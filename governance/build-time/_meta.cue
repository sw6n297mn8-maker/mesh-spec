package build_time

meta: "governance/build-time": {
	canonicalPath: "governance/build-time"
	purpose:       "Especificações de build-time: work governance, quality-gate, self-review, task-specs."
	conventions: [
		"Schemas de protocolo em arquivos top-level do diretório.",
		"self-reviews/ e task-specs/ são containers de instâncias — schemas correspondentes em architecture/artifact-schemas/.",
		"work-graph.cue e projections/ derivam de eventos; nunca editados manualmente.",
	]
	rationale: "Protocolos de build-time orquestram como o trabalho acontece; isolamento em subdiretório facilita auditoria de governança de execução sem ruído de domínio."
}
