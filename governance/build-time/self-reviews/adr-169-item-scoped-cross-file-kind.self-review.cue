package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr169ItemScopedCrossFileKind: build_time.#SelfReviewReport & {
	reportId: "srr-adr-169-item-scoped-cross-file-kind"

	artifactPath:       "architecture/adrs/adr-169-item-scoped-cross-file-kind.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-05"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — review por sub-agente ISOLADO (sem histórico da conversa; artefato + schema +
			critérios + verificação de disco per inputContract do quality-gate). O sub-agente
			verificou as alegações factuais contra o disco: fce/domain-model.cue TEM
			evt-invoice-issued com sourceContext "inv" e cmt NÃO o tem (o falso-verde alegado é
			real); ev_scoped_cross_file_id_exists resolve contra união global (premissa central
			confere); ev_item_scoped_cross_file_id_exists implementa exatamente o desenho da
			decisão (escopo por-item, cache por escopo, escopo fantasma, violação nomeando
			arquivo+item+escopo); self-test PASS com a fixture nova; runner full 31/0 idêntico ao
			baseline alegado na decisão 2; os 3 affectedArtifacts alterados de fato.

			FINDING (uq-03, fail): consequences dizia 'um kind a mais no vocabulario do engine
			(17→18)' — contagem incorreta sob qualquer interpretação: a união discriminada em
			structural-check.cue tem 22 kinds pós-introdução (21→22), idem o mapa EVAL do runner.
			Número errado em registro permanente cria ilusão de rastreabilidade sobre o estado do
			engine. Demais critérios: uq-01/02/04..08 OK; tq-adr-01 (alternativas com rejeição
			justificada: chave composta vs motor; esperar 2ª consumidora), tq-adr-02
			(medium/cross-cutting consistentes; nota de calibração vs adr-113 high/repo-wide —
			divergência entre precedentes, não violação), tq-adr-03/04 OK.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — correção aplicada e re-verificada: '(17→18)' → '(21→22)' em consequences
			(1 token). Contagem re-conferida no disco pelo agente principal: 22 entradas
			'kind: "..."' na união do schema e 22 entradas no dict EVAL do runner, ambas
			pós-introdução. cue vet EXIT=0 pós-edição. Nenhum finding novo introduzido pela
			correção (edição não toca decisão, falsificação nem refs).
			"""
	}]

	findings: {}

	summary: """
		adr-169 (kind item-scoped-cross-file-id-exists): review ISOLADO encontrou 1 fail factual —
		contagem de kinds do engine errada em consequences (dizia 17→18; o disco tem 21→22) —
		corrigido em 1 token e re-verificado no round 2. Todas as demais alegações da decisão foram
		verificadas no disco pelo sub-agente: falso-verde por cópia consumida REAL (fce tem
		evt-invoice-issued consumido; cmt não o tem), evaluator implementa o desenho, aditividade
		provada (31/0 idêntico), fixture do self-test morde como declarado. VEREDITO: stable,
		0 fail residual.
		"""
}
