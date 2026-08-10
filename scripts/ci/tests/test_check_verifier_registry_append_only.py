#!/usr/bin/env python3
"""Suite adversarial do dente APPEND-ONLY do Verifier Registry (adr-189, CI-1).

Falsifica EXCLUSIVAMENTE check-verifier-registry-append-only.sh: a história de
verifierRegistry.events da BASE (origin/main) deve ser prefixo EXATO da do
CANDIDATO (working tree). NÃO cobre:
  - validade causal/estrutural interna do stream (invariantes R/U + projeção) —
    isso é responsabilidade de `cue vet` sobre `#VerifierRegistry`;
  - restrição pós-revogação — isso é o gate terminal-quiescence.
Suites separadas por dente (decisão do founder): quebrar um dente deixa só a
sua suite vermelha.

Propriedade preservada: cada CANDIDATO permanece um #VerifierRegistry
semanticamente VÁLIDO. Se um candidato fosse inválido, `cue export` falharia e o
gate sairia 2 (infra) — mascarando a semântica do append-only. Por isso a base
usa >=3 eventos onde truncar/reordenar precisa manter validade (grant-coverage).

Fixture self-contained (sem framework compartilhado até haver 2 consumidores
reais): módulo CUE mínimo (cue.mod + cópia do verifier-types.cue adotado +
verifier-registry.cue instanciado), repo BASE committado, clone WORK onde
origin/main resolve; o candidato é uma mudança do working tree do clone.
"""

import os
import shutil
import subprocess
import unittest
import tempfile

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
CHECK_SCRIPT = os.path.join(REPO_ROOT, "scripts", "ci", "check-verifier-registry-append-only.sh")
SCHEMA_SRC = os.path.join(REPO_ROOT, "architecture", "artifact-schemas", "verifier-types.cue")

REGISTRY_REL = "governance/build-time/verifier-registry.cue"
SCHEMA_REL = "architecture/artifact-schemas/verifier-types.cue"
MODULE = "fixture.test/vr"

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
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)


# ── construtores de evento (literais CUE) ──

def register(vid, v, asch, rev="abc1234"):
    return (
        '{event: "verifier-registered", contract: {ref: {id: "%s", version: %d, '
        'revision: "%s"}, assertionSchemaRef: "%s", evidenceIntegrity: '
        '"reproducible", resultSemantics: "bool", readOnly: true, rationale: "r"}, '
        'rationale: "r"}' % (vid, v, rev, asch)
    )


def grant(vid, v, asch, rationale="r"):
    return (
        '{event: "verifier-granted", verifierRef: {id: "%s", version: %d}, '
        'assertionSchemaRef: "%s", rationale: "%s"}' % (vid, v, asch, rationale)
    )


def deprecate(vid, v):
    return ('{event: "verifier-deprecated", verifierRef: {id: "%s", version: %d}, '
            'rationale: "r"}' % (vid, v))


def registry_cue(event_literals, *, header_comment="", reformat=False):
    """Instância verifier-registry.cue do módulo-fixture com os eventos dados.

    reformat=True escreve os MESMOS eventos com texto materialmente diferente
    (comentário + whitespace + reordenação de campos onde CUE permite) — prova
    que o gate compara JSON semântico, não bytes.
    """
    if reformat:
        # eventos reordenados campo-a-campo + comentários + indentação diferente
        body = ",\n".join("      // evento reformatado\n      " + e for e in event_literals)
        return (
            "package build_time\n\n"
            '// %sheader materialmente reformatado para o teste de deep-equality\n\n'
            'import as "%s/architecture/artifact-schemas:artifact_schemas"\n\n'
            "verifierRegistry: as.#VerifierRegistry & {\n"
            "    events: [\n%s,\n    ]\n}\n" % (header_comment, MODULE, body)
        )
    body = ",\n\t\t".join(event_literals)
    return (
        "package build_time\n\n"
        'import "%s/architecture/artifact-schemas:artifact_schemas"\n\n'
        "verifierRegistry: artifact_schemas.#VerifierRegistry & {\n"
        "\tevents: [\n\t\t%s,\n\t]\n}\n" % (MODULE, body)
    )


