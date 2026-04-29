package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-053 — Adoção universal de #ProductionGuide com phasing.
//
// PARTIAL — commit 1 da sequência (scaffold).
// Metadata estrutural completa (id, title, date, decisionClass, decider,
// status, reversibility, blastRadius, affectedArtifacts, derivedArtifacts,
// principlesApplied). context, decision, consequences e rationale com
// placeholders TBD a serem substituídos em commits 2 e 3.

adr053: artifact_schemas.#ADR & {
	id:    "adr-053"
	title: "Adopt #ProductionGuide with universal coverage rule and phased rollout"
	date:  "2026-04-27"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context:      "TBD — context substantivo em commit 2 da sequência."
	decision:     "TBD — decision substantivo em commit 2 da sequência."
	consequences: "TBD — consequences substantivo em commit 3 da sequência."

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/production-guide.cue",
		"architecture/production-guides/production-guide.cue",
		"governance/adopted-artifacts.cue",
		"governance/readme/config.cue",
	]

	derivedArtifacts: [
		"README.md",
	]

	principlesApplied: [
		"P0",
		"P10",
		"P12",
	]

	rationale: "TBD — rationale substantivo em commit 3 da sequência."
}
