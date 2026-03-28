package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensTheoryOfFirm: build_time.#SelfReviewReport & {
	reportId: "srr-lens-theory-of-firm"

	artifactPath:       "architecture/lenses/lens-theory-of-firm.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-28"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 avaliou lente parcial (trigger + 18 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em BaaS, providers de IA, registradoras, bureaus, administradores fiduciários, Pix, SLA, LGPD, SCD, construção civil, modelos calibrados, embeddings, workflows, Mesh AI-native, cessão, banking (uq-02), dependsOn internos consistentes (uq-03 pass), sem contradição com design-principles (uq-04), terminologia consistente — custos de transação, coordenação interna, oportunismo, hold-up, especificidade, complementaridade, direitos residuais, dependência bilateral, racionalidade limitada, contratos incompletos, governança híbrida, ambiente institucional, escala mínima, capacidade, switching cost, portabilidade, optionality, assimetria de erro, boundary map (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 13 condições testáveis, 6 excludeWhen."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 avaliou lente completa com todos os campos. uq-01 pass: rationales explicam WHY em concepts, reasoningProtocol, meshExamples e limitations. uq-02 pass: meshExamples ancorados em BaaS, qualificação de fornecedores, provider de IA — cenários específicos da Mesh com decisões concretas de fronteira. uq-03 pass: principleIds (ax-03, ax-04, ax-05, ax-07, dp-07) existem em design-principles e domain-definition; relatedLenses referenciam 7 lenses existentes (mechanism-design, information-economics, financial-intermediation, regulatory-strategy, platform-dynamics, network-theory, supply-chain-theory). uq-04 pass: sem contradição com design-principles — dp-07 (reversibilidade) alinhado com buy-now-build-later e switching cost explícito. uq-05 pass: 4 limitations declaradas cobrindo otimização local, imprecisão no bootstrap, hipótese empírica de IA e ausência de substituição de constraints regulatórias. uq-06 pass: terminologia consistente ao longo de todo o artefato. uq-07 pass: zero placeholders. uq-08 pass: todos os campos obrigatórios presentes — 15 reasoningProtocol steps (>=4), 3 meshExamples (>=2), 5 principleIds, 4 limitations (>=2), rationale preenchido. tq-ln-01 pass: trigger com 13 condições testáveis e 6 excludeWhen. tq-ln-02 pass: 18 conceitos (>=5), cada um com role válido (framework ou method), meshManifestation e meshImplication específicos. cue vet pass."
	}]

	findings: {}

	summary: """
		Lente theory-of-firm completa com trigger (13 condições, 33 keywords,
		6 excludeWhen), 18 conceitos, 15 passos de reasoning protocol, 3
		meshExamples (BaaS vs banking, supplier qualification, AI provider
		dependency), 5 principleIds, 7 relatedLenses, 4 limitations e
		rationale. Estabilizada em round 2 após resolução do uq-08 fail
		do round 1 (campos obrigatórios agora presentes). cue vet pass.
		"""
}
