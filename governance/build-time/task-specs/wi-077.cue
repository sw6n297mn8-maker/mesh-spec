package task_specs

taskSpecs: "WI-077": {
	version:     1
	title:       "Patch retroativo DISCAP no structural-check do BC INV"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-086-domain-invariant-authoring-protocol.cue — protocolo DISCAP canonico",
		"architecture/production-guides/structural-check.cue — criterios tq-scg-04..08 do patch",
		"architecture/structural-checks/inv-domain-model.cue — alvo do patch (8 regras sc-inv autoradas pre-DISCAP)",
	]
	outputs: [{
		artifact: "architecture/structural-checks/inv-domain-model.cue"
		type:     "update"
	}]
	affects: []
	rationale: """
		Backfill retroativo per sc-wg-01: o patch retroativo DISCAP no structural-check
		do BC INV (declaracoes de layers + war-game evidence nas 8 regras sc-inv;
		arquivo 301 -> 440 linhas) foi proposto, aprovado, reivindicado e concluido em
		2026-05-11 (work-events/wi-077.cue), mas a task-spec pareada nunca foi criada.
		Esta task-spec reconstroi o registro de autoria.

		Tipo: update de structural-check existente — retrofit do protocolo adr-086 a
		regras autoradas antes do meta-template existir.

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
