package artifact_schemas

// context-map.cue — Schema para context map (DDD).
//
// O context map é artefato singleton que documenta a topologia
// de integração entre bounded contexts e seus padrões de relação.
// É o SoT de quais BCs existem, quais subdomínios cada um cobre,
// e como se relacionam.
//
// Estratégia desta versão:
// - combinações inválidas de patterns são irrepresentáveis por union de tipos
// - ownership explícito de subdomínios é invariante, não feature
// - published language é obrigatória nos tipos que a exigem e proibida nos demais
// - conformistCascadeRisk é permitido apenas em variantes conformist
// - communication e data flows (events/commands/queries) são simétricos por tipo
// - hooks de unificação permitem validação forte com wave plan e catálogo de flows
// - feedback loop é union discriminado
// - relações com externos suportam inbound e outbound
// - nomes dos tipos refletem os patterns reais, sem semântica enganosa
// - domainLevelTransversals são artefatos de primeira classe no nível global
// - campos estratégicos opcionais têm quality gate warn

#ContextMap: {
	code:    string & =~"^[a-z][a-z0-9-]*$"
	name:    string & !=""
	purpose: string & !=""

	topology: "global"

	// BCs participantes.
	contexts: [#ContextEntry, #ContextEntry, ...#ContextEntry]

	// Transversais de domínio como artefatos de primeira classe.
	// Definição canônica única de shared kernels consumidos por múltiplos BCs.
	// Cada BC referencia transversais pelo code via domainTransversals.
	domainLevelTransversals?: [...#DomainLevelTransversal]

	// Ownership explícito dos subdomínios no mapa.
	// O campo é obrigatório; a cobertura total dos subdomínios
	// usados em contexts[] é validada por runner/unificação (tq-cm-06).
	subdomainOwnership: [#SubdomainRef]: #SubdomainOwnership

	// Relações entre contexts e/ou sistemas externos.
	relationships: [...#ContextRelationship]

	// Hooks para unificação cross-artifact.
	expectedContexts?: [...#BoundedContextRef]
	declaredFlows?:    [...#CrossContextFlowRef]

	knownLimitations?: [...string]
	assumptions?:      [...string]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^strategic/context-map\\.cue$"
			fileNameRegex:      "^context-map\\.cue$"
			description:        "Context map: topologia global de integração entre bounded contexts."
			rationale:          "Context map vive em strategic/ como visão única das relações entre BCs."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-cm-01"
			description: "Todo bounded context listado em contexts[] é único"
			test:        "Nenhum context aparece mais de uma vez em contexts[]."
			severity:    "fail"
			rationale:   "Duplicata de BC gera ambiguidade estrutural."
		}, {
			id:          "tq-cm-02"
			description: "Todo BC interno em relationships[] está declarado em contexts[]"
			test:        "Cada endpoint interno em relationships[] referencia um context existente em contexts[].context."
			severity:    "fail"
			rationale:   "Relação com BC não declarado é referência órfã."
		}, {
			id:          "tq-cm-03"
			description: "Relações internas não duplicam o mesmo par source-target"
			test:        "Cada par (source, target) interno aparece no máximo uma vez em relationships[]."
			severity:    "fail"
			rationale:   "Duplicata cria ambiguidade sobre a fronteira."
		}, {
			id:          "tq-cm-04"
			description: "Patterns upstream/downstream são compatíveis por construção do tipo"
			test:        "relationships[] instancia uma variante válida de #ContextRelationship."
			severity:    "fail"
			rationale:   "Compatibilidade não é convenção textual; é enforced pelo union de tipos."
		}, {
			id:          "tq-cm-05"
			description: "Todo context tem ao menos um subdomínio"
			test:        "Cada contexts[].subdomains contém ao menos um item."
			severity:    "fail"
			rationale:   "BC sem subdomínio não tem escopo semântico."
		}, {
			id:          "tq-cm-06"
			description: "Ownership de subdomínio é explícito e unificável"
			test:        "subdomainOwnership é obrigatório. Cada entrada aponta para um único ownerContext. A cobertura total dos subdomínios usados em contexts[] depende de unificação/runner (tq-cm-06)."
			severity:    "fail"
			rationale:   "O tipo garante presença; o runner garante completude."
		}, {
			id:          "tq-cm-07"
			description: "Relações simétricas são modeladas como simétricas"
			test:        "Partnership e Shared Kernel usam variantes próprias do union."
			severity:    "fail"
			rationale:   "Evita assimetrias inválidas nesses padrões."
		}, {
			id:          "tq-cm-08"
			description: "Todo BC participa de ao menos uma relação ou tem justificativa"
			test:        "BC isolado deve ser justificado em rationale/context ou limitations."
			severity:    "warn"
			rationale:   "BC isolado pode ser legítimo, mas normalmente indica mapa incompleto."
		}, {
			id:          "tq-cm-09"
			description: "Cobertura esperada pelo wave plan pode ser validada por unificação"
			test:        "Se expectedContexts estiver preenchido, cada item deve aparecer em contexts[].context."
			severity:    "fail"
			rationale:   "Regra preparada para unificação com wave plan."
		}, {
			id:          "tq-cm-10"
			description: "Toda relação tem identidade canônica própria"
			test:        "Cada relationships[].code é único e segue regex canônica."
			severity:    "fail"
			rationale:   "Permite referência estável a relações."
		}, {
			id:          "tq-cm-11"
			description: "flowRefs podem ser validados por unificação com catálogo de flows"
			test:        "Se declaredFlows estiver preenchido, cada flowRef deve pertencer a declaredFlows."
			severity:    "fail"
			rationale:   "Regra preparada para unificação cross-artifact."
		}, {
			id:          "tq-cm-12"
			description: "Todo BC tem classificação estratégica completa ou justificativa"
			test:        "Cada contexts[] declara subdomainType, wardleyEvolution e domainAgentSpec, ou possui rationale explicando ausência."
			severity:    "warn"
			rationale:   "Campos estratégicos opcionais suportam preenchimento incremental, mas BC sem classificação limita análise de coupling e investimento."
		}, {
			id:          "tq-cm-13"
			description: "domainTransversals referenciados por BCs existem em domainLevelTransversals"
			test:        "Cada ref em contexts[].domainTransversals deve corresponder a um domainLevelTransversals[].code."
			severity:    "fail"
			rationale:   "Referência a transversal não definido é coupling invisível."
		}, {
			id:          "tq-cm-14"
			description: "Communication e data flows são simétricos por construção de tipo"
			test:        "Sem communication → sem events/commands/queries; com communication → ao menos um de events/commands/queries. flowRefs (referências a CrossContextFlows) são independentes desta regra."
			severity:    "fail"
			rationale:   "Data flows sem communication e communication sem data flows são ambos contratos incompletos. Enforced por tipo."
		}]
		rationale: "Critérios cobrem integridade estrutural, ownership como invariante, compatibilidade de patterns, contratos explícitos por tipo, completude estratégica e hooks para unificação cross-artifact."
	}
}

// ==============================
// CONTEXTS
// ==============================

#ContextEntry: {
	context:    #BoundedContextRef
	name:       string & !=""
	subdomains: [#SubdomainRef, ...#SubdomainRef]

	// Classificação estratégica.
	// Opcionais para suportar preenchimento incremental.
	// tq-cm-12 alerta quando ausentes sem rationale.
	subdomainType?:    "core" | "supporting" | "generic"
	wardleyEvolution?: "genesis" | "custom" | "product" | "commodity"
	// Path canônico do agent spec primário do BC.
	// Formato esperado: contexts/{bc}/agents/{bc}-primary-agent.cue
	// Substitui o antigo ID lógico (agt-{bc}-primary) — ADR-039.
	// O schema valida apenas o formato geral do path.
	// A coerência entre o BC do contexto e o BC embutido no path,
	// bem como a existência física do arquivo, é validada pelo runner.
	// Arquivo ausente em fase incremental: warn, não fail.
	domainAgentSpec?: string

	// Referências a transversais definidos em domainLevelTransversals[].code.
	// tq-cm-13 valida existência.
	domainTransversals?: [...#DomainLevelTransversalRef]

	rationale?: string & !=""
}

#SubdomainOwnership: {
	ownerContext: #BoundedContextRef
	rationale:    string & !=""
}

// Definição canônica de shared kernels de domínio.
// Artefato de primeira classe: cada transversal tem identidade,
// lista de tipos e rationale de existência.
#DomainLevelTransversal: {
	code:      string & =~"^[a-z][a-z0-9-]*$"
	name:      string & !=""
	typeRefs:  [#NonEmptyString, ...#NonEmptyString]
	rationale: string & !=""
}

// ==============================
// ENDPOINTS
// ==============================

#RelationshipEndpoint:
	#ContextEndpoint |
	#ExternalEndpoint

#ContextEndpoint: {
	kind:    "bounded-context"
	context: #BoundedContextRef
}

#ExternalEndpoint: {
	kind: "external-system"
	code: #ExternalSystemRef
	name: string & !=""
	type: "financial-institution" | "government-authority" | "saas-provider" | "erp" | "other"
	regulatoryVolatility?: "low" | "medium" | "high"
}

