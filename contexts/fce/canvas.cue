package fce

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// canvas.cue — Bounded Context Canvas: Financial Commitment Execution.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// FCE é o BC core de execução financeira da Mesh: garante que dinheiro
// só se move quando a operação comprova (P11). Owner do PrePaymentGuard,
// do estado do Payment (state machine, 11 invariantes), da financialization
// atômica e da liberação condicional de retenções.
//
// Primeira aplicação real de P13/adr-125 (boundary-derivation). A derivação
// de fronteira (3 testes de separação + teste de remoção + classificação
// das 6 relações cross-BC) NÃO materializa campo neste canvas (schema #Canvas
// é struct fechada, sem campo de derivação; Opção (i) — founder decision):
// vive canonicamente no ADR de criação (adr-127, mesmo PR) e alimenta a
// communication abaixo. Nomes de evento/command reconciliados com os canvases
// adjacentes (autoridade) via adr-126.
//
// Autoria manual section-by-section per manualAuthoringProtocol (adr-057),
// com founder gate em cada uma das 9 sections do PG canvas.

canvas: artifact_schemas.#Canvas & {
	code: "fce"
	name: "Financial Commitment Execution"

	purpose: """
		Orquestrar a execução financeira de compromissos econômicos —
		garantir que dinheiro só se move quando a operação comprova que
		deve se mover (P11). FCE é owner exclusivo do gate PrePaymentGuard
		(compõe elegibilidade de risco de REW, fatura válida de INV e
		integridade da cadeia de evidência), do estado do Payment (state
		machine com 11 invariantes), da financialization atômica
		all-or-nothing e da liberação condicional de retenções.

		Existe como unidade SEPARADA porque a linguagem de liquidação e
		as regras de settlement são distintas de: formalização do
		compromisso (CMT), precificação de risco (REW), faturamento
		fiscal (INV), liquidação física via rails (BKR), originação de
		produtos de working capital (SCF), contabilidade fiscal (ATO) e
		gestão de tesouraria/projeção de caixa (TCM). FCE decide quando e
		por que pagar; BKR executa fisicamente sob authorization proof
		emitida pelo FCE. FCE executa; não projeta posição de caixa —
		consome disponibilidade de TCM como input read-only de
		otimização, nunca como autorização. FCE realiza o envelope
		orçamentário aprovado por BDG via Payment.commitmentRef →
		BudgetApproved; não aloca nem possui orçamento.

		Sem FCE como unidade canônica, dinheiro se moveria por instrução
		manual desacoplada da operação — exatamente o problema que a tese
		existe para resolver — e a função de execução ficaria órfã entre
		INV (que materializa a fatura mas não paga) e os rails bancários
		(que liquidam mas não decidem). A invariante P11 perderia enforcer
		determinístico.
		"""

	ubiquitousLanguageRef: "contexts/fce/glossary.cue"

	classification: {
		subdomainType:    "core"
		businessRole:     "compliance-enforcer"
		wardleyEvolution: "custom"
		rationale: """
			Core porque a vinculação causal operação→pagamento é lógica
			proprietária e indissociável da tese (fce.cue:104-110): não há
			diferenciação em "mover dinheiro", mas há em "mover dinheiro só
			quando a operação comprova" (P11), com o ledger de execução
			(PaymentSettled) como SoT contribuindo para o moat de ecossistema.
			compliance-enforcer porque o papel estratégico do FCE é fazer
			cumprir a invariante inviolável P11 via PrePaymentGuard —
			determinístico que BLOQUEIA movimento de dinheiro sem
			elegibilidade (REW), fatura válida (INV) e integridade de
			evidência. É o análogo financeiro core do gate orçamentário do
			BDG (supporting): FCE protege a rede contra movimento de dinheiro
			sem lastro operacional, o que sustenta integridade legal (SCD,
			Bacen — constraint nível 1). A dimensão de execução/orquestração
			é capturada em domainRoles. custom na evolução Wardley porque a
			orquestração evidência→guard→settlement é construída sob medida e
			ainda evolui (novos rails, netting, produtos, regulação alteram
			regras de execução — fce.cue:96-101); rails em si são commodity,
			mas delegados ao BKR.
			"""
	}

	verticalApplicability: {
		mode: "vertical-agnostic"
		rationale: """
			Os mecanismos do FCE (PrePaymentGuard, Payment state machine,
			financialization atômica, settlement, liberação condicional de
			retenções) operam sobre primitivas financeiras universais —
			fatura, elegibilidade, evidência, pagamento — sem depender da
			vertical de construção civil. A especificidade jurisdicional e de
			rail é delegada ao BKR (negativeBoundary bkr, fce.cue:61-66:
			"trocar rails sem alterar lógica financeira"); a semântica
			vertical (tipo de compromisso, critério de entrega) vive upstream
			em CMT/DLV/INV. "Liberação condicional de retenções" é instância
			do padrão universal release-on-proof (P11), não acoplamento à
			vertical. Paralelo INV/BDG: engine horizontal, semântica vertical
			externa.
			"""
	}

	domainRoles: {
		primary: "execution"
		secondary: ["gateway"]
		rationale: """
			Primary execution: FCE é o engine de execução financeira —
			orquestra guard→authorize→dispatch→settle→realização
			orçamentária→liberação de retenção como financialization
			atômica (fce.cue:94 "FinancializationService all-or-nothing";
			fce.cue:108 "absorveu a metade orquestradora do antigo PSO").
			O enum #Archetype não tem "orchestrator"/"ledger"; a
			orquestração de execução mapeia para execution como papel
			central. Secondary gateway: o PrePaymentGuard é gate
			determinístico que bloqueia movimento de dinheiro sem prova
			(P11) — sub-função, não papel central. Inversão deliberada vs
			BDG/INV (gateway primary + execution secondary): aqueles são
			gates que executam steps; FCE é executor que aplica um gate.
			Coerente com businessRole compliance-enforcer (estratégico:
			enforçar P11; funcional: executar via gate).
			"""
	}

	capabilities: {
		operational: [{
			capabilityRef: "cc-01"
			description: """
				PrePaymentGuard: gate determinístico pré-pagamento que compõe
				elegibilidade de risco (REW), fatura válida (INV) e integridade
				da cadeia de evidência, autorizando movimento de dinheiro apenas
				quando a operação comprova (P11). Inclui liberação condicional
				de retenções como instância de release-on-proof.
				"""
			rationale: """
				cc-01 (liberação vinculada a evidência, domain-definition:494)
				é a capability que define o FCE — declarada no subdomain
				capabilityRefs (fce.cue:42). Não precifica risco (REW), não
				materializa fatura (INV), não verifica evidência operacional
				(DLV via INV): FCE compõe e autoriza, não produz os inputs.
				"""
		}, {
			capabilityRef: "cc-03"
			description: """
				Execução financeira 24/7 via gate determinístico: orquestra
				pagamentos continuamente sem intervenção humana rotineira;
				agente recomenda, gate determinístico valida (P10); humano por
				exceção (override, ambiguidade de liquidação).
				"""
			rationale: """
				cc-03 (operação 24/7, domain-definition:506) — declarada no
				subdomain capabilityRefs (fce.cue:43). Não despacha fisicamente:
				delega ao BKR via comando DispatchPaymentInstruction sob
				authorization proof verificável.
				"""
		}, {
			description: """
				Financialization atômica all-or-nothing: orquestra
				guard→authorize→dispatch→settle→realização orçamentária→
				liberação de retenção como unidade atômica; settlement parcial
				não é estado válido. Garante consistência entre estado do
				Payment e os fatos publicados.
				"""
			rationale: """
				Capability local (sem cc-XX) ancorada em strategicProfile
				"FinancializationService all-or-nothing" (fce.cue:94).
				Atomicidade é precondition de dp-04 (determinismo operacional).
				Não estrutura produtos financeiros (SCF), não gere posição de
				caixa (TCM).
				"""
		}, {
			description: """
				Payment como ledger de execução + autoridade econômica: mantém
				o estado canônico do Payment (state machine, 11 invariantes) e
				emite authorization proof verificável ao BKR; PaymentSettled é
				o fato canônico (SoT) de "dinheiro moveu", consumido por
				REW/SCF/ATO/TCM. Realiza o envelope orçamentário do BDG via
				Payment.commitmentRef → BudgetApproved (baixa o committed na
				liquidação). Audit trail regulatory-grade por construção.
				"""
			rationale: """
				Capability local ancorada em strategicProfile "Payment state
				machine com 11 invariantes" (fce.cue:96) + bkr
				bd-settlement-authorization-upstream (contexts/bkr/canvas.cue:444,
				"FCE como autoridade econômica") + Opção B (Payment realiza o
				envelope BDG). Não lança contábil (ATO conformist), não baixa
				físico (BKR), não decide orçamento (BDG aprova, FCE realiza).
				Auditabilidade fica como propriedade estrutural (dp-05); cc-04
				NÃO é declarado como ref porque o subdomain não o lista para fce
				(capabilityRefs = cc-01, cc-03) — evitar drift canvas↔subdomain.
				"""
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	communication: {
		inbound: [{
			type:          "event-consumer"
			sourceContext: "inv"
			event:         "InvoiceIssued"
			reaction: """
				Materializa Payment para (commitmentRef, invoice); aciona
				PrePaymentGuard (elegibilidade REW + integridade de evidência)
				antes de qualquer dispatch. Só prossegue para financialization
				se a operação comprova (P11).
				"""
			description: "Trigger primário de execução. Nome coincide context-map↔INV — sem reconciliação."
		}, {
			type:          "event-consumer"
			sourceContext: "inv"
			event:         "InvoiceCancelled"
			reaction: """
				Cancela settlement pendente se pré-liquidação
				(RequestSettlementCancellation ao BKR se já despachado
				pré-finality); no-op pós-settle — correção pós-liquidação é
				DRC, não mutação FCE.
				"""
			description: "Cancelamento dentro da janela fiscal do INV. Coincide context-map↔INV."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "SettlementFinalized"
			reaction: """
				Reconciliação rail confirmou liquidação; transiciona Payment
				para settled, realiza o envelope orçamentário (baixa committed
				via commitmentRef→BudgetApproved) e emite PaymentSettled.
				"""
			description: "Outcome canônico de sucesso (bkr:482). Reconciliado: context-map dizia BankSettlementConfirmed."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "SettlementFailed"
			reaction: """
				Rail rejeitou; FCE classifica (detalhe via FailureClassified) e
				decide reissuance ou cancelamento. Payment não vai a settled.
				Pode emitir PaymentObligationDefaulted se a obrigação não for
				honrável.
				"""
			description: "Outcome canônico de falha (bkr:488); FailureClassified acompanha (side-channel-aware). Reconciliado."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "SettlementIndeterminate"
			reaction: """
				Estado epistêmico ambíguo (timeout sem resposta definitiva).
				FCE NÃO assume sucesso nem falha; decide reconciliação manual,
				external check ou aguardar próxima janela. Payment em estado
				não-final auditável.
				"""
			description: "Distinto de Failed (bkr:494). Reconciliado."
		}, {
			type:          "event-consumer"
			sourceContext: "bkr"
			event:         "InstructionRejected"
			reaction: """
				Rejeição pré-dispatch (proof inválida / structural-invalid);
				terminal — nova tentativa exige nova PaymentInstruction
				autorizada (novo InstructionId + proof).
				"""
			description: "Pré-dispatch terminal, nunca atingiu o rail (bkr:506). Reconciliado."
		}, {
			type:          "event-consumer"
			sourceContext: "rew"
			event:         "RiskEvaluationEmitted"
			reaction: """
				Projeta a faceta eligibility (decision) para o cache do
				PrePaymentGuard (condição (b), event-driven). Validação
				crítica no momento do gate usa sync query (QueryEligibility).
				Score/confidence/context do fato NÃO consumidos aqui.
				"""
			description: "FCE consome a faceta eligibility de RiskEvaluationEmitted (fato atômico unificado do REW; contrato-de-consumo #EligibilityConsumption, def-057 opção d). Reconciliação do forward-ref: o canvas REW Phase 1 nomeava EligibilityEmitted/RiskScoreEmitted separados (rew amendment, ed19316)."
		}, {
			type:          "event-consumer"
			sourceContext: "scf"
			event:         "ReceivableAdvanceOriginated"
			reaction: """
				Desembolsa o advance ao fornecedor sob PrePaymentGuard/P11 — o SCF
				origina (decide a antecipação), o FCE executa o movimento de dinheiro.
				A interação do guard com a FONTE de capital (próprio/parceiro) é
				deferida (def-036); aqui só se abre o canal de execução.
				"""
			description: "Canal de disbursement do advance — aresta scf-to-fce, ciclo bidirectional-orchestration (adr-137). Resolve pf-scf-1 (a prosa ce-06 já afirmava a execução do FCE; agora há aresta)."
		}, {
			type:       "query-surface"
			query:      "QueryPaymentSettlementStatus"
			returnType: "PaymentSettlementStatusView (paymentId + commitmentRef + status ∈ {guarded,authorized,dispatched,settled,failed,indeterminate,cancelled} + settledAt? + railReferenceId?)"
			description: """
				Superfície síncrona exposta por FCE; consumida por SCF para
				reconciliar fechamento de antecipação (fce-to-scf, queries).
				Read model do event log; não emite outcome sob estado não-final.
				"""
		}]

		outbound: [{
			type: "event-publisher"
			trigger: """
				Payment atinge settled (SettlementFinalized reconciliado +
				envelope orçamentário realizado).
				"""
			event:     "PaymentSettled"
			consumers: ["rew", "scf", "ato", "tcm"]
			description: """
				Fato canônico (SoT) de "dinheiro moveu". REW recalibra risco
				(kind policy-execution-feedback no context-map fce-to-rew); SCF
				fecha antecipação; ATO lança (conformist); TCM atualiza posição
				realizada.
				"""
		}, {
			type: "event-publisher"
			trigger: """
				Obrigação de pagamento torna-se inadimplente (default pós-
				tentativas / fora de janela honrável).
				"""
			event:     "PaymentObligationDefaulted"
			consumers: ["rew"]
			description: """
				Sinal de comportamento financeiro adverso. Per context-map
				fce-to-rew. NOTA: canvas REW ainda não enumera consumo (WI-043
				pendente, rew:297) — forward reference.
				"""
		}, {
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "bkr"
			command:         "DispatchPaymentInstruction"
			trigger: """
				PrePaymentGuard aprovado + financialization autorizada. FCE
				(autoridade econômica) emite PaymentInstruction com authorization
				proof verificável (assinatura + nonce + validity window + claim
				chain).
				"""
			description: "Reconciliado: context-map dizia InitiateBankTransfer; BKR command-handler é DispatchPaymentInstruction (bkr:445). FCE decide; BKR executa físico."
		}, {
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "bkr"
			command:         "RequestSettlementCancellation"
			trigger: """
				Cancelamento pré-finality (e.g., InvoiceCancelled pré-settle).
				NON-GUARANTEED — finality é determinada pelo rail.
				"""
			description: "Reconciliado (novo). BKR command-handler RequestSettlementCancellation (bkr:452)."
		}, {
			type:          "query-dependency"
			targetContext: "rew"
			query:         "QueryEligibility"
			purpose: """
				PrePaymentGuard real-time: validação crítica de elegibilidade no
				momento do gate, complementar ao cache event-driven
				(EligibilityEmitted).
				"""
			description: "Reconciliado: queries adicionadas a rew-to-fce (shape async→hybrid). REW expõe QueryEligibility nomeando FCE/PrePaymentGuard (rew:321)."
		}, {
			type:          "query-dependency"
			targetContext: "rew"
			query:         "QueryRiskScore"
			purpose: """
				Validação de score em tempo real no PrePaymentGuard quando a
				elegibilidade contextual exige score corrente.
				"""
			description: "Reconciliado (parte do shape change rew-to-fce). REW expõe QueryRiskScore nomeando FCE (rew:316)."
		}, {
			type:          "query-dependency"
			targetContext: "tcm"
			query:         "QueryCashAvailability"
			purpose: """
				Otimizar sequenciamento/timing de execução (read-only). NÃO é
				autorização — FCE não condiciona o gate P11 ao caixa; usa para
				ordenar, não para decidir SE paga.
				"""
			description: "Per tcm-to-fce (sync, query-only). Coincide context-map↔TCM. Aresta reversa do par fce↔tcm (gate-acíclico via events-required filter, adr-120)."
		}, {
			type:          "query-dependency"
			targetContext: "tcm"
			query:         "QueryCashForecast"
			purpose: """
				Otimizar timing de execução contra projeção de liquidez
				(read-only, não-autorização).
				"""
			description: "Per tcm-to-fce (sync, query-only)."
		}]

		rationale: """
			Inbound event-driven (sem command-handler): FCE é acionado por
			InvoiceIssued, não comandado — interface event/query-only no
			inbound. Inbound: 7 event-consumers (inv ×2, bkr ×4, rew ×1) + 1
			query-surface exposta. Outbound: 2 event-publishers + 2
			command-invocations sync ao BKR (sob authorization proof) + 4
			query-dependencies (rew ×2 PrePaymentGuard real-time; tcm ×2
			otimização read-only). Outbound alto (8) é esperado: FCE é o
			downstream dominant do grafo (fce.cue:104 "concentra dependências
			de leitura") — query-dependencies/command-invocations não são hub
			drift (só 2 event-publishers). Kinds vivem no context-map: fce↔rew
			policy-execution-feedback (×2 arestas, adr-124/122); par fce↔tcm
			gate-acíclico por events-required filter (adr-120; tcm→fce
			query-only). TODAS as relations cross-checked com context-map após
			reconciliação adr-126 (bkr-to-fce + rew-to-fce).
			"""
	}

	businessDecisions: [{
		id: "bd-money-moves-only-on-proof"
		decision: """
			Nenhuma PaymentInstruction é despachada sem (a) fatura válida
			(InvoiceIssued de INV), (b) elegibilidade de risco satisfeita
			(REW) e (c) cadeia de evidência íntegra. Dinheiro só se move
			quando a operação comprova que deve se mover.
			"""
		rationale: """
			Instanciação de P11 (design-principles.cue:182) na camada de
			execução financeira — a invariante que torna o FCE core e
			proprietário (fce.cue:104). Sem ela, FCE é motor de pagamentos
			genérico. Formalizada em ADR próprio (adr-128) por ser
			cross-cutting e ancorar integridade legal (SCD/Bacen, constraint
			nível 1).
			"""
		consequences: """
			Gate determinístico pré-dispatch (PrePaymentGuard); ausência de
			qualquer das 3 condições bloqueia o dispatch sem override
			autônomo. Toda movimentação é rastreável até o commitment e o
			evento que a originou (dp-05).
			"""
	}, {
		id: "bd-prepayment-guard-deterministic"
		decision: """
			PrePaymentGuard é gate determinístico que compõe fatura +
			elegibilidade + integridade de evidência. O agente recomenda;
			o gate valida. O agente nunca despacha pagamento diretamente —
			todo command com impacto financeiro passa pelo gate.
			"""
		rationale: """
			P10 (design-principles.cue:166): agentes estocásticos recomendam,
			gates determinísticos validam — sem a separação, ninguém sabe se
			um pagamento foi decisão ou alucinação. cc-03 (operação 24/7) só é
			segura com o gate determinístico no caminho crítico.
			"""
		consequences: """
			Decisões dentro do envelope são autônomas; fora (override,
			ambiguidade) escalam para supervisão (governanceScope). O gate é
			reproduzível — replay produz a mesma decisão (dp-04).
			"""
	}, {
		id: "bd-financialization-atomic"
		decision: """
			Financialization é all-or-nothing: a sequência
			guard→authorize→dispatch→settle→realização orçamentária→
			liberação de retenção é atômica. Settlement parcial não é estado
			de domínio válido.
			"""
		rationale: """
			strategicProfile fce.cue:94 (FinancializationService all-or-nothing)
			+ dp-04 (determinismo operacional): operação parcial criaria estado
			ambíguo não-reproduzível — o que reguladores não aceitam.
			Atomicidade elimina a classe de bugs de meio-pagamento.
			"""
		consequences: """
			Falha em qualquer etapa reverte ou mantém o Payment em estado
			não-final auditável (nunca meio-settled). Consistência
			estado↔fatos publicados é garantida por construção, não por
			reconciliação ex-post.
			"""
	}, {
		id: "bd-conditional-retention-release"
		decision: """
			Retenção é liberada somente quando a evidência comprova que o
			critério de liberação foi satisfeito — instância de
			release-on-proof, a mesma invariante P11 aplicada à retenção
			contratual.
			"""
		rationale: """
			subdomain definition fce.cue:13 ('liberação condicional de
			retenções') + P11. Dinheiro retido só se move (libera) quando a
			operação comprova; liberação por instrução manual desacoplada da
			evidência é o problema que a tese resolve.
			"""
		consequences: """
			Liberação de retenção passa pelo mesmo gate de evidência do
			pagamento principal; sem critério comprovado, a retenção permanece
			retida (estado auditável). Critérios de liberação são input
			(commitment/contrato), não decisão autônoma do FCE.
			"""
	}, {
		id: "bd-payment-canonical-state"
		decision: """
			FCE é owner canônico exclusivo do estado do Payment (state machine
			com 11 invariantes). Transições ocorrem somente dentro do FCE;
			nenhum BC externo muta o estado do Payment.
			"""
		rationale: """
			strategicProfile fce.cue:96 (Payment state machine, 11 invariantes)
			+ teste (c) de P13 (ownership canônico) + dp-05 (auditabilidade
			exige origem única e rastreável por transição). Estado de pagamento
			distribuído entre BCs seria fonte de divergência e fraude.
			"""
		consequences: """
			Correções pós-estado-final não mutam o Payment histórico — são
			novos fatos (DRC/ATO). O detalhamento granular das 11 invariantes
			vive no domain-model (WI futuro); o canvas captura a invariante de
			ownership.
			"""
	}, {
		id: "bd-settlement-fact-canonical"
		decision: """
			PaymentSettled é o fato canônico único de "dinheiro moveu". Nenhum
			outro BC afirma que um pagamento foi liquidado; REW/SCF/ATO/TCM
			derivam seu estado consumindo PaymentSettled, sem fonte concorrente.
			"""
		rationale: """
			P0 (localização canônica única) + ax-07 (ledger como primitiva
			nativa, domain-definition:272); o subdomain ancora 'ledger como
			SoT' (fce.cue:109). Fonte concorrente de 'pagamento liquidado'
			criaria divergência silenciosa entre risco, contábil e tesouraria.
			"""
		consequences: """
			ATO conforma (conformist) sem traduzir; TCM atualiza posição
			realizada; SCF fecha antecipação — todos a partir de PaymentSettled.
			Divergência cross-BC é resolvida contra o ledger de execução do FCE.
			"""
	}, {
		id: "bd-realizes-not-allocates-budget"
		decision: """
			FCE realiza o envelope orçamentário aprovado pelo BDG via
			Payment.commitmentRef → BudgetApproved; a liquidação baixa o
			comprometimento (committed→realizado). FCE não aloca, não decide
			nem possui orçamento.
			"""
		rationale: """
			Espelho de bdg bd-commitment-not-payment (contexts/bdg/canvas.cue:200):
			BDG compromete (prospectivo), FCE executa (efetivo). Opção B
			(decisão founder): sem aggregate de budget no FCE — o Payment
			carrega commitmentRef e realiza o envelope. Evita aggregate anêmico
			e drift de linguagem (alocação=externa/estratégica,
			comprometimento=BDG). A imprecisão "budget allocation" em
			fce.cue:11 é registrada em ten-013.
			"""
		consequences: """
			FCE não decrementa saldo de centro de custo (BDG já o fez no
			comprometimento); a liquidação realiza o committed. Ausência de
			BudgetApproved válido para o commitmentRef bloqueia o dispatch
			(cobertura é pré-condição enforçada por BDG upstream).
			"""
	}, {
		id: "bd-economic-authority-not-rails"
		decision: """
			FCE é a autoridade econômica: decide quando e por que pagar e
			emite authorization proof verificável (assinatura + nonce +
			validity window + claim chain). BKR executa a liquidação física
			sob a proof; FCE nunca toca rails.
			"""
		rationale: """
			Espelho de bkr bd-settlement-authorization-upstream
			(contexts/bkr/canvas.cue:444). Separação core/generic
			(fce.cue:61-66): trocar rails sem alterar lógica financeira. P10:
			autoridade de decisão separada da execução técnica; a proof torna a
			delegação verificável e auditável.
			"""
		consequences: """
			BKR rejeita dispatch sem proof válida (InstructionRejected).
			Adicionar/trocar rail é mudança no BKR, não no FCE. FCE não conhece
			pacs/SPI/clearing — só a semântica econômica de pagar.
			"""
	}, {
		id: "bd-execution-not-treasury"
		decision: """
			FCE executa pagamentos; não projeta nem gere posição de caixa.
			Disponibilidade de TCM (QueryCashAvailability/QueryCashForecast) é
			input read-only de otimização de sequenciamento — nunca autorização.
			"""
		rationale: """
			negativeBoundary tcm (fce.cue:81-88): FCE executa, TCM consolida
			posição/projeção. Empresa pode ter orçamento sem caixa ou caixa sem
			orçamento — domínios distintos (bdg:203). Condicionar o gate P11 ao
			caixa fundiria execução e tesouraria (drift para BC Deus).
			"""
		consequences: """
			FCE usa disponibilidade de TCM para ORDENAR pagamentos
			(timing/sequência), não para decidir SE paga. O par fce↔tcm é
			gate-acíclico (tcm→fce query-only, events-required filter adr-120).
			Indisponibilidade de TCM degrada otimização, não bloqueia execução.
			"""
	}]

	stakeholders: [{
		stakeholderRef: "sh-02"
		roleInContext:  "Beneficiário do movimento financeiro — recebe o pagamento quando a operação comprova."
		impactDescription: """
			PaymentSettled é o momento em que sh-02 efetivamente recebe. FCE
			liquida on-proof (P11), encurtando o ciclo de 60-120 dias. Sem o
			gate do FCE, o pagamento se daria por instrução manual desacoplada
			da operação — atraso, erro e ausência de previsibilidade sobre
			quando o dinheiro chega.
			"""
		rationale: "É quem mais sofre a assimetria informacional (sh-02 catálogo); FCE é o BC que torna 'recebível verificado' em 'dinheiro recebido'."
	}, {
		stakeholderRef: "sh-01"
		roleInContext:  "Pagador — dinheiro só sai contra execução verificada."
		impactDescription: """
			FCE garante que sh-01 só paga contra fatura válida + evidência
			íntegra (P11) — proteção contra pagar por trabalho não comprovado
			e contra double-pay (idempotência por commitmentRef/invoice).
			InvoiceCancelled pré-settle cancela settlement pendente, protegendo
			contra obrigação faturada erroneamente.
			"""
		rationale: "sh-01 é o nó que paga; previsibilidade de quando e por que o dinheiro sai é precondição de gestão de caixa da obra."
	}, {
		stakeholderRef: "sh-04"
		roleInContext:  "Regulador prudencial da SCD — exige rastreabilidade da execução financeira."
		impactDescription: """
			FCE produz o ledger de execução (PaymentSettled) ancorado em cadeia
			de evidência, com audit trail regulatory-grade (dp-05). Cada
			movimento de dinheiro é rastreável até o commitment e o evento que
			o originou; reconstituível em qualquer data. Execução SCD sem esse
			trail é ilegal (constraint nível 1).
			"""
		rationale: "Operar como SCD sem trilha de execução auditável é ilegal (sh-04 catálogo); FCE é o BC que produz essa trilha no domínio de liquidação."
	}, {
		stakeholderRef: "sh-05"
		roleInContext:  "Operador do PrePaymentGuard — executa o gate de liberação financeira."
		impactDescription: """
			Agente IA opera a execução 24/7 (cc-03) dentro do envelope: P10
			impede dispatch sem as 3 condições (fatura + elegibilidade +
			evidência). Override de gate e ambiguidade escalam como
			supervisedDecision; o agente não move dinheiro fora do envelope.
			"""
		rationale: "Sem sh-05 explícito, decisões tratam o agente como ferramenta — gates explícitos preservam clareza dos limites (ax-01/ax-02)."
	}, {
		stakeholderRef: "sh-03"
		roleInContext:  "Funding partner que reconcilia antecipação contra a liquidação do pagamento original."
		impactDescription: """
			sh-03 consome PaymentSettled e QueryPaymentSettlementStatus para
			fechar operações de antecipação (via SCF): saber quando o pagamento
			original liquidou é precondição para encerrar o ciclo de funding.
			Determinismo da liquidação (bd-financialization-atomic) dá confiança
			no fechamento.
			"""
		rationale: "sh-03 fornece capital e precisa de sinal confiável de liquidação; FCE é a fonte canônica do fato de settlement."
	}]

	costsEliminated: [{
		costRef: "ce-03"
		contribution: """
			bd-settlement-fact-canonical (PaymentSettled como SoT único) +
			bd-financialization-atomic eliminam reconciliação entre sistemas de
			pagamento: não há divergência na origem (mech-three-sots). ATO/TCM/
			SCF derivam estado do mesmo fato canônico, sem fontes concorrentes.
			"""
		rationale: "ce-03 (mech-three-sots) é eliminável só se 'dinheiro moveu' tem fonte única — FCE produz esse fato canônico."
	}, {
		costRef: "ce-05"
		contribution: """
			FCE é o engine de execução da SCD própria — move dinheiro
			diretamente sob licença SCD (mech-scd), internalizando o spread que
			um intermediário bancário cobraria. Sem FCE, a SCD não executa
			liquidação; dependeria de intermediário que adiciona custo sem
			adicionar informação.
			"""
		rationale: "ce-05 (mech-scd) elimina-se quando o originador do crédito executa o pagamento — FCE é onde a SCD exerce a execução direta."
	}, {
		costRef: "ce-06"
		contribution: """
			FCE executa a liquidação on-proof que materializa o encurtamento do
			ciclo do fornecedor (mech-scd): PaymentSettled é o instante em que
			sh-02 recebe. Sem a execução determinística do FCE, a antecipação
			originada por SCF não se converte em dinheiro na conta do fornecedor.
			"""
		rationale: "ce-06 (mech-scd) é o driver primário de adoção; FCE é a etapa de execução que realiza o ciclo curto que a tese promete."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-05"
			participantType:           "Agente operador do gate de execução financeira (IA)."
			desiredBehavior:           "Executar PrePaymentGuard com imparcialidade; despachar apenas quando fatura + elegibilidade + evidência estão satisfeitas; escalar overrides em vez de resolvê-los autonomamente."
			correctOperationIncentive: "Operação dentro do envelope é autônoma e 24/7 (cc-03); manter o gate íntegro preserva a credibilidade da execução e a integridade legal da SCD."
			manipulationVector:        "Despachar pagamento sem o guard completo (aceitar elegibilidade stale, evidência incompleta) sob pressão de velocidade ou favoritismo a um proponente."
			manipulationCost:          "P10: o gate determinístico bloqueia dispatch sem as 3 condições — o agente não despacha fora do envelope. Override é supervisedDecision nominalmente atribuída ao supervisor; Event Log imutável registra cada decisão; desvio é detectável por auditoria contínua."
			vsBenefit:                 "Ganho de velocidade/favoritismo é marginal; custo é responsabilidade jurídica (dp-10) + violação de P11 detectável + perda de confiança no spine financeiro. Inviável estruturalmente."
			designResponse:            "PrePaymentGuard determinístico inline (tripwire fail-safe: bloqueia, não 'corrige'); authorization proof verificável; override como supervisedDecision; audit trail regulatory-grade (dp-05)."
			rationale:                 "Mesh é AI-operated — misalignment do operador é vetor default (P10). Gate determinístico + supervisão tornam o bypass mais caro que a operação correta."
		}, {
			stakeholderRef:            "sh-06"
			participantType:           "Classe de actor adversarial canonical (R4+++) com intenção primária de extrair valor."
			desiredBehavior:           "Mover dinheiro sem que a operação comprove — pagamento sem lastro, double-pay por replay, ou cancel-then-reissue laundering."
			correctOperationIncentive: "Participação legítima dá acesso a liquidação rápida e crédito na rede; extração adversarial leva a detecção e degradação de reputação cross-network (custo cumulativo)."
			manipulationVector:        "Forjar evidência upstream para gerar fatura sem entrega; replay de invoice para double-pay; cancel-then-reissue (RequestSettlementCancellation seguido de nova instrução) para lavagem ou duplicação."
			manipulationCost:          "P11 chain: sem DeliveryVerified não há InvoiceIssued (INV bd-issuance-requires-verification); idempotência por (commitmentRef, invoice) impede double-pay; InstructionRejected é terminal (nova tentativa exige novo InstructionId + authorization proof); PaymentSettled é fato canônico único — cancel-then-reissue deixa lineage auditável cross-BC."
			vsBenefit:                 "Ganho de um pagamento ilícito < custo de forjar evidência criptográfica (inviável; mecanismo detalhado em adr-128) + detecção por reconciliação cross-BC + isolamento + degradação de reputação cumulativa."
			designResponse:            "Composição PrePaymentGuard (3 condições) + idempotência + bd-settlement-fact-canonical + audit trail cross-BC; cancel-then-reissue mitigado por InstructionRejected terminal + lineage auditável."
			rationale:                 "sh-06 é o vetor adversarial canonical reusável cross-BC (REW WI-046); sua descrição cita 'cancel-then-reissue laundering', diretamente aplicável ao RequestSettlementCancellation do FCE."
		}]
		rationale: """
			Dois vetores: (a) operador (sh-05) que contorna o gate por
			velocidade/favoritismo — contido por P10 (gate determinístico) +
			override supervisionado + Event Log; (b) adversário canonical
			(sh-06) que tenta mover dinheiro sem prova ou lavar via
			cancel-then-reissue — contido pela P11 chain (sem evidência, sem
			fatura, sem pagamento), idempotência e fato de settlement canônico.
			Em ambos, custo de manipulação excede o benefício por design (dp-08).
			"""
	}

	ownership: {
		domainAgentSpec: "contexts/fce/agents/fce-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "dispatch-on-guard-pass"
				description: "Despachar PaymentInstruction ao BKR quando o PrePaymentGuard aprova: fatura válida (INV) + elegibilidade satisfeita (REW) + cadeia de evidência íntegra. Função categórica das 3 condições."
				rationale:   "P10/P11: dispatch dentro do envelope é a operação autônoma central; o gate é determinístico (sim/não), não julgamento. cc-03 (24/7) depende dessa autonomia."
			}, {
				id:          "release-retention-on-proof"
				description: "Liberar retenção quando a evidência comprova que o critério de liberação foi satisfeito (within-criterion sim/não). Mesmo gate de evidência do pagamento principal."
				rationale:   "bd-conditional-retention-release: liberação on-proof é determinística; o critério é input (commitment/contrato), não decisão econômica do agente."
			}, {
				id:          "reissue-on-transient-within-policy"
				description: "Reemitir PaymentInstruction (novo InstructionId + proof, mesmo commitmentRef) após falha classificada por BKR como technical-transient, dentro do limite de retry da policy."
				rationale:   "Retry de falha técnica transitória dentro de policy não cria nova decisão econômica — é determinístico (within-retry-count). Reissuance fora desse escopo é supervised."
			}]
			supervisedDecisions: [{
				id:          "override-prepayment-guard"
				description: "Autorizar pagamento quando qualquer das 3 condições do PrePaymentGuard está stale, incompleta ou ambígua. NUNCA autônomo — exige confirmação humana nominalmente atribuída ao supervisor."
				rationale:   "Linha vermelha P10/P11: mover dinheiro sem as 3 condições é override de gate — julgamento humano, jamais decisão autônoma do agente. Override autônomo violaria a invariante central do FCE."
			}, {
				id:          "authorize-cancel-then-reissue"
				description: "Autorizar reemissão após cancelamento (cancel-then-reissue) quando o lineage cancel→reissue precisa de verificação contra laundering adversarial (sh-06)."
				rationale:   "sh-06 cita cancel-then-reissue laundering; a sequência cancelar+reemitir tem lineage potencialmente adversarial que exige olho humano — não é retry determinístico."
			}, {
				id:          "resolve-settlement-indeterminate-persistent"
				description: "Decidir sobre SettlementIndeterminate persistente além da janela operacional (reconciliação manual / external check via STR pull / aguardar próxima janela)."
				rationale:   "Estado epistêmico ambíguo persistente (bkr SettlementIndeterminate) não tem resposta determinística — a escolha de próximo passo econômico é julgamento humano."
			}, {
				id:          "confirm-payment-obligation-default"
				description: "Confirmar a emissão de PaymentObligationDefaulted, dado o impacto reputacional cross-BC em REW (feedbackLoop policy-execution-feedback)."
				rationale:   "Declarar default tem impacto no risco (REW) e reputacional sobre a contraparte; classificar uma obrigação como inadimplente não é puramente determinístico."
			}]
			escalationCriteria: [{
				id:        "p11-invariant-breach-detected"
				condition: "Dispatch ocorrido ou tentado sem uma das 3 condições P11 satisfeitas (violação do gate detectada por reconciliação ou tripwire)."
				action:    "Freeze imediato do pipeline de dispatch autônomo (tripwire fail-safe, containment precede diagnosis); escalar founder + supervisor sh-05; forensics completo no Event Log."
				rationale: "P11 breach é a violação mais grave do FCE — integridade legal (nível 1). Containment fail-safe primeiro; diagnóstico depois (ADR-079 guardrail)."
			}, {
				id:        "replay-or-double-pay-attempt"
				condition: "Idempotência detecta 2º dispatch para a mesma tupla (commitmentRef, invoice) OU replay de PaymentInstruction."
				action:    "Reject dispatch (no-op idempotente); emitir anomaly event; escalar security review (vetor sh-06)."
				rationale: "Double-pay/replay é vetor adversarial sh-06; o reject é fail-safe determinístico, mas o padrão exige análise humana de origem (bug vs ataque)."
			}, {
				id:        "prepayment-guard-systemic-failure"
				condition: "PrePaymentGuard indisponível ou inconsistente: inputs REW/INV stale além de threshold, ou o gate retorna resultados não-reproduzíveis."
				action:    "Freeze autonomous dispatch (fail-safe); escalar founder. Nenhum pagamento autônomo enquanto o gate não garante P11."
				rationale: "Gate comprometido = nenhuma garantia de money-on-proof; o fail-safe é parar de mover dinheiro, não degradar a verificação (dp-04)."
			}, {
				id:        "regulatory-or-juridical-ambiguity"
				condition: "Pagamento envolve zona cinza regulatória/jurídica: regulatory-block do BKR (sanctions/AML), estrutura de liquidação não-rotineira ou enquadramento incerto."
				action:    "Escalar compliance officer designado antes de prosseguir; não despachar até parecer."
				rationale: "Integridade legal é constraint inviolável (nível 1); zona cinza exige julgamento humano especializado, jamais resolução autônoma."
			}]
		}
		rationale: """
			fce-primary-agent como operador (forward reference — agent spec
			ainda não autorado; path coincide com o registro context-map). 3
			autonomousDecisions cobrem operação puramente determinística
			(dispatch on-guard, liberação on-proof, retry transitório dentro de
			policy); 4 supervisedDecisions cobrem onde o gate NÃO pode decidir
			sozinho (override do guard — linha vermelha P10/P11; cancel-then-
			reissue adversarial; indeterminate persistente; declaração de
			default). 4 escalationCriteria cobrem P11 breach, replay/double-pay
			(sh-06), falha sistêmica do guard e ambiguidade regulatória — com
			containment fail-safe precedendo diagnóstico (ADR-079). Default é
			autonomia determinística; supervisão é exceção (ax-01/ax-02). Nenhum
			caminho autônomo move dinheiro sem as 3 condições P11.
			"""
	}

	assumptions: [{
		id:                 "as-fce-1"
		assumption:         "O mecanismo criptográfico da cadeia de evidência (assinatura digital + hash chain + notarização de eventos) torna a falsificação de evidência computacionalmente inviável."
		invalidationSignal: "Evidência forjada aceita pelo PrePaymentGuard, OU comprometimento do esquema criptográfico (colisão de hash, vazamento de chave de assinatura)."
		rationale:          "manipulationCost de sh-06 depende disso; sem inviabilidade criptográfica, 'forjar evidência' deixa de ser barreira. adr-128 detalha o mecanismo."
	}, {
		id:                 "as-fce-2"
		assumption:         "Idempotência por (commitmentRef, invoice) garante at-most-once dispatch — replay não produz double-pay."
		invalidationSignal: "Dois PaymentSettled observados para a mesma tupla (commitmentRef, invoice) em produção ou replay."
		rationale:          "Assumido em communication (inbound), incentiveAnalysis (sh-06 replay) e governanceScope (replay-or-double-pay-attempt); é a defesa estrutural contra double-pay."
	}, {
		id:                 "as-fce-3"
		assumption:         "BKR valida a authorization proof estruturalmente antes de qualquer dispatch físico — nenhum dispatch ocorre sem proof verificável."
		invalidationSignal: "Liquidação física confirmada (SettlementFinalized) sem proof válida correspondente, OU BKR incapaz de verificar a proof."
		rationale:          "bd-economic-authority-not-rails delega execução física ao BKR sob proof; a separação só é segura se a proof é efetivamente verificada upstream do rail."
	}, {
		id:                 "as-fce-4"
		assumption:         "O critério de liberação de retenção é input upstream (commitment/contrato), determinístico e completo no momento da decisão de liberação."
		invalidationSignal: "Recorrência de liberações que exigem julgamento humano por critério ausente/ambíguo — taxa de override de retenção acima de threshold operacional."
		rationale:          "release-retention-on-proof é autônomo só se o critério é input, não interpretação do FCE; senão a autonomia regride para semi-manual."
	}, {
		id:                 "as-fce-5"
		assumption:         "BudgetApproved do BDG é cobertura suficiente: o BDG já decrementou o saldo no comprometimento; o FCE não re-verifica cobertura no dispatch, apenas realiza o envelope."
		invalidationSignal: "Divergência entre committed (BDG) e realizado (FCE) detectada na reconciliação — pagamento realizado sem comprometimento correspondente ou vice-versa."
		rationale:          "bd-realizes-not-allocates-budget (Opção B) pressupõe que a cobertura foi enforçada upstream pelo BDG; re-verificar duplicaria responsabilidade."
	}]

	openQuestions: [{
		id:       "oq-fce-1"
		question: "Quando autorar contexts/fce/api.yaml e contexts/fce/async-api.yaml (superfícies declaradas hasSyncSurface/hasAsyncSurface=true)?"
		impact:   "sc-cv-02/sc-cv-03 esperam os specs; o canvas materializa com flags true/true espelhando o precedente do bdg (gap conhecido, não-bloqueante per decisão de scaffold)."
		deadline: "2026-07-31"
		rationale: "Spec authoring é trabalho rotineiro pendente sem trade-off (WI, não deferred-decision); flags refletem a verdade das superfícies."
	}, {
		id:       "oq-fce-2"
		question: "Quando autorar contexts/fce/glossary.cue (ubiquitousLanguageRef forward-ref)?"
		impact:   "ubiquitousLanguageRef aponta para arquivo ainda inexistente; structural-check de glossary validará quando autorado."
		deadline: "2026-06-30"
		rationale: "Glossary consolida a ubiquitous language (settlement, financialization, PrePaymentGuard, retention) — precondição para domain-model."
	}, {
		id:       "oq-fce-3"
		question: "Quando autorar contexts/fce/agents/fce-primary-agent.cue (domainAgentSpec forward-ref)?"
		impact:   "domainAgentSpec referencia agent spec não-materializado; o agente operacional + autonomy envelope formal dependem dele."
		deadline: "2026-08-31"
		rationale: "Agent spec materializa o operador que executa o governanceScope; forward-ref consciente (pattern inv/bdg)."
	}, {
		id:       "oq-fce-4"
		question: "Quando o canvas REW enumera o consumo de PaymentObligationDefaulted (WI-043)?"
		impact:   "Forward-ref cross-BC: até REW listar o evento, o consumo não é bidirecional-validado (FCE publica per context-map fce-to-rew)."
		deadline: "2026-07-15"
		rationale: "oq compartilhada com REW (WI-043 já registrado lá); FCE publica, REW formaliza consumo depois."
	}, {
		id:       "oq-fce-5"
		question: "Quais os thresholds operacionais de retry (technical-transient, reissue-on-transient-within-policy) e da janela operacional de SettlementIndeterminate persistente?"
		impact:   "Os targets das verificationMetrics e os limites de autonomia/escalação dependem de calibração empírica; sem ela, parâmetros são provisórios."
		deadline: "2026-09-30"
		rationale: "Calibração exige dados reais de operação (Phase 1); fixar a priori arriscaria autonomia mal-calibrada."
	}, {
		id:       "oq-fce-6"
		question: "Quando formalizar decisionAuthorityModel + consistencyBoundary do FCE como artefato dedicado (pattern adr-085)?"
		impact:   "O canvas captura governanceScope; o modelo formal de autoridade de decisão + fronteira de consistência (adr-085 nomeia FCE como alvo replicável) ainda não é artefato próprio."
		deadline: "2026-08-31"
		rationale: "adr-085 ('decision-systems-with-truth-boundaries') é replicável a FCE; a truth boundary é P11, a autoridade é o PrePaymentGuard — formalização é WI futuro."
	}]

	verificationMetrics: [{
		id:     "p11-breach-rate"
		metric: "Número de dispatches ocorridos ou tentados sem as 3 condições P11 satisfeitas (fatura + elegibilidade + evidência)."
		target: "0 — zero-tolerance (qualquer breach é violação de invariante crítica e de integridade legal)."
		onBreach: {
			escalationRef: "p11-invariant-breach-detected"
			rationale:     "P11 breach é a violação determinística mais grave do FCE; mapeia 1:1 para o escalationCriterion de containment fail-safe."
		}
		rationale: "Control metric — viola P11 diretamente; causalidade determinística metric→escalation. Containment precede diagnóstico (ADR-079)."
	}, {
		id:     "double-pay-effected"
		metric: "Número de double-pay efetivados (≥2 PaymentSettled para a mesma tupla commitmentRef/invoice)."
		target: "0 — idempotência garante at-most-once."
		onBreach: {
			escalationRef: "replay-or-double-pay-attempt"
			rationale:     "Qualquer tentativa detectada de double-pay/replay aciona o escalationCriterion (reject fail-safe + security review)."
		}
		rationale: "Control metric — invariante de idempotência (as-fce-2); a tentativa é o leading indicator, contida antes de efetivar."
	}, {
		id:     "prepayment-guard-consistency"
		metric: "Reprodutibilidade das decisões do PrePaymentGuard em replay + frescor dos inputs REW/INV."
		target: "100% das decisões reproduzíveis em replay; inputs stale < 24h no caminho crítico."
		onBreach: {
			escalationRef: "prepayment-guard-systemic-failure"
			rationale:     "Gate não-reproduzível ou com inputs stale compromete a garantia P11; aciona freeze fail-safe."
		}
		rationale: "Control metric — dp-04 (determinismo); inconsistência do gate é violação direta da reprodutibilidade exigida."
	}, {
		id:     "dispatch-latency-p99"
		metric: "Latência p99 entre InvoiceIssued consumido e DispatchPaymentInstruction emitido (caminho normal)."
		target: "p99 < 5 min no caminho normal (provisório — calibração Phase 1, oq-fce-5)."
		rationale: "Observability-only — latência sem SLA hard de violação; interpretação depende de volume e janela de rail. Sem onBreach (ADR-077/078): não há ação automática determinística."
	}, {
		id:     "settlement-indeterminate-rate"
		metric: "Percentual de dispatches que terminam em SettlementIndeterminate."
		target: "< 2% dos dispatches (provisório — calibração Phase 1)."
		rationale: "Observability-only — indeterminate é estado epistêmico dependente de rail/provider; o caso persistente vira supervisedDecision (resolve-settlement-indeterminate-persistent), mas a TAXA é diagnóstica, não breach determinístico."
	}, {
		id:     "cancel-then-reissue-rate"
		metric: "Taxa de cancel-then-reissue (RequestSettlementCancellation seguido de nova PaymentInstruction)."
		target: "< 1% dos dispatches (provisório — calibração Phase 1)."
		rationale: "Observability-only — pode correlacionar com laundering sh-06, mas ratio elevado exige análise contextual. Candidata a promoção a control se Phase 1+ identificar root cause estável e reproduzível."
	}, {
		id:     "supervised-override-rate"
		metric: "Percentual de dispatches que exigem override-prepayment-guard (supervisedDecision)."
		target: "< 5% dos dispatches (provisório — calibração Phase 1)."
		rationale: "Observability-only — taxa alta indica que o gate determinístico não cobre o espectro operacional (inputs REW/INV frequentemente stale/ambíguos); sinal para calibração, não ação automática."
	}]

	rationale: """
		FCE é o BC core de execução financeira da Mesh: existe para garantir
		que dinheiro só se move quando a operação comprova (P11), materializando
		a invariante central da tese na camada de liquidação. businessRole
		compliance-enforcer (enforça P11 via PrePaymentGuard), archetype primary
		execution + secondary gateway, custom na evolução Wardley. As 9
		invariantes ancoram-se em P11 (money-on-proof, prepayment-guard,
		conditional-retention-release), P10 (gate determinístico — agente
		recomenda, gate valida), dp-04 (financialization atômica all-or-nothing)
		e dp-05 + ax-07 + P0 (Payment como estado canônico; PaymentSettled como
		SoT único do fato 'dinheiro moveu'; ledger como primitiva nativa).
		Fronteiras: FCE decide e emite authorization proof, BKR executa físico
		(bd-economic-authority-not-rails); FCE realiza o envelope do BDG via
		Payment.commitmentRef, não aloca orçamento (bd-realizes-not-allocates-
		budget, espelho de bdg bd-commitment-not-payment); FCE executa, não
		projeta caixa (bd-execution-not-treasury). Governança: dispatch
		on-guard-pass é autônomo (determinístico); override do gate é SEMPRE
		supervisado (linha vermelha P10/P11); 4 escalationCriteria cobrem P11
		breach, replay/double-pay (sh-06), falha sistêmica do guard e ambiguidade
		regulatória, com containment fail-safe precedendo diagnóstico (ADR-079).
		Topologia das 6 relações: fce↔rew é o único ciclo tipado
		(policy-execution-feedback, adr-124/122); o par fce↔tcm é
		topologicamente cíclico mas gate-acíclico por isenção via events-required
		filter (adr-120) — FCE consome query síncrona de TCM para otimização de
		sequenciamento, não para autorização (o gate P11 não depende de caixa).
		FCE instancia o pattern adr-085 ('decision-systems-with-truth-boundaries',
		que nomeia FCE como alvo replicável): a truth boundary é P11 (evidência
		comprova), a autoridade de decisão é o PrePaymentGuard; a formalização do
		decisionAuthorityModel + consistencyBoundary é WI futuro (oq-fce-6). Teste
		de remoção (P13): remover FCE para a execução por perda de função, não
		por acoplamento — TCM projeta, FCE executa.
		"""
}
