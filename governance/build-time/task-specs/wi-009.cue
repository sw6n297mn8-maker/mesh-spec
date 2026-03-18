package task_specs

taskSpecs: "WI-009": {
	version:     1
	title:       "Criar contexts/cmt/canvas.cue — primeiro BC"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"CMT identificado como minimum economic loop em domain-definition.cue",
	]
	outputs: [{
		artifact: "contexts/cmt/canvas.cue"
		type:     "create"
	}]
	affects: []
	rationale: "Primeiro BC. CMT (Economic Commitment Lifecycle) é o minimum economic loop. Depende de domain-definition, subdomínios e canvas schema."
}
