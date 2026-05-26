package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

repoStructureSchemaExemptZones: build_time.#SelfReviewReport & {
	reportId: "srr-repo-structure-schema-exempt-zones"

	artifactPath:       "architecture/artifact-schemas/repo-structure.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Delta (adr-098): #Scope ganha schemaExemptZones?: [...string & !=""] —
			zonas engine/config DENTRO de validated mas FORA da classificacao por
			artifact-schema-instance. Aprovado pelo founder antes da escrita.

			Conformancia (#ArtifactSchema / meta-schema): o campo e OPCIONAL (sufixo
			?) e default-ausente => ADITIVO; instancias de repo-structure de outros
			repos do portfolio (sem o conceito) permanecem validas sem alteracao —
			zero impacto cross-repo. Tipo [...string & !=""] coerente com validated
			e excluded (mesmo shape de lista de prefixos nao-vazios). Posicionado
			entre excluded e rationale, com comentario de proposito + referencia a
			adr-098. _schema.location do #RepoStructure intocado.

			Verificacao empirica antes da proposta: cue vet ./... EXIT 0 (schema +
			instancia governance/repo-structure.cue que popula schemaExemptZones com
			as 3 zonas); runner --self-test PASS; o runner le o campo via
			exempt_zones() e o aplica em file_classification sem regressao
			(inventario de orfaos = 0).
			"""
	}]

	findings: {}

	summary: """
		Adiciona schemaExemptZones?: [...string] ao #Scope (repo-structure schema)
		per adr-098 — campo opcional/aditivo que declara as zonas engine/config
		excluidas da classificacao por artifact-schema-instance. Sem findings
		fail/warn; aditivo e default-seguro (outros repos intactos); cue vet 0 +
		runner self-test PASS.
		"""

	singleRoundRationale: """
		Uma rodada basta: o delta e um unico campo opcional aditivo, cujo shape e
		semantica derivam diretamente de adr-098 (aprovado pelo founder antes da
		escrita) e cuja seguranca (aditividade cross-repo, leitura pelo runner,
		orfaos=0) foi verificada de forma deterministica por cue vet + self-test.
		Sem espaco de decisao aberto a red-team adicional.
		"""
}
