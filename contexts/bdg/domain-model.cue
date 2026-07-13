package bdg

// domain-model.cue — Domain Model do BC Budget & Approval.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Materializado via subagent dispatch (disp-006) pós-WI-069 +
// adr-074 rollout extension. Cascade ordering per adr-054
// decision item 13: PG existe.
//
// Modela 1 aggregate central: agg-cost-center (consistency boundary
// de comprometimento orçamentário por centro de custo). Lifecycle
// não declarado para o aggregate — Centro de Custo persiste estado
// (limite + comprometimentos ativos) mas não tem state machine
// canônica (criação, ajuste e descontinuação são governance
// externa per bd-allocation-not-treasury). Aggregate justifica-se
// como tal (não service) por persistir registry de Comprometimentos
// Orçamentários ativos que sustenta invariantes (saldo, idempotência
// por compromisso) — vide tq-dmg-07 stateless aggregate test.
//
// Behavior-first ordering aplicado: events identificados primeiro
// do canvas (1 published spine + 2 internal pendentes de
// formalização cross-BC per oq-bdg-2 + 1 internal ACL); commands
// derivados de canvas inbound + intenção interna de liberação;
// invariants protegidos derivados de businessDecisions e
// autonomousDecisions; value-objects emergentes de payloads
// (CostCenterId, Money, BudgetCommitmentId,
// CommitmentReleaseReason, RejectionReason, BudgetApprovalStatus,
// CostCenterAvailability). Aggregate wira catalog.
//
// Glossary alignment: events/commands/aggregates/value-objects
// reconciliados com terms canônicos do glossary BDG (16 terms —
// term-efetivacao-de-reserva entrou no WI-153).
// 15/16 mapeados explicitamente; term-fracionamento NÃO modelado
// como invariant local (aguarda oq-bdg-1 — agregação cross-BC com
// REW). Sem divergências terminológicas identificadas.
//
// Lenses aplicadas:
// - lens-organizational-resource-allocation (primária): Centro
//   de Custo modelado como unidade canônica de allocation;
//   Saldo Disponível como capacidade prospectiva derivada de
//   Limite menos comprometimentos ativos; Comprometimento
//   Orçamentário como reserva que reduz capacidade; Liberação
//   como reversão que devolve capacidade. Alçada modela
//   delegation-fitness (ora-delegation-fitness): faixa em que
//   ator pode autorizar autonomamente vs requer escalação.
//   Strategic neglect (ora-strategic-neglect): BDG NÃO realoca
//   entre centros (bd-allocation-not-treasury).
// - lens-event-driven-architecture-patterns (secundária):
//   BudgetApproved/BudgetRejected/BudgetCommitmentReleased
//   modelados como published events (eda-domain-vs-integration-
//   events); event sourcing implícito do agregado (eda-event-
//   sourcing) sustenta auditabilidade contínua (cap-04);
//   projeções (prj-budget-approval-status, prj-cost-center-
//   availability) materializam read models per CQRS (eda-cqrs);
//   policy pol-commitment-accepted-triggers-approval automatiza
//   evt-commitment-accepted-received → cmd-confirm-budget-reservation
//   (efetivação da reserva per adr-174/WI-153; eda-choreography-vs-
//   orchestration: choreography para trigger, orchestration interna).
//
// [ATUALIZADO 2026-07-13 — adr-174 / WI-153] Re-papel two-phase
// Reservation/Confirmation: o Gate de Cobertura é invocado no PORTÃO
// (aprovação da requisição no p2p, pré-pedido) e RESERVA cobertura
// keyed por requisitionRef (fase 1: evt-coverage-reserved, status
// reserved — o CommitmentId não existe ainda); o CommitmentAccepted
// EFETIVA a reserva (fase 2: cmd-confirm-budget-reservation →
// evt-budget-approved, status confirmed — spine bdg-to-dlv intocado
// em contrato); o release LIBERA (inclui cancelamento de requisição
// no p2p). +1 event, +1 command, +1 invariant; enum de status
// QUEBRADO por decisão D3 (approved → reserved|confirmed).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code:              "bdg"
	name:              "Budget & Approval Domain Model"
	boundedContextRef: "bdg"

	// =============================================
	// EVENTS (catalog top-level)
	// =============================================

	events: [{
		code:        "evt-coverage-reserved"
		name:        "CoverageReserved"
		visibility:  "published"
		description: "Reserva de cobertura registrada pelo Gate de Cobertura no PORTÃO (fase 1 do two-phase adr-174): a aprovação da requisição de compra (p2p) reservou Saldo Disponível + Alçada contra o Centro de Custo, keyed por requisitionRef — o CommitmentId ainda não existe neste momento. Comprometimento nasce em status=reserved; a efetivação (fase 2) ancora o commitment aceito à reserva."
		rationale:   "O evento de reserva declarado no adr-174 decisão 4 — sem ele, a fase 1 do two-phase seria estado mudo (o saldo reduziria sem fato auditável de primeira classe). Published paralelo ao trio canônico (BudgetApproved/Rejected/Released). Consumo assíncrono cross-BC é anchor: o P2P lê a reserva via QueryBudgetApprovalStatus sync no portão (caminho operacional Phase 0); cache local event-fed é evolução futura, paralela a prj-active-purchase-authorities."
		fields: [{
			kind:        "primitive"
			name:        "requisitionRef"
			type:        "string"
			description: "Requisição de compra (p2p vo-requisition-id) cuja aprovação reservou a cobertura — a chave da fase 1. Primitive ref cross-BC: p2p mantém a identidade canônica."
		}, {
			kind:           "value-object-ref"
			name:           "costCenterId"
			valueObjectRef: "vo-cost-center-id"
			description:    "Centro de Custo contra o qual a cobertura foi reservada — declarado na própria requisição desde a submissão (WI-151 costCenterRef)."
		}, {
			kind:           "value-object-ref"
			name:           "budgetCommitmentId"
			valueObjectRef: "vo-budget-commitment-id"
			description:    "Identificador da reserva — é o coverageReservationRef que o p2p guarda na requisição aprovada."
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
			description:    "Valor reservado contra o Centro de Custo — o amount aprovado no portão (valor da cotação vencedora, per WI-151)."
		}, {
			kind: "primitive"
			name: "reservedAt"
			type: "datetime"
		}, {
			kind:        "primitive"
			name:        "approvedBy"
			type:        "string"
			description: "Ator que autorizou no gate (agente operador ou supervisor em override) — o de-acordo do gestor vive no p2p (evt-purchase-approved.approvedBy)."
		}]
	}, {
		code:        "evt-budget-approved"
		name:        "BudgetApproved"
		visibility:  "published"
		description: "Reserva de cobertura EFETIVADA (fase 2 do two-phase adr-174): o commitment aceito foi ancorado ao Comprometimento reservado no portão (reserved → confirmed) — o CommitmentId liga-se à reserva; o valor não muda (reservou na fase 1). Sinal canônico de progressão no commitment lifecycle. Spine commitment-lifecycle no context-map (bdg-to-dlv, async) — contrato INTOCADO pelo re-papel: DLV segue consumindo BudgetApproved keyed por CommitmentId, agora emitido no momento certo (pós-commitment, quando há execução a habilitar)."
		rationale:   "Event publisher declarado em canvas.communication.outbound[]. DLV consome para habilitar verificação de execução — fields intactos (commitmentId, budgetCommitmentId, amount) preservam o contrato downstream através do re-papel adr-174/WI-153. Emitido por cmd-confirm-budget-reservation (efetivação via pol-commitment-accepted-triggers-approval); o split de outcome do GATE vive na fase 1 (CoverageReserved vs BudgetRejected) — a efetivação pressupõe gate já passado na reserva (inv-confirmation-requires-active-reservation). Semântica inequívoca preservada (tq-dmg-06)."
		fields: [{
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Identificador do compromisso CMT que recebeu cobertura."
		}, {
			kind:           "value-object-ref"
			name:           "costCenterId"
			valueObjectRef: "vo-cost-center-id"
			description:    "Centro de Custo contra o qual o Comprometimento foi registrado."
		}, {
			kind:           "value-object-ref"
			name:           "budgetCommitmentId"
			valueObjectRef: "vo-budget-commitment-id"
			description:    "Identificador do Comprometimento Orçamentário registrado."
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
			description:    "Valor reservado contra o Centro de Custo."
		}, {
			kind:        "primitive"
			name:        "approvedAt"
			type:        "datetime"
			description: "Timestamp da aprovação."
		}, {
			kind:        "primitive"
			name:        "approvedBy"
			type:        "string"
			description: "Identificador do ator que autorizou (agente operador ou supervisor humano em caso de override)."
		}]
	}, {
		code:        "evt-budget-rejected"
		name:        "BudgetRejected"
		visibility:  "published"
		description: "Gate de Cobertura concluiu ausência de cobertura, com motivo estruturado (insufficient-balance, invalid-cost-center, alcada-exceeded). No caminho canônico pós-adr-174 a rejeição acontece na FASE 1 (portão), keyed por requisitionRef: o p2p recebe a falha sync e a requisição permanece triaged (escalada supervisionada do bdg). CMT/DRC consomem em cenário residual pós-formalização. Publicação direta para CMT/DRC pendente de formalização no context-map (oq-bdg-2)."
		rationale:   "Counterpart de evt-budget-approved. Published para preservar rejeição como fato auditável de primeira classe (não como result code negativo de aprovação). Estruturação do motivo permite consumers reagirem programaticamente. Em Phase 0 antes de oq-bdg-2 resolver, evento permanece em audit trail; ativação de propagação direta cross-BC depende de formalização no context-map."
		fields: [{
			kind:        "primitive"
			name:        "requisitionRef"
			type:        "string"
			description: "Requisição cuja cobertura foi rejeitada no portão — a chave do caminho canônico (fase 1, per adr-174/WI-153)."
		}, {
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Compromisso referenciado — presente apenas em rejeição residual pós-formalização; AUSENTE no caminho canônico (rejeição de fase 1, pré-commitment)."
		}, {
			kind:           "value-object-ref"
			name:           "costCenterId"
			valueObjectRef: "vo-cost-center-id"
			description:    "Centro de Custo avaliado (pode ser ausente se motivo é invalid-cost-center)."
		}, {
			kind:           "value-object-ref"
			name:           "requestedAmount"
			valueObjectRef: "vo-money"
			description:    "Valor solicitado para cobertura."
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-rejection-reason"
			description:    "Motivo estruturado da rejeição."
		}, {
			kind:        "primitive"
			name:        "rejectedAt"
			type:        "datetime"
			description: "Timestamp da rejeição."
		}]
	}, {
		code:        "evt-budget-commitment-released"
		name:        "BudgetCommitmentReleased"
		visibility:  "published"
		description: "Liberação de Comprometimento executada — Comprometimento Orçamentário previamente registrado é revertido e o valor devolvido ao Saldo Disponível do Centro de Custo. CMT consome para manter consistência interna do estado do compromisso. Publicação direta para CMT pendente de formalização no context-map (oq-bdg-2)."
		rationale:   "Completa o trio canônico de eventos de BDG (BudgetApproved, BudgetRejected, BudgetCommitmentReleased). Cada evento é fato auditável de primeira classe. Triggered por cancelamento de requisição aprovada no p2p (release de reserva pré-efetivação, per adr-174/WI-153), cancelamento em CMT, ajuste supervisionado ou conclusão integral em FCE. Publicação cross-BC pendente de oq-bdg-2; em Phase 0 evento serve audit trail interno e anchor para futura ativação."
		fields: [{
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Compromisso cuja reserva foi liberada."
		}, {
			kind:           "value-object-ref"
			name:           "costCenterId"
			valueObjectRef: "vo-cost-center-id"
			description:    "Centro de Custo cujo Saldo Disponível foi reabastecido."
		}, {
			kind:           "value-object-ref"
			name:           "budgetCommitmentId"
			valueObjectRef: "vo-budget-commitment-id"
			description:    "Identificador do Comprometimento revertido."
		}, {
			kind:           "value-object-ref"
			name:           "releasedAmount"
			valueObjectRef: "vo-money"
			description:    "Valor devolvido ao Saldo Disponível."
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-commitment-release-reason"
			description:    "Causa estruturada da liberação: cancellation, full-execution, supervised-adjustment."
		}, {
			kind:        "primitive"
			name:        "releasedAt"
			type:        "datetime"
			description: "Timestamp da liberação."
		}]
	}, {
		code:          "evt-commitment-accepted-received"
		name:          "CommitmentAcceptedReceived"
		visibility:    "internal"
		sourceContext: "cmt"
		description:   "Tradução ACL de CommitmentAccepted (CMT). Sinal canônico de entrada do commitment lifecycle no escopo de BDG; trigger para EFETIVAÇÃO da reserva feita no portão (reserved → confirmed, per adr-174/WI-153) — o Gate de Cobertura já rodou na fase 1 (aprovação da requisição)."
		rationale:     "Evento interno traduzido de sinal externo de CMT (cmt-to-bdg, async). Domain model permanece puro — linguagem local. Trigger para pol-commitment-accepted-triggers-approval (re-papelizada: efetivação, não gate). O ACL adapter ENRIQUECE o evento com requisitionRef derivando commitment → purchaseOrderRef → requisitionRef (o aggregate do cmt guarda purchaseOrderRef; QueryPurchaseOrderById do p2p resolve o requisitionRef) — mesmo papel de enriquecimento que as-bdg-1 já estabelece para Centro de Custo. cmt INTOCADO: a necessidade do bdg resolve na borda do bdg (D1 founder). Sufixo -received segue convenção ACL estabelecida em CMT/NPM."
		fields: [{
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Identificador do compromisso aceito em CMT."
		}, {
			kind:        "primitive"
			name:        "requisitionRef"
			type:        "string"
			description: "Requisição de origem do commitment — ENRIQUECIDO pelo ACL adapter (cadeia commitment → purchaseOrderRef → requisitionRef; premissa paralela a as-bdg-1, D1 founder). Chave do elo com a reserva (inv-confirmation-requires-active-reservation)."
		}, {
			kind:        "domain-type"
			name:        "scope"
			type:        "CommitmentScope"
			description: "Escopo do compromisso (descrição, valor, prazo) que sustenta identificação determinística do Centro de Custo aplicável (per as-bdg-1)."
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
			description:    "Valor do compromisso a ser coberto."
		}]
	}]

	// =============================================
	// COMMANDS (intenções de mudança de estado)
	// =============================================

	commands: [{
		code:        "cmd-approve-budget"
		name:        "ApproveBudget"
		description: "Solicitar Aprovação Orçamentária para um CommitmentId. Aceito quando Gate de Cobertura aprova determinísticamente (Saldo Disponível suficiente + Alçada satisfeita) OU supervisor humano autoriza dentro do escopo de governance. Sync — downstream (DLV) precisa de decisão determinística antes de progredir."
		rationale:   "Command-handler sync declarado em canvas.communication.inbound[0]. Spine commitment-lifecycle. Resultado: registro de Comprometimento Orçamentário e publicação de BudgetApproved. Distinto do par cmd-reject-budget — separação explícita aceita/rejeita evita acoplamento implícito de result code."
		fields: [{
			kind:        "primitive"
			name:        "requisitionRef"
			type:        "string"
			description: "Requisição de compra em aprovação no portão (p2p vo-requisition-id) — a chave da fase 1 (D2: commitmentId removido; o commitment não existe pré-pedido)."
		}, {
			kind:           "value-object-ref"
			name:           "costCenterId"
			valueObjectRef: "vo-cost-center-id"
			description:    "Centro de Custo declarado na requisição desde a submissão (WI-151 costCenterRef) — não mais inferido do escopo do compromisso."
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
		}, {
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Identificador do ator que solicita a aprovação (agente operador por default; supervisor humano em caso de override)."
		}]
	}, {
		code:        "cmd-confirm-budget-reservation"
		name:        "ConfirmBudgetReservation"
		description: "Command INTERNO emitido por pol-commitment-accepted-triggers-approval quando CommitmentAccepted chega (fase 2 do two-phase adr-174): EFETIVA a reserva feita no portão — localiza o Comprometimento reserved pela requisitionRef (enriquecida pelo ACL), liga o CommitmentId à reserva e transiciona reserved → confirmed. Emite BudgetApproved (spine bdg-to-dlv, agora no momento certo). O valor não muda — reservou na fase 1."
		rationale:   "A segunda fase que o Reservation/Confirmation sempre implicou (ADR-C4-2.0 §2.0.8 via adr-174): a efetivação ancora o compromisso à reserva sem re-rodar o gate — inv-confirmation-requires-active-reservation garante reserva ativa; ausência escala para supervisão (nunca auto-aprovação, P10). Command interno de policy (carve-out tq-dm-12; não exposto no canvas — paralelo ao cmd-convert-requisition do p2p)."
		fields: [{
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Compromisso aceito que ancora à reserva — o elo CommitmentId ↔ BudgetCommitment nasce aqui."
		}, {
			kind:        "primitive"
			name:        "requisitionRef"
			type:        "string"
			description: "Chave de localização da reserva reserved (enriquecida pelo ACL adapter per D1)."
		}, {
			kind:        "primitive"
			name:        "confirmedBy"
			type:        "string"
			description: "Ator da efetivação (agente operador via policy; supervisor em escalada confirm-without-reservation)."
		}]
	}, {
		code:        "cmd-reject-budget"
		name:        "RejectBudget"
		description: "Solicitar registro de rejeição de cobertura quando Gate de Cobertura conclui ausência de cobertura. No caminho canônico pós-adr-174 a rejeição acontece na FASE 1 (portão), keyed por requisitionRef — Sync: o p2p recebe o resultado no ato da aprovação (a requisição permanece triaged; escalada supervisionada). Não cancela a requisição nem o compromisso — apenas sinaliza ausência de cobertura; a consequência é do portão."
		rationale:   "Command-handler sync declarado em canvas.communication.inbound[1]. Resultado: publicação de BudgetRejected com motivo estruturado. Termo canônico explícito (em vez de tratar rejeição como result negativo de ApproveBudget) preserva auditabilidade do motivo como fato de primeira classe."
		fields: [{
			kind:        "primitive"
			name:        "requisitionRef"
			type:        "string"
			description: "Requisição cuja cobertura foi rejeitada — a chave do caminho canônico (fase 1, portão)."
		}, {
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Presente apenas em rejeição residual pós-formalização; AUSENTE no caminho canônico (fase 1, pré-commitment)."
		}, {
			kind:           "value-object-ref"
			name:           "costCenterId"
			valueObjectRef: "vo-cost-center-id"
			description:    "Centro de Custo avaliado (pode ser ausente se motivo é invalid-cost-center)."
		}, {
			kind:           "value-object-ref"
			name:           "requestedAmount"
			valueObjectRef: "vo-money"
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-rejection-reason"
		}]
	}, {
		code:        "cmd-release-budget-commitment"
		name:        "ReleaseBudgetCommitment"
		description: "Reverter Comprometimento Orçamentário previamente registrado, devolvendo o valor reservado ao Saldo Disponível do Centro de Custo. Disparado por cancelamento de requisição aprovada no p2p (release de reserva reserved, pré-efetivação — per adr-174 o cancelamento LIBERA), cancelamento em CMT, ajuste supervisionado ou conclusão integral de execução em FCE. Resultado: publicação de BudgetCommitmentReleased."
		rationale:   "Não declarado em canvas inbound porque trigger é interno/cross-BC — em Phase 0 antes de oq-bdg-2 resolver, command serve anchor para futura ativação. Termo deriva do glossary term-liberacao-de-comprometimento. Distinto de cmd-reject-budget porque opera sobre Comprometimento já registrado, não sobre solicitação inicial."
		fields: [{
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Compromisso ancorado — presente quando a reserva foi efetivada (confirmed); AUSENTE no release de reserva pré-efetivação (reserved), cuja referência canônica é budgetCommitmentId."
		}, {
			kind:           "value-object-ref"
			name:           "budgetCommitmentId"
			valueObjectRef: "vo-budget-commitment-id"
			description:    "Referência canônica da reserva a liberar — é o coverageReservationRef que o p2p guarda na requisição aprovada."
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-commitment-release-reason"
		}]
	}]

	// =============================================
	// INVARIANTS (regras protegidas)
	// =============================================

	invariants: [{
		code:      "inv-coverage-gate-deterministic"
		name:      "Gate de Cobertura Determinístico"
		rule:      "Nenhuma reserva de cobertura (CoverageReserved) é registrada sem que o Gate de Cobertura tenha verificado em sequência: (1) Saldo Disponível em Centro de Custo identificado é suficiente para o valor solicitado; (2) valor está dentro da Alçada do ator que autoriza. Falha em qualquer verificação bloqueia a reserva. A efetivação (BudgetApproved) NÃO re-roda o gate — pressupõe reserva gated na fase 1 (inv-confirmation-requires-active-reservation)."
		rationale: "Invariante central de BDG per bd-coverage-as-invariant. Gate determinístico transforma cobertura de premissa implícita em fato auditável — sem ele, compromissos progridem para DLV/INV/FCE sem lastro orçamentário (inadimplência programática). Per adr-174 o gate roda no PORTÃO (fase 1, aprovação da requisição, pré-pedido) — mudou o momento, não o mecanismo. Materializa term-gate-de-cobertura do glossary."
	}, {
		code:      "inv-cost-center-required"
		name:      "Centro de Custo Obrigatório e Identificado"
		rule:      "Toda Aprovação Orçamentária registra Comprometimento contra exatamente um Centro de Custo identificado e válido. Compromissos cujo Centro de Custo aplicável não pode ser determinado deterministicamente são bloqueados na entrada — agente solicita esclarecimento ou escala."
		rationale: "Materializa bd-cost-center-as-sot. Sem unidade canônica de comprometimento, controle orçamentário se dilui em agregações ad-hoc. Centro de Custo é vocabulário estabelecido em controladoria (term-centro-de-custo do glossary). Identificação determinística é premissa as-bdg-1."
	}, {
		code:      "inv-alcada-respected"
		name:      "Alçada Respeitada"
		rule:      "Nenhuma Aprovação Orçamentária autorizada autonomamente por agente excede a Alçada do agente conforme tabela vigente. Aprovação fora de Alçada é supervisedDecision (approve-budget-out-of-alcada) que requer autorização de supervisor humano."
		rationale: "Materializa autonomousDecision evaluate-alcada-deterministic + supervisedDecision approve-budget-out-of-alcada do canvas. Aprovação fora de alçada por agente viola mech-agent-gate e P10. Alçada é segundo input do gate (junto com Saldo Disponível) — vide term-alcada do glossary. Nota: a tabela de Alçadas vive como configuração externa fora do BDG BC (mantida por governance financeira da organização operadora); este invariant captura a regra de respeito mas não modela o data — value object próprio para faixa de Alçada não é necessário porque limites são consultados em runtime via API/configuration externa, não persistidos como state interno do agg-cost-center."
	}, {
		code:      "inv-commitment-not-payment"
		name:      "Comprometimento Não é Pagamento"
		rule:      "Aprovação Orçamentária NUNCA consulta disponibilidade de caixa em TCM nem dispara execução de pagamento em FCE. Comprometimento é prospectivo (orçamento reservado); pagamento é efetivo (caixa executado) — operam em SoTs distintos com cadências distintas."
		rationale: "Materializa bd-commitment-not-payment. Fronteira inviolável: BDG controla orçamento, FCE executa pagamento, TCM gerencia caixa. Misturar acumularia em BDG responsabilidade de TCM e FCE — drift para 'BC Deus' financeiro. Termo canônico no glossary (term-comprometimento-orcamentario antiTerm 'Pagamento') sustenta a fronteira na UL."
	}, {
		code:      "inv-allocation-not-treasury"
		name:      "Alocação Não é Tesouraria"
		rule:      "BDG NUNCA realoca orçamento entre Centros de Custo autonomamente. Ajustes de Limite por Centro de Custo (aumento ou redução) são supervisedDecisions (adjust-cost-center-limit) com justificativa documentada — não há autonomia operacional para reallocate."
		rationale: "Materializa bd-allocation-not-treasury. Decisão estratégica de quanto cada Centro de Custo recebe pertence à diretoria financeira (planejamento anual, revisões trimestrais), não ao agente operador. Mistura de operação e calibragem geraria conflito de incentivos no agente."
	}, {
		code:      "inv-released-amount-matches-commitment"
		name:      "Valor Liberado Coincide com Comprometimento"
		rule:      "Liberação de Comprometimento devolve ao Saldo Disponível exatamente o valor previamente reservado pelo Comprometimento referenciado — nunca mais, nunca menos. Referência ao BudgetCommitmentId é obrigatória; liberações sem referência ou com valor divergente são bloqueadas."
		rationale: "Garante que reversões de reserva mantêm a invariante de que Saldo Disponível = Limite − Σ(comprometimentos ativos). Sem esta invariante, divergências numéricas acumulam e o cálculo de Saldo Disponível regride para snapshot inconsistente."
	}, {
		code:      "inv-commitment-id-global-uniqueness-active"
		name:      "Unicidade de Comprometimento por Compromisso"
		rule:      "Unicidade por fase (two-phase adr-174): (1) cada requisitionRef tem no máximo UMA reserva ativa (reserved ou confirmed) registrada em BDG — re-reserva da mesma requisição exige liberação prévia; (2) cada CommitmentId tem no máximo um Comprometimento confirmed ativo — dupla efetivação do mesmo commitment é bloqueada. Histórico liberado preserva BudgetCommitmentIds distintos."
		rationale: "Idempotência ao nível de requisição (fase 1) e de compromisso (fase 2): previne double-booking que inflaria comprometimento agregado contra o Centro de Custo. Sustenta cálculo correto de Saldo Disponível. Histórico de Comprometimentos liberados por CommitmentId é preservado (BudgetCommitmentIds distintos) — regra restringe apenas ATIVOS simultâneos, não impede re-aprovação após liberação prévia."
	}, {
		code:      "inv-confirmation-requires-active-reservation"
		name:      "Efetivação Exige Reserva Ativa (Elo Reserva↔Commitment)"
		rule:      "Toda efetivação (reserved → confirmed) EXIGE Comprometimento em status=reserved cuja requisitionRef corresponda à do CommitmentAccepted recebido (enriquecida pelo ACL). CommitmentAccepted SEM reserva correspondente NUNCA efetiva, NUNCA re-roda o Gate de Cobertura silenciosamente e NUNCA auto-aprova — escalada supervisionada (confirm-without-reservation) com justificativa documentada. Dinheiro não se efetiva sem o elo reserva↔commitment fechado."
		rationale: "A lei da fase 2 per adr-174: sob o portão, TODO commitment legítimo nasce de PO emitido sob requisição aprovada com reserva (inv-emission-requires-approved-requisition no p2p) — commitment sem reserva é anomalia de fluxo, não caso normal, e anomalia com dinheiro escala para humano (P10: o gate determinístico decide o caminho normal; a exceção é supervisedDecision, nunca silêncio). Vigiada pela falsificação (b) do adr-174 — reservas órfãs envelhecendo são o outro lado da mesma moeda."
	}]

	// =============================================
	// VALUE OBJECTS (catalog top-level)
	// =============================================

	valueObjects: [{
		code:        "vo-cost-center-id"
		name:        "CostCenterId"
		description: "Identificador canônico de Centro de Custo configurado externamente. Referência usada em todo Comprometimento Orçamentário e em queries de disponibilidade. Formato definido por configuração externa (e.g., CC-2026-OBRA-XYZ-CONCRETO)."
		fields: [{
			kind:        "primitive"
			name:        "value"
			type:        "string"
			description: "Valor do identificador do Centro de Custo conforme plano externo."
		}]
		rationale: "Identidade do aggregate root agg-cost-center. Value object porque é imutável após criação e identidade vem do valor. Termo canônico no glossary (term-centro-de-custo)."
	}, {
		code:        "vo-money"
		name:        "Money"
		description: "Valor monetário tipado com moeda explícita. Usado em Limite, Saldo Disponível, valor de Comprometimento, valor solicitado e valor liberado. Imutável após criação."
		fields: [{
			kind:        "primitive"
			name:        "amount"
			type:        "decimal"
			description: "Valor numérico em unidade da moeda."
		}, {
			kind:        "primitive"
			name:        "currency"
			type:        "string"
			description: "Código ISO 4217 da moeda (e.g., BRL)."
		}]
		constraints: [
			"amount não-negativo para valores de saldo, limite e reserva; sinal só admitido em ajustes contábeis fora do escopo deste BC",
			"currency uniforme entre Limite e Comprometimentos do mesmo Centro de Custo",
		]
		rationale: "Tipo fundamental para todo valor numérico monetário no BDG. Centralizá-lo evita drift de representação entre eventos, comandos e fields do aggregate. Currency explícita (ISO 4217) preserva vertical-agnostic mode do canvas BDG; uso prático no bootstrap pré-revenue será predominantemente BRL, mas multi-moeda é mantido para evolução futura sem refactor de tipo."

		// adr-151 Forma B (Peça 3b): elo ao primitivo compartilhado canônico.
		// Money puro (amount+currency) — aponta #Money + term-money como lar
		// canônico (P0: ponteiro, não cópia; os fields locais permanecem).
		shared:             true
		canonicalSchemaRef: "#Money"
		canonicalTermRef:   "term-money"
	}, {
		code:        "vo-budget-commitment-id"
		name:        "BudgetCommitmentId"
		description: "Identificador único de um Comprometimento Orçamentário registrado em BDG. Distinto do CommitmentId (CMT) — referencia a reserva orçamentária específica, não o compromisso bilateral. Permite referência inequívoca em liberações e queries."
		fields: [{
			kind:        "primitive"
			name:        "value"
			type:        "string"
			description: "Identificador único da reserva orçamentária."
		}]
		rationale: "Identidade da entity ent-budget-commitment nested em agg-cost-center. Distinção de CommitmentId é deliberada: um CommitmentId tem (no máximo) um BudgetCommitmentId ATIVO, mas reservas históricas (liberadas) preservam BudgetCommitmentIds distintos para auditabilidade. Sustenta inv-released-amount-matches-commitment e inv-commitment-id-global-uniqueness-active."
	}, {
		code:        "vo-rejection-reason"
		name:        "RejectionReason"
		description: "Motivo estruturado de rejeição de Aprovação Orçamentária. Permite consumers (CMT, DRC) reagirem programaticamente sem parsing de string."
		fields: [{
			kind:        "primitive"
			name:        "code"
			type:        "string"
			description: "Código do motivo: insufficient-balance, invalid-cost-center, alcada-exceeded."
		}, {
			kind:        "primitive"
			name:        "description"
			type:        "string"
			description: "Descrição legível para auditoria."
		}, {
			kind:           "value-object-ref"
			name:           "availableBalance"
			valueObjectRef: "vo-money"
			description:    "Saldo Disponível no momento da rejeição (relevante quando code=insufficient-balance)."
		}]
		constraints: [
			"code deve ser um dos: insufficient-balance, invalid-cost-center, alcada-exceeded",
		]
		rationale: "Estruturação do motivo é deliberada per canvas: permite revisão de centro de custo, escalação ou renegociação como reação programática. Distinto de string opaca que forçaria parsing por consumers."
	}, {
		code:        "vo-commitment-release-reason"
		name:        "CommitmentReleaseReason"
		description: "Causa estruturada de Liberação de Comprometimento. Distingue cancelamento de requisição no p2p (release de reserva pré-efetivação, per adr-174), cancelamento upstream (CMT), conclusão integral (FCE) e ajuste supervisionado interno."
		fields: [{
			kind:        "primitive"
			name:        "causeType"
			type:        "string"
			description: "Tipo da causa: cancellation, full-execution, supervised-adjustment."
		}, {
			kind:        "primitive"
			name:        "originContext"
			type:        "string"
			description: "Contexto de origem: cmt, fce, p2p (cancelamento de requisição pré-efetivação), internal."
		}, {
			kind:        "primitive"
			name:        "description"
			type:        "string"
			description: "Descrição legível para auditoria."
		}]
		constraints: [
			"causeType deve ser um dos: cancellation, full-execution, supervised-adjustment",
			"originContext deve ser um dos: cmt, fce, p2p, internal",
		]
		rationale: "Sustenta auditabilidade da Liberação como fato auditável distinto da reserva original. Consumers downstream (CMT) podem filtrar por causeType sem inspecionar payload opaco."
	}, {
		code:        "vo-budget-approval-status"
		name:        "BudgetApprovalStatus"
		description: "Estado canônico de cobertura orçamentária — keyed por requisitionRef (fase 1, o lookup do portão p2p) OU CommitmentId (pós-efetivação, CMT/DRC). Exposto por QueryBudgetApprovalStatus do canvas. Enum tipado two-phase (adr-174/WI-153; BREAKING declarado D3: o valor approved foi REMOVIDO, split em reserved|confirmed): pending, reserved, confirmed, rejected, released."
		fields: [{
			kind:        "primitive"
			name:        "value"
			type:        "string"
			description: "Estado atual: pending, reserved, confirmed, rejected, released."
		}]
		constraints: [
			"value deve ser um dos: pending, reserved, confirmed, rejected, released",
		]
		rationale: "Tipo de retorno canônico de QueryBudgetApprovalStatus. Status derivado do lifecycle two-phase do Comprometimento (per glossary rationale: estados não viram terms separados — são derivados). Consumidores pós-D3: p2p lê reserved no portão (inv-approval-requires-coverage-reservation); CMT/DRC leem confirmed pós-efetivação; DLV consome o EVENTO BudgetApproved, não este enum — o contrato do spine fica intocado. Value object imutável que representa snapshot do estado."
	}, {
		code:        "vo-cost-center-availability"
		name:        "CostCenterAvailability"
		description: "Visão composta de capacidade orçamentária de um Centro de Custo: identidade, Limite vigente, Saldo Disponível corrente, total comprometido. Exposto por QueryCostCenterAvailability do canvas."
		fields: [{
			kind:           "value-object-ref"
			name:           "costCenterId"
			valueObjectRef: "vo-cost-center-id"
		}, {
			kind:           "value-object-ref"
			name:           "limit"
			valueObjectRef: "vo-money"
			description:    "Limite configurado externamente."
		}, {
			kind:           "value-object-ref"
			name:           "availableBalance"
			valueObjectRef: "vo-money"
			description:    "Saldo Disponível corrente = Limite − Σ(comprometimentos ativos)."
		}, {
			kind:           "value-object-ref"
			name:           "activeCommitmentsTotal"
			valueObjectRef: "vo-money"
			description:    "Soma dos valores de comprometimentos ativos (não liberados)."
		}]
		rationale: "Tipo de retorno canônico de QueryCostCenterAvailability. Consumed por controllers, supervisores e (em cenário evolutivo per oq-bdg-3) por CMT para previsão de cobertura pré-formalização. Encapsula derivação numérica para evitar drift de cálculo entre consumers."
	}]

	// =============================================
	// AGGREGATES (consistency boundaries)
	// =============================================

	aggregates: [{
		code:        "agg-cost-center"
		name:        "CostCenter"
		description: "Aggregate root de Centro de Custo. Único consistency boundary de BDG. Encapsula Limite vigente, Comprometimentos Orçamentários ativos (entities owned, vivendo o two-phase adr-174: reserved → confirmed → released) e cálculo determinístico de Saldo Disponível. Mutações de Comprometimento (registro, liberação) e ajustes supervisionados de Limite são atômicos no escopo deste aggregate. Lifecycle do Centro de Custo (criação, descontinuação) é governance externa per bd-allocation-not-treasury — não modelado como state machine."
		rootIdentity: {
			field: "costCenterId"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-cost-center-id"
			}
		}
		fields: [{
			kind:           "value-object-ref"
			name:           "limit"
			valueObjectRef: "vo-money"
			description:    "Limite configurado externamente; ajustes são supervisedDecisions (adjust-cost-center-limit)."
		}, {
			kind:        "primitive"
			name:        "limitConfiguredAt"
			type:        "datetime"
			description: "Timestamp da última configuração/ajuste de Limite — auditável por inv-allocation-not-treasury."
		}, {
			kind:        "primitive"
			name:        "active"
			type:        "boolean"
			description: "Indica se o Centro de Custo está ativo para novos Comprometimentos. Descontinuação é governance externa."
		}]

		entities: [{
			code:        "ent-budget-commitment"
			name:        "BudgetCommitment"
			description: "Comprometimento Orçamentário individual registrado contra o Centro de Custo. Owned exclusivamente pelo aggregate — não existe fora dele. Vive o two-phase adr-174: nasce reserved (portão, keyed por requisitionRef), é efetivado para confirmed (CommitmentAccepted ancora o CommitmentId) e liberado para released. reserved e confirmed AMBOS reduzem Saldo Disponível — a efetivação muda fase/ancoragem, não o valor."
			identity: {
				field: "budgetCommitmentId"
				type: {
					kind:           "value-object-ref"
					valueObjectRef: "vo-budget-commitment-id"
				}
			}
			fields: [{
				kind:        "primitive"
				name:        "requisitionRef"
				type:        "string"
				description: "Requisição de compra que originou a reserva no portão (p2p vo-requisition-id) — a chave da fase 1; base do elo verificado por inv-confirmation-requires-active-reservation."
			}, {
				kind:        "domain-type"
				name:        "commitmentId"
				type:        "CommitmentId"
				description: "Compromisso CMT ancorado à reserva — populado na EFETIVAÇÃO (fase 2); ausente enquanto status=reserved (a reserva nasce pré-commitment, no portão)."
			}, {
				kind:           "value-object-ref"
				name:           "amount"
				valueObjectRef: "vo-money"
				description:    "Valor reservado contra o Centro de Custo."
			}, {
				kind:        "primitive"
				name:        "status"
				type:        "string"
				description: "reserved | confirmed | released — two-phase per adr-174. reserved e confirmed contam como ATIVOS no cálculo de Saldo Disponível (Saldo = Limite − Σ ativos); released devolve. Sustenta inv-commitment-id-global-uniqueness-active (unicidade por fase)."
			}, {
				kind:        "primitive"
				name:        "approvedAt"
				type:        "datetime"
				description: "Timestamp da aprovação que criou esta reserva (fase 1, portão)."
			}, {
				kind:        "primitive"
				name:        "confirmedAt"
				type:        "datetime"
				description: "Timestamp da efetivação (presente quando status alcançou confirmed; ausente enquanto reserved)."
			}, {
				kind:        "primitive"
				name:        "approvedBy"
				type:        "string"
				description: "Identificador do ator que autorizou a aprovação (agente operador ou supervisor humano)."
			}, {
				kind:        "primitive"
				name:        "releasedAt"
				type:        "datetime"
				description: "Timestamp da liberação (presente quando status=released; ausente quando status=active)."
			}, {
				kind:           "value-object-ref"
				name:           "releaseReason"
				valueObjectRef: "vo-commitment-release-reason"
				description:    "Causa da liberação (presente quando status=released)."
			}]
			rationale: "Entity (não value object) porque tem identidade própria persistente (BudgetCommitmentId) que sobrevive à mudança de atributos (fases reserved → confirmed → released) e é referenciada em events (CoverageReserved.budgetCommitmentId, BudgetApproved.budgetCommitmentId, BudgetCommitmentReleased.budgetCommitmentId). Não é aggregate root separado porque sua existência é derivada do Centro de Custo — sem o agregado pai, Comprometimento isolado não tem semântica de capacidade orçamentária."
		}]

		handlesCommands: [
			"cmd-approve-budget",
			"cmd-confirm-budget-reservation",
			"cmd-reject-budget",
			"cmd-release-budget-commitment",
		]

		emitsEvents: [
			"evt-coverage-reserved",
			"evt-budget-approved",
			"evt-budget-rejected",
			"evt-budget-commitment-released",
			"evt-commitment-accepted-received",
		]

		protectsInvariants: [
			"inv-coverage-gate-deterministic",
			"inv-cost-center-required",
			"inv-alcada-respected",
			"inv-commitment-not-payment",
			"inv-allocation-not-treasury",
			"inv-released-amount-matches-commitment",
			"inv-commitment-id-global-uniqueness-active",
			"inv-confirmation-requires-active-reservation",
		]

		usesValueObjects: [
			"vo-cost-center-id",
			"vo-money",
			"vo-budget-commitment-id",
			"vo-rejection-reason",
			"vo-commitment-release-reason",
		]

		rationale: "Single aggregate porque Centro de Custo é a única consistency boundary de BDG: cálculo de Saldo Disponível, registro de Comprometimento e Liberação são mutações que devem ser atômicas para preservar a invariante Saldo = Limite − Σ(comprometimentos ativos). Aggregate sem lifecycle (per tq-dmg-07): justificativa estrutural — persiste registry de Comprometimentos ativos (entities owned) que sustenta inv-released-amount-matches-commitment e inv-commitment-id-global-uniqueness-active; serve como uniqueness registry e ledger de reservas orçamentárias. Sem essa estrutura persistente, o Gate de Cobertura regride a snapshot stateless e a idempotência por compromisso fica sem enforcement. Lifecycle do próprio Centro de Custo (criação, ajuste de Limite, descontinuação) é governance externa per bd-allocation-not-treasury — não modelado como state machine porque transições não são triggered por commands de domínio do BDG; modelar especulativo violaria heuristic do PG. Eventos publicados (CoverageReserved/BudgetApproved/Rejected/Released) e ACL (CommitmentAcceptedReceived) listados em emitsEvents conforme padrão CMT/NPM (tq-dm-02): aggregate registra os fatos no seu event stream — ACL adapter produz semanticamente o evento traduzido. Note: vo-budget-approval-status e vo-cost-center-availability NÃO listados em usesValueObjects porque são tipos de retorno de queries (projeções), não fields stored no aggregate — tq-dm-04 warn aceito para esses dois VOs."
	}]

	// =============================================
	// POLICIES (event → command)
	// =============================================

	policies: [{
		code:             "pol-commitment-accepted-triggers-approval"
		name:             "Compromisso Aceito Efetiva a Reserva"
		description:      "Quando CMT publica CommitmentAccepted (traduzido como evt-commitment-accepted-received via ACL, ENRIQUECIDO com requisitionRef), emite cmd-confirm-budget-reservation para EFETIVAR a reserva feita no portão (reserved → confirmed) — fase 2 do two-phase adr-174. O Gate de Cobertura NÃO roda aqui: rodou na fase 1 (aprovação da requisição no p2p)."
		triggeredByEvent: "evt-commitment-accepted-received"
		issuesCommand:    "cmd-confirm-budget-reservation"
		rationale:        "RE-PAPEL per adr-174/WI-153: de gate-tardio ('inicia Gate de Cobertura pós-commitment' — o papel velho, que sob o portão seria aprovação dupla) para EFETIVAÇÃO da reserva. O code é mantido (histórico de refs: adr-174, WI-153, canvas); o papel novo vive em name/description/issuesCommand. O ACL adapter enriquece requisitionRef (commitment → purchaseOrderRef → requisitionRef — mesmo papel de enriquecimento que as-bdg-1 estabelece para Centro de Custo; D1 founder: a necessidade do bdg resolve na borda do bdg, cmt intocado). Reserva ausente → inv-confirmation-requires-active-reservation escala para supervisão (nunca auto-aprova, nunca re-roda o gate em silêncio)."
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-budget-approval-status"
		name:        "BudgetApprovalStatusProjection"
		description: "Read model que materializa estado vigente de cobertura por requisitionRef (fase 1 — o lookup do portão p2p, per inv-approval-requires-coverage-reservation) OU CommitmentId (pós-efetivação). Consumido pelo p2p no portão, por CMT (visibilidade pós-formalização) e por DRC quando disputa referencia compromisso, via QueryBudgetApprovalStatus."
		consumesEvents: [
			"evt-coverage-reserved",
			"evt-budget-approved",
			"evt-budget-rejected",
			"evt-budget-commitment-released",
		]
		queryCapabilities: [{
			code:        "qry-budget-approval-status"
			description: "Retorna BudgetApprovalStatus por requisitionRef OU CommitmentId (pending, reserved, confirmed, rejected, released) com motivo estruturado, Centro de Custo e budgetCommitmentId associados. O p2p lê status=reserved no portão; CMT/DRC leem confirmed pós-efetivação."
			rationale:   "Canvas query-surface QueryBudgetApprovalStatus retorna BudgetApprovalStatus. A chave por requisição (WI-153) fecha a janela declarada no adr-174: o portão consulta a reserva pela chave certa. Interface de leitura para p2p (portão), CMT (visibilidade pós-formalização) e DRC (contexto de disputa)."
		}]
		rationale: "Per canvas query-surface QueryBudgetApprovalStatus consumida por CMT/DRC. Projeção mantém estado vigente sintético derivado de events; otimizada para lookup por CommitmentId. Latência de projeção alvo per eda-projections: <5s para consumers síncronos."
	}, {
		code:        "prj-cost-center-availability"
		name:        "CostCenterAvailabilityProjection"
		description: "Read model que materializa capacidade orçamentária por Centro de Custo: Limite, Saldo Disponível, total de comprometimentos ativos. Consumido por controllers, supervisores e (cenário evolutivo per oq-bdg-3) por CMT para previsão de cobertura pré-formalização."
		consumesEvents: [
			"evt-coverage-reserved",
			"evt-budget-commitment-released",
		]
		queryCapabilities: [{
			code:        "qry-cost-center-availability"
			description: "Retorna CostCenterAvailability para um CostCenterId (Limite, Saldo Disponível, comprometimentos ativos)."
			rationale:   "Canvas query-surface QueryCostCenterAvailability retorna CostCenterAvailability. Consumed por controllers, supervisores e (cenário evolutivo per oq-bdg-3) por CMT para previsão de cobertura pré-formalização."
		}]
		rationale: "Per canvas query-surface QueryCostCenterAvailability. Projeção agrega comprometimentos ativos para derivar Saldo Disponível em runtime sem reconstruir do event log. O Saldo reduz na RESERVA (fase 1, evt-coverage-reserved) — por isso NÃO consome evt-budget-approved: a efetivação muda fase/ancoragem, não valor (two-phase adr-174). Não consome evt-budget-rejected porque rejeições não criam reserva."
	}]

	rationale: """
		Domain model do BC Budget & Approval modela 1 aggregate central
		(agg-cost-center) com 1 entity nested (ent-budget-commitment)
		cobrindo todo o escopo declarado em canvas: Gate de Cobertura,
		registro de Comprometimento Orçamentário, Liberação. Aggregate
		sem lifecycle por design (per tq-dmg-07): justificativa
		estrutural é persistir registry de Comprometimentos ativos
		(entities owned) que sustenta cálculo de Saldo Disponível e
		idempotência por compromisso — sem essa persistência, Gate de
		Cobertura regrediria a snapshot stateless. Lifecycle do
		próprio Centro de Custo é governance externa per
		bd-allocation-not-treasury — não modelado para evitar
		especulação.

		TWO-PHASE RESERVATION/CONFIRMATION (adr-174 / WI-153): o Gate de
		Cobertura é invocado no PORTÃO — a aprovação da requisição de
		compra (p2p cmd-approve-purchase), PRÉ-pedido — e RESERVA
		cobertura keyed por requisitionRef (fase 1: cmd-approve-budget →
		status reserved + CoverageReserved; o CommitmentId não existe
		ainda). O CommitmentAccepted EFETIVA a reserva (fase 2:
		pol-commitment-accepted-triggers-approval re-papelizada →
		cmd-confirm-budget-reservation → reserved → confirmed +
		BudgetApproved — spine bdg-to-dlv intocado em contrato). O
		release LIBERA em qualquer fase (inclui cancelamento de
		requisição no p2p — originContext p2p). reserved e confirmed
		AMBOS reduzem Saldo Disponível; a efetivação muda fase e
		ancoragem, não valor. Efetivação sem reserva NUNCA auto-aprova —
		escalada supervisionada (inv-confirmation-requires-active-
		reservation). BREAKING declarado (D3 founder): o estado
		'approved' do vo-budget-approval-status morreu — split em
		reserved|confirmed (p2p lê reserved no portão; CMT/DRC leem
		confirmed; DLV consome o EVENTO BudgetApproved — intocado).

		Behavior-first ordering aplicado: events emergiram do canvas
		na derivação original (1 published spine BudgetApproved + 2
		published pendentes de formalização cross-BC per oq-bdg-2
		BudgetRejected/BudgetCommitmentReleased modelados como UL terms
		no glossary para preservar paralelismo + 1 internal ACL
		CommitmentAcceptedReceived); o WI-153 somou CoverageReserved
		(fase 1 do two-phase, published — 5 events no catálogo).
		Commands derivam de canvas inbound (ApproveBudget re-keyed por
		requisitionRef, RejectBudget) + intenção interna anchor
		(ReleaseBudgetCommitment) + command interno de policy
		(ConfirmBudgetReservation, efetivação — carve-out tq-dm-12); invariants protegidos derivados de
		businessDecisions (bd-coverage-as-invariant,
		bd-commitment-not-payment, bd-cost-center-as-sot,
		bd-allocation-not-treasury) + autonomousDecisions
		(evaluate-alcada-deterministic) + necessidade estrutural
		(unicidade, valor liberado coincide); value-objects emergentes
		dos payloads e do glossary (CostCenterId, Money,
		BudgetCommitmentId, RejectionReason, CommitmentReleaseReason,
		BudgetApprovalStatus, CostCenterAvailability).

		Lenses aplicadas:
		- lens-organizational-resource-allocation (primária): Centro
		  de Custo como unidade canônica de allocation; Saldo
		  Disponível como capacidade prospectiva (Limite − Σ
		  comprometimentos ativos); Comprometimento como reserva
		  que reduz capacidade; Liberação como reversão. Alçada
		  modela delegation-fitness (ora-delegation-fitness).
		  Strategic neglect (ora-strategic-neglect): BDG NÃO realoca
		  entre centros — bd-allocation-not-treasury codificado como
		  invariant (inv-allocation-not-treasury).
		- lens-event-driven-architecture-patterns (secundária):
		  3 published events com semântica inequívoca per
		  eda-domain-vs-integration-events; outcome split em
		  approve/reject (eda-event-catalog) cobre tq-dmg-06;
		  projeções materializam read models per eda-cqrs com SLO
		  de latência (eda-projections); policy choreographs trigger
		  initial CMT→BDG, orchestration interna do gate (eda-
		  choreography-vs-orchestration). Event sourcing implícito
		  do agregado sustenta auditabilidade contínua (cap-04 do
		  canvas, per eda-event-sourcing).

		Phase 0 caveats:
		- evt-budget-rejected e evt-budget-commitment-released
		  modelados como published mas propagação direta cross-BC
		  (bdg→cmt, bdg→drc) pendente de formalização no context-map
		  (oq-bdg-2). Em Phase 0 publicação serve audit trail interno
		  e anchor para futura ativação; consumers descobrem via
		  query polling (QueryBudgetApprovalStatus) enquanto não
		  declarada relação direta.
		- cmd-release-budget-commitment serve anchor; trigger concreto
		  (cancelamento em CMT, conclusão em FCE, ajuste supervisionado)
		  depende de protocolo cross-BC formalizado em commits futuros.
		- Detecção de Fracionamento (term-fracionamento do glossary)
		  é responsabilidade compartilhada com REW (oq-bdg-1) — não
		  modelada como invariant local porque agregação cross-
		  compromisso por par de partes/janela temporal exige state
		  fora do agg-cost-center; aguarda decisão estrutural.
		- as-bdg-1 (identificação determinística de Centro de Custo
		  a partir do escopo CMT) é premissa do command
		  cmd-approve-budget; se invalidada (taxa de escalação por
		  ambiguidade alta), Gate de Cobertura regride para semi-
		  manual e cc-03 fica comprometida.

		Glossary alignment: nomes de events/commands/aggregates/
		value-objects reconciliados com 16 terms do glossary BDG
		(term-cobertura-orcamentaria, term-centro-de-custo,
		term-saldo-disponivel, term-limite-de-centro-de-custo,
		term-comprometimento-orcamentario, term-alcada,
		term-aprovacao-orcamentaria, term-gate-de-cobertura,
		term-approve-budget, term-reject-budget, term-budget-approved,
		term-budget-rejected, term-budget-commitment-released,
		term-liberacao-de-comprometimento, term-efetivacao-de-reserva
		per WI-153, term-fracionamento). 15
		dos 16 terms têm mapping explícito; term-fracionamento NÃO
		modelado como invariant local (deferred to oq-bdg-1). Sem
		divergências terminológicas identificadas. Loanword 'Alcada'
		não aparece como code (codes em ASCII per schema regex) mas
		é referenciada em rationale e modelada via inv-alcada-respected
		(decorre da tabela de Alçadas configurada externamente).
		"""
}
