package fce

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue — Ubiquitous Language: Financial Commitment Execution.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// FATIA DO CAMINHO DO GUARD (claim parcial do WI-043 — NÃO conclui o WI;
// precedente de fatia: WI-140/pm-dlv). Escopo: os 7 termos do caminho
// PrePaymentGuard → authorize → dispatch → settle, suficientes para o
// domain-model recortado da mesma fatia e para o cenário de validação
// terminal do WI-138. Termos fora do caminho (default, indeterminação,
// reissuance, cancelamento, realização orçamentária) entram quando os
// respectivos estados/fluxos entrarem no modelo (ver T1/T2 no header do
// domain-model.cue desta fatia).
//
// Definições DERIVADAS DO CANVAS (contexts/fce/canvas.cue): purpose,
// bd-money-moves-only-on-proof, bd-prepayment-guard-deterministic,
// bd-financialization-atomic, bd-conditional-retention-release,
// bd-settlement-fact-canonical, bd-economic-authority-not-rails,
// as-fce-1..4. Nenhum termo introduz semântica nova — o glossário
// consolida vocabulário que o canvas já canonizou.
//
// Authoring manual per manualAuthoringProtocol (adr-057), modo batch
// aprovado pelo founder para esta fatia (proposta consolidada revisada
// no chat em 2026-06-12; section gates substituídos pela revisão da
// proposta integral + checkpoint pré-commit).

