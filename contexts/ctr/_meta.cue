package ctr

meta: "contexts/ctr": {
	canonicalPath: "contexts/ctr"
	purpose:       "Bounded Context Contract & Terms Registry: registro versionado de contratos e cláusulas canônicas."
	conventions: [
		"Versionamento de contratos é backward-compatible por construção; quebra exige supersession.",
		"Cláusulas são referenciadas por outros BCs via IDs estáveis.",
	]
	rationale: "Separar ctr como BC dedicado evita que cada BC consumidor redefina termos contratuais — fonte canônica única para obrigações jurídicas."
}
