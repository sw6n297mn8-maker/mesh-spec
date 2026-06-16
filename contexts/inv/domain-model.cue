package inv

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-model.cue — Domain Model: Invoicing.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Domain model do BC INV — 9º BC bootstrap. Phase 3 do WI-053
// pos-canvas Phase 1 + glossary Phase 2. Materializa propriedades
// formais como CUE constraints validáveis via cue vet —
// transforma INV de "conjunto de termos" em "sistema formal onde
// violações viram erro de compilação" (founder framing).
//
// Domain model é COMPILAÇÃO do glossary (não design livre):
//   Glossary entity → Aggregate/Entity (struct + state)
//   Glossary event → Domain Event (append-only fact)
//   Glossary rule (mechanism) → Invariant (hard constraint)
//   Glossary value → Value Object (typed value)
//   Glossary condition → Predicate/Guard (não muta estado)
//
// Decisões estruturais founder pre-write (5 ajustes finais):
// (1) reasonCode: string (não enum) — decisão fica em policy/regime
//     layer, não no type system do domínio
// (2) cancellationWindow: função pura externa ao domínio — domínio
//     usa, não define (relação declarativa em invariant rule)
// (3) Timestamps padronizados: eventTimestamp em TODOS events;
//     entity Invoice mantém issuedAt como field semântico próprio
// (4) appendOnlyEventLog NÃO é invariant de domínio — é
//     infraestrutura/storage guarantee (removido do model)
// (5) Receivable referential integrity reduzida — atomic-dual-
//     emission já cobre amount/currency consistency
//
// Aggregate: 1 root (Invoice) com Receivable como entity interna.
// BD7 (atomic-dual-emission) implica MESMA unidade de verdade —
// separar aggregates transformaria garantia em coordenação
// (decisão founder pre-write não-negociável).
//
// Materializado em 2 partes incrementais:
//   Part 1 (este commit): catalogs (events + commands + invariants
//     + valueObjects) — ainda SEM aggregate (file fica em estado
//     intermediário até Part 2)
//   Part 2: aggregates (root + entity + lifecycle) + projections
//     + policies + outer rationale
//
// Boundary preservation transversal (anti-mini-NIM/FCE/SCF/ATO):
// - reasonCode: string (não fixa enum no domain — anti-mini-ATO)
// - cancellationWindow externo (não procedural — anti-orchestrator)
// - Receivable internal entity (não autonomous — anti-mini-SCF)
// - timestamps uniformes (anti-special-case-leakage)

