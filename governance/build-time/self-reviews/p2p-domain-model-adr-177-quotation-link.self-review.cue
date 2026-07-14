package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pDomainModelAdr177QuotationLink: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-domain-model-adr-177-quotation-link"

	artifactPath:       "contexts/p2p/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

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
			Round 1 — o elo requisição↔cotação + 2º braço do portão (adr-177,
			resolve def-079), com anti-dangling PRÉ-VERIFICADO contra o disco
			antes da escrita (lição WI-155):

			(1) sourcingDecisionRef + quantity nos 3 lugares decididos:
			cmd-approve-purchase (nasce — declarados pelo gestor),
			agg-purchase-requisition (persiste — presentes quando
			status=approved, preservados em converted para auditoria),
			evt-purchase-approved (viaja — procedência auditável a partir do
			fato). Primitive ref cross-BC língua ssc, padrão costCenterRef/
			claimedAuthorityRef confirmado no próprio arquivo; a description
			do ssc vo-sourcing-decision-id já antecipava 'referenciada
			cross-context (P2P validation)'.

			(2) inv-approval-amount-matches-winning-quotation com os 4 checks
			(existência+concluída; vencedor resolvível — multi-supplier →
			ambiguous-case; currency match; unitPrice × quantity == amount) e
			a proibição explícita de estimatedVolume como base. Guard da
			transição triaged→approved AO LADO do braço bdg — mesma mecânica
			(falha não transiciona + escalada supervisionada).
			dependsOnAggregateState → ssc agg-sourcing-process via
			canvasQuerySurface QueryQuotationMap (existente no canvas ssc,
			linha verificada) — shape idêntico ao RECTOR de authority e ao
			braço bdg (padrão adr-055).

			(3) Prosa classe-2 morta no ato: os 3 pontos que citavam def-079
			como dívida (rationale do cmd, descriptions do amount no cmd e no
			evt) reescritos para a verdade atual (verificado contra a cotação
			vencedora, adr-177); selector rationale + descriptions da
			transição/aggregate atualizados para o portão DUPLO;
			protectsInvariants += a invariante nova.

			[tq-dm coerência]: guards referenciam invariants declarados;
			handlesCommands/emitsEvents inalterados (nenhum building block
			além da invariante — campos não são ids). [uq-08]: cue vet
			EXIT=0. Evidência determinística: runner TOTAL 31/0 bloqueantes
			(idêntico ao baseline pré-fatia); sc-ag-01 0 (nenhum ref dangling
			introduzido); sc-ag-02 em REJECT permanece 0 com a coevolução do
			agent-spec no mesmo batch.
			"""
	}]

	findings: {}

	summary: """
		Elo formal requisição↔cotação materializado (sourcingDecisionRef +
		quantity firme nos 3 lugares) + 2º braço do portão como invariante-
		gate determinístico espelhando o braço bdg (adr-055; falha não
		transiciona + escalada). def-079 morre com prosa classe-2 zerada no
		arquivo. Runner 31/0 (baseline mantido); cue vet EXIT=0.
		VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: desenho integralmente cravado pelo founder
		no Tempo 2 (direção ii, opção B, fórmula b, moradas dos campos), com
		anti-dangling pré-verificado e o shape da invariante espelhado de
		dois precedentes vivos no mesmo arquivo (braço bdg + RECTOR ssc); a
		evidência determinística (vet + runner 31/0 com sc-ag-01/02 em
		reject) é reproduzível nesta execução.
		"""
}
