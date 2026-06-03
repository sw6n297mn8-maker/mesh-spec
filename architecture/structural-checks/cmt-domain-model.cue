package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// cmt-domain-model.cue — Structural checks para CMT domain-model.
// Per ADR-080: kind 'domain-invariant' unifica filesystem + semantic
// enforcement. 8 invariants do contexts/cmt/domain-model.cue declarados
// como garantias com limites explícitos (runtime-gap canonicalmente
// declarado quando runtimeRequired=true).
//
// WI-079 PRIMEIRA APPLICATION DISCAP-GUIDED forward authoring (per
// ADR-086 Domain-Invariant Structural Check Authoring Protocol + PG
// patch WI-076). Pattern paralelo a INV/REW pos-DISCAP-retroactive-
// patch, mas autorado FROM SCRATCH com protocol canonical aplicado
// — não retroactive backfill.
//
// CMT severity tier ALTO: Bacen credit scrutiny + cascade CMT →
// BDG/DLV/INV/FCE; commitment é root das obligation chains downstream.
//
// Coverage distribution (8 checks):
// - 2 fully build-time + runtime (lifecycle terminality + identity
//   uniqueness via CUE schema constraint + state machine declaration)
// - 6 com runtime-gap declarado canonicamente (bilateral acceptance;
//   terms reference cross-BC resolution; supervision gates suspend/
//   reactivation; cancellation irreversibility; alias resolution)
// - All 8 com validation-time advisory (event log analysis + cross-
//   instance lint + cross-BC reconciliation)
//
// Layer matrix demonstra DISCAP progressive ladder seletivo (per
// founder observation empirical validation):
// - sc-cmt-01 (bilateral-acceptance): L1+L2+L6 — interpretation
//   coherence cross-party
// - sc-cmt-02 (terms-reference-valid): L3+L4+L5+L6 — cross-BC contract
//   resolution + version freeze + freshness + interpretation coherence
//   downstream (PEAK semantic complexity in CMT — cross-BC dependency)
// - sc-cmt-03 (commitment-id-uniqueness): L1+L2 — structural-local
// - sc-cmt-04/06 (supervision gates): L1+L2+L7 — P10 decision context
// - sc-cmt-05 (cancellation-irreversible): L1+L2+L4+L7 + RE-VAL
// - sc-cmt-07 (proposer-counterparty-distinct): L1+L2 — anti-self-
//   commitment via alias resolution
// - sc-cmt-08 (cancelled-is-terminal): L1+L2+L4 — state machine
//   terminality
//
// CMT é mid-band entre INV (puramente structural-local L1/L2/L4) e REW
// (semanticamente contextual L5/L6/L7); CMT força L3+L6 (cross-BC
// terms resolution + bilateral interpretation coherence) — ladder
// captura genuine complexity gradation.
//
// Behavioral non-applicability discipline (per adr-086 D6):
// CMT domain-model 8 invariants são TODAS structurally enforceable
// (com runtime gaps declarados onde aplicável); NENHUMA é behavioral
// pura (architectural review OR anti-corruption discipline). Pattern
// paralelo INV — quase totalmente structural com cross-BC dimension
// (CTR terms reference) adicionada.
//
// Forbidden patterns são state/property prohibitions (não actions —
// per founder lint pattern: forbidden é proibição de ESTADO ou
// PROPRIEDADE, não de ação procedural; previne reintrodução de
// orchestration implícita).

