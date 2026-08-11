#!/usr/bin/env python3
"""Suite adversarial do gate de CONSUMERHOOD via abstração canônica
(adr-190 item 11 [norma] + adr-191 dec 7 [contrato R1/R2/R3]).

Falsifica check-verifier-resolution-consumer-declaration.sh:
  R1: instancia/unifica #VerifierResolution (posicao de binding) -> exige
      _verifierResolutionConsumer:; mencao em prosa de string nao conta
  R2: idioma cru de re-derivacao fora de verifier-resolution.cue -> violacao
  R3: _resolvableRefKeys fora de verifier-resolution.cue -> violacao
verifier-resolution.cue (definicao) e isento de R1 e e a unica morada legal de
idioma e internals. Comentarios nao contam em nenhuma das tres regras.

O QUE ESTA SUITE NAO PROVA (ten-018): deteccao semantica universal — uma
implementacao futura da mesma semantica por construcao sintaticamente nova
escapa das tres regras. test_semantica_reimplementada_sem_tokens_escapa
documenta a fronteira em vez de escondê-la.

Fixture self-contained: arvore minima com governance/build-time/ e o gate real
rodando com cwd nela.
"""

import os
import shutil
import subprocess
import unittest
import tempfile

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
CHECK_SCRIPT = os.path.join(
    REPO_ROOT, "scripts", "ci", "check-verifier-resolution-consumer-declaration.sh")

SCOPE = "governance/build-time"
DEF_REL = f"{SCOPE}/verifier-resolution.cue"
IDIOM = 'if e.event == "verifier-registered"'
INTERNALS = "_resolvableRefKeys"

# Definicao-fixture: espelha a estrutura real (idioma + internals DENTRO do
# arquivo da abstracao — a unica morada legal).
DEF_CONTENT = (
    "package build_time\n"
    "#VerifierResolution: {\n"
    "\tregistry!: _\n"
    "\t%s: [for e in registry.events %s {e.x}]\n"
    "\tresolve: {refs!: [..._], out: [for r in refs {true}]}\n"
    "}\n" % (INTERNALS, IDIOM)
)


def consumer(name):
    """Consumidor conforme: instancia a abstracao + declaracao ANINHADA."""
    return (
        '#%s: {\n\t_verifierResolutionConsumer: "%s"\n'
        "\t_r: #VerifierResolution & {registry: {events: []}}\n}\n"
        % (name.title().replace("-", ""), name)
    )


def _write(root, rel, content):
    path = os.path.join(root, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)


