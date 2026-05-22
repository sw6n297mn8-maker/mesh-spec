package fce

// domain-model.cue — Domain Model: Financial Commitment Execution.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Design tático do FCE. Building blocks em ordering behavior-first:
// events → commands → invariants → value objects → aggregates → policies → projections.
//
// Decisões de design:
// - 2 aggregates: agg-payment (lifecycle central) e agg-financial-compensation
//   (execução de compensações ordenadas por DRC, lifecycle puramente financeiro
//   sem decisão de mérito).
// - 13 events: 2 published (PaymentSettled, PaymentObligationDefaulted), 6
//   observados via ACL (invoice, eligibility, bank settlement, dispute,
//   compensation order), 5 internos puros (state-changed para ambos aggregates,
//   ledger-event-recorded, settlement-aborted, financial-compensation-recorded).
// - 10 commands, todos internos (FCE é cross-context event-driven — não expõe
//   command-handlers cross-BC).
// - 9 invariants materializando os 4 BDs do canvas + 5 operacionais.
// - PrePaymentGuard é gate interno do FCE — REW fornece input via
//   CreditEligibilityDecided observado. Disciplina explícita.
// - agg-financial-compensation não revisa mérito, causa, responsabilidade ou
//   valor: lifecycle puramente financeiro (ordered → executing → recorded).
//   inv-compensation-respects-drc-decision formaliza essa disciplina de boundary.
// - pre-settle = pré-emissão de InitiateBankTransfer. Após emissão, dinheiro pode
//   já estar no rail; settling tem apenas 2 saídas (settled | defaulted).
//   Cancellation durante settling → policy dispara mas aggregate rejeita
//   sem transição e registra no-op auditável; correção pós-settle vira
//   responsabilidade de DRC via FinancialCompensationOrdered.
//
// Gaps Phase 0 (deferred):
// - wiring concreto de inv-financialization-atomicity (policy/service SCF)
//   aguarda evidência operacional de uso SCF.
// - branches de failure em agg-financial-compensation (equivalente a
//   cmd-resolve-prolonged-settling do payment) aguardam padrão observado.
//
// Trade-off documentado (tq-dm-02):
// - Eventos ACL (sourceContext) são produzidos pela camada ACL, não pelo
//   aggregate. Listados em emitsEvents para satisfazer tq-dm-02 que exige
//   que todo event do catálogo esteja wired a um aggregate. Semanticamente
//   o aggregate "registra" o fato observado no seu event stream. Convenção
//   herdada de cmt.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code: "fce"
	name: "Financial Commitment Execution Domain Model"

	boundedContextRef: "fce"

	// =============================================
	// EVENTS (behavior-first: fatos observados ou produzidos)
	// =============================================

	events: [{
		// --- PUBLISHED ---
		code:        "evt-payment-settled"
		name:        "PaymentSettled"
		visibility:  "published"
		description: "Liquidação financeira confirmada — payment state machine atingiu o estado terminal settled após BankSettlementConfirmed de BKR. Consumido por REW (retroalimenta risco), SCF (fecha antecipação), ATO (lançamento contábil em modo conformist) e TCM (converte projeção em posição realizada)."
		rationale:   "Evento canônico de saída do FCE. Materializa bd-settled-after-bkr: só é publicado após confirmação do rail. Sinal positivo canônico de liquidação cross-BC."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "invoiceRef", valueObjectRef: "vo-invoice-ref"
		}, {
			kind: "value-object-ref", name: "amount", valueObjectRef: "vo-money"
		}, {
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-counterparty-pair"
		}, {
			kind: "value-object-ref", name: "rail", valueObjectRef: "vo-settlement-rail"
		}, {
			kind:        "value-object-ref", name: "bankTransferRef", valueObjectRef: "vo-bank-transfer-ref"
			description: "Identificador BKR-side da liquidação física confirmada — fecha trilha BKR↔FCE."
		}, {
			kind:        "primitive", name: "settledAt", type: "datetime"
			description: "Timestamp de BankSettlementConfirmed recebido."
		}]
	}, {
		code:        "evt-payment-obligation-defaulted"
		name:        "PaymentObligationDefaulted"
		visibility:  "published"
		description: "Pagamento não foi executado dentro do prazo após elegibilidade autorizada, ou settlement falhou em rail sem recuperação. Consumido por REW para alimentar modelos de risco — comportamento financeiro adverso da contraparte."
		rationale:   "Sinal canônico de falha terminal do payment lifecycle. Publicado apenas para REW (modelo de risco); ATO e TCM não consomem porque default não gera lançamento contábil de liquidação. Pode informar decisões futuras de elegibilidade em REW."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-counterparty-pair"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-payment-failure-reason"
		}, {
			kind: "primitive", name: "defaultedAt", type: "datetime"
		}]
	}, {
		// --- OBSERVADOS VIA ACL ---
		code:          "evt-invoice-issued-received"
		name:          "InvoiceIssuedReceived"
		visibility:    "internal"
		sourceContext: "inv"
		description:   "Evento externo observado via ACL — tradução de InvoiceIssued (INV) para a linguagem local do FCE. Sinal canônico para iniciar o payment lifecycle: fatura emitida vincula CommitmentId + evidência verificada (DLV)."
		rationale:     "Não é evento interno do FCE no sentido domínio; é a face do FCE para o sinal observado de INV. Trigger para pol-invoice-issued-registers-payment."
		fields: [{
			kind: "value-object-ref", name: "invoiceRef", valueObjectRef: "vo-invoice-ref"
		}, {
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "amount", valueObjectRef: "vo-money"
		}, {
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-counterparty-pair"
		}]
	}, {
		code:          "evt-invoice-cancelled-received"
		name:          "InvoiceCancelledReceived"
		visibility:    "internal"
		sourceContext: "inv"
		description:   "Evento externo observado via ACL — tradução de InvoiceCancelled (INV). Sinal para abortar payment lifecycle quando ainda em pending ou eligible (pré-emissão de InitiateBankTransfer). Pós-emissão, cancellation vira responsabilidade de DRC (bd-post-settle-immutability)."
		rationale:     "ACL face para cancellation da fatura. Trigger para pol-invoice-cancelled-aborts-pre-settle. Janela de cobertura: pending/eligible. Settling+ é coberto exclusivamente por DRC."
		fields: [{
			kind: "value-object-ref", name: "invoiceRef", valueObjectRef: "vo-invoice-ref"
		}, {
			kind: "primitive", name: "cancelledAt", type: "datetime"
		}]
	}, {
		code:          "evt-credit-eligibility-decided-received"
		name:          "CreditEligibilityDecidedReceived"
		visibility:    "internal"
		sourceContext: "rew"
		description:   "Evento externo observado via ACL — tradução de CreditEligibilityDecided (REW). Fornece input determinístico para o PrePaymentGuard avaliar elegibilidade do payment lifecycle correspondente."
		rationale:     "ACL face para decisão de risco de REW. PrePaymentGuard é interno ao FCE; REW só fornece input. Trigger para pol-eligibility-decided-evaluates-guard."
		fields: [{
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "decision", valueObjectRef: "vo-eligibility-decision"
		}]
	}, {
		code:          "evt-bank-settlement-confirmed-received"
		name:          "BankSettlementConfirmedReceived"
		visibility:    "internal"
		sourceContext: "bkr"
		description:   "Evento externo observado via ACL — tradução de BankSettlementConfirmed (BKR). Sinal canônico de movimento real no rail bancário. bankTransferRef resolve para payment OU compensation: aggregate que possui a ref aceita o command derivado; outro registra no-op auditável."
		rationale:     "ACL face para confirmação física do rail. BKR é tratado como oracle canônico dentro do boundary do FCE (bd-settled-after-bkr). Triggers para pol-bank-settlement-confirmed-finalizes-payment e pol-bank-settlement-confirmed-finalizes-compensation — discriminação por bankTransferRef ownership no aggregate."
		fields: [{
			kind: "value-object-ref", name: "bankTransferRef", valueObjectRef: "vo-bank-transfer-ref"
		}, {
			kind: "primitive", name: "confirmedAt", type: "datetime"
		}]
	}, {
		code:          "evt-dispute-resolved-received"
		name:          "DisputeResolvedReceived"
		visibility:    "internal"
		sourceContext: "drc"
		description:   "Evento externo observado via ACL — tradução de DisputeResolved (DRC). Decisão de disputa que pode reverter pagamento, reter saldo, ou liberar pagamento previamente bloqueado por disputa em andamento."
		rationale:     "ACL face para decisão de disputa. FCE não decide mérito da disputa — apenas executa consequências financeiras orientadas por DRC. Trigger para pol-dispute-resolved-routes."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind:        "domain-type", name: "resolution", type: "DisputeResolution"
			description: "Decisão de DRC: reverter, reter, liberar."
		}]
	}, {
		code:          "evt-financial-compensation-ordered-received"
		name:          "FinancialCompensationOrderedReceived"
		visibility:    "internal"
		sourceContext: "drc"
		description:   "Evento externo observado via ACL — tradução de FinancialCompensationOrdered (DRC). Ordem de execução de movimento financeiro de natureza distinta (refund, reembolso) já decidida por DRC — valores, partes e mérito determinados upstream."
		rationale:     "ACL face para compensação ordenada. FCE executa o lifecycle financeiro; não revisa mérito, causa, responsabilidade ou valor (decisões pertencem a DRC). Trigger para pol-compensation-ordered-initiates."
		fields: [{
			kind:        "domain-type", name: "compensationOrder", type: "CompensationOrder"
			description: "Ordem completa de DRC: amount, parties, motivo de origem (ref disputa). Imutável dentro do FCE."
		}]
	}, {
		// --- INTERNOS PUROS ---
		code:        "evt-payment-state-changed"
		name:        "PaymentStateChanged"
		visibility:  "internal"
		description: "Transição de estado do payment lifecycle (pending → eligible → settling, ou ramos defaulted/aborted). Fato interno para audit trail e construção da projection prj-payment-state-view."
		rationale:   "Evento genérico de transição (vs evento por transição). Reduz acoplamento da projection downstream — consome um tipo, não N. Custo: consumer inspeciona previousState/newState. Padrão herdado de cmt evt-commitment-state-changed."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "value-object-ref", name: "previousState", valueObjectRef: "vo-payment-state"
		}, {
			kind: "value-object-ref", name: "newState", valueObjectRef: "vo-payment-state"
		}, {
			kind: "primitive", name: "changedAt", type: "datetime"
		}]
	}, {
		code:        "evt-compensation-state-changed"
		name:        "CompensationStateChanged"
		visibility:  "internal"
		description: "Transição de estado do compensation lifecycle (ordered → executing → recorded). Fato interno para audit trail."
		rationale:   "Simétrico com evt-payment-state-changed. Compensation lifecycle é simples (linear, 3 estados); evento existe para alimentar audit/projection sem inflar com eventos por transição."
		fields: [{
			kind: "value-object-ref", name: "compensationId", valueObjectRef: "vo-financial-compensation-id"
		}, {
			kind: "value-object-ref", name: "previousState", valueObjectRef: "vo-compensation-state"
		}, {
			kind: "value-object-ref", name: "newState", valueObjectRef: "vo-compensation-state"
		}, {
			kind: "primitive", name: "changedAt", type: "datetime"
		}]
	}, {
		code:        "evt-ledger-event-recorded"
		name:        "LedgerEventRecorded"
		visibility:  "internal"
		description: "Append-only ledger fact — fato financeiro registrado de forma imutável vinculando CommitmentId, evidência operacional e movimento. Consumido por prj-financial-ledger para materializar o SoT canônico contra o qual ATO/TCM/SCF reconciliam."
		rationale:   "Materializa bd-ledger-as-sot. Todo movimento canônico (settlement, default, compensation) deve produzir um evt-ledger-event-recorded. Imutabilidade do ledger é construída por append-only no Event Log."
		fields: [{
			kind: "value-object-ref", name: "ledgerEvent", valueObjectRef: "vo-ledger-event"
		}]
	}, {
		code:        "evt-settlement-aborted"
		name:        "SettlementAborted"
		visibility:  "internal"
		description: "Payment lifecycle abortado pré-emissão de InitiateBankTransfer (cancelamento de fatura observado antes de settling). Holds liberados; sem movimento financeiro."
		rationale:   "Branch terminal alternativo do lifecycle. Distinto de defaulted (falha) porque abort é intencional vs default é falha operacional. Não publicado cross-BC — TCM/ATO não recebem porque não houve movimento."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-payment-failure-reason"
		}, {
			kind: "primitive", name: "abortedAt", type: "datetime"
		}]
	}, {
		code:        "evt-financial-compensation-recorded"
		name:        "FinancialCompensationRecorded"
		visibility:  "internal"
		description: "Compensação financeira ordenada por DRC executada e registrada no ledger. Lifecycle de execução do agg-financial-compensation concluído — sem decisão de mérito, apenas confirmação de movimento."
		rationale:   "Fato interno do FCE; o aspecto público é capturado por evt-ledger-event-recorded (que prj-financial-ledger materializa). Evento separado porque rastreabilidade exige distinguir compensation de settlement no audit trail."
		fields: [{
			kind: "value-object-ref", name: "compensationId", valueObjectRef: "vo-financial-compensation-id"
		}, {
			kind: "value-object-ref", name: "bankTransferRef", valueObjectRef: "vo-bank-transfer-ref"
		}, {
			kind: "primitive", name: "recordedAt", type: "datetime"
		}]
	}]

	// =============================================
	// COMMANDS (intenções de mutação)
	// =============================================

	commands: [{
		code:        "cmd-register-invoice-for-payment"
		name:        "RegisterInvoiceForPayment"
		description: "Registra fatura observada via ACL no payment lifecycle, criando payment em estado pending. Trigger interno disparado pela policy reagindo a evt-invoice-issued-received."
		rationale:   "Comando interno (FCE é event-driven cross-BC — sem command-handlers expostos). Entrada do lifecycle: cada InvoiceIssued observado cria exatamente um payment."
		fields: [{
			kind: "value-object-ref", name: "invoiceRef", valueObjectRef: "vo-invoice-ref"
		}, {
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "amount", valueObjectRef: "vo-money"
		}, {
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-counterparty-pair"
		}]
	}, {
		code:        "cmd-evaluate-pre-payment-guard"
		name:        "EvaluatePrePaymentGuard"
		description: "Avalia invariantes determinísticas do gate PrePaymentGuard: coerência entre CommitmentId, InvoiceIssued e elegibilidade vigente (REW); presença de cash availability (TCM). Resultado positivo transiciona pending → eligible."
		rationale:   "Materializa bd-payment-invariant via gate determinístico interno ao FCE. Avaliação autônoma (canvas governance scope) — agente executa sem supervisão pois invariantes são checagens computáveis."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}]
	}, {
		code:        "cmd-initiate-bank-transfer"
		name:        "InitiateBankTransfer"
		description: "FCE solicita movimento no rail bancário via emissão de InitiateBankTransfer command-invocation a BKR após gate aprovado e caixa confirmada. Transiciona eligible → settling."
		rationale:   "Supervisionada integralmente (canvas governance) até definição de threshold de autonomia (oq-fce-1). Distinto de cmd-evaluate-pre-payment-guard porque esta é a decisão de mover dinheiro real, irreversível pós-settlement."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "value-object-ref", name: "rail", valueObjectRef: "vo-settlement-rail"
		}]
	}, {
		code:        "cmd-confirm-settlement"
		name:        "ConfirmSettlement"
		description: "Confirma liquidação após BankSettlementConfirmedReceived (BKR). Transiciona settling → settled, registra ledger event final e publica PaymentSettled."
		rationale:   "Materializa bd-settled-after-bkr. Decisão autônoma — BKR é oracle canônico; FCE apenas registra o fato confirmado e propaga."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "value-object-ref", name: "bankTransferRef", valueObjectRef: "vo-bank-transfer-ref"
		}, {
			kind: "primitive", name: "confirmedAt", type: "datetime"
		}]
	}, {
		code:        "cmd-mark-defaulted"
		name:        "MarkDefaulted"
		description: "Transiciona payment para estado terminal defaulted (timeout após elegibilidade ou falha de rail sem recuperação). Emite PaymentObligationDefaulted publicado para REW."
		rationale:   "Branch terminal alternativo. Distinto de aborted (intencional) — default é falha operacional não recuperável. Decisão pode ser autônoma (timeout determinístico) ou supervisionada (escalation via resolve-prolonged-settling)."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-payment-failure-reason"
		}]
	}, {
		code:        "cmd-abort-pre-settle"
		name:        "AbortPreSettle"
		description: "Aborta payment lifecycle ao receber InvoiceCancelled antes de emissão de InitiateBankTransfer (estado pending ou eligible). Libera holds, transiciona para aborted. Pós-emissão, command é no-op auditável: aggregate não transiciona e registra a decisão."
		rationale:   "Reação determinística a evento ACL dentro da janela coberta (pre-settle = pré-emissão de InitiateBankTransfer). Pós-emissão, cancellation vira responsabilidade de DRC (bd-post-settle-immutability) — dinheiro pode já estar no rail."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "value-object-ref", name: "reason", valueObjectRef: "vo-payment-failure-reason"
		}]
	}, {
		code:        "cmd-resolve-prolonged-settling"
		name:        "ResolveProlongedSettling"
		description: "Decisão supervisionada sobre payments em settling além de SLA: retry, escalate ou default. Disparado quando BKR não confirma após N retries dentro da janela settling→settled."
		rationale:   "Supervisão humana (canvas governance) — diagnóstico de causa raiz exige julgamento sobre confiabilidade do rail. Pode terminar em ConfirmSettlement (retry funcionou), MarkDefaulted (rail irrecuperável) ou intervenção manual."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind:        "domain-type", name: "decision", type: "SettlingResolutionDecision"
			description: "Decisão humana: retry, escalate-default, manual-intervene."
		}]
	}, {
		code:        "cmd-handle-dispute-resolution"
		name:        "HandleDisputeResolution"
		description: "Processa resolução de disputa recebida de DRC. Aggregate inspeciona resolution e executa transição apropriada do payment lifecycle (reverter via abort se pre-settle, no-op auditável se settling/settled — pós-settle DRC ordena FinancialCompensationOrdered separadamente)."
		rationale:   "Análogo a cmt cmd-handle-dispute-resolution. #Policy exige exatamente um issuesCommand; routing multi-outcome vive no aggregate porque ele é o consistency boundary."
		fields: [{
			kind: "value-object-ref", name: "paymentId", valueObjectRef: "vo-payment-id"
		}, {
			kind: "domain-type", name: "resolution", type: "DisputeResolution"
		}]
	}, {
		// --- agg-financial-compensation commands ---
		code:        "cmd-execute-financial-compensation"
		name:        "ExecuteFinancialCompensation"
		description: "Inicia execução de compensação financeira ordenada por DRC. Cria compensation em estado ordered → executing; emite InitiateBankTransfer a BKR com valores e partes determinados upstream por DRC."
		rationale:   "Supervisionada (canvas governance) — embora valores/partes/mérito sejam ordenados por DRC, a execução move dinheiro real. inv-compensation-respects-drc-decision garante que FCE não revisa nem altera a ordem; apenas executa."
		fields: [{
			kind: "domain-type", name: "compensationOrder", type: "CompensationOrder"
		}]
	}, {
		code:        "cmd-confirm-compensation-settled"
		name:        "ConfirmCompensationSettled"
		description: "Confirma execução da compensação após BankSettlementConfirmedReceived correspondente. Transiciona executing → recorded; registra ledger event vinculado à ordem original de DRC."
		rationale:   "Autônoma — BKR é oracle canônico; o ledger event preserva proveniência (origem dispute-driven) para auditoria."
		fields: [{
			kind: "value-object-ref", name: "compensationId", valueObjectRef: "vo-financial-compensation-id"
		}, {
			kind: "value-object-ref", name: "bankTransferRef", valueObjectRef: "vo-bank-transfer-ref"
		}]
	}]

	// =============================================
	// INVARIANTS (regras que nunca podem ser violadas)
	// =============================================

	invariants: [{
		code:      "inv-payment-evidence-required"
		name:      "Dinheiro só se move com evidência"
		rule:      "Nenhum payment transiciona para settling sem (a) InvoiceIssued observado de INV, (b) CreditEligibilityDecided positivo observado de REW, e (c) cash availability confirmada em TCM. PrePaymentGuard é gate interno do FCE que verifica essas três condições determinísticamente."
		rationale: "Materializa bd-payment-invariant — invariante central da fusão CMT-DLV-FCE. Razão de existência do FCE como BC separado. PrePaymentGuard é interno; REW fornece input via CreditEligibilityDecidedReceived."
		dependsOnAggregateState: {
			boundedContextRef: "tcm"
			aggregateRef:      "agg-cash-position"
			accessVia: {
				kind:               "sync-query"
				canvasQuerySurface: "QueryCashAvailability"
			}
			rationale: "Cash availability é owned por TCM; FCE consulta via canvas query-surface no momento de avaliar gate. INV e REW são satisfeitos por arrival de events (não cross-state dependency); apenas TCM exige sync read no momento da decisão."
		}
	}, {
		code:      "inv-ledger-immutability"
		name:      "Ledger é append-only"
		rule:      "Ledger events registrados nunca são mutados, removidos ou retroagidos. Correção de movimentos canonicamente registrados ocorre via novo movimento rastreável (refund via FinancialCompensationOrdered), não via mutação retroativa."
		rationale: "Materializa bd-ledger-as-sot + bd-post-settle-immutability. Imutabilidade é o que torna o ledger consultável como fonte auditável e contábil. Apêndice via Event Log; correção via novo fato."
	}, {
		code:      "inv-settled-requires-bkr-confirmation"
		name:      "Settled exige confirmação BKR"
		rule:      "Nenhum payment transiciona para settled sem BankSettlementConfirmed observado de BKR. PaymentSettled só é publicado pós-ACK do rail."
		rationale: "Materializa bd-settled-after-bkr. Estado settling existe explicitamente para representar a janela entre InitiateBankTransfer e confirmação BKR — settling ≠ settled para todos os consumidores."
	}, {
		code:      "inv-post-settle-immutability"
		name:      "Pós-settlement não retroage no FCE"
		rule:      "Payment em estado settled não aceita commands de abort, reversão ou mutação retroativa. Correção pós-settle vira responsabilidade de DRC, que pode emitir FinancialCompensationOrdered (refund rastreável como novo movimento)."
		rationale: "Materializa bd-post-settle-immutability. Permitir mutação retroativa quebraria audit trail (dp-10) e duplicaria papel do DRC. Separação clara: pré-emissão de InitiateBankTransfer FCE aborta; pós-emissão DRC ordena compensação."
	}, {
		code:      "inv-cash-availability-required-for-settling"
		name:      "Settling requer caixa disponível"
		rule:      "Transição eligible → settling exige confirmação de cash availability em TCM no momento da emissão de InitiateBankTransfer. Settlement sem caixa cria default operacional mesmo com PrePaymentGuard aprovado."
		rationale: "FCE não assume gestão de caixa — TCM é SoT. Subset de inv-payment-evidence-required isolado porque é o gate específico para transição settling (vs evaluation do guard). Cobertura cross-aggregate compartilhada com inv-payment-evidence-required."
	}, {
		code:      "inv-commitment-id-preservation"
		name:      "CommitmentId preservado end-to-end"
		rule:      "Todo payment e toda compensation rastreia até o CommitmentId originário. Ledger events, PaymentSettled, PaymentObligationDefaulted e FinancialCompensationRecorded carregam CommitmentId sem alteração."
		rationale: "CommitmentId é fio de rastreabilidade end-to-end nascido em CMT. FCE preserva sem modificar — viabiliza reconciliação cross-BC (SCF, ATO, TCM) e auditoria contínua (cc-04)."
	}, {
		code:      "inv-bank-transfer-requires-supervision"
		name:      "InitiateBankTransfer requer supervisão"
		rule:      "Nenhum InitiateBankTransfer é emitido sem supervisão humana até definição de threshold de autonomia. Após threshold definido, transfers abaixo do valor configurado tornam-se autônomos dentro do envelope; acima permanecem supervisionados."
		rationale: "Canvas governance: initiate-bank-transfer é supervisedDecision. Threshold pendente em oq-fce-1. Aplica também a cmd-execute-financial-compensation que emite InitiateBankTransfer."
	}, {
		code:      "inv-financialization-atomicity"
		name:      "Financialization é all-or-nothing"
		rule:      "Quando antecipação SCF é elegível para um payment, settlement original e cessão à IF financiadora ocorrem atomicamente. Falha em qualquer perna aborta toda a operação composta — sem estados intermediários inconsistentes."
		rationale: "Materializa a capability local do canvas. Invariant declarada; wiring concreto (policy/service SCF) é Phase 0 gap deferred — aguarda evidência operacional de uso SCF. Quando wired, busca evitar que SCF receba cessão sem settlement correspondente nem vice-versa."
	}, {
		code:      "inv-compensation-respects-drc-decision"
		name:      "FCE não revisa compensações ordenadas por DRC"
		rule:      "agg-financial-compensation executa exatamente os valores, partes e referências de proveniência determinados por DRC. FCE não recalcula valor, reavalia mérito, modifica partes ou questiona causa. Lifecycle do aggregate é puramente financeiro (ordered → executing → recorded)."
		rationale: "Disciplina de boundary do FCE — compensações são domínio de DRC; FCE executa. Sem essa invariant, agg-financial-compensation tenderia a absorver lógica de DRC dentro do FCE, quebrando separação de concerns (bd-post-settle-immutability + dp-10)."
	}]

	// =============================================
	// VALUE OBJECTS (tipos imutáveis sem identidade)
	// =============================================

	valueObjects: [{
		code:        "vo-payment-id"
		name:        "PaymentId"
		description: "Identificador canônico do payment lifecycle no FCE. Gerado no momento de RegisterInvoiceForPayment; permeia ledger events e a projection prj-financial-ledger."
		fields: [{kind: "primitive", name: "value", type: "string"}]
		rationale: "Identidade do agg-payment. Distinto de CommitmentId (que rastreia o compromisso end-to-end); permite múltiplos payments por compromisso (parcelas, reemissões pré-settle)."
	}, {
		code:        "vo-payment-state"
		name:        "PaymentState"
		description: "Estado canônico do payment no lifecycle. Enum: pending, eligible, settling, settled, defaulted, aborted."
		fields: [{kind: "primitive", name: "value", type: "string"}]
		constraints: ["value deve ser um dos: pending, eligible, settling, settled, defaulted, aborted"]
		rationale: "Distinção settling vs settled é o coração de bd-settled-after-bkr. defaulted e aborted são branches terminais distintos (falha operacional vs intencional)."
	}, {
		code:        "vo-commitment-id"
		name:        "CommitmentId"
		description: "Referência ao identificador canônico do compromisso originário em CMT. Permanece imutável em todo o payment lifecycle e em ledger events vinculados."
		fields: [{kind: "primitive", name: "value", type: "string"}]
		rationale: "Cross-BC reference — preserva fio de rastreabilidade end-to-end (inv-commitment-id-preservation). FCE não gera CommitmentId; apenas referencia."
	}, {
		code:        "vo-invoice-ref"
		name:        "InvoiceRef"
		description: "Referência à fatura emitida em INV que originou o payment. Inclui invoice-id e timestamp de emissão."
		fields: [{
			kind: "primitive", name: "invoiceId", type: "string"
		}, {
			kind: "primitive", name: "issuedAt", type: "datetime"
		}]
		rationale: "Cross-BC reference — INV é SoT da fatura. FCE consulta para validar coerência no PrePaymentGuard."
	}, {
		code:        "vo-money"
		name:        "Money"
		description: "Valor monetário com moeda explícita. Imutável."
		fields: [{
			kind: "primitive", name: "amount", type: "decimal"
		}, {
			kind:        "primitive", name: "currency", type: "string"
			description: "Código ISO 4217 (ex.: BRL, USD)."
		}]
		constraints: ["amount > 0 para movimentos canônicos; ledger events de reversão preservam sinal explícito via type, não amount negativo"]
		rationale: "Conceito de domínio reutilizado em events, commands, aggregate fields. Promover spread de payments multi-moeda exige currency explícito desde início."
	}, {
		code:        "vo-ledger-event"
		name:        "LedgerEvent"
		description: "Fato financeiro registrado de forma imutável no ledger canônico. Carrega tipo (settlement, default-marker, compensation), CommitmentId, PaymentId/CompensationId, amount, parties e timestamp."
		fields: [{
			kind: "primitive", name: "ledgerEventId", type: "string"
		}, {
			kind:        "primitive", name: "type", type: "string"
			description: "settlement | default-marker | compensation"
		}, {
			kind: "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
		}, {
			kind: "value-object-ref", name: "amount", valueObjectRef: "vo-money"
		}, {
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-counterparty-pair"
		}, {
			kind: "primitive", name: "recordedAt", type: "datetime"
		}, {
			kind:        "primitive", name: "sourcePaymentId", type: "string"
			description: "PaymentId ou CompensationId originário."
		}]
		constraints: ["type deve ser um dos: settlement, default-marker, compensation"]
		rationale: "Fato canônico do ledger SoT. Imutabilidade aplicada via inv-ledger-immutability + append-only no Event Log. default-marker (não default) reflete que o ledger registra o fato 'pagamento defaultou' como marcador, não como movimento financeiro."
	}, {
		code:        "vo-settlement-rail"
		name:        "SettlementRail"
		description: "Rail bancário usado para liquidação física. Enum: pix, ted, boleto, swift."
		fields: [{kind: "primitive", name: "value", type: "string"}]
		constraints: ["value deve ser um dos: pix, ted, boleto, swift"]
		rationale: "Tipo de rail informa SLA (oq-fce-2) e estratégia de sequenciamento. FCE não opera rail diretamente — delega a BKR; mantém ref para audit e SLA-tracking."
	}, {
		code:        "vo-bank-transfer-ref"
		name:        "BankTransferRef"
		description: "Identificador BKR-side da transferência bancária. Vincula confirmation de BKR ao payment ou compensation correspondente."
		fields: [{
			kind:        "primitive", name: "value", type: "string"
			description: "ID gerado por BKR ao receber InitiateBankTransfer."
		}]
		rationale: "Cross-BC reference — BKR é SoT da liquidação física. Fecha trilha BKR↔FCE em ledger events."
	}, {
		code:        "vo-eligibility-decision"
		name:        "EligibilityDecision"
		description: "Decisão de elegibilidade observada de REW. Inclui resultado (positive/negative), score reference e timestamp."
		fields: [{
			kind:        "primitive", name: "result", type: "string"
			description: "positive | negative"
		}, {
			kind:        "primitive", name: "scoreRef", type: "string"
			description: "Referência ao score REW-side; FCE não recalcula."
		}, {
			kind: "primitive", name: "decidedAt", type: "datetime"
		}]
		constraints: ["result deve ser: positive ou negative"]
		rationale: "Cross-BC reference — REW é SoT da decisão. FCE consome como input para o gate; não revalida nem modifica."
	}, {
		code:        "vo-counterparty-pair"
		name:        "CounterpartyPair"
		description: "Par de partes envolvidas no movimento financeiro: payer e receiver."
		fields: [{
			kind: "domain-type", name: "payer", type: "ParticipantId"
		}, {
			kind: "domain-type", name: "receiver", type: "ParticipantId"
		}]
		rationale: "Análogo a cmt vo-commitment-parties. Encapsula o par bilateral; movimento sem ambos é estruturalmente inválido."
	}, {
		code:        "vo-payment-failure-reason"
		name:        "PaymentFailureReason"
		description: "Causa estruturada de defaulted ou aborted. Inclui tipo, descrição auditável e referência de contexto (rail-failure-ref, invoice-cancellation-ref, dispute-ref)."
		fields: [{
			kind:        "primitive", name: "type", type: "string"
			description: "rail-failure | timeout | invoice-cancelled | dispute-suspension | manual-abort"
		}, {
			kind: "primitive", name: "description", type: "string"
		}, {
			kind:        "primitive", name: "contextRef", type: "string"
			description: "Referência ao evento ou trigger originário (e.g., InvoiceCancelledReceived ID)."
		}]
		constraints: ["type deve ser um dos: rail-failure, timeout, invoice-cancelled, dispute-suspension, manual-abort"]
		rationale: "Estrutura uniforme para audit e para alimentar modelos REW (PaymentObligationDefaulted preserva proveniência da falha)."
	}, {
		code:        "vo-financial-compensation-id"
		name:        "FinancialCompensationId"
		description: "Identificador canônico do lifecycle de compensação financeira no FCE. Gerado em cmd-execute-financial-compensation."
		fields: [{kind: "primitive", name: "value", type: "string"}]
		rationale: "Identidade do agg-financial-compensation. Distinto de PaymentId — compensações não fazem parte do payment lifecycle normal."
	}, {
		code:        "vo-compensation-state"
		name:        "CompensationState"
		description: "Estado canônico da compensação financeira. Enum: ordered, executing, recorded."
		fields: [{kind: "primitive", name: "value", type: "string"}]
		constraints: ["value deve ser um dos: ordered, executing, recorded"]
		rationale: "Lifecycle restrito — agg-financial-compensation não revisa mérito (inv-compensation-respects-drc-decision); apenas executa. Sem branches de rejection ou modificação porque DRC já decidiu upstream."
	}]

	// =============================================
	// AGGREGATES (consistency boundaries)
	// =============================================

	aggregates: [{
		code:        "agg-payment"
		name:        "Payment"
		description: "Aggregate root do payment lifecycle. Encapsula estado, partes, refs e ledger trace do payment desde InvoiceIssued observado até settled, defaulted ou aborted."

		rootIdentity: {
			field: "paymentId"
			type: {kind: "value-object-ref", valueObjectRef: "vo-payment-id"}
		}

		fields: [{
			kind:        "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
			description: "Fio de rastreabilidade end-to-end (inv-commitment-id-preservation)."
		}, {
			kind:        "value-object-ref", name: "invoiceRef", valueObjectRef: "vo-invoice-ref"
			description: "Fatura originária observada de INV."
		}, {
			kind: "value-object-ref", name: "amount", valueObjectRef: "vo-money"
		}, {
			kind: "value-object-ref", name: "parties", valueObjectRef: "vo-counterparty-pair"
		}, {
			kind: "value-object-ref", name: "currentState", valueObjectRef: "vo-payment-state"
		}, {
			kind:        "value-object-ref", name: "eligibilityDecision", valueObjectRef: "vo-eligibility-decision"
			description: "Populated após CreditEligibilityDecided observado; null até então."
		}, {
			kind:        "value-object-ref", name: "rail", valueObjectRef: "vo-settlement-rail"
			description: "Populated em InitiateBankTransfer; null em pending/eligible."
		}, {
			kind:        "value-object-ref", name: "bankTransferRef", valueObjectRef: "vo-bank-transfer-ref"
			description: "Populated em settling; fecha trilha BKR↔FCE."
		}, {
			kind:        "value-object-ref", name: "failureReason", valueObjectRef: "vo-payment-failure-reason"
			description: "Populated em defaulted ou aborted; null em outros estados."
		}, {
			kind:        "primitive", name: "registeredAt", type: "datetime"
			description: "Criação do payment (cmd-register-invoice-for-payment)."
		}, {
			kind:        "primitive", name: "becameEligibleAt", type: "datetime"
			description: "Timestamp da transição pending → eligible."
		}, {
			kind:        "primitive", name: "settlingStartedAt", type: "datetime"
			description: "Timestamp da emissão de InitiateBankTransfer (settling window opens)."
		}, {
			kind:        "primitive", name: "settledAt", type: "datetime"
			description: "Timestamp de BankSettlementConfirmed (settled)."
		}, {
			kind:        "primitive", name: "defaultedAt", type: "datetime"
			description: "Timestamp de transição para defaulted, quando aplicável."
		}, {
			kind:        "primitive", name: "abortedAt", type: "datetime"
			description: "Timestamp de transição para aborted, quando aplicável."
		}]

		handlesCommands: [
			"cmd-register-invoice-for-payment",
			"cmd-evaluate-pre-payment-guard",
			"cmd-initiate-bank-transfer",
			"cmd-confirm-settlement",
			"cmd-mark-defaulted",
			"cmd-abort-pre-settle",
			"cmd-resolve-prolonged-settling",
			"cmd-handle-dispute-resolution",
		]

		emitsEvents: [
			"evt-payment-state-changed",
			"evt-payment-settled",
			"evt-payment-obligation-defaulted",
			"evt-settlement-aborted",
			"evt-ledger-event-recorded",
			"evt-invoice-issued-received",
			"evt-invoice-cancelled-received",
			"evt-credit-eligibility-decided-received",
			"evt-bank-settlement-confirmed-received",
			"evt-dispute-resolved-received",
		]

		protectsInvariants: [
			"inv-payment-evidence-required",
			"inv-ledger-immutability",
			"inv-settled-requires-bkr-confirmation",
			"inv-post-settle-immutability",
			"inv-cash-availability-required-for-settling",
			"inv-commitment-id-preservation",
			"inv-bank-transfer-requires-supervision",
			"inv-financialization-atomicity",
		]

		usesValueObjects: [
			"vo-payment-id",
			"vo-payment-state",
			"vo-commitment-id",
			"vo-invoice-ref",
			"vo-money",
			"vo-ledger-event",
			"vo-settlement-rail",
			"vo-bank-transfer-ref",
			"vo-eligibility-decision",
			"vo-counterparty-pair",
			"vo-payment-failure-reason",
		]

		lifecycle: {
			initialState: "pending"
			states: ["pending", "eligible", "settling", "settled", "defaulted", "aborted"]
			transitions: [{
				from:               "pending"
				to:                 "eligible"
				triggeredByCommand: "cmd-evaluate-pre-payment-guard"
				emitsEvents: ["evt-payment-state-changed"]
				guards: ["inv-payment-evidence-required"]
				description: "PrePaymentGuard aprovado: InvoiceIssued observado + CreditEligibilityDecided positivo + cash availability confirmada via QueryCashAvailability (TCM)."
			}, {
				from:               "eligible"
				to:                 "settling"
				triggeredByCommand: "cmd-initiate-bank-transfer"
				emitsEvents: ["evt-payment-state-changed"]
				guards: ["inv-cash-availability-required-for-settling", "inv-bank-transfer-requires-supervision"]
				description: "FCE solicita movimento no rail bancário via InitiateBankTransfer (BKR). Janela settling se abre — pagamento ainda não é canonical settled."
			}, {
				from:               "settling"
				to:                 "settled"
				triggeredByCommand: "cmd-confirm-settlement"
				emitsEvents: ["evt-payment-state-changed", "evt-payment-settled", "evt-ledger-event-recorded"]
				guards: ["inv-settled-requires-bkr-confirmation"]
				description: "BankSettlementConfirmed observado; ledger event registrado; PaymentSettled publicado para REW, SCF, ATO, TCM. bd-settled-after-bkr materializado."
			}, {
				from:               "eligible"
				to:                 "defaulted"
				triggeredByCommand: "cmd-mark-defaulted"
				emitsEvents: ["evt-payment-state-changed", "evt-payment-obligation-defaulted", "evt-ledger-event-recorded"]
				description: "Timeout pós-elegibilidade sem progresso para settling (e.g., cash availability persistentemente indisponível em TCM dentro de janela aceitável)."
			}, {
				from:               "settling"
				to:                 "defaulted"
				triggeredByCommand: "cmd-mark-defaulted"
				emitsEvents: ["evt-payment-state-changed", "evt-payment-obligation-defaulted", "evt-ledger-event-recorded"]
				description: "Settling prolongado sem confirmação BKR escalado via cmd-resolve-prolonged-settling — rail considerado irrecuperável; movimento não foi confirmado fisicamente."
			}, {
				from:               "pending"
				to:                 "aborted"
				triggeredByCommand: "cmd-abort-pre-settle"
				emitsEvents: ["evt-payment-state-changed", "evt-settlement-aborted"]
				description: "InvoiceCancelled observado antes do PrePaymentGuard. Sem ledger event — não houve movimento."
			}, {
				from:               "eligible"
				to:                 "aborted"
				triggeredByCommand: "cmd-abort-pre-settle"
				emitsEvents: ["evt-payment-state-changed", "evt-settlement-aborted"]
				description: "InvoiceCancelled após gate aprovado mas antes de InitiateBankTransfer (pre-settle). Cash reservation (se aplicável) é liberada; sem ledger event."
			}]
		}

		rationale: """
			agg-payment é o consistency boundary central do FCE. Lifecycle exaustivo:
			pending → eligible → settling → settled (happy path) com branches terminais
			defaulted (falha operacional) e aborted (intencional pré-emissão de
			InitiateBankTransfer). settled/defaulted/aborted são estados terminais
			por design — settled por bd-post-settle-immutability (correção pós-settle
			é responsabilidade de DRC, não retroage no FCE); defaulted e aborted são
			branches terminais distintos do happy path com semântica clara para REW
			(default deteriora score) e audit (abort preserva evidência de intent
			sem movimento). 8 commands handled (incluindo cmd-handle-dispute-resolution
			e cmd-resolve-prolonged-settling que operam como routers internos — não
			disparam transição direta, despacham para cmd-abort-pre-settle /
			cmd-mark-defaulted / cmd-confirm-settlement conforme outcome humano ou
			da disputa). 7 transitions formalizando happy path + 2 branches default
			+ 2 branches abort (apenas pre-settle = pré-emissão de InitiateBankTransfer:
			pending e eligible; settling não tem branch abort porque dinheiro pode
			já estar no rail — correção vira responsabilidade de DRC via
			FinancialCompensationOrdered). 5 ACL events registrados em emitsEvents
			para satisfazer tq-dm-02 (mesmo trade-off documentado no cmt: semanticamente
			são produzidos pela camada ACL, mas o aggregate registra no seu event
			stream). PrePaymentGuard é gate interno do FCE — REW fornece input via
			evt-credit-eligibility-decided-received.
			"""
	}, {
		code:        "agg-financial-compensation"
		name:        "FinancialCompensation"
		description: "Aggregate root do lifecycle de EXECUÇÃO de compensação financeira já ordenada por DRC. Não decide mérito, causa, responsabilidade ou valor — todos esses atributos vêm imutáveis da ordem upstream. Lifecycle puramente financeiro (ordered → executing → recorded)."

		rootIdentity: {
			field: "compensationId"
			type: {kind: "value-object-ref", valueObjectRef: "vo-financial-compensation-id"}
		}

		fields: [{
			kind:        "domain-type", name: "compensationOrder", type: "CompensationOrder"
			description: "Ordem completa de DRC: amount, parties, motivo de origem, ref disputa. Imutável dentro do FCE (inv-compensation-respects-drc-decision)."
		}, {
			kind:        "value-object-ref", name: "commitmentId", valueObjectRef: "vo-commitment-id"
			description: "Preservado da ordem original — rastreabilidade ao compromisso (inv-commitment-id-preservation)."
		}, {
			kind: "value-object-ref", name: "currentState", valueObjectRef: "vo-compensation-state"
		}, {
			kind:        "value-object-ref", name: "bankTransferRef", valueObjectRef: "vo-bank-transfer-ref"
			description: "Populated em executing; fecha trilha BKR↔FCE da compensação."
		}, {
			kind:        "primitive", name: "orderedAt", type: "datetime"
			description: "Recebimento de FinancialCompensationOrdered (DRC)."
		}, {
			kind:        "primitive", name: "executingStartedAt", type: "datetime"
			description: "Emissão de InitiateBankTransfer (BKR)."
		}, {
			kind:        "primitive", name: "recordedAt", type: "datetime"
			description: "Confirmação BKR + ledger event registrado."
		}]

		handlesCommands: [
			"cmd-execute-financial-compensation",
			"cmd-confirm-compensation-settled",
		]

		emitsEvents: [
			"evt-compensation-state-changed",
			"evt-financial-compensation-recorded",
			"evt-ledger-event-recorded",
			"evt-financial-compensation-ordered-received",
			"evt-bank-settlement-confirmed-received",
		]

		protectsInvariants: [
			"inv-ledger-immutability",
			"inv-commitment-id-preservation",
			"inv-bank-transfer-requires-supervision",
			"inv-compensation-respects-drc-decision",
		]

		usesValueObjects: [
			"vo-financial-compensation-id",
			"vo-compensation-state",
			"vo-commitment-id",
			"vo-money",
			"vo-counterparty-pair",
			"vo-bank-transfer-ref",
			"vo-ledger-event",
		]

		lifecycle: {
			initialState: "ordered"
			states: ["ordered", "executing", "recorded"]
			transitions: [{
				from:               "ordered"
				to:                 "executing"
				triggeredByCommand: "cmd-execute-financial-compensation"
				emitsEvents: ["evt-compensation-state-changed"]
				guards: ["inv-bank-transfer-requires-supervision", "inv-compensation-respects-drc-decision"]
				description: "FCE solicita movimento no rail bancário com valores e partes determinados imutavelmente por DRC. Janela executing se abre — compensação ainda não é canonical recorded."
			}, {
				from:               "executing"
				to:                 "recorded"
				triggeredByCommand: "cmd-confirm-compensation-settled"
				emitsEvents: ["evt-compensation-state-changed", "evt-financial-compensation-recorded", "evt-ledger-event-recorded"]
				description: "BankSettlementConfirmed observado para a compensação; ledger event registrado preservando proveniência dispute-driven; lifecycle completo."
			}]
		}

		rationale: """
			agg-financial-compensation é consistency boundary separado de agg-payment
			por trigger e semântica distintos: compensações são ordenadas por DRC
			(não derivam do gate INV+REW+TCM normal) e operam fora do payment
			lifecycle. O lifecycle é deliberadamente restrito a 3 estados lineares
			(ordered → executing → recorded) sem branches de rejection, modificação
			ou hold — DRC já decidiu tudo upstream; FCE apenas executa o movimento
			financeiro e registra o fato no ledger. inv-compensation-respects-drc-decision
			formaliza a disciplina de boundary: agg-financial-compensation não revisa
			valor, partes ou mérito. Branches de failure (e.g., rail falha) ainda
			não modelados na Phase 0 deste BC — defer para sessão posterior quando
			evidência operacional revelar padrão (equivalente a
			cmd-resolve-prolonged-settling para o payment lifecycle teria que
			ser introduzido com supervisão explícita). 2 commands handled,
			2 transitions, 2 ACL events registrados em emitsEvents (mesma
			convenção de cmt para satisfazer tq-dm-02).
			"""
	}]

	// =============================================
	// POLICIES (automação event → command)
	// =============================================

	policies: [{
		code:             "pol-invoice-issued-registers-payment"
		name:             "Fatura Emitida Inicia Payment"
		description:      "Quando INV publica InvoiceIssued (observado via ACL como evt-invoice-issued-received), emite cmd-register-invoice-for-payment para criar payment em estado pending."
		triggeredByEvent: "evt-invoice-issued-received"
		issuesCommand:    "cmd-register-invoice-for-payment"
		rationale:        "Entrada canônica do payment lifecycle. ACL adapter traduz InvoiceIssued para a linguagem local; policy materializa o trigger interno. Sem guards — registration é determinística."
	}, {
		code:             "pol-eligibility-decided-evaluates-guard"
		name:             "Decisão de Risco Aciona PrePaymentGuard"
		description:      "Quando REW publica CreditEligibilityDecided positivo (observado via ACL), emite cmd-evaluate-pre-payment-guard para o payment correspondente. Resultado positivo do gate transiciona pending → eligible."
		triggeredByEvent: "evt-credit-eligibility-decided-received"
		issuesCommand:    "cmd-evaluate-pre-payment-guard"
		guards: ["inv-payment-evidence-required"]
		rationale: "REW fornece input (não o gate). Policy formaliza o trigger; aggregate executa o gate interno. Guard registra a invariant central como pré-condição auditável da automação."
	}, {
		code:             "pol-invoice-cancelled-aborts-pre-settle"
		name:             "Cancelamento de Fatura Aborta Pré-Settle"
		description:      "Quando INV publica InvoiceCancelled (observado via ACL), emite cmd-abort-pre-settle. Aggregate transiciona payment para aborted se estado é pending ou eligible; ignora sem transição e registra decisão de no-op auditável se estado é settling+ (dinheiro pode já estar no rail — DRC trata pós-emissão via FinancialCompensationOrdered)."
		triggeredByEvent: "evt-invoice-cancelled-received"
		issuesCommand:    "cmd-abort-pre-settle"
		rationale:        "Disciplina pre-settle = pré-emissão de InitiateBankTransfer. Policy dispara uniforme; aggregate enforce estado válido. Pós-settling, cancellation vira responsabilidade de DRC (bd-post-settle-immutability)."
	}, {
		code:             "pol-bank-settlement-confirmed-finalizes-payment"
		name:             "Confirmação BKR Finaliza Settlement"
		description:      "Quando BKR publica BankSettlementConfirmed (observado via ACL) para um bankTransferRef vinculado a payment em settling, emite cmd-confirm-settlement. Aggregate finaliza o lifecycle e publica PaymentSettled."
		triggeredByEvent: "evt-bank-settlement-confirmed-received"
		issuesCommand:    "cmd-confirm-settlement"
		guards: ["inv-settled-requires-bkr-confirmation"]
		rationale: "Discriminação payment vs compensation acontece via bankTransferRef no aggregate, não na policy. agg-payment aceita apenas se possui o bankTransferRef em estado settling; caso contrário no-op auditável (confirmation registrada como observada mas não consumida por este aggregate)."
	}, {
		code:             "pol-bank-settlement-confirmed-finalizes-compensation"
		name:             "Confirmação BKR Finaliza Compensação"
		description:      "Quando BKR publica BankSettlementConfirmed (observado via ACL) para um bankTransferRef vinculado a compensation em executing, emite cmd-confirm-compensation-settled. Aggregate finaliza o lifecycle."
		triggeredByEvent: "evt-bank-settlement-confirmed-received"
		issuesCommand:    "cmd-confirm-compensation-settled"
		rationale:        "Par paralelo a pol-bank-settlement-confirmed-finalizes-payment. Mesmo evento ACL dispara as duas policies; cada aggregate aceita apenas se possui o bankTransferRef. Routing implícito via ownership do bankTransferRef. Confirmation para o aggregate não-dono é no-op auditável."
	}, {
		code:             "pol-compensation-ordered-initiates"
		name:             "Ordem de Compensação Inicia Execução"
		description:      "Quando DRC publica FinancialCompensationOrdered (observado via ACL), emite cmd-execute-financial-compensation. Cria agg-financial-compensation em estado ordered → executing."
		triggeredByEvent: "evt-financial-compensation-ordered-received"
		issuesCommand:    "cmd-execute-financial-compensation"
		guards: ["inv-compensation-respects-drc-decision"]
		rationale: "Trigger da execução de compensações dispute-driven. Guard registra a disciplina de boundary: FCE não revisa a ordem; apenas executa."
	}, {
		code:             "pol-dispute-resolved-routes"
		name:             "Disputa Resolvida Roteia para Aggregate"
		description:      "Quando DRC publica DisputeResolved (observado via ACL), emite cmd-handle-dispute-resolution para o aggregate decidir routing (abort se pre-settle, no-op auditável se settling/settled — pós-settle DRC ordena FinancialCompensationOrdered separadamente)."
		triggeredByEvent: "evt-dispute-resolved-received"
		issuesCommand:    "cmd-handle-dispute-resolution"
		rationale:        "Análogo a cmt pol-dispute-resolved-routes. Policy emite command único; routing multi-outcome vive no aggregate porque ele é o consistency boundary que preserva a decisão final."
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-financial-ledger"
		name:        "Financial Ledger"
		description: "Projeção que materializa o ledger canônico do FCE (bd-ledger-as-sot). Append-only view de todos os movimentos financeiros — settlements, default markers, compensações — vinculados a CommitmentId e evidência originária. Fonte de reconciliação para ATO, TCM e SCF."

		consumesEvents: [
			"evt-ledger-event-recorded",
		]

		queryCapabilities: [{
			code:        "qry-ledger-by-commitment"
			description: "Retorna todos os ledger events vinculados a um CommitmentId — view canônica do trace financeiro end-to-end para o compromisso."
			rationale:   "Interface primária para auditoria cross-BC (ATO, sh-04 regulador) e para reconciliação SCF de antecipações."
		}, {
			code:        "qry-ledger-by-time-range"
			description: "Retorna ledger events dentro de uma janela temporal — habilita reporting prudencial Bacen e batch reconciliation ATO."
			rationale:   "Reporting é projeção sobre o ledger, não atividade separada (sh-04 impactDescription do canvas)."
		}]

		rationale: "Materializa bd-ledger-as-sot — ATO/TCM/SCF reconciliam contra esta projection, não contra extratos bancários paralelos. Construída por append a partir de evt-ledger-event-recorded; imutabilidade preservada estruturalmente (sem command de update/delete)."
	}, {
		code:        "prj-payment-state-view"
		name:        "Payment State View"
		description: "Projeção que materializa estado corrente do payment lifecycle para consulta por SCF. Suporta a query-surface QueryPaymentSettlementStatus declarada no canvas."

		consumesEvents: [
			"evt-payment-state-changed",
			"evt-payment-settled",
			"evt-payment-obligation-defaulted",
			"evt-settlement-aborted",
		]

		queryCapabilities: [{
			code:        "qry-payment-settlement-status"
			description: "Retorna PaymentSettlementStatus (pending, eligible, settling, settled, defaulted, aborted) por PaymentId ou CommitmentId. Interface canvas-declarada para SCF reconciliar operações de antecipação."
			rationale:   "Canvas query-surface QueryPaymentSettlementStatus consumed by SCF. Complementa o evento PaymentSettled com leitura point-in-time."
		}]

		rationale: "Necessária porque agg-payment é event-sourced para escrita; leitura externa via projection evita reconstrução do event log. Distinção settling vs settled (bd-settled-after-bkr) é preservada na projection."
	}, {
		code:        "prj-compensation-state-view"
		name:        "Compensation State View"
		description: "Projeção que materializa estado corrente das compensações financeiras. Suporta consulta interna por DRC sobre execução de FinancialCompensationOrdered."

		consumesEvents: [
			"evt-compensation-state-changed",
			"evt-financial-compensation-recorded",
		]

		queryCapabilities: [{
			code:        "qry-compensation-state"
			description: "Retorna CompensationState (ordered, executing, recorded) por CompensationId. Permite DRC verificar status de compensações ordenadas."
			rationale:   "Canvas não declara query-surface explícita para compensation status, mas a projection existe para audit e troubleshooting interno. Se DRC futuramente precisar query síncrono, formalizar como query-surface no canvas via update separado."
		}]

		rationale: "Paralela a prj-payment-state-view com lifecycle simplificado (3 estados). Não é exposta via canvas query-surface — uso interno por enquanto."
	}]

	rationale: """
		Domain model do FCE com 2 aggregates como consistency boundaries: agg-payment
		(payment lifecycle desde InvoiceIssued observado até settled/defaulted/aborted)
		e agg-financial-compensation (execução de compensações ordenadas por DRC, lifecycle
		puramente financeiro sem decisão de mérito). Behavior-first: 13 events (2 published —
		PaymentSettled, PaymentObligationDefaulted; 6 observados via ACL — invoice,
		eligibility, bank settlement, dispute, compensation; 5 internos puros —
		payment-state-changed, compensation-state-changed, ledger, settlement-aborted,
		compensation-recorded), 10 commands (todos internos: FCE é cross-context
		event-driven), 9 invariants (4 materializando os BDs do canvas + 5 operacionais),
		13 value objects. agg-payment lifecycle: 6 estados (pending, eligible, settling,
		settled, defaulted, aborted) com 7 transitions — happy path linear pending → eligible
		→ settling → settled, 2 branches defaulted (timeout eligible ou settling), 2 branches
		aborted (pré-emissão de InitiateBankTransfer — pending ou eligible apenas; settling
		só sai para settled/defaulted porque dinheiro pode já estar no rail).
		agg-financial-compensation lifecycle: 3 estados (ordered, executing, recorded) com
		2 transitions linear. 7 policies conectam eventos ACL a commands; routing por
		bankTransferRef (payment vs compensation) acontece via ownership no aggregate.
		3 projections (prj-financial-ledger materializa bd-ledger-as-sot consumindo
		evt-ledger-event-recorded; prj-payment-state-view suporta canvas QueryPaymentSettlementStatus;
		prj-compensation-state-view para audit interno). PrePaymentGuard é gate interno do
		FCE — REW fornece input via CreditEligibilityDecided. inv-compensation-respects-drc-decision
		formaliza disciplina de boundary: FCE não revisa compensações. Cross-BC state
		dependency declarada em inv-payment-evidence-required (TCM via QueryCashAvailability).
		Gap deferido Phase 0: wiring concreto de inv-financialization-atomicity (policy/service
		SCF) aguarda evidência operacional; branches de failure em agg-financial-compensation
		aguardam padrão observado.
		"""
}