// ==============================
// RELATIONSHIPS
// ==============================

#ContextRelationship:
	#InternalRelationship |
	#ExternalRelationship

// #FlowPayload — Data flows declarados em uma relação com communication.
//
// At-least-one (≥1 de events/commands/queries não-vazio) era expressa
// como disjunção 7-way sobre open structs. CUE não colapsa disjunções
// abertas em valores concretos — produzia "incomplete value" para TODAS
// instâncias (válidas e inválidas indistintamente), de modo que a
// constraint nunca discriminava de fato. Disciplina movida para
// structural-check candidate (sc-cm-XX): communication declarado ⇒
// ≥1 flow não-vazio. Alinha com adr-040: cross-field assertions são
// domínio determinístico (structural-check), não shape-level.
//
// Asymmetry sem→sem permanece intacta via #BaseRelationshipWithoutCommunication.
#FlowPayload: {
	events?:   [#NonEmptyString, ...#NonEmptyString]
	commands?: [#NonEmptyString, ...#NonEmptyString]
	queries?:  [#NonEmptyString, ...#NonEmptyString]
	...
}

// Campos comuns a qualquer relação.
#_RelationshipCore: {
	code:      string & =~"^[a-z][a-z0-9-]*$"
	source:    #RelationshipEndpoint
	target:    #RelationshipEndpoint
	direction: #RelationshipDirection

	description?: string & !=""
	rationale:    string & !=""

	hotspots?:      [...string]
	feedbackLoop?:  #FeedbackLoop
	contextBudget?: "light" | "moderate" | "heavy"

	flowRefs?: [...#CrossContextFlowRef]

	// Open for extension by subtypes.
	...
}

// Relação sem communication declarada.
// Data flows (events/commands/queries) proibidos sem communication.
#BaseRelationshipWithoutCommunication: #_RelationshipCore & {
	events?:   _|_
	commands?: _|_
	queries?:  _|_
	kind?:     #RelationshipKind
}

// Relação com communication declarada.
// #FlowPayload provê shape opcional para events/commands/queries.
// At-least-one (com communication ⇒ ≥1 flow não-vazio) é disciplina
// deferida a structural-check (sc-cm-XX candidate); ver comentário
// em #FlowPayload sobre por que constraint type-level era inviável.
// Asymmetry sem→sem permanece via #BaseRelationshipWithoutCommunication.
#BaseRelationshipWithCommunication: #_RelationshipCore & {
	communication: #CommunicationPattern
	#FlowPayload
	kind?: #RelationshipKind
}

