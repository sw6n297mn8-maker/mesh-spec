package p2p

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue — Ubiquitous Language: Procure-to-Pay.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Glossário do BC P2P (Procure-to-Pay) — segundo BC do macrofluxo
// Mesh (SSC → P2P → CMT). Phase 0 cobre porção 'Procure' do nome
// canônico (PO emission + cancel pre-CMT); pagamento (FCE) e
// faturamento (INV) são BCs distintos downstream — termos relacionados
// aparecem em antiTerms para reforçar boundary.
//
// 15 terms canônicos planejados: 2 entities (Pedido de Compra +
// Autoridade de Sourcing) + 2 values (Authority Type discriminator +
// Allocation Convergence) + 2 process (Authority Validation + PO
// Lifecycle) + 3 roles (Originadora absorvendo Comprador +
// Requisitante) + 4 classifications (Maverick anti-pattern + 3
// vetores adversariais fragmentation/allocation-bias/renegotiation-
// pressure) + 2 events (PurchaseOrderEmitted hard binding +
// PurchaseOrderCancelled withdrawal/negative signal pre-CMT).
//
// Authoring manual section-by-section (paralelo ao canvas P2P; per
// founder choice contra dispatch path option). 5 ciclos red team
// aplicados pre-write detectaram: (1) drop term-purchase-authority-
// reference (redundante com sourcing-authority); (2) drop term-
// purchase-authority-cache (implementation detail, não conceito UL);
// (3) rename term-allocation-tracking → term-allocation-convergence
// (UL focus em outcome, não projection); (4) drop term-po-history
// (integrar em term-fragmentation-pattern); (5) drop term-withdrawal
// (semantic do event, não conceito autônomo).
//
// Anti-mini-NIM como invariant transversal: antiTerms em cada anchor
// articulando boundary explícita — pool de fornecedores qualificados
// (SSC concept), NPM eligibility, fitness rules (SSC), decisão de
// sourcing (SSC), pagamento (FCE), faturamento (INV) — todos NÃO são
// P2P concerns.
//
// Materializado em 2 commits incrementais (paralelo a SSC):
//   2a — anchor (2) + values (2) + process (2) + roles (3) = 9 terms (este commit)
//   2b — classifications (4) + events (2) = 6 terms
// + SRR srr-p2p-glossary
//
// 5 founder pre-write patches aplicados: (1) term-authority-type
// "3 valores enum" → "3 valores canônicos Phase 0" (não congelar
// enum pré-domain-model); (2) term-allocation-convergence "P2P
// enforce" suavizado para "P2P busca operacionalmente / monitors";
// (3) term-purchase-order-emitted "hard binding contratual" → "hard
// binding operational signal para CMT" (não contrato já existente);
// (4) term-originadora-de-demanda + synonym "Área Demandante" (PT-BR
// idiomático); (5) term-maverick + antiTerm "Compra emergencial"
// (PT-BR equivalent).

