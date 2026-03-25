package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr031: build_time.#SelfReviewReport & {
	reportId: "srr-adr-031-remove-subdomain-deprecation"

	artifactPath:       "architecture/adrs/adr-031-remove-subdomain-deprecation.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-03-24T00:00:00Z"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Sub-agente isolado avaliou ADR-031 contra 8 critérios universais (uq-01 a uq-08) e 3 type-specific (tq-adr-01 a tq-adr-03). Finding único: tq-adr-01 fail — context e decision não mencionam alternativa considerada e rejeitada. Demais 10 critérios passaram: rationale explica WHY (P0, drift, duplicação), referências P0 e ADR-030 válidas, metadata de risco consistente (high/cross-artifact), 6 affectedArtifacts verificados no repositório, ubiquitous language consistente, zero placeholders."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Context corrigido com alternativa explícita: manter união discriminada no schema sem instanciar deprecated — rejeitada por preservar complexidade morta e sugerir deprecação como caminho válido. tq-adr-01 resolvido. Verificação de regressão: demais 10 critérios continuam passando. Zero findings."
	}]

	findings: {}

	summary: "ADR-031 estável em 2/4 rounds via sub-agente isolado. Round 1 detectou ausência de alternativa (tq-adr-01); corrigido no context com alternativa rejeitada (manter união sem instanciar). Round 2 confirmou estabilidade — zero findings em 11 critérios."
}
