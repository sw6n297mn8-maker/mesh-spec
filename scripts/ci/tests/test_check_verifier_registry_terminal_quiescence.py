#!/usr/bin/env python3
"""Suite adversarial do dente QUIESCÊNCIA TERMINAL do Verifier Registry (adr-189, CI-1).

Falsifica EXCLUSIVAMENTE check-verifier-registry-terminal-quiescence.sh: após um
(verifier id, version) atingir "revoked", nenhum evento subsequente dirigido a
essa versão é válido. Só "revoked" é terminal; "deprecated" não.

FRONTEIRAS (documentadas por decisão do founder — não são casos desta suite):
  - re-register da MESMA versão pós-revoke é rejeitado ANTES pelo invariante U
    (register-once) do `#VerifierRegistry` → cue export falha → o gate sai 2, não
    1. A regra "qualquer evento dirigido à versão terminal" divide-se: register →
    dente CUE (U); não-register → este gate.
  - tipo de evento OPACO é rejeitado ANTES pela união fechada
    #VerifierRegistryEvent → cue export falha → exit 2. O branch "unknown" do
    script (fail-closed) NÃO é fabricado aqui: fica como DEFESA DE EVOLUÇÃO, para
    o caso de o schema ganhar um evento novo e o gate não ser atualizado junto.
Ambas as fronteiras foram verificadas empiricamente.

Este gate não usa Git/base (só cue export do candidato), então a fixture é um
módulo CUE mínimo (sem repo git): cue.mod + cópia do verifier-types.cue adotado +
verifier-registry.cue instanciado. O gate roda com cwd na raiz do módulo.
"""

import os
import shutil
import subprocess
import unittest
import tempfile

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
CHECK_SCRIPT = os.path.join(REPO_ROOT, "scripts", "ci", "check-verifier-registry-terminal-quiescence.sh")
SCHEMA_SRC = os.path.join(REPO_ROOT, "architecture", "artifact-schemas", "verifier-types.cue")

REGISTRY_REL = "governance/build-time/verifier-registry.cue"
SCHEMA_REL = "architecture/artifact-schemas/verifier-types.cue"
MODULE = "fixture.test/vrtq"


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


def grant(vid, v, asch):
    return ('{event: "verifier-granted", verifierRef: {id: "%s", version: %d}, '
            'assertionSchemaRef: "%s", rationale: "r"}' % (vid, v, asch))


def grant_revoke(vid, v, asch):
    return ('{event: "verifier-grant-revoked", verifierRef: {id: "%s", version: %d}, '
            'assertionSchemaRef: "%s", rationale: "r"}' % (vid, v, asch))


def deprecate(vid, v):
    return ('{event: "verifier-deprecated", verifierRef: {id: "%s", version: %d}, '
            'rationale: "r"}' % (vid, v))


def revoke(vid, v):
    return ('{event: "verifier-revoked", verifierRef: {id: "%s", version: %d}, '
            'rationale: "r"}' % (vid, v))


def registry_cue(event_literals):
    body = ",\n\t\t".join(event_literals)
    return (
        "package build_time\n\n"
        'import "%s/architecture/artifact-schemas:artifact_schemas"\n\n'
        "verifierRegistry: artifact_schemas.#VerifierRegistry & {\n"
        "\tevents: [\n\t\t%s,\n\t]\n}\n" % (MODULE, body)
    )


@unittest.skipUnless(shutil.which("cue"), "cue binário ausente (job cue-validate instala)")
class TerminalQuiescenceGateTest(unittest.TestCase):
    """Cada teste constrói um módulo-fixture próprio e roda o gate real."""

    def build(self, events):
        with open(SCHEMA_SRC, encoding="utf-8") as f:
            schema = f.read()
        root = tempfile.mkdtemp(prefix="vrtq-")
        self.addCleanup(shutil.rmtree, root, ignore_errors=True)
        _write(root, "cue.mod/module.cue",
               'module: "%s"\nlanguage: version: "v0.16.0"\n' % MODULE)
        _write(root, SCHEMA_REL, schema)
        _write(root, REGISTRY_REL, registry_cue(events))
        return root

    def run_check(self, root):
        return subprocess.run(["bash", CHECK_SCRIPT], cwd=root,
                              capture_output=True, text=True)

    def assert_violation(self, r):
        # returncode 1 E sem contaminação de infra/export (exit 2).
        combined = r.stdout + r.stderr
        self.assertEqual(r.returncode, 1, combined)
        self.assertIn("APOS revoked", r.stderr)
        for marker in ("cue export", "falhou", "sem alvo"):
            self.assertNotIn(marker, combined,
                             f"violação contaminada por outro caminho: {marker!r}\n{combined}")

    # 1. register → grant → revoke → 0
    def test_revoke_limpo_passa(self):
        r = self.run_check(self.build(
            [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x"), revoke("vrf-x", 1)]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("terminal-quiescence ok", r.stdout)

    # 2. register → grant → revoke → grant → 1
    def test_grant_apos_revoke_falha(self):
        r = self.run_check(self.build(
            [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x"),
             revoke("vrf-x", 1), grant("vrf-x", 1, "asch-x")]))
        self.assert_violation(r)

    # 3. register → grant → deprecated → revoke → 0 (deprecated não é terminal)
    def test_deprecated_depois_revoke_passa(self):
        r = self.run_check(self.build(
            [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x"),
             deprecate("vrf-x", 1), revoke("vrf-x", 1)]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("terminal-quiescence ok", r.stdout)

    # 4. register → grant → revoke → deprecated → 1
    def test_deprecate_apos_revoke_falha(self):
        r = self.run_check(self.build(
            [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x"),
             revoke("vrf-x", 1), deprecate("vrf-x", 1)]))
        self.assert_violation(r)

    # 5. register → grant → revoke → grant-revoke → 1 (prova "qualquer não-register")
    def test_grant_revoke_apos_revoke_falha(self):
        r = self.run_check(self.build(
            [register("vrf-x", 1, "asch-x"), grant("vrf-x", 1, "asch-x"),
             revoke("vrf-x", 1), grant_revoke("vrf-x", 1, "asch-x")]))
        self.assert_violation(r)


if __name__ == "__main__":
    unittest.main()
