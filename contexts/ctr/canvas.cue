package ctr

// canvas.cue — Bounded Context Canvas: Contract & Terms Registry.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// CTR é o registry canônico de termos contratuais. Termos são imutáveis
// e versionados — qualquer alteração cria nova versão. Lifecycle
// explícito (draft → active → superseded → expired → cancelled).
// CMT, SCF e DRC consomem CTR como SoT de validade jurídica.
//
// Lenses aplicadas:
// - lens-contractual-and-legal-architecture (primária):
//   contract stack, imutabilidade, liability, evidence de aceite
// - lens-temporal-modeling-for-financial-systems (primária):
//   bitemporalidade, validity windows, supersession dates
// - lens-contract-theory (primária):
//   contratos incompletos, residual rights, cadeia contratual
// - lens-event-driven-architecture-patterns (secundária):
//   append-only history, schema evolution, Published Language
// - lens-regulatory-compliance-as-architecture (secundária):
//   audit trail, reconstrução temporal, compliance by design
// - lens-platform-evolution-and-backwards-compatibility (secundária):
//   versionamento backward-compatible, supersession sem quebra

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

canvas: artifact_schemas.#Canvas & {
	code: "ctr"
	name: "Contract & Terms Registry"

	purpose: """
		Registrar, versionar e expor termos contratuais como fonte de
		verdade jurídica operacional para o commitment lifecycle. CTR
		garante que toda referência a termos — por CMT, SCF ou DRC —
		aponta para uma versão específica, imutável e vigente. Sem CTR,
		cada BC downstream resolve "quais são os termos?" de forma
		independente, criando inconsistência contratual que degrada
		disputas, precificação de crédito e formalização de compromissos.
		CTR não é sistema de gestão de contratos nem workflow de
		negociação — é registry versionado, imutável e auditável.
		"""

	ubiquitousLanguageRef: "contexts/ctr/glossary.cue"

	// ==============================
	// CLASSIFICAÇÃO ESTRATÉGICA
	// ==============================

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque formalização contratual é domínio bem
			entendido e não proprietário — padrões contratuais de
			construção civil são exógenos à Mesh. Operational-enabler
			porque CTR habilita operação de CMT, SCF e DRC sem ser
			gerador de receita direto. Product porque padrões de
			registry contratual existem no mercado — a Mesh adapta com
			versionamento imutável e bitemporalidade, mas não inventa
			o conceito.
			"""
	}

	// ==============================
	// DOMAIN ROLES
	// ==============================

	domainRoles: {
		primary: "specification"
		rationale: """
			Specification como primário: CTR define e expõe termos
			contratuais como artefatos formais consumidos por BCs
			downstream. Não executa workflows (CMT faz isso) nem
			processa eventos (DRC faz isso). CTR especifica as
			condições sob as quais compromissos são firmados,
			financiados e disputados.
			"""
	}

	// ==============================
	// CAPABILITIES
	// ==============================

	capabilities: {
		operational: [{
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua de termos contratuais: cada registro,
				ativação, supersession e expiração é fato imutável no
				Event Log. Reconstrução temporal (as-of queries) permite
				ao regulador saber quais termos estavam vigentes em
				qualquer data passada.
				"""
			rationale: "Termos contratuais são base jurídica de operações financeiras. Se não são auditáveis com bitemporalidade, reconstituição regulatória é impossível."
		}, {
			description: """
				Registry versionado de termos contratuais: cada conjunto
				de termos é imutável após registro. Alterações criam nova
				versão com lineage explícita. Invariante: exatamente uma
				versão active por contrato+escopo.
				"""
			rationale: "Imutabilidade com versionamento é o único modelo que permite reconstrução determinística. Mutação de termos in-place quebraria rastreabilidade end-to-end de compromissos, crédito e disputas."
		}, {
			description: """
				Published Language de termos contratuais: modelo canônico
				exposto via sync queries para CMT (formalização), SCF
				(precificação) e DRC (base jurídica de disputas).
				"""
			rationale: "Três BCs downstream consomem termos com semânticas diferentes. Published Language garante que todos referenciam a mesma fonte com tradução via ACL local."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// ==============================
	// COMUNICAÇÃO
	// ==============================

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Organização submete registro de termos contratuais com partes, cláusulas, condições e escopo."
			command:         "RegisterContractTerms"
			resultingEvents: ["ContractTermsDrafted"]
			description: "Inicia lifecycle do termo em estado draft. Agente valida completude estrutural e existência das partes em NPM. ContractTermsDrafted é evento interno."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Operador ou agente ativa termos contratuais após validação completa."
			command:         "ActivateContractTerms"
			resultingEvents: ["ContractTermsActivated"]
			description: "Transiciona termos de draft para active. Gate verifica: unicidade de versão active por contrato+escopo, partes qualificadas, cláusulas válidas. ContractTermsActivated é evento publicado."
		}, {
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Organização submete nova versão de termos para contrato existente."
			command:         "RegisterTermsRevision"
			resultingEvents: ["ContractTermsDrafted"]
			description: "Cria nova versão em draft com lineage para versão anterior. Versão anterior permanece active até nova versão ser ativada."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Operador cancela termos por invalidação (fraude, erro, regulatória)."
			command:         "CancelContractTerms"
			resultingEvents: ["ContractTermsCancelled"]
			description: "Transiciona termos para cancelled — estado terminal. Supervisionado por irreversibilidade e impacto em compromissos ativos downstream."
		}, {
			type:        "query-surface"
			query:       "QueryContractTerms"
			returnType:  "ContractTerms"
			description: "Retorna termos contratuais por ID+versão ou termos active por contrato+escopo. Interface primária consumida por CMT, SCF e DRC."
		}, {
			type:        "query-surface"
			query:       "QueryContractClauses"
			returnType:  "ContractClauses"
			description: "Retorna cláusulas específicas de termos contratuais. Interface consumida por DRC para avaliar disputas contra base contratual."
		}]
		outbound: [{
			type:        "event-publisher"
			trigger:     "Termos contratuais ativados com sucesso."
			event:       "ContractTermsActivated"
			consumers:   ["cmt", "scf"]
			description: "Sinal de novos termos disponíveis. CMT pode referenciar em novos compromissos. SCF atualiza condições de elegibilidade."
		}, {
			type:        "event-publisher"
			trigger:     "Versão de termos superseded por nova versão ativada."
			event:       "ContractTermsSuperseded"
			consumers:   ["cmt", "scf", "drc"]
			description: "Sinal de que versão anterior não é mais a active. Compromissos existentes que referenciam versão superseded permanecem válidos — novos compromissos devem usar versão active."
		}, {
			type:        "event-publisher"
			trigger:     "Termos contratuais cancelados por invalidação."
			event:       "ContractTermsCancelled"
			consumers:   ["cmt", "drc"]
			description: "Sinal de invalidação. CMT deve avaliar compromissos ativos que referenciam estes termos. DRC registra como base para disputa."
		}, {
			type:          "query-dependency"
			targetContext: "npm"
			query:         "QueryParticipantStatus"
			purpose:       "Validar que partes referenciadas nos termos existem e estão qualificadas em NPM."
			description:   "CTR consome qualificação como pré-condição para registro. ACL traduz modelo de NPM para linguagem contratual."
		}]
		rationale: """
			Inbound: 4 commands (registro async + ativação sync + revisão
			async + cancelamento sync), 2 query surfaces (termos e
			cláusulas). Outbound: 3 event publishers (ativação para
			CMT/SCF, supersession para CMT/SCF/DRC, cancelamento para
			CMT/DRC), 1 query dependency (qualificação de partes via
			NPM). Padrão: CTR é upstream puro de dados contratuais —
			publica termos que governam toda a cadeia downstream.
			Queries são sync por necessidade de consistência forte
			(compromisso não pode referenciar termos inválidos).
			"""
	}
}
