package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr048SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-adr-048"

	artifactPath:       "architecture/adrs/adr-048-api-spec-convention-conditional-presence.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-09"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		ADR cria a primeira convenção concreta do repositório —
		artefato singleton declarativo sem lógica, constraints
		de campo nem ambiguidade interpretativa. A substância da
		convenção foi revisada em 3 ciclos adversariais antes
		do self-review. Os 11 critérios aplicáveis
		(uq-01..uq-08 + tq-adr-01/02/03) foram avaliados em
		uma passada — a superfície semântica do ADR não tem
		dimensões que um round adicional revelaria.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round único sobre adr-048. Aplicados uq-01 a uq-08 +
			tq-adr-01/02/03.

			- uq-01 (rationale como WHY, fail): PASS. Rationale
			  explica por que a norma deve existir antes do
			  mecanismo e por que bicondicionalidade captura ambos
			  os sentidos de drift.

			- uq-02 (ancoragem, fail): PASS. Context ancora em
			  adr-040, adr-046, adr-047, canvas.cue capabilities,
			  api-spec.cue, tq-cv-11, P0, P1, P10, P12.

			- uq-03 (referências verificáveis, fail): PASS. Paths
			  citados existem: architecture/conventions/
			  api-spec-convention.cue (criado no mesmo commit),
			  architecture/artifact-schemas/canvas.cue,
			  api-spec.cue, ADRs 040/046/047.

			- uq-04 (alinhamento com princípios, fail): PASS. P0
			  (localização canônica única do protocolo), P1
			  (schemas existem antes da convenção), P10 (separação
			  structural/advisory), P12 (governance as code).

			- uq-05 (limitações declaradas, warn): PASS. Known
			  gaps declarados em consequences: enforcement
			  editorial/manual até B.2, shape livre sem #Convention,
			  sourceField documental, kind cross-artifact pode
			  exigir extensão.

			- uq-06 (rationale específico, fail): PASS. Rationale
			  referencia bicondicionalidade, canvas flags por nome,
			  e sequenciamento B.1→B.2.

			- uq-07 (naming, fail): PASS. Filename
			  adr-048-api-spec-convention-conditional-presence.cue
			  segue canonicalPathRegex.

			- uq-08 (conformidade ao schema, fail): PASS. Todos os
			  campos obrigatórios de #ADR presentes.

			- tq-adr-01 (alternativas, fail): PASS. 4 alternativas
			  (a-d) com justificativa de rejeição.

			- tq-adr-02 (metadata reflete decisão, fail): PASS.
			  reversibility=high (convenção aditiva sem consumidores
			  mecânicos), blastRadius=cross-artifact (governa
			  relação canvas↔api-specs em todos os BCs).

			- tq-adr-03 (paths reais, fail): PASS.
			  affectedArtifacts contém
			  architecture/conventions/api-spec-convention.cue —
			  criado no mesmo commit.

			Conclusão: 0 fail, 0 warn, 0 info. Estável em 1 round.
			"""
	}]

	findings: {}

	summary: """
		Self-review stable em 1 round para adr-048 — ADR da
		primeira convenção concreta do repositório. Codifica
		protocolo de presença bicondicional entre canvas
		capability flags e API specs. 11 critérios avaliados
		(uq-01..uq-08 + tq-adr-01/02/03), zero findings.
		Substância da convenção já revisada em 3 ciclos
		adversariais antes deste self-review.
		"""
}
