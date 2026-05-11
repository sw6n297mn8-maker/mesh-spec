package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// dlv-domain-model.cue — Structural checks para DLV domain-model.
// Per ADR-080: kind 'domain-invariant' unifica filesystem + semantic
// enforcement. 14 invariants do contexts/dlv/domain-model.cue declarados
// como garantias com limites explícitos (runtime-gap canonicalmente
// declarado quando runtimeRequired=true).
//
// WI-080 SEGUNDA APPLICATION DISCAP-GUIDED forward authoring (per
// ADR-086 Domain-Invariant Structural Check Authoring Protocol + PG
// patch WI-076). Pattern paralelo a CMT (WI-079 — first forward
// authoring); DLV é segundo BC autorado FROM SCRATCH com protocol
// canonical aplicado.
//
// DLV severity tier ALTO: bridge physical reality ↔ financial decision;
// Lei NF-e cascade INV; forensic audit 5yr retention (Lei 12.846/SCD/
// CVM/LGPD); supersession + replay determinism são fundação econômica
// da rede.
//
// Coverage distribution (14 checks):
// - 3 schema-enforced + lint (02/04/05) — T/T/F (CUE schema declares
//   enum + identity tuple + required-when-rejected fields)
// - 11 runtime-required com runtimeGap declarado canonicamente
//   (01/03/06/07/08/09/10/11/12/13/14)
// - All 14 com validation-time advisory (event log analysis +
//   cross-instance lint + property-based test)
//
// Layer matrix demonstra DISCAP progressive ladder seletivo (per
// founder observation empirical validation):
// - L1 PRESENCE em 7 rules (01/03/04/05/07/08)
// - L2 CROSS-FIELD DOMINANT em 11 rules (01/02/04/05/07/08/09/11/13/14)
// - L3 RESOLVABLE CONTRACT em 5 rules (01/06/07/13/14) — evidence/
//   lineage/supersession/replay reference resolution
// - L4 VERSIONED em 6 rules (02/03/06/09/13/14) — versioning +
//   write-once + computed + ordering + replay
// - L5 FRESHNESS HEURISTIC em 3 rules (09/10/12) — temporal windows
//   (finality + exception)
// - L6 DECISION↔INTERPRETATION COHERENCE em 2 rules (04/06) — binary
//   outcome + retryPath determinism
// - L7 DECISION CONTEXT em 3 rules (08/10/12) — finality + exception
//   decisions (bounded blast radius)
// - RE-VAL em 6 rules (08/09/10/12/13/14) — replay + audit + finality
//   + temporal drift detection
//
// DLV é structural-rich + L4 forte + temporal/finality/replay ladder
// (7/8 layers ativos em algum rule — pattern mais amplo de todos
// BCs autorados). Demonstra DISCAP captura bridge complexity sem
// precisar L8 ainda (founder anticipation: 'deixar empirical
// evidence acumular antes de canonizar L8 adversarial-physical-
// evidence').
//
// Comparação ladder usage cross-BCs (empirical validation):
// - INV: L1/L2/L4 (structural-local)
// - CMT: L1+L2 base + L3+L4+L5+L6 (sc-cmt-02 peak) + L7 (supervision
//   gates) — structural+cross-BC mid-band
// - DLV: L1+L2+L3+L4+L5+L7 + RE-VAL forte — structural-rich +
//   temporal + finality + replay (bridge physical/financial)
// - REW: L5/L6/L7 forte (semanticamente contextual/adversarial-heavy)
//
// DLV usa o ladder MAIS AMPLO de todos (7/8 layers); valida progressive
// ladder per ADR-086 D2 — não checklist rígido, seletivamente aplicado
// per natureza do invariant.
//
// Behavioral non-applicability discipline (per adr-086 D6):
// DLV domain-model 14 invariants são TODAS structurally enforceable
// (com runtime gaps declarados onde aplicável); NENHUMA é behavioral
// pura (architectural review OR anti-corruption discipline).
// inv-replay-determinism é a entry mais próxima de "property-based"
// mas é structurally enforceable via aggregate construction discipline
// (replay determinism BY CONSTRUCTION, não by convention).
//
// Forbidden patterns são state/property prohibitions (não actions —
// per founder lint pattern: forbidden é proibição de ESTADO ou
// PROPRIEDADE, não de ação procedural).

