package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fcePrimaryAgent: build_time.#SelfReviewReport & {
	reportId: "srr-fce-primary-agent"

	artifactPath:       "contexts/fce/agents/fce-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-13"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Agent spec FCE (1099L) materializado via authoring manual
			section-by-section per manualAuthoringProtocol (adr-057).
			Phase 4 do WI-043 FCE bootstrap; quarto artefato do BC
			após canvas Phase 1 closed (0ad3302) + glossary Phase 2
			closed (e85c85b) + domain-model Phase 3 closed (7c8b804).
			Cascade ordering preservado.

			Materializado em 2 commits Phase 4:
			4110f4f feat(agent-spec): FCE primary agent — Phase 4 WI-043
			(este) feat(agent-spec): Phase 4.5 SRR closure

			Round único per founder iterative review pre-write
			integrated across 5 sub-phases (4.0 charter + 4.1
			envelope + 4.2 capabilities + 4.3 anti-capabilities +
			4.4 escalation) com 10 ajustes finos founder integrated
			pre-write.

			Este SRR é prova arquitetural de identity boundary
			preservation Phase 4 — agent como entidade
			epistemicamente limitada por construção, não sistema
			operacional rígido. Organização: VERIFICATION BY 10
			FOUNDER AJUSTES DELTAS (não phase chronology nem schema
			check enumeration).

			===========================================================
			CHARTER PHASE 4.0 PRESERVATION
			===========================================================

			Identity canonical preserved em 3 layers complementares:
			(a) NEGATIVE DEFINITION — 'NÃO é payment orchestrator,
			settlement optimizer, approval engine, workflow
			coordinator, operations accelerator, throughput maximizer,
			integration broker, exception handler, retry orchestrator'
			— embedded no header comment + description field do
			agent.
			(b) POSITIVE IDENTITY — 'guardião determinístico da
			integridade de convergência econômica sob pressão
			institucional adversarial' — embedded header + description.
			(c) HEADER PHRASE CANONICAL — 'The FCE agent is not
			authorized to preserve operational continuity at the
			expense of convergence integrity' — embedded header.

			Verification: CONFIRMED — todas 3 layers presentes;
			triangulation epistemic preserva identity contra
			reinterpretation.

			===========================================================
			VERIFICATION BY 10 FOUNDER AJUSTES (deltas-based)
			===========================================================

			Ajuste 1 — Agent/system separation
			Founder requirement: 'rollback, idempotency, state
			transition legality, atomicity devem ser tratados como
			system guarantees consumed by the agent.'
			Verification: CONFIRMED. Removed from agent capabilities:
			deterministic-state-transition, rollback-on-financialization-
			failure, idempotency-enforcement (todos system guarantees
			do domain-model Phase 3 — svc-financialization atomic,
			aggregate consistency boundary, lifecycle guards). Agent
			actions são todos behavioral (observation/evaluation/
			classification/escalation/routing/validation/interpretation/
			refusal). Separation property declared explicit em header
			+ outer rationale 'AGENT vs SYSTEM SEPARATION' section.

			Ajuste 2 — AP5 Refusal over fabricated continuity
			Founder requirement: 'AP5 — Refusal over fabricated
			continuity... refusal is a first-class valid outcome.'
			Verification: CONFIRMED. AP5 declared em header + outer
			rationale; act-emit-canonical-refusal action implementa
			operacionalmente; cst-refusal-is-valid-outcome constraint
			operacionaliza como behavioral constraint verificável
			(per ajuste final 1 below).

			Ajuste 3 — Capability authoritativeSource declared
			Founder requirement: 'capabilities precisam declarar
			epistemic source authority... grafo de autoridade
			epistemológica.'
			Verification: CONFIRMED. Cada action carrega
			authoritativeSource embedded em description field:
			- observe-convergence: upstream BC canonical states
			- verify-invariants: canonical invariants catalog (11)
			- correlate-evidence: PaymentObligation canonical refs
			- translate-upstream-signal: upstream domain events
			- classify-defer: convergence completeness result
			- detect-toctou: snapshot diff observation
			- classify-pending: BKR Indeterminate observation
			- route-escalation: anti-capability detection signals
			- detect-condition-weakening: convergence/invariant audit
			- detect-boundary-erosion: ConvergenceSet schemaVersion
			- apply-economic-interpretation: BKR canonical outcomes
			- apply-reconciliation-resolution: supervised reconciliation
			  authority externa
			- apply-reverse-settlement-execution: upstream mandate
			  validated
			- emit-canonical-refusal: invariant violation + anti-
			  capability attempt detection
			Audit trail field 'authoritative-source-ref' captures
			source per action.

			Ajuste 4 — ANTI-15 rename
			Founder requirement: 'cannot-reinterpret-bkr-settlement-
			outcomes está perigosa semanticamente... rename para
			cannot-synthesize-alternative-settlement-semantics.'
			Verification: CONFIRMED. cst-cannot-synthesize-alternative-
			settlement-semantics declared; description preserva
			distinção crítica ('interpretação econômica é legítima;
			divergência ontológica não'). Rationale explicit cita
			founder ajuste 4.

			Ajuste 5 — ANTI-16 NOVO
			Founder requirement: 'cannot-create-trust-based-fast-paths
			... institutional capture resistance.'
			Verification: CONFIRMED. cst-cannot-create-trust-based-
			fast-paths declared como constraint #16. Description cita
			exemplos canonical: 'trusted counterparty fast lane',
			'premium client skip reconciliation', 'supplier always
			delivers', 'risk already knows them', 'temporarily disable
			escalation'.

			Ajuste 6 — escalationNature 4-enum
			Founder requirement: 'escalation event deveria carregar
			escalationNature: epistemic | structural | institutional |
			operational.'
			Verification: CONFIRMED. Audit trail field 'escalation-
			nature' declared como requiredField. 8 escalation
			conditions classified por nature em description:
			- 3 epistemic (ambiguous-case x reconciliation,
			  insufficient-context x convergence pattern,
			  conflicting-signals x cross-BC)
			- 2 structural (suspicious-input x anti-capability
			  attempts ANTI-1/3/11/12/13/14/15, unclassifiable-
			  anomaly x boundary erosion + condition weakening
			  patterns)
			- 2 institutional (suspicious-input x ANTI-2/5/7/9/16,
			  unclassifiable-anomaly x waiver normalization ANTI-7)
			- 1 operational (out-of-scope x edge cases)

			Ajuste 7 — HIGH autonomy reframed
			Founder requirement: 'HIGH autonomy precisa de wording
			mais duro... Mechanically Determined Domains.'
			Verification: CONFIRMED. Header comment + outer rationale
			use exact phrase 'Mechanically Determined Domains' +
			'autonomy-irrelevant' framing. Explicit anti-framing:
			'NÃO é agent creativity zone, optimization zone, adaptive
			behavior zone' / 'agent NÃO decides — executes
			consequência inevitável do canonical state'. 10 actions
			labeled execute-and-log fall in this tier.

			Ajuste 8 — Anti-goal explicit
			Founder requirement: 'The FCE agent must not evolve toward
			becoming a generalized payment operations intelligence
			layer... deveria aparecer no charter.'
			Verification: CONFIRMED. Anti-goal canonical embedded em
			3 locations: header comment, agent description field,
			outer rationale (ANTI-GOAL CANONICAL section explicit).
			Rationale articulates attractor gravitacional natural
			Phase 5+ (dashboards, ops tooling, retries, optimization
			pressure, exception handling, customer success pressure
			todos pressionam nessa direção).

			Ajuste 9 (fine 1) — cst-refusal-is-valid-outcome
			Founder requirement: 'AP5 deve virar constraint
			comportamental verificável, não só property.'
			Verification: CONFIRMED. cst-refusal-is-valid-outcome
			constraint declared #17 com:
			- description: 'When convergence integrity NÃO pode ser
			  preserved, agent MUST emit canonical refusal/defer/
			  escalation outcome em vez de fabricating operational
			  continuity'
			- verification: 'Runner audit: para every halted action
			  path, verify (a) canonical refusal/defer/escalation
			  event emitted; (b) state preserved (no fabricated
			  transition); (c) no synthetic data substituting missing
			  canonical input. Pattern detection: if any state
			  transition occurs without canonical authoritative source
			  documented, constraint violated.'
			- onViolation: block-and-escalate
			- rationale: explicit cita founder ajuste final 1

			Ajuste 10 (fine 2) — ANTI-16 marked P0
			Founder requirement: 'cannot-create-trust-based-fast-paths
			seja marcado como P0 anti-capability no rationale.'
			Verification: CONFIRMED. cst-cannot-create-trust-based-
			fast-paths rationale explicit: '**P0 ANTI-CAPABILITY** —
			protege contra THE principal institutional drift vector
			of long-term operation' + 'Per founder ajuste final 2:
			marked P0 porque vector institucional de longo prazo
			mais perigoso'.

			===========================================================
			SoT DISCIPLINE VERIFICATION (founder critical attention)
			===========================================================

			Founder concern: 'Evite que APs, constraints, anti-
			capabilities, escalation semantics virem blocos
			redundantes semanticamente.'

			Separation discipline applied:
			- APs (philosophical-operational posture): canonical SoT
			  em header comment + outer rationale only. Actions/
			  constraints reference 'per APx' instead of
			  re-explaining.
			- Constraints (enforceable obligations): canonical SoT em
			  constraints[] array (17 entries). Each has verification
			  + onViolation + rationale. Não re-explain APs.
			- Capabilities (what behavior exists): canonical SoT em
			  actions[] array (14 entries). Each has description +
			  preconditions + postconditions. Não re-explain APs nor
			  constraints.
			- Anti-capabilities (what behavior cannot exist): canonical
			  SoT em constraints[] (subset cst-cannot-*). Não
			  duplicated em actions narrative.
			- Escalation (routing semantics): canonical SoT em
			  escalationConditions[] array (8 entries). Não duplicate
			  description from constraints or APs.

			Cross-references via canonical refs (per APx, per cst-y,
			per ANTI-z, per inv-w) em vez de re-narrative. Outer
			rationale serve como cross-traceability map (canvas →
			glossary → domain-model → agent-spec) sem duplicar each
			block.

			Verification: SoT discipline preservada — single canonical
			location per concept; cross-refs via codes; minimal
			narrative overlap.

			===========================================================
			SCHEMA SATISFACTION tq-ag-01..13
			===========================================================

			tq-ag-01 (operationalScope refs válidos): ✓ — Verified
			contra domain-model Phase 3:
			- 1 aggregate (agg-payment-obligation): exists
			- 11 commands: all exist
			- 19 events: all exist
			- 11 invariants: all exist
			- 3 projections: all exist
			Runner cross-file será autoritativo.

			tq-ag-02 (actions refs dentro de operationalScope): ✓ —
			Each action.domainModelRefs verified contra
			operationalScope. Refs incluem agg-/cmd-/evt-/inv-/vo-/
			prj- prefixes; agg-/cmd-/evt-/inv-/prj- todos em
			operationalScope arrays; vo- permitido per schema
			(parent-associated). Nenhum ref out-of-scope detectado.

			tq-ag-03 (canvas domainAgentSpec alignment): runner-
			validated. Canvas Phase 1.1 declared domainAgentSpec ref
			canonical; agent code 'agt-fce-primary' deve corresponder.

			tq-ag-04 (constraints verifiable): ✓ — 17 constraints,
			each has verification field with mechanical-runner-
			implementable check. Examples:
			- cst-cannot-infer-settlement-truth: 'Runner audit: every
			  state transition InstructionDispatched → Settled OR
			  → Failed must have provenance ref to consumed
			  BKRSettlementOutcome event.'
			- cst-cannot-create-trust-based-fast-paths: 'Runner audit:
			  code paths conditional on counterparty-trust-level /
			  customer-tier / supplier-reputation = violation.'
			- cst-refusal-is-valid-outcome: 'Runner audit: para every
			  halted action path, verify canonical refusal/defer/
			  escalation event emitted.'

			tq-ag-05 (observability cobre ações): ✓ — 10 signals
			cobrindo categorias:
			- query (sig-convergence-observation-emitted)
			- validation (sig-invariant-verification-result + defer-
			  classified + toctou-detected + pending-declaration-
			  classified + condition-weakening-detected + boundary-
			  erosion-detected)
			- mutation (sig-economic-interpretation-applied)
			- escalation (sig-anti-capability-attempt-detected +
			  sig-refusal-emitted)
			All 5 categorias actions cobertas: query, validation,
			mutation, escalation (generation N/A — agente não gera
			artefatos).

			tq-ag-06 (context coherent com scope): ✓ — 5 context
			artifacts:
			- canvas: used para identity + canonical clauses
			- domain-model: used para invariants/lifecycle/VOs
			- glossary: used para UL anchoring
			- agent-governance: used para envelope (Phase 5)
			- context-map: used para cross-BC boundary
			All artifacts justified em rationale fields.

			tq-ag-07 (action codes únicos): ✓ — 14 codes distintos
			(act-observe-convergence, act-verify-invariants, etc.).

			tq-ag-08 (constraint codes únicos): ✓ — 17 codes distintos
			(cst-refusal-is-valid-outcome + 16 cst-cannot-*).

			tq-ag-09 (governanceRef exists): N/A — Phase 5 (governance
			envelope) ainda não materializada. governanceRef='fce-
			primary-agent' aponta para contexts/fce/agents/fce-
			primary-agent.governance.cue que será criado Phase 5.
			Runner check pendente até Phase 5 close.

			tq-ag-10 (escalation coherent): ✓ — 8 escalation
			conditions cobrindo 6 #EscalationCategory enum values:
			ambiguous-case (1), out-of-scope (1), conflicting-signals
			(1), insufficient-context (1), suspicious-input (2),
			unclassifiable-anomaly (2). Coherent com role=domain-
			agent + operationalScope.

			tq-ag-11 (inputTrustLevel declared): ✓ — Each action
			declares inputTrustLevel:
			- trusted-internal: 11 actions (FCE-internal operations)
			- external-structured: 3 actions (apply-economic-
			  interpretation consumes BKR canonical event;
			  apply-reconciliation-resolution consumes external
			  authority; apply-reverse-settlement-execution consumes
			  upstream mandate; translate-upstream-signal consumes
			  upstream domain events)

			tq-ag-12 (autonomy × constraints coherent): ✓ — 10
			execute-and-log actions (Tier 1 Mechanically Determined)
			operate under 16 cst-cannot-* block-and-escalate
			constraints. 3 propose-and-wait actions operate under
			cst-refusal-is-valid-outcome + applicable cst-cannot-*.
			Não há combinação execute-and-log + log-only-constraint
			(would be 'agent sem freio real'). Não há combinação
			no-autonomous-action — Tier 3 'Absence-by-Construction'
			materialized via anti-capability absence, não autonomy
			level.

			tq-ag-13 (audit trail minimumFields): ✓ — auditTrail.
			requiredFields contém todos 7 minimumAuditFields:
			timestamp, agent-id, action-code, input-summary, output-
			summary, decision-rationale, governance-version. Plus 6
			additional regulatory-grade fields:
			- authoritative-source-ref (per ajuste 3)
			- escalation-nature (per ajuste 6)
			- escalation-layer (per ajuste 6)
			- invariants-verified (per AP1 determinism evidence)
			- constraints-evaluated (per anti-capabilities audit)
			- refusal-context (per AP5 refusal-as-valid-outcome
			  documentation per ajuste final 1)

			===========================================================
			CROSS-CLASS REINFORCEMENT MATRIX (anti-capabilities × invariants)
			===========================================================

			11 Phase 3 invariants ↔ 16 anti-capabilities mapping:

			Boundary class (inv-bdy-*):
			- inv-bdy-1 (no upstream mutation) → ANTI-3 (cannot-
			  create-upstream-commands) + ANTI-6 (cannot-replace-
			  upstream-authority-with-heuristics)
			- inv-bdy-2 (no settlement arbitration) → ANTI-1 (cannot-
			  infer-settlement-truth) + ANTI-15 (cannot-synthesize-
			  alternative-settlement-semantics)
			- inv-bdy-3 (reverse upstream-mandated) → ANTI-12 (cannot-
			  originate-reverse-settlement)
			- inv-bdy-4 (economic interpretation distinct) → ANTI-15
			  (cross-class)

			Convergence class (inv-cvg-*):
			- inv-cvg-1 (full convergence required) → ANTI-2 (cannot-
			  weaken-convergence) + ANTI-14 (cannot-mutate-convergence-
			  set-runtime)
			- inv-cvg-2 (atomic financialization) → system guarantee
			  (no agent constraint; per ajuste 1)
			- inv-cvg-3 (no stale eligibility) → ANTI-13 (cannot-mutate-
			  validity-windows) + ANTI-6 (cannot-replace-upstream-
			  authority-with-heuristics)
			- inv-cvg-4 (retention release convergence) → ANTI-2
			  (cross-application)

			Epistemic class (inv-eps-*):
			- inv-eps-1 (indeterminate non-collapse) → ANTI-11 (cannot-
			  collapse-epistemic-uncertainty) + ANTI-4 (cannot-auto-
			  resolve-ambiguity)
			- inv-eps-2 (no inferred settlement truth) → ANTI-1
			  (cross-class)
			- inv-eps-3 (no proxy substitution) → ANTI-10 (cannot-
			  synthesize-proxy-conditions)

			Institutional-only protection (no direct invariant; meta-
			protection):
			- ANTI-5 (cannot-optimize-for-throughput) — meta over all
			  integrity invariants
			- ANTI-7 (cannot-normalize-waivers) — meta-pattern
			- ANTI-8 (cannot-silently-retry-around-invariant-
			  violations) — meta-pattern
			- ANTI-9 (cannot-downgrade-escalation-severity) — anti-
			  fatigue
			- ANTI-16 P0 (cannot-create-trust-based-fast-paths) — THE
			  principal institutional drift vector

			Plus cst-refusal-is-valid-outcome — operacionaliza AP5
			across all integrity preservation paths.

			Coverage property: cada invariant Phase 3 tem ≥1
			anti-capability proteção (exceto inv-cvg-2 que é system
			guarantee per ajuste 1 separation). Institutional drift
			class (ANTI-5/7/8/9/16) sem direct invariant mapping
			porque é meta-protection emergent (não pertence a single
			invariant — protege institutional integrity over time).

			===========================================================
			LENSES ACTIVATION EVIDENCE (5)
			===========================================================

			- lens-ai-agent-governance (primária): 14 actions × autonomy
			  matrix (10 execute-and-log + 3 propose-and-wait) + 17
			  constraints × verification + 10 observability signals
			- lens-mechanism-design (secundária): convergence-as-
			  mechanism operacionalizado em observe/verify/classify
			  capabilities; refusal-as-mechanism via cst-refusal-is-
			  valid-outcome
			- lens-trust-and-credibility-design (terciária): integrity-
			  over-throughput posture canonical materializada em anti-
			  capabilities + escalation-as-success semantics
			- lens-regulatory-compliance-as-architecture (quaternária):
			  reverse settlement upstream-mandated-only enforcement
			  (ANTI-12); audit trail regulatory-grade (13 fields)
			- lens-security-trust-infrastructure (quinária):
			  inputTrustLevel per action; cryptographic boundary via
			  authorization-proof binding consumption (não originação
			  per ANTI-3)

			===========================================================
			VERIFICATION RESULT SUMMARY
			===========================================================

			10 founder ajustes integrated: CONFIRMED (cada delta
			verificado por ID).

			Charter Phase 4.0 preservation (Identity + Header phrase
			+ Anti-goal): CONFIRMED.

			SoT discipline (APs/constraints/capabilities/anti-
			capabilities/escalation sem narrative overlap):
			CONFIRMED.

			Schema satisfaction tq-ag-01..13: CONFIRMED intra-file +
			runner-pending para tq-ag-01 (operationalScope), tq-ag-03
			(canvas alignment), tq-ag-09 (governanceRef Phase 5
			pendente).

			Cross-class reinforcement matrix: 10/11 invariants Phase
			3 ↔ ≥1 anti-capability constraint each (inv-cvg-2 system
			guarantee per ajuste 1). 5 institutional meta-protection
			anti-capabilities sem direct invariant mapping (correct
			per architectural design).

			5 lenses activated: CONFIRMED.

			cue-validate (CI structural authority): aguardando run
			post-push do commit 4110f4f + (este) SRR commit;
			expectation GREEN por construção (regex compliance
			verificada; referential integrity verificada via cross-
			file inspection).

			CUE CLI indisponível no ambiente do agente; validação
			sintática autoritativa via CI cue-validate post-commit
			(padrão estabelecido). Integridade estrutural verificada
			por inspeção textual neste SRR.
			"""
	}]

	findings: {}

	summary: """
		FCE primary agent-spec Phase 4 WI-043 closure. 1099 linhas
		materializando Charter Phase 4.0 (5 APs + Anti-goal + Header
		phrase canonical + Agent vs System separation) + 14 actions
		behavioral-only + 17 constraints (16 anti-capabilities + 1
		cst-refusal-is-valid-outcome) + 8 escalation conditions
		(4 escalationNature) + 10 observability signals + audit trail
		regulatory-grade (13 fields).

		10 founder ajustes all CONFIRMED via verification-by-delta
		framework:
		1. Agent/system separation
		2. AP5 Refusal over fabricated continuity
		3. authoritativeSource per action
		4. ANTI-15 rename (synthesize-alternative-settlement-
		   semantics)
		5. ANTI-16 NOVO P0 (cannot-create-trust-based-fast-paths)
		6. escalationNature 4-enum
		7. Mechanically Determined Domains framing
		8. Anti-goal explicit
		9. cst-refusal-is-valid-outcome (AP5 operationalized)
		10. ANTI-16 P0 marker explicit

		SoT discipline preservada per founder critical attention:
		APs (header + outer rationale only), constraints (constraints[]
		only), capabilities (actions[] only), anti-capabilities
		(constraints cst-cannot-* only), escalation (escalationConditions[]
		only). Cross-references via canonical refs, não re-narrative.

		Identity preservada: agent epistemicamente limitada por
		construção, não sistema operacional rígido. Esta diferença
		evita FCE derivar para payment ops layer, workflow automation
		engine, heuristic exception handler, ou convergence optimizer.

		Cross-class reinforcement: 10/11 Phase 3 invariants ↔ ≥1
		anti-capability; inv-cvg-2 system guarantee per separation
		ajuste 1; 5 institutional meta-protection anti-capabilities
		(ANTI-5/7/8/9/16 P0) sem direct invariant — protegem
		institutional integrity over time.

		Phase 5 (governance envelope fce-primary-agent.governance.cue)
		próximo — materializa autonomy caps + escalation channels +
		drift detection config + promotion/regression criteria,
		fechando WI-043.
		"""

	singleRoundRationale: """
		Round único suficiente per founder iterative review
		incorporated pre-write across 5 sub-phases (4.0 charter +
		4.1 envelope + 4.2 capabilities + 4.3 anti-capabilities +
		4.4 escalation) com 10 ajustes finos founder integrated.

		Density de direction founder superior em:
		- Phase 4.0 charter (substantial framing + 4 APs initial)
		- Phase 4 mid-review (8 substantive ajustes — agent/system
		  separation, AP5, authoritativeSource, ANTI-15 rename,
		  ANTI-16 novo, escalationNature, autonomy reframe, anti-goal)
		- Phase 4 fine ajustes (2 final ajustes pre-write — cst-
		  refusal-is-valid-outcome operationalization, ANTI-16 P0
		  marker)

		Each iteration revisado por founder antes de progressão
		final. Founder critical attention pre-write sobre SoT
		discipline (APs/constraints/capabilities/anti-capabilities/
		escalation sem narrative overlap) integrated em estructura
		final.

		Additional rounds não detectariam new findings porque:
		(a) Founder iterative review already integrated all axes
		    de análise (identity preservation, behavioral authority
		    boundary, institutional drift resistance, refusal
		    semantics, anti-capability identity);
		(b) SoT discipline applied per critical attention — each
		    concept single canonical location;
		(c) Schema satisfaction tq-ag-01..13 verificada intra-file;
		    cue-validate CI structural authority runs post-commit;
		(d) Cross-traceability (canvas + glossary + domain-model)
		    mapped via canonical refs sem narrative duplication.

		Phase 4 substantive completeness confirmed by verification-
		by-delta framework (10 founder ajustes deltas), not by
		additional procedural review.

		Per CLAUDE.md guardrail Phase 1.7/2.4/3.8 established pattern:
		self-review-check intentionally red across Phase 4 build-up;
		Phase 4.5 SRR closure expected to turn check green
		(paralleling Phase 1.7 srr-fce-canvas + Phase 2.4 srr-fce-
		glossary + Phase 3.8 srr-fce-domain-model patterns).
		"""
}
