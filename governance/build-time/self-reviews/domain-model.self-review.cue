package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainModelSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-domain-model-schema"

	artifactPath:       "architecture/artifact-schemas/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"

	generatedAt: "2026-04-01"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 0
		summary: """
			Sub-agente isolado avaliou #DomainModel contra 8 critérios
			universais + 3 critérios específicos de artifact-schema
			(tq-as-01/02/03). Findings aceitos: uq-02 (fail) — header
			comment não ancorava decisões de design nos princípios Mesh
			(P3, P10, P1), schema passava teste de substituição; uq-05
			(warn) — limitações conhecidas não declaradas (Saga/Process
			Manager sem building block first-class, #DomainTypeField sem
			validação cross-glossary). Findings rejeitados: uq-08 (fail)
			— 'domain-model' ausente de #ArtifactType, rejeitado como
			falso-positivo porque mudança companion no mesmo commit
			adiciona o tipo; tq-as-02 (fail) — critérios tq-dm-11/12/15/16
			delegam a 'runner', rejeitado como falso-positivo porque
			pattern idêntico ('Validação por runner') já aprovado no
			canvas schema (tq-cv-10, tq-cv-12) e os tests descrevem
			a lógica de verificação concretamente.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correções aplicadas ao header comment: (1) seção 'Ancoragem
			nos princípios Mesh' adicionada com referências a P3
			(behavior-first/Event Log como SoT), P10 (lifecycle guards,
			policies como gates táticos), P1 (prefixed refs como
			type-safety por construção); (2) seção 'Limitações conhecidas'
			adicionada documentando ausência de Saga/Process Manager e
			dependência de #Glossary para cross-glossary validation;
			(3) rationale de _qualityCriteria atualizado para referenciar
			'canvas Mesh' e 'gates determinísticos'. Findings rejeitados
			(uq-08, tq-as-02) mantidos com justificativa nos round
			details. Zero findings remanescentes. findings: {} representa
			ausência de findings abertos no estado final; histórico
			completo está em roundDetails.
			"""
	}]

	// findings: {} representa estado final sem findings abertos.
	// Histórico completo (4 findings no round 1: 2 aceitos e corrigidos,
	// 2 rejeitados como falso-positivo) está documentado em roundDetails.
	// Schema #SelfReviewFindings não suporta status por finding
	// (accepted/rejected/resolved) — limitação conhecida do schema
	// self-review-report.cue.
	findings: {}

	summary: """
		Schema #DomainModel (WI-020) para DDD tactical design com 16
		building block types, 16 quality criteria e prefixed refs por
		catálogo. Estabilizou em 2/4 rounds via isolated-subagent.
		Round 1: 4 findings — 2 aceitos (uq-02 ancoragem Mesh no
		header comment, uq-05 limitações não declaradas) e 2
		rejeitados como falso-positivo (uq-08 mudança companion em
		quality-criteria.cue, tq-as-02 pattern 'validação por runner'
		já aprovado no canvas schema). Round 2: correções aplicadas
		(ancoragem Mesh, limitações conhecidas), zero findings
		remanescentes. Ajustes do founder pós-self-review: typo
		tq-dm-08 corrigido, #DomainEvent separado em union
		discriminada (internal/published), sourceContext tipado como
		#SourceContextRef (aceita ext-*).
		"""
}