structuralChecks: "sc-dlv-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-01"
	title:        "Identity Uniqueness domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification: a tupla (commitmentRef, evidenceRef) é storage identity unique. Duas Verifications NÃO podem coexistir com mesma identidade per BD2 IdempotencyIdentity. Identity refs DEVEM resolver a entidades existentes (não apenas string uniqueness; entity uniqueness verificável).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: commitmentRef + evidenceRef fields populated
		- L2 CROSS-FIELD: tuple uniqueness constraint per identity pair
		- L3 RESOLVABLE CONTRACT: commitmentRef resolves to existing Commitment (CMT) + evidenceRef resolves to existing EvidenceRecord (entity uniqueness, não apenas string)

		Layers non-applicable: L2.5, L4, L5, L6, L7
		Non-applicability rationale: invariant é identity discipline + reference resolution; sem adoption proof binding, sem version dependency (identity é timeless), sem freshness drift, sem interpretation coherence step, sem decision context scaling.

		RE-VAL: N/A (identity uniqueness é structural discipline; não evolui).

		War-game evidence (per adr-086 D5):
		Concurrent ingestion paths (primary API + manual ingestion + batch reconciliation) create duplicate Verifications under same (commitmentRef, evidenceRef) tuple via race conditions on retry scenarios; divergent outcomes emitted; downstream INV/REW reconciliation impossible (which Verification was authoritative?); 5yr audit retention forensics broken + Lei 12.846/SCD/CVM compliance exposure.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-identity-uniqueness"
		assertion: """
			∀ (commitmentRef, evidenceRef):
			  count(Verification where
			    Verification.commitmentRef == commitmentRef
			    ∧ Verification.evidenceRef == evidenceRef
			  ) ≤ 1
			∧ commitmentRef resolves to existing Commitment (CMT)
			∧ evidenceRef resolves to existing EvidenceRecord
			∧ identity tuple is canonical end-to-end
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Tuple uniqueness across instances + cross-aggregate reference resolution requires persistence layer enforcement; build-time pode declarar identity tuple structure em CUE schema mas NÃO prova instance uniqueness runtime. Validation-time lint cross-instance + runtime DB unique constraint + reference resolver."
			enforcedBy:  "database unique constraint on (commitmentRef, evidenceRef) tuple + event log dedup ancorado em identity + cross-aggregate reference resolver (resolve commitmentRef em CMT + evidenceRef em EvidenceRecord aggregate) + validation-time lint cross-instance"
		}
		forbidden: [
			"two Verification instances with same (commitmentRef, evidenceRef) tuple",
			"Verification with commitmentRef pointing to non-existent Commitment",
			"Verification with evidenceRef pointing to non-existent EvidenceRecord",
			"identity tuple reused after Verification cancellation (recycled identity)",
		]
	}
	errorMessage: "domain-invariant inv-identity-uniqueness: dup Verifications detectadas com mesma (commitmentRef, evidenceRef) tuple OR refs não resolvem. BD2 IdempotencyIdentity violado — replay safety + 5yr audit forensics quebrados. Verifique DB unique constraint + reference resolver para commitmentRef/evidenceRef."
	rationale:    "Materializa BD2 IdempotencyIdentity. L3 captura reference resolution beyond string uniqueness — entity-level identity verificável previne ataques via refs órfãs. Coverage F/T/T per founder ajuste: CUE não enforce tuple uniqueness build-time; persistence + reference resolver são runtime."
}

structuralChecks: "sc-dlv-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-02"
	title:        "CriteriaVersion as Attribute Not Identity domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification: criteriaVersion é ATTRIBUTE da decisão emitida, NÃO componente da identity tuple. Identity = (commitmentRef, evidenceRef) APENAS; criteriaVersion vive em fields. Decisão crítica V6 (BD2): incluir criteriaVersion na identity invalidaria verifications passadas em upgrade de criteria, quebrando economic finality + replay determinism.

		Layers ativos (per adr-086 D2):
		- L2 CROSS-FIELD: relation entre identity tuple e attribute set (criteriaVersion in fields, NOT in identity)
		- L4 VERSIONED: criteriaVersion é attribute versioned per decision; identity é version-independent

		Layers non-applicable: L1, L2.5, L3, L5, L6, L7
		Non-applicability rationale: invariant é schema design decision (where to place criteriaVersion); sem presence specific check (covered pela identity definition); sem adoption proof, contract resolution, freshness drift, interpretation coherence, decision context scaling.

		RE-VAL: N/A (schema discipline; não evolui).

		War-game evidence (per adr-086 D5):
		criteriaVersion accidentally placed in identity tuple via schema refactor — refactor team decides 'criteriaVersion should be canonical part of identity for tracking purposes'; upgrade de criteria invalidates entire historical Verifications corpus (forces cascade re-evaluation); economic finality broken (V6 contract); replay determinism broken (re-evaluated under new criteria produces divergent outcomes); 5yr audit trail invalidated.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-criteria-version-as-attribute"
		assertion: """
			∀ Verification:
			  identity tuple = (commitmentRef, evidenceRef) APENAS
			∧ criteriaVersion is field in Verification.payload
			    (NOT identity component)
			∧ schema declares identity structure explicit
			    (cannot drift criteriaVersion into identity via refactor)
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: false
		}
		forbidden: [
			"criteriaVersion included in identity tuple",
			"Verification identity changing when criteriaVersion bumps",
			"schema refactor moving criteriaVersion into identity components",
			"identity tuple drift across criteriaVersion upgrades",
		]
	}
	errorMessage: "domain-invariant inv-criteria-version-as-attribute: criteriaVersion detected in identity tuple OR identity drift across criteriaVersion bumps. V6 finality contract requires criteriaVersion-as-attribute (NOT identity). Verifique domain-model schema declaration identity = (commitmentRef, evidenceRef) ONLY."
	rationale:    "Materializa decisão crítica V6 BD2 — criteriaVersion-as-attribute preserva economic finality + replay determinism. Coverage T/T/F: build-time CUE schema declares identity structure; lint validates; runtime N/A (schema-enforced)."
}

