package fce

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-model.cue — Domain Model: Financial Commitment Execution.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// FATIA DO CAMINHO DO GUARD (claim parcial do WI-043 — NÃO conclui o WI;
// precedente de fatia: WI-140/pm-dlv). Modela exclusivamente o caminho
// guarded → authorized → dispatched → settled do agg-payment, na
// granularidade necessária ao cenário de validação terminal do WI-138
// (PrePaymentGuard sobre o walking skeleton).
//
// GAPS DECLARADOS DA FATIA (decisão founder 2026-06-12):
// (T1) A financialization completa do canvas inclui realização
//      orçamentária (BDG) e liberação de retenção APÓS settle
//      (bd-financialization-atomic). Esta fatia termina em settled —
//      a atomicidade completa entra quando BDG entrar na composição.
// (T2) O canvas declara 7 estados (query-surface: + failed,
//      indeterminate, cancelled). Esta fatia traz os 4 do caminho
//      feliz; bloqueio do guard NÃO é estado de falha — o Payment
//      permanece em guarded com motivo. Estados de falha entram com
//      os fluxos de exceção (reissuance, indeterminate, default).
// (5/11) As 5 invariantes desta fatia são SUBCONJUNTO DECLARADO das
//      11 do Payment (canvas bd-payment-canonical-state: "o
//      detalhamento granular das 11 invariantes vive no domain-model").
//      As demais entram com os fluxos que protegem.
// (CONSUMO) INV é REAL: evt-invoice-issued espelha #InvoiceIssued
//      (contexts/inv/schemas/events.cue:126). REW materializou: a
//      eligibility é consumida via contrato-de-consumo #EligibilityConsumption
//      (faceta de RiskEvaluationEmitted, def-057 opção d) — não há entry de
//      evento REW aqui (projeção, não espelho). BKR ainda fixture
//      (#SettlementFinalized, forward-ref adr-149 até BKR materializar).
//
// Ajuste estrutural sobre a proposta aprovada (exigência do schema
// #StateTransition: toda transição requer triggeredByCommand +
// emitsEvents): a transição authorized→dispatched materializa
// cmd-dispatch-payment-instruction + evt-payment-instruction-dispatched
// (proposta dizia 3 commands/5 events; o modelo tem 4/6).
//
// Authoring manual per manualAuthoringProtocol (adr-057), modo batch
// aprovado pelo founder para esta fatia (proposta consolidada revisada
// no chat em 2026-06-12; section gates substituídos pela revisão da
// proposta integral + checkpoint pré-commit).

