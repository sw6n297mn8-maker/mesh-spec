package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensGameTheoryApplied: build_time.#SelfReviewReport & {
	reportId: "srr-lens-game-theory-applied"

	artifactPath:       "architecture/lenses/lens-game-theory-applied.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Artefato parcial por instrução do founder — contém trigger e 13 concepts. uq-08 fail por seções obrigatórias ausentes."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Lente completa com 13 concepts, 12 reasoning steps (5 com appliesWhen), 3 exemplos, 6 principleIds, 10 relatedLenses, 8 limitations. uq-08 resolvido — todas as seções obrigatórias presentes. uq-01: rationales explicam WHY em todos os campos. uq-02: conceitos ancorados em mecanismos Mesh (adverse selection no bootstrap, multi-homing em construção civil, scoring como commitment device, bypass como defecção). uq-03: principleIds (ax-05/06/07, dp-02/05/09) e relatedLenses referenciam IDs existentes, concept dependsOn resolvem internamente. uq-06: terminologia consistente (multi-homing, bypass, adverse selection usados uniformemente). uq-07: zero placeholders. tq-ln-01 a tq-ln-04: condições testáveis, reasoning protocol específico para análise estratégica, exemplos concretos com cenários Mesh, limitações reais com alternativas."
	}]

	findings: {}

	summary: """
		Lente de Teoria dos Jogos Aplicada (lens-game-theory-applied) com
		status draft. 13 concepts, 12 reasoning steps, 3 exemplos, 6
		principleIds, 10 relatedLenses, 8 limitations. Construída em dois
		rounds: round 1 parcial (uq-08 fail), round 2 completo após
		founder fornecer seções restantes. Zero findings no round final.
		"""
}
