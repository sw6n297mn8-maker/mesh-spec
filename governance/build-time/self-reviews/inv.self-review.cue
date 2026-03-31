package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

invSubdomain: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-inv"

	artifactPath:       "strategic/subdomains/inv.cue"
	artifactSchemaPath: "architecture/artifact-schemas/subdomain.cue"
	artifactType:       "subdomain"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-30T00:00:00Z"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 avaliou INV contra critérios universais e type-specific.
			Finding: (1) fail — falta negativeBoundary para REW
			(elegibilidade financeira do recebível). Supporting-subdomain
			validado por red team (RT-2.4): faturamento é regulatoriamente
			determinado, diferencial é da composição (DLV+CMT), não do
			faturamento em si. Purpose justifica separação de ATO (tempo
			real vs batch).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			NegativeBoundary para REW adicionado. Verificação de regressão
			confirmou estabilidade. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		INV estável no round 2. Round 1 identificou 1 fail
		(negativeBoundary REW ausente). Corrigido. Supporting-subdomain
		com 6 negativeBoundaries cobrindo DLV, ATO, FCE, SCF, CMT e REW.
		"""
}