structuralChecks: "sc-dlv-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-03"
	title:        "Identity Immutable Across State Transitions domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification: campos da identity (commitmentRef, evidenceRef) são immutable durante state transitions. State machine opera sobre identity fixa; aggregate não migra identity. Identity stability é precondition de audit trail consistency + replay determinism.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: commitmentRef + evidenceRef fields populated post-creation
		- L4 VERSIONED: write-once discipline post-creation (immutability)

		Layers non-applicable: L2, L2.5, L3, L5, L6, L7
		Non-applicability rationale: invariant é write-once structural-local; cross-field não aplica (single-field immutability); sem adoption proof binding, sem contract resolution discipline, sem freshness drift, sem interpretation coherence step, sem decision context scaling.

		RE-VAL: N/A (immutability é structural discipline; não evolui).

		War-game evidence (per adr-086 D5):
		Migration script "normalizes" commitmentRef format post-creation — operations team encounters legacy commitmentRef format ('CMT-2024-001' vs canonical 'cmt-001-2024'); migration script "fixes" format directly via SQL UPDATE bypassing aggregate write-once guard; audit trail corruption (which commitmentRef was the canonical reference?); supersession lineage broken (supersession references original format; verifications now have normalized format); 5yr audit forensics impossible.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-identity-immutable-across-state"
		assertion: """
			∀ Verification:
			  Verification.commitmentRef write-once post-creation
			∧ Verification.evidenceRef write-once post-creation
			∧ state transitions don't modify identity fields
			∧ no migration/refactor mutates identity in-place
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Build-time não vê histórico de Verification — não detecta mutation post-creation. Validation-time pode lint cross-instance comparando snapshots; runtime requer persistence layer write-once enforcement."
			enforcedBy:  "persistence layer write-once constraint on commitmentRef + evidenceRef fields + aggregate state-transition guards (reject any state change attempting identity mutation) + validation-time lint snapshot comparison"
		}
		forbidden: [
			"Verification.commitmentRef mutated post-creation",
			"Verification.evidenceRef mutated post-creation",
			"state transition modifying identity fields",
			"migration/refactor mutating identity in-place via direct DB write",
		]
	}
	errorMessage: "domain-invariant inv-identity-immutable-across-state: identity field mutation detected post-creation OR migration script bypassing write-once guard. Identity stability é precondition de audit trail + replay determinism. Verifique persistence write-once constraint + aggregate state-transition guards."
	rationale:    "Materializa identity stability para audit trail consistency + replay determinism. Coverage F/T/T: build-time não vê histórico; persistence write-once é runtime concern."
}

structuralChecks: "sc-dlv-04": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-04"
	title:        "Binary Outcome domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification em terminal state: outcome ∈ {verified, rejected}. NÃO existe terceiro estado terminal ('insufficient' é tratado como rejected + reasonCode=insufficient-evidence per BD1). RECTOR thesis-invariant: third state criaria ambiguidade operacional downstream (INV/REW/FCE precisam decidir ou esperar?).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: outcome field populated em terminal state
		- L2 CROSS-FIELD: enum membership constraint
		- L6 DECISION↔INTERPRETATION COHERENCE: consumers downstream (INV/REW/FCE) interpretam outcome de forma idêntica — binary semantics enforced; no partial decision pattern leak

		Layers non-applicable: L2.5, L3, L4, L5, L7
		Non-applicability rationale: invariant é structural-local enum + interpretation coherence; sem adoption proof binding, sem contract resolution discipline, sem version dependency (enum é timeless), sem freshness drift, sem decision context scaling.

		RE-VAL: N/A (enum é structural constant).

		War-game evidence (per adr-086 D5):
		Third state 'insufficient' leaked via partial decision pattern — operational pressure for 'incomplete verification needs more time' triggers ad-hoc terceiro state introduction; consumer INV waits indefinitely thinking decision pending; consumer REW computes risk on insufficient signal; consumer FCE rejects payment under different interpretation; cross-BC reconciliation diverges; macrofluxo single-source-of-truth violated (BD1).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-binary-outcome"
		assertion: """
			∀ Verification in terminal state:
			  outcome ∈ {verified, rejected}
			∧ no third terminal state exists in schema
			∧ insufficient evidence handled as rejected
			    with reasonCode=insufficient-evidence
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: false
		}
		forbidden: [
			"outcome outside {verified, rejected} in terminal state",
			"third terminal state introduced (e.g., 'insufficient', 'pending', 'partial')",
			"partial decision pattern leaking as intermediate terminal",
			"consumer downstream treating non-binary outcome via interpretation",
		]
	}
	errorMessage: "domain-invariant inv-binary-outcome: outcome outside binary {verified, rejected} detected OR third terminal state introduced. BD1 RECTOR thesis-invariant: insufficient é rejected + reasonCode=insufficient-evidence. Verifique CUE enum constraint + state machine declaration."
	rationale:    "Materializa BD1 RECTOR thesis-invariant + L6 interpretation coherence downstream. Coverage T/T/F: CUE enum constraint build-time; lint validates instances; runtime N/A (enum schema-enforced)."
}