domainModel: artifact_schemas.#DomainModel & {
	code:              "inv"
	name:              "Invoicing"
	boundedContextRef: "inv"

	// =============================================
	// DOMAIN EVENTS (3) — todos published cross-BC
	// =============================================

	events: [
		{
			code:        "evt-invoice-issued"
			name:        "InvoiceIssued"
			description: "Fatura formalmente emitida sob identity (commitmentRef, evidenceRef). Evento canônico que declara nascimento de obrigação fiscal a partir de DeliveryVerified status=approved + commitmentTerms projection consistente. Append-only no event log; INV não muta nem re-emite. Consumido cross-BC por FCE (settle pagamento) e ATO (lançamento fiscal — pattern conformist)."
			rationale:   "Contrato semântico público da rede materializando BD7 atomic-dual-emission (par com ReceivableMaterialized). Payload mínimo categórico defende anti-payload-bloat (sem paymentMethod/paymentSchedule/accountRef = FCE concerns; sem riskScore/eligibility = REW/SCF concerns; sem rationale fiscal interpretativo = ATO concern). Append-only é invariante operacional — cancellation gera evento separado, nunca mutação retroativa."
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "invoiceId", valueObjectRef:        "vo-invoice-id"},
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:    "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:      "vo-evidence-ref"},
				{kind: "value-object-ref", name: "amount", valueObjectRef:           "vo-money"},
				{kind: "value-object-ref", name: "regimeVersion", valueObjectRef:    "vo-regime-version"},
				{kind: "value-object-ref", name: "fiscalDocRef", valueObjectRef:     "vo-fiscal-doc-ref"},
				{kind: "primitive", name:        "eventTimestamp", type:             "datetime"},
			]
		},
		{
			code:        "evt-receivable-materialized"
			name:        "ReceivableMaterialized"
			description: "Direito creditório passível de transferência materializado atomicamente com InvoiceIssued (mesma transação, primitive infra). amount idêntico ao Invoice por construção (BD7 conservation). Materialização ocorre SEMPRE que Invoice é emitida — não depende de elegibilidade, scoring ou decisão financeira externa. Consumido cross-BC por SCF para originar produtos financeiros sobre lastro verificado."
			rationale:   "Contrato semântico público para SCF separado de InvoiceIssued (BD7 dual emission atomic) preservando contract independence — SCF liga em ReceivableMaterialized sem acoplar-se a fiscalDocRef/regimeVersion (concerns INV/ATO). INV não determina transferibilidade nem condições de cessão; apenas materializa o direito creditório. SCF decide se, como e sob quais condições ocorre a transferência."
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "receivableId", valueObjectRef:     "vo-receivable-id"},
				{kind: "value-object-ref", name: "invoiceId", valueObjectRef:        "vo-invoice-id"},
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:    "vo-commitment-ref"},
				{kind: "value-object-ref", name: "amount", valueObjectRef:           "vo-money"},
				{kind: "primitive", name:        "eventTimestamp", type:             "datetime"},
			]
		},
		{
			code:        "evt-invoice-cancelled"
			name:        "InvoiceCancelled"
			description: "Cancellation INV-owned dentro de janela fiscal regulada (G3 explicit-event-only — sem soft-delete, sem overwrite, sem re-emissão silenciosa). Append-only no event log. Consumido cross-BC contextualmente: FCE pode ignorar pós-settle (correção é DRC scope); ATO sempre processa (estornar lançamento fiscal); outros BCs decidem conforme própria responsabilidade."
			rationale:   "Único path INV-owned de mutação pós-issued, com escopo regulamentado (janela fiscal). Fora-da-janela escala para DRC/ATO via supervisedDecision. reasonCode é string (não enum no type) — taxonomia de razões pertence a policy/regime/adapter layer, não ao núcleo do domínio (varia por jurisdição/regime)."
			visibility:  "published"
			fields: [
				{kind: "value-object-ref", name: "invoiceId", valueObjectRef:                "vo-invoice-id"},
				{kind: "value-object-ref", name: "fiscalCancellationRef", valueObjectRef:    "vo-fiscal-cancellation-ref"},
				{kind: "primitive", name:        "reasonCode", type:                         "string"},
				{kind: "primitive", name:        "eventTimestamp", type:                     "datetime"},
			]
		},
	]

	// =============================================
	// COMMANDS (2)
	// =============================================

	commands: [
		{
			code:        "cmd-issue-invoice"
			name:        "Issue Invoice"
			description: "Emite InvoiceIssued + ReceivableMaterialized atomicamente quando DeliveryVerified consumed (status=approved) + commitmentTerms projection consistente (canIssueInvoice predicate). Função pura: amount = f(commitmentTerms, verificationOutcome=approved). Replay-safe via identity (commitmentRef, evidenceRef)."
			rationale:   "Comando canônico da issuance INV. Atomic dual emit é responsabilidade da infraestrutura (transactional outbox pattern OR equivalente — fora do escopo do domínio); domínio declara contract de atomicidade via inv-atomic-dual-emission. Triggered por pol-delivery-verified-handler (event-handler reativo, não orchestration)."
			fields: [
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef:    "vo-commitment-ref"},
				{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:      "vo-evidence-ref"},
				{kind: "value-object-ref", name: "regimeVersion", valueObjectRef:    "vo-regime-version"},
			]
		},
		{
			code:        "cmd-cancel-invoice"
			name:        "Cancel Invoice"
			description: "Cancela Invoice existente APENAS dentro de janela fiscal regulada (canCancelInvoice predicate: Invoice.status == issued ∧ now - Invoice.issuedAt ≤ cancellationWindow(regimeVersion)). Emit InvoiceCancelled como fact-record explícito. Fora-da-janela: command rejeitado, escalation supervisedDecision para DRC/ATO."
			rationale:   "G3 cancellation explicit-event-only + BD5 within-window-only. cancellationWindow é função pura externa ao domínio (regime parameter lookup); domínio usa, não define. reasonCode aceito como string — validação semântica do valor é policy/regime layer."
			fields: [
				{kind: "value-object-ref", name: "invoiceId", valueObjectRef:                "vo-invoice-id"},
				{kind: "value-object-ref", name: "fiscalCancellationRef", valueObjectRef:    "vo-fiscal-cancellation-ref"},
				{kind: "primitive", name:        "reasonCode", type:                         "string"},
			]
		},
	]

	// =============================================
	// INVARIANTS (8) — formal logic per founder pattern
	// =============================================

	invariants: [
		{
			code: "inv-atomic-dual-emission"
			name: "Atomic Dual Emission"
			rule: """
				∀ invoiceId:
				  exists Invoice(invoiceId)
				    ⇔ exists Receivable(invoiceId)
				∧ Invoice.amount == Receivable.amount
				∧ Invoice.currency == Receivable.currency
				"""
			rationale: "BD7 atomic-dual-emission. Garantia estrutural de indivisibilidade lógica: Invoice e Receivable existem como par OR não existem; amounts e currencies sempre coincidentes por construção (mesma fonte computacional). Mecanismo de garantia é responsabilidade da infraestrutura (fora do escopo do domínio)."
		},
		{
			code: "inv-idempotent-issuance"
			name: "Idempotent Issuance"
			rule: """
				∀ (commitmentRef, evidenceRef):
				  count(Invoice where
				    Invoice.commitmentRef == commitmentRef
				    ∧ Invoice.evidenceRef == evidenceRef
				  ) ≤ 1
				"""
			rationale: "BD3 issuance-idempotent. Identity (commitmentRef, evidenceRef) define unicidade canônica do fato no domínio — múltiplas observações da tupla (replay, partição, multi-log) são repetição da MESMA realidade, não criação de nova invoice. Identity NÃO inclui criteriaVersion nem regimeVersion (são attributes, não componentes de unicidade); identity independe de tempo/ordem/tentativas."
		},
		{
			code: "inv-regime-immutability"
			name: "Regime Immutability"
			rule: """
				∀ invoiceId:
				  Invoice.regimeVersion is immutable post-creation
				∧ Invoice.amount is immutable post-creation
				∧ Invoice.currency is immutable post-creation
				"""
			rationale: "BD2 deterministic-fiscal-projection. Invoice emitida sob regimeVersion-N permanece reproduzível para audit indefinidamente. Regime change retroativa NÃO regenera invoices históricas; aplica somente a verifications futuras."
		},
		{
			code: "inv-lifecycle-states"
			name: "Lifecycle States"
			rule: """
				∀ invoiceId:
				  Invoice.status ∈ {issued, cancelled}
				∧ no transition exists to any other state
				"""
			rationale: "BD5 lifecycle 2 estados. Estados de domínio Invoice ∈ {issued, cancelled}. Não há draft, partial, pending, ou amended no domínio — draft é integration concern (transiente em adapter NF-e Phase 1+, fora do boundary canônico INV)."
		},
		{
			code: "inv-cancellation-boundary"
			name: "Cancellation Boundary"
			rule: """
				∀ invoiceId:
				  Invoice.status == cancelled
				    ⇒ Invoice was previously issued
				∧ Invoice.status == cancelled
				    ⇒ no further mutation allowed on Invoice fields
				"""
			rationale: "BD5 + G3. Estrutural: cancelled invoice DEVE ter sido issued antes (não há criação direta em cancelled state); pós-cancel, Invoice fields são imutáveis. Cancellation dentro de janela fiscal é gate operacional separado (canCancelInvoice predicate)."
		},
		{
			code: "inv-fiscal-doc-ref-integrity"
			name: "Fiscal Document Reference Integrity"
			rule: """
				∀ invoiceId:
				  exists Invoice(invoiceId)
				    ⇒ Invoice.fiscalDocRef is non-empty
				∧ Invoice.fiscalDocRef is immutable post-creation
				"""
			rationale: "cc-04 audit trail regulatory-grade. fiscalDocRef é ponte canônica para documento fiscal autoritativo externo — non-empty obrigatório (Invoice sem fiscal-doc-ref quebra audit trail regulatório); imutabilidade absoluta pós-association garante audit reproducibility e satisfaz retention legal regulatória (≥5 anos NF-e)."
		},
		{
			code: "inv-cancellation-event-required"
			name: "Cancellation Event Required (no soft-delete)"
			rule: """
				∀ invoiceId:
				  Invoice.status == cancelled
				    ⇒ exists InvoiceCancelled(invoiceId)
				∧ Invoice record persists post-cancellation (no deletion of entity)
				"""
			rationale: "G3 cancellation sempre evento explícito + Invoice entity persistence. Sem soft-delete em Invoice entity: cancelled invoice permanece no event log com status=cancelled + paired InvoiceCancelled event. Downstream BCs reconstroem lifecycle completo via event log canônico."
		},
		{
			code: "inv-receivable-referential-integrity"
			name: "Receivable Referential Integrity"
			rule: """
				∀ receivableId:
				  exists Receivable(receivableId)
				    ⇒ exists Invoice(Receivable.invoiceId)
				"""
			rationale: "Receivable não existe órfã — toda Receivable deve referenciar Invoice válida. Distinto de inv-atomic-dual-emission (que cobre amount/currency consistency entre par): este invariant cobre integridade referencial pura. Receivable é entity interna do InvoiceAggregate; relação parent-child via invoiceId."
		},
	]

	// =============================================
	// VALUE OBJECTS (6) — catálogo top-level
	// =============================================

	valueObjects: [
		{
			code:        "vo-invoice-id"
			name:        "Invoice ID"
			description: "Identificador único de Invoice na rede Mesh. Atributo do Invoice, NÃO componente de identity canônica (que é tupla (commitmentRef, evidenceRef) per inv-idempotent-issuance)."
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			rationale: "Required como atributo não-identity para downstream consumers (FCE/SCF/ATO referenciarem invoice específica em logs/reconciliation), distinto da identity canônica de unicidade."
		},
		{
			code:        "vo-receivable-id"
			name:        "Receivable ID"
			description: "Identificador único de Receivable. Atributo da Receivable entity para referenciamento downstream (SCF) sem expor fiscal concerns (regimeVersion, fiscalDocRef)."
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			rationale: "Receivable expõe identity próprio para SCF originar produtos sobre receivable específico sem precisar referenciar invoice fields fiscais."
		},
		{
			code:        "vo-commitment-ref"
			name:        "Commitment Reference"
			description: "Referência opaca a Commitment formalizado em CMT. INV não interpreta estrutura interna do commitment — apenas usa como identifier canônico cross-BC para identidade de Invoice + Receivable."
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			rationale: "Boundary preservation: INV consome commitmentRef como opaco (CMT é authority canônica); idempotency-identity tupla (commitmentRef, evidenceRef) garante unicidade Invoice."
		},
		{
			code:        "vo-evidence-ref"
			name:        "Evidence Reference"
			description: "Referência opaca a Evidence registrada em DLV. INV não interpreta estrutura interna — apenas usa como identifier canônico cross-BC. Componente de identity Invoice (parte da tupla idempotency)."
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			rationale: "Boundary preservation: INV consome evidenceRef como opaco (DLV é authority canônica de evidence lifecycle). Nova evidenceRef (post-supersession) gera nova invoice via tupla distinta — bd-no-supersession-reaction."
		},
		{
			code:        "vo-money"
			name:        "Money"
			description: "Par estruturado (amount, currency) representando valor monetário canônico. Usado em Invoice + Receivable para garantir conservação amount entre par (inv-atomic-dual-emission)."
			fields: [
				{kind: "primitive", name: "amount", type:   "decimal"},
				{kind: "primitive", name: "currency", type: "string"},
			]
			rationale: "Encapsular amount + currency como par estrutural impede divergência silenciosa entre os dois (currency mismatch + amount match seria erro mascarado). VO compartilhado entre Invoice e Receivable garante mesma fonte computacional."

			// adr-151 Forma B (Peça 3b): elo ao primitivo compartilhado canônico.
			// Money puro (amount+currency) — aponta #Money + term-money como lar
			// canônico (P0: ponteiro, não cópia; os fields locais permanecem).
			shared:             true
			canonicalSchemaRef: "#Money"
			canonicalTermRef:   "term-money"
		},
		{
			code:        "vo-regime-version"
			name:        "Regime Version"
			description: "Identificador imutável de versão das regras fiscais externas (CFOP, alíquotas, retenções jurisdicionais) aplicadas no momento da issuance. Atributo do Invoice declarando QUAL versão de regime estava vigente; INV consome o identifier resolvido externamente, NÃO o resolve nem o interpreta."
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			rationale: "BD2 deterministic-fiscal-projection. RegimeVersion é IDENTIFIER, não logic — protege contra config-virando-lógica (anti-mini-ATO). Bump de version aplica-se a invoices geradas após sua ativação upstream, NUNCA a invoices históricas (inv-regime-immutability)."
		},
		{
			code:        "vo-fiscal-doc-ref"
			name:        "Fiscal Document Reference"
			description: "Referência canônica para identificador de documento fiscal externo (e.g., NF-e number + chave de acesso no regime brasileiro; equivalentes em outros regimes jurisdicionais). Liga o Invoice INV ao documento fiscal autoritativo na jurisdição correspondente. É reference (ponte semântica), NÃO integração."
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			rationale: "cc-04 audit trail regulatory-grade. INV declara o identifier; emissão técnica do documento na autoridade fiscal é responsabilidade de adapter externo (Phase 1+ forward-ref, fora do boundary INV). Uma vez associado a uma invoice, nunca é alterado nem substituído (inv-fiscal-doc-ref-integrity)."
		},
		{
			code:        "vo-fiscal-cancellation-ref"
			name:        "Fiscal Cancellation Reference"
			description: "Referência canônica para identificador de documento fiscal de cancelamento externo (e.g., evento de cancelamento NF-e SEFAZ). Liga o InvoiceCancelled à autoridade fiscal correspondente. Imutável pós-emit do InvoiceCancelled."
			fields: [
				{kind: "primitive", name: "value", type: "string"},
			]
			rationale: "Paralelo a vo-fiscal-doc-ref para evento de cancelamento. Reference (não integração) — emissão técnica do documento de cancelamento na autoridade fiscal é adapter externo Phase 1+."
		},
	]

	// =============================================
	// AGGREGATES (1) — InvoiceAggregate (Part 2)
	// =============================================
	// PART 1 (este commit): catalogs only — aggregate skeleton em
	// Part 2. Schema #DomainModel exige aggregates non-empty;
	// placeholder mínimo será substituído por implementação completa.

	aggregates: [{
		code:        "agg-invoice"
		name:        "Invoice Aggregate"
		description: "Aggregate root canônico do domínio INV: Invoice como root com Receivable como entity interna. BD7 atomic-dual-emission implica MESMA unidade de verdade no momento de criação — separar aggregates transformaria garantia em coordenação. 8 invariants protegidos cobrem identidade canônica, atomicidade, imutabilidade fiscal, lifecycle bounded, integridade referencial."
		rootIdentity: {
			field: "invoiceId"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-invoice-id"
			}
		}
		fields: [
			{kind: "value-object-ref", name: "commitmentRef", valueObjectRef: "vo-commitment-ref"},
			{kind: "value-object-ref", name: "evidenceRef", valueObjectRef:   "vo-evidence-ref"},
			{kind: "value-object-ref", name: "amount", valueObjectRef:        "vo-money"},
			{kind: "value-object-ref", name: "regimeVersion", valueObjectRef: "vo-regime-version"},
			{kind: "value-object-ref", name: "fiscalDocRef", valueObjectRef:  "vo-fiscal-doc-ref"},
			{kind: "primitive", name:        "issuedAt", type:                "datetime"},
			{kind: "primitive", name:        "status", type:                  "string"},
		]
		handlesCommands: ["cmd-issue-invoice", "cmd-cancel-invoice"]
		emitsEvents: [
			"evt-invoice-issued",
			"evt-receivable-materialized",
			"evt-invoice-cancelled",
		]
		protectsInvariants: [
			"inv-atomic-dual-emission",
			"inv-idempotent-issuance",
			"inv-regime-immutability",
			"inv-lifecycle-states",
			"inv-cancellation-boundary",
			"inv-fiscal-doc-ref-integrity",
			"inv-cancellation-event-required",
			"inv-receivable-referential-integrity",
		]
		entities: [{
			code:        "ent-receivable"
			name:        "Receivable"
			description: "Entity interna do InvoiceAggregate representando direito creditório passível de transferência. Materializado atomicamente com Invoice (BD7); identity própria (receivableId) para referenciamento downstream (SCF) sem expor fiscal concerns. SEM lifecycle próprio — Receivable é fact-record imutável criado junto com Invoice; não muta independentemente."
			identity: {
				field: "receivableId"
				type: {
					kind:           "value-object-ref"
					valueObjectRef: "vo-receivable-id"
				}
			}
			fields: [
				{kind: "value-object-ref", name: "invoiceId", valueObjectRef:     "vo-invoice-id"},
				{kind: "value-object-ref", name: "commitmentRef", valueObjectRef: "vo-commitment-ref"},
				{kind: "value-object-ref", name: "amount", valueObjectRef:        "vo-money"},
				{kind: "primitive", name:        "createdAt", type:               "datetime"},
			]
			usesValueObjects: [
				"vo-receivable-id",
				"vo-invoice-id",
				"vo-commitment-ref",
				"vo-money",
			]
			rationale: "Receivable é entity interna (não aggregate separado) porque BD7 atomic-dual-emission implica vida-junta com Invoice — separação criaria 2 aggregates cuja consistência exigiria coordenação cross-aggregate, transformando garantia estrutural em distributed transaction. Entity interna preserva: (a) atomic creation (par com Invoice via mesma transação); (b) referential integrity (inv-receivable-referential-integrity); (c) identity própria (receivableId) para downstream SCF sem acoplamento a Invoice fiscal fields. SEM status/lifecycle próprio — Receivable não muta independentemente; herda visibilidade de Invoice (Invoice cancelled implica Receivable não-acionável via consumo SCF post-cancel — concern downstream)."
		}]
		usesValueObjects: [
			"vo-invoice-id",
			"vo-receivable-id",
			"vo-commitment-ref",
			"vo-evidence-ref",
			"vo-money",
			"vo-regime-version",
			"vo-fiscal-doc-ref",
			"vo-fiscal-cancellation-ref",
		]
		lifecycle: {
			initialState: "issued"
			states: ["issued", "cancelled"]
			transitions: [{
				from:               "issued"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-invoice"
				emitsEvents: ["evt-invoice-cancelled"]
				guards: ["inv-cancellation-boundary"]
			}]
		}
		rationale: "InvoiceAggregate fechado em 2 estados: lifecycle mínimo + final. Estado inicial 'issued' implica que Invoice nasce com cmd-issue-invoice (estado pre-issued NÃO existe — issuance é atomic creation, não preparation/draft). Única transição é issued → cancelled triggered por cmd-cancel-invoice; não há transição para 'paid' (FCE concern), 'reversed' (DRC concern), ou 'amended' (não existe per BD5). Receivable como entity interna SEM lifecycle próprio reforça single-source-of-truth: nenhum estado existe fora do aggregate boundary."
	}]

	projections: [{
		code:        "prj-invoice-by-identity"
		name:        "Invoice By Identity"
		description: "Mapping (commitmentRef, evidenceRef) → invoiceId. Read-only projeção determinística sobre evt-invoice-issued events. Suporta verificação de idempotência (BD3 issuance-idempotent) — query 'existe Invoice para esta tupla?' antes de emit. Pode estar stale (eventually-consistent com event log) MAS é DERIVADA, nunca AUTORITATIVA: identity canonical permanece em Invoice entity/aggregate; projection é otimização de read."
		consumesEvents: [
			"evt-invoice-issued",
		]
		queryCapabilities: [{
			code:        "qry-invoice-by-identity"
			description: "Retorna invoiceId para tupla (commitmentRef, evidenceRef) específica, OR not-found se nenhuma Invoice ainda emitida."
			rationale:   "Suporta BD3 idempotent issuance: cmd-issue-invoice consulta projection antes de emit; se tupla já existe, command é no-op (replay-safe). Query é read-only sobre projection; identity canonical decision permanece em aggregate (projection é cache derivado, não fonte)."
		}]
		rationale: "Projection é derivada exclusivamente de evt-invoice-issued events (próprio domain-model events). Não consome eventos externos cross-BC (pattern paralelo DLV — projections consomem somente domain events internos). Pode estar stale durante replay/recovery sem violar invariantes (idempotency check via projection é Phase 1+ otimização; Phase 0 caminho sync alternativo: aggregate state lookup direct). Read-only por design; mutação de estado canonical permanece em aggregate via cmd-issue-invoice."
	}]

	rationale: """
		Domain Model INV materializa formal compilation do glossary:
		18 termos canônicos do glossary mapeiam para 3 events + 2
		commands + 8 invariants + 8 valueObjects + 1 aggregate (com 1
		entity interna + lifecycle 2 estados) + 1 projection. Compilação
		é determinística (não design livre) — cada construto domain-
		model existe como consequência direta de termo glossary +
		invariant declarado em BDs do canvas.

		**Aggregate único como single source of truth**:
		InvoiceAggregate (root: Invoice; entity interna: Receivable)
		reflete BD7 atomic-dual-emission — Invoice + Receivable são
		MESMA unidade de verdade. Separar em 2 aggregates transformaria
		garantia estrutural em distributed coordination (anti-pattern).
		Receivable SEM lifecycle/status próprio: herda visibilidade do
		Invoice; é fact-record imutável criado atomicamente; não há
		estado fora do aggregate boundary (founder check 1 satisfied).

		**Lifecycle mínimo fechado** (founder check 2 satisfied):
		Invoice.status ∈ {issued, cancelled}. Sem pending/processing/
		paid/reversed (esses são FCE/ATO/DRC territory). Única
		transition: issued → cancelled triggered por cmd-cancel-invoice
		com guard inv-cancellation-boundary. State machine é
		closed-by-construction — schema enforce.

		**Projection derivada nunca autoritativa** (founder check 3
		satisfied): prj-invoice-by-identity consome SOMENTE eventos
		internos do domain-model (evt-invoice-issued); pode estar stale
		MAS é cache otimização, não source-of-truth. Identity canonical
		permanece em aggregate via cmd-issue-invoice; projection serve
		idempotency check Phase 1+. Cache externa de CMT terms
		(commitment-terms-cache mencionada em canvas BD4) NÃO está
		modelada como projection do domain-model — é infra/adapter
		Phase 1+, não conceito do domínio INV.

		**Sem policy cross-BC** (founder check 4 satisfied): consumo
		de eventos externos (evt-delivery-verified de DLV; eventos CMT)
		é responsabilidade canvas/agent layer (event-consumer entries
		em communication; agent-spec Phase 4). Pattern paralelo DLV —
		policies em domain-model triggers SOMENTE em eventos internos
		(no orchestration cross-BC; no decisão contextual; no estado
		próprio). pol-delivery-verified-handler hipotético seria
		canvas inbound consumer + agent reaction, NÃO policy do domain.

		**Boundary preservation transversal** (anti-mini-NIM/FCE/SCF/
		ATO + anti-orchestrator):
		- reasonCode: string (não enum no type) — taxonomia em
		  policy/regime/adapter, não domain core (anti-mini-ATO)
		- cancellationWindow: função pura externa — domínio usa, não
		  define (anti-orchestrator + anti-procedural-leakage)
		- Receivable como entity interna sem autonomia — anti-mini-SCF
		  (transferibilidade decidida por SCF, não INV)
		- Lifecycle 2 estados fechado — anti-mini-FCE (paid não existe)
		- Projection derivada não autoritativa — anti-runtime-coupling

		**Disambiguação temporal explícita** (preventiva contra drift,
		regra normativa do domínio):
		- Invoice.issuedAt = tempo SEMÂNTICO do domínio (quando invoice
		  nasceu canonicamente). Usado em regras de domínio (e.g.,
		  cancellation window calculation: now - Invoice.issuedAt).
		- evt-X.eventTimestamp = tempo TÉCNICO do registro (quando
		  event entrou no log).
		- **REGRA NORMATIVA**: qualquer invariant ou predicate que
		  referencie eventTimestamp é INVÁLIDO por definição do
		  domínio. Decisões temporais usam Invoice.issuedAt (entity)
		  ou regimeVersion (vo-regime-version). Mistura silenciosa
		  entre os dois timestamps gera comportamento divergente
		  difícil de detectar — proibida por construção semântica.

		**Properties formalmente verificáveis** (cue vet enforces):
		- Determinismo: invariants em forma lógica formal (∀, ⇔, ∧, ⇒)
		- Idempotency: identity (commitmentRef, evidenceRef) tupla única
		- Atomicity: BD7 dual-emission via primitive infra (declarado
		  como contract, não mecanismo)
		- Replayability: events append-only; lifecycle states fechados;
		  identity sem version components
		- Imutabilidade: regime/amount/currency/fiscalDocRef immutable
		  post-creation; cancelled state preserva entity record
		- Auditability: cc-04 fiscal-grade trail via fiscalDocRef
		  non-empty + immutable + lineage Invoice ↔ Receivable ↔
		  InvoiceCancelled

		**Phase 0 limitations honest**:
		- Cancellation window logic depende de cancellationWindow(
		  regimeVersion) função externa — Phase 0 lookup tabela
		  declarativa simples; Phase 1+ multi-jurisdictional adapter
		  per oq-inv-4 canvas
		- Projection prj-invoice-by-identity é Phase 1+ optimization;
		  Phase 0 caminho idempotency check sync via aggregate state
		  lookup direct é alternativa válida
		- Cross-BC event consumption (evt-delivery-verified DLV;
		  eventos CMT) é canvas/agent territory; NÃO modelado em
		  domain-model (paralelo DLV pattern)
		- 4 forward-refs declarados (Phase 4 agent-spec; Phase 5
		  envelope; Phase 1+ adapter SEFAZ; Phase 1+ multi-juris
		  regime adapter)

		Domain Model é COMPILAÇÃO do glossary, não design livre —
		qualquer regra futura que NÃO encaixa neste modelo NÃO
		pertence ao INV. Boundary fechado por construção formal.
		"""
}
