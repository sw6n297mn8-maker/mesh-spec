#!/usr/bin/env python3
"""Testes de fixture das Regras A+B do check-self-review.sh (adr-167).

Cobertura (per decisão do founder, fatia def-012 PR-B):
- Regra A dispara nomeando a entry stale ("exceção stale: quitar <path>")
- Regra A limpa (transient sem SRR matching → 0 stale)
- Regra B exige SRR em artefato isento modificado (SEM SKIP)
- Regra B satisfeita por existência (permanent com SRR passa; A não olha
  permanent — escopo B=todas / A=transient-only)
- Ciclo completo num único PR: modificação + SRR + entry removida → verde
  (a mecânica que a falsificationCondition do adr-167 declara)

Fixtures: repo git BASE em tempdir (policy + self-reviews + artefatos
governados, committados) clonado para WORK (origin/main resolve); o script
REAL do repo roda com cwd no clone. Requer cue (Step 0 do script) — o step
de CI roda após Install CUE no job cue-validate.
"""

import os
import shutil
import subprocess
import unittest
import tempfile

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
CHECK_SCRIPT = os.path.join(REPO_ROOT, "scripts", "ci", "check-self-review.sh")

POLICY_PATH = "governance/build-time/self-review-bootstrap-policy.cue"
SRR_DIR = "governance/build-time/self-reviews"

GIT_ENV = {
    "GIT_AUTHOR_NAME": "t", "GIT_AUTHOR_EMAIL": "t@t",
    "GIT_COMMITTER_NAME": "t", "GIT_COMMITTER_EMAIL": "t@t",
}


def _git(cwd, *args):
    env = dict(os.environ)
    env.update(GIT_ENV)
    subprocess.run(["git", *args], cwd=cwd, env=env, check=True,
                   capture_output=True, text=True)


