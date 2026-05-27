package shared_schemas

meta: "architecture/shared-schemas": {
	canonicalPath: "architecture/shared-schemas"
	purpose:       "Schemas compartilhados entre BCs (Money canônico, CloudEvents envelope, assertions formais, Ion rules)."
	conventions: [
		"Um arquivo por schema; uso cross-BC justifica presença aqui.",
		"Schemas locais a um BC vivem em contexts/{bc}/schemas/, nunca aqui.",
	]
	rationale: "Schemas usados por mais de um BC ganham localização canônica única; duplicação entre BCs seria drift por construção."
}