glossary: artifact_schemas.#Glossary & {
	code:              "fce"
	name:              "Financial Commitment Execution"
	boundedContextRef: "fce"

	terms: [{
		code:   "term-guarda-pre-pagamento"
		name:   "Guarda Pré-Pagamento"
		termEn: "PrePaymentGuard"
		definition: """
			Gate determinístico pré-dispatch que compõe três condições —
			fatura válida (InvoiceIssued de INV), elegibilidade de risco
			satisfeita (REW) e cadeia de evidência íntegra — e autoriza
			movimento de dinheiro apenas quando a operação comprova que
			deve se mover (P11). É função categórica das 3 condições
			(sim/não), reproduzível em replay; o agente recomenda, o gate
			valida (P10). Ausência de qualquer condição bloqueia o
			dispatch sem override autônomo.
			"""
		category: "rule"
		rationale: """
			Termo que define o FCE (canvas purpose + bd-money-moves-only-
			on-proof + bd-prepayment-guard-deterministic). Nomeá-lo com
			precisão evita que o gate seja confundido com julgamento do
			agente ou com validações upstream.
			"""
		synonyms: ["o guard", "gate de pré-pagamento"]
		antiTerms: [{
			term: "Scoring de risco"
			clarification: """
				Precificar/decidir elegibilidade é REW; o guard CONSOME a
				elegibilidade como condição, não a produz.
				"""
		}, {
			term: "Validação de fatura"
			clarification: """
				Materializar e validar fatura é INV; o guard consome
				InvoiceIssued como condição.
				"""
		}, {
			term: "Decisão do agente"
			clarification: """
				O agente nunca despacha pagamento diretamente; override do
				guard é sempre supervisedDecision (linha vermelha P10/P11,
				canvas governanceScope).
				"""
		}]
		rejectedAlternatives: [{
			term: "Pagamento Condicionado"
			reason: """
				Descreve o efeito, não o mecanismo; o termo canônico nomeia
				o gate que produz a condição (precisão para code generation
				e para o cenário do WI-138).
				"""
		}]
		relatedTerms: ["term-cadeia-de-evidencia", "term-autorizacao"]
		domainModelRefs: ["inv-money-moves-only-on-proof", "inv-guard-deterministic", "cmd-authorize-payment"]
	}, {
		code:   "term-financializacao"
		name:   "Financialização"
		termEn: "Financialization"
		definition: """
			Sequência atômica all-or-nothing que executa um pagamento:
			guard → authorize → dispatch → settle → realização
			orçamentária → liberação de retenção. Settlement parcial não
			é estado de domínio válido; falha em qualquer etapa reverte ou
			mantém o Payment em estado não-final auditável.
			"""
		category: "process"
		rationale: """
			bd-financialization-atomic: a atomicidade é precondition de
			dp-04 (determinismo operacional) e elimina a classe de bugs de
			meio-pagamento. NOTA DE FATIA: o domain-model desta fatia
			modela a sequência até settle (T1 — realização orçamentária e
			liberação de retenção entram com BDG na composição).
			"""
		antiTerms: [{
			term: "Originação de produto financeiro"
			clarification: """
				Estruturar antecipação/working capital é SCF; FCE executa o
				movimento de dinheiro que o SCF origina.
				"""
		}]
		relatedTerms: ["term-liquidacao", "term-autorizacao"]
		domainModelRefs: ["inv-no-partial-settlement", "agg-payment"]
	}, {
		code:   "term-liquidacao"
		name:   "Liquidação"
		termEn: "Settlement"
		definition: """
			Efetivação física do movimento de dinheiro, executada pelo BKR
			sob authorization proof e reconciliada de volta ao FCE
			(SettlementFinalized). O fato canônico de conclusão é
			PaymentSettled — SoT único de "dinheiro moveu", consumido por
			REW/SCF/ATO/TCM sem fonte concorrente.
			"""
		category: "process"
		rationale: """
			bd-settlement-fact-canonical + ax-07 (ledger como primitiva):
			fonte concorrente de "pagamento liquidado" criaria divergência
			silenciosa entre risco, contábil e tesouraria.
			"""
		antiTerms: [{
			term: "Autorização"
			clarification: """
				Authorized não é settled: a autorização é decisão econômica
				do FCE; a liquidação só conclui com a reconciliação do rail.
				"""
		}, {
			term: "Lançamento contábil"
			clarification: """
				ATO conforma (conformist) consumindo PaymentSettled; o
				lançamento é downstream, não parte da liquidação.
				"""
		}]
		relatedTerms: ["term-financializacao", "term-prova-de-autorizacao"]
		domainModelRefs: ["evt-payment-settled", "inv-settled-fact-canonical", "cmd-settle-payment"]
	}, {
		code:   "term-retencao"
		name:   "Retenção"
		termEn: "Retention"
		definition: """
			Parcela do pagamento retida contratualmente, liberada somente
			quando a evidência comprova que o critério de liberação foi
			satisfeito — instância de release-on-proof, a mesma invariante
			P11 aplicada à retenção. O critério é input (commitment/
			contrato), nunca decisão autônoma do FCE.
			"""
		category: "value"
		rationale: """
			bd-conditional-retention-release + as-fce-4: liberação por
			instrução manual desacoplada da evidência é o problema que a
			tese resolve. FORA do caminho desta fatia (T1) — o termo é
			canonizado agora porque pertence ao vocabulário nuclear do BC
			e evita re-trabalho terminológico na expansão.
			"""
		antiTerms: [{
			term: "Multa ou garantia bancária"
			clarification: """
				Retenção é parcela do próprio pagamento condicionada a
				critério de liberação, não instrumento de garantia externo
				(INS) nem penalidade.
				"""
		}]
		relatedTerms: ["term-guarda-pre-pagamento"]
	}, {
		code:   "term-autorizacao"
		name:   "Autorização"
		termEn: "Authorization"
		definition: """
			Decisão econômica do FCE de pagar, tomada exclusivamente após
			o PrePaymentGuard aprovar; materializa-se na emissão da
			authorization proof ao BKR. FCE decide quando e por que pagar;
			BKR executa fisicamente sob a proof (FCE nunca toca rails).
			"""
		category: "process"
		rationale: """
			bd-economic-authority-not-rails: separar autoridade econômica
			de execução física é o que permite trocar rails sem alterar a
			lógica financeira e mantém a responsabilidade da decisão no
			FCE (P10).
			"""
		antiTerms: [{
			term: "Dispatch"
			clarification: """
				Dispatch é o ato subsequente de emitir a PaymentInstruction
				ao BKR; a autorização é a decisão que o precede e o habilita.
				"""
		}]
		relatedTerms: ["term-prova-de-autorizacao", "term-guarda-pre-pagamento"]
		domainModelRefs: ["cmd-authorize-payment", "evt-payment-authorized"]
	}, {
		code:   "term-prova-de-autorizacao"
		name:   "Prova de Autorização"
		termEn: "Authorization Proof"
		definition: """
			Artefato verificável emitido pelo FCE — assinatura + nonce +
			validity window + claim chain — que acompanha toda
			PaymentInstruction. O BKR valida a proof estruturalmente antes
			de qualquer dispatch físico; instrução sem proof válida é
			rejeitada de forma terminal (InstructionRejected), e nova
			tentativa exige novo InstructionId + nova proof.
			"""
		category: "value"
		rationale: """
			as-fce-3 + bd-economic-authority-not-rails: a proof torna a
			delegação FCE→BKR verificável e auditável; é a materialização
			da autoridade econômica como artefato, não como confiança
			implícita entre serviços.
			"""
		antiTerms: [{
			term: "Comprovante de pagamento"
			clarification: """
				A proof autoriza ANTES do movimento; comprovante atesta
				DEPOIS — o fato pós-liquidação é PaymentSettled.
				"""
		}]
		rejectedAlternatives: [{
			term: "Comprovante de Autorização"
			reason: """
				"Comprovante" sugere recibo a posteriori; "prova" captura o
				artefato criptográfico verificável ex-ante (consistente com
				IntegrityProof do EvidencePort e com a família proof-* do
				ecossistema).
				"""
		}]
		relatedTerms: ["term-autorizacao", "term-liquidacao"]
		domainModelRefs: ["vo-authorization-proof"]
	}, {
		code:   "term-cadeia-de-evidencia"
		name:   "Cadeia de Evidência"
		termEn: "Evidence Chain"
		definition: """
			Encadeamento íntegro da evidência operacional upstream
			(DLV → INV) que lastreia um pagamento: do registro de
			evidência verificado à fatura emitida. A INTEGRIDADE desse
			encadeamento é a condição (c) do PrePaymentGuard; a
			inviabilidade computacional de falsificação é ancorada no
			mecanismo criptográfico (assinatura + hash chain +
			notarização, as-fce-1/adr-128).
			"""
		category: "value"
		rationale: """
			Sem este termo, "evidência" no FCE colide com os termos de
			custódia/ingestão do DLV. No FCE o conceito é a PROPRIEDADE
			composta (integridade do encadeamento) que o gate verifica —
			não o ato de registrar nem o blob custodiado.
			"""
		antiTerms: [{
			term: "Registro de Evidência (DLV)"
			clarification: """
				Registrar/custodiar evidência é DLV (ingestão BD11,
				local-first); o FCE consome a integridade do encadeamento
				já verificado, não re-executa a verificação operacional.
				"""
		}, {
			term: "Verdade semântica"
			clarification: """
				Integridade != verdade (defense in depth BD9 do DLV): a
				cadeia íntegra prova lineage não-adulterado, não a verdade
				material do conteúdo — que é responsabilidade das camadas
				de verificação upstream.
				"""
		}]
		relatedTerms: ["term-guarda-pre-pagamento"]
		domainModelRefs: ["inv-money-moves-only-on-proof"]
	}]

	rationale: """
		Fatia da Ubiquitous Language do FCE recortada no caminho do
		PrePaymentGuard (claim parcial WI-043; precedente WI-140): 7
		termos derivados integralmente do canvas, suficientes para o
		domain-model recortado e o cenário terminal do WI-138. Termos do
		vocabulário de falha/exceção (default, indeterminação,
		reissuance) entram com os estados correspondentes (T2). Bilingual
		mapping habilita codegen (termEn vira identificador); antiTerms
		preservam as fronteiras com REW/INV/DLV/BKR/SCF/ATO que o canvas
		desenhou.
		"""
}
