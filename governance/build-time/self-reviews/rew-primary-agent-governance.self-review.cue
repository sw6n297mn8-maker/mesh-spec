package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

rewPrimaryAgentGovernance: build_time.#SelfReviewReport & {
	reportId: "srr-rew-primary-agent-governance"

	artifactPath:       "contexts/rew/agents/rew-primary-agent.governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-governance.cue"
	artifactType:       "agent-governance"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-11"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 1 (routing-and-blast-radius) — manualAuthoringProtocol
			section-gate per adr-057 ciclo R1 → founder review identificou
			3 vazamentos conceituais build-time/runtime → análise revelou
			que 2 dos 3 vazamentos residem no schema #AgentGovernanceEnvelope
			(slaDescription field name; #EscalationChannel enum values),
			NÃO no envelope instance.

			Decisão de governança: Opção B aprovada (tension-entry ten-012
			+ envelope REW com schema atual + ajuste prose-level).

			Identity declarado: agentRef='agt-rew-primary'; governance
			GlobalVersion='0.1' Phase 0 forward-ref canônico; lifecycle
			Stage='onboarding' Phase 0 default.

			5 escalationRouting cobrindo 5 spec.escalationConditions
			categories (1:1, tq-gvg-02 coverage). 2 routes com sub-routing
			splits via rationale (suspicious-input UNCERTAIN/VERIFIED;
			out-of-scope replay-default/sustained-pattern override).

			Routing precedence canonical 5-tier: unclassifiable-anomaly
			(HALT_AGENT) > conflicting-signals/suspicious-input VERIFIED
			> suspicious-input UNCERTAIN > insufficient-context > out-of-
			scope.

			HALT_AGENT recovery protocol 4-condition (root cause +
			invariants revalidated + SAFE STATE REPLAY EXECUTED + explicit
			human authorization) com audit trail event AgentResumedAfterHalt.

			Block scopes declarados: evaluation-specific / item-specific /
			actor-affected / cluster-elevável / agent-wide (per tq-gvg-10).

			blastRadiusCaps 2/30 mid-band conservador (faixa onboarding
			canônica 1-2/20-50; vs gateway-padrão upper-end 2/50). REW
			severity tier ALTO justifica posição mid-band (paralelo INV).

			Unknown event safety rule narrowed to semantic/domain/
			governance events within modeled governance surface (founder
			ajuste Section 3); infrastructure telemetry excluded unless
			linked to mutation/result/invariant/governance transition.

			Governance-critical-activation discipline (cst-13 do spec)
			materializada via 4 mecanismos: dm-governance-version-change-
			frequency metric + regression trigger 6 + rationale outer
			declaration + signal-as-contract sig-rew-governance-version-
			changed payload (semanticCategory preserved per ADR-075).
			NÃO via autonomyOverride retroativo.

			Tension-entry ten-012 registered (status: accepted) capturando
			vazamento schema-level: #EscalationChannel enum + slaDescription
			field name carry runtime/SRE/transport semantics. Trade-off
			articulado: schema atual preservado + envelope reframa CONTEÚDO
			em linguagem de governança (Governance response window vs SLA;
			channel enum values interpretados como review modes). Schema
			rename deferred to ADR + 9-envelope migration.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 2 (drift-and-calibration) — manualAuthoringProtocol
			section-gate ciclo R2 → founder review identificou 4 ajustes
			refinement → aplicação inline → approval com strong verdict.

			driftDetection 9 metrics organizadas em 3 classes:
			- OPERATIONAL pure (2): dm-evaluation-cycle-time +
			  dm-emit-failure-rate.
			- HYBRID op/adv (3): dm-supersede-rate + dm-alert-resolution-
			  completeness + dm-structural-gate-block-rate.
			- ADVERSARIAL fundamental (4): dm-replay-divergence-detected
			  + dm-governance-version-change-frequency + dm-cross-bc-
			  evaluation-utilization-drift + (combined via regression
			  trigger 8).

			3 drift→action bindings declarados (tq-gvg-06): replay-
			divergence (TIER MÁXIMO LGPD contract integrity); gate-block
			multi-camada (single-actor concentration + multi-actor
			distributed probing); governance-version-change (anti-
			instability + anti-adversarial-baseline-shift).

			calibration: 2 promotionCriteria (20/60 onboarding→validation
			+ 60/90 validation→operational) com 4 anti-gaming criteria
			embedded (coverage multi-version; ZERO replay divergence;
			ZERO unclassifiable-anomaly; audit trail reconstrução real;
			realization tracking via downstream CMT).

			8 regressionTriggers Phase 0: P10 boundary tolerance-zero
			(suspend); replay divergence HARD 1 evaluation (suspend; TIER
			MÁXIMO); domain corruption post-emit (suspend → HALT_AGENT);
			gate-block concentration OR distributed (suspend); cap breach
			(reduce); governance-critical activation rate breach (suspend);
			sustained supersede pattern (reduce); COMBINED ADVERSARIAL
			SIGNAL 'weak + weak = strong' (suspend).

			failureHandling per adr-058 first-class: suspend-and-escalate
			em 3 events; retry diferenciado (intra-BC projection 1 retry
			exponential; cross-BC ACL 1 retry curto 1-2s; audit logic
			ZERO retry); ANTI-BYPASS DISCIPLINE (retry NUNCA contorna
			gates; gate failure suspende, retry NÃO salva gate).

			autonomyOverrides Phase 0 empty per founder discipline
			(tq-gv-14 forbid execute-and-log override direto a mutations
			preserva P10).

			4 founder ajustes pre-write incorporados:
			- (1) dm-replay-divergence-rate → dm-replay-divergence-detected
			      (binary breach detector, NÃO statistical rate);
			- (2) threshold 'governance-version-change' rephrased '1 breach
			      in monthly evaluation window' (unidade semântica clara);
			- (3) realization tracking GUARDRAIL EPISTEMOLÓGICO explicit
			      anti-Goodhart note ('epistemic validation ≠ reward
			      shaping');
			- (4) evaluationCadence schema interpretation note inline
			      (drift compute cadence vs governance review vs human
			      review cadence — distinção explicit; NÃO promoted to
			      tension-entry per low-stakes ambiguity).

			Founder verdict canonical: 'runtime governance calibration
			system' — disciplina separada de runtime implementation, ML
			ops, observability pura, DDD build-time. Especialmente:
			- drift virou governance degradation (não model quality);
			- replay virou contract integrity;
			- promotion virou epistemic trust accumulation;
			- regression virou confidence withdrawal.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 3 (bidirectional-validation) + rationale outer +
			final write — manualAuthoringProtocol section-gate ciclo R3
			→ founder review identificou 2 ajustes refinement → aplicação
			inline → approval.

			Bidirectional-validation checks PASSING:
			- tq-gv-06: envelope.agentRef 'agt-rew-primary' == spec.code;
			  spec.governanceRef 'rew-primary-agent' == envelope filename
			  base.
			- tq-gv-08: lifecycleStage 'onboarding' ∈ #LifecycleStage enum.
			- tq-gvg-02: 5 routes cobrem 5 spec.escalationConditions
			  categories (1:1).
			- tq-gv-11/13/14: autonomyOverrides empty Phase 0; nenhum
			  override a validar.
			- tq-gv-15: nenhum outro .governance.cue em contexts/rew/agents/
			  com mesmo agentRef.
			- tq-gvg-07: caps 2/30 dentro de onboarding range monotonicity.
			- tq-gvg-10: block scope explícito em alert-and-block routes.
			- tq-gvg-11: statistical signal discipline ADVERSARIAL metrics.

			Rationale outer cobertura completa de 19 disciplinas:
			conceito central + bidirectional ref + 5 routes + routing
			precedence + multi-match resolution + scope elevation +
			unknown event safety (narrowed) + HALT recovery 4-condition +
			caps + 9 drift metrics + 3 drift→action bindings + calibration
			+ realization tracking GUARDRAIL EPISTEMOLÓGICO + 8 regression
			triggers + failure handling anti-bypass + autonomy overrides
			Phase 0 empty + envelope-is-control-plane + schema interpretation
			ten-012 + cross-artifact dependencies + forward-refs Phase N+1.

			2 founder ajustes pre-write incorporados:
			- (1) Unknown event safety rule narrowed to semantic/domain/
			      governance events within modeled governance surface;
			      infrastructure telemetry excluded unless linked to
			      mutation/result/invariant/governance transition. Anti-
			      pattern guard: HALT por noise infrastructure;
			- (2) 'runner' → 'runtime governance layer' em usos
			      implementation-sounding no rationale outer (preserva
			      canonical references onde runner é role schema-
			      canonical).

			cue vet ./contexts/rew/agents/ ./architecture/artifact-schemas/
			EXIT=0; cue vet ./... EXIT=0. Shape conforme #AgentGovernance
			Envelope.

			Manual authoring protocol concluído:
			- 3 sections completadas (routing-and-blast-radius +
			  drift-and-calibration + bidirectional-validation).
			- Cada section approved por founder ANTES de section seguinte
			  (section-gate per adr-057 camada 2).
			- 6 ajustes founder totais incorporados pre-write (Section 2:
			  4; Section 3: 2) + tension-entry ten-012 registered.
			- Artifact escrito ÚNICO commit (com SRR + WI-074) após
			  approval completo + ten-012 committed standalone prior.
			"""
	}]

	findings: {}

	summary: """
		REW Primary Agent Governance Envelope (rewPrimaryAgentGovernance)
		materializado em commit Phase 5 sobre Phase 4 agent-spec
		(rew-primary-agent.cue). Control plane supervisório:
		routing + caps + drift + calibration + failureHandling.

		Identity: agentRef='agt-rew-primary'; governanceGlobalVersion='0.1'
		Phase 0 forward-ref canônico; lifecycleStage='onboarding'.

		5 escalationRouting cobrindo 5 spec categories (1:1; tq-gvg-02);
		2 routes com sub-routing splits; routing precedence canonical
		5-tier; multi-match resolution rule; scope elevation rule
		(actor-affected → cluster-elevável anti-coordinated-fraud); unknown
		event safety rule narrowed (semantic/domain/governance surface);
		HALT_AGENT recovery 4-condition protocol incluindo SAFE STATE
		REPLAY EXECUTED.

		blastRadiusCaps 2/30 mid-band conservador (REW severity tier
		ALTO; cascade REW → CMT-credit).

		driftDetection 9 metrics (2 OPERATIONAL + 3 HYBRID + 4 ADVERSARIAL)
		com 3 drift→action bindings declarados (replay-divergence TIER
		MÁXIMO; gate-block multi-camada; governance-version-change).
		dm-replay-divergence-detected é binary breach detector (NÃO
		statistical rate) — tolerance ZERO.

		calibration: 20/60 + 60/90 promotion criteria com anti-gaming
		embedded; 8 regressionTriggers incluindo combined adversarial
		signal 'weak + weak = strong'.

		Realization tracking GUARDRAIL EPISTEMOLÓGICO declarado anti-
		Goodhart: 'epistemic validation ≠ reward shaping'; realization
		informa promotion gate NÃO runtime decision-making.

		failureHandling adr-058 first-class: suspend-and-escalate em 3
		events; retry diferenciado intra-BC vs cross-BC vs audit logic;
		ANTI-BYPASS DISCIPLINE (retry NUNCA contorna gates).

		autonomyOverrides Phase 0 empty; governance-critical-activation
		discipline (cst-13 do spec) materializada via 4 mecanismos
		(metric + regression trigger + rationale + signal payload
		semanticCategory) — NÃO via override retroativo.

		Tension-entry ten-012 registered (status: accepted): schema
		#EscalationChannel + slaDescription field name vazam runtime/
		transport semantics. Trade-off articulado: schema atual preservado
		+ envelope reframa CONTEÚDO em linguagem de governança. Schema
		rename deferred to dedicated ADR + 9-envelope migration.

		3 rounds executados (Section 1 + 2 + 3); 6 founder ajustes
		pre-write incorporados + ten-012 standalone commit + envelope
		write/cue vet/commit. Pattern paralelo INV/DLV/CTR primary
		agent envelope discipline; REW é segundo envelope consumindo
		structural-checks Phase 3.5 sc-rew-* per ADR-080; primeira
		instância completa do pattern decision-systems-with-truth-
		boundaries per adr-085 + lens-truth-boundaries (post-INV
		extraction).
		"""
}
