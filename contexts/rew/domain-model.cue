package rew

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-model.cue — Domain Model: Risk Engine & Risk Observability.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Phase 3 Part 1 do WI-046 pos-canvas Phase 1 (commit fbe0b2d "top 0.1%")
// + glossary Phase 2 (commit 7854cc7, 12 terms em 5 camadas ontológicas).
//
// REW é controle epistemológico, NÃO documentação. Domain model COMPILA
// o glossary em building blocks DDD onde violações tornam-se erros de
// compilação OU rules estruturais executáveis (Phase 3.5 structural-checks).
//
// FRASE CANONICAL Phase 2: "Glossary não define palavras — define o que
// o sistema está autorizado a considerar verdade."
//
// REGRA DE 3 CAMADAS (founder Phase 3 directive — Opção A ratified):
//   VO define forma         (CUE schema-time — presence + primitive types + refs)
//   invariant define verdade (rule prose + rationale + dependsOnAggregateState)
//   structural-check impõe verdade (CUE rules em architecture/structural-
//     checks/rew-domain-model.cue — Phase 3 Part 3 deferred)
//
// Cascade ordering preserved: stakeholder-map sh-06 (Phase 1 cross-cutting)
// + canvas REW Phase 1 + glossary REW Phase 2 + lens-domain-language-and-
// terminology-design existentes ANTES desta instância. Schema #DomainModel
// NÃO modificado (Opção A — blast radius zero; INV/DLV/SSC/PG preserved).
//
// REGRA-GOV-WRITE-01 honrada: incompleto ≠ incoerente. Part 1 contém:
// - 13 events (signal layer + evaluation layer + alert layer + lifecycle)
// - 9 commands (com cmd-mark-evaluation-stale como internal orchestration
//   per Opção 6 founder ratified — automated-policy issuer; NOT external)
// - 24 invariants (6 founder Phase 3 hardenings + 5 final-pressure new)
// - 17 valueObjects (3 utility + 5 signal/payload + 5 domain core +
//   3 type catalog + 1 scale-metadata)
// - 1 aggregate skeleton (agg-risk-evaluation com lifecycle 3 estados)
// - 1 entity (ent-reasoning-trace owned por agg-risk-evaluation)
// - 1 policy (pol-mark-stale-on-relevant-signal)
// - 1 projection (prj-active-risk-evaluations — OBRIGATÓRIA per
//   inv-rew-active-evaluation-rule)
// Deferred to Part 2: agg-risk-alert + agg-risk-model + agg-risk-policy +
// modules + pol-emit-risk-alert-on-eligibility-denied. Deferred to Part 3:
// architecture/structural-checks/rew-domain-model.cue (S7 — 14+ sc-rew-*
// rules executáveis).
//
// REGRA-GOV-VO-01 (founder governance rule): Nenhum novo VO criado sem
// errorClassEliminated explícito. Aplicado retroativamente aos 17 VOs.
//
// MODULE DECOMPOSITION (deferred Part 2; documentado para cascade preview):
//   mod-rew-evaluation: agg-risk-evaluation + agg-risk-alert (decision +
//     observability — emissão de risco e ciclo de vida de alerta)
//   mod-rew-control: agg-risk-model + agg-risk-policy (controle versionado
//     — modelo prevê, policy decide; inv-rew-model-policy-independence
//     é arquitetural)
//   mod-rew-acl: VOs inbound (Signal + payload variants + integrity
//     proofs) — boundary entre upstream BCs (NPM/DLV/NIM/FCE) e domínio
//     REW puro. Anti-corruption boundary enforces:
//     - REW NUNCA interpreta payload bruto upstream
//     - REW SÓ consome signalType + interpretation contract validated
//     - payload é opaco para REW logic — discriminated union por
//       signalType determina parsing autorizado
//
// CANVAS ↔ DOMAIN-MODEL ALIGNMENT DEBT — PAGO (2026-06-12):
// Canvas Phase 1 declarou 4 published events (RiskScoreEmitted,
// EligibilityEmitted, RiskAlertOpened, RiskAlertResolved). Phase 3
// design evolved: score + eligibility + confidence formam DECISÃO
// ATÔMICA via evt-risk-evaluation-emitted (single fact). Canvas
// alignment update materializado no commit separado 245c056
// (PR #139, fatia REW Etapa 1): canvas publica RiskEvaluationEmitted
// + RiskAlertRaised/RiskAlertResolved — debt pago; tq-dm-11 sem objeto.
//
// O QUE NÃO VIVE AQUI:
// - SoT affinity (Event Log, Ledger) → Architecture Communication Canvas
// - wire format (CloudEvents, AsyncAPI) → AsyncAPI specs
// - replay execution semantics → runtime engine
// - model training/retraining → outside REW domain
// - adversário econômico modelagem como entity → behavioral class
//   (pressão arquitetural via inv-rew-asset-aware-discipline +
//   manipulationVectors em canvas + sh-06 stakeholder catalog)
// - structural-check rules executáveis → architecture/structural-checks/
//   rew-domain-model.cue (Part 3 deferred)
// - agent-spec REW → contexts/rew/agents/ (Phase 4 deferred)
// - autonomy envelope REW → contexts/rew/agents/ (Phase 5 deferred)

