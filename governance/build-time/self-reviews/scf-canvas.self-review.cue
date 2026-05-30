package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

scfCanvas: build_time.#SelfReviewReport & {
	reportId: "srr-scf-canvas"

	artifactPath:       "contexts/scf/canvas.cue"
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
			Canvas SCF (Supply Chain Finance) — terceira aplicação de P13/adr-125
			(N=3), segunda em section-by-section (9 founder gates per
			manualAuthoringProtocol adr-057). Self-review integrado round-1 sobre
			o artefato completo para cross-section consistency. Estrutura:
			identity (code=scf, purpose articulando estruturação-de-produto + 7
			adjacents/ext, contrafactual dp-02, boundary funding/securitização);
			classification (subdomainType=supporting cross-checked com
			strategic/subdomains/scf.cue type='supporting-subdomain' + registry;
			businessRole=REVENUE-GENERATOR — primeiro BC revenue surface, decisão
			consciente vs operational-enabler ancorada dp-02; wardleyEvolution=
			product); verticalApplicability=vertical-agnostic; domainRoles
			(SPECIFICATION primary + analysis secondary — inversão deliberada vs
			FCE execution); 3 capabilities (estruturação de produto local +
			composição de elegibilidade local + cc-05 preparação de portfólio,
			ref tailor-made bearer sh-03), hasSyncSurface+hasAsyncSurface=true;
			communication (9 event-consumers: inv ×1, rew ×2 reconciliado, fce ×1,
			ctr ×2, ins ×3 forward-ref; 1 query-surface QueryPortfolioEligibility
			consumer sh-03 EXTERNO schema-conforme precedente DLV
			QueryEvidenceLedger; 2 event-publishers→ato conformist forward-ref; 4
			query-deps rew×2/ctr/fce); 6 businessDecisions (advance-requires-
			verified-receivable [P11 instância], eligibility-multi-source-
			composition [invariante PRÓPRIA S1 teste-b], structures-not-executes
			[anti-FCE], consumes-risk-not-models [anti-REW], structuring-not-
			funding-guarantee [honestidade, cristaliza ortogonalidade revenue-
			generator], prepares-portfolio-not-administers-fund [anti-ext/CVM]); 4
			stakeholders (sh-03 funding partner central + sh-02 + sh-01 + sh-04) +
			2 costsEliminated (ce-07 bearer=sh-03 ENCAIXE DIRETO via cc-05 + ce-06
			bearer=sh-02, SCF-specific por construção não espelho genérico) + 2
			incentive vectors adversariais (sh-06 fraude de lastro + sh-03 seleção
			adversa, mesmo stakeholder beneficiário E vetor — paralelo INV);
			ownership 3 autonomous + 4 supervised + 4 escalation (padrão
			INTERMEDIÁRIO entre FCE autônomo e DRC supervisionado; override-
			eligibility SEMPRE supervised — linha vermelha P10/P11; securitização
			supervised — CVM nível 1); 5 assumptions + 5 openQuestions (deadlines
			ISO) + 6 verificationMetrics (3 control→escalationCriteria S8: lastro-
			fraud-rate→lastro-fraud-suspected, cross-source-inconsistency-rate→
			cross-source-inconsistency-persistent, funding-adverse-selection-ratio
			→funding-adverse-selection-detected; 3 observability-only); rationale
			root sintetizando a coerência econômica (produto commodity + moat
			upstream + SCF revenue surface; spread comprime porque lastro é
			verificável, não porque produto é único). Cross-section consistency
			verificada: communication↔flags (tq-cv-06); BDs↔communication;
			governanceScope↔BDs; verificationMetrics↔escalationCriteria (3
			control→S8, 4º securitization-regulatory por condição direta sem dead
			path); vetores S7↔escalation S8 (sh-06+sh-03 mapeados); forward-refs↔
			openQuestions (ext-securitization-admin oq-scf-1, ins oq-scf-2, ato
			oq-scf-3, glossary oq-scf-4, agent-spec/api-specs oq-scf-5). Auto-checks
			tq-cv-01..10 PASSED, incl. tq-cv-10 (supporting exige costsEliminated)
			com ce-06/07 encaixe direto. Sem 5º drift PG↔schema (enums pós-#89
			corretos; cc-05 existe). Decisões deliberadas: businessRole revenue-
			generator (ortogonalidade supporting↔revenue, eixos diferenciação vs
			captura de valor); QueryPortfolioEligibility consumer externo sh-03
			schema-conforme; sem ADR de invariante (P11 instância, não princípio
			novo — como DRC). rew-to-scf reconciliação naming+shape (espelho
			adr-126, 1 edge, adr-130). cue vet ./contexts/scf/ + ./strategic/
			EXIT=0 confirmado na materialização.
			"""
	}]

	findings: {}

	summary: """
		Canvas SCF via section-by-section (9 founder gates, adr-057); terceira
		aplicação de P13 (N=3). Self-review integrado round-1: 0 fail, 0 warn.
		Cross-section consistency verificada (flags↔communication, BDs↔governance,
		metrics↔escalations, vetores S7↔escalation S8, forward-refs↔openQuestions).
		Decisões deliberadas: businessRole revenue-generator (1º revenue surface),
		archetype specification, sem ADR de invariante (P11 instância como DRC),
		QueryPortfolioEligibility consumer externo sh-03. costsEliminated ce-06/07
		encaixe direto (não espelho). rew-to-scf naming+shape (espelho adr-126,
		adr-130). cue vet EXIT=0.
		"""

	singleRoundRationale: """
		Cada uma das 9 sections passou por section-gate auto-check + founder
		confirmation durante authoring (manualAuthoringProtocol); o review
		front-loaded por section deixou ao round integrado apenas a verificação
		de consistência cross-section (communication↔flags, BDs↔governance,
		metrics↔escalationCriteria, vetores adversariais S7↔escalation S8,
		forward-refs↔openQuestions), que passou sem fail/warn. SCF supporting com
		fronteiras bem-declaradas (7 negativeBoundaries); risco concentrado na S5
		(reconciliação rew-to-scf + forward-refs + ext-system), tratado com gate
		dedicado section-by-section. Round único suficiente; cue vet estrutural
		na materialização confirmou sintaxe (EXIT=0).
		"""
}
