package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// bdg-domain-model.cue — Structural checks para BDG domain-model.
// Per ADR-080: kind 'domain-invariant' unifica filesystem + semantic
// enforcement. 7 invariants do contexts/bdg/domain-model.cue declarados
// como garantias com limites explícitos.
//
// WI-084 SÉTIMA APPLICATION DISCAP-GUIDED forward authoring (per
// ADR-086 + PG patch WI-076; follows CMT WI-079 + DLV WI-080 + SSC
// WI-081 + CTR WI-082 + P2P WI-083; retroactive INV WI-077 + REW
// WI-078).
//
// BDG identidade epistemológica:
// **BDG is a deterministic budgetary commitment gate; it never
// executes payment nor reallocates between cost centers.**
//
// BDG severity tier ALTO: Gate de Cobertura é foundation econômica
// da rede; sem ele, compromissos progridem sem lastro orçamentário
// (inadimplência programática); Lei 12.846 anti-corruption audit
// retention (5y); Bacen orçamentário compliance; numerical integrity
// de Saldo Disponível = Limite − Σ(comprometimentos ativos) sustenta
// cap-04 audit trail composto.
//
// Coverage distribution (7 checks):
// - 2 schema-enforced + runtime (04/05) — T/T/T (NEGATIVO constraints
//   structural absence build-time enforceable)
// - 5 runtime-required com runtimeGap declarado canonicamente
//   (01/02/03/06/07)
// - All 7 com validation-time advisory (audit + cross-instance lint)
//
// BDG shape: **resource-allocation-gate + cross-BC-trigger-heavy +
// 2 NEGATIVO constraints + numerical-integrity-sensitive**:
// - L1: 7 rules (presença em todas)
// - L2: 5 rules (01/02/03/06/07) — cross-field gates
// - L3: 5 rules (01/02/03/06/07) — cross-BC CMT + cost-center +
//   Alçada external config + BudgetCommitmentId + CommitmentId
//   resolution
// - L4: 4 rules (04/05/06/07) — 2 NEGATIVOS + write-once + state
//   transition discipline
// - L5: 2 rules (01/03) — Alçada external config freshness
// - L6: 0 rules ABSENT — BDG NÃO interpreta significado; aplica
//   gate determinístico (paralelo P2P + CTR)
// - L7: 2 rules (01/03) — Gate + Alçada autonomous-vs-supervised scope
// - RE-VAL: 4 rules (01/03/06/07) — Alçada drift + numerical drift +
//   idempotência drift (strong defense pattern paralelo CTR RE-VAL
//   dominant; mas aqui por numerical integrity reasons distintas)
//
// 6 layers ativos + RE-VAL orthogonal dimension (RE-VAL NÃO é layer;
// é dimensão temporal de revalidação per ADR-086 D7).
//
// BDG distinct shape vs 7 BCs antes autorados pos-DISCAP:
// - INV: L1/L2/L4 (structural-local baseline)
// - CMT: L1+L2+L3+L4+L5+L6+L7 — cross-BC mid-band
// - DLV: 8 layers (L2 dominant) — structural-rich bridge
// - SSC: 8 layers (L7 dominant) — semantic+cross-BC+anti-Goodhart
// - CTR: 6 layers + RE-VAL (L4+RE-VAL dominant) — versioning-heavy
//   contractual
// - REW: L5/L6/L7 (semantic-contextual)
// - P2P: 6 layers + RE-VAL (L1 dominant, L6 absent, **1 NEGATIVO**)
//   execution-under-pre-validated-authority
// - BDG (this): 6 layers + RE-VAL (L1 dominant, balanced L2/L4, L6
//   absent, **2 NEGATIVOS**, RE-VAL strong) — resource-allocation-
//   gate + numerical-integrity-sensitive
//
// **NEGATIVO constraint shape CEMENTED upstream pattern**: 2 BCs
// (P2P + BDG) com 3 NEGATIVO rules totais materializando shape
// pattern transferable. P2P sc-p2p-04 (anti-mini-NIM via
// QueryParticipantStatus prohibition) validated as upstream pattern;
// BDG sc-bdg-04 (anti-mini-FCE/TCM via cash/payment query prohibition)
// + sc-bdg-05 (anti-realloc via reallocation command prohibition)
// cement pattern empirically in 2 BCs com semânticas distintas.
//
// NEGATIVO pattern naming convention (paralelo P2P sc-p2p-04):
// - **forbidden capability acquisition invariant**
// - **absence itself is the invariant**
// - **dependency prohibition is enforceable structure**
// - **prevention of operational authority expansion** (BDG variant;
//   P2P era "epistemic authority expansion")
// - **blast-radius containment** + **prevents convergence toward a
//   financial super-aggregate BC with mixed authority domains** (BDG
//   addition per founder ajuste Section 2)
//
// L8 NÃO invocado — existing ladder sufficient. BDG pressure não
// revelou new layer (resource-allocation-gate determinístico SEM
// adversarial-physical-evidence).
//
// Behavioral non-applicability discipline (per adr-086 D6):
// BDG domain-model 7 invariants são TODAS structurally enforceable.
// Casos limítrofes:
// - inv-04 + inv-05 (2 NEGATIVOS): declarações de ausência —
//   structurally enforceable via dependsOnAggregateState absence +
//   operationalScope linting + commands absence + autonomousDecisions
//   absence + workflows absence + policies absence
// - inv-06 + inv-07 (numerical integrity + idempotência): drift
//   detection over time é structurally enforceable via projection +
//   RE-VAL periodic audit comparing aggregate state vs derived
//   calculations
//
// Forbidden patterns são state/property prohibitions (não actions —
// per founder lint pattern).
//
// Note grandfathered name (per founder ajuste Section 2 #5):
// sc-bdg-07 title reflete GLOBAL uniqueness semantics; rule.invariantId
// referencia domain-model code "inv-commitment-id-uniqueness-per-cost-
// center" (grandfathered). Domain-model rename para alinhar code com
// global semantics é candidate WI-085 (semantic change requires ADR
// per CLAUDE.md).

