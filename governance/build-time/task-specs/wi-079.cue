package task_specs

taskSpecs: "WI-079": {
	version:     1
	title:       "Criar structural-check de invariantes de dominio do BC CMT (cmt-domain-model.cue)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/artifact-schemas/structural-check.cue — #StructuralCheck, kind domain-invariant (adr-080)",
		"architecture/adrs/adr-086-domain-invariant-authoring-protocol.cue — protocolo DISCAP de autoria",
		"architecture/production-guides/structural-check.cue — guia de autoria (extensao domain-invariant)",
		"contexts/cmt/domain-model.cue — invariantes do BC CMT que os checks codificam",
	]
	outputs: [{
		artifact: "architecture/structural-checks/cmt-domain-model.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Backfill retroativo per sc-wg-01: a autoria dos structural-checks de
		invariantes de dominio do BC CMT foi proposta, aprovada, reivindicada e
		concluida em 2026-05-12 (work-events/wi-079.cue), mas a task-spec pareada
		nunca foi criada. Esta task-spec reconstroi o registro de autoria.

		Tipo: create-instance de structural-check (kind domain-invariant, adr-080),
		codificando os invariantes do domain-model do CMT como gates deterministicos
		(adr-040), guiado pelo protocolo DISCAP (adr-086).

		Criticality medium (default tmpl-create-instance@v1). Reversivel por remocao
		da task-spec de backfill, sem alterar o artefato produzido.
		"""
}
