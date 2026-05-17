package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// ctr-domain-model.cue — Structural checks para CTR domain-model.
// Per ADR-080: kind 'domain-invariant' unifica filesystem + semantic
// enforcement. 7 invariants do contexts/ctr/domain-model.cue declarados
// como garantias com limites explícitos.
//
// WI-082 QUARTA APPLICATION DISCAP-GUIDED forward authoring (per
// ADR-086 + PG patch WI-076; follows CMT WI-079 + DLV WI-080 + SSC
// WI-081). Tier 2 BC second.
//
// CTR severity tier ALTO: base jurídica para CMT commitments + SCF
// eligibility cascade; reconstituição temporal regulatória (Lei NF-e
// histórico) + Lei 12.846 anti-corruption audit; cancellation
// terminal+irreversible afeta compromissos downstream.
//
// Coverage distribution (7 checks):
// - 2 schema-enforced + runtime (02/07) — T/T/T (CUE state machine +
//   lifecycle declares write-once + enum)
// - 5 runtime-required com runtimeGap declarado canonicamente
//   (01/03/04/05/06)
// - All 7 com validation-time advisory (audit + cross-instance lint)
//
// Layer matrix demonstra DISCAP progressive ladder seletivo:
// - L1: 5 rules (01/02/03/04/07) — state fields + supervision events
// - L2: 5 rules (01/03/04/06/07) — cross-field cardinality + transitions
//   + lineage
// - L3: 2 rules (05/06) — NPM cross-BC + lineage refs (MINIMAL vs
//   CMT/DLV/SSC)
// - L4 DOMINANT: 5 rules (01/02/04/06/07) — versioning + write-once +
//   lineage + terminal immutability (anticipated by founder)
// - L5: 1 rule (05) — NPM freshness at registration (single-point,
//   não dual-moment like SSC)
// - L6: 0 rules — CTR é structural-mechanical SEM interpretation
//   coherence step (distinct from CMT/REW/SSC)
// - L7: 3 rules (03/04/05) — P10 supervision decision context +
//   participant qualification decision scope
// - RE-VAL: 5 rules (01/02/04/06/07) — periodic audit defense
//   (cardinality drift + immutability drift + cancellation reversal +
//   lineage branching + draft-only drift)
//
// 6 layers ativos + RE-VAL orthogonal dimension (per founder naming
// precision ajuste — RE-VAL NÃO é layer; é dimensão temporal de
// revalidação).
//
// CTR distinct shape: **structural-contractual versioning-heavy** com
// L4 DOMINANT (5/7) + RE-VAL DOMINANT (5/7 — drift defense central).
// Paralelo INV (structural-local) MAS com L4 + L7 (supervision gates)
// + RE-VAL fortes. Distinto de CMT (cross-BC mid-band) + DLV (bridge)
// + SSC (decision-context-heavy) + REW (semantic-contextual).
//
// Comparação ladder cross-BCs (empirical validation post 5 BCs):
// - INV: L1/L2/L4 (structural-local baseline)
// - CMT: L1+L2+L3+L4+L5+L6+L7 — cross-BC mid-band
// - DLV: 8 layers (L2 dominant) — structural-rich bridge
// - SSC: 8 layers (L7 dominant) — semantic+cross-BC+anti-Goodhart
// - CTR: 6 layers + RE-VAL (L4 dominant, RE-VAL dominant) —
//   versioning-heavy contractual
// - REW: L5/L6/L7 (semantic-contextual)
//
// CTR é o BC menos broad em layers (6 vs 7-8 dos outros pos-DISCAP)
// MAS com RE-VAL strongest pattern observed — confirma DISCAP ladder
// seletivo. Versioning-heavy contractual nature: drift over time é
// THE primary defense concern (periodic audits catch drift patterns
// invisíveis em snapshot checks).
//
// L8 NÃO invocado — existing ladder sufficient. CTR pressure não
// revelou new layer.
//
// Behavioral non-applicability discipline (per adr-086 D6):
// CTR domain-model 7 invariants são TODAS structurally enforceable.
// Supervision gates (03/04) são structural authorization event presence
// + state-transition consistency. Sem invariants behavioral pure.
//
// Forbidden patterns são state/property prohibitions (não actions —
// per founder lint pattern).

