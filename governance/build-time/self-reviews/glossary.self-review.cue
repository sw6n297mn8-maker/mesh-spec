package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

glossarySelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-glossary-schema"

	artifactPath:       "architecture/artifact-schemas/glossary.cue"
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
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary: """
			Sub-agente isolado avaliou #Glossary contra 8 critérios
			universais + 3 critérios específicos de artifact-schema
			(tq-as-01/02/03). Finding aceito: uq-01 (fail) — rationale
			de tq-gl-01 descrevia consequência mecânica ('quebra
			integridade referencial') em vez de WHY; corrigido para
			'Code é o identificador que agentes e tooling consomem
			para referenciar termos programaticamente; duplicidade
			torna a referência ambígua.' Finding aceito: uq-05 (warn)
			— limitação sobre #ArtifactType não incluir 'glossary'
			não estava declarada no header; adicionada à seção de
			limitações conhecidas.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correções aplicadas: (1) tq-gl-01 rationale corrigido de
			consequência mecânica para WHY conceitual. (2) Limitação
			sobre #ArtifactType adicionada ao header comment. Ambas
			correções são editoriais — não alteraram estrutura nem
			semântica do schema. Zero findings no round 2. Condição
			de estabilidade satisfeita.
			"""
	}]

	// Findings representa estado final (round 2): zero findings abertos.
	// Histórico completo nos roundDetails acima.
	findings: {}

	summary: """
		Schema #Glossary para Ubiquitous Language por BC. 13 quality
		criteria (tq-gl-01 a tq-gl-13), bilingual mapping (termEn),
		cross-layer mapping (layerMapping), rejected alternatives,
		refs ao domain model com 11 prefixos. Estabilizou em 2 rounds
		após correção de rationale (uq-01) e declaração de limitação
		(uq-05). Dois red teams adversariais executados antes do
		self-review — 26 findings no primeiro round, 12 no segundo;
		todos tratados (corrigidos ou aceitos com justificativa).
		"""
}
