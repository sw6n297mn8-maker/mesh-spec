package task_specs

taskSpecs: "WI-054": {
	version:               1
	title:                 "Criar artefatos de domínio para Logistics & Operational Evidence (LOG)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — LOG captura evidência operacional com integridade de IDC; publica cadeia de custódia para DLV",
	]
	outputs: [{
		artifact: "contexts/log/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/log/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/log/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/log/agents/log-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/log/agents/log-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting LOG. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — captura, registro e gestão de evidência
		operacional: rastreamento de carga, inspeção de qualidade,
		medição de obra, atividades de campo. Produz cadeia de
		custódia que DLV consome para verificação. Consome
		integridade criptográfica de IDC.

		Criticality medium (default template) — evidência operacional
		é input para verificação, não decisão financeira direta.
		"""
}