structuralChecks: "sc-dlv-05": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-05"
	title:        "Rejected Requires Rationale domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo evt-delivery-rejected emit: reasonCode PRESENTE + retryPath PRESENTE (ambos mandatory per BD13). Silent rejection (rejected sem rationale auditável) é estruturalmente proibido. Cada rejeição é justificada categoricamente (reasonCode) + actionable (retryPath).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: reasonCode + retryPath fields populated em rejected emit
		- L2 CROSS-FIELD: rejection event MUST have both fields together (não one without other)

		Layers non-applicable: L2.5, L3, L4, L5, L6, L7
		Non-applicability rationale: invariant é anti-silent-rejection structural; sem adoption proof binding, sem contract resolution, sem version dependency, sem freshness drift, sem interpretation coherence step, sem decision context scaling.

		RE-VAL: N/A (presence discipline; não evolui).

		War-game evidence (per adr-086 D5):
		Silent rejection via system error path — emit handler encounters edge case (unexpected evidence format); falls back to generic rejection without reasonCode/retryPath; supplier sh-02 receives rejection sem rationale; cannot distinguish legitimate rejection from adversarial bias OR system glitch; fairness perception erosion + Bacen audit exposes opaque decisions in regulated credit context.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rejected-requires-rationale"
		assertion: """
			∀ evt-delivery-rejected:
			  reasonCode is PRESENT (non-null, non-empty)
			∧ retryPath is PRESENT (non-null, non-empty)
			∧ rejection event schema REQUIRES both fields
			    (CUE schema constraint when outcome=rejected)
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: false
		}
		forbidden: [
			"evt-delivery-rejected emit with reasonCode null OR empty",
			"evt-delivery-rejected emit with retryPath null OR empty",
			"silent rejection (rejected outcome without rationale fields)",
			"rejection schema permitting missing reasonCode/retryPath",
		]
	}
	errorMessage: "domain-invariant inv-rejected-requires-rationale: rejected emit sem reasonCode OR retryPath detected. BD13 anti-silent-rejection: cada rejeição é justificada (reasonCode) + actionable (retryPath). Verifique CUE schema constraint when outcome=rejected + emit handler validation."
	rationale:    "Materializa BD13 anti-silent-rejection. Coverage T/T/F: CUE schema can require fields when outcome=rejected; lint validates; runtime N/A once schema correct."
}

structuralChecks: "sc-dlv-06": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-06"
	title:        "RetryPath Deterministic Function domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo evt-delivery-rejected: retryPath é função determinística de (reasonCode, criteriaVersion-context, finality-state) via schema mapping table per BD13. NÃO atribuído arbitrariamente pelo executor; replay sob mesma timeline produz mesmo retryPath signal.

		Layers ativos (per adr-086 D2):
		- L3 RESOLVABLE CONTRACT: schema mapping table resolves (reasonCode, criteriaVersion-context, finality-state) → retryPath canonicalmente
		- L4 VERSIONED: mapping table is version-bound to criteriaVersion-context (function evolves with criteria upgrades)
		- L6 DECISION↔INTERPRETATION COHERENCE: replay under same timeline produces same retryPath signal; consumer downstream interprets retryPath identically (não executor-arbitrated)

		Layers non-applicable: L1, L2, L2.5, L5, L7
		Non-applicability rationale: invariant é deterministic function discipline; presence covered em sc-dlv-05 (rejected-requires-rationale); cross-field local (function inputs are local to rejection event); sem adoption proof, freshness drift, decision context scaling.

		RE-VAL: N/A (deterministic function discipline; mapping table evolution tracked via criteriaVersion).

		War-game evidence (per adr-086 D5):
		retryPath arbitrarily assigned by executor — emit handler implements 'helpful' heuristic guessing best retry path based on context analysis; different executor instances produce different retryPath signals for same (reasonCode, context); replay under same Event Log timeline produces divergent retryPath cascade; forensic audit cannot reconstruct retry decisions; supplier sh-02 receives inconsistent retry guidance across attempts.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-retry-path-deterministic"
		assertion: """
			∀ evt-delivery-rejected:
			  retryPath = f(reasonCode, criteriaVersion-context, finality-state)
			    via schema mapping table
			∧ f is deterministic function (same inputs → same retryPath)
			∧ mapping table is part of schema (NOT executor-arbitrated)
			∧ replay under same Event Log timeline
			    produces same retryPath signal
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "retryPath function execution + replay validation requires runtime. Build-time pode declarar mapping table em schema; runtime executor MUST apply table consistently (sem 'helpful' heuristics overriding); replay validation via property-based test."
			enforcedBy:  "schema mapping table declared em domain-model (deterministic function) + emit handler MUST execute table (refused via constraint to add arbitrary logic) + property-based replay test validating consistency cross-instance + validation-time lint cross-instance"
		}
		forbidden: [
			"retryPath arbitrarily assigned by executor (heuristic-based)",
			"retryPath divergent under replay (non-deterministic)",
			"mapping table bypass via inline logic in emit handler",
			"retryPath function dependent on runtime state outside (reasonCode, criteriaVersion-context, finality-state) inputs",
		]
	}
	errorMessage: "domain-invariant inv-retry-path-deterministic: retryPath arbitrarily assigned OR replay produces divergent signal. BD13 replay-safety exige deterministic function via schema mapping table. Verifique mapping table declaration em schema + emit handler MUST execute table + property-based replay test."
	rationale:    "Materializa BD13 replay-safety. L3+L4+L6: schema mapping resolvable + version-bound + interpretation coherence cross-instance. Coverage F/T/T per founder ajuste: build-time declares mapping table; runtime executor applies; replay validates."
}

