package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def071: artifact_schemas.#DeferredDecision & {
	id:     "def-071"
	title:  "Implementação do check-(a) compile-probe (P14) pendente da geração viva madura no mesh-runtime"
	date:   "2026-06-28"
	status: "open"

	description: """
		adr-163 fixou o CONTRATO do check-(a): a prova por compilação de que a forma P14 sobrevive ao
		codegen — os 16 probes de violação (estado não-tratado, campo obrigatório ausente, wrapper-bypass)
		DEVEM falhar a compilação, como gate determinístico mandatório. Fica deferida a IMPLEMENTAÇÃO desse
		probe: cabear o corpus de 16 no CI do mesh-runtime, sobre os domain-types gerados, de modo que o
		gate reprove quando a forma não força. Resíduo de runtime do def-056 (resolvido pelo contrato).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: adr-163 resolve o que é resolvível no spec (o contrato); a implementação
		do probe é trabalho de RUNTIME (mesh-runtime, fronteira adr-138/139) e amadurece junto com a
		toolchain de codegen — cuja linguagem-alvo, test-runner e fiação ainda dependem das seleções de
		vendor/runtime atrás dos Ports (def-041..045 re-adiados na mesma triagem). Cabear os 16 probes
		antes de os domain-types gerados estabilizarem arriscaria refazer a fiação a cada giro da toolchain.
		Custo evitado: materializar e manter compile-probes contra geração ainda em movimento. Custo de
		continuar deferindo: P14 segue sem a sua prova-de-força ATIVA até o cabeamento — mitigado no
		interino por FF-CG-03 (regeneração-e-diff, proveniência/drift) + review (P10), exatamente a mesma
		mitigação que cobria o def-056; o que falta é só a prova de que a forma força, não a sua substância.
		"""

	triggerCalibrationRationale: """
		Gatilho primário manual-review: o evento real — "o check-(a) é cabeado no CI do mesh-runtime sobre
		domain-types gerados estáveis" — vive no mesh-runtime e NÃO é machine-evaluable a partir do runner
		repo-local de mesh-spec (o gerador, o output e o CI vivem lá, invisíveis daqui). Mesmo padrão honesto
		dos 9 re-adiados nesta triagem (adr-162): não se inventa um file-exists artificial onde o evento não
		tem sensor no mesh-spec. Backstop temporal 180d: único kind além de file-exists que o gate de
		carência V1 (adr-162) enforça, garante que o deferimento não vire limbo (é pego pelo próprio
		mecanismo de vigilância). Nasce limpo: date 2026-06-28, idade 0 — não dispara na hora.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-163-compile-probe-p14-mandatory-gate.cue",
		"session:dd-triage-10-fired",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque, no interino, P14 é coberto por FF-CG-03 (regeneração-e-diff) + review — deferir a
			implementação do probe não bloqueia codegen (P1) nem os contratos de Port; cross-artifact porque
			o check-(a) incide sobre os domain-types gerados de vários BCs + o harness de codegen-validation,
			não um único artefato. Exit: cabear os 16 compile-probes no CI do mesh-runtime quando a geração
			viva e a toolchain estiverem estáveis.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Revisitar quando o check-(a) for cabeado no CI do mesh-runtime sobre domain-types gerados estáveis (corpus de 16 probes reprovando por compilação) — evento que vive no mesh-runtime, fora do alcance machine-evaluable do runner de mesh-spec."
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
