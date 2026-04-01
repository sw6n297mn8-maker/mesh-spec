package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr035: artifact_schemas.#ADR & {
	id:    "adr-035"
	title: "Create #DomainModel artifact schema for DDD tactical design"
	date:  "2026-04-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Após instanciar o primeiro BC canvas (CMT), o próximo artefato
		tático necessário é o domain model — building blocks DDD formalizados
		(events, commands, invariants, value objects, aggregates, entities,
		policies, domain services, projections, lifecycle). Sem schema,
		instâncias de domain model não têm contrato de conformidade e
		integridade referencial entre building blocks não é validável.
		Alternativa considerada: domain model como texto livre ou seção
		do canvas — rejeitada porque perderia integridade referencial
		entre building blocks, type-safety por prefixo e alinhamento
		cross-artifact validável por runner.
		"""

	decision: """
		Criar #DomainModel em architecture/artifact-schemas/domain-model.cue
		com: (1) behavior-first ordering (events → commands → invariants →
		VOs → aggregates); (2) aggregates como wiring layer (handlesCommands,
		emitsEvents, protectsInvariants); (3) prefixed refs por catálogo
		(evt-, cmd-, inv-, vo-, agg-, mod-, svc-, pol-, prj-, ent-, qry-)
		para type-safety por regex; (4) #DomainEvent como union discriminada
		por visibility — internal (sourceContext permitido para traduções
		ACL) e published (sourceContext proibido — evento nasce neste BC);
		(5) sourceContext tipado como #SourceContextRef (aceita BCs internos
		e ext-*) alinhado com #ContextOrSystemRef do canvas; (6) #DomainField
		e #IdentityType como unions discriminados (primitive/value-object-ref/
		domain-type); (7) lifecycle como state machine com transitions
		referenciando commands, events e guards; (8) policies como automação
		event → command; (9) projections com queryCapabilities; (10) 16
		quality criteria cobrindo integridade referencial interna (tq-dm-01
		a tq-dm-10, tq-dm-13, tq-dm-14), alinhamento cross-artifact com
		canvas (tq-dm-11, tq-dm-12, tq-dm-15, tq-dm-16) e consistência
		de lifecycle (tq-dm-07, tq-dm-08). Adicionar "domain-model" a
		#ArtifactType em quality-criteria.cue.
		"""

	consequences: """
		Positivas: (1) Instâncias de domain model têm contrato de
		conformidade validável por cue vet. (2) Integridade referencial
		interna (commands→aggregates, events→aggregates, invariants→
		aggregates, VOs→aggregates, policies→events/commands) é enforced
		por 14 quality criteria. (3) Alinhamento canvas↔domain model
		validável por runner para published events (tq-dm-11), commands
		(tq-dm-12), event-consumers (tq-dm-15) e query-surfaces
		(tq-dm-16). (4) Prefixed refs eliminam refs cross-type por
		construção — cmd-* nunca unifica com evt-*. (5) #SourceContextRef
		aceita BCs internos e sistemas externos (ext-*), alinhado com
		#ContextOrSystemRef do canvas. (6) Union discriminada em
		#DomainEvent torna estado inválido (published + sourceContext)
		irrepresentável.
		Negativas: (1) Schema complexo com 16 quality criteria aumenta
		custo de self-review por instância. (2) #BoundedContextRef
		redefinido com mesma regex de context-map.cue — unifica em CUE
		mas é duplicação declarativa consciente para legibilidade local.
		(3) Saga/Process Manager não tem building block first-class —
		limitação documentada no header comment.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/domain-model.cue",
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P3",
		"P10",
	]

	rationale: """
		Domain model schema é estruturante para todos os BCs — sem ele,
		building blocks táticos não têm contrato validável. Behavior-first
		ordering ancora em P3 (Event Log como SoT de fatos). Lifecycle
		com guards ancora em P10 (gates determinísticos). Prefixed refs
		ancora em P1 (CUE como SoT, type-safety por construção).
		#SourceContextRef aceita ext-* para coerência com canvas e
		context map. Union discriminada em #DomainEvent torna published
		+ sourceContext irrepresentável — estado inválido eliminado por
		construção. Reversibility high porque não há instâncias commitadas
		nem dados persistidos. blastRadius cross-artifact porque quality
		criteria validam contra canvas e #ArtifactType é expandido em
		quality-criteria.cue.
		"""
}
