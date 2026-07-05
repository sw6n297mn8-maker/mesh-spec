package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def052Adr169ScopingNote: build_time.#SelfReviewReport & {
	reportId: "srr-def-052-adr-169-scoping-note"

	artifactPath:       "architecture/deferred-decisions/def-052-manifest-cross-file-scoping.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
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
			Round 1 — self-review da EDIÇÃO do def-052 (nota datada [ATUALIZADO 2026-07-05,
			adr-169] na description; primeiro SRR deste artefato — o def-052 nasceu antes do
			gate exigir, e a edição presente ativa a exigência).

			[ESCOPO DA MUDANÇA]: additiva e cirúrgica — a nota separa as 3 manifestações da
			pergunta de escopo (stories POR-ITEM = resolvida pelo kind adr-169; sc-mri-01/02 =
			NÃO-migradas, aperto continua aguardando evidência e usará instance-scoped adr-113;
			def-013 = bloqueios próprios que nenhum kind resolve). Texto original intacto;
			triggers/status/costOfDeferral INALTERADOS — a nota registra estado do mundo, não
			re-calibra o deferimento.

			[FIDELIDADE FACTUAL]: OK, verificada — cada alegação da nota espelha evidência do
			read-only do Tempo 1: manifests têm escopo único na raiz (port-manifest
			boundedContextRef; aggregate-manifest aggregateRef); def-013 bloqueado por resolução
			de fileset first-definition-wins (runner, resolução de schema_location) + envelope
			sem campo de escopo; sc-ds-04..08 são o caso por-item genuíno. Coerente com adr-169
			decision item 5 (NÃO-MIGRAÇÃO explícita) e affectedArtifacts (def-052 listado).

			[uq-08]: OK — cue vet EXIT=0; edição não toca campos tipados. [uq-01/02]: N/A à nota
			(registro factual datado). [uq-03]: OK — adr-169, adr-113, sc-mri-01/02, def-013,
			sc-ds-04..08 todos existem (adr-169 no mesmo commit). [uq-04]: OK — a nota REFORÇA a
			separação capacidade-vs-migração (cada migração é decisão própria; nada migra por
			arrasto). [uq-05]: OK — a não-migração é o próprio conteúdo declarado. [uq-06]: OK.
			[uq-07]: OK. [uq-09]: edição de instância existente dentro do arco de checkpoint
			único (Tempo 2); batch no checkpoint.

			[APPEND-ONLY DE ESPÍRITO]: a convenção append-only formal é do subagent-execution-log,
			mas a nota segue o espírito para defs: marcada com data + causa (adr-169), sem editar
			o texto original — o histórico do deferimento permanece legível.
			"""
	}]

	findings: {}

	summary: """
		Edição do def-052: nota datada [ATUALIZADO 2026-07-05, adr-169] registrando que a 3ª
		manifestação da pergunta de escopo (stories, por-item) foi resolvida pelo kind novo, e que
		as DUAS manifestações do próprio def (sc-mri-01/02 plain; def-013 com bloqueios próprios)
		permanecem NÃO-migradas por decisão explícita. VEREDITO: stable, 0 fail. Nota aditiva,
		factualmente fiel ao read-only do Tempo 1, sem re-calibração de triggers/status; primeiro
		SRR do def-052 (exigência ativada por esta edição).
		"""

	singleRoundRationale: """
		Round único proporcional: edição de description em instância existente (nota datada de
		reconciliação), sem mudança de triggers, status ou calibração. O conteúdo da nota é o
		resultado direto do read-only do Tempo 1 reportado ao founder, cuja decisão ('construir o
		motor; registrar não-migração em nota no def-052') a nota transcreve.
		"""
}
