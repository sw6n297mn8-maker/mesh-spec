#!/usr/bin/env python3
"""Suite adversarial do gate de COBERTURA EXAUSTIVA da Authority Surface (adr-189 dec 1/2).

Falsifica check-verifier-governance-coverage.sh: igualdade de conjuntos entre os
event types da união #VerifierRegistryEvent ADOTADA e os resultingEventType
declarados na Authority Surface.

VALOR NOVO DO GATE (o que só ele prova): o sentido adotado ⊆ declarado. O sentido
inverso (declarado ⊆ adotado) já é enforçado pelo TIPO em cue vet, via
_validEventType. Por isso o teste load-bearing desta suite é
test_adotado_ganha_evento_novo_sem_acao_falha: um sexto event type no schema
adotado, com a Authority Surface parada em cinco, DEVE ficar vermelho.

CAMADAS (observado empiricamente, documentado para não fabricar cobertura):
  - duplicata de resultingEventType é capturada ANTES pelo tipo CUE
    (_uniqueEvents na Authority Surface) — o cue export falha e o gate observa
    como INFRA (exit 2). A propriedade load-bearing testada aqui é "nunca verde",
    não o código específico.
  - ação apontando para event type inexistente é capturada ANTES pelo tipo
    (_validEventType) — não é caso desta suite pelo mesmo motivo.
  - falha de introspecção da união (representação mudou) DEVE ser exit 2 e nunca
    cobertura verde — testado.

Fixture self-contained: módulo CUE mínimo espelhando os paths que o gate usa
(architecture/artifact-schemas/ + governance/build-time/), com cópias do schema
adotado e da Authority Surface reais do repo; cada teste muta a cópia.
"""

import os
import shutil
import subprocess
import unittest
import tempfile

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
CHECK_SCRIPT = os.path.join(REPO_ROOT, "scripts", "ci", "check-verifier-governance-coverage.sh")
SCHEMA_SRC = os.path.join(REPO_ROOT, "architecture", "artifact-schemas", "verifier-types.cue")
AUTH_SRC = os.path.join(REPO_ROOT, "governance", "build-time", "verifier-governance-authority.cue")

SCHEMA_REL = "architecture/artifact-schemas/verifier-types.cue"
AUTH_REL = "governance/build-time/verifier-governance-authority.cue"
MODULE = "fixture.test/vga"
REAL_IMPORT = "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
FIXTURE_IMPORT = MODULE + "/architecture/artifact-schemas:artifact_schemas"

# Evento extra usado para simular crescimento da união adotada.
EXTRA_EVENT_STRUCT = """

#VerifierFrobnicatedEvent: {
\tevent!:       "verifier-frobnicated"
\tverifierRef!: #VerifierVersionRef
\trationale!:   string & !=""
}
"""


def _write(root, rel, content):
    path = os.path.join(root, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)


@unittest.skipUnless(shutil.which("cue"), "cue binário ausente (job cue-validate instala)")
class VerifierGovernanceCoverageTest(unittest.TestCase):
    """Cada teste constrói um módulo-fixture próprio e roda o gate real."""

    def build(self, schema_mutator=None, auth_mutator=None):
        with open(SCHEMA_SRC, encoding="utf-8") as f:
            schema = f.read()
        with open(AUTH_SRC, encoding="utf-8") as f:
            auth = f.read().replace(REAL_IMPORT, FIXTURE_IMPORT)

        if schema_mutator:
            schema = schema_mutator(schema)
        if auth_mutator:
            auth = auth_mutator(auth)

        root = tempfile.mkdtemp(prefix="vga-")
        self.addCleanup(shutil.rmtree, root, ignore_errors=True)
        _write(root, "cue.mod/module.cue",
               'module: "%s"\nlanguage: version: "v0.16.0"\n' % MODULE)
        _write(root, SCHEMA_REL, schema)
        _write(root, AUTH_REL, auth)
        return root

    def run_check(self, root):
        return subprocess.run(["bash", CHECK_SCRIPT], cwd=root,
                              capture_output=True, text=True)

    # ── baseline: conjuntos iguais → verde ──
    def test_cobertura_completa_passa(self):
        r = self.run_check(self.build())
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("coverage ok", r.stdout)

    # ── LOAD-BEARING: união adotada cresce, Authority Surface não → vermelho ──
    def test_adotado_ganha_evento_novo_sem_acao_falha(self):
        def grow_union(s):
            s = s + EXTRA_EVENT_STRUCT
            return s.replace(
                "\t#VerifierGrantRevokedEvent\n",
                "\t#VerifierGrantRevokedEvent |\n\t#VerifierFrobnicatedEvent\n", 1)

        r = self.run_check(self.build(schema_mutator=grow_union))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("sem acao autorizante", r.stderr)
        self.assertIn("verifier-frobnicated", r.stderr)
        self.assertNotIn("coverage ok", r.stdout)

    # ── introspecção da união falha → exit 2, NUNCA cobertura verde ──
    def test_uniao_nao_extraivel_falha_como_infra(self):
        def rename(s):
            return s.replace("#VerifierRegistryEvent", "#VerifierRegistryEvt")

        r = self.run_check(self.build(schema_mutator=rename, auth_mutator=rename))
        self.assertEqual(r.returncode, 2, r.stdout + r.stderr)
        self.assertNotIn("coverage ok", r.stdout)

    # ── duplicata: capturada antes pelo tipo (_uniqueEvents); load-bearing é
    #    "nunca verde", não o código específico (hoje 2, via export falho) ──
    def test_duplicata_nunca_fica_verde(self):
        def dup(s):
            return s.replace('resultingEventType: "verifier-deprecated"',
                             'resultingEventType: "verifier-registered"', 1)

        r = self.run_check(self.build(auth_mutator=dup))
        self.assertNotEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertNotIn("coverage ok", r.stdout)


if __name__ == "__main__":
    unittest.main()
