package cmt

// domain-model.cue — Domain Model: Commitment Management.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Design tático do CMT. Building blocks em ordering behavior-first:
// events → commands → invariants → value objects → aggregate → policies → projection.
//
// Lenses aplicadas:
// - lens-event-driven-architecture-patterns (primária):
//   lifecycle como state machine, visibility internal/published,
//   sourceContext para traduções ACL
// - lens-contractual-and-legal-architecture (secundária):
//   invariants que protegem obrigações bilaterais, gates determinísticos
// - lens-domain-language-and-terminology-design:
//   naming alinhado com glossário CMT (WI-023)
//
// Decisões de design:
// - Single aggregate (agg-commitment): compromisso é o único consistency
//   boundary. Partes, termos e estado são internos ao aggregate.
// - 7 eventos internos ACL (sourceContext): traduzem sinais de REW, DRC,
//   P2P e CTR para linguagem local do CMT. Domain model permanece puro.
// - Dual entry path: compromisso pode originar de pedido de compra spot
//   (P2P → evt-purchase-order-received → ProposeCommitment) ou de termos
//   ativados via sourcing estratégico (SSC→CTR→CMT). Ambos os fluxos
//   assumem que termos contratuais existem em CTR — inv-terms-reference-valid
//   é universal.
// - CommitmentStateChanged como evento genérico de transição: simplifica
//   consumers downstream vs evento por transição.
// - at-risk como estado intermediário entre accepted e suspended:
//   sinalização autônoma (cmd-flag-at-risk) vs suspensão supervisionada
//   (cmd-suspend-commitment). Canvas distingue explicitamente.
// - Policies conectam sinais ACL a commands: automação event → command
//   com guards opcionais per P10 (agentes recomendam, gates validam).
//   Exceção: eventos de lifecycle de termos de CTR são fatos informativos
//   registrados sem policy — validação de termos é sync via QueryContractTerms.
//
// Trade-off documentado (tq-dm-02):
// - Eventos ACL (sourceContext) são produzidos pela camada ACL, não pelo
//   aggregate. Listados em emitsEvents para satisfazer tq-dm-02 que exige
//   que todo event do catálogo esteja wired a um aggregate. Semanticamente
//   o aggregate "registra" o fato traduzido no seu event stream.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code: "cmt"
	name: "Commitment Management Domain Model"

	boundedContextRef: "cmt"

	// =============================================
	// EVENTS (behavior-first: fatos que aconteceram)
	// =============================================

	events: [{
		code:        "evt-commitment-proposed"
		name:        "CommitmentProposed"
		visibility:  "internal"
		description: "Proposta de compromisso registrada com termos, partes e escopo. Trigger para workflows internos de preparação de aceite."
		rationale:   "Interno porque nenhum BC downstream precisa saber que proposta foi criada — apenas que foi aceita (CommitmentAccepted). Mantido interno para não acoplar BDG/DRC a rascunhos que podem nunca ser aceitos (~15% drop rate)."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
			description: "Identificador canônico gerado no momento da proposta."
		}, {
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-commitment-parties"
			description: "Proponente e contraparte."
		}, {
			kind: "value-object-ref", name: "contractTermsRef", valueObjectRef: "vo-contract-terms-ref"
			description: "Referência aos termos contratuais de CTR."
		}, {
			kind: "domain-type", name: "scope", type: "CommitmentScope"
			description: "Escopo do compromisso: descrição, valor, prazo."
		}]
	}, {
		code:        "evt-commitment-accepted"
		name:        "CommitmentAccepted"
		visibility:  "published"
		description: "Gate de aceite mútuo bilateral aprovado com sucesso. Sinal canônico de entrada no commitment lifecycle — BDG inicia aprovação orçamentária, DRC registra contexto para disputas futuras, TCM projeta obrigação futura na posição de caixa."
		rationale:   "Evento cross-context mais importante do CMT. Publicado para BDG, DRC e TCM conforme context-map (cmt-to-bdg, cmt-to-drc, cmt-to-tcm). Nome segue convenção Entity+PastParticiple."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-commitment-parties"
		}, {
			kind: "value-object-ref", name: "contractTermsRef", valueObjectRef: "vo-contract-terms-ref"
		}, {
			kind: "domain-type", name: "scope", type: "CommitmentScope"
		}, {
			kind: "primitive", name: "acceptedAt", type: "datetime"
			description: "Timestamp do aceite bilateral."
		}]
	}, {
		code:        "evt-commitment-state-changed"
		name:        "CommitmentStateChanged"
		visibility:  "published"
		description: "Estado do compromisso transicionou por sinal externo (risco, disputa) ou ação interna (suspensão, cancelamento, reativação). Consumido por DRC para atualizar contexto de disputas e por TCM para atualizar projeções de caixa."
		rationale:   "Trade-off deliberado: evento genérico vs evento por transição (e.g., CommitmentSuspended, CommitmentCancelled). Evento único reduz acoplamento de consumers downstream (DRC consome um tipo, não N) e permite adicionar estados ao lifecycle sem criar novos event types. Custo: consumers precisam inspecionar previousState/newState para filtrar transições relevantes."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "previousState", valueObjectRef: "vo-commitment-state"
		}, {
			kind: "value-object-ref", name: "newState", valueObjectRef: "vo-commitment-state"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-state-change-reason"
			description: "Causa estruturada da transição: tipo, contexto de origem e descrição."
		}]
	}, {
		code:          "evt-counterparty-risk-signaled"
		name:          "CounterpartyRiskSignaled"
		visibility:    "internal"
		sourceContext: "rew"
		description:   "Tradução ACL de CounterpartyRiskAlertRaised (REW). Contraparte de compromisso ativo recebeu alerta de deterioração de risco."
		rationale:     "Evento interno traduzido de sinal externo de REW. Domain model permanece puro — linguagem local. Trigger para pol-risk-signal-flags-commitment."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "domain-type", name: "riskLevel", type: "RiskLevel"
			description: "Nível de risco sinalizado por REW."
		}]
	}, {
		code:          "evt-dispute-resolved-received"
		name:          "DisputeResolvedReceived"
		visibility:    "internal"
		sourceContext: "drc"
		description:   "Tradução ACL de DisputeResolved (DRC). Disputa que afeta compromisso ativo foi resolvida com decisão que pode cancelar, modificar ou manter."
		rationale:     "Evento interno traduzido de sinal externo de DRC. Linguagem local preserva domain model puro. Trigger para pol-dispute-resolved-updates-state."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "domain-type", name: "resolution", type: "DisputeResolution"
			description: "Decisão de resolução: manter, cancelar, modificar termos."
		}]
	}, {
		code:          "evt-suspension-ordered-received"
		name:          "SuspensionOrderedReceived"
		visibility:    "internal"
		sourceContext: "drc"
		description:   "Tradução ACL de CommitmentSuspensionOrdered (DRC). Determinação de suspensão de compromisso ativo por procedimento de disputa."
		rationale:     "Evento interno traduzido de sinal externo de DRC. Trigger para pol-suspension-ordered-suspends."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "domain-type", name: "disputeRef", type: "DisputeRef"
			description: "Referência à disputa que originou a ordem de suspensão."
		}]
	}, {
		code:          "evt-counterparty-risk-cleared"
		name:          "CounterpartyRiskCleared"
		visibility:    "internal"
		sourceContext: "rew"
		description:   "Tradução ACL de CounterpartyRiskAlertCleared (REW). Alerta de risco previamente sinalizado para contraparte foi resolvido."
		rationale:     "Par reverso de evt-counterparty-risk-signaled. Evento interno traduzido de sinal externo de REW. Trigger para pol-risk-cleared-clears-flag."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}]
	}, {
		code:          "evt-purchase-order-received"
		name:          "PurchaseOrderReceived"
		visibility:    "internal"
		sourceContext: "p2p"
		description:   "Tradução ACL de PurchaseOrderEmitted (P2P). Pedido de compra spot recebido — trigger para formalização de compromisso bilateral."
		rationale:     "Evento interno traduzido de sinal externo de P2P. P2P é upstream no macrofluxo spot (P2P→CMT). Agente traduz pedido unilateral para proposta bilateral via ACL. ACL adapter enriquece com contractTermsRef via QueryContractTerms — premissa de que termos existem em CTR para ambos os fluxos (spot e estratégico)."
		fields: [{
			kind: "domain-type", name: "purchaseOrderRef", type: "PurchaseOrderRef"
			description: "Referência ao pedido de compra em P2P."
		}, {
			kind: "domain-type", name: "buyer", type: "ParticipantId"
			description: "Compradora que emitiu o pedido."
		}, {
			kind: "domain-type", name: "supplier", type: "ParticipantId"
			description: "Fornecedora destinatária do pedido."
		}]
	}, {
		code:          "evt-contract-terms-activated-received"
		name:          "ContractTermsActivatedReceived"
		visibility:    "internal"
		sourceContext: "ctr"
		description:   "Tradução ACL de ContractTermsActivated (CTR). Novos termos contratuais ativados e disponíveis para referência em compromissos futuros."
		rationale:     "Evento interno traduzido de sinal externo de CTR. Upstream no macrofluxo estratégico (SSC→CTR→CMT). Fato informativo registrado sem policy — validação de termos em propostas futuras é sync via QueryContractTerms (inv-terms-reference-valid). Evento existe para auditabilidade e cache invalidation."
		fields: [{
			kind: "domain-type", name: "contractTermsId", type: "ContractTermsId"
			description: "Identificador dos termos ativados em CTR."
		}, {
			kind: "primitive", name: "effectiveFrom", type: "datetime"
			description: "Data de vigência dos termos."
		}]
	}, {
		code:          "evt-contract-terms-superseded-received"
		name:          "ContractTermsSupersededReceived"
		visibility:    "internal"
		sourceContext: "ctr"
		description:   "Tradução ACL de ContractTermsSuperseded (CTR). Termos contratuais superseded — compromissos existentes mantêm referência snapshot; novos compromissos devem usar versão vigente."
		rationale:     "Evento interno traduzido de sinal externo de CTR. Fato informativo registrado sem policy — impacto é em validação de propostas futuras (inv-terms-reference-valid via QueryContractTerms sync), não em compromissos existentes (snapshot). Propostas in-flight com termos stale são capturadas no gate de aceite (inv-terms-reference-valid)."
		fields: [{
			kind: "domain-type", name: "contractTermsId", type: "ContractTermsId"
			description: "Identificador dos termos superseded em CTR."
		}, {
			kind: "domain-type", name: "supersededBy", type: "ContractTermsId"
			description: "Identificador da versão que substitui."
		}]
	}]

	// =============================================
	// COMMANDS (intenções de mutação)
	// =============================================

	commands: [{
		code:        "cmd-propose-commitment"
		name:        "ProposeCommitment"
		description: "Proponente submete proposta de compromisso com termos, partes, escopo e referência a termos contratuais de CTR. Async — proponente não espera aceite imediato."
		rationale:   "Separado de cmd-confirm-commitment-acceptance porque proposta e aceite são atos de partes distintas em momentos distintos. Validação de CTR no momento da proposta evita propostas órfãs de lastro contratual."
		fields: [{
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-commitment-parties"
		}, {
			kind: "value-object-ref", name: "contractTermsRef", valueObjectRef: "vo-contract-terms-ref"
		}, {
			kind: "domain-type", name: "scope", type: "CommitmentScope"
		}]
	}, {
		code:        "cmd-confirm-commitment-acceptance"
		name:        "ConfirmCommitmentAcceptance"
		description: "Contraparte confirma aceite dos mesmos termos propostos pelo proponente. Sync — contraparte recebe confirmação imediata. Completa gate bilateral."
		rationale:   "Par direto de cmd-propose-commitment. Sync por exigência de confirmação imediata (canvas inbound[1]). Gate determinístico: inv-mutual-bilateral-acceptance."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "domain-type", name: "counterpartyConfirmation", type: "AcceptanceConfirmation"
			description: "Confirmação com mesmos termos para validação bilateral."
		}]
	}, {
		code:        "cmd-flag-at-risk"
		name:        "FlagAtRisk"
		description: "Sinaliza compromisso ativo cuja contraparte recebeu alerta de risco de REW. Decisão autônoma — não altera estado do compromisso, apenas marca para supervisão."
		rationale:   "Canvas governance scope: flag-at-risk-commitments é autonomousDecision. Sinalização é reação determinística a evento externo. Distinto de suspensão (que é supervisedDecision)."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "domain-type", name: "riskLevel", type: "RiskLevel"
		}]
	}, {
		code:        "cmd-clear-risk-flag"
		name:        "ClearRiskFlag"
		description: "Remove sinalização de risco de compromisso at-risk, retornando ao estado accepted. Decisão autônoma — simétrica com cmd-flag-at-risk."
		rationale:   "Se sinalizar risco é autonomousDecision, limpar a sinalização quando REW resolve o alerta também é. Simetria operacional: flag e clear são par determinístico. Distinto de cmd-reactivate-commitment que retorna de suspended (estado parado) — at-risk nunca parou."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-state-change-reason"
		}]
	}, {
		code:        "cmd-suspend-commitment"
		name:        "SuspendCommitment"
		description: "Suspende compromisso ativo por sinalização de risco ou determinação de disputa. SupervisedDecision — agente recomenda, gate de supervisão humana autoriza."
		rationale:   "Canvas governance scope: suspend-commitment é supervisedDecision porque afeta todo o commitment lifecycle downstream. mech-agent-gate garante que agente nunca suspende unilateralmente."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-state-change-reason"
		}]
	}, {
		code:        "cmd-reactivate-commitment"
		name:        "ReactivateCommitment"
		description: "Reativa compromisso suspenso após resolução favorável de disputa ou redução de risco. Retorna ao estado accepted. Exclusivo para transição suspended → accepted."
		rationale:   "Reativação implica retorno de estado parado — aplica-se apenas a suspended, não a at-risk (que usa cmd-clear-risk-flag). SupervisedDecision — mesma severidade que suspensão."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-state-change-reason"
		}]
	}, {
		code:        "cmd-handle-dispute-resolution"
		name:        "HandleDisputeResolution"
		description: "Processa resolução de disputa recebida de DRC. Aggregate inspeciona tipo de resolução e executa transição apropriada: reativação (cmd-reactivate-commitment), cancelamento (cmd-cancel-commitment) ou manutenção do estado corrente."
		rationale:   "Existe porque #Policy exige exatamente um issuesCommand, mas resolução de disputa é sinal externo com múltiplos outcomes (reativar, cancelar, manter). Routing vive no aggregate porque ele é o consistency boundary que preserva a decisão final — nenhum orchestrator externo decide a transição."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "domain-type", name: "resolution", type: "DisputeResolution"
			description: "Tipo de resolução: manter, reativar, cancelar."
		}]
	}, {
		code:        "cmd-cancel-commitment"
		name:        "CancelCommitment"
		description: "Cancela compromisso definitivamente. Decisão terminal — compromisso cancelado não pode ser reativado."
		rationale:   "Estado terminal do lifecycle. Pode originar de disputa resolvida com cancelamento ou decisão operacional. Irreversibilidade exige supervisão."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-state-change-reason"
		}]
	}]

	// =============================================
	// INVARIANTS (regras que nunca podem ser violadas)
	// =============================================

	invariants: [{
		code:      "inv-mutual-bilateral-acceptance"
		name:      "Aceite Mútuo Bilateral"
		rule:      "Nenhum compromisso progride para estado 'accepted' sem confirmação explícita de ambas as partes (proponente e contraparte) sobre termos idênticos."
		rationale: "Invariante central do CMT. dp-08: custos de manipulação excedam benefícios por design. dp-10: ambas as partes são juridicamente identificáveis. Compromisso unilateral é irrepresentável."
	}, {
		code:      "inv-terms-reference-valid"
		name:      "Referência a Termos Contratuais Válida"
		rule:      "Proposta de compromisso só é aceita se os termos contratuais referenciados existem e estão vigentes em CTR. Validação sync via QueryContractTerms."
		rationale: "Canvas bd-terms-validation: compromisso sem lastro contratual é risco jurídico. Validação determinística — agente pode executar autonomamente (canvas: validate-terms-reference)."
	}, {
		code:      "inv-commitment-id-uniqueness"
		name:      "Unicidade de CommitmentId"
		rule:      "Cada CommitmentId é único globalmente dentro do CMT. Dois compromissos nunca compartilham o mesmo identificador."
		rationale: "CommitmentId é fio de rastreabilidade end-to-end. Duplicação quebraria vínculo determinístico entre compromisso e cadeia downstream (BDG, DLV, INV, FCE)."
	}, {
		code:      "inv-suspension-requires-supervision"
		name:      "Suspensão Requer Supervisão Humana"
		rule:      "Nenhum compromisso transiciona para estado 'suspended' sem autorização de supervisão humana. Agente recomenda suspensão; gate de supervisão valida e autoriza."
		rationale: "P10: agentes recomendam, gates validam. Suspensão afeta todo o commitment lifecycle downstream (BDG, DLV, INV, FCE). Canvas classifica suspend-commitment como supervisedDecision. mech-agent-gate garante que automação não suspende unilateralmente."
	}, {
		code:      "inv-cancellation-irreversible"
		name:      "Cancelamento é Irreversível e Supervisionado"
		rule:      "Nenhum compromisso transiciona para estado 'cancelled' sem supervisão humana. Cancelamento é terminal — compromisso cancelado não pode ser reativado. Impacto downstream (BDG, DLV, INV, FCE) exige decisão humana."
		rationale: "Irreversibilidade de cancelamento satisfaz critério de reversibilityThreshold de domain-definition.cue. P10 exige gate humano para decisões com impacto financeiro irreversível."
	}, {
		code:      "inv-reactivation-requires-supervision"
		name:      "Reativação Requer Supervisão Humana"
		rule:      "Nenhum compromisso transiciona de 'suspended' para 'accepted' sem supervisão humana. Reativação restaura obrigações financeiras que foram suspensas por risco ou disputa."
		rationale: "Reativação reverte uma suspensão que foi autorizada por humano — restaurar obrigações financeiras exige o mesmo nível de supervisão. Simétrico com inv-suspension-requires-supervision."
	}, {
		code:      "inv-proposer-counterparty-distinct"
		name:      "Proponente e Contraparte Distintos"
		rule:      "Proponente e contraparte de um compromisso devem ser organizações distintas. Auto-compromisso é inválido."
		rationale: "Compromisso bilateral exige duas partes. Auto-compromisso anularia o propósito do aceite mútuo e abriria vetor de manipulação trivial (dp-08)."
	}, {
		code:      "inv-cancelled-is-terminal"
		name:      "Estado Cancelado é Terminal"
		rule:      "Nenhum compromisso em estado 'cancelled' aceita commands de reativação, suspensão, sinalização de risco ou aceite. Cancelamento encerra definitivamente o lifecycle."
		rationale: "State machine já expressa terminality via ausência de transições from: cancelled. Invariant explícito torna a restrição auditável por validação e legível sem interpretar o grafo de transições."
	}]

	// =============================================
	// VALUE OBJECTS (tipos imutáveis sem identidade)
	// =============================================

	valueObjects: [{
		code:        "vo-commitment-id"
		name:        "CommitmentId"
		description: "Identificador canônico gerado exclusivamente em CMT no momento da proposta. Permeia todos os contexts downstream como fio de rastreabilidade end-to-end."
		fields: [{
			kind: "primitive", name: "value", type: "string"
			description: "Valor do identificador. Formato definido em runtime (e.g., prefixo + ano + sequencial)."
		}]
		rationale: "Value object porque é imutável após criação e definido exclusivamente pelo valor. Identidade do aggregate mas também conceito de domínio referenciado cross-context."
	}, {
		code:        "vo-commitment-state"
		name:        "CommitmentState"
		description: "Estado canônico do compromisso no lifecycle. Enum tipado: proposed, accepted, at-risk, suspended, cancelled."
		fields: [{
			kind: "primitive", name: "value", type: "string"
			description: "Um dos estados válidos do lifecycle: proposed, accepted, at-risk, suspended, cancelled."
		}]
		constraints: [
			"value deve ser um dos: proposed, accepted, at-risk, suspended, cancelled",
		]
		rationale: "Value object porque é imutável (cada transição cria novo valor) e definido exclusivamente pelo estado. at-risk é estado intermediário entre accepted e suspended — sinalização autônoma antes de suspensão supervisionada."
	}, {
		code:        "vo-contract-terms-ref"
		name:        "ContractTermsRef"
		description: "Referência aos termos contratuais vigentes em CTR que o compromisso deve satisfazer. CMT não armazena os termos — apenas a referência validada."
		fields: [{
			kind: "primitive", name: "contractTermsId", type: "string"
			description: "Identificador dos termos em CTR."
		}, {
			kind: "primitive", name: "validatedAt", type: "datetime"
			description: "Timestamp da última validação de vigência contra CTR."
		}]
		rationale: "Referência, não cópia — CMT consulta CTR como SoT. Timestamp de validação permite detectar termos potencialmente expirados. Staleness detectável via comparação de validatedAt com threshold de negócio; versioning de termos é responsabilidade de CTR."
	}, {
		code:        "vo-commitment-parties"
		name:        "CommitmentParties"
		description: "Par de participantes do compromisso: proponente e contraparte. inv-proposer-counterparty-distinct garante que são organizações distintas."
		fields: [{
			kind: "domain-type", name: "proposer", type: "ParticipantId"
			description: "Identificador da organização proponente."
		}, {
			kind: "domain-type", name: "counterparty", type: "ParticipantId"
			description: "Identificador da organização contraparte."
		}]
		rationale: "Value object encapsulando o par bilateral. Garante que proponente e contraparte são sempre declarados juntos — compromisso sem ambos é estruturalmente inválido."
	}, {
		code:        "vo-state-change-reason"
		name:        "StateChangeReason"
		description: "Causa estruturada de uma transição de estado do compromisso. Torna evt-commitment-state-changed auto-descritivo para consumers sem acoplar a mecanismos internos (event refs, ACL)."
		fields: [{
			kind: "primitive", name: "causeType", type: "string"
			description: "Tipo da causa: risk-signal, risk-cleared, dispute-resolution, dispute-suspension, operational."
		}, {
			kind: "primitive", name: "originContext", type: "string"
			description: "Contexto de origem do sinal: rew, drc, internal."
		}, {
			kind: "primitive", name: "description", type: "string"
			description: "Razão legível da transição para auditoria."
		}]
		constraints: [
			"causeType deve ser um dos: risk-signal, risk-cleared, dispute-resolution, dispute-suspension, operational",
			"originContext deve ser um dos: rew, drc, internal",
		]
		rationale: "Promovido de domain-type opaco para value object estruturado porque consumers de CommitmentStateChanged (especialmente DRC) precisam filtrar transições por causa e origem sem inspecionar payloads opacos. causeType classifica o que aconteceu; originContext diz de onde veio o sinal."
	}]

	// =============================================
	// AGGREGATE (consistency boundary)
	// =============================================

	aggregates: [{
		code:        "agg-commitment"
		name:        "Commitment"
		description: "Aggregate root do compromisso. Único consistency boundary do CMT. Encapsula estado, partes, termos e lifecycle do compromisso."

		rootIdentity: {
			field: "commitmentId"
			type: {kind: "value-object-ref", valueObjectRef: "vo-commitment-id"}
		}

		fields: [{
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-commitment-parties"
			description: "Proponente e contraparte do compromisso."
		}, {
			kind: "value-object-ref", name: "contractTermsRef", valueObjectRef: "vo-contract-terms-ref"
			description: "Referência aos termos contratuais de CTR validados na formalização."
		}, {
			kind: "value-object-ref", name: "currentState", valueObjectRef: "vo-commitment-state"
			description: "Estado corrente do compromisso no lifecycle."
		}, {
			kind: "domain-type", name: "scope", type: "CommitmentScope"
			description: "Escopo do compromisso: descrição, valor, prazo."
		}, {
			kind: "primitive", name: "createdAt", type: "datetime"
		}, {
			kind: "primitive", name: "updatedAt", type: "datetime"
		}]

		handlesCommands: [
			"cmd-propose-commitment",
			"cmd-confirm-commitment-acceptance",
			"cmd-flag-at-risk",
			"cmd-clear-risk-flag",
			"cmd-suspend-commitment",
			"cmd-reactivate-commitment",
			"cmd-cancel-commitment",
			"cmd-handle-dispute-resolution",
		]

		emitsEvents: [
			"evt-commitment-proposed",
			"evt-commitment-accepted",
			"evt-commitment-state-changed",
			"evt-counterparty-risk-signaled",
			"evt-dispute-resolved-received",
			"evt-suspension-ordered-received",
			"evt-counterparty-risk-cleared",
			"evt-purchase-order-received",
			"evt-contract-terms-activated-received",
			"evt-contract-terms-superseded-received",
		]

		protectsInvariants: [
			"inv-mutual-bilateral-acceptance",
			"inv-terms-reference-valid",
			"inv-commitment-id-uniqueness",
			"inv-proposer-counterparty-distinct",
			"inv-suspension-requires-supervision",
			"inv-cancellation-irreversible",
			"inv-reactivation-requires-supervision",
			"inv-cancelled-is-terminal",
		]

		usesValueObjects: [
			"vo-commitment-id",
			"vo-commitment-state",
			"vo-contract-terms-ref",
			"vo-commitment-parties",
			"vo-state-change-reason",
		]

		lifecycle: {
			initialState: "proposed"

			states: ["proposed", "accepted", "at-risk", "suspended", "cancelled"]

			transitions: [{
				from:               "proposed"
				to:                 "accepted"
				triggeredByCommand: "cmd-confirm-commitment-acceptance"
				emitsEvents:       ["evt-commitment-accepted"]
				guards:            ["inv-mutual-bilateral-acceptance", "inv-terms-reference-valid"]
				description:       "Gate de aceite bilateral aprovado. Publica CommitmentAccepted para BDG e DRC."
			}, {
				from:               "proposed"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-commitment"
				emitsEvents:       ["evt-commitment-state-changed"]
				description:       "Proposta rejeitada ou abandonada antes do aceite bilateral. ~15% das propostas não atingem aceite (canvas metric bilateral-acceptance-rate)."
			}, {
				from:               "accepted"
				to:                 "at-risk"
				triggeredByCommand: "cmd-flag-at-risk"
				emitsEvents:       ["evt-commitment-state-changed"]
				description:       "Sinalização autônoma de risco por alerta de REW. Não requer supervisão — apenas marca."
			}, {
				from:               "accepted"
				to:                 "suspended"
				triggeredByCommand: "cmd-suspend-commitment"
				emitsEvents:       ["evt-commitment-state-changed"]
				guards:            ["inv-suspension-requires-supervision"]
				description:       "Suspensão supervisionada de compromisso ativo por risco ou disputa."
			}, {
				from:               "accepted"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-commitment"
				emitsEvents:       ["evt-commitment-state-changed"]
				guards:            ["inv-cancellation-irreversible"]
				description:       "Cancelamento direto de compromisso aceito — e.g., resolução de disputa ordena cancelamento sem suspensão intermediária."
			}, {
				from:               "at-risk"
				to:                 "suspended"
				triggeredByCommand: "cmd-suspend-commitment"
				emitsEvents:       ["evt-commitment-state-changed"]
				guards:            ["inv-suspension-requires-supervision"]
				description:       "Escalação de at-risk para suspensão após supervisão humana."
			}, {
				from:               "at-risk"
				to:                 "accepted"
				triggeredByCommand: "cmd-clear-risk-flag"
				emitsEvents:       ["evt-commitment-state-changed"]
				description:       "Risco resolvido — sinalização removida, compromisso retorna a accepted. Decisão autônoma, simétrica com cmd-flag-at-risk."
			}, {
				from:               "suspended"
				to:                 "accepted"
				triggeredByCommand: "cmd-reactivate-commitment"
				emitsEvents:       ["evt-commitment-state-changed"]
				guards:            ["inv-reactivation-requires-supervision"]
				description:       "Reativação após resolução favorável de disputa ou redução de risco. Requer supervisão."
			}, {
				from:               "suspended"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-commitment"
				emitsEvents:       ["evt-commitment-state-changed"]
				guards:            ["inv-cancellation-irreversible"]
				description:       "Cancelamento definitivo. Estado terminal — compromisso não pode ser reativado."
			}, {
				from:               "at-risk"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-commitment"
				emitsEvents:       ["evt-commitment-state-changed"]
				guards:            ["inv-cancellation-irreversible"]
				description:       "Cancelamento direto de compromisso at-risk sem passar por suspensão."
			}]
		}

		rationale: "Single aggregate porque compromisso é o único consistency boundary do CMT. Partes, termos e estado são sempre mutados atomicamente. at-risk como estado separado de suspended reflete distinção do canvas entre sinalização autônoma e suspensão supervisionada (mech-agent-gate). Nota: 7 eventos ACL internos (evt-counterparty-risk-signaled, evt-counterparty-risk-cleared, evt-dispute-resolved-received, evt-suspension-ordered-received, evt-purchase-order-received, evt-contract-terms-activated-received, evt-contract-terms-superseded-received) aparecem em emitsEvents por limitação estrutural do schema (tq-dm-02), não porque o aggregate os origine semanticamente — são fatos traduzidos pela camada ACL que o aggregate registra no seu event stream. Eventos CTR (activated, superseded) são informativos sem policy — validação de termos é sync via QueryContractTerms."
	}]

	// =============================================
	// POLICIES (automação event → command)
	// =============================================

	policies: [{
		code:             "pol-risk-signal-flags-commitment"
		name:             "Sinalização de Risco em Compromisso"
		description:      "Quando REW publica alerta de risco de contraparte (traduzido como evt-counterparty-risk-signaled), sinaliza compromissos ativos da contraparte como at-risk."
		triggeredByEvent: "evt-counterparty-risk-signaled"
		issuesCommand:    "cmd-flag-at-risk"
		rationale:        "Canvas governance: flag-at-risk-commitments é autonomousDecision. Policy formaliza a automação: sinal externo de risco → sinalização determinística. Não requer supervisão porque não altera o lifecycle — apenas marca."
	}, {
		code:             "pol-suspension-ordered-suspends"
		name:             "Ordem de Suspensão por Disputa"
		description:      "Quando DRC ordena suspensão (traduzido como evt-suspension-ordered-received), emite cmd-suspend-commitment com gate de supervisão."
		triggeredByEvent: "evt-suspension-ordered-received"
		issuesCommand:    "cmd-suspend-commitment"
		rationale:        "Canvas governance: suspend-commitment é supervisedDecision. Policy emite o command mas o aggregate verifica guards de supervisão. Agente recomenda, gate valida (P10)."
	}, {
		code:             "pol-dispute-resolved-routes"
		name:             "Resolução de Disputa Roteia para Aggregate"
		description:      "Quando DRC resolve disputa (traduzido como evt-dispute-resolved-received), emite cmd-handle-dispute-resolution para o aggregate decidir internamente qual transição executar."
		triggeredByEvent: "evt-dispute-resolved-received"
		issuesCommand:    "cmd-handle-dispute-resolution"
		rationale:        "Policy emite command único e honesto — routing multi-outcome (reativar, cancelar, manter) é lógica interna do aggregate que inspeciona o tipo de resolução. Resolve limitação do schema que exige exatamente um issuesCommand por policy."
	}, {
		code:             "pol-risk-cleared-clears-flag"
		name:             "Resolução de Risco Limpa Sinalização"
		description:      "Quando REW resolve alerta de risco de contraparte (traduzido como evt-counterparty-risk-cleared), emite cmd-clear-risk-flag para retornar compromissos at-risk a accepted."
		triggeredByEvent: "evt-counterparty-risk-cleared"
		issuesCommand:    "cmd-clear-risk-flag"
		rationale:        "Par reverso de pol-risk-signal-flags-commitment. Se sinalização é autônoma, limpeza também é. Simetria operacional: flag e clear são par determinístico com policies simétricas."
	}, {
		code:             "pol-purchase-order-initiates-commitment"
		name:             "Pedido de Compra Inicia Compromisso"
		description:      "Quando P2P emite pedido de compra spot (traduzido como evt-purchase-order-received), emite cmd-propose-commitment para iniciar formalização de compromisso bilateral."
		triggeredByEvent: "evt-purchase-order-received"
		issuesCommand:    "cmd-propose-commitment"
		rationale:        "Canvas inbound: PurchaseOrderEmitted → 'Inicia formalização de compromisso econômico bilateral a partir de pedido de compra'. Automação do macrofluxo spot (P2P→CMT). ACL adapter traduz pedido unilateral para proposta bilateral, enriquecendo com contractTermsRef via QueryContractTerms. Policy formaliza a cadeia; tradução vive no adapter."
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-commitment-state-view"
		name:        "Commitment State View"
		description: "Projeção que materializa estado corrente do compromisso para consulta por BCs downstream. Construída a partir de eventos de lifecycle."

		consumesEvents: [
			"evt-commitment-proposed",
			"evt-commitment-accepted",
			"evt-commitment-state-changed",
		]

		queryCapabilities: [{
			code:        "qry-commitment-state"
			description: "Retorna estado canônico do compromisso por CommitmentId. Interface primária de leitura para BDG, DLV, DRC, TCM."
			rationale:   "Canvas query-surface: QueryCommitmentState retorna CommitmentState. 3+ BCs downstream consomem."
		}]

		rationale: "Projeção necessária porque o aggregate é otimizado para escrita (event sourced). Leitura por BCs downstream usa projeção em vez de reconstruir estado do event log."
	}]

	rationale: "Domain model do CMT com single aggregate (Commitment) como único consistency boundary. Behavior-first: 10 events (7 internos ACL de REW/DRC/P2P/CTR + 1 interno + 2 published), 8 commands, 8 invariants, 5 value objects. Lifecycle com 5 estados e 10 transições — at-risk↔accepted via flag/clear autônomos, suspended↔accepted via reactivate supervisionado. 5 policies conectam sinais ACL a commands (inclui par simétrico risk-signal/risk-cleared + purchase-order→propose); eventos CTR (terms activated/superseded) são informativos sem policy — validação de termos é sync via QueryContractTerms. Dual entry path: spot (P2P→CMT) e estratégico (SSC→CTR→CMT), ambos assumem termos em CTR (inv-terms-reference-valid). 1 projeção habilita QueryCommitmentState para BDG, DLV, DRC, TCM. Alinhado com canvas pós-WI-039/WI-041, glossário, context-map v2 e design principles."
}
