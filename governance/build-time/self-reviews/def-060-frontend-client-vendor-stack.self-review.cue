package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def060SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-def-060-frontend-client-vendor-stack"

	artifactPath:       "architecture/deferred-decisions/def-060-frontend-client-vendor-stack.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-14"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		DD criado junto com adr-150 (item 7) e revisado como parte do bundle no
		isolated-subagent review do adr-150 (2 rounds, stable) -- vendor-
		neutralidade, waiver tq-def-03 e ausencia de colisao com def-043
		confirmados la. Este self-report registra a checagem anti-catch-all e a
		calibracao do trigger: trade-off articulado (vendor envelhece / escolher
		antes do frontend-runtime e especular) + condicao de revisita declarada
		(founder seleciona no bootstrap do frontend-runtime). Decisao do founder
		no arco de ratificacao do adr-150 (PR #142).
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Checagem anti-catch-all do CLAUDE.md: deferimento consciente (trade-off
			articulado: vendor troca de lider em ~18-24 meses, selecionar antes do
			frontend-runtime e especular; revisita quando o repo bootstrar), nao WI
			rotineiro nem tension-entry. manual-review-only justificado (waiver
			tq-def-03 explicito): nenhum sinal de revisita e machine-evaluable pelo
			runner do mesh-spec (frontend-runtime e repo futuro invisivel ao grep;
			watchpoints sao fatos de ecossistema externo). Categoria distinta de
			def-061. originatingArtifacts aponta adr-150. cue vet OK.
			"""
	}]

	findings: {}

	summary: """
		def-060 registra o deferimento da selecao de vendor de cliente de frontend
		(framework web, mobile sync, runtime de orquestracao de agente IA distinto
		do WorkflowPort/def-043, design system, specs de tela) ao frontend-runtime,
		originado pelo adr-150 (filtro spec×runtime do adr-139). manual-review-only
		com waiver tq-def-03; watchpoints datados como criterios. Estavel em 1 round.
		"""
}
