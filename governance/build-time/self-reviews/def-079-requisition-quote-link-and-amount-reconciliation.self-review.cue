package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def079RequisitionQuoteLinkAndAmountReconciliation: build_time.#SelfReviewReport & {
	reportId: "srr-def-079-requisition-quote-link-and-amount-reconciliation"

	artifactPath:       "architecture/deferred-decisions/def-079-requisition-quote-link-and-amount-reconciliation.cue"
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
			Round 1 — self-review do def-079 (elo formal requisição↔cotação
			p2p↔ssc + reconciliação approve-amount vs quote-amount), nascido
			como consequência de governança da decisão do founder sobre o
			residual #1 do review isolado do adr-174: amount entra como CAMPO
			de entrada agora; o elo e a reconciliação são fatia futura.

			[uq-08 CONFORMÂNCIA #DeferredDecision]: OK. cue vet EXIT=0. Enums
			CONFERIDOS contra o schema ANTES da escrita (lição do def-078):
			severity medium ∈ {low,medium,high}; blastRadius cross-artifact ∈
			{local,cross-artifact,cross-cutting,repo-wide}. Número def-079
			re-derivado via freshness --assert def=79 (G2): próximo-livre em
			origin/main @ 0895891.

			[ANTI-CATCH-ALL]: OK. Deferimento consciente genuíno — decisão de
			DESENHO adiada (shape do elo cross-BC + estratégia de
			reconciliação) com trade-off articulado; não é WI (a fatia p2p↔ssc
			não está desenhada — registrá-la como WI cravaria escopo
			não-decidido), não é tensão, não é bug (o portão funciona; o que
			falta é verificação de procedência do valor).

			[tq-def-01 TRADE-OFF]: OK. Custo evitado: desenhar contrato
			cross-BC p2p↔ssc no meio da fatia da requisição, sem o mapa de
			cotações consultável (WI-152 pendente). Custo de continuar:
			janela em que approve-amount é entrada solta — divergência vs
			quote-amount possível e invisível até o elo fechar.

			[tq-def-02 CODIFICADO]: OK. Trigger manual-review conforma
			#TriggerStrict (reason substantiva > 40 runes).

			[tq-def-03 — FINDING WARN, ACEITO]: manual-only. Warn DECLARADO
			em findings.warn, não silenciado. Justificativa canônica no
			triggerCalibrationRationale: o gatilho real é a fatia p2p↔ssc
			abrir (sequenciamento do founder, não fato de disco); trigger de
			conteúdo sobre 'quoteRef' dispararia espúrio em prosa que já
			menciona o conceito; trigger de existência cravaria path de fatia
			não-desenhada. Revisita ancorada no ponto de uso: o rationale do
			amount em cmd-approve-purchase cita def-079 pelo número.

			[tq-def-04 COERENTE]: OK. medium (portão funciona; risco é
			divergência de valor não-verificada) / cross-artifact (p2p ↔ ssc
			concretos). [uq-03 REFS]: originatingArtifacts existem (adr-174 no
			working tree da mesma fatia + p2p domain-model); cross-ref reverso
			cmd-approve-purchase → def-079 resolve. [uq-07]: zero placeholder.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "def-079 é manual-only: nenhum trigger non-manual-review. Warn ACEITO por decisão de forma — não silenciado, não 'consertado' com trigger decorativo."
			rationale:   "Justificativa canônica no triggerCalibrationRationale do def-079: o gatilho real é a fatia p2p↔ssc abrir (decisão de sequenciamento do founder, não fato de disco); trigger de conteúdo sobre quoteRef dispararia espúrio (o conceito já vive em prosa no rationale do amount e neste próprio def); trigger de existência cravaria path de fatia não-desenhada, frágil contra renomeação e contra o G2. A revisita está ancorada no ponto de uso: quem abrir a superfície de aprovação encontra def-079 citado no rationale do amount."
		}]
	}

	summary: """
		def-079 (elo requisição↔cotação + reconciliação de valor): deferimento
		consciente nascido da decisão do founder sobre o residual #1 do adr-174
		— amount como campo de entrada AGORA, elo formal e reconciliação na
		fatia p2p↔ssc futura. VEREDITO: stable, 0 fail, 1 warn DECLARADO e
		aceito (tq-def-03 manual-only, justificado no
		triggerCalibrationRationale; revisita ancorada no rationale do amount).
		Enums conferidos contra o schema antes da escrita; G2 re-derivado.
		"""

	singleRoundRationale: """
		Round único proporcional: o def materializa consequência de governança
		de decisão explícita do founder (residual #1 do review isolado), com
		enums conferidos pré-escrita e o precedente def-078 como molde direto;
		o round confirmou conformância e declarou o warn residual sem findings
		novos.
		"""
}
