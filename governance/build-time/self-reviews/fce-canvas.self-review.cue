package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fceCanvas: build_time.#SelfReviewReport & {
	reportId: "srr-fce-canvas"

	artifactPath:       "contexts/fce/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-01"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Canvas FCE (Financial Commitment Execution) — primeira aplicação real de
			P13/adr-125 (boundary-derivation) e do PG canvas section-by-section per
			manualAuthoringProtocol (adr-057), com founder gate em cada uma das 9
			sections. Self-review integrado round-1: identity (code=fce, contorno P11);
			classification (core, compliance-enforcer, custom); domainRoles (execution
			primary + gateway secondary); 4 capabilities; communication (8 inbound + 8
			outbound, nomes reconciliados); 9 businessDecisions (P11/P10/dp-04/dp-05/
			ax-07/P0); 5 stakeholders + 3 costsEliminated + 2 incentive vectors; ownership
			3 autonomous + 4 supervised + 4 escalation; 5 assumptions + 6 openQuestions +
			7 verificationMetrics; rationale root. Auto-checks tq-cv-01..10 PASSED. Par
			fce↔tcm gate-acíclico por events-required filter (adr-120). cue vet
			./contexts/fce/ + ./strategic/ EXIT=0.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 (2026-06-01, correção pf-scf-1 via adr-137 — canal de disbursement).
			Edit: +1 event-consumer em communication.inbound {sourceContext:"scf",
			event:"ReceivableAdvanceOriginated", reaction: desembolsa o advance ao
			fornecedor sob PrePaymentGuard/P11 — a interação do guard com a fonte de
			capital (próprio/parceiro) é DEFERIDA (def-036); description: aresta
			scf-to-fce, ciclo bidirectional-orchestration}. Decisão de escopo: NÃO modelar
			a semântica do guard por fonte (isso é def-036) — só abrir o canal.
			Consistência cross-section: o consumer novo torna a aresta scf→fce
			bidirecional-válida e dá canal à prosa ce-06 (l.654) que já afirmava
			"antecipação originada por SCF... execução do FCE" (antes sem aresta). É um
			2º gatilho de execução do FCE (além de InvoiceIssued) — registrado; o regime
			(guard por fonte) fica em def-036. Re-checados uq-03 (sourceContext scf existe
			no context-map via aresta nova), uq-05 (limitação guard-por-fonte declarada na
			reaction → def-036), uq-07 (zero placeholder), uq-08 (cue vet EXIT=0). Sem
			novos findings. (Imprecisão histórica "budget allocation" / drifts PG↔schema
			do round 1 permanecem fora de escopo deste edit.)
			"""
	}]

	findings: {}

	summary: """
		Canvas FCE via manual authoring section-by-section (9 founder gates, adr-057);
		primeira aplicação real de P13/adr-125. Round 1: 0 fail/warn. Round 2
		(2026-06-01): correção pf-scf-1 (adr-137) — +1 event-consumer (scf,
		ReceivableAdvanceOriginated) abre o canal de disbursement scf→fce e dá lastro
		topológico à prosa ce-06; guard-por-fonte deferido (def-036). Estável; zero
		findings em ambos os rounds. cue vet EXIT=0.
		"""
}
