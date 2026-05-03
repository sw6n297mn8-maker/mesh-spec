package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr063: build_time.#SelfReviewReport & {
	reportId: "srr-adr-063"

	artifactPath:       "architecture/adrs/adr-063-add-filesystem-path-exists-kind-to-structural-check.cue"
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
		summary:   "ADR documenta extensão do framework #StructuralCheck com kind 'filesystem-path-exists' (5 → 6 kinds). Pattern paralelo a adr-049 (conditional-file-presence) e adr-056 (production-guide-coverage). Aplicação imediata: 4 structural-checks novos no MESMO commit (sc-srr-01, sc-te-01, sc-pg-02, sc-pg-03 — últimos 2 usando same-artifact-consistency existente). 4 alternativas explicitamente rejeitadas. Primeira ADR pós-adr-062 a usar field defersTo (lista def-002 + def-003 — formaliza dois deferimentos via novo sistema). 3 known gaps declarados em prose (sc-adr-affectedArtifacts, sc-aa-artifact, sc-te-tensionTarget) — NÃO viram def-XXX agora porque critério de revisita não está claro o suficiente (founder decision sessão 2026-05-03 ajuste 2). principlesApplied: P0, P1, P10, P12. decisionClass=structural, reversibility=high, blastRadius=cross-artifact. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "ADR-063 adiciona filesystem-path-exists kind + materializa 4 structural-checks + formaliza 2 deferimentos (def-002, def-003) + 3 known gaps em prose. Primeira ADR pós-adr-062 usando defersTo field."

	singleRoundRationale: "Pattern bem-estabelecido (3º extension de structural-check kind, precedentes adr-049/056). Founder explicitly approved retomar Opção B com 2 ajustes aplicados. Round único suficiente."
}