structuralChecks: "sc-cmt-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-cmt-01"
	title:        "Mutual Bilateral Acceptance domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhum compromisso transiciona para state 'accepted' sem evidência bilateral de aceite (proposer + counterparty) sobre termos idênticos. O aceite é assimétrico: o proponente confirma implicitamente via ProposeCommitment (fixando referenceTermsHash = sha256(canonical({contractTermsRef, scope}))); a contraparte confirma explicitamente via ConfirmCommitmentAcceptance carregando AcceptanceConfirmation.termsHash. 'Termos idênticos' é verificado por igualdade de hash (AcceptanceConfirmation.termsHash == referenceTermsHash), evidenciada no evt-commitment-accepted (campos termsHash + confirmedBy).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: BilateralAcceptanceEvidence both proposer + counterparty present
		- L2 CROSS-FIELD: termsRef idêntico entre proposer + counterparty evidence
		- L6 DECISION↔INTERPRETATION COHERENCE: ambas partes aceitam THE SAME interpretation of terms (não interpretação divergente do mesmo termsRef)

		Layers non-applicable: L2.5, L3, L4, L5, L7
		Non-applicability rationale: invariant é bilateral consent + interpretation coherence; sem semantic adoption binding step, sem cross-BC contract resolution (terms validity é sc-cmt-02 concern), sem version dependency (interpretation é point-in-time at acceptance), sem freshness drift, sem decision context scaling.

		RE-VAL: N/A (bilateral acceptance é point-in-time gate; once passed, immutable in event log).

		War-game evidence (per adr-086 D5):
		Unilateral acceptance via outbox failure — proposer's acceptance signal recorded; counterparty's bilateral evidence lost in outbox transactional gap; state-machine guard fails to detect missing counterparty evidence; commitment transitions to 'accepted' silently; contract obligation triggered without bilateral consent; dp-10 jurídico violation + legal liability exposure + downstream BDG/DLV/INV cascade triggered on invalid commitment.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-mutual-bilateral-acceptance"
		assertion: """
			∀ commitmentId:
			  Commitment.state == 'accepted'
			    ⇒ ∃ ProposeCommitment(commitmentId, by=proposer) fixa referenceTermsHash
			    ∧ ∃ AcceptanceConfirmation(commitmentId, confirmedBy=counterparty)
			    ∧ AcceptanceConfirmation.termsHash == referenceTermsHash
			∧ ∀ state transition to 'accepted':
			    transition event references both bilateral evidence entries
			∧ no unilateral state transition to 'accepted' permitted
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Bilateral evidence presence + termsRef coherence check requires event log query + state machine guard pre-transition. Build-time não vê event log nem state machine runtime; validation-time pode auditar cross-instance lint comparando state vs bilateral evidence presence."
			enforcedBy:  "aggregate state-machine guard pre-transition (refuse state 'accepted' sem bilateral evidence resolvable) + event log auditor (validation-time advisory comparing Commitment.state vs BilateralAcceptanceEvidence presence + termsRef coherence)"
		}
		forbidden: [
			"Commitment state 'accepted' com only one party's BilateralAcceptanceEvidence",
			"AcceptanceConfirmation.termsHash divergente do referenceTermsHash fixado no ProposeCommitment",
			"state transition to 'accepted' captured via single-party signal apenas (unilateral)",
			"BilateralAcceptanceEvidence ausente em event log para Commitment.state == 'accepted'",
		]
	}
	errorMessage: "domain-invariant inv-mutual-bilateral-acceptance: state 'accepted' atingido sem bilateral acceptance evidence completa OR com termsRef divergentes entre proposer/counterparty. dp-10 jurídico exige bilateral consent. Verifique event log para BilateralAcceptanceEvidence ambas partes + termsRef idêntico + state-machine guard pre-transition."
	rationale:    "Materializa bd-bilateral-mutual-acceptance + dp-08 (custos de manipulação excedam benefícios) + dp-10 (ambas partes juridicamente identificáveis). L6 captura que bilateral consent é interpretation coherence (não apenas presence). Per adr-142: 'termos idênticos' materializado por igualdade de termsHash (sha256 de canonical({contractTermsRef, scope})); proponente confirma implicitamente (ProposeCommitment fixa referenceTermsHash), contraparte explicitamente (AcceptanceConfirmation.termsHash); P11 mech-evidence. Runtime gap canonical porque event log + state machine guard são runtime concerns."
}

structuralChecks: "sc-cmt-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-cmt-02"
	title:        "Terms Reference Valid (cross-BC CTR resolution) domain invariant"
	artifactType: "domain-model"
	description: """
		ProposeCommitment só é aceito (compromisso nasce em 'proposed') se termsRef resolve em CTR via QueryContractTerms returning ContractTerms ativo NO MOMENTO DO PROPOSE (propose-time, fail-closed). Fail-closed: CTR sem-resposta/indisponível em propose-time ⇒ ProposeCommitment REJEITADO, nenhum compromisso criado (sem lastro verificável). Commitment.termsVersionAtProposal frozen = ContractTerms.version. SLA numérico deferido a def-046. Cross-BC dependency declarada em domain-model dependsOnAggregateState per adr-055.

		Layers ativos (per adr-086 D2):
		- L3 RESOLVABLE CONTRACT: termsRef resolve em CTR.QueryContractTerms (authoritative cross-BC contract)
		- L4 VERSIONED: Commitment.termsVersionAtProposal frozen at acceptance time
		- L5 FRESHNESS HEURISTIC: ContractTerms.status == 'active' AT acceptance time (não expired entre proposal e acceptance)
		- L6 DECISION↔INTERPRETATION COHERENCE: CMT + downstream BDG/INV interpretam mesma version de terms; downstream deprecation post-acceptance NÃO altera commitment interpretation (frozen reference)

		Layers non-applicable: L1, L2, L2.5, L7
		Non-applicability rationale: presence + cross-field cobertos em sc-cmt-01 (commitment fields); sem adoption proof binding (terms são authoritative not adopted); sem decision context scaling (terms validity é binary cross-BC check, não contextual scope).

		RE-VAL: Yes — periodic audit re-validates termsVersionAtProposal frozen vs actual ContractTerms version history; cross-BC reconciliation catches terms drift post-acceptance OR retroactive ContractTerms modification.

		War-game evidence (per adr-086 D5):
		Terms expired during proposal-acceptance window — proposal references ContractTerms version=v3 status=active; counterparty review takes hours; during window, CTR deprecates v3 → activates v4 (regulatory change); counterparty accepts under v3 (read-cached) OR system silently uses v4 (drift); CMT acceptance gate doesn't detect version drift; commitment locks to expired terms; downstream BDG approves under v4 interpretation + INV emits invoice under v3 interpretation; reconciliation divergence cascade + Bacen audit gap exposes regulatory violation.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-terms-reference-valid"
		assertion: """
			∀ commitmentId:
			  Commitment.state == 'accepted'
			    ⇒ resolve(Commitment.termsRef) via CTR.QueryContractTerms
			      returns ContractTerms_resolved
			    ∧ ContractTerms_resolved.status == 'active'
			      validado em propose-time (frozen)
			    ∧ Commitment.termsVersionAtProposal == ContractTerms_resolved.version
			∧ post-acceptance:
			    Commitment.termsVersionAtProposal write-once (no drift)
			∧ downstream BDG/INV consumers reference
			    Commitment.termsVersionAtProposal (frozen)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cross-BC sync query at acceptance time + version freeze enforcement. Build-time não vê CTR state nem runtime sync query; validation-time advisory pode auditar event log post-hoc verificando termsVersionAtProposal presence + cross-BC reconciliation com CTR version history."
			enforcedBy:  "CMT agent pre-acceptance gate (sync query CTR.QueryContractTerms) + event log records frozen termsVersionAtProposal em evt-commitment-accepted + persistence write-once constraint on termsVersionAtProposal + RE-VAL periodic cross-BC reconciliation com CTR audit"
		}
		forbidden: [
			"state 'accepted' com termsRef que não resolve em CTR.QueryContractTerms",
			"ProposeCommitment criado quando CTR indisponível/timeout em propose-time (fail-open proibido)",
			"ContractTerms.status != 'active' at acceptance time (expired/deprecated)",
			"Commitment.termsVersionAtProposal ausente",
			"Commitment.termsVersionAtProposal mutated post-acceptance (drift)",
			"downstream consumer (BDG/INV) referencing CTR.current version em vez de Commitment.termsVersionAtProposal frozen",
		]
	}
	errorMessage: "domain-invariant inv-terms-reference-valid: termsRef não resolve em CTR.QueryContractTerms OR ContractTerms inativos at propose-time OR termsVersionAtProposal drift detected. Verifique CMT agent propose-time gate (sync query CTR, fail-closed) + event log para termsVersionAtProposal frozen + cross-BC reconciliation."
	rationale:    "Materializa bd-terms-validation + adr-055 cross-aggregate-state-dependency. L3+L4+L5 capturam cross-BC contract resolution + version freeze + freshness; L6 captura interpretation coherence cross-BC (CMT frozen reference vs downstream CTR.current). Runtime gap canonical porque sync query + version freeze são runtime concerns. RE-VAL essential porque CTR version history pode drift retroactively (regulatory change) e cross-BC reconciliation detecta. Per adr-142: validação movida para propose-time + fail-closed (CTR indisponível/timeout em propose-time ⇒ ProposeCommitment rejeitado); SLA numérico deferido a def-046."
}

structuralChecks: "sc-cmt-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-cmt-03"
	title:        "Commitment ID Uniqueness domain invariant"
	artifactType: "domain-model"
	description: """
		CommitmentId é único globalmente dentro do CMT. Dois compromissos NUNCA compartilham mesmo identificador. CommitmentId é fio de rastreabilidade end-to-end consumed por BDG/DLV/INV/FCE downstream.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: commitmentId field populated em Commitment + cross-BC downstream events
		- L2 CROSS-FIELD: uniqueness constraint per commitmentId value (no duplicates)

		Layers non-applicable: L2.5, L3, L4, L5, L6, L7
		Non-applicability rationale: invariant é identity-uniqueness structural-local; sem adoption proof binding, sem cross-BC contract resolution (downstream BCs consume commitmentId mas não exigem ResolvableContract semantics para uniqueness), sem version dependency, sem freshness drift, sem interpretation step, sem decision context scaling.

		RE-VAL: N/A (uniqueness é structural discipline; não evolui).

		War-game evidence (per adr-086 D5):
		ID collision via concurrent generation paths — primary API generates ID via sequence + manual ingestion via UUID + batch import via timestamp+hash; collision happens on retry scenarios; downstream BDG approves orçamento sob commitmentId X + DLV verifies entrega sob mesmo commitmentId X (different commitments merged); INV emits invoice referencing collided commitmentId; cross-BC reconciliation impossible (which commitment was the real one?); audit trail forensics broken.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-commitment-id-uniqueness"
		assertion: """
			∀ commitmentId:
			  count(Commitment where Commitment.commitmentId == commitmentId) ≤ 1
			∧ commitmentId is canonical end-to-end identifier
			    (consumed unchanged by BDG/DLV/INV/FCE downstream)
			∧ commitmentId NOT reused after cancellation
			    (cancelled commitments preserve commitmentId; new commitments get new IDs)
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Build-time pode declarar commitmentId field required + uniqueness constraint intent em domain-model schema (CUE shape declaration). Validation-time pode lint cross-instance verificando absence of collisions em event log. Runtime garantia exige persistence layer enforcement — sem isso, race conditions criam collisions invisíveis."
			enforcedBy:  "database unique constraint on commitmentId field + event log dedup ancorado em commitmentId tuple + canonical ID generation service (single point of issuance preventing concurrent collision) + validation-time lint cross-instance"
		}
		forbidden: [
			"two Commitment instances com mesmo commitmentId",
			"commitmentId reused após cancellation (recycled identity)",
			"commitmentId regenerated via retry path concurrent (collision risk)",
			"commitmentId derived from non-canonical source (UUID + sequence + hash mixed paths)",
		]
	}
	errorMessage: "domain-invariant inv-commitment-id-uniqueness: duas Commitments com mesmo commitmentId detectadas OR commitmentId reused post-cancellation. CommitmentId é fio de rastreabilidade end-to-end; duplicação quebra vínculo cross-BC (BDG/DLV/INV/FCE) + audit forensics. Verifique DB unique constraint + canonical ID generation service single-point-of-issuance."
	rationale:    "Materializa identity discipline (rationale CMT: 'CommitmentId é fio de rastreabilidade end-to-end'). Coverage T/T/T per founder ajuste: build-time declara field + uniqueness intent; validation-time lint cross-instance; runtime enforcement via persistence + ID generation service. Pattern paralelo a sc-inv-02 idempotent-issuance (ambos identity discipline)."
}

structuralChecks: "sc-cmt-04": artifact_schemas.#StructuralCheck & {
	id:           "sc-cmt-04"
	title:        "Suspension Requires Supervision (P10 gate) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhum compromisso transiciona para state 'suspended' sem SupervisionApproval event correspondente. Agent recommends suspension; gate de supervisão valida e autoriza. P10: agentes recomendam, gates determinísticos validam.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: SupervisionApproval event presente em event log para suspended transition
		- L2 CROSS-FIELD: state-transition event references SupervisionApproval.id (consistency)
		- L7 DECISION CONTEXT: suspension decision scope + magnitude (cascade impact downstream BDG/DLV/INV/FCE; financial obligation freeze)

		Layers non-applicable: L2.5, L3, L4, L5, L6
		Non-applicability rationale: invariant é P10 gate enforcement structural; sem adoption proof binding, sem cross-BC contract resolution (supervision é intra-CMT discipline), sem version dependency (approval é point-in-time), sem freshness drift, sem interpretation coherence step (approval é binary authorization).

		RE-VAL: N/A (P10 gate é point-in-time authorization; once approved, immutable in event log).

		War-game evidence (per adr-086 D5):
		Automated suspension via agent override — agent receives at-risk signal (counterparty risk; dispute received); agent recommends suspension; without P10 gate enforcement, suspension command fires unilaterally without SupervisionApproval; commitment frozen + cascade BDG/DLV/INV/FCE halt (orçamento bloqueado; entrega cancelada; invoice rejection; payment hold); no human accountability for financial impact + Bacen audit exposes autonomous high-impact decision violating regulatory framework.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-suspension-requires-supervision"
		assertion: """
			∀ commitmentId:
			  Commitment.state == 'suspended'
			    ⇒ ∃ SupervisionApproval(commitmentId, action='suspend')
			    ∧ state transition event references SupervisionApproval.id
			∧ ∀ state transition to 'suspended':
			    transition event MUST include supervisionApprovalRef field
			    pointing to existing SupervisionApproval entry
			∧ no autonomous state transition to 'suspended' permitted
			    (agent recommendation alone is NOT sufficient)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Aggregate guard pre-transition requires runtime check of SupervisionApproval event presence + reference resolution. Build-time não vê event log nem aggregate state machine runtime; validation-time pode auditar event log cross-instance verificando supervisionApprovalRef presence em state-transition events para 'suspended'."
			enforcedBy:  "aggregate state-machine guard pre-suspend (P10 gate-determinístico — refuse state transition sem SupervisionApproval resolvable) + event log auditor (validation-time advisory comparing state transitions to 'suspended' vs SupervisionApproval references) + agent autonomy boundary (cst-suspension-blocked-without-approval em agent-spec constraints)"
		}
		forbidden: [
			"state 'suspended' sem SupervisionApproval event correspondente em event log",
			"agent autonomously transitioning state to 'suspended' (sem human gate)",
			"SupervisionApproval reference ausente em state-transition event para 'suspended'",
			"SupervisionApproval reference pointing to non-existent OR resolved-revoked authorization",
		]
	}
	errorMessage: "domain-invariant inv-suspension-requires-supervision: state 'suspended' atingido sem SupervisionApproval event correspondente OR sem supervisionApprovalRef em state-transition event. P10 exige gate humano para suspensão (afeta cascade BDG/DLV/INV/FCE). Configure aggregate guard pre-suspend exigindo SupervisionApproval reference + agent autonomy boundary enforcing recommendation-not-execution discipline."
	rationale:    "Materializa P10 (architecture/design-principles.cue — agentes recomendam, gates determinísticos validam) + canvas supervisedDecision classification. L7 captura decision context (cascade impact downstream BDG/DLV/INV/FCE). Coverage F/T/T: build-time não vê P10 enforcement (gate é runtime); validation-time lint cross-instance; runtime via aggregate guard + agent boundary constraint."
}

