package ctr

// service-contract.cue — Service Contract: Contract & Terms Registry.
// Instância de #ServiceContract (architecture/artifact-schemas/service-contract.cue).
//
// Superfície canônica do CTR: registry versionado e imutável de termos
// contratuais. CUE como SoT autoral; api.yaml e async-api.yaml são
// derivados mecanicamente (P1).
//
// Lenses aplicadas:
// - lens-api-design-as-product: design-first, error guidance,
//   naming consistency, HATEOAS navigation
// - lens-contractual-and-legal-architecture: supervisão de ativação
//   e cancelamento, imutabilidade pós-ativação
// - lens-event-driven-architecture-patterns: ordering contratual,
//   ACL boundary estruturado, CloudEvents envelope
//
// Decisões relevantes:
// - getOperationStatus excluído: tracking async é platform convention,
//   não semântica de superfície do BC.
// - registerTermsRevision é ActionCommand (não CreateCommand): opera
//   sobre aggregate existente e precisa de concorrência para proteger
//   inv-lineage-integrity contra branching.
// - err-supervision-required projeta 422 (não 403): supervisão é
//   evidência de workflow ausente, não falta de permissão.
//
// ADR correspondente: adr-050.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

serviceContract: artifact_schemas.#ServiceContract & {
	name:        "Contract & Terms Registry Service Contract"
	apiVersion:  "1.0.0"
	description: "Superfície canônica do CTR: registry versionado e imutável de termos contratuais. Consumers (CMT, SCF, DRC, ITC) referenciam termos por versão específica ou pela versão active de um contrato+escopo. Registro e revisão são async; ativação e cancelamento são sync supervisionados."

	boundedContextRef: "ctr"

	// ==============================
	// SYNC SURFACE
	// ==============================

	sync: {
		commands: [{
			kind:        "create"
			operationId: "registerContractTerms"
			commandRef:  "cmd-register-contract-terms"
			name:        "Registrar Termos Contratuais"
			description: "Submete registro de termos com partes, cláusulas, condições e escopo. Processamento async — cria aggregate com versão v1 em estado draft. Agente valida completude estrutural e existência das partes em NPM."
			possibleErrors: [
				"err-duplicate-scope",
				"err-invalid-participant",
				"err-incomplete-terms",
			]
			links: [{
				rel:               "search"
				targetOperationId: "searchContractTerms"
				description:       "Buscar aggregate criado após processamento. Filtrar por contract_id e scope_description."
			}]
			idempotency: {
				required:  true
				mechanism: "idempotency-key"
				rationale: "Registro é POST async — retry sem idempotency-key criaria aggregates duplicados para mesmo contrato+escopo."
			}
			rationale: "Canvas inbound[0]: registro como command async. Primeiro ponto de entrada no lifecycle. CreateCommand porque cria novo aggregate root (novo contractTermsId). Concorrência proibida (CreateCommand) porque aggregate ainda não existe."
		}, {
			kind:        "action"
			operationId: "activateContractTerms"
			commandRef:  "cmd-activate-contract-terms"
			name:        "Ativar Termos Contratuais"
			description: "Transiciona versão de termos de draft para active. Sync — caller recebe confirmação imediata de vigência. Se existir versão active anterior para mesmo contrato+escopo, supersede atomicamente. Decisão supervisionada."
			possibleErrors: [
				"err-aggregate-not-found",
				"err-version-not-found",
				"err-invalid-state-transition",
				"err-supervision-required",
				"err-invariant-violation",
			]
			links: [{
				rel:               "self"
				targetOperationId: "getContractTerms"
				description:       "Consultar aggregate após ativação."
			}, {
				rel:               "versions"
				targetOperationId: "listTermsVersions"
				description:       "Listar todas as versões do aggregate."
			}]
			idempotency: {
				required: false
				rationale: "Ativação é transição de estado idempotente por natureza — ativar versão já active é no-op. Não precisa de mecanismo explícito."
			}
			concurrency: {
				strategy:     "optimistic"
				versionField: "aggregateVersion"
				rationale:    "Controle otimista por aggregate version (event sequence number do event store). Generator projeta como ETag/If-Match. Previne ativação concorrente de versões diferentes. aggregateVersion é campo infra derivado do event store, não campo de domínio — follow-up para formalizar quando ontologia de domain fields suportar refs a campos infra."
			}
			supervision: {
				required: true
				approver: "human-supervisor"
				rationale: "Canvas supervisedDecision: activate-contract-terms. Ativação cria base jurídica para compromissos em CMT e elegibilidade em SCF. P10: agente recomenda, humano decide."
			}
			rationale: "Canvas inbound[1]: ativação sync supervisionada. ActionCommand porque opera sobre aggregate existente — concorrência obrigatória. Supervisão por irreversibilidade jurídica."
		}, {
			kind:        "action"
			operationId: "registerTermsRevision"
			commandRef:  "cmd-register-terms-revision"
			name:        "Registrar Revisão de Termos"
			description: "Submete nova versão de termos para contrato+escopo existente. Async — cria nova versão em draft com lineage para versão anterior. Versão anterior permanece active até nova ser ativada."
			possibleErrors: [
				"err-aggregate-not-found",
				"err-incomplete-terms",
			]
			links: [{
				rel:               "versions"
				targetOperationId: "listTermsVersions"
				description:       "Listar versões incluindo nova revisão após processamento."
			}]
			idempotency: {
				required:  true
				mechanism: "idempotency-key"
				rationale: "Revisão é POST async que cria nova versão — retry sem idempotency-key duplicaria versões no aggregate."
			}
			concurrency: {
				strategy:     "optimistic"
				versionField: "aggregateVersion"
				rationale:    "Concorrência obrigatória: duas revisões concorrentes criariam dois drafts apontando para mesma versão anterior, violando inv-lineage-integrity (lineage é cadeia linear, não árvore). If-Match garante que o aggregate não mudou desde a leitura do client."
			}
			rationale: "Canvas inbound[2]: revisão como command async. ActionCommand (não CreateCommand) porque opera sobre aggregate existente — precisa de concorrência para proteger inv-lineage-integrity contra branching de lineage."
		}, {
			kind:        "action"
			operationId: "cancelContractTerms"
			commandRef:  "cmd-cancel-contract-terms"
			name:        "Cancelar Termos Contratuais"
			description: "Cancela versão de termos por invalidação (fraude, erro, regulatória). Sync — estado terminal irreversível. Decisão supervisionada por impacto cross-context."
			possibleErrors: [
				"err-aggregate-not-found",
				"err-version-not-found",
				"err-invalid-state-transition",
				"err-supervision-required",
			]
			links: [{
				rel:               "self"
				targetOperationId: "getContractTerms"
				description:       "Consultar aggregate após cancelamento."
			}]
			idempotency: {
				required: false
				rationale: "Cancelamento é transição de estado idempotente — cancelar versão já cancelled é no-op."
			}
			concurrency: {
				strategy:     "optimistic"
				versionField: "aggregateVersion"
				rationale:    "Controle otimista previne cancelamento concorrente com ativação sobre mesma versão."
			}
			supervision: {
				required: true
				approver: "human-supervisor"
				rationale: "Canvas supervisedDecision: cancel-contract-terms. Cancelamento é irreversível com impacto em compromissos ativos downstream. P10."
			}
			rationale: "Canvas inbound[3]: cancelamento sync supervisionado. ActionCommand porque opera sobre versão existente. Supervisão por irreversibilidade e blast radius cross-context."
		}]

		queries: [{
			kind:        "single"
			operationId: "getContractTerms"
			queryRef:    "qry-contract-terms"
			name:        "Consultar Termos Contratuais"
			description: "Retorna aggregate com versão active expandida. Suporta as_of para reconstrução temporal regulatória. Interface primária consumida por CMT, SCF e DRC para referenciar termos vigentes."
			possibleErrors: [
				"err-aggregate-not-found",
			]
			links: [{
				rel:               "versions"
				targetOperationId: "listTermsVersions"
				description:       "Listar todas as versões deste aggregate."
			}]
			cacheTier: "volatile"
			rationale: "Canvas query-surface: QueryContractTerms. Volatile porque estado muda com ativação/supersessão/cancelamento. 3 BCs downstream consomem."
		}, {
			kind:        "collection"
			operationId: "searchContractTerms"
			queryRef:    "qry-contract-terms"
			name:        "Buscar Termos por Contrato"
			description: "Busca aggregates por contract_id, opcionalmente filtrado por scope_description. Retorna lista paginada com versão active expandida. Interface para discovery de termos antes de referenciar por ID."
			possibleErrors: []
			cacheTier: "list"
			rationale: "Query de busca complementar a getContractTerms. List porque resultados de busca mudam com menor frequência que item individual."
		}, {
			kind:        "single"
			operationId: "getTermsVersion"
			queryRef:    "qry-contract-terms"
			name:        "Consultar Versão Específica"
			description: "Retorna versão específica por contractTermsId + versionNumber. Preferido para operações já formalizadas que referenciam versão exata — version-pinned. Imutável após ativação."
			possibleErrors: [
				"err-aggregate-not-found",
				"err-version-not-found",
			]
			links: [{
				rel:               "activate"
				targetOperationId: "activateContractTerms"
				description:       "Ativar esta versão (requer supervisão)."
				availability: stateIn: ["draft"]
			}, {
				rel:               "cancel"
				targetOperationId: "cancelContractTerms"
				description:       "Cancelar esta versão (requer supervisão)."
				availability: stateIn: ["draft", "active"]
			}]
			cacheTier: "terminal"
			rationale: "Versão específica é imutável após ativação (inv-post-activation-immutability). Terminal cache — conteúdo nunca muda, apenas estado pode transicionar. Links condicionais por state vivem aqui (não em getContractTerms) porque esta query retorna versão com estado visível."
		}, {
			kind:        "collection"
			operationId: "listTermsVersions"
			queryRef:    "qry-contract-terms"
			name:        "Listar Versões"
			description: "Lista versões de termos de um aggregate, com filtro opcional por estado. Retorna lista paginada ordenada por versionNumber decrescente."
			possibleErrors: [
				"err-aggregate-not-found",
			]
			cacheTier: "list"
			rationale: "Lista de versões muda apenas com nova revisão ou transição de estado. List cache adequado para coleções com frequência moderada de mudança."
		}, {
			kind:        "collection"
			operationId: "queryContractClauses"
			queryRef:    "qry-contract-clauses"
			name:        "Consultar Cláusulas Contratuais"
			description: "Retorna cláusulas específicas de termos por contractTermsId + versionNumber, com filtro por tipo (sla, retention, penalty, warranty, cancellation). Interface primária consumida por DRC para base jurídica de disputas."
			possibleErrors: [
				"err-aggregate-not-found",
				"err-version-not-found",
			]
			cacheTier: "terminal"
			rationale: "Canvas query-surface: QueryContractClauses. Terminal porque cláusulas são imutáveis pós-ativação. DRC consome para resolução contra cláusulas específicas."
		}]
	}

	// ==============================
	// ASYNC SURFACE
	// ==============================

	async: {
		publishedEvents: [{
			eventRef:    "evt-contract-terms-activated"
			name:        "ContractTermsActivated"
			description: "Versão de termos ativada (draft → active). Sinal cross-context: CMT pode referenciar em novos compromissos, SCF atualiza condições de elegibilidade, ITC governa operações de comex."
			ordering: {
				scope:         "within-aggregate"
				guarantor:     "producer"
				sequenceField: "mesh_sequence_number"
				rationale:     "Ordenação por aggregate garante que consumers processam eventos de lifecycle na sequência correta. Producer garante via Event Log append-only com sequence number monotônico."
			}
			rationale: "Canvas outbound[0]: consumers CMT, SCF, ITC. Evento cross-context mais importante — sinaliza nova base jurídica disponível."
		}, {
			eventRef:    "evt-contract-terms-superseded"
			name:        "ContractTermsSuperseded"
			description: "Versão de termos substituída por nova versão ativada. Sinal para CMT, SCF e DRC que versão referenciada não é mais a active. Compromissos existentes mantêm referência à versão supersedida."
			ordering: {
				scope:         "within-aggregate"
				guarantor:     "producer"
				sequenceField: "mesh_sequence_number"
				rationale:     "Supersessão é par atômico com ativação — mesma ordering guarantee. Consumers usam mesh_correlation_id para processar Activated+Superseded como par."
			}
			rationale: "Canvas outbound[1]: consumers CMT, SCF, DRC. Completa ciclo de supersessão. Emitido atomicamente com ContractTermsActivated quando existe versão active anterior."
		}, {
			eventRef:    "evt-contract-terms-cancelled"
			name:        "ContractTermsCancelled"
			description: "Termos cancelados por decisão supervisionada (fraude, erro, regulatória). Sinal de invalidação: CMT avalia compromissos ativos referenciando estes termos, DRC registra como base para disputa."
			ordering: {
				scope:         "within-aggregate"
				guarantor:     "producer"
				sequenceField: "mesh_sequence_number"
				rationale:     "Cancelamento é evento de invalidação com maior blast radius — ordenação correta é crítica para que consumers não processem eventos posteriores antes da invalidação."
			}
			rationale: "Canvas outbound[2]: consumers CMT, DRC. Evento de invalidação com maior blast radius."
		}]

		consumedEvents: [{
			// Pré-condição de runner: este eventRef resolve no domain model
			// de SSC (sourceContext), não no domain model local do CTR.
			// tq-ct-01 como escrito hoje exige resolução em domain-model.cue
			// events[].code sem qualificar de qual BC. Para que esta instância
			// passe validação, o runner precisa implementar resolução cross-BC:
			// consumedEvents[].eventRef resolve contra sourceContext domain model.
			// Se o runner ainda estiver no comportamento antigo (resolução
			// local), este ref falhará mesmo estando conceitualmente correto.
			// Gap estrutural: #DomainModel não tem seção de consumed events.
			eventRef:      "evt-sourcing-decision-made"
			name:          "SourcingDecisionMade"
			description:   "Decisão de sourcing estratégico de SSC. Trigger para registro de contrato-quadro. CTR traduz decisão de sourcing para linguagem contratual via ACL anticorruption-layer."
			sourceContext: "ssc"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz modelo de sourcing de SSC para linguagem contratual do CTR. Payload de domínio pertence a SSC — CTR não acopla ao schema interno. ACL extrai dados relevantes (partes, escopo, condições iniciais) e transforma em input para cmd-register-contract-terms."
				rationale:   "SSC e CTR têm linguagens ubíquas distintas. Conformist acoplaria CTR ao modelo de sourcing — evolução do schema de SSC quebraria registro de termos. ACL isola a fronteira."
			}
			reaction: "Inicia registro de contrato-quadro: ACL traduz decisão de sourcing para input de cmd-register-contract-terms com escopo derivado da decisão de sourcing."
			correlatedWith: [
				"cmd-register-contract-terms",
				"agg-contract-terms",
			]
			rationale: "Canvas inbound event-consumer: SSC é upstream — decisão de sourcing estratégico é gatilho para formalização contratual. Contrato-quadro nasce de negociação estratégica (SSC), não de execução de compra (P2P)."
		}]
	}

	// ==============================
	// DOMAIN ERRORS
	// ==============================
	//
	// SOMENTE erros semânticos de negócio do CTR.
	// Erros de transporte excluídos deliberadamente:
	// - 400 Bad Request (request validation) → platform
	// - 412 Precondition Failed (If-Match) → derivado de ConcurrencyPolicy
	// - 429 Too Many Requests (rate limit) → platform policy
	// - 304 Not Modified (conditional GET) → platform convention

	errors: [{
		code:           "err-duplicate-scope"
		name:           "Escopo Duplicado"
		description:    "Já existe aggregate de termos para este contrato+escopo. Use registerTermsRevision para criar nova versão, ou consulte o aggregate existente via searchContractTerms."
		httpStatusCode: 409
		rationale:      "Unicidade de contrato+escopo é invariante do aggregate. 409 porque conflito com recurso existente."
	}, {
		code:           "err-invalid-participant"
		name:           "Participante Não Qualificado"
		description:    "Uma ou mais partes referenciadas não existem ou não estão qualificadas em NPM. Verifique qualificação das partes via NPM antes de submeter registro."
		httpStatusCode: 422
		rationale:      "inv-valid-participant-qualification. 422 porque dados são sintaticamente válidos mas violam regra de negócio."
	}, {
		code:           "err-incomplete-terms"
		name:           "Termos Incompletos"
		description:    "Registro não contém campos obrigatórios: escopo, partes, ao menos uma cláusula e período de vigência. Complete os dados e resubmeta."
		httpStatusCode: 422
		rationale:      "Completude estrutural é pré-condição de registro. 422 por violação de invariante de completude."
	}, {
		code:           "err-invalid-state-transition"
		name:           "Transição de Estado Inválida"
		description:    "Versão não está em estado que permita esta operação. Verifique o estado corrente via getTermsVersion. Transições válidas: draft→active (activateContractTerms), draft|active→cancelled (cancelContractTerms)."
		httpStatusCode: 409
		rationale:      "Lifecycle com transições determinísticas. 409 porque estado corrente conflita com operação solicitada."
	}, {
		code:           "err-supervision-required"
		name:           "Supervisão Requerida"
		description:    "Operação requer token de supervisão humana. Obtenha autorização do supervisor designado e inclua supervision_token no request."
		httpStatusCode: 422
		rationale:      "inv-activation-requires-supervision e inv-cancellation-requires-supervision. 422 (não 403) porque não é falta de permissão de acesso — é ausência de evidência de aprovação de workflow."
	}, {
		code:           "err-invariant-violation"
		name:           "Violação de Invariante de Negócio"
		description:    "Operação viola invariante do domain model. Mensagem inclui ID da invariante violada (e.g., inv-single-active-version) e hint de resolução."
		httpStatusCode: 422
		rationale:      "Catch-all para invariantes não cobertas por erros específicos. 422 por violação de regra de negócio."
	}, {
		code:           "err-aggregate-not-found"
		name:           "Termos Não Encontrados"
		description:    "Não existe aggregate de termos com este ID. Verifique o ID ou use searchContractTerms para localizar por contrato+escopo."
		httpStatusCode: 404
		rationale:      "Aggregate inexistente é erro de domínio (recurso não existe no registry). 404."
	}, {
		code:           "err-version-not-found"
		name:           "Versão Não Encontrada"
		description:    "Aggregate existe mas não possui versão com este número. Use listTermsVersions para consultar versões disponíveis."
		httpStatusCode: 404
		rationale:      "Versão inexistente dentro de aggregate existente. 404."
	}]

	// ==============================
	// DEFAULT AUTH
	// ==============================

	defaultAuth: {
		scheme: "bearer-jwt"
		scopes: ["ctr:read", "ctr:write"]
		rationale: "Bearer JWT como padrão da Mesh. Scopes declaram categorias de acesso disponíveis — plataforma mapeia scopes a operações (ctr:read para queries, ctr:write para commands)."
	}

	rationale: """
		Service contract do CTR derivado do domain model (5 commands,
		5 events, 2 projections, 7 invariants) e do canvas (4 command
		handlers, 1 event consumer, 2 query surfaces, 3 event publishers).
		Superfície sync: 4 commands (register create-async, activate
		action-sync-supervisionado, revision action-async, cancel
		action-sync-supervisionado) + 5 queries (get single, search
		collection, version-pinned single, list-versions collection,
		clauses collection). Superfície async: 3 published events
		(activated, superseded, cancelled) com ordering within-aggregate
		+ 1 consumed event (SourcingDecisionMade de SSC com ACL
		anticorruption-layer). 8 erros de domínio catalogados — erros
		de transporte excluídos (platform policy). getOperationStatus
		excluído — tracking async é platform convention. Red team (3
		rounds) corrigiu registerTermsRevision para ActionCommand
		(concorrência por lineage), versionField para aggregateVersion,
		resolveu ref cross-BC de consumed event, e moveu links
		condicionais para getTermsVersion.
		"""
}
