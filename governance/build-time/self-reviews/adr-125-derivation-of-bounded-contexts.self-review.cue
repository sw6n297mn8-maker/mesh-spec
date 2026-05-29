package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr125: build_time.#SelfReviewReport & {
	reportId: "srr-adr-125"

	artifactPath:       "architecture/adrs/adr-125-derivation-of-bounded-contexts.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-125 formaliza P13 (derivação de BC) + section boundary-derivation
			no PG de canvas + linha na tabela do config.cue + def-029/def-030.
			Avaliado contra universalCriteria (uq-01..09) + type-specific adr
			(tq-adr-01..04).

			tq-adr-01 (alternativas): 5 alternativas rejeitadas com rationale —
			(a) PG standalone (misfit #ProductionGuide por-artifactType), (b)
			type-PG design-principle agora (Path A; design-principle fora da
			whitelist sc-pg-01; deferido def-030), (c) structural-check novo
			(sc-cm-07 já cobre acyclicity), (d) group StructuralInvariants (P13 é
			filosofia, não mecanismo de runtime), (e) campo derivationRationale
			(rationale/purpose já existem; P0).

			tq-adr-02 (risk metadata): structural/medium/cross-cutting coerente —
			governa derivação em todos os contextos (cross-cutting), reversível
			com esforço moderado sem migração de dados (medium).

			tq-adr-03/04 (paths/rastreabilidade): affectedArtifacts (3 existentes:
			design-principles, config, canvas), plannedOutputs (def-029/030),
			derivedArtifacts (CLAUDE.md regen + canvas-pg SRR). Todos reais.

			uq-01 rationale=WHY (custo de fronteira errada, evidência empírica do
			arco). uq-02 Mesh-specific (BCs, sc-cm-07, policy-execution-feedback,
			fce↔rew). uq-03 refs existem (P0/P12, def-029/030 no mesmo commit,
			adr-002/065/085/124, dp-06, lenses). uq-04 sem contradição; dp-06
			declarado complementar. defersTo (def-029/030) usado como ORIGEM —
			contraste explícito com adr-124 que não usou.

			uq-09 (manualAuthoringProtocol section gates): adr-125 autorado em
			modo batch por direção explícita do founder (mesmo padrão dos PRs
			#84/#85/#86) — section gates do PG de ADR conscientemente dispensados
			pelo founder; não é skip não-autorizado.

			cue vet ./... EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		ADR-125 (structural) formaliza o princípio de derivação de BC (P13, group
		DesignPhilosophy) destilando 4 aprendizados do arco cycle-resolution, com
		protocolo no PG de canvas e 2 deferimentos (def-029 advisory review,
		def-030 PG coverage). 5 alternativas rejeitadas; risk metadata
		cross-cutting/medium; defersTo usado como origem dos deferimentos. Sem
		fail/warn pendente.
		"""

	singleRoundRationale: """
		ADR segue pattern bem-estabelecido (precedente adr-124 no mesmo arco) e
		passou por pre-flight extenso (Path B, misfit do PG standalone, fork de
		cobertura) que já resolveu as decisões de escopo antes da autoria. Modo
		batch autorizado pelo founder. Round único suficiente.
		"""
}
