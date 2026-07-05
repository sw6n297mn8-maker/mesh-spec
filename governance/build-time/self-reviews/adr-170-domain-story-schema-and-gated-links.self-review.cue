package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr170DomainStorySchemaAndGatedLinks: build_time.#SelfReviewReport & {
	reportId: "srr-adr-170-domain-story-schema-and-gated-links"

	artifactPath:       "architecture/adrs/adr-170-domain-story-schema-and-gated-links.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-05"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — review por sub-agente ISOLADO (sem histórico da conversa; inputContract do
			quality-gate). ZERO findings. Verificações de disco do sub-agente: os 3
			affectedArtifacts alterados de fato (enum #ArtifactType com 'domain-story',
			coveredSchemas do sc-pg-01, disp-009 no subagent-execution-log); os 5 plannedOutputs
			existem na working tree; defersTo resolve (def-075/def-076); a citação do _meta.cue é
			fiel ao arquivo; WI-113 no wave-plan diz exatamente 'Brandolini + 1ª instância CMT'
			com output cmt-commitment-formation.cue (a divergência declarada no item 5 é honesta);
			tq-gl-02 diz literalmente que refs cross-glossário não são suportadas (o elo frouxo do
			item 4 é fiel); o mapeamento readModelRefs→projections[].code e
			queryRefs→projections[].queryCapabilities[].code confere com sc-ds-07/08 e com o disco.

			Critérios: uq-01 (rationale explica por que forma mínima venceu Brandolini e por que
			ordem-pela-posição) OK; uq-02 (teia stakeholder↔canvas↔glossário↔domain-model, WI-113,
			def-075/076) OK; uq-03 TODAS as refs verificadas OK; uq-04 (P0/P10/adr-097/062/054)
			OK; uq-05 (vácuo-verde dos 8 warn, termo sem gate, corte vigiado pela falsificação)
			OK; uq-06/07/08 OK; tq-adr-01 (Brandolini completo rejeitado com justificativa) OK;
			tq-adr-02 (medium/cross-cutting refletem schema+8 checks+PG+2 defs) OK; tq-adr-03/04
			OK. uq-09: PG-ADR aplicado dentro do arco de checkpoint único definido pelo founder
			(ordem Tempo 2); auto-checks das sections apresentados em batch no checkpoint
			(cláusula batch do serializationRule — pattern def-074).
			"""
	}]

	findings: {}

	summary: """
		adr-170 (schema #DomainStory + elos gateados + princípio 'a story referencia o que existe;
		ref vazia = lacuna honesta'): review ISOLADO com ZERO findings — todas as refs e alegações
		factuais verificadas no disco pelo sub-agente, incluindo a fidelidade da citação do
		_meta.cue, a divergência declarada vs WI-113 e o mapeamento de refs aos nomes reais dos
		domain-models. VEREDITO: stable.
		"""

	singleRoundRationale: """
		Round único isolado suficiente: o conteúdo substantivo do ADR passou por review isolado
		PRÉ-ESCRITA do schema draft (3 BLOCKERs + 7 WARNs, todos endereçados — os BLOCKERs viraram
		exatamente os itens 3/4/5 da decisão: pacote completo no mesmo commit, def-075 real em vez
		de def fantasma, divergência de eventos declarada) e o review isolado pós-escrita confirmou
		zero findings residuais com verificação de disco integral.
		"""
}
