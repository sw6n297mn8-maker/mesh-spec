package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// p2p-domain-model.cue — Structural checks para P2P domain-model.
// Per ADR-080: kind 'domain-invariant' unifica filesystem + semantic
// enforcement. 5 invariants do contexts/p2p/domain-model.cue declarados
// como garantias com limites explícitos.
//
// WI-083 SEXTA APPLICATION DISCAP-GUIDED forward authoring (per
// ADR-086 + PG patch WI-076; follows CMT WI-079 + DLV WI-080 + SSC
// WI-081 + CTR WI-082; retroactive INV WI-077 + REW WI-078).
//
// P2P identidade epistemológica:
// **P2P is intentionally authority-dependent, not authority-generating.**
//
// P2P severity tier ALTO: bridge entre SSC sourcing decisions (upstream)
// + CMT commitment formalization (downstream); Lei 12.846 anti-corruption
// audit retention (5y); Bacen procurement compliance; cross-BC NPM single-
// owner discipline preserved via anti-mini-NIM transversal.
//
// Coverage distribution (5 checks):
// - 2 schema-enforced + runtime (03/04) — T/T/F + T/T/T (lifecycle state
//   machine + NEGATIVO constraint structural absence)
// - 3 runtime-required com runtimeGap declarado canonicamente
//   (01/02/05)
// - All 5 com validation-time advisory (audit + cross-instance lint)
//
// P2P shape: **execution-under-pre-validated-authority + cross-BC heavy
// + anti-mini-NIM transversal**:
// - L1: 5 rules (presença em todas)
// - L2: 3 rules (01/03/05) — cross-field lifecycle gates
// - L3: 1 rule (01) — cross-BC SSC resolvable contract
// - L4: 2 rules (02/04) — forbidden patterns + NEGATIVO structural absence
// - L5: 1 rule (01) — preferred-designation validUntil freshness
// - L6: 0 rules ABSENT — P2P NÃO interpreta significado; executa
//   authority pre-validated upstream; anti-mini-NIM discipline reduces
//   semantic interpretation pressure inside P2P
// - L7: 3 rules (01/03/05) — authority binding regime + boundary scope
//   + stakeholder communication
// - RE-VAL: 2 rules (01/02) — authority drift + allocation drift
//
// 6 layers ativos + RE-VAL orthogonal dimension (RE-VAL NÃO é layer;
// é dimensão temporal de revalidação per ADR-086 D7).
//
// P2P distinct shape vs 5 BCs antes autorados pos-DISCAP:
// - INV: L1/L2/L4 (structural-local baseline)
// - CMT: L1+L2+L3+L4+L5+L6+L7 — cross-BC mid-band
// - DLV: 8 layers (L2 dominant) — structural-rich bridge
// - SSC: 8 layers (L7 dominant) — semantic+cross-BC+anti-Goodhart
// - CTR: 6 layers + RE-VAL (L4+RE-VAL dominant) — versioning-heavy
//   contractual
// - REW: L5/L6/L7 (semantic-contextual)
// - P2P (this): 6 layers + RE-VAL (L1 dominant, balanced L2/L7) —
//   execution-under-pre-validated-authority com NEGATIVO constraint
//   shape novo (sc-p2p-04)
//
// **NEGATIVO constraint shape novo (sc-p2p-04)**: forbidden capability
// acquisition invariant — pattern arquitetural transferable upstream
// candidate. Não declara presença de comportamento MAS prohibition
// de capability acquisition. Materializa **prevention of epistemic
// authority expansion**: P2P NÃO adquire capability QueryParticipantStatus
// porque adquiriria epistemic authority sobre supplier qualification
// (responsabilidade NPM single-owner per dp-04).
//
// L8 NÃO invocado — existing ladder sufficient. P2P pressure não
// revelou new layer.
//
// Behavioral non-applicability discipline (per adr-086 D6):
// P2P domain-model 5 invariants são TODAS structurally enforceable.
// Casos limítrofes:
// - inv-02 (allocation monitoring): poderia parecer behavioral (agent
//   computes drift) MAS structurally enforceable via projection presence
//   (prj-allocation-tracking) + signal emission mechanism (sig-allocation-
//   drift) — observable property é codified as structural artifact
//   discipline. **sig-allocation-drift is advisory, not binding** —
//   signal emission ≠ automatic procurement intervention (anti mini-SSC
//   stealth).
// - inv-04 (no-supplier-revalidation): NEGATIVO constraint declarando
//   AUSÊNCIA — structurally enforceable via agent-spec operationalScope
//   linting + aggregate dependsOnAggregateState absence.
//
// Forbidden patterns são state/property prohibitions (não actions —
// per founder lint pattern).

