package cross_context_workflows

meta: "architecture/cross-context-workflows": {
	canonicalPath: "architecture/cross-context-workflows"
	purpose:       "Processos que atravessam múltiplos bounded contexts (ex: commitment lifecycle)."
	conventions: [
		"Cada workflow documenta BCs participantes e eventos trocados.",
		"Conformam com architecture/artifact-schemas/cross-context-flow.cue.",
	]
	rationale: "Workflows cross-context não pertencem a nenhum BC individual; alocar em architecture/ preserva ownership distribuído dos BCs."
}
