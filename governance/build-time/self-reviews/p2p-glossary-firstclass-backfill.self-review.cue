package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pGlossaryFirstClassBackfill: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-glossary-firstclass-backfill"

	artifactPath:       "contexts/p2p/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-16"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 -- self-review self-reported (rollout default p/ glossary) da edicao do
			glossario p2p na onda 5 do backfill Forma A (adr-151 passo vi; os 12 conceitos que o
			kit adr-178 trouxe para o sc-fct-01 via am-purchase-requisition). SRR sob nome
			QUALIFICADO (p2p-glossary-firstclass-backfill) -- p2p-glossary.self-review.cue de
			authoring ja existe (licao do dlv). Edicao: +11 termos novos (5 command:
			submeter/triar/aprovar-compra/converter/cancelar; 6 event: submetida/triada/
			compra-aprovada/aprovacao-recusada/convertida/cancelada), 1 REUSO com add-ref:
			term-requisicao cobre o agg-purchase-requisition (decisao do founder pos-leitura da
			definicao no disco -- ela ja descreve o boundary-com-ciclo e NOMEIA o agg; os 2
			toques cravados: domainModelRefs adicionado + definicao atualizada para o portao
			DUPLO com o 2o braco adr-177). Onda 100% owned (0 foreign). PASS: cada termo tem
			termEn == coreNoun do conceito (norm-exato) e domainModelRefs apontando o code (G1);
			reasons da folha cravada pelo founder: governance x4 (agg boundary do portao,
			triagem ato formal + fato, recusa do gestor), financial x4 (aprovacao que reserva
			cobertura + fato, cancelamento que libera reserva + fato), cross-artifact-contract
			x4 (submissao porta da jornada + fato, conversao interna por policy + fato) -- 4-4-4. Padrao
			ato/fato: definitions distinguem EXPLICITAMENTE comando vs evento em cada par;
			fronteiras preservadas (Requisicao Cancelada != Purchase Order Cancelled; recusa do
			gestor != falha de gate, P10). Verificado: nenhum termEn/code novo colide com os 16
			existentes; relatedTerms resolvem (novos + requisicao/requisitante/comprador/
			purchase-order*). cue vet ./... EXIT=0; evaluator first-class-traceability contra o
			disco: report VAZIO (os 12 passam G1 por cobertura real); worklist drenada 12->0
			(VAZIA novamente, gate reject permanece); runner 30 warns / 0 bloqueantes =
			baseline pre-onda intocado. 0 fail, 0 warn.
			"""
	}]

	findings: {}

	summary: """
		Edicao do glossario p2p na onda 5 do backfill Forma A (adr-151 passo vi): 11 termos
		novos (5 command + 6 event) + reuso de term-requisicao para o agg (com domainModelRefs
		e 2o braco adr-177 na definicao), dando cobertura dedicada (G1) aos 12 conceitos
		cross-contract do kit adr-178. Reasons per folha cravada pelo founder (governance/
		financial/cross-artifact-contract, 4-4-4). Self-review self-reported em round unico
		com 0 fail / 0 warn. Padrao ato/fato nas definitions. Fidelidade provada pelo evaluator
		(report VAZIO pos-onda; worklist 12->0, vazia; runner 30/0 = baseline). cue vet EXIT=0.
		"""

	singleRoundRationale: """
		1 round: edicao aditiva de 11 termos declarativos + 1 add-ref conformando ao #Glossary
		(cue vet EXIT=0), cada termo com termEn==coreNoun + ref (G1), classificacoes cravadas
		pelo founder na folha (Tempo 1), e comportamento do gate validado empiricamente
		(evaluator vazio pos-onda; worklist drenada). Mesmo regime de round unico das ondas
		fce/rew.
		"""
}
