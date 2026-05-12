package bkr

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Banking Rails & Settlement.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// BKR é boundary entre a Mesh (lógica financeira proprietária) e o
// sistema financeiro regulado pelo Bacen (rails comoditizados,
// protocolos uniformes Pix, TED, boleto e, quando aplicável,
// SWIFT/correspondent banking). Executa liquidação física sob
// autorização upstream — não decide mérito econômico de pagamento
// (decisão permanece em FCE/TCM/policy).
//
// Anti-core differentiator: high criticality operacional (movimenta
// dinheiro real, regulado pelo Bacen e integrado ao SPB/PIX por meio
// de instituições autorizadas) com low strategic uniqueness (rails
// substituíveis por qualquer provedor que implemente os mesmos
// protocolos). BKR existe como BC separado para absorver
// heterogeneidade de protocolos bancários atrás de interface
// uniforme — sem isto, FCE absorveria complexidade de cada rail e
// acoplaria lógica financeira proprietária a integrações commodity.
//
// Frase canônica do papel: BKR é o portão técnico para os rails;
// FCE decide a obrigação econômica; o Bacen regula o sistema
// financeiro pelo qual o dinheiro se move.
//
// Authoring manual section-by-section per manualAuthoringProtocol
// (adr-057). Materializado em 7 commits incrementais:
//   1.1 — skeleton: identity + classification + roles + ownership
//         (este commit)
//   1.2 — capabilities
//   1.3 — businessDecisions + stakeholders (generic isento de
//         costsEliminated per tq-cv-10)
//   1.4 — communication (inbound from FCE; outbound settlement
//         events; query-deps a TCM/providers; commands;
//         query-surfaces)
//   1.5 — incentiveAnalysis + governanceScope
//   1.6 — assumptions + openQuestions + verificationMetrics +
//         outer rationale
//   1.7 — SRR srr-bkr-canvas
//
// Cada commit deixa o canvas em shape válido (cue vet ./...) com
// conteúdo placeholder explícito nas seções pendentes — substituído
// por conteúdo substantivo no commit subsequente.

