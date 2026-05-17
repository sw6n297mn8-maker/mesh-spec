package nim

// domain-model.cue — Domain Model NIM: Network Intelligence & Mechanism Design.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Phase 3 do WI-045 NIM bootstrap. Materializa via single-shot consolidation
// per founder direction "Faz a fase 3 toda de uma vez" (paralelo NTF Phase 2
// single-shot precedent canonical):
//
// - Phase 3.0 charter (Sections 1-6 outer rationale — Ontological Admissibility)
// - Phase 3.1.A events (33) + 3.1.B commands (18) + 3.1.C invariants (36)
// - Phase 3.2 VOs (25 — Q3-final.1 inline interpretability-class-value)
// - Phase 3.3 aggregates (11 — Q3-final.2: Tier 2 NÃO aggregate) + 2 entities
// - Phase 3.4 modules (4) + services (7) + policies (2 per Q3-final.3) +
//   projections (10) + systemConsistencyModel + decisionAuthorityModel
//
// Family Mesh META-extension explicit: NIM primeiro guardian META-constitucional
// (governance over governance-producing mechanisms); qualitatively distinto FCE
// (semantic convergence) + NTF (admissibility integrity).
//
// 3 canonical phrases preserved literal em outer rationale:
//
// 1. "Phase 1 protege topology; Phase 2 protege semantic substrate; Phase 3
//    protege ontology formation itself — quais coisas o sistema está autorizado
//    a considerar que 'existem'."
//
// 2. "Name the evidence type or bounded scope, not the authority claim."
//
// 3. "ObjectiveFunction is dangerous because it defines what the system learns
//    to want."
//
// ~50+ founder ajustes integrated literally across Phase 3.0-3.4 + 6 ajustes
// finais Q3-final.1-6 ratificados.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code: "nim"
	name: "Domain Model NIM — Network Intelligence & Mechanism Design"

	boundedContextRef: "nim"

	// =========================================================================
	// EVENTS — 33 total
	// =========================================================================

	events: [
		// === Group 1 — Mechanism Artifact Emission (6 published, Authority-bearing Critical) ===
		{
			code:        "evt-scoring-artifact-emitted"
			name:        "ScoringArtifactEmitted"
			description: "Scoring mechanism produced authority-bearing artifact for consumer BCs (REW + NPM)"
			rationale:   "C9 + Section 4.3 Cluster B; Critical per Section 5.4.1 — REW pricing + NPM qualification terminal decisions; 5-tuple binding canonical mandatory; founder canonical: MechanismArtifact ≠ DecisionArtifact"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "artifactId", type:        "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef:   "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef:               "vo-provenance"},
				{kind: "value-object-ref", name: "confidenceClass", valueObjectRef:          "vo-confidence-class"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef:    "vo-interpretability-class"},
				{kind: "domain-type", name:      "payload", type:                            "ScoringPayload"},
			]
		},
		{
			code:        "evt-matching-artifact-emitted"
			name:        "MatchingArtifactEmitted"
			description: "Matching mechanism produced authority-bearing artifact for consumer BCs (CMT + SSC)"
			rationale:   "C9 + Section 4.3 Cluster B; Critical — CMT matching + SSC shortlist terminal decisions; 5-tuple binding canonical"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "artifactId", type:        "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef:   "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef:               "vo-provenance"},
				{kind: "value-object-ref", name: "confidenceClass", valueObjectRef:          "vo-confidence-class"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef:    "vo-interpretability-class"},
				{kind: "domain-type", name:      "payload", type:                            "MatchingPayload"},
			]
		},
		{
			code:        "evt-ranking-artifact-emitted"
			name:        "RankingArtifactEmitted"
			description: "Ranking mechanism produced authority-bearing RankingOutput artifact for consumer BCs (SSC + NPM); founder canonical RankingOutput ≠ Selection"
			rationale:   "C9 + Section 4.3 Cluster B + Section 3.4 founder canonical preserved; Critical — SSC selection sovereignty preserved (Selection é SSC act, NÃO NIM claim)"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "artifactId", type:        "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef:   "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef:               "vo-provenance"},
				{kind: "value-object-ref", name: "confidenceClass", valueObjectRef:          "vo-confidence-class"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef:    "vo-interpretability-class"},
				{kind: "domain-type", name:      "payload", type:                            "RankingPayload"},
			]
		},
		{
			code:        "evt-incentive-artifact-emitted"
			name:        "IncentiveArtifactEmitted"
			description: "Incentive mechanism produced authority-bearing artifact for consumer BCs (CMT + FCE)"
			rationale:   "C9 + Section 4.3 Cluster B; Critical — CMT commitment formation + FCE payment trigger terminal decisions"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "artifactId", type:        "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef:   "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef:               "vo-provenance"},
				{kind: "value-object-ref", name: "confidenceClass", valueObjectRef:          "vo-confidence-class"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef:    "vo-interpretability-class"},
				{kind: "domain-type", name:      "payload", type:                            "IncentivePayload"},
			]
		},
		{
			code:        "evt-penalty-artifact-emitted"
			name:        "PenaltyArtifactEmitted"
			description: "Penalty mechanism produced authority-bearing artifact for consumer BCs (NPM + CMT + FCE); lifecycle post-emission é cross-BC concern per Q3.1.A.2"
			rationale:   "C9 + Section 4.3 Cluster B + Q3.1.A.2 ratificado canonical boundary preservation; Critical multi-BC cascade"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "artifactId", type:        "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef:   "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef:               "vo-provenance"},
				{kind: "value-object-ref", name: "confidenceClass", valueObjectRef:          "vo-confidence-class"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef:    "vo-interpretability-class"},
				{kind: "domain-type", name:      "payload", type:                            "PenaltyPayload"},
			]
		},
		{
			code:        "evt-governed-suggestion-emitted"
			name:        "GovernedSuggestionEmitted"
			description: "GovernedSuggestion mechanism produced authority-bearing suggestion artifact for all 6 consumer BCs (discretionary input — NEVER Recommendation per C13)"
			rationale:   "C9 + C13 + Section 3.4 founder canonical GovernedSuggestion ≠ Recommendation; CP4 anti-engagement-language enforcement canonical; Critical — affects all consumer BCs discretionary reasoning"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "artifactId", type:        "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef:   "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef:               "vo-provenance"},
				{kind: "value-object-ref", name: "confidenceClass", valueObjectRef:          "vo-confidence-class"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef:    "vo-interpretability-class"},
				{kind: "domain-type", name:      "payload", type:                            "GovernedSuggestionPayload"},
			]
		},

		// === Group 2 — Substrate Lifecycle (5) ===
		{
			code:        "evt-tier-1-signal-admitted"
			name:        "Tier1SignalAdmitted"
			description: "Raw observation signal admitted to Tier 1 substrate layer (NIM-internal substrate creation)"
			rationale:   "C1 + Cluster A; substrate creation observation; consumed por mechanism execution internal only"
			visibility:  "internal"
			fields: [
				{kind: "value-object-ref", name: "admittedSignal", valueObjectRef: "vo-signal"},
				{kind: "primitive", name:       "admissionTimestamp", type:                "datetime"},
			]
		},
		{
			code:          "evt-tier-1-q-exogenous-signal-quarantined"
			name:          "Tier1QExogenousSignalQuarantined"
			description:   "Exogenous signal from cross-BC source admitted to Tier 1.Q quarantine layer; explicit source enumeration mandatory per Q3.1.A.6"
			rationale:     "C3 + Section 4.3 Cluster A + Q3.1.A.6 ratificado: explicit source enum; founder canonical preserved: 'quarantine contém e registra, NÃO decide verdade'"
			visibility:    "internal"
			sourceContext: "ext-monitoring-systems"
			fields: [
				{kind: "value-object-ref", name: "quarantinedSignal", valueObjectRef: "vo-signal"},
				{kind: "value-object-ref", name: "exogenousSource", valueObjectRef:   "vo-exogenous-source-enum"},
				{kind: "primitive", name:       "quarantineRationale", type:                  "string"},
				{kind: "primitive", name:       "quarantineTimestamp", type:                  "datetime"},
			]
		},
		{
			code:        "evt-tier-2-mechanism-artifact-created"
			name:        "Tier2MechanismArtifactCreated"
			description: "Tier 2 substrate mechanism artifact created post-Gate admission; precondition para Group 1 published emission. Tier 2 emerge via mechanism aggregates per Q3-final.2 (NÃO substrate aggregate separado)"
			rationale:   "C1 + C2; substrate layer creation; consumed por mechanism aggregate em emission cascade"
			visibility:  "internal"
			fields: [
				{kind: "value-object-ref", name: "mechanismArtifactRef", valueObjectRef: "vo-mechanism-artifact"},
				{kind: "domain-type", name:      "gateAdmissionRef", type:                  "GateDecisionRef"},
			]
		},
		{
			code:        "evt-substrate-invariant-violation-detected"
			name:        "SubstrateInvariantViolationDetected"
			description: "Substrate-level invariant violation detected (Tier separation, quarantine breach, lineage discontinuity); published para Phase 5 governance review + cross-BC audit awareness"
			rationale:   "C5 + Section 6.4.2 systemFailureModes; published per consumer protocol Phase 5 governance + cross-BC audit"
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "violationType", type:    "string"},
				{kind: "primitive", name: "violationContext", type: "string"},
				{kind: "primitive", name: "violationTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-gate-admission-decision-recorded"
			name:        "GateAdmissionDecisionRecorded"
			description: "MechanismExecutionGate admission decision recorded para audit"
			rationale:   "C2 constitutional center; audit trail por Gate; consumed por lineage projection + Phase 5 review"
			visibility:  "internal"
			fields: [
				{kind: "domain-type", name: "gateDecisionId", type:    "GateDecisionId"},
				{kind: "primitive", name:   "admissionOutcome", type:  "string"},
				{kind: "primitive", name:   "decisionTimestamp", type: "datetime"},
			]
		},

		// === Group 3 — Authority Topology (3) ===
		{
			code:        "evt-interpretability-class-declared"
			name:        "InterpretabilityClassDeclared"
			description: "InterpretabilityClass declared para authority-bearing artifact com payload obrigatório canonical (per Q3.1.A Group 3 ajuste 'sem isso vira claim solto')"
			rationale:   "C7 + Section 4.3 Cluster C + Q3.1.A Group 3 ajuste payload obrigatório; Critical — todos 6 consumer BCs depend on class declaration"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "artifactId", type:               "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef: "vo-interpretability-class"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundaryRef", valueObjectRef: "vo-tuple-authority-boundary"},
			]
		},
		{
			code:        "evt-escape-path-exercised"
			name:        "EscapePathExercised"
			description: "Consumer BC exercised escape path overriding mechanism artifact (consumer sovereignty enacted — NIM observa, NÃO autoriza)"
			rationale:   "C8 + Section 4.3 Cluster C + Section 6.6 consumer sovereignty preservation; Observation-bearing — NIM records consumer act, NÃO claims authority"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "artifactId", type:        "string"},
				{kind: "primitive", name:       "consumerBcRef", type:     "string"},
				{kind: "primitive", name:       "exerciseRationale", type: "string"},
				{kind: "value-object-ref", name: "escapePathRef", valueObjectRef: "vo-escape-path"},
				{kind: "primitive", name:       "exerciseTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-lineage-discontinuity-detected"
			name:        "LineageDiscontinuityDetected"
			description: "LineagePropagationRules Gate detected lineage chain discontinuity"
			rationale:   "C6 + Section 4.3 Cluster C + Section 5.7 cascade analysis; High — affected artifacts marked downstream + Phase 5 review trigger"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "discontinuityContext", type: "string"},
				{kind: "value-object-ref", name: "affectedLineage", valueObjectRef: "vo-lineage"},
				{kind: "primitive", name:       "detectionTimestamp", type: "datetime"},
			]
		},

		// === Group 4 — Governance Pathway (4 per Q3.2 canonical naming) ===
		{
			code:        "evt-mutation-proposal-submitted"
			name:        "MutationProposalSubmitted"
			description: "MechanismMutationProposal submitted to governance pathway evaluation (autoridade interna não-executiva per Q4.5)"
			rationale:   "C11 + Section 4.3 Q2.6 + Q4.5 canonical 'autoriza entrada no caminho governado de avaliação'"
			visibility:  "internal"
			fields: [
				{kind: "primitive", name: "proposalId", type:          "string"},
				{kind: "domain-type", name: "targetMechanismRef", type: "MechanismRef"},
				{kind: "value-object-ref", name: "mutationType", valueObjectRef: "vo-mutation-type"},
				{kind: "primitive", name: "proposer", type:            "string"},
				{kind: "primitive", name: "submissionRationale", type: "string"},
				{kind: "primitive", name: "submissionTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-mutation-evaluation-started"
			name:        "MutationEvaluationStarted"
			description: "Governance pathway evaluation cycle started para submitted proposal (cyclical lifecycle first-class per Q6.3)"
			rationale:   "C11 + Section 6.3 governance aggregate cyclical lifecycle + Q6.3 ratificado"
			visibility:  "internal"
			fields: [
				{kind: "primitive", name: "proposalId", type:               "string"},
				{kind: "primitive", name: "evaluationCycleId", type:        "string"},
				{kind: "primitive", name: "evaluationStartTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-mechanism-mutation-approved"
			name:        "MechanismMutationApproved"
			description: "Governance pathway approved mutation; cascade conditional on activation"
			rationale:   "C11 + Q3.2 ratificado canonical naming + Q3.1.A.4 'approval IS decision event'; R-3.5.4 governance context canonical exception applies"
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "proposalId", type:         "string"},
				{kind: "primitive", name: "evaluationCycleId", type:  "string"},
				{kind: "primitive", name: "approvalRationale", type:  "string"},
				{kind: "primitive", name: "approver", type:           "string"},
				{kind: "primitive", name: "effectiveTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-mechanism-mutation-rejected"
			name:        "MechanismMutationRejected"
			description: "Governance pathway rejected mutation; NO cascade (proposal closes)"
			rationale:   "C11 + Q3.2 ratificado canonical naming + Q3.1.A.4"
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "proposalId", type:          "string"},
				{kind: "primitive", name: "evaluationCycleId", type:   "string"},
				{kind: "primitive", name: "rejectionRationale", type:  "string"},
				{kind: "primitive", name: "rejecter", type:            "string"},
				{kind: "primitive", name: "rejectionTimestamp", type:  "datetime"},
			]
		},

		// === Group 5 — ObjectiveFunction Lifecycle (3) ===
		{
			code:        "evt-objective-function-defined"
			name:        "ObjectiveFunctionDefined"
			description: "ObjectiveFunction defined for mechanism (post-governance approval per Q3.1.B.3 ratificado: sem bootstrap exemption); 5-tuple discipline bound"
			rationale:   "Q2.6 + Q5.6 + canonical phrase preservada 'ObjectiveFunction is dangerous because it defines what the system learns to want'; Critical cascade"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "objectiveFunctionId", type: "string"},
				{kind: "domain-type", name:      "bindingMechanismRef", type: "MechanismRef"},
				{kind: "value-object-ref", name: "definition", valueObjectRef: "vo-objective-function"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "primitive", name:       "definitionTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-objective-function-updated"
			name:        "ObjectiveFunctionUpdated"
			description: "ObjectiveFunction updated via mutation governance (bounded + cooldown-respected per Q5.6)"
			rationale:   "Q2.6 + Q5.6 + canonical phrase enforced; preceded por evt-mechanism-mutation-approved with mutationType=objective-function-update"
			visibility:  "published"
			fields: [
				{kind: "primitive", name:       "objectiveFunctionId", type: "string"},
				{kind: "primitive", name:       "proposalId", type:          "string"},
				{kind: "value-object-ref", name: "updatedDefinition", valueObjectRef: "vo-objective-function"},
				{kind: "primitive", name:       "cooldownVerificationTimestamp", type: "datetime"},
				{kind: "primitive", name:       "updateTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-objective-function-mutation-cooldown-violated"
			name:        "ObjectiveFunctionMutationCooldownViolated"
			description: "Mutation attempted on ObjectiveFunction before cooldown elapsed; rejected by gate (published per Q3.1.A.3 ratificado para cross-BC governance awareness)"
			rationale:   "Q5.6 inv-objective-function-mutation-cooldown Gate failure detection; High drift signal published para Phase 5"
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "objectiveFunctionId", type:        "string"},
				{kind: "primitive", name: "proposalId", type:                 "string"},
				{kind: "primitive", name: "remainingCooldownDuration", type:  "string"},
				{kind: "primitive", name: "violationTimestamp", type:         "datetime"},
			]
		},

		// === Group 6 — Drift Detection (7: 5 Cluster D + 2 META Cluster F) ===
		{
			code:        "evt-mechanism-gaming-detected"
			name:        "MechanismGamingDetected"
			description: "Drift class detected: mechanism gaming (adversarial input pattern detected)"
			rationale:   "Cluster D drift class + Section 5.5 drift detection events High; published para Phase 5 + cross-BC awareness"
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "driftClass", valueObjectRef: "vo-drift-class"},
				{kind: "domain-type", name:      "affectedMechanismRef", type: "MechanismRef"},
				{kind: "primitive", name:       "detectionContext", type:     "string"},
				{kind: "primitive", name:       "detectionTimestamp", type:   "datetime"},
			]
		},
		{
			code:        "evt-pseudo-objectivity-collapse-detected"
			name:        "PseudoObjectivityCollapseDetected"
			description: "Drift class detected: pseudo-objectivity collapse (CP3 anti-objectivity-theater violation)"
			rationale:   "Cluster D explicit canonical anti-pattern; CP3 enforcement materialized canonical"
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "driftClass", valueObjectRef: "vo-drift-class"},
				{kind: "domain-type", name:      "affectedMechanismRef", type: "MechanismRef"},
				{kind: "primitive", name:       "detectionContext", type:     "string"},
				{kind: "primitive", name:       "detectionTimestamp", type:   "datetime"},
			]
		},
		{
			code:        "evt-implicit-policy-creep-detected"
			name:        "ImplicitPolicyCreepDetected"
			description: "Drift class detected: implicit policy creep (mutations accumulating policy-like behavior outside governance)"
			rationale:   "Cluster D; High — Phase 5 review trigger"
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "driftClass", valueObjectRef: "vo-drift-class"},
				{kind: "domain-type", name:      "affectedMechanismRef", type: "MechanismRef"},
				{kind: "primitive", name:       "detectionContext", type:     "string"},
				{kind: "primitive", name:       "detectionTimestamp", type:   "datetime"},
			]
		},
		{
			code:        "evt-objective-function-drift-detected"
			name:        "ObjectiveFunctionDriftDetected"
			description: "Drift class detected: ObjectiveFunction drift (objective semantics shifting outside mutation governance)"
			rationale:   "Cluster D + Q5.6 ObjectiveFunction protection; High — critical cascade risk if undetected"
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "driftClass", valueObjectRef: "vo-drift-class"},
				{kind: "primitive", name:       "objectiveFunctionId", type: "string"},
				{kind: "primitive", name:       "detectionContext", type:    "string"},
				{kind: "primitive", name:       "detectionTimestamp", type:  "datetime"},
			]
		},
		{
			code:        "evt-authority-delegation-drift-detected"
			name:        "AuthorityDelegationDriftDetected"
			description: "Drift class detected: authority delegation drift (5-tuple consumerBCs scope erosion OR authoritySurface universalization)"
			rationale:   "Cluster D + inv-authority-surface-not-universalized Gate complement; High"
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "driftClass", valueObjectRef: "vo-drift-class"},
				{kind: "domain-type", name:      "affectedAuthorityBearingRef", type: "AuthorityBearingRef"},
				{kind: "primitive", name:       "detectionContext", type:     "string"},
				{kind: "primitive", name:       "detectionTimestamp", type:   "datetime"},
			]
		},
		{
			code:        "evt-legitimacy-accumulation-risk-warning"
			name:        "LegitimacyAccumulationRiskWarning"
			description: "Cluster F META drift signal: legitimacy accumulating beyond bounded scope (forbidden term as failure mode descriptor admissible canonical exception per Phase 3.1.C ajuste 5)"
			rationale:   "Cluster F (Phase 1.7 forward observation #6 anchor) + Q2.3 partial materialization + canonical exception preservada literal; consumed by Phase 5 governance review cycles"
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "accumulationMetric", type: "string"},
				{kind: "primitive", name: "warningContext", type:     "string"},
				{kind: "primitive", name: "warningTimestamp", type:   "datetime"},
			]
		},
		{
			code:        "evt-mechanism-legitimacy-capture-detected"
			name:        "MechanismLegitimacyCaptureDetected"
			description: "Cluster F META drift: mechanism becoming structural authority beyond intended bounded scope; CP6 anti-legitimacy-naturalization enforcement (forbidden term as failure mode descriptor admissible per canonical exception)"
			rationale:   "Cluster F (Phase 1.6 incentive misalignment #7 anchor); CP6 enforcement canonical + canonical exception preservada"
			visibility:  "published"
			fields: [
				{kind: "domain-type", name: "affectedMechanismRef", type: "MechanismRef"},
				{kind: "primitive", name:   "captureContext", type:       "string"},
				{kind: "primitive", name:   "detectionTimestamp", type:   "datetime"},
			]
		},

		// === Group 7 — Special Protection (5) ===
		{
			code:        "evt-mechanism-execution-record-created"
			name:        "MechanismExecutionRecordCreated"
			description: "Pure observation record of mechanism execution (Q2.6: 'sem virar artifact nem decision')"
			rationale:   "Q2.6 MechanismExecutionRecord Observation-bearing; consumed por governance review + audit only"
			visibility:  "internal"
			fields: [
				{kind: "primitive", name:       "executionRecordId", type: "string"},
				{kind: "domain-type", name:      "mechanismRef", type:      "MechanismRef"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "primitive", name:       "executionTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-loop-marker-emitted"
			name:        "LoopMarkerEmitted"
			description: "CC6 recursion bound tracking marker emitted"
			rationale:   "CC6 + Q2.6 LoopMarker materialization + Q2.2 inv-loop-marker-required derived"
			visibility:  "internal"
			fields: [
				{kind: "value-object-ref", name: "loopMarker", valueObjectRef: "vo-loop-marker"},
				{kind: "primitive", name:       "markerTimestamp", type:      "datetime"},
			]
		},
		{
			code:        "evt-consumer-acknowledgment-recorded"
			name:        "ConsumerAcknowledgmentRecorded"
			description: "Consumer BC acknowledgment of artifact receipt — pure record NÃO approval (per Q2.6 + Q4.4 + Q3.1.A.5 internal canonical preserving 'acknowledgment ≠ approval')"
			rationale:   "Q2.6 + Q4.4 multi-modal defense (combination d) + Q3.1.A.5 ratificado internal; classification IS safeguard per Section 4.6 SC-1"
			visibility:  "internal"
			fields: [
				{kind: "primitive", name:       "artifactId", type:      "string"},
				{kind: "primitive", name:       "consumerBcRef", type:   "string"},
				{kind: "value-object-ref", name: "acknowledgmentType", valueObjectRef: "vo-acknowledgment-type"},
				{kind: "primitive", name:       "acknowledgmentTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-authority-boundary-violation-detected"
			name:        "AuthorityBoundaryViolationDetected"
			description: "5-tuple boundary violation detected (consumerBCs scope breach OR forbiddenInterpretation claimed)"
			rationale:   "Q2.6 AuthorityBoundaryViolation; High Phase 5 review trigger; founder framing 'melhor que termos genéricos misuse/abuse'"
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "artifactId", type:       "string"},
				{kind: "primitive", name: "violatingClaim", type:   "string"},
				{kind: "primitive", name: "violationContext", type: "string"},
				{kind: "primitive", name: "detectionTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-semantic-hazard-violation-detected"
			name:        "SemanticHazardViolationDetected"
			description: "Cluster E watchlist enforcement detected building block name slipping into forbidden territory"
			rationale:   "Q2.6 SemanticHazardViolation + Section 3 R-3.5.2 + Section 5 R-5.9.1 escalation rule materialization operacional"
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "violatingName", type:        "string"},
				{kind: "primitive", name: "hazardClassification", type: "string"},
				{kind: "primitive", name: "promotionTriggered", type:   "boolean"},
				{kind: "primitive", name: "detectionTimestamp", type:   "datetime"},
			]
		},
	]

	// =========================================================================
	// COMMANDS — 18 total
	// =========================================================================

	commands: [
		// === Group A — Mechanism Execution (6, Authority-bearing Critical) ===
		{
			code:        "cmd-execute-scoring-mechanism"
			name:        "ExecuteScoringMechanism"
			description: "Trigger scoring mechanism execution; produces scoring artifact bound to 5-tuple"
			rationale:   "C9 + Section 4.3 Cluster B; Critical cascade; canonical command para invoke mechanism authority"
			fields: [
				{kind: "domain-type", name: "mechanismId", type:           "MechanismId"},
				{kind: "primitive", name:   "requestor", type:             "string"},
				{kind: "domain-type", name: "targetEntityRef", type:       "EntityRef"},
				{kind: "domain-type", name: "signalContextRef", type:      "SignalContextRef"},
				{kind: "primitive", name:   "requestId", type:             "string"},
				{kind: "value-object-ref", name: "objectiveFunctionVersionRequested", valueObjectRef: "vo-mechanism-version"},
			]
		},
		{
			code:        "cmd-execute-matching-mechanism"
			name:        "ExecuteMatchingMechanism"
			description: "Trigger matching mechanism execution"
			rationale:   "C9 + Section 4.3 Cluster B; Critical cascade canonical"
			fields: [
				{kind: "domain-type", name: "mechanismId", type:           "MechanismId"},
				{kind: "primitive", name:   "requestor", type:             "string"},
				{kind: "domain-type", name: "targetEntityRef", type:       "EntityRef"},
				{kind: "domain-type", name: "signalContextRef", type:      "SignalContextRef"},
				{kind: "primitive", name:   "requestId", type:             "string"},
				{kind: "value-object-ref", name: "objectiveFunctionVersionRequested", valueObjectRef: "vo-mechanism-version"},
			]
		},
		{
			code:        "cmd-execute-ranking-mechanism"
			name:        "ExecuteRankingMechanism"
			description: "Trigger ranking mechanism execution producing RankingOutput (NÃO Selection per founder canonical)"
			rationale:   "C9 + Section 4.3 + Section 3.4 founder canonical preserved"
			fields: [
				{kind: "domain-type", name: "mechanismId", type:           "MechanismId"},
				{kind: "primitive", name:   "requestor", type:             "string"},
				{kind: "domain-type", name: "targetEntityRef", type:       "EntityRef"},
				{kind: "domain-type", name: "signalContextRef", type:      "SignalContextRef"},
				{kind: "primitive", name:   "requestId", type:             "string"},
				{kind: "value-object-ref", name: "objectiveFunctionVersionRequested", valueObjectRef: "vo-mechanism-version"},
			]
		},
		{
			code:        "cmd-execute-incentive-mechanism"
			name:        "ExecuteIncentiveMechanism"
			description: "Trigger incentive mechanism execution producing incentive structure artifact"
			rationale:   "C9 + Section 4.3; CMT + FCE consumer"
			fields: [
				{kind: "domain-type", name: "mechanismId", type:           "MechanismId"},
				{kind: "primitive", name:   "requestor", type:             "string"},
				{kind: "domain-type", name: "targetEntityRef", type:       "EntityRef"},
				{kind: "domain-type", name: "signalContextRef", type:      "SignalContextRef"},
				{kind: "primitive", name:   "requestId", type:             "string"},
				{kind: "value-object-ref", name: "objectiveFunctionVersionRequested", valueObjectRef: "vo-mechanism-version"},
			]
		},
		{
			code:        "cmd-execute-penalty-mechanism"
			name:        "ExecutePenaltyMechanism"
			description: "Trigger penalty mechanism execution producing PenaltyArtifact only (lifecycle post-emission é cross-BC concern per Q3.1.A.2)"
			rationale:   "C9 + Section 4.3 + Q3.1.A.2 ratificado boundary canonical"
			fields: [
				{kind: "domain-type", name: "mechanismId", type:           "MechanismId"},
				{kind: "primitive", name:   "requestor", type:             "string"},
				{kind: "domain-type", name: "targetEntityRef", type:       "EntityRef"},
				{kind: "domain-type", name: "signalContextRef", type:      "SignalContextRef"},
				{kind: "primitive", name:   "requestId", type:             "string"},
				{kind: "value-object-ref", name: "objectiveFunctionVersionRequested", valueObjectRef: "vo-mechanism-version"},
			]
		},
		{
			code:        "cmd-execute-governed-suggestion"
			name:        "ExecuteGovernedSuggestion"
			description: "Trigger GovernedSuggestion mechanism execution (NÃO Recommendation per C13)"
			rationale:   "C9 + C13 + Section 3.4 founder canonical + CP4 enforcement"
			fields: [
				{kind: "domain-type", name: "mechanismId", type:           "MechanismId"},
				{kind: "primitive", name:   "requestor", type:             "string"},
				{kind: "domain-type", name: "targetEntityRef", type:       "EntityRef"},
				{kind: "domain-type", name: "signalContextRef", type:      "SignalContextRef"},
				{kind: "primitive", name:   "requestId", type:             "string"},
				{kind: "value-object-ref", name: "objectiveFunctionVersionRequested", valueObjectRef: "vo-mechanism-version"},
			]
		},

		// === Group B — Substrate Management (2) ===
		{
			code:        "cmd-admit-tier-1-signal"
			name:        "AdmitTier1Signal"
			description: "Admit raw observation signal to Tier 1 substrate (mix internal + cross-BC inbound per Q3.1.B.6, fechado Phase 3.4)"
			rationale:   "C1 + substrate ingestion command"
			fields: [
				{kind: "domain-type", name: "signalPayload", type:        "SignalPayload"},
				{kind: "primitive", name:   "observationTimestamp", type: "datetime"},
				{kind: "domain-type", name: "observationSourceRef", type: "ObservationSourceRef"},
				{kind: "value-object-ref", name: "signalSchemaVersion", valueObjectRef: "vo-mechanism-version"},
			]
		},
		{
			code:        "cmd-quarantine-exogenous-signal"
			name:        "QuarantineExogenousSignal"
			description: "Admit exogenous signal to Tier 1.Q quarantine layer (Gate command + Observation-bearing event canonical per founder ajuste 'contém e registra, NÃO decide verdade')"
			rationale:   "C3 + Section 4.3 Cluster A + Q3.1.A.6 ratificado explicit source enum mandatory + founder canonical preserved literal"
			fields: [
				{kind: "domain-type", name: "signalPayload", type:        "SignalPayload"},
				{kind: "value-object-ref", name: "exogenousSource", valueObjectRef: "vo-exogenous-source-enum"},
				{kind: "primitive", name:   "quarantineRationale", type:  "string"},
				{kind: "primitive", name:   "observationTimestamp", type: "datetime"},
			]
		},

		// === Group C — Authority Topology Declaration (2) ===
		{
			code:        "cmd-declare-interpretability-class"
			name:        "DeclareInterpretabilityClass"
			description: "Declare InterpretabilityClass para authority-bearing artifact com payload obrigatório canonical (4 mandatory fields per Q3.1.A Group 3 ajuste)"
			rationale:   "C7 + Q3.1.A Group 3 ajuste 'sem isso vira claim solto'; Critical cascade"
			fields: [
				{kind: "primitive", name:       "artifactId", type:               "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef: "vo-interpretability-class"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundaryRef", valueObjectRef: "vo-tuple-authority-boundary"},
			]
		},
		{
			code:        "cmd-record-consumer-escape"
			name:        "RecordConsumerEscape"
			description: "Record observation que consumer BC exercised escape path (initiated por consumer BC per Q3.1.B.4 ratificado, NÃO inferred by NIM)"
			rationale:   "C8 + Section 4.3 Cluster C + Section 6.6 consumer sovereignty + Q3.1.B.4 ratificado consumer-initiated canonical"
			fields: [
				{kind: "primitive", name:       "artifactId", type:        "string"},
				{kind: "primitive", name:       "consumerBcRef", type:     "string"},
				{kind: "primitive", name:       "exerciseRationale", type: "string"},
				{kind: "value-object-ref", name: "escapePathRef", valueObjectRef: "vo-escape-path"},
				{kind: "primitive", name:       "exerciseTimestamp", type: "datetime"},
			]
		},

		// === Group D — Governance Pathway (4) ===
		{
			code:        "cmd-submit-mutation-proposal"
			name:        "SubmitMutationProposal"
			description: "Submit MechanismMutationProposal para governance pathway evaluation (autoridade interna não-executiva per Q4.5)"
			rationale:   "C11 + Q4.5 canonical 'autoriza entrada no caminho governado de avaliação'"
			fields: [
				{kind: "primitive", name:       "proposalId", type:            "string"},
				{kind: "domain-type", name:      "targetMechanismRef", type:    "MechanismRef"},
				{kind: "value-object-ref", name: "mutationType", valueObjectRef: "vo-mutation-type"},
				{kind: "domain-type", name:      "proposedChanges", type:       "ProposedChanges"},
				{kind: "primitive", name:       "proposer", type:               "string"},
				{kind: "primitive", name:       "rationale", type:              "string"},
			]
		},
		{
			code:        "cmd-start-mutation-evaluation"
			name:        "StartMutationEvaluation"
			description: "Initiate governance pathway evaluation cycle (cyclical first-class per Q6.3)"
			rationale:   "C11 + Q6.3 ratificado"
			fields: [
				{kind: "primitive", name: "proposalId", type:               "string"},
				{kind: "primitive", name: "evaluationCycleId", type:        "string"},
				{kind: "primitive", name: "evaluationStartTimestamp", type: "datetime"},
			]
		},
		{
			code:        "cmd-approve-mechanism-mutation"
			name:        "ApproveMechanismMutation"
			description: "Approve mutation; cascade conditional on activation"
			rationale:   "C11 + Q3.2 ratificado canonical naming + R-3.5.4 governance context exception"
			fields: [
				{kind: "primitive", name: "proposalId", type:             "string"},
				{kind: "primitive", name: "evaluationCycleId", type:      "string"},
				{kind: "primitive", name: "approvalRationale", type:      "string"},
				{kind: "primitive", name: "approver", type:               "string"},
				{kind: "primitive", name: "effectiveTimestamp", type:     "datetime"},
				{kind: "primitive", name: "cooldownPeriodOverride", type: "string"},
			]
		},
		{
			code:        "cmd-reject-mechanism-mutation"
			name:        "RejectMechanismMutation"
			description: "Reject mutation; NO cascade"
			rationale:   "C11 + Q3.2 ratificado"
			fields: [
				{kind: "primitive", name: "proposalId", type:          "string"},
				{kind: "primitive", name: "evaluationCycleId", type:   "string"},
				{kind: "primitive", name: "rejectionRationale", type:  "string"},
				{kind: "primitive", name: "rejecter", type:            "string"},
				{kind: "primitive", name: "rejectionTimestamp", type:  "datetime"},
			]
		},

		// === Group E — ObjectiveFunction Lifecycle (2) ===
		{
			code:        "cmd-define-objective-function"
			name:        "DefineObjectiveFunction"
			description: "Define initial ObjectiveFunction para mechanism (post-governance approval per Q3.1.B.3 ratificado: sem bootstrap exemption)"
			rationale:   "Q2.6 + Q5.6 + canonical phrase 'ObjectiveFunction is dangerous because it defines what the system learns to want' + Q3.1.B.3 ratificado"
			fields: [
				{kind: "primitive", name:       "objectiveFunctionId", type:    "string"},
				{kind: "domain-type", name:      "bindingMechanismRef", type:    "MechanismRef"},
				{kind: "value-object-ref", name: "definition", valueObjectRef:    "vo-objective-function"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "weightingLineage", valueObjectRef: "vo-weighting-lineage"},
				{kind: "primitive", name:       "approvalProposalId", type:     "string"},
			]
		},
		{
			code:        "cmd-update-objective-function"
			name:        "UpdateObjectiveFunction"
			description: "Update ObjectiveFunction via mutation governance (bounded + cooldown-respected per Q5.6)"
			rationale:   "Q2.6 + Q5.6 invariants pair protection"
			fields: [
				{kind: "primitive", name:       "objectiveFunctionId", type:           "string"},
				{kind: "primitive", name:       "proposalId", type:                    "string"},
				{kind: "value-object-ref", name: "updatedDefinition", valueObjectRef:    "vo-objective-function"},
				{kind: "value-object-ref", name: "updatedTupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "updatedWeightingLineage", valueObjectRef: "vo-weighting-lineage"},
				{kind: "primitive", name:       "cooldownVerificationTimestamp", type: "datetime"},
			]
		},

		// === Group F — Special Protection (2) ===
		{
			code:        "cmd-record-consumer-acknowledgment"
			name:        "RecordConsumerAcknowledgment"
			description: "Record consumer BC acknowledgment of artifact receipt — pure record NÃO approval (per Q2.6 + Q4.4 + Q3.1.B.5 ratificados symmetry canonical: record-only command + internal-only event)"
			rationale:   "Q2.6 + Q4.4 multi-modal defense (d) + Q3.1.B.5 ratificado symmetry preserved"
			fields: [
				{kind: "primitive", name:       "artifactId", type:       "string"},
				{kind: "primitive", name:       "consumerBcRef", type:    "string"},
				{kind: "value-object-ref", name: "acknowledgmentType", valueObjectRef: "vo-acknowledgment-type"},
				{kind: "primitive", name:       "acknowledgmentTimestamp", type: "datetime"},
			]
		},
		{
			code:        "cmd-emit-loop-marker"
			name:        "EmitLoopMarker"
			description: "Emit CC6 recursion bound tracking marker"
			rationale:   "CC6 + Q2.6 LoopMarker materialization explícita"
			fields: [
				{kind: "value-object-ref", name: "loopMarker", valueObjectRef: "vo-loop-marker"},
				{kind: "primitive", name:       "markerTimestamp", type:      "datetime"},
			]
		},
	]

	// =========================================================================
	// INVARIANTS — 36 total
	// =========================================================================

	invariants: [
		// === Group A — Canvas C1-C13 + C14/C15 derived (16) ===
		{
			code: "inv-tier-substrate-separation"
			name: "TierSubstrateSeparation"
			rule: "Tier 1, Tier 1.Q, Tier 2 substrate layers separated; no cross-tier contamination admissible"
			rationale: "C1 + Section 4.3 Cluster A; substrate separation canonical é foundational"
		},
		{
			code: "inv-gate-mandatory-admission"
			name: "GateMandatoryAdmission"
			rule: "All Tier 1/1.Q → Tier 2 transitions pass via MechanismExecutionGate; bypass forbidden"
			rationale: "C2 + Section 4.3 Cluster A + Q5.5 redundant protection canonical"
		},
		{
			code: "inv-exogenous-quarantine"
			name: "ExogenousQuarantine"
			rule: "Exogenous signals isolated em Tier 1.Q quarantine; direct admission a Tier 1 forbidden"
			rationale: "C3 + canonical 'quarantine contém e registra, NÃO decide verdade'"
		},
		{
			code: "inv-five-tuple-mandatory"
			name: "FiveTupleMandatory"
			rule: "All Authority-bearing objects declare canonical 5-tuple (mechanismType + consumerBCs + authoritySurface + forbiddenInterpretations + escapePaths); creation rejected sem all 5 fields"
			rationale: "C4 + Section 5.11 per-Authority-bearing gate canonical"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "projection", projectionRef: "prj-authority-bearing-tuple-monitor"}
				rationale: "5-tuple enforcement runtime requer projection consolidating Authority-bearing aggregates 5-tuple state"
			}
		},
		{
			code: "inv-substrate-invariant-preservation"
			name: "SubstrateInvariantPreservation"
			rule: "Substrate-level invariants (Group D sub-invariants) maintained continuously; violation detection cascades emission halt"
			rationale: "C5 umbrella + Group D sub-invariants"
		},
		{
			code: "inv-provenance-non-erasure"
			name: "ProvenanceNonErasure"
			rule: "Provenance lineage cannot be erased post-emission; append-only canonical"
			rationale: "C6 Provenance non-erasure canonical"
		},
		{
			code: "inv-interpretability-class-declared"
			name: "InterpretabilityClassDeclared"
			rule: "Every authority-bearing artifact emission accompanied by InterpretabilityClass declaration com payload obrigatório (artifactId + mechanismVersion + interpretabilityClass + tupleAuthorityBoundaryRef per Q3.1.A Group 3 ajuste)"
			rationale: "C7 + Q3.1.A Group 3 ajuste canonical 'sem isso vira claim solto'"
			dependsOnAggregateState: {
				aggregateRef: "agg-scoring-mechanism"
				accessVia: {kind: "sync-query", canvasQuerySurface: "MechanismArtifactEmissionContext"}
				rationale: "Per artifact emission context query for declaration verification"
			}
		},
		{
			code: "inv-escape-path-mandatory"
			name: "EscapePathMandatory"
			rule: "Every authority-bearing artifact declares ≥1 EscapePath canonical"
			rationale: "C8 + Section 6.6 consumer sovereignty"
		},
		{
			code: "inv-mechanism-type-closed-set"
			name: "MechanismTypeClosedSet"
			rule: "Only 6 canonical MechanismTypes admissible (Scoring/Matching/Ranking/Incentive/Penalty/GovernedSuggestion); extension via mutation governance + constitutional review"
			rationale: "C9 + Q2.1 ratificado 'authority topology distinta'"
		},
		{
			code: "inv-mechanism-dimension-closed-set"
			name: "MechanismDimensionClosedSet"
			rule: "Only 8 canonical MechanismDimensions admissible (incluindo AdversarialResistanceClass); extension via mutation governance"
			rationale: "C10 mechanism dimensions canonical"
		},
		{
			code: "inv-mutation-requires-governance"
			name: "MutationRequiresGovernance"
			rule: "All Authority-bearing object mutations route via agg-mechanism-mutation-governance pathway; direct mutation forbidden"
			rationale: "C11 mutation governance canonical"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "sync-query", canvasQuerySurface: "MutationGovernanceCycleState"}
				rationale: "Mutation acceptance requires active governance cycle state"
			}
		},
		{
			code: "inv-authority-chain-preserved"
			name: "AuthorityChainPreserved"
			rule: "Authority lineage continuous across mutations; chain reinforcement via AuthorityChainReinforcement; no chain breaks admissible"
			rationale: "C12 authority chain canonical"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "projection", projectionRef: "prj-authority-chain-monitor"}
				rationale: "Chain integrity verification requer projection consolidating mechanism + governance aggregates state"
			}
		},
		{
			code: "inv-governed-suggestion-strict-discipline"
			name: "GovernedSuggestionStrictDiscipline"
			rule: "GovernedSuggestion authority bounded canonical; consumer BC retains discretionary sovereignty; engagement-gravity defense (CP4); strict distinction de canonical inverso preservada"
			rationale: "C13 + Section 3.4 founder canonical + R-3.5.1 naming evita substring hit canonical"
			dependsOnAggregateState: {
				aggregateRef: "agg-governed-suggestion"
				accessVia: {kind: "sync-query", canvasQuerySurface: "GovernedSuggestionEmissionContext"}
				rationale: "Suggestion emission requer state verification"
			}
		},
		{
			code: "inv-loop-marker-required"
			name: "LoopMarkerRequired"
			rule: "Every recursion bound across NIM aggregates emits LoopMarker (CC6); unmarked recursion forbidden"
			rationale: "C14 rationale anchor + Q2.2 derived"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-governance-mutation-control"
				accessVia: {kind: "projection", projectionRef: "prj-recursion-marker-monitor"}
				rationale: "Recursion marker enforcement requer projection over META-control + mechanism aggregates"
			}
		},
		{
			code: "inv-authority-surface-not-universalized"
			name: "AuthoritySurfaceNotUniversalized"
			rule: "AuthoritySurface scope bounded per-consumer-BC; universalization (consumerBCs = all-BCs sem rationale) forbidden"
			rationale: "C14 rationale anchor + Q2.2 derived + Q5.5 redundant protection canonical"
		},
		{
			code: "inv-recursive-consumption-bounded"
			name: "RecursiveConsumptionBounded"
			rule: "Recursive consumption pattern (NIM consuming own outputs) bounded; unbounded feedback divergence forbidden"
			rationale: "C15 rationale anchor + Q2.2 derived + CC6"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-governance-mutation-control"
				accessVia: {kind: "sync-query", canvasQuerySurface: "RecursiveConsumptionState"}
				rationale: "Recursion state verification synchronous"
			}
		},

		// === Group B — FORBIDDEN canonical mutations defense (4) ===
		{
			code: "inv-adversarial-resistance-monotone"
			name: "AdversarialResistanceMonotone"
			rule: "AdversarialResistanceClass per mechanism cannot degrade via mutation; monotonic preservation canonical (downgrade FORBIDDEN)"
			rationale: "Section 6.1.4 FORBIDDEN canonical mutations defense + Q6.4 ratificado"
		},
		{
			code: "inv-interpretability-monotone"
			name: "InterpretabilityMonotone"
			rule: "InterpretabilityClass per artifact cannot relax via mutation; monotonic preservation canonical (relaxation FORBIDDEN)"
			rationale: "Section 6.1.4 + Q6.4 ratificado"
		},
		{
			code: "inv-objective-function-bounded"
			name: "ObjectiveFunctionBounded"
			rule: "ObjectiveFunction scope bounded per declaration; unbounded scope FORBIDDEN"
			rationale: "Q5.6 + canonical phrase 'ObjectiveFunction is dangerous because it defines what the system learns to want'"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "sync-query", canvasQuerySurface: "ObjectiveFunctionDefinitionState"}
				rationale: "ObjectiveFunction state verification para boundedness check"
			}
		},
		{
			code: "inv-objective-function-mutation-cooldown"
			name: "ObjectiveFunctionMutationCooldown"
			rule: "ObjectiveFunction mutations respect cooldown period canonical; mutation attempts within cooldown FORBIDDEN"
			rationale: "Q5.6 + Section 5.4.4"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "projection", projectionRef: "prj-objective-function-mutation-history"}
				rationale: "Mutation history requer projection para cooldown verification"
			}
		},

		// === Group C — Drift detection (7) ===
		{
			code: "inv-mechanism-gaming-detected"
			name: "MechanismGamingDetected"
			rule: "Adversarial input pattern detection canonical; pattern hit → guard violation + evt-mechanism-gaming-detected emission"
			rationale: "Cluster D drift class"
		},
		{
			code: "inv-pseudo-objectivity-collapse-detected"
			name: "PseudoObjectivityCollapseDetected"
			rule: "Pseudo-objectivity drift pattern detection; CP3 anti-objectivity-theater enforcement"
			rationale: "Cluster D explicit canonical anti-pattern + CP3"
		},
		{
			code: "inv-implicit-policy-creep-detected"
			name: "ImplicitPolicyCreepDetected"
			rule: "Mutations accumulating policy-like behavior outside governance pathway detected"
			rationale: "Cluster D + C11"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "projection", projectionRef: "prj-mutation-policy-pattern-monitor"}
				rationale: "Pattern detection requer projection consolidating mutation history across mechanism aggregates"
			}
		},
		{
			code: "inv-objective-function-drift-detected"
			name: "ObjectiveFunctionDriftDetected"
			rule: "ObjectiveFunction semantic shift outside mutation governance detected"
			rationale: "Cluster D + Q5.6"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "projection", projectionRef: "prj-objective-function-mutation-history"}
				rationale: "Drift detection shares projection com cooldown enforcement"
			}
		},
		{
			code: "inv-authority-delegation-drift-detected"
			name: "AuthorityDelegationDriftDetected"
			rule: "5-tuple consumerBCs scope erosion OR authoritySurface universalization drift detected"
			rationale: "Cluster D"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "projection", projectionRef: "prj-authority-delegation-monitor"}
				rationale: "Delegation drift detection over Authority-bearing aggregates state"
			}
		},
		{
			code: "inv-mechanism-legitimacy-capture-detected"
			name: "MechanismLegitimacyCaptureDetected"
			rule: "META drift: mechanism becoming structural authority beyond bounded scope; CP6 anti-legitimacy-naturalization (Cluster F partial materialization per Q2.3; canonical exception canonical 'forbidden term as failure mode descriptor admissible')"
			rationale: "Cluster F + Q2.3 partial materialization + canonical exception preserved literal"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-governance-mutation-control"
				accessVia: {kind: "projection", projectionRef: "prj-legitimacy-accumulation-monitor"}
				rationale: "META drift detection over Authority-bearing aggregates"
			}
		},
		{
			code: "inv-legitimacy-accumulation-bounded"
			name: "LegitimacyAccumulationBounded"
			rule: "META drift bound: legitimacy accumulation within bounded threshold canonical; threshold breach triggers evt-legitimacy-accumulation-risk-warning"
			rationale: "Cluster F + Q2.3 + canonical exception per Phase 3.1.C ajuste 5"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-governance-mutation-control"
				accessVia: {kind: "projection", projectionRef: "prj-legitimacy-accumulation-monitor"}
				rationale: "Accumulation threshold verification via projection"
			}
		},

		// === Group D — Substrate sub-invariants (3) ===
		{
			code: "inv-tier-1-signal-schema-conformance"
			name: "Tier1SignalSchemaConformance"
			rule: "Tier 1 signals conform a registered signal schema; non-conformant signals rejected at admission"
			rationale: "C1 + C5 sub-rule"
		},
		{
			code: "inv-tier-1-q-source-enumerated"
			name: "Tier1QSourceEnumerated"
			rule: "Exogenous signals to Tier 1.Q only from enumerated sources canonical (per Q3.1.A.6 ratificado); unknown source rejected"
			rationale: "C3 + Q3.1.A.6 ratificado"
		},
		{
			code: "inv-tier-2-derivation-gated"
			name: "Tier2DerivationGated"
			rule: "Tier 2 mechanism artifacts only emerge via Gate admission; direct Tier 2 emission forbidden"
			rationale: "C2 + C5 + founder canonical 'contém e registra, NÃO decide verdade'"
		},

		// === Group E — Authority topology specific (2) ===
		{
			code: "inv-lineage-propagation-continuous"
			name: "LineagePropagationContinuous"
			rule: "LineagePropagationRules enforces lineage chain continuity; discontinuity rejected + emits evt-lineage-discontinuity-detected"
			rationale: "Section 4.3 Cluster C + Section 5.7 cascade"
			dependsOnAggregateState: {
				aggregateRef: "agg-lineage-observation"
				accessVia: {kind: "projection", projectionRef: "prj-lineage-continuity-monitor"}
				rationale: "Continuity verification over Authority-bearing aggregates state"
			}
		},
		{
			code: "inv-consumer-bc-authority-bounded"
			name: "ConsumerBCAuthorityBounded"
			rule: "ConsumerBCAuthority claims bounded per BC scope; universalization across BCs forbidden"
			rationale: "Section 4.3 Cluster C + Section 6.6 consumer sovereignty"
			dependsOnAggregateState: {
				aggregateRef: "agg-lineage-observation"
				accessVia: {kind: "projection", projectionRef: "prj-authority-delegation-monitor"}
				rationale: "Consumer BC scope verification shares projection com delegation drift detection"
			}
		},

		// === Group F — Special protection (3) ===
		{
			code: "inv-consumer-acknowledgment-non-approval"
			name: "ConsumerAcknowledgmentNonApproval"
			rule: "ConsumerAcknowledgment record cannot include approval-like semantic fields; cannot trigger approval-effects downstream (classification IS safeguard per Section 4.6 SC-1)"
			rationale: "Q4.4 multi-modal defense (combination d: invariant layer) + Q2.6 ConsumerAcknowledgment"
		},
		{
			code: "inv-semantic-hazard-violation-blocked"
			name: "SemanticHazardViolationBlocked"
			rule: "Cluster E watchlist + R-3.5.5 no-benevolent-rescue enforced runtime; building block name slipping into forbidden territory rejected + emits evt-semantic-hazard-violation-detected"
			rationale: "Section 3 + Q2.6 SemanticHazardViolation + Section 5 R-5.9.1"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "projection", projectionRef: "prj-naming-hazard-monitor"}
				rationale: "Runtime name verification over all aggregates state"
			}
		},
		{
			code: "inv-authority-boundary-violation-blocked"
			name: "AuthorityBoundaryViolationBlocked"
			rule: "5-tuple scope enforced at consumption time; consumerBCs scope breach OR forbiddenInterpretation claim rejected + emits evt-authority-boundary-violation-detected"
			rationale: "Q2.6 AuthorityBoundaryViolation + 5-tuple discipline runtime"
			dependsOnAggregateState: {
				aggregateRef: "agg-scoring-mechanism"
				accessVia: {kind: "sync-query", canvasQuerySurface: "AuthorityBearingScopeContext"}
				rationale: "Per artifact 5-tuple scope verification sync"
			}
		},

		// === Group G — Lifecycle constraint (1) ===
		{
			code: "inv-mutation-proposal-immutability"
			name: "MutationProposalImmutability"
			rule: "MechanismMutationProposal entities immutable post-submission; updates rejected; new proposal replaces canonical"
			rationale: "Q4.5 + Section 6.3.1 lifecycle anticipation"
			dependsOnAggregateState: {
				aggregateRef: "agg-mechanism-mutation-governance"
				accessVia: {kind: "sync-query", canvasQuerySurface: "MutationProposalState"}
				rationale: "Proposal state immutability verification"
			}
		},
	]

	// =========================================================================
	// VALUE OBJECTS — 25 total (per Q3-final.1: interpretability-class-value inline)
	// =========================================================================

	valueObjects: [
		// === Group A — Authority-bearing VOs (7) ===
		{
			code:        "vo-mechanism-artifact"
			name:        "MechanismArtifact"
			description: "Canonical output artifact emitted por mechanism aggregates; consumed por todos 6 consumer BCs como substrate de reasoning"
			fields: [
				{kind: "primitive", name:       "artifactId", type:      "string"},
				{kind: "domain-type", name:      "mechanismId", type:     "MechanismId"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef: "vo-provenance"},
				{kind: "value-object-ref", name: "confidenceClass", valueObjectRef: "vo-confidence-class"},
				{kind: "value-object-ref", name: "interpretabilityClass", valueObjectRef: "vo-interpretability-class"},
				{kind: "domain-type", name:      "payload", type:         "MechanismArtifactPayload"},
			]
			constraints: [
				"All 9 fields mandatory at emission canonical",
				"Immutable post-creation",
				"artifactId + mechanismVersion + objectiveFunctionVersion per Q6.5 snapshot-aware",
			]
			rationale: "C9 + Section 4.3 + 5.4.2 Critical canonical; 5-tuple binding mandatory; founder canonical MechanismArtifact ≠ DecisionArtifact preserved literal"
		},
		{
			code:        "vo-tuple-authority-boundary"
			name:        "TupleAuthorityBoundary"
			description: "5-tuple authority discipline structural VO; recursive canonical per Q4.2 META-constitutional 'ponto meta-constitucional em forma estrutural'"
			fields: [
				{kind: "value-object-ref", name: "mechanismType", valueObjectRef: "vo-mechanism-type"},
				{kind: "primitive", name:       "consumerBCs", type:                          "string"},
				{kind: "value-object-ref", name: "authoritySurface", valueObjectRef:          "vo-authority-surface"},
				{kind: "primitive", name:       "forbiddenInterpretations", type:             "string"},
				{kind: "value-object-ref", name: "escapePathRef", valueObjectRef:             "vo-escape-path"},
			]
			constraints: [
				"All 5 fields mandatory canonical",
				"forbiddenInterpretations ≥1 explicit",
				"escapePaths ≥1 per C8 mandatory",
				"Recursive canonical per Q4.2",
			]
			rationale: "C4 + Section 4.3 Cluster C + Section 4.6 SC-4 + Q4.2 ratificado"
		},
		{
			code:        "vo-interpretability-class"
			name:        "InterpretabilityClass"
			description: "4-class lattice declarando consumer BC reasoning rights per authority-bearing artifact (classValue inline per Q3-final.1)"
			fields: [
				{kind: "primitive", name: "classValue", type:               "string"},
				{kind: "primitive", name: "classRationale", type:           "string"},
				{kind: "primitive", name: "consumerReasoningRights", type:  "string"},
			]
			constraints: [
				"classValue ∈ {directly-interpretable, feature-interpretable, comparison-interpretable, outcome-only-interpretable}",
				"Monotone preservation per inv-interpretability-monotone (no relaxation across mutations)",
			]
			rationale: "C7 + Section 4.3 Cluster C + Q6.4 monotone discipline + Q3-final.1 inline canonical"
		},
		{
			code:        "vo-authority-surface"
			name:        "AuthoritySurface"
			description: "Explicit consumer-facing authority contract surface; bounded canonical (NÃO universal authority)"
			fields: [
				{kind: "primitive", name: "surfaceScope", type:             "string"},
				{kind: "primitive", name: "surfaceLimits", type:            "string"},
				{kind: "primitive", name: "consumerBcSpecificScope", type:  "string"},
			]
			constraints: [
				"surfaceScope non-empty",
				"surfaceLimits ≥1 (bounded discipline)",
				"Universalization forbidden per inv-authority-surface-not-universalized",
			]
			rationale: "C4 + Section 4.3 Cluster C + Q5.5 redundant protection"
		},
		{
			code:        "vo-consumer-bc-authority"
			name:        "ConsumerBCAuthority"
			description: "NIM claim about consumer BC sovereign reasoning rights — bounded per BC scope; preserves consumer sovereignty per Section 6.6"
			fields: [
				{kind: "primitive", name:       "consumerBcRef", type:                       "string"},
				{kind: "primitive", name:       "sovereignReasoningRights", type:            "string"},
				{kind: "primitive", name:       "mechanismOutputConsumptionBounds", type:    "string"},
				{kind: "value-object-ref", name: "escapePathReferences", valueObjectRef:      "vo-escape-path"},
			]
			constraints: [
				"consumerBcRef ∈ {REW, NPM, CMT, SSC, FCE, NTF}",
				"sovereignReasoningRights ≥1",
				"mechanismOutputConsumptionBounds ≥1",
			]
			rationale: "Section 4.3 Cluster C + Section 6.6 decision precedence canonical"
		},
		{
			code:        "vo-escape-path"
			name:        "EscapePath"
			description: "Mandatory consumer override mechanism declarando explicit pathway por which consumer BC overrides authority-bearing artifact"
			fields: [
				{kind: "primitive", name: "pathType", type:           "string"},
				{kind: "primitive", name: "triggerConditions", type:  "string"},
				{kind: "primitive", name: "overrideEffect", type:     "string"},
			]
			constraints: [
				"pathType ∈ {consumer-override, rationale-required-override, escalation-to-phase-5, manual-review-by-bc-decision-maker}",
				"triggerConditions ≥1 explicit",
			]
			rationale: "C8 + Section 4.3 + Section 6.6 consumer sovereignty"
		},
		{
			code:        "vo-objective-function"
			name:        "ObjectiveFunction"
			description: "Defines what mechanism optimizes — canonical phrase preservada literal 'ObjectiveFunction is dangerous because it defines what the system learns to want'; bounded + mutation-governed per Q5.6"
			fields: [
				{kind: "primitive", name:       "objectiveFunctionId", type:    "string"},
				{kind: "domain-type", name:      "bindingMechanismRef", type:    "MechanismRef"},
				{kind: "primitive", name:       "definition", type:             "string"},
				{kind: "primitive", name:       "boundedScope", type:           "string"},
				{kind: "value-object-ref", name: "weightingLineage", valueObjectRef: "vo-weighting-lineage"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "primitive", name:       "forbiddenInterpretations", type: "string"},
				{kind: "primitive", name:       "cooldownPeriod", type:         "string"},
			]
			constraints: [
				"All 8 fields mandatory canonical",
				"boundedScope ≥1 (unbounded forbidden per inv-objective-function-bounded)",
				"forbiddenInterpretations ≥1",
				"cooldownPeriod parameterized per instance per Q3.2.6 (default ≥30 days)",
			]
			rationale: "Q2.6 + Q5.6 invariants pair + canonical phrase preservada literal + Section 4.6 SC-2"
		},

		// === Group B — Observation-bearing VOs (10) ===
		{
			code:        "vo-signal"
			name:        "Signal"
			description: "Atomic observation unit; founder canonical Signal ≠ Verdict preserved"
			fields: [
				{kind: "primitive", name:       "signalId", type:               "string"},
				{kind: "domain-type", name:      "signalPayload", type:           "SignalPayload"},
				{kind: "value-object-ref", name: "signalSchemaVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "primitive", name:       "observationTimestamp", type:    "datetime"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef:    "vo-provenance"},
			]
			constraints: ["Signal NÃO Verdict (founder canonical)", "Immutable post-admission"]
			rationale: "C1 + Cluster A + founder canonical inverse preserved literal"
		},
		{
			code:        "vo-provenance"
			name:        "Provenance"
			description: "Lineage record per artifact/signal; non-erasure canonical per C6"
			fields: [
				{kind: "primitive", name:  "provenanceId", type:         "string"},
				{kind: "domain-type", name: "originRef", type:            "OriginRef"},
				{kind: "primitive", name:  "provenanceChain", type:      "string"},
				{kind: "primitive", name:  "creationTimestamp", type:    "datetime"},
				{kind: "primitive", name:  "signatureBlob", type:        "string"},
			]
			constraints: ["Append-only canonical", "Immutable post-creation"]
			rationale: "C6 + Cluster A + inv-provenance-non-erasure Gate"
		},
		{
			code:        "vo-lineage"
			name:        "Lineage"
			description: "Generic lineage trace cradle-to-consumer canonical"
			fields: [
				{kind: "primitive", name:  "lineageId", type:    "string"},
				{kind: "primitive", name:  "chainNodes", type:   "string"},
				{kind: "domain-type", name: "currentHolder", type: "ConsumerBcRef"},
			]
			constraints: ["Continuous chain canonical per inv-lineage-propagation-continuous", "Discontinuity rejected"]
			rationale: "Section 4.3 Cluster C; LineagePropagationRules Gate consumer"
		},
		{
			code:        "vo-weighting-lineage"
			name:        "WeightingLineage"
			description: "Specific lineage subtype para weighting/scoring inputs — critical para objective-function-drift detection (Q2.6 founder rationale)"
			fields: [
				{kind: "primitive", name:  "weightingLineageId", type:     "string"},
				{kind: "primitive", name:  "weightingChain", type:         "string"},
				{kind: "value-object-ref", name: "objectiveFunctionRef", valueObjectRef: "vo-objective-function"},
				{kind: "primitive", name:  "weightingDriftIndicator", type: "decimal"},
			]
			constraints: ["Specialization of Lineage", "Tracks weighting evolution canonical"]
			rationale: "Q2.6 canonical + founder framing preserved 'mais específico que Lineage; crítico para objective-function drift'"
		},
		{
			code:        "vo-mechanism-version"
			name:        "MechanismVersion"
			description: "Version marker per mechanism/ObjectiveFunction para lineage + mutation governance"
			fields: [
				{kind: "primitive", name:  "versionId", type:           "string"},
				{kind: "primitive", name:  "versionTimestamp", type:    "datetime"},
				{kind: "primitive", name:  "mutationProposalRef", type: "string"},
			]
			constraints: ["Monotonic increment canonical", "Immutable per version"]
			rationale: "Q2.6 canonical version marker"
		},
		{
			code:        "vo-loop-marker"
			name:        "LoopMarker"
			description: "CC6 recursion bound tracking marker — observation of bounded recursion per inv-loop-marker-required"
			fields: [
				{kind: "primitive", name:  "markerId", type:           "string"},
				{kind: "domain-type", name: "recursionContextRef", type: "RecursionContextRef"},
				{kind: "primitive", name:  "recursionDepth", type:     "integer"},
				{kind: "domain-type", name: "boundedScopeRef", type:    "BoundedScopeRef"},
			]
			constraints: ["recursionDepth bounded per inv-recursive-consumption-bounded"]
			rationale: "CC6 + Q2.6 LoopMarker materialization + Q2.2 inv-loop-marker-required derived"
		},
		{
			code:        "vo-confidence-class"
			name:        "ConfidenceClass"
			description: "Bounded uncertainty class — founder canonical ConfidenceClass ≠ TruthClaim preserved literal"
			fields: [
				{kind: "primitive", name: "classValue", type:     "string"},
				{kind: "primitive", name: "varianceMeasure", type: "decimal"},
				{kind: "primitive", name: "classRationale", type: "string"},
			]
			constraints: [
				"classValue ∈ {high-confidence-bounded, medium-confidence-bounded, low-confidence-bounded, insufficient-evidence}",
				"NÃO TruthClaim (founder canonical preserved)",
				"varianceMeasure bounded (NÃO accuracy claim)",
			]
			rationale: "Section 3.4 founder canonical inverse pair + Cluster B sub-classification"
		},
		{
			code:        "vo-mechanism-dimension"
			name:        "MechanismDimension"
			description: "8 canonical dimensions structural enum"
			fields: [
				{kind: "primitive", name: "dimensionValue", type:      "string"},
				{kind: "primitive", name: "dimensionDescription", type: "string"},
			]
			constraints: ["Closed set per inv-mechanism-dimension-closed-set"]
			rationale: "C10 + Section 4.3 Cluster B"
		},
		{
			code:        "vo-adversarial-resistance-class"
			name:        "AdversarialResistanceClass"
			description: "8th dimension NEW per Phase 2 sub-phase emergence; adversarial-resistance classification + monotone canonical per Q6.4"
			fields: [
				{kind: "primitive", name: "resistanceClassValue", type:       "string"},
				{kind: "primitive", name: "resistanceTestRationale", type:    "string"},
				{kind: "primitive", name: "resistanceMonotoneBaseline", type: "string"},
			]
			constraints: [
				"resistanceClassValue ∈ {high-resistance, moderate-resistance, baseline-resistance, no-claimed-resistance}",
				"Monotone preservation canonical per Q6.4 inv-adversarial-resistance-monotone",
			]
			rationale: "Q1.5 emergence + Section 4.3 Cluster B + Q6.4"
		},
		{
			code:        "vo-drift-class"
			name:        "DriftClass"
			description: "9 canonical drift classes em 3 families enum"
			fields: [
				{kind: "primitive", name: "familyValue", type:       "string"},
				{kind: "primitive", name: "driftValue", type:        "string"},
				{kind: "primitive", name: "driftDescription", type:  "string"},
			]
			constraints: [
				"familyValue ∈ {constitutional, recursive-system, optimization-gravity}",
				"driftValue ∈ 9 drift classes canonical",
			]
			rationale: "Section 4.3 Cluster D"
		},

		// === Group C — Substrate VOs (4) ===
		{
			code:        "vo-tier-1-signal-substrate"
			name:        "Tier1SignalSubstrate"
			description: "Substrate type marker para Tier 1 signal layer"
			fields: [
				{kind: "primitive", name:       "substrateLayer", type:       "string"},
				{kind: "value-object-ref", name: "admittedSignal", valueObjectRef: "vo-signal"},
				{kind: "primitive", name:       "admissionTimestamp", type:   "datetime"},
			]
			constraints: ["substrateLayer fixed: 'tier-1'"]
			rationale: "C1 + Cluster A; foundational layer marker"
		},
		{
			code:        "vo-tier-1-q-exogenous-signal-quarantine"
			name:        "Tier1QExogenousSignalQuarantine"
			description: "Substrate type marker para Tier 1.Q quarantine layer; exogenous source isolated"
			fields: [
				{kind: "primitive", name:       "substrateLayer", type:          "string"},
				{kind: "value-object-ref", name: "quarantinedSignal", valueObjectRef: "vo-signal"},
				{kind: "value-object-ref", name: "exogenousSource", valueObjectRef: "vo-exogenous-source-enum"},
				{kind: "primitive", name:       "quarantineTimestamp", type:      "datetime"},
				{kind: "primitive", name:       "quarantineRationale", type:      "string"},
			]
			constraints: ["substrateLayer fixed: 'tier-1-q'", "exogenousSource ∈ canvas-derived enum (per Q3.1.A.6)"]
			rationale: "C3 + Cluster A + Phase 1.5 emergence + Q3.1.A.6 ratificado"
		},
		{
			code:        "vo-tier-2-mechanism-artifact-substrate"
			name:        "Tier2MechanismArtifactSubstrate"
			description: "Substrate type marker para Tier 2 mechanism artifact layer; post-Gate canonical (Tier 2 emerge via mechanism aggregates per Q3-final.2)"
			fields: [
				{kind: "primitive", name:       "substrateLayer", type:           "string"},
				{kind: "value-object-ref", name: "mechanismArtifactRef", valueObjectRef: "vo-mechanism-artifact"},
				{kind: "domain-type", name:      "gateAdmissionRef", type:         "GateDecisionRef"},
			]
			constraints: ["substrateLayer fixed: 'tier-2'"]
			rationale: "C2 + Cluster A; precondition para Authority-bearing artifact emission"
		},
		{
			code:        "vo-mechanism-integrity-matrix"
			name:        "MechanismIntegrityMatrix"
			description: "Normative substrate consumed by Gate, NÃO projection (founder ajuste canonical preservada literal 'evita drift para read model')"
			fields: [
				{kind: "primitive", name:       "matrixId", type:               "string"},
				{kind: "value-object-ref", name: "mechanismType", valueObjectRef: "vo-mechanism-type"},
				{kind: "value-object-ref", name: "dimensions", valueObjectRef:   "vo-mechanism-dimension"},
				{kind: "value-object-ref", name: "resistanceClass", valueObjectRef: "vo-adversarial-resistance-class"},
				{kind: "primitive", name:       "normativeReference", type:     "string"},
			]
			constraints: [
				"Normative substrate canonical",
				"Immutable per version",
				"Gate-consumption only",
			]
			rationale: "Section 4.3 Cluster A + founder ajuste canonical 'normative substrate consumed by Gate, NÃO projection' preservada literal"
		},

		// === Group D — Enum/discriminator VOs (4) ===
		{
			code:        "vo-mechanism-type"
			name:        "MechanismType"
			description: "6 canonical mechanism types closed set per Q2.1 'authority topology distinta'"
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			constraints: [
				"value ∈ {scoring, matching, ranking, incentive, penalty, governed-suggestion}",
				"Closed set per inv-mechanism-type-closed-set",
			]
			rationale: "C9 + Q2.1 ratificado canonical"
		},
		{
			code:        "vo-mutation-type"
			name:        "MutationType"
			description: "Mutation proposal type discriminator"
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			constraints: [
				"value ∈ {config-update, deprecate, retire, objective-function-update, objective-function-creation, bind-tuple}",
			]
			rationale: "C11 + Q3.2 governance pathway types"
		},
		{
			code:        "vo-exogenous-source-enum"
			name:        "ExogenousSourceEnum"
			description: "Canvas-derived exogenous source enum per Q3.1.A.6 (closure Phase 3.4 — anticipated values via canvas.communication.inbound exogenous declarations)"
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			constraints: [
				"Closed enum derived from canvas.communication.inbound (Phase 3.4)",
			]
			rationale: "Q3.1.A.6 ratificado canonical; closure Phase 3.4"
		},
		{
			code:        "vo-acknowledgment-type"
			name:        "AcknowledgmentType"
			description: "Consumer acknowledgment type discriminator (receipt-only canonical per Q2.6 + Q4.4)"
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			constraints: [
				"value ∈ {received, consumed, exercised-escape}",
				"Receipt-only canonical (NÃO approval — classification IS safeguard per Section 4.6 SC-1)",
			]
			rationale: "Q2.6 ConsumerAcknowledgment + Q4.4 multi-modal defense canonical"
		},
	]

	// =========================================================================
	// AGGREGATES — 11 + 2 entities
	// =========================================================================

	aggregates: [
		// === Mechanism Aggregates (6, Authority-bearing Critical) ===
		{
			code:        "agg-scoring-mechanism"
			name:        "ScoringMechanism"
			description: "Authority-bearing scoring mechanism aggregate; produces scoring artifacts para REW + NPM consumer BCs"
			rootIdentity: {
				field: "mechanismId"
				type: {kind: "domain-type", type: "MechanismId"}
			}
			fields: [
				{kind: "primitive", name:       "status", type:               "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionRef", valueObjectRef: "vo-objective-function"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "primitive", name:       "createdAt", type:            "datetime"},
				{kind: "primitive", name:       "updatedAt", type:            "datetime"},
			]
			handlesCommands: ["cmd-execute-scoring-mechanism"]
			emitsEvents: [
				"evt-scoring-artifact-emitted",
				"evt-tier-2-mechanism-artifact-created",
				"evt-mechanism-execution-record-created",
				"evt-gate-admission-decision-recorded",
				"evt-interpretability-class-declared",
				"evt-substrate-invariant-violation-detected",
				"evt-objective-function-mutation-cooldown-violated",
				"evt-semantic-hazard-violation-detected",
				"evt-authority-boundary-violation-detected",
			]
			protectsInvariants: [
				"inv-five-tuple-mandatory",
				"inv-interpretability-class-declared",
				"inv-escape-path-mandatory",
				"inv-mechanism-type-closed-set",
				"inv-mechanism-dimension-closed-set",
				"inv-adversarial-resistance-monotone",
				"inv-interpretability-monotone",
				"inv-mechanism-gaming-detected",
				"inv-pseudo-objectivity-collapse-detected",
				"inv-authority-chain-preserved",
				"inv-provenance-non-erasure",
				"inv-authority-boundary-violation-blocked",
			]
			entities: [{
				code:        "ent-scoring-execution-record"
				name:        "ScoringExecutionRecord"
				description: "Per-execution observation record (Q2.6 MechanismExecutionRecord; entity with identity para audit)"
				identity: {
					field: "executionRecordId"
					type: {kind: "domain-type", type: "ExecutionRecordId"}
				}
				fields: [
					{kind: "primitive", name:  "executionTimestamp", type: "datetime"},
					{kind: "domain-type", name: "signalContextRef", type:   "SignalContextRef"},
					{kind: "domain-type", name: "gateDecisionRef", type:    "GateDecisionRef"},
					{kind: "primitive", name:  "executionOutcome", type:   "string"},
				]
				usesValueObjects: ["vo-signal", "vo-provenance", "vo-mechanism-version"]
				rationale: "Q2.6 entity Observation-bearing canonical 'sem virar artifact nem decision'"
			}]
			usesValueObjects: [
				"vo-mechanism-artifact", "vo-tuple-authority-boundary", "vo-interpretability-class",
				"vo-authority-surface", "vo-consumer-bc-authority", "vo-escape-path", "vo-objective-function",
				"vo-signal", "vo-provenance", "vo-confidence-class", "vo-mechanism-version",
				"vo-mechanism-dimension", "vo-adversarial-resistance-class", "vo-mechanism-type",
				"vo-tier-2-mechanism-artifact-substrate", "vo-weighting-lineage", "vo-lineage",
			]
			lifecycle: {
				initialState: "defined"
				states: ["defined", "active"]
				transitions: [{
					from: "defined"
					to: "active"
					triggeredByCommand: "cmd-execute-scoring-mechanism"
					emitsEvents: ["evt-scoring-artifact-emitted"]
					guards: ["inv-five-tuple-mandatory", "inv-mechanism-type-closed-set"]
					description: "Lazy activation via first execution"
				}]
			}
			consistencyBoundary: {
				guarantees: [
					"Atomic 5-tuple binding at emission",
					"Atomic interpretability class declaration with artifact",
					"Atomic provenance record creation",
				]
				explicitlyDoesNotGuarantee: [
					"Synchronous consumer BC notification",
					"Cross-aggregate state consistency at emission instant",
					"Immediate cascade to consumer BCs",
				]
				failureModes: [
					"Gate admission failure (Tier 1 substrate violation)",
					"ObjectiveFunction cooldown violation",
					"Semantic hazard detection",
					"5-tuple incompleteness rejection",
				]
				rationale: "Authority-bearing aggregate canonical: atomic intra-aggregate + eventual cross-aggregate per Section 6.5"
			}
			rationale: "Critical Authority-bearing per Section 5.4.1; serves REW + NPM consumer BCs; 5-tuple binding mandatory canonical"
		},
		{
			code:        "agg-matching-mechanism"
			name:        "MatchingMechanism"
			description: "Authority-bearing matching mechanism aggregate; produces matching artifacts para CMT + SSC"
			rootIdentity: {
				field: "mechanismId"
				type: {kind: "domain-type", type: "MechanismId"}
			}
			fields: [
				{kind: "primitive", name:       "status", type:               "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionRef", valueObjectRef: "vo-objective-function"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "primitive", name:       "createdAt", type:            "datetime"},
				{kind: "primitive", name:       "updatedAt", type:            "datetime"},
			]
			handlesCommands: ["cmd-execute-matching-mechanism"]
			emitsEvents: [
				"evt-matching-artifact-emitted",
				"evt-tier-2-mechanism-artifact-created",
				"evt-mechanism-execution-record-created",
				"evt-gate-admission-decision-recorded",
				"evt-interpretability-class-declared",
				"evt-substrate-invariant-violation-detected",
				"evt-semantic-hazard-violation-detected",
				"evt-authority-boundary-violation-detected",
			]
			protectsInvariants: [
				"inv-five-tuple-mandatory", "inv-interpretability-class-declared", "inv-escape-path-mandatory",
				"inv-mechanism-type-closed-set", "inv-mechanism-dimension-closed-set",
				"inv-adversarial-resistance-monotone", "inv-interpretability-monotone",
				"inv-mechanism-gaming-detected", "inv-authority-chain-preserved",
				"inv-provenance-non-erasure", "inv-authority-boundary-violation-blocked",
			]
			usesValueObjects: [
				"vo-mechanism-artifact", "vo-tuple-authority-boundary", "vo-interpretability-class",
				"vo-authority-surface", "vo-escape-path", "vo-signal", "vo-provenance",
				"vo-confidence-class", "vo-mechanism-version", "vo-mechanism-type",
				"vo-tier-2-mechanism-artifact-substrate", "vo-lineage",
			]
			lifecycle: {
				initialState: "defined"
				states: ["defined", "active"]
				transitions: [{
					from: "defined"
					to: "active"
					triggeredByCommand: "cmd-execute-matching-mechanism"
					emitsEvents: ["evt-matching-artifact-emitted"]
					guards: ["inv-five-tuple-mandatory"]
					description: "Lazy activation via first execution"
				}]
			}
			rationale: "Critical Authority-bearing per Section 5.4.1; serves CMT + SSC consumer BCs"
		},
		{
			code:        "agg-ranking-mechanism"
			name:        "RankingMechanism"
			description: "Authority-bearing ranking mechanism aggregate; produces RankingOutput (NÃO Selection per founder canonical) para SSC + NPM"
			rootIdentity: {
				field: "mechanismId"
				type: {kind: "domain-type", type: "MechanismId"}
			}
			fields: [
				{kind: "primitive", name:       "status", type:               "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionRef", valueObjectRef: "vo-objective-function"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "primitive", name:       "createdAt", type:            "datetime"},
				{kind: "primitive", name:       "updatedAt", type:            "datetime"},
			]
			handlesCommands: ["cmd-execute-ranking-mechanism"]
			emitsEvents: [
				"evt-ranking-artifact-emitted",
				"evt-tier-2-mechanism-artifact-created",
				"evt-mechanism-execution-record-created",
				"evt-gate-admission-decision-recorded",
				"evt-interpretability-class-declared",
				"evt-substrate-invariant-violation-detected",
				"evt-semantic-hazard-violation-detected",
				"evt-authority-boundary-violation-detected",
			]
			protectsInvariants: [
				"inv-five-tuple-mandatory", "inv-interpretability-class-declared", "inv-escape-path-mandatory",
				"inv-mechanism-type-closed-set", "inv-mechanism-dimension-closed-set",
				"inv-adversarial-resistance-monotone", "inv-interpretability-monotone",
				"inv-mechanism-gaming-detected", "inv-authority-chain-preserved",
				"inv-provenance-non-erasure", "inv-authority-boundary-violation-blocked",
			]
			usesValueObjects: [
				"vo-mechanism-artifact", "vo-tuple-authority-boundary", "vo-interpretability-class",
				"vo-authority-surface", "vo-escape-path", "vo-signal", "vo-provenance",
				"vo-confidence-class", "vo-mechanism-version", "vo-mechanism-type",
				"vo-tier-2-mechanism-artifact-substrate", "vo-lineage",
			]
			lifecycle: {
				initialState: "defined"
				states: ["defined", "active"]
				transitions: [{
					from: "defined"
					to: "active"
					triggeredByCommand: "cmd-execute-ranking-mechanism"
					emitsEvents: ["evt-ranking-artifact-emitted"]
					guards: ["inv-five-tuple-mandatory"]
					description: "Lazy activation via first execution"
				}]
			}
			rationale: "Critical Authority-bearing per Section 5.4.1; serves SSC + NPM consumer BCs; founder canonical RankingOutput ≠ Selection preserved (Selection é SSC sovereignty)"
		},
		{
			code:        "agg-incentive-mechanism"
			name:        "IncentiveMechanism"
			description: "Authority-bearing incentive mechanism aggregate; produces incentive structures para CMT + FCE"
			rootIdentity: {
				field: "mechanismId"
				type: {kind: "domain-type", type: "MechanismId"}
			}
			fields: [
				{kind: "primitive", name:       "status", type:               "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionRef", valueObjectRef: "vo-objective-function"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "primitive", name:       "createdAt", type:            "datetime"},
				{kind: "primitive", name:       "updatedAt", type:            "datetime"},
			]
			handlesCommands: ["cmd-execute-incentive-mechanism"]
			emitsEvents: [
				"evt-incentive-artifact-emitted",
				"evt-tier-2-mechanism-artifact-created",
				"evt-mechanism-execution-record-created",
				"evt-gate-admission-decision-recorded",
				"evt-interpretability-class-declared",
				"evt-substrate-invariant-violation-detected",
				"evt-semantic-hazard-violation-detected",
				"evt-authority-boundary-violation-detected",
			]
			protectsInvariants: [
				"inv-five-tuple-mandatory", "inv-interpretability-class-declared", "inv-escape-path-mandatory",
				"inv-mechanism-type-closed-set", "inv-mechanism-dimension-closed-set",
				"inv-adversarial-resistance-monotone", "inv-interpretability-monotone",
				"inv-mechanism-gaming-detected", "inv-authority-chain-preserved",
				"inv-provenance-non-erasure", "inv-authority-boundary-violation-blocked",
			]
			usesValueObjects: [
				"vo-mechanism-artifact", "vo-tuple-authority-boundary", "vo-interpretability-class",
				"vo-authority-surface", "vo-escape-path", "vo-signal", "vo-provenance",
				"vo-confidence-class", "vo-mechanism-version", "vo-mechanism-type",
				"vo-tier-2-mechanism-artifact-substrate", "vo-lineage",
			]
			lifecycle: {
				initialState: "defined"
				states: ["defined", "active"]
				transitions: [{
					from: "defined"
					to: "active"
					triggeredByCommand: "cmd-execute-incentive-mechanism"
					emitsEvents: ["evt-incentive-artifact-emitted"]
					guards: ["inv-five-tuple-mandatory"]
					description: "Lazy activation via first execution"
				}]
			}
			rationale: "Critical Authority-bearing per Section 5.4.1; serves CMT + FCE consumer BCs"
		},
		{
			code:        "agg-penalty-mechanism"
			name:        "PenaltyMechanism"
			description: "Authority-bearing penalty mechanism aggregate; produces PenaltyArtifact only (lifecycle post-emission é cross-BC concern per Q3.1.A.2)"
			rootIdentity: {
				field: "mechanismId"
				type: {kind: "domain-type", type: "MechanismId"}
			}
			fields: [
				{kind: "primitive", name:       "status", type:               "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionRef", valueObjectRef: "vo-objective-function"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "primitive", name:       "createdAt", type:            "datetime"},
				{kind: "primitive", name:       "updatedAt", type:            "datetime"},
			]
			handlesCommands: ["cmd-execute-penalty-mechanism"]
			emitsEvents: [
				"evt-penalty-artifact-emitted",
				"evt-tier-2-mechanism-artifact-created",
				"evt-mechanism-execution-record-created",
				"evt-gate-admission-decision-recorded",
				"evt-interpretability-class-declared",
				"evt-substrate-invariant-violation-detected",
				"evt-semantic-hazard-violation-detected",
				"evt-authority-boundary-violation-detected",
			]
			protectsInvariants: [
				"inv-five-tuple-mandatory", "inv-interpretability-class-declared", "inv-escape-path-mandatory",
				"inv-mechanism-type-closed-set", "inv-mechanism-dimension-closed-set",
				"inv-adversarial-resistance-monotone", "inv-interpretability-monotone",
				"inv-mechanism-gaming-detected", "inv-authority-chain-preserved",
				"inv-provenance-non-erasure", "inv-authority-boundary-violation-blocked",
			]
			usesValueObjects: [
				"vo-mechanism-artifact", "vo-tuple-authority-boundary", "vo-interpretability-class",
				"vo-authority-surface", "vo-escape-path", "vo-signal", "vo-provenance",
				"vo-confidence-class", "vo-mechanism-version", "vo-mechanism-type",
				"vo-tier-2-mechanism-artifact-substrate", "vo-lineage",
			]
			lifecycle: {
				initialState: "defined"
				states: ["defined", "active"]
				transitions: [{
					from: "defined"
					to: "active"
					triggeredByCommand: "cmd-execute-penalty-mechanism"
					emitsEvents: ["evt-penalty-artifact-emitted"]
					guards: ["inv-five-tuple-mandatory"]
					description: "Lazy activation via first execution"
				}]
			}
			rationale: "Critical Authority-bearing per Section 5.4.1; serves NPM + CMT + FCE consumer BCs; penalty lifecycle post-emission é cross-BC per Q3.1.A.2 ratificado"
		},
		{
			code:        "agg-governed-suggestion"
			name:        "GovernedSuggestion"
			description: "Authority-bearing GovernedSuggestion mechanism aggregate; produces suggestion artifacts (NÃO Recommendation per C13) para todos 6 consumer BCs"
			rootIdentity: {
				field: "mechanismId"
				type: {kind: "domain-type", type: "MechanismId"}
			}
			fields: [
				{kind: "primitive", name:       "status", type:               "string"},
				{kind: "value-object-ref", name: "mechanismVersion", valueObjectRef: "vo-mechanism-version"},
				{kind: "value-object-ref", name: "objectiveFunctionRef", valueObjectRef: "vo-objective-function"},
				{kind: "value-object-ref", name: "tupleAuthorityBoundary", valueObjectRef: "vo-tuple-authority-boundary"},
				{kind: "primitive", name:       "createdAt", type:            "datetime"},
				{kind: "primitive", name:       "updatedAt", type:            "datetime"},
			]
			handlesCommands: ["cmd-execute-governed-suggestion"]
			emitsEvents: [
				"evt-governed-suggestion-emitted",
				"evt-tier-2-mechanism-artifact-created",
				"evt-mechanism-execution-record-created",
				"evt-gate-admission-decision-recorded",
				"evt-interpretability-class-declared",
				"evt-substrate-invariant-violation-detected",
				"evt-semantic-hazard-violation-detected",
				"evt-authority-boundary-violation-detected",
			]
			protectsInvariants: [
				"inv-five-tuple-mandatory", "inv-interpretability-class-declared", "inv-escape-path-mandatory",
				"inv-mechanism-type-closed-set", "inv-mechanism-dimension-closed-set",
				"inv-adversarial-resistance-monotone", "inv-interpretability-monotone",
				"inv-governed-suggestion-strict-discipline",
				"inv-mechanism-gaming-detected", "inv-authority-chain-preserved",
				"inv-provenance-non-erasure", "inv-authority-boundary-violation-blocked",
			]
			usesValueObjects: [
				"vo-mechanism-artifact", "vo-tuple-authority-boundary", "vo-interpretability-class",
				"vo-authority-surface", "vo-consumer-bc-authority", "vo-escape-path",
				"vo-signal", "vo-provenance", "vo-confidence-class", "vo-mechanism-version",
				"vo-mechanism-type", "vo-tier-2-mechanism-artifact-substrate", "vo-lineage",
			]
			lifecycle: {
				initialState: "defined"
				states: ["defined", "active"]
				transitions: [{
					from: "defined"
					to: "active"
					triggeredByCommand: "cmd-execute-governed-suggestion"
					emitsEvents: ["evt-governed-suggestion-emitted"]
					guards: ["inv-five-tuple-mandatory", "inv-governed-suggestion-strict-discipline"]
					description: "Lazy activation via first execution"
				}]
			}
			rationale: "Critical Authority-bearing per Section 5.4.1; serves all 6 consumer BCs (discretionary input); founder canonical GovernedSuggestion ≠ Recommendation preserved; CP4 enforcement canonical"
		},

		// === Governance Aggregates (2, bootstrap-exempt per Q5.4) ===
		{
			code:        "agg-mechanism-mutation-governance"
			name:        "MechanismMutationGovernance"
			description: "Authority-bearing governance pathway aggregate para mechanism mutations; bootstrap-exempt per Q5.4 canonical (limit = Phase 5 constitutional review/founder-bounded governance)"
			rootIdentity: {
				field: "governanceCycleId"
				type: {kind: "domain-type", type: "GovernanceCycleId"}
			}
			fields: [
				{kind: "primitive", name: "cycleStatus", type: "string"},
				{kind: "primitive", name: "createdAt", type:   "datetime"},
			]
			handlesCommands: [
				"cmd-submit-mutation-proposal",
				"cmd-start-mutation-evaluation",
				"cmd-approve-mechanism-mutation",
				"cmd-reject-mechanism-mutation",
				"cmd-define-objective-function",
				"cmd-update-objective-function",
			]
			emitsEvents: [
				"evt-mutation-proposal-submitted",
				"evt-mutation-evaluation-started",
				"evt-mechanism-mutation-approved",
				"evt-mechanism-mutation-rejected",
				"evt-objective-function-defined",
				"evt-objective-function-updated",
				"evt-objective-function-mutation-cooldown-violated",
			]
			protectsInvariants: [
				"inv-mutation-requires-governance",
				"inv-mutation-proposal-immutability",
				"inv-authority-chain-preserved",
				"inv-objective-function-bounded",
				"inv-objective-function-mutation-cooldown",
				"inv-implicit-policy-creep-detected",
				"inv-objective-function-drift-detected",
				"inv-authority-delegation-drift-detected",
				"inv-semantic-hazard-violation-blocked",
			]
			entities: [{
				code:        "ent-mechanism-mutation-proposal"
				name:        "MechanismMutationProposal"
				description: "Authority-bearing entity (autoridade interna não-executiva per Q4.5 'autoriza entrada no caminho governado'); immutable post-submission"
				identity: {
					field: "proposalId"
					type: {kind: "domain-type", type: "ProposalId"}
				}
				fields: [
					{kind: "domain-type", name: "targetMechanismRef", type:  "MechanismRef"},
					{kind: "domain-type", name: "proposedChanges", type:     "ProposedChanges"},
					{kind: "primitive", name:  "proposer", type:             "string"},
					{kind: "primitive", name:  "submissionRationale", type:  "string"},
					{kind: "primitive", name:  "submissionTimestamp", type:  "datetime"},
					{kind: "primitive", name:  "proposalStatus", type:       "string"},
				]
				usesValueObjects: ["vo-mutation-type", "vo-tuple-authority-boundary"]
				rationale: "Q2.6 + Q4.5 canonical preserved + immutable post-submission per inv-mutation-proposal-immutability"
			}]
			usesValueObjects: [
				"vo-mutation-type", "vo-mechanism-version", "vo-tuple-authority-boundary", "vo-objective-function",
			]
			lifecycle: {
				initialState: "governance-active"
				states: ["governance-active", "proposal-received", "evaluation-active", "decision-emitted"]
				transitions: [
					{
						from: "governance-active"
						to: "proposal-received"
						triggeredByCommand: "cmd-submit-mutation-proposal"
						emitsEvents: ["evt-mutation-proposal-submitted"]
						description: "Proposal entry canonical"
					},
					{
						from: "proposal-received"
						to: "evaluation-active"
						triggeredByCommand: "cmd-start-mutation-evaluation"
						emitsEvents: ["evt-mutation-evaluation-started"]
						description: "Evaluation begins"
					},
					{
						from: "evaluation-active"
						to: "decision-emitted"
						triggeredByCommand: "cmd-approve-mechanism-mutation"
						emitsEvents: ["evt-mechanism-mutation-approved"]
						guards: ["inv-mutation-requires-governance", "inv-authority-chain-preserved"]
						description: "Approval decision canonical"
					},
					{
						from: "evaluation-active"
						to: "decision-emitted"
						triggeredByCommand: "cmd-reject-mechanism-mutation"
						emitsEvents: ["evt-mechanism-mutation-rejected"]
						description: "Rejection decision canonical"
					},
					{
						from: "decision-emitted"
						to: "governance-active"
						triggeredByCommand: "cmd-start-mutation-evaluation"
						emitsEvents: ["evt-mutation-evaluation-started"]
						description: "Cycle restart (cyclical first-class per Q6.3)"
					},
				]
			}
			consistencyBoundary: {
				guarantees: [
					"Synchronous within governance cycle (atomic decision)",
					"Atomic proposal submission with immutable lock",
					"Atomic approval/rejection decision",
				]
				explicitlyDoesNotGuarantee: [
					"Immediate mutation cascade to target aggregate",
					"Cross-cycle governance state consistency",
				]
				failureModes: [
					"Governance pathway deadlock (Phase 5 escalation)",
					"Conflicting proposals (rejection canonical)",
					"Cooldown violation (rejection)",
				]
				rationale: "Governance pathway synchronous within cycle per Section 6.5 strong consistency requirement"
			}
			rationale: "Bootstrap-exempt per Q5.4 (limit = Phase 5 constitutional review/founder-bounded governance, NÃO equivalent gate); cyclical lifecycle first-class per Q6.3 ratificado"
		},
		{
			code:        "agg-mechanism-governance-mutation-control"
			name:        "MechanismGovernanceMutationControl"
			description: "META-control aggregate (Phase 1.5 emergent) para governance over governance-producing mechanisms; bootstrap-exempt META per Q5.4 + Q4.2 recursive 5-tuple canonical"
			rootIdentity: {
				field: "metaControlCycleId"
				type: {kind: "domain-type", type: "MetaControlCycleId"}
			}
			fields: [
				{kind: "primitive", name: "controlStatus", type: "string"},
				{kind: "primitive", name: "createdAt", type:     "datetime"},
			]
			handlesCommands: ["cmd-emit-loop-marker"]
			emitsEvents: [
				"evt-loop-marker-emitted",
				"evt-mechanism-legitimacy-capture-detected",
				"evt-legitimacy-accumulation-risk-warning",
			]
			protectsInvariants: [
				"inv-recursive-consumption-bounded",
				"inv-loop-marker-required",
				"inv-authority-surface-not-universalized",
				"inv-mechanism-legitimacy-capture-detected",
				"inv-legitimacy-accumulation-bounded",
			]
			usesValueObjects: ["vo-loop-marker", "vo-tuple-authority-boundary"]
			lifecycle: {
				initialState: "meta-control-active"
				states: ["meta-control-active", "recursive-evaluation", "recursive-decision"]
				transitions: [
					{
						from: "meta-control-active"
						to: "recursive-evaluation"
						triggeredByCommand: "cmd-emit-loop-marker"
						emitsEvents: ["evt-loop-marker-emitted"]
						guards: ["inv-loop-marker-required"]
						description: "Recursion entry"
					},
					{
						from: "recursive-evaluation"
						to: "recursive-decision"
						triggeredByCommand: "cmd-emit-loop-marker"
						emitsEvents: ["evt-loop-marker-emitted"]
						guards: ["inv-recursive-consumption-bounded"]
						description: "Recursion progression"
					},
					{
						from: "recursive-decision"
						to: "meta-control-active"
						triggeredByCommand: "cmd-emit-loop-marker"
						emitsEvents: ["evt-loop-marker-emitted"]
						description: "Recursion close (recursive cyclical canonical)"
					},
				]
			}
			rationale: "Bootstrap-exempt META per Q5.4 + Q4.2 recursive 5-tuple canonical Family Mesh META-extension materialization estrutural"
		},

		// === Substrate Aggregates (2 stateless ledgers per Q3-final.2) ===
		{
			code:        "agg-tier-1-substrate"
			name:        "Tier1Substrate"
			description: "Tier 1 signal substrate aggregate — ledger de admitted signals; stateless per tq-dmg-07"
			rootIdentity: {
				field: "substrateId"
				type: {kind: "primitive", type: "string"}
			}
			handlesCommands: ["cmd-admit-tier-1-signal"]
			emitsEvents: ["evt-tier-1-signal-admitted", "evt-substrate-invariant-violation-detected"]
			protectsInvariants: [
				"inv-substrate-invariant-preservation",
				"inv-tier-1-signal-schema-conformance",
				"inv-tier-substrate-separation",
			]
			usesValueObjects: ["vo-signal", "vo-tier-1-signal-substrate", "vo-provenance"]
			rationale: "Stateless aggregate per tq-dmg-07; ledger/registry de admitted Tier 1 signals canonical (justificativa ledger explícita)"
		},
		{
			code:        "agg-tier-1-q-quarantine"
			name:        "Tier1QQuarantine"
			description: "Tier 1.Q exogenous quarantine aggregate — ledger de quarantined signals; founder canonical 'quarantine contém e registra, NÃO decide verdade'; stateless per tq-dmg-07"
			rootIdentity: {
				field: "quarantineLedgerId"
				type: {kind: "primitive", type: "string"}
			}
			handlesCommands: ["cmd-quarantine-exogenous-signal"]
			emitsEvents: ["evt-tier-1-q-exogenous-signal-quarantined", "evt-substrate-invariant-violation-detected"]
			protectsInvariants: [
				"inv-exogenous-quarantine",
				"inv-tier-1-q-source-enumerated",
				"inv-tier-substrate-separation",
			]
			usesValueObjects: [
				"vo-signal", "vo-tier-1-q-exogenous-signal-quarantine", "vo-exogenous-source-enum", "vo-provenance",
			]
			rationale: "Stateless aggregate per tq-dmg-07; ledger de quarantined exogenous signals; founder canonical preservada literal"
		},

		// === Observation Aggregate (1 stateless ledger) ===
		{
			code:        "agg-lineage-observation"
			name:        "LineageObservation"
			description: "Observation-bearing aggregate para consumer interactions (escape path + acknowledgments); stateless ledger per Q4.4 multi-modal defense"
			rootIdentity: {
				field: "observationLedgerId"
				type: {kind: "primitive", type: "string"}
			}
			handlesCommands: ["cmd-record-consumer-escape", "cmd-record-consumer-acknowledgment"]
			emitsEvents: ["evt-escape-path-exercised", "evt-consumer-acknowledgment-recorded"]
			protectsInvariants: [
				"inv-consumer-acknowledgment-non-approval",
				"inv-lineage-propagation-continuous",
				"inv-consumer-bc-authority-bounded",
			]
			usesValueObjects: [
				"vo-lineage", "vo-weighting-lineage", "vo-escape-path", "vo-consumer-bc-authority",
				"vo-acknowledgment-type",
			]
			rationale: "Stateless ledger consumer interactions; preserva Q4.4 multi-modal defense (combination d) canonical"
		},
	]

	// =========================================================================
	// MODULES — 4 organizational groupings
	// =========================================================================

	modules: [
		{
			code: "mod-mechanism-execution"
			name: "MechanismExecution"
			description: "6 mechanism aggregates Authority-bearing"
			aggregateRefs: [
				"agg-scoring-mechanism", "agg-matching-mechanism", "agg-ranking-mechanism",
				"agg-incentive-mechanism", "agg-penalty-mechanism", "agg-governed-suggestion",
			]
			rationale: "Mechanism execution domain canonical (Q2.1 distinct authority topology)"
		},
		{
			code: "mod-mutation-governance"
			name: "MutationGovernance"
			description: "2 governance aggregates bootstrap-exempt per Q5.4"
			aggregateRefs: [
				"agg-mechanism-mutation-governance", "agg-mechanism-governance-mutation-control",
			]
			rationale: "Governance pathway domain META-canonical (bootstrap-exempt + recursive)"
		},
		{
			code: "mod-substrate"
			name: "Substrate"
			description: "2 substrate ledger aggregates (Tier 1 + Tier 1.Q; Tier 2 emerge via mechanism aggregates per Q3-final.2)"
			aggregateRefs: ["agg-tier-1-substrate", "agg-tier-1-q-quarantine"]
			rationale: "Substrate ledger domain canonical"
		},
		{
			code: "mod-lineage-observation"
			name: "LineageObservation"
			description: "Consumer interaction observation ledger"
			aggregateRefs: ["agg-lineage-observation"]
			rationale: "Q4.4 multi-modal defense materialization"
		},
	]

	// =========================================================================
	// DOMAIN SERVICES — 7
	// =========================================================================

	domainServices: [
		{
			code: "svc-execution-gating"
			name: "ExecutionGatingService"
			description: "MechanismExecutionGate canonical stateless Gate"
			orchestrates: [
				"agg-scoring-mechanism", "agg-matching-mechanism", "agg-ranking-mechanism",
				"agg-incentive-mechanism", "agg-penalty-mechanism", "agg-governed-suggestion",
				"agg-tier-1-substrate", "agg-tier-1-q-quarantine",
			]
			rationale: "Gate constitucional stateless per Q3-final.4 ratificado, NÃO 'god service' operacional; orchestrates 8 aggregates para Tier 1/1.Q→Tier 2 admission canonical per Section 4.3 Cluster A T-1 resolved; stateless coordination over substrate (founder canonical preservada)"
		},
		{
			code: "svc-substrate-tier-verification"
			name: "SubstrateTierVerification"
			description: "Substrate tier integrity verification stateless"
			orchestrates: ["agg-tier-1-substrate", "agg-tier-1-q-quarantine"]
			rationale: "Stateless verification Gate per Section 6.1.2 cap-substrate-tier-integrity-verification"
		},
		{
			code: "svc-authority-chain-reinforcement"
			name: "AuthorityChainReinforcement"
			description: "AuthorityChainReinforcement Gate per C12"
			orchestrates: [
				"agg-scoring-mechanism", "agg-matching-mechanism", "agg-ranking-mechanism",
				"agg-incentive-mechanism", "agg-penalty-mechanism", "agg-governed-suggestion",
				"agg-mechanism-mutation-governance",
			]
			rationale: "C12 Gate canonical authority chain integrity"
		},
		{
			code: "svc-lineage-propagation"
			name: "LineagePropagation"
			description: "LineagePropagationRules Gate per Section 4.3 Cluster C"
			orchestrates: [
				"agg-scoring-mechanism", "agg-matching-mechanism", "agg-ranking-mechanism",
				"agg-incentive-mechanism", "agg-penalty-mechanism", "agg-governed-suggestion",
				"agg-lineage-observation",
			]
			rationale: "Lineage continuity Gate canonical"
		},
		{
			code: "svc-semantic-hazard-violation-detection"
			name: "SemanticHazardViolationDetection"
			description: "Cluster E enforcement runtime per Section 5.9 R-5.9.1"
			orchestrates: [
				"agg-scoring-mechanism", "agg-matching-mechanism", "agg-ranking-mechanism",
				"agg-incentive-mechanism", "agg-penalty-mechanism", "agg-governed-suggestion",
				"agg-mechanism-mutation-governance", "agg-mechanism-governance-mutation-control",
				"agg-tier-1-substrate", "agg-tier-1-q-quarantine", "agg-lineage-observation",
			]
			rationale: "Runtime hazard verification over all 11 aggregates per Section 5.9"
		},
		{
			code: "svc-authority-boundary-violation-detection"
			name: "AuthorityBoundaryViolationDetection"
			description: "5-tuple scope enforcement consumer-side"
			orchestrates: [
				"agg-scoring-mechanism", "agg-matching-mechanism", "agg-ranking-mechanism",
				"agg-incentive-mechanism", "agg-penalty-mechanism", "agg-governed-suggestion",
			]
			rationale: "Q2.6 AuthorityBoundaryViolation runtime canonical"
		},
		{
			code: "svc-lineage-tracing"
			name: "LineageTracing"
			description: "Observation-bearing lineage tracing"
			orchestrates: [
				"agg-scoring-mechanism", "agg-matching-mechanism", "agg-ranking-mechanism",
				"agg-incentive-mechanism", "agg-penalty-mechanism", "agg-governed-suggestion",
				"agg-lineage-observation",
			]
			rationale: "Section 6.1.2 cap-mechanism-artifact-lineage-tracing Observation-bearing"
		},
	]

	// =========================================================================
	// POLICIES — 2 (per Q3-final.3)
	// =========================================================================

	policies: [
		{
			code: "pol-objective-function-update-on-approval"
			name: "ObjectiveFunctionUpdateOnApproval"
			description: "Auto-execute ObjectiveFunction update post-governance approval"
			triggeredByEvent: "evt-mechanism-mutation-approved"
			issuesCommand: "cmd-update-objective-function"
			guards: ["inv-objective-function-mutation-cooldown"]
			rationale: "Automation canonical pós-governance approval para mutationType=objective-function-update (Q5.6 cooldown enforced via guard)"
		},
		{
			code: "pol-mutation-trigger-on-authority-boundary-violation"
			name: "MutationTriggerOnAuthorityBoundaryViolation"
			description: "Auto-propose corrective mutation when boundary violation detected"
			triggeredByEvent: "evt-authority-boundary-violation-detected"
			issuesCommand: "cmd-submit-mutation-proposal"
			guards: ["inv-mutation-requires-governance"]
			rationale: "Routes corrective intent through governance pathway canonical (anti-direct-mutation)"
		},
	]

	// =========================================================================
	// PROJECTIONS — 10
	// =========================================================================

	projections: [
		{
			code: "prj-authority-bearing-tuple-monitor"
			name: "AuthorityBearingTupleMonitor"
			description: "Consolidates 5-tuple state across all Authority-bearing aggregates"
			consumesEvents: [
				"evt-scoring-artifact-emitted", "evt-matching-artifact-emitted", "evt-ranking-artifact-emitted",
				"evt-incentive-artifact-emitted", "evt-penalty-artifact-emitted", "evt-governed-suggestion-emitted",
				"evt-interpretability-class-declared",
			]
			queryCapabilities: [{
				code: "qry-authority-bearing-tuple-state"
				description: "Query 5-tuple state per Authority-bearing artifact"
				rationale: "Cross-aggregate 5-tuple verification canonical"
			}]
			rationale: "Q4.3 per-authority-bearing gate verification materialization"
		},
		{
			code: "prj-authority-chain-monitor"
			name: "AuthorityChainMonitor"
			description: "Consolidates authority chain state across mutations"
			consumesEvents: [
				"evt-scoring-artifact-emitted", "evt-matching-artifact-emitted", "evt-ranking-artifact-emitted",
				"evt-incentive-artifact-emitted", "evt-penalty-artifact-emitted", "evt-governed-suggestion-emitted",
				"evt-mechanism-mutation-approved", "evt-mechanism-mutation-rejected",
			]
			queryCapabilities: [{
				code: "qry-authority-chain-integrity"
				description: "Query chain integrity state"
				rationale: "C12 authority chain canonical verification"
			}]
			rationale: "Authority chain integrity verification cross-aggregate"
		},
		{
			code: "prj-recursion-marker-monitor"
			name: "RecursionMarkerMonitor"
			description: "Recursion depth + bound state"
			consumesEvents: ["evt-loop-marker-emitted"]
			queryCapabilities: [{
				code: "qry-recursion-depth-current"
				description: "Current recursion depth state"
				rationale: "CC6 recursion bound canonical"
			}]
			rationale: "CC6 enforcement materialization"
		},
		{
			code: "prj-objective-function-mutation-history"
			name: "ObjectiveFunctionMutationHistory"
			description: "ObjectiveFunction version + cooldown state history"
			consumesEvents: [
				"evt-objective-function-defined", "evt-objective-function-updated",
				"evt-objective-function-mutation-cooldown-violated",
			]
			queryCapabilities: [
				{
					code: "qry-objective-function-version-history"
					description: "Version history per mechanism"
					rationale: "Q6.5 snapshot-aware canonical"
				},
				{
					code: "qry-objective-function-cooldown-status"
					description: "Cooldown remaining per ObjectiveFunction"
					rationale: "Q5.6 cooldown enforcement"
				},
			]
			rationale: "Q5.6 + Q6.5 materialization canonical"
		},
		{
			code: "prj-mutation-policy-pattern-monitor"
			name: "MutationPolicyPatternMonitor"
			description: "Mutation pattern + policy creep indicator"
			consumesEvents: ["evt-mechanism-mutation-approved", "evt-mechanism-mutation-rejected"]
			queryCapabilities: [
				{
					code: "qry-mutation-pattern-trends"
					description: "Mutation pattern over time"
					rationale: "Implicit policy creep detection"
				},
				{
					code: "qry-policy-creep-indicator"
					description: "Policy creep current indicator"
					rationale: "Cluster D drift detection"
				},
			]
			rationale: "Cluster D implicit-policy-creep detection canonical"
		},
		{
			code: "prj-authority-delegation-monitor"
			name: "AuthorityDelegationMonitor"
			description: "Authority delegation state cross Authority-bearing"
			consumesEvents: [
				"evt-scoring-artifact-emitted", "evt-matching-artifact-emitted", "evt-ranking-artifact-emitted",
				"evt-incentive-artifact-emitted", "evt-penalty-artifact-emitted", "evt-governed-suggestion-emitted",
				"evt-authority-delegation-drift-detected",
			]
			queryCapabilities: [{
				code: "qry-authority-delegation-state"
				description: "Delegation state per consumer BC"
				rationale: "5-tuple consumerBCs scope monitoring"
			}]
			rationale: "Cluster D authority-delegation-drift detection"
		},
		{
			code: "prj-legitimacy-accumulation-monitor"
			name: "LegitimacyAccumulationMonitor"
			description: "Cluster F META drift monitoring (forbidden term as failure mode descriptor admissible canonical exception)"
			consumesEvents: [
				"evt-scoring-artifact-emitted", "evt-matching-artifact-emitted", "evt-ranking-artifact-emitted",
				"evt-incentive-artifact-emitted", "evt-penalty-artifact-emitted", "evt-governed-suggestion-emitted",
				"evt-legitimacy-accumulation-risk-warning", "evt-mechanism-legitimacy-capture-detected",
			]
			queryCapabilities: [{
				code: "qry-legitimacy-accumulation-metric"
				description: "Accumulation metric current state"
				rationale: "Cluster F META drift threshold monitoring"
			}]
			rationale: "Q2.3 Cluster F partial materialization canonical + canonical exception preserved literal"
		},
		{
			code: "prj-lineage-continuity-monitor"
			name: "LineageContinuityMonitor"
			description: "Lineage chain continuity state"
			consumesEvents: [
				"evt-scoring-artifact-emitted", "evt-matching-artifact-emitted", "evt-ranking-artifact-emitted",
				"evt-incentive-artifact-emitted", "evt-penalty-artifact-emitted", "evt-governed-suggestion-emitted",
				"evt-lineage-discontinuity-detected",
			]
			queryCapabilities: [{
				code: "qry-lineage-continuity-state"
				description: "Lineage continuity state per artifact"
				rationale: "LineagePropagationRules canonical"
			}]
			rationale: "C6 + lineage propagation continuous verification"
		},
		{
			code: "prj-naming-hazard-monitor"
			name: "NamingHazardMonitor"
			description: "Cluster E enforcement runtime tracking"
			consumesEvents: ["evt-semantic-hazard-violation-detected"]
			queryCapabilities: [{
				code: "qry-semantic-hazard-incidents"
				description: "Hazard incidents over time"
				rationale: "Cluster E + R-3.5.5 enforcement tracking"
			}]
			rationale: "Section 3 + Q2.6 SemanticHazardViolation materialization"
		},
		{
			code: "prj-consumer-acknowledgment-semantic-monitor"
			name: "ConsumerAcknowledgmentSemanticMonitor"
			description: "Q4.4 multi-modal defense (combination d) projection layer"
			consumesEvents: ["evt-consumer-acknowledgment-recorded"]
			queryCapabilities: [
				{
					code: "qry-consumer-acknowledgment-pattern"
					description: "Acknowledgment pattern over time"
					rationale: "Q4.4 multi-modal defense"
				},
				{
					code: "qry-acknowledgment-drift-indicator"
					description: "Drift Observation→Authority indicator"
					rationale: "Section 4.6 SC-1 safeguard verification"
				},
			]
			rationale: "Q4.4 multi-modal defense materialization canonical (combination d: projection layer)"
		},
	]

	// =========================================================================
	// SYSTEM CONSISTENCY MODEL (per tq-dm-18 production-safety hardening)
	// =========================================================================

	systemConsistencyModel: {
		type: "eventual"
		intraAggregateGuarantees: [
			"5-tuple match at emission atomic (mechanism aggregates ACID)",
			"Mutation lifecycle atomic within governance aggregate (synchronous canonical)",
			"Substrate ledger append atomic",
			"Authority artifact + InterpretabilityClass + 5-tuple binding atomic at emission",
		]
		crossAggregateGuarantees: [
			"Lineage propagation eventual via LineagePropagationRules",
			"Drift detection event propagation eventual to Phase 5 governance + consumer BCs",
			"Mutation approval cascade to target Authority-bearing eventual",
		]
		explicitlyDoesNotGuarantee: [
			"Strong consistency across consumer BCs reads",
			"Synchronous mutation cascade across mechanism aggregates",
			"Real-time legitimacy accumulation aggregation",
			"Immediate propagation of governance decisions to consumer-facing state",
		]
		conflictResolution: {
			strategy: "explicit-command"
			rationale: "Mutation conflicts resolved via mutation governance pathway commands canonical; NO last-write-wins (drift risk per Cluster D implicit-policy-creep)"
		}
		consumerProtocol: [
			"REW: eventual consistency + 5-tuple verification at consumption (scoring artifacts → pricing decisions)",
			"NPM: eventual consistency + 5-tuple verification (scoring + ranking → qualification decisions)",
			"CMT: eventual consistency + 5-tuple verification (matching + incentive → commitment decisions)",
			"SSC: eventual consistency + 5-tuple verification (ranking + matching → selection sovereignty preserved)",
			"FCE: eventual consistency + 5-tuple verification + monetary lineage anchor (incentive + penalty → payment execution)",
			"NTF: eventual consistency + admissibility-bound (legitimacy + admissibility signals)",
			"Phase 5 governance: synchronous within governance pathway (mutation decisions + drift signals)",
		]
		systemFailureModes: [
			"Gate failure cascade Critical (MechanismExecutionGate fails → all Authority-bearing emission halted)",
			"Mutation governance pathway deadlock (Phase 5 constitutional review escalation per Q5.4)",
			"Signal contamination cross-Tier (quarantine breach affects Tier 1 substrate purity)",
			"5-tuple drift (Authority-bearing emits incomplete OR universalized scope; redundant Q5.5 protection)",
			"Lineage discontinuity (LineagePropagationRules Gate fails → affected artifacts marked downstream)",
			"Cluster E semantic hazard violation (building block name slides forbidden territory mid-lifecycle)",
			"Recursion divergence (CC6 unbounded feedback loop)",
			"Objective-function drift (Q5.6 cooldown + bounded violations cascade affecting all mechanism outputs)",
		]
		replayScopeStrategy: "by-aggregateRef"
		rationale: "Per-aggregate replay preserva substrate snapshot integrity per Q6.5 (artifactId + mechanismVersion + objectiveFunctionVersion) + cooldown-aware replay para ObjectiveFunction-affected outputs; by-correlationId pode aparecer depois como detalhe complementar (per Q3-final.5 ratificado), NÃO como estratégia primária"
	}

	// =========================================================================
	// DECISION AUTHORITY MODEL (per Section 6.6 — hybrid per Q3-final.6)
	// =========================================================================

	decisionAuthorityModel: {
		type: "hybrid"
		authoritativeScope: "Mechanism outputs (Scoring/Matching/Ranking/Incentive/Penalty artifacts) within 5-tuple discipline canonical; governance decisions (mutation approval/rejection) within governance pathway scope"
		advisoryScope: "GovernedSuggestion artifacts (discretionary input para consumer BCs); consumer BCs retain sovereign reasoning per Section 6.6 decision precedence canonical"
		rationale: "Hybrid authority preserva Family Mesh META-extension pattern: authoritative sobre mechanism-bound outputs com 5-tuple discipline + advisory através GovernedSuggestion preservando consumer sovereignty per CP4 anti-engagement-language; Phase 5 constitutional precedence supersede all NIM-internal authority per Section 6.6"
	}

	// =========================================================================
	// RATIONALE — Outer rationale Sections 1-6 consolidating Phase 3.0 charter
	// =========================================================================

	rationale: """
		NIM domain-model materializa Phase 3 WI-045 closure single-shot per
		founder direction "Faz a fase 3 toda de uma vez" (paralelo NTF Phase
		2 single-shot precedent canonical). Large NIM domain-model; density
		justified by META-constitutional complexity.

		Family Mesh META-extension explicit: NIM primeiro guardian META-
		constitucional (governance over governance-producing mechanisms);
		qualitatively distinto FCE (semantic convergence) + NTF (admissibility
		integrity).

		=============================================================================
		SECTION 1 — ONTOLOGICAL ADMISSIBILITY FRAMING
		=============================================================================

		Phase 1 protege topology; Phase 2 protege semantic substrate; Phase
		3 protege ontology formation itself — quais coisas o sistema está
		autorizado a considerar que "existem". (canonical phrase preservada
		literal)

		Ontological Admissibility é gate constitucional precedendo behavior-
		first ordering: "Nenhuma entity, value object, event, command,
		invariant, aggregate, policy, projection, domain service ou capability
		pode entrar no domain-model NIM sem demonstrar compatibilidade
		explícita com o semantic governance substrate definido pelo glossary
		Phase 2."

		Distinção qualitativa de cognatos:
		- Naming convention (aesthetic) → inconsistência estilo
		- Linting (technical) → erro mecânico
		- Style guide (aesthetic) → inconsistência editorial
		- Terminology consistency (warn) → drift terminológico
		- Glossary alignment PG (warn) → divergência UL↔código
		- ONTOLOGICAL ADMISSIBILITY (constitutional fail) → REGRESSÃO
		  CONSTITUCIONAL

		Authority status constitutional baseado em: (a) glossary upstream
		vinculante (Phase 2 closure: 2586L > canvas 1788L = semântica é
		infraestrutura operacional); (b) mechanism artifacts consumidos
		downstream como substrate de reasoning; (c) Cluster E watchlist =
		active containment infrastructure; (d) Family Mesh META-extension
		recursão canonical.

		Hierarchia constraint: Canvas Phase 1 (15 clauses + 14 capabilities)
		→ Glossary Phase 2 (68 terms + Cluster E + Cluster F) → Phase 3.0
		Charter → Phase 3.1-3.4 admission → Phase 3.5 SRR.

		Frase canonical preserved literal: "Behavior-first ordering governs
		modeling sequence; Ontological Admissibility governs existential
		permission."

		Recursive nature: per-building-block enforcement (NÃO one-shot Phase
		3.0); Phase 3.1+ catalog admission verifica cada novo building block.

		Failure mode: constitutional regression ≠ editorial inconsistency.

		Q4 ratificado canonical: NIM-particular em Phase 3.0; promoção a
		template canonical para outros BCs requer uso real + SRR + ADR/WI
		separate.

		=============================================================================
		SECTION 2 — CANONICAL ENTITY/OBJECT ADMISSIBILITY MAP
		=============================================================================

		Metodologia: candidates extraídos de canvas + glossary + Q2.6
		founder canonical = ~85-95 candidates classificados em 4 clusters
		+ canvas-direct + founder canonical.

		8 tensions T-1..T-8 surfaced + Section 4 resolutions:
		- T-1: MechanismExecutionGate → Gate (T-1 resolved)
		- T-2: MechanismIntegrityMatrix → Substrate (T-2 resolved)
		- T-3: Mechanism types → 6 separate aggregates per Q2.1 (T-3 resolved)
		- T-4: AuthorityChainReinforcement → Gate (T-4 resolved)
		- T-5: C14/C15 → rationale anchors + 3 derived invariants per Q2.2 (T-5)
		- T-6: Capabilities per-cap classification (Phase 3.1)
		- T-7: Cluster F per-term classification per Q2.3 (T-7)
		- T-8: Drift multi-modality canonical (T-8 resolved)

		Founder canonical 5 inverses canonical exemplars preservada literal:
		- MechanismArtifact ≠ DecisionArtifact (materialized em vo-mechanism-artifact)
		- Signal ≠ Verdict (materialized em vo-signal)
		- RankingOutput ≠ Selection (materialized em evt-ranking-artifact-emitted +
		  agg-ranking-mechanism rationale)
		- GovernedSuggestion ≠ Recommendation (materialized em vo-mechanism-type +
		  inv-governed-suggestion-strict-discipline)
		- ConfidenceClass ≠ TruthClaim (materialized em vo-confidence-class)

		10 Q2.6 founder candidates integrated: MechanismExecutionRecord (entity),
		MechanismVersion (VO), WeightingLineage (VO), ObjectiveFunction (Authority-
		bearing VO), LoopMarker (VO), ConsumerAcknowledgment (Observation-bearing
		canonical safeguard), AuthorityBoundaryViolation (event), SemanticHazard-
		Violation (event + invariant), MechanismMutationProposal (Authority-bearing
		entity), MechanismMutationDecision (Authority-bearing event canonical exception).

		=============================================================================
		SECTION 3 — FORBIDDEN ONTOLOGY MAP
		=============================================================================

		Frase canonical preservada literal: "Name the evidence type or
		bounded scope, not the authority claim."

		5 detailed FORBIDDEN canonical (rejection absoluta):
		- Recommendation* (CP4 engagement-gravity)
		- Intelligent*/Smart* (CP2 optimization-euphemism)
		- Unbiased*/Neutral* (CP3 objectivity-theater)
		- Consensus* (CP5 authority-euphemism)
		- Alignment* (CP6 legitimacy-naturalization)

		20 BOUNDED/FORBIDDEN brief + canonical replacements (Q3.3 8 founder
		additions): VerifiedSource → SourceWithVerificationEvidence,
		TrustedParticipant → ParticipantWithVerificationEvidence,
		ApprovedSupplier → SupplierWithQualificationEvidence,
		QualifiedByNIM → NPMQualificationInputFromNIM,
		ObjectiveScore → ScoringOutputWithLineage,
		FairRanking → RankingOutputWithDeclaredCriteria,
		HealthyEcosystem → EcosystemMetricSnapshot,
		AlignedIncentive → IncentiveStructureWithDeclaredObjective.

		Authority canonical exceptions (3 admissible apenas): AuthoritySurface,
		TupleAuthorityBoundary, ConsumerBCAuthority. Fora disso = forbidden
		OR requires-justification forte.

		R-3.5.1..R-3.5.5 enforcement rules:
		- R-3.5.1: Substring exact match against watchlist
		- R-3.5.2: Semantic context check (BOUNDED hit elevation)
		- R-3.5.3: 5 canonical exceptions preserved (Ranking* / Scoring* /
		  Matching* / Mechanism* admissible roots + AuthoritySurface)
		- R-3.5.4: Governance context exception (MechanismMutationDecision
		  canonical único)
		- R-3.5.5: No benevolent abstraction rescue — 5 canonical examples:
		  ResponsibleRecommendation = F, TransparentConsensus = F,
		  VerifiedTrustedSource = F, GovernedAlignment = F,
		  SafeIntelligentMechanism = F

		Canonical exception preservada literal: "Termo forbidden usado como
		descritor de failure mode é admissible. Distinto de benevolent
		abstraction rescue per R-3.5.5." Exemplos: legitimacy em
		inv-legitimacy-accumulation-bounded + inv-mechanism-legitimacy-
		capture-detected.

		=============================================================================
		SECTION 4 — AUTHORITY-BEARING OBJECT TAXONOMY
		=============================================================================

		Frase canonical preservada literal: "ObjectiveFunction is dangerous
		because it defines what the system learns to want."

		4-category framework:
		- Authority-bearing: claim about authority over consumer BCs' reasoning;
		  5-tuple discipline MANDATORY
		- Observation-bearing: record/transmit observation sem authority claim
		- Gate: enforce admission/transition em boundary constitutional; stateless
		- Substrate: foundational layer consumido por mechanisms (não BCs direct)

		Q1-Q4 operational test sequence: mutually exclusive — first match wins.

		Distribution NIM:
		- Authority-bearing: ~17 (6 mechanism + 7 Cluster C Authority + 2
		  governance + ObjectiveFunction + MechanismMutationProposal + Decision)
		- Observation-bearing: ~25-30 (records, events, projections, VOs)
		- Gate: ~22-25 (invariants + services)
		- Substrate: ~6-8 (Tier 1/1.Q/2 + IntegrityMatrix)

		Q4.3 canonical formulation preservada literal: "Every authority-bearing
		object must have at least one explicit gate protecting its creation,
		mutation, consumption, or propagation."

		4 special cases (SC-1..SC-4):
		- SC-1 ConsumerAcknowledgment: classification IS safeguard (Q4.4 multi-
		  modal defense combination d)
		- SC-2 ObjectiveFunction: dangerous; bounded + mutation-governed per Q5.6
		- SC-3 MechanismMutationDecision: canonical exception per R-3.5.4
		- SC-4 TupleAuthorityBoundary recursive canonical per Q4.2 (META-
		  constitutional em forma estrutural)

		Q5.5 redundant protection: MechanismExecutionGate + inv-authority-
		surface-not-universalized.

		Q5.6 ObjectiveFunction additional protection: inv-objective-function-
		bounded + inv-objective-function-mutation-cooldown.

		=============================================================================
		SECTION 5 — SEMANTIC BLAST RADIUS MATRIX
		=============================================================================

		5-tier scale (Q5.1 ratificado): Critical / High / Medium / Low / Zero.
		Critical META = qualifier, NÃO sexto tier.

		Consumer BC inventory: REW + NPM + CMT + SSC + FCE + NTF + Phase 5
		governance + Family Mesh META (conceptual).

		Critical concentration zones: 6 mechanism aggregates + Cluster C
		Authority-bearing + 2 governance + ObjectiveFunction + MechanismMutation-
		Proposal + Decision = ~17 Authority-bearing constituting NIM's
		structural authority core.

		R-5.9.1 escalation rule (Q5.2 ratificado proactive defense):
		BOUNDED watchlist + Tier ≥ High → automatic FORBIDDEN promotion.

		Per-authority-bearing gate verification table: cada ~17 Authority-
		bearing protected by ≥1 explicit gate canonical (Q4.3 enforced).

		2 bootstrap-exempt META-gates (Q5.4 permanent canonical property):
		MechanismMutationGovernance + agg-mechanism-governance-mutation-
		control; limit = Phase 5 constitutional review/founder-bounded
		governance.

		=============================================================================
		SECTION 6 — CROSS-CANVAS ALIGNMENT + LIFECYCLE + PRODUCTION-SAFETY
		=============================================================================

		15 constitutional clauses C1-C15 anchored:
		- C1 (Tier substrate separation): inv-tier-substrate-separation + 3
		  substrate VOs
		- C2 (Gate constitutional center): MechanismExecutionGate + inv-gate-
		  mandatory-admission
		- C3 (Tier 1.Q quarantine): inv-exogenous-quarantine + vo-tier-1-q
		- C4 (5-tuple discipline): TupleAuthorityBoundary + inv-five-tuple-mandatory
		- C5 (Substrate-invariants preservation): inv-substrate-invariant-
		  preservation umbrella + 3 sub-invariants Group D
		- C6 (Provenance non-erasure): vo-provenance + inv-provenance-non-erasure
		- C7 (Interpretability consumer rights): InterpretabilityClass +
		  inv-interpretability-class-declared
		- C8 (Escape-path mandatory): EscapePath + inv-escape-path-mandatory
		- C9 (6 mechanism types): 6 separate aggregates + inv-mechanism-type-
		  closed-set
		- C10 (8 mechanism dimensions): vo-mechanism-dimension + vo-adversarial-
		  resistance-class + inv-mechanism-dimension-closed-set
		- C11 (Mutation governance): agg-mechanism-mutation-governance + inv-
		  mutation-requires-governance
		- C12 (Authority chain reinforcement): svc-authority-chain-reinforcement
		  + inv-authority-chain-preserved
		- C13 (GovernedSuggestion strict): agg-governed-suggestion + inv-
		  governed-suggestion-strict-discipline
		- C14 (Recursive governance META): rationale anchor + 3 derived
		  invariants per Q2.2 (inv-loop-marker-required + inv-authority-
		  surface-not-universalized + inv-recursive-consumption-bounded)
		- C15 (Bidirectional feedback): rationale anchor + shared derived
		  invariants C14

		4 FORBIDDEN canonical mutations defended via Q6.4 invariants:
		- adversarial-resistance downgrade → inv-adversarial-resistance-monotone
		- 5-tuple removal → inv-five-tuple-mandatory + inv-authority-surface-not-
		  universalized
		- interpretability relaxation → inv-interpretability-monotone
		- objective-function substitution → inv-objective-function-bounded +
		  inv-objective-function-mutation-cooldown

		Per Q6.2 ratificado: tq-dmg-04 sobe de warn para fail-equivalent em
		NIM via Ontological Admissibility. Glossary divergence em qualquer
		building block = constitutional regression, NÃO editorial inconsistência.

		Per Q6.3 ratificado: lifecycle cíclico first-class para governance/
		control aggregates (agg-mechanism-mutation-governance + agg-mechanism-
		governance-mutation-control); tq-dmg-05 reachability satisfied por
		construction.

		Cross-aggregate state dependencies (adr-055): 19/36 invariants declare
		dependsOnAggregateState canonical = ~53% NIM canonical signature
		(META-constitutional natureza estruturalmente exige cross-agg
		enforcement) per Q3.1.C.2 ratificado.

		Behavior-first ordering preserved (PG canonical tq-dmg-02) sob
		Ontological Admissibility upstream constraints.

		=============================================================================
		FOUNDER AJUSTES PRESERVED LITERAL (~50+ across Phase 3.0-3.4)
		=============================================================================

		Phase 3.0 charter: Sections 1-6 batch-by-batch com ~30+ ajustes
		ratificados; 3 canonical phrases preserved literal.

		Phase 3.1: events (33) + commands (18) + invariants (36) batch-by-
		batch com ~18 ajustes ratificados; Q3.1.A Group 3 payload obrigatório
		canonical preserved; Q3.1.B.4 + Q3.1.B.5 + Q3.1.B.6 ratificados
		consumer/visibility/source enum.

		Phase 3.2 VOs: 25 (per Q3-final.1 inline interpretability-class-value).

		Phase 3.3 aggregates: 11 (per Q3-final.2: Tier 2 NÃO aggregate; emerge
		via mechanism aggregates).

		Phase 3.4: 4 modules + 7 services (Q3-final.4 svc-execution-gating
		Gate constitucional stateless canonical) + 2 policies (Q3-final.3
		suficiente) + 10 projections + systemConsistencyModel by-aggregateRef
		(Q3-final.5) + decisionAuthorityModel hybrid (Q3-final.6).

		Phase 3.5: write single-shot consolidation per founder direction.

		=============================================================================
		PHASE 4-5 NEXT
		=============================================================================

		Phase 4 (agent-spec herda domain-model como binding building block
		substrate) + Phase 5 (governance envelope closes WI-045) próximos
		passos. Constitutional regression prevention: future phases NÃO podem
		reintroduzir Cluster E forbidden terms (recommendation, intelligent,
		unbiased, consensus, alignment) — seria regressão constitucional, NÃO
		inconsistência terminológica.
		"""
}
