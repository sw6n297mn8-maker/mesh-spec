package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr135: build_time.#SelfReviewReport & {
	reportId: "srr-adr-135-relation-classification-schema-gated"

	artifactPath:       "architecture/adrs/adr-135-relation-classification-schema-gated.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-01"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-135 (resolve def-033 por documentação — gate de
			classificação de relação é redundante). NOTA: rollout prescreve
			isolated-subagent para adr; aqui self-reported (manual takeover).
			Avaliado contra 8 universalCriteria + tq-adr.

			uq-01 (WHY): rationale explica por que NÃO criar check (redundância com
			schema+sc-cm-07), não o que o check faria. Pass.
			uq-02 (Mesh): é a metade determinística do enforcement de derivação P13
			da Mesh (adr-040). Pass.
			uq-03 (refs): affectedArtifacts apontam paths existentes (def-033,
			context-map schema, sc context-map); a prova 47/47 é verificável. Pass.
			uq-04 (princípios): P10 (gate determinístico já existe; correção semântica
			é advisory) + P12 (a regra vive no schema versionado, não em check novo). Pass.
			uq-05 (limitações): consequência N declara o risco (se o schema afrouxar
			pattern→opcional, o gate some silenciosamente) — coberto pela
			falsificationCondition. Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #ADR): decisionClass/decider/status/falsificationCondition{
			condition,observableSignal}/affectedArtifacts/principlesApplied/supersedes
			presentes; cue vet EXIT=0. Pass.
			tq-adr (alternativas): context avalia construir o check (rejeitado —
			redundante, prova 47/47 + união discriminada) vs documentar (escolhido). Pass.
			"""
	}]

	findings: {}

	summary: """
		adr-135 documenta que a presença de classificação de relação cross-BC já é
		enforçada determinísticamente — #Relationship é união discriminada por
		direction (cue vet falha sem upstreamPattern+downstreamPattern) + sc-cm-07
		(ciclo sem kind tipado → reject). Cobertura verificada: 47/47 arestas
		classificadas, cue vet EXIT=0. Logo um structural-check novo (a proposta de
		def-033) seria redundante; def-033 → resolved por este ADR. A correção
		SEMÂNTICA (pattern correto, não só presente) é interpretativa (P10) e vive em
		def-029 (advisory, independente). Estável em 1 round.
		"""

	singleRoundRationale: """
		Decisão derivada de pré-flight verificado nesta sessão (47/47 classificadas;
		#Relationship discriminated-union por direction; sc-cm-07 reject). O ADR
		registra um fato estrutural verificável por inspeção direta (cue vet + leitura
		do schema), não uma decisão de design nova com alternativas em aberto. Sem
		ambiguidade pendente.
		"""
}
