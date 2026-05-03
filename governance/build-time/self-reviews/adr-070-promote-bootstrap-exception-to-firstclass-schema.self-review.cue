package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr070: build_time.#SelfReviewReport & {
	reportId: "srr-adr-070"

	artifactPath:       "architecture/adrs/adr-070-promote-bootstrap-exception-to-firstclass-schema.cue"
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
		summary:   "ADR promove #BootstrapException a schema first-class adicionando 3 fields: category (enum 3 valores: inaugural-circularity, predecessor-supersession-only, pre-mapping-transient), lifecycle (enum 2 valores: permanent, transient), exitCondition? (string opcional, presente em transient). Resolve def-011 após 2 trigger refires consecutivos (adr-068 count 3→4, adr-069 count 4→5) + Known gap explícito de adr-069 articulando active reconsideration. 4 alternativas explicitamente rejeitadas (manter schema atual + acknowledge, hybrid só category, full schema com CUE conditional, exitCondition obrigatório). Migration declarativa de 20 entries existentes: 4 inaugural-circularity + 2 predecessor-supersession-only (permanent) + 14 pre-mapping-transient (com exitCondition uniforme 'Remove exception when artifact receives a matching SRR after next modification.'). Stale detection structural-check sc-be-01 deferido per def-012 — zero stale empirically observed, design especulativo sem casos. CUE conditional category→lifecycle não adicionado por enquanto (preserva opção de futura categoria com entries de ambos lifecycles). exitCondition format estruturado deferido até 2nd transient category emerjam. defersTo: [def-012]. principlesApplied: P0 (zero duplicação), P10 (gates determinísticos), P12 (governança como código). decisionClass=structural, reversibility=high, blastRadius=cross-cutting. COUPLED com adr-071 (trigger kind necessário para def-012); separados por concern em mesmo commit. cue vet ./... EXIT=0; CI self-review-check local PASSED."
	}]

	findings: {}

	summary: "ADR-070 promove #BootstrapException a schema first-class (category + lifecycle + exitCondition?). Resolve def-011 (2 trigger refires + Known gap explícito). Migration de 20 entries; stale detection sc deferida em def-012."

	singleRoundRationale: "Active reconsideration de def-011 já incorporou red-team via founder articulation em adr-069 Known gaps + explicit choice (a1) entre 3 sub-paths. Schema design simples (3 fields, sem CUE conditionals) reduz superfície de erro. Round único suficiente."
}
