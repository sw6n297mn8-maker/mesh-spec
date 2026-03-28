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

	status: "stable"

	singleRoundRationale: "Lente completa com 14 conceitos, 13 reasoning steps, 3 meshExamples, 6 principleIds, 6 relatedLenses e 6 limitations. Round 1 identificou zero fail e 1 warn (uq-03: 1 de 6 relatedLenses é forward reference). Todos os campos obrigatórios do schema presentes. Conteúdo fornecido integralmente pelo founder em 3 entregas parciais."

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 1 avaliou lente completa (trigger + 14 concepts + 13 reasoning steps + 3 examples + 6 principleIds + 6 relatedLenses + 6 limitations). uq-01 pass: rationales explicam WHY. uq-02 pass: meshManifestation ancorado em construção civil, construtoras grandes, fornecedores pequenos, grafo bipartito, camadas financeira/operacional/informacional, dashboard estrutural, São Paulo, concreto, climatização, hidráulica. uq-03 warn: principleIds ax-05, ax-06, ax-07, dp-02, dp-05, dp-09 todos existem em domain-definition.cue; 5 de 6 relatedLenses existem (lens-credit-risk, lens-mechanism-design, lens-information-economics, lens-supply-chain-theory, lens-complex-adaptive-systems); 1 forward reference (lens-platform-dynamics). uq-04 pass: sem contradição com design-principles. uq-05 pass: 6 limitações com alternativas e rationale. uq-06 pass: terminologia consistente — bipartito, backbone, betweenness, hub/authority, contágio, resiliência, divergência inter-camada, SPOF usados consistentemente. uq-07 pass: zero placeholders. uq-08 pass: todos os campos obrigatórios presentes. tq-ln-01 pass: 12 condições testáveis, 5 excludeWhen. tq-ln-02 pass: 13 reasoning steps cobrindo decisão motivadora, cobertura, backbone, representação, camada/janela, comunidades, centralidade, dependência assimétrica, divergência, contágio, resiliência, crescimento e fechamento de loop. tq-ln-03 pass: 3 exemplos concretos (critical node detection, dual-layer divergence, network-guided acquisition). tq-ln-04 pass: 6 limitações reais incluindo bootstrap, cobertura parcial, snapshots temporais, cascata sem intervenção, ferramentas bipartite-native e heavy-tailed distributions."
	}]

	findings: {
		warn: [{
			criterion: "uq-03"
			severity:  "warn"
			message:   "1 de 6 relatedLenses (lens-platform-dynamics) é forward reference — arquivo não existe ainda no repo. Padrão consistente com outras lenses."
		}]
	}

	summary: """
		Lente network-theory completa com 14 conceitos (13 theoretical + 1
		operational quarterly), trigger (12 condições, 33 keywords, 5
		excludeWhen), 13 reasoning steps, 3 meshExamples (critical node
		detection, dual-layer divergence, network-guided acquisition), 6
		principleIds verificados, 6 relatedLenses e 6 limitations. Stable
		em 1 round. Warn (uq-03) por 1 forward reference em relatedLenses
		(lens-platform-dynamics).
		"""
}
