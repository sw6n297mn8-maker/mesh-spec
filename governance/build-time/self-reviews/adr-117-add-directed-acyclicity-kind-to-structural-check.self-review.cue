package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr117: build_time.#SelfReviewReport & {
	reportId: "srr-adr-117"

	artifactPath:       "architecture/adrs/adr-117-add-directed-acyclicity-kind-to-structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-28"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR documenta extensão do framework #StructuralCheck com kind
			'directed-acyclicity' (18 → 19 kinds). Pattern paralelo a
			adr-049 (conditional-file-presence), adr-056 (production-
			guide-coverage), adr-063 (filesystem-path-exists), adr-076
			(at-least-one-block-present), adr-080 (domain-invariant).

			4 alternativas explicitamente rejeitadas: (a) kind dedicado
			context-map-acyclicity hard-coded; (b) kind genérico
			directed-acyclicity ESCOLHIDO; (c) advisory via
			validation-prompt; (d) OR-composto em edgeFilters (YAGNI
			deliberado para v1). Decisão da Opção C alinhada com pattern
			dos 17 kinds existentes que generalizam por path/glob
			declarativo (exceto domain-invariant que é narrow por
			design).

			Descoberta arquitetural durante o desenho (sessão 2026-05-28):
			schema #BaseRelationship carrega discriminador 'direction'
			(union upstream-downstream | mutual-dependency) fixado por
			união discriminada. Filtro por direction é mais robusto que
			enumerar patterns simétricos {partnership, shared-kernel} —
			evolução do schema fica auto-compatível com o check.
			Documentada no ADR como item de calibração.

			Aplicação imediata no mesmo commit: sc-cm-07 (primeiro
			consumidor do kind) born-warn. Evaluator + helper +
			self-test (4 casos sintéticos) materializados no runner.

			Diagnóstico empírico documentado: 4 ciclos pré-existentes
			no grafo atual (drc↔cmt, fce↔tcm, cmt→rew→dlv→bdg→cmt,
			fce→drc→cmt→rew→fce). Justifica enforcement=warn (catraca
			adr-097); promoção para reject ocorrerá em ADR follow-on
			quando os ciclos forem resolvidos em PRs de modelagem
			separados (decisão DDD que cabe ao founder).

			Known gaps declarados em prose (não viram def-XXX agora
			porque critério de revisita não é machine-evaluable de
			forma simples):
			- Resolução dos 4 ciclos pré-existentes (trigger seria
			  'ciclo resolvido', depende de critério DDD humano);
			- Reporte mais sofisticado (SCC via Tarjan; edge label
			  configurável) — sem caso concreto que justifique agora.

			principlesApplied: P0, P1, P10, P12. decisionClass=
			structural, reversibility=high, blastRadius=cross-artifact.
			affectedArtifacts: 3 (schema, runner, sc-cm structural-checks).
			plannedOutputs: 1 (sc-cm-07 já materializado neste commit).
			defersTo: vazio. supersedes: vazio. cue vet ./... EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		ADR-117 adiciona kind directed-acyclicity (18→19 kinds) +
		materializa sc-cm-07 (primeiro consumidor) born-warn + documenta
		4 ciclos pré-existentes como evidência. Pattern paralelo a
		adr-049/056/063/076/080. Opção C (genérico) escolhida sobre A
		(dedicado) por alinhamento com 17 kinds existentes que
		generalizam por path declarativo.
		"""

	singleRoundRationale: """
		Pattern bem-estabelecido (6ª extensão de structural-check kind;
		precedentes adr-049/056/063/076/080). Decisão passou por 3 ciclos
		de calibração antes da escrita: propose (Opção C), refinamento
		(filtro por direction em vez de enumeração de patterns), e
		diagnóstico empírico (4 ciclos reportados antes do check ser
		ativado). Round único suficiente.
		"""
}
