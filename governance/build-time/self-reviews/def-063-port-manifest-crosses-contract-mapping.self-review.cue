package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def063: build_time.#SelfReviewReport & {
	reportId: "srr-def-063-port-manifest-crosses-contract-mapping"

	artifactPath:       "architecture/deferred-decisions/def-063-port-manifest-crosses-contract-mapping.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-16"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 -- self-review self-reported (rollout default do quality-gate p/
			deferred-decision) de def-063 completo. Universais uq-01..09 + type-specific
			tq-def-01..04 contra o disco. PASS: tq-def-01 (deferralRationale articula
			trade-off concreto -- vetor de erro no gate evitado [mapeamento fuzzy
			value-class->vo viola P10/norm-exato] vs cobertura port-manifest adiada, NAO
			'fazer depois'); tq-def-02 (trigger conforma #Trigger: manual-review + reason
			MinRunes40); tq-def-03 (warn ENDERECADO -- manual-only justificado: o mecanismo
			de mapeamento deterministico e indefinido hoje, sem pattern auto-detectavel;
			espelha def-049/def-062); tq-def-04 (low+cross-artifact coerente com a
			description). uq-03: originatingArtifacts (adr-153) resolve no disco. uq-04:
			alinhado a P10 (determinismo do gate) e adr-062 (deferimento governado, nao
			prose). cue vet EXIT=0. 0 fail, 0 warn (tq-def-03 satisfeito pela justificativa,
			nao pendente).
			"""
	}]

	findings: {}

	summary: """
		def-063 (open) defere o trigger port-manifest do G2 do gate first-class-traceability
		(adr-153) ate existir mapeamento deterministico value-class-canonica->vo-code. Gemeo
		do deferimento de assertion (def-049): governar um em def e o outro em prose seria
		assimetria que adr-062 desencoraja. Self-review self-reported em 1 round: uq-01..09 +
		tq-def-01..04 contra o disco, 0 fail / 0 warn (tq-def-03 manual-only justificado pela
		indefinicao do mecanismo de mapeamento). cue vet EXIT=0. Estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: def-063 e instancia pequena de #DeferredDecision conformando ao schema (cue
		vet EXIT=0) com os 4 tq-def passando -- o unico ponto sensivel (tq-def-03 manual-only)
		ja vem justificado na triggerCalibrationRationale (mecanismo de mapeamento indefinido
		=> sem pattern auto-detectavel, espelhando def-049/def-062). Nenhum finding tocou a
		substancia; round unico porque nao ha correcao pendente.
		"""
}
