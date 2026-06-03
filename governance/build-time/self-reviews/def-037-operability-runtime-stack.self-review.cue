package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def037: build_time.#SelfReviewReport & {
	reportId: "srr-def-037-operability-runtime-stack"

	artifactPath:       "architecture/deferred-decisions/def-037-operability-runtime-stack.cue"
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
			Self-review do def-037 (stack de operability runtime — backend de observabilidade +
			CI/CD + IaC — deferida per adr-139). Avaliado contra universalCriteria + tq-def-01..04.

			tq-def-01 (deferralRationale = trade-off concreto): custo evitado (especular stack de
			telemetria/CI/IaC antes de haver runtime a observar) vs custo de continuar (spec sem
			backend de observabilidade, mitigado por OTel vendor-neutro + mesh-runtime como operador).
			Não é "fazer depois". Pass.
			tq-def-02 (triggers codificados): trigger adjacent-need file-exists em adr-141 — kind +
			path machine-evaluable. Pass.
			tq-def-03 (≥1 non-manual-review): SIM — adjacent-need é non-manual (melhor que def-023,
			que só conseguia manual-review por id imprevisível; aqui o path adr-141 é conhecido,
			assinado por adr-139 a WI-103). Pass.
			tq-def-04 (coerência custo-escopo): severity low + blastRadius cross-cutting — low porque
			observability é runtime puro (não bloqueia codegen P1 nem Port contracts P7); cross-cutting
			porque toca a operação de todos os BCs no runtime ao materializar. Coerente. Pass.
			uq-01 (WHY): deferralRationale registra POR QUE deferir (operability é runtime/ops, atrás
			do Port — P2; buy/generic — theory-of-firm), não o que faz. Pass.
			uq-02 (Mesh): Ports/P2/P7, mesh-runtime, real-options, adr-138 — específico. Pass.
			uq-03 (refs): originatingArtifacts (adr-139, wave-plan) existem; trigger aponta adr-141
			(forward-ref intencional — file-exists dispara quando o kernel for autorado). Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #DeferredDecision): status open, description≥50, deferralRationale≥100,
			triggerCalibrationRationale≥50, originatingArtifacts, costOfDeferral{low,cross-cutting,
			desc≥50}, triggers≥1; cue vet EXIT=0. Pass.
			"""
	}]

	findings: {}

	summary: """
		def-037 defere a stack de operability runtime (backend de telemetria, CI/CD, IaC) per adr-139
		filtro spec×runtime — é seleção de vendor atrás do Port (P2), não decisão de spec. Trigger
		adjacent-need file-exists em adr-141 (revisita quando o kernel/Ports existirem). low/cross-cutting:
		runtime puro, não bloqueia codegen/Port contracts, mas toca a operação de todos os BCs ao
		materializar. Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Deferral com calibração travada pelo founder (low/cross-cutting, trigger adjacent-need→adr-141);
		conformance a #DeferredDecision verificável por inspeção direta (MinRunes dos campos, shape do
		trigger, cue vet EXIT=0). Trade-off concreto articulado + trigger non-manual machine-evaluable —
		sem ambiguidade que rounds adicionais resolveriam.
		"""
}
