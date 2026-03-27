package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensCommonsCollectiveAction: build_time.#SelfReviewReport & {
	reportId: "srr-lens-commons-collective-action"

	artifactPath:       "architecture/lenses/lens-commons-collective-action.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 1
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary:   "Round 1 avaliou lente parcial (trigger + 16 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. uq-05 warn: limitações não declaradas (virão com conteúdo restante). Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation/meshImplication ancorados em FIDC, scoring, anchor tenants, Ostrom, construção civil (uq-02), crossDependsOn referencia lenses existentes (uq-03), sem contradição com design-principles (uq-04), terminologia consistente (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 11 condições testáveis com 5 excludeWhen e redirecionamento explícito. 16 conceitos com dependsOn consistentes internamente."
	}]

	findings: {
		fail: [{
			criterion: "uq-08"
			severity:  "fail"
			message:   "Campos obrigatórios do schema #AnalyticalLens ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
		warn: [{
			criterion: "uq-05"
			severity:  "warn"
			message:   "Limitações conhecidas não declaradas. Esperado: virão com o conteúdo restante da lente (limitations é campo obrigatório do schema)."
		}]
	}

	summary: """
		Lente commons-collective-action parcial com trigger (11 condições, 31
		keywords, 5 excludeWhen) e 16 conceitos cobrindo lifecycle, tipologia,
		heterogeneidade, coordenação vs contribuição, dados como commons,
		free-riding, tragédia dos comuns, seleção adversa intra-commons,
		governança Ostrom, custo de monitoramento, risco de enclosure, funding
		pool como club good, design de excludabilidade, reputação coletiva,
		incentivos de contribuição e saúde dos commons (1 operacional com
		reviewCadence quarterly). Fail estrutural (uq-08) por campos obrigatórios
		ausentes — artefato parcial por decisão do founder. Warn (uq-05) por
		limitações ausentes. Aguardando reasoningProtocol, meshExamples,
		principleIds, relatedLenses, limitations e rationale.
		"""
}
