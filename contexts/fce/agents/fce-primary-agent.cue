package fce

// fce-primary-agent.cue — Agent Spec: FCE Primary Agent.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Agente primário do FCE. Operador primário do BC — executa o payment
// lifecycle (registro de fatura → PrePaymentGuard → InitiateBankTransfer
// → settlement) e o compensation lifecycle ordenado por DRC, sob gates
// determinísticos. Não decide risco (REW), não decide disponibilidade
// financeira (TCM), não arbitra disputa (DRC), não origina compensação
// (DRC), não produz dados contábeis derivados (ATO).
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária): autonomyLevel por ação,
//   escalation conditions, observability contract
// - lens-security-trust-infrastructure (secundária): inputTrustLevel
//   para ACL ingestion + anti-drift de aprovação→execução via payload-hash
// - lens-regulatory-compliance-as-architecture (terciária): audit trail
//   regulatory-grade com 16 fields para reconstituição completa
//
// Fronteira spec ↔ governance (ADR-037):
// - Este spec declara QUANDO escalar, QUAL nível de autonomia e QUAIS
//   constraints obedecer.
// - O governance envelope (fce-primary-agent.governance.cue) declara
//   COMO escalar (canal, SLA), calibração dinâmica, high-value-threshold
//   e blast radius limits.
//
// Forward reference: governanceRef aponta para fce-primary-agent —
// arquivo governance será criado em sequência. Runner reportará
// tq-ag-09 fail até criação do envelope.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

