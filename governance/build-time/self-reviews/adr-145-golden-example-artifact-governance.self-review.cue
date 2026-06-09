package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr145GoldenExample: build_time.#SelfReviewReport & {
	reportId: "srr-adr-145-golden-example-artifact-governance"

	artifactPath:       "architecture/adrs/adr-145-golden-example-artifact-governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-08"

	roundsExecuted: 1
	maxRounds:      3
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-review isolated-subagent (contexto fresco, separado da autoria) do adr-145 (GoldenExample como
			ArtifactType governado, filho de adr-138). tq-adr-01: 4 alternativas reais com motivo (declaracao-pura
			ESCOLHIDA; evidencia-inline rejeitada por quebrar template-role e inverter evidencia->declaracao;
			arquivo-livre rejeitado por 0 gate; shared-schema leve rejeitado por exigir PG+criterios). tq-adr-02:
			reversibility medium + blastRadius repo-wide justificados (estende #ArtifactType); falsificationCondition
			com condition + observableSignal, e NAO congela a hipotese P1 de adr-138. tq-adr-03/04: affectedArtifacts
			(quality-criteria, production-guide, meta-coverage, wave-plan) + plannedOutputs (schema, PG) verificados
			no disco. Claims factuais checados: adr-138/adr-144 existem; agent-probe-record->targetCanvas e o
			precedente evidencia->declaracao; 0 instancias de golden-example. Item 7 inclui o passo da isencao
			sc-meta-02 (cascade fiel aos 7 arquivos). uq-* pass. Veredito do subagente: APROVADO.
			"""
	}]

	findings: {}

	summary: """
		adr-145 conforma #ADR e formaliza GoldenExample como ArtifactType governado declaracao-pura (filho de
		adr-138). Re-review isolated-subagent APROVADO: alternativas reais, metadata de risco coerente,
		falsificationCondition sem congelar P1, separacao declaracao/evidencia (evidencia->declaracao, padrao
		agent-probe-record), defersTo vazio (escolha de nao-redundancia com o harness WI-137, nao deferimento de
		capacidade). Sem findings fail/warn. cue vet ./... = 0 no parent (o subagente nao tinha CUE CLI).
		"""

	singleRoundRationale: """
		1 round: o re-review isolado verificou tq-adr-01..04 + uq-* e os claims factuais contra o disco sem fail.
		O design fora aprovado pelo founder; o item 6/7 (registro da isencao em sc-meta-02 exemptTypes) so torna a
		escolha de nao-criar-structural-check rastreavel ao ADR. Nada a iterar.
		"""
}
