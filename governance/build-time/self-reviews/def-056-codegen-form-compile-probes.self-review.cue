package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def056CodegenFormCompileProbes: build_time.#SelfReviewReport & {
	reportId: "srr-def-056-codegen-form-compile-probes"

	artifactPath:       "architecture/deferred-decisions/def-056-codegen-form-compile-probes.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-28"

	roundsExecuted: 2
	maxRounds:      3
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Re-review isolated-subagent (contexto fresco) do def-056 (check-(a) compile-probes dos domain-types
			gerados, deferido ate a geracao viva). tq-def-01: deferralRationale articula trade-off concreto --
			custo evitado = materializar compile-probes contra output inexistente (harness sai 78); custo de
			continuar = P14 sem a validacao mais-forte ate a geracao viva, mitigado pela FF-CG-03 re-apontada +
			review. tq-def-02: ambos os triggers conformam #Trigger (adjacent-need/file-exists + manual-review
			reason>=40). tq-def-03: ha trigger non-manual-review. tq-def-04: low + cross-artifact coerentes com a
			description. MinRunes conferidos (description ~480, deferralRationale ~700, triggerCalibration ~480,
			costOfDeferral.description ~360, manual-review.reason ~260). Anti-catch-all: e deferimento genuino
			(trade-off + condicao de revisita), nao WI/bug/tensao -- materializa o gap N1/N3 de adr-146. INFO: o
			trigger file-exists em validate-codegen.sh nasce disparado (harness ja existe, WI-137) -- justificado
			no triggerCalibrationRationale como lembrete permanente, com a condicao real (geracao viva) vivendo no
			mesh-runtime, nao machine-evaluable daqui; mesmo padrao de def-055, com que co-anota. Veredito do
			subagente: APROVADO.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round 2 (2026-06-28) — review isolated-subagent da TRANSIÇÃO open→resolved do def-056, no mesmo
			subagente que cobriu adr-163. O gatilho da revisita (premissa "não há geração viva a auditar")
			CADUCOU: verificado no disco geração viva real (mesh-runtime contexts/fce-generated/FceTypes.kt
			com value class private constructor + header DO-NOT-EDIT adr-146/148; mesh-frontend-runtime
			contexts/fce-generated/*.ts). A resolução conforma a união discriminada de #DeferredDecision:
			status "resolved" + resolvedBy = #OriginRef path .cue apontando para o adr-163 existente;
			auxiliares triggeredAt/withdrawalRationale ausentes (correto para resolved). O CONTRATO do
			check-(a) foi fixado em adr-163 (review substantivo no SRR do adr-163); aqui confirma-se apenas
			a conformidade da transição de lifecycle. INFO: os triggers originais foram preservados (benigno;
			status=resolved torna-os inertes ao runner — nenhum schema exige limpá-los). Veredito: APROVADO.
			"""
	}]

	findings: {}

	summary: """
		def-056 RESOLVIDO por adr-163. Round 1 (2026-06-10) revisou o deferimento original (materializa o
		gap N1/N3 de adr-146: o check-(a) compile-probes só rodaria com geração viva). Round 2 (2026-06-28)
		revisou a resolução: a premissa caducou (geração viva real nos dois runtimes), e a transição
		open→resolved conforma a união discriminada (resolvedBy = path do adr-163, que fixou o contrato do
		check). Substância do contrato no SRR do adr-163; o resíduo de IMPLEMENTAÇÃO segue rastreado em
		def-071. VEREDITO: 0 fail / 0 warn, stable em 2 rounds; cue vet EXIT=0.
		"""
}
