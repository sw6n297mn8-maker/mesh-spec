package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckCrossFileIdExistsKind: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-cross-file-id-exists-kind"

	artifactPath:       "architecture/artifact-schemas/structural-check.cue"
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
			Delta (adr-102): kind cross-file-id-exists adicionado ao #StructuralCheck
			via uniao discriminada, com entrada paralela em #StructuralCheckKind e
			#StructuralCheckRule, e a rule shape #CrossFileIdExistsRule {referencePath,
			targetGlob, targetIdPath}. Aprovado pelo founder antes da escrita.

			Conformancia: segue o padrao de extensao por kind consolidado
			(adr-049/063/064/080/090/099/100). Rule shape e dado estruturado puro (3
			campos string non-empty) — tq-sc-02. _schema.location intocado. Aditivo: os
			kinds e checks existentes nao sao afetados. O kind e o gemeo cross-file do
			local-field-reference-integrity (adr-100): mesmo estilo de path (_resolve_multi),
			mas namespace montado de OUTROS arquivos (targetGlob + targetIdPath).

			Verificacao empirica: cue vet ./... EXIT 0 (schema + a instancia sc-te-02);
			runner --self-test PASS; o evaluator ev_cross_file_id_exists despacha por
			kind sem erro — sc-te-02 born-green sobre dados reais.
			"""
	}]

	findings: {}

	summary: """
		Adiciona ao #StructuralCheck o kind cross-file-id-exists e a rule shape
		#CrossFileIdExistsRule (referencePath/targetGlob/targetIdPath) per adr-102
		(resolve def-002). Extensao aditiva no padrao das anteriores; sem findings
		fail/warn. cue vet 0 + runner self-test PASS.
		"""

	singleRoundRationale: """
		Uma rodada basta: kind aditivo no padrao consolidado de extensao do
		#StructuralCheck, shape derivado de adr-102 (aprovado antes da escrita) e
		verificado por cue vet + self-test + execucao (sc-te-02 born-green). Sem
		espaco de decisao aberto a red-team adicional.
		"""
}
