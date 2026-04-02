package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentSpecSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-agent-spec-schema"

	artifactPath:       "architecture/artifact-schemas/agent-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"

	generatedAt: "2026-04-02"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente isolado avaliou #AgentSpec contra 8 critérios
			universais + 3 critérios específicos de artifact-schema
			(tq-as-01/02/03). Finding aceito: tq-as-02 (fail) —
			tq-ag-10 test vago sobre 'classes de incerteza que o
			operationalScope pode gerar'; corrigido para vincular
			coerência com role e operationalScope, sem exigir
			cobertura exaustiva de #EscalationCategory. Finding
			rejeitado: tq-as-02 (fail) — tq-ag-12 test descrito
			como soft com exemplos; header já declara como limitação
			conhecida, critério é soft por design, exemplos concretos
			tornam-no suficientemente acionável para warn.
			Observação aceita: abreviação canônica 'ag' adicionada
			ao comentário de quality-criteria.cue.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correções aplicadas: (1) tq-ag-10 test reformulado para
			verificar coerência entre escalationConditions, role e
			operationalScope em vez de exigir cobertura exaustiva.
			(2) Abreviação 'ag' adicionada ao comentário canônico
			em quality-criteria.cue. Finding tq-ag-12 rejeitado com
			justificativa — limitação já declarada no header. Zero
			findings no round 2. Condição de estabilidade satisfeita.
			"""
	}]

	findings: {}

	summary: """
		Schema #AgentSpec para definição operacional de agentes por BC.
		4 campos novos informados por lenses: governanceRef (ponte para
		governance envelope), autonomyLevel por ação (Sheridan 4 níveis),
		inputTrustLevel por ação (3 níveis de confiança), escalationConditions
		(6 categorias de incerteza). requiresHumanConfirmation removido por
		redundância com autonomyLevel (P0). 13 quality criteria
		(tq-ag-01 a tq-ag-13). _minimumAuditFields fecha gap regulatory-grade.
		Estabilizou em 2 rounds após correção de tq-ag-10.
		"""
}
