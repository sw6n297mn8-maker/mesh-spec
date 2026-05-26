package task_specs

taskSpecs: "WI-075": {
	version:     1
	title:       "Criar ADR-086 — Domain-Invariant Structural Check Authoring Protocol"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/artifact-schemas/adr.cue — schema #ADR",
		"architecture/artifact-schemas/structural-check.cue — kind domain-invariant (adr-080) que o protocolo disciplina",
		"architecture/structural-checks/rew-domain-model.cue — genesis empirica do meta-template (REW Phase 3.5a)",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-086-domain-invariant-authoring-protocol.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Backfill retroativo per sc-wg-01: a criacao do ADR-086 (Domain-Invariant
		Structural Check Authoring Protocol) foi proposta, aprovada, reivindicada e
		concluida em 2026-05-11 (work-events/wi-075.cue), mas a task-spec pareada
		nunca foi criada. Esta task-spec reconstroi o registro de autoria.

		Tipo: create-instance de ADR. Canoniza o protocolo de autoria para o kind
		domain-invariant (adr-080), formalizando o meta-template emergente na REW
		Phase 3.5a. O patch do production-guide e os patches retroativos INV/REW
		sao plannedOutputs sequenciados em WIs separados (wi-076/077/078).

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