#BaseRelationship:
	#BaseRelationshipWithoutCommunication |
	#BaseRelationshipWithCommunication

#RelationshipDirection:
	"upstream-downstream" |
	"mutual-dependency"

// ----------------------------------------
// Internal BC ↔ Internal BC
// ----------------------------------------

#InternalRelationship:
	#InternalOHSACLRelationship |
	#InternalOHSConformistRelationship |
	#InternalOHSCustomerSupplierRelationship |
	#InternalOHSPLACLRelationship |
	#InternalOHSPLConformistRelationship |
	#InternalOHSPLCustomerSupplierRelationship |
	#InternalPublishedLanguageACLRelationship |
	#InternalPublishedLanguageConformistRelationship |
	#InternalPublishedLanguageCustomerSupplierRelationship |
	#InternalPartnershipRelationship |
	#InternalSharedKernelRelationship

#InternalBaseRelationship: #BaseRelationship & {
	source: {kind: "bounded-context"}
	target: {kind: "bounded-context"}
	direction: "upstream-downstream"
	upstreamPattern:   #UpstreamPattern
	downstreamPattern: #DownstreamPattern
}

#InternalSymmetricRelationship: #BaseRelationship & {
	source: {kind: "bounded-context"}
	target: {kind: "bounded-context"}
	direction: "mutual-dependency"
	upstreamPattern:   #SymmetricPattern
	downstreamPattern: #SymmetricPattern
}

