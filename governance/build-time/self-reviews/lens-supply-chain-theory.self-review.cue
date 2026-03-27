package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensSupplyChainTheory: build_time.#SelfReviewReport & {
	reportId: "srr-lens-supply-chain-theory"

	artifactPath:       "architecture/lenses/lens-supply-chain-theory.cue"
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
		summary:   "Artefato parcial por decisão do founder: contém id, name, purpose, status, trigger (15 condições, 44 keywords, 7 exclusões) e concepts (15 conceitos cobrindo anatomia da cadeia, informalidade, retenção, transmissão operacional-financeira, disputa de escopo, restrições físicas, bullwhip, Kraljic dinâmico, propagação multi-tier, assimetria de poder, mecanismo SCF, sazonalidade, coordenação operacional, lead time e saúde da cadeia). Campos obrigatórios ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. uq-08 fail por incompletude. Demais critérios sobre conteúdo presente: uq-01 pass (rationale explica por que), uq-02 pass (fortemente ancorado em construção civil — concreto, boletim, medição, canteiro, retenção contratual), uq-03 pass (dependsOn internos consistentes), uq-04 pass, uq-06 pass (terminologia consistente — material/serviço, payment gap, dilution, bullwhip), uq-07 pass. tq-ln-01 pass (15 condições testáveis, 7 excludeWhen). tq-ln-02 a tq-ln-04 não avaliáveis."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Artefato não conforma com #AnalyticalLens: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale estão ausentes. Artefato parcial por decisão explícita do founder."
		}]
	}

	summary: """
		Lente parcial de supply chain theory com trigger completo (15 condições,
		44 keywords, 7 exclusões) e 15 conceitos cobrindo anatomia da cadeia
		da construção civil, regimes de informalidade, retenção contratual,
		transmissão operacional-financeira, disputa de escopo, restrições físicas,
		bullwhip, Kraljic dinâmico, propagação multi-tier, assimetria de poder,
		mecanismo SCF, sazonalidade, coordenação operacional, lead time e saúde
		da cadeia. Founder fornecerá campos restantes em mensagens subsequentes.
		"""
}
