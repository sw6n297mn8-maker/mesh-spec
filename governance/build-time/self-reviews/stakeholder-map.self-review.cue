package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

stakeholderMapSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-stakeholder-map-schema"

	artifactPath:       "architecture/artifact-schemas/stakeholder-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"

	generatedAt: "2026-04-02"

	roundsExecuted: 4
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 2
		infoCount: 0
		summary: """
			Sub-agente isolado avaliou #StakeholderMap contra 8 critérios
			universais + critérios de artifact-schema. Finding aceito:
			prefixo dos quality criteria usava tq-sh-* em vez de tq-sm-*
			(abreviação canônica em quality-criteria.cue é sm); corrigido
			para tq-sm-01..08. Finding aceito: schema é breaking change
			do existente (id→code, #StakeholderType→#StakeholderCategory,
			campos removidos) sem documentação de evolução; corrigido com
			header detalhado de evolução v0→v1. Warn aceito: tq-sm-04 e
			tq-sm-07 sem 'Validação por runner' no test; corrigido. Warn
			aceito: campo code no root de singleton — inconsistente com
			domain-definition (outro singleton sem code); removido.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 2
		infoCount: 1
		summary: """
			Correções de R1 aplicadas. Novos findings: warn — codes
			internos (int-*, pp-*, mv-*) usam slug mas refs globais
			(sh-NN, ce-NN) usam numérico, inconsistência interna;
			aceito com comentários explícitos de que codes internos são
			scoped ao stakeholder (não globais), slug por legibilidade.
			Warn — sem critério para unicidade de desiredOutcomes entre
			stakeholders; aceito como info (strings livres, comparação
			semântica não operacionalizável por runner). Info —
			desiredOutcomes duplicados; aceito por design.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 1
		infoCount: 1
		summary: """
			Warn — interactsWith do schema antigo capturava relações
			inter-stakeholder, schema novo não tem equivalente; aceito
			como decisão de design — relações capturadas implicitamente
			via canvas (co-ocorrência) e manipulationVectors
			(attackSurface); adicionado ao header 'O que NÃO vive aqui'.
			Info — tq-sm-08 não inclui platform-operator como categoria
			obrigatória; aceito (obrigatoriedade de platform-operator é
			decisão de design, não critério de runner).
			"""
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 2
		summary: """
			Info — #PainSeverity 'annoying' é coloquial; aceito (tom
			consistente com enums do repositório). Info — mesmo costRef
			pode aparecer em múltiplos stakeholders; correto por design
			(mesmo custo afeta múltiplos stakeholders com severidades
			diferentes). Zero fail/warn. Condição de estabilidade
			satisfeita.
			"""
	}]

	findings: {}

	summary: """
		Schema #StakeholderMap evolução v0→v1. Principais mudanças:
		taxonomia #StakeholderType→#StakeholderCategory (papel econômico
		em vez de natureza jurídica), id→code (alinhamento com package),
		concerns→interests+painPoints (com rastreabilidade a custos
		canônicos ce-NN), adição de incentiveProfile com
		manipulationVectors condicionais (dp-08). 7 quality criteria
		(tq-sm-01 a tq-sm-07). tq-sm-08 removido após R3 (expectativa
		de instância, não critério de schema). Estabilizou em 4 rounds.
		Propagação: canvas tq-cv-02 (id→code), instância
		domain/stakeholder-map.cue (id→code).
		"""
}
