package task_specs

taskSpecs: "WI-076": {
	version:     1
	title:       "Estender o production-guide de structural-check com o protocolo domain-invariant (plannedOutput do adr-086)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/artifact-schemas/production-guide.cue — schema #ProductionGuide",
		"architecture/adrs/adr-086-domain-invariant-authoring-protocol.cue — origem dos plannedOutputs do patch",
		"architecture/production-guides/structural-check.cue — PG alvo do patch",
	]
	outputs: [{
		artifact: "architecture/production-guides/structural-check.cue"
		type:     "update"
	}]
	affects: []
	rationale: """
		Backfill retroativo per sc-wg-01: o patch do production-guide de
		structural-check (extensao para o kind domain-invariant; +5 criterios
		tq-scg-04..08; PG 204 -> 375 linhas) foi proposto, aprovado, reivindicado e
		concluido em 2026-05-11 (work-events/wi-076.cue), mas a task-spec pareada
		nunca foi criada. Esta task-spec reconstroi o registro de autoria.

		Tipo: update do PG existente, materializando os plannedOutputs declarados no
		adr-086 (estende as 3 sections existentes com sub-blocos domain-invariant).

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
