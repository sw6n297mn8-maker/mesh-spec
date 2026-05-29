package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr121: build_time.#SelfReviewReport & {
	reportId: "srr-adr-121"

	artifactPath:       "architecture/adrs/adr-121-edge-filter-notequals-operator.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

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
			ADR documenta PR-3 capability: operator notEquals como 3ª
			variante de união discriminada do
			#DirectedAcyclicityRule.edgeFilters. Pattern paralelo a
			adr-120 (operator exists). Família B+ — capability extension
			do framework, sem aplicação concreta neste ADR.

			Tabela de verdade explicitada no ADR + comentário do
			schema: equals/notEquals/exists com semântica per-presença
			documentada (ausente para notEquals = passa vacuously;
			dualidade correta com equals onde ausente = exclui).
			Composição AND com exists:true permite strictness se
			necessária no futuro.

			4 alternativas explicitamente rejeitadas: (a) inverter
			sc-cm-07 inteiro (refactor invasivo); (b) flag boolean
			per relationship (esconde semantic-per-kind); (c) valor
			sentinel via equals (gambiarra); (d) operators present/
			absent separados (redundância com exists: bool).

			4 casos novos no --self-test: sc-g-05 (notEquals diff →
			mantém), sc-g-06 (notEquals igual → exclui), sc-g-07
			(notEquals ausente → mantém vacuously), sc-g-08 (3-operator
			AND composição). Regression dos 4 operators pré-existentes
			coberta por sc-g-01..04 do PR-2.

			Decisão de NÃO usar defersTo: mesma análise adr-118/119/
			120. Este ADR é apenas capability; aplicação que resolve
			def-026/027 é adr-122 (mesmo PR-3); promoção que resolve
			def-028 é adr-123.

			principlesApplied: P0, P1, P12. decisionClass=structural,
			reversibility=high, blastRadius=cross-artifact. cue vet
			./... EXIT=0. Self-test 8 casos PASS.

			Risco categórico em N3: futuro autor de check pode esperar
			notEquals strict (ausente exclui per SQL convention).
			Mitigação: tabela de verdade no schema; sc-g-07 ratifica
			comportamentalmente.

			Pattern paralelo a adr-049/056/063/076/080/117/118/119/120
			— nona extensão orgânica de framework de check.
			"""
	}]

	findings: {}

	summary: """
		ADR-121 adiciona operator notEquals como 3ª variante de união
		discriminada do #DirectedAcyclicityRule.edgeFilters. Capability
		extension Família B+ (paralelo a adr-120 exists). Tabela de
		verdade documentada; absent semantics ratificado em sc-g-07.
		defersTo não usado (def-026/027/028 criados em PR #83
		anterior; resolução substantiva em adr-122/123 mesmo PR-3).
		"""

	singleRoundRationale: """
		Pattern bem-estabelecido (nona extensão orgânica de framework).
		Decisão passou por Fase 1 (reconhecimento + scan completo) +
		Fase 2 (4 alternativas analisadas, semântica absent decidida
		explicitamente per founder direction Q1=α). Self-test 8 casos
		PASS. Round único suficiente.
		"""
}
