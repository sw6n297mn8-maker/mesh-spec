package bkr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// bkr-primary-agent.cue — Agent Spec: BKR Primary Agent.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Agente primário do BKR (único agent Phase 0; specialist/integration
// agents em waves futuras). Opera sobre o único aggregate
// agg-settlement-attempt + 3 cross-source domain services
// (svc-reconciliation, svc-failure-classification, svc-technical-rail-
// selection) + 3 projections (prj-settlement-status, prj-failure-
// classification, prj-audit-trail). Materializa execução técnica
// determinística de settlement sob intenção econômica autorizada
// upstream.
//
// Phase 4 do WI-062 BKR bootstrap. Cascade ordering per adr-053/adr-054:
// schema #AgentSpec + PG existem; canvas BKR Phase 1 stable (cf513a4);
// glossary Phase 2 stable (85eddac); domain-model Phase 3 stable
// (f33d03c); agent-spec é Phase 4. Phase 5 (governance envelope)
// materializa autonomy caps + escalation channels + drift detection.
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária): 16 actions × autonomyLevel
//   matrix (8 propose-and-wait + 8 execute-and-log); 3 decision-vs-
//   execution splits em irreversibility/external-side-effect/epistemic-
//   collapse; observabilidade 10 signals + 13 audit fields
// - lens-security-trust-infrastructure (secundária): inputTrustLevel
//   per action (11 trusted-internal + 5 external-structured/mixed);
//   cryptographic boundary via cst-authorization-proof-verification +
//   audit-proof-reference (never payload)
// - lens-regulatory-compliance-as-architecture (terciária): 9 cst-*
//   1:1 invariant coverage; side-channel mitigation via prj-failure-
//   classification policy; regulatory boundary halt + escalate (no
//   heuristic adaptation per cst-rail-selection-technical-only + ec-
//   regulatory-boundary-misalignment)
//
// Phase 4 materializada em 6 sub-phases pre-write (4.1 scope + actions
// skeleton → 4.2 autonomy/trust/impact matrix → 4.3 constraints +
// escalation → 4.4 context + observability + audit → 4.5 write único
// → 4.6 SRR). Founder iterative review aplicou 20+ ajustes finos
// distribuídos.
//
// Canonical test domínio-é-centro (tq-agg-10): agente OBSERVA + VALIDA
// + PROPÕE; aggregates/lifecycle/svcs/schema SEGURAM invariants. 9:9
// coverage invariant→constraint sem agent como sole-enforcer.

