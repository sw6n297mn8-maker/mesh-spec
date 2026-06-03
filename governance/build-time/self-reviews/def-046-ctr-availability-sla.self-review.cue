package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def046: build_time.#SelfReviewReport & {
	reportId: "srr-def-046-ctr-availability-sla"

	artifactPath:       "architecture/deferred-decisions/def-046-ctr-availability-sla.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-03"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-046 (SLA numérico de indisponibilidade do CTR para o fail-closed do CMT,
			deferido per adr-142 decisão 5). Avaliado contra universalCriteria + tq-def-01..04.
			tq-def-01 (trade-off concreto): custo evitado (comprometer a spec a um número que a primeira
			calibração de produção contradiria) vs custo de continuar (nenhum até o golden-example
			exercitar o caminho CTR real — e ele usa adapter-stub). Não é "fazer depois". Pass.
			tq-def-02 (triggers codificados): manual-review conforme #Trigger. Pass.
			tq-def-03 (≥1 non-manual OU manual-only justificado): manual-only JUSTIFICADO — a condição
			("existe telemetria de latência do CTR em produção") não é machine-evaluable a partir de
			mesh-spec (runtime vive em mesh-runtime, fora de escopo); reason ≥40 runes. Pass.
			tq-def-04 (coerência custo-escopo): low + local — default fail-closed é seguro; escopo
			restrito ao gate de ProposeCommitment do CMT. Coerente. Pass.
			uq-02 (Mesh): QueryContractTerms, fail-closed, golden-example/adapter-stub, mesh-runtime —
			específico. uq-03: originatingArtifacts (adr-142 + session:fix-cmt-bd-mutual-acceptance)
			válidos. uq-08 (conforma #DeferredDecision): status open, description≥50, deferralRationale
			≥100, triggerCalibrationRationale≥50, costOfDeferral{low,local,desc≥50}, triggers≥1; cue vet
			EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-046 defere o SLA NUMÉRICO de indisponibilidade do CTR (o fail-mode fail-closed já está
		decidido em adr-142; só o threshold é deferido) porque calibrá-lo exige a distribuição real de
		latência de QueryContractTerms em produção, inexistente na Phase 0. Trigger manual-review
		justificado (condição não machine-evaluable a partir de mesh-spec). low/local. Estável em 1
		round, 0 findings.
		"""

	singleRoundRationale: """
		Deferral com fail-mode já decidido (adr-142) e calibração travada pelo founder (low/local,
		manual-review com reason articulando por que automação não é viável); conformance a
		#DeferredDecision verificável por inspeção direta (MinRunes dos campos, shape do trigger, cue
		vet EXIT=0). Trade-off concreto articulado — sem ambiguidade que rounds adicionais resolveriam.
		"""
}