structuralChecks: "sc-bdg-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-bdg-01"
	title:        "Coverage Gate Deterministic (RECTOR) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhum compromisso recebe BudgetApproved sem que Gate de Cobertura tenha verificado em sequência: (1) Saldo Disponível em Centro de Custo identificado é suficiente para o valor solicitado; (2) valor está dentro da Alçada do ator que autoriza. Falha em qualquer step bloqueia aprovação. **Coverage gate = conjunction of budget coverage + authority threshold, NOT two independent approvals.**

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: Gate execution audit trail present antes de BudgetApproved emission
		- L2 CROSS-FIELD: Saldo + Alçada conjunction (Saldo Disponível ≥ amount AND amount ≤ Alçada threshold)
		- L3 RESOLVABLE CONTRACT: cross-BC CommitmentId resolvable to CMT aggregate state
		- L5 FRESHNESS HEURISTIC: Alçada external config vigente at decision time (Alcada-table.vigentFrom ≤ approvedAt < Alcada-table.vigentTo)
		- L7 DECISION CONTEXT: Gate scope determines autonomous (Alçada satisfied) vs supervisedDecision (approve-budget-out-of-alcada) authorization path

		Layers non-applicable: L2.5, L4, L6
		Non-applicability rationale: sem adoption proof binding; Gate é point-in-time NÃO versioned; sem interpretation coherence — Gate é determinístico structural conjunction.

		RE-VAL: Yes — Alçada table drift via external config update sync; **authoritative external config supersedes cached projection** (precedence epistemológica paralelo P2P sc-p2p-01 RE-VAL); periodic audit detects stale Alçada threshold creating false autonomy expansion.

		War-game evidence (per adr-086 D5):
		Agente aprova budget sem Gate execution audit trail OR Gate marcado approved=true com step F (partial approval state OR fallback approve OR step skipped) — BudgetApproved fires sem lastro; DLV/INV/FCE consumem BudgetApproved como hard binding para progredir; cascade econômica progride sem cobertura orçamentária real; inadimplência programática emerge em volume; Lei 12.846 audit gap (5y retention sem fonte canônica de verificação de cobertura); regulator probe expõe inability to demonstrate deterministic gate enforcement.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-coverage-gate-deterministic"
		assertion: """
			∀ BudgetApproved event B for CommitmentId C:
			  ∃ Gate(C) execution audit record ∧
			  Gate(C).step1_balance: CostCenter(C.costCenterId).availableBalance ≥ C.amount ∧
			  Gate(C).step2_alcada: C.amount ≤ Alcada(C.approvedBy).threshold ∧
			Bidirectional iff (eliminates shortcut prevention):
			  Gate(C).approved = true ⇔ Gate(C).step1_balance = true ∧ Gate(C).step2_alcada = true
			(no partial approval states; no implicit fallback approve;
			no 'step skipped but approved=true')
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Gate execution sequence runtime; Saldo derivation from event log + Alçada external config lookup runtime. CUE não enforce cross-instance state derivation NEM external config resolution."
			enforcedBy:  "aggregate guard pre-emit BudgetApproved (refuse emission absent Gate audit trail OR step F) + Alçada external config resolver + Saldo derivation algorithm (Limite − Σ ativos) + validation-time lint cross-instance + RE-VAL periodic Alçada audit cross-validating external config vigente at decision time (authoritative external config supersedes cached projection)"
		}
		forbidden: [
			"BudgetApproved emitted WITHOUT Gate execution audit trail",
			"Gate marked approved=true WITH step1_balance=F (insufficient balance)",
			"Gate marked approved=true WITH step2_alcada=F (alcada exceeded sem supervisedDecision)",
			"Gate skipping step2_alcada when step1_balance passes (treating as 2 independent approvals)",
			"implicit fallback approve OR partial approval states",
			"Alçada lookup bypassing vigência check (stale config consumption)",
		]
	}
	errorMessage: "domain-invariant inv-coverage-gate-deterministic: BudgetApproved sem Gate determinístico OR Gate step conjunction violation. **Coverage gate = conjunction of budget coverage + authority threshold, NOT two independent approvals.** Verifique Gate execution audit trail + step1_balance AND step2_alcada conjunction (Gate.approved = true ⇔ step1_balance ∧ step2_alcada bidirectional iff)."
	rationale:    "Invariante RECTOR de BDG per bd-coverage-as-invariant. P10 gate determinístico. **Coverage gate = conjunction of budget coverage (Saldo Disponível) + authority threshold (Alçada), NOT two independent approvals** — gate único conjunto evita drift conceitual onde steps poderiam ser tratados independentemente. Bidirectional iff em assertion (per founder ajuste Section 2 #1) elimina shortcut prevention: partial approval states + implicit fallback approve + 'step skipped but approved=true' all blocked structurally. L3 cross-BC CMT resolution + L5 Alçada freshness + L7 decision context scope."
}

structuralChecks: "sc-bdg-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-bdg-02"
	title:        "Cost Center Required (deterministic identification) domain invariant"
	artifactType: "domain-model"
	description: """
		Toda Aprovação Orçamentária registra Comprometimento contra exatamente um Centro de Custo identificado e válido. Compromissos cujo Centro de Custo aplicável não pode ser determinado deterministicamente são bloqueados na entrada — agente solicita esclarecimento ou escala.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: costCenterId field populated em BudgetApproved + Comprometimento
		- L2 CROSS-FIELD: costCenterId valid + identification determinístico per as-bdg-1 (cost-center identification from CMT scope is deterministic, NOT ambiguity-tolerant)
		- L3 RESOLVABLE CONTRACT: costCenterId resolves to existing active CostCenter aggregate (intra-BDG resolution)

		Layers non-applicable: L2.5, L4, L5, L6, L7
		Non-applicability rationale: sem adoption proof binding; sem versioning (CostCenter lifecycle é governance externa); cost-center existence é binary NÃO freshness window; sem interpretation; cost center identification é structural NÃO decision context scope.

		RE-VAL: No (cost-center existence é structural snapshot; as-bdg-1 determinism é runtime gate).

		War-game evidence (per adr-086 D5):
		as-bdg-1 (identificação determinística de Centro de Custo a partir do escopo CMT) invalidada — escopo CMT ambíguo gera identificação heurística por agente; cost-center inferred via fuzzy match; comprometimentos ad-hoc agregados em cost-centers errados; controle orçamentário se dilui em agregações sem fonte canônica; supervisor não detecta drift até auditoria periódica (cc-03 fica comprometida); regulator probe expõe inconsistent cost-center allocation patterns.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-cost-center-required"
		assertion: """
			∀ BudgetApproved event B:
			  B.costCenterId ≠ ∅ ∧
			  ∃ CostCenter cc : cc.costCenterId = B.costCenterId ∧
			  cc.active = true ∧
			  cost-center identified deterministically per as-bdg-1
			    (from CMT commitmentScope; NOT heuristic fuzzy match)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Field presence é build-time T mas cross-instance CostCenter existence resolution + as-bdg-1 deterministic identification é runtime."
			enforcedBy:  "aggregate guard pre-approval (refuse cmd-approve-budget absent valid costCenterId resolvable + as-bdg-1 deterministic identification audit) + validation-time lint cross-instance"
		}
		forbidden: [
			"BudgetApproved WITH costCenterId=∅",
			"BudgetApproved WITH costCenterId pointing to non-existent CostCenter",
			"BudgetApproved WITH costCenterId pointing to inactive CostCenter (cc.active=false)",
			"cost-center identification via fuzzy match OR heuristic bypassing as-bdg-1 determinism",
		]
	}
	errorMessage: "domain-invariant inv-cost-center-required: BudgetApproved sem Centro de Custo válido identificado deterministicamente — costCenterId=∅ OR não resolvível OR identificação heurística bypassing as-bdg-1. Bloquear na entrada; agente solicita esclarecimento ou escala via supervisedDecision."
	rationale:    "Materializa bd-cost-center-as-sot. as-bdg-1 (identificação determinística) é premissa. L3 adicionado per founder ajuste Section 1 #2: costCenterId valid implica resolver centro de custo existente — não apenas field populated. Sem unidade canônica de comprometimento, controle orçamentário se dilui em agregações ad-hoc."
}

structuralChecks: "sc-bdg-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-bdg-03"
	title:        "Alcada Respected (autonomous-vs-supervised authorization scope) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhuma Aprovação Orçamentária autorizada autonomamente por agente excede a Alçada do agente conforme tabela vigente. Aprovação fora de Alçada é supervisedDecision (approve-budget-out-of-alcada) que requer autorização de supervisor humano com binding causal explícito ao commitment + threshold exceeded.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: Alçada check audit trail present antes de BudgetApproved
		- L2 CROSS-FIELD: amount + Alçada threshold consistency (amount ≤ threshold for autonomous; amount > threshold ⇒ SupervisionApproval required)
		- L3 RESOLVABLE CONTRACT: Alçada external config table resolvable (table reference resolves runtime; per founder ajuste Section 1 #3 — Alçada é external config; precisa resolução contratual)
		- L5 FRESHNESS HEURISTIC: Alçada vigente at decision time (Alcada-table.vigentFrom ≤ approvedAt < Alcada-table.vigentTo)
		- L7 DECISION CONTEXT: Alçada DEFINES authorization scope (autonomous-by-agent vs supervisedDecision approve-budget-out-of-alcada)

		Layers non-applicable: L2.5, L4, L6
		Non-applicability rationale: sem adoption proof binding; sem versioning core (Alçada table versioning handled externally por governance financeira); sem interpretation — Alçada é structural threshold.

		RE-VAL: Yes — Alçada external config drift; table update sync staleness creates false autonomy expansion; periodic audit cross-validates BudgetApproved decisions vs Alcada table vigente at decision time (authoritative external config supersedes cached projection).

		War-game evidence (per adr-086 D5):
		Agente aprova fora de Alçada sem supervisedDecision OR SupervisionApproval reused sem binding causal específico — mech-agent-gate violation + P10 violation; cascade autoridade implícita aumenta silenciosamente; supervisor pode ter aprovado outro commitment + agente reusa stale approval; audit gap regulatório (Bacen + Lei 12.846); potencial corruption probe expõe pattern de pseudo-supervision.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-alcada-respected"
		assertion: """
			∀ BudgetApproved B autorizado autonomamente por agente:
			  ∃ Alcada-table-entry a : a.actorRef = B.approvedBy ∧
			  B.amount ≤ a.threshold ∧
			  Alcada-table.vigentFrom ≤ B.approvedAt < Alcada-table.vigentTo ∧
			∀ B WITH amount > Alcada(B.approvedBy).threshold:
			  ∃ SupervisionApproval s WITH explicit binding:
			    s.references(commitmentId = B.commitmentId) ∧
			    s.action = 'approve-budget-out-of-alcada' ∧
			    s.alcadaThresholdExceeded = true ∧
			    s.thresholdAtDecisionTime = Alcada(B.approvedBy).threshold
			(no SupervisionApproval unrelated; no stale approval reused;
			no approval sem binding causal explícito)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Alçada external config table resolution + SupervisionApproval binding verification runtime; CUE não enforce external config nem cross-instance approval reference resolution."
			enforcedBy:  "aggregate guard pre-emit BudgetApproved (refuse autonomous approval absent Alçada validation OR refuse out-of-alcada absent SupervisionApproval with explicit binding) + Alçada external config resolver + SupervisionApproval reference binding check + RE-VAL periodic Alçada audit (authoritative external config supersedes cached projection)"
		}
		forbidden: [
			"BudgetApproved autonomamente WITH amount > Alcada(approvedBy).threshold (sem supervisedDecision)",
			"BudgetApproved consulting Alçada table sem vigência check (stale config consumption)",
			"Alçada external config not resolvable runtime (table reference broken)",
			"SupervisionApproval reused sem binding causal específico ao commitmentId atual",
			"SupervisionApproval unrelated (approval for different commitmentId being reused)",
			"approval sem binding causal explícito (no alcadaThresholdExceeded=true marker)",
		]
	}
	errorMessage: "domain-invariant inv-alcada-respected: BudgetApproved autonomamente fora de Alçada OR SupervisionApproval sem binding causal explícito ao commitment + threshold exceeded. mech-agent-gate violation + P10 violation. Verifique Alçada vigente check + SupervisionApproval.references(commitmentId, alcadaThresholdExceeded=true) explicit binding."
	rationale:    "Materializa autonomousDecision evaluate-alcada-deterministic + supervisedDecision approve-budget-out-of-alcada. L3 adicionado per founder ajuste Section 1 #3 — Alçada é external config (tabela vive fora do BDG BC); precisa resolução contratual. Explicit binding em SupervisionApproval (per founder ajuste Section 2 #2): SupervisionApproval.references(commitmentId, alcadaThresholdExceeded=true) elimina drift causal (unrelated approval + stale reuse + approval sem binding). Drift causal é exatamente o tipo que DISCAP combate."
}

