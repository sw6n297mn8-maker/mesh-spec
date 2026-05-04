package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr074: build_time.#SelfReviewReport & {
	reportId: "srr-adr-074"

	artifactPath:       "architecture/adrs/adr-074-extend-authoring-rollout-for-wi-048-bc-bootstrap-types.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-04"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "ADR estende authoring-policy.cue rollout de 1 para 6 types: production-guide (existing) + canvas + glossary + domain-model + agent-spec + agent-governance (5 novos types de WI-048 BC bootstrap). promptTemplate generalizado: substitui hardcoded 'production-guide' por placeholder {artifactType}; substitui Section 1/2/3 references do META-PG por reference genérica a workOrder do production-guide alvo. outputContract tweaked: 'Draft #ProductionGuide' → 'Draft de instância conformante ao schema target'. Authorization-not-guarantee framing explícito: extensão do rollout AUTORIZA tentativa via subagent-drafted, NÃO garante sucesso; fallback to manual preserved per fallbackPolicy. Order de execução em WI-048: canvas → glossary → domain-model → agent-spec → agent-governance (dependency semântica). Revisit conditions explícitas: (a) 2+ fallbacks → revisar rollout, (b) canvas falha por complexidade → fora do rollout, (c) agent-spec/governance falham por context-heavy deps → restringir, (d) todos succedem → expand para próximos types. 4 alternativas explicitamente rejeitadas (status quo, canvas only B0, B1 escolhida, over-expansion). principlesApplied: P10, P12. decisionClass=structural, reversibility=high, blastRadius=cross-cutting. Cascade ordering pre-validated (5 PGs existem em main). Generalização at n=0 evidence per non-PG type aceita per founder guidance + WI-048 cohesion + per-dispatch fallback isolation. cue vet ./... EXIT=0; CI self-review-check local PASSED."
	}]

	findings: {}

	summary: "ADR-074 estende authoring rollout de 1 para 6 types (5 BC bootstrap types adicionados). promptTemplate generalizado. Authorization-not-guarantee framing. Revisit conditions explícitas. Volume baixo (3 arquivos: ADR + SRR + policy edit)."

	singleRoundRationale: "Pattern subagent-drafted estabelecido em adr-054/057 + Phase 1 validated em WI-069. Generalização documentada com revisit conditions. Authorization-not-guarantee preserva founder expectations. Round único suficiente."
}
