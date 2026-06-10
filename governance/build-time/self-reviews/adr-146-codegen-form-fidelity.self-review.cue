package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr146CodegenFormFidelity: build_time.#SelfReviewReport & {
	reportId: "srr-adr-146-codegen-form-fidelity"

	artifactPath:       "architecture/adrs/adr-146-codegen-form-fidelity.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

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
			Re-review isolated-subagent (contexto fresco, separado da autoria) do adr-146 (P14 + geracao de
			domain-types do cue.Value, reinterpretando o item 2 de adr-140). tq-adr-01: 4 alternativas reais com
			motivo (JSON Schema+typify rejeitada por hostilidade a tipos nominais + presenca degradada; Pkl por
			perder unificacao-por-lattice; tipos-a-mao por furar P1; aceitar-a-perda por empurrar estado-ilegal a
			runtime). tq-adr-02: reversibility medium + blastRadius repo-wide defendidos (P14 fundacional + re-aponta
			FF-CG-03), nao defaults. tq-adr-03/04: affectedArtifacts (design-principles, adr-140, codegen-contract)
			+ plannedOutputs (def-056) + derivedArtifacts (assertion-schema, wave-plan) verificados no disco.
			Claims factuais checados contra o disco pelo subagente: adr-140 esta proposed e seu item 2 declara
			.proto como IR-de-tipos; P14 existe em design-principles; def-056 existe; a uniao #ADR nao tem
			'partially-superseded' (valida reinterpretacao-via-nota-aditiva vs supersession). INFO: os numeros 16
			probes / 18 construcoes (corretos e distintos) ficam visualmente proximos na prosa -- cosmetico, nao
			gate. uq-* pass. Veredito do subagente: APROVADO.
			"""
	}]

	findings: {}

	summary: """
		adr-146 conforma #ADR e estabelece P14 (fidelidade de forma) + reinterpreta o escopo do item 2 de
		adr-140 (.proto deixa de ser IR-de-domain-types; tipos vem do cue.Value direto), mantendo adr-140
		proposed e vigente nos demais itens. Re-review isolated-subagent APROVADO: 4 alternativas reais,
		metadata de risco defendida, falsificationCondition real (conjunto de construcoes aberto / construcao
		nova nao-coberta), reinterpretacao-nao-supersession sound (a uniao #ADR nao admite parcial). Sem findings
		fail/warn; 1 INFO cosmetico (16 vs 18 adjacentes na prosa). cue vet ./... = 0 no parent.
		"""

	singleRoundRationale: """
		1 round: o re-review isolado verificou tq-adr-01..04 + uq-* e os claims factuais contra o disco
		(adr-140 proposed/item-2; P14 presente; def-056 presente; uniao #ADR sem parcial-superseded) sem fail.
		O design (P14 + reinterpretacao) fora aprovado pelo founder no PRE; nada a iterar -- o unico INFO
		(adjacencia 16/18) e cosmetico e nao altera conformidade.
		"""
}
