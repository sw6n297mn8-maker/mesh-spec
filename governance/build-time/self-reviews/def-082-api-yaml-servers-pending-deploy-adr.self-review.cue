package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def082ApiYamlServersPendingDeployAdr: build_time.#SelfReviewReport & {
	reportId: "srr-def-082-api-yaml-servers-pending-deploy-adr"

	artifactPath:       "architecture/deferred-decisions/def-082-api-yaml-servers-pending-deploy-adr.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Round único (tipo fora do rollout isolated; self-reported): a entry
		é o SPLIT aprovado explicitamente pelo founder no Gate 2/OK do
		WI-158 (def-024 resolved com a metade servers re-adiada em def
		novo, escopo limpo), herda verbatim o fundamento e a calibração do
		def-024 real (tq-api-05; manual-review com a limitação técnica
		documentada em def-023/def-024), e a coerência com o adr-182 e o
		def-024 editado foi verificada item a item pelo reviewer isolado da
		fatia ('def-082: metade servers com escopo limpo... def-024: diff
		cirúrgico de 2 linhas'). cue vet PASS; trade-off e exit codificados
		(anti-catch-all do adr-062 satisfeito: custo evitado = fixar host
		cross-BC sem ADR; revisita = ADR de deploy).
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — def-082 como a metade que sobrevive ao split do
			def-024: description registra as duas metades e qual resolveu
			(auth, via adr-182); deferralRationale articula o trade-off
			(fixar host sem ADR de deploy = contrato escondido, per
			tq-api-05) E o porquê do split-em-def-novo (lifecycle limpo:
			def-024 resolve com resolvedBy rastreável; a entry nova nasce
			com escopo exato do restante); trigger manual-review com reason
			substantiva (a mesma limitação técnica documentada de
			def-023/def-024 — tq-def-03 warn aceito deliberadamente, não
			preguiça); originatingArtifacts = def-024 + adr-182 (ambos no
			disco no mesmo commit); costOfDeferral herdado sem mudança de
			posto (low/cross-cutting) com exit codificado (ADR de deploy →
			fatia mecânica adiciona servers[] → resolve). adr-182 defersTo
			lista def-082 (elo ADR↔def per adr-062).
			"""
	}]

	findings: {}

	summary: """
		O deferimento que o adr-182 cria: a metade servers do antigo
		def-024 com escopo limpo e lifecycle rastreável — zero pendência
		escondida no split (a resolução do def-024 nomeia o destino; a
		entry nova nomeia a origem).
		"""
}
