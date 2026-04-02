package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentGovernanceSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-agent-governance-schema"

	artifactPath:       "architecture/artifact-schemas/agent-governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-02"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação inicial do schema proposto pelo founder. Dois findings fail:
			(1) #NonEmptyString redefinido no final do arquivo — já existe em
			agent-spec.cue no mesmo package artifact_schemas, violação de P0
			(zero duplicação). (2) Listas opcionais categoryDefaults e
			autonomyOverrides usam [...#Type] permitindo lista vazia quando
			presente — padrão do codebase é [#Type, ...#Type] para absent-or-nonempty.
			"""
	}, {
		round:     2
		failCount: 4
		warnCount: 1
		infoCount: 0
		summary: """
			Correções do round 1 aplicadas. Revisão aprofundada com founder
			identificou 4 fails adicionais: (1) tq-gv-14 dizia "mutations
			financeiras" mas schema não distingue mutation financeira de
			não-financeira — corrigido para toda mutation como default
			conservador. (2) Ponte governanceRef ↔ agentRef era implícita —
			tq-gv-06 fortalecido para validar bidirecionalidade e convenção
			documentada no header. (3) Faltava critério de unicidade de
			envelope por agentRef — adicionado tq-gv-15. (4) tq-gv-12 como
			warn sem justificativa explícita — rationale atualizado para
			documentar como escolha de rollout com estado final desejado.
			1 warn: tq-gv-01 assume progressão por posição na lista sem
			explicitar que runner usa ordem da enum.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Todas as correções do round 2 aplicadas. tq-gv-01 test atualizado
			para explicitar que runner usa ordem fixa da enum #LifecycleStage
			(onboarding < validation < operational < mature). Verificação
			final: 15 quality criteria (tq-gv-01..15), _schema com location
			para ambos os tipos, convenção de naming bidirecional documentada,
			#NonEmptyString removido, listas opcionais com padrão correto.
			Schema conforma com artifact-schema.cue meta-schema. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		Schema #AgentGovernanceGlobal + #AgentGovernanceEnvelope (ADR-037)
		com 15 quality criteria. Estabilizou em 3 rounds após correções:
		remoção de #NonEmptyString duplicado, padrão de listas opcionais,
		generalização de tq-gv-14 para toda mutation, ponte bidirecional
		spec↔envelope em tq-gv-06, unicidade de envelope em tq-gv-15,
		justificativa de rollout em tq-gv-12, e ordinal explícito em tq-gv-01.
		"""
}
