package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

fce: artifact_schemas.#Subdomain & {
	code:   "fce"
	name:   "Financial Commitment Execution"
	type: "core-subdomain"

	definition: """
		Orquestração da execução financeira de compromissos econômicos —
		budget allocation, payment lifecycle, settlement e liberação
		condicional de retenções. Governa a invariante central da fusão:
		dinheiro só se move quando operação comprova que deve se mover.
		Não governa o estado do compromisso (ECL), não precifica risco
		(REW), não origina produtos de working capital (SCF) nem executa
		liquidação física (BKR).
		"""

	purpose: """
		Eliminar a separação entre operação e liquidação financeira. Cada
		pagamento é rastreável até o compromisso e o evento que o originou.
		A vinculação causal torna a conciliação automática e a governança
		inerente ao fluxo. Sem FCE, dinheiro se move por instrução manual
		desacoplada da operação — o problema que a tese existe para
		resolver.
		"""

	mechanismRefs: [
		"mech-evidence",
		"mech-three-sots",
		"mech-scd",
	]

	costRefs: [
		"ce-03", // reconciliação multi-sistema
		"ce-05", // intermediação financeira
		"ce-06", // alongamento do ciclo do fornecedor
	]

	capabilityRefs: [
		"cc-01", // liberação vinculada a evidência
		"cc-03", // operação 24/7
	]

	negativeBoundaries: [{
		responsibility: "Estado do compromisso — state machine, transições e elegibilidades do lifecycle."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "FCE consome estados do compromisso (CMT) para decidir quando pagar, mas não governa transições. Fusão acoplaria evolução do lifecycle à evolução da execução financeira."
	}, {
		responsibility: "Precificação de risco e elegibilidade — políticas de crédito, limites, pricing."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "FCE executa decisões de risco, não as produz. Internalizar risco acoplaria modelos financeiros à execução de pagamentos — dois eixos de evolução com cadências diferentes."
	}, {
		responsibility: "Liquidação física — execução de Pix, TED, boleto, SWIFT."
		delegatedTo: {
			type: "subdomain"
			ref:  "bkr"
		}
		rationale: "FCE decide quando e por que pagar; BKR executa fisicamente. Separação core/generic permite trocar rails sem alterar lógica financeira."
	}, {
		responsibility: "Originação de produtos de working capital — antecipação, reverse factoring."
		delegatedTo: {
			type: "subdomain"
			ref:  "scf"
		}
		rationale: "FCE move dinheiro; SCF estrutura produtos. Fusão acoplaria execução de pagamentos à originação de produtos financeiros — cadências de evolução e regulação distintas."
	}, {
		responsibility: "Contabilidade e fiscal — lançamentos contábeis, obrigações fiscais."
		delegatedTo: {
			type: "subdomain"
			ref:  "ato"
		}
		rationale: "FCE gera eventos com impacto fiscal; ATO registra consequências. Separação permite evolução fiscal independente da execução financeira — regras fiscais mudam por regulação, não por produto."
	}]

	strategicProfile: {
		complexity: "high"
		volatility: "high"
		rationale: """
			Complexidade alta porque orquestra FinancializationService
			all-or-nothing, PrePaymentGuardService e Payment state machine
			com 11 invariantes — o subdomínio mais protegido do Wave 0
			porque qualquer bug financeiro tem impacto monetário direto.
			Volatilidade alta porque cada novo rail (Pix internacional,
			netting multilateral), novo produto financeiro ou mudança
			regulatória altera regras de execução.
			"""
	}

	rationale: """
		FCE é o downstream dominant do grafo — concentra dependências de
		leitura para decidir quando dinheiro se move. Core porque a lógica
		de vinculação causal operação→pagamento é proprietária e
		indissociável da tese. Absorveu a metade orquestradora do antigo
		PSO. Contribui para o moat de ecossistema (ledger como SoT).
		"""
}