structuralChecks: "sc-p2p-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-p2p-01"
	title:        "Purchase Order Requires Valid Authority (RECTOR) domain invariant"
	artifactType: "domain-model"
	description: """
		Toda transição requested→emitted (PO progredindo de attempt recorded para PO emitida) EXIGE authorityRef vigente apontando para uma SSC decision válida no momento do emit. AuthorityType determina admissible SSC decision shape — NÃO é enum decorativo. Authority válida significa: (a) one-shot-decision → single RFQ lineage (SourcingDecisionMade vigente para categoryRef + supplier ∈ selectedSuppliers); (b) preferred-designation → requires validUntil (PreferredSupplierDesignated com validUntil > emittedAt + supplier ∈ preferredSuppliers); (c) strategic-award → may imply multi-supplier admissibility (StrategicAwardCompleted vigente; Phase 0 advisory binding; Phase 1+ requer ContractActivated CTR para hard binding per oq-p2p-1).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: authorityRef field populated em agg-purchase-order
		- L2 CROSS-FIELD: authorityRef + authorityType + supplier + categoryRef consistency (authorityType determines admissible SSC decision shape)
		- L3 RESOLVABLE CONTRACT: cross-BC SSC resolvable contract via QuerySourcingDecision sync query + prj-active-purchase-authorities cache lookup
		- L5 FRESHNESS HEURISTIC: preferred-designation validUntil > emittedAt freshness window
		- L7 DECISION CONTEXT: authorityType determines binding regime scope (hard/soft/advisory) + escalation routing

		Layers non-applicable: L2.5, L4, L6
		Non-applicability rationale: invariant é cross-BC authority resolution + binding regime scope; sem adoption proof binding (authority é pre-validated upstream NÃO adopted by P2P), sem versioning core (authorityType discriminator é structural NÃO versioned per-se — SSC owns version), sem interpretation coherence step (authorityType discriminator é structural NÃO interpretive — P2P NÃO interpreta significado per anti-mini-NIM discipline).

		RE-VAL: Yes — failure mode real é **projection stale creates false authority continuity**. Periodic audit cross-validates prj-active-purchase-authorities cache vs SSC authoritative event log — **authoritative event log supersedes projection state** (precedence epistemológica). Cobre 3 cenários: (a) cache invalidation failure após CTR cancel → strategic-award authorityType permanece advisory falsamente disponível; (b) stale projection após SSC supervisedDecision override → authority revogada mas cache não atualizado; (c) replay divergence entre SSC event log canônico vs P2P projection materializada → false authority continuity in prj-active-purchase-authorities.

		War-game evidence (per adr-086 D5):
		Agente P2P emite PO sob authorityRef inexistente OR stale projection — gate determinístico authority validation consulta prj-active-purchase-authorities (cache local) que reporta authority como vigente mesmo após SSC supervisedDecision override OR CTR cancel cascade; cache invalidation falhou em produção (network partition OR consumer lag); P2P emit prossegue; cascade hard binding falsa para CMT; CMT formaliza commitment econômico bilateral não rastreável a SSC decision válida; reconciliação cross-BC quebra; Lei 12.846 audit (5y retention) sem fonte canônica de decisão de sourcing; potencial corruption probe expõe inability to demonstrate procurement competitive process.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-purchase-order-requires-valid-authority"
		assertion: """
			∀ transition (requested → emitted) of agg-purchase-order PO:
			  PO.authorityRef ≠ ∅ ∧
			  PO.authorityType ∈ {one-shot-decision, preferred-designation, strategic-award} ∧
			  ∃ resolvable SSC-decision d : d.id = PO.authorityRef ∧
			    d.categoryRef = PO.categoryRef ∧
			    PO.supplier ∈ d.{selectedSuppliers | preferredSuppliers | awardedSuppliers} ∧
			  authorityType determines admissible SSC decision shape:
			    PO.authorityType = one-shot-decision ⇒ d originated by single RFQ lineage (SourcingDecisionMade) ∧
			    PO.authorityType = preferred-designation ⇒ d.validUntil > PO.emittedAt (requires validUntil) ∧
			    PO.authorityType = strategic-award ⇒ d may imply multi-supplier admissibility (Phase 0 advisory; Phase 1+ requires CTR ContractActivated for hard binding)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cross-BC SSC authority resolution requer sync query + cache lookup runtime; CUE não enforce cross-BC reference resolution build-time. AuthorityType ↔ SSC decision shape binding requer runtime decision-payload introspection."
			enforcedBy:  "aggregate guard pre-emit (gate determinístico consulta prj-active-purchase-authorities + sync fallback QuerySourcingDecision via canvas query-surface) + validation-time advisory cross-instance lint + RE-VAL periodic projection audit cross-validating cache vs SSC authoritative event log (authoritative event log supersedes projection state)"
		}
		forbidden: [
			"transition requested→emitted WITH authorityRef=∅",
			"transition requested→emitted WITH authorityType ∉ {one-shot-decision, preferred-designation, strategic-award}",
			"transition requested→emitted WITHOUT SSC-decision resolvable in prj-active-purchase-authorities OR sync fallback",
			"transition requested→emitted WITH authorityType ↔ SSC decision shape mismatch (e.g., preferred-designation referencing decision sem validUntil)",
			"agente P2P emitting PO autonomously sem authority gate (anti-mini-NIM violation)",
		]
	}
	errorMessage: "domain-invariant inv-purchase-order-requires-valid-authority: P2P emit attempt sem authority válida — authorityRef=<X> não resolvível em prj-active-purchase-authorities nem em SSC sync query (QuerySourcingDecision) OR authorityType ↔ SSC decision shape mismatch. Defina authorityRef apontando para SSC decision vigente com shape compatível com authorityType OR escale via supervisedDecision (gate humano + justificativa documentada)."
	rationale:    "Invariante RECTOR de P2P per bd-emission-requires-sourcing-authority. P10 gate determinístico. Anti-mini-NIM: sem este gate, P2P decidiria sourcing fora de processo competitivo SSC — viola moat de inteligência da Mesh + integridade de boundary. AuthorityType determines admissible SSC decision shape (per founder ajuste 1) — discriminator NÃO é enum decorativo; cada valor binda P2P a shape estrutural específico do upstream SSC. RE-VAL essential (per founder ajuste 2): authoritative event log supersedes projection state — projection-consistency-sensitive invariant cristaliza precedence epistemológica entre SSC event log canônico (truth source) vs P2P projection materializada (cache derivado)."
}

