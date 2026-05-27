package idc

meta: "contexts/idc": {
	canonicalPath: "contexts/idc"
	purpose:       "Bounded Context Identity & Data Governance: identidade de participantes e governança de dados pessoais (LGPD, integridade criptográfica)."
	conventions: [
		"Event log com integridade criptográfica end-to-end.",
		"Dados pessoais governados por políticas declaradas aqui; outros BCs consultam, não redefinem.",
	]
	rationale: "Identidade e conformidade regulatória são responsabilidades que tangenciam todos os BCs; BC dedicado evita dispersão de lógica sensível."
}
