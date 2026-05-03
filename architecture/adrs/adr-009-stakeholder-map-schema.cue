package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr009: artifact_schemas.#ADR & {
	id:    "adr-009"
	title: "Stakeholder map schema and stub instance"
	date:  "2026-03-18"

	decisionClass: "structural"
	decider:       "founder"

	status: "accepted"

	context: """
		domain-definition.cue referencia stakeholderMapRef: "domain/stakeholder-map.cue",
		mas o artefato não existia. O schema em artifact-schemas/ também não existia.
		Sem ambos, domain-definition.cue não passa na validação de CI (referência
		a artefato inexistente). Adicionalmente, todos os futuros arquivos em
		domain/ (package domain) precisam de convenção de namespacing para evitar
		colisão de campos top-level na unificação CUE.
		"""

	decision: """
		1. Criar schema #StakeholderMap em architecture/artifact-schemas/stakeholder-map.cue
		   com #StakeholderType incluindo "agent" como tipo distinto de "system"
		   (coerência com ax-01/ax-02). #Stakeholder inclui role, meshInteraction,
		   influence, concerns e interactsWith para suportar análise de stakeholders.
		   ID de stakeholder fechado por pattern (^sh-[0-9]{2}$).
		2. Criar instância stub em domain/stakeholder-map.cue com 5 stakeholders
		   fundamentais (construtora, fornecedor, instituição financeira, Bacen,
		   agente de IA).
		3. Estabelecer convenção de namespacing para package domain: cada arquivo
		   encapsula seu conteúdo sob chave top-level única (stakeholderMap,
		   domainDefinition, businessModel, etc.) para evitar colisão na
		   unificação CUE.
		"""

	consequences: """
		Positivas: domain-definition.cue passa validação de referência cruzada.
		Convenção de namespacing previne colisões em domain/ para todos os
		arquivos futuros. Tipo "agent" no schema reflete distinção fundacional
		da Mesh entre agentes de IA e sistemas convencionais.
		Negativas: overhead de schema para artefato que pode expandir
		significativamente. Aceitável porque a estrutura mínima não impede
		evolução e campos opcionais (interactsWith) permitem crescimento
		incremental.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: []

	plannedOutputs: [
		"architecture/artifact-schemas/stakeholder-map.cue",
		"domain/stakeholder-map.cue",
	]

	principlesApplied: ["P0", "P1"]

	rationale: "Desbloqueia commit de domain-definition.cue e estabelece padrão de namespacing que previne defeito estrutural em toda a camada domain/."
}