structuralChecks: "sc-dlv-07": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-07"
	title:        "Verified Requires Evidence Or Emergency Override domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo evt-delivery-verified emit: ∃ EvidenceRecord precedente para mesma identity (commitmentRef, evidenceRef) OR ∃ supervisedDecision approve-with-emergency-override autorizado per BD7. Verified NUNCA emerge silenciosamente sem evidence ou override. Anti-fraude estrutural RECTOR-adjacent: bloqueia classe de bugs por construção.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: EvidenceRecord OR override authorization present em event log
		- L2 CROSS-FIELD: verified emit MUST cross-reference one of (EvidenceRecord OR override authorization)
		- L3 RESOLVABLE CONTRACT: EvidenceRecord OR override authorization resolves to existing entity (not phantom reference)

		Layers non-applicable: L2.5, L4, L5, L6, L7
		Non-applicability rationale: invariant é anti-fraude presence + cross-reference resolution; sem adoption proof binding, sem version dependency (evidence é point-in-time), sem freshness drift, sem interpretation coherence step (binary check), sem decision context scaling.

		RE-VAL: N/A (point-in-time check; once verified emitted, evidence chain immutable).

		War-game evidence (per adr-086 D5):
		Verified emitted silently via timeout — emit handler has timeout fallback that emits 'default verified' when evidence query times out (operational convenience); subsequent INV invoice + REW risk evaluation + FCE payment cascade triggered on phantom verification; no EvidenceRecord exists; auditor reconstructs via forensics: 'how was this verified?'; anti-fraude breach (RECTOR-adjacent); Bacen audit exposes phantom verifications + regulatory liability + Lei 12.846 corruption exposure (potential evidence fabrication).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-verified-requires-evidence-or-override"
		assertion: """
			∀ evt-delivery-verified:
			  ∃ EvidenceRecord(commitmentRef, evidenceRef)
			    precedente in event log
			  OR ∃ supervisedDecision(type=approve-with-emergency-override)
			    authorized + referenced em verified emit
			∧ verified emit references one of these sources
			∧ no verified emerges via timeout/default/inference/race
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Evidence record presence + override authorization resolution requires event log query + cross-aggregate reference resolver at emit time. Build-time não vê event log; runtime gate at emit handler MUST verify one source exists + reference resolvable."
			enforcedBy:  "emit handler guard pre-verified-emit (refuse emit sem evidence record resolved OR override authorization resolved) + event log auditor (validation-time advisory) + verificationMetric tripwire 'verified-without-evidence-or-override-attempts' = 0 (any non-zero is critical bug)"
		}
		forbidden: [
			"evt-delivery-verified emit without precedent EvidenceRecord AND without override authorization",
			"verified emit via timeout fallback (default-verified pattern)",
			"verified emit via inference (e.g., 'context suggests verification ok')",
			"verified emit via race condition (concurrent emit before evidence persisted)",
			"override authorization reference pointing to non-existent OR revoked supervisedDecision",
		]
	}
	errorMessage: "domain-invariant inv-verified-requires-evidence-or-override: verified emit detected sem precedent EvidenceRecord AND sem override authorization. BD7 anti-fraude estrutural — verified NUNCA emerge silenciosamente. Verifique emit handler guard + event log para EvidenceRecord precedente + verificationMetric tripwire = 0."
	rationale:    "Materializa BD7 + anti-fraude RECTOR-adjacent. Coverage F/T/T: event log query + cross-aggregate reference resolver são runtime; verificationMetric tripwire é canonical defense-in-depth detector."
}

structuralChecks: "sc-dlv-08": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-08"
	title:        "Post-Finality No Autonomous Emit domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification com finalityReached=true: emit de superseding Verification AUTONOMAMENTE é PROHIBITED per BD8. Superseding pós-finality requer caminho controlado: supervisedDecision approve-post-finality-supersession (path A) OR DRC-driven correction (path B Phase 1+). finalityReached é flag estrutural (NÃO depende de 'now > finalityAt' runtime).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: finalityReached flag populated em Verification
		- L2 CROSS-FIELD: supersession emit guard checks finalityReached + authority reference
		- L7 DECISION CONTEXT: post-finality supersession decision scope (cascade economic impact downstream INV/REW/FCE/DRC; magnitude regulatory/financial)

		Layers non-applicable: L2.5, L3, L4, L5, L6
		Non-applicability rationale: invariant é authority gate enforcement; sem adoption proof binding, sem cross-BC contract resolution (intra-DLV discipline), sem version dependency (finality é flag-based), sem freshness drift (finality é binary), sem interpretation coherence step.

		RE-VAL: Yes — periodic audit catches autonomous post-finality emits via event log forensics; supersession lineage cross-references authority chain.

		War-game evidence (per adr-086 D5):
		Agent autonomously emits supersession post-finality — agent receives new evidence signal for verified-then-finalized commitment; agent reasons 'evidence corrects prior decision'; emits supersession autonomously without supervisedDecision authority; economic contract instability cascade — downstream INV/REW/FCE/DRC already settled on original finality; supersession invalidates settled positions; reconciliation impossible + financial loss + regulatory liability + cascade DRC dispute resolution.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-post-finality-no-autonomous-emit"
		assertion: """
			∀ Verification with finalityReached == true:
			  no autonomous supersession emit permitted
			∧ supersession emit requires:
			    supervisedDecision(approve-post-finality-supersession)
			    OR DRC-driven correction (Phase 1+)
			∧ supersession emit references authority chain
			    (supervisedDecision.id OR DRC correction reference)
			∧ finalityReached is flag (NOT 'now > finalityAt' computed)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Aggregate guard pre-supersession-emit requires runtime check of finalityReached + authority resolution. Build-time pode declarar finalityReached flag; runtime emit handler MUST verify authority chain present."
			enforcedBy:  "aggregate emit handler guard pre-supersession (refuse autonomous emit when finalityReached=true sem authority chain resolved) + event log auditor (validation-time advisory) + RE-VAL periodic audit catching autonomous patterns + supervisedDecision aggregate enforcement (CMT)"
		}
		forbidden: [
			"supersession emit when finalityReached=true sem supervisedDecision authority chain",
			"agent autonomously emitting supersession post-finality",
			"finalityReached computed runtime via 'now > finalityAt' instead of flag",
			"authority reference pointing to non-existent OR revoked supervisedDecision",
		]
	}
	errorMessage: "domain-invariant inv-post-finality-no-autonomous-emit: autonomous supersession emit detected post-finality OR authority chain missing. BD8 hard line preserva finality forte como contrato econômico. Verifique aggregate emit guard + supervisedDecision authority chain + RE-VAL periodic audit."
	rationale:    "Materializa BD8 finality contract preservation. L7 captura decision context (cascade economic impact downstream INV/REW/FCE/DRC). RE-VAL essential porque autonomous emit pode escape guards momentaneamente; periodic audit é defense-in-depth."
}

