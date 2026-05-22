package fce

// canvas.cue — Bounded Context Canvas: Financial Commitment Execution.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// FCE é o orquestrador da execução financeira de compromissos.
// Recebe sinais upstream de INV (fatura), REW (elegibilidade de risco),
// DRC (decisões de disputa), BKR (confirmação de settlement) e TCM
// (disponibilidade financeira). Publica sinais de pagamento para
// REW (comportamento), SCF (antecipação), ATO (contabilidade) e
// TCM (posição realizada).

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

canvas: artifact_schemas.#Canvas & {
	code: "fce"
	name: "Financial Commitment Execution"

	purpose: """
		FCE executa e reconcilia obrigações financeiras cristalizadas pelo
		commitment lifecycle (CMT/CTR/P2P): orquestra settlement, ledger events,
		holds/releases e receivables. Não define sourcing, entrega, risco ou
		pricing — consome decisões de INV, REW e DRC, publica eventos
		financeiros para REW, SCF, ATO e TCM, e delega liquidação física a BKR.
		"""

	ubiquitousLanguageRef: "contexts/fce/glossary.cue"

	// ==============================
	// CLASSIFICAÇÃO ESTRATÉGICA
	// ==============================

	classification: {
		subdomainType:    "core"
		businessRole:     "operational-enabler"
		wardleyEvolution: "custom"
		rationale: """
			Core porque a vinculação causal operação→pagamento e o
			PrePaymentGuard são proprietários da Mesh — eliminam a separação
			entre operação e liquidação financeira que existe na cadeia
			tradicional. Operational-enabler porque FCE não origina o fluxo
			financeiro (CMT formaliza o compromisso que origina): habilita
			execução financeira a ocorrer sob invariante "dinheiro só se move
			com evidência". Custom porque o problema (settlement orquestrado)
			é compreendido, mas a solução acoplada a evidência operacional
			(DLV) e a elegibilidade de risco (REW) é proprietária — não há
			padrão de mercado para financialization all-or-nothing condicionada
			a milestones operacionais verificáveis.
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Mecanismos centrais do FCE — gates determinísticos
			(PrePaymentGuard), payment state machine, financialization
			all-or-nothing, ledger events com vinculação causal, holds e
			releases condicionados a evidência — são primitivas universais
			de execução financeira B2B, reaproveitáveis em qualquer cadeia
			produtiva que rastreie compromisso→pagamento. Verticalização
			entra a montante (CTR/P2P/SSC modelam termos e sourcing por
			vertical) e na natureza da evidência operacional (DLV define o
			que conta como execução verificada para cada vertical). FCE
			consome os resultados desses BCs sem refletir vocabulário de
			vertical no próprio modelo: settlement de obra em construção
			civil e settlement de carga em logística usam a mesma máquina.
			"""
	}

	// ==============================
	// DOMAIN ROLES
	// ==============================

	domainRoles: {
		primary: "execution"
		secondary: ["gateway"]
		rationale: """
			Execution como primário: FCE opera a payment state machine como
			SoT do pagamento e orquestra a financialization all-or-nothing —
			papel central é executar movimentos de dinheiro sob invariante,
			não modelar, não decidir risco, não liquidar fisicamente.
			Gateway como secundário: PrePaymentGuard é gate determinístico
			que precede qualquer settlement — sem elegibilidade de risco
			(REW) e fatura válida (INV), o pagamento não atravessa. O gate
			é tão central à fronteira de entrada que merece archetype, mas
			não compete com execution pelo papel primário.
			"""
	}

	// ==============================
	// CAPABILITIES
	// ==============================

	capabilities: {
		operational: [{
			capabilityRef: "cc-01"
			description: """
				Liberação financeira vinculada a evidência: cada movimento de
				dinheiro é condicionado a evidência operacional verificável
				(milestones de execução em DLV, fatura válida em INV,
				elegibilidade de risco em REW). FCE materializa a invariante
				"dinheiro só se move com evidência" via gates determinísticos
				no ponto de pagamento.
				"""
			rationale: "cc-01 é a capability que justifica a existência do FCE — sem vinculação a evidência, settlement degenera em instrução manual desacoplada da operação."
		}, {
			capabilityRef: "cc-03"
			description: """
				Operação 24/7 do payment lifecycle: FCE processa
				elegibilidade, holds, releases e settlement sem latência
				humana, com gates determinísticos validando invariantes a
				cada transição. Compromisso pode atingir estado pagável a
				qualquer hora — pagamento executa imediatamente sob gate,
				sem depender de revisão manual de tesouraria quando os
				gates já estão satisfeitos.
				"""
			rationale: "cc-03 elimina o alongamento do ciclo do fornecedor (ce-06) ao remover latência humana entre operação verificada e pagamento liberado."
		}, {
			description: """
				Vinculação causal operação→pagamento como ledger: FCE
				registra ledger events que mantêm rastreabilidade
				end-to-end entre CommitmentId, evidência operacional e
				movimento financeiro. Reconciliação multi-sistema (ce-03)
				torna-se subproduto da execução — ATO, TCM e SCF
				reconciliam contra o ledger de FCE, não contra fontes
				concorrentes.
				"""
			rationale: "Capability local (não no catálogo cc-XX) — ledger como SoT financeiro é específico do FCE. Se recorrer cross-BC, candidata a promoção via ADR."
		}, {
			description: """
				Financialization all-or-nothing: quando antecipação via SCF
				é elegível, FCE orquestra atomicamente as movimentações
				(settlement original + repasse à IF financiadora) — falha em
				qualquer perna aborta toda a operação. Sem atomicidade,
				antecipação cria estados financeiros intermediários
				inconsistentes que SCF não consegue reconciliar.
				"""
			rationale: "Capability local — invariante operacional crítica para acoplamento com SCF. Atomicidade elimina classe inteira de falhas de reconciliação entre antecipação e settlement original."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// ==============================
	// COMUNICAÇÃO
	// ==============================

	communication: {
		inbound: [{
			type:          "event-consumer"
			sourceContext: "inv"
			event:         "InvoiceIssued"
			reaction:      "Inicia o pipeline de elegibilidade do pagamento — agente registra fatura no payment lifecycle e aciona o PrePaymentGuard consumindo elegibilidade de REW antes de qualquer movimento financeiro."
			description:   "INV é o gatilho canônico de execução financeira: fatura emitida vincula CommitmentId + evidência verificada (DLV), condições necessárias para FCE atuar."
		}, {
			type:          "event-consumer"
			sourceContext: "inv"
			event:         "InvoiceCancelled"
			reaction:      "Cancela settlement pendente pré-liquidação — agente aborta payment lifecycle e libera holds. Pós-settlement, cancelamento exige correção via DRC (não retroage em FCE)."
			description:   "Cancelamento dentro da janela fiscal é coberto por FCE; pós-settle vira responsabilidade de DRC para preservar contabilidade (ce-03)."
		}, {
			type:          "event-consumer"
			sourceContext: "rew"
			event:         "CreditEligibilityDecided"
			reaction:      "Materializa decisão do PrePaymentGuard — elegibilidade positiva autoriza progressão para hold/release; negativa bloqueia a fatura como inelegível até reavaliação."
			description:   "REW fornece input determinístico para o gate (invariante: dinheiro não move sem decisão de risco). Loop bidirecional com fce-to-rew."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "BankSettlementConfirmed"
			reaction:      "Confirma transição da payment state machine para settled — registra ledger event final e publica PaymentSettled para REW, SCF, ATO e TCM."
			description:   "Settlement só é canônico em FCE após confirmação de BKR; antes disso, estado é settling. BKR é SoT da liquidação física no rail."
		}, {
			type:          "event-consumer"
			sourceContext: "drc"
			event:         "DisputeResolved"
			reaction:      "Traduz decisão de disputa para operação financeira — pode reverter pagamento (refund), reter saldo, ou liberar pagamento previamente bloqueado por disputa em andamento."
		}, {
			type:          "event-consumer"
			sourceContext: "drc"
			event:         "FinancialCompensationOrdered"
			reaction:      "Executa pagamento de compensação determinado por DRC — fora do payment lifecycle normal; ledger event marca origem (dispute-driven)."
			description:   "Compensação é movimento financeiro de natureza distinta — não deriva de InvoiceIssued, mas de decisão de disputa. Ledger preserva proveniência."
		}, {
			type:        "query-surface"
			query:       "QueryPaymentSettlementStatus"
			returnType:  "PaymentSettlementStatus"
			description: "Expõe estado canônico do pagamento para SCF reconciliar operações de antecipação. Hybrid em fce-to-scf: complementa o evento PaymentSettled com leitura point-in-time quando SCF precisa do estado fora da janela de evento."
		}]
		outbound: [{
			type:    "event-publisher"
			trigger: "BankSettlementConfirmed recebido (BKR) — transição final da payment state machine para settled."
			event:   "PaymentSettled"
			consumers: ["rew", "scf", "ato", "tcm"]
			description: "Sinal canônico de liquidação realizada. REW retroalimenta risco com comportamento de pagamento; SCF fecha operação de antecipação; ATO registra lançamento contábil em modo conformist; TCM converte projeção em posição realizada."
		}, {
			type:    "event-publisher"
			trigger: "Compromisso entra em default — pagamento não executado dentro do prazo após elegibilidade autorizada, ou settlement falhou em rail sem recuperação."
			event:   "PaymentObligationDefaulted"
			consumers: ["rew"]
			description: "Sinal de comportamento financeiro adverso para alimentar modelos de risco. Default deteriora score da contraparte cross-BC e pode informar decisões futuras de elegibilidade em REW."
		}, {
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "bkr"
			command:         "InitiateBankTransfer"
			trigger:         "PrePaymentGuard aprovou e disponibilidade de caixa (TCM) confirmou — payment state machine transita para settling."
			description:     "Iniciação síncrona da liquidação física via rail bancário. Confirmação retorna assíncrona via BankSettlementConfirmed (bkr-to-fce é hybrid)."
		}, {
			type:          "query-dependency"
			targetContext: "tcm"
			query:         "QueryCashAvailability"
			purpose:       "Confirmar liquidez antes de transitar para settling — settlement sem caixa cria default operacional mesmo com PrePaymentGuard aprovado."
			description:   "BDG aprovou cobertura orçamentária (upstream de CMT) mas TCM mantém SoT de disponibilidade real. FCE não assume gestão de caixa — apenas consulta para sequenciar."
		}, {
			type:          "query-dependency"
			targetContext: "tcm"
			query:         "QueryCashForecast"
			purpose:       "Otimizar sequenciamento de múltiplos pagamentos elegíveis simultaneamente — agente prioriza dentro do horizonte projetado."
			description:   "Forecast informa políticas de sequenciamento. Não bloqueia execução — informa ordem."
		}]
		rationale: """
			Inbound: 6 event consumers cobrindo gatilho de execução (INV:
			InvoiceIssued/Cancelled), gate de risco (REW:
			CreditEligibilityDecided), confirmação de rail (BKR:
			BankSettlementConfirmed) e decisões de disputa (DRC:
			DisputeResolved, FinancialCompensationOrdered); 1 query-surface
			(QueryPaymentSettlementStatus) consumida por SCF para
			reconciliação de antecipação. Outbound: 2 event publishers
			(PaymentSettled para 4 consumidores, PaymentObligationDefaulted
			para REW), 1 command-invocation síncrona (InitiateBankTransfer
			para BKR) e 2 query-dependencies (QueryCashAvailability e
			QueryCashForecast para TCM). FCE é cross-context event-driven —
			não expõe command-handlers cross-BC. Toda execução é reativa
			a eventos sob gates determinísticos. Loop feedback fce-to-rew
			↔ rew-to-fce é o ciclo financeiro→risco→elegibilidade central.
			"""
	}

	// ==============================
	// DECISÕES DE NEGÓCIO
	// ==============================

	businessDecisions: [{
		id:           "bd-payment-invariant"
		decision:     "Dinheiro só se move quando operação comprova que deve se mover — PrePaymentGuard é gate determinístico inviolável: sem InvoiceIssued (INV) e CreditEligibilityDecided positivo (REW), nenhum InitiateBankTransfer é emitido."
		rationale:    "Invariante central da fusão CMT-DLV-FCE e razão de existência do FCE como BC separado. Sem este gate, execução financeira degenera em instrução de pagamento desacoplada da operação — o problema que a tese existe para resolver. PrePaymentGuard materializa o gate no ponto único onde dinheiro encontra evidência."
		consequences: "Toda execução passa por gate antes da iniciação de settlement. Introduz latência relativa a sistemas tradicionais (que pagam por instrução manual), mas elimina classe inteira de pagamentos sem lastro operacional e habilita auditoria automática (dp-10, ce-03). Casos de exceção (compensações DRC, refunds) precisam de gate equivalente próprio para não criar bypass."
	}, {
		id:           "bd-ledger-as-sot"
		decision:     "FCE mantém o ledger canônico de movimentos financeiros — ATO, TCM e SCF reconciliam contra ele, não contra extratos bancários ou fontes concorrentes."
		rationale:    "Sem SoT financeiro único, reconciliação multi-sistema (ce-03) reaparece em cada BC que toca dinheiro. Centralizar no executor — que possui o trigger, o gate e a confirmação — reduz drift e transforma reconciliação em subproduto da execução, não atividade separada."
		consequences: "ATO consome PaymentSettled em modo conformist (sem tradução fiscal-financeira); TCM lê ledger para posição realizada; SCF reconcilia antecipações contra ledger. BCs downstream perdem autonomia para manter SoT financeiro próprio — ganho de coerência, perda de paralelismo. Falhas de FCE bloqueiam reconciliação cross-BC; criticidade operacional alta."
	}, {
		id:           "bd-settled-after-bkr"
		decision:     "Estado \"settled\" é canônico apenas após BankSettlementConfirmed de BKR. Pré-confirmação, o estado é \"settling\" — visível via query-surface mas semanticamente distinto de settled para todos os consumidores."
		rationale:    "Sem essa distinção, FCE publicaria PaymentSettled antes da liquidação física, criando dessincronia com TCM (posição realizada), ATO (lançamento contábil) e SCF (reconciliação de antecipação). Confirmação de BKR é tratada como oracle canônico de movimento real no rail bancário dentro do boundary do FCE."
		consequences: "Janela \"settling\" exposta na query-surface; consumidores tratam settling ≠ settled. PaymentSettled só é publicado pós-ACK de BKR. Adiciona latência percebida (cliente vê \"settling\" antes de \"settled\"), mas preserva consistência cross-BC. Falha persistente de confirmação BKR mantém pagamento em settling indefinidamente — exige escalation criterion próprio."
	}, {
		id:           "bd-post-settle-immutability"
		decision:     "Após settlement confirmado, cancelamento ou reversão não retroage em FCE — vira disputa em DRC. InvoiceCancelled pós-settle não é coberto pelo payment lifecycle: o pagamento já existiu, só pode ser corrigido por nova movimentação rastreável (refund via FinancialCompensationOrdered)."
		rationale:    "Permitir mutação retroativa do ledger quebraria audit trail (dp-10) e duplicaria o papel do DRC. Imutabilidade pós-settle é o que torna o ledger consultável como fonte auditável e contábil — append-only, com proveniência preservada em cada movimento."
		consequences: "Cancelamento de fatura dentro da janela fiscal pré-settle: FCE aborta payment lifecycle e libera holds. Pós-settle: operador é redirecionado a abrir disputa em DRC, que pode emitir FinancialCompensationOrdered (refund rastreável com ledger event próprio). Aumenta complexidade do fluxo de cancelamento; ganho é rastreabilidade total e separação clara de responsabilidades."
	}]

	// ==============================
	// STAKEHOLDERS
	// ==============================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Pagador primário — submete o fluxo de compromissos cujos pagamentos FCE executa via PrePaymentGuard, ledger e InitiateBankTransfer a BKR."
		impactDescription: "Execução 24/7 sob gate elimina latência humana entre evidência verificada e pagamento. Imutabilidade pós-settle protege contra reversão arbitrária por contraparte."
		rationale:         "Construtora é tomadora de crédito e originadora dos compromissos que ativam o payment lifecycle. Sem visibilidade do estado de pagamento, perde controle sobre fluxo de caixa da obra."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Beneficiário direto — recebe PaymentSettled como sinal definitivo de liquidação, reconciliado contra o ledger canônico de FCE."
		impactDescription: "Redução do ciclo de recebimento (ce-06) materializa-se em FCE: evidência verificada (DLV) + fatura válida (INV) + elegibilidade (REW) ⇒ pagamento sob gate em horas, não dias. Antecipação SCF é coordenada com settlement original via financialization all-or-nothing."
		rationale:         "Fornecedor é quem mais sofre com assimetria informacional sobre pagamento. FCE como SoT financeiro dá visibilidade determinística do estado (pending, settling, settled)."
	}, {
		stakeholderRef:    "sh-03"
		roleInContext:     "Consumidor de PaymentSettled — reconcilia operações de antecipação (SCF) contra o ledger de FCE, sem manter SoT financeiro paralelo."
		impactDescription: "Ledger como SoT (bd-ledger-as-sot) reduz drasticamente due diligence manual sobre lastro. Funding partner audita portfólio em tempo real contra eventos de FCE — não espera reporting periódico."
		rationale:         "sh-03 fornece capital para antecipações SCF. Sem reconciliação determinística contra o ledger FCE, IF parceira recria contabilidade paralela — custo de transação que destrói o moat informacional."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulador — exige rastreabilidade end-to-end de cada movimento financeiro com responsabilidade jurídica identificável (dp-10) e auditoria contínua (cc-04)."
		impactDescription: "FCE como SoT financeiro com ledger imutável e ledger events vinculados a CommitmentId facilita demonstração computacional de requisitos prudenciais de SCD — reporting é projeção sobre o ledger, não atividade separada."
		rationale:         "Operar como SCD sem rastreabilidade total é ilegal (constraint nível 1). FCE é o BC onde a invariante dinheiro↔evidência é materializada — onde compliance regulatório é demonstrável computacionalmente."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Operador primário do payment lifecycle — recebe eventos upstream (INV, REW, BKR, DRC), executa PrePaymentGuard, sequencia pagamentos sob TCM, escala decisões fora do envelope autônomo."
		impactDescription: "Boundaries claras (gates determinísticos, autonomy envelope, escalation criteria) permitem operação 24/7 com auditabilidade. Agente não move dinheiro diretamente — propõe transições; gates determinísticos autorizam execução via infraestrutura bancária."
		rationale:         "Agente IA é operador primário (ax-01). Em FCE — onde falhas operacionais têm impacto monetário direto — boundaries explícitas são pré-condição de operação."
	}, {
		stakeholderRef:    "sh-06"
		roleInContext:     "Vetor adversarial canonical para modelagem defensiva — atacante econômico que explora janela settling↔settled, fracionamento, cancel-then-reissue laundering, ou coordena com sh-01/sh-02/sh-05 para induzir movimentos sem lastro."
		impactDescription: "Modelagem explícita de sh-06 força que cada vetor R4+++ tenha designResponse declarado em incentiveAnalysis. FCE expõe múltiplas superfícies de ataque (gate, ledger, query-surface, command-invocation a BKR) que exigem defesa em profundidade."
		rationale:         "Sem stakeholder adversarial explícito, FCE assume implicitamente que participantes são todos legítimos — premissa falsa para BC core financeiro. sh-06 introduzido em REW Phase 1 (WI-046); reusable cross-BC."
	}]

	// ==============================
	// CUSTOS ELIMINADOS
	// ==============================

	costsEliminated: [{
		costRef: "ce-03"
		contribution: """
			FCE elimina reconciliação multi-sistema ao ser SoT financeiro
			(bd-ledger-as-sot): ATO, TCM e SCF reconciliam contra o ledger
			de FCE — não contra extratos bancários, sistemas paralelos ou
			contabilidades concorrentes. Ledger events vinculam cada
			movimento a CommitmentId + evidência originária; reconciliação
			torna-se subproduto da execução, não atividade separada.
			"""
		rationale: "ce-03 é o custo eliminado por FCE de forma mais direta — sem ledger único, cada BC downstream financeiro recria reconciliação contra fontes externas, custo que cresce O(n²) com integrações."
	}, {
		costRef: "ce-05"
		contribution: """
			FCE executa pagamentos via SCD própria (mech-scd) — intermediário
			bancário não captura margem de intermediação sobre operações onde
			a Mesh já possui toda a informação (compromisso, evidência, risco).
			FCE é o BC onde a vantagem informacional acumulada (mech-network)
			materializa-se em custo menor de execução, repassado ao tomador
			(sh-01) como crédito mais barato.
			"""
		rationale: "ce-05 é eliminado especificamente em FCE — outros BCs constroem a informação, mas FCE é onde a execução interna via SCD substitui intermediação bancária. Sem FCE como BC dedicado, vantagem informacional não se converte em custo menor de execução."
	}, {
		costRef: "ce-06"
		contribution: """
			FCE elimina o alongamento do ciclo do fornecedor via cc-01
			(liberação evidence-bound) e cc-03 (operação 24/7): assim que
			evidência (DLV) + fatura (INV) + elegibilidade (REW) materializam,
			gate aprova e InitiateBankTransfer é emitido sem depender de
			revisão manual de tesouraria. Quando há antecipação SCF, a
			financialization all-or-nothing torna pagamento e cessão atômicos:
			fornecedor recebe imediato sem coordenação manual.
			"""
		rationale: "ce-06 é a dor mais aguda do fornecedor (sh-02) e driver primário de adoção. FCE é o BC que materializa a redução do ciclo — outros BCs constroem condições, FCE executa a transição evidência→dinheiro."
	}]

	// ==============================
	// ANÁLISE DE INCENTIVOS
	// ==============================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "pagador"
			desiredBehavior:           "Submeter pagamentos contra evidência real, com valores que refletem o escopo executado, sem fragmentar para evadir gates ou alongar holds para transferir custo de capital."
			correctOperationIncentive: "Pagamentos consistentes elevam reputação cross-network (sh-01 interage com sh-02 e sh-03), reduzindo prêmio de risco em operações futuras. Ciclo curto para fornecedor melhora retenção da base e poder de negociação."
			manipulationVector:        "Fracionar pagamentos em múltiplos sub-thresholds para evitar escalation (high-value-threshold), ou postergar settlement explorando a janela settling↔settled para alongar ciclo do fornecedor (transferência involuntária de custo de capital)."
			manipulationCost:          "Fracionamento é detectável por análise de padrão em REW (par sh-01↔sh-02 com múltiplos compromissos pequenos em janela curta) e por agregação em BDG. Alongamento de settling é monitorado por verification metric (settling→settled SLA) — desvio gera escalation e degrada score de pagamento (PaymentObligationDefaulted)."
			vsBenefit:                 "Benefício: evitar supervisão humana ou ganhar dias de float. Custo: detecção em REW + degradação de score que afeta crédito futuro (ce-05 deixa de comprimir margem de intermediação) + dano reputacional na rede que afeta ce-06 dos próprios fornecedores."
			designResponse:            "Detecção cross-BC: REW agrega por par de partes, BDG por escopo/contrato; settling SLA com escalation criterion. Gates determinísticos isolam decisão de pagamento de pressão humana; ledger imutável preserva proveniência cross-período."
			rationale:                 "sh-01 controla o trigger upstream (CMT/INV). Design response usa detecção sistêmica + custo reputacional cross-BC para tornar fracionamento e delay mais caros que pagamento normal."
		}, {
			stakeholderRef:            "sh-02"
			participantType:           "recebedor"
			desiredBehavior:           "Aceitar PaymentSettled como liquidação definitiva, sem disputar settlement confirmado por BKR salvo em casos legítimos."
			correctOperationIncentive: "Liquidações claras com ciclo curto (ce-06) são driver de adoção. Histórico de disputas spurious em DRC degrada score em REW, afetando elegibilidade futura para antecipação SCF (perde acesso a crédito de menor custo)."
			manipulationVector:        "Aceitar antecipação SCF e disputar settlement original em DRC (claim de não-recebimento) para receber duas vezes. Variante: explorar janela settling↔settled afirmando 'pagamento não chegou' enquanto BKR ainda está confirmando."
			manipulationCost:          "BankSettlementConfirmed é oracle independente (BKR) — disputa contra confirmação requer evidência contra rail bancário, território de fraude documental criminal (dp-10). Ledger imutável + QueryPaymentSettlementStatus expõem estado canônico verificável por sh-03 e DRC. Score em REW deteriora cross-network."
			vsBenefit:                 "Benefício: receber valor duplicado em casos isolados. Custo: detecção por BKR + reconciliação cross-BC (SCF, ATO) + tipificação penal por fraude + perda de acesso a antecipação SCF (custo de capital sobe via mercado externo)."
			designResponse:            "BKR como oracle de movimento físico; settling vs settled explícito na query-surface; ledger preservando proveniência de cada perna (settlement original + cessão SCF); financialization all-or-nothing evita estados intermediários exploráveis."
			rationale:                 "Receiver-side fraud é vetor clássico. Design response empurra detecção para oracle externo (BKR) e cria custo reputacional cross-BC superior ao benefício de duplo recebimento."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "operador-plataforma"
			desiredBehavior:           "Processar eventos (InvoiceIssued, CreditEligibilityDecided, BankSettlementConfirmed) na ordem de chegada e sob critérios determinísticos, sem favoritismo de sequenciamento, omissão seletiva ou priorização extra-envelope."
			correctOperationIncentive: "Sequenciamento imparcial mantém fairness da plataforma — driver de retenção (dp-02 health metric). Favoritismo detectado degrada credibilidade da Mesh como intermediário neutro e gera responsabilidade jurídica para o operador (dp-10)."
			manipulationVector:        "Favoritismo no sequenciamento quando há restrição de caixa (TCM) — priorizar pagamentos a fornecedores preferidos por sh-01 em detrimento de outros. Omissão seletiva: atrasar processamento de InvoiceIssued de fornecedores específicos. Bias intra-envelope autônomo que não viola gates mas degrada fairness."
			manipulationCost:          "Event Log registra timestamps de cada ato do agente; verification metric (CV de latência por par sh-01↔sh-02) torna desvio detectável por REW. Gates determinísticos validam invariantes independentemente do agente — bias não bypassa PrePaymentGuard. Decisões supervisionadas (high-value, regulatory ambiguity) saem do envelope autônomo."
			vsBenefit:                 "Benefício: favoritismo retém cliente preferencial. Custo: detecção estatística em REW + responsabilidade jurídica do operador da plataforma + dano cross-BC à reputação da Mesh como infraestrutura neutra."
			designResponse:            "mech-agent-gate (agente propõe, gate valida); Event Log com timestamps (mech-evidence); autonomy envelope explícito com escalation criteria; verification metric de fairness operacional. Risco residual: bias sutil intra-envelope detectável apenas post-facto — gap declarado em openQuestion sobre alignment proativo (cross-BC com oq-cmt-4)."
			rationale:                 "Agente IA tem poder assimétrico sobre o sequenciamento. Design response separa stocástico (agente) de determinístico (gate) + detecção temporal + escalação para decisões consequentes."
		}, {
			stakeholderRef:            "sh-06"
			participantType:           "adversário-econômico"
			desiredBehavior:           "Sistema deve tornar exploração economicamente irracional — sh-06 abandona quando vetores R4+++ conhecidos têm custo > benefício extraível."
			correctOperationIncentive: "Residual: sh-06 desiste quando custos cumulativos de manipulação (detecção multi-camada + reputação cross-network + tipificação penal) excedem benefício pontual extraível por vetor."
			manipulationVector:        "Vetores R4+++ específicos a FCE: (a) value concentration — concentrar pagamentos em valor logo abaixo de thresholds de escalação; (b) cancel-then-reissue laundering — usar InvoiceCancelled pré-settle + nova InvoiceIssued para confundir trilha de proveniência; (c) delay attack — induzir disputa fictícia em DRC para forçar hold prolongado em compromissos correlatos; (d) settling exploitation — atacar pagamentos durante janela settling para forçar timeout ou inconsistência."
			manipulationCost:          "(a) detecção por agregação cross-período em REW; (b) ledger preserva proveniência cross-cancellation, vinculação CommitmentId torna laundering rastreável; (c) DRC tem custo próprio de abertura de disputa + reputational decay; (d) settling SLA com escalation + BKR como oracle independente. Combinações requerem coordenação multi-actor — sh-06 tipicamente isolado."
			vsBenefit:                 "Benefício depende do vetor — valor extraível por cancel-then-reissue é limitado ao gap pré-detecção (horas a dias). Custo cumulativo: detecção multi-camada (REW agrega + ledger preserva + BKR confirma) + pode degradar reputação cross-network."
			designResponse:            "Defesa em profundidade: ledger imutável com proveniência cross-cancellation; settling vs settled como estado de primeira classe; cross-BC analytics (REW + DRC + BDG + INV) para detectar padrões adversariais R4+++; escalation criteria com threshold dinâmico contra value concentration."
			rationale:                 "FCE é alvo de alto valor (state-change financeiro direto). Modelagem explícita de sh-06 com designResponse para cada vetor R4+++ específico do BC torna defesa auditável — não premissa implícita."
		}, {
			stakeholderRef:            "sh-01"
			participantType:           "coalizão-pagador-operador"
			desiredBehavior:           "Pagador e operador interagem sob políticas determinísticas (gates, queue temporal, observabilidade de fairness) sem coordenação fora da governance scope do agente."
			correctOperationIncentive: "Operação imparcial preserva confiança de todos os participantes. Coalizão detectada gera responsabilidade jurídica conjunta (sh-01 + sh-05 + operador da plataforma) sob dp-10."
			manipulationVector:        "sh-01 (pagador) coordena com sh-05 (agente) para priorização sistemática de fornecedores preferidos em detrimento de outros, dentro do envelope autônomo do agente. Coalizão é satisfeita por design: agente processa, sh-01 se beneficia da retenção de fornecedores estratégicos, fornecedores preteridos não percebem viés pontual."
			manipulationCost:          "Detecção cross-período em REW: CV de latência por par sh-01↔sh-02 e por sh-02 individual revela bias estatístico. Event Log preserva timestamps de cada decisão de sequenciamento. Decisões supervisionadas (high-value, fora do envelope) saem da coalizão. Responsabilidade jurídica conjunta agrava custo individual."
			vsBenefit:                 "Benefício: retenção de fornecedores estratégicos por velocidade preferencial. Custo: detecção estatística em REW + degradação reputacional cross-BC + responsabilidade jurídica conjunta + perda de status como participante preferido na Mesh."
			designResponse:            "Agent governance scope explícito separa decisões autônomas (sequenciamento dentro de queue temporal) de supervisionadas (override de prioridade). Verification metric de fairness operacional detecta bias estatístico que viole padrão temporal. Gap declarado (openQuestion sobre alignment proativo) — detecção é post-facto, não prevenção."
			rationale:                 "Coalizão pagador-operador é vetor distinto de coalizão pagador-recebedor (CMT-level). FCE-specific porque sh-05 controla queue temporal sob restrição TCM. Design response usa detecção temporal + escalação + responsabilidade conjunta para tornar coalizão mais cara que operação imparcial."
		}]
		rationale: """
			Análise cobre 5 participantes em 5 classes de vetor: (a) payer
			manipulation — fracionamento e delay (sh-01); (b) receiver
			manipulation — duplo recebimento via disputa (sh-02); (c) agent
			misalignment — favoritismo de sequenciamento (sh-05); (d) adversarial
			baseline — vetores R4+++ canonical (sh-06); (e) coalizão
			pagador-operador (sh-01 + sh-05). O design busca tornar custos
			cumulativos superiores aos benefícios esperados via combinação de
			oracle externo (BKR), SoT imutável (ledger), detecção cross-BC
			(REW + DRC + BDG + INV), gates determinísticos (mech-agent-gate) e
			responsabilidade jurídica explícita (dp-10). Riscos residuais
			declarados: bias sutil intra-envelope do agente (gap em alignment
			proativo, cross-BC com oq-cmt-4), janela settling↔settled como
			superfície adversarial, e combinações multi-actor R4+++ que exigem
			detecção heurística cross-período em REW.
			"""
	}

	// ==============================
	// OWNERSHIP & GOVERNANCE
	// ==============================

	ownership: {
		domainAgentSpec: "contexts/fce/agents/fce-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "evaluate-pre-payment-guard"
				description: "Avaliar invariantes determinísticas do PrePaymentGuard contra InvoiceIssued recebida — verificar coerência entre CommitmentId, InvoiceIssued e elegibilidade vigente; presença de CreditEligibilityDecided positivo (REW) e disponibilidade em TCM."
				rationale:   "Gate é determinístico — invariantes são checagens computáveis sem julgamento. Resultado positivo libera transição para eligible; negativo bloqueia até reavaliação."
			}, {
				id:          "advance-payment-state"
				description: "Transitar a payment state machine em resposta a eventos verificáveis (InvoiceIssued, CreditEligibilityDecided, BankSettlementConfirmed) e a checagens internas: pending → eligible → settling → settled, ou ramos alternativos defaulted/aborted."
				rationale:   "Transições seguem regras determinísticas vinculadas a eventos verificáveis e às invariantes da state machine declaradas no profile estratégico. Sem margem para julgamento."
			}, {
				id:          "record-ledger-event"
				description: "Registrar ledger events imutáveis em cada transição da state machine — append-only no Event Log, com vinculação a CommitmentId, evidência originária e timestamp."
				rationale:   "Registro de fatos é append-only e determinístico. Sem margem para erro de julgamento. Ledger é SoT financeiro (bd-ledger-as-sot)."
			}, {
				id:          "abort-pre-settle-cancel"
				description: "Abortar payment lifecycle ao receber InvoiceCancelled de INV antes de BankSettlementConfirmed — liberar holds, registrar abort no ledger e notificar consumers."
				rationale:   "Reação determinística a evento upstream dentro da janela coberta. Pós-settle, cancellation vira responsabilidade de DRC (bd-post-settle-immutability) — não autônomo em FCE."
			}]
			supervisedDecisions: [{
				id:          "initiate-bank-transfer"
				description: "Aprovar emissão de InitiateBankTransfer a BKR após gate aprovado e caixa confirmada — passo onde dinheiro deixa controle da plataforma e movimenta no rail bancário."
				rationale:   "InitiateBankTransfer move dinheiro real e é irreversível pós-settlement (bd-post-settle-immutability). Supervisionada integralmente até definição de threshold de autonomia (openQuestion); abaixo do threshold definido, ação torna-se autônoma dentro do envelope."
			}, {
				id:          "execute-financial-compensation"
				description: "Executar pagamento de compensação derivado de FinancialCompensationOrdered (DRC) — refund, reembolso ou movimento corretivo fora do payment lifecycle normal."
				rationale:   "Compensação é movimento de natureza distinta — não deriva do gate INV+REW+TCM, mas de decisão jurídica em DRC. Requer aprovação humana para validar coerência entre decisão DRC e execução financeira."
			}, {
				id:          "resolve-prolonged-settling"
				description: "Decidir entre retry, escalate ou default para pagamentos cujo settling state excedeu SLA — BKR não confirmou após múltiplos retries dentro da janela."
				rationale:   "Settling prolongado pode ser falha técnica recuperável (retry) ou problema fundamental no rail (escalate/default). Julgamento exige consideração de causa raiz e impacto cross-BC (TCM, SCF, ATO ficam em estado pendente)."
			}]
			escalationCriteria: [{
				id:        "high-value-threshold"
				condition: "Valor do pagamento excede threshold de autonomia definido no envelope (per vertical ou per contraparte)."
				action:    "Escalar ao humano designado para aprovação antes de emitir InitiateBankTransfer."
				rationale: "Pagamentos de alto valor têm blast radius proporcional. Supervisão humana é controle de contenção (conflictResolution nível 2). Threshold pendente em openQuestion."
			}, {
				id:        "regulatory-ambiguity"
				condition: "Pagamento envolve regime fiscal não coberto, cross-border, ou estrutura que cai em zona cinza regulatória da SCD."
				action:    "Escalar ao compliance officer para parecer antes de prosseguir com initiate-bank-transfer."
				rationale: "Integridade legal é constraint inviolável (conflictResolution nível 1). Zona cinza exige julgamento humano especializado — não automatizável."
			}, {
				id:        "rail-failure-prolonged"
				condition: "BKR falha em confirmar settlement após N retries dentro da janela settling→settled SLA, sem padrão claro de causa raiz recuperável."
				action:    "Escalar ao humano para diagnóstico de causa raiz (rail, contraparte, configuração) e decisão entre retry, default ou settlement manual."
				rationale: "Settling prolongado bloqueia o ledger e afeta reconciliação cross-BC. Decisão tem impacto cross-período e requer julgamento sobre confiabilidade do rail."
			}, {
				id:        "value-concentration-pattern"
				condition: "Detecção em REW de padrão de fracionamento ou value concentration logo abaixo de threshold (sh-01 ou sh-06 vector) cross-período."
				action:    "Suspender autonomia de initiate-bank-transfer para o par identificado até revisão; escalar ao founder + compliance officer para avaliação de manipulação."
				rationale: "Anti-gaming defensive — value concentration é vetor R4+++ explicitamente modelado (sh-06 incentiveAnalysis). Resposta defensiva é interromper autonomia até verificação humana."
			}]
		}
		rationale: """
			fce-primary-agent como operador, referenciado por path canônico
			(contexts/fce/agents/fce-primary-agent.cue) — SoT local do BC.
			O context map replica este identificador para visão global; em
			caso de drift, o canvas prevalece. 4 decisões autônomas (avaliação
			do gate, transição da state machine, registro de ledger events,
			abort pré-settle), 3 decisões supervisionadas (initiate-bank-transfer,
			financial compensation, resolução de settling prolongado) e 4
			critérios de escalação (high-value, regulatory ambiguity, rail
			failure, value concentration). Boundaries refletem mech-agent-gate
			(agente propõe, gate valida, humano aprova decisões com impacto
			financeiro irreversível) e a posição estratégica de FCE como BC
			mais protegido do Wave 0 (subdomain registry) — falhas no BC têm
			impacto monetário direto. initiate-bank-transfer é supervisionado
			integralmente até definição de threshold de autonomia; após
			threshold definido, abaixo dele torna-se autônomo dentro do envelope.
			"""
	}

	// ==============================
	// ESTADO EPISTÊMICO
	// ==============================

	assumptions: [{
		id:                 "as-fce-1"
		assumption:         "PrePaymentGuard com invariantes determinísticas (InvoiceIssued válida + CreditEligibilityDecided positivo + caixa em TCM) é suficiente para materializar a invariante 'dinheiro só se move com evidência'."
		invalidationSignal: "Surgimento de classe de fraude que satisfaz gate mas é fraudulenta — e.g., evidência fabricada que passa integridade criptográfica mas é mentirosa na origem (ataque at-06 do domain-definition)."
		rationale:          "Gate determinístico assume que upstream (DLV verification, INV faturamento, REW elegibilidade) entrega verdade verificável. Se upstream pode ser fraudado e gate não detecta, FCE lastreia execução em ficção. Mitigação parcial: cross-BC analytics em REW + responsabilidade jurídica (dp-10). Risco residual reconhecido em at-06."
	}, {
		id:                 "as-fce-2"
		assumption:         "Latência média de BankSettlementConfirmed por rail (PIX, TED, boleto, SWIFT) é compatível com SLA aceitável de settling→settled."
		invalidationSignal: "Latência de BankSettlementConfirmed consistentemente acima do SLA por rail, ou indisponibilidade frequente do rail bancário, mantendo pagamentos em settling indefinidamente e bloqueando reconciliação cross-BC."
		rationale:          "A distinção settling vs settled (bd-settled-after-bkr) assume janela curta o suficiente para não criar pressão de reconciliação em TCM/ATO/SCF. Se rail é lento ou instável, a distinção vira fonte de inconsistência percebida. Mitigação: rail-failure-prolonged escalation criterion + verification metric por rail."
	}, {
		id:                 "as-fce-3"
		assumption:         "TCM como SoT de disponibilidade financeira está disponível com latência aceitável para QueryCashAvailability e QueryCashForecast sync."
		invalidationSignal: "Latência de QueryCashAvailability consistentemente acima de SLA ou indisponibilidade frequente de TCM, forçando degradação para fallback (assumir caixa disponível ou bloquear todas as transferências)."
		rationale:          "Decisão de transitar para settling depende de query sync a TCM. Se TCM não é confiável, FCE precisa de estratégia de resiliência — defina no Architecture Communication Canvas."
	}, {
		id:                 "as-fce-4"
		assumption:         "Ledger como SoT financeiro escala horizontalmente sob volume crescente sem degradação em append nem em QueryPaymentSettlementStatus (dp-06)."
		invalidationSignal: "Latência de registro de ledger event ou de QueryPaymentSettlementStatus cresce não-linearmente com volume de operações, evidenciando ponto de saturação na arquitetura do SoT."
		rationale:          "FCE como SoT centraliza reconciliação (bd-ledger-as-sot). Se SoT não escala, criticidade vira gargalo cross-BC. Mitigação: dp-06 deve ser materializado no Architecture Communication Canvas."
	}]

	openQuestions: [{
		id:        "oq-fce-1"
		question:  "Qual o threshold de valor para autonomia de initiate-bank-transfer? Como definir thresholds por vertical e por contraparte?"
		impact:    "Sem threshold definido, toda execução de InitiateBankTransfer requer supervisão humana, eliminando o benefício de operação 24/7 (cc-03) e o ganho de ce-06. Bloqueante para autonomy envelope expansion."
		deadline:  "2026-06-01"
		rationale: "Threshold deve ser calibrado com dados reais e perfil de risco por vertical. Paralelo a oq-cmt-1 (CMT) e oq-cmt-5 (fracionamento detection) — devem ser resolvidos coordenadamente."
	}, {
		id:        "oq-fce-2"
		question:  "Qual o settling→settled SLA aceitável por rail (PIX, TED, boleto, SWIFT)? Como sequenciar pagamentos para minimizar exposição à janela settling?"
		impact:    "Sem SLA por rail, rail-failure-prolonged escalation criterion não tem trigger objetivo. Pagamentos em settling indefinido bloqueiam reconciliação cross-BC (TCM, ATO, SCF) e degradam confiança no ledger como SoT."
		deadline:  "2026-05-15"
		rationale: "SLA por rail é calibração técnica + operacional. Cada rail pode ter latência, disponibilidade e confirmação distintas; os targets devem ser calibrados antes da operação 24/7 em produção."
	}, {
		id:        "oq-fce-3"
		question:  "Como implementar detecção de value concentration (REW) que esteja operacional antes ou simultaneamente à definição do threshold de autonomia (oq-fce-1)?"
		impact:    "Threshold sem detecção de value concentration cria incentivo imediato para fracionamento (vetor sh-01 + sh-06). Sistema teria vulnerabilidade conhecida e incentivo econômico para explorá-la no mesmo momento."
		deadline:  "2026-06-01"
		rationale: "Dependência temporal: oq-fce-3 deve ser resolvido no mesmo timeline de oq-fce-1. Cross-BC com oq-cmt-5 (fracionamento detection em CMT). REW precisa expor analytics agregado por par sh-01↔sh-02 cross-período."
	}, {
		id:        "oq-fce-4"
		question:  "Como implementar agent alignment proativo em FCE — métricas de fairness no sequenciamento, penalização por desvio estatístico, feedback loop REW→comportamento do agente?"
		impact:    "Sem alignment proativo, agente pode operar 'no limite do aceitável' dentro do envelope autônomo (favoritismo de sequenciamento sob restrição TCM) sem violar gates, degradando fairness sistematicamente. Detecção via Event Log é post-facto — dano à confiança já ocorreu."
		deadline:  "2026-07-01"
		rationale: "Diferença entre sistema que detecta viés e sistema que previne viés. Cross-BC com oq-cmt-4 — pattern aplicável a todo agente primário da Mesh."
	}, {
		id:        "oq-fce-5"
		question:  "Como tratar CreditEligibilityRevoked? REW publica CreditEligibilityDecided positivo mas não há evento de revogação mid-flight. Se elegibilidade é revogada após autorização e antes de BankSettlementConfirmed, FCE não tem mecanismo formal de notificação."
		impact:    "Pagamento elegível pode tornar-se inelegível durante a janela settling — atualmente FCE prossegue mesmo se REW revogou. Janela de exposição depende do rail (minutos a dias). Possível movimento financeiro sem elegibilidade vigente no momento do settlement."
		deadline:  "2026-05-15"
		rationale: "Gap no modelo de eventos REW→FCE. Coordenação cross-BC necessária: REW precisa publicar CreditEligibilityRevoked como evento canônico; FCE precisa reagir abortando ou suspendendo pagamento conforme estado. Não resolve fraude (premise as-fce-1), mas fecha brecha operacional."
	}]

	// ==============================
	// MÉTRICAS DE VERIFICAÇÃO
	// ==============================

	verificationMetrics: [{
		id:     "settling-to-settled-time"
		metric: "Tempo médio entre InitiateBankTransfer e BankSettlementConfirmed por rail"
		target: "Targets por rail pendentes de calibração em oq-fce-2; placeholder não-normativo até decisão formal."
		onBreach: {
			escalationRef: "rail-failure-prolonged"
			rationale:     "Excedente de SLA indica falha persistente no rail bancário ou na contraparte — não é variação operacional aceitável. Escalação dispara diagnóstico de causa raiz e decisão entre retry, default ou settlement manual."
		}
		rationale: "SLA por rail é métrica primária de saúde operacional. Mede tanto confiabilidade técnica quanto coerência da bd-settled-after-bkr."
	}, {
		id:     "value-concentration-detection-rate"
		metric: "Percentual de InitiateBankTransfer cujo valor está em janela ±5% do threshold de autonomia"
		target: "Target pendente de calibração após resolução de oq-fce-1 (threshold) e oq-fce-3 (REW detection); placeholder não-normativo até decisão formal."
		onBreach: {
			escalationRef: "value-concentration-pattern"
			rationale:     "Concentração acima do baseline é sinal estatístico de fracionamento ou value gaming (vetor sh-01 + sh-06). Escalação suspende autonomia do par e dispara revisão por compliance."
		}
		rationale: "Anti-gaming defensivo. Métrica é operacional apenas após oq-fce-1 (threshold) e oq-fce-3 (REW detection) resolvidos."
	}, {
		id:        "agent-sequencing-fairness"
		metric:    "Coeficiente de variação de latência entre InvoiceIssued e InitiateBankTransfer por par sh-01↔sh-02, controlado por volume comparável"
		target:    "CV < 0.3 entre fornecedores com volume comparável"
		rationale: "Mede fairness operacional do agente em sequenciamento sob restrição TCM. Desvio alto indica favoritismo temporal — sinal de alerta antes que padrão se consolide. Observability-only (onBreach omitido): bias sutil exige avaliação contextual humana, não escalation determinística — gap reconhecido em oq-fce-4."
	}, {
		id:        "payment-default-rate"
		metric:    "Percentual de pagamentos elegíveis que terminam em PaymentObligationDefaulted dentro de 90 dias após CreditEligibilityDecided positivo"
		target:    "Target pendente de calibração contra REW model; placeholder não-normativo até baseline real."
		rationale: "Mede coerência entre decisão de elegibilidade (REW) e execução real (FCE). Taxa alta invalida a premissa de que CreditEligibilityDecided é predictor confiável (cross-BC com at-02 do domain-definition). Observability-only — feeds REW retraining, não escalation FCE-side."
	}]

	rationale: """
		Canvas do FCE como documento raiz de identidade. FCE é o orquestrador
		da execução financeira de compromissos econômicos, materializando a
		invariante central da fusão CMT-DLV-FCE: dinheiro só se move quando
		operação comprova que deve se mover. Recebe upstream de INV (fatura),
		REW (elegibilidade), BKR (confirmação) e DRC (decisões de disputa);
		publica PaymentSettled para REW, SCF, ATO e TCM; delega liquidação
		física a BKR; consulta TCM para sequenciamento. Core porque a
		vinculação causal operação→pagamento e o PrePaymentGuard são
		proprietários da Mesh — eliminam a separação entre operação e
		liquidação financeira da cadeia tradicional. Execution como archetype
		primário porque opera o payment lifecycle sob gates determinísticos;
		gateway como secundário porque PrePaymentGuard é fronteira de entrada
		inviolável. Business decisions declaradas: bd-payment-invariant
		(gate inviolável), bd-ledger-as-sot (FCE mantém o ledger financeiro
		canônico contra o qual ATO/TCM/SCF reconciliam), bd-settled-after-bkr
		(canonical settled apenas pós-BKR ACK), bd-post-settle-immutability
		(correção pós-settle via DRC, não mutação retroativa). Governance
		scope separa decisões determinísticas (autônomas) de decisões com
		impacto financeiro irreversível (supervisionadas). Incentive analysis
		demonstra que o design busca tornar o custo cumulativo de manipulação
		(por pagador, recebedor, agente ou coalizão) superior aos benefícios
		esperados — combinação de oracle externo (BKR), ledger imutável,
		detecção cross-BC e responsabilidade jurídica explícita (dp-10).
		Cross-BC dependencies declaradas: oq-cmt-3 (SCF↔DLV milestone),
		oq-cmt-4 (agent alignment), oq-cmt-5 (fracionamento detection). FCE
		é downstream dominant do grafo — falhas no BC têm impacto monetário
		direto.
		"""
}
