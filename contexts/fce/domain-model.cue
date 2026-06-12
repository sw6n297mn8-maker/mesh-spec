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
// (FIXTURES) REW e BKR não possuem schemas materializados; os eventos
//      consumidos deles são FIXTURE-CONTRACTS de shape mínimo (apenas
//      os campos que o guard/settle consomem), com forward-ref
//      oq-fce-4 — reconciliar quando REW/BKR materializarem schemas.
//      INV é REAL: evt-invoice-issued espelha #InvoiceIssued
//      (contexts/inv/schemas/events.cue:126).
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
		code:        "evt-eligibility-emitted"
		name:        "EligibilityEmitted"
		visibility:  "internal"
		sourceContext: "rew"
		description: """
			Decisão de elegibilidade emitida pelo REW; alimenta o cache
			event-driven do PrePaymentGuard (condição (b) do gate).
			"""
		rationale: """
			FIXTURE-CONTRACT (REW sem schemas materializados): shape
			mínimo derivado do canvas REW (QueryEligibility returnType,
			rew:321 — decision ∈ {eligible, conditionally-eligible,
			ineligible} + policyVersion + entityRef), restrito aos campos
			que o guard consome. Forward-ref oq-fce-4: reconciliar quando
			REW materializar schemas/events.cue.
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
			Forward-ref oq-fce-4: reconciliar quando BKR materializar.
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
		code:        "evt-risk-score-emitted"
		name:        "RiskScoreEmitted"
		visibility:  "internal"
		sourceContext: "rew"
		description: """
			Score de risco recomputado pelo REW; alimenta o cache de score
			do PrePaymentGuard (complementar a EligibilityEmitted).
			"""
		rationale: """
			FIXTURE-CONTRACT de CATÁLOGO (REW sem schemas): declarado para
			integridade da aresta rew→fce do context-map (sc-cm-06 exige o
			evento quando o FCE possui domain-model); o guard desta fatia
			usa elegibilidade — o consumo de score entra com a validação
			contextual. Shape mínimo per canvas REW (rew:316). Forward-ref
			oq-fce-4.
			"""
		fields: [{
			kind: "primitive"
			name: "entityRef"
			type: "string"
		}, {
			kind: "primitive"
			name: "score"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "scoreVersion"
			type: "string"
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
	}]

	commands: [{
		code:        "cmd-materialize-payment"
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
			FIXTURE-CONTRACT shape mínimo (canvas REW rew:321); congela
			apenas o que o guard consome — forward-ref oq-fce-4 para
			reconciliação quando REW materializar schemas.
			"""
	}]

	aggregates: [{
		code:        "agg-payment"
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
		}]
		handlesCommands: [
			"cmd-materialize-payment",
			"cmd-authorize-payment",
			"cmd-dispatch-payment-instruction",
			"cmd-settle-payment",
		]
		emitsEvents: [
			"evt-payment-authorized",
			"evt-payment-instruction-dispatched",
			"evt-payment-settled",
		]
		protectsInvariants: [
			"inv-money-moves-only-on-proof",
			"inv-guard-deterministic",
			"inv-at-most-once-dispatch",
			"inv-no-partial-settlement",
			"inv-settled-fact-canonical",
		]
		usesValueObjects: [
			"vo-payment-id",
			"vo-commitment-ref",
			"vo-authorization-proof",
			"vo-eligibility-decision",
		]
		lifecycle: {
			initialState: "guarded"
			states: [
				"guarded",
				"authorized",
				"dispatched",
				"settled",
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
				description: """
					PrePaymentGuard aprova as 3 condições → decisão
					econômica de pagar + emissão da proof. Reprovação NÃO
					transiciona (permanece guarded com motivo, T2).
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
			Consistency boundary único da fatia: as 5 invariantes são
			intra-Payment e as transições são serializadas pelo aggregate
			(bd-payment-canonical-state — ownership exclusivo). O caminho
			modelado é exatamente o que o cenário do WI-138 exercita:
			guard-pass até settled + 1 bloqueio (permanência em guarded).
			"""
	}]

	rationale: """
		Fatia do domain-model do FCE recortada no caminho do
		PrePaymentGuard (claim parcial WI-043; precedente WI-140),
		derivada integralmente do canvas: 6 events (3 consumidos — INV
		real, REW/BKR fixtures mínimos com forward-ref oq-fce-4; 2
		internos; 1 publicado), 4 commands, 5 invariantes (subconjunto
		declarado das 11), 4 VOs e o agg-payment com lifecycle de 4
		estados. Gaps T1/T2 declarados no header; expansão (estados de
		falha, retenção, realização orçamentária, default) segue nos
		próximos incrementos do WI-043/WI futuro com BDG na composição.
		"""
}
