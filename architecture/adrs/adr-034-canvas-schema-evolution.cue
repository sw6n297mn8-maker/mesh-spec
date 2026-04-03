package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr034: artifact_schemas.#ADR & {
	id:    "adr-034"
	title: "Evolve #Canvas schema: communication, ownership, domain roles, external identity"
	date:  "2026-04-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O schema #Canvas existente cobria identidade mínima do BC: purpose,
		classification (via shared-types), capabilities com flags, stakeholders,
		costsEliminated e incentiveAnalysis. Durante planejamento do primeiro
		canvas (CMT), identificaram-se gaps: (1) sem perspectiva interna de
		comunicação — o canvas não declarava o que entra e sai do BC; (2) sem
		domain roles (archetypes) — agentes não sabiam se o BC é executor,
		gateway ou analítico; (3) sem ownership/governance — domainAgentSpec
		vivia apenas no context map sem SoT local, sem boundaries de autonomia;
		(4) sem estado epistêmico — assumptions e open questions não tinham
		onde viver; (5) sem identidade canônica para sistemas externos —
		#ContextOrSystemRef no canvas não podia ser validado contra o context
		map porque #ExternalEndpoint não tinha code. (6) hasDomainAgents era
		redundante — todo BC na Mesh tem domain agent. Alternativa considerada:
		manter canvas mínimo e documentar comunicação em artefatos separados
		por BC — rejeitada porque fragmentaria a identidade do BC e violaria
		o princípio de canvas como rootArtifact.
		"""

	decision: """
		Evoluir #Canvas com: (1) #BCCommunication como union discriminado
		com 6 subtipos (3 inbound + 3 outbound), interactionMode nos
		commands, refs tipados via #ContextOrSystemRef; (2) #DomainRoles
		com 6 archetypes (analysis, draft, execution, gateway, specification,
		engagement); (3) #BCOwnership com domainAgentSpec como SoT local e
		#GovernanceScope com autonomous/supervised/escalation; (4) #Assumption
		com invalidationSignal e #OpenQuestion com deadline tipado como data;
		(5) #VerificationMetric; (6) #BusinessDecision; (7) #BCClassification
		inline com businessRole e wardleyEvolution (sem dependência de
		shared-types); (8) costsEliminated opcional (runner enforça para
		core/supporting); (9) ubiquitousLanguageRef com regex canônica;
		(10) capabilityRef regex ampliada para cc-[0-9]+; (11) hasDomainAgents
		removido; (12) 12 quality criteria (vs 4). Adicionalmente, evoluir
		#ExternalEndpoint no context-map schema com campo code:
		#ExternalSystemRef (regex ext-*) para identidade canônica de
		sistemas externos, permitindo validação robusta de tq-cv-12.
		#GovernanceScope usa listas tipadas com MinItems(1) quando presentes;
		enforcement de ao menos um bloco via tq-cv-07.
		"""

	consequences: """
		Positivas: (1) Canvas torna-se documento de identidade completo —
		comunicação, governance, estado epistêmico num só lugar. (2) Domain
		agents têm boundaries de autonomia explícitas. (3) Sistemas externos
		têm identidade canônica validável cross-artifact. (4) 12 quality
		criteria cobrem contorno, rastreabilidade, alinhamento econômico,
		identidade operacional, completude condicional e estado epistêmico.
		Negativas: (1) Schema significativamente mais complexo — requer
		mais preenchimento por canvas. (2) Dependência cruzada canvas↔context-map
		via #ContextOrSystemRef — runner deve validar consistência. (3)
		#BCClassification inline duplica conceitos de shared-types — decisão
		consciente para evitar dependência e adicionar businessRole.
		(4) #GovernanceScope não impõe ao menos um bloco por CUE nativo —
		enforcement via quality criterion.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/canvas.cue",
		"architecture/artifact-schemas/context-map.cue",
	]

	derivedArtifacts: [
		"governance/build-time/self-reviews/canvas.self-review.cue",
		"governance/build-time/self-reviews/context-map.self-review.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"dp-08",
		"dp-10",
	]

	rationale: """
		Canvas evolui de identidade mínima para documento raiz completo,
		motivado por necessidade concreta de instanciar o primeiro BC (CMT).
		Communication discriminada resolve o gap de perspectiva interna.
		Ownership com governanceScope resolve o gap de boundaries para
		domain agents (dp-10). #ExternalSystemRef resolve a impossibilidade
		de validar refs a sistemas externos. Cada adição resolve gap real
		identificado durante planejamento — nenhuma é especulativa.
		Reversibility high porque não há canvases commitados nem dados
		persistidos. blastRadius cross-artifact porque afeta canvas schema,
		context-map schema e futuros canvases.
		"""
}
