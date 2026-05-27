package agent_instructions

meta: "ai-orchestration/agent-instructions": {
	canonicalPath: "ai-orchestration/agent-instructions"
	purpose:       "Prompt-templates por tarefa recorrente (implementar agregado, expor API, gerar testes, evoluir evento)."
	conventions: [
		"Um arquivo por tarefa; nome no formato verbo-substantivo (implement-aggregate.cue).",
		"Cada template referencia artefatos source da spec, nunca duplica conteúdo.",
	]
	rationale: "Templates reutilizáveis por tarefa garantem consistência de execução e reduzem drift entre sessões de agente."
}
