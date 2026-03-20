package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr012: artifact_schemas.#ADR & {
	id:            "adr-012"
	title:         "Analytical lens schema for agent reasoning"
	date:          "2026-03-19"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		CLAUDE.md define que lenses analíticas orientam raciocínio de agentes
		para decisões não-triviais. O diretório architecture/lenses/ é o
		destino canônico para instâncias, mas não existia schema formal em
		artifact-schemas/ para validar estrutura, critérios de ativação,
		protocolo de raciocínio e relações entre lenses.
		"""

	decision: """
		Criar architecture/artifact-schemas/lens.cue com #AnalyticalLens
		como schema principal. O schema inclui tipos auxiliares
		(#LensConcept, #ReasoningStep, #LensExample, #LensRelation,
		#LensLimitation), constraints de unicidade de concept IDs,
		validação de dependsOn intra-lens, e _qualityCriteria colocados
		no próprio schema conforme ADR-010. Alternativa considerada:
		schema mínimo sem protocolo de raciocínio formalizado —
		rejeitada porque o valor da lens está precisamente na sequência
		estruturada de perguntas que guia o agente.
		"""

	consequences: """
		Positivas: lenses validáveis por cue vet, estrutura consistente
		entre lenses, e base formal para CI validar dependências internas
		e referências cruzadas.
		Negativas: o schema introduz overhead mínimo de modelagem
		(purpose, trigger, concepts, reasoningProtocol, meshExamples,
		limitations), o que aumenta o custo de criação de novas lenses.
		Esse custo é intencional: evita lentes vagas, redundantes ou
		inoperáveis para agentes.
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/lens.cue",
	]

	principlesApplied: ["P0", "P12"]

	rationale: """
		P0: sem schema, cada lens tenderia a inventar formato próprio,
		criando drift estrutural e reduzindo reuso.
		P12: lenses são governança de raciocínio; precisam existir como
		artefatos formais, validáveis e consumíveis por agentes, não como
		convenção textual solta.
		"""
}
