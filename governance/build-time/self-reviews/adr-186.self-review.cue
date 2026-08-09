package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr186Adoption: build_time.#SelfReviewReport & {
	reportId:           "srr-adr-186"
	artifactPath:       "architecture/adrs/adr-186-adopt-tekton-proof-model-binding.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"
	executionMode:      "isolated-subagent"
	generatedAt:        "2026-08-09"
	roundsExecuted:     1
	maxRounds:          4
	status:             "stable"
	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: "Review isolado (subagente sem histórico da conversa) de adr-186 contra uq-01..09 + tq-adr-01..04. Zero findings: refs cruzadas (adr-148/157/182/183/184/185, def-084, P0/P1/P10/P14) resolvem no repo; plannedOutputs (evidence-types, verifier-types) new-created corretos per adr-059; alternativas (a)-(d) com motivo de rejeição substantivo (tq-adr-01); specificity test (uq-02) quebra na troca Mesh->qualquer-fintech. Única observação não-finding: rationale de reversibility=medium encostava na definição de high; refinado antes da materialização, calibração medium mantida por decisão do founder."
	}]
	findings: {}
	summary: "adr-186 (adoção do modelo de prova Tekton v0.4.0 como binding Mesh) estabilizou em 1 round via review isolado, sem findings fail/warn/info. Decisão structural que adota o vocabulário genérico (evidence-types + verifier-types verbatim @ 0.4.0/0de85b3), declara o binding Mesh, reinterpreta adr-183/184/185 (generic authority transferred / Mesh-specific authority preserved) e fixa a condição de resolução de def-084; conformidade #ADR e coerência com P0/P1/P10/P14 confirmadas pelo subagente isolado."
	singleRoundRationale: "Estabilizou em 1 round porque as três sections (scaffold, context-decision, consequences-traceability) passaram por section-gates bloqueantes com o founder ANTES da integração (manualAuthoringProtocol), e um verification pass mecânico já resolvera as alegações factuais (refs cruzadas, colisão de nomes no package artifact_schemas, âncora v0.4.0/0de85b3) durante a autoria; o review isolado confirmou sem introduzir fail — convergência de gates prévios, não bypass."
}
