package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr028CanvasArtifactSchema: build_time.#SelfReviewReport & {
	reportId: "srr-adr-028-canvas-artifact-schema"

	artifactPath:       "architecture/adrs/adr-028-canvas-artifact-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-03-23T00:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		ADR-028 revisado por sub-agente isolado contra 8 critérios
		universais (uq-01 a uq-08) e 3 critérios type-specific de ADR
		(tq-adr-01 a tq-adr-03). Sub-agente verificou: rationale explica
		WHY (pivô de governança, extensão de P0/P12); termos ancorados em
		mecanismos Mesh (sh-NN, ce-NN, cc-NN, dp-08, sistema de
		completude); alternativa documentada (continuar sem schema,
		rejeitada por violar P0 e P12); risk metadata consistente
		(reversibility high porque nenhum BC existe, blastRadius
		cross-artifact porque afeta schema + completude);
		affectedArtifacts verificados (canvas.cue criado no mesmo commit,
		bounded-context-completeness.cue existe); P0 e P12 existem em
		design-principles.cue. Zero findings.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Sub-agente isolado avaliou ADR-028 contra critérios universais (uq-01 a uq-08) e type-specific (tq-adr-01 a tq-adr-03). Context documenta gap (canvas sem schema formal) e alternativa rejeitada (continuar sem schema viola P0/P12). Decision descreve estrutura com tipos referenciados (#CanvasStakeholder, #CanvasCostContribution, #IncentiveParticipant) e referências cruzadas a sh-NN/ce-NN/cc-NN. Reversibility high é consistente (nenhum BC existe). BlastRadius cross-artifact é consistente (schema + completude). Paths em affectedArtifacts verificados. Zero findings."
	}]

	findings: {}

	summary: "ADR-028 estável no round 1 via sub-agente isolado. Alternativa documentada, risk metadata consistente com decisão, affected artifacts verificados. Zero findings em 11 critérios avaliados."
}
