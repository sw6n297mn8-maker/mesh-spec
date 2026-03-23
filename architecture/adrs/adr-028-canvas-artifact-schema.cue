package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr028: artifact_schemas.#ADR & {
	id:    "adr-028"
	title: "Canvas artifact schema — estrutura formal do Bounded Context Canvas"
	date:  "2026-03-23"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O canvas é o rootArtifact do sistema de completude de BCs
		(bounded-context-completeness.cue). Regras de completude avaliam
		campos do canvas (classification, capabilities) para determinar
		presença obrigatória de artefatos. Entretanto, o schema formal
		#Canvas não existe em architecture/artifact-schemas/ — não há
		validação de conformidade por CI, e a estrutura do canvas depende
		de convenção implícita. A alternativa — continuar sem schema —
		foi rejeitada porque viola P0 (single source of truth para a
		estrutura) e P12 (governança como código).
		"""

	decision: """
		Criar architecture/artifact-schemas/canvas.cue com #Canvas
		definindo: id, name, purpose, classification (#BCClassification),
		capabilities (operational: [#OperationalCapability] com capabilityRef
		para cc-NN + flags de completude), stakeholders: [#CanvasStakeholder]
		com stakeholderRef para sh-NN, costsEliminated:
		[#CanvasCostContribution] com costRef para ce-NN,
		ubiquitousLanguageRef, incentiveAnalysis com #IncentiveParticipant
		por stakeholder (manipulationCost + vsBenefit, alinhado com dp-08).
		Referências cruzadas validadas por CI. Quality criteria com prefixo
		tq-cv-NN cobrindo contorno, rastreabilidade e alinhamento econômico.
		"""

	consequences: """
		Positivas: CI pode validar conformidade de todo canvas.cue
		via cue vet; campos referenciados por completude têm tipos
		garantidos; referências cruzadas a sh-NN e ce-NN são
		estruturalmente validáveis; incentive analysis tem estrutura
		que espelha dp-08 com precisão semântica.
		Negativas: canvas.cue de BCs futuros precisarão conformar
		com o schema. Custo aceitável — nenhum BC foi criado ainda.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/canvas.cue",
		"governance/bounded-context-completeness.cue",
	]

	principlesApplied: [
		"P0",
		"P12",
	]

	rationale: """
		Canvas é o pivô de governança contextual — todo o sistema de
		completude depende de seus campos. Schema formal é a extensão
		natural de P0 (estrutura canônica, não convenção) e P12
		(validação por CI, não por memória do agente). Tipos com
		referências cruzadas (#CanvasStakeholder → sh-NN,
		#CanvasCostContribution → ce-NN, #IncentiveParticipant → sh-NN)
		garantem rastreabilidade entre canvas e artefatos fundacionais
		do domínio. Sem schema, a estrutura do canvas é contrato social;
		com schema, é contrato verificável.
		"""
}