agentSpec: artifact_schemas.#AgentSpec & {
	code:        "agt-bkr-primary"
	name:        "BKR Primary Agent"
	description: "Único agent do BC BKR Phase 0. Opera agg-settlement-attempt + 3 domain services (svc-reconciliation, svc-failure-classification, svc-technical-rail-selection) + 3 projections para executar settlement técnico sob intenção econômica autorizada upstream. 16 actions cobrindo verification, rail selection, dispatch (split decide+execute), reject, reconciliation outcome canonicalization, cancellation (split decide+execute), indeterminate resolution (split decide+execute), failure classification, rail availability observation, queries, e escalation. Identidade canônica preservada: agente executa decisões técnicas determinísticas; nunca transforma em decisão econômica."

	boundedContextRef: "bkr"
	role:              "domain-agent"
	governanceRef:     "bkr-primary-agent"

	// ============================================================
	// OPERATIONAL SCOPE
	// ============================================================

	operationalScope: {
		aggregates: ["agg-settlement-attempt"]
		commands: [
			"cmd-dispatch-payment-instruction",
			"cmd-request-settlement-cancellation",
			"cmd-reject-instruction",
			"cmd-dispatch-to-rail",
			"cmd-record-reconciliation-outcome",
			"cmd-resolve-indeterminate-state",
		]
		events: [
			"evt-payment-instruction-accepted",
			"evt-instruction-rejected",
			"evt-attempt-dispatched",
			"evt-settlement-finalized",
			"evt-settlement-failed",
			"evt-settlement-indeterminate",
			"evt-failure-classified",
			"evt-cancellation-requested-of-rail",
			"evt-cancellation-acknowledged-by-rail",
			"evt-cancellation-rejected-by-rail",
			"evt-cash-operational-status-updated-received",
			"evt-rail-provider-status-updated-received",
			"evt-reconciliation-completed",
		]
		invariants: [
			"inv-anti-decision-boundary",
			"inv-authorization-proof-verification-gate",
			"inv-settlement-finality-post-reconciliation-only",
			"inv-indeterminate-state-non-collapse",
			"inv-attempt-identity-per-retry",
			"inv-idempotency-enforcement-per-attempt",
			"inv-rail-selection-technical-criteria-only",
			"inv-failure-classification-no-automatic-remediation",
			"inv-reverse-settlement-upstream-authorized-only",
		]
		projections: [
			"prj-settlement-status",
			"prj-failure-classification",
			"prj-audit-trail",
		]
	}

	// ============================================================
	// ACTIONS (16)
	// ============================================================

	actions: [{
		code:            "act-verify-authorization-proof"
		name:            "Verify Authorization Proof"
		description:     "Verifica AuthorizationProof anexada à PaymentInstruction recebida via cmd-dispatch-payment-instruction na borda T1 do BC. 5-component verification: (a) cryptographic signature valid against canonical payload encoding; (b) nonce not previously consumed (replay protection); (c) issued-at timestamp present; (d) now() ≤ validity-window-ends-at (proof not expired); (e) claim chain resolvable to upstream FCE agent identity. Outcome: verified (proceeds to act-select-rail + act-decide-dispatch-to-rail) OR rejected (triggers act-classify-failure subtype=authorization-proof-invalid + act-reject-instruction). impact=read-only (verification produz outcome; mutation materializada por T1 aggregate creation OR T2 rejection subsequent)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"vo-authorization-proof",
			"vo-payment-instruction",
			"inv-authorization-proof-verification-gate",
			"cmd-dispatch-payment-instruction",
		]
		preconditions: [
			"cmd-dispatch-payment-instruction received from FCE with PaymentInstruction payload attached",
			"vo-authorization-proof 5 components present (signature + nonce + issuedAt + validityWindowEndsAt + claimChain)",
		]
		postconditions: [
			"If verified: act-select-rail invoked subsequent",
			"If rejected: act-classify-failure invoked with subtype=authorization-proof-invalid + act-reject-instruction issued; intake failure (no aggregate created) OR T2 transition (aggregate already in requested → rejected) per cst-authorization-proof-verification",
			"Verification outcome registered in audit trail with authorization-proof-reference (hash only; never proof payload)",
		]
	}, {
		code:            "act-select-rail"
		name:            "Select Rail Technically"
		description:     "Invoca svc-technical-rail-selection per 4 critérios técnicos do glossary term-technical-rail-selection: (a) technical availability rail dentro de operational-window; (b) protocol compatibility payer/payee; (c) latency admissibility contra upstream-declared validity-window (constraint check, NOT optimization); (d) upstream-declared constraints (railHint OR pin OR fallback list). Output: vo-rail-target. NUNCA por cost optimization, treasury position, fee arbitrage. impact=read-only (decision recommendation; rail materializado em act-execute-dispatch-to-rail). inputTrustLevel=external-structured per defense-in-depth (lower-trust input dominates): although vo-payment-instruction é trusted-internal FCE, operational-window + rail-operational-status são external-structured via ACL feeds."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"svc-technical-rail-selection",
			"vo-rail-target",
			"vo-operational-window",
			"vo-rail-operational-status",
			"vo-payment-instruction",
			"inv-rail-selection-technical-criteria-only",
		]
		preconditions: [
			"act-verify-authorization-proof produced verified outcome",
			"vo-operational-window current per rail consultable",
			"vo-rail-operational-status updated per ACL events recent",
		]
		postconditions: [
			"vo-rail-target selected per 4 critérios deterministic",
			"If no rail satisfies critérios: act-classify-failure invoked with category=structural-invalid (e.g., out-of-window upstream pin)",
			"If rail selected: act-decide-dispatch-to-rail invoked subsequent",
		]
	}, {
		code:            "act-decide-dispatch-to-rail"
		name:            "Decide Dispatch To Rail"
		description:     "Decision recommendation step (tq-agg-09 separation per inv-anti-decision-boundary preservation). Consome outputs de act-verify-authorization-proof + act-select-rail e produz recommendation payload contendo: (a) selected rail (vo-rail-target); (b) idempotencyKey construído per attempt; (c) dispatch payload structured per rail-specific protocol (Pix pacs.008, TED message, boleto CNAB, SWIFT MX). Recommendation passa por human gate Phase 0 (propose-and-wait) antes de act-execute-dispatch-to-rail. NÃO efetiva mutation no aggregate; NÃO envia ao rail. impact=read-only (recommendation pure; aggregate state NÃO muta até execute)."
		category:        "validation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-dispatch-to-rail",
			"vo-rail-target",
			"vo-idempotency-key",
			"vo-payment-instruction",
			"inv-anti-decision-boundary",
			"inv-rail-selection-technical-criteria-only",
			"inv-idempotency-enforcement-per-attempt",
			"inv-attempt-identity-per-retry",
		]
		preconditions: [
			"act-verify-authorization-proof produced verified outcome",
			"act-select-rail produced rail per 4 critérios técnicos deterministic",
			"agg-settlement-attempt in state=requested",
		]
		postconditions: [
			"Recommendation payload (rail + idempotencyKey + dispatch payload) produced",
			"Human gate consulted per propose-and-wait Phase 0",
			"On approval: act-execute-dispatch-to-rail proceeds with approved recommendation",
			"On rejection: returns to upstream FCE for instruction adjustment; aggregate remains in state=requested or escalates via ec-* if persistent",
		]
	}, {
		code:            "act-execute-dispatch-to-rail"
		name:            "Execute Dispatch To Rail"
		description:     "Materialização da approved recommendation produzida por act-decide-dispatch-to-rail. Issues cmd-dispatch-to-rail ao aggregate handler; aggregate transitiona T3 (requested → in-flight); aggregate emits evt-attempt-dispatched (internal lifecycle marker); integration adapter dispatcha instruction ao external rail (Pix via SPI, TED via STR/SITRAF, boleto via SILOC, SWIFT via correspondent) per canvas command-invocation. Action é IRREVERSÍVEL at rail-side once dispatched; supervised gate per propose-and-wait Phase 0 é o último ponto de controle BKR antes de externalizar instruction. impact=external-side-effect. Per-action escalation override: +suspicious-input (proof reuse pattern em re-dispatch) + conflicting-signals (rail status conflict durante dispatch window)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-dispatch-to-rail",
			"agg-settlement-attempt",
			"evt-attempt-dispatched",
			"vo-idempotency-key",
			"vo-rail-target",
			"inv-attempt-identity-per-retry",
			"inv-idempotency-enforcement-per-attempt",
			"inv-anti-decision-boundary",
		]
		preconditions: [
			"act-decide-dispatch-to-rail produced approved recommendation",
			"Human gate per propose-and-wait Phase 0 approved",
			"agg-settlement-attempt in state=requested",
			"idempotencyKey not previously consumed at rail-side (verified via rail dedup)",
		]
		postconditions: [
			"cmd-dispatch-to-rail issued; aggregate handler transitions T3 (requested → in-flight)",
			"evt-attempt-dispatched emitted (internal lifecycle marker)",
			"Integration adapter dispatches instruction ao external rail per railSelected",
			"vo-rail-reference-id may emerge subsequently via partner/PSTI ACL events (consumed por act-compute-reconciliation)",
			"Settlement attempt now subject to rail-side processing; cancellation pre-finality possible via act-decide-cancellation-request + act-execute-cancellation-request",
		]
	}, {
		code:            "act-reject-instruction"
		name:            "Reject Instruction"
		description:     "Materializa T2 transition (requested → rejected) issuing cmd-reject-instruction ao aggregate handler. Triggered post-act-classify-failure quando boundary check detecta structural-invalid OR business-invalid OR upstream-policy-reject OR authorization-proof-invalid pre-dispatch. Aggregate handler aplica state transition + emits evt-instruction-rejected (published para fce) + evt-failure-classified (published para fce com granular detail). impact=cross-bc (eventos publicados a fce)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-reject-instruction",
			"agg-settlement-attempt",
			"evt-instruction-rejected",
			"evt-failure-classified",
			"vo-failure-classification",
			"inv-failure-classification-no-automatic-remediation",
			"inv-anti-decision-boundary",
		]
		preconditions: [
			"act-classify-failure produced classification with category ∈ {structural-invalid, business-invalid, upstream-policy-reject, authorization-proof-invalid}",
			"agg-settlement-attempt in state=requested (when aggregate created) OR intake failure (no aggregate created)",
		]
		postconditions: [
			"If aggregate exists: cmd-reject-instruction issued; T2 transition rejected (terminal)",
			"If intake failure: rejection recorded sem aggregate creation",
			"evt-instruction-rejected emitted published to fce",
			"evt-failure-classified emitted published to fce com granular classification",
			"New attempt requires new InstructionId + new AuthorizationProof per inv-authorization-proof-verification-gate amplification",
		]
	}, {
		code:            "act-compute-reconciliation"
		name:            "Compute Reconciliation Outcome"
		description:     "Invoca svc-reconciliation que correlaciona SettlementAttempt state (BKR-side: instructionId × attemptId × idempotencyKey × instructed value/payee/rail) contra rail settlement/confirmation signals received via partner/PSTI ACL events (rail-side: railReferenceId × confirmed value/payee/status/timestamp) per 4 conditions glossary term-reconciliation. Outcome trichotomic: finalized | failed | indeterminate. Emits evt-reconciliation-completed; pol-reconciliation-outcome-routing transforma em cmd-record-reconciliation-outcome. impact=read-only (computation; canonicalization via cmd-record-reconciliation-outcome subsequent)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"svc-reconciliation",
			"evt-reconciliation-completed",
			"vo-rail-reference-id",
			"vo-instruction-id",
			"vo-attempt-id",
			"vo-settlement-state",
			"inv-settlement-finality-post-reconciliation-only",
			"inv-indeterminate-state-non-collapse",
		]
		preconditions: [
			"agg-settlement-attempt in state=in-flight",
			"Rail settlement/confirmation signal received via partner/PSTI ACL events",
		]
		postconditions: [
			"Reconciliation outcome computed (finalized | failed | indeterminate) per 4 conditions deterministic",
			"evt-reconciliation-completed emitted (internal marker)",
			"pol-reconciliation-outcome-routing transforma outcome em cmd-record-reconciliation-outcome subsequent",
			"failureClassification computed via act-classify-failure when outcome=failed",
			"indeterminacyReason determined via reasoning algorithm when outcome=indeterminate",
		]
	}, {
		code:            "act-record-reconciliation-outcome"
		name:            "Record Reconciliation Outcome (Canonicalization Mutation)"
		description:     "Canonicalization mutation — issues cmd-record-reconciliation-outcome ao aggregate handler com outcome trichotomic determined by svc-reconciliation. Aggregate transitions T4/T5/T6 per outcome value: finalized → evt-settlement-finalized published; failed → evt-settlement-failed + evt-failure-classified published; indeterminate → evt-settlement-indeterminate published. Action é o ponto onde BKR publica outcome canonical cross-BC para fce/tcm/ato. Conditional fields per outcome: failureClassification iff failed; indeterminacyReason iff indeterminate. impact=cross-bc."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-record-reconciliation-outcome",
			"agg-settlement-attempt",
			"evt-settlement-finalized",
			"evt-settlement-failed",
			"evt-settlement-indeterminate",
			"evt-failure-classified",
			"vo-settlement-state",
			"vo-failure-classification",
			"vo-indeterminacy-reason",
			"inv-settlement-finality-post-reconciliation-only",
			"inv-indeterminate-state-non-collapse",
			"inv-failure-classification-no-automatic-remediation",
		]
		preconditions: [
			"act-compute-reconciliation produced trichotomic outcome",
			"pol-reconciliation-outcome-routing triggered by evt-reconciliation-completed",
			"agg-settlement-attempt in state=in-flight",
			"Outcome discriminator (finalized/failed/indeterminate) determined deterministically",
		]
		postconditions: [
			"cmd-record-reconciliation-outcome issued with outcome + railReferenceId + (conditional failureClassification + indeterminacyReason)",
			"Aggregate handler transitions T4 (→ finalized) OR T5 (→ failed) OR T6 (→ indeterminate)",
			"Published events emitted cross-BC per outcome",
			"prj-settlement-status + prj-failure-classification + prj-audit-trail updated via event consumption",
		]
	}, {
		code:            "act-decide-cancellation-request"
		name:            "Decide Cancellation Request"
		description:     "Decision recommendation step para cancellation request — consume cmd-request-settlement-cancellation inbound de FCE; verifica aggregate state (in-flight only pre-finality; rejected/finalized/failed/indeterminate NÃO aceita cancellation request); valida instructionId+attemptId existence; constrói cancellation request payload per rail-specific protocol (e.g., pacs.057 SPI). Recommendation passa por human gate Phase 0 antes de act-execute-cancellation-request. impact=read-only (recommendation; not yet sent to rail)."
		category:        "validation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-request-settlement-cancellation",
			"vo-instruction-id",
			"vo-attempt-id",
			"inv-anti-decision-boundary",
			"inv-reverse-settlement-upstream-authorized-only",
		]
		preconditions: [
			"cmd-request-settlement-cancellation received from FCE",
			"agg-settlement-attempt in state=in-flight (cancellation request rejected if post-finality OR indeterminate)",
		]
		postconditions: [
			"Cancellation request payload prepared per rail-specific protocol",
			"Human gate consulted per propose-and-wait Phase 0",
			"On approval: act-execute-cancellation-request proceeds",
			"On rejection: cancellation request not dispatched; FCE informed via audit trail",
		]
	}, {
		code:            "act-execute-cancellation-request"
		name:            "Execute Cancellation Request"
		description:     "Materializa cancellation request ao rail — handler invoca aggregate processing de cmd-request-settlement-cancellation; aggregate atualiza ent-cancellation-request nested entity (outcomeStatus=pending → eventual acknowledged|rejected); aggregate emits evt-cancellation-requested-of-rail (internal); integration adapter dispatches pacs.057 OR equivalente ao external rail. Action é NON-GUARANTEED — alguns rails aceitam, outros best-effort, outros já em clearing irreversível. impact=external-side-effect. Per-action escalation override: +out-of-scope (post-finality cancellation attempt detected pelo rail)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-request-settlement-cancellation",
			"agg-settlement-attempt",
			"ent-cancellation-request",
			"evt-cancellation-requested-of-rail",
			"inv-anti-decision-boundary",
		]
		preconditions: [
			"act-decide-cancellation-request produced approved recommendation",
			"Human gate per propose-and-wait Phase 0 approved",
			"agg-settlement-attempt still in state=in-flight (re-verified atomically)",
		]
		postconditions: [
			"ent-cancellation-request created or updated (outcomeStatus=pending; requestSentToRailAt timestamped)",
			"evt-cancellation-requested-of-rail emitted (internal)",
			"Integration adapter dispatches cancellation request ao external rail",
			"Outcome (evt-cancellation-acknowledged-by-rail OR evt-cancellation-rejected-by-rail) received subsequently via ACL events",
			"If acknowledged: pol-cancellation-outcome-routing → cmd-record-reconciliation-outcome with subtype='cancellation-honored-by-rail'",
			"If rejected: attempt remains in normal reconciliation path (no terminal state from cancellation rejection per Phase 3.A.5 ajuste 3)",
		]
	}, {
		code:            "act-update-rail-availability-state"
		name:            "Update Rail Availability State (Observation-Normalization)"
		description:     "Observação e normalização de inputs externos sobre operational availability per rail. Consume ACL events evt-rail-provider-status-updated-received (partner/PSTI status feeds) + evt-cash-operational-status-updated-received (TCM liquidity advisory). Normaliza inputs em vo-rail-operational-status + vo-operational-window canonical update no internal projection/cache utilizado por svc-technical-rail-selection critério (a). impact=state-change (limitado a projection/cache operacional; NÃO muta agg-settlement-attempt nem cria settlement outcome)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"evt-rail-provider-status-updated-received",
			"evt-cash-operational-status-updated-received",
			"vo-rail-operational-status",
			"vo-operational-window",
			"vo-rail-target",
		]
		preconditions: [
			"ACL event evt-rail-provider-status-updated-received OR evt-cash-operational-status-updated-received received com sourceContext válido",
		]
		postconditions: [
			"Internal projection/cache de rail availability updated (NÃO mutation em agg-settlement-attempt)",
			"svc-technical-rail-selection consume cache atualizado em invocations subsequentes",
			"Se divergence detectada vs cache anterior: sig-rail-status-divergence emitted (warn)",
		]
	}, {
		code:            "act-decide-indeterminate-resolution"
		name:            "Decide Indeterminate Resolution"
		description:     "Decision recommendation step para resolução de aggregate em state=indeterminate. Consume resolution evidence (re-query rail response OR manual reconciliation outcome OR escalation determination) e propõe resolution discriminator (finalized OR failed; NUNCA indeterminate per inv-indeterminate-state-non-collapse). Recommendation passa por human gate Phase 0 antes de act-execute-indeterminate-resolution — colapsar incerteza epistemológica em estado canônico é tão sensível quanto dispatch externo. impact=read-only (recommendation pure; canonicalization via execute subsequent). inputTrustLevel=external-structured per defense-in-depth (lower-trust input dominates): manual reconciliation evidence é trusted-internal mas re-query rail responses são external-structured via ACL feeds."
		category:        "validation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"cmd-resolve-indeterminate-state",
			"vo-resolution-evidence",
			"vo-settlement-state",
			"vo-indeterminacy-reason",
			"inv-indeterminate-state-non-collapse",
			"inv-settlement-finality-post-reconciliation-only",
		]
		preconditions: [
			"agg-settlement-attempt in state=indeterminate",
			"Resolution evidence collected (re-query rail confirmed outcome OR manual reconciliation OR escalation determination)",
		]
		postconditions: [
			"Resolution recommendation payload (finalized OR failed + resolutionEvidence + railReferenceId optional + failureClassification optional iff failed) prepared",
			"Human gate consulted per propose-and-wait Phase 0 — epistemic state collapse sensitivity",
			"On approval: act-execute-indeterminate-resolution proceeds with approved recommendation",
			"On rejection: aggregate remains in indeterminate; resolution path re-investigated",
		]
	}, {
		code:            "act-execute-indeterminate-resolution"
		name:            "Execute Indeterminate Resolution"
		description:     "Materializa T7 (indeterminate → finalized) OR T8 (indeterminate → failed) transition via cmd-resolve-indeterminate-state ao aggregate handler. Aggregate atomicaly aplica transição + emits evt-settlement-finalized OR evt-settlement-failed (+ evt-failure-classified iff failed) cross-BC published para fce/tcm/ato. Canonicalização epistemic é o pico de criticality do BC — non-final state é colapsado em finality canonical com proof evidence. impact=cross-bc. Per-action escalation override: +conflicting-signals (re-query rail × manual reconciliation divergem) + insufficient-context (resolution evidence ambiguous between paths)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-resolve-indeterminate-state",
			"agg-settlement-attempt",
			"evt-settlement-finalized",
			"evt-settlement-failed",
			"evt-failure-classified",
			"vo-resolution-evidence",
			"vo-settlement-state",
			"inv-indeterminate-state-non-collapse",
			"inv-settlement-finality-post-reconciliation-only",
			"inv-failure-classification-no-automatic-remediation",
		]
		preconditions: [
			"act-decide-indeterminate-resolution produced approved recommendation",
			"Human gate per propose-and-wait Phase 0 approved",
			"agg-settlement-attempt still in state=indeterminate (re-verified atomically)",
		]
		postconditions: [
			"cmd-resolve-indeterminate-state issued com resolution discriminator + resolutionEvidence",
			"Aggregate handler transitions T7 (→ finalized) OR T8 (→ failed)",
			"Published events emitted cross-BC per resolution",
			"resolutionEvidence stored em aggregate field for audit trail forensic",
		]
	}, {
		code:            "act-classify-failure"
		name:            "Classify Failure"
		description:     "Invoca svc-failure-classification que classifica falhas detectadas em 5 categorias × 4 ownership × optional subtype, produzindo vo-failure-classification. Triggers: (a) pre-dispatch boundary check (structural-invalid | business-invalid | upstream-policy-reject); (b) post-dispatch rail rejection (provider-or-rail-reject com subtypes regulatory | account-status | rail-limit | provider-policy); (c) technical-failure (BKR-authoritative pre ou post rail) — may produce retry-eligibility ONLY IF retry policy is pre-authorized by instruction's fallback declaration or by an upstream policy explicitly governing the rail; in absence of pre-authorization, technical-failure escalates without auto-remediation. Output embedded em cmd-reject-instruction OR cmd-record-reconciliation-outcome payload. Side-channel mitigation: detailReference opaque para sanitized downstream consumption via prj-failure-classification. impact=read-only (classification tuple produced; remediation requires separate upstream-authorized command). inputTrustLevel=external-structured per defense-in-depth (lower-trust input dominates): BKR boundary state é trusted-internal mas rail error codes são external-structured via ACL feeds."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"svc-failure-classification",
			"vo-failure-classification",
			"evt-failure-classified",
			"inv-failure-classification-no-automatic-remediation",
			"inv-anti-decision-boundary",
		]
		preconditions: [
			"Failure detected via boundary check OR rail rejection OR technical-failure observation",
		]
		postconditions: [
			"vo-failure-classification produced (category × ownership × optional subtype × detailReference opaque)",
			"Classification embedded em cmd-reject-instruction payload OR cmd-record-reconciliation-outcome payload",
			"evt-failure-classified emitted published com granular detail para fce; sanitized aggregate para downstream consumers via prj-failure-classification",
			"NO remediation command auto-emitted; retry eligibility set only when pre-authorized policy lookup confirms",
		]
	}, {
		code:            "act-query-settlement-status"
		name:            "Query Settlement Status"
		description:     "Read query operation contra prj-settlement-status projection. Suporta 3 query capabilities: qry-settlement-status-by-instruction-id (FCE/ATO business correlation lookup); qry-settlement-status-by-attempt-id (operational debug + forensic per attempt); qry-settlement-status-by-rail-reference-id (reverse lookup from rail-side identifier). Não causa mutation; não decide ação; retorna SettlementStatusView snapshot. impact=read-only."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-settlement-status",
			"qry-settlement-status-by-instruction-id",
			"qry-settlement-status-by-attempt-id",
			"qry-settlement-status-by-rail-reference-id",
		]
		preconditions: [
			"Query received com filter parameter (instructionId OR attemptId OR railReferenceId)",
		]
		postconditions: [
			"SettlementStatusView snapshot returned per filter",
			"Audit trail entry registered (input-summary contains query filter; output-summary contains state discriminator returned)",
		]
	}, {
		code:            "act-query-failure-classification"
		name:            "Query Failure Classification"
		description:     "Read query operation contra prj-failure-classification projection. Suporta 2 query capabilities: qry-failure-classification-by-instruction-id (FCE business correlation lookup); qry-failure-classification-by-attempt-id (granular detail per attempt). Side-channel filtering policy implementada em prj-failure-classification projection layer: full granular detail apenas para callers identificáveis como upstream authorizer (FCE); demais consumers recebem sanitized aggregate. Action respeita projection policy; NÃO bypassa filtering. impact=read-only."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-failure-classification",
			"qry-failure-classification-by-instruction-id",
			"qry-failure-classification-by-attempt-id",
		]
		preconditions: [
			"Query received com filter (instructionId OR attemptId) + caller identity claim",
		]
		postconditions: [
			"FailureClassificationView returned per filter; granular OR sanitized per caller identity verification by projection layer",
			"Audit trail entry registered (input-summary contains query filter + caller identity; output-summary contains classification visibility level applied)",
		]
	}, {
		code:            "act-escalate-anomaly"
		name:            "Escalate Anomaly"
		description:     "Emit escalation signal per canvas Phase 1.5 escalationCriteria (9 ec-* mapeados para schema categories). Triggered por: cst-* onViolation=block-and-escalate firing; ou observation patterns matching ec-* conditions (proof verification failure pattern, double settlement suspicion, indeterminate persistence beyond operational window, rail-finality conflict, side-channel leak detection, regulatory routing ambiguity, regulatory misalignment detection, cross-attempt anomaly under instruction, BKR meta info leak). Escalation channel + recipient + SLA materializados em governance envelope (Phase 5). impact=cross-bc (emits escalation to supervisor/governance channel)."
		category:        "escalation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"inv-anti-decision-boundary",
			"inv-authorization-proof-verification-gate",
			"inv-settlement-finality-post-reconciliation-only",
			"inv-indeterminate-state-non-collapse",
			"inv-reverse-settlement-upstream-authorized-only",
		]
		preconditions: [
			"Escalation criterion detected (per 9 ec-* + 4 per-action overrides) OR cst-* onViolation=block-and-escalate fired",
		]
		postconditions: [
			"sig-escalation-triggered emitted (warn level) com escalation-category + escalation-rationale payload",
			"Audit trail entry registered (input-summary contains trigger detail; output-summary contains escalation channel routed)",
			"Action halts subsequent execution path until escalation resolution per governance envelope",
		]
	}]

	// ============================================================
	// CONSTRAINTS (9, 1:1 invariant coverage)
	// ============================================================

	constraints: [{
		code:         "cst-anti-decision-boundary-enforcement"
		name:         "Anti-Decision Boundary Enforcement"
		description:  "BKR agent NEVER materializes economic decision via any action. Agent operates 5 nevers: never authorizes payment, never mutates beneficiary, never alters value, never collapses ambiguity into completion, never performs treasury allocation. Any agent action that would constitute economic decision is rejected by aggregate handler OR escalated per supervised gate."
		verification: "Runner verifies: (a) no action[] declares domainModelRef to economic-decision command (no cmd-authorize-payment / cmd-decide-beneficiary / cmd-allocate-treasury exist in BKR domain-model); (b) act-classify-failure does not produce remediation field; (c) act-decide-* recommendations carry only technical decision payload (rail + idempotencyKey + dispatch payload); (d) agg-settlement-attempt.fields are immutable post-creation (payer/payee/value/instructionId/idempotencyKey snapshots); (e) no action chain auto-progresses from non-final state to final without cmd-resolve-indeterminate-state explicit."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-anti-decision-boundary. enforcementLevel: domain (aggregate handler rejects commands violating 5 nevers; schema does not model economic-decision commands in BKR) + agent (act-decide-* produces only technical recommendations; agent never authorizes economic intent). Real enforcer: aggregate handler + schema constraint. Agent role: observe + validate; sole-enforcement detection é red flag per tq-agg-10."
	}, {
		code:         "cst-authorization-proof-verification"
		name:         "Authorization Proof Verification"
		description:  "Every PaymentInstruction received via cmd-dispatch-payment-instruction MUST undergo full AuthorizationProof verification before SettlementAttempt aggregate creation (T1). Verification: 5-component check (signature valid + nonce not consumed + issuedAt present + now() ≤ validityWindowEndsAt + claimChain resolvable). If aggregate instance already exists in requested, transition T2 to rejected. If verification fails before aggregate creation, reject intake without creating SettlementAttempt. Original AuthorizationProof never reusable for reverse economic intent."
		verification: "Runner verifies: (a) act-verify-authorization-proof invoked synchronously before T1 aggregate creation for every cmd-dispatch-payment-instruction; (b) aggregate handler rejects T1 creation when verification outcome != verified; (c) nonce uniqueness check against persistent nonce-consumed store; (d) validityWindowEndsAt comparison against now() at verification time; (e) claimChain resolves via upstream authorizer registry. Audit trail entry per verification (input-summary contains authorization-proof-reference hash; outcome-summary contains verified/rejected discriminator)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-authorization-proof-verification-gate. enforcementLevel: agent (act-verify-authorization-proof executes verification deterministic) + domain (aggregate T1 atomic creation rejects if proof invalid). Real enforcer: T1 lifecycle atomicity. Agent role: invoke verification deterministic; rejection materialized via svc-failure-classification subtype=structural-invalid + cmd-reject-instruction. Per inv: validity is consumed never interpreted."
	}, {
		code:         "cst-settlement-finality-deterministic-only"
		name:         "Settlement Finality Deterministic Only"
		description:  "evt-settlement-finalized é emitted ONLY após svc-reconciliation completou 4-conditions match deterministic; NUNCA derived diretamente de rail signal isolated. SettlementFinality é canonical assertion BKR sobre system state, not forwarded rail signal."
		verification: "Runner verifies: (a) evt-settlement-finalized emission path traces back to cmd-record-reconciliation-outcome com outcome=finalized; (b) svc-reconciliation 4 conditions evaluated em order (instructionId × railReferenceId × outcome match; rail signal confirms irreversibility per rail-specific semantics; value coherence; payee coherence); (c) no policy auto-emits evt-settlement-finalized from rail signal alone; (d) lifecycle T4/T7 guards include inv-settlement-finality-post-reconciliation-only invariant ref."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-settlement-finality-post-reconciliation-only. enforcementLevel: domain (lifecycle T4/T7 atomic transitions with guard) + runner (validates emission paths). Real enforcer: lifecycle guards + cmd-record-reconciliation-outcome routing. Agent role: invoke svc-reconciliation deterministic; canonicalization decision flows through aggregate handler atomic."
	}, {
		code:         "cst-indeterminate-preserved-distinct"
		name:         "Indeterminate Preserved Distinct"
		description:  "Aggregate state=indeterminate é preservado epistemic distinct from failed and finalized. evt-settlement-indeterminate é own event (NOT subsumed em evt-settlement-failed). Aggregate state=indeterminate NEVER auto-progresses without explicit cmd-resolve-indeterminate-state. Transition out of indeterminate (T7/T8) is only via cmd-resolve-indeterminate-state with resolutionEvidence required."
		verification: "Runner verifies: (a) lifecycle.states[] includes 'indeterminate' as nominal state distinct from 'failed' and 'finalized'; (b) evt-settlement-indeterminate code is unique entry in events[] catalog; (c) no transition from indeterminate to finalized/failed exists without triggeredByCommand=cmd-resolve-indeterminate-state; (d) consumerProtocol no systemConsistencyModel declares 'Consumers MUST handle SettlementIndeterminate as distinct state'."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-indeterminate-state-non-collapse. enforcementLevel: domain (lifecycle states[] + transitions[] structural) + runner (validates state machine atomicity). Real enforcer: lifecycle state machine. Agent role: invoke svc-reconciliation que pode produzir indeterminate outcome; act-decide-indeterminate-resolution + act-execute-indeterminate-resolution materializam resolution explicit."
	}, {
		code:         "cst-new-attempt-per-retry"
		name:         "New Attempt Per Retry"
		description:  "Each new technical dispatch following a retry decision generates new SettlementAttempt aggregate instance com new vo-attempt-id + new vo-idempotency-key sob same vo-instruction-id. Existing aggregate NEVER mutates its attemptId. Re-query OR reconciliation paths que NÃO generate new dispatch do NOT create new SettlementAttempt."
		verification: "Runner verifies: (a) attemptId field é immutable post-creation em agg-settlement-attempt; (b) cada act-execute-dispatch-to-rail invocation cria new aggregate instance (creation path through act-decide-dispatch-to-rail); (c) idempotencyKey per attempt unique; never reused across attempts; (d) instructionId persists across multiple attempt instances; cross-attempt lineage reconstructible via prj-audit-trail."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-attempt-identity-per-retry. enforcementLevel: domain (aggregate identity immutability) + agent (act-decide-dispatch-to-rail constructs new identifiers per attempt). Real enforcer: aggregate identity field immutability. Agent role: generate new identifiers per new dispatch decision."
	}, {
		code:         "cst-idempotency-per-attempt-not-instruction"
		name:         "Idempotency Enforcement Per Attempt Not Instruction"
		description:  "vo-idempotency-key enforcement happens per SettlementAttempt, NEVER per InstructionId. Using InstructionId como idempotency enforcement is invariant violation: blocks legitimate re-dispatch under same economic instruction AND fails to prevent replay (multiple SettlementAttempts may legitimately share one InstructionId when upstream policy authorizes re-dispatch after non-final or failed execution path)."
		verification: "Runner verifies: (a) cmd-dispatch-to-rail.idempotencyKey field é per-attempt unique (validated against per-attempt construction logic em act-decide-dispatch-to-rail); (b) InstructionId NEVER passed as idempotency parameter ao rail integration adapter; (c) rail-side dedup operates on idempotencyKey per attempt; (d) audit trail captures attempt × idempotencyKey pairing for forensic forensic."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-idempotency-enforcement-per-attempt. enforcementLevel: agent (act-decide-dispatch-to-rail constructs idempotencyKey per attempt) + external (rail-side dedup uses idempotencyKey). Real enforcer: rail-side deduplication + agent identifier construction. Agent role: construct correctly; vector adversarial CRÍTICO se confundido com InstructionId."
	}, {
		code:         "cst-rail-selection-technical-only"
		name:         "Rail Selection By Technical Criteria Only"
		description:  "svc-technical-rail-selection considers ONLY 4 criteria: (a) technical availability against operational window; (b) protocol compatibility between payer and payee; (c) latency admissibility against upstream-declared settlement semantics (constraint check, NOT optimization target); (d) upstream-declared constraints. Rail selection by cost, treasury position, fee arbitrage, scoring/adaptive optimization, or smart routing functions é FORBIDDEN."
		verification: "Runner verifies: (a) svc-technical-rail-selection orchestrates logic structure inspects only 4 fields (no cost/treasury/fee fields referenced); (b) act-select-rail domainModelRefs include inv-rail-selection-technical-criteria-only; (c) no policy auto-substitutes rail based on cost optimization; (d) audit trail captures 4-criteria evaluation per selection."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-rail-selection-technical-criteria-only. enforcementLevel: agent (svc-technical-rail-selection logic structure) + runner (validates no economic optimization fields). Real enforcer: service logic structure. Agent role: invoke service per 4-criteria deterministic; rejection produces structural-invalid classification."
	}, {
		code:         "cst-classification-no-auto-remediation"
		name:         "Classification Produces Ownership Not Remediation"
		description:  "act-classify-failure produces tuple (category × ownership × optional subtype) and emits evt-failure-classified. NEVER automatically issues remediation commands (cross-rail failover, compensating settlement, economic adjustment). technical-failure may produce retry-eligibility ONLY IF pre-authorized retry policy exists em instruction fallback declaration or upstream policy explicitly governs the rail; absence of pre-authorization → escalates without auto-remediation. Side-channel mitigation: granular detail propagates only to FCE via prj-failure-classification authorized channel; downstream consumers receive sanitized aggregate."
		verification: "Runner verifies: (a) act-classify-failure output payload contains only (category, ownership, subtype, detailReference opaque); no remediation command issued from classification result; (b) no policy auto-triggers cmd-record-reconciliation-outcome from classification without explicit reconciliation completion; (c) technical-failure retry eligibility flag set only when pre-authorized policy lookup confirms; (d) prj-failure-classification query handler filters detail per caller identity (granular only for FCE; sanitized for downstream)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-failure-classification-no-automatic-remediation. enforcementLevel: domain (svc-failure-classification output structure produces tuple only) + agent (act-classify-failure produces no remediation; act-escalate-anomaly invoked for compliance info leak detection). Real enforcer: svc-failure-classification output structure + projection layer side-channel filter. Agent role: invoke classification deterministic; respeitar side-channel policy implementada em prj-failure-classification."
	}, {
		code:         "cst-reverse-settlement-upstream-only"
		name:         "Reverse Settlement Upstream Authorized Only"
		description:  "Any reverse-settlement execution by BKR requires NEW AuthorizationProof for NEW economic obligation distinct from original PaymentInstruction. ReversePaymentInstruction must arrive from FCE (policy-driven refund), DRC (dispute reversal), or upstream process responding to regulatory mandate. BKR NEVER originates reverse-settlement autonomously; never derives reverse-authorization from original AuthorizationProof; never executes Pix devolução / pacs.004 / chargeback as response to Reconciliation anomaly. Original AuthorizationProof is never reusable for reverse economic intent."
		verification: "Runner verifies: (a) no cmd-initiate-reverse-settlement OR equivalent autonomous-reverse command exists in BKR domain-model commands[]; (b) no policy auto-emits reverse instruction from Reconciliation anomaly or any internal trigger; (c) reverse-settlement instructions enter via separate authorized inbound path com new AuthorizationProof (modeled em separate aggregate em Phase futura); (d) agent action chain has no path that produces reverse-settlement without upstream-authorized command receipt."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-reverse-settlement-upstream-authorized-only. enforcementLevel: domain (schema constraint: no reverse-settlement-initiation command in BKR) + agent (act-* actions catalog has no reverse-initiation action). Real enforcer: schema constraint + aggregate scope. Agent role: observer; agg-reverse-settlement-attempt é Phase futura separada quando ReverseSettlement workflow for definido."
	}]

	// ============================================================
	// ESCALATION CONDITIONS (9 global)
	// ============================================================
	// Per-action escalation overrides (tq-agg-08 heuristic) declarados
	// em rationale de actions específicas: act-execute-dispatch-to-rail
	// (+suspicious-input + conflicting-signals); act-execute-cancellation-
	// request (+out-of-scope); act-execute-indeterminate-resolution
	// (+conflicting-signals + insufficient-context). act-reject-instruction
	// usa global only.

	escalationConditions: [{
		category:    "suspicious-input"
		description: "AuthorizationProof verification failure during act-verify-authorization-proof — signature invalid, nonce previously consumed, validityWindowEndsAt expired, claimChain unresolvable, OR multiple verification attempts with progressively decaying proofs (degradation pattern indicating possible replay/forgery/upstream key compromise)."
		rationale:   "Mapeia canvas ec-authorization-proof-verification-failure. Per inv-authorization-proof-verification-gate + glossary term-authorization-proof: verification failure não é apenas structural-invalid trivial; pattern degradation indica adversarial signal. Escalation channel: synchronous (blocks aggregate creation); recipient: FCE upstream + supervisor (canal supervisionado per Phase 1.5)."
	}, {
		category:    "conflicting-signals"
		description: "Multiple settlement confirmations detected for same attemptId across separate dispatch paths — e.g., idempotencyKey hit em rail-side mas BKR observa response inconsistent com Attempt original; OR reconciled-completed event emitted twice for same attemptId; OR rail emits second SettlementFinalized signal para mesma instructionId+attemptId em rails distintos sem upstream-authorized fallback declaration."
		rationale:   "Mapeia canvas ec-double-settlement-detected. Per vm-bkr-01 (canvas Phase 1.6 verificationMetrics — duplicate settlement rate target 0%) + inv-idempotency-enforcement-per-attempt: double settlement é falha catastrófica que requer forensic investigation imediata. Escalation channel: synchronous (halt operational dispatch para todos attempts da instructionId); recipient: founder + compliance supervisor."
	}, {
		category:    "insufficient-context"
		description: "Aggregate state=indeterminate persists beyond rail operational window (Pix: defined timeout; STR: data útil cutoff; SILOC: D+0/D+1 batch close; SWIFT: correspondent SLA window). Resolution evidence missing across re-query attempts; manual reconciliation pending; escalation per rail-specific timeout policy required."
		rationale:   "Mapeia canvas ec-indeterminate-state-exceeds-operational-window. Per inv-indeterminate-state-non-collapse: indeterminate é epistemicamente distinto de Failed; persistence beyond window indicates BKR knowledge gap that cannot self-resolve. Escalation channel: async (does not block other operations); recipient: operations team for manual reconciliation."
	}, {
		category:    "conflicting-signals"
		description: "Rail confirma SettlementFinalized mas BKR internal state inconsistent — e.g., cancellation acknowledged + completion confirmed for same attemptId; OR reconciled-failed previamente registrado para mesma attemptId que agora rail confirma como completed; OR rail-side finality claim conflicts com BKR Reconciliation outcome computado."
		rationale:   "Mapeia canvas ec-rail-finality-irreversibility-conflict. Per inv-settlement-finality-post-reconciliation-only: BKR canonicalization deve ser deterministically alinhada com rail evidence; conflict indica reconciliation logic bug OR rail-side bug OR adversarial manipulation. Escalation channel: synchronous (halt aggregate transitions for affected attemptId); recipient: founder + rail integration partner."
	}, {
		category:    "suspicious-input"
		description: "evt-failure-classified OR QueryFailureClassification response carrying compliance-sensitive detail (regulatory-block category subtype, sanctions list inference, AML trigger specifics) para consumer NÃO identificado como upstream authorizer (e.g., regulatory-block detail emitido para audit aggregate consumer OR retornado em query para sh-02 sem identity verification)."
		rationale:   "Mapeia canvas ec-classification-side-channel-leak-detected. Per side-channel mitigation Phase 1.2 cap 6 + cst-classification-no-auto-remediation: BKR é fiduciário de informação regulatoriamente sensível; leak vector é amplification risk (informa attacker sobre sanctions/AML target state). Escalation channel: synchronous + audit aggregate quarantine; recipient: compliance officer + founder."
	}, {
		category:    "ambiguous-case"
		description: "Provider-or-rail-reject with regulatory subtype where the causal category is known, but routing/visibility is ambiguous: which details may be shown to FCE, ATO, audit projection, or downstream consumers without leaking sensitive compliance information."
		rationale:   "Mapeia canvas ec-regulatory-classification-routing. Per side-channel mitigation: classification ownership conhecido (external) mas routing decision precisa de policy clarification antes de proceder com publication. Escalation channel: async; recipient: compliance officer for routing policy decision."
	}, {
		category:    "out-of-scope"
		description: "BKR detects Bacen/CIP/SWIFT spec drift or provider behavior divergence. Action: halt affected rail-specific behavior and escalate for capability/schema update. No heuristic adaptation inside BKR."
		rationale:   "Mapeia canvas ec-regulatory-boundary-misalignment. Per glossary term-regulatory-boundary + inv-anti-decision-boundary: BKR consome regulatory constraints como input absorbed; spec drift OU divergência rail invalida assumption. Heuristic adaptation seria interpretation of regulation. Escalation channel: synchronous halt + capability review; recipient: founder + regulatory specialist for spec update OR provider partnership review."
	}, {
		category:    "conflicting-signals"
		description: "Multiple attempts under same instructionId show anomalous patterns (temporal clustering beyond rail latency expectations; value drift across attempts under same instructionId though instruction value is immutable; rail target drift across attempts without explicit upstream fallback declaration; idempotencyKey collision attempts indicating possible adversarial replay)."
		rationale:   "Mapeia canvas ec-cross-attempt-anomaly-under-instruction. Per inv-attempt-identity-per-retry + inv-idempotency-enforcement-per-attempt: legitimate retries follow specific patterns; deviation indicates potential adversarial scenario OR bug em upstream policy fallback configuration. Escalation channel: async + cross-attempt forensic review via prj-audit-trail; recipient: founder + operations team."
	}, {
		category:    "suspicious-input"
		description: "Meta-detection trigger sobre BKR vazar info sensível — pattern match em emitted events suggesting compliance info leak (sanctions reasoning, AML detail in non-fce-channel), OR prj-failure-classification queries em high-frequency consumer pattern indicating side-channel sweep attempt, OR meta-metrics on classification routing showing distribution anomaly."
		rationale:   "Mapeia canvas ec-bkr-info-leak-meta-detection. Per side-channel mitigation: BKR é responsável por self-monitoring sobre próprio comportamento de vazamento. Meta-detection é última linha de defesa quando previous gates fail. Escalation channel: synchronous halt + compliance review; recipient: compliance officer + founder."
	}]

	// ============================================================
	// CONTEXT REQUIREMENTS
	// ============================================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Identity + capabilities + bd-* business decisions + Phase 1.5 governance scope (5 autonomous + 6 supervised + 9 escalation criteria) + communication inbound/outbound surface. Agente carrega para preservar boundary semantics + identidade canônica per cada action."
			requiredSlices: [
				"identity (purpose + classification + verticalApplicability)",
				"capabilities (cap-* todos)",
				"businessDecisions (bd-* todos — anti-decision boundary materialization)",
				"governanceScope (autonomous + supervised + escalation criteria)",
				"communication (inbound + outbound — alinhamento canvas-domain-model)",
			]
		}, {
			artifactType: "domain-model"
			rationale:    "Building blocks DDD táticos: 9 invariants protegidos atomicamente per command handling; 6 commands handled; 13 events emitted; 15 value objects com 4-way IDs + AuthorizationProof + FailureClassification; aggregate lifecycle 6 states + 7 transitions; interpretation contracts (consistency + authority + boundary). Domain-model é fonte de truth para operationalScope + actions[].domainModelRefs."
			requiredSlices: [
				"invariants (9 — protected pelo agg)",
				"commands (6 — handled pelo agg)",
				"events (13 — emitted pelo agg per P2P convention)",
				"valueObjects (15 — usesValueObjects subset)",
				"aggregates (agg-settlement-attempt completo + ent-cancellation-request nested)",
				"domainServices (svc-reconciliation + svc-failure-classification + svc-technical-rail-selection)",
				"policies (pol-reconciliation-outcome-routing + pol-cancellation-outcome-routing)",
				"projections (prj-settlement-status + prj-failure-classification + prj-audit-trail)",
				"systemConsistencyModel + decisionAuthorityModel + consistencyBoundary",
			]
		}, {
			artifactType: "glossary"
			rationale:    "15 termos canônicos com antiTerms preservando UL precision (term-payment-instruction vs Payment; term-reconciliation vs Confirmation; term-reverse-settlement boundary com 8 antiTerms; term-settlement-indeterminate vs Failed; term-technical-rail-selection vs Smart Routing). Agente consulta para preservar UL durante action invocation + signal emission + audit trail composition."
			requiredSlices: [
				"all 15 terms (boundary-hardening artifact, não onboarding dictionary)",
				"outer rationale (event naming deferral note + 5 lenses applied)",
			]
		}, {
			artifactType: "agent-governance"
			rationale:    "Required before autonomous promotion; Phase 4 may reference governanceRef as planned artifact. Phase 5 envelope materializa autonomy caps + escalation channels + drift detection thresholds + signal-as-contract scopedBySignal refs per adr-075. Phase 4 spec declara QUANDO escalar; envelope declara COMO."
			requiredSlices: [
				"autonomy caps per action (Phase 0 100% supervised onboarding default)",
				"escalation channels (sync/async + recipient + SLA)",
				"drift detection thresholds (Phase 5+)",
				"signal-as-contract scopedBySignal refs",
			]
		}, {
			artifactType: "context-map"
			rationale:    "Cross-BC interactions (FCE inbound command-handlers + TCM advisory event-consumer + ATO/REW outbound event-publishers + DRC future reverse-settlement) + external refs (ext-spi-bacen, ext-str-bacen, ext-sitraf-cip, ext-siloc-cip, ext-swift-network, ext-partner-bank-or-psti). Agente consulta para sourceContext em ACL events + cross-BC publication semantics."
			requiredSlices: [
				"BC interactions FCE/TCM/ATO/REW/DRC (cross-context relationships)",
				"external system refs (rails + partners + DICT)",
				"context-dependencies (read/write boundaries)",
			]
		}]
		estimatedBudget: "heavy"
	}

	// ============================================================
	// OBSERVABILITY
	// ============================================================

	observability: {
		signals: [{
			code:           "sig-mutation-executed"
			name:           "Mutation Executed"
			description:    "Info signal emitted post aggregate state transition completou (T2-T8). Routine success path indicator. Audit trail entry corresponde 1:1 per signal emission."
			coversCategory: "mutation"
			trigger:        "Aggregate handler completou state transition atomically + emitted resulting events."
			level:          "info"
			payloadFields: [
				"action-code",
				"attempt-id",
				"instruction-id",
				"lifecycle-transition",
				"timestamp",
			]
		}, {
			code:           "sig-validation-result"
			name:           "Validation Result"
			description:    "Info signal emitted post validation action produziu outcome. Routine; details captured em audit trail. Covers verification, classification, rail selection, reconciliation computation, observation-normalization."
			coversCategory: "validation"
			trigger:        "Validation action completou outcome computation (verified/rejected/eligible/selected/computed)."
			level:          "info"
			payloadFields: [
				"action-code",
				"attempt-id",
				"validation-outcome",
				"timestamp",
			]
		}, {
			code:           "sig-query-served"
			name:           "Query Served"
			description:    "Info signal emitted post projection query handler returned result. Side-channel filtering applied quando aplicável via prj-failure-classification."
			coversCategory: "query"
			trigger:        "Query handler returned result to caller (with appropriate filtering per caller identity)."
			level:          "info"
			payloadFields: [
				"action-code",
				"query-capability",
				"caller-identity-class",
				"visibility-level-applied",
				"timestamp",
			]
		}, {
			code:           "sig-escalation-triggered"
			name:           "Escalation Triggered"
			description:    "Warn signal emitted quando escalation criterion fired (any of 9 global + 4 per-action overrides). Channel + recipient + SLA materialized via governance envelope."
			coversCategory: "escalation"
			trigger:        "Escalation criterion matched (per cst-* onViolation=block-and-escalate firing OR observation patterns matching ec-* conditions)."
			level:          "warn"
			payloadFields: [
				"action-code",
				"attempt-id",
				"escalation-category",
				"escalation-rationale",
				"timestamp",
			]
		}, {
			code:           "sig-supervision-requested"
			name:           "Supervision Requested"
			description:    "Info-level signal emitted toda vez que action com autonomyLevel=propose-and-wait fica pending human gate approval. Phase 0 BKR pre-PMF: ~all mutations + 3 decide-* recommendations geram este signal. Promotion paths para execute-and-log Phase 1+ vivem em governance envelope; signal cadence é métrica de calibration."
			coversCategory: "escalation"
			trigger:        "Action invocation completou decision/preparation step; aguardando approval via supervised gate per governance envelope channel."
			level:          "info"
			payloadFields: [
				"action-code",
				"attempt-id",
				"instruction-id",
				"decision-payload-summary",
				"wait-start-timestamp",
				"governance-channel",
			]
		}, {
			code:           "sig-constraint-violation"
			name:           "Constraint Violation"
			description:    "Error signal emitted quando any cst-* triggered onViolation=block-and-escalate. Halt + audit + escalate path."
			coversCategory: "validation"
			trigger:        "Constraint check failed during action execution; onViolation policy fired."
			level:          "error"
			payloadFields: [
				"action-code",
				"constraint-code",
				"derived-from-invariant",
				"violation-detail",
				"attempt-id",
				"timestamp",
			]
		}, {
			code:           "sig-reconciliation-outcome-emitted"
			name:           "Reconciliation Outcome Emitted"
			description:    "Info signal emitted quando svc-reconciliation completou trichotomic outcome (finalized | failed | indeterminate). evt-reconciliation-completed published internal; pol-reconciliation-outcome-routing triggered subsequent."
			coversCategory: "validation"
			trigger:        "svc-reconciliation completou 4-conditions evaluation; outcome discriminator determined."
			level:          "info"
			payloadFields: [
				"attempt-id",
				"instruction-id",
				"rail-reference-id",
				"outcome",
				"indeterminacy-reason",
				"failure-classification-reference",
				"timestamp",
			]
		}, {
			code:           "sig-indeterminate-state-entered"
			name:           "Indeterminate State Entered"
			description:    "Warn signal emitted quando aggregate transitioned T6 (in-flight → indeterminate). Persistence drives ec-indeterminate-state-exceeds-operational-window se exceder rail window; resolution explicit via act-decide-indeterminate-resolution + act-execute-indeterminate-resolution required."
			coversCategory: "mutation"
			trigger:        "Aggregate handler completou T6 transition; state=indeterminate set; indeterminacyReason populated."
			level:          "warn"
			payloadFields: [
				"attempt-id",
				"instruction-id",
				"indeterminacy-reason",
				"rail-reference-id",
				"timestamp",
			]
		}, {
			code:           "sig-rail-status-divergence"
			name:           "Rail Status Divergence"
			description:    "Warn signal emitted quando partner/PSTI rail status feed diverges from internal cache OR shows operational degradation pattern. Informs retry policy + classification subsequent + svc-technical-rail-selection critério (a) re-evaluation."
			coversCategory: "validation"
			trigger:        "act-update-rail-availability-state detectou divergence vs cache anterior OR degradation pattern observed."
			level:          "warn"
			payloadFields: [
				"rail",
				"current-status",
				"previous-status",
				"divergence-type",
				"timestamp",
			]
		}, {
			code:           "sig-double-settlement-suspicion"
			name:           "Double Settlement Suspicion"
			description:    "Critical signal emitted when BKR detects multiple settlement confirmations for the same attemptId across separate paths — e.g., idempotencyKey hit but provider confirms second dispatch despite no-op response; OR rail emits second SettlementFinalized for same instructionId+attemptId across distinct dispatch paths; OR reconciled-completed event emitted twice for same attempt. Triggers ec-double-settlement-detected escalation imediata."
			coversCategory: "escalation"
			trigger:        "Detection algorithm em svc-reconciliation: matches (instructionId, attemptId) against historical SettlementFinalized events; conflict on rail-side confirmation count > 1 OR cross-rail confirmations for same attempt."
			level:          "critical"
			payloadFields: [
				"instruction-id",
				"attempt-id",
				"conflicting-signal-ids",
				"rail-reference-ids-observed",
				"settlement-confirmations-count",
				"timestamp",
				"detection-rule-version",
			]
		}]

		auditTrail: {
			requiredFields: [
				"timestamp",
				"agent-id",
				"action-code",
				"input-summary",
				"output-summary",
				"decision-rationale",
				"governance-version",
				"instruction-id",
				"attempt-id",
				"rail-reference-id",
				"failure-classification-tuple",
				"authorization-proof-reference",
				"lifecycle-transition",
			]
			storageHint: "Append-only event log materializado via prj-audit-trail projection (per Phase 3 domain-model). Imutabilidade garantida por construção; cada query retorna snapshot ordered per filter parameters. Storage layer detail vive em Architecture Communication Canvas."
			rationale:   "13 fields = 7 minimum regulatory-grade + 6 BKR-specific. Domain-specific selection: (a) instruction-id cross-BC business correlation (FCE-owned lineage); (b) attempt-id execution lineage (BKR retry forensics); (c) rail-reference-id cross-system rail forensics (per glossary term-rail-reference-id); (d) failure-classification-tuple para classification routing audit + side-channel forensic review; (e) authorization-proof-reference (hash/reference ONLY, never proof payload itself — preserves cryptographic boundary); (f) lifecycle-transition para state machine replay reconstruction sem depender de input-summary/output-summary parse. Reconstrução completa de decisão + outcome + state machine possível dado os 13 fields. Per inv-anti-decision-boundary: audit é o mecanismo de prova retroativa que agente não exerceu decisão econômica."
		}
	}

	// ============================================================
	// OUTER RATIONALE
	// ============================================================

	rationale: """
		Agent spec BKR primary materializa Phase 4 do WI-062 BKR
		bootstrap. Único agent do BC Phase 0 (specialist/integration/
		validation agents em waves futuras). Opera sobre o único
		aggregate agg-settlement-attempt + 3 cross-source domain
		services + 2 policies + 3 projections do Phase 3 domain-model.

		Composição final do agent-spec:
		- operationalScope full surface (1 agg + 6 cmds + 13 events
		  + 9 invariants + 3 projections — incluindo ACL events
		  porque agent observa stream local mesmo não sendo author
		  semântico)
		- 16 actions (8 propose-and-wait mutations + decide-*
		  recommendations supervisadas Phase 0; 8 execute-and-log
		  validations deterministic + queries + observation + escalation)
		- 3 decision-vs-execution splits (tq-agg-09): dispatch
		  irreversibility rail-side; cancellation rail-side NON-
		  GUARANTEED request; indeterminate epistemic collapse
		  canonicalization
		- 9 constraints (1:1 invariant coverage tq-agg-02 perfect;
		  todas onViolation=block-and-escalate regulatory-grade)
		- 9 escalationConditions global (mapeando canvas Phase 1.5 ec-*
		  para 5 schema categories: 3 suspicious-input + 3 conflicting-
		  signals + 1 insufficient-context + 1 ambiguous-case + 1
		  out-of-scope) + 4 per-action overrides (tq-agg-08) declarados
		  em rationale de actions específicas
		- 5 contextRequirements artifacts (canvas + domain-model +
		  glossary + agent-governance forward-ref Phase 5 + context-map)
		  com estimatedBudget=heavy
		- 10 observability signals (6 canonical PG recurrence + 4
		  BKR domain-specific) cobrindo 4 action categories +
		  payloadFields per signal para audit forensic granular
		- 13 auditTrail fields (7 minimum regulatory + 6 BKR-specific
		  incluindo lifecycle-transition para state machine replay
		  reconstruction)

		Identidade canônica preservada: agente BKR executa decisões
		técnicas determinísticas; nunca transforma em decisão
		econômica. Esta direction founder Phase 4 materializada via:
		(a) 16 actions classificadas: 4 validation pure + 5 mutation
		(todas propose-and-wait Phase 0) + 3 decide-* recommendation
		(read-only, propose-and-wait) + 2 query + 1 escalation +
		1 observation-normalization; zero actions econômicas; (b) 9
		cst-* 1:1 invariant coverage com sole-enforcer detection per
		tq-agg-10 — agente OBSERVA/VALIDA/PROPÕE, aggregate handler
		+ lifecycle + svcs + schema SEGURAM invariants; (c) audit
		trail 13 fields documenta prova retroativa de que agente
		nunca exerceu decisão econômica (authorization-proof-
		reference como hash never payload; lifecycle-transition para
		replay; failure-classification-tuple para classification
		ownership audit).

		Canonical test domínio-é-centro (tq-agg-10) passa: para
		cada invariant, real enforcer é aggregate+lifecycle+svcs+
		schema; agente é operator (observe + validate + propose +
		invoke). Se removido o agente do BC, sistema ainda protege
		os 9 invariants (aggregate handler rejects commands;
		lifecycle guards block invalid transitions; svcs produzem
		outputs deterministic; schema constraints definem boundary).

		5 lenses aplicadas:
		- lens-ai-agent-governance (primária): autonomyLevel matrix
		  + escalation taxonomy + observability contract; 3 decision-
		  vs-execution splits aplicados em criticality divergente
		- lens-security-trust-infrastructure (secundária):
		  inputTrustLevel per action; cryptographic boundary via
		  authorization-proof-reference hash never payload; side-
		  channel filtering em prj-failure-classification
		- lens-regulatory-compliance-as-architecture (terciária):
		  9:9 cst-* invariant coverage; regulatory boundary halt +
		  escalate (no heuristic adaptation per cst-rail-selection-
		  technical-only + ec-regulatory-boundary-misalignment);
		  audit trail 13 fields regulatory-grade

		Phase 4 sub-phases pre-write: 4.1 scope + 13 actions skeleton
		(later expanded para 16 via 3 splits founder direction); 4.2
		autonomy/trust/impact matrix; 4.3 constraints + escalation;
		4.4 context + observability + audit; 4.5 write único; 4.6
		SRR closure. Founder iterative review aplicou 20+ ajustes
		finos pre-write distribuídos.

		Forward-looking acknowledged: agent-governance envelope
		Phase 5 separate file (bkr-primary-agent.governance.cue);
		Phase 1+ promotion de execute-and-log autonomy para
		mutations atualmente propose-and-wait vive em governance
		calibration dinâmica, não em spec; specialist/integration/
		validation agents em waves futuras quando volume operacional
		justificar; api-spec + async-api-spec contextRequirements
		emergem quando contracts cristalizarem (Phase futura).
		"""
}