structuralChecks: "sc-cmt-05": artifact_schemas.#StructuralCheck & {
	id:           "sc-cmt-05"
	title:        "Cancellation Irreversible (terminal + supervised) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhum compromisso transiciona para state 'cancelled' sem CancellationApproval event. Cancelamento é terminal — compromisso cancelado NÃO pode ser reativado nem ter fields mutated post-cancel. Impacto downstream (BDG/DLV/INV/FCE) exige decisão humana per reversibilityThreshold de domain-definition.cue.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: CancellationApproval event presente em event log para cancelled transition
		- L2 CROSS-FIELD: state-transition event references CancellationApproval.id + no transition from 'cancelled' to any other state
		- L4 VERSIONED: Commitment fields write-once post-cancellation (immutability discipline)
		- L7 DECISION CONTEXT: irreversibility decision context (financial impact escope cascade + reversibilityThreshold satisfied)

		Layers non-applicable: L2.5, L3, L5, L6
		Non-applicability rationale: invariant é terminal state + supervision enforcement; sem adoption proof binding, sem cross-BC contract resolution (cancellation é intra-CMT discipline), sem freshness drift (terminal é timeless), sem interpretation coherence step (cancellation é declarative state transition).

		RE-VAL: Yes — periodic audit catches reversal attempts (state transitions FROM 'cancelled' OR mutations post-cancel) + reactivation patterns flagged for compliance review.

		War-game evidence (per adr-086 D5):
		Cancellation reversal via 'fix typo' operation — operational team receives report that commitment was cancelled mistakenly; DBA convenience flips state cancelled→accepted directly via SQL update bypassing aggregate guard; downstream BDG already saw cancelled state and freed budget allocation; DLV halted delivery process; INV processed cancellation refund; reversal creates inconsistent cross-BC state (CMT shows accepted; BDG/DLV/INV show cancelled); reconciliation impossible + audit trail broken + Bacen compliance exposure (irreversible decisions per reversibilityThreshold violated).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-cancellation-irreversible"
		assertion: """
			∀ commitmentId:
			  Commitment.state == 'cancelled'
			    ⇒ ∃ CancellationApproval(commitmentId)
			    ∧ state transition event references CancellationApproval.id
			∧ no transition exists from 'cancelled' state to any other state
			∧ Commitment fields write-once post-cancellation
			    (no mutation allowed)
			∧ no commands targeting cancelled commitment accepted
			    (reactivation/suspension/risk-signal/acceptance all rejected)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Multi-layer enforcement: aggregate guard pre-cancel (supervision check), state machine no-transition-from-cancelled, persistence write-once, command handler reject post-cancel commands. Build-time pode declarar state machine transition table; validation-time lint cross-instance event log; runtime enforcement via aggregate + persistence + command handler."
			enforcedBy:  "aggregate guard pre-cancel (CancellationApproval reference required) + state machine no-transition-from-cancelled (declared em domain-model.lifecycle) + persistence write-once constraint post-cancel + command handler reject post-cancel commands + RE-VAL periodic audit catching reversal attempts"
		}
		forbidden: [
			"state 'cancelled' sem CancellationApproval event correspondente",
			"state transition FROM 'cancelled' state to any other state (reversal)",
			"Commitment fields mutated post-cancellation",
			"commands accepted targeting cancelled commitment (reactivation/suspension/risk/acceptance)",
			"CancellationApproval reference pointing to non-existent OR revoked authorization",
		]
	}
	errorMessage: "domain-invariant inv-cancellation-irreversible: cancellation reversal detected (state transition from 'cancelled' OR mutation post-cancel) OR CancellationApproval ausente em event log. Cancelamento é terminal + supervisionado per reversibilityThreshold (domain-definition.cue). Verifique state machine no-transition-from-cancelled + persistence write-once + RE-VAL periodic audit."
	rationale:    "Materializa reversibilityThreshold de domain-definition.cue + P10 supervisão. L4 captura write-once post-cancel; L7 captura irreversibility decision context (cascade impact + regulatory significance). RE-VAL essential porque DBA convenience operations bypass aggregate guards em practice — periodic audit é defense-in-depth."
}

structuralChecks: "sc-cmt-06": artifact_schemas.#StructuralCheck & {
	id:           "sc-cmt-06"
	title:        "Reactivation Requires Supervision (P10 gate; symmetric) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhum compromisso transiciona de state 'suspended' para 'accepted' sem ReactivationApproval event. Reativação restaura obrigações financeiras suspensas — simétrico com suspension (inv-suspension-requires-supervision); exige mesmo nível de supervisão humana.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: ReactivationApproval event presente em event log para reactivation transition
		- L2 CROSS-FIELD: state-transition event references ReactivationApproval.id (consistency)
		- L7 DECISION CONTEXT: reactivation decision scope + magnitude (financial obligation restoration cascade downstream)

		Layers non-applicable: L2.5, L3, L4, L5, L6
		Non-applicability rationale: paralelo a sc-cmt-04 (suspension) — invariant é P10 gate enforcement structural simétrico; sem adoption proof, cross-BC resolution, version dependency, freshness drift, interpretation coherence step.

		RE-VAL: N/A (P10 gate é point-in-time authorization).

		War-game evidence (per adr-086 D5):
		Automated reactivation post-suspension — counterparty risk signal cleared via evt-counterparty-risk-cleared; agent recommends reactivation; without P10 gate enforcement, reactivation fires unilaterally without ReactivationApproval; financial obligations restored automatically; downstream BDG re-allocates budget + DLV resumes entrega + INV resumes invoicing; original suspension was supervisor-authorized (had legitimate human intent); automated reactivation bypasses that intent + no human accountability for financial restoration + asymmetric supervision (suspended supervised but reactivated automatically) violates dp-08 manipulation discipline.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-reactivation-requires-supervision"
		assertion: """
			∀ commitmentId:
			  state transition from 'suspended' to 'accepted'
			    ⇒ ∃ ReactivationApproval(commitmentId)
			    ∧ state transition event references ReactivationApproval.id
			∧ no autonomous transition from 'suspended' to 'accepted' permitted
			    (agent recommendation alone is NOT sufficient)
			∧ symmetric discipline com sc-cmt-04 (suspension):
			    same supervision rigor for restoration of financial obligations
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Paralelo a sc-cmt-04 (suspension gate). Aggregate guard pre-reactivation requires runtime check of ReactivationApproval event presence + reference resolution. Build-time não vê event log nem aggregate state machine runtime; validation-time advisory cross-instance lint."
			enforcedBy:  "aggregate state-machine guard pre-reactivation (P10 gate-determinístico — refuse 'suspended'→'accepted' transition sem ReactivationApproval resolvable) + event log auditor + agent autonomy boundary (cst-reactivation-blocked-without-approval em agent-spec constraints)"
		}
		forbidden: [
			"state transition 'suspended'→'accepted' sem ReactivationApproval event correspondente",
			"agent autonomously reactivating commitment (sem human gate)",
			"ReactivationApproval reference ausente em state-transition event",
			"ReactivationApproval reference pointing to non-existent OR revoked authorization",
			"asymmetric supervision pattern (suspended supervised but reactivated automatically)",
		]
	}
	errorMessage: "domain-invariant inv-reactivation-requires-supervision: transição 'suspended'→'accepted' sem ReactivationApproval event correspondente. Reativação restaura obrigações financeiras + exige mesmo nível de supervisão que suspensão (simétrico). Configure aggregate guard pre-reactivation exigindo ReactivationApproval reference + symmetric supervision discipline."
	rationale:    "Materializa simetria com inv-suspension-requires-supervision (sc-cmt-04). Asymmetric supervision (suspended supervised, reactivated automatically) é vetor de manipulação dp-08 — humano autoriza suspensão para mitigar risco; automated reactivation pode reverter intent sem nova decisão consciente. L7 captura decision context (financial obligation restoration scope)."
}

