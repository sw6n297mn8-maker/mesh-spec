package ssc

meta: "contexts/ssc": {
	canonicalPath: "contexts/ssc"
	purpose:       "Bounded Context Strategic Sourcing & Category: decide qual fornecedor atende qual categoria via regras determinísticas sobre sinais estruturados (NPM, RFQ, respostas); início do macrofluxo Mesh."
	conventions: [
		"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
		"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
	]
	rationale: "Sem decisão de sourcing canônica a escolha de fornecedor acontece fora da rede e o dado mais valioso (como e por que um fornecedor foi escolhido) se perde; o BC ancora o início do macrofluxo."
}
