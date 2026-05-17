package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr078PgCanvasMetricClassificationHardening: build_time.#SelfReviewReport & {
	reportId: "srr-adr-078"

	artifactPath:       "architecture/adrs/adr-078-pg-canvas-metric-classification-hardening.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-06"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-078 operacionaliza ADR-077 (commit 8d964fd) via PG canvas
			Section 8 hardening — fecha gap operacional onde campo schema
			existia (#VerificationMetric.onBreach) mas authoring rule
			permanecia ad-hoc, criando risco de fabricação simétrica
			cross-BC.

			Decisão: 7 mudanças coordenadas no PG (objective expandido +
			process 5-step decision flow + heuristics control/observability +
			many-to-one princípio + promotion path explícito + no-dead-paths
			heuristic + doneCriteria/finalValidation strengthened). Reversibility
			high (PG é guidance, não schema constraint); blastRadius local
			(PG canvas único guide).

			Trade-offs principais avaliados: (a) ADR-078 standalone vs absorvido
			em ADR-077 → standalone preserva separação layer (ADR-077 = schema;
			ADR-078 = authoring rule); (b) 2 vs 3 categorias formais (control/
			observability/diagnostic) → 2 categorias com promotion path em
			rationale (founder pushback agente: 'diagnostic vira só texto sem
			schema enum'); (c) wording original 'métrica agregada → não onBreach'
			→ refinado para 'métrica sem threshold crítico claro' (agente
			pushback empírico: vm-inv-2 INV é agregada com threshold
			determinístico legítimo); (d) 3-layer governance loop como insight
			expansion → DEFERRED (founder discipline: 'insight, NÃO escopo';
			implementar agora via lens não-validada empiricamente seria erro
			de escopo).

			Founder review iterativo aplicou 4 ajustes finais pre-write: (1)
			tightening process step 2 — 'criar escalationCriterion APENAS se
			causalidade determinística OR classificar como observability-only
			(NÃO criar escalation prematuramente)'; (2) promotion path com
			critério negativo explícito 'NÃO promover sem evidência empírica
			de causalidade estável e reproduzível' bloqueia 'acho que dá pra
			automatizar'; (3) many-to-one wording fortalecido 'MESMO quando
			múltiplas métricas parecem distintas — se convergem em mesmo
			failure mode, convergem para mesma escalation' fecha caso clássico
			'mas essa métrica é um pouco diferente'; (4) no-dead-paths
			'EXPLÍCITO E VERIFICÁVEL' (não conceitual) reforça observabilidade
			real do trigger.

			Backward-compat: PG governa authoring future, não retrofits — 8
			canvases existentes (CMT, BDG, DLV, IDC, NPM, P2P, SSC, CTR) não
			exigem migration; backfill é WI canvas-schema-hardening separado
			se decidido. Zero breaking change. cue vet ./architecture/ EXIT=0
			pos-mod.

			Schema satisfação tq-adr-XX: tq-adr-01 (alternatives consideradas
			com substância — proposta inicial 'mencionar onBreach' rejeitada;
			3 trade-offs principais avaliados com pushback bilateral) ✓;
			tq-adr-02 (reversibility high reflete PG guidance scope;
			blastRadius local reflete PG single guide) ✓; tq-adr-03
			(affectedArtifacts path real architecture/production-guides/
			canvas.cue) ✓; tq-adr-04 (impacto rastreável — 1
			affectedArtifacts non-empty satisfaz at-least-one-of-3
			per sc-adr-01) ✓.

			Round único suficiente — qualidade incorporada via founder review
			iterativo substantivo (avaliação crítica + pushback bilateral +
			4 micro-tightenings finais) pre-write; ADR é destilação cirúrgica
			de consensus pre-write em vez de proposal aberta a iteration
			pos-hoc.

			Lessons learned: (a) PG updates derivative de ADRs estruturais
			devem ser tratados como ADRs próprios quando adicionam authoring
			rules substantivas (não editorial); (b) sistema de decisão
			consistente cross-BC vale schema mod minoritária + ADR
			operacionalização paralelo vs single ADR cobrindo ambos —
			separação preserva clareza de scope (schema vs authoring rule);
			(c) anti-pattern 'fabricação simétrica' (forçar OR omitir
			indiscriminadamente) requer guidance algorítmica determinística,
			não heurística textual.
			"""
	}]

	findings: {}

	summary: """
		ADR-078 (PG canvas Section 8 hardening — operationalize metric
		classification per ADR-077) materializa 7 mudanças coordenadas em
		PG canvas: objective expandido + process 5-step + heuristics
		control/observability/many-to-one/no-dead-paths + promotion path
		explícito + doneCriteria/finalValidation strengthened. 4 vetores
		fabricação simétrica bloqueados (forçar onBreach; omitir
		indiscriminadamente; criar escalations sintéticas; promoção
		prematura). Reversibility high; blastRadius local. Zero breaking
		change. Founder review iterativo: 5 aprovações iniciais + 2
		pushbacks aceitos (wording 'agregada' + categoria 'diagnostic') +
		1 expansion deferred (3-layer governance) + 4 micro-tightenings
		finais. tq-adr-01..04 satisfeitos. cue vet ./architecture/ clean.
		"""

	singleRoundRationale: """
		Authoring manual via founder review iterativo schema hardening
		session — avaliação crítica de proposta inicial 'mencionar
		onBreach' rejeitada como insuficiente; escalou para 'sistema de
		decisão consistente'. Pre-write founder approval: 5 aprovações +
		2 pushbacks bilaterais + 1 deferral + 4 micro-tightenings finais.
		Auto-checks PASSED (cue vet ./architecture/ EXIT=0; backward-compat
		verification 8 canvases existentes preservados; zero breaking
		change). Padrão paralelo a adr-043 Phase 1 advisory rollout —
		método cirúrgico-de-destilação quando founder review prévia é
		substantiva o suficiente para incorporar toda iteration em batch
		único pre-write.
		"""
}
