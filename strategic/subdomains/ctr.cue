package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ctr: artifact_schemas.#Subdomain & {
	code: "ctr"
	name: "Contract & Terms Registry"
	type: "supporting-subdomain"

	definition: """
		Formalização e gestão do ciclo de vida de contratos,
		pedidos de compra, ordens de serviço, cláusulas de
		retenção e requisitos de garantias. Governa os termos
		sob os quais compromissos econômicos são firmados. Não
		governa o lifecycle do compromisso econômico em si (ECL),
		não executa pagamentos (FCE), não avalia risco (REW).
		"""

	purpose: """
		Separar a complexidade de formalização contratual do
		lifecycle do compromisso econômico. Contratos têm regras,
		vocabulário e cadência de evolução próprios (cláusulas
		de SLA, retenção, garantia). Sem CTR como unidade separada,
		ECL absorveria toda a complexidade contratual — inflando
		o core com lógica que é supporting por natureza.
		"""

	negativeBoundaries: [{
		responsibility: "Lifecycle do compromisso econômico — state machine, transições, fases."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "CTR formaliza termos; CMT governa a formalização e o estado do compromisso sob esses termos. Fusão acoplaria evolução de cláusulas contratuais à evolução de fases operacionais — dois eixos de mudança independentes."
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
	}]

	rationale: """
		CTR é supporting porque formalização contratual é domínio
		bem entendido e não proprietário — padrões contratuais de
		construção civil, logística e energia são exógenos à Mesh.
		O valor proprietário está no lifecycle (ECL) e na execução
		financeira (FCE), não na modelagem de contratos. CTR serve
		como registry canônico que ECL e FCE consomem.
		"""
}
