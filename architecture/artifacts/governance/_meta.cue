package artifacts_governance

meta: "architecture/artifacts/governance": {
	canonicalPath: "architecture/artifacts/governance"
	purpose:       "Instâncias de autonomy envelopes por domínio."
	conventions: [
		"Um arquivo por envelope; nome no formato {domain-slug}.governance.cue.",
		"Conteúdo instanciado, não schema nem protocolo cross-domain.",
	]
	rationale: "Container de instâncias: separar instâncias de governance de definições autorais cross-domain. Diretório reservado antecipadamente como slot canônico — pode conter apenas marcador de presença, mas a função permanente independe de quando os primeiros envelopes serão materializados."
}
