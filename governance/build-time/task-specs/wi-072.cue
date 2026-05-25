package task_specs

taskSpecs: "WI-072": {
	version:     1
	title:       "Expandir structural-check do BC REW (Phase 3.5a): +10 regras sc-rew cobrindo invariantes Part 1"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/artifact-schemas/structural-check.cue — #StructuralCheck, kind domain-invariant (adr-080)",
		"contexts/rew/domain-model.cue — invariantes Part 1 (1-12) do BC REW codificados pelas regras",
		"architecture/structural-checks/rew-domain-model.cue — 5 regras sc-rew war-game existentes a expandir",
	]
	outputs: [{
		artifact: "architecture/structural-checks/rew-domain-model.cue"
		type:     "update"
	}]
	affects: []
	rationale: """
		Backfill retroativo per sc-wg-01: a expansao Phase 3.5a do structural-check
		do BC REW (+10 regras sc-rew-06..15 cobrindo invariantes Part 1; arquivo
		248 -> 883 linhas) foi proposta, aprovada, reivindicada e concluida em
		2026-05-09 (work-events/wi-072.cue), mas a task-spec pareada nunca foi
		criada. Esta task-spec reconstroi o registro de autoria.

		Tipo: update de structural-check existente (kind domain-invariant, adr-080).
		Esta expansao foi a genesis empirica do meta-template level-2 (DISCAP),
		depois canonizado pelo adr-086.

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
