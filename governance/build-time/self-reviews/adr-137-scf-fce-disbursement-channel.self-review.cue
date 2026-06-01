package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr137: build_time.#SelfReviewReport & {
	reportId: "srr-adr-137-scf-fce-disbursement-channel"

	artifactPath:       "architecture/adrs/adr-137-scf-fce-disbursement-channel.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-01"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-137 (resolve pf-scf-1: canal de disbursement scf→fce +
			dois modos de funding). NOTA: rollout prescreve isolated-subagent para adr;
			aqui self-reported (manual takeover). Avaliado contra 8 universalCriteria +
			tq-adr.

			uq-01 (WHY): rationale explica por que tipar o ciclo (P13 ônus invertido —
			ciclo é defeito-por-default, legitimado por kind nomeado + ADR), por que o
			canal é sempre FCE (P0 — um executor canônico de movimento de dinheiro), e
			por que o escopo amplo defere (modos dependem de condições inexistentes). Pass.
			uq-02 (Mesh): dois modos de funding (próprio sob licença SCD + parceiro) é
			específico da Mesh; trocar 'Mesh' por 'qualquer fintech' falha. Pass.
			uq-03 (refs): affectedArtifacts (context-map, scf canvas, fce canvas) existem;
			def-036 criado no mesmo PR; defersTo def-036. Pass.
			uq-04 (princípios): P13 (typing do ciclo), P0 (canal único de execução), P12
			(legitimidade gate-enforçada por sc-cm-07). Sem contradição. Pass.
			uq-05 (limitações): N1 declara que a semântica do PrePaymentGuard por fonte
			fica deferida (def-036) — só o canal é aberto aqui. Pass.
			uq-06 (ubiquitous language): disbursement/canal-de-execução/fonte-de-funding
			estáveis. Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #ADR): decisionClass/decider/status/reversibility/blastRadius/
			falsificationCondition{condition,observableSignal}/affectedArtifacts/defersTo/
			principlesApplied/supersedes presentes; cue vet EXIT=0. Pass.
			uq-09 (section gates): N/A — adr em rollout isolated-subagent, não manual.
			tq-adr-01 (alternativas): context avalia (A-evento+typed-cycle [escolhida]),
			(A-sync sem events [rejeitada — command-surface novo no FCE + acoplamento sync]),
			(B reframe-only [rejeitada — negaria uma relação que ambos os canvases afirmam]). Pass.
			tq-adr-02 (metadata de risco): reversibility medium (typing+aresta reversível
			com esforço); blastRadius cross-cutting (context-map + 2 canvases + def). Pass.
			tq-adr-03 (paths reais): todos existem ou criados no PR. Pass.
			tq-adr-04 (rastreabilidade ≥1): affectedArtifacts non-empty (3). Pass.
			"""
	}]

	findings: {}

	summary: """
		adr-137 resolve pf-scf-1 (contradição bd-structures-not-executes vs topologia):
		modela a aresta scf→fce (OHS/ACL, ReceivableAdvanceOriginated), tipa o ciclo
		scf↔fce como bidirectional-orchestration (ambas as arestas; reusa kind existente,
		zero schema novo), fixa o canal de execução como SEMPRE o FCE e declara a fonte
		de capital como variável (próprio/parceiro = dois modos de funding). Escopo amplo
		(escolha da fonte, risco por modo, impacto no PrePaymentGuard) deferido a def-036.
		Estável em 1 round, zero findings.
		"""

	singleRoundRationale: """
		Decisão de topologia/fronteira derivada do fork apresentado ao founder com fatos
		(report da topologia scf↔fce): kind travado (bidirectional-orchestration), patterns
		travados (OHS/ACL), escopo mínimo vs amplo separado (def-036). O ADR registra a
		decisão já tomada + a justificativa do ciclo tipado (P13); critérios verificáveis
		por inspeção direta (conformance a #ADR, sc-cm-07 exclui o ciclo tipado). Sem
		ambiguidade pendente.
		"""
}
