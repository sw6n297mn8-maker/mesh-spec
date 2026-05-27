package projections

meta: "governance/build-time/projections": {
	canonicalPath: "governance/build-time/projections"
	purpose:       "Read models derivados do event stream de work governance."
	conventions: [
		"Um arquivo por projection; nome reflete o read model materializado.",
		"Conteúdo é derivado de work-events/ e nunca editado manualmente.",
		"Formato e integridade são governados pelos artefatos de build-time correspondentes.",
	]
	rationale: "Container de derivados: projections separam estado consultável da fonte de eventos e devem permanecer claramente distintas dos artefatos autorais que as definem."
}
