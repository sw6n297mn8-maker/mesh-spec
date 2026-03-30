package subdomains

// inv.cue — Invoicing.
// Instância de #Subdomain (architecture/artifact-schemas/subdomain.cue).
//
// Emerge da decomposição de ECL (ADR-032): faturamento e materialização
// do direito creditório é área de conhecimento com regulação fiscal
// própria e cadência distinta de verificação e contabilização.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

inv: artifact_schemas.#Subdomain & {
	code: "inv"
	name: "Invoicing"
	type: "supporting-subdomain"

	definition: """
		Faturamento e materialização do direito creditório. Governa
		emissão de NF-e, validação fiscal, vinculação da fatura ao
		compromisso verificado e a transformação de execução verificada
		em recebível financeiro. Produz o lastro que SCF consome para
		originação de produtos e que REW consome para precificação.
		Não verifica execução operacional (DLV), não formaliza
		compromissos (CMT), não executa pagamentos (FCE), não registra
		consequências contábeis e fiscais (ATO), não modela risco (REW).
		"""

	purpose: """
		Separar a materialização do recebível da verificação de execução
		e da contabilização fiscal. INV opera em tempo real (cada
		verificação aprovada pode gerar fatura), enquanto ATO opera em
		batch (apuração mensal/trimestral). Sem INV como unidade separada,
		a materialização do recebível ficaria entre DLV (que verifica mas
		não fatura) e ATO (que contabiliza mas não materializa) — sem
		owner canônico do momento em que o direito creditório nasce.
		"""

	negativeBoundaries: [{
		responsibility: "Verificação de execução operacional — medição, inspeção, aceite técnico."
		delegatedTo: {
			type: "subdomain"
			ref:  "dlv"
		}
		rationale: "INV fatura o que DLV verificou. Separação mantém materialização fiscal desacoplada de verificação operacional — regulação fiscal e critérios de verificação evoluem por drivers distintos."
	}, {
		responsibility: "Contabilidade e obrigações fiscais — lançamentos contábeis, apuração de impostos, reporting."
		delegatedTo: {
			type: "subdomain"
			ref:  "ato"
		}
		rationale: "INV materializa o recebível (NF-e); ATO registra consequências contábeis. Cadências radicalmente distintas: INV opera por evento, ATO opera por período fiscal."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "INV materializa o direito; FCE executa o pagamento. Separação mantém lastro desacoplado de liquidação — cada um com regulação e cadência próprias."
	}, {
		responsibility: "Originação de produtos financeiros — antecipação, reverse factoring."
		delegatedTo: {
			type: "subdomain"
			ref:  "scf"
		}
		rationale: "INV produz recebível lastreado; SCF origina produtos sobre ele. Separação permite novos produtos financeiros sem alterar faturamento."
	}, {
		responsibility: "Formalização de compromissos econômicos — proposta, aceite mútuo."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "Compromisso formalizado é pré-condição para faturamento, mas formalização e faturamento têm linguagens, profissionais e regulação distintos."
	}, {
		responsibility: "Precificação de risco e elegibilidade financeira do recebível — políticas de crédito, limites, scoring."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "INV materializa o recebível; REW avalia se é elegível para produtos financeiros. Faturamento é ato fiscal, elegibilidade é decisão de risco — domínios com profissionais e regulação distintos."
	}]

	rationale: """
		INV é supporting porque faturamento é regulatoriamente
		determinado (NF-e, SEFAZ, legislação fiscal) — padrões
		exógenos à Mesh. O valor proprietário está na vinculação
		do faturamento à verificação de execução (DLV) e ao
		compromisso formalizado (CMT) — o que torna o recebível
		da Mesh lastreado em evidência verificável, diferente de
		recebíveis tradicionais. INV é o ponto onde execução
		operacional se transforma em instrumento financeiro.
		"""
}
