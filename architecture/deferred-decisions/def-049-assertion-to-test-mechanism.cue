package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def049: artifact_schemas.#DeferredDecision & {
	id:     "def-049"
	title:  "Mecanismo concreto de assertion-to-test deferido até o contrato de codegen (WI-134)"
	date:   "2026-06-28"
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
		Re-deferimento pós-triagem do backlog de defs disparados (adr-162, Camada 3). O trigger
		original (adjacent-need file-exists em governance/build-time/codegen-contract.cue) ERA
		proxy-prematuro: disparou quando o contrato de codegen (WI-134) materializou, mas a decisão
		real — volume de contract-tests hand-encoded que justifique automatizar a transformação
		assertion→test — só fica devida em fenômeno de runtime que vive no mesh-runtime e NÃO tem
		sensor honesto no runner repo-local de mesh-spec: os testes hand-encoded vivem no mesh-runtime
		(contexts/*/src/test, marcador *AssertionTest/*CompositionTest) e o volume-threshold do runner
		só conta 10 artifactTypes hardcoded, sem "assertion-test". Substituído por manual-review (o
		evento real, founder revisita) + temporal 180d (backstop gateável; único kind além de
		file-exists que o gate V1 de adr-162 enforça; impede limbo, mesmo desenho do def-070). Data
		refrescada para 2026-06-28 para o backstop contar a partir de agora (idade 0, não re-dispara na
		hora); deferido ORIGINALMENTE em 2026-06-04 — proveniência preservada aqui porque
		#DeferredDecision tem campo `date` único, sem slot estruturado para "última revisão"
		(triggeredAt é proibido em status open).
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
		kind:   "manual-review"
		reason: "Volume de contract-tests hand-encoded que justifique automatizar assertion→test (≥N testes, ou ≥2 Ports com adapter a testar). Os testes vivem no mesh-runtime (contexts/*/src/test, marcador *AssertionTest/*CompositionTest) e o volume-threshold do runner só conta 10 artifactTypes hardcoded sem 'assertion-test' — sem sensor honesto aqui."
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