agentSpec: artifact_schemas.#AgentSpec & {
	code: "agt-fce-primary"
	name: "FCE Primary Agent"
	description: """
		Agente primário do Financial Commitment Execution. Operador primário do BC —
		executa o payment lifecycle (registro de fatura → PrePaymentGuard →
		InitiateBankTransfer → settlement) e o compensation lifecycle ordenado por
		DRC, sob gates determinísticos. Não decide risco (input vem de REW), não
		decide disponibilidade financeira (consulta TCM), não arbitra disputa (input
		vem de DRC), não origina compensação (executa apenas ordens upstream), não
		produz dados contábeis derivados (ATO consome conformist downstream).
		Decisões com movimento de dinheiro irreversível (cmd-initiate-bank-transfer,
		cmd-execute-financial-compensation) requerem supervisão humana via
		mech-agent-gate com anti-drift via payload-hash. Decisões puramente
		determinísticas (PrePaymentGuard evaluation, ledger event recording após
		BKR ACK, routing técnico por BankTransferRef ownership) executam autônomas
		com log regulatório.
		"""

	boundedContextRef: "fce"
	role:              "domain-agent"
	governanceRef:     "fce-primary-agent"

	// =============================================
	// ESCOPO OPERACIONAL
	// =============================================
	//
	// Cobertura completa do domain-model FCE:
	// 2/2 aggregates, 10/10 commands, 13/13 events, 9/9 invariants, 3/3 projections.
	// FCE primary é operador único de todo o BC nesta fase.

	operationalScope: {
		aggregates: [
			"agg-payment",
			"agg-financial-compensation",
		]

		commands: [
			"cmd-register-invoice-for-payment",
			"cmd-evaluate-pre-payment-guard",
			"cmd-initiate-bank-transfer",
			"cmd-confirm-settlement",
			"cmd-mark-defaulted",
			"cmd-abort-pre-settle",
			"cmd-resolve-prolonged-settling",
			"cmd-handle-dispute-resolution",
			"cmd-execute-financial-compensation",
			"cmd-confirm-compensation-settled",
		]

		events: [
			// Published cross-BC (2)
			"evt-payment-settled",
			"evt-payment-obligation-defaulted",
			// ACL-observed (6)
			"evt-invoice-issued-received",
			"evt-invoice-cancelled-received",
			"evt-credit-eligibility-decided-received",
			"evt-bank-settlement-confirmed-received",
			"evt-dispute-resolved-received",
			"evt-financial-compensation-ordered-received",
			// Internal pure (5)
			"evt-payment-state-changed",
			"evt-compensation-state-changed",
			"evt-ledger-event-recorded",
			"evt-settlement-aborted",
			"evt-financial-compensation-recorded",
		]

		invariants: [
			"inv-payment-evidence-required",
			"inv-ledger-immutability",
			"inv-settled-requires-bkr-confirmation",
			"inv-post-settle-immutability",
			"inv-cash-availability-required-for-settling",
			"inv-commitment-id-preservation",
			"inv-bank-transfer-requires-supervision",
			"inv-financialization-atomicity",
			"inv-compensation-respects-drc-decision",
		]

		projections: [
			"prj-financial-ledger",
			"prj-payment-state-view",
			"prj-compensation-state-view",
		]
	}

	// =============================================
	// AÇÕES (23 actions)
	// =============================================
	//
	// Distribuição:
	// - 5 propose-and-wait (2 irreversíveis bank-transfer + 1 mark-default + 2 routers humano)
	// - 18 execute-and-log (1 validation gate + 1 routing técnico + 4 internal det. + 3 execute-approved + 6 observations + 3 queries)
	//
	// Por category:
	// - 2 validation (gate determinístico + routing técnico)
	// - 12 mutation
	// - 6 observation (ACL ingestion)
	// - 3 query
	//
	// Padrão decision-vs-execution split em mutações financeiras irreversíveis:
	// par propose (recommendation, sem mutação) + execute-approved
	// (mutation, requer approval-id + payload-hash match). Anti-drift via hash
	// garante que aprovação humana não pode ser desviada por modificação do
	// payload entre approve e execute.

	actions: [{
		// ----- #1 — Validation gate determinístico -----
		code:            "act-evaluate-pre-payment-guard"
		name:            "Avaliar PrePaymentGuard"
		description:     "Avalia se o payment pode avançar para eligible combinando 3 inputs determinísticos: (a) InvoiceIssued válida observada via act-observe-invoice-issued para este PaymentId; (b) CreditEligibilityDecided positivo observado via act-observe-credit-eligibility-decided para o CommitmentId originário; (c) cash availability confirmada via consulta sync a TCM (QueryCashAvailability — FCE consulta, não cacheia, não override). Gate determinístico interno do FCE; REW provê input, não decide; TCM provê input, não decide."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-evaluate-pre-payment-guard",
			"inv-payment-evidence-required",
			"inv-cash-availability-required-for-settling",
			"evt-payment-state-changed",
			"agg-payment",
		]
		preconditions: [
			"Payment em estado pending",
			"evt-invoice-issued-received já observada e registrada para este PaymentId",
			"evt-credit-eligibility-decided-received já observada e registrada para o CommitmentId originário",
		]
		postconditions: [
			"Gate satisfeito (3 inputs presentes e positivos) → transição pending → eligible registrada via evt-payment-state-changed",
			"Gate insatisfeito → payment permanece em pending; decisão registrada com inputs faltantes em audit trail",
		]
	}, {
		// ----- #2 — Propose initiate bank transfer (par com #3) -----
		code:            "act-propose-initiate-bank-transfer"
		name:            "Propor Emissão de Transferência Bancária"
		description:     "Analisa payment em estado eligible + cash availability re-verificada via TCM + escolha de rail (PIX/TED/SWIFT) e prepara transfer request draft. Output = recommendation com amount + parties + rail + rationale (sem BankTransferRef — esta nasce em BKR após registro do command). Não emite cmd-initiate-bank-transfer; aguarda approval-id de humano via mech-agent-gate. Não materializa nenhuma transição."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-initiate-bank-transfer",
			"inv-bank-transfer-requires-supervision",
			"inv-cash-availability-required-for-settling",
			"agg-payment",
		]
		preconditions: [
			"Payment em estado eligible",
			"Cash availability TCM re-confirmada (consulta sync mais recente que a do guard; sem cache)",
		]
		postconditions: [
			"Recommendation produzida com transfer request draft + rail + rationale; payload-hash registrado",
			"Audit trail contém recommendation payload + rationale; nenhuma transição materializada",
			"Aguarda approval-id de humano via mech-agent-gate",
		]
	}, {
		// ----- #3 — Execute approved bank transfer (par com #2) -----
		code:            "act-execute-approved-bank-transfer"
		name:            "Executar Transferência Bancária Aprovada"
		description:     "Após approval-id de humano registrado para recommendation produzida por act-propose-initiate-bank-transfer, emite cmd-initiate-bank-transfer a BKR. Payment transita eligible → settling; BKR registra a transferência e retorna BankTransferRef que é vinculado ao payment. Janela settling abre — dinheiro pode estar em trânsito no rail. Sem decisão semântica: execução do command corresponde 1:1 ao payload da recommendation aprovada (payload-hash match obrigatório). Per-action override: unclassifiable-anomaly se payload-hash mismatch detectado."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-initiate-bank-transfer",
			"inv-bank-transfer-requires-supervision",
			"evt-payment-state-changed",
			"agg-payment",
		]
		preconditions: [
			"Recommendation aprovada por humano via mech-agent-gate (approval-id presente)",
			"Payload de execução é byte-idêntico ao payload da recommendation aprovada (payload-hash match)",
			"Payment ainda em estado eligible (sem transição intermediária que invalide a recommendation)",
		]
		postconditions: [
			"cmd-initiate-bank-transfer emitido a BKR com payload da recommendation aprovada",
			"Payment transita eligible → settling",
			"BankTransferRef retornado por BKR é vinculado ao payment e registrado",
			"Audit trail contém: approval-id, payload-hash, BankTransferRef retornado",
		]
	}, {
		// ----- #4 — Propose execute financial compensation (par com #5) -----
		code:            "act-propose-execute-financial-compensation"
		name:            "Propor Execução de Compensação Financeira"
		description:     "Após observação de evt-financial-compensation-ordered-received via act-observe-financial-compensation-ordered, analisa ordem DRC e prepara recommendation de execução. Output = recommendation com amount + parties + rationale byte-idênticos ao payload DRC originário (FCE may execute compensation ordered by DRC, but MUST NOT originate compensation, calculate compensation, or reinterpret DRC decision). Não emite command; aguarda approval-id via mech-agent-gate. Não cria aggregate ainda — criação + transição ordered → executing materializa em #5."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-execute-financial-compensation",
			"inv-bank-transfer-requires-supervision",
			"inv-compensation-respects-drc-decision",
			"agg-financial-compensation",
		]
		preconditions: [
			"evt-financial-compensation-ordered-received observado via act-observe-financial-compensation-ordered",
			"Payload DRC validado: amount, parties, rationale presentes",
		]
		postconditions: [
			"Recommendation produzida preservando amount/parties/rationale byte-idênticos ao payload DRC; payload-hash registrado",
			"Audit trail contém recommendation payload + ref ao event DRC originário; nenhum aggregate criado ainda",
			"Aguarda approval-id de humano via mech-agent-gate",
		]
	}, {
		// ----- #5 — Execute approved financial compensation (par com #4) -----
		code:            "act-execute-approved-financial-compensation"
		name:            "Executar Compensação Financeira Aprovada"
		description:     "Após approval-id de humano + payload-hash match com recommendation aprovada de act-propose-execute-financial-compensation, cria FinancialCompensation e emite cmd-execute-financial-compensation a BKR. Aggregate transita (criação) → ordered → executing em sequência atômica. BankTransferRef retornado por BKR é vinculado à compensation. Sem decisão semântica: amount/parties/rationale preservados imutáveis do payload DRC originário. Per-action override: unclassifiable-anomaly se payload-hash mismatch detectado."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-execute-financial-compensation",
			"inv-bank-transfer-requires-supervision",
			"inv-compensation-respects-drc-decision",
			"evt-compensation-state-changed",
			"agg-financial-compensation",
		]
		preconditions: [
			"Recommendation aprovada por humano via mech-agent-gate (approval-id presente)",
			"Payload de execução byte-idêntico ao payload da recommendation aprovada (payload-hash match)",
			"Sem FinancialCompensation já criada para esta ordem DRC (idempotência)",
		]
		postconditions: [
			"FinancialCompensation criada com amount/parties/rationale preservados do payload DRC originário",
			"Compensation transita (criação) → ordered → executing",
			"cmd-execute-financial-compensation emitido a BKR; BankTransferRef vinculado",
			"Audit trail contém: approval-id, payload-hash, ref ao FinancialCompensationOrdered originário, BankTransferRef retornado",
		]
	}, {
		// ----- #6 — Register payment from invoice (internal deterministic) -----
		code:            "act-register-payment-from-invoice"
		name:            "Registrar Pagamento a partir de Fatura"
		description:     "Cria payment em estado pending a partir de evt-invoice-issued-received observada via act-observe-invoice-issued. Gera PaymentId local ao FCE preservando CommitmentId originário do CMT. Sem movimento financeiro — apenas criação de lifecycle entity para subsequent evaluation por PrePaymentGuard."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-register-invoice-for-payment",
			"inv-commitment-id-preservation",
			"evt-payment-state-changed",
			"agg-payment",
		]
		preconditions: [
			"evt-invoice-issued-received observada via act-observe-invoice-issued",
			"Nenhum payment já criado para esta combinação (InvoiceRef, CommitmentId) — idempotência",
		]
		postconditions: [
			"Payment criado em estado pending com PaymentId local",
			"CommitmentId originário preservado para rastreabilidade cross-BC",
		]
	}, {
		// ----- #7 — Abort payment pre-emission (internal deterministic, condição rígida) -----
		code:            "act-abort-payment-pre-emission"
		name:            "Abortar Pagamento Pré-Emissão"
		description:     "Sob condição rígida: ao observar evt-invoice-cancelled-received via act-observe-invoice-cancelled E payment em estado pending OR eligible (estritamente pré-emissão de InitiateBankTransfer), transita para aborted. Sem movimento financeiro envolvido. Qualquer cancelamento fora deste canal (não via INV ACL) ou fora deste estado (settling, settled, defaulted, aborted) NÃO ativa esta action — vira no-op auditável via sig-routing-no-op-recorded; correção pós-emissão exige FinancialCompensationOrdered upstream via DRC."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-abort-pre-settle",
			"evt-settlement-aborted",
			"evt-payment-state-changed",
			"agg-payment",
		]
		preconditions: [
			"evt-invoice-cancelled-received observada via act-observe-invoice-cancelled",
			"Payment em estado pending OR eligible (pré-emissão estrita)",
			"Nenhum cmd-initiate-bank-transfer emitido para este payment",
		]
		postconditions: [
			"Payment transita pending|eligible → aborted",
			"evt-settlement-aborted emitido (interno)",
			"Sem ledger event (não houve movimento financeiro)",
		]
	}, {
		// ----- #8 — Record payment settlement (publish PaymentSettled) -----
		code:            "act-record-payment-settlement"
		name:            "Registrar Liquidação de Pagamento"
		description:     "Após act-route-bank-settlement-by-ownership resolver BankTransferRef X para um payment em settling, emite cmd-confirm-settlement. Materializa transição settling → settled + registra ledger event (tipo: settlement) + publica evt-payment-settled para REW, SCF, ATO, TCM. Inteiramente determinística pós-routing: input already ACL-observed and ownership-routed; still causally external (origem causal é BKR ACK)."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"cmd-confirm-settlement",
			"inv-settled-requires-bkr-confirmation",
			"inv-ledger-immutability",
			"inv-commitment-id-preservation",
			"evt-payment-settled",
			"evt-payment-state-changed",
			"evt-ledger-event-recorded",
			"agg-payment",
		]
		preconditions: [
			"act-route-bank-settlement-by-ownership resolveu BankTransferRef para este payment",
			"Payment em estado settling",
			"BankTransferRef do BKR ACK confere com BankTransferRef registrado no payment",
		]
		postconditions: [
			"Payment transita settling → settled",
			"Ledger event (tipo: settlement) registrado em prj-financial-ledger com CommitmentId preservado",
			"evt-payment-settled publicado para REW, SCF, ATO, TCM",
		]
	}, {
		// ----- #9 — Record compensation settlement (interno only) -----
		code:            "act-record-compensation-settlement"
		name:            "Registrar Liquidação de Compensação"
		description:     "Após act-route-bank-settlement-by-ownership resolver BankTransferRef X para uma compensation em executing, emite cmd-confirm-compensation-settled. Materializa transição executing → recorded + registra ledger event (tipo: compensation, com proveniência dispute-driven preservada via referência ao FinancialCompensationOrdered originário) + emite evt-financial-compensation-recorded (interno; sem publish cross-BC). Input already ACL-observed and ownership-routed; still causally external (origem causal é BKR ACK)."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"cmd-confirm-compensation-settled",
			"inv-ledger-immutability",
			"inv-compensation-respects-drc-decision",
			"inv-commitment-id-preservation",
			"evt-financial-compensation-recorded",
			"evt-compensation-state-changed",
			"evt-ledger-event-recorded",
			"agg-financial-compensation",
		]
		preconditions: [
			"act-route-bank-settlement-by-ownership resolveu BankTransferRef para esta compensation",
			"Compensation em estado executing",
			"BankTransferRef do BKR ACK confere com BankTransferRef registrado na compensation",
		]
		postconditions: [
			"Compensation transita executing → recorded",
			"Ledger event (tipo: compensation) registrado em prj-financial-ledger preservando proveniência dispute-driven",
			"evt-financial-compensation-recorded emitido (interno)",
		]
	}, {
		// ----- #10 — Propose mark default (par com #11) -----
		code:            "act-propose-mark-default"
		name:            "Propor Marcação de Default"
		description:     "Após análise de timeout em settling > threshold do governance envelope + sinais BKR de falha persistente, recomenda transição settling → defaulted. Output = recommendation com evidência operacional coletada (sinais BKR, timestamps, ausência de ACK). Default afeta REW score — supervisão obrigatória. Não emite command; aguarda approval-id via mech-agent-gate."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-mark-defaulted",
			"agg-payment",
		]
		preconditions: [
			"Payment em estado settling",
			"Tempo decorrido em settling > threshold do envelope",
			"Sinais BKR consultados (sem ACK persistente, falha de rail confirmada)",
		]
		postconditions: [
			"Recommendation produzida com evidência operacional + rationale; payload-hash registrado",
			"Audit trail contém recommendation; nenhuma transição materializada",
			"Aguarda approval-id via mech-agent-gate",
		]
	}, {
		// ----- #11 — Execute approved mark default (par com #10) -----
		code:            "act-execute-approved-mark-default"
		name:            "Executar Marcação de Default Aprovada"
		description:     "Após approval-id de humano + payload-hash match com recommendation de act-propose-mark-default, emite cmd-mark-defaulted. Materializa transição settling → defaulted + registra ledger event (tipo: default-marker) + publica evt-payment-obligation-defaulted para REW. Per-action override: suspicious-input adicional — qualquer suspeita de approval forjado ou recommendation manipulada escala imediatamente em vez de execute (default deteriora reputação financeira)."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-mark-defaulted",
			"inv-ledger-immutability",
			"inv-commitment-id-preservation",
			"evt-payment-obligation-defaulted",
			"evt-payment-state-changed",
			"evt-ledger-event-recorded",
			"agg-payment",
		]
		preconditions: [
			"Recommendation aprovada por humano via mech-agent-gate (approval-id presente)",
			"Payload de execução byte-idêntico ao payload da recommendation aprovada (payload-hash match)",
			"Payment ainda em estado settling",
		]
		postconditions: [
			"Payment transita settling → defaulted",
			"Ledger event (tipo: default-marker) registrado em prj-financial-ledger com CommitmentId preservado",
			"evt-payment-obligation-defaulted publicado para REW",
		]
	}, {
		// ----- #12 — Router humano: dispute resolution -----
		code:            "act-route-dispute-resolution"
		name:            "Rotear Resolução de Disputa"
		description:     "Analisa evt-dispute-resolved-received observado de DRC + estado atual do payment afetado + decisão DRC carregada no payload, e recomenda rota: (a) manter bloqueado aguardando ordem específica de DRC; (b) acionar act-abort-payment-pre-emission se aplicável (payment ainda pré-emissão); (c) acionar par propose+execute mark-default se DRC determinou default; (d) aguardar FinancialCompensationOrdered da DRC para corrigir movimentos já realizados. Output = recommendation. Não executa transição própria — humano aprova rota; terminal action correspondente é triggered conforme aprovação. FCE NÃO reinterpreta decisão DRC."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-handle-dispute-resolution",
			"evt-dispute-resolved-received",
			"agg-payment",
		]
		preconditions: [
			"evt-dispute-resolved-received observado via act-observe-dispute-resolved",
			"Payment identificado e estado consultado",
		]
		postconditions: [
			"Recommendation produzida com rota proposta + rationale + ref a decisão DRC originária",
			"Humano aprova → terminal action correspondente é triggered (não por este action)",
			"Sem transição direta materializada por este action (router puro per Discipline 6)",
		]
	}, {
		// ----- #13 — Router humano: prolonged settling -----
		code:            "act-resolve-prolonged-settling"
		name:            "Resolver Settling Prolongado"
		description:     "Analisa payment em settling com tempo decorrido > threshold (configurável via governance envelope) + sinais BKR disponíveis (status de transferência via canais BKR side) e recomenda rota: (a) continuar aguardando ACK (se sinais indicam transferência em trânsito normal); (b) retry operacional via canais BKR; (c) acionar par propose+execute mark-default (se sinais indicam falha persistente). Nunca recomenda act-record-payment-settlement sem BKR ACK observado — settled requer confirmação BKR (Discipline 3). Output = recommendation. Sem transição própria — humano aprova; terminal action correspondente é triggered."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-resolve-prolonged-settling",
			"agg-payment",
		]
		preconditions: [
			"Payment em settling com tempo > threshold do envelope",
			"Sinais BKR consultados (status da transferência via canal apropriado)",
		]
		postconditions: [
			"Recommendation produzida com rota proposta + rationale + evidência BKR coletada",
			"Sem transição direta materializada (router puro per Discipline 6)",
			"Rota 'resolver settled' nunca é recomendada sem evt-bank-settlement-confirmed-received observado",
		]
	}, {
		// ----- #14 — Router técnico mecânico (validation routing) -----
		code:            "act-route-bank-settlement-by-ownership"
		name:            "Rotear Confirmação BKR por Ownership"
		description:     "Routing técnico determinístico: ao receber evt-bank-settlement-confirmed-received com BankTransferRef X (observado via act-observe-bank-settlement-confirmed), resolve ownership por lookup: (a) X pertence a algum agg-payment em settling → dispatch act-record-payment-settlement; (b) X pertence a algum agg-financial-compensation em executing → dispatch act-record-compensation-settlement; (c) X não pertence a nenhum aggregate (no-owner) → emite sig-routing-no-op-recorded com payload incluindo bank-transfer-ref e ownership-resolution=no-owner. Sem julgamento semântico: validation determinística por ref. Categoria validation porque NÃO materializa mutation — apenas resolve rota; mutations reais ficam nas dispatched actions."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"evt-bank-settlement-confirmed-received",
			"agg-payment",
			"agg-financial-compensation",
		]
		preconditions: [
			"act-observe-bank-settlement-confirmed registrou o evento",
			"BankTransferRef extraído do payload",
		]
		postconditions: [
			"Match em payment → act-record-payment-settlement dispatchado",
			"Match em compensation → act-record-compensation-settlement dispatchado",
			"Sem match → no-op auditável; sig-routing-no-op-recorded emitido com ownership-resolution=no-owner",
		]
	}, {
		// ----- #15 — Observation: InvoiceIssued (INV) -----
		code:            "act-observe-invoice-issued"
		name:            "Observar InvoiceIssued de INV"
		description:     "Ingestão ACL de evt-invoice-issued-received de INV. Registra evento observado em audit; aciona chain downstream via pol-invoice-issued-registers-payment → act-register-payment-from-invoice (sem mutação direta neste action). Observation per ADR-089: trigger independence — sem invocação explícita."
		category:        "observation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"evt-invoice-issued-received",
			"agg-payment",
		]
		preconditions: [
			"evt-invoice-issued-received chegou via canal ACL definido",
			"Payload conforma a schema declarado",
		]
		postconditions: [
			"Evento observado registrado em audit",
			"sig-acl-event-observed emitido com source-bc=inv",
			"Downstream chain triggered via pol-invoice-issued-registers-payment; sem mutação direta materializada",
		]
	}, {
		// ----- #16 — Observation: InvoiceCancelled (INV) -----
		code:            "act-observe-invoice-cancelled"
		name:            "Observar InvoiceCancelled de INV"
		description:     "Ingestão ACL de evt-invoice-cancelled-received de INV. Registra evento observado em audit; aciona chain downstream via pol-invoice-cancelled-aborts-pre-settle. Filtro de pré-emissão estrita vive na action terminal act-abort-payment-pre-emission (#7), não nesta observation — esta apenas observa e propaga via policy. Observation per ADR-089."
		category:        "observation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"evt-invoice-cancelled-received",
			"agg-payment",
		]
		preconditions: [
			"evt-invoice-cancelled-received chegou via canal ACL definido",
			"Payload conforma a schema declarado",
		]
		postconditions: [
			"Evento observado registrado em audit",
			"sig-acl-event-observed emitido com source-bc=inv",
			"Downstream chain triggered via pol-invoice-cancelled-aborts-pre-settle; ação terminal filtra por pré-emissão",
		]
	}, {
		// ----- #17 — Observation: CreditEligibilityDecided (REW) -----
		code:            "act-observe-credit-eligibility-decided"
		name:            "Observar CreditEligibilityDecided de REW"
		description:     "Ingestão ACL de evt-credit-eligibility-decided-received de REW. Registra evento observado em audit; aciona chain downstream via pol-eligibility-decided-evaluates-guard → act-evaluate-pre-payment-guard. REW provê input; FCE possui o gate. Observation per ADR-089."
		category:        "observation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"evt-credit-eligibility-decided-received",
			"agg-payment",
		]
		preconditions: [
			"evt-credit-eligibility-decided-received chegou via canal ACL definido",
			"Payload conforma a schema declarado",
		]
		postconditions: [
			"Evento observado registrado em audit",
			"sig-acl-event-observed emitido com source-bc=rew",
			"Downstream chain triggered via pol-eligibility-decided-evaluates-guard; sem mutação direta materializada",
		]
	}, {
		// ----- #18 — Observation: BankSettlementConfirmed (BKR) -----
		code:            "act-observe-bank-settlement-confirmed"
		name:            "Observar BankSettlementConfirmed de BKR"
		description:     "Ingestão ACL de evt-bank-settlement-confirmed-received de BKR. Registra evento observado em audit; aciona chain downstream via pol-bank-settlement-confirmed-finalizes-payment + pol-bank-settlement-confirmed-finalizes-compensation → act-route-bank-settlement-by-ownership. Per-action override: unclassifiable-anomaly + suspicious-input adicionais — BKR ACK para BankTransferRef no-owner ou padrão repetido sugere ataque ou misconfiguração crítica. Observation per ADR-089."
		category:        "observation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"evt-bank-settlement-confirmed-received",
			"agg-payment",
			"agg-financial-compensation",
		]
		preconditions: [
			"evt-bank-settlement-confirmed-received chegou via canal ACL definido",
			"Payload conforma a schema declarado",
		]
		postconditions: [
			"Evento observado registrado em audit",
			"sig-acl-event-observed emitido com source-bc=bkr",
			"Downstream chain triggered via policies de finalização; routing técnico em act-route-bank-settlement-by-ownership",
		]
	}, {
		// ----- #19 — Observation: DisputeResolved (DRC) -----
		code:            "act-observe-dispute-resolved"
		name:            "Observar DisputeResolved de DRC"
		description:     "Ingestão ACL de evt-dispute-resolved-received de DRC. Registra evento observado em audit; aciona chain downstream via pol-dispute-resolved-routes → act-route-dispute-resolution. DRC é autoridade de mérito de disputa; FCE NÃO reinterpreta. Observation per ADR-089."
		category:        "observation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"evt-dispute-resolved-received",
			"agg-payment",
		]
		preconditions: [
			"evt-dispute-resolved-received chegou via canal ACL definido",
			"Payload conforma a schema declarado",
		]
		postconditions: [
			"Evento observado registrado em audit",
			"sig-acl-event-observed emitido com source-bc=drc",
			"Downstream chain triggered via pol-dispute-resolved-routes; routing humano em act-route-dispute-resolution",
		]
	}, {
		// ----- #20 — Observation: FinancialCompensationOrdered (DRC) -----
		code:            "act-observe-financial-compensation-ordered"
		name:            "Observar FinancialCompensationOrdered de DRC"
		description:     "Ingestão ACL de evt-financial-compensation-ordered-received de DRC. Registra evento observado em audit; aciona chain downstream via pol-compensation-ordered-initiates → act-propose-execute-financial-compensation. FCE may execute compensation ordered by DRC, but MUST NOT originate compensation, calculate compensation, or reinterpret DRC decision — observation apenas observa; preservação imutável do payload ocorre nas actions #4 e #5. Observation per ADR-089."
		category:        "observation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"evt-financial-compensation-ordered-received",
			"agg-financial-compensation",
		]
		preconditions: [
			"evt-financial-compensation-ordered-received chegou via canal ACL definido",
			"Payload conforma a schema declarado",
		]
		postconditions: [
			"Evento observado registrado em audit",
			"sig-acl-event-observed emitido com source-bc=drc",
			"Downstream chain triggered via pol-compensation-ordered-initiates; criação de aggregate em act-execute-approved-financial-compensation",
		]
	}, {
		// ----- #21 — Query: payment state -----
		code:          "act-query-payment-state"
		name:          "Consultar Estado do Pagamento"
		description:   "Consulta prj-payment-state-view para informar TCM, ATO, SCF, REW e BCs downstream sobre estado canônico de payment. Read-only — nunca publica state ahead de evt-payment-settled. Distinção settling ≠ settled preservada no payload retornado via sig-settling-vs-settled-discriminated."
		category:      "query"
		autonomyLevel: "execute-and-log"
		domainModelRefs: [
			"prj-payment-state-view",
			"qry-payment-settlement-status",
		]
		preconditions: ["PaymentId válido"]
		postconditions: ["Estado canônico retornado sem efeito colateral; payload preserva discriminação settling vs settled"]
	}, {
		// ----- #22 — Query: ledger -----
		code:          "act-query-ledger"
		name:          "Consultar Ledger"
		description:   "Consulta prj-financial-ledger por CommitmentId ou janela temporal — atende ATO (audit), TCM (reconciliação), SCF (fechamento de antecipação) e auditoria interna. Read-only; ledger é append-only por construção — query nunca causa efeito colateral."
		category:      "query"
		autonomyLevel: "execute-and-log"
		domainModelRefs: [
			"prj-financial-ledger",
			"qry-ledger-by-commitment",
			"qry-ledger-by-time-range",
		]
		preconditions: ["CommitmentId válido OR janela temporal válida"]
		postconditions: ["Ledger events retornados em ordem cronológica com proveniência preservada"]
	}, {
		// ----- #23 — Query: compensation state -----
		code:          "act-query-compensation-state"
		name:          "Consultar Estado de Compensação"
		description:   "Consulta prj-compensation-state-view para informar DRC, ATO e auditoria interna sobre estado canônico de FinancialCompensation. Read-only."
		category:      "query"
		autonomyLevel: "execute-and-log"
		domainModelRefs: [
			"prj-compensation-state-view",
			"qry-compensation-state",
		]
		preconditions: ["FinancialCompensationId válido"]
		postconditions: ["Estado canônico retornado sem efeito colateral"]
	}]

	// =============================================
	// CONSTRAINTS (9, coverage 1:1 com invariants)
	// =============================================

	constraints: [{
		code:         "cst-payment-evidence-required"
		name:         "Evidência Tripla para PrePaymentGuard"
		description:  "Agente nunca transita payment de pending para eligible sem os 3 inputs determinísticos do PrePaymentGuard: (a) InvoiceIssued válida observada de INV; (b) CreditEligibilityDecided positivo observado de REW; (c) cash availability confirmada via TCM sync. Sem qualquer dos 3, payment permanece em pending."
		verification: "Runner verifica que act-evaluate-pre-payment-guard só transita pending → eligible quando audit trail contém refs aos 3 eventos/queries originários: evt-invoice-issued-received, evt-credit-eligibility-decided-received positivo, response positiva de QueryCashAvailability via TCM. Ausência de qualquer input = transição bloqueada com motivo registrado em audit."
		onViolation:  "block-and-escalate"
		rationale:    "[enforcementLevel: agent + domain] [derivedFromInvariant: inv-payment-evidence-required] PrePaymentGuard interno é a invariante mais central do FCE — razão de existência do BC como unidade separada (Discipline 1). REW provê input via CreditEligibilityDecided mas NÃO é o gate; TCM provê input via QueryCashAvailability mas NÃO é o gate; o gate é interno ao FCE. Violação cria movimento financeiro sem evidência verificável — viola o purpose operacional do FCE."
	}, {
		code:         "cst-ledger-append-only"
		name:         "Ledger Apenas Append"
		description:  "Agente nunca emite mutação retroativa sobre ledger event registrado. Correção de movimento canonicamente registrado é via novo ledger event rastreável (compensation via FinancialCompensationOrdered), nunca via update, delete ou rewrite do event original."
		verification: "Runner verifica que nenhuma operação sobre prj-financial-ledger é update ou delete — apenas append. Audit trail contém timestamp imutável + sourcePaymentId ou CompensationId em cada ledger event. Tentativa de modificação = command rejeitado pelo lifecycle da projection."
		onViolation:  "block-and-escalate"
		rationale:    "[enforcementLevel: domain + agent] [derivedFromInvariant: inv-ledger-immutability] Ledger append-only é o que torna o SoT financeiro auditável e contábil canônico (Discipline 8). Lifecycle do projection enforça por construção; agente nunca emite delete/update. Violação destruiria reconstituição de auditoria regulatória e contábil."
	}, {
		code:         "cst-settled-requires-bkr-confirmation"
		name:         "Settled Requer Confirmação BKR"
		description:  "Agente nunca transita payment de settling para settled sem evt-bank-settlement-confirmed-received observado de BKR via ACL, com BankTransferRef do payload conferindo com BankTransferRef registrado no payment (ownership match). Settlement NÃO pode ser inferido por timeout, retry interno, heurística ou sinal parcial — somente por confirmação BKR explícita."
		verification: "Runner verifica que cmd-confirm-settlement só é emitido após (a) evt-bank-settlement-confirmed-received registrado em audit via act-observe-bank-settlement-confirmed; (b) BankTransferRef do event resolvido por act-route-bank-settlement-by-ownership para este payment específico; (c) audit trail contém ambas as refs + timestamp da observation + ownership-resolution=match."
		onViolation:  "block-and-escalate"
		rationale:    "[enforcementLevel: agent + runner] [derivedFromInvariant: inv-settled-requires-bkr-confirmation] BKR é source externa autoritativa para settlement (Discipline 3); settling ≠ settled (Discipline 4); BankTransferRef ownership é guard determinístico (Discipline 10). Violação publicaria PaymentSettled para REW/SCF/ATO/TCM sem confirmação física — propaga estado inconsistente cross-BC."
	}, {
		code:         "cst-post-settle-immutability"
		name:         "Imutabilidade Pós-Settle"
		description:  "Agente nunca emite mutation sobre payment em estado settled. Correção de pagamento já settled exige novo movimento via FinancialCompensation ordenada por DRC — nunca via alteração retroativa do payment original. Aplica-se também a payment em defaulted e aborted (terminais)."
		verification: "Runner verifica que nenhuma action de category mutation tem postcondition que altera payment em estado settled, defaulted ou aborted. Tentativa de emit de cmd-* sobre payment em terminal = command rejeitado pelo lifecycle do aggregate antes de processar; agente reporta no-op auditável via sig-routing-no-op-recorded."
		onViolation:  "block-and-escalate"
		rationale:    "[enforcementLevel: domain + agent] [derivedFromInvariant: inv-post-settle-immutability] Extensão da disciplina append-only (Discipline 8) ao payment terminal: settled/defaulted/aborted são terminais por construção; alteração retroativa quebra rastreabilidade e reconciliação cross-BC (ATO contabilizou; SCF fechou antecipação; REW retroalimentou risco). Correção deve ser via novo movimento rastreável."
	}, {
		code:         "cst-cash-availability-checked"
		name:         "Verificação Sync de Disponibilidade de Caixa"
		description:  "Agente consulta TCM via QueryCashAvailability antes de transição pending → eligible (parte do PrePaymentGuard) e re-verifica antes de act-propose-initiate-bank-transfer. Cash availability nunca é cacheada pelo FCE nem assumida — sempre consulta sync. FCE MUST NOT cache or override cash availability. TCM decide; FCE consulta."
		verification: "Runner verifica que (a) act-evaluate-pre-payment-guard tem audit field 'cash-availability-tcm-response' com timestamp da consulta dentro de window aceitável; (b) act-propose-initiate-bank-transfer tem nova consulta TCM com timestamp mais recente que a do guard. Cache hit, omissão, ou consulta stale = transição bloqueada."
		onViolation:  "block-and-escalate"
		rationale:    "[enforcementLevel: agent] [derivedFromInvariant: inv-cash-availability-required-for-settling] Discipline 1 explicit: FCE MUST NOT cache or override cash availability. TCM é autoridade canônica de disponibilidade; FCE consulta sync, não decide, não cacheia. Violação criaria movimento sem cobertura financeira confirmada."
	}, {
		code:         "cst-commitment-id-preserved"
		name:         "Preservação de CommitmentId"
		description:  "Agente preserva CommitmentId originário em todos os ledger events, queries retornadas, audit trail entries e events publicados. CommitmentId é o fio de rastreabilidade cross-BC (CMT → FCE → ATO/REW/SCF) — não pode ser perdido em nenhuma transição, agregação ou projection."
		verification: "Runner verifica que (a) cada ledger event contém CommitmentId em payload; (b) evt-payment-settled e evt-payment-obligation-defaulted publicados contêm CommitmentId; (c) prj-financial-ledger, prj-payment-state-view e prj-compensation-state-view incluem CommitmentId nas queries; (d) audit fields contêm commitment-id em todas as actions. Ausência = command rejeitado."
		onViolation:  "block-and-escalate"
		rationale:    "[enforcementLevel: agent + runner] [derivedFromInvariant: inv-commitment-id-preservation] Sem CommitmentId preservado, ATO não consegue lançar contábil, SCF não consegue reconciliar antecipação, REW não consegue retroalimentar risco. CommitmentId é a chave cross-BC que torna o ledger reconciliável e o sistema auditável end-to-end."
	}, {
		code:         "cst-bank-transfer-supervised"
		name:         "Transferência Bancária Requer Supervisão"
		description:  "Agente nunca emite cmd-initiate-bank-transfer (via act-execute-approved-bank-transfer) nem cmd-execute-financial-compensation (via act-execute-approved-financial-compensation) sem approval-id de humano registrado via mech-agent-gate. Approval-id deve referenciar recommendation aprovada de propose action correspondente. Payload de execução deve ser byte-idêntico ao payload aprovado (payload-hash match)."
		verification: "Runner verifica que cada emit de cmd-initiate-bank-transfer e cmd-execute-financial-compensation tem (a) approval-id no audit trail; (b) payload-hash do command = payload-hash da recommendation aprovada da propose action correspondente; (c) timestamp do approval anterior ao timestamp do emit. Audit trail contém: approval-id, recommendation-id, payload-hash, approval-timestamp, execute-timestamp."
		onViolation:  "block-and-escalate"
		rationale:    "[enforcementLevel: agent + runner] [derivedFromInvariant: inv-bank-transfer-requires-supervision] Discipline 7: movimento financeiro irreversível requer aprovação humana via mech-agent-gate. Anti-drift via payload-hash: aprovação humana não pode ser desviada por modificação do payload entre approve e execute. Violação moveria dinheiro real sem audit autorizado — irreparável."
	}, {
		code:         "cst-financialization-atomicity"
		name:         "Atomicidade da Financialization (Phase 0 Declarada)"
		description:  "Quando antecipação SCF for elegível para um payment, settlement original (FCE → fornecedor) e cessão à IF financiadora (SCF) ocorrem atomicamente — falha em qualquer perna aborta toda a operação composta. Phase 0: constraint declarada estruturalmente; enforcement ativo deferido até wiring SCF concretizar."
		verification: "Phase 0: Runner não verifica enforcement ativo; apenas registra que constraint existe estruturalmente para SCF wiring futuro. Phase futura (quando SCF policy/service concretizar): verifica que execução de antecipação produz settlement + cessão como par atômico ou rollback completo da operação composta."
		onViolation:  "log-only"
		rationale:    "[enforcementLevel: declared-only] [derivedFromInvariant: inv-financialization-atomicity] Phase 0 declarative constraint; no active enforcement until SCF wiring exists — deferred wiring pending SCF integration decision. Constraint existe como placeholder governamental para guiar implementação futura. Quando SCF policy/service concretizar, onViolation eleva para block-and-escalate."
	}, {
		code:         "cst-compensation-respects-drc-decision"
		name:         "Compensação Respeita Decisão DRC"
		description:  "Agente preserva amount, parties e rationale do FinancialCompensationOrdered originário de DRC em todo o lifecycle da FinancialCompensation. Nenhuma modificação, reinterpretação ou cálculo derivado é permitido. FCE may execute compensation ordered by DRC, but MUST NOT originate compensation, calculate compensation, or reinterpret DRC decision."
		verification: "Runner verifica que payload de cmd-execute-financial-compensation (via act-execute-approved-financial-compensation) tem amount, parties e rationale byte-idênticos aos do evt-financial-compensation-ordered-received originário. Audit trail contém refs ao event DRC originário + payload-hash do FinancialCompensationOrdered preservado. Mismatch = command rejeitado."
		onViolation:  "block-and-escalate"
		rationale:    "[enforcementLevel: agent + runner] [derivedFromInvariant: inv-compensation-respects-drc-decision] Discipline 5 (frase canônica). DRC é autoridade de mérito de disputa; FCE é executor financeiro. Modificação de qualquer atributo carregado pela ordem DRC viola separation of concerns crítica para integridade do sistema de disputa. FCE não é compensating authority por construção."
	}]

	// =============================================
	// ESCALATION CONDITIONS (6)
	// =============================================

	escalationConditions: [{
		category:    "conflicting-signals"
		description: "Sinais contraditórios de fontes ACL diferentes sobre o mesmo payment ou compensation. Exemplos: REW emite CreditEligibilityDecided positivo enquanto INV simultaneamente emite InvoiceCancelled; BKR confirma settlement enquanto DRC ordena compensation no mesmo instante; QueryCashAvailability positivo fica stale antes da emissão e a reconsulta TCM falha ou retorna negativa."
		rationale:   "Mutations exigem cobertura (tq-ag-10). Conflito entre fontes upstream exige julgamento humano sobre precedência — agente não resolve estruturalmente."
	}, {
		category:    "insufficient-context"
		description: "Contexto insuficiente para gate determinístico ou rota técnica. Exemplos: QueryCashAvailability retorna timeout/erro persistente em TCM; CommitmentId não resolve em CMT via lookup; payload de evt-bank-settlement-confirmed-received não contém BankTransferRef esperado; estado interno do payment inconsistente com prj-payment-state-view (concorrência detectada)."
		rationale:   "Mutations exigem cobertura (tq-ag-10). Decisão com dados incompletos gera risco de obrigação financeira incorreta ou movimento errado."
	}, {
		category:    "ambiguous-case"
		description: "Parâmetros do payment ou compensation fora de zona rotineira. Exemplos: valor excede high-value-threshold configurado no governance envelope; rail BKR não previsto (novo PSP, BNPL externo, cripto); parties em jurisdição cross-border não suportada Phase 0; FinancialCompensationOrdered com semântica não-financeira (service credit, deliverable corretivo) que não é executável via BKR rail."
		rationale:   "Canvas escalation criteria high-value-threshold + novel-operation-type. Casos ambíguos exigem decisão humana sobre conformidade legal e operacional."
	}, {
		category:    "suspicious-input"
		description: "Padrão suspeito em input ACL externo. Exemplos: evt-financial-compensation-ordered-received com amount desproporcional ao payment original; payload BKR com schema unexpected ou campos divergentes do contrato; sequence de events ACL em ordem que sugere replay/manipulation; BankTransferRef de evt-bank-settlement-confirmed-received nunca emitido pelo FCE."
		rationale:   "Observations com external-structured input exigem cobertura (tq-ag-11). Suspeita de injection/manipulation/fraude requer escalation imediata — proteção financeira contra adversarial input."
	}, {
		category:    "out-of-scope"
		description: "Operação fora do escopo declarado do FCE. Exemplos: solicitação de KYC/AML/sanctions screening (delegado a outro BC); solicitação de FX conversion ou tax calculation; solicitação de pricing decision ou credit-risk decision (REW); query sobre operação cross-BC para a qual FCE não é autoritativo (e.g., dispute merit em DRC, credit score em REW)."
		rationale:   "Discipline boundaries explícitas — FCE não é treasury agent, não é AML agent, não é tax agent, não é pricing agent, não é risk agent. Tentativa de operar fora do escopo é escalada para humano clarificar BC apropriado."
	}, {
		category:    "unclassifiable-anomaly"
		description: "Anomalia estrutural não classificável. Exemplos: BKR ACK chegando para BankTransferRef nunca emitido pelo FCE (potencial misrouting ou ataque); ledger event não correlacionável a CommitmentId ou PaymentId existente; mismatch payload-hash entre recommendation aprovada e execute attempt (anti-drift falhou estruturalmente)."
		rationale:   "Anomalias estruturais indicam falha em invariantes do sistema, não apenas no payment individual. Escala imediatamente para auditoria de integridade do FCE."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Canvas define governanceScope (autonomousDecisions, supervisedDecisions, escalationCriteria), stakeholders, businessDecisions e incentiveAnalysis — necessário para calibrar autonomia, detectar adversarial patterns e mapear high-value-threshold + novel-operation-type para escalation."
			requiredSlices: ["ownership", "governanceScope", "incentiveAnalysis", "communication", "businessDecisions"]
		}, {
			artifactType: "domain-model"
			rationale:    "Domain model define os 2 aggregates, 10 commands, 13 events, 9 invariants, 7 policies e 3 projections — mapa operacional completo do agente. FCE primary opera sobre todo o domain-model (coverage 100%)."
		}, {
			artifactType: "glossary"
			rationale:    "Glossário FCE define os 12 termos canônicos (PrePaymentGuard, settling vs settled, Ledger, BankTransferRef ownership, etc.) — agente precisa interpretar inputs ACL e produzir outputs usando linguagem ubíqua do BC, especialmente em distinções críticas (PaymentId vs CommitmentId, settling vs settled)."
			requiredSlices: ["terms"]
		}, {
			artifactType: "agent-governance"
			rationale:    "Governance envelope (fce-primary-agent.governance.cue, forward-ref até criação do governance envelope) define calibração dinâmica, blast radius limits, high-value-threshold para escalation, channels de aprovação via mech-agent-gate, autonomy promotion/regression criteria. Agente consulta envelope para decisões calibráveis (timeout settling, threshold values)."
		}, {
			artifactType: "context-map"
			rationale:    "Context map define integration patterns com INV (upstream ACL), REW (upstream ACL bidirectional), TCM (upstream sync + downstream publish), BKR (downstream rail + upstream ACL), DRC (upstream ACL), SCF/ATO (downstream publish). FCE tem 6 sources ACL — context-map é necessário para validar event handling correto."
			requiredSlices: ["relationships where upstream is fce or downstream is fce"]
		}]

		estimatedBudget: "heavy"
	}

	// =============================================
	// OBSERVABILITY
	// =============================================

	observability: {
		signals: [{
			code:           "sig-mutation-executed"
			name:           "Mutação Executada"
			description:    "Emitido após cada mutation action que materializa command ou transição de estado com sucesso. Inclui register-payment, abort-pre-emission, record-settlement (payment + compensation), execute-approved-* e mark-default."
			coversCategory: "mutation"
			trigger:        "Mutation action processada com sucesso por agg-payment ou agg-financial-compensation."
			level:          "info"
			payloadFields: ["aggregate-id", "command-code", "from-state", "to-state", "commitment-id"]
		}, {
			code:           "sig-validation-result"
			name:           "Resultado de Validação"
			description:    "Emitido após cada validation processada — PrePaymentGuard (3 inputs) ou routing técnico BKR ACK por ownership."
			coversCategory: "validation"
			trigger:        "act-evaluate-pre-payment-guard OR act-route-bank-settlement-by-ownership executado."
			level:          "info"
			payloadFields: ["validation-code", "inputs-summary", "result", "rationale"]
		}, {
			code:           "sig-escalation-triggered"
			name:           "Escalation Disparada"
			description:    "Emitido quando agente identifica condição de escalation (conflicting-signals, insufficient-context, ambiguous-case, suspicious-input, out-of-scope, unclassifiable-anomaly) e transfere decisão para humano."
			coversCategory: "escalation"
			trigger:        "Qualquer escalationCondition satisfeita."
			level:          "warn"
			payloadFields: ["category", "description-context", "affected-aggregate-id", "commitment-id"]
		}, {
			code:           "sig-query-served"
			name:           "Query Atendida"
			description:    "Emitido após cada query atendida — payment state, ledger by commitment/time-range, ou compensation state. Read-only sem efeito colateral."
			coversCategory: "query"
			trigger:        "act-query-payment-state OR act-query-ledger OR act-query-compensation-state executado."
			level:          "info"
			payloadFields: ["query-code", "query-key", "result-count"]
		}, {
			code:           "sig-supervision-requested"
			name:           "Supervisão Humana Solicitada"
			description:    "Emitido quando agente submete recommendation de propose action (act-propose-initiate-bank-transfer, act-propose-execute-financial-compensation, act-propose-mark-default, act-route-dispute-resolution, act-resolve-prolonged-settling) e aguarda approval-id de humano via mech-agent-gate."
			coversCategory: "mutation"
			trigger:        "Action com autonomyLevel propose-and-wait submetida para approval."
			level:          "warn"
			payloadFields: ["action-code", "recommendation-id", "payload-hash", "aggregate-id"]
		}, {
			code:           "sig-constraint-violation"
			name:           "Violação de Constraint"
			description:    "Emitido quando action ou command viola constraint com onViolation=block-and-escalate. Ação bloqueada e escalada para humano."
			coversCategory: "mutation"
			trigger:        "Qualquer constraint com onViolation block-and-escalate ativada."
			level:          "error"
			payloadFields: ["constraint-code", "violating-action", "violation-detail", "aggregate-id"]
		}, {
			code:           "sig-acl-event-observed"
			name:           "Evento ACL Observado"
			description:    "Emitido por cada act-observe-* após registro de evt-*-received em audit (ADR-089 trigger independence). Cobre as 6 observation actions (INV/REW/BKR/DRC sources). Materializa disciplina de observation explícita — observation não é silenciosa."
			coversCategory: "observation"
			trigger:        "Qualquer act-observe-* processa um evt-*-received."
			level:          "info"
			payloadFields: ["source-bc", "event-type", "event-payload-summary", "correlation-id"]
		}, {
			code:           "sig-settling-vs-settled-discriminated"
			name:           "Discriminação settling vs settled"
			description:    "Signal emitted by query and mutation paths; category points to the critical mutation boundary. Emitido em toda act-query-payment-state e antes de qualquer publicação de evt-payment-settled — explicita estado canônico do payment para evitar confusão downstream entre settling (interno) e settled (terminal pós-BKR-ACK). Materializa Discipline 4."
			coversCategory: "mutation"
			trigger:        "act-query-payment-state retorna estado OR act-record-payment-settlement antes de publish evt-payment-settled."
			level:          "info"
			payloadFields: ["payment-id", "payment-state-at-emission", "bkr-ack-observed"]
		}, {
			code:           "sig-routing-no-op-recorded"
			name:           "No-op de Roteamento Registrado"
			description:    "Emitido quando sinal inbound não resolve para nenhum aggregate (no-owner case). Cobre Discipline 9 (no-op auditável geral) — nenhum sinal é silenciosamente descartado."
			coversCategory: "mutation"
			trigger:        "act-route-bank-settlement-by-ownership resolve no-owner OR observation ACL não correlacionável a payment/compensation existente."
			level:          "warn"
			payloadFields: ["inbound-event-type", "routing-key", "ownership-resolution", "routing-resolution-rationale"]
		}, {
			code:           "sig-bank-transfer-ref-routed"
			name:           "BankTransferRef Roteado"
			description:    "Emitido em cada act-route-bank-settlement-by-ownership com ownership-resolution explícito (match-payment / match-compensation / no-owner). Materializa Discipline 10 — ownership guard determinístico auditável."
			coversCategory: "validation"
			trigger:        "act-route-bank-settlement-by-ownership processa qualquer BKR ACK."
			level:          "info"
			payloadFields: ["bank-transfer-ref", "owning-aggregate-id", "owning-aggregate-type", "ownership-resolution"]
		}]

		auditTrail: {
			requiredFields: [
				// 7 minimum regulatory-grade (per #AuditTrailSpec._minimumAuditFields)
				"timestamp",
				"agent-id",
				"action-code",
				"input-summary",
				"output-summary",
				"decision-rationale",
				"governance-version",
				// 9 FCE-specific
				"aggregate-id",
				"commitment-id",
				"payment-state-at-emission",
				"ownership-resolution",
				"bank-transfer-ref",
				"approval-id",
				"payload-hash",
				"autonomy-level-applied",
				"constraints-evaluated",
			]

			storageHint: "Event Log imutável do FCE — mesmo store dos domain events (evt-ledger-event-recorded e demais internos), partição separada para audit trail do agente. Append-only por construção (alinhado com cst-ledger-append-only). Acessível para reconstituição de auditoria regulatória e contábil."

			rationale: "Intermediário financeiro requer reconstituição completa de decisões para auditoria regulatória e contábil. Os 7 campos mínimos (_minimumAuditFields) são floor regulatory-grade. 9 campos FCE-specific cobrem: discriminação double aggregate (aggregate-id), rastreabilidade cross-BC (commitment-id), discriminação settling vs settled (payment-state-at-emission, Discipline 4), routing ownership audit (ownership-resolution + bank-transfer-ref, Disciplines 9/10), anti-drift de supervisão (approval-id + payload-hash, Discipline 7), e tracking operacional (autonomy-level-applied + constraints-evaluated)."
		}
	}

	// =============================================
	// RATIONALE OUTER
	// =============================================

	rationale: """
		Agente primário do FCE. Domain-agent que opera sobre todo o lifecycle financeiro do BC — 2 aggregates (agg-payment, agg-financial-compensation), 10 commands, 13 events (2 published + 6 ACL-observed + 5 internos), 9 invariants, 7 policies, 3 projections.

		23 actions distribuídas em 8 grupos canônicos: 1 validation gate (PrePaymentGuard interno) + 3 pares propose+execute-approved para mutações financeiras irreversíveis (initiate-bank-transfer, execute-financial-compensation, mark-default) com anti-drift via payload-hash + 4 internal deterministic mutations (register-payment, abort-pre-emission, record-payment-settlement, record-compensation-settlement) + 2 router humano/semânticos propose-and-wait (handle-dispute, resolve-prolonged-settling) + 1 routing técnico validation execute-and-log (route-bank-settlement-by-ownership) + 6 ACL ingestion observations execute-and-log (INV×2, REW, BKR, DRC×2) + 3 queries execute-and-log.

		5 propose-and-wait / 18 execute-and-log — distribuição reflete envelope: dinheiro real irreversível supervisionado; gates determinísticos + ingestion + queries autônomas; routers humano/semânticos supervisionados; routing técnico determinístico autônomo.

		9 constraints verificáveis cobrindo 1:1 os 9 invariants do domain-model (cst-payment-evidence-required, cst-ledger-append-only, cst-settled-requires-bkr-confirmation, cst-post-settle-immutability, cst-cash-availability-checked, cst-commitment-id-preserved, cst-bank-transfer-supervised, cst-financialization-atomicity Phase 0 declared-only com log-only, cst-compensation-respects-drc-decision). 8 com block-and-escalate + 1 log-only (Phase 0 SCF wiring deferred). Cada constraint declara enforcementLevel (agent/runner/domain/external/declared-only) e derivedFromInvariant explicit no rationale.

		6 escalation conditions cobrindo conflicting-signals + insufficient-context (mutations per tq-ag-10) + suspicious-input + ambiguous-case (observations per tq-ag-11) + out-of-scope (boundaries FCE — KYC/AML/sanctions/FX/tax/pricing/credit-risk) + unclassifiable-anomaly (anomalias estruturais). 3 per-action overrides em actions críticas (#11 execute-approved-mark-default, #3/#5 execute-approved bank-transfer + compensation, #18 observe-bank-settlement-confirmed) documentados nas descriptions correspondentes.

		10 signals de observabilidade: 6 canônicos (sig-mutation-executed, sig-validation-result, sig-escalation-triggered, sig-query-served, sig-supervision-requested, sig-constraint-violation) + 1 observation-canonical (sig-acl-event-observed) + 3 FCE-specific (sig-settling-vs-settled-discriminated, sig-routing-no-op-recorded, sig-bank-transfer-ref-routed). Coverage ≥1 por category presente em actions[].

		Audit trail regulatory-grade com 16 fields: 7 mínimos (_minimumAuditFields) + 9 FCE-specific cobrindo double aggregate discrimination + cross-BC rastreabilidade + Disciplines 4/7/9/10 dedicated audit + operational tracking.

		Forward reference: governanceRef aponta para fce-primary-agent.governance.cue — arquivo será criado em sequência (próximo artefato do FCE). Runner reportará tq-ag-09 fail até criação do envelope.

		Disciplinas operacionais canônicas: PrePaymentGuard interno (gate determinístico — REW/TCM provêem input, FCE possui o gate); execução de dinheiro real estruturalmente separada em observe/recommend/execute via autonomy distribution; BKR confirmation como sinal externo observado (settling ≠ settled até BKR ACK); FCE não é compensating authority (FCE may execute compensation ordered by DRC, but MUST NOT originate, calculate or reinterpret); routers dispatcham, terminais materializam; InitiateBankTransfer requer supervised approval com anti-drift via payload-hash; ledger append-only; no-op auditável geral + BankTransferRef ownership específico.

		Alinhado com canvas, domain-model, glossary, context-map e design principles (P10 — agentes recomendam, gates determinísticos validam).
		"""
}
