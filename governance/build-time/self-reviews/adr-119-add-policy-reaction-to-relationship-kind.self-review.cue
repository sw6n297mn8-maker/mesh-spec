package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr119: build_time.#SelfReviewReport & {
	reportId: "srr-adr-119"

	artifactPath:       "architecture/adrs/adr-119-add-policy-reaction-to-relationship-kind.cue"
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
			ADR documenta schema extension do context-map: cria enum
			#RelationshipKind (1 valor inicial "policy-reaction") +
			estende #BaseRelationshipWithoutCommunication e
			#BaseRelationshipWithCommunication com field opcional kind?
			(em ambas explicitamente, per decisão registrada no decision
			do ADR — visibilidade > DRY).

			Decisão passou por múltiplos ciclos de calibração antes da
			escrita (Fase 1 + 2 + 3 do def-027 em PR #83 mergeado em
			2026-05-29): agrupamento topológico, refinement com canvas
			REW ("decisão ≠ execução" como tese categórica), confirmação
			por subdomain FCE, pattern de PRs sequenciais.

			Pattern paralelo a adr-049 (conditional-file-presence),
			adr-056 (production-guide-coverage), adr-063 (filesystem-
			path-exists), adr-076 (at-least-one-block-present), adr-080
			(domain-invariant), adr-117 (directed-acyclicity), adr-118
			(este PR, paralelo).

			4 alternativas explicitamente rejeitadas: (a) estender
			#UpstreamPattern em vez de criar dimensão ortogonal kind;
			(b) valores especulativos; (c) kind obrigatório (cascade em
			47 relationships); (d) modelar como variante nova de
			#InternalRelationship discriminated union (explosão
			combinatória pattern × kind).

			Decisão de NÃO usar defersTo: mesma análise que adr-118.
			def-027 foi criado em PR #83 anterior; este ADR só prepara
			vocabulário. Resolução em PR-3.

			principlesApplied: P0, P1, P12. decisionClass=structural,
			reversibility=high, blastRadius=cross-artifact.
			affectedArtifacts: 1. plannedOutputs: 1. defersTo: vazio
			(documentado em prose). supersedes: vazio. cue vet ./... EXIT=0.

			Risco categórico de scope creep em PR-3 documentado em
			consequences negative (N3): hipótese "policy-reaction como
			categoria DDD" tem aplicação além de rew-to-cmt; scan
			complementar obrigatório no PR-3. Documentado em def-027.
			triggerCalibrationRationale.

			Zero risco runtime PR-1: só toca schema. sc-cm-07 mantém 4
			WARN inalterados. Aplicação + scan + edição em PR-3.
			"""
	}]

	findings: {}

	summary: """
		ADR-119 adiciona #RelationshipKind enum (1 valor "policy-reaction")
		+ field opcional kind? em ambas variantes de #BaseRelationship.
		Pattern paralelo a adr-049/056/063/076/080/117/118. Schema
		extension narrow; aplicação + scan complementar em PR-3.
		defersTo não usado (semântica estrita; def-027 não foi criado
		por este ADR).
		"""

	singleRoundRationale: """
		Pattern bem-estabelecido (sétima extensão orgânica de schema;
		precedentes adr-049/056/063/076/080/117/118). Decisão passou por
		múltiplos ciclos de calibração antes do def-027 ser escrito em
		PR #83 anterior; este ADR materializa o passo 1 do plano de PRs
		já validado. Round único suficiente.
		"""
}