structuralChecks: "sc-bdg-04": artifact_schemas.#StructuralCheck & {
	id:           "sc-bdg-04"
	title:        "Commitment Not Payment (NEGATIVO; forbidden capability acquisition) domain invariant"
	artifactType: "domain-model"
	description: """
		Aprovação Orçamentária NUNCA consulta disponibilidade de caixa em TCM nem dispara execução de pagamento em FCE. Comprometimento é prospectivo (orçamento reservado); pagamento é efetivo (caixa executado) — operam em SoTs distintos com cadências distintas. Shape novo paralelo P2P sc-p2p-04: **forbidden capability acquisition invariant** — NÃO declara presença de comportamento MAS prohibition de capability acquisition.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: absence enforcement at artifact level (BDG artifacts checked for forbidden capabilities)
		- L4 VERSIONED: forbidden patterns NEGATIVO — 5 declarações de ausência (dependsOnAggregateState + operationalScope + workflows + commands + policies)

		Layers non-applicable: L2, L2.5, L3, L5, L6, L7
		Non-applicability rationale: declarações de ausência são independentes (sem cross-field); CONSTRAINT NEGATIVO — ausência de contract NÃO presença (L3 inversion); sem freshness drift (structural absence permanent); interpretation absent; decision context não scaling porque AUSÊNCIA é total.

		RE-VAL: No — NEGATIVO constraint structural absence permanent (não drift temporal; absence is the invariant — não evolui).

		War-game evidence (per adr-086 D5):
		BDG adiciona QueryCashAvailability OR cmd-execute-payment "por conveniência" — BDG vira mini-TCM/mini-FCE duplicando responsabilidade; drift entre BDG comprometimento prospectivo + TCM caixa efetivo + FCE pagamento executado emerge; BC Deus financeiro composto convergence; cap-04 audit trail composto se confunde (qual SoT é canônico para cash position?); regulator probe expõe inconsistent financial accountability.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-commitment-not-payment"
		assertion: """
			∀ BDG artifacts:
			  BDG.aggregates.*.dependsOnAggregateState ∌ {bc: tcm | bc: fce} ∧
			  BDG.agent-spec.operationalScope ∌ {QueryCashAvailability | QueryPaymentStatus} ∧
			  BDG.workflows ∌ {payment-execution-step | cash-availability-check-step} ∧
			  BDG.commands ∌ {cmd-execute-payment | cmd-check-cash-availability} ∧
			  BDG.policies ∌ on-payment-required-react
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Schema-level absence declarations enforceable build-time via CUE schema linting; validation-time cross-artifact audit catches drift; runtime session inspection defense-in-depth."
			enforcedBy:  "CUE schema declares BDG.aggregates.*.dependsOnAggregateState absence check (TCM/FCE not in cross-BC deps) + agent-spec operationalScope linter (QueryCashAvailability/QueryPaymentStatus excluded) + workflow linter (no payment-execution/cash-check steps) + commands catalog absence enforcement + policies absence + agent-spec constraint cst-no-cash-query"
		}
		forbidden: [
			"BDG.aggregates.*.dependsOnAggregateState pointing to TCM OR FCE (NEGATIVO state prohibition)",
			"BDG.agent-spec.operationalScope ⊇ {QueryCashAvailability | QueryPaymentStatus} (NEGATIVO property prohibition)",
			"BDG.workflows containing payment-execution-step OR cash-availability-check-step (NEGATIVO state prohibition)",
			"BDG.commands declaring cmd-execute-payment OR cmd-check-cash-availability (NEGATIVO capability prohibition)",
			"BDG.policies declaring on-payment-required-react (NEGATIVO event consumer prohibition — FCE events not consumed)",
		]
	}
	errorMessage: "domain-invariant inv-commitment-not-payment: BDG artifact declara capability/dependency PROIBIDA a TCM/FCE — BDG NÃO consulta caixa (TCM single-owner) NEM executa pagamento (FCE single-owner). Remove capability/dependency. **Absence itself is the invariant; dependency prohibition is enforceable structure.**"
	rationale:    "**Forbidden capability acquisition invariant** (per founder ajuste Section 2 #3 paralelo P2P sc-p2p-04). **Absence itself is the invariant.** **Dependency prohibition is enforceable structure.** Materializa **prevention of operational authority expansion**: BDG NÃO adquire capability de consultar caixa (TCM single-owner) nem executar pagamento (FCE single-owner). **Blast-radius containment**: **Prevents convergence toward a financial super-aggregate BC with mixed authority domains** (per founder ajuste Section 2 #3 — pattern transferable upstream value). Materializa bd-commitment-not-payment fronteira inviolável."
}

