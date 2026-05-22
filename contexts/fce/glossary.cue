package fce

// glossary.cue — Ubiquitous Language: Financial Commitment Execution.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Termos canônicos do BC FCE. Define o vocabulário que agentes, código,
// contratos e interfaces usam ao operar neste contexto.
//
// Lenses aplicadas:
// - lens-domain-language-and-terminology-design (primária):
//   bilingual mapping pt-BR/en, term selection criteria, cross-layer consistency
// - lens-contractual-and-legal-architecture (secundária):
//   precisão jurídica do conceito de inadimplência e da imutabilidade do ledger

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code: "fce"
	name: "Glossário FCE — Financial Commitment Execution"

	boundedContextRef: "fce"

	terms: [{
		code:       "term-pagamento"
		name:       "Pagamento"
		termEn:     "Payment"
		definition: "Lifecycle financeiro que executa a movimentação de dinheiro decorrente de um compromisso operacional verificado. Nasce com InvoiceIssued observado de INV e segue gates determinísticos internos (PrePaymentGuard, cash availability) até estado terminal settled, defaulted ou aborted. Rastreável end-to-end via PaymentId vinculado ao CommitmentId originário."
		category:   "entity"
		rationale:  "Pagamento é o conceito operacional central do FCE — distinto de Compromisso (CMT, obrigação bilateral) e de Recebível (INV/SCF, ativo financeiro). Pagamento é a execução do compromisso na dimensão financeira: o momento em que dinheiro se move sob gate. Sem termo canônico separado, agentes confundem com 'transferência' (mecânica BKR) ou 'liquidação' (estado terminal específico)."
		synonyms: ["Execução Financeira"]
		antiTerms: [{
			term:          "Liquidação"
			clarification: "Liquidação é o estado terminal settled. Pagamento é o lifecycle completo (pending→eligible→settling→settled), não só o ponto final."
		}, {
			term:          "Transferência Bancária"
			clarification: "Transferência Bancária é o fenômeno físico no rail (delegado a BKR). Pagamento é o lifecycle lógico do FCE que solicita a transferência mas é distinto dela."
		}, {
			term:          "Compromisso"
			clarification: "Compromisso é a obrigação bilateral em CMT. Pagamento é a execução financeira dessa obrigação — um compromisso pode gerar múltiplos pagamentos (parcelas)."
		}]
		examples: [{
			context:   "Happy path do lifecycle"
			instance:  "Fatura emitida em INV → Payment criado em pending → PrePaymentGuard aprovado → settling → BankSettlementConfirmed → settled. PaymentSettled publicado para REW, SCF, ATO, TCM."
			rationale: "Caminho canônico que materializa a invariante 'dinheiro só se move com evidência'."
		}]
		relatedTerms: ["term-payment-id", "term-payment-state", "term-pre-payment-guard", "term-ledger"]
		domainModelRefs: ["agg-payment"]
		layerMapping: {
			codeTerm: "Payment"
			apiTerm:  "payments"
			uiLabel:  "Pagamento"
		}
	}, {
		code:       "term-payment-id"
		name:       "PaymentId"
		termEn:     "Payment ID"
		definition: "Identificador canônico do payment lifecycle gerado no FCE no momento de RegisterInvoiceForPayment. Distinto de CommitmentId (fio de rastreabilidade cross-BC nascido em CMT): um compromisso pode gerar múltiplos PaymentIds (parcelas, reemissões pré-settle). PaymentId permeia ledger events e a projection prj-financial-ledger."
		category:   "value"
		rationale:  "PaymentId merece termo canônico porque é a identidade local do FCE, distinta de CommitmentId. A confusão entre os dois ids é vetor de erro recorrente: CommitmentId é fio cross-BC; PaymentId é unidade de execução local. Sem distinção explícita, agentes tratam como sinônimos e perdem a granularidade do FCE."
		antiTerms: [{
			term:          "CommitmentId"
			clarification: "CommitmentId é identificador do compromisso em CMT, fio cross-BC. PaymentId é local ao FCE — múltiplos PaymentIds podem rastrear ao mesmo CommitmentId."
		}, {
			term:          "TransactionId"
			clarification: "TransactionId é conceito BKR/bancário. PaymentId é identidade lógica do lifecycle financeiro do FCE, anterior e independente da execução física no rail."
		}]
		examples: [{
			context:  "Múltiplas parcelas para o mesmo compromisso"
			instance: "Compromisso com CommitmentId cmt-2026-0042 gera dois payments: pay-2026-0042-01 e pay-2026-0042-02. Ambos rastreiam ao mesmo CommitmentId no ledger; cada um tem seu próprio lifecycle."
		}]
		relatedTerms: ["term-pagamento"]
		domainModelRefs: ["vo-payment-id"]
		layerMapping: {
			codeTerm: "PaymentId"
			apiTerm:  "payment_id"
			uiLabel:  "ID do Pagamento"
		}
	}, {
		code:       "term-payment-state"
		name:       "Estado do Pagamento"
		termEn:     "Payment State"
		definition: "Estado canônico do payment no lifecycle. Enum de 6 valores: pending (criado, aguardando gate), eligible (PrePaymentGuard aprovado), settling (InitiateBankTransfer emitido, aguardando confirmação BKR), settled (BankSettlementConfirmed observado — terminal de sucesso), defaulted (falha operacional terminal), aborted (encerrado intencionalmente pré-emissão de InitiateBankTransfer). A distinção settling ≠ settled é semanticamente central: settling é janela interna; settled torna-se observável cross-BC via PaymentSettled."
		category:   "value"
		rationale:  "Estado merece termo canônico porque concentra a distinção mais crítica do FCE: settling vs settled (bd-settled-after-bkr). Consumers cross-BC tratam settling ≠ settled — TCM/ATO/SCF reconciliam apenas contra settled. Sem termo explícito que enforce essa distinção, agentes geram código que confunde os dois estados."
		examples: [{
			context:  "Distinção settling vs settled"
			instance: "Payment em settling: InitiateBankTransfer foi emitido a BKR via PIX, mas BankSettlementConfirmed ainda não chegou. Visível via QueryPaymentSettlementStatus mas NÃO publicado como PaymentSettled. Payment em settled: BKR confirmou, ledger event registrado, PaymentSettled publicado para REW/SCF/ATO/TCM."
		}, {
			context:   "Distinção defaulted vs aborted"
			instance:  "defaulted: PrePaymentGuard aprovou mas rail falhou ou timeout pós-elegibilidade — REW recebe PaymentObligationDefaulted, score deteriora. aborted: InvoiceCancelled observado pré-emissão — sem movimento financeiro, sem impacto em score."
			rationale: "Ambos são terminais, mas semanticamente distintos: defaulted é falha operacional; aborted é encerramento intencional."
		}]
		relatedTerms: ["term-pagamento", "term-pre-payment-guard", "term-transferencia-bancaria"]
		domainModelRefs: ["vo-payment-state"]
		layerMapping: {
			codeTerm: "PaymentState"
			apiTerm:  "payment_state"
			uiLabel:  "Estado"
		}
	}, {
		code:       "term-pre-payment-guard"
		name:       "PrePaymentGuard"
		termEn:     "PrePaymentGuard"
		definition: "Gate determinístico interno do FCE que materializa a invariante 'dinheiro só se move com evidência'. Verifica três condições antes de permitir transição pending → eligible: (a) InvoiceIssued válida observada de INV, (b) CreditEligibilityDecided positivo observado de REW, (c) cash availability confirmada em TCM via QueryCashAvailability. Sem todas as três condições satisfeitas, pagamento permanece em pending."
		category:   "rule"
		rationale:  "PrePaymentGuard é o conceito mais central da identidade do FCE — razão de existência do BC como unidade separada. A internalidade do gate é disciplina crítica: REW fornece input via CreditEligibilityDecided mas NÃO é o gate; o gate é interno ao FCE. Sem termo canônico que enforce essa disciplina, agentes tendem a atribuir o gate a REW (erro arquitetural recorrente)."
		antiTerms: [{
			term:          "Gate de Risco (REW)"
			clarification: "REW decide elegibilidade de crédito e publica CreditEligibilityDecided. O gate que combina essa decisão com fatura válida (INV) e cash availability (TCM) é interno ao FCE — PrePaymentGuard."
		}, {
			term:          "Validação de Pagamento"
			clarification: "Validação genérica não captura a invariante 'dinheiro só se move com evidência'. PrePaymentGuard é gate determinístico específico com 3 condições enumeradas, não conjunto difuso de checks."
		}]
		rejectedAlternatives: [{
			term:   "PaymentEligibilityCheck"
			reason: "Genérico demais — não captura a precondição de evidência operacional (vinculação a InvoiceIssued, que por sua vez vincula a DLV). Guard expressa melhor a semântica de barreira determinística inviolável; PrePaymentGuard preserva intent operacional sem reduzir a check técnico."
		}]
		examples: [{
			context:  "Fluxo do gate"
			instance: "Payment em pending: InvoiceIssued já chegou de INV. PrePaymentGuard aguarda CreditEligibilityDecided de REW. Quando chega positivo, PrePaymentGuard consulta TCM via QueryCashAvailability. Se caixa disponível, transição pending → eligible. Caso contrário, payment permanece em pending até cash availability se materializar."
		}]
		relatedTerms: ["term-pagamento", "term-payment-state"]
		domainModelRefs: ["inv-payment-evidence-required", "cmd-evaluate-pre-payment-guard"]
	}, {
		code:       "term-ledger"
		name:       "Ledger"
		termEn:     "Ledger"
		definition: "Source of Truth (SoT) financeiro canônico do FCE: visão append-only de todos os movimentos canônicos (settlements, default markers, compensações) vinculados a CommitmentId e evidência originária. ATO, TCM e SCF reconciliam contra o ledger — não contra extratos bancários ou fontes concorrentes. Materializado como projection (prj-financial-ledger) consumindo evt-ledger-event-recorded, não como aggregate."
		category:   "entity"
		rationale:  "Ledger merece termo canônico — apesar de implementado como projection no domain-model — porque é conceito operacional percebido pelo negócio e regulador. UL modela ontologia, não aggregate boundary: o ledger 'existe' para ATO/TCM/SCF/Bacen como entidade conceitual única, mesmo sendo derivado de events. Materializa bd-ledger-as-sot."
		antiTerms: [{
			term:          "Extrato Bancário"
			clarification: "Extrato bancário é vista BKR-side da liquidação física. Ledger é vista FCE-side com proveniência (CommitmentId, evidência originária) que extrato bancário não carrega."
		}, {
			term:          "Contabilidade"
			clarification: "Contabilidade é responsabilidade do ATO sob regras fiscais. Ledger é movimento financeiro canônico do qual ATO deriva lançamentos contábeis — anterior e distinto."
		}]
		examples: [{
			context:  "Reconciliação cross-BC"
			instance: "ATO consome PaymentSettled em modo conformist e deriva lançamento contábil; quando precisa auditar, consulta o ledger via qry-ledger-by-commitment. SCF reconcilia operação de antecipação contra ledger no momento de fechamento — não contra extratos bancários paralelos."
		}]
		relatedTerms: ["term-ledger-event", "term-pagamento"]
		domainModelRefs: ["prj-financial-ledger"]
	}, {
		code:       "term-ledger-event"
		name:       "Ledger Event"
		termEn:     "Ledger Event"
		definition: "Fato financeiro imutável registrado no ledger canônico. Append-only por construção: nunca mutado, removido ou retroagido. Carrega tipo (settlement, default-marker, compensation), CommitmentId, amount, parties, sourcePaymentId ou CompensationId e timestamp. Correção de movimento canonicamente registrado ocorre via novo ledger event rastreável (refund via FinancialCompensationOrdered), nunca via mutação."
		category:   "event"
		rationale:  "Ledger event é a unidade atômica do SoT financeiro. Categoria event (não value) reflete a semântica temporal append-only: cada ledger event marca um fato que ocorreu em um instante específico. Imutabilidade pós-registro é o que torna o ledger consultável como fonte auditável e contábil (dp-10)."
		antiTerms: [{
			term:          "Transação"
			clarification: "Transação implica unidade atômica que pode ser revertida (rollback). Ledger event é imutável pós-registro — não há rollback, apenas correção via novo event."
		}, {
			term:          "Linha do Ledger"
			clarification: "Linha sugere mutabilidade tabular. Ledger event é fato cronológico append-only com proveniência."
		}]
		examples: [{
			context:  "Tipos de ledger event"
			instance: "settlement ledger event: registra liquidação confirmada por BKR. default-marker ledger event: registra que pagamento foi marcado defaulted (não é movimento financeiro — é marcador para audit). compensation ledger event: registra execução de FinancialCompensationOrdered preservando proveniência dispute-driven."
		}]
		relatedTerms: ["term-ledger", "term-pagamento"]
		domainModelRefs: ["vo-ledger-event", "evt-ledger-event-recorded"]
	}, {
		code:       "term-financialization-atomicity"
		name:       "Atomicidade da Financialization"
		termEn:     "Financialization Atomicity"
		definition: "Invariante operacional que governa antecipações SCF: quando antecipação é elegível para um payment, settlement original (FCE → fornecedor) e cessão à IF financiadora (SCF) ocorrem atomicamente. Falha em qualquer perna aborta toda a operação composta. Evita estados intermediários inconsistentes (cessão sem settlement, ou settlement sem cessão correspondente) impossíveis de reconciliar."
		category:   "rule"
		rationale:  "Atomicidade da financialization é invariante específica ao acoplamento FCE↔SCF que merece termo canônico. Sem termo explícito, agentes tendem a modelar antecipação como dois eventos sequenciais independentes — quebra o all-or-nothing por construção. Phase 0 deferred no wiring concreto (policy/service SCF aguarda evidência operacional); conceito permanece canônico no UL para guiar implementação futura."
		relatedTerms: ["term-pagamento", "term-ledger-event"]
		domainModelRefs: ["inv-financialization-atomicity"]
	}, {
		code:       "term-transferencia-bancaria"
		name:       "Transferência Bancária"
		termEn:     "Bank Transfer"
		definition: "Fenômeno operacional de movimentação física de dinheiro via rail bancário (PIX, TED, boleto, SWIFT). Solicitada pelo FCE via InitiateBankTransfer a BKR; confirmada de forma assíncrona via BankSettlementConfirmed. Pós-emissão de InitiateBankTransfer, dinheiro pode já estar em trânsito no rail — a janela settling representa esse intervalo. Disciplina canônica: aborted só é válido pré-emissão; pós-emissão exige BKR confirmation ou DRC compensation para correção."
		category:   "process"
		rationale:  "Transferência Bancária é fenômeno operacional percebido pelo negócio (tesouraria, regulador) e merece termo canônico distinto do command interno InitiateBankTransfer. Categoria process reflete que é fluxo temporal (emissão → confirmação) com janela settling explícita, não command pontual. UL modela o conceito de domínio, não o command que o aciona."
		antiTerms: [{
			term:          "Settlement"
			clarification: "Settlement é o estado terminal pós-BKR-ACK. Transferência Bancária é o processo completo incluindo a janela settling intermediária."
		}, {
			term:          "Pagamento"
			clarification: "Pagamento é o lifecycle lógico do FCE; Transferência Bancária é o fenômeno físico no rail. Um Payment usa uma Transferência Bancária para executar a fase settling."
		}]
		examples: [{
			context:  "Janela settling"
			instance: "Após PrePaymentGuard aprovar e InitiateBankTransfer ser emitido a BKR via PIX, o payment entra em settling. Dinheiro pode já ter saído da plataforma; BKR confirma assincronamente via BankSettlementConfirmed. Até a confirmação, o pagamento NÃO é canonical settled — settling ≠ settled."
		}]
		relatedTerms: ["term-pagamento", "term-payment-state", "term-bank-transfer-ref"]
		domainModelRefs: ["cmd-initiate-bank-transfer"]
		layerMapping: {
			codeTerm: "BankTransfer"
			apiTerm:  "bank_transfers"
			uiLabel:  "Transferência Bancária"
		}
	}, {
		code:       "term-bank-transfer-ref"
		name:       "BankTransferRef"
		termEn:     "Bank Transfer Reference"
		definition: "Identificador BKR-side da transferência bancária. Gerado por BKR ao receber InitiateBankTransfer e propagado de volta na confirmação. No FCE, é a ref que discrimina ownership entre payment e compensation: o aggregate (agg-payment ou agg-financial-compensation) que possui a ref aceita o command derivado de BankSettlementConfirmedReceived; aggregate sem ownership registra no-op auditável."
		category:   "value"
		rationale:  "BankTransferRef merece termo canônico porque é o mecanismo de routing entre os dois aggregates do FCE quando BKR confirma settlement. Sem termo explícito, a discriminação ownership-based dilui em prosa de policies. Cross-BC reference: BKR é SoT da liquidação física; FCE preserva sem modificar."
		relatedTerms: ["term-transferencia-bancaria", "term-pagamento", "term-compensacao-financeira"]
		domainModelRefs: ["vo-bank-transfer-ref"]
		layerMapping: {
			codeTerm: "BankTransferRef"
			apiTerm:  "bank_transfer_ref"
			uiLabel:  "Ref BKR"
		}
	}, {
		code:       "term-compensacao-financeira"
		name:       "Compensação Financeira"
		termEn:     "Financial Compensation"
		definition: "Lifecycle de execução de movimento financeiro corretivo já ordenado por DRC via FinancialCompensationOrdered. Estados lineares: ordered (recebida) → executing (InitiateBankTransfer emitido) → recorded (BKR confirmou e ledger event registrado). FCE não decide mérito, causa, responsabilidade nem valor — todos esses atributos vêm imutáveis da ordem upstream. Lifecycle puramente financeiro."
		category:   "entity"
		rationale:  "Compensação Financeira merece termo canônico porque é consistency boundary separado de Pagamento, com trigger e semântica distintos. A disciplina 'FCE executa, não decide' é crítica para a boundary contra DRC — sem termo explícito, agentes tendem a embutir lógica de disputa dentro do FCE."
		antiTerms: [{
			term:          "Estorno"
			clarification: "Estorno implica reversão da transação original. Compensação Financeira é movimento novo rastreável (refund via FinancialCompensationOrdered), não mutação retroativa do pagamento original (bd-post-settle-immutability)."
		}, {
			term:          "Reembolso (Refund)"
			clarification: "Reembolso é uma das formas de compensação. Compensação Financeira é o termo guarda-chuva que inclui refunds mas também outras movimentações corretivas determinadas por DRC."
		}]
		examples: [{
			context:  "Refund pós-settlement"
			instance: "Pagamento já em settled; DRC resolve disputa em favor do pagador. DRC emite FinancialCompensationOrdered. FCE cria FinancialCompensation em ordered, executa via novo InitiateBankTransfer (movimento reverso), registra ledger event de tipo compensation preservando proveniência dispute-driven."
		}]
		relatedTerms: ["term-pagamento", "term-ledger-event", "term-transferencia-bancaria"]
		domainModelRefs: ["agg-financial-compensation", "inv-compensation-respects-drc-decision"]
		layerMapping: {
			codeTerm: "FinancialCompensation"
			apiTerm:  "financial_compensations"
			uiLabel:  "Compensação"
		}
	}, {
		code:       "term-payment-settled-event"
		name:       "Pagamento Liquidado"
		termEn:     "Payment Settled"
		definition: "Evento de domínio publicado quando o payment atinge o estado terminal settled após BankSettlementConfirmed observado de BKR. Sinal canônico de saída do FCE consumido por REW (retroalimenta risco), SCF (fecha antecipação), ATO (lançamento contábil em modo conformist) e TCM (converte projeção em posição realizada)."
		category:   "event"
		rationale:  "Pagamento Liquidado é o evento cross-BC mais importante do FCE — sinaliza que dinheiro efetivamente se moveu fisicamente. Merece termo canônico porque é o ponto único onde múltiplos BCs downstream agem. A distinção settling vs settled (bd-settled-after-bkr) é mediada exatamente por este evento."
		relatedTerms: ["term-pagamento", "term-payment-state", "term-ledger-event"]
		domainModelRefs: ["evt-payment-settled"]
		layerMapping: {
			codeTerm: "PaymentSettled"
		}
	}, {
		code:       "term-payment-obligation-defaulted-event"
		name:       "Obrigação de Pagamento Inadimplida"
		termEn:     "Payment Obligation Defaulted"
		definition: "Evento de domínio publicado quando o payment atinge o estado terminal defaulted — falha operacional não recuperável após elegibilidade autorizada (timeout, falha persistente de rail sem confirmação BKR). Consumido apenas por REW para alimentar modelos de risco. Distinto semanticamente de aborted (encerramento intencional pré-emissão, sem impacto em score)."
		category:   "event"
		rationale:  "Sinal canônico de falha terminal — informa REW sobre comportamento financeiro adverso da contraparte. Publicado apenas para REW (não para TCM/ATO/SCF) porque default não gera lançamento contábil de liquidação: é marcador, não movimento financeiro. Merece termo canônico separado de Pagamento Liquidado por simetria semântica (falha vs sucesso) e por escopo de consumo (1 consumer vs 4)."
		antiTerms: [{
			term:          "Cancelamento de Pagamento"
			clarification: "Cancelamento (aborted) é intencional e ocorre pré-emissão de InitiateBankTransfer, sem impacto em score. Inadimplência (defaulted) é falha operacional pós-elegibilidade — deteriora score REW."
		}]
		relatedTerms: ["term-pagamento", "term-payment-state"]
		domainModelRefs: ["evt-payment-obligation-defaulted"]
		layerMapping: {
			codeTerm: "PaymentObligationDefaulted"
		}
	}]

	rationale: """
		Glossário do FCE com 12 termos centrais cobrindo a ontologia operacional do
		BC: 1 entity principal (Pagamento), 1 entity-as-projection (Ledger), 1 entity
		de boundary com DRC (Compensação Financeira); 3 valores canônicos (PaymentId,
		Estado do Pagamento, BankTransferRef); 2 rules (PrePaymentGuard como gate
		central, Atomicidade da Financialization como invariante de acoplamento SCF);
		1 process operacional (Transferência Bancária); 3 events (Ledger Event como
		fato append-only; Pagamento Liquidado e Obrigação de Pagamento Inadimplida
		como sinais terminais cross-BC).

		Decisões deliberadas de ontologia:
		- Ledger entra como entity apesar de implementado como projection no
		  domain-model. UL modela conceito operacional percebido pelo negócio e
		  regulador, não aggregate boundary. Evita "aggregate leakage" para a
		  linguagem ubíqua.
		- Ledger Event entra como event apesar de VO no schema — semântica temporal
		  append-only domina a classificação ontológica.
		- Transferência Bancária entra como process apesar de command no schema —
		  fenômeno operacional inclui a janela settling, não apenas a emissão
		  pontual de InitiateBankTransfer.
		- Estados do pagamento (settling, settled, defaulted, aborted) não
		  fragmentam em terms independentes — distinções semânticas críticas
		  vivem na definition de term-payment-state, preservando densidade
		  semântica do UL.
		- Invariants secundárias (ledger-immutability, post-settle-immutability,
		  bank-transfer-supervision) não viram terms separados — são propriedades
		  das entidades canônicas (Ledger, Pagamento, Transferência Bancária),
		  não conceitos independentes.
		- PrePaymentGuard preserva nome PascalCase (não traduzido) por ser
		  conceito proprietário do FCE com identidade técnica e de domínio
		  simultaneamente. Disciplina central: o gate é interno ao FCE; REW
		  fornece input via CreditEligibilityDecided, não é o gate.
		- Compensação Financeira ancora a disciplina de boundary "FCE executa,
		  não decide" — a inv-compensation-respects-drc-decision se materializa
		  no UL como termo cuja definition explicitamente proíbe FCE de revisar
		  mérito, causa, responsabilidade ou valor.

		Cobertura cross-artifact:
		- 2 aggregates do domain-model cobertos: agg-payment (term-pagamento),
		  agg-financial-compensation (term-compensacao-financeira) — tq-gl-04 warn.
		- 4 invariants canônicas referenciadas via domainModelRefs:
		  inv-payment-evidence-required, inv-financialization-atomicity,
		  inv-compensation-respects-drc-decision (todas em terms relevantes).
		- 2 events published e 1 evento interno (Ledger Event) referenciados.
		- 2 commands referenciados: cmd-evaluate-pre-payment-guard (anchored em
		  term-pre-payment-guard) e cmd-initiate-bank-transfer (anchored em
		  term-transferencia-bancaria).
		- Distinção CommitmentId (CMT, cross-BC) vs PaymentId (FCE, local)
		  preservada em antiTerms — vetor de confusão recorrente eliminado por
		  construção da UL.

		Lenses aplicadas:
		- lens-domain-language-and-terminology-design (primária): bilingual
		  mapping pt-BR/en, term selection criteria (rejectedAlternatives em
		  term-pre-payment-guard), cross-layer consistency (layerMapping em 8
		  termos).
		- lens-contractual-and-legal-architecture (secundária): precisão jurídica
		  do conceito de inadimplência (Obrigação de Pagamento Inadimplida) e
		  da imutabilidade do ledger (Ledger Event como fato append-only).
		"""
}
