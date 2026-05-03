package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr010: artifact_schemas.#ADR & {
	id:            "adr-010"
	title:         "Colocate type-specific quality criteria with artifact schemas"
	date:          "2026-03-18"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		quality-gate.cue centralizava critérios de qualidade type-specific
		no bloco selfReviewProtocol.typeSpecific. Com 8 tipos registrados
		(adr, canvas, domain-definition, lens, artifact-schema,
		stakeholder-map, task-template, wave-plan), o migrationTrigger
		definido no próprio artefato foi atingido ('8+ entries em
		typeSpecific'). Centralização acima desse volume aumenta risco
		de drift: quem edita um schema não vê os critérios de qualidade
		que o validam, e vice-versa.
		"""

	decision: """
		Migrar critérios type-specific de selfReviewProtocol.typeSpecific
		para campo _qualityCriteria em cada artifact schema correspondente
		em architecture/artifact-schemas/<tipo>.cue. quality-gate.cue
		retém universalCriteria, definições de tipos reutilizáveis
		(#QualityCriterion, #QualityCriteria), protocolo operacional
		(severityPolicy, transparency, criteriaResolution) e migrationRecord.
		O agente resolve critérios em runtime: universal
		(quality-gate.cue) + type-specific (schema do tipo).
		"""

	consequences: """
		Positivas: colocação correta, menor drift, extensibilidade local
		por tipo e simplificação de quality-gate.cue como protocolo
		transversal. Negativas: critérios ficam distribuídos por múltiplos
		schemas, visão consolidada exige leitura de mais arquivos, e o
		agente precisa carregar o schema do tipo no self-review.
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/adr.cue",
		"architecture/artifact-schemas/domain-definition.cue",
		"architecture/artifact-schemas/stakeholder-map.cue",
		"architecture/artifact-schemas/task-template.cue",
		"architecture/artifact-schemas/wave-plan.cue",
	]

	plannedOutputs: [
		"governance/build-time/quality-gate.cue",
	]

	principlesApplied: ["P0", "P12"]

	rationale: """
		P0: critérios colocados com o schema reduzem duplicação implícita
		entre o contrato estrutural e a validação de qualidade.
		P12: critérios como campo estruturado no schema são governança
		como código, não convenção textual dispersa.
		"""
}
