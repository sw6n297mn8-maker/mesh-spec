package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

bdgAgentSpecWi154Coevolution: build_time.#SelfReviewReport & {
	reportId: "srr-bdg-agent-spec-wi-154-coevolution"

	artifactPath:       "contexts/bdg/agents/bdg-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

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
		infoCount: 2
		summary: """
			Round 1 — coevolução WI-154 (higiene A, adr-175) do agent-spec do
			bdg, a PRIORIDADE da fatia (classe-1 + classe-2). PARTIÇÃO
			(tq-agg-11): 2 cobertura — evt-coverage-reserved (events; emitido
			pela action central do gate) e inv-confirmation-requires-active-
			reservation (invariants; precedente do próprio spec que lista
			TODAS as invariants incl. domain-enforced; a escalada
			confirm-without-reservation entrou na escalationCondition
			conflicting-signals); 1 exclusão POR-ID padrão C —
			cmd-confirm-budget-reservation (chave estrutural policies[].
			issuesCommand da pol-commitment-accepted-triggers-approval).

			CLASSE-2 (as 9 correções de prosa pós-two-phase, CADA UMA
			confirmada contra o disco — adr-174 + contexts/bdg/domain-model.cue
			— antes da escrita): (1) description do agente: gate no PORTÃO,
			RESERVA/CoverageReserved fase 1, BudgetApproved na EFETIVAÇÃO;
			(2) act-execute-coverage-gate: approved emite CoverageReserved
			(refs trocados evt-budget-approved→evt-coverage-reserved); spine
			DLV consome o BudgetApproved da efetivação, não desta action;
			(3) act-identify-cost-center: fase 1 parte da requisição
			(costCenterRef declarado desde a submissão per WI-151); ACL
			dispara a efetivação; (4) act-validate-commitment-scope: payload
			fase 1 = requisição via sync p2p; payload ACL = fase 2;
			(5) act-query-budget-approval-status: enum pending/reserved/
			confirmed/rejected/released (D3), keyed requisitionRef OU
			CommitmentId, consumers +p2p (lê reserved no portão);
			(6) cst-coverage-gate-mandatory: lei ancorada na RESERVA;
			BudgetApproved exige reserva ativa; (7) release: +origem p2p
			(cancelamento de requisição approved); (8) rationale/sig-budget-
			decision-emitted: decisão fase 1 = CoverageReserved/BudgetRejected;
			(9) contagens contextRequirements: 5 events, 8 invariants + 1
			exclusão declarada. Nenhuma prosa correta foi reescrita.

			[uq-08]: cue vet EXIT=0. [tq-ag-02]: refs novos ⊆ scope. [uq-09/
			tq-agg-11]: runner confirmou sc-ag-02 do bdg = ZERO; sc-ag-01 sem
			dangling (a exclusão nova resolve no domain-model).

			[INFO 1 — divergência observada FORA do escopo desta fatia]: a
			description/rationale top-level do cmd-approve-budget no PRÓPRIO
			domain-model do bdg ainda diz 'para um CommitmentId' e
			'publicação de BudgetApproved' — resíduo classe-2 do WI-153 no
			domain-model (os fields estão corretos, com D2 anotado). As 9
			verdades desta coevolução foram confirmadas por outras fontes do
			disco (evt-coverage-reserved, evt-budget-approved, vo/qry, inv,
			policy). Candidato a correção editorial em fatia própria.
			[INFO 2 — 10º trecho candidato, não listado nas 9 aprovadas]: a
			precondition de act-execute-coverage-gate cita 'CommitmentId NÃO
			tem Comprometimento ATIVO (inv-commitment-id-global-uniqueness-
			active)' — na fase 1 o CommitmentId ainda não existe (a
			unicidade re-desenhada por fase no WI-153). Mantido intocado
			neste round (fora da lista aprovada); apresentado ao founder no
			checkpoint.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round 2 — o founder decidiu o INFO 2 do round 1: APLICAR a 10ª
			correção de prosa (mesma classe-2, mesma action, mesmo arquivo —
			completar a correção, não expandir escopo). Verdade CONFIRMADA
			contra o disco antes da escrita (inv-commitment-id-global-
			uniqueness-active pós-WI-153: unicidade POR FASE — fase 1: cada
			requisitionRef tem no máximo UMA reserva ativa reserved|confirmed,
			re-reserva exige liberação prévia, histórico liberado não
			bloqueia; fase 2: cada CommitmentId tem no máximo um confirmed).
			Precondition corrigida: 'CommitmentId NÃO tem Comprometimento
			ATIVO' → 'requisitionRef NÃO tem reserva ATIVA (reserved ou
			confirmed) — na fase 1 o CommitmentId ainda não existe'. Nenhuma
			outra linha tocada; nenhuma contagem afetada (correção intra-
			precondition, sem mudança de refs/scope). A lista de correções
			de prosa do WI-154 no bdg vai de 9 para 10.

			O INFO 1 do round 1 (prosa stale no cmd-approve-budget do
			DOMAIN-MODEL do bdg) foi decidido como NÃO-tocar: resíduo do
			WI-153 em outra superfície, fora do escopo do WI-154 (agent-
			specs) — permanece registrado como higiene de domain-model
			separada. cue vet EXIT=0; runner re-confirmou sc-ag-02 do bdg =
			ZERO (a correção é prosa; a cobertura não muda).
			"""
	}]

	findings: {}

	summary: """
		Coevolução do agent-spec do bdg com o mundo pós-two-phase: 2
		coberturas + 1 exclusão padrão C por-id + 10 correções de prosa
		falsa (9 pré-cravadas no Tempo 1 + a 10ª decidida pelo founder no
		checkpoint — precondition de uniqueness re-ancorada na fase 1 por
		requisitionRef; todas confirmadas contra o disco antes da escrita)
		+ escalada confirm-without-reservation. sc-ag-02 do bdg a ZERO;
		sc-ag-01 sem dangling. Info residual: prosa stale no domain-model
		(cmd-approve-budget) decidida como NÃO-tocar — higiene de
		domain-model separada. VEREDITO: stable, 0 fail.
		"""
}
