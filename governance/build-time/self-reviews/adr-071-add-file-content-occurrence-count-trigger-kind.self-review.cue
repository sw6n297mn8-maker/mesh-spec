package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr071: build_time.#SelfReviewReport & {
	reportId: "srr-adr-071"

	artifactPath:       "architecture/adrs/adr-071-add-file-content-occurrence-count-trigger-kind.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "ADR adiciona 6º trigger kind ao #Trigger union em #DeferredDecision: file-content-occurrence-count (path + pattern + threshold). Distinto de scope=file-content existente: conta OCCURRENCES dentro de UM arquivo singleton, não FILES com matches across repo. Use case originador (n=1): def-012 monitora crescimento de transient bootstrap exceptions em singleton policy file. Pattern ten-009 expand-when-needed normalmente sugere n=2; aqui generalizamos at n=1 porque alternative (drop automation OR creative workaround) perde signal valioso e use case é genérico (singleton governance file occurrence-count signaling). Restriction de uso documentada explicitamente em comment do schema + adr-071 rationale: É TRIGGER DE SINGLETON GOVERNANCE FILE, NÃO MECANISMO GERAL DE BUSCA NO REPO. Aplicar quando (a) há um arquivo canônico único, (b) sinal é quantidade de ocorrências dentro desse arquivo, (c) recurrence scope=file-content não serve. Conditions for revisit explícitas em decision item 6: vindication (2+ casos adicionais validam), over-built revisit (sem 2nd case após 3+ next path-mapping ADRs), scope expansion (path glob), threshold calibration. Runner extension em scripts/ci/evaluate-deferred-triggers.sh: handler com re.findall (count) + FileNotFoundError safety. 4 alternativas explicitamente rejeitadas (drop automation, workaround creative, nova RecurrenceScope, schema first-class kind único — escolhida). COUPLED com adr-070 (mesmo commit). principlesApplied: P10, P12. decisionClass=structural, reversibility=high, blastRadius=cross-cutting. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "ADR-071 adiciona file-content-occurrence-count trigger kind (singleton-file-only). Use case originador: def-012. Restriction documentada para evitar abuse. Conditions for revisit explícitas."

	singleRoundRationale: "Single ADR scope (1 kind addition); use case + restriction articulados; revisit conditions explícitas substituem rounds adicionais de red-team. Round único suficiente."
}
