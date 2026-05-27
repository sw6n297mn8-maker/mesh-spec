package inv

meta: "contexts/inv": {
	canonicalPath: "contexts/inv"
	purpose:       "Bounded Context Invoicing: materializa a obrigação de faturamento (InvoiceIssued) e o direito creditório a partir de DeliveryVerified, sob regime fiscal regulado determinístico."
	conventions: [
		"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
		"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
	]
	rationale: "A linguagem fiscal (NF-e, CFOP, alíquotas, retenções) tem regulação tributária própria e cadência distinta; separar de DLV/FCE/ATO/SCF evita acoplar regime fiscal ao fluxo operacional."
}
