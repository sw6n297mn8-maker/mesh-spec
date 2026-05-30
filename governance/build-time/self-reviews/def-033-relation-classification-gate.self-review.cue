package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def033RelationClassificationGate: build_time.#SelfReviewReport & {
	reportId: "srr-def-033-relation-classification-gate"

	artifactPath:       "architecture/deferred-decisions/def-033-relation-classification-gate.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-30"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-033 (Ciclo 2 da auditoria de feedback: gate
			determinístico de classificação de relação cross-BC — structural-check
			que falha em aresta de context-map sem pattern/kind classificado).

			Conformância #DeferredDecision (tq-def-01/02/03/04):
			(tq-def-01) deferralRationale ≥100 runes articula trade-off: MOTIVO
			(baixo custo cumulativo — arestas atuais já classificadas, sc-cm-07 já
			cobre o risco maior de ciclo; acoplamento com def-029) + HORIZONTE real
			(diferido, junto de def-029) + CUSTO de continuar (classificação
			depende de vigilância humana via founder-gate). PASS.
			(tq-def-02) trigger conforma #Trigger: adjacent-need file-exists sobre
			validate-bc-derivation.cue. cue vet EXIT 0. PASS.
			(tq-def-03) trigger único é non-manual-review (adjacent-need). PASS —
			não precisa de backstop porque o primário já é determinístico.
			(tq-def-04) severity=medium + blastRadius=cross-artifact coerentes — a
			acyclicity (risco maior) já é gate e as arestas atuais estão
			classificadas; afeta context-map + canvas das pontas da aresta. PASS.

			Relação com def-029 registrada (refina, não duplica): def-029 cobre a
			dimensão interpretativa da derivação (genuinidade de contorno,
			legitimidade de kind — advisory); def-033 cobre a dimensão mecânica
			(pattern/kind preenchido — gate). adr-040 separa as duas camadas;
			resolvê-las no mesmo movimento mantém a coerência do enforcement de
			derivação. O acoplamento à def-029 é o motivo de NÃO usar trigger
			temporal — o sinal de revisita é a materialização do validation-prompt,
			não o calendário.

			Verificação: cue vet ./architecture/deferred-decisions/ EXIT 0; shape
			conforma variante "open"; originatingArtifacts cita
			session:feedback-cycles-audit + structural-checks/context-map.cue
			(path real); trigger adjacent-need aponta para o path que def-029
			materializará.
			"""
	}]

	findings: {}

	summary: """
		def-033 conforma #DeferredDecision (tq-def-01..04 PASS). Ciclo 2 (gate
		determinístico de classificação de relação cross-BC). Horizonte: diferido,
		junto de def-029. Refina def-029 (dimensão mecânica gate vs interpretativa
		advisory, per adr-040). severity medium (acyclicity já é gate; arestas
		atuais classificadas). cue vet EXIT 0.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round: o gap foi identificado e dimensionado na auditoria
		de ciclos de feedback com o founder, e o acoplamento à def-029 já estava
		mapeado lá; este DD apenas o registra com trade-off, horizonte e trigger
		calibrados. Conformidade tq-def-NN verificada + cue vet EXIT 0.
		"""
}
