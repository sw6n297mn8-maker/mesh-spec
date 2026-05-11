package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// ssc-domain-model.cue — Structural checks para SSC domain-model.
// Per ADR-080: kind 'domain-invariant' unifica filesystem + semantic
// enforcement. 7 invariants do contexts/ssc/domain-model.cue declarados
// como garantias com limites explícitos (runtime-gap canonicalmente
// declarado quando runtimeRequired=true).
//
// WI-081 TERCEIRA APPLICATION DISCAP-GUIDED forward authoring (per
// ADR-086 Domain-Invariant Structural Check Authoring Protocol + PG
// patch WI-076). Pattern paralelo a CMT (WI-079) + DLV (WI-080); SSC
// é terceiro BC autorado FROM SCRATCH com protocol canonical aplicado.
//
// SSC severity tier ALTO: Lei 12.846 anti-corruption audit + supplier
// fairness + GOODHART VECTOR (fitness rules manipulation) + cross-BC
// NPM dependency heavy + adversarial probing surface (pool engineering).
//
// SSC tem 7 invariants vs DLV 14 — proportionally less em volume MAS
// peak semantic depth (anti-Goodhart + cross-BC + decision context
// authority). Cada rule defende contra vetores de manipulação
// específicos.
//
// Coverage distribution (7 checks):
// - 2 schema-enforced + runtime (02/04) — T/T/T (CUE schema declares
//   required fields + command handler validates)
// - 5 runtime-required com runtimeGap declarado canonicamente
//   (01/03/05/06/07)
// - All 7 com validation-time advisory (audit trail + cross-instance
//   lint + cross-BC reconciliation)
//
// Layer matrix demonstra DISCAP progressive ladder seletivo (per
// founder observation empirical validation):
// - L1: 6 rules (01/02/04/05/06/07) — structural-local presence
// - L2: 5 rules (01/02/04/05/06) — cross-field consistency
// - L3: 3 rules (01/03/07) — cross-BC NPM + fitness rules registry
//   resolution (Goodhart defense)
// - L4: 2 rules (01/07) — versioning (rules snapshot + temporal
//   anchoring)
// - L5: 2 rules (03/06) — re-validation freshness (cross-BC drift)
// - L6: 3 rules (01/04/07) — interpretation coherence (anti-Goodhart:
//   agent applies NOT interprets; rationale supports audit
//   reconstruction; decision under correct rule set)
// - L7 DOMINANT: 5 rules (02/03/04/05/06) — decision context authority
//   (decision type declaration; re-validation scope; rationale scope;
//   stakeholder communication scope; exception authority scope)
// - RE-VAL: 3 rules (03/06/07) — re-validation + drift detection +
//   manipulation pattern audit
//
// SSC distinct shape: **semantic+cross-BC+anti-Goodhart** com L7
// dominant (5/7 — confirma decision-context-heavy nature: SSC opera
// decision authority within bounded scopes per-rfq, per-supplier,
// per-rule-version).
//
// Comparação ladder cross-BCs (empirical validation):
// - INV: L1/L2/L4 (structural-local)
// - CMT: L1+L2+L3+L4+L5+L6+L7 (structural+cross-BC mid-band)
// - DLV: 7/8 layers (structural-rich + temporal/finality/replay bridge)
// - SSC: L1+L2+L3+L4+L5+L6+L7+RE-VAL — semantic+cross-BC+anti-Goodhart
//   com L7 dominant
// - REW: L5/L6/L7 forte (semantic-contextual)
//
// SSC e DLV têm mesma layer breadth (8 layers) MAS shapes distintas:
// DLV peak em L2 dominant (structural-rich); SSC peak em L7 dominant
// (decision context heavy). Validates progressive ladder per ADR-086
// D2 — não apenas mais campos, capture different epistemological
// pressures per BC.
//
// L8 NÃO invocado per founder anticipation: 'recommendation fairness /
// supplier fitness drift detection could pressure new layer if
// recurring pattern across multiple BCs — deixar empirical evidence
// acumular antes de canonizar'. SSC inv-07 captures Goodhart vector
// via L6 interpretation coherence + L3 contract resolution + L4
// versioning + RE-VAL — existing ladder sufficient.
//
// Behavioral non-applicability discipline (per adr-086 D6):
// SSC domain-model 7 invariants são TODAS structurally enforceable
// via runtime gate + snapshot embedding + audit reconstruction.
// inv-01 (decision-from-structured-signals) poderia parecer behavioral
// (agent discipline) MAS é structurally enforceable: runtime gate
// refuses decision sem fitness rule snapshot embedded + signals
// reference. Agent autonomy bounded structurally, não by-convention.
//
// Forbidden patterns são state/property prohibitions (não actions —
// per founder lint pattern).

