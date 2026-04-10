package subdomains

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

scf: artifact_schemas.#Subdomain & {
	code: "scf"
	name: "Supply Chain Finance"
	type: "supporting-subdomain"

	definition: """
		Estruturação e oferta de produtos financeiros sobre
		recebíveis operacionais e preparação de carteiras
		para distribuição a investidores — antecipação de
		recebíveis, reverse factoring, dynamic discounting,
		capital de giro e preparação de portfólios para
		veículos de securitização. Consome recebíveis
		materializados por INV a partir do commitment
		lifecycle e decisões de risco de REW. A estruturação
		de produto não garante disponibilidade de funding nem
		elegibilidade da carteira para securitização. Não
		governa o lifecycle do compromisso (CMT), não executa
		pagamentos (FCE), não modela risco (REW), não
		formaliza contratos (CTR), não gerencia instrumentos
		de proteção (INS), não materializa recebíveis (INV).
		"""

	purpose: """
		Separar estruturação e oferta de produtos financeiros
		da infraestrutura que os viabiliza. INV materializa
		recebíveis operacionais, REW precifica, FCE executa
		— SCF estrutura produtos financeiros e prepara
		portfólios para distribuição, consumindo esses três.
		Sem SCF como unidade separada, a lógica de produto
		financeiro e de elegibilidade para securitização
		ficaria distribuída entre CMT+DLV+INV (originação),
		REW (pricing) e FCE (execução) sem owner canônico.
		"""

	negativeBoundaries: [{
		responsibility: "Lifecycle do compromisso econômico — state machine, transições."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "SCF consome recebíveis materializados por INV a partir do commitment lifecycle (CMT governa estado); não governa como são produzidos. Fusão acoplaria produtos financeiros ao lifecycle operacional — cadências de regulação distintas."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement, budget."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "SCF estrutura; FCE executa. Separação permite novos produtos financeiros sem alterar a orquestração de pagamentos."
	}, {
		responsibility: "Precificação de risco — políticas de crédito, limites."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "SCF define parâmetros de produto e consome decisões de risco de REW para elegibilidade e precificação; não produz avaliação de risco. Fusão acoplaria originação de produto à modelagem de risco — dois corpos de conhecimento com stakeholders distintos."
	}, {
		responsibility: "Formalização contratual — termos de cessão, condições de antecipação."
		delegatedTo: {
			type: "subdomain"
			ref:  "ctr"
		}
		rationale: "SCF define regras de produto; CTR formaliza contratos. Separação permite que a formalização evolua com regulação enquanto regras de produto evoluem com mercado."
	}, {
		responsibility: "Materialização de recebíveis operacionais — derivação de ativos a partir da execução e evidência."
		delegatedTo: {
			type: "subdomain"
			ref:  "inv"
		}
		rationale: "SCF consome recebíveis materializados por INV como base para estruturação de produtos financeiros; não governa a criação do ativo subjacente. Fusão acoplaria originação financeira à derivação do lastro — dois momentos distintos da cadeia de valor."
	}, {
		responsibility: "Instrumentos de proteção de risco — apólices, seguro garantia, performance bonds."
		delegatedTo: {
			type: "subdomain"
			ref:  "ins"
		}
		rationale: "SCF estrutura produtos financeiros; INS gerencia instrumentos de proteção. Cobertura de seguro melhora perfil do ativo para securitização, mas é input de SCF, não produto de SCF."
	}, {
		responsibility: "Estruturação jurídica de veículos de securitização — constituição de FIDC, regulação CVM, administração fiduciária e gestão de portfólio de investimentos."
		delegatedTo: {
			type: "external-system"
			ref:  "ext-securitization-admin"
		}
		rationale: "SCF prepara carteiras e define critérios de elegibilidade; a constituição e administração de veículos de securitização é responsabilidade de administradores fiduciários e gestores regulados pela CVM. A Mesh não é administradora fiduciária nem gestora de FIDC."
	}]

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			O subdomain SCF estrutura produtos financeiros padronizados
			do mercado global (antecipação de recebíveis, reverse factoring,
			dynamic discounting, capital de giro, securitização) sobre
			recebíveis operacionais materializados por INV. Nenhum destes
			produtos carrega vocabulário, mecanismo ou premissa
			construção-específica: são padrões exógenos da disciplina de
			Supply Chain Finance, aplicáveis a qualquer cadeia produtiva
			B2B com recebíveis rastreáveis.

			O próprio rationale do subdomain é autoatestado neste ponto:
			"produtos de supply chain finance [...] são padrões exógenos
			do mercado financeiro — não proprietários à Mesh. O diferencial
			proprietário é o lastro em evidência verificável (mech-evidence
			via DLV) e o pricing baseado em dados observados (mech-network
			via REW). SCF combina esses diferenciais em produtos que o
			mercado já conhece — inovação é no lastro, não no produto."

			O binding construção-específico da Mesh, se existir no plano
			financeiro, vive upstream em DLV (materialização de evidência),
			INV (derivação de recebíveis) e REW (pricing de risco) — não
			em SCF. SCF é um orquestrador de produtos financeiros
			padronizados. As menções regulatórias (FIDC, CVM, performance
			bonds) são âncoras jurisdicionais (Brasil), não setoriais —
			FIDC pode securitizar recebíveis de qualquer vertical.
			"""
	}

	rationale: """
		SCF é supporting porque produtos de supply chain finance
		(antecipação, factoring, desconto dinâmico) e
		securitização de recebíveis são padrões exógenos do
		mercado financeiro — não proprietários à Mesh. O
		diferencial proprietário é o lastro em evidência
		verificável (mech-evidence via DLV) e o pricing baseado
		em dados observados (mech-network via REW). SCF combina
		esses diferenciais em produtos que o mercado já conhece
		— inovação é no lastro, não no produto.
		"""
}
