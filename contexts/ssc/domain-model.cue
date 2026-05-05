package ssc

// domain-model.cue — Domain Model do BC Strategic Sourcing & Category.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Materializado via authoring manual section-by-section per
// manualAuthoringProtocol (adr-057). Cascade ordering per adr-053/
// adr-054 dec 13: PG existe; canvas SSC + glossary SSC estabelecidos
// (Phases 1+2 do WI-060).
//
// 1 aggregate central: agg-sourcing-process (consistency boundary do
// processo RFQ + decisão emitida atomicamente). rootIdentity = rfqId
// (RFQ existe desde t=0, mesmo se cancelada antes de decisão).
// 1 entity nested: ent-quotation (cotação submetida com lifecycle
// submitted → withdrawn).
//
// 8 commands cobrindo lifecycle real de RFQ: open → receive (multiple
// quotation submissions/withdrawals) → conclude (3 tipos) | cancel.
// Mais 1 command interno (revalidate) triggered por policy.
//
// Behavior-first ordering aplicado: events identificados primeiro do
// canvas (3 published spine + 3 published RFQ lifecycle + 1 internal
// ACL); commands derivados de canvas inbound + intenção interna +
// lifecycle granular per refactor pós-founder review; invariants
// protegidos derivados dos 7 businessDecisions; value-objects
// emergentes dos payloads + glossary terms.
//
// Multi-supplier first-class: events carregam selectedSuppliers/
// preferredSuppliers/awardedSuppliers como SupplierRefList (single-
// supplier é caso típico mas estrutura é lista) + vo-allocation-policy
// para split semantics. Materializa decisão Q1 do canvas SSC.
//
// Lenses aplicadas:
// - lens-organizational-resource-allocation (primária): aggregate
//   modela alocação de oportunidade (RFQ é mecanismo competitivo;
//   decisão é alocação canônica)
// - lens-incentive-alignment (secundária): invariants e fitness
//   rules como config externa governada protegem contra manipulação
// - lens-event-driven-architecture-patterns (secundária): 6 events
//   published + 1 internal ACL; 3 projections como read models
// - lens-information-economics (terciária): decisionRationale rico
//   captura asymmetry resolution para downstream consumers
//
// Glossary alignment: 19 terms canônicos do glossary (Phase 2)
// reconciliados com events/commands/aggregates/value-objects/entities.
//
// Convenção List (paralelo a IDC domain-model): campos com kind
// "domain-type" cujo type termina em "List" denotam coleção do tipo
// correspondente removido o sufixo (ex.: SupplierRefList = coleção
// de SupplierRef; QuotationRefList = coleção de QuotationRef;
// EvaluatedSupplierList = coleção de EvaluatedSupplier; TradeoffList
// = coleção de Tradeoff; CriterionList = coleção de strings-criterion).
// Workaround para #DomainField não suportar kind "array" hoje. Quando
// schema ganhar array kind, migrar em commit dedicado.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code:              "ssc"
	name:              "Strategic Sourcing & Category Domain Model"
	boundedContextRef: "ssc"

	// =============================================
	// EVENTS (catalog top-level)
	// =============================================

	events: [{
		code:        "evt-sourcing-decision-made"
		name:        "SourcingDecisionMade"
		visibility:  "published"
		description: "Decisão de Sourcing one-shot emitida — fornecedor(es) selecionado(s) para escopo específico. Hard binding para P2P emitir pedido. Carrega decisionRationale rico + allocationPolicy (single-supplier ou split multi-supplier)."
		rationale:   "Event publisher canvas.communication.outbound[]. P2P consume com binding hard (override = supervised). Pós-NIM bootstrap (oq-ssc-2), NIM consume como input para intelligence learning loop sem evento dedicado. Multi-supplier first-class: selectedSuppliers é lista (single-supplier é variação de payload, não event type — per Q1 ciclo 5)."
		fields: [{
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
		}, {
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "selectedSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef (≥1; tipicamente 1; multi-supplier suportado)."
		}, {
			kind:           "value-object-ref"
			name:           "allocationPolicy"
			valueObjectRef: "vo-allocation-policy"
			description:    "Política de allocation (single ou split)."
		}, {
			kind:           "value-object-ref"
			name:           "decisionRationale"
			valueObjectRef: "vo-decision-rationale"
		}, {
			kind:           "value-object-ref"
			name:           "fitnessRuleSnapshot"
			valueObjectRef: "vo-fitness-rule-snapshot"
		}, {
			kind: "primitive"
			name: "decidedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "decidedBy"
			type: "string"
		}]
	}, {
		code:        "evt-preferred-supplier-designated"
		name:        "PreferredSupplierDesignated"
		visibility:  "published"
		description: "Designação de Fornecedor(es) Preferido(s) ativada para categoria com prazo de validade. Soft binding em P2P. Multi-supplier: preferredSuppliers é lista."
		rationale:   "Event publisher canvas outbound. P2P consume como cache de policy. Expiração por validUntil é passiva (sem evt-preferred-expired Phase 0). Multi-supplier first-class per Q1."
		fields: [{
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
		}, {
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "preferredSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef preferidos para a categoria."
		}, {
			kind:           "value-object-ref"
			name:           "allocationPolicy"
			valueObjectRef: "vo-allocation-policy"
		}, {
			kind:           "value-object-ref"
			name:           "decisionRationale"
			valueObjectRef: "vo-decision-rationale"
		}, {
			kind:           "value-object-ref"
			name:           "fitnessRuleSnapshot"
			valueObjectRef: "vo-fitness-rule-snapshot"
		}, {
			kind:           "value-object-ref"
			name:           "validityPeriod"
			valueObjectRef: "vo-validity-period"
		}, {
			kind: "primitive"
			name: "designatedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "designatedBy"
			type: "string"
		}]
	}, {
		code:        "evt-strategic-award-completed"
		name:        "StrategicAwardCompleted"
		visibility:  "published"
		description: "Strategic Award concluído pós-RFQ formal — gatilho para formalização contratual em CTR. CTR consumer obrigatório; P2P advisory. Multi-supplier: awardedSuppliers é lista."
		rationale:   "Event publisher canvas outbound. CTR consume como input governado (não vinculante); P2P consume como advisory cache. Cache stale pós-cancelamento CTR é openQuestion oq-ssc-5."
		fields: [{
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
		}, {
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "awardedSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef premiados para formalização contratual."
		}, {
			kind:           "value-object-ref"
			name:           "allocationPolicy"
			valueObjectRef: "vo-allocation-policy"
		}, {
			kind:           "value-object-ref"
			name:           "decisionRationale"
			valueObjectRef: "vo-decision-rationale"
		}, {
			kind:           "value-object-ref"
			name:           "fitnessRuleSnapshot"
			valueObjectRef: "vo-fitness-rule-snapshot"
		}, {
			kind:           "value-object-ref"
			name:           "expectedContractScope"
			valueObjectRef: "vo-expected-contract-scope"
		}, {
			kind: "primitive"
			name: "awardedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "awardedBy"
			type: "string"
		}]
	}, {
		code:        "evt-rfq-opened"
		name:        "RFQOpened"
		visibility:  "published"
		description: "RFQ aberta — fornecedores qualificados convidados são notificados (NTF/OBS subscription transversal). Carrega categoria, escopo, janela e pool, e tipo declarado upfront."
		rationale:   "Trio canônico de RFQ lifecycle per bd-rfq-lifecycle-public-minimal. decisionType declarado upfront sustenta inv-decision-type-declared-upfront."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-rfq-scope"
		}, {
			kind:           "value-object-ref"
			name:           "decisionType"
			valueObjectRef: "vo-decision-type"
			description:    "Tipo declarado upfront (one-shot/preferred/strategic)."
		}, {
			kind: "primitive"
			name: "openedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "quotationDeadline"
			type: "datetime"
		}, {
			kind:        "domain-type"
			name:        "invitedSuppliers"
			type:        "SupplierRefList"
			description: "Refs a NPM participants qualificados (snapshot pool no momento da abertura)."
		}]
	}, {
		code:        "evt-rfq-concluded"
		name:        "RFQConcluded"
		visibility:  "published"
		description: "RFQ concluída — decisão emitida (vencedores + não-vencedores notificados via NTF transversal)."
		rationale:   "Conclusão pareada com abertura. Decisão autônoma do agente. Conclusão é evento causal de decisão emitida — sem julgamento envolvido."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
		}, {
			kind: "primitive"
			name: "concludedAt"
			type: "datetime"
		}]
	}, {
		code:        "evt-rfq-cancelled"
		name:        "RFQCancelled"
		visibility:  "published"
		description: "RFQ cancelada antes de decisão — anula compromisso com fornecedores convidados. supervisedDecision (cancel-rfq)."
		rationale:   "Cancelamento é supervisedDecision per bd-rfq-lifecycle-public-minimal. Notifica fornecedores convidados via NTF transversal com justificativa."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind: "primitive"
			name: "cancelledAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "cancelledBy"
			type: "string"
		}, {
			kind:        "primitive"
			name:        "reason"
			type:        "string"
			description: "Justificativa documentada — obrigatória."
		}]
	}, {
		code:          "evt-network-participant-status-changed-received"
		name:          "NetworkParticipantStatusChangedReceived"
		visibility:    "internal"
		sourceContext: "npm"
		description:   "Tradução ACL de NetworkParticipantStatusChanged (NPM). Trigger para revalidação de fornecedores em RFQs ativas."
		rationale:     "Event interno traduzido de sinal externo de NPM (npm-to-ssc, hybrid). Domain model permanece puro — linguagem local. Trigger para pol-revalidate-on-status-changed. Sufixo -received segue convenção ACL estabelecida em CMT/BDG."
		fields: [{
			kind:           "value-object-ref"
			name:           "supplierRef"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind:        "primitive"
			name:        "newEligibility"
			type:        "string"
			description: "eligible-for-sourcing | provisionally-qualified | suspended | revoked."
		}, {
			kind: "primitive"
			name: "changedAt"
			type: "datetime"
		}]
	}]

	// =============================================
	// COMMANDS (intenções de mudança de estado)
	// =============================================

	commands: [{
		code:        "cmd-open-rfq"
		name:        "OpenRFQ"
		description: "Abrir RFQ para uma categoria com escopo definido e tipo declarado upfront (one-shot / preferred-designation / strategic-award). Sync. Resultado: agg-sourcing-process criado + evt-rfq-opened emitido + fornecedores qualificados convidados via NTF transversal."
		rationale:   "Entry point que materializa term-rfq-opened do glossary. Tipo declarado pelo category manager pré-RFQ per bd-decision-type-is-declared-upfront — sustenta inv-decision-type-declared-upfront via requestedAt timestamp + decisionType field. Pool de fornecedores qualificados construído por svc-supplier-pool-builder consultando NPM. Aggregate creation: cmd-open-rfq creates agg-sourcing-process directly in initialState=open and emits evt-rfq-opened; therefore it is not represented as a transition from a prior lifecycle state — schema #Lifecycle não suporta create transition (from: ∅), criação implícita via initialState."
		fields: [{
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-rfq-scope"
		}, {
			kind:           "value-object-ref"
			name:           "decisionType"
			valueObjectRef: "vo-decision-type"
			description:    "Tipo declarado upfront — determina qual command de conclusão é válido downstream."
		}, {
			kind: "primitive"
			name: "quotationDeadline"
			type: "datetime"
		}, {
			kind:           "value-object-ref"
			name:           "validityPeriod"
			valueObjectRef: "vo-validity-period"
			description:    "Opcional — apenas para decisionType=preferred-designation."
		}, {
			kind:           "value-object-ref"
			name:           "expectedContractScope"
			valueObjectRef: "vo-expected-contract-scope"
			description:    "Opcional — apenas para decisionType=strategic-award."
		}, {
			kind: "primitive"
			name: "requestedBy"
			type: "string"
		}, {
			kind:        "primitive"
			name:        "requestedAt"
			type:        "datetime"
			description: "Timestamp do request — sustenta inv-decision-type-declared-upfront audit (requestedAt < rfqOpenedAt)."
		}]
	}, {
		code:        "cmd-submit-quotation"
		name:        "SubmitQuotation"
		description: "Fornecedor qualificado submete cotação para uma RFQ aberta. Mutação de state intra-open (não muda lifecycle status). Resultado: ent-quotation criada com status=submitted."
		rationale:   "Operação de fornecedor durante janela de cotação. Cotação é fato auditável intra-BC mas NÃO event público Phase 0 (cotações vivem como state interno do aggregate; audit via ent-quotation lifecycle + decisionRationale.evaluatedSuppliers). Multi-quotation per supplier não suportada Phase 0 (1 fornecedor → 1 quotation; re-submission requer withdraw + submit)."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "supplierRef"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind: "primitive"
			name: "unitPrice"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "currency"
			type: "string"
		}, {
			kind: "primitive"
			name: "declaredCapacity"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "termsNotes"
			type: "string"
		}]
	}, {
		code:        "cmd-withdraw-quotation"
		name:        "WithdrawQuotation"
		description: "Fornecedor retira cotação previamente submetida (antes da decisão). Mutação de state intra-open. Resultado: ent-quotation status muda submitted → withdrawn (não deleta — preserva audit trail)."
		rationale:   "Withdrawal opera marcando status, não removendo. Preserva audit trail de quem cotou e retirou. Cotações withdrawn não entram em decisionRationale.evaluatedSuppliers da decisão final."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "quotationId"
			valueObjectRef: "vo-quotation-id"
		}, {
			kind:           "value-object-ref"
			name:           "supplierRef"
			valueObjectRef: "vo-supplier-ref"
			description:    "Supplier que retira (deve match supplier original)."
		}]
	}, {
		code:        "cmd-make-one-shot-sourcing-decision"
		name:        "MakeOneShotSourcingDecision"
		description: "Concluir RFQ de tipo one-shot com decisão emitida. Sync. Precondição: rfq.decisionType=one-shot. Resultado: agg-sourcing-process status open→concluded + evt-rfq-concluded + evt-sourcing-decision-made (com selectedSuppliers + allocationPolicy + decisionRationale + fitnessRuleSnapshot)."
		rationale:   "Command de conclusão para tipo one-shot. Aplica fitness rules sobre signals via svc-fitness-rule-evaluator; produz decisão atômica com hard binding em P2P. Tipo da RFQ deve match tipo do command (per inv-decision-type-declared-upfront)."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind: "primitive"
			name: "decidedBy"
			type: "string"
		}]
	}, {
		code:        "cmd-designate-preferred-supplier"
		name:        "DesignatePreferredSupplier"
		description: "Concluir RFQ de tipo preferred-designation com designação ativada. Sync. Precondição: rfq.decisionType=preferred-designation; rfq carrega validityPeriod. Resultado: open→concluded + evt-rfq-concluded + evt-preferred-supplier-designated."
		rationale:   "Command de conclusão para tipo preferred. Soft binding em P2P (autonomous-with-audit). validityPeriod foi declarado em cmd-open-rfq — propagado para event."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind: "primitive"
			name: "designatedBy"
			type: "string"
		}]
	}, {
		code:        "cmd-complete-strategic-award"
		name:        "CompleteStrategicAward"
		description: "Concluir RFQ de tipo strategic-award com award emitido. Sync. Precondição: rfq.decisionType=strategic-award; rfq carrega expectedContractScope. Resultado: open→concluded + evt-rfq-concluded + evt-strategic-award-completed."
		rationale:   "Command de conclusão para tipo strategic. CTR consumer obrigatório (formalização contratual); P2P advisory. expectedContractScope foi declarado em cmd-open-rfq — propagado para event."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind: "primitive"
			name: "awardedBy"
			type: "string"
		}]
	}, {
		code:        "cmd-cancel-rfq"
		name:        "CancelRFQ"
		description: "Cancelar RFQ aberta antes de decisão — anula compromisso com fornecedores convidados. supervisedDecision per bd-rfq-lifecycle-public-minimal. Sync. Resultado: open→cancelled + evt-rfq-cancelled."
		rationale:   "Cancelamento exige aprovação humana (custo reputacional para fornecedores convidados). Entry justificada por escalationCriterion rfq-no-quotations-received OU mudança estratégica OU pool inadequado sem path de exception."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:        "primitive"
			name:        "reason"
			type:        "string"
			description: "Justificativa documentada — obrigatória."
		}, {
			kind: "primitive"
			name: "cancelledBy"
			type: "string"
		}]
	}, {
		code:        "cmd-revalidate-rfq-pool"
		name:        "RevalidateRFQPool"
		description: "Reavaliar pool de fornecedores qualificados de uma RFQ ativa quando NetworkParticipantStatusChangedReceived afeta participante convidado. Async — triggered por pol-revalidate-on-status-changed. Mutação intra-state."
		rationale:   "Command interno disparado por policy. Não está em canvas inbound. Consequência: fornecedor rebaixado removido do pool; se pool resultante < 2 (ou critério de competitive pool), escalation insufficient-qualified-pool dispara."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "affectedSupplier"
			valueObjectRef: "vo-supplier-ref"
		}]
	}]

	// =============================================
	// INVARIANTS (regras protegidas)
	// =============================================

	invariants: [{
		code:      "inv-decision-from-structured-signals"
		name:      "Decisão Determinística sobre Signals Estruturados"
		rule:      "Toda decisão emitida (SourcingDecisionMade / PreferredSupplierDesignated / StrategicAwardCompleted) é resultado da aplicação de fitness rules versionadas (vo-fitness-rule-snapshot) sobre fitnessSignals estruturados. SSC NÃO interpreta signals nem infere reputation/performance — consome o que outros BCs (NPM, NIM, CTR) produzem e estrutura o que vem da RFQ."
		rationale: "Invariante RECTOR de SSC per bd-deterministic-decision-from-structured-signals. P10 (gates determinísticos validam, agentes recomendam). Anti-mini-NIM: sem este invariant, agente vira intérprete de signals — viola integridade do gate. Cross-BC state dependency (tq-dm-17 heuristic): protective enforcement consulta NPM eligibility via QueryParticipantStatus (cross-BC sync) — fornecedor não-eligible em decision time bloqueia emissão. Estrutura formal de dependsOnAggregateState fica como evolução futura quando schema absorver pattern. Materializa term-fitness-signals + term-fitness-rules + term-decision-rationale do glossary."
	}, {
		code:      "inv-decision-type-declared-upfront"
		name:      "Tipo de Decisão Declarado Upfront"
		rule:      "Para todo evento de decisão emitido, deve existir um requestedDecisionType declarado em cmd-open-rfq (requestedAt < rfqOpenedAt). O tipo do evento emitido (SourcingDecisionMade / PreferredSupplierDesignated / StrategicAwardCompleted) deve corresponder ao tipo declarado no aggregate. Mapeamento canônico: one-shot → SourcingDecisionMade; preferred-designation → PreferredSupplierDesignated; strategic-award → StrategicAwardCompleted. Comando de conclusão deve match tipo da RFQ — cmd-make-one-shot-sourcing-decision rejeita RFQ não-one-shot, etc."
		rationale: "Invariante de comportamento do agente SSC (não classifica retroativamente) per bd-decision-type-is-declared-upfront. Testável via audit trail (timing + correspondence). Evita autonomy creep — agente aplica regras, não decide tipo de processo. Aggregate carrega decisionType desde abertura (campo do agg-sourcing-process); commands de conclusão validam consistency."
	}, {
		code:      "inv-qualification-as-precondition"
		name:      "Qualificação NPM como Precondição Absoluta"
		rule:      "Nenhum fornecedor entra em RFQ sem status eligible-for-sourcing em NPM (consultado via QueryParticipantStatus). Validação obrigatória em 2 momentos críticos: RFQ open (qualificação inicial do pool) e decision time (re-validation antes de emitir decisão). Fornecedor rebaixado entre os pontos é excluído automaticamente."
		rationale: "Materializa bd-qualification-as-absolute-precondition. SSC NÃO revalida compliance (KYC/AML é responsabilidade NPM); apenas consume status binário. Re-validation no decision time é design response a janela de risco. Cross-BC state dependency (tq-dm-17): NPM aggregate state via QueryParticipantStatus em 2 momentos críticos. Fornecedor pode ser rebaixado em NPM durante RFQ ativa — re-validation detecta. Materializa term-fornecedor-qualificado do glossary."
	}, {
		code:      "inv-decision-rationale-required"
		name:      "DecisionRationale Obrigatório"
		rule:      "Toda decisão emitida (3 tipos) carrega decisionRationale completo: criteria aplicados, weights vigentes da categoria, evaluatedSuppliers (todos os cotantes válidos com score por critério), tradeoffs articulados (justificativa de escolha vs alternativa específica). decisionRationale vazio ou parcial bloqueia emissão. Quotations com status=withdrawn NÃO entram em evaluatedSuppliers."
		rationale: "Materializa moat de inteligência da Mesh per subdomain SSC. DecisionRationale é o output canônico estruturado — sustenta auditoria de processo competitivo (Lei 12.846) + reconciliação spend + consumo NIM futuro (oq-ssc-2). Materializa term-decision-rationale do glossary."
	}, {
		code:      "inv-rfq-public-lifecycle-events"
		name:      "Lifecycle Público de RFQ via 3 Events"
		rule:      "Toda RFQ que percorre fluxo normal (open → decisão emitida) deve emitir RFQOpened seguido de RFQConcluded. Toda RFQ cancelada antes de decisão deve emitir RFQOpened seguido de RFQCancelled. Não há saída do lifecycle sem evento público correspondente."
		rationale: "Materializa bd-rfq-lifecycle-public-minimal. Notificação a fornecedores convidados (NTF transversal) + observabilidade (OBS) dependem destes events. Avaliação interna (cotações, equalização) permanece intra-SSC — confidencialidade competitiva preservada."
	}, {
		code:      "inv-competitive-pool-or-supervised-exception"
		name:      "Pool Competitivo ou Exceção Supervisionada"
		rule:      "Decisão emitida AUTOMATICAMENTE exige pool ≥ 2 fornecedores qualificados no decision time. Pool < 2 (incluindo cenário sole-source genuíno: item proprietário, fornecedor único qualificado, urgência operacional) exige supervisedDecision approve-decision-with-insufficient-pool com justificativa documentada — sem bloqueio absoluto, apenas escalation para gate humano."
		rationale: "Materializa premissa de seleção competitiva sem rigidez universal. Pool < 2 quebra premissa core de RFQ no caso default, mas sole-source é caso real e legítimo em algumas categorias — exige decisão humana com justificativa, não bloqueio. Sustenta as-ssc-1 (pool qualificado viável). Cross-BC state dependency (tq-dm-17): pool size derivado de NPM eligible-for-sourcing population. Sem visibility de NPM state, regra não tem base de comparação. Re-validation pre-decision detecta drift do pool durante RFQ. Materializa escalationCriterion insufficient-qualified-pool do canvas."
	}, {
		code:      "inv-fitness-rules-versioned-config"
		name:      "Fitness Rules Versionadas em Config Externa"
		rule:      "Fitness rules vivem em configuração externa governada (não no agent code) com versionamento. Cada decisão emitida carrega fitnessRuleSnapshot (versionId + content) imutável referenciando as regras vigentes no momento da decisão. Configuração e atualização são supervisedDecision (configure-fitness-rules) — não pertencem ao escopo aplicador do agente."
		rationale: "Materializa bd-deterministic-decision-from-structured-signals consequence. Sem snapshot versionado, audit não consegue reconstituir como decisão foi tomada (drift de regras invalida histórico). Shape e infraestrutura de configuração é openQuestion oq-ssc-8."
	}]

	// =============================================
	// AGGREGATES (stub — completado em Parte 3)
	// =============================================

	aggregates: [{
		code:        "agg-sourcing-process"
		name:        "SourcingProcess"
		description: "Stub minimal — completado em Parte 3 (aggregate + entity + lifecycle)."
		rootIdentity: {
			field: "rfqId"
			type: {
				kind: "primitive"
				type: "string"
			}
		}
		handlesCommands: [
			"cmd-open-rfq",
			"cmd-submit-quotation",
			"cmd-withdraw-quotation",
			"cmd-make-one-shot-sourcing-decision",
			"cmd-designate-preferred-supplier",
			"cmd-complete-strategic-award",
			"cmd-cancel-rfq",
			"cmd-revalidate-rfq-pool",
		]
		emitsEvents: [
			"evt-sourcing-decision-made",
			"evt-preferred-supplier-designated",
			"evt-strategic-award-completed",
			"evt-rfq-opened",
			"evt-rfq-concluded",
			"evt-rfq-cancelled",
			"evt-network-participant-status-changed-received",
		]
		protectsInvariants: [
			"inv-decision-from-structured-signals",
			"inv-decision-type-declared-upfront",
			"inv-qualification-as-precondition",
			"inv-decision-rationale-required",
			"inv-rfq-public-lifecycle-events",
			"inv-competitive-pool-or-supervised-exception",
			"inv-fitness-rules-versioned-config",
		]
		rationale: "Stub para satisfazer #DomainModel.aggregates min-1. rootIdentity primitive temporário (substituído por vo-rfq-id em Parte 3 quando VOs forem catalogados). handlesCommands + emitsEvents + protectsInvariants pré-populados em listas completas porque commands/events/invariants catalogs estão fechados — satisfação tq-dm-01/02/03 exige cada artefato com aggregate de origem. Restante (VOs, entity, lifecycle, fields, descrição completa) em Parte 3."
	}]

	rationale: "Domain model SSC scaffold (Parte 1 de 5): events catalog completo (7 events: 3 spine de decisão + 3 lifecycle de RFQ + 1 internal ACL de NPM); stubs mínimos de command/invariant/aggregate satisfazem schema min-1 e serão substituídos nas Partes 2-3. Outer rationale completo finalizado em Parte 4."
}