canvas: artifact_schemas.#Canvas & {
	code: "bkr"
	name: "Banking Rails & Settlement"

	purpose: """
		Executar liquidação física via rails bancários (Pix, TED,
		boleto e, quando aplicável, SWIFT/correspondent banking) sob
		autorização upstream. BKR é boundary entre a Mesh (lógica
		financeira proprietária) e o sistema financeiro regulado pelo
		Bacen e integrado ao SPB/PIX por meio de instituições
		autorizadas (rails comoditizados, protocolos uniformes). Não
		decide mérito econômico de pagamento — decisão de quando e
		por que pagar permanece upstream em FCE (liquidação), TCM
		(tesouraria) ou policy. BKR pode tomar decisões técnicas de
		roteamento e rail selection (qual protocolo usar; retry
		strategy; timeout handling), mas nunca decisão econômica
		(autorizar pagamento, definir valor, alterar destinatário).

		Anti-core differentiator: high criticality operacional
		(movimenta dinheiro real, regulado pelo Bacen e integrado ao
		SPB/PIX por meio de instituições autorizadas) com low
		strategic uniqueness (rails substituíveis por qualquer
		provedor que implemente os mesmos protocolos). BKR existe
		como BC separado para absorver heterogeneidade de protocolos
		bancários atrás de interface uniforme — sem isto, FCE
		absorveria complexidade de cada rail e acoplaria lógica
		financeira proprietária a integrações commodity.
		"""

	ubiquitousLanguageRef: "contexts/bkr/glossary.cue"

	classification: {
		subdomainType:    "generic"
		businessRole:     "operational-enabler"
		wardleyEvolution: "commodity"
		rationale: """
			Generic porque rails bancários (Pix, TED, boleto e,
			quando aplicável, SWIFT/correspondent banking) são
			infraestrutura comoditizada — protocolos definidos pelo
			Bacen e instituições financeiras, não pela Mesh.
			Diferenciação competitiva reside em FCE (quando/por que
			pagar) e REW (sob quais condições), não em como o
			dinheiro se move fisicamente. BKR é substituível por
			construção: qualquer provedor que implemente os mesmos
			protocolos realiza a mesma função.

			Operational-enabler porque BKR habilita execução
			operacional do sistema (liquidação física) sem ser fonte
			de receita (revenue-generator é CMT/SCF), engajamento
			(engagement-creator é NGR/NPM) ou compliance regulatório
			primário (compliance-enforcer é IDC para LGPD/KYC, ATO
			para fiscal). BKR está sob constraint regulatório do
			Bacen, mas seu papel funcional é executor habilitador,
			não enforcer. Distinção análoga ao papel DLV (compliance
			interna da tese vs externa): BKR sob regulação externa
			Bacen é boundary constraint, não papel ativo de
			enforcement.

			Commodity (Wardley) reflete maturidade dos rails:
			Pix/TED/boleto estabelecidos há anos; SWIFT desde 1973;
			padrões ISO 20022 amplamente adotados. Não é product
			(rails não são solução de mercado vendida pela Mesh);
			não é custom (protocolos não construídos pela Mesh); não
			é genesis (problema completamente resolvido em escala
			global).
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Rails bancários (Pix, TED, boleto e, quando aplicável,
			SWIFT/correspondent banking) são protocolos uniformes
			definidos pelo Bacen e instituições financeiras —
			aplicam-se identicamente a qualquer vertical (construção,
			agronegócio, serviços, comércio exterior, energia).
			Diferenciação por vertical reside em FCE (regras de
			liquidação por contrato) e ATO (compliance fiscal por
			regime tributário do setor), não em como o dinheiro se
			move fisicamente. Estrutura preservada: BKR permanece
			estável enquanto verticais expandem; expansão vertical
			adiciona contratos upstream sem alterar engine de rails.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["execution"]
		rationale: """
			Gateway como primário: BKR é boundary topológico entre
			Mesh e sistema financeiro regulado externo. Captura papel
			de tradução entre vocabulário interno Mesh
			(PaymentInstruction, SettlementRequest) e protocolos
			externos (ISO 20022, COMPE, SWIFT MT). Frase canônica:
			BKR é o portão técnico para os rails; FCE decide a
			obrigação econômica; o Bacen regula o sistema financeiro
			pelo qual o dinheiro se move.

			Execution como secundário: BKR executa liquidação física
			sob autorização upstream — recebe instrução finalizada,
			despacha para rail apropriado, recebe confirmação/falha,
			emite resultado de settlement. A dupla gateway+execution
			captura a tensão fundamental do BKR: topologicamente
			boundary com sistema externo, funcionalmente executor de
			instruções recebidas. NÃO 'analysis' (REW analisa risco;
			BKR não avalia); NÃO 'specification' (FCE especifica
			liquidação; BKR consome especificação); NÃO 'engagement'
			(NPM domain); NÃO 'draft' (não há autoria de proposta —
			BKR recebe instruções finalizadas).

			Anti-decision (boundary explícita): BKR é deliberadamente
			sem autoridade de decisão econômica. Decisões técnicas
			(rail selection, retry strategy, timeout handling)
			permitidas no escopo gateway/execution; decisões
			econômicas (autorizar pagamento, definir valor, alterar
			destinatário) fora do escopo — pertencem a FCE/TCM
			upstream.
			"""
	}

	// =============================================
	// CAPABILITIES — placeholder; conteúdo em commit 1.2
	// =============================================

	capabilities: {
		operational: [{
			description: "Placeholder — capabilities operacionais entram em commit 1.2."
			rationale:   "Skeleton commit 1.1 estabelece shape; conteúdo substantivo (provavelmente cobrindo: rail dispatch + protocol translation + settlement confirmation reconciliation + retry/timeout handling determinístico) entra em commit 1.2."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// =============================================
	// COMMUNICATION — placeholder; conteúdo em commit 1.4
	// =============================================

	communication: {
		rationale: "Placeholder — communication completa entra em commit 1.4. Esperado: inbound (PaymentInstruction de FCE — sync command); sinais operacionais de disponibilidade/estado de liquidação vindos de TCM ou providers, sem autoridade econômica de timing; outbound (SettlementCompleted/SettlementFailed/SettlementPending events consumidos por FCE/TCM/ATO); query-deps (AccountStatus externo via providers; estado operacional de TCM); commands (DispatchPayment sync); query-surfaces (QuerySettlementStatus). Ordering aprovado seguirá padrão DLV: businessDecisions (1.3) ANTES de communication (1.4)."
	}

	// =============================================
	// STAKEHOLDERS — placeholder; conteúdo em commit 1.3
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Placeholder — completado em commit 1.3."
		impactDescription: "Placeholder — completado em commit 1.3."
		rationale:         "Skeleton stakeholder; stakeholders substantivos (provavelmente: sh-01 originadora consumindo settlement outcome para fluxo; sh-02 fornecedor recebendo crédito final; sh-04 instituição financeira parceira como provider de rails; sh-05 operador agente BKR) em commit 1.3."
	}]

	// =============================================
	// INCENTIVE ANALYSIS — placeholder; conteúdo em commit 1.5
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Placeholder — preenchido em commit 1.5."
			desiredBehavior:           "Placeholder."
			correctOperationIncentive: "Placeholder."
			manipulationVector:        "Placeholder."
			manipulationCost:          "Placeholder."
			vsBenefit:                 "Placeholder."
			designResponse:            "Placeholder."
			rationale:                 "Skeleton; vetores adversariais substantivos (esperados: rail provider downtime/SLA breach; replay de settlement; misrouting between rails; provider opacity para verificação de confirmação) em commit 1.5."
		}]
		rationale: "Placeholder — incentive analysis completo entra em commit 1.5. BKR commodity reduz vetores estratégicos (provider substituível) mas eleva vetores operacionais (rail SLA, double-settlement, misrouting)."
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 1.5
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/bkr/agents/bkr-primary-agent.cue"
		governanceScope: {}
		rationale:       "Skeleton commit 1.1 estabelece domainAgentSpec canônico (forward reference — agent-spec será autorado em Phase 4 do bootstrap WI-062). governanceScope completo (esperado: autonomousDecisions cobrindo rail selection + retry strategy + timeout escalation; supervisedDecisions cobrindo manual reconciliation + provider override; escalationCriteria cobrindo Bacen regulatory breach + cross-rail orphan + economic value mismatch detected post-dispatch) entra em commit 1.5."
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 1.6
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + businessDecisions + anti-decision economic authority + commodity Wardley justification + cross-BC integration cascade FCE→BKR→external + lenses ativadas) entra em commit 1.6."
}
