package build_time

// terminal-validation-evidence.cue -- Evidencia do run INAUGURAL da composicao
// do cenario terminal (ge-fce-prepayment-guard-terminal, WI-138 / adr-138
// decisao 3). Irmao de codegen-validation-evidence.cue (run-001), mesma forma
// e regime: schema-exempt (promocao a tipo first-class so com recorrencia de
// runs terminais); direcao evidencia->declaracao preservada — esta evidencia
// REFERENCIA o cenario; o cenario permanece declaracao-pura (tq-ge-01) e
// INTOCADO (decisao founder 2026-06-12; precedente N5(a)/run-001: evidencia
// historica gate-only, declaracao estavel).
//
// RUN DE REFERENCIA: o CI verde do mesh-runtime PR #7 (actions run
// 27441751029: build-test 28/28 + regenerate-check), toolchain limpa de CI.
// O run local com MESH_CODEGEN_ALLOW_DIRTY=1 NAO e evidencia canonica
// (escape de dev local per contrato 2b do harness).

terminalValidationEvidence: {
	terminalValidationRef: "ge-fce-prepayment-guard-terminal" // contexts/fce/golden-examples/prepayment-guard-terminal.cue
	status:                "executed"

	runRef: "mesh-runtime#7 / actions run 27441751029 (CI, toolchain limpa; build-test + regenerate-check verdes)"

	execution: {
		date:          "2026-06-12"
		specCommit:    "ab374b1d1b92928262d7bdaaee809c0066b7720b" // main do mesh-spec no run (tip pos-#137; checkout do regenerate-check)
		runtimeCommit: "74e3224d5489051c3fcb68893ecd93036150bcf0" // squash do #7 na main — arvore identica ao head ed1c64b exercitado pelo CI
		testsPassed:   28
		testsTotal:    28
		compositionCases: [
			"valid - composition CMT-DLV-INV-REW-FCE-BKR ends settled with PaymentSettled exactly once and joined refs",
			"blocked - tampered integrity proof makes verify answer invalid and the Payment stays guarded with zero payment events",
		]
	}

	// Gates do cenario avaliados ITEM A ITEM contra o resultado (condicoes
	// fixadas ANTES do run, mesh-spec #137 — real-options adr-138 item 7).
	gates: {
		continuar: "reached"
		continuarBreakdown: [
			"(i) composicao sobe SO com reference adapters: zero vendor — 1 InMemoryEventLogAdapter compartilhado entre os streams de CMT/DLV/FCE + 1 InMemoryEvidenceAdapter para custodia e verify",
			"(ii) >=1 fluxo valido ate settled com PaymentSettled EXACTLY-ONCE: assert nominal 'asrt/inv-settled-fact-canonical: PaymentSettled exactly once per Payment'",
			"(iii) >=1 bloqueio com guarded preservado: GuardFailed(MONEY_MOVES_ONLY_ON_PROOF) asserted no guard especifico; Payment permanece GUARDED; stream do Payment sem nenhum evento de pagamento",
		]
		pivotar:             "not-reached" // nenhum elo exigiu cola nao-derivavel da spec — zero candidatos a PIVOTAR reportados na execucao
		abandonar:           "not-reached" // zero edicao semantica de codigo gerado (pathspecs gerados limpos, verificado via additions-check -uall)
		falsificationSignal: "not-fired" // 3 slices hand distintos (MutualAcceptanceSlice/VerificationSlice/PaymentSlice) + teste de composicao — ZERO colapso da composicao em aggregate unico
	}

	// Limites HERDADOS do cenario e do desenho da composicao (verbatim — a
	// evidencia registra o que o run NAO prova, com a mesma honestidade do
	// que prova).
	declaredLimits: [
		"INV: real no tipo e nos dados; emissao construida pelo teste — sem am-invoice/skeleton; agg INV entra quando INV ganhar manifests (rtd-015 do mesh-runtime)",
		"REW/BKR: fixtures — fabricas hand instanciando os fixture-contracts de contexts/fce/schemas/events.cue (forward-ref oq-fce-4; reconciliar quando REW/BKR materializarem schemas)",
		"joins por commitmentRef/entityRef/evidenceRef hand-encoded no teste (interino def-049; resolucao mecanica de #VarRef/filter e quantificacao = def-053/def-054)",
		"inv-guard-deterministic materializado NESTE NIVEL como re-verificacao dupla no EvidencePort (mesmo input -> mesmo receipt, rtd-012); determinismo de replay completo e propriedade do stream, coberta pelas suites de Port (pm-cmt/pm-dlv tier-2)",
	]

	verdict: {
		outcome:   "CONTINUAR"
		decidedBy: "founder"
		date:      "2026-06-12"
		rationale: """
			Veredito humano por causa-raiz sobre o run (adr-148: exit codes e
			gates INFORMAM, nunca derivam o desfecho mecanicamente; precedente
			run-001): as 3 condicoes do continuar foram atingidas e verificadas
			independentemente; zero candidatos a PIVOTAR; falsificationSignal
			nao disparado. A composicao provou que o template do golden-example
			COMPOE entre BCs — adr-138 decisao 3 cumprida: o walking skeleton
			executa o primeiro fluxo de negocio completo (commitment -> entrega
			com evidencia -> pagamento condicionado pelo PrePaymentGuard) com
			dinheiro se movendo APENAS quando a operacao comprova (P11).
			"""
	}

	blockedBy: []

	rationale: """
		Evidencia do run inaugural da composicao do cenario terminal,
		executado como suite hand no gradle test do mesh-runtime (rtd-015:
		entra automaticamente no build-test do CI e no pipeline P1 sem
		mudanca de harness). Direcao evidencia->declaracao preservada: esta
		evidencia referencia o ge-fce-prepayment-guard-terminal; o cenario
		permanece declaracao-pura e re-runnable — evidencias futuras sao
		por-run, a declaracao e estavel.
		"""
}
