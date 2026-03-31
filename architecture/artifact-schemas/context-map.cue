package artifact_schemas

// context-map.cue — Schema para context map (DDD).
//
// O context map é artefato singleton que documenta a topologia
// de integração entre bounded contexts e seus padrões de relação.
// É o SoT de quais BCs existem e como se relacionam.
//
// Estratégia desta versão:
// - Compatibilidade de patterns é regra de tipo (union estrutural)
// - Ownership de subdomínio é SoT explícito (mapa global obrigatório)
// - contexts[].subdomains é VISÃO DERIVADA (não fonte primária)
// - Regras cross-artifact são contratos de unificação
// - Runner fecha apenas o que não pode ser expresso em tipo

#ContextMap: {
	code:    string & =~"^[a-z][a-z0-9-]*$"
	name:    string & !=""
	purpose: string & !=""

	topology: "global"

	// BCs participantes.
	// subdomains aqui são visão derivada do ownership global.
	contexts: [#ContextEntry, #ContextEntry, ...#ContextEntry]

	// 🔴 SOURCE OF TRUTH DE OWNERSHIP
	subdomainOwnership: [#SubdomainRef]: #SubdomainOwnership

	// Relações direcionais entre BCs.
	relationships: [...#ContextRelationship]

	// Hooks de unificação cross-artifact
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
			rationale:          "Artefato estratégico único (singleton) que governa fronteiras entre BCs."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [

			// --- Estrutura básica ---
			{
				id:          "tq-cm-01"
				description: "Todo BC listado é único"
				test:        "Nenhum context aparece mais de uma vez."
				severity:    "fail"
				rationale:   "Duplicata quebra identidade do BC."
			},

			{
				id:          "tq-cm-02"
				description: "Relações referenciam BCs existentes"
				test:        "upstream/downstream existem em contexts[]."
				severity:    "fail"
				rationale:   "Referência órfã invalida o mapa."
			},

			{
				id:          "tq-cm-03"
				description: "Par upstream/downstream é único"
				test:        "Nenhum par duplicado."
				severity:    "fail"
				rationale:   "Duplicata cria ambiguidade de contrato."
			},

			// --- Tipo forte ---
			{
				id:          "tq-cm-04"
				description: "Compatibilidade de patterns é garantida por tipo"
				test:        "relationship instancia variante válida."
				severity:    "fail"
				rationale:   "Estado inválido é irrepresentável."
			},

			// --- Subdomínio ---
			{
				id:          "tq-cm-05"
				description: "Todo BC tem subdomínio"
				test:        "contexts[].subdomains não vazio."
				severity:    "fail"
				rationale:   "BC sem domínio não existe semanticamente."
			},

			{
				id:          "tq-cm-06"
				description: "Ownership de subdomínio é explícito e unificável"
				test:        "subdomainOwnership define owner único; cobertura total depende de unificação com contexts[]."
				severity:    "fail"
				rationale:   "Ownership é SoT explícito; cobertura completa exige validação cross-artifact."
			},

			// --- Simetria ---
			{
				id:          "tq-cm-07"
				description: "Relações simétricas são estruturalmente simétricas"
				test:        "Partnership e Shared Kernel usam tipos dedicados."
				severity:    "fail"
				rationale:   "Evita modelagem inconsistente."
			},

			// --- Completude ---
			{
				id:          "tq-cm-08"
				description: "BC participa de ao menos uma relação ou é justificado"
				test:        "BC isolado requer rationale."
				severity:    "warn"
				rationale:   "Evita mapa incompleto."
			},

			// --- Unificação ---
			{
				id:          "tq-cm-09"
				description: "Contexts esperados podem ser validados por unificação"
				test:        "expectedContexts ⊆ contexts[]."
				severity:    "fail"
				rationale:   "Hook para integração com wave plan."
			},

			{
				id:          "tq-cm-10"
				description: "Toda relação tem identidade única"
				test:        "code único e válido."
				severity:    "fail"
				rationale:   "Permite referência estável."
			},

			{
				id:          "tq-cm-11"
				description: "flowRefs validados por unificação com catálogo"
				test:        "flowRefs ⊆ declaredFlows."
				severity:    "fail"
				rationale:   "Hook para integração com cross-context flows."
			}]

		rationale: "Separação clara entre validação estrutural (tipo), contratos de unificação e validação operacional (runner)."
	}
}

// ==============================
// CONTEXT ENTRY
// ==============================

#ContextEntry: {
	context: #BoundedContextRef

	// ⚠️ VISÃO DERIVADA
	// Deve ser consistente com subdomainOwnership
	subdomains: [#SubdomainRef, ...#SubdomainRef]

	rationale?: string & !=""
}

// ==============================
// OWNERSHIP
// ==============================

#SubdomainOwnership: {
	ownerContext: #BoundedContextRef
	rationale:    string & !=""
}

// ==============================
// RELATIONSHIPS (TIPO FORTE)
// ==============================

#BaseRelationship: {
	code:       string & =~"^[a-z][a-z0-9-]*$"
	upstream:   #BoundedContextRef
	downstream: #BoundedContextRef

	upstreamPattern:   #UpstreamPattern
	downstreamPattern: #DownstreamPattern

	description?: string & !=""
	rationale:    string & !=""

	communicationPattern?: #CommunicationPattern
	flowRefs?:             [...#CrossContextFlowRef]
}

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

// ==============================
// ENUMS
// ==============================

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

// ==============================
// REFS
// ==============================

#BoundedContextRef:   string & =~"^[a-z][a-z0-9-]*$"
#SubdomainRef:        string & =~"^[a-z][a-z0-9-]*$"
#CrossContextFlowRef: string & =~"^[a-z][a-z0-9-]*$"
