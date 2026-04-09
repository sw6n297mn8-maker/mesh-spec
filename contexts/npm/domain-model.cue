package npm

// domain-model.cue — Domain Model: Network Participant Management.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Single aggregate (Participant) com lifecycle de 4 estados.
// Behavior-first: events → commands → invariants → value objects → aggregate.
//
// Eventos ACL (sufixo -received): traduzidos pela camada ACL de sinais
// externos, listados em emitsEvents do aggregate para satisfazer
// tq-dm-02 (padrão estabelecido em CMT). Semanticamente produzidos
// pelo ACL adapter, não pelo aggregate.
//
// NetworkGrowthTargetDefined (NGR) não modelado como domain event —
// sinal operacional que afeta capacidade de onboarding, não estado
// do aggregate Participant. tq-dm-15 warn aceito.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code:              "npm"
	name:              "Domain Model NPM — Network Participant Management"
	boundedContextRef: "npm"

	// ══════════════════════════════════════════════════════════
	// EVENTS — published (lifecycle + registro)
	// ══════════════════════════════════════════════════════════

	events: [{
		code:        "evt-participant-registered"
		name:        "ParticipantRegistered"
		visibility:  "published"
		description: "Novo participante registrado em estado pending. Consumido por NGR (métricas de crescimento), REW (modelo de risco baseline) e NIM (topologia). Context-map referencia como NetworkParticipantOnboarded."
		rationale:   "Sinal de criação de entidade — distinto de transições de status. NGR precisa para funil de conversão independente do resultado da qualificação."
	}, {
		code:        "evt-participant-qualified"
		name:        "ParticipantQualified"
		visibility:  "published"
		description: "Participante transicionou para qualified após aprovação supervisionada de KYC/AML. Consumido por REW (modelos de risco), NIM (topologia) e SSC (sourcing). CTR consome status via query sync, não via evento."
		rationale:   "Evento cross-context mais importante do NPM — habilita operações downstream. Granular (não genérico StatusChanged) porque consumers distinguem tipo de transição sem parsear payload."
	}, {
		code:        "evt-participant-suspended"
		name:        "ParticipantSuspended"
		visibility:  "published"
		description: "Participante bloqueado temporariamente por irregularidade. Consumido por REW (scoring), NIM (nó indisponível) e SSC (remove de sourcing pool)."
		rationale:   "Suspensão afeta todo o ecosystem downstream — sinal explícito e imediato para cada consumer atualizar modelo."
	}, {
		code:        "evt-participant-terminated"
		name:        "ParticipantTerminated"
		visibility:  "published"
		description: "Participante excluído definitivamente da rede. Consumido por REW (arquiva modelo), NIM (remove nó) e SSC (exclui de sourcing). Publicação para CMT pendente (oq-npm-3)."
		rationale:   "Terminação é irreversível — evento documenta decisão definitiva com justificativa para trail auditável."
	}, {
		code:        "evt-participant-reactivated"
		name:        "ParticipantReactivated"
		visibility:  "published"
		description: "Participante reabilitado após resolução de irregularidade. Consumido por REW (reavalia scoring), NIM (reativa nó) e SSC (reincorpora em sourcing)."
		rationale:   "Reversão de suspensão é sinal distinto — consumers precisam diferenciar de qualificação inicial para atualizar modelos."

	// ══════════════════════════════════════════════════════════
	// EVENTS — internal (workflow)
	// ══════════════════════════════════════════════════════════

	}, {
		code:        "evt-qualification-documents-received"
		name:        "QualificationDocumentsReceived"
		visibility:  "internal"
		description: "Documentação KYC/AML recebida e registrada. Evento interno — não publicado. Sinaliza prontidão para verificação."
		rationale:   "Fato interno que marca recepção de documentação. Não cruza fronteira porque submissão de docs não é sinal relevante para consumers externos."

	// ══════════════════════════════════════════════════════════
	// EVENTS — internal ACL (traduzidos de BCs externos)
	// ══════════════════════════════════════════════════════════

	}, {
		code:          "evt-identity-verification-received"
		name:          "IdentityVerificationReceived"
		visibility:    "internal"
		sourceContext: "idc"
		description:   "Tradução ACL de IdentityVerificationCompleted (IDC). Registra no NPM a tradução interna do resultado de verificação de identidade recebido de IDC. Evento inicia fluxo; query pull (QueryIdentityVerificationStatus) confirma no momento da decisão."
		rationale:     "Integração dual com IDC: evento push como trigger, query pull como SoT. Em divergência, query prevalece. Sufixo -received segue convenção ACL estabelecida em CMT."
	}]

	// ══════════════════════════════════════════════════════════
	// COMMANDS
	// ══════════════════════════════════════════════════════════

	commands: [{
		code:        "cmd-register-participant"
		name:        "RegisterParticipant"
		description: "Inicia ciclo de vida do participante em estado pending. Recebe dados cadastrais, valida completude. Async — não depende de resposta imediata. Decisão autônoma do agente."
		rationale:   "Ponto de entrada canônico no lifecycle. Autônomo porque validação de completude cadastral é determinística."
	}, {
		code:        "cmd-submit-qualification-documents"
		name:        "SubmitQualificationDocuments"
		description: "Recebe documentação KYC/AML do participante. Async — documentação entra em fila de verificação. Decisão autônoma para recepção."
		rationale:   "Separado de aprovação porque recepção é autônoma (validação de formato/completude) enquanto aprovação é supervisionada."
	}, {
		code:        "cmd-approve-qualification"
		name:        "ApproveQualification"
		description: "Transiciona participante de pending para qualified. Sync — supervisor precisa de confirmação imediata. Pré-condição: query a IDC confirma verificação de identidade."
		rationale:   "Gate de qualificação materializado como command supervisionado. Sync por exigência de feedback imediato ao supervisor que autoriza."
	}, {
		code:        "cmd-suspend-participant"
		name:        "SuspendParticipant"
		description: "Transiciona participante de qualified para suspended. Sync — supervisor autoriza bloqueio temporário. Reversível via ReactivateParticipant."
		rationale:   "Suspensão afeta ecosystem downstream — supervisão garante que decisão é justificada e documentada."
	}, {
		code:        "cmd-reactivate-participant"
		name:        "ReactivateParticipant"
		description: "Transiciona participante de suspended para qualified. Sync — supervisor autoriza reativação após resolução de irregularidade."
		rationale:   "Reversão de suspensão exige supervisão — confirmar que irregularidade foi resolvida antes de reabilitar operações."
	}, {
		code:        "cmd-terminate-participant"
		name:        "TerminateParticipant"
		description: "Transiciona participante de qualified, suspended ou pending para terminated. Exclui definitivamente da rede. Async — decisão supervisionada com processamento que pode envolver reavaliação de entidades vinculadas. Irreversível."
		rationale:   "Sanção máxima — irreversibilidade exige documentação e supervisão (dp-10). Async porque pode disparar reavaliação em cascata."
	}, {
		code:        "cmd-record-identity-verification"
		name:        "RecordIdentityVerification"
		description: "Command interno: registra resultado de verificação de identidade recebido de IDC via ACL. Atualiza flag de verificação no aggregate para uso posterior por ApproveQualification."
		rationale:   "Materializa recepção do evento ACL como mutação no aggregate, seguindo padrão policy event→command (CMT). Não é command de fronteira — não aparece no canvas."
	}]

	// ══════════════════════════════════════════════════════════
	// INVARIANTS
	// ══════════════════════════════════════════════════════════

	invariants: [{
		code:      "inv-qualification-gate"
		name:      "Gate de Qualificação Binário"
		rule:      "Participante opera na rede em 4 estados internos (pending, qualified, suspended, terminated). Para operações contratuais e financeiras, o gate é binário: apenas participantes com status qualified são referenciáveis por CTR para registro de termos. Observação por BCs downstream (scoring em REW, topologia em NIM) não é restrita pelo gate — esses BCs referenciam participantes em qualquer estado."
		rationale: "bd-qualification-as-gate. Gate binário simplifica validação downstream e elimina estados intermediários manipuláveis. Distinção operação vs observação evita que o gate bloqueie scoring e topologia."
	}, {
		code:      "inv-approval-requires-identity-verification"
		name:      "Aprovação Requer Verificação de Identidade"
		rule:      "ApproveQualification só pode ser executado se verificação de identidade em IDC estiver confirmada. Query a QueryIdentityVerificationStatus prevalece sobre evento previamente recebido em caso de divergência."
		rationale: "Integração dual com IDC: evento push notifica, query pull confirma no momento da decisão. Query como autoridade garante consistência temporal."
	}, {
		code:      "inv-termination-irreversible"
		name:      "Terminação Irreversível"
		rule:      "Participante em estado terminated não pode transicionar para nenhum outro estado. Terminated é estado final do lifecycle — sem transição de saída."
		rationale: "Irreversibilidade é propriedade intencional — terminação é sanção máxima. dp-10 exige justificativa documentada para decisão irreversível."
	}, {
		code:      "inv-supervision-required-for-material-decisions"
		name:      "Supervisão Obrigatória para Decisões Materiais"
		rule:      "ApproveQualification, SuspendParticipant, ReactivateParticipant e TerminateParticipant exigem autorização de supervisor humano. Agente recomenda e prepara, humano autoriza."
		rationale: "Decisões que alteram capacidade operacional de organizações na rede têm blast radius alto. mech-agent-gate garante que agente não decide unilateralmente."
	}, {
		code:      "inv-registration-completeness"
		name:      "Completude Cadastral no Registro"
		rule:      "RegisterParticipant requer dados cadastrais mínimos completos (CNPJ, razão social, dados de contato). Registro incompleto é rejeitado antes de criar entidade."
		rationale: "Validação de completude é autônoma e determinística — previne criação de participantes sem dados mínimos para qualificação subsequente."
	}, {
		code:      "inv-single-active-identity"
		name:      "Unicidade de Identidade Ativa"
		rule:      "Não pode existir mais de um participante ativo (pending, qualified, suspended) para o mesmo CNPJ. Re-registro após terminação cria novo participante com novo lifecycle."
		rationale: "Previne duplicidade que contornaria terminação. Participante terminado que deseja retornar passa por qualificação completa como novo registro."
	}]

	// ══════════════════════════════════════════════════════════
	// VALUE OBJECTS
	// ══════════════════════════════════════════════════════════

	valueObjects: [{
		code:        "vo-participant-id"
		name:        "ParticipantId"
		description: "Identificador canônico do participante, gerado por NPM no momento do registro. Referenciado por BCs downstream (CTR, REW, NIM, SSC) como chave de lookup."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
			description: "Identificador único no formato definido por NPM."
		}]
		rationale: "Identidade gerada na origem (NPM) garante unicidade sem dependência externa. BCs downstream usam este ID para queries e correlação de eventos."
	}, {
		code:        "vo-participant-status"
		name:        "ParticipantStatus"
		description: "Estado canônico do participante: 4 estados internos (pending, qualified, suspended, terminated). Value object imutável que representa estado atual e data da última transição. Externamente, o gate de qualificação opera como binário: qualified habilita operações contratuais e financeiras; qualquer outro estado impede. Observação por REW, NIM e SSC não é restrita pelo gate."
		fields: [{
			kind: "primitive"
			name: "state"
			type: "string"
			description: "Estado atual: pending | qualified | suspended | terminated."
		}, {
			kind: "primitive"
			name: "since"
			type: "datetime"
			description: "Data/hora da última transição de estado."
		}]
		constraints: ["state ∈ {pending, qualified, suspended, terminated}"]
		rationale: "Status tipado como value object garante transições explícitas e auditáveis. 4 estados internos com semântica de gate binário externamente — CTR consulta um boolean, não tiers."
	}, {
		code:        "vo-participant-profile"
		name:        "ParticipantProfile"
		description: "Visão composta do participante para consumers: dados cadastrais, histórico de qualificação, estado atual. Exposto via QueryParticipantProfile para SSC (decisão de sourcing). REW obtém dados equivalentes via eventos de lifecycle, não via query (npm-to-rew é async-only)."
		fields: [{
			kind:           "value-object-ref"
			name:           "participantId"
			valueObjectRef: "vo-participant-id"
		}, {
			kind:           "value-object-ref"
			name:           "currentStatus"
			valueObjectRef: "vo-participant-status"
		}, {
			kind: "domain-type"
			name: "cadastralData"
			type: "CadastralData"
			description: "Dados cadastrais da organização (razão social, CNPJ, endereço, contato)."
		}, {
			kind: "domain-type"
			name: "qualificationHistory"
			type: "QualificationHistory"
			description: "Histórico de qualificações, suspensões e reativações com datas e justificativas."
		}]
		rationale: "Perfil agrega informações em visão coesa para consumers. SSC consome via query sync; REW obtém dados via eventos de lifecycle (async-only no context-map)."
	}, {
		code:        "vo-qualification-result"
		name:        "QualificationResult"
		description: "Resultado da avaliação KYC/AML: resultado binário da decisão supervisionada, justificativa documentada, data da decisão. Imutável após produção."
		fields: [{
			kind: "primitive"
			name: "approved"
			type: "boolean"
			description: "Resultado binário da qualificação — qualified ou não."
		}, {
			kind: "primitive"
			name: "justification"
			type: "string"
			description: "Justificativa documentada pelo supervisor."
		}, {
			kind: "primitive"
			name: "decidedAt"
			type: "datetime"
			description: "Data/hora da decisão de qualificação."
		}]
		rationale: "Resultado como value object imutável garante trail auditável. Armazenado no aggregate para consulta posterior sem necessidade de reconstruir decisão."
	}]

	// ══════════════════════════════════════════════════════════
	// AGGREGATE
	// ══════════════════════════════════════════════════════════

	aggregates: [{
		code:        "agg-participant"
		name:        "Participant"
		description: "Aggregate root do NPM. Representa uma organização participante da rede com ciclo de vida de qualificação. Boundary de consistência: transições de estado, verificações e decisões de qualificação são atômicas dentro deste aggregate."

		rootIdentity: {
			field: "participantId"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-participant-id"
			}
		}

		fields: [{
			kind: "primitive"
			name: "cnpj"
			type: "string"
			description: "CNPJ da organização — chave de negócio para unicidade (inv-single-active-identity)."
		}, {
			kind: "domain-type"
			name: "cadastralData"
			type: "CadastralData"
			description: "Dados cadastrais completos da organização."
		}, {
			kind:           "value-object-ref"
			name:           "currentStatus"
			valueObjectRef: "vo-participant-status"
		}, {
			kind: "primitive"
			name: "identityVerified"
			type: "boolean"
			description: "Flag atualizada por RecordIdentityVerification (policy ACL). Consultada como pré-condição de ApproveQualification (inv-approval-requires-identity-verification)."
		}, {
			kind:           "value-object-ref"
			name:           "lastQualificationResult"
			valueObjectRef: "vo-qualification-result"
			description:    "Último resultado de qualificação, se existir."
		}]

		handlesCommands: [
			"cmd-register-participant",
			"cmd-submit-qualification-documents",
			"cmd-approve-qualification",
			"cmd-suspend-participant",
			"cmd-reactivate-participant",
			"cmd-terminate-participant",
			"cmd-record-identity-verification",
		]

		emitsEvents: [
			// Published — lifecycle + registro
			"evt-participant-registered",
			"evt-participant-qualified",
			"evt-participant-suspended",
			"evt-participant-terminated",
			"evt-participant-reactivated",
			// Internal — workflow
			"evt-qualification-documents-received",
			// Internal ACL — traduzido de IDC, listado aqui para
			// satisfazer tq-dm-02 (padrão CMT). Semanticamente
			// produzido pela camada ACL, não pelo aggregate.
			"evt-identity-verification-received",
		]

		protectsInvariants: [
			"inv-qualification-gate",
			"inv-approval-requires-identity-verification",
			"inv-termination-irreversible",
			"inv-supervision-required-for-material-decisions",
			"inv-registration-completeness",
			"inv-single-active-identity",
		]

		usesValueObjects: [
			"vo-participant-id",
			"vo-participant-status",
			"vo-qualification-result",
		]

		lifecycle: {
			initialState: "pending"
			states: ["pending", "qualified", "suspended", "terminated"]
			transitions: [{
				from:               "pending"
				to:                 "qualified"
				triggeredByCommand: "cmd-approve-qualification"
				emitsEvents:        ["evt-participant-qualified"]
				guards:             ["inv-approval-requires-identity-verification", "inv-supervision-required-for-material-decisions"]
				description:        "Participante aprovado após KYC/AML supervisionado. Habilita operações contratuais e financeiras na rede."
			}, {
				from:               "qualified"
				to:                 "suspended"
				triggeredByCommand: "cmd-suspend-participant"
				emitsEvents:        ["evt-participant-suspended"]
				guards:             ["inv-supervision-required-for-material-decisions"]
				description:        "Suspensão por irregularidade detectada. Bloqueio temporário reversível."
			}, {
				from:               "suspended"
				to:                 "qualified"
				triggeredByCommand: "cmd-reactivate-participant"
				emitsEvents:        ["evt-participant-reactivated"]
				guards:             ["inv-supervision-required-for-material-decisions"]
				description:        "Reativação após resolução documentada de irregularidade."
			}, {
				from:               "qualified"
				to:                 "terminated"
				triggeredByCommand: "cmd-terminate-participant"
				emitsEvents:        ["evt-participant-terminated"]
				guards:             ["inv-termination-irreversible", "inv-supervision-required-for-material-decisions"]
				description:        "Terminação definitiva a partir de estado ativo. Irreversível."
			}, {
				from:               "suspended"
				to:                 "terminated"
				triggeredByCommand: "cmd-terminate-participant"
				emitsEvents:        ["evt-participant-terminated"]
				guards:             ["inv-termination-irreversible", "inv-supervision-required-for-material-decisions"]
				description:        "Terminação definitiva a partir de suspensão. Irreversível."
			}, {
				from:               "pending"
				to:                 "terminated"
				triggeredByCommand: "cmd-terminate-participant"
				emitsEvents:        ["evt-participant-terminated"]
				guards:             ["inv-termination-irreversible", "inv-supervision-required-for-material-decisions"]
				description:        "Terminação de participante pendente — fraude descoberta durante onboarding ou determinação regulatória antes da qualificação. Irreversível."
			}]
		}

		rationale: "Single aggregate porque participante é a única boundary de consistência do NPM. Todas as transições de lifecycle são atômicas, incluindo pending→terminated para fraude descoberta durante onboarding. evt-identity-verification-received (ACL) listado em emitsEvents para tq-dm-02 — semanticamente produzido pelo ACL adapter, aggregate registra o fato traduzido (padrão CMT). vo-participant-profile não em usesValueObjects porque é conceito de projeção (prj-participant-profile-view), não stored field — tq-dm-04 warn aceito."
	}]

	// ══════════════════════════════════════════════════════════
	// POLICIES (event → command)
	// ══════════════════════════════════════════════════════════

	policies: [{
		code:             "pol-record-identity-verification"
		name:             "Registrar Verificação de Identidade"
		description:      "Quando IDC conclui verificação (evt-identity-verification-received via ACL), atualiza flag no aggregate. Não dispara qualificação — supervisor decide quando aprovar."
		triggeredByEvent: "evt-identity-verification-received"
		issuesCommand:    "cmd-record-identity-verification"
		rationale:        "Automação simples: evento ACL → atualização de flag. Qualificação permanece supervisionada — policy apenas registra fato, não decide."
	}]

	// ══════════════════════════════════════════════════════════
	// PROJECTIONS (read models)
	// ══════════════════════════════════════════════════════════

	projections: [{
		code:        "prj-participant-status-view"
		name:        "Participant Status View"
		description: "Read model que serve QueryParticipantStatus. Retorna status de qualificação e data de última transição. Consumido por CTR (registro de termos) e SSC (decisão de sourcing)."
		consumesEvents: [
			"evt-participant-registered",
			"evt-participant-qualified",
			"evt-participant-suspended",
			"evt-participant-terminated",
			"evt-participant-reactivated",
		]
		queryCapabilities: [{
			code:        "qry-participant-status"
			description: "Retorna status do participante (4 estados internos: pending, qualified, suspended, terminated) e data de última transição. CTR interpreta como gate binário para operações contratuais (qualified ou não) — observação por outros BCs não é restrita pelo gate."
			rationale:   "Interface primária para validação de qualificação. Projeção unificada serve ambos os nomes — divergência é de naming no context-map, não de semântica."
		}]
		rationale: "Projeção otimizada para lookup de status. Consome todos os eventos de lifecycle para manter visão atualizada. Consumers síncronos (CTR, SSC) precisam de latência mínima."
	}, {
		code:        "prj-participant-profile-view"
		name:        "Participant Profile View"
		description: "Read model que serve QueryParticipantProfile. Retorna perfil completo: dados cadastrais, histórico de qualificação, estado atual. Consumido por SSC (decisão de sourcing). REW obtém dados equivalentes via eventos, não via esta query (npm-to-rew é async-only)."
		consumesEvents: [
			"evt-participant-registered",
			"evt-participant-qualified",
			"evt-participant-suspended",
			"evt-participant-terminated",
			"evt-participant-reactivated",
			"evt-qualification-documents-received",
		]
		queryCapabilities: [{
			code:        "qry-participant-profile"
			description: "Retorna perfil completo do participante com dados cadastrais e histórico de qualificação."
			rationale:   "Visão mais rica que status — inclui histórico e dados cadastrais. SSC consome via query sync; REW obtém dados via eventos (async-only no context-map)."
		}]
		rationale: "Projeção agrega dados cadastrais e histórico de qualificação. Consome evt-qualification-documents-received adicionalmente para rastrear progresso documental."
	}]

	rationale: """
		Domain model tático do NPM com single aggregate (Participant)
		governando lifecycle de 4 estados internos (pending, qualified,
		suspended, terminated) com 6 transições e gate binário externo
		para operações contratuais — observação não restrita. 7 eventos
		(5 published lifecycle/registro, 1 internal workflow, 1 ACL de
		IDC com sufixo -received). 7 commands (6 de fronteira do canvas
		+ 1 interno para policy ACL). 6 invariants. NetworkGrowthTargetDefined
		(NGR) não modelado como domain event — sinal operacional que
		afeta capacidade de onboarding, não estado do aggregate
		(tq-dm-15 warn aceito). Projeções servem as 2 query-surfaces
		do canvas (status e perfil). Consumers de eventos published
		alinham com canvas: registered→NGR/REW/NIM,
		qualified/suspended/terminated/reactivated→REW/NIM/SSC.
		"""
}
