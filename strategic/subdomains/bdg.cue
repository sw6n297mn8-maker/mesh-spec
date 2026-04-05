package subdomains

// bdg.cue — Budget & Approval.
// Instância de #Subdomain (architecture/artifact-schemas/subdomain.cue).
//
// Emerge da decomposição de ECL (ADR-032): controle orçamentário
// é área de conhecimento com linguagem, profissionais e cadência
// de evolução próprios — passa no teste DDD.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

bdg: artifact_schemas.#Subdomain & {
	code: "bdg"
	name: "Budget & Approval"
	type: "supporting-subdomain"

	definition: """
		Controle de comprometimento orçamentário e aprovação de
		compromissos econômicos. Governa saldo disponível por centro
		de custo, limites de comprometimento, alçadas de aprovação e
		a invariante de que nenhum compromisso progride sem cobertura
		orçamentária verificada. Não formaliza compromissos (CMT), não
		executa pagamentos (FCE), não verifica execução operacional
		(DLV), não precifica risco (REW).
		"""

	purpose: """
		Separar controle orçamentário da formalização de compromissos
		e da execução financeira. Budget control tem linguagem própria
		(comprometimento vs realizado, centro de custo, alçada),
		profissionais próprios (controllers, diretoria financeira) e
		cadência de evolução independente (planejamento anual,
		revisões trimestrais). Sem BDG como unidade separada, o gate
		orçamentário ficaria diluído entre CMT e FCE — sem owner
		canônico do comprometimento.
		"""

	negativeBoundaries: [{
		responsibility: "Formalização de compromissos econômicos — proposta, aceite mútuo, estado do compromisso."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "BDG aprova orçamento; CMT formaliza o compromisso. Separação mantém controle financeiro desacoplado de formalização operacional."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement, liberação de retenções."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "BDG controla comprometimento; FCE executa pagamento. Comprometimento orçamentário e fluxo de caixa têm cadências distintas — comprometimento é prospectivo, pagamento é efetivo."
	}, {
		responsibility: "Precificação de risco — políticas de crédito, limites, pricing."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "BDG controla orçamento do comprador; REW avalia risco do fornecedor e da operação. Dois domínios com dados, modelos e profissionais distintos."
	}, {
		responsibility: "Disputas sobre aprovação orçamentária — contestações de alocação, revisões de comprometimento."
		delegatedTo: {
			type: "subdomain"
			ref:  "drc"
		}
		rationale: "Disputas sobre orçamento (ex: alocação contestada, comprometimento excedido) têm lifecycle de exceção com prazos e resolução próprios. Fusão misturaria controle orçamentário rotineiro com fluxo de exceção."
	}, {
		responsibility: "Gestão do ciclo de procurement — requisição, aprovação de compras por alçada, composição de demanda."
		delegatedTo: {
			type: "subdomain"
			ref:  "p2p"
		}
		rationale: "BDG aprova comprometimento orçamentário; P2P aprova fluxo de procurement por alçada de compras. Gates distintos — BDG verifica se há budget, P2P verifica se a requisição segue política de compras."
	}, {
		responsibility: "Gestão de tesouraria — posição de caixa, projeção de liquidez, gestão de disponibilidades."
		delegatedTo: {
			type: "subdomain"
			ref:  "tcm"
		}
		rationale: "BDG controla comprometimento orçamentário (prospectivo); TCM consolida posição de caixa (efetiva). Empresa pode ter orçamento sem caixa ou caixa sem orçamento — dois instrumentos complementares com cadências distintas."
	}]

	rationale: """
		BDG é supporting porque controle orçamentário é domínio com
		padrões bem estabelecidos (planejamento, comprometimento, ERP)
		— não proprietário. O valor proprietário da Mesh está na
		vinculação do gate orçamentário ao commitment lifecycle como
		pré-condição formal, não no controle orçamentário em si. BDG
		não é generic porque o gate é integrado ao flow da Mesh —
		precisa consumir CommitmentId e emitir sinal de aprovação
		para contexts downstream. BDG impede que compromissos avancem
		sem cobertura — gate que protege a rede contra inadimplência
		programática.
		"""
}
