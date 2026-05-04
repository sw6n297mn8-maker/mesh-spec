package ssc

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Strategic Sourcing & Category.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// SSC é o início do macrofluxo canônico Mesh: SSC → {P2P, CTR} → CMT
// → BDG → DLV → INV → FCE. Decide qual fornecedor atende qual
// categoria de demanda, sob regras determinísticas aplicadas a sinais
// estruturados — não inferindo performance nem inventando qualificação.
//
// Frase canônica: SSC decide sourcing. CTR formaliza contrato. P2P
// executa compra.
//
// Authoring manual section-by-section per manualAuthoringProtocol
// (adr-057). Q1-Q10 + 5 ciclos de red team por questão + cascade
// de criação de PG lens + lens-incentive-alignment para Q10.
//
// Materializado em 4 commits incrementais:
//   2.1 — skeleton: identity + classification + roles (este commit)
//   2.2 — capabilities + communication
//   2.3 — businessDecisions + stakeholders + costsEliminated + incentiveAnalysis
//   2.4 — ownership.governanceScope + assumptions + openQuestions + verificationMetrics + rationale outer
//
// Cada commit deixa o canvas em shape válido (cue vet ./...) com
// conteúdo placeholder explícito nas seções pendentes — substituído
// por conteúdo substantivo no commit subsequente.

canvas: artifact_schemas.#Canvas & {
	code: "ssc"
	name: "Strategic Sourcing & Category"

	purpose: """
		Decidir qual fornecedor atende qual categoria de demanda no
		ecossistema das organizações participantes, aplicando regras
		determinísticas a sinais estruturados (elegibilidade NPM,
		contexto RFQ, respostas de fornecedores, e — pós-formalização
		cross-BC — performance NIM e compromissos CTR). SSC é o início
		do macrofluxo Mesh: sem decisão de sourcing canônica, escolha
		de fornecedor acontece fora da rede e o dado mais valioso
		(como e por que um fornecedor foi escolhido) fica perdido.
		SSC NÃO interpreta sinais — aplica regras versionadas; NÃO
		formaliza contrato — apenas designa fornecedor; NÃO executa
		compra — produz decisão consumida por P2P (execução) e CTR
		(formalização contratual, quando aplicável).
		"""

	ubiquitousLanguageRef: "contexts/ssc/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque strategic sourcing é domínio com padrões
			estabelecidos (category management, RFQ, TCO equalization)
			— não é proprietário da Mesh. O valor proprietário está
			na captura estruturada da decisão de sourcing como dado
			canônico que alimenta NIM (rede) + CTR (formalização) +
			P2P (execução) — não no processo de sourcing em si.
			Operational-enabler porque SSC habilita compra estruturada
			downstream sem ser o BC que executa ou formaliza. Product
			(Wardley) porque RFQ + category management são padrões
			amplamente compreendidos e endereçados por soluções de
			mercado (e-procurement, sourcing platforms); a Mesh adapta
			o padrão integrando-o ao macrofluxo como decisão capturada
			com decisionRationale rico.
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Sourcing estratégico opera sobre primitivas universais
			(categoria, RFQ, fornecedor qualificado, decision rationale)
			que não dependem da vertical de aplicação. SSC nasce
			aplicado à construção civil (vertical inicial Mesh), mas
			seus mecanismos — gate de qualificação NPM, equalização via
			fitness rules em config externa governada, decision events
			com decisionRationale estruturado — são reutilizáveis em
			qualquer cadeia produtiva B2B com vocabulário adaptado.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["analysis"]
		rationale: """
			Gateway como primário: SSC é gate de progressão do
			macrofluxo — sem decisão de sourcing canônica vigente, P2P
			não emite pedido (per bd-procurement-requires-sourcing-
			authority). Analysis como secundário: SSC analisa fitness
			signals estruturados aplicando regras determinísticas para
			produzir decisão. SSC NÃO é execution (P2P) nem
			specification (CTR) — articulado em
			bd-sourcing-decides-not-formalizes-not-executes.
			"""
	}

	// =============================================
	// CAPABILITIES — placeholder; conteúdo em commit 2.2
	// =============================================

	capabilities: {
		operational: [{
			description: "Placeholder — capabilities operacionais (4 entries) entram em commit 2.2."
			rationale:   "Skeleton commit 2.1 estabelece shape; conteúdo substantivo (cc-04 audit + cc-03 24/7 + decisionRationale capture + query SoT) entra em commit 2.2."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// =============================================
	// COMMUNICATION — placeholder; conteúdo em commit 2.2
	// =============================================

	communication: {
		rationale: "Placeholder — communication completa (6 inbound + 4 outbound) entra em commit 2.2."
	}

	// =============================================
	// STAKEHOLDERS — placeholder; conteúdo em commit 2.3
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Placeholder — completado em commit 2.3."
		impactDescription: "Placeholder — completado em commit 2.3."
		rationale:         "Skeleton stakeholder; 3 stakeholders substantivos (sh-01, sh-02, sh-05) em commit 2.3."
	}]

	// =============================================
	// INCENTIVE ANALYSIS — placeholder; conteúdo em commit 2.3
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Placeholder — preenchido em commit 2.3."
			desiredBehavior:           "Placeholder."
			correctOperationIncentive: "Placeholder."
			manipulationVector:        "Placeholder."
			manipulationCost:          "Placeholder."
			vsBenefit:                 "Placeholder."
			designResponse:            "Placeholder."
			rationale:                 "Skeleton; 3 participants com manipulation vectors substantivos em commit 2.3."
		}]
		rationale: "Placeholder — incentive analysis completo (3 vetores adversariais) entra em commit 2.3."
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 2.4
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/ssc/agents/ssc-primary-agent.cue"
		governanceScope: {}
		rationale:       "Skeleton commit 2.1 estabelece domainAgentSpec canônico (forward reference — agent-spec será autorado em Phase 4 do bootstrap WI-060). governanceScope completo (6 autonomousDecisions + 4 supervisedDecisions + 5 escalationCriteria) entra em commit 2.4."
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 2.4
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + 7 businessDecisions + 4 lenses + Phase 0 caveats + anti-mini-NIM principle) entra em commit 2.4."
}
