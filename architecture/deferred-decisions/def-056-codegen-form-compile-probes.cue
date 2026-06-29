package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def056: artifact_schemas.#DeferredDecision & {
	id:         "def-056"
	title:      "Check-(a) compile-probes dos domain-types gerados deferido ate a geracao viva"
	date:       "2026-06-10"
	status:     "resolved"
	resolvedBy: "architecture/adrs/adr-163-compile-probe-p14-mandatory-gate.cue"

	description: """
		P14 (adr-146) exige que todo invariante compile-time-verificavel seja forcado pelo compilador nos
		domain-types gerados. Fica deferido o CHECK-(a) que VERIFICA isso POR COMPILACAO: pegar os tipos
		gerados do cue.Value + os probes de violacao (estado nao-tratado, campo obrigatorio ausente,
		wrapper-bypass -- os 16 probes medidos no spike 4) e exigir que TODOS falhem compilar (forca). E
		fitness function futura, complementar a FF-CG-03 re-apontada (regeneracao-e-diff): regen-diff prova
		proveniencia/ausencia-de-drift, o check-(a) prova que a forma gerada de fato FORCA.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: o check-(a) so tem o que verificar quando ha GERACAO VIVA -- tipos
		efetivamente gerados e compilaveis para auditar. Hoje nao ha: a toolchain de codegen (linguagem-alvo
		+ gerador + test runner) esta indecisa (adr-139 deferiu vendor/runtime; def-040 open) e o mesh-runtime
		-- onde o gerador e o output vivem (P1 estrito, nunca committado no mesh-spec) -- nao existe; o harness
		validate-codegen.sh sai EX_CONFIG (78), nao gera nada. Construir o check-(a) agora seria um check sem
		nada para checar. Custo evitado: materializar compile-probes contra output inexistente. Custo de
		continuar deferindo: P14 fica sem a sua validacao MAIS FORTE (compilacao real) ate a geracao viva --
		mitigado no interino pela FF-CG-03 re-apontada (regeneracao-e-diff dos domain-types do cue.Value) +
		review (P10), que ja cobrem proveniencia e ausencia de drift; o check-(a) acrescenta a prova de que a
		forma forca, nao a substitui.
		"""

	triggerCalibrationRationale: """
		Mesma calibracao de def-055 (mesmo harness, mesmo desfecho contingente). Trigger adjacent-need
		file-exists em scripts/ci/validate-codegen.sh: o harness ja existe (WI-137), logo o trigger nasce
		disparado e o runner ANOTA def-056 a cada CI -- lembrete permanente de cablear o check-(a) quando a
		geracao viva materializar. manual-review porque a condicao real ('geracao viva produz output
		compilavel e o check-(a) roda no CI do mesh-runtime') NAO e machine-evaluable a partir do mesh-spec: o
		gerador e o output vivem no mesh-runtime, invisivel ao runner deste repo -- o founder revisita quando
		a toolchain for decidida e o mesh-runtime existir.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-146-codegen-form-fidelity.cue",
		"architecture/design-principles.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque no interino P14 e cumprido pela FF-CG-03 re-apontada (regeneracao-e-diff) + review, e
			nao ha geracao viva que o check-(a) pudesse cobrir (o harness sai 78); deferir nao bloqueia nada.
			cross-artifact porque o check-(a) incidiria sobre os domain-types gerados de varios BCs + o harness
			de codegen-validation, nao um unico artefato. Exit: cablear os compile-probes no CI do mesh-runtime
			quando a geracao viva existir.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "scripts/ci/validate-codegen.sh"
		}
	}, {
		kind:   "manual-review"
		reason: "Revisitar quando a toolchain de codegen for decidida e o mesh-runtime existir, materializando geracao viva cujo output compilavel o check-(a) possa exercitar -- condicao que vive no mesh-runtime, fora do alcance machine-evaluable do runner de mesh-spec."
	}]
}
