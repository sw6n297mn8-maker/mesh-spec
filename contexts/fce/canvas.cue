package fce

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Financial Commitment Execution.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// FCE é o orquestrador canônico de execução financeira de
// compromissos econômicos — gates condicionais antes do dispatch
// + payment state machine + dispatch técnico delegado a BKR.
// Concentra dependências de leitura cross-BC (BDG budget + REW
// risk + INV invoice + DLV evidence + TCM operational availability)
// para single decision: autorizar PaymentInstruction com
// AuthorizationProof verificável.
//
// Core differentiator: vinculação causal operação→pagamento via
// 11 invariantes protegidos + 3 services (FinancializationService
// all-or-nothing + PrePaymentGuardService + Payment state machine).
// "Subdomínio mais protegido do Wave 0 porque qualquer bug
// financeiro tem impacto monetário direto" — FCE exerce economic
// authority em nome da Mesh; nunca delega rail/provider.
//
// Frase canônica do papel: FCE decide se, quando e sob quais
// condições o dinheiro pode se mover; BKR executa fisicamente.
//
// TCM separação semântica: TCM informa disponibilidade operacional
// de liquidez; não autoriza pagamento.
//
// Authoring manual section-by-section per manualAuthoringProtocol
// (adr-057). Materializado em 7 commits incrementais:
//   1.1 — skeleton: identity + classification + roles + ownership
//         (este commit)
//   1.2 — capabilities
//   1.3 — businessDecisions + stakeholders + costsEliminated
//         (core subdomain — costsEliminated aplicável per tq-cv-10)
//   1.4 — communication (inbound de CMT/BDG/REW/INV/DLV/TCM;
//         outbound PaymentInstruction para BKR + outcome events;
//         query-deps; commands; query-surfaces)
//   1.5 — incentiveAnalysis + governanceScope
//   1.6 — assumptions + openQuestions + verificationMetrics +
//         outer rationale
//   1.7 — SRR srr-fce-canvas
//
// Cada commit deixa o canvas em shape válido (cue vet ./...) com
// conteúdo placeholder explícito nas seções pendentes — substituído
// por conteúdo substantivo no commit subsequente.
//
// Cross-BC alignment com BKR (Phase 5 closed em 0e9d99c): FCE é
// upstream emitter de PaymentInstruction + AuthorizationProof
// que BKR consome via cmd-dispatch-payment-instruction. Boundary
// documentado por BKR Phase 2 glossary preservada aqui:
// PaymentInstruction is not Payment (Payment é FCE concept;
// PaymentInstruction é technical instruction); AuthorizationProof
// é FCE-originated cryptographic boundary (consumed by BKR, never
// interpreted nor redefined); ReverseSettlement intent é FCE/DRC-
// owned (BKR não originates).

