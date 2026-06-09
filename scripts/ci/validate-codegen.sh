#!/usr/bin/env bash
# validate-codegen.sh -- harness do golden-example CMT (WI-137 / W006).
#
# O QUE FAZ (quando houver toolchain): le o golden-example
# contexts/cmt/golden-examples/bd-mutual-acceptance.cue, gera os artefatos de
# codegenTarget.kinds (types/aggregate-skeleton/port-contracts/stubs/
# contract-tests/assertion-tests) para um diretorio de SCRATCH ignorado pelo git,
# compila, roda os assertion-tests de asrt-mutual-bilateral-acceptance (>=1 caso
# valido + >=1 invalido), avalia os gates de adr-138 item 7 (CONTINUAR/PIVOTAR/
# ABANDONAR) e grava o resultado em
# governance/build-time/codegen-validation-evidence.cue.
#
# P1 ESTRITO: o codigo gerado vai SO para scratch (nunca commitado no mesh-spec);
# o mesh-runtime NAO e tocado. Edicao semantica do gerado e PROIBIDA (gate
# ABANDONAR) -- so header/formatacao/scaffolding documentado FORA do gerado.
#
# ESTADO ATUAL: a toolchain de codegen (linguagem-alvo + gerador CUE->codigo +
# test runner) NAO esta decidida -- adr-139 deferiu vendor/runtime; def-040
# (runtime HTTP) esta open; e o mesh-runtime nao esta no escopo. Sem toolchain
# NAO HA o que gerar/compilar/testar; este harness detecta a ausencia e para.
#
# POR QUE EXIT 78 (EX_CONFIG, sysexits.h), NAO 0 NEM 1:
#   - exit 0 seria FALSO-VERDE: um CI futuro concluiria que a validacao P1
#     PASSOU quando so detectamos ausencia de toolchain. Falso-verde e PIOR que
#     ausencia -- mascara o experimento nao-executado como se fosse sucesso.
#   - exit 1 seria confundivel com BUG / teste real falhando.
#   - exit 78 = "configuracao ausente": sinaliza inequivocamente "toolchain
#     pending", distinto de sucesso e de bug. Este harness so retorna 0 quando
#     a toolchain existir E o pipeline gerar+compilar+testar rodar ate o fim.
set -euo pipefail

readonly EX_CONFIG=78
readonly GOLDEN_EXAMPLE="contexts/cmt/golden-examples/bd-mutual-acceptance.cue"
readonly SCRATCH_DIR="${MESH_CODEGEN_SCRATCH:-.codegen-scratch}" # gitignored; nunca commitado

# Marcador de toolchain: definido quando a stack de codegen for materializada
# (linguagem-alvo + gerador + test runner). Ausente hoje (adr-139 deferiu).
TOOLCHAIN="${MESH_CODEGEN_TOOLCHAIN:-}"

if [[ -z "${TOOLCHAIN}" ]]; then
	{
		echo "codegen toolchain pending (adr-139/def-040; mesh-runtime ausente) -- nada a gerar/compilar/testar."
		echo "WI-137 entregou o lado-spec (golden-example + #Assertion + este harness + evidence-pending);"
		echo "a execucao viva fica deferida ate a toolchain ser decidida e o mesh-runtime existir."
		echo "exit ${EX_CONFIG} (EX_CONFIG) deliberado: NAO 0 (evita falso-verde), NAO 1 (evita confusao com bug)."
	} >&2
	exit "${EX_CONFIG}"
fi

# Guard: mesmo com a env var setada, o pipeline de execucao abaixo ainda nao foi
# implementado (WI-137 entregou so o lado-spec). Sair com EX_CONFIG ate ele
# existir -- nunca cair em exit 0 implicito (falso-verde) por env var prematura.
{
	echo "MESH_CODEGEN_TOOLCHAIN='${TOOLCHAIN}' setada, mas o pipeline gerar+compilar+testar ainda nao foi implementado."
	echo "Implementar contra ${GOLDEN_EXAMPLE} -> ${SCRATCH_DIR} (gitignored), depois gravar codegen-validation-evidence.cue."
	echo "exit ${EX_CONFIG} ate la (evita falso-verde)."
} >&2
exit "${EX_CONFIG}"

# --- Pipeline a implementar quando a toolchain materializar (adr-138 item 6/7) ---
#  1. Gerar codegenTarget.kinds de ${GOLDEN_EXAMPLE} para ${SCRATCH_DIR} (gitignored;
#     nunca commitar; nunca tocar o mesh-runtime).
#  2. Compilar o gerado na linguagem-alvo.
#  3. Rodar os assertion-tests de asrt-mutual-bilateral-acceptance (>=1 valido + >=1 invalido).
#  4. Avaliar os gates de adr-138 item 7 e mapear para exit-code DISTINTO (nunca ad-hoc):
#       CONTINUAR = 0
#       PIVOTAR   = 75 (EX_TEMPFAIL: spec/toolchain insuficiente -- revisar)
#       ABANDONAR = 70 (EX_SOFTWARE: output exige edicao semantica -- P1 violado)
#     Todos DISTINTOS de 1 (bug/teste real falhando) e de 78 (EX_CONFIG: toolchain ausente, acima);
#     pre-fixados aqui para o implementador futuro NAO escolher ad-hoc e reintroduzir falso-verde.
#  5. Gravar governance/build-time/codegen-validation-evidence.cue com o gate atingido.
#  P1: qualquer edicao semantica do gerado dispara ABANDONAR (exit 70). exit 0 SO no gate CONTINUAR.