domainModel: artifact_schemas.#DomainModel & {
	code:              "rew"
	name:              "Risk Engine & Risk Observability"
	boundedContextRef: "rew"

	// =========================================================
	// DOMAIN EVENTS (13)
	// =========================================================
	// Signal layer (3): received, corruption-detected
	// Evaluation layer (4): computed, emitted, superseded, marked-stale
	// Alert layer (3): raised, acknowledged, resolved
	// Model lifecycle (2): activated, deprecated
	// Policy lifecycle (2): activated, deprecated
	// Common pattern: todo event tem eventId + correlationId + eventTimestamp
	//   + (causationId | causationKind+causationRef discriminado).

	events: [
		{
			code:        "evt-signal-received"
			// adr-151 Forma A (onda rew, passo vi)
			firstClass:       true
			firstClassReason: "risk"
			coreNoun:         "Signal Received"
			name:        "SignalReceivedFromUpstreamBC"
			description: "Signal interpretado por upstream BC (NPM/DLV/NIM/FCE) INGESTADO em REW via ACL. Idempotency split crítico: (signalId, sourceContext) é IDENTITY (idempotency key); signalHash é INTEGRITY VALIDATION (não identity). Same identity + same hash → ignored. Same identity + different hash → triggera evt-signal-corruption-detected. causationKind/causationRef discriminados porque nem todo upstream tem eventId (batch ingestion, polling, backfill, manual import) — forçar causalidade inexistente cria mentira estrutural."
			rationale:   "'Received' (REW) vs 'observed' (upstream) — observação pertence ao upstream, ingestão pertence ao REW (founder Phase 3 insight). Idempotency split (identity vs integrity) elimina classe de bug onde upstream mutation passa undetected. errorClassEliminated: 'signal corruption silently accepted as new signal' + 'forced causality on causation-less signals'."
			visibility:  "internal"
			fields: [
				{kind: "primitive", name: "eventId", type:        "string"},
				{kind: "primitive", name: "causationKind", type:  "string", description: "Enum: ^(upstream-event|ingestion-job|backfill-job|manual-import|none)$"},
				{kind: "primitive", name: "causationRef", type:   "string", description: "Reference per causationKind: upstream eventId, jobId, importId, OR vazio quando kind=='none'"},
				{kind: "primitive", name: "correlationId", type:  "string", description: "Workflow chain id — pode herdar de upstream OR começar root aqui"},
				{kind: "value-object-ref", name: "signal", valueObjectRef:    "vo-signal"},
				{kind: "value-object-ref", name: "signalRef", valueObjectRef: "vo-signal-ref", description: "Snapshot reference (signalRef + signalHash + capturedAt) — idempotency anchor"},
				{kind: "primitive", name: "eventTimestamp", type: "datetime"},
			]
		},
		{
			code:        "evt-signal-corruption-detected"
			name:        "SignalCorruptionDetected"
			description: "Same (signalId, sourceContext) recebido com signalHash DIFERENTE do snapshot original. DECISÃO DETERMINÍSTICA REW (Opção A founder-recommended): incoming signal é DESCARTADO automaticamente; original snapshot PRESERVADO (immutability per inv-rew-signal-traceability); alert crítico raised; review humano decide próxima ação (manual re-ingest com NEW signalId, OR mark adversarial, OR escalate). REW NÃO classifica causa (mutation/corruption/adversarial) — delega a review via alert. Manual re-ingestion corrigida exige NEW signalId (não pode reusar identity do corrupted attempt)."
			rationale:   "Detectar corrupção sem decidir o que fazer = meia arquitetura (founder Phase 3 insight). Comportamento determinístico (discard + alert) preserva inv-rew-signal-traceability + inv-rew-deterministic-replay incólumes. Alternative (accept as suspect) introduziria estado ambíguo destruindo replay determinism. errorClassEliminated: 'upstream mutation passing undetected as legitimate update' + 'ambiguous handling of corrupted signal causing decision history mutation'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                  "string"},
				{kind: "primitive", name: "causationId", type:              "string", description: "evt-signal-received eventId que disparou detection"},
				{kind: "primitive", name: "correlationId", type:            "string"},
				{kind: "value-object-ref", name: "signalRef", valueObjectRef: "vo-signal-ref"},
				{kind: "primitive", name: "originalHash", type:             "string", description: "Hash do snapshot original; regex ^[a-f0-9]{64}$ (enforced sc-rew-hash-format)"},
				{kind: "primitive", name: "incomingHash", type:             "string", description: "Hash do incoming signal; regex ^[a-f0-9]{64}$"},
				{kind: "primitive", name: "incomingDiscardedAt", type:      "datetime", description: "Timestamp quando incoming signal foi DESCARTADO (não processado)"},
				{kind: "primitive", name: "originalSnapshotPreserved", type: "boolean", description: "Sempre true — invariant inv-rew-signal-corruption-handling"},
				{kind: "primitive", name: "detectedAt", type:               "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:           "datetime"},
			]
		},
		{
			code:        "evt-risk-evaluation-computed"
			// adr-151 Forma A (onda rew, passo vi)
			firstClass:       true
			firstClassReason: "risk"
			coreNoun:         "Risk Evaluation Computed"
			name:        "RiskEvaluationComputed"
			description: "Evaluation calculation finalizada internamente. Computed ≠ Emitted (founder insight 'decidir ≠ publicar'). Split permite: shadow mode (compute sem emit), retry (re-emit sem recompute), failure isolation (compute success ≠ emit success). signalSnapshotIds carrega lista de signalIds capturados — replay determinístico inviável sem inputs explícitos. parentEvaluationId opcional referencia evaluation predecessora no lineage tree (chain de superseding); empty quando evaluation root."
			rationale:   "Sem inputs explícitos, não existe explicação — só resultado (founder Phase 3 insight). Split compute/emit elimina classe de bug: failure de emission gerando duplicate compute on retry. parentEvaluationId materializa lineage navegável — sem lineage, histórico vira lista, não estrutura. errorClassEliminated: 'compute and emit conflated as single atomic event causing replay corruption' + 'evaluation history without traversable lineage'."
			visibility:  "internal"
			fields: [
				{kind: "primitive", name: "eventId", type:                "string"},
				{kind: "primitive", name: "causationId", type:            "string", description: "cmd-request-risk-evaluation commandId que disparou compute"},
				{kind: "primitive", name: "correlationId", type:          "string"},
				{kind: "primitive", name: "evaluationId", type:           "string", description: "Idempotent anchor — eventId ≠ evaluationId; estável across retries de emission"},
				{kind: "primitive", name: "parentEvaluationId", type:     "string", description: "Optional reference à evaluation predecessora; empty quando root (primeira no scope)"},
				{kind: "primitive", name: "signalSnapshotIds", type:      "string", description: "Comma-separated signalIds (ordered ascending) referenciando vo-signal-ref instances; cardinality ≥1; uniqueness enforced sc-rew-evaluation-snapshot-uniqueness"},
				{kind: "value-object-ref", name: "score", valueObjectRef:      "vo-risk-score"},
				{kind: "value-object-ref", name: "eligibility", valueObjectRef: "vo-eligibility-decision"},
				{kind: "value-object-ref", name: "confidence", valueObjectRef:  "vo-confidence-interval"},
				{kind: "value-object-ref", name: "context", valueObjectRef:     "vo-applicable-context"},
				{kind: "primitive", name: "modelVersion", type:           "string"},
				{kind: "primitive", name: "policyVersion", type:          "string"},
				{kind: "primitive", name: "replayHash", type:             "string", description: "SHA-256 hex regex ^[a-f0-9]{64}$ — canonical serialization de (signalSnapshotIds ordered + modelVersion + policyVersion + decisionContextTime)"},
				{kind: "primitive", name: "computedAt", type:             "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:         "datetime"},
			]
		},
		{
			code:        "evt-risk-evaluation-emitted"
			// adr-151 Forma A (onda rew, passo vi)
			firstClass:       true
			firstClassReason: "risk"
			coreNoun:         "Risk Evaluation Emitted"
			name:        "RiskEvaluationEmitted"
			description: "Evaluation publicada cross-BC para consumers (CMT, FCE, SCF). evaluationId IDENTITY anchor; eventId varia per re-emission (network retry), evaluationId NÃO. Consumer dedupe via evaluationId. Alinhamento com canvas: Phase 3 design evolved para evaluation atômica unificando score + eligibility + confidence em fact único (ex-RiskScoreEmitted + EligibilityEmitted); canvas alinhado em 245c056 (PR #139)."
			rationale:   "Public contract event. Founder insight: 'evento pode duplicar; decisão não pode' — evaluationId stable identity garante consumers nunca contam decision 2× por retry de emission. errorClassEliminated: 'consumer treating retried emission as new evaluation'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                "string"},
				{kind: "primitive", name: "causationId", type:            "string", description: "evt-risk-evaluation-computed eventId precedente — inv-rew-compute-emit-ordering"},
				{kind: "primitive", name: "correlationId", type:          "string"},
				{kind: "primitive", name: "evaluationId", type:           "string"},
				{kind: "value-object-ref", name: "score", valueObjectRef:      "vo-risk-score"},
				{kind: "value-object-ref", name: "eligibility", valueObjectRef: "vo-eligibility-decision"},
				{kind: "value-object-ref", name: "confidence", valueObjectRef:  "vo-confidence-interval"},
				{kind: "value-object-ref", name: "context", valueObjectRef:     "vo-applicable-context"},
				{kind: "primitive", name: "emittedAt", type:              "datetime"},
				{kind: "primitive", name: "validUntilTimestamp", type:    "datetime", description: "= emittedAt + RiskPolicy.evaluationValidityWindowSeconds (inv-rew-evaluation-temporal-validity); consumer reading com now() > validUntilTimestamp = decisão EXPIRED"},
				{kind: "primitive", name: "eventTimestamp", type:         "datetime"},
			]
		},
		{
			code:        "evt-risk-evaluation-superseded"
			// adr-151 Forma A (onda rew, passo vi)
			firstClass:       true
			firstClassReason: "risk"
			coreNoun:         "Risk Evaluation Superseded"
			name:        "RiskEvaluationSuperseded"
			description: "Substituição EXPLÍCITA via cmd-supersede-risk-evaluation. REW NUNCA supersede automaticamente (inv-rew-explicit-supersede-only). supersedeReason via vo-decision-reason obrigatório. Concurrency rule garantida: race conditions e last-write-wins ELIMINADAS por design — evaluation history é append-only fact log."
			rationale:   "Substituição sem razão = corrupção silenciosa (founder Phase 3 insight). Superseding é decisão histórica (≠ active state read-rule). errorClassEliminated: 'implicit supersede causing decision history corruption' + 'concurrent signals causing non-deterministic supersession'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                              "string"},
				{kind: "primitive", name: "causationId", type:                          "string", description: "cmd-supersede-risk-evaluation commandId"},
				{kind: "primitive", name: "correlationId", type:                        "string"},
				{kind: "primitive", name: "supersededEvaluationId", type:               "string"},
				{kind: "primitive", name: "newEvaluationId", type:                      "string"},
				{kind: "value-object-ref", name: "supersedeReason", valueObjectRef: "vo-decision-reason"},
				{kind: "primitive", name: "supersededAt", type:                         "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                       "datetime"},
			]
		},
		{
			code:        "evt-risk-evaluation-marked-stale"
			// adr-151 Forma A (onda rew, passo vi)
			firstClass:       true
			firstClassReason: "risk"
			coreNoun:         "Risk Evaluation Marked Stale"
			name:        "RiskEvaluationMarkedStale"
			description: "Evaluation marcada STALE AUTOMATICAMENTE porque novo signal relevante chegou. Stale ≠ Superseded: stale signal arrived; evaluation continua VÁLIDA mas FLAGGED para review/refresh (não é decisão). Supersede separado (explicit-only). Causation: pol-mark-stale-on-relevant-signal triggered por evt-signal-received quando signal.context match evaluation.applicableContext per RiskPolicy.stalenessTriggerCriteria. Boundedness: NO MÁXIMO 1 evt-marked-stale por evaluation por window (inv-rew-event-emission-boundedness)."
			rationale:   "Supersede decide; staleness sinaliza (founder Phase 3 insight — o mais importante de S4). Sem staleness tracking, evaluation envelhece silenciosamente. Staleness automática (policy-driven) preserva append-only history enquanto torna freshness observable. errorClassEliminated: 'evaluation aging silently — consumer using stale decision without awareness'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                                "string"},
				{kind: "primitive", name: "causationId", type:                            "string", description: "evt-signal-received eventId que disparou staleness mark"},
				{kind: "primitive", name: "correlationId", type:                          "string"},
				{kind: "primitive", name: "evaluationId", type:                           "string"},
				{kind: "value-object-ref", name: "triggeringSignalRef", valueObjectRef: "vo-signal-ref"},
				{kind: "primitive", name: "stalenessReason", type:                        "string", description: "Enum: ^(new-signal-same-entity|new-signal-same-asset|policy-version-changed|model-version-changed)$"},
				{kind: "primitive", name: "markedStaleAt", type:                          "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                         "datetime"},
			]
		},
		{
			code:        "evt-risk-alert-raised"
			name:        "RiskAlertRaised"
			description: "Alert raised por: eligibility-denied, signal-corruption, adversarial-pattern, policy-violation, OR model-drift. Alert é OBSERVABILITY artifact — sinaliza condição para review humano. Dedupe key (evaluationId, alertCategory) — múltiplos triggers para mesma combinação NÃO criam novos alerts (inv-rew-alert-dedupe). Alert binding ao evaluationId é IMUTÁVEL (inv-rew-alert-evaluation-binding-immutability)."
			rationale:   "Alert sem dedupe = ruído → sistema ignorado (founder Phase 3 insight). Alert ≠ decision: decision categórica; alert flag de condição para review. errorClassEliminated: 'decision and alert conflated causing review fatigue' + 'repeated alerts for same condition causing alert fatigue'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                                  "string"},
				{kind: "primitive", name: "causationId", type:                              "string", description: "evt-risk-evaluation-emitted OR evt-signal-corruption-detected eventId"},
				{kind: "primitive", name: "correlationId", type:                            "string"},
				{kind: "primitive", name: "alertId", type:                                  "string"},
				{kind: "primitive", name: "evaluationId", type:                             "string", description: "Reference imutável à evaluation que originou o alert (inv-rew-alert-evaluation-binding-immutability)"},
				{kind: "primitive", name: "alertCategory", type:                            "string", description: "Enum: ^(eligibility-denied|signal-corruption|adversarial-pattern|policy-violation|model-drift)$"},
				{kind: "primitive", name: "severity", type:                                 "string", description: "Enum: ^(low|medium|high|critical)$"},
				{kind: "value-object-ref", name: "triggeringContext", valueObjectRef: "vo-applicable-context"},
				{kind: "primitive", name: "raisedAt", type:                                 "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                           "datetime"},
			]
		},
		{
			code:        "evt-risk-alert-acknowledged"
			name:        "RiskAlertAcknowledged"
			description: "Acknowledge ≠ Resolve: ack indica 'estou ciente'; resolve indica 'avaliei e tomei ação'. performedBy + actorAuthority obrigatórios — quem fez ≠ quem podia fazer. Authority validation enforced em sc-rew-command-authority-binding (S7) — critical alert → ack só por supervisor+."
			rationale:   "Quem fez ≠ quem podia fazer (founder Phase 3 insight). actorAuthority enum declara explicitamente classe de actor; structural-check enforça authority minimum per alert category. errorClassEliminated: 'ack by unauthorized actor bypassing escalation'."
			visibility:  "internal"
			fields: [
				{kind: "primitive", name: "eventId", type:                          "string"},
				{kind: "primitive", name: "causationId", type:                      "string", description: "cmd-acknowledge-risk-alert commandId"},
				{kind: "primitive", name: "correlationId", type:                    "string"},
				{kind: "primitive", name: "alertId", type:                          "string"},
				{kind: "value-object-ref", name: "performedBy", valueObjectRef: "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                   "string", description: "Enum: ^(system|automated-policy|analyst|supervisor|admin)$"},
				{kind: "primitive", name: "acknowledgedAt", type:                   "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                   "datetime"},
			]
		},
		{
			code:        "evt-risk-alert-resolved"
			name:        "RiskAlertResolved"
			description: "Alert resolved com performedBy + actorAuthority + resolutionReason obrigatórios. Resolve IRREVERSÍVEL (inv-rew-alert-lifecycle); reabertura PROIBIDA — alert resolved gera novo alert se condição recorre (preserva append-only event log)."
			rationale:   "Resolution trail é auditable evidence. resolutionReason via vo-decision-reason permite categorization (false-positive, manual-override, escalated, etc.). errorClassEliminated: 'alert closure without auditable rationale'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                                  "string"},
				{kind: "primitive", name: "causationId", type:                              "string"},
				{kind: "primitive", name: "correlationId", type:                            "string"},
				{kind: "primitive", name: "alertId", type:                                  "string"},
				{kind: "value-object-ref", name: "performedBy", valueObjectRef:         "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                           "string"},
				{kind: "value-object-ref", name: "resolutionReason", valueObjectRef:    "vo-decision-reason"},
				{kind: "primitive", name: "resolvedAt", type:                               "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                           "datetime"},
			]
		},
		{
			code:        "evt-risk-model-activated"
			name:        "RiskModelVersionActivated"
			description: "Model version promovida a active status. Cross-BC observability — consumers calibram CI/score interpretation. Authority elevada exigida (supervisor+) per sc-rew-command-authority-binding (S7)."
			rationale:   "errorClassEliminated: 'model version drift undetected by consumers'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                        "string"},
				{kind: "primitive", name: "causationId", type:                    "string"},
				{kind: "primitive", name: "correlationId", type:                  "string"},
				{kind: "primitive", name: "modelVersion", type:                   "string"},
				{kind: "value-object-ref", name: "activatedBy", valueObjectRef: "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                 "string"},
				{kind: "primitive", name: "activatedAt", type:                    "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                 "datetime"},
			]
		},
		{
			code:        "evt-risk-model-deprecated"
			name:        "RiskModelVersionDeprecated"
			description: "Model version marcada deprecated com reason. Mesma disciplina de supersede: substituição sem razão = corrupção silenciosa."
			rationale:   "errorClassEliminated: 'silent model deprecation causing consumer confusion'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                                  "string"},
				{kind: "primitive", name: "causationId", type:                              "string"},
				{kind: "primitive", name: "correlationId", type:                            "string"},
				{kind: "primitive", name: "modelVersion", type:                             "string"},
				{kind: "value-object-ref", name: "deprecatedBy", valueObjectRef:        "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                           "string"},
				{kind: "value-object-ref", name: "deprecationReason", valueObjectRef:   "vo-decision-reason"},
				{kind: "primitive", name: "deprecatedAt", type:                             "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                           "datetime"},
			]
		},
		{
			code:        "evt-risk-policy-activated"
			name:        "RiskPolicyVersionActivated"
			description: "Policy version promovida a active status. Cross-BC observability."
			rationale:   "errorClassEliminated: 'policy version drift undetected by consumers'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                        "string"},
				{kind: "primitive", name: "causationId", type:                    "string"},
				{kind: "primitive", name: "correlationId", type:                  "string"},
				{kind: "primitive", name: "policyVersion", type:                  "string"},
				{kind: "value-object-ref", name: "activatedBy", valueObjectRef: "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                 "string"},
				{kind: "primitive", name: "activatedAt", type:                    "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                 "datetime"},
			]
		},
		{
			code:        "evt-risk-policy-deprecated"
			name:        "RiskPolicyVersionDeprecated"
			description: "Policy version marcada deprecated com reason."
			rationale:   "errorClassEliminated: 'silent policy deprecation'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                                "string"},
				{kind: "primitive", name: "causationId", type:                            "string"},
				{kind: "primitive", name: "correlationId", type:                          "string"},
				{kind: "primitive", name: "policyVersion", type:                          "string"},
				{kind: "value-object-ref", name: "deprecatedBy", valueObjectRef:      "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                         "string"},
				{kind: "value-object-ref", name: "deprecationReason", valueObjectRef: "vo-decision-reason"},
				{kind: "primitive", name: "deprecatedAt", type:                           "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                         "datetime"},
			]
		},
		{
			code:        "evt-risk-evaluation-emit-failed"
			name:        "RiskEvaluationEmitFailed"
			description: "Emit failure após retry exhaustion (RiskPolicy.emitTimeoutSeconds default 30s). ABORT EXPLÍCITO — evaluation NÃO entra em projection, NÃO participa de active rule, NÃO pode ser target de cmd-supersede. Permanece em event log como FACT histórico (audit trail) mas NÃO é evaluation válida no domínio. Evaluation = emitted by definition; nem todo cálculo deve virar estado."
			rationale:   "Retry sem dono = retry inexistente + nem todo cálculo deve virar estado (founder Phase 3 insights). emit-failed preserva audit trail sem inflar lifecycle states. errorClassEliminated: 'computed evaluation invisible OR becoming spurious lifecycle state post-crash-pre-emit'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                              "string"},
				{kind: "primitive", name: "causationId", type:                          "string", description: "evt-risk-evaluation-computed eventId precedente"},
				{kind: "primitive", name: "correlationId", type:                        "string"},
				{kind: "primitive", name: "evaluationId", type:                         "string", description: "Aborted evaluationId — historical fact only"},
				{kind: "value-object-ref", name: "failureReason", valueObjectRef: "vo-decision-reason"},
				{kind: "primitive", name: "retryAttempts", type:                        "integer"},
				{kind: "primitive", name: "retryExhausted", type:                       "boolean"},
				{kind: "primitive", name: "abortedAt", type:                            "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                       "datetime"},
			]
		},
		{
			code:        "evt-signal-rejected"
			name:        "SignalRejectedAtACLBoundary"
			description: "Signal incoming reprovado em ACL validation (per inv-rew-signal-validation-before-ingestion). NUNCA drop silent — ambiguity em boundary = bug futuro. originalSignalRef preserva ref para investigação upstream; rejectionReason articula categoria de falha. Rejected signal NUNCA entra no domínio: NÃO triggers staleness, alert, OR evaluation pipeline."
			rationale:   "Boundary não declarado vira superfície de ataque + ambiguidade em boundary = bug futuro (founder Phase 3 insights). errorClassEliminated: 'malformed signal silently dropped causing missing audit trail + debugging blind spots'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                                "string"},
				{kind: "primitive", name: "causationKind", type:                          "string", description: "Enum (espelho de evt-signal-received causationKind)"},
				{kind: "primitive", name: "causationRef", type:                           "string"},
				{kind: "primitive", name: "correlationId", type:                          "string"},
				{kind: "value-object-ref", name: "originalSignalRef", valueObjectRef: "vo-signal-ref"},
				{kind: "value-object-ref", name: "rejectionReason", valueObjectRef:   "vo-decision-reason"},
				{kind: "primitive", name: "validationCheckFailed", type:                  "string", description: "Enum: ^(signalType-invalid|sourceContext-invalid|signalType-source-mismatch|integrityProof-missing|payloadVoCode-invalid|payloadInstance-unavailable)$"},
				{kind: "primitive", name: "rejectedAt", type:                             "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:                         "datetime"},
			]
		},
		{
			code:        "evt-risk-evaluation-emit-superseded-by-newer"
			name:        "RiskEvaluationEmitSuperseded"
			description: "Emit handler detectou newer evaluation E_other para mesmo scope com emittedAt > THIS.computedAt. THIS NÃO entra em lifecycle — mas ≠ failure. successorEvaluationId reference permite consumer USAR E_other em vez de retry. Distinção semântica vs evt-risk-evaluation-emit-failed: failure = sistema não conseguiu computar; obsolescence = sistema computou mas newer reality já existe (FAILURE ≠ OBSOLESCENCE — founder War Game 2 insight). successor chain bounded por inv-rew-successor-chain-bounded (default N=3 hops consumer-side)."
			rationale:   "Consumer originador recebe successorEvaluationId reference em vez de simples failure — pode adopt successor OR re-request com fresh inputs. Evita false negative semântico + consumer retry loop indefinido. errorClassEliminated: 'consumer retry loop on obsolescence misclassified as failure'."
			visibility:  "published"
			fields: [
				{kind: "primitive", name: "eventId", type:                "string"},
				{kind: "primitive", name: "causationId", type:            "string", description: "evt-risk-evaluation-computed eventId precedente"},
				{kind: "primitive", name: "correlationId", type:          "string"},
				{kind: "primitive", name: "evaluationId", type:           "string", description: "THIS evaluation — obsolete, NÃO entra em lifecycle"},
				{kind: "primitive", name: "successorEvaluationId", type:  "string", description: "E_other reference — newer evaluation already emitted; consumer pode adopt"},
				{kind: "primitive", name: "supersededAt", type:           "datetime"},
				{kind: "primitive", name: "eventTimestamp", type:         "datetime"},
			]
		},
	]

	// =========================================================
	// COMMANDS (10)
	// =========================================================
	// Common pattern: commandId + correlationId + issuedBy (vo-external-ref)
	//   + actorAuthority + issuedAt. cmd-mark-evaluation-stale é INTERNAL
	//   orchestration (issued by automated-policy only — Opção 6 founder
	//   ratified).

	commands: [
		{
			code:        "cmd-request-risk-evaluation"
			// adr-151 Forma A (onda rew, passo vi)
			firstClass:       true
			firstClassReason: "risk"
			coreNoun:         "Request Risk Evaluation"
			name:        "Request Risk Evaluation (correlation root + version freeze anchor)"
			description: "Consumer (CMT/FCE/SCF) solicita evaluation. Command é DUPLO ANCHOR: (a) correlation chain root — correlationId nasce aqui; (b) version freeze anchor — modelVersion E policyVersion são SNAPSHOT IMUTÁVEIS aqui (per inv-rew-version-frozen-at-request). Toda compute/emit/replay subsequent usa esses snapshots; new model/policy activated mid-flow NÃO afeta in-flight evaluation."
			rationale:   "errorClassEliminated: 'correlation chain orphans preventing flow reconstruction' + 'mid-flow model/policy swap causing comparability collapse + non-deterministic replay'."
			fields: [
				{kind: "primitive", name: "commandId", type:                  "string", description: "Idempotent anchor — retry com mesmo commandId rejeitado se payload diverge (inv-rew-command-idempotency)"},
				{kind: "primitive", name: "correlationId", type:              "string", description: "ROOT — nasce neste command; propagado por toda cadeia"},
				{kind: "value-object-ref", name: "context", valueObjectRef:    "vo-applicable-context"},
				{kind: "primitive", name: "requestedModelVersion", type:      "string", description: "Snapshot do RiskModel.version active em issuedAt — IMUTÁVEL durante evaluation chain"},
				{kind: "primitive", name: "requestedPolicyVersion", type:     "string", description: "Snapshot do RiskPolicy.version active em issuedAt — IMUTÁVEL"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef:   "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:             "string"},
				{kind: "primitive", name: "issuedAt", type:                   "datetime"},
			]
		},
		{
			code:        "cmd-supersede-risk-evaluation"
			// adr-151 Forma A (onda rew, passo vi)
			firstClass:       true
			firstClassReason: "risk"
			coreNoun:         "Supersede Risk Evaluation"
			name:        "Supersede Risk Evaluation (explicit replacement)"
			description: "Comando EXPLÍCITO de substituição. REW NUNCA supersede automaticamente (inv-rew-explicit-supersede-only). Caller (CMT analyst, FCE compliance, automated review policy) declara intenção + reason. Concurrency e race conditions ELIMINADAS por design."
			rationale:   "Concurrency rule explicit-supersede-only. errorClassEliminated: 'implicit supersede on signal arrival causing decision history corruption'."
			fields: [
				{kind: "primitive", name: "commandId", type:                            "string"},
				{kind: "primitive", name: "correlationId", type:                        "string"},
				{kind: "primitive", name: "supersededEvaluationId", type:               "string"},
				{kind: "primitive", name: "newEvaluationId", type:                      "string"},
				{kind: "value-object-ref", name: "supersedeReason", valueObjectRef: "vo-decision-reason"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef:        "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                       "string"},
				{kind: "primitive", name: "issuedAt", type:                             "datetime"},
			]
		},
		{
			code:        "cmd-mark-evaluation-stale"
			// adr-151 Forma A (onda rew, passo vi)
			firstClass:       true
			firstClassReason: "risk"
			coreNoun:         "Mark Evaluation Stale"
			name:        "Mark Evaluation Stale (INTERNAL orchestration)"
			description: "Command INTERNAL emitido EXCLUSIVAMENTE por pol-mark-stale-on-relevant-signal (automated-policy issuer). NÃO exposto via canvas inbound — não é command de domínio externo. Schema #Policy.issuesCommand exige command target; cmd-mark-evaluation-stale resolve essa restrição preservando founder framing 'staleness é automático, sem intent humano' via actorAuthority='automated-policy'. Pattern paralelo a CQRS process manager → command → aggregate."
			rationale:   "Opção 6 founder ratified: schema-aligned (issuesCommand obrigatório); founder framing parcialmente honrado via classification automated-policy. errorClassEliminated: 'staleness emission via direct event-from-policy violando schema OR via aggregate reactive behavior não modelável em #DomainModel atual'."
			fields: [
				{kind: "primitive", name: "commandId", type:                              "string"},
				{kind: "primitive", name: "correlationId", type:                          "string"},
				{kind: "primitive", name: "evaluationId", type:                           "string"},
				{kind: "value-object-ref", name: "triggeringSignalRef", valueObjectRef: "vo-signal-ref"},
				{kind: "primitive", name: "stalenessReason", type:                        "string", description: "Enum: ^(new-signal-same-entity|new-signal-same-asset|policy-version-changed|model-version-changed)$"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef:          "vo-external-ref", description: "Reference à policy emissor (sourceContext='rew' system component)"},
				{kind: "primitive", name: "actorAuthority", type:                         "string", description: "Sempre 'automated-policy' (sc-rew-internal-cmd-actor-authority)"},
				{kind: "primitive", name: "issuedAt", type:                               "datetime"},
			]
		},
		{
			code:        "cmd-acknowledge-risk-alert"
			name:        "Acknowledge Risk Alert"
			description: "Authorized actor reconhece alert (estou ciente). actorAuthority validado contra alert.severity em sc-rew-command-authority-binding (S7)."
			rationale:   "errorClassEliminated: 'ack by unauthorized actor bypassing escalation'."
			fields: [
				{kind: "primitive", name: "commandId", type:                "string"},
				{kind: "primitive", name: "correlationId", type:            "string"},
				{kind: "primitive", name: "alertId", type:                  "string"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef: "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:           "string"},
				{kind: "primitive", name: "issuedAt", type:                 "datetime"},
			]
		},
		{
			code:        "cmd-resolve-risk-alert"
			name:        "Resolve Risk Alert"
			description: "Authorized actor resolve alert (avaliei + tomei ação). resolutionReason via vo-decision-reason obrigatório — resolve sem rationale = audit trail corruption."
			rationale:   "errorClassEliminated: 'alert closure without auditable rationale'."
			fields: [
				{kind: "primitive", name: "commandId", type:                              "string"},
				{kind: "primitive", name: "correlationId", type:                          "string"},
				{kind: "primitive", name: "alertId", type:                                "string"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef:          "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                         "string"},
				{kind: "value-object-ref", name: "resolutionReason", valueObjectRef: "vo-decision-reason"},
				{kind: "primitive", name: "issuedAt", type:                               "datetime"},
			]
		},
		{
			code:        "cmd-activate-risk-model"
			name:        "Activate Risk Model Version"
			description: "Promove model version a active status. Authority elevada (supervisor+ per sc-rew-command-authority-binding S7)."
			rationale:   "errorClassEliminated: 'unauthorized model activation causing decision drift'."
			fields: [
				{kind: "primitive", name: "commandId", type:                "string"},
				{kind: "primitive", name: "correlationId", type:            "string"},
				{kind: "primitive", name: "modelVersion", type:             "string"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef: "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:           "string"},
				{kind: "primitive", name: "issuedAt", type:                 "datetime"},
			]
		},
		{
			code:        "cmd-deprecate-risk-model"
			name:        "Deprecate Risk Model Version"
			description: "Marca model version deprecated com reason. Authority supervisor+."
			rationale:   "errorClassEliminated: 'silent model deprecation'."
			fields: [
				{kind: "primitive", name: "commandId", type:                                "string"},
				{kind: "primitive", name: "correlationId", type:                            "string"},
				{kind: "primitive", name: "modelVersion", type:                             "string"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef:            "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                           "string"},
				{kind: "value-object-ref", name: "deprecationReason", valueObjectRef:   "vo-decision-reason"},
				{kind: "primitive", name: "issuedAt", type:                                 "datetime"},
			]
		},
		{
			code:        "cmd-activate-risk-policy"
			name:        "Activate Risk Policy Version"
			description: "Promove policy version a active status. Authority supervisor+."
			rationale:   "errorClassEliminated: 'unauthorized policy activation'."
			fields: [
				{kind: "primitive", name: "commandId", type:                "string"},
				{kind: "primitive", name: "correlationId", type:            "string"},
				{kind: "primitive", name: "policyVersion", type:            "string"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef: "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:           "string"},
				{kind: "primitive", name: "issuedAt", type:                 "datetime"},
			]
		},
		{
			code:        "cmd-deprecate-risk-policy"
			name:        "Deprecate Risk Policy Version"
			description: "Marca policy version deprecated com reason. Authority supervisor+."
			rationale:   "errorClassEliminated: 'silent policy deprecation'."
			fields: [
				{kind: "primitive", name: "commandId", type:                              "string"},
				{kind: "primitive", name: "correlationId", type:                          "string"},
				{kind: "primitive", name: "policyVersion", type:                          "string"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef:          "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                         "string"},
				{kind: "value-object-ref", name: "deprecationReason", valueObjectRef: "vo-decision-reason"},
				{kind: "primitive", name: "issuedAt", type:                               "datetime"},
			]
		},
		{
			code:        "cmd-raise-risk-alert"
			name:        "Raise Risk Alert (INTERNAL orchestration)"
			description: "Internal orchestration command emitido APENAS por pol-emit-risk-alert-on-eligibility-denied (automated-policy issuer). NÃO exposto via canvas inbound. Idempotent at COMMAND level via composite key (evaluationId, alertCategory) per inv-rew-alert-command-idempotency — concurrent issuance da mesma composite key deduped no command level (não event level — dedupe depois da ação é tarde demais)."
			rationale:   "errorClassEliminated: 'concurrent policy nodes producing duplicate alerts via race-condition pre-event-store'."
			fields: [
				{kind: "primitive", name: "commandId", type:                              "string"},
				{kind: "primitive", name: "correlationId", type:                          "string"},
				{kind: "primitive", name: "alertId", type:                                "string"},
				{kind: "primitive", name: "evaluationId", type:                           "string", description: "IMUTÁVEL post-raise (inv-rew-alert-evaluation-binding-immutability)"},
				{kind: "primitive", name: "alertCategory", type:                          "string"},
				{kind: "primitive", name: "severity", type:                               "string"},
				{kind: "value-object-ref", name: "triggeringContext", valueObjectRef: "vo-applicable-context"},
				{kind: "value-object-ref", name: "issuedBy", valueObjectRef:          "vo-external-ref"},
				{kind: "primitive", name: "actorAuthority", type:                         "string", description: "Sempre 'automated-policy'"},
				{kind: "primitive", name: "issuedAt", type:                               "datetime"},
			]
		},
	]

	// =========================================================
	// INVARIANTS (39)
	// =========================================================
	// 12 originais (S2 founder Phase 3): signal-traceability, contextual-
	//   completeness, bounded-score, deterministic-replay, model-policy-
	//   separation, alert-lifecycle, model-version-binding, asset-aware-
	//   discipline, reasoning-completeness, model-policy-independence,
	//   temporal-consistency, payload-opacity
	// 1 S4 round 1: explicit-supersede-only
	// 6 S4 founder final pressure: active-evaluation-rule (modified for
	//   uniqueness), compute-emit-ordering, alert-dedupe, signal-corruption-
	//   handling, staleness-tracking
	// 5 S4 final pressure: no-staleness-feedback-loop, command-idempotency,
	//   snapshot-temporal-consistency, alert-evaluation-binding-immutability,
	//   evaluation-completeness
	// 1 final mesmo: event-emission-boundedness

	invariants: [
		{
			code: "inv-rew-signal-traceability"
			name: "Signal traceability via immutable snapshot"
			rule: "Toda RiskEvaluation deve referenciar signalSnapshot — lista append-only de #SignalRef (signalRef + signalHash + capturedAt) capturada em ApplicableContext.decisionContextTime. Snapshot é imutável: signal upstream apagado/modificado NÃO afeta evaluations passadas. Hash↔conteúdo verificação é runtime (não CUE)."
			rationale: "Sem snapshot imutável, replay determinístico (inv-rew-deterministic-replay) é impossível e auditoria perde lastro. Schema-time enforce shape (#SignalRef present + tipos primitivos); structural-check enforce ≥1 signal per evaluation; runtime enforce hash↔content match (L3 behavioral). errorClassEliminated: 'evaluation history without verifiable signal lineage'."
		},
		{
			code: "inv-rew-contextual-completeness"
			name: "ApplicableContext required for every evaluation"
			rule: "Toda RiskEvaluation deve incluir ApplicableContext com entityRef + productCode + policyVersion + decisionContextTime + assetVisibility + evaluationScope. Decision categórica sem contexto completo é PROIBIDA por construção."
			rationale: "Glossary Phase 2 estabeleceu Eligibility Decision como CONTEXTUAL (não absoluta). Eligibility sem (produto, política, tempo, asset visibility) é decisão fora-de-contexto — vetor de erro estrutural. errorClassEliminated: 'decision emitted without binding context'."
		},
		{
			code: "inv-rew-bounded-score"
			name: "RiskScore value bounded by scale semantics"
			rule: "RiskScore.value deve respeitar range determinado por RiskScore.scale: probability→[0,1]; normalized→[0,100]; custom→[scaleMetadata.min, scaleMetadata.max]. Score fora do range para sua scale é violação. Comparação cross-model só é legítima quando scales==scales && calibrationProfile==calibrationProfile (mesma escala ≠ mesma semântica)."
			rationale: "Range depende da semântica, não do tipo (founder Phase 3 insight). Score como float livre cria comparação ilusória cross-model; binding scale↔range torna comparabilidade auditable. Enforcement em structural-check sc-rew-score-scale-range (cross-field conditional não expressável em #ValueObject closed schema). errorClassEliminated: 'score comparison ilusória cross-model OR cross-calibration'."
		},
		{
			code: "inv-rew-deterministic-replay"
			name: "Replay determinism via SHA-256 replayHash from canonical serialization"
			rule: "Toda RiskEvaluation deve incluir replayHash: string conforme regex ^[a-f0-9]{64}$ (SHA-256 hex padrão). replayHash deve ser computado a partir de canonical serialization dos inputs: signalSnapshotIds ordered ascending + modelVersion + policyVersion + decisionContextTime (ISO-8601 UTC normalized). Replay com mesmo input em mesma serialization deve produzir replayHash idêntico; divergência indica corrupção."
			rationale: "Determinismo não é propriedade de dado — é propriedade de execução (founder Phase 3 insight). Schema-time enforce presence; structural-check enforce regex; runtime recomputa e compara. Canonical serialization elimina bug clássico: mesmos dados → hash diferente por ordering. errorClassEliminated: 'replay non-determinism causing unauditable decision history'."
		},
		{
			code: "inv-rew-model-policy-separation"
			name: "Model and policy versions are distinct namespaces"
			rule: "RiskEvaluation.modelVersion != RiskEvaluation.policyVersion (strings em namespaces independentes). RiskModel evolui por re-treino/calibração; RiskPolicy evolui por compliance/business rule. Mesma version string em ambos é coincidência ilegítima — enforce desigualdade na shape."
			rationale: "Glossary Phase 2: 'Risk Model e Risk Policy são DISTINTOS e NÃO intercambiáveis'. Model prevê (probabilístico); policy decide (categórico). Compartilhar versionamento esconde acoplamento inválido. Structural part enforceable; 'model não DEPENDE de policy' é inv-rew-model-policy-independence (behavioral). errorClassEliminated: 'model-policy version coupling hiding architectural debt'."
		},
		{
			code: "inv-rew-alert-lifecycle"
			name: "RiskAlert lifecycle is monotonic and irreversible"
			rule: "RiskAlert.status ∈ {open, acknowledged, resolved}. Transições válidas: open→acknowledged→resolved. Resolved exige resolutionReason: string non-empty. Reabertura é PROIBIDA — alert resolved gera novo alert se condição recorre (append-only event log preserva história)."
			rationale: "Lifecycle como state machine declarativa. Conditional 'if status == resolved then resolutionReason' não expressável em VO closed schema — vive em structural-check via state transition guard. Reabertura proibida preserva append-only semantics. errorClassEliminated: 'alert state mutation breaking append-only audit'."
		},
		{
			code: "inv-rew-model-version-binding"
			name: "RiskScore binds to RiskEvaluation model version"
			rule: "RiskScore.computedFromModelVersion deve ser igual ao RiskEvaluation.modelVersion onde o score está embutido. Score gerado por modelo X colado em evaluation que declara modelo Y é corrupção semântica."
			rationale: "Cross-VO consistency dentro do mesmo aggregate. Path-ref unification não disponível em VO catalog model — enforcement em structural-check sc-rew-model-version-binding. errorClassEliminated: 'score generated by different model than declared'."
		},
		{
			code: "inv-rew-asset-aware-discipline"
			name: "Asset visibility gap blocks eligible decision"
			rule: "Se ApplicableContext.assetVisibility == 'gap', então EligibilityDecision.decision NÃO PODE ser 'eligible'. Decision permitidas em gap: 'ineligible' OU 'conditionally_eligible' (com constraints articulando o gap como condição). Ignorância sistêmica (não temos signal sobre o asset) bloqueia approval por construção."
			rationale: "Glossary Phase 2: Asset Visibility Gap reconhece formalmente ignorância sistêmica. Decisão 'eligible' sob gap é falso positivo estrutural — sistema afirma verdade que não pode justificar. Enforcement em structural-check via cross-VO conditional rule (sc-rew-asset-aware-discipline). errorClassEliminated: 'eligible decision under unknown asset = false positive estrutural'."
		},
		{
			code: "inv-rew-reasoning-completeness"
			name: "ReasoningTrace presence with structural minimum (≥2 steps)"
			rule: "Toda RiskEvaluation deve possuir ent-reasoning-trace (entity owned) com inputs.signals[] (≥1), inputs.modelVersion, inputs.policyVersion, intermediateSteps[] (≥2), outputs.score, outputs.eligibility, outputs.confidence. Cardinalidade intermediateSteps ≥ 2 obrigatória — 1 step é output disfarçado de explicação. 'Completude semântica' (todos passos relevantes presentes) é responsabilidade do agente + revisão — não enforceable em CUE."
			rationale: "Trace é evidência auditável, não atributo opcional (founder Phase 3: trace é Entity, não VO). 1 step permite trace trivial. ≥2 força estrutura mínima de raciocínio: input consumption → intermediate computation → output emission. Schema-time enforce cardinality; structural-check enforce inputs.signals[] codes existem em RiskEvaluation.signalSnapshot; runtime enforce semantic completeness via review. errorClassEliminated: 'pseudo-explanation passing as auditable trace'."
		},
		{
			code: "inv-rew-model-policy-independence"
			name: "RiskModel must not depend on RiskPolicy"
			rule: "Definição/treino/versionamento de RiskModel NÃO referencia RiskPolicy.code, RiskPolicy.version nem qualquer state de policy. Sentido oposto é permitido: RiskPolicy referencia RiskModel via modelVersionRef. Quebra desta independência indica corrupção arquitetural (modelo ajustado para satisfazer policy específica = overfitting regulatório)."
			rationale: "BEHAVIORAL — não estruturalmente enforceable. Disciplina de código + revisão humana + ADR review enforcement. Documentado aqui como invariant para fazer parte do contrato semântico do BC. Glossary Phase 2 anti-corruption rule. errorClassEliminated: 'regulatory overfitting via model-policy coupling'."
		},
		{
			code: "inv-rew-temporal-consistency"
			name: "Temporal ordering with bounded clock-skew tolerance"
			rule: "Para toda RiskEvaluation e para todo signal ∈ signalSnapshot, a cadeia temporal monótona é obrigatória COM tolerance window policy-defined (default Phase 0: 5min) em boundaries upstream cross-BC: signal.observedAt ≤ signal.capturedAt + tolerance; signal.capturedAt ≤ signalSnapshotTime + tolerance. Tolerance NÃO se aplica entre signalSnapshotTime → decisionContextTime → evaluatedAt (single clock authority REW)."
			rationale: "Temporal consistency sem tolerância = sistema frágil (founder Phase 3 insight). Real-world clock skew + retry semantics + ingestion delay quebram ordering estrita cross-BC. Tolerance bounded absorve ruído operacional sem mascarar corrupção. Tolerance >15min sinaliza problema infra (clock sync) não problema temporal. errorClassEliminated: 'temporal violation false positive from clock skew' + 'temporal violation masked by oversized tolerance'."
		},
		{
			code: "inv-rew-payload-opacity"
			name: "REW logic must not branch on signal payload fields"
			rule: "REW domain logic (policies, projections, decision rules, score computation) NÃO pode condicionar comportamento em campos específicos de Signal.payload (variants kyc/device/behavioral/fiscal). Branching legítimo é APENAS em signalType + interpretation contract + signalRef shape. Acesso direto a payload field específico em REW logic = violação arquitetural (REW reinterpretando upstream = segundo lugar de verdade)."
			rationale: "BEHAVIORAL — não estruturalmente enforceable em CUE. Disciplina arquitetural + review + ADR enforcement. Anti-corruption rule per glossary Phase 2 + mod-rew-acl boundary. Detection mechanism (review-time): policy.guards/projection.queryCapabilities/domain service consuming payload directly = violação. errorClassEliminated: 'REW logic branching on upstream payload causing reinterpretation drift'."
		},
		{
			code: "inv-rew-explicit-supersede-only"
			name: "Risk Evaluation supersession requires explicit command"
			rule: "REW NUNCA emite evt-risk-evaluation-superseded automaticamente. Supersession ocorre EXCLUSIVAMENTE como resultado de cmd-supersede-risk-evaluation explícito. Mesmo que novo signal arrive invalidando evaluation antiga, ambas evaluations permanecem válidas até cmd-supersede explícito. Race conditions e last-write-wins ELIMINADAS por design — evaluation history é append-only fact log; supersession é decisão auditável separada."
			rationale: "Concurrency sem regra = comportamento não-determinístico (founder Phase 3 insight). Explicit-supersede-only é regra correta para teu design — evaluation é fato; substituição é decisão. Concorrência de signals NÃO causa concorrência de decisões. Enforcement BEHAVIORAL: disciplina + review + sc-rew-no-policy-implicit-supersede em S7 (Policy.triggeredByEvent NÃO inclui events de signal layer when issuesCommand == cmd-supersede-risk-evaluation). errorClassEliminated: 'concurrent signals causing non-deterministic supersession + decision history corruption'."
		},
		{
			code: "inv-rew-active-evaluation-rule"
			name: "Active evaluation = UNIQUE latest emitted, NOT superseded (stale still counts)"
			rule: "Para cada tuple (entityRef, productCode, scope) — onde scope = (assetRef OR entity_level) — EXISTE NO MÁXIMO UMA active evaluation a qualquer momento. Active definida deterministicamente: (a) status emitted (passou por evt-risk-evaluation-emitted); (b) NÃO superseded por cmd-supersede explícito; (c) latest emittedAt para o tuple; ties broken por evaluationId ascending (deterministic tiebreaker). Stale flag NÃO afeta classificação active (stale ainda é active, apenas flagged). Nova emit AUTOMATICAMENTE invalida previous active para mesmo tuple — read-level invalidation, NÃO supersede event."
			rationale: "Supersede = decisão histórica; active = visão operacional (founder Phase 3 insight). Append-only sem regra de leitura deterministic = sistema inutilizável. Uniqueness por scope elimina ambiguidade em projection prj-active-risk-evaluations. Read-level invalidation ≠ supersede: nova emit invalidates previous active ON READ; mas não emite evento. errorClassEliminated: 'ambiguous active state in concurrent emit scenarios causing non-deterministic consumer reads'."
		},
		{
			code: "inv-rew-compute-emit-ordering"
			name: "Emitted requires Computed predecessor with same evaluationId"
			rule: "Toda evt-risk-evaluation-emitted DEVE ter causationId apontando para evt-risk-evaluation-computed com mesmo evaluationId. Emit sem computed predecessor é PROIBIDO (manual replay, bug, falha de ordem). Re-emit (mesmo evaluationId, novo eventId) é permitido se computed predecessor existe."
			rationale: "Ordem de eventos não é garantida — tem que ser validada (founder Phase 3 insight). Split compute/emit cria possibilidade de emit órfão; sem invariant, sistema aceita silenciosamente. Enforcement em sc-rew-compute-emit-ordering (S7) — runner valida event log. errorClassEliminated: 'emitted evaluation without computed predecessor causing replay corruption'."
		},
		{
			code: "inv-rew-alert-dedupe"
			name: "Alert uniqueness key (evaluationId, alertCategory)"
			rule: "alertId NÃO é idempotency key suficiente. Uniqueness é derivada de (evaluationId, alertCategory): mesmo evaluationId + mesma alertCategory → NÃO cria novo alert (idempotent — primeiro alert preservado); mesma alertCategory + nova evaluationId → novo alert; mesmo evaluationId + alertCategory diferente → novo alert. REW NUNCA emite múltiplos alerts para mesma (evaluation, category)."
			rationale: "Alert sem dedupe = ruído → sistema ignorado (founder Phase 3 insight). Repeated alerting da mesma condição causa alert fatigue + downstream consumers ignorando legitimate signals. Dedupe via composite key garantia signal-to-noise alta. errorClassEliminated: 'repeated alerts for same condition causing alert fatigue + signal degradation'."
		},
		{
			code: "inv-rew-signal-corruption-handling"
			name: "Signal corruption discard policy (immutability preserved)"
			rule: "Quando hash mismatch detected (evt-signal-corruption-detected), o incoming signal É DESCARTADO automaticamente: original snapshot PRESERVADO (immutability inviolada); incoming signal NUNCA processado downstream; alert raised category='signal-corruption' severity='critical'; manual re-ingestion (corrigida) requer NEW signalId (não pode reusar identity do corrupted attempt). REW NÃO classifica causa (mutation/corruption/adversarial); delega a review humano via alert."
			rationale: "Detectar corrupção sem decidir o que fazer = meia arquitetura (founder Phase 3 insight). Comportamento determinístico: discard + alert. Alternative (accept as suspect) introduziria estado ambíguo destruindo replay determinism. Chosen path preserva inv-rew-signal-traceability + inv-rew-deterministic-replay incólumes. errorClassEliminated: 'ambiguous handling of corrupted signal causing decision history mutation'."
		},
		{
			code: "inv-rew-staleness-tracking"
			name: "Active evaluation MUST track staleness when relevant signal arrives"
			rule: "Para toda active evaluation E (per inv-rew-active-evaluation-rule), quando signal S arriva tal que match-criteria(S, E) é true, REW DEVE auto-emitir evt-risk-evaluation-marked-stale para E. Match criteria definidos por RiskPolicy.stalenessTriggerCriteria; default Phase 0: signal.entityRef == evaluation.context.entityRef OR signal.assetRef == evaluation.context.assetRef. Staleness NÃO invalida evaluation (continua active per inv-rew-active-evaluation-rule); apenas FLAG visível para consumers. Supersede separado (explicit-only)."
			rationale: "Supersede decide; staleness sinaliza (founder Phase 3 insight). Sem staleness tracking, evaluation envelhece silenciosamente. Implementation: pol-mark-stale-on-relevant-signal triggered por evt-signal-received; emite cmd-mark-evaluation-stale (internal); aggregate emite evt-risk-evaluation-marked-stale. Projection prj-active-risk-evaluations exposes status field {fresh|stale} via derived state. errorClassEliminated: 'evaluation aging silently — consumer using stale decision without awareness'."
		},
		{
			code: "inv-rew-no-staleness-feedback-loop"
			name: "Staleness events must not re-enter decision pipeline"
			rule: "evt-risk-evaluation-marked-stale NÃO pode disparar pol-mark-stale-on-relevant-signal (auto-loop), policy de recompute (cascata não-controlada), policy de auditoria que emite cmd-supersede. Eventos de estado (staleness, alert lifecycle, lineage) são SINAIS de leitura, NÃO triggers de decisão. Reentrada no pipeline causa cascata exponencial em scenarios de signal burst."
			rationale: "Eventos de estado NÃO podem reentrar no pipeline de decisão (founder Phase 3 insight). BEHAVIORAL invariant — disciplina de policy authoring + review + sc-rew-no-state-event-feedback (S7) que valida policies[].triggeredByEvent NÃO inclui evt-risk-evaluation-marked-stale, evt-risk-alert-*, evt-risk-evaluation-superseded. errorClassEliminated: 'feedback loop on state events causing cascading non-deterministic emission'."
		},
		{
			code: "inv-rew-command-idempotency"
			name: "Command retry requires payload integrity (not just commandId match)"
			rule: "Mesmo commandId implica payload IDÊNTICO. Replay de command com mesmo commandId mas payload diferente é REJEITADO (não silently ignored, não silently overwritten — REJECTED com erro explícito). Idempotency real = (commandId, payload canonical hash) match."
			rationale: "Idempotência sem integridade = replay corrompido (founder Phase 3 insight). Naive 'commandId já visto → ignora' permite payload mutation injection (adversarial OR bug) passar undetected. Enforcement em sc-rew-command-idempotency (S7) — runner mantém commandId → payloadHash mapping; mismatch = rejection event. errorClassEliminated: 'command replay with mutated payload causing silent inconsistency'."
		},
		{
			code: "inv-rew-snapshot-temporal-consistency"
			name: "All signals in snapshot must precede decisionContextTime"
			rule: "Para toda RiskEvaluation E e para todo signal s ∈ E.signalSnapshot: s.capturedAt ≤ E.context.decisionContextTime. Snapshot incluindo signal capturado DEPOIS de decisionContextTime é decision usando informação do futuro — replay falso por construção. Refinement de inv-rew-temporal-consistency: aquele invariant trata da chain temporal geral; este é especificamente sobre snapshot membership consistency. Tolerance window NÃO se aplica aqui (snapshot construction é dentro de REW boundary)."
			rationale: "Sem consistência temporal, replay é falso (founder Phase 3 insight). Distinto de inv-rew-temporal-consistency: chain ordering vs snapshot membership rule. Mantido separado (founder ratified): elimina classes de erro diferentes — consolidar perderia poder de diagnóstico. errorClassEliminated: 'future-information leakage via signal post-dating decisionContextTime in snapshot'."
		},
		{
			code: "inv-rew-alert-evaluation-binding-immutability"
			name: "Alert keeps original evaluationId binding (no auto-migration)"
			rule: "RiskAlert.evaluationId é IMUTÁVEL após raise. Quando evaluation referenciada é superseded OR marked-stale, alert NÃO migra automaticamente para nova evaluation. Alert continua binding à evaluation ORIGINAL (fact histórico). Refresh de alert (se necessário) requer novo alert via evt-risk-alert-raised com novo alertId binding à new evaluation. Optional Phase N: evt-risk-alert-invalidated quando evaluation referenciada é superseded — deferred per anti-overfitting (não adicionar até evidência empírica)."
			rationale: "Alert sem referência imutável vira ruído histórico (founder Phase 3 insight). Auto-migration causaria history corruption (alert original some, novo aparece com mesma ID). Append-only fact log preservado: alert é fact sobre evaluation original; new condition em new evaluation = new alert. errorClassEliminated: 'alert binding mutation causing audit trail corruption + temporal traceability loss'."
		},
		{
			code: "inv-rew-evaluation-completeness"
			name: "Evaluation only exists with complete required components"
			rule: "Toda RiskEvaluation só pode existir (computed OR emitted states) se TODOS os componentes seguintes presentes e válidos: (a) signalSnapshot non-empty (cardinality ≥1) referenciando signals que efetivamente existiram em event log; (b) ApplicableContext completo (entityRef, productCode, policyVersion, decisionContextTime, assetVisibility, evaluationScope) — per inv-rew-contextual-completeness; (c) modelVersion non-empty referenciando RiskModel.version que tinha status active em decisionContextTime; (d) policyVersion non-empty referenciando RiskPolicy.version que tinha status active em decisionContextTime; (e) replayHash presente conformidade SHA-256 hex. Evaluation com qualquer destes ausente OR inválido NÃO pode ser computed (REJEITADA na fase de compute) — never emitida."
			rationale: "Estado impossível que não é bloqueado → vai acontecer (founder Phase 3 insight). Invariant global de existência — agrega presence requirements + cross-aggregate version validity. Enforcement parcialmente schema-time (presence), parcialmente structural-check (cross-aggregate version active-at-time validation), parcialmente runtime (signalSnapshot existence em event log). Acts as 'final gate' antes de emit. errorClassEliminated: 'incomplete evaluation reaching consumer state — partial decision causing downstream corruption'."
		},
		{
			code: "inv-rew-event-emission-boundedness"
			name: "Event emission bounded per (scope, time-window)"
			rule: "Para mesmo (entityRef, productCode, scope, time-window): múltiplos signals relevantes → NO MÁXIMO 1 evt-risk-evaluation-marked-stale por evaluation por RiskPolicy.stalenessWindowSeconds; múltiplos triggers para mesma alertCategory dentro de RiskPolicy.alertEmissionWindowSeconds → deduplicados (consistente com inv-rew-alert-dedupe); policies NÃO podem emitir múltiplos eventos equivalentes dentro da mesma janela de consistência por type. 3 windows separados em RiskPolicy: stalenessWindowSeconds (default 60s) + alertEmissionWindowSeconds (default 60s) + emitTimeoutSeconds (default 30s) — anti-acoplamento (window compartilhada vira acoplamento oculto)."
			rationale: "Sem controle de emissão, sistema correto vira sistema inutilizável (founder Phase 3 insight). 3 windows separados eliminam acoplamento oculto entre tipos de evento. errorClassEliminated: 'event storm at scale causing observability collapse + downstream consumer overload'."
		},
		// === S5 batch — 8 invariants (founder Phase 3 final pressure) ===
		{
			code: "inv-rew-alert-no-feedback-to-evaluation"
			name: "Alert lifecycle MUST NOT alter evaluation state"
			rule: "agg-risk-alert é DOWNSTREAM de agg-risk-evaluation. Alert lifecycle (raise/acknowledge/resolve) NÃO pode emitir commands que mutem evaluation state. Alert reage a evaluation; evaluation NUNCA reage a alert. Quebra dessa direção cria ciclo de feedback que destrói append-only semantics + auditability."
			rationale: "Se alert influencia decisão, você criou ciclo (founder Phase 3 insight). BEHAVIORAL — disciplina + review + sc-rew-alert-no-feedback-cmds (S7) que valida policies triggeredByEvent ∈ alert events NÃO emitem commands em evaluation aggregate. errorClassEliminated: 'feedback cycle alert→evaluation causing decision history corruption'."
		},
		{
			code: "inv-rew-version-frozen-at-request"
			name: "Model AND Policy versions FROZEN at cmd-request-risk-evaluation"
			rule: "cmd-request-risk-evaluation captura modelVersion E policyVersion ATIVOS em issuedAt como SNAPSHOT IMUTÁVEL. Toda computação subsequent (compute, emit, replay) usa esses snapshots mesmo se novo model/policy é activated mid-flow. Model e policy são INSEPARÁVEIS — congelar um sem o outro é bug. Nova request com cmd-request distinto pode usar new versions; evaluation existente NUNCA muda."
			rationale: "Model e policy são inseparáveis — congelar um sem o outro é bug (founder Phase 3 insight). Freeze at command é stronger choice porque elimina race entre activation e compute. errorClassEliminated: 'mid-flow model OR policy swap causing comparability collapse'."
		},
		{
			code: "inv-rew-policy-version-immutability-per-evaluation"
			name: "Policy version IDENTICAL across compute and emit per evaluation"
			rule: "policyVersion usada na fase compute (registrada em evt-risk-evaluation-computed) DEVE ser idêntica a policyVersion na fase emit (registrada em evt-risk-evaluation-emitted) para mesma evaluationId. Race entre compute e emit onde policy evolui mid-flow é REJEITADA (emit fails se policyVersion diverge). Policy é parte da VERDADE da decisão, não configuração externa."
			rationale: "Policy é parte da verdade da decisão, não configuração externa (founder Phase 3 insight). errorClassEliminated: 'policy drift between compute and emit causing decision misattribution'."
		},
		{
			code: "inv-rew-evaluation-lineage-acyclic"
			name: "Evaluation lineage tree MUST be acyclic"
			rule: "parentEvaluationId chain forma DIRECTED ACYCLIC GRAPH (DAG). Para qualquer evaluation E, traversal recursivo de parentEvaluationId → parent.parentEvaluationId → ... nunca retorna a E. Ciclos (E1 → E2 → E3 → E1) são PROIBIDOS por construção — destruem temporal ordering + replay determinism + supersede semantics. Adicionalmente: parentEvaluationId.emittedAt < evaluation.emittedAt (temporal ordering reforçado)."
			rationale: "Grafo sem restrição vira ciclo — ciclo quebra história (founder Phase 3 insight). errorClassEliminated: 'lineage cycle destroying temporal ordering + supersede consistency'."
		},
		{
			code: "inv-rew-supersede-after-emit-only"
			name: "Supersession requires evaluation in emitted or stale state"
			rule: "cmd-supersede-risk-evaluation só pode ser aceito quando target evaluation está em status ∈ {emitted, stale}. Supersede de evaluation em status pré-lifecycle (computed phase awaiting emit) é PROIBIDO — substituir something que não foi publicado é nonsense. Supersede de evaluation em status='superseded' (já terminal) é PROIBIDO — duplicate supersede."
			rationale: "Race condition real: emit acontece em T1 + supersede chega em T0 (out-of-order). Sem essa rule, supersede pode ser aceito antes de emit completar — estado impossível. errorClassEliminated: 'pre-emit supersede causing impossible state (superseded never-emitted)'."
		},
		{
			code: "inv-rew-compute-implies-emit"
			name: "Every computed evaluation MUST be followed by emitted OR emit-failed"
			rule: "Toda evt-risk-evaluation-computed DEVE ter event subsequent com mesmo evaluationId — OU evt-risk-evaluation-emitted (success) OU evt-risk-evaluation-emit-failed (abort). Computed sem follow-up event = orphan state inválido. Schema friction: lifecycle states não inclui 'computed' (computed é transient pre-lifecycle); compute → emit é AUTOMÁTICO via runtime (não command-driven)."
			rationale: "Se não existe escolha, não é command — é transição (founder Phase 3 insight). compute→emit é transição automática; runtime garante OR emit OR fail. errorClassEliminated: 'orphan computed without follow-up causing replay history gap'."
		},
		{
			code: "inv-rew-computed-idempotent-retry"
			name: "Computed events are idempotent and retry-safe"
			rule: "evt-risk-evaluation-computed com mesmo (evaluationId, replayHash) é IDEMPOTENTE — re-emission via retry produz NEW eventId mas SAME evaluationId + SAME replayHash. Consumer (downstream emission logic) dedupa via evaluationId. Failure de emission post-compute NÃO bloqueia evaluation — retry permitido até timeout policy-defined (default 3 retries com exponential backoff). Após timeout, evaluation marcada via evt-risk-evaluation-emit-failed."
			rationale: "Todo estado precisa de estratégia de retry (founder Phase 3 insight). Idempotency via (evaluationId + replayHash) garante retry safe sem duplicate compute. errorClassEliminated: 'duplicate compute on retry causing event log pollution'."
		},
		{
			code: "inv-rew-single-successor-per-evaluation"
			name: "Lineage tree: at most ONE direct successor per evaluation"
			rule: "Para qualquer evaluation E, existe NO MÁXIMO UMA evaluation E' tal que E'.parentEvaluationId == E.evaluationId. Branching no lineage tree é PROIBIDO — múltiplos sucessores de mesma E indicam erro lógico (concurrent supersede da mesma evaluation = race condition violando inv-rew-explicit-supersede-only). Resultado: lineage forma TREE (não DAG, não graph)."
			rationale: "Árvore vs grafo não é detalhe — muda semântica do sistema (founder Phase 3 insight). Tree é correta para risk decision: chain linear de supersession por scope; 'active' = leaf node do scope. errorClassEliminated: 'lineage branching creating multiple current evaluations per scope'."
		},
		// === Production-safety batch — 4 invariants (Step B) ===
		{
			code: "inv-rew-computed-must-eventually-emit-or-fail"
			name: "Computed evaluation MUST eventually emit OR fail explicitly (emit-failed = ABORT, not state)"
			rule: "Toda evt-risk-evaluation-computed DEVE produzir UMA das duas consequências dentro de RiskPolicy.emitTimeoutSeconds (default Phase 0: 30s): (a) evt-risk-evaluation-emitted com mesmo evaluationId → evaluation entra em lifecycle (state='emitted'); (b) evt-risk-evaluation-emit-failed com mesmo evaluationId + failureReason + retryExhausted=true → ABORT do lifecycle. emit-failed é ABORT EXPLÍCITO. Evaluation com emit-failed NÃO entra em projection / active rule / supersede target. Permanece em event log como FACT histórico mas NÃO é evaluation válida no domínio. Evaluation = emitted by definition. nem todo cálculo deve virar estado. Retry ownership: runtime infra owns retries com exponential backoff até timeout."
			rationale: "Retry sem dono = retry inexistente + nem todo cálculo deve virar estado (founder Phase 3 insights). errorClassEliminated: 'computed evaluation invisible OR becoming spurious lifecycle state'."
		},
		{
			code: "inv-rew-alert-command-idempotency"
			name: "Alert raise commands idempotent at COMMAND level (not just event level)"
			rule: "cmd-raise-risk-alert é idempotent via composite key (evaluationId, alertCategory). Concurrent issuance da mesma composite key (e.g., dois nós de policy detectando mesmo evt-risk-evaluation-emitted) é deduped no COMMAND level — APENAS UM cmd succeeds; demais retornam idempotent-success com original alertId. Dedupe tardio (event-level via inv-rew-alert-dedupe) é INSUFICIENTE — comando duplicado causa side-effects duplicados antes de event reach storage."
			rationale: "Dedupe depois da ação é tarde demais (founder Phase 3 insight). errorClassEliminated: 'concurrent policy nodes producing duplicate alerts via race-condition pre-event-store'."
		},
		{
			code: "inv-rew-supersede-requires-current-active"
			name: "Supersede only succeeds if target is CURRENTLY active (atomic check)"
			rule: "cmd-supersede-risk-evaluation só pode ser aceito se target evaluation é a UNIQUE ACTIVE per inv-rew-active-evaluation-rule no momento do command processing (atomic check no aggregate via optimistic concurrency control / CAS on supersededBy field). Se evaluation já foi superseded por outro cmd concorrente, novo cmd-supersede falha com explicit error 'already-superseded'. Garantir TREE shape via inv-rew-single-successor-per-evaluation NÃO é suficiente — invariant detecta post-hoc; race condition acontece BEFORE detection."
			rationale: "Garantir forma do grafo não resolve concorrência (founder Phase 3 insight). errorClassEliminated: 'concurrent supersedes producing lineage fork pre-detection'."
		},
		{
			code: "inv-rew-signal-validation-before-ingestion"
			name: "Signal validation MUST occur at ACL boundary; FAILED = evt-signal-rejected (NEVER silent drop)"
			rule: "evt-signal-received SÓ pode existir após validação ACL passar (6 checks): (a) signalType válido (enum); (b) sourceContext válido (enum); (c) signalType ↔ sourceContext canonical mapping; (d) integrityProof presente + proofType válido; (e) payloadVoCode existe em VO catalog + matches signalType; (f) payload referenced via payloadInstance disponível em sourceContext BC. Validation FAILED = REW DEVE emitir evt-signal-rejected com rejectionReason + validationCheckFailed + originalSignalRef. NUNCA drop silent (ambiguity em boundary = bug futuro). Rejected signals NUNCA entram no domínio."
			rationale: "Boundary não declarado vira superfície de ataque + ambiguidade em boundary = bug futuro (founder Phase 3 insights). errorClassEliminated: 'malformed signal silently dropped causing missing audit trail + debugging blind spots'."
		},
		// === Final pressure batch — 3 invariants (production-safe decision system) ===
		{
			code: "inv-rew-supersede-emit-failed-precedence"
			name: "Mutual exclusion: supersede and emit-failed cannot both apply to same evaluation"
			rule: "Para evaluation E em phase computed (awaiting emit OR fail), precedência DETERMINÍSTICA: (a) Se evt-risk-evaluation-emit-failed processed BEFORE cmd-supersede-risk-evaluation arrives at aggregate: cmd-supersede REJECTED com 'target-aborted-not-supersedable' — evaluation NUNCA entrou lifecycle; supersede de não-evaluation é nonsense. (b) Se evt-risk-evaluation-emitted processed BEFORE emit-timeout reached: emit succeeds; pending emit-failed timeout cancelled (runtime sentinel). Subsequent cmd-supersede aplicado normalmente sobre evaluation em status='emitted'. (c) Concurrent processing (race condition real): atomic ordering via event log timestamp + CAS no aggregate. FIRST-WINS deterministically; second outcome becomes idempotent-noop com explicit audit log entry 'precedence-resolved-against'. PRECEDÊNCIA SEMÂNTICA: supersede só pode operar sobre evaluation ∈ lifecycle (status ∈ {emitted, stale}); emit-failed pre-cedes lifecycle entry; logo supersede de aborted-evaluation é semanticamente nonsense — não apenas operacionalmente bloqueado."
			rationale: "Bug pode parecer comportamento válido (founder Phase 3 insight). Sem precedência terminal SEMÂNTICA, dois outcomes mutuamente exclusivos coexistem semanticamente — auditor humano trava porque evaluation foi superseded OR aborted? Precedência semântica (supersede só em lifecycle) torna ambíguo SEMANTICAMENTE INVÁLIDO, não apenas operacionalmente. errorClassEliminated: 'ambiguous terminal state breaking audit explanation + downstream reasoning'."
		},
		{
			code: "inv-rew-evaluation-temporal-validity"
			name: "Evaluation has explicit temporal validity window (validUntilTimestamp)"
			rule: "Toda RiskEvaluation emitted DEVE incluir validUntilTimestamp computed at emit time: validUntilTimestamp = emittedAt + RiskPolicy.evaluationValidityWindowSeconds. evaluationValidityWindowSeconds policy-defined per scope (default Phase 0 entity_level: 300s; asset_level: 120s; product-specific overrides via policy variants). Decisão temporal-validity: consumer reading evaluation com now() ≤ validUntilTimestamp = decisão TEMPORALMENTE VÁLIDA; consumer reading com now() > validUntilTimestamp = evaluation EXPIRED — consumer MUST request fresh OR explicitly accept stale-by-time risk via ADR override. Stale flag (signal-driven) é INDEPENDENTE de expired (time-driven): evaluation pode ser fresh-but-stale (relevant signal arrived) OR fresh-and-valid OR expired (regardless of stale flag)."
			rationale: "Decisão tomada com base em realidade já inválida (founder Phase 3 insight — falha CRÍTICA). Modelar evaluation state sem temporal validity = consumer correto + protocolo seguido + decisão errada = inevitável em escala. validUntilTimestamp torna BOUNDARY explícito entre 'evaluation existe' e 'decisão pode ser tomada'. Sistema saiu de 'estado correto' para 'decisão correta no tempo'. errorClassEliminated: 'consumer decision based on temporally-invalid-but-state-valid evaluation causing systemic divergence'."
		},
		{
			code: "inv-rew-replay-scope-completeness"
			name: "Replay output declares completeness explicitly via replayConfidence enum"
			rule: "Toda operação de replay (per replayScopeStrategy='by-entityRef') DEVE produzir output com replayConfidence enum: 'complete' (todos signals em signalSnapshot replicados; NENHUMA cross-entity dependency necessária — output trusted como authoritative), 'partial' (cross-entity dependency existe; replay usa inputs PARCIAIS apenas — flag alerta consumer que reconstruction é aproximação), 'degraded' (missing signals detected during replay OR replayHash recompute mismatch — output NÃO trusted; review humano obrigatório). Consumer of replay output MUST handle cada level appropriately: 'complete' → auditing/regulatory; 'partial' → debugging com awareness, NÃO auditing; 'degraded' → escalation only, NÃO usable."
			rationale: "Replay pode mentir e você aceita (founder Phase 3 insight). Cross-entity replay limitation declarada em adr-084 NÃO era suficiente — falta CRITÉRIO DE COMPLETUDE. replayConfidence força declaração explícita de qualidade do replay; consumer adapta uso. Sistema saiu de 'reconstrução' para 'reconstrução com grau de verdade declarado'. errorClassEliminated: 'silent replay inaccuracy causing fabricated history accepted as truth'."
		},
		// === War Game Round 2 batch — 7 invariants (boundary commit) ===
		{
			code: "inv-rew-acl-validation-cost-bounded"
			name: "ACL validation cost bounded per-signal AND per-window"
			rule: "ACL validation tem 2 budgets distintos enforced runtime: (a) aclValidationCostBudgetPerSignalMs (default 50ms) — single signal validation cost; signal exceeding budget rejeitado com validationCheckFailed='cost-exceeded'. (b) aclValidationCostBudgetPerSecondMs (default 50000ms = 50s compute per 1s wall — assume ~50 concurrent validation slots) — cumulative cost per window; window exhausted → ACL throttle ativated; subsequent signals enqueued OR backpressured upstream. Sem dois budgets: ataque distribuído passa invisível (signals individualmente baratos mas caros em agregação)."
			rationale: "Protege output mas não protege processamento (founder War Game 2 insight). Distinção per-signal vs per-window crítica: per-signal previne spike attack; per-window previne distributed-cheap attack. Enforcement runtime via sc-rew-acl-cost-bounded (architecture/structural-checks/rew-domain-model.cue) — schema declara presença dos budgets; runtime enforces. errorClassEliminated: 'distributed validation cost attack saturating system silently'."
		},
		{
			code: "inv-rew-obsolete-evaluation-must-link-successor"
			name: "Late emit blocked by newer evaluation MUST link successor (NOT failure)"
			rule: "Quando emit handler detecta newer evaluation E_other para mesmo scope com emittedAt > THIS.computedAt, THIS NÃO é tratada como FAILURE (evt-risk-evaluation-emit-failed) mas como OBSOLESCENCE — emite evt-risk-evaluation-emit-superseded-by-newer com successorEvaluationId=E_other.evaluationId. Distinção semântica: failure = sistema não conseguiu computar; obsolescence = sistema computou mas newer reality já existe; consumer pode USAR successor em vez de retry. Sem essa distinção: false negative semântico → consumer retry → loop indefinido."
			rationale: "FAILURE ≠ OBSOLESCENCE (founder War Game 2 insight). Consumer originador recebe successorEvaluationId reference — pode adopt successor OR re-request com fresh inputs (decisão consumer). errorClassEliminated: 'consumer retry loop on obsolescence misclassified as failure'."
		},
		{
			code: "inv-rew-successor-chain-bounded"
			name: "Successor chain MUST be bounded (consumer max-hops; default 3)"
			rule: "Quando consumer segue successorEvaluationId chain (E1 → E2 → E3 → ...), MUST NOT seguir além de N hops (default Phase 0: 3 hops; configurable per consumer policy). Após N hops sem chegar a evaluation 'fresh-and-valid', consumer DEVE: (a) emitir cmd-request-risk-evaluation novo com fresh request OR (b) escalate via ADR override OR (c) abort decisão. Sem bound: chain pode loop indefinitely (E_n superseded por E_{n+1} ad infinitum em high-throughput scenarios) gerando consumer-side infinite resolution loop."
			rationale: "Loop de resolução indireto (founder War Game 2 insight). chain-bounded é GUARDRAIL para consumer behavior (não REW behavior — REW emite chain naturally). Enforcement consumer-side via consumerProtocol entry. errorClassEliminated: 'infinite successor chain following causing consumer livelock'."
		},
		{
			code: "inv-rew-replay-confidence-propagation"
			name: "Replay confidence MUST propagate to all downstream usage (training, analytics, derived signals)"
			rule: "Outputs de replay com replayConfidence != 'complete' DEVEM propagar confidence metadata para qualquer downstream usage chain: training pipelines, analytics aggregations, derived signals (signal generation from replay), audit reports. Downstream usage MUST attach confidenceProvenance metadata: {originalReplayConfidence, propagationDepth, derivedFromReplayId}. Sem propagação: erro parcial vira verdade futura (replay 'partial' alimenta training; trained model retorna a REW; sistema 'aprende errado' silently)."
			rationale: "Erro parcial vira verdade futura (founder War Game 2 insight). Protege uso INDIRETO além do uso direto (consumerProtocol replay entry já cobre uso direto). Enforcement runtime via data lineage tracking infra (BEHAVIORAL — runtime concern); structural-check valida que derived artifacts declaram provenance. errorClassEliminated: 'partial replay confidence leaking into authoritative chain via training pipeline'."
		},
		{
			code: "inv-rew-decision-binding-to-evaluation-version"
			name: "Downstream actions MUST bind to evaluationId + check supersede before commit (TOCTOU defense)"
			rule: "Toda ação downstream (CMT pagamento, FCE bloqueio, SCF crédito) que use REW evaluation DEVE: (a) referenciar evaluationId usado em ação metadata; (b) RECHECK evaluation status no aggregate (não projection) ANTES de commit final da ação; (c) se evaluation foi superseded entre leitura e commit → ação DEVE FALHAR com 'evaluation-superseded-during-execution' OR REVALIDATE com new evaluation. Time-of-check ≠ time-of-use (TOCTOU): protege intervalo entre consumer.read e consumer.commit."
			rationale: "TOCTOU: protege leitura, não intervalo entre leitura e ação (founder War Game 2 insight). Enforcement consumer-side via consumerProtocol entry — consumers (CMT/FCE/SCF) responsabilidade. REW provê evaluationId binding + supersede check API (qry-rew-evaluation-current-status). errorClassEliminated: 'consumer action committed against superseded evaluation due to read-action time gap'."
		},
		{
			code: "inv-rew-undetectable-pattern-risk-declared"
			name: "Systemic risks beyond REW detection scope MUST be declared in systemFailureModes (honesty invariant)"
			rule: "Riscos sistêmicos que REW NÃO consegue detectar (cross-entity adversarial patterns abaixo de threshold; distributed fraud; covariância multi-entity) DEVEM ser DECLARADOS explicitly em systemConsistencyModel.systemFailureModes. Este invariant é HONESTY invariant — força VISIBILIDADE, NÃO COMPORTAMENTO. NÃO bloqueia nada; NÃO valida nada; NÃO interfere em fluxo; NÃO entra em aggregate.protectsInvariants enforcement; NÃO entra em policy.guards. Apenas EXIGE que systemFailureModes contenha entry para cada risk class identificado as undetectable."
			rationale: "Falha sistêmica invisível → risco explícito auditável (founder War Game 2 insight). Honesty invariant transforma silent gap em declared limitation. Verificação via sc-rew-pattern-risk-declared (declarative kind) — confirms systemFailureModes contém entries para distributed-fraud-below-threshold + cross-entity-correlation-undetected. Pattern paralelo a invariants existentes 'declarar limitação ≠ resolver' (replayScopeStrategy limitation; cross-BC enforcement def-016). errorClassEliminated: 'systemic blind spot hidden as implicit limitation; auditor cannot identify what system DOES NOT cover'."
		},
	]

	// =========================================================
	// VALUE OBJECTS (17)
	// =========================================================
	// Utility (4): vo-version-stamp, vo-external-ref, vo-integrity-proof,
	//   vo-signal-ref
	// Signal layer (5): vo-signal + 4 payload variants (kyc/device/
	//   behavioral/fiscal)
	// Domain core (5): vo-risk-score, vo-confidence-interval, vo-coverage-
	//   stats, vo-eligibility-decision, vo-applicable-context
	// Type catalog (3): vo-uncertainty-driver, vo-decision-reason
	// Scale metadata (1): vo-scale-metadata
	// Storage workaround pattern (Opção A founder ratified): VO catalog
	//   define TYPE; field é primitive string com structural-check parse +
	//   element validation. Aplicado a uncertaintyDrivers, constraints,
	//   blockingReasons, missingSignals, signalSnapshotIds.

	valueObjects: [
		{
			code:        "vo-version-stamp"
			name:        "Version Stamp"
			description: "Versioning metadata reusable: version identifier (regex v[0-9]+) + compatibility flags. Aplicado a Signal, ApplicableContext, e qualquer VO em eixo de evolução. Schema-time enforce presença; structural-check enforce regex pattern + semântica de compatibility."
			fields: [
				{kind: "primitive", name: "version", type: "string", description: "Identifier conforme ^v[0-9]+$ (regex enforced em sc-rew-version-format)"},
				{kind: "primitive", name: "backwardCompatible", type: "boolean", description: "Consumers da versão anterior continuam funcionando sem alteração"},
				{kind: "primitive", name: "requiresMigration", type: "boolean", description: "Existe data migration entre versões; false implica zero-cost upgrade"},
			]
			constraints: [
				"version regex pattern: ^v[0-9]+$ (sc-rew-version-format)",
				"Semântica: backwardCompatible=false implica requiresMigration=true (sc-rew-version-coherence)",
			]
			rationale: "Version sem compatibilidade = número decorativo (founder Phase 3 insight). Reusable via valueObjectRef em qualquer VO versionado evita duplicação de campos de versionamento. Justifica VO independente: identidade semântica clara, invariants próprios (regex + xor compatibility), evolução independente. errorClassEliminated: 'version sem semantics de compatibilidade'."
		},
		{
			code:        "vo-external-ref"
			name:        "External Cross-BC Reference"
			description: "Referência tipada para entidades externas ao REW (asset, entity, product, actor) com sourceContext explícito. Substitui string opaca que cria coupling invisível. sourceContext declara origem (inv|fce|scf|cmt|dlv|nim|npm|ext-*) — runner cross-file valida que externalRef existe no BC declarado (Phase 1+ quando query-surfaces materializadas)."
			fields: [
				{kind: "primitive", name: "externalRef", type: "string", description: "Identifier opaco no BC de origem (formato declared by source BC, não interpretado por REW)"},
				{kind: "primitive", name: "sourceContext", type: "string", description: "BC origin code conforme enum {inv,fce,scf,cmt,dlv,nim,npm,ext-*}"},
			]
			constraints: [
				"sourceContext enum: ^(inv|fce|scf|cmt|dlv|nim|npm|ext-[a-z][a-z0-9-]*|rew)$ (sc-rew-source-context-enum) — 'rew' permitido para self-references (e.g., policy issuer)",
				"Cross-BC ref integrity: runner cross-file (Phase 1+) valida externalRef existe em sourceContext BC",
			]
			rationale: "Referência sem origem = acoplamento invisível (founder Phase 3 insight). REW NÃO é dono de asset/entity/product — declarar sourceContext torna dependência cross-BC EXPLICITA e revisável. errorClassEliminated: 'implicit cross-BC coupling'."
		},
		{
			code:        "vo-integrity-proof"
			name:        "Integrity Proof Reference"
			description: "Proof of integrity para signal payload upstream (signature, hash chain, attestation). REW NÃO valida proof semanticamente — verifica que existe e que proofType é reconhecido; runtime usa proofRef para re-verificação se necessário."
			fields: [
				{kind: "primitive", name: "proofType", type: "string", description: "Tipo do proof: ^(signature|hash-chain|attestation|notarized)$"},
				{kind: "primitive", name: "proofRef", type: "string", description: "Identifier opaco do proof artifact em storage upstream"},
			]
			constraints: [
				"proofType enum: ^(signature|hash-chain|attestation|notarized)$ (sc-rew-proof-type-enum)",
			]
			rationale: "Signal sem proof = trust upstream sem auditabilidade. REW como controle epistemológico (glossary Phase 2) EXIGE rastreabilidade. Validation semântica do proof é runtime concern. errorClassEliminated: 'trust upstream sem auditabilidade'."
		},
		{
			code:        "vo-signal-ref"
			name:        "Signal Snapshot Reference"
			description: "Reference imutável a signal capturado em snapshot. Composição: vo-external-ref (signalId + sourceContext) + snapshot-specific fields (signalHash + capturedAt). Triple {ref, hash, capturedAt} garante replay determinístico + detecção de mutação upstream + traceability de origem."
			fields: [
				{kind: "value-object-ref", name: "signalRef", valueObjectRef: "vo-external-ref", description: "Reference ao signal upstream — externalRef (signalId) + sourceContext (npm/dlv/nim/fce)"},
				{kind: "primitive", name: "signalHash", type: "string", description: "Hash SHA-256 hex do signal payload no momento da captura — runtime verifica match"},
				{kind: "primitive", name: "capturedAt", type: "datetime", description: "Timestamp ISO-8601 UTC quando REW snapshotou o signal"},
			]
			constraints: [
				"signalHash regex: ^[a-f0-9]{64}$ (SHA-256 hex; sc-rew-hash-format)",
				"capturedAt deve ser ≤ signalSnapshotTime do RiskEvaluation parent (temporal monotonia; sc-rew-temporal-ordering)",
				"signalRef.sourceContext ∈ canvas inbound contextDependencies (sc-rew-signal-source-canvas-binding)",
			]
			rationale: "Referência sem origem = ambiguidade histórica (founder Phase 3 insight). Composição com vo-external-ref preserva sourceContext explícito + reuso (DRY) + evita duplicação de pattern cross-BC ref. Snapshot triple semantics: signalRef binds upstream identity; signalHash binds content at capture; capturedAt binds time of capture. errorClassEliminated: 'signal source ambiguity + replay drift'."
		},
		{
			code:        "vo-signal"
			name:        "Signal (interpreted upstream observation)"
			description: "Tipo central da Layer 1 (Reality Interpretation) per glossary Phase 2: 'Signal NÃO é dado bruto, NÃO é evento, NÃO é métrica agregada — É interpretação validada upstream'. Discriminated union via signalType + payloadVoCode (binding estrutural enforced em sc-rew-signal-payload-binding). Schema-time enforce shape; structural-check enforce signalType ↔ payloadVoCode pairing válido."
			fields: [
				{kind: "primitive", name: "signalId", type: "string", description: "Identifier upstream (NPM/DLV/NIM/FCE)"},
				{kind: "primitive", name: "signalType", type: "string", description: "Discriminator: ^(kyc|device|behavioral|fiscal)$"},
				{kind: "primitive", name: "sourceContext", type: "string", description: "BC origin: ^(npm|dlv|nim|fce)$"},
				{kind: "primitive", name: "observedAt", type: "datetime", description: "Quando o fato aconteceu no mundo"},
				{kind: "primitive", name: "recordedAt", type: "datetime", description: "Quando upstream BC registrou o signal"},
				{kind: "value-object-ref", name: "integrityProof", valueObjectRef: "vo-integrity-proof"},
				{kind: "value-object-ref", name: "versionStamp", valueObjectRef: "vo-version-stamp"},
				{kind: "primitive", name: "payloadVoCode", type: "string", description: "Code da VO concreta que define payload structure: ^vo-signal-payload-(kyc|device|behavioral|fiscal)$"},
				{kind: "value-object-ref", name: "payloadInstance", valueObjectRef: "vo-external-ref", description: "Reference ao payload instance armazenado em sourceContext BC; preserva sourceContext explícito"},
			]
			constraints: [
				"signalType enum: ^(kyc|device|behavioral|fiscal)$ (sc-rew-signal-type-enum)",
				"sourceContext enum: ^(npm|dlv|nim|fce)$ (sc-rew-signal-source-enum)",
				"signalType ↔ sourceContext canonical mapping {kyc→npm, fiscal→fce, device→nim, behavioral→dlv} (sc-rew-signalType-source-binding) — estruturalmente válido ≠ semanticamente correto",
				"payloadVoCode regex: ^vo-signal-payload-(kyc|device|behavioral|fiscal)$ (sc-rew-signal-payload-vo-code)",
				"Discriminated binding REGRA CRÍTICA: signalType=='kyc' ⟺ payloadVoCode=='vo-signal-payload-kyc'; idem device/behavioral/fiscal (sc-rew-signal-payload-binding)",
				"payloadInstance.sourceContext deve igualar vo-signal.sourceContext (sc-rew-signal-payload-source-coherence)",
				"Temporal: observedAt ≤ recordedAt + tolerance (5min default; sc-rew-temporal-ordering)",
				"Anti-corruption (BEHAVIORAL): REW logic NÃO branch em campos de payload — apenas em signalType + interpretation contract (vide inv-rew-payload-opacity)",
			]
			rationale: "Signal vive no boundary entre upstream BCs e domínio REW. Discriminated union mal feita = type safety falsa (founder Phase 3 insight). Binding signalType↔payloadVoCode via structural-check é o único caminho dado #ValueObject schema fechado. payloadVoCode declara EXPLICITAMENTE qual VO concreta define payload structure. Glossary Phase 2 firewall semântico preserved: REW consome interpretation contract upstream, não payload bruto. errorClassEliminated: 'raw upstream observation acoplada a REW logic' + 'type safety falsa em discriminated union'."
		},
		{
			code:        "vo-signal-payload-kyc"
			name:        "Signal Payload — KYC variant"
			description: "Payload tipado para signalType='kyc'. Conteúdo interpretado upstream pelo NPM (KYC primary owner). REW recebe interpretation result (não raw documents). Structural-check bind: vo-signal.signalType=='kyc' ↔ vo-signal.payloadVoCode=='vo-signal-payload-kyc'."
			fields: [
				{kind: "primitive", name: "kycStatus", type: "string", description: "^(verified|pending|rejected|expired)$"},
				{kind: "primitive", name: "verificationLevel", type: "string", description: "^(basic|enhanced|full)$"},
				{kind: "primitive", name: "verifiedAt", type: "datetime"},
				{kind: "value-object-ref", name: "subjectRef", valueObjectRef: "vo-external-ref", description: "Reference to verified entity in NPM"},
			]
			constraints: [
				"kycStatus enum: ^(verified|pending|rejected|expired)$ (sc-rew-kyc-status-enum)",
				"verificationLevel enum: ^(basic|enhanced|full)$ (sc-rew-kyc-level-enum)",
				"subjectRef.sourceContext deve ser 'npm' (sc-rew-kyc-source-binding)",
			]
			rationale: "KYC é primary signal type — verification status é input categórico para policy decision. REW NÃO faz re-verification — consome interpretation NPM. subjectRef via vo-external-ref preserva sourceContext explícito. errorClassEliminated: 'type safety falsa em discriminated union (KYC variant)'."
		},
		{
			code:        "vo-signal-payload-device"
			name:        "Signal Payload — Device fingerprint variant"
			description: "Payload tipado para signalType='device'. Sinais de device fingerprint, behavioral biometrics, anomalias de session — interpretados upstream por NIM (network integrity)."
			fields: [
				{kind: "primitive", name: "fingerprintHash", type: "string", description: "Hash anonimizado do device fingerprint (^[a-f0-9]{64}$)"},
				{kind: "primitive", name: "anomalyLevel", type: "string", description: "^(none|low|medium|high|critical)$"},
				{kind: "primitive", name: "sessionRisk", type: "decimal", description: "Range [0,1] — risk score de session aderente a calibração NIM"},
				{kind: "primitive", name: "geolocationCategory", type: "string", description: "Categoria genérica: ^(domestic|cross-border|tor-vpn|unknown)$"},
			]
			constraints: [
				"anomalyLevel enum: ^(none|low|medium|high|critical)$ (sc-rew-device-anomaly-enum)",
				"sessionRisk range: 0 ≤ value ≤ 1 (sc-rew-device-session-risk-range)",
				"geolocationCategory enum: ^(domestic|cross-border|tor-vpn|unknown)$ (sc-rew-device-geo-enum)",
				"fingerprintHash regex: ^[a-f0-9]{64}$ (sc-rew-device-fingerprint-format)",
			]
			rationale: "Device signal exige anonimização (fingerprintHash, não raw fingerprint) — privacy by design. geolocationCategory categórica (não lat/long) preserva minimização. sessionRisk como decimal NÃO tem mesma semantic-equivalence cross-model (NIM scale) — REW reinterpreta via calibrationProfile. errorClassEliminated: 'device payload privacy leakage' + 'type safety falsa em discriminated union (device variant)'."
		},
		{
			code:        "vo-signal-payload-behavioral"
			name:        "Signal Payload — Behavioral pattern variant"
			description: "Payload tipado para signalType='behavioral'. Sinais de transaction patterns, velocity anomalies, peer comparison — interpretados upstream por DLV."
			fields: [
				{kind: "primitive", name: "patternCategory", type: "string", description: "^(velocity|peer-deviation|circadian|amount-distribution)$"},
				{kind: "primitive", name: "deviationMagnitude", type: "decimal", description: "Z-score (standardized) — pode ser negativo (sub-pattern)"},
				{kind: "primitive", name: "windowDays", type: "integer", description: "Time window do pattern: 1-365"},
				{kind: "primitive", name: "confidence", type: "decimal", description: "Range [0,1] — confidence upstream do pattern detection"},
			]
			constraints: [
				"patternCategory enum: ^(velocity|peer-deviation|circadian|amount-distribution)$ (sc-rew-behavior-category-enum)",
				"windowDays range: 1 ≤ value ≤ 365 (sc-rew-behavior-window-range)",
				"confidence range: 0 ≤ value ≤ 1 (sc-rew-behavior-confidence-range)",
			]
			rationale: "Behavioral signal vive em base statistical (Z-score permite negativo — sub-pattern indica comportamento ABAIXO do baseline). patternCategory como enum fechado evita drift de interpretação cross-time. errorClassEliminated: 'type safety falsa em discriminated union (behavioral variant)'."
		},
		{
			code:        "vo-signal-payload-fiscal"
			name:        "Signal Payload — Fiscal/regulatory variant"
			description: "Payload tipado para signalType='fiscal'. Sinais de compliance fiscal, sanctions screening, regulatory reporting — interpretados upstream por FCE."
			fields: [
				{kind: "primitive", name: "fiscalStatus", type: "string", description: "^(compliant|warning|non-compliant|sanctioned)$"},
				{kind: "primitive", name: "regulatoryFramework", type: "string", description: "^(bacen|coaf|sefaz|ofac|fatf)$ — framework de origem da avaliação"},
				{kind: "primitive", name: "evaluatedAt", type: "datetime"},
				{kind: "value-object-ref", name: "regulatoryDocRef", valueObjectRef: "vo-external-ref", description: "Reference to regulatory determination in FCE"},
			]
			constraints: [
				"fiscalStatus enum: ^(compliant|warning|non-compliant|sanctioned)$ (sc-rew-fiscal-status-enum)",
				"regulatoryFramework enum: ^(bacen|coaf|sefaz|ofac|fatf)$ (sc-rew-fiscal-framework-enum)",
				"regulatoryDocRef.sourceContext deve ser 'fce' (sc-rew-fiscal-source-binding)",
			]
			rationale: "Fiscal status é input regulatório — não tensionável (CLAUDE.md constraint inviolável). 'sanctioned' implica decisão automática 'ineligible' (enforced via policy rule). regulatoryFramework explícito permite multi-jurisdiction sem misturar. errorClassEliminated: 'type safety falsa em discriminated union (fiscal variant)'."
		},
		{
			code:        "vo-risk-score"
			name:        "Risk Score"
			description: "Output principal de RiskEvaluation. value bounded por scale semantics. calibrationProfile torna comparação cross-model auditável — mesma scale ≠ mesma semântica sem calibration match. computedFromModelVersion binds score ao modelo gerador (inv-rew-model-version-binding)."
			fields: [
				{kind: "primitive", name: "scale", type: "string", description: "^(probability|normalized|custom)$"},
				{kind: "primitive", name: "value", type: "decimal", description: "Range determinado por scale (sc-rew-score-scale-range)"},
				{kind: "primitive", name: "calibrationProfile", type: "string", description: "Identifier de calibração: ^(default-v[0-9]+|construction-v[0-9]+|high-risk-adjusted-v[0-9]+|custom-[a-z0-9-]+)$"},
				{kind: "primitive", name: "computedFromModelVersion", type: "string", description: "Reference ao RiskModel.version que produziu este score"},
				{kind: "primitive", name: "computedAt", type: "datetime"},
				{kind: "value-object-ref", name: "scaleMetadata", valueObjectRef: "vo-scale-metadata", description: "Metadata de scale custom — PRESENTE APENAS quando scale=='custom' (sc-rew-score-custom-coherence)"},
			]
			constraints: [
				"scale enum: ^(probability|normalized|custom)$ (sc-rew-score-scale-enum)",
				"scale=='probability' → value ∈ [0,1] (sc-rew-score-probability-range)",
				"scale=='normalized' → value ∈ [0,100] (sc-rew-score-normalized-range)",
				"scale=='custom' → scaleMetadata presente; value ∈ [scaleMetadata.min, scaleMetadata.max] (sc-rew-score-custom-range)",
				"calibrationProfile regex (sc-rew-calibration-profile-format)",
				"Comparabilidade: scores comparáveis SOMENTE quando scale==scale && calibrationProfile==calibrationProfile (sc-rew-score-comparison-rule — runner Phase 1+)",
			]
			rationale: "Range depende da semântica, não do tipo (founder Phase 3 insight). calibrationProfile resolve buraco residual: mesma escala ≠ mesma semântica. Dois modelos podem usar scale='probability' com calibrações diferentes — comparação cross-model exige calibrationProfile match explícito. errorClassEliminated: 'score comparation ilusória cross-model'."
		},
		{
			code:        "vo-scale-metadata"
			name:        "Scale Metadata (custom scale bounds)"
			description: "Metadata de escala custom para RiskScore quando scale=='custom'. Define bounds [min, max] + opcional unit semantic. PRESENTE APENAS quando scale=='custom'; ABSENT para probability/normalized (bounds são implicit)."
			fields: [
				{kind: "primitive", name: "min", type: "decimal", description: "Lower bound da escala custom (inclusivo)"},
				{kind: "primitive", name: "max", type: "decimal", description: "Upper bound da escala custom (inclusivo)"},
				{kind: "primitive", name: "unit", type: "string", description: "Optional semantic unit: e.g., 'percent', 'basis-points', 'tier'; vazio quando dimensionless"},
			]
			constraints: [
				"min < max (sc-rew-scale-metadata-bounds-ordering)",
				"Coerência cross-VO: vo-risk-score.scaleMetadata presente ⟺ vo-risk-score.scale=='custom' (sc-rew-score-custom-coherence)",
			]
			rationale: "Anti-mistura semântica: vo-version-stamp era reuso errado (governança ≠ semântica de escala). VO dedicada torna scaleMetadata semanticamente claro: 'bounds + unit de uma escala custom'. Identidade própria + invariants próprios + evolução independente. errorClassEliminated: 'scaleMetadata semanticamente opaco'."
		},
		{
			code:        "vo-confidence-interval"
			name:        "Confidence Interval"
			description: "Quantifica incerteza epistemológica do RiskScore. Layer Epistemic per glossary Phase 2 — separa força epistêmica de decisão categórica (Eligibility). uncertaintyDrivers torna confidence EXPLICÁVEL (não número opaco)."
			fields: [
				{kind: "primitive", name: "lowerBound", type: "decimal"},
				{kind: "primitive", name: "upperBound", type: "decimal"},
				{kind: "primitive", name: "confidenceLevel", type: "decimal", description: "Range (0,1) — e.g., 0.95 para CI 95%"},
				{kind: "value-object-ref", name: "coverage", valueObjectRef: "vo-coverage-stats"},
				{kind: "primitive", name: "methodology", type: "string", description: "^(bayesian|heuristic|conservative)$"},
				{kind: "primitive", name: "uncertaintyDrivers", type: "string", description: "Comma-separated list de driverCode (vo-uncertainty-driver.driverCode); ordered ascending; cardinality ≥1 quando coverage<1.0"},
				{kind: "primitive", name: "computedAt", type: "datetime"},
			]
			constraints: [
				"lowerBound ≤ upperBound (sc-rew-ci-bounds-ordering)",
				"confidenceLevel range: 0 < value < 1 (sc-rew-ci-level-range; e.g., 0.90, 0.95, 0.99)",
				"methodology enum: ^(bayesian|heuristic|conservative)$ (sc-rew-ci-methodology-enum)",
				"uncertaintyDrivers cardinality: empty quando coverage.weightedRatio==1.0; ≥1 quando <1.0 (sc-rew-ci-drivers-coverage-coherence)",
				"uncertaintyDrivers elementos: cada elemento ∈ vo-uncertainty-driver.driverCode enum (sc-rew-ci-drivers-element-validation)",
				"uncertaintyDrivers uniqueness: nenhum driverCode duplicado (sc-rew-ci-drivers-uniqueness)",
			]
			rationale: "Confidence sem explicação = número opaco (founder Phase 3 insight). uncertaintyDrivers força declarar QUE causou a incerteza — torna review humano possível. Coherence rule (drivers ≥1 quando coverage<1) impede confidence baixa sem driver declarado. uncertaintyDrivers como string comma-separated é workaround estrutural (#ValueObject não suporta list cardinality em field). errorClassEliminated: 'confidence sem explicação (número opaco)'."
		},
		{
			code:        "vo-coverage-stats"
			name:        "Coverage Statistics"
			description: "Métrica de cobertura de signals upstream — quanto da informação esperada foi observada. weightedRatio reflete importância (signal de fraude > signal de geo) per glossary Phase 2 hardening: 'cobertura não é quantidade — é relevância'. missingSignals enumera lacunas (operacional)."
			fields: [
				{kind: "primitive", name: "weightedRatio", type: "decimal", description: "Range [0,1] — Σ(weight_i × presence_i) / Σ(weight_i); calculado RUNTIME"},
				{kind: "primitive", name: "missingSignals", type: "string", description: "Comma-separated signalIds esperados mas ausentes (ordered ascending) — operacional, não semântico"},
				{kind: "primitive", name: "totalExpected", type: "integer"},
				{kind: "primitive", name: "totalObserved", type: "integer"},
			]
			constraints: [
				"weightedRatio range: 0 ≤ value ≤ 1 (sc-rew-coverage-ratio-range)",
				"totalObserved ≤ totalExpected (sc-rew-coverage-counts-coherence)",
				"weightedRatio == 1.0 implica missingSignals empty (sc-rew-coverage-empty-coherence)",
				"Coverage WEIGHTING correctness é BEHAVIORAL — runtime computa weightedRatio; CUE valida shape e range (não fórmula)",
			]
			rationale: "Coverage weighted (não simples ratio) é hardening Phase 2. Schema-time enforce shape + range; structural-check enforce coherence; runtime enforce weighting formula correctness. missingSignals string-encoded por ser OPERACIONAL (não semântico — founder Phase 3 ratified). errorClassEliminated: 'coverage como ratio simples (ignora relevância)'."
		},
		{
			code:        "vo-uncertainty-driver"
			name:        "Uncertainty Driver Code (TYPE catalog entry)"
			description: "Type definition de um driver de incerteza atribuível a uma ConfidenceInterval. Catalog enum versionado. Used as TYPE em vo-confidence-interval.uncertaintyDrivers (storage como comma-separated string; structural-check parse + valida cada elemento contra driverCode enum)."
			fields: [
				{kind: "primitive", name: "driverCode", type: "string", description: "Enum: ^(missing_payment_history|low_signal_diversity|stale_kyc|high_anomaly_count|insufficient_history|model_uncertainty|policy_ambiguity|sparse_peer_data|adversarial_signal_suspicion)$"},
				{kind: "primitive", name: "category", type: "string", description: "^(data|model|policy|adversarial)$ — taxonomia para review filtering"},
			]
			constraints: [
				"driverCode enum (sc-rew-uncertainty-driver-enum)",
				"category enum: ^(data|model|policy|adversarial)$ (sc-rew-uncertainty-driver-category-enum)",
				"Adição de novo driverCode requer version stamp em vo-confidence-interval consumers (sc-rew-uncertainty-driver-versioning)",
			]
			rationale: "Driver enum codificado força declarar QUE causou incerteza (review acionável). category permite agrupamento. Adversário Econômico sh-06 (Phase 1 cross-cutting) tem driver dedicado (adversarial_signal_suspicion) — REW reconhece estruturalmente que adversário pressiona o sistema epistemologicamente. Storage limitation: schema #ValueObject.fields não suporta list cardinality — VO existe como TYPE catalog (governance/enum/evolução), não como instance storage. errorClassEliminated: 'incerteza não-acionável em review'."
		},
		{
			code:        "vo-eligibility-decision"
			name:        "Eligibility Decision"
			description: "Output categórico de RiskEvaluation — decision em domínio CONTEXTUAL (não absoluta) per glossary Phase 2. constraints articulam conditional approval; blockingReasons enumeram causas de denial — ambos auditáveis. basedOnScore + basedOnPolicyVersion preservam binding ao raciocínio."
			fields: [
				{kind: "primitive", name: "decision", type: "string", description: "^(eligible|conditionally_eligible|ineligible)$"},
				{kind: "primitive", name: "constraints", type: "string", description: "Comma-separated list de reasonCode (vo-decision-reason.reasonCode) onde severity ∈ {soft, hard}; presente quando decision=='conditionally_eligible'"},
				{kind: "primitive", name: "blockingReasons", type: "string", description: "Comma-separated list de reasonCode (vo-decision-reason.reasonCode) onde severity=='blocking'; presente quando decision=='ineligible'"},
				{kind: "value-object-ref", name: "basedOnScore", valueObjectRef: "vo-risk-score"},
				{kind: "primitive", name: "basedOnPolicyVersion", type: "string"},
				{kind: "primitive", name: "evaluatedAt", type: "datetime"},
			]
			constraints: [
				"decision enum: ^(eligible|conditionally_eligible|ineligible)$ (sc-rew-eligibility-decision-enum)",
				"decision=='conditionally_eligible' → constraints non-empty (sc-rew-eligibility-constraints-coherence)",
				"decision=='ineligible' → blockingReasons non-empty (sc-rew-eligibility-blocking-coherence)",
				"decision=='eligible' → constraints empty AND blockingReasons empty (sc-rew-eligibility-clean-coherence)",
				"constraints elementos: cada ∈ vo-decision-reason.reasonCode WHERE severity ∈ {soft,hard} (sc-rew-eligibility-constraints-element-validation)",
				"blockingReasons elementos: cada ∈ vo-decision-reason.reasonCode WHERE severity=='blocking' (sc-rew-eligibility-blocking-element-validation)",
				"Uniqueness em ambos (sc-rew-eligibility-reasons-uniqueness)",
			]
			rationale: "Glossary Phase 2: 'Eligibility Decision é categórica; Confidence Interval é força epistemológica — duas dimensões SEPARADAS'. Decision puro (sem score embedded) preserva separação. constraints/blockingReasons como comma-separated strings — workaround VO explosion guardrail. errorClassEliminated: 'decisão sem estrutura de razão (não auditável)'."
		},
		{
			code:        "vo-decision-reason"
			name:        "Decision Reason Code (TYPE catalog entry)"
			description: "Type definition de um reason code de EligibilityDecision — usado em constraints (quando conditionally_eligible) E em blockingReasons (quando ineligible) E em supersedeReason E em deprecationReason E em resolutionReason. Mesmo VO type para todos os contextos: razão é razão; consumer difere por field. Storage como comma-separated string (schema limitation); structural-check valida elementos."
			fields: [
				{kind: "primitive", name: "reasonCode", type: "string", description: "Enum: ^(reduced-limit|short-term|collateral-required|enhanced-monitoring|fiscal-non-compliant|asset-visibility-gap|score-below-threshold|kyc-pending|kyc-rejected|sanctioned|stale-evidence|adversarial-pattern-detected|policy-not-applicable|insufficient-confidence|policy-version-changed|model-version-changed|manual-override|false-positive|escalated|supersession-by-newer-evaluation|model-deprecated|policy-deprecated|model-recalibration|policy-update-required)$"},
				{kind: "primitive", name: "severity", type: "string", description: "^(soft|hard|blocking)$ — soft=advisory, hard=requires action, blocking=denial cause"},
				{kind: "primitive", name: "category", type: "string", description: "^(risk|compliance|operational|epistemic|lifecycle)$"},
			]
			constraints: [
				"reasonCode enum (sc-rew-decision-reason-enum)",
				"severity enum (sc-rew-decision-severity-enum)",
				"category enum (sc-rew-decision-category-enum)",
				"Coerência: severity=='blocking' implica reasonCode permitido SOMENTE em blockingReasons (não em constraints) — sc-rew-decision-severity-coherence",
				"Coerência: severity ∈ {'soft', 'hard'} permitido em constraints OR em supersedeReason/resolutionReason (não em blockingReasons)",
			]
			rationale: "Decisão sem estrutura de razão = decisão não auditável (founder Phase 3 insight). Mesmo VO type para múltiplos consumers preserva uniformidade semântica — razão é razão; o que difere é severity (qual field consumer legítimo aceita). Cross-BC reusable. adversarial-pattern-detected como reason explícito materializa sh-06. errorClassEliminated: 'reason ad-hoc cross-BC (incoerente)'."
		},
		{
			code:        "vo-applicable-context"
			name:        "Applicable Context (decision context)"
			description: "Contexto obrigatório de toda RiskEvaluation per inv-rew-contextual-completeness. assetVisibility + evaluationScope reconhecem ignorância sistêmica formalmente (Layer Epistemic). assetRef via vo-external-ref preserva sourceContext (anti-coupling-invisivel). entityRef.sourceContext primary source é canvas (não hardcode em policy)."
			fields: [
				{kind: "value-object-ref", name: "entityRef", valueObjectRef: "vo-external-ref", description: "Subject of evaluation — sourceContext ∈ canvas inbound contextDependencies (canonical primary)"},
				{kind: "primitive", name: "productCode", type: "string", description: "Product identifier — e.g., 'credit-line-construction', 'invoice-discount-30d'"},
				{kind: "primitive", name: "policyVersion", type: "string", description: "RiskPolicy.version aplicável a esta decisão"},
				{kind: "primitive", name: "decisionContextTime", type: "datetime", description: "Tempo do contexto da decisão — temporal anchor"},
				{kind: "value-object-ref", name: "assetRef", valueObjectRef: "vo-external-ref", description: "Asset evaluated (opcional — só presente quando evaluationScope=='asset_level')"},
				{kind: "primitive", name: "assetVisibility", type: "string", description: "^(visible|indirect|gap)$ — ignorância sistêmica explícita"},
				{kind: "primitive", name: "evaluationScope", type: "string", description: "^(entity_level|asset_level)$"},
				{kind: "value-object-ref", name: "versionStamp", valueObjectRef: "vo-version-stamp"},
			]
			constraints: [
				"entityRef.sourceContext ∈ canvas.contextDependencies.inbound.[].sourceBC (canonical primary; sc-rew-context-entity-source-canvas-binding) — runner cross-file lê canvas REW Phase 1",
				"RiskPolicy MAY adicionar entitySourceRestriction como constraint adicional (refinement, não definição); sc-rew-policy-entity-restriction-narrowing valida que policy.entitySourceRestriction ⊆ canvas-declared set",
				"evaluationScope=='asset_level' → assetRef presente (sc-rew-context-asset-scope-coherence)",
				"evaluationScope=='entity_level' → assetRef ausente (sc-rew-context-entity-scope-coherence)",
				"assetVisibility enum: ^(visible|indirect|gap)$ (sc-rew-context-visibility-enum)",
				"evaluationScope enum: ^(entity_level|asset_level)$ (sc-rew-context-scope-enum)",
				"Cross-VO INV-REW-08: assetVisibility=='gap' → consumer EligibilityDecision.decision != 'eligible' (sc-rew-asset-aware-discipline — REGRA CRÍTICA)",
			]
			rationale: "Hardcode de origem = bloqueio de evolução (founder Phase 3 insight). entityRef.sourceContext primary source é canvas — policy decide risco, não decide ontologia do mundo. assetVisibility=='gap' reconhece formalmente que sistema NÃO TEM signal sobre o asset — bloqueia eligible decision por construção. errorClassEliminated: 'decisão fora-de-contexto' + 'ontology drift via policy hardcoding'."
		},
	]

	// =========================================================
	// AGGREGATES (1 skeleton — agg-risk-evaluation)
	// =========================================================
	// Part 1: 1 aggregate skeleton com handlesCommands/emitsEvents/
	//   protectsInvariants/entities/usesValueObjects/lifecycle.
	// Part 2 deferred: agg-risk-alert + agg-risk-model + agg-risk-policy
	//   + module decomposition completa.

	aggregates: [{
		code:        "agg-risk-evaluation"
		// adr-151 Forma A (onda rew, passo vi)
		firstClass:       true
		firstClassReason: "risk"
		coreNoun:         "Risk Evaluation"
		name:        "Risk Evaluation Aggregate"
		description: "Aggregate central de REW — owns evaluation lifecycle (compute → emit → stale | superseded), signal snapshot, reasoning trace. Consistency boundary: evaluation lifecycle + snapshot integrity + reasoning trace ownership. Identity por evaluationId surrogate (não tupla composta — 'identidade ≠ determinismo' founder Phase 3 directive)."

		rootIdentity: {
			field: "evaluationId"
			type: {
				kind: "primitive"
				type: "string"
			}
		}

		fields: [
			{kind: "primitive", name: "evaluationId", type:           "string", description: "Surrogate identity — ULID/UUID; NÃO derivada de inputs (determinismo é replayHash, não identity)"},
			{kind: "primitive", name: "status", type:                 "string", description: "Enum: ^(emitted|stale|superseded)$ — lifecycle state"},
			{kind: "primitive", name: "parentEvaluationId", type:     "string", description: "Optional reference para evaluation predecessora (lineage)"},
			{kind: "value-object-ref", name: "context", valueObjectRef:  "vo-applicable-context"},
			{kind: "value-object-ref", name: "score", valueObjectRef:    "vo-risk-score"},
			{kind: "value-object-ref", name: "eligibility", valueObjectRef: "vo-eligibility-decision"},
			{kind: "value-object-ref", name: "confidence", valueObjectRef:  "vo-confidence-interval"},
			{kind: "primitive", name: "signalSnapshotIds", type:      "string", description: "Comma-separated signalIds (snapshot membership)"},
			{kind: "primitive", name: "modelVersion", type:           "string"},
			{kind: "primitive", name: "policyVersion", type:          "string"},
			{kind: "primitive", name: "replayHash", type:             "string"},
			{kind: "primitive", name: "computedAt", type:             "datetime"},
			{kind: "primitive", name: "emittedAt", type:              "datetime"},
			{kind: "primitive", name: "supersededBy", type:           "string", description: "Optional newEvaluationId quando status=='superseded'"},
			{kind: "primitive", name: "markedStaleAt", type:          "datetime", description: "Optional timestamp quando status transicionou para stale"},
			{kind: "primitive", name: "validUntilTimestamp", type:    "datetime", description: "Computed at emit time = emittedAt + RiskPolicy.evaluationValidityWindowSeconds; consumer reading com now() > validUntilTimestamp = expired (inv-rew-evaluation-temporal-validity)"},
		]

		handlesCommands: [
			"cmd-request-risk-evaluation",
			"cmd-supersede-risk-evaluation",
			"cmd-mark-evaluation-stale",
		]

		emitsEvents: [
			"evt-signal-received",
			"evt-signal-rejected",
			"evt-signal-corruption-detected",
			"evt-risk-evaluation-computed",
			"evt-risk-evaluation-emitted",
			"evt-risk-evaluation-emit-failed",
			"evt-risk-evaluation-emit-superseded-by-newer",
			"evt-risk-evaluation-superseded",
			"evt-risk-evaluation-marked-stale",
		]

		protectsInvariants: [
			"inv-rew-signal-traceability",
			"inv-rew-contextual-completeness",
			"inv-rew-bounded-score",
			"inv-rew-deterministic-replay",
			"inv-rew-model-policy-separation",
			"inv-rew-model-version-binding",
			"inv-rew-asset-aware-discipline",
			"inv-rew-reasoning-completeness",
			"inv-rew-temporal-consistency",
			"inv-rew-payload-opacity",
			"inv-rew-explicit-supersede-only",
			"inv-rew-active-evaluation-rule",
			"inv-rew-compute-emit-ordering",
			"inv-rew-snapshot-temporal-consistency",
			"inv-rew-evaluation-completeness",
			"inv-rew-staleness-tracking",
			"inv-rew-no-staleness-feedback-loop",
			"inv-rew-event-emission-boundedness",
			"inv-rew-command-idempotency",
			"inv-rew-signal-corruption-handling",
			"inv-rew-version-frozen-at-request",
			"inv-rew-policy-version-immutability-per-evaluation",
			"inv-rew-evaluation-lineage-acyclic",
			"inv-rew-supersede-after-emit-only",
			"inv-rew-compute-implies-emit",
			"inv-rew-computed-idempotent-retry",
			"inv-rew-single-successor-per-evaluation",
			"inv-rew-computed-must-eventually-emit-or-fail",
			"inv-rew-supersede-requires-current-active",
			"inv-rew-signal-validation-before-ingestion",
			"inv-rew-supersede-emit-failed-precedence",
			"inv-rew-evaluation-temporal-validity",
			"inv-rew-replay-scope-completeness",
			"inv-rew-acl-validation-cost-bounded",
			"inv-rew-obsolete-evaluation-must-link-successor",
			"inv-rew-successor-chain-bounded",
			"inv-rew-replay-confidence-propagation",
			"inv-rew-decision-binding-to-evaluation-version",
			"inv-rew-undetectable-pattern-risk-declared",
		]

		entities: [{
			code:        "ent-reasoning-trace"
			name:        "Reasoning Trace (auditable evidence)"
			description: "Entity owned por agg-risk-evaluation — captura raciocínio que produziu uma evaluation. Trace é EVIDÊNCIA AUDITÁVEL, não atributo opcional (founder Phase 3 correction: trace é Entity, não VO). Identity própria (traceId) porque trace tem lifecycle independente de evaluation post-compute (e.g., trace pode ser annotated por reviewer)."

			identity: {
				field: "traceId"
				type: {
					kind: "primitive"
					type: "string"
				}
			}

			fields: [
				{kind: "primitive", name: "traceId", type:                 "string"},
				{kind: "primitive", name: "evaluationId", type:            "string", description: "Reference back para parent evaluation"},
				{kind: "primitive", name: "inputSignalSnapshotIds", type:  "string", description: "Comma-separated signalIds usados como input"},
				{kind: "primitive", name: "inputModelVersion", type:       "string"},
				{kind: "primitive", name: "inputPolicyVersion", type:      "string"},
				{kind: "primitive", name: "intermediateSteps", type:       "string", description: "JSON-encoded list of {stepId, stepType, inputRefs[], outputRefs[], rationale} — cardinality ≥2 enforced sc-rew-trace-steps-cardinality"},
				{kind: "value-object-ref", name: "outputScore", valueObjectRef:        "vo-risk-score"},
				{kind: "value-object-ref", name: "outputEligibility", valueObjectRef:  "vo-eligibility-decision"},
				{kind: "value-object-ref", name: "outputConfidence", valueObjectRef:   "vo-confidence-interval"},
				{kind: "primitive", name: "createdAt", type:               "datetime"},
			]

			usesValueObjects: [
				"vo-risk-score",
				"vo-eligibility-decision",
				"vo-confidence-interval",
			]

			rationale: "Trace tem identity própria porque é evidência (reviewer pode anotar; auditor pode referenciar). NÃO é VO (que é imutável valor sem identity). intermediateSteps como JSON-encoded string é workaround estrutural (#Entity.fields tem mesma restrição que #ValueObject.fields — list cardinality não expressável em primitive types). errorClassEliminated: 'trace as opaque attribute losing audit evidence + 1-step pseudo-explanation'."
		}]

		usesValueObjects: [
			"vo-applicable-context",
			"vo-risk-score",
			"vo-confidence-interval",
			"vo-eligibility-decision",
			"vo-signal",
			"vo-signal-ref",
			"vo-version-stamp",
			"vo-external-ref",
			"vo-decision-reason",
			"vo-uncertainty-driver",
			"vo-coverage-stats",
			"vo-scale-metadata",
			"vo-integrity-proof",
			"vo-signal-payload-kyc",
			"vo-signal-payload-device",
			"vo-signal-payload-behavioral",
			"vo-signal-payload-fiscal",
		]

		lifecycle: {
			initialState: "emitted"
			states: ["emitted", "stale", "superseded"]
			transitions: [
				{
					from:               "emitted"
					to:                 "stale"
					triggeredByCommand: "cmd-mark-evaluation-stale"
					emitsEvents: ["evt-risk-evaluation-marked-stale"]
					guards: ["inv-rew-staleness-tracking", "inv-rew-active-evaluation-rule", "inv-rew-event-emission-boundedness"]
					description: "Evaluation marcada stale por sinal relevante (automático via pol-mark-stale)"
				},
				{
					from:               "emitted"
					to:                 "superseded"
					triggeredByCommand: "cmd-supersede-risk-evaluation"
					emitsEvents: ["evt-risk-evaluation-superseded"]
					guards: ["inv-rew-explicit-supersede-only"]
					description: "Substituição explícita via command"
				},
				{
					from:               "stale"
					to:                 "superseded"
					triggeredByCommand: "cmd-supersede-risk-evaluation"
					emitsEvents: ["evt-risk-evaluation-superseded"]
					guards: ["inv-rew-explicit-supersede-only"]
					description: "Substituição explícita de evaluation stale"
				},
			]
		}

		consistencyBoundary: {
			guarantees: [
				"evaluation lifecycle state transitions atomic dentro do aggregate",
				"signal snapshot integrity (signalSnapshotIds immutable post-creation)",
				"lineage integrity TREE (parentEvaluationId acyclic + temporal-ordered + single-successor enforced via CAS)",
				"model+policy version frozen at cmd-request (immutable across compute→emit→supersede)",
				"replay determinism (replayHash reproducible from canonical serialization)",
				"active evaluation uniqueness per (entity, product, scope) tuple",
				"supersede atomic (CAS on supersededBy field — concurrent supersedes resolved deterministically)",
				"compute→emit OR compute→fail (no orphan computed via timeout enforcement)",
				"validUntilTimestamp computed at emit (temporal validity boundary explícito)",
			]
			explicitlyDoesNotGuarantee: [
				"alert emission post evaluation (downstream eventual via agg-risk-alert)",
				"policy/model side-effect propagation cross-aggregate",
				"cross-evaluation consistency",
				"consumer immediate visibility (eventual via prj-active-risk-evaluations)",
				"cross-entity replay correlation (limitation declared; replayConfidence enum signals partial)",
			]
			failureModes: [
				"compute success + emit failure: evaluationId persisted as FACT historical; emit-failed event documents abort; NÃO entra em active rule",
				"supersede pre-emit: rejected by inv-rew-supersede-after-emit-only + inv-rew-supersede-emit-failed-precedence (semantic precedence)",
				"concurrent supersede mesma evaluation: CAS resolves first-wins; second cmd recebe explicit error 'already-superseded'",
				"snapshot signal hash mismatch: incoming discarded; original preserved; corruption-detected emitted",
				"replay drift detected (runtime hash recompute mismatch): replayConfidence='degraded'; flagged for review",
				"ACL validation failure: evt-signal-rejected emitted; signal NÃO entra no domínio",
				"lineage cycle attempted: detected by sc-rew-lineage-acyclic; supersede rejected",
				"emit-failed + concurrent supersede: precedence resolution per inv-rew-supersede-emit-failed-precedence",
				"evaluation expired (now() > validUntilTimestamp): consumer responsibility — request fresh OR ADR override",
			]
			rationale: "Aggregate central. Boundary preserva append-only fact log + replay determinism + lineage tree + version freeze + temporal validity. Cross-aggregate side-effects são event-driven eventual."
		}

		rationale: """
			agg-risk-evaluation é consistency boundary central de REW.
			Identity por evaluationId surrogate (não tupla composta) per
			founder Phase 3 directive: 'identidade ≠ determinismo' —
			determinismo é replayHash (input-derived), identity é
			surrogate (lifecycle anchor).

			Lifecycle 3 estados (emitted, stale, superseded) cobre
			operational lifetime da evaluation. Initial state 'emitted'
			(compute é internal transient pre-lifecycle; emit-failed é
			ABORT pre-lifecycle — não entra como state). Stale NÃO é
			estado terminal — pode transitar para superseded via
			cmd-supersede explícito. Superseded É estado terminal
			(append-only fact log; reabertura proibida).

			Lineage via parentEvaluationId TREE (não DAG — single-
			successor enforced; acyclic; temporal-ordered). Cada
			evaluation é fato imutável com referência opcional ao
			predecessor.

			Part 2 production-safety hardening (founder pressure final):
			- validUntilTimestamp field (inv-rew-evaluation-temporal-
			  validity) — boundary explícito entre 'evaluation existe'
			  e 'decisão pode ser tomada'
			- emit-failed = ABORT (não state) — evaluation NÃO entra em
			  lifecycle se compute→emit falha
			- CAS atomic supersede (inv-rew-supersede-requires-current-
			  active) — race conditions resolvidas deterministicamente
			- precedência semântica supersede vs emit-failed (inv-rew-
			  supersede-emit-failed-precedence) — supersede só opera em
			  evaluation ∈ lifecycle
			- replay confidence enum (inv-rew-replay-scope-completeness)
			  — replay output declara completude

			33 invariants protected (foi 20 em Part 1; +13 production-
			safety em Part 2). 8 events emitted (foi 5; +signal-rejected
			+emit-failed; +signal-received do ACL boundary).
			"""
	}, {
		code:        "agg-risk-alert"
		name:        "Risk Alert Aggregate"
		description: "Aggregate de alert lifecycle — DOWNSTREAM de agg-risk-evaluation. Reage a evaluation events; NUNCA muta evaluation state (inv-rew-alert-no-feedback-to-evaluation). Identity por alertId; binding ao evaluationId é IMUTÁVEL post-raise."

		rootIdentity: {
			field: "alertId"
			type: {
				kind: "primitive"
				type: "string"
			}
		}

		fields: [
			{kind: "primitive", name: "alertId", type:                    "string"},
			{kind: "primitive", name: "evaluationId", type:               "string", description: "IMUTÁVEL post-raise (inv-rew-alert-evaluation-binding-immutability)"},
			{kind: "primitive", name: "alertCategory", type:              "string"},
			{kind: "primitive", name: "severity", type:                   "string"},
			{kind: "primitive", name: "status", type:                     "string", description: "Enum: open|acknowledged|resolved"},
			{kind: "value-object-ref", name: "triggeringContext", valueObjectRef: "vo-applicable-context"},
			{kind: "primitive", name: "raisedAt", type:                   "datetime"},
			{kind: "primitive", name: "acknowledgedAt", type:             "datetime"},
			{kind: "primitive", name: "resolvedAt", type:                 "datetime"},
			{kind: "value-object-ref", name: "performedBy", valueObjectRef: "vo-external-ref"},
			{kind: "primitive", name: "actorAuthority", type:             "string"},
			{kind: "value-object-ref", name: "resolutionReason", valueObjectRef: "vo-decision-reason"},
		]

		handlesCommands: [
			"cmd-raise-risk-alert",
			"cmd-acknowledge-risk-alert",
			"cmd-resolve-risk-alert",
		]

		emitsEvents: [
			"evt-risk-alert-raised",
			"evt-risk-alert-acknowledged",
			"evt-risk-alert-resolved",
		]

		protectsInvariants: [
			"inv-rew-alert-lifecycle",
			"inv-rew-alert-dedupe",
			"inv-rew-alert-evaluation-binding-immutability",
			"inv-rew-alert-no-feedback-to-evaluation",
			"inv-rew-alert-command-idempotency",
		]

		usesValueObjects: [
			"vo-external-ref",
			"vo-applicable-context",
			"vo-decision-reason",
		]

		lifecycle: {
			initialState: "open"
			states: ["open", "acknowledged", "resolved"]
			transitions: [
				{
					from:               "open"
					to:                 "acknowledged"
					triggeredByCommand: "cmd-acknowledge-risk-alert"
					emitsEvents: ["evt-risk-alert-acknowledged"]
					guards: ["inv-rew-alert-lifecycle"]
					description: "Authorized actor reconhece alert"
				},
				{
					from:               "acknowledged"
					to:                 "resolved"
					triggeredByCommand: "cmd-resolve-risk-alert"
					emitsEvents: ["evt-risk-alert-resolved"]
					guards: ["inv-rew-alert-lifecycle"]
					description: "Authorized actor resolve alert com reason"
				},
			]
		}

		consistencyBoundary: {
			guarantees: [
				"alert lifecycle state transitions atomic (open→acknowledged→resolved monotonic)",
				"alert dedupe per (evaluationId, alertCategory) at COMMAND level (idempotent raise)",
				"alert.evaluationId IMUTÁVEL post-raise",
				"actorAuthority enforced per severity (sc-rew-alert-ack-authority-binding)",
				"alert NUNCA emite cmd targeting evaluation aggregate (anti-feedback enforced)",
			]
			explicitlyDoesNotGuarantee: [
				"evaluation state mutation (PROIBIDO por inv-rew-alert-no-feedback-to-evaluation)",
				"cross-alert consistency",
				"alert delivery to downstream consumers (eventual via event log)",
				"alert raising synchronous com evaluation emission (eventual via pol-emit-risk-alert)",
			]
			failureModes: [
				"alert raise para evaluationId inexistente: rejected (binding requires existing evaluation)",
				"duplicate raise mesma (evaluationId, alertCategory): silently deduped at COMMAND level",
				"ack/resolve por unauthorized actor: rejected",
				"resolve sem resolutionReason: rejected",
				"alert para evaluation que veio a ser superseded: alert continua valid (binding immutable; fact histórico)",
				"alert raise concurrent de múltiplos policy nodes: CAS at command index resolves first-wins",
			]
			rationale: "Alert é OBSERVABILITY artifact downstream. Reage a evaluation; NUNCA muta evaluation. Append-only lifecycle (resolved é terminal — reabertura = novo alert)."
		}

		rationale: "Aggregate downstream agg-risk-evaluation. Anti-feedback rule fundamental: alert é reação, não causa."
	}, {
		code:        "agg-risk-model"
		name:        "Risk Model Aggregate"
		description: "Aggregate de model versioning. Independente de RiskPolicy (inv-rew-model-policy-independence)."

		rootIdentity: {
			field: "modelVersion"
			type: {
				kind: "primitive"
				type: "string"
			}
		}

		fields: [
			{kind: "primitive", name: "modelVersion", type:               "string"},
			{kind: "primitive", name: "status", type:                     "string", description: "Enum: draft|active|deprecated"},
			{kind: "primitive", name: "calibrationProfile", type:         "string"},
			{kind: "primitive", name: "activatedAt", type:                "datetime"},
			{kind: "primitive", name: "deprecatedAt", type:               "datetime"},
			{kind: "value-object-ref", name: "activatedBy", valueObjectRef:    "vo-external-ref"},
			{kind: "value-object-ref", name: "deprecatedBy", valueObjectRef:   "vo-external-ref"},
			{kind: "value-object-ref", name: "deprecationReason", valueObjectRef: "vo-decision-reason"},
		]

		handlesCommands: [
			"cmd-activate-risk-model",
			"cmd-deprecate-risk-model",
		]

		emitsEvents: [
			"evt-risk-model-activated",
			"evt-risk-model-deprecated",
		]

		protectsInvariants: [
			"inv-rew-model-policy-independence",
			"inv-rew-model-policy-separation",
		]

		usesValueObjects: [
			"vo-external-ref",
			"vo-decision-reason",
		]

		lifecycle: {
			initialState: "draft"
			states: ["draft", "active", "deprecated"]
			transitions: [
				{
					from:               "draft"
					to:                 "active"
					triggeredByCommand: "cmd-activate-risk-model"
					emitsEvents: ["evt-risk-model-activated"]
					guards: ["inv-rew-model-policy-independence"]
					description: "Model promovida a active (authority supervisor+)"
				},
				{
					from:               "active"
					to:                 "deprecated"
					triggeredByCommand: "cmd-deprecate-risk-model"
					emitsEvents: ["evt-risk-model-deprecated"]
					guards: []
					description: "Model marcada deprecated com reason"
				},
			]
		}

		consistencyBoundary: {
			guarantees: [
				"model version lifecycle transitions atomic (draft→active→deprecated monotonic)",
				"model independence from policy (RiskModel NÃO referencia RiskPolicy)",
				"deprecated models PRESERVED em event log (evaluations using deprecated model continuam valid via snapshot)",
			]
			explicitlyDoesNotGuarantee: [
				"evaluations using this model are unaffected by model state change (snapshot frozen at cmd-request per inv-rew-version-frozen-at-request)",
				"policy compatibility validation (separate concern in agg-risk-policy)",
				"consumer immediate visibility of model state changes",
			]
			failureModes: [
				"activate model already active: rejected (transition not in lifecycle)",
				"deprecate non-active model: rejected (draft→deprecated não permitida)",
				"model activation while evaluation in-flight: NÃO afeta evaluation (frozen)",
				"concurrent activate de mesmo modelVersion: CAS resolves first-wins",
			]
			rationale: "Model versioning. Lifecycle monotonic; deprecation NÃO invalida history (snapshot)."
		}

		rationale: "Aggregate de governance de model versions. Independência arquitetural de policy."
	}, {
		code:        "agg-risk-policy"
		name:        "Risk Policy Aggregate"
		description: "Aggregate de policy versioning. Pode referenciar RiskModel (sentido permitido); inverse proibido. 4 windows separadas (anti-acoplamento)."

		rootIdentity: {
			field: "policyVersion"
			type: {
				kind: "primitive"
				type: "string"
			}
		}

		fields: [
			{kind: "primitive", name: "policyVersion", type:                  "string"},
			{kind: "primitive", name: "status", type:                         "string"},
			{kind: "primitive", name: "modelVersionRef", type:                "string", description: "Reference ao RiskModel.modelVersion (sentido permitido)"},
			{kind: "primitive", name: "stalenessTriggerCriteria", type:       "string", description: "JSON-encoded match criteria for staleness automation"},
			{kind: "primitive", name: "stalenessWindowSeconds", type:         "integer", description: "Window para inv-rew-staleness-tracking; default 60s"},
			{kind: "primitive", name: "alertEmissionWindowSeconds", type:     "integer", description: "Window para inv-rew-alert-dedupe + boundedness; default 60s"},
			{kind: "primitive", name: "emitTimeoutSeconds", type:             "integer", description: "Timeout para inv-rew-computed-must-eventually-emit-or-fail; default 30s"},
			{kind: "primitive", name: "evaluationValidityWindowSeconds", type: "integer", description: "Window para inv-rew-evaluation-temporal-validity; default 300s entity_level / 120s asset_level"},
			{kind: "primitive", name: "maxEmissionRatePerSecond", type:       "integer", description: "Rate limit estrutural per scope (anti-flood); default 1000/s. errorClassEliminated: 'never drop vira vetor de ataque sob flood upstream'."},
			{kind: "primitive", name: "aclIngressRatePerSecond", type:        "integer", description: "ACL boundary ingress rate limit (separado de maxEmissionRatePerSecond domain budget); default 5000/s. Sob flood: backpressure upstream + rejection batching. errorClassEliminated: 'rejection events draining domain emission budget'."},
			{kind: "primitive", name: "aclValidationCostBudgetPerSignalMs", type: "integer", description: "Per-signal validation cost ceiling (inv-rew-acl-validation-cost-bounded); default 50ms. Signal exceeding → rejected com 'cost-exceeded'."},
			{kind: "primitive", name: "aclValidationCostBudgetPerSecondMs", type: "integer", description: "Per-window cumulative validation cost ceiling; default 50000ms = 50 cores @ 1s wall. Window exhausted → ACL throttle + backpressure. errorClassEliminated: 'distributed cheap-but-many cost attack passing under per-signal budget'."},
			{kind: "primitive", name: "entitySourceRestriction", type:        "string", description: "Optional comma-separated narrowing"},
			{kind: "primitive", name: "activatedAt", type:                    "datetime"},
			{kind: "primitive", name: "deprecatedAt", type:                   "datetime"},
			{kind: "value-object-ref", name: "activatedBy", valueObjectRef:        "vo-external-ref"},
			{kind: "value-object-ref", name: "deprecatedBy", valueObjectRef:       "vo-external-ref"},
			{kind: "value-object-ref", name: "deprecationReason", valueObjectRef: "vo-decision-reason"},
		]

		handlesCommands: [
			"cmd-activate-risk-policy",
			"cmd-deprecate-risk-policy",
		]

		emitsEvents: [
			"evt-risk-policy-activated",
			"evt-risk-policy-deprecated",
		]

		protectsInvariants: [
			"inv-rew-model-policy-separation",
			"inv-rew-model-policy-independence",
		]

		usesValueObjects: [
			"vo-external-ref",
			"vo-decision-reason",
		]

		lifecycle: {
			initialState: "draft"
			states: ["draft", "active", "deprecated"]
			transitions: [
				{
					from:               "draft"
					to:                 "active"
					triggeredByCommand: "cmd-activate-risk-policy"
					emitsEvents: ["evt-risk-policy-activated"]
					guards: ["inv-rew-model-policy-independence"]
					description: "Policy promovida a active (authority supervisor+)"
				},
				{
					from:               "active"
					to:                 "deprecated"
					triggeredByCommand: "cmd-deprecate-risk-policy"
					emitsEvents: ["evt-risk-policy-deprecated"]
					guards: []
					description: "Policy marcada deprecated com reason"
				},
			]
		}

		consistencyBoundary: {
			guarantees: [
				"policy version lifecycle transitions atomic",
				"policy→model reference integrity (modelVersionRef valid + active-at-time)",
				"deprecated policies PRESERVED em event log",
				"4 separate windows (staleness/alert/emit/evaluation-validity) — anti-acoplamento",
				"maxEmissionRatePerSecond rate limit estrutural via runtime (anti-flood)",
			]
			explicitlyDoesNotGuarantee: [
				"evaluations using this policy are unaffected by policy state change (frozen at cmd-request)",
				"policy effective-at-time validation (runtime per evaluation)",
				"consumer immediate visibility",
			]
			failureModes: [
				"policy activation referencing inactive model: rejected (modelVersionRef must be active)",
				"policy deprecate while evaluations in-flight: NÃO afeta in-flight (snapshot)",
				"entitySourceRestriction NOT subset of canvas-declared: rejected",
				"concurrent activate de mesmo policyVersion: CAS resolves first-wins",
				"emission rate exceeded: backpressure runtime + alert (não silently drop)",
			]
			rationale: "Policy aggregate. Pode referenciar Model (sentido permitido); 4 windows separadas + rate limit (anti-acoplamento + anti-flood)."
		}

		rationale: "Policy aggregate. 4 windows + rate limit estabelecem operational guards explícitos."
	}]

	// =========================================================
	// POLICIES (1 — pol-mark-stale-on-relevant-signal)
	// =========================================================
	// Part 1: pol-mark-stale (única automation justificável). Part 2
	// deferred: pol-emit-risk-alert-on-eligibility-denied (alert
	// raising via aggregate behavior em agg-risk-alert).

	policies: [{
		code:             "pol-mark-stale-on-relevant-signal"
		name:             "Auto-mark active evaluations stale when relevant signal arrives"
		description:      "Triggered por evt-signal-received. Para cada active evaluation E onde match-criteria(signal, E) é true, emite cmd-mark-evaluation-stale (internal orchestration). match-criteria default Phase 0: signal.entityRef == evaluation.context.entityRef OR signal.assetRef == evaluation.context.assetRef. Boundedness enforced por inv-rew-event-emission-boundedness — máximo 1 emit por evaluation por window."
		triggeredByEvent: "evt-signal-received"
		issuesCommand:    "cmd-mark-evaluation-stale"
		guards: [
			"inv-rew-staleness-tracking",
			"inv-rew-active-evaluation-rule",
			"inv-rew-no-staleness-feedback-loop",
			"inv-rew-event-emission-boundedness",
		]
		rationale: "Staleness automation única exception ao 'agentes recomendam, gates validam' (P10) porque staleness é SINAL, não DECISÃO — não decide ação, apenas torna freshness observable. cmd-mark-evaluation-stale é internal orchestration command (Opção 6 founder ratified) — NÃO exposto via canvas inbound. Pattern paralelo CQRS process manager → command → aggregate → event. errorClassEliminated: 'evaluation aging silently'."
	}, {
		code:             "pol-emit-risk-alert-on-eligibility-denied"
		name:             "Auto-emit risk alert when evaluation has eligibility denied OR adversarial pattern detected"
		description:      "Triggered por evt-risk-evaluation-emitted. Quando evaluation.eligibility.decision == 'ineligible' OR adversarial-pattern-detected presente em decision reasons, emite cmd-raise-risk-alert (internal orchestration; idempotent at command level via composite key per inv-rew-alert-command-idempotency). Boundedness enforced via RiskPolicy.alertEmissionWindowSeconds."
		triggeredByEvent: "evt-risk-evaluation-emitted"
		issuesCommand:    "cmd-raise-risk-alert"
		guards: [
			"inv-rew-alert-dedupe",
			"inv-rew-alert-command-idempotency",
			"inv-rew-alert-evaluation-binding-immutability",
			"inv-rew-event-emission-boundedness",
		]
		rationale: "Alert raising automation — eligibility=ineligible OR adversarial-pattern-detected → alert para review humano. cmd-raise-risk-alert é internal orchestration (NÃO exposto canvas). errorClassEliminated: 'manual alert raising causing missed signals + audit trail gaps'."
	}]

	// =========================================================
	// PROJECTIONS (1 — prj-active-risk-evaluations OBRIGATÓRIA)
	// =========================================================
	// Per inv-rew-active-evaluation-rule: read regra deterministic
	// requer projection materializada (sem regra de leitura, sistema
	// inutilizável).

	projections: [{
		code:        "prj-active-risk-evaluations"
		name:        "Active Risk Evaluations (with staleness + temporal validity flags)"
		description: "Read model derivado para query de active evaluation por (entityRef, productCode, scope). Aplica regra inv-rew-active-evaluation-rule: active = unique latest emitted NOT superseded. Derived state expandida 5-states: {fresh-and-valid, fresh-but-stale-by-signal, stale-and-valid-by-time, expired-by-time, superseded}. Consumers obtêm decision determinística + freshness flag + temporal validity flag."
		consumesEvents: [
			"evt-risk-evaluation-emitted",
			"evt-risk-evaluation-superseded",
			"evt-risk-evaluation-marked-stale",
			"evt-risk-evaluation-emit-failed",
			"evt-signal-received",
		]
		queryCapabilities: [
			{
				code:        "qry-rew-active-evaluation-by-scope"
				description: "Find active evaluation por (entityRef, productCode, evaluationScope, optional assetRef). Retorna evaluation + status enum {fresh-and-valid, fresh-but-stale-by-signal, stale-and-valid-by-time, expired-by-time} OR not-found. Active definition per inv-rew-active-evaluation-rule."
				rationale:   "Query principal — consumers (CMT, FCE, SCF) precisam decision para entity+product no contexto da decisão deles. Status expandido permite consumer decision sob authoritative + eventual consistency (per inv-rew-evaluation-temporal-validity)."
			},
			{
				code:        "qry-rew-evaluation-staleness-status"
				description: "Check staleness + temporal validity status de active evaluation. Consumer decide se aceita stale OR expired OR requesta fresh evaluation."
				rationale:   "Staleness signal-driven + expired time-driven são INDEPENDENTES — consumer trata cada caso. Sem essa query, freshness e validity opacas."
			},
		]
		rationale: "Projection OBRIGATÓRIA per inv-rew-active-evaluation-rule + inv-rew-evaluation-temporal-validity. Append-only sem regra de leitura = sistema inutilizável. errorClassEliminated: 'consumer reads não-determinísticos + decisão temporalmente inválida'."
	}, {
		code:        "prj-active-risk-alerts"
		name:        "Active Risk Alerts (open + acknowledged)"
		description: "Read model derivado para query de active alerts. Active = status ∈ {open, acknowledged}; resolved é terminal histórico (não active). Consumer (CMT) usa para visibility por evaluation."
		consumesEvents: [
			"evt-risk-alert-raised",
			"evt-risk-alert-acknowledged",
			"evt-risk-alert-resolved",
		]
		queryCapabilities: [
			{
				code:        "qry-rew-active-alerts-by-evaluation"
				description: "Query active alerts por evaluationId. Retorna lista de alerts ativos vinculados à evaluation. Binding evaluationId é IMUTÁVEL (inv-rew-alert-evaluation-binding-immutability) — alerts NÃO migram para new evaluation."
				rationale:   "Consumer (CMT) precisa visibility por evaluation para review humano + escalation. Sem essa query, consumers escaneiam event log diretamente."
			},
			{
				code:        "qry-rew-active-alerts-by-severity"
				description: "Query active alerts por severity threshold (e.g., critical+, high+, medium+). Operations dashboard prioritizes critical alerts."
				rationale:   "Triagem de review humano — analisar critical antes de medium previne alert fatigue."
			},
		]
		rationale: "Alert observability projection. Sem projection, consumers fazem read inconsistente do event log."
	}]

	// =========================================================
	// MODULES (2)
	// =========================================================
	// mod-rew-acl removido — schema #Module.aggregateRefs requires ≥1;
	// ACL boundary documentado via inv-rew-signal-validation-before-
	// ingestion + agg-risk-evaluation handles ACL events directly.

	modules: [{
		code:        "mod-rew-evaluation"
		name:        "Evaluation + Alert (decision + observability)"
		description: "Module agrupando agg-risk-evaluation + agg-risk-alert. Decision emission + alert observability. Anti-feedback rule: alert reage; evaluation NÃO reage a alert."
		aggregateRefs: ["agg-risk-evaluation", "agg-risk-alert"]
		rationale: "Evaluation emite decisão; alert observa. Ambos compartilham subject (evaluationId binding) mas mantêm boundaries separados (anti-feedback per inv-rew-alert-no-feedback-to-evaluation)."
	}, {
		code:        "mod-rew-control"
		name:        "Model + Policy (versioned control)"
		description: "Module agrupando agg-risk-model + agg-risk-policy. Versioning canonical. Independência arquitetural model→policy."
		aggregateRefs: ["agg-risk-model", "agg-risk-policy"]
		rationale: "Model prevê (probabilístico); policy decide (categórico). Independência arquitetural enforced via inv-rew-model-policy-independence; policy pode referenciar model via modelVersionRef (não inverso)."
	}]

	// =========================================================
	// INTERPRETATION CONTRACTS (per adr-081 + adr-084)
	// =========================================================

	systemConsistencyModel: {
		type: "eventual"
		intraAggregateGuarantees: [
			"evaluation lifecycle atomic dentro de agg-risk-evaluation (CAS supersede + frozen versions + temporal validity)",
			"alert lifecycle atomic dentro de agg-risk-alert (anti-feedback enforced; binding immutable)",
			"model version lifecycle atomic dentro de agg-risk-model (independência policy)",
			"policy version lifecycle atomic dentro de agg-risk-policy (4 windows separadas + rate limit)",
		]
		crossAggregateGuarantees: [
			"evaluation correctness preserved cross-restart (replay determinístico via replayHash + signalSnapshotIds immutable)",
			"causation chain reconstrutível cross-aggregate (correlationId root cmd-request + causationId chain)",
			"lineage tree integrity (parentEvaluationId acyclic + temporal-ordered + single-successor enforced via CAS)",
			"model+policy version frozen at cmd-request (immutable across compute→emit→supersede via inv-rew-version-frozen-at-request)",
			"temporal validity boundary explícito (validUntilTimestamp por evaluation)",
			"replay confidence declared (complete|partial|degraded) — cross-entity replay limitation tornada explícita",
		]
		explicitlyDoesNotGuarantee: [
			"immediate alert visibility post evaluation emission (eventual via prj-active-risk-alerts)",
			"cross-aggregate atomic transactions (saga pattern para multi-aggregate workflows)",
			"model/policy activation visible imediatamente cross-aggregate (eventual via event log)",
			"consumer dedupe automatic (consumer responsibility per evaluationId/alertId/causationId)",
			"cross-entity replay reconstruction (limitation declarada; replayConfidence='partial' OR 'degraded')",
			"cross-BC consumer compliance with consumerProtocol (governance, NÃO enforcement runtime — per def-016)",
		]
		conflictResolution: {
			strategy: "explicit-command"
			rationale: "Tudo via cmd-supersede + commands explícitos. NUNCA last-write-wins automático. Concorrência sem regra = comportamento não-determinístico. Founder Phase 3 directive ratified."
		}
		consumerProtocol: [
			"Consumer MUST check evaluation.status flag (fresh|stale) before acting (sob authoritativeScope)",
			"Consumer MUST check evaluation.validUntilTimestamp before acting; if now() > validUntilTimestamp, decisão EXPIRED (inv-rew-evaluation-temporal-validity)",
			"Consumer MUST define tolerance window for staleness acceptance per use-case (CMT real-time payment: 30s; SCF originación: 5min)",
			"Consumer MUST re-request evaluation via cmd-request-risk-evaluation if stale beyond tolerance OR expired beyond validUntilTimestamp",
			"Consumer MUST dedupe by evaluationId at receive boundary (event retry produces same evaluationId)",
			"Consumer MUST handle evt-risk-evaluation-superseded by invalidating cached active evaluation for scope",
			"Consumer MUST handle evt-risk-evaluation-emit-failed by treating evaluationId as ABORTED (não cache; não use)",
			"Consumer MUST NOT consume internal events (visibility='internal') — only published events constitute REW contract; evt-risk-evaluation-computed é INTERNAL exclusively",
			"Consumer MUST handle replay output replayConfidence enum: 'complete' for auditing/regulatory; 'partial' for debugging com awareness; 'degraded' for escalation only (NÃO usable as authoritative)",
		]
		systemFailureModes: [
			"evaluation emitted without alert raised (alert pipeline lag — consumer must tolerate temporary mismatch)",
			"alert raised delayed relative to evaluation emission (eventual via event log replay)",
			"projection lag causing stale reads (active evaluation rule from event log = source of truth; projection é optimization)",
			"compute success + emit failure: handled by inv-rew-computed-must-eventually-emit-or-fail (timeout → emit-failed = ABORT)",
			"supersede + concurrent staleness mark: order resolved by event log timestamp; no double-state",
			"supersede + concurrent emit-failed: precedence resolved by inv-rew-supersede-emit-failed-precedence (semantic precedence — supersede só opera em lifecycle)",
			"model/policy activation visible to some consumers but not others temporarily (eventual via event log)",
			"consumer reading evaluation pre-emit-failed: subsequent emit-failed invalidates retroactively (consumer must handle invalidation)",
			"cross-aggregate event ordering NOT guaranteed (consumer must reconstruct via causationId chain)",
			"ACL validation failure during burst: evt-signal-rejected emitted (1:1) OR aggregated batch sob flood; backpressure via runtime + aclIngressRatePerSecond + maxEmissionRatePerSecond domain budget protected",
			"consumer ignoring REW authoritative decision (cross-BC contract violation) — UNDETECTABLE at runtime in Phase 3; requires governance OR future attestation infrastructure (per def-016 deferred decision)",
			"replay returning replayConfidence='partial' OR 'degraded': consumer responsibility — adapt usage per level; NÃO trust 'partial' as authoritative",
			"evaluation expired (now() > validUntilTimestamp): consumer responsibility — request fresh OR ADR override (consumer correto + protocolo seguido + decisão expirada = consumer responsibility)",
			"distributed cheap-but-many ACL validation cost attack: per-signal budget passes; per-window cumulative budget triggers throttle (inv-rew-acl-validation-cost-bounded — protege output AND processamento)",
			"compute race: late emit blocked by newer evaluation NÃO é failure — emit-superseded-by-newer event emitted com successorEvaluationId; consumer pode adopt successor (inv-rew-obsolete-evaluation-must-link-successor) — FAILURE ≠ OBSOLESCENCE",
			"replay confidence leakage: 'partial' replay output feeding training/analytics/derived signals → erro parcial vira verdade futura. inv-rew-replay-confidence-propagation força propagação metadata downstream (BEHAVIORAL — runtime concern + data lineage tracking)",
			"TOCTOU consumer side: evaluation read at T1; action commit at T2; supersede entre T1-T2 → ação stale. inv-rew-decision-binding-to-evaluation-version força consumer recheck status pre-commit (consumer responsibility)",
			"distributed fraud below per-entity threshold: cross-entity adversarial pattern undetectable em REW (replayScopeStrategy='by-entityRef'); systemic blind spot DECLARED via inv-rew-undetectable-pattern-risk-declared (honesty invariant — força visibilidade não comportamento). Detection requires upstream BC correlation OR future cross-entity correlation infrastructure (separate concern)",
		]
		replayScopeStrategy: "by-entityRef"
		rationale: """
			Eventual consistency é o modelo correto para sistema distribuído REW:
			intra-aggregate (ACID); cross-aggregate (event-driven eventual).

			consumerProtocol MANDATORY for consumers under decisionAuthorityModel.
			authoritativeScope — enforcement EXTERNAL TO REW (validated via
			structural-check against consuming BC declarations + ADR overrides).
			Protocolo sem enforcement é documentação, não contrato. Cross-BC
			technical enforcement (signature/blocking/attestation) deferred
			via def-016 (Phase N+1 quando evidência empírica multi-BC justify
			heavy infra).

			replayScopeStrategy='by-entityRef' suporta per-entity replay
			(escala — reconstruction de 1 entity NÃO requer global computation).
			LIMITAÇÃO: cross-entity replay é SEPARATE concern; output usa
			replayConfidence enum {complete, partial, degraded} per inv-rew-
			replay-scope-completeness — replay pode mentir e consumer aceita
			sem detection foi BLOQUEADO via declaração de completude.
			REW MUST operate under by-entityRef strategy: cross-scope replay
			requests rejected; future migration requires ADR + data migration plan.

			Production-safety hardening final pressure:
			- inv-rew-supersede-emit-failed-precedence (precedência semântica)
			- inv-rew-evaluation-temporal-validity (validUntilTimestamp)
			- inv-rew-replay-scope-completeness (replayConfidence enum)
		"""
	}

	decisionAuthorityModel: {
		type: "authoritative"
		authoritativeScope: """
			Risk assessment domain (signal interpretation, score computation,
			eligibility decision, risk alert raising). Consumers (CMT, FCE,
			SCF) DEVEM tratar evt-risk-evaluation-emitted como input
			autoritativo para suas próprias decisões — NÃO podem ignorar
			decision OR substituir score sem ADR documentando override
			rationale. REW é source of truth para 'qual é o risco neste
			contexto'; consumers retêm autoridade sobre 'que ação tomar
			dado esse risco'.

			LIMITATION ACKNOWLEDGED: enforcement runtime de cross-BC
			compliance é GOVERNANÇA ORGANIZACIONAL (ADR review process),
			NÃO garantia técnica. Consumer pode violar protocolo silently
			no runtime — detectável apenas via post-hoc audit OR runtime
			attestation infrastructure (per def-016 deferred decision —
			Phase N+1 quando evidência empírica multi-BC justify).

			CONFLICT RESOLUTION PRIORITY (Phase 3 default — não congelado;
			cross-BC governance level; REW participates, NÃO enforces):
			fraud-detection > payment-authorization > credit-origination.
			Quando consumers divergem em decisão para mesma scope/entity
			(timeline differences sob eventual consistency), priority
			declarada governs reversal/compensation flow downstream
			(saga pattern responsibility cross-BC). Phase 3 default
			capturado em prose; future ADR pode formalizar como
			structured field se ≥3 cross-BC scenarios emergirem com
			conflicting priority needs. Ajuste anti-frozen-semantics:
			'current default Phase 3' phrasing preserva opção de revisita
			quando outros BCs/produtos entrarem (anti-acidental commitment).
		"""
		rationale: """
			Sem decisionAuthorityModel declarado, integração com outros
			BCs quebra silenciosamente (founder Phase 3 insight). REW
			autoritativo no DOMÍNIO de risk assessment garante coerência
			cross-BC: todos consumers usam mesma evaluation como input
			canonical; divergência cross-BC indica bug (não preferência).
			Authoritative ≠ dictator: consumers retêm decisão de AÇÃO;
			REW garante consistência da AVALIAÇÃO. Override formal
			(cross-BC) requer ADR explícito documentando trade-off.

			LIMITATION declarada explicitly: governance organizacional
			≠ garantia de sistema (founder Phase 3 final pressure
			insight). Cross-BC technical enforcement é deferred
			conscious decision (def-016 trigger automático em pattern
			detection canvas-level).
		"""
	}

	// =========================================================
	// OUTER RATIONALE
	// =========================================================

	rationale: """
		Domain Model REW Phase 3 Part 1 — COMPILAÇÃO do glossary Phase 2
		em building blocks DDD. REW é controle epistemológico (NÃO
		documentação): domain model materializa o que o sistema está
		AUTORIZADO a considerar verdade.

		**Frase canonical Phase 2 que ancora todo o design**:
		'Glossary não define palavras — define o que o sistema está
		autorizado a considerar verdade.'

		**5 LAYERS ONTOLÓGICAS preservadas do glossary** (Reality
		Interpretation → Epistemic → Decision → Control → Actor):

		Layer 1 (Reality): vo-signal + 4 payload variants ACL-translated
		do upstream BC. ACL boundary preserved via mod-rew-acl
		anti-corruption rule (REW NUNCA branch em payload field).

		Layer 2 (Epistemic): vo-confidence-interval + vo-coverage-stats
		+ vo-uncertainty-driver. Confidence EXPLICÁVEL via uncertainty-
		Drivers — força declarar QUE causou incerteza (review acionável).
		Coverage WEIGHTED (não simples ratio) — relevância > quantidade.

		Layer 3 (Decision): vo-eligibility-decision + vo-decision-reason
		+ ent-reasoning-trace. Decision categórica + reasons estruturados
		+ trace auditável (≥2 intermediateSteps obrigatórios).

		Layer 4 (Control): vo-risk-score + vo-scale-metadata + agg-risk-
		evaluation. Score com calibrationProfile binding (mesma escala ≠
		mesma semântica). Aggregate central com lifecycle 3-estados.

		Layer 5 (Actor): vo-external-ref + actorAuthority enum em
		commands/events. sh-06 Adversário Econômico modelado como
		behavioral class via inv-rew-asset-aware-discipline +
		uncertainty driver adversarial_signal_suspicion + decision
		reason adversarial-pattern-detected.

		**REGRA DE 3 CAMADAS** (founder Phase 3 directive — Opção A):
		- VO define forma (CUE schema-time)
		- invariant define verdade (rule + rationale)
		- structural-check impõe verdade (Phase 3 Part 3 deferred)

		**REGRA-GOV-VO-01** (governance): nenhum VO criado sem
		errorClassEliminated explícito. Aplicado retroativamente aos
		17 VOs (cada VO declara classe de erro que elimina no rationale).

		**REGRA-GOV-WRITE-01** (governance): incompleto ≠ incoerente.
		Part 1 é estado intermediário coerente com Part 2/3 cascade
		documentado em this rationale.

		**24 INVARIANTS** organizados em 3 grupos:
		(a) STRUCTURAL (CUE schema-time presence + structural-check
			cross-field): bounded-score, contextual-completeness,
			alert-lifecycle, asset-aware-discipline, model-policy-
			separation, temporal-consistency, snapshot-temporal-
			consistency, evaluation-completeness, alert-dedupe,
			compute-emit-ordering, alert-evaluation-binding-immutability,
			active-evaluation-rule, signal-corruption-handling
		(b) SEMI (CUE shape + structural-check coherence): signal-
			traceability, model-version-binding, reasoning-completeness,
			deterministic-replay (replayHash format), command-
			idempotency, staleness-tracking
		(c) BEHAVIORAL (architectural discipline + review): model-
			policy-independence, payload-opacity, explicit-supersede-
			only, no-staleness-feedback-loop, event-emission-boundedness

		**S7 STRUCTURAL-CHECKS QUEUE** (architecture/structural-checks/
		rew-domain-model.cue — Part 3 deferred):
		- sc-rew-signalType-source-binding (signalType↔sourceContext
		  canonical {kyc→npm, fiscal→fce, device→nim, behavioral→dlv})
		- sc-rew-signal-idempotency (identity vs integrity split)
		- sc-rew-signal-payload-binding (signalType↔payloadVoCode)
		- sc-rew-alert-ack-authority-binding (authority por severity)
		- sc-rew-no-policy-implicit-supersede (concurrency rule)
		- sc-rew-correlation-id-root (correlationId origin tracking)
		- sc-rew-no-state-event-feedback (state events não triggeram)
		- sc-rew-active-evaluation-uniqueness (1 active per scope)
		- sc-rew-command-idempotency (commandId+payloadHash mapping)
		- sc-rew-snapshot-temporal-consistency (signal.capturedAt
		  ≤ decisionContextTime)
		- sc-rew-alert-evaluation-binding-immutability
		- sc-rew-evaluation-lineage-existence (parentEvaluationId chain)
		- sc-rew-evaluation-completeness (final gate antes emit)
		- sc-rew-command-authority-binding (cmd→requiredAuthority map)
		- sc-rew-event-emission-boundedness (window-bounded emission)
		- sc-rew-score-scale-range (conditional value range per scale)
		- sc-rew-asset-aware-discipline (cross-VO conditional)
		- sc-rew-eligibility-* (decision coherence + element validation)
		- sc-rew-context-entity-source-canvas-binding (canvas as primary)
		- sc-rew-version-format + sc-rew-version-coherence
		- sc-rew-trace-steps-cardinality (≥2 intermediate steps)

		**LENS APLICADA**: lens-domain-language-and-terminology-design
		(applied em glossary Phase 2 — domain model herda dl-bilingual-
		terminology + dl-term-selection-criteria + dl-cross-layer-
		consistency).

		**CASCADE ORDERING preserved**: stakeholder-map sh-06 (Phase 1)
		+ canvas REW Phase 1 (commit fbe0b2d) + glossary Phase 2
		(commit 7854cc7) existem ANTES desta instância. Schema
		#DomainModel NÃO modificado (Opção A — blast radius zero;
		INV/DLV/SSC/PG existentes preservados).

		**KNOWN DIVERGENCES E DEFERIMENTOS**:
		(1) Canvas Phase 1 declarou RiskScoreEmitted + EligibilityEmitted
		    como events separados; Phase 3 design unificou em
		    evt-risk-evaluation-emitted (decision atômica). Canvas
		    alignment update tracked para commit pos Part 2 — runner
		    tq-dm-11 emitirá warn até alignment.
		(2) 4 invariants para agg-risk-alert/agg-risk-model serão
		    deferred orphans em Part 1 (alert-lifecycle, alert-dedupe,
		    alert-evaluation-binding-immutability, model-policy-
		    independence) — tq-dm-03 emitirá warn até Part 2.
		(3) Comandos cmd-acknowledge-risk-alert + cmd-resolve-risk-
		    alert + cmd-activate-risk-* + cmd-deprecate-risk-* são
		    declarados mas NÃO handled por agg-risk-evaluation —
		    aguardam aggregates Part 2 (tq-dm-01 emitirá warn).
		(4) Commands list inclui cmd-mark-evaluation-stale (internal
		    orchestration); tq-dm-12 (canvas inbound alignment) NÃO
		    aplica — internal commands NÃO aparecem em canvas.
		(5) Module decomposition documentada em header comment;
		    materialização em modules[] deferred Part 2.
		(6) Structural-checks executáveis em architecture/structural-
		    checks/rew-domain-model.cue — Part 3 deferred (≥21 sc-rew-*
		    rules listadas como S7 queue).
		(7) Authority validation table (cmd→requiredAuthority) é
		    structural-check rule, não declared em domain-model.
		    Mapping queue: activate/deprecate-risk-{model,policy} →
		    supervisor+; resolve-alert-critical → supervisor+;
		    acknowledge/resolve-alert (não-critical) → analyst+;
		    cmd-mark-evaluation-stale → automated-policy ONLY.

		**INSIGHTS CANONICAL Phase 3 capturados** (gravados como
		invariant rationales + fields descriptions):
		- 'observação pertence ao upstream, ingestão pertence ao REW'
		- 'idempotência é sobre identidade; hash é sobre integridade'
		- 'decidir ≠ publicar' (compute/emit split)
		- 'substituição sem razão = corrupção silenciosa'
		- 'quem fez ≠ quem podia fazer' (actorAuthority)
		- 'idempotência não é só para eventos — é principalmente para
		  comandos' (commandId)
		- 'sem root, correlationId vira só UUID bonito' (cmd-request-
		  risk-evaluation como root)
		- 'concorrência sem regra = comportamento não-determinístico'
		  (explicit-supersede-only)
		- 'eventos de estado NÃO podem reentrar no pipeline de decisão'
		- 'supersede = decisão histórica; active = visão operacional'
		- 'idempotência sem integridade = replay corrompido'
		- 'sem consistência temporal, replay é falso'
		- 'alert sem referência imutável vira ruído histórico'
		- 'sem lineage, histórico vira lista — não estrutura'
		- 'estado impossível que não é bloqueado → vai acontecer'
		- 'sem controle de emissão, sistema correto vira sistema
		  inutilizável'
		- 'forçar causalidade inexistente cria mentira estrutural'
		- 'sem inputs explícitos, não existe explicação — só resultado'
		- 'append-only sem regra de leitura = sistema inutilizável'
		- 'detectar corrupção sem decidir o que fazer = meia
		  arquitetura'
		- 'supersede decide; staleness sinaliza' (staleness ≠ supersede)
		- 'um bom domain model não é o que cobre tudo — é o que torna
		  impossível fazer coisas erradas'
		- 'o melhor sistema não é o mais expressivo — é o que consegue
		  evoluir sem quebrar a própria verdade'

		Phase 3 Part 1 fechou ~95% das classes de erro estruturais
		(founder Phase 3 final assessment). Os 5% restantes (loops,
		consistência temporal granular, lineage edge cases) endereçados
		via S7 structural-checks Part 3 + runtime gates.
		"""
}
