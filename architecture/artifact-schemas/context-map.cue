package artifact_schemas

// context-map.cue — Schema para context map (DDD).
//
// O context map é artefato singleton que documenta a topologia
// de integração entre bounded contexts e seus padrões de relação.
// É o SoT de quais BCs existem, quais subdomínios cada um cobre,
// e como se relacionam (upstream/downstream patterns).
//
// Estratégia desta versão:
// - tq-cm-04 vira regra de tipo por union estrutural de relações válidas
// - tq-cm-06 vira parcialmente estrutural via mapa explícito de ownership;
//   a cobertura total ainda depende de unificação/runner
// - tq-cm-09 vira regra forte quando unificado com o artefato que fornece
//   os contexts esperados do wave plan
// - tq-cm-11 vira regra forte quando unificado com o catálogo de flows
//
// Princípio:
// - o que puder ser estado inválido irrepresentável, vira tipo
// - o que depender de outro artefato, vira contrato de unificação
// - runner fica só para o restante

#ContextMap: {
	code:    string & =~"^[a-z][a-z0-9-]*$"
	name:    string & !=""
	purpose: string & !=""

	// Singleton estratégico.
	topology: "global"

	// BCs participantes.
	contexts: [#ContextEntry, #ContextEntry, ...#ContextEntry]

	// Ownership explícito dos subdomínios no mapa.
	// Cada chave é um subdomínio e aponta para exatamente um ownerContext.
	// Isso transforma single-ownership em dado explícito do artefato.
	subdomainOwnership?: [#SubdomainRef]: #SubdomainOwnership

	// Relações direcionais entre BCs.
	relationships: [...#ContextRelationship]

	// Hooks para unificação cross-artifact.
	// Quando preenchidos por outro artefato, viram constraints reais.
	expectedContexts?: [...#BoundedContextRef]
	knownFlows?:       [...#CrossContextFlowRef]

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
			description: "Todo BC em relationships[] está declarado em contexts[]"
			test:        "Cada upstream e downstream em relationships[] referencia um context existente em contexts[].context."
			severity:    "fail"
			rationale:   "Relação com BC não declarado é referência órfã."
		}, {
			id:          "tq-cm-03"
			description: "Relações não duplicam par upstream-downstream"
			test:        "Cada par (upstream, downstream) aparece no máximo uma vez."
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
			test:        "Se subdomainOwnership estiver preenchido, cada entrada aponta para um único ownerContext. A cobertura total dos subdomínios usados em contexts[] deve ser verificada por unificação/runner."
			severity:    "fail"
			rationale:   "Single ownership vira artefato explícito. A cobertura total depende de comparar contexts[].subdomains com as chaves do mapa."
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
			rationale:   "Regra preparada para unificação com o artefato que materializa os contexts esperados do wave plan."
		}, {
			id:          "tq-cm-10"
			description: "Toda relação tem identidade canônica própria"
			test:        "Cada relationships[].code é único e segue regex canônica."
			severity:    "fail"
			rationale:   "Permite referência estável a relações."
		}, {
			id:          "tq-cm-11"
			description: "flowRefs podem ser validados por unificação com catálogo de flows"
			test:        "Se knownFlows estiver preenchido, cada flowRef deve pertencer a knownFlows."
			severity:    "fail"
			rationale:   "Regra preparada para unificação cross-artifact com catálogo de CrossContextFlows."
		}]
		rationale: "Critérios cobrem integridade estrutural, ownership explícito, compatibilidade de patterns e hooks para unificação cross-artifact."
	}
}

#ContextEntry: {
	context:    #BoundedContextRef
	subdomains: [#SubdomainRef, ...#SubdomainRef]
	rationale?: string & !=""
}

#SubdomainOwnership: {
	ownerContext: #BoundedContextRef
	rationale:    string & !=""
}

#BaseRelationship: {
	code:        string & =~"^[a-z][a-z0-9-]*$"
	upstream:    #BoundedContextRef
	downstream:  #BoundedContextRef

	upstreamPattern:   #UpstreamPattern
	downstreamPattern: #DownstreamPattern

	description?: string & !=""
	rationale:   string & !=""

	communicationPattern?: #CommunicationPattern
	flowRefs?:             [...#CrossContextFlowRef]
}

// Compatibilidade de patterns vira regra de tipo.
// Relações inválidas simplesmente não unificam.
#ContextRelationship:
	#OHSACLRelationship |
	#OHSConformistRelationship |
	#OHSPLACLRelationship |
	#OHSPLConformistRelationship |
	#PublishedLanguageACLRelationship |
	#PublishedLanguageConformistRelationship |
	#PartnershipRelationship |
	#SharedKernelRelationship

#OHSACLRelationship: #BaseRelationship & {
	upstreamPattern:   "open-host-service"
	downstreamPattern: "anti-corruption-layer"
}

#OHSConformistRelationship: #BaseRelationship & {
	upstreamPattern:   "open-host-service"
	downstreamPattern: "conformist"
}

#OHSPLACLRelationship: #BaseRelationship & {
	upstreamPattern:   "open-host-service-published-language"
	downstreamPattern: "anti-corruption-layer"
}

#OHSPLConformistRelationship: #BaseRelationship & {
	upstreamPattern:   "open-host-service-published-language"
	downstreamPattern: "conformist"
}

#PublishedLanguageACLRelationship: #BaseRelationship & {
	upstreamPattern:   "published-language"
	downstreamPattern: "anti-corruption-layer"
}

#PublishedLanguageConformistRelationship: #BaseRelationship & {
	upstreamPattern:   "published-language"
	downstreamPattern: "conformist"
}

#PartnershipRelationship: #BaseRelationship & {
	upstreamPattern:   "partnership"
	downstreamPattern: "partnership"
}

#SharedKernelRelationship: #BaseRelationship & {
	upstreamPattern:   "shared-kernel"
	downstreamPattern: "shared-kernel"
}

#UpstreamPattern:
	"open-host-service" |
	"published-language" |
	"open-host-service-published-language" |
	"partnership" |
	"shared-kernel"

#DownstreamPattern:
	"anti-corruption-layer" |
	"conformist" |
	"partnership" |
	"shared-kernel"

#CommunicationPattern: {
	mode: "events" | "request-reply" | "mixed"
	criticality?: "high" | "medium" | "low"
	notes?: string & !=""
}

#BoundedContextRef:   string & =~"^[a-z][a-z0-9-]*$"
#SubdomainRef:        string & =~"^[a-z][a-z0-9-]*$"
#CrossContextFlowRef: string & =~"^[a-z][a-z0-9-]*$"