structuralChecks: "sc-bdg-05": artifact_schemas.#StructuralCheck & {
	id:           "sc-bdg-05"
	title:        "Allocation Not Treasury (NEGATIVO; forbidden capability acquisition) domain invariant"
	artifactType: "domain-model"
	description: """
		BDG NUNCA realoca orçamento entre Centros de Custo autonomamente. Ajustes de Limite por Centro de Custo (aumento ou redução) são supervisedDecisions (adjust-cost-center-limit) com justificativa documentada — não há autonomia operacional para reallocate. Shape novo paralelo P2P sc-p2p-04 + BDG sc-bdg-04: **forbidden capability acquisition invariant**.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: absence enforcement at artifact level + cost-center limit adjustment classification check
		- L4 VERSIONED: forbidden patterns NEGATIVO — 4 declarações de ausência (commands + autonomousDecisions + policies + workflows) + 1 classification enforcement (cost-center limit adjustment ALWAYS supervisedDecision)

		Layers non-applicable: L2, L2.5, L3, L5, L6, L7
		Non-applicability rationale: declarações de ausência são independentes (sem cross-field); CONSTRAINT NEGATIVO — ausência (L3 inversion); sem freshness drift (structural absence permanent); interpretation absent; decision context não scaling porque AUSÊNCIA é total.

		RE-VAL: No — NEGATIVO constraint structural absence permanent.

		War-game evidence (per adr-086 D5):
		BDG adquire capability autonomous realloc OR on-cost-center-overdraft-auto-realloc policy materializada — decisão estratégica de diretoria financeira (planejamento anual + revisões trimestrais) capturada por agente operador; conflito de incentivos no agente (operação + calibragem misturadas); governance externa drift; ora-strategic-neglect violation; potencial corruption probe expõe inconsistent allocation authority.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-allocation-not-treasury"
		assertion: """
			∀ BDG artifacts:
			  BDG.commands ∌ cmd-reallocate-between-cost-centers ∧
			  BDG.agent-spec.autonomousDecisions ∌ realloc-between-cost-centers ∧
			  BDG.policies ∌ on-cost-center-overdraft-auto-realloc ∧
			  BDG.workflows ∌ realloc-step ∧
			∀ cost-center limit adjustment operation:
			  classification = supervisedDecision (adjust-cost-center-limit)
			  with documented justification
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Schema-level absence declarations enforceable build-time; validation-time cross-artifact audit catches drift; runtime session inspection enforces classification."
			enforcedBy:  "CUE schema declares BDG.commands absence (no cmd-reallocate) + agent-spec autonomousDecisions linter (no realloc-between-cost-centers) + policies absence + workflows absence + cost-center limit adjustment SEMPRE classified as supervisedDecision (adjust-cost-center-limit) per agent-spec governance"
		}
		forbidden: [
			"BDG.commands declaring cmd-reallocate-between-cost-centers (NEGATIVO capability prohibition)",
			"BDG.agent-spec.autonomousDecisions ⊇ {realloc-between-cost-centers} (NEGATIVO autonomy prohibition)",
			"BDG.policies declaring on-cost-center-overdraft-auto-realloc (NEGATIVO automation prohibition)",
			"BDG.workflows containing realloc-step (NEGATIVO state prohibition)",
			"cost-center limit adjustment classified as autonomousDecision (must be supervisedDecision)",
		]
	}
	errorMessage: "domain-invariant inv-allocation-not-treasury: BDG artifact declara capability/automation PROIBIDA de reallocation — BDG NÃO realoca autonomamente; ajustes de Limite SEMPRE supervisedDecisions (adjust-cost-center-limit). Decisão estratégica pertence à diretoria financeira. **Absence itself is the invariant; dependency prohibition is enforceable structure.**"
	rationale:    "**Forbidden capability acquisition invariant** (per founder ajuste Section 2 #3 paralelo P2P sc-p2p-04 + sc-bdg-04). **Absence itself is the invariant.** **Dependency prohibition is enforceable structure.** Materializa **prevention of operational authority expansion**: BDG NÃO adquire capability realloc autonomous — decisão estratégica pertence à diretoria financeira (planejamento anual + revisões trimestrais), não ao agente operador. **Blast-radius containment**: **Prevents convergence toward a financial super-aggregate BC with mixed authority domains** (per founder ajuste Section 2 #3). Materializa bd-allocation-not-treasury + ora-strategic-neglect."
}

