package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

firstClassTraceabilityFlipReject: build_time.#SelfReviewReport & {
	reportId: "srr-first-class-traceability-flip-reject"

	artifactPath:       "architecture/structural-checks/first-class-traceability.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-17"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 -- self-review self-reported do FLIP warn->reject da instancia sc-fct-01
			(ato final do adr-151 passo vi; executa o step ja decidido no adr-153, NAO novo ADR).
			SRR distinto do de criacao da instancia (srr-first-class-traceability, adr-153,
			enforcement warn) -- append-only: dois eventos distintos (nascimento born-warn vs
			promocao a reject). PRE-CONDICAO confirmada contra MAIN (3803877, pos-rew, nao local):
			(1) cue export da worklist = [] (zero entries); (2) evaluator sc-fct-01 = report VAZIO
			(0 findings). A campanha de backfill Forma A fechou: os 48 conceitos cross-contract
			cobertos nas 4 ondas (cmt 20 + dlv 11 + fce 8 + rew 9), worklist zerada. Logo o reject
			nao barra nada hoje (casa 100% coberta) -- a condicao do passo vi do adr-153 ('promove
			quando todo cross-contract estiver declarado-ou-na-worklist E a worklist fechar') esta
			cumprida. Mudanca de substancia UNICA: enforcement "warn"->"reject"; comment + rationale
			da instancia atualizados (editorial) de futuro ("promove quando fechar") para executado
			("promovido"). Worklist VAZIA mantida no repo (decisao do flip): o evaluator ainda a le;
			vazia e valida e admite futuras pendencias reconhecidas sem reabrir o gate. GATE
			AUTO-DEMONSTRADO (como o derived-drift-gate): com reject ligado, quebrar temporariamente
			um conceito cross-contract (firstClass:false) faz o runner BLOQUEAR (exit nao-zero,
			sc-fct-01 FAIL); reverter -> verde. Prova que o reject morde. cue vet EXIT=0; runner 0
			bloqueante no estado real. 0 fail, 0 warn.
			"""
	}]

	findings: {}

	summary: """
		Flip warn->reject da instancia sc-fct-01 (first-class-traceability) -- ato final do adr-151
		passo vi, executando o step ja decidido no adr-153 (sem ADR novo). Pre-condicao confirmada
		contra MAIN: worklist [] + evaluator vazio (48 conceitos cobertos nas 4 ondas). Substancia:
		enforcement warn->reject; comment/rationale atualizados de futuro para executado; worklist
		vazia mantida. Gate auto-demonstrado (reject barra um conceito quebrado; reverte -> verde).
		SRR distinto do de criacao (append-only). cue vet EXIT=0. Estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: mudanca cirurgica de enforcement (1 campo) + 2 edicoes editoriais de coerencia,
		conformando ao #StructuralCheck (cue vet EXIT=0); a decisao ja estava tomada (adr-153 passo
		vi) e a pre-condicao foi confirmada deterministicamente contra main (worklist [] + evaluator
		vazio) ANTES do flip; o comportamento do reject foi auto-demonstrado end-to-end. Nenhum
		finding tocou a substancia; round unico porque nao ha decisao nova a deliberar -- so a
		execucao verificada de um step pre-decidido.
		"""
}