structuralChecks: "sc-p2p-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-p2p-02"
	title:        "Allocation Convergence Aggregate Level (monitoring obligation) domain invariant"
	artifactType: "domain-model"
	description: """
		P2P MUST monitor and report sustained drift entre allocationPolicy upstream SSC e volume real emitido por authorityRef + supplier + categoryRef ao longo do validityPeriod (preferred) ou da janela ativa (one-shot/strategic). Drift sustentado dispara sig-allocation-drift como signal observável (OBS) para SSC reconsiderar fitness rules. **sig-allocation-drift is advisory, not binding** — signal emission ≠ automatic procurement intervention. **P2P detects allocation drift signals; SSC owns fairness interpretation.** Phase 0 enforcement é monitoring + reporting structural, NÃO bloqueio individual de PO — POs individuais não são gated por allocation; agregado é tracked via prj-allocation-tracking; drift é reportado, não impedido nem auto-corrigido.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: prj-allocation-tracking projection materializada em domain-model + qry-allocation-tracking-by-authority queryCapability declared
		- L4 VERSIONED: forbidden patterns NEGATIVO — agg-purchase-order WITHOUT prj-allocation-tracking projection = drift undetectable; sig-allocation-drift signal emission mechanism defined; P2P NÃO decide fairness allocation (responsabilidade SSC fitness rules — anti mini-SSC stealth)

		Layers non-applicable: L2, L2.5, L3, L5, L6, L7
		Non-applicability rationale: single-projection presence check NÃO cross-field; sem adoption proof binding; intra-BC (SSC consume signal, P2P NÃO consulta SSC para drift detection — signal is one-way advisory); window é definido upstream em allocationPolicy NÃO P2P freshness; interpretation de drift significance é SSC fitness rules (P2P só detecta); drift signal não DEFINE scope — apenas observa property.

		RE-VAL: Yes — drift periodic audit cross-validates projection volumes computed vs signal emission rate observed; cobre 3 cenários: (a) projection emite volumes mas signal não disparado → drift silencioso (sh-05 vetor adversarial passa sem detecção); (b) signal disparado sem projection backing → false positive flooding SSC; (c) cancellations não tracked corrigindo drift detection (cancelled POs já não foram entregues; volume real é downstream CMT/DLV — Phase 0 P2P projection trackeia apenas emitted volumes como proxy operacional).

		War-game evidence (per adr-086 D5):
		prj-allocation-tracking ausente em domain-model — drift cross-supplier não detectado em agregado; sh-05 allocation bias passa sem signal a SSC fitness rules reconsideração; supplier favoritism via fragmentation sub-threshold + concentração silenciosa em single supplier dentro de preferred pool; moat de fairness erode silenciosamente; Lei 12.846 vector adversarial não auditado — regulator probe expõe pattern de bias sem fonte canônica de detection signal; SSC fitness rules nunca aprendem com drift real porque feedback loop quebrado.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-allocation-convergence-aggregate-level"
		assertion: """
			∀ agg-purchase-order BC:
			  ∃ projection prj-allocation-tracking ∧
			  ∃ queryCapability qry-allocation-tracking-by-authority ∧
			  ∃ signal-emission-mechanism sig-allocation-drift ∧
			P2P domain logic ∌ fairness-allocation-decision-step
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Monitoring obligation Phase 0 é observable property — drift detection algorithm + signal emission runtime. CUE schema declara projection + queryCapability presence; runtime computa volumes agregados + dispara signal advisory."
			enforcedBy:  "agg-purchase-order schema declares prj-allocation-tracking projection presence + qry-allocation-tracking-by-authority queryCapability + sig-allocation-drift signal mechanism (validation-time lint enforces 3-piece structural completeness) + runtime drift detection algorithm + RE-VAL periodic audit cross-validating projection volumes vs signal emission rate (sig-allocation-drift is advisory NOT binding — no automatic procurement intervention)"
		}
		forbidden: [
			"agg-purchase-order WITHOUT prj-allocation-tracking projection",
			"prj-allocation-tracking WITHOUT qry-allocation-tracking-by-authority queryCapability",
			"P2P operational logic WITHOUT sig-allocation-drift signal emission capability",
			"P2P MUST NOT include fairness allocation decision logic (anti mini-SSC stealth — P2P detects drift signals; SSC owns fairness interpretation)",
			"sig-allocation-drift treated as binding gate (Phase 0 é advisory; automatic procurement intervention recriaria mini-SSC stealth)",
		]
	}
	errorMessage: "domain-invariant inv-allocation-convergence-aggregate-level: P2P BC sem prj-allocation-tracking projection OR sem sig-allocation-drift signal emission capability OR contains fairness decision logic — allocation drift cross-supplier não detectável; SSC fitness rules reconsideration impossibilitada. Materialize prj-allocation-tracking + signal emission mechanism; NÃO adicione fairness decision logic (responsabilidade SSC); sig-allocation-drift é advisory, NÃO binding gate."
	rationale:    "Monitoring obligation Phase 0 per bd-allocation-policy-respected-in-aggregate + Patch 3 founder. **P2P detects drift signals; SSC owns fairness interpretation** (per founder ajuste 3 anti mini-SSC stealth). **sig-allocation-drift is advisory, not binding** — signal emission ≠ automatic procurement intervention. Phase 1+ pode evoluir para hard gate se feedback loop estabilizar (oq-p2p-3 + oq-ssc-3 bridge), MAS Phase 0 mantém boundary explícita: P2P observa convergência, NÃO decide allocation."
}

