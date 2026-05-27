package ai_orchestration

meta: "ai-orchestration": {
	canonicalPath: "ai-orchestration"
	purpose:       "Layer 5 da espec: como montar contexto certo para tarefa certa dentro do orçamento de tokens."
	conventions: [
		"retrieval-patterns.cue, dependency-graph.cue e agent-lifecycle.cue são top-level do diretório.",
		"Prompt-templates em ai-orchestration/agent-instructions/.",
	]
	rationale: "Orquestração de IA é problema que a literatura DDD não endereça; separar em layer própria evita poluir Layers 0-4 com preocupações de runtime estocástico."
}
