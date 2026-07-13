package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

bdgCanvasWi153TwoPhaseRerole: build_time.#SelfReviewReport & {
	reportId: "srr-bdg-canvas-wi-153-two-phase-rerole"

	artifactPath:       "contexts/bdg/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

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
			Round 1 — coevolução do canvas bdg (WI-153): handler ApproveBudget
			re-descrito (invocador é o PORTÃO p2p, pré-pedido; resultingEvents
			BudgetApproved → CoverageReserved — o fato da fase 1); handler
			RejectBudget re-descrito (resultado sync ao p2p; requisição
			permanece triaged); consumer CommitmentAccepted com reaction =
			EFETIVAÇÃO (não mais 'inicia aprovação' — o papel velho morreu
			aqui também, não só na policy); query-surface
			QueryBudgetApprovalStatus com chave por requisição + enum novo;
			outbound ganhou event-publisher CoverageReserved (consumers p2p —
			consumo async declarado como ANCHOR; query sync é o caminho
			Phase 0) e BudgetApproved re-descrito como efetivação (spine DLV
			intocado em contrato); rationale da communication coevoluído
			(3 relations em context-map incluindo bdg-to-p2p). cue vet
			EXIT=0; tq-cv-02 satisfeito — toda relation cross-checked
			(bdg-to-p2p criada no context-map na mesma fatia).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — correção pós-STOP do sc-cm-07 (directed-acyclicity,
			REJECT) por DECISÃO DO FOUNDER (opção A): a entry outbound de
			CoverageReserved foi REMOVIDA do canvas — o evento segue o
			precedente EXATO dos irmãos BudgetRejected/BudgetCommitment-
			Released no mesmo canvas (published no domain-model como fato de
			1ª classe INTOCADO; propagação cross-BC não declarada; citado no
			rationale da communication como ANCHOR com flag explícito).
			Outbound volta a 1 event publisher (BudgetApproved efetivação,
			spine DLV). O handler ApproveBudget MANTÉM resultingEvents
			[CoverageReserved] — consistente com o precedente (RejectBudget
			tem resultingEvents [BudgetRejected] sem outbound entry):
			resultingEvents declara o domain event resultante, não a
			propagação. Shape conferido idêntico aos dois precedentes.
			Razão fiel: em Phase 0 o portão é query síncrona (call-site
			operacional per adr-120); a aresta de evento seria o futuro que
			ainda não chegou. cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		Canvas bdg coevoluído com o re-papel two-phase: portão como invocador,
		efetivação como reaction, contagens e cross-checks atualizados.
		Round 2 (decisão A do founder no STOP do sc-cm-07): CoverageReserved
		FORA do outbound — anchor no rationale, precedente dos irmãos
		BudgetRejected/Released; o caminho operacional Phase 0 é a query.
		VEREDITO: stable, 0 fail.
		"""

}
