package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr001: artifact_schemas.#ADR & {
	id:    "adr-001"
	title: "Adoção de governança type-centric para estrutura do repositório"
	date:  "2026-03-15"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	context: """
		O repositório precisava de um modelo de governança estrutural que não
		dependesse de um arquivo central monolítico (repo-structure.cue como
		single point of failure). A alternativa era distribuir a responsabilidade
		de localização para os próprios artifact schemas, mantendo repo-structure.cue
		apenas como escopo de validação e algoritmo de classificação.
		"""

	decision: """
		Adotar modelo type-centric: cada artifact schema declara sua própria
		localização via _schema.location (canonicalPathRegex, fileNameRegex,
		cardinality, allowNested). repo-structure.cue governa escopo de
		validação e algoritmo de classificação, não localização de tipos.
		bounded-context-completeness.cue governa presença condicional de
		artefatos por BC, usando canvas como rootArtifact com mustExist e
		conditions avaliadas contra seus campos.
		"""

	consequences: """
		Positivas: adicionar novo artifact type não exige editar repo-structure.cue;
		schemas são auto-contidos; CI pode descobrir tipos dinamicamente.
		Negativas: schemas precisam manter _schema.location consistente;
		canonicalPathRegex precisa ser unambíguo entre schemas (CI valida
		exclusive-schema-match).
		"""

	reversibility: "low"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"governance/repo-structure.cue",
		"architecture/artifact-schemas/domain-definition.cue",
		"governance/bounded-context-completeness.cue",
	]

	principlesApplied: [
		"P0",
		"P12",
	]

	rationale: "Decisão retroativa. Registra a escolha fundacional de governança distribuída que moldou a estrutura do repositório desde o commit 9c0a6b8."
}
