package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

dlvSubdomain: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-dlv"

	artifactPath:       "strategic/subdomains/dlv.cue"
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
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 avaliou DLV contra critérios universais e type-specific.
			Findings: (1) fail — falta negativeBoundary para DRC
			(contestação de verificação). (2) warn — ce-04 (custo de risco
			com dados incompletos) contribuição indireta: DLV produz dados
			que REW consome, mas não avalia risco diretamente. Core-subdomain
			validado: mech-evidence é o diferencial central da tese, DLV é
			onde evidência é avaliada como suficiente. strategicProfile
			high/high confirmado por red team (RT-2.3): critérios de
			verificação variam radicalmente por vertical.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			NegativeBoundary para DRC adicionado. ce-04 mantido com
			rationale explícito sobre contribuição indireta (DLV produz
			dados completos que eliminam o custo de risco com dados
			incompletos). Zero findings.
			"""
	}]

	findings: {}

	summary: """
		DLV estável no round 2. Round 1 identificou 1 fail
		(negativeBoundary DRC ausente) e 1 warn (ce-04 indireta).
		Ambos resolvidos. Core-subdomain com 3 mechanismRefs, 2
		costRefs, 2 capabilityRefs e 6 negativeBoundaries.
		"""
}