structuralChecks: "sc-p2p-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-p2p-03"
	title:        "Cancellation Pre-Formalization Only (lifecycle boundary) domain invariant"
	artifactType: "domain-model"
	description: """
		evt-purchase-order-cancelled é emitido APENAS quando: (a) state=requested cancela para limpar attempt failed validation; (b) state=emitted cancela ANTES de CMT formalization (race condition pré-CMT). Cancelamento pós-CMT formalization NÃO é coberto Phase 0 — exige cross-BC coordination cancel-cascade. **Cancellation authority ends at PO lifecycle boundary; downstream commitment unwind is NOT owned by P2P** — anti mini-CMT stealth.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: state precondition (fromState ∈ {requested, emitted})
		- L2 CROSS-FIELD: lifecycle transition guard (cancel only from non-terminal states; transition table prevents cancel→*)
		- L7 DECISION CONTEXT: cancellation DEFINES scope boundary — pre-CMT formalization only; cancellation authority ends at PO lifecycle boundary; downstream commitment unwind é responsabilidade CMT/CTR

		Layers non-applicable: L2.5, L3, L4, L5, L6
		Non-applicability rationale: sem adoption proof binding; cross-BC CMT formalization state visibility é Phase 1+ design (oq-p2p-2) NÃO Phase 0 contract resolution; state transition NÃO versioning; boundary é structural NÃO temporal-freshness; interpretation absent.

		RE-VAL: No — boundary é structural; race condition oq-p2p-2 endereça via design Phase 1+ NÃO periodic audit.

		War-game evidence (per adr-086 D5):
		Cancel após CMT formalizar commitment — race condition em produção (CMT já consumiu evt-purchase-order-emitted e formalizou CommitmentAccepted; P2P recebe cancel request da originadora; P2P emite evt-purchase-order-cancelled sem visibility de CMT state); commitment-without-source-PO emerge em sistema; reconciliação cross-BC quebrada; Lei 12.846 audit trail inconsistente; ALTERNATIVA pior: P2P implementa unilateral commitment unwind logic → mini-CMT stealth + duplica responsabilidade + drift de truth source.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-cancellation-pre-formalization-only"
		assertion: """
			∀ transition (* → cancelled) of agg-purchase-order PO:
			  fromState ∈ {requested, emitted} ∧
			  fromState ≠ cancelled ∧
			  P2P workflow ∌ downstream-commitment-unwind-step ∧
			  (fromState = emitted ⇒ Phase 0 accepts unresolved coordination gap explicitly documented in oq-p2p-2;
			   Phase 1+ requires CMT-formalization-state(PO.purchaseOrderId) = not-yet-formalized resolution)
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: false
		}
		runtimeGap: {
			description: "Lifecycle transitions enforceable build-time via #Lifecycle schema + state machine declaration; CMT formalization race condition coordination Phase 0 accepts unresolved coordination gap explicitly documented in oq-p2p-2 (Phase 1+ design endereça via cross-BC coordination protocol — NÃO periodic audit nor probabilistic operational optimism)."
			enforcedBy:  "CUE #Lifecycle schema declares transition table (cancel only from {requested, emitted}; no transition from cancelled) + aggregate command handler reject cmd-cancel-purchase-order if status=cancelled + validation-time lint enforces P2P workflows ∌ downstream-commitment-unwind-step + oq-p2p-2 deferred coordination gap explicit (cross-BC unwind é CMT/CTR responsabilidade)"
		}
		forbidden: [
			"transition cancelled→cancelled (terminal state)",
			"transition cancelled→requested (no return from terminal)",
			"transition cancelled→emitted (no return from terminal)",
			"P2P workflow OR command implementing downstream commitment unwind logic (anti mini-CMT stealth — cancellation authority ends at PO lifecycle boundary)",
			"P2P cancellation triggering CMT.commitmentRollback OR similar cross-BC unwind command",
		]
	}
	errorMessage: "domain-invariant inv-cancellation-pre-formalization-only: P2P cancel attempt fora do escopo — fromState=<X> não permite cancel OR P2P implementing downstream commitment unwind logic. Cancellation authority de P2P termina no PO lifecycle boundary; downstream commitment unwind é responsabilidade CMT/CTR (cross-BC coordination Phase 1+ oq-p2p-2 deferred). Phase 0 accepts unresolved coordination gap explicitly."
	rationale:    "Boundary explícita do escopo de cancellation Phase 0. **Cancellation authority ends at PO lifecycle boundary; downstream commitment unwind is NOT owned by P2P** (per founder ajuste 3 anti mini-CMT stealth). RuntimeGap não depende de probabilistic operational optimism (per founder ajuste 4) — Phase 0 accepts unresolved coordination gap explicitly documented in oq-p2p-2; Phase 1+ design endereça via cross-BC coordination protocol."
}