class ConsumerDeclarationGateTest(unittest.TestCase):
    """Cada teste constroi uma arvore-fixture propria e roda o gate real."""

    def build(self, files, with_def=True):
        root = tempfile.mkdtemp(prefix="vrcd-")
        self.addCleanup(shutil.rmtree, root, ignore_errors=True)
        os.makedirs(os.path.join(root, SCOPE), exist_ok=True)
        if with_def:
            _write(root, DEF_REL, DEF_CONTENT)
        for rel, content in files:
            _write(root, rel, content)
        return root

    def run_check(self, root):
        return subprocess.run(["bash", CHECK_SCRIPT], cwd=root,
                              capture_output=True, text=True)

    # ── so a definicao: isenta de R1; idioma+internals nela sao legais ──
    def test_definicao_sozinha_nao_e_consumidor(self):
        r = self.run_check(self.build([]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("nenhum consumidor", r.stdout)
        self.assertIn("zero bypass", r.stdout)

    # ── R1: consumidor conforme (instancia + declaracao aninhada) → verde ──
    def test_consumidor_conforme_passa(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/consumidor.cue", "package build_time\n" + consumer("completion-v2")),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("1 consumidor", r.stdout)

    # ── R1: instancia SEM declaracao → vermelho nomeando o arquivo ──
    def test_instanciacao_sem_declaracao_falha(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/consumidor.cue",
             "package build_time\n_r: #VerifierResolution & {registry: {events: []}}\n"),
        ]))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("R1", r.stderr)
        self.assertIn("consumidor.cue", r.stderr)

    # ── R1: dois consumidores aninhados no MESMO arquivo → verde ──
    def test_dois_consumidores_no_mesmo_arquivo(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/dois.cue",
             "package build_time\n" + consumer("completion-v2") + consumer("admission-v2")),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    # ── R1: mencao a #VerifierResolution SO em comentario nao compele ──
    def test_mencao_em_comentario_nao_compele(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/doc.cue",
             "package build_time\n// consome #VerifierResolution no futuro\n_y: 2\n"),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("nenhum consumidor", r.stdout)

    # ── R1: mencao em STRING de prosa (nao binding) nao compele — caso real
    #    encontrado na bateria: o SRR de adr-191 menciona o token em summary ──
    def test_mencao_em_string_de_prosa_nao_compele(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/srr.cue",
             'package build_time\n_s: {summary: "centraliza em #VerifierResolution, Mesh-local"}\n'),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("nenhum consumidor", r.stdout)

    # ── R1: binding por tipo (campo tipado com a abstracao) COMPELE ──
    def test_binding_por_tipo_compele(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/typed.cue",
             "package build_time\n#T: {res!: #VerifierResolution}\n"),
        ]))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("R1", r.stderr)

    # ── R1: declaracao SO em comentario nao satisfaz ──
    def test_declaracao_apenas_em_comentario_nao_satisfaz(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/falso.cue",
             'package build_time\n// _verifierResolutionConsumer: "x"\n'
             "_r: #VerifierResolution & {registry: {events: []}}\n"),
        ]))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("falso.cue", r.stderr)

    # ── R2: idioma cru fora da definicao → vermelho, mesmo COM declaracao ──
    def test_idioma_cru_fora_da_definicao_e_bypass(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/bypass.cue",
             'package build_time\n#B: {\n\t_verifierResolutionConsumer: "b"\n'
             "\t_c: [for e in [] %s {x: 1}]\n}\n" % IDIOM),
        ]))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("R2", r.stderr)
        self.assertIn("bypass.cue", r.stderr)

    # ── R3: _resolvableRefKeys fora da definicao → vermelho ──
    def test_acesso_internals_fora_da_definicao_e_bypass(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/leak.cue",
             'package build_time\n#L: {\n\t_verifierResolutionConsumer: "l"\n'
             "\t_r: #VerifierResolution & {registry: {events: []}}\n"
             "\t_keys: _r.%s\n}\n" % INTERNALS),
        ]))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("R3", r.stderr)
        self.assertIn("leak.cue", r.stderr)

    # ── R2/R3 em comentario nao contam ──
    def test_bypass_apenas_em_comentario_nao_conta(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/doc2.cue",
             "package build_time\n// exemplo: [for e in [] %s {x}]\n"
             "// e nunca acessar %s de fora\n_z: 1\n" % (IDIOM, INTERNALS)),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    # ── fora do escopo nao entra em regra alguma ──
    def test_fora_do_escopo_nao_entra(self):
        r = self.run_check(self.build([
            ("outra-area/x.cue",
             "package outra\n_c: [for e in [] %s {x: 1}]\n_k: %s\n" % (IDIOM, INTERNALS)),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    # ── FRONTEIRA DECLARADA (ten-018): reimplementacao sem os tokens escapa ──
    def test_semantica_reimplementada_sem_tokens_escapa(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/oculto.cue",
             'package build_time\n_ev: "verifier-" + "registered"\n'
             "_c: [for e in [] if e.event == _ev {x: 1}]\n"),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    # ── escopo ausente → infra, nunca verde ──
    def test_escopo_ausente_falha_como_infra(self):
        root = tempfile.mkdtemp(prefix="vrcd-noscope-")
        self.addCleanup(shutil.rmtree, root, ignore_errors=True)
        r = self.run_check(root)
        self.assertEqual(r.returncode, 2, r.stdout + r.stderr)
        self.assertNotIn("ok:", r.stdout)


if __name__ == "__main__":
    unittest.main()