structuralChecks: "sc-ssc-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-ssc-01"
	title:        "Decision From Structured Signals domain invariant"
	artifactType: "domain-model"
	description: """
		Toda decisão emitida (SourcingDecisionMade / PreferredSupplierDesignated / StrategicAwardCompleted) é resultado da aplicação de fitness rules versionadas (vo-fitness-rule-snapshot) sobre fitnessSignals estruturados. SSC NÃO interpreta signals nem infere reputation/performance — consume what other BCs (NPM, NIM, CTR) produce e estrutura what comes from RFQ. Anti-mini-NIM discipline: sem invariant, agent vira intérprete de signals e viola integridade do gate.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: structuredSignalsSnapshot + fitnessRuleSnapshot present em decision event
		- L2 CROSS-FIELD: decision references only declared structured signals (NO free-form signal source); decision content derives from declared snapshot references
		- L3 RESOLVABLE CONTRACT: signal refs resolve to NPM/NIM/CTR canonical sources (cross-BC contract); fitnessRuleSnapshot.versionId resolves to registered rule version
		- L4 VERSIONED: fitnessRuleSnapshot frozen at evaluation time (immutable per decision)
		- L6 DECISION↔INTERPRETATION COHERENCE: decision follows mechanical interpretation of declared signals via declared rules; agent applies NOT interprets (anti-mini-NIM)

		Layers non-applicable: L2.5, L5, L7
		Non-applicability rationale: invariant é structural+cross-BC+interpretation discipline; sem adoption proof binding, sem freshness drift (snapshot é immutable point-in-time), sem decision context scaling (decision context covered em sc-ssc-02/04).

		RE-VAL: N/A (snapshot immutability é point-in-time; once decision emitted, structurally fixed).

		War-game evidence (per adr-086 D5):
		Agent starts interpreting signals via inference — operational pressure for "smart" decisions; agent begins pattern matching on supplier names ("this supplier has good history with our org"); applies soft heuristics beyond declared fitness rules; structured rule application bypassed via inference; RECTOR invariant violated (BD deterministic-decision-from-structured-signals); downstream P2P/CTR consume decision that doesn't derive from declared rules; Lei 12.846 anti-corruption audit cannot reconstruct (decision NOT derivable from snapshots); agent autonomy creep into NIM territory (anti-mini-NIM).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-decision-from-structured-signals"
		assertion: """
			∀ decision event (SourcingDecisionMade | PreferredSupplierDesignated | StrategicAwardCompleted):
			  decision event contains structuredSignalsSnapshot
			∧ decision event contains fitnessRuleSnapshot
			∧ all signals referenced are from declared snapshot
			    (NO free-form signal source)
			∧ signal refs resolve to NPM/NIM/CTR canonical sources
			∧ fitnessRuleSnapshot.versionId resolves to registered rule version
			∧ decision content derives mechanically from rule application
			    over snapshot (agent applies NOT interprets)
			∧ no decision emitted via agent inference outside declared rules
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Snapshot embedding + cross-BC reference resolution + rule application discipline requires runtime gate. Build-time não pode validate rule application correctness em general; runtime emit handler MUST refuse decision sem snapshots embedded + sem signal refs resolving + sem rule application traced."
			enforcedBy:  "agent runtime gate (refuse decision sem fitnessRuleSnapshot + structuredSignalsSnapshot embedded) + emit handler validation (signal refs resolve to NPM/NIM/CTR canonical) + audit trail recording rule application path + validation-time lint cross-instance verifying decisions derivable from snapshots"
		}
		forbidden: [
			"decision event sem structuredSignalsSnapshot OR fitnessRuleSnapshot embedded",
			"agent interpreting signals via inference (pattern matching, soft heuristics, reputation guessing)",
			"decision content NOT derivable from rule application over declared snapshot",
			"free-form signal source bypassing declared snapshot",
			"signal refs pointing to non-existent OR non-canonical NPM/NIM/CTR sources",
		]
	}
	errorMessage: "domain-invariant inv-decision-from-structured-signals: decision detected sem snapshots embedded OR agent interpretation traces OR signals from non-canonical source. RECTOR invariant (BD deterministic-decision-from-structured-signals) violated — agent applies, NOT interprets (anti-mini-NIM). Verifique agent runtime gate + emit handler snapshot embedding + signal refs resolution NPM/NIM/CTR + audit trail rule application path."
	rationale:    "Materializa BD deterministic-decision-from-structured-signals (RECTOR invariant) + P10 (gates determinísticos validam, agentes recomendam) + anti-mini-NIM discipline. L6 captura interpretação coerência: decision follows mechanical rule application, NÃO agent inference. Coverage F/T/T: runtime gate é primary enforcer; validation-time lint catches divergences post-hoc."
}

