package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def038: build_time.#SelfReviewReport & {
	reportId: "srr-def-038-compute-platform-deploy-topology"

	artifactPath:       "architecture/deferred-decisions/def-038-compute-platform-deploy-topology.cue"
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
			Self-review do def-038 (compute platform + topologia FÍSICA de deploy — k8s/serverless/VMs,
			mapeamento módulo→runtime físico — deferida per adr-139). Avaliado contra universalCriteria
			+ tq-def-01..04.

			tq-def-01 (deferralRationale = trade-off concreto): custo evitado (inventar mapeamento físico
			+ plataforma antes de haver kernel materializado e carga real) vs custo de continuar (kernel
			lógico sem contraparte física, mitigado porque nenhum deploy real ocorre antes do
			golden-example). Não é "fazer depois". Pass.
			tq-def-02 (triggers codificados): trigger adjacent-need file-exists em adr-141 — a topologia
			física só faz sentido depois da lógica existir; kind + path machine-evaluable. Pass.
			tq-def-03 (≥1 non-manual-review): SIM — adjacent-need non-manual, path adr-141 conhecido. Pass.
			tq-def-04 (coerência custo-escopo): severity medium + blastRadius cross-cutting — medium (não
			low, distinto de def-037) porque deferir compute/deploy eventualmente bloqueia o deploy real
			do runtime (custo cumulativo quando o golden-example sair do local); cross-cutting porque
			plataforma + granularidade de deploy afetam todos os módulos/BCs. Coerente. Pass.
			uq-01 (WHY): deferralRationale registra POR QUE (topologia física é runtime/deploy, vive no
			mesh-runtime fora de escopo, depende de vendor de compute não-escolhido). Pass.
			uq-02 (Mesh): topologia lógica BC→módulo, Ports, mesh-runtime, adr-138, golden-example —
			específico. Pass.
			uq-03 (refs): originatingArtifacts (adr-139, wave-plan) existem; trigger adr-141 (forward-ref
			intencional). Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #DeferredDecision): status open, description≥50, deferralRationale≥100,
			triggerCalibrationRationale≥50, originatingArtifacts, costOfDeferral{medium,cross-cutting,
			desc≥50}, triggers≥1; cue vet EXIT=0. Pass.
			"""
	}]

	findings: {}

	summary: """
		def-038 defere a plataforma de compute + a topologia FÍSICA de deploy per adr-139 — a spec fixa
		a topologia LÓGICA (BC→módulo, em adr-141); COMO os módulos rodam fisicamente é runtime/deploy,
		no mesh-runtime fora de escopo. Trigger adjacent-need file-exists em adr-141 (a física segue a
		lógica). medium/cross-cutting: no caminho crítico do runtime sair do local (custo cumulativo),
		afeta todos os módulos/BCs. Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Deferral com calibração travada pelo founder (medium/cross-cutting, trigger adjacent-need→adr-141);
		conformance a #DeferredDecision verificável por inspeção direta (MinRunes, shape do trigger, cue
		vet EXIT=0). Trade-off concreto + trigger non-manual machine-evaluable; severity medium justificada
		pelo custo cumulativo de deploy — sem ambiguidade que rounds adicionais resolveriam.
		"""
}
