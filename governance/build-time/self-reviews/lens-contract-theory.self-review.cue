package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensContractTheory: build_time.#SelfReviewReport & {
	reportId: "srr-lens-contract-theory"

	artifactPath:       "architecture/lenses/lens-contract-theory.cue"
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
		summary:   "Artefato parcial por decisão do founder: contém id, name, purpose, status, trigger (15 condições, 30 keywords, 5 exclusões) e concepts (15 conceitos cobrindo gap de verificabilidade, contratos incompletos, contratos relacionais, cadeia contratual, infraestrutura legal brasileira, gradação de enforcement, moral hazard contratual, reps and warranties, design de remédios, design de covenants, renegociação, menu de contratos, commitment e optionality, alinhamento multi-party e saúde contratual). Campos obrigatórios ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. uq-08 fail por incompletude. Demais critérios sobre conteúdo presente: uq-01 pass (rationale explica por que, e.g., 'Sem distinguir observável de verificável, o contrato parece completo no papel e falha justamente quando precisa ser aplicado'). uq-02 pass (fortemente ancorado na Mesh — cessão, duplicata, registradora, LGPD, protesto, FIDC, construção civil, informalidade brasileira). uq-03 pass (dependsOn internos consistentes). uq-04 pass. uq-06 pass (terminologia consistente — verificabilidade, enforcement, covenant, reps, cessão, perfection). uq-07 pass. tq-ln-01 pass (15 condições testáveis, 5 excludeWhen). tq-ln-02 a tq-ln-04 não avaliáveis."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Artefato não conforma com #AnalyticalLens: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale estão ausentes. Artefato parcial por decisão explícita do founder."
		}]
	}

	summary: """
		Lente parcial de contract theory com trigger completo (15 condições,
		30 keywords, 5 exclusões) e 15 conceitos cobrindo verificabilidade,
		contratos incompletos, contratos relacionais, cadeia contratual,
		infraestrutura legal brasileira, enforcement, moral hazard, reps and
		warranties, remédios, covenants, renegociação, menu de contratos,
		commitment, alinhamento multi-party e saúde contratual. Founder
		fornecerá campos restantes em mensagens subsequentes.
		"""
}
