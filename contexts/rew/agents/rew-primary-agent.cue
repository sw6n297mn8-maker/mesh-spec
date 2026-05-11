package rew

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// rew-primary-agent.cue — Agent Spec: REW Primary Agent.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Phase 4 do WI-046 REW bootstrap. Materializa operator layer
// sobre os artefatos formais Phase 1-3.5a:
// canvas (governanceScope + BDs) + glossary (firewall semântico) +
// domain-model (4 aggregates + 46 invariants + 16 events + 10 commands +
// 2 projections + 2 modules + 2 policies) + structural-checks Phase 3.5a
// (architecture/structural-checks/rew-domain-model.cue: 15 sc-rew-*
// rules cobrindo Part 1 invariants per ADR-080).
//
// Conceito central founder framing:
//   agent é OPERADOR não ENFORCER. Domain enforce via aggregate
//   lifecycle + runner + structural-checks; agent requisita commands
//   sob supervisão (Phase 0 100% propose-and-wait).
//
// Phase 0 supervised-onboarding: 100% mutations propose-and-wait;
// promotion vive em governance envelope (Phase 5 forward-ref),
// não em spec. Caps + thresholds + channel routing + drift detection
// elaborados pelo envelope.
//
// Scope Section 1+2+3 (manualAuthoringProtocol per adr-057):
//   Section 1 (scope-and-action-catalog) — 10 actions 1:1 com commands;
//     todas mutation/propose-and-wait/trusted-internal exceto
//     act-request-risk-evaluation (external-structured post-ACL).
//   Section 2 (constraints-and-escalation) — 13 constraints (1:1
//     coverage do subset operacional 13/13 invariants) + 1 honesty ACK
//     ACL boundary; 5 escalationConditions canonical categories +
//     per-action override governance-critical-activation (4 governance
//     actions, semanticCategory preservada, technicalRoutingOnly
//     marker — NÃO routed via #EscalationCategory reuse).
//   Section 3 (context-observability-validation) — 4 contextRequirements
//     artifacts (canvas + domain-model + glossary + agent-governance
//     forward-ref); 9 observability signals consolidados; 19 audit
//     fields (7 minimum regulatory-grade + 12 REW-specific incluindo
//     semanticHash + replayVerificationStatus para cst-deterministic-
//     replay-auditable).
//
// 33 invariants fora do subset operacional do agent são enforced via
// aggregate lifecycle / runner / structural-checks Phase 3.5a sc-rew-*
// — agent OPERADOR não ENFORCER do domínio inteiro.
//
// Founder ajustes pre-write incorporados:
//   Section 1: (1) rename act-evaluate-risk → act-request-risk-evaluation;
//     (2) operationalScope.events restrito a produced (signal lifecycle
//     events evt-signal-* removidos — ACL ownership); (3) inputTrustLevel
//     external-structured com rationale endurecido (structure ≠ truth;
//     admissibility via ACL); (4) governance-critical activations via
//     per-action override próprio NÃO via reuse de #EscalationCategory.
//   Section 2: (1) cst-bounded-score-validated enforcementLevel domain +
//     runner (não agent — operador ≠ guardrail matemático); (2) cst-
//     deterministic-replay-auditable onViolation block-and-escalate
//     (não log-only — replay divergence NÃO é telemetria decorativa,
//     é DOMAIN-CORRUPTION); (3) governance-critical-activation com
//     semanticCategory preservada + technicalRoutingOnly marker
//     (anti-pattern conflicting-signals reuse rejeitado).
//   Section 3: (A) confidenceInterval rationale epistemológico explícito
//     (incerteza do modelo, NÃO precisão; anti-mini-CMT + anti-
//     confiability-as-trust); (B) assetIdentifier privacy-minimized
//     stable reference (LGPD minimização, não apenas respeito).
//
// Forward-refs Phase 5: governanceRef='rew-primary-agent' aponta para
// contexts/rew/agents/rew-primary-agent.governance.cue que elabora
// runtime enforcement layer (autonomy-overrides + escalation-routing
// channel/SLA/recipient para governance-critical-activation +
// drift-detection-metrics consumindo sig-rew-replay-divergence-detected
// e sig-rew-domain-corruption-detected + freeze-model thresholds).