structuralChecks: "sc-dlv-09": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-09"
	title:        "FinalityAt Computed domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification em terminal state: finalityAt = decidedAt + 30 days (Phase 0 hard-coded; parameterização per criteria type Phase 1+ via oq-dlv-2). Computed field, NÃO arbitrariamente assigned. Window calibration centralized via single computation rule.

		Layers ativos (per adr-086 D2):
		- L2 CROSS-FIELD: relation entre decidedAt + finality policy + computed finalityAt
		- L4 VERSIONED: finality policy version-bound (Phase 0 = 30d; Phase 1+ parameterizable per criteria)
		- L5 FRESHNESS HEURISTIC: finalityAt defines temporal window (decidedAt + 30d is freshness boundary for supersession)

		Layers non-applicable: L1, L2.5, L3, L6, L7
		Non-applicability rationale: presence covered em terminal state guarantee; sem adoption proof binding, sem cross-BC contract resolution (finality policy é intra-DLV), sem interpretation coherence step (computation é deterministic), sem decision context scaling.

		RE-VAL: Yes — periodic audit re-validates finalityAt computed correctly across terminal transitions; catches drift via timezone bugs, migration scripts, policy version updates.

		War-game evidence (per adr-086 D5):
		finalityAt drift via timezone bug — server fleet across regions; one region uses local timezone for decidedAt; another uses UTC; finalityAt computation produces inconsistent values (30d in local vs UTC); supersession admissibility ambiguous (when does window close?); audit forensics show finalityAt values that don't match decidedAt + 30d exactly; cascade BD8 enforcement weakens (autonomous post-finality emits slip through inconsistent windows).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-finality-at-computed"
		assertion: """
			∀ Verification in terminal state:
			  finalityAt == decidedAt + finalityWindow(criteriaVersion)
			∧ finalityWindow(criteriaVersion) is computed function
			    (Phase 0: 30d hard-coded; Phase 1+ parameterizable)
			∧ finalityAt is NOT arbitrarily assigned
			∧ timezone discipline canonical (UTC OR explicit timezone-aware)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Datetime arithmetic + policy lookup + computation at terminal transition. Build-time não pode validate computation correctness em instances; runtime requires policy lookup + arithmetic + timezone consistency."
			enforcedBy:  "aggregate state-machine guard at terminal transition (compute finalityAt via policy function) + persistence layer write-once on finalityAt + RE-VAL periodic audit comparing finalityAt vs decidedAt + finalityWindow(criteriaVersion) + timezone canonical enforcement"
		}
		forbidden: [
			"finalityAt arbitrarily assigned (not computed from decidedAt + window)",
			"finalityAt drift from decidedAt + finalityWindow",
			"finalityAt computed under inconsistent timezone (e.g., local vs UTC mixed)",
			"finalityAt mutated post-terminal-transition",
		]
	}
	errorMessage: "domain-invariant inv-finality-at-computed: finalityAt arbitrarily assigned OR drift from decidedAt + finalityWindow detected. Window calibration MUST be centralized via computation rule. Verifique aggregate guard at terminal transition + timezone canonical + RE-VAL periodic audit."
	rationale:    "Materializa centralized window calibration (BD8 dependency). L5 captura temporal freshness — finalityAt is freshness boundary for supersession admissibility. RE-VAL essential per founder ajuste — drift via timezone/migration/policy updates é real risk."
}

structuralChecks: "sc-dlv-10": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-10"
	title:        "Exception Cumulative Cap 30 Days domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification: cumulative duration de exceptionHistory desde firstEntry.timestamp até terminalEntry.timestamp ≤ 30 dias (cap absoluto BD6). Extensions cumulativas adicionam tempo ao timer existente; NÃO reiniciam o relógio do primeiro entry. P2 BOUNDED principle materialização: founder pode estender mas com cap absoluto.

		Layers ativos (per adr-086 D2):
		- L5 FRESHNESS HEURISTIC: cumulative duration is temporal bound from firstEntry.timestamp
		- L7 DECISION CONTEXT: bounded blast radius decision (founder authority bounded; cap absoluto preserves system-level guarantee)

		Layers non-applicable: L1, L2, L2.5, L3, L4, L6
		Non-applicability rationale: invariant é temporal cap discipline + decision context bound; presence + cross-field structures covered em sc-dlv-11/12 (companion exception invariants); sem adoption proof, contract resolution, version dependency, interpretation coherence step.

		RE-VAL: Yes — periodic audit catches cap bypass via extension stacking pattern (multiple small extensions adding to > 30d cumulative).

		War-game evidence (per adr-086 D5):
		Cumulative cap bypass via extension stacking — founder authorized initial 14d exception; needs extending; instead of single extension to e.g. 25d, splits into 3 extensions of 5d each (15d → 20d → 25d → 30d → potentially > 30d); cumulative counter naively resets per extension OR each extension adds to timer; cumulative reaches 35d undetected; bounded blast radius violated (BD6 cap absoluto); P2 BOUNDED principle compromised.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-exception-cumulative-cap"
		assertion: """
			∀ Verification:
			  cumulative_duration(exceptionHistory)
			    from firstEntry.timestamp
			    to terminalEntry.timestamp (OR now if open)
			  ≤ 30 days
			∧ extensions ADD to cumulative timer
			    (NOT reset cumulative counter)
			∧ founder authority bounded by cap absoluto
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cumulative duration computation across exception entries requires event log query at extension attempt + active exception state. Build-time não vê histórico; runtime guard pre-extension MUST sum durations + check cap."
			enforcedBy:  "aggregate guard pre-extension (compute cumulative from firstEntry.timestamp + reject if exceeds 30d) + persistence layer write-once on cumulative_duration field + RE-VAL periodic audit catching extension stacking patterns"
		}
		forbidden: [
			"cumulative_duration > 30 days from firstEntry.timestamp",
			"extension resetting cumulative counter (treating extensions as fresh timers)",
			"extension stacking pattern (multiple small extensions adding to > 30d cumulative)",
			"cumulative counter computed from latest entry instead of firstEntry",
		]
	}
	errorMessage: "domain-invariant inv-exception-cumulative-cap: cumulative duration > 30 days detected OR extension stacking pattern bypassing cap. BD6 cap absoluto + P2 BOUNDED — founder authority bounded por cap. Verifique aggregate guard pre-extension + RE-VAL periodic audit."
	rationale:    "Materializa P2 BOUNDED + BD6 cap absoluto. L7 captura decision context (founder authority bounded — fundamental Mesh discipline). RE-VAL essential porque extension stacking é gradual escape pattern detectable apenas via periodic audit."
}

