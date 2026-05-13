package fce

// glossary.cue — Ubiquitous Language: Financial Commitment Execution.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Termos canônicos do BC FCE. Define a linguagem que agentes,
// código, contratos e interfaces usam ao operar neste contexto.
//
// Centering principle: FCE glossary is a boundary-hardening
// artifact for conditional economic authority, not a payment
// terminology dictionary. Cada term canoniza conceito cujo
// mis-naming levaria FCE a colapsar em 'sistema de pagamentos'
// ou apagar fronteiras com BKR (settlement execution), CMT
// (commitment lifecycle), REW (risk), BDG (budget), DLV
// (evidence), INV (invoice), ATO (accounting), TCM (treasury).
//
// 22 termos em 4 axes semânticas:
// (A) Identity & Authorization — 4 termos
// (B) Lifecycle & Financialization — 7 termos
// (C) Retention & Conditional Release — 4 termos
// (D) Boundary, Authority & Anti-Patterns — 7 termos
//
// Cross-BC alignments com BKR glossary peer preservados por
// convention de ownership lens (3 termos compartilhados:
// term-authorization-proof, term-payment-instruction,
// term-bkr-settlement-outcome).
//
// Lenses aplicadas (5):
// - lens-domain-language-and-terminology-design (primária)
// - lens-trust-and-credibility-design
// - lens-mechanism-design
// - lens-regulatory-compliance-as-architecture
// - lens-distributed-systems-design
//
// Materializado em Phase 2 do WI-043 FCE bootstrap via 4
// batches incrementais (Cluster A→D) + ajustes finos founder
// pre-write across cada batch (5+2+2 ajustes acumulados).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code: "fce"
	name: "Glossário FCE — Financial Commitment Execution"

	boundedContextRef: "fce"

	terms: [{
		code:   "term-economic-authority-crystallization"
		name:   "Cristalização de Autoridade Econômica"
		termEn: "Economic Authority Crystallization"
		definition: """
			Processo canônico FCE de converter autoridade econômica
			condicionada — distribuída entre upstream BCs (BDG budget,
			REW risk, CMT lifecycle, DLV evidence, INV invoice, NPM
			counterparty) — em obrigação financeira network-visible e
			executable. Crystallization ocorre por convergência de N
			upstream conditions, não por decisão volitiva: FCE não
			autoriza no sentido ativo; FCE evidencia que autorização
			ocorreu. Identity nucleus do BC — sem este conceito FCE
			colapsa para 'payment orchestrator'.
			"""
		category:  "process"
		rationale: "Term canônico de identidade do BC. Substitui interpretação de FCE como 'sistema de pagamentos' por interpretação correta: bounded context responsável por cristalizar autoridade econômica condicionada. Sem este term canonicamente posto, semantic drift é caminho de menor resistência. Boundary-hardening: define o que FCE é, por contraste explícito com o que não é."
		antiTerms: [{
			term:          "Pagamento (Payment)"
			clarification: "Pagamento é resultado downstream de crystallization (executado por BKR sob PaymentInstruction). Crystallization é o ato semântico anterior — não confundir resultado físico com processo de autoridade."
		}, {
			term:          "Autorização (Authorization Act)"
			clarification: "Autorização sugere ato volitivo (alguém autoriza). Crystallization é evidence-driven: condições convergem, autoridade emerge — FCE evidencia, não decide."
		}, {
			term:          "Orquestração de Pagamento (Payment Orchestration)"
			clarification: "Orquestração descreve coordenação técnica de operações. Crystallization é fato semântico sobre autoridade econômica, não procedural step."
		}]
		rejectedAlternatives: [{
			term:   "Payment Authorization"
			reason: "Mistura ato (authorization) com resultado (payment); apaga propriedade canônica de convergência (não decisão)."
		}, {
			term:   "Financial Decision Crystallization"
			reason: "Decision é exatamente o que NÃO é — convergência ≠ decisão."
		}, {
			term:   "Economic Commitment Materialization"
			reason: "Commitment lifecycle vive em CMT; materialization sugere physical layer (BKR). Crystallization preserva camada semântica única do FCE."
		}]
		examples: [{
			context:   "Convergência completa de upstream conditions"
			instance:  "BDG.budget-available + REW.risk-gate-passed + CMT.commitment-active + DLV.evidence-validated + INV.invoice-approved + NPM.counterparty-qualified convergem para PaymentObligation. FCE não decide pagar — FCE materializa que autoridade já se constituiu upstream."
			rationale: "Cristalização canônica: input set converge → autoridade cristalizada existe."
		}, {
			context:   "Convergência parcial → não-crystallization"
			instance:  "REW.risk-gate=pending impede convergência. FCE retém em AuthorizationPending; não pode acelerar por relaxar condição (anti-pattern condition-weakening) nem completar autoridade heurística (não-canonical)."
			rationale: "Crystallization é all-or-nothing per AuthorizationConvergenceSet."
		}]
		relatedTerms: [
			"term-authorization-convergence",
			"term-authorization-convergence-set",
			"term-payment-obligation",
			"term-downstream-authoritative",
			"term-condition-weakening",
		]
		layerMapping: {
			codeTerm: "EconomicAuthorityCrystallization"
			apiTerm:  "authority-crystallization"
		}
	}, {
		code:   "term-authorization-convergence"
		name:   "Convergência de Autorização"
		termEn: "Authorization Convergence"
		definition: """
			Convergência canônica de um conjunto pré-declarado de N
			upstream conditions cuja satisfação simultânea constitui
			autoridade para crystallization. Convergência é evidência
			observada, não decisão tomada — FCE observa o set completo
			e matricula o fato 'autoridade existe agora'. Per canonical
			clause #1: authorization is convergence not decision. Sem
			convergência completa, AuthorizationProof não pode ser
			emitida; relaxar threshold para acelerar é
			ec-condition-weakening-to-accelerate (PRIMARY drift
			detector).
			"""
		category:  "process"
		rationale: "Term distingue postura epistemológica canônica do FCE (observação de convergência) de postura imprópria (decisão proativa de autorizar). É a definição operacional do canonical clause #1 — sem este term, agentes geram código onde FCE 'decide autorizar' em vez de 'evidenciar convergência'."
		antiTerms: [{
			term:          "Decisão de Autorização (Authorization Decision)"
			clarification: "Decision implica agency volitiva; convergence implica observation of pre-conditions. FCE não decide, FCE observa. Confundir os dois é o erro semântico #1 do BC."
		}, {
			term:          "Aprovação (Approval)"
			clarification: "Approval pertence ao approving authority (humano ou agent upstream). Convergence é mecanismo arquitetural — não há 'aprovador' do FCE; há set of conditions cuja satisfação produz autoridade."
		}, {
			term:          "Verificação de Autorização (Authorization Verification)"
			clarification: "Verification sugere checar autoridade pré-existente. Convergence produz autoridade by composing upstream conditions — autoridade emerge da convergência, não é verificada como entidade externa."
		}]
		examples: [{
			context:   "Convergência observada → AuthorizationProof emitida"
			instance:  "Todas 7 upstream conditions retornam satisfied dentro de validity window. FCE observa set complete, emite AuthorizationProof bound cryptograficamente ao PaymentInstruction payload."
			rationale: "Postura canônica: observação → evidência → emissão."
		}, {
			context:   "Convergência incompleta + pressão temporal"
			instance:  "6/7 conditions satisfied; CMT.commitment-active aguardando ack upstream. Pressão operacional sugere relaxar para 6/7 'aceitável'. FCE rejeita relaxamento — ec-condition-weakening fires; defer authorization até 7/7 ou abandonar instruction."
			rationale: "Convergence é binary completeness, never threshold tuning."
		}]
		relatedTerms: [
			"term-economic-authority-crystallization",
			"term-authorization-convergence-set",
			"term-upstream-condition",
			"term-authorization-proof",
			"term-condition-weakening",
			"term-convergence-integrity",
		]
		layerMapping: {
			codeTerm: "AuthorizationConvergence"
			apiTerm:  "authorization-convergence"
		}
	}, {
		code:   "term-authorization-convergence-set"
		name:   "Conjunto de Convergência de Autorização"
		termEn: "Authorization Convergence Set"
		definition: """
			Conjunto canônico, finito e fechado de upstream conditions
			cuja convergência integral constitui autoridade para
			crystallization. Cada condition é UpstreamCondition
			produzida por BC upstream específico
			(BDG.budget-available, REW.risk-gate-passed,
			CMT.commitment-active, DLV.evidence-validated,
			INV.invoice-approved, NPM.counterparty-qualified, etc.).
			Set é declarado a priori per payment obligation type — não
			dinamicamente expandido nem reduzido no momento de
			avaliação. Mutação do set (adicionar/remover conditions) é
			decisão de design FCE separada do processamento de
			convergência.
			"""
		category:  "value"
		rationale: "Term canoniza propriedade arquitetural fundamental: o conjunto de conditions é predeclared, não improvisado per case. Esta propriedade impede dois drifts: (a) shopping for satisfied conditions; (b) silent boundary erosion (ec-convergence-boundary-erosion-detected). Sem este term, agentes podem gerar lógica que evolui set dinamicamente — drift difícil de detectar."
		antiTerms: [{
			term:          "Authorization Rules"
			clarification: "Rules sugere policy procedural avaliada step-by-step. Convergence set é conjunto declarativo cuja completeness é checked atomicamente — diferença semântica importante."
		}, {
			term:          "Authorization Checklist"
			clarification: "Checklist sugere sequência ordenada que pode falhar parcialmente. Convergence set é all-or-nothing; partial satisfaction não produz partial authorization."
		}]
		rejectedAlternatives: [{
			term:   "Authorization Predicates"
			reason: "Predicates é abstração matemática genérica; convergence set é especificamente o conjunto definido per payment obligation type que FCE materializes."
		}, {
			term:   "Required Conditions"
			reason: "Required é descritivo mas perde a propriedade canônica fechado-e-declarado-a-priori."
		}]
		examples: [{
			context:   "Set canônico para PaymentObligation tipo straight-payment"
			instance:  "{ BDG.budget-available, REW.risk-gate-passed, CMT.commitment-active, INV.invoice-approved, NPM.counterparty-qualified }. Set declarado at design-time; evaluation observa todos 5 simultaneamente."
			rationale: "Predeclared, finite, fechado."
		}, {
			context:   "Evolução do set ≠ runtime improvisation"
			instance:  "Adicionar nova condition (e.g., DLV.evidence-validated) ao set para straight-payment é decisão de design que altera AuthorizationConvergenceSet definition. Não pode ocorrer em runtime per case."
			rationale: "Mutação do set é arquitetural, não operacional."
		}]
		relatedTerms: [
			"term-authorization-convergence",
			"term-upstream-condition",
			"term-convergence-boundary-erosion",
			"term-convergence-integrity",
		]
		layerMapping: {
			codeTerm: "AuthorizationConvergenceSet"
			apiTerm:  "convergence-set"
		}
	}, {
		code:   "term-authorization-proof"
		name:   "Prova de Autorização"
		termEn: "Authorization Proof"
		definition: """
			Value object FCE-originated emitido upon convergence
			observed, carregando evidência criptográfica verificável de
			que AuthorizationConvergenceSet convergiu. Composição
			mínima: (a) signature sobre instructionId + payer + payee
			+ value (binding criptográfico — proof é semanticamente
			bound to specific instruction payload, não credential
			reutilizável; mutação de payload invalida signature por
			construção); (b) nonce previne replay; (c) issued-at +
			validity window upstream-declared; (d) reference às
			upstream conditions observadas convergir; (e) claim chain
			link to FCE agent identity. BKR consome AuthorizationProof
			como pré-condição estrutural para dispatch; BKR não
			interpreta nem estende validity. Cross-BC peer: BKR
			glossary term-authorization-proof define lens consumer.
			"""
		category:  "value"
		rationale: "Term de fronteira crítica FCE↔BKR. A propriedade cryptographic-binding (absorvida da decisão de design bd-authorization-proof-cryptographic-binding) está canonizada na definition (item a) e antiTerms — sem isso, AuthorizationProof pode ser interpretado como token genérico reutilizável, perdendo binding semântico a instruction específica. Cross-BC alignment com BKR glossary peer preservado: same artifact, diferentes lenses (FCE-originated vs BKR-consumed)."
		antiTerms: [{
			term:          "Token de Autorização (Authorization Token)"
			clarification: "Token implica credential reutilizável (Bearer, OAuth). AuthorizationProof é per-instruction, single-use, semanticamente bound ao payload — não reutilizável entre instruções."
		}, {
			term:          "Assinatura (Signature)"
			clarification: "Signature é componente da proof (item a), mas proof completa requer nonce, validity window e claim chain. Reduzir AuthorizationProof a signature solta habilita replay attacks."
		}, {
			term:          "Permissão (Permission)"
			clarification: "Permission é amplo (RBAC, ACL). AuthorizationProof é especificamente evidência cryptográfica sobre uma payment obligation específica — não amplia 'esse usuário pode pagar'."
		}, {
			term:          "Autorização (Authorization Act)"
			clarification: "Autorização é o ato (que em FCE é convergence-observed); proof é a evidência do ato. Confundir os dois leva a modelo onde proof produz autoridade em vez de evidenciá-la."
		}]
		rejectedAlternatives: [{
			term:   "PaymentAuthorization"
			reason: "Mistura Payment lifecycle com authorization moment; AuthorizationProof é o artefato distinto que viaja entre BCs."
		}, {
			term:   "AuthorizationCredential"
			reason: "Credential implies reusability; proof é per-instruction binding."
		}, {
			term:   "ConvergenceProof"
			reason: "Tecnicamente mais preciso (convergence-observed produz a proof), mas AuthorizationProof preserva linguagem operacional do domínio financeiro e mantém alinhamento com BKR glossary peer."
		}]
		examples: [{
			context:   "Emissão pós-convergence observed"
			instance:  "AuthorizationConvergenceSet converge at 09:30:00. FCE emite proof com signature sobre payload {instructionId: fce-2026-09823, payer: x, payee: y, value: 47250.00}, nonce: abc123, issued-at: 09:30:00, validity-window: 15min, conditions-snapshot: [bdg-OK, rew-OK, cmt-OK, dlv-OK, inv-OK]."
			rationale: "Proof exists because convergence ocorreu, not because FCE decided."
		}, {
			context:   "Tentativa de reutilizar proof para outra instruction"
			instance:  "Agent tenta usar proof de instruction A para instruction B (alterando payload). Signature falha; proof rejected. Cryptographic binding faz reuso impossível por construção."
			rationale: "Cryptographic binding materializado: per-instruction semantic binding via signature payload."
		}]
		relatedTerms: [
			"term-authorization-convergence",
			"term-payment-instruction",
			"term-economic-authority-crystallization",
			"term-prepayment-guard",
		]
		layerMapping: {
			codeTerm: "AuthorizationProof"
			apiTerm:  "authorization-proofs"
		}
	}, {
		code:   "term-payment-obligation"
		name:   "Obrigação de Pagamento"
		termEn: "Payment Obligation"
		definition: """
			Aggregate central FCE: obrigação financeira cristalizada
			após convergência completa de AuthorizationConvergenceSet,
			em ciclo de vida desde authorization até reconciliação
			final. PaymentObligation carrega referência a
			CMT.commitment (não é o commitment), a INV.invoice (não
			é a invoice), e ao AuthorizationProof emitido. Sua
			identidade econômica é FCE-owned; sua execução física é
			BKR-delegated. Lifecycle states (Authorized, Sent, Failed,
			Reversed, PaymentPendingFinalReconciliation, Settled,
			etc.) governados por 11 invariantes canônicas em
			domain-model.
			"""
		category:  "entity"
		rationale: "Aggregate root do FCE. Distingue camada econômica (PaymentObligation = FCE-owned) das camadas adjacentes: Commitment (CMT-owned upstream), Payment Execution (BKR-owned downstream), Account Payable (ATO ledger). Sem este term, agentes geram modelo onde 'Payment' aparece como aggregate único atravessando FCE/BKR — colapso de boundaries."
		antiTerms: [{
			term:          "Pagamento (Payment)"
			clarification: "Payment é termo ambíguo; no FCE, a entidade correta é PaymentObligation. A execução física é settlement execution, delegated to BKR. Confundi-los apaga fronteira FCE↔BKR."
		}, {
			term:          "Compromisso (Commitment)"
			clarification: "Commitment é CMT-owned: lifecycle do compromisso econômico (estabelecido, em-andamento, finalizado). PaymentObligation é a obrigação derivada de Commitment quando autoridade econômica cristaliza no FCE — não é o commitment, é referência a ele."
		}, {
			term:          "Conta a Pagar (Account Payable)"
			clarification: "Account Payable é abstração contábil ATO-owned para ledger entries. PaymentObligation é o aggregate operacional FCE pre-settlement; ATO registra consequência contábil downstream."
		}, {
			term:          "Dívida (Debt / Liability)"
			clarification: "Liability é classification contábil-financeira; PaymentObligation é aggregate operacional com state machine. Mesmo conceito subjacente, mas mismatch de layer."
		}]
		rejectedAlternatives: [{
			term:   "Payment"
			reason: "Colapso semântico crítico — Payment é execução BKR, não obrigação FCE."
		}, {
			term:   "PaymentRecord"
			reason: "Record sugere ledger entry passive; obligation tem state machine ativa."
		}, {
			term:   "FinancialObligation"
			reason: "Não distingue obrigação de pagamento de outras obrigações financeiras (retention, reverse settlement). Payment-prefix é específico ao subset que FCE governa."
		}]
		examples: [{
			context:   "Crystallization → PaymentObligation criada"
			instance:  "AuthorizationConvergenceSet converge para fce-2026-09823. FCE cria PaymentObligation com state=Authorized, references {commitment: cmt-2026-1827, invoice: inv-2026-7621, authorization-proof: ap-09823-x}, e emite PaymentInstruction para BKR."
			rationale: "Aggregate emerge da crystallization; identidade FCE-owned."
		}, {
			context:   "Lifecycle states distintos de payment execution"
			instance:  "PaymentObligation em state=Sent indica que PaymentInstruction foi dispatched a BKR; BKR pode estar em qualquer estado interno (dispatching, rail-attempting, retrying). FCE state e BKR state são acoplados por eventos, não compartilhados."
			rationale: "Boundary preservation: FCE state machine ≠ BKR state machine."
		}]
		relatedTerms: [
			"term-payment-lifecycle",
			"term-economic-authority-crystallization",
			"term-payment-instruction",
			"term-financialization",
			"term-retention",
		]
		layerMapping: {
			codeTerm: "PaymentObligation"
			apiTerm:  "payment-obligations"
		}
	}, {
		code:   "term-payment-lifecycle"
		name:   "Ciclo de Vida do Pagamento"
		termEn: "Payment Lifecycle"
		definition: """
			State machine FCE-owned governando PaymentObligation desde
			Authorized até estado terminal (Settled, Cancelled,
			Reversed, PaymentPendingFinalReconciliation). Transitions
			são FCE-authored — driven por (a) economic interpretation
			de canonical settlement outcomes consumidos como eventos
			upstream, (b) decisions internas como retention release ou
			reverse settlement upstream-mandated, (c) timeout/expiry
			de validity windows. Lifecycle é governado por 11
			invariantes canônicas (vivem em domain-model) que protegem
			contra transitions semantically inconsistent com canonical
			clauses. Não é workflow de execução técnica (que vive em
			BKR); é evolução de estado econômico da obrigação.
			"""
		category:  "process"
		rationale: "Term canoniza ownership do lifecycle: FCE owns state evolution da PaymentObligation; BKR owns execution. Sem este term, agentes podem implementar lifecycle compartilhado FCE↔BKR — drift que rompe ambas as boundaries. Define escopo onde os 11 invariantes operam (domain-model Phase 3)."
		antiTerms: [{
			term:          "Settlement Workflow"
			clarification: "Settlement workflow é BKR-internal sequencing de dispatch/retry/finalization. PaymentLifecycle é FCE-internal economic state evolution. Mesmo timeline real-world, layers distintas."
		}, {
			term:          "Payment Pipeline"
			clarification: "Pipeline sugere processing técnico linear. Lifecycle inclui forks (retention hold), regressions (reverse settlement), e estados terminais não-lineares — modelo de pipeline perde essa estrutura."
		}, {
			term:          "Payment Status Tracking"
			clarification: "Status tracking sugere observação passiva. Lifecycle implies authored transitions per FCE com invariantes — não monitor de progress externo."
		}]
		examples: [{
			context:   "Transition canônica Sent → Settled"
			instance:  "BKR emite BKRSettlementOutcome.Succeeded. FCE consome, interpreta economically como settlement-confirmed, transitions PaymentObligation Sent → Settled, checa invariantes (e.g., retention untouched if applicable), emite economic outcome event downstream (naming deferred to domain-model)."
			rationale: "Transition FCE-authored via economic interpretation de BKR outcome."
		}, {
			context:   "Transition para PaymentPendingFinalReconciliation"
			instance:  "BKR emite BKRSettlementOutcome.Indeterminate (rail timeout, ack ambíguo). FCE transitions PaymentObligation Sent → PaymentPendingFinalReconciliation. Epistemic non-collapse preserved: FCE não infere Succeeded nem Failed."
			rationale: "Lifecycle preserva incerteza upstream em vez de colapsá-la."
		}]
		relatedTerms: [
			"term-payment-obligation",
			"term-economic-interpretation",
			"term-bkr-settlement-outcome",
			"term-payment-pending-final-reconciliation",
			"term-reverse-settlement",
		]
		layerMapping: {
			codeTerm: "PaymentLifecycle"
			apiTerm:  "payment-lifecycle"
		}
	}, {
		code:   "term-financialization"
		name:   "Financialização"
		termEn: "Financialization"
		definition: """
			Operação atômica all-or-nothing FCE que vincula
			simultaneamente compromisso (CMT.commitment), budget
			allocation (BDG.budget-line), pricing/risk decision
			(REW.risk-gate-output) e PaymentObligation criada — todos
			ou nenhum. Atomicidade é constituinte: parcial linking
			deixa estado financeiro inconsistente com obrigação,
			violando audit trail. Per bd-financialization-is-atomic:
			FinancializationService coordena os 4 vínculos como
			unidade transacional; falha em qualquer um aborta toda
			crystallization e libera reservas parciais.
			"""
		category:  "process"
		rationale: "Term canoniza propriedade arquitetural ontológica do BC. Sem atomicidade, FCE perde garantia de auditability econômica — pode existir PaymentObligation sem budget link, ou budget consumed sem obligation. bd-financialization-is-atomic é a #1 business decision por uma razão: define o contrato de integridade financeira do sistema."
		antiTerms: [{
			term:          "Financial Linking"
			clarification: "Linking é descritivo (associar A com B); Financialization é especificamente o atomic all-or-nothing operation. Linking genérico pode ser parcial; Financialization não pode."
		}, {
			term:          "Budget Allocation"
			clarification: "Budget allocation é BDG-owned: BDG decide quanto alocar. Financialization é FCE-owned: vincula a alocação a uma obligation. Confundir leva a modelo onde FCE aloca budget — boundary violation."
		}, {
			term:          "Payment Setup"
			clarification: "Setup sugere configuração técnica passive. Financialization é ato econômico-contábil com consequência immediate (budget consumed, risk decision frozen, commitment marked, obligation born)."
		}]
		rejectedAlternatives: [{
			term:   "PaymentInitialization"
			reason: "Initialization sugere preparação; Financialization é evento canônico financeiro com consequência immediate."
		}, {
			term:   "AtomicCommitment"
			reason: "Já reservado em DDB literature para conceito distinct (2PC). Domain-specific term Financialization evita colisão."
		}, {
			term:   "EconomicBinding"
			reason: "Binding já usado para AuthorizationProof cryptographic-binding (semântica distinta); reuso causaria ambiguity."
		}]
		examples: [{
			context:   "Financialization succeeds"
			instance:  "FinancializationService inicia tx: link CMT.commitment-1827 + reserve BDG.budget-line-92 + freeze REW.risk-decision-44 + create PaymentObligation. Todos 4 succeed atomically; emits financialization outcome event (naming deferred to domain-model Phase 3); PaymentObligation state=Authorized."
			rationale: "All-or-nothing succeed path."
		}, {
			context:   "Financialization fails partially → rollback"
			instance:  "REW.risk-decision-44 freeze falha (REW unavailable). FinancializationService aborta tx: budget reservation released, commitment link reverted, PaymentObligation não criada. Emits financialization outcome event (naming deferred to domain-model Phase 3). Sistema retorna estado pre-attempt."
			rationale: "Atomicidade enforced: parcial impossível."
		}]
		relatedTerms: [
			"term-payment-obligation",
			"term-economic-authority-crystallization",
			"term-prepayment-guard",
			"term-retention",
		]
		layerMapping: {
			codeTerm: "Financialization"
			apiTerm:  "financialization"
		}
	}, {
		code:   "term-prepayment-guard"
		name:   "Guarda Pré-Pagamento"
		termEn: "Prepayment Guard"
		definition: """
			Service canônico FCE que enforça gates estruturais
			pre-dispatch de PaymentInstruction a BKR: (a)
			AuthorizationProof presente e válida (signature + nonce +
			validity window + claim chain); (b) idempotency-key não
			usado anteriormente; (c) upstream truth snapshot
			consistente (conditions ainda satisfied; nenhuma upstream
			mutation entre convergence observation e dispatch); (d)
			evidence binding ao compromisso intacta — materializa
			mech-evidence localmente (dinheiro só se move com prova
			operacional vinculada ao commitment). Guard rejeita
			estruturalmente pre-dispatch quando qualquer gate falha —
			não tenta repair; aborta e emite authorization rejection/
			revocation event (naming deferred to domain-model).
			"""
		category:  "process"
		rationale: "Term canoniza última linha de defesa pre-BKR. Sem este term, agentes podem implementar dispatch direto pós-convergence sem re-checagem — abrindo janela onde upstream mutates entre convergence e dispatch (TOCTOU). PrepaymentGuard fecha essa janela. Absorve materialização local de mech-evidence (mecanismo canônico Mesh) sem precisar de term separado evidence-binding — per founder Phase 2.1 ajuste."
		antiTerms: [{
			term:          "Payment Validation"
			clarification: "Validation é genérico (input validation). PrepaymentGuard é especificamente gates estruturais semânticos sobre payment authorization integrity — não checa formato, checa fronteira."
		}, {
			term:          "Authorization Check"
			clarification: "Authorization check sugere checar se autorização existe. Guard checa que autorização permanece válida no momento de dispatch — uma checagem temporal sobre observation já feita."
		}, {
			term:          "Pre-flight Check"
			clarification: "Pre-flight é metáfora aviação para go/no-go genérico. Guard tem semantic carga específica: enforcement de invariantes econômicos pre-physical-execution."
		}]
		rejectedAlternatives: [{
			term:   "DispatchGuard"
			reason: "Dispatch é a ação BKR-side; Prepayment captures que guard atua antes da fronteira BKR ser cruzada."
		}, {
			term:   "AuthorizationGate"
			reason: "Gate é genérico. Guard implica defesa ativa contra TOCTOU e drift, não passive gate."
		}]
		examples: [{
			context:   "Guard passes → dispatch to BKR"
			instance:  "PaymentObligation Authorized; AuthorizationProof valid; idempotency-key unused; conditions snapshot still satisfied; evidence link to commitment intact. PrepaymentGuard passes; FCE dispatches PaymentInstruction to BKR."
			rationale: "All gates clear → dispatch admissible."
		}, {
			context:   "Guard catches TOCTOU window"
			instance:  "Entre convergence observation e dispatch, CMT.commitment é cancelled por upstream operation. Guard checa upstream snapshot, detecta CMT.commitment-active=false, aborta dispatch. Emits authorization rejection/revocation event (naming deferred to domain-model). PaymentObligation transitions Authorized → Cancelled."
			rationale: "Guard fecha TOCTOU window entre observation e action."
		}]
		relatedTerms: [
			"term-authorization-proof",
			"term-payment-instruction",
			"term-payment-obligation",
			"term-upstream-condition",
			"term-condition-weakening",
		]
		layerMapping: {
			codeTerm: "PrepaymentGuard"
			apiTerm:  "prepayment-guard"
		}
	}, {
		code:   "term-payment-instruction"
		name:   "Instrução de Pagamento"
		termEn: "Payment Instruction"
		definition: """
			Value object FCE-originated representando intenção
			econômica autorizada (PaymentObligation em state=Authorized)
			cristalizada como instrução técnica para BKR executar.
			Carrega instructionId (FCE-owned correlation), references
			payer/payee, valor, rail-hint ou rail pinado,
			AuthorizationProof anexada, validity window e references a
			PaymentObligation/commitment/invoice. FCE é authority de
			criação; BKR é authority de execução. Após emissão,
			instruction é immutable from FCE side — qualquer
			cancelamento exige instruction nova ou reverse settlement
			upstream-mandated. Cross-BC peer: BKR glossary
			term-payment-instruction define lens consumer (BKR não
			cria, não muta, não interpreta economic intent).
			"""
		category:  "value"
		rationale: "Term de fronteira FCE↔BKR. Cross-BC alignment com BKR glossary peer preservado por convention: same artifact, lens distintos (FCE-originated vs BKR-consumed). Sem este term em ambos glossários com lens explicit, agentes podem gerar modelo onde Payment é compartilhado entre BCs ou BKR cria PaymentInstruction — boundary violation."
		antiTerms: [{
			term:          "Pagamento (Payment)"
			clarification: "Payment é conceito econômico FCE-owned + execução física BKR-owned. PaymentInstruction é o value object que viaja entre BCs carregando intent autorizado. Confundir é o erro semântico mais comum em arquiteturas de pagamento."
		}, {
			term:          "Ordem de Pagamento (Payment Order)"
			clarification: "Termo bancário tradicional carrega ambiguidade de autoria (cliente ordena banco). PaymentInstruction é instrução já autorizada chegando a executor técnico — não há decisão pendente sobre se executar."
		}, {
			term:          "Solicitação de Transferência (Transfer Request)"
			clarification: "Request implica decisão pendente upstream. PaymentInstruction é pós-decisão; AuthorizationProof precede dispatch."
		}, {
			term:          "Comando de Liquidação (Settlement Command)"
			clarification: "PaymentInstruction é value object (data); o command operacional DispatchPaymentInstruction é separado (vive em domain-model). Confundir value com command leva a modelo errado onde instruction vira ação."
		}]
		rejectedAlternatives: [{
			term:   "Payment"
			reason: "Colapsa intenção econômica (FCE) com instrução técnica e execução (BKR)."
		}, {
			term:   "PaymentRequest"
			reason: "Request implica decisão pendente; PaymentInstruction é pós-decisão."
		}, {
			term:   "SettlementInstruction"
			reason: "Settlement-prefix sugere downstream ownership; FCE é upstream author."
		}]
		examples: [{
			context:   "Emissão FCE → consumo BKR"
			instance:  "PaymentObligation Authorized + AuthorizationProof emitida. FCE compõe PaymentInstruction com instructionId fce-2026-09823, payer=construtora-x, payee=fornecedor-y, value=47250.00, rail-hint=pix, proof anexada, validity-window=15min. Dispatched a BKR; BKR consome estruturalmente."
			rationale: "FCE authors, BKR consumes — boundary explicit."
		}, {
			context:   "Immutability FCE-side post-dispatch"
			instance:  "Após dispatch, fornecedor solicita alteração de bank account. FCE NÃO muta PaymentInstruction; emite reverse settlement upstream-mandated ou nova instruction com novo instructionId."
			rationale: "Immutability protege chain of authorization."
		}]
		relatedTerms: [
			"term-payment-obligation",
			"term-authorization-proof",
			"term-bkr-settlement-outcome",
			"term-prepayment-guard",
		]
		layerMapping: {
			codeTerm: "PaymentInstruction"
			apiTerm:  "payment-instructions"
		}
	}, {
		code:   "term-bkr-settlement-outcome"
		name:   "Resultado de Liquidação BKR"
		termEn: "BKR Settlement Outcome"
		definition: """
			Estado canônico settlement-side BKR-owned, consumido por
			FCE como input para economic interpretation. Tem 3 valores
			canônicos: Succeeded (rail confirmou settlement), Failed
			(rail rejeitou ou settlement abortado), Indeterminate
			(rail ambíguo — timeout, ack confuso, network partition
			sem reconciliation possível dentro do SLA imediato). BKR é
			authority única do outcome; FCE não arbitra outcome, FCE
			consome outcome and interprets economically. Per canonical
			clause #2: FCE outbound events express economic
			interpretation de canonical settlement outcomes, not
			settlement execution truth itself. Naming prefix 'BKR'
			explícito no termo sinaliza ownership boundary — FCE não
			possui settlement outcome.
			"""
		category:  "classification"
		rationale: "Term de fronteira crítica FCE↔BKR. Naming explícito 'BKR' (per founder Phase 2.1 ajuste #2) previne reinterpretação onde FCE aparenta possuir settlement outcome. Indeterminate como valor canônico distinto preserva epistemic non-collapse — sem isso, FCE pode colapsar Indeterminate em Failed (perdendo information) ou em Succeeded (optimismo perigoso). Categoria 'classification' (per founder Phase 2.2.B ajuste #4) reflete que term descreve o TIPO de outcome consumido, não o evento em si. Cross-BC peer: BKR glossary term-settlement-outcome define lens producer."
		antiTerms: [{
			term:          "Payment Result (FCE)"
			clarification: "Payment result interpretado como FCE-owned é o erro #1. Settlement outcome é BKR-owned; FCE produz economic interpretation downstream que pode ser distinta (e.g., Settled vs PaymentPendingFinalReconciliation)."
		}, {
			term:          "Settlement Status"
			clarification: "Status sugere observable passive value. Outcome canoniza terminal-or-ambiguous state from rail's perspective — distinção semântica importante (status pode mudar; outcome é fato)."
		}, {
			term:          "Transaction Outcome"
			clarification: "Transaction é amplo (DB tx, business tx, accounting tx). Settlement outcome é especificamente o resultado settlement-side relatado pelo rail."
		}]
		rejectedAlternatives: [{
			term:   "SettlementOutcome"
			reason: "Sem prefix BKR, agentes podem ler como FCE-owned settlement state. Founder Phase 2.1 ajuste explícito: 'evita parecer que FCE possui settlement outcome'."
		}, {
			term:   "SettlementResult"
			reason: "Result não distingue terminal (success/fail) de ambiguous (indeterminate). Outcome cobre os 3 valores canônicos."
		}, {
			term:   "RailResponse"
			reason: "Rail é detalhe técnico BKR-internal. FCE consome outcome semântico canonicalizado por BKR — não touch rail directly."
		}]
		examples: [{
			context:   "BKRSettlementOutcome.Succeeded → FCE economic interpretation"
			instance:  "BKR emite BKRSettlementOutcome.Succeeded para instructionId fce-2026-09823. FCE consome, interpreta economically: PaymentObligation Sent → Settled, emite economic outcome event (naming deferred to domain-model, distinto do fact settlement-side de BKR)."
			rationale: "Outcome BKR-owned; economic interpretation FCE-owned."
		}, {
			context:   "BKRSettlementOutcome.Indeterminate preservation"
			instance:  "BKR emite BKRSettlementOutcome.Indeterminate (timeout sem rail confirmation). FCE NÃO infere Failed nem Succeeded; transitions PaymentObligation → PaymentPendingFinalReconciliation. Epistemic non-collapse preserved até reconciliation final."
			rationale: "Indeterminate como valor canônico previne colapso prematuro."
		}]
		relatedTerms: [
			"term-payment-instruction",
			"term-economic-interpretation",
			"term-payment-pending-final-reconciliation",
			"term-payment-lifecycle",
		]
		layerMapping: {
			codeTerm: "BkrSettlementOutcome"
			apiTerm:  "bkr-settlement-outcomes"
		}
	}, {
		code:   "term-payment-pending-final-reconciliation"
		name:   "Pagamento Pendente Reconciliação Final"
		termEn: "Payment Pending Final Reconciliation"
		definition: """
			Estado canônico no PaymentLifecycle assumido quando FCE
			consome BKRSettlementOutcome.Indeterminate (rail outcome
			ambíguo, irreconcilable dentro do SLA imediato). Não é
			Succeeded — FCE não infere settlement confirmed sem
			evidence canônica; não é Failed — FCE não infere
			settlement aborted sem evidence de rail rejection.
			PaymentObligation permanece neste estado até reconciliation
			process (manual ou automated upstream) produzir
			authoritative determination. Preserva epistemic
			non-collapse: o sistema não substitui ignorance por
			confidence quando rail é ambíguo.
			"""
		category:  "classification"
		rationale: "Term canoniza propriedade epistemológica crítica do BC. Sem este estado nomeado, agentes geram código que colapsa Indeterminate em Failed (perdendo dinheiro potencialmente já transferido) ou em Succeeded (afirmando settlement não-confirmado). Founder Phase 2.1 explicitamente preservou este term porque 'protege epistemic non-collapse no lado econômico do FCE'."
		antiTerms: [{
			term:          "Payment In Progress"
			clarification: "In progress sugere progress determinado — settlement está em andamento e completará. PaymentPendingFinalReconciliation é estado de incerteza sobre o que JÁ aconteceu — não predicts forward."
		}, {
			term:          "Payment Failed"
			clarification: "Failed afirma settlement abortado. Indeterminate é silence rail-side, não rejection. Colapsar Indeterminate em Failed pode levar a re-tentar pagamento já realizado fisicamente."
		}, {
			term:          "Payment Successful (Conservative)"
			clarification: "Optimistic assumption sem rail confirmation. Colapsar Indeterminate em Succeeded confirma economicamente settlement que pode não ter ocorrido fisicamente."
		}, {
			term:          "Payment Disputed"
			clarification: "Disputed implica reclamação ativa de party. PendingFinalReconciliation é silence rail-side antes de qualquer dispute — não há contestação, há ausência de confirmation."
		}]
		rejectedAlternatives: [{
			term:   "PaymentUnknown"
			reason: "Unknown é correto mas não-actionable; PendingFinalReconciliation aponta para process resolution (reconciliation)."
		}, {
			term:   "PaymentIndeterminate"
			reason: "Indeterminate é a propriedade do BKR outcome; FCE state nomeia consequência operacional (await reconciliation)."
		}, {
			term:   "PaymentInLimbo"
			reason: "Linguagem coloquial; remove confidence; reconciliation é actionable resolution path."
		}]
		examples: [{
			context:   "Indeterminate → state assumed"
			instance:  "BKR emite BKRSettlementOutcome.Indeterminate para fce-2026-09823 (Pix timeout sem confirmation, ack ambíguo após 60s). FCE NÃO infere; transitions PaymentObligation Sent → PaymentPendingFinalReconciliation. Triggers reconciliation workflow (consultar Bacen acks, query rail directly, manual review se needed)."
			rationale: "Estado preserva incerteza canonicamente até reconciliation produzir certainty."
		}, {
			context:   "Resolution via reconciliation"
			instance:  "Reconciliation process posterior (e.g., +24h) determina via Bacen ledger que settlement de fato ocorreu. FCE transitions PaymentPendingFinalReconciliation → Settled com reconciliation-source=bacen-ledger."
			rationale: "State é transient awaiting authoritative determination."
		}]
		relatedTerms: [
			"term-payment-lifecycle",
			"term-bkr-settlement-outcome",
			"term-economic-interpretation",
			"term-payment-obligation",
		]
		layerMapping: {
			codeTerm: "PaymentPendingFinalReconciliation"
			apiTerm:  "payment-pending-final-reconciliation"
		}
	}, {
		code:   "term-retention"
		name:   "Retenção"
		termEn: "Retention"
		definition: """
			Parcela financeira do PaymentObligation retida
			condicionalmente pelo FCE — não convertida em
			PaymentInstruction enviada a BKR — pending operational
			evidence canônica que satisfaça
			RetentionReleaseConvergenceSet. Retenção é materialização
			local de mech-evidence: dinheiro só se move quando
			operação comprova que deve se mover. Não é garantia
			jurídica (collateral), não é provisão contábil (ATO), não
			é escrow tercerizado — é estado operacional FCE-owned de
			parcela do valor mantida sob hold canônico até evidência
			convergir. Carrega referência ao PaymentObligation
			original, valor retido (absoluto ou proporcional), e ao
			RetentionReleaseConvergenceSet aplicável.
			"""
		category:  "value"
		rationale: "Term canoniza materialização operacional FCE de mech-evidence. Sem este term, agentes podem implementar 'hold' genérico bancário (BKR-style) confundido com retenção econômica FCE. Distinção semântica: BKR pode ter hold técnico sobre rail-side; Retention é hold econômico-condicional FCE-owned, vinculado a evidence."
		antiTerms: [{
			term:          "Escrow"
			clarification: "Escrow tradicionalmente envolve third-party custodian neutro entre payer e payee. Retention é FCE-internal estado da obrigação — não há custodian; o valor permanece no fluxo FCE até liberação."
		}, {
			term:          "Hold (Bancário)"
			clarification: "Hold bancário é técnico rail-side (banco bloqueia saldo). Retention é econômico FCE-side — refere-se à parcela da obligation não-dispatched, não a saldo bloqueado em rail."
		}, {
			term:          "Provisão (Provision)"
			clarification: "Provision é abstração contábil ATO-owned para reservar valor em ledger. Retention é operacional FCE-owned — não registra ledger entry, define estado da obrigação."
		}, {
			term:          "Garantia (Collateral / Guarantee)"
			clarification: "Collateral é instrumento jurídico (penhor, fiança). Retention é mecanismo operacional sem implicação jurídica direta — é decisão de fluxo FCE sobre o próprio valor da obligation."
		}]
		rejectedAlternatives: [{
			term:   "PaymentHold"
			reason: "Hold é genérico e capturado por antiTerm; Retention preserva linguagem econômica do conceito (manter parcela sob condição)."
		}, {
			term:   "ConditionalReservation"
			reason: "Reservation sugere alocação contábil; Retention é operacional sobre value já alocado."
		}, {
			term:   "WithheldPortion"
			reason: "Withheld é correto descritivamente mas perde a conexão semântica com mech-evidence (mecanismo Mesh canônico)."
		}]
		examples: [{
			context:   "PaymentObligation com retention parcial"
			instance:  "PaymentObligation fce-2026-09823 valor 50000.00 contratualmente carrega retention=10% pending obra-entregue evidence. FCE dispatch PaymentInstruction com value=45000.00 a BKR; 5000.00 permanecem em Retention vinculada a RetentionReleaseConvergenceSet={DLV.delivery-confirmed, CMT.milestone-closed}."
			rationale: "Retention separa valor dispatched de valor held — ambos pertencem à mesma obligation."
		}, {
			context:   "Retenção materializa mech-evidence"
			instance:  "Sem DLV.delivery-confirmed event consumido, FCE não pode iniciar retention release — não importa pressão temporal ou commercial. Money does not move without evidence; retention é o estado canônico que enforça este invariante."
			rationale: "Materialização local de mech-evidence ancorada no aggregate FCE."
		}]
		relatedTerms: [
			"term-payment-obligation",
			"term-retention-release",
			"term-retention-release-convergence-set",
			"term-financialization",
		]
		layerMapping: {
			codeTerm: "Retention"
			apiTerm:  "retentions"
		}
	}, {
		code:   "term-retention-release"
		name:   "Liberação de Retenção"
		termEn: "Retention Release"
		definition: """
			Processo canônico FCE de liberar Retention previamente
			held quando RetentionReleaseConvergenceSet converge —
			análogo estrutural a authorization convergence, mas
			especializado para release event do valor retido. Não é
			decisão volitiva de unlock; é observação de convergência
			de operational truth (DLV evidence-validated, CMT
			milestone-closed, outras conditions per type) que torna
			retention release semanticamente devida. Per
			bd-retention-release-conditional-on-operational-truth:
			nenhuma autoridade dentro do FCE pode liberar retention
			sem convergence; pressure operacional ou commercial não
			substitui evidence. Triggers nova PaymentInstruction para
			BKR com o valor liberado e emits retention release event
			(naming deferred to domain-model Phase 3).
			"""
		category:  "process"
		rationale: "Term canoniza estrutura paralela à authorization convergence aplicada ao release event de retenção. Sem este term, agentes podem implementar 'unlock' procedural sob policy variável, abrindo vetor para condition weakening específico ao retention path. Categoria 'process' (não event) per founder Phase 2.1 ajuste #3 — o evento de liberação vive em domain-model; o conceito processual vive aqui."
		antiTerms: [{
			term:          "Unlock"
			clarification: "Unlock é técnico-genérico (database lock release, account unlock). Retention release é semantic-conditional: depends de convergence de operational truth specific."
		}, {
			term:          "Pagamento Final (Final Payment)"
			clarification: "Final payment pode descrever last installment de parcelamento. Retention release é especificamente liberação de parcela held pending evidence — escopo distinto, momento distinto."
		}, {
			term:          "Aprovação de Liberação (Release Approval)"
			clarification: "Approval implica authority figure deciding. Retention release é convergence-observed, não approval-granted — mesmo erro semântico de authorization (decision vs convergence)."
		}]
		rejectedAlternatives: [{
			term:   "RetentionUnlock"
			reason: "Unlock genérico; Release preserves economic specificity."
		}, {
			term:   "WithholdingRelease"
			reason: "Withholding já tem semantic tax/payroll-specific em alguns contextos; Retention é o term consistente do FCE glossary."
		}, {
			term:   "FinalPayment"
			reason: "Confundido com last installment; capturado por antiTerm."
		}]
		examples: [{
			context:   "Convergence observed → release"
			instance:  "RetentionReleaseConvergenceSet={DLV.delivery-confirmed, CMT.milestone-closed} satisfeito. FCE observa convergence, cria nova PaymentInstruction para valor retido 5000.00, emite retention release event downstream (naming deferred to domain-model), atualiza PaymentObligation com retention=released."
			rationale: "Convergence-observed → release issued."
		}, {
			context:   "Pressure sem convergence → no release"
			instance:  "Counterparty pressiona por release antecipado citing 'goodwill'. Sem DLV.delivery-confirmed, FCE não libera. ec-condition-weakening fires se attempt de bypassar; escalation route engaged."
			rationale: "Mesma postura de authorization — convergence is not negotiable."
		}]
		relatedTerms: [
			"term-retention",
			"term-retention-release-convergence-set",
			"term-payment-instruction",
			"term-condition-weakening",
		]
		layerMapping: {
			codeTerm: "RetentionRelease"
			apiTerm:  "retention-release"
		}
	}, {
		code:   "term-retention-release-convergence-set"
		name:   "Conjunto de Convergência para Liberação de Retenção"
		termEn: "Retention Release Convergence Set"
		definition: """
			Conjunto canônico, finito e fechado de operational truth
			conditions cuja convergência integral libera Retention
			held. Análogo estrutural a AuthorizationConvergenceSet mas
			especializado para retention release: conditions são
			tipicamente operational (DLV.delivery-confirmed,
			DLV.quality-validated, CMT.milestone-closed,
			CMT.deliverable-acknowledged) — diferente do conjunto de
			authorization que mistura financial (BDG, REW) com
			operational (DLV, CMT). Set é declarado a priori per
			retention type — não improvisado per case. Mutação do set
			é decisão de design FCE separada do processamento de
			convergência.
			"""
		category:  "value"
		rationale: "Term canoniza nomenclatura canonical (per founder Phase 1.5/1.6) e propriedade arquitetural do set específico para retention path. Existe como term separado de AuthorizationConvergenceSet por: (a) composição distinta (operational truth-heavy vs financial-heavy); (b) momento distinto (post-settlement vs pre-authorization); (c) failure modes distintos (operational ambiguity vs financial constraint). Mesma propriedade canonical-fechado-predeclared protege contra os mesmos drifts (shopping, boundary erosion)."
		antiTerms: [{
			term:          "Release Criteria"
			clarification: "Criteria é descritivo genérico; convergence set é especificamente o conjunto declarativo all-or-nothing definido per retention type."
		}, {
			term:          "Delivery Confirmation List"
			clarification: "DLV evidence é apenas uma parte do set típico; também envolve CMT signals e outros. Reducir set a DLV é fragmentação."
		}]
		rejectedAlternatives: [{
			term:   "ReleaseConditions"
			reason: "Conditions é descritivo mas perde propriedade canonical-fechado-predeclared."
		}, {
			term:   "RetentionGate"
			reason: "Gate é genérico e implica binary check passive; convergence set é declarativo all-or-nothing observado."
		}]
		examples: [{
			context:   "Set canônico para retention tipo milestone-completion"
			instance:  "{ DLV.delivery-confirmed, DLV.quality-validated, CMT.milestone-closed }. Set declarado at design-time per retention type; evaluation observa todos 3 simultaneamente. Convergence completa → release issued."
			rationale: "Predeclared, finite, fechado, operational-truth-heavy."
		}, {
			context:   "Evolução do set ≠ runtime improvisation"
			instance:  "Adicionar nova condition (e.g., CMT.deliverable-acknowledged) ao set para milestone-completion é decisão de design que altera RetentionReleaseConvergenceSet definition. Não pode ocorrer em runtime per case."
			rationale: "Boundary erosion via runtime mutation seria ec-convergence-boundary-erosion-detected hit."
		}]
		relatedTerms: [
			"term-retention",
			"term-retention-release",
			"term-authorization-convergence-set",
			"term-upstream-condition",
			"term-convergence-boundary-erosion",
		]
		layerMapping: {
			codeTerm: "RetentionReleaseConvergenceSet"
			apiTerm:  "retention-release-convergence-set"
		}
	}, {
		code:   "term-reverse-settlement"
		name:   "Liquidação Reversa"
		termEn: "Reverse Settlement"
		definition: """
			Processo canônico FCE de executar reversão financeira de
			PaymentObligation previamente settled — emit reverse
			PaymentInstruction para BKR a fim de retornar valor ao
			payer. Per bd-reverse-settlement-upstream-mandated-only:
			FCE NÃO origina reverse settlement por decisão própria.
			Origem é sempre upstream — CMT.commitment-cancelled,
			regulatory mandate, contractual reverse provision
			triggered, dispute resolution upstream-authoritative.
			FCE recebe mandate upstream e executa via
			PaymentInstruction com flag reverse-direction. BKR executa
			fisicamente o retorno. Reverse settlement é distinto de
			cancellation (que ocorre pre-settlement) e de refund
			commercial (que envolve decisão comercial não
			upstream-mandated).
			"""
		category:  "process"
		rationale: "Term canoniza propriedade upstream-mandated-only crítica. Sem este term, FCE pode aparentar authority para originar reversões (e.g., 'risk team decided to reverse') — boundary violation. Reverse settlement é execução de mandate externo, não decision interna. Per bd-reverse-settlement-upstream-mandated-only: ownership da decisão de reverter é upstream; FCE é executor."
		antiTerms: [{
			term:          "Refund"
			clarification: "Refund tipicamente envolve decisão comercial (e.g., customer satisfaction). Reverse settlement é upstream-mandated by commitment/regulatory event — não decision FCE."
		}, {
			term:          "Chargeback"
			clarification: "Chargeback é consumer-initiated via card network (B2C). Reverse settlement é B2B operational-mandated."
		}, {
			term:          "Cancellation"
			clarification: "Cancellation ocorre pre-settlement (PaymentObligation Authorized → Cancelled antes de dispatch ou pre-confirmation). Reverse settlement ocorre post-settlement (PaymentObligation Settled → Reversed via novo flow)."
		}, {
			term:          "Reversal (BKR-side)"
			clarification: "BKR pode executar reversal técnico rail-side (e.g., Pix instant return). Reverse settlement é o processo econômico FCE-owned que pode usar reversal técnico BKR como mecanismo, mas semantically é distinct: FCE executes only when upstream mandate exists; it does not decide whether reversal is deserved."
		}]
		rejectedAlternatives: [{
			term:   "PaymentReversal"
			reason: "Reversal técnico é capturado por antiTerm; reverse settlement enfatiza o processo econômico end-to-end, não só o mecanismo."
		}, {
			term:   "PaymentRefund"
			reason: "Refund implica commercial decision; capturado por antiTerm."
		}, {
			term:   "FinancialUnwind"
			reason: "Unwind é jargão financial markets para position-closing; semantically distant do conceito FCE."
		}]
		examples: [{
			context:   "Upstream mandate → reverse settlement executed"
			instance:  "CMT emits CommitmentCancelled event for cmt-2026-1827 com retroactive cancellation flag. FCE consume, identifies que PaymentObligation fce-2026-09823 (já Settled) é affected, executa reverse settlement: emits reverse PaymentInstruction to BKR com value=47250.00, payer/payee swapped. PaymentObligation transitions Settled → Reversed."
			rationale: "Upstream-mandated origin; FCE executes per mandate."
		}, {
			context:   "Tentativa FCE-internal de originar reverse → rejected"
			instance:  "FCE internal operator detecta fraud post-settlement, attempts to originate reverse settlement without upstream mandate. Boundary violation fires; escalation route engaged. FCE não pode originar — operator escalates a CMT/regulatory para gerar mandate canônico upstream."
			rationale: "Ownership da decisão é upstream; FCE não pode usurpar via internal authority."
		}]
		relatedTerms: [
			"term-payment-obligation",
			"term-payment-instruction",
			"term-payment-lifecycle",
			"term-bkr-settlement-outcome",
		]
		layerMapping: {
			codeTerm: "ReverseSettlement"
			apiTerm:  "reverse-settlement"
		}
	}, {
		code:   "term-economic-interpretation"
		name:   "Interpretação Econômica"
		termEn: "Economic Interpretation"
		definition: """
			Processo canônico FCE de converter canonical settlement
			outcomes (BKR-owned) em estado econômico da
			PaymentObligation no FCE lifecycle. Per canonical clause
			#2: FCE outbound events express economic interpretation
			of canonical settlement outcomes, not settlement execution
			truth itself. Interpretation produces FCE-owned facts
			(economic states do payment lifecycle) distintos dos facts
			BKR-side (BKRSettlementOutcome.X). Interpretation pode ser
			direta (BKRSettlementOutcome.Succeeded → estado Settled)
			ou epistemically preserving (BKRSettlementOutcome.
			Indeterminate → PaymentPendingFinalReconciliation — não
			colapsa em Settled nem Failed).
			"""
		category:  "process"
		rationale: "Term canoniza camada que separa fact BKR (settlement-side) de fact FCE (economic-side). Sem este term, agentes podem implementar passthrough direto onde BKR facts viram FCE events sem layer interpretive — colapsando boundaries. Interpretation existe como conceito canônico para preserve epistemic non-collapse e ownership distinction."
		antiTerms: [{
			term:          "Settlement Forwarding"
			clarification: "Forwarding sugere passthrough sem semantic transformation. Interpretation explicita que FCE produces distinct economic fact, não apenas relays BKR fact downstream."
		}, {
			term:          "Settlement Synchronization"
			clarification: "Sync sugere bilateral state matching. Interpretation é unidirectional process FCE-side: BKR outcome consumed, FCE economic state produced — não há matching."
		}, {
			term:          "Status Update"
			clarification: "Status update é passive observation. Interpretation é authored act: FCE derives canonical economic state baseado em outcome e contexto da obligation."
		}]
		rejectedAlternatives: [{
			term:   "OutcomeTranslation"
			reason: "Translation sugere 1:1 mapping; interpretation pode preserve uncertainty (Indeterminate → PendingFinalReconciliation), não translate."
		}, {
			term:   "EconomicProjection"
			reason: "Projection é DDD term para read model derived from events; interpretation é process actively producing events, não projection passive."
		}]
		examples: [{
			context:   "Direct interpretation Succeeded → Settled"
			instance:  "FCE consome BKRSettlementOutcome.Succeeded para fce-2026-09823. Interpretation produces transition para Settled state com economic context: budget consumed, commitment closed, retention timeline started if applicable."
			rationale: "Direct mapping com FCE-side economic enrichment."
		}, {
			context:   "Epistemic-preserving interpretation"
			instance:  "FCE consome BKRSettlementOutcome.Indeterminate. Interpretation does NOT collapse: produces transition para PaymentPendingFinalReconciliation state (não Settled nem Failed). Reconciliation workflow triggered downstream."
			rationale: "Interpretation respects uncertainty rather than inventing certainty."
		}]
		relatedTerms: [
			"term-bkr-settlement-outcome",
			"term-payment-lifecycle",
			"term-payment-pending-final-reconciliation",
			"term-downstream-authoritative",
		]
		layerMapping: {
			codeTerm: "EconomicInterpretation"
			apiTerm:  "economic-interpretation"
		}
	}, {
		code:   "term-downstream-authoritative"
		name:   "Autoridade Downstream"
		termEn: "Downstream Authoritative"
		definition: """
			Postura canônica FCE: autoritativa sobre economic
			interpretation downstream do que aconteceu (canonical
			clauses #1-4), jamais sobre upstream truth (budget, risk,
			commitment, evidence, invoice) nem sobre settlement
			execution truth (BKR-owned). FCE produz autoridade
			downstream — outbound events que outros BCs consomem como
			canonical economic facts — mas não controla upstream BCs.
			Per canonical clause base: FCE is downstream-authoritative,
			not upstream-controlling. Asymmetry of authority é
			propriedade arquitetural ontológica: FCE consome upstream
			sem reinterpretation; FCE produces downstream com
			interpretation autoria. Não é descrição de hierarquia
			organizacional; é descrição de epistemic posture
			operacional.
			"""
		category:  "classification"
		rationale: "Term canoniza propriedade canonical do BC como classification (postura, não conceito instanciado). Sem este term, agentes podem implementar bidirectional flows onde FCE mutates upstream state ou ignora upstream authority — apagando asymmetry. É a definição operacional de uma das canonical clauses bases que governam toda communication FCE inbound/outbound."
		antiTerms: [{
			term:          "Authoritative (Generic)"
			clarification: "Authority genérica sugere control amplo; downstream-authoritative é precisa: authority sobre economic interpretation downstream only — explicitly bounded."
		}, {
			term:          "Source of Truth"
			clarification: "SoT é amplo — FCE pode ser SoT para economic state da PaymentObligation, mas NÃO SoT para upstream conditions ou settlement execution. Downstream-authoritative é narrower e mais preciso."
		}, {
			term:          "Master/Slave"
			clarification: "Master/slave é metáfora hierárquica technical; downstream-authoritative descreve postura epistemic, não controle. FCE não 'masters' nada upstream — apenas observes."
		}]
		rejectedAlternatives: [{
			term:   "EconomicSoT"
			reason: "SoT terminology é overloaded; downstream-authoritative explicita direction asymmetry, capturando propriedade canonical mais precisamente."
		}, {
			term:   "EconomicAuthority"
			reason: "Captura authority but loses direction (downstream-only); sem direction signal, term lose anti-drift property."
		}]
		examples: [{
			context:   "Downstream authority over economic interpretation"
			instance:  "FCE emits canonical economic event para ATO (accounting), CRM (customer relationship), TCM (treasury). FCE é authority canônica do fato 'this payment is economically settled' — esses BCs consume canonically without re-interpreting."
			rationale: "Downstream-authoritative materializada."
		}, {
			context:   "NOT upstream-controlling boundary"
			instance:  "FCE observes CMT.commitment-active=false (cancellation). FCE NÃO writes back to CMT to 'sync' nem questiona CMT's authority. FCE simply consumes new upstream truth e reflects em economic interpretation (potentially triggering reverse settlement if upstream-mandated)."
			rationale: "Asymmetry preserved: FCE consumes upstream sem reinterpretation ou control."
		}]
		relatedTerms: [
			"term-economic-interpretation",
			"term-economic-authority-crystallization",
			"term-upstream-condition",
			"term-cross-bc-condition-evaluation",
		]
		layerMapping: {
			codeTerm: "DownstreamAuthoritative"
			apiTerm:  "downstream-authoritative"
		}
	}, {
		code:   "term-upstream-condition"
		name:   "Condição Upstream"
		termEn: "Upstream Condition"
		definition: """
			Cada condition produzida por BC upstream que entra em
			AuthorizationConvergenceSet ou
			RetentionReleaseConvergenceSet. Exemplos canônicos:
			BDG.budget-available (BDG-owned), REW.risk-gate-passed
			(REW-owned), CMT.commitment-active (CMT-owned),
			DLV.evidence-validated (DLV-owned), INV.invoice-approved
			(INV-owned), NPM.counterparty-qualified (NPM-owned). Cada
			condition é owned semanticamente pelo BC upstream que a
			produces — FCE consome estado da condition (true/false +
			metadata), não re-evaluates lógica interna do upstream BC.
			Condition pode ser snapshot at convergence observation
			moment ou live-evaluated; mutação upstream entre snapshot
			e dispatch deve ser detectada por PrepaymentGuard.
			"""
		category:  "value"
		rationale: "Term canoniza unit ontológica de what conditions a convergência. Sem este term named, agentes podem confundir conditions FCE-internal (lifecycle states) com upstream-owned conditions — boundary violation. Naming explícito 'upstream' sinaliza ownership boundary: FCE consume, não produces."
		antiTerms: [{
			term:          "Authorization Rule"
			clarification: "Rule é FCE-internal policy. Upstream condition é estado externo produzido por outro BC — diferente categoria epistemological."
		}, {
			term:          "Precondition (Generic)"
			clarification: "Precondition é generic programming term. Upstream condition é especificamente owned by another BC e parte de ConvergenceSet — escopo arquitetural específico."
		}, {
			term:          "Dependency Check"
			clarification: "Dependency check sugere runtime verification ad-hoc. Upstream condition é declarative element of convergence set, observed atomically."
		}]
		rejectedAlternatives: [{
			term:   "ExternalCondition"
			reason: "External é vago (external to what?); upstream sinaliza direction in BC graph specifically."
		}, {
			term:   "ConvergenceCondition"
			reason: "Loses ownership signal; condition belongs to upstream BC, não to convergence set abstractamente."
		}]
		examples: [{
			context:   "Conditions diversas em AuthorizationConvergenceSet"
			instance:  "Set para straight-payment inclui 5 upstream conditions: BDG.budget-available (BDG-owned, value boolean + budget-line-ref), REW.risk-gate-passed (REW-owned, value boolean + risk-decision-id), CMT.commitment-active (CMT-owned, value boolean + commitment-id), INV.invoice-approved (INV-owned, value boolean + invoice-id), NPM.counterparty-qualified (NPM-owned, value boolean + counterparty-status)."
			rationale: "Cada condition é owned by distinct BC upstream."
		}, {
			context:   "FCE não re-evaluates condition internals"
			instance:  "BDG.budget-available=true. FCE consome valor; não questiona como BDG decidiu (que budget line, qual cálculo, qual policy). Boundary preserved: FCE consume canonical state, não duplica logic."
			rationale: "Consumption-only; no re-evaluation."
		}]
		relatedTerms: [
			"term-authorization-convergence-set",
			"term-retention-release-convergence-set",
			"term-cross-bc-condition-evaluation",
			"term-downstream-authoritative",
		]
		layerMapping: {
			codeTerm: "UpstreamCondition"
			apiTerm:  "upstream-conditions"
		}
	}, {
		code:   "term-cross-bc-condition-evaluation"
		name:   "Avaliação de Condição Cross-BC"
		termEn: "Cross-BC Condition Evaluation"
		definition: """
			Capability canônica FCE de avaliar UpstreamConditions de
			múltiplos BCs sem mutação de estado upstream nem
			re-evaluation de lógica upstream. FCE queries upstream BCs
			ou consumes upstream events para observar estado canonical
			de cada condition, e composes observations em answer sobre
			convergence (complete/incomplete). Cap não invoca write
			operations upstream; não solicita autoria upstream; não
			substitui upstream decision. É exercício de epistemic
			posture downstream-authoritative materializada como
			capability operacional. Per cap-cross-bc-condition-evaluation:
			evaluation pode ser sync (live query at convergence
			moment) ou async (consuming upstream events) —
			implementation choice em domain-model.
			"""
		category:  "process"
		rationale: "Term canoniza mechanism que FCE usa para observe upstream sem violate boundary. Sem este term, agentes podem implementar pull-based polling pesado, write-back queries, ou cached state com TTL — sem framing canônico de ownership. Naming 'cross-BC' explícito sinaliza escopo: capability é arquitetural entre BCs, não FCE-internal."
		antiTerms: [{
			term:          "Upstream Query (Generic)"
			clarification: "Query genérico não captura constraint canônico: no mutation, no re-evaluation. Cross-BC condition evaluation é especificamente bounded form de upstream interaction."
		}, {
			term:          "Data Aggregation"
			clarification: "Aggregation sugere collecting data for analysis. Evaluation aqui é arquitetural: observe-then-compose para convergence determination — não generic data fetch."
		}]
		rejectedAlternatives: [{
			term:   "UpstreamObservation"
			reason: "Observation captura epistemic posture mas perde o aspecto 'multiple BCs composed' que é central."
		}, {
			term:   "ConvergenceEvaluation"
			reason: "Convergence evaluation poderia ser intra-set (within FCE state); cross-BC explicit anchors boundary."
		}]
		examples: [{
			context:   "Evaluation async via consumed events"
			instance:  "FCE consumes upstream domain events de BDG, REW, CMT, DLV, INV, NPM. Maintains snapshot per pending PaymentObligation. At convergence check moment, composes snapshots: all true → convergence; any false/missing → incomplete."
			rationale: "Async observation; no upstream mutation."
		}, {
			context:   "Boundary preserved during evaluation"
			instance:  "REW.risk-gate-passed=false (REW determinou risk too high). FCE consome, observes incomplete convergence. FCE não tenta modify REW state nem 'appeal' REW decision — apenas reflects em economic state (PaymentObligation remains in AuthorizationPending or transitions to Cancelled per policy)."
			rationale: "Boundary preservation explicit during evaluation."
		}]
		relatedTerms: [
			"term-upstream-condition",
			"term-authorization-convergence",
			"term-authorization-convergence-set",
			"term-downstream-authoritative",
		]
		layerMapping: {
			codeTerm: "CrossBcConditionEvaluation"
			apiTerm:  "cross-bc-condition-evaluation"
		}
	}, {
		code:   "term-condition-weakening"
		name:   "Enfraquecimento de Condição"
		termEn: "Condition Weakening"
		definition: """
			Anti-pattern canonical e PRIMARY architectural drift
			detector do BC: qualquer attempt de relaxar threshold,
			substituir UpstreamCondition por proxy mais permissivo,
			accept partial convergence as if complete, ou bypass
			condition pending para acelerar authorization ou retention
			release. Per canonical clause #4: FCE may defer
			authorization due to non-convergence, but never accelerate
			authorization by weakening upstream conditions. Detection
			é canonical escalation criterion
			ec-condition-weakening-to-accelerate com zero-tolerance:
			any instance is fail-loud-and-escalate, nunca
			silent-tolerate. Não é erro de implementação; é drift
			semântico que destrói epistemic posture do BC.
			"""
		category:  "rule"
		rationale: "Term canoniza THE primary anti-pattern do BC. Sem este term canonicamente named, drift to faster-but-weaker authorization é caminho de menor resistência sob pressão operacional. Naming explícito como 'rule' (não 'metric') porque define what is forbidden, não what is measured. Founder Phase 1.6 cristalização: prohibition clause 'FCE must NEVER be reinterpreted as sistema de pagamentos' tem este anti-pattern como mecanismo de drift detection."
		antiTerms: [{
			term:          "Optimization (in convergence context)"
			clarification: "Optimization legítima existe (latency redução, cache de upstream conditions, async event consumption). Condition weakening NÃO é optimization — é trade-off de integrity por throughput, antithetical ao canonical evaluation metric (convergence integrity not throughput)."
		}, {
			term:          "Pragmatic Compromise"
			clarification: "Compromise framing é como condition weakening typically apresenta-se ('let's accept 6/7 just this once'). Sem este term canonicamente forbidden, 'pragmatic compromise' becomes silent erosion path."
		}, {
			term:          "Threshold Tuning"
			clarification: "Threshold tuning sounds technical-legitimate. In FCE convergence context é exactly the anti-pattern: lowering threshold to accept partial."
		}]
		rejectedAlternatives: [{
			term:   "ConditionRelaxation"
			reason: "Relaxation é mais neutral; weakening sinaliza adversarial-direction explicitly."
		}, {
			term:   "GateBypass"
			reason: "Bypass captures binário OFF; weakening captures continuum (lower threshold, accept proxy, partial)."
		}, {
			term:   "EarlyAuthorization"
			reason: "Captures one instance (pre-convergence) mas perde generality."
		}]
		examples: [{
			context:   "Direct weakening attempt"
			instance:  "Operational pressure to authorize despite REW.risk-gate-passed=false. Suggestion: 'use risk-tolerance=elevated to bypass for este caso'. FCE detects ec-condition-weakening-to-accelerate, refuses authorization, escalates per route. PaymentObligation remains in AuthorizationPending."
			rationale: "Detection at decision moment; escalation route engaged."
		}, {
			context:   "Subtler weakening: proxy substitution"
			instance:  "DLV.evidence-validated pendente. Suggestion: 'use DLV.evidence-uploaded as proxy — uploaded é proxy reasonable for validated'. FCE detects: validated ≠ uploaded (different upstream owners decision). Anti-pattern fires; refuse."
			rationale: "Proxy substitution é form de weakening detectado canonicamente."
		}]
		relatedTerms: [
			"term-authorization-convergence",
			"term-authorization-convergence-set",
			"term-convergence-boundary-erosion",
			"term-convergence-integrity",
			"term-prepayment-guard",
		]
		layerMapping: {
			codeTerm: "ConditionWeakening"
			apiTerm:  "condition-weakening"
		}
	}, {
		code:   "term-convergence-boundary-erosion"
		name:   "Erosão de Fronteira de Convergência"
		termEn: "Convergence Boundary Erosion"
		definition: """
			Meta-anti-pattern canonical: deslocamento incremental da
			fronteira de quais UpstreamConditions integram um
			ConvergenceSet — sem decisão arquitetural explícita —
			produzindo drift gradual de what authorizes payment ou
			retention release. Diferente de condition-weakening (que
			relaxa threshold de condition existente), boundary-erosion
			alters which conditions exist no set. Pode manifestar
			como: adding optional condition que silently becomes
			mandatory, removing condition deemed 'redundant' sem ADR,
			redefining condition semantic without changing name.
			Detection é meta-pattern
			ec-convergence-boundary-erosion-detected com canonical
			comparison entre set-as-implemented vs
			set-as-architecturally-declared. Boundary mutations devem
			ser ADR-grade decisions, não emergent runtime/code drift.
			"""
		category:  "rule"
		rationale: "Term canoniza meta-pattern crítico para long-term integrity. Sem este term, agentes (humanos ou estocásticos) podem incrementally alter set composition over time without architectural visibility. Naming 'meta' relativo a condition-weakening (que é threshold/proxy-level): este é set-composition-level. Os dois drifts são detectados separadamente porque têm vetores e detection mechanisms distintos."
		antiTerms: [{
			term:          "Set Evolution"
			clarification: "Evolution é neutro/legítimo when explicit and ADR-grade. Erosion é especificamente implicit/incremental sem visibility — failure mode da evolução."
		}, {
			term:          "Refactoring (in convergence context)"
			clarification: "Refactoring genérico legítimo. Refactoring de convergence set é alta-stakes architectural decision — não code cleanup. Confundir leads to silent erosion via 'cleanup' commits."
		}]
		rejectedAlternatives: [{
			term:   "SetDrift"
			reason: "Drift captures mas perde the 'boundary' semantic essential to canonical clause."
		}, {
			term:   "ConditionListMutation"
			reason: "Tecnicamente preciso mas perde the architectural framing — boundary é conceptual, não apenas list."
		}]
		examples: [{
			context:   "Silent addition of optional condition becoming mandatory"
			instance:  "Developer adds 'TCM.liquidity-cleared' as optional condition to authorization set para safety. Six meses later, code path treats absence as failure (defensive checks accumulate). Set as-implemented now requires TCM.liquidity-cleared; as-declared não. Boundary erosion detected via canonical comparison."
			rationale: "Silent shift from optional to mandatory sem ADR."
		}, {
			context:   "Silent removal of condition deemed redundant"
			instance:  "Code review comment suggests removing INV.invoice-approved because 'CMT.commitment-active implies invoice processed'. Removed without ADR. Six meses later, edge case (commitment active but invoice rejected post-hoc) leads to authorization sem evidence. Erosion detected retroactively; boundary should never have shifted sem architectural decision."
			rationale: "Implicit refactor produces semantic drift."
		}]
		relatedTerms: [
			"term-authorization-convergence-set",
			"term-retention-release-convergence-set",
			"term-condition-weakening",
			"term-convergence-integrity",
		]
		layerMapping: {
			codeTerm: "ConvergenceBoundaryErosion"
			apiTerm:  "convergence-boundary-erosion"
		}
	}, {
		code:   "term-convergence-integrity"
		name:   "Integridade de Convergência"
		termEn: "Convergence Integrity"
		definition: """
			Métrica canônica de avaliação do BC FCE per founder Phase
			1.6 cristalização. Mede em que grau o convergence process
			produces authorizations e retention releases somente
			quando set canonical converged integral and intact — sem
			condition-weakening incidents (term-condition-weakening),
			sem boundary-erosion drift (term-convergence-boundary-erosion),
			sem epistemic collapse (Indeterminate colapsado em Settled
			ou Failed). Per canonical evaluation metric statement: FCE
			is evaluated on convergence integrity, not authorization
			throughput. Maximizing throughput ao custo de integrity é
			explicit anti-goal: optimization pressure against integrity
			é PRIMARY long-term adversarial vector against BC identity.
			Composição: zero condition-weakening incidents, zero
			boundary-erosion detections, zero epistemic collapses,
			100% AuthorizationProof binding intact.
			"""
		category:  "metric"
		rationale: "Term canoniza THE evaluation metric do BC. Sem este term canonicamente posto, agentes (humanos e estocásticos) podem default to standard SaaS metrics (throughput, latency, error rate) — drift implícito to value system antithetical ao canonical purpose do BC. Founder Phase 1.6: 'FCE is evaluated on convergence integrity, not authorization throughput' is the explicit anti-goal naming. Sem este term, optimization pressure win silently over time."
		antiTerms: [{
			term:          "Authorization Throughput"
			clarification: "Throughput legítima como secondary observability metric, NUNCA primary evaluation. Confusing the two is canonical drift — operationally, throughput maximization implies trade-offs against integrity."
		}, {
			term:          "Payment Success Rate"
			clarification: "Success rate (% paid / % attempted) é downstream observability — útil mas not the canonical FCE metric. FCE pode have low 'success rate' enquanto preserving high integrity (e.g., refusing authorization sem convergence — that's success per FCE, failure per generic SaaS framing)."
		}, {
			term:          "System Reliability"
			clarification: "Reliability genérica technical. Convergence integrity é semantic: mede se canonical posture é preserved, não se sistema é stable."
		}]
		rejectedAlternatives: [{
			term:   "AuthorizationFidelity"
			reason: "Fidelity sugere precision against external target; integrity sugere internal coherence — fits canonical framing better."
		}, {
			term:   "PostureCompliance"
			reason: "Compliance carries regulatory connotation distinta; convergence-integrity é internal semantic invariant."
		}]
		examples: [{
			context:   "High integrity: defer authorization sem convergence"
			instance:  "Operational pressure 3 hours to authorize; convergence incomplete (1 condition pending). FCE defers, escalates, refuses to authorize. Per throughput metric: 0% (authorization not produced). Per integrity metric: 100% (no weakening incident, no epistemic collapse). FCE evaluation per canonical metric: succeed."
			rationale: "Integrity-over-throughput materializada."
		}, {
			context:   "Low integrity: throughput-driven weakening (counterfactual)"
			instance:  "Hypothetical: under pressure, FCE accepted 6/7 convergence (weakening). Per throughput: 100%. Per integrity: incident logged (condition-weakening detected ex-post). Evaluation per canonical metric: failure (regardless de outcome). Esta é a posture canônica que FCE preserves contra."
			rationale: "Throughput-driven weakening detected and rejected ex-ante."
		}]
		relatedTerms: [
			"term-authorization-convergence",
			"term-condition-weakening",
			"term-convergence-boundary-erosion",
			"term-economic-authority-crystallization",
		]
		layerMapping: {
			codeTerm: "ConvergenceIntegrity"
			apiTerm:  "convergence-integrity"
		}
	}]

	rationale: """
		Glossário canoniza Ubiquitous Language do BC FCE como
		boundary-hardening artifact for conditional economic
		authority, não como payment terminology dictionary. Cada
		termo materializa decisão de design semântica: o que FCE é
		(crystallization), o que FCE não é (sistema de pagamentos,
		settlement engine, payment orchestrator), e onde as
		boundaries com BCs adjacentes (BKR, CMT, BDG, REW, DLV,
		INV, NPM, ATO, TCM) são preservadas.

		22 termos organizados em 4 axes:
		(A) Identity & Authorization (4): cristalização canônica de
		    autoridade econômica + proof material;
		(B) Lifecycle & Financialization (7): aggregate central,
		    state machine, atomic financialization, cross-BC
		    instruction/outcome, epistemic non-collapse state;
		(C) Retention & Conditional Release (4): mech-evidence
		    materializado localmente, convergence-set específico;
		(D) Boundary, Authority & Anti-Patterns (7): epistemic
		    posture, upstream observation, drift detectors PRIMARY
		    (condition-weakening) e META (boundary-erosion),
		    canonical evaluation metric (convergence-integrity).

		Cross-BC alignments com BKR glossary peer preservados por
		convention de ownership lens (3 termos compartilhados:
		term-authorization-proof, term-payment-instruction,
		term-bkr-settlement-outcome). Each defines lens FCE-side
		(originated vs consumed) without copying BKR semantic.

		Lenses aplicadas: lens-domain-language-and-terminology-design
		(primária); lens-trust-and-credibility-design;
		lens-mechanism-design; lens-regulatory-compliance-as-
		architecture; lens-distributed-systems-design.

		domainModelRefs deferidos a Phase 3 quando domain-model.cue
		materializar building blocks (per PG gapPolicy: preenchidos
		incrementalmente quando domain-model surgir).

		Materializado em Phase 2 WI-043 FCE bootstrap via 4 batches
		incrementais (A → B → C → D) com 9 ajustes finos founder
		integrated pre-write (Cluster B: 5, Cluster C: 2, Cluster
		D: 2). Centering principle preservado throughout:
		boundary-hardening artifact for conditional economic
		authority, not a payment terminology dictionary.
		"""
}