// --- OHS upstream (publishedLanguage proibido) ---

#InternalOHSACLRelationship: #InternalBaseRelationship & {
	upstreamPattern:    #UpstreamPattern & "open-host-service"
	downstreamPattern:  #DownstreamPattern & "anti-corruption-layer"
	publishedLanguage?: _|_
}

#InternalOHSConformistRelationship: #InternalBaseRelationship & {
	upstreamPattern:    #UpstreamPattern & "open-host-service"
	downstreamPattern:  #DownstreamPattern & "conformist"
	publishedLanguage?: _|_
}

#InternalOHSCustomerSupplierRelationship: #InternalBaseRelationship & {
	upstreamPattern:    #UpstreamPattern & "open-host-service"
	downstreamPattern:  #DownstreamPattern & "customer-supplier"
	publishedLanguage?: _|_
}

// --- OHS+PL upstream (publishedLanguage obrigatório) ---

#InternalOHSPLACLRelationship: #InternalBaseRelationship & {
	upstreamPattern:   #UpstreamPattern & "open-host-service-published-language"
	downstreamPattern: #DownstreamPattern & "anti-corruption-layer"
	publishedLanguage: string & !=""
}

#InternalOHSPLConformistRelationship: #InternalBaseRelationship & {
	upstreamPattern:   #UpstreamPattern & "open-host-service-published-language"
	downstreamPattern: #DownstreamPattern & "conformist"
	publishedLanguage: string & !=""
}

#InternalOHSPLCustomerSupplierRelationship: #InternalBaseRelationship & {
	upstreamPattern:   #UpstreamPattern & "open-host-service-published-language"
	downstreamPattern: #DownstreamPattern & "customer-supplier"
	publishedLanguage: string & !=""
}

// --- PL upstream (publishedLanguage obrigatório) ---

#InternalPublishedLanguageACLRelationship: #InternalBaseRelationship & {
	upstreamPattern:   #UpstreamPattern & "published-language"
	downstreamPattern: #DownstreamPattern & "anti-corruption-layer"
	publishedLanguage: string & !=""
}

#InternalPublishedLanguageConformistRelationship: #InternalBaseRelationship & {
	upstreamPattern:   #UpstreamPattern & "published-language"
	downstreamPattern: #DownstreamPattern & "conformist"
	publishedLanguage: string & !=""
}

#InternalPublishedLanguageCustomerSupplierRelationship: #InternalBaseRelationship & {
	upstreamPattern:   #UpstreamPattern & "published-language"
	downstreamPattern: #DownstreamPattern & "customer-supplier"
	publishedLanguage: string & !=""
}

// --- Symmetric (publishedLanguage proibido) ---

