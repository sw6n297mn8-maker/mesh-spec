package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr030: build_time.#SelfReviewReport & {
	reportId: "srr-adr-030-shared-strategic-classification"

	artifactPath:       "architecture/adrs/adr-030-shared-strategic-classification.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-03-24T00:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		ADR-030 revisado por sub-agente isolado contra 8 critérios
		universais (uq-01 a uq-08) e 3 critérios type-specific de ADR
		(tq-adr-01 a tq-adr-03). Sub-agente verificou: alternativa
		rejeitada explícita no context (manter #BCClassification no
		canvas e evoluir apenas subdomain — rejeitada por perpetuar
		ownership incorreto e impedir importação limpa); metadata de
		risco (reversibility high, blastRadius cross-artifact) reflete
		a decisão real — schemas não instanciados, custo de migração
		zero, impacto em 3 artefatos dentro do mesmo domínio
		arquitetural; affectedArtifacts verificados (shared-types/
		strategic-classification.cue será criado como output direto,
		canvas.cue e subdomain.cue existem); rationale explica WHY
		(ownership de vocabulário, importabilidade, governança como
		código); referências P0, P1 e P12 existem em
		design-principles.cue; supersedes adr-029 verificado como
		existente; ubiquitous language consistente ao longo do
		artefato; zero placeholders. Zero findings.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Sub-agente isolado avaliou ADR-030 contra critérios universais (uq-01 a uq-08) e type-specific (tq-adr-01 a tq-adr-03). Context menciona alternativa rejeitada (manter #BCClassification no canvas) com justificativa de ownership incorreto e acoplamento. reversibility high e blastRadius cross-artifact consistentes — schemas não instanciados, 3 artefatos afetados no domínio arquitetural. affectedArtifacts: strategic-classification.cue será criado, canvas.cue e subdomain.cue existem. principlesApplied P0, P1 e P12 verificados contra design-principles.cue. supersedes adr-029 validado. Zero findings."
	}]

	findings: {}

	summary: "ADR-030 estável no round 1 via sub-agente isolado. Decisão structural de extrair vocabulário estratégico para shared-types e evoluir subdomain schema, com alternativa documentada, metadata de risco consistente, referências cruzadas válidas e supersession de ADR-029. Zero findings em 11 critérios avaliados."
}
