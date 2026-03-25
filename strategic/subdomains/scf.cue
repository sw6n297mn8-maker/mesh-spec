package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

scf: artifact_schemas.#Subdomain & {
	code: "scf"
	name: "Supply Chain Finance"
	type: "supporting-subdomain"

	definition: """
		Originação de produtos financeiros sobre recebíveis
		operacionais — antecipação de recebíveis, reverse
		factoring, dynamic discounting e capital de giro.
		Consome recebíveis lastreados produzidos por ECL e
		decisões de risco de REW. Não governa o lifecycle do
		compromisso (ECL), não executa pagamentos (FCE), não
		modela risco (REW), não formaliza contratos (CTR).
		"""

	purpose: """
		Separar originação de produtos financeiros da
		infraestrutura que a viabiliza. ECL produz recebíveis
		operacionais, REW precifica, FCE executa — SCF estrutura
		produtos financeiros consumindo esses três. Sem SCF como
		unidade separada, a lógica de produto financeiro ficaria
		distribuída entre ECL (originação), REW (pricing) e FCE
		(execução) sem owner canônico.
		"""

	negativeBoundaries: [{
		responsibility: "Lifecycle do compromisso econômico — state machine, transições."
		delegatedTo: {
			type: "subdomain"
			ref:  "ecl"
		}
		rationale: "SCF consome recebíveis operacionais produzidos por ECL; não governa como são produzidos. Fusão acoplaria produtos financeiros ao lifecycle operacional — cadências de regulação distintas."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement, budget."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "SCF origina; FCE executa. Separação permite novos produtos financeiros sem alterar a orquestração de pagamentos."
	}, {
		responsibility: "Precificação de risco — políticas de crédito, limites."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "SCF consome decisões de risco de REW; não as produz. Fusão acoplaria originação de produto à modelagem de risco — dois corpos de conhecimento com stakeholders distintos."
	}, {
		responsibility: "Formalização contratual — termos de cessão, condições de antecipação."
		delegatedTo: {
			type: "subdomain"
			ref:  "ctr"
		}
		rationale: "SCF define regras de produto; CTR formaliza contratos. Separação permite que a formalização evolua com regulação enquanto regras de produto evoluem com mercado."
	}]

	rationale: """
		SCF é supporting porque produtos de supply chain finance
		(antecipação, factoring, desconto dinâmico) são padrões
		exógenos do mercado financeiro — não proprietários à Mesh.
		O diferencial proprietário é o lastro em evidência
		verificável (mech-evidence via ECL) e o pricing baseado em
		dados observados (mech-network via REW). SCF combina esses
		diferenciais em produtos que o mercado já conhece —
		inovação é no lastro, não no produto.
		"""
}
