package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

ten011ProductionGuideVerbatimReview: build_time.#SelfReviewReport & {
	reportId: "srr-ten-011"

	artifactPath:       "architecture/tension-log/ten-011-production-guide-verbatim-inherits-upstream-constraints.cue"
	artifactSchemaPath: "architecture/artifact-schemas/tension-entry.cue"
	artifactType:       "tension-entry"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-30T13:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		ten-011 é tradução direta de findings concretos do vp-artifact-schema
		(sessão 2026-04-29) para o formato canônico #TensionEntry. Conteúdo
		(description, resolution, status=accepted) deriva mecanicamente dos
		5 findings retornados pelo subagente isolado: 1 fail (canonicalPathRegex
		alternativa portfolio/) + 4 warn narrativas (collectFromFounder
		MinItems, target regex sem validação cross-schema, rigidez para
		namespaces qualificados, constraint transitiva de id). Não há
		conteúdo de design original — todo o judgment foi sobre a forma
		de registrar findings já validados em sessão de validation prompt.
		Backfill de governance refeito após commit 12 revertido (12b6a8e)
		por incompatibilidade de artifactType na enum #ArtifactType.
		Critério de estabilização em 1 round: tradução direta sem desenho +
		conteúdo upstream já validado.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Auto-avaliação contra 12 critérios (uq-01..08 + tq-te-01..04).
			uq-01: rationale explica WHY (preservar memória organizacional
			do trade-off para evitar re-litigation futura por autor que
			reler findings de vp-artifact-schema). uq-02: ancoragem mesh
			via referências concretas a adr-053, adopted-artifacts.cue,
			adr-050, adr-052 (precedentes verbatim). uq-03: tensionTarget
			e manifestsIn apontam para architecture/artifact-schemas/
			production-guide.cue (existe pós-commit b1f6d9b); relatedADR
			"adr-053" existe em architecture/adrs/. uq-04: zero contradição
			com design principles; resolução respeita P0 (verbatim mantém
			localização canônica única upstream). uq-05: limitação declarada
			(timing da promoção FP-XX depende de priorização do trabalho
			upstream — não controlado por mesh). uq-06: terminologia
			consistente (verbatim, FP-XX, tq-as-05, sourceCommit).
			uq-07: zero placeholder. uq-08: shape #TensionEntry satisfeito
			(id regex ^ten-[0-9]{3}$, kind enum schema-limitation, status
			enum accepted, tensionTarget regex satisfeito por path
			architecture/...). tq-te-01: tensionTarget é path de schema
			existente. tq-te-02: resolution especifica alternativa escolhida
			(aceitar verbatim) e rejeitada (supersessão local) com
			justificativa de custo (perde alinhamento portfolio-wide,
			duplica manutenção) e ganho zero. tq-te-03: manifestsIn é path
			real do schema com finding observável. tq-te-04: status=accepted
			(não resolved); critério N/A (só aplica a resolved); contudo,
			structuralResolutionPath está presente como referência futura
			a promoção FP-XX. Zero findings.
			"""
	}]

	findings: {}

	summary: "ten-011 estável no round 1 com 0 findings. Tradução direta de 5 findings concretos do vp-artifact-schema para formato #TensionEntry. 12 critérios (uq-01..08 + tq-te-01..04) satisfeitos. status=accepted; structuralResolutionPath aponta promoção FP-XX upstream tekton; relatedADR=adr-053."
}
