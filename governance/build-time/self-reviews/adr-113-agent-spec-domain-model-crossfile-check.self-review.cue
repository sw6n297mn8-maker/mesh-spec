package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr113AgentSpecDomainModelCrossfileCheck: build_time.#SelfReviewReport & {
	reportId: "srr-adr-113-agent-spec-domain-model-crossfile-check"

	artifactPath:       "architecture/adrs/adr-113-agent-spec-domain-model-crossfile-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-27"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-113 (kind instance-scoped-cross-file-id-exists + check
			agent-spec→domain-model). Aprovado pelo founder (escolha explícita "novo
			kind per-BC, fiel" sobre as alternativas união-global/só-governanceRef/
			adiar).

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility "high" + blastRadius "repo-wide".
			affectedArtifacts = 4 reais (structural-check.cue schema, runner,
			agent-spec.cue, meta-coverage.cue). tq-adr-01: escopo negativo explícito
			(não promove a reject; não cobre governanceRef/boundedContextRef; não cobre
			direção reversa).

			(b) Honestidade: o ADR REFUTA a premissa do def-002 (risco de vocabulário/
			materialização como events) com evidência — refs são codes internos no
			domain-model próprio e completo do BC, não nomes canônicos cross-BC.
			Justifica o +1 kind: nenhum kind existente combinava escopo derivado-por-
			instância (least-privilege) + multi-path target.

			(c) Verificacao empirica: protótipo → 309 refs dos 12 agentes resolvem no
			domain-model do próprio BC, 0 não-resolvidas; cue vet ./... EXIT 0; runner
			--self-test PASS (born-green x + born-red y); runner default → sc-ag-01
			verde, sc-meta-01/02 verdes (kind com evaluator; agent-spec coberto), M2
			descobertos = 0, bucket cross-file 1→0, 0 bloqueantes, exit 0.
			"""
	}]

	findings: {}

	summary: """
		adr-113 adiciona o kind instance-scoped-cross-file-id-exists (escopo
		least-privilege derivado por instância) e autora sc-ag-01: agent-spec
		operationalScope/domainModelRefs → domain-model do próprio BC, born-warn/
		born-green. Refuta a premissa do def-002 para agent-spec e zera o bucket
		cross-file do M2 (1→0). Sem findings fail/warn.
		"""

	singleRoundRationale: """
		Uma rodada basta: +1 kind aditivo no padrão consolidado + 1 instância de
		check, com premissa (born-green; def-002 stale) verificada empiricamente
		(309 refs) e teeth provadas por self-test born-green/born-red. Sem espaço de
		decisão aberto a red-team.
		"""
}
