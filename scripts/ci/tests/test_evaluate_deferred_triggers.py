#!/usr/bin/env python3
"""Testes do core do runner de deferred-triggers (adr-166).

Cobertura:
- Exclusões de engine por construção (self-match morto) — adr-166 item 1
- pathScope em recurrence file-content + âncora em filename — item 2
- structural-predicate: happy paths, malformação falha ALTO — itens 2-3
- Gate multi-trigger: cenário 6.3 reproduzido (trigger[0] warn-only disparado
  + trigger[1] gateável além da carência → AMBOS avaliados) — item 4
- Discovery dual-source (regressão)
- Calibração congelada dos 4 predicados reais contra o repo (tripwire
  deliberado — quebra = recalibrar conscientemente, decisão do founder
  2026-07-03)

Rodar: python3 -m unittest discover -s scripts/ci/tests  (da raiz do repo)
Fixtures git efêmeras em tempdir; sem dependências fora da stdlib (+ cue
binário apenas para os testes de calibração, garantido no job cue-validate).
"""

import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from datetime import date

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import evaluate_deferred_triggers as edt  # noqa: E402

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
TODAY = date(2026, 7, 3)


def _git(cwd, *args, env_extra=None):
    env = dict(os.environ)
    env.update({
        "GIT_AUTHOR_NAME": "t", "GIT_AUTHOR_EMAIL": "t@t",
        "GIT_COMMITTER_NAME": "t", "GIT_COMMITTER_EMAIL": "t@t",
    })
    if env_extra:
        env.update(env_extra)
    subprocess.run(["git", *args], cwd=cwd, env=env, check=True,
                   capture_output=True, text=True)


def _write(root, rel, content="x\n"):
    path = os.path.join(root, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(content)


class FixtureRepoTest(unittest.TestCase):
    """Base: repo git efêmero como cwd (os avaliadores usam git no cwd)."""

    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix="dd-runner-test-")
        self.addCleanup(shutil.rmtree, self.tmp)
        self._old_cwd = os.getcwd()
        self.addCleanup(os.chdir, self._old_cwd)
        _git(self.tmp, "init", "-q")
        os.chdir(self.tmp)

    def commit_all(self, backdate=None):
        _git(self.tmp, "add", "-A")
        env_extra = None
        if backdate:
            env_extra = {"GIT_AUTHOR_DATE": backdate, "GIT_COMMITTER_DATE": backdate}
        _git(self.tmp, "commit", "-q", "-m", "fixture", env_extra=env_extra)


class TestEngineExclusions(FixtureRepoTest):
    """adr-166 item 1: def/self-reviews/_* nunca contam — self-match morto."""

    def test_file_content_excludes_self_dirs_and_underscore(self):
        _write(self.tmp, "contexts/foo/canvas.cue", "needle here\n")
        _write(self.tmp, "architecture/deferred-decisions/def-999-x.cue", "needle here\n")
        _write(self.tmp, "governance/build-time/self-reviews/x.self-review.cue", "needle here\n")
        _write(self.tmp, "contexts/foo/_meta.cue", "needle here\n")
        self.commit_all()
        ok, msg = edt.evaluate_recurrence(
            {"kind": "recurrence", "scope": "file-content", "pattern": "needle",
             "threshold": 2})
        self.assertFalse(ok, msg)
        self.assertIn("count 1 <", msg)

    def test_filename_excludes_underscore_and_self_dirs(self):
        _write(self.tmp, "architecture/conventions/_meta.cue")
        _write(self.tmp, "architecture/conventions/api-spec-convention.cue")
        _write(self.tmp, "architecture/deferred-decisions/def-010-conventions.cue")
        self.commit_all()
        # Reprodução do caso def-010 (#196): pattern amplo contava _meta.cue.
        ok, msg = edt.evaluate_recurrence(
            {"kind": "recurrence", "scope": "filename",
             "pattern": "^architecture/conventions/", "threshold": 2})
        self.assertFalse(ok, msg)
        self.assertIn("count 1 <", msg)