structuralChecks: "sc-cmt-07": artifact_schemas.#StructuralCheck & {
	id:           "sc-cmt-07"
	title:        "Proposer Counterparty Distinct (anti-self-commitment) domain invariant"
	artifactType: "domain-model"
	description: """
		Proposer e counterparty de um compromisso devem ser organizações distintas. Auto-compromisso é inválido — bilateral commitment exige duas partes; auto-aceite anularia propósito do aceite mútuo (dp-08 manipulation vector).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: both proposer + counterparty fields populated em Commitment
		- L2 CROSS-FIELD: proposer != counterparty (identity equality across organization aliases)

		Layers non-applicable: L2.5, L3, L4, L5, L6, L7
		Non-applicability rationale: invariant é anti-self-commitment structural check; sem adoption proof binding, sem cross-BC contract resolution, sem version dependency, sem freshness drift, sem interpretation coherence step, sem decision context scaling. Alias resolution depende de identity registry runtime (sem isso, build-time literal comparison é insufficient).

		RE-VAL: N/A (anti-self-commitment é structural discipline; não evolui).

		War-game evidence (per adr-086 D5):
		Self-commitment via alias chain — single legal entity operating multiple alias accounts (legal-entity-A com subsidiaries B, C); system literal compare detects proposer=A, counterparty=B as distinct; pseudo-bilateral commitment created entre alias accounts da mesma legal entity; manipulation vector dp-08 violated (custos de manipulação NÃO excedem benefícios — self-commitment é trivially exploitable); legal liability ambíguo (mesmo CNPJ raiz); Bacen relevant pattern (legal entity manipulation via aliases).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-proposer-counterparty-distinct"
		assertion: """
			∀ commitmentId:
			  Commitment.proposer != Commitment.counterparty
			∧ identity equality is computed via alias resolution
			    (NOT literal field comparison only):
			    resolve(Commitment.proposer) via PartyResolutionService
			      returns canonical legal entity E_proposer
			    resolve(Commitment.counterparty) returns E_counterparty
			    E_proposer != E_counterparty
			∧ alias chain analysis catches:
			    same legal entity operating multiple accounts
			    subsidiary relationships sharing CNPJ raiz
			    common control patterns
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Build-time pode declarar proposer + counterparty fields required + literal inequality constraint em domain-model schema. Validation-time lint cross-instance pode check literal comparison. Runtime garantia requires alias resolution / legal-entity-identity-graph — sem isso, literal comparison é insufficient; identity registry runtime service exposes canonical legal entity per party reference."
			enforcedBy:  "build-time CUE schema constraint (literal inequality) + identity registry / party-resolution service runtime (alias chain analysis catching subsidiaries + CNPJ raiz sharing + common control) + validation-time lint cross-instance"
		}
		forbidden: [
			"Commitment.proposer == Commitment.counterparty literal (direct self-commitment)",
			"Commitment.proposer + Commitment.counterparty resolving to same canonical legal entity via alias chain",
			"Commitment.proposer + Commitment.counterparty sharing CNPJ raiz (mesma legal entity raiz)",
			"Commitment with parties under common control (controlled subsidiaries) flagged as bilateral",
		]
	}
	errorMessage: "domain-invariant inv-proposer-counterparty-distinct: proposer == counterparty OR resolvendo a mesma organização via alias chain detected. Bilateral commitment exige duas partes distintas (dp-08 anti-manipulation). Verifique party-resolution service + identity registry alias chain analysis + CNPJ raiz comparison."
	rationale:    "Materializa dp-08 (custos de manipulação excedam benefícios) — self-commitment é trivially exploitable. Coverage T/T/T per founder ajuste: build-time CUE literal inequality; validation-time lint; runtime alias resolution via identity registry / party-resolution service (sem isso, literal comparison é insufficient — vetor de manipulação aberto via alias accounts). Pattern paralelo a inv-mutual-bilateral-acceptance (sc-cmt-01) reforça bilateral discipline."
}

