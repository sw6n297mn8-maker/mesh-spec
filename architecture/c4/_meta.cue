package c4

meta: "architecture/c4": {
	canonicalPath: "architecture/c4"
	purpose:       "Diagramas C4 do sistema (Structurizr DSL como source, views derivadas em .mmd/.png)."
	conventions: [
		"workspace.dsl é o source of truth; views/ contém derivados.",
		"Diagramas nunca editados no formato renderizado — regenerados do DSL.",
	]
	rationale: "C4 provê linguagem visual compartilhada para arquitetura; manter DSL como source mantém versionamento textual auditável."
}
