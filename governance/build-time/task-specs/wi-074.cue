package task_specs

taskSpecs: "WI-074": {
	version:     1
	title:       "Criar envelope de governanca do primary-agent do BC REW (Phase 5)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/artifact-schemas/agent-governance.cue — schema do envelope de governanca",
		"contexts/rew/agents/rew-primary-agent.cue — primary-agent governado pelo envelope",
	]
	outputs: [{
		artifact: "contexts/rew/agents/rew-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Backfill retroativo per sc-wg-01: a criacao do envelope de governanca do
		primary-agent do BC REW (Phase 5) foi proposta, aprovada, reivindicada e
		concluida em 2026-05-11 (work-events/wi-074.cue), mas a task-spec pareada
		nunca foi criada. Esta task-spec reconstroi o registro de autoria.

		Tipo: create-instance de agent-governance pareado ao primary-agent do REW.

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
