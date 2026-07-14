package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def081RequisitionOriginPrefill: build_time.#SelfReviewReport & {
	reportId: "srr-def-081-requisition-origin-prefill"

	artifactPath:       "architecture/deferred-decisions/def-081-requisition-origin-prefill-when-schedule-becomes-system-input.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-14"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 — def-081 (a migração de regime da origem da requisição,
			fatia adr-178) contra schema + PG do tipo:

			[conformidade] Enums de costOfDeferral CONFERIDOS contra o schema
			ANTES da escrita (lição def-078): severity 'low' ∈
			{low,medium,high}; blastRadius 'cross-artifact' ∈
			{local,cross-artifact,cross-cutting,repo-wide}. Combinação
			low+cross-artifact fora das suspeitas do tq (low+repo-wide,
			high+local). cue vet EXIT=0.

			[pertinência anti-catch-all] É deferimento consciente legítimo:
			trade-off articulado (custo evitado: integração planejamento/BIM
			antes de existir produto/fonte; custo de continuar: UX de
			digitação + vigilância do precedente) + condição codificada de
			revisita (cronograma vira input de sistema). NÃO é 'falta o
			agente' (declarado no texto: o que muda o regime é o PRESSUPOSTO
			do critério net-new, não a existência de preenchedor) — o
			enquadramento ESTREITO que o founder cravou na correção da D5.

			[linguagem] ZERO aspas atribuídas à adr-150: o def descreve o
			não-padrão como instituição do adr-178 sobre o qualificador 'por
			padrao' (mencionado sem pretensão de cláusula de exceção da lei)
			— a linguagem fabricada da formulação anterior ('braço net-new da
			lei', 'humanExceptionPrinciple') NÃO aparece.

			[triggers] manual-review com reason substantiva (fato de
			produto/integração fora do disco; predicados de conteúdo/
			existência teriam falso-positivo — mesmo padrão do def-079/080);
			âncora de revisita no ponto de uso (contrato v2 action-surface-p2p
			+ POST do api.yaml citam def-081 — verificado no disco).

			1 WARN DECLARADO (aceito per ordem do founder): tq-def-03 —
			trigger manual-only sem predicado automático; a reason articula
			por que automação não é viável (padrão aceito nos defs 076-080).
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review sem predicado automático — aceito e declarado: 'cronograma virou input de sistema' é fato de produto/integração que só o founder observa; predicados de disco teriam falso-positivo (conteúdo dispara em prosa que já menciona cronograma/BIM; existência cravaria path de integração não-desenhada)."
		}]
	}

	summary: """
		def-081 (open) registra ESTREITO a migração de regime da origem da
		requisição: digitação humana legítima HOJE (não-padrão net-new do
		adr-178 — fonte fora do sistema) → Generative Form padrão da adr-150
		QUANDO o cronograma físico virar input de sistema. Enums conferidos
		contra o schema antes da escrita; zero linguagem fabricada (nenhuma
		cláusula inexistente atribuída à lei); trigger manual-review com
		reason substantiva e âncora de revisita no ponto de uso. VEREDITO:
		stable, 0 fail, 1 warn declarado (tq-def-03, aceito).
		"""

	singleRoundRationale: """
		Round único proporcional: instância de tipo com schema + PG maduros,
		desenho cravado pelo founder (D5 corrigida) e verificação mecânica
		(enums, refs, vet) reproduzível nesta execução; o conteúdo normativo
		que o def acompanha é revisado pelo subagente isolado do adr-178 na
		mesma fatia.
		"""
}
