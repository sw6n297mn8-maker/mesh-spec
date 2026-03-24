package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

canvasSchema: build_time.#SelfReviewReport & {
	reportId: "srr-canvas-schema"

	artifactPath:       "architecture/artifact-schemas/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-03-23T00:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Canvas schema revisado por sub-agente isolado (sem acesso ao
		histórico da conversa) contra 8 critérios universais (uq-01 a
		uq-08) e 3 critérios type-specific de artifact-schema (tq-as-01
		a tq-as-03). Sub-agente verificou: rationales explicam WHY não
		WHAT; termos ancorados em mecanismos Mesh (sh-NN, ce-NN, cc-NN,
		dp-08); referências cruzadas validadas contra stakeholder-map.cue
		e domain-definition.cue; consistência com P0/P12 de
		design-principles.cue; campos consumidos por
		bounded-context-completeness.cue (classification, hasDomainAgents,
		hasSyncSurface, hasAsyncSurface) presentes e tipados; _schema.location
		preenchido; 4 critérios tq-cv-NN acionáveis; rationale do conjunto
		explica cobertura das 3 dimensões downstream. Zero findings em
		todas as verificações.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Sub-agente isolado avaliou canvas.cue contra critérios universais (uq-01 a uq-08) e type-specific (tq-as-01 a tq-as-03). Schema declara _schema.location com canonicalPathRegex para contexts/<id>/canvas.cue. Tipos #CanvasStakeholder, #CanvasCostContribution e #IncentiveParticipant usam referências cruzadas (sh-NN, ce-NN, cc-NN) com regex constraints consistentes com IDs existentes no repositório. Campos consumidos por bounded-context-completeness.cue (classification, capabilities flags) estão presentes. 4 critérios tq-cv-NN são acionáveis e cobrem contorno, rastreabilidade e alinhamento econômico. Zero findings."
	}]

	findings: {}

	summary: "Canvas artifact schema estável no round 1 via sub-agente isolado. Schema define estrutura forte com referências cruzadas a sh-NN, ce-NN e cc-NN, incentive analysis alinhada com dp-08, e campos consumidos por bounded-context-completeness.cue. Zero findings em 11 critérios avaliados."
}
