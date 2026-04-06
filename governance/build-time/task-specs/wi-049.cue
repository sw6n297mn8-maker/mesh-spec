package task_specs

taskSpecs: "WI-049": {
	version:               1
	title:                 "Criar artefatos de domínio para Disputes, Reversals & Corrections (DRC)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — DRC consome de CMT, DLV e CTR; publica decisões para FCE e CMT",
		"contexts/cmt/domain-model.cue — CMT publica compromissos que DRC referencia em disputas",
		"contexts/ctr/domain-model.cue — CTR publica termos que DRC usa como base de resolução",
	]
	outputs: [{
		artifact: "contexts/drc/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/drc/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/drc/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/drc/agents/drc-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/drc/agents/drc-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting DRC. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — avalia e resolve disputas referenciando
		compromissos (CMT), evidência (DLV) e termos (CTR). Publica
		decisões de resolução para FCE (reversão financeira) e CMT
		(ajuste de compromisso).

		Criticality medium (default template) — processo de resolução
		é operacional. Impacto financeiro é indireto via FCE.
		"""
}
