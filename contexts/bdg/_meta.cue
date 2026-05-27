package bdg

meta: "contexts/bdg": {
	canonicalPath: "contexts/bdg"
	purpose:       "Bounded Context Budget & Approval: verifica cobertura orçamentária de compromissos formalizados em CMT e emite o gate canônico de aprovação que habilita a progressão do commitment lifecycle."
	conventions: [
		"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
		"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
	]
	rationale: "Isolar o gate orçamentário em BC próprio evita que ele fique diluído entre CMT (formalização) e a execução financeira — owner único do estado de comprometimento orçamentário e das regras de alçada."
}
