#!/usr/bin/env python3
"""Suite adversarial do gate de DECLARAÇÃO DE CONSUMERHOOD (adr-190 item 11).

Falsifica check-verifier-resolution-consumer-declaration.sh, cujo contrato é
ESTREITO e deliberadamente não-universal: arquivo em governance/build-time/ que
use o IDIOMA CANÔNICO de re-derivação (comprehension filtrando eventos
"verifier-registered") DEVE conter a declaração canônica
(_verifierResolutionConsumer:).

O QUE ESTA SUITE NÃO PROVA (ten-018): que todo consumidor governado da resolução
declara consumerhood. O gate detecta OMISSÃO no idioma conhecido; uma
implementação futura que resolva verifier por outra construção escapa. O teste
test_idioma_ausente_nao_exige_declaracao documenta essa fronteira: sem o idioma,
o gate não exige nada — inclusive de um arquivo que resolva verifier de outro
jeito.

Granularidade declarada: o gate é POR ARQUIVO (>=1 declaração no arquivo que usa
o idioma), não por consumidor. Isso é deliberado — contar declarações por
consumidor é inconstruível (ver ten-018) e contar por arquivo colidiria com a
propriedade de permitir dois consumidores no mesmo arquivo.

Fixture self-contained: árvore mínima com governance/build-time/ e o gate real
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
IDIOM = 'if e.event == "verifier-registered"'
# Declaração ANINHADA na definição do consumidor. NUNCA top-level: todos os
# .cue de governance/build-time/ são um único package, e duas declarações
# top-level com valores distintos colidem em cue vet (conflicting values) —
# o segundo consumidor quebraria o build em vez de disparar o sensor.
def consumer(name):
    return ('#%s: {\n\t_verifierResolutionConsumer: "%s"\n\t_c: [for e in [] %s {x: 1}]\n}\n'
            % (name.title().replace("-", ""), name, IDIOM))


DECLARATION = '_verifierResolutionConsumer: "fixture-consumer"' 


def _write(root, rel, content):
    path = os.path.join(root, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)


class ConsumerDeclarationGateTest(unittest.TestCase):
    """Cada teste constrói uma árvore-fixture própria e roda o gate real."""

    def build(self, files):
        root = tempfile.mkdtemp(prefix="vrcd-")
        self.addCleanup(shutil.rmtree, root, ignore_errors=True)
        os.makedirs(os.path.join(root, SCOPE), exist_ok=True)
        for rel, content in files:
            _write(root, rel, content)
        return root

    def run_check(self, root):
        return subprocess.run(["bash", CHECK_SCRIPT], cwd=root,
                              capture_output=True, text=True)

    # ── sem o idioma: o gate não exige nada (fronteira declarada, ten-018) ──
    def test_idioma_ausente_nao_exige_declaracao(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/outro.cue", "package build_time\n_x: 1\n"),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("nenhum arquivo", r.stdout)

    # ── CONTRATO: idioma no escopo SEM marcador → vermelho ──
    def test_idioma_no_escopo_sem_marcador_falha(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/consumidor.cue",
             "package build_time\n_c: [for e in [] %s {x: 1}]\n" % IDIOM),
        ]))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("SEM a declaração canônica", r.stderr)
        self.assertIn("consumidor.cue", r.stderr)

    # ── CONTRATO: idioma no escopo COM marcador aninhado → verde ──
    def test_idioma_no_escopo_com_marcador_aninhado_passa(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/consumidor.cue", "package build_time\n" + consumer("completion-v2")),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("todos com declaração", r.stdout)

    # ── CONTRATO: idioma FORA do escopo não entra na obrigação ──
    def test_idioma_fora_do_escopo_nao_entra_na_obrigacao(self):
        r = self.run_check(self.build([
            ("outra-area/consumidor.cue",
             "package outra\n_c: [for e in [] %s {x: 1}]\n" % IDIOM),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("nenhum arquivo", r.stdout)

    # ── um arquivo declara, outro não → vermelho nomeando só o faltante ──
    def test_apenas_o_faltante_e_nomeado(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/ok.cue", "package build_time\n" + consumer("completion-v2")),
            (f"{SCOPE}/faltante.cue",
             "package build_time\n_d: [for e in [] %s {y: 2}]\n" % IDIOM),
        ]))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("faltante.cue", r.stderr)
        self.assertNotIn("ok.cue", r.stderr)

    # ── DOIS consumidores aninhados no MESMO arquivo → verde (era o bug do
    #    round 4: com declaração top-level isto quebraria o cue vet) ──
    def test_dois_consumidores_no_mesmo_arquivo(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/dois.cue",
             "package build_time\n" + consumer("completion-v2") + consumer("admission-v2")),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    # ── comentário com o idioma NÃO compele declaração falsa ──
    def test_idioma_em_comentario_nao_compele_declaracao(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/doc.cue",
             "package build_time\n// exemplo: [for e in [] %s {x: 1}]\n_y: 2\n" % IDIOM),
        ]))
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("nenhum arquivo", r.stdout)

    # ── declaração SÓ em comentário não satisfaz o gate ──
    def test_declaracao_apenas_em_comentario_nao_satisfaz(self):
        r = self.run_check(self.build([
            (f"{SCOPE}/falso.cue",
             "package build_time\n// %s\n_c: [for e in [] %s {x: 1}]\n" % (DECLARATION, IDIOM)),
        ]))
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertIn("falso.cue", r.stderr)

    # ── escopo ausente → infra, nunca verde ──
    def test_escopo_ausente_falha_como_infra(self):
        root = tempfile.mkdtemp(prefix="vrcd-noscope-")
        self.addCleanup(shutil.rmtree, root, ignore_errors=True)
        r = self.run_check(root)
        self.assertEqual(r.returncode, 2, r.stdout + r.stderr)
        self.assertNotIn("ok:", r.stdout)


if __name__ == "__main__":
    unittest.main()
