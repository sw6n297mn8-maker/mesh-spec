package fce

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Financial Commitment Execution.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// FCE é a máquina canônica de cristalização de autoridade econômica
// executável condicionada — converge upstream operational truth +
// risk eligibility + budget + invoice + evidence em authorization
// crystallization cryptograficamente vinculada que BKR consome para
// dispatch técnico. Não é payment engine, não é treasury orchestrator,
// não é ERP financeiro — é boundary canônico onde verdade operacional
// torna-se verdade financeira observável pela rede.
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
		Cristalizar autoridade econômica executável condicionada a
		convergência determinística de verdade operacional e
		financeira. FCE é a máquina canônica que transforma
		operational truth (CMT commitment state + BDG budget
		reservation + REW risk eligibility + INV invoice + DLV
		evidence + TCM operational advisory) em network-visible
		financial truth via AuthorizationProof cryptograficamente
		vinculada que BKR consome para dispatch técnico. NÃO é
		payment engine; NÃO é treasury orchestrator; NÃO é ERP
		financeiro — é boundary canônico onde operational truth
		converge em authorization crystallization.

		FCE decide se, quando e sob quais condições o dinheiro pode
		se mover; BKR executa fisicamente. Concentra dependências
		de leitura cross-BC em single function: deterministic
		convergence evaluation produzindo authorization-eligibility
		verdict. FCE evaluates eligibility, never rewrites upstream
		truth — upstream BCs own fact production; FCE owns
		authorization convergence; BKR owns settlement execution.

		Core differentiator: vinculação causal operação→pagamento
		via 11 invariantes protegidos. FCE não delega economic
		authority a rail nem a provider; ele a CRISTALIZA em nome
		da Mesh. Diferenciação competitiva canônica reside aqui —
		sem FCE, dinheiro se move por instrução manual desacoplada
		da operação (o problema que a tese existe para resolver).
		3 services protegem a fronteira: FinancializationService
		(all-or-nothing atomic crystallization — operational truth
		→ network-visible financial truth), PrePaymentGuardService
		(11 invariantes enforcement pré-authorization),
		AuthorizationProofService (cryptographic crystallization da
		economic authority per PaymentInstruction).

		Boundary semantic clarification — TCM informa disponibilidade
		operacional de liquidez; não autoriza pagamento. BKR executa
		fisicamente; não decide economic merit. FCE é único locus
		de economic authority crystallization na cadeia.

		Identidade canônica FCE: canonical crystallization boundary
		for executable economic authority, conditioned on
		deterministic convergence of operational and financial truth.
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
	// BUSINESS DECISIONS — 7 bd-* (Phase 1.3)
	// =============================================

	businessDecisions: [{
		id: "bd-financialization-is-atomic"
		consequences: "Downstream BCs (SCF, REW, ATO, INS) podem consumir PaymentObligation como fact observável da rede após financialization. Shadow obligations + partial commits + duplicated financing windows são forbidden por construção. Implementation cost: aggregate handler transactional + atomic state machine transitions; rejeição de convergence parcial = false negative ao invés de partial commit."
		decision: """
			Financialization é o instante ontológico onde dinheiro
			passa a existir economicamente na rede Mesh. Operational
			convergence (commitment accepted + evidence verified +
			risk eligible + budget reserved + invoice validated) only
			becomes financial truth atomically. Partial commits NEVER
			produce partial financial obligations.

			Esta decisão elimina classes inteiras de patologia
			downstream: partial payable state; ambiguous obligation;
			asynchronous debt emergence; duplicated financing windows;
			settlement races; receivable phantom states. Sem
			atomicidade, SCF antecipa obrigação que pode não existir;
			REW modela risco sem visibility into actual obligation;
			ATO contabiliza sem fato consolidado; INS underwrite sem
			substrato verificável.

			Atomicity é structural property: convergence →
			crystallization é all-or-nothing transactional;
			observability post-crystallization é network-wide
			consistent. Vector adversarial protegido: shadow
			obligations leaking via partial commits são forbidden
			por construção, não por convenção.
			"""
		rationale: """
			Decisão ontológica mais profunda do FCE — define o
			instante em que money begins to exist economically on
			the network. Mais importante que routing, mais importante
			que retention, mais importante até que PrePaymentGuard
			porque governs the ontological transition operational
			truth → network-visible financial truth. Heart of the
			Mesh value proposition: a network reliably consumes
			financial obligations as facts only because
			financialization é atomic + observable. Materializado
			em cap-financialization-service. Enforcement: domain
			(aggregate handler + state machine transactional) + FCE
			agent (validates convergence completeness via
			cap-prepayment-guard-service antes de invoke
			financialization).
			"""
	}, {
		id: "bd-authorization-is-convergence-not-decision"
		consequences: "FCE NEVER expands its authority scope autonomously; never absorbs risk/budget/evidence interpretation. Eliminação estrutural de classe de drift: 'FCE corrigindo risco / reinterpretando evidence / ajustando budget'. Trade-off: condições de borda (ambiguous upstream state) escalate ao invés de FCE-internal resolution — supervised intervention preferido a silent override."
		decision: """
			FCE authorization emerges from deterministic convergence
			of upstream facts; FCE never makes independent economic
			decision. Authorization é função pura de 6 upstream reads
			(CMT commitment state + BDG budget reservation + REW risk
			eligibility + INV invoice + DLV evidence + TCM operational
			advisory). FCE evaluates whether conditions converge;
			upstream BCs decide their own facts.

			FCE owns authorization convergence, never truth production
			nor settlement execution. Distinção crítica vs decision-
			making: decision implies discretion over multiple valid
			options; convergence is deterministic aggregation of
			upstream facts producing single eligibility verdict. Drift
			protection: FCE que decide tende a virar super-orchestrator
			que absorve upstream concerns (corrigindo risco,
			reinterpretando evidence, ajustando budget). FCE que
			converge permanece bounded à authorization function.
			"""
		rationale: """
			Identity decision crítica anti-drift — separa FCE de ERP
			financeiro genérico que absorve all financial concerns.
			Compliance é mecanismo; crystallization de autoridade
			econômica executável via convergence é identidade. FCE
			authority é authority of deterministic recognition (esses
			fatos convergiram em elegibilidade), não authority of
			discretionary judgment (eu decido que essa transação
			merece autorização). Materializado em
			cap-cross-bc-condition-evaluation +
			cap-prepayment-guard-service. Enforcement: domain
			(aggregate immutability over upstream-derived fields) +
			runner (cross-BC ref integrity validation) + agent (NEVER
			mutates upstream VO contents during evaluation).
			"""
	}, {
		id: "bd-upstream-truth-immutable-from-fce"
		consequences: "Upstream truth drift detected forced para escalation channel ao invés de FCE local reinterpretation. Cache snapshots de upstream VOs são read-only — FCE pode referenciar mas nunca mutate semantics. Trade-off: aumenta dependency em upstream freshness; FCE não 'corrige' upstream temporal staleness silently — escalates se snapshot age > policy threshold."
		decision: """
			Upstream BCs own fact production absolutely; FCE never
			rewrites nor reinterprets upstream truth. FCE may cache,
			snapshot, or reference upstream truth for authorization
			evaluation, but never reinterpret upstream semantic
			meaning. Risk eligibility semantics belong to REW;
			evidence completeness semantics belong to DLV; budget
			semantics belong to BDG; invoice validity semantics
			belong to INV; commitment state semantics belong to CMT;
			operational liquidity semantics belong to TCM.

			Anti-drift clause transversal: FCE owns authorization
			convergence, never truth production nor settlement
			execution. Esta cláusula previne 4 vectors específicos
			de deriva: (a) risk eligibility meaning drift — FCE
			reinterpretando o que "elegível" significa; (b) evidence
			reinterpretation — FCE filtrando ou ajustando evidence
			completude; (c) budget semantics translation — FCE
			convertendo budget reservation em authorization gate
			customizado; (d) commitment state override — FCE
			progredindo commitment lifecycle independentemente de CMT.
			"""
		rationale: """
			Boundary integrity decision per founder Phase 1.2/1.3 +
			BKR Phase 5 anti-economic-autonomy proof equivalent. Sem
			esta decisão explícita, FCE silenciosamente absorveria
			upstream concerns ao longo de Phase 1+ via 'jeitinho
			operacional', 'override pontual', 'cache local com
			interpretation tweak'. Cláusula cache/snapshot/reference
			(per founder ajuste 4 Phase 1.3) explicita que FCE PODE
			ler + manter snapshots para evaluation, but never alter
			semantics. Materializado em cap-cross-bc-condition-
			evaluation. Enforcement: domain (aggregate fields para
			upstream VOs são immutable post-creation) + runner (no
			mutation operations on upstream-derived state) + agent
			(read-only operations sobre cached upstream snapshots).
			"""
	}, {
		id: "bd-authorization-proof-cryptographic-binding"
		consequences: "AuthorizationProof emission é cryptographically attestable + single-use enforced. Replay attacks bloqueados via nonce single-use; forgery bloqueado via signature validation; reverse-payment requires NEW proof (não derivation). Implementation cost: nonce-consumed registry + key rotation procedures + claim chain validation infrastructure. BKR consumes proof per Phase 5 boundary; never interprets validity."
		decision: """
			AuthorizationProof é single-use cryptographic binding per
			PaymentInstruction emitted by FCE. Composição minimum
			canonical: (a) cryptographic signature sobre canonical
			encoding de (instructionId + payer + payee + value); (b)
			nonce single-use replay protection; (c) issued-at
			timestamp; (d) validity window upstream-declared; (e)
			claim chain link to FCE agent identity authorizing.

			Original AuthorizationProof is NEVER reusable for reverse
			economic intent — reverse-payment requires NEW
			AuthorizationProof for NEW economic obligation under
			upstream mandate. Validity window é upstream-declared
			(FCE owns; never derived from BKR state nor extended by
			any downstream consumer). FCE é único locus que pode
			gerar valid AuthorizationProof — possessing FCE agent
			identity + valid nonce-issuing capability é sufficient
			condition (e prova) de economic decision authority.
			"""
		rationale: """
			Cryptographic crystallization da economic authority FCE
			contra forgery/replay/expiry attacks per BKR Phase 5
			boundary documented. Materializa identidade FCE
			cryptographically — possessing valid AuthorizationProof
			emit capability ≡ holding FCE economic authority. Sem
			single-use binding, replay attack reusable de proof
			válida ainda no validity window permitiria double
			authorization. Sem reverse-reusability prohibition,
			adversário poderia derivar reversal authority de forward
			authorization (drift catastrófico de boundary). Forward
			compatibility: novas cryptographic primitives (post-
			quantum, threshold signatures) podem ser adicionadas
			como composite extensions; minimum canonical composition
			é forward-secure baseline. Materializado em
			cap-authorization-proof-emission.
			"""
	}, {
		id: "bd-settlement-delegated-to-bkr"
		consequences: "FCE não desenvolve nem mantém rail integration logic — herda BKR Phase 5 boundary. Single source of truth para settlement outcome é BKR canonical event. Trade-off: indeterminate state em BKR propaga a FCE indeterminate (preserved epistemic); FCE não pode 'forçar' finality. Beneficio: BKR substituibilidade preservada (provider/rail changes não afetam FCE lifecycle logic)."
		decision: """
			FCE never executes technical settlement nor arbitrates
			rail behavior. BKR é sole settlement execution authority
			per Phase 5 boundary documented. FCE emite
			PaymentInstruction + AuthorizationProof; BKR consome via
			cmd-dispatch-payment-instruction; outcome canonical
			retorna a FCE via cap-payment-outcome-routing (consumindo
			SettlementFinalized / SettlementFailed /
			SettlementIndeterminate / FailureClassified /
			InstructionRejected).

			FCE NEVER re-arbitrates rail outcomes — single source of
			truth para outcome é BKR canonical event. Indeterminate
			state consumption preserves epistemic non-finality at FCE
			level (aguarda BKR resolution via
			cmd-resolve-indeterminate-state). Rail selection,
			protocol translation, retry strategy, timeout handling,
			failure classification são BKR territory.
			"""
		rationale: """
			Execution boundary preservation explícita BKR↔FCE per
			Phase 5 closed. BKR is settlement execution authority;
			FCE is economic lifecycle authority. Distinct concerns:
			BKR resolve 'did money move at rail layer?' (technical
			question); FCE resolve 'what does this mean for the
			payment obligation lifecycle?' (economic question). Sem
			esta decisão, FCE silenciosamente absorveria rail
			interpretation logic ao longo de Phase 1+ via 'override
			pontual de outcome', 'rail retry interno', 'reconciliation
			custom'. Materializado em cap-payment-outcome-routing.
			Enforcement: schema (no rail dispatch action em FCE
			agent-spec) + runner (no cmd-dispatch-to-rail invocation
			from FCE; only BKR aggregate handles).
			"""
	}, {
		id: "bd-retention-release-conditional-on-operational-truth"
		consequences: "Money releases ONLY post 4-source convergence (DLV evidence + FCE financialization + BDG retention + CMT commitment). Não há single-signature override pathway (anti-fraud estrutural). Trade-off: release events não podem ser 'rushed' por escalation manual — exception pathway requires explicit supervised override + audit trail. Beneficio: fornecedor opera sob certainty about release conditions; downstream financing antecipa com confidence."
		decision: """
			Money releases (retention payouts, next-tranche
			disbursements, full settlement) ONLY post operational
			verification convergence. Inputs canonical:
			evidence-bundle-status (DLV — completeness verified) +
			financialization-state (FCE internal — atomic completion)
			+ budget-retention (BDG — retention amount declared) +
			commitment-state (CMT — commitment progressed).

			Anti-fraud guard estrutural: não há single signature que
			libera; há aggregation de operational truth + financial
			truth + commitment truth deterministicamente convergente.
			Distingue Mesh de mecanismos commodity (escrow simples
			libera por timer; banco libera por instrução manual).
			Retention release é onde Mesh value proposition
			materializa concretamente — dinheiro condicionado a
			verdade operacional verificável.
			"""
		rationale: """
			Moat Mesh materializado per cc-01 (liberação vinculada
			a evidência). Sem evidence completude verifiable,
			dinheiro não move — esta é a propriedade que distingue
			Mesh de payment processor commodity. Vector adversarial
			protegido: tentativas de release sem evidence completa
			OR sem financialization completed OR sem commitment
			progression são forbidden por convergence requirement
			multi-source. Materializado em cap-retention-release-
			conditional. Enforcement: domain (aggregate state
			transition requires all 4 inputs convergent) + agent
			(triggers release only via cap evaluation; never via
			manual override).
			"""
	}, {
		id: "bd-reverse-settlement-upstream-mandated-only"
		consequences: "FCE não tem cmd-initiate-reverse-payment autônomo. Reverse pathway exige mandate proof upstream (DRC dispute resolution OR policy tier OR regulatory mandate); reverse execution emits NEW AuthorizationProof (não derivado de original). Defense-in-depth com BKR Phase 5: even se FCE attempts autonomous reverse, BKR rejects per cst-reverse-settlement-upstream-only. Exception pathway é supervised + audit-logged."
		decision: """
			FCE never originates reverse-settlement autonomously.
			Reverse-payment execution requires NEW AuthorizationProof
			for NEW economic obligation under upstream mandate:
			(a) DRC dispute resolution determining reversal; (b)
			FCE policy-driven refund (originated from FCE policy
			tier, not FCE runtime agent); (c) regulatory mandate
			(Bacen ou regulator) flowing through governed upstream
			process.

			Original AuthorizationProof NEVER reusable for reverse
			economic intent (per BKR
			inv-reverse-settlement-upstream-authorized-only).
			Reverse pathway é exceptional lifecycle — folded em
			cap-payment-lifecycle-state-machine (estado=reversed)
			ao invés de capability standalone porque reverse não é
			identidade FCE; é exception upstream-mandated.
			"""
		rationale: """
			Reversibility boundary decision crítica anti-drift.
			Reverse-settlement é o vector #1 onde FCE poderia
			naturalmente derivar para DRC territory (resolvendo
			disputes) OR para treasury override (auto-refund por
			'error correction'). Decisão estrutural: reverse não
			nasce em FCE; só consome mandate upstream com new
			cryptographic authority. Materializado em
			cap-payment-lifecycle-state-machine (reversed state) +
			BKR boundary preservation (BKR também recusa autonomous
			reverse per Phase 5 cst-reverse-settlement-upstream-
			only). Defense-in-depth: even se FCE somehow tried
			autonomous reverse, BKR rejects sem upstream mandate
			proof.
			"""
	}]

	// =============================================
	// COSTS ELIMINATED — 3 epistemological costs (Phase 1.3)
	// =============================================

	costsEliminated: [{
		costRef: "ce-03"
		contribution: """
			Custo de reconciliação manual de elegibilidade eliminado
			via cap-cross-bc-condition-evaluation deterministic
			convergence. Sem FCE convergence canonical, eligibility
			determination cross-BC (commitment × evidence × risk ×
			budget × invoice) requires manual cross-system check per
			payment intent — analista verificando 5+ sistemas para
			autorizar cada pagamento. FCE materializa convergence em
			single deterministic function output: authorization
			verdict + classification routing. Manual reconciliation
			elimina-se por construção, não por workflow optimization.
			"""
		rationale: """
			ce-03 (reconciliação multi-sistema) reformulado como
			custo EPISTEMOLÓGICO ao invés de operacional per founder
			Phase 1.3 direction. Não é apenas 'menos retrabalho' —
			é eliminação estrutural de classe inteira de incerteza
			sobre 'esta autorização é coerente com todos os upstream
			facts?'. Convergence determinística substitui
			reconciliation periodic manual.
			"""
	}, {
		costRef: "ce-05"
		contribution: """
			Custo de divergência entre verdade operacional e verdade
			financeira eliminado via cap-financialization-service
			atomic crystallization. Sem FCE financialization canonical
			observável, operational reality (DLV evidence + INV
			invoice + CMT commitment) e financial reality (SCF
			antecipação + ATO accounting + REW risk model)
			divergem temporal e semanticamente; reconciliation
			manual posterior é overhead estrutural. FCE materializa
			single canonical birth event de economic truth —
			operational truth → network-visible financial truth é
			atomic + observable cross-BC.
			"""
		rationale: """
			ce-05 (intermediação financeira) reformulado como custo
			EPISTEMOLÓGICO per founder Phase 1.3 direction.
			Praticamente a tese inteira da Mesh condensada: sem
			financialization observável atômica, downstream BCs
			operam sobre estado inconsistente. Esta é a propriedade
			que permite SCF antecipar com confidence, REW modelar
			risk com base em facts consolidados, ATO contabilizar
			facts não promessas. Heart of Mesh value proposition.
			"""
	}, {
		costRef: "ce-06"
		contribution: """
			Custo de ambiguidade sobre obrigação financeira válida
			eliminado via cap-authorization-proof-emission
			cryptographic crystallization + cap-retention-release-
			conditional evidence-bound release. Sem FCE
			authorization crystallization, fornecedor opera sob
			incerteza temporal — 'minha obrigação é financeiramente
			válida agora?' requires wait + manual confirmation +
			cross-system reconciliation. FCE materializa
			authorization como cryptographically attested fact;
			release como deterministic post-evidence-convergence
			event. Fornecedor (e downstream financing consumers)
			operam sobre fact observável, não promessa especulativa.
			"""
		rationale: """
			ce-06 (alongamento do ciclo do fornecedor) reformulado
			como custo EPISTEMOLÓGICO per founder Phase 1.3
			direction. Não é apenas 'pagamentos mais rápidos' —
			é eliminação de incerteza estrutural sobre validade
			temporal de obrigação. Permite SCF antecipar sem
			discount risk premium associado a 'esta obrigação ainda
			é válida?'. Cryptographic + evidence-bound boundary
			substitui temporal uncertainty.
			"""
	}]

	// =============================================
	// COMMUNICATION — placeholder; conteúdo em commit 1.4
	// =============================================

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "FCE agent identifies candidate payment authorization triggered by upstream policy tier OR convergence-evaluation-eligible state (CMT commitment in valid state + invoice present + evidence sufficient + risk eligible + budget reserved). Handler invokes cap-prepayment-guard-service + cap-cross-bc-condition-evaluation → produces authorization verdict."
			command:         "AuthorizePayment"
			resultingEvents: ["PaymentAuthorized", "PaymentAuthorizationRejected", "EligibilityConvergenceFailed"]
			description:     "Primary FCE inbound — authorization request. Verdict é deterministic convergence per bd-authorization-is-convergence-not-decision. Resulting event distribution: PaymentAuthorized (convergence succeeded → emits AuthorizationProof + invokes BKR dispatch) | PaymentAuthorizationRejected (structural failure) | EligibilityConvergenceFailed (convergence didn't satisfy — distinct from structural rejection)."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "DLV emits trigger via EvidenceCommitted indicating retention release conditions met OR upstream policy tier explicitly requests release. Handler invokes cap-retention-release-conditional convergence evaluation (evidence + financialization + budget retention + commitment state)."
			command:         "RequestRetentionRelease"
			resultingEvents: ["RetentionReleased", "RetentionBlocked"]
			description:     "Retention release request — moat Mesh materializado per cc-01. 4-source convergence determinístic; nenhum single-signature override pathway (anti-fraud estrutural)."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "DRC dispute resolution determines reversal mandate OR FCE policy tier (not runtime agent) authorizes refund OR regulatory mandate flows through governed upstream process. Handler validates mandate proof + invokes cap-authorization-proof-emission para NEW AuthorizationProof (NEVER derived from original)."
			command:         "AuthorizeReversePayment"
			resultingEvents: ["ReverseSettlementOutcome"]
			description:     "Reverse-payment authorization — DRC-only OR policy tier OR regulatory mandate per bd-reverse-settlement-upstream-mandated-only. FCE NEVER originates reverse autonomously. NEW AuthorizationProof for NEW obligation; original NEVER reusable."
		}, {
			type:          "event-consumer"
			sourceContext: "cmt"
			event:         "CommitmentAccepted"
			reaction:      "FCE cache vo-commitment-state snapshot (read-only); marca commitment como eligible-pending-financialization no internal state machine. NEVER reinterpret commitment semantics — CMT owns commitment truth per bd-upstream-truth-immutable-from-fce."
			description:   "Truth-bearing input #1 — entrada do commitment lifecycle no FCE convergence pool. Sem CommitmentAccepted upstream, FCE não tem semantic basis para authorization downstream."
		}, {
			type:          "event-consumer"
			sourceContext: "cmt"
			event:         "CommitmentStateChanged"
			reaction:      "Update cached snapshot vo-commitment-state; trigger condition re-evaluation se affecting pending authorization cycle. Cache cleared se commitment cancelled OR rolled back."
			description:   "Lifecycle state propagation from CMT. FCE may snapshot or reference, never reinterpret semantics (per bd-upstream-truth-immutable-from-fce)."
		}, {
			type:          "event-consumer"
			sourceContext: "bdg"
			event:         "BudgetApproved"
			reaction:      "Cache vo-budget-reservation snapshot. Marks budget eligibility para authorization convergence evaluation."
			description:   "Truth-bearing input from BDG — budget approval upstream condition para convergence."
		}, {
			type:          "event-consumer"
			sourceContext: "bdg"
			event:         "BudgetReserved"
			reaction:      "Update reservation snapshot; reservation amount tracked para retention release evaluation pos-convergence."
			description:   "Budget reservation lifecycle — atomic snapshot consumption. Reservation semantics never reinterpreted por FCE."
		}, {
			type:          "event-consumer"
			sourceContext: "rew"
			event:         "EligibilityDecision"
			reaction:      "Cache vo-risk-eligibility snapshot; includes timestamp para staleness check during convergence evaluation. NEVER reinterprets risk semantics — eligibility meaning belongs to REW."
			description:   "Truth-bearing risk input from REW — eligibility verdict para convergence pool. Stale eligibility (per policy threshold) triggers QueryRiskEligibilityCurrent re-validation."
		}, {
			type:          "event-consumer"
			sourceContext: "rew"
			event:         "CounterpartyRiskAlertRaised"
			reaction:      "Update eligibility cache; trigger re-evaluation se affecting pending authorization cycle. Pending authorization halted até eligibility re-validated."
			description:   "Risk state propagation. FCE consumes alert as upstream truth; never re-arbitrates risk semantics."
		}, {
			type:          "event-consumer"
			sourceContext: "inv"
			event:         "InvoiceIssued"
			reaction:      "Cache vo-invoice snapshot; validates invoice presence para convergence evaluation. Invoice validity semantics belongs to INV — FCE consumes presence + validity flag."
			description:   "Truth-bearing input from INV — fiscal/contábil substrate para payment authorization."
		}, {
			type:          "event-consumer"
			sourceContext: "inv"
			event:         "InvoiceCancelled"
			reaction:      "Update invoice state; cascade to affected authorization cycle (rejection se already authorized but not yet settled — coordinates with BKR cancellation se in-flight)."
			description:   "Invoice cancellation propagation — boundary-sensitive (cascade interaction with BKR cancellation request if dispatched)."
		}, {
			type:          "event-consumer"
			sourceContext: "dlv"
			event:         "DeliveryVerified"
			reaction:      "Cache vo-evidence-bundle snapshot; verifies evidence completeness flag para convergence + retention release evaluation. NEVER reinterprets evidence semantics — DLV owns evidence truth."
			description:   "Truth-bearing input from DLV — operational verification substrate. Core do moat Mesh: payment authorization vinculado a evidence verificável."
		}, {
			type:          "event-consumer"
			sourceContext: "dlv"
			event:         "EvidenceCommitted"
			reaction:      "Update evidence snapshot; may trigger automatic RequestRetentionRelease command-handler invocation se retention release conditions canonical met."
			description:   "Evidence lifecycle update — pode triggar automatic retention release pathway."
		}, {
			type:          "event-consumer"
			sourceContext: "tcm"
			event:         "CashOperationalStatusUpdated"
			reaction:      "Informs timing advisory for authorization scheduling — NEVER authorizes payment. Per bd-tcm-advisory-only: TCM advisory ≠ FCE authority. Liquidity insufficient pode atrasar authorization (defer) MAS NEVER weaken upstream conditions to accelerate (per canonical clause #4)."
			description:   "ADVISORY input from TCM — informs operational timing constraint. Critical anti-drift: TCM cannot become 'quem decide timing econômico' over time. FCE may defer authorization due to non-convergence, but never accelerate authorization by weakening upstream conditions."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "SettlementFinalized"
			reaction:      "Publishes canonical consequence PaymentSettled downstream (rew/ato/tcm/scf). Lifecycle state transitions to settled. FCE NEVER re-arbitrates BKR settlement outcome — single source of truth para settlement é BKR per bd-settlement-delegated-to-bkr."
			description:   "BKR canonical positive outcome consumed. FCE outbound events express economic interpretation, not settlement execution truth itself (canonical clause #2)."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "SettlementFailed"
			reaction:      "Publishes canonical consequence PaymentObligationUnsettled downstream. Lifecycle state transitions to unsettled. Triggers reissuance pathway evaluation OR cancellation. FCE NEVER overrides BKR failure verdict."
			description:   "BKR canonical negative outcome — FCE economic reaction reflects failed obligation lifecycle without re-arbitration."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "SettlementIndeterminate"
			reaction:      "Publishes canonical consequence PaymentPendingFinalReconciliation downstream. Lifecycle state preserves epistemic non-finality. Downstream consumers MUST NOT collapse into Settled nor Unsettled. Resolution waits BKR cmd-resolve-indeterminate-state explicit per BKR Phase 5 boundary."
			description:   "BKR ambiguous outcome — FCE preserves non-collapse per bd-upstream-truth-immutable-from-fce. Epistemic boundary protected end-to-end."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "FailureClassified"
			reaction:      "Consume classification as routing metadata only, NEVER as authority to reinterpret settlement causality. Classification subtype guides escalation routing decision (compliance officer sh-06 oversight for regulatory subtype) + downstream reissuance pathway eligibility. FCE NEVER absorbs classification semantics into economic policy."
			description:   "BKR granular classification — strict boundary preservation. Hoje routing metadata; NEVER drift to 'retry heuristics' OR 'economic policy adaptation'. Critical anti-drift clause: FCE consumes classification as routing metadata only, never as authority to reinterpret settlement causality."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "InstructionRejected"
			reaction:      "Pre-dispatch rejection by BKR (structural-invalid OR boundary check failure). FCE publishes canonical consequence PaymentAuthorizationRejected upstream (sh-01 + policy tier); lifecycle state transitions to rejected."
			description:   "BKR boundary rejection — FCE reflects rejection economic-side. New authorization cycle requires new InstructionId + new AuthorizationProof per BKR inv-authorization-proof-verification-gate amplification."
		}, {
			type:        "query-surface"
			query:       "QueryPaymentStatus"
			returnType:  "PaymentStatusView"
			description: "Public read-only lifecycle state query per instructionId. Returns canonical FCE state ∈ {proposed, guarded, authorized, dispatched, settled, unsettled, pending-final-reconciliation, rejected, reversed}. Per canonical clause #3: queries expose authorization state and economic lifecycle state, not authoritative upstream truth."
		}, {
			type:        "query-surface"
			query:       "QueryAuthorizationProof"
			returnType:  "AuthorizationProofReferenceView"
			description: "Scoped read-only authorization reference query. Returns hash + audit reference (NEVER full proof payload — cryptographic boundary preservation). Caller identity verified via projection layer side-channel filter: only originating policy tier can request full reference; demais consumers receive existence + hash only."
		}, {
			type:        "query-surface"
			query:       "QueryEligibilityVerdict"
			returnType:  "EligibilityVerdictView"
			description: "FCE's convergence verdict for a candidate payment authorization. Returns verdict ∈ {eligible, ineligible, pending-conditions} + classification routing if ineligible. Verdict is ephemeral and derived, not canonical upstream state — consumers MUST NOT use verdict as source-of-truth substitute for upstream BC state (CMT/BDG/REW/INV/DLV own canonical truth respectively). Side-channel filtered per caller authorization."
		}]

		outbound: [{
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "bkr"
			command:         "DispatchPaymentInstruction"
			trigger:         "FCE convergence evaluation completed positive (cap-cross-bc-condition-evaluation + cap-prepayment-guard-service approved); AuthorizationProof emitted via cap-authorization-proof-emission. PaymentInstruction payload + AuthorizationProof composite consumed by BKR."
			description:     "Primary outbound — authority crystallization materializada cryptographically. BKR Phase 5 boundary: BKR consumes proof validity never interprets nor redefines. Per bd-settlement-delegated-to-bkr: FCE is sole AuthorizationProof emitter; BKR is sole settlement execution authority."
		}, {
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "bkr"
			command:         "RequestSettlementCancellation"
			trigger:         "Upstream cancellation mandate received pre-finality (e.g., InvoiceCancelled while attempt in-flight; commitment cancelled with downstream pending dispatch). FCE forwards cancellation request to BKR per non-guaranteed pacs.057 pathway."
			description:     "Cancellation request boundary — NON-GUARANTEED per BKR Phase 1.4. FCE does not interpret rail-level cancellation outcome; BKR ACL events (acknowledged/rejected) flow back via standard reconciliation path."
		}, {
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "bkr"
			command:         "DispatchReversePaymentInstruction"
			trigger:         "Reverse-payment authorization completed via DRC mandate OR policy tier OR regulatory mandate. NEW AuthorizationProof emitted (NEVER derived from original); ReversePaymentInstruction payload + NEW AuthorizationProof composite consumed by BKR."
			description:     "Reverse pathway outbound — boundary preservation per inv-reverse-settlement-upstream-authorized-only. Defense-in-depth com BKR Phase 5: BKR rejects reverse without NEW AuthorizationProof + upstream mandate proof."
		}, {
			type:    "event-publisher"
			trigger: "FCE cap-authorization-proof-emission completed; AuthorizationProof crystallized; PaymentInstruction dispatched to BKR."
			event:   "PaymentAuthorized"
			consumers: ["rew", "ato"]
			description: "Authority crystallization milestone. REW updates risk model (authorized payment is observable economic fact). ATO marks fiscal accrual reference."
		}, {
			type:    "event-publisher"
			trigger: "FCE cap-financialization-service atomic crystallization completed — 6 upstream reads converged + AuthorizationProof emitted + commitment state progresses to obligated. Heart of Mesh loop: operational truth → network-visible financial truth atomic."
			event:   "PaymentObligationCreated"
			consumers: ["scf", "rew", "ato", "ins"]
			description: "Single canonical birth event of economic truth on Mesh network. SCF antecipa obrigação como fact (não promessa). REW modela risk com base em obligation observável. ATO contabiliza fact consolidado. INS underwrite com substrate verificável. Per bd-financialization-is-atomic: ontological #1 da Mesh."
		}, {
			type:    "event-publisher"
			trigger: "FCE consumed BKR SettlementFinalized; lifecycle transitions to settled state. Publishes canonical consequence."
			event:   "PaymentSettled"
			consumers: ["rew", "ato", "tcm", "scf"]
			description: "Economic interpretation of BKR SettlementFinalized — FCE outbound expresses economic consequence, not settlement execution truth itself (canonical clause #2). REW closes risk cycle. ATO finalizes accounting. TCM updates position. SCF closes antecipação cycle se aplicável."
		}, {
			type:    "event-publisher"
			trigger: "FCE consumed BKR SettlementFailed; lifecycle transitions to unsettled state. Publishes canonical consequence."
			event:   "PaymentObligationUnsettled"
			consumers: ["rew", "ato"]
			description: "Economic lifecycle outcome of obligation not settling (renamed from 'PaymentFailedEconomically' per founder Phase 1.4 ajuste 2 — avoid 'economically' as future semantic garbage; preserve explicit link to settlement). Triggers reissuance pathway evaluation OR cancellation. REW updates obligation tracking. ATO marks annullment OR pending reissuance."
		}, {
			type:    "event-publisher"
			trigger: "FCE consumed BKR SettlementIndeterminate; lifecycle state preserves epistemic non-finality."
			event:   "PaymentPendingFinalReconciliation"
			consumers: ["rew", "ato"]
			description: "Epistemic non-finality preserved end-to-end. Downstream consumers MUST NOT collapse into Settled nor Unsettled — preserves replay safety + reconciliation semantics + operational auditability. Resolution waits BKR cmd-resolve-indeterminate-state explicit per bd-upstream-truth-immutable-from-fce."
		}, {
			type:    "event-publisher"
			trigger: "FCE cap-retention-release-conditional convergence evaluation completed positive (evidence + financialization + budget retention + commitment state). Triggered via RequestRetentionRelease command-handler."
			event:   "RetentionReleased"
			consumers: ["bdg", "scf"]
			description: "Moat Mesh materializado per cc-01 — dinheiro condicionado a verdade operacional verificável. BDG updates retention amount. SCF unlocks downstream financing eligibility se aplicável. Anti-fraud guard estrutural materializada."
		}, {
			type:    "event-publisher"
			trigger: "Reverse-payment execution completed via BKR (consumed via standard settlement outcome path — SettlementFinalized OR SettlementFailed para reverse instruction)."
			event:   "ReverseSettlementOutcome"
			consumers: ["drc", "ato", "rew"]
			description: "Economic consequence of reverse-settlement execution. DRC closes dispute resolution cycle. ATO marks reverse accounting entries. REW updates risk model post-reverse outcome."
		}, {
			type:    "event-publisher"
			trigger: "FCE cap-prepayment-guard-service detected structural failure (proof invalid, business-invalid pre-dispatch, OR BKR InstructionRejected propagation)."
			event:   "PaymentAuthorizationRejected"
			consumers: ["sh-01"]
			description: "Boundary-level rejection — structural failure distinct from convergence non-success. New authorization cycle requires new instructionId + new AuthorizationProof. Originadora (sh-01 policy tier) decides correction pathway."
		}, {
			type:    "event-publisher"
			trigger: "FCE cap-cross-bc-condition-evaluation produced non-convergence verdict — one OR more upstream conditions failed to satisfy authorization threshold."
			event:   "EligibilityConvergenceFailed"
			consumers: ["rew", "bdg", "sh-01"]
			description: "Convergence failure distinct from authorization rejection. World converged to 'not eligible' — upstream BC state didn't satisfy convergence. Classification routing identifies which BC needs attention (REW se eligibility expired; BDG se budget insufficient; etc.). Per bd-authorization-is-convergence-not-decision: FCE evaluates convergence; never decides discretionarily."
		}, {
			type:    "event-publisher"
			trigger: "FCE cap-retention-release-conditional detected non-convergence — 1+ of 4 sources (evidence + financialization + budget retention + commitment state) didn't satisfy release threshold."
			event:   "RetentionBlocked"
			consumers: ["bdg", "sh-01"]
			description: "Explicit non-convergence signal for retention release. Distinct from release deferral (advisory delay) — RetentionBlocked é structural non-convergence; release pathway exige condition resolution upstream."
		}, {
			type:          "query-dependency"
			targetContext: "cmt"
			query:         "QueryCommitmentState"
			purpose:       "Re-validation pre-authorization when cached vo-commitment-state snapshot stale per FCE policy threshold. FCE may cache, snapshot, or reference upstream truth for authorization evaluation, but never reinterpret upstream semantic meaning."
			description:   "Stale-cache fallback to authoritative CMT source. CMT remains single source of truth para commitment state per bd-upstream-truth-immutable-from-fce."
		}, {
			type:          "query-dependency"
			targetContext: "ctr"
			query:         "QueryContractTerms"
			purpose:       "Contract terms validation cross-check — eligibility convergence requires verification against contract conditions (e.g., payment terms allow current authorization timing; retention amounts match contract)."
			description:   "Contract terms validation — CTR owns contract truth; FCE consumes for convergence verification."
		}, {
			type:          "query-dependency"
			targetContext: "tcm"
			query:         "QueryAccountAvailability"
			purpose:       "Pre-dispatch operational liquidity advisory check (informs timing; NEVER authorizes payment per bd-tcm-advisory-only). FCE may defer authorization based on TCM advisory, but never accelerate by weakening upstream conditions."
			description:   "TCM advisory query — informs timing decision; does not authorize. Critical anti-drift: TCM cannot become 'quem decide timing econômico' over time."
		}, {
			type:          "query-dependency"
			targetContext: "rew"
			query:         "QueryRiskEligibilityCurrent"
			purpose:       "Re-validation when cached vo-risk-eligibility snapshot aged out per FCE staleness threshold. REW provides current eligibility state; FCE never reinterprets semantics."
			description:   "Stale-cache fallback to authoritative REW source. REW remains single source of truth para risk eligibility."
		}]

		rationale: """
			Communication boundary modela FCE como downstream-
			authoritative authority crystallization layer — convergence
			node de 5 upstream truth-bearing inputs + 1 advisory input
			+ 5 BKR settlement outcome inputs; emite authorization
			cryptographic + economic lifecycle outcomes downstream.

			4 canonical clauses transversais governam communication
			semantics:

			(1) TRANSVERSAL PRINCIPLE — FCE is downstream-authoritative,
			not upstream-controlling. Downstream dominance é dependency
			pattern (concentra leituras cross-BC para convergence);
			NOT control authority (não reescreve upstream facts; não
			arbitra settlement; não substitui rail outcome
			interpretation).

			(2) OUTBOUND EVENTS PRINCIPLE — FCE outbound events express
			economic interpretation of canonical settlement outcomes,
			not settlement execution truth itself. PaymentSettled é
			economic consequence de BKR SettlementFinalized;
			PaymentObligationUnsettled é economic consequence de BKR
			SettlementFailed; PaymentPendingFinalReconciliation é
			economic acknowledgment de BKR SettlementIndeterminate.
			BKR owns settlement truth; FCE owns economic consequence.

			(3) QUERIES PRINCIPLE — Queries expose authorization state
			and economic lifecycle state, not authoritative upstream
			truth. QueryPaymentStatus expõe lifecycle FCE-canonical;
			QueryAuthorizationProof expõe reference hash (never
			payload); QueryEligibilityVerdict é ephemeral and derived,
			not canonical upstream state. Consumers MUST consultar
			upstream BCs (CMT/BDG/REW/INV/DLV) para canonical truth de
			respective domains.

			(4) TEMPORAL AUTHORITY DRIFT CLAUSE — FCE may defer
			authorization due to non-convergence, but never accelerate
			authorization by weakening upstream conditions. Protege
			contra deriva perigosíssima futura: 'flexibilizar evidence
			porque está demorando'; 'aceitar risk stale
			temporariamente'; 'usar cache vencido para acelerar'.
			Defer é acceptable; weaken é forbidden.

			Semantic ownership matrix preservada explicitly:
			- BKR owns: SettlementFinalized | SettlementFailed |
			  SettlementIndeterminate (technical settlement outcomes)
			- FCE owns: PaymentAuthorized | PaymentObligationCreated |
			  PaymentSettled | PaymentObligationUnsettled |
			  PaymentPendingFinalReconciliation | RetentionReleased |
			  ReverseSettlementOutcome | PaymentAuthorizationRejected |
			  EligibilityConvergenceFailed | RetentionBlocked
			- Anti-pattern names forbidden: PaymentCompleted,
			  ObligationSettled, PaymentFinalized, SettlementCompleted
			  — sugerem dual ownership OR boundary blur.

			Anti-drift transversal clause (eco em bd-upstream-truth-
			immutable-from-fce + outer rationale Phase 1.6):
			'FCE owns authorization convergence, never truth production
			nor settlement execution.' Esta é literalmente o anti-
			monólito semântico do FCE — impede absorção de REW
			(eligibility semantics), DLV (evidence semantics), BDG
			(budget semantics), INV (invoice semantics), CMT
			(commitment semantics), BKR (settlement execution), TCM
			(treasury authority).

			Critical anti-drift on FailureClassified consumption: FCE
			consumes classification as routing metadata only, never as
			authority to reinterpret settlement causality. Hoje routing
			metadata; NEVER drift to retry heuristics OR economic
			policy adaptation OR BKR absorption.

			39 entries total (22 inbound + 17 outbound — 3 commands +
			16 events truth/advisory/outcome + 3 query-surfaces para
			inbound; 3 command-invocations + 10 event-publishers +
			4 query-dependencies para outbound). Scale reflects FCE
			downstream-dominant nature; ownership rigor preserves
			boundary integrity per founder Phase 1.4 ajuste 8 (scale
			não é o problema; ownership é).

			Wording shift per founder Phase 1.4 ajuste 5: 'trigger
			downstream FCE state transitions' substituído por 'publish
			canonical consequence' em descriptions/reactions onde FCE
			acts on BKR outcomes — preserves downstream autonomy +
			boundedness; FCE reflects consequence, not defines policy.
			"""
	}

	// =============================================
	// STAKEHOLDERS — placeholder; conteúdo em commit 1.3
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "upstream authority producer — emissor de commitment compromissos formalizados (via CMT) + budget approvals (via BDG). FCE consome decisions made upstream; never produces commitment nor budget."
		impactDescription: "Originadora autoriza cadeia de eventos que culmina em FCE convergence evaluation. Receives downstream PaymentSettled / PaymentObligationDefaulted events para closure operational visibility."
		rationale:         "Structural role: upstream truth producer. Sem originadora authority production upstream, FCE não tem facts para converger. Stakeholder boundary: originadora produces commitment + budget facts; FCE consumes para authorization."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "downstream financing consumer + payment beneficiary — fornecedor recebendo credito post-settlement; rede downstream (SCF + secondary financing) consumindo observable financial truth produzida por FCE financialization."
		impactDescription: "Beneficia-se de single canonical birth event de economic truth (via cap-financialization-service) que reduz ambiguidade temporal sobre validade de obrigação financeira. Consumes PaymentSettled events directly + indirectly via SCF antecipação."
		rationale:         "Structural role: downstream financing consumer. Anti-fraud protection materializa-se para sh-02 via cap-retention-release-conditional (dinheiro só releases post operational truth convergence). Diferenciador moat Mesh."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "compliance/audit + regulatory boundary constraint authority — Bacen como SCD compliance + Pix policy + AML/KYC enforcement boundary. FCE absorve regulatory constraints como inputs estruturais (não enforça policy regulatória diretamente — enforcement via IDC/NPM)."
		impactDescription: "Boundary constraint provider; recebe reporting via parceiro autorizado/IDC channel. Não consume eventos FCE diretamente; é constraint authority cuja spec drift dispara ec-regulatory-boundary-misalignment escalation (forwarded a BKR pattern aplicado aqui também)."
		rationale:         "Structural role: regulatory boundary constraint. FCE relationship com Bacen é mediado — FCE não interage direto; absorve regulation via upstream channels. Distinto de BKR onde rail-level regulation absorption é mais direto."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "authorization operations — FCE agent guardião do boundary de autoridade. Runtime authorization decision execution; convergence evaluation; cryptographic crystallization via AuthorizationProof emission. NÃO é tesouraria clássica (cash optimization + liquidity strategy + working capital discretion são fora do escopo); é guardian of economic authority boundary."
		impactDescription: "Executa autonomously decisions limitadas a convergence evaluation determinística (per cap-cross-bc-condition-evaluation); escalates supervisada para discretionary cases (override risk + budget waiver + reverse-payment authorization). Per BKR Phase 5 pattern: aggressive supervised onboarding Phase 0; promotion paths via calibration."
		rationale:         "Structural role: authorization operations (per founder Phase 1.3 ajuste 5). 'Treasury/operations' framing rejeitado porque puxa naming para cash optimization + liquidity strategy. Authorization operations é boundary-aligned: opera convergence + crystallization, não treasury discretion. Naming preserva identity boundary contra drift para treasury orchestrator."
	}, {
		stakeholderRef:    "sh-06"
		roleInContext:     "compliance officer — side-channel routing policy authority; audit oversight on classification routing (failure-classification detail sharing per caller identity); regulatory escalation receiver for compliance-sensitive scenarios."
		impactDescription: "Receives escalations on classification side-channel leak detection + meta-detection on FCE info leak patterns. Authority over routing policy for compliance-sensitive detail (regulatory subtype + sanctions hint + AML trigger specifics). Paralelo a BKR Phase 5 sh-06 + analogous granular-vs-sanitized authority."
		rationale:         "Structural role: compliance/audit oversight orthogonal to operational authority. Distinct from sh-05 (authorization operations runtime) — sh-06 governs visibility/routing policy that protects compliance-sensitive info. Side-channel mitigation via projection layer + escalation routing depend on sh-06 policy decisions."
	}]

	// =============================================
	// INCENTIVE ANALYSIS — placeholder; conteúdo em commit 1.5
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-05"
			participantType:           "runtime authorization operations agent"
			desiredBehavior:           "FCE agent operates strict convergence evaluation per 6 upstream reads + bd-authorization-is-convergence-not-decision; emits AuthorizationProof only when ALL conditions converge per deterministic rules; defers when non-convergent (per canonical clause #4: defer acceptable, weaken forbidden); respects cache staleness thresholds + invokes re-validation queries when needed; never mutates upstream truth nor reinterprets upstream semantics."
			correctOperationIncentive: "Operator audited via 13-field audit trail (paralelo BKR Phase 5 pattern); promotion paths via calibration require sustained zero-violation track record across full outcome distribution (não apenas happy paths); evaluation metric is convergence integrity, NOT authorization throughput."
			manipulationVector:        "Silent autonomy expansion (cumulative drift): (a) caching upstream truth beyond staleness policy (using aged eligibility OR stale budget); (b) condition threshold weakening to accelerate convergence (drop one of 6 upstream reads when 'demorando'); (c) heuristic adaptation embedding economic policy decisions; (d) semantic absorption (gradually interpreting upstream meanings — 'evidence is probably complete' OR 'risk should be eligible by now'); (e) treating TCM advisory as timing authority; (f) convergence flickering exploitation (issue authorization between A and A+1s when condition validity transient). Cumulative drift over time = FCE identity erosion."
			manipulationCost:          "Individual instance: low (single runtime decision appears reasonable in isolation). Cumulative pattern detection: medium (audit trail review identifies pattern across time + dm-* drift metrics). Boundary integrity validation runner: high (structural drift detection via convergence consistency rate + ec-convergence-boundary-erosion-detected escalation criterion)."
			vsBenefit:                 "Catastrophic — FCE identity erosion is anti-Mesh pattern. Single FCE that absorbs upstream concerns destroys the entire architectural premise. Boundary integrity loss is not recoverable via supervised intervention; requires governance-level rollback. Each individual decision appears reasonable; cumulative pattern is destructive. Real adversarial pattern of FCE is gradualism, not explicit failure."
			designResponse:            "(a) Cache staleness policy enforced via runner check (boundary integrity validation); (b) governance envelope blastRadiusCaps Phase 5 cap mutations aggressively (paralelo BKR pattern, even tighter for FCE given convergence sensitivity); (c) escalationCriteria ec-condition-weakening-to-accelerate (primary architectural drift detector) + ec-eligibility-staleness-bypass + ec-upstream-truth-mutation-attempt + ec-convergence-boundary-erosion-detected detect specific drift vectors; (d) drift metrics on convergence consistency rate detect gradual pattern erosion; (e) sustained 60-day zero-violation precondition for any autonomy promotion; (f) evaluation metric explicit canonical: convergence integrity not throughput."
			rationale:                 "Vetor adversarial #1 do FCE — non-obvious porque drift is gradual + each individual decision appears reasonable. Cumulative erosion é o real vector. Per founder Phase 1.2/1.3/1.4/1.5 transversal direction + anti-monólito clause: 'FCE owns authorization convergence, never truth production nor settlement execution.' Drift via sh-05 runtime is the primary pathway through which FCE would become super-orchestrator over time. FCE autonomy is bounded by convergence determinism — limits the ontology of autonomy permitted, not just its level."
		}, {
			stakeholderRef:            "sh-01"
			participantType:           "upstream authority issuer (commitment + budget originator)"
			desiredBehavior:           "Originadora emits commitments + budget approvals + invoices reflecting genuine economic operations; upstream BC trust chain (CMT/BDG/INV authorities) issues facts grounded in operational reality; cryptographic identity protected; multi-BC chain integrity preserved."
			correctOperationIncentive: "Commitment + budget + invoice authority chain is audit-traceable; downstream financialization observability creates feedback loop — ghost commitments without ultimate physical operation become detectable via DLV evidence non-convergence + dm-* drift metrics over time."
			manipulationVector:        "Ghost-payment authorization via forged upstream truth: (a) fake CommitmentAccepted without real commitment; (b) backdated evidence inference (manipulate evidence timestamps); (c) fake risk eligibility via REW compromise; (d) collusion across multiple upstream BCs to satisfy convergence simultaneously without underlying truth. Goal: extract payment authorization for non-existent operation."
			manipulationCost:          "High — requires either cryptographic key compromise OR multi-BC collusion. Defense-in-depth via cross-BC convergence reduces single-BC attack surface; ghost-payment requires coordinated forgery across 5+ BCs (CMT + BDG + REW + INV + DLV)."
			vsBenefit:                 "Low — single payment fraud bounded by financialization atomicity. PaymentObligationCreated is observable network-wide; downstream consumers (SCF antecipação) detect inconsistency over time. Recurring ghost-payments at scale would trigger network-wide anomaly via dm-* metrics + ec-ghost-authorization-detected."
			designResponse:            "(a) Cryptographic AuthorizationProof boundary (5-component composite per bd-authorization-proof-cryptographic-binding); (b) 6-source convergence requires coordinated forgery; (c) escalationCriteria ec-ghost-authorization-detected detects authorization patterns without underlying truth; (d) audit trail 13+ fields reconstruct full convergence evaluation for forensic review; (e) financialization observability creates downstream feedback loop (SCF antecipação reconciliation detects inconsistency); (f) atomic financialization (no partial commits) bounds blast radius even under hypothetical breakthrough."
			rationale:                 "Per bd-financialization-is-atomic — financialization is the canonical transition from operational truth to network-visible financial truth. Atomicity itself is part of ghost-payment defense: shadow obligations cannot be partial; either fully crystallized OR not at all. Defense-in-depth assumes some upstream BC compromise possible; FCE convergence boundary contains blast radius."
		}, {
			stakeholderRef:            "sh-02"
			participantType:           "downstream financing consumer + payment beneficiary"
			desiredBehavior:           "Downstream financing actor (SCF antecipação + secondary financing + retention recipients) consume PaymentObligationCreated as canonical observable fact post atomic financialization; respect epistemic non-finality of PaymentPendingFinalReconciliation; do NOT collapse non-final states into final assumptions."
			correctOperationIncentive: "Financing decisions based on observable financial truth (not promise) reduce risk premium; antecipação cycles align with actual financialization atomicity; retention release timing predictable per cap-retention-release-conditional convergence."
			manipulationVector:        "Rapid antecipação claim from non-final state: (a) consume PaymentObligationCreated before financialization atomicity fully completed (temporal race); (b) infer retention release pre-evidence completeness (downstream pressure to release earlier); (c) treat PaymentPendingFinalReconciliation as PaymentSettled (epistemic collapse). Goal: extract financing benefit before underlying state truly stable."
			manipulationCost:          "Medium — requires temporal race against atomic crystallization OR epistemic collapse cooperation from FCE/SCF integration layer. Race condition narrow if atomicity guarantee enforced via aggregate handler."
			vsBenefit:                 "Medium — financing fraud bounded by re-verification post-claim. Audit trail captures temporal sequence; SCF antecipação reconciliation triggers anomaly detection if PaymentObligationCreated retroactively reversed OR non-final state collapsed."
			designResponse:            "(a) Atomic financialization with transactional guarantee (no partial commits observable network-wide); (b) PaymentPendingFinalReconciliation as distinct canonical event (NOT collapsable into Settled per canonical clause #4 echo); (c) consumerProtocol contract (paralelo BKR Phase 5 adr-084): consumers MUST handle non-final states; (d) SCF antecipação reconciliation contract enforces fact-based (not promise-based) financing."
			rationale:                 "Bounded adversarial vector — financialization atomicity + epistemic preservation contain blast radius. Anti-fraud guard via 4-source convergence (RetentionReleaseConvergenceSet) preserves moat: retention release vinculada a verdade operacional verificável (cc-01)."
		}, {
			stakeholderRef:            "sh-04"
			participantType:           "regulatory boundary constraint authority (non-adversarial)"
			desiredBehavior:           "Bacen + regulatory bodies publish stable + interpretable regulatory specs (SCD + Pix policy + AML/KYC) that FCE convergence policy absorbs as upstream truth via IDC/NPM. Regulatory spec changes flow through governed channels with adequate notice for FCE policy adaptation."
			correctOperationIncentive: "Compliance achieved via mechanism (FCE convergence policy + IDC enforcement) not heuristic; regulatory audit trail reconstruction supported via 13-field audit; FCE never enforces regulatory policy directly (per RegulatoryBoundary glossary term)."
			manipulationVector:        "Structural-absence (NOT malicious): regulatory spec drift not absorbed into FCE convergence policy in adequate time — leads to gap between current regulation and FCE behavior. Examples: new Bacen ruling on AML thresholds not propagated; SCD operational rules updated without IDC notification chain; sanctions list updates not reaching REW eligibility model. FCE compliance violations cumulative over time despite no operational malice."
			manipulationCost:          "(não-malicious) — cost is operational coordination gap, not adversarial action. Mitigation requires governance/IDC channel discipline."
			vsBenefit:                 "(não-malicious assessment) — compliance violations cumulative over time can trigger regulatory action; financial penalties + reputation damage; potential loss of SCD license."
			designResponse:            "(a) ec-regulatory-boundary-misalignment escalation criterion (paralelo BKR Phase 5 pattern) — halt + escalate sem heuristic adaptation; (b) IDC/NPM channel propagates regulatory updates as upstream truth; (c) FCE convergence policy versioned (per governance-version audit field); (d) regulatory specialist (sh-04 stakeholder) reviews boundary alignment quarterly minimum."
			rationale:                 "Non-adversarial participant modeled per structural-absence pattern — captures regulatory drift risk without implying Bacen as adversary. Per glossary term-regulatory-boundary: BKR (and FCE) consume regulatory constraints as inputs; never enforce policy beyond structural absorption. Same boundary principle applies upstream."
		}, {
			stakeholderRef:            "sh-06"
			participantType:           "compliance officer / side-channel routing policy authority"
			desiredBehavior:           "Compliance officer governs side-channel routing policy (which classification detail visibility flows to which consumer per caller identity); side-channel mitigation enforced via prj-failure-classification + prj-eligibility-verdict projection layer filtering; classification subtypes (regulatory + account-status + rail-limit + provider-policy) routed per caller authorization."
			correctOperationIncentive: "Compliance audit trail captures all routing policy decisions; side-channel mitigation via projection layer is auditable + reproducible; sh-06 oversight separable from runtime authorization (sh-05 territory)."
			manipulationVector:        "(a) Side-channel routing policy adjustment without audit (silently relaxing visibility constraints); (b) classification detail leak to non-authorized consumer (granular sanctions detail OR AML triggers routed to broad downstream); (c) sh-06 authority abuse: side-channel routing manipulation for downstream financial benefit (informing favored consumers about flagged transactions); (d) projection layer bypass via direct event consumption."
			manipulationCost:          "Medium — requires policy authority abuse OR projection layer bypass. Detection via audit trail spot-checks + ec-classification-side-channel-leak-detected escalation criterion (paralelo BKR Phase 5)."
			vsBenefit:                 "High — regulatory compliance breach + sanctions exposure + potential criminal liability under AML/KYC regimes. Side-channel leak amplification risk (compliance info informing adversarial pattern continuation)."
			designResponse:            "(a) Projection layer enforces filtering deterministically (not via discretionary sh-06 decision per query); (b) ec-classification-side-channel-leak-detected detects leak patterns; (c) ec-fce-info-leak-meta-detection self-monitoring (paralelo BKR ec-bkr-info-leak-meta-detection); (d) sd-side-channel-routing-policy-change requires supervised approval + audit; (e) sh-06 stakeholder distinct from sh-05 (authorization operations) to preserve separation of concerns."
			rationale:                 "Side-channel mitigation is FCE Phase 0 priority because FCE classification routing handles regulatory-sensitive detail (REW eligibility decisions + BDG budget detail can reveal counterparty risk profiles). Boundary integrity requires compliance authority orthogonal to authorization runtime; sh-06 distinct from sh-05 prevents single-actor compromise."
		}]
		rationale: """
			5 incentive participants cobrem 5 categorias de adversarial
			risk distintas: (1) sh-05 runtime drift cumulativo — vetor
			adversarial #1 do FCE; (2) sh-01 ghost-payment via upstream
			forgery — bounded by atomicity + convergence; (3) sh-02
			downstream financing rapid claim — bounded by atomicity +
			epistemic preservation; (4) sh-04 regulatory structural-
			absence — non-malicious drift via spec coordination gap;
			(5) sh-06 side-channel routing manipulation — compliance
			authority abuse vector.

			Vetor adversarial #1 (sh-05 cumulative drift) é qualitativa-
			mente diferente dos demais: não é explicit failure but
			gradual erosion. Each individual decision appears reasonable;
			cumulative pattern destrói boundary integrity. Detection
			pattern requires drift metrics + boundary integrity runner
			+ ec-convergence-boundary-erosion-detected meta-pattern
			escalation (renamed from ec-authorization-boundary-
			exploitation-detected per founder Phase 1.5 ajuste 7).

			FCE autonomy is bounded by convergence determinism — esta
			frase canônica limita não apenas o nível de autonomia
			(propose-and-wait vs execute-and-log) mas a ONTOLOGIA da
			autonomia permitida. FCE pode reconhecer convergence; nunca
			pode otimizar convergence. Convergence reconhecida é
			authority crystallization; convergence otimizada é authority
			drift toward super-orchestrator.

			Per founder Phase 1.5 ajuste 9 — canonical evaluation metric:
			FCE is evaluated on convergence integrity, not authorization
			throughput. Métricas erradas destroem arquitetura correta.
			Optimizing throughput inevitably enfraquece thresholds +
			reinterpreta upstream truth + absorve authority.
			"""
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 1.5
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/fce/agents/fce-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "ad-deterministic-convergence-evaluation"
				description: "FCE agent evaluates 6 upstream reads (CMT commitment state + BDG budget reservation + REW risk eligibility + INV invoice + DLV evidence + TCM operational advisory) via cap-cross-bc-condition-evaluation per deterministic rules — pure function output (eligible / ineligible / pending) without discretion. Output é determinado completamente por inputs upstream; never depends on agent judgment."
				rationale:   "Per bd-authorization-is-convergence-not-decision: FCE evaluates eligibility, never rewrites upstream truth. Convergence evaluation é pure function; autonomy bounded by determinism. Permite execute-and-log Phase 1+ (post-calibration) porque output é reproduzível + auditável."
			}, {
				id:          "ad-atomic-financialization-when-converged"
				description: "FCE agent invokes cap-financialization-service when convergence completeness is provably stable within the evaluation window (per founder Phase 1.5 ajuste 3 — protege convergence flickering). Atomic crystallization é transactional + observable network-wide. Convergence momentânea seguida de invalidation logo após NÃO suficiente — stability window enforced antes de emission."
				rationale:   "Per bd-financialization-is-atomic: heart of Mesh loop. Convergence flickering protection é critical porque FCE opera sobre múltiplos upstreams cuja validity pode oscilar. Stability window é structural protection (não policy heuristic) — runner check enforced via aggregate handler temporal validation."
			}, {
				id:          "ad-authorization-proof-emission-when-eligible"
				description: "FCE agent emits AuthorizationProof composite (5 components: cryptographic signature + nonce + issuedAt + validity window + claim chain) via cap-authorization-proof-emission when convergence verdict = eligible AND stability window satisfied. Deterministic cryptographic operation — same convergence state produces same proof structure."
				rationale:   "Per bd-authorization-proof-cryptographic-binding: cryptographic crystallization da economic authority FCE. Autonomy possível porque cryptographic operation é deterministic + bounded; non-deterministic decision moved upstream (convergence evaluation)."
			}, {
				id:          "ad-bkr-outcome-canonical-consumption"
				description: "FCE agent consumes BKR canonical outcomes (SettlementFinalized/Failed/Indeterminate) via cap-payment-outcome-routing; deterministic state transition reflection (lifecycle update + downstream PaymentSettled/Unsettled/PendingFinalReconciliation publication). FCE NEVER re-arbitrates BKR outcome per bd-settlement-delegated-to-bkr."
				rationale:   "Per canonical clause #2: FCE outbound events express economic interpretation of canonical settlement outcomes, not settlement execution truth itself. BKR owns settlement truth; FCE owns economic consequence. Mapping is deterministic; no discretion."
			}, {
				id:          "ad-classification-routing-metadata-only"
				description: "FCE agent consumes BKR FailureClassified as routing metadata only — guides escalation routing decision (sh-06 compliance oversight for regulatory subtype) + downstream reissuance pathway eligibility flagging. NEVER reinterprets settlement causality. Hoje routing metadata; NEVER drift to retry heuristics OR economic policy adaptation."
				rationale:   "Per founder Phase 1.4 ajuste 3: FCE consumes classification as routing metadata only, never as authority to reinterpret settlement causality. Anti-drift critical clause: routing metadata é structural categorization; reinterpretation seria absorption."
			}, {
				id:          "ad-retention-release-when-convergence-set-met"
				description: "FCE agent triggers RetentionReleased when RetentionReleaseConvergenceSet (canonical 4-source set per founder Phase 1.5 ajuste 4) converges: DLV evidence completeness + FCE financialization atomic completion + BDG budget retention amount + CMT commitment state progression. Deterministic 4-source AND gate; no single-signature override pathway."
				rationale:   "Per bd-retention-release-conditional-on-operational-truth + cc-01: moat Mesh materializado — dinheiro condicionado a verdade operacional verificável. RetentionReleaseConvergenceSet nomenclatura canônica explicita estrutura (per founder Phase 1.5 ajuste 4) — aparecerá em audit, queries, métricas, governance, explicabilidade."
			}]

			supervisedDecisions: [{
				id:          "sd-reverse-payment-authorization"
				description: "Authorize reverse-payment for an existing PaymentObligation that has been settled. Requires explicit mandate proof: DRC dispute resolution determination OR FCE policy tier (not runtime agent) mandate OR regulatory mandate flowing through governed upstream process. Generates NEW AuthorizationProof for NEW economic obligation (NEVER derived from original)."
				rationale:   "Per bd-reverse-settlement-upstream-mandated-only: FCE never originates reverse-settlement autonomously. Defense-in-depth com BKR Phase 5 cst-reverse-settlement-upstream-only — even se FCE tried autonomous reverse, BKR rejects sem upstream mandate proof. Supervised approval enforces mandate validation + audit trail completeness."
			}, {
				id:          "sd-budget-override-or-waiver"
				description: "When BDG budget reservation insufficient but business case justifies override (e.g., emergency payment with retroactive budget approval pathway). Supervisor approves with documented rationale + audit trail; FCE never autonomously overrides budget insufficient."
				rationale:   "Budget is BDG truth per bd-upstream-truth-immutable-from-fce; override NEVER mutates BDG state — only authorizes temporary tolerance under explicit audit. Supervised because override is discretionary; convergence pattern explicitly broken via supervisor decision (not heuristic agent adaptation)."
			}, {
				id:          "sd-risk-eligibility-waiver-post-aged"
				description: "When cached vo-risk-eligibility snapshot aged out per FCE staleness threshold AND QueryRiskEligibilityCurrent returns ineligible OR unavailable AND business case requires time-bounded tolerance. Supervisor approves waiver with audit; waiver never mutates REW truth; only authorizes temporary tolerance under explicit audit (per founder Phase 1.5 ajuste 8)."
				rationale:   "Per founder Phase 1.5 ajuste 8: waiver never mutates REW truth; only authorizes temporary tolerance under explicit audit. Sem essa cláusula, waiver vira reinterpretation, depois vira shadow risk engine. Critical anti-drift: waiver é supervisor decision + audit, NEVER FCE agent caching ineligibility as eligible."
			}, {
				id:          "sd-financialization-rollback"
				description: "Post-atomic crystallization rollback — when financialization completed but fraud OR evidence forgery detected post-fact, rollback affects network observability (PaymentObligationCreated retroactively invalidated). Structural reversal pathway via supervisor mandate; affects SCF antecipação reconciliation + REW risk model + ATO accounting downstream."
				rationale:   "Per bd-financialization-is-atomic: irrevocable atomicity is structural property post-crystallization. Rollback violates atomicity by definition — requires supervised intervention + downstream coordination + audit trail. Not autonomous because consequences propagate network-wide."
			}, {
				id:          "sd-side-channel-routing-policy-change"
				description: "Classification detail visibility policy change (sh-06 compliance officer authority) — affects regulatory-sensitive routing (granular subtype detail flow to callers per identity). Supervisor (sh-06 compliance officer) approves change with audit; policy versioned via governance-version field."
				rationale:   "Side-channel routing affects regulatory compliance + sanctions exposure. Policy changes require oversight separable from runtime authorization (sh-05 territory). Versioning enables forensic reconstruction of which policy was active per audit trail entry."
			}, {
				id:          "sd-cancel-pending-authorization-pre-dispatch"
				description: "Cancel authorization before BKR dispatch sent — post-authorization but pre-BKR commit (between AuthorizationProof emission and DispatchPaymentInstruction issued). Supervisor approves cancellation rationale; reverses lifecycle state from authorized to rejected; no rail-level cancellation needed (no dispatch occurred)."
				rationale:   "Cancellation pre-dispatch is discretionary intervention; convergence was met but external factors (upstream cancellation OR detected anomaly) justify halt. Supervisor decision required because cancellation overrides deterministic flow that already converged. Audit trail captures cancellation reason."
			}]

			escalationCriteria: [{
				id:        "ec-ghost-authorization-detected"
				condition: "Authorization completed (AuthorizationProof emitted) but downstream evidence/operational reconciliation shows no underlying operation: DLV evidence completeness rate declined for instructionId family + cross-BC inconsistency pattern detected via dm-* metrics + SCF antecipação reconciliation triggers anomaly."
				action:    "Halt all pending authorizations for affected originadora (sh-01 family); emit GhostAuthorizationAnomaly event para audit + sh-06 compliance officer review; forensic investigation across 6 upstream BCs to identify ghost source (CMT/BDG/REW/INV/DLV); sustained pattern triggers ec-convergence-boundary-erosion-detected meta-escalation."
				rationale: "Vector adversarial sh-01 (ghost-payment via forged upstream truth) detection. Bounded by financialization atomicity but cumulative ghost-payments destroy network confidence. Detection feedback loop via downstream observable inconsistency."
			}, {
				id:        "ec-financialization-atomicity-violation"
				condition: "Partial financialization commit detected — PaymentObligationCreated emitted but one or more downstream consumers (SCF/REW/ATO/INS) observed inconsistent state OR aggregate handler transactional guarantee broken via system fault."
				action:    "Halt all financialization operations system-wide; emit AtomicityViolationDetected event para compliance + founder; structural rollback evaluation (sd-financialization-rollback) for affected obligation; forensic investigation of aggregate handler integrity."
				rationale: "Catastrophic per bd-financialization-is-atomic — atomicity is heart of Mesh loop. Single violation indicates structural integrity failure; sustained operation impossible until root cause resolved."
			}, {
				id:        "ec-reverse-without-mandate-detected"
				condition: "Autonomous reverse-payment attempt detected — FCE agent attempted to invoke DispatchReversePaymentInstruction OR ReversePayment cycle without valid DRC/policy/regulatory mandate proof; OR reverse instruction emitted via original AuthorizationProof reuse."
				action:    "Halt all reverse-payment operations; emit AutonomousReverseAttemptDetected event para founder + DRC + compliance; FCE agent rollback to no-autonomous-action authonomy level pending forensic + structural review."
				rationale: "Per bd-reverse-settlement-upstream-mandated-only: FCE never originates reverse. Autonomous reverse attempt indicates either agent compromise OR boundary integrity violation. Defense-in-depth com BKR Phase 5 cst-reverse-settlement-upstream-only — both layers should reject."
			}, {
				id:        "ec-tcm-advisory-treated-as-authority"
				condition: "FCE agent behavior pattern shows TCM signal driving authorization decisions: authorization timing correlation with TCM liquidity signal > policy threshold; OR authorization deferred/expedited based on TCM advisory without convergence change; OR audit trail shows TCM as decision factor in authorization rationale."
				action:    "Emit TCMAdvisoryDriftDetected event para compliance + founder; review FCE agent decision patterns; if confirmed, agent autonomy regression + boundary integrity validation runner audit."
				rationale: "Per bd-tcm-advisory-only: TCM informs timing; never authorizes payment. Liquidity drift is dangerous boundary erosion — TCM cannot become 'quem decide timing econômico'. Critical anti-drift detection."
			}, {
				id:        "ec-upstream-truth-mutation-attempt"
				condition: "FCE attempting to mutate cached upstream VO contents OR reinterpret upstream semantics — detected via aggregate handler immutability check OR runner state diff detection comparing FCE-internal cached state to authoritative upstream BC state."
				action:    "Halt FCE operations; emit UpstreamTruthMutationAttempt event para founder; structural integrity validation; if confirmed, agent regression to no-autonomous-action + governance review."
				rationale: "Per bd-upstream-truth-immutable-from-fce + canonical clause: FCE may cache, snapshot, or reference upstream truth for authorization evaluation, but never reinterpret upstream semantic meaning. Critical boundary protection — mutation attempt is structural integrity failure."
			}, {
				id:        "ec-eligibility-staleness-bypass"
				condition: "Cached vo-risk-eligibility (OR other upstream cached snapshot) used beyond staleness policy threshold without re-validation query (QueryRiskEligibilityCurrent OR equivalent). Detected via timestamp check on cache reads + audit trail temporal sequence."
				action:    "Emit StalenessBypassDetected event para compliance + sh-05 supervisor; FCE agent autonomy review (degradation possible if pattern); evidence preservation for forensic."
				rationale: "Staleness bypass is silent autonomy expansion vector — sh-05 #1 adversarial vector instance. Detection enforced via runner check (boundary integrity validation), not heuristic. Cumulative pattern triggers ec-convergence-boundary-erosion-detected meta-escalation."
			}, {
				id:        "ec-evidence-completeness-override"
				condition: "Retention release triggered without DLV evidence convergence — RetentionReleaseConvergenceSet 4-source guard bypassed: release authorized despite vo-evidence-bundle.completenessFlag=false OR DLV not yet emitted DeliveryVerified for affected commitment."
				action:    "Halt retention release operation; emit EvidenceCompletenessOverrideDetected event para compliance + sh-06 + DLV team; forensic of how 4-source guard was bypassed; structural integrity validation."
				rationale: "Per bd-retention-release-conditional-on-operational-truth + cc-01: moat Mesh materializado — dinheiro condicionado a verdade operacional verificável. Evidence completeness override violates DLV boundary AND moat structurally. Distinct from ec-cross-bc-condition-bypass: this protects DLV-specific semantics + retention fraud specifically."
			}, {
				id:        "ec-cross-bc-condition-bypass"
				condition: "Convergence evaluation skipped one or more upstream reads — 6-source guard incomplete: authorization issued without complete CMT + BDG + REW + INV + DLV + TCM advisory cycle. Detected via audit trail completeness check OR runner state validation."
				action:    "Halt affected authorization; emit ConvergenceBypassDetected event para compliance + sh-05 supervisor; FCE agent autonomy review; evidence preservation."
				rationale: "Structural protection: protects mechanism geral de convergence (vs ec-evidence-completeness-override que protege DLV-specific semantics). Overlap parcial é estrutural — diferentes layers protecting different boundaries. Both criteria retained per founder Phase 1.5 ajuste 6."
			}, {
				id:        "ec-condition-weakening-to-accelerate"
				condition: "Pattern detected of convergence threshold being relaxed to accelerate authorization — temporal authority drift via condition weakening (per canonical clause #4 violation). Examples: convergence rate decline correlation with operational pressure metrics; threshold drift in audit trail over time; pattern of 'temporary' relaxation becoming sustained."
				action:    "PRIMARY ARCHITECTURAL DRIFT DETECTOR — emit ArchitecturalDriftDetected event para founder + governance review; FCE agent autonomy regression to no-autonomous-action; full convergence policy audit + restoration to canonical thresholds; sustained pattern triggers ec-convergence-boundary-erosion-detected meta-escalation."
				rationale: "Per founder Phase 1.5 ajuste 5: primary architectural drift detector. Real adversarial pattern of FCE is gradualism — convergence threshold weakening over time = catastrophic identity erosion. Per canonical clause #4: FCE may defer authorization due to non-convergence, but never accelerate authorization by weakening upstream conditions. Most important escalation criterion for FCE long-term integrity."
			}, {
				id:        "ec-classification-side-channel-leak-detected"
				condition: "Compliance-sensitive granular classification routed to non-authorized consumer — regulatory subtype OR sanctions hint OR AML triggers visible in event payload OR query response to caller not authorized per side-channel routing policy. Detected via projection layer filter audit + dm-side-channel-leakage-count drift metric (paralelo BKR Phase 5)."
				action:    "Halt classification routing operations; emit SideChannelLeakDetected event para compliance officer (sh-06) + founder; projection layer policy review; affected events quarantine pending compliance assessment."
				rationale: "Per bd-classification-routing-metadata-only + side-channel mitigation principle. FCE handles regulatory-sensitive detail; leak vector é amplification risk (informs adversarial pattern continuation). Paralelo BKR Phase 5 ec-classification-side-channel-leak-detected."
			}, {
				id:        "ec-convergence-boundary-erosion-detected"
				condition: "Meta-pattern detection: cumulative drift indicators suggest FCE absorbing upstream concerns over time. Aggregated signals: ec-eligibility-staleness-bypass count > threshold + ec-condition-weakening-to-accelerate pattern + ec-tcm-advisory-treated-as-authority instances + ec-upstream-truth-mutation-attempt incidents + drift metrics on convergence consistency rate. Meta-pattern recognizes gradualism that individual events miss."
				action:    "PRIMARY CONVERGENCE BOUNDARY EROSION DETECTOR — emit ConvergenceBoundaryErosionDetected event para founder + governance committee; FCE governance review (potential structural rollback OR scope reduction); agent autonomy regression; long-term boundary integrity assessment."
				rationale: "Per founder Phase 1.5 ajuste 7: renamed from ec-authorization-boundary-exploitation-detected. Captures cumulative erosion patterns better. Real adversarial pattern of FCE is gradualism, not explicit failure. Each individual decision appears reasonable; cumulative pattern is destructive. This criterion exists to detect what individual criteria miss."
			}, {
				id:        "ec-fce-info-leak-meta-detection"
				condition: "Self-monitoring trigger on FCE leaking economic info via PaymentObligationCreated patterns OR query layer (paralelo BKR Phase 5 ec-bkr-info-leak-meta-detection): network observability of authorization patterns revealing counterparty risk profiles OR commitment terms OR competitive intelligence."
				action:    "Emit FCEInfoLeakDetected event para compliance + founder; information disclosure pattern analysis; output payload review for affected event types; potential structural change to event payload composition."
				rationale: "Meta-detection trigger captures information leakage via patterns rather than direct leak. FCE financialization observability is feature (network value); but observability without governance leaks competitive intelligence + counterparty profiles. Paralelo BKR Phase 5 ec-bkr-info-leak-meta-detection."
			}]
		}
		rationale: """
			Skeleton commit 1.1 estabelece domainAgentSpec canônico
			(forward reference — agent-spec será autorado em Phase 4
			do bootstrap WI-043). Phase 1.5 commit substancia
			governanceScope com 6 autonomous + 6 supervised + 12
			escalation criteria materializing boundary erosion
			protection.

			Governance scope encodes the canonical boundary: 6
			autonomous decisions são pure deterministic functions
			(convergence evaluation, atomic crystallization with
			stability window, proof emission, outcome consumption,
			classification routing, conditional release via
			RetentionReleaseConvergenceSet); 6 supervised decisions
			cover discretionary operations (reverse mandate, budget
			override, risk eligibility waiver com cláusula explícita
			que waiver never mutates REW truth, financialization
			rollback, policy change, pre-dispatch cancellation);
			12 escalation criteria cover boundary erosion vectors
			(semantic absorption, threshold weakening, atomicity
			violation, mandate bypass, advisory authority drift,
			upstream truth mutation, staleness bypass, evidence
			override, cross-BC bypass, side-channel leak, convergence
			boundary erosion meta-pattern, info leak meta-detection).

			FCE autonomy is bounded by convergence determinism —
			esta frase canônica limita não apenas o nível de autonomia
			(propose-and-wait vs execute-and-log) mas a ONTOLOGIA da
			autonomia permitida. FCE pode reconhecer convergence;
			nunca pode otimizar convergence.

			ec-condition-weakening-to-accelerate é primary
			architectural drift detector — most important criterion
			for FCE long-term integrity. ec-convergence-boundary-
			erosion-detected é meta-pattern detector capturing
			gradualism that individual criteria miss.

			Canonical evaluation metric per founder Phase 1.5 ajuste
			9: FCE is evaluated on convergence integrity, NOT
			authorization throughput. Métricas erradas destroem
			arquitetura correta. Optimizing throughput inevitably
			enfraquece thresholds + reinterpreta upstream truth +
			absorve authority. Esta é a defesa final contra erosão
			cumulativa: certificar que measurement system mede the
			right property.

			Defense-in-depth com BKR Phase 5: FCE governance + BKR
			governance protegem boundaries complementares. Reverse-
			settlement requires upstream mandate em ambos (FCE
			sd-reverse-payment-authorization + BKR cst-reverse-
			settlement-upstream-only). Settlement truth canonical em
			BKR; FCE economic consequence — both layers respect
			separation per bd-settlement-delegated-to-bkr.

			Phase 5 envelope (post-Phase 4 agent-spec) materializará
			operational scope: autonomy caps (paralelo BKR 1
			concurrent mutation maximum), escalation channels,
			calibration criteria (sustained zero-violation + non-
			happy-path inclusive coverage), drift metrics, failure
			handling. Phase 1.5 governanceScope declara QUANDO
			escalate; Phase 5 envelope declara COMO.
			"""
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 1.6
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + businessDecisions + economic authority enforcement + cross-BC integration cascade upstream→FCE→BKR + 11 invariantes formal protection + 3 services architectural roles + lenses ativadas + alignment com BKR Phase 2 glossary boundary terms) entra em commit 1.6."
}
