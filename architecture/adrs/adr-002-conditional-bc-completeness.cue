package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr002: artifact_schemas.#ADR & {
	id:    "adr-002"
	title: "Completude condicional de BCs com canvas como rootArtifact"
	date:  "2026-03-15"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Definir quais artefatos um Bounded Context precisa ter para ser
		considerado estruturalmente completo. Uma regra fixa (todo BC precisa
		de tudo) seria prematura para BCs em estágios diferentes de maturidade.
		"""

	decision: """
		Completude é condicional: regras de presença (CompletionRule) são
		avaliadas contra campos do canvas do BC. Canvas é rootArtifact com
		mustExist: true. Se canvas não existe, completeness evaluation é
		bloqueada (absentPolicy: block-completeness-evaluation). Cada regra
		declara uma condition avaliável contra o canvas e um presencePolicy
		(required | forbidden).
		"""

	consequences: """
		Positivas: BCs podem evoluir incrementalmente sem violar completude;
		regras são declarativas e auditáveis; canvas se torna ponto focal
		natural de maturidade do BC.
		Negativas: dependência forte no schema do canvas — mudança em campos
		usados em conditions exige revisão das regras de completude.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/bounded-context-completeness.cue",
	]

	principlesApplied: [
		"P1",
		"P12",
	]

	rationale: "Decisão retroativa. Registra o modelo condicional de completude que evita regras rígidas prematuras enquanto mantém governança verificável."
}
