package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

ntfPrimaryAgentGovernance: build_time.#SelfReviewReport & {
	reportId: "srr-ntf-primary-agent-governance"

	artifactPath:       "contexts/ntf/agents/ntf-primary-agent.governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-governance.cue"
	artifactType:       "agent-governance"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-14"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			NTF Primary Agent Governance Envelope materializado via
			authoring manual section-by-section per
			manualAuthoringProtocol (adr-057) com batch-by-batch
			founder review canonical. Phase 5 do WI-063 NTF bootstrap;
			QUINTO e ÚLTIMO artefato do BC após:
			- Phase 1 canvas (commit 11f7f98)
			- Phase 2 glossary (commit f7e5832)
			- Phase 3 domain-model + SRR + editorial fixes (commits
			  dd832f7 + 0dde268 + f645905 + 00fc03b)
			- Phase 4 agent-spec + ADR-088 schema delta + SRRs (commits
			  afad087 + 18a0dde + ab65293 + cd0114d)

			Family Mesh parallel canonical:
			- FCE primary agent governance envelope (876 linhas):
			  sistema imunológico contra captura institucional cumulativa
			- NTF primary agent governance envelope (1188 linhas):
			  sistema imunológico contra degradação de admissibility
			  integrity

			Densidade superior NTF (~36% maior que FCE) reflete:
			- 7 priority axes (NTF) vs 4-5 axes (FCE)
			- 15 drift metrics em 7 axes (NTF) vs ~10 metrics (FCE)
			- MCM exception class NEW via ADR-088 schema-anchored
			- Asymmetric provenance ontology specific NTF
			- Forensic-integrity layer (L4 escalation) NEW NTF
			- Linguistic drift detection meta-imunological NEW NTF
			- 4 anti-drift clauses (vs 3 FCE — governance-cannot-self-
			  weaken 4th NEW per Phase 5.6 ajuste #2)

			Materializado em commit (este) + SRR closure commit.

			Round único per founder iterative review pre-write integrated
			across 7 sub-phases canonical (Phase 5.0-5.6) com ~24 ajustes
			finos founder integrated em conversational dialog batch-by-
			batch.

			Este SRR não é compliance de processo. É prova arquitetural
			de preservação ontológica covering 7 priority axes + 8
			canonical clauses + 4 anti-drift clauses + 4 FORBIDDEN
			mutations + Phase 4 obligations satisfied + WI-063 closure
			lineage.

			Organização: VERIFICATION BY PRIORITY AXIS + ANTI-DRIFT
			CLAUSE + MUTATION CLASSIFICATION (paralelo NTF Phase 4 SRR
			organization).

			===========================================================
			AXIS 1 — MCM expansion control
			===========================================================

			Materialização verificada via:
			- driftDetection metric dm-mcm-vs-standard-mutation-ratio
			  (baseline 4 MCM actions; threshold ANY new MCM declaration
			  sem ADR + parallel SRR + 90/180-day cycle)
			- driftDetection metric dm-unauthorized-execute-and-log-
			  mutation (zero-tolerance per tq-ag-15 enforcement)
			- calibration promotionCriteria #5 (MCM action declaration
			  approval: ADR + SRR + 90-day default OR 180-day critical
			  cycle)
			- calibration regressionTrigger #6 (unauthorized MCM
			  declaration → reduce-autonomy)
			- calibration regressionTrigger #7 (unauthorized execute-
			  and-log mutation → reduce-autonomy)
			- mutation classification table row 4 (MCM class expansion
			  → founder-only + ADR + SRR + 90/180-day cycle critical
			  domains: replay-forbidden + audit-chain + tier-separation
			  + scope-boundary per Phase 5.0 ajuste #2 + Phase 5.3
			  ajuste #2)
			- canonical clause 2 (MCM EXPANSION GATE) em outer
			  rationale section 6

			Verification: CONFIRMED.

			===========================================================
			AXIS 2 — Refusal-rate anti-drift
			===========================================================

			Materialização verificada via:
			- driftDetection metric dm-refusal-rate-trend (OBSERVED não
			  optimization; anti-fatigue framing INLINE)
			- driftDetection metric dm-conservatism-rate-trend (OBSERVED
			  não optimization; anti-fatigue framing INLINE)
			- driftDetection metric dm-refusal-suppression-pressure-
			  signals NEW per Phase 5.2 ajuste #3 (zero-tolerance
			  meta-imune layer detecting linguistic drift)
			- calibration regressionTrigger #5 (suspend-and-escalate
			  per Phase 5.3 ajuste #1 literal: 'Linguistic drift é
			  precursor constitucional, NÃO sinal fraco')
			- calibration regressionTriggers #8 + #9 (refusal/
			  conservatism trend → reduce-autonomy + investigation
			  cycle, NÃO automatic admissibility relaxation)
			- Anti-fatigue clause canonical DUPLO (inline em metrics +
			  central em driftDetection.rationale per Phase 5.2 ajuste
			  #5 founder confirmed)
			- Anti-metric-gaming clause canonical (Phase 5.2 ajuste #6
			  literal embedded)
			- canonical clause 1 (ANTI-DEGRADATION-AS-SUCCESS P0)
			- outer rationale Section 4 (Recognition Fundamental — NTF
			  combats narrative pressure)

			Verification: CONFIRMED.

			===========================================================
			AXIS 3 — Projection non-authority enforcement
			===========================================================

			Materialização verificada via:
			- driftDetection metric dm-projection-causal-input-attempts-
			  in-mutations (zero-tolerance absolute)
			- driftDetection metric dm-tier-boundary-violation-rate
			  (zero-tolerance absolute)
			- calibration regressionTriggers #3 + #4 (suspend-and-
			  escalate canonical para constitutional integrity breach)
			- mutation classification row 10 (projection→mutation
			  authority shift FORBIDDEN) — 1ª of 4 FORBIDDEN
			- canonical clause 3 (PROJECTION NON-AUTHORITY)
			- agent-spec cst-projection-never-causal-input-to-mutation
			  (constraint #2 block-and-escalate) inherited

			Verification: CONFIRMED.

			===========================================================
			AXIS 4 — Provider-claim distrust calibration
			===========================================================

			Materialização verificada via:
			- driftDetection metric dm-provenance-class-collapse-attempts
			  (hard collapse vector)
			- driftDetection metric dm-provider-instrumented-evidence-
			  unflagged
			- driftDetection metric dm-asymmetric-provenance-asymmetry-
			  erosion NEW per Phase 5.2 ajuste #2 (gradual erosion vs
			  hard collapse distinction)
			- calibration regressionTriggers #10 + #11 + #12 (reduce-
			  autonomy spectrum)
			- mutation classification row 13 (provider-claim-as-fact
			  weighting override FORBIDDEN) — 4ª FORBIDDEN per Phase
			  5.0 ajuste #5
			- canonical clause 4 (PROVIDER DISTRUST CALIBRATION)
			- agent-spec OP3 + inv-eps-claim-preserving-handling-vs-
			  fact-preserving-handling inherited

			Verification: CONFIRMED.

			===========================================================
			AXIS 5 — Replay-forbidden zero leakage
			===========================================================

			Materialização verificada via:
			- driftDetection metric dm-replay-forbidden-retry-flow-
			  leakage (absolute zero-tolerance — single instance =
			  L4 critical drift)
			- calibration regressionTrigger #1 (suspend-and-escalate)
			- mutation classification row 11 (replay-forbidden
			  isolation modification FORBIDDEN) — 2ª of 4 FORBIDDEN
			- canonical clause 5 (REPLAY-FORBIDDEN ZERO-LEAKAGE)
			- escalation routing L4 forensic-integrity-immediate
			  (suspicious-input sync-human-review canonical para
			  cryptographic + adversarial vectors)
			- agent-spec OP4 + inv-eps-replay-forbidden-failed-issuer-
			  reissuance + C9 inherited

			Verification: CONFIRMED.

			===========================================================
			AXIS 6 — Evidence/staleness governance
			===========================================================

			Materialização verificada via:
			- driftDetection metric dm-evidence-staleness-near-threshold-
			  ratio (substrate aging signal)
			- driftDetection metric dm-staleness-threshold-extension-
			  attempts (FORBIDDEN-adjacent mutation row violation)
			- calibration regressionTriggers #14 + #15 (revert-to-
			  previous-stage canonical para substrate hygiene)
			- mutation classification row 9 (evidence staleness window
			  extension → founder-only + evidence base expansion
			  proof) — founder-only stringent
			- mutation classification row 8 (confidence class threshold
			  relaxation → founder-only + proof) — founder-only
			  stringent (moved from FORBIDDEN per Phase 5.6 ajuste #1
			  taxonomy clean — altera sensibility/calibração sem
			  colapso ontológico imediato)
			- canonical clause 7 (EVIDENCE STALENESS CONSERVATISM)
			- agent-spec OP6 + C11 inherited

			Verification: CONFIRMED.

			===========================================================
			AXIS 7 — Audit/evidentiary integrity
			===========================================================

			Materialização verificada via:
			- driftDetection metric dm-audit-chain-integrity-breach
			  (absolute zero-tolerance)
			- driftDetection metric dm-audit-field-completeness-
			  violation (per cst-evidentiary-audit-chain-required)
			- calibration regressionTrigger #2 (suspend-and-escalate
			  para chain breach)
			- calibration regressionTrigger #13 (reduce-autonomy para
			  field completeness)
			- mutation classification row 12 (audit chain field
			  removal/modification FORBIDDEN) — 3ª of 4 FORBIDDEN
			- canonical clause 6 (AUDIT CHAIN INVIOLABILITY)
			- escalation routing L4 forensic-integrity-immediate
			  (cryptographic chain breach → ntf-forensic-integrity-
			  reviewer per Phase 5.1 ajuste #3 rename)
			- agent-spec OP7 + tc-regulatory-evidentiary contract
			  inherited

			Verification: CONFIRMED.

			===========================================================
			4 FORBIDDEN MUTATIONS (constitutional core)
			===========================================================

			Mutation classification table (Section 7) contém 4 FORBIDDEN
			canonical (rows 10-13):
			1. projection→mutation authority shift (OP8 non-negotiable)
			2. replay-forbidden isolation modification (constitutional
			   integrity P8 + C9)
			3. audit chain field removal/modification (OP7 + tc-
			   regulatory-evidentiary)
			4. provider-claim-as-fact weighting override (OP3 + C10) —
			   4ª FORBIDDEN per Phase 5.0 ajuste #5

			Taxonomy clean per Phase 5.6 ajuste #1 founder confirmed:
			- FORBIDDEN = viola identidade constitucional diretamente
			- founder-only stringent (5 entries — rows 4 + 6-9) =
			  altera sensibilidade/calibração sem colapso ontológico
			  imediato (MCM expansion + anti-capability + refusal
			  threshold + confidence relaxation + staleness extension)

			Verification: CONFIRMED.

			===========================================================
			4 ANTI-DRIFT CLAUSES (defense in depth)
			===========================================================

			Section 9 outer rationale embedded 4 clauses canonical:
			1. ANTI-ROUTING-OPTIMIZATION (Phase 5.1 ajuste #4) —
			   protege topology
			2. ANTI-METRIC-GAMING (Phase 5.2 ajuste #6) — protege
			   observability
			3. ANTI-FATIGUE (Phase 5.2 ajuste #5 duplo: inline +
			   central) — protege semantics
			4. ANTI-SELF-EROSION / GOVERNANCE-CANNOT-SELF-WEAKEN
			   (Phase 5.0 + Phase 5.6 ajuste #2 NEW) — protege o
			   próprio sistema imune (4th clause meta-imunological)

			Verification: CONFIRMED.

			===========================================================
			PHASE 4 OBLIGATIONS SATISFIED
			===========================================================

			agent-spec outer rationale Section 10 declared obligations
			cross-referenced (envelope Section 10):
			(1) Autonomy calibration → calibration (5 promotionCriteria
			    + 15 regressionTriggers)
			(2) Observed metrics → driftDetection (15 metrics em 7
			    axes)
			(3) Escalation channels + SLAs → escalationRouting (6
			    entries cobrindo 6 #EscalationCategory; 4 conceptual
			    L1-L4)
			(4) Externalized detection rule packs → declared em
			    escalation #5 suspicious-input rationale (concrete
			    signatures externalized; deferred to Phase 6+ amendment
			    cycles)
			(5) Audit storage configuration → declared em failureHandling
			    rationale + escalation L4 recipient (court-grade per
			    tc-regulatory-evidentiary; Architecture Communication
			    Canvas authority)
			(6) MCM expansion gate clause → mutation classification
			    table row 4 + promotionCriteria #5 + regressionTrigger
			    #6 (90/180-day cycle critical domains)

			Cascade ordering preserved: agent-spec Phase 4.6 declared
			obligations → envelope Phase 5 materialized via schema
			fields + outer rationale clauses.

			Verification: CONFIRMED.

			===========================================================
			SCHEMA SATISFACTION (tq-gv-06..15 + COMPANION CHECKS)
			===========================================================

			tq-gv-06 (agentRef + governanceRef bidirecional): ✓ —
			agentRef='agt-ntf-primary' corresponde a agent-spec.code;
			agent-spec.governanceRef='ntf-primary-agent' corresponde
			a base name deste envelope file (ntf-primary-agent.
			governance.cue).

			tq-gv-07 (escalation routing cobertura): ✓ — 6 routing
			entries cobrindo 6 #EscalationCategory declaradas em
			agent-spec.escalationConditions (ambiguous-case, out-of-
			scope, conflicting-signals, insufficient-context, suspicious-
			input, unclassifiable-anomaly).

			tq-gv-08 (lifecycleStage ∈ taxonomia global): ✓ —
			lifecycleStage='onboarding' válido per #LifecycleStage
			enum.

			tq-gv-09 (blastRadiusCaps ≤ global): N/A em Phase 0 —
			global #AgentGovernanceGlobal não materializado em
			architecture/agent-governance.cue. Forward-ref
			governanceGlobalVersion='0.1' Phase 0 canonical; tq-gv-12
			warn ativa quando global criado e versão divergir. Caps
			deliberadamente conservadoras (1/15 match FCE baseline)
			para não exceder qualquer ceiling reasonable.

			tq-gv-10 (calibration mensurável + time-bounded): ✓ — 5
			promotionCriteria todas com metric + minimumObservationPeriod
			(90/180/365/90/90+180 days); 15 regressionTriggers todas
			com metric + threshold + immediateAction enumerable.

			tq-gv-11 (autonomyOverrides actions válidas): N/A —
			autonomyOverrides ABSENT (Phase 0 strictness per Phase 5.4
			ajuste).

			tq-gv-12 (governanceGlobalVersion match): N/A em Phase 0
			— global não materializado; forward-ref '0.1' canonical.

			tq-gv-13 (autonomyOverrides não expirados): N/A —
			autonomyOverrides ABSENT.

			tq-gv-14 (autonomyOverrides não execute-and-log mutations):
			N/A — autonomyOverrides ABSENT (zero risk de violation).

			tq-gv-15 (unicidade envelope per agentRef): ✓ — único
			ntf-primary-agent.governance.cue no diretório contexts/ntf/
			agents/.

			===========================================================
			FOUNDER AJUSTES INTEGRATED PRE-WRITE (~24 across 7 sub-phases)
			===========================================================

			Phase 5.0 charter (5 ajustes): L4 rename forensic-integrity-
			immediate + MCM 90/180-day distinction + #4 confidence-
			insufficient L1/L2 default + #9 multi-jurisdictional L3 +
			4ª FORBIDDEN provider-claim-as-fact

			Phase 5.1 escalationRouting (4 ajustes): suspicious-input
			sync-human-review exception + unclassifiable-anomaly '24h
			triage start' + ntf-forensic-integrity-reviewer rename +
			anti-routing-optimization clause

			Phase 5.2 driftDetection (6 ajustes): cadence daily +
			asymmetric provenance erosion separate metric + refusal-
			suppression-pressure signal metric + zero-tolerance
			absolute + anti-fatigue duplo + metric gaming clause

			Phase 5.3 calibration (3 ajustes): #5 trigger suspend-and-
			escalate stays + scope-boundary added to critical MCM
			domains + clearanceCondition all-manual

			Phase 5.4 blastRadiusCaps (2 ajustes): maxDailyActions=15
			FCE match + caps-cannot-rise-via-override clause

			Phase 5.5 failureHandling (1 ajuste): rationale rewrite
			'at least comparable to FCE convergence sensitivity'

			Phase 5.6 outer rationale (3 ajustes): 4 FORBIDDEN
			canonical (clean taxonomy) + section 9 governance-cannot-
			self-weaken 4th clause + section 12 SRR-pending temporal
			note

			Total ~24 founder ajustes integrated. Densidade superior
			vs FCE governance envelope (~10 ajustes durante Phase 5)
			reflete NTF constitutional complexity (7 priority axes +
			15 drift metrics + MCM exception class ADR-088 +
			asymmetric provenance ontology + forensic-integrity layer
			+ linguistic drift detection meta-imunológico).

			===========================================================
			VERIFICATION RESULT SUMMARY
			===========================================================

			7 Priority axes coverage: CONFIRMED (Axis 1-7 each verified
			via driftDetection + calibration + mutation classification
			+ canonical clauses).
			4 FORBIDDEN mutations: CONFIRMED (clean taxonomy per Phase
			5.6 ajuste #1).
			4 anti-drift clauses defense in depth: CONFIRMED
			(governance-cannot-self-weaken 4th clause NEW per Phase
			5.6 ajuste #2).
			Phase 4 obligations satisfied: CONFIRMED (6/6 obligations
			materialized).
			Schema tq-gv-06..15 satisfaction: CONFIRMED (intra-file
			+ bidirectional ref agent-spec ↔ envelope verified).
			Family Mesh pattern preservation: CONFIRMED (FCE 876L ↔
			NTF 1188L; same posture canonical, different drift vectors).
			WI-063 NTF bootstrap closure lineage: CONFIRMED (Phase 1
			→ Phase 5 chain documented em outer rationale Section 12).

			cue vet ./... EXIT=0 post-commit (CLEAN). check-self-
			review.sh local: aguardando este SRR commit para PASSED.

			CUE CLI executado pre-commit confirmando schema satisfaction
			(cue vet ./... CLEAN).
			"""
	}]

	findings: {}

	summary: """
		NTF Primary Agent Governance Envelope Phase 5 WI-063 closure.
		1188 linhas materializando 7 priority axes + 6 escalationRouting
		entries (incluindo L4 forensic-integrity-immediate sync-human-
		review exception) + blastRadiusCaps 1/15 (FCE match) +
		autonomyOverrides ABSENT + driftDetection 15 metrics daily
		cadence + calibration 5 promotionCriteria + 15 regressionTriggers
		(5 suspend-and-escalate + 8 reduce-autonomy + 2 revert-to-
		previous-stage) + failureHandling uniform suspend-and-escalate
		(2 failures/1h) + outer rationale 12 sections (mutation
		classification 13 rows com 4 FORBIDDEN + 4 anti-drift clauses
		defense in depth).

		7 priority axes CONFIRMED:
		1. MCM expansion control (ADR-088 anti-creep)
		2. Refusal-rate anti-drift (anti-fatigue + linguistic drift
		   detection meta-imunológico)
		3. Projection non-authority enforcement (OP8 absolute)
		4. Provider-claim distrust calibration (asymmetric + erosion
		   detection)
		5. Replay-forbidden zero leakage (constitutional integrity
		   P8 + C9)
		6. Evidence/staleness governance (temporal substrate hygiene)
		7. Audit/evidentiary integrity (court-grade chain preservation)

		4 FORBIDDEN canonical (clean taxonomy per Phase 5.6 ajuste #1):
		projection-authority + replay-isolation + audit-chain + provider-
		claim-as-fact.

		4 anti-drift clauses (defense in depth):
		anti-routing-optimization + anti-metric-gaming + anti-fatigue
		duplo + governance-cannot-self-weaken (4th clause NEW per
		Phase 5.6 ajuste #2 meta-imunological).

		~24 ajustes founder integrated across 7 sub-phases (Phase 5.0-
		5.6).

		Family Mesh parallel canonical preservado: FCE 876L combats
		institutional pressure (convergence weakening); NTF 1188L
		combats operational pressure (delivery degradation rebranded
		as success). Different drift vectors, same posture canonical.

		WI-063 NTF bootstrap CHAIN CONSUMMATED post-este SRR:
		Phase 1 canvas → Phase 2 glossary → Phase 3 domain-model →
		Phase 4 agent-spec + ADR-088 → Phase 5 governance envelope.
		NTF agora opera under full BC artifact chain.
		"""

	singleRoundRationale: """
		Round único per founder iterative review pre-write integrated
		across 7 sub-phases canonical (Phase 5.0 charter + 5.1
		escalationRouting + 5.2 driftDetection + 5.3 calibration + 5.4
		blastRadiusCaps + 5.5 failureHandling + 5.6 outer rationale)
		com ~24 ajustes finos founder integrated em conversational
		dialog batch-by-batch.

		Densidade de direction founder superior versus FCE governance
		envelope (~10 ajustes durante Phase 5):
		- Phase 5.0 charter (5 ajustes incluindo 4ª FORBIDDEN NEW)
		- Phase 5.1 escalationRouting (4 ajustes incluindo sync-human-
		  review exception canonical + ntf-forensic-integrity-reviewer
		  rename)
		- Phase 5.2 driftDetection (6 ajustes incluindo 2 NEW metrics:
		  asymmetric provenance erosion + refusal-suppression-pressure
		  signal)
		- Phase 5.3 calibration (3 ajustes incluindo scope-boundary
		  added to critical MCM domains)
		- Phase 5.4 blastRadiusCaps (2 ajustes incluindo caps-cannot-
		  rise-via-override clause)
		- Phase 5.5 failureHandling (1 ajuste rationale tone)
		- Phase 5.6 outer rationale (3 ajustes incluindo governance-
		  cannot-self-weaken 4th clause meta-imunological)

		Densidade superior reflete NTF constitutional complexity (7
		priority axes + 15 drift metrics + MCM exception class
		formalization via ADR-088 + asymmetric provenance ontology +
		forensic-integrity layer + linguistic drift detection meta-
		imunológico).

		Each sub-phase revisado por founder antes de progressão ao
		próximo per manualAuthoringProtocol section gates + batch-by-
		batch canonical mode. Final consolidation directive integrated
		3 ajustes Phase 5.6 + outer rationale 12 sections completas
		pre-write.

		Additional rounds não detectariam new findings porque:
		(a) Founder iterative review already integrated all axes de
		    análise (7 priority axes coverage matrix + 4 anti-drift
		    clauses defense in depth + 4 FORBIDDEN constitutional
		    core + mutation classification asymmetric);
		(b) Schema satisfaction verificada por inspeção transversal
		    (tq-gv-06..15) + cue vet ./... EXIT=0 pre-commit (CLEAN);
		(c) ADR-088 schema delta + agent-spec Phase 4.6 obligations
		    Section 10 declared explicit cross-references — envelope
		    Phase 5 materializa via schema fields + outer rationale
		    clauses;
		(d) Family Mesh pattern parallel ao FCE governance envelope
		    provê reference architecture — desvios detectados pre-
		    write via comparison structural com FCE Phase 5 closure
		    (commit 52fb840 WI-043 final closure).

		Phase 5 substantive completeness confirmed by 7-axis +
		mutation classification + anti-drift clauses verification
		framework (founder direction explicit), not by additional
		procedural review.

		Per CLAUDE.md guardrail self-review-check: este SRR cobre
		artifactPath canonical contexts/ntf/agents/ntf-primary-agent.
		governance.cue exclusivamente. Agent-spec.cue + ADR-088 +
		schema delta têm SRRs separados dedicados (srr-ntf-primary-
		agent + srr-adr-088-formalize-mcm-execution-class + srr-agent-
		spec-mcm-execution-class-schema-delta).

		Phase 5.7 SRR closure (este) é último Phase WI-063 NTF
		bootstrap. Post-commit WI-063 chain consummated:
		Phase 1 (11f7f98) + Phase 2 (f7e5832) + Phase 3 (dd832f7 +
		0dde268 + f645905 + 00fc03b) + Phase 4 (afad087 + 18a0dde +
		ab65293 + cd0114d) + Phase 5 (envelope commit + este SRR
		commit).

		Family Mesh canonical preserved: FCE WI-043 closed (commit
		52fb840 governance closure) + NTF WI-063 closure (este +
		envelope). Pattern canonical para future BC bootstraps que
		envolvam constitutional integrity guardian role.
		"""
}
