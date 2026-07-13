package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

scAg02PromoteRejectAndScAg03: build_time.#SelfReviewReport & {
	reportId: "srr-sc-ag-02-promote-reject-and-sc-ag-03"

	artifactPath:       "architecture/structural-checks/agent-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

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
			Round 1 — a catraca do sc-ag-02 (adr-176): duas mudanças no
			arquivo de checks, ambas com pré-condição VERIFICADA NO ATO antes
			da escrita:

			(1) FLIP sc-ag-02 enforcement warn→reject. Pré-condição: runner
			confirmou 0 violações ('nem coberto' = 0) em main @ f36457d ANTES
			do flip — o reject não bloqueia nada hoje. Frase de fecho
			adicionada ao rationale no mesmo padrão do irmão sc-ag-01
			('promovido a reject (adr-114)'): 'Promovido a reject em adr-176;
			baseline zerado pelas higienes WI-154/WI-155 (61→37→0,
			2026-07-13)'. Nada mais tocado no sc-ag-02.

			(2) sc-ag-03 NOVO born-green: kind EXISTENTE
			directory-pair-coverage (zero motor, zero schema — sc-meta-01
			segue verde por construção: kind já tem evaluator e fixture),
			molde do sc-apr-02. Pré-condição: 12/12 pares
			contexts/<bc>/domain-model.cue ↔ contexts/<bc>/agents/_meta.cue
			verificados no ato (drc/scf sem domain-model ficam fora por
			construção). Nasce reject direto per precedente sc-ag-01/adr-114
			(born-green — a catraca adr-097 é para baseline sujo). Fecha a
			janela estrutural que o read-only revelou: o sc-ag-02 itera
			instâncias de agent-spec e não visitaria um BC que ganhasse
			domain-model sem agente algum.

			[tq-sc-01 acionabilidade]: errorMessage do sc-ag-03 nomeia o
			conserto exato (criar o agente da fatia que criou o domain-model,
			per canvas.ownership.domainAgentSpec + cascade PG-A). [tq-sc-02]:
			rule conforma ao #DirectoryPairCoverageRule (sourceGlob/
			targetGlob/bidirectional). [tq-sc-03]: rationales citam o caso
			concreto (janela drc/scf; arco 61→37→0) e os precedentes
			(adr-114, adr-117→123, adr-097). [uq-08]: cue vet EXIT=0.

			Execução real pós-mudança: runner TOTAL 31 violações / 0
			BLOQUEANTES — com sc-ag-02 e sc-ag-03 AMBOS em reject, nenhum
			bloqueante novo (os 31 são warns pré-existentes de api.yaml/
			probe-records, não afetados). sc-ag-01 segue 0; self-test PASS.
			A lei está armada sem quebrar nada no dia 1.
			"""
	}]

	findings: {}

	summary: """
		Catraca executada (adr-176): sc-ag-02 warn→reject com baseline zero
		verificado no ato + sc-ag-03 born-green reject (kind existente,
		12/12 pares) fechando a janela do BC-sem-agente. Runner pós-mudança:
		31/0 bloqueantes — a lei arma sem quebrar nada. VEREDITO: stable,
		0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: flip de 1 campo + 1 entry declarativa de
		kind existente, com desenho pré-cravado pelo founder (Tempo 1
		read-only verificou zero, 12/12 e o molde adr-123) e as duas
		pré-condições re-verificadas no ato da escrita; a evidência
		determinística (runner 31/0 com ambos em reject + self-test) é
		reproduzível nesta execução.
		"""
}
