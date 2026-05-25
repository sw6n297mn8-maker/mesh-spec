package task_specs

taskSpecs: "WI-073": {
	version:     1
	title:       "Criar primary-agent do BC REW (Phase 4)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/artifact-schemas/agent-spec.cue — schema #AgentSpec do primary-agent",
		"contexts/rew/canvas.cue — definicao do BC REW que o agente serve",
		"contexts/rew/domain-model.cue — invariantes e agregados protegidos pelo agente",
	]
	outputs: [{
		artifact: "contexts/rew/agents/rew-primary-agent.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Backfill retroativo per sc-wg-01: a criacao do primary-agent do BC REW
		(Phase 4) foi proposta, aprovada, reivindicada e concluida em 2026-05-11
		(work-events/wi-073.cue), mas a task-spec pareada nunca foi criada. Esta
		task-spec reconstroi o registro de autoria.

		Tipo: create-instance de agent-spec para o BC REW.

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
