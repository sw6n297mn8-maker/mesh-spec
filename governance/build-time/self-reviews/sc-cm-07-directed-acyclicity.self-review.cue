package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

scCm07DirectedAcyclicity: build_time.#SelfReviewReport & {
	reportId: "srr-sc-cm-07-directed-acyclicity"

	artifactPath:       "architecture/structural-checks/context-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-28"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			sc-cm-07 (kind directed-acyclicity, primeiro consumidor — adr-117)
			born-warn. Aprovado pelo founder em 3 ciclos: (1) propose com
			Opção C (kind genérico instanciado pro context-map), (2)
			calibração após descoberta do discriminador `direction` no
			schema #BaseRelationship (filtro por direction em vez de
			enumeração de patterns simétricos — mais robusto a evolução),
			(3) diagnóstico empírico antes de propor como ativo.

			Conformância #StructuralCheck (tq-sc-01/02/03):
			- id "sc-cm-07" casa ^sc-[a-z0-9-]+-[0-9]{2}$ — PASS.
			- artifactType "context-map" ∈ #ArtifactType — PASS.
			- kind↔rule pela união discriminada: kind directed-acyclicity +
			  rule {nodesPath, edgesPath, edgeSource, edgeTarget, edgeFilters}
			  conforma a #DirectedAcyclicityRule. PASS (cue vet exit 0).
			- errorMessage específica e acionável: nomeia o que verificar
			  (mutual-dependency, policy reaction, redesenho de fronteira)
			  em vez de só sinalizar falha. PASS tq-sc-01.
			- rationale conecta a princípio (dp-03 blast radius) + caso
			  concreto (4 ciclos atuais + adr-117 documenta) + escolha
			  de enforcement (born-warn catraca adr-097). PASS tq-sc-03.
			- enforcement "warn" deliberado — catraca adr-097, justificado
			  por findings pré-existentes (abaixo).

			4 WARN findings pré-existentes (documentados explicitamente
			para evitar interpretação de desativação preguiçosa):

			(W1) Ciclo 2-BC: drc → cmt → drc
			     (arestas: cmt-to-drc, drc-to-cmt)
			(W2) Ciclo 4-BC: cmt → rew → dlv → bdg → cmt
			     (arestas: rew-to-cmt, dlv-to-rew, bdg-to-dlv, cmt-to-bdg)
			(W3) Ciclo 4-BC: fce → drc → cmt → rew → fce
			     (arestas: drc-to-fce, cmt-to-drc, rew-to-cmt, fce-to-rew)
			(W4) Ciclo 2-BC: fce → tcm → fce
			     (arestas: tcm-to-fce, fce-to-tcm)

			Esses ciclos podem refletir realidade do domínio econômico em
			loop (típico de sistemas financeiros: pagamento → sinal de
			risco → novo compromisso → disputa → execução); a resolução
			(promover a mutual-dependency? redesenhar como policy
			reaction? aceitar redesenho de fronteira?) é decisão de
			design DDD separada, fora do escopo deste SRR e do adr-117.
			Promoção sc-cm-07 warn→reject ocorrerá em ADR follow-on
			quando os 4 forem resolvidos em PRs de modelagem dedicados.

			Verificação empírica:
			- cue vet ./... exit 0;
			- structural-check-runner.py --self-test PASS (4 casos
			  sintéticos cobrindo: acíclico, ciclo 2-nós, ciclo 4-nós,
			  filtro exclui aresta que criaria ciclo);
			- runner sobre dados reais (--mode default): EXATAMENTE 4
			  WARN de sc-cm-07, 0 bloqueantes, exit 0 — match exato
			  com diagnóstico documentado em adr-117.
			"""
	}]

	findings: {}

	summary: """
		sc-cm-07 (directed-acyclicity, primeiro consumidor do kind via
		adr-117) born-warn. Conforma #StructuralCheck (tq-sc-01/02/03
		passados). 4 ciclos pré-existentes documentados como findings
		warn (drc↔cmt, fce↔tcm, cmt→rew→dlv→bdg→cmt, fce→drc→cmt→rew→
		fce). Promoção warn→reject ocorrerá em ADR follow-on quando os
		ciclos forem resolvidos.
		"""

	singleRoundRationale: """
		Uma rodada basta: instância direta do kind definido em adr-117
		(aprovado em 3 ciclos antes da escrita, incluindo calibração de
		direction como discriminador e diagnóstico empírico antes do
		check ser ativado). Conformidade verificada por cue vet + self-
		test + execução do runner sobre dados reais com match exato dos
		4 ciclos. Sem espaço de decisão aberto a red-team adicional —
		decisão de resolver os 4 ciclos é DDD design, fora do escopo
		deste SRR.
		"""
}
