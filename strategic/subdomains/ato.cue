package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ato: artifact_schemas.#Subdomain & {
	code: "ato"
	name: "Accounting & Tax Operations"
	type: "supporting-subdomain"

	definition: """
		Contabilidade e obrigações fiscais derivadas de operações
		financeiras — lançamentos contábeis, apuração de impostos,
		reporting regulatório e conciliação fiscal. Consome eventos
		financeiros de FCE e produz registros contábeis e fiscais
		auditáveis. Não executa pagamentos (FCE), não origina
		produtos financeiros (SCF), não governa o lifecycle do
		compromisso econômico (ECL).
		"""

	purpose: """
		Separar consequências contábeis e fiscais da execução
		financeira que as origina. Regras fiscais mudam por
		regulação (legislação tributária, normas contábeis), não
		por produto ou mercado. Sem ATO como unidade separada,
		FCE absorveria lógica fiscal — acoplando evolução de
		execução financeira a um domínio com cadência de mudança
		exógena e especialização profissional distinta (contadores,
		não engenheiros financeiros).
		"""

	negativeBoundaries: [{
		responsibility: "Execução financeira — orquestração de pagamentos, settlement, budget."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "ATO registra consequências fiscais; FCE executa a movimentação que as gera. Separação permite que regras fiscais evoluam por legislação sem alterar fluxo de pagamento."
	}, {
		responsibility: "Originação de produtos financeiros — antecipação, factoring."
		delegatedTo: {
			type: "subdomain"
			ref:  "scf"
		}
		rationale: "ATO computa impostos sobre operações de SCF; não origina produtos. Fusão acoplaria compliance fiscal a inovação de produto — incentivos e cadências opostos."
	}, {
		responsibility: "Lifecycle do compromisso econômico — state machine, transições."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "ATO consome eventos do commitment lifecycle para apuração fiscal; não governa progressão. CMT é owner do estado do compromisso. Fusão inflaria o lifecycle com complexidade tributária específica por jurisdição."
	}]

	rationale: """
		ATO é supporting porque contabilidade e fiscalidade são
		domínios regulatoriamente determinados, não proprietários.
		Padrões contábeis (IFRS, CPC) e legislação fiscal são
		exógenos à Mesh. O valor proprietário da Mesh está na
		execução financeira (FCE) e no lastreamento (ECL), não
		nos lançamentos contábeis derivados dessas operações.
		"""
}