#InternalPartnershipRelationship: #InternalSymmetricRelationship & {
	upstreamPattern:    #SymmetricPattern & "partnership"
	downstreamPattern:  #SymmetricPattern & "partnership"
	publishedLanguage?: _|_
}

#InternalSharedKernelRelationship: #InternalSymmetricRelationship & {
	upstreamPattern:    #SymmetricPattern & "shared-kernel"
	downstreamPattern:  #SymmetricPattern & "shared-kernel"
	publishedLanguage?: _|_
}

// ----------------------------------------
// External System ↔ Internal BC
// ----------------------------------------

#ExternalRelationship:
	#ExternalInboundRelationship |
	#ExternalOutboundRelationship

// --- Inbound: external → internal ---

#ExternalInboundRelationship:
	#ExternalInboundInterfaceACLRelationship |
	#ExternalInboundInterfaceConformistRelationship |
	#ExternalInboundInterfaceCustomerSupplierRelationship |
	#ExternalInboundPublishedLanguageACLRelationship |
	#ExternalInboundPublishedLanguageConformistRelationship |
	#ExternalInboundPLCustomerSupplierRelationship

#ExternalInboundBaseRelationship: #BaseRelationship & {
	source: {kind: "external-system"}
	target: {kind: "bounded-context"}
	direction: "upstream-downstream"
	upstreamPattern:   #ExternalUpstreamPattern
	downstreamPattern: #ExternalDownstreamPattern
}

// Interface inbound non-PL: publishedLanguage proibido.
// Non-conformist: conformistCascadeRisk proibido.

#ExternalInboundInterfaceACLRelationship: #ExternalInboundBaseRelationship & {
	upstreamPattern:         #ExternalUpstreamPattern & "external-interface"
	downstreamPattern:       #ExternalDownstreamPattern & "anti-corruption-layer"
	publishedLanguage?:      _|_
	conformistCascadeRisk?:  _|_
}

#ExternalInboundInterfaceConformistRelationship: #ExternalInboundBaseRelationship & {
	upstreamPattern:    #ExternalUpstreamPattern & "external-interface"
	downstreamPattern:  #ExternalDownstreamPattern & "conformist"
	publishedLanguage?: _|_
	conformistCascadeRisk?: #ConformistCascadeRisk
}

#ExternalInboundInterfaceCustomerSupplierRelationship: #ExternalInboundBaseRelationship & {
	upstreamPattern:         #ExternalUpstreamPattern & "external-interface"
	downstreamPattern:       #ExternalDownstreamPattern & "customer-supplier"
	publishedLanguage?:      _|_
	conformistCascadeRisk?:  _|_
}

// --- Inbound PL (publishedLanguage obrigatório) ---

#ExternalInboundPublishedLanguageACLRelationship: #ExternalInboundBaseRelationship & {
	upstreamPattern:        #ExternalUpstreamPattern & "published-language"
	downstreamPattern:      #ExternalDownstreamPattern & "anti-corruption-layer"
	publishedLanguage:      string & !=""
	conformistCascadeRisk?: _|_
}

#ExternalInboundPublishedLanguageConformistRelationship: #ExternalInboundBaseRelationship & {
	upstreamPattern:   #ExternalUpstreamPattern & "published-language"
	downstreamPattern: #ExternalDownstreamPattern & "conformist"
	publishedLanguage: string & !=""
	conformistCascadeRisk?: #ConformistCascadeRisk
}

#ExternalInboundPLCustomerSupplierRelationship: #ExternalInboundBaseRelationship & {
	upstreamPattern:        #ExternalUpstreamPattern & "published-language"
	downstreamPattern:      #ExternalDownstreamPattern & "customer-supplier"
	publishedLanguage:      string & !=""
	conformistCascadeRisk?: _|_
}

// --- Outbound: internal → external ---
// conformistCascadeRisk proibido em todos os outbound.