structuralChecks: "sc-p2p-04": artifact_schemas.#StructuralCheck & {
	id:           "sc-p2p-04"
	title:        "No Supplier Revalidation by P2P (NEGATIVO; forbidden capability acquisition) domain invariant"
	artifactType: "domain-model"
	description: """
		P2P NÃO consulta NPM (sem QueryParticipantStatus em P2P operationalScope). P2P NÃO revalida supplier eligibility no momento do emit — confia na validação SSC upstream. Shape novo: **forbidden capability acquisition invariant** — NÃO declara presença de comportamento MAS prohibition de capability acquisition. Materializa **prevention of epistemic authority expansion**: P2P NÃO adquire capability QueryParticipantStatus porque adquiriria epistemic authority sobre supplier qualification (responsabilidade NPM single-owner per dp-04).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: absence enforcement at artifact level (agent-spec.operationalScope check)
		- L4 VERSIONED: forbidden patterns NEGATIVO — 3 declarações de ausência (operationalScope + dependsOnAggregateState + workflows)

		Layers non-applicable: L2, L2.5, L3, L5, L6, L7
		Non-applicability rationale: declarações de ausência são independentes (sem cross-field); CONSTRAINT NEGATIVO — ausência de contract NÃO presença de contract (L3 inversion); sem freshness drift (structural absence permanent); interpretation absent; decision context não scaling porque AUSÊNCIA é total não scoped.

		RE-VAL: No — NEGATIVO constraint é structural absence permanent (não drift temporal; absence is the invariant — não evolui).

		War-game evidence (per adr-086 D5):
		P2P adiciona QueryParticipantStatus a operationalScope "por conveniência" — agente P2P emite PO encontra supplier marginal status; revalida via NPM query; encontra status difere de SSC validation cached (supplier rebaixado entre SSC decision e P2P emit); P2P decide bloquear emit autonomamente; mas SSC validation upstream foi truth source; P2P virou mini-NIM com duplicated qualification authority; drift entre SSC validation result + P2P revalidation result emerge; fonte ambígua de qualification truth degrada moat NPM single-owner per dp-04; downstream CMT/CTR não sabem qual qualification source é canônica; potencial Lei 12.846 corruption probe expõe inconsistent qualification enforcement.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-no-supplier-revalidation-by-p2p"
		assertion: """
			∀ P2P artifacts:
			  P2P.agent-spec.operationalScope ∌ QueryParticipantStatus ∧
			  P2P.aggregates.*.dependsOnAggregateState ∌ {bc: npm} ∧
			  P2P.workflows ∌ supplier-revalidation-step ∧
			  P2P.commands ∌ revalidate-supplier-command ∧
			  P2P.policies ∌ on-supplier-status-change-react
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "agent-spec operationalScope linter + dependsOnAggregateState declaration check executam build-time; runtime workflow inspection enforce que sessions não invocam QueryParticipantStatus mesmo se schema permitir (defense-in-depth)."
			enforcedBy:  "CUE schema declares P2P.agent-spec.operationalScope (validation-time lint enforces QueryParticipantStatus ∉ operationalScope) + P2P.aggregates.*.dependsOnAggregateState absence check (NPM not in cross-BC deps) + P2P.workflows linter (no supplier-revalidation-step) + runtime session inspection rejecting QueryParticipantStatus invocation patterns + agent-spec constraint cst-no-supplier-revalidation as agent autonomy boundary"
		}
		forbidden: [
			"P2P.agent-spec.operationalScope ⊇ {QueryParticipantStatus} (NEGATIVO property prohibition)",
			"P2P.aggregates.*.dependsOnAggregateState pointing to NPM (NEGATIVO state prohibition)",
			"P2P.workflows containing supplier-revalidation-step (NEGATIVO state prohibition)",
			"P2P.commands declaring revalidate-supplier-command (NEGATIVO capability prohibition)",
			"P2P.policies declaring on-supplier-status-change-react (NEGATIVO event consumer prohibition — NPM events not consumed)",
		]
	}
	errorMessage: "domain-invariant inv-no-supplier-revalidation-by-p2p: P2P artifact declara dependency PROIBIDA a NPM — P2P NÃO revalida supplier eligibility (confia em SSC validação upstream per inv-qualification-as-precondition SSC). NPM single-owner de qualification per dp-04. Remova QueryParticipantStatus de operationalScope / dependsOnAggregateState NPM / supplier-revalidation-step de workflows / revalidate-supplier-command / on-supplier-status-change-react policy. **Absence itself is the invariant; dependency prohibition is enforceable structure.**"
	rationale:    "**Forbidden capability acquisition invariant** (per founder ajuste 5) — pattern arquitetural novo. **Absence itself is the invariant.** **Dependency prohibition is enforceable structure.** Materializa **prevention of epistemic authority expansion**: P2P NÃO adquire capability QueryParticipantStatus porque adquiriria epistemic authority sobre supplier qualification (responsabilidade NPM single-owner per dp-04). Shape novo NEGATIVO transferable upstream candidate — REW/DLV/IDC poderiam ter similar absence-of-dependency constraints (anti-mini-NIM como invariant transversal materializado at rule body level)."
}

