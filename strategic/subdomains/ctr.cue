package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ctr: artifact_schemas.#Subdomain & {
	code: "ctr"
	name: "Contract & Terms Registry"
	type: "supporting-subdomain"

	definition: """
		Formalização e gestão do ciclo de vida de instrumentos
		contratuais — contratos-quadro, contratos de
		fornecimento e termos contratuais aplicáveis a pedidos
		de compra, ordens de serviço, SLAs, cláusulas de
		retenção e requisitos de garantias. Governa os termos
		sob os quais compromissos econômicos são firmados. Não
		governa o lifecycle do compromisso econômico em si
		(CMT), não executa pagamentos (FCE), não avalia risco
		(REW), não gerencia instrumentos de proteção de risco
		(INS), não governa o ciclo de procurement (P2P).
		"""

	purpose: """
		Separar a complexidade de formalização contratual do
		lifecycle do compromisso econômico. Instrumentos
		contratuais têm regras, vocabulário e cadência de
		evolução próprios — contratos-quadro definem condições
		gerais entre partes, SLAs definem níveis de serviço,
		e cláusulas específicas governam retenção e garantias.
		Sem CTR como unidade separada, CMT absorveria toda a
		complexidade contratual — inflando o core com lógica
		que é supporting por natureza.
		"""

	negativeBoundaries: [{
		responsibility: "Lifecycle do compromisso econômico — state machine, transições, fases."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "CTR formaliza termos contratuais; CMT instancia e governa o lifecycle do compromisso sob esses termos. Fusão acoplaria evolução de cláusulas contratuais à evolução de fases operacionais — dois eixos de mudança independentes."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement, budget."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "CTR define condições de pagamento; FCE executa. Separação permite que termos contratuais evoluam sem alterar a orquestração financeira."
	}, {
		responsibility: "Disputas e reversões — contestações, penalidades, estornos."
		delegatedTo: {
			type: "subdomain"
			ref:  "drc"
		}
		rationale: "CTR define cláusulas de penalidade e retenção; DRC orquestra a resolução quando essas cláusulas são invocadas. Separação mantém formalização desacoplada de execução de exceções."
	}, {
		responsibility: "Seleção estratégica de fornecedores — avaliação comparativa, negociação de termos indicativos, decisão de sourcing."
		delegatedTo: {
			type: "subdomain"
			ref:  "ssc"
		}
		rationale: "CTR formaliza termos contratuais vinculantes; SSC negocia condições preliminares e parâmetros de acordo. Negociação preliminar (SSC) precede formalização contratual (CTR) — cadências e profissionais distintos."
	}, {
		responsibility: "Instrumentos de proteção de risco — apólices, seguro garantia, performance bonds."
		delegatedTo: {
			type: "subdomain"
			ref:  "ins"
		}
		rationale: "CTR formaliza contratos comerciais; INS gerencia instrumentos de proteção emitidos por seguradoras. Apólice não é cláusula contratual — é instrumento jurídico independente."
	}, {
		responsibility: "Execução de compliance de comércio exterior — desembaraço aduaneiro, licenças de importação, habilitação RADAR."
		delegatedTo: {
			type: "subdomain"
			ref:  "itc"
		}
		rationale: "CTR formaliza termos contratuais incluindo condições de comércio exterior como cláusula; ITC executa o compliance aduaneiro. Formalização contratual e execução aduaneira são processos com cadências e profissionais distintos."
	}, {
		responsibility: "Ciclo de procurement — requisição, aprovação, emissão de pedido de compra."
		delegatedTo: {
			type: "subdomain"
			ref:  "p2p"
		}
		rationale: "CTR governa termos contratuais aplicáveis a pedidos de compra; P2P governa o ciclo de procurement que os emite. Termos contratuais (CTR) precedem e condicionam o pedido (P2P), mas emissão e aprovação são processo de compras."
	}]

	rationale: """
		CTR é supporting porque formalização contratual é domínio
		bem entendido e não proprietário — padrões contratuais de
		construção civil, logística e energia são exógenos à Mesh.
		O valor proprietário está no commitment lifecycle (CMT) e na
		execução financeira (FCE), não na modelagem de contratos.
		CTR serve como registry canônico de termos contratuais que
		CMT e FCE consomem.
		"""
}