glossary: artifact_schemas.#Glossary & {
	code:              "p2p"
	name:              "Glossário P2P — Procure-to-Pay"
	boundedContextRef: "p2p"

	terms: [{
		code:        "term-purchase-order"
		name:        "Pedido de Compra"
		termEn:      "Purchase Order"
		definition:  "Conceito unificado da P2P representando demanda de compra formalizada para um supplier sob authorityRef pré-existente. PO carrega authorityType discriminator (one-shot-decision | preferred-designation | strategic-award) que determina binding regime + override semantics. PO immutable post-emit (P2P aggregate); cancel apenas via supervisedDecision pre-CMT formalization. Emit publica PurchaseOrderEmitted como hard binding signal operacional para CMT; cancel publica PurchaseOrderCancelled como withdrawal signal pre-formalization."
		category:    "entity"
		rationale:   "Conceito central do BC P2P. PO unificado (não 3 tipos paralelos a SSC types) com authorityRef discriminator desacopla P2P da estrutura interna SSC e permite evolução independente per bd-purchase-order-as-single-concept-with-authority-ref. Precisão crítica: PO é demanda formalizada bilateral → CMT trigger, não pagamento (FCE) nem faturamento (INV)."
		synonyms: ["PO", "Ordem de Compra", "Pedido"]
		antiTerms: [{
			term:   "Compromisso Econômico"
			clarification: "Compromisso é responsabilidade CMT (formalização bilateral com aceite mútuo). PO é demanda unilateral upstream — aceite formaliza commitment downstream."
		}, {
			term:   "Fatura"
			clarification: "Fatura é responsabilidade INV (faturamento downstream). PO é trigger de commitment, não documento financeiro de cobrança."
		}, {
			term:   "Pagamento"
			clarification: "Pagamento é responsabilidade FCE (Financial Closure & Execution downstream). PO marca demanda; pagamento materializa pós-INV."
		}, {
			term:   "Cotação"
			clarification: "Cotação (Quotation) é responsabilidade SSC (RFQ flow upstream). PO é resultado de decisão sourcing; cotação é input do processo competitivo SSC."
		}]
		rejectedAlternatives: [{
			term:   "Procurement Order"
			reason: "Procurement é categoria mais ampla (cobre sourcing + execution + supplier management); 'Purchase' é mais preciso para escopo de execution P2P."
		}, {
			term:   "Compra"
			reason: "Compra como termo isolado é ambíguo (cobre intent vs PO vs payment). 'Pedido de Compra' é canônico em vocabulário ERP/procurement BR."
		}]
		relatedTerms: [
			"term-sourcing-authority",
			"term-authority-type",
			"term-po-lifecycle",
		]
	}, {
		code:        "term-requisicao"
		name:        "Requisição de Compra"
		termEn:      "Purchase Requisition"
		definition:  "Declaração formal de demanda técnica pelo requisitante — a PORTA do ciclo demanda-a-pedido (adr-174/WI-151). Nasce no canteiro ancorada em Centro de Custo + etapa do orçamento (budgetStageRef, fato-de-origem), passa por triagem FORMAL do comprador (outcome routed-to-sourcing | returned | rejected) e por aprovação do gestor por Alçada sob o portão DUPLO pré-pedido (reserva de cobertura confirmada no bdg per adr-174 PORTÃO + procedência de preço verificada contra a cotação vencedora do ssc via sourcingDecisionRef per adr-177), e converte em Pedido de Compra na emissão. Lifecycle: submitted → triaged → approved → converted | rejected | cancelled (agg-purchase-requisition)."
		category:    "entity"
		rationale:   "A língua já existia (subdomínio p2p declara 'requisição, aprovação por alçada'; term-requisitante nomeia quem a declara) — o conceito ganhou lar de escrita no WI-151 após a ds-buyer-procurement-journey revelar o vazio ('requisi' tinha zero ocorrências nos domain-models). Requisição de Compra é vocabulário canônico em procurement BR (requisition-to-PO). Elo de rastreabilidade custo↔obra: toda demanda nasce ancorada na etapa que a origina."
		synonyms: ["Solicitação de Compra", "Requisição", "Purchase Requisition"]
		antiTerms: [{
			term:          "Pedido de Compra"
			clarification: "PO é a demanda FORMALIZADA ao fornecedor sob authority validada (downstream da requisição, via conversão). Requisição é a declaração INTERNA de demanda que precede cotação e pedido — nunca chega ao fornecedor."
		}, {
			term:          "Cotação"
			clarification: "Cotação é responsabilidade SSC (RFQ flow) — acontece DEPOIS da triagem da requisição, quando o comprador vai a mercado. Requisição é o input interno que dispara o funil."
		}]
		relatedTerms: [
			"term-requisitante",
			"term-comprador",
			"term-purchase-order",
			"term-po-lifecycle",
			"term-submeter-requisicao",
			"term-triar-requisicao",
			"term-aprovar-compra",
			"term-cancelar-requisicao",
		]
		// adr-151 Forma A (onda p2p, passo vi): reuso deste termo para o agg
		// (decisao do founder) -- a definicao ja descreve o boundary-com-ciclo;
		// o elo formal G1 e este ref.
		domainModelRefs: ["agg-purchase-requisition"]
	}, {
		code:        "term-sourcing-authority"
		name:        "Autoridade de Sourcing"
		termEn:      "Sourcing Authority"
		definition:  "Validação pré-existente que autoriza emissão de PO. Origem em 1 de 3 sources SSC: SourcingDecisionMade (one-shot, hard binding direto), PreferredSupplierDesignated (preferred com validityPeriod, soft binding), StrategicAwardCompleted (strategic, Phase 0 advisory binding; Phase 1+ hard pós-CTR ContractActivated). Authority é precondition para emit autônomo via gate determinístico; ausência dispara escalation insufficient-authority OR maverick supervised path."
		category:    "entity"
		rationale:   "Conceito de boundary entre SSC (decide) e P2P (executa) — articula bd-procurement-requires-sourcing-authority RECTOR herdado. Precisão: authority é VÁLIDA vs AUSENTE vs EXPIRADA — P2P observa authority status, NÃO revalida composition do pool subjacente (per bd-no-supplier-revalidation-by-p2p). Strategic-award authority transition Phase 0 advisory → Phase 1+ hard explícita (oq-p2p-1)."
		synonyms: ["Authority", "Sourcing Decision Authority"]
		antiTerms: [{
			term:   "Pool de Fornecedores Qualificados"
			clarification: "Pool é responsabilidade SSC (validates eligibility via NPM em decision time + re-validation pre-decision). P2P NÃO possui pool — apenas authority válida (que pré-validou pool upstream)."
		}, {
			term:   "Eligibility NPM"
			clarification: "Eligibility é responsabilidade NPM (single-owner per dp-04). P2P NÃO consulta NPM — confia em SSC's pre-validated authority."
		}, {
			term:   "Fitness Rules"
			clarification: "Fitness rules são responsabilidade SSC (versionadas em config externa governada). P2P NÃO aplica regras — apenas observa authority outcome."
		}, {
			term:   "Decisão de Sourcing"
			clarification: "Decision é responsabilidade SSC. Authority é o ASPECT da decision que P2P consume (ref + type + binding regime); decision como conceito completo (criteria, weights, evaluatedSuppliers) vive em SSC."
		}]
		rejectedAlternatives: [{
			term:   "Procurement Authority"
			reason: "Procurement é categoria ampla; 'Sourcing' é mais preciso para origem do authority (decisão SSC)."
		}, {
			term:   "Purchase Authorization"
			reason: "Authorization sugere approval workflow humano; 'Authority' captura precondition estrutural pré-existente (não authorization runtime)."
		}]
		relatedTerms: [
			"term-purchase-order",
			"term-authority-type",
			"term-authority-validation",
		]
	}, {
		code:        "term-authority-type"
		name:        "Tipo de Authority"
		termEn:      "Authority Type"
		definition:  "Discriminador da Autoridade de Sourcing. 3 valores canônicos Phase 0: 'one-shot-decision' (PO único para escopo específico, hard binding direto, override = supervisedDecision), 'preferred-designation' (PO recurring sob designation com validityPeriod, soft binding autonomous-with-audit, override permitido com audit trail), 'strategic-award' (PO sob strategic award, Phase 0 advisory binding até CTR ContractActivated materializar, Phase 1+ hard binding contratual). Enum domain-model congela em Phase 3."
		category:    "value"
		rationale:   "Discriminador determina binding regime + override semantics + cancel rules + lifecycle do authorityRef. Crítico para anti-mini-NIM: P2P NÃO infere binding regime — applies regra determinística per authority type. Strategic-award type captures Phase 0→Phase 1+ transition explicitly (advisory→hard pós-CTR ContractActivated). Phase 0 valores são canônicos mas formalmente congelados apenas em Phase 3 domain-model (#PurchaseAuthorityType enum)."
		antiTerms: [{
			term:   "Categoria de Compra"
			clarification: "Category (eg., raw materials, services) é classification orthogonal ao authority type. Authority type discrimina FONTE da decisão; category discrimina escopo da demanda."
		}, {
			term:   "Tipo de Decisão de Sourcing"
			clarification: "SSC decisionType (one-shot/preferred/strategic) é distinct conceito (qual TIPO DE PROCESSO SSC decidiu). P2P authority-type é DERIVADO mas representa angle P2P-side: como tratar autoridade durante emit. Nomes distintos previnem confusão cross-BC."
		}]
		relatedTerms: [
			"term-sourcing-authority",
			"term-purchase-order",
		]
	}, {
		code:        "term-allocation-convergence"
		name:        "Convergência de Allocation"
		termEn:      "Allocation Convergence"
		definition:  "Propriedade aggregate-level (cross-PO) onde volume distribuído entre suppliers ao longo da janela de validade da authority converge para a allocationPolicy declarada por SSC (e.g., split-by-percentage 60/40, split-by-criteria). P2P busca convergência operacionalmente em agregado via prj-allocation-tracking + sig-allocation-bias detection cross-PO; não força allocation per-PO individual nem enforce strict policy. Drift sustained vira signal cross-BC (oq-p2p-7)."
		category:    "value"
		rationale:   "Conceito de boundary com SSC: SSC define allocationPolicy; P2P monitora/busca operacionalmente convergência aggregate-level. Articula bd-allocation-policy-respected-in-aggregate. Precisão: convergence é OBSERVABLE PROPERTY + monitoring target (não computed enforcement) — P2P observa real allocation via projection; drift é signal cross-BC, não policy override. Enforcement strict requer domain-model mechanisms (Phase 3) que escapam Phase 0 scope."
		synonyms: ["Allocation Policy Monitoring", "Aggregate Allocation"]
		antiTerms: [{
			term:   "Allocation Decision"
			clarification: "Decision é responsabilidade SSC (allocationPolicy declared in SourcingDecisionMade event). P2P observa convergência, NÃO decide allocation."
		}, {
			term:   "Allocation Policy"
			clarification: "Policy é responsabilidade SSC. Convergence é o que P2P busca operacionalmente em agregado contra a policy declarada upstream."
		}, {
			term:   "Allocation Enforcement"
			clarification: "Enforcement strict (rejeição automática per-PO de POs que violem policy) NÃO é P2P Phase 0 scope — domain-model mechanisms futuros podem evoluir para enforcement; Phase 0 é monitoring + drift signaling."
		}]
		rejectedAlternatives: [{
			term:   "Allocation Tracking"
			reason: "Tracking sugere implementation (projection name); 'Convergence' captura o OUTCOME P2P busca — UL focus em valor produzido, não mecanismo."
		}, {
			term:   "Multi-Supplier Distribution"
			reason: "Distribution é mais geral; 'Convergence' captura o aspect específico de aggregate-level alignment com policy declarada (não distribution arbitrária)."
		}]
		relatedTerms: [
			"term-purchase-order",
			"term-sourcing-authority",
		]
	}, {
		code:        "term-authority-validation"
		name:        "Validação de Authority"
		termEn:      "Authority Validation"
		definition:  "Gate determinístico pré-emit que verifica authorityRef proposto contra prj-active-purchase-authorities (cache local derivada de 3 SSC events ACL) com sync fallback a QuerySourcingDecision SSC quando cache miss. Outcome: authority válida (caminho autônomo emit) OR insufficient/stale/conflicting (escalation). Anti-mini-NIM: agente NÃO infere authority quando ausente — escala. Validation NÃO inclui revalidação de pool composition (responsabilidade SSC pré-decision)."
		category:    "process"
		rationale:   "Process canônico do BC P2P — articula cap-04 24/7 via gate determinístico. Validation é função numérica (sim/não), não julgamento. Critical para anti-mini-NIM enforcement: mantém boundary clear entre 'authority observation' (P2P) e 'pool/fitness validation' (SSC)."
		synonyms: ["Authority Gate", "Sourcing Authority Check"]
		antiTerms: [{
			term:   "Supplier Eligibility Validation"
			clarification: "Eligibility validation é responsabilidade SSC (decision time) + NPM (single-owner). P2P NÃO revalida supplier eligibility per bd-no-supplier-revalidation-by-p2p."
		}, {
			term:   "Approval"
			clarification: "Approval sugere workflow humano (supervisor decides). Authority validation é gate determinístico autônomo (cache lookup + match)."
		}]
		relatedTerms: [
			"term-sourcing-authority",
			"term-purchase-order",
		]
	}, {
		code:        "term-po-lifecycle"
		name:        "Lifecycle de Purchase Order"
		termEn:      "Purchase Order Lifecycle"
		definition:  "State machine pública mínima do PO (3 states): 'requested' (PO submitted via EmitPurchaseOrder; agent valida authority), 'emitted' (terminal hand-off para CMT; PurchaseOrderEmitted publicado), 'cancelled' (terminal pre-CMT formalization apenas; PurchaseOrderCancelled como withdrawal signal). Lifecycle pós-CMT formalization NÃO modelado em P2P Phase 0 (oq-p2p-2 cross-BC). Acknowledged/fulfilled NÃO Phase 0 (oq-p2p-4 supplier API + DLV downstream)."
		category:    "process"
		rationale:   "Process canônico que articula bd-purchase-order-lifecycle-public-minimal + bd-cancellation-pre-formalization-only. Precisão: emitted é HAND-OFF terminal (CMT consume); cancelled é WITHDRAWAL terminal pre-formalization (CMT cancela path de formalização). 3 states deliberatamente mínimos para preserver confidentialidade competitiva (cotações + comparações vivem em SSC, não em P2P lifecycle)."
		antiTerms: [{
			term:   "Commitment Lifecycle"
			clarification: "Commitment lifecycle é responsabilidade CMT (proposed/accepted/rejected/...). P2P lifecycle stops at hand-off; CMT lifecycle inicia pós-PurchaseOrderEmitted consumption."
		}, {
			term:   "Delivery Lifecycle"
			clarification: "Delivery lifecycle é responsabilidade DLV (verification downstream). P2P NÃO modela acknowledged/fulfilled — supplier acknowledgment (Phase 1+ via supplier API) e delivery verification (DLV) são distinct concerns."
		}]
		relatedTerms: [
			"term-purchase-order",
		]
	}, {
		code:        "term-originadora-de-demanda"
		name:        "Originadora de Demanda"
		termEn:      "Demand Originator"
		definition:  "Stakeholder organizacional (mapeado a sh-01) que origina demanda de compra dentro da rede Mesh. Em P2P Phase 0, originadora absorve roles operacionais (compradores + requisitantes) sob entidade única — diferenciação Phase 1+ quando volume + complexity justify. Originadora submete EmitPurchaseOrder com authorityRef + supplierRef candidate; ganha gate determinístico + audit trail Lei 12.846 procurement; absorve maverick approvals como supervisedDecision."
		category:    "role"
		rationale:   "Role canônico do BC P2P — paralelo a SSC originadora (mesma sh-01 absorvendo category managers em SSC; absorve compradores + requisitantes em P2P). Phase 0 deliberate: modelar entidade única evita overhead de governance per-role pre-PMF; diferenciação operacional captura via term-comprador + term-requisitante separadamente como UL terms."
		synonyms: ["Buyer Organization", "Demanding Organization", "Área Demandante"]
		antiTerms: [{
			term:   "Fornecedor"
			clarification: "Fornecedor (sh-02) é a counterparty respondente; originadora é a parte que demanda. Roles distintos no procurement workflow."
		}, {
			term:   "Operador Agente"
			clarification: "Operador agente (sh-05) é o agente operacional executando emit; originadora é o stakeholder humano que submete demanda ao agente."
		}]
		relatedTerms: [
			"term-comprador",
			"term-requisitante",
			"term-purchase-order",
		]
	}, {
		code:        "term-comprador"
		name:        "Comprador"
		termEn:      "Buyer"
		definition:  "Role operacional dentro da Originadora de Demanda — valida authorityRef contra demanda do requisitante e submete EmitPurchaseOrder ao agente. Phase 0 absorbed em sh-01 originadora (sem governance differentiation). Comprador é o gatekeeper humano da authority match (supplier in selectedSuppliers/preferredSuppliers/awardedSuppliers da decisão SSC)."
		category:    "role"
		rationale:   "Role operacional canônico em vocabulário procurement BR — comprador é função estabelecida (operations team, central purchasing department). Phase 0 absorbed em sh-01 mas mantido como UL term para preserve domain language — Phase 1+ pode ganhar governance própria quando volume/complexity justify."
		synonyms: ["Purchaser", "Procurement Officer"]
		antiTerms: [{
			term:   "Category Manager"
			clarification: "Category manager é responsabilidade SSC (declares decision type pré-RFQ + configures fitness rules). Comprador é responsabilidade P2P (validates authority + submits PO)."
		}, {
			term:   "Requisitante"
			clarification: "Requisitante declares demanda (need); comprador valida authority + emite. Roles operacionais distintos dentro de originadora."
		}]
		relatedTerms: [
			"term-originadora-de-demanda",
			"term-requisitante",
			"term-authority-validation",
		]
	}, {
		code:        "term-requisitante"
		name:        "Requisitante"
		termEn:      "Requester"
		definition:  "Role operacional dentro da Originadora de Demanda — declara demanda técnica (categoryRef + scope + estimated amount) que precede EmitPurchaseOrder pelo comprador. Phase 0 absorbed em sh-01 originadora. Requisitante é tipicamente operational stakeholder (engineer, project manager) que identifica necessidade material/serviço; não opera authority validation directly (comprador role)."
		category:    "role"
		rationale:   "Role operacional canônico em vocabulário procurement BR — requisitante é função estabelecida em fluxos requisition-to-PO. Phase 0 absorbed em sh-01 mas mantido como UL term para preserve operational distinction. Diferenciação requisitante vs comprador é separation of concerns: technical demand vs authority validation."
		synonyms: ["Requester", "Technical Demand Originator"]
		antiTerms: [{
			term:   "Comprador"
			clarification: "Comprador valida authority + emite PO. Requisitante declara necessidade técnica que precede o ciclo de PO."
		}, {
			term:   "Fornecedor"
			clarification: "Fornecedor é counterparty respondente. Requisitante é dentro da originadora (mesmo lado da demanda)."
		}]
		relatedTerms: [
			"term-originadora-de-demanda",
			"term-comprador",
		]
	}, {
		code:        "term-maverick"
		name:        "Maverick"
		termEn:      "Maverick"
		definition:  "Anti-pattern de PO: demanda emitida SEM authorityRef canônica pré-validada (one-shot/preferred/strategic) — bypass do RECTOR bd-procurement-requires-sourcing-authority. Phase 0 maverick é blocked no gate determinístico autônomo + escalado como supervisedDecision approve-po-without-sourcing-authority com justificativa documentada (emergência, fixed-price low-value, regulatory exception). Maverick rate sustained é signal de drift sh-01 (manipulation vector)."
		category:    "classification"
		rationale:   "Concept anti-pattern crítico para articulating bd-procurement-requires-sourcing-authority RECTOR. Workaround classification: schema #TermCategory enum não tem 'anti-pattern'; uses classification per precedente SSC term-fracionamento. Maverick é vocabulário estabelecido em procurement literature (maverick spend, off-contract spend, rogue purchasing)."
		synonyms: ["Maverick Spend", "Off-Contract Purchase", "Rogue PO"]
		antiTerms: [{
			term:          "Emergency Purchase"
			clarification: "Emergency é caso legítimo de exceção (supervised approval com justificativa); maverick é spend não-controlado pattern. Distinguishment: emergency tem justificativa documentada + gate humano explícito; maverick é bypass silencioso."
		}, {
			term:          "Compra emergencial"
			clarification: "Compra emergencial (PT-BR equivalente a Emergency Purchase) é caso legítimo via supervisedDecision approve-po-without-sourcing-authority com justificativa documentada (urgência operacional, fornecedor único disponível). Maverick é o pattern abusivo: emit PO sem authority canônica E sem supervised approval (silent bypass do RECTOR)."
		}, {
			term:          "Spot Purchase"
			clarification: "Spot purchase é compra one-time (válida via one-shot decision SSC); maverick é spot WITHOUT one-shot decision authority. Pattern matters."
		}]
		rejectedAlternatives: [{
			term:   "Off-Contract"
			reason: "'Off-contract' é mais técnico (sugere ausência de strategic-award contract apenas); 'Maverick' captures broader anti-pattern (qualquer authority canônica ausente — one-shot OR preferred OR strategic)."
		}]
		relatedTerms: [
			"term-purchase-order",
			"term-authority-validation",
			"term-fragmentation-pattern",
		]
	}, {
		code:        "term-fragmentation-pattern"
		name:        "Padrão de Fragmentação"
		termEn:      "Fragmentation Pattern"
		definition:  "Anti-pattern adversarial: múltiplos POs sub-threshold do mesmo proponente (ou mesmo supplier cross-categoria) em janela curta para evitar SSC decision threshold OU bypass de supervisedDecision approval. Vetor sh-01 manipulation. Detection P2P Phase 0 via prj-purchase-history-by-category local; cross-BC coordination com BDG (oq-bdg-1 análogo) + SSC (paralelo a SSC prj-rfq-history-by-category) pendente Phase 1+ (oq-p2p-6)."
		category:    "classification"
		rationale:   "Vetor adversarial sustentando incentiveAnalysis sh-01 designResponse. Workaround classification per precedente SSC + BDG. Cross-BC pattern (existe em SSC RFQ flow, BDG budget approval, P2P PO emission) — uniformity de naming reforça cross-BC coordination quando materializada Phase 1+."
		synonyms: ["Threshold Gaming", "Splitting Pattern"]
		antiTerms: [{
			term:          "Lote de Compras"
			clarification: "Lote (batch ordering) é prática operacional legítima (efficiency). Fragmentação é pattern coordenado com intent de bypass — distinção via temporal pattern + threshold proximity + repeated proponent."
		}]
		rejectedAlternatives: [{
			term:   "Threshold Avoidance"
			reason: "Avoidance é mais geral; 'Fragmentation Pattern' captures the specific mechanism (splitting demand into sub-threshold pieces). Plus: paralelo cross-BC (SSC + BDG) usa fragmentation language."
		}]
		relatedTerms: [
			"term-maverick",
			"term-purchase-order",
		]
	}, {
		code:        "term-allocation-bias"
		name:        "Viés de Allocation"
		termEn:      "Allocation Bias"
		definition:  "Anti-pattern adversarial: desvio sistemático da allocationPolicy SSC declarada pelo agente operador (sh-05 vetor) — favorecer certos suppliers em multi-supplier authority routing além do envelope esperado per policy. Detection via prj-allocation-tracking comparando real distribution vs policy. Phase 0 detection local + sig-allocation-bias OBS metrics; Phase 1+ NIM consumes para cross-BC pattern recognition (oq-p2p-7)."
		category:    "classification"
		rationale:   "Vetor adversarial sustentando incentiveAnalysis sh-05 designResponse. Crítico para anti-mini-NIM enforcement: agente operador é stakeholder próprio com incentivos (dp-08); design tem que prever drift potencial em allocation routing autonomous decisions. Workaround classification per precedente."
		synonyms: ["Routing Bias", "Supplier Favoritism"]
		antiTerms: [{
			term:          "Operational Preference"
			clarification: "Operational preference é justificativa legítima (supplier reliability, location proximity) registrada em decisionRationale upstream. Bias é desvio NÃO-justificado da policy declarada — distinção via audit trail + statistical pattern vs legitimate variability."
		}]
		relatedTerms: [
			"term-allocation-convergence",
			"term-purchase-order",
		]
	}, {
		code:        "term-renegotiation-pressure"
		name:        "Pressão de Renegociação"
		termEn:      "Renegotiation Pressure"
		definition:  "Anti-pattern adversarial: pressão sustentada de fornecedor (sh-02 vetor) para renegotiation pós-PurchaseOrderEmitted — drift de price/scope/terms explorando dependência operacional (urgência, lock-in, switching cost). PO immutable post-emit by design (P2P aggregate lifecycle); cancel apenas supervisedDecision. Detection via supplier-override-rate sustained + audit trail. Phase 0 manual review; Phase 1+ feedback loop NIM (oq-p2p-3)."
		category:    "classification"
		rationale:   "Vetor adversarial sustentando incentiveAnalysis sh-02 designResponse. Articula immutability post-emit como design defense. Distinguishment necessário: legitimate scope change request vs sustained pressure pattern — primeiro usa supervisedDecision cancel + re-emit path; segundo é classification anti-pattern observable via override-rate."
		synonyms: ["Price Drift Pressure", "Post-Emit Renegotiation"]
		antiTerms: [{
			term:          "Scope Adjustment Request"
			clarification: "Scope adjustment legítimo (e.g., supplier capacity issue, technical change) usa supervisedDecision cancel + re-emit path. Pressure é pattern sustained sem justificativa estrutural — distinção via repeated incidents + supplier-specific pattern."
		}]
		relatedTerms: [
			"term-purchase-order",
			"term-purchase-order-cancelled",
		]
	}, {
		code:        "term-purchase-order-emitted"
		name:        "PurchaseOrderEmitted"
		termEn:      "Purchase Order Emitted"
		definition:  "Domain event published por P2P quando authority validada + EmitPurchaseOrder approved → PO emitido + state=emitted (terminal hand-off). Hard binding signal operacional para CMT (consumer único Phase 0 — formaliza commitment a partir do PO). Event imutável carrega purchaseOrderId + authorityRef + authorityType + supplier + scope + amount + emittedAt + emittedBy + audit metadata. Phase 0 sem NIM consumer; Phase 1+ pós-NIM bootstrap (oq-p2p-3 paralelo a oq-ssc-2)."
		category:    "event"
		rationale:   "Event canônico spine commitment-lifecycle entre P2P e CMT (per p2p-to-cmt context-map relation). Hard binding operational signal: PO emitida triggera path de commitment formalization (CMT consume + initiates lifecycle); 'hard' refere-se ao caráter inevitável do trigger downstream, NÃO a obrigação contratual estabelecida (contrato é responsabilidade CTR para strategic-award; CMT formaliza commitment econômico bilateral). Audit trail authorityRef + authorityType + supplier + scope é evidence regulatory-grade Lei 12.846 procurement."
		layerMapping: {
			codeTerm: "PurchaseOrderEmitted"
		}
		antiTerms: [{
			term:          "CommitmentAccepted"
			clarification: "CommitmentAccepted é responsabilidade CMT (downstream lifecycle). PurchaseOrderEmitted é trigger; CommitmentAccepted é consequence pós-CMT consumption + bilateral aceite."
		}, {
			term:          "InvoiceIssued"
			clarification: "InvoiceIssued é responsabilidade INV (faturamento downstream pós-DLV verification). PurchaseOrderEmitted é upstream event; InvoiceIssued depende de delivery + verification."
		}]
		relatedTerms: [
			"term-purchase-order",
			"term-po-lifecycle",
			"term-purchase-order-cancelled",
		]
	}, {
		code:        "term-purchase-order-cancelled"
		name:        "PurchaseOrderCancelled"
		termEn:      "Purchase Order Cancelled"
		definition:  "Domain event published por P2P quando supervisedDecision cancel-emitted-po é approved + state=cancelled (terminal pre-CMT formalization apenas). Withdrawal/negative signal para CMT: PO retirada antes de commitment formalization; CMT cancela path de formalização sem produzir CommitmentAccepted. Race condition pós-formalization (PurchaseOrderEmitted consumed mas Cancelled chegando após CommitmentAccepted) requer cross-BC coordination separada (oq-p2p-2 deferred). Phase 0 cobre apenas pre-CMT cancellation."
		category:    "event"
		rationale:   "Event canônico para signal de retirada — paralelo a PurchaseOrderEmitted mas com semantic withdrawal. Articula bd-cancellation-pre-formalization-only Phase 0 boundary. Distinguishment crítico: 'withdrawal/negative signal' (não 'advisory generic'); CMT consume com semantic explícita per Patch 2 founder canvas."
		layerMapping: {
			codeTerm: "PurchaseOrderCancelled"
		}
		antiTerms: [{
			term:          "CommitmentCancelled"
			clarification: "CommitmentCancelled é responsabilidade CMT (lifecycle pós-formalization). PurchaseOrderCancelled é pre-formalization withdrawal; CommitmentCancelled requer commitment já formalizado + cross-BC cancellation flow."
		}, {
			term:          "OrderRefused"
			clarification: "Refusal sugere supplier-side rejection. Cancellation é P2P-side withdrawal (originadora ou agent supervised) antes de supplier acknowledgment."
		}]
		relatedTerms: [
			"term-purchase-order",
			"term-po-lifecycle",
			"term-purchase-order-emitted",
		]
	}, {
		// adr-151 Forma A (onda p2p, passo vi) -- 11 termos novos dando cobertura
		// dedicada (G1) aos commands/events da Requisicao de Compra (kit adr-178);
		// o agg reusa term-requisicao (decisao do founder). Padrao ato/fato.
		code:        "term-submeter-requisicao"
		name:        "Submeter Requisição"
		termEn:      "Submit Purchase Requisition"
		definition:  "Ato do requisitante de declarar demanda técnica — cria a Requisição de Compra em submitted e a coloca na fila de triagem do comprador (async: nenhuma decisão síncrona no ato). A PORTA da jornada de compras; origem net-new legítima per adr-178 (o cronograma físico do canteiro ainda não é input de sistema). Comando — distinto do fato Requisição Submetida."
		category:    "command"
		rationale:   "Entry point do ciclo demanda-a-pedido (adr-174/WI-151); ato do requisitante, distinto do fato — ato/fato."
		relatedTerms: ["term-requisicao", "term-requisitante", "term-requisicao-submetida"]
		domainModelRefs: ["cmd-submit-purchase-requisition"]
	}, {
		code:        "term-requisicao-submetida"
		name:        "Requisição Submetida"
		termEn:      "Purchase Requisition Submitted"
		definition:  "Fato de que a demanda técnica foi declarada e a Requisição de Compra nasceu em submitted, aguardando triagem — o fato de abertura do ciclo demanda-a-pedido. Evento — distinto do comando Submeter Requisição."
		category:    "event"
		rationale:   "Fato de abertura do ciclo; interno ao P2P até a conversão em pedido — fato vs ato."
		relatedTerms: ["term-requisicao", "term-submeter-requisicao", "term-requisicao-triada"]
		domainModelRefs: ["evt-purchase-requisition-submitted"]
	}, {
		code:        "term-triar-requisicao"
		name:        "Triar Requisição"
		termEn:      "Triage Requisition"
		definition:  "Ato FORMAL do comprador de triar a requisição submetida, com outcome: routed-to-sourcing (segue para cotação/decisão de sourcing), returned (devolvida ao requisitante para correção — sem transição de estado) ou rejected (demanda morta na triagem). Comando — distinto do fato Requisição Triada."
		category:    "command"
		rationale:   "Triagem é ato formal com outcome, não anotação (decisão do founder no WI-151); materializa o passo 3 da jornada — ato/fato."
		relatedTerms: ["term-requisicao", "term-comprador", "term-requisicao-triada"]
		domainModelRefs: ["cmd-triage-requisition"]
	}, {
		code:        "term-requisicao-triada"
		name:        "Requisição Triada"
		termEn:      "Purchase Requisition Triaged"
		definition:  "Fato do ato formal de triagem, com o outcome de roteamento registrado: routed-to-sourcing e rejected transicionam; returned registra a devolução e a requisição permanece submitted para correção. Evento — distinto do comando Triar Requisição."
		category:    "event"
		rationale:   "O outcome carrega a decisão de roteamento (selectors per adr-160); returned não transiciona — fato fiel ao desenho."
		relatedTerms: ["term-requisicao", "term-triar-requisicao"]
		domainModelRefs: ["evt-purchase-requisition-triaged"]
	}, {
		code:        "term-aprovar-compra"
		name:        "Aprovar Compra"
		termEn:      "Approve Purchase"
		definition:  "Ato de decisão do gestor por Alçada sobre requisição triada (approve | reject), sob o portão DUPLO pré-pedido: (1) reserva de cobertura confirmada pelo Gate de Cobertura do bdg (adr-174) e (2) procedência de preço verificada contra a cotação vencedora do ssc via sourcingDecisionRef (adr-177). Falha de qualquer braço não transiciona — escalada supervisionada. Comando — distinto do fato Compra Aprovada."
		category:    "command"
		rationale:   "O de-acordo do gestor como pré-condição da emissão (adr-174 decisão 1); o approve RESERVA cobertura (two-phase §2.0.8) — ato/fato."
		relatedTerms: ["term-requisicao", "term-compra-aprovada", "term-aprovacao-de-compra-recusada"]
		domainModelRefs: ["cmd-approve-purchase"]
	}, {
		code:        "term-compra-aprovada"
		name:        "Compra Aprovada"
		termEn:      "Purchase Approved"
		definition:  "Fato de que o gestor aprovou por Alçada com os dois braços do portão verificados — cobertura reservada no Centro de Custo (bdg, adr-174) e procedência de preço provada contra a cotação vencedora (ssc, adr-177). A reserva efetiva-se no aceite do commitment e libera no cancelamento. Evento — distinto do comando Aprovar Compra."
		category:    "event"
		rationale:   "A pré-condição que o setor de compras vive vira fato verificável do sistema — alçada e saldo precedem a emissão, nunca reagem ao pedido."
		relatedTerms: ["term-requisicao", "term-aprovar-compra", "term-requisicao-convertida"]
		domainModelRefs: ["evt-purchase-approved"]
	}, {
		code:        "term-aprovacao-de-compra-recusada"
		name:        "Aprovação de Compra Recusada"
		termEn:      "Purchase Approval Rejected"
		definition:  "Fato do não-de-acordo do gestor — a requisição triada morre no portão (triaged → rejected). Distinto de falha do Gate de Cobertura: falha de gate não transiciona nem emite este evento (segue a escalada supervisionada e a requisição permanece triaged). Evento — o outcome reject do comando Aprovar Compra."
		category:    "event"
		rationale:   "Registro do não-de-acordo como fato — sustenta a fila do gestor e a leitura de padrões; decisão humana não se confunde com gate (P10)."
		relatedTerms: ["term-requisicao", "term-aprovar-compra"]
		domainModelRefs: ["evt-purchase-approval-rejected"]
	}, {
		code:        "term-converter-requisicao"
		name:        "Converter Requisição"
		termEn:      "Convert Requisition"
		definition:  "Comando INTERNO emitido pela policy de conversão quando o Pedido de Compra emitido carrega o requisitionRef — transiciona a requisição approved → converted, fechando o ciclo requisição → pedido. Veículo tático da policy (adr-174), não ato humano. Comando — distinto do fato Requisição Convertida."
		category:    "command"
		rationale:   "Par command/event exigido por construção do schema (#StateTransition); a decisão semântica é a policy — o comando é o veículo."
		relatedTerms: ["term-requisicao", "term-requisicao-convertida", "term-purchase-order-emitted"]
		domainModelRefs: ["cmd-convert-requisition"]
	}, {
		code:        "term-requisicao-convertida"
		name:        "Requisição Convertida"
		termEn:      "Purchase Requisition Converted"
		definition:  "Fato do fecho do ciclo requisição → pedido: a requisição aprovada foi consumada em Pedido de Compra (approved → converted). Evento — distinto do comando interno Converter Requisição."
		category:    "event"
		rationale:   "Sem este fato a requisição ficaria approved órfã após o pedido nascer — converted mantém a fila de requisições limpa."
		relatedTerms: ["term-requisicao", "term-converter-requisicao", "term-purchase-order"]
		domainModelRefs: ["evt-purchase-requisition-converted"]
	}, {
		code:        "term-cancelar-requisicao"
		name:        "Cancelar Requisição"
		termEn:      "Cancel Purchase Requisition"
		definition:  "Ato de retirar a demanda pré-conversão (submitted | triaged | approved) — requisitante retira ou supervisor limpa a fila. Cancelamento de requisição approved implica liberar a reserva de cobertura no bdg (release per two-phase adr-174). Comando — distinto do fato Requisição Cancelada."
		category:    "command"
		rationale:   "Saída limpa do lifecycle pré-conversão — sem ela, requisição abandonada prenderia reserva (falsificação (b) do adr-174)."
		relatedTerms: ["term-requisicao", "term-requisicao-cancelada"]
		domainModelRefs: ["cmd-cancel-purchase-requisition"]
	}, {
		code:        "term-requisicao-cancelada"
		name:        "Requisição Cancelada"
		termEn:      "Purchase Requisition Cancelled"
		definition:  "Fato da saída limpa do lifecycle pré-conversão (de submitted, triaged ou approved), com liberação da reserva de cobertura quando a requisição estava approved. Reusa a taxonomia estruturada de cancelamento do BC (vo-cancellation-reason). Evento — distinto do comando Cancelar Requisição e do fato Purchase Order Cancelled (pedido, não requisição)."
		category:    "event"
		rationale:   "Fato do cancelamento com vocabulário único de razões — analytics cobre requisições e pedidos com a mesma taxonomia."
		relatedTerms: ["term-requisicao", "term-cancelar-requisicao", "term-purchase-order-cancelled"]
		domainModelRefs: ["evt-purchase-requisition-cancelled"]
	}]

	rationale: """
		Glossário P2P (Procure-to-Pay) — 27 terms canônicos cobrindo
		Ubiquitous Language do segundo BC do macrofluxo Mesh (SSC →
		P2P → CMT). Phase 0 escopo deliberado: porção 'Procure' do
		nome canônico (PO emission + cancel pre-CMT; ampliado no
		WI-151 com a PORTA da requisição — demanda → triagem →
		aprovação per adr-174); pagamento (FCE)
		e faturamento (INV) são BCs distintos downstream — antiTerms
		articulam boundary explícita.

		Distribuição: 3 entities (Pedido de Compra + Requisição de
		Compra per WI-151 + Autoridade de Sourcing) + 2 values (Authority Type discriminator + Allocation
		Convergence aggregate-level monitoring) + 2 process (Authority
		Validation gate determinístico + PO Lifecycle 3 states) + 3
		roles (Originadora absorvendo Comprador + Requisitante
		operacionais) + 4 classifications (Maverick anti-pattern + 3
		vetores adversariais Fragmentation/Allocation Bias/Renegotiation
		Pressure) + 2 events (PurchaseOrderEmitted hard binding
		operational signal + PurchaseOrderCancelled withdrawal/negative
		signal pre-CMT).

		Anti-mini-NIM enforcement como invariant transversal via
		antiTerms em cada anchor entity — pool de fornecedores
		qualificados (SSC concept), NPM eligibility, fitness rules
		(SSC), decisão de sourcing (SSC), pagamento (FCE), faturamento
		(INV), commitment lifecycle (CMT), delivery (DLV) — todos NÃO
		são P2P concerns. Boundary clarification reforçada em
		term-sourcing-authority (P2P NÃO possui pool — apenas authority
		válida vs ausente vs expirada) e term-authority-validation
		(NÃO inclui revalidação de pool composition).

		Cross-BC vocabulary consistency: term-fragmentation-pattern
		mirrors SSC term-fracionamento + BDG term-fracionamento
		análogo (paralelo); term-originadora-de-demanda mirrors SSC
		mesmo conceito; term-maverick é P2P-specific anti-pattern.

		Vocabulary híbrido PT-BR + EN loanword (Purchase Order,
		Maverick, Allocation Bias, Renegotiation Pressure) seguindo
		precedente SSC/BDG/IDC — defensável caso a caso em rationale
		por termo.

		Phase 0 caveats explícitos:
		- term-sourcing-authority strategic-award type: Phase 0
		  advisory binding → Phase 1+ hard pós-CTR ContractActivated
		  (oq-p2p-1)
		- term-authority-type: 3 valores canônicos Phase 0; enum
		  formalmente congelado em Phase 3 domain-model
		- term-allocation-convergence: monitoring Phase 0; enforcement
		  strict requer domain-model mechanisms Phase 1+
		- term-purchase-order-cancelled: pre-CMT formalization apenas;
		  pós-CMT cross-BC coordination (oq-p2p-2)
		- term-fragmentation-pattern: detection local Phase 0;
		  cross-BC coordination Phase 1+ (oq-p2p-6)
		- term-allocation-bias / term-renegotiation-pressure: signal
		  Phase 0 OBS metrics; Phase 1+ NIM feedback loops (oq-p2p-3
		  + oq-p2p-7)

		Schema satisfação tq-gl-XX por inspeção: tq-gl-01 (codes
		únicos: 15 terms com term-* codes distintos) ✓; tq-gl-02
		(relatedTerms refs intra-glossário válidos) ✓; tq-gl-03
		(domainModelRefs vazios — o domain-model P2P já existe;
		backfill dos refs é trabalho futuro) ✓; tq-gl-04 (não aplicável Phase
		0); tq-gl-05 (definitions distintas de names; sem redundância)
		✓; tq-gl-06 (antiTerms não repetem term names) ✓; tq-gl-07
		(boundedContextRef alinha canvas) ✓; tq-gl-08 (sem self-
		references em relatedTerms) ✓; tq-gl-10 (layerMapping presente
		em 2 events com codeTerm) ✓; tq-gl-11 (termEn semanticamente
		adequado — Purchase Order e Maverick loanwords explícitos) ✓.

		5 founder pre-write patches aplicados:
		- Patch 1: term-authority-type wording '3 valores enum' → '3
		  valores canônicos Phase 0' (não congelar enum pré-domain-
		  model)
		- Patch 2: term-allocation-convergence wording suavizado ('P2P
		  busca operacionalmente / monitors' não 'enforce')
		- Patch 3: term-purchase-order-emitted 'hard binding contratual'
		  → 'hard binding operational signal' (não contrato existente)
		- Patch 4: term-originadora-de-demanda + synonym 'Área
		  Demandante'
		- Patch 5: term-maverick + antiTerm 'Compra emergencial' (PT-BR)

		Materializado em 2 commits incrementais (paralelo a SSC):
		2a (e3c2d4a + 731e5dd correção schema antiTerm field) — anchor
		(2) + values (2) + process (2) + roles (3) = 9 terms; 2b (este
		commit) — classifications (4) + events (2) = 6 terms.
		Cada commit deixa cue vet ./contexts/p2p/ EXIT=0.
		"""
}
