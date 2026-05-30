package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr126: build_time.#SelfReviewReport & {
	reportId: "srr-adr-126"

	artifactPath:       "architecture/adrs/adr-126-context-map-naming-shape-reconciliation-fce.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-126 reconcilia naming + shape de 2 arestas do context-map
			(bkr-to-fce, rew-to-fce) com os canvases adjacentes mergeados
			(autoridade per knownLimitations do context-map), no mesmo PR do
			scaffold FCE. bkr-to-fce: events BankSettlementConfirmed →
			[SettlementFinalized/Failed/Indeterminate/FailureClassified/
			InstructionRejected]; commands InitiateBankTransfer →
			[DispatchPaymentInstruction/RequestSettlementCancellation].
			rew-to-fce: events CreditEligibilityDecided →
			[EligibilityEmitted/RiskScoreEmitted]; communication.type
			async→hybrid; queries (ausente) → [QueryEligibility/QueryRiskScore];
			feedbackLoop.kind policy-execution-feedback PRESERVADO.
			tq-adr-01 PASSED: alternativa Q1=B (só naming) explicitada e
			rejeitada (cherry-pick cria dívida). tq-adr-02 PASSED:
			reversibility=high (renomeação reversível sem impacto em dados/
			contratos), blastRadius=cross-artifact (context-map + canvases que
			usam os nomes). tq-adr-03 PASSED: affectedArtifacts=[context-map]
			existe. tq-adr-04 PASSED: affectedArtifacts populado.
			principlesApplied=[P0] — canvas é autoridade, context-map vira
			ponteiro consistente. Acyclicity: nenhuma aresta nova/direção
			alterada; fce↔rew permanece tipado (adr-124), par fce↔tcm permanece
			isento (adr-120) — sc-cm-07 deve manter 0 ciclos. cue vet
			./strategic/ EXIT=0 pós-edit.
			"""
	}]

	findings: {}

	summary: """
		ADR-126 reconcilia 2 arestas do context-map (bkr-to-fce + rew-to-fce)
		com os canvases adjacentes — naming + shape change (rew async→hybrid +
		queries). Aplicação completa de Q1=A (canvas vence). Acyclicity
		preservada (fce↔rew tipado, fce↔tcm isento). cue vet EXIT=0.
		"""

	singleRoundRationale: """
		ADR mecânico-estrutural de reconciliação com diff exato pré-validado
		na section communication do canvas (founder gate S5). Alternativa
		única (Q1=B) explicitada e rejeitada; risco baixo e reversível.
		Acyclicity verificável por construção. Round único suficiente.
		"""
}
