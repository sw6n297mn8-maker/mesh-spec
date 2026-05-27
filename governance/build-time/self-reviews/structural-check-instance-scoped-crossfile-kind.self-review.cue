package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckInstanceScopedCrossfileKind: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-instance-scoped-crossfile-kind"

	artifactPath:       "architecture/artifact-schemas/structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-27"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Delta (adr-113): kind instance-scoped-cross-file-id-exists adicionado ao
			#StructuralCheck via união discriminada, com entrada paralela em
			#StructuralCheckKind e #StructuralCheckRule, e a rule shape
			#InstanceScopedCrossFileIdExistsRule {referencePaths[], scopeField,
			targetGlobTemplate, targetIdPaths[]}. Aprovado pelo founder (opção "novo
			kind per-BC, fiel").

			Conformancia: segue o padrão de extensão por kind consolidado
			(adr-049/.../107). Rule shape é dado estruturado puro (2 listas de string +
			2 strings) — tq-sc-02; targetGlobTemplate tem constraint =~"\\{scope\\}"
			(garante o placeholder). _schema.location intocado. Aditivo. referencePaths/
			targetIdPaths usam a mesma travessia _resolve_multi dos kinds adr-100/102/105.
			Distinção vs. família existente documentada no comentário da rule: alvo
			DERIVADO por instância (scopeField→targetGlobTemplate), não união global;
			escopo least-privilege.

			Verificacao empirica: cue vet ./... EXIT 0 (schema + a instância sc-ag-01);
			runner --self-test PASS com caso dedicado born-green/born-red (x resolve no
			seu dm; y referencia c-9 ausente no SEU dm → 1 finding); ev_instance_scoped_
			cross_file_id_exists registrado em EVAL e despacha sem erro.
			"""
	}]

	findings: {}

	summary: """
		Adiciona ao #StructuralCheck o kind instance-scoped-cross-file-id-exists e a
		rule shape #InstanceScopedCrossFileIdExistsRule (referencePaths/scopeField/
		targetGlobTemplate/targetIdPaths) per adr-113. Variante least-privilege da
		família cross-file-id-exists: alvo derivado por instância, não união global.
		Extensão aditiva; sem findings fail/warn. cue vet 0 + runner self-test PASS
		(born-green + born-red).
		"""

	singleRoundRationale: "Uma rodada: kind aditivo no padrão consolidado, shape derivado de adr-113 (aprovado antes da escrita) e verificado por cue vet + self-test born-green/born-red + execução. Sem espaço de red-team."
}
