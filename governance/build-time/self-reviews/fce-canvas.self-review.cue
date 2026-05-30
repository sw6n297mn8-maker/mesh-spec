package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fceCanvas: build_time.#SelfReviewReport & {
	reportId: "srr-fce-canvas"

	artifactPath:       "contexts/fce/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Canvas FCE (Financial Commitment Execution) — primeira aplicação
			real de P13/adr-125 (boundary-derivation) e do PG canvas
			section-by-section per manualAuthoringProtocol (adr-057), com
			founder gate em cada uma das 9 sections. Self-review integrado
			round-1 sobre o artefato completo para capturar inconsistências
			cross-section. Estrutura: identity (code=fce, purpose articulando
			contorno P11 + 8 BCs adjacentes, ubiquitousLanguageRef forward);
			classification (subdomainType=core cross-checked com
			strategic/subdomains/fce.cue type='core-subdomain' + context-map;
			businessRole=compliance-enforcer; wardleyEvolution=custom);
			verticalApplicability=vertical-agnostic; domainRoles (execution
			primary + gateway secondary — inversão deliberada vs BDG/INV); 4
			capabilities (cc-01 PrePaymentGuard + cc-03 24/7 + financialization
			atômica + Payment ledger/autoridade econômica),
			hasSyncSurface+hasAsyncSurface=true; communication com nomes
			reconciliados (8 inbound + 8 outbound); 9 businessDecisions
			ancoradas em P11/P10/dp-04/dp-05/ax-07/P0; 5 stakeholders
			(sh-01/02/03/04/05) + 3 costsEliminated (ce-03/05/06 match exato
			com subdomain costRefs) + 2 incentive vectors adversariais (sh-05
			operador + sh-06 adversário canonical); ownership 3 autonomous + 4
			supervised + 4 escalation (override-prepayment-guard SEMPRE
			supervised — linha vermelha P10/P11); 5 assumptions + 6
			openQuestions (deadlines ISO) + 7 verificationMetrics (3 control com
			onBreach.escalationRef→governanceScope, 4 observability-only);
			rationale root sintético. Cross-section consistency verificada:
			communication↔flags (tq-cv-06); businessDecisions↔communication;
			governanceScope↔businessDecisions; verificationMetrics↔
			escalationCriteria (3 control→p11-invariant-breach-detected/
			replay-or-double-pay-attempt/prepayment-guard-systemic-failure; 4º
			criterion regulatory-or-juridical-ambiguity acionado por condição
			direta, sem dead path); forward-refs↔openQuestions (glossary/
			api-specs/agent-spec/PaymentObligationDefaulted-em-rew rastreados em
			oq-fce-1..4). Auto-checks tq-cv-01..10 PASSED (purpose justifica
			contorno; sh-NN existem; incentive com manipulationCost; ce-NN
			existem; archetype primário; flags coerentes; governance separa
			auto/supervised; assumptions com invalidationSignal; openQuestions
			com impacto; core com costsEliminated). Decisões deliberadas
			registradas: Opção B budget (sem aggregate BudgetAllocation —
			Payment.commitmentRef→BudgetApproved realiza envelope BDG); sh-06
			adversário canonical aparece em incentiveAnalysis mas não em
			stakeholders (pattern REW WI-046 — adversário modelado em
			incentivos, não como stakeholder convencional); par fce↔tcm
			topologicamente cíclico mas gate-acíclico por events-required filter
			(adr-120). Imprecisão "budget allocation" em fce.cue:11 registrada
			em ten-013 (mesmo PR). 3 drifts PG↔schema surfacados durante
			authoring (businessRole/archetype/derivedFrom — PG catalog diverge
			dos enums/campos do schema) → mini-PR de polish mecânico pós-merge,
			não afetam validade do canvas. cue vet ./contexts/fce/ EXIT=0
			confirmado na materialização; cue vet ./strategic/ EXIT=0 (context-
			map reconciliado adr-126).
			"""
	}]

	findings: {}

	summary: """
		Canvas FCE via manual authoring section-by-section (9 founder gates,
		adr-057); primeira aplicação real de P13/adr-125. Self-review
		integrado round-1: 0 fail, 0 warn. Cross-section consistency
		verificada (flags↔communication, BDs↔governance, metrics↔escalations,
		forward-refs↔openQuestions). Decisões deliberadas: Opção B budget
		(Payment.commitmentRef→BudgetApproved), sh-06 só em incentiveAnalysis
		(pattern REW), fce↔tcm gate-acíclico (adr-120). cue vet EXIT=0
		(contexts/fce/ + strategic/). 3 drifts PG↔schema → mini-PR de polish.
		"""

	singleRoundRationale: """
		Cada uma das 9 sections passou por section-gate auto-check + founder
		confirmation durante authoring (manualAuthoringProtocol); o review
		front-loaded por section deixou ao round integrado apenas a
		verificação de consistência cross-section (communication↔flags,
		BDs↔governance, metrics↔escalationCriteria, forward-refs↔openQuestions),
		que passou sem fail/warn. Round único suficiente; cue vet estrutural
		na materialização confirmou sintaxe (EXIT=0).
		"""
}
