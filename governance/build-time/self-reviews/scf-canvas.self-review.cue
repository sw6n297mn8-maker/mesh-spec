package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

scfCanvas: build_time.#SelfReviewReport & {
	reportId: "srr-scf-canvas"

	artifactPath:       "contexts/scf/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-01"

	roundsExecuted: 2
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
			classification (subdomainType=supporting; businessRole=REVENUE-GENERATOR;
			wardleyEvolution=product); verticalApplicability=vertical-agnostic;
			domainRoles (SPECIFICATION primary + analysis secondary); 3 capabilities;
			communication (9 event-consumers; 1 query-surface; 2 event-publishers→ato
			conformist; 4 query-deps); 6 businessDecisions; 4 stakeholders + 2
			costsEliminated + 2 incentive vectors adversariais (sh-06 + sh-03);
			ownership 3 autonomous + 4 supervised + 4 escalation; 5 assumptions + 5
			openQuestions + 6 verificationMetrics; rationale root. Auto-checks
			tq-cv-01..10 PASSED. cue vet ./contexts/scf/ + ./strategic/ EXIT=0.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 (2026-06-01, correção pf-scf-1 via adr-137 — disbursement scf→fce).
			Edits: (a) communication.outbound ReceivableAdvanceOriginated consumers
			["ato"] → ["ato","fce"] (description nota que o FCE consome para executar o
			disbursement, aresta scf-to-fce); (b) reframe de bd-structures-not-executes
			SEPARANDO explicitamente o CANAL de execução (sempre FCE; SCF nunca move
			dinheiro nem toca rails) da FONTE de capital (variável: próprio sob
			receita+autorização BC / parceiro para diluir risco; escolha+risco+guard
			deferidos a def-036); (c) +oq-scf-6 (escolha da fonte / regime de risco /
			impacto no PrePaymentGuard → defersTo def-036).
			Verificação de não-regressão cross-section: o reframe NÃO quebra
			bd-structuring-not-funding-guarantee (estruturar ≠ fondar) nem as-scf-5
			(estruturação e funding desacoplados) — ao contrário, a dimensão fonte-de-
			capital REFORÇA ambos (a fonte é o eixo separado que eles já anteviam). A
			aresta scf→fce torna verdadeira a cláusula "o que o FCE executará downstream"
			que antes não tinha canal (era a contradição pf-scf-1). Re-checados uq-03
			(consumer fce + oq-scf-6 → def-036 existem no PR), uq-04 (P0 canal único de
			execução; sem novo modelo de pagamento no SCF), uq-07 (zero placeholder),
			uq-08 (cue vet EXIT=0). Sem novos findings.
			"""
	}]

	findings: {}

	summary: """
		Canvas SCF via section-by-section (9 founder gates, adr-057); terceira
		aplicação de P13 (N=3). Round 1: 0 fail/warn (cross-section consistency).
		Round 2 (2026-06-01): correção pf-scf-1 (adr-137) — aresta scf→fce no
		disbursement (consumers +fce), reframe de bd-structures-not-executes
		separando canal (sempre FCE) de fonte (variável, def-036), +oq-scf-6. Sem
		quebra de bd-structuring-not-funding-guarantee / as-scf-5 (reforçados).
		Estável; zero findings em ambos os rounds. cue vet EXIT=0.
		"""
}
