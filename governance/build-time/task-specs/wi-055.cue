package task_specs

taskSpecs: "WI-055": {
	version:               1
	title:                 "Criar artefatos de domínio para Network Participant Management (NPM)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — NPM gerencia lifecycle de participantes; publica para REW, NIM, CTR, SSC; opera com NGR",
	]
	outputs: [{
		artifact: "contexts/npm/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/npm/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/npm/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/npm/agents/npm-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/npm/agents/npm-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting NPM. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — gerencia ciclo de vida de participantes
		da rede: onboarding, qualificação, suspensão. Publica eventos
		para REW (risco), NIM (inteligência), CTR (contratos) e SSC
		(sourcing). Opera em parceria com NGR (growth).

		Criticality medium (default template) — gestão de participantes
		é operacional. KYC/AML é responsabilidade de IDC, não de NPM.
		"""
}
