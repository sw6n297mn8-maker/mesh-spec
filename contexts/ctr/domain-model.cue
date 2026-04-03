package ctr

// domain-model.cue — Domain Model: Contract & Terms Registry.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Design tático do CTR. Building blocks em ordering behavior-first:
// events → commands → invariants → value objects → aggregate → policies → projections.
//
// Lenses aplicadas:
// - lens-event-driven-architecture-patterns (primária):
//   lifecycle como state machine, visibility internal/published,
//   event sourcing para auditabilidade regulatória
// - lens-contractual-and-legal-architecture (secundária):
//   imutabilidade como invariante jurídica, supervisão de decisões irreversíveis
//
// Decisões de design:
// - Single aggregate (agg-contract-terms): contrato+escopo é o único consistency
//   boundary. Versões são entities internas ao aggregate.
// - ent-terms-version como entity nested: versão é a unidade operacional com
//   lifecycle (draft→active→superseded→expired→cancelled). O aggregate root
//   é o conceito guarda-chuva que agrupa versões.
// - Lifecycle no aggregate representa state machine per-version: cada versão
//   segue o mesmo grafo de estados, gerenciado atomicamente pelo aggregate.
// - cmd-activate-contract-terms dispara duas transições atômicas: draft→active
//   na nova versão e active→superseded na anterior (se existir). Invariante
//   inv-single-active-version é verificada nesta transação.
// - evt-contract-terms-expired é internal, pendente oq-ctr-2 para potencial
//   promoção a published.
// - NPM é dependência sync (query) para validação de participantes — não há
//   evento ACL de NPM. Validação ocorre no processamento de commands de registro.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code: "ctr"
	name: "Contract & Terms Registry Domain Model"

	boundedContextRef: "ctr"

	// =============================================
	// EVENTS (behavior-first: fatos que aconteceram)
	// =============================================

	events: [{
		code:        "evt-contract-terms-drafted"
		name:        "ContractTermsDrafted"
		visibility:  "internal"
		description: "Nova versão de termos registrada em estado draft, por registro inicial (cmd-register-contract-terms) ou revisão (cmd-register-terms-revision). Não cruza fronteira do BC — trigger para workflows internos de preparação e validação."
		rationale:   "Interno porque rascunho não cria obrigação e pode nunca ser ativado. Consumers externos só precisam saber de ativação (evt-contract-terms-activated)."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
			description: "Identificador do aggregate (contrato+escopo)."
		}, {
			kind: "value-object-ref", name: "versionNumber", valueObjectRef: "vo-version-number"
			description: "Número sequencial da versão criada."
		}, {
			kind: "value-object-ref", name: "contractScope", valueObjectRef: "vo-contract-scope"
			description: "Escopo contratual que delimita unicidade."
		}, {
			kind: "value-object-ref", name: "lineage", valueObjectRef: "vo-lineage"
			description: "Referência à versão anterior (null para v1)."
		}]
	}, {
		code:        "evt-contract-terms-activated"
		name:        "ContractTermsActivated"
		visibility:  "published"
		description: "Versão de termos transicionou de draft para active. Sinal cross-context: CMT pode referenciar em novos compromissos, SCF atualiza condições de elegibilidade."
		rationale:   "Evento cross-context mais importante do CTR — sinaliza que nova base jurídica está disponível. Consumers: CMT e SCF conforme canvas outbound."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
		}, {
			kind: "value-object-ref", name: "versionNumber", valueObjectRef: "vo-version-number"
		}, {
			kind: "value-object-ref", name: "contractScope", valueObjectRef: "vo-contract-scope"
		}, {
			kind: "value-object-ref", name: "validityPeriod", valueObjectRef: "vo-validity-period"
			description: "Período de vigência dos termos ativados."
		}, {
			kind: "primitive", name: "activatedAt", type: "datetime"
			description: "Timestamp da ativação."
		}]
	}, {
		code:        "evt-contract-terms-superseded"
		name:        "ContractTermsSuperseded"
		visibility:  "published"
		description: "Versão de termos substituída por nova versão ativada. Sinal para CMT, SCF e DRC que versão referenciada não é mais a active. Compromissos existentes mantêm referência à versão supersedida."
		rationale:   "Evento que completa o ciclo de supersessão. CMT invalida cache, SCF reavalia elegibilidade, DRC registra contexto. Consumers: CMT, SCF, DRC conforme canvas outbound."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
		}, {
			kind: "value-object-ref", name: "supersededVersion", valueObjectRef: "vo-version-number"
			description: "Versão que foi supersedida."
		}, {
			kind: "value-object-ref", name: "newActiveVersion", valueObjectRef: "vo-version-number"
			description: "Nova versão que assumiu como active."
		}]
	}, {
		code:        "evt-contract-terms-cancelled"
		name:        "ContractTermsCancelled"
		visibility:  "published"
		description: "Termos cancelados por decisão supervisionada (fraude, erro, regulatória). Sinal de invalidação para CMT e DRC. Cancelamento é irreversível."
		rationale:   "Evento de invalidação com maior blast radius. Decisão supervisionada por irreversibilidade e impacto cross-context. Consumers: CMT e DRC conforme canvas outbound."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
		}, {
			kind: "value-object-ref", name: "versionNumber", valueObjectRef: "vo-version-number"
		}, {
			kind: "primitive", name: "reason", type: "string"
			description: "Justificativa do cancelamento para auditoria."
		}, {
			kind: "primitive", name: "cancelledAt", type: "datetime"
		}]
	}, {
		code:        "evt-contract-terms-expired"
		name:        "ContractTermsExpired"
		visibility:  "internal"
		description: "Termos transitaram para estado expired por expiração temporal da vigência. Detectado automaticamente por pol-detect-expired-terms. Internal pendente oq-ctr-2 para potencial promoção a published."
		rationale:   "Expiração é fato temporal determinístico. Internal porque canvas oq-ctr-2 ainda não decidiu se consumers devem ser notificados via push (evento published) ou pull (query sob demanda)."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
		}, {
			kind: "value-object-ref", name: "versionNumber", valueObjectRef: "vo-version-number"
		}, {
			kind: "value-object-ref", name: "validityPeriod", valueObjectRef: "vo-validity-period"
			description: "Vigência que expirou."
		}, {
			kind: "primitive", name: "expiredAt", type: "datetime"
		}]
	}]

	// =============================================
	// COMMANDS (intenções de mutação)
	// =============================================

	commands: [{
		code:        "cmd-register-contract-terms"
		name:        "RegisterContractTerms"
		description: "Organização submete registro de termos contratuais com partes, cláusulas, condições e escopo. Async — cria versão v1 em estado draft. Agente valida completude estrutural e existência das partes em NPM."
		rationale:   "Canvas inbound[0]: registro como command async. Validação de participantes em NPM é pré-condição (inv-valid-participant-qualification). Resultado é draft, não active — ativação é decisão supervisionada separada."
		fields: [{
			kind: "value-object-ref", name: "contractScope", valueObjectRef: "vo-contract-scope"
			description: "Contrato + escopo que delimita unicidade."
		}, {
			kind: "domain-type", name: "parties", type: "ContractParties"
			description: "Registrante e contraparte."
		}, {
			kind: "domain-type", name: "clauses", type: "ContractClauseSet"
			description: "Conjunto de cláusulas contratuais."
		}, {
			kind: "value-object-ref", name: "validityPeriod", valueObjectRef: "vo-validity-period"
			description: "Período de vigência pretendido."
		}]
	}, {
		code:        "cmd-activate-contract-terms"
		name:        "ActivateContractTerms"
		description: "Operador ou agente ativa versão de termos após validação completa. Sync — caller recebe confirmação imediata de vigência. Se existir versão active anterior para mesmo contrato+escopo, supersede atomicamente."
		rationale:   "Canvas inbound[1]: ativação como command sync, decisão supervisionada (activate-contract-terms). Transação atômica: draft→active + active→superseded (se aplicável). inv-single-active-version verificada."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
		}, {
			kind: "value-object-ref", name: "versionNumber", valueObjectRef: "vo-version-number"
			description: "Versão a ativar."
		}]
	}, {
		code:        "cmd-register-terms-revision"
		name:        "RegisterTermsRevision"
		description: "Organização submete nova versão de termos para contrato+escopo existente. Async — cria nova versão em draft com lineage para versão anterior. Versão anterior permanece active até nova versão ser ativada."
		rationale:   "Canvas inbound[2]: revisão como command async. Lineage explícito garante rastreabilidade. Nova versão herda escopo do aggregate."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
		}, {
			kind: "domain-type", name: "clauses", type: "ContractClauseSet"
			description: "Novas cláusulas contratuais."
		}, {
			kind: "value-object-ref", name: "validityPeriod", valueObjectRef: "vo-validity-period"
			description: "Novo período de vigência."
		}]
	}, {
		code:        "cmd-cancel-contract-terms"
		name:        "CancelContractTerms"
		description: "Operador cancela versão de termos por invalidação (fraude, erro, regulatória). Sync — estado terminal irreversível. Supervisionado por impacto cross-context."
		rationale:   "Canvas inbound[3]: cancelamento como command sync, decisão supervisionada (cancel-contract-terms). Irreversibilidade satisfaz critério de reversibilityThreshold."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
		}, {
			kind: "value-object-ref", name: "versionNumber", valueObjectRef: "vo-version-number"
			description: "Versão a cancelar."
		}, {
			kind: "primitive", name: "reason", type: "string"
			description: "Justificativa para auditoria."
		}]
	}, {
		code:        "cmd-expire-contract-terms"
		name:        "ExpireContractTerms"
		description: "Transiciona versão de termos para estado expired por expiração temporal da vigência. Command interno emitido por pol-detect-expired-terms. Decisão autônoma — expiração é determinística."
		rationale:   "Canvas autonomous decision: detect-expired-terms. Expiração é evento temporal sem margem para erro de julgamento. Command separado de cancelamento porque semântica é diferente (prazo natural vs invalidação)."
		fields: [{
			kind: "value-object-ref", name: "contractTermsId", valueObjectRef: "vo-contract-terms-id"
		}, {
			kind: "value-object-ref", name: "versionNumber", valueObjectRef: "vo-version-number"
		}]
	}]

	// =============================================
	// INVARIANTS (regras que nunca podem ser violadas)
	// =============================================

	invariants: [{
		code:      "inv-single-active-version"
		name:      "Unicidade de Versão Active"
		rule:      "Para um mesmo contrato+escopo, exatamente uma versão de termos pode estar no estado active simultaneamente. Ativação de nova versão automaticamente supersede a anterior."
		rationale: "Invariante central do CTR. Ambiguidade sobre qual versão é vigente criaria disputas irresolvíveis em DRC, precificação incorreta em SCF e referência ambígua em CMT. bd-single-active-version."
	}, {
		code:      "inv-post-activation-immutability"
		name:      "Imutabilidade Pós-Ativação"
		rule:      "Nenhum campo de uma versão de termos pode ser alterado após transição para estado active. Qualquer mudança requer RegisterTermsRevision que cria nova versão em draft."
		rationale: "Invariante que garante reconstrução temporal e auditoria regulatória. Sem imutabilidade, reconstituição de 'quais termos estavam vigentes na data X' é impossível. bd-terms-immutability."
	}, {
		code:      "inv-activation-requires-supervision"
		name:      "Ativação Requer Supervisão Humana"
		rule:      "Nenhuma versão de termos transiciona de draft para active sem autorização de supervisão humana. Agente prepara e recomenda; gate de supervisão autoriza."
		rationale: "Ativação cria base jurídica para compromissos em CMT e elegibilidade em SCF. Canvas classifica activate-contract-terms como supervisedDecision. P10: agentes recomendam, gates validam."
	}, {
		code:      "inv-cancellation-requires-supervision"
		name:      "Cancelamento Requer Supervisão Humana"
		rule:      "Nenhuma versão de termos transiciona para estado cancelled sem supervisão humana. Cancelamento é terminal e irreversível — afeta compromissos existentes downstream."
		rationale: "Canvas classifica cancel-contract-terms como supervisedDecision. Irreversibilidade satisfaz reversibilityThreshold. P10 exige gate humano para decisões com impacto cross-context irreversível."
	}, {
		code:      "inv-valid-participant-qualification"
		name:      "Participantes Qualificados em NPM"
		rule:      "Registro de termos contratuais só é aceito se todas as partes referenciadas existem e estão qualificadas em NPM. Validação sync via QueryParticipantStatus."
		rationale: "Canvas autonomous decision: validate-participant-qualification. Canvas query dependency: NPM. Termos com partes não qualificadas são risco jurídico."
	}, {
		code:      "inv-lineage-integrity"
		name:      "Integridade de Lineage"
		rule:      "Cada versão criada por RegisterTermsRevision deve referenciar exatamente a versão anterior existente. Lineage forma cadeia linear sem gaps nem branching."
		rationale: "Lineage é mecanismo de reconstrução temporal. Cadeia quebrada impediria regulador de reconstruir evolução contratual. as-ctr-1 assume lineage linear."
	}, {
		code:      "inv-draft-only-mutable"
		name:      "Apenas Draft Aceita Modificação"
		rule:      "Somente versões em estado draft aceitam mutação in-place de seus campos. Versões em active, superseded, expired e cancelled são imutáveis. cmd-register-terms-revision não viola esta invariante: cria nova versão em draft, sem alterar a versão existente."
		rationale: "Corolário de inv-post-activation-immutability estendido a todos os estados não-draft. Garante que o único ponto de mutação é antes da ativação."
	}]

	// =============================================
	// VALUE OBJECTS (tipos imutáveis sem identidade)
	// =============================================

	valueObjects: [{
		code:        "vo-contract-terms-id"
		name:        "ContractTermsId"
		description: "Identificador canônico do aggregate — representa um contrato+escopo único. Gerado no momento do primeiro registro."
		fields: [{
			kind: "primitive", name: "value", type: "string"
			description: "Valor do identificador. Formato definido em runtime."
		}]
		rationale: "Value object porque é imutável após criação e definido exclusivamente pelo valor. Identidade do aggregate root."
	}, {
		code:        "vo-version-number"
		name:        "VersionNumber"
		description: "Número sequencial de uma versão de termos dentro do aggregate. Monotonicamente crescente (v1, v2, v3...)."
		fields: [{
			kind: "primitive", name: "value", type: "integer"
			description: "Número da versão. Positivo, sequencial."
		}]
		rationale: "Value object porque é imutável e definido pelo valor numérico. Identidade da entity ent-terms-version dentro do aggregate."
	}, {
		code:        "vo-terms-state"
		name:        "TermsState"
		description: "Estado canônico no lifecycle de uma versão de termos: draft, active, superseded, expired, cancelled."
		fields: [{
			kind: "primitive", name: "value", type: "string"
			description: "Um dos estados válidos: draft, active, superseded, expired, cancelled."
		}]
		constraints: [
			"value deve ser um dos: draft, active, superseded, expired, cancelled",
		]
		rationale: "Value object porque cada transição cria novo valor imutável. Alinhado com glossário term-estado-de-termos."
	}, {
		code:        "vo-contract-scope"
		name:        "ContractScope"
		description: "Par contrato+escopo que delimita a unicidade de versão active. Combina identificador externo do contrato com descrição do escopo."
		fields: [{
			kind: "primitive", name: "contractId", type: "string"
			description: "Identificador externo do contrato."
		}, {
			kind: "primitive", name: "scopeDescription", type: "string"
			description: "Descrição do escopo: 'fornecimento de concreto', 'serviço de bombeamento'."
		}]
		rationale: "Value object que materializa glossário term-escopo-contratual. Sem escopo, cada contrato teria apenas um conjunto de termos — insuficiente para contratos de obra com múltiplos escopos."
	}, {
		code:        "vo-validity-period"
		name:        "ValidityPeriod"
		description: "Intervalo temporal de vigência dos termos. Data de início (ativação) e data de fim (expiração natural)."
		fields: [{
			kind: "primitive", name: "startDate", type: "date"
			description: "Data de início da vigência."
		}, {
			kind: "primitive", name: "endDate", type: "date"
			description: "Data de expiração natural. Obrigatória no modelo atual — as-ctr-3 assume que expiração por data é suficiente. Contratos com prazo indefinido são invalidation signal dessa assumption."
		}]
		rationale: "Value object que materializa glossário term-vigencia. Campo que governa expiração automática (pol-detect-expired-terms)."
	}, {
		code:        "vo-lineage"
		name:        "Lineage"
		description: "Referência à versão anterior na cadeia de evolução contratual. Null para v1 (primeira versão). Forma cadeia linear: v1→v2→v3."
		fields: [{
			kind: "value-object-ref", name: "previousVersion", valueObjectRef: "vo-version-number"
			description: "Número da versão anterior. Para v1 (primeira versão), o value object vo-lineage não é instanciado — o campo lineage da entity é semanticamente vazio."
		}]
		rationale: "Value object que materializa glossário term-lineage. inv-lineage-integrity garante integridade da cadeia."
	}, {
		code:        "vo-contract-clause"
		name:        "ContractClause"
		description: "Sub-unidade dos termos contratuais: condição específica (SLA, retenção, penalidade, garantia). Consultável individualmente via prj-contract-clauses-view."
		fields: [{
			kind: "primitive", name: "clauseId", type: "string"
			description: "Identificador da cláusula dentro da versão."
		}, {
			kind: "primitive", name: "type", type: "string"
			description: "Tipo: sla, retention, penalty, warranty, cancellation."
		}, {
			kind: "primitive", name: "description", type: "string"
			description: "Descrição da condição em linguagem natural."
		}, {
			kind: "primitive", name: "value", type: "string"
			description: "Valor paramétrico: '48h', '5%', '0.5%/dia', '12 meses'."
		}]
		rationale: "Value object que materializa glossário term-clausula-contratual. DRC referencia cláusulas específicas em disputas — QueryContractClauses existe por essa necessidade."
	}]

	// =============================================
	// AGGREGATE (consistency boundary)
	// =============================================

	aggregates: [{
		code:        "agg-contract-terms"
		name:        "Contract Terms"
		description: "Aggregate root do registry de termos contratuais. Único consistency boundary do CTR. Agrupa versões imutáveis por contrato+escopo. O lifecycle operacional vive em cada ent-terms-version; o aggregate gerencia invariantes cross-version (unicidade de active, lineage)."

		rootIdentity: {
			field: "contractTermsId"
			type: {kind: "value-object-ref", valueObjectRef: "vo-contract-terms-id"}
		}

		fields: [{
			kind: "value-object-ref", name: "contractScope", valueObjectRef: "vo-contract-scope"
			description: "Contrato+escopo que delimita este aggregate."
		}, {
			kind: "primitive", name: "createdAt", type: "datetime"
		}]

		handlesCommands: [
			"cmd-register-contract-terms",
			"cmd-activate-contract-terms",
			"cmd-register-terms-revision",
			"cmd-cancel-contract-terms",
			"cmd-expire-contract-terms",
		]

		emitsEvents: [
			"evt-contract-terms-drafted",
			"evt-contract-terms-activated",
			"evt-contract-terms-superseded",
			"evt-contract-terms-cancelled",
			"evt-contract-terms-expired",
		]

		protectsInvariants: [
			"inv-single-active-version",
			"inv-post-activation-immutability",
			"inv-activation-requires-supervision",
			"inv-cancellation-requires-supervision",
			"inv-valid-participant-qualification",
			"inv-lineage-integrity",
			"inv-draft-only-mutable",
		]

		entities: [{
			code:        "ent-terms-version"
			name:        "Terms Version"
			description: "Entidade operacional do CTR — instância imutável e numerada de termos contratuais. Cada versão tem lifecycle próprio (draft→active→superseded→expired→cancelled). O aggregate gerencia a coleção e invariantes cross-version."

			identity: {
				field: "versionNumber"
				type: {kind: "value-object-ref", valueObjectRef: "vo-version-number"}
			}

			fields: [{
				kind: "value-object-ref", name: "state", valueObjectRef: "vo-terms-state"
				description: "Estado corrente desta versão no lifecycle."
			}, {
				kind: "value-object-ref", name: "validityPeriod", valueObjectRef: "vo-validity-period"
				description: "Período de vigência."
			}, {
				kind: "value-object-ref", name: "lineage", valueObjectRef: "vo-lineage"
				description: "Referência à versão anterior."
			}, {
				kind: "primitive", name: "activatedAt", type: "datetime"
				description: "Timestamp de ativação. Null para versões nunca ativadas."
			}, {
				kind: "primitive", name: "createdAt", type: "datetime"
			}]

			usesValueObjects: [
				"vo-terms-state",
				"vo-validity-period",
				"vo-lineage",
				"vo-contract-clause",
			]

			rationale: "Entity porque tem identidade (versionNumber) e lifecycle com transições. Nested no aggregate porque não existe sem o contexto de contrato+escopo. Não é aggregate separado porque inv-single-active-version é invariante cross-version que exige transacionalidade no aggregate pai."
		}]

		usesValueObjects: [
			"vo-contract-terms-id",
			"vo-version-number",
			"vo-terms-state",
			"vo-contract-scope",
			"vo-validity-period",
			"vo-lineage",
			"vo-contract-clause",
		]

		lifecycle: {
			initialState: "draft"

			states: ["draft", "active", "superseded", "expired", "cancelled"]

			transitions: [{
				from:               "draft"
				to:                 "active"
				triggeredByCommand: "cmd-activate-contract-terms"
				emitsEvents:       ["evt-contract-terms-activated"]
				guards:            ["inv-single-active-version", "inv-activation-requires-supervision"]
				description:       "Ativação supervisionada da versão-alvo (draft→active). Esta transição opera na versão sendo ativada. Se existir versão active anterior no mesmo aggregate, o aggregate coordena atomicamente a transição active→superseded na versão anterior (duas entities distintas mutadas na mesma transação)."
			}, {
				from:               "active"
				to:                 "superseded"
				triggeredByCommand: "cmd-activate-contract-terms"
				emitsEvents:       ["evt-contract-terms-superseded"]
				guards:            ["inv-single-active-version"]
				description:       "Supersessão da versão anteriormente active quando nova versão é ativada. Esta transição opera na versão sendo substituída, coordenada atomicamente pelo aggregate junto com draft→active na versão-alvo. Duas entities distintas (anterior e nova) são mutadas na mesma transação."
			}, {
				from:               "active"
				to:                 "expired"
				triggeredByCommand: "cmd-expire-contract-terms"
				emitsEvents:       ["evt-contract-terms-expired"]
				description:       "Expiração temporal automática. Decisão autônoma (detect-expired-terms)."
			}, {
				from:               "active"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-contract-terms"
				emitsEvents:       ["evt-contract-terms-cancelled"]
				guards:            ["inv-cancellation-requires-supervision"]
				description:       "Cancelamento supervisionado de versão active. Irreversível — estado terminal."
			}, {
				from:               "draft"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-contract-terms"
				emitsEvents:       ["evt-contract-terms-cancelled"]
				guards:            ["inv-cancellation-requires-supervision"]
				description:       "Cancelamento de draft antes de ativação."
			}]
		}

		rationale: "Single aggregate porque contrato+escopo é o único consistency boundary. Versões são entities internas (ent-terms-version) gerenciadas atomicamente. Cada entity tem lifecycle próprio (mesmo grafo de estados) — o aggregate não tem estado de lifecycle próprio, apenas coordena transições cross-entity. inv-single-active-version exige transacionalidade cross-version. cmd-activate-contract-terms é o caso crítico: o aggregate muta duas entities distintas na mesma transação (draft→active na nova, active→superseded na anterior). NPM validation é sync no processamento de commands de registro — sem evento ACL."
	}]

	// =============================================
	// POLICIES (automação event → command)
	// =============================================

	policies: [{
		code:             "pol-detect-expired-terms"
		name:             "Detecção de Termos Expirados"
		description:      "Ao ativar termos com vigência finita, agenda verificação para data de expiração. Na data, emite cmd-expire-contract-terms. O command verifica que a versão ainda está em estado active antes de transicionar — se já foi supersedida ou cancelada, o command é descartado (idempotente). Decisão autônoma — expiração temporal é determinística."
		triggeredByEvent: "evt-contract-terms-activated"
		issuesCommand:    "cmd-expire-contract-terms"
		rationale:        "Canvas autonomous decision: detect-expired-terms. Usa evt-contract-terms-activated como trigger de scheduling: ao ativar termos com endDate, agenda verificação temporal. Expiração não requer julgamento — data de fim atingida é condição binária. Guard implícito: cmd-expire-contract-terms só transiciona versão em estado active. Versão já supersedida (por nova ativação) ou cancelada é caso de no-op idempotente."
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-contract-terms-view"
		name:        "Contract Terms View"
		description: "Projeção que materializa estado corrente dos termos para consulta por BCs downstream."

		consumesEvents: [
			"evt-contract-terms-drafted",
			"evt-contract-terms-activated",
			"evt-contract-terms-superseded",
			"evt-contract-terms-cancelled",
			"evt-contract-terms-expired",
		]

		queryCapabilities: [{
			code:        "qry-contract-terms"
			description: "Retorna termos contratuais por ID+versão (version-pinned) ou pela versão active de contrato+escopo. Interface primária consumida por CMT, SCF e DRC."
			rationale:   "Canvas query-surface: QueryContractTerms. 3 BCs downstream consomem."
		}]

		rationale: "Projeção necessária porque aggregate é otimizado para escrita (event sourced). Leitura por BCs downstream usa projeção. Suporta query por version-pin e por active."
	}, {
		code:        "prj-contract-clauses-view"
		name:        "Contract Clauses View"
		description: "Projeção que materializa cláusulas individuais para consulta granular. Otimizada para DRC que referencia cláusulas específicas em disputas."

		consumesEvents: [
			"evt-contract-terms-drafted",
			"evt-contract-terms-activated",
			"evt-contract-terms-superseded",
			"evt-contract-terms-cancelled",
			"evt-contract-terms-expired",
		]

		queryCapabilities: [{
			code:        "qry-contract-clauses"
			description: "Retorna cláusulas específicas de termos por ID+versão+tipo. Interface consumida por DRC para base jurídica de disputas."
			rationale:   "Canvas query-surface: QueryContractClauses. DRC consome para resolução contra cláusulas específicas."
		}]

		rationale: "Projeção separada porque query pattern é diferente: termos retornam conjunto completo, cláusulas retornam sub-unidades filtráveis por tipo. DRC precisa de cláusula específica, não do aggregate inteiro."
	}]

	rationale: """
		Domain model do CTR com single aggregate (Contract Terms) como único
		consistency boundary. Behavior-first: 5 events (1 interno draft,
		3 published lifecycle, 1 interno expiração pendente oq-ctr-2),
		5 commands (register async, activate sync supervisionado, revision
		async, cancel sync supervisionado, expire interno autônomo),
		7 invariants (unicidade de active, imutabilidade pós-ativação,
		supervisão de ativação e cancelamento, qualificação de participantes
		em NPM, integridade de lineage, mutabilidade restrita a draft).
		7 value objects (ContractTermsId, VersionNumber, TermsState,
		ContractScope, ValidityPeriod, Lineage, ContractClause).
		1 entity nested (ent-terms-version — unidade operacional com
		lifecycle). Lifecycle com 5 estados e 5 transições —
		cmd-activate-contract-terms dispara duas transições atômicas
		(draft→active e active→superseded). 1 policy (detecção de
		expiração temporal). 2 projections habilitam QueryContractTerms
		e QueryContractClauses. Alinhado com canvas, glossário e design
		principles (P0, P1, P3, P6, P10).
		"""
}
