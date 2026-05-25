package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckSchemaFilesystemPathFilter: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-schema-filesystem-path-filter"

	artifactPath:       "architecture/artifact-schemas/structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Extensao de #FilesystemPathExistsRule com 3 campos opcionais para
			suportar registros de delecao em self-review (adr-090 follow-on):
			- filterField? / filterValue?: avalia apenas instancias onde
			  filterField == filterValue (e.g., recordType == artifact-review);
			- mustExist (bool | *true): quando false, inverte a assercao — o
			  path DEVE NAO existir (e.g., SRRs de delecao).

			Backward compat: todos os campos sao opcionais com default que
			preserva o comportamento original (avalia todas as instancias, path
			DEVE existir). As instancias existentes de filesystem-path-exists
			(sc-srr-01 antigo, tension-entry.manifestsIn) nao setam os novos
			campos e permanecem identicas. Demais kinds e o restante do schema
			(#StructuralCheckKind, uniao discriminada, _qualityCriteria)
			inalterados.

			Consome o novo shape: sc-srr-01 (filtra recordType=artifact-review)
			e sc-srr-03 (recordType=artifact-deletion + mustExist:false), ambos
			em architecture/structural-checks/self-review-report.cue.
			cue vet confirma a uniao discriminada por kind.
			"""
	}]

	findings: {}

	summary: """
		#FilesystemPathExistsRule ganha filterField/filterValue (filtro por
		campo) e mustExist (polaridade da assercao). Habilita o sc-srr-01/03 a
		distinguir review (path existe) de delecao (path ausente) sem novo kind.
		Retrocompat preservada por defaults. 6th refinement do schema
		structural-check.
		"""

	singleRoundRationale: "Extensao mecanica e retrocompativel (3 campos opcionais com default que preserva semantica atual). Decisao registrada no dialogo de design do follow-on adr-090; os consumidores (sc-srr-01/03) entram no mesmo commit. cue vet passa; rounds adicionais nao detectariam new findings."
}
