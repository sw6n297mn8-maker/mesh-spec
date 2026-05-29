package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def028FceTcmSyncQueryFilter: build_time.#SelfReviewReport & {
	reportId: "srr-def-028-fce-tcm-sync-query-filter"

	artifactPath:       "architecture/deferred-decisions/def-028-fce-tcm-sync-query-filter.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-028 (W4 fce↔tcm, Família B da taxonomia de
			exclusão do grafo do sc-cm-07). Proposta passou por 3 ciclos
			pré-aprovação:

			Ciclo 1 (propose): proposta inicial sugeria "projection-adjustment"
			(Família A) por analogia com def-026.
			Ciclo 2 (refine + pausa): leitura dos subdomains FCE e TCM REFUTOU
			a hipótese inicial — "TCM projeta; FCE executa" + "cadências de
			evolução independente" + "FCE utiliza informações de
			disponibilidade fornecidas por TCM para otimizar execução, sem
			assumir gestão de posição de caixa" desfizeram a leitura de loop
			projection-adjustment estrutural. Agente pausou e reportou ao
			founder.
			Ciclo 3 (re-decision): founder confirmou refinamento para opção
			(b) — Família B (edgeFilter sobre dado existente) em vez de
			Família A (kind semântico). Decisão final: filter sync + queries
			+ ausência de events.

			Conformância #DeferredDecision (tq-def-01/02/03/04):

			(tq-def-01 — deferralRationale articula trade-off concreto):
			deferralRationale ≥100 runes explicita MOTIVO (forma exata do
			filter + scan complementar para outras query-surfaces + ADR-120
			planejado) + RISCO (filter composto mal-desenhado pode excluir
			hybrid sync+async erroneamente) + CUSTO (1 ciclo W4 WARN;
			reversível em PR-2). PASS.

			(tq-def-02 — triggers codificados, não prose): triggers conforma
			#Trigger discriminated union — manual-review com reason ≥40 runes
			+ adjacent-need file-contains. PASS (cue vet exit 0).

			(tq-def-03 — pelo menos 1 trigger non-manual-review): adjacent-need
			file-contains é non-manual-review machine-evaluable. PASS.

			(tq-def-04 — costOfDeferral coerente com escopo): severity=medium
			+ blastRadius=cross-artifact justificados (escopo contido a 2 BCs
			+ decisão tática vs estratégica + reversível mecanicamente; sc-cm-07
			+ context-map + potencialmente outros query-surfaces). PASS.

			Distinção entre Famílias (registrada na description do def):
			- Família A: relação tem natureza qualitativa nova → vocabulário
			  novo do schema do context-map (def-026, def-027).
			- Família B: relação já tem campos que distinguem dependência vs
			  operação → só filter no sc-cm-07 (def-028).

			Esta distinção fecha o loop conceitual sobre como o sc-cm-07
			evolui: kinds semânticos quando o schema precisa nomear; filters
			quando o schema já carrega o dado.

			Verificação:
			- cue vet ./architecture/deferred-decisions/ EXIT 0;
			- shape conforma à variante "open";
			- originatingArtifacts cita 5 referências reais (context-map.cue,
			  sc-cm-07, adr-117, subdomain FCE, subdomain TCM);
			- triggers[1].condition.pattern "communication.type" é único o
			  suficiente no path do sc-cm-07 (baixo risco de FP; "." regex
			  como "qualquer char" é aceito porque o contexto natural é
			  literal).
			"""
	}]

	findings: {}

	summary: """
		def-028 conforma #DeferredDecision (tq-def-01/02/03/04 todos passados).
		Família B da taxonomia (edgeFilter sobre dado existente; sem mudar
		schema do context-map). Cobre W4 do sc-cm-07. Proposta inicial
		(projection-adjustment kind, Família A) foi REFUTADA pela leitura
		dos subdomains FCE/TCM — pausa do agente + refinamento founder
		levaram à decisão correta. Verificado: cue vet exit 0.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round após 3 ciclos de calibração pré-escrita
		incluindo pausa explícita do agente quando subdomains contradiram a
		hipótese inicial. Conformidade verificada por cue vet + análise
		tq-def-NN. Sem espaço de decisão aberto a red-team adicional —
		decisão DDD foi corrigida na pausa pré-Fase 2.
		"""
}
