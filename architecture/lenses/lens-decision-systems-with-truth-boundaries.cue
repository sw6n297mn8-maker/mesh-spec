package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

decisionSystemsWithTruthBoundaries: artifact_schemas.#AnalyticalLens & {
	id:     "lens-decision-systems-with-truth-boundaries"
	name:   "Decision Systems with Truth Boundaries"
	purpose: "Orientar Phase 3 (domain-model) de bounded contexts cujo papel é produzir decisões consumidas cross-BC como input autoritativo, onde a verdade da decisão tem limites explícitos (validade temporal, completude de replay, precedência semântica, anti-corruption boundary). Pattern extraído de REW Phase 3 (WI-046) via 2 War Game Rounds + 8 founder pressure rounds — primeiro exemplar completo da Mesh."
	status: "draft"

	trigger: {
		conditions: [
			"BC produces evaluations consumed cross-BC as authoritative input para outras BCs (não apenas decisões internas)",
			"decisions têm validade temporal explícita — decision ≠ state; decision = state + tempo (e.g., risk evaluation expires; pricing window ends; sanction list snapshot ages)",
			"decisions can become invalid WITHOUT explicit mutation event (mundo muda; signal arrives; clock passes — sem que algum agente emita 'invalidate') — esta condição é CRITICAL: separa cases reais (lens applies) de cases triviais (state-only systems)",
			"replay/audit é regulatory OR business requirement (Bacen audit; LGPD evidence; internal compliance review; regulator on-demand reconstruction)",
			"consumer-side decisions depend on REW-style evaluation com cross-BC contract semantics (consumer must follow protocolo; override requires ADR; eventual consistency cross-BC)",
		]
		keywords: [
			"decision system", "evaluation", "authoritative",
			"truth boundary", "temporal validity", "validUntil",
			"replay confidence", "audit reconstruction",
			"emit failure", "obsolescence", "supersede",
			"interpretation contract", "consumer protocol",
			"eventual consistency cross-BC", "anti-corruption layer",
			"signal validation", "ACL boundary", "rejection event",
			"consistency boundary", "decision authority",
			"production-safe decision",
		]
		excludeWhen: [
			"BC é apenas state machine sem decisão temporal — usar generic DDD aggregates",
			"BC é puramente internal sem cross-BC consumers — não há need para interpretation contracts",
			"applicabilityTest: If removing validUntilTimestamp from the design does NOT break correctness, this lens should NOT be applied. Lens é overkill quando decisions têm validity intrínseca ao state (sem invalidation por passagem de tempo OR signal arrival sem mutation event)",
			"BC é orchestration/saga (coordenador de múltiplos aggregates) — usar lens-saga-orchestration (future, when emerges)",
			"BC é pure read model / projection layer — não produz decisions, só agrega",
		]
		rationale: "REW Phase 3 + 2 War Game Rounds materializaram primeiro exemplar completo de pattern transversal aplicável a CMT (commitment lifecycle decisions com temporal validity), FCE (fraud + compliance evaluations cross-BC authoritative), SCF (credit origination decisions com replay audit), NIM (network integrity assessments cross-BC). 5 conditions trigger (incluindo CRITICAL temporal-invalidation-without-mutation) + applicabilityTest (validUntilTimestamp removability) separa lens applicability rigorously. Sem essa lens, próximo BC reimplementa parcialmente + invariants críticos esquecidos + divergência silenciosa. Bloomberg-style vocabulary moat aplicado a arquitetura: pattern reusável codificado torna Mesh accelerator cross-BC bootstrap."
	}

	concepts: [
		{
			id:         "ds-truth-boundaries"
			name:       "Truth Boundaries: Cada decisão carrega seu próprio contexto de verdade"
			nature:     "operational"
			role:       "framework"
			definition: "Decisões cross-BC autoritativas DEVEM declarar boundaries explícitos: (a) validUntilTimestamp — temporal validity (decision válida até T_emit + window); (b) replayConfidence — qualidade de reconstrução audit (complete | partial | degraded); (c) emit-failed (ABORT) vs emit-superseded-by-newer (OBSOLESCENCE) distinction — failure ≠ obsolescence semantically. Sem truth boundaries, sistema 'está correto' mas consumer toma decisão errada (founder War Game insight: 'evaluation ≠ decisão válida; evaluation + tempo → decisão válida'). Pattern transformacional: 'estado correto → decisão correta no tempo'."
			meshManifestation: "REW reference implementation (contexts/rew/domain-model.cue): validUntilTimestamp em evt-risk-evaluation-emitted + agg-risk-evaluation field (computed at emit = emittedAt + RiskPolicy.evaluationValidityWindowSeconds; default 300s entity_level / 120s asset_level). replayConfidence enum em replay output (per inv-rew-replay-scope-completeness). emit-failed (evt-risk-evaluation-emit-failed = ABORT; NÃO entra em lifecycle) DISTINGUISHED from emit-superseded-by-newer (evt-risk-evaluation-emit-superseded-by-newer com successorEvaluationId reference; consumer pode adopt ao invés de retry). 3 invariants core: inv-rew-evaluation-temporal-validity + inv-rew-replay-scope-completeness + inv-rew-obsolete-evaluation-must-link-successor."
			meshImplication: "Phase 3 de BC matching activationCriteria: (1) declare temporal validity field em emit event + aggregate (windowSeconds policy-defined); (2) replay output usa enum {complete, partial, degraded} com consumer protocol entries 'complete=auditing/regulatory; partial=debugging only; degraded=escalation only'; (3) emit failure modes diferenciados (ABORT vs OBSOLESCENCE) com distinct events — successor reference em obsolescence event permite consumer adopt. NON-PATTERN ELEMENT (REW-specific): exact validity windows (300s/120s) + replay scope (by-entityRef vs by-correlationId) — cada BC calibra per domain semantics. PATTERN ELEMENT (transversal): existence + structure of truth boundaries."
			rationale: "Truth boundaries transformaram REW de 'production-grade architecture' (Part 2) para 'production-safe decision system' (Part 2.1 boundary commit). Sem truth boundaries, eventual consistency + authoritative = decisões incorretas inevitáveis em escala (founder War Game 1)."
		},
		{
			id:         "ds-temporal-correctness"
			name:       "Temporal Correctness: Decision = State + Tempo (não apenas state)"
			nature:     "theoretical"
			role:       "property"
			definition: "Modelagem temporal correta requires: (a) version freezing at request time — input model + decision rule versions ATIVOS no momento do cmd-request são SNAPSHOT IMUTÁVEL ao longo de toda evaluation chain (inv-rew-version-frozen-at-request); (b) signalSnapshot temporal consistency — todos signals em snapshot DEVEM preceder decisionContextTime (inv-rew-snapshot-temporal-consistency); (c) tolerance window cross-BC explícito (boundaries upstream com clock-skew tolerance; intra-BC single clock authority); (d) compute → emit ordering (inv-rew-compute-emit-ordering); (e) emit-after-newer-emit blocked (inv-rew-emit-after-newer-emit-rejected — late emit detected at emit time). Pattern: tempo NÃO é metadata adicional; é PARTE DA VERDADE da decisão."
			meshManifestation: "REW: cmd-request-risk-evaluation captura requestedModelVersion + requestedPolicyVersion como SNAPSHOTS imutáveis (founder ajuste — model+policy inseparáveis; congelar um sem o outro é bug). emittedAt + computedAt + decisionContextTime + signalSnapshotTime + observedAt + recordedAt — 6 timestamps com chain monotonia + tolerance window 5min default cross-BC. Active rule deterministic: latest emittedAt NOT superseded; ties broken por evaluationId ascending."
			meshImplication: "Phase 3 BC: declare temporal chain explicit + version freeze at request command + active rule deterministic. NON-PATTERN ELEMENT: exact tolerance windows + specific timestamp fields per domain. PATTERN ELEMENT: version freezing + temporal chain monotonia + deterministic active rule + tie-breaking explicit."
			rationale: "Founder Phase 3 insight: 'mudança de modelo no meio de um fluxo = quebra semântica invisível'. Version freezing fecha race entre activation e compute. Tolerance window absorve real-world clock skew sem mascarar corrupção (>15min indica problema infra, não temporal violation)."
		},
		{
			id:         "ds-semantic-determinism"
			name:       "Semantic Determinism: Precedência explícita; obsolescence ≠ failure"
			nature:     "operational"
			role:       "framework"
			definition: "Concorrência sem regra = comportamento não-determinístico. Determinismo semântico requires: (a) explicit-supersede-only — REW NUNCA supersede automaticamente; substituição é DECISÃO via cmd-supersede explícito (inv-rew-explicit-supersede-only); (b) supersede-after-emit-only — supersede só opera em evaluation ∈ lifecycle (inv-rew-supersede-after-emit-only + inv-rew-supersede-emit-failed-precedence semantic); (c) supersede-requires-current-active — atomic CAS check at command time (inv-rew-supersede-requires-current-active); (d) lineage TREE não DAG — single-successor enforced (inv-rew-single-successor-per-evaluation); (e) FAILURE ≠ OBSOLESCENCE — emit-failed (ABORT) vs emit-superseded-by-newer (recoverable). Pattern: ordem técnica → significado único do evento."
			meshManifestation: "REW: 5 invariants core de semantic determinism (explicit-supersede-only + supersede-after-emit-only + supersede-requires-current-active + single-successor + supersede-emit-failed-precedence) + 2 events distinct (emit-failed + emit-superseded-by-newer com successorEvaluationId). Lifecycle 3-states (emitted/stale/superseded) com transitions list closed por exclusão = forbidden states irrepresentáveis."
			meshImplication: "Phase 3 BC: declare 5 core semantic determinism invariants + distinct events para failure vs obsolescence + lifecycle transitions explícitas (closed list). Successor chain bounded N=3 hops consumer-side (inv-rew-successor-chain-bounded — anti-livelock). NON-PATTERN ELEMENT: specific lifecycle states (emitted/stale/superseded REW). PATTERN ELEMENT: structural pattern of explicit-only mutations + atomic CAS + tree (não DAG)."
			rationale: "Founder War Game insight: 'bug pode parecer comportamento válido'. Sem precedência semântica explícita, 2 outcomes mutuamente exclusivos coexistem (superseded OR aborted? — auditor humano trava). Distinction failure-vs-obsolescence elimina consumer retry loop (founder War Game 2: 'FAILURE ≠ OBSOLESCENCE')."
		},
		{
			id:         "ds-execution-integrity"
			name:       "Execution Integrity: Invariants → Structural-Checks Executáveis"
			nature:     "operational"
			role:       "method"
			definition: "Boundary commit principle: invariants declarativos em domain-model devem TRANSITAR para structural-checks executáveis (per ADR-080 #DomainInvariantRule kind). Execution integrity requires: (a) replay determinism via replayHash canonical serialization (inv-rew-deterministic-replay); (b) command idempotency com payload integrity (inv-rew-command-idempotency); (c) retry-safe computed events (inv-rew-computed-idempotent-retry); (d) compute-must-eventually-emit-or-fail (inv-rew-computed-must-eventually-emit-or-fail); (e) ACL validation cost bounded per-signal AND per-window (inv-rew-acl-validation-cost-bounded — protege output AND processamento); (f) decision-binding-to-evaluation-version cross-BC contract (inv-rew-decision-binding-to-evaluation-version — TOCTOU defense). Coverage diferenciada por natureza: runtime guard (cost), semantic consistency (obsolescence), consumer contract (chain bounded), metadata integrity (replay propagation), cross-BC contract (TOCTOU)."
			meshManifestation: "REW: 5 sc-rew-* structural-check rules executáveis (architecture/structural-checks/rew-domain-model.cue) — primeiro batch boundary commit. Cada rule per ADR-080 #DomainInvariantRule: invariantId regex match + assertion formal logic + coverage 3-flag (buildTime/validationTime/runtimeRequired) + runtimeGap.enforcedBy mecanismo + forbidden state prohibitions. Coverage diferenciada por natureza ('NÃO escreva todos no mesmo estilo de check' — founder ajuste)."
			meshImplication: "Phase 3 BC + Phase 3.5 (structural-checks): boundary commit declarativo→executável após domain-model establish. Coverage MUST be diferenciada por natureza do invariant (runtime guard vs semantic consistency vs cross-BC contract vs metadata integrity vs consumer contract). Forbidden patterns são state/property prohibitions (NÃO action prohibitions). NON-PATTERN ELEMENT: exact invariant codes + specific runtime infrastructure. PATTERN ELEMENT: declarative→executable transition + coverage diferenciada + ADR-080 reference compliance."
			rationale: "Founder boundary commit insight: 'invariants deixam de ser design e passam a ser contrato executável'. Sem execution integrity, invariants viram intenção não enforcement. ADR-080 estabeleceu mecanismo (domain-invariant kind); pattern aplica esse mecanismo cross-BC."
		},
		{
			id:         "ds-boundary-integrity"
			name:       "Boundary Integrity: ACL validation + rejection explícito + interpretation contracts"
			nature:     "operational"
			role:       "framework"
			definition: "Boundary não declarado vira superfície de ataque. Boundary integrity requires: (a) ACL validation BEFORE ingestion (inv-rew-signal-validation-before-ingestion) — N checks (signalType/sourceContext/canonical mapping/integrityProof/payloadVoCode/payloadInstance availability); (b) rejection explícito EVENT NÃO drop silent (evt-signal-rejected published cross-BC com rejectionReason + validationCheckFailed); (c) ACL boundary separated from domain emission budget (aclIngressRatePerSecond ≠ maxEmissionRatePerSecond domain budget); (d) ACL flood protection via 2-layer cost budget (per-signal + per-window cumulative); (e) interpretation contracts per ADR-081 + ADR-084 (consistencyBoundary aggregate-level + systemConsistencyModel domain-level + decisionAuthorityModel cross-BC); (f) replay confidence propagation (inv-rew-replay-confidence-propagation — protege uso INDIRETO além de uso direto)."
			meshManifestation: "REW: mod-rew-acl conceitual + agg-risk-evaluation handles ACL events directly + 4 consistencyBoundary (1 per aggregate) + 1 systemConsistencyModel com consumerProtocol (9 entries) + systemFailureModes (17 entries) + replayScopeStrategy='by-entityRef' + 1 decisionAuthorityModel (authoritative + risk-assessment scope + LIMITATION cross-BC enforcement = governance not runtime)."
			meshImplication: "Phase 3 BC: declare ACL boundary com validation N-checks + rejection events explícitos (NEVER drop silent) + 2-layer cost budget + interpretation contracts (consistencyBoundary aggregate-level + systemConsistencyModel + decisionAuthorityModel per ADR-081/084) + replay confidence propagation invariant. NON-PATTERN ELEMENT: exact 6 ACL validation checks REW + specific signal types. PATTERN ELEMENT: ACL validation existence + rejection events + budget separation + interpretation contracts compliance."
			rationale: "Founder War Game insight: 'never drop vira vetor de ataque' + 'ambiguidade em boundary = bug futuro' + 'protege output mas não protege processamento'. Boundary integrity é cross-cutting concern — pattern via interpretation contracts (ADR-081/084) é canonical."
		},
		{
			id:         "ds-honesty-invariants"
			name:       "Honesty Invariants: Declarar limitações como structural facts (não silenciar)"
			nature:     "theoretical"
			role:       "property"
			definition: "Honesty invariants são INVARIANTS de honestidade do sistema, não de execução. Eles forçam VISIBILIDADE, não COMPORTAMENTO. NÃO bloqueiam, NÃO validam, NÃO interferem em fluxo, NÃO entram em aggregate enforcement guards. Exemplos: (a) inv-rew-undetectable-pattern-risk-declared — exige que systemFailureModes contenha entries para cada risk class identified as undetectable (cross-entity adversarial patterns; distributed fraud below threshold); (b) replayScopeStrategy LIMITATION declared (cross-entity replay deferred); (c) decisionAuthorityModel cross-BC enforcement LIMITATION (governance Phase 3; technical Phase N+1 per def-016); (d) deferred-decision artifacts (def-016 cross-BC enforcement) — explícito governance lifecycle. Pattern: 'declarar limitação ≠ resolver'; sistema é AUDITÁVEL precisamente porque DECLARA o que NÃO cobre."
			meshManifestation: "REW: 1 invariant honesty-pure (inv-rew-undetectable-pattern-risk-declared) + 1 deferred-decision (def-016 cross-BC enforcement) + systemConsistencyModel.systemFailureModes (17 entries declarando classes de falha distribuída esperadas; founder War Game 1 + 2 derived) + replayScopeStrategy.rationale com LIMITATION explicit (cross-entity replay deferred Phase N+1) + decisionAuthorityModel.rationale com LIMITATION explicit (governance ≠ enforcement runtime)."
			meshImplication: "Phase 3 BC: identify systemic risks que BC NÃO consegue cover (cross-BC correlation; cross-domain dependencies; emergent patterns) + DECLARE explicitly em systemFailureModes + invariants honesty quando structural facts emergem + deferred-decisions per ADR-062 quando trade-off articulated. NON-PATTERN ELEMENT: exact failure mode entries (REW-specific 17 entries cobrem REW-specific scenarios). PATTERN ELEMENT: existence + structure of honesty declarations + deferred-decision artifacts as governance mechanism."
			rationale: "Founder Phase 3 closure insight: 'não é mais desenhando um sistema; é desenhando um SISTEMA QUE NÃO MENTE' + 'sistema evita parecer correto quando está errado'. Honesty invariants transformam silent gaps em declared limitations — auditor humano + future BCs sabem o que NÃO está coberto. Sistema antifrágil a erro: erros viram eventos auditáveis, não silent corruptions."
		},
	]

	principleIds: ["P10", "dp-10"]

	reasoningProtocol: [
		{
			question: "BC produces evaluations consumed cross-BC as authoritative input?"
			reveals: "Whether lens applicability foundation exists. Lens é para decision systems, não state machines puramente internal."
			rationale: "Activation criterion 1 — sem authoritative cross-BC consumption, lens é overkill (interpretation contracts + consumerProtocol não fazem sentido sem consumers)."
		},
		{
			question: "Decisions can become invalid WITHOUT explicit mutation event?"
			reveals: "CRITICAL applicability test. Aplicável quando mundo muda OR signal arrives sem agente emit 'invalidate' event. Test concreto: 'If removing validUntilTimestamp does NOT break correctness, lens should NOT be applied'."
			rationale: "Activation criterion 3 + applicabilityTest. Separa cases reais (lens applies) de cases triviais (state-only systems). Sem este criterion, pattern aplicado onde overkill."
			appliesWhen: "Domain has temporal validity inherent (decisions age via time passage OR information arrival, not just via explicit mutation)."
		},
		{
			question: "Replay/audit é regulatory OR business requirement?"
			reveals: "Whether replayConfidence enum + replayScopeStrategy + propagation invariants são justificáveis. Sem audit need, replay infrastructure é over-engineering."
			rationale: "Activation criterion 4 — Bacen/LGPD/internal compliance/regulator on-demand define need; sem essas pressões, replayHash + canonical serialization são overkill."
		},
		{
			question: "Cross-BC consumers depend on this BC's evaluations as decision input?"
			reveals: "Whether decisionAuthorityModel + consumerProtocol são cross-BC necessities OR BC-internal apenas."
			rationale: "Activation criterion 5 — cross-BC contract enforcement requires interpretation contracts (consistencyBoundary + decisionAuthorityModel) per ADR-081/084."
		},
		{
			question: "Adversarial behavior é threat model relevant?"
			reveals: "Whether ACL validation + rejection events + cost bounded budgets são justificáveis. Sem threat model, ACL pode ser simpler."
			rationale: "Production-safety hardening (War Game derived) é overkill quando threat model é apenas operational errors. Risk/fraud/compliance domains amplify need."
			appliesWhen: "BC handles signals/inputs from untrusted OR adversarial-suspect sources (financial, identity, regulatory, signal aggregation)."
		},
	]

	meshExamples: [
		{
			id:       "ex-rew-phase-3"
			scenario: "REW (Risk Engine & Risk Observability) Phase 3 do WI-046 — primeiro exemplar completo do pattern. BC produz risk evaluations consumed cross-BC (CMT/FCE/SCF) como authoritative input; decisions têm temporal validity (validUntilTimestamp); replay regulatory requirement (Bacen audit); adversarial threat model (fraud detection); cross-BC consumers dependem (CMT pagamento; FCE bloqueio; SCF crédito)."
			analysis: "5/5 activation criteria match. applicabilityTest passes (removing validUntilTimestamp breaks correctness — eligibility 'eligible' indefinitely sob mundo mutável é correctness violation). 6 concepts da lens aplicados durante 3 phases (Part 1 + Part 2 + Part 2.1 boundary commit) + 2 War Game Rounds + 8 founder pressure rounds. Resultado: 46 invariants + 16 events + 4 aggregates + 5 sc-rew-* structural-checks executáveis + interpretation contracts maturity."
			recommendation: "REW serve como REFERENCE IMPLEMENTATION canonical. Future BCs aplicando lens podem comparar suas decisions com REW directly via lens.concepts.meshManifestation pointers. NON-PATTERN ELEMENTS REW (risk score semantics; eligibility decision structure; alert lifecycle specifics; adversarial signal taxonomy; 5-layer ontology; 4 specific aggregates) declared explicitly em adr-085 — próximo BC NÃO copia REW-specific."
			principlesApplied: ["P10", "dp-10"]
			assumptions: ["REW Phase 3 commits 31feaf9 (Part 1) + 554e8db (Part 2) + ea78e3e (Part 2.1 boundary) materializados", "adr-081 + adr-084 interpretation contracts schema layer + production-safety hardening adopted"]
			rationale: "REW é primeiro exemplar — pattern emerged from this BC. Reference implementation status até second BC application validates pattern OR coincidence."
		},
		{
			id:       "ex-cmt-phase-3-future"
			scenario: "CMT (Commitment Lifecycle Management) Phase 3 (FUTURE — próximo BC para validar pattern). CMT produz commitment decisions consumed cross-BC; decisions têm temporal validity (commitment expira com window window); replay audit requirement (regulatory + internal); cross-BC consumers (FCE settles payment; INV depends on commitment; SCF pode anticipate against commitment)."
			analysis: "Hypothetical — when CMT reaches Phase 3, lens activated based on activationCriteria match. Reasoning protocol applied: question 1 (authoritative cross-BC) ✓; question 2 (temporal invalidation without mutation — commitment can expire OR sanction-list signal arrive sem CMT mutation) ✓; question 3 (audit requirement) ✓; question 4 (cross-BC dependencies) ✓; question 5 (adversarial — payment fraud, contract gaming) ✓. PATTERN ELEMENTS apply: validUntilTimestamp para commitment validity + replayConfidence para audit + emit-failed/emit-superseded distinction + interpretation contracts. NON-PATTERN ELEMENTS distinct (NÃO 'risk score' — CMT tem 'commitment terms'; NÃO 'eligibility' — CMT tem 'fulfillment status'; NÃO 'risk alert' — CMT tem 'commitment breach signal'). Generalization 'input vs decision rule independence' aplica diferentemente: pricing-model versioning ⊥ business-rule versioning."
			recommendation: "CMT Phase 3 application será o TEST DEFINITIVO se pattern is real OR coincidence. Founder revisita pos-aplicação: 'isso é padrão OR coincidência bem construída?'. Se confirmed pattern: promote lens.status='draft' → 'active'; possibly create #Pattern artifact type if ≥3 patterns emerge cross-BC."
			principlesApplied: ["P10"]
			assumptions: ["CMT Phase 3 ainda não iniciada (WI futuro)", "lens applied during Phase 3 of CMT bootstrap as consciously-applied analytical lens (not retroactive)"]
			rationale: "Hypothetical example documents pattern application protocol explicitly. Real validation virá com actual application."
		},
	]

	limitations: [
		{
			description: "Cross-entity correlation analysis (adversarial fraud patterns spanning multiple entities; distributed cheap-but-many attacks below per-entity threshold) é EXPLICITLY NOT covered by lens. replayScopeStrategy='by-entityRef' assumido — cross-entity inteligência requires bespoke runtime separate concern."
			alternative: "BCs aplicando lens delegam cross-entity detection a upstream BCs (NIM/DLV style) que publicam signals com pattern recognition done upstream. Future Phase N+1: dedicated correlation BC OR REW extension via correlationId-based replay strategy (separate ADR + data migration plan)."
			rationale:   "REW reference implementation declares this LIMITATION explicitly em replayScopeStrategy.rationale + inv-rew-undetectable-pattern-risk-declared. Pattern preserva same boundary."
		},
		{
			description: "Cross-BC consumer protocol compliance é GOVERNANCE Phase 3, NÃO runtime enforcement. Consumer pode violar protocolo silently (ignore status flag; bypass validity check; skip pre-commit recheck) — UNDETECTABLE em runtime; detectable apenas via post-hoc audit OR runtime attestation infrastructure."
			alternative: "BCs aplicando lens herdam LIMITATION declarada explicitly em decisionAuthorityModel.rationale + systemFailureModes. Override formal cross-BC requires explicit ADR. Phase N+1 quando ≥2 consumers override pattern emerge: trigger automation per def-016-style deferred decision OR equivalent."
			rationale:   "Founder Phase 3 ratified deferred-decision (def-016 cross-BC enforcement). Pattern aplica same governance approach: governance Phase 3; technical enforcement Phase N+1 quando empirical evidence justify heavy infra."
		},
		{
			description: "Operational calibration parameters ('taxa de juros do sistema') são NOT enforced by lens — Phase 3 declara field presence; runtime enforces. Calibração mal feita = sistema trava (curto demais) OR risco invisível (longo demais). Aplicável a: validityWindowSeconds + emitTimeoutSeconds + maxEmissionRatePerSecond + aclIngressRatePerSecond + aclValidationCostBudgetPerSignal/PerSecondMs (5+ parameters em REW reference)."
			alternative: "BCs aplicando lens calibram defaults Phase 0 em policy fields; Phase 1+ telemetry-driven calibration via policy version updates. Calibration revisits when production telemetry available. Future framework de calibration cross-BC (parameter sharing? cross-BC defaults?) emerges com multi-BC pattern application."
			rationale:   "Calibration é runtime concern, não pattern concern. Lens declara structural pattern; calibration é per-BC operational decision."
		},
	]

	rationale: "Lens captura PATTERN extraído de REW Phase 3 (WI-046) primeiro exemplar completo de decision-systems-with-truth-boundaries. 6 concepts agrupados (truth boundaries; temporal; semantic determinism; execution integrity; boundary integrity; honesty invariants) — framework mental, não checklist linear. 5 activation criteria + applicabilityTest critical (validUntilTimestamp removability test) separa applicability rigorously. 3 limitations declaradas explicitly (cross-entity; cross-BC runtime; calibration). Reference implementation REW (contexts/rew/). Validation real só com SECOND APPLICATION em outro BC (CMT/FCE/SCF/NIM Phase 3) — só aí pattern is confirmed vs coincidence. Status='draft' até second application valida; promote a 'active' quando pattern materially confirmed cross-BC."
}
