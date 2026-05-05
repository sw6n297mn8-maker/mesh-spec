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
		rationale: "Invariante RECTOR de SSC per bd-deterministic-decision-from-structured-signals. P10 (gates determinísticos validam, agentes recomendam). Anti-mini-NIM: sem este invariant, agente vira intérprete de signals — viola integridade do gate. Materializa term-fitness-signals + term-fitness-rules + term-decision-rationale do glossary. Cross-BC dependency declarada em dependsOnAggregateState per adr-055."
		dependsOnAggregateState: {
			boundedContextRef: "npm"
			aggregateRef:      "agg-participant"
			accessVia: {
				kind:               "sync-query"
				canvasQuerySurface: "QueryParticipantStatus"
			}
			rationale: "NPM eligibility é input crítico de decision time — fornecedor não-eligible bloqueia emissão da decisão. SSC consume status binário via QueryParticipantStatus; NPM é single-owner de qualification (dp-04). Sem visibility de NPM state, RECTOR invariant fica sem base de comparação para enforcement."
		}
	}, {
		code:      "inv-decision-type-declared-upfront"
		name:      "Tipo de Decisão Declarado Upfront"
		rule:      "Para todo evento de decisão emitido, deve existir um requestedDecisionType declarado em cmd-open-rfq (requestedAt < rfqOpenedAt). O tipo do evento emitido (SourcingDecisionMade / PreferredSupplierDesignated / StrategicAwardCompleted) deve corresponder ao tipo declarado no aggregate. Mapeamento canônico: one-shot → SourcingDecisionMade; preferred-designation → PreferredSupplierDesignated; strategic-award → StrategicAwardCompleted. Comando de conclusão deve match tipo da RFQ — cmd-make-one-shot-sourcing-decision rejeita RFQ não-one-shot, etc."
		rationale: "Invariante de comportamento do agente SSC (não classifica retroativamente) per bd-decision-type-is-declared-upfront. Testável via audit trail (timing + correspondence). Evita autonomy creep — agente aplica regras, não decide tipo de processo. Aggregate carrega decisionType desde abertura (campo do agg-sourcing-process); commands de conclusão validam consistency."
	}, {
		code:      "inv-qualification-as-precondition"
		name:      "Qualificação NPM como Precondição Absoluta"
		rule:      "Nenhum fornecedor entra em RFQ sem status eligible-for-sourcing em NPM (consultado via QueryParticipantStatus). Validação obrigatória em 2 momentos críticos: RFQ open (qualificação inicial do pool) e decision time (re-validation antes de emitir decisão). Fornecedor rebaixado entre os pontos é excluído automaticamente."
		rationale: "Materializa bd-qualification-as-absolute-precondition. SSC NÃO revalida compliance (KYC/AML é responsabilidade NPM); apenas consume status binário. Re-validation no decision time é design response a janela de risco. Materializa term-fornecedor-qualificado do glossary. Cross-BC dependency declarada em dependsOnAggregateState per adr-055."
		dependsOnAggregateState: {
			boundedContextRef: "npm"
			aggregateRef:      "agg-participant"
			accessVia: {
				kind:               "sync-query"
				canvasQuerySurface: "QueryParticipantStatus"
			}
			rationale: "NPM single-owner de qualification status (dp-04). SSC consulta em 2 momentos críticos: RFQ open (qualificação inicial do pool via svc-supplier-pool-builder) e decision time (re-validation pre-emit). Janela entre os pontos é mitigada por re-validation no decision time + pol-revalidate-on-status-changed (defesa secundária via NPM event consumption ACL)."
		}
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
		rationale: "Materializa premissa de seleção competitiva sem rigidez universal. Pool < 2 quebra premissa core de RFQ no caso default, mas sole-source é caso real e legítimo em algumas categorias — exige decisão humana com justificativa, não bloqueio. Sustenta as-ssc-1 (pool qualificado viável). Re-validation pre-decision detecta drift do pool durante RFQ. Materializa escalationCriterion insufficient-qualified-pool do canvas. Cross-BC dependency declarada em dependsOnAggregateState per adr-055."
		dependsOnAggregateState: {
			boundedContextRef: "npm"
			aggregateRef:      "agg-participant"
			accessVia: {
				kind:               "sync-query"
				canvasQuerySurface: "QueryParticipantStatus"
			}
			rationale: "Pool size derivado de NPM eligible-for-sourcing population por categoria. NPM single-owner; SSC consume snapshot via QueryParticipantStatus na construção do pool (via svc-supplier-pool-builder) e re-validation pre-decision. Sem visibility de NPM state, regra de pool ≥ 2 (ou exception) não tem base de comparação para enforcement."
		}
	}, {
		code:      "inv-fitness-rules-versioned-config"
		name:      "Fitness Rules Versionadas em Config Externa"
		rule:      "Fitness rules vivem em configuração externa governada (não no agent code) com versionamento. Cada decisão emitida carrega fitnessRuleSnapshot (versionId + content) imutável referenciando as regras vigentes no momento da decisão. Configuração e atualização são supervisedDecision (configure-fitness-rules) — não pertencem ao escopo aplicador do agente."
		rationale: "Materializa bd-deterministic-decision-from-structured-signals consequence. Sem snapshot versionado, audit não consegue reconstituir como decisão foi tomada (drift de regras invalida histórico). Shape e infraestrutura de configuração é openQuestion oq-ssc-8."
	}]

	// =============================================
	// VALUE OBJECTS (catalog top-level)
	// =============================================

	valueObjects: [{
		code:        "vo-sourcing-decision-id"
		name:        "SourcingDecisionId"
		description: "Identidade canônica de uma Decisão de Sourcing emitida. Persistente, imutável, referenciada cross-context (P2P validation; CTR formalização; controllers reconciliação). Distinto de RFQId — sourcingDecisionId só existe quando RFQ é concluída com decisão emitida."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Identidade da decisão emitida. Field opcional do aggregate (populated quando status=concluded). Value object por imutabilidade."
	}, {
		code:        "vo-rfq-id"
		name:        "RFQId"
		description: "Identidade canônica de uma RFQ. Distinta de sourcingDecisionId — RFQ existe desde abertura (status=open) e persiste mesmo se cancelada antes de decisão. É o root identity do agg-sourcing-process."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Root identity do aggregate. RFQ tem identidade própria persistente desde a abertura — sourcingDecisionId só existe quando concluída. Garantia de identidade aggregate-wide independente de outcome (concluded vs cancelled)."
	}, {
		code:        "vo-quotation-id"
		name:        "QuotationId"
		description: "Identidade canônica de uma cotação submetida — root identity de ent-quotation nested em agg-sourcing-process."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Identity de entity nested. Permite withdrawal por reference + audit trail de quem cotou e retirou."
	}, {
		code:        "vo-category-ref"
		name:        "CategoryRef"
		description: "Referência a uma Categoria de Compra (taxonomia configurada externamente). Eixo principal de segmentação operacional do BC — fitness rules + KPIs + drift detection segmentados por categoria."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Materializa term-categoria-de-compra. Configuração externa governada — SSC consome ref, não define taxonomia."
	}, {
		code:        "vo-supplier-ref"
		name:        "SupplierRef"
		description: "Referência a um participante NPM (Fornecedor). Boundary com NPM — SSC consome ref, NPM mantém identidade canônica e qualificação."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Boundary explícita com NPM. Materializa term-fornecedor-qualificado pattern."
	}, {
		code:        "vo-decision-type"
		name:        "DecisionType"
		description: "Tipo declarado upfront de Decisão de Sourcing — determina binding regime em P2P, consumer downstream (CTR para strategic) e qual command de conclusão é válido."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		constraints: [
			"value deve ser um dos: one-shot, preferred-designation, strategic-award",
		]
		rationale: "Materializa bd-decision-type-is-declared-upfront + term-decision-type. Discriminator que sustenta inv-decision-type-declared-upfront (mapping para evento correspondente + validation no command de conclusão)."
	}, {
		code:        "vo-allocation-policy"
		name:        "AllocationPolicy"
		description: "Política de allocation em decisão multi-supplier — declara como fornecedores selecionados dividem volume/responsibility. Single-supplier é caso típico Phase 0 (type=single); split-by-percentage e split-by-criteria são patterns suportados quando categoria justifica."
		fields: [{
			kind:        "primitive"
			name:        "type"
			type:        "string"
			description: "single | split-by-percentage | split-by-criteria"
		}, {
			kind:        "domain-type"
			name:        "splitDetails"
			type:        "AllocationSplitDetails"
			description: "Estrutura de split — para split-by-percentage: {supplierRef → percentage}; para split-by-criteria: descrição estruturada do critério; para single: vazio."
		}]
		constraints: [
			"type deve ser um dos: single, split-by-percentage, split-by-criteria",
		]
		rationale: "Materializa Q1+Q2 do canvas SSC: multi-supplier first-class via lista de selectedSuppliers/preferredSuppliers/awardedSuppliers + allocationPolicy explícita. P2P respeita policy em agregado (não por pedido individual). Phase 0 single é dominante; split é caso real para risk diversification ou capacity matching."
	}, {
		code:        "vo-fitness-signals"
		name:        "FitnessSignals"
		description: "Estrutura de inputs que SSC consome para aplicar fitness rules. Composição Phase 0: requiredPhase0 (NPM eligibility + RFQ context + RFQ responses) + optionalPhase0 (NIM performance/reputation + CTR existingCommitments). SSC NÃO interpreta — aplica regras."
		fields: [{
			kind:        "primitive"
			name:        "eligibleForSourcing"
			type:        "boolean"
			description: "NPM eligibility status."
		}, {
			kind:        "domain-type"
			name:        "qualificationScope"
			type:        "QualificationScope"
			description: "NPM qualification por categoria + restrictions + expirationDate (shape em oq-ssc-6)."
		}, {
			kind:           "value-object-ref"
			name:           "rfqContext"
			valueObjectRef: "vo-rfq-scope"
		}, {
			kind:        "domain-type"
			name:        "rfqResponses"
			type:        "QuotationRefList"
			description: "Lista de quotations submetidas (refs a ent-quotation com status=submitted)."
		}, {
			kind:        "primitive"
			name:        "performanceScore"
			type:        "decimal"
			description: "Optional Phase 0 — populado pós-NIM bootstrap (oq-ssc-1). Null Phase 0."
		}, {
			kind:        "primitive"
			name:        "existingCommitments"
			type:        "integer"
			description: "Optional Phase 0 — populado pós-CTR formalização cross-BC (oq-ssc-7). Null Phase 0."
		}]
		rationale: "Materializa term-fitness-signals do glossary. Anti-mini-NIM: struct externa consumida, não computada. Camadas Phase 0 / pós-bootstrap explícitas."
	}, {
		code:        "vo-fitness-rule-snapshot"
		name:        "FitnessRuleSnapshot"
		description: "Snapshot imutável de fitness rules vigentes no momento da decisão — versionId + content (pesos por critério + thresholds + lógica de equalização TCO). Carregado em cada decision event para audit reproducibility."
		fields: [{
			kind: "primitive"
			name: "versionId"
			type: "string"
		}, {
			kind:        "domain-type"
			name:        "content"
			type:        "FitnessRuleContent"
			description: "Pesos + thresholds + lógica de equalização (shape em oq-ssc-8)."
		}, {
			kind: "primitive"
			name: "appliedAt"
			type: "datetime"
		}]
		rationale: "Sustenta inv-fitness-rules-versioned-config + inv-decision-rationale-required. Sem snapshot versionado, drift de regras invalida histórico de decisões."
	}, {
		code:        "vo-decision-rationale"
		name:        "DecisionRationale"
		description: "Captura estruturada do rationale de uma Decisão de Sourcing — criteria aplicados, weights vigentes, evaluatedSuppliers (todos cotantes válidos com score por critério), tradeoffs articulados."
		fields: [{
			kind: "domain-type"
			name: "criteria"
			type: "CriterionList"
		}, {
			kind: "domain-type"
			name: "weights"
			type: "WeightsByCriterion"
		}, {
			kind:        "domain-type"
			name:        "evaluatedSuppliers"
			type:        "EvaluatedSupplierList"
			description: "Lista de vo-evaluated-supplier."
		}, {
			kind:        "domain-type"
			name:        "tradeoffs"
			type:        "TradeoffList"
			description: "Lista de vo-tradeoff."
		}]
		rationale: "Materializa term-decision-rationale + moat de inteligência. Sustenta inv-decision-rationale-required + auditoria contínua (cap-04 do canvas)."
	}, {
		code:        "vo-evaluated-supplier"
		name:        "EvaluatedSupplier"
		description: "Avaliação per-supplier dentro de uma Decisão de Sourcing — scores por critério + posição final + observações relevantes."
		fields: [{
			kind:           "value-object-ref"
			name:           "supplierRef"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind: "domain-type"
			name: "scoresPerCriterion"
			type: "ScoresByCriterion"
		}, {
			kind: "primitive"
			name: "finalRank"
			type: "integer"
		}, {
			kind:        "primitive"
			name:        "notes"
			type:        "string"
			description: "Observações qualitativas (não-decisórias)."
		}]
		rationale: "Componente de decisionRationale — sustenta auditoria detalhada."
	}, {
		code:        "vo-tradeoff"
		name:        "Tradeoff"
		description: "Justificativa estruturada de escolha vs alternativa específica — articula por que decisão preferiu fornecedor X em detrimento de Y em determinado critério."
		fields: [{
			kind:           "value-object-ref"
			name:           "preferredSupplier"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind:           "value-object-ref"
			name:           "alternativeSupplier"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind: "primitive"
			name: "criterion"
			type: "string"
		}, {
			kind: "primitive"
			name: "rationale"
			type: "string"
		}]
		rationale: "Granularidade de tradeoffs sustenta justificabilidade da decisão."
	}, {
		code:        "vo-rfq-scope"
		name:        "RFQScope"
		description: "Descrição estruturada do escopo de uma RFQ — categoria, descrição do item/serviço, volume estimado, prazo, location relevante."
		fields: [{
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind: "primitive"
			name: "description"
			type: "string"
		}, {
			kind: "primitive"
			name: "estimatedVolume"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "deadline"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "location"
			type: "string"
		}]
		rationale: "Estruturação do escopo é precondição de RFQ válida."
	}, {
		code:        "vo-validity-period"
		name:        "ValidityPeriod"
		description: "Janela temporal de validade — usada principalmente em PreferredSupplierDesignated (preferred designation expira passivamente após validUntil)."
		fields: [{
			kind: "primitive"
			name: "validFrom"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "validUntil"
			type: "datetime"
		}]
		rationale: "Sustenta semantics de preferred designation per glossary."
	}, {
		code:        "vo-expected-contract-scope"
		name:        "ExpectedContractScope"
		description: "Input indicativo (não vinculante) para CTR formalizar contrato pós-StrategicAward — volume comprometido + prazo + condições indicativas. CTR pode divergir com aprovação supervisada."
		fields: [{
			kind: "primitive"
			name: "committedVolume"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "contractTermDuration"
			type: "string"
		}, {
			kind: "primitive"
			name: "indicativeConditions"
			type: "string"
		}]
		rationale: "Sustenta semantics de strategic-award per glossary."
	}]

	// =============================================
	// AGGREGATES (consistency boundaries)
	// =============================================

	aggregates: [{
		code:        "agg-sourcing-process"
		name:        "SourcingProcess"
		description: "Aggregate central de SSC — consistency boundary do processo de sourcing (RFQ + cotações recebidas + decisão emitida atomicamente). RFQ existe desde t=0 (rfqId é root identity); sourcingDecisionId é populated apenas quando RFQ é concluída com decisão. 1 entity nested (ent-quotation) com lifecycle próprio (submitted → withdrawn). Lifecycle do aggregate: open → concluded | cancelled (terminal)."
		rootIdentity: {
			field: "rfqId"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-rfq-id"
			}
		}
		fields: [{
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "decisionType"
			valueObjectRef: "vo-decision-type"
			description:    "Tipo declarado upfront em cmd-open-rfq — sustenta inv-decision-type-declared-upfront."
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-rfq-scope"
		}, {
			kind:        "primitive"
			name:        "status"
			type:        "string"
			description: "open | concluded | cancelled — discriminator do lifecycle."
		}, {
			kind:        "domain-type"
			name:        "invitedSuppliers"
			type:        "SupplierRefList"
			description: "Pool qualificado snapshot na abertura (refs a NPM)."
		}, {
			kind:        "primitive"
			name:        "requestedAt"
			type:        "datetime"
			description: "Timestamp do cmd-open-rfq — sustenta audit (requestedAt < rfqOpenedAt)."
		}, {
			kind: "primitive"
			name: "rfqOpenedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "quotationDeadline"
			type: "datetime"
		}, {
			kind:        "primitive"
			name:        "concludedAt"
			type:        "datetime"
			description: "Presente quando status=concluded."
		}, {
			kind:        "primitive"
			name:        "cancelledAt"
			type:        "datetime"
			description: "Presente quando status=cancelled."
		}, {
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
			description:    "Optional — populated apenas quando status=concluded."
		}, {
			kind:           "value-object-ref"
			name:           "validityPeriod"
			valueObjectRef: "vo-validity-period"
			description:    "Optional — declarado em cmd-open-rfq quando decisionType=preferred-designation."
		}, {
			kind:           "value-object-ref"
			name:           "expectedContractScope"
			valueObjectRef: "vo-expected-contract-scope"
			description:    "Optional — declarado em cmd-open-rfq quando decisionType=strategic-award."
		}, {
			kind:           "value-object-ref"
			name:           "fitnessRuleSnapshot"
			valueObjectRef: "vo-fitness-rule-snapshot"
			description:    "Snapshot vigente no decision time — populated quando status=concluded."
		}, {
			kind:           "value-object-ref"
			name:           "decisionRationale"
			valueObjectRef: "vo-decision-rationale"
			description:    "Output canônico — populated quando status=concluded."
		}, {
			kind:           "value-object-ref"
			name:           "allocationPolicy"
			valueObjectRef: "vo-allocation-policy"
			description:    "Policy de allocation — populated quando status=concluded."
		}, {
			kind:        "domain-type"
			name:        "selectedSuppliers"
			type:        "SupplierRefList"
			description: "Selected/preferred/awarded supplier refs depending on decisionType — populated quando status=concluded; semântica neutra entre os 3 tipos de decisão."
		}]

		entities: [{
			code:        "ent-quotation"
			name:        "Quotation"
			description: "Cotação submetida por fornecedor durante janela de RFQ. Owned exclusivamente por agg-sourcing-process — não existe fora de uma RFQ. Lifecycle: submitted → withdrawn (terminal). Withdrawal opera marcando status, não deletando — preserva audit trail."
			identity: {
				field: "quotationId"
				type: {
					kind:           "value-object-ref"
					valueObjectRef: "vo-quotation-id"
				}
			}
			fields: [{
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
			}, {
				kind:        "primitive"
				name:        "status"
				type:        "string"
				description: "submitted | withdrawn"
			}, {
				kind: "primitive"
				name: "submittedAt"
				type: "datetime"
			}, {
				kind:        "primitive"
				name:        "withdrawnAt"
				type:        "datetime"
				description: "Presente quando status=withdrawn."
			}]
			rationale: "Entity (não value object) porque tem identidade própria persistente (quotationId) que sobrevive à mudança de status (submitted → withdrawn) e é referenciada em decisionRationale.evaluatedSuppliers + audit trail de withdrawal. Não é aggregate root separado porque sua existência é derivada da RFQ — sem agg-sourcing-process pai, quotation isolada não tem semântica."
		}]

		lifecycle: {
			initialState: "open"
			states: ["open", "concluded", "cancelled"]
			transitions: [{
				from:               "open"
				to:                 "concluded"
				triggeredByCommand: "cmd-make-one-shot-sourcing-decision"
				emitsEvents: ["evt-rfq-concluded", "evt-sourcing-decision-made"]
				guards: [
					"inv-decision-from-structured-signals",
					"inv-decision-type-declared-upfront",
					"inv-qualification-as-precondition",
					"inv-decision-rationale-required",
					"inv-competitive-pool-or-supervised-exception",
					"inv-fitness-rules-versioned-config",
				]
				description: "Conclusão de RFQ tipo one-shot — emite SourcingDecisionMade com selectedSuppliers + allocationPolicy + decisionRationale + fitnessRuleSnapshot."
			}, {
				from:               "open"
				to:                 "concluded"
				triggeredByCommand: "cmd-designate-preferred-supplier"
				emitsEvents: ["evt-rfq-concluded", "evt-preferred-supplier-designated"]
				guards: [
					"inv-decision-from-structured-signals",
					"inv-decision-type-declared-upfront",
					"inv-qualification-as-precondition",
					"inv-decision-rationale-required",
					"inv-competitive-pool-or-supervised-exception",
					"inv-fitness-rules-versioned-config",
				]
				description: "Conclusão de RFQ tipo preferred-designation — emite PreferredSupplierDesignated com validityPeriod propagado."
			}, {
				from:               "open"
				to:                 "concluded"
				triggeredByCommand: "cmd-complete-strategic-award"
				emitsEvents: ["evt-rfq-concluded", "evt-strategic-award-completed"]
				guards: [
					"inv-decision-from-structured-signals",
					"inv-decision-type-declared-upfront",
					"inv-qualification-as-precondition",
					"inv-decision-rationale-required",
					"inv-competitive-pool-or-supervised-exception",
					"inv-fitness-rules-versioned-config",
				]
				description: "Conclusão de RFQ tipo strategic-award — emite StrategicAwardCompleted com expectedContractScope propagado."
			}, {
				from:               "open"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-rfq"
				emitsEvents: ["evt-rfq-cancelled"]
				description:        "Cancelamento de RFQ antes de decisão — supervisedDecision."
			}]
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

		usesValueObjects: [
			"vo-rfq-id",
			"vo-sourcing-decision-id",
			"vo-quotation-id",
			"vo-category-ref",
			"vo-supplier-ref",
			"vo-decision-type",
			"vo-allocation-policy",
			"vo-fitness-rule-snapshot",
			"vo-decision-rationale",
			"vo-rfq-scope",
			"vo-validity-period",
			"vo-expected-contract-scope",
		]

		rationale: "Single aggregate central com root identity = rfqId (RFQ existe desde abertura, persiste mesmo se cancelada antes de decisão). sourcingDecisionId é optional field populated apenas quando concluded — reflete corretamente que cancelamento não produz decisão. Justificativa estrutural (per tq-dmg-07): persiste registry de RFQs ativas + ent-quotation collection (cotações com lifecycle submitted/withdrawn) + decision rationale gerado, sustentando inv-decision-rationale-required + inv-rfq-public-lifecycle-events. Sem essa estrutura persistente, gate determinístico regrediria a snapshot stateless e auditoria não conseguiria reconstituir como decisão foi tomada. Lifecycle simples (open → concluded | cancelled): receiving/evaluating são micro-states intra-open via mutações com cmd-submit-quotation, cmd-withdraw-quotation, cmd-revalidate-rfq-pool — não materializados como lifecycle states (avaliação interna preserva confidencialidade competitiva). Decisão emitida é state terminal; lifecycle pós-emit (preferred validUntil expira passivamente; strategic await CTR) vive em projections, não como state mutável do aggregate. ent-quotation nested per founder review pos-Q3 (Quotation tem identidade + state mutável → entity, não VO). Aggregate creation: cmd-open-rfq creates agg-sourcing-process directly in initialState=open and emits evt-rfq-opened — schema #Lifecycle não suporta transition from: ∅, criação implícita via initialState; ligação cmd-open-rfq → evt-rfq-opened está endurecida aqui (aggregate emitsEvents inclui evt-rfq-opened; cmd-open-rfq aparece em handlesCommands; correspondência semântica documentada em rationale do command + neste rationale). NetworkParticipantStatusChangedReceived listado em emitsEvents per padrão CMT/BDG/IDC: aggregate registra fato no event stream — ACL adapter produz semanticamente o evento traduzido."
	}]

	// =============================================
	// POLICIES (event → command)
	// =============================================

	policies: [{
		code:             "pol-revalidate-on-status-changed"
		name:             "Revalidação por Mudança de Status NPM"
		description:      "Quando NPM publica NetworkParticipantStatusChanged (traduzido como evt-network-participant-status-changed-received via ACL), emite cmd-revalidate-rfq-pool para cada RFQ ativa que tem o participante afetado no pool de convidados."
		triggeredByEvent: "evt-network-participant-status-changed-received"
		issuesCommand:    "cmd-revalidate-rfq-pool"
		rationale:        "Materializa design response a janela de risco entre RFQ open e decision time. Fornecedor rebaixado durante RFQ ativa precisa ser excluído antes da emissão da decisão. Trigger automático via policy é defesa primária; re-validation explícita no decision time é defesa secundária (per inv-qualification-as-precondition)."
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-active-sourcing-decisions"
		name:        "ActiveSourcingDecisionsProjection"
		description: "Read model que materializa decisões ativas vigentes — one-shot pendentes de execução em P2P, preferred designations vigentes (validUntil futuro), strategic awards aguardando contrato CTR. Consumido por P2P como cache de policies aplicáveis e por controllers para reporting."
		consumesEvents: [
			"evt-sourcing-decision-made",
			"evt-preferred-supplier-designated",
			"evt-strategic-award-completed",
		]
		queryCapabilities: [{
			code:        "qry-active-sourcing-decisions"
			description: "Retorna ActiveSourcingDecisions por categoria — lista de decisões vigentes com tipo + selectedSuppliers + allocationPolicy + validade + scope."
			rationale:   "Canvas query-surface QueryActiveSourcingDecisions. Phase 0 não modela invalidações cross-BC explícitas (cancelamento de contrato CTR não invalida cache automaticamente — oq-ssc-5 deferred); pós-evolução, projection consumirá events de invalidação adicionais."
		}]
		rationale: "Per canvas query-surface QueryActiveSourcingDecisions. Projeção mantém estado vigente sintético derivado de events; otimizada para lookup por categoria. Não consome RFQCancelled (decisão cancelada nunca foi emitida — não entra no projection). Latência alvo per eda-projections: <5s para consumers síncronos. Phase 0 evolução: invalidações cross-BC (CTR cancel post-award per oq-ssc-5) entram como event consumers adicionais quando relação for formalizada."
	}, {
		code:        "prj-sourcing-decision-by-id"
		name:        "SourcingDecisionByIdProjection"
		description: "Read model que materializa decisão de sourcing por sourcingDecisionId — útil para lookup específico (P2P confirmando autoridade de pedido; CTR consultando strategic award para formalização; auditoria reconstituindo decisão histórica)."
		consumesEvents: [
			"evt-sourcing-decision-made",
			"evt-preferred-supplier-designated",
			"evt-strategic-award-completed",
		]
		queryCapabilities: [{
			code:        "qry-sourcing-decision"
			description: "Retorna SourcingDecision (3 tipos) por sourcingDecisionId — payload completo incluindo decisionRationale + fitnessRuleSnapshot + selectedSuppliers + allocationPolicy."
			rationale:   "Canvas query-surface QuerySourcingDecision. Suporta lookup pontual (P2P validation, CTR formalização, audit reconstitution)."
		}]
		rationale: "Per canvas query-surface QuerySourcingDecision. Lookup-by-id complementa lookup-by-category (prj-active-sourcing-decisions). Decisões históricas (one-shot já executadas, preferred expiradas, strategic com contratos cancelados) permanecem queriable para auditoria."
	}, {
		code:        "prj-rfq-history-by-category"
		name:        "RFQHistoryByCategoryProjection"
		description: "Read model interno que mantém histórico agregado por categoria — mediana de preço, variância, distribuição de fornecedores selecionados, frequência de cancelamentos. Signal robusto SSC-mantido (não input do fornecedor manipulável) per as-ssc-2."
		consumesEvents: [
			"evt-sourcing-decision-made",
			"evt-preferred-supplier-designated",
			"evt-strategic-award-completed",
			"evt-rfq-cancelled",
		]
		queryCapabilities: [{
			code:        "qry-rfq-history-by-category"
			description: "Retorna RFQHistoryAggregate por categoria — estatísticas históricas usadas internamente por svc-fitness-rule-evaluator para detecção de cotação fora de range (anti-low-balling design response)."
			rationale:   "Consumer interno (svc-fitness-rule-evaluator) — não exposto via canvas query-surface. Sustenta as-ssc-2 (RFQ history como signal robusto)."
		}]
		rationale: "Sustenta as-ssc-2 (assumption operacional sobre RFQ history estruturável como signal SSC-mantido). Consumido internamente por svc-fitness-rule-evaluator — comparação contra mediana + variância dispara escalation 'suspicious-input' quando cotação está fora de range. Cancelamentos consumidos para detectar padrões anômalos (categoria com taxa alta de cancellation pode indicar scope mal-definido OR pool inadequado)."
	}]

	// =============================================
	// DOMAIN SERVICES (operações sem aggregate apropriado)
	// =============================================

	domainServices: [{
		code:         "svc-fitness-rule-evaluator"
		name:         "FitnessRuleEvaluator"
		description:  "Domain service que aplica fitness rules versionadas sobre fitnessSignals consumidos para produzir output determinístico: decisionRationale + ranking de fornecedores + allocationPolicy recomendada. Inclui equalização TCO específica por categoria. Consultas internas a prj-rfq-history-by-category para detecção estatística de cotação fora de range."
		orchestrates: ["agg-sourcing-process"]
		rationale:    "Operação não pertence a um aggregate específico — opera sobre inputs externos (fitness rules + signals) e produz output DETERMINÍSTICO (rationale + ranking + allocation) consumido pelo agg-sourcing-process. Anti-mini-NIM rigorously enforced: scoresPerCriterion em vo-evaluated-supplier são output direto da aplicação de FÓRMULA DECLARADA em vo-fitness-rule-snapshot.content sobre vo-fitness-signals — sem inferência, sem treinamento, sem aprendizado, sem julgamento. Reaplicação dado mesmos inputs (signals + snapshot) produz MESMO output (determinismo testável via property-based test). Tradeoffs em vo-tradeoff são justificativas estruturadas que articulam diferenças quantitativas entre fornecedores (não opiniões qualitativas do agente). Detection de cotação fora de range via prj-rfq-history-by-category é comparação estatística contra histórico próprio (mediana + variância), não classificação preditiva. Materializa term-fitness-rules + term-equalizacao-tco do glossary preservando boundary com NIM (NIM computa reputation/performance; SSC consome eligibility de NPM via signal e aplica regras)."
	}, {
		code:         "svc-supplier-pool-builder"
		name:         "SupplierPoolBuilder"
		description:  "Domain service que constrói pool qualificado de fornecedores para uma categoria consultando NPM (QueryParticipantStatus) e aplicando filtros de scope (location, capacity range, qualification per category). Output: lista de SupplierRef qualificados que entram em RFQ."
		orchestrates: ["agg-sourcing-process"]
		rationale:    "Operação não pertence a um aggregate (constrói input para o aggregate antes da abertura da RFQ via cmd-open-rfq). Materializa boundary com NPM — SSC consume status, não computa qualificação. Sustenta inv-qualification-as-precondition (gate hard binário aplicado na construção do pool)."
	}]

	rationale: """
		Domain model do BC Strategic Sourcing & Category modela 1
		aggregate central (agg-sourcing-process) com 1 entity nested
		(ent-quotation) cobrindo todo escopo declarado em canvas:
		processo RFQ (open → receive quotations → conclude) + decisão
		emitida atomicamente. Root identity = rfqId (RFQ persiste desde
		abertura mesmo se cancelada); sourcingDecisionId é optional
		field populated apenas quando concluded.

		8 commands granulares cobrindo lifecycle real de RFQ: cmd-open-
		rfq (entry com decisionType declarado upfront — cria
		agg-sourcing-process directly em initialState=open e emite
		evt-rfq-opened, sem transition from prior state porque schema
		#Lifecycle não suporta create transition), cmd-submit-quotation
		+ cmd-withdraw-quotation (mutações intra-open por fornecedores),
		3 commands de conclusão por tipo (1 por decisionType para validar
		correspondência), cmd-cancel-rfq (supervisedDecision), cmd-
		revalidate-rfq-pool (triggered por policy). Cotações têm
		lifecycle próprio (submitted → withdrawn) preservando audit
		trail completo.

		Multi-supplier first-class per Q1 do canvas: events carregam
		selectedSuppliers/preferredSuppliers/awardedSuppliers como
		SupplierRefList + vo-allocation-policy explícita (single |
		split-by-percentage | split-by-criteria). Single-supplier é caso
		típico Phase 0 mas estrutura suporta split (risk diversification,
		capacity matching). Aggregate field selectedSuppliers tem
		descrição neutra ('selected/preferred/awarded supplier refs
		depending on decisionType') — não inclina para nenhum dos 3
		event types.

		Behavior-first ordering aplicado: events emergem do canvas (3
		published spine de decisão + 3 published lifecycle de RFQ + 1
		internal ACL de NPM); commands derivam de canvas inbound + 5
		commands granulares adicionais (open, submit/withdraw quotation,
		cancel, revalidate); invariants protegidos derivados dos 7
		businessDecisions do canvas (1 RECTOR + 6 operacionais);
		value-objects emergentes dos payloads + glossary terms (15 VOs
		incluindo identity refs, decision structures, signals, allocation
		policy, validity, expected contract scope; vo-quotation removido
		por ser entity, não VO).

		Anti-mini-NIM como invariant transversal materializado em:
		(a) inv-decision-from-structured-signals (RECTOR);
		(b) vo-fitness-signals como struct externa consumida (não
		    computada);
		(c) vo-fitness-rule-snapshot versionado em config externa;
		(d) svc-fitness-rule-evaluator aplica fórmula declarada
		    deterministicamente — sem inferência, treinamento ou
		    julgamento (testável via property-based test);
		(e) prj-rfq-history-by-category é signal SSC-mantido (não input
		    de fornecedor manipulável) per as-ssc-2.

		Cross-BC state dependencies (tq-dm-17 + tq-dmg-09 per adr-055):
		3 invariants (inv-decision-from-structured-signals,
		inv-qualification-as-precondition, inv-competitive-pool-or-
		supervised-exception) declaram dependsOnAggregateState first-
		class apontando para NPM agg-participant via canvas query-
		surface QueryParticipantStatus (kind=sync-query, cross-BC).
		Granularidade per-invariant per heuristic do PG. Aggregate
		state interno do agg-sourcing-process + projections são state
		intra-BC — sem cross-aggregate dependencies além do path NPM
		cross-BC.

		Lenses aplicadas:
		- lens-organizational-resource-allocation (primária): aggregate
		  modela alocação de oportunidade de fornecimento entre
		  fornecedores qualificados sob critérios estruturados
		  (decisionRationale + fitnessRuleSnapshot capturam o COMO +
		  POR QUÊ; allocationPolicy modela split semantics).
		- lens-incentive-alignment (secundária): invariants e fitness
		  rules versionadas em config governada protegem mecanismo
		  contra manipulação. inv-decision-from-structured-signals +
		  inv-fitness-rules-versioned-config + inv-decision-rationale-
		  required são triplo de defesa estrutural; prj-rfq-history-by-
		  category é signal robusto para anti-low-balling detection;
		  inv-competitive-pool-or-supervised-exception preserva
		  flexibilidade para sole-source genuíno via gate humano.
		- lens-event-driven-architecture-patterns (secundária): 6 events
		  published com semântica inequívoca (3 decisão + 3 lifecycle);
		  3 projections como read models com SLO de latência; 1 policy
		  choreographs npm-trigger interno; event sourcing implícito do
		  agregado sustenta auditoria contínua (cap-04 do canvas).
		- lens-information-economics (terciária): decisionRationale rico
		  (criteria + weights + evaluatedSuppliers + tradeoffs +
		  allocationPolicy) é asymmetry resolution capturada — consumers
		  downstream recebem signal estruturado em vez de inferir.

		Phase 0 caveats:
		- Quotation submission/withdrawal modelados como commands intra-
		  state (não events públicos) — audit via ent-quotation lifecycle
		  + decisionRationale.evaluatedSuppliers. evt-quotation-submitted/
		  withdrawn não são events Phase 0.
		- Lifecycle pós-emit (preferred validUntil expira passivamente;
		  strategic await CTR contract activation) vive em projections,
		  não como state mutável do aggregate. Cache stale em P2P pós-
		  cancelamento CTR é openQuestion oq-ssc-5.
		- Multi-round RFQ (BAFO) é openQuestion oq-ssc-9 — Phase 0
		  modela apenas single-round (1 cycle de quotation submission).
		- Cross-BC consumers de signals (NIM em fitnessSignals.
		  performanceScore; CTR em fitnessSignals.existingCommitments)
		  permanecem null Phase 0 — formalização cross-BC em oq-ssc-1
		  + oq-ssc-2 + oq-ssc-7.
		- Multi-quotation per supplier não suportada Phase 0 (1
		  fornecedor → 1 quotation; re-submission requer withdraw +
		  submit).

		Glossary alignment: 19 terms canônicos do glossary (Phase 2)
		reconciliados com events/commands/aggregates/value-objects/
		entities. Mapeamentos chave: term-sourcing-decision → vo-
		sourcing-decision-id + decisão concluded em agg-sourcing-process;
		term-decision-type → vo-decision-type discriminator;
		term-fitness-signals → vo-fitness-signals struct;
		term-fitness-rules → vo-fitness-rule-snapshot + svc-fitness-
		rule-evaluator; term-decision-rationale → vo-decision-rationale
		+ inv-decision-rationale-required; term-rfq + 3 lifecycle terms
		→ 3 events RFQOpened/Concluded/Cancelled + agg-sourcing-process
		lifecycle; term-fornecedor-qualificado → vo-supplier-ref +
		svc-supplier-pool-builder + inv-qualification-as-precondition;
		term-fracionamento → consumido por svc-fitness-rule-evaluator
		via prj-rfq-history-by-category. Sem divergências terminológicas
		identificadas. Frase canônica preservada (SSC decide sourcing;
		CTR formaliza contrato; P2P executa compra) via separação
		clara de responsabilidades — agg-sourcing-process não emite
		commands para CTR/P2P (apenas events que outros BCs consomem).
		"""
}
