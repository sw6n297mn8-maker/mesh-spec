package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

qualityCriteriaGoldenExampleType: build_time.#SelfReviewReport & {
	reportId: "srr-quality-criteria-golden-example-type"

	artifactPath:       "architecture/artifact-schemas/quality-criteria.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-08"

	roundsExecuted: 1
	maxRounds:      3
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review da extensao de quality-criteria.cue para WI-136 (adr-145 item 3): #ArtifactType +=
			"golden-example" (append nao-destrutivo apos aggregate-manifest) + abreviacao "ge" no bloco de
			convencao de ids. Sem isso o tipo golden-example nao entra no regime de self-review (tq-ge-* inertes).
			"ge" nao colide com nenhuma abreviacao existente; tq-ge casa o regex ^(uq|tq-[a-z]{2,3})-[0-9]{2}$.
			Nenhuma definicao existente foi alterada (so 1 membro de enum + 1 token de comentario adicionados).
			cue vet pass.
			"""
	}]

	findings: {}

	summary: """
		quality-criteria.cue: #ArtifactType += golden-example + abbrev ge (append nao-destrutivo) — habilita o
		regime de self-review do novo tipo (adr-145 item 3). Self-review LIMPO (0 fail/warn/info). NOTA: o gate
		check-self-review nao exigia SRR fresco (chaveia artifactPath >= 1 SRR; ha 6 SRRs de quality-criteria);
		este e per-change por disciplina/transparencia (paridade adr-144).
		"""

	singleRoundRationale: """
		1 round: append nao-destrutivo de 1 membro de enum + 1 abreviacao, sem alterar nenhuma definicao
		existente; "ge" sem colisao e tq-ge dentro do regex de #QualityCriterion. cue vet pass. Nada a iterar.
		"""
}
