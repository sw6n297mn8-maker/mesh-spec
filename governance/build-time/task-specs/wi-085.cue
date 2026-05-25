package task_specs

taskSpecs: "WI-085": {
	version:     1
	title:       "Criar ADR-087: rename semantico do invariante de unicidade de commitment do BC BDG (escopo global)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/artifact-schemas/adr.cue — schema #ADR",
		"architecture/structural-checks/bdg-domain-model.cue — assertion sc-bdg-07 que ja operava globalmente",
		"contexts/bdg/domain-model.cue — invariante renomeado (inv-commitment-id-...)",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-087-rename-bdg-commitment-uniqueness-invariant-global.cue"
		type:     "create"
	}]
	affects: [
		"contexts/bdg/domain-model.cue",
		"contexts/bdg/agents/bdg-primary-agent.cue",
		"contexts/bdg/agents/bdg-primary-agent.governance.cue",
		"architecture/structural-checks/bdg-domain-model.cue",
	]
	rationale: """
		Backfill retroativo per sc-wg-01: o ADR-087 (correcao semantica renomeando
		inv-commitment-id-uniqueness-per-cost-center -> inv-commitment-id-global-uniqueness-active,
		com rename atomico em 4 arquivos BDG, behavior change zero) foi proposto,
		aprovado, reivindicado e concluido em 2026-05-12 (work-events/wi-085.cue),
		mas a task-spec pareada nunca foi criada. Esta task-spec reconstroi o registro.

		Tipo: create-instance de ADR. O output direto e o ADR; o rename atomico nos
		4 arquivos BDG (domain-model + primary-agent + governance + structural-check)
		e a superficie impactada (affects).

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
