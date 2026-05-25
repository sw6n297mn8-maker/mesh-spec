package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr093SchematizeDesignPrinciples: build_time.#SelfReviewReport & {
	reportId: "srr-adr-093-schematize-design-principles"

	artifactPath:       "architecture/adrs/adr-093-schematize-design-principles.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-093 materializa o passo (i) do cutover do adr-090 para o primeiro
			fundacional: schematizar design-principles.

			Schema satisfaction (#ADR):
			- id "adr-093" (regex ^adr-[0-9]{3}$); proximo livre real (adr-090 e o
			  max no branch; adr-091/092 reservados por branches em flight, evitados
			  per direcao do founder).
			- decisionClass structural (cria tipo + altera superficie de validacao);
			  decider founder; status accepted.
			- tq-adr-01 (alternativas): PASS — context registra a alternativa
			  rejeitada (deixar orfao / tolerar via warn) e remete a rejeicao previa
			  da derivacao-com-gate no adr-090.
			- tq-adr-02 (risco coerente): PASS — reversibility medium + blastRadius
			  cross-artifact, consistentes com a decisao (schema + instancia).
			- tq-adr-03/04 (rastreabilidade): PASS — affectedArtifacts
			  [architecture/design-principles.cue] (existente, refatorado) +
			  plannedOutputs [architecture/artifact-schemas/design-principles.cue]
			  (novo). Disciplina 3-way per adr-059; satisfaz sc-adr-01 (at-least-one).
			- principlesApplied [P0, P12] com identificador + prosa.

			Ponto-chave preservado na decisao: refactor CONTENT-PRESERVING — os 13
			principios (statements + rationales) permanecem byte-a-byte inalterados;
			o ADR nao reabre o merito de nenhum principio. Renomeacao do campo
			top-level (principles -> designPrinciples) registrada em consequences,
			com verificacao de ausencia de consumidor CUE do pacote design_principles.

			cue vet do schema + instancia validado localmente (v0.16.0).
			"""
	}]

	findings: {}

	summary: """
		ADR-093 (structural) registra a schematizacao content-preserving de
		design-principles — passo (i) do cutover adr-090 para o primeiro
		fundacional. 4 criterios tq-adr PASS; rastreabilidade 3-way
		(affectedArtifacts + plannedOutputs); principlesApplied [P0, P12].
		Refactor preserva o conteudo dos 13 principios; apenas adiciona schema +
		location e conforma a instancia.
		"""

	singleRoundRationale: "Decisao de escopo contido (schematizar 1 fundacional, content-preserving) ja sequenciada e justificada no adr-090; este ADR a materializa. Alternativa unica viavel registrada. cue vet validado localmente; rounds adicionais nao detectariam new findings."
}
