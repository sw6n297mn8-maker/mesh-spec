package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

drcCanvas: build_time.#SelfReviewReport & {
	reportId: "srr-drc-canvas"

	artifactPath:       "contexts/drc/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-30"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Canvas DRC (Disputes, Reversals & Corrections) — segunda aplicação
			de P13/adr-125, primeira em modo BATCH (9 sections integradas de uma
			vez, sem section-by-section gate). Self-review integrado round-1
			sobre o artefato completo para capturar inconsistências cross-section.
			Estrutura: identity (code=drc, purpose articulando contorno de exceção
			+ 3 BCs adjacentes cmt/fce/ctr, ubiquitousLanguageRef forward);
			classification (subdomainType=supporting cross-checked com
			strategic/subdomains/drc.cue type='supporting-subdomain';
			businessRole=operational-enabler — viabiliza recovery, não enforça
			invariante categórica, ≠ compliance-enforcer FCE; wardleyEvolution=
			product); verticalApplicability=vertical-agnostic; domainRoles
			(execution primary + ANALYSIS secondary — distinção real vs gateway do
			FCE: DRC avalia disputa contra evidência); 3 capabilities (lifecycle
			de disputa local + cc-04 audit + resolução ancorada em evidência),
			hasSyncSurface+hasAsyncSurface=true; communication (6 event-consumers:
			cmt ×2, dlv ×2, ctr ×2 + 1 query-surface QueryDisputeStatus; 3
			event-publishers + 2 query-dependencies ctr); 5 businessDecisions
			(dispute-lifecycle-separate, resolution-requires-evidence [invariante
			própria, mech-evidence], decides-reversal-not-executes,
			applies-penalty-not-defines, material-resolution-human-gated [threshold
			= input upstream, anti escalation-bypass]); 4 stakeholders
			(sh-01/02/04/05) + 2 incentive vectors adversariais (sh-06 disputa
			frívola/delay attack + par sh-01↔sh-02 disputa-como-leverage); 2
			costsEliminated (ce-02 + ce-03, espelho bdg — encaixe defensável mas
			NÃO dispute-specific, ce-08 candidato futuro registrado na contribution);
			ownership 3 autonomous + 4 supervised + 4 escalation (INVERSÃO vs FCE:
			default da resolução é SUPERVISÃO, não autonomia — P10, julgamento
			não-categórico); 4 assumptions + 4 openQuestions (deadlines ISO,
			incluindo oq-drc-4 reconciliação drc-to-fce no canvas FCE como WI
			futuro mesmo padrão WI-043) + 4 verificationMetrics (2 control
			[resolution-without-evidence→evidence-insufficient-or-conflicting;
			material-dispute-auto-resolved→material-dispute-threshold-exceeded] +
			2 observability-only); rationale root sintético. Cross-section
			consistency verificada: communication↔flags (sync query-surface +
			query-dependency, async event-consumer/publisher → tq-cv-06);
			businessDecisions↔communication (bd-decides-reversal↔
			FinancialCompensationOrdered; bd-applies-penalty↔QueryContractClauses);
			governanceScope↔businessDecisions (resolve-material-dispute supervised
			↔ bd-material-resolution-human-gated); verificationMetrics↔
			escalationCriteria (2 control→escalationCriteria existentes; metrics
			observability sem dead path; 2 escalation [suspected-dispute-fraud,
			regulatory-deadline-at-risk] acionadas por condição direta);
			forward-refs↔openQuestions (glossary/agent-spec/api-specs/drc-to-fce
			rastreados em oq-drc-1..4). Auto-checks tq-cv-01..10 PASSED:
			tq-cv-10 (supporting exige costsEliminated) satisfeito com ce-02+ce-03
			apesar do subdomain drc não declarar costRefs — encaixe via precedente
			bdg, nota ce-08 futura na contribution. Decisões deliberadas: cc-04
			como ref local (subdomain sem capabilityRefs, pattern INV/BDG); sh-06
			em incentiveAnalysis (pattern REW WI-046); ciclo cmt↔drc conforma a
			bidirectional-orchestration já canônico (adr-122 W1), não deriva kind
			novo. Sem 5º drift PG↔schema (enums pós-#89 corretos: businessRole 4
			valores, #Archetype 6 valores). cue vet ./contexts/drc/ EXIT=0
			confirmado na materialização.
			"""
	}]

	findings: {}

	summary: """
		Canvas DRC via authoring BATCH (segunda aplicação de P13/adr-125,
		primeira em batch). Self-review integrado round-1: 0 fail, 0 warn.
		Cross-section consistency verificada (flags↔communication,
		BDs↔governance, metrics↔escalations, forward-refs↔openQuestions).
		Invariante própria: bd-resolution-requires-evidence (mech-evidence).
		INVERSÃO de governança vs FCE: resolução material é supervised por
		default (P10). Ciclo cmt↔drc conforma a bidirectional-orchestration
		(adr-122). costsEliminated ce-02+ce-03 (espelho bdg, ce-08 futuro).
		cue vet EXIT=0.
		"""

	singleRoundRationale: """
		Modo batch: as 9 sections foram autoradas integradas e revisadas em
		round-1 único sobre o artefato completo — a verificação cross-section
		(communication↔flags, BDs↔governance, metrics↔escalationCriteria,
		forward-refs↔openQuestions, tq-cv-10 com subdomain sem costRefs) passou
		sem fail/warn. DRC é supporting enxuto (subdomain sem strategicProfile/
		mech/cost/capability refs), menor blast radius que o FCE; o batch é
		justificado pelo pre-flight (score 3 batch / 2 section-by-section).
		Round único suficiente; cue vet estrutural na materialização confirmou
		sintaxe (EXIT=0).
		"""
}
