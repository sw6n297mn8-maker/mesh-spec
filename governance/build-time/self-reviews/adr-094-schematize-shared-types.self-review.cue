package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr094SchematizeSharedTypes: build_time.#SelfReviewReport & {
	reportId: "srr-adr-094-schematize-shared-types"

	artifactPath:       "architecture/adrs/adr-094-schematize-shared-types.cue"
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
			ADR-094 materializa o passo (i) do cutover adr-090 para o 2º
			fundacional (shared-types), registrando a exceção conceitual.

			Schema satisfaction (#ADR):
			- id "adr-094" (próximo livre real; adr-093 é o max no branch após o
			  commit anterior; adr-091/092 reservados por branches em flight).
			- decisionClass structural; decider founder; status accepted.
			- tq-adr-01 (alternativas): PASS — registra a alternativa rejeitada
			  (excluir shared-types/ via repo-structure) e por que é pior (desviaria
			  da sequência + exigiria emendar def-018).
			- tq-adr-02 (risco coerente): PASS — reversibility medium + blastRadius
			  cross-artifact, coerentes com alteração do contrato estrutural.
			- tq-adr-03/04 (rastreabilidade): PASS — affectedArtifacts com 3 paths
			  (o schema novo + os 2 shared-types que passam a ser classificados por
			  ele, per direção do founder). Todos reais (schema criado como output
			  direto; os 2 já existem). Satisfaz sc-adr-01 (at-least-one).
			- principlesApplied [P0, P12].

			Pontos-chave registrados per regras do founder: (1) shared-types.cue é
			location/convention schema, NÃO instance-shape — explícito no decision
			e no rationale; (2) por que a exceção é aceita — manter sequência
			adr-090/def-018 e eliminar órfão sem redesenhar shared-types; (3) defs
			não tocadas; (4) affectedArtifacts inclui os 2 shared-types porque o ADR
			altera o contrato estrutural (passam a ser classificados pelo schema).

			cue vet do schema validado localmente (v0.16.0).
			"""
	}]

	findings: {}

	summary: """
		ADR-094 (structural) registra a schematização de shared-types via
		location/convention schema (exceção conceitual explícita) — passo (i) do
		cutover adr-090 para o 2º fundacional. 4 critérios tq-adr PASS;
		affectedArtifacts com os 3 paths (schema + 2 shared-types reclassificados);
		principlesApplied [P0, P12]. Defs não redesenhadas.
		"""

	singleRoundRationale: "Decisão de escopo contido (location/convention schema, defs intocadas) sequenciada em adr-090; este ADR a materializa registrando a exceção conceitual. Alternativa (excluir via repo-structure) avaliada e rejeitada no context. cue vet validado localmente; rounds adicionais não detectariam new findings."
}
