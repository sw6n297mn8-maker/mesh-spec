package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def077MultiIdentifierOrganization: build_time.#SelfReviewReport & {
	reportId: "srr-def-077-multi-identifier-organization"

	artifactPath:       "architecture/deferred-decisions/def-077-multi-identifier-organization.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-12"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do def-077 (agregação de múltiplos
			identificadores legais na mesma organização). [uq-08]: cue vet
			EXIT=0; conforma #DeferredDecision; def-77 confirmado próximo-livre
			via freshness --assert (G2). [ANTI-CATCH-ALL]: deferimento
			consciente genuíno — decisão explícita de NÃO modelar agregação
			agora, com 3 formas candidatas enumeradas (desvinculadas / conjunto
			com primário por jurisdição / vínculo leve), trade-off articulado e
			revisita codificada; não é WI (nada a executar sem caso), não é
			tensão, não é bug (o mínimo do adr-173 é correto para 100% dos
			casos atuais). [tq-def-01]: custo evitado = modelar agregação sem
			evidência (o mesmo erro que adr-173 desfez); custo de continuar =
			org dual-identificador como 2 identidades desvinculadas, mitigado
			pela chave neutra do npm. [tq-def-02/03]: adjacent-need file-exists
			contexts/itc/canvas.cue (machine-evaluable, proxy de
			internacionalização ativa) + manual-review com reason substantiva
			(o gatilho real é fato de negócio fora do disco). [tq-def-04]:
			low/local coerente (nada quebra; escopo idc+npm profile). [uq-03]:
			originatingArtifacts existem na fatia. [uq-01/05/06/07]: OK.
			[uq-09]: PG deferred-decision aplicado; arco de checkpoint único
			(batch, pattern def-074).
			"""
	}]

	findings: {}

	summary: """
			def-077: a única sub-pergunta da identidade qualificada que espera caso
		real — agregação multi-identificador. Trigger proxy machine-evaluable
		(derivação do itc) + manual-review substantivo. VEREDITO: stable,
		0 fail.
		"""

	singleRoundRationale: """
			Round único proporcional: o def codifica exatamente o que o adr-173
		item 6 deferiu, com as 3 formas candidatas já enumeradas para a decisão
		futura; conteúdo validado na discussão da fatia aprovada pelo founder.
		"""
}
