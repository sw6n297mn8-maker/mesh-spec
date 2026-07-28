package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscAgentWi161NegotiationCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-agent-wi-161-negotiation-coverage"

	artifactPath:       "contexts/ssc/agents/ssc-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-28"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Round único (precedente das fatias de domínio WI-151/152/adr-177,
		modo self-reported): os critérios verificáveis mecanicamente foram
		provados por gate real na própria fatia (cue vet; runner estrutural
		com sc-ds/sc-ag/sc-fct em reject; verbatim-diff programático do am;
		fidelidade command→event extraída por export e reportada verbatim no
		checkpoint per instrução do founder) e as decisões interpretativas
		foram aprovadas explicitamente pelo founder na proposta consolidada
		com 3 calibrações — a dimensão restante é o founder review final da
		fatia, gate humano que rounds adicionais de self-review não
		substituem.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — coevolução agente↔modelo NO MESMO COMMIT (catraca
			adr-175/adr-176; sc-ag-01/sc-ag-02 em reject): operationalScope
			ganha os 3 commands + 3 events + 1 invariant da negociação
			(comentários registram o regime — fatos internal, mesmo veto de
			confidencialidade do WI-152/WI-154); nova action
			act-prepare-counter-proposal (mutation, propose-and-wait —
			Phase 0 vira 4 propose-and-wait + 1 execute-and-log, header
			coevoluído): o agente RECOMENDA o alvo da contraproposta a
			partir da equalização TCO (prj-quotation-map) + range do
			histórico da categoria (prj-rfq-history-by-category,
			mediana/variância — estatística sobre histórico próprio, não
			inferência sobre fornecedor: anti-mini-NIM preservado); o
			comprador decide e envia — a negociação segue sendo a 'arte'
			humana da jornada (decide-vs-execute per tq-agg-09, atos
			separados por construção). A action declara explicitamente que
			NUNCA muta a ent-quotation (inv-negotiated-terms-materialize-
			on-quotation). Commands do fornecedor (revise/decline) cobertos
			via operationalScope como submit/withdraw (operações inbound
			processadas, sem action dedicada — precedente WI-152/WI-154).
			domainModelRefs da action resolvem no domain-model do BC
			(cmd/evt/agg/inv/prj — todas as famílias no targetIdPaths do
			sc-ag-01). cue vet PASS; runner sc-ag-01/02 verdes na fatia.
			"""
	}]

	findings: {}

	summary: """
		Primeira extensão do agent-spec do ssc sob a catraca em fatia de
		modelagem própria do BC: a cobertura viaja no mesmo commit dos
		building blocks novos (regra do adr-175, molde adr-177/P5). A
		action nova mantém a divisão canônica da jornada: agente prepara
		a mesa (recomendação determinística/estatística), humano negocia.
		"""
}
