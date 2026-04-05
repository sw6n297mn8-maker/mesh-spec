package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ssc: artifact_schemas.#Subdomain & {
	code: "ssc"
	name: "Strategic Sourcing & Category"
	type: "supporting-subdomain"

	definition: """
		Seleção estratégica de fornecedores e gestão de categorias
		de compra no contexto das organizações participantes:
		cotação estruturada, equalização TCO, spend analysis e
		decisão de sourcing. Governa como e por que um fornecedor
		é escolhido para um compromisso, e produz a decisão de
		fornecedor consumível por P2P e os dados de sourcing que
		alimentam NIM. A decisão de sourcing não implica
		compromisso formalizado nem garante execução de compra
		ou seleção final no pedido emitido. Não executa compra
		(P2P), não formaliza compromissos (CMT), não qualifica
		participantes (NPM), não computa reputação (NIM).
		"""

	purpose: """
		Separar inteligência de sourcing da execução de compra e
		da qualificação de participantes. SSC tem linguagem própria
		(categoria, TCO, spend, equalização, RFQ), profissionais
		próprios (strategic sourcing, category managers) e cadência
		de evolução independente (ciclos de negociação e contratos
		framework são anuais ou plurianuais). Sem SSC como unidade
		separada, decisões de fornecedor acontecem fora da rede e
		a Mesh perde o dado mais valioso para NIM: como e por que
		um fornecedor foi escolhido.
		"""

	negativeBoundaries: [{
		responsibility: "Execução de compra — requisição, aprovação por alçada, emissão de pedido de compra."
		delegatedTo: {
			type: "subdomain"
			ref:  "p2p"
		}
		rationale: "SSC decide qual fornecedor; P2P executa a compra. SSC é estratégico (qual fornecedor para qual categoria); P2P é operacional (emitir pedido aprovado)."
	}, {
		responsibility: "Formalização de compromissos econômicos — proposta, aceite mútuo, estado do compromisso."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "SSC produz decisão de sourcing; CMT formaliza o compromisso bilateral. Decisão de fornecedor não é compromisso — é input para compromisso."
	}, {
		responsibility: "Qualificação e compliance de participantes — verificação documental, elegibilidade, IQF."
		delegatedTo: {
			type: "subdomain"
			ref:  "npm"
		}
		rationale: "SSC assume que fornecedores cotados estão qualificados; NPM garante a qualificação. SSC seleciona entre qualificados — não revalida compliance."
	}, {
		responsibility: "Computação de reputação e inteligência de rede — scoring, matching, ranking, mecanismos algorítmicos."
		delegatedTo: {
			type: "subdomain"
			ref:  "nim"
		}
		rationale: "SSC consome inteligência de NIM para decisões de sourcing; NIM produz a inteligência. SSC é consumidor de dados analíticos, não produtor de modelos."
	}, {
		responsibility: "Formalização contratual — contratos, framework agreements, ordens de serviço, cláusulas, SLAs."
		delegatedTo: {
			type: "subdomain"
			ref:  "ctr"
		}
		rationale: "SSC negocia termos indicativos e seleciona fornecedor; CTR formaliza o contrato com cláusulas jurídicas, SLAs e retenções. SSC é decisão de sourcing; CTR é formalização legal."
	}]

	rationale: """
		SSC é supporting porque strategic sourcing é domínio com
		padrões estabelecidos (category management, RFQ, TCO) —
		não proprietário. O valor proprietário da Mesh está na
		inteligência que NIM produz e que SSC consome. Não é
		generic porque a decisão de sourcing na Mesh alimenta o
		commitment lifecycle e captura dados que retroalimentam
		inteligência de rede — supporting estratégico com alto
		leverage sobre a qualidade dos cores.
		"""
}
