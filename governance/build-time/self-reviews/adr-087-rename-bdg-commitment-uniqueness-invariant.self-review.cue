package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr087RenameBdgCommitmentUniquenessInvariant: build_time.#SelfReviewReport & {
	reportId: "srr-adr-087-rename-bdg-commitment-uniqueness-invariant"

	artifactPath:       "architecture/adrs/adr-087-rename-bdg-commitment-uniqueness-invariant-global.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-12"

	roundsExecuted:        1
	maxRounds:             4
	singleRoundRationale:  "Rename é semantic correction de escopo limitado (single canonical name align com rule body já existente); plano + ADR draft pre-validados com founder em 2 ciclos de proposta (ADR-087 + plano de edits inicial; founder ajustes #1 semantic correction explicit + #2 sem dual canonical) antes de qualquer write. Multi-round seria ritual sem ganho — decisão arquitetural cristalizada pre-write."

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-087 + atomic rename across 4 files completed.

			Decisão: SEMANTIC CORRECTION (per founder ajuste #1
			explícito; distinção clara de cosmetic refactor):
			inv-commitment-id-uniqueness-per-cost-center →
			inv-commitment-id-global-uniqueness-active.

			Rationale: rule body domain-model + aggregate guard runtime +
			assertion structural-check sc-bdg-07 já operavam GLOBALLY
			(across all CostCenters). Suffixo 'per-cost-center' carried
			grandfathered from initial domain-model authoring (predating
			WI-084 structural-check review). CommitmentId é CMT-issued
			canonical id; unicidade econômica transversal — nome canonical
			deve refletir semantic real (P0 zero duplication).

			Behavior change: ZERO. Rule body + runtime + assertion NÃO
			mudam — rename é alignment exclusivamente.

			Edits atômicos (single commit):
			- contexts/bdg/domain-model.cue (4 occurrences)
			- contexts/bdg/agents/bdg-primary-agent.cue (5 occurrences)
			- contexts/bdg/agents/bdg-primary-agent.governance.cue (1)
			- architecture/structural-checks/bdg-domain-model.cue (1
			  occurrence in rule.invariantId + rationale cleanup
			  removing grandfathered note + adding ADR-087 reference)

			Single canonical name post-rename (per founder ajuste #2):
			- NÃO há dual canonical em código active
			- Alias histórico (nome antigo) preserved APENAS em:
			  (a) ADR-087 context section (migration audit trail)
			  (b) WI-084 SRR historical record (append-only audit trail
			      per CLAUDE.md SRRs não editáveis)

			Verificação pos-rename:
			grep -rn "inv-commitment-id-uniqueness-per-cost-center"
			retorna APENAS historical/audit references:
			- governance/build-time/self-reviews/bdg-structural-check.
			  self-review.cue (WI-084 SRR)
			- architecture/adrs/adr-087-*.cue (este ADR context)
			- governance/build-time/self-reviews/adr-087-*.self-review.cue
			  (este SRR documentando rename)
			Zero occurrences em código active (domain-model + agent-spec
			+ governance + structural-check active references).

			Schema satisfaction verified:
			- ADR-087 schema #ADR conforme (id + title + date +
			  decisionClass + decider + status + context + decision +
			  consequences + reversibility + blastRadius +
			  affectedArtifacts + plannedOutputs + principlesApplied +
			  rationale)
			- principlesApplied refs valid (P0 + adr-040 + adr-086)
			- reversibility=high (atomic string rename) + blastRadius=
			  local (4 files BDG context)
			- decisionClass=structural (semantic change per CLAUDE.md
			  "Na dúvida... é semântica")

			cue vet ./... EXIT=0; cue vet -c ./... EXIT=0.

			Cascade complete: WI-084 (BDG structural-check forward) →
			WI-085 (rename semantic correction). Loop closed antes de
			IDC/NPM Tier 3 authoring.
			"""
	}]

	findings: {}

	summary: """
		ADR-087 — Semantic correction (NOT cosmetic refactor) renomeando
		BDG invariant code de 'inv-commitment-id-uniqueness-per-cost-
		center' → 'inv-commitment-id-global-uniqueness-active'.

		Decisão arquitetural: rename é semantic correction porque
		canonical name antigo sugeria 'per-cost-center' scope enquanto
		rule body domain-model + aggregate guard runtime + assertion
		structural-check sc-bdg-07 já operavam GLOBALLY. CommitmentId
		é CMT-issued canonical id; unicidade econômica transversal.
		Novo nome alinha canonical com semantic real.

		Behavior change: ZERO. Rename é alignment exclusivamente.

		Discipline preserved:
		- **Semantic correction explicit** (per founder ajuste #1) —
		  distinção clara de cosmetic refactor
		- **Single canonical name post-rename** (per founder ajuste #2)
		  — NÃO há dual canonical em código active; alias histórico
		  preserved APENAS em rationale/migration note + SRRs históricas

		Atomic update across 4 files (mesmo commit) preserving:
		- domain-model BDG (canonical source)
		- agent-spec BDG (invariants protected + preconditions
		  narrative + rationale)
		- governance envelope BDG (promotion criteria metric)
		- structural-check sc-bdg-07 (invariantId + rationale cleanup
		  referencing ADR-087)

		Cascade DISCAP: WI-084 BDG structural-check (sc-bdg-07
		identified mismatch via founder dialectic) → WI-085 rename
		semantic correction (ADR-087 closes loop). Cleanup antes de
		IDC/NPM Tier 3 authoring evita cementar mismatch com mais
		references downstream.

		Pattern reusable: 'inv-<entity>-global-uniqueness-active' como
		naming convention para futuro BC com global uniqueness pattern.
		"""
}
