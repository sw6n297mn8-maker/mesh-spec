#!/usr/bin/env python3
"""Testes do gate de frescura de materialização (adr-168).

Fixture = o INCIDENTE REAL desta sessão (WI-147 fce async-api colidindo com o
WI-147/WI-148 que origin/main ganhou entre a proposta e a escrita; resolvido
para WI-149). Reproduzido deterministicamente:

- G1: branch parte de um main antigo; origin/main avança → o gate nomeia os
  commits novos e reprova (exit 1).
- G2: --assert WI=147 sobre o tip avançado → STOP renumeração (147 tomado;
  próximo-livre é 149) (exit 1).
- pós-rebase: --assert WI=149 → gate ok (exit 0).
- --ci: a branch adiciona wi-147.cue que já vive na base → colisão add/add
  detectada antes do merge-surpresa (exit 1).

Rodar: python3 -m unittest discover -s scripts/ci/tests  (da raiz do repo)
Fixtures git efêmeras em tempdir (bare remote + clone); só stdlib.
"""

import os
import shutil
import subprocess
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
SCRIPT = os.path.join(REPO_ROOT, "scripts", "ci", "materialization-freshness.sh")

_ENV = {
    "GIT_AUTHOR_NAME": "t", "GIT_AUTHOR_EMAIL": "t@t",
    "GIT_COMMITTER_NAME": "t", "GIT_COMMITTER_EMAIL": "t@t",
}


def _git(cwd, *args):
    env = dict(os.environ); env.update(_ENV)
    return subprocess.run(["git", *args], cwd=cwd, env=env, check=True,
                          capture_output=True, text=True)


def _write(root, rel, content="x\n"):
    path = os.path.join(root, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(content)


def _wi(num):
    """Path + conteúdo mínimo de um task-spec wi-NNN."""
    return (f"governance/build-time/task-specs/wi-{num}.cue",
            f'taskSpecs: "WI-{num}": {{ version: 1 }}\n')


class FreshnessGateTest(unittest.TestCase):

    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix="freshness-test-")
        self.addCleanup(shutil.rmtree, self.tmp)
        self.remote = os.path.join(self.tmp, "remote.git")
        self.work = os.path.join(self.tmp, "work")
        _git(self.tmp, "init", "--bare", "-q", self.remote)
        _git(self.tmp, "clone", "-q", self.remote, self.work)
        _git(self.work, "config", "user.name", "t")
        _git(self.work, "config", "user.email", "t@t")
        # main inicial: consumido até WI-146 (próximo-livre = 147)
        rel, content = _wi(146)
        _write(self.work, rel, content)
        _git(self.work, "add", "-A")
        _git(self.work, "commit", "-q", "-m", "seed wi-146")
        _git(self.work, "branch", "-M", "main")
        _git(self.work, "push", "-q", "origin", "main")

    def _run(self, *args, cwd=None):
        env = dict(os.environ); env.update(_ENV)
        return subprocess.run(["bash", SCRIPT, *args], cwd=cwd or self.work,
                              env=env, capture_output=True, text=True)

    def _advance_main(self, nums):
        """Simula outra sessão consumindo números em origin/main (novos commits)."""
        for n in nums:
            rel, content = _wi(n)
            _write(self.work, rel, content)
            _git(self.work, "add", "-A")
            _git(self.work, "commit", "-q", "-m", f"other session: wi-{n}")
        _git(self.work, "push", "-q", "origin", "main")

    def _branch_proposes(self, num, base="origin/main"):
        """Cria feature branch a partir de `base` e adiciona wi-<num> (proposta)."""
        _git(self.work, "checkout", "-q", "-B", "feature", base)
        rel, content = _wi(num)
        _write(self.work, rel, content)
        _git(self.work, "add", "-A")
        _git(self.work, "commit", "-q", "-m", f"propose wi-{num}")

    # ── Cenário do incidente ──

    def test_g1_stale_branch_names_new_commits(self):
        # branch parte do main@146-era; propõe wi-147 (correto ENTÃO)
        self._branch_proposes(147)
        # origin/main avança com wi-147 + wi-148 (outra sessão)
        _git(self.work, "checkout", "-q", "main")
        self._advance_main([147, 148])
        _git(self.work, "checkout", "-q", "feature")
        # G1 deve reprovar nomeando os commits novos
        r = self._run("--assert", "WI=147")
        self.assertEqual(r.returncode, 1, r.stderr)
        self.assertIn("G1", r.stderr)
        self.assertIn("other session: wi-148", r.stderr)  # commit nomeado

    def test_g2_collision_on_taken_number(self):
        self._branch_proposes(147)
        _git(self.work, "checkout", "-q", "main")
        self._advance_main([147, 148])
        _git(self.work, "checkout", "-q", "feature")
        # G2: 147 foi tomado; próximo-livre é 149
        r = self._run("--assert", "WI=147")
        self.assertEqual(r.returncode, 1, r.stderr)
        self.assertIn("STOP renumeração", r.stderr)
        self.assertIn("149", r.stderr)

    def test_exit0_after_rebase_with_renumber(self):
        self._branch_proposes(147)
        _git(self.work, "checkout", "-q", "main")
        self._advance_main([147, 148])
        _git(self.work, "checkout", "-q", "feature")
        # rebase no tip + renumera a proposta para 149
        _git(self.work, "rebase", "origin/main", "-X", "theirs")
        r = self._run("--assert", "WI=149")
        self.assertEqual(r.returncode, 0, r.stderr + r.stdout)
        self.assertIn("gate ok", r.stdout)
        self.assertIn("WI-149", r.stdout)

    def test_ci_detects_add_add_collision(self):
        # branch adiciona wi-147 enquanto origin/main já tem wi-147
        self._branch_proposes(147)
        _git(self.work, "checkout", "-q", "main")
        self._advance_main([147, 148])
        _git(self.work, "checkout", "-q", "feature")
        r = self._run("--ci")
        self.assertEqual(r.returncode, 1, r.stderr)
        self.assertIn("colisão add/add", r.stderr)
        self.assertIn("wi-147", r.stderr)

    def test_ci_clean_when_number_fresh(self):
        # branch adiciona wi-149 (livre) sobre o tip → --ci limpo
        _git(self.work, "checkout", "-q", "main")
        self._advance_main([147, 148])
        self._branch_proposes(149, base="origin/main")
        r = self._run("--ci")
        self.assertEqual(r.returncode, 0, r.stderr + r.stdout)

    def test_echo_reports_state(self):
        r = self._run("--echo")
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("WI-146", r.stdout)   # último consumido no seed
        self.assertIn("main @", r.stdout)

    def test_gate_ok_on_fresh_branch(self):
        # branch parte do tip corrente; propõe o próximo-livre (147) → ok
        self._branch_proposes(147, base="origin/main")
        r = self._run("--assert", "WI=147")
        self.assertEqual(r.returncode, 0, r.stderr + r.stdout)
        self.assertIn("gate ok", r.stdout)


if __name__ == "__main__":
    unittest.main()
