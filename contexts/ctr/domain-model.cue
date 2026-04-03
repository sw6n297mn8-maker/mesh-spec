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

	// PLACEHOLDER: invariants, valueObjects, aggregates, policies, projections, rationale
	// serão adicionados nos próximos commits parciais.
	invariants: [{
		code:      "inv-single-active-version"
		name:      "Unicidade de Versão Active"
		rule:      "PLACEHOLDER"
		rationale: "PLACEHOLDER"
	}]
	aggregates: [{
		code:        "agg-contract-terms"
		name:        "Contract Terms"
		description: "PLACEHOLDER"
		rootIdentity: {
			field: "contractTermsId"
			type: {kind: "domain-type", type: "ContractTermsId"}
		}
		handlesCommands:    ["cmd-register-contract-terms"]
		emitsEvents:        ["evt-contract-terms-drafted"]
		protectsInvariants: ["inv-single-active-version"]
		rationale: "PLACEHOLDER"
	}]
	rationale: "PLACEHOLDER — domain model parcial, parte 1: events + commands."
}
