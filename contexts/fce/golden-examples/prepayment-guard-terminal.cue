package fce

// prepayment-guard-terminal.cue — VALIDAÇÃO TERMINAL do walking skeleton
// (WI-138 / W006-fce-terminal-validation / adr-138 decisão 3).
//
// ╔══════════════════════════════════════════════════════════════════╗
// ║ TERMINAL-VALIDATION — NÃO É GOLDEN-EXAMPLE DE FAN-OUT.            ║
// ║ Instância de #GoldenExample REUSADA como terminal-validation      ║
// ║ (decisão em execução prevista no wave-plan WI-138; founder        ║
// ║ 2026-06-12: reuso com marcação explícita > proliferar schema      ║
// ║ para n=1). isTemplate: false. O valor deste artefato é provar a   ║
// ║ COMPOSIÇÃO cross-BC (CMT→DLV→INV→[REW]→FCE→[BKR]), não inaugurar  ║
// ║ o pipeline de um BC (isso é o ge-cmt). Promoção a                 ║
// ║ #TerminalValidation first-class via ADR no 2º cenário terminal.   ║
// ╚══════════════════════════════════════════════════════════════════╝
//
// DECLARAÇÃO-PURA (adr-145): zero campo de evidência; o resultado de rodar
// viverá em evidência separada (direção evidência→declaração, precedente
// run-001/codegen-validation-evidence).
//
// COMPOSIÇÃO CROSS-BC (a struct #GoldenExample é mono-BC por construção —
// specSlice abaixo cobre o FCE, dono do cenário; a composição vive AQUI e
// nos rationales, com refs por id, regime de verificação idêntico ao dos
// refs formais: review + harness, adr-145 N1 / tq-ge-02):
//
//   1. CMT (real)    — commitment em 'accepted' (inv-mutual-bilateral-
//                      acceptance; ponto de partida provado pelo ge-cmt).
//   2. DLV (real)    — evidência custodiada no reference adapter
//                      content-addressed (store → address sha256) →
//                      cmd-record-evidence → cmd-evaluate-verification →
//                      evt-delivery-verified (inv-verified-requires-
//                      evidence-or-override + inv-binary-outcome).
//   3. INV (real)    — evt-invoice-issued (bd-issuance-requires-
//                      verification, contexts/inv/canvas.cue:382; o FCE
//                      consome via espelho-7, def-057).
//   4. REW           — faceta eligibility (decision=eligible) de
//                      evt-risk-evaluation-emitted, consumida via
//                      contrato-de-consumo #EligibilityConsumption
//                      (contexts/fce/schemas/events.cue, def-057 d).
//   5. FCE (alvo)    — cmd-materialize-payment → PrePaymentGuard compõe
//                      (a) fatura ✓ (b) elegibilidade ✓ (c) EvidencePort.
//                      verify() → receipt valid=true ✓ →
//                      cmd-authorize-payment → evt-payment-authorized
//                      (authorization proof) →
//                      cmd-dispatch-payment-instruction.
//   6. BKR (FIXTURE) — evt-settlement-finalized (fixture-contract dos
//                      schemas do FCE).
//   7. FCE           — cmd-settle-payment → evt-payment-settled (fato
//                      canônico; inv-settled-fact-canonical).
//
//   CASO NEGATIVO (obrigatório): evidência com INTEGRIDADE VIOLADA no
//   passo 5c — EvidencePort.verify() retorna receipt valid=false → o
//   guard BLOQUEIA → Payment PERMANECE em 'guarded' com motivo (sem
//   transição; T2 do domain-model). Exercita a condição (c) e a
//   fronteira integridade ≠ verdade (glossário term-cadeia-de-evidencia).
//
// MAPEAMENTO CENÁRIO→INVARIANTES (cruzamento verificado por grep
// pré-escrita, padrão N5(a) — todos os ids existem no disco):
//   FCE: inv-money-moves-only-on-proof (5±), inv-guard-deterministic (5),
//        inv-at-most-once-dispatch (5→6), inv-no-partial-settlement (5–7),
//        inv-settled-fact-canonical (7).
//   CMT: inv-mutual-bilateral-acceptance (1).
//   DLV: inv-verified-requires-evidence-or-override, inv-binary-outcome (2).
//   INV: bd-issuance-requires-verification (3).
//
// O QUE A EXECUÇÃO EXIGE DO RUNTIME E AINDA NÃO EXISTE (expectativa
// honesta — este artefato é SPEC; a execução é pacote-runtime
// subsequente): (i) harness de COMPOSIÇÃO cross-BC — o pipeline atual
// gera/compila/testa POR BC, não instancia múltiplos aggregates + 2
// reference adapters e encadeia o fluxo; (ii) assertion-tests
// hand-encoded do cenário (não há contexts/fce/ hand no mesh-runtime;
// def-049 interino); (iii) test-doubles emitindo os 2 eventos fixture
// (REW/BKR). Gates abaixo definidos ANTES desse run (real-options).

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"
)