structuralChecks: "sc-dlv-11": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-11"
	title:        "At Most One Active Exception domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification: at most ONE entry em exceptionHistory sem resolvedAt at any time (estado vigente único per BD6 — exception-during-exception proibido por construção). Estado único + exceptionHistory append-only preserva granularidade temporal sem permitir explosão de estado.

		Layers ativos (per adr-086 D2):
		- L2 CROSS-FIELD: state singularity constraint (at most one entry without resolvedAt)

		Layers non-applicable: L1, L2.5, L3, L4, L5, L6, L7
		Non-applicability rationale: invariant é state singularity structural; presence covered em sc-dlv-12 (exception timer entry); sem adoption proof binding, contract resolution, version dependency, freshness drift, interpretation coherence step, decision context scaling.

		RE-VAL: N/A (state singularity é structural discipline; não evolui).

		War-game evidence (per adr-086 D5):
		Concurrent exceptions registered via race — two exception entry commands arrive concurrently (founder operating from different UI tabs); race condition creates two entries without resolvedAt; aggregate state ambiguous (which exception is canonical?); resolution path undefined (which resolution clears which entry?); BD6 single-vigent-state violated; downstream consumers see ambiguous exception state.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-at-most-one-active-exception"
		assertion: """
			∀ Verification:
			  count(exceptionHistory entries where resolvedAt is null) ≤ 1
			∧ exceptionHistory is append-only
			∧ state is deterministic projection from latest entry without resolvedAt
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "State singularity check across exception entries requires runtime atomic check at extension/entry attempt. Build-time não vê histórico; persistence layer atomic check via aggregate guard."
			enforcedBy:  "aggregate guard pre-exception-entry (check no existing entry without resolvedAt before creating new) + persistence layer atomic operation (transactional insert with constraint check) + validation-time lint cross-instance"
		}
		forbidden: [
			"exceptionHistory with multiple entries without resolvedAt at any time",
			"exception-during-exception state (new entry created before previous resolved)",
			"exceptionHistory mutated in-place (must be append-only)",
			"aggregate state derived from arbitrary entry instead of latest unresolved",
		]
	}
	errorMessage: "domain-invariant inv-at-most-one-active-exception: multiple exception entries without resolvedAt detected OR exception-during-exception state. BD6 single-vigent-state. Verifique aggregate guard pre-exception-entry + persistence atomic operation."
	rationale:    "Materializa BD6 single-vigent-state preservation. L2 dominant: state singularity é cross-field count constraint. Aggregate guard + atomic persistence preserve discipline runtime."
}

structuralChecks: "sc-dlv-12": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-12"
	title:        "Exception Timer Mandatory Transition domain invariant"
	artifactType: "domain-model"
	description: """
		Para todo aggregate Verification entrando em exception-pending state: terminal transition (verified | rejected) mandatory dentro de 14 dias desde firstEntry.timestamp (Phase 0 hard-coded; Phase 1+ parameterizable per oq-dlv-7). Auto-rejection forçada com reasonCode=exception-unresolved-timeout per BD6 fail-safe forward motion.

		Layers ativos (per adr-086 D2):
		- L5 FRESHNESS HEURISTIC: 14-day timer is temporal freshness bound from firstEntry.timestamp
		- L7 DECISION CONTEXT: fail-safe decision (rejected NOT verified — P5 anti-paralysis without compromising anti-fraud invariant)

		Layers non-applicable: L1, L2, L2.5, L3, L4, L6
		Non-applicability rationale: invariant é temporal + fail-safe discipline; presence covered em sc-dlv-11 (exception entry); cross-field state machine covered em other rules; sem adoption proof binding, contract resolution, version dependency, interpretation coherence step.

		RE-VAL: Yes — periodic timer audit catches exceptions exceeding 14d without auto-rejection trigger.

		War-game evidence (per adr-086 D5):
		Indefinite exception via missed timer — exception entry created; auto-rejection trigger logic has bug (timer not started OR resolution incorrect); 14d passes silently; exception remains pending indefinitely; financial cascade blocked (INV cannot proceed without verification outcome); P5 anti-paralysis violated; sistema declara obrigação fail-safe mas não detecta exception vencida; supplier sh-02 blocked indefinitely + cascade economic damage.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-exception-timer-mandatory"
		assertion: """
			∀ Verification entering exception-pending state:
			  terminal transition (verified | rejected) MUST occur
			    within 14 days from firstEntry.timestamp
			∧ if 14d elapsed without resolution:
			    auto-rejection forced with
			    reasonCode=exception-unresolved-timeout
			∧ fail-safe is rejected (NOT verified — P5 anti-paralysis
			    without compromising anti-fraud)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "14-day timer + auto-rejection trigger requires runtime scheduler + datetime arithmetic. Build-time não pode enforce temporal triggers; runtime scheduler MUST track exception entries + fire auto-rejection at 14d boundary."
			enforcedBy:  "aggregate timer scheduler (track exception-pending entries + fire auto-rejection at 14d from firstEntry.timestamp) + RE-VAL periodic timer audit catching exceptions exceeding 14d without auto-rejection + monitoring alert on timer drift"
		}
		forbidden: [
			"exception-pending state persisting > 14 days without terminal transition",
			"auto-rejection NOT triggered at 14d boundary",
			"timer started from wrong timestamp (not firstEntry.timestamp)",
			"fail-safe being verified instead of rejected (anti-fraud invariant compromised)",
		]
	}
	errorMessage: "domain-invariant inv-exception-timer-mandatory: exception-pending > 14 days detected without auto-rejection. P5 anti-paralysis fail-safe — preserve forward motion sob indecisão humana. Verifique aggregate timer scheduler + RE-VAL periodic audit + monitoring alert."
	rationale:    "Materializa P5 anti-paralysis fail-safe + BD6. L7 captura fail-safe decision context (rejected NOT verified — preserva anti-fraud while preventing paralysis). RE-VAL essential per founder ajuste — timer audit é defense-in-depth contra scheduler bugs."
}

structuralChecks: "sc-dlv-13": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-13"
	title:        "Supersession Ordering Canonical domain invariant"
	artifactType: "domain-model"
	description: """
		Para toda supersession (evt-supersession-applied): ordering canonical via eventLogOffset(supersedingEvidenceRef) > eventLogOffset(supersededEvidenceRef), com hash tie-breaker (SHA-256 lexicographic) se offsets equal. Globally deterministic per BD5. Replay-safety + idempotency: ordering ancorada em Event Log offset elimina race conditions cross-ingestion-paths.

		Layers ativos (per adr-086 D2):
		- L2 CROSS-FIELD: ordering relation between superseding + superseded refs
		- L3 RESOLVABLE CONTRACT: refs resolve to Event Log entries (offset query); supersession lineage navigable via prj-evidence-lineage projection
		- L4 VERSIONED: ordering canonical via Event Log offset (monotonic versioning) + hash tie-breaker (deterministic version selector)

		Layers non-applicable: L1, L2.5, L5, L6, L7
		Non-applicability rationale: presence covered em sc-dlv-01 (identity uniqueness); sem adoption proof binding, freshness drift (ordering é monotonic timeless), interpretation coherence step, decision context scaling.

		RE-VAL: Yes — replay verifies ordering canonical across executions; periodic audit catches ordering inconsistencies.

		War-game evidence (per adr-086 D5):
		Race condition cross-ingestion paths produces tie offsets — multiple ingestion paths (API + batch) submit evidence concurrently; Event Log assigns identical offsets (single-writer assumption violated in distributed deployment); without SHA-256 lexicographic tie-breaker, ordering ambiguous; supersession chain inconsistent (which is superseding?); replay under same Event Log produces divergent outcomes; BD5 globally deterministic violated.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-supersession-ordering"
		assertion: """
			∀ supersession (evt-supersession-applied):
			  eventLogOffset(supersedingEvidenceRef)
			    > eventLogOffset(supersededEvidenceRef)
			∧ if offsets equal:
			    SHA-256(supersedingEvidenceRef) lexicographic_>
			    SHA-256(supersededEvidenceRef)
			∧ ordering is globally deterministic across replays
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Event Log offset comparison + hash tie-breaker computation requires runtime query + cryptographic hash function. Build-time não vê Event Log; runtime ordering enforcer pre-supersession emit MUST execute offset comparison + tie-breaker."
			enforcedBy:  "aggregate ordering enforcer pre-supersession-emit (compute eventLogOffset(refs) + apply SHA-256 tie-breaker if equal) + prj-evidence-lineage projection materializes ordering canonical for queries + RE-VAL replay verifies ordering canonical"
		}
		forbidden: [
			"supersession with reversed offset ordering",
			"tie offsets without SHA-256 lexicographic tie-breaker resolution",
			"supersession ordering computed via wall-clock time instead of Event Log offset",
			"supersession chain inconsistent across replays (non-deterministic ordering)",
		]
	}
	errorMessage: "domain-invariant inv-supersession-ordering: supersession ordering violation detected (reversed offsets OR tie unresolved). BD5 globally deterministic exige Event Log offset + hash tie-breaker. Verifique aggregate ordering enforcer + prj-evidence-lineage projection + RE-VAL replay validation."
	rationale:    "Materializa BD5 globally deterministic ordering. L2+L3+L4 captura cross-field ordering + projection resolution + monotonic versioning via Event Log offset. RE-VAL intrinsic porque replay determinism depends on ordering canonical."
}

structuralChecks: "sc-dlv-14": artifact_schemas.#StructuralCheck & {
	id:           "sc-dlv-14"
	title:        "Replay Determinism domain invariant"
	artifactType: "domain-model"
	description: """
		Para toda execução de replay sobre mesmo Event Log até offset K: produz mesma Verification state at offset K. Property-based test verificável: ∀ replay execution sob mesma timeline → mesmo outcome. Precondition de forensic audit Lei 12.846/SCD/CVM (5 anos retention) + DRC dispute resolution.

		Layers ativos (per adr-086 D2):
		- L2 CROSS-FIELD: replay state at offset K matches across executions (cross-execution comparison)
		- L3 RESOLVABLE CONTRACT: referenced events resolve consistently (Event Log offset access stable)
		- L4 VERSIONED: replay versions reproduce identical outcomes (replay determinism by construction)

		Layers non-applicable: L1, L2.5, L5, L6, L7
		Non-applicability rationale: presence covered em other rules; sem adoption proof binding, freshness drift, interpretation coherence step, decision context scaling.

		RE-VAL: Yes (INTRINSIC — invariant IS replay determinism; property-based test is RE-VAL by construction).

		War-game evidence (per adr-086 D5):
		Replay produces divergent state under same Event Log timeline — emit handler has non-deterministic behavior (e.g., uses system time, random salt, parallel concurrent operations with non-deterministic ordering); replay over Event Log K produces State_replay != State_original at offset K; forensic audit Lei 12.846/SCD/CVM broken (cannot reconstruct historical decisions); DRC dispute resolution impossible (which state was authoritative at dispute time?); 5yr retention requirement violated; regulatory liability + Bacen audit exposure.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-replay-determinism"
		assertion: """
			∀ replay execution over Event Log up to offset K:
			  produces Verification state State_K identical to original execution
			∧ replay determinism by construction (aggregate code deterministic)
			∧ no system-time, random salt, non-deterministic parallelism
			∧ property-based test verifiable:
			    ∀ replay timeline → same outcome
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Replay execution + outcome comparison requires runtime replay engine + property-based test. Build-time não pode prove determinism em general (halting problem); validation-time property-based test catches concrete divergences; runtime replay engine MUST be deterministic by construction."
			enforcedBy:  "aggregate code review (deterministic-by-construction discipline: no system-time, no random salt, no non-deterministic parallelism) + property-based replay test (validation-time) + RE-VAL replay engine periodic verification across event log offsets"
		}
		forbidden: [
			"aggregate code using system-time directly (non-deterministic)",
			"aggregate code using random salt without seed control",
			"aggregate code with non-deterministic parallel operations",
			"replay producing State_replay != State_original at offset K",
			"event handlers depending on runtime state outside Event Log",
		]
	}
	errorMessage: "domain-invariant inv-replay-determinism: replay producing divergent state detected OR aggregate code using non-deterministic primitives. Forensic audit Lei 12.846/SCD/CVM (5yr retention) + DRC dispute resolution exigem replay determinism. Verifique aggregate code review + property-based test + RE-VAL replay verification."
	rationale:    "Materializa replay determinism fundamental — precondition de forensic audit + DRC dispute. L4+RE-VAL intrinsic: replay determinism IS the invariant; property-based test IS RE-VAL. Aggregate construction discipline (deterministic-by-construction) preserves invariant by design."
}
