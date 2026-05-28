package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def024ApiYamlAuthServersPendingAdr: build_time.#SelfReviewReport & {
	reportId: "srr-def-024-api-yaml-auth-servers-pending-adr"

	artifactPath:       "architecture/deferred-decisions/def-024-api-yaml-auth-servers-pending-adr.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-28"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Self-review do def-024 (OpenAPI security + servers deferidos até ADRs de
			auth e deploy). Paralelo direto do def-023 (transport bindings da async-api)
			— mesmo padrão revisita-em-marco-de-ADR, mesma limitação técnica do
			#Trigger schema. Aprovado pelo founder no chat.

			(a) Conformância #DeferredDecision: id ^def-[0-9]{3}$; status 'open'
			(triggeredAt/triggeredCondition/resolvedBy ausentes — discriminado por
			união); description afirmativa sobre o que está deferido (security +
			servers nos api.yaml); deferralRationale com trade-off concreto
			(MOTIVO: nem auth nem deploy têm ADR; RISCO de gatear: scheme/URL
			fantasmas cross-BC; CUSTO de deferir: sem nível de auth/endpoint até ADRs
			chegarem) — tq-def-01 satisfeito.

			(b) Trigger manual-review e tq-def-03 WARN ESPERADO: única trigger é
			manual-review com reason articulando a limitação técnica (nenhuma das 6
			kinds do #Trigger expressa cleanly 'qualquer ADR futuro de auth/deploy
			menciona scheme/URL'). Warn aceito DELIBERADAMENTE (paralelo ao def-023).

			(c) costOfDeferral coerente (tq-def-04): severity=low + blastRadius=
			cross-cutting refletem que afeta todos BCs com sync surface mas é baixo
			(OpenAPI sem security/servers ainda é válido); reversível mecanicamente.

			(d) Verificação: cue vet ./architecture/deferred-decisions/... exit 0;
			structural-check-runner 0 bloqueantes.
			"""
	}]

	summary: "def-024 conforma #DeferredDecision (tq-def-01/02/04 fail satisfeitos; tq-def-03 warn ACEITO E DOCUMENTADO pela mesma limitação técnica do def-023 — manual-review é a única kind expressável). Paralelo direto do def-023. Verificado: cue vet exit 0; structural-check-runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round: padrão idêntico do def-023 (já estabilizado nos 3 ciclos de red team do PR #72) aplicado a auth+servers do api.yaml; aprovado pelo founder com o mesmo trade-off. Conformância verificada por cue vet + runner sem findings fail."
}
