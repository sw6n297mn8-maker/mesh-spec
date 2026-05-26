package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckScopedCrossFileIdExistsKind: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-scoped-cross-file-id-exists-kind"

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
			Delta (adr-105): kind scoped-cross-file-id-exists adicionado ao
			#StructuralCheck via uniao discriminada, com entrada paralela em
			#StructuralCheckKind e #StructuralCheckRule, e a rule shape
			#ScopedCrossFileIdExistsRule {itemsPath, guardFields, guardPresenceGlob,
			refField, targetGlob, targetIdPath}. Nome aprovado pelo founder.

			Conformancia: segue o padrao de extensao por kind consolidado
			(adr-049/.../102/103). Rule shape e dado estruturado puro — tq-sc-02.
			_schema.location intocado. Aditivo. Gemeo guardado do cross-file-id-exists:
			a allowance (forward-declaration de entidade nao-materializada) e
			declarativa via guardFields + guardPresenceGlob.

			Verificacao empirica: cue vet ./... EXIT 0 (schema + a instancia sc-cm-06);
			runner --self-test PASS; o evaluator ev_scoped_cross_file_id_exists despacha
			por kind sem erro — sc-cm-06 born-green.
			"""
	}]

	findings: {}

	summary: """
		Adiciona ao #StructuralCheck o kind scoped-cross-file-id-exists e a rule shape
		#ScopedCrossFileIdExistsRule per adr-105. Extensao aditiva no padrao das
		anteriores; sem findings fail/warn. cue vet 0 + runner self-test PASS.
		"""

	singleRoundRationale: """
		Uma rodada basta: kind aditivo no padrao consolidado, shape derivado de
		adr-105 (aprovado antes da escrita) e verificado por cue vet + self-test +
		execucao (sc-cm-06 born-green). Sem espaco de decisao aberto a red-team.
		"""
}
