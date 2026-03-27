package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensCreditRisk: build_time.#SelfReviewReport & {
	reportId: "srr-lens-credit-risk"

	artifactPath:       "architecture/lenses/lens-credit-risk.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 1
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 avaliou lente parcial (trigger + 19 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em construção civil, FIDC, registradora, Resolução 2.682, cessão, coobrigação, duplicata, NF eletrônica, judiciário, HHI, AUROC, PSI, RAROC (uq-02), crossDependsOn referencia sc-multi-tier-propagation, sc-operational-financial-transmission, cas-nonlinearity-tipping, rs-brazil-financial-regime em lenses existentes (uq-03), sem contradição com design-principles (uq-04), terminologia consistente — PD, LGD, EAD, EL, UL usados consistentemente (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 9 condições testáveis, 4 excludeWhen. 19 conceitos (18 theoretical + 1 operational) com dependsOn consistentes internamente."
	}]

	findings: {
		fail: [{
			criterion: "uq-08"
			severity:  "fail"
			message:   "Campos obrigatórios do schema #AnalyticalLens ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
	}

	summary: """
		Lente credit-risk parcial com trigger (9 condições, 32 keywords, 4
		excludeWhen) e 19 conceitos cobrindo definição de default, estrutura
		jurídica, PD, maturidade, LGD, diluição, fraude, cure/roll rate, EAD,
		EL/UL/RAROC, concentração, correlação, pro-ciclicalidade, transmissão
		operacional→financeira, vintage, stress testing, model risk, provisão
		regulatória e métricas de saúde (1 operacional com reviewCadence monthly).
		Fail estrutural (uq-08) por campos obrigatórios ausentes — artefato
		parcial por decisão do founder. Aguardando reasoningProtocol,
		meshExamples, principleIds, relatedLenses, limitations e rationale.
		"""
}