structuralChecks: "sc-ssc-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-ssc-02"
	title:        "Decision Type Declared Upfront domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo evento de decisão emitido, deve existir requestedDecisionType declarado em cmd-open-rfq (requestedAt < rfqOpenedAt). Tipo do evento emitido (SourcingDecisionMade / PreferredSupplierDesignated / StrategicAwardCompleted) DEVE corresponder ao tipo declarado no aggregate. Mapeamento canônico: one-shot → SourcingDecisionMade; preferred-designation → PreferredSupplierDesignated; strategic-award → StrategicAwardCompleted. Anti-autonomy-creep: agente aplica regras, NÃO decide tipo de processo.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: requestedDecisionType field populated em cmd-open-rfq + decisionType field em aggregate
		- L2 CROSS-FIELD: emitted event type matches declared decisionType (mapping table consistency)
		- L7 DECISION CONTEXT: decisionType DEFINES authority scope of the process (one-shot vs preferred-designation vs strategic-award têm scopes distintos de stakeholder communication + downstream contract obligation)

		Layers non-applicable: L2.5, L3, L4, L5, L6
		Non-applicability rationale: invariant é timing + type consistency structural; sem semantic adoption binding, sem cross-BC contract resolution, sem version dependency (decisionType é declarado upfront, NÃO versioned), sem freshness drift, sem interpretation coherence step (mapping é binary).

		RE-VAL: N/A (timing constraint é point-in-time; once declared, immutable).

		War-game evidence (per adr-086 D5):
		Autonomy creep via post-hoc reclassification — RFQ opened as one-shot (single decision expected); during evaluation, supplier shows promise for ongoing relationship; agent emits PreferredSupplierDesignated instead of SourcingDecisionMade because "supplier shows long-term promise"; agent decides process type instead of applying it; downstream consumers (P2P/CTR) receive decision type they didn't expect; long-term contractual obligations triggered without bilateral expectation; audit trail confused (which process type was authoritative?); cascade autonomy creep — agent territoria expands silently.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-decision-type-declared-upfront"
		assertion: """
			∀ decision event:
			  ∃ cmd-open-rfq with requestedDecisionType DECLARED
			    BEFORE rfqOpenedAt (requestedAt < rfqOpenedAt)
			∧ aggregate.decisionType is populated from cmd-open-rfq
			∧ emitted event type matches aggregate.decisionType
			    via canonical mapping:
			      one-shot → SourcingDecisionMade
			      preferred-designation → PreferredSupplierDesignated
			      strategic-award → StrategicAwardCompleted
			∧ command de conclusão (cmd-make-*) match aggregate.decisionType
			    (reject mismatch)
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Build-time pode declarar decisionType field structure em CUE schema + mapping table; lint validates timing + correspondence em instances; runtime command handler MUST reject decisions where emitted event type ≠ aggregate.decisionType OR command type mismatches RFQ type."
			enforcedBy:  "CUE schema declares decisionType field + canonical mapping table + command handler validation (reject mismatched cmd-make-* vs aggregate.decisionType) + emit handler validation (event type matches aggregate.decisionType) + audit trail timing verification"
		}
		forbidden: [
			"decision event with type that doesn't match aggregate.decisionType",
			"cmd-make-one-shot-sourcing-decision applied to non-one-shot RFQ",
			"cmd-make-preferred-supplier-designation applied to non-preferred-designation RFQ",
			"cmd-make-strategic-award applied to non-strategic-award RFQ",
			"aggregate.decisionType populated POST rfqOpenedAt (retroactive classification)",
			"agent decides decisionType instead of applying declared type",
		]
	}
	errorMessage: "domain-invariant inv-decision-type-declared-upfront: decision type mismatch detected (event type ≠ aggregate.decisionType) OR retroactive classification OR autonomy creep (agent decides type). Anti-autonomy-creep: agente aplica, NÃO decide. Verifique CUE schema decisionType + command handler validation + canonical mapping table application."
	rationale:    "Materializa bd-decision-type-is-declared-upfront + anti-autonomy-creep discipline. L7 captura decision context: decisionType DEFINES authority scope (one-shot vs preferred vs strategic têm stakeholder communication + downstream contract obligation scopes distintos). Coverage T/T/T: CUE schema build-time; lint validates timing/correspondence; command handler runtime."
}

structuralChecks: "sc-ssc-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-ssc-03"
	title:        "Qualification as Absolute Precondition (NPM cross-BC) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhum fornecedor entra em RFQ sem status eligible-for-sourcing em NPM (consultado via QueryParticipantStatus). Validação obrigatória em 2 momentos críticos: RFQ open (qualificação inicial do pool) e decision time (re-validation antes de emitir decisão). Fornecedor rebaixado entre os pontos é excluído automaticamente. SSC NÃO revalida compliance (KYC/AML é responsabilidade NPM); apenas consume status binário.

		Layers ativos (per adr-086 D2):
		- L3 RESOLVABLE CONTRACT: NPM cross-BC sync query via QueryParticipantStatus (single-owner qualification per dp-04)
		- L5 FRESHNESS HEURISTIC: re-validation at decision time catches mid-RFQ drift (status downgrade between RFQ open and decision)
		- L7 DECISION CONTEXT: re-validation scope (per-supplier at 2 critical moments — RFQ open + decision time)

		Layers non-applicable: L1, L2, L2.5, L4, L6
		Non-applicability rationale: presence + cross-field covered em other rules (sc-ssc-06 pool count); sem adoption proof binding, sem version dependency (qualification é binary status), sem interpretation coherence step (status é binary consume).

		RE-VAL: Yes — re-validation discipline IS the invariant; periodic audit catches mid-RFQ drift patterns + pol-revalidate-on-status-changed event consumption from NPM ACL.

		War-game evidence (per adr-086 D5):
		NPM status drift mid-RFQ — supplier eligible at RFQ open (KYC passed; sanctions clear); during evaluation window (days/weeks), supplier added to sanctions list OR KYC re-validation fails; without re-validation at decision time, ineligible supplier wins; OR re-validation cached stale (cache TTL too long); compliance breach + Bacen audit exposes decision based on outdated eligibility; cross-BC drift silent (NPM emits status-changed event but SSC ACL not consuming OR consuming with delay).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-qualification-as-precondition"
		assertion: """
			∀ RFQ:
			  ∀ supplier in pool at RFQ open:
			    NPM.QueryParticipantStatus(supplier) returns 'eligible-for-sourcing'
			∧ ∀ decision emit moment:
			    ∀ supplier in evaluatedSuppliers:
			      NPM.QueryParticipantStatus(supplier) returns 'eligible-for-sourcing'
			      (re-validation at decision time)
			∧ supplier downgrade between RFQ open and decision time
			    triggers automatic exclusion from evaluatedSuppliers
			∧ re-validation is sync query (not cached stale data)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cross-BC sync query + re-validation discipline requires runtime. Build-time não vê NPM state nem runtime sync queries; emit handler MUST execute re-validation query at decision time + filter ineligible suppliers; cache discipline (não stale)."
			enforcedBy:  "emit handler runtime gate (refuse decision emit sem fresh QueryParticipantStatus for each evaluatedSupplier) + svc-supplier-pool-builder at RFQ open (initial qualification check) + pol-revalidate-on-status-changed (ACL consuming NPM status-changed events, secondary defense) + RE-VAL periodic audit catching drift patterns"
		}
		forbidden: [
			"supplier in evaluatedSuppliers without recent (decision-time) eligible-for-sourcing status",
			"re-validation skipped at decision time (relying on RFQ open qualification only)",
			"cached NPM status used at decision time without re-query",
			"supplier downgrade between RFQ open and decision NOT triggering exclusion",
			"SSC revalidating compliance directly (anti-mini-NPM — NPM is single-owner)",
		]
	}
	errorMessage: "domain-invariant inv-qualification-as-precondition: supplier in pool/evaluatedSuppliers without fresh eligible-for-sourcing status OR re-validation skipped at decision time. NPM single-owner qualification per dp-04 — 2 critical moments mandatory (RFQ open + decision time). Verifique emit handler runtime gate + svc-supplier-pool-builder + pol-revalidate-on-status-changed + RE-VAL periodic audit."
	rationale:    "Materializa bd-qualification-as-absolute-precondition + dp-04 single-owner NPM. L3+L5+L7: cross-BC sync query + re-validation freshness + decision context scope. RE-VAL essential — drift mid-RFQ é real risk; defense-in-depth via dual moments + periodic audit."
}

