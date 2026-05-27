package p2p

meta: "contexts/p2p": {
	canonicalPath: "contexts/p2p"
	purpose:       "Bounded Context Procure-to-Pay: emite Purchase Orders sob autoridade de sourcing pré-existente e faz hand-off da demanda formalizada para CMT — gateway entre sourcing (SSC) e compromisso."
	conventions: [
		"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
		"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
	]
	rationale: "Sem PO canônico vinculado a authority válida, a demanda flui fora da rede e o porquê da compra se perde; o BC gateway preserva o registro da decisão na formalização."
}
