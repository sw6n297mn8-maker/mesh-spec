package economic_model

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// mesh-economic-assumptions.cue — First instance of #EconomicAssumptionModel.
// Materializes Layer -1 (Economic Reality Layer) per ADR-082.
//
// 9 reality invariants (ri-01..09) + 3 adversarial capabilities + 9 system
// implications. Sistema declara canonicamente realidades do ambiente
// adversarial onde opera; sistema deve sobreviver APESAR delas.
//
// Pós-R4+ founder adversarial review (3 mandatory corrections aplicadas):
//   (R4+-1) ri-01 absolute language: "marginal cost approaching zero"
//     → "cost does not constitute reliable limiting factor" (gradient
//     language eliminado per tq-eam-01)
//   (R4+-2) ri-07 NEW: cross-BC composition exploitation reality
//     (A7 critical gap addressed)
//   (R4+-3) ri-08 NEW: payoff asymmetry reality (A8 critical gap
//     addressed)
//   (R4+-4) imp-08 net-vs-gross outcome evaluation (recommended
//     refinement applied)
//   imp-07 + imp-08 added correspondingly tracing ri-07/ri-08.
//
// Pós-R4++ founder attack-driven adversarial validation (Round 2 SRR):
//   (R4++-1) ri-09 NEW: misaligned incentives reality — actors optimize
//     for private payoff; alignment with system-level outcomes is NOT
//     default. End-to-end attack scenario "Loop de extração colusivo
//     multi-BC" demonstrated payoff_privado > 0 com impacto_sistêmico
//     < 0 achievable via formally valid actions only — ri-09 captures
//     the central reality this proves.
//   (R4++-2) imp-09 NEW: mechanisms must produce incentive alignment
//     BY DESIGN; alignment cannot be assumed (NÃO emergent property).
//   Pattern emergente per Round 2 schema SRR falsifiability discipline:
//   schema's empirical incompleteness discovered via adversarial review
//   → refinement is EPISTEMIC (reality discovery), not architectural.
//
// Mechanism-level concerns (when attack pays vs costs; system auto-
// protection mechanisms; v2 mechanism upgrades U1-U4 from R4++ SRR
// Round 2) deferred para economic-mechanism-model.cue future artifact
// (NIM bootstrap).

economicModel: artifact_schemas.#EconomicAssumptionModel & {
	realityInvariants: [{
		id: "ri-01"
		statement: """
			Arbitrarily many economically low-value but formally valid
			transactions are achievable within the system at any time; the
			cost of generating additional valid transactions does not
			constitute a reliable limiting factor.
			"""
		rationale: "Validity of transaction does not imply economic substance; cost cannot be relied upon as a constraint."
	}, {
		id: "ri-02"
		statement: """
			Historical performance of a participant is not a stable predictor
			of future behavior.
			"""
		rationale: "Captures adverse selection and behavioral drift."
	}, {
		id: "ri-03"
		statement: """
			Mutual consistency between participant signals does not imply
			economic truth.
			"""
		rationale: "Captures collusion without explicit contradiction."
	}, {
		id: "ri-04"
		statement: """
			Assets derived from valid transactions are subject to reuse,
			transfer, and leverage across time and counterparties.
			"""
		rationale: "Captures receivable reuse and implicit leverage."
	}, {
		id: "ri-05"
		statement: """
			Information propagation across system components is
			non-instantaneous and exploitable.
			"""
		rationale: "Captures latency arbitrage."
	}, {
		id: "ri-06"
		statement: """
			Participants optimize their behavior to maximize outcomes under
			the system's explicit rules.
			"""
		rationale: "Captures specification gaming."
	}, {
		id: "ri-07"
		statement: """
			Correctness within any single bounded context does not imply
			correctness of the system under composition; interactions between
			contexts generate behaviors not constrained by individual context
			invariants.
			"""
		rationale: "Cross-context interactions introduce behaviors that cannot be inferred from local invariants alone."
	}, {
		id: "ri-08"
		statement: """
			The system admits action sequences that concentrate upside while
			externalizing downside; payoff asymmetry is structurally
			achievable under formally valid operations.
			"""
		rationale: "Valid operations can produce asymmetric payoff structures that concentrate gains and distribute losses."
	}, {
		id: "ri-09"
		statement: """
			Actors within the system optimize for private payoff, and such
			optimization is not aligned with system-level outcomes by default.
			"""
		rationale: "System participants act under local incentive optimization, which can produce globally harmful outcomes even when all actions are formally valid."
	}]

	adversarialCapabilities: [{
		id: "cap-adv-01"
		statement: """
			Participants can repeat actions at scale with minimal marginal
			cost.
			"""
		rationale: "Enables farming and pattern exploitation."
	}, {
		id: "cap-adv-02"
		statement: """
			Participants can change behavior faster than system models adapt.
			"""
		rationale: "Enables regime shift exploitation."
	}, {
		id: "cap-adv-03"
		statement: """
			Participants can observe and learn system rules and optimize
			against them.
			"""
		rationale: "Enables strategic gaming."
	}]

	systemImplications: [{
		id: "imp-01"
		statement: """
			System correctness cannot rely solely on transaction validity.
			"""
		derivedFrom: ["ri-01"]
		rationale: "Valid transactions are not sufficient evidence of economic substance."
	}, {
		id: "imp-02"
		statement: """
			Any scoring or trust model must account for temporal decay and
			behavioral shifts.
			"""
		derivedFrom: ["ri-02"]
		rationale: "Past behavior cannot be treated as stationary."
	}, {
		id: "imp-03"
		statement: """
			System trust cannot assume independence between participants.
			"""
		derivedFrom: ["ri-03"]
		rationale: "Collusion breaks independent validation assumptions."
	}, {
		id: "imp-04"
		statement: """
			System must track asset lineage across transformations and
			ownership changes.
			"""
		derivedFrom: ["ri-04"]
		rationale: "Prevents hidden leverage and reuse exploitation."
	}, {
		id: "imp-05"
		statement: """
			All decisions must be robust to delayed or inconsistent
			information.
			"""
		derivedFrom: ["ri-05"]
		rationale: "Latency is inherent and exploitable."
	}, {
		id: "imp-06"
		statement: """
			Mechanisms must be robust to strategic behavior, not just
			compliant behavior.
			"""
		derivedFrom: ["ri-06"]
		rationale: "Participants optimize against rules, not intent."
	}, {
		id: "imp-07"
		statement: """
			System safety cannot rely on individual bounded-context validation
			alone; cross-context composition risk requires network-level
			analysis.
			"""
		derivedFrom: ["ri-07"]
		rationale: "Single-BC invariants são insuficientes para safety global; análise composicional cross-BC é mandatory (NIM responsibility Phase 1+)."
	}, {
		id: "imp-08"
		statement: """
			System mechanisms must evaluate outcomes in net terms rather than
			gross terms; optimization based solely on positive flows is
			structurally exploitable.
			"""
		derivedFrom: ["ri-08"]
		rationale: "Gross-only evaluation ignores asymmetric downside exposure."
	}, {
		id: "imp-09"
		statement: """
			System mechanisms must produce incentive alignment by design;
			alignment between private payoff and system-level outcomes
			cannot be assumed.
			"""
		derivedFrom: ["ri-09"]
		rationale: "Mecanismos que assumem alinhamento implícito entre payoff privado e sistêmico falham por construção; alignment é design responsibility (mechanism design), NÃO emergent property."
	}]
}
