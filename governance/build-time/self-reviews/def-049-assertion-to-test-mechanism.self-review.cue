package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def049: build_time.#SelfReviewReport & {
	reportId: "srr-def-049-assertion-to-test-mechanism"

	artifactPath:       "architecture/deferred-decisions/def-049-assertion-to-test-mechanism.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-04"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-049 (mecanismo concreto de assertion-to-test deferido de adr-140).
			Avaliado contra universalCriteria + tq-def-01..04.
			tq-def-01 (trade-off concreto): custo evitado (comprometer abordagem de geração de teste antes
			de WI-134 desenhar a transformação spec→runtime, arriscando retrabalho) vs custo de continuar
			(o golden-example precisa do path de teste — mitigado porque WI-137 depende de WI-134, onde o
			trigger dispara, e o mecanismo provisório hand-encoded prova o conceito). Não é "fazer depois". Pass.
			tq-def-02: adjacent-need file-exists em governance/build-time/codegen-contract.cue conforme
			#Trigger, machine-evaluable. Pass.
			tq-def-03 (≥1 non-manual): trigger non-manual (adjacent-need). Pass.
			tq-def-04 (coerência): medium + cross-artifact — coerente: medium porque está no caminho crítico
			do golden-example completo e é bounded à janela WI-134 (não low/indefinido; não high pois
			mecanismo provisório + WI-137-depende-de-WI-134 evitam bloqueio duro); cross-artifact porque toca
			codegen-contract + harness WI-137 + gramática #Assertion. Pass.
			uq-02 (Mesh): #Assertion como fonte canônica de teste, FF-04/compat 3-camadas, codegen-contract
			WI-134, golden-example WI-137 — específico. uq-08 (conforma #DeferredDecision): status=open;
			MinRunes; cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-049 defere o MECANISMO concreto de assertion-to-test (adr-140 fixa a ponte: #Assertion é
		fonte canônica de teste; o COMO depende do codegen-contract de WI-134). Trigger adjacent-need
		file-exists em governance/build-time/codegen-contract.cue. medium/cross-artifact (caminho crítico
		do golden-example, bounded à janela WI-134). Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Deferral com calibração travada pelo founder (medium/cross-artifact — severity subida de low por
		estar no caminho crítico do golden-example; trigger adjacent-need em codegen-contract.cue,
		machine-evaluable); conformance a #DeferredDecision verificável por inspeção (MinRunes, shape do
		trigger, status=open, cue vet EXIT=0). Trade-off concreto — sem ambiguidade que rounds adicionais
		resolveriam.
		"""
}
