package cmt

// service-contract.cue — Service Contract: Commitment Management.
// Instância de #ServiceContract (architecture/artifact-schemas/service-contract.cue).
//
// Superfície canônica do CMT: formalização e gestão do lifecycle de
// compromissos econômicos bilaterais. CUE como SoT autoral; api.yaml
// e async-api.yaml são derivados mecanicamente (P1).
//
// Lenses aplicadas:
// - lens-api-design-as-product: design-first, error guidance,
//   naming consistency, HATEOAS navigation por estado do lifecycle
// - lens-contractual-and-legal-architecture: supervisão de aceite,
//   suspensão, cancelamento e reativação; aceite mútuo bilateral
// - lens-event-driven-architecture-patterns: ordering contratual,
//   ACL boundary estruturado, 8 consumed events de 4 BCs
//
// Decisões relevantes:
// - flagAtRisk, clearRiskFlag e handleDisputeResolution excluídos da
//   API: triggered por policies (autonomousDecisions), sem interação
//   humana via API.
// - confirmCommitmentAcceptance é ActionCommand (não CreateCommand):
//   opera sobre aggregate existente em estado proposed.
// - suspend, reactivate e cancel expostos na API como supervisedDecisions:
//   supervisor precisa de endpoint para invocar.
// - getCommitmentState é a única query: canvas declara 1 query-surface,
//   domain model confirma 1 query capability. Consumers downstream
//   (BDG, DLV, DRC, TCM) descobrem commitments via eventos publicados
//   (CommitmentAccepted, CommitmentStateChanged) e consultam por ID.
//
// Pré-condição de runner e tensão arquitetural (tq-ct-01): o critério
// como escrito exige que eventRef resolva em domain-model.cue events[].code
// sem qualificar de qual BC. Para consumed events de outro BC, o runner
// precisa implementar resolução cross-BC: eventRef resolve contra
// sourceContext domain model, não contra domain model local. 5 de 8
// consumed events referenciam BCs cujo domain model não existe neste
// momento (REW, DRC, P2P) — eventRefs derivados dos nomes no canvas.
// 3 consumed events referenciam CTR (domain model existe). Refinamento
// do critério tq-ct-01 ou do runner é pendência de arquitetura
// (adr-050), não desta instância.
//
// correlatedWith[]: todas as refs nesta instância apontam para building
// blocks do domain model local do CMT. Runner valida existência contra
// catálogo local (tq-ct-01). Runner deve rejeitar refs que não existam
// no domain-model.cue do BC — correlatedWith é local por definição.
//
// Gap no domain model corrigido neste commit: evt-contract-terms-
// cancelled-received adicionado ao aggregate emitsEvents (existia no
// catálogo de eventos mas faltava no wiring do aggregate).
//
// ADR correspondente: adr-050.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

