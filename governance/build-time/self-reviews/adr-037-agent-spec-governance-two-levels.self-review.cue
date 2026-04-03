package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr037SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-adr-037"

	artifactPath:       "architecture/adrs/adr-037-agent-spec-governance-two-levels.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"

	generatedAt: "2026-04-02"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary: """
			Sub-agente isolado avaliou ADR-037 contra 8 critérios
			universais + 3 critérios específicos de ADR (tq-adr-01/02/03).
			Finding aceito: tq-adr-01 (fail) — alternativas rejeitadas
			não explicitadas no context. Corrigido: adicionada alternativa
			'monolithic agent-spec with inline governance' com justificativa
			de rejeição. Finding aceito: uq-05 (warn) — dependência
			sequencial no #AgentGovernanceEnvelope schema não declarada
			explicitamente como limitação. Corrigido: adicionada nas
			consequences.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correções aplicadas: (1) Alternativa rejeitada adicionada
			ao context com justificativa. (2) Dependência sequencial
			no governance envelope schema declarada explicitamente nas
			consequences. Zero findings no round 2. Condição de
			estabilidade satisfeita.
			"""
	}]

	findings: {}

	summary: """
		ADR-037 registra decisão de governança de agentes em dois níveis
		(global + per-agent envelope) e schema #AgentSpec com 4 campos
		informados por lenses. Estabilizou em 2 rounds após adição de
		alternativa rejeitada (tq-adr-01) e declaração de dependência
		sequencial (uq-05).
		"""
}
