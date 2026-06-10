package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

goldenExamplePg: build_time.#SelfReviewReport & {
	reportId: "srr-golden-example-pg"

	artifactPath:       "architecture/production-guides/golden-example.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-10"

	roundsExecuted: 1
	maxRounds:      3
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 2
		summary: """
			Re-review isolated-subagent (contexto fresco, separado da autoria) do PG de #GoldenExample APOS o update
			WI-139 (template generalization); substitui o self-review de 2026-06-08 da autoria original do PG (mesmo
			artifactPath -- evidencia point-in-time do estado corrente; o review anterior fica no historico git).
			O update sao 3 adicoes de escopo minimo (sem ADR, sem toque em schema/structural-check/wave-plan/ledger):
			(1) ge-cmt-mutual-acceptance declarado como exemplar de referencia do fan-out (adr-138 P3c; adr-145);
			(2) guidance de derivacao que torna a divergencePolicy CONTAVEL -- lista ESTRUTURA (replicar; divergir
			exige ADR ANTES) vs lista CONTEUDO (varia normal, NAO conta) + a regra "divergencia estrutural > 0 sem
			ADR = falha do fan-out (adr-138 falsificationCondition); CONTEUDO nunca conta"; (3) citacoes de coerencia
			leves (divergencia registrada alimenta a falsificationCondition de adr-147; o template herda a triade de
			codegen P14/adr-146/adr-147 via codegen-contract, sem re-declarar).
			Red team nos 4 pontos pedidos. (i) ANCORAS da Adicao 2 -- cada elemento ESTRUTURA deriva de ancora
			committada, verificado no disco: (a/b) pipeline specSlice->#Assertion->golden-example->gates = adr-138
			itens 6-7; (c) port-contracts deriva do PortManifest do proprio BC = adr-141; (d) zero-drift #Assertion
			<->domain-invariant na mesma fatia = adr-080 + codegen-contract.testDerivation.convergence + P0. Os 4
			SUPPORTED; nenhuma zona-cinza -> autoria prosseguiu sem inventar criterio (sem threshold/check/campo novo).
			(ii) CONTABILIDADE: "divergencia estrutural > 0 sem ADR" e machine-countable -- espelha o observableSignal
			(2) da falsificationCondition de adr-138; variacao de CONTEUDO explicitamente fora da contagem. PASS.
			(iii) FIDELIDADE-DE-COERENCIA: as citacoes da Adicao 3 apontam (nao copiam) adr-147 e a triade via
			codegen-contract -- P0 ponteiro, nao copia; fidelidade conferida no disco. PASS. (iv) NAO-DUPLICACAO:
			as adicoes referenciam adr-138/145/080/141/codegen-contract/adr-147 por id, zero conteudo copiado;
			anti-meta = zero hit de narracao-de-processo no diff do PG. PASS.
			Findings: 2 INFO de precisao de citacao CORRIGIDOS na sessao (a cadeia que termina em "gates" e itens
			6-7, nao item 6; sc-pg-02/03 guardam a bijecao workOrder<->sections, nao a ordem). 1 WARN RESOLVIDO: o
			reviewer sugeriu tie-break explicito em "A REGRA" para o caso de um BC exigir conjunto de Ports diferente
			de ge-cmt; o founder escolheu explicitar -- frase de tie-break adicionada a "A REGRA" (Port set diferente
			= CONTEUDO; a estrutura replicada e derivar do PortManifest do proprio BC, ver elemento (c); adr-141).
			Veredito do subagente: APROVADO.
			"""
	}]

	findings: {}

	summary: """
		PG de #GoldenExample apos WI-139 conforma #ProductionGuide e mantem a bijecao workOrder<->5 sections,
		declaracao-pura. Re-review isolated-subagent APROVADO, 0 fail. As 3 adicoes (exemplar nomeado ge-cmt;
		guidance ESTRUTURA/CONTEUDO que torna a divergencePolicy contavel; coerencia leve com adr-147 e a triade
		de codegen) sao referencia-nao-copia (P0) e cada elemento ESTRUTURA esta ancorado em artefato committado
		(adr-138 itens 6-7; sc-pg-02/03; adr-141; adr-080 + codegen-contract + P0) -- verificado no disco, sem
		zona-cinza, sem criterio inventado. 2 INFO de precisao de citacao CORRIGIDOS (itens 6-7; bijecao
		workOrder<->sections). 1 WARN RESOLVIDO: o tie-break explicito do caso Port -- founder escolheu explicitar;
		frase adicionada a "A REGRA" (Port set diferente = CONTEUDO via adr-141, elemento (c)). cue vet ./... = 0;
		structural-runner 0 bloqueante (sc-pg-* e sc-srr-01 verdes).
		"""

	singleRoundRationale: """
		1 round: zero fail. Das observacoes do review isolado, as 2 INFO eram correcao trivial de precisao de
		citacao, aplicadas na sessao (nao alteram semantica); o 1 WARN (tie-break do caso Port) foi RESOLVIDO --
		o founder escolheu explicitar e a frase de tie-break foi adicionada a "A REGRA" (Port set diferente =
		CONTEUDO, ancorado em adr-141 / elemento (c)). Os 4 pontos do red team resolvidos (anchors SUPPORTED /
		countability PASS / coherence-fidelity PASS / non-duplication PASS). Nada a iterar internamente.
		"""
}