goldenExample: artifact_schemas.#GoldenExample & {
	id:                  "ge-fce-prepayment-guard-terminal"
	boundedContextRef:   "fce"
	businessDecisionRef: "bd-money-moves-only-on-proof"

	specSlice: {
		invariantRefs: [
			"inv-money-moves-only-on-proof",
			"inv-guard-deterministic",
			"inv-at-most-once-dispatch",
			"inv-no-partial-settlement",
			"inv-settled-fact-canonical",
		]
		commandRefs: [
			"cmd-materialize-payment",
			"cmd-authorize-payment",
			"cmd-dispatch-payment-instruction",
			"cmd-settle-payment",
		]
		eventRefs: [
			"evt-payment-authorized",
			"evt-payment-instruction-dispatched",
			"evt-payment-settled",
		]
		aggregateRef: "agg-payment"
		rationale: """
			Recorte do FCE (BC dono): o caminho do guard inteiro —
			guarded→authorized→dispatched→settled + o bloqueio (permanece
			guarded). Os refs cross-BC da composição (CMT/DLV/INV reais,
			REW/BKR fixtures) vivem no header e no rationale externo com
			regime de verificação idêntico (review + harness, adr-145 N1):
			a struct specSlice é mono-BC por construção e o FCE é o dono
			do cenário. Refs ao domain-model do FCE (P0), nunca cópia.
			"""
	}

	assertionRefs: ["asrt-money-moves-only-on-proof"]

	codegenTarget: {
		kinds: ["types", "aggregate-skeleton", "port-contracts", "stubs", "contract-tests", "assertion-tests"]
		rationale: """
			types/aggregate-skeleton/port-contracts do FCE JÁ gerados e
			compilando (pacote-runtime da fatia FCE, mesh-runtime#6) —
			este cenário os CONSOME, não os inaugura. stubs = reference
			adapters in-memory existentes (eventlog + evidence,
			content-addressed). contract-tests = suites Tier-1/2
			existentes (reuso declarado no pm-fce). assertion-tests = a
			derivar de asrt-money-moves-only-on-proof: ≥1 caso válido
			(fluxo 1–7 termina settled) + ≥1 BLOQUEIO (receipt
			valid=false → permanece guarded) — hand-encoded no interino
			def-049, encodando os joins por commitmentRef (limite V1 da
			assertion, ver rationale dela).
			"""
	}

	gates: {
		continuar: """
			A composição sobe APENAS com reference adapters in-memory
			(zero vendor): os types/skeletons dos BCs da composição
			compilam, e os assertion-tests do cenário passam — ≥1 caso
			válido (CMT accepted → DLV verified com evidência custodiada
			→ INV issued → REW eligible (fixture) → guard pass com
			verify() valid=true → authorized→dispatched→settled(fixture
			BKR) → PaymentSettled emitido exatamente uma vez) E ≥1 caso
			de bloqueio (integridade violada → receipt valid=false →
			Payment permanece guarded, nenhum evento de pagamento
			emitido).
			"""
		pivotar: """
			A spec da composição não tem informação para encadear os
			passos sem preenchimento manual — e.g., o elo
			DeliveryVerified→InvoiceIssued→materialize não é derivável
			dos schemas/manifests, ou os fixture-contracts REW/BKR são
			insuficientes para o guard decidir — revisar spec
			(domain-models/schemas dos BCs da composição) ou o harness
			de composição (adr-138 item 7).
			"""
		abandonar: """
			O output gerado de qualquer BC da composição exige EDIÇÃO
			SEMÂNTICA MANUAL para compilar ou para o fluxo passar —
			viola P1; re-escolher toolchain (adr-138 item 7).
			"""
		p1Strict: """
			Edições no output gerado são PROIBIDAS, exceto header de
			arquivo gerado, configuração de formatação, ou scaffolding
			de adapter temporário documentado FORA do código gerado
			(adr-138 item 7, P1 estrito). Test-doubles dos fixtures
			REW/BKR e assertion-tests hand-encoded são HAND-AUTHORED
			legais fora dos diretórios gerados.
			"""
		falsificationSignal: """
			Qualquer arquivo gerado editado SEMANTICAMENTE para o fluxo
			passar; OU o cenário só fecha colapsando a composição num
			único aggregate (provaria que o template NÃO compõe entre
			BCs — exatamente o que adr-138 decisão 3 manda detectar).
			"""
		rationale: """
			Gates são CONDIÇÃO definida ANTES do run (real-options,
			adr-138 item 7), nunca resultado — o resultado medido viverá
			em evidência separada quando o harness de composição existir
			(pacote-runtime subsequente). O falsificationSignal é o
			específico do TERMINAL: falha de composição, não de geração.
			"""
	}

	templateRole: {
		isTemplate: false
		divergencePolicy: """
			n/a — terminal-validation é ÚNICA por construção (adr-138
			decisão 3: prova a composição, não inaugura pipeline de BC);
			não é molde de fan-out e nenhum BC a copia. O template do
			fan-out é o ge-cmt (WI-139).
			"""
		rationale: """
			Marcação explícita do reuso: instância #GoldenExample
			operando como terminal-validation (ver header). isTemplate
			false impede leitura como molde; o 2º cenário terminal
			promove o tipo via ADR.
			"""
	}

	rationale: """
		Validação TERMINAL do walking skeleton (adr-138 decisão 3): prova
		que o template do golden-example COMPÕE entre BCs — o
		PrePaymentGuard (P11, money-on-proof) é cross-BC por construção:
		consome o aceite do CMT (via cadeia), a verificação do DLV, a
		fatura do INV, a elegibilidade do REW (fixture) e delega
		liquidação ao BKR (fixture), movendo dinheiro APENAS quando a
		operação comprova. Reuso de #GoldenExample com marcação tripla
		(header + templateRole + este rationale) em vez de tipo novo para
		n=1 (decisão founder 2026-06-12; desvio do path do wave-plan
		registrado no stream WI-138 e no task-spec). Caso negativo
		exercita a condição (c) e a fronteira integridade ≠ verdade. A
		execução é pacote-runtime subsequente (harness de composição +
		assertion-tests hand, def-049); gates definidos antes do run.
		"""
}