structuralChecks: "sc-ssc-04": artifact_schemas.#StructuralCheck & {
	id:           "sc-ssc-04"
	title:        "Decision Rationale Required (Lei 12.846 audit) domain invariant"
	artifactType: "domain-model"
	description: """
		Toda decisão emitida carrega decisionRationale completo: criteria aplicados, weights vigentes da categoria, evaluatedSuppliers (todos cotantes válidos com score por critério), tradeoffs articulados (justificativa de escolha vs alternativa específica). decisionRationale vazio ou parcial bloqueia emissão. Quotations com status=withdrawn NÃO entram em evaluatedSuppliers.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: decisionRationale field populated com sub-fields (criteria + weights + evaluatedSuppliers + tradeoffs)
		- L2 CROSS-FIELD: rationale components cross-consistent (criteria match weights; evaluatedSuppliers scores derive from criteria + weights; tradeoffs reference evaluatedSuppliers; withdrawn excluded)
		- L6 DECISION↔INTERPRETATION COHERENCE: rationale supports audit reconstruction (Lei 12.846); auditor can derive how decision was reached from rationale alone
		- L7 DECISION CONTEXT: rationale DEFINES scope of decision (criteria scope; weight authority; evaluation surface; alternative consideration boundary)

		Layers non-applicable: L2.5, L3, L4, L5
		Non-applicability rationale: presence + cross-field structural; sem semantic adoption binding, sem cross-BC contract resolution (rationale é intra-SSC), sem version dependency (rationale é point-in-time at emit), sem freshness drift.

		RE-VAL: N/A (rationale é point-in-time at emit; once captured, immutable in event log).

		War-game evidence (per adr-086 D5):
		Rationale summary replacing full content — operational pressure to ship decisions faster; "supplier A won because best score" replaces criteria + weights + evaluatedSuppliers + tradeoffs; partial rationale slips through (only top supplier, no alternatives considered articulated); audit reconstruction fails when investigador asks "why didn't supplier B win? what was the criteria comparison?"; Lei 12.846 anti-corruption audit gap (cannot prove competitive process was fair); regulatory exposure + potential corruption probing exposed via inability to reconstruct decision.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-decision-rationale-required"
		assertion: """
			∀ decision event:
			  decision.decisionRationale.criteria is PRESENT non-empty
			∧ decision.decisionRationale.weights is PRESENT non-empty
			∧ decision.decisionRationale.evaluatedSuppliers is PRESENT non-empty
			    (all valid quoters with score per criterion)
			∧ decision.decisionRationale.tradeoffs is PRESENT non-empty
			    (articulated justification of choice vs specific alternative)
			∧ quotations with status=withdrawn NOT in evaluatedSuppliers
			∧ evaluatedSuppliers scores derive from criteria + weights mechanically
			∧ tradeoffs reference suppliers in evaluatedSuppliers
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "CUE schema can declare decisionRationale fields required; lint validates completeness; runtime emit handler MUST refuse decisions with empty/partial rationale OR rationale inconsistencies (withdrawn included, tradeoffs not referencing evaluatedSuppliers)."
			enforcedBy:  "CUE schema requires decisionRationale fields non-empty + emit handler runtime gate (refuse partial rationale) + audit trail lint cross-instance validating cross-field consistency + Lei 12.846 audit reconstruction property test"
		}
		forbidden: [
			"decision event with empty OR partial decisionRationale",
			"decisionRationale.criteria empty OR missing",
			"decisionRationale.weights empty OR missing",
			"decisionRationale.evaluatedSuppliers empty OR including withdrawn quotations",
			"decisionRationale.tradeoffs empty OR not referencing evaluatedSuppliers",
			"rationale summary replacing full content (e.g., 'best score won' without sub-fields)",
			"evaluatedSuppliers scores not deriving from criteria + weights mechanically",
		]
	}
	errorMessage: "domain-invariant inv-decision-rationale-required: decision detected com decisionRationale empty/partial OR inconsistencies (withdrawn included, tradeoffs orphan). Lei 12.846 anti-corruption audit exige rationale completo + reconstrutível. Verifique CUE schema + emit handler runtime gate + audit lint."
	rationale:    "Materializa moat de inteligência Mesh + Lei 12.846 anti-corruption audit support + sustenta reconciliação spend + consumo NIM futuro (oq-ssc-2). L6+L7: rationale supports audit interpretation coherence + defines decision scope (criteria + weights + alternatives boundary). Coverage T/T/T: CUE schema + lint + runtime gate."
}

