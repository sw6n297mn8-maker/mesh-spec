package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

productionGuideMetaInstance: build_time.#SelfReviewReport & {
	reportId: "srr-production-guide-meta"

	artifactPath:       "architecture/production-guides/production-guide.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-29T15:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Meta-guide é adaptação MECÂNICA do auster-spec origin/main commit
		2dc4a1e (validado upstream via 3 ciclos de red team em sessão
		2026-04-26). Adaptações: import path mesh-spec; sources cross-repo
		para tekton-spec/portfolio (evita coupling com auster); package,
		variable name, _qualityCriteria, prerequisites, workOrder, sections
		(estrutura), finalValidation preservados verbatim. Materializado
		em 3 commits scaffold→sections→finalValidation (b71a45f, e34c8f1,
		b12325f) com cue vet incremental limpo em cada um. Adoção verbatim
		de schema (b1f6d9b) garante que instância valida contra
		#ProductionGuide. Backfill de governance: este self-review é
		formal pós-commit, mas conteúdo herda validação upstream. Critério
		de estabilização em 1 round: conteúdo substantivo herdado de
		artefato pré-validado + zero findings novos.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Auto-avaliação contra 14 critérios (uq-01..08 universais +
			tq-pg-01..06 type-specific). uq-01: rationale do _qualityCriteria
			explica WHY (4 falhas estruturais previstas + hardening warn→fail
			onde fabricação é risco crítico); rationale de _schema.location
			explica WHY (fecha meta-recursão localmente em mesh). uq-02:
			ancoragem mesh via tq-as-05 cross-repo e referência à promoção
			FP-02 upstream tekton. uq-03: target "#ProductionGuide" existe
			no schema mesh-local; sources cross-repo para tekton-spec/portfolio
			(business-case.base, repo-bootstrap-plan, claude-config) verificados
			existentes em /home/user/tekton-spec/portfolio/production-guides/.
			uq-04: zero contradição com design principles; P0 honrado
			(guide é localização canônica única). uq-05: limitações declaradas
			no rationale do _qualityCriteria (severities hardened deliberadamente).
			uq-06: terminologia consistente (production guide / guide /
			schema / artifact-schema). uq-07: zero placeholder pós-commit
			3/3. uq-08: shape #ProductionGuide satisfeito (cue vet limpo
			3 vezes consecutivas). tq-pg-01: workOrder ["target-and-prerequisites",
			"sections-and-workorder", "validation-and-meta"] === keys(sections),
			permutação exata sem duplicatas/omissões. tq-pg-02: todas as 3
			sections.target = "#ProductionGuide" (válido no schema adotado).
			tq-pg-03: doneCriteria avaliáveis em todas as sections (condições
			verificáveis, não aspiracionais). tq-pg-04: prerequisites.gapPolicy
			com 800+ runes E declara explicitamente "NÃO crie", "NÃO invente",
			"NÃO infira", "NÃO copie". tq-pg-05: finalValidation.steps[-1] =
			"Submeter ao founder para aprovação antes de commit." tq-pg-06:
			process[].action começam com verbos imperativos concretos
			(Identificar, Ler, Coletar, Compor, Avaliar, Verificar). Zero
			findings em qualquer severidade.
			"""
	}]

	findings: {}

	summary: "Meta-guide instância estável no round 1 com 0 findings. Adaptação mecânica de auster origin/main commit 2dc4a1e (3 ciclos red team upstream). 14 critérios (uq-01..08 + tq-pg-01..06) satisfeitos: workOrder permutação exata de keys(sections); targets resolvem para #ProductionGuide; gapPolicy com cláusulas anti-invenção explícitas; finalValidation termina em founder approval."
}