canvas: artifact_schemas.#Canvas & {
	code: "fce"
	name: "Financial Commitment Execution"

	purpose: """
		Orquestrar execução financeira de compromissos econômicos
		cross-BC — budget allocation + payment lifecycle +
		conditional release de retenções + settlement dispatch via
		BKR. FCE decide se, quando e sob quais condições o dinheiro
		pode se mover; BKR executa fisicamente. Concentra
		dependências de leitura cross-BC (BDG budget + REW risk +
		INV invoice + DLV evidence + TCM operational availability)
		e materializa decisão única canônica: autorizar
		PaymentInstruction com AuthorizationProof verificável para
		dispatch a BKR.

		Core differentiator: vinculação causal operação→pagamento
		via 11 invariantes protegidos. FCE não delega economic
		authority a rail nem a provider; ele a EXERCE em nome da
		Mesh. Diferenciação competitiva canônica reside aqui — sem
		FCE, dinheiro se move por instrução manual desacoplada da
		operação (o problema que a tese existe para resolver). 3
		services protegem a fronteira: FinancializationService (all-
		or-nothing financialization), PrePaymentGuardService (11
		invariantes enforcement pré-dispatch), Payment state machine
		(lifecycle canonical de cada pagamento).

		Boundary semantic clarification — TCM informa disponibilidade
		operacional de liquidez; não autoriza pagamento. BKR executa
		fisicamente; não decide economic merit. FCE é único locus
		de economic decision authority na cadeia.

		Identidade canônica FCE: orchestrator authority for economic
		payment intent, gated by deterministic guards over operational
		evidence and risk eligibility upstream-resolved.
		"""

	ubiquitousLanguageRef: "contexts/fce/glossary.cue"

	classification: {
		subdomainType:    "core"
		businessRole:     "compliance-enforcer"
		wardleyEvolution: "custom"
		rationale: """
			Core porque a lógica de vinculação causal
			operação→pagamento é proprietária e indissociável da
			tese Mesh. "Eliminar a separação entre operação e
			liquidação financeira. Cada pagamento é rastreável até
			o compromisso e o evento que o originou" é diferenciação
			competitiva canônica — não pode ser comprada de
			provider, não pode ser substituída por commodity rail.

			Compliance-enforcer porque a identidade arquitetural do
			FCE é gate financeiro governado: PrePaymentGuardService
			enforça 11 invariantes pré-dispatch + FinancializationService
			impõe all-or-nothing causal correctness. Revenue é
			consequência operacional de FCE funcionar, não atributo
			classification — sem enforcement não há revenue legítima.
			Distinção vs alternativas: revenue-generator seria CMT
			(commitment originates monetary flow) ou SCF (working
			capital products generate fees); engagement-creator é
			NGR/NPM (rede + participantes); operational-enabler é
			BKR (rails commoditizados habilitam liquidação física).
			FCE preside o gate; enforcement é seu papel.

			Custom (Wardley) reflete maturidade da lógica de
			liquidação condicional vinculada a operação: ainda em
			construção pela Mesh; não há padrão de mercado para
			vinculação causal operação→pagamento integrada por
			invariants formais. Não é product (não há solução de
			liquidação condicional vendida no mercado); não é
			commodity (lógica proprietária da tese); não é genesis
			(problema reconhecido mas solução em evolução).
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Payment lifecycle (propose → guard → dispatch → settle)
			é uniforme cross-vertical. Condições vertical-specific
			(qual evidence libera retenção; qual budget aprova
			payment; qual contract term governa eligibility) entram
			via inputs upstream — DLV evidence (vertical-aware),
			INV invoice (vertical-aware), CMT commitment terms
			(vertical-aware), REW risk eligibility (vertical-aware)
			— consumidas por FCE genericamente como conditions input.
			FCE engine permanece estável enquanto verticais expandem;
			expansão vertical adiciona contracts/evidence/policies
			upstream sem alterar payment state machine ou 11
			invariantes core.

			Estrutura preservada: payment authorization logic é
			vertical-agnostic; condition evaluation é
			vertical-parameterized via upstream inputs. Permite
			multi-vertical scaling sem branching FCE core.
			"""
	}

	domainRoles: {
		primary: "execution"
		secondary: ["gateway", "analysis"]
		rationale: """
			Execution como primário: FCE orquestra payment lifecycle
			canonical end-to-end — receive operation evidence + risk
			eligibility + budget + invoice → evaluate guard
			conditions → authorize PaymentInstruction → dispatch a
			BKR → consume settlement outcome → liberate retentions
			ou registrar falha. Frase canônica: FCE decide se, quando
			e sob quais condições o dinheiro pode se mover; BKR
			executa fisicamente.

			Gateway como secundário (primeira camada): FCE é boundary
			topológico entre operação cross-BC (CMT compromissos +
			DLV evidence + INV faturas + REW risk + BDG budget +
			TCM availability) e execução técnica de rails (BKR).
			Materializa boundary via PrePaymentGuardService — único
			gate cross-BC que autoriza payment intent.

			Analysis como secundário (segunda camada): FCE não
			executa cegamente — avalia guard conditions multi-fonte
			antes de emitir PaymentInstruction. Condition evaluation
			(11 invariantes × evidence completude × risk eligibility
			× budget reservation × invoice validity × TCM advisory)
			é processo analítico determinístico distinto de execution
			mechanics. Capturar 'analysis' explicitamente preserva
			a precisão: FCE pondera antes de executar.

			Anti-decision boundary explícita: FCE exerce economic
			authority (autorizar payment) mas NÃO técnica (rail
			selection logic, retry strategy, timeout handling são
			BKR territory). FCE NÃO especifica protocolo rail nem
			interpreta rail signals — apenas emite intent
			cryptographically attested. NÃO 'specification' (BKR
			specifica technical execution); NÃO 'engagement' (NGR/NPM
			domain); NÃO 'draft' (CMT origina proposta; FCE consome
			compromisso formalizado).
			"""
	}

	// =============================================
	// CAPABILITIES — placeholder; conteúdo em commit 1.2
	// =============================================

	capabilities: {
		operational: [{
			description: "Placeholder — capabilities operacionais entram em commit 1.2."
			rationale:   "Skeleton commit 1.1 estabelece shape; conteúdo substantivo (provavelmente cobrindo: payment lifecycle state machine determinística + PrePaymentGuardService 11-invariant enforcement + FinancializationService all-or-nothing + AuthorizationProof emission cryptographic + cross-BC condition evaluation + outcome reconciliation + retention release condicional) entra em commit 1.2."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// =============================================
	// COMMUNICATION — placeholder; conteúdo em commit 1.4
	// =============================================

	communication: {
		rationale: "Placeholder — communication completa entra em commit 1.4. Esperado: inbound (CommitmentAccepted/CommitmentStateChanged de CMT; BudgetApproved/BudgetReserved de BDG; CounterpartyRiskAlertRaised + EligibilityDecision de REW; InvoiceIssued/InvoiceCancelled de INV; DeliveryVerified + EvidenceCommitted de DLV; CashOperationalStatusUpdated de TCM como advisory; SettlementFinalized/SettlementFailed/SettlementIndeterminate/FailureClassified/InstructionRejected de BKR como outcome); outbound (PaymentInstruction + AuthorizationProof para BKR via cmd-dispatch-payment-instruction; PaymentSettled/PaymentObligationDefaulted/PaymentReleased para REW/ATO/TCM/SCF; ReversePaymentInstruction para BKR sob authorization upstream de DRC); query-deps (CommitmentState; ContractTerms; AccountAvailability TCM); commands (DispatchPayment inbound de policy/agent; RequestRetentionRelease; AuthorizeReversePayment sob DRC mandate); query-surfaces (QueryPaymentStatus; QueryAuthorizationProof scoped per caller). Cross-BC dependencies amplas refletem FCE como downstream dominant do grafo."
	}

	// =============================================
	// STAKEHOLDERS — placeholder; conteúdo em commit 1.3
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Placeholder — completado em commit 1.3."
		impactDescription: "Placeholder — completado em commit 1.3."
		rationale:         "Skeleton stakeholder; stakeholders substantivos (provavelmente: sh-01 originadora autorizando dispatch de pagamento; sh-02 fornecedor beneficiário recebendo credito post-settlement; sh-04 Bacen como regulatory boundary constraint authority; sh-05 operador agente FCE; sh-06 compliance officer side-channel routing authority) em commit 1.3."
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
			rationale:                 "Skeleton; vetores adversariais substantivos (esperados: ghost-payment authorization without evidence; retention release sem complete operational verification; budget bypass via partial release patterns; risk override silently after eligibility decision aged out; rail substitution post-authorization for cost arbitrage; double dispatch under race condition; reverse settlement initiated by FCE without DRC mandate; FinancializationService all-or-nothing bypass via partial commits) em commit 1.5."
		}]
		rationale: "Placeholder — incentive analysis completo entra em commit 1.5. FCE core + compliance-enforcer eleva vetores estratégicos (manipulação de gate authorization é vector adversarial #1) sobre operacionais (race conditions secundárias)."
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 1.5
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/fce/agents/fce-primary-agent.cue"
		governanceScope: {}
		rationale:       "Skeleton commit 1.1 estabelece domainAgentSpec canônico (forward reference — agent-spec será autorado em Phase 4 do bootstrap WI-043). governanceScope completo (esperado: autonomousDecisions cobrindo guard evaluation determinística + AuthorizationProof generation + retention release condicional automática; supervisedDecisions cobrindo budget override + risk eligibility waiver + reverse-payment authorization (sempre DRC-mandated) + financialization rollback; escalationCriteria cobrindo guard failure pattern + cross-BC evidence inconsistency + budget mismatch + risk eligibility expired + double-authorization attempt + reverse-settlement-without-mandate detection + financialization atomicity violation + cross-rail substitution attempt + PrePaymentGuardService bypass detection) entra em commit 1.5."
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 1.6
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + businessDecisions + economic authority enforcement + cross-BC integration cascade upstream→FCE→BKR + 11 invariantes formal protection + 3 services architectural roles + lenses ativadas + alignment com BKR Phase 2 glossary boundary terms) entra em commit 1.6."
}
