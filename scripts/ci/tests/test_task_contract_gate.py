#!/usr/bin/env python3
"""ContractGate do contrato V2 da tarefa Mesh (M-182 acceptance; adr-190 C2).

Prova NAO-VACUOSA de #TaskCompletionV2: instancia conforme PASSA e instancias
malformadas FALHAM sob `cue vet -c`.

Fixtures vivem SO aqui (decisao do founder): nenhuma fixture entra em
governance/build-time/ — aquele diretorio e configuracao/contrato real, e e
justamente o escopo observado pelo gate de consumerhood e pelos triggers de
def-085; fixture ali viraria ruido de sensor.

Isolamento: a arvore de trabalho (incl. mudancas nao-commitadas) e copiada uma
vez para tmp; cada caso escreve seu pacote de fixture na COPIA. O working tree
do autor nunca e tocado, e um crash nao deixa .cue vermelho para tras.
"""

import os
import shutil
import subprocess
import unittest
import tempfile

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
FX_DIR = "contract-gate-fx"

BT = 'bt "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"'
AS = 'as "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"'

PRELUDE = f"""package contract_gate_fx

import (
\t{BT}
\t{AS}
)

_asch: "asch-cue-vet"

// construtor: spec + completion coerentes para um verifierRef dado. Nao unifica
// listas concretas — evita que a fixture falhe por si mesma em vez do join.
_mk: {{
\tr: as.#VerifierRef
\tspec: bt.#TaskSpecV2 & {{
\t\tspecVersion: "v2", id: "WI-190", version: 1, title: "f", templateRef: "tmpl-f@v1"
\t\tsemanticPrerequisites: ["n"], outputs: [{{artifact: "x.cue", type: "create"}}], affects: ["x"]
\t\trequiredEvidence: [{{id: "req-1", verifierRef: r, assertionPayload: {{}}, rationale: "f"}}]
\t\trationale: "f"
\t}}
\tcompletion: bt.#CompletionValidationV2 & {{
\t\tvalidationVersion: "v2", validationRunId: "run-1", artifactSnapshotHash: "dead", gatesPassed: ["g"]
\t\tproofResults: [{{requirementId: "req-1", verifierRef: r, evidenceRef: {{kind: "git", value: "abc1234"}}, observedAt: "2026-08-10T21:00:00Z", conclusion: "verified", rationale: "f"}}]
\t}}
}}

_good: as.#VerifierRef & {{id: "vrf-cue-vet-c", version: 1, revision: "a1b2c3d"}}
_ver:  {{id: _good.id, version: _good.version}}
_contract: as.#VerifierContract & {{
\tref: _good, assertionSchemaRef: _asch, evidenceIntegrity: "reproducible"
\tresultSemantics: "exit 0 == verified", readOnly: true, rationale: "f"
}}
_registered: {{event: "verifier-registered", contract: _contract, rationale: "f"}}
_granted:    {{event: "verifier-granted", verifierRef: _ver, assertionSchemaRef: _asch, rationale: "f"}}
"""


def case(body):
    return PRELUDE + "\n" + body


class TaskContractGateTest(unittest.TestCase):
    """Cada caso roda `cue vet -c` sobre um pacote de fixture na copia isolada."""

    @classmethod
    def setUpClass(cls):
        cls.root = tempfile.mkdtemp(prefix="contract-gate-")
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
            r = subprocess.run(["cue", "vet", "-c", f"./{FX_DIR}/"], cwd=self.root,
                               capture_output=True, text=True)
        finally:
            os.remove(path)
        return r

    # ── POSITIVO: registrado + active + grant compativel -> resolve ──
    def test_positivo_instancia_conforme_passa(self):
        r = self.vet(case("""
_reg: as.#VerifierRegistry & {events: [_registered, _granted]}
_c:   (_mk & {r: _good})
ok: bt.#TaskCompletionV2 & {taskSpec: _c.spec, completion: _c.completion, registry: _reg}
"""))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    # ── NEGATIVOS rejeitados PELO JOIN (_verifierResolves) ──
    def _join_rejects(self, body):
        r = self.vet(case(body))
        self.assertNotEqual(r.returncode, 0, "fixture deveria falhar e passou")
        self.assertIn("_verifierResolves", r.stdout + r.stderr,
                      "falhou, mas NAO pela invariante de resolucao:\n" + r.stdout + r.stderr)

    def test_revoked_nao_resolve(self):
        self._join_rejects("""
_reg: as.#VerifierRegistry & {events: [_registered, _granted, {event: "verifier-revoked", verifierRef: _ver, rationale: "f"}]}
_c:   (_mk & {r: _good})
n: bt.#TaskCompletionV2 & {taskSpec: _c.spec, completion: _c.completion, registry: _reg}
""")

    def test_deprecated_nao_resolve(self):
        self._join_rejects("""
_reg: as.#VerifierRegistry & {events: [_registered, _granted, {event: "verifier-deprecated", verifierRef: _ver, rationale: "f"}]}
_c:   (_mk & {r: _good})
n: bt.#TaskCompletionV2 & {taskSpec: _c.spec, completion: _c.completion, registry: _reg}
""")

    def test_revision_divergente_nao_resolve(self):
        self._join_rejects("""
_reg: as.#VerifierRegistry & {events: [_registered, _granted]}
_c:   (_mk & {r: {id: "vrf-cue-vet-c", version: 1, revision: "9999999"}})
n: bt.#TaskCompletionV2 & {taskSpec: _c.spec, completion: _c.completion, registry: _reg}
""")

    def test_verifier_nao_registrado_nao_resolve(self):
        self._join_rejects("""
_reg: as.#VerifierRegistry & {events: [_registered, _granted]}
_c:   (_mk & {r: {id: "vrf-ghost", version: 1, revision: "beef123"}})
n: bt.#TaskCompletionV2 & {taskSpec: _c.spec, completion: _c.completion, registry: _reg}
""")

    # ── NEGATIVOS rejeitados PELA CAMADA REGISTRY (_capabilityCovered) ──
    # adr-190 dec 7: sob #VerifierRegistry valido, "active sem grant efetivo" e
    # IRREPRESENTAVEL. Estes casos provam a entailment em vez de escondê-la.
    def _registry_rejects(self, body):
        r = self.vet(case(body))
        self.assertNotEqual(r.returncode, 0, "fixture deveria falhar e passou")
        self.assertIn("_capabilityCovered", r.stdout + r.stderr,
                      "falhou, mas NAO na camada Registry:\n" + r.stdout + r.stderr)

    def test_sem_grant_e_irrepresentavel_no_registry(self):
        self._registry_rejects("""
_reg: as.#VerifierRegistry & {events: [_registered]}
_c:   (_mk & {r: _good})
n: bt.#TaskCompletionV2 & {taskSpec: _c.spec, completion: _c.completion, registry: _reg}
""")

    def test_grant_revogado_e_irrepresentavel_no_registry(self):
        self._registry_rejects("""
_reg: as.#VerifierRegistry & {events: [_registered, _granted, {event: "verifier-grant-revoked", verifierRef: _ver, assertionSchemaRef: _asch, rationale: "f"}]}
_c:   (_mk & {r: _good})
n: bt.#TaskCompletionV2 & {taskSpec: _c.spec, completion: _c.completion, registry: _reg}
""")

    # ── NAO-VACUIDADE: a copia isolada esta limpa entre casos ──
    def test_arvore_isolada_sem_fixture_residual(self):
        self.assertEqual(os.listdir(os.path.join(self.root, FX_DIR)), [],
                         "fixture vazou entre casos — o gate perderia isolamento")


if __name__ == "__main__":
    unittest.main()
