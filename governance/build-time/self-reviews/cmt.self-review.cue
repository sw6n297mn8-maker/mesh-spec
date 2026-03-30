package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

cmtSubdomain: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-cmt"

	artifactPath:       "strategic/subdomains/cmt.cue"
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
		failCount: 4
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 avaliou CMT contra 8 critérios universais e 7 type-specific.
			Findings: (1) fail — costRefs ce-01 incorreto: ce-01 é custo de
			verificação de execução (DLV), não de formalização. (2) fail —
			capabilityRefs cc-01 incorreto: cc-01 é liberação financeira
			vinculada a evidência (DLV/FCE), não formalização. (3) fail —
			falta negativeBoundary para REW. (4) fail — falta negativeBoundary
			para DRC. (5) warn — mech-evidence rationale impreciso sobre qual
			aspecto se aplica a CMT. Lenses aplicadas: theory-of-firm,
			domain-language, supply-chain-theory, information-economics,
			mechanism-design. 4 rounds de red team executados.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correções aplicadas: ce-01 → ce-02, cc-01 → cc-04,
			negativeBoundaries para REW e DRC adicionados, rationale de
			mech-evidence ajustado para explicitar que CMT registra aceite
			bilateral como fato com integridade criptográfica. Verificação
			de regressão: demais critérios continuam passando. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		CMT estável no round 2. Round 1 identificou 4 fail (costRef e
		capabilityRef incorretos, 2 negativeBoundaries ausentes) e 1 warn
		(rationale de mech-evidence). Todos corrigidos. Design informado
		por 5 lenses analíticas e 4 rounds de red team.
		"""
}
