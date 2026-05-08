package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def015TaskOutputTemporalityMetadata: build_time.#SelfReviewReport & {
	reportId: "srr-def-015"

	artifactPath:       "architecture/deferred-decisions/def-015-task-output-temporality-metadata.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-08"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			def-015 registra deferimento governado de promotion a schema fields para metadata temporal de tasks (status delivered/pending em #TaskOutput + origin emergent-from em #TaskSpec) emergente em WI-070 (primeiro caso real — Bootstrap Economic Foundation Layers emergent from WI-053 R3 cross-BC review).

			Founder canonical R5+ insight unificador capturado: status + origin são o mesmo fenômeno — 'temporalidade do trabalho' (status = estado no tempo; origin = causalidade no tempo). Por isso deferimento UNIFICADO cobre os dois fields, não dois deferimentos separados.

			Decisão de design P3 escolhida em sessão 2026-05-08 (vs P1 schema mod imediata + ADR / vs P2 rationale only sem tracking): preserva disciplina de meta-rule founder canonical '1 ocorrência ≠ nova estrutura; repetição gera estrutura' E preserva memória da decisão via deferred-decision com trigger automático. P1 violaria meta-rule (cristaliza padrão prematuramente em 1 uso); P2 perderia rastreabilidade (vira dívida invisível). P3 resolve ambos lados.

			Trigger calibrado: kind 'recurrence', pattern 'OUTPUTS STATUS (structured):', scope file-content, threshold 2. Header line distintivo (header em rationale de WI-070 task-spec; pouco propenso a falsos positivos). Threshold 2 — segundo WI emergent com mesmo pattern → trigger fires → ADR + schema change considered. Threshold 2 (não 3 da meta-rule '3 usos → schema') porque pattern já existe em WI-070; segunda ocorrência prova que NÃO é caso isolado e justifica revisita estrutural.

			Pattern self-match check: def-015 description usa 'OUTPUTS STATUS' em prose argumentativa (referenciando WI-070 rationale), não como header parseable em task-spec. Trigger pattern busca em scope file-content; def-015 vive em architecture/deferred-decisions/ (não governance/build-time/task-specs/). Runner não confunde — pattern match em path scope diferente. Verified clean por inspeção pós-write.

			costOfDeferral: severity medium / blastRadius cross-artifact. Sem schema field structurally, runner não consegue: (1) calcular % progresso real WIs com outputs parciais; (2) detectar emergence patterns automaticamente; (3) gerar projections DELIVERED vs PENDING. Workaround atual via convenção textual em rationale é frágil — quebra silently se autor de WI futuro esquecer convenção. Risco cumulativo medium ao longo de N WIs emergent; cross-artifact porque afeta task-specs + work-graph + projections.

			originatingArtifacts: 2 entries — governance/build-time/task-specs/wi-070.cue (path do primeiro caso real) + session:wi-070-emergent-from-wi-053-2026-05-08 (sessão de chat onde decisão P3 foi tomada).

			Schema satisfação por inspeção:
			- id format 'def-015' ✓ (regex ^def-[0-9]{3}$)
			- title concreto articulando promotion + condition de revisita ✓
			- date ISO 2026-05-08 ✓
			- description substantivo (≥50 chars) articulando 3 features (status / origin / unificação 'temporalidade') + primeiro caso real WI-070 + insight founder ✓
			- deferralRationale (≥100 chars) articula meta-rule 'repetição gera estrutura' + trade-off P1/P2/P3 + custo de continuar deferindo ✓
			- triggerCalibrationRationale (≥50 chars) articula threshold 2 vs 3 reasoning + pattern distintivo + scope ✓
			- originatingArtifacts 2 (path .cue + session:slug) ✓
			- costOfDeferral severity medium + blastRadius cross-artifact + description substantivo (≥50 chars) ✓
			- triggers 1 recurrence machine-evaluable ✓
			- status open ✓ (correto para deferimento recém-criado)

			vc-te-01 satisfeito (anti-catch-all): decisão CONSCIENTE de NÃO promote schema agora; trade-off ARTICULADO (preservar meta-rule vs perder rastreabilidade automática); condição CODIFICADA de revisita (recurrence threshold 2). NÃO é WI rotineiro (não tem trade-off articulado); NÃO é tension-entry (não é tensão entre forças concorrentes — é decisão temporal); NÃO é bug travestido (é decisão arquitetural genuína).

			Pattern paralelo a def-013 (envelope governance typing maturity) e def-014 (canvas communication schema enrichment) — mesma classe de deferimento (schema enrichment quando recurrence justify); diferente em foco (def-015 é meta-governance — temporalidade do trabalho — vs def-013/014 que são canvas/envelope domain semantics).

			cue vet ./... EXIT=0 post-write (recursive + strict).
			"""
	}]

	findings: {}

	summary: """
		def-015 captura deferimento governado de promotion a schema fields para metadata temporal de tasks (status delivered/pending + origin emergent-from). Emergente em WI-070 (primeiro caso real — Economic Foundation Layers emergent from WI-053). Founder canonical insight unificador: 'temporalidade do trabalho' agrupa status (estado no tempo) + origin (causalidade no tempo) em fenômeno único. Path P3 escolhido (rationale estruturado + deferred-decision tracking) preserva meta-rule '1 ocorrência ≠ nova estrutura' E preserva rastreabilidade. Trigger recurrence threshold 2 com pattern 'OUTPUTS STATUS (structured):'. costOfDeferral medium / cross-artifact. Schema #DeferredDecision satisfeito por inspeção. cue vet clean.
		"""

	singleRoundRationale: """
		Authoring via founder dialectic R5+ pre-write iterativo (P1/P2/P3 evaluated; P3 selected; rationale formato sem brackets; timestamps escalonados; insight unificador status+origin). Pattern paralelo a def-013/def-014 schema enrichment deferment class. Round único suficiente — qualidade incorporada via founder bilateral pushback durante design phase + meta-rule enforcement (não cristalizar prematuramente) + tracking automático garantido via trigger machine-evaluable. Founder approval registered em sessão 2026-05-08 commit d97a443 prep.
		"""
}