@unittest.skipUnless(shutil.which("cue"), "cue binário ausente (job cue-validate instala)")
class AppendOnlyGateTest(unittest.TestCase):
    """Cada teste constrói base+clone próprios e roda o gate real."""

    def build(self, base_events, candidate_text):
        with open(SCHEMA_SRC, encoding="utf-8") as f:
            schema = f.read()

        base = tempfile.mkdtemp(prefix="vrao-base-")
        self.addCleanup(shutil.rmtree, base, ignore_errors=True)
        _git(base, "init", "-q", "-b", "main")
        _write(base, "cue.mod/module.cue",
               'module: "%s"\nlanguage: version: "v0.16.0"\n' % MODULE)
        _write(base, SCHEMA_REL, schema)
        _write(base, REGISTRY_REL, registry_cue(base_events))
        _git(base, "add", "-A")
        _git(base, "commit", "-q", "-m", "fixture base")

        work = tempfile.mkdtemp(prefix="vrao-work-")
        self.addCleanup(shutil.rmtree, work, ignore_errors=True)
        subprocess.run(["git", "clone", "-q", base, work + "/repo"],
                       check=True, capture_output=True)
        repo = os.path.join(work, "repo")
        # candidato = mudança do working tree (uncommitted; o gate lê via cue export)
        _write(repo, REGISTRY_REL, candidate_text)
        return repo

    def run_check(self, repo):
        return subprocess.run(["bash", CHECK_SCRIPT], cwd=repo,
                              capture_output=True, text=True)

    def assert_no_infra(self, r):
        # protege contra "passar pelo motivo errado": nenhuma violação pode ser
        # na verdade um erro de infra/export (fetch/worktree/export → exit 2).
        combined = r.stdout + r.stderr
        self.assertEqual(r.returncode, 1, combined)
        for marker in ("falhou", "worktree", "não trato como", "git fetch"):
            self.assertNotIn(marker, combined,
                             f"violação contaminada por diagnóstico de infra: {marker!r}\n{combined}")

    # ── 1. append válido → 0 ──
    def test_append_valido_passa(self):
        base = [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x")]
        cand = registry_cue(base + [deprecate("vrf-x", 1)])
        r = self.run_check(self.build(base, cand))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("append-only ok", r.stdout)

    # ── 2. rewrite semântico → 1, primeiro índice divergente ──
    def test_rewrite_semantico_falha(self):
        base = [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x")]
        # idx 1 reescrito: mesmo grant válido, rationale diferente → diverge
        cand = registry_cue([base[0], grant("vrf-x", 1, "asch-x", rationale="alterado"),
                             deprecate("vrf-x", 1)])
        r = self.run_check(self.build(base, cand))
        self.assert_no_infra(r)
        self.assertIn("evento[1] diverge", r.stderr)

    # ── 3. truncamento válido → 1 ──
    def test_truncamento_falha(self):
        base = [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x"),
                deprecate("vrf-x", 1)]
        cand = registry_cue([base[0], base[1]])  # solta o deprecate; ainda válido
        r = self.run_check(self.build(base, cand))
        self.assert_no_infra(r)
        self.assertIn("encurtada", r.stderr)

    # ── 4. reorder ainda semanticamente válido → 1 ──
    def test_reorder_falha(self):
        base = [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x"),
                deprecate("vrf-x", 1)]
        # troca idx 1 e 2: [reg, deprecate, grant] — deprecated não-revogado tem grant
        cand = registry_cue([base[0], base[2], base[1]])
        r = self.run_check(self.build(base, cand))
        self.assert_no_infra(r)
        self.assertIn("evento[1] diverge", r.stderr)

    # ── 5. reformat sem mudança semântica → 0 ──
    def test_reformat_sem_mudanca_semantica_passa(self):
        base = [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x")]
        cand = registry_cue(base, header_comment="X ", reformat=True)
        r = self.run_check(self.build(base, cand))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("append-only ok", r.stdout)


if __name__ == "__main__":
    unittest.main()
