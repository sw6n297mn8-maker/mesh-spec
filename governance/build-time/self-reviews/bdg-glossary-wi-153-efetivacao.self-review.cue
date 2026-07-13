package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

bdgGlossaryWi153Efetivacao: build_time.#SelfReviewReport & {
	reportId: "srr-bdg-glossary-wi-153-efetivacao"

	artifactPath:       "contexts/bdg/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — coevolução UL do bdg (WI-153, D4 founder): 16º term
			term-efetivacao-de-reserva (category process — a fase 2 do
			two-phase: ancoragem do commitment à reserva, sem re-rodar o gate,
			sem alterar valor; escalada quando sem reserva) com antiTerms
			fechando as duas confusões prováveis (Aprovação Orçamentária — o
			gate roda na fase 1; Pagamento — FCE downstream);
			term-comprometimento-orcamentario re-definido com as fases
			(nasce reserved no portão keyed por requisitionRef; EFETIVADO
			para confirmed; release inclui cancelamento no p2p) +
			relatedTerms ligando a efetivação; rationale raiz do glossário
			coevoluído com o arco two-phase. Par UL↔domain-model no mesmo
			movimento (precedente WI-151 term-requisicao). cue vet EXIT=0;
			contagem real: 16 code term- no arquivo.
			"""
	}]

	findings: {}

	summary: """
		Glossário bdg em par com o re-papel: efetivação nomeada como termo
		canônico, fases no termo de comprometimento, arco atualizado.
		VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: coevolução satélite da fatia WI-153
		executando decisões pré-cravadas do founder (D1-D6) sob comando
		estruturado batch; a revisão substantiva do desenho correu no Tempo 1
		(read-only) e a verificação determinística corre nos gates da
		validação integral do checkpoint.
		"""
}
