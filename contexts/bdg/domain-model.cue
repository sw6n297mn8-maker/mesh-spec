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
// reconciliados com terms canônicos do glossary BDG (15 terms).
// 14/15 mapeados explicitamente; term-fracionamento NÃO modelado
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
//   evt-commitment-accepted-received → cmd-approve-budget
//   (eda-choreography-vs-orchestration: choreography para
//   trigger initial; orchestration interna do gate).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code:              "bdg"
	name:              "Budget & Approval Domain Model"
	boundedContextRef: "bdg"

	// =============================================
	// EVENTS (catalog top-level)
	// =============================================

	events: [{
		code:        "evt-budget-approved"
		name:        "BudgetApproved"
		visibility:  "published"
		description: "Gate de Cobertura aprovou compromisso — Saldo Disponível verificado e Alçada satisfeita; Comprometimento Orçamentário registrado contra Centro de Custo. Sinal canônico de progressão no commitment lifecycle. Spine commitment-lifecycle no context-map (bdg-to-dlv, async)."
		rationale:   "Event publisher declarado em canvas.communication.outbound[]. DLV consome para habilitar verificação de execução. Split de outcome de cmd-approve-budget em sucesso (este event) vs rejeição (evt-budget-rejected) — cobre tq-dmg-06: published events com semântica inequívoca para consumers externos sem inspeção polimórfica de payload."
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
		description: "Gate de Cobertura concluiu ausência de cobertura para um compromisso, com motivo estruturado (insufficient-balance, invalid-cost-center, alcada-exceeded). CMT consome para atualizar estado do compromisso; DRC pode consumir para contexto de disputa. Publicação direta para CMT/DRC pendente de formalização no context-map (oq-bdg-2)."
		rationale:   "Counterpart de evt-budget-approved. Published para preservar rejeição como fato auditável de primeira classe (não como result code negativo de aprovação). Estruturação do motivo permite consumers reagirem programaticamente. Em Phase 0 antes de oq-bdg-2 resolver, evento permanece em audit trail; ativação de propagação direta cross-BC depende de formalização no context-map."
		fields: [{
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Identificador do compromisso CMT que teve cobertura rejeitada."
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
		rationale:   "Completa o trio canônico de eventos de BDG (BudgetApproved, BudgetRejected, BudgetCommitmentReleased). Cada evento é fato auditável de primeira classe. Triggered por cancelamento em CMT, ajuste supervisionado ou conclusão integral em FCE. Publicação cross-BC pendente de oq-bdg-2; em Phase 0 evento serve audit trail interno e anchor para futura ativação."
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
		description:   "Tradução ACL de CommitmentAccepted (CMT). Sinal canônico de entrada do commitment lifecycle no escopo de BDG; trigger para identificação de Centro de Custo aplicável e execução do Gate de Cobertura."
		rationale:     "Evento interno traduzido de sinal externo de CMT (cmt-to-bdg, async). Domain model permanece puro — linguagem local. Trigger para pol-commitment-accepted-triggers-approval. Sufixo -received segue convenção ACL estabelecida em CMT/NPM."
		fields: [{
			kind:        "domain-type"
			name:        "commitmentId"
			type:        "CommitmentId"
			description: "Identificador do compromisso aceito em CMT."
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
			kind: "domain-type"
			name: "commitmentId"
			type: "CommitmentId"
		}, {
			kind:           "value-object-ref"
			name:           "costCenterId"
			valueObjectRef: "vo-cost-center-id"
			description:    "Centro de Custo identificado a partir do escopo do compromisso (per as-bdg-1)."
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
		code:        "cmd-reject-budget"
		name:        "RejectBudget"
		description: "Solicitar registro de rejeição de Aprovação Orçamentária para um CommitmentId quando Gate de Cobertura conclui ausência de cobertura. Sync — CMT precisa do resultado para atualizar estado do compromisso. Não cancela o compromisso em CMT — apenas sinaliza ausência de cobertura."
		rationale:   "Command-handler sync declarado em canvas.communication.inbound[1]. Resultado: publicação de BudgetRejected com motivo estruturado. Termo canônico explícito (em vez de tratar rejeição como result negativo de ApproveBudget) preserva auditabilidade do motivo como fato de primeira classe."
		fields: [{
			kind: "domain-type"
			name: "commitmentId"
			type: "CommitmentId"
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
		description: "Reverter Comprometimento Orçamentário previamente registrado, devolvendo o valor reservado ao Saldo Disponível do Centro de Custo. Disparado por cancelamento em CMT, ajuste supervisionado ou conclusão integral de execução em FCE. Resultado: publicação de BudgetCommitmentReleased."
		rationale:   "Não declarado em canvas inbound porque trigger é interno/cross-BC — em Phase 0 antes de oq-bdg-2 resolver, command serve anchor para futura ativação. Termo deriva do glossary term-liberacao-de-comprometimento. Distinto de cmd-reject-budget porque opera sobre Comprometimento já registrado, não sobre solicitação inicial."
		fields: [{
			kind: "domain-type"
			name: "commitmentId"
			type: "CommitmentId"
		}, {
			kind:           "value-object-ref"
			name:           "budgetCommitmentId"
			valueObjectRef: "vo-budget-commitment-id"
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
		rule:      "Nenhum compromisso recebe BudgetApproved sem que Gate de Cobertura tenha verificado em sequência: (1) Saldo Disponível em Centro de Custo identificado é suficiente para o valor solicitado; (2) valor está dentro da Alçada do ator que autoriza. Falha em qualquer invariante bloqueia aprovação."
		rationale: "Invariante central de BDG per bd-coverage-as-invariant. Gate determinístico transforma cobertura de premissa implícita em fato auditável — sem ele, compromissos progridem para DLV/INV/FCE sem lastro orçamentário (inadimplência programática). Materializa term-gate-de-cobertura do glossary."
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
		rule:      "Cada CommitmentId tem no máximo um Comprometimento Orçamentário ativo (não liberado) registrado em BDG. Re-aprovação de um mesmo CommitmentId já com Comprometimento ativo é bloqueada — exigiria liberação prévia."
		rationale: "Idempotência de aprovação ao nível de compromisso: previne double-booking que inflaria comprometimento agregado contra o Centro de Custo. Sustenta cálculo correto de Saldo Disponível. Histórico de Comprometimentos liberados por CommitmentId é preservado (BudgetCommitmentIds distintos) — regra restringe apenas ATIVOS simultâneos, não impede re-aprovação após liberação prévia."
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
		description: "Causa estruturada de Liberação de Comprometimento. Distingue cancelamento upstream (CMT), conclusão integral (FCE) e ajuste supervisionado interno."
		fields: [{
			kind:        "primitive"
			name:        "causeType"
			type:        "string"
			description: "Tipo da causa: cancellation, full-execution, supervised-adjustment."
		}, {
			kind:        "primitive"
			name:        "originContext"
			type:        "string"
			description: "Contexto de origem: cmt, fce, internal."
		}, {
			kind:        "primitive"
			name:        "description"
			type:        "string"
			description: "Descrição legível para auditoria."
		}]
		constraints: [
			"causeType deve ser um dos: cancellation, full-execution, supervised-adjustment",
			"originContext deve ser um dos: cmt, fce, internal",
		]
		rationale: "Sustenta auditabilidade da Liberação como fato auditável distinto da reserva original. Consumers downstream (CMT) podem filtrar por causeType sem inspecionar payload opaco."
	}, {
		code:        "vo-budget-approval-status"
		name:        "BudgetApprovalStatus"
		description: "Estado canônico de Aprovação Orçamentária para um CommitmentId. Exposto por QueryBudgetApprovalStatus do canvas. Enum tipado: pending, approved, rejected, released."
		fields: [{
			kind:        "primitive"
			name:        "value"
			type:        "string"
			description: "Estado atual: pending, approved, rejected, released."
		}]
		constraints: [
			"value deve ser um dos: pending, approved, rejected, released",
		]
		rationale: "Tipo de retorno canônico de QueryBudgetApprovalStatus. Status derivado do lifecycle de Comprometimento Orçamentário (per glossary rationale: estados não viram terms separados — são derivados). Value object imutável que representa snapshot do estado."
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
		description: "Aggregate root de Centro de Custo. Único consistency boundary de BDG. Encapsula Limite vigente, Comprometimentos Orçamentários ativos (entities owned) e cálculo determinístico de Saldo Disponível. Mutações de Comprometimento (registro, liberação) e ajustes supervisionados de Limite são atômicos no escopo deste aggregate. Lifecycle do Centro de Custo (criação, descontinuação) é governance externa per bd-allocation-not-treasury — não modelado como state machine."
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
			description: "Comprometimento Orçamentário individual registrado contra o Centro de Custo. Owned exclusivamente pelo aggregate — não existe fora dele. Cada Comprometimento referencia um CommitmentId (CMT) e um valor reservado; pode estar ativo ou liberado."
			identity: {
				field: "budgetCommitmentId"
				type: {
					kind:           "value-object-ref"
					valueObjectRef: "vo-budget-commitment-id"
				}
			}
			fields: [{
				kind:        "domain-type"
				name:        "commitmentId"
				type:        "CommitmentId"
				description: "Referência ao compromisso CMT que originou a reserva."
			}, {
				kind:           "value-object-ref"
				name:           "amount"
				valueObjectRef: "vo-money"
				description:    "Valor reservado contra o Centro de Custo."
			}, {
				kind:        "primitive"
				name:        "status"
				type:        "string"
				description: "active | released — sustenta cálculo de Saldo Disponível e inv-commitment-id-global-uniqueness-active."
			}, {
				kind:        "primitive"
				name:        "approvedAt"
				type:        "datetime"
				description: "Timestamp da aprovação que criou esta reserva."
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
			rationale: "Entity (não value object) porque tem identidade própria persistente (BudgetCommitmentId) que sobrevive à mudança de atributos (status active → released) e é referenciada em events (BudgetApproved.budgetCommitmentId, BudgetCommitmentReleased.budgetCommitmentId). Não é aggregate root separado porque sua existência é derivada do Centro de Custo — sem o agregado pai, Comprometimento isolado não tem semântica de capacidade orçamentária."
		}]

		handlesCommands: [
			"cmd-approve-budget",
			"cmd-reject-budget",
			"cmd-release-budget-commitment",
		]

		emitsEvents: [
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
		]

		usesValueObjects: [
			"vo-cost-center-id",
			"vo-money",
			"vo-budget-commitment-id",
			"vo-rejection-reason",
			"vo-commitment-release-reason",
		]

		rationale: "Single aggregate porque Centro de Custo é a única consistency boundary de BDG: cálculo de Saldo Disponível, registro de Comprometimento e Liberação são mutações que devem ser atômicas para preservar a invariante Saldo = Limite − Σ(comprometimentos ativos). Aggregate sem lifecycle (per tq-dmg-07): justificativa estrutural — persiste registry de Comprometimentos ativos (entities owned) que sustenta inv-released-amount-matches-commitment e inv-commitment-id-global-uniqueness-active; serve como uniqueness registry e ledger de reservas orçamentárias. Sem essa estrutura persistente, o Gate de Cobertura regride a snapshot stateless e a idempotência por compromisso fica sem enforcement. Lifecycle do próprio Centro de Custo (criação, ajuste de Limite, descontinuação) é governance externa per bd-allocation-not-treasury — não modelado como state machine porque transições não são triggered por commands de domínio do BDG; modelar especulativo violaria heuristic do PG. Eventos publicados (BudgetApproved/Rejected/Released) e ACL (CommitmentAcceptedReceived) listados em emitsEvents conforme padrão CMT/NPM (tq-dm-02): aggregate registra os fatos no seu event stream — ACL adapter produz semanticamente o evento traduzido. Note: vo-budget-approval-status e vo-cost-center-availability NÃO listados em usesValueObjects porque são tipos de retorno de queries (projeções), não fields stored no aggregate — tq-dm-04 warn aceito para esses dois VOs."
	}]

	// =============================================
	// POLICIES (event → command)
	// =============================================

	policies: [{
		code:             "pol-commitment-accepted-triggers-approval"
		name:             "Compromisso Aceito Dispara Aprovação Orçamentária"
		description:      "Quando CMT publica CommitmentAccepted (traduzido como evt-commitment-accepted-received via ACL), emite cmd-approve-budget para iniciar Gate de Cobertura. ACL adapter identifica Centro de Custo aplicável (per as-bdg-1) e enriquece o command."
		triggeredByEvent: "evt-commitment-accepted-received"
		issuesCommand:    "cmd-approve-budget"
		rationale:        "Canvas inbound: CommitmentAccepted reaction = 'Inicia processo de aprovação orçamentária. Agente identifica centro de custo aplicável a partir do compromisso, consulta saldo disponível e alçada, executa gate determinístico.' Policy formaliza a automação spine commitment-lifecycle: sinal externo de aceite → Gate de Cobertura. Outcome (aprovação ou rejeição) é decidido internamente pelo aggregate inspecionando guards (inv-coverage-gate-deterministic, inv-alcada-respected) — schema #Policy exige exatamente um issuesCommand, e cmd-approve-budget é o caminho canônico; rejeição emerge como decisão interna do aggregate ao falhar guards (transição implícita para emissão de cmd-reject-budget pelo próprio aggregate em handler de cmd-approve-budget). Em Phase 0 esta convenção é suficiente; refatorar para policy split caso volume de rejeições justifique."
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-budget-approval-status"
		name:        "BudgetApprovalStatusProjection"
		description: "Read model que materializa estado vigente de Aprovação Orçamentária por CommitmentId. Consumido por CMT (visibilidade pós-formalização) e por DRC quando disputa referencia compromisso aprovado, via QueryBudgetApprovalStatus."
		consumesEvents: [
			"evt-budget-approved",
			"evt-budget-rejected",
			"evt-budget-commitment-released",
		]
		queryCapabilities: [{
			code:        "qry-budget-approval-status"
			description: "Retorna BudgetApprovalStatus para um CommitmentId (pending, approved, rejected, released) com motivo estruturado e Centro de Custo associado."
			rationale:   "Canvas query-surface QueryBudgetApprovalStatus retorna BudgetApprovalStatus. Interface primária de leitura para CMT (visibilidade pós-formalização) e DRC (contexto de disputa)."
		}]
		rationale: "Per canvas query-surface QueryBudgetApprovalStatus consumida por CMT/DRC. Projeção mantém estado vigente sintético derivado de events; otimizada para lookup por CommitmentId. Latência de projeção alvo per eda-projections: <5s para consumers síncronos."
	}, {
		code:        "prj-cost-center-availability"
		name:        "CostCenterAvailabilityProjection"
		description: "Read model que materializa capacidade orçamentária por Centro de Custo: Limite, Saldo Disponível, total de comprometimentos ativos. Consumido por controllers, supervisores e (cenário evolutivo per oq-bdg-3) por CMT para previsão de cobertura pré-formalização."
		consumesEvents: [
			"evt-budget-approved",
			"evt-budget-commitment-released",
		]
		queryCapabilities: [{
			code:        "qry-cost-center-availability"
			description: "Retorna CostCenterAvailability para um CostCenterId (Limite, Saldo Disponível, comprometimentos ativos)."
			rationale:   "Canvas query-surface QueryCostCenterAvailability retorna CostCenterAvailability. Consumed por controllers, supervisores e (cenário evolutivo per oq-bdg-3) por CMT para previsão de cobertura pré-formalização."
		}]
		rationale: "Per canvas query-surface QueryCostCenterAvailability. Projeção agrega comprometimentos ativos para derivar Saldo Disponível em runtime sem reconstruir do event log. Não consome evt-budget-rejected porque rejeições não afetam Saldo Disponível (não criam reserva)."
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

		Behavior-first ordering aplicado: events emergem do canvas
		(1 published spine BudgetApproved + 2 published pendentes de
		formalização cross-BC per oq-bdg-2 BudgetRejected/
		BudgetCommitmentReleased modelados como UL terms no glossary
		para preservar paralelismo + 1 internal ACL
		CommitmentAcceptedReceived); commands derivam de canvas inbound
		(ApproveBudget, RejectBudget) + intenção interna anchor
		(ReleaseBudgetCommitment); invariants protegidos derivados de
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
		value-objects reconciliados com 15 terms do glossary BDG
		(term-cobertura-orcamentaria, term-centro-de-custo,
		term-saldo-disponivel, term-limite-de-centro-de-custo,
		term-comprometimento-orcamentario, term-alcada,
		term-aprovacao-orcamentaria, term-gate-de-cobertura,
		term-approve-budget, term-reject-budget, term-budget-approved,
		term-budget-rejected, term-budget-commitment-released,
		term-liberacao-de-comprometimento, term-fracionamento). 14
		dos 15 terms têm mapping explícito; term-fracionamento NÃO
		modelado como invariant local (deferred to oq-bdg-1). Sem
		divergências terminológicas identificadas. Loanword 'Alcada'
		não aparece como code (codes em ASCII per schema regex) mas
		é referenciada em rationale e modelada via inv-alcada-respected
		(decorre da tabela de Alçadas configurada externamente).
		"""
}