structuralChecks: "sc-p2p-05": artifact_schemas.#StructuralCheck & {
	id:           "sc-p2p-05"
	title:        "Purchase Order Lifecycle Public Events (paired) domain invariant"
	artifactType: "domain-model"
	description: """
		Toda PurchaseOrder que percorre fluxo normal (requested → emitted) DEVE emitir PurchaseOrderEmitted. Toda PurchaseOrder cancelada (requested → cancelled OR emitted → cancelled) DEVE emitir PurchaseOrderCancelled. Não há saída do lifecycle sem evento público correspondente. **Public lifecycle ≠ notification success**: invariant é **authoritative event publication occurred**, NÃO 'every downstream consumer processed successfully' — observabilidade distribuída é responsabilidade infra/OBS, NÃO escopo deste structural invariant. **At-least-once publication acceptable; exactly-once delivery NOT required by this invariant.**

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: emitsEvents contains evt-purchase-order-emitted + evt-purchase-order-cancelled
		- L2 CROSS-FIELD: lifecycle transition implies corresponding event emission declaration (transitions.emitsEvents consistency)
		- L7 DECISION CONTEXT: lifecycle DEFINES stakeholder communication scope (CMT consume emit hard binding; CMT consume cancel withdrawal signal; NTF transversal notifies supplier)

		Layers non-applicable: L2.5, L3, L4, L5, L6
		Non-applicability rationale: event emission intra-BC declaration NÃO cross-BC contract (publisher responsibility é P2P-internal; consumer obligation é separate concern); event schema versioning é separate concern (versioning de event schema NÃO core deste invariant); event publication não temporal-freshness; interpretation absent — anti-mini-NIM discipline reduces semantic interpretation pressure inside P2P.

		RE-VAL: No — lifecycle structural não drifts; event publication discipline é structural snapshot.

		War-game evidence (per adr-086 D5):
		Transição lifecycle sem event público — agg-purchase-order.lifecycle.transitions declares transition requested→emitted SEM emitsEvents: [evt-purchase-order-emitted]; em produção, transition fires but no event published authoritative; CMT não recebe trigger canônico de commitment lifecycle; commitment formalization gap silencioso; audit Lei 12.846 fica sem traceability cross-BC; NTF transversal não notifica supplier; potencial regulatory probe expõe inability to demonstrate procurement event chain (no authoritative event publication = no audit reconstruction possible).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-purchase-order-lifecycle-public-events"
		assertion: """
			∀ agg-purchase-order:
			  evt-purchase-order-emitted ∈ emitsEvents ∧
			  evt-purchase-order-cancelled ∈ emitsEvents ∧
			  ∀ transition (requested → emitted) declared in lifecycle:
			    evt-purchase-order-emitted ∈ transition.emitsEvents ∧
			  ∀ transition (* → cancelled) declared in lifecycle:
			    evt-purchase-order-cancelled ∈ transition.emitsEvents
			Note: invariant cobre authoritative event publication occurred;
			at-least-once publication acceptable; exactly-once delivery NOT
			required by this invariant (downstream consumer success é
			responsabilidade infra/OBS, NÃO escopo structural invariant).
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Event publisher semantics runtime; CUE schema declara emitsEvents + transitions.emitsEvents mas event emission discipline runtime. At-least-once publication acceptable (downstream delivery semantics NOT in scope)."
			enforcedBy:  "CUE #Lifecycle schema declares transitions.emitsEvents per state transition + validation-time lint enforces lifecycle ↔ emitsEvents consistency (transition declares event AND event in aggregate emitsEvents catalog) + runtime event publisher discipline emit authoritative publication per transition (at-least-once acceptable)"
		}
		forbidden: [
			"agg-purchase-order WITHOUT evt-purchase-order-emitted in emitsEvents",
			"agg-purchase-order WITHOUT evt-purchase-order-cancelled in emitsEvents",
			"transition requested→emitted WITHOUT evt-purchase-order-emitted in transition.emitsEvents",
			"transition (* → cancelled) WITHOUT evt-purchase-order-cancelled in transition.emitsEvents",
			"invariant expanded to require exactly-once delivery (out of scope — downstream consumer processing é infra/OBS responsabilidade NÃO structural invariant)",
		]
	}
	errorMessage: "domain-invariant inv-purchase-order-lifecycle-public-events: P2P agg-purchase-order lifecycle transition sem event público correspondente — CMT não recebe trigger canônico; audit Lei 12.846 sem traceability cross-BC. Declare evt-purchase-order-emitted/cancelled em emitsEvents + #Lifecycle.transitions.emitsEvents. **Invariant cobre publicação authoritative, NÃO sucesso de consumer downstream** (responsabilidade infra/OBS). At-least-once publication acceptable; exactly-once delivery NOT required."
	rationale:    "Materializa bd-po-lifecycle-public-events + term-po-lifecycle do glossary. **Public lifecycle ≠ notification success** (per founder ajuste 6) — invariant é **authoritative event publication occurred**, NÃO 'every downstream consumer processed successfully'. **At-least-once publication acceptable; exactly-once delivery NOT required by this invariant** — evita future inflation do invariant para observabilidade distribuída (que é infra/OBS responsabilidade)."
}
