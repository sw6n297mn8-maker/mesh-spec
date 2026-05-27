package domain_stories

meta: "strategic/domain-stories": {
	canonicalPath: "strategic/domain-stories"
	purpose:       "Fluxos de negócio narrados como sequências ator → ação → work item."
	conventions: [
		"Um arquivo por story; nome no formato slug kebab-case.",
		"Cada story referencia BCs e eventos envolvidos por ID.",
	]
	rationale: "Domain stories ancoram design em exemplos concretos de uso; reduzem risco de decomposição correta porém desconectada de cenários reais."
}
