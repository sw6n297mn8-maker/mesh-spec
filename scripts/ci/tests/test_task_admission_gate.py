#!/usr/bin/env python3
"""AdmissionGate do contrato V2 (adr-192, C3b): born-reject de #TaskAdmissionV2
sob `cue vet -c`.

Duas relacoes: (1) mandatoryVerifiers(template) ⊆ requiredEvidence(task);
(2) todo verifierRef declarado resolve pela MESMA #VerifierResolution da
completion (adr-191) — nenhuma logica de resolvability copiada.

Fixtures vivem SO aqui (mesma decisao de C2): nada em governance/build-time/.
Isolamento identico ao ContractGate: arvore copiada para tmp; fixtures na copia.
"""

import os
import shutil
import subprocess
import unittest
import tempfile

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
FX_DIR = "admission-gate-fx"

PRELUDE = """package admission_gate_fx

import (
\tbt "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"
\tas "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
)

_asch: "asch-cue-vet"
_good: as.#VerifierRef & {id: "vrf-cue-vet-c", version: 1, revision: "a1b2c3d"}
_ver:  {id: _good.id, version: _good.version}
_contract: as.#VerifierContract & {
\tref: _good, assertionSchemaRef: _asch, evidenceIntegrity: "reproducible"
\tresultSemantics: "exit 0 == verified", readOnly: true, rationale: "f"
}
_reg: as.#VerifierRegistry & {events: [
\t{event: "verifier-registered", contract: _contract, rationale: "f"},
\t{event: "verifier-granted", verifierRef: _ver, assertionSchemaRef: _asch, rationale: "f"},
]}

// template-fixture minimo valido; mandatoryVerifiers entra por caso.
_mkTemplate: {
\tmv: _
\tout: as.#TaskTemplate & {
\t\tid: "tmpl-fixture", version: 1, kind: "validate-artifact"
\t\ttitle: "f", applicability: "f", rationale: "f"
\t\tpreReads: [{target: "x.cue", targetType: "path", rationale: "f"}]
\t\tsteps: [{action: "Verificar x", rationale: "f"}]
\t\tqualityGates: [{gate: "cue vet", rationale: "f"}]
\t\tif mv != _|_ {mandatoryVerifiers: mv}
\t}
}

_mkTask: {
\tr: _
\ttref: string | *"tmpl-fixture@v1"
\tout: bt.#TaskSpecV2 & {
\t\tspecVersion: "v2", id: "WI-192", version: 1, title: "f"
\t\ttemplateRef: tref
\t\tsemanticPrerequisites: ["n"], outputs: [{artifact: "x.cue", type: "create"}], affects: ["x"]
\t\tif r != _|_ {requiredEvidence: [{id: "req-1", verifierRef: r, assertionPayload: {}, rationale: "f"}]}
\t\tif r == _|_ {requiredEvidence: [{id: "req-1", verifierRef: _good, assertionPayload: {}, rationale: "f"}]}
\t\trationale: "f"
\t}
}
"""


def case(body):
    return PRELUDE + "\n" + body


class TaskAdmissionGateTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = tempfile.mkdtemp(prefix="admission-gate-")
        subprocess.run(
            ["bash", "-c", f"tar -C {REPO_ROOT} --exclude=./.git -cf - . | tar -C {cls.root} -xf -"],
            check=True)
        os.makedirs(os.path.join(cls.root, FX_DIR), exist_ok=True)

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.root, ignore_errors=True)

    def vet(self, content):
        path = os.path.join(self.root, FX_DIR, "fx.cue")
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        try:
            return subprocess.run(["cue", "vet", "-c", f"./{FX_DIR}/"], cwd=self.root,
                                  capture_output=True, text=True)
        finally:
            os.remove(path)

    # ── POSITIVO: task conforme (cobre X, revision registrada) → admite ──
    def test_task_conforme_admite(self):
        r = self.vet(case("""
_t: (_mkTemplate & {mv: [{verifierId: "vrf-cue-vet-c", rationale: "f"}]}).out
_k: (_mkTask & {r: _good}).out
ok: bt.#TaskAdmissionV2 & {task: _k, template: _t, registry: _reg}
"""))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    # ── COMPAT: template SEM mandatoryVerifiers (as 5 instâncias atuais) ──
    def test_template_sem_mandatory_verifiers_admite(self):
        r = self.vet(case("""
_t: (_mkTemplate & {mv: _|_}).out
_k: (_mkTask & {r: _good}).out
ok: bt.#TaskAdmissionV2 & {task: _k, template: _t, registry: _reg}
"""))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    # ── (1) template exige X; task OMITE X → rejeita por _mandatoryCovered ──
    def test_template_exige_task_omite_rejeita(self):
        r = self.vet(case("""
_t: (_mkTemplate & {mv: [{verifierId: "vrf-outro", rationale: "f"}]}).out
_k: (_mkTask & {r: _good}).out
n: bt.#TaskAdmissionV2 & {task: _k, template: _t, registry: _reg}
"""))
        self.assertNotEqual(r.returncode, 0, "deveria rejeitar")
        self.assertIn("_mandatoryCovered", r.stdout + r.stderr)

    # ── (2) task declara X com REVISION INVÁLIDA → rejeita pela MESMA
    #    #VerifierResolution (o caso do founder) ──
    def test_revision_invalida_rejeita_pela_mesma_resolucao(self):
        r = self.vet(case("""
_t: (_mkTemplate & {mv: [{verifierId: "vrf-cue-vet-c", rationale: "f"}]}).out
_bad: as.#VerifierRef & {id: "vrf-cue-vet-c", version: 1, revision: "9999999"}
_k: (_mkTask & {r: _bad}).out
n: bt.#TaskAdmissionV2 & {task: _k, template: _t, registry: _reg}
"""))
        self.assertNotEqual(r.returncode, 0, "deveria rejeitar")
        self.assertIn("_verifiersResolve", r.stdout + r.stderr,
                      "rejeitou, mas NAO pela resolucao canonica:\n" + r.stdout + r.stderr)

    # ── (2b) verifier revogado tambem nao admite — born-reject, nao so completion ──
    def test_verifier_revogado_nao_admite(self):
        r = self.vet(case("""
_t: (_mkTemplate & {mv: _|_}).out
_reg2: as.#VerifierRegistry & {events: [
\t{event: "verifier-registered", contract: _contract, rationale: "f"},
\t{event: "verifier-granted", verifierRef: _ver, assertionSchemaRef: _asch, rationale: "f"},
\t{event: "verifier-revoked", verifierRef: _ver, rationale: "f"},
]}
_k: (_mkTask & {r: _good}).out
n: bt.#TaskAdmissionV2 & {task: _k, template: _t, registry: _reg2}
"""))
        self.assertNotEqual(r.returncode, 0)
        self.assertIn("_verifiersResolve", r.stdout + r.stderr)

    # ── COERÊNCIA: template passado ≠ o que a task referencia → rejeita ──
    def test_template_divergente_do_templateRef_rejeita(self):
        r = self.vet(case("""
_t: (_mkTemplate & {mv: _|_}).out & {version: 1}
_k: (_mkTask & {r: _good, tref: "tmpl-fixture@v2"}).out
n: bt.#TaskAdmissionV2 & {task: _k, template: _t, registry: _reg}
"""))
        self.assertNotEqual(r.returncode, 0)
        self.assertIn("_templateMatches", r.stdout + r.stderr)

    # ── isolamento limpo entre casos ──
    def test_arvore_isolada_sem_fixture_residual(self):
        self.assertEqual(os.listdir(os.path.join(self.root, FX_DIR)), [])


if __name__ == "__main__":
    unittest.main()
