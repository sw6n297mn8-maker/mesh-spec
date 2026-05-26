package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

economicAssumptionModelLocationDisambiguation: build_time.#SelfReviewReport & {
	reportId: "srr-economic-assumption-model-location-disambiguation"

	artifactPath:       "architecture/artifact-schemas/economic-assumption-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

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
			Aperto do _schema.location.canonicalPathRegex de #EconomicAssumptionModel
			de um glob de colecao (^strategic/economic-model/[a-z0-9-]+\\.cue$) para o
			caminho literal do seu unico arquivo (^strategic/economic-model/mesh-economic-assumptions\\.cue$),
			com fileNameRegex correspondente (^mesh-economic-assumptions\\.cue$).

			Motivo: o regex de colecao casava QUALQUER arquivo na pasta, inclusive
			mesh-economic-mechanisms.cue — que tambem casa o location especifico de
			#EconomicMechanismModel. Resultado: mesh-economic-mechanisms.cue casava 2
			schemas, violando exclusive-match (fileClassification AMBIGUO no runner de
			structural-checks). Alem disso, o glob de colecao era incoerente com
			cardinality: singleton ja declarada — um singleton deve ancorar num caminho
			literal.

			Efeito: mesh-economic-assumptions.cue passa a casar apenas
			#EconomicAssumptionModel; mesh-economic-mechanisms.cue apenas
			#EconomicMechanismModel. AMBIG resolvido; exclusive-match restaurado.

			Mudanca exclusivamente de location (2 linhas). Tipos, quality criteria,
			realityInvariants/adversarialCapabilities/systemImplications e demais defs
			inalterados. Backward compat: a unica instancia existente
			(mesh-economic-assumptions.cue) permanece conformante e ainda casa o regex.
			"""
	}]

	findings: {}

	summary: """
		Correcao de location de #EconomicAssumptionModel: regex de colecao ->
		caminho literal do singleton. Resolve a violacao de exclusive-match em que
		mesh-economic-mechanisms.cue casava tanto #EconomicAssumptionModel quanto
		#EconomicMechanismModel, e alinha o location ao cardinality singleton ja
		declarado. Sem mudanca de tipos ou de instancia.
		"""

	singleRoundRationale: "Correcao estrutural de 2 linhas (canonicalPathRegex + fileNameRegex) com efeito mecanico e verificavel: o arquivo de mechanisms deixa de casar 2 schemas. A instancia unica de assumptions permanece conformante. cue vet confirma; rounds adicionais nao detectariam new findings."
}
