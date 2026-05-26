package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def018PromoteOrphanDetectionToReject: build_time.#SelfReviewReport & {
	reportId: "srr-def-018-promote-orphan-detection-to-reject"

	artifactPath:       "architecture/deferred-decisions/def-018-promote-orphan-detection-to-reject.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			def-018 registra o deferimento da promocao de orfao->reject na
			classificacao fileClassification (ativada por adr-090). Promover
			agora bloquearia arquivos legitimos sem schema dentro do scope
			validado (design-principles.cue, shared-types/*, conventions/*);
			a promocao fica condicionada a dupla condicao: schemas
			fundacionais existentes E zero orfaos remanescentes.

			Schema satisfaction (#DeferredDecision):
			- description: PASS (descreve a classificacao e a condicao de
			  promocao)
			- deferralRationale: PASS (articula o custo evitado = falha de CI
			  sobre arquivos corretos vs custo de deferir = orfaos genuinos
			  so visiveis em warn)
			- triggerCalibrationRationale: PASS (explica POR QUE os triggers
			  sao file-exists sobre os fundacionais e nao "fase reporta zero
			  findings" — nenhum kind de trigger expressa isso; paths
			  PROVISORIOS a reconciliar com os ADRs follow-on)
			- originatingArtifacts: PASS (adr-090)
			- costOfDeferral: PASS (severity low, blastRadius cross-cutting,
			  nao cumulativo)
			- triggers: PASS (2 adjacent-need file-exists:
			  design-principles.cue, shared-types.cue)
			- status open: PASS

			Per anti-catch-all adr-062: deferimento genuino com trade-off
			articulado e condicao de revisita codificada (file-exists
			machine-evaluable + confirmacao do founder para zero orfaos).
			Nao e WI rotineiro, tension entry nem bug travestido.
			"""
	}]

	findings: {}

	summary: """
		def-018 single-round SRR. Deferimento consciente per adr-062 da
		promocao orfao->reject ate os schemas fundacionais existirem E os
		orfaos remanescentes zerarem. Triggers sao file-exists sobre
		design-principles.cue e shared-types.cue (provisorios, a reconciliar
		com os ADRs follow-on que schematizam os fundacionais).
		"""

	singleRoundRationale: "Single-round suficiente: deferred-decision e artefato de registro de trade-off + triggers, estrutura canonical per #DeferredDecision. A calibracao dos triggers ja foi resolvida no red-team de adr-090 (rodada 2). cue vet passa; rounds adicionais nao detectariam new findings."
}
