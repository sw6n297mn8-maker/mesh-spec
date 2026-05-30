package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr128: build_time.#SelfReviewReport & {
	reportId: "srr-adr-128"

	artifactPath:       "architecture/adrs/adr-128-money-on-proof-invariant-fce.cue"
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
			ADR-128 formaliza a instanciação de P11 (dinheiro só se move
			quando a operação comprova) na camada de execução financeira do
			FCE, e detalha o mecanismo criptográfico que torna a falsificação
			de evidência inviável (assinatura digital + hash chain +
			notarização de eventos), referenciado pela assumption as-fce-1 e
			pelo manipulationCost de sh-06 no canvas. Designa o FCE como
			enforcer canônico de P11 e referencia as 3 businessDecisions que o
			operacionalizam (bd-money-moves-only-on-proof, bd-prepayment-guard-
			deterministic, bd-conditional-retention-release). tq-adr-01 PASSED:
			alternativas explicitadas e rejeitadas (dobrar P11 no ADR de
			criação adr-127 — rejeitado: P11 é cross-cutting e merece ponteiro
			estável; omitir detalhe criptográfico — rejeitado: 'inviável'
			viraria hand-wave sem o mecanismo). tq-adr-02 PASSED:
			reversibility=medium, blastRadius=cross-cutting (P11 ancora
			integração FCE↔INV↔REW↔BKR + integridade legal SCD/Bacen).
			tq-adr-03/04 PASSED: affectedArtifacts=[canvas] (BDs instanciam o
			invariante; path criado em adr-127 no mesmo PR).
			principlesApplied=[P11,P10,P0]. Sem novo schema/structural-check.
			"""
	}]

	findings: {}

	summary: """
		ADR-128 instancia P11 (money-on-proof) no FCE + detalha o mecanismo
		criptográfico (assinatura + hash chain + notarização) que sustenta
		as-fce-1 e o manipulationCost de sh-06. Referencia as 3 BDs
		operacionais. Separado de adr-127 para ponteiro estável (P11
		cross-cutting). affectedArtifacts=[canvas FCE].
		"""

	singleRoundRationale: """
		Invariante P11 já validada na section business-decisions do canvas
		(founder gate S6); este ADR é o registro canônico da instanciação +
		do mecanismo criptográfico anotado pelo founder. Alternativas (fold no
		adr-127; omitir cripto) explicitadas e rejeitadas. Round único
		suficiente.
		"""
}
