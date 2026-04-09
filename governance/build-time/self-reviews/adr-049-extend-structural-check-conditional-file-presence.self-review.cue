package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr049SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-adr-049"

	artifactPath:       "architecture/adrs/adr-049-extend-structural-check-conditional-file-presence.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-09"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		ADR estende schema existente com 4º kind — decisão
		diretamente derivada da análise de expressividade dos
		kinds v1 (todos intra-artifact) contra requisito
		cross-artifact concreto (api-spec-convention). A
		superfície semântica é estreita: um kind novo com 4
		campos, dois checks instanciados. Critérios aplicáveis
		(uq-01..uq-08 + tq-adr-01/02/03) são verificáveis em
		uma passada — não há dimensão que round adicional
		revelaria.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round único sobre adr-049. Aplicados uq-01 a uq-08 +
			tq-adr-01/02/03.

			- uq-01 (rationale como WHY, fail): PASS. Rationale
			  explica por que o kind é sobre arquivo por path (não
			  artefato abstrato) e por que extensão é necessária
			  (kinds v1 todos intra-artifact).

			- uq-02 (ancoragem, fail): PASS. Context ancora em
			  adr-041 (v1 schema shape, modelo de crescimento
			  orgânico), adr-048 (convenção motivadora), adr-040
			  (separação structural/advisory), api-spec-convention
			  (norma sendo enforçada), P10, P12.

			- uq-03 (referências verificáveis, fail): PASS. Paths
			  citados existem: architecture/artifact-schemas/
			  structural-check.cue, architecture/structural-checks/
			  canvas.cue, architecture/conventions/
			  api-spec-convention.cue (commit 15d75f4). ADRs
			  040/041/048 existem.

			- uq-04 (alinhamento com princípios, fail): PASS. P10
			  (rule como dado estruturado, não snippet — check
			  determinístico), P12 (governance as code — kind é
			  CUE declarativo versionado).

			- uq-05 (limitações declaradas, warn): PASS. Known
			  gaps declarados: runner não existe, conditionField
			  string documental, scope matching depende de
			  wildcards consistentes.

			- uq-06 (rationale específico, fail): PASS. Rationale
			  referencia hasSyncSurface/hasAsyncSurface, api.yaml/
			  async-api.yaml, modelo de crescimento orgânico de
			  adr-041, e sequenciamento B.1→B.2.

			- uq-07 (naming, fail): PASS. Filename
			  adr-049-extend-structural-check-conditional-file-
			  presence.cue segue canonicalPathRegex.

			- uq-08 (conformidade ao schema, fail): PASS. Todos
			  os campos obrigatórios de #ADR presentes.

			- tq-adr-01 (alternativas, fail): PASS. 4 alternativas
			  (a-d) com justificativa de rejeição individual.

			- tq-adr-02 (metadata reflete decisão, fail): PASS.
			  reversibility=high (kind aditivo, runner não existe),
			  blastRadius=cross-artifact (governa relação
			  canvas↔api-specs em todos os BCs).

			- tq-adr-03 (paths reais, fail): PASS.
			  affectedArtifacts contém structural-check.cue e
			  structural-checks/canvas.cue — ambos modificados
			  no mesmo commit.

			Conclusão: 0 fail, 0 warn, 0 info. Estável em 1 round.
			"""
	}]

	findings: {}

	summary: """
		Self-review stable em 1 round para adr-049. Extensão do
		schema de structural-check com 4º kind
		conditional-file-presence, motivado pelo enforcement da
		convenção api-spec (B.2 de WI-027). 11 critérios
		avaliados (uq-01..uq-08 + tq-adr-01/02/03), zero
		findings. Delta: 1 kind novo, 1 rule type, 2 instâncias
		de check.
		"""
}
