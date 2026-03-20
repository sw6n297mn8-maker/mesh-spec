package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr011: artifact_schemas.#ADR & {
	id:            "adr-011"
	title:         "Quality criteria types owned by artifact-schemas package"
	date:          "2026-03-19"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		ADR-010 decidiu colocar _qualityCriteria em cada artifact schema.
		A implementação inicial definia #Severity, #QualityCriterion e
		#QualityCriteria em governance/build-time/quality-gate.cue (package
		build_time). Isso forçava cada schema em artifact_schemas a importar
		build_time — direção inversa à natural (governance consome schemas,
		não o contrário). O acoplamento bidirecional conceitual fecharia
		opções futuras se quality-gate.cue precisasse importar tipos de
		artifact_schemas.
		"""

	decision: """
		Mover #Severity, #QualityCriterion e #QualityCriteria para
		architecture/artifact-schemas/quality-criteria.cue no package
		artifact_schemas. quality-gate.cue passa a importar esses tipos
		de artifact_schemas. Cada schema usa os tipos do próprio package
		sem import cross-package. Alternativa considerada: manter em
		build_time e aceitar o acoplamento — rejeitada porque viola a
		direção natural de dependência e fecha opções de evolução
		(e.g., quality-gate importar artifact_schemas para introspecção
		de schemas).
		"""

	consequences: """
		Positivas: direção de dependência correta (governance → schemas),
		schemas sem import externo, extensibilidade preservada.
		Negativas: quality-gate.cue agora importa artifact_schemas,
		adicionando uma dependência explícita. Tipos de qualidade
		ficam em package que não é exclusivamente sobre qualidade.
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"governance/build-time/quality-gate.cue",
	]

	principlesApplied: ["P0", "P12"]

	rationale: """
		P0: cada tipo tem exatamente uma localização canônica — no package
		que o consome primariamente (artifact_schemas).
		P12: direção de dependência é decisão de governança que afeta
		toda evolução futura do sistema de qualidade.
		"""
}
