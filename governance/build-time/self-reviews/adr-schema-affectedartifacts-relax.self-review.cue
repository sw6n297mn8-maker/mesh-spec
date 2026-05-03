package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adrSchemaAffectedartifactsRelax: build_time.#SelfReviewReport & {
	reportId: "srr-adr-schema-affectedartifacts-relax"

	artifactPath:       "architecture/artifact-schemas/adr.cue"
	artifactSchemaPath: "architecture/artifact-schemas/quality-criteria.cue"
	artifactType:       "artifact-schema"

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
		summary:   "Schema #ADR.affectedArtifacts relaxado de '[string & !=\"\", ...string & !=\"\"]' (required ≥1) para '[...string & !=\"\"]' (optional non-empty list, can be empty). Fecha gap não-resolvido no setup de adr-059 (commit 907e6b9): plannedOutputs foi adicionado como optional, mas affectedArtifacts permaneceu required ≥1, impossibilitando migração de ADRs cuja única atividade é criar paths novos (adr-041, adr-048 — 1 path total, classificado como new-created → sem nada para deixar em affectedArtifacts). Comment do field expandido articulando relaxação + nota de que at-least-one across {affectedArtifacts, plannedOutputs, derivedArtifacts} é discipline narrative em PG-ADR (não enforced por schema dado limites de disjunção CUE sobre fields opcionais; runner futuro pode validar). Trade-off explícito: schema permite 3 fields vazios simultaneamente (semanticamente inválido), mas constraint complexa hit FlowPayload-style CUE limitations. Coerente com adr-059 intent original. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: """
		Schema #ADR.affectedArtifacts relaxado de required ≥1 para
		optional non-empty list (allow empty). Fecha gap do setup de
		adr-059 — plannedOutputs optional + affectedArtifacts required
		impossibilitava migração de ADRs com apenas paths new-created.
		Coerente com adr-059 intent. Single round porque mudança é
		schema relax editorial; PG-ADR documenta at-least-one como
		discipline narrative.
		"""

	singleRoundRationale: """
		Mudança é completion mecânica do setup de adr-059 (commit
		907e6b9) descoberta durante execução de C3 Part 2 (founder-
		approved migration plan). Founder pre-approval explícita
		('Opção B' + 'Opção mais completa e definitiva'). Round 1
		do self-review verifica: (a) cue vet ./... passa EXIT=0 com
		11 migrações usando affectedArtifacts vazio quando aplicável
		(adr-041, adr-048), (b) tipo [...string & !=\"\"] preserva
		non-empty string constraint elemento-a-elemento, (c) ADRs
		existentes pré-migration permanecem válidas (todos têm ≥1
		entry; nenhuma regressão), (d) at-least-one constraint movido
		para discipline narrative em PG-ADR (não schema-enforced
		dado limites de disjunção CUE).
		"""
}
