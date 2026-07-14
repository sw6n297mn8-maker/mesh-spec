package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapAdr177SscToP2pHybrid: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-adr-177-ssc-to-p2p-hybrid"

	artifactPath:       "strategic/context-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/context-map.cue"
	artifactType:       "context-map"

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
			Round 1 — ssc-to-p2p evolui async → HYBRID (adr-177), molde
			npm-to-ssc (o precedente hybrid exato: events + queries na mesma
			relação):

			(1) communication.type: async → hybrid; queries:
			[QueryQuotationMap, QuerySourcingDecision] — AMBAS existem como
			query-surfaces no canvas do ssc (verificado no disco antes da
			escrita: linhas 192 e 202). events INALTERADOS (os 3 mesmos:
			SourcingDecisionMade, PreferredSupplierDesignated,
			StrategicAwardCompleted).

			(2) ACICLICIDADE VERIFICADA POR EXECUÇÃO REAL, não por leitura:
			o sc-cm-07 (directed-acyclicity, REJECT) filtra por events:exists
			+ direction + kinds — communication.type NÃO participa dos
			edgeFilters; a aresta p2p→ssc do grafo permanece IDÊNTICA (os
			events continuam) e as queries são call-site fora do grafo per
			adr-120. Runner pós-mudança: TOTAL 31/0 bloqueantes, nenhuma
			linha sc-cm-* — zero ciclo, zero aresta nova. NENHUMA relação
			p2p-to-ssc criada (a direção do elo é dado no command, não
			aresta — adr-177).

			(3) Drift quitado de carona: QuerySourcingDecision era consumida
			pelo p2p desde o bootstrap (act-validate-authority, sync
			fallback do gate de authority) SEM declaração no mapa. A entry
			declara as duas queries e o rationale registra a quitação
			explicitamente.

			(4) sc-cm-06 (events built↔built existem no produtor, REJECT):
			inalterado — nenhum event novo na relação. sc-cm-01/02/03
			(integridade de endpoints): endpoints intocados. [uq-08]:
			cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		ssc-to-p2p hybrid (molde npm-to-ssc): +2 queries com events intactos
		— a aresta do grafo não muda e o sc-cm-07 em reject segue 0 (runner
		real 31/0). QuerySourcingDecision quita drift pré-existente do mapa.
		Nenhuma relação nova. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: mudança de 3 campos numa relação existente,
		com molde literal (npm-to-ssc), refs pré-verificados no canvas do ssc
		e a dimensão de risco real (ciclo) coberta por gate determinístico em
		reject executado nesta sessão (31/0, nenhuma linha sc-cm-*).
		"""
}
