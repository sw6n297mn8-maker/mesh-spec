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

	capabilities: {
		operational: [{
			capabilityRef: "cc-03"
			description: """
				Operação 24/7 via gate determinístico de emissão:
				InvoiceIssued + ReceivableMaterialized atomic emit
				triggered por consumo de DeliveryVerified (DLV
				terminal=approved); sem janelas de aprovação humana no
				caminho normal. Gate é função categórica (verification
				approved sim/não → fatura nasce sim/não), não
				julgamento. Cancelamento dentro de janela fiscal segue
				mesmo padrão: gate categórico (within-window sim/não),
				sem interpretação.
				"""
			rationale: """
				Capability matches cc-03 do domain-definition (24/7
				disponibilidade); INV-specific aspect: emission gate é
				deterministic (verification approved sim/não), não
				exige reasoning sobre payload. Paralelo P2P (authority
				gate deterministic) e DLV (criteria match function
				pura). Cancelamento fora-da-janela é supervisedDecision
				separado, não orchestration.
				"""
		}, {
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua e regulatory-grade de invoices
				emitidas: cada InvoiceIssued carrega imutavelmente
				(commitmentRef, evidenceRef, criteriaVersion,
				regimeVersion, taxBreakdown, fiscalDocRef, issuedAt) +
				trace completo dos inputs e outputs fiscais aplicados,
				sem interpretação ou justificativa do regime; trail
				satisfaz exigência fiscal regulatória (retenção legal
				NF-e ≥5 anos). InvoiceCancelled preserva trail completo
				do invoice cancelado (fiscalCancellationRef +
				reasonCode categórico).
				"""
			rationale: """
				Capability matches cc-04 do domain-definition (audit
				contínuo); INV-specific aspect: audit trail é
				fiscal-grade (regulação tributária exige
				rastreabilidade documento + inputs + outputs, sem
				justificativa de regime que invadiria domínio ATO).
				Imutabilidade pós-emit é invariante estrutural —
				soft-delete proibido (G3 guardrail).
				"""
		}, {
			description: """
				Cômputo fiscal apply-only deterministic: dado regime
				fiscal resolvido (read-only input), commitment terms
				verificados (read-only via CMT projection cache) e
				verification outcome categórico (approved), INV calcula
				taxBreakdown aplicando tabelas declarativas (CFOP +
				alíquotas + retenções) — sem interpretar regime, sem
				decidir enquadramento, sem alterar amount. Função pura:
				input idêntico → output idêntico reproduzível em replay
				(paralelo BD2 DLV idempotency).
				"""
			rationale: """
				Sem capability própria de domain-definition — emerge da
				análise dos businessDecisions: apply-only é o RECTOR
				estrutural anti-mini-ATO. Sem isso, INV vira
				interpretador fiscal e absorve responsabilidade ATO.
				Determinismo é precondition de cc-03 (24/7) e cc-04
				(audit reproducible).
				"""
		}, {
			description: """
				Emissão atômica com lifecycle público mínimo:
				InvoiceIssued + ReceivableMaterialized emitidos
				atomicamente via primitive de infraestrutura que
				garante consistência entre estado e publicação de
				eventos; InvoiceCancelled emitido como evento explícito
				dentro de janela fiscal. Conservação de valor:
				ReceivableMaterialized.amount == InvoiceIssued.amount
				sempre (mesma fonte computacional). Idempotência: tupla
				(commitmentRef, evidenceRef) gera no máximo um
				InvoiceIssued (replay-safe). Sem eventos intermediários
				ou de ajuste — ajustes pós-issued vivem em DRC/ATO,
				não em INV.
				"""
			rationale: """
				Sem capability própria de domain-definition —
				capability core do INV. Sustenta G1 (idempotência
				operacional), G2 (receivable.amount == invoice.amount
				sempre) e G3 (cancelamento sempre evento explícito,
				não soft-delete). Lifecycle público mínimo (3 events
				cobrindo nascimento atomic + morte dentro da janela
				fiscal) previne INV virar workflow engine; correções
				fora dessa janela são DRC (disputa) ou ATO (ajuste
				contábil), não mutações INV. Atomic emit é
				responsabilidade da infrastructure (declarado como
				contract, não mecanismo).
				"""
		}]
		hasSyncSurface:  false
		hasAsyncSurface: true
	}
}