class TestPathScope(FixtureRepoTest):
    """adr-166 item 2: pathScope restringe ONDE file-content conta."""

    def test_pathscope_filters_out_of_scope_matches(self):
        _write(self.tmp, "contexts/a/canvas.cue", "needle\n")
        _write(self.tmp, "contexts/b/canvas.cue", "needle\n")
        _write(self.tmp, "architecture/adrs/adr-001-x.cue", "prosa sobre needle\n")
        self.commit_all()
        ok, msg = edt.evaluate_recurrence(
            {"kind": "recurrence", "scope": "file-content", "pattern": "needle",
             "pathScope": "^contexts/", "threshold": 2})
        self.assertTrue(ok, msg)
        self.assertIn("found 2 >=", msg)
        ok3, msg3 = edt.evaluate_recurrence(
            {"kind": "recurrence", "scope": "file-content", "pattern": "needle",
             "pathScope": "^contexts/", "threshold": 3})
        self.assertFalse(ok3, msg3)


class TestGateMultiTrigger(FixtureRepoTest):
    """Condição 1 do founder: reprodução do cenário 6.3 — trigger[0] warn-only
    disparado NÃO esconde trigger[1] gateável além da carência; AMBOS avaliados."""

    def test_gateable_second_trigger_blocks_despite_warnonly_first(self):
        _write(self.tmp, "docs/x.cue", "needle\n")
        _write(self.tmp, "architecture/structural-checks/adr.cue", "check\n")
        # arquivo gateável ADICIONADO há 30d (> carência de 7d) — git-derivado
        self.commit_all(backdate="2026-06-03T12:00:00")
        defs = {"def-901": {
            "id": "def-901", "title": "cenário 6.3", "status": "open",
            "date": "2026-05-01",
            "triggers": [
                # [0] recurrence disparado — warn-only (não-gateável no V1)
                {"kind": "recurrence", "scope": "file-content",
                 "pattern": "needle", "pathScope": "^docs/", "threshold": 1},
                # [1] file-exists disparado há 30d — gateável, além da carência
                {"kind": "adjacent-need", "condition": {
                    "kind": "file-exists",
                    "path": "architecture/structural-checks/adr.cue"}},
            ],
        }}
        count, _lines, gate_blocking, exit_code = edt.evaluate_all(
            defs, today=TODAY, gate_enabled=True)
        self.assertEqual(count, 1)
        self.assertEqual(len(gate_blocking), 1, "trigger gateável ficou escondido atrás do warn-only (bug 6.3)")
        self.assertEqual(gate_blocking[0][0], "def-901")
        self.assertGreater(gate_blocking[0][2], 7)
        self.assertEqual(exit_code, 1)

    def test_gate_off_stays_advisory(self):
        _write(self.tmp, "architecture/structural-checks/adr.cue", "check\n")
        self.commit_all(backdate="2026-06-03T12:00:00")
        defs = {"def-902": {
            "id": "def-902", "title": "advisory", "status": "open",
            "date": "2026-05-01",
            "triggers": [{"kind": "adjacent-need", "condition": {
                "kind": "file-exists",
                "path": "architecture/structural-checks/adr.cue"}}],
        }}
        _c, _l, gate_blocking, exit_code = edt.evaluate_all(
            defs, today=TODAY, gate_enabled=False)
        self.assertEqual(len(gate_blocking), 1)
        self.assertEqual(exit_code, 0)


