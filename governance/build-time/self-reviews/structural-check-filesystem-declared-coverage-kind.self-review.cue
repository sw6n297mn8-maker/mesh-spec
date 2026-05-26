package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckFilesystemDeclaredCoverageKind: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-filesystem-declared-coverage-kind"

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
			Delta (adr-103): kind filesystem-declared-coverage adicionado ao
			#StructuralCheck via uniao discriminada, com entrada paralela em
			#StructuralCheckKind e #StructuralCheckRule, e a rule shape
			#FilesystemDeclaredCoverageRule {pathGlob, targetGlob, targetIdPath}.
			Nome aprovado pelo founder antes da escrita.

			Conformancia: segue o padrao de extensao por kind consolidado
			(adr-049/063/064/080/090/099/100/102). Rule shape e dado estruturado puro
			(3 campos string non-empty) — tq-sc-02. _schema.location intocado. Aditivo.
			Inverso do cross-file-id-exists: la a fonte e ref-em-artefato; aqui a fonte
			e enumeracao do filesystem (pathGlob + glob_capture) e o namespace e o
			campo declarado no artefato.

			Verificacao empirica: cue vet ./... EXIT 0 (schema + a instancia sc-cm-05);
			runner --self-test PASS; o evaluator ev_filesystem_declared_coverage
			despacha por kind sem erro — sc-cm-05 born-green sobre dados reais.
			"""
	}]

	findings: {}

	summary: """
		Adiciona ao #StructuralCheck o kind filesystem-declared-coverage e a rule
		shape #FilesystemDeclaredCoverageRule (pathGlob/targetGlob/targetIdPath) per
		adr-103. Extensao aditiva no padrao das anteriores; sem findings fail/warn.
		cue vet 0 + runner self-test PASS.
		"""

	singleRoundRationale: """
		Uma rodada basta: kind aditivo no padrao consolidado de extensao do
		#StructuralCheck, shape derivado de adr-103 (aprovado antes da escrita) e
		verificado por cue vet + self-test + execucao (sc-cm-05 born-green). Sem
		espaco de decisao aberto a red-team adicional.
		"""
}
