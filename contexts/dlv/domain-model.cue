package dlv

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-model.cue — Domain Model: Delivery & Verification.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Domain model do BC DLV — quinto BC do macrofluxo Mesh (SSC →
// {P2P, CTR} → CMT → BDG → DLV → INV → FCE). Phase 3 do WI-042
// pos-canvas Phase 1 closure (commits bb6c4ee..2421810) +
// glossary Phase 2 (commit d5bc9a8). Materializa propriedades
// formais como CUE constraints validáveis via cue vet —
// transforma DLV de "conjunto de regras" em "sistema formal
// onde violações viram erro de compilação" (founder framing).
//
// Decisões estruturais aprovadas pre-write (4 ajustes founder):
// (1) 1 aggregate root apenas — Verification (NÃO 2); EvidenceRecord
//     vira Entity interna dentro de Verification com identity intrínseca
// (2) INV-D1 atomic emit reclassificado como design invariant (ADR
//     responsibility, NÃO CUE-codable — runtime atomicity guarantee
//     via transactional outbox pattern Phase 3 implementação)
// (3) State machine simplificada: 4 states + flag (evaluating +
//     exception-pending + verified + rejected; pending-evaluation
//     removido — vive em CMT; evaluating-pending-criteria vira flag
//     pendingCriteria derivada de criteriaVersion absent)
// (4) ApplySupersession reclassificado como event-handler (Policy
//     pol-supersession-applied-handler), NÃO command — supersession
//     é REAÇÃO ao LOG event, não decisão DLV (anti-mini-NIM BD5)
//
// 3 micro-ajustes founder aplicados:
// (a) pendingCriteria DERIVED de criteriaVersion absence (não bool
//     arbitrário) — Part 2 lifecycle
// (b) eventLogOffset escopo claro: ingestion offset (em
//     EvidenceRecord) vs decision offset (em terminal Verification
//     event) — ambos presentes
// (c) INV-8 estruturalmente segura via finalityReached flag (NÃO
//     "now > finalityAt" — CUE não conhece tempo runtime) — Part 2
//
// Materializado em 3 partes incrementais (cada parte deixa
// domain-model.cue em shape válido cue vet ./...):
//   Part 1 — Catalogs + Aggregate Skeleton (este commit):
//            11 VOs + 7 events + 3 commands + 14 invariants
//            + Verification skeleton (rootIdentity + wiring;
//            SEM entity, SEM lifecycle)
//   Part 2 — Aggregate Completion: entity ent-evidence-record
//            embedded + lifecycle state machine 4 states +
//            transitions com guards
//   Part 3 — Projections + Policy + Outer Rationale: 5 prj-* +
//            1 pol-* (event-handler supersession) + outer
//            rationale completo
//
// Boundary preservation transversal (anti-mini-NIM BND-1..4):
// - BND-1: NO numeric-statistical fields em event payloads
// - BND-2: criteriaVersion DEVE referenciar CMT existing (NÃO
//   inferida)
// - BND-3: supersession é ordering canonical (NÃO seleção entre
//   evidências) per BD5
// - BND-4: verificationMetrics são observation-only (NÃO input
//   para command preconditions) per BD10

domainModel: artifact_schemas.#DomainModel & {
	code:              "dlv"
	name:              "Delivery & Verification"
	boundedContextRef: "dlv"

	// =============================================
	// DOMAIN EVENTS (7) — 2 published cross-BC + 5 internal
	// =============================================

	events: [
		// --- PUBLISHED (cross-BC; BD14 atomic emit; BD10 categorical payload) ---
		{
			code:        "evt-delivery-verified"
			name:        "Delivery Verified"
			description: "Verification atinge state terminal verified. Cross-BC published event consumido por INV (faturamento gate), REW (qualidade-de-execução signal), NIM (mecanismos design signal), DRC (post-verification dispute context per BD8 within finality window). Payload categórico determinístico per BD10 (NO scoring fields)."
			rationale:   "Terminal event canonical do happy path DLV. Hard binding cross-BC: INV consume como precondition de invoice issuance; REW como input categórico para credit scoring (BD10 boundary preserved); NIM como signal para mechanism design; DRC como contexto pós-verification."
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:     "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:       "vo-evidence-ref"},
				{kind: "value-object-ref", name: "criteriaVersion", valueObjectRef:   "vo-criteria-version"},
				{kind: "primitive", name: "decidedAt", type:                          "integer", description: "DLV system time (replay-safe per BD3)"},
				{kind: "primitive", name: "finalityAt", type:                         "integer", description: "decidedAt + 30d Phase 0 per BD8"},
				{kind: "primitive", name: "decidedBy", type:                          "string", description: "actor identifier (agt-dlv-primary OR founder via supervisedDecision)"},
				{kind: "value-object-ref", name: "integrityProofRef", valueObjectRef: "vo-integrity-proof-ref"},
				{kind: "value-object-ref", name: "supersededByRef", valueObjectRef:   "vo-evidence-ref", description: "presente apenas se Verification anterior foi superseded por nova evidence (per BD5)"},
				{kind: "value-object-ref", name: "eventLogOffset", valueObjectRef:    "vo-event-log-offset", description: "decision offset (terminal event position no Event Log)"},
			]
		},
		{
			code:        "evt-delivery-rejected"
			name:        "Delivery Rejected"
			description: "Verification atinge state terminal rejected. Cross-BC published event mesmo conjunto de consumers que DeliveryVerified com semantics distintas: INV bloqueia invoice path; REW signal negativo para scoring; NIM signal para mechanism design (e.g., padrões sustained de rejection sinalizam criteria evolution need); DRC entry point IMEDIATO de dispute Phase 0 per BD8. reasonCode + retryPath MANDATORY per BD13 (silent rejection proibido)."
			rationale:   "Terminal event canonical do rejection path DLV. Mandatory reasonCode + retryPath fornece accountability + actionable contract com sh-02 fornecedor (retry path determinístico via mapping table per BD13)."
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:     "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:       "vo-evidence-ref"},
				{kind: "value-object-ref", name: "criteriaVersion", valueObjectRef:   "vo-criteria-version"},
				{kind: "value-object-ref", name: "reasonCode", valueObjectRef:        "vo-reason-code", description: "MANDATORY per BD13"},
				{kind: "value-object-ref", name: "retryPath", valueObjectRef:         "vo-retry-path", description: "MANDATORY per BD13; deterministic mapping de (reasonCode, criteriaVersion-context, finality-state)"},
				{kind: "primitive", name: "decidedAt", type:                          "integer"},
				{kind: "primitive", name: "finalityAt", type:                         "integer"},
				{kind: "primitive", name: "decidedBy", type:                          "string"},
				{kind: "value-object-ref", name: "integrityProofRef", valueObjectRef: "vo-integrity-proof-ref"},
				{kind: "value-object-ref", name: "supersededByRef", valueObjectRef:   "vo-evidence-ref", description: "presente se rejected por evidence-superseded reasonCode"},
				{kind: "value-object-ref", name: "eventLogOffset", valueObjectRef:    "vo-event-log-offset"},
			]
		},

		// --- INTERNAL (DLV-only; NÃO publicados cross-BC per BD4) ---
		{
			code:        "evt-evidence-recorded"
			name:        "Evidence Recorded"
			description: "EvidenceRecord entity criada via RecordEvidence command OR EvidenceCommitted LOG ACL consumption. Marker de aggregate creation per BD4 ingestion-evaluation-separation. INTERNAL — NÃO publicado cross-BC (visibility=internal per BD4)."
			rationale:   "Marker de Verification aggregate creation com EvidenceRecord embedded; trigger interno de evaluation eligibility. Phase 0 evaluation requer cmd-evaluate-verification subsequent (sync). Phase 1+ eventual evaluation policy poderia consumir este event."
			visibility:  "internal"
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:     "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:       "vo-evidence-ref"},
				{kind: "value-object-ref", name: "integrityProofRef", valueObjectRef: "vo-integrity-proof-ref"},
				{kind: "primitive", name: "recordedAt", type:                         "integer", description: "DLV system time ingestion-time"},
				{kind: "value-object-ref", name: "eventLogOffset", valueObjectRef:    "vo-event-log-offset", description: "ingestion offset (distinto de decision offset)"},
			]
		},
		{
			code:        "evt-exception-entered"
			name:        "Exception Entered"
			description: "Verification transiciona de evaluating para exception-pending state. Marca primeiro entry em exceptionHistory per BD6. INTERNAL — exception states são internos a DLV (NÃO publicados cross-BC; expostos apenas via QueryVerificationStatus query-surface internal-consumers-only)."
			rationale:   "Trigger de timer 14d mandatory transition (BD6). Inicia tracking de exceptionHistory append-only. Estado intermediário internal preserva contract público limpo (apenas terminal events cross-BC)."
			visibility:  "internal"
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef: "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:   "vo-evidence-ref"},
				{kind: "value-object-ref", name: "exceptionEntry", valueObjectRef: "vo-exception-entry", description: "first entry com reason + timestamp + triggeredBy"},
				{kind: "value-object-ref", name: "eventLogOffset", valueObjectRef: "vo-event-log-offset"},
			]
		},
		{
			code:        "evt-exception-extended"
			name:        "Exception Extended"
			description: "Extension de timer aplicada via supervisedDecision extend-exception-window (BD6). Adiciona entry em exceptionHistory; cumulative duration cap 30d TOTAL desde primeiro entry preservado por construção. INTERNAL."
			rationale:   "Trigger de extension cumulativa bounded por construção (BD6 cap absoluto). exceptionHistory append-only preserva granularidade temporal + actor + justification per audit."
			visibility:  "internal"
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef: "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:   "vo-evidence-ref"},
				{kind: "value-object-ref", name: "exceptionEntry", valueObjectRef: "vo-exception-entry", description: "extension entry com reason=extend-exception-window + actor"},
				{kind: "primitive", name: "newDeadline", type:                    "integer", description: "novo timer deadline absoluto (DLV system time)"},
				{kind: "value-object-ref", name: "eventLogOffset", valueObjectRef: "vo-event-log-offset"},
			]
		},
		{
			code:        "evt-exception-resolved"
			name:        "Exception Resolved"
			description: "Verification transiciona de exception-pending para terminal (verified | rejected) — humano resolveu OU timer fired auto-rejection per BD6 fail-safe. Marca último entry em exceptionHistory com resolvedAt + resolution. INTERNAL — terminal event público correspondente é DeliveryVerified | DeliveryRejected emitido atomicamente."
			rationale:   "Marker de exception lifecycle closure. Distinct de DeliveryVerified | DeliveryRejected: aquele é cross-BC public (BD14 atomic emit); este é DLV-internal tracking de exception transition (paralelo + atomic)."
			visibility:  "internal"
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:    "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:      "vo-evidence-ref"},
				{kind: "value-object-ref", name: "resolution", valueObjectRef:       "vo-decision-outcome", description: "verified | rejected outcome"},
				{kind: "primitive", name: "resolvedAt", type:                        "integer", description: "DLV system time"},
				{kind: "primitive", name: "resolutionType", type:                    "string", description: "human-resolved | timeout-forced (BD6 fail-safe)"},
				{kind: "value-object-ref", name: "eventLogOffset", valueObjectRef:   "vo-event-log-offset"},
			]
		},
		{
			code:        "evt-supersession-applied"
			name:        "Supersession Applied"
			description: "Linkage de supersession aplicada per BD5: evidenceRef-N+1 supersedes evidenceRef-N para mesmo commitmentRef. Trigger de nova Verification aggregate creation com nova IdempotencyIdentity (commitmentRef, evidenceRef-N+1). INTERNAL — public correspondence é nova DeliveryVerified | DeliveryRejected da nova evaluation."
			rationale:   "Marker de supersession lineage explícita. Trigger primário: EvidenceSuperseded LOG event consumed via ACL (Policy pol-supersession-applied-handler — Part 3); fallback: DLV ordering canonical eventLogOffset em ausência de LOG event (BD5 robust-against-failure-of-adjacent-BC)."
			visibility:  "internal"
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:        "vo-commitment-ref"},
				{kind: "value-object-ref", name: "supersededEvidenceRef", valueObjectRef: "vo-evidence-ref", description: "evidenceRef-N (supersedida)"},
				{kind: "value-object-ref", name: "supersedingEvidenceRef", valueObjectRef: "vo-evidence-ref", description: "evidenceRef-N+1 (canonical-current)"},
				{kind: "primitive", name: "lineageSource", type:                         "string", description: "log-declared | dlv-fallback-ordering (per BD5 dual path)"},
				{kind: "value-object-ref", name: "eventLogOffset", valueObjectRef:       "vo-event-log-offset"},
			]
		},
	]

	// =============================================
	// COMMANDS (3) — 2 user-invoked + 1 timer-driven internal
	// =============================================

	commands: [
		{
			code:        "cmd-record-evidence"
			name:        "Record Evidence"
			description: "Ingestion command: cria Verification aggregate com EvidenceRecord embedded. Sync. Trigger primário: EvidenceCommitted LOG event consumption (ACL); alternative: direct submission por sh-02/sh-01 (Phase 0 manual; Phase 1+ supplier API). Layer 1 integrity check parser-time per BD11 (local-first; network-independent). Falha integridade → command rejected sem side effects."
			rationale:   "Entry point ingestion path per BD4 separation. Cria Verification em state=evaluating com pendingCriteria flag derivada de criteriaVersion absence. INV-7 (verified requires evidence) é precondition por construção: sem cmd-record-evidence success, NÃO existe EvidenceRecord, e cmd-evaluate-verification não pode emit verified."
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:     "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:       "vo-evidence-ref"},
				{kind: "value-object-ref", name: "integrityProofRef", valueObjectRef: "vo-integrity-proof-ref", description: "MANDATORY per BD11 (no implicit trust em LOG)"},
			]
		},
		{
			code:        "cmd-evaluate-verification"
			name:        "Evaluate Verification"
			description: "Core function execution: avalia EvidenceRecord contra criteriaVersion vigente (sync via QueryCommitmentCriteria Phase 0). Sync. Função pura sobre tripla causal (evidence ingerida, criteriaVersion snapshot, integrityProof) per BD1 RECTOR + BD9 Layer 1+2. Outcome binário verified | rejected; OR transição para exception-pending (estado intermediário internal per BD12)."
			rationale:   "Trigger primário do gate determinístico. Função pura per BD1 (sem julgamento, sem inferência probabilística, sem estado externo). Cache miss criteria → estado evaluating com pendingCriteria=true (await criteria activation). INV-13 retry path deterministic via mapping table aplicado em rejected outcome."
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef: "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:   "vo-evidence-ref"},
			]
		},
		{
			code:        "cmd-transition-exception-state"
			name:        "Transition Exception State"
			description: "Timer-driven internal command: força transição de exception-pending para terminal state quando 14d timer fires per BD6. Resultado: humano resolveu (terminal verified | rejected) OR auto-rejection forçada (rejected com reasonCode=exception-unresolved-timeout per BD6 fail-safe). Timer baseado em DLV system time (NÃO wall-clock) — replay-safe per BD3."
			rationale:   "P5 anti-paralysis materialização: garante forward motion sob indecisão humana sem comprometer invariante 'no evidence verified → no economic progression' (auto-rejection é fail-safe, NÃO fail-open). Timer-driven preserva determinismo replay (events ingerida sob mesma timeline produzem mesmas transições)."
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef: "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:   "vo-evidence-ref"},
				{kind: "primitive", name: "currentTime", type:                    "integer", description: "DLV system time at trigger (replay input)"},
			]
		},
	]

	// =============================================
	// INVARIANTS (14) — schema-codable executable + 1 design ADR'd separately
	// =============================================

	invariants: [
		// --- Identity (3) ---
		{
			code:      "inv-identity-uniqueness"
			name:      "Identity Uniqueness"
			rule:      "Para todo aggregate Verification: a tupla (commitmentRef, evidenceRef) é storage identity unique. Duas Verifications NÃO podem coexistir com mesma identidade per BD2 IdempotencyIdentity."
			rationale: "Idempotency precondition: at-least-once delivery em sistemas event-driven exige unique constraint sobre identity tuple. Sem isso, retry de cmd-record-evidence ou re-publication de EvidenceCommitted gera duplicatas com outcomes potencialmente divergentes."
		},
		{
			code:      "inv-criteria-version-as-attribute"
			name:      "CriteriaVersion as Attribute, Not Identity"
			rule:      "Para todo aggregate Verification: criteriaVersion é ATTRIBUTE da decisão emitida, NÃO componente da identity tuple. Identity = (commitmentRef, evidenceRef) apenas; criteriaVersion vive em fields."
			rationale: "Decisão crítica V6 (BD2): incluir criteriaVersion na identity significaria que upgrade de criteria invalidaria verifications passadas (forçando re-evaluation), quebrando economic finality + replay determinism. criteriaVersion-as-attribute permite coexistência de verifications sob versões distintas."
		},
		{
			code:      "inv-identity-immutable-across-state"
			name:      "Identity Immutable Across State Transitions"
			rule:      "Para todo aggregate Verification: campos da identity (commitmentRef, evidenceRef) são immutable durante state transitions. State machine opera sobre identity fixa; aggregate não migra identity."
			rationale: "Identity stability é precondition de audit trail consistency + replay determinism. Sem imutabilidade, supersession ficaria ambígua (qual identity foi superseded?) e replay produziria histórias divergentes."
		},

		// --- Decision (3) ---
		{
			code:      "inv-binary-outcome"
			name:      "Binary Outcome"
			rule:      "Para todo aggregate Verification em terminal state: outcome ∈ {verified, rejected}. NÃO existe terceiro estado terminal (insufficient é tratado como rejected + reasonCode=insufficient-evidence per BD1)."
			rationale: "RECTOR thesis-invariant per BD1. Terceiro estado 'insufficient' criaria ambiguidade operacional downstream (INV/REW/FCE precisam decidir ou esperar?) — viola single-source-of-truth do macrofluxo."
		},
		{
			code:      "inv-rejected-requires-rationale"
			name:      "Rejected Requires Rationale"
			rule:      "Para todo evt-delivery-rejected emit: reasonCode PRESENTE + retryPath PRESENTE (ambos mandatory per BD13). Silent rejection (rejected sem rationale auditável) é estruturalmente proibido."
			rationale: "Anti-silent-rejection per BD13. Cada rejeição é justificada categoricamente (reasonCode) + actionable (retryPath). Sem isso, sh-02 fornecedor não distingue rejeição legítima de bias adversarial."
		},
		{
			code:      "inv-retry-path-deterministic"
			name:      "RetryPath Deterministic Function"
			rule:      "Para todo evt-delivery-rejected: retryPath é função determinística de (reasonCode, criteriaVersion-context, finality-state) via schema mapping table per BD13. NÃO atribuído arbitrariamente pelo executor; replay sob mesma timeline produz mesmo retryPath signal."
			rationale: "Replay-safety per BD3: se retryPath fosse atribuído arbitrariamente, replay produziria signals divergentes para mesma decisão histórica. Mapping table parte do schema é hard guarantee."
		},

		// --- Evidence (1) ---
		{
			code:      "inv-verified-requires-evidence-or-override"
			name:      "Verified Requires Evidence or Emergency Override"
			rule:      "Para todo evt-delivery-verified emit: ∃ EvidenceRecord precedente para mesma identity (commitmentRef, evidenceRef) OR ∃ supervisedDecision approve-with-emergency-override autorizado per BD7. Verified NUNCA emerge silenciosamente sem evidence ou override."
			rationale: "Anti-fraude estrutural RECTOR-adjacent per BD7. Bloqueia classe de bugs por construção: nenhum caminho de código produz verified silencioso (timeout, default, inferência, race condition). Verificable via verificationMetric tripwire 'verified-without-evidence-or-override-attempts' (deve = 0; non-zero = critical bug)."
		},

		// --- Finality (2) ---
		{
			code:      "inv-post-finality-no-autonomous-emit"
			name:      "Post-Finality No Autonomous Emit"
			rule:      "Para todo aggregate Verification com finalityReached=true: emit de superseding Verification AUTONOMAMENTE é PROHIBITED per BD8. Superseding pós-finality requer caminho controlado: supervisedDecision approve-post-finality-supersession (path A) OR DRC-driven correction (path B Phase 1+)."
			rationale: "BD8 hard line preserva finality forte como contrato econômico estável para downstream INV/REW/FCE/DRC sem cegueira sistêmica. finalityReached é flag estrutural (NÃO depende de 'now > finalityAt' runtime — CUE não conhece tempo atual)."
		},
		{
			code:      "inv-finality-at-computed"
			name:      "FinalityAt Computed"
			rule:      "Para todo aggregate Verification em terminal state: finalityAt = decidedAt + 30 days (Phase 0 hard-coded; parameterização per criteria type Phase 1+ via oq-dlv-2). Computed field, NÃO arbitrariamente assigned."
			rationale: "Window calibration centralized via single computation rule. Phase 0 baseline 30d alinhado com V6 finality contract + CMT formalization typical timeline B2B brasileiro. Phase 1+ promotion via tension-entry → deferred-decision → ADR pipeline per esc-post-finality-correction-rate-sustained breach."
		},

		// --- Exception (3) ---
		{
			code:      "inv-exception-cumulative-cap"
			name:      "Exception Cumulative Cap 30 Days"
			rule:      "Para todo aggregate Verification: cumulative duration de exceptionHistory desde firstEntry.timestamp até terminalEntry.timestamp ≤ 30 dias (cap absoluto BD6). Extensions cumulativas adicionam tempo ao timer existente; NÃO reiniciam o relógio do primeiro entry."
			rationale: "P2 BOUNDED principle materialização: founder pode estender mas com cap absoluto. cap-por-cumulativo (vs cap-por-extensão) evita escape via múltiplas extensions pequenas. Bounded blast radius temporal preservado por construção."
		},
		{
			code:      "inv-at-most-one-active-exception"
			name:      "At Most One Active Exception"
			rule:      "Para todo aggregate Verification: at most ONE entry em exceptionHistory sem resolvedAt at any time (estado vigente único per BD6 — exception-during-exception proibido por construção)."
			rationale: "Estado único + exceptionHistory append-only preserva granularidade temporal sem permitir explosão de estado. Estado é projeção determinística do último entry sem resolvedAt; histórico é rico (auditor pode reconstruir sequência completa)."
		},
		{
			code:      "inv-exception-timer-mandatory"
			name:      "Exception Timer Mandatory Transition"
			rule:      "Para todo aggregate Verification entrando em exception-pending state: terminal transition (verified | rejected) mandatory dentro de 14 dias desde firstEntry.timestamp (Phase 0 hard-coded; Phase 1+ parameterizable per oq-dlv-7). Auto-rejection forçada com reasonCode=exception-unresolved-timeout per BD6 fail-safe forward motion."
			rationale: "P5 anti-paralysis fail-safe: preserva forward motion sob indecisão humana sem comprometer invariante 'no evidence verified → no economic progression'. fail-safe é rejected (NÃO fail-open verified)."
		},

		// --- Atomicity & Ordering (2 — INV-D1 atomic emit reclassificado design invariant Part 3 outer rationale) ---
		{
			code:      "inv-supersession-ordering"
			name:      "Supersession Ordering Canonical"
			rule:      "Para toda supersession (evt-supersession-applied): ordering canonical via eventLogOffset(supersedingEvidenceRef) > eventLogOffset(supersededEvidenceRef), com hash tie-breaker (SHA-256 lexicographic) se offsets equal. Globally deterministic per BD5."
			rationale: "Replay-safety + idempotency: ordering ancorada em Event Log offset elimina race conditions cross-ingestion-paths. Tie-breaker absorve empates teóricos (improbable dado single-writer Event Log Phase 0; preservado como safety net)."
			dependsOnAggregateState: {
				aggregateRef: "agg-verification"
				accessVia: {
					kind:          "projection"
					projectionRef: "prj-evidence-lineage"
				}
				rationale: "Ordering invariant requer comparação cross-Verification (multiple identidades sob mesmo commitmentRef). Projeção evidence-lineage (Part 3) materializa ordering canonical para queries determinísticas."
			}
		},
		{
			code:      "inv-replay-determinism"
			name:      "Replay Determinism"
			rule:      "Para toda execução de replay sobre mesmo Event Log até offset K: produz mesma Verification state at offset K. Property-based test verificável: ∀ replay execution sob mesma timeline → mesmo outcome."
			rationale: "Precondition de forensic audit Lei 12.846/SCD/CVM (5 anos retention) + DRC dispute resolution. Property-based test é gate de regressão; CUE constraints estruturam aggregates para que replay seja deterministic by construction."
		},
	]

	// =============================================
	// VALUE OBJECTS (11) — catálogo top-level reusable
	// =============================================

	valueObjects: [
		{
			code:        "vo-commitment-ref"
			name:        "Commitment Reference"
			description: "Identificador único do compromisso econômico (owned por CMT) que delimita o escopo de avaliação DLV. Eixo de agregação de evidências, escopo de supersession lineage, componente da IdempotencyIdentity. Cross-BC reference: commitments existem em CMT; DLV consume."
			fields: [{kind: "primitive", name: "value", type: "string"}]
			constraints: [
				"format regex: ^cmt-[a-z0-9-]+$ (CMT-owned format)",
				"immutable após criação de Verification associada",
			]
			rationale: "Sem termo canônico, commitmentRef vira variável implícita. Explicitar como VO catalog permite type safety + boundary preservation CMT↔DLV."
		},
		{
			code:        "vo-evidence-ref"
			name:        "Evidence Reference"
			description: "Identificador único de uma Evidência dentro do contexto de uma CommitmentRef. Componente da IdempotencyIdentity. Distinct evidenceRefs sob mesmo commitmentRef ordenam-se via Supersessão (ordering canonical via eventLogOffset + hash tie-breaker per BD5)."
			fields: [{kind: "primitive", name: "value", type: "string"}]
			constraints: [
				"format regex: ^evt-[a-z0-9-]+$ (LOG-owned format)",
				"immutable após ingestion via cmd-record-evidence",
			]
			rationale: "Permite multiple evidências sob mesmo commitment (correção de evidence original via supersession) sem ambiguidade. Boundary LOG↔DLV preserved."
		},
		{
			code:        "vo-event-log-offset"
			name:        "Event Log Offset"
			description: "Posição canônica monotônica globalmente determinística de um evento no Event Log. Fonte canonical de ordering em Supersessão (BD5), at-most-once cross-BC observability (BD14c), replay determinism (BD3). Independente de wall-clock externo."
			fields: [{kind: "primitive", name: "value", type: "integer"}]
			constraints: [
				"value >= 0",
				"monotonic globally per Event Log (single-writer Phase 0)",
				"replay-safe by construction (não wall-clock dependency)",
			]
			rationale: "Eixo determinístico mais crítico do BC. Distinct semântico de timestamp (que é wall-clock sujeito a skew/drift). Dois usos distintos: ingestion offset (em EvidenceRecord) vs decision offset (em terminal Verification event)."
		},
		{
			code:        "vo-idempotency-identity"
			name:        "Idempotency Identity"
			description: "Tupla canônica composta (commitmentRef, evidenceRef) que define unicidade de avaliação em DLV per BD2. criteriaVersion é ATTRIBUTE da decisão emitida, NÃO componente da identidade — deliberado: criteria upgrade NÃO invalida verifications históricas (preserva economic finality + replay determinism)."
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef: "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:   "vo-evidence-ref"},
			]
			constraints: [
				"NÃO inclui criteriaVersion (per BD2 deliberate decision)",
				"storage layer DLV exige unique constraint sobre tupla per inv-identity-uniqueness",
			]
			rationale: "Identity composta canonical do Verification aggregate root. Distinct de 'identidade da Verificação' (que inclui criteriaVersion como attribute imutável); IdempotencyIdentity exclui criteriaVersion para permitir coexistência de versões."
		},
		{
			code:        "vo-integrity-proof-ref"
			name:        "Integrity Proof Reference"
			description: "Cryptographic proof reference DSSE-anchored gerada por IDC verificável LOCALMENTE por DLV. Hash-anchored format. Verificação dual: Layer 1 ingestion-time syntax check per BD11 + Layer 1 evaluation-time deep semantic check per BD9 (opcional Phase 0 com fail-safe fallback)."
			fields: [{kind: "primitive", name: "value", type: "string"}]
			constraints: [
				"format regex: ^proof-[a-f0-9]+$ (hash-anchored)",
				"local-first verifiable (DSSE complete payload OR offline snapshot per BD11)",
				"network-independent ingestion path (cc-03 24/7 precondition)",
			]
			rationale: "Distinção integridade vs verdade per BD9: cryptographic proof prova autenticidade do signatário, NÃO truth do conteúdo. Layer 1 de Defense in Depth — necessário mas não suficiente."
		},
		{
			code:        "vo-criteria-version"
			name:        "Criteria Version"
			description: "Snapshot imutável hash-anchored de criteria owned por CMT. DLV consume via criteriaVersion attribute (NÃO identity component per BD2). Mutation in-place proibida — criteria evolution exige nova version. Habilita replay determinism (BD3) sob critérios vigentes à época."
			fields: [{kind: "primitive", name: "value", type: "string"}]
			constraints: [
				"format regex: ^cv-[a-f0-9]+$ (hash-anchored CMT snapshot)",
				"immutable (mutation in-place proibida por construção)",
				"reference DEVE existir em CMT (per BND-2 anti-criteria-inference)",
			]
			rationale: "Versioning explícito é precondition de replay determinism + economic finality. Sem hash-anchored snapshot, criteria drift retroativamente invalidaria histórico."
		},
		{
			code:        "vo-reason-code"
			name:        "Reason Code"
			description: "Categoria estrutural taxonomy aberta anexada a toda decisão emitida. Mandatory em rejected per inv-rejected-requires-rationale. Categorias canônicas Phase 0: integrity-proof-unverifiable-local, integrity-failure, cross-evidence-inconsistency-{class}, insufficient-evidence, criteria-mismatch, evidence-superseded, exception-emergency-override, post-finality-correction, drc-driven-correction, criteria-version-override-applied, exception-resolved-{outcome}, exception-unresolved-timeout."
			fields: [{kind: "primitive", name: "value", type: "string"}]
			constraints: [
				"format regex: ^[a-z][a-z0-9-]+$",
				"taxonomy aberta com categorias canônicas Phase 0 (extensions Phase 1+ via criteriaVersion declaration)",
				"mandatory em DeliveryRejected events per BD13",
			]
			rationale: "Anti-silent-rejection estrutural: cada decisão é auditável via reasonCode categórico. Distinct de scoring (numérico-statistical) per BD10."
		},
		{
			code:        "vo-retry-path"
			name:        "Retry Path"
			description: "Signal estrutural categórico anexado a DeliveryRejected events: retryable | non-retryable | exception. Função DETERMINÍSTICA de (reasonCode, criteriaVersion-context, finality-state) via schema mapping table per BD13. Mandatory em rejected."
			fields: [{kind: "primitive", name: "value", type: "string"}]
			constraints: [
				"enum: retryable | non-retryable | exception",
				"derived deterministically from (reasonCode, criteriaVersion-context, finality-state)",
				"mandatory em DeliveryRejected events per BD13",
			]
			rationale: "Actionable contract com sh-02 fornecedor + DRC. Determinismo preserva replay (BD3): replay sob mesma timeline produz mesmo retryPath signal."
		},
		{
			code:        "vo-decision-outcome"
			name:        "Decision Outcome"
			description: "Enum binário do outcome terminal de Verification per BD7 anti-default. NO third state (insufficient é tratado como rejected + reasonCode=insufficient-evidence per BD1)."
			fields: [{kind: "primitive", name: "value", type: "string"}]
			constraints: [
				"enum: verified | rejected (binário per BD7)",
				"NO third state (insufficient → rejected + reasonCode)",
			]
			rationale: "RECTOR thesis-invariant per BD1 + anti-default per BD7. Binário elimina ambiguidade operacional downstream."
		},
		{
			code:        "vo-verification-state"
			name:        "Verification State"
			description: "Enum dos states do Verification aggregate state machine per BD6 + canvas Phase 1.5: evaluating (transient com pendingCriteria flag derivada) + exception-pending (intermediário internal per BD12) + verified (terminal) + rejected (terminal). NO pending-evaluation state em DLV (commitments sem evidence vivem em CMT)."
			fields: [{kind: "primitive", name: "value", type: "string"}]
			constraints: [
				"enum: evaluating | exception-pending | verified | rejected",
				"verified + rejected são terminal (immutable per inv-identity-immutable-across-state)",
				"exception-pending requer mandatory transition em 14d per inv-exception-timer-mandatory",
			]
			rationale: "State machine simplificada per founder ajuste 3: 4 states + flag (vs 6 states proposta inicial). pending-evaluation removido (CMT-side); evaluating-pending-criteria → flag pendingCriteria derivada de criteriaVersion absence (Part 2 lifecycle)."
		},
		{
			code:        "vo-exception-entry"
			name:        "Exception History Entry"
			description: "Entry append-only em exceptionHistory de Verification per BD6. Tupla (reason, timestamp, triggeredBy, resolvedAt?, resolution?). resolvedAt + resolution presentes apenas se entry transitioned to terminal. Estado vigente da exception é projeção determinística do último entry sem resolvedAt."
			fields: [
				{kind: "primitive", name: "reason", type:      "string", description: "exception reason (insufficient-authority | criteria-version-override | manual-reconciliation | regulatory-fiscal-ambiguity | extend-exception-window)"},
				{kind: "primitive", name: "timestamp", type:   "integer", description: "DLV system time entry creation"},
				{kind: "primitive", name: "triggeredBy", type: "string", description: "actor identifier (system | agt-dlv-primary | founder)"},
				{kind: "primitive", name: "resolvedAt", type:  "integer", description: "presente apenas se resolved (DLV system time)"},
				{kind: "primitive", name: "resolution", type:  "string", description: "presente apenas se resolved (verified | rejected)"},
			]
			constraints: [
				"append-only (immutable após creation)",
				"resolvedAt + resolution são opcionais; presentes juntos OR ausentes juntos",
				"first entry timestamp + last terminal entry timestamp definem cumulative duration per inv-exception-cumulative-cap",
			]
			rationale: "VO composto rich preservando granularidade temporal + causalidade + actor. Estado é projeção determinística (último entry sem resolvedAt); histórico é audit + diagnostic."
		},
	]

	// =============================================
	// AGGREGATES (1) — Verification skeleton (Part 1)
	// Lifecycle + entity ent-evidence-record adicionados em Part 2
	// =============================================

	aggregates: [{
		code:        "agg-verification"
		name:        "Verification"
		description: "Aggregate raiz DLV materializando decisão emitida sobre suficiência de evidência contra critério versionado. Carrega outcome (verified | rejected) + reasonCode + retryPath (em rejected) + criteriaVersion (attribute) + finalityAt + decidedAt + decidedBy + supersededByRef? + exceptionHistory? + finalityReached flag (estrutural per micro-ajuste 3). Imutável após emit (BD2 idempotency); supersedida via supersededByRef (BD5) sem mutação. Identity canonical: vo-idempotency-identity (commitmentRef, evidenceRef)."
		rootIdentity: {
			field: "identity"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-idempotency-identity"
			}
		}
		handlesCommands: [
			"cmd-record-evidence",
			"cmd-evaluate-verification",
			"cmd-transition-exception-state",
		]
		emitsEvents: [
			"evt-evidence-recorded",
			"evt-delivery-verified",
			"evt-delivery-rejected",
			"evt-exception-entered",
			"evt-exception-extended",
			"evt-exception-resolved",
			"evt-supersession-applied",
		]
		protectsInvariants: [
			"inv-identity-uniqueness",
			"inv-criteria-version-as-attribute",
			"inv-identity-immutable-across-state",
			"inv-binary-outcome",
			"inv-rejected-requires-rationale",
			"inv-retry-path-deterministic",
			"inv-verified-requires-evidence-or-override",
			"inv-post-finality-no-autonomous-emit",
			"inv-finality-at-computed",
			"inv-exception-cumulative-cap",
			"inv-at-most-one-active-exception",
			"inv-exception-timer-mandatory",
			"inv-supersession-ordering",
			"inv-replay-determinism",
		]
		usesValueObjects: [
			"vo-commitment-ref",
			"vo-evidence-ref",
			"vo-event-log-offset",
			"vo-idempotency-identity",
			"vo-integrity-proof-ref",
			"vo-criteria-version",
			"vo-reason-code",
			"vo-retry-path",
			"vo-decision-outcome",
			"vo-verification-state",
			"vo-exception-entry",
		]
		// entities + lifecycle adicionados em Part 2
		rationale: """
			1 aggregate root apenas per founder ajuste 1 (EvidenceRecord
			vira Entity interna em Part 2, NÃO aggregate root separado).
			Single consistency boundary preserva atomicity (BD14) sem
			cross-aggregate transactions complexity. handlesCommands +
			emitsEvents + protectsInvariants completos Part 1 (wiring
			catálogos); entity + lifecycle Part 2 completam aggregate
			behavior. Identity via vo-idempotency-identity garante
			(commitmentRef, evidenceRef) tupla canonical per BD2.
			"""
	}]

	rationale: """
		Domain Model DLV materializa propriedades formais do BC como
		CUE constraints validáveis via cue vet. Phase 3 do WI-042
		pos-canvas Phase 1 + glossary Phase 2.

		Part 1 (este commit) — Catalogs + Aggregate Skeleton:
		11 Value Objects (catálogo top-level reusable) + 7 Domain
		Events (2 published cross-BC + 5 internal DLV-only) + 3
		Commands (2 user-invoked + 1 timer-driven internal) + 14
		Invariants (rules declarados; codification via aggregate
		discriminated union em Part 2) + Verification aggregate
		SKELETON (rootIdentity + complete wiring handlesCommands/
		emitsEvents/protectsInvariants/usesValueObjects; SEM entity,
		SEM lifecycle).

		4 ajustes founder pre-write conceptual model aplicados
		estruturalmente:
		(1) 1 aggregate root apenas (EvidenceRecord = Entity interna
		    Part 2)
		(2) INV-D1 atomic emit reclassificado design invariant Part 3
		    outer rationale
		(3) State machine 4 states + flag (Part 2 lifecycle)
		(4) ApplySupersession event-handler Part 3 policy

		3 micro-ajustes founder pre-write:
		(a) pendingCriteria DERIVED (Part 2 lifecycle)
		(b) eventLogOffset escopo claro: ingestion (EvidenceRecord)
		    vs decision (terminal Verification event) — ambos
		    presentes nos events Part 1
		(c) finalityReached flag estrutural (Part 2 aggregate fields
		    + inv-post-finality-no-autonomous-emit Part 1)

		Part 2 — Aggregate Completion: ent-evidence-record embedded
		(identity intrínseca a Verification per BD4) + lifecycle
		state machine 4 states + transitions com triggeredByCommand
		+ emitsEvents + guards (referenciando invariants Part 1) +
		pendingCriteria + finalityReached flags estruturais.

		Part 3 — Projections + Policy + Outer Rationale: 5 prj-*
		(canonical-current-verification + evidence-lineage +
		exception-tracking + active-criteria Phase 1+ note +
		pending-reconciliation Phase 1+ note) + 1 pol-* (event-
		handler supersession reagindo a evt-supersession-applied) +
		outer rationale completo cobrindo 14 invariantes + INV-D1
		design invariant + boundary rules BND-1..4 + state machine
		semantics + cascade Phase 4-5.

		Boundary preservation transversal anti-mini-NIM (BND-1..4):
		BND-1 NO numeric-statistical fields em event payloads (BD10);
		BND-2 criteriaVersion DEVE referenciar CMT existing (NÃO
		inferida); BND-3 supersession é ordering canonical (NÃO
		seleção entre evidências) per BD5; BND-4 verificationMetrics
		são observation-only (NÃO input para command preconditions)
		per BD10.

		cue vet ./contexts/dlv/ EXIT=0; tq-dm-01..04 (commands +
		events + invariants + valueObjects todos wired no único
		aggregate Verification) satisfeitos por construção em Part 1.
		Phase 4-5 forward-refs: agent-spec consumirá governanceScope
		do canvas + invariants do domain-model; envelope agent-
		governance materializará enforcement runtime.
		"""
}
