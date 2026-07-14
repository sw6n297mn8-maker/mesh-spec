package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pAgentSpecAdr177Coevolution: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-agent-spec-adr-177-coevolution"

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
		infoCount: 0
		summary: """
			Round 1 — 1ª COEVOLUÇÃO DE FATIA DE DOMÍNIO SOB A CATRACA
			(sc-ag-02 em reject desde adr-176; esta fatia é o primeiro teste
			real do regime 'o agente viaja com o modelo' em mudança de
			domain-model):

			(1) Cobertura do id novo: inv-approval-amount-matches-winning-
			quotation entrou em operationalScope.invariants E em
			act-process-purchase-approval.domainModelRefs — o único building
			block novo da fatia (campos não são ids; ssc não ganhou building
			block). sc-ag-02 (REJECT) permanece 0 — verificado por execução
			real do runner pós-mudança (TOTAL 31/0, nenhuma linha sc-ag-*).

			(2) Prosa classe-2 REESCRITA (não deixada): a description do
			act-process-purchase-approval dizia 'amount com procedência da
			cotação vencedora do ssc, dívida do elo formal em def-079' —
			FALSA no instante da materialização. Reescrita para o portão
			DUPLO (braço 1 cobertura bdg; braço 2 procedência ssc via
			QueryQuotationMap + gate determinístico), com def-079 citado como
			RESOLVIDO pelo adr-177.

			(3) Braço ssc nas pre/postconditions: precondition nova (mapa de
			cotações acessível via sync) + precondition da decisão ampliada
			(amount, quantity FIRME e sourcingDecisionRef declarados);
			postcondition de approve exige os dois braços verdes e nomeia os
			3 campos vinculados no evento; postcondition de falha cobre os
			dois braços com a rota de escalada de cada um; postcondition nova
			para vencedor ambíguo → ambiguous-case.

			(4) Coevolução de fidelidade além do mínimo (reportada no
			checkpoint, não silenciada): escalationConditions ambiguous-case
			ganhou o caso do vencedor ambíguo no 2º braço (a invariante roteia
			explicitamente para essa category — sem a menção, a condition
			ficaria incompleta); contextRequirements context-map rationale
			ganhou QueryQuotationMap na dependência SSC (a enumeração ficaria
			stale). Nenhuma action nova, nenhuma exclusão nova.

			[tq-ag-02 least-privilege]: domainModelRefs ⊆ operationalScope
			mantido. [sc-ag-01 REJECT]: 0 — todos os refs novos existem no
			domain-model do p2p (anti-dangling pré-verificado). [uq-08]:
			cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		Coevolução obrigatória da 1ª fatia de domínio sob a catraca:
		invariante nova coberta (scope + refs), prosa classe-2 do def-079
		reescrita para o portão DUPLO, braço ssc nas pre/postconditions,
		ambiguous-case e contextRequirements fiéis. Runner real pós-mudança:
		sc-ag-01/sc-ag-02/sc-ag-03 todos 0 em REJECT — a lei do adr-176
		funcionou sem fricção. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: o delta é 1 id novo coberto + reescrita de
		prosa cravada pelo founder no comando (portão duplo, braço ssc,
		ambiguous-case); a condição de saída é verificada por gate
		determinístico em reject (sc-ag-01/02 no runner, 0 violações,
		reproduzível nesta execução) — exatamente a dimensão que o review
		estocástico não precisa re-julgar.
		"""
}
