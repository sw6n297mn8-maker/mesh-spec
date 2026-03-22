package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr025: build_time.#SelfReviewReport & {
	reportId: "srr-adr-025"

	artifactPath:       "architecture/adrs/adr-025-dependsonphases-and-governance-ci.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-21"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Avaliação contra 11 critérios (8 universais + 3 type-specific).
			uq-01: rationale explica por que dependência positiva é mais
			robusta que exceção negativa (why, não what). Pass.
			uq-02: referencia mecanismos Mesh-specific (P12 governance-as-code,
			dependsOnPhases no work-graph, CI de work-events). Pass.
			uq-03: ADR-024, P12, P0, P8, work-governance.cue — todos existem. Pass.
			uq-04: P12 (CI validation), P0 (events como SoT), P8 (projeções
			derivadas) — decisão alinhada. Pass.
			uq-05: warn — consequences negativas mencionam semântica condicional
			mas não explicitam que o algoritmo de readiness muda. Encontrado
			durante Red Team Round 3. Correção: adicionar na decision a regra
			operacional de interpretação.
			uq-06: terminologia consistente (dependsOnPhases, phases, work-events). Pass.
			uq-07: zero placeholders. Pass.
			uq-08: todos os campos obrigatórios de #ADR presentes e tipados. Pass.
			tq-adr-01: alternativa independentOf documentada com justificativa
			de rejeição (exceção negativa, difícil de ler, fácil de esquecer). Pass.
			tq-adr-02: reversibility high (extensão de schema + arquivos novos,
			revertível sem impacto em dados persistidos); blastRadius cross-cutting
			(afeta work-graph, 5 WI streams, projeções). Consistente. Pass.
			tq-adr-03: 13 paths em affectedArtifacts — 2 existem
			(work-governance.cue, work-graph.cue), 11 serão criados neste commit. Pass.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-avaliação após correção do warn de uq-05: decision agora inclui
			explicitamente que o algoritmo de readiness resolve por dependsOnPhases
			quando presente e por order como fallback. Consequences negativas
			detalham a semântica condicional. Todos os 11 critérios passam sem
			findings. Estável.
			"""
	}]

	findings: {}

	summary: """
		ADR-025 registra duas decisões acopladas: (1) extensão de #Phase
		com dependsOnPhases para dependência positiva explícita entre
		phases, e (2) criação de 5 WIs de governança CI em duas phases
		independentes do domínio. Warn em round 1 (uq-05: algoritmo de
		readiness não explícito na decision) corrigido em round 2.
		Estável após 2 rounds.
		"""
}