class TestStructuralPredicate(unittest.TestCase):
    """adr-166 itens 2-3: predicados nomeados; malformação falha ALTO."""

    PREDICATES = {
        "ddp-101": {"id": "ddp-101", "package": "./p/", "expr": "e1",
                    "comparator": ">=", "threshold": 3,
                    "rationale": "teste count"},
        "ddp-102": {"id": "ddp-102", "package": "./p/", "expr": "e2",
                    "comparator": "==true", "rationale": "teste bool"},
    }

    def test_count_comparator_fires_at_threshold(self):
        ok, msg = edt.evaluate_structural_predicate(
            {"kind": "structural-predicate", "predicate": "ddp-101"},
            self.PREDICATES, exporter=lambda p, e: 3)
        self.assertTrue(ok, msg)
        ok2, msg2 = edt.evaluate_structural_predicate(
            {"kind": "structural-predicate", "predicate": "ddp-101"},
            self.PREDICATES, exporter=lambda p, e: 2)
        self.assertFalse(ok2, msg2)

    def test_bool_comparator(self):
        ok, _ = edt.evaluate_structural_predicate(
            {"kind": "structural-predicate", "predicate": "ddp-102"},
            self.PREDICATES, exporter=lambda p, e: True)
        self.assertTrue(ok)
        ok2, _ = edt.evaluate_structural_predicate(
            {"kind": "structural-predicate", "predicate": "ddp-102"},
            self.PREDICATES, exporter=lambda p, e: False)
        self.assertFalse(ok2)

    def test_unknown_predicate_id_fails_loud(self):
        with self.assertRaises(edt.MalformedTriggerError):
            edt.evaluate_structural_predicate(
                {"kind": "structural-predicate", "predicate": "ddp-999"},
                self.PREDICATES, exporter=lambda p, e: 0)

    def test_wrong_value_type_fails_loud(self):
        with self.assertRaises(edt.MalformedTriggerError):
            edt.evaluate_structural_predicate(
                {"kind": "structural-predicate", "predicate": "ddp-101"},
                self.PREDICATES, exporter=lambda p, e: True)  # bool p/ '>='
        with self.assertRaises(edt.MalformedTriggerError):
            edt.evaluate_structural_predicate(
                {"kind": "structural-predicate", "predicate": "ddp-102"},
                self.PREDICATES, exporter=lambda p, e: 1)  # número p/ '==true'

    def test_evaluate_all_propagates_malformation_as_exit_1(self):
        defs = {"def-903": {
            "id": "def-903", "title": "malformado", "status": "open",
            "date": "2026-07-01",
            "triggers": [{"kind": "structural-predicate", "predicate": "ddp-999"}],
        }}
        with self.assertRaises(edt.MalformedTriggerError):
            edt.evaluate_all(defs, today=TODAY,
                             predicates_loader=lambda: self.PREDICATES)


class TestDiscovery(unittest.TestCase):
    """Regressão da discovery dual-source (contrato pré-existente preservado)."""

    def test_dual_source_rekeyed_by_canonical_id(self):
        data = {
            "deferredDecisions": {
                "def-001": {"id": "def-001", "triggers": []},
                "def-015-slug": {"id": "def-015", "triggers": []},
            },
            "def018": {"id": "def-018", "triggers": []},
            "meta": {"id": "not-a-def"},
            "other": {"id": "def-99", "triggers": []},  # id fora do shape → ignora
        }
        defs = edt.discover_defs(data)
        self.assertEqual(sorted(defs.keys()), ["def-001", "def-015", "def-018"])


@unittest.skipUnless(shutil.which("cue"), "cue binário ausente (job cue-validate instala)")
class TestFrozenPredicateCalibration(unittest.TestCase):
    """Condição 2 do founder: os 4 valores validados no pre-flight/escrita
    congelados como asserts. Quebra deste teste = o repo evoluiu sob o sensor
    OU o predicado drifou — recalibrar CONSCIENTEMENTE (nunca silenciar).
    Roda contra o repo real (cwd = raiz)."""

    def setUp(self):
        self._old_cwd = os.getcwd()
        self.addCleanup(os.chdir, self._old_cwd)
        os.chdir(REPO_ROOT)
        self.predicates = edt.load_predicates()

    def _value(self, pid):
        pred = self.predicates[pid]
        return edt.cue_export_expr(pred["package"], pred["expr"])

    def test_registry_has_exactly_the_four_founding_predicates(self):
        self.assertEqual(sorted(self.predicates.keys()),
                         ["ddp-001", "ddp-002", "ddp-003", "ddp-004"])

    def test_ddp_001_transient_exceptions_count_frozen_21(self):
        # Recalibração CONSCIENTE 24→21 (2026-07-03, fatia def-012 PR-A):
        # quitação das 3 entries stale com SRR matching per exitCondition
        # declarado (PG structural-check, canvas CMT, glossary CMT).
        # Tripwire do adr-166 (N2) funcionando como desenhado.
        self.assertEqual(self._value("ddp-001"), 21)  # ≥20 → def-012 segue disparado (honesto)

    def test_ddp_002_declared_flows_frozen_1(self):
        self.assertEqual(self._value("ddp-002"), 1)  # <2 → def-031 não dispara

    def test_ddp_003_fcc_status_frozen_false(self):
        self.assertIs(self._value("ddp-003"), False)  # proposed → def-064 não dispara

    def test_ddp_004_design_principle_coverage_frozen_0(self):
        self.assertEqual(self._value("ddp-004"), 0)  # ausente → def-030 não dispara


if __name__ == "__main__":
    unittest.main()