structuralChecks: "sc-bdg-06": artifact_schemas.#StructuralCheck & {
	id:           "sc-bdg-06"
	title:        "Released Amount Matches Commitment (numerical integrity + conservation law) domain invariant"
	artifactType: "domain-model"
	description: """
		Liberação de Comprometimento devolve ao Saldo Disponível exatamente o valor previamente reservado pelo Comprometimento referenciado — nunca mais, nunca menos. Referência ao BudgetCommitmentId é obrigatória; liberações sem referência ou com valor divergente são bloqueadas. **Conservation law**: Σ(active commitments) + Σ(released commitments) must remain derivable without loss or duplication across transitions.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: BudgetCommitmentId reference required em release event
		- L2 CROSS-FIELD: releasedAmount = original commitment.amount exactly (numerical equality)
		- L3 RESOLVABLE CONTRACT: BudgetCommitmentId resolves to existing commitment entity em agg-cost-center registry
		- L4 VERSIONED: write-once amount immutability post-commit (release não muta commitment record — cria status transition active→released)

		Layers non-applicable: L2.5, L5, L6, L7
		Non-applicability rationale: sem adoption proof binding; L5 fora per founder ajuste Section 1 #4 — drift sobre tempo é RE-VAL audit não freshness window; sem interpretation; sem decision context scaling (numerical equality é structural).

		RE-VAL: Yes — numerical drift detection over time; Saldo Disponível = Limite − Σ(comprometimentos ativos) periodic audit; conservation law Σ(active) + Σ(released) coherence across transitions; manual DB repairs bypassing aggregate; migration drift; defense-in-depth contra aggregate guard bypass. Sustenta replay + audit + reconstruction + drift detection sem inflar para novo invariant.

		War-game evidence (per adr-086 D5):
		Release com releasedAmount divergente OR sem BudgetCommitmentId reference OR mutation of commitment.amount in-place — Saldo Disponível regride para snapshot inconsistente; divergências numéricas acumulam silenciosamente; cap-04 derivação se quebra (Limite − Σ ativos não bate); conservation law violada (active + released coherence perdida); replay determinism quebra; regulatory reconstruction Lei 12.846 (5y retention) torna-se impossível.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-released-amount-matches-commitment"
		assertion: """
			∀ BudgetCommitmentReleased event R:
			  R.budgetCommitmentId ≠ ∅ ∧
			  ∃ BudgetCommitment bc : bc.budgetCommitmentId = R.budgetCommitmentId ∧
			  R.releasedAmount = bc.amount (exactly; never more, never less) ∧
			  bc.amount immutable post-creation (write-once) ∧
			  bc.status transition active → released monotonic ∧
			Conservation law:
			  ∀ CostCenter cc:
			    Σ(active commitments of cc) + Σ(released commitments of cc)
			      remains derivable without loss or duplication across
			      transitions (no dropped records; no duplicated records;
			      no value mutation in-place)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cross-instance numerical equality + commitment resolution + conservation law verification runtime; CUE não enforce cross-instance state coherence build-time."
			enforcedBy:  "aggregate guard pre-release (verify BudgetCommitmentId resolves + releasedAmount = original amount + status active before transition) + persistence layer write-once constraint on commitment.amount + RE-VAL periodic numerical integrity audit (Saldo coherence + conservation law derivability + active/released cardinality consistency)"
		}
		forbidden: [
			"BudgetCommitmentReleased WITH releasedAmount ≠ original commitment.amount",
			"BudgetCommitmentReleased WITHOUT budgetCommitmentId reference",
			"mutation of commitment.amount post-creation",
			"state transition released → active (reversal — terminal status)",
			"silent commitment record drop OR duplication (conservation law violation)",
			"manual DB repair bypassing aggregate guard (write-once breach)",
		]
	}
	errorMessage: "domain-invariant inv-released-amount-matches-commitment: release com valor divergente OR sem BudgetCommitmentId reference OR commitment.amount mutated OR conservation law violada (active + released coherence perdida). Saldo Disponível regride inconsistente; cap-04 derivação broken. Verifique aggregate guard pre-release + write-once constraint + RE-VAL periodic numerical audit."
	rationale:    "Garante numerical integrity de Saldo = Limite − Σ ativos. L4 write-once amount immutability + status transition monotonic. **Conservation law** (per founder ajuste Section 2 #4): Σ(active commitments) + Σ(released commitments) must remain derivable without loss or duplication across transitions — sustenta replay + audit + reconstruction + drift detection sem inflar para novo invariant. RE-VAL essential (per founder ajuste Section 1 #4): drift sobre tempo é defense-in-depth audit catching manual repairs + migration patterns; L5 fora porque drift audit ≠ freshness window."
}

