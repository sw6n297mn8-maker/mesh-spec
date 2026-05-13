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
	// CAPABILITIES — 7 capabilities (Phase 1.2)
	// =============================================
	// Anti-drift clause transversal (per founder Phase 1.2):
	//   FCE owns economic eligibility convergence, not upstream truth
	//   production nor downstream settlement execution.
	//
	// Identity refinement transversal (per founder Phase 1.2):
	//   Compliance é mecanismo; crystallization de autoridade econômica
	//   executável é identidade. FCE é o único BC autorizado a
	//   transformar convergência operacional em autoridade econômica
	//   executável.

	capabilities: {
		operational: [{
			description: """
				Lifecycle econômico canonical de payment obligation no
				BC FCE. State machine: proposed → guarded → authorized
				→ dispatched → settled OR failed OR reversed.
				Transições determinísticas governadas por gates
				(PrePaymentGuardService aprova → guarded → authorized),
				authorization emission (AuthorizationProofService
				crystalliza → dispatched), e outcome consumption
				(cap-payment-outcome-routing routes BKR canonical
				outcomes → settled/failed). Reverse pathway é
				exceptional: requires NEW AuthorizationProof + upstream
				mandate (DRC/policy); reverse não nasce autonomamente
				em FCE. Distinguishable semanticamente do BKR
				SettlementAttempt state machine (T1-T8) — FCE state
				machine modela payment obligation lifecycle
				(compromisso → autorização → settlement outcome
				reconhecido); BKR T1-T8 modela technical dispatch
				lifecycle (instrução recebida → executada →
				reconciled). 1 PaymentObligation FCE pode gerar N
				SettlementAttempts BKR via retry per BKR
				inv-attempt-identity-per-retry.
				"""
			capabilityRef: "cc-03"
			rationale: """
				Lifecycle canonical materializa identidade FCE:
				economic state machine cross-BC anchor. Estados são
				economic semantic (proposed = obligation reconhecida +
				guarded = condições convergeram + authorized =
				AuthorizationProof emitida + dispatched = BKR consumiu
				+ settled/failed = BKR outcome canonicalizado consumido
				+ reversed = exceptional pathway pós-mandate). Cada
				transição é gated por capability específica:
				cap-prepayment-guard-service controla guarded →
				authorized; cap-authorization-proof-emission
				materializa authorized → dispatched;
				cap-payment-outcome-routing materializa dispatched →
				settled/failed. FCE owns economic eligibility
				convergence, not upstream truth production nor
				downstream settlement execution. Reverse-settlement
				folded como exceptional pathway (não capability
				identitária standalone) per founder Phase 1.2: reverse
				não é raison d'être do FCE; é exceção upstream-
				mandated.
				"""
		}, {
			description: """
				Gate determinístico multi-fonte enforçando 11
				invariantes financeiros antes de FCE emitir
				AuthorizationProof. Inputs ponderados:
				vo-commitment-state (CMT — must be in 'accepted' OR
				'in-progress'), vo-budget-reservation (BDG — must have
				sufficient reserved budget), vo-risk-eligibility (REW
				— must be currently eligible AND not aged out),
				vo-invoice (INV — must be issued AND validated AND not
				cancelled), vo-evidence-bundle (DLV — must satisfy
				retention release conditions when applicable),
				vo-cash-operational-availability (TCM — advisory input;
				informs timing not authorization). Output binary:
				authorize-payment OR reject-with-classification. NÃO
				inclui evidence verification logic (DLV territory);
				NÃO inclui risk scoring (REW); apenas enforça
				aggregation invariants determinísticos.
				"""
			capabilityRef: "cc-01"
			rationale: """
				PrePaymentGuard é o single gate através do qual
				economic authority FCE materializa. 11 invariantes
				incluem (preliminar Phase 3 domain-model):
				inv-payment-requires-accepted-commitment +
				inv-budget-reservation-required +
				inv-risk-eligibility-current + inv-invoice-validated +
				inv-evidence-complete-for-release +
				inv-no-duplicate-authorization-under-instructionId +
				inv-authorization-proof-cryptographic-validity +
				inv-financialization-atomic +
				inv-reverse-payment-requires-upstream-mandate +
				inv-tcm-advisory-only +
				inv-anti-economic-decision-bypass. Cada invariant é
				deterministic guard; classification de failure routing
				para REW (eligibility) OR BDG (budget) OR DLV
				(evidence) OR upstream (policy) — never opaque
				rejection. Compliance é mecanismo; crystallization de
				autoridade econômica executável via emission
				downstream é identidade.
				"""
		}, {
			description: """
				All-or-nothing atomic crystallization que converte
				estado operacional elegível em obrigação financeira
				irrevogavelmente observável. Financialization is the
				canonical transition from operational truth to
				network-visible financial truth. Garante que partial
				commits NÃO geram partial financial obligations
				(vector adversarial #1 do FCE). Materializa o ponto
				onde commitment econômico FCE-consumed + evidence
				operacional verificado + risk eligibility válido +
				budget reservado convergem em PaymentObligation
				observável pela rede inteira (downstream SCF para
				antecipação + secondary financing, REW para risk
				model, ATO para accounting, INS para insurance
				coverage). NÃO inclui invoice generation (INV); NÃO
				inclui working capital product structuring (SCF); NÃO
				inclui contract terms management (CTR).
				"""
			capabilityRef: "cc-03"
			rationale: """
				Capability economicamente mais importante do FCE —
				heart of the Mesh loop. Sem financialization
				observável, downstream BCs operam sobre estado
				inconsistente: SCF antecipa obrigação que pode não
				existir; REW modela risco sem visibility into actual
				obligation; ATO contabiliza sem fato consolidado; INS
				underwrite sem fato substrato verificável.
				All-or-nothing atomicity é vector adversarial crítico
				— partial financialization criaria 'shadow
				obligations' que vazam dependency consistency. A
				palavra crítica é OBSERVÁVEL: obrigação não é apenas
				criada, é fato confiável da rede. Per founder Phase
				1.2: 'Financialization is the canonical transition
				from operational truth to network-visible financial
				truth' — heart of the Mesh value proposition. FCE owns
				economic eligibility convergence + observability
				anchor; upstream BCs own truth production; downstream
				BCs consume observable fact.
				"""
		}, {
			description: """
				Cryptographic crystallization da economic authority
				FCE per PaymentInstruction. Composição
				AuthorizationProof (per BKR Phase 2 glossary
				term-authorization-proof + Phase 3
				vo-authorization-proof): (a) cryptographic signature
				sobre canonical encoding de (instructionId + payer +
				payee + value); (b) nonce single-use replay
				protection; (c) issued-at timestamp; (d) validity
				window upstream-declared (FCE owns; NOT derived from
				BKR state); (e) claim chain link to FCE agent
				identity authorizing. Output consumed by BKR via
				cmd-dispatch-payment-instruction; AuthorizationProof
				validity is consumed never interpreted nor redefined
				por BKR per BKR
				inv-authorization-proof-verification-gate. Reverse
				pathway: NEW AuthorizationProof for NEW economic
				obligation (mandato upstream DRC/policy required);
				original NEVER reusable for reverse intent.
				"""
			capabilityRef: "cc-03"
			rationale: """
				Materializa economic authority crystallization em
				cryptographic boundary contra forgery/replay/expiry
				attacks per BKR Phase 5 documented. FCE é único locus
				que pode gerar valid AuthorizationProof — possessing
				FCE agent identity + valid nonce-issuing capability é
				sufficient condition (e prova) de economic decision.
				Compliance é mecanismo; crystallization de autoridade
				econômica executável é identidade — esta capability é
				onde a identidade materializa cryptographically.
				Original AuthorizationProof NEVER reusable for
				reverse economic intent (per BKR
				inv-reverse-settlement-upstream-authorized-only);
				reverse-payment requires NEW proof for NEW obligation.
				Validity window upstream-declared garante que FCE
				governs expiry semantics; BKR consome literal
				validity, nunca estende. FCE owns economic authority
				emission; not upstream truth production nor
				downstream technical execution.
				"""
		}, {
			description: """
				Ponderação determinística de 6 upstream reads em
				single decision: authorize OR reject OR escalate.
				Reads: CMT commitment state + BDG budget reservation
				+ REW risk eligibility + INV invoice + DLV evidence +
				TCM operational advisory. FCE evaluates eligibility,
				never rewrites upstream truth. Upstream BCs own fact
				production; FCE owns payment eligibility convergence.
				NÃO inclui upstream decision authority (cada BC owns
				sua decision); NÃO inclui condition policy definition
				(declared upstream em ADRs/business decisions); NÃO
				inclui retry of upstream reads (failure paths são
				FCE-internal classification para escalation routing).
				"""
			capabilityRef: "cc-03"
			rationale: """
				FCE é 'downstream dominant do grafo' per subdomain —
				concentra dependências de leitura cross-BC.
				Capability captura aggregation pattern formalmente: 6
				upstream reads ponderados deterministicamente produzem
				authorization-eligibility verdict. Asymmetria de
				autoridade é estrutural: FCE consome facts (não
				reescreve), evaluates convergence (não overrides),
				produces eligibility verdict (não policy). Vector
				adversarial protegido: FCE poderia tentar corrigir
				risco silenciosamente OR reinterpretar evidence OR
				ajustar budget semanticamente — todos forbidden por
				construção. Cada upstream BC owns sua truth; FCE
				convergence é função pura desses inputs. Elimina
				classe inteira de drift arquitetural futuro: FCE
				corrigindo risco / reinterpretando evidence /
				ajustando budget. Per founder Phase 1.2: 'FCE
				evaluates eligibility, never rewrites upstream truth.
				Upstream BCs own fact production; FCE owns payment
				eligibility convergence.'
				"""
		}, {
			description: """
				Consumo de canonical outcomes published por BKR
				(SettlementFinalized / SettlementFailed /
				SettlementIndeterminate / FailureClassified /
				InstructionRejected) → trigger downstream FCE state
				transitions (lifecycle update + retention release
				decision + reversal pathway evaluation + downstream
				PaymentSettled emission para REW/ATO/TCM/SCF). BKR
				owns reconciliation truth; FCE owns economic lifecycle
				reaction. NÃO inclui BKR reconciliation (BKR
				svc-reconciliation consome rail signals; FCE consome
				BKR canonical outcome — distinct boundary); NÃO inclui
				rail signal interpretation; NÃO inclui rail outcome
				arbitration. Indeterminate consumption preserves FCE
				epistemic state (non-final; aguarda BKR resolution
				via cmd-resolve-indeterminate-state).
				"""
			capabilityRef: "cc-03"
			rationale: """
				Boundary preservation explícita BKR↔FCE — BKR
				canonicalizes settlement state per Phase 5
				evt-settlement-finalized/failed/indeterminate; FCE
				reacts economicamente. Semantically clear separation:
				BKR é settlement execution authority; FCE é economic
				lifecycle authority. Distinct concerns: BKR resolve
				'did money move at rail layer?' (technical question);
				FCE resolve 'what does this mean for the payment
				obligation lifecycle?' (economic question). Per
				founder Phase 1.2 boundary direction: BKR = execução
				técnica de settlement e reconciliação operacional do
				dispatch; FCE = autoridade econômica + governance +
				lifecycle. Esta capability preserva separation
				operationally — single-source-of-truth para outcome
				é BKR; FCE never re-arbitrates.
				"""
		}, {
			description: """
				Liberação de retentions vinculada a evidence
				completude (DLV) + financialization completion +
				cross-condition convergence. Materializa anti-fraud
				guard: money releases ONLY post operational
				verification convergence. Inputs:
				evidence-bundle-status (DLV — completeness verified)
				+ financialization-state (FCE internal — atomic
				completion) + budget-retention (BDG — retention amount
				declared) + commitment-state (CMT — commitment
				progressed). Output: trigger PaymentRelease event
				consumed downstream para next-tranche disbursement OR
				full release. NÃO inclui evidence completeness
				determination (DLV); NÃO inclui retention amount
				calculation upstream (BDG/CTR); NÃO inclui escrow
				custody (financial infra externa).
				"""
			capabilityRef: "cc-01"
			rationale: """
				Capability operacional core do moat Mesh: 'dinheiro
				condicionado a verdade operacional verificável.'
				Retention release é onde Mesh value proposition
				materializa concretamente — sem evidence completude
				verifiable, dinheiro não move. Distingue Mesh de
				mecanismos de pagamento commodity (escrow simples
				libera por timer; banco libera por instrução manual).
				Anti-fraud por construção: retention release exige
				convergence multi-fonte determinístico — não há
				single signature que libera; há aggregation de
				operational truth + financial truth + commitment
				truth. Per founder Phase 1.2: cc-01 (liberação
				vinculada a evidência) alinhado ao moat Mesh —
				dinheiro condicionado a verdade operacional
				verificável. FCE owns economic eligibility convergence
				(when conditions met → release authorized); upstream
				BCs (DLV evidence + BDG retention amount + CMT
				commitment state) own truth production.
				"""
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
