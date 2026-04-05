package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

ctrPrimaryAgentGovernanceSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-ctr-primary-agent-governance"

	artifactPath:       "contexts/ctr/agents/ctr-primary-agent.governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-governance.cue"
	artifactType:       "agent-governance"
	canonicalSource:    "governance/build-time/quality-gate.cue"
	executionMode:      "self-reported"
	generatedAt:        "2026-04-03"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 2
		infoCount: 0
		summary:   "Governance envelope do CTR primary agent avaliado contra 8 critérios universais + 10 type-specific do agent-governance schema. Zero fail. 2 warns: tq-gv-09 (blastRadiusCaps não validáveis contra global inexistente) e tq-gv-12 (governanceGlobalVersion 0.1 forward reference — architecture/agent-governance.cue não existe). Ambos documentados como limitações conhecidas no header do artefato. 4 rotas de escalação, 3 drift metrics, 2 promotion criteria, 3 regression triggers avaliados."
	}]

	findings: {
		warn: [{
			criterionId: "tq-gv-09"
			severity:    "warn"
			message:     "blastRadiusCaps (maxConcurrentMutations=3, maxDailyActions=50) não podem ser validados contra blastRadiusPolicy global porque architecture/agent-governance.cue não existe. Forward reference documentada no header — será satisfeito quando global for criado."
		}, {
			criterionId: "tq-gv-12"
			severity:    "warn"
			message:     "governanceGlobalVersion '0.1' referencia architecture/agent-governance.cue que não existe. Estruturalmente permitido pelo type system (string com regex). Validação de match é runner-level. Forward reference documentada no header."
		}]
	}

	singleRoundRationale: "Governance envelope construído iterativamente com 3 rounds de ataque/correção internos + 2 rounds de revisão pelo founder antes do self-review. Correções materiais: (1) suspicious-input rationale explicitado para separar audit trail operacional de event log de domínio, (2) ambiguous-case rationale documenta simplificação temporária por limitação de sub-routing, (3) insufficient-context removido bypass de invariante. 18 critérios avaliados, zero fail, 2 warns (forward refs para global). Estabilização em round 1 reflete maturidade do artefato pós-revisão humana."

	summary: "CTR primary agent governance envelope estável em lifecycle onboarding. 4 rotas de escalação (sync-human-review e alert-and-block), blast radius conservador (3 concurrent, 50 daily), drift detection semanal com 3 métricas, calibração com promoção em dois estágios e regressão de tolerância zero para violação de invariante. 2 warns pendentes: global governance inexistente (forward reference documentada)."
}