structuralChecks: "sc-ssc-05": artifact_schemas.#StructuralCheck & {
	id:           "sc-ssc-05"
	title:        "RFQ Public Lifecycle Events domain invariant"
	artifactType: "domain-model"
	description: """
		Toda RFQ que percorre fluxo normal (open → decisão emitida) DEVE emitir RFQOpened seguido de RFQConcluded. Toda RFQ cancelada antes de decisão DEVE emitir RFQOpened seguido de RFQCancelled. NÃO há saída do lifecycle sem evento público correspondente. Notificação a fornecedores invited (NTF transversal) + observabilidade (OBS) dependem destes events.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: RFQOpened + RFQConcluded OR RFQCancelled present em event log
		- L2 CROSS-FIELD: event sequence consistency (RFQOpened precedes terminal event; terminal event matches aggregate state)
		- L7 DECISION CONTEXT: lifecycle events DEFINE stakeholder communication scope + commitment scope (suppliers invited têm expectation of outcome notification; OBS/NTF cascade depends on events)

		Layers non-applicable: L2.5, L3, L4, L5, L6
		Non-applicability rationale: invariant é state machine + event presence structural; sem semantic adoption binding, sem cross-BC contract resolution, sem version dependency (events são immutable records), sem freshness drift, sem interpretation coherence step (event presence é binary).

		RE-VAL: N/A (event log is append-only; once events emitted, structurally fixed).

		War-game evidence (per adr-086 D5):
		RFQ silently abandoned without emit — operational decision to "drop" RFQ (no winner identified, no formal cancellation); suppliers invited never notified of outcome; reputation damage (suppliers frustrated by ambiguous status); fairness breach (suppliers committed effort without closure); OBS/NTF cascade broken (no terminal event for downstream observability + notification systems); stakeholder communication discipline violated; pattern enables informal "ghost RFQs" used to gauge market without commitment.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rfq-public-lifecycle-events"
		assertion: """
			∀ RFQ:
			  ∃ RFQOpened event in event log
			∧ ∃ terminal event in event log (RFQConcluded OR RFQCancelled)
			∧ RFQOpened.timestamp < terminal_event.timestamp
			∧ aggregate state matches terminal event:
			    aggregate.status == 'concluded' ⇒ RFQConcluded emitted
			    aggregate.status == 'cancelled' ⇒ RFQCancelled emitted
			∧ no RFQ exits lifecycle without paired terminal event
			∧ RFQConcluded ALWAYS paired with decision emit (SourcingDecisionMade |
			    PreferredSupplierDesignated | StrategicAwardCompleted)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Event log presence + sequence consistency requires runtime query. Build-time não vê event log; aggregate state machine guard pre-conclusion MUST emit terminal event; validation-time lint catches orphan RFQs."
			enforcedBy:  "aggregate state machine guard (refuse state transition to terminal sem emit pareado) + event log auditor (validation-time advisory) + OBS/NTF cascade dependency on terminal events (downstream consumers expect events; absence detected)"
		}
		forbidden: [
			"RFQ in terminal state (concluded OR cancelled) without paired terminal event in event log",
			"RFQ silently abandoned (no RFQCancelled OR RFQConcluded emitted)",
			"aggregate state ≠ terminal event type (state=concluded but RFQCancelled emitted, etc.)",
			"RFQConcluded emitted without paired decision event",
			"ghost RFQ pattern (informal market gauging without lifecycle closure)",
		]
	}
	errorMessage: "domain-invariant inv-rfq-public-lifecycle-events: RFQ terminal state without paired event OR silent abandonment detected OR state-event mismatch. Stakeholder communication discipline + OBS/NTF cascade dependem de events. Verifique aggregate state machine guard + event log auditor."
	rationale:    "Materializa bd-rfq-lifecycle-public-minimal + stakeholder communication discipline. L7 captura decision context: lifecycle events DEFINE communication scope (suppliers invited deserve closure; OBS/NTF systems consume events). Coverage F/T/T: event log presence é runtime query."
}