def _write(root, rel, content):
    path = os.path.join(root, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(content)


def policy_cue(entries):
    blocks = []
    for path, lifecycle in entries:
        category = ("pre-mapping-transient" if lifecycle == "transient"
                    else "inaugural-circularity")
        blocks.append(
            '\t\t{\n'
            f'\t\t\tartifactPath: "{path}"\n'
            f'\t\t\tcategory:     "{category}"\n'
            f'\t\t\tlifecycle:    "{lifecycle}"\n'
            '\t\t\trationale:    "fixture"\n'
            '\t\t},'
        )
    return (
        "package build_time\n\n"
        "selfReviewBootstrapPolicy: {\n"
        '\tmode: "bootstrap-exception"\n'
        "\texceptions: [\n" + "\n".join(blocks) + "\n\t]\n"
        '\trationale: "fixture"\n'
        "}\n"
    )


def srr_cue(name, artifact_path, artifact_type):
    return (
        "package self_reviews\n\n"
        f'"{name}": {{\n'
        f'\treportId:       "srr-{name}"\n'
        f'\tartifactPath:   "{artifact_path}"\n'
        f'\tartifactType:   "{artifact_type}"\n'
        "\troundsExecuted: 1\n"
        "\troundDetails: [{round: 1}]\n"
        "}\n"
    )


@unittest.skipUnless(shutil.which("cue"), "cue binário ausente (job cue-validate instala)")
class CheckSelfReviewRulesTest(unittest.TestCase):
    """Cada teste constrói base+clone próprios e roda o script real."""

    def build_fixture(self, policy_entries, srrs, artifacts):
        base = tempfile.mkdtemp(prefix="csr-base-")
        self.addCleanup(shutil.rmtree, base, ignore_errors=True)
        _git(base, "init", "-q", "-b", "main")
        _write(base, "cue.mod/module.cue",
               'module: "fixture.test/csr"\nlanguage: version: "v0.16.0"\n')
        _write(base, POLICY_PATH, policy_cue(policy_entries))
        for name, apath, atype in srrs:
            _write(base, f"{SRR_DIR}/{name}.self-review.cue", srr_cue(name, apath, atype))
        if not srrs:
            # dir precisa existir para o glob da Regra A não variar o cenário
            os.makedirs(os.path.join(base, SRR_DIR), exist_ok=True)
            _write(base, f"{SRR_DIR}/.gitkeep", "")
        for rel, content in artifacts:
            _write(base, rel, content)
        _git(base, "add", "-A")
        _git(base, "commit", "-q", "-m", "fixture base")

        work = tempfile.mkdtemp(prefix="csr-work-")
        self.addCleanup(shutil.rmtree, work, ignore_errors=True)
        # clone dá origin/main (o script diffa origin/main...HEAD)
        subprocess.run(["git", "clone", "-q", base, work + "/repo"],
                       check=True, capture_output=True)
        return os.path.join(work, "repo")

    def run_check(self, repo):
        return subprocess.run(["bash", CHECK_SCRIPT], cwd=repo,
                              capture_output=True, text=True)

    def test_regra_a_dispara_nomeando_entry_stale(self):
        repo = self.build_fixture(
            policy_entries=[("contexts/foo/canvas.cue", "transient")],
            srrs=[("foo-canvas", "contexts/foo/canvas.cue", "canvas")],
            artifacts=[("contexts/foo/canvas.cue", "canvas: true\n")],
        )
        r = self.run_check(repo)
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("exceção stale: quitar contexts/foo/canvas.cue", r.stdout)
        self.assertIn("FAILED", r.stdout)

    def test_regra_a_limpa_sem_srr_matching(self):
        repo = self.build_fixture(
            policy_entries=[("contexts/foo/canvas.cue", "transient")],
            srrs=[("other", "contexts/bar/canvas.cue", "canvas")],
            artifacts=[("contexts/foo/canvas.cue", "canvas: true\n"),
                       ("contexts/bar/canvas.cue", "canvas: true\n")],
        )
        r = self.run_check(repo)
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("1 transient entries, 0 stale", r.stdout)

    def test_regra_b_exige_srr_em_isento_modificado(self):
        repo = self.build_fixture(
            policy_entries=[("contexts/foo/canvas.cue", "transient")],
            srrs=[],
            artifacts=[("contexts/foo/canvas.cue", "canvas: true\n")],
        )
        # "próxima modificação" do artefato isento — worktree change
        with open(os.path.join(repo, "contexts/foo/canvas.cue"), "a") as f:
            f.write("// modificado\n")
        r = self.run_check(repo)
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("CHECK: contexts/foo/canvas.cue (canvas)", r.stdout)
        self.assertIn("missing self-review report", r.stdout)
        self.assertNotIn("SKIP (bootstrap-exempt)", r.stdout)

    def test_regra_b_satisfeita_por_existencia_e_a_ignora_permanent(self):
        repo = self.build_fixture(
            policy_entries=[("architecture/adrs/adr-001-perm.cue", "permanent")],
            srrs=[("adr-001-perm", "architecture/adrs/adr-001-perm.cue", "adr")],
            artifacts=[("architecture/adrs/adr-001-perm.cue", "adr: true\n")],
        )
        with open(os.path.join(repo, "architecture/adrs/adr-001-perm.cue"), "a") as f:
            f.write("// modificado\n")
        r = self.run_check(repo)
        # permanent com SRR: B acha o report (sem SKIP); A não olha permanent
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("CHECK: architecture/adrs/adr-001-perm.cue (adr)", r.stdout)
        self.assertIn("0 stale", r.stdout)
        self.assertNotIn("SKIP (bootstrap-exempt)", r.stdout)

    def test_ciclo_completo_num_unico_pr(self):
        repo = self.build_fixture(
            policy_entries=[("contexts/foo/canvas.cue", "transient"),
                            ("contexts/baz/canvas.cue", "transient")],
            srrs=[],
            artifacts=[("contexts/foo/canvas.cue", "canvas: true\n"),
                       ("contexts/baz/canvas.cue", "canvas: true\n")],
        )
        # O PR único: modifica o artefato + autora o SRR + quita a entry.
        with open(os.path.join(repo, "contexts/foo/canvas.cue"), "a") as f:
            f.write("// modificado\n")
        _write(repo, f"{SRR_DIR}/foo-canvas.self-review.cue",
               srr_cue("foo-canvas", "contexts/foo/canvas.cue", "canvas"))
        _write(repo, POLICY_PATH,
               policy_cue([("contexts/baz/canvas.cue", "transient")]))
        r = self.run_check(repo)
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("CHECK: contexts/foo/canvas.cue (canvas)", r.stdout)
        self.assertIn("1 transient entries, 0 stale", r.stdout)
        self.assertIn("PASSED", r.stdout)


if __name__ == "__main__":
    unittest.main()
