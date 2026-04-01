package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

canvasSchema: build_time.#SelfReviewReport & {
	reportId: "srr-canvas-schema-v2"

	artifactPath:       "architecture/artifact-schemas/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-04-01"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Canvas schema evoluído significativamente: adição de communication
		discriminada (6 subtipos com interactionMode), domain roles com
		archetypes, ownership com governanceScope, business decisions,
		assumptions/open questions com invalidationSignal, verification
		metrics, classification expandida com businessRole e wardleyEvolution.
		Sub-agente isolado avaliou contra 8 critérios universais e 3
		type-specific. Verificou: rationales WHY em sub-structs restaurados
		(conformidade CLAUDE.md), refs tipados com regex numérica compatível
		com dados existentes (sh-[0-9]{2}, ce-[0-9]{2}), #ContextOrSystemRef
		com regex que aceita BCs internos e ext-* para externos, 12 quality
		criteria acionáveis (vs 4 na versão anterior), _schema.location
		preservado. Zero findings.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Sub-agente isolado avaliou canvas.cue v2 contra uq-01..uq-08 e tq-as-01..tq-as-03. Schema expandido com #BCCommunication (6 subtipos inbound/outbound com interactionMode sync/async), #DomainRoles (6 archetypes), #BCOwnership (domainAgentSpec SoT local + governanceScope com autonomous/supervised/escalation), #BCClassification inline com businessRole e wardleyEvolution, #Assumption com invalidationSignal, #OpenQuestion com deadline tipado como data, #VerificationMetric. capabilityRef mantido com regex ampliada (cc-[0-9]+). Rationale restaurado em todas as sub-structs. 12 quality criteria (tq-cv-01..12) com testes acionáveis. #ContextOrSystemRef aceita BCs e ext-* para sistemas externos. Zero findings."
	}]

	findings: {}

	summary: """
		Canvas schema v2 estável no round 1 via sub-agente isolado.
		Evolução estrutural significativa: communication discriminada,
		domain roles, ownership com governance, estado epistêmico,
		classification expandida, 12 quality criteria. Correções de
		alinhamento: rationale em sub-structs, regex numérica para refs,
		#ContextOrSystemRef alinhado com #ExternalSystemRef do context-map.
		Zero findings em 11 critérios.
		"""
}
