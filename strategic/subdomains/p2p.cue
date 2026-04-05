package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

p2p: artifact_schemas.#Subdomain & {
	code: "p2p"
	name: "Procure-to-Pay"
	type: "supporting-subdomain"

	definition: """
		Ciclo de demanda interna da organização compradora até a
		emissão de pedido de compra direcionado a fornecedor
		participante da rede: requisição, aprovação por alçada,
		composição de demanda e emissão de pedido de compra.
		Governa a rastreabilidade entre necessidade interna e
		compromisso econômico inter-organizacional, e produz o
		sinal de demanda consumível por CMT, BDG e NIM. A
		conversão de pedido em compromisso depende de aceite do
		fornecedor e não é garantida. Não formaliza compromissos
		(CMT), não controla orçamento (BDG), não seleciona
		fornecedores estrategicamente (SSC), não qualifica
		participantes (NPM).
		"""

	purpose: """
		Separar o ciclo de demanda-a-pedido da formalização de
		compromissos e do controle orçamentário. P2P tem linguagem
		própria (requisição, aprovação, pedido de compra, alçada),
		profissionais próprios (área de compras, requisitantes técnicos)
		e cadência de evolução independente (processos de procurement
		mudam por política corporativa, não por regulação financeira).
		Sem P2P como unidade separada, o sinal de demanda que origina
		compromissos seria invisível à Mesh — e a Mesh perderia o
		dado mais upstream do ciclo econômico.
		"""

	negativeBoundaries: [{
		responsibility: "Formalização de compromissos econômicos — proposta, aceite mútuo, estado do compromisso."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "P2P emite pedido de compra; CMT formaliza o compromisso bilateral. Pedido é intenção unilateral do comprador; compromisso é acordo bilateral com aceite mútuo."
	}, {
		responsibility: "Controle orçamentário — saldo disponível, limites de comprometimento, alçadas financeiras."
		delegatedTo: {
			type: "subdomain"
			ref:  "bdg"
		}
		rationale: "P2P solicita verificação orçamentária como gate; BDG é o owner canônico do comprometimento. Fusão misturaria fluxo operacional de compras com controle financeiro."
	}, {
		responsibility: "Seleção estratégica de fornecedores — cotação estruturada, equalização TCO, spend analysis."
		delegatedTo: {
			type: "subdomain"
			ref:  "ssc"
		}
		rationale: "P2P consome a decisão de fornecedor; SSC produz a decisão. P2P é execução de compra; SSC é inteligência de sourcing — profissionais e cadências distintos."
	}, {
		responsibility: "Qualificação e compliance de participantes — verificação documental, elegibilidade, IQF."
		delegatedTo: {
			type: "subdomain"
			ref:  "npm"
		}
		rationale: "P2P assume que fornecedor está qualificado; NPM garante a qualificação. P2P não revalida compliance — consome o estado canônico de elegibilidade de NPM."
	}]

	rationale: """
		P2P é supporting porque o processo de procurement é
		domínio com padrões estabelecidos — não proprietário.
		O valor proprietário da Mesh está na captura do sinal
		de demanda como input para inteligência de rede e na
		rastreabilidade demanda→compromisso→execução→pagamento.
		Não é generic porque o pedido de compra alimenta o
		commitment lifecycle e reduz assimetria informacional
		sobre intenção de demanda antes da formação do
		compromisso. O escopo inclui etapas internas apenas
		quando necessárias para originar um compromisso inter-
		organizacional.
		"""
}
