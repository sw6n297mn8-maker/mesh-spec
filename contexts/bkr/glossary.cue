package bkr

// glossary.cue — Ubiquitous Language: Banking Rails & Settlement.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Termos canônicos do BC BKR. Define a linguagem que agentes,
// código, contratos e interfaces usam ao operar neste contexto.
//
// Esta é a UL de execução técnica de settlement sob intenção
// econômica autorizada upstream. Função primária: prevenir
// colapso semântico entre intent econômico (FCE), execução
// técnica (BKR), signaling rail (provider/Bacen/CIP) e estado
// canônico (BKR-canonicalized).
//
// Lenses aplicadas (5):
// - lens-domain-language-and-terminology-design (primária)
// - lens-regulatory-compliance-as-architecture
// - lens-distributed-systems-design
// - lens-trust-and-credibility-design
// - lens-mechanism-design
//
// Materializado em Phase 2 do WI-062 BKR bootstrap via 3 batches
// + 5 ajustes finos Phase 2.2.A + 4 ajustes Batch 1 + 3 ajustes
// Batch 2 + 4 ajustes Batch 3 (founder iterative review pre-write).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code: "bkr"
	name: "Glossário BKR — Banking Rails & Settlement"

	boundedContextRef: "bkr"

	terms: [{
		code:       "term-payment-instruction"
		name:       "Instrução de Pagamento"
		termEn:     "Payment Instruction"
		definition: "Value object FCE-originated consumido por BKR, representando intenção econômica já autorizada upstream (com proof verificável) cristalizada como instrução técnica para execução de settlement. Carrega instructionId (FCE-owned correlation), payer/payee identifiers, valor, rail pinado ou hint, AuthorizationProof, validity window e referências de claim chain. BKR não cria, não muta beneficiary, não altera valor. AuthorizationProof validity is consumed, never interpreted or redefined by BKR. Apenas valida estrutura, autoriza dispatch e gera SettlementAttempt(s) sob este InstructionId."
		category:   "value"
		rationale:  "Termo gateway do BC. Ownership FCE-originated é canônico: instrução tem ciclo de vida em FCE; BKR é executor técnico per instrução. 'PaymentInstruction is not Payment' é invariante constitutivo — sem essa fronteira a UL colapsa e agentes geram código onde BKR aparenta 'fazer pagamento'. Categoria 'value' (não 'command') porque é estrutura de dados imutável que viaja entre BCs; o command DispatchPaymentInstruction é separado e vive em domain-model."
		antiTerms: [{
			term:          "Pagamento (Payment)"
			clarification: "Pagamento é conceito econômico FCE-owned — decisão de quando e por que pagar, budget commitment, obligation lifecycle. PaymentInstruction é o artefato técnico que materializa a intenção FCE após autorização upstream; BKR não decide payment, executa a instrução. PaymentInstruction is not Payment."
		}, {
			term:          "Ordem de Pagamento (Payment Order)"
			clarification: "Termo bancário tradicional carrega ambiguidade de autoria (cliente ordena banco). PaymentInstruction em BKR é instrução já autorizada chegando ao executor técnico — não há decisão pendente sobre se executar, apenas sobre como executar tecnicamente."
		}, {
			term:          "Solicitação de Transferência (Transfer Request)"
			clarification: "Request implica decisão pendente upstream. PaymentInstruction é pós-decisão; AuthorizationProof verificável precede o dispatch. Solicitação sem proof é rejeitada na borda BKR."
		}, {
			term:          "Comando de Liquidação (Settlement Command)"
			clarification: "PaymentInstruction é o value object (dado); o command operacional que dispara o consumo é DispatchPaymentInstruction (vive em domain-model, não no glossary). Confundir value com command leva a modelo errado onde a instrução vira ação."
		}]
		rejectedAlternatives: [{
			term:   "Payment"
			reason: "Colapsa intenção econômica (FCE) com instrução técnica (BKR). Esta colapsação é o erro semântico #1 que o glossary previne."
		}, {
			term:   "PaymentRequest"
			reason: "Request implica autorização pendente. BKR consome apenas instruções já autorizadas upstream com proof."
		}, {
			term:   "SettlementInstruction"
			reason: "Settlement describes execution outcome semantics, not upstream economic authorization semantics. PaymentInstruction is upstream-authored intent; Settlement is downstream-observed state."
		}, {
			term:   "TransferInstruction"
			reason: "Transfer é termo bancário rail-specific (TED, transferência). A instrução BKR é rail-agnostic — pode resolver via Pix, TED, boleto ou SWIFT per Technical Rail Selection."
		}]
		examples: [{
			context:   "FCE autoriza pagamento de fatura a fornecedor"
			instance:  "FCE valida budget + risk gates + invoice + counterparty, gera AuthorizationProof e emite PaymentInstruction com instructionId fce-2026-09823, payer=construtora-x, payee=fornecedor-y, value=47250.00, rail-hint=pix, validity-window=15min. BKR consome, valida proof, executa dispatch."
			rationale: "Exemplo canônico: instrução é resultado de decisão econômica FCE; BKR é consumer downstream."
		}, {
			context:   "Rejeição na borda BKR"
			instance:  "Instrução chega sem AuthorizationProof válido (expired validity-window). BKR rejeita estruturalmente — failure-classification = structural-invalid, BKR-authoritative; FCE deve re-autorizar e re-emitir."
			rationale: "BKR exerce gate técnico mas não substitui decisão FCE."
		}]
		relatedTerms: ["term-authorization-proof", "term-instruction-id", "term-settlement-attempt", "term-technical-rail-selection"]
		layerMapping: {
			codeTerm: "PaymentInstruction"
			apiTerm:  "payment_instructions"
		}
	}, {
		code:       "term-authorization-proof"
		name:       "Prova de Autorização"
		termEn:     "Authorization Proof"
		definition: "Value object FCE-originated anexado a PaymentInstruction carrying cryptographic evidence of upstream authorization. Composição mínima: (a) cryptographic signature sobre instructionId + payer + payee + value; (b) nonce previne replay; (c) issued-at timestamp; (d) validity window upstream-declared (NÃO derivada de estado BKR downstream); (e) claim chain link to upstream authorizer (FCE agent identity). AuthorizationProof validity is consumed, never interpreted or redefined by BKR. BKR consumes authorization semantics; it does not originate them. BKR rejeita dispatch sem proof OR com proof expired/invalid; rejeição é structural-invalid failure category."
		category:   "value"
		rationale:  "Termo de fronteira crítica. Sem AuthorizationProof como conceito canônico, a fronteira FCE/BKR colapsa: BKR aparenta autorizar payment quando de fato apenas verifica proof prévia. Categoria 'value' (não 'rule') porque é estrutura de dados anexada à instrução; a regra subjacente ('BKR rejects unauthorized instructions') vive como businessDecision bd-settlement-authorization-upstream."
		antiTerms: [{
			term:          "Autorização (Authorization)"
			clarification: "Autorização é o ato de autorizar (FCE-owned); AuthorizationProof é a evidência verificável da autorização anexada à instrução. BKR consome evidência, não realiza ato. Confundir os dois leva a modelo onde BKR autoriza."
		}, {
			term:          "Permission / Permissão"
			clarification: "Permission é amplo (RBAC, ACL, access control). AuthorizationProof é especificamente cryptographic evidence sobre uma instrução específica — não permissão amplia para 'esse user pode executar pagamentos'."
		}, {
			term:          "Signature / Assinatura"
			clarification: "Signature é componente do AuthorizationProof (item (a)), mas proof completa exige nonce, issued-at, validity window e claim chain. Signature isolada sem os outros componentes não basta para evitar replay/forgery."
		}, {
			term:          "Token"
			clarification: "Token (Bearer, OAuth) é credential genérica reutilizável; AuthorizationProof é per-instruction, single-use, com semantic binding ao instructionPayload."
		}]
		rejectedAlternatives: [{
			term:   "PaymentAuthorization"
			reason: "Mistura Payment (FCE concept) — implícita confusão de ownership; AuthorizationProof enfatiza que é proof of authorization, não authorization act."
		}, {
			term:   "SettlementAuthorization"
			reason: "Settlement-prefix sugere downstream ownership; ownership é FCE upstream."
		}, {
			term:   "DispatchAuthorization"
			reason: "Dispatch é a ação técnica BKR; authorization é decisão econômica FCE — fronteira invertida no termo."
		}, {
			term:   "AuthCredential"
			reason: "Credential é genérico, reutilizável across operations; AuthorizationProof é per-instruction, binding semântico."
		}]
		examples: [{
			context:  "Proof válida sob validity window"
			instance: "FCE assina proof at 09:30:00 com validity-window 15min, nonce abc123, claim chain → fce-agent-prod. BKR receives instruction at 09:32:01 — proof valid for 13 more minutes. BKR verifica signature, valida nonce não foi usado, valida claim chain, valida validity window. Dispatch technically admissible."
		}, {
			context:   "Proof expired → structural rejection"
			instance:  "FCE assina proof at 09:30:00 com validity-window 5min. BKR receives instruction at 09:36:00 — proof expired há 1 min. BKR rejeita estruturalmente. Failure-classification: structural-invalid (BKR-authoritative). FCE deve re-autorizar e re-emitir."
			rationale: "BKR não estende validity (would be interpreting authorization); apenas consome e valida prazo upstream-declared."
		}, {
			context:   "Signature inválida → não fabricar substituição"
			instance:  "Proof tem signature inválida (key rotation upstream não propagada). BKR rejeita; NÃO 'tries another key' nem 'assumes upstream intent'. Failure-classification: structural-invalid."
			rationale: "BKR consome semantics; não redefine."
		}]
		relatedTerms: ["term-payment-instruction", "term-instruction-id", "term-regulatory-boundary"]
		layerMapping: {
			codeTerm: "AuthorizationProof"
		}
	}, {
		code:       "term-settlement-attempt"
		name:       "Tentativa de Liquidação"
		termEn:     "Settlement Attempt"
		definition: "Entidade BKR-owned representando uma execução técnica concreta de uma PaymentInstruction contra um rail selecionado. Tem identidade attemptId (gerado per execução), idempotencyKey pareado, lifecycle atomic state machine: requested → in-flight → confirmed | failed | indeterminate. Cada novo dispatch técnico após decisão de retry gera novo SettlementAttempt com novo attemptId + novo idempotencyKey sob o mesmo instructionId (lineage técnica explícita, NÃO 'mesma execução prolongada'). SettlementAttempt is the operational unit BKR reconciles; PaymentInstruction is the upstream unit FCE authorizes."
		category:   "entity"
		rationale:  "Entidade central do BC. Identidade attemptId é mandatória — sem ela, retries colapsam em ambiguidade indistinguível de double-settlement. Categoria 'entity' porque tem identidade + lifecycle + estado mutável; PaymentInstruction (value) é input imutável, SettlementAttempt (entity) é a unidade que vive e transiciona em BKR."
		antiTerms: [{
			term:          "Pagamento (Payment)"
			clarification: "Pagamento é intenção econômica FCE. SettlementAttempt é execução técnica BKR. Múltiplos SettlementAttempts podem existir sob um único pagamento autorizado (retries); um SettlementAttempt isolado não é 'um pagamento'."
		}, {
			term:          "Liquidação (Settlement) genérica"
			clarification: "Settlement genérico é amplo demais — pode significar attempt, finality, indeterminate state ou processo cross-temporal. SettlementAttempt é especificamente uma execução discreta com identidade atomicamente rastreável."
		}, {
			term:          "Transação (Transaction)"
			clarification: "Transaction carrega conotação ACID database (commit/rollback). SettlementAttempt é cross-system com rail externo — não tem rollback determinístico; tem reconciliation post-hoc, indeterminate state e compensating flows."
		}, {
			term:          "Dispatch"
			clarification: "Dispatch é a ação executiva inicial (enviar instrução ao rail); SettlementAttempt é a entidade que encapsula dispatch + state transitions + reconciliation outcome. Um dispatch é um evento; um attempt é uma entidade com vida."
		}, {
			term:          "Confirmation"
			clarification: "Confirmation é signal rail-level recebido em algum ponto do lifecycle. SettlementAttempt é a entidade que pode ou não receber confirmation; recebê-la não encerra o attempt — apenas avança o state machine se Reconciliation validar."
		}]
		rejectedAlternatives: [{
			term:   "SettlementExecution"
			reason: "Execution implica ato pontual; attempt enfatiza tentativa discreta com possibilidade de falha + retry. Semantically atomic-tries vs continuous-action."
		}, {
			term:   "SettlementOperation"
			reason: "Operation é genérico demais; perde a granularidade per-tentativa que distingue retries."
		}, {
			term:   "PaymentTransaction"
			reason: "Mistura Payment (FCE concept) com transaction (ACID concept); ambos errados para BKR."
		}]
		examples: [{
			context:   "Retry após indeterminate state"
			instance:  "Attempt-1 (attemptId a-001 + idempotencyKey k-001) dispatched, rail timeout, estado=indeterminate. Reconciliation futura resolverá. Para nova tentativa: Attempt-2 (attemptId a-002 + idempotencyKey k-002) sob o mesmo instructionId i-001 — race protection via idempotencyKey distinta, lineage explícita via instructionId compartilhado."
			rationale: "Demonstra retry generating new attempt entity, não reusing the previous one."
		}, {
			context:  "Atomic state machine per attempt"
			instance: "Attempt-1 transita requested → in-flight (dispatch sent) → confirmed (rail SETTLED + Reconciliation match) → SettlementFinality declarada. Cada transição é atômica per attempt; estados intermediários não emitem eventos canônicos downstream."
		}]
		relatedTerms: ["term-attempt-id", "term-idempotency-key", "term-payment-instruction", "term-reconciliation", "term-settlement-finality", "term-settlement-indeterminate"]
		layerMapping: {
			codeTerm: "SettlementAttempt"
			apiTerm:  "settlement_attempts"
		}
	}, {
		code:       "term-settlement-finality"
		name:       "Finalidade de Liquidação"
		termEn:     "Settlement Finality"
		definition: "Estado canônico BKR-owned declarando que um SettlementAttempt atingiu irreversibilidade verificável post-Reconciliation com proof rail. SettlementFinality is a canonical assertion by BKR about the state of the system, not merely a forwarded rail signal. Pré-condições estritas: (a) Reconciliation determinística completou com match instructionId × railReferenceId × outcome; (b) rail signal confirma irreversibility per semântica SPB/SWIFT do rail específico; (c) proof anchorável em audit trail imutável. Sem as 3 condições, estado permanece SettlementIndeterminate. SettlementFinality é o único gate que autoriza emissão de evento canônico de settlement-completed downstream para FCE/REW/ATO."
		category:   "value"
		rationale:  "Conceptually state; representado como 'value' porque #TermCategory enum não inclui 'state' (mapping per dl-cross-layer-consistency: state values são value objects no domain model). Termo crítico para impedir colapso 'rail-confirmou = settlement-final' — confirmação rail isolada não é finality; só Reconciliation com proof verificável canonicaliza. Sem este gate, BKR vira eco passivo do rail e perde authority de canonicalização."
		antiTerms: [{
			term:          "Confirmação do Rail (Rail Confirmation)"
			clarification: "Confirmation é signal rail-level (provider/Bacen sinaliza receipt ou processing). É INPUT para Reconciliation. SettlementFinality é OUTPUT pós-Reconciliation com proof. Confirmação isolada pode ser revogada (Pix devolução automática, SWIFT pacs.004) antes de finality."
		}, {
			term:          "Rail Finality"
			clarification: "Rail finality é fato rail-determined (cada rail tem semântica própria: Pix instant, STR D+0, boleto T+1). BKR consome rail-finality como input mas só canonicaliza SettlementFinality após Reconciliation + proof. SettlementFinality é asserção BKR sobre o sistema, não eco passivo do rail. Different rails may expose different notions of irreversibility, revocation windows and compensating flows — BKR canonicaliza per Reconciliation, não per rail-specific finality semantic."
		}, {
			term:          "Successful Settlement"
			clarification: "Sucesso operacional ≠ finality canônica. Um attempt pode ter sucesso técnico no rail e ainda estar SettlementIndeterminate enquanto Reconciliation não consolidar. Sem finality declarada, BKR não emite evento canônico downstream."
		}, {
			term:          "Closed / Completed"
			clarification: "'Closed'/'Completed' são genéricos demais — incluem failed. SettlementFinality é especificamente o estado positivo irreversível verificado; um attempt failed também é 'closed' mas não tem finality."
		}]
		rejectedAlternatives: [{
			term:   "SettlementCompleted"
			reason: "'Completed' implica sucesso mas não distingue verificação. Finality enfatiza a irreversibilidade verificada, propriedade canônica do conceito."
		}, {
			term:   "SettlementClosed"
			reason: "Closed inclui failed; finality é positivo-irreversível especificamente."
		}, {
			term:   "FinalSettlement"
			reason: "Adjective-noun ordering esconde o conceito principal. 'Finality' como noun foca na propriedade canônica."
		}]
		examples: [{
			context:  "Pix bem-sucedido reconciliado"
			instance: "BKR dispara dispatch Pix com instructionId i-001 + idempotencyKey k-001. Rail retorna E2E ID + status SETTLED via pacs.002. Reconciliation deterministic match: i-001 ↔ railReferenceId E2E ↔ outcome SETTLED ↔ proof timestamp+signature. Estado transita para SettlementFinality. Evento canônico de settlement-completed emitido."
		}, {
			context:   "Confirmação rail isolada NÃO atinge finality"
			instance:  "Rail sinaliza ACCEPTED via pacs.002 mas Reconciliation detecta divergência de valor (47.250 instruído × 47.520 confirmado). Estado permanece SettlementIndeterminate até reconciliation manual ou escalation; SettlementFinality NÃO é declarada apesar do 'confirmation' rail."
			rationale: "Demonstra que confirmation rail isolada não atinge finality."
		}]
		relatedTerms: ["term-settlement-attempt", "term-settlement-indeterminate", "term-reconciliation", "term-authorization-proof"]
		layerMapping: {
			codeTerm: "SettlementFinality"
		}
	}, {
		code:       "term-settlement-indeterminate"
		name:       "Liquidação Indeterminada"
		termEn:     "Settlement Indeterminate"
		definition: "Estado canônico BKR-owned descrevendo SettlementAttempt cuja Reconciliation ainda não pôde determinar deterministically se o settlement foi bem-sucedido, falhou ou continua pending no rail. Causas típicas: rail timeout sem signal final, divergência entre instructionPayload e railOutcome, signal ambíguo do rail. SettlementIndeterminate is epistemically distinct from Failed — failed declara fracasso conhecido com proof; indeterminate declara estado de conhecimento incompleto. NÃO emite evento canônico downstream sob ambiguidade; consome reconciliation post-hoc, manual escalation ou rail-specific timeout policy."
		category:   "value"
		rationale:  "Conceptually state; representado como 'value' porque #TermCategory enum não inclui 'state'. Termo crítico porque colapsar indeterminate em Failed/Pending destruiria 3 propriedades: (a) replay safety — retry baseado em assumption de Failed pode causar double-settlement; (b) reconciliation semantics — indeterminate exige path de resolução distinto; (c) operational auditability — distinção entre 'sabemos que falhou' vs 'não sabemos ainda' é forensicamente essencial."
		antiTerms: [{
			term:          "Failed / Falha"
			clarification: "Failed = fracasso conhecido com proof rail (rail retornou REJECTED + reason code). Indeterminate = estado de conhecimento incompleto (timeout, signal ambíguo, divergência não resolvida). Tratar indeterminate como failed → retry assumindo failure → double-settlement risk se attempt anterior estava silently successful."
		}, {
			term:          "Finality"
			clarification: "Finality é estado canônico positivo pós-Reconciliation. Indeterminate é estado epistemicamente não-final; nunca deve ser tratado como finality parcial ou finality pendente."
		}, {
			term:          "Pending"
			clarification: "Pending implica progresso normal aguardando completion natural dentro de operational window. Indeterminate é especificamente quando deveria-se ter signal e não temos OU temos signal ambíguo. Pending durante operational window é normal; indeterminate é ambiguidade que exige path de resolução."
		}, {
			term:          "Timeout"
			clarification: "Timeout é uma causa de indeterminate, não o estado em si. Outras causas: value divergence, signal contradiction, missing reconciliation match. Timeout-driven indeterminate é resolvível via re-query do rail; value-divergence indeterminate exige reconciliation manual."
		}, {
			term:          "Unknown"
			clarification: "Unknown é genérico — indeterminate é especificamente sobre settlement state após dispatch técnico bem-sucedido. Antes do dispatch o estado é requested, não indeterminate; após reconciliation o estado é finality ou failed, não indeterminate."
		}]
		rejectedAlternatives: [{
			term:   "SettlementPending"
			reason: "Pending sugere progresso normal; indeterminate enfatiza ambiguidade não-resolvível por simples espera."
		}, {
			term:   "SettlementAmbiguous"
			reason: "Ambiguous é literário; indeterminate é técnico e ressoa com terminology de distributed systems (CAP-style indeterminism)."
		}, {
			term:   "SettlementUnresolved"
			reason: "Unresolved foca em ausência de resolução; indeterminate foca na natureza epistemológica do estado — mais preciso."
		}]
		examples: [{
			context:  "Rail timeout sem signal final"
			instance: "Dispatch Pix at 09:32:01; ack received at 09:32:01.250 (ACCEPTED). Operational window Pix expects pacs.002 SETTLED dentro de 30s. At 09:33:00 ainda sem SETTLED. Estado transita para SettlementIndeterminate; retry NÃO automático (poderia ser double-settlement se attempt original foi silently successful); BKR aguarda re-query Pix endpoint OR Bacen escalation per rail-specific timeout policy."
		}, {
			context:   "Value divergence em reconciliation"
			instance:  "Dispatched 47.250,00; rail confirmou processamento mas E2E record mostra 47.520,00. SettlementIndeterminate — pode ser bug provider, tampering, ou erro de instrução. NÃO declara Finality; escalation para reconciliation manual."
			rationale: "Demonstra que confirmação com divergência ≠ confirmação de finality."
		}]
		relatedTerms: ["term-settlement-attempt", "term-settlement-finality", "term-reconciliation", "term-failure-classification"]
		layerMapping: {
			codeTerm: "SettlementIndeterminate"
		}
	}, {
		code:       "term-reconciliation"
		name:       "Reconciliação"
		termEn:     "Reconciliation"
		definition: "Processo determinístico BKR-owned que correlaciona uma SettlementAttempt (com instructionId, attemptId, idempotencyKey, valor instruído, payee, rail-target) contra o output observado do rail (railReferenceId, valor confirmado, payee confirmado, status, timestamp) para produzir um outcome canônico: SettlementFinality, SettlementFailed ou SettlementIndeterminate. Match exige 4 condições: (a) instructionId presente no railReferenceId metadata OR claim chain match; (b) valor exato; (c) payee exato; (d) status terminal coerente. Qualquer divergência → indeterminate state, NÃO assumir finality."
		category:   "process"
		rationale:  "Capability central do BC (cap-reconciliation no canvas). Reconciliation is the deterministic process that distinguishes 'rail confirmed receipt' from 'system has verified settlement'. Sem Reconciliation, BKR vira eco passivo do rail. Categoria 'process' porque é sequência de validações com outcome; o output da reconciliation é um state value (Finality / Failed / Indeterminate)."
		antiTerms: [{
			term:          "Confirmation (do rail)"
			clarification: "Confirmation é input rail-level único (rail signaling); Reconciliation é processo BKR que consome confirmation + outras provas + instructionPayload e produz outcome canônico. Múltiplas confirmations podem alimentar uma Reconciliation; uma Reconciliation pode rejeitar confirmation por divergência."
		}, {
			term:          "Settlement (genérico)"
			clarification: "Settlement é amplo demais — Reconciliation é especificamente o processo de verificação cross-source. Settlement como verbo ('we settled X') é FCE-semantic; Reconciliation como processo ('we reconciled attempt X with rail signal Y') é BKR-semantic."
		}, {
			term:          "Dispatch"
			clarification: "Dispatch é envio ao rail; Reconciliation é verificação pós-dispatch contra output rail. Dispatch sem Reconciliation não produz estado canônico."
		}, {
			term:          "Match (genérico)"
			clarification: "Match é só uma das 4 condições da Reconciliation (instructionId match). Reconciliation completa exige match + value coherence + payee coherence + status terminal coherence. Reduzir a 'match' perde 3 condições."
		}, {
			term:          "Validation"
			clarification: "Validation é check estrutural (formato, signature, expiry) feito na entrada da instrução. Reconciliation é check cross-source feito post-dispatch contra realidade observada do rail. Validation é syntactic; Reconciliation é semantic + state-based."
		}, {
			term:          "Settlement Verification"
			clarification: "Verification implica passo único; Reconciliation é processo determinístico com múltiplas condições e outcome trichotomic (Finality / Failed / Indeterminate). Verification não captura o trichotomic outcome."
		}]
		rejectedAlternatives: [{
			term:   "SettlementMatching"
			reason: "Matching reduz a uma das 4 condições; reconciliation captura processo completo cross-source."
		}, {
			term:   "SettlementVerification"
			reason: "Verification implica passo único; reconciliation é processo determinístico com outcome trichotomic."
		}, {
			term:   "CrossCheck"
			reason: "Cross-check é genérico, sem ancoragem em settlement semantics."
		}]
		examples: [{
			context:  "Reconciliation bem-sucedida → SettlementFinality"
			instance: "Attempt a-001 dispatched Pix 47.250 to payee-y. Rail returna pacs.002 status SETTLED + E2E ID + amount 47.250 + payee-y. 4 condições satisfeitas: (a) E2E carries instructionId hint i-001 ✓ (b) valor exato ✓ (c) payee exato ✓ (d) SETTLED é terminal ✓. Outcome: SettlementFinality."
		}, {
			context:   "Reconciliation falha por divergência de valor → Indeterminate"
			instance:  "Attempt a-002 dispatched 100.000; rail confirma valor 99.500 (possible PSTI middleware bug ou taxa retida indevidamente). Condição (b) falha. Outcome: SettlementIndeterminate (NÃO Finality e NÃO Failed); escalation para reconciliation manual."
			rationale: "Demonstra que rail-confirmed value ≠ instruído triggers indeterminate path, não finality."
		}]
		relatedTerms: ["term-settlement-attempt", "term-settlement-finality", "term-settlement-indeterminate", "term-rail-reference-id", "term-instruction-id"]
		layerMapping: {
			codeTerm: "Reconciliation"
			apiTerm:  "reconciliations"
		}
	}, {
		code:       "term-instruction-id"
		name:       "InstructionId"
		termEn:     "Instruction ID"
		definition: "Value object identifier FCE-owned representando uma PaymentInstruction única no commitment lifecycle. Gerado em FCE no momento da emissão da instrução, antes de qualquer dispatch técnico em BKR. Permanece estável across all SettlementAttempts gerados sob essa instrução — é o fio de rastreabilidade business-level cross-BC. Cardinalidade: 1 InstructionId : N SettlementAttempts : N RailReferenceIds. NUNCA reutilizado entre instruções distintas. NUNCA usado como idempotency enforcement; BKR derives or assigns a separate IdempotencyKey per SettlementAttempt."
		category:   "value"
		rationale:  "Identifier upstream business correlation. Sem InstructionId estável, audit lineage cross-BC quebra: FCE não consegue correlacionar settlement outcomes aos commitments originais. Distinto dos outros 3 IDs do 4-way separation (AttemptId, IdempotencyKey, RailReferenceId) por ownership (FCE), granularidade (per business action) e propósito (rastreabilidade, NÃO enforcement nem identity técnica per execução)."
		antiTerms: [{
			term:          "AttemptId"
			clarification: "AttemptId é per execução técnica BKR (1 instructionId pode gerar N attemptIds via retries). Confundir InstructionId com AttemptId → todos retries indistinguíveis OR identity per attempt confundida com per business action."
		}, {
			term:          "IdempotencyKey"
			clarification: "IdempotencyKey é enforcement value per attempt; InstructionId é correlation per business action. Usar InstructionId como idempotency enforcement bloqueia retries legítimos (rail rejeita 'duplicate' incorretamente). Vector adversarial CRÍTICO do BC."
		}, {
			term:          "RailReferenceId"
			clarification: "RailReferenceId emerge no rail post-dispatch (E2E ID Pix, MessageId SWIFT). InstructionId existe pré-dispatch, originado upstream. Carregam direções opostas de lineage: instructionId carry-forward, railReferenceId observed-back."
		}, {
			term:          "Transaction ID"
			clarification: "Transaction ID é termo bancário tradicional ambíguo (pode significar attempt, rail, ou business correlation per provider). InstructionId é especificamente per business action FCE-owned — distinção semântica explícita."
		}, {
			term:          "Reference Number"
			clarification: "Reference number é genérico; InstructionId é especificamente identifier carregado upstream-to-downstream com semantic binding ao authorization proof."
		}]
		rejectedAlternatives: [{
			term:   "PaymentId"
			reason: "Mistura Payment (FCE concept) com identifier — ambíguo se identifica intent econômico OU instrução técnica. InstructionId é específico ao DTO técnico."
		}, {
			term:   "OrderId"
			reason: "Order implica unilateralidade; instrução BKR é resultado de decisão bilateral FCE já consumada."
		}, {
			term:   "BusinessCorrelationId"
			reason: "Verboso; InstructionId é mais conciso e operacionalmente claro."
		}]
		examples: [{
			context:  "InstructionId persists across retries"
			instance: "FCE emite PaymentInstruction com instructionId fce-2026-09823. BKR gera Attempt-1 (attemptId a-001), rail timeout → indeterminate. Após reconciliação manual confirmar falha, BKR gera Attempt-2 (attemptId a-002) sob mesmo instructionId fce-2026-09823. Audit trail completo correlaciona ambos attempts ao mesmo business intent."
		}, {
			context:   "Rejection de re-uso de InstructionId"
			instance:  "FCE tenta emitir nova PaymentInstruction reutilizando instructionId fce-2026-09823. BKR rejeita estruturalmente — instructionId previously consumed. Failure-classification: structural-invalid. FCE deve gerar novo instructionId."
			rationale: "InstructionId não é reutilizável; é fio de rastreabilidade único per business action."
		}]
		relatedTerms: ["term-payment-instruction", "term-settlement-attempt", "term-attempt-id", "term-idempotency-key", "term-rail-reference-id"]
		layerMapping: {
			codeTerm: "InstructionId"
			apiTerm:  "instruction_id"
		}
	}, {
		code:       "term-attempt-id"
		name:       "AttemptId"
		termEn:     "Attempt ID"
		definition: "Value object identifier BKR-owned representando uma execução técnica concreta (SettlementAttempt) contra um rail. Gerado em BKR no momento da decisão de dispatch (não na emissão da instrução upstream). Cardinalidade: 1 SettlementAttempt : 1 AttemptId; múltiplos AttemptIds podem existir sob 1 InstructionId via retries. AttemptId é a identidade do state machine atomic per attempt — todo state transition referencia attemptId; Reconciliation referencia attemptId. NÃO reutilizado entre attempts."
		category:   "value"
		rationale:  "Identifier técnico per execução. Sem AttemptId, retries colapsam em ambiguidade indistinguível: 'foi a primeira tentativa? a segunda? quantas?' — bloqueia debug forense e replay safety. Distinto dos outros 3 IDs do 4-way separation por granularidade (per attempt, não per business nem per rail-roundtrip) e ownership (BKR, não FCE nem rail)."
		antiTerms: [{
			term:          "InstructionId"
			clarification: "InstructionId é per business action FCE-owned; AttemptId é per execução BKR-owned. Mismatch granular: 1 InstructionId carrega N AttemptIds via retries. Confundir os dois esconde retries no audit trail."
		}, {
			term:          "IdempotencyKey"
			clarification: "AttemptId é identity (entidade WHICH attempt); IdempotencyKey é enforcement value (rail-side replay protection). Conceitualmente diferentes mesmo se algumas implementações usem mesmo valor — separação semântica preserva flexibilidade de design e clareza forense."
		}, {
			term:          "RailReferenceId"
			clarification: "AttemptId é BKR-side identity (existe pré-dispatch); RailReferenceId é rail-side identifier (emerge post-dispatch). Correlação entre os dois é trabalho da Reconciliation, não identidade compartilhada."
		}, {
			term:          "Retry ID / Retry Count"
			clarification: "Retry count é metadata (a quanta tentativa este attempt corresponde); AttemptId é identidade da entidade. Retry count derivável de attemptId+instructionId lineage."
		}, {
			term:          "Confirmation ID"
			clarification: "Confirmation ID seria identifier do signal rail recebido (subset de RailReferenceId em algumas implementações). AttemptId é BKR-side identity independente de receber confirmation ou não."
		}]
		rejectedAlternatives: [{
			term:   "ExecutionId"
			reason: "Execution implica ato pontual; attempt enfatiza tentativa com possibilidade de falha — semantically alinhado com state machine que inclui failed/indeterminate."
		}, {
			term:   "DispatchId"
			reason: "Dispatch é a ação inicial; attempt cobre toda lifecycle (dispatch + monitoring + reconciliation outcome). DispatchId perderia escopo."
		}, {
			term:   "TryId"
			reason: "Try é informal; attempt é técnico e ressoa com retry literature em distributed systems."
		}]
		examples: [{
			context:  "Multiple attempts under same instruction"
			instance: "InstructionId i-001. Attempt-1: attemptId a-001 (Pix dispatch, timeout, indeterminate). Attempt-2: attemptId a-002 (Pix re-dispatch após reconciliação manual confirmar falha do Attempt-1). Cada attemptId é único; lineage retrieved via instructionId."
		}, {
			context:   "AttemptId como state machine identity"
			instance:  "Estado per attempt: a-001 status=indeterminate; a-002 status=in-flight. BKR não emite evento canônico de settlement-completed para i-001 enquanto algum attempt sob i-001 permanecer non-final (proteção contra premature finalization)."
			rationale: "AttemptId identity é o que permite per-attempt state tracking sem colapsar instruction-level."
		}]
		relatedTerms: ["term-settlement-attempt", "term-instruction-id", "term-idempotency-key", "term-rail-reference-id"]
		layerMapping: {
			codeTerm: "AttemptId"
			apiTerm:  "attempt_id"
		}
	}, {
		code:       "term-idempotency-key"
		name:       "Chave de Idempotência"
		termEn:     "Idempotency Key"
		definition: "Value object BKR-constructed per SettlementAttempt usado como enforcement boundary contra duplicate execution no rail. Enviado ao rail (Idempotency-Key header HTTP, Pix idempotency control, SWIFT MessageId construct per protocol) para que o rail rejeite re-execuções com a mesma chave. Cardinalidade: 1 SettlementAttempt : 1 IdempotencyKey; nunca reutilizado across attempts (retry sob mesmo instructionId gera novo idempotencyKey). Enforcement per IdempotencyKey per attempt, NUNCA per InstructionId — usar instructionId como idempotency bloqueia retries legítimos (rail rejeita como duplicate falso-positivo)."
		category:   "value"
		rationale:  "Enforcement boundary anti-replay / anti-double-settlement. Distinto de AttemptId (que é entity identity) porque IdempotencyKey é o VALOR enviado ao rail para enforcement, semanticamente sobre 'don't execute this twice', não sobre 'which attempt is this'. Em algumas implementações IdempotencyKey pode coincidir com AttemptId literal; separação canônica preserva clareza semântica e flexibilidade de design (e.g., idempotencyKey como hash deterministico do payload, enquanto attemptId é UUID puro)."
		antiTerms: [{
			term:          "InstructionId"
			clarification: "USAR InstructionId como IdempotencyKey é vector adversarial CRÍTICO: bloqueia retries legítimos. InstructionId persists across attempts; IdempotencyKey é per-attempt. Esse erro silencia replay attacks como bonus mas mata recurring legítimo — falha em ambos os lados do trade-off."
		}, {
			term:          "AttemptId"
			clarification: "AttemptId é entity identity (BKR-side state); IdempotencyKey é rail enforcement value (BKR→rail boundary). Mesmo se uma implementação use o mesmo valor literal, semanticamente são conceitos distintos — separação preserva clareza forense e permite divergência de implementação."
		}, {
			term:          "RailReferenceId"
			clarification: "RailReferenceId emerge no rail post-receipt; IdempotencyKey é enviado pelo BKR pre-dispatch. Direções opostas no boundary BKR↔rail."
		}, {
			term:          "Replay Token"
			clarification: "Replay token é genérico; IdempotencyKey é especificamente enforcement value que rail consulta para deduplicate. Replay protection é o efeito, idempotency é o mecanismo."
		}, {
			term:          "Hash"
			clarification: "Hash é estrutura de dados; IdempotencyKey pode ser hash mas pode ser UUID ou qualquer string. O conceito é semantic role (enforcement boundary), não a estrutura interna."
		}]
		rejectedAlternatives: [{
			term:   "DedupKey"
			reason: "Dedup é informal; idempotency é o termo técnico canônico em HTTP REST literature e rail protocols (Pix, SWIFT)."
		}, {
			term:   "RailIdempotencyKey"
			reason: "Rail prefix redundante — todo IdempotencyKey em BKR é para enforcement no rail. Brevidade prevalece."
		}, {
			term:   "ReplayProtectionKey"
			reason: "Replay protection é o EFEITO; idempotency é o MECANISMO. Nomear por efeito perde semântica HTTP / rail-protocol nativa."
		}]
		examples: [{
			context:  "Per-attempt enforcement, NÃO per-instruction"
			instance: "InstructionId i-001. Attempt-1: idempotencyKey k-001 enviado ao SPI. Pix processa, retorna E2E. Reconciliation resulta indeterminate. Decisão de retry: Attempt-2 com idempotencyKey k-002 (NOVA chave). Rail trata k-002 como nova request — não rejeita como duplicate. Retry legítimo permitido."
		}, {
			context:   "Replay attack blocked"
			instance:  "Adversário re-submete dispatch com mesmo idempotencyKey k-001. Pix detecta duplicate, retorna response cached (não executa novamente). BKR recebe response coerente com Attempt-1 original; não cria Attempt novo, não double-settles."
			rationale: "IdempotencyKey enforcement bloqueia replay attack mantendo legítimo retry possível (porque novo dispatch técnico após decisão de retry gera nova key)."
		}]
		relatedTerms: ["term-settlement-attempt", "term-attempt-id", "term-instruction-id", "term-rail-reference-id"]
		layerMapping: {
			codeTerm: "IdempotencyKey"
			apiTerm:  "idempotency_key"
		}
	}, {
		code:       "term-rail-reference-id"
		name:       "Referência do Rail"
		termEn:     "Rail Reference ID"
		definition: "Value object identifier rail-owned, atribuído pelo rail no recebimento ou processamento de uma SettlementAttempt. Exemplos por rail: E2E ID em Pix via SPI (gerado por Bacen), MessageId em SWIFT MX (gerado per pacs.008), CustomerCreditTransferInitiation reference em TED via STR, registry number em boleto via SILOC. BKR observa RailReferenceId nos signals retornados pelo rail; nunca emite — apenas correlaciona via Reconciliation contra (instructionId, attemptId, idempotencyKey) para produzir outcome canônico. Cardinalidade: 1 SettlementAttempt : 0..N rail-observed references, with one primary RailReferenceId selected for canonical reconciliation when available."
		category:   "value"
		rationale:  "Identifier externo rail-owned. Distinto dos outros 3 IDs do 4-way separation por ownership (rail, não FCE nem BKR) e direction (observed-back, não carry-forward). Sem RailReferenceId canônico, Reconciliation perde o anchor para verificar que o que o rail processou corresponde ao que BKR despachou. Categoria 'value' porque é identifier dado pelo rail; BKR consome, não constrói."
		antiTerms: [{
			term:          "InstructionId"
			clarification: "InstructionId é FCE-originated upstream; RailReferenceId é rail-originated downstream. Direções opostas de fluxo. Confundi-los esconde origem do identifier — útil para auditoria forense saber 'isto veio do upstream' vs 'isto veio do rail'."
		}, {
			term:          "AttemptId"
			clarification: "AttemptId é BKR-internal entity identity (existe pré-dispatch, persiste mesmo se rail nunca confirmar); RailReferenceId é rail-assigned (só existe post-rail-receipt). Conceitos não-equivalentes mesmo quando 1:1 em casos normais."
		}, {
			term:          "IdempotencyKey"
			clarification: "IdempotencyKey é BKR-sent enforcement value (request side); RailReferenceId é rail-returned identifier (response side). Boundary inverso: idempotencyKey é input para o rail, railReferenceId é output do rail."
		}, {
			term:          "Transaction ID (do rail)"
			clarification: "Transaction ID é termo bancário ambíguo (pode significar rail-internal txid, settlement reference, ou batch id). RailReferenceId é especificamente o identifier que o rail expõe canonicamente per protocol (E2E em Pix, MessageId em SWIFT, etc.)."
		}, {
			term:          "Settlement Reference"
			clarification: "Settlement reference é genérico — pode confundir com SettlementFinality ou SettlementAttempt. RailReferenceId enfatiza explicitamente origem rail."
		}]
		rejectedAlternatives: [{
			term:   "ProviderId"
			reason: "Provider é ambíguo (PSTI ≠ banco parceiro ≠ Bacen ≠ CIP); rail é o termo canônico para a infraestrutura."
		}, {
			term:   "ExternalRefId"
			reason: "External é genérico; rail é específico ao domínio de settlement."
		}, {
			term:   "RailTxId"
			reason: "Tx (transaction) é termo bancário ambíguo (vide antiTerm). Reference é mais neutro e preciso."
		}]
		examples: [{
			context:  "Pix E2E ID como RailReferenceId"
			instance: "Attempt-1 dispatched ao SPI. Bacen retorna pacs.002 com EndToEndId 'E11223344202609230932000123456'. BKR registra como railReferenceId of Attempt-1. Reconciliation correlaciona (instructionId i-001, attemptId a-001, idempotencyKey k-001, railReferenceId E11223344...) → outcome verification."
		}, {
			context:   "Ausência de RailReferenceId"
			instance:  "Attempt-2 dispatched ao SPI, conexão TCP falhou antes do rail aceitar. RailReferenceId ausente. SettlementAttempt status=failed (BKR-authoritative); Reconciliation não tenta correlacionar. Decisão de retry escalation upstream."
			rationale: "Ausência de RailReferenceId é signal forensicamente preciso de que dispatch falhou pre-rail-accept."
		}]
		relatedTerms: ["term-settlement-attempt", "term-attempt-id", "term-idempotency-key", "term-instruction-id", "term-reconciliation"]
		layerMapping: {
			codeTerm: "RailReferenceId"
			apiTerm:  "rail_reference_id"
		}
	}, {
		code:       "term-technical-rail-selection"
		name:       "Seleção Técnica de Rail"
		termEn:     "Technical Rail Selection"
		definition: "Processo BKR-owned de selecionar o rail concreto (Pix via SPI, TED via STR, TED via SITRAF, boleto via SILOC, SWIFT, Drex futuro) para um SettlementAttempt baseado em 4 critérios estritamente técnicos: (a) technical availability — rail dentro de operational window; (b) protocol compatibility — payer/payee suportam o protocolo; (c) latency admissibility — rail latency admissível contra upstream-declared settlement semantics (constraint check, não optimization target); (d) upstream-declared constraints — instrução pode pinar rail específico ou fallback list. Quando instrução não pina rail, BKR seleciona deterministicamente per estes critérios. NUNCA por cost optimization local, treasury position, ou fee arbitrage."
		category:   "process"
		rationale:  "Termo perigosíssimo. Sem cercamento adversarial explícito, 'selecionar rail' vira porta de entrada para BKR exercer decisões econômicas — manipulação de spread, otimização de fee, arbitragem de timing. Per dp-08 (custo de manipulação > benefício), seleção é restritamente técnica. Categoria 'process' (não 'rule') porque é sequência de avaliação de critérios; a regra subjacente vive como bd-rail-selection-is-technical-only no canvas."
		antiTerms: [{
			term:          "Otimização Econômica (Economic Optimization)"
			clarification: "Otimização econômica de roteamento (qual rail é mais barato, qual rende float) é decisão FCE-owned se aplicável; NUNCA BKR. Selecionar rail por custo seria payment decision implícita — vector adversarial explícito do BC."
		}, {
			term:          "Decisão de Tesouraria (Treasury Decision)"
			clarification: "Decisões de tesouraria (qual rail preserva liquidez, qual rail minimiza float, qual rail favorece counterparty position) são TCM-owned se modeladas, NUNCA BKR. BKR consome TCM como constraint operacional advisory (operational window), não como input de decisão de roteamento."
		}, {
			term:          "Arbitragem de Tarifa (Fee Arbitrage)"
			clarification: "Arbitragem de fee entre rails (escolher rail menos taxado para minimizar custo) seria decisão econômica de pricing — domínio TCM/policy upstream. BKR seleciona rail por viabilidade técnica; o custo é exposto upstream se modelado, nunca otimizado dentro de BKR."
		}, {
			term:          "Roteamento Inteligente (Smart Routing)"
			clarification: "'Smart routing' carrega conotação de otimização adaptativa (latency, custo, success rate ponderados). BKR rail-selection é determinístico per 4 critérios técnicos explícitos — não adaptive scoring, não machine learning, não preference functions econômicas."
		}, {
			term:          "Cross-Rail Failover"
			clarification: "Failover entre rails (Pix falha → tentar TED) altera settlement semantics (Pix instant vs TED D+0) e exige autorização upstream explícita na instrução. Failover automático sem authorization seria payment decision implícita. TechnicalRailSelection cobre seleção inicial determinística, NÃO fallback automático cross-rail."
		}]
		rejectedAlternatives: [{
			term:   "RailRouting"
			reason: "Routing carrega conotação de algoritmo adaptive/multi-objective. BKR seleciona deterministicamente per critérios fixos."
		}, {
			term:   "RailDispatch"
			reason: "Dispatch é a ação executiva pós-seleção (capability cap-protocol-translation); selection é o passo antecedente de escolha."
		}, {
			term:   "SmartRailSelection"
			reason: "'Smart' implica adaptive optimization — semanticamente errado para BKR."
		}, {
			term:   "OptimalRailChoice"
			reason: "'Optimal' implica função-objetivo a maximizar; BKR satisfaz critérios técnicos, não maximiza."
		}]
		examples: [{
			context:  "Seleção determinística sem rail-hint"
			instance: "Instrução sem rail pinado, payer/payee ambos com chave Pix válida, validity-window 5min, operational window Pix 24/7 ON. Critérios: (a)✓ (b)✓ (c)✓ Pix latency <30s admissível contra validity-window (d) N/A. BKR seleciona Pix. Decisão registrada no audit trail com 4-criteria-evaluation."
		}, {
			context:   "Rail pinado por upstream"
			instance:  "Instrução pina rail=ted. BKR valida critério (a) STR dentro de operational window (Bacen hours), (b) ambas instituições autorizadas STR, (c) latency admissível (D+0 dentro validity window). Selection respeita pin upstream. BKR não substitui pin por 'rail mais barato'."
			rationale: "Upstream pin é constraint vinculante, não sugestão otimizável."
		}, {
			context:   "Rejeição por critério (a)"
			instance:  "Instrução chega 02:30 com rail-hint=ted. Critério (a) STR fora de operational window (Bacen STR opera 06h30-18h). BKR NÃO auto-substitui por Pix; rejeita ou enfileira per upstream-declared fallback policy."
			rationale: "Substituição automática violaria boundary."
		}]
		relatedTerms: ["term-operational-window", "term-payment-instruction", "term-settlement-attempt", "term-regulatory-boundary"]
		layerMapping: {
			codeTerm: "TechnicalRailSelection"
		}
	}, {
		code:       "term-operational-window"
		name:       "Janela Operacional"
		termEn:     "Operational Window"
		definition: "Value object descrevendo restrição temporal de disponibilidade per rail: período(s) durante o(s) qual(is) o rail aceita dispatch e processa settlements. Exemplos canônicos: Pix via SPI 24/7 (sem janela restritiva); STR direto Bacen ~06h30-18h dias úteis; SITRAF via CIP janelas específicas; SILOC via CIP janelas batch D+0/D+1; SWIFT MX janelas per cut-off correspondent banking. OperationalWindow é constraint técnico observável (não decision target), consumido por (a) TechnicalRailSelection critério (a); (b) timeout policy per attempt; (c) escalation criteria. Variável per rail e ao longo do tempo (Bacen publica mudanças de calendário operacional)."
		category:   "value"
		rationale:  "Conceito técnico que aparece transversal em capabilities, businessDecisions e governanceScope do canvas. Sem termo canônico, BCs downstream e código de tooling confundem operational window (rail-defined availability) com SLA promise (BKR commitment) ou com timing policy (FCE/TCM decision). Categoria 'value' porque é estrutura de dados observável (start, end, recurrence, calendário per rail), não processo nem regra. Aparece em failure classification como contexto causal: 'failed por operational-window-closed' é distinto de 'failed por technical-failure'."
		antiTerms: [{
			term:          "Settlement SLA"
			clarification: "SLA é promessa de serviço (BKR commits a entregar settlement em X tempo). OperationalWindow é constraint observável do rail (Bacen define horários STR). BKR não promete SLA contra OperationalWindow — apenas valida admissibility per TechnicalRailSelection critério (a)."
		}, {
			term:          "Business Hours"
			clarification: "Business hours sugere horário comercial humano; OperationalWindow é horário rail-technical (algumas janelas SILOC vão até 23h). Não confundir UX hour com rail availability hour."
		}, {
			term:          "Cutoff Time"
			clarification: "Cutoff é endpoint específico (e.g., 'TED cutoff Bacen 17h'); OperationalWindow abrange o período completo (start, end, recurrence). Cutoff é atributo do window, não o window."
		}, {
			term:          "Latency Window"
			clarification: "Latency window é tolerance temporal per instrução upstream (validity window da AuthorizationProof). OperationalWindow é constraint do rail. Conceitos ortogonais — instrução pode ter latency window curto enquanto rail tem operational window aberto, e vice-versa."
		}, {
			term:          "Scheduling Policy"
			clarification: "Scheduling policy é decisão de quando agendar dispatch (FCE/TCM upstream); OperationalWindow é o constraint contra o qual scheduling se valida."
		}]
		rejectedAlternatives: [{
			term:   "RailHours"
			reason: "Hours sugere unidade temporal; window é estrutura mais geral (start, end, recurrence, calendar exceptions)."
		}, {
			term:   "AvailabilityWindow"
			reason: "Availability é genérico (pode confundir com system uptime); operational é específico ao domain banking rails."
		}, {
			term:   "ProcessingHours"
			reason: "Processing é genérico; operational ressoa com canonical literature (Bacen 'horário operacional')."
		}]
		examples: [{
			context:  "Pix 24/7 window"
			instance: "OperationalWindow for SPI: always-on, no calendar restriction. TechnicalRailSelection critério (a) sempre satisfied for Pix; window-closed classification não se aplica ao Pix under normal SPI operation."
		}, {
			context:   "STR Bacen restricted window"
			instance:  "OperationalWindow for STR: weekdays 06:30-18:00 BRT, except Bacen holidays. Instrução chega 19:00 com rail-hint=ted. TechnicalRailSelection critério (a) FAIL. BKR não substitui rail; rejeita per upstream-declared fallback policy OR enfileira para próxima window."
			rationale: "Demonstra constraint check, não optimization."
		}, {
			context:  "SILOC batch window"
			instance: "OperationalWindow for SILOC boleto: batch D+0 com cutoff 16:00 BRT, batch D+1 com cutoff 22:00 BRT. Instrução chega 16:15 com rail-hint=boleto. Window D+0 closed; instrução enfileira para D+1 OR rejeita per policy upstream."
		}]
		relatedTerms: ["term-technical-rail-selection", "term-settlement-attempt", "term-failure-classification"]
		layerMapping: {
			codeTerm: "OperationalWindow"
		}
	}, {
		code:       "term-failure-classification"
		name:       "Classificação de Falha"
		termEn:     "Failure Classification"
		definition: "Processo determinístico BKR-owned de classificar uma SettlementAttempt failed (ou rejected pre-dispatch) em uma de 5 categorias ortogonais que codificam ownership causal: (1) structural-invalid — BKR authoritative (instrução malformada, signature inválida, validity window expired); (2) technical-failure — BKR authoritative (rail conexão falha, timeout BKR-side, dispatch system error); (3) provider-or-rail-reject — external, com subtypes regulatory (rail rejeita per regra Bacen/CIP), account-status (conta cancelada/bloqueada), rail-limit (limite operacional do rail), provider-policy (rejection per política interna do provider/PSTI); (4) upstream-policy-reject — upstream (decisão FCE/REW pré-dispatch que BKR materializou); (5) business-invalid — upstream semantic (valor incompatível, payee mismatch nível business, instrução inconsistente com regras FCE). Classification determina routing de remediation (BKR ajusta vs rail re-attempt vs upstream re-authorize)."
		category:   "process"
		rationale:  "Capability central do BC (cap-failure-classification no canvas). Sem classification deterministic, falhas viram blob homogêneo e remediation degenera em retry-everything (vector de double-settlement) ou escalate-everything (vector de paralisia operacional). Categoria 'process' porque é sequência de avaliação de evidência → categoria + ownership atribution. Subtypes em provider-or-rail-reject preservam granularidade observacional sem colapsar 'rejeição externa = regulatória' (account-status, rail-limit, provider-policy NÃO são regulatórios). Side-channel mitigation explícita: classification detail granular emitido apenas para FCE upstream (canal autorizado); downstream consumers recebem categoria agregada sanitizada (preserva confidentiality de regulatory reasons / provider internal codes)."
		antiTerms: [{
			term:          "Error Code"
			clarification: "Error code é raw rail-side string (Bacen reason code, SWIFT error category). FailureClassification é o processo BKR de mapear error codes + observed state em uma das 5 categorias canônicas com ownership atribution. Error code é input, classification é outcome."
		}, {
			term:          "Settlement Failed"
			clarification: "Settlement Failed é um possible outcome state (post-classification). FailureClassification é o PROCESS que decide se está Failed (vs Indeterminate vs Finality). Confundir os dois sugere que 'failed' é binário — mas há 5 sub-categorias com paths de remediation distintos."
		}, {
			term:          "Retry Decision"
			clarification: "Retry decision é consequência downstream da classification; classification não é retry decision per se. structural-invalid pode requerer upstream re-authorize (não retry); technical-failure pode justificar retry; business-invalid sempre requer upstream intervention."
		}, {
			term:          "Rejection (genérico)"
			clarification: "Rejection é genérico — pode vir da borda BKR (structural-invalid), do rail (provider-or-rail-reject), ou ser materialização de upstream policy reject. Classification distingue origem e ownership."
		}]
		rejectedAlternatives: [{
			term:   "FailureCategorization"
			reason: "Categorização é sinônimo, mais formal. Classification ressoa com domain literature (reconciliation, accounting classification) e é mais conciso."
		}, {
			term:   "ErrorMapping"
			reason: "Error mapping sugere lookup table determinístico; classification é processo de avaliação multi-evidence."
		}, {
			term:   "SettlementFailureRouting"
			reason: "Routing é consequência (onde escalate); classification é o passo antecedente que produz a categoria + ownership."
		}]
		examples: [{
			context:  "structural-invalid (BKR authoritative)"
			instance: "Instrução chega com AuthorizationProof expired (validity-window passed). BKR rejeita na borda. Classification: structural-invalid; ownership: BKR-authoritative. Remediation: FCE deve re-autorizar e re-emitir; BKR não tenta novamente."
		}, {
			context:   "provider-or-rail-reject (external, regulatory subtype)"
			instance:  "Pix dispatch aceito por SPI mas rail retorna pacs.002 status=RJCT reason=AC04 (conta cancelada na DICT). Classification: provider-or-rail-reject subtype=account-status; ownership: external. BKR não pode remediar; emite categoria agregada para FCE downstream + detail granular ao canal supervisionado."
			rationale: "Distingue de structural-invalid (BKR borda) e de business-invalid (FCE upstream); subtype account-status preserva precisão (não é puramente regulatória)."
		}, {
			context:   "business-invalid (upstream semantic)"
			instance:  "Instrução tem payee CNPJ correto mas branch identifier inconsistente com cadastro FCE-side. BKR detecta via cross-check pre-dispatch. Classification: business-invalid; ownership: upstream-semantic. Routing: FCE recebe detail; BKR não dispatches."
			rationale: "Demonstra ownership upstream-semantic que BKR detecta mas não decide."
		}]
		relatedTerms: ["term-settlement-attempt", "term-settlement-indeterminate", "term-authorization-proof", "term-regulatory-boundary"]
		layerMapping: {
			codeTerm: "FailureClassification"
			apiTerm:  "failure_classifications"
		}
	}, {
		code:       "term-regulatory-boundary"
		name:       "Fronteira Regulatória"
		termEn:     "Regulatory Boundary"
		definition: "Regra constitutiva do BC declarando que BKR opera sob fronteira regulatória externa (Bacen via SPB/SPI/STR/SILOC; CIP via SITRAF/SILOC; SWIFT via standards MX; futuro Drex via Bacen) mas NÃO enforça policy regulatória. BKR consome regulatory constraints como inputs estruturais absorvidos (operational windows per rail, ISO 20022 schemas, settlement irreversibility rules, payment arrangement requirements), traduz para technical execution e propaga rejection codes upstream — sem interpretar, redefinir ou substituir a autoridade regulatória. RegulatoryBoundary constrains BKR behavior but does not grant BKR regulatory authority. Fronteira é bidirecional: BKR não inventa regulação; não absorve obrigação fiscal-tributária (ATO); não absorve responsabilidade KYC/AML enforcement (FCE/IDC/NPM)."
		category:   "rule"
		rationale:  "Regra de positioning do BC. Sem RegulatoryBoundary canônica, dois erros simétricos emergem: (a) BKR vira mini-regulator pretendendo enforçar regras Bacen (overreach inválido); (b) Bacen vira consumer downstream BKR (semantic error — regulator não consome eventos do regulado). Categoria 'rule' porque é invariant constitutivo do BC, não processo nem identifier. Diferencia BKR de banking adapter genérico (que poderia interpretar regulação) e de FCE/IDC (que enforçam policy)."
		antiTerms: [{
			term:          "Regulatory Compliance Enforcement"
			clarification: "Compliance enforcement (verificar KYC, AML, sanctions screening) é FCE/IDC/NPM territory — BCs com mandato proprietário sobre policy. BKR observa rejection regulatória do rail mas não decide policy compliance pre-dispatch (exceto structural validation da instrução)."
		}, {
			term:          "Bacen Integration"
			clarification: "Bacen integration sugere relationship operacional bilateral. BKR integra com rails (SPI, STR, SILOC) via instituição autorizada parceira ou PSTI homologada — NÃO direto com Bacen como autoridade. Bacen é boundary constraint authority, NÃO downstream consumer nem integration peer."
		}, {
			term:          "Regulatory Policy Implementation"
			clarification: "Implementation sugere materialização ativa de policy. BKR absorve policy como constraint passivo (operational window, schema, irreversibility rule); não implementa policy (não decide quem pode pagar, quanto, quando — isso é FCE)."
		}, {
			term:          "Bacen Reporting"
			clarification: "Reporting ao Bacen é fluxo legal específico que tipicamente vive em IDC/NPM/ATO via parceiro autorizado, não em BKR. BKR pode prover dados (audit trail, settlement records) como source, mas o channel de reporting não é BKR-owned."
		}]
		rejectedAlternatives: [{
			term:   "RegulatoryCompliance"
			reason: "Compliance implica enforcement ativo; BKR absorve constraint passivo. Boundary enfatiza fronteira de não-overreach."
		}, {
			term:   "RegulatoryInterface"
			reason: "Interface sugere bidirectional integration peer; boundary enfatiza constraint absorption não-bidirectional (regulator → BKR é input; BKR → regulator não é channel canônico)."
		}, {
			term:   "RegulatoryAdapter"
			reason: "Adapter sugere translation layer técnica; boundary captura o invariant constitutivo (BKR não enforça policy, apenas absorve)."
		}]
		examples: [{
			context:  "BKR absorve, não enforça"
			instance: "Bacen publica nova regra de operational window STR (e.g., extension de horário). BKR atualiza capability cap-protocol-translation para refletir nova window via spec change. NÃO decide se aplica a uma instrução específica — apenas valida technical-availability per critério (a) da TechnicalRailSelection. Decisão sobre se a instrução merece ser executada per nova janela é FCE."
		}, {
			context:   "Bacen NÃO é downstream consumer"
			instance:  "BKR processa Pix com sucesso. Settlement records ficam em audit trail BKR. Reporting ao Bacen para fins de SOC/CONIF flui via instituição autorizada parceira (canal regulado); BKR não publica eventos para Bacen, apenas expõe data sources."
			rationale: "Mantém fronteira: BKR é regulated, não regulator-facing."
		}, {
			context:   "Rejection regulatória do rail"
			instance:  "SPI rejeita Pix com AC04 (conta cancelada). BKR classifica como provider-or-rail-reject subtype account-status; encaminha categoria + detail granular para FCE; não tenta workaround regulatório (e.g., 'tentar TED no lugar' seria interpretar policy)."
			rationale: "Mostra que BKR propaga rejection sem interpretar."
		}]
		relatedTerms: ["term-payment-instruction", "term-failure-classification", "term-technical-rail-selection", "term-authorization-proof"]
		layerMapping: {
			codeTerm: "RegulatoryBoundary"
		}
	}, {
		code:       "term-reverse-settlement"
		name:       "Reversão de Liquidação"
		termEn:     "Reverse Settlement"
		definition: "Processo de reversão de SettlementFinality previamente declarada, originando obrigação econômica NOVA distinta da PaymentInstruction original. Compreende: estornos (Pix devolução, pacs.004 SWIFT), refunds upstream-initiated, chargebacks, judicial reversals, dispute-driven reversals (originadas em DRC). REVERSE SETTLEMENT IS NOT BKR-OWNED. BKR pode executar tecnicamente uma reverse-settlement instruction (e.g., processar pacs.004 dispatch) MAS apenas quando a obrigação reversa foi gerada e autorizada upstream (FCE para refunds policy-driven; DRC para dispute reversal; regulatory authority para Bacen-mandated reversal). FORA do Phase 0 BKR scope — documentado em openQuestions do canvas como cluster a definir."
		category:   "process"
		rationale:  "Termo gatekeeper máximo. Sem cercamento adversarial maximum, ReverseSettlement é o vector #1 de BKR scope creep — porque rails têm protocolos nativos de reversão (Pix devolução, SWIFT pacs.004) e tooling de execução técnica reversa parece naturalmente BKR-owned. A semântica econômica da reversão (decisão de devolver, decisão de chargeback, adjudicação de disputa) NÃO é BKR. Categoria 'process' porque é fluxo de execução técnica de instruções reversas; a regra subjacente ('BKR não decide reversal economically') vive cross-rationale do BC."
		antiTerms: [{
			term:          "Refund / Reembolso"
			clarification: "Refund é decisão econômica FCE-owned (decidir devolver) ou DRC-owned (resolver disputa). BKR pode executar refund instruction tecnicamente, mas refund decision NÃO é BKR. Confundir os dois → BKR vira FCE (autoriza reembolsos). VECTOR ADVERSARIAL CRÍTICO."
		}, {
			term:          "Chargeback"
			clarification: "Chargeback é processo de dispute resolution com arbiter (regulator, card network, dispute resolution body — DRC). BKR pode executar leg técnica do chargeback (dispatch da reversal instruction), mas adjudication NÃO é BKR. Confundir → BKR vira DRC."
		}, {
			term:          "Estorno"
			clarification: "Estorno é termo bancário ambíguo: pode significar correção contábil (ATO), refund (FCE-decision), Pix devolução (DRC ou FCE upstream decision), ou cancelamento técnico pre-finality (não é reversal, é cancellation). ReverseSettlement abrange apenas reversal post-finality com nova obrigação econômica upstream-authorized."
		}, {
			term:          "Correction"
			clarification: "Correction is ambiguous: it may mean data correction, accounting correction, dispute correction or economic reversal. ReverseSettlement only covers post-finality economic reversal authorized upstream."
		}, {
			term:          "Cancelamento Pré-Liquidação"
			clarification: "Cancelamento de SettlementAttempt antes de finality (e.g., RequestSettlementCancellation) é operação BKR-owned NON-GUARANTEED (rail pode aceitar pacs.057 ou não). NÃO é ReverseSettlement — cancellation acontece pré-finality; reversal acontece post-finality como nova obrigação."
		}, {
			term:          "Treasury Adjustment"
			clarification: "Ajuste de tesouraria (TCM territory) — realocação de posição liquidez para corrigir desbalanço operacional. NÃO é settlement reversal; é movimento patrimonial interno. BKR não tem authority de tesouraria, mesmo para correção própria."
		}, {
			term:          "Settlement Cancellation"
			clarification: "Settlement cancellation pode significar (a) cancelamento pré-finality (BKR-owned, non-guaranteed) OR (b) reversal post-finality (NOT BKR-owned). Sem disambiguation, termo é vector de scope creep. ReverseSettlement é especificamente (b)."
		}, {
			term:          "Compensating Settlement"
			clarification: "Compensating settlement (settlement reverso para corrigir settlement anterior) sugere BKR autônomo de compensation logic. BKR não tem authority de compensation econômica — apenas executa instrução compensatória upstream-authorized."
		}]
		rejectedAlternatives: [{
			term:   "SettlementReversal"
			reason: "Word ordering: 'Reverse Settlement' alinha com terminologia de rails (Pix devolução, pacs.004 reversal); 'Settlement Reversal' enfatiza o processo administrativo. Founder direction Phase 2.1 priorizou rail-aligned naming."
		}, {
			term:   "Refund"
			reason: "Refund colapsa com FCE concept; mistura semantic ownership."
		}, {
			term:   "Estorno Técnico"
			reason: "Termo bancário ambíguo (vide antiTerm 'Estorno'); 'técnico' não resolve a ambiguidade."
		}, {
			term:   "DisputeReversal"
			reason: "Dispute reversal é só um dos tipos (DRC-originated); ReverseSettlement abrange refund, chargeback, judicial e regulatory também."
		}, {
			term:   "BackoutSettlement"
			reason: "Backout sugere operação técnica autônoma reversível (database backout); ReverseSettlement é nova obrigação econômica, não rollback técnico."
		}]
		examples: [{
			context:   "DRC-originated reversal (post-dispute)"
			instance:  "Compromisso X com SettlementFinality declarada em t-100d. Dispute resolvida em DRC determina reversão. DRC emite instrução de reversal para FCE; FCE gera ReversePaymentInstruction com AuthorizationProof próprio (NOVA autorização, NÃO derivada da original); BKR consome e executa via pacs.004. BKR NÃO decidiu reverter; apenas executou."
			rationale: "Demonstra ownership upstream-decision + BKR-execution-only."
		}, {
			context:   "Pix devolução por FCE policy"
			instance:  "FCE detecta que SettlementFinality foi a payee errado por erro de instrução (post-finality). FCE decide refund via Pix devolução. Emite ReversePaymentInstruction → BKR executa Pix devolução request. BKR NÃO sugere refund; NÃO automaticamente reverte; espera instrução upstream."
			rationale: "BKR não interpreta erros upstream como mandate de reversal."
		}, {
			context:   "Anti-pattern: BKR autonomous reversal"
			instance:  "BKR detecta divergência em Reconciliation post-finality (signal tardio de invalidade do rail). NÃO emite reversal autonomously. Escalation: emite ReconciliationAnomaly evento para FCE; FCE decide se há reversal mandate. BKR aguarda upstream decision."
			rationale: "Mostra explicitamente o anti-pattern e o pattern correto."
		}]
		relatedTerms: ["term-settlement-finality", "term-payment-instruction", "term-authorization-proof", "term-failure-classification"]
		layerMapping: {
			codeTerm: "ReverseSettlement"
		}
	}]

	rationale: """
		Glossário canônico do BC BKR — Banking Rails & Settlement.
		Estabelece a linguagem ubíqua de execução técnica de settlement
		sob intenção econômica autorizada upstream, cobrindo 15 termos
		canônicos distribuídos em 5 categorias semânticas (entity,
		value, process, rule).

		This glossary is a boundary-hardening artifact, not an
		onboarding dictionary. Sua função primária é prevenir colapso
		semântico entre economic intent (FCE), technical execution
		(BKR), rail signaling (provider/Bacen/CIP) e canonical system
		state (BKR-canonicalized). Densidade adversarial (73 antiTerms
		entries + 50 rejectedAlternatives + 36 examples) reflete a
		posição do BC: BKR é o portão técnico onde manipulação
		econômica disfarçada (cost optimization, treasury arbitrage,
		autonomous reversal, regulatory enforcement overreach) tem
		maior superfície de ataque.

		Anti-colapso transversal — cobertura dos 5 sinônimos frouxos
		cristalizada explicitamente:
		- Pagamento (Payment) — FCE-owned conceito econômico, NÃO BKR.
		- Liquidação (Settlement genérico) — decomposto em
		  SettlementAttempt (entidade), SettlementFinality (estado
		  canônico), SettlementIndeterminate (estado epistemic não-
		  final).
		- Dispatch — ação técnica BKR-internal, NÃO synonym de
		  Payment nem Settlement.
		- Confirmation — signal rail-level, DISTINTO de Reconciliation
		  (processo BKR) e SettlementFinality (estado canônico).
		- Finality — rail-determined fact; BKR canonicaliza apenas
		  post-Reconciliation com proof verificável.

		Núcleo 4-way ID separation (InstructionId × AttemptId ×
		IdempotencyKey × RailReferenceId) é anti-replay / anti-double-
		settlement: cada ID com ownership, granularidade e direção de
		fluxo distintas; cross-anti-collapse matrix completa (cada ID
		anti-colide explicitamente contra os outros 3) garante que
		nenhum colapsa em sinônimo dos outros.

		Lenses aplicadas (5): lens-domain-language-and-terminology-
		design (primária — bilingual mapping pt-BR/en, term selection
		criteria, cross-layer consistency); lens-regulatory-compliance-
		as-architecture (boundary absorption não-enforcement —
		RegulatoryBoundary constrains BKR behavior but does not grant
		BKR regulatory authority); lens-distributed-systems-design
		(4-way ID lineage, atomic state machine per attempt,
		reconciliation determinism); lens-trust-and-credibility-design
		(AuthorizationProof como cryptographic boundary; BKR consumes
		authorization semantics, does not originate them); lens-
		mechanism-design (incentive alignment via anti-decision
		boundary cristalizada como vocabulário canônico).

		Event naming intentionally deferred to domain-model authoring
		(Phase 3) to preserve distinction between operational completion
		and canonicalized settlement finality. O domain-model.cue de BKR já existe
		com aggregate, entity, value-object, event, command e invariant
		building blocks com prefixos canônicos (agg-, ent-, vo-, evt-,
		cmd-, inv-); os domainModelRefs dos terms permanecem vazios —
		o backfill dos refs é trabalho futuro.

		Forward-looking: glossário cobre Phase 0 / Phase 1 conceptual
		surface. Termos para emerging rails (Drex CBDC, Pix
		internacional, Open Finance ITP) e expanding fronteiras
		(ReverseSettlement workflow completo, secondary reconciliation
		automation, recurring payment lineage cross-BC) virão em wave
		futura quando openQuestions do canvas (clusters OQ-A/B/C)
		resolverem.
		"""
}