structuralChecks: "sc-bdg-07": artifact_schemas.#StructuralCheck & {
	id:           "sc-bdg-07"
	title:        "CommitmentId Global Uniqueness Active (idempotency) domain invariant"
	artifactType: "domain-model"
	description: """
		Cada CommitmentId tem no máximo um BudgetCommitment ativo (não liberado) registrado em BDG inteiro (global uniqueness across all CostCenters). Re-aprovação de um mesmo CommitmentId já com Comprometimento ativo é bloqueada — exigiria liberação prévia. Uniqueness é GLOBAL (não per-CostCenter) porque CommitmentId vem do CMT e representa unicidade econômica transversal — um compromisso bilateral só pode ter UMA reserva orçamentária ativa simultaneamente em toda a rede BDG.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: status field (active|released) populated em BudgetCommitment entity
		- L2 CROSS-FIELD: at most one ACTIVE BudgetCommitment per CommitmentId globally
		- L3 RESOLVABLE CONTRACT: commitmentId cross-BC reference resolves to CMT aggregate state (CommitmentId é CMT-issued canonical id)
		- L4 VERSIONED: status transition discipline monotonic (active → released; nunca released → active)

		Layers non-applicable: L2.5, L5, L6, L7
		Non-applicability rationale: sem adoption proof binding; L5 confirmadamente FORA per founder ajuste Section 1 #5 — 'active' depends only on status (active|released), NOT temporal expiry window; sem interpretation; uniqueness é structural NÃO decision context.

		RE-VAL: Yes — idempotência drift detection over time; race conditions concurrent approval; double-booking detection via periodic cardinality audit across all instances; defense-in-depth contra aggregate guard bypass (manual repair + migration patterns).

		War-game evidence (per adr-086 D5):
		Re-approval mesmo CommitmentId sem liberação prévia OR concurrent approval race producing 2 active simultaneously — 2 BudgetCommitments ativos para mesmo compromisso; comprometimento agregado contra CostCenter inflado; Saldo Disponível mostrado incorreto; cascade decisions baseadas em Saldo stale (P2P emite POs adicionais sob false capacity); regulatory probe expõe inability to demonstrate idempotency-by-construction; cap-04 audit trail composto se quebra (multiple reservations for same economic commitment).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-commitment-id-uniqueness-per-cost-center"
		assertion: """
			∀ CommitmentId C (issued by CMT):
			  count(BudgetCommitment bc where
			    bc.commitmentId = C ∧
			    bc.status = 'active'
			  ) ≤ 1 (globally across entire BDG state — all CostCenters) ∧
			  bc.status transition active → released monotonic (no reversal) ∧
			  C.commitmentId resolves to CMT aggregate state
			Global uniqueness rationale:
			  CommitmentId é CMT-issued canonical id; representa unicidade
			  econômica transversal — um compromisso bilateral só pode ter
			  UMA reserva orçamentária ativa simultaneamente em toda a rede
			  BDG (não per-CostCenter; global).
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cross-instance global cardinality enforcement requires runtime aggregate guard + persistence layer atomic operation + cross-aggregate audit; CUE não enforce cross-instance cardinality build-time."
			enforcedBy:  "aggregate guard pre-approval (verify no other active BudgetCommitment for same CommitmentId across all CostCenters before transition) + persistence layer atomic operation with global uniqueness check + RE-VAL periodic global cardinality audit catching drift via race/migration/manual repair"
		}
		forbidden: [
			"2+ BudgetCommitment entities WITH same commitmentId AND status='active' (anywhere in BDG state)",
			"re-approval mesmo CommitmentId sem liberação prévia",
			"status transition released → active (reversal)",
			"silent global uniqueness breach via direct DB mutation bypassing aggregate",
			"per-CostCenter uniqueness check treating semantics as local (semantic regression — uniqueness é global)",
		]
	}
	errorMessage: "domain-invariant inv-commitment-id-uniqueness-per-cost-center: 2+ BudgetCommitments ativos para mesmo CommitmentId em BDG state (global) OR re-approval sem liberação prévia OR per-CostCenter semantics regression. Uniqueness é GLOBAL (CommitmentId é CMT-issued canonical id; unicidade econômica transversal). Verifique aggregate guard global uniqueness check + persistence atomic operation + RE-VAL periodic global cardinality audit."
	rationale:    "Idempotência de aprovação ao nível de compromisso (paralelo CTR sc-ctr-01 single-active-version pattern). Title atualizado para refletir GLOBAL semantics (per founder ajuste Section 2 #5 Opção A): CommitmentId é CMT-issued canonical id; representa unicidade econômica transversal; um compromisso bilateral só pode ter UMA reserva orçamentária ativa simultaneamente em toda a rede BDG. **Note grandfathered name**: rule.invariantId referencia domain-model code 'inv-commitment-id-uniqueness-per-cost-center' (grandfathered name carries 'per-cost-center' suffix). Rule body do domain-model já diz 'em BDG' (global semantic correct). Domain-model rename para alinhar code com global semantics é WI-085 separado (semantic change requires ADR per CLAUDE.md). L5 confirmadamente FORA per founder ajuste Section 1 #5 — 'active' depends only on status, NOT temporal expiry. RE-VAL essential — drift patterns detectable apenas via periodic global cardinality audit."
}
