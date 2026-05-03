package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr036: artifact_schemas.#ADR & {
	id:    "adr-036"
	title: "Create #Glossary artifact schema for Ubiquitous Language"
	date:  "2026-04-02"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Canvas CMT referencia glossário via ubiquitousLanguageRef mas não
		existe schema para validar instâncias de glossário. Sem schema,
		termos da Ubiquitous Language não têm contrato de conformidade,
		bilingual mapping não é governado, e integridade referencial
		(termos → building blocks do domain model) não é validável.
		Lens domain-language-and-terminology-design recomenda glossário
		como SoT da UL com bilingual mapping, cross-layer mapping e
		rejected alternatives. Alternativa considerada: termos como
		seção do canvas — rejeitada porque perderia granularidade de
		campos por termo (category, antiTerms, examples, domainModelRefs)
		e o canvas ficaria excessivamente grande.
		"""

	decision: """
		Criar #Glossary em architecture/artifact-schemas/glossary.cue com:
		(1) bilingual mapping obrigatório (termEn) para code generation —
		regex disciplinada impede trailing spaces e hyphens;
		(2) cross-layer mapping opcional e lightweight (codeTerm, apiTerm,
		uiLabel) — evento de domínio excluído para não competir com
		domain-model.cue como SoT de building blocks;
		(3) rejected alternatives documentam seleção deliberada de termos,
		complementar a antiTerms (o que NÃO é vs. nomes rejeitados);
		(4) 10 categorias de termo (#TermCategory) mapeando para building
		blocks DDD (entity, value, process, role, rule, event, command,
		metric, document, classification);
		(5) #DomainModelRef com 11 prefixos canônicos do domain-model.cue;
		(6) regex estrita em term codes (^term-[a-z][a-z0-9]*(-[a-z0-9]+)*$)
		impede trailing hyphens — mais rigorosa que demais schemas do package;
		(7) 13 quality criteria cobrindo integridade referencial interna
		(tq-gl-01/02/08), unicidade de identidade e naming (tq-gl-12/13),
		rastreabilidade ao domain model (tq-gl-03/04), qualidade semântica
		(tq-gl-05/06/09), qualidade bilíngue (tq-gl-11), alinhamento
		cross-artifact com canvas (tq-gl-07) e consistência cross-layer
		(tq-gl-10).
		Adicionar "glossary" a #ArtifactType em quality-criteria.cue.
		"""

	consequences: """
		Positivas: (1) Instâncias de glossário têm contrato de conformidade
		validável por cue vet. (2) Bilingual mapping (termEn) habilita code
		generation governada — agentes consultam termEn para nomear classes
		e endpoints. (3) Integridade referencial glossário→domain model
		validável por runner via #DomainModelRef. (4) Rejected alternatives
		formalizam seleção terminológica como decisão de design rastreável.
		(5) Cross-layer mapping lightweight conecta UL a código/API/UI sem
		competir com domain model. (6) 13 quality criteria cobrem desde
		unicidade até alinhamento cross-artifact com canvas.
		Negativas: (1) #BoundedContextRef e #NonEmptyString redefinidos com
		mesma regex/tipo de context-map.cue e lens.cue — unifica em CUE
		mas é duplicação declarativa para legibilidade local.
		(2) #DomainModelRef mantém trailing hyphens por consistência com
		domain-model.cue — documentado como limitação. (3) Normalização
		de synonyms (case, duplicatas, espaços) é responsabilidade do
		runner, não do schema.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/glossary.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
	]

	rationale: """
		Glossary schema é estruturante para a UL de todos os BCs — sem ele,
		termos de domínio não têm contrato validável e agentes nomeiam
		conceitos ad hoc. SoT da UL ancora em P1 (CUE como SoT). Seleção
		deliberada de termos (rejected alternatives) ancora em P0 (cada
		decisão de design é registrada). Lens domain-language informou
		bilingual mapping, cross-layer mapping e rejected alternatives.
		Reversibility high porque não há instâncias commitadas nem dados
		persistidos. blastRadius cross-artifact porque quality criteria
		validam contra canvas (tq-gl-07) e domain model (tq-gl-03/04),
		e #ArtifactType é expandido em quality-criteria.cue.
		"""
}
