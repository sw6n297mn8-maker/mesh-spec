package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def078ApprovalOrderGateVsConsequence: build_time.#SelfReviewReport & {
	reportId: "srr-def-078-approval-order-gate-vs-consequence"

	artifactPath:       "architecture/deferred-decisions/def-078-approval-order-gate-vs-consequence.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-12"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 — self-review do def-078 (ordem da aprovação de compra:
			aprovação-como-gate vs aprovação-como-consequência; decisão de
			modelo em aberto exposta pela ds-buyer-procurement-journey).

			[uq-08 CONFORMÂNCIA #DeferredDecision]: OK. cue vet EXIT=0 —
			registrado que a autoria teve um round de schema-fix gated: o
			blastRadius nasceu 'cross-context' (inválido no enum), a execução
			PAROU sem auto-correção per instrução, e o arquiteto reautorou para
			'cross-artifact' (o blast atinge os artefatos concretos bdg + p2p,
			não uma camada transversal do repo). Número def-078 confirmado
			próximo-livre via freshness --assert (G2) no ato da escrita E
			re-assertado no ato do commit.

			[ANTI-CATCH-ALL]: OK. Deferimento consciente genuíno — decisão de
			MODELO explícita (qual ordem de aprovação o sistema adota) com
			trade-off articulado e revisita codificada; não é WI (a execução da
			requisição é WI-151, separada), não é tensão entre forças de design
			registrada, não é bug (o modelo atual é coerente consigo mesmo — a
			divergência é contra a jornada vivida, e qual lado cede é decisão
			do founder).

			[tq-def-01 TRADE-OFF]: OK. Custo evitado: reescrever o acoplamento
			bdg↔p2p (invariantes de alçada + momento da validação) antes do
			desenho da triagem existir. Custo de continuar: o passo de
			triagem/alçada da fatia da requisição não fecha — por isso def-078
			é pré-requisito do passo 3 do WI-151, não item paralelo.

			[tq-def-02 CODIFICADO]: OK. O trigger manual-review conforma
			#TriggerStrict (reason >= 40 runes, substantiva).

			[tq-def-03 — FINDING WARN, ACEITO]: o def é manual-only (nenhum
			trigger non-manual-review). Warn DECLARADO abaixo em findings.warn,
			não silenciado. A justificativa NÃO é reaberta aqui — vive no
			triggerCalibrationRationale do próprio def-078: não há predicado de
			disco livre de falso-positivo ('a ordem foi decidida' não é
			machine-evaluable; o domain-model do p2p já referencia
			authority/alçada, gerando disparo espúrio imediato em trigger de
			conteúdo; trigger de existência de arquivo cravaria número de WI
			irmão do mesmo lote, frágil contra o G2). O acoplamento com a
			revisita real está expresso no semanticPrerequisites do WI-151.

			[tq-def-04 COERENTE]: OK. medium (bloqueia o passo 3 da jornada,
			não o resto do modelo) / cross-artifact (bdg + p2p concretos)
			coerentes com a description pós-reautoria.

			[uq-03 REFS]: OK — originatingArtifacts existem (story + p2p
			domain-model); o cross-ref reverso WI-151→def-078 resolve no disco.
			[uq-01 WHY / uq-05 LIMITAÇÕES / uq-06 UL / uq-07 ZERO PLACEHOLDER]:
			OK — gate vs consequência nomeados na UL da jornada; a limitação
			(manual-only) é o próprio warn declarado.

			[uq-09 SECTION GATES]: PG deferred-decision aplicado; conteúdo
			autorado LITERAL pelo arquiteto com decisões de forma pré-cravadas
			(manual-only; task-spec-only para os WIs irmãos); arco de
			checkpoint com STOPs executados (G2 stop-on-divergence; schema-fix
			stop) — pattern batch do serializationRule (precedente def-074).
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "def-078 é manual-only: nenhum trigger non-manual-review. Warn ACEITO por decisão de forma do arquiteto — não silenciado, não 'consertado' com trigger decorativo."
			rationale:   "Justificativa canônica no triggerCalibrationRationale do def-078 (não reaberta aqui): sem predicado de disco livre de falso-positivo para 'a ordem foi decidida'; trigger de conteúdo dispararia espúrio (p2p já referencia authority/alçada); trigger de existência cravaria número de WI irmão intra-lote, frágil contra o G2. A revisita real está acoplada ao WI-151 via semanticPrerequisites — o def não depende de vigilância automática para ser encontrado: ele bloqueia o passo de triagem da fatia que o cita."
		}]
	}

	summary: """
		def-078 (ordem da aprovação: gate vs consequência): deferimento
		consciente de DECISÃO DE MODELO do founder, exposto pela 1ª domain
		story — a jornada vivida aprova ANTES do pedido; o modelo atual (bdg)
		dispara DEPOIS do commitment. VEREDITO: stable, 0 fail, 1 warn
		DECLARADO e aceito (tq-def-03 manual-only, justificado no
		triggerCalibrationRationale; revisita acoplada ao WI-151 como
		pré-requisito do passo de triagem). Round de schema-fix gated
		registrado (blastRadius cross-context→cross-artifact, reautoria do
		arquiteto, sem auto-correção).
		"""

	singleRoundRationale: """
		Round único proporcional: o def materializa conteúdo autorado LITERAL
		pelo arquiteto com as decisões de forma pré-cravadas e dois STOPs de
		protocolo executados durante a autoria (G2 e schema-fix) — a revisão
		substantiva da calibração já aconteceu no próprio ciclo de reautoria;
		o round confirmou conformância e declarou o warn residual sem findings
		novos.
		"""
}
