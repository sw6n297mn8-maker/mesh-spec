package deferred_decisions

meta: "architecture/deferred-decisions": {
	canonicalPath: "architecture/deferred-decisions"
	purpose:       "Deferimentos conscientes governados: decisões explícitas de não resolver agora, com trade-off articulado e condição codificada de revisita (per adr-062)."
	conventions: [
		"Nome no formato def-NNN-slug.cue com numeração contínua e incremental.",
		"Conformam com architecture/artifact-schemas/deferred-decision.cue.",
		"Status inicial open; lifecycle avaliado por scripts/ci/evaluate-deferred-triggers.sh (runner não muta arquivos).",
	]
	rationale: "Separar deferimento consciente de prose 'Known gaps' em ADRs e de WIs rotineiros torna a dívida deliberada rastreável e sujeita a trigger — evita virar dumping ground de débito técnico genérico."
}
