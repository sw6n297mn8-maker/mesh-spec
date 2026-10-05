package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

dsBuyerProcurementJourneyMeshConducts: build_time.#SelfReviewReport & {
	reportId: "srr-ds-buyer-procurement-journey-mesh-conducts"

	artifactPath:       "strategic/domain-stories/buyer-procurement-journey.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-story.cue"
	artifactType:       "domain-story"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-10-05"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido na DECOMPOSIÇÃO. A sequência pedida pelo founder
			(propostas → análise → negociação → compra preparada → ratificação)
			cabia em menos passos, mas qualquer fusão a partir do passo 8
			renumerava os passos 9-12 — e esses números são citados fora da
			story (story do fornecedor A3/A4/A6, rationale da contraproposta
			no domain-model do ssc, stakeholder-map no passo 11). Trocado por
			uma decomposição que preserva 1-6 e 9-12: o novo passo 7 declara a
			condução da janela de cotação (trabalho que não tinha dono), o
			antigo 7 vira 8, e o antigo 8 (leitura material a material) se
			funde no 10. Só as citações ao passo 7 como 'proposta do agente'
			envelhecem, e estão listadas como incompatibilidade.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Zero fails. Refs inalteradas em todos os passos que já as tinham;
			o passo 7 novo nasce com commandRefs e eventRefs vazios por
			lacuna honesta (adr-170) declarada no rationale, e o passo 10
			absorve os termRefs do antigo 8. Cada rationale preserva as
			revisões anteriores e acrescenta a de 2026-10-05, inclusive onde
			a revisão nova contradiz frase anterior (passo 9), que fica como
			proveniência com a correção dita ao lado. cue vet ✓;
			structural-check-runner idêntico ao baseline (31 violações, 0
			bloqueantes).
			"""
	}]

	findings: {}

	summary: """
		A story deixa de narrar a compradora como operadora do procurement e
		passa a narrar a Mesh conduzindo a operação, por decisão de produto do
		founder em 2026-10-05. sh-05 assume triagem mecânica (3), pool (4),
		abertura (5) e condução (7) da cotação, análise (8), negociação
		operacional (9) e emissão do pedido (12). O humano fica onde há
		informação só dele (1-2), julgamento (trade-off da negociação dentro do
		9; decisões da compra preparada no 10), autoridade (ratificação no 10,
		aprovação no 11) e exceção (rejeição na triagem, pool insuficiente,
		qualificação). A ratificação é preservada como gesto humano e o registro
		da decisão de sourcing passa a ser consequência dela.

		A revisão declara a experiência decidida e NÃO adapta os artefatos que
		ainda descrevem o comportamento anterior: autonomia propose-and-wait dos
		agentes do p2p e do ssc, textos de cmd-triage-requisition,
		cmd-propose-counter-terms e do campo triagedBy, descrição de sh-08 no
		stakeholder-map, teto por estágio na governança global, e as citações ao
		passo 7 como proposta do agente (adr-196, def-091). Ficam registradas
		para trabalho posterior autorizado pelo founder.
		"""
}
