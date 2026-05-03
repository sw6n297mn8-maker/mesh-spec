package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr064: build_time.#SelfReviewReport & {
	reportId: "srr-adr-064"

	artifactPath:       "architecture/adrs/adr-064-add-directory-pair-coverage-kind-and-work-governance-type.cue"
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
		summary:   "ADR documenta extensão dupla acoplada: (1) #ArtifactType += 'work-governance' (abreviação 'wg'); (2) #StructuralCheck += kind 'directory-pair-coverage' (4ª extension após adr-049/056/063). Aplicação imediata: sc-wg-01 instance no MESMO commit (pattern adr-056). 5 alternativas explicitamente rejeitadas (generic glob-pair; estender CFP; usar filesystem-path-exists; artifactType=task-template; manual-only). Founder feedback explícito incorporado: artifactType=work-governance vs task-template (anti-poluição semântica). Motivação concreta: bug WI-033 (commit c9b584c 2026-04-02) — work-event sem task-spec por ~5 semanas. 3 known gaps em prose (bidirectional não exercitado; sequencing não enforced; work-governance NÃO em sc-pg-01 coveredSchemas porque work-events são append-only mecanicamente authored). principlesApplied: P0, P1, P10, P12. decisionClass=structural, reversibility=high, blastRadius=cross-artifact. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "ADR-064 adiciona work-governance type + directory-pair-coverage kind + sc-wg-01 instance. Pattern paralelo adr-049/056/063 (kind extension) + adr-061 (type extension). Sistemic fix do bug WI-033."

	singleRoundRationale: "Pattern bem-estabelecido (4º extension de structural-check kind, 2º extension de #ArtifactType nesta sessão). Founder feedback explícito sobre artifactType incorporado. Round único suficiente."
}