agentSpec: artifact_schemas.#AgentSpec & {
	code:        "agt-rew-primary"
	name:        "REW Primary Agent"
	description: """
		Domain agent operador do BC REW (Risk Engine & Risk Observability).
		Opera evaluation lifecycle (request → compute → emit → supersede →
		stale), alert lifecycle (raise → acknowledge → resolve), e
		governance versioning (activate/deprecate model + policy).

		Phase 0 framing canonical: agent é OPERADOR não ENFORCER.
		Agent REQUISITA commands sob supervisão; compute + emit + lifecycle
		state transitions são determinístico do aggregate (sc-rew-* per
		Phase 3.5a + runner audit + domain lifecycle). Agent NÃO computa
		score, NÃO decide thresholds, NÃO valida bounds — requisita
		evaluation e o aggregate enforça invariants via lifecycle.

		Phase 0 supervised-onboarding: 100% mutations propose-and-wait.
		Promotion para execute-and-log vive em governance envelope
		(Phase 5 forward-ref), não em spec. Governance-critical actions
		(activate/deprecate model + policy) carregam per-action escalation
		override OBRIGATÓRIA pre-execução — ativação muda baseline
		sistêmico de risco, não decisão técnica routine.
		"""
	boundedContextRef: "rew"
	role:              "domain-agent"
	governanceRef:     "rew-primary-agent"

	operationalScope: {
		aggregates: [
			"agg-risk-evaluation",
			"agg-risk-alert",
			"agg-risk-model",
			"agg-risk-policy",
		]
		commands: [
			"cmd-request-risk-evaluation",
			"cmd-supersede-risk-evaluation",
			"cmd-mark-evaluation-stale",
			"cmd-raise-risk-alert",
			"cmd-acknowledge-risk-alert",
			"cmd-resolve-risk-alert",
			"cmd-activate-risk-model",
			"cmd-deprecate-risk-model",
			"cmd-activate-risk-policy",
			"cmd-deprecate-risk-policy",
		]
		// events APENAS produced pelo agent. evt-signal-* (received,
		// corruption-detected, rejected) NÃO incluídos — vivem na ACL
		// boundary, produced por ingestion adapter / validation
		// pipeline, observados/consumidos pelo agent context mas NÃO
		// produced. Honesty arquitetural: cst-acl-boundary-acknowledged
		// declara explicitamente este escopo.
		events: [
			"evt-risk-evaluation-computed",
			"evt-risk-evaluation-emitted",
			"evt-risk-evaluation-superseded",
			"evt-risk-evaluation-marked-stale",
			"evt-risk-evaluation-emit-failed",
			"evt-risk-evaluation-emit-superseded-by-newer",
			"evt-risk-alert-raised",
			"evt-risk-alert-acknowledged",
			"evt-risk-alert-resolved",
			"evt-risk-model-activated",
			"evt-risk-model-deprecated",
			"evt-risk-policy-activated",
			"evt-risk-policy-deprecated",
		]
		// invariants subset: 13 dos 46 — agent OPERADOR não ENFORCER
		// do domínio inteiro; 33 invariants restantes enforced via
		// aggregate lifecycle / runner / structural-checks Phase 3.5a.
		invariants: [
			"inv-rew-signal-traceability",
			"inv-rew-bounded-score",
			"inv-rew-deterministic-replay",
			"inv-rew-model-policy-separation",
			"inv-rew-alert-lifecycle",
			"inv-rew-model-version-binding",
			"inv-rew-version-frozen-at-request",
			"inv-rew-policy-version-immutability-per-evaluation",
			"inv-rew-command-idempotency",
			"inv-rew-explicit-supersede-only",
			"inv-rew-compute-emit-ordering",
			"inv-rew-supersede-after-emit-only",
			"inv-rew-signal-validation-before-ingestion",
		]
		projections: [
			"prj-active-risk-evaluations",
			"prj-active-risk-alerts",
		]
	}

	actions: [{
		code: "act-request-risk-evaluation"
		name: "Request risk evaluation"
		description: """
			Requisitar compute + emit de risk evaluation para asset/subject
			sob model + policy version frozen at request time. Agent NÃO
			computa risco diretamente — REQUISITA evaluation via
			cmd-request-risk-evaluation; compute + emit é fluxo
			determinístico do aggregate agg-risk-evaluation sob model +
			policy version frozen + signal payloads referenced.

			Input chega via ACL boundary já estruturado (signal payloads
			typed — vo-signal-payload-kyc/device/behavioral/fiscal), MAS
			estrutura ≠ verdade. Admissibilidade vem do ACL (inv-rew-
			signal-validation-before-ingestion enforced pre-ingestion);
			agent NÃO trata structure como semântica confiável.

			Agent ONLY binds input → command sob escalation discipline.
			Agent NÃO computa score, NÃO decide model/policy selection
			(activation vive em commands separados), NÃO calibra confidence
			interval — esses são responsabilidade do aggregate sob
			structural-checks Phase 3.5a.
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"cmd-request-risk-evaluation",
			"agg-risk-evaluation",
			"evt-risk-evaluation-computed",
			"evt-risk-evaluation-emitted",
			"evt-risk-evaluation-emit-failed",
			"inv-rew-signal-traceability",
			"inv-rew-bounded-score",
			"inv-rew-deterministic-replay",
			"inv-rew-version-frozen-at-request",
			"inv-rew-compute-emit-ordering",
			"prj-active-risk-evaluations",
		]
		preconditions: [
			"signal payloads passaram ACL validation (cst-acl-boundary-acknowledged)",
			"modelVersion ativa resolvida e frozen at request time",
			"policyVersion ativa resolvida e frozen at request time",
			"asset/subject identifier privacy-minimized resolvido",
		]
		postconditions: [
			"evt-risk-evaluation-computed emitido com bounded score + confidence interval",
			"evt-risk-evaluation-emitted emitido post-compute (compute-emit ordering preservada)",
			"semanticHash registrado em audit trail para replay verification",
			"sc-rew-08 bounded-score maintained (score dentro de bounds declarados pelo model)",
		]
	}, {
		code: "act-supersede-risk-evaluation"
		name: "Supersede risk evaluation (post-emit, explicit trigger)"
		description: """
			Substituir evaluation prévia por evaluation nova quando novo
			signal arrival OR re-execução determinística pós-replay
			divergence indica delta semântico. Agent requisita supersede
			via cmd-supersede-risk-evaluation; aggregate enforce ordering
			(supersede-after-emit-only) + explicit-trigger (inv-rew-
			explicit-supersede-only).

			Supersede só admissível post-emit (predecessor must be
			emitted state); pre-emit attempts caem em escalation
			out-of-scope. Trigger discipline é responsabilidade do
			aggregate via lifecycle.
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-supersede-risk-evaluation",
			"agg-risk-evaluation",
			"evt-risk-evaluation-superseded",
			"evt-risk-evaluation-emit-superseded-by-newer",
			"inv-rew-explicit-supersede-only",
			"inv-rew-supersede-after-emit-only",
		]
		preconditions: [
			"predecessor evaluation existe em projection prj-active-risk-evaluations",
			"predecessor evaluation status == emitted (não draft, não superseded, não stale)",
			"supersede trigger explícito (não automático sem trigger declarado)",
		]
		postconditions: [
			"evt-risk-evaluation-superseded emitido com link predecessor → successor",
			"successor evaluation criada com supersedeReason structured",
			"chain integrity preservada (sc-rew-04 chain-of-evaluation)",
		]
	}, {
		code: "act-mark-evaluation-stale"
		name: "Mark evaluation as stale (lifecycle transition)"
		description: """
			Marcar evaluation como não-acionável quando TTL expira OR
			signal freshness threshold cruzado OR model/policy
			deprecation arrives. Lifecycle transition declarativa — NÃO
			introduz nova decisão de risco; sinaliza que decisão prévia
			não é mais acionável.

			Consumers downstream filtram por status='stale' (read-side
			discipline). pol-mark-stale-on-relevant-signal pode disparar
			este command automaticamente; agent path mantém supervisão
			Phase 0.
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-mark-evaluation-stale",
			"agg-risk-evaluation",
			"evt-risk-evaluation-marked-stale",
		]
		preconditions: [
			"evaluation existe em projection",
			"evaluation status admite transição para stale (não já superseded)",
			"trigger declarado: TTL OR signal-freshness OR model-deprecation OR policy-deprecation",
		]
		postconditions: [
			"evt-risk-evaluation-marked-stale emitido",
			"evaluation lifecycle state == stale",
			"downstream consumers filtram via projection prj-active-risk-evaluations",
		]
	}, {
		code: "act-raise-risk-alert"
		name: "Raise risk alert (deterministic consequence)"
		description: """
			Levantar alert quando bounded score crossing threshold OR
			eligibility denied — consequência determinística da evaluation
			emitida pelo aggregate sob policy active. Agent NÃO julga
			severity adicional; thresholds são declarativos no policy.

			pol-emit-risk-alert-on-eligibility-denied dispara este
			command automaticamente em policy path; agent supervised
			path mantém Phase 0 review.
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-raise-risk-alert",
			"agg-risk-alert",
			"evt-risk-alert-raised",
			"inv-rew-alert-lifecycle",
		]
		preconditions: [
			"evaluation emitted referenced (alert binds 1:1 to evaluation)",
			"threshold OR eligibility-denial trigger declarado pelo policy",
			"alert deduplication enforced (sc-rew / inv-rew-alert-dedupe via aggregate)",
		]
		postconditions: [
			"evt-risk-alert-raised emitido",
			"alert lifecycle entry state == raised",
			"alertId bound to evaluationId (immutability sc-rew via aggregate)",
		]
	}, {
		code: "act-acknowledge-risk-alert"
		name: "Acknowledge risk alert"
		description: """
			Operator acknowledgment de alert raised — transição lifecycle
			raised → acknowledged. Action é operator-initiated; agent
			submete command sob propose-and-wait discipline.
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-acknowledge-risk-alert",
			"agg-risk-alert",
			"evt-risk-alert-acknowledged",
			"inv-rew-alert-lifecycle",
		]
		preconditions: [
			"alert existe em projection prj-active-risk-alerts",
			"alert status == raised (não já acknowledged, não resolved)",
		]
		postconditions: [
			"evt-risk-alert-acknowledged emitido",
			"alert lifecycle state == acknowledged",
			"acknowledgmentActorRef registrado em audit trail",
		]
	}, {
		code: "act-resolve-risk-alert"
		name: "Resolve risk alert (lifecycle closure)"
		description: """
			Resolver alert encerrando ciclo operacional do alerta, sem
			alterar retrospectivamente a evaluation que o originou.
			Decisão consciente de aceitação de risco residual;
			founder/operator approval obrigatório (mantido em
			propose-and-wait permanente, não promovível).
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-resolve-risk-alert",
			"agg-risk-alert",
			"evt-risk-alert-resolved",
			"inv-rew-alert-lifecycle",
		]
		preconditions: [
			"alert existe em projection prj-active-risk-alerts",
			"alert status ∈ {raised, acknowledged}",
			"resolution rationale declarada (não free-text vazio)",
		]
		postconditions: [
			"evt-risk-alert-resolved emitido",
			"alert lifecycle state == resolved",
			"resolutionActorRef + resolutionRationale registrados em audit trail",
		]
	}, {
		code: "act-activate-risk-model"
		name: "Activate risk model version (governance-critical)"
		description: """
			Ativar nova model version. GOVERNANCE-CRITICAL: ativação muda
			baseline sistêmico de risco — toda evaluation subsequente
			opera sob nova version. PER-ACTION ESCALATION OVERRIDE
			OBRIGATÓRIA (cst-governance-critical-actions-always-escalate):
			semanticCategory='governance-critical-activation' emitida
			PRE-execução, independent de anomalia. Channel + SLA +
			recipient materializados em governance envelope Phase 5
			(NÃO via reuse de #EscalationCategory enum — workaround
			conflicting-signals rejeitado por corromper diagnostic
			downstream).
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-activate-risk-model",
			"agg-risk-model",
			"evt-risk-model-activated",
			"inv-rew-model-policy-separation",
			"inv-rew-model-version-binding",
		]
		preconditions: [
			"model version exists em registry (não-ativada anteriormente)",
			"governance-authority-role approval ref registrada pre-command",
			"escalation event semanticCategory=governance-critical-activation emitido pre-execução",
		]
		postconditions: [
			"evt-risk-model-activated emitido",
			"model version status == active",
			"semanticHash registry atualizado para nova baseline",
		]
	}, {
		code: "act-deprecate-risk-model"
		name: "Deprecate risk model version (governance-critical)"
		description: """
			Depreciar model version ativa. GOVERNANCE-CRITICAL idem
			act-activate-risk-model: per-action escalation override
			OBRIGATÓRIA + governance-authority approval pre-execução.
			Evaluations sob model deprecated permanecem válidas
			retrospectivamente (audit); novas evaluations exigem
			model ativa.
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-deprecate-risk-model",
			"agg-risk-model",
			"evt-risk-model-deprecated",
			"inv-rew-model-version-binding",
		]
		preconditions: [
			"model version status == active",
			"successor model version ativada OR justificativa explícita declarada",
			"governance-authority-role approval ref + escalation event pre-execução",
		]
		postconditions: [
			"evt-risk-model-deprecated emitido",
			"model version status == deprecated",
			"new evaluation requests rejected for deprecated model",
		]
	}, {
		code: "act-activate-risk-policy"
		name: "Activate risk policy version (governance-critical)"
		description: """
			Ativar nova policy version (thresholds, eligibility rules).
			GOVERNANCE-CRITICAL idem activate-risk-model: per-action
			escalation override + governance approval + semantic baseline
			shift documentado.
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-activate-risk-policy",
			"agg-risk-policy",
			"evt-risk-policy-activated",
			"inv-rew-policy-version-immutability-per-evaluation",
		]
		preconditions: [
			"policy version exists em registry",
			"governance-authority-role approval ref + escalation event pre-execução",
		]
		postconditions: [
			"evt-risk-policy-activated emitido",
			"policy version status == active",
		]
	}, {
		code: "act-deprecate-risk-policy"
		name: "Deprecate risk policy version (governance-critical)"
		description: """
			Depreciar policy version ativa. GOVERNANCE-CRITICAL idem
			pares anteriores: per-action escalation override + governance
			approval pre-execução. Evaluations sob policy deprecated
			permanecem válidas (immutability per evaluation per
			inv-rew-policy-version-immutability).
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-deprecate-risk-policy",
			"agg-risk-policy",
			"evt-risk-policy-deprecated",
		]
		preconditions: [
			"policy version status == active",
			"governance-authority-role approval ref + escalation event pre-execução",
		]
		postconditions: [
			"evt-risk-policy-deprecated emitido",
			"policy version status == deprecated",
		]
	}]

	constraints: [{
		code: "cst-signal-trace-mandatory"
		name: "Signal traceability mandatory in evaluation"
		description: """
			Toda evaluation requested deve referenciar signal payloads
			explicitamente (signalSnapshotIds frozen at request time).
			Evaluation sem trace de signals é caixa-preta — viola
			contestabilidade regulatória + replay determinístico.
			"""
		verification: """
			[enforcementLevel: agent | derivedFromInvariant: inv-rew-signal-traceability]
			Agent valida pre-submit que cmd-request-risk-evaluation payload
			carrega signalSnapshotIds não-vazio + cada ID resolve a signal
			payload presente em ACL ingestion log. Runner valida post-emit
			que evt-risk-evaluation-emitted payload preserva signalSnapshotIds.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Signal traceability é precondição de explainability + replay
			determinístico + LGPD Art. 20 contestabilidade. Phase 0 agent
			valida estrutura; runner valida persistência post-emit (camadas
			complementares).
			"""
	}, {
		code: "cst-bounded-score-validated"
		name: "Bounded score validated by aggregate + runner"
		description: """
			Score computed deve respeitar bounds declarados pelo model
			version active. Agent NÃO valida bounds (operador ≠ guardrail
			matemático); aggregate enforce via lifecycle, runner audita
			post-emit via sc-rew-08 boundedness rule.
			"""
		verification: """
			[enforcementLevel: domain + runner | derivedFromInvariant: inv-rew-bounded-score]
			Aggregate agg-risk-evaluation rejeita compute outside bounds
			declarados pelo model.bounds (lifecycle enforcement). Runner
			audita cada evt-risk-evaluation-emitted via sc-rew-08
			(structural-check Phase 3.5a) verificando score ∈ model.bounds
			frozen at request time.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Founder ajuste Section 2: enforcement está em domain + runner,
			NÃO agent. Operador NÃO finge ser autoridade epistemológica
			matemática do domínio. Agent observa violation post-emit via
			sig-rew-domain-corruption-detected; aggregate é primary
			enforcer.
			"""
	}, {
		code: "cst-deterministic-replay-auditable"
		name: "Deterministic replay auditable with block-on-divergence"
		description: """
			Toda evaluation persistida com semanticHash permitindo replay
			com mesmas (modelVersion, policyVersion, signalSnapshotIds) e
			verificação de hash equivalence. Replay divergence é DOMAIN-
			CORRUPTION (decisão computada antes não é mais reproduzível) —
			block-and-escalate, NÃO log-only normalizando corrupção como
			telemetria passiva.
			"""
		verification: """
			[enforcementLevel: runner | derivedFromInvariant: inv-rew-deterministic-replay]
			Runner replay-audit periódico re-executa compute determinístico
			com inputs frozen + version frozen + signalSnapshotIds frozen,
			compara semanticHash(replay) vs semanticHash(stored). Divergence
			dispara sig-rew-replay-divergence-detected (critical) +
			block-and-escalate da evaluation afetada para founder review.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Founder ajuste Section 2: replay divergence NÃO é observabilidade
			cosmética; é guardrail real de LGPD Art. 20 contestabilidade +
			Bacen scrutiny + cross-BC explainability. log-only normalizaria
			'sabemos que não reproduz mas seguimos operando' — anti-pattern
			fatal em REW.
			"""
	}, {
		code: "cst-model-policy-separation"
		name: "Model and policy versioning separated by aggregate"
		description: """
			Model version e policy version são aggregates separados
			(agg-risk-model + agg-risk-policy) com lifecycle independente.
			Agent NÃO mistura model params com policy thresholds em
			payload — aggregate boundary impede.
			"""
		verification: """
			[enforcementLevel: domain | derivedFromInvariant: inv-rew-model-policy-separation]
			Aggregates agg-risk-model e agg-risk-policy têm comandos
			distintos (cmd-activate-risk-model vs cmd-activate-risk-policy);
			lifecycle separado. evt-risk-evaluation-* payload carrega
			modelVersion + policyVersion como refs distintos. Runner
			audita ausência de cross-mixing post-emit.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Separação model/policy permite versionamento independente
			(model = compute logic; policy = thresholds + eligibility
			rules). Aggregate boundary é primary enforcer; agent observa.
			"""
	}, {
		code: "cst-alert-lifecycle-respected"
		name: "Alert lifecycle state machine enforced by aggregate"
		description: """
			Alert transitions raised → acknowledged → resolved são
			lifecycle do agg-risk-alert. Agent submete commands; aggregate
			rejeita transições inválidas (e.g., resolved → raised).
			"""
		verification: """
			[enforcementLevel: domain | derivedFromInvariant: inv-rew-alert-lifecycle]
			Aggregate agg-risk-alert rejeita commands cuja transição
			from→to não respeita state machine declarada. Runner audita
			ordering de eventos via prj-active-risk-alerts.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Lifecycle state machine é responsabilidade do aggregate (DDD
			discipline). Agent submete commands sob propose-and-wait;
			aggregate enforce.
			"""
	}, {
		code: "cst-model-version-binding-explicit"
		name: "Model version binding explicit in evaluation payload"
		description: """
			Toda evaluation carrega modelVersion ref explícita no payload
			(não inferida, não default). Agent valida pre-submit;
			runner audita post-emit.
			"""
		verification: """
			[enforcementLevel: agent + runner | derivedFromInvariant: inv-rew-model-version-binding]
			Agent valida pre-submit que cmd-request-risk-evaluation
			payload contém modelVersion explícito. Runner audita
			evt-risk-evaluation-emitted via sc-rew (Phase 3.5a) verificando
			modelVersion preservado.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Binding explícito previne ambiguidade sobre qual model
			computou — precondição de replay determinístico + audit
			forensics.
			"""
	}, {
		code: "cst-version-frozen-at-request"
		name: "Model + policy versions frozen at request time"
		description: """
			modelVersion e policyVersion são FROZEN no momento do
			cmd-request-risk-evaluation; ativação/depreciação subsequente
			NÃO afeta evaluations já requested. Agent freezes pre-submit;
			aggregate enforce immutability post-write.
			"""
		verification: """
			[enforcementLevel: agent + domain | derivedFromInvariant: inv-rew-version-frozen-at-request]
			Agent resolve modelVersion + policyVersion active no momento
			do cmd build, freezes em payload. Aggregate rejeita mutation
			subsequente desses fields. Runner audita post-emit.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Freezing version at request time é precondição de
			determinismo: replay com mesmas versions produz mesmo
			resultado independente de ativações posteriores.
			"""
	}, {
		code: "cst-policy-version-immutability-per-evaluation"
		name: "Policy version immutable per evaluation (lifecycle)"
		description: """
			policyVersion frozen at request NÃO pode ser alterada na
			lifecycle de uma evaluation (incluindo supersede chain — cada
			elo carrega sua própria policyVersion). Aggregate enforce.
			"""
		verification: """
			[enforcementLevel: domain | derivedFromInvariant: inv-rew-policy-version-immutability-per-evaluation]
			Aggregate agg-risk-evaluation rejeita mutation de policyVersion
			em events post-emit. Runner audita supersede chain (sc-rew)
			verificando cada elo carrega policyVersion individual.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Immutability per evaluation permite contestabilidade
			retrospectiva: 'sob qual policy você decidiu meu caso?' tem
			resposta canônica per evaluation.
			"""
	}, {
		code: "cst-command-idempotency"
		name: "Command idempotency enforced by runner"
		description: """
			Commands replayed (mesmo commandId, mesmo payload) NÃO
			produzem efeitos colaterais duplicados. Runner enforce via
			command-id deduplication + transactional boundary.
			"""
		verification: """
			[enforcementLevel: runner | derivedFromInvariant: inv-rew-command-idempotency]
			Runner mantém log de commandIds processados; replay com
			mesmo commandId returns cached outcome (rollback
			intermediário se executado parcialmente).
			"""
		onViolation: "rollback-and-escalate"
		rationale: """
			Idempotency precondição de retry-safe operations + replay
			discipline. rollback-and-escalate cobre case de execução
			parcial detectada (não block-and-escalate porque parcial
			já mutou estado — precisa reverter).
			"""
	}, {
		code: "cst-supersede-explicit-only"
		name: "Supersede only on explicit trigger"
		description: """
			Supersede NÃO acontece automaticamente sem trigger declarado
			(e.g., novo signal, replay divergence, governance recalibration).
			Agent rejeita supersede commands sem trigger explícito.
			"""
		verification: """
			[enforcementLevel: agent | derivedFromInvariant: inv-rew-explicit-supersede-only]
			Agent valida pre-submit que cmd-supersede-risk-evaluation
			payload contém supersedeReason structured (enum válido +
			triggerRef). Runner audita post-emit.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Supersede sem trigger explícito vira ruído auditável (chain
			cresce sem semantic delta) + perde diagnostic clarity.
			Discipline é primary enforcement do agent (boundary
			behavior).
			"""
	}, {
		code: "cst-compute-emit-ordering"
		name: "Compute precedes emit (ordering enforcement)"
		description: """
			evt-risk-evaluation-computed precede evt-risk-evaluation-emitted
			no event log da evaluation. Aggregate enforce ordering;
			runner audita.
			"""
		verification: """
			[enforcementLevel: agent + runner | derivedFromInvariant: inv-rew-compute-emit-ordering]
			Agent submete cmd-request-risk-evaluation que dispara compute
			pelo aggregate; emit é step subsequente do mesmo workflow.
			Runner audita event log ordering pelo evaluationId.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Ordering compute → emit é parte do contrato determinístico:
			emit sem compute é ghost event; compute sem emit é decisão
			não-publicada (viola downstream contract).
			"""
	}, {
		code: "cst-supersede-after-emit-only"
		name: "Supersede only post-emit (lifecycle gate)"
		description: """
			Supersede só admissível quando predecessor evaluation está em
			emitted state (não draft, não computed-but-not-emitted).
			Aggregate enforce via lifecycle.
			"""
		verification: """
			[enforcementLevel: domain | derivedFromInvariant: inv-rew-supersede-after-emit-only]
			Aggregate agg-risk-evaluation rejeita cmd-supersede-risk-
			evaluation se predecessor.status != emitted. Runner audita.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Supersede pre-emit cria chain inválida (substituir algo que
			ainda não foi publicado). Aggregate boundary impede.
			"""
	}, {
		code: "cst-governance-critical-actions-always-escalate"
		name: "Governance-critical actions always escalate pre-execution"
		description: """
			act-activate-risk-model + act-deprecate-risk-model +
			act-activate-risk-policy + act-deprecate-risk-policy emitem
			escalation event semanticCategory='governance-critical-
			activation' PRE-execução, INDEPENDENT de anomalia. Per-action
			override OBRIGATÓRIA — ativação muda baseline sistêmico.

			semanticCategory preservada (NÃO routed via reuse de
			#EscalationCategory enum); technicalRoutingOnly marker em
			rationale; channel + SLA + recipient materializados em
			governance envelope Phase 5 escalation-routing block.

			Anti-pattern rejected: routing via 'conflicting-signals' OR
			outras categories existentes — semantic mismatch corrompe
			diagnostic clarity downstream.
			"""
		verification: """
			[enforcementLevel: agent + runner | derivedFromInvariant: per-action-override-discipline (Section 2 founder ajuste)]
			[appliesToActions: act-activate-risk-model, act-deprecate-risk-model, act-activate-risk-policy, act-deprecate-risk-policy]
			[semanticCategory: governance-critical-activation]
			[technicalRoutingOnly: schema #EscalationCategory enum não modela
			 governance-critical-activation como first-class; routing via
			 envelope governance Phase 5 dedicated channel — NÃO via reuse
			 semântico]
			Runner valida que toda execução das 4 actions emite escalation
			event com semanticCategory='governance-critical-activation' +
			founderApprovalRef pre-cmd execution. Sem escalation event +
			approval ref → action blocked.
			"""
		onViolation: "block-and-escalate"
		rationale: """
			Founder ajuste Section 2: governance-critical activations
			(model/policy lifecycle) NÃO são decisões técnicas routine;
			alteram baseline sistêmico de risco. Escalation OBRIGATÓRIA
			pre-execução força founder/governance-authority approval
			visible. semanticCategory preservada evita drift diagnóstico
			downstream (anti-pattern conflicting-signals reuse rejeitado
			explicitamente). Spec declara discipline + semanticCategory;
			envelope materializa channel + SLA + recipient.
			"""
	}, {
		code: "cst-acl-boundary-acknowledged"
		name: "ACL boundary signal validation acknowledged (NOT enforced by agent)"
		description: """
			[KIND: declarative-acknowledgment / category: system-boundary-assumption]

			ACKNOWLEDGED LIMIT: signal validation, corruption detection,
			signal rejection vivem na ACL boundary (ingestion adapter +
			validation pipeline), NÃO no agent. Eventos evt-signal-
			received, evt-signal-corruption-detected, evt-signal-rejected
			são produced por ACL — observed/consumed pelo agent context
			MAS NÃO produced.

			Agent declara expectation: signal payloads que chegam ao
			cmd-request-risk-evaluation passaram inv-rew-signal-validation-
			before-ingestion enforced pre-ingestion pelo ACL. Agent NÃO
			re-valida (would duplicate ACL discipline) e NÃO trata
			structure como semantic truth.

			Honesty arquitetural: spec declara escopo real de enforcement
			(agent supervises operational lifecycle; ACL supervises
			boundary discipline). Phase 1+ promotion para mecanismos
			estruturais (ACL signal contract structural-check) deferred.
			"""
		verification: """
			[enforcementLevel: external (ACL) | derivedFromInvariant: inv-rew-signal-validation-before-ingestion]
			[KIND: declarative-acknowledgment]
			riskLevel: medium
			scope: ACL ingestion adapter + validation pipeline
			acknowledgedAssumption:
			  id: signal-validation-pre-ingestion
			  type: ACL-validation-enforced-pre-cmd-arrival
			  scope: ingestion adapter + validation pipeline
			  attack-vectors-residual: [ACL-bypass-via-direct-aggregate-write, signal-corruption-undetected-by-ACL-pattern-rules]
			  ideal-mitigation: ACL signal contract structural-check (Phase 1+)
			requiredChecks:
			- type: declarative-acknowledgment
			  target: signal-validation-pre-ingestion
			  expected: documented-in-rationale
			  enforcementLevel: advisory
			"""
		onViolation: "log-only"
		rationale: """
			Honesty arquitetural pattern (paralelo a INV cst-system-
			boundary-acknowledged R2 review): agent declara escopo real
			NÃO finge cobertura completa. ACL é primary enforcer de
			signal validation; agent observa via ACL output. Phase 1+
			promotion possível (ACL signal contract structural-check).
			"""
	}]

	escalationConditions: [{
		category: "insufficient-context"
		description: """
			Folded scenarios:

			(A) act-request-risk-evaluation: signal payload incompleto,
			projection prj-active-risk-evaluations unavailable, modelVersion
			OR policyVersion ativa unresolvable.

			(B) act-supersede-risk-evaluation: predecessor evaluation
			não encontrada em projection (eventual consistency lag OR
			não emitted ainda).

			(C) act-mark-evaluation-stale: evaluation referenced
			não encontrada em projection.

			(D) act-acknowledge-risk-alert / act-resolve-risk-alert:
			alert referenced não encontrado em projection.

			DECISION local: ABORT_ACTION (action does not execute).
			ESCALATION systemic: DEFERRED — propose-and-wait com
			structured failureReason classified; threshold-based
			escalation pode disparar Phase 1+ via envelope governance
			se condition persists.
			"""
		rationale: """
			Guard failure NÃO é decisão a escalar imediatamente — é
			estado a aguardar (eventual consistency comum em
			distributed system). Local ABORT_ACTION distinto de
			DEFERRED systemic ESCALATION preserva replay independence.
			Padrão DLV/INV precedent (folded scenarios via OR per
			category).
			"""
	}, {
		category: "conflicting-signals"
		description: """
			Folded scenarios:

			(A) act-request-risk-evaluation: signal sources contradictórios
			detected post-ACL (e.g., KYC tier vs device behavioral tier
			divergem materialmente sem reconciliação). Sub-classifications
			VERIFIED → HARD vs UNCERTAIN → SOFT (paralelo a INV R2-3
			distinction).

			(B) act-raise-risk-alert: alert state vs evaluation state
			inconsistentes (e.g., alert raised para evaluation já
			superseded).

			DECISION local: ABORT_ACTION.
			ESCALATION systemic: HARD se VERIFIED contradiction
			(DOMAIN-INCONSISTENCY); SOFT retry-eligible se VERIFICATION-
			UNCERTAIN.
			"""
		rationale: """
			Sinais contraditórios pre-cmd indicam OR drift de fonte
			OR fraude OR pattern emergente — todas exigem founder
			visibility. Distinção VERIFIED vs UNCERTAIN previne falso
			negativo operacional + escalation overhead.
			"""
	}, {
		category: "suspicious-input"
		description: """
			Folded scenarios:

			(A) act-request-risk-evaluation: signal payload com pattern
			anomalous post-ACL — ACL passou estrutura mas pattern detection
			downstream (replay analysis, statistical anomaly) sinaliza
			candidato a corruption.

			Sub-classifications:
			- VERIFIED-CORRUPTION: pattern confirmed by cross-source
			  reconciliation OR explicit fraud signal arrived.
			- VERIFICATION-UNCERTAIN: pattern flagged mas not confirmed
			  (precision tradeoff).

			DECISION local: ABORT_ACTION.
			ESCALATION systemic: HARD se VERIFIED; SOFT retry-eligible
			se UNCERTAIN.
			"""
		rationale: """
			Suspicious-input post-ACL é caso onde ACL boundary discipline
			NÃO foi suficiente — agent observa downstream signal via
			pattern detection. Sub-classification distinct previne falso
			negativo (timeout / glitch ≠ structural corruption).
			"""
	}, {
		category: "out-of-scope"
		description: """
			Folded scenarios:

			(A) act-supersede-risk-evaluation: tentativa de supersede
			pre-emit (cst-supersede-after-emit-only OR
			inv-rew-supersede-after-emit-only violado).

			(B) act-mark-evaluation-stale: tentativa de mark-stale
			em evaluation já em terminal state (superseded, OR já stale).

			(C) act-acknowledge-risk-alert / act-resolve-risk-alert:
			tentativa de transição lifecycle inválida from terminal
			state (resolved → acknowledged OR resolved → raised) —
			transições from terminal state proibidas.

			DECISION local: ABORT_ACTION (structural gate boundary).
			ESCALATION systemic: SOFT (typically replay legítimo OR
			race condition operacional); HARD apenas em pattern
			adversarial sustained.
			"""
		rationale: """
			Out-of-scope tipicamente reflete eventual consistency lag
			OR retry pattern legítimo. SOFT é default; HARD escalation
			só em pattern adversarial (Phase 1+ envelope threshold).
			"""
	}, {
		category: "unclassifiable-anomaly"
		description: """
			Post-execution scenario: invariant violation detectada apesar
			de gates passing pre-emit. Examples:
			- score outside bounded range (sc-rew-08 violation post-emit)
			- semanticHash divergence em replay (cst-deterministic-replay-
			  auditable trigger)
			- alert raised sem evaluation referenced (cardinality breach)
			- supersede chain cycle detected
			- modelVersion mutation post-emit (immutability breach)

			DECISION local: HALT_AGENT (agent-wide stop, NÃO action-
			specific) — DOMAIN-CORRUPTION classification.
			ESCALATION systemic: HARD imediato; founder review +
			audit reconciliation mandatory; agent não pode 'corrigir'
			domain corruption (fora do envelope de autonomy).
			"""
		rationale: """
			Distinção crítica: HALT_AGENT (agent-wide) ≠ ABORT_ACTION
			(action-specific). Domain corruption afeta agent confidence
			inteira — não apenas a action atual. Pattern paralelo a
			INV unclassifiable-anomaly. Single recovery path Phase 0:
			founder + audit trail.
			"""
	}]

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale: """
				Canvas REW materializa governanceScope (autonomousDecisions
				vs supervisedDecisions classification per ADR-037) +
				ownership.domainAgentSpec (binding agent ↔ canvas via
				tq-ag-03) + escalationCriteria (founder routing thresholds)
				+ BDs (boundary decisions anti-mini-CMT/SSC/DLV) — todas
				referências de actions, constraints e escalation.
				"""
			requiredSlices: [
				"governanceScope",
				"escalationCriteria",
				"boundaryDecisions",
				"ownership",
			]
		}, {
			artifactType: "domain-model"
			rationale: """
				Domain-model materializa 4 aggregates + 46 invariants + 16
				events + 10 commands + 17 VOs + 2 modules + 2 policies +
				2 projections — todas referências de actions[].domainModelRefs
				+ constraints[].derivedFromInvariant + postconditions.
				33 invariants fora do subset operacional do agent são
				enforced via aggregate lifecycle / runner / structural-
				checks Phase 3.5a sc-rew-01..15 (architecture/structural-
				checks/rew-domain-model.cue per ADR-080) — agent OPERADOR
				não ENFORCER do domínio inteiro; contexto para boundary
				clarity, NÃO para re-enforcement.
				"""
		}, {
			artifactType: "glossary"
			rationale: """
				Ubiquitous Language REW (incluindo antiTerms anti-mini-CMT
				score, anti-mini-SSC eligibility, anti-confiability-as-
				trust) é vocabulário canonical; agent uses para naming
				de actions + signals + boundary clarity. Firewall semântico
				previne drift terminológico cross-BC (bounded score ≠
				credit score; risk evaluation ≠ eligibility decision).
				"""
		}, {
			artifactType: "agent-governance"
			rationale: """
				Governance envelope (Phase 5 forward-ref —
				contexts/rew/agents/rew-primary-agent.governance.cue)
				declara COMO escalar (canal + SLA + destinatário per
				ADR-037 two-level governance), autonomy calibration
				overrides (promotion paths post-onboarding), e channel
				routing para governance-critical-activation per-action
				override (cst-13 — semanticCategory preservada; routing
				técnico materializado em envelope NÃO via reuse de
				#EscalationCategory enum). Envelope materializa drift-
				detection-metrics consumindo sig-rew-replay-divergence-
				detected + sig-rew-domain-corruption-detected + freeze-
				model thresholds. Agent-spec declara QUANDO + discipline;
				envelope declara COMO.
				"""
		}]
		estimatedBudget: "heavy"
	}

	observability: {
		signals: [{
			code: "sig-rew-evaluation-emitted"
			name: "Risk evaluation emitted (compute + emit success)"
			description: """
				Emitido após evt-risk-evaluation-emitted acked pelo broker.
				Indica ciclo completo da action act-request-risk-evaluation
				(compute determinístico + bounded score + confidence
				interval + emit atomic).
				"""
			coversCategory: "mutation"
			trigger:        "Post-emit success: evt-risk-evaluation-emitted acked + ordering compute→emit preservada."
			level:          "info"
			payloadFields: [
				"timestamp",
				"evaluationId",
				"assetIdentifier",
				"modelVersion",
				"policyVersion",
				"boundedScore",
				"signalSnapshotIds",
			]
		}, {
			code: "sig-rew-evaluation-emit-failed"
			name: "Risk evaluation emit failed"
			description: """
				Emitido quando evt-risk-evaluation-emit-failed dispatched
				(transactional outbox falhou OR cardinality breach pre-emit).
				Distingue replay-eligible failures de domain-corruption
				(latter dispara sig-rew-domain-corruption-detected).
				"""
			coversCategory: "mutation"
			trigger:        "Emit failure: evt-risk-evaluation-emit-failed dispatched OR pre-emit gate blocked atomic emission."
			level:          "error"
			payloadFields: [
				"timestamp",
				"evaluationId",
				"failureReason",
				"retryEligibility",
				"modelVersion",
				"policyVersion",
			]
		}, {
			code: "sig-rew-evaluation-superseded"
			name: "Risk evaluation superseded"
			description: """
				Emitido após evt-risk-evaluation-superseded acked. Indica
				ciclo completo de act-supersede-risk-evaluation com
				explicit trigger (sc-rew chain integrity preservada).
				"""
			coversCategory: "mutation"
			trigger:        "Post-emit success: evt-risk-evaluation-superseded acked; chain predecessor → successor estabelecida."
			level:          "info"
			payloadFields: [
				"timestamp",
				"predecessorEvaluationId",
				"successorEvaluationId",
				"supersedeReason",
			]
		}, {
			code: "sig-rew-evaluation-marked-stale"
			name: "Risk evaluation marked stale"
			description: """
				Emitido após evt-risk-evaluation-marked-stale acked.
				Lifecycle transition declarativa para non-actionable
				state — consumers downstream filtram via projection.
				"""
			coversCategory: "mutation"
			trigger:        "Post-emit success: evt-risk-evaluation-marked-stale acked."
			level:          "info"
			payloadFields: [
				"timestamp",
				"evaluationId",
				"staleTrigger",
				"staleReason",
			]
		}, {
			code: "sig-rew-alert-raised"
			name: "Risk alert raised"
			description: """
				Emitido após evt-risk-alert-raised acked. Indica alert
				lifecycle entry (threshold crossed OR eligibility denied
				per policy active).
				"""
			coversCategory: "mutation"
			trigger:        "Post-emit success: evt-risk-alert-raised acked; alert bound 1:1 to evaluationId."
			level:          "warn"
			payloadFields: [
				"timestamp",
				"alertId",
				"evaluationId",
				"alertSeverity",
				"alertCondition",
			]
		}, {
			code: "sig-rew-alert-lifecycle-transition"
			name: "Risk alert lifecycle transition (ack OR resolve)"
			description: """
				Emitido após evt-risk-alert-acknowledged OR evt-risk-alert-
				resolved acked. Consolida transições non-entry lifecycle
				(raised entry coberta por sig-rew-alert-raised) em signal
				único — diagnostic clarity via transitionFrom/transitionTo
				fields no payload.
				"""
			coversCategory: "mutation"
			trigger:        "Post-emit success: evt-risk-alert-acknowledged OR evt-risk-alert-resolved acked."
			level:          "info"
			payloadFields: [
				"timestamp",
				"alertId",
				"transitionFrom",
				"transitionTo",
				"actorRef",
			]
		}, {
			code: "sig-rew-governance-version-changed"
			name: "Governance-critical version changed (model OR policy activate/deprecate)"
			description: """
				Emitido após evt-risk-model-activated OR evt-risk-model-
				deprecated OR evt-risk-policy-activated OR evt-risk-policy-
				deprecated acked. Consolida 4 governance-critical actions
				em signal único — semanticCategory='governance-critical-
				activation' preservada no payload (paralelo a cst-13
				per-action override discipline). Drift detection metrics
				(envelope governance Phase 5) consomem este signal como
				signal-as-contract per ADR-075.
				"""
			coversCategory: "mutation"
			trigger:        "Post-emit success: evt-risk-{model,policy}-{activated,deprecated} acked + escalation event pre-execução acked."
			level:          "warn"
			payloadFields: [
				"timestamp",
				"versionKind",
				"versionRef",
				"transitionType",
				"semanticCategory",
				"founderApprovalRef",
			]
		}, {
			code: "sig-rew-replay-divergence-detected"
			name: "Replay divergence detected (cst-deterministic-replay-auditable trigger)"
			description: """
				Emitido quando runner replay-audit detecta semanticHash
				divergence entre stored vs replay com mesmas (modelVersion,
				policyVersion, signalSnapshotIds). DOMAIN-CORRUPTION
				classification — dispara block-and-escalate da evaluation
				afetada per cst-3 (founder ajuste Section 2: NÃO
				log-only normalizando corrupção).
				"""
			coversCategory: "mutation"
			trigger:        "Runner replay-audit: semanticHash(stored) != semanticHash(replay) com inputs + versions frozen idênticos."
			level:          "critical"
			payloadFields: [
				"timestamp",
				"evaluationId",
				"storedSemanticHash",
				"replaySemanticHash",
				"modelVersion",
				"policyVersion",
				"replayTimestamp",
			]
		}, {
			code: "sig-rew-domain-corruption-detected"
			name: "Domain corruption detected post-emit (HALT_AGENT trigger)"
			description: """
				Emitido quando audit post-emit detecta invariant violation
				apesar de gates passing pre-emit. Examples: score outside
				bounded range, cardinality breach (alert sem evaluation),
				supersede chain cycle, modelVersion mutation post-emit.
				Dispara HALT_AGENT per escalationCondition unclassifiable-
				anomaly.
				"""
			coversCategory: "mutation"
			trigger:        "Post-emit audit: sc-rew-* OR runner detecta invariant violation despite pre-emit gates passing."
			level:          "critical"
			payloadFields: [
				"timestamp",
				"invariantRef",
				"violationDescription",
				"affectedEvaluationId",
				"auditTimestamp",
			]
		}]

		auditTrail: {
			requiredFields: [
				// _minimumAuditFields (regulatory-grade per tq-ag-13)
				"timestamp",
				"agent-id",
				"action-code",
				"input-summary",
				"output-summary",
				"decision-rationale",
				"governance-version",
				// REW-core: entity refs + version freeze + decision content
				"evaluationId",
				"assetIdentifier",
				"signalSnapshotIds",
				"modelVersion",
				"policyVersion",
				"boundedScore",
				"confidenceInterval",
				// Lifecycle-specific: chain + transition traceability
				"predecessorEvaluationId",
				"supersedeReason",
				"alertId",
				// Replay forensics (cst-deterministic-replay-auditable support)
				"semanticHash",
				"replayVerificationStatus",
			]
			storageHint: """
				Risk-grade audit log: LGPD Art. 20 contestabilidade requer
				rastreabilidade decision + inputs + version-frozen +
				bounds + replay-hash; Bacen scrutiny para decisões
				automatizadas que afetam acesso a crédito/conta; cross-BC
				explainability para CMT/SSC consumers downstream.
				Retention legal ≥5 anos per LGPD/Bacen baseline;
				jurisdictional equivalents Phase 1+. Replay verification
				status mandatory — semanticHash permite reconstrução
				causal sob mesmas (modelVersion, policyVersion,
				signalSnapshotIds). Detalhes de implementação vivem no
				Architecture Communication Canvas.
				"""
			rationale: """
				19 fields total (7 minimum + 12 REW-specific). Coverage
				tq-ag-13 + tq-agg-04 satisfeita. Decomposição:
				7 REW-core + 3 lifecycle + 2 replay forensics = 12 REW-specific.

				**Field semantics canônica**:

				- 7 minimum: regulatory-grade base per ADR/lens-regulatory-
				  compliance-as-architecture.

				- 7 REW-core (entity refs + version freeze + decision
				  content):
				  - evaluationId: primary entity ref para chain forensics.
				  - assetIdentifier (ajuste B Section 3): privacy-minimized
				    stable reference — LGPD minimização (não duplicação de
				    PII desnecessária); permite auditability + replay sem
				    replicar dados sensíveis no audit log. Desacoplamento
				    de PII é precondição de retention legal ≥5 anos sob
				    LGPD principles of purpose limitation, necessity/
				    minimization and transparency.
				  - signalSnapshotIds: refs frozen at request time para
				    replay determinístico.
				  - modelVersion + policyVersion: version freeze
				    (immutability per evaluation) para contestabilidade
				    retrospectiva.
				  - boundedScore: decision content principal.
				  - confidenceInterval (ajuste A Section 3): incerteza
				    epistemológica do modelo declarada explicitamente.
				    Score sem intervalo induz falsa precisão downstream —
				    consumers tratam output probabilístico como verdade
				    binária. Anti-mini-CMT (score ≠ certeza) + anti-
				    confiability-as-trust (output ≠ verdade) preservados
				    via interval mandatory. Reificação do modelo
				    (treating model output as ground truth) é anti-pattern
				    crítico em risk decision systems.

				- 3 lifecycle: predecessorEvaluationId + supersedeReason +
				  alertId — chain + transition traceability completa
				  (supersede chain auditável + alert binding 1:1
				  evaluation).

				- 2 replay forensics: semanticHash + replayVerificationStatus
				  (last-replay-outcome ∈ {verified, divergent, pending,
				  not-applicable}) — suportam cst-3 cst-deterministic-
				  replay-auditable verification. Replay divergence NÃO é
				  evento auditável passivo; é bloqueante (founder ajuste
				  Section 2). Status field permite consumers downstream
				  + envelope governance Phase 5 drift-detection-metrics
				  determinar quando evaluations são confiáveis.

				**Audit trail 'reconstrutível'** satisfeito: dado o registro
				persistido, reconstrói (a) inputs (signals frozen + versions
				frozen + asset reference); (b) decisão (score + interval
				+ classification implícita); (c) cadeia (predecessor +
				supersede + alert); (d) verifiability (semanticHash replay
				status).
				"""
		}
	}

	rationale: """
		Phase 4 do WI-046 REW bootstrap. Materializa operator layer sobre
		Phase 1-3.5a artifacts (canvas + glossary + domain-model +
		structural-checks Phase 3.5a sc-rew-01..15).

		**Conceito central**: agent é OPERADOR não ENFORCER. Domain
		enforce via aggregate lifecycle + runner audit + structural-
		checks Phase 3.5a; agent requisita commands sob supervisão
		(Phase 0 100% propose-and-wait). Operador ≠ autoridade
		epistemológica matemática do domínio.

		**Phase 0 supervised-onboarding**: 100% mutations propose-and-wait.
		Promotion para execute-and-log vive em governance envelope
		(Phase 5 forward-ref), NÃO em spec. Caps + thresholds + channel
		routing + drift detection elaborados pelo envelope.

		**Subset operacional declarado**: 13 invariants (do subset que o
		agent toca operacionalmente) coberto 1:1 por constraints
		(cst-1..12 + cst-14 honesty ACK). 33 invariants restantes do
		domain-model (46 total) são enforced via aggregate lifecycle /
		runner / structural-checks Phase 3.5a — agent NÃO finge ownership
		do domínio inteiro. Honesty arquitetural: spec declara escopo
		real de enforcement.

		**Founder ajustes pre-write incorporados**:

		Section 1 (4 ajustes):
		- (1) rename act-evaluate-risk → act-request-risk-evaluation
		  (agent REQUISITA, NÃO computa);
		- (2) operationalScope.events restrito a produced pelo agent
		  (evt-signal-* removidos — ACL ownership; observed/consumed
		  via context, não emitted);
		- (3) inputTrustLevel external-structured com rationale
		  endurecido (structure ≠ truth; admissibility via ACL pre-
		  ingestion; agent NÃO trata structure como semantic truth);
		- (4) governance-critical activations (4 actions model+policy
		  activate/deprecate) via per-action escalation override próprio
		  — semanticCategory='governance-critical-activation' preservada;
		  routing técnico via envelope Phase 5 dedicated channel.

		Section 2 (3 ajustes):
		- (1) cst-bounded-score-validated enforcementLevel domain +
		  runner (NÃO agent — operador ≠ guardrail matemático);
		- (2) cst-deterministic-replay-auditable onViolation block-and-
		  escalate (NÃO log-only — replay divergence é DOMAIN-CORRUPTION,
		  não telemetria decorativa; LGPD Art. 20 contestabilidade +
		  Bacen scrutiny);
		- (3) governance-critical-activation com semanticCategory
		  preservada + technicalRoutingOnly marker em verification —
		  anti-pattern routing via conflicting-signals reuse rejeitado
		  explicitamente (corromperia diagnostic clarity downstream).

		Section 3 (2 ajustes não-bloqueantes):
		- (A) confidenceInterval rationale epistemológico explícito —
		  incerteza do modelo declarada (anti-mini-CMT + anti-
		  confiability-as-trust; score sem interval induz falsa precisão
		  downstream);
		- (B) assetIdentifier privacy-minimized stable reference —
		  LGPD principles of purpose limitation, necessity/minimization
		  and transparency; desacoplamento de PII precondição de
		  retention legal ≥5 anos sem replicação de dados sensíveis.

		**Replay determinístico como guardrail real**: cst-3 block-and-
		escalate + semanticHash + replayVerificationStatus em audit
		trail + sig-rew-replay-divergence-detected (critical level)
		transformam replay de capacidade futura em parte do contrato
		operacional. Anti-pattern 'sabemos que não reproduz mas seguimos
		operando' estructuralmente bloqueado.

		**Honesty arquitetural patterns**:
		- cst-14 (acl-boundary-acknowledged) — signal validation vive
		  na ACL boundary, NÃO no agent; spec declara escopo real
		  de enforcement.
		- cst-13 (governance-critical-actions-always-escalate) —
		  separação semanticCategory vs technicalRoutingOnly evita
		  corrupção semântica de #EscalationCategory taxonomy.
		- Subset operacional 13/46 invariants — agent OPERADOR não
		  ENFORCER do domínio inteiro.
		- estimatedBudget heavy — honestidade operacional sobre custo
		  cognitivo + tamanho do domínio + necessidade de slices.

		**Forward-refs Phase 5**: governanceRef='rew-primary-agent'
		aponta para contexts/rew/agents/rew-primary-agent.governance.cue
		que elabora:
		- autonomy-overrides (promotion paths post-onboarding);
		- escalation-routing channel + SLA + recipient para
		  governance-critical-activation (cst-13 technicalRoutingOnly
		  materializado);
		- freeze-model thresholds consumindo sig-rew-replay-divergence-
		  detected + sig-rew-domain-corruption-detected;
		- drift-detection-metrics signal-as-contract per ADR-075
		  consumindo sig-rew-governance-version-changed (warn).

		**Cross-artifact deferrals declarados** (não-resolvidos em Phase 4):
		- ACL signal contract structural-check (Phase 1+ — endurece
		  cst-14 boundary acknowledged para enforcement real).
		- Phase 5 governance envelope materializa cst-13
		  technicalRoutingOnly em channel concreto.
		- Phase N+1 telemetry feedback loop consumindo signals 7/8/9
		  (governance + replay + corruption) para drift detection.

		Pattern paralelo INV/DLV/CTR primary agent bootstrap discipline;
		REW é segundo agent-spec consumindo structural-checks Phase 3.5
		(kind domain-invariant per ADR-080) — sets pattern continuity
		após INV reference.
		"""
}
