package nim

// glossary.cue — Ubiquitous Language: Network Intelligence & Mechanism Design.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// =============================================================================
// IDENTITY CANONICAL — GLOSSARY AS SEMANTIC GOVERNANCE INFRASTRUCTURE
// =============================================================================
//
// NIM glossary é semantic containment layer for epistemic authority
// vocabulary — NÃO terminology dictionary. Cada termo canoniza
// concept cuja semantic ambiguity vira authority leakage operacional.
// Vocabulário é primary attack surface (drift começa na linguagem
// → métrica → override → colapso ontológico per founder framing
// inheritance).
//
// Glossary é outra categoria de artifact per founder Phase 2.0:
// preserva visibility de legitimacy accumulation trajectories +
// active semantic containment mechanism + meta-imune layer
// protegendo o próprio sistema imune.
//
// =============================================================================
// FAMILY MESH INHERITANCE + META-CONSTITUTIONAL EXTENSION
// =============================================================================
//
// FCE glossary: boundary-hardening artifact for conditional economic
//               authority.
// NTF glossary: boundary-hardening artifact for communication
//               guarantee admissibility.
// NIM glossary: boundary-hardening artifact for epistemic authority
//               vocabulary + meta-defense against semantic gravity
//               vectors.
//
// =============================================================================
// 6 CENTERING PRINCIPLES CP1-CP6
// =============================================================================
//
// CP1 — Anti-synonym collapse (apparently redundant terms são
//       distinct ontological vectors)
// CP2 — Anti-optimization euphemism (optimization-flavored terms
//       carry covert authority semantics)
// CP3 — Anti-objectivity theater (truth-claim terms forbidden em
//       mechanism output vocabulary)
// CP4 — Anti-engagement-language drift (engagement-flavored terms
//       carry behavioral gravity)
// CP5 — Anti-authority-euphemism (authority-disguising terms hide
//       authority assertion as descriptive property)
// CP6 — Anti-legitimacy-naturalization (repeated usage gradually
//       naturalizes epistemic authority — glossary preserves
//       visibility of legitimacy accumulation trajectories)
//
// =============================================================================
// 6 CLUSTERS CANONICAL (ordering A → F culminação semântica)
// =============================================================================
//
// Cluster A — Substrate canonical (7 terms)
//             Tier 1 + Tier 1.Q + Tier 2 + Gate + Matrix + signal +
//             mechanism-artifact + provenance + substrate invariants
// Cluster B — Mechanism types canonical (10 terms)
//             mechanism (foundational) + 6 mechanism types +
//             mechanism-type taxonomy + mechanism-dimension +
//             adversarial-resistance-class
// Cluster C — Authority + lineage + interpretability (7 terms)
//             5-tuple authority boundary + authority-surface +
//             consumer-bc-authority + lineage + lineage-propagation
//             + interpretability-class + escape-path
// Cluster D — Drift class + governance vocabulary (9 terms)
//             9 drift classes umbrella + 5 drift class detailed +
//             mechanism-mutation-governance + authority-chain-
//             reinforcement + recursive-governance
// Cluster E — Semantic Hazard Watchlist (26 terms — semantic
//             containment infrastructure)
//             Semantic Gravity Escalation umbrella + 5 detailed
//             FORBIDDEN canonical + 20 brief BOUNDED/FORBIDDEN entries
// Cluster F — META-constitutional vocabulary (7 terms)
//             meta-constitutional-bc-pattern + governance-over-
//             governance-producing-mechanisms + bidirectional-epistemic-
//             feedback-topology + legitimacy-accumulation-risk +
//             mechanism-legitimacy-capture + epistemic-dependency-
//             normalization + constitutional-split-review-pathway
//
// =============================================================================
// 66 TOTAL TERMS CANONICAL (density per founder framing)
// =============================================================================
//
// Density structural justified per founder framing canonical: glossary
// é semantic governance infrastructure, NÃO terminology dictionary.
// Pattern paralelo NIM canvas 1788L vs NTF canvas 1015L ratio ~1.76x;
// glossary ratio ~3.1x reflete semantic containment density canonical.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code: "nim"
	name: "Glossário NIM — Network Intelligence & Mechanism Design"

	boundedContextRef: "nim"

	terms: [
		// ====================================================================
		// CLUSTER A — SUBSTRATE CANONICAL (7 terms)
		// ====================================================================

		{
			code:   "term-tier-1-signal-substrate"
			name:   "Substrato de Sinais Tier 1"
			termEn: "Tier1 Signal Substrate"
			definition: """
				Append-only canonical substrate layer onde signals raw
				observed dos 13 BCs operacionais são ingested + preserved
				com provenance metadata (source + observation-time +
				epistemic-class). NÃO mutable post-emission. Layer
				foundational para mechanism execution downstream —
				mechanisms operate over Tier 1 signals via Mechanism
				Execution Gate; signals NÃO entram Tier 2 sem gate
				canonical execution.
				"""
			category:  "entity"
			rationale: "Term canoniza Tier 1 substrate distinct from Tier 2 Mechanism Artifact Substrate (paralelo NTF Tier 1 provider claims vs Tier 2 admissibility certifications). Sem este term explicit, sistema collapses signals into mechanism outputs silently — foundational drift vector destroyed."
			antiTerms: [{
				term:          "Database"
				clarification: "Banal storage framing perde substrate canonical semantics + provenance + append-only invariant."
			}, {
				term:          "Signal log"
				clarification: "Perde substrate framing; sugere passive accumulation."
			}, {
				term:          "Event store"
				clarification: "Generic event sourcing perde NIM-specific 7 substrate invariants + provenance class structural."
			}]
			rejectedAlternatives: [{
				term:   "SignalStore"
				reason: "Verbose mas perde 'substrate' canonical framing."
			}, {
				term:   "RawObservationLayer"
				reason: "Perde 'tier' architectural framing critical para Tier 1/Tier 1.Q/Tier 2 distinction."
			}, {
				term:   "InputDataLayer"
				reason: "Generic ML-platform vocabulary (CP4 + CP5 violations)."
			}]
			examples: [{
				context:   "NPM emits EligibilityDecisionEmitted event → Tier 1 ingestion"
				instance:  "Signal carried provenance: source=npm, observation-time=2026-05-15T14:23:00Z, epistemic-class=internal-decision; ingested via cap-signal-substrate-ingestion to Tier 1 substrate canonical."
				rationale: "Substrate ingestion mechanical; no judgment; provenance preserved structurally."
			}]
			relatedTerms: [
				"term-tier-1-q-exogenous-signal-quarantine",
				"term-tier-2-mechanism-artifact-substrate",
				"term-mechanism-execution-gate",
				"term-provenance",
				"term-signal",
				"term-substrate-invariants",
			]
			layerMapping: {
				codeTerm: "Tier1SignalSubstrate"
				apiTerm:  "tier-1-signal-substrate"
			}
		},
		{
			code:   "term-tier-1-q-exogenous-signal-quarantine"
			name:   "Quarentena Tier 1.Q de Sinais Exógenos"
			termEn: "Tier1Q Exogenous Signal Quarantine"
			definition: """
				Quarantine layer entre exogenous signal sources (ext-
				economic-indicator + ext-regulatory-signal + ext-market-
				intelligence + ext-counterparty-public) e Tier 1 Signal
				Substrate canonical promotion. Validation obrigatória:
				provenance + freshness + source reliability check.
				Exogenous signals NUNCA enter Tier 1 directly; asymmetric
				epistemic ontology canonical — higher uncertainty
				weighting downstream-visible em mechanism outputs.
				"""
			category:  "entity"
			rationale: "Term canoniza Tier 1.Q (per Phase 1.2 ajuste #4). Sem quarantine, exogenous signal contamination cross-substrate inevitable. Tier 1.Q é structural defense, NÃO operational filter (paralelo NTF asymmetric provenance ontology). Naming '1.Q' preserve tier hierarchy + explicit quarantine function."
			antiTerms: [{
				term:          "Input filter"
				clarification: "Generic; perde quarantine canonical semantics + asymmetric epistemic ontology framing."
			}, {
				term:          "Validation layer"
				clarification: "Perde Tier hierarchy + asymmetric semantics."
			}, {
				term:          "Sanitization layer"
				clarification: "Sanitization sugere transformation; quarantine é assessment + clearance OR block (NÃO transformation)."
			}]
			rejectedAlternatives: [{
				term:   "ExogenousSignalValidator"
				reason: "Perde quarantine canonical framing."
			}, {
				term:   "ExternalSignalFilter"
				reason: "Generic filter framing."
			}, {
				term:   "Pre-Tier-1 validation"
				reason: "Verbose; perde Tier 1.Q hierarchy explicit."
			}]
			examples: [{
				context:   "Regulatory authority emits ext-regulatory-signal"
				instance:  "Signal arrives Tier 1.Q quarantine; cap-exogenous-signal-quarantine validates provenance (regulatory authority verified) + freshness (observation < 24h) + source reliability (authority pattern matches canonical regulators list). Cleared → ExogenousSignalQuarantineCleared event + Tier 1 promotion. Blocked → ExogenousSignalQuarantineBlocked + audit event."
				rationale: "Quarantine validation mechanical; NÃO discretionary."
			}]
			relatedTerms: [
				"term-tier-1-signal-substrate",
				"term-provenance",
				"term-signal",
			]
			layerMapping: {
				codeTerm: "Tier1QExogenousSignalQuarantine"
				apiTerm:  "tier-1-q-exogenous-signal-quarantine"
			}
		},
		{
			code:   "term-tier-2-mechanism-artifact-substrate"
			name:   "Substrato de Artefatos de Mecanismo Tier 2"
			termEn: "Tier2 Mechanism Artifact Substrate"
			definition: """
				Layer onde mechanism artifacts canonical (outputs +
				versions + lineage + authority + validity envelope) são
				materialized + preserved post Mechanism Execution Gate
				canonical execution. NÃO mutable post-emission. Mechanism
				artifact é governance artifact (NOT optimization
				artifact) — carries 5-tuple authority boundary declared
				+ provenance lineage back to Tier 1 input signals +
				temporal validity envelope.
				"""
			category:  "entity"
			rationale: "Term canoniza Tier 2 distinct from Tier 1 substrate per Phase 1.2 ajuste #3 naming ('Mechanism Artifact Substrate' NÃO 'Mechanism Output Substrate' — substrato comprehensive, NÃO apenas outputs). Distinct entity from Tier 1: Tier 1 = signals raw; Tier 2 = governance artifacts canonical. Gate é constitutional center between."
			antiTerms: [{
				term:          "Mechanism cache"
				clarification: "Generic; perde substrate canonical + immutability + lineage structural."
			}, {
				term:          "Output store"
				clarification: "Perde 'artifact' governance framing critical."
			}, {
				term:          "Result layer"
				clarification: "Generic; perde Tier hierarchy."
			}]
			rejectedAlternatives: [{
				term:   "Mechanism Output Substrate"
				reason: "Original Phase 1.2 naming; rejected per founder Phase 1.2 ajuste #3 — substrato é mais comprehensive (outputs + versions + lineage + authority + validity envelope)."
			}, {
				term:   "Mechanism Result Layer"
				reason: "Generic ML-platform vocabulary."
			}]
			examples: [{
				context:   "Scoring mechanism executed via gate"
				instance:  "Mechanism Execution Gate validates 5-tuple + dimensions + Integrity Matrix; produces Tier 2 mechanism artifact: scoring output + version v3.2 + lineage [signal-refs] + authority surface {NPM, REW, SSC, NGR, FCE-limited, DLV-limited} + validity envelope {temporal: 30-day window; consumer-bounded}. Artifact immutable post-emission."
				rationale: "Tier 2 substrate é governance artifact substrate; NÃO mere output storage."
			}]
			relatedTerms: [
				"term-tier-1-signal-substrate",
				"term-mechanism-execution-gate",
				"term-mechanism-artifact",
				"term-lineage",
				"term-tuple-authority-boundary",
			]
			layerMapping: {
				codeTerm: "Tier2MechanismArtifactSubstrate"
				apiTerm:  "tier-2-mechanism-artifact-substrate"
			}
		},
		{
			code:   "term-mechanism-execution-gate"
			name:   "Portão de Execução de Mecanismo"
			termEn: "Mechanism Execution Gate"
			definition: """
				Constitutional center canonical entre Tier 1 + Tier 1.Q
				(signal substrate) e Tier 2 (mechanism artifact substrate).
				Validates 8-dimension declaration + Mechanism Integrity
				Matrix application (Class A/B/C/D/E violation detection).
				Auto-promotion forbidden; opaque-blocked interpretability
				forbidden. Paralelo NTF admissibility certification gate.
				Constitutional anchor C1 + C14 + C15.
				"""
			category:  "entity"
			rationale: "Gate é constitutional center canonical entre substrate tiers. Sem gate explicit, Tier 1 → Tier 2 silent promotion = sovereignty violation."
			antiTerms: [{
				term:          "Validation pipeline"
				clarification: "Generic engineering framing perde constitutional center canonical."
			}, {
				term:          "Output gate"
				clarification: "Perde 'execution' canonical framing."
			}]
			relatedTerms: [
				"term-tier-1-signal-substrate",
				"term-tier-2-mechanism-artifact-substrate",
				"term-mechanism-integrity-matrix",
				"term-tuple-authority-boundary",
			]
			layerMapping: {
				codeTerm: "MechanismExecutionGate"
				apiTerm:  "mechanism-execution-gate"
			}
		},
		{
			code:   "term-mechanism-integrity-matrix"
			name:   "Matriz de Integridade de Mecanismo"
			termEn: "Mechanism Integrity Matrix"
			definition: """
				Canonical determination of mechanism structural validity
				per 5 violation classes: Class A (structural mechanism
				violation) + Class B (authority surface violation) +
				Class C (interpretability violation) + Class D (governance
				violation) + Class E (feedback-loop violation per Phase
				1.2 ajuste #5). Materializes Mechanism Execution Gate
				decision logic. Paralelo NTF admissibility matrix.
				"""
			category:  "rule"
			rationale: "Matrix canoniza violation taxonomy estrutural — sem matrix, gate decisions são ad-hoc; com matrix, decisions são deterministic per violation class canonical."
			antiTerms: [{
				term:          "Compliance check"
				clarification: "Compliance framing perde integrity canonical + 5 violation class structural."
			}]
			relatedTerms: [
				"term-mechanism-execution-gate",
				"term-mechanism",
			]
			layerMapping: {
				codeTerm: "MechanismIntegrityMatrix"
				apiTerm:  "mechanism-integrity-matrix"
			}
		},
		{
			code:   "term-signal"
			name:   "Sinal"
			termEn: "Signal"
			definition: """
				Tier 1 substrate canonical entity: raw observation com
				provenance metadata (source + observation-time + epistemic-
				class). Append-only post-emission. Signal NÃO é decision,
				NÃO é mechanism output, NÃO é result.
				"""
			category:  "entity"
			rationale: "Term canoniza Tier 1 entity distinct from event (fact published) + metric (aggregate) + decision. Signal é observation consumed; preserva ontological distinction canonical."
			antiTerms: [{
				term:          "Data point"
				clarification: "Generic; perde substrate ontology + provenance structural."
			}, {
				term:          "Event"
				clarification: "Different ontology — events são facts published; signals são observations consumed."
			}, {
				term:          "Metric"
				clarification: "Aggregate; perde provenance structural + raw observation framing."
			}]
			relatedTerms: [
				"term-tier-1-signal-substrate",
				"term-provenance",
			]
			layerMapping: {
				codeTerm: "Signal"
				apiTerm:  "signals"
			}
		},
		{
			code:   "term-mechanism-artifact"
			name:   "Artefato de Mecanismo"
			termEn: "Mechanism Artifact"
			definition: """
				Tier 2 substrate canonical entity: governance artifact
				produced via Mechanism Execution Gate canonical
				execution. Carries 5-tuple authority boundary + lineage
				+ validity envelope + interpretability class. Governance
				artifact NOT optimization artifact (canonical clause C2
				inheritance).
				"""
			category:  "entity"
			rationale: "Term canoniza Tier 2 entity distinct from generic output + score + result. Mechanism artifact é governance artifact, NÃO optimization artifact — semantic discipline canonical."
			antiTerms: [{
				term:          "Output"
				clarification: "Generic; perde governance framing canonical."
			}, {
				term:          "Result"
				clarification: "Perde canonical artifact framing."
			}, {
				term:          "Score"
				clarification: "Cluster E forbidden specific subset; mechanism artifact é genérico, NÃO score-specific."
			}]
			relatedTerms: [
				"term-tier-2-mechanism-artifact-substrate",
				"term-mechanism",
				"term-lineage",
			]
			layerMapping: {
				codeTerm: "MechanismArtifact"
				apiTerm:  "mechanism-artifacts"
			}
		},
		{
			code:   "term-provenance"
			name:   "Proveniência"
			termEn: "Provenance"
			definition: """
				Structural property of signals (source + observation-
				time + epistemic-class) preserved through ingestion +
				propagated through mechanism execution into lineage.
				Canonical substrate invariant #2. Provenance é origem
				epistêmica do sinal — distinct from lineage (cadeia
				causal do artefato de mecanismo).
				"""
			category:  "value"
			rationale: "Term canoniza structural property foundational substrate hygiene. Per Phase 2.3 founder reinforcement: provenance = origem epistêmica do sinal; lineage = cadeia causal do artefato de mecanismo (distinct canonical)."
			antiTerms: [{
				term:          "Metadata"
				clarification: "Generic; perde provenance canonical framing + structural property semantic."
			}, {
				term:          "Source attribution"
				clarification: "Incomplete; perde temporal + epistemic dimensions canonical."
			}, {
				term:          "Lineage"
				clarification: "Related-but-distinct (provenance é signal-level; lineage é mechanism-execution causal chain through gate)."
			}]
			relatedTerms: [
				"term-tier-1-signal-substrate",
				"term-signal",
				"term-lineage",
				"term-substrate-invariants",
			]
			layerMapping: {
				codeTerm: "Provenance"
				apiTerm:  "provenance"
			}
		},
		{
			code:   "term-substrate-invariants"
			name:   "Invariantes do Substrato"
			termEn: "Substrate Invariants"
			definition: """
				Canonical 7 invariants governing substrate hygiene:
				(1) inv-substrate-append-only — signals immutable post-
				emission;
				(2) inv-provenance-preservation — source + time +
				epistemic-class carried structurally;
				(3) inv-identity-immutability — signal/mechanism identity
				NÃO reassigned;
				(4) inv-temporal-causal-ordering — causal precedence
				preserved (anti-anachronism);
				(5) inv-weighting-lineage-explicit — mechanism output
				carries full computation lineage;
				(6) inv-source-diversity-preserved — anti-monoculture
				structural (C12 defense);
				(7) inv-audit-chain-integrity — substrate mutations
				governed via explicit governance events.

				Per Phase 1.2 Section B + Phase 2.1 founder ajuste #3:
				umbrella term + internal canonical invariant IDs preserves
				ontologia sem maximizar granularidade prematuramente.
				"""
			category:  "rule"
			rationale: "Umbrella term canonical per Phase 2.1 founder ajuste #3: glossary preserva ontologia + internal canonical IDs (inv-substrate-*) enable future extraction sem quebrar glossary cedo. Equilíbrio entre containment + extractability."
			antiTerms: [{
				term:          "Substrate constraints"
				clarification: "Generic constraint framing perde 'invariants' canonical structural property."
			}, {
				term:          "Substrate rules"
				clarification: "Rules sugere policy; invariants é structural property."
			}]
			relatedTerms: [
				"term-tier-1-signal-substrate",
				"term-provenance",
			]
			layerMapping: {
				codeTerm: "SubstrateInvariants"
				apiTerm:  "substrate-invariants"
			}
		},

		// ====================================================================
		// CLUSTER B — MECHANISM TYPES CANONICAL (10 terms)
		// ====================================================================

		{
			code:   "term-mechanism"
			name:   "Mecanismo"
			termEn: "Mechanism"
			definition: """
				Canonical governance artifact NIM-produced operating
				sobre Tier 1 Signal Substrate (+ Tier 1.Q quarantine
				cleared exogenous signals) via Mechanism Execution Gate
				constitutional execution. Each mechanism declares 8
				canonical dimensions (input substrate + output type +
				authority surface + interpretability class + mutation
				governance + temporal validity + replay semantics +
				adversarial-resistance-class) + 5-tuple authority
				boundary (mechanismType + consumerBCs + authoritySurface
				+ forbiddenInterpretations + escapePaths). Mechanisms
				são governance artifacts, NOT optimization artifacts
				(canonical clause C2 foundational).
				"""
			category:  "entity"
			rationale: "Term central da ontologia NIM. Sem distinção canonical 'mechanism = governance artifact', sistema lentamente collapses em ML-platform / scoring service / recommendation engine attractor. Mechanism canonical é structurally distinct from algorithm/model/function/scorer."
			antiTerms: [{
				term:          "Algorithm"
				clarification: "Generic computational procedure; perde governance artifact framing + 5-tuple authority + mutation governance discipline."
			}, {
				term:          "Model"
				clarification: "ML-platform vocabulary; carries learning/training semantics inappropriate (NÃO autonomous policy optimizer per C9)."
			}, {
				term:          "Function"
				clarification: "Math/programming term; perde substrate ontology + governance framing."
			}, {
				term:          "Scorer"
				clarification: "Narrow to scoring; mechanism é genérico cobrindo 6 types."
			}, {
				term:          "Heuristic"
				clarification: "Informal/approximation framing; perde canonical discipline structural."
			}, {
				term:          "Decision system"
				clarification: "Collapses NIM specification + consumer decision authority (CP5 anti-authority-euphemism)."
			}]
			rejectedAlternatives: [{
				term:   "GovernanceMechanism"
				reason: "Verbose; canonical 'mechanism' carries governance via C2 inheritance."
			}, {
				term:   "AlgorithmicArtifact"
				reason: "Perde 'mechanism' canonical + algorithmic framing implies optimization."
			}, {
				term:   "EpistemicArtifact"
				reason: "Verbose; perde mechanism execution canonical."
			}]
			examples: [{
				context:   "IQF scoring mechanism (Indicador de Qualidade do Fornecedor)"
				instance:  "Mechanism canonical declared: type=Scoring; dimensions {input: NPM eligibility + DLV delivery + INV invoice signals; output: composite supplier quality score 0-100; authority surface: NPM eligibility input + REW risk input; interpretability: inspectable-lineage; mutation governance: ADR-bound; temporal validity: 30-day window; replay: recomputable-deterministic; adversarial-resistance: high}; 5-tuple authority: bounded NPM/REW consumer pathway. Per governance-cannot-self-weaken canonical, IQF mutations require ADR + parallel SRR + 90-day cycle."
				rationale: "Mechanism é governance artifact com explicit boundary + lineage + mutation discipline; NÃO optimization artifact."
			}, {
				context:   "GovernedSuggestion evaluation criteria template mechanism"
				instance:  "Mechanism canonical declared: type=GovernedSuggestion; dimensions {input: industry-benchmark signals + canonical sourcing patterns; output: evaluation criteria framework template; authority surface: SSC sourcing committee adoption pathway; interpretability: inspectable-full; mutation governance: founder-only + ADR + 90-day; temporal validity: 180-day window; replay: snapshot; adversarial-resistance: medium}; 5-tuple authority: bounded SSC committee canonical authority preserved. NÃO personalized per buyer; NÃO sourcing decision; template é input to SSC bounded authority."
				rationale: "Mechanism canonical scope é genérico — cobre scoring + matching + ranking + incentive + penalty + governed-suggestion. Cada mechanism type carries distinct semantics mas mesma discipline structural."
			}]
			relatedTerms: [
				"term-mechanism-type",
				"term-mechanism-execution-gate",
				"term-mechanism-artifact",
				"term-mechanism-dimension",
				"term-tuple-authority-boundary",
				"term-mechanism-mutation-governance",
			]
			layerMapping: {
				codeTerm: "Mechanism"
				apiTerm:  "mechanisms"
			}
		},
		{
			code:   "term-mechanism-type"
			name:   "Tipo de Mecanismo"
			termEn: "Mechanism Type"
			definition: """
				Canonical taxonomy of 6 mechanism types: Scoring +
				Matching + Ranking + Incentive + Penalty +
				GovernedSuggestion. NÃO arbitrary creation; new
				mechanism types require ADR + parallel SRR + 90-day
				observation cycle minimum (founder-only mutation per
				cap-mechanism-governance-mutation-control).
				"""
			category:  "classification"
			rationale: "Taxonomy canonical bounded prevents covert mechanism type emergence + preserves governance discipline canonical."
			antiTerms: [{
				term:          "Algorithm category"
				clarification: "Generic; perde mechanism canonical framing + bounded taxonomy."
			}]
			relatedTerms: [
				"term-mechanism",
				"term-scoring-mechanism",
				"term-matching-mechanism",
				"term-ranking-mechanism",
				"term-incentive-mechanism",
				"term-penalty-mechanism",
				"term-governed-suggestion",
			]
			layerMapping: {
				codeTerm: "MechanismType"
				apiTerm:  "mechanism-types"
			}
		},
		{
			code:   "term-scoring-mechanism"
			name:   "Mecanismo de Pontuação"
			termEn: "Scoring Mechanism"
			definition: """
				Mechanism type producing composite score derived from
				signal weighting (e.g., IQF Indicador de Qualidade do
				Fornecedor; TCO Total Cost of Ownership). Score é INPUT
				to consumer canonical decision pathway, NÃO verdict.
				"""
			category:  "entity"
			rationale: "Distinct mechanism type canonical — score canonical bounded scope, NÃO universal authority. Authority surface declared explicit per consumer × mechanism pair."
			antiTerms: [{
				term:          "Rating engine"
				clarification: "Engagement framing CP4 violation."
			}, {
				term:          "Trust score"
				clarification: "CP5 anti-authority-euphemism; score canonical is bounded property, NÃO trust assertion."
			}]
			relatedTerms: [
				"term-mechanism",
				"term-mechanism-type",
			]
			layerMapping: {
				codeTerm: "ScoringMechanism"
				apiTerm:  "scoring-mechanisms"
			}
		},
		{
			code:   "term-matching-mechanism"
			name:   "Mecanismo de Pareamento"
			termEn: "Matching Mechanism"
			definition: """
				Mechanism type producing algorithmic entity pair
				proposal. Pair é INPUT to consumer authority (SSC
				sourcing committee, NPM qualification flow), NÃO
				sourcing pair OR qualification verdict.
				"""
			category:  "entity"
			rationale: "Pair proposal bounded; consumer canonical authority preserved per Phase 1.2.B matrix."
			antiTerms: [{
				term:          "Matchmaking"
				clarification: "Engagement vocabulary CP4 violation."
			}, {
				term:          "Smart matching"
				clarification: "Cluster E 'smart' forbidden + CP2."
			}]
			relatedTerms: [
				"term-mechanism",
				"term-mechanism-type",
			]
			layerMapping: {
				codeTerm: "MatchingMechanism"
				apiTerm:  "matching-mechanisms"
			}
		},
		{
			code:   "term-ranking-mechanism"
			name:   "Mecanismo de Ordenação"
			termEn: "Ranking Mechanism"
			definition: """
				Mechanism type producing ordered list per relevance/
				quality declared. Order é signal NOT decision; 'top N
				auto-shortlist' interpretation forbidden.
				"""
			category:  "entity"
			rationale: "Ordering bounded; sequence é signal NOT decision per Phase 1.2.B matrix."
			antiTerms: [{
				term:          "Ranking engine"
				clarification: "Implies engagement framing CP4."
			}, {
				term:          "Best supplier list"
				clarification: "Cluster E 'best' forbidden + CP5."
			}]
			relatedTerms: [
				"term-mechanism",
				"term-mechanism-type",
			]
			layerMapping: {
				codeTerm: "RankingMechanism"
				apiTerm:  "ranking-mechanisms"
			}
		},
		{
			code:   "term-incentive-mechanism"
			name:   "Mecanismo de Incentivo"
			termEn: "Incentive Mechanism"
			definition: """
				Mechanism type producing reward structure recipe (volume
				discounts, loyalty terms formula, status promotion
				structures). Recipe consumed by P2P/CTR/NPM via canonical
				authority pathways; NÃO direct reward distribution.
				"""
			category:  "entity"
			rationale: "Structure recipe bounded; consumer applies via own canonical contract/payment/promotion authority."
			antiTerms: [{
				term:          "Reward system"
				clarification: "Engagement framing CP4 violation."
			}, {
				term:          "Loyalty engine"
				clarification: "CP4 + engagement gravity attractor."
			}]
			relatedTerms: [
				"term-mechanism",
				"term-mechanism-type",
			]
			layerMapping: {
				codeTerm: "IncentiveMechanism"
				apiTerm:  "incentive-mechanisms"
			}
		},
		{
			code:   "term-penalty-mechanism"
			name:   "Mecanismo de Penalidade"
			termEn: "Penalty Mechanism"
			definition: """
				Mechanism type producing sanction structure recipe
				consumed by REW/NPM/CTR/DRC via canonical authority.
				Recipe é INPUT, NÃO sanction itself; consumer applies
				via own canonical authority (esp. DRC dispute resolution
				remains DRC canonical).
				"""
			category:  "entity"
			rationale: "Sanction structure bounded; consumer canonical authority preserved per Phase 1.2.B matrix."
			antiTerms: [{
				term:          "Punishment system"
				clarification: "Informal; perde governance framing canonical."
			}, {
				term:          "Fine engine"
				clarification: "Collapses governance into automated enforcement."
			}]
			relatedTerms: [
				"term-mechanism",
				"term-mechanism-type",
			]
			layerMapping: {
				codeTerm: "PenaltyMechanism"
				apiTerm:  "penalty-mechanisms"
			}
		},
		{
			code:   "term-governed-suggestion"
			name:   "Sugestão Governada"
			termEn: "Governed Suggestion"
			definition: """
				Canonical mechanism type produzindo bounded non-
				personalized governance suggestion (e.g., evaluation
				criteria template para sourcing committee, qualification
				framework suggestion, sourcing template). NÃO personalized
				per actor. NÃO recommendation engine framing. NÃO
				engagement-driven. Authority surface bounded per consumer
				× suggestion-type pair declared explicit. Suggestion é
				INPUT to consumer canonical decision pathway, NÃO
				decision template.
				"""
			category:  "entity"
			rationale: "Term canoniza mechanism type que mais concentra engagement gravity vector + recommendation engine attractor. Naming canonical 'GovernedSuggestion' canonicalmente substitui Phase 1.2 original 'Governed-recommendation' per founder ajuste #2 — evita gravidade semântica de 'recommendation engine' (drift class #5 engagement gravity catastrophic vector). Term é primary defense contra 'NIM virou recommendation API' attractor."
			antiTerms: [{
				term:          "Recommendation"
				clarification: "Canonical FORBIDDEN (CP4 anti-engagement-language drift; engagement gravity vector carrying behavioral inference semantics inappropriate); recommendation engine framing forbidden por construção."
			}, {
				term:          "Suggestion (sem 'Governed')"
				clarification: "Perde governance framing canonical; bare 'suggestion' carries informal advisory semantics."
			}, {
				term:          "Personalized recommendation"
				clarification: "DOUBLE FORBIDDEN (recommendation + personalized engagement gravity)."
			}, {
				term:          "Smart suggestion"
				clarification: "Cluster E 'smart' forbidden."
			}, {
				term:          "Top picks"
				clarification: "Engagement-language drift CP4."
			}]
			rejectedAlternatives: [{
				term:   "Governed-recommendation"
				reason: "Original Phase 1.2 naming; rejected per founder ajuste #2 — recommendation gravity semantic cannot be governed away através de adjective; canonical replacement integral."
			}, {
				term:   "GovernanceTemplate"
				reason: "Perde 'suggestion' framing; suggestion preserva nature non-binding."
			}, {
				term:   "BoundedSuggestion"
				reason: "Verbose; 'governed' captura bounded + non-personalized + ADR-bound mutation discipline."
			}]
			examples: [{
				context:   "SSC sourcing committee evaluation criteria template"
				instance:  "Mechanism canonical: type=GovernedSuggestion; output = evaluation criteria framework template (NÃO personalized per buyer; NÃO sourcing decision; NÃO ranking). Authority surface: SSC committee adopts/adapts template canonical via SSC bounded sourcing authority. Forbidden: SSC auto-applying template sem committee review; SSC personalizing template per buyer; SSC framing template como 'NIM-recommended sourcing'."
				rationale: "Suggestion é template + bounded authority pathway; NÃO personalized engagement-driven recommendation."
			}, {
				context:   "NPM qualification framework suggestion"
				instance:  "Mechanism canonical produces qualification framework template (e.g., 'recommended evaluation criteria for technology vendors qualification'). NPM canonical authority adopts/adapts framework + applies own qualification decision pathway. Framework é input, NÃO authority."
				rationale: "Same canonical pattern: bounded suggestion + consumer canonical authority preserved."
			}]
			relatedTerms: [
				"term-mechanism-type",
				"term-mechanism",
				"term-watch-recommendation",
			]
			layerMapping: {
				codeTerm: "GovernedSuggestion"
				apiTerm:  "governed-suggestions"
			}
		},
		{
			code:   "term-mechanism-dimension"
			name:   "Dimensão de Mecanismo"
			termEn: "Mechanism Dimension"
			definition: """
				Canonical 8 dimensions characterizing each mechanism:
				input substrate + output type + authority surface +
				interpretability class + mutation governance + temporal
				validity + replay semantics + adversarial-resistance-
				class. Materializa structural mechanism property
				declaration. Per Phase 1.2 + Phase 1.2 ajuste #1.
				"""
			category:  "classification"
			rationale: "8 dimensions canonical preserve structural mechanism property declaration explicit — anti-genericização discipline."
			relatedTerms: [
				"term-mechanism",
				"term-adversarial-resistance-class",
			]
			layerMapping: {
				codeTerm: "MechanismDimension"
				apiTerm:  "mechanism-dimensions"
			}
		},
		{
			code:   "term-adversarial-resistance-class"
			name:   "Classe de Resistência Adversarial"
			termEn: "Adversarial Resistance Class"
			definition: """
				Structural mechanism dimension (8th canonical per Phase
				1.2 founder ajuste #1) declarando capability of mechanism
				to resist adversarial gaming + manipulation pressure.
				Enumerable canonical: low / medium / high / critical.
				Critical-resistance mechanisms require governance review
				per execution. Class downgrade FORBIDDEN canonical (1st
				of 4 FORBIDDEN mutations per cap-mechanism-governance-
				mutation-control).
				"""
			category:  "classification"
			rationale: "Term canoniza adversarial pressure como structural mechanism property, NÃO operational tuning concern. Per drift class #1 (mechanism gaming top-3 severity) + Phase 1.0 founder framing — gaming pressure structural NÃO transient. Resistance class é declared mechanism property visible canonical via mechanism declaration; class downgrade FORBIDDEN preserves structural defense canonical."
			antiTerms: [{
				term:          "Robustness score"
				clarification: "Collapses adversarial resistance into generic robustness metric (CP1 anti-synonym collapse)."
			}, {
				term:          "Security level"
				clarification: "Generic security framing perde adversarial-specific semantics + Goodhart operationalization."
			}, {
				term:          "Reliability"
				clarification: "Different ontological vector (operational reliability vs adversarial resistance distinct)."
			}, {
				term:          "Trust score for mechanism"
				clarification: "CP5 anti-authority-euphemism + collapses mechanism property into trust authority."
			}]
			rejectedAlternatives: [{
				term:   "GamingResistance"
				reason: "Perde adversarial canonical framing; gaming é Goodhart-specific subset."
			}, {
				term:   "AdversarialHardening"
				reason: "Sugere process, NÃO structural property declared."
			}]
			examples: [{
				context:   "IQF scoring mechanism adversarial-resistance-class declaration"
				instance:  "Mechanism declares adversarial-resistance-class=high per evidence: (a) signal aggregation across 6+ sources prevents single-source manipulation; (b) temporal staleness detection prevents historical reputation gaming; (c) cap-feedback-loop-detection covers reflexive reinforcement vector; (d) provenance preservation enables forensic audit of suspected gaming. Critical upgrade considered if novel sophistication detected per cap-adversarial-resistance-evaluation."
				rationale: "Class é declared property + evidence-grounded; NÃO marketing claim."
			}, {
				context:   "FORBIDDEN mutation attempt detection"
				instance:  "Mutation proposal: 'Downgrade IQF adversarial-resistance-class from high to medium for operational simplicity.' Result: REJECTED at submission per cap-mechanism-governance-mutation-control + 1st FORBIDDEN canonical. Audit event emitted; constitutional integrity containment review triggered."
				rationale: "Downgrade FORBIDDEN preserva structural defense canonical anti-mechanism-gaming drift class #1."
			}]
			relatedTerms: [
				"term-mechanism-dimension",
				"term-mechanism-gaming",
				"term-mechanism-mutation-governance",
			]
			layerMapping: {
				codeTerm: "AdversarialResistanceClass"
				apiTerm:  "adversarial-resistance-class"
			}
		},

		// ====================================================================
		// CLUSTER C — AUTHORITY + LINEAGE + INTERPRETABILITY (7 terms)
		// ====================================================================

		{
			code:   "term-tuple-authority-boundary"
			name:   "Limite de Autoridade 5-tuple"
			termEn: "Tuple Authority Boundary"
			definition: """
				Canonical 5-tuple discipline structural carried por
				cada mechanism output, declarando 5 dimensions explicit:
				(1) mechanismType — qual canonical mechanism type produz
				output; (2) consumerBCs — quais BCs consomem output
				legitimately; (3) authoritySurface — qual authority
				surface specific consumer × mechanism pair; (4)
				forbiddenInterpretations — explicit anti-patterns
				canonical forbidden per pair; (5) escapePaths —
				pathways canonical quando consumer encontra boundary
				OR violation. Phase 1 canvas: textual discipline;
				Phase 3/4 materialization deferred para structural
				materialization (paralelo ADR-088 MCM expansion pattern).
				"""
			category:  "classification"
			rationale: "Term canoniza disciplina anti-genericização canonical. Generic capability tipo 'GenerateScore' viraria universal authority sem 5-tuple discipline — drift class #7 authority delegation + epistemic monoculture attractor. 5-tuple força explicit per-consumer × per-mechanism authority declaration; aggregation cross-consumer = universal substrate substitution Class A violation."
			antiTerms: [{
				term:          "Authority scope"
				clarification: "Generic; perde 5-dimension canonical structural + forbidden interpretations explicit + escape paths."
			}, {
				term:          "Permission boundary"
				clarification: "ACL/security framing perde governance artifact discipline."
			}, {
				term:          "API contract"
				clarification: "Technical contract framing perde authority + governance + epistemic dimensions canonical."
			}]
			rejectedAlternatives: [{
				term:   "AuthorityBoundary (sem tuple prefix)"
				reason: "Perde structural 5-dimension canonical."
			}, {
				term:   "ConsumerAuthorityDeclaration"
				reason: "Verbose; perde 5-tuple discipline canonical."
			}, {
				term:   "GovernanceBoundary"
				reason: "Generic; perde 5-tuple specific structural."
			}]
			examples: [{
				context:   "Scoring mechanism IQF output to NPM consumer"
				instance:  "5-tuple declared: mechanismType=Scoring; consumerBCs=[NPM]; authoritySurface=eligibility decision INPUT (signal contribution to NPM eligibility calculation, NÃO eligibility verdict); forbiddenInterpretations=[score AS eligibility verdict; 'high score = eligible' automated derivation; bypass of NPM canonical qualification process]; escapePaths=[insufficient signal escape #1; provenance degradation escape #6]. Authority surface bounded per consumer × mechanism pair canonical."
				rationale: "5-tuple discipline anti-genericização — IQF authority surface explicit, NÃO universal."
			}, {
				context:   "Cross-mechanism × cross-consumer matrix Phase 1.2.B"
				instance:  "Scoring × {NPM, REW, SSC, NGR, FCE-limited, DLV-limited} + Matching × {SSC, NPM} + Ranking × {SSC, NGR, NPM} + Incentive × {P2P, CTR, NPM} + Penalty × {REW, NPM, CTR, DRC} + GovernedSuggestion × {SSC, NGR, NPM}. Cada cell tem 5-tuple distinct canonical."
				rationale: "Matrix structure preserves bounded authority per cell; aggregation cross-cells é Class A structural violation."
			}]
			relatedTerms: [
				"term-authority-surface",
				"term-consumer-bc-authority",
				"term-escape-path",
				"term-mechanism",
			]
			layerMapping: {
				codeTerm: "TupleAuthorityBoundary"
				apiTerm:  "tuple-authority-boundary"
			}
		},
		{
			code:   "term-lineage"
			name:   "Linhagem"
			termEn: "Lineage"
			definition: """
				Structural property canonical preserved by mechanism
				artifacts (Tier 2 substrate) carrying full causal chain
				canonical from Tier 1 input signals through Mechanism
				Execution Gate canonical execution to mechanism output.
				Lineage chain structural: Tier 1 signals (provenance:
				source + observation-time + epistemic-class) → Mechanism
				Execution Gate (5-tuple declaration + 8-dimension
				validation + Integrity Matrix decision) → Tier 2 artifact
				(weighting lineage explicit + temporal validity envelope).
				Lineage NÃO mutable post-emission; truncation/aggregation/
				opacity/rewriting forbidden (4 forbidden cases Phase 1.5.B
				Section E). Lineage = cadeia causal do artefato de mecanismo
				(distinct from provenance = origem epistêmica do sinal).
				"""
			category:  "value"
			rationale: "Term canoniza causal traceability structural — distinct from provenance (signal-level) e versioning (artifact-level). Lineage carries CAUSAL CHAIN canonical através de gate execution + consumer propagation. Sem lineage canonical preserved structurally, authority leakage + opacity drift inevitable downstream."
			antiTerms: [{
				term:          "Audit log"
				clarification: "Observational framing; perde structural property canonical (lineage é structural; log é record)."
			}, {
				term:          "Trace"
				clarification: "Generic; perde causal chain canonical structural."
			}, {
				term:          "Provenance"
				clarification: "Related-but-distinct (provenance é signal-level property; lineage é mechanism-execution causal chain through gate)."
			}, {
				term:          "Versioning"
				clarification: "Different ontological vector (versioning é artifact evolution; lineage é causal chain through execution)."
			}, {
				term:          "Metadata"
				clarification: "Generic catch-all; perde structural causal property canonical."
			}]
			examples: [{
				context:   "IQF scoring mechanism Tier 2 artifact lineage"
				instance:  "Mechanism output (IQF score 87 for supplier X) carries lineage canonical: [Tier 1 signals: NPM EligibilityDecisionEmitted-ref1 @observation-time-T1; DLV DeliveryConfirmed-refs[5] @T2-T6; INV InvoiceApproved-refs[12] @T7-T18; FCE PaymentObligationSettled-refs[8] @T19-T26] → [Mechanism Execution Gate: 5-tuple validated; 8-dimensions validated; Integrity Matrix Pass] → [Tier 2 artifact: IQF v3.2 + weighting [NPM-eligibility=0.2, DLV-performance=0.35, INV-reliability=0.25, FCE-settlement=0.2] + temporal validity: 30-day window]. Lineage NÃO mutable post-emission."
				rationale: "Lineage canonical é structural causal chain; every Tier 2 artifact carries full chain inspectable."
			}, {
				context:   "Forbidden case: lineage truncation"
				instance:  "Consumer NPM emits downstream qualification decision baseado em IQF score but truncates lineage (drops mechanism-version ref + weighting lineage). Detection via cap-mechanism-authority-boundary-enforcement: lineage truncation = Class C interpretability + drift class #8 provenance erosion violation. Escape path #6 provenance degradation triggered."
				rationale: "Lineage truncation é canonical violation, NÃO operational optimization."
			}]
			relatedTerms: [
				"term-provenance",
				"term-lineage-propagation-rules",
				"term-tier-2-mechanism-artifact-substrate",
				"term-mechanism-execution-gate",
				"term-interpretability-class",
			]
			layerMapping: {
				codeTerm: "Lineage"
				apiTerm:  "lineage"
			}
		},
		{
			code:   "term-interpretability-class"
			name:   "Classe de Interpretabilidade"
			termEn: "Interpretability Class"
			definition: """
				Structural mechanism dimension declarando degree of
				interpretability of mechanism output. Enumerable
				canonical: inspectable-full / inspectable-lineage /
				opaque-blocked. Inspectable-lineage minimum canonical
				em authority surface; opaque-blocked forbidden em
				canonical authority surface (downgrade FORBIDDEN per
				3rd of 4 FORBIDDEN mutations per cap-mechanism-governance-
				mutation-control). Constitutional anchor C15 mechanism
				interpretability preservation.
				"""
			category:  "classification"
			rationale: "Term canoniza interpretability como structural property declared canonical, NÃO operational concern. Opaque mechanism outputs lead to invisible governance + accountability erosion + authority leakage invisibility."
			antiTerms: [{
				term:          "Explainability"
				clarification: "Adjacent but distinct ontological vector (explainability é post-hoc explanation generation; interpretability é structural property declared canonical pre-execution)."
			}, {
				term:          "Transparency"
				clarification: "Generic + benevolence-framed (CP6 anti-benevolent-language camouflage); perde structural class canonical."
			}, {
				term:          "Auditability"
				clarification: "Related but different vector (auditability é audit chain reconstructability; interpretability é structural inspectability of mechanism output)."
			}]
			rejectedAlternatives: [{
				term:   "InterpretabilityLevel"
				reason: "Sugere measurement continuum; canonical is enumerable class."
			}]
			examples: [{
				context:   "Mechanism declares interpretability-class explicit"
				instance:  "IQF scoring mechanism canonical declares interpretability-class=inspectable-lineage; weighting lineage explicit + signal contribution lineage explicit + temporal validity envelope inspectable. Authority surface canonical (NPM, REW, SSC) consumes with full lineage inspectability. Downgrade to opaque-blocked = FORBIDDEN canonical (mutation rejected at submission per cap #14)."
				rationale: "Class é structural property, NÃO marketing claim."
			}, {
				context:   "FORBIDDEN mutation attempt detection"
				instance:  "Mutation proposal: 'Migrate IQF interpretability-class from inspectable-lineage to opaque-blocked for IP protection reasons.' Result: REJECTED at submission per 3rd FORBIDDEN mutation row. Audit event + constitutional integrity containment review."
				rationale: "Interpretability class downgrade FORBIDDEN preserves C15 + accountability discipline canonical."
			}]
			relatedTerms: [
				"term-mechanism-dimension",
				"term-lineage",
				"term-mechanism-mutation-governance",
				"term-mechanism-execution-gate",
			]
			layerMapping: {
				codeTerm: "InterpretabilityClass"
				apiTerm:  "interpretability-class"
			}
		},
		{
			code:   "term-authority-surface"
			name:   "Superfície de Autoridade"
			termEn: "Authority Surface"
			definition: """
				Structural property canonical declarando bounded scope
				of mechanism output authority per consumer × mechanism
				pair. NÃO universal; aggregation cross-consumer forbidden
				por construção. Authority surface é INPUT scope
				declaration, NÃO decision scope.
				"""
			category:  "classification"
			rationale: "Authority surface é 3rd dimension do 5-tuple discipline canonical. Per consumer × mechanism pair bounded canonical."
			antiTerms: [{
				term:          "Permission scope"
				clarification: "Security framing; perde governance canonical."
			}, {
				term:          "Authority domain"
				clarification: "Generic; perde bounded per pair canonical."
			}]
			relatedTerms: [
				"term-tuple-authority-boundary",
				"term-consumer-bc-authority",
			]
			layerMapping: {
				codeTerm: "AuthoritySurface"
				apiTerm:  "authority-surface"
			}
		},
		{
			code:   "term-consumer-bc-authority"
			name:   "Autoridade do BC Consumidor"
			termEn: "Consumer BC Authority"
			definition: """
				Canonical bounded authority preserved by each consumer
				BC over own decision pathway. NIM mechanism outputs são
				INPUT a consumer authority, NÃO authority substitution.
				Per Phase 1.2.B matrix: NPM canonical authority over
				eligibility decisions; REW over risk pricing; SSC over
				sourcing decisions; etc.
				"""
			category:  "classification"
			rationale: "Term canoniza consumer authority preservation discipline — defesa contra drift class #7 authority delegation."
			antiTerms: [{
				term:          "Consumer permission"
				clarification: "Perde canonical authority framing."
			}, {
				term:          "Delegated authority"
				clarification: "CP5 — delegation drift class #7 canonical anti-pattern."
			}]
			relatedTerms: [
				"term-tuple-authority-boundary",
				"term-authority-surface",
				"term-authority-delegation-drift",
			]
			layerMapping: {
				codeTerm: "ConsumerBCAuthority"
				apiTerm:  "consumer-bc-authority"
			}
		},
		{
			code:   "term-lineage-propagation-rules"
			name:   "Regras de Propagação de Linhagem"
			termEn: "Lineage Propagation Rules"
			definition: """
				Canonical rules governing how lineage propagates from
				Tier 1 signals through mechanism execution to consumer
				downstream consumption. 4 forbidden cases canonical:
				lineage truncation + lineage aggregation + lineage
				opacity + lineage rewriting (Phase 1.5.B Section E +
				Phase 1.5.B ajuste #5 lineage rewriting). Materializa
				CC3 provenance + authority boundary preserved.
				"""
			category:  "process"
			rationale: "Lineage propagation discipline canonical — sem rules, lineage truncation/aggregation/opacity/rewriting drift inevitable downstream."
			antiTerms: [{
				term:          "Audit propagation rules"
				clarification: "Generic; perde lineage canonical structural."
			}, {
				term:          "Metadata flow"
				clarification: "Generic catch-all."
			}]
			relatedTerms: [
				"term-lineage",
				"term-provenance",
			]
			layerMapping: {
				codeTerm: "LineagePropagationRules"
				apiTerm:  "lineage-propagation-rules"
			}
		},
		{
			code:   "term-escape-path"
			name:   "Caminho de Escape"
			termEn: "Escape Path"
			definition: """
				Canonical 6 escape pathway classes (per Phase 1.2.B
				Section D + Phase 1.2.B ajuste #3 provenance degradation):
				(1) insufficient signal escape + (2) conflicting
				mechanism escape + (3) stale mechanism escape + (4)
				authority overflow escape + (5) feedback loop escape +
				(6) provenance degradation escape. Escape paths são
				canonical pathways quando consumer × mechanism pair
				encontra boundary OR violation; preservam consumer
				canonical authority pathway.
				"""
			category:  "classification"
			rationale: "Escape paths canonical preservam consumer authority pathway quando boundary detected — 5th dimension 5-tuple discipline."
			antiTerms: [{
				term:          "Exception handling"
				clarification: "Generic technical framing."
			}, {
				term:          "Fallback pathway"
				clarification: "Generic; perde escape canonical structural."
			}]
			relatedTerms: [
				"term-tuple-authority-boundary",
			]
			layerMapping: {
				codeTerm: "EscapePath"
				apiTerm:  "escape-paths"
			}
		},

		// ====================================================================
		// CLUSTER D — DRIFT CLASS + GOVERNANCE VOCABULARY (9 terms)
		// ====================================================================

		{
			code:   "term-mechanism-mutation-governance"
			name:   "Governança de Mutação de Mecanismo"
			termEn: "Mechanism Mutation Governance"
			definition: """
				Discipline canonical governing mechanism mutations
				(formulae change, weighting recalibration, new mechanism
				type declaration, authority surface expansion). Mutations
				são explicit ADR-bound governance acts, NÃO autonomous
				learning OR operational tuning. 10 mutation classification
				rows canonical (additive architectural reviewer →
				semantic architectural reviewer → identity-altering
				founder-only → 4 FORBIDDEN constitutional core não-
				negociável). 4 FORBIDDEN canonical: (1) adversarial-
				resistance-class downgrade + (2) 5-tuple field removal
				+ (3) interpretability class relaxation (downgrade to
				opaque-blocked) + (4) objective-function substitution.
				Observation cycles canonical: 90-day default, 180-day
				critical para replay-sensitive + recursive-feedback +
				cross-BC-authority + adversarial-resistance-critical
				domains.
				"""
			category:  "classification"
			rationale: "Term materializa C6 no-implicit-policy + C9 NOT autonomous policy optimizer + 4th anti-drift clause governance-cannot-self-weaken. Per Phase 1.5 + Phase 1.5.B + Phase 1.7 forward observation: 'em NIM, mudar mecanismo = mudar política; mudar weighting = redistribuir poder; mudar objective function = alterar comportamento sistêmico da rede'. Mutation governance discipline é primary defense contra drift class #3 implicit policy creep + #9 objective-function drift."
			antiTerms: [{
				term:          "Mechanism tuning"
				clarification: "Operational framing; perde governance act canonical (CP2 anti-optimization euphemism — tuning is mutation euphemism)."
			}, {
				term:          "Mechanism calibration"
				clarification: "Adjacent but distinct (calibration é within-spec; mutation is spec-altering); preserve distinction."
			}, {
				term:          "Model retraining"
				clarification: "ML-platform vocabulary perde governance framing canonical (NÃO autonomous policy optimizer per C9)."
			}, {
				term:          "Mechanism update"
				clarification: "Banal framing perde ADR-bound governance act + 4 FORBIDDEN canonical structural."
			}]
			rejectedAlternatives: [{
				term:   "MechanismChangeControl"
				reason: "IT change management framing perde governance canonical."
			}, {
				term:   "AlgorithmGovernance"
				reason: "Algorithmic framing collapses 'mechanism' canonical."
			}, {
				term:   "MutationApproval"
				reason: "Perde 'governance' canonical discipline + 4 FORBIDDEN structural."
			}]
			examples: [{
				context:   "Mutation classification: founder-only + ADR + SRR + 90-day cycle"
				instance:  "Proposed mutation: 'Add 7th canonical mechanism type (e.g., trust-scoring distinct from IQF Scoring).' Classification: founder-only (sovereignty-defining) + ADR documenting 5-predicate satisfaction + parallel SRR + 90-day observation cycle minimum. Mutation pathway preserves governance discipline canonical."
				rationale: "Mechanism type expansion é structural identity altering; bare architectural reviewer approval insufficient."
			}, {
				context:   "4 FORBIDDEN mutation rejected at submission"
				instance:  "Proposed mutation: 'Downgrade IQF interpretability-class from inspectable-lineage to opaque-blocked.' Result: REJECTED canonical at submission per 3rd FORBIDDEN row (interpretability class relaxation). Audit event + constitutional integrity containment review."
				rationale: "FORBIDDEN canonical NÃO negociáveis — preserve constitutional core não-negociável structural."
			}, {
				context:   "180-day critical cycle (cross-BC authority domain)"
				instance:  "Proposed mutation: 'Expand scoring authority surface to add new consumer BC (e.g., DRC).' Classification: founder-only + ADR + parallel SRR + 180-day cycle critical (cross-BC-authority domain per Phase 1.5 ajuste #4). Extended observation cycle preserves authority topology evolution discipline."
				rationale: "Cross-BC authority expansion é high-blast-radius; extended observation cycle canonical."
			}]
			relatedTerms: [
				"term-drift-classes",
				"term-implicit-policy-creep",
				"term-objective-function-drift",
				"term-recursive-governance",
				"term-meta-constitutional-bc-pattern",
			]
			layerMapping: {
				codeTerm: "MechanismMutationGovernance"
				apiTerm:  "mechanism-mutation-governance"
			}
		},
		{
			code:   "term-authority-chain-reinforcement"
			name:   "Reforço de Cadeia de Autoridade"
			termEn: "Authority Chain Reinforcement"
			definition: """
				CRITICAL+ existential drift pattern canonical where
				consumer BC re-emits mechanism output as new authority
				signal, creating chain canonical: mechanism → consumer
				legitimacy → institutional policy → invisible authority
				substrate. Distinct from authority delegation drift (#7)
				which é decision substitution; authority chain
				reinforcement é more profound — creates aggregated
				legitimacy substrate gradually transforming mechanism
				artifact em governance authority autonomous. Per Phase
				1.5.B Section D Pattern #2 + Phase 1.6 ajuste #3: drift
				mais perigoso do sistema inteiro; constitutional review
				pathway DIRETO bypass normal escalation.
				"""
			category:  "classification"
			rationale: "Term canoniza Pattern #2 CRITICAL+ canonical — drift trajectory: score → legitimacy → policy → invisible governance substrate. Distinct from delegation (which é boundary violation per dispatch) — chain reinforcement é institutional pattern across time."
			antiTerms: [{
				term:          "Authority cascading"
				clarification: "Generic distribution framing perde reinforcement canonical drift semantics."
			}, {
				term:          "Legitimacy emergence"
				clarification: "Naturalization framing perde drift + CRITICAL+ severity canonical."
			}, {
				term:          "Authority delegation drift"
				clarification: "Adjacent-but-distinct (delegation é boundary violation; chain reinforcement é institutional reinforcement pattern)."
			}]
			rejectedAlternatives: [{
				term:   "AuthorityChainEffect"
				reason: "Neutral framing perde drift + CRITICAL+ classification."
			}]
			examples: [{
				context:   "Pattern #2 detection canonical"
				instance:  "Consumer NPM receives IQF scoring output (5-tuple authority surface: eligibility decision INPUT bounded). Pattern detection: NPM begins emitting downstream signal 'NIM-blessed-supplier' carrying NIM authority claim AS NPM authority signal. Detection: cap-mechanism-authority-boundary-enforcement + outbound event signature audit pattern match. Class: CRITICAL+ existential (distinct from HIGH boundary violation). Response: BYPASS normal escalation pathways + DIRECT constitutional review pathway per Phase 1.6 ajuste #3."
				rationale: "Chain reinforcement detected é existential threat — drift mais perigoso do sistema inteiro requires direct constitutional review."
			}]
			relatedTerms: [
				"term-authority-delegation-drift",
				"term-legitimacy-accumulation-risk",
				"term-mechanism-legitimacy-capture",
				"term-drift-classes",
			]
			layerMapping: {
				codeTerm: "AuthorityChainReinforcement"
				apiTerm:  "authority-chain-reinforcement"
			}
		},
		{
			code:   "term-recursive-governance"
			name:   "Governança Recursiva"
			termEn: "Recursive Governance"
			definition: """
				Canonical concept materializing CC6 Recursive
				Epistemological Governance Explicitness. Recursive
				governance loops emerge structural canonical via
				bidirectional epistemic feedback topology: mechanism
				output → consumer decision → consumer signal back to
				NIM substrate → mechanism execution influenced by own
				prior output. Loops MUST remain explicit + inspectable
				+ bounded. Hidden recursive optimization forbidden.
				Loop markers canonical (loopId + recursionDepth +
				recursionPath + boundedReviewRequired + loopOriginRef +
				loopRiskClass) preserve visibility of recursive patterns
				+ enable bounded review triggers.
				"""
			category:  "classification"
			rationale: "Term canoniza recursive epistemological governance discipline canonical — NIM-specific addition beyond Family Mesh inheritance. Bidirectional epistemic feedback topology é única camada com dependência bidirecional por design; recursive loops são structural feature canonical (NÃO bug). Discipline preserves loop visibility + bounded review pathway canonical; alternative é invisible recursive reinforcement collapse (reflexive governance risk canonical drift)."
			antiTerms: [{
				term:          "Feedback control"
				clarification: "Engineering control-theory framing perde epistemological + governance dimensions canonical."
			}, {
				term:          "Adaptive system"
				clarification: "Implies autonomous adaptation (C9 NOT autonomous policy optimizer violation)."
			}, {
				term:          "Self-optimizing loop"
				clarification: "CP2 anti-optimization euphemism direct violation; recursive governance is bounded + explicit, NÃO autonomous."
			}]
			rejectedAlternatives: [{
				term:   "RecursiveEpistemologicalGovernance"
				reason: "Verbose; 'recursive governance' captures canonical sufficient."
			}, {
				term:   "FeedbackLoopGovernance"
				reason: "Perde epistemological dimension canonical."
			}]
			examples: [{
				context:   "SSC sourcing decision loop canonical"
				instance:  "NIM ranking output → SSC sourcing decision → SSC emits SourcingDecisionEmitted event → NIM ingests as Tier 1 signal → next ranking execution influenced by SSC sourcing history → loop. Loop marker emitted explicit: loopId=X + recursionDepth=N + recursionPath=[ranking-mech, ssc-bc, ssc-decision, sourcing-signal, ranking-mech] + boundedReviewRequired=true if depth > 2 OR loopRiskClass=critical."
				rationale: "Recursive loops são structural feature; visibility + bounded review canonical."
			}]
			relatedTerms: [
				"term-feedback-loop-drift",
				"term-bidirectional-epistemic-feedback-topology",
			]
			layerMapping: {
				codeTerm: "RecursiveGovernance"
				apiTerm:  "recursive-governance"
			}
		},
		{
			code:   "term-drift-classes"
			name:   "Classes de Drift"
			termEn: "Drift Classes"
			definition: """
				Umbrella canonical enumerating 9 drift classes em 3
				families: Constitutional drift vectors (drift-1-mechanism-
				gaming + drift-2-pseudo-objectivity-collapse + drift-3-
				implicit-policy-creep + drift-9-objective-function-
				drift) + Recursive-system drift vectors (drift-4-
				reputation-drift + drift-5-feedback-loop-drift + drift-7-
				authority-delegation-drift + drift-8-provenance-erosion)
				+ Optimization gravity drift (drift-6-engagement-gravity).
				Per Phase 1.1 founder ajuste #3 grouping. Internal
				canonical drift IDs preserve future extraction path
				canonical.
				"""
			category:  "rule"
			rationale: "Umbrella term per Phase 2.4 founder ajuste #1: NÃO break em 9 termos próprios agora (umbrella mantém + termos próprios podem emergir em domain-model se virarem invariants/services). Internal IDs preserve granularity canonical."
			relatedTerms: [
				"term-mechanism-gaming",
				"term-pseudo-objectivity-collapse",
				"term-implicit-policy-creep",
				"term-objective-function-drift",
				"term-authority-delegation-drift",
			]
			layerMapping: {
				codeTerm: "DriftClasses"
				apiTerm:  "drift-classes"
			}
		},
		{
			code:   "term-mechanism-gaming"
			name:   "Gaming de Mecanismo"
			termEn: "Mechanism Gaming"
			definition: """
				Drift class #1 top-3 constitutional severity. Adversarial
				actors manipulating scoring algorithms (Goodhart's law
				operationalized). Defended via cap-adversarial-resistance-
				evaluation + adversarial-resistance-class structural
				dimension + C8.
				"""
			category:  "rule"
			rationale: "Drift class canonical foundational — gaming pressure structural NÃO transient per as-nim-adversarial-pressure-structural assumption."
			antiTerms: [{
				term:          "Abuse"
				clarification: "Informal framing perde Goodhart canonical."
			}, {
				term:          "Fraud"
				clarification: "Legal term — distinct category (fraud é jurídico; gaming é structural Goodhart)."
			}]
			relatedTerms: [
				"term-drift-classes",
				"term-adversarial-resistance-class",
			]
			layerMapping: {
				codeTerm: "MechanismGaming"
				apiTerm:  "mechanism-gaming"
			}
		},
		{
			code:   "term-pseudo-objectivity-collapse"
			name:   "Colapso de Pseudo-Objetividade"
			termEn: "Pseudo Objectivity Collapse"
			definition: """
				Drift class #2 top-3 constitutional severity. Algorithmic
				outputs treated as objective truth ('score says X,
				therefore X'). Truth-claim framing of mechanism outputs
				forbidden por construção. Defended via C3 + Phase 1.1
				anti-goal NOT-truth-engine + CC1 mechanism integrity
				facts only.
				"""
			category:  "rule"
			rationale: "Drift class canonical — collapse de signal em truth claim é principal vector ontological collapse NIM."
			antiTerms: [{
				term:          "Objectivity bias"
				clarification: "Collapses canonical canonical."
			}, {
				term:          "Data-driven illusion"
				clarification: "Generic."
			}]
			relatedTerms: [
				"term-drift-classes",
			]
			layerMapping: {
				codeTerm: "PseudoObjectivityCollapse"
				apiTerm:  "pseudo-objectivity-collapse"
			}
		},
		{
			code:   "term-implicit-policy-creep"
			name:   "Creep de Política Implícita"
			termEn: "Implicit Policy Creep"
			definition: """
				Drift class #3 top-3 constitutional severity. Mechanism
				mutations becoming covert policy changes sem governance
				review. Governance mutation sem governance recognition.
				Defended via cap-mechanism-governance-mutation-governance
				+ ADR-bound mutations + C6 no-implicit-policy.
				"""
			category:  "rule"
			rationale: "Drift class canonical — governance mutation invisível é existencial para NIM (mudar mecanismo = mudar política)."
			antiTerms: [{
				term:          "Gradual improvement"
				clarification: "CP2 euphemism direct violation."
			}, {
				term:          "Operational evolution"
				clarification: "Perde 'policy' framing canonical critical."
			}]
			relatedTerms: [
				"term-drift-classes",
				"term-mechanism-mutation-governance",
			]
			layerMapping: {
				codeTerm: "ImplicitPolicyCreep"
				apiTerm:  "implicit-policy-creep"
			}
		},
		{
			code:   "term-objective-function-drift"
			name:   "Drift de Função Objetivo"
			termEn: "Objective Function Drift"
			definition: """
				Drift class #9 NEW per Phase 1.0 founder ajuste #5.
				Optimization target slowly diverges from declared
				constitutional objective via local metric substitutions,
				proxy optimization, OR operational convenience pressure.
				Examples: quality → engagement; reliability → response
				rate; epistemic confidence → throughput; trustworthiness
				→ popularity. Distinct from #3 implicit policy creep:
				#3 = governance mutation invisível; #9 = target mutation
				invisível. Defended via 4th FORBIDDEN mutation row
				(objective-function substitution canonical) + C13.
				"""
			category:  "rule"
			rationale: "Drift class canonical NEW — target mutation invisível distinct from governance mutation invisível (drift #3). Os dois juntos explicam praticamente toda degradação moderna de sistemas algorítmicos."
			antiTerms: [{
				term:          "Metric optimization"
				clarification: "CP2 + collapses canonical."
			}, {
				term:          "KPI refinement"
				clarification: "Corporate vocabulary perde structural framing."
			}]
			relatedTerms: [
				"term-drift-classes",
				"term-mechanism-mutation-governance",
			]
			layerMapping: {
				codeTerm: "ObjectiveFunctionDrift"
				apiTerm:  "objective-function-drift"
			}
		},
		{
			code:   "term-authority-delegation-drift"
			name:   "Drift de Delegação de Autoridade"
			termEn: "Authority Delegation Drift"
			definition: """
				Drift class #7. Consumer BCs consumindo mechanism scores
				como decision substitute ('just follow the score'
				narrative). Materializes epistemic monoculture risk.
				Defended via cap-mechanism-authority-boundary-enforcement
				+ 5-tuple discipline + C14 no-universal-score-authority
				+ Phase 1.2.B authority matrix. Distinct from authority-
				chain-reinforcement (Pattern #2 institutional cross-time
				pattern); delegation drift é per-dispatch boundary
				violation.
				"""
			category:  "rule"
			rationale: "Drift class canonical — delegation per-dispatch boundary violation distinct from chain reinforcement institutional pattern."
			antiTerms: [{
				term:          "Smart automation"
				clarification: "CP2 + Cluster E 'smart' forbidden."
			}, {
				term:          "Decision streamlining"
				clarification: "CP2 euphemism."
			}, {
				term:          "Authority chain reinforcement"
				clarification: "Adjacent but distinct (delegation = per-dispatch; chain reinforcement = institutional pattern across time)."
			}]
			relatedTerms: [
				"term-drift-classes",
				"term-authority-chain-reinforcement",
				"term-consumer-bc-authority",
			]
			layerMapping: {
				codeTerm: "AuthorityDelegationDrift"
				apiTerm:  "authority-delegation-drift"
			}
		},

		// ====================================================================
		// CLUSTER E — SEMANTIC HAZARD WATCHLIST (26 terms)
		// (Semantic containment infrastructure, NÃO catalog auxiliar)
		// ====================================================================

		{
			code:   "term-semantic-gravity-escalation"
			name:   "Escalação de Gravidade Semântica"
			termEn: "Semantic Gravity Escalation"
			definition: """
				Canonical concept declarando que semantic risk é time-
				dependent: certain terms começam apparently neutral mas
				gradually accumulate authority semantics through
				repetition, cross-BC propagation, and institutional
				adoption. Hazard classification não é static; deve
				evoluir com adoption trajectory. Mechanism canonical
				BOUNDED → FORBIDDEN promotion criterion canonical
				(per Phase 2.5 founder ajuste #6): 'quando o termo
				começa a aparecer como autoridade, decisão, verdade,
				legitimidade institucional ou substituto de consumer
				judgment'.
				"""
			category:  "classification"
			rationale: "Umbrella concept Cluster E canonical — tying Cluster E ao Phase 1.7 forward observation #6 Legitimacy accumulation risk + Phase 1.6 misalignment #7 Mechanism Legitimacy Capture + CC6 Recursive Epistemological Governance."
			examples: [{
				context:   "Term lifecycle canonical trajectory"
				instance:  "'score' begins numerical → vira authority substrate institutional; 'trusted' begins relational → vira legitimacy assertion; 'verified' begins procedural → vira authority claim; 'recommended' begins suggestion → vira engagement-driven authority."
				rationale: "Semantic risk é time-dependent canonical; defense canonical via vm-nim-legitimacy-accumulation-monitoring + Cluster E watchlist evolution + Phase 5 governance envelope review cycles."
			}]
			relatedTerms: [
				"term-legitimacy-accumulation-risk",
				"term-mechanism-legitimacy-capture",
				"term-epistemic-dependency-normalization",
			]
			layerMapping: {
				codeTerm: "SemanticGravityEscalation"
				apiTerm:  "semantic-gravity-escalation"
			}
		},
		{
			code:   "term-watch-recommendation"
			name:   "Vigilância — Recommendation"
			termEn: "Watch Recommendation"
			definition: """
				FORBIDDEN canonical em NIM vocabulary. Engagement-driven
				authority disguised as suggestion. 'Recommendation'
				carries behavioral inference semantics + implies
				personalization + creates engagement gravity attractor
				+ collapses NIM specification authority into engagement
				engine framing.

				Canonical replacement: 'GovernedSuggestion' (term-governed-
				suggestion Cluster B). Distinct canonical: bounded non-
				personalized governance suggestion + consumer canonical
				authority preserved + NÃO behavioral inference + NÃO
				engagement-driven.

				Semantic gravity escalation trajectory: Phase initial
				harmless suggestion → Phase intermediate personalization
				creep → Phase critical institutional authority +
				engagement engine attractor materializado.

				Forbidden variants: 'personalized recommendation' +
				'smart recommendation' + 'AI recommendation' +
				'recommended for you' + 'recommended supplier' +
				'recommendation engine' + 'trending recommendations' +
				'top recommendations' + 'curated' + 'selected for you'
				+ 'AI-picked' + 'personalized shortlist'.
				"""
			category:  "classification"
			rationale: "FORBIDDEN canonical — most dangerous engagement gravity attractor canonical em NIM vocabulary. Defense canonical: GovernedSuggestion canonical naming + drift class #6 engagement gravity + Phase 1.1 anti-goal NOT recommendation API + 11 anti-goals canonical."
			relatedTerms: [
				"term-governed-suggestion",
				"term-semantic-gravity-escalation",
			]
			layerMapping: {
				codeTerm: "WatchRecommendation"
				apiTerm:  "watch-recommendation"
			}
		},
		{
			code:   "term-watch-intelligent"
			name:   "Vigilância — Intelligent"
			termEn: "Watch Intelligent"
			definition: """
				FORBIDDEN canonical em NIM vocabulary (per Phase 2.1
				ajuste #5). Epistemic superiority + optimization
				authority disguised as capability + anthropomorphic
				legitimacy implication. 'Intelligent' acelera (a)
				legitimacy accumulation canonical, (b) authority
				laundering, (c) epistemic dependency normalization.
				Triple gravity vector canonical per founder framing.

				Canonical replacement: 'specification-bound mechanism'
				OR 'inspectable mechanism execution' OR specific
				mechanism description (NÃO genericized intelligence
				framing). Mechanism é structural artifact, NÃO
				intelligent agent canonical.

				Semantic gravity escalation trajectory: Phase initial
				marketing language → Phase intermediate capability
				claim → Phase critical institutional epistemic
				superiority — legitimacy laundering catastrophic.

				Forbidden variants: 'intelligent mechanism' + 'intelligent
				governance' + 'intelligent ranking' + 'intelligent trust
				layer' + 'AI intelligence scoring' + 'intelligent
				automation' + 'AI-intelligent' + 'intelligent decision
				support' + 'intelligent recommendation'.
				"""
			category:  "classification"
			rationale: "FORBIDDEN canonical — anthropomorphic framing forbidden por construção + C9 NOT autonomous policy optimizer + Phase 1.1 anti-goal NOT learning system genérico + canonical replacements explicit."
			relatedTerms: [
				"term-mechanism",
				"term-semantic-gravity-escalation",
			]
			layerMapping: {
				codeTerm: "WatchIntelligent"
				apiTerm:  "watch-intelligent"
			}
		},
		{
			code:   "term-watch-unbiased"
			name:   "Vigilância — Unbiased"
			termEn: "Watch Unbiased"
			definition: """
				FORBIDDEN canonical em NIM vocabulary (per Phase 2.0
				ajuste #3 — extremely dangerous em meta-constitutional
				systems). Epistemic legitimacy claim disguised as
				methodology. 'Unbiased' frames mechanism output como
				objective neutral substrate transcending bias — implicit
				authority claim de epistemic superiority over biased
				alternatives. Particularly dangerous em meta-
				constitutional systems porque transforma mechanism em
				arbiter of bias (meta-authority claim).

				Canonical replacement: 'bounded scope + explicit
				weighting lineage + declared epistemic-class'. NIM
				mechanisms NÃO claim absence of bias; declare structural
				scope + lineage + epistemic class explicit per C3 + C15.

				Semantic gravity escalation trajectory: Phase initial
				methodology description → Phase intermediate epistemic
				claim → Phase critical meta-authority — arbiter-of-bias
				positioning catastrophic.

				Forbidden variants: 'unbiased scoring' + 'unbiased
				ranking' + 'unbiased AI' + 'bias-free mechanism' +
				'objective unbiased methodology' + 'neutral unbiased
				substrate'.
				"""
			category:  "classification"
			rationale: "FORBIDDEN canonical — extremely dangerous per founder Phase 2.0 ajuste #3. Defense canonical: Phase 1.1 anti-goal NOT truth engine + C3 algorithmic-output-is-signal-not-decision + interpretability-class inspectable-lineage canonical."
			relatedTerms: [
				"term-semantic-gravity-escalation",
			]
			layerMapping: {
				codeTerm: "WatchUnbiased"
				apiTerm:  "watch-unbiased"
			}
		},
		{
			code:   "term-watch-consensus"
			name:   "Vigilância — Consensus"
			termEn: "Watch Consensus"
			definition: """
				FORBIDDEN canonical em NIM vocabulary (per Phase 2.0
				ajuste #3 — meta-constitutional legitimacy aggregation
				risk extremely dangerous). Legitimacy aggregation
				disguised as convergence. 'Consensus' frames cross-BC
				adoption + cross-actor agreement como spontaneous
				legitimacy convergence — hides authority chain
				reinforcement (Pattern #2 CRITICAL+ existential) +
				universal substrate convergence (Pattern #3) + Mechanism
				Legitimacy Capture (incentive #7 pre-hegemonic drift).
				Most dangerous em meta-constitutional systems per
				founder framing.

				Canonical replacement: 'cross-BC consumption pattern
				(bounded per consumer × mechanism pair)' OR 'authority
				surface aggregation declared explicit'. NIM NÃO produces
				consensus; produces bounded mechanism outputs canonical
				per 5-tuple authority boundary.

				Semantic gravity escalation trajectory: Phase initial
				descriptive → Phase intermediate legitimacy claim →
				Phase critical meta-authority — meta-constitutional
				authority claim catastrophic existential.

				Forbidden variants: 'consensus scoring' + 'consensus
				ranking' + 'market consensus' + 'consensus authority'
				+ 'consensus-based governance' + 'consensus mechanism'.
				"""
			category:  "classification"
			rationale: "FORBIDDEN canonical — extremely dangerous per founder Phase 2.0 ajuste #3. Defense canonical: C14 no-universal-score-authority + Pattern #2/#3 detection canonical + Phase 1.7 forward observation #6 Legitimacy accumulation risk + Phase 1.6 misalignment #7 Mechanism Legitimacy Capture."
			relatedTerms: [
				"term-authority-chain-reinforcement",
				"term-legitimacy-accumulation-risk",
				"term-mechanism-legitimacy-capture",
				"term-semantic-gravity-escalation",
			]
			layerMapping: {
				codeTerm: "WatchConsensus"
				apiTerm:  "watch-consensus"
			}
		},
		{
			code:   "term-watch-alignment"
			name:   "Vigilância — Alignment"
			termEn: "Watch Alignment"
			definition: """
				FORBIDDEN canonical em NIM vocabulary (per Phase 2.0
				ajuste #3 — extremely dangerous em meta-constitutional
				systems). Policy conformity disguised as coordination.
				'Alignment' frames mechanism mutation OR consumer
				behavior conformity como benign coordination — hides
				implicit policy creep (drift class #3) + objective-
				function drift (drift class #9) + governance evolution
				pressure. Especially dangerous porque alignment
				vocabulary carries strong benevolence framing (CP6
				violation).

				Canonical replacement: 'explicit governance pathway'
				OR 'declared canonical specification compliance' OR
				'mutation governance ADR-bound pathway'. NIM operates
				per declared mechanism specification; 'alignment'
				implies normative conformity beyond bounded specification.

				Semantic gravity escalation trajectory: Phase initial
				descriptive → Phase intermediate capability claim →
				Phase critical institutional authority — covert policy
				formation invisible.

				Forbidden variants: 'AI alignment' + 'policy alignment'
				+ 'value alignment' + 'alignment-driven optimization'
				+ 'aligned mechanisms' + 'stakeholder alignment'.
				"""
			category:  "classification"
			rationale: "FORBIDDEN canonical — per founder Phase 2.0 ajuste #3 extremely dangerous. Defense canonical: drift class #3 implicit policy creep + drift class #9 objective-function drift + cap-mechanism-governance-mutation-control + 4 FORBIDDEN mutations canonical."
			relatedTerms: [
				"term-implicit-policy-creep",
				"term-objective-function-drift",
				"term-semantic-gravity-escalation",
			]
			layerMapping: {
				codeTerm: "WatchAlignment"
				apiTerm:  "watch-alignment"
			}
		},
		{
			code:        "term-watch-score"
			name:        "Vigilância — Score"
			termEn:      "Watch Score"
			definition:  "BOUNDED canonical (mandatory disambiguation). Authority artifact disguised as numeric value. Canonical replacement: 'mechanism scoring output' + 5-tuple authority boundary explicit. Anti-pattern CP5 anti-authority-euphemism."
			category:    "classification"
			rationale:   "BOUNDED — score precisa ser usado canonical; mandatory disambiguation via 5-tuple authority boundary explicit per dispatch."
			relatedTerms: ["term-scoring-mechanism", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchScore", apiTerm: "watch-score"}
		},
		{
			code:        "term-watch-ranking"
			name:        "Vigilância — Ranking"
			termEn:      "Watch Ranking"
			definition:  "BOUNDED canonical (mandatory disambiguation). Authority ordering disguised as relevance. Canonical replacement: 'mechanism ranking output' + bounded authority surface. Anti-pattern CP5."
			category:    "classification"
			rationale:   "BOUNDED — ranking precisa ser usado canonical; mandatory disambiguation."
			relatedTerms: ["term-ranking-mechanism", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchRanking", apiTerm: "watch-ranking"}
		},
		{
			code:        "term-watch-reputation"
			name:        "Vigilância — Reputation"
			termEn:      "Watch Reputation"
			definition:  "BOUNDED canonical (mandatory disambiguation). Aggregate authority disguised as social property. Canonical replacement: 'mechanism-derived reputation signal' + provenance lineage explicit. Anti-patterns CP5 + CP6."
			category:    "classification"
			rationale:   "BOUNDED — reputation é canonical concept mas mandatory framing per lineage + bounded authority."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchReputation", apiTerm: "watch-reputation"}
		},
		{
			code:        "term-watch-trust"
			name:        "Vigilância — Trust"
			termEn:      "Watch Trust"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Authority claim disguised as relationship state. Canonical replacement: 'verification evidence class' + bounded scope. Anti-patterns CP5 + CP6. NIM NÃO produces trust; produces evidence-grounded mechanism outputs canonical."
			category:    "classification"
			rationale:   "FORBIDDEN — trust framing collapses evidence + authority + relationship em single authority claim invisível."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchTrust", apiTerm: "watch-trust"}
		},
		{
			code:        "term-watch-smart"
			name:        "Vigilância — Smart"
			termEn:      "Watch Smart"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Autonomous optimization disguised as capability. Canonical replacement: 'specification-bound mechanism'. Anti-patterns CP2 + CP5."
			category:    "classification"
			rationale:   "FORBIDDEN — 'smart' carries autonomous optimization implication + CP2 violation direct."
			relatedTerms: ["term-mechanism", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchSmart", apiTerm: "watch-smart"}
		},
		{
			code:        "term-watch-best"
			name:        "Vigilância — Best"
			termEn:      "Watch Best"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Authority claim disguised as comparative. Canonical replacement: 'highest-scored within declared scope' + bounded. Anti-pattern CP5."
			category:    "classification"
			rationale:   "FORBIDDEN — 'best' authority claim absoluto perde scope canonical."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchBest", apiTerm: "watch-best"}
		},
		{
			code:        "term-watch-trusted"
			name:        "Vigilância — Trusted"
			termEn:      "Watch Trusted"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Authority assertion disguised as descriptive property. Canonical replacement: 'verification-evidenced + bounded scope'. Anti-patterns CP5 + CP6."
			category:    "classification"
			rationale:   "FORBIDDEN — adjective 'trusted' hides authority assertion as descriptive state."
			relatedTerms: ["term-watch-trust", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchTrusted", apiTerm: "watch-trusted"}
		},
		{
			code:        "term-watch-top"
			name:        "Vigilância — Top"
			termEn:      "Watch Top"
			definition:  "BOUNDED canonical. Authority ordering disguised as positional. Canonical replacement: 'ordered-rank position N' + bounded ranking scope. Anti-patterns CP4 + CP5."
			category:    "classification"
			rationale:   "BOUNDED — 'top' precisa ser usado canonical mas com bounded scope explicit."
			relatedTerms: ["term-ranking-mechanism", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchTop", apiTerm: "watch-top"}
		},
		{
			code:        "term-watch-reliable"
			name:        "Vigilância — Reliable"
			termEn:      "Watch Reliable"
			definition:  "BOUNDED canonical. Authority claim disguised as durability property. Canonical replacement: 'reliability-evidenced + lineage-traceable'. Anti-patterns CP6 + CP5."
			category:    "classification"
			rationale:   "BOUNDED — reliable canonical concept mas mandatory framing per evidence + lineage."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchReliable", apiTerm: "watch-reliable"}
		},
		{
			code:        "term-watch-fair"
			name:        "Vigilância — Fair"
			termEn:      "Watch Fair"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Substantive authority claim disguised as procedural. NIM NÃO é fairness authority; fairness é consumer-canonical concern, NÃO mechanism property. Anti-patterns CP3 + CP6."
			category:    "classification"
			rationale:   "FORBIDDEN — fairness é consumer-canonical concern NÃO NIM mechanism property; per Phase 1.1 anti-goal NOT truth engine."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchFair", apiTerm: "watch-fair"}
		},
		{
			code:        "term-watch-optimized"
			name:        "Vigilância — Optimized"
			termEn:      "Watch Optimized"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Mechanism mutation disguised as improvement. Canonical replacement: NÃO usar — mechanism mutations são explicit ADR-bound governance acts. Anti-pattern CP2."
			category:    "classification"
			rationale:   "FORBIDDEN — 'optimized' carries autonomous improvement framing violating C9 NOT autonomous policy optimizer."
			relatedTerms: ["term-mechanism-mutation-governance", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchOptimized", apiTerm: "watch-optimized"}
		},
		{
			code:        "term-watch-confidence"
			name:        "Vigilância — Confidence"
			termEn:      "Watch Confidence"
			definition:  "BOUNDED canonical (canonical concept). Mechanism epistemic claim — bounded canonical OK with disambiguation. Canonical use: 'confidence-class snapshot' + epistemic-class explicit. Anti-pattern CP3-adjacent."
			category:    "classification"
			rationale:   "BOUNDED — confidence canonical bounded property mas requires explicit class + epistemic framing."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchConfidence", apiTerm: "watch-confidence"}
		},
		{
			code:        "term-watch-risk"
			name:        "Vigilância — Risk"
			termEn:      "Watch Risk"
			definition:  "OUT-OF-SCOPE canonical. Risk authority disguised as NIM concern. Canonical: NÃO NIM canonical (REW canonical authority); cross-reference apenas para signal contribution. Anti-pattern: cross-domain authority capture."
			category:    "classification"
			rationale:   "OUT-OF-SCOPE — risk é REW canonical authority; NIM mechanism outputs são input signal apenas, NÃO risk verdict."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchRisk", apiTerm: "watch-risk"}
		},
		{
			code:        "term-watch-quality"
			name:        "Vigilância — Quality"
			termEn:      "Watch Quality"
			definition:  "BOUNDED canonical (mandatory disambiguation). Substantive authority disguised as adjective. Canonical replacement: 'quality-evidenced + provenance-traceable signal contribution'. Anti-patterns CP6 + CP3."
			category:    "classification"
			rationale:   "BOUNDED — quality precisa ser usado canonical mas mandatory framing."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchQuality", apiTerm: "watch-quality"}
		},
		{
			code:        "term-watch-safe-safety"
			name:        "Vigilância — Safe / Safety"
			termEn:      "Watch Safe Safety"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Authority assertion disguised as state. Canonical replacement: explicit safety-property declaration + bounded. Anti-pattern CP6 anti-benevolent-language camouflage canonical primary example."
			category:    "classification"
			rationale:   "FORBIDDEN — 'safe' / 'safety' benevolent-language camouflage canonical exemplo direto; hides authority expansion + optimization drift + legitimacy laundering."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchSafeSafety", apiTerm: "watch-safe-safety"}
		},
		{
			code:        "term-watch-neutral"
			name:        "Vigilância — Neutral"
			termEn:      "Watch Neutral"
			definition:  "FORBIDDEN canonical em NIM vocabulary (per Phase 2.0 ajuste #3). Authority laundering through absence-of-bias framing. Canonical replacement: 'scope-bounded + explicit weighting lineage'. Anti-patterns CP3 + CP6."
			category:    "classification"
			rationale:   "FORBIDDEN — 'neutral' canonical authority laundering vector."
			relatedTerms: ["term-watch-unbiased", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchNeutral", apiTerm: "watch-neutral"}
		},
		{
			code:        "term-watch-signal-quality"
			name:        "Vigilância — Signal Quality"
			termEn:      "Watch Signal Quality"
			definition:  "BOUNDED canonical (mandatory disambiguation). Covert weighting authority. Canonical replacement: 'signal weighting-class + provenance-evidenced'. Anti-pattern CP5-adjacent."
			category:    "classification"
			rationale:   "BOUNDED — signal quality canonical concept mas hides weighting authority."
			relatedTerms: ["term-watch-quality", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchSignalQuality", apiTerm: "watch-signal-quality"}
		},
		{
			code:        "term-watch-relevance"
			name:        "Vigilância — Relevance"
			termEn:      "Watch Relevance"
			definition:  "FORBIDDEN canonical em ranking context. Contextual authority disguised as ranking logic. Canonical: NÃO usar em ranking outputs — ranking é ordered list per declared criteria, NÃO relevance verdict. Anti-patterns CP4 + CP5."
			category:    "classification"
			rationale:   "FORBIDDEN em ranking context — relevance carries contextual authority claim invisível."
			relatedTerms: ["term-ranking-mechanism", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchRelevance", apiTerm: "watch-relevance"}
		},
		{
			code:        "term-watch-credibility"
			name:        "Vigilância — Credibility"
			termEn:      "Watch Credibility"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Trust authority disguised as evidence property. Canonical replacement: 'evidence-class + provenance lineage'. Anti-patterns CP5 + CP6."
			category:    "classification"
			rationale:   "FORBIDDEN — credibility collapses evidence + authority em single trust claim."
			relatedTerms: ["term-watch-trust", "term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchCredibility", apiTerm: "watch-credibility"}
		},
		{
			code:        "term-watch-health"
			name:        "Vigilância — Health (Ecosystem)"
			termEn:      "Watch Health"
			definition:  "FORBIDDEN canonical em NIM vocabulary. Optimization authority disguised as state assessment. Canonical: 'ecosystem health' framing forbidden — replaced com explicit metric declaration + bounded scope. Anti-pattern CP6 anti-benevolent-language camouflage."
			category:    "classification"
			rationale:   "FORBIDDEN — 'ecosystem health' benevolent-language camouflage hides optimization authority canonical."
			relatedTerms: ["term-semantic-gravity-escalation"]
			layerMapping: {codeTerm: "WatchHealth", apiTerm: "watch-health"}
		},

		// ====================================================================
		// CLUSTER F — META-CONSTITUTIONAL VOCABULARY (7 terms)
		// ====================================================================

		{
			code:   "term-meta-constitutional-bc-pattern"
			name:   "Padrão de BC Meta-Constitucional"
			termEn: "Meta Constitutional BC Pattern"
			definition: """
				Canonical Family Mesh extension qualitatively new beyond
				FCE (convergence integrity) + NTF (admissibility
				integrity). META-constitutional BC pattern: governs
				substrate produzindo authority em outros domínios —
				protected object NÃO é fluxo OR contrato OR
				admissibilidade OR operação mas autoridade epistemológica
				emergente que outros BCs eventualmente consomem como
				substrate de suas próprias decisões. NIM emerge como
				primeiro guardian META-constitucional canonical.
				"""
			category:  "classification"
			rationale: "Term canoniza distinct architectural layer hierarchy. Pattern precursor relevante quando: (a) meta-governance emerge canonical; (b) BCs disputam weighting authority; (c) mutation governance deixa de caber em envelope operacional único."
			antiTerms: [{
				term:          "Constitutional BC"
				clarification: "Family Mesh constitutional pattern; META-constitutional é extension qualitatively distinct (NÃO subset)."
			}, {
				term:          "Meta-governance layer"
				clarification: "Generic; perde 'BC pattern' canonical framing + Family Mesh inheritance."
			}, {
				term:          "Higher-order governance"
				clarification: "Vague hierarchy framing perde structural distinction canonical."
			}]
			rejectedAlternatives: [{
				term:   "Second-order constitutional pattern"
				reason: "Implies hierarchy mas perde 'meta' canonical + 'BC pattern' framing."
			}, {
				term:   "Governance-producing BC pattern"
				reason: "Accurate mas verbose; 'meta-constitutional' canonical é mais compact."
			}]
			examples: [{
				context:   "Family Mesh hierarchy canonical"
				instance:  "BC layers: (1) Operational BCs (NPM/REW/SSC/etc — governa decisões locais); (2) Constitutional BCs (FCE/NTF — governa integrity surfaces especific); (3) META-constitutional BCs (NIM emerging — governa mechanism integrity + epistemic substrate + authority topology cross-BC). Layer 3 é qualitatively distinct porque protected object é autoridade epistemológica emergente que outros BCs consomem downstream."
				rationale: "Pattern precursor canonical para future meta-governance emergence + cross-BC arbitration + AI-agent governance + Drex/Open Finance reputation infrastructure."
			}, {
				context:   "Forward evolution canonical"
				instance:  "Phase 1.7 forward observation #c: 'NIM may become the first Mesh BC where governance evolution itself becomes a governed domain object'. Implication canonical: future architectural evolution may need two distinct governance envelopes for NIM (operational + constitutional-mutation), OR mutation governance promoted to standalone meta-BC."
				rationale: "META-constitutional BC pattern é forward evolution surface canonical — pattern precursor establishing trajectory."
			}]
			relatedTerms: [
				"term-governance-over-governance-producing-mechanisms",
				"term-constitutional-split-review-pathway",
				"term-mechanism-mutation-governance",
			]
			layerMapping: {
				codeTerm: "MetaConstitutionalBCPattern"
				apiTerm:  "meta-constitutional-bc-pattern"
			}
		},
		{
			code:   "term-legitimacy-accumulation-risk"
			name:   "Risco de Acumulação de Legitimidade"
			termEn: "Legitimacy Accumulation Risk"
			definition: """
				Canonical pre-hegemonic drift trajectory: as mechanism
				adoption scales, repeated cross-BC consumption may
				gradually transform operational usefulness into implicit
				institutional legitimacy, creating pressure toward
				universal epistemic authority. Distinct from authority-
				delegation-drift (per-dispatch boundary violation) +
				authority-chain-reinforcement (institutional pattern
				across time) — legitimacy accumulation é trajectory
				metric over time canonical.
				"""
			category:  "classification"
			rationale: "Term canoniza forward observation Phase 1.7 #6 + incentive misalignment #7 Mechanism Legitimacy Capture (Phase 1.6 NEW). Amarra: monoculture (drift #7) + authority reinforcement (Pattern #2) + recursive governance (CC6) + constitutional split (forward candidate) + legitimacy capture (incentive #7) + invisible policy emergence. Trajectory monitoring canonical via vm-nim-legitimacy-accumulation-monitoring metric."
			antiTerms: [{
				term:          "Brand recognition"
				clarification: "Marketing framing perde drift trajectory canonical."
			}, {
				term:          "Market adoption"
				clarification: "Descriptive perde authority semantics canonical."
			}, {
				term:          "Network effect"
				clarification: "Distinct ontology (network effect é value multiplication; legitimacy accumulation é authority emergence invisible)."
			}, {
				term:          "Authority chain reinforcement"
				clarification: "Adjacent-but-distinct (chain reinforcement é institutional pattern instance; legitimacy accumulation é aggregate trajectory)."
			}]
			rejectedAlternatives: [{
				term:   "LegitimacyDrift"
				reason: "Perde 'accumulation' + 'risk' canonical trajectory framing."
			}, {
				term:   "InstitutionalLegitimacyEmergence"
				reason: "Naturalization framing CP6 violation."
			}]
			examples: [{
				context:   "Phase 1.7 forward observation canonical"
				instance:  "As mechanism adoption scales (3+ years sustained + cross-BC consumption + economic consequence) detection of legitimacy accumulation pressure via vm-nim-legitimacy-accumulation-monitoring metric. Trajectory signals: (a) cross-BC consumption patterns approaching universal-substrate-substitution threshold; (b) market discourse framing NIM outputs como 'reference standard'; (c) cross-actor framing 'se todos usam, então é neutro' canonical legitimacy capture trajectory."
				rationale: "Pre-hegemonic drift detection canonical antes de Pattern #2/#3 critical materialization."
			}]
			relatedTerms: [
				"term-mechanism-legitimacy-capture",
				"term-authority-chain-reinforcement",
				"term-epistemic-dependency-normalization",
				"term-semantic-gravity-escalation",
			]
			layerMapping: {
				codeTerm: "LegitimacyAccumulationRisk"
				apiTerm:  "legitimacy-accumulation-risk"
			}
		},
		{
			code:   "term-epistemic-dependency-normalization"
			name:   "Normalização de Dependência Epistêmica"
			termEn: "Epistemic Dependency Normalization"
			definition: """
				Canonical concept materializing Phase 1.7 founder ajuste
				#5 frase canonical: 'The primary risk is not explicit
				authoritarian control, but gradual epistemic dependency
				normalization.' Captures hegemonia epistemológica
				emergente + naturalização do score + invisibilidade do
				drift + legitimidade acumulada + recursive governance
				collapse. Distinct from authoritarian control framing —
				epistemic dependency normalization é gradual + invisible
				+ cumulative process where consumer BCs + actors
				gradually lose contextual review + bounded authority +
				provenance separation + uncertainty preservation
				capabilities.
				"""
			category:  "classification"
			rationale: "Term canoniza frase canonical Section 13 (Phase 1.7 founder ajuste #5) — provavelmente frase mais importante do BC inteiro per founder explicit framing. Captura risk vector que nenhum sistema moderno formaliza: hegemonia epistemológica emergente gradual NÃO via control assertion mas via dependency normalization. NIM defense canonical é primary architectural contribution against this drift trajectory."
			antiTerms: [{
				term:          "Authoritarian control"
				clarification: "Explicit form; canonical contrast canonical — primary risk is NÃO explicit control mas gradual normalization."
			}, {
				term:          "Authority capture"
				clarification: "Adjacent but distinct (authority capture é institutional pattern; epistemic dependency é cognitive + operational substrate erosion)."
			}, {
				term:          "Vendor lock-in"
				clarification: "IT/commercial framing perde epistemological + governance dimensions canonical."
			}]
			rejectedAlternatives: [{
				term:   "EpistemicCapture"
				reason: "Accurate mas perde 'normalization' canonical framing (key — process é gradual + naturalized)."
			}, {
				term:   "DependencyDrift"
				reason: "Generic; perde 'epistemic' canonical specific."
			}]
			examples: [{
				context:   "Section 13 canonical clause materialization"
				instance:  "Frase canonical Section 13: 'The primary risk is not explicit authoritarian control, but gradual epistemic dependency normalization.' Materializa via: (a) substrate diversity preservation (C12 anti-monoculture); (b) bounded authority canonical (C14 no-universal-score-authority + 5-tuple discipline); (c) interpretability preservation (C15 + inspectable-lineage canonical); (d) provenance preservation (C4 + 7 substrate invariants); (e) uncertainty preservation (epistemic-class canonical + asymmetric exogenous ontology); (f) consumer canonical authority preservation (Phase 1.2.B authority matrix bounded)."
				rationale: "Defense canonical é multi-layer structural — single defense insufficient against gradual normalization vector."
			}]
			relatedTerms: [
				"term-legitimacy-accumulation-risk",
				"term-mechanism-legitimacy-capture",
				"term-meta-constitutional-bc-pattern",
				"term-recursive-governance",
			]
			layerMapping: {
				codeTerm: "EpistemicDependencyNormalization"
				apiTerm:  "epistemic-dependency-normalization"
			}
		},
		{
			code:        "term-governance-over-governance-producing-mechanisms"
			name:        "Governança Sobre Mecanismos Que Produzem Governança"
			termEn:      "Governance Over Governance Producing Mechanisms"
			definition:  "Canonical phrase materializing META-constitutional pattern per Phase 1.7 founder architectural observation. NIM introduces Family Mesh pattern qualitatively new: govern mechanisms that produce governance authority em outros domínios."
			category:    "classification"
			rationale:   "Term canoniza META-constitutional framing canonical foundational observation."
			antiTerms: [{
				term:          "Meta-control"
				clarification: "Generic perde 'producing mechanisms' canonical."
			}]
			relatedTerms: ["term-meta-constitutional-bc-pattern"]
			layerMapping: {codeTerm: "GovernanceOverGovernanceProducingMechanisms", apiTerm: "governance-over-governance-producing-mechanisms"}
		},
		{
			code:        "term-mechanism-legitimacy-capture"
			name:        "Captura de Legitimidade de Mecanismo"
			termEn:      "Mechanism Legitimacy Capture"
			definition:  "Pre-hegemonic drift vector canonical (incentive misalignment #7 Phase 1.6 NEW). Distinct from gaming (#1) + delegation (#3) + policy creep (#5) — alvo é transformar adoção em legitimidade + legitimidade em soberania epistemológica. Forms canonical: 'esse score deveria ser referência oficial' / 'o mercado inteiro usa isso' / 'se todos usam, então é neutro'. Defended via C14 + Pattern #2 detection + vm-nim-legitimacy-accumulation-monitoring."
			category:    "classification"
			rationale:   "Pre-hegemonic drift vector canonical distinct from gaming/delegation/policy-creep."
			relatedTerms: ["term-legitimacy-accumulation-risk", "term-authority-chain-reinforcement", "term-watch-consensus"]
			layerMapping: {codeTerm: "MechanismLegitimacyCapture", apiTerm: "mechanism-legitimacy-capture"}
		},
		{
			code:        "term-bidirectional-epistemic-feedback-topology"
			name:        "Topologia de Feedback Epistêmico Bidirecional"
			termEn:      "Bidirectional Epistemic Feedback Topology"
			definition:  "Canonical NIM identity characteristic structural per Phase 1.5.B founder reframing. NIM é única camada com dependência bidirecional por design — consome sinais cross-BC + produz mechanism artifacts consumed cross-BC. Topology introduz 2 unique drift risks structural: reflexive governance risk + epistemic monoculture risk."
			category:    "classification"
			rationale:   "Identity characteristic canonical NIM-specific."
			antiTerms: [{
				term: "Bidirectional dependency"
				clarification: "Generic, founder rejected Phase 1.5.B framing."
			}, {
				term: "Feedback loop architecture"
				clarification: "Generic engineering framing."
			}]
			relatedTerms: ["term-recursive-governance"]
			layerMapping: {codeTerm: "BidirectionalEpistemicFeedbackTopology", apiTerm: "bidirectional-epistemic-feedback-topology"}
		},
		{
			code:        "term-constitutional-split-review-pathway"
			name:        "Pathway de Revisão Constitutional-Split"
			termEn:      "Constitutional Split Review Pathway"
			definition:  "Forward evolution candidate canonical per Phase 1.5.B founder ajuste #3. NÃO implementar agora — register como future pathway quando some NIM mutations deixam de ser 'evolução operacional' e passam a ser 'mudança constitucional da rede'. Trigger conditions: replay-sensitive + recursive-feedback + cross-BC-authority + adversarial-resistance-critical domains canonical (180-day cycle critical). Future architectural evolution may need two distinct governance envelopes for NIM (operational + constitutional-mutation), OR mutation governance promoted to standalone meta-BC."
			category:    "classification"
			rationale:   "Forward evolution candidate canonical Phase 1.5.B + Phase 1.7."
			relatedTerms: ["term-meta-constitutional-bc-pattern", "term-mechanism-mutation-governance"]
			layerMapping: {codeTerm: "ConstitutionalSplitReviewPathway", apiTerm: "constitutional-split-review-pathway"}
		},
	]

	rationale: """
		Glossário NIM — Network Intelligence & Mechanism Design.

		=========================================================================
		Section 1 — IDENTITY PRESERVATION CANONICAL
		=========================================================================

		NIM glossary é semantic containment layer for epistemic authority
		vocabulary — NÃO terminology dictionary. Cada termo canoniza
		concept cuja semantic ambiguity vira authority leakage operacional.
		Vocabulário é primary attack surface — drift começa na linguagem
		→ métrica → override → colapso ontológico (founder framing canonical
		inheritance).

		Esta é outra categoria de artifact per founder Phase 2.0:
		'A glossary where terminology itself is treated as constitutional
		infrastructure.' Preserva visibility de legitimacy accumulation
		trajectories + active semantic containment mechanism + meta-imune
		layer protegendo o próprio sistema imune.

		Risk vector central canonical preparado aqui (materializado em
		Section 10 + retomado em Section 12): epistemic dependency
		normalization — NÃO authoritarian control mas gradual + invisible
		+ cumulative process onde consumer BCs + actors gradually lose
		contextual review + bounded authority + provenance separation +
		uncertainty preservation capabilities.

		=========================================================================
		Section 2 — FAMILY MESH INHERITANCE + META-CONSTITUTIONAL EXTENSION
		=========================================================================

		FCE glossary: boundary-hardening artifact for conditional economic
		authority.
		NTF glossary: boundary-hardening artifact for communication
		guarantee admissibility.
		NIM glossary: boundary-hardening artifact for epistemic authority
		vocabulary + meta-defense against semantic gravity vectors.

		NIM extension qualitatively new: glossary é semantic governance
		infrastructure, NÃO terminology dictionary (paralelo NIM canvas
		META-constitutional framing — NIM emerge como primeiro guardian
		META-constitucional da Mesh).

		=========================================================================
		Section 3 — 6 CENTERING PRINCIPLES CP1-CP6
		=========================================================================

		CP1 — Anti-synonym collapse: apparently redundant terms são
		distinct ontological vectors. Glossary preserves canonical
		distinctions; collapse into 'mesma coisa' destroys detectability
		of authority leakage vectors downstream.

		CP2 — Anti-optimization euphemism: optimization-flavored terms
		('improvement', 'best', 'smart', 'optimal', 'efficient') carry
		covert authority semantics. Each instance flagged + replaced com
		canonical specification term OR explicit forbidden marker.

		CP3 — Anti-objectivity theater: truth-claim terms ('true',
		'objective', 'accurate', 'correct', 'fact', 'unbiased') forbidden
		em NIM mechanism output vocabulary. Mechanism outputs são
		governance-interpretable signals; objectivity framing forbidden
		por construção (C3 + Phase 1.1 anti-goal NOT-truth-engine).

		CP4 — Anti-engagement-language drift: engagement-flavored terms
		('recommended', 'relevant', 'personalized', 'preferred', 'top-
		pick', 'trending') carry behavioral gravity vector. NIM glossary
		canonical vocabulary explicit anti-engagement: 'governed-suggestion'
		NÃO 'recommendation'.

		CP5 — Anti-authority-euphemism: authority-disguising terms
		('trusted', 'approved', 'verified', 'qualified', 'endorsed',
		'official') hide authority assertion as descriptive property.
		Glossary explicit: NIM mechanism produces signals; consumers
		apply own canonical authority.

		CP6 — Anti-legitimacy-naturalization (per Phase 2.0 founder ajuste
		#1): repeated usage gradually naturalizes epistemic authority.
		Terms appearing operational may silently accumulate institutional
		legitimacy through repetition, reuse, and cross-BC propagation.
		Glossary preserves visibility of legitimacy accumulation
		trajectories. Plus extension Phase 2.0 ajuste #4: anti-benevolent-
		language camouflage — terms apparently protective/neutral/
		benevolent ('safety', 'health', 'trusted', 'fair') frequently
		hide authority expansion + optimization drift + legitimacy
		laundering + governance opacity.

		=========================================================================
		Section 4 — 6 CLUSTER STRUCTURE + ORDERING RATIONALE
		=========================================================================

		Cluster ordering A → F culminação semântica per founder Phase 2.6
		ajuste #5:

		Cluster A — Substrate canonical (7 terms): Tier 1 + Tier 1.Q +
		Tier 2 + Gate + Matrix + signal + mechanism-artifact + provenance
		+ substrate invariants. Foundation cluster — termos aqui anchor
		todos os outros clusters.

		Cluster B — Mechanism types canonical (10 terms): mechanism
		(foundational) + 6 mechanism types + mechanism-type taxonomy +
		mechanism-dimension + adversarial-resistance-class. Cluster
		onde engagement gravity + optimization euphemism + recommendation
		engine attractor concentra mais densamente — anti-pattern
		discipline maximally rigorous aqui.

		Cluster C — Authority + lineage + interpretability (7 terms):
		5-tuple authority boundary canonical + authority-surface + lineage
		+ interpretability-class. Cluster onde 5-tuple discipline é
		materializada semanticamente.

		Cluster D — Drift class + governance vocabulary (9 terms): 9
		drift classes umbrella + 5 drift class detailed + mechanism-
		mutation-governance + authority-chain-reinforcement CRITICAL+ +
		recursive-governance.

		Cluster E — Semantic Hazard Watchlist (26 terms): semantic
		containment infrastructure, NÃO catalog. Largest cluster por
		anti-euphemism discipline + Semantic Gravity Escalation umbrella +
		5 detailed FORBIDDEN canonical + 20 brief BOUNDED/FORBIDDEN
		entries.

		Cluster F — META-constitutional vocabulary (7 terms): culminação
		semântica canonical — meta-constitutional-bc-pattern + governance-
		over-governance-producing-mechanisms + bidirectional-epistemic-
		feedback-topology + legitimacy-accumulation-risk + mechanism-
		legitimacy-capture + epistemic-dependency-normalization +
		constitutional-split-review-pathway.

		=========================================================================
		Section 5 — 66 TERMS CANONICAL DENSITY RATIONALE
		=========================================================================

		Cluster sizes: A(7) + B(10) + C(7) + D(9) + E(26) + F(7) = 66
		terms total. Superior vs FCE/NTF glossary reflete semantic
		governance infrastructure framing canonical per founder Phase 2.0.

		Pattern paralelo NIM canvas 1788L vs NTF canvas 1015L ratio ~1.76x;
		glossary ratio similar reflete densidade structural NIM canonical.
		Densidade vem de:
		- 5-tuple discipline canonical textual (Cluster B + C)
		- Semantic Hazard Watchlist active containment (Cluster E)
		- Forward-canonical observations META-constitutional (Cluster F)
		- 6 anti-patterns × 6 clusters discipline matrix

		Per Phase 2.6 founder confirmation: '66 termos aceitável. Não
		aparar. Validation Dimension 5 Semantic Blast Radius Containment
		preservation requires densidade canonical structural.'

		=========================================================================
		Section 6 — 6 ANTI-PATTERNS × CLUSTER MATERIALIZATION
		=========================================================================

		CP1 anti-synonym collapse: cross-cluster discipline canonical;
		distinções preservadas (signal ≠ event ≠ data point; mechanism ≠
		algorithm ≠ model; authority-surface ≠ permission-scope;
		provenance ≠ lineage ≠ trace ≠ versioning; authority-delegation-
		drift ≠ authority-chain-reinforcement).

		CP2 anti-optimization euphemism: most concentrated Cluster E
		(intelligent + optimized + smart + best FORBIDDEN); plus Cluster
		B (anti 'smart mechanism' + 'optimized scorer'); Cluster D (anti
		'mechanism tuning' + 'model retraining').

		CP3 anti-objectivity theater: Cluster D (pseudo-objectivity-
		collapse explicit canonical anti-pattern) + Cluster E (unbiased +
		neutral + fair FORBIDDEN).

		CP4 anti-engagement-language drift: Cluster B (governed-suggestion
		canonical NÃO recommendation) + Cluster E (recommendation +
		personalized + trending + curated + selected-for-you + AI-picked
		FORBIDDEN).

		CP5 anti-authority-euphemism: cross-cluster (Cluster B + C + E)
		— trusted + verified + smart + intelligent + best + credibility
		FORBIDDEN across clusters.

		CP6 anti-legitimacy-naturalization: most concentrated Cluster F
		(legitimacy-accumulation + epistemic-dependency-normalization)
		+ Cluster E (safety + health + neutral + organic + natural-
		legitimacy FORBIDDEN); plus anti-benevolent-language camouflage
		extension Phase 2.0 ajuste #4.

		=========================================================================
		Section 7 — CLUSTER E SEMANTIC CONTAINMENT MECHANISM
		=========================================================================

		Cluster E é active containment mechanism canonical, NÃO catalog
		(per founder Phase 2.4 explicit framing). 5 enforcement layers
		canonical:

		1. Glossary enforcement: any new term proposed em other clusters
		checked against Cluster E watchlist; matches require explicit
		canonical replacement OR rejection.

		2. Communication canvas enforcement: Phase 1 communication
		entries scanned against watchlist; matches require disambiguation
		OR redrafting.

		3. Future agent-spec enforcement (Phase 4): action descriptions
		+ capability descriptions scanned; matches blocked at authoring
		time.

		4. Future domain-model enforcement (Phase 3): invariant rules +
		service descriptions + value object naming scanned; FORBIDDEN
		canonical terms rejected.

		5. Semantic Gravity Escalation review cycle (Phase 5 governance
		envelope future): periodic review of bounded watchlist terms
		para promotion to FORBIDDEN as adoption matures + legitimacy
		accumulation patterns emerge.

		BOUNDED vs FORBIDDEN distinction canonical:
		- FORBIDDEN canonical: term NÃO usar em vocabulary canonical
		  NIM, com explicit replacement
		- BOUNDED canonical: uso restricted with mandatory disambiguation
		  per dispatch

		Promotion criterion canonical per Phase 2.5 founder ajuste #6:
		'BOUNDED → FORBIDDEN quando o termo começa a aparecer como
		autoridade, decisão, verdade, legitimidade institucional ou
		substituto de consumer judgment.'

		=========================================================================
		Section 8 — SEMANTIC GRAVITY ESCALATION CONCEPT CANONICAL
		=========================================================================

		Semantic Gravity Escalation umbrella concept canonical (term-
		semantic-gravity-escalation Cluster E): semantic risk é time-
		dependent. Certain terms começam apparently neutral mas gradually
		accumulate authority semantics through repetition + cross-BC
		propagation + institutional adoption.

		Mechanism canonical:
		- Phase initial: term operational + bounded (controlled use OK)
		- Phase intermediate: term acquires institutional legitimacy
		  patterns (visibility warning)
		- Phase critical: term virou implicit authority substrate
		  (canonical FORBIDDEN trigger)

		Examples canonical trajectory:
		- 'score' começa numérico → vira authority substrate institutional
		- 'trusted' começa relational → vira legitimacy assertion
		- 'verified' começa procedural → vira authority claim
		- 'recommended' começa suggestion → vira engagement-driven
		  authority

		Defense canonical: vm-nim-legitimacy-accumulation-monitoring +
		Cluster E watchlist evolution + Phase 5 governance envelope
		review cycles. Conversa diretamente com legitimacy accumulation
		+ recursive governance + meta-constitutional emergence + epistemic
		dependency normalization.

		=========================================================================
		Section 9 — FORWARD-CANONICAL OBSERVATIONS INHERITANCE
		=========================================================================

		6 forward-canonical observations canvas Phase 1 inherited +
		materialized via Cluster F terms:

		(a) mutation-authority traffic → future authority class separation
		    → term-mechanism-mutation-governance (Cluster D)
		(b) constitutional-split-review pathway forward evolution
		    candidate → term-constitutional-split-review-pathway
		    (Cluster F)
		(c) Governance evolution as governed domain object → term-meta-
		    constitutional-bc-pattern (Cluster F)
		(d) Mutation governance + operational governance structural
		    separation candidate → term-constitutional-split-review-
		    pathway (Cluster F)
		(e) Recursive audit 3-layer separation forward-note → term-
		    recursive-governance (Cluster D) + future expansion
		(f) Legitimacy accumulation risk → term-legitimacy-accumulation-
		    risk (Cluster F) + term-mechanism-legitimacy-capture
		    (Cluster F)

		=========================================================================
		Section 10 — NÚCLEO RATIONALE: EPISTEMIC DEPENDENCY NORMALIZATION
		=========================================================================

		THESIS CENTRAL CANONICAL canvas Phase 1.7 founder ajuste #5
		materializada aqui explicit:

		'The primary risk is not explicit authoritarian control, but
		gradual epistemic dependency normalization.'

		Esta frase é a justificativa existencial do glossary inteiro.
		Glossary NIM NÃO é terminology dictionary — é defense canonical
		contra hegemonia epistemológica emergente que ocorre NÃO via
		control assertion mas via dependency normalization gradual +
		invisible + cumulative.

		NIM defense canonical é primary architectural contribution
		against this drift trajectory canonical per founder explicit
		framing. Materialização cross-glossary:

		Cluster A substrate canonical: substrate diversity preservation
		(C12 anti-monoculture) + provenance preservation (C4 + 7
		substrate invariants)

		Cluster B mechanism canonical: mechanism NÃO truth engine + NÃO
		autonomous policy optimizer + GovernedSuggestion NÃO recommendation
		(engagement gravity defense) + adversarial-resistance-class
		structural

		Cluster C authority canonical: 5-tuple discipline anti-
		genericização + bounded authority canonical (C14 no-universal-
		score-authority) + interpretability preservation (C15 + inspectable-
		lineage canonical) + consumer canonical authority preservation
		(Phase 1.2.B authority matrix bounded)

		Cluster D drift/governance canonical: mechanism-mutation-governance
		discipline + 4 FORBIDDEN canonical (mutation governance discipline
		structural) + recursive-governance discipline (CC6 + bounded
		review canonical)

		Cluster E semantic hazard canonical: anti-euphemism discipline
		structural + Semantic Gravity Escalation evolution canonical +
		BOUNDED → FORBIDDEN promotion criterion canonical (quando termo
		vira autoridade/decisão/verdade/legitimidade/substituto)

		Cluster F META-constitutional canonical: legitimacy-accumulation-
		risk trajectory monitoring + epistemic-dependency-normalization
		thesis explicit + meta-constitutional-bc-pattern + governance-
		over-governance-producing-mechanisms

		Defense canonical é multi-layer structural — single defense
		insufficient against gradual normalization vector. Glossary é
		semantic containment infrastructure cumulative + structurally
		integrated defense canonical.

		=========================================================================
		Section 11 — CROSS-CLUSTER VALIDATION OUTCOMES
		=========================================================================

		5 validation dimensions canonical (per Phase 2.7 founder ajuste
		#2 Validation Dimension 5 NEW):

		Validation Dimension 1 — relatedTerms coherence canonical:
		acyclic + bottom-up referencing canonical (Cluster A foundation
		referenced by all; cumulative reference upward sem circular
		loops detected).

		Validation Dimension 2 — Anti-synonym collapse final pass:
		critical distinctions canonical preserved cross-cluster
		(provenance ≠ lineage; mechanism-artifact ≠ output; authority-
		delegation-drift ≠ authority-chain-reinforcement; interpretability
		≠ explainability ≠ transparency).

		Validation Dimension 3 — Ontological non-circularity canonical:
		cluster ordering A → F é cumulative + non-circular per founder
		Phase 2.6 ajuste #5 culminação semântica framing.

		Validation Dimension 4 — Canonical distinction preservation
		cross-cluster: critical cross-cluster distinctions preserved
		(mechanism Cluster B ≠ mechanism-artifact Cluster A; governed-
		suggestion Cluster B ≠ watch-recommendation Cluster E FORBIDDEN;
		mechanism-mutation-governance Cluster D ≠ constitutional-split-
		review-pathway Cluster F; epistemic-dependency-normalization
		Cluster F ≠ authority-chain-reinforcement Cluster D).

		Validation Dimension 5 — Semantic Blast Radius Containment (NEW
		Phase 2.7 founder ajuste #2): mutations of local vocabulary NÃO
		alteram implicitly authority topology + consumer judgment
		boundaries + legitimacy surfaces + interpretability expectations
		+ governance semantics. Verificação canonical: cada term canonical
		replacement cross-checked contra forbidden alternatives Cluster E
		+ canonical distinction matrix cross-cluster. Result canonical:
		semantic blast radius bounded canonical preservada.

		=========================================================================
		Section 12 — PHASE 2 CLOSURE + PHASE 3 CASCADE + FRASE RETOMADA
		=========================================================================

		Phase 2.8 SRR (srr-nim-glossary) closes Phase 2 — paralelo Family
		Mesh canonical inheritance pattern (FCE WI-043 + NTF WI-063
		bootstraps).

		Phase 3 cascade canonical: NIM domain-model bootstrap inheriting
		glossary discipline canonical. Future Phase 3-5 (domain-model +
		agent-spec + governance envelope) materializam glossary canonical
		vocabulary em structural artifacts.

		Authoring history canonical: ~95+ founder ajustes integrated
		batch-by-batch across 8 sub-phases (Phase 2.0 charter + 2.1
		Cluster A + 2.2 Cluster B + 2.3 Cluster C + 2.4 Cluster D + 2.5
		Cluster E + 2.6 Cluster F + 2.7 outer rationale + cross-cluster
		validation).

		FRASE RETOMADA canonical (per Phase 2.7 founder ajuste #1 —
		Section 1 prepara risk + Section 10 materializa thesis + Section
		12 fecha retomando):

		'The primary risk is not explicit authoritarian control, but
		gradual epistemic dependency normalization.'

		NIM glossary é semantic governance infrastructure canonical —
		primary architectural contribution against this drift trajectory.
		Per founder Phase 2.7 framing: 'Essa frase não é apenas uma
		observação — ela é a justificativa existencial do glossary
		inteiro.'

		Glossary closes Phase 2; Phase 3 (domain-model) cascade canonical
		next.
		"""
}
