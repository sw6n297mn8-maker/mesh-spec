package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscAgentSpecWi154Coevolution: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-agent-spec-wi-154-coevolution"

	artifactPath:       "contexts/ssc/agents/ssc-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round 1 — coevolução WI-154 (higiene A, adr-175) do agent-spec do
			ssc, SCOPE-ONLY per decisão do founder (higiene é reconciliação,
			não design novo; sem action nova — o ssc não tem query actions e
			introduzir uma abriria inconsistência de estilo fora de escopo).
			PARTIÇÃO (tq-agg-11): 5 cobertura, 0 exclusão —
			evt-quotation-submitted/withdrawn (events; resultado dos commands
			cmd-submit/withdraw-quotation que o agente JÁ processa — a
			doutrina do repo é que o agente processa commands de ator
			externo; nunca foram exclusão); prj-quotation-map (projections;
			a superfície de comparação do comprador, WI-152);
			svc-supplier-pool-builder e svc-fitness-rule-evaluator
			(domainServices — 1ª instância REAL da 6ª família do adr-175 no
			repo; ambos já citados NOMINALMENTE na prosa das actions —
			viraram refs estruturadas: pool-builder em act-build-supplier-
			pool, fitness-evaluator em act-evaluate-and-conclude-rfq, com
			prj-quotation-map somado às refs da conclusão).

			[uq-08]: cue vet EXIT=0. [tq-ag-02]: refs novos ⊆ scope. [uq-09/
			tq-agg-11]: runner confirmou sc-ag-02 do ssc = ZERO; sem
			exclusões (nada para o sc-ag-01 validar de novo).

			[INFO — adaptação declarada]: a 'nota do mapa nos postconditions
			do processing de submit/withdraw' do comando não tem morada
			literal — NÃO existe action de processing de cotação no ssc
			(consequência da própria decisão scope-only; os commands vivem
			em scope sem action dedicada, shape pré-existente do spec). O
			vínculo cotação→mapa foi registrado nos comentários das entries
			novas do scope (events + projection). Modelar a action de
			intake de cotação é candidato de fatia futura, não desta
			higiene.
			"""
	}]

	findings: {}

	summary: """
		Coevolução scope-only do agent-spec do ssc: 5 coberturas (2 events
		internal de cotação, o mapa, e os 2 domain services — 1ª instância
		real da 6ª família do adr-175), 0 exclusões, refs estruturadas nas
		actions que já citavam os services em prosa. sc-ag-02 do ssc a ZERO.
		1 info: a nota do mapa vive nos comentários do scope (não há action
		de processing de cotação — shape pré-existente). VEREDITO: stable,
		0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: reconciliação scope-only com partição
		pré-cravada (Tempo 1 classificou 5/5 cobertura); zero prosa nova
		além de comentários de vínculo; evidência determinística (runner
		zero + vet) reproduzível nesta execução.
		"""
}