domainModel: artifact_schemas.#DomainModel & {
	code:              "fce"
	name:              "Financial Commitment Execution"
	boundedContextRef: "fce"

	events: [{
		code:        "evt-invoice-issued"
		name:        "InvoiceIssued"
		visibility:  "internal"
		sourceContext: "inv"
		description: """
			Fatura emitida pelo INV para um commitment com evidência
			verificada — trigger primário de execução do FCE: materializa
			o Payment e aciona o PrePaymentGuard.
			"""
		rationale: """
			Consumo REAL (não fixture): espelha #InvoiceIssued de
			contexts/inv/schemas/events.cue:126 (mesh.inv.invoice-issued.v1)
			nos campos que o FCE consome. Per canvas inbound inv:
			"Trigger primário de execução".
			"""
		fields: [{
			kind: "primitive"
			name: "invoiceId"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "commitmentRef"
			valueObjectRef: "vo-commitment-ref"
		}, {
			kind: "primitive"
			name: "evidenceRef"
			type: "string"
		}, {
			kind: "primitive"
			name: "amount"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "regimeVersion"
			type: "string"
		}]
	}, {
		code:        "evt-settlement-finalized"
		name:        "SettlementFinalized"
		visibility:  "internal"
		sourceContext: "bkr"
		description: """
			Reconciliação do rail confirmou a liquidação física da
			PaymentInstruction — outcome canônico de sucesso do BKR.
			"""
		rationale: """
			FIXTURE-CONTRACT (BKR sem schemas materializados): shape
			mínimo derivado do canvas (inbound bkr SettlementFinalized,
			fce canvas l.223 / bkr:482), restrito ao que o settle consome.
			Forward-ref adr-149: aplicar o contrato-de-consumo quando BKR materializar.
			"""
		fields: [{
			kind: "primitive"
			name: "instructionId"
			type: "string"
		}, {
			kind: "primitive"
			name: "railReferenceId"
			type: "string"
		}]
	}, {
		code:        "evt-payment-authorized"
		// adr-151 Forma A (onda fce, passo vi)
		firstClass:       true
		firstClassReason: "financial"
		coreNoun:         "Payment Authorized"
		name:        "PaymentAuthorized"
		visibility:  "internal"
		description: """
			PrePaymentGuard aprovou as 3 condições e o FCE tomou a decisão
			econômica de pagar, emitindo a authorization proof.
			"""
		rationale: """
			Marco interno do caminho do guard: separa a decisão econômica
			(autoridade do FCE) do ato de dispatch — espelha
			bd-economic-authority-not-rails.
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind:           "value-object-ref"
			name:           "proof"
			valueObjectRef: "vo-authorization-proof"
		}]
	}, {
		code:        "evt-payment-instruction-dispatched"
		// adr-151 Forma A (onda fce, passo vi)
		firstClass:       true
		firstClassReason: "financial"
		coreNoun:         "Payment Instruction Dispatched"
		name:        "PaymentInstructionDispatched"
		visibility:  "internal"
		description: """
			PaymentInstruction emitida ao BKR sob authorization proof
			(comando cross-BC DispatchPaymentInstruction do canvas).
			"""
		rationale: """
			Materializa a transição authorized→dispatched (exigência
			estrutural #StateTransition); registra o instructionId que a
			reconciliação do BKR referenciará.
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind: "primitive"
			name: "instructionId"
			type: "string"
		}]
	}, {
		code:        "evt-payment-settled"
		// adr-151 Forma A (onda fce, passo vi)
		firstClass:       true
		firstClassReason: "financial"
		coreNoun:         "Payment Settled"
		name:        "PaymentSettled"
		visibility:  "published"
		description: """
			Fato canônico de "dinheiro moveu": Payment atingiu settled
			após reconciliação do rail. Consumido por REW (recalibração),
			SCF (fechamento de antecipação), ATO (lançamento) e TCM
			(posição realizada).
			"""
		rationale: """
			bd-settlement-fact-canonical: SoT único — nenhum outro BC
			afirma liquidação; divergência cross-BC resolve-se contra
			este fato (P0 + ax-07).
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind:           "value-object-ref"
			name:           "commitmentRef"
			valueObjectRef: "vo-commitment-ref"
		}, {
			kind: "primitive"
			name: "railReferenceId"
			type: "string"
		}, {
			kind: "primitive"
			name: "settledAt"
			type: "datetime"
		}]
	}, {
		code:        "evt-payment-obligation-defaulted"
		name:        "PaymentObligationDefaulted"
		visibility:  "published"
		description: """
			Obrigação de pagamento tornou-se inadimplente (default
			pós-tentativas / fora de janela honrável); sinal de
			comportamento financeiro adverso consumido pelo REW.
			"""
		rationale: """
			Evento de CATÁLOGO declarado para integridade da aresta
			fce→rew do context-map (sc-cm-06); o FLUXO de default está
			FORA desta fatia (T2 — estados de falha) e nenhuma transição
			o emite ainda. Per canvas outbound (l.310-321): declaração de
			default é supervisedDecision (confirm-payment-obligation-
			default), modelagem completa entra com os fluxos de exceção.
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind:           "value-object-ref"
			name:           "commitmentRef"
			valueObjectRef: "vo-commitment-ref"
		}]
	}, {
		code: "evt-payment-guard-escalated"
		// adr-155 materialização — first-class governance (intervenção de supervisão)
		firstClass:       true
		firstClassReason: "governance"
		coreNoun:         "Payment Guard Escalated"
		name:        "PaymentGuardEscalated"
		visibility:  "internal"
		description: """
			O PrePaymentGuard não passou de forma limpa — uma das 3 condições
			(fatura / elegibilidade / evidência) está stale, incompleta ou
			ambígua-mas-PRESENTE — e o Payment foi escalado para julgamento
			humano. NÃO é breach: evidência ausente ou com integridade
			criptográfica falha permanece em guarded e dispara o freeze
			(escalationCriterion p11-invariant-breach-detected), não escala.
			"""
		rationale: """
			Outcome-split do PrePaymentGuard (tq-dmg-06): separa o caminho
			overridável (stale/ambíguo) do bloqueio-limpo (T2 — permanece
			guarded) e do breach (freeze). Materializa o estado escalated do
			adr-155 — evidência auditável de que a máquina parou e esperou um
			humano.
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind:           "value-object-ref"
			name:           "escalatedConditions"
			valueObjectRef: "vo-overridden-guard-conditions"
		}]
	}, {
		code: "evt-payment-guard-overridden"
		// adr-155 materialização — first-class governance
		firstClass:       true
		firstClassReason: "governance"
		coreNoun:         "Payment Guard Overridden"
		name:        "PaymentGuardOverridden"
		visibility:  "internal"
		description: """
			O supervisor APROVOU o override de um Payment escalado — autorizou
			o pagamento com atribuição nominal (quem / por quê / quais condições
			foram sobrepostas). O Payment reentra no trilho (authorized) e segue
			para dispatch sob a authorization proof.
			"""
		rationale: """
			O ato humano sancionado (adr-155): carrega a atribuição (supervisorId
			/ reason / overriddenConditions) para o audit trail. Distinto de
			evt-payment-authorized (autônomo) — o audit separa override humano de
			gate-pass autônomo (fronteira P10).
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind:           "value-object-ref"
			name:           "supervisorId"
			valueObjectRef: "vo-supervisor-id"
		}, {
			kind: "primitive"
			name: "reason"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "overriddenConditions"
			valueObjectRef: "vo-overridden-guard-conditions"
		}, {
			kind:           "value-object-ref"
			name:           "proof"
			valueObjectRef: "vo-authorization-proof"
		}]
	}, {
		code: "evt-payment-guard-override-refused"
		// adr-155 materialização — first-class governance
		firstClass:       true
		firstClassReason: "governance"
		coreNoun:         "Payment Guard Override Refused"
		name:        "PaymentGuardOverrideRefused"
		visibility:  "internal"
		description: """
			O supervisor NEGOU o override de um Payment escalado — o Payment vai
			ao terminal refused. O destino da obrigação (default, reissuance,
			encerramento) é a supervisedDecision confirm-payment-obligation-default
			(#4), fora desta fatia.
			"""
		rationale: """
			Caminho de recusa (adr-155 item 3): terminal próprio, NÃO acoplado a
			default — mantém a fatia coesa. Registra supervisorId + reason para o
			audit trail.
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind:           "value-object-ref"
			name:           "supervisorId"
			valueObjectRef: "vo-supervisor-id"
		}, {
			kind: "primitive"
			name: "reason"
			type: "string"
		}]
	}]

	commands: [{
		code:        "cmd-materialize-payment"
		// adr-151 Forma A (onda fce, passo vi)
		firstClass:       true
		firstClassReason: "financial"
		coreNoun:         "Materialize Payment"
		name:        "Materialize Payment"
		description: """
			Cria o Payment em guarded para (commitmentRef, invoice) ao
			consumir InvoiceIssued; idempotente por tupla — segunda
			materialização para a mesma tupla é no-op.
			"""
		rationale: """
			Canvas inbound inv: "Materializa Payment para (commitmentRef,
			invoice)". A idempotência na criação é a primeira metade de
			inv-at-most-once-dispatch (as-fce-2).
			"""
		fields: [{
			kind: "primitive"
			name: "invoiceId"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "commitmentRef"
			valueObjectRef: "vo-commitment-ref"
		}]
	}, {
		code:        "cmd-authorize-payment"
		// adr-151 Forma A (onda fce, passo vi)
		firstClass:       true
		firstClassReason: "financial"
		coreNoun:         "Authorize Payment"
		name:        "Authorize Payment"
		description: """
			Avalia o PrePaymentGuard (fatura válida + elegibilidade +
			integridade da cadeia de evidência) e, em aprovação, autoriza
			o pagamento emitindo a authorization proof. Em reprovação, o
			Payment permanece em guarded com motivo — sem transição.
			"""
		rationale: """
			O guard é função determinística avaliada DENTRO deste command
			(P10: agente recomenda, gate valida); reprovação não é estado
			de falha (T2) — é permanência auditável em guarded.
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}]
	}, {
		code:        "cmd-dispatch-payment-instruction"
		// adr-151 Forma A (onda fce, passo vi)
		firstClass:       true
		firstClassReason: "financial"
		coreNoun:         "Dispatch Payment Instruction"
		name:        "Dispatch Payment Instruction"
		description: """
			Emite a PaymentInstruction ao BKR sob authorization proof
			(invocação sync cross-BC DispatchPaymentInstruction) e
			registra o dispatch no Payment.
			"""
		rationale: """
			Materializa o ato de dispatch separado da autorização
			(bd-economic-authority-not-rails); exigência estrutural da
			transição authorized→dispatched (#StateTransition).
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}]
	}, {
		code:        "cmd-settle-payment"
		// adr-151 Forma A (onda fce, passo vi)
		firstClass:       true
		firstClassReason: "financial"
		coreNoun:         "Settle Payment"
		name:        "Settle Payment"
		description: """
			Transiciona o Payment para settled ao consumir
			SettlementFinalized do BKR e emite PaymentSettled — o fato
			canônico que encerra o caminho desta fatia (T1: realização
			orçamentária e liberação de retenção fora da fatia).
			"""
		rationale: """
			Canvas inbound bkr SettlementFinalized: "transiciona Payment
			para settled... e emite PaymentSettled".
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind: "primitive"
			name: "railReferenceId"
			type: "string"
		}]
	}, {
		code: "cmd-resolve-guard-escalation"
		// adr-155 materialização — first-class governance
		firstClass:       true
		firstClassReason: "governance"
		coreNoun:         "Resolve Guard Escalation"
		name:        "Resolve Guard Escalation"
		description: """
			Resolução humana de um Payment escalado: o supervisor APROVA
			(decision=approve → authorized, emite PaymentGuardOverridden) OU NEGA
			(decision=deny → refused, emite PaymentGuardOverrideRefused). Um ato
			de julgamento supervisionado, dois outcomes. Alcançável SÓ de
			escalated.
			"""
		rationale: """
			Materializa a supervisedDecision override-prepayment-guard como command
			de domínio (adr-155). overriddenConditions é campo deste command e o
			command só é alcançável de escalated → breach (que nunca escala,
			inv-breach-bypasses-escalation) nunca chega aqui: o piso por construção.
			A enforcement humano-only (o agente não pode emiti-lo autonomamente) é
			o estágio 2 (agent-spec autonomyLevel propose-and-wait, oq-fce-3) — não
			vive no domain-model.
			"""
		fields: [{
			kind:           "value-object-ref"
			name:           "paymentId"
			valueObjectRef: "vo-payment-id"
		}, {
			kind:           "value-object-ref"
			name:           "supervisorId"
			valueObjectRef: "vo-supervisor-id"
		}, {
			kind: "primitive"
			name: "reason"
			type: "string"
		}, {
			kind: "primitive"
			name: "decision"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "overriddenConditions"
			valueObjectRef: "vo-overridden-guard-conditions"
		}]
	}]

	invariants: [{
		code: "inv-money-moves-only-on-proof"
		name: "Dinheiro só se move quando a operação comprova"
		rule: """
			Nenhuma PaymentInstruction é despachada sem (a) fatura válida
			(InvoiceIssued de INV), (b) elegibilidade de risco satisfeita
			(REW) e (c) cadeia de evidência íntegra. Ausência de qualquer
			condição bloqueia o dispatch sem override autônomo.
			"""
		rationale: """
			P11 na camada de execução (canvas bd-money-moves-only-on-proof,
			adr-128) — a invariante que torna o FCE core; ancora
			integridade legal (SCD/Bacen, constraint nível 1).
			"""
	}, {
		code: "inv-guard-deterministic"
		name: "PrePaymentGuard determinístico e reproduzível"
		rule: """
			O PrePaymentGuard é função categórica das 3 condições: mesma
			entrada produz a mesma decisão em replay. O agente nunca
			despacha diretamente; override do guard é sempre
			supervisedDecision.
			"""
		rationale: """
			P10 + dp-04 (canvas bd-prepayment-guard-deterministic): sem a
			separação recomendação/validação, ninguém sabe se um pagamento
			foi decisão ou alucinação.
			"""
	}, {
		code: "inv-at-most-once-dispatch"
		name: "Dispatch at-most-once por (commitmentRef, invoice)"
		rule: """
			A tupla (commitmentRef, invoice) produz no máximo um dispatch
			efetivo: materialização repetida é no-op; segundo dispatch
			para a mesma tupla é rejeitado (replay não produz double-pay).
			"""
		rationale: """
			as-fce-2 + escalationCriterion replay-or-double-pay-attempt:
			defesa estrutural contra double-pay (vetor adversarial sh-06).
			"""
	}, {
		code: "inv-no-partial-settlement"
		name: "Settlement parcial não é estado válido"
		rule: """
			A sequência guard→authorize→dispatch→settle é atômica no
			escopo desta fatia: falha em qualquer etapa mantém o Payment
			em estado não-final auditável — nunca meio-settled.
			"""
		rationale: """
			bd-financialization-atomic + dp-04. NOTA T1: a atomicidade
			COMPLETA do canvas inclui realização orçamentária e liberação
			de retenção pós-settle — fora desta fatia, entra com BDG.
			"""
	}, {
		code: "inv-settled-fact-canonical"
		name: "PaymentSettled é o fato canônico único"
		rule: """
			PaymentSettled só é emitido na transição dispatched→settled,
			exatamente uma vez por Payment; nenhum outro evento ou BC
			afirma "dinheiro moveu".
			"""
		rationale: """
			bd-settlement-fact-canonical (P0 + ax-07): fonte concorrente
			de liquidação criaria divergência silenciosa entre risco,
			contábil e tesouraria.
			"""
	}, {
		code: "inv-override-requires-attribution"
		name: "Override exige atribuição nominal ao supervisor"
		rule: """
			A transição escalated → authorized (override) ocorre EXCLUSIVAMENTE
			via cmd-resolve-guard-escalation (decision=approve) com supervisorId
			nominal + reason + overriddenConditions registrados em
			evt-payment-guard-overridden. Nenhum caminho autônomo transiciona
			escalated → authorized. A recusa (decision=deny) vai a refused com
			supervisorId + reason.
			"""
		rationale: """
			P10 (aprovações humanas como parte do gate) + a supervisedDecision
			override-prepayment-guard: o override é ato humano sancionado,
			nominalmente atribuído e auditável. A enforcement de que o AGENTE não
			pode emitir o command vive no agent-governance (estágio 2, oq-fce-3);
			aqui o domain-model registra a atribuição obrigatória.
			"""
	}, {
		code: "inv-breach-bypasses-escalation"
		name: "Breach de P11 nunca escala — vai a freeze"
		rule: """
			Evidência AUSENTE ou com integridade criptográfica FALHA (breach de
			P11) nunca transiciona para escalated. Permanece em guarded e dispara
			o escalationCriterion p11-invariant-breach-detected (freeze fail-safe,
			canvas governanceScope). Só condição stale, ambígua ou
			incompleta-mas-PRESENTE escala (guarded → escalated).
			overriddenConditions é alcançável só de escalated → breach nunca chega
			ao override.
			"""
		rationale: """
			O piso inoverridável (adr-155 item 4; P11 nível-1 não-tensionável): o
			override cobre o presente-mas-não-confirmável, jamais o ausente/forjado.
			O roteamento breach → freeze JÁ EXISTE (canvas p11-invariant-breach-
			detected) — esta invariante o REFERENCIA, não o cria. Reforçada por
			construção: vo-overridden-guard-conditions não tem flag de
			integridade-criptográfica.
			"""
	}]

	valueObjects: [{
		code:        "vo-payment-id"
		name:        "Payment Id"
		description: "Identidade canônica do Payment no FCE."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		constraints: ["não-vazio", "único por (commitmentRef, invoice) — ver inv-at-most-once-dispatch"]
		rationale: "Identidade do aggregate root; a unicidade por tupla é a âncora da idempotência."
	}, {
		code:        "vo-commitment-ref"
		name:        "Commitment Ref"
		description: "Referência ao EconomicCommitment (CMT) que o pagamento realiza."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		constraints: ["não-vazio"]
		rationale: """
			Toda movimentação é rastreável até o commitment que a originou
			(dp-05); é também a chave da realização orçamentária futura
			(Payment.commitmentRef → BudgetApproved, fora da fatia, T1).
			"""
	}, {
		code:        "vo-authorization-proof"
		name:        "Authorization Proof"
		description: """
			Prova verificável da decisão econômica do FCE: assinatura +
			nonce + janela de validade + claim chain.
			"""
		fields: [{
			kind: "primitive"
			name: "signature"
			type: "string"
		}, {
			kind: "primitive"
			name: "nonce"
			type: "string"
		}, {
			kind: "primitive"
			name: "validUntil"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "claimChain"
			type: "string"
		}]
		constraints: ["todos os campos não-vazios", "nonce de uso único por instrução"]
		rationale: """
			as-fce-3: o BKR valida a proof estruturalmente antes do
			dispatch físico — a delegação de execução é verificável, não
			implícita (glossário term-prova-de-autorizacao).
			"""
	}, {
		code:        "vo-eligibility-decision"
		name:        "Eligibility Decision"
		description: """
			Decisão de elegibilidade consumida do REW: entityRef +
			decision (eligible | conditionally-eligible | ineligible) +
			policyVersion.
			"""
		fields: [{
			kind: "primitive"
			name: "entityRef"
			type: "string"
		}, {
			kind: "primitive"
			name: "decision"
			type: "string"
		}, {
			kind: "primitive"
			name: "policyVersion"
			type: "string"
		}]
		constraints: ["decision ∈ {eligible, conditionally-eligible, ineligible}"]
		rationale: """
			Faceta eligibility consumida do fato unificado do REW
			(RiskEvaluationEmitted) via contrato-de-consumo
			#EligibilityConsumption (def-057 opção d, adr-149); REW
			materializou na Etapa 2 — projeção-de-parte, não fixture.
			"""
	}, {
		code:        "vo-supervisor-id"
		name:        "Supervisor Id"
		description: """
			Identidade nominal do supervisor humano que autorizou ou negou um
			override do PrePaymentGuard.
			"""
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		constraints: ["não-vazio"]
		rationale: """
			A atribuição nominal (QUEM) que torna o override auditável e
			não-anônimo (adr-155; P10). A identidade é governada pelo
			agent-governance (estágio 2); aqui é o slot de domínio que o command e
			os events do override carregam.
			"""
	}, {
		code:        "vo-overridden-guard-conditions"
		name:        "Overridden Guard Conditions"
		description: """
			Subconjunto das condições do PrePaymentGuard que estavam stale/ambíguas
			e foram sobrepostas pelo supervisor: três flags — fatura, elegibilidade,
			frescor-de-evidência. NÃO há flag para integridade-criptográfica de
			evidência.
			"""
		fields: [{
			kind: "primitive"
			name: "invoiceStaleOverridden"
			type: "boolean"
		}, {
			kind: "primitive"
			name: "eligibilityStaleOverridden"
			type: "boolean"
		}, {
			kind: "primitive"
			name: "evidenceFreshnessOverridden"
			type: "boolean"
		}]
		constraints: [
			"ao menos uma flag true (override vazio é incoerente)",
			"SEM campo de integridade-criptográfica — breach nunca é overridável: evidência ausente/forjada vai a freeze (p11-invariant-breach-detected), não a este VO",
		]
		rationale: """
			O QUÊ foi sobreposto, auditável. A AUSÊNCIA de flag para
			integridade-criptográfica é o piso REALIZADO por construção (não só
			prosa): o supervisor não consegue sequer NOMEAR override de breach —
			evidência ausente/forjada vai a p11-invariant-breach-detected (freeze),
			não a este VO. Reforça inv-breach-bypasses-escalation.
			"""
	}]

	aggregates: [{
		code:        "agg-payment"
		// adr-151 Forma A (onda fce, passo vi)
		firstClass:       true
		firstClassReason: "financial"
		coreNoun:         "Payment"
		name:        "Payment"
		description: """
			Ledger de execução do FCE: estado canônico do pagamento de um
			commitment faturado, do guard à liquidação. Owner exclusivo
			das transições (nenhum BC externo muta o Payment).
			"""
		rootIdentity: {
			field: "paymentId"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-payment-id"
			}
		}
		fields: [{
			kind:           "value-object-ref"
			name:           "commitmentRef"
			valueObjectRef: "vo-commitment-ref"
		}, {
			kind: "primitive"
			name: "invoiceId"
			type: "string"
		}, {
			kind: "primitive"
			name: "amount"
			type: "decimal"
		}, {
			// adr-155 — carimbo do estado escalated (outcome state).
			kind: "primitive"
			name: "escalatedAt"
			type: "datetime"
		}, {
			// adr-155 — atribuição do override aprovado (quem sobrepôs).
			kind:           "value-object-ref"
			name:           "overriddenBy"
			valueObjectRef: "vo-supervisor-id"
		}, {
			// adr-155 — carimbo do override aprovado (authorized via escalada).
			kind: "primitive"
			name: "overriddenAt"
			type: "datetime"
		}, {
			// adr-155 — atribuição da recusa (quem negou).
			kind:           "value-object-ref"
			name:           "refusedBy"
			valueObjectRef: "vo-supervisor-id"
		}, {
			// adr-155 — carimbo do estado refused (outcome state).
			kind: "primitive"
			name: "refusedAt"
			type: "datetime"
		}]
		handlesCommands: [
			"cmd-materialize-payment",
			"cmd-authorize-payment",
			"cmd-dispatch-payment-instruction",
			"cmd-settle-payment",
			"cmd-resolve-guard-escalation",
		]
		emitsEvents: [
			"evt-payment-authorized",
			"evt-payment-instruction-dispatched",
			"evt-payment-settled",
			"evt-payment-guard-escalated",
			"evt-payment-guard-overridden",
			"evt-payment-guard-override-refused",
		]
		protectsInvariants: [
			"inv-money-moves-only-on-proof",
			"inv-guard-deterministic",
			"inv-at-most-once-dispatch",
			"inv-no-partial-settlement",
			"inv-settled-fact-canonical",
			"inv-override-requires-attribution",
			"inv-breach-bypasses-escalation",
		]
		usesValueObjects: [
			"vo-payment-id",
			"vo-commitment-ref",
			"vo-authorization-proof",
			"vo-eligibility-decision",
			"vo-supervisor-id",
			"vo-overridden-guard-conditions",
		]
		lifecycle: {
			initialState: "guarded"
			states: [
				"guarded",
				"escalated",
				"authorized",
				"dispatched",
				"settled",
				"refused",
			]
			transitions: [{
				from:               "guarded"
				to:                 "authorized"
				triggeredByCommand: "cmd-authorize-payment"
				emitsEvents: ["evt-payment-authorized"]
				guards: [
					"inv-money-moves-only-on-proof",
					"inv-guard-deterministic",
				]
				selector: {
					name:         "sel-prepayment-clean"
					readsPayload: false
					rationale: """
						Roteia o caso LIMPO: as 3 condições do PrePaymentGuard (invoice +
						eligibility + integridade) presentes e válidas, sem ressalva.
						Complemento exato de sel-prepayment-not-clean — o par {clean,
						not-clean} particiona todo o espaço de (guarded,
						cmd-authorize-payment), exatamente um casa (sem AmbiguousTransition
						nem NoApplicableTransition). Não lê payload: o roteamento decide pelo
						estado das condições, não por campo do comando. Per adr-160 (selector
						roteia, guard termina).
						"""
				}
				description: """
					PrePaymentGuard aprova as 3 condições de forma limpa →
					decisão econômica de pagar + emissão da proof. Reprovação
					limpa NÃO transiciona (permanece guarded com motivo, T2);
					reprovação não-limpa escala (guarded → escalated).
					"""
			}, {
				// adr-155 — outcome-split do guard: caminho não-limpo.
				from:               "guarded"
				to:                 "escalated"
				triggeredByCommand: "cmd-authorize-payment"
				emitsEvents: ["evt-payment-guard-escalated"]
				guards: [
					"inv-guard-deterministic",
					"inv-breach-bypasses-escalation",
				]
				selector: {
					name:         "sel-prepayment-not-clean"
					readsPayload: false
					rationale: """
						Roteia o RESIDUAL AMPLO — todo caso NÃO-limpo, INCLUSIVE breach — ao
						candidato escalated. O piso NÃO mora neste selector: é o guard
						TERMINAL inv-breach-bypasses-escalation que barra o breach APÓS a
						seleção (breach → not-clean casa → candidato escalated → guard falha →
						fica guarded → freeze p11-invariant-breach-detected). Excluir breach
						aqui moveria a barreira do piso para fora do guard e violaria a
						falsificationCondition 'vazamento do piso' do adr-160. Complemento de
						sel-prepayment-clean: {clean, not-clean} é mutuamente exclusivo e
						exaustivo. Per adr-160.
						"""
				}
				description: """
					Uma das 3 condições está stale / incompleta / ambígua-mas-
					PRESENTE → Payment escala para julgamento humano. O piso
					inv-breach-bypasses-escalation barra o breach (evidência
					ausente ou com integridade criptográfica falha): este vai a
					freeze (p11-invariant-breach-detected), nunca a escalated.
					"""
			}, {
				// adr-155 — saída bilateral da escalada: override aprovado.
				from:               "escalated"
				to:                 "authorized"
				triggeredByCommand: "cmd-resolve-guard-escalation"
				emitsEvents: ["evt-payment-guard-overridden"]
				guards: ["inv-override-requires-attribution"]
				selector: {
					name:         "sel-override-approve"
					readsPayload: true
					rationale: """
						Discrimina por PAYLOAD: command.decision == approve. Os dois ramos de
						escalated→ têm guards IDÊNTICOS (inv-override-requires-attribution),
						logo nenhum guard distingue o destino — só o campo decision do
						cmd-resolve-guard-escalation roteia. Par mutuamente exclusivo com
						sel-override-deny sobre o valor de decision. Per adr-160 (selector PODE
						ler payload).
						"""
				}
				description: """
					Supervisor APROVA o override (decision approve) → Payment
					reentra no trilho com atribuição nominal (supervisorId /
					reason / overriddenConditions) + proof. Converge ao mesmo
					authorized do caminho autônomo; o audit distingue a origem
					(override humano vs gate-pass autônomo, fronteira P10).
					"""
			}, {
				// adr-155 — saída bilateral da escalada: override recusado.
				from:               "escalated"
				to:                 "refused"
				triggeredByCommand: "cmd-resolve-guard-escalation"
				emitsEvents: ["evt-payment-guard-override-refused"]
				guards: ["inv-override-requires-attribution"]
				selector: {
					name:         "sel-override-deny"
					readsPayload: true
					rationale: """
						Discrimina por PAYLOAD: command.decision == deny. Par com
						sel-override-approve: mutuamente exclusivo (approve ≠ deny) e exaustivo
						sobre o domínio pretendido {approve, deny} do cmd-resolve-guard-escalation.
						Per adr-160 (selector PODE ler payload).
						"""
				}
				description: """
					Supervisor NEGA o override (decision deny) → terminal
					refused com atribuição (supervisorId / reason). O destino da
					obrigação (default, reissuance, encerramento) é decisão
					supervisionada fora desta fatia (T2).
					"""
			}, {
				from:               "authorized"
				to:                 "dispatched"
				triggeredByCommand: "cmd-dispatch-payment-instruction"
				emitsEvents: ["evt-payment-instruction-dispatched"]
				guards: ["inv-at-most-once-dispatch"]
				description: """
					PaymentInstruction emitida ao BKR sob proof; at-most-once
					por (commitmentRef, invoice).
					"""
			}, {
				from:               "dispatched"
				to:                 "settled"
				triggeredByCommand: "cmd-settle-payment"
				emitsEvents: ["evt-payment-settled"]
				guards: [
					"inv-no-partial-settlement",
					"inv-settled-fact-canonical",
				]
				description: """
					SettlementFinalized do BKR reconciliado → estado final
					da fatia + fato canônico publicado (T1: realização
					orçamentária e retenção fora da fatia).
					"""
			}]
		}
		rationale: """
			Consistency boundary único da fatia: as 7 invariantes são
			intra-Payment e as transições são serializadas pelo aggregate
			(bd-payment-canonical-state — ownership exclusivo). O caminho
			autônomo é o que o cenário do WI-138 exercita (guard-pass até
			settled + bloqueio-limpo em guarded); o adr-155 acrescenta a
			exceção sancionada — escalada a julgamento humano (escalated)
			com saída bilateral: override atribuído (→ authorized) ou recusa
			(→ refused). O piso inv-breach-bypasses-escalation mantém o breach
			fora da escalada — vai a freeze, nunca a humano.
			"""
	}]

	rationale: """
		Fatia do domain-model do FCE recortada no caminho do
		PrePaymentGuard (claim parcial WI-043; precedente WI-140),
		derivada do canvas e estendida pelo adr-155 (exceção de override
		humano): 9 events (1 consumido — INV espelho; 1 fixture BKR —
		SettlementFinalized; 5 internos — authorized/dispatched + os 3 de
		governança escalated/overridden/override-refused; 1 publicado —
		PaymentSettled; 1 catálogo — PaymentObligationDefaulted; eligibility
		consumida via contrato-de-consumo #EligibilityConsumption, fora do
		events[]), 5 commands, 7 invariantes (5 do subconjunto declarado das
		11 do canvas + 2 do adr-155: atribuição do override e o piso
		inoverridável), 6 VOs e o agg-payment com lifecycle de 6 estados
		(guard autônomo + escalada bilateral). Gaps T1/T2 declarados no
		header; expansão (demais estados de falha, retenção, realização
		orçamentária, default) segue nos próximos incrementos do WI-043/WI
		futuro com BDG na composição.
		"""
}
