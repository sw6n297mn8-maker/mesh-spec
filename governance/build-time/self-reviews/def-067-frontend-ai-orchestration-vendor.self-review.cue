package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def067FrontendAiOrchestrationVendor: build_time.#SelfReviewReport & {
	reportId: "srr-def-067-frontend-ai-orchestration-vendor"

	artifactPath:       "architecture/deferred-decisions/def-067-frontend-ai-orchestration-vendor.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-23"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do def-067 NOVO (open, low/cross-artifact), sucessor de adr-159: defere o vendor de
			runtime de orquestração de agente IA (não-determinístico, distinto do WorkflowPort de domínio, def-043).

			[tq-def-01 trade-off próprio]: PASS. deferralRationale específico — a 1ª tela (override do FCE) NÃO
			exercita orquestração de agente (o agente recomenda, o humano confirma em ação estruturada); sem superfície
			que prove o vendor, escolher é especulação. Distinto da peça-sync e da design — não copiado de def-060.

			[tq-def-02/03 trigger]: PASS. manual-review com reason ≥40; triggerCalibrationRationale justifica
			manual-only (vendor no frontend-runtime, invisível ao runner — precedente def-060/def-043). Runner skipa →
			sem disparo espúrio (confirmado: evaluate-deferred-triggers não disparou def-067).

			[tq-def-04 custo-escopo]: PASS. low (isolamento FF-FE-01/02/08 é lei; nenhuma tela orquestra agente antes
			do runtime) + cross-artifact (camada de IA + bridge com o domínio — o bridge JÁ é lei, só o vendor atrás
			dele é adiado), não cross-cutting nem low+repo-wide.

			[uq-02/03/08]: PASS. uq-02 quebra na substituição (FF-FE-01/02/08, P2, def-043, frontend-runtime).
			originatingArtifacts [adr-159, def-060] existem. cue vet limpo; shape open.
			"""
	}]

	findings: {}

	summary: """
		def-067 NOVO (open, low/cross-artifact), sucessor per-peça de adr-159, defere o vendor de runtime de
		orquestração de agente IA (distinto do WorkflowPort de domínio, def-043). deferralRationale próprio: a 1ª tela
		(override, human-facing) não exercita orquestração — sem superfície, o vendor é especulação. Trigger
		manual-review justificado (vendor no runtime). Self-review, 1 round.

		VEREDITO: 0 fail / 0 warn / 0 info. tq-def-01..04 satisfeitos (trade-off próprio; manual-only legítimo;
		low+cross-artifact — o bridge da IA já é lei, só o vendor é adiado, logo cross-artifact e não cross-cutting);
		uq-02 quebra na substituição; refs resolvem; cue vet limpo. Estável em 1 round.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque os eixos do def-067 foram exercitados contra o disco: o trade-off é específico
		da peça-orquestração (a 1ª tela não exercita agente — distinto do motivo de sync ou design, passa tq-def-01);
		o trigger manual-only segue de o vendor viver no frontend-runtime (precedente def-060/def-043), e o runner não
		o disparou; a calibração low+cross-artifact foi confirmada pelo founder com o raciocínio de que o bridge da
		camada de IA já é lei (só o vendor atrás dele é adiado → cross-artifact, não cross-cutting); originatingArtifacts
		existem; cue vet confirma o shape open. Sem gap fail/warn-ancorável — nada a corrigir-e-rerodar.
		"""
}
