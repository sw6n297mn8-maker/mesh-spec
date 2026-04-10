package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr039SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-adr-039-domain-agent-spec-canonical-path"

	artifactPath:       "architecture/adrs/adr-039-domain-agent-spec-canonical-path.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-06"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		ADR registra decisão de migrar domainAgentSpec de ID lógico
		para path canônico — convenção já estabelecida nos canvas CMT
		e CTR, apenas faltava alinhar context-map. Mudança mecânica
		de formato de string com alternativa documentada e rejeitada
		(tabela de tradução no runner). Decisão revisada e aprovada
		pelo founder com 3 condições explícitas de execução. Segue
		padrão estabelecido por ADRs anteriores (035-038).
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação de adr-039 contra 8 critérios universais + 3
			critérios de ADR (tq-adr-01/02/03). tq-adr-01: contexto
			menciona alternativa (tabela de tradução no runner) e
			justifica rejeição (indireção sem valor, diverge da
			convenção dos canvas). tq-adr-02: reversibility high
			(mudança de formato de string sem consumidores do valor
			antigo) e blastRadius cross-artifact (afeta context-map
			e schema) são consistentes. tq-adr-03: 2 paths em
			affectedArtifacts são arquivos reais modificados neste
			commit. decision item (5) documenta que schema mantém
			campo como string simples — validação semântica no runner.
			uq-02: ancoragem Mesh via convenção canvas e alinhamento
			filesystem↔context-map↔canvas. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		ADR para migração de domainAgentSpec de ID lógico para path
		canônico. Decisão structural com reversibility high (formato
		de string) e blastRadius cross-artifact (context-map + schema).
		Estabilizou em 1 round — decisão aprovada pelo founder com
		condições explícitas. Alternativa documentada e rejeitada.
		"""
}