serviceContract: artifact_schemas.#ServiceContract & {
	name:        "Commitment Management Service Contract"
	apiVersion:  "1.0.0"
	description: "Superfície canônica do CMT: formalização e gestão do lifecycle de compromissos econômicos bilaterais. Proposta async, aceite mútuo bilateral sync supervisionado, gestão de estado (suspensão, reativação, cancelamento) com supervisão humana. Consumers downstream (BDG, DRC, TCM) consomem estado canônico e eventos de lifecycle."

	boundedContextRef: "cmt"

	// ==============================
	// SYNC SURFACE
	// ==============================

	sync: {
		commands: [{
			kind:        "create"
			operationId: "proposeCommitment"
			commandRef:  "cmd-propose-commitment"
			name:        "Propor Compromisso"
			description: "Submete proposta de compromisso bilateral com partes, escopo e referência a termos contratuais de CTR. Async — proponente não espera aceite imediato. Agente valida completude e referência de termos via QueryContractTerms (inv-terms-reference-valid)."
			possibleErrors: [
				"err-terms-reference-invalid",
				"err-proposer-counterparty-identical",
				"err-invariant-violation",
			]
			links: [{
				rel:               "self"
				targetOperationId: "getCommitmentState"
				description:       "Consultar estado do compromisso proposto por commitmentId retornado na resposta async."
			}]
			idempotency: {
				required:  true
				mechanism: "idempotency-key"
				rationale: "Proposta é POST async — retry sem idempotency-key criaria aggregates duplicados para mesmas partes+escopo."
			}
			rationale: "Canvas inbound[0]: proposta como command async. CreateCommand porque cria novo aggregate root (novo commitmentId). Concorrência proibida (CreateCommand) porque aggregate ainda não existe."
		}, {
			kind:        "action"
			operationId: "confirmCommitmentAcceptance"
			commandRef:  "cmd-confirm-commitment-acceptance"
			name:        "Confirmar Aceite Bilateral"
			description: "Contraparte confirma aceite dos mesmos termos propostos pelo proponente. Sync — contraparte recebe confirmação imediata. Completa gate de aceite mútuo bilateral (inv-mutual-bilateral-acceptance). Re-valida vigência de termos em CTR."
			possibleErrors: [
				"err-commitment-not-found",
				"err-invalid-state-transition",
				"err-bilateral-acceptance-mismatch",
				"err-terms-reference-invalid",
				"err-supervision-required",
				"err-invariant-violation",
			]
			links: [{
				rel:               "self"
				targetOperationId: "getCommitmentState"
				description:       "Consultar estado do compromisso após aceite."
			}]
			idempotency: {
				required: false
				rationale: "Aceite é transição de estado idempotente por natureza — confirmar compromisso já accepted é no-op."
			}
			concurrency: {
				strategy:     "optimistic"
				versionField: "aggregateVersion"
				rationale:    "Controle otimista por aggregate version. Previne race condition: aceite concorrente com cancelamento sobre mesmo aggregate."
			}
			supervision: {
				required: true
				approver: "human-supervisor"
				rationale: "Canvas supervisedDecision: accept-commitment. Aceite cria obrigação financeira que desencadeia cadeia downstream inteira (BDG, DLV, FCE). P10: agente recomenda, humano decide."
			}
			rationale: "Canvas inbound[1]: aceite bilateral sync. ActionCommand porque opera sobre aggregate existente em estado proposed. Supervisão por impacto financeiro irreversível — CommitmentAccepted desencadeia BDG, DRC, TCM."
		}, {
			kind:        "action"
			operationId: "suspendCommitment"
			commandRef:  "cmd-suspend-commitment"
			name:        "Suspender Compromisso"
			description: "Suspende compromisso ativo por sinalização de risco ou determinação de disputa. Sync — supervisor recebe confirmação imediata. Compromisso suspenso pode ser reativado ou cancelado."
			possibleErrors: [
				"err-commitment-not-found",
				"err-invalid-state-transition",
				"err-supervision-required",
				"err-invariant-violation",
			]
			links: [{
				rel:               "self"
				targetOperationId: "getCommitmentState"
				description:       "Consultar estado do compromisso após suspensão."
			}]
			idempotency: {
				required: false
				rationale: "Suspensão é transição de estado idempotente — suspender compromisso já suspended é no-op."
			}
			concurrency: {
				strategy:     "optimistic"
				versionField: "aggregateVersion"
				rationale:    "Controle otimista previne suspensão concorrente com cancelamento ou reativação sobre mesmo aggregate."
			}
			supervision: {
				required: true
				approver: "human-supervisor"
				rationale: "Canvas supervisedDecision: suspend-commitment. Suspensão afeta todo o commitment lifecycle downstream. mech-agent-gate garante que agente nunca suspende unilateralmente."
			}
			rationale: "Canvas governance: suspend-commitment é supervisedDecision. Exposto na API para supervisor invocar. Também triggered por pol-suspension-ordered-suspends (DRC) com guard de supervisão."
		}, {
			kind:        "action"
			operationId: "reactivateCommitment"
			commandRef:  "cmd-reactivate-commitment"
			name:        "Reativar Compromisso"
			description: "Reativa compromisso suspenso após resolução favorável de disputa ou redução de risco. Sync — retorna ao estado accepted. Exclusivo para transição suspended → accepted."
			possibleErrors: [
				"err-commitment-not-found",
				"err-invalid-state-transition",
				"err-supervision-required",
				"err-invariant-violation",
			]
			links: [{
				rel:               "self"
				targetOperationId: "getCommitmentState"
				description:       "Consultar estado do compromisso após reativação."
			}]
			idempotency: {
				required: false
				rationale: "Reativação é transição de estado idempotente — reativar compromisso já accepted é no-op."
			}
			concurrency: {
				strategy:     "optimistic"
				versionField: "aggregateVersion"
				rationale:    "Controle otimista previne reativação concorrente com cancelamento sobre mesmo aggregate."
			}
			supervision: {
				required: true
				approver: "human-supervisor"
				rationale: "Canvas supervisedDecision: reactivate-commitment. Reativação restaura obrigações financeiras suspensas — mesma severidade que suspensão. P10."
			}
			rationale: "Canvas governance: reactivate-commitment é supervisedDecision. Simétrico com suspendCommitment. Exposto na API para supervisor invocar."
		}, {
			kind:        "action"
			operationId: "cancelCommitment"
			commandRef:  "cmd-cancel-commitment"
			name:        "Cancelar Compromisso"
			description: "Cancela compromisso definitivamente. Sync — decisão terminal irreversível (inv-cancelled-is-terminal). Compromisso cancelado não pode ser reativado. Impacto cross-context em BDG, DLV, INV, FCE."
			possibleErrors: [
				"err-commitment-not-found",
				"err-invalid-state-transition",
				"err-supervision-required",
				"err-invariant-violation",
			]
			links: [{
				rel:               "self"
				targetOperationId: "getCommitmentState"
				description:       "Consultar estado do compromisso após cancelamento."
			}]
			idempotency: {
				required: false
				rationale: "Cancelamento é transição terminal idempotente — cancelar compromisso já cancelled é no-op (inv-cancelled-is-terminal)."
			}
			concurrency: {
				strategy:     "optimistic"
				versionField: "aggregateVersion"
				rationale:    "Controle otimista previne cancelamento concorrente com reativação ou suspensão sobre mesmo aggregate."
			}
			supervision: {
				required: true
				approver: "human-supervisor"
				rationale: "Canvas supervisedDecision: cancel-commitment. Irreversível com impacto em todo o commitment lifecycle downstream. Satisfaz reversibilityThreshold. P10."
			}
			rationale: "Canvas governance: cancel-commitment é supervisedDecision. Estado terminal irreversível — supervisão obrigatória por impacto financeiro cross-context."
		}]

		queries: [{
			kind:        "single"
			operationId: "getCommitmentState"
			queryRef:    "qry-commitment-state"
			name:        "Consultar Estado do Compromisso"
			description: "Retorna estado canônico do compromisso por commitmentId. Interface primária de leitura para BDG, DLV, DRC, TCM. Inclui partes, referência a termos, escopo e estado corrente no lifecycle."
			possibleErrors: [
				"err-commitment-not-found",
			]
			links: [{
				rel:               "accept"
				targetOperationId: "confirmCommitmentAcceptance"
				description:       "Confirmar aceite bilateral (requer supervisão)."
				availability: stateIn: ["proposed"]
			}, {
				rel:               "suspend"
				targetOperationId: "suspendCommitment"
				description:       "Suspender compromisso (requer supervisão)."
				availability: stateIn: ["accepted", "at-risk"]
			}, {
				rel:               "reactivate"
				targetOperationId: "reactivateCommitment"
				description:       "Reativar compromisso suspenso (requer supervisão)."
				availability: stateIn: ["suspended"]
			}, {
				rel:               "cancel"
				targetOperationId: "cancelCommitment"
				description:       "Cancelar compromisso definitivamente (requer supervisão)."
				availability: stateIn: ["proposed", "accepted", "at-risk", "suspended"]
			}]
			cacheTier: "volatile"
			rationale: "Canvas query-surface: QueryCommitmentState — single canonical read surface do CMT. Decisão deliberada de não ter query de discovery: BCs downstream descobrem commitments via eventos publicados (CommitmentAccepted, CommitmentStateChanged) e consultam por ID. Volatile porque estado muda com aceite, sinalização de risco, suspensão, reativação e cancelamento. 4+ BCs downstream consomem. Links condicionais por estado do lifecycle guiam supervisor para operações disponíveis."
		}]
	}

	// ==============================
	// ASYNC SURFACE
	// ==============================

	async: {
		publishedEvents: [{
			eventRef:    "evt-commitment-accepted"
			name:        "CommitmentAccepted"
			description: "Gate de aceite mútuo bilateral aprovado. Sinal cross-context mais importante do CMT: BDG inicia aprovação orçamentária, DRC registra contexto para disputas, TCM projeta obrigação futura na posição de caixa."
			ordering: {
				scope:         "within-aggregate"
				guarantor:     "producer"
				sequenceField: "mesh_sequence_number"
				rationale:     "Ordenação por aggregate garante que consumers processam eventos de lifecycle na sequência correta. Producer garante via Event Log append-only com sequence number monotônico."
			}
			rationale: "Canvas outbound[0]: consumers BDG, DRC, TCM. Evento cross-context mais importante — sinaliza entrada no commitment lifecycle com obrigação financeira vinculada."
		}, {
			eventRef:    "evt-commitment-state-changed"
			name:        "CommitmentStateChanged"
			description: "Estado do compromisso transicionou por sinal externo (risco, disputa) ou ação interna (suspensão, cancelamento, reativação). Evento genérico com previousState/newState — consumers filtram transições relevantes."
			ordering: {
				scope:         "within-aggregate"
				guarantor:     "producer"
				sequenceField: "mesh_sequence_number"
				rationale:     "Ordenação por aggregate é crítica: consumers reconstroem state machine do compromisso. Evento fora de ordem inverte transições."
			}
			rationale: "Canvas outbound[1]: consumers DRC, TCM. Trade-off deliberado: evento genérico vs evento por transição. Reduz acoplamento — DRC consome um tipo, não N."
		}]

		consumedEvents: [{
			// Pré-condição de runner: eventRef resolve no domain model de REW.
			// REW domain model não existe — ref derivado do canvas name.
			eventRef:      "evt-counterparty-risk-alert-raised"
			name:          "CounterpartyRiskAlertRaised"
			description:   "Alerta de deterioração de risco de contraparte publicado por REW. Trigger para sinalização autônoma de compromissos ativos como at-risk."
			sourceContext: "rew"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz modelo de risco de REW para linguagem de compromisso do CMT. REW publica alerta genérico de risco; CMT filtra compromissos ativos da contraparte e sinaliza como at-risk."
				rationale:   "REW e CMT têm linguagens ubíquas distintas. REW fala em risk alerts; CMT fala em commitment state. ACL isola a fronteira."
			}
			reaction: "Sinaliza compromissos ativos com contraparte sob risco elevado como at-risk. Automação via pol-risk-signal-flags-commitment → cmd-flag-at-risk (autonomousDecision)."
			correlatedWith: [
				"cmd-flag-at-risk",
				"agg-commitment",
			]
			rationale: "Canvas inbound event-consumer: REW retroalimenta CMT com deterioração de risco pós-formalização. Sinalização autônoma — não altera lifecycle, apenas marca."
		}, {
			eventRef:      "evt-counterparty-risk-alert-cleared"
			name:          "CounterpartyRiskAlertCleared"
			description:   "Alerta de risco de contraparte resolvido por REW. Trigger para remoção de sinalização de compromissos at-risk."
			sourceContext: "rew"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz resolução de alerta de REW para limpeza de flag de risco no CMT. Par reverso de CounterpartyRiskAlertRaised."
				rationale:   "Simetria com consumo de risk-alert-raised. ACL mantém domain model puro."
			}
			reaction: "Remove sinalização de risco de compromissos at-risk cuja contraparte teve alerta resolvido. Retorna a accepted via pol-risk-cleared-clears-flag → cmd-clear-risk-flag (autonomousDecision)."
			correlatedWith: [
				"cmd-clear-risk-flag",
				"agg-commitment",
			]
			rationale: "Canvas inbound event-consumer: par reverso de CounterpartyRiskAlertRaised. Se sinalizar risco é autônomo, limpar também é."
		}, {
			eventRef:      "evt-dispute-resolved"
			name:          "DisputeResolved"
			description:   "Resolução de disputa publicada por DRC. Decisão com múltiplos outcomes: cancelar, reativar ou manter compromisso afetado."
			sourceContext: "drc"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz modelo de resolução de DRC para linguagem de compromisso do CMT. DRC publica resolução com tipo; CMT roteia internamente via aggregate."
				rationale:   "DRC fala em disputas e resoluções; CMT fala em estados de compromisso. ACL garante que aggregate recebe sinal traduzido."
			}
			reaction: "Aggregate inspeciona tipo de resolução e executa transição apropriada — reativação, cancelamento ou manutenção do estado corrente. Via pol-dispute-resolved-routes → cmd-handle-dispute-resolution."
			correlatedWith: [
				"cmd-handle-dispute-resolution",
				"agg-commitment",
			]
			rationale: "Canvas inbound event-consumer: DRC publica resolução, CMT reage. Routing multi-outcome é lógica interna do aggregate."
		}, {
			eventRef:      "evt-commitment-suspension-ordered"
			name:          "CommitmentSuspensionOrdered"
			description:   "Determinação de suspensão de compromisso por procedimento de disputa em DRC. Trigger para suspensão supervisionada."
			sourceContext: "drc"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz ordem de suspensão de DRC para command de suspensão no CMT. DRC determina; CMT executa com guard de supervisão."
				rationale:   "Separação entre determinação (DRC) e execução (CMT). ACL garante que cada BC mantém sua linguagem."
			}
			reaction: "Emite cmd-suspend-commitment com gate de supervisão. Agente recomenda, gate valida (P10). Via pol-suspension-ordered-suspends."
			correlatedWith: [
				"cmd-suspend-commitment",
				"agg-commitment",
			]
			rationale: "Canvas inbound event-consumer: DRC ordena suspensão, CMT executa com supervisão. supervisedDecision — guard garante aprovação humana."
		}, {
			eventRef:      "evt-purchase-order-emitted"
			name:          "PurchaseOrderEmitted"
			description:   "Pedido de compra spot emitido por P2P. Trigger para formalização de compromisso bilateral — agente traduz pedido unilateral para proposta bilateral via ACL."
			sourceContext: "p2p"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz pedido de compra de P2P para proposta de compromisso bilateral do CMT. ACL adapter enriquece com contractTermsRef via QueryContractTerms — premissa de que termos existem em CTR para ambos os fluxos."
				rationale:   "P2P fala em pedidos de compra (demanda unilateral). CMT fala em compromissos bilaterais. Transformação semântica profunda: unilateral → bilateral com referência contratual."
			}
			reaction: "Inicia formalização de compromisso bilateral: ACL traduz pedido para input de cmd-propose-commitment com partes derivadas de buyer/supplier e contractTermsRef resolvido via QueryContractTerms. Via pol-purchase-order-initiates-commitment."
			correlatedWith: [
				"cmd-propose-commitment",
				"agg-commitment",
			]
			rationale: "Canvas inbound event-consumer: P2P é upstream no macrofluxo spot (P2P→CMT). Dual entry path: spot via P2P, estratégico via SSC→CTR→CMT."
		}, {
			eventRef:      "evt-contract-terms-activated"
			name:          "ContractTermsActivated"
			description:   "Versão de termos contratuais ativada em CTR. Habilita referência a novos termos em compromissos futuros."
			sourceContext: "ctr"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz evento de ativação de CTR para evento local (evt-contract-terms-activated-received). Registra fato para auditabilidade e cache invalidation."
				rationale:   "Domain model diz 'Tradução ACL de ContractTermsActivated (CTR)'. Mesmo que impacto seja informativo, CMT cria evento local com shape próprio — é tradução, não pass-through."
			}
			reaction: "Registra fato para auditabilidade. Habilita referência a novos termos em propostas futuras. Sem policy — validação de termos é sync via QueryContractTerms (inv-terms-reference-valid)."
			correlatedWith: [
				"agg-commitment",
			]
			rationale: "Canvas inbound event-consumer: CTR publica lifecycle de termos. Fato informativo registrado sem policy — domain model documenta explicitamente."
		}, {
			eventRef:      "evt-contract-terms-superseded"
			name:          "ContractTermsSuperseded"
			description:   "Versão de termos superseded em CTR por nova versão ativada. Compromissos existentes mantêm referência snapshot; novos compromissos devem usar versão vigente."
			sourceContext: "ctr"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz evento de supersession de CTR para evento local (evt-contract-terms-superseded-received). Impacto indireto: propostas in-flight com termos stale são capturadas no gate de aceite."
				rationale:   "Mesma lógica de ContractTermsActivated — tradução ACL para linguagem local, mesmo que impacto seja informativo."
			}
			reaction: "Registra fato para auditabilidade. Enforcement de vigência é sync via QueryContractTerms no gate de aceite — sem policy para supersession."
			correlatedWith: [
				"agg-commitment",
			]
			rationale: "Canvas inbound event-consumer: CTR publica supersession. Fato informativo sem policy — mesma razão de ContractTermsActivated."
		}, {
			eventRef:      "evt-contract-terms-cancelled"
			name:          "ContractTermsCancelled"
			description:   "Termos contratuais invalidados em CTR por fraude, erro ou decisão regulatória. Compromissos ativos que referenciam estes termos devem ser avaliados — cancelamento é mais grave que supersession (invalidação irreversível)."
			sourceContext: "ctr"
			aclBoundary: {
				kind:        "anticorruption-layer"
				description: "Traduz cancelamento de CTR para avaliação de impacto em compromissos do CMT. Cancelamento é invalidação irreversível — exige identificação de compromissos impactados e potencial suspensão."
				rationale:   "Cancelamento tem semântica distinta de supersession — requer avaliação ativa, não apenas registro. Tradução mais profunda."
			}
			reaction: "Identifica compromissos ativos referenciando termos cancelados. Compromissos impactados devem ser avaliados para potencial suspensão ou cancelamento — avaliação é supervisedDecision."
			correlatedWith: [
				"agg-commitment",
			]
			rationale: "Canvas inbound event-consumer: CTR publica cancelamento. Mais grave que supersession — invalidação irreversível pode exigir suspensão de compromissos impactados."
		}]
	}

	// ==============================
	// DOMAIN ERRORS
	// ==============================
	//
	// SOMENTE erros semânticos de negócio do CMT.
	// Erros de transporte excluídos deliberadamente:
	// - 400 Bad Request (request validation) → platform
	// - 412 Precondition Failed (If-Match) → derivado de ConcurrencyPolicy
	// - 429 Too Many Requests (rate limit) → platform policy

	errors: [{
		code:           "err-commitment-not-found"
		name:           "Compromisso Não Encontrado"
		description:    "Não existe compromisso com este commitmentId. Consumers obtêm commitmentId a partir de CommitmentAccepted (evento publicado) ou da resposta async de proposeCommitment. Verifique que o ID corresponde a um compromisso formalizado."
		httpStatusCode: 404
		rationale:      "Aggregate inexistente. 404."
	}, {
		code:           "err-invalid-state-transition"
		name:           "Transição de Estado Inválida"
		description:    "Compromisso não está em estado que permita esta operação. Consulte getCommitmentState para verificar estado corrente. Transições válidas: proposed→accepted (confirm), accepted/at-risk→suspended (suspend), suspended→accepted (reactivate), qualquer não-terminal→cancelled (cancel)."
		httpStatusCode: 409
		rationale:      "Lifecycle com transições determinísticas. 409 porque estado corrente conflita com operação solicitada."
	}, {
		code:           "err-terms-reference-invalid"
		name:           "Referência a Termos Inválida"
		description:    "Termos contratuais referenciados não existem ou não estão vigentes em CTR. Verifique vigência dos termos via CTR antes de submeter proposta ou confirmar aceite."
		httpStatusCode: 422
		rationale:      "inv-terms-reference-valid. 422 porque dados são sintaticamente válidos mas violam regra de negócio."
	}, {
		code:           "err-supervision-required"
		name:           "Supervisão Requerida"
		description:    "Operação requer token de supervisão humana. Obtenha autorização do supervisor designado e inclua supervision_token no request."
		httpStatusCode: 422
		rationale:      "inv-suspension-requires-supervision, inv-cancellation-irreversible, inv-reactivation-requires-supervision, accept-commitment. 422 (não 403) porque não é falta de permissão — é ausência de evidência de aprovação de workflow."
	}, {
		code:           "err-bilateral-acceptance-mismatch"
		name:           "Aceite Bilateral Não Corresponde"
		description:    "Termos confirmados pela contraparte não correspondem aos termos da proposta original. Proponente e contraparte devem confirmar termos idênticos para satisfazer inv-mutual-bilateral-acceptance."
		httpStatusCode: 422
		rationale:      "inv-mutual-bilateral-acceptance. 422 porque dados são válidos mas não satisfazem invariante de aceite bilateral."
	}, {
		code:           "err-proposer-counterparty-identical"
		name:           "Proponente e Contraparte Idênticos"
		description:    "Proponente e contraparte devem ser organizações distintas. Auto-compromisso é inválido — compromisso bilateral exige duas partes."
		httpStatusCode: 422
		rationale:      "inv-proposer-counterparty-distinct. 422 porque auto-compromisso viola regra de negócio fundamental."
	}, {
		code:           "err-invariant-violation"
		name:           "Violação de Invariante de Negócio"
		description:    "Operação viola invariante do domain model. Mensagem inclui ID da invariante violada e hint de resolução."
		httpStatusCode: 422
		rationale:      "Catch-all para invariantes não cobertas por erros específicos. 422 por violação de regra de negócio."
	}]

	// ==============================
	// DEFAULT AUTH
	// ==============================

	defaultAuth: {
		scheme: "bearer-jwt"
		scopes: ["cmt:read", "cmt:write"]
		rationale: "Bearer JWT como padrão da Mesh. Scopes declaram categorias de acesso — plataforma mapeia scopes a operações (cmt:read para queries, cmt:write para commands)."
	}

	rationale: """
		Service contract do CMT derivado do domain model (8 commands,
		11 events, 8 invariants, 5 value objects, 1 aggregate, 5
		policies, 1 projection) e do canvas (2 command handlers, 8
		event consumers, 1 query surface, 2 event publishers, 4
		supervisedDecisions, 4 autonomousDecisions). Superfície sync:
		5 commands (propose create-async + confirm action-sync-
		supervisionado + suspend/reactivate/cancel action-sync-
		supervisionados) + 1 query (getCommitmentState single com
		links condicionais por estado do lifecycle). 3 commands
		excluídos da API: flagAtRisk e clearRiskFlag são autonomous-
		Decisions triggered por policies de REW; handleDispute-
		Resolution é routing interno do aggregate triggered por
		policy de DRC. Superfície async: 2 published events
		(CommitmentAccepted → BDG/DRC/TCM, CommitmentStateChanged →
		DRC/TCM) com ordering within-aggregate + 8 consumed events
		(2 REW risco, 2 DRC disputa, 1 P2P pedido de compra, 3 CTR
		lifecycle de termos — todos com ACL boundary anticorruption-
		layer). 7 erros de domínio catalogados — erros de transporte
		excluídos (platform policy). Query única reflete canvas: BCs
		downstream descobrem commitments via eventos publicados e
		consultam por ID — discovery por search é operacional, não
		semântico.
		"""
}
