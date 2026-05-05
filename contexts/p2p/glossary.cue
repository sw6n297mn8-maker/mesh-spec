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
			reason: "Compromisso é responsabilidade CMT (formalização bilateral com aceite mútuo). PO é demanda unilateral upstream — aceite formaliza commitment downstream."
		}, {
			term:   "Fatura"
			reason: "Fatura é responsabilidade INV (faturamento downstream). PO é trigger de commitment, não documento financeiro de cobrança."
		}, {
			term:   "Pagamento"
			reason: "Pagamento é responsabilidade FCE (Financial Closure & Execution downstream). PO marca demanda; pagamento materializa pós-INV."
		}, {
			term:   "Cotação"
			reason: "Cotação (Quotation) é responsabilidade SSC (RFQ flow upstream). PO é resultado de decisão sourcing; cotação é input do processo competitivo SSC."
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
		code:        "term-sourcing-authority"
		name:        "Autoridade de Sourcing"
		termEn:      "Sourcing Authority"
		definition:  "Validação pré-existente que autoriza emissão de PO. Origem em 1 de 3 sources SSC: SourcingDecisionMade (one-shot, hard binding direto), PreferredSupplierDesignated (preferred com validityPeriod, soft binding), StrategicAwardCompleted (strategic, Phase 0 advisory binding; Phase 1+ hard pós-CTR ContractActivated). Authority é precondition para emit autônomo via gate determinístico; ausência dispara escalation insufficient-authority OR maverick supervised path."
		category:    "entity"
		rationale:   "Conceito de boundary entre SSC (decide) e P2P (executa) — articula bd-procurement-requires-sourcing-authority RECTOR herdado. Precisão: authority é VÁLIDA vs AUSENTE vs EXPIRADA — P2P observa authority status, NÃO revalida composition do pool subjacente (per bd-no-supplier-revalidation-by-p2p). Strategic-award authority transition Phase 0 advisory → Phase 1+ hard explícita (oq-p2p-1)."
		synonyms: ["Authority", "Sourcing Decision Authority"]
		antiTerms: [{
			term:   "Pool de Fornecedores Qualificados"
			reason: "Pool é responsabilidade SSC (validates eligibility via NPM em decision time + re-validation pre-decision). P2P NÃO possui pool — apenas authority válida (que pré-validou pool upstream)."
		}, {
			term:   "Eligibility NPM"
			reason: "Eligibility é responsabilidade NPM (single-owner per dp-04). P2P NÃO consulta NPM — confia em SSC's pre-validated authority."
		}, {
			term:   "Fitness Rules"
			reason: "Fitness rules são responsabilidade SSC (versionadas em config externa governada). P2P NÃO aplica regras — apenas observa authority outcome."
		}, {
			term:   "Decisão de Sourcing"
			reason: "Decision é responsabilidade SSC. Authority é o ASPECT da decision que P2P consume (ref + type + binding regime); decision como conceito completo (criteria, weights, evaluatedSuppliers) vive em SSC."
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
			reason: "Category (eg., raw materials, services) é classification orthogonal ao authority type. Authority type discrimina FONTE da decisão; category discrimina escopo da demanda."
		}, {
			term:   "Tipo de Decisão de Sourcing"
			reason: "SSC decisionType (one-shot/preferred/strategic) é distinct conceito (qual TIPO DE PROCESSO SSC decidiu). P2P authority-type é DERIVADO mas representa angle P2P-side: como tratar autoridade durante emit. Nomes distintos previnem confusão cross-BC."
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
			reason: "Decision é responsabilidade SSC (allocationPolicy declared in SourcingDecisionMade event). P2P observa convergência, NÃO decide allocation."
		}, {
			term:   "Allocation Policy"
			reason: "Policy é responsabilidade SSC. Convergence é o que P2P busca operacionalmente em agregado contra a policy declarada upstream."
		}, {
			term:   "Allocation Enforcement"
			reason: "Enforcement strict (rejeição automática per-PO de POs que violem policy) NÃO é P2P Phase 0 scope — domain-model mechanisms futuros podem evoluir para enforcement; Phase 0 é monitoring + drift signaling."
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
			reason: "Eligibility validation é responsabilidade SSC (decision time) + NPM (single-owner). P2P NÃO revalida supplier eligibility per bd-no-supplier-revalidation-by-p2p."
		}, {
			term:   "Approval"
			reason: "Approval sugere workflow humano (supervisor decides). Authority validation é gate determinístico autônomo (cache lookup + match)."
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
			reason: "Commitment lifecycle é responsabilidade CMT (proposed/accepted/rejected/...). P2P lifecycle stops at hand-off; CMT lifecycle inicia pós-PurchaseOrderEmitted consumption."
		}, {
			term:   "Delivery Lifecycle"
			reason: "Delivery lifecycle é responsabilidade DLV (verification downstream). P2P NÃO modela acknowledged/fulfilled — supplier acknowledgment (Phase 1+ via supplier API) e delivery verification (DLV) são distinct concerns."
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
			reason: "Fornecedor (sh-02) é a counterparty respondente; originadora é a parte que demanda. Roles distintos no procurement workflow."
		}, {
			term:   "Operador Agente"
			reason: "Operador agente (sh-05) é o agente operacional executando emit; originadora é o stakeholder humano que submete demanda ao agente."
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
			reason: "Category manager é responsabilidade SSC (declares decision type pré-RFQ + configures fitness rules). Comprador é responsabilidade P2P (validates authority + submits PO)."
		}, {
			term:   "Requisitante"
			reason: "Requisitante declares demanda (need); comprador valida authority + emite. Roles operacionais distintos dentro de originadora."
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
			reason: "Comprador valida authority + emite PO. Requisitante declara necessidade técnica que precede o ciclo de PO."
		}, {
			term:   "Fornecedor"
			reason: "Fornecedor é counterparty respondente. Requisitante é dentro da originadora (mesmo lado da demanda)."
		}]
		relatedTerms: [
			"term-originadora-de-demanda",
			"term-comprador",
		]
	}]

	rationale: """
		Glossário P2P parte 2a (anchor + values + process + roles).
		9 terms canônicos Phase 0 substantivos: 2 entities (Pedido de
		Compra unificado + Autoridade de Sourcing) + 2 values (Authority
		Type discriminator com 3 valores canônicos Phase 0 + Allocation
		Convergence aggregate-level monitoring) + 2 process (Authority
		Validation gate determinístico + PO Lifecycle 3 states) + 3
		roles (Originadora absorvendo Comprador + Requisitante).
		Restantes 6 terms (4 classifications anti-pattern/adversarial
		+ 2 events) entram em commit 2b. Anti-mini-NIM articulado
		via antiTerms boundary explícita em cada anchor entity (pool,
		eligibility, fitness rules, decisão sourcing, pagamento,
		faturamento — todos não são P2P concerns). Cross-BC vocabulary
		consistency: term-originadora-de-demanda mirrors SSC.
		"""
}
