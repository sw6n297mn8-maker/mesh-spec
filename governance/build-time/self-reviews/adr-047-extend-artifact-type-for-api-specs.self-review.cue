package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr047SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-adr-047"

	artifactPath:       "architecture/adrs/adr-047-extend-artifact-type-for-api-specs.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-09"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		ADR puramente meta-estrutural: estende um enum fechado
		(#ArtifactType) com 2 valores e adiciona 2 abreviações
		canônicas no comment block do mesmo arquivo. Superfície
		semântica compacta — não há lógica, não há constraints
		inter-artefato, não há ambiguidade de interpretação
		sobre o que está sendo decidido. Os 11 critérios
		aplicáveis (uq-01..uq-08 + tq-adr-01/02/03) foram
		avaliados em uma passada; o artefato não tem dimensões
		que um round adicional revelaria. Não há tensão entre
		critérios nem dependência de evidência externa.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round único sobre adr-047. Aplicados uq-01 a uq-08 +
			tq-adr-01/02/03.

			- uq-01 (rationale como WHY, fail): PASS. O campo
			  rationale explica por que resolver o bloqueador na
			  ordem de detecção é mais barato e mais honesto do
			  que carregar dependência não-resolvida — não descreve
			  o que a ADR faz.

			- uq-02 (ancoragem, fail): PASS. Context ancora em
			  adr-040 (split ontologia/enforcement), adr-041
			  (structural-check v1 com artifactType referenciando
			  #ArtifactType), quality-criteria.cue linhas 20-37
			  (enum) e linhas 42-46 (abreviações), WI-027 v2
			  (templateRef tmpl-create-convention@v1).

			- uq-03 (referências verificáveis, fail): PASS. Paths
			  citados: architecture/artifact-schemas/quality-criteria.cue,
			  architecture/artifact-schemas/structural-check.cue,
			  architecture/artifact-schemas/api-spec.cue,
			  architecture/adrs/adr-040*.cue, adr-041*.cue,
			  adr-046*.cue — todos existem no repositório.

			- uq-04 (alinhamento com princípios, fail): PASS. P0
			  (fonte única para identidade de tipo), P1 (schema
			  declara tipo), P12 (governance as code — enum é
			  contrato). Aplicação específica, não genérica.

			- uq-05 (limitações declaradas, warn): PASS. Known gaps
			  declarados em consequences: ausência de instâncias de
			  #StructuralCheck após commit; comment block de
			  abreviações como texto livre sem enforcement
			  automático; fronteira regulatória explicitamente
			  deferida para ADR da convenção.

			- uq-06 (rationale específico, fail): PASS. Rationale
			  referencia bloqueador mecânico de cue vet em
			  #StructuralCheck.artifactType, não é frase genérica.

			- uq-07 (naming, fail): PASS. Filename
			  adr-047-extend-artifact-type-for-api-specs.cue segue
			  canonicalPathRegex ^architecture/adrs/adr-[0-9]{3}-
			  [a-z0-9-]+\\.cue$.

			- uq-08 (conformidade ao schema, fail): PASS. Todos os
			  campos obrigatórios de #ADR presentes: id, title,
			  date, decisionClass, decider, context, decision,
			  consequences, status, reversibility, blastRadius,
			  affectedArtifacts, principlesApplied, rationale.
			  supersedes presente como lista vazia.

			- tq-adr-01 (alternativas com rejeição, fail): PASS.
			  Context lista 4 alternativas (a-d) com justificativa
			  de rejeição para cada: umbrella api-spec, adiar para
			  B.2, sem structural-check, string aberto.

			- tq-adr-02 (metadata reflete decisão, fail): PASS.
			  reversibility=high é consistente com decisão aditiva
			  em enum sem consumidores existentes.
			  blastRadius=cross-artifact é consistente com mudança
			  em quality-criteria.cue que desbloqueia
			  structural-check.cue como consumidor.

			- tq-adr-03 (paths reais, fail): PASS.
			  affectedArtifacts contém
			  architecture/artifact-schemas/quality-criteria.cue —
			  arquivo existente que será modificado no mesmo commit.

			Conclusão: 0 fail, 0 warn, 0 info. Estável em 1 round.
			"""
	}]

	findings: {}

	summary: """
		Self-review stable em 1 round para adr-047 — ADR
		meta-estrutural que estende #ArtifactType com 2 valores
		(openapi-spec, asyncapi-spec) e adiciona 2 abreviações
		canônicas (oas, aas) em quality-criteria.cue. Promovido
		a B.0 do WI-027 como pré-requisito mecânico de B.2
		(structural-check da convenção api-spec). 11 critérios
		avaliados (uq-01..uq-08 + tq-adr-01/02/03), zero
		findings. Artefato com superfície semântica compacta —
		um round cobre todas as dimensões sem residual.
		"""
}
