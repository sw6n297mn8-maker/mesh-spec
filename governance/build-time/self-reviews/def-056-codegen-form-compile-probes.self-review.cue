package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def056CodegenFormCompileProbes: build_time.#SelfReviewReport & {
	reportId: "srr-def-056-codegen-form-compile-probes"

	artifactPath:       "architecture/deferred-decisions/def-056-codegen-form-compile-probes.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-10"

	roundsExecuted: 1
	maxRounds:      3
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Re-review isolated-subagent (contexto fresco) do def-056 (check-(a) compile-probes dos domain-types
			gerados, deferido ate a geracao viva). tq-def-01: deferralRationale articula trade-off concreto --
			custo evitado = materializar compile-probes contra output inexistente (harness sai 78); custo de
			continuar = P14 sem a validacao mais-forte ate a geracao viva, mitigado pela FF-CG-03 re-apontada +
			review. tq-def-02: ambos os triggers conformam #Trigger (adjacent-need/file-exists + manual-review
			reason>=40). tq-def-03: ha trigger non-manual-review. tq-def-04: low + cross-artifact coerentes com a
			description. MinRunes conferidos (description ~480, deferralRationale ~700, triggerCalibration ~480,
			costOfDeferral.description ~360, manual-review.reason ~260). Anti-catch-all: e deferimento genuino
			(trade-off + condicao de revisita), nao WI/bug/tensao -- materializa o gap N1/N3 de adr-146. INFO: o
			trigger file-exists em validate-codegen.sh nasce disparado (harness ja existe, WI-137) -- justificado
			no triggerCalibrationRationale como lembrete permanente, com a condicao real (geracao viva) vivendo no
			mesh-runtime, nao machine-evaluable daqui; mesmo padrao de def-055, com que co-anota. Veredito do
			subagente: APROVADO.
			"""
	}]

	findings: {}

	summary: """
		def-056 conforma #DeferredDecision e materializa, como deferimento consciente governado, o gap N1/N3 de
		adr-146: o check-(a) compile-probes (prova por compilacao de que os domain-types gerados forcam a forma
		de P14) so roda quando houver geracao viva (mesh-runtime ausente; harness sai 78). Re-review
		isolated-subagent APROVADO: tq-def-01..04 pass, MinRunes folgados, anti-catch-all satisfeito (nao e WI
		nem bug nem tensao). Sem findings fail/warn; 1 INFO: trigger file-exists nasce disparado (lembrete
		permanente, padrao def-055; co-anota com def-055). cue vet ./... = 0 no parent.
		"""

	singleRoundRationale: """
		1 round: o re-review isolado verificou tq-def-01..04 + MinRunes + o criterio anti-catch-all sem fail. O
		trade-off e a condicao de revisita sao explicitos e o trigger born-fired esta justificado (padrao
		def-055 ja aceito); o unico INFO (co-anotacao com def-055) e consequencia de design, nao defeito. Nada
		a iterar.
		"""
}