structuralChecks: "sc-cmt-08": artifact_schemas.#StructuralCheck & {
	id:           "sc-cmt-08"
	title:        "Cancelled is Terminal (state machine closure) domain invariant"
	artifactType: "domain-model"
	description: """
		Nenhum compromisso em state 'cancelled' aceita commands de reativação, suspensão, risk-signaling ou acceptance. State machine declara terminality via ausência de transitions FROM 'cancelled' state. Invariant explícito torna restrição auditável + legível sem interpretar grafo de transições.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: Commitment.state field populated
		- L2 CROSS-FIELD: no transition exists from 'cancelled' to any other state (state machine constraint)
		- L4 VERSIONED: terminal state immutability post-cancel (write-once)

		Layers non-applicable: L2.5, L3, L5, L6, L7
		Non-applicability rationale: invariant é state machine terminality structural; sem adoption proof binding, sem cross-BC contract resolution, sem freshness drift (terminal é timeless), sem interpretation coherence step (terminality é declarative), sem decision context scaling.

		RE-VAL: N/A (state machine terminality é structural discipline; não evolui).

		War-game evidence (per adr-086 D5):
		State machine bypass via maintenance script — operational team needs to 'restore' cancelled commitment for legal dispute resolution; bypass aggregate command handler via direct DB UPDATE state='accepted' OR migration script that doesn't respect state machine; downstream BCs already received CommitmentStateChanged event with cancelled; reconciliation breaks (CMT shows accepted; BDG/DLV/INV/FCE show cancelled); audit trail forensics broken + Bacen audit exposes inconsistency + parallel exposure to sc-cmt-05 (cancellation-irreversible) reversal vector.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-cancelled-is-terminal"
		assertion: """
			∀ commitmentId:
			  Commitment.state == 'cancelled'
			    ⇒ no state transition event exists in event log post-cancel
			∧ no commands targeting cancelled commitment accepted:
			    cmd-accept-commitment rejected
			    cmd-suspend-commitment rejected
			    cmd-reactivate-commitment rejected
			    cmd-signal-risk rejected
			∧ state machine declares no transitions from 'cancelled'
			    (lifecycle.transitions excludes any from: cancelled)
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Build-time pode declarar state machine transition table (CUE schema) com no transitions from 'cancelled' + lifecycle declaration. Validation-time lint cross-instance pode auditar event log para transitions ilegais. Runtime garantia exige aggregate command handler reject post-cancel commands + event log enforcement (no event emission para state transitions from cancelled)."
			enforcedBy:  "build-time state machine constraint (CUE enum + transition table declared em domain-model.lifecycle.transitions) + aggregate command handler reject post-cancel commands + event log enforcement (no state-transition event emission from cancelled state) + validation-time lint cross-instance"
		}
		forbidden: [
			"state transition event from 'cancelled' state to any other state",
			"command accepted targeting cancelled commitment (cmd-accept/suspend/reactivate/signal-risk)",
			"state machine declaration permitting transition from 'cancelled' (lifecycle.transitions includes from: cancelled entry)",
			"direct DB mutation of cancelled commitment state via maintenance script bypass",
		]
	}
	errorMessage: "domain-invariant inv-cancelled-is-terminal: state transition detected from 'cancelled' state OR command targeting cancelled commitment accepted. State machine declara terminality via ausência de transitions from 'cancelled'. Verifique state machine declaration + aggregate command handler reject post-cancel + event log forensics para transitions ilegais."
	rationale:    "Materializa state machine closure discipline (paralelo a sc-cmt-05 cancellation-irreversible — sc-cmt-08 captura terminality via state machine; sc-cmt-05 captura supervision + immutability). Coverage T/T/T per founder ajuste: build-time state machine declaration; validation-time lint event log; runtime command handler + event enforcement (no transition from cancelled state)."
}