structuralChecks: "sc-ctr-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-ctr-01"
	title:        "Single Active Version domain invariant"
	artifactType: "domain-model"
	description: """
		Para um mesmo contrato+escopo, exatamente UMA versão de termos pode estar no estado 'active' simultaneamente. Ativação de nova versão automaticamente supersede a anterior. Ambiguidade sobre qual versão é vigente criaria disputas irresolvíveis em DRC, precificação incorreta em SCF e referência ambígua em CMT.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: state field populated em ContractTermsVersion
		- L2 CROSS-FIELD: cardinality constraint (at most one active per contract+scope)
		- L4 VERSIONED: supersession chain monotonic (activating new version supersedes previous)

		Layers non-applicable: L2.5, L3, L5, L6, L7
		Non-applicability rationale: invariant é structural cardinality + versioning local; sem adoption proof binding, sem cross-BC contract resolution (cardinality é intra-CTR), sem freshness drift, sem interpretation coherence step, sem decision context scaling.

		RE-VAL: Yes — periodic cardinality audit catches: (a) race conditions concurrent activation; (b) manual DB repair operations bypassing aggregate guard; (c) migration drift introducing multiple active; (d) silent cardinality breach via direct state mutation.

		War-game evidence (per adr-086 D5):
		Concurrent activation paths produce 2 active versions silently — primary activation API + scheduled batch + manual override pathway race; aggregate guard fails to detect concurrent activation; both versions land in 'active' state for same (contract+scope); DRC dispute resolution faces irresolvable ambiguity ("which terms governed at date X?"); SCF references ambiguous version for pricing; CMT commitment references one version while system shows two active; cross-BC reconciliation cascade fails.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-single-active-version"
		assertion: """
			∀ (contractRef, scope):
			  count(ContractTermsVersion where
			    Version.contractRef == contractRef
			    ∧ Version.scope == scope
			    ∧ Version.state == 'active'
			  ) ≤ 1
			∧ activation of new version triggers automatic supersession
			    of previous active version (transactional)
			∧ supersession chain monotonic (no branching)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cross-instance cardinality cannot be enforced em build-time CUE schema; persistence layer atomic operation + aggregate guard pre-activation are runtime concerns."
			enforcedBy:  "aggregate guard pre-activation (verify no other active version for same (contract, scope) before transitioning) + persistence layer atomic operation (transactional state change with cardinality check) + RE-VAL periodic cardinality audit catching drift via race/migration/manual repair"
		}
		forbidden: [
			"two ContractTermsVersion instances in 'active' state for same (contract, scope)",
			"activation without automatic supersession of previous active",
			"branching supersession chain (multiple versions claim same supersession parent)",
			"silent cardinality breach via direct DB state mutation bypassing aggregate",
		]
	}
	errorMessage: "domain-invariant inv-single-active-version: multiple active versions detected for same (contract, scope) OR supersession chain branched OR aggregate guard bypassed. Ambiguidade vigente é irresolvível em DRC + SCF pricing + CMT reference. Verifique aggregate guard pre-activation + atomic persistence + RE-VAL periodic cardinality audit."
	rationale:    "Materializa bd-single-active-version + cross-BC cascade discipline (DRC dispute resolution + SCF pricing + CMT commitment references). RE-VAL essential per founder ajuste — drift patterns (race + repair + migration + manual) detectable apenas via periodic audit; defense-in-depth contra aggregate guard bypass."
}

