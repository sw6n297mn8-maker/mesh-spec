package bkr

meta: "contexts/bkr": {
	canonicalPath: "contexts/bkr"
	purpose:       "Bounded Context Banking Rails & Settlement: liquidação física via rails bancários (Pix/SPI, TED/STR, boleto, SWIFT) sob autorização upstream — boundary entre a Mesh e o sistema regulado pelo Bacen."
	conventions: [
		"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
		"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
	]
	rationale: "Liquidação física toca regulação Bacen/SPB e responsabilidade jurídica de instituição autorizada; BC dedicado isola o boundary regulado da lógica financeira proprietária da Mesh — BKR não decide mérito econômico."
}
