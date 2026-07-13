package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pDomainModelWi153WindowClose: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-domain-model-wi-153-window-close"

	artifactPath:       "contexts/p2p/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

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
		infoCount: 0
		summary: """
			Round 1 — fecho da janela no p2p (WI-153): edição ÚNICA no
			rationale do dependsOnAggregateState de inv-approval-requires-
			coverage-reservation — de 'HOJE a surface é keyed por CommitmentId
			(papel pré-adr-174); a chave por requisição entra no re-papel
			bdg-side WI-153 — janela declarada' para 'a chave por requisição
			foi MATERIALIZADA no re-papel bdg-side (WI-153, 2026-07-13): a
			surface responde por requisitionRef — o portão lê status=reserved
			na fase 1 (CoverageReserved) — e a janela declarada no adr-174
			consequences FECHOU'. Nada mais tocado no p2p domain-model
			(escopo cravado pelo founder: só esta edição de rationale + a
			query-dependency no canvas). cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		Janela da chave fechada no lado p2p: o rationale do
		dependsOnAggregateState agora descreve o estado materializado, não a
		pendência. Edição única, escopo respeitado. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: coevolução satélite da fatia WI-153
		executando decisões pré-cravadas do founder (D1-D6) sob comando
		estruturado batch; a revisão substantiva do desenho correu no Tempo 1
		(read-only) e a verificação determinística corre nos gates da
		validação integral do checkpoint.
		"""
}