structuralChecks: "sc-ctr-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-ctr-02"
	title:        "Post-Activation Immutability domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhum campo de uma versão de termos pode ser alterado após transição para estado 'active'. Qualquer mudança requer RegisterTermsRevision que cria nova versão em draft. Imutabilidade garante reconstrução temporal e auditoria regulatória.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: state field populated (active vs draft)
		- L4 VERSIONED: write-once discipline post-active (immutability)

		Layers non-applicable: L2, L2.5, L3, L5, L6, L7
		Non-applicability rationale: invariant é write-once discipline structural-local; cross-field não aplica (single-version immutability); sem adoption proof binding, contract resolution, freshness drift, interpretation coherence step, decision context scaling.

		RE-VAL: Yes — periodic immutability audit catches: (a) maintenance scripts editing active version "to fix typo"; (b) migration drift mutating active versions in-place; (c) silent field updates bypassing aggregate write-once guard.

		War-game evidence (per adr-086 D5):
		Maintenance script edits active version "to fix typo" — operational team encounters customer report of typo in active terms; DBA convenience runs UPDATE directly on active version bypassing RegisterTermsRevision flow; regulatory reconstruction of "quais termos estavam vigentes na data X" becomes impossible (version now reflects post-typo content but timestamp shows pre-edit); Bacen audit + Lei NF-e ≥5yr retention compromised; potential Lei 12.846 corruption probe exposes inability to reconstruct historical contractual obligation.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-post-activation-immutability"
		assertion: """
			∀ ContractTermsVersion:
			  Version.state ∈ {active, superseded, expired, cancelled}
			    ⇒ all fields write-once (no in-place mutation)
			∧ mutations require RegisterTermsRevision creating new draft version
			∧ persistence layer enforces write-once constraint
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "CUE schema declares state machine + lifecycle write-once semantics build-time; validation lint catches post-hoc mutation patterns; runtime persistence layer atomic write-once constraint."
			enforcedBy:  "CUE schema declares state machine + lifecycle write-once per state + persistence layer write-once constraint on non-draft states + aggregate guard rejects mutation commands on non-draft + RE-VAL periodic immutability audit comparing version snapshots over time"
		}
		forbidden: [
			"fields mutated em ContractTermsVersion with state != 'draft'",
			"direct DB UPDATE bypassing RegisterTermsRevision flow",
			"maintenance script editing active/superseded/expired/cancelled versions",
			"silent field updates without new draft version emission",
		]
	}
	errorMessage: "domain-invariant inv-post-activation-immutability: mutation detected em non-draft ContractTermsVersion OR direct DB update bypassing RegisterTermsRevision. Reconstrução temporal regulatória broken (Bacen + Lei NF-e ≥5yr + Lei 12.846). Verifique persistence write-once + aggregate guard + RE-VAL immutability audit."
	rationale:    "Materializa bd-terms-immutability. L4 captura write-once core. RE-VAL essential per founder ajuste — maintenance scripts + migration drift são real risks bypassing aggregate guards; periodic audit é defense-in-depth detecting historical record corruption."
}

structuralChecks: "sc-ctr-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-ctr-03"
	title:        "Activation Requires Supervision (P10 gate) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhuma versão de termos transiciona de 'draft' para 'active' sem autorização de supervisão humana. Agente prepara e recomenda; gate de supervisão autoriza. Ativação cria base jurídica para compromissos em CMT e elegibilidade em SCF.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: SupervisionApproval event present em event log para activation transition
		- L2 CROSS-FIELD: state-transition event references SupervisionApproval.id (consistency)
		- L7 DECISION CONTEXT: activation decision scope — creates legal basis for CMT commitments + SCF eligibility cascade (decision affects multiple downstream BCs)

		Layers non-applicable: L2.5, L3, L4, L5, L6
		Non-applicability rationale: invariant é P10 gate enforcement structural; sem adoption proof binding, sem cross-BC contract resolution (supervision é intra-CTR), sem version dependency (approval é point-in-time), sem freshness drift, sem interpretation coherence step.

		RE-VAL: N/A (P10 gate é point-in-time authorization; once approved, immutable em event log).

		War-game evidence (per adr-086 D5):
		Automated activation via agent — agent prepares draft version + recommends activation; without P10 gate enforcement, transition draft → active fires unilaterally without SupervisionApproval; downstream CMT/SCF cascade triggered (CMT commitments become possible against newly active terms; SCF eligibility recomputed); no human accountability for legal-basis creation; potential Lei 12.846 anti-corruption exposure (autonomous high-impact decision in regulated context).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-activation-requires-supervision"
		assertion: """
			∀ state transition from 'draft' to 'active':
			  ∃ SupervisionApproval(versionId, action='activate-contract-terms')
			∧ state transition event references SupervisionApproval.id
			∧ no autonomous transition draft → active permitted
			    (agent recommendation alone is NOT sufficient)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Aggregate guard pre-activation requires runtime SupervisionApproval event presence + reference resolution. Build-time não vê event log; validation-time lint cross-instance catches activations without supervision reference."
			enforcedBy:  "aggregate state-machine guard pre-activation (P10 gate — refuse transition sem SupervisionApproval resolvable) + event log auditor (validation-time advisory) + agent autonomy boundary (cst-activation-blocked-without-approval em agent-spec constraints)"
		}
		forbidden: [
			"state transition draft → active sem SupervisionApproval event correspondente",
			"agent autonomously activating contract terms (sem human gate)",
			"SupervisionApproval reference ausente em state-transition event",
			"SupervisionApproval reference pointing to non-existent OR revoked authorization",
		]
	}
	errorMessage: "domain-invariant inv-activation-requires-supervision: state transition draft → active sem SupervisionApproval OR supervisionApprovalRef ausente em transition event. P10 exige gate humano para activation (afeta cascade CMT/SCF). Verifique aggregate guard pre-activation + agent autonomy boundary."
	rationale:    "Materializa P10 + canvas supervisedDecision classification (activate-contract-terms). L7 captura decision context: activation creates legal basis cascade downstream (CMT commitments + SCF eligibility). Pattern paralelo a sc-cmt-04 (suspension) + sc-cmt-05 (cancellation supervision gates)."
}