// #Assertion embutida (padrão ge-cmt): formaliza inv-money-moves-only-on-proof
// na gramática estruturada. Referenciada por goldenExample.assertionRefs.
moneyMovesOnlyOnProofAssertion: shared_schemas.#Assertion & {
	id:      "asrt-money-moves-only-on-proof"
	subject: "Payment em transição para o estado 'settled' (e, por implicação da cadeia, qualquer dispatch)"
	variables: [
		{name: "state", source: "aggregate-state", filter: "Payment.state"},
		{name: "invoiceEvidence", source: "event-log", filter: "evt-invoice-issued (INV, espelho-7) para o commitmentRef do Payment"},
		{name: "eligibilityDecision", source: "event-log", filter: "evt-risk-evaluation-emitted.eligibility.decision (faceta consumida via #EligibilityConsumption) para o entityRef do pagador do commitmentRef"},
		{name: "verifyReceiptValid", source: "contract", filter: "VerificationReceipt.valid retornado por EvidencePort.verify(address, proof) para a cadeia de evidência que lastreia o invoiceEvidence (rtd-012: receipt determinístico e re-verificável)"},
	]
	predicate: {
		op: "implies"
		operands: [
			{relation: "eq", left: {var: "state"}, right: {const: "settled"}},
			{
				op: "and"
				operands: [
					{relation: "exists", left: {var: "invoiceEvidence"}},
					{relation: "eq", left: {var: "eligibilityDecision"}, right: {const: "eligible"}},
					{relation: "eq", left: {var: "verifyReceiptValid"}, right: {const: "true"}},
				]
			},
		]
	}
	rationale: """
		Formaliza inv-money-moves-only-on-proof (P11): estado 'settled'
		implica fatura presente E elegibilidade 'eligible' E receipt de
		integridade válido — dinheiro só se move quando a operação
		comprova. O codegen deriva ≥1 caso válido (3 condições satisfeitas,
		fluxo termina settled) + ≥1 inválido (receipt valid=false → o guard
		bloqueia e settled é inalcançável: Payment permanece guarded).
		LIMITES DE FIDELIDADE V1 (disciplina idêntica ao
		asrt-mutual-bilateral-acceptance do CMT): (a) os JOINS — mesmo
		commitmentRef entre Payment/invoice/evidência e entityRef do
		pagador — vivem nos filters (prosa), NÃO no predicate (sem
		variável de join; def-053/054); (b) 'settled' como proxy: o
		invariante real guarda o DISPATCH (pré-condição), o predicate
		observa o estado terminal alcançado — a equivalência depende da
		cadeia authorized→dispatched→settled do lifecycle (guards do
		am-payment); (c) source 'contract' para o receipt: o enum fechado
		da assertion-grammar não tem source de Port-operation — 'contract'
		é a leitura mais próxima (dado do contrato de Port), resolução
		mecânica herda def-053 — revisitar quando a gramática ganhar
		source de port-operation OU o receipt for persistido no data do
		PaymentAuthorized (segunda forma tem mérito de auditabilidade
		próprio). INTERINO (def-049): os assertion-tests
		hand-encoded DEVEM encodar os joins por commitmentRef/entityRef e
		o caso de bloqueio com Payment inalterado em guarded — auto-codegen
		puro deste predicate validaria uma APROXIMAÇÃO.
		"""
}
