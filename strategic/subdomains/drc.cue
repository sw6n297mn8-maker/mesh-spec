package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

drc: artifact_schemas.#Subdomain & {
	code: "drc"
	name: "Disputes, Reversals & Corrections"
	type: "supporting-subdomain"

	definition: """
		Orquestração do lifecycle de exceções — disputas,
		contestações, não conformidades, penalidades e estornos.
		Governa o fluxo de alegação, evidência, resolução e
		impacto econômico de reversões. Não governa o fluxo
		normal do compromisso econômico (ECL), não executa
		estornos financeiros (FCE), não define cláusulas de
		penalidade (CTR).
		"""

	purpose: """
		Separar o fluxo de exceção do fluxo normal. Disputas têm
		lifecycle próprio (alegação→evidência→resolução→impacto)
		com regras, prazos e stakeholders distintos do fluxo de
		compromisso. Sem DRC como unidade separada, ECL absorveria
		toda a complexidade de reversões — inflando o core com
		lógica que é inerentemente excepcional e regulatoriamente
		pesada.
		"""

	negativeBoundaries: [{
		responsibility: "Lifecycle do compromisso econômico — fluxo normal de progressão."
		delegatedTo: {
			type: "subdomain"
			ref:  "ecl"
		}
		rationale: "DRC trata exceções que afetam compromissos; ECL governa o fluxo normal. Fusão misturaria regras de progressão com regras de reversão — lógica de exceção inflaria a state machine do lifecycle."
	}, {
		responsibility: "Execução de estornos financeiros — movimentação reversa de dinheiro."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "DRC decide que um estorno é devido; FCE executa a movimentação. Separação mantém decisão de reversão desacoplada de orquestração financeira."
	}, {
		responsibility: "Formalização de cláusulas de penalidade e retenção."
		delegatedTo: {
			type: "subdomain"
			ref:  "ctr"
		}
		rationale: "DRC aplica penalidades quando cláusulas são invocadas; CTR define as cláusulas. Separação permite que termos contratuais evoluam sem alterar a orquestração de disputas."
	}]

	rationale: """
		DRC é supporting porque a gestão de disputas, embora
		complexa, é domínio com padrões exógenos (processos de
		contestação, regras de estorno, prazos regulatórios).
		O valor proprietário está em como a Mesh resolve disputas
		usando evidência verificável (mech-evidence) — mas a
		orquestração do processo em si é supporting.
		"""
}
