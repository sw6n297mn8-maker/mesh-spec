package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr033: artifact_schemas.#ADR & {
	id:    "adr-033"
	title: "Evolve #ContextMap schema: typed endpoints, external relationships, flow payload"
	date:  "2026-03-31"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O schema #ContextMap original (adr não registrado, bootstrap) suportava
		apenas 8 variantes de relacionamento interno com referências por string
		(upstream/downstream). Durante a construção da instância (strategic/context-map.cue
		com 21 BCs e 31 relações), identificaram-se limitações: (1) sem suporte a
		relacionamentos com sistemas externos; (2) endpoints não tipados impedem
		validação de que source/target existem nos contexts declarados; (3) sem
		FlowPayload (events/commands/queries) — data flows ficavam implícitos;
		(4) publishedLanguage não era enforced por variante — variantes OHS-PL
		podiam omitir o campo; (5) sem FeedbackLoop para capturar loops bidirecionais;
		(6) ContextEntry limitado a context+subdomains, sem classificação estratégica.
		Alternativa considerada: manter schema simples e documentar em texto livre —
		rejeitada porque viola P1 (schemas CUE são SoT de contratos) e impede
		validação por CI.
		"""

	decision: """
		Evoluir #ContextMap de 8 para 23 variantes de relacionamento: 11 internas
		+ 6 external inbound + 6 external outbound. Mudanças estruturais:
		(1) #RelationshipEndpoint como união #ContextEndpoint | #ExternalEndpoint
		com tipagem por kind; (2) campo direction explícito; (3) #FlowPayload
		com events/commands/queries tipados como [...string]; (4) publishedLanguage
		enforced (obrigatório) em variantes OHS-PL e proibido (_|_) nas demais;
		(5) #FeedbackLoop como união discriminada por exists; (6) #ContextEntry
		expandido com subdomainType, wardleyEvolution, domainAgentSpec, rationale;
		(7) #DomainLevelTransversal para shared kernels de domínio;
		(8) #CommunicationPattern mudado de mode (events/request-reply/mixed)
		para type (sync/async/hybrid); (9) 14 quality criteria específicos;
		(10) expectedContexts e declaredFlows como hooks de unificação.
		Enums de padrão separados por direção: #UpstreamPattern,
		#DownstreamPattern, #SymmetricPattern, #ExternalUpstreamPattern,
		#ExternalDownstreamPattern, etc.
		"""

	consequences: """
		Positivas: (1) Relacionamentos são autovalidados — endpoints tipados
		garantem que source/target referenciam contexts declarados ou sistemas
		externos nomeados. (2) Data flows explícitos via FlowPayload permitem
		rastreabilidade de eventos cross-BC por CI. (3) publishedLanguage
		enforced elimina classe de omissão em variantes OHS-PL. (4) FeedbackLoop
		captura loops bidirecionais com referência cruzada verificável.
		(5) ContextEntry expandido permite análise estratégica (Wardley, subdomain
		type) diretamente no context map. (6) 14 quality criteria garantem
		completude e consistência da instância.
		Negativas: (1) Schema significativamente mais complexo — 23 variantes
		vs 8 aumenta superfície de manutenção. (2) Instâncias existentes do
		schema anterior são incompatíveis — migração manual necessária (instância strategic/context-map.cue
		foi construída já no schema evoluído, então impacto de migração é zero). (3) External
		relationships introduzem #ExternalEndpoint que não é validável contra
		contexts[] — consistência depende de quality criteria, não de CUE nativo.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/context-map.cue",
	]

	derivedArtifacts: [
		"governance/build-time/self-reviews/context-map.self-review.cue",
		"strategic/context-map.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"dp-01",
		"dp-03",
		"dp-05",
	]

	rationale: """
		Schema evolui por necessidade concreta durante construção da instância
		com 21 BCs e 31 relações. Cada feature (typed endpoints, FlowPayload,
		publishedLanguage enforcement, FeedbackLoop, external relationships)
		resolve uma limitação real encontrada durante o mapeamento. Design
		informado por 4 rounds de red team no schema e 4 rounds de red team
		na instância. Reversibility high porque não há dados persistidos nem
		consumidores externos — o schema governa apenas artefatos CUE no
		repositório. blastRadius cross-artifact porque a mudança afeta o
		schema e sua instância, mas não outros schemas nem governança.
		"""
}
