package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def026CmtDrcBidirectionalOrchestration: build_time.#SelfReviewReport & {
	reportId: "srr-def-026-cmt-drc-bidirectional-orchestration"

	artifactPath:       "architecture/deferred-decisions/def-026-cmt-drc-bidirectional-orchestration.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-026 (W1 drc↔cmt + cascata W3, Família A da
			taxonomia de exclusão do grafo do sc-cm-07). Proposta passou por
			3 ciclos pré-aprovação:

			Ciclo 1 (propose): agrupamento topológico (3 defs cobrindo 4 ciclos).
			Ciclo 2 (refine): preferência por edição de schema vs partnership
			forçada — opção (c) [PREFERRED] explicitada em optionsConsidered.
			Ciclo 3 (validate subdomains): leitura de subdomain DRC confirmou
			"Orquestração do lifecycle de exceções" + assimetria de tipos
			(DRC=supporting, CMT=core); refutou opção (a) partnership.

			Conformância #DeferredDecision (tq-def-01/02/03/04):

			(tq-def-01 — deferralRationale articula trade-off concreto):
			deferralRationale ≥100 runes explicita MOTIVO (decisão DDD +
			sequenciamento de PRs) + RISCO (decisão apressada → partnership
			falsa ou deleção de aresta) + CUSTO de deferir (1 ciclo WARN +
			cascata W3; reversível mecanicamente). NÃO é "fazer depois quando
			der tempo". PASS.

			(tq-def-02 — triggers codificados, não prose): triggers conforma
			#Trigger discriminated union — manual-review com reason ≥40 runes
			+ adjacent-need file-contains com path/pattern machine-evaluable
			via re.search. PASS (cue vet exit 0).

			(tq-def-03 — pelo menos 1 trigger non-manual-review): adjacent-need
			file-contains é non-manual-review machine-evaluable. PASS.

			(tq-def-04 — costOfDeferral coerente com escopo): severity=medium
			+ blastRadius=cross-artifact justificados na description do cost
			(cascata W3 + 3 arquivos afetados + reversibilidade mecânica). PASS.

			Verificação:
			- cue vet ./architecture/deferred-decisions/ EXIT 0;
			- shape conforma à variante "open" do schema (sem triggeredAt/
			  triggeredCondition/resolvedBy/withdrawalRationale);
			- originatingArtifacts cita 5 referências reais (context-map.cue,
			  sc-cm-07, adr-117, contexts/cmt/canvas.cue, strategic/subdomains/
			  drc.cue);
			- triggers[1].condition.pattern com aspas escapadas restringe match
			  a atribuição CUE em instance — evita FP em adr-118 (PR-1).
			"""
	}]

	findings: {}

	summary: """
		def-026 conforma #DeferredDecision (tq-def-01/02/03/04 todos passados).
		Família A da taxonomia (kind semântico novo). Cobre W1 + cascata W3
		do sc-cm-07. 3 ciclos pré-aprovação + validação por leitura de
		subdomain DRC. Verificado: cue vet exit 0; pattern do trigger
		secundário restrito a atribuição CUE para evitar FP em ADR.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round após 3 ciclos de calibração pré-escrita
		(propose → refine → validate subdomains). Conformidade verificada por
		cue vet + análise de conformidade tq-def-NN. Sem espaço de decisão
		aberto a red-team adicional — decisão de design DDD foi tomada antes
		do def existir (def captura a decisão, não a debate).
		"""
}
