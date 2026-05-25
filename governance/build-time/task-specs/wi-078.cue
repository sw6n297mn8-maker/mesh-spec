package task_specs

taskSpecs: "WI-078": {
	version:     1
	title:       "Patch retroativo DISCAP no structural-check do BC REW (sc-rew-01..05)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-086-domain-invariant-authoring-protocol.cue — protocolo DISCAP canonico",
		"architecture/production-guides/structural-check.cue — criterios tq-scg-04..08 do patch",
		"architecture/structural-checks/rew-domain-model.cue — alvo do patch (sc-rew-01..05, war-game pre-meta-template)",
	]
	outputs: [{
		artifact: "architecture/structural-checks/rew-domain-model.cue"
		type:     "update"
	}]
	affects: []
	rationale: """
		Backfill retroativo per sc-wg-01: o patch retroativo DISCAP nas regras
		sc-rew-01..05 (war-game derived antes do meta-template) foi proposto,
		aprovado, reivindicado e concluido em 2026-05-12 (work-events/wi-078.cue),
		mas a task-spec pareada nunca foi criada. Esta task-spec reconstroi o registro.

		Tipo: update de structural-check existente — retrofit das declaracoes de
		layers + war-game evidence per adr-086, alinhando sc-rew-01..05 ao protocolo
		canonizado (sc-rew-06..15 ja conformes desde a Phase 3.5a).

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
