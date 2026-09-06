package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def092ExceptionResponderMechanization: build_time.#SelfReviewReport & {
	reportId: "srr-def-092-exception-responder-mechanization"

	artifactPath:       "architecture/deferred-decisions/def-092-exception-responder-mechanization.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-06"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary: """
			1 fail corrigido: o escopo do def foi conferido letra a letra
			contra a decisão (4) do adr-197 (extensão de schema sob adr-182 +
			forma placeholder contável + check born-warn per adr-097 +
			critério de promoção) para não redefinir nem estreitar a
			encomenda — o def dá morada, não reescreve (a decisão do ADR
			permanece intocada, per comando).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Warn tq-def-03 (manual-only) mantido; calibração
			medium/cross-cutting espelhando o blastRadius do próprio adr-197,
			ratificada nominalmente. Par do commit: adr-197 ganha
			defersTo: ["def-092"] — higiene de registro, decisão intocada.
			#TriggerStrict ✓; cue vet ✓.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review-only: a forma literal do placeholder que um predicado contaria só nasce na própria fatia de mecanização — antes dela qualquer trigger cravaria grafia ou path não-desenhado."
			rationale:   "Warn aceito; a âncora de revisita vive no ponto de uso (defersTo do adr-197), mesmo desenho ratificado no def-079."
		}]
	}

	summary: """
		def-092 é a morada da mecanização encomendada pela decisão (4) do
		adr-197 — a pendência que era promessa interna ao texto vira def com
		trigger, e o adr-197 passa a apontá-la por defersTo (mesmo par
		adr↔def de adr-175/178/183/184). Correção gêmea do adr-196
		(materialização sem defersTo) registrada no passe SEM correção, per
		decisão do founder: cabe na mesma fatia de higiene futura.
		"""
}
