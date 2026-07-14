package p2p

// domain-model.cue — Domain Model do BC Procure-to-Pay.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Materializado via authoring manual section-by-section per
// manualAuthoringProtocol (adr-057). Cascade ordering per adr-053/
// adr-054 dec 13: PG existe; canvas P2P + glossary P2P estabelecidos
// (Phases 1+2 do WI-057).
//
// 1 aggregate central: agg-purchase-order (consistency boundary do
// processo de emissão de PO sob authority pré-validada SSC). rootIdentity
// = purchaseOrderId (PO existe desde t=0 mesmo se attempt for recorded
// sem progredir para emitted — semântica "emit attempt recorded" per
// founder Patch 1; lifecycle requested → emitted | cancelled com cancel
// reachable de ambos requested e emitted).
//
// Behavior-first ordering aplicado: events identificados primeiro do
// canvas (2 published de PO lifecycle + 3 internal ACL de SSC);
// commands derivados de canvas inbound (EmitPurchaseOrder + Cancel
// PurchaseOrder); invariants protegidos derivados dos 6 businessDecisions;
// value-objects emergentes dos payloads + glossary terms.
//
// Multi-supplier first-class via authorityRef discriminator per Q1 do
// canvas: P2P emite PO supplier-specific (1 supplier por PO) sob
// authorityRef que aponta para SSC decision; multi-supplier semantics
// vive em allocationPolicy do upstream SSC decision (P2P respeita policy
// em agregado via prj-allocation-tracking, não por pedido individual).
// PurchaseOrder é conceito único, NÃO 3 tipos paralelos — discriminação
// é via authorityType (one-shot-decision | preferred-designation |
// strategic-award).
//
// Lenses aplicadas:
// - lens-organizational-resource-allocation (primária): aggregate
//   modela alocação de POs sob authority pré-validada (allocation
//   policy upstream SSC respeitada em agregado)
// - lens-incentive-alignment (secundária): invariants e gate
//   determinístico de authority protegem contra 3 vetores adversariais
//   (sh-01 fragmentation, sh-02 renegotiation, sh-05 allocation bias)
// - lens-event-driven-architecture-patterns (secundária): 2 events
//   published + 3 internal ACL; 4 projections como read models
// - lens-information-economics (terciária): authorityRef preserving
//   link to sourcing decision rationale rich, NIM intelligence
//   learning loop bridge Phase 1+
//
// Glossary alignment: 15 terms canônicos do glossary (Phase 2)
// reconciliados com events/commands/aggregates/value-objects.
//
// Convenção List (paralelo a SSC/IDC): campos com kind "domain-type"
// cujo type termina em "List" denotam coleção (ex.: SupplierRefList).
//
// [ATUALIZADO 2026-07-12 — adr-174 / WI-151] Fatia da requisição:
// 2º aggregate agg-purchase-requisition materializa a PORTA da
// jornada (requisição → triagem formal → aprovação com Gate de
// Cobertura pré-pedido; adr-174 PORTÃO, def-078 resolved). Emissão
// de PO ganha 2º braço de gate (inv-emission-requires-approved-
// requisition ao lado do RECTOR). +6 events internal, +5 commands,
// +3 invariants, +1 VO, +1 policy, +1 projection. Re-papel bdg-side
// (efetivação da reserva) = fatia irmã WI-153.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code:              "p2p"
	name:              "Procure-to-Pay Domain Model"
	boundedContextRef: "p2p"

	// =============================================
	// EVENTS (catalog top-level)
	// =============================================

	events: [{
		code:        "evt-purchase-order-emitted"
		name:        "PurchaseOrderEmitted"
		visibility:  "published"
		description: "Pedido de Compra emitido com authority validada — supplier-specific, hard binding operational signal para CMT formalizar commitment econômico bilateral. Carrega authorityRef + authorityType + supplier + scope + amount + requisitionRef imutáveis."
		rationale:   "Event publisher canvas.communication.outbound[]. CMT consume como trigger canônico de commitment lifecycle (p2p-to-cmt context-map, ACL hard binding). Phase 0 NIM consumer pendente (PO data como signal NIM Phase 1+ — paralelo a oq-ssc-2). Materializa term-purchase-order-emitted do glossary. Hard binding é OPERATIONAL signal (caráter inevitável do trigger downstream), NÃO obrigação contratual estabelecida — contrato é responsabilidade CTR para strategic-award; CMT formaliza commitment econômico bilateral pós-PO emit per Patch 3 founder glossary. Confidencialidade competitiva preservada: NTF transversal notifica supplier-specific (não broadcast cross-supplier)."
		fields: [{
			kind:           "value-object-ref"
			name:           "purchaseOrderId"
			valueObjectRef: "vo-purchase-order-id"
		}, {
			kind:           "value-object-ref"
			name:           "authorityRef"
			valueObjectRef: "vo-authority-ref"
		}, {
			kind:           "value-object-ref"
			name:           "authorityType"
			valueObjectRef: "vo-authority-type"
		}, {
			kind:           "value-object-ref"
			name:           "supplier"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
		}, {
			kind: "primitive"
			name: "emittedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "emittedBy"
			type: "string"
		}, {
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Originadora — área/função que solicitou demanda (term-originadora-de-demanda)."
		}, {
			kind:           "value-object-ref"
			name:           "requisitionRef"
			valueObjectRef: "vo-requisition-id"
			description:    "Requisição aprovada que origina este PO (adr-174 portão) — o elo que pol-purchase-order-converts-requisition usa para fechar o ciclo requisição → pedido."
		}]
	}, {
		code:        "evt-purchase-order-cancelled"
		name:        "PurchaseOrderCancelled"
		visibility:  "published"
		description: "Pedido de Compra cancelado — withdrawal/negative signal a CMT pré-commitment formalization. CMT cancela path de formalização correspondente sem produzir CommitmentAccepted. Phase 0 cobre apenas pre-CMT cancellation (pós-CMT cancellation requer cross-BC coordination separada — oq-p2p-2 deferred)."
		rationale:   "Event publisher canvas outbound. CMT consume como sinal de retirada (não evento de cancelamento downstream-formalizado). Materializa term-purchase-order-cancelled do glossary. Phase 0 cobre 2 cenários: (a) cancelamento de PO emitida pré-CMT formalization (originadora retira demanda; supplier withdraw; scope mismatch detected); (b) cancelamento de attempt recorded (PO em estado requested cuja validation falhou e founder/admin cancela explicitamente para limpar audit trail). Per Patch 4 founder, lifecycle inclui requested→cancelled E emitted→cancelled."
		fields: [{
			kind:           "value-object-ref"
			name:           "purchaseOrderId"
			valueObjectRef: "vo-purchase-order-id"
		}, {
			kind:           "value-object-ref"
			name:           "supplier"
			valueObjectRef: "vo-supplier-ref"
			description:    "Optional — populated apenas quando cancellation ocorre de state emitted (PO já tinha supplier vinculado); ausente quando cancel ocorre de state requested (attempt failed validation antes de supplier binding)."
		}, {
			kind: "primitive"
			name: "cancelledAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "cancelledBy"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-cancellation-reason"
		}]
	}, {
		code:        "evt-purchase-requisition-submitted"
		name:        "PurchaseRequisitionSubmitted"
		visibility:  "internal"
		description: "Requisição de Compra submetida — requisitante declara demanda técnica (o que, quanto escopo cobre, para qual Centro de Custo e etapa) e a requisição nasce em state=submitted aguardando triagem. A PORTA da jornada de compras (passos 1-3 da ds-buyer-procurement-journey) per adr-174/WI-151."
		rationale:   "Fato de abertura do ciclo demanda-a-pedido. Internal: a requisição vive intra-P2P até virar pedido (evt-purchase-order-emitted é o sinal published downstream). Materializa term-requisitante do glossary (requisitante declara demanda que precede a emissão pelo comprador); fato-de-origem da demanda registrado COMO CAMPO (budgetStageRef) sem cerimônia de observação, per decisão do founder no WI-151."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Requisitante — quem declara a demanda técnica (term-requisitante; absorvido em sh-01 originadora Phase 0)."
		}, {
			kind:        "primitive"
			name:        "costCenterRef"
			type:        "string"
			description: "Centro de Custo contra o qual a cobertura será reservada na aprovação — língua bdg (term-centro-de-custo; identidade canônica vive no bdg agg-cost-center). Primitive ref cross-BC: p2p referencia, bdg mantém."
		}, {
			kind:        "primitive"
			name:        "budgetStageRef"
			type:        "string"
			description: "Etapa do cronograma/orçamento que origina a demanda — fato-de-origem registrado COMO CAMPO sem cerimônia de observação (decisão do founder, WI-151). Primitive ref: etapa como conceito first-class bdg-side não existe ainda — formalização eventual acompanha o re-papel WI-153 ou fatia própria."
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
			description:    "Escopo da demanda — descrição, volume estimado, prazo, location (vo-purchase-scope reusado; quantidade e prazo vivem DENTRO do scope, sem campos duplicados — P0)."
		}, {
			kind: "primitive"
			name: "submittedAt"
			type: "datetime"
		}]
	}, {
		code:        "evt-purchase-requisition-triaged"
		name:        "PurchaseRequisitionTriaged"
		visibility:  "internal"
		description: "Requisição triada pelo comprador — ATO FORMAL com outcome: routed-to-sourcing (segue para cotação/decisão de sourcing), returned (devolvida ao requisitante para correção; requisição permanece submitted) ou rejected (demanda morta na triagem). Per decisão do founder no WI-151: triagem é ato formal, não anotação."
		rationale:   "Materializa o passo 3 da ds-buyer-procurement-journey (a triagem que o setor de compras vive). Outcome carrega a decisão de roteamento: routed-to-sourcing e rejected transicionam (selectors per adr-160); returned NÃO transiciona — registra a devolução e a requisição permanece submitted para correção."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:        "primitive"
			name:        "outcome"
			type:        "string"
			description: "routed-to-sourcing | returned | rejected"
		}, {
			kind:        "primitive"
			name:        "triagedBy"
			type:        "string"
			description: "Comprador que executa a triagem (term-comprador)."
		}, {
			kind:        "primitive"
			name:        "narrative"
			type:        "string"
			description: "Justificativa — obrigatória quando outcome=returned (o que falta) ou rejected (por que morre); vazia quando routed-to-sourcing."
		}, {
			kind: "primitive"
			name: "triagedAt"
			type: "datetime"
		}]
	}, {
		code:        "evt-purchase-approved"
		name:        "PurchaseApproved"
		visibility:  "internal"
		description: "Compra aprovada pelo gestor por Alçada COM reserva de cobertura confirmada pelo Gate de Cobertura do bdg (Saldo Disponível suficiente + Alçada satisfeita) E procedência de preço verificada contra a cotação vencedora do ssc (2º braço do portão, adr-177) — o PORTÃO DUPLO pré-pedido (adr-174 + adr-177). A aprovação RESERVA cobertura no Centro de Custo (two-phase Reservation/Confirmation, ADR-C4-2.0 §2.0.8); o commitment aceito EFETIVA (re-papel bdg-side WI-153); o cancelamento LIBERA."
		rationale:   "O de-acordo do gestor que o setor de compras vive como pré-condição vira fato verificável do sistema — a divergência nº 1 do relatório da story morre aqui. Alçada e saldo são PRÉ-CONDIÇÃO da emissão, nunca reação ao pedido emitido (adr-174 decisão 1)."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:        "primitive"
			name:        "approvedBy"
			type:        "string"
			description: "Gestor cuja Alçada cobre o valor — língua bdg."
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
			description:    "Valor aprovado — declarado pelo gestor e VERIFICADO contra a cotação vencedora do sourcing (ssc) pelo 2º braço do portão (unitPrice × quantity == amount + currency match; inv-approval-amount-matches-winning-quotation, adr-177), reservado pelo Gate de Cobertura. A fonte-de-verdade do preço unitário é a cotação no ssc; a procedência do valor aprovado é provada no disco, não confiada."
		}, {
			kind:        "primitive"
			name:        "sourcingDecisionRef"
			type:        "string"
			description: "Decisão de sourcing cuja cotação vencedora precificou a compra aprovada — língua ssc (sourcingDecisionId; identidade canônica vive no ssc vo-sourcing-decision-id). O elo formal requisição↔cotação (adr-177) viaja no evento: a procedência do valor é auditável a partir do próprio fato, sem reconstrução."
		}, {
			kind:        "primitive"
			name:        "quantity"
			type:        "decimal"
			description: "Quantidade FIRME aprovada — base da fórmula verificada pelo 2º braço do portão (unitPrice × quantity == amount; adr-177)."
		}, {
			kind:        "primitive"
			name:        "coverageReservationRef"
			type:        "string"
			description: "Referência à reserva de cobertura confirmada pelo Gate de Cobertura no bdg (Comprometimento Orçamentário reservado contra o Centro de Custo). Primitive ref cross-BC; a chave por requisição entra no re-papel bdg-side WI-153 — janela declarada no adr-174."
		}, {
			kind: "primitive"
			name: "approvedAt"
			type: "datetime"
		}]
	}, {
		code:        "evt-purchase-approval-rejected"
		name:        "PurchaseApprovalRejected"
		visibility:  "internal"
		description: "Aprovação de compra REJEITADA por decisão do gestor — a requisição triada morre no portão (triaged → rejected). Distinto de falha do Gate de Cobertura (saldo/alçada insuficiente): falha do gate NÃO transiciona nem emite este evento — segue a escalada supervisionada do bdg e a requisição permanece triaged."
		rationale:   "Registro do não-de-acordo como fato — sustenta a fila do gestor e a leitura de padrões (requisições recusadas por categoria/Centro de Custo). A separação decisão-humana vs falha-de-gate preserva P10: o gate determinístico não é sobrescrito por decisão; a decisão não se confunde com o gate."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:        "primitive"
			name:        "rejectedBy"
			type:        "string"
		}, {
			kind:        "primitive"
			name:        "narrative"
			type:        "string"
			description: "Justificativa documentada — obrigatória."
		}, {
			kind: "primitive"
			name: "rejectedAt"
			type: "datetime"
		}]
	}, {
		code:        "evt-purchase-requisition-converted"
		name:        "PurchaseRequisitionConverted"
		visibility:  "internal"
		description: "Requisição aprovada CONVERTIDA em Pedido de Compra — fecho do ciclo requisição → pedido (approved → converted), disparado por pol-purchase-order-converts-requisition quando evt-purchase-order-emitted carrega o requisitionRef desta requisição."
		rationale:   "Sem este fato, a requisição ficaria 'approved' órfã após o pedido nascer — converted registra a consumação e mantém a fila de requisições limpa. Par command/event exigido por construção do schema (#StateTransition requer triggeredByCommand + emitsEvents) para expressar a conversão decidida no adr-174."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:           "value-object-ref"
			name:           "purchaseOrderId"
			valueObjectRef: "vo-purchase-order-id"
		}, {
			kind: "primitive"
			name: "convertedAt"
			type: "datetime"
		}]
	}, {
		code:        "evt-purchase-requisition-cancelled"
		name:        "PurchaseRequisitionCancelled"
		visibility:  "internal"
		description: "Requisição cancelada pré-conversão (de submitted, triaged ou approved) — requisitante retira a demanda ou supervisor limpa a fila. Cancelamento de requisição approved implica liberação da reserva de cobertura no bdg (release per two-phase adr-174; materialização bdg-side WI-153)."
		rationale:   "Saída limpa do lifecycle da requisição em qualquer estado pré-conversão. Reusa vo-cancellation-reason (mesma taxonomia estruturada do PO) — analytics de padrões de cancelamento cobre requisições e pedidos com vocabulário único."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:        "primitive"
			name:        "cancelledBy"
			type:        "string"
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-cancellation-reason"
		}, {
			kind: "primitive"
			name: "cancelledAt"
			type: "datetime"
		}]
	}, {
		code:          "evt-sourcing-decision-made-received"
		name:          "SourcingDecisionMadeReceived"
		visibility:    "internal"
		sourceContext: "ssc"
		description:   "Tradução ACL de SourcingDecisionMade (SSC). Trigger para atualização de prj-active-purchase-authorities com authority type=one-shot-decision (hard binding direta)."
		rationale:     "Event interno traduzido de sinal externo de SSC (ssc-to-p2p, hybrid). Domain model permanece puro — linguagem local. Sufixo -received segue convenção ACL estabelecida em CMT/BDG/SSC. Materializa hard binding cache feed: P2P emit subsequente sob esta authority sem sync query a SSC. Override = supervisedDecision per canvas inbound."
		fields: [{
			kind: "primitive"
			name: "sourcingDecisionId"
			type: "string"
			description: "Reference a SSC vo-sourcing-decision-id (boundary cross-BC; P2P consume identidade SSC-mantida)."
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "selectedSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef selecionados pela decisão SSC (≥1; tipicamente 1; multi-supplier suportado per Q1 canvas SSC)."
		}, {
			kind:        "domain-type"
			name:        "allocationPolicy"
			type:        "AllocationPolicy"
			description: "Policy de allocation upstream SSC (single | split-by-percentage | split-by-criteria). P2P respeita em agregado via prj-allocation-tracking + inv-allocation-convergence-aggregate-level."
		}, {
			kind: "primitive"
			name: "receivedAt"
			type: "datetime"
		}]
	}, {
		code:          "evt-preferred-supplier-designated-received"
		name:          "PreferredSupplierDesignatedReceived"
		visibility:    "internal"
		sourceContext: "ssc"
		description:   "Tradução ACL de PreferredSupplierDesignated (SSC). Trigger para atualização de prj-active-purchase-authorities com authority type=preferred-designation (soft binding) + validityPeriod."
		rationale:     "Event interno traduzido de SSC. Soft binding: P2P emite POs subsequentes da categoria para preferredSuppliers até validUntil expirar OU override sustentado disparar drift signal. Múltiplos POs por designação ao longo do validityPeriod. Override = autonomous-with-audit per canvas inbound."
		fields: [{
			kind: "primitive"
			name: "sourcingDecisionId"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "preferredSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef preferidos para a categoria (≥1; tipicamente >=1)."
		}, {
			kind:        "domain-type"
			name:        "allocationPolicy"
			type:        "AllocationPolicy"
			description: "Policy de allocation para preferred designation."
		}, {
			kind: "primitive"
			name: "validUntil"
			type: "datetime"
			description: "Expiração passiva da designação (sem evento de expiry Phase 0)."
		}, {
			kind: "primitive"
			name: "receivedAt"
			type: "datetime"
		}]
	}, {
		code:          "evt-strategic-award-completed-received"
		name:          "StrategicAwardCompletedReceived"
		visibility:    "internal"
		sourceContext: "ssc"
		description:   "Tradução ACL de StrategicAwardCompleted (SSC). Phase 0: trigger para atualização de prj-active-purchase-authorities com authority type=strategic-award (advisory binding — CTR contract ainda não materializado). Phase 1+: pós-ContractActivated CTR (forward-ref oq-p2p-1), authority bumped para hard."
		rationale:     "Event interno traduzido de SSC. Advisory Phase 0 porque contrato CTR ainda não existe — P2P pode emitir POs sob strategic-award mas authorityType reflete advisory. Hard binding ativa apenas pós-CTR ContractActivated (PHASE 1+ FORWARD-REF). Per oq-ssc-5: cache stale pós-CTR cancel é openQuestion compartilhada."
		fields: [{
			kind: "primitive"
			name: "sourcingDecisionId"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "awardedSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef premiados para formalização contratual via CTR Phase 1+."
		}, {
			kind:        "domain-type"
			name:        "allocationPolicy"
			type:        "AllocationPolicy"
		}, {
			kind: "primitive"
			name: "receivedAt"
			type: "datetime"
		}]
	}]

	// =============================================
	// COMMANDS (intenções de mudança de estado)
	// =============================================

	commands: [{
		code:        "cmd-emit-purchase-order"
		name:        "EmitPurchaseOrder"
		description: "Solicitação para emitir Pedido de Compra para supplier específico sob authorityRef vigente. Sync. Resultado: agg-purchase-order criado em initialState=requested ('emit attempt recorded' per Patch 1 founder); se os gates de emissão passam (inv-purchase-order-requires-valid-authority + inv-emission-requires-approved-requisition per adr-174), transição requested→emitted + evt-purchase-order-emitted publicado para CMT. Se validation falha, aggregate persiste em requested (audit trail de tentativa) — pode ser cancelado posteriormente via cmd-cancel-purchase-order para limpar."
		rationale:   "Entry point principal do BC. Aggregate creation: cmd-emit-purchase-order creates agg-purchase-order directly em initialState=requested e tenta transition para emitted via guard inv-purchase-order-requires-valid-authority — schema #Lifecycle não suporta create transition (from: ∅), criação implícita via initialState. Per Patch 1 founder, semântica de requested é 'emit attempt recorded', NÃO 'PO válida aguardando emissão' — validation success transita imediato para emitted no caminho síncrono; validation failure deixa aggregate em requested como audit trail (originadora pode then submeter cmd-cancel-purchase-order ou retentar com authorityRef diferente). Materializa term-authority-validation gate determinístico do glossary. Per adr-174 (portão), a emissão ganha 2º braço de gate: requisitionRef DEVE apontar requisição em estado approved (inv-emission-requires-approved-requisition)."
		fields: [{
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Originadora — área/função que solicita demanda."
		}, {
			kind:           "value-object-ref"
			name:           "requisitionRef"
			valueObjectRef: "vo-requisition-id"
			description:    "Requisição APROVADA que origina este pedido (adr-174 portão) — validada pelo 2º braço do gate de emissão (inv-emission-requires-approved-requisition) via prj-pending-requisitions."
		}, {
			kind:           "value-object-ref"
			name:           "supplier"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
		}, {
			kind:        "primitive"
			name:        "claimedAuthorityRef"
			type:        "string"
			description: "AuthorityRef que originadora reivindica como cobertura — sourcingDecisionId apontando para SSC decision (one-shot/preferred/strategic). Validado pelo gate determinístico via prj-active-purchase-authorities + sync fallback QuerySourcingDecision."
		}, {
			kind:        "primitive"
			name:        "requestedAt"
			type:        "datetime"
			description: "Timestamp do request — sustenta audit trail de attempt mesmo se validation falhar."
		}]
	}, {
		code:        "cmd-cancel-purchase-order"
		name:        "CancelPurchaseOrder"
		description: "Cancelar Pedido de Compra. Sync supervised. Phase 0 cobre 2 cenários: (a) cancelamento de PO emitida pré-CMT formalization (originadora retira demanda; supplier withdraw; scope mismatch detected) — emitted→cancelled + evt-purchase-order-cancelled como withdrawal/negative signal a CMT; (b) cancelamento de attempt recorded em estado requested — requested→cancelled (limpa audit trail de attempt sem progressão para emit). supervisedDecision per bd-cancellation-pre-formalization-only; pós-CMT cancellation é cross-BC oq-p2p-2 deferred."
		rationale:   "Command de saída do lifecycle. Per Patch 4 founder, lifecycle tem 2 transitions de cancel: requested→cancelled (limpa attempt failed) E emitted→cancelled (withdrawal pre-CMT). Cancel apenas pré-CMT formalization Phase 0 (per bd-cancellation-pre-formalization-only). Materializa term-purchase-order-cancelled do glossary."
		fields: [{
			kind:           "value-object-ref"
			name:           "purchaseOrderId"
			valueObjectRef: "vo-purchase-order-id"
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-cancellation-reason"
		}, {
			kind: "primitive"
			name: "cancelledBy"
			type: "string"
		}]
	}, {
		code:        "cmd-submit-purchase-requisition"
		name:        "SubmitPurchaseRequisition"
		description: "Requisitante declara demanda técnica — cria agg-purchase-requisition em initialState=submitted e emite evt-purchase-requisition-submitted. Async: a submissão entra na fila de triagem do comprador (prj-pending-requisitions); nenhuma decisão síncrona ocorre no ato."
		rationale:   "Entry point da PORTA da jornada (passos 1-3 da ds-buyer-procurement-journey) per adr-174/WI-151. Aggregate creation via initialState (schema #Lifecycle não suporta create transition — mesmo pattern do agg-purchase-order). A língua já existia (subdomínio p2p declara 'requisição, aprovação por alçada'; glossário tem term-requisitante) — execução, não descoberta."
		fields: [{
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Requisitante — quem declara a demanda (term-requisitante)."
		}, {
			kind:        "primitive"
			name:        "costCenterRef"
			type:        "string"
			description: "Centro de Custo alvo da cobertura — língua bdg."
		}, {
			kind:        "primitive"
			name:        "budgetStageRef"
			type:        "string"
			description: "Etapa do cronograma/orçamento que origina a demanda — fato-de-origem como campo (WI-151)."
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
		}, {
			kind: "primitive"
			name: "submittedAt"
			type: "datetime"
		}]
	}, {
		code:        "cmd-triage-requisition"
		name:        "TriageRequisition"
		description: "Triagem FORMAL da requisição pelo comprador — Sync, com outcome: routed-to-sourcing (transição submitted→triaged; segue para cotação/decisão de sourcing), returned (SEM transição — requisição permanece submitted para correção; evento registra o que falta) ou rejected (transição submitted→rejected; demanda morta na triagem). Guard inv-requisition-completeness no caminho routed-to-sourcing."
		rationale:   "Per decisão do founder no WI-151: triagem é ATO FORMAL com outcome, não anotação informal. Outcome-split via selectors per adr-160 (par colidente routed-to-sourcing/rejected sobre (submitted, cmd-triage-requisition); returned fica fora do par — devolução não é transição de estado). Materializa o passo 3 da jornada."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:        "primitive"
			name:        "outcome"
			type:        "string"
			description: "routed-to-sourcing | returned | rejected"
		}, {
			kind:        "primitive"
			name:        "triagedBy"
			type:        "string"
		}, {
			kind:        "primitive"
			name:        "narrative"
			type:        "string"
			description: "Justificativa — obrigatória quando returned ou rejected."
		}]
	}, {
		code:        "cmd-approve-purchase"
		name:        "ApprovePurchase"
		description: "Decisão de aprovação do gestor por Alçada sobre requisição triada — Sync, decision approve | reject. PRÉ-CONDIÇÕES do approve (portão DUPLO, padrão adr-055): (1) reserva de cobertura CONFIRMADA pelo Gate de Cobertura do bdg (cmd-approve-budget sync: Saldo Disponível suficiente + Alçada satisfeita) — inv-approval-requires-coverage-reservation (adr-174); (2) procedência de preço VERIFICADA contra a cotação vencedora do ssc (sourcingDecisionRef resolve a cotação; unitPrice × quantity == amount + currency match) — inv-approval-amount-matches-winning-quotation (adr-177). Falha de QUALQUER braço: requisição permanece triaged (escalada supervisionada); reject do gestor: triaged→rejected."
		rationale:   "O de-acordo do gestor como pré-condição da emissão — a ordem que o setor de compras vive (adr-174 decisão 1). O mecanismo bdg é integralmente reusado: muda o invocador e o momento (pré-pedido), não o gate. Two-phase Reservation/Confirmation §2.0.8: approve RESERVA; commitment EFETIVA (WI-153); cancel LIBERA. Outcome-split approve/reject via selectors per adr-160. O amount permanece campo de ENTRADA — o gestor declara o valor (ato de autoridade humana real) — e o 2º braço determinístico do portão prova a procedência contra a cotação vencedora do ssc via sourcingDecisionRef (elo formal requisição↔cotação, adr-177 — resolve def-079); divergência não transiciona e escala."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:        "primitive"
			name:        "decision"
			type:        "string"
			description: "approve | reject"
		}, {
			kind:        "primitive"
			name:        "decidedBy"
			type:        "string"
			description: "Gestor cuja Alçada cobre o valor — língua bdg."
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
			description:    "Valor da compra a aprovar — declarado pelo gestor (campo de ENTRADA; ato de autoridade humana) e VERIFICADO pelo 2º braço do portão contra a cotação vencedora do ssc (unitPrice × quantity == amount + currency match — inv-approval-amount-matches-winning-quotation, adr-177). É sobre este valor que o Gate de Cobertura avalia Saldo Disponível + Alçada."
		}, {
			kind:        "primitive"
			name:        "sourcingDecisionRef"
			type:        "string"
			description: "Decisão de sourcing cuja cotação vencedora precifica esta compra — língua ssc (sourcingDecisionId; identidade canônica vive no ssc vo-sourcing-decision-id; padrão primitive ref cross-BC de costCenterRef/claimedAuthorityRef: p2p referencia, ssc mantém). O elo formal requisição↔cotação (adr-177): o 2º braço resolve a cotação vencedora por este ref via QueryQuotationMap."
		}, {
			kind:        "primitive"
			name:        "quantity"
			type:        "decimal"
			description: "Quantidade FIRME sendo comprada — declarada pelo gestor no ato da aprovação. Base da fórmula do 2º braço: unitPrice (cotação vencedora) × quantity == amount. Distinta de scope.estimatedVolume (estimativa da submissão — NUNCA base de reconciliação; adr-177)."
		}, {
			kind:        "primitive"
			name:        "coverageReservationRef"
			type:        "string"
			description: "Referência à reserva confirmada pelo Gate de Cobertura — presente quando decision=approve (preenchida pela interação sync com o bdg)."
		}, {
			kind:        "primitive"
			name:        "narrative"
			type:        "string"
			description: "Justificativa — obrigatória quando decision=reject."
		}]
	}, {
		code:        "cmd-convert-requisition"
		name:        "ConvertRequisition"
		description: "Command INTERNO emitido por pol-purchase-order-converts-requisition quando evt-purchase-order-emitted carrega requisitionRef — transiciona a requisição approved→converted, fechando o ciclo requisição → pedido. Não exposto no canvas (command interno de policy per tq-dm-12 carve-out)."
		rationale:   "Par command/event exigido por construção do schema para expressar a conversão como transição (toda #StateTransition requer triggeredByCommand + emitsEvents). A decisão semântica é a policy (adr-174); o command é o veículo tático dela."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:           "value-object-ref"
			name:           "purchaseOrderId"
			valueObjectRef: "vo-purchase-order-id"
		}]
	}, {
		code:        "cmd-cancel-purchase-requisition"
		name:        "CancelPurchaseRequisition"
		description: "Cancelar requisição pré-conversão (submitted | triaged | approved) — requisitante retira a demanda ou supervisor limpa a fila. Cancelamento de requisição approved implica liberar a reserva de cobertura no bdg (cmd-release-budget-commitment devolve o valor ao Saldo Disponível — materialização do disparo é re-papel bdg-side WI-153; janela declarada no adr-174)."
		rationale:   "Saída limpa do lifecycle em qualquer estado pré-conversão — sem ela, requisição abandonada prenderia reserva (a preocupação vigiada pela falsificação (b) do adr-174: reservas órfãs envelhecendo). Reusa vo-cancellation-reason (taxonomia única de cancelamento no BC)."
		fields: [{
			kind:           "value-object-ref"
			name:           "requisitionId"
			valueObjectRef: "vo-requisition-id"
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-cancellation-reason"
		}, {
			kind: "primitive"
			name: "cancelledBy"
			type: "string"
		}]
	}]

	// =============================================
	// INVARIANTS (regras protegidas)
	// =============================================

	invariants: [{
		code:      "inv-purchase-order-requires-valid-authority"
		name:      "Pedido de Compra Exige Authority Válida"
		rule:      "Toda transição requested→emitted (PO progredindo de attempt recorded para PO emitida) EXIGE authorityRef vigente apontando para uma SSC decision válida no momento do emit. Authority válida significa: (a) one-shot-decision (SourcingDecisionMade vigente para o categoryRef + supplier ∈ selectedSuppliers) OR (b) preferred-designation (PreferredSupplierDesignated com validUntil > emittedAt + supplier ∈ preferredSuppliers + categoryRef match) OR (c) strategic-award (StrategicAwardCompleted vigente; Phase 0 advisory binding; supplier ∈ awardedSuppliers + categoryRef match; Phase 1+ requer ContractActivated CTR para hard binding per oq-p2p-1). Sem authority válida, transição NÃO ocorre — aggregate permanece em state requested (attempt recorded). Override = supervisedDecision approve-po-without-sourcing-authority (escalation para gate humano com justificativa documentada)."
		rationale: "Invariante RECTOR de P2P per bd-emission-requires-sourcing-authority. P10 (gates determinísticos validam, agentes recomendam). Anti-mini-NIM: sem este invariant, P2P viraria 'mini-SSC' decidindo sourcing fora de processo competitivo — viola moat de inteligência da Mesh + integridade de boundary. Materializa term-authority-validation + term-sourcing-authority do glossary. Cross-BC dependency declarada em dependsOnAggregateState per adr-055."
		dependsOnAggregateState: {
			boundedContextRef: "ssc"
			aggregateRef:      "agg-sourcing-process"
			accessVia: {
				kind:               "sync-query"
				canvasQuerySurface: "QuerySourcingDecision"
			}
			rationale: "SSC é single-owner de sourcing decisions (term-sourcing-authority do glossary). P2P consume authority via prj-active-purchase-authorities (cache local derivada de 3 ACL events) com sync fallback via canvas query-surface QuerySourcingDecision quando cache não tem entry para authorityRef reivindicado (cache miss; ACL event ainda não recebido). RECTOR invariant precisa de visibility de SSC state — sem isso, gate fica sem base de comparação para enforcement."
		}
	}, {
		code:      "inv-allocation-convergence-aggregate-level"
		name:      "Convergência de Allocation em Agregado (Monitoring Obligation)"
		rule:      "P2P MUST monitor and report sustained drift entre allocationPolicy upstream SSC e volume real emitido por authorityRef + supplier + categoryRef ao longo do validityPeriod (preferred) ou da janela ativa (one-shot/strategic). Drift sustentado (diferença significativa por janela operacional) dispara sig-allocation-drift como signal observável (OBS) para SSC reconsiderar fitness rules. Phase 0 enforcement é monitoring + reporting, NÃO bloqueio individual de PO — POs individuais não são gated por allocation; agregado é tracked via prj-allocation-tracking; drift é reportado, não impedido."
		rationale: "Invariante de monitoring obligation per bd-allocation-policy-respected-in-aggregate + Patch 3 founder ('volume converge' substituído por 'monitor and report sustained drift' porque enforcement strict é Phase 1+ requer domain-model mechanisms — Phase 0 invariant é observable property, não gate determinístico). Materializa term-allocation-convergence + term-allocation-bias do glossary. P2P observa convergência, NÃO decide allocation — anti-mini-NIM: agente NÃO computa fairness allocation (responsabilidade SSC fitness rules); apenas tracked + signal."
	}, {
		code:      "inv-cancellation-pre-formalization-only"
		name:      "Cancelamento Apenas Pré-CMT Formalization"
		rule:      "evt-purchase-order-cancelled é emitido APENAS quando: (a) state=requested cancela para limpar attempt failed validation (cmd-cancel-purchase-order de state requested), OR (b) state=emitted cancela ANTES de CMT receber e formalizar CommitmentAccepted (cmd-cancel-purchase-order de state emitted; race condition pós-emit antes de CMT formalization). Cancelamento pós-CMT formalization NÃO é coberto Phase 0 — exige cross-BC coordination cancel-cascade entre P2P + CMT (oq-p2p-2 deferred). Race condition (CMT já formalizou commitment quando PurchaseOrderCancelled chega) é assumed rara Phase 0 (typical CMT formalization latency); reconciliação cross-BC futura tratará."
		rationale: "Materializa bd-cancellation-pre-formalization-only + term-purchase-order-cancelled do glossary. Define boundary explícita do escopo de cancellation Phase 0 — protege contra creep para cross-BC coordination prematura (Phase 0 escopo Procure only; Pay = pós-CMT é fora deste BC). Race condition é openQuestion oq-p2p-2."
	}, {
		code:      "inv-no-supplier-revalidation-by-p2p"
		name:      "P2P NÃO Revalida Supplier Eligibility (Anti-mini-NIM)"
		rule:      "P2P NÃO consulta NPM (sem QueryParticipantStatus em P2P operationalScope). P2P NÃO revalida supplier eligibility no momento do emit — confia na validação SSC upstream (que validou no decision time via QueryParticipantStatus per inv-qualification-as-precondition SSC). Janela de risco entre SSC decision e P2P emit é mitigada por SSC re-validation no decision time + (Phase 1+) drift signal feedback loop a SSC. Se supplier rebaixado entre SSC decision e P2P emit, supervisor escala (revoke authority + re-issue OR escalate decisão); P2P emit per authority vigente — NÃO pause-gate na ausência de authority revoke explícita."
		rationale: "Invariante NEGATIVO de anti-mini-NIM per bd-no-supplier-revalidation-by-p2p (boundary clarification founder Patch 4 canvas). P2P NÃO possui supplier pool — apenas purchase authority; pool é responsabilidade SSC pré-validada upstream (NPM single-owner de qualification per dp-04). Sem este invariant, P2P duplicaria responsabilidade SSC + violaria anti-mini-NIM como invariant transversal da Mesh. Sem dependsOnAggregateState (constraint NEGATIVO — declara ausência de dependency, não presence). Materializa term-fornecedor-qualificado boundary + escalation criterion authority-exhausted (renomeado de pool-exhausted per Patch 4 canvas)."
	}, {
		code:      "inv-purchase-order-lifecycle-public-events"
		name:      "Lifecycle Público de PO via 2 Events"
		rule:      "Toda PurchaseOrder que percorre fluxo normal (requested → emitted) DEVE emitir PurchaseOrderEmitted. Toda PurchaseOrder cancelada (requested → cancelled OR emitted → cancelled) DEVE emitir PurchaseOrderCancelled. Não há saída do lifecycle sem evento público correspondente. State requested SEM transição para emitted nem para cancelled é attempt recorded persistente (válido per Patch 1 founder) — não é violação do invariant porque lifecycle não 'sai' do state."
		rationale: "Materializa bd-po-lifecycle-public-events + term-po-lifecycle do glossary. CMT consume PurchaseOrderEmitted como trigger canônico de commitment lifecycle; PurchaseOrderCancelled como sinal de retirada (withdrawal/negative signal). NTF transversal notifica supplier via PO events. OBS observabilidade rastreia emit/cancel rates. Avaliação interna (authority validation, allocation tracking) permanece intra-P2P — confidencialidade competitiva preservada."
	}, {
		code:      "inv-requisition-completeness"
		name:      "Requisição Completa Antes de Seguir"
		rule:      "Transição submitted→triaged (outcome routed-to-sourcing) EXIGE requisição completa: requestedBy + costCenterRef + budgetStageRef + categoryRef + scope presentes e válidos. Requisição incompleta NÃO segue — a triagem devolve (outcome returned, evento registra o que falta) e a requisição permanece submitted para correção pelo requisitante."
		rationale: "A triagem que o setor de compras vive: demanda malformada volta para quem a declarou, não entra no funil de cotação. Completude aqui é pré-condição do roteamento — barata na porta, cara depois (cotação sobre escopo errado desperdiça o funil ssc inteiro). Materializa o passo 3 da ds-buyer-procurement-journey."
	}, {
		code:      "inv-approval-requires-coverage-reservation"
		name:      "Aprovação Exige Reserva de Cobertura Confirmada (Portão adr-174)"
		rule:      "Transição triaged→approved (decision approve) EXIGE reserva de cobertura CONFIRMADA pelo Gate de Cobertura do bdg ANTES de efetivar: Saldo Disponível suficiente no Centro de Custo identificado + valor dentro da Alçada do aprovador (cmd-approve-budget, sync, determinístico, com escalada supervisionada). Sem reserva confirmada, aprovação NÃO ocorre — requisição permanece triaged. A reserva segue two-phase Reservation/Confirmation (ADR-C4-2.0 §2.0.8): aprovação RESERVA; commitment aceito EFETIVA (re-papel bdg-side WI-153); cancelamento LIBERA (cmd-release-budget-commitment)."
		rationale: "Materializa adr-174 (PORTÃO, decisão A do def-078): alçada e saldo são PRÉ-CONDIÇÃO da emissão do pedido, nunca reação ao pedido emitido. P10: o portão é gate determinístico (saldo + alçada verificáveis), nenhuma camada estocástica decide cobertura. O mecanismo bdg é integralmente preservado — muda o invocador e o momento, não o gate. Cross-BC dependency declarada per adr-055 (mesmo shape npm↔idc)."
		dependsOnAggregateState: {
			boundedContextRef: "bdg"
			aggregateRef:      "agg-cost-center"
			accessVia: {
				kind:               "sync-query"
				canvasQuerySurface: "QueryBudgetApprovalStatus"
			}
			rationale: "Cobertura orçamentária é owned pelo bdg (Centro de Custo persiste Saldo Disponível + Comprometimentos; single-owner). P2P lê a confirmação da reserva via canvas query-surface no momento da aprovação — gate determinístico no momento da decisão, paralelo npm↔idc per adr-055. A chave por requisição foi MATERIALIZADA no re-papel bdg-side (WI-153, 2026-07-13): a surface responde por requisitionRef — o portão lê status=reserved na fase 1 (CoverageReserved) — e a janela declarada no adr-174 consequences FECHOU."
		}
	}, {
		code:      "inv-approval-amount-matches-winning-quotation"
		name:      "Aprovação Exige Procedência de Preço da Cotação Vencedora (2º Braço do Portão adr-177)"
		rule:      "Transição triaged→approved (decision approve) EXIGE procedência de preço verificada contra o ssc ANTES de efetivar: (a) sourcingDecisionRef aponta para decisão de sourcing existente e concluída; (b) a cotação VENCEDORA dessa decisão é resolvível — one-shot: vencedor único, resolução trivial; preferred/strategic multi-supplier: cotação vencedora ambígua → escalada ambiguous-case, o gate NÃO efetiva (espelho do padrão multi-supplier da emissão); (c) currency da cotação vencedora == currency do amount; (d) unitPrice (cotação vencedora) × quantity (firme, declarada no command) == amount. Divergência em qualquer verificação NÃO transiciona — requisição permanece triaged + escalada supervisionada. A base da fórmula é quantity FIRME; scope.estimatedVolume (estimativa) NUNCA é base de reconciliação."
		rationale: "2º braço do portão de aprovação (adr-177, resolve def-079): o 1º braço prova COBERTURA (bdg: saldo + alçada); este prova PROCEDÊNCIA (ssc: o valor aprovado é o da cotação certa). Transforma 'confio que o valor é o da cotação vencedora' em 'o disco prova a procedência do valor aprovado' — fecha o furo de auditoria da SCD. Mesma mecânica determinística do braço bdg (falha de gate não transiciona, escala — P10); a decisão do gestor permanece humana (amount é entrada verificada, não derivação). Cross-BC dependency declarada per adr-055."
		dependsOnAggregateState: {
			boundedContextRef: "ssc"
			aggregateRef:      "agg-sourcing-process"
			accessVia: {
				kind:               "sync-query"
				canvasQuerySurface: "QueryQuotationMap"
			}
			rationale: "A cotação vencedora e seu unitPrice são owned pelo ssc (ent-quotation; vencedor carimbado pela decisão em prj-quotation-map — a superfície de leitura que o WI-152 entregou como pré-requisito do exit do def-079). P2P lê a cotação vencedora via canvas query-surface QueryQuotationMap no momento da aprovação — query-only sync, call-site operacional FORA do grafo per adr-120: zero aresta nova, sc-cm-07 preservado por construção."
		}
	}, {
		code:      "inv-emission-requires-approved-requisition"
		name:      "Emissão Exige Requisição Aprovada (2º Braço do Gate)"
		rule:      "Toda transição requested→emitted do agg-purchase-order EXIGE requisitionRef apontando para agg-purchase-requisition em estado approved (aprovação do gestor com reserva de cobertura vigente). Sem requisição aprovada, a emissão NÃO ocorre — o aggregate permanece em requested (attempt recorded), mesmo pattern do braço de authority. Pedido sem requisição aprovada é maverick por construção."
		rationale: "Materializa a ordem canônica do adr-174 (requisição → triagem → aprovação → emissão): o 2º braço do gate de emissão, ao lado do RECTOR inv-purchase-order-requires-valid-authority — authority prova o COMO (sourcing legítimo); a requisição aprovada prova o PORQUÊ COM COBERTURA (demanda triada + de-acordo do gestor + reserva). Aqui a divergência nº 1 do relatório da story morre no disco. Dependência intra-BC declarada per adr-055."
		dependsOnAggregateState: {
			aggregateRef: "agg-purchase-requisition"
			accessVia: {
				kind:          "projection"
				projectionRef: "prj-pending-requisitions"
			}
			rationale: "Estado da requisição é intra-BC — o gate de emissão lê o read model local (estado approved + reserva vigente) no momento do emit. Sem sync cross-BC: a confirmação da reserva já foi verificada na aprovação (inv-approval-requires-coverage-reservation); o emit verifica o ESTADO da requisição, não re-verifica o bdg."
		}
	}]

	// =============================================
	// VALUE OBJECTS (catalog top-level)
	// =============================================

	valueObjects: [{
		code:        "vo-purchase-order-id"
		name:        "PurchaseOrderId"
		description: "Identidade canônica de um Pedido de Compra. Persistente, imutável, referenciada cross-context (CMT formalização; CTR cross-check para strategic award; DRC futuro para dispute context). Gerada na criação do aggregate em initialState=requested ('emit attempt recorded' per Patch 1 founder) — persiste mesmo se attempt falhar validation."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Root identity do aggregate. PO tem identidade própria desde criação em state requested — sustenta audit trail de attempt mesmo se nunca progredir para emitted. Garantia de identidade aggregate-wide independente de outcome (emitted vs cancelled)."
	}, {
		code:        "vo-requisition-id"
		name:        "RequisitionId"
		description: "Identidade canônica de uma Requisição de Compra. Persistente, imutável, gerada na criação do aggregate em initialState=submitted. Referenciada pelo Pedido de Compra via requisitionRef — o elo requisição → pedido que o gate inv-emission-requires-approved-requisition verifica (adr-174)."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Root identity do agg-purchase-requisition. A requisição tem identidade desde a submissão — sustenta a fila de triagem/aprovação, o vínculo com a reserva de cobertura e o elo ao PO na conversão."
	}, {
		code:        "vo-authority-ref"
		name:        "AuthorityRef"
		description: "Referência a uma Autoridade de Sourcing emitida pelo SSC — sourcingDecisionId apontando para SSC vo-sourcing-decision-id. Boundary cross-BC: P2P consume identidade SSC-mantida; SSC mantém canonicidade. P2P NÃO emite authority (apenas APLICA) per anti-mini-NIM."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Materializa term-sourcing-authority do glossary. Boundary explícita com SSC. Sustenta inv-purchase-order-requires-valid-authority — gate determinístico de authority validation consulta authorityRef + authorityType contra prj-active-purchase-authorities + sync fallback QuerySourcingDecision."
	}, {
		code:        "vo-authority-type"
		name:        "AuthorityType"
		description: "Discriminator do tipo de authority — determina binding regime (hard/soft/advisory) + supplier visibility (1 supplier vs lista preferred vs awarded list)."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		constraints: [
			"value deve ser um dos: one-shot-decision, preferred-designation, strategic-award",
		]
		rationale: "Materializa term-authority-type do glossary. 3 valores canônicos Phase 0 (per Patch 1 founder glossary: 'canônicos', NÃO enum congelado pré-domain-model — formal freezing Phase 3 pós-#PurchaseAuthorityType domain-type). Discriminator que sustenta authority validation gate: one-shot=hard binding direta; preferred=soft binding com validityPeriod; strategic=advisory Phase 0 (hard pós-CTR ContractActivated Phase 1+ per oq-p2p-1)."
	}, {
		code:        "vo-supplier-ref"
		name:        "SupplierRef"
		description: "Referência a um participante NPM (Fornecedor). Boundary com NPM — P2P consume ref, NPM mantém identidade canônica e qualificação. P2P NÃO consulta NPM diretamente per inv-no-supplier-revalidation-by-p2p — confia em SSC validação upstream."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Boundary explícita com NPM (single-owner per dp-04). Paralelo a SSC vo-supplier-ref. P2P consume sem revalidar — anti-mini-NIM."
	}, {
		code:        "vo-category-ref"
		name:        "CategoryRef"
		description: "Referência a uma Categoria de Compra (taxonomia configurada externamente). Eixo de segmentação operacional — authority validation por categoria; allocation tracking por categoria; fragmentation pattern detection por categoria."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Materializa term-categoria-de-compra (paralelo a SSC). Configuração externa governada — P2P consome ref, não define taxonomia."
	}, {
		code:        "vo-money"
		name:        "Money"
		description: "Quantia monetária com currency code — amount + currency. Imutável."
		fields: [{
			kind: "primitive"
			name: "amount"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "currency"
			type: "string"
		}]
		constraints: [
			"amount deve ser >= 0",
			"currency deve ser ISO 4217 code (3 letters, ex.: BRL, USD)",
		]
		rationale: "Tipo canônico de domínio para amounts. Sustenta auditoria + reconciliação spend. Currency multi-moeda suportada (paralelo a CMT/BDG)."

		// adr-151 Forma B (Peça 3b): elo ao primitivo compartilhado canônico.
		// Money puro (amount+currency) — aponta #Money + term-money como lar
		// canônico (P0: ponteiro, não cópia; os fields locais permanecem).
		shared:             true
		canonicalSchemaRef: "#Money"
		canonicalTermRef:   "term-money"
	}, {
		code:        "vo-purchase-scope"
		name:        "PurchaseScope"
		description: "Descrição estruturada do escopo de um Pedido de Compra — descrição do item/serviço, volume estimado, prazo de entrega, location relevante. Alinhado nominalmente com SSC vo-rfq-scope para coerência cross-BC vocabulary (estimatedVolume + deadline + location)."
		fields: [{
			kind: "primitive"
			name: "description"
			type: "string"
		}, {
			kind: "primitive"
			name: "estimatedVolume"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "deadline"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "location"
			type: "string"
		}]
		rationale: "Estruturação do escopo de PO é precondição de emit válido. estimatedVolume sustenta allocation tracking aggregate-level (prj-allocation-tracking computa volume agregado por authorityRef + supplier + category). Nomenclatura alinhada com SSC vo-rfq-scope (estimatedVolume + deadline) per cross-BC vocabulary consistency — drift prévio (requestedVolume + deliveryDeadline + unit) corrigido mecanicamente sem rationale defensável para divergência. Unit removido: não usado em invariants nem allocation tracking; sustentação prévia era especulativa. Quando unit emergir como conceito primário (e.g., per-categoryRef unit canonization), formalizar como VO próprio ou extension."
	}, {
		code:        "vo-cancellation-reason"
		name:        "CancellationReason"
		description: "Justificativa estruturada de cancelamento — texto livre + reasonCode discriminator. ReasonCode permite analytics + observability sobre padrões (taxa por categoria, etc)."
		fields: [{
			kind:        "primitive"
			name:        "reasonCode"
			type:        "string"
			description: "demand-cancelled | scope-mismatch | supplier-withdrawal | failed-validation-cleanup | admin-override | queue-overflow | other"
		}, {
			kind:        "primitive"
			name:        "narrative"
			type:        "string"
			description: "Justificativa documentada — obrigatória."
		}]
		constraints: [
			"reasonCode deve ser um dos: demand-cancelled, scope-mismatch, supplier-withdrawal, failed-validation-cleanup, admin-override, queue-overflow, other",
		]
		rationale: "Cancellation reasons são input crítico para drift signal + fragmentation pattern detection. ReasonCode failed-validation-cleanup distingue cancel de attempt recorded (state requested) de withdrawal pre-CMT (state emitted) per Patch 1 + Patch 4 founder. ReasonCode queue-overflow adicionado per adr-075 Caminho D' Phase 5: sustenta #OverflowPolicy.cancelReasonCode references quando bounded wait queue (route insufficient-context) atinge maxQueueDepth/maxQueueAge limits — auto-cancel-and-escalate fail-safe action limpa attempt + escala via existing escalation taxonomy, preservando invariants sob queue pressure (NÃO auto-approve sob pressure — classe de erro adversarial vetada por design)."
	}]

	// =============================================
	// AGGREGATES (consistency boundaries)
	// =============================================

	aggregates: [{
		code:        "agg-purchase-order"
		name:        "PurchaseOrder"
		description: "Aggregate central de P2P — consistency boundary do processo de emissão de Pedido de Compra sob authority pré-validada SSC. PurchaseOrder é conceito ÚNICO (NÃO 3 tipos paralelos) per Q1 canvas — discriminação via authorityType. 1 PO = 1 supplier (multi-supplier semantics vive em allocationPolicy upstream SSC; P2P respeita policy em agregado via prj-allocation-tracking). Lifecycle: requested → emitted | cancelled (terminal). Estado requested é 'emit attempt recorded' per Patch 1 founder — persiste mesmo se validation falhar (audit trail de attempt)."
		rootIdentity: {
			field: "purchaseOrderId"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-purchase-order-id"
			}
		}
		fields: [{
			kind:           "value-object-ref"
			name:           "supplier"
			valueObjectRef: "vo-supplier-ref"
			description:    "Optional — populated quando state=emitted (PO vinculada a supplier após validation success); ausente quando state=requested + authority validation falhou."
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
		}, {
			kind:           "value-object-ref"
			name:           "authorityRef"
			valueObjectRef: "vo-authority-ref"
			description:    "Reivindicada na criação (cmd-emit-purchase-order.claimedAuthorityRef). Validada via gate; permanece imutável pós-emit."
		}, {
			kind:           "value-object-ref"
			name:           "authorityType"
			valueObjectRef: "vo-authority-type"
			description:    "Resolved durante authority validation gate — determina binding regime + audit trail downstream."
		}, {
			kind:           "value-object-ref"
			name:           "requisitionRef"
			valueObjectRef: "vo-requisition-id"
			description:    "Requisição APROVADA que origina este pedido (adr-174 portão). Validada pelo 2º braço do gate de emissão (inv-emission-requires-approved-requisition); imutável pós-emit — elo de auditoria requisição → pedido."
		}, {
			kind:        "primitive"
			name:        "status"
			type:        "string"
			description: "requested | emitted | cancelled — discriminator do lifecycle."
		}, {
			kind:        "primitive"
			name:        "requestedAt"
			type:        "datetime"
			description: "Timestamp da criação do aggregate (cmd-emit-purchase-order recorded)."
		}, {
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Originadora — área/função que solicitou demanda."
		}, {
			kind:        "primitive"
			name:        "emittedAt"
			type:        "datetime"
			description: "Presente quando status=emitted."
		}, {
			kind:        "primitive"
			name:        "emittedBy"
			type:        "string"
			description: "Operador agente (agt-p2p-primary) ou supervisor — populated quando status=emitted."
		}, {
			kind:        "primitive"
			name:        "cancelledAt"
			type:        "datetime"
			description: "Presente quando status=cancelled."
		}, {
			kind:        "primitive"
			name:        "cancelledBy"
			type:        "string"
			description: "Presente quando status=cancelled."
		}, {
			kind:           "value-object-ref"
			name:           "cancellationReason"
			valueObjectRef: "vo-cancellation-reason"
			description:    "Presente quando status=cancelled."
		}]

		lifecycle: {
			initialState: "requested"
			states: ["requested", "emitted", "cancelled"]
			transitions: [{
				from:               "requested"
				to:                 "emitted"
				triggeredByCommand: "cmd-emit-purchase-order"
				emitsEvents: ["evt-purchase-order-emitted"]
				guards: [
					"inv-purchase-order-requires-valid-authority",
					"inv-emission-requires-approved-requisition",
					"inv-no-supplier-revalidation-by-p2p",
				]
				description: "Gates de emissão passam (authority validation + requisição aprovada per adr-174) — transição requested → emitted + evt-purchase-order-emitted publicado para CMT como hard binding operational signal."
			}, {
				from:               "requested"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-purchase-order"
				emitsEvents: ["evt-purchase-order-cancelled"]
				guards: ["inv-cancellation-pre-formalization-only"]
				description: "Cancelamento de attempt recorded (state requested cuja validation falhou e founder/admin decide limpar audit trail) — transição requested → cancelled + evt-purchase-order-cancelled publicado. Per Patch 4 founder, transition existe porque Patch 1 mantém attempt persistente — sem este path, requested seria dead-end."
			}, {
				from:               "emitted"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-purchase-order"
				emitsEvents: ["evt-purchase-order-cancelled"]
				guards: ["inv-cancellation-pre-formalization-only"]
				description: "Cancelamento de PO emitida pré-CMT formalization (originadora retira demanda; supplier withdraw; scope mismatch) — transição emitted → cancelled + evt-purchase-order-cancelled publicado como withdrawal/negative signal a CMT."
			}]
		}

		handlesCommands: [
			"cmd-emit-purchase-order",
			"cmd-cancel-purchase-order",
		]

		emitsEvents: [
			"evt-purchase-order-emitted",
			"evt-purchase-order-cancelled",
			"evt-sourcing-decision-made-received",
			"evt-preferred-supplier-designated-received",
			"evt-strategic-award-completed-received",
		]

		protectsInvariants: [
			"inv-purchase-order-requires-valid-authority",
			"inv-emission-requires-approved-requisition",
			"inv-allocation-convergence-aggregate-level",
			"inv-cancellation-pre-formalization-only",
			"inv-no-supplier-revalidation-by-p2p",
			"inv-purchase-order-lifecycle-public-events",
		]

		usesValueObjects: [
			"vo-purchase-order-id",
			"vo-requisition-id",
			"vo-authority-ref",
			"vo-authority-type",
			"vo-supplier-ref",
			"vo-category-ref",
			"vo-money",
			"vo-purchase-scope",
			"vo-cancellation-reason",
		]

		rationale: """
			Single aggregate central com root identity = purchaseOrderId
			(PO existe desde criação em state=requested 'emit attempt
			recorded' per Patch 1 founder; supplier + emittedAt são
			optional fields populated apenas quando state=emitted).

			Justificativa estrutural (per tq-dmg-07): persiste registry
			de POs (incluindo attempts failed validation persistidos como
			state=requested para audit trail) + sustenta gate determinístico
			de authority + carrega authorityRef/authorityType imutáveis
			pós-emit + sustenta inv-purchase-order-lifecycle-public-events
			via 2 events pareados emit/cancel. Sem essa estrutura
			persistente, gate determinístico regrediria a stateless e
			audit trail Lei 12.846 (5 anos retention) ficaria sem fonte
			canônica.

			Lifecycle 3 states (requested → emitted | cancelled) com 3
			transitions cobrindo todos paths Phase 0:
			- requested → emitted (cmd-emit-purchase-order, guards
			  inv-purchase-order-requires-valid-authority + inv-emission-
			  requires-approved-requisition (2º braço per adr-174) +
			  inv-no-supplier-revalidation-by-p2p): caminho normal (gates
			  passam); emite PurchaseOrderEmitted hard binding operational
			  signal a CMT.
			- requested → cancelled (cmd-cancel-purchase-order, guard
			  inv-cancellation-pre-formalization-only): limpa attempt
			  failed validation persistente (per Patch 4 founder porque
			  Patch 1 mantém attempt persistente — sem este path,
			  requested seria dead-end).
			- emitted → cancelled (cmd-cancel-purchase-order, guard
			  inv-cancellation-pre-formalization-only): withdrawal
			  pre-CMT formalization (originadora retira demanda; supplier
			  withdraw; scope mismatch). Emite PurchaseOrderCancelled
			  como withdrawal/negative signal a CMT.

			Aggregate creation: cmd-emit-purchase-order creates
			agg-purchase-order directly em initialState=requested e
			TENTA transition requested → emitted via guards — schema
			#Lifecycle não suporta create transition (from: ∅), criação
			implícita via initialState. Per Patch 1 founder semântica,
			requested é 'emit attempt recorded' (não 'PO válida aguardando
			emissão'): validation success transita imediato para emitted;
			validation failure deixa aggregate persistente em requested
			como audit trail (originadora pode then submeter cmd-cancel-
			purchase-order ou retentar com authorityRef diferente em
			novo aggregate).

			emitsEvents incluem 5 events: 2 published de PO lifecycle
			(PurchaseOrderEmitted + PurchaseOrderCancelled) + 3 internal
			ACL de SSC (-received). Os 3 events ACL são emitted/recorded
			in local event stream, not originated by aggregate decision
			(per Patch 2 founder) — paralelo a CMT/BDG/IDC/SSC pattern:
			aggregate registra fato no event stream local; ACL adapter
			produz semanticamente o evento traduzido. Naming 'emitsEvents'
			fica semanticamente torto para os ACL events mas convenção
			estabelecida é mantida — distinção semântica é capturada via
			visibility=internal + sourceContext=ssc fields.

			Multi-supplier first-class via authorityRef discriminator
			per Q1 canvas: agg-purchase-order tem 1 supplier por instância
			(supplier field é singular); multi-supplier semantics vive
			em allocationPolicy do upstream SSC decision (P2P respeita
			em agregado via prj-allocation-tracking + inv-allocation-
			convergence-aggregate-level monitoring obligation).
			PurchaseOrder é conceito único — discriminação via
			authorityType (one-shot-decision | preferred-designation |
			strategic-award) NÃO via 3 schemas paralelos.

			Anti-mini-NIM via inv-no-supplier-revalidation-by-p2p (P2P
			NÃO consulta NPM; sem QueryParticipantStatus em
			operationalScope) + boundary clarification founder Patch 4
			canvas: P2P NÃO possui supplier pool — apenas purchase
			authority; pool é responsabilidade SSC pré-validada upstream
			via NPM single-owner per dp-04.
			"""
	}, {
		code:        "agg-purchase-requisition"
		name:        "PurchaseRequisition"
		description: "Aggregate da Requisição de Compra — consistency boundary da PORTA da jornada (requisitante declara demanda → comprador tria como ato formal → gestor aprova por Alçada sob portão DUPLO pré-pedido → conversão em PO). Lifecycle: submitted → triaged → approved → converted | rejected | cancelled. Per adr-174 (PORTÃO): alçada e saldo são pré-condição da emissão; a aprovação RESERVA cobertura (two-phase Reservation/Confirmation, ADR-C4-2.0 §2.0.8). Per adr-177 (2º braço): o valor aprovado tem procedência verificada contra a cotação vencedora do ssc via sourcingDecisionRef."
		rootIdentity: {
			field: "requisitionId"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-requisition-id"
			}
		}
		fields: [{
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Requisitante — quem declarou a demanda (term-requisitante)."
		}, {
			kind:        "primitive"
			name:        "costCenterRef"
			type:        "string"
			description: "Centro de Custo alvo da cobertura — língua bdg; identidade canônica vive no bdg agg-cost-center."
		}, {
			kind:        "primitive"
			name:        "budgetStageRef"
			type:        "string"
			description: "Etapa do cronograma/orçamento que origina a demanda — fato-de-origem como CAMPO sem cerimônia (decisão do founder, WI-151)."
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
		}, {
			kind:        "primitive"
			name:        "status"
			type:        "string"
			description: "submitted | triaged | approved | converted | rejected | cancelled — discriminator do lifecycle."
		}, {
			kind:        "primitive"
			name:        "triageOutcome"
			type:        "string"
			description: "Último outcome de triagem registrado (routed-to-sourcing | returned | rejected) — presente após a primeira triagem; returned mantém status=submitted."
		}, {
			kind:        "primitive"
			name:        "coverageReservationRef"
			type:        "string"
			description: "Reserva de cobertura confirmada pelo Gate de Cobertura do bdg — presente quando status=approved (preservada em converted para auditoria do elo reserva → commitment)."
		}, {
			kind:        "primitive"
			name:        "sourcingDecisionRef"
			type:        "string"
			description: "Decisão de sourcing cuja cotação vencedora precificou a compra — língua ssc; presente quando status=approved (preservada em converted para auditoria da procedência do valor, adr-177). O elo requisição↔cotação persiste no aggregate."
		}, {
			kind:        "primitive"
			name:        "quantity"
			type:        "decimal"
			description: "Quantidade firme aprovada — presente quando status=approved; base da fórmula do 2º braço (unitPrice × quantity == amount; adr-177)."
		}, {
			kind:           "value-object-ref"
			name:           "purchaseOrderRef"
			valueObjectRef: "vo-purchase-order-id"
			description:    "PO originado desta requisição — presente quando status=converted."
		}, {
			kind: "primitive"
			name: "submittedAt"
			type: "datetime"
		}, {
			kind:        "primitive"
			name:        "triagedAt"
			type:        "datetime"
			description: "Presente após a primeira triagem."
		}, {
			kind:        "primitive"
			name:        "decidedAt"
			type:        "datetime"
			description: "Presente quando status alcançou approved ou rejected via decisão do gestor."
		}, {
			kind:        "primitive"
			name:        "convertedAt"
			type:        "datetime"
			description: "Presente quando status=converted."
		}, {
			kind:        "primitive"
			name:        "cancelledAt"
			type:        "datetime"
			description: "Presente quando status=cancelled."
		}, {
			kind:           "value-object-ref"
			name:           "cancellationReason"
			valueObjectRef: "vo-cancellation-reason"
			description:    "Presente quando status=cancelled."
		}]

		lifecycle: {
			initialState: "submitted"
			states: ["submitted", "triaged", "approved", "converted", "rejected", "cancelled"]
			transitions: [{
				from:               "submitted"
				to:                 "triaged"
				triggeredByCommand: "cmd-triage-requisition"
				emitsEvents: ["evt-purchase-requisition-triaged"]
				guards: ["inv-requisition-completeness"]
				selector: {
					name:         "sel-triage-route-to-sourcing"
					readsPayload: true
					rationale: """
						Discrimina por PAYLOAD: command.outcome == routed-to-sourcing. Par
						colidente com sel-triage-reject sobre (submitted,
						cmd-triage-requisition). O par NÃO é exaustivo sobre o domínio
						{routed-to-sourcing, returned, rejected}: outcome=returned não casa
						selector nenhum — devolução NÃO transiciona (requisição permanece
						submitted para correção; o evento registra o que falta). Per adr-160.
						"""
				}
				description: "Triagem formal aprova o roteamento (requisição completa per guard) — submitted → triaged + evt-purchase-requisition-triaged (outcome routed-to-sourcing); segue para cotação/decisão de sourcing."
			}, {
				from:               "submitted"
				to:                 "rejected"
				triggeredByCommand: "cmd-triage-requisition"
				emitsEvents: ["evt-purchase-requisition-triaged"]
				selector: {
					name:         "sel-triage-reject"
					readsPayload: true
					rationale: """
						Discrimina por PAYLOAD: command.outcome == rejected — demanda
						ilegítima ou duplicada morta na triagem. Par mutuamente exclusivo
						com sel-triage-route-to-sourcing; returned fica fora do par (não
						transiciona). Per adr-160.
						"""
				}
				description: "Triagem rejeita a demanda — submitted → rejected + evt-purchase-requisition-triaged (outcome rejected, narrative obrigatória)."
			}, {
				from:               "triaged"
				to:                 "approved"
				triggeredByCommand: "cmd-approve-purchase"
				emitsEvents: ["evt-purchase-approved"]
				guards: [
					"inv-approval-requires-coverage-reservation",
					"inv-approval-amount-matches-winning-quotation",
				]
				selector: {
					name:         "sel-purchase-approval-approve"
					readsPayload: true
					rationale: """
						Discrimina por PAYLOAD: command.decision == approve. Par mutuamente
						exclusivo com sel-purchase-approval-reject e exaustivo sobre o
						domínio pretendido {approve, reject} do cmd-approve-purchase. Os
						guards TERMINAIS inv-approval-requires-coverage-reservation e
						inv-approval-amount-matches-winning-quotation (portão DUPLO:
						cobertura bdg + procedência de preço ssc) barram o approve APÓS a
						seleção — falha de qualquer braço deixa a requisição em triaged
						(escalada supervisionada). Per adr-160 (selector roteia, guards
						terminam).
						"""
				}
				description: "Gestor aprova COM reserva de cobertura confirmada pelo Gate de Cobertura (Saldo Disponível + Alçada, sync) E procedência de preço verificada contra a cotação vencedora do ssc (unitPrice × quantity == amount, sync) — triaged → approved + evt-purchase-approved. O PORTÃO DUPLO (adr-174 + adr-177)."
			}, {
				from:               "triaged"
				to:                 "rejected"
				triggeredByCommand: "cmd-approve-purchase"
				emitsEvents: ["evt-purchase-approval-rejected"]
				selector: {
					name:         "sel-purchase-approval-reject"
					readsPayload: true
					rationale: """
						Discrimina por PAYLOAD: command.decision == reject. Par com
						sel-purchase-approval-approve (mutuamente exclusivo, exaustivo
						sobre {approve, reject}). Decisão HUMANA do gestor — distinta de
						falha do Gate de Cobertura, que não transiciona. Per adr-160.
						"""
				}
				description: "Gestor rejeita a compra — triaged → rejected + evt-purchase-approval-rejected (narrative obrigatória)."
			}, {
				from:               "approved"
				to:                 "converted"
				triggeredByCommand: "cmd-convert-requisition"
				emitsEvents: ["evt-purchase-requisition-converted"]
				description: "PO originado da requisição foi emitido (evt-purchase-order-emitted com requisitionRef) — pol-purchase-order-converts-requisition emite cmd-convert-requisition; approved → converted fecha o ciclo requisição → pedido."
			}, {
				from:               "submitted"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-purchase-requisition"
				emitsEvents: ["evt-purchase-requisition-cancelled"]
				description: "Requisitante retira a demanda antes da triagem — submitted → cancelled."
			}, {
				from:               "triaged"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-purchase-requisition"
				emitsEvents: ["evt-purchase-requisition-cancelled"]
				description: "Demanda retirada após triagem, antes da decisão do gestor — triaged → cancelled."
			}, {
				from:               "approved"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-purchase-requisition"
				emitsEvents: ["evt-purchase-requisition-cancelled"]
				description: "Requisição aprovada cancelada antes da conversão — approved → cancelled. Implica LIBERAR a reserva de cobertura no bdg (release per two-phase adr-174; disparo materializado no re-papel bdg-side WI-153 — janela declarada). Vigiado pela falsificação (b) do adr-174 (reservas órfãs)."
			}]
		}

		handlesCommands: [
			"cmd-submit-purchase-requisition",
			"cmd-triage-requisition",
			"cmd-approve-purchase",
			"cmd-convert-requisition",
			"cmd-cancel-purchase-requisition",
		]

		emitsEvents: [
			"evt-purchase-requisition-submitted",
			"evt-purchase-requisition-triaged",
			"evt-purchase-approved",
			"evt-purchase-approval-rejected",
			"evt-purchase-requisition-converted",
			"evt-purchase-requisition-cancelled",
		]

		protectsInvariants: [
			"inv-requisition-completeness",
			"inv-approval-requires-coverage-reservation",
			"inv-approval-amount-matches-winning-quotation",
		]

		usesValueObjects: [
			"vo-requisition-id",
			"vo-category-ref",
			"vo-purchase-scope",
			"vo-purchase-order-id",
			"vo-cancellation-reason",
		]

		rationale: """
			Consistency boundary SEPARADO do agg-purchase-order porque a
			requisição vive um ciclo próprio ANTES de qualquer pedido
			existir (submissão → triagem → aprovação) e pode morrer sem
			nunca virar PO (rejected, cancelled). Fundir os dois num
			aggregate acoplaria a fila de demanda ao registry de pedidos
			e faria o portão do adr-174 depender de estado do próprio
			artefato que ele deve gatear. A ponte é explícita: o PO
			carrega requisitionRef; a conversão é policy + command
			interno (pol-purchase-order-converts-requisition →
			cmd-convert-requisition), nunca mutação cross-aggregate.

			Lifecycle 6 states / 8 transitions. Criação implícita via
			initialState=submitted (cmd-submit-purchase-requisition cria;
			schema #Lifecycle não suporta create transition — mesmo
			pattern do agg-purchase-order). Dois pares colidentes com
			selectors per adr-160: (submitted, cmd-triage-requisition) →
			triaged | rejected via sel-triage-* (readsPayload: outcome);
			(triaged, cmd-approve-purchase) → approved | rejected via
			sel-purchase-approval-* (readsPayload: decision). Outcome
			returned da triagem NÃO transiciona — devolução deixa a
			requisição em submitted para correção (evento registra),
			paralelo ao attempt persistente do PO.

			O PORTÃO (adr-174, decisão A do def-078): aprovação exige
			reserva de cobertura confirmada pelo Gate de Cobertura do
			bdg ANTES de efetivar (inv-approval-requires-coverage-
			reservation, sync per adr-055 — mesmo shape npm↔idc).
			Two-phase Reservation/Confirmation (ADR-C4-2.0 §2.0.8):
			aprovação RESERVA; commitment aceito EFETIVA (re-papel
			bdg-side WI-153, fatia irmã — janela declarada); cancelamento
			LIBERA (cmd-release-budget-commitment). Falha do gate não
			transiciona nem emite — escalada supervisionada do bdg;
			rejeição HUMANA do gestor é transição própria (P10: gate e
			decisão não se confundem).

			Fato-de-origem da demanda = etapa do cronograma como CAMPO
			(budgetStageRef) sem cerimônia de observação, per decisão do
			founder no WI-151. costCenterRef/budgetStageRef são primitive
			refs cross-BC (língua bdg; identidade canônica vive lá) —
			mesma técnica do sourcingDecisionId nos eventos ACL de SSC.

			Anti-retrofit: todos os codes desta fatia nasceram dos
			elementos reais criados aqui (a requisição vivida na
			ds-buyer-procurement-journey, passos 1-3), nunca sintetizados
			do modelo para trás. A story referencia estes codes nos
			passos 2-3 APÓS esta materialização.
			"""
	}]

	// =============================================
	// POLICIES (automação event → command)
	// =============================================

	policies: [{
		code:             "pol-purchase-order-converts-requisition"
		name:             "Pedido de Compra Converte Requisição"
		description:      "Quando evt-purchase-order-emitted é publicado carregando requisitionRef, emite cmd-convert-requisition para transicionar a requisição aprovada (approved → converted) — fecha o ciclo requisição → pedido."
		triggeredByEvent: "evt-purchase-order-emitted"
		issuesCommand:    "cmd-convert-requisition"
		rationale:        "Automação determinística do fecho do ciclo per adr-174: a requisição não fica 'approved' órfã após o pedido nascer — converted registra a consumação. Paralelo ao pattern do cmt (pol-purchase-order-initiates-commitment). Command interno emitido por policy (tq-dm-12 carve-out; não exposto no canvas)."
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-active-purchase-authorities"
		name:        "ActivePurchaseAuthoritiesProjection"
		description: "Read model interno que materializa authorities vigentes — derivado de 3 events ACL de SSC (SourcingDecisionMadeReceived + PreferredSupplierDesignatedReceived + StrategicAwardCompletedReceived). Cache local consumido pelo aggregate via authority validation gate (sem sync query a SSC no caminho normal). Materializa term-purchase-authority-cache implícita (não termo separado per glossary refactor)."
		consumesEvents: [
			"evt-sourcing-decision-made-received",
			"evt-preferred-supplier-designated-received",
			"evt-strategic-award-completed-received",
		]
		queryCapabilities: [{
			code:        "qry-active-purchase-authorities"
			description: "Retorna authority vigente por authorityRef ou (categoryRef + supplier) — payload incluindo authorityType + selectedSuppliers/preferredSuppliers/awardedSuppliers + allocationPolicy + validityPeriod (preferred) + categoryRef. Consumer interno (gate determinístico authority validation)."
			rationale:   "Lookup principal do gate determinístico per inv-purchase-order-requires-valid-authority. Cache miss dispara sync fallback QuerySourcingDecision a SSC (canvas query-dependency). Cache stale pós-CTR cancel é openQuestion oq-ssc-5/oq-p2p-2 compartilhada."
		}]
		rationale: "Sustenta gate determinístico de authority validation sem latência de sync query no caminho normal. Latência alvo: <5s para consumers síncronos (alinhado eda-projections SLO). Phase 0 evolução: ContractActivated CTR (PHASE 1+ FORWARD-REF per oq-p2p-1) entra como event consumer adicional para bumping authorityType de strategic-award (advisory) → strategic-award-with-active-contract (hard) quando relação ctr-to-p2p for formalizada operacionalmente."
	}, {
		code:        "prj-purchase-orders"
		name:        "PurchaseOrdersProjection"
		description: "Read model que materializa POs (todas, todos states) consumidos por canvas query-surfaces QueryActivePurchaseOrders + QueryPurchaseOrderById. Source-of-record canônico para controllers (reporting), supervisores (visibility), CMT (cross-check pré-formalização), CTR (cross-check para strategic award), DRC futuro (dispute context)."
		consumesEvents: [
			"evt-purchase-order-emitted",
			"evt-purchase-order-cancelled",
		]
		queryCapabilities: [{
			code:        "qry-active-purchase-orders"
			description: "Retorna ActivePurchaseOrders (state=emitted) por categoryRef OR supplierRef OR requesterRef — lista com authority + status + emittedAt + cancellation status. Filtros suportados: categoria, supplier, requester."
			rationale:   "Canvas query-surface QueryActivePurchaseOrders. Suporta lookup por dimension operacional (controller filtra por categoria; supervisor por requester; CMT por supplier para cross-check)."
		}, {
			code:        "qry-purchase-order-by-id"
			description: "Retorna PurchaseOrder completa por purchaseOrderId — payload incluindo authorityRef + authorityType + supplier + scope + amount + audit metadata + cancellation status + reason."
			rationale:   "Canvas query-surface QueryPurchaseOrderById. Suporta lookup pontual (CMT formalization input; CTR cross-check; audit reconstitution histórica). POs históricas (cancelled, formalized via CMT) permanecem queriable para auditoria."
		}]
		rationale: "Per canvas query-surfaces QueryActivePurchaseOrders + QueryPurchaseOrderById. POs em state=requested (attempts persistentes failed validation) NÃO entram em qry-active-purchase-orders (filtro state=emitted) — visibility de attempts é via projection separada se demanda emergir Phase 1+ (oq-p2p-attempts-visibility deferred futuro). Phase 0: attempts ficam apenas no aggregate event stream local; não expostos cross-context."
	}, {
		code:        "prj-allocation-tracking"
		name:        "AllocationTrackingProjection"
		description: "Read model interno que mantém volume agregado emitido por authorityRef + supplier + categoryRef ao longo de janela ativa (validityPeriod para preferred; janela operacional para one-shot/strategic). Source-of-record para inv-allocation-convergence-aggregate-level monitoring obligation + sig-allocation-drift signal."
		consumesEvents: [
			"evt-purchase-order-emitted",
		]
		queryCapabilities: [{
			code:        "qry-allocation-tracking-by-authority"
			description: "Retorna AllocationStatus por authorityRef — total volume emitido por supplier vs allocationPolicy declarada (split-by-percentage tracking). Drift sustentado dispara sig-allocation-drift signal a SSC (OBS observability)."
			rationale:   "Consumer interno do agente P2P (drift detection cross-PO) + signal feed a SSC fitness rules reconsideração. Phase 0 monitoring + reporting (não enforcement); Phase 1+ pode evoluir para hard gate se feedback loop estabilizar (oq-p2p-3 + oq-ssc-3 bridge)."
		}]
		rationale: "Sustenta inv-allocation-convergence-aggregate-level monitoring obligation per Patch 3 founder ('P2P MUST monitor and report sustained drift', NÃO 'volume converge' enforcement). Materializa term-allocation-convergence + term-allocation-bias do glossary. P2P observa convergência, NÃO decide allocation — anti-mini-NIM: agente NÃO computa fairness allocation (responsabilidade SSC fitness rules); apenas tracked + signal. Cancellations NÃO consumidas (Phase 0): cancelled POs já não foram entregues; volume real entregue é tracked downstream em CMT/DLV; Phase 0 P2P projection trackeia apenas emitted volumes como proxy operacional."
	}, {
		code:        "prj-purchase-history-by-category"
		name:        "PurchaseHistoryByCategoryProjection"
		description: "Read model interno que mantém histórico agregado de POs por categoria — frequência de cancelamentos, distribuição de suppliers, padrões de emit por requester. Sustenta term-fragmentation-pattern detection (POs sub-threshold artificialmente fragmentadas para evitar gates de aprovação SSC)."
		consumesEvents: [
			"evt-purchase-order-emitted",
			"evt-purchase-order-cancelled",
		]
		queryCapabilities: [{
			code:        "qry-purchase-history-by-category"
			description: "Retorna PurchaseHistoryAggregate por categoria — estatísticas históricas (volume médio por PO; frequência por requester; cancellation rate; supplier diversity). Consumer interno P2P para fragmentation pattern detection (sh-01 vetor adversarial)."
			rationale:   "Consumer interno do agente P2P — comparação contra padrões esperados detecta fragmentation (sub-threshold splitting). Sustenta sh-01 designResponse + escalation 'fragmentation-pattern-detected' do canvas."
		}]
		rationale: "Sustenta as-p2p-2 (PO history como signal robusto) + term-fragmentation-pattern detection. Cancellations consumidas para detectar padrões anômalos (categoria com taxa alta de cancellation pode indicar scope mal-definido OR maverick masking via cancel/re-emit). Phase 0 detection local; cross-BC coordination (oq-p2p-6) deferida Phase 1+ quando NIM aggregation suportar pattern correlation cross-context."
	}, {
		code:        "prj-pending-requisitions"
		name:        "PendingRequisitionsProjection"
		description: "Read model da fila de requisições — materializa requisições por estado (submitted aguardando triagem; triaged aguardando decisão do gestor; approved aguardando conversão) + terminais (converted, rejected, cancelled) para leitura histórica. Sustenta a fila de trabalho do comprador (triagem) e do gestor (aprovação) — passo 3 da ds-buyer-procurement-journey — e o gate de emissão inv-emission-requires-approved-requisition (accessVia projection, intra-BC)."
		consumesEvents: [
			"evt-purchase-requisition-submitted",
			"evt-purchase-requisition-triaged",
			"evt-purchase-approved",
			"evt-purchase-approval-rejected",
			"evt-purchase-requisition-converted",
			"evt-purchase-requisition-cancelled",
		]
		queryCapabilities: [{
			code:        "qry-pending-requisitions"
			description: "Retorna requisições por estado com filtros por costCenterRef, categoryRef e requestedBy — payload incluindo triageOutcome, coverageReservationRef (quando approved) e purchaseOrderRef (quando converted). Consumers: comprador (fila de triagem), gestor (fila de aprovação), gate de emissão (lookup de requisição approved por requisitionId)."
			rationale:   "A fila que o comprador vive no passo 3 da jornada + o lookup determinístico do 2º braço do gate de emissão (inv-emission-requires-approved-requisition lê estado approved + reserva vigente no momento do emit)."
		}]
		rationale: "Sem esta projeção, a fila de triagem/aprovação — o instrumento diário do comprador e do gestor na PORTA da jornada — não seria consultável, e o gate de emissão do adr-174 ficaria sem read path intra-BC declarado (accessVia projection per adr-055/tq-dm-17). Latência alvo <5s (alinhado eda-projections SLO, paralelo às demais projeções do BC)."
	}]

	rationale: """
		Domain model do BC Procure-to-Pay modela 2 aggregates:
		agg-purchase-requisition (a PORTA da jornada — requisição →
		triagem formal → aprovação com Gate de Cobertura pré-pedido,
		per adr-174/WI-151) e agg-purchase-order (emissão de PO sob
		authority pré-validada SSC), cobrindo o escopo declarado em
		canvas Phase 0 (Procure execution NÃO Pay; pagamento é FCE;
		faturamento é INV per Adj 1 founder canvas). Root identity do
		PO = purchaseOrderId (PO existe desde criação em state=requested
		'emit attempt recorded' per Patch 1 founder; supplier + emittedAt
		populated apenas quando state=emitted); da requisição =
		requisitionId (existe desde a submissão).

		7 commands cobrindo os dois lifecycles. Requisição (5):
		cmd-submit-purchase-requisition (entry async; criação em
		initialState=submitted), cmd-triage-requisition (triagem como
		ATO FORMAL com outcome routed-to-sourcing | returned | rejected),
		cmd-approve-purchase (decisão do gestor por Alçada; approve
		exige reserva de cobertura confirmada per adr-174),
		cmd-convert-requisition (interno, emitido por policy),
		cmd-cancel-purchase-requisition (retirada pré-conversão). PO
		(2): cmd-emit-purchase-order (entry com aggregate creation
		directly em initialState=requested e tentativa de transition
		para emitted via gates de emissão — authority + requisição
		aprovada), cmd-cancel-purchase-order (cancel supervised pré-
		CMT formalization; 2 cenários — cleanup de attempt failed em
		state requested OR withdrawal de PO emitida pré-CMT).

		FATIA DA REQUISIÇÃO (adr-174 / WI-151): a aprovação de compra é
		PORTÃO pré-pedido (decisão A do def-078). Ordem canônica:
		requisição → triagem (ato formal com outcome) → aprovação com
		Gate de Cobertura do bdg (Saldo Disponível + Alçada, sync per
		adr-055) → emissão do pedido → commitment. Two-phase
		Reservation/Confirmation (ADR-C4-2.0 §2.0.8): aprovação RESERVA
		cobertura; commitment aceito EFETIVA; cancelamento LIBERA. O
		re-papel bdg-side (policy → efetivação + evento de reserva) é
		fatia irmã WI-153 — janela declarada em que a policy antiga do
		bdg ainda descreve o papel velho. Fato-de-origem da demanda =
		etapa do cronograma como CAMPO (budgetStageRef), sem cerimônia
		de observação, per decisão do founder na conversa do WI-151.
		Outcome-split da triagem e da aprovação via selectors per
		adr-160 (2 pares colidentes; returned não transiciona).

		Multi-supplier first-class via authorityRef discriminator per
		Q1 canvas: agg-purchase-order tem 1 supplier por instância;
		multi-supplier semantics vive em allocationPolicy upstream SSC
		(P2P respeita em agregado via prj-allocation-tracking + inv-
		allocation-convergence-aggregate-level monitoring obligation).
		PurchaseOrder é conceito ÚNICO — discriminação via authorityType
		(one-shot-decision | preferred-designation | strategic-award)
		NÃO via 3 schemas paralelos.

		Behavior-first ordering aplicado na derivação original: events
		emergiram do canvas (2 published de PO lifecycle + 3 internal
		ACL de SSC); commands derivaram de canvas inbound
		(EmitPurchaseOrder + CancelPurchaseOrder); invariants protegidos
		derivados dos 6 businessDecisions do canvas (1 RECTOR + 5
		operacionais incluindo 1 NEGATIVO). A fatia da requisição
		(WI-151) somou 6 events internal + 5 commands + 3 invariants ao
		catálogo. Value-objects emergentes dos payloads + glossary
		terms: 9 VOs (identity do PO + identity da requisição per
		WI-151 + authority discriminator + scope + money + cancellation
		reason + refs de boundary).

		Anti-mini-NIM como invariant transversal materializado em 5
		layers (paralelo a SSC):
		(a) inv-purchase-order-requires-valid-authority (RECTOR — gate
		    determinístico autoridade pré-validada);
		(b) inv-no-supplier-revalidation-by-p2p (NEGATIVO — P2P NÃO
		    possui supplier pool, apenas purchase authority per Patch
		    4 founder canvas; sem QueryParticipantStatus em
		    operationalScope);
		(c) inv-allocation-convergence-aggregate-level (monitoring
		    obligation Phase 0 — observable property + signal a SSC,
		    NÃO enforcement strict per Patch 3 founder);
		(d) capability rationale + sh-05 designResponse (allocation
		    bias via tracking aggregate-level);
		(e) escalation routing (insufficient/conflicting/expired/
		    exhausted authority — TODOS supervisedDecision escalation
		    para gate humano).

		Cross-BC state dependencies (tq-dm-17 + tq-dmg-09 per adr-055):
		4 invariants declaram dependsOnAggregateState first-class — 2
		cross-BC → SSC agg-sourcing-process (inv-purchase-order-requires-
		valid-authority via QuerySourcingDecision; inv-approval-amount-
		matches-winning-quotation via QueryQuotationMap, adr-177), 1
		cross-BC → BDG agg-cost-center (inv-approval-requires-coverage-
		reservation via QueryBudgetApprovalStatus, adr-174/WI-153) e 1
		intra-BC (inv-emission-requires-approved-requisition via
		prj-pending-requisitions). Granularidade per-invariant per
		heuristic do PG. Demais state (aggregates internos + projections)
		é intra-BC.

		Lifecycle 3 states com 3 transitions per Patch 4 founder:
		- requested → emitted (validation passa)
		- requested → cancelled (cleanup de attempt failed validation
		  persistente — necessário porque Patch 1 mantém attempt
		  persistente; sem este path, requested seria dead-end)
		- emitted → cancelled (withdrawal pre-CMT)

		Aggregate creation: cmd-emit-purchase-order creates aggregate
		directly em initialState=requested e TENTA transition para
		emitted via guards — schema #Lifecycle não suporta create
		transition (from: ∅), criação implícita via initialState. Per
		Patch 1 founder semântica, requested é 'emit attempt recorded'
		(NÃO 'PO válida aguardando emissão'): validation success transita
		imediato para emitted; validation failure deixa aggregate
		persistente em requested como audit trail.

		emitsEvents incluem 5 events: 2 published de PO lifecycle
		(PurchaseOrderEmitted hard binding operational signal a CMT +
		PurchaseOrderCancelled withdrawal/negative signal pre-CMT) + 3
		internal ACL de SSC (-received). Per Patch 2 founder, os 3 ACL
		events são emitted/recorded in local event stream, not originated
		by aggregate decision — paralelo a CMT/BDG/IDC/SSC pattern:
		aggregate registra fato no event stream local; ACL adapter
		produz semanticamente o evento traduzido. Naming 'emitsEvents'
		fica semanticamente torto para os ACL events mas convenção
		estabelecida é mantida — distinção semântica capturada via
		visibility=internal + sourceContext=ssc fields.

		5 projections como read models:
		- prj-active-purchase-authorities (cache de 3 ACL events;
		  sustenta gate determinístico de authority validation sem
		  latência de sync query no caminho normal)
		- prj-purchase-orders (canvas query-surfaces QueryActive
		  PurchaseOrders + QueryPurchaseOrderById; source-of-record
		  para CMT/CTR/DRC cross-check)
		- prj-allocation-tracking (sustenta inv-allocation-convergence-
		  aggregate-level monitoring obligation; sig-allocation-drift
		  signal a SSC)
		- prj-purchase-history-by-category (term-fragmentation-pattern
		  detection — sh-01 vetor adversarial; cross-BC coordination
		  oq-p2p-6 Phase 1+ deferred)
		- prj-pending-requisitions (fila de triagem/aprovação da
		  requisição — passo 3 da jornada; lookup intra-BC do gate
		  inv-emission-requires-approved-requisition per adr-174)

		1 policy + 0 domain services: pol-purchase-order-converts-
		requisition (evt-purchase-order-emitted → cmd-convert-
		requisition) fecha o ciclo requisição → pedido per adr-174.
		Policy adicional poderia emergir Phase 1+ se ContractActivated
		CTR consumer materializar (automate authorityType bumping
		advisory→hard); Phase 0 é commit point de cache update
		(manual por agent).

		Lenses aplicadas:
		- lens-organizational-resource-allocation (primária): aggregate
		  modela alocação de POs sob authority pré-validada SSC;
		  allocationPolicy upstream respeitada em agregado via
		  prj-allocation-tracking + inv-allocation-convergence
		  monitoring; multi-supplier first-class preservado via
		  authorityRef discriminator.
		- lens-incentive-alignment (secundária): invariants e gate
		  determinístico de authority protegem contra 3 vetores
		  adversariais — sh-01 fragmentation (prj-purchase-history-
		  by-category detection) + sh-02 renegotiation (PO immutability
		  pós-emit) + sh-05 allocation bias (prj-allocation-tracking
		  + sig-allocation-drift signal). Anti-mini-NIM como invariant
		  transversal protege P2P de virar 'mini-SSC'.
		- lens-event-driven-architecture-patterns (secundária): 2
		  events published com semântica inequívoca (PO lifecycle); 6
		  events internal da requisição (WI-151) + 3 internal ACL de
		  SSC traduzidos via convenção -received; 5 projections como
		  read models com SLO de latência <5s; 1 policy (conversão
		  requisição → pedido per adr-174).
		- lens-information-economics (terciária): authorityRef
		  preserving link to sourcing decision rationale rich (SSC
		  decisionRationale acessível via QuerySourcingDecision);
		  PO data como signal NIM intelligence learning loop bridge
		  Phase 1+ (paralelo a oq-ssc-2). Phase 0: NIM consumer pendente.

		Phase 0 caveats:
		- PurchaseOrderCancelled cobre apenas pre-CMT formalization
		  withdrawal (pós-CMT cancellation requer cross-BC coordination
		  cancel-cascade entre P2P + CMT — oq-p2p-2 deferred).
		- CTR ContractActivated PHASE 1+ FORWARD-REF (oq-p2p-1) NÃO
		  incluído como event-consumer Phase 0; ctr-to-p2p relation
		  no context-map materializa apenas Phase 1+ pós oq-p2p-1.
		- Strategic-award authorityType Phase 0 advisory binding;
		  hard binding ativa apenas pós-CTR ContractActivated Phase
		  1+ per oq-p2p-1.
		- Supplier API (acceptance/rejection by supplier) Phase 1+
		  per oq-p2p-4; Phase 0 modela apenas notification (NTF
		  transversal) sem aceite/rejeição.
		- inv-allocation-convergence-aggregate-level Phase 0 é
		  monitoring obligation (observable + signal); enforcement
		  strict requer domain-model mechanisms Phase 1+ (oq-p2p-3
		  + oq-ssc-3 bridge).
		- prj-purchase-history-by-category fragmentation detection
		  é local Phase 0; cross-BC coordination cross-context
		  pattern correlation Phase 1+ via NIM aggregation (oq-p2p-6
		  deferred).
		- Attempts persistentes (state=requested failed validation)
		  visibility cross-context é via projection separada se
		  demanda emergir Phase 1+ (não exposta em prj-purchase-orders
		  Phase 0 por filtro state=emitted).

		Glossary alignment: 16 terms canônicos do glossary (15 da
		Phase 2 + term-requisicao do WI-151) reconciliados com
		events/commands/aggregates/value-objects.
		Mapeamentos chave: term-purchase-order → vo-purchase-order-id
		+ agg-purchase-order; term-sourcing-authority → vo-authority-
		ref + inv-purchase-order-requires-valid-authority; term-
		authority-type → vo-authority-type discriminator; term-
		authority-validation → gate determinístico via prj-active-
		purchase-authorities + sync fallback QuerySourcingDecision;
		term-allocation-convergence → inv-allocation-convergence-
		aggregate-level + prj-allocation-tracking; term-po-lifecycle
		→ agg-purchase-order lifecycle 3 states; term-purchase-order-
		emitted/cancelled → 2 events published; term-maverick → gate
		determinístico bloqueio + escalation supervisedDecision; term-
		fragmentation-pattern → prj-purchase-history-by-category +
		sh-01 designResponse; term-allocation-bias → inv-allocation-
		convergence + sig-allocation-drift + prj-allocation-tracking;
		term-renegotiation-pressure → PO immutability pós-emit
		(authorityRef + amount + scope + supplier imutáveis); term-
		originadora-de-demanda → cmd-emit-purchase-order.requestedBy
		+ aggregate.requestedBy; term-fornecedor-qualificado →
		boundary explícita via inv-no-supplier-revalidation-by-p2p
		(P2P NÃO revalida — confia em SSC validação upstream); term-
		requisicao → agg-purchase-requisition + vo-requisition-id +
		lifecycle 6 states (WI-151). Sem
		divergências terminológicas identificadas. Frase canônica
		preservada (SSC decide sourcing; P2P emite pedido sob
		authority; CMT formaliza compromisso) via separação clara
		de responsabilidades — agg-purchase-order não emite commands
		para SSC/CMT (apenas events que outros BCs consomem).
		"""
}