#ExternalOutboundRelationship:
	#ExternalOutboundOHSInterfaceRelationship |
	#ExternalOutboundPLInterfaceRelationship |
	#ExternalOutboundOHSPLInterfaceRelationship |
	#ExternalOutboundOHSCustomerSupplierRelationship |
	#ExternalOutboundPLCustomerSupplierRelationship |
	#ExternalOutboundOHSPLCustomerSupplierRelationship

#ExternalOutboundBaseRelationship: #BaseRelationship & {
	source: {kind: "bounded-context"}
	target: {kind: "external-system"}
	direction: "upstream-downstream"
	upstreamPattern:        #ExternalOutboundUpstreamPattern
	downstreamPattern:      #ExternalOutboundDownstreamPattern
	conformistCascadeRisk?: _|_
}

// OHS outbound non-PL: publishedLanguage proibido.

#ExternalOutboundOHSInterfaceRelationship: #ExternalOutboundBaseRelationship & {
	upstreamPattern:    #ExternalOutboundUpstreamPattern & "open-host-service"
	downstreamPattern:  #ExternalOutboundDownstreamPattern & "external-interface"
	publishedLanguage?: _|_
}

// Outbound PL: publishedLanguage obrigatório.

#ExternalOutboundPLInterfaceRelationship: #ExternalOutboundBaseRelationship & {
	upstreamPattern:   #ExternalOutboundUpstreamPattern & "published-language"
	downstreamPattern: #ExternalOutboundDownstreamPattern & "external-interface"
	publishedLanguage: string & !=""
}

#ExternalOutboundOHSPLInterfaceRelationship: #ExternalOutboundBaseRelationship & {
	upstreamPattern:   #ExternalOutboundUpstreamPattern & "open-host-service-published-language"
	downstreamPattern: #ExternalOutboundDownstreamPattern & "external-interface"
	publishedLanguage: string & !=""
}

#ExternalOutboundOHSCustomerSupplierRelationship: #ExternalOutboundBaseRelationship & {
	upstreamPattern:    #ExternalOutboundUpstreamPattern & "open-host-service"
	downstreamPattern:  #ExternalOutboundDownstreamPattern & "customer-supplier"
	publishedLanguage?: _|_
}

#ExternalOutboundPLCustomerSupplierRelationship: #ExternalOutboundBaseRelationship & {
	upstreamPattern:   #ExternalOutboundUpstreamPattern & "published-language"
	downstreamPattern: #ExternalOutboundDownstreamPattern & "customer-supplier"
	publishedLanguage: string & !=""
}

#ExternalOutboundOHSPLCustomerSupplierRelationship: #ExternalOutboundBaseRelationship & {
	upstreamPattern:   #ExternalOutboundUpstreamPattern & "open-host-service-published-language"
	downstreamPattern: #ExternalOutboundDownstreamPattern & "customer-supplier"
	publishedLanguage: string & !=""
}

// ==============================
// PATTERN ENUMS
// ==============================

// Internal upstream-downstream: apenas patterns assimétricos.
// Partnership e shared-kernel passam por #SymmetricPattern.
#UpstreamPattern:
	"open-host-service" |
	"published-language" |
	"open-host-service-published-language"

#DownstreamPattern:
	"anti-corruption-layer" |
	"conformist" |
	"customer-supplier"

#SymmetricPattern:
	"partnership" |
	"shared-kernel"

#ExternalUpstreamPattern:
	"external-interface" |
	"published-language"

#ExternalDownstreamPattern:
	"anti-corruption-layer" |
	"conformist" |
	"customer-supplier"

#ExternalOutboundUpstreamPattern:
	"open-host-service" |
	"published-language" |
	"open-host-service-published-language"

#ExternalOutboundDownstreamPattern:
	"external-interface" |
	"customer-supplier"

// ==============================
// COMMUNICATION / COUPLING
// ==============================

#CommunicationPattern: {
	type: "sync" | "async" | "hybrid"
}

#FeedbackLoop:
	#NoFeedbackLoop |
	#ActiveFeedbackLoop