structuralChecks: "sc-ssc-06": artifact_schemas.#StructuralCheck & {
	id:           "sc-ssc-06"
	title:        "Competitive Pool or Supervised Exception domain invariant"
	artifactType: "domain-model"
	description: """
		Decisão emitida AUTOMATICAMENTE exige pool ≥ 2 fornecedores qualificados no decision time. Pool < 2 (incluindo sole-source genuíno: item proprietário, fornecedor único qualificado, urgência operacional) exige supervisedDecision approve-decision-with-insufficient-pool com justificativa documentada — sem bloqueio absoluto, apenas escalation para gate humano.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: pool count + supervisedDecision authority present (when applicable)
		- L2 CROSS-FIELD: cross-field condition (autonomous emit ⇒ pool ≥ 2; pool < 2 ⇒ supervisedDecision present)
		- L5 FRESHNESS HEURISTIC: re-validation at decision time catches pool drift (suppliers withdraw mid-RFQ)
		- L7 DECISION CONTEXT: exception authority scope (founder/supervisor authorization required for pool < 2; bounded exception decision per-RFQ)

		Layers non-applicable: L2.5, L3, L4, L6
		Non-applicability rationale: invariant é authority gate + temporal discipline; cross-BC NPM dependency covered em sc-ssc-03; sem adoption proof, version dependency, interpretation coherence step (pool count é numeric).

		RE-VAL: Yes — pool drift detection mid-RFQ + periodic audit catches engineered scenarios forcing pool=1 (manipulation patterns).

		War-game evidence (per adr-086 D5):
		**MANIPULATION VECTOR** — Pool size 2 at RFQ open; supplier withdraws OR is downgraded mid-RFQ (legitimate OR engineered); pool=1 at decision time; without re-validation, automatic emit with insufficient pool; OR more sophisticated: scenario engineered where only one supplier qualifies in narrow category (criteria tuning to favor specific supplier; specs that match only one supplier's offering); competitive discipline breach + manipulation vector against fair sourcing process; Bacen audit exposes pattern + potential anti-corruption probe (Lei 12.846); supervisedDecision authority circumvented via "natural" sole-source emergence.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-competitive-pool-or-supervised-exception"
		assertion: """
			∀ decision emit AUTONOMOUS (no supervisedDecision):
			  pool_size_at_decision_time ≥ 2
			    (qualified suppliers in evaluatedSuppliers)
			∧ pool_size_at_decision_time < 2 ⇒
			    ∃ supervisedDecision(approve-decision-with-insufficient-pool)
			    referenced in decision event
			∧ pool_size_at_decision_time computed via re-validation
			    (not cached pool_size_at_rfq_open)
			∧ supervisedDecision.justification documented + non-empty
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Pool size computation at decision time + supervisedDecision authority resolution requires runtime. Build-time não vê pool state nem authorization events; emit handler MUST compute pool size via re-validation + verify supervisedDecision present when pool < 2."
			enforcedBy:  "emit handler runtime gate (compute pool size via re-validation NPM cross-BC query + refuse autonomous emit when pool < 2 sem supervisedDecision resolved) + supervisedDecision aggregate enforcement (CMT) + RE-VAL periodic audit catching pool drift patterns + manipulation pattern detection (recurring single-supplier categories)"
		}
		forbidden: [
			"autonomous decision emit when pool_size_at_decision_time < 2",
			"decision emit with pool < 2 without supervisedDecision authority chain resolved",
			"pool_size_at_decision_time computed from cached pool_size_at_rfq_open (no re-validation)",
			"supervisedDecision present but justification empty OR missing",
			"engineered scenario pattern (criteria tuning OR specs favoring single supplier) NOT flagged",
		]
	}
	errorMessage: "domain-invariant inv-competitive-pool-or-supervised-exception: autonomous decision emit detected with pool < 2 OR supervisedDecision authority missing OR pool drift undetected. Competitive discipline + dp-08 manipulation defense exigem pool ≥ 2 OR human gate authority. Verifique emit handler runtime gate + re-validation + RE-VAL periodic audit."
	rationale:    "Materializa premissa de seleção competitiva sem rigidez universal + canvas escalationCriterion insufficient-qualified-pool. L7 captura exception authority decision context: founder/supervisor authorization para sole-source legitimate. RE-VAL essential — pool drift mid-RFQ + manipulation patterns são real risks detectáveis apenas via periodic audit."
}