structuralChecks: "sc-ctr-04": artifact_schemas.#StructuralCheck & {
	id:           "sc-ctr-04"
	title:        "Cancellation Requires Supervision (terminal + irreversible) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhuma versão de termos transiciona para estado 'cancelled' sem supervisão humana. Cancelamento é terminal e irreversível — afeta compromissos existentes downstream (CMT commitments referencing cancelled terms; SCF eligibility revoked).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: CancellationApproval event present em event log
		- L2 CROSS-FIELD: state-transition event references CancellationApproval.id + no transition from 'cancelled' to any other state
		- L4 VERSIONED: post-cancellation immutability (terminal state write-once)
		- L7 DECISION CONTEXT: irreversibility decision context (cascade impact CMT commitments + SCF eligibility + reversibilityThreshold satisfied)

		Layers non-applicable: L2.5, L3, L5, L6
		Non-applicability rationale: invariant é terminal state + supervision enforcement; sem adoption proof, cross-BC resolution (cancellation é intra-CTR), freshness drift, interpretation coherence step.

		RE-VAL: Yes — periodic audit catches reversal attempts (state transitions FROM 'cancelled' OR mutations post-cancel) + suspicious patterns flagged for compliance review.

		War-game evidence (per adr-086 D5):
		Cancellation reversal via "fix mistake" operation — operational team receives report that contract terms were cancelled mistakenly; DBA convenience flips state cancelled → active via direct SQL bypassing aggregate guard; downstream CMT commitments already saw cancelled state and triggered fallback flows; SCF eligibility already revoked; reversal creates inconsistent cross-BC state (CTR shows active; CMT/SCF show cancelled-context); reconciliation impossible + audit trail broken + Bacen compliance exposure (reversibilityThreshold violated).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-cancellation-requires-supervision"
		assertion: """
			∀ state transition to 'cancelled':
			  ∃ CancellationApproval(versionId, action='cancel-contract-terms')
			∧ state transition event references CancellationApproval.id
			∧ no transition FROM 'cancelled' state to any other state
			∧ Version fields write-once post-cancellation
			∧ no autonomous transition to 'cancelled' permitted
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Multi-layer enforcement: aggregate guard pre-cancel + state machine no-transition-from-cancelled + persistence write-once + command handler reject post-cancel commands. Build-time pode declarar state machine; runtime enforces full discipline."
			enforcedBy:  "aggregate guard pre-cancel (CancellationApproval reference required) + state machine no-transition-from-cancelled (lifecycle declared) + persistence write-once constraint post-cancel + command handler reject post-cancel commands + RE-VAL periodic audit catching reversal attempts"
		}
		forbidden: [
			"state 'cancelled' sem CancellationApproval event correspondente",
			"state transition FROM 'cancelled' to any other state (reversal)",
			"Version fields mutated post-cancellation",
			"autonomous cancellation by agent (sem human gate)",
			"CancellationApproval reference pointing to non-existent OR revoked authorization",
		]
	}
	errorMessage: "domain-invariant inv-cancellation-requires-supervision: cancellation reversal detected OR CancellationApproval ausente OR mutation post-cancel. Cancelamento é terminal+irreversible per reversibilityThreshold. Verifique aggregate guard + state machine no-transition-from-cancelled + persistence write-once + RE-VAL periodic audit."
	rationale:    "Materializa reversibilityThreshold + P10 supervision. L4 captura write-once post-cancel; L7 captura irreversibility decision context (cascade CMT/SCF impact + regulatory significance). Pattern paralelo sc-cmt-05 (cancellation-irreversible). RE-VAL essential — DBA convenience operations bypass aggregate guards em practice."
}

structuralChecks: "sc-ctr-05": artifact_schemas.#StructuralCheck & {
	id:           "sc-ctr-05"
	title:        "Valid Participant Qualification (NPM cross-BC) domain invariant"
	artifactType: "domain-model"
	description: """
		Registro de termos contratuais só é aceito se todas as partes referenciadas existem e estão qualificadas em NPM. Validação sync via QueryParticipantStatus no momento de registro. Termos com partes não qualificadas são risco jurídico.

		Layers ativos (per adr-086 D2):
		- L3 RESOLVABLE CONTRACT: NPM cross-BC sync query via QueryParticipantStatus (NPM single-owner qualification per dp-04)
		- L5 FRESHNESS HEURISTIC: qualification checked AT registration time (single-point freshness, não dual-moment como SSC sc-ssc-03)
		- L7 DECISION CONTEXT: participant qualification decision scope — registrar termos com participante desqualificado cria consequência jurídica/econômica downstream (CMT commitments + SCF eligibility based on terms involving disqualified party)

		Layers non-applicable: L1, L2, L2.5, L4, L6
		Non-applicability rationale: invariant é cross-BC validation + decision context; presence + cross-field structures covered em other rules; sem adoption proof binding, sem version dependency (qualification é binary status), sem interpretation coherence step (status é binary consume).

		RE-VAL: N/A (CTR registration é single-point validation, NÃO continuous re-validation like SSC). Drift entre registration e activation NÃO é structural concern do CTR — handled separately if needed.

		War-game evidence (per adr-086 D5):
		NPM status drift between draft creation and activation — party qualified at registration draft creation; weeks pass during draft refinement; party downgraded in NPM (KYC re-validation fails OR added to sanctions); activation proceeds without re-check; terms registered+activated com unqualified party; CMT commitments become possible against terms involving disqualified entity; legal risk + Bacen audit exposes regulatory gap; potential Lei 12.846 corruption probe.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-valid-participant-qualification"
		assertion: """
			∀ ContractTermsVersion registration:
			  ∀ party in Version.parties:
			    NPM.QueryParticipantStatus(party) returns
			      'eligible-for-sourcing' OR equivalent qualified status
			∧ registration rejected if any party not qualified
			∧ qualification check via sync NPM query at registration time
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cross-BC sync query at registration time requires runtime. Build-time não vê NPM state; aggregate guard pre-registration MUST execute NPM query for each party + reject if any not qualified."
			enforcedBy:  "aggregate guard pre-registration (sync query NPM.QueryParticipantStatus for each party in Version.parties + reject registration if any party not qualified) + event log auditor (validation-time advisory)"
		}
		forbidden: [
			"ContractTermsVersion registered com party not qualified in NPM",
			"party qualification check skipped at registration",
			"cached NPM status used at registration without sync query",
			"CTR self-validating compliance (anti-mini-NPM — NPM é single-owner per dp-04)",
		]
	}
	errorMessage: "domain-invariant inv-valid-participant-qualification: ContractTermsVersion registered com party not qualified in NPM OR qualification check skipped. NPM single-owner per dp-04; termos com partes desqualificadas são risco jurídico cascade CMT/SCF. Verifique aggregate guard pre-registration + NPM sync query."
	rationale:    "Materializa canvas autonomous decision validate-participant-qualification + dp-04 single-owner NPM. L3+L5+L7: cross-BC sync query + freshness at registration + participant qualification decision scope. Distinct from SSC sc-ssc-03 (dual-moment re-val) — CTR é registration-only single-point check; drift post-registration handled outside CTR if needed."
}

structuralChecks: "sc-ctr-06": artifact_schemas.#StructuralCheck & {
	id:           "sc-ctr-06"
	title:        "Lineage Integrity (linear chain) domain invariant"
	artifactType: "domain-model"
	description: """
		Cada versão criada por RegisterTermsRevision deve referenciar exatamente a versão anterior existente. Lineage forma cadeia linear sem gaps nem branching. Lineage é mecanismo de reconstrução temporal regulatória.

		Layers ativos (per adr-086 D2):
		- L2 CROSS-FIELD: lineage chain links cross-field consistency (predecessor.version + 1 == successor.version)
		- L3 RESOLVABLE CONTRACT: lineage predecessor reference resolves to existing version
		- L4 VERSIONED: monotonic linear versioning (no gaps, no branching, version numbers sequential)

		Layers non-applicable: L1, L2.5, L5, L6, L7
		Non-applicability rationale: presence covered em other rules; sem adoption proof binding, sem freshness drift (lineage é structural-monotonic), sem interpretation coherence step, sem decision context scaling.

		RE-VAL: Yes — periodic audit catches: (a) branching lineage (multiple versions claim same predecessor); (b) gaps in chain (version N+2 references version N skipping N+1); (c) circular references; (d) orphan versions without predecessor.

		War-game evidence (per adr-086 D5):
		Concurrent revision paths create branching lineage — two revision commands arrive concurrently from different ingestion paths (UI + API + batch); both claim same predecessor v1 → creating v2a and v2b branches; regulator cannot reconstruct evolution ("which v2 was authoritative?"); as-ctr-1 assumption "lineage linear" violated; OR gap in chain via migration script that skips a version → reconstruction impossible from chain alone.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-lineage-integrity"
		assertion: """
			∀ ContractTermsVersion V (created by RegisterTermsRevision):
			  V.predecessor references exactly one existing version V_prev
			∧ V.version == V_prev.version + 1 (sequential, no gaps)
			∧ no other version V' has V.predecessor == V_prev (no branching)
			∧ no circular references (V.predecessor chain reaches initial version)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Lineage chain integrity requires event log query + cross-reference resolution + monotonic version check. Build-time não vê chain; runtime aggregate guard pre-revision + event log auditor."
			enforcedBy:  "aggregate guard pre-revision (verify predecessor resolves + no branching + sequential version) + event log auditor (validation-time advisory) + RE-VAL periodic lineage audit catching branching/gaps/circular patterns"
		}
		forbidden: [
			"version with predecessor pointing to non-existent version",
			"branching lineage (two versions claim same predecessor)",
			"gap in chain (version N+2 references N skipping N+1)",
			"circular reference (predecessor chain doesn't reach initial version)",
			"orphan version without predecessor (when not initial)",
		]
	}
	errorMessage: "domain-invariant inv-lineage-integrity: lineage chain inconsistency detected (branching OR gap OR circular OR orphan). as-ctr-1 assume lineage linear — regulatory temporal reconstruction depends on chain integrity. Verifique aggregate guard pre-revision + RE-VAL periodic lineage audit."
	rationale:    "Materializa as-ctr-1 + reconstrução temporal regulatória. L2+L3+L4 captura cross-field chain + reference resolution + monotonic versioning. RE-VAL essential per founder ajuste — concurrent revision paths + migration scripts são real risks detectable apenas via periodic chain audit."
}

structuralChecks: "sc-ctr-07": artifact_schemas.#StructuralCheck & {
	id:           "sc-ctr-07"
	title:        "Draft Only Mutable (state machine closure) domain invariant"
	artifactType: "domain-model"
	description: """
		Somente versões em estado 'draft' aceitam mutação in-place de seus campos. Versões em 'active', 'superseded', 'expired' e 'cancelled' são imutáveis. cmd-register-terms-revision não viola esta invariante: cria nova versão em draft, sem alterar a versão existente.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: state field populated em ContractTermsVersion
		- L2 CROSS-FIELD: state-transition gate (mutation allowed only when state=draft)
		- L4 VERSIONED: write-once discipline post-draft (corollary of post-activation-immutability extended a todos non-draft states)

		Layers non-applicable: L2.5, L3, L5, L6, L7
		Non-applicability rationale: invariant é state machine + write-once corollary; sem adoption proof binding, sem cross-BC contract resolution, sem freshness drift, sem interpretation coherence step, sem decision context scaling.

		RE-VAL: Yes — periodic audit catches: (a) mutations em non-draft versions (paralelo sc-ctr-02 mas at state-transition level); (b) silent drift bypassing aggregate guard.

		War-game evidence (per adr-086 D5):
		Mutation em active/superseded/expired version via "edit in place" — downstream CMT/SCF see modified terms without new version emit; corollary of sc-ctr-02 (post-activation-immutability) at state-transition level; same root pattern but caught at mutation attempt rather than post-mutation; redundant defense layer ensures both points have structural enforcement.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-draft-only-mutable"
		assertion: """
			∀ ContractTermsVersion V:
			  V.state != 'draft' ⇒ no field mutation allowed in-place
			∧ V.state == 'draft' allows field mutation via cmd-update-terms-draft
			∧ cmd-register-terms-revision creates new draft version
			    (NOT mutate existing)
			∧ state machine declares transition table preventing mutation
			    on non-draft states
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "CUE schema declares state enum + transition table build-time; validation lint catches mutation patterns em event log; runtime aggregate guard rejects mutation commands on non-draft states."
			enforcedBy:  "CUE schema declares state enum {draft, active, superseded, expired, cancelled} + transition table allows mutation only on draft + aggregate command handler reject mutations em non-draft + persistence layer write-once constraint + RE-VAL periodic immutability audit"
		}
		forbidden: [
			"mutation in-place em ContractTermsVersion com state != 'draft'",
			"cmd-update-terms-draft applied to non-draft version",
			"cmd-register-terms-revision mutating existing version (instead of creating new draft)",
			"state machine declaration permitting mutation on non-draft state",
		]
	}
	errorMessage: "domain-invariant inv-draft-only-mutable: mutation attempt em non-draft ContractTermsVersion OR state machine permitting non-draft mutation. Corollary of post-activation-immutability — único ponto de mutação é antes da ativação. Verifique CUE state machine + aggregate command handler + RE-VAL audit."
	rationale:    "Materializa corollary de inv-post-activation-immutability extended a todos non-draft states. L4 dominant — write-once é central discipline. Coverage T/T/T: CUE schema state enum + transition table build-time; aggregate + persistence runtime. RE-VAL essential per founder ajuste — paralelo a sc-ctr-02 drift pattern detection."
}
