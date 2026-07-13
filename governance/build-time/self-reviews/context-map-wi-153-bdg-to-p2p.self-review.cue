package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapWi153BdgToP2p: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-wi-153-bdg-to-p2p"

	artifactPath:       "strategic/context-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/context-map.cue"
	artifactType:       "context-map"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — espelho estrutural no context-map (WI-153): +relação
			bdg-to-p2p (upstream-downstream, open-host-service/anti-corruption-
			layer, communication hybrid: events CoverageReserved + queries
			QueryBudgetApprovalStatus — molde idc-to-npm per adr-055 decisão
			5); description da cmt-to-bdg re-papelizada (BDG consome
			CommitmentAccepted para EFETIVAR, não para iniciar aprovação — o
			papel velho não podia sobreviver aqui). NOTA DE FORMA declarada
			na própria relação: o code segue o padrão source=upstream do repo
			(idc-to-npm, cmt-to-bdg, ssc-to-p2p) — o task-spec WI-153 rotulou
			coloquialmente 'p2p-to-bdg' pela direção da dependência; a relação
			canônica nomeia o fornecedor primeiro (bdg fornece cobertura; p2p
			consome). Divergência nominal reportada no checkpoint, não
			silenciada. cue vet EXIT=0.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — correção pós-STOP do sc-cm-07 (directed-acyclicity,
			REJECT) por DECISÃO DO FOUNDER (opção A): a relação bdg-to-p2p
			virou QUERY-ONLY — events [CoverageReserved] REMOVIDO,
			communication hybrid → sync, queries [QueryBudgetApprovalStatus]
			mantida. O gate havia detectado o ciclo bdg → cmt → p2p → bdg
			(arestas cmt-to-bdg, p2p-to-cmt, bdg-to-p2p) — fechado
			exatamente pela aresta de evento; o filtro events:exists do
			sc-cm-07 exclui arestas query-only por design (adr-120: sync
			queries são call-site operacional, não dependência arquitetural
			cross-BC; precedente literal: ciclo fce↔tcm resolvido assim).
			Razão fiel registrada no rationale da relação: em Phase 0 o
			portão É uma query síncrona; a aresta de evento seria o futuro
			(consumo async) que ainda não chegou — declará-la agora fecharia
			um ciclo que não reflete o acoplamento real de hoje. O consumo
			async de CoverageReserved (cache event-fed no p2p) é anchor de
			fatia futura, que resolverá a aciclicidade com kind próprio +
			ADR. Regra sc-cm-07 INTOCADA (opções B e C rejeitadas). cue vet
			EXIT=0; runner esperado de volta a 31/0.
			"""
	}]

	findings: {}

	summary: """
		Relação bdg-to-p2p criada + cmt-to-bdg re-papelizada para efetivação.
		Round 2 (decisão A do founder no STOP do sc-cm-07): aresta QUERY-ONLY
		per adr-120 — o ciclo bdg→cmt→p2p→bdg morreu sem afrouxar regra; o
		consumo async de CoverageReserved é anchor de fatia futura. Nota de
		forma: code segue padrão source=upstream (o rótulo coloquial do
		task-spec era p2p-to-bdg). VEREDITO: stable, 0 fail.
		"""

}
