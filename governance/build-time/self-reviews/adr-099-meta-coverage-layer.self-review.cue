package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr099MetaCoverageLayer: build_time.#SelfReviewReport & {
	reportId: "srr-adr-099-meta-coverage-layer"

	artifactPath:       "architecture/adrs/adr-099-meta-coverage-layer.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-099 (camada de meta-cobertura: M1 evaluator-coverage +
			M2 structural-check-coverage), cujo design foi aprovado pelo founder antes
			da escrita (incluindo a escolha de DERIVAR o conjunto de tipos em vez de
			autorar). Confirmacoes:

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted" (nao-superseded);
			decisionClass "structural" coerente (2 kinds + 2 rule shapes no schema, 2
			evaluators no runner, 2 instancias); reversibility "medium" + blastRadius
			"repo-wide". tq-adr-01: 2 alternativas rejeitadas com motivo (autorar a
			lista de tipos = drift estilo coveredSchemas; hardcode no runner = debito
			estilo GOVERNED_ELSEWHERE). affectedArtifacts = 3 paths reais e alterados.

			(b) Distincao COBERTURA vs ADEQUACAO registrada explicitamente (P10/ten-006):
			M1/M2 mecanizam cobertura (decidivel); adequacao fica na camada advisory.
			Evita falsa confianca de que um gate prova suas proprias regras.

			(c) Verificacao empirica antes da proposta: cue vet ./... EXIT 0; runner
			--self-test PASS; runner default → sc-meta-01 verde (0 kinds sem evaluator),
			sc-meta-02 lista ~30 tipos sem check comportamental, ambos enforcement warn
			=> TOTAL sobe para 51 com 0 BLOQUEANTES, exit 0. Born-warn nao quebra o CI.

			(d) Escopo negativo respeitado: promocao a reject, M3 (liveness do
			workflow) e a pre-condicao de cascata (tipo novo nasce coberto) ficam como
			follow-on declarado — esta decisao entrega so a visibilidade.

			(e) Fixpoint articulado: M1/M2 rodados pelo mesmo runner com o mesmo
			conjunto de evaluators que verificam; recursao termina em nucleo pequeno
			auditavel (analogo ao mapa auto-desenhado do adr-090).
			"""
	}]

	findings: {}

	summary: """
		adr-099 conforma a #ADR e registra a decisao (aprovada pelo founder) de criar
		a camada de meta-cobertura: M1 (evaluator-coverage, rule→robo) e M2
		(structural-check-coverage, tipo→check com conjunto DERIVADO + exemptTypes),
		ambos born-warn. Distingue COBERTURA (mecanizada aqui) de ADEQUACAO (camada
		advisory, P10). Sem findings fail/warn. Verificacao: M1 verde, M2 lista ~30
		tipos, 0 bloqueantes, exit 0.
		"""

	singleRoundRationale: """
		Uma rodada basta: o design (M1/M2, derivar-nao-autorar, born-warn, escopo
		negativo) foi proposto e aprovado pelo founder explicitamente antes da escrita,
		e a verificacao (cue vet, self-test, inventario, 0 bloqueantes) e deterministica
		e passou. Sem espaco de decisao aberto a red-team adicional.
		"""
}
