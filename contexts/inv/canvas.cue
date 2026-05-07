package inv

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// inv-canvas — Bounded Context Canvas para Invoicing.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// INV materializa Wave 0 commitment-lifecycle Phase Invoicing —
// ponto onde execução verificada é formalizada como obrigação de
// faturamento e direito creditório transferível. Boundary core
// anti-mini-ATO: INV aplica regras fiscais, não as interpreta.
//
// Phases incrementais por section per manualAuthoringProtocol
// (adr-057). Phase 1.1 (commit anterior): identity-and-purpose.
// Phase 1.2 (este commit): strategic-classification + correção
// convenção package/variable.

canvas: artifact_schemas.#Canvas & {

	code: "inv"
	name: "Invoicing"

	purpose: """
		Materializar obrigação de faturamento (InvoiceIssued) e o
		direito creditório associado (ReceivableMaterialized) a partir
		de DeliveryVerified (DLV terminal=approved), aplicando regime
		fiscal regulado de forma determinística.

		Existe como BC SEPARADO de DLV, FCE, ATO e SCF porque a
		linguagem fiscal de faturamento (NF-e, CFOP, alíquotas,
		retenções) tem regulação tributária própria, cadência distinta
		e profissionais distintos da verificação operacional (DLV),
		execução financeira (FCE), contabilidade fiscal (ATO) e
		originação de produtos sobre recebíveis (SCF). Sem INV como
		unidade canônica, o momento em que a execução verificada é
		formalizada como obrigação de faturamento e direito creditório
		ficaria entre DLV (que verifica mas não fatura) e ATO (que
		contabiliza mas não materializa) — sem owner explícito.

		INV é estritamente projeção determinística: aplica regras
		fiscais sobre commitment terms verificados, sem decisão
		econômica, sem interpretação operacional e sem qualquer forma
		de otimização ou priorização de fluxo financeiro. Boundary
		core anti-mini-ATO: INV aplica, não interpreta — regime fiscal
		e enquadramento tributário são resolvidos fora do INV e
		consumidos como input read-only.
		"""

	ubiquitousLanguageRef: "contexts/inv/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque faturamento e materialização do recebível
			são regulados por regime fiscal externo (legislação tributária,
			tabelas CFOP, regras de retenção) — aplicação determinística
			de regras públicas, sem espaço para diferenciação competitiva
			da Mesh. A vantagem competitiva está em DLV (provar execução)
			e em SCF/REW (transformar recebível verificado em produtos
			financeiros); INV é o passo regulado e necessário entre os
			dois, não onde a tese ganha. operational-enabler porque INV
			viabiliza a transição de execução verificada para fluxo
			financeiro (alimentando FCE, ATO, SCF) — não é gate de
			bloqueio (compliance-enforcer) nem fonte direta de receita
			(revenue-generator). Wardley product: faturamento eletrônico
			é prática estabelecida no Brasil há ~15 anos (NF-e v1.0 em
			2006), evolui por mudança regulatória externa, não por
			inovação interna.
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Boundary INV é horizontal por natureza — regime fiscal é
			input jurisdicional vertical, não estrutura do BC. O engine
			(aplicar regime + materializar InvoiceIssued +
			ReceivableMaterialized) opera sobre primitivas universais
			(commitment terms, verification outcome, regime config);
			regimes concretos (NF-e Brasil, VAT EU, GST APAC) entram
			como configuração read-only sem alterar a estrutura do BC.
			Regime fiscal é tratado como configuração declarativa
			externa, não como lógica interna do BC — proteção crítica
			contra config-virando-lógica que transformaria INV em
			mini-ATO. Paralelo P2P/SSC/DLV: mecanismos do BC são
			genéricos, regimes/critérios são externos.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["execution"]
		rationale: """
			Primary gateway: INV é a transição canônica entre operação
			verificada (DLV terminal=approved) e materialização fiscal
			e projeção em obrigação de faturamento (InvoiceIssued para
			FCE/ATO) e direito creditório (ReceivableMaterialized para
			SCF) — paralelo BDG (gateway approval), DLV (gateway
			verification), NPM/P2P/SSC (gateway de suas respectivas
			fases). Secondary execution: INV executa cômputo fiscal
			determinístico (apply-only), sem interpretar regime, sem
			decidir enquadramento e sem alterar valor — CFOP +
			alíquotas + retenções resolvidos por regime read-only; não
			é analysis (não interpreta), não é draft (não propõe), não
			é specification (não define regras).
			"""
	}
}
