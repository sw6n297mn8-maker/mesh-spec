package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fctInstance: build_time.#SelfReviewReport & {
	reportId: "srr-first-class-traceability"

	artifactPath:       "architecture/structural-checks/first-class-traceability.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-16"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 -- self-review self-reported (rollout default do quality-gate p/
			structural-check) da instancia sc-fct-01 (kind first-class-traceability,
			enforcement warn). Universais uq-01..09 + type-specific tq-sc-01..03 contra o
			disco. PASS: tq-sc-01 (errorMessage especifico -- nomeia as condicoes: sem
			firstClass nem na worklist, termo dedicado ausente/incorreto, ref de glossario
			quebrado, link Forma B invalido -- e a remediacao acionavel); tq-sc-02 (rule {}
			conforma a #FirstClassTraceabilityRule via uniao discriminada -- defaults
			kernelGlossaryPath + worklistPath); tq-sc-03 (rationale conecta a adr-153/adr-151/
			P12 + o caso concreto Payment-no-FCE, nao tautologico). uq-03: refs resolvem
			(adr-153, adr-151, def-049, def-063, kernel glossary, worklist). uq-08: cue vet
			EXIT=0 + o evaluator validado report-vs-estimativa (48 G2; report vazio
			pos-worklist-seed) -- a instancia produz o comportamento esperado. enforcement warn
			coerente (born-warn, Forma A nao backfillada). 0 fail, 0 warn.
			"""
	}]

	findings: {}

	summary: """
		Instancia sc-fct-01 do gate first-class-traceability (adr-153), enforcement warn.
		Self-review self-reported em 1 round: uq-01..09 + tq-sc-01..03 contra o disco, 0 fail /
		0 warn. A fidelidade da instancia + evaluator foi provada pela validacao
		report-vs-estimativa do bundle (48 G2; report vazio apos a worklist-seed). cue vet
		EXIT=0. Estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: instancia declarativa pequena de #StructuralCheck conformando ao schema (cue
		vet EXIT=0), os 3 tq-sc passando, e o comportamento do gate ja validado empiricamente
		(report-vs-estimativa: 48 G2 -> worklist -> report vazio). Nenhum finding tocou a
		substancia; round unico porque a instancia e declarativa e o evaluator foi validado a
		parte.
		"""
}