#NoFeedbackLoop: {
	exists: false
}

#ActiveFeedbackLoop: {
	exists:                true
	reverseRelationshipId: string & =~"^[a-z][a-z0-9-]*$"
	loopSemantics:         string & !=""
	// Categorização machine-evaluable da natureza do loop (adr-118).
	// Opcional em PR-1 (schema extension); aplicação em arestas concretas
	// vem em PR-3 do plano registrado em def-026/def-027.
	// loopSemantics permanece como descrição em prose; kind é a
	// dimensão categorical complementar (typed enum).
	kind?: #FeedbackLoopKind
}

#ConformistCascadeRisk: {
	chain:     string & !=""
	rationale: string & !=""
}

// ==============================
// REFS (definição canônica única)
// ==============================

#BoundedContextRef:         string & =~"^[a-z][a-z0-9-]*$"
#ExternalSystemRef:         string & =~"^ext-[a-z][a-z0-9-]*$"
#SubdomainRef:              string & =~"^[a-z][a-z0-9-]*$"
#CrossContextFlowRef:       string & =~"^[a-z][a-z0-9-]*$"
#DomainLevelTransversalRef: string & =~"^[a-z][a-z0-9-]*$"
#NonEmptyString:            string & !=""

// ==============================
// KINDS (categorização machine-evaluable, adr-118 + adr-119)
// ==============================

// #FeedbackLoopKind — categoria do loop bidirecional declarado em
// #ActiveFeedbackLoop. Complementa loopSemantics (prose) com dimensão
// typed. Per adr-118: enum inicial com 1 valor; expansão via ADRs
// follow-on quando padrão concreto adicional surgir (pattern
// adr-049/056/063 de minimalismo). adr-124 adiciona 2º valor após
// descoberta empírica de ciclo fce↔rew via Ajuste 1 do PR-3.
//
// Valores:
//   bidirectional-orchestration — par BC↔BC onde cada lado publica
//     eventos para o outro consumir como orquestração sequencial
//     (publish-react bilateral), distinto de partnership (shared
//     kernel) e de OHS (one-way data flow). Primeiro consumidor:
//     drc↔cmt (sc-cm-07 W1, ciclo declarado via feedbackLoop em
//     ambas arestas; documentação no canvas CMT + subdomain DRC).
//   policy-execution-feedback — par BC↔BC onde upstream publica
//     decisões/policy (lado policy) e downstream publica state events
//     de execução (lado execution) que retroalimentam o modelo do
//     upstream. Estrutura canônica policy ↔ execution: assimetria de
//     cadência (decisão pontual vs stream de state); complementar a
//     policy-reaction (per adr-119) ao adicionar a dimensão de
//     feedback contínuo de execução. Primeiro consumidor: fce↔rew
//     (sc-cm-07 sub-ciclo emergente após quebra de W3, REW publica
//     CreditEligibilityDecided + FCE publica PaymentSettled/
//     PaymentObligationDefaulted; loopSemantics declarada em ambas
//     arestas como "loop de aprendizado contínuo").
#FeedbackLoopKind:
	"bidirectional-orchestration" |
	"policy-execution-feedback"

// #RelationshipKind — categoria opcional de relationship cross-BC
// que complementa direction (upstream-downstream | mutual-dependency)
// + patterns (OHS/ACL/etc.) com dimensão semântica sobre NATUREZA do
// acoplamento. Per adr-119: 1 valor inicial; expansão via ADRs
// follow-on (pattern adr-049/056/063).
//
// Valores:
//   policy-reaction — relação onde upstream PUBLICA decisão/sinal
//     (notification) e downstream REAGE via policy interna,
//     distinto de dependência estrutural de dados. Upstream
//     "produz decisões; downstream executa OU ignora conforme
//     policy local". Primeiro consumidor: rew-to-cmt (sc-cm-07 W2,
//     RiskAlertRaised/Resolved per canvas REW "decisão ≠ execução").
#RelationshipKind: "policy-reaction"
