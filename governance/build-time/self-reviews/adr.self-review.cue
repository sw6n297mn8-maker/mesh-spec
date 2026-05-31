package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adrSchema: build_time.#SelfReviewReport & {
	reportId: "srr-adr-schema-falsification"

	artifactPath:       "architecture/artifact-schemas/adr.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

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
			Amendment ao schema #ADR (per adr-132, def-032): adiciona campo
			OPCIONAL falsificationCondition?: #FalsificationCondition ao
			#ADRBase — struct mínima {condition, observableSignal} (ambos
			string & !=""). Declarado em #ADRBase, NÃO na união discriminada
			por status, porque struct fechada CUE não admite novos campos via
			união (mesmo motivo arquitetural de supersededBy, já documentado no
			schema). uq-08 PASSED: optional → ADRs existentes sem o campo
			permanecem válidos (backward-compat); cue vet ./... EXIT=0. uq-01
			PASSED: o comentário do campo registra o PORQUÊ (distinção semântica
			vs reversibility/defersTo/supersededBy + razão da declaração em
			base), não o what. uq-04 PASSED: coerente com P12 (base codificável
			da fitness function), P10 (campo registra o sinal; gate determinístico
			futuro valida) e P0 (a hipótese falsificável vive no próprio ADR, não
			duplicada). Escopo deliberadamente mínimo: NENHUM novo _qualityCriteria
			(tq-adr-05) e NENHUM structural-check — o enforcement condicional por
			decisionClass (gate warn→reject) permanece DEFERIDO em def-032 (open),
			evitando aninhar evolução do motor de checks neste amendment. uq-07
			PASSED: zero placeholder. uq-05: limitação declarada — struct v1 não
			modela revisita/cadência (def-034 painel), over-modeling evitado antes
			do consumidor existir.
			"""
	}]

	findings: {}

	summary: """
		Adição do campo opcional falsificationCondition (struct {condition,
		observableSignal}) ao schema #ADR per adr-132/def-032. Campo em
		#ADRBase (constraint de struct fechada, como supersededBy); optional →
		backward-compatible. Sem novo tq-criterion e sem structural-check: o
		gate condicional permanece deferido em def-032 (open). cue vet ./...
		EXIT=0.
		"""

	singleRoundRationale: """
		Amendment atômico de um único campo opcional a schema base maduro, com
		shape (struct 2b), mecanismo (opcional, gate diferido) e escopo
		decididos pelo founder na auditoria de ciclos de feedback. A decisão de
		design precede o self-review; a conformidade é estrutural (cue vet) e a
		ausência de enforcement novo elimina superfície de regressão. Round
		único suficiente.
		"""
}

// ci: re-trigger required checks no head materializado (structure-index regen veio com skip-ci); ref def-032 PR-95

// nota: este SRR complementa adr-schema-affectedartifacts-relax.self-review.cue (review anterior do mesmo schema, adr-059) — ambos cobrem amendments distintos do #ADR.
