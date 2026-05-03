package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

idcPrimaryAgentSpecPreDExpansion: build_time.#SelfReviewReport & {
	reportId: "srr-idc-primary-agent-spec-pre-d-expansion"

	artifactPath:       "contexts/idc/agents/idc-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-01"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Retroativo per adr-060 (Opção D) cobrindo as touches deste agent-spec nesta branch: (1) F1+F3 amendments em commit 8822fb5 (signal coverage gap fechado: novo signal sig-generation-result com coversCategory='generation'; sig-validation-result.description corrigido para remover ref a act-normalize-identity-data; decide-vs-execute pattern Phase 0 articulado em outer rationale para act-sign-evidence/act-generate-integrity-proof/act-propose-identity-revocation com exceção explícita de act-execute-identity-verification por outcome determinístico); (2) F2 amendment em commit 8bef2e3 (act-propose-identity-revocation.inputTrustLevel: trusted-internal → external-structured per Opção C founder decision com chain-of-origin clarification em description). Original spec era b248178 (pre-session, em main). Tq-ag-01..13 + tq-agg-01..10 satisfeitos por inspeção (review retroativo vs PG-A documentado em chat sessão 2026-05-01: 4 findings warn — F1/F2/F3 fechados; F4 endereçado via PG-A refinement commit 35dd8ab). cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Retroativo per adr-060: cobre F1+F3 (8822fb5) + F2 (8bef2e3) amendments do agent-spec IDC. Single round consolidando as 2 touches; tq-ag + tq-agg satisfeitos via review retroativo prévio + amendments."

	singleRoundRationale: "Retroativo criado pós-fact em adr-060 commit per founder-approved Opção D plan. Single round porque ambas touches são amendments mecânicos coordenados (F1+F3 em commit único; F2 em commit posterior). Review retroativo completo vs PG-A foi feito em chat anterior (Item 2 do session pendente list); este report consolida evidência da branch-level changes."
}
