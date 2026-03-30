package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

commitmentLifecycle: build_time.#SelfReviewReport & {
	reportId:          "srr-commitment-lifecycle"
	artifactPath:      "architecture/cross-context-workflows/commitment-lifecycle.cue"
	artifactSchemaPath: "architecture/artifact-schemas/cross-context-flow.cue"
	artifactType:      "cross-context-flow"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-30T00:00:00Z"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Import path usa formato curto 'mesh-spec/architecture/artifact-schemas' em vez do path completo com módulo GitHub usado em todos os outros arquivos do repo. Todos os critérios tipo-específicos (tq-xf-01 a tq-xf-07) passam: ownership por BC, cadeia conectada CMT→BDG→DLV→INV→FCE, invariantes emergentes com 3 contribuições distintas, CommitmentId com origem e 4 consumidores, agnóstico a runtime, outOfScope com 6 exclusões, failureModes com 3 entradas."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Import path corrigido para formato completo com módulo GitHub. Todos os 8 critérios universais e 7 critérios tipo-específicos passam. Artefato estável."
	}]

	findings: {}

	summary: "Instância commitment-lifecycle conforma com #CrossContextFlow. Corrigido import path na round 1. Cadeia CMT→BDG→DLV→INV→FCE é conectada e verificável. Invariantes emergentes referenciam 3 contexts distintos cada. CommitmentId como conceito cross-cutting com rastreabilidade end-to-end. 3 failure modes documentados para flow financeiro (tq-xf-07). Artefato permanece agnóstico a runtime."
}
