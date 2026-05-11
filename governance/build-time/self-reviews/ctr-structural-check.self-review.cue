package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

ctrStructuralCheck: build_time.#SelfReviewReport & {
	reportId: "srr-ctr-structural-check"

	artifactPath:       "architecture/structural-checks/ctr-domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-12"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 1 (context-and-rule-identification) — CTR é
			structural-contractual versioning-heavy (per founder Tier 2
			anticipation 'shape paralelo INV structural-local + L4 forte
			versioning + post-activation immutability + lineage').

			7 invariants identificados:
			- inv-single-active-version-per-contract (RECTOR; supersession
			  determinism)
			- inv-post-activation-immutability (audit trail integrity)
			- inv-activation-requires-supervision (autonomy envelope L3
			  policy gate)
			- inv-cancellation-requires-supervision (autonomy envelope L3
			  + audit retention)
			- inv-valid-participant-qualification (NPM cross-BC active
			  qualification snapshot)
			- inv-lineage-integrity (supersession chain verifiable)
			- inv-draft-only-mutable (write-once-after-activation)

			War-game admissibility articulado per invariant. Especialmente
			forte: sc-ctr-01 single-active version é supersession
			determinism foundation (replay determinism downstream depende
			disso); sc-ctr-02 post-activation immutability é audit trail
			integrity (Lei 12.846 + CVM 5yr retention).

			Behavioral non-applicability: NENHUM invariant é behavioral
			puro. inv-03/inv-04 (activation/cancellation requires
			supervision) poderiam parecer behavioral MAS structurally
			enforceable via runtime gate (refuse activation/cancellation
			sem supervisorApprovalRef embedded).

			4 founder ajustes Section 1 incorporados:
			(1) sc-ctr-01 add RE-VAL Yes (single-active drift via clock
			    skew/partial activation/supersession race é real risk;
			    periodic audit detect orphan active versions)
			(2) sc-ctr-05 add L7 (qualification snapshot embedded DEFINES
			    participant authority scope at contract creation time;
			    re-validation scope per-participant per-contract-version)
			(3) sc-ctr-07 add RE-VAL Yes (draft-only-mutable depends on
			    state transition discipline; periodic audit detect drafts
			    edited post-activation via clock drift or migration bug)
			(4) Header naming precision: "6 layers ativos + RE-VAL
			    orthogonal dimension" (não "7 layers" — RE-VAL is NOT a
			    layer; é dimension perpendicular per ADR-086 D7)
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 2 (rule-composition) — 7 sc-ctr-* rules com DISCAP
			block per ADR-086 D2..D6 application.

			Per rule composição: 8 fields obrigatórios + assertion
			formal logic + coverage flags + runtimeGap + forbidden
			patterns + DISCAP block.

			Final layer assignments + coverage + RE-VAL:
			- sc-ctr-01 single-active-version-per-contract:
			  L1+L2+L4 / F/T/T / RE-VAL Yes
			- sc-ctr-02 post-activation-immutability:
			  L1+L4 / T/T/T / RE-VAL Yes
			- sc-ctr-03 activation-requires-supervision:
			  L1+L2+L7 / F/T/T / RE-VAL No
			- sc-ctr-04 cancellation-requires-supervision:
			  L1+L2+L4+L7 / F/T/T / RE-VAL Yes
			- sc-ctr-05 valid-participant-qualification:
			  L3+L5+L7 / F/T/T / RE-VAL No
			- sc-ctr-06 lineage-integrity:
			  L2+L3+L4 / F/T/T / RE-VAL Yes
			- sc-ctr-07 draft-only-mutable:
			  L1+L2+L4 / T/T/T / RE-VAL Yes

			Layer distribution validation:
			- L1: 5 rules (01/02/03/04/07)
			- L2: 5 rules (01/03/04/06/07)
			- L3: 2 rules (05/06) — cross-BC NPM + supersession refs
			- L4 DOMINANT: 5 rules (01/02/04/06/07) — versioning +
			  write-once + supersession lineage
			- L5: 1 rule (05) — qualification freshness
			- L6: 0 rules — interpretation coherence not pressed in CTR
			- L7: 3 rules (03/04/05) — decision authority scope
			  (supervision + qualification snapshot)
			- RE-VAL DOMINANT: 5 rules (01/02/04/06/07) — drift +
			  immutability audit + lineage audit

			CTR distinct shape: L4 DOMINANT (5/7) + RE-VAL DOMINANT
			(5/7) + L6 ABSENT confirma CTR é versioning-heavy contractual.
			Cada contrato carrega lineage + write-once-after-activation
			+ supersession determinism + supervision autonomy gates.

			L6 absent reflete CTR não ter interpretation coherence
			pressure (vs SSC sc-ssc-07 Goodhart vector OR DLV sc-dlv-06
			replay retryPath determinism). CTR contractual immutability é
			puro structural-temporal, não semantic interpretation.

			L8 NÃO invocado — existing ladder L1+L2+L3+L4+L5+L7 +
			RE-VAL suficiente para versioning-heavy shape.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 3 (validation-and-meta) — finalValidation steps
			executed per PG structural-check.

			Schema satisfaction verified:
			- Todas 7 rules têm 8 campos obrigatórios preenchidos
			- kind: domain-invariant em todas
			- rule sub-schema #DomainInvariantRule conforme
			- assertion formal logic ∀⇒∧ presente per rule
			- coverage struct at-least-one-true em todas
			- runtimeGap presente quando runtimeRequired=true (7/7
			  rules com runtimeRequired=true; 7/7 runtimeGap completo)
			- forbidden patterns state/property prohibitions
			- errorMessage 3-part acionável em todas

			DISCAP compliance (per ADR-086 + PG patch WI-076):
			- tq-scg-04 (D2 layer applicability): 7/7 rules declaram
			  applicable layers + non-applicable rationale
			- tq-scg-05 (D3 coverage flags): 7/7 declared
			- tq-scg-06 (D4 runtimeGap): 7/7 runtimeRequired complete
			- tq-scg-07 (D5 war-game evidence): 7/7 articulated
			- tq-scg-08 (D6 behavioral non-applicability): header
			  declares structurally enforceable; nenhum behavioral puro

			cue vet ./... EXIT=0; cue vet -c ./... EXIT=0.

			Tamanho file: ~750 linhas (proporcional 7 rules vs SSC 7;
			peak rule sc-ctr-06 lineage-integrity com cross-version
			supersession chain coherence).

			Cascade complete (Tier 1 + 2 Tier 2 BCs): INV (retroactive)
			+ REW (retroactive) + CMT (forward) + DLV (forward) + SSC
			(forward) + CTR (forward). 6 BCs com structural-check
			DISCAP-conformant.

			Pattern transferable validated: CTR shape diferente de SSC
			(L7 dominant decision-context) E diferente de DLV (L2
			dominant structural-rich) MAS same ladder progressive —
			confirms ladder selective per BC nature. CTR é prova final
			que L4+RE-VAL podem dominar quando BC é versioning-heavy
			contractual (post-activation immutability + supersession).
			"""
	}]

	findings: {}

	summary: """
		CTR structural-check (sc-ctr-01..07) — quarta aplicação
		DISCAP-guided forward authoring per ADR-086 + PG patch WI-076.

		7 rules cobrindo 7 invariants CTR domain-model:
		single-active-version-per-contract (RECTOR; supersession
		determinism) + post-activation-immutability (audit trail
		integrity Lei 12.846/CVM 5yr) + activation-requires-supervision
		(L3 autonomy gate) + cancellation-requires-supervision
		(L3 autonomy + audit retention) + valid-participant-
		qualification (NPM cross-BC snapshot) + lineage-integrity
		(supersession chain) + draft-only-mutable (write-once).

		CTR severity tier ALTO: contractual immutability + supersession
		determinism + Lei 12.846 audit retention + cross-BC NPM
		qualification snapshot + autonomy envelope L3 supervision
		gates (activation/cancellation).

		Layer matrix shape: **structural-contractual versioning-heavy**
		com L4 DOMINANT (5/7 rules) + RE-VAL DOMINANT (5/7 rules) +
		L6 ABSENT:
		- L1: 5 rules / L2: 5 rules / L3: 2 rules (cross-BC NPM +
		  supersession refs) / L4: 5 rules DOMINANT (versioning +
		  write-once + lineage) / L5: 1 rule (qualification freshness) /
		  L6: 0 rules (interpretation coherence não pressed) / L7:
		  3 rules (supervision + qualification authority) /
		  RE-VAL: 5 rules DOMINANT

		CTR vs 5 BCs antes autorados pos-DISCAP:
		- INV: L1/L2/L4 (structural-local)
		- CMT: L1+L2+L3+L4+L5+L6+L7 (cross-BC mid-band)
		- DLV: 8 layers (L2 dominant) — structural-rich bridge
		- SSC: 8 layers (L7 dominant) — semantic+cross-BC+anti-Goodhart
		- CTR: **6 layers ativos + RE-VAL orthogonal** (L4+RE-VAL
		  dominant) — versioning-heavy contractual
		- REW: L5/L6/L7 (semantic-contextual)

		Behavioral non-applicability: NENHUM puro; todos structurally
		enforceable. sc-ctr-03/04 (supervision requirements) enforced
		via runtime gate (supervisorApprovalRef embedded refuse
		activation/cancellation absent).

		L8 NÃO invocado per founder anticipation. L6 ABSENT reflete
		CTR não ter interpretation coherence pressure — contractual
		immutability é puro structural-temporal, não semantic.

		3 rounds executed (Section 1 + 2 + 3); 4 founder ajustes
		incorporados pre-write (Section 1). cue vet ./... EXIT=0.

		Cascade DISCAP forward application progress: INV (retroactive
		WI-077) → REW (retroactive WI-078) → CMT (WI-079 forward) →
		DLV (WI-080 forward) → SSC (WI-081 forward) → CTR (WI-082
		forward). 6 BCs DISCAP-conformant. 4 BCs pending (P2P Tier 2
		+ BDG/IDC/NPM Tier 3 per founder priority; IDC/NPM precisam
		D-expansion antes).

		Pattern transferable empirically validated: forward authoring
		FROM SCRATCH produces BC-specific layer matrix matching BC
		epistemological nature; CTR confirma L4+RE-VAL podem dominar
		quando shape é versioning-heavy contractual; L6 pode estar
		ABSENT quando interpretation coherence não pressed; no new
		layer required despite contractual immutability + supersession
		determinism complexity.
		"""
}
