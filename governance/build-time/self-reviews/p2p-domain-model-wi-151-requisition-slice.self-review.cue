package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pDomainModelWi151RequisitionSlice: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-domain-model-wi-151-requisition-slice"

	artifactPath:       "contexts/p2p/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-12"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da FATIA DA REQUISIÇÃO (WI-151, executa
			adr-174): +6 events internal (submitted/triaged/approved/approval-
			rejected/converted/cancelled), +5 commands (submit/triage/approve/
			convert/cancel-requisition), +3 invariants (completeness/approval-
			requires-coverage-reservation/emission-requires-approved-
			requisition), +vo-requisition-id, +agg-purchase-requisition
			(6 states / 8 transitions), +pol-purchase-order-converts-requisition
			(1ª policy do BC), +prj-pending-requisitions; agg-purchase-order
			ganhou requisitionRef (field + cmd + evento published) e o 2º braço
			do gate de emissão; rationale raiz coevoluído (2 aggregates, 7
			commands, 1 policy, 5 projections, 16 terms, bloco da fatia).

			[uq-08 CONFORMÂNCIA]: cue vet EXIT=0. Wiring interno verificado
			contra tq-dm-01..17: todo command handled por exatamente 1
			aggregate (convert incluso); todo event em emitsEvents; invariants
			protegidas (inv-emission no PO, os 2 novos na requisição); policy
			refs resolvem (tq-dm-05); projection consome só events do catálogo
			(tq-dm-06); transitions referenciam commands/events/guards
			existentes (tq-dm-07/08); dependsOnAggregateState intra-BC aponta
			agg+projection existentes (tq-dm-17).

			[FORMA IMPOSTA PELO SCHEMA, declarada]: o plano da proposta tinha
			5 events/4 commands; o schema exige triggeredByCommand + emitsEvents
			em toda #StateTransition — a conversão approved→converted ganhou o
			par interno cmd-convert-requisition + evt-purchase-requisition-
			converted (carve-out tq-dm-12: command interno de policy, fora do
			canvas). Decisão semântica inalterada (a conversão já era a policy
			do adr-174); +1 command/+1 event são veículo tático.

			[uq-03 REFS]: cross-refs verificadas — QueryBudgetApprovalStatus
			existe no canvas do bdg; agg-cost-center existe no bdg;
			cmd-approve-budget/cmd-release-budget-commitment citados existem;
			shape npm↔idc (adr-055) replicado fielmente. A limitação da chave
			(surface bdg keyed por CommitmentId HOJE) está DECLARADA no
			rationale do dependsOnAggregateState — janela WI-153, não drift
			silencioso. [uq-05 LIMITAÇÕES]: janela WI-153 declarada em todos os
			pontos que tocam o re-papel bdg (release, efetivação, chave).
			[uq-06 UL]: língua bdg citada como língua (Centro de Custo, Saldo
			Disponível, Alçada, Comprometimento); term-requisicao criado em par
			no glossário. [uq-01/uq-07]: rationales substantivos, zero
			placeholder. Selectors per adr-160 nos 2 pares colidentes, molde
			fce (sel-*, readsPayload, exclusividade/exaustividade declaradas;
			returned fora do par — não transiciona).

			[uq-09 SECTION GATES]: edição de instância executando comando
			estruturado do arquiteto (Tempo 2 do WI-151, instruções a-g com
			decisões cravadas: triagem ato formal; fato-de-origem como campo;
			anti-retrofit) — arco de checkpoint único, batch per serialization
			Rule (precedente WI-145/adr-173); diffs integrais no checkpoint.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — fechamento do residual #1 do review isolado por DECISÃO
			DO FOUNDER: amount entra COMO CAMPO (vo-money, o VO canônico
			shared #Money — mesmo shape que o cmd-approve-budget do bdg exige)
			em cmd-approve-purchase e evt-purchase-approved. O rationale do
			command declara LITERALMENTE a procedência e a dívida: o amount é
			o valor da cotação vencedora do sourcing (ssc), aprovado pelo
			gestor e reservado pelo Gate de Cobertura; nesta fatia é campo de
			ENTRADA; o elo formal requisição↔cotação (quoteRef cross-BC) e a
			reconciliação approve-amount vs quote-amount são a fatia p2p↔ssc
			registrada em def-079 (criado nesta rodada, open, manual-review).
			Escopo cirúrgico respeitado: NENHUM quoteRef criado, contexts/ssc/
			intocado, usesValueObjects do agg-purchase-requisition inalterado
			(amount não é field do aggregate root — pattern do wiring:
			usesValueObjects reflete fields do root). cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		Fatia da requisição no domain-model do p2p (WI-151 executa adr-174
		PORTÃO): a PORTA da jornada materializada — requisição com triagem
		formal, aprovação com Gate de Cobertura pré-pedido (reserva two-phase),
		conversão via policy, 2º braço do gate de emissão no PO. VEREDITO:
		stable, 0 fail; forma imposta pelo schema (+1 command/+1 event para a
		transição de conversão) declarada, não silenciada. Round 2 fechou o
		portão oco por decisão do founder: amount (vo-money) como campo de
		entrada em approve/approved, com procedência (cotação ssc) e dívida
		do elo (def-079) declaradas no rationale.
		"""

}
