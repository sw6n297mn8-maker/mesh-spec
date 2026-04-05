package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

ctrPrimaryAgentSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-ctr-primary-agent"

	artifactPath:       "contexts/ctr/agents/ctr-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"
	canonicalSource:    "governance/build-time/quality-gate.cue"
	executionMode:      "self-reported"
	generatedAt:        "2026-04-03"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "8 ações, 5 constraints, 5 escalation conditions, 6 signals avaliados contra 8 critérios universais + 13 type-specific do agent-spec schema. Zero fail. 1 warn: tq-ag-09 — governanceRef 'ctr-primary-agent' aponta para envelope ainda não criado (ctr-primary-agent.governance.cue). Forward reference deliberada; envelope é próximo artefato planejado."
	}]

	findings: {
		warn: [{
			criterionId: "tq-ag-09"
			severity:    "warn"
			message:     "governanceRef 'ctr-primary-agent' referencia contexts/ctr/agents/ctr-primary-agent.governance.cue que não existe. Forward reference planejada — envelope de governança é próximo artefato a ser criado."
		}]
	}

	singleRoundRationale: "Agent spec do CTR foi construído iterativamente com 4 correções solicitadas pelo founder (precondition de revalidação em revisão, act-publish como side effect, expire idempotente, rename query). Artefato já passou por revisão humana detalhada antes do self-review. 21 critérios avaliados, zero fail, 1 warn (forward ref para governance envelope). Estabilização em round 1 reflete maturidade do artefato pós-revisão humana."

	summary: "CTR primary agent spec estável. 8 ações cobrindo lifecycle completo de Contract Terms, calibração de autonomia alinhada com canvas governance scope (execute-and-log para determinísticas, propose-and-wait para ativação/cancelamento). 1 warn pendente: governance envelope inexistente (forward reference planejada). Zero fail em 21 critérios."
}
