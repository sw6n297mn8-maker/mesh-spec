package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

bkr: artifact_schemas.#Subdomain & {
	code: "bkr"
	name: "Banking Rails & Settlement"
	type: "generic-subdomain"

	definition: """
		Liquidação física via rails bancários — execução de Pix,
		TED, boleto, SWIFT e futuros meios de pagamento. Abstrai
		a heterogeneidade de protocolos bancários em interface
		uniforme que FCE consome. Não decide quando nem por que
		pagar (FCE), não modela risco (REW), não governa o
		lifecycle do compromisso econômico (ECL).
		"""

	purpose: """
		Separar execução física de liquidação da lógica
		financeira que a comanda. Rails bancários mudam por
		regulação do Bacen e evolução de protocolos (Pix
		internacional, Open Finance), não por regras de negócio
		da Mesh. Sem BKR como unidade separada, FCE absorveria
		a complexidade de cada protocolo bancário — acoplando
		lógica financeira proprietária a integrações substituíveis.
		"""

	negativeBoundaries: [{
		responsibility: "Lógica financeira — decisão de quando e por que pagar, budget, settlement lógico."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "BKR executa fisicamente; FCE decide. Separação core/generic permite trocar rails sem alterar lógica financeira — o rail é commodity, a decisão é proprietária."
	}, {
		responsibility: "Precificação de risco — limites, condições de crédito."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "BKR não avalia se uma transação deveria acontecer; apenas executa quando autorizada. Risco é input upstream, não responsabilidade do rail."
	}]

	rationale: """
		BKR é generic porque rails bancários são infraestrutura
		comoditizada — Pix, TED e boleto têm protocolos definidos
		pelo Bacen, não pela Mesh. A diferenciação competitiva
		está em FCE (quando e por que pagar) e REW (sob quais
		condições), não em como o dinheiro se move fisicamente.
		BKR é substituível por qualquer provedor que implemente
		os mesmos protocolos.
		"""
}
