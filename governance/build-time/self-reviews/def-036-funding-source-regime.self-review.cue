package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def036: build_time.#SelfReviewReport & {
	reportId: "srr-def-036-funding-source-regime"

	artifactPath:       "architecture/deferred-decisions/def-036-funding-source-regime.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

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
			Self-review do def-036 (escopo amplo do disbursement deferido: escolha da
			fonte de funding próprio/parceiro, regime de risco por modo, impacto no
			PrePaymentGuard). Avaliado contra 8 universalCriteria + tq-def.

			uq-01/tq-def-01 (deferralRationale = trade-off concreto): os detalhes de cada
			modo dependem de condições que ainda NÃO existem (receita do Mesh + autorização
			BC para capital próprio; parceiros de funding concretos); modelar agora seria
			especular sobre regime regulatório não-controlado. Custo evitado articulado
			(resposta inventada) vs custo de continuar (canal sem regime). Pass.
			uq-03 (refs): originatingArtifacts apontam paths .cue existentes/criados no PR
			(record scf.cue com pf-scf-1, adr-137, canvas SCF, canvas FCE). Pass.
			uq-05 (limitações): costOfDeferral declara que o canal existe (escopo mínimo)
			mas implementar disbursement sem regime de fonte arriscaria inventar a resposta;
			mitigado por canal modelado + pendência rastreada. Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #DeferredDecision): status open com description≥50,
			deferralRationale≥100, triggerCalibrationRationale≥50, originatingArtifacts,
			costOfDeferral{severity,blastRadius,description}, triggers≥1; cue vet EXIT=0. Pass.
			tq-def-02 (triggers codificados): trigger manual-review com reason articulado. Pass.
			tq-def-03 (≥1 non-manual-review OU justificativa de manual-only): manual-only
			JUSTIFICADO — o gatilho (primeiro parceiro de funding real OU autorização BC
			encaminhada) é evento de negócio/ops não machine-evaluable; nenhum proxy de
			arquivo o detecta. Warn aceitável por justificativa explícita. Pass.
			tq-def-04 (coerência custo-escopo): severity medium + blastRadius cross-cutting
			coerentes (afeta SCF+FCE+guard, mas o canal mínimo já existe). Pass.
			"""
	}]

	findings: {}

	summary: """
		def-036 defere conscientemente o escopo amplo do disbursement do advance: como a
		fonte de funding (próprio vs parceiro) é escolhida, o regime de risco por modo, e
		o impacto no PrePaymentGuard do FCE. Originado por adr-137/pf-scf-1 (escopo mínimo
		abriu o canal scf→fce; o regime de fonte fica para quando as condições existirem —
		receita+autorização BC OU parceiro concreto). Trigger manual-review (evento de
		negócio não machine-evaluable). Estável em 1 round.
		"""

	singleRoundRationale: """
		Deferimento desenhado no pré-flight do fork (escopo mínimo vs amplo separado pelo
		founder): o canal de execução é resolvido por adr-137; o regime de fonte depende de
		condições externas inexistentes (receita Mesh, autorização BC, parceiros). O DD
		registra trade-off concreto + trigger manual-only justificado; verificável por
		inspeção (conformance a #DeferredDecision). Sem ambiguidade pendente.
		"""
}
