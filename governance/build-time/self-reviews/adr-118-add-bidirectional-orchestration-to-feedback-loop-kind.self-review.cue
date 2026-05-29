package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr118: build_time.#SelfReviewReport & {
	reportId: "srr-adr-118"

	artifactPath:       "architecture/adrs/adr-118-add-bidirectional-orchestration-to-feedback-loop-kind.cue"
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
			#FeedbackLoopKind (1 valor inicial "bidirectional-orchestration")
			+ estende #ActiveFeedbackLoop com field opcional kind?.

			Decisão passou por múltiplos ciclos de calibração antes da
			escrita (Fase 1 + 2 + 3 do def-026 em PR #83 mergeado em
			2026-05-29): agrupamento topológico, refinement de opção (c)
			vs partnership forçada, validação por leitura de subdomain DRC,
			confirmação de pattern de PRs sequenciais.

			Pattern paralelo a adr-049 (conditional-file-presence),
			adr-056 (production-guide-coverage), adr-063 (filesystem-
			path-exists), adr-076 (at-least-one-block-present), adr-080
			(domain-invariant), adr-117 (directed-acyclicity). Sexta
			extensão orgânica de schema do framework de modelagem
			(structural-check, agora também context-map).

			4 alternativas explicitamente rejeitadas: (a) prose adicional
			sem enum; (b) valores especulativos no enum; (c) kind
			obrigatório; (d) modificar shape de loopSemantics.

			Decisão de NÃO usar defersTo: semântica estrita do field per
			schema #ADR descreve "Deferimentos conscientes governados
			CRIADOS por esta decisão". def-026 foi criado em PR #83
			anterior; este ADR só prepara vocabulário (PR-1 do plano
			registrado em def-026.triggerCalibrationRationale). Resolução
			ocorre em PR-3 quando arestas drc↔cmt forem editadas para
			incluir kind="bidirectional-orchestration" e sc-cm-07 ganhar
			edgeFilter. Linkage documentado em prose no context e rationale
			do ADR.

			principlesApplied: P0, P1, P12. decisionClass=structural,
			reversibility=high, blastRadius=cross-artifact.
			affectedArtifacts: 1 (apenas schema do context-map).
			plannedOutputs: 1 (mesma path; modificação do schema é o
			output). defersTo: vazio (decisão deliberada — documentada
			no context). supersedes: vazio. cue vet ./... EXIT=0.

			Zero risco runtime: PR-1 só toca schema. sc-cm-07 mantém 4
			WARN inalterados (nada quebra). Aplicação progressiva em PR-3.
			"""
	}]

	findings: {}

	summary: """
		ADR-118 adiciona #FeedbackLoopKind enum (1 valor "bidirectional-
		orchestration") + field opcional kind? em #ActiveFeedbackLoop.
		Pattern paralelo a adr-049/056/063/076/080/117. Schema extension
		narrow + field opcional preservam validade de instances
		existentes; aplicação progressiva em PR-3. defersTo não usado
		(semântica estrita; def-026 não foi criado por este ADR).
		"""

	singleRoundRationale: """
		Pattern bem-estabelecido (sexta extensão orgânica de schema;
		precedentes adr-049/056/063/076/080/117). Decisão passou por
		múltiplos ciclos de calibração antes do def-026 ser escrito em
		PR #83 anterior; este ADR materializa o passo 1 do plano de
		PRs já validado. Round único suficiente — sem espaço de decisão
		aberto a red-team adicional.
		"""
}
