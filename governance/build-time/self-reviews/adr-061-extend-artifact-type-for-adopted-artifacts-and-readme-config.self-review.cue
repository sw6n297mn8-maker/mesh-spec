package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr061: build_time.#SelfReviewReport & {
	reportId: "srr-adr-061"

	artifactPath:       "architecture/adrs/adr-061-extend-artifact-type-for-adopted-artifacts-and-readme-config.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "ADR documenta extensão do enum #ArtifactType com 'adopted-artifacts' e 'readme-config' para fechar gap ontológico revelado por WI-067 (validation-prompts dependentes não-compiláveis). 4 alternativas explicitamente rejeitadas — opção (a) extensão local de #ValidationTargetType foi vetada pelo founder por preservar a inconsistência. Pattern segue adr-047 (extensão para api-specs). decisionClass=structural, reversibility=high, blastRadius=cross-artifact. affectedArtifacts=[quality-criteria.cue]; consumidores existentes (#StructuralCheck instances, CI mapping) não recebem entradas novas — alinhado com adr-060 framing forward-looking. Known gaps declarados: ausência de structural-check para tipos é estado esperado, não defeito."
	}]

	findings: {}

	summary: "ADR-061 fecha gap ontológico via extensão #ArtifactType + abreviation block; desbloqueia WI-067 inteiro (4 prompts) no mesmo commit."

	singleRoundRationale: "Decisão atômica isolada de extensão de enum, pattern já estabelecido (adr-047). Founder explicitamente vetou opção alternativa local-fix. Sem alternativas substantivas adicionais a explorar; round único suficiente."
}
