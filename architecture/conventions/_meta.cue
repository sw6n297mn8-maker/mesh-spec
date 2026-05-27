package conventions

meta: "architecture/conventions": {
	canonicalPath: "architecture/conventions"
	purpose:       "Convenções arquiteturais condicionais a capability flags do BC (API sync/async, etc.)."
	conventions: [
		"Cada convenção declara condição de ativação (ex: hasSyncSurface).",
		"CI valida conformidade apenas quando condição é satisfeita no BC.",
	]
	rationale: "Convenção condicional evita impor regra universal a BCs que não têm a capability; flexibilidade sem perder auditoria."
}
