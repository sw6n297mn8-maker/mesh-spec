package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def049: artifact_schemas.#DeferredDecision & {
	id:     "def-049"
	title:  "Mecanismo concreto de assertion-to-test deferido até o contrato de codegen (WI-134)"
	date:   "2026-06-04"
	status: "open"

	description: """
		adr-140 decide que #Assertion é a fonte canônica para geração ou derivação de testes de
		runtime verificáveis (participa de FF-04 / compatibility 3-camadas com SchemaRef próprio).
		Fica deferido o MECANISMO concreto dessa transformação — codegen direto de teste, derivação
		via IR intermediário, ou framework de teste sobre os tipos gerados — e a tecnologia de
		teste do runtime.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: adr-140 fixa a PONTE (assertion é fonte canônica de teste) porque
		isso é contrato de spec; o COMO concreto (qual transformação, qual framework de teste)
		depende do contrato de codegen spec→runtime que ainda não existe — é WI-134
		(governance/build-time/codegen-contract.cue) que materializa como #Assertion + domain-model
		+ domain-invariant viram tipos/skeleton/Ports/testes. Fixar a tecnologia de teste antes
		disso seria decidir o mecanismo antes de existir o contrato que ele serve. Custo evitado:
		comprometer uma abordagem de geração de teste antes de WI-134 desenhar a transformação,
		arriscando retrabalho. Custo de continuar deferindo: o golden-example precisa exercitar o
		path de teste — mitigado porque WI-137 depende de WI-134 (o mecanismo é revisitado antes de
		o golden-example precisar dele) e um mecanismo provisório (teste hand-encoded da assertion
		do CMT) prova o conceito sem fixar a generalização.
		"""

	triggerCalibrationRationale: """
		Trigger adjacent-need file-exists em governance/build-time/codegen-contract.cue (output de
		WI-134): a existência desse arquivo é o sinal exato de que a transformação spec→runtime foi
		desenhada e o mecanismo de assertion-to-test deixa de ser prematuro — mesmo padrão de
		def-039 (file-exists no artefato que destrava a decisão). Path canônico assinado a WI-134
		no wave-plan, machine-evaluable. Fire forte: codegen-contract.cue não existe até WI-134, e
		WI-137 (golden-example) depende dele — o trigger garante revisita ANTES de o consumidor precisar.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-140-codegen-contracts.cue",
		"governance/wave-plan.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			Até o mecanismo existir, o golden-example (WI-137) só prova o path de teste com um
			mecanismo provisório (teste hand-encoded), não com a geração/derivação generalizada que
			é o objetivo. medium (não low) porque está no caminho crítico do golden-example completo
			e não é deferível indefinidamente — resolve-se na janela de WI-134, da qual WI-137 já
			depende; cross-artifact porque toca o codegen-contract (WI-134), o harness do
			golden-example (WI-137) e a gramática #Assertion, não um único artefato.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "governance/build-time/codegen-contract.cue"
		}
	}]
}
