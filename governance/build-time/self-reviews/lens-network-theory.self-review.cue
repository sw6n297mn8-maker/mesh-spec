package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensNetworkTheory: build_time.#SelfReviewReport & {
	reportId: "srr-lens-network-theory"

	artifactPath:       "architecture/lenses/lens-network-theory.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-28"

	roundsExecuted: 1
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 avaliou lente parcial (trigger + 14 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em construção civil, construtoras grandes, fornecedores pequenos, grafo bipartito, camadas financeira/operacional/informacional, dashboard estrutural (uq-02), sem crossDependsOn neste batch (uq-03 pass), sem contradição com design-principles (uq-04), terminologia consistente — bipartito, backbone, betweenness, hub/authority, contágio, resiliência, divergência inter-camada usados consistentemente (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 12 condições testáveis, 5 excludeWhen."
	}]

	findings: {
		fail: [{
			criterion: "uq-08"
			severity:  "fail"
			message:   "Campos obrigatórios do schema #AnalyticalLens ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
	}

	summary: """
		Lente network-theory parcial com trigger (12 condições, 33 keywords,
		5 excludeWhen) e 14 conceitos cobrindo representação em grafo bipartito
		multi-layer, cobertura, janelas temporais, análise bipartida e projeções,
		backbone extraction, centralidade bipartite-aware, assortatividade,
		dependência assimétrica, community detection, divergência inter-camada,
		contágio e cascata, resiliência, dinâmica de crescimento e métricas
		operacionais. Fail estrutural (uq-08) por campos obrigatórios ausentes
		— artefato parcial por decisão do founder. Aguardando demais campos
		obrigatórios.
		"""
}
