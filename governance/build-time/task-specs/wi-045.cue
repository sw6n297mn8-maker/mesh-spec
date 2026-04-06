package task_specs

taskSpecs: "WI-045": {
	version:               1
	title:                 "Criar artefatos de domínio para Network Intelligence & Mechanism Design (NIM)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — NIM modela topologia e comportamento de rede; publica ontologia de mecanismos para REW e insights para NGR",
	]
	outputs: [{
		artifact: "contexts/nim/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/nim/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/nim/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/nim/agents/nim-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/nim/agents/nim-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC core NIM. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Core domain — modela topologia e comportamento de rede para
		calibrar mecanismos de incentivo. Consome dados de NPM e DLV;
		publica ontologia de mecanismos para REW (risco) e insights
		para NGR (growth). Wardley evolution genesis — domínio
		experimental de mechanism design.

		Criticality medium (default template) — mecanismos de incentivo
		têm impacto econômico indireto via REW, mas NIM não controla
		decisão sobre dinheiro diretamente.
		"""
}
