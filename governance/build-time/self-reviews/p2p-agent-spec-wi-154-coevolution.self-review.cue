package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pAgentSpecWi154Coevolution: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-agent-spec-wi-154-coevolution"

	artifactPath:       "contexts/p2p/agents/p2p-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

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
		infoCount: 1
		summary: """
			Round 1 — coevolução WI-154 (higiene A, adr-175) do agent-spec do
			p2p, a maior massa da fatia (16 itens — a requisição inteira do
			WI-151 entrou no mapa do agente). PARTIÇÃO (tq-agg-11): 14
			cobertura — agg-purchase-requisition; cmd-submit/triage/approve/
			cancel (4); evt submitted/triaged/approved/approval-rejected/
			cancelled (5); inv-requisition-completeness, inv-approval-
			requires-coverage-reservation, inv-emission-requires-approved-
			requisition (3); prj-pending-requisitions — e 2 exclusão
			POR-CLASSE padrão C 'policy-driven-conversion' (1ª exclusão
			por-classe do repo: cmd-convert-requisition emitido por
			pol-purchase-order-converts-requisition [chave estrutural
			policies[].issuesCommand] + evt-purchase-requisition-converted, o
			fato da mesma transição; o agente observa o resultado via
			prj-pending-requisitions, coberta).

			3 ACTIONS NOVAS (mutation, propose-and-wait — a decisão é humana,
			o agente roda a interação e processa): act-triage-requisition
			(triagem formal com outcome routed/returned/rejected; consome a
			fila; inv-requisition-completeness como guard); act-process-
			purchase-approval (o PORTÃO adr-174: interação sync com o Gate de
			Cobertura do bdg keyed requisitionRef + verificação de reserva
			via QueryBudgetApprovalStatus status=reserved per adr-055;
			decisão do gestor por Alçada; amount com procedência ssc, dívida
			def-079 citada); act-cancel-requisition (pré-conversão; release
			da reserva no bdg quando approved per WI-153). A submissão
			(async, sem decisão síncrona) NÃO ganhou action — coberta por
			scope + refs da triagem, per decisão do founder. 2º braço do
			gate de emissão entrou como refs+precondition em
			act-emit-purchase-order (inv-emission-requires-approved-
			requisition + prj-pending-requisitions).

			[uq-08]: cue vet EXIT=0. [tq-ag-02]: todos os refs das 3 actions
			novas ⊆ operationalScope. [tq-ag-05]: categorias das actions
			novas (mutation) já cobertas pelos signals existentes
			(sig-mutation-executed/sig-supervision-requested). [uq-09/
			tq-agg-11]: runner confirmou sc-ag-02 do p2p = ZERO; sc-ag-01 sem
			dangling (os 2 refs da exclusão por-classe resolvem no
			domain-model).

			[INFO — PENDÊNCIA REGISTRADA per decisão do founder]: o
			governanceScope do canvas p2p segue SÓ do mundo purchase-order
			(5 autonomous + 3 supervised + 5 escalation) — NÃO declara as
			decisões do fluxo de requisição (quem tria, quem aprova por
			Alçada, quem cancela). NÃO tocado nesta fatia: papéis intra-org
			são matéria do def-076 (aberto) — declarar agora cristalizaria
			papéis não decididos. As actions novas ancoram a natureza humana
			da decisão na prosa (propose-and-wait) sem inventar entries de
			governanceScope. Revisita: quando def-076 resolver.
			"""
	}]

	findings: {}

	summary: """
		Coevolução do agent-spec do p2p: a requisição inteira entrou no mapa
		do agente — 14 coberturas + a 1ª exclusão por-classe do repo
		(policy-driven-conversion, 2 refs, chave estrutural) + 3 actions
		novas propose-and-wait (triagem, portão de aprovação com interação
		sync bdg, cancelamento com release) + 2º braço do gate na emissão.
		sc-ag-02 do p2p a ZERO; sc-ag-01 sem dangling. Pendência registrada:
		governanceScope do canvas aguarda def-076. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: reconciliação com partição e forma das 3
		actions pré-cravadas pelo founder (Tempo 1 classificou os 16 itens e
		desenhou as actions; Tempo 2 materializou no molde das actions
		existentes do próprio spec); evidência determinística (runner zero +
		vet + refs ⊆ scope) reproduzível nesta execução.
		"""
}
