package governance

meta: "governance": {
	canonicalPath: "governance"
	purpose:       "Layer 4 da espec: governança e qualidade (estrutura do repo, princípios operacionais, protocolos)."
	conventions: [
		"repo-structure.cue e repo-principles.cue são top-level do diretório.",
		"Protocolos (self-review, wave-plan, red-team, audit) vivem aqui.",
		"Configuração source-of-truth de CLAUDE.md e README.md em subdiretórios dedicados.",
	]
	rationale: "Governança não produz conhecimento novo — audita o existente. Separar em layer própria evita confundir metarregra com spec de domínio."
}
