package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr029: build_time.#SelfReviewReport & {
	reportId: "srr-adr-029-subdomain-schema"

	artifactPath:       "architecture/adrs/adr-029-subdomain-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-03-23T00:00:00Z"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente isolado avaliou ADR-029 contra critérios universais
			(uq-01 a uq-08) e type-specific (tq-adr-01 a tq-adr-03).
			Um finding válido: tq-adr-02 — reversibility: "high"
			subestima custo de reversão. Relocação de #BCClassification
			cria acoplamento semântico novo entre schemas; reverter após
			criação de consumidores exige coordenação multi-artefato, não
			rollback local. Demais critérios passam: alternativa
			considerada e rejeitada (tq-adr-01), paths em
			affectedArtifacts reais (tq-adr-03), rationales explicam WHY,
			conteúdo ancorado em mecanismos Mesh, referências cruzadas
			a P0/P1/P12 válidas, linguagem consistente, zero placeholders.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correção aplicada: reversibility alterado de "high" para
			"medium" conforme finding tq-adr-02 do round 1. Justificativa:
			relocação de #BCClassification cria acoplamento semântico novo
			entre subdomain.cue e canvas.cue; reverter após criação de
			consumidores alinhados à nova origem requer mudança coordenada
			em múltiplos artefatos, encaixando na definição de "medium"
			(reversível com esforço moderado, ajuste de consumidores).
			Decisão de correção aprovada pelo founder. Reavaliação
			confirma zero findings pendentes.
			"""
	}]

	findings: {}

	summary: """
		ADR-029 estável no round 2 via sub-agente isolado. Round 1
		identificou finding válido em tq-adr-02 (reversibility "high"
		incorreto para decisão que cria acoplamento semântico
		cross-schema). Corrigido para "medium" no round 2 com aprovação
		do founder. ADR registra criação de #Subdomain schema e relocação
		de #BCClassification, com alternativa explicitamente rejeitada,
		metadata de risco corrigida, e paths reais em affectedArtifacts.
		"""
}
