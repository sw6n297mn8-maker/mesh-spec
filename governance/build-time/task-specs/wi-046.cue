package task_specs

taskSpecs: "WI-046": {
	version:               1
	title:                 "Criar artefatos de domínio para Risk Engine & Risk Observability (REW)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — REW é hub de risco: recebe sinais de NPM, DLV, CMT; publica elegibilidade para FCE, SCF, CMT",
		"contexts/cmt/domain-model.cue — CMT consome risk flags de REW; entender interface upstream→downstream",
	]
	outputs: [{
		artifact: "contexts/rew/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/rew/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/rew/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/rew/agents/rew-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/rew/agents/rew-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC core REW. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Core domain — hub de risco da rede. Avalia risco contínuo
		de participantes e operações; publica scores e elegibilidade
		consumidos por CMT (gates de compromisso), FCE (liquidação),
		SCF (antecipação) e DLV (verificação). Recebe sinais de
		múltiplos BCs — posição topológica de convergência.

		Criticality high — controla decisão sobre dinheiro. Scoring
		incorreto pode liberar liquidação para operação inelegível
		ou bloquear operação legítima. Decisões de elegibilidade
		condicionam diretamente FCE e SCF.
		"""
}
