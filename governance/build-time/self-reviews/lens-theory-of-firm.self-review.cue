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

	roundsExecuted: 1
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 avaliou lente parcial (trigger + 18 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em BaaS, providers de IA, registradoras, bureaus, administradores fiduciários, Pix, SLA, LGPD, SCD, construção civil, modelos calibrados, embeddings, workflows, Mesh AI-native, cessão, banking (uq-02), dependsOn internos consistentes (uq-03 pass), sem contradição com design-principles (uq-04), terminologia consistente — custos de transação, coordenação interna, oportunismo, hold-up, especificidade, complementaridade, direitos residuais, dependência bilateral, racionalidade limitada, contratos incompletos, governança híbrida, ambiente institucional, escala mínima, capacidade, switching cost, portabilidade, optionality, assimetria de erro, boundary map (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 13 condições testáveis, 6 excludeWhen."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Campos obrigatórios do schema #AnalyticalLens ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
	}

	summary: """
		Lente theory-of-firm parcial com trigger (13 condições, 33 keywords,
		6 excludeWhen) e 18 conceitos cobrindo custos de transação, coordenação
		interna, oportunismo, especificidade de ativo e temporal, direitos
		residuais, complementaridade, hold-up, dependência bilateral,
		racionalidade limitada, estruturas de governança, ambiente institucional,
		escala mínima, capacidade, switching cost/portabilidade, assimetria de
		erro, framework make-or-buy e boundary map operacional. Fail estrutural
		(uq-08) por campos obrigatórios ausentes.
		"""
}
