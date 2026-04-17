package governance

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adopted-artifacts.cue — Primeiro manifest de adoção cross-repo de mesh-spec.
//
// Registra artefatos copiados de tekton-spec (portfolio de governança)
// com double-anchor version+commit per ADR-002 (tekton-spec). Base da
// adoção formal de #ReadmeConfig instituída por adr-050.
//
// Futuras adoções (outros schemas portfolio-wide) serão appendadas a
// esta lista. Target de longo prazo: manifest compacto cobrindo apenas
// adoções ativas.

adoptedArtifacts: artifact_schemas.#AdoptedArtifactsManifest & {
	repoId:      "sw6n297mn8-maker/mesh-spec"
	lastUpdated: "2026-04-17"

	artifacts: [{
		artifact:         "architecture/artifact-schemas/adopted-artifacts.cue"
		sourceRepo:       "sw6n297mn8-maker/tekton-spec"
		sourcePath:       "portfolio/artifact-schemas/adopted-artifacts.cue"
		sourceVersion:    "0.2.0"
		sourceCommitHash: "7151c925654f249346d1f796cb64f40e9bfa28a2"
		localContentHash: "sha256:318f9d76b879b62f4df87da956741832e78f7aa4284e5f2247f3671eb922d198"
		adoptionMode:     "verbatim"
		adoptedAt:        "2026-04-16"
	}, {
		artifact:         "architecture/artifact-schemas/readme-config.cue"
		sourceRepo:       "sw6n297mn8-maker/tekton-spec"
		sourcePath:       "portfolio/artifact-schemas/readme-config.cue"
		sourceVersion:    "0.2.0"
		sourceCommitHash: "7151c925654f249346d1f796cb64f40e9bfa28a2"
		localContentHash: "sha256:0734a8f705dfa7ca048162845aa76cd5afdc1d47a6f080c5d0e1c0ce60ec69ac"
		adoptionMode:     "verbatim"
		adoptedAt:        "2026-04-16"
	}, {
		artifact:         "architecture/artifact-schemas/repo-structure.cue"
		sourceRepo:       "sw6n297mn8-maker/tekton-spec"
		sourcePath:       "portfolio/artifact-schemas/repo-structure.cue"
		sourceVersion:    "0.3.0"
		sourceCommitHash: "2266455739bc6a1c0f06f949ae16d38df0053f47"
		localContentHash: "sha256:fcf0c5a91f323249583c8b9c2abdd51501afd7c2c03b658ed5153d2da3e107f9"
		adoptionMode:     "verbatim"
		adoptedAt:        "2026-04-17"
	}]
}