structuralChecks: "sc-ssc-07": artifact_schemas.#StructuralCheck & {
	id:           "sc-ssc-07"
	title:        "Fitness Rules Versioned Config (Goodhart defense) domain invariant"
	artifactType: "domain-model"
	description: """
		Fitness rules vivem em configuração externa governada (não no agent code) com versionamento. Cada decisão emitida carrega fitnessRuleSnapshot (versionId + content) imutável referenciando as regras vigentes no momento da decisão. Configuração e atualização são supervisedDecision (configure-fitness-rules) — não pertencem ao escopo aplicador do agente.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: fitnessRuleSnapshot (versionId + content) present em decision event
		- L3 RESOLVABLE CONTRACT: fitnessRuleSnapshot.versionId resolves to registered rule version in external config registry
		- L4 VERSIONED: snapshot immutable post-emit; rule version frozen at evaluation time (not pointing to current rules)
		- L6 DECISION↔INTERPRETATION COHERENCE: decision was interpreted under THE SAME rule set as embedded snapshot (não rule set diferente aplicada post-hoc)

		Layers non-applicable: L2, L2.5, L5, L7
		Non-applicability rationale: invariant é snapshot + version + interpretation discipline; cross-field consistency covered em sc-ssc-01 (decision-from-structured-signals); sem adoption proof binding, sem freshness drift (snapshot é immutable), sem decision context scaling (rule application scope covered em sc-ssc-01).

		RE-VAL: Yes — periodic audit of rule manipulation patterns (rules updated mid-RFQ; supplier-specific rule tuning; sudden version churn correlated with specific decisions).

		War-game evidence (per adr-086 D5):
		**PRIMARY GOODHART VECTOR** — fitnessRules version v1 active during evaluation; supplier scoring completed; before decision emit, founder OR adversarial actor updates rules to v2 (favoring specific supplier — e.g., changes weights, adds criteria that match favored supplier); decision emit happens; without versioned snapshot frozen at EVALUATION time, audit cannot determine which ruleset produced the scoring; rules manipulation vector + Lei 12.846 corruption exposure + audit reconstruction impossible (was decision under v1 evaluation or v2 emit? snapshots solve this); supplier favoritism pattern + competitive process integrity breach. Pattern paralelo a sc-rew-* version-bound discipline + sc-cmt-02 terms-reference-valid frozen pattern.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-fitness-rules-versioned-config"
		assertion: """
			∀ decision event:
			  decision contains fitnessRuleSnapshot
			∧ fitnessRuleSnapshot.versionId resolves to registered rule version
			    in external config registry (NOT inline em agent code)
			∧ fitnessRuleSnapshot.content is immutable post-emit
			    (snapshot frozen at evaluation time, not pointing to current)
			∧ decision was emitted using SAME ruleset as snapshot
			    (interpretation coherence — não rules updated between
			     evaluation and emit)
			∧ fitness rules configuration updates require
			    supervisedDecision(configure-fitness-rules)
			    (not autonomous agent action)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Snapshot embedding + resolution + interpretation coherence requires runtime. Build-time não vê rule registry nem snapshot lifecycle; emit handler MUST embed snapshot at evaluation time + freeze content + verify same ruleset used for evaluation + emit."
			enforcedBy:  "emit handler runtime gate (embed fitnessRuleSnapshot at evaluation time + freeze content + verify rule version unchanged between evaluation and emit) + rule registry external config (versioned + governed) + supervisedDecision aggregate enforcement for rule updates + RE-VAL periodic audit catching rule manipulation patterns (mid-RFQ updates, supplier-specific tuning, version churn correlation)"
		}
		forbidden: [
			"decision event without fitnessRuleSnapshot embedded",
			"fitnessRuleSnapshot.content mutated post-emit (drift)",
			"fitnessRuleSnapshot pointing to current rules instead of frozen snapshot",
			"rules updated between evaluation and decision emit (interpretation incoherence)",
			"fitness rules updated autonomously by agent (without supervisedDecision authority)",
			"rule manipulation pattern (rules updated mid-RFQ favoring specific supplier)",
		]
	}
	errorMessage: "domain-invariant inv-fitness-rules-versioned-config: decision detected sem fitnessRuleSnapshot embedded OR snapshot drift OR rules updated mid-RFQ. **GOODHART VECTOR + Lei 12.846 corruption exposure**. Verifique emit handler runtime gate + rule registry external config + supervisedDecision authority + RE-VAL periodic audit catching manipulation patterns."
	rationale:    "Materializa bd-deterministic-decision-from-structured-signals consequence + **PRIMARY GOODHART DEFENSE**. L6 captura interpretation coherence: decision interpreted under SAME ruleset as embedded snapshot (não rule set diferente). RE-VAL essential — rule manipulation patterns detectable apenas via periodic audit + correlation analysis. Pattern paralelo sc-rew-* version-bound discipline + sc-cmt-02 terms-reference-valid frozen."
}
