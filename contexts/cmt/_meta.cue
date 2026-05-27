package cmt

meta: "contexts/cmt": {
	canonicalPath: "contexts/cmt"
	purpose:       "Bounded Context Commitment Management: gestão do ciclo de vida de compromissos entre participantes."
	conventions: [
		"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
		"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
	]
	rationale: "Commitment é o centro operacional do sistema Mesh; isolamento em BC próprio permite evolução independente do vocabulário de compromissos."
}
