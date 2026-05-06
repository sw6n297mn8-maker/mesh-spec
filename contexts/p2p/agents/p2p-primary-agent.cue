package p2p

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// p2p-primary-agent.cue — Agent Spec do BC Procure-to-Pay.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Aplicação manual do production-guide architecture/production-guides/
// agent-spec.cue (manualAuthoringProtocol per adr-057). Cascade ordering
// per adr-054 dec 13: PG-A existe; canvas.ownership.domainAgentSpec
// aponta para este path. Manual takeover per founder choice (Phase 4 do
// WI-057 P2P bootstrap, paralelo a SSC + BDG approach pre-WI-069
// subagent dispatch operacional).
//
// Princípio operacional canônico (canonizado em BDG agent-spec
// 2026-05-01 + reforçado em SSC agent-spec): Spec declara CAPACIDADE;
// governance envelope declara AUTONOMIA atual via promotion criteria +
// autonomyOverrides intermediários. Phase 0: 1 mutation propose-and-wait
// (act-emit-purchase-order; promotion possível pós-track-record) + 1
// mutation hard-supervised (act-cancel-purchase-order; sempre humano per
// canvas supervisedDecision cancel-emitted-po + custo cross-BC para
// CMT). "autonomousDecision" no canvas significa "não exige julgamento
// humano (gate determinístico)", NÃO "execução sem governança".
// Promotion para execute-and-log de act-emit-purchase-order é decisão
// do envelope.governance — preserva P10 (gates determinísticos validam,
// agentes recomendam) e habilita rollback automático per
// failureHandling. tq-gv-14 bloqueia override execute-and-log direto.
//
// Boundaries explicitamente preservadas (per canvas businessDecisions
// + 4 founder canvas patches + 4 founder domain-model patches):
// - bd-procurement-requires-sourcing-authority (RECTOR): P2P emite PO
//   APENAS sob authority pré-validada SSC; gate determinístico.
// - bd-purchase-order-as-single-concept-with-authority-ref: PO é
//   conceito ÚNICO (NÃO 3 tipos paralelos); discriminação via
//   authorityType (Q1 canvas multi-supplier first-class).
// - bd-allocation-policy-respected-in-aggregate: allocation respeitada
//   em agregado via prj-allocation-tracking + monitoring obligation
//   (Patch 3 founder domain-model: NÃO enforcement strict Phase 0).
// - bd-cancellation-pre-formalization-only: cancel cobre apenas
//   pre-CMT formalization Phase 0 (oq-p2p-2 deferred pós-CMT).
// - bd-no-supplier-revalidation-by-p2p (anti-mini-NIM): P2P NÃO
//   consulta NPM; P2P NÃO possui supplier pool — apenas purchase
//   authority (Patch 4 founder canvas).
// - bd-purchase-order-lifecycle-public-minimal: 2 events públicos
//   pareados (Emit/Cancel); Cancel é withdrawal/negative signal a
//   CMT pre-formalization (Patch 2 founder canvas).
// - Patch 1 founder domain-model: state requested = "emit attempt
//   recorded" (persiste para audit trail mesmo se validation falhar;
//   audit trail é único registro de attempts failed validation per
//   founder Ajuste 3 Opção A pre-Phase 4 — sem campo dedicado no
//   aggregate, mantendo aggregate clean).
// - Patch 2 founder domain-model: 3 ACL events (-received) emitted/
//   recorded in local event stream, not originated by aggregate
//   decision (paralelo CMT/BDG/IDC/SSC).
// - Patch 3 founder domain-model: inv-allocation-convergence é
//   monitoring obligation (sustained drift report), NÃO enforcement.
// - Patch 4 founder domain-model: lifecycle requested→cancelled
//   transition keep (cleanup de attempt failed validation).
// - Adj 1 founder canvas: escopo Phase 0 = Procure only (NÃO Pay).
// - Adj 3 founder canvas: CTR ContractActivated + QueryContractStatus
//   PHASE 1+ FORWARD-REF (ctr-to-p2p relation NÃO operacional Phase 0).
//
// Anti-mini-NIM como invariant transversal materializado em 5 layers
// herdados do domain-model P2P:
// (a) inv-purchase-order-requires-valid-authority como RECTOR (gate
//     determinístico authority pré-validada);
// (b) inv-no-supplier-revalidation-by-p2p como NEGATIVO (P2P NÃO
//     consulta NPM; sem QueryParticipantStatus em operationalScope);
// (c) inv-allocation-convergence-aggregate-level como monitoring
//     obligation (observable + signal, Patch 3);
// (d) capability rationale + sh-05 designResponse via prj-allocation-
//     tracking aggregate-level;
// (e) escalation routing (insufficient/conflicting/expired/exhausted
//     authority — TODOS supervisedDecision para gate humano).

p2pPrimaryAgent: artifact_schemas.#AgentSpec & {
	code:              "agt-p2p-primary"
	name:              "P2P Primary Agent"
	description:       "Agente operador único do BC Procure-to-Pay. Aplica gate determinístico de authority (consulta prj-active-purchase-authorities cache local + sync fallback QuerySourcingDecision) para emitir PurchaseOrders supplier-specific sob authority pré-validada SSC. Opera lifecycle público mínimo de PO (requested → emitted | cancelled, semântica 'emit attempt recorded' per Patch 1 founder domain-model — state requested persiste para audit trail mesmo se validation falhar; audit trail é único registro de attempts failed validation per Ajuste 3 founder Opção A). Monitora drift de allocation aggregate-level via prj-allocation-tracking (Patch 3 founder: monitoring obligation, NÃO enforcement strict Phase 0; sig-allocation-drift signal feed a SSC para reconsideração de fitness rules). Detecta padrões fragmentation (sh-01) via prj-purchase-history-by-category (Phase 0 detection local; cross-BC coordination com BDG term-fracionamento bidirecional pendente oq-p2p-6). NÃO consulta NPM (anti-mini-NIM via inv-no-supplier-revalidation-by-p2p; P2P NÃO possui supplier pool — apenas purchase authority per Patch 4 founder canvas). NÃO formaliza commitment econômico (CMT) nem decide sourcing (SSC) — boundary preservada via separation of concerns + frase canônica trio (SSC decide sourcing; P2P emite pedido sob authority; CMT formaliza compromisso)."
	boundedContextRef: "p2p"
	role:              "domain-agent"
	governanceRef:     "p2p-primary-agent"

	// =============================================
	// OPERATIONAL SCOPE
	// =============================================

	operationalScope: {
		aggregates: [
			"agg-purchase-order",
		]
		commands: [
			"cmd-emit-purchase-order",
			"cmd-cancel-purchase-order",
		]
		events: [
			"evt-purchase-order-emitted",
			"evt-purchase-order-cancelled",
			"evt-sourcing-decision-made-received",
			"evt-preferred-supplier-designated-received",
			"evt-strategic-award-completed-received",
		]
		invariants: [
			"inv-purchase-order-requires-valid-authority",
			"inv-allocation-convergence-aggregate-level",
			"inv-cancellation-pre-formalization-only",
			"inv-no-supplier-revalidation-by-p2p",
			"inv-purchase-order-lifecycle-public-events",
		]
		projections: [
			"prj-active-purchase-authorities",
			"prj-purchase-orders",
			"prj-allocation-tracking",
			"prj-purchase-history-by-category",
		]
	}

	// =============================================
	// ACTIONS (operações executáveis)
	// =============================================

	actions: [{
		code:        "act-validate-authority"
		name:        "Validate Authority"
		description: "Validar authorityRef reivindicado em cmd-emit-purchase-order via gate determinístico: consulta prj-active-purchase-authorities (cache local derivado de 3 ACL events SSC) por (authorityRef OR categoryRef + supplier); cache hit retorna authorityType + selectedSuppliers/preferredSuppliers/awardedSuppliers + allocationPolicy + validityPeriod (preferred). Cache miss dispara sync fallback QuerySourcingDecision (canvas query-dependency cross-BC SSC). Pré-condição estrutural de act-emit-purchase-order. Outcome boolean: válida (transition requested→emitted permitida) OR inválida (aggregate persiste em requested per Patch 1 semantic 'emit attempt recorded' + escalation insufficient-authority + audit trail registra validation context completo). Anti-mini-NIM: gate é função numérica (sim/não), NÃO julgamento; agente NÃO consulta NPM (boundary explícita)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-purchase-order",
			"inv-purchase-order-requires-valid-authority",
			"inv-no-supplier-revalidation-by-p2p",
			"prj-active-purchase-authorities",
		]
		preconditions: [
			"cmd-emit-purchase-order recebido com claimedAuthorityRef + supplier + categoryRef populated",
			"prj-active-purchase-authorities acessível (cache local) OR SSC acessível via QuerySourcingDecision sync (latência aceitável)",
		]
		postconditions: [
			"Outcome=válida → authorityType resolvido + supplier verified ∈ selectedSuppliers/preferredSuppliers/awardedSuppliers + categoryRef match → next act-validate-emit-request-scope + act-emit-purchase-order",
			"Outcome=inválida → escalation insufficient-authority (cache miss + sync fallback failed) OR conflicting-authority (multi-authority overlap) OR ambiguous-case (multi-supplier cobertura unclear); aggregate persiste em state=requested se já criado; audit trail registra cache hit/miss + sync fallback timestamp + authorityType resolution attempt",
		]
	}, {
		code:        "act-validate-emit-request-scope"
		name:        "Validate Emit Request Scope"
		description: "Validar estruturalmente payload de cmd-emit-purchase-order antes de aggregate creation: presença de campos obrigatórios (categoryRef + supplier + scope com description/estimatedVolume/deadline/location + amount Money + claimedAuthorityRef + requestedBy), formato de Money (currency ISO 4217 + amount ≥ 0), consistência de scope (estimatedVolume positivo + deadline futuro), supplier formato vo-supplier-ref válido. Pré-condição de act-emit-purchase-order. Impact: read-only (validação técnica sobre payload de demanda)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-purchase-order",
			"cmd-emit-purchase-order",
		]
		preconditions: [
			"cmd-emit-purchase-order recebido de originadora com payload estruturado",
		]
		postconditions: [
			"Payload validado → próxima ação act-validate-authority (se ainda não executada) OR act-emit-purchase-order",
			"Payload malformado → escalation suspicious-input (campos obrigatórios ausentes; Money currency inválida; scope incoerente) OR ambiguous-case (categoria multi-aplicável)",
		]
	}, {
		code:        "act-emit-purchase-order"
		name:        "Emit Purchase Order"
		description: "Emitir PurchaseOrder via cmd-emit-purchase-order: cria agg-purchase-order directly em initialState=requested (semântica 'emit attempt recorded' per Patch 1 founder domain-model — persiste para audit trail mesmo se validation falhar) + tenta transition requested→emitted via guards inv-purchase-order-requires-valid-authority + inv-no-supplier-revalidation-by-p2p. Validation success → transition para emitted + evt-purchase-order-emitted publicado para CMT como hard binding operational signal. Validation failure → aggregate persiste em requested (originadora pode submeter cmd-cancel-purchase-order para limpar OR retentar com authorityRef diferente em novo aggregate); audit trail registra validation context completo (cache hit/miss + sync fallback timestamp + authorityType resolution attempt) — sem campo dedicado no aggregate, mantendo aggregate clean. Phase 0 propose-and-wait per BDG canon (mesmo sendo canvas autonomousDecision emit-po-on-valid-authority): human gate aprova emissão; promotion para execute-and-log via envelope.governance.promotionCriteria após track record. Impact: state-change (cria aggregate; transition condicional) + cross-bc (NTF transversal notifica supplier-specific; CMT consume PurchaseOrderEmitted como trigger commitment lifecycle). Decide-vs-execute audit (tq-agg-09): NÃO monolítico — gate é função determinística (authority válida sim/não), não julgamento; outcome é consequência de signals (cache + sync), não decisão julgativa do agente."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-emit-purchase-order",
			"evt-purchase-order-emitted",
			"agg-purchase-order",
			"inv-purchase-order-requires-valid-authority",
			"inv-no-supplier-revalidation-by-p2p",
			"inv-purchase-order-lifecycle-public-events",
			"prj-active-purchase-authorities",
		]
		preconditions: [
			"act-validate-emit-request-scope retornou payload válido",
			"act-validate-authority retornou outcome=válida (authorityRef vigente + supplier ∈ authority + categoryRef match) OR escalation supervised approve-po-without-sourcing-authority autorizada",
			"Aprovação humana registrada em audit trail Phase 0 (autonomyLevel propose-and-wait + canvas autonomousDecision emit-po-on-valid-authority — promotion path Phase 1+ via envelope)",
		]
		postconditions: [
			"agg-purchase-order criado em status=requested + tentativa transition→emitted via guards atomic",
			"Validation success: status=emitted + supplier/categoryRef/scope/amount/authorityRef/authorityType populated + emittedAt + emittedBy registrados + evt-purchase-order-emitted publicado (NTF supplier-specific + CMT consumer hard binding)",
			"Validation failure: status=requested persiste + audit trail registra validation context completo (cache hit/miss + sync fallback timestamp + authorityType resolution attempt) como single source of truth para attempts failed; aggregate aguarda cmd-cancel-purchase-order para cleanup OR retry em novo aggregate",
		]
	}, {
		code:        "act-cancel-purchase-order"
		name:        "Cancel Purchase Order"
		description: "Cancelar PurchaseOrder via cmd-cancel-purchase-order — 2 cenários cobertos por 1 action conforme state corrente do aggregate: (a) state=requested cancela para limpar attempt failed validation persistente (Patch 1 + Patch 4 founder; transition requested→cancelled + evt-purchase-order-cancelled emitido sem supplier field — supplier ausente porque attempt nunca progrediu); (b) state=emitted cancela ANTES de CMT formalizar CommitmentAccepted (transition emitted→cancelled + evt-purchase-order-cancelled emitido como withdrawal/negative signal a CMT — CMT cancela path de formalização sem produzir CommitmentAccepted). Phase 0 cobre apenas pre-CMT formalization (per inv-cancellation-pre-formalization-only); pós-CMT cancellation requer cross-BC coordination cancel-cascade (oq-p2p-2 deferred). SEMPRE supervised per canvas supervisedDecision cancel-emitted-po + custo cross-BC reputacional (CMT path interrupted) — escalationOverride hard-supervised mesmo após governance promotion futura de outras mutations. Impact: state-change + cross-bc (NTF supplier + CMT cancela path)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-cancel-purchase-order",
			"evt-purchase-order-cancelled",
			"agg-purchase-order",
			"inv-cancellation-pre-formalization-only",
			"inv-purchase-order-lifecycle-public-events",
		]
		preconditions: [
			"agg-purchase-order em status=requested OR status=emitted (não pode cancelar status=cancelled — terminal)",
			"Para state=emitted: best-effort heuristic only — agente NÃO verifica CMT formalization status deterministicamente Phase 0 (sem query-dep operacional QueryCommitmentStatus; ctr-to-p2p one-way relation no context-map P2P → CMT); race condition pós-emit é registrada em audit trail como cmt-formalization-status: not-yet-confirmed-at-cancel-time + reconciliação cross-BC futura via oq-p2p-2",
			"Justificativa documentada em vo-cancellation-reason (reasonCode + narrative) — obrigatória",
			"Aprovação humana registrada antes de emit (autonomyLevel propose-and-wait + canvas supervised + escalationOverride hard-supervised)",
		]
		postconditions: [
			"agg-purchase-order status → cancelled + cancelledAt + cancelledBy + cancellationReason populated + evt-purchase-order-cancelled emitido",
			"State=requested→cancelled: evento sem supplier field (attempt nunca progrediu); audit trail registra reasonCode failed-validation-cleanup OR admin-override",
			"State=emitted→cancelled: evento com supplier (PO tinha supplier vinculado); CMT consume como withdrawal/negative signal e cancela path de formalização correspondente; NTF supplier notificado; audit trail registra cmt-formalization-status: not-yet-confirmed-at-cancel-time como best-effort acknowledgment de race condition",
		]
	}, {
		code:        "act-detect-allocation-drift"
		name:        "Detect Allocation Drift"
		description: "Self-monitoring estatístico de drift sustentado entre allocationPolicy upstream SSC e volume real emitido por authorityRef + supplier + categoryRef ao longo de janela ativa (validityPeriod para preferred-designation; janela operacional para one-shot/strategic-award). Materializa inv-allocation-convergence-aggregate-level como monitoring obligation per Patch 3 founder (NÃO enforcement strict Phase 0). Drift sustentado (diferença significativa por janela operacional, threshold via envelope.governance) emite sig-allocation-drift signal a SSC (OBS observability) para reconsideração de fitness rules. POs individuais NÃO bloqueados por drift — agregado é tracked + reportado, não impedido. Vetor adversarial sh-05 (allocation bias) per canvas incentiveAnalysis. Impact: read-only (consumer de prj-allocation-tracking). Anti-mini-NIM: P2P observa convergência, NÃO decide allocation — responsabilidade SSC fitness rules."
		category:        "escalation"
		autonomyLevel:   "collect-and-report"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-purchase-order",
			"prj-allocation-tracking",
			"inv-allocation-convergence-aggregate-level",
		]
		preconditions: [
			"prj-allocation-tracking populated com janela ativa para authorityRef alvo (preferred validityPeriod ativa OR one-shot/strategic ainda em horizonte operacional)",
			"≥N POs emitidas para authorityRef no horizonte de detecção (threshold mínimo via envelope.governance — sem volume mínimo, drift não é estatisticamente meaningful)",
		]
		postconditions: [
			"Drift report estruturado: authorityRef + supplier + categoryRef + observedDistribution (volume real per supplier) vs declaredAllocationPolicy (split-by-percentage upstream SSC) + window + sustainedThresholdEvidence; sig-allocation-drift signal emitido a SSC; nenhum state change em agg-purchase-order",
			"Sem drift sustentado → nenhum signal; monitoring contínuo silencioso",
		]
	}, {
		code:        "act-detect-fragmentation-pattern"
		name:        "Detect Fragmentation Pattern"
		description: "Self-monitoring estatístico de padrões de Fracionamento — múltiplas POs sub-threshold do mesmo proponente (originadora) na mesma categoria em janela curta — que sugerem evasão de gate de aprovação SSC via splitting (vetor adversarial sh-01 per canvas incentiveAnalysis). Defesa estrutural primária depende de coordenação cross-BC com BDG (term-fracionamento bidirecional, oq-p2p-6 análogo a oq-bdg-1 + oq-ssc-fragmentation); Phase 0 P2P sinaliza padrões observáveis no escopo local via prj-purchase-history-by-category (frequência por requester + categoria + janela + threshold gaming evidence). Impact: read-only. Mecanismo SECUNDÁRIO de defesa per canvas escalationCriterion suspicious-pattern: Phase 0 limitação reconhecida — agregação cross-BC pendente."
		category:        "escalation"
		autonomyLevel:   "collect-and-report"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-purchase-order",
			"prj-purchase-history-by-category",
			"evt-purchase-order-emitted",
		]
		preconditions: [
			"prj-purchase-history-by-category populada com janela mínima viável (≥30 dias de POs por categoria — paralelo SSC act-detect-fragmentation-pattern threshold)",
		]
		postconditions: [
			"Anomaly report estruturado (proponente requester + categoria + POs envolvidas + janela + threshold gaming evidence: distribuição de amounts sub-threshold + frequência) + recommendation para revisão humana; nenhum state change",
			"Sem padrão detectado → nenhum signal; monitoring contínuo silencioso",
		]
	}, {
		code:        "act-query-active-purchase-orders"
		name:        "Query Active Purchase Orders"
		description: "Atender query QueryActivePurchaseOrders consumida por controllers (reporting), supervisores (visibility), e CMT (cross-check pré-formalização) + originadora (lookup por requester). Retorna ActivePurchaseOrders (state=emitted) por categoryRef OR supplierRef OR requesterRef — lista com authority + status + emittedAt + cancellation status. POs em state=requested (attempts persistentes failed validation) NÃO entram (filtro state=emitted; visibility de attempts deferida Phase 1+). Impact: read-only (consulta a prj-purchase-orders)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-purchase-orders",
		]
		preconditions: [
			"Filtro fornecido (categoryRef OR supplierRef OR requesterRef)",
		]
		postconditions: [
			"ActivePurchaseOrders retornado (lista filtrada) OR not-found se filtro sem resultados",
		]
	}, {
		code:        "act-query-purchase-order-by-id"
		name:        "Query Purchase Order By Id"
		description: "Atender query QueryPurchaseOrderById consumida por CMT (formalization input — payload completo necessário para Commitment construction), CTR (cross-check para strategic award validation), DRC futuro (dispute context — POs históricas), supervisores e auditoria. Retorna PurchaseOrder completa por purchaseOrderId — payload incluindo authorityRef + authorityType + supplier + scope + amount + audit metadata + cancellation status + reason. POs históricas (cancelled, formalized via CMT) permanecem queriable para auditoria Lei 12.846 (5 anos retention). Impact: read-only (consulta a prj-purchase-orders)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-purchase-orders",
		]
		preconditions: [
			"purchaseOrderId fornecido",
		]
		postconditions: [
			"PurchaseOrder retornado (payload completo) OR not-found se purchaseOrderId desconhecido",
		]
	}]

	// =============================================
	// CONSTRAINTS (regras enforced pelo agente)
	// =============================================
	//
	// Cada constraint declara em rationale: enforcementLevel
	// (agent / runner / domain / external) per tq-agg-05 e
	// derivedFromInvariant per tq-agg-06. Schema não modela esses
	// campos como first-class hoje (heuristic-level).

	constraints: [{
		code:         "cst-authority-validation-mandatory"
		name:         "Authority Validation Mandatory"
		description:  "act-emit-purchase-order NUNCA materializa transition requested→emitted sem authorityRef vigente apontando para SSC decision válida no momento do emit. Authority válida significa: (a) one-shot-decision (SourcingDecisionMade vigente para categoryRef + supplier ∈ selectedSuppliers); OR (b) preferred-designation (PreferredSupplierDesignated com validUntil > emittedAt + supplier ∈ preferredSuppliers + categoryRef match); OR (c) strategic-award (StrategicAwardCompleted vigente + supplier ∈ awardedSuppliers + categoryRef match — Phase 0 advisory binding; Phase 1+ requer ContractActivated CTR para hard binding per oq-p2p-1). Sem authority válida, transition NÃO ocorre — aggregate persiste em state=requested. Override = supervisedDecision approve-po-without-sourcing-authority (escalation para gate humano com justificativa documentada)."
		verification: "Runner verifica que para cada evt-purchase-order-emitted publicado, payload contém: (a) authorityRef não-vazio resolvendo em prj-active-purchase-authorities (cache hit) OR sync query QuerySourcingDecision audit timestamp ≤ emittedAt; (b) authorityType resolvido (one-shot-decision | preferred-designation | strategic-award) coerente com authority encontrada; (c) supplier ∈ selectedSuppliers/preferredSuppliers/awardedSuppliers do authority record; (d) categoryRef match. Audit trail registra cache hit/miss + sync fallback timestamp + authorityType resolution. Decisão sem authority OR mismatch bloqueia emissão (transition não fires; aggregate persiste em requested)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-purchase-order-requires-valid-authority (RECTOR). enforcementLevel: agent (gate determinístico in-line via prj-active-purchase-authorities + sync fallback antes de transition fire) + domain (lifecycle guard no schema #StateTransition do agg-purchase-order valida invariant). bd-procurement-requires-sourcing-authority + P10 (gates determinísticos validam, agentes recomendam). Sem este gate, P2P viraria 'mini-SSC' decidindo sourcing fora de processo competitivo — viola moat de inteligência da Mesh + integridade de boundary. Cross-BC dependency declarada via dependsOnAggregateState first-class apontando para SSC agg-sourcing-process via QuerySourcingDecision sync-query per adr-055."
	}, {
		code:         "cst-no-supplier-revalidation"
		name:         "No Supplier Revalidation By P2P"
		description:  "agt-p2p-primary NUNCA consulta NPM nem revalida supplier eligibility no momento do emit. P2P confia na validação SSC upstream (que validou no decision time via QueryParticipantStatus per inv-qualification-as-precondition SSC). Janela de risco entre SSC decision e P2P emit é mitigada por SSC re-validation no decision time + (Phase 1+) drift signal feedback loop a SSC. Se supplier rebaixado entre SSC decision e P2P emit, supervisor escala (revoke authority + re-issue OR escalate decisão); P2P emit per authority vigente — NÃO pause-gate na ausência de authority revoke explícita. P2P NÃO possui supplier pool — apenas purchase authority (boundary clarification founder Patch 4 canvas)."
		verification: "Runner verifica via static + runtime checks: (a) agent code NÃO contém calls para QueryParticipantStatus (NPM canvas query-surface); (b) operationalScope NÃO inclui projections externas a P2P (sem refs a NPM agg-participant); (c) audit trail de cada action NÃO contém npm-query-id field; (d) canvas P2P queryDeps NÃO inclui QueryParticipantStatus. Boundary check static (compile-time scan) + runtime (audit trail field absence). Constraint violação (qualquer call a NPM detected) bloqueia ação."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-no-supplier-revalidation-by-p2p (NEGATIVO; anti-mini-NIM como invariant transversal Mesh). enforcementLevel: agent (boundary check + ausência em operationalScope) + external (NPM single-owner de qualification per dp-04; SSC consume status binário em decision time). bd-no-supplier-revalidation-by-p2p (Patch 4 founder canvas). Sem este constraint, P2P duplicaria responsabilidade SSC + violaria anti-mini-NIM. Verification por absence é estrutural — boundary preservada via construção (operationalScope + queryDeps), não por checagem dinâmica de comportamento."
	}, {
		code:         "cst-cancellation-pre-formalization-only"
		name:         "Cancellation Pre-Formalization Only"
		description:  "act-cancel-purchase-order opera em janela pre-CMT formalization Phase 0 — sem deterministic check de CMT formalization status (P2P NÃO tem query-dep operacional Phase 0; ctr-to-p2p one-way relation no context-map P2P → CMT). 2 cenários cobertos: (a) state=requested cancela attempt failed validation (cleanup audit trail; reasonCode failed-validation-cleanup OR admin-override); (b) state=emitted cancela ANTES de CMT formalizar (race condition pós-emit antes de CommitmentAccepted; assumed rara Phase 0 mas NÃO detectada deterministicamente — best-effort heuristic). Cancelamento pós-CMT formalization é cross-BC coordination cancel-cascade (oq-p2p-2 deferred Phase 1+). Explicitude > ilusão de controle: agente reconhece limitação Phase 0 e registra incerteza no audit trail."
		verification: "Runner verifica que para cada evt-purchase-order-cancelled emitido, audit trail registra: (a) state corrente do aggregate antes do cancel (requested OR emitted, não cancelled); (b) para state=emitted: heuristic flag cmt-formalization-status: not-yet-confirmed-at-cancel-time (best-effort acknowledgment de race condition — Phase 0 NÃO consulta CMT deterministicamente); (c) approver-id + justification timestamp ≤ cancelledAt (autonomyLevel propose-and-wait + canvas supervised hard gate). Race condition pós-emit (CMT já formalizou commitment quando Cancelled chega) é detectada via reconciliação cross-BC futura (oq-p2p-2); Phase 0 assume janela curta mas NÃO promete detection."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-cancellation-pre-formalization-only. enforcementLevel: agent (state check determinístico atomic; heuristic flag CMT formalization registrado em audit trail como best-effort acknowledgment) + domain (lifecycle guard no schema #StateTransition impede transitions inválidas). bd-cancellation-pre-formalization-only. Phase 0 limitação reconhecida: race condition pós-emit antes de Cancelled chegar (CMT já formalizou) é assumed rara mas NÃO detectada deterministicamente — explicitude > ilusão de controle (agente NÃO promete enforcement que não pode entregar; registra incerteza). Reconciliação via cross-BC coordination cancel-cascade (oq-p2p-2 deferred Phase 1+) cobre detection retroativa."
	}, {
		code:         "cst-po-lifecycle-events-paired"
		name:         "PO Lifecycle Events Paired"
		description:  "Toda agg-purchase-order que percorre fluxo normal (requested → emitted) DEVE emitir PurchaseOrderEmitted atomic com a transition. Toda agg-purchase-order que cancela (requested → cancelled OR emitted → cancelled) DEVE emitir PurchaseOrderCancelled atomic. State requested SEM saída do lifecycle (attempt persistente failed validation per Patch 1 founder) NÃO viola este constraint — lifecycle não 'sai' do state, audit trail captura validation context completo (cache hit/miss + sync fallback timestamp + authorityType resolution attempt) per Ajuste 3 founder Opção A (sem campo dedicado no aggregate)."
		verification: "Runner verifica que para cada agg-purchase-order com status=emitted, event log contém evt-purchase-order-emitted (purchaseOrderId match + emittedAt match). Para status=cancelled, event log contém evt-purchase-order-cancelled (purchaseOrderId match + cancelledAt match). Saída de lifecycle (transition fires) sem event pareado bloqueia transition — atomic emit no lifecycle do aggregate é hard. State=requested persistente sem progressão é audit trail (sem evento emitted nem cancelled) — não conta como saída."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-purchase-order-lifecycle-public-events. enforcementLevel: domain (atomic transition no lifecycle do agg-purchase-order emite event pareado com state change). bd-purchase-order-lifecycle-public-minimal. CMT consume PurchaseOrderEmitted como trigger canônico de commitment lifecycle; PurchaseOrderCancelled como sinal de retirada (withdrawal/negative signal). NTF transversal notifica supplier-specific via PO events. OBS observabilidade rastreia emit/cancel rates."
	}, {
		code:         "cst-allocation-monitoring-mandatory"
		name:         "Allocation Monitoring Mandatory"
		description:  "act-detect-allocation-drift DEVE executar monitoring contínuo de drift sustentado entre allocationPolicy upstream SSC e volume real emitido (per authorityRef + supplier + categoryRef). Drift sustentado emite sig-allocation-drift signal a SSC. POs individuais NÃO bloqueados por drift — agregado é tracked + reportado, não impedido. Patch 3 founder: monitoring obligation, NÃO enforcement strict."
		verification: "Runner verifica que prj-allocation-tracking é populated continuamente para authorities ativas; sustained drift threshold dispara sig-allocation-drift dentro de SLO operacional (envelope.governance threshold). Ausência de monitoring (prj-allocation-tracking stale > SLO OR authorities ativas sem coverage de tracking) emite warn — invariant é monitoring obligation, não enforcement strict; portanto onViolation warn-and-continue, não block-and-escalate."
		onViolation:  "warn-and-continue"
		rationale:    "derivedFromInvariant: inv-allocation-convergence-aggregate-level (Patch 3 founder: monitoring obligation NÃO enforcement). enforcementLevel: agent (monitoring contínuo via projection consumption + drift signal emission). bd-allocation-policy-respected-in-aggregate. Patch 3 founder: 'volume converge' substituído por 'monitor and report sustained drift' porque enforcement strict requer domain-model mechanisms Phase 1+ (oq-p2p-3 + oq-ssc-3 bridge). onViolation warn-and-continue (NÃO block) é deliberado: invariant é observable property, não gate determinístico — bloquear PO individual contraditária a Patch 3 + violar simplicidade do escopo Phase 0."
	}, {
		code:         "cst-supervised-operations-require-human-gate"
		name:         "Supervised Operations Require Human Gate"
		description:  "act-cancel-purchase-order NUNCA materializa state change (cancelled) sem aprovação humana em Phase 0 — escalationOverride hard-supervised mesmo após governance promotion futura de outras mutations. Operations equivalentes (approve-po-without-sourcing-authority + override-allocation-policy) são supervisedDecisions externas ao escopo aplicador do agente — agente apenas escala via escalationCondition out-of-scope; humano materializa decisão via canal próprio (governance envelope)."
		verification: "Runner verifica que para cada evt-purchase-order-cancelled emitido, audit trail contém approval timestamp + approver-id + justification ANTES de emit. autonomyLevel propose-and-wait + canvas supervisedDecision cancel-emitted-po é hard gate. approve-po-without-sourcing-authority + override-allocation-policy NÃO produzem events emitidos pelo agente — são canais paralelos governados via supervisedDecision externa. Bypass attempt (cancel emitido sem approver-id) bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: (operacional, sustenta canvas 3 supervisedDecisions Phase 0). enforcementLevel: agent (autonomyLevel propose-and-wait + escalationOverride hard-supervised declarados no spec). Cancel-emitted-po tem custo cross-BC (CMT path interrupted + supplier relacionamento reputacional); approve-po-without-sourcing-authority quebra premissa RECTOR de authority; override-allocation-policy ajusta gate determinístico em exceção. Todas excedem authority autônoma do agente — operacionalmente irreversíveis ou estrategicamente julgativas exigem human gate Phase 0."
	}]

	// =============================================
	// ESCALATION CONDITIONS (when to halt and escalate)
	// =============================================
	//
	// Default global. Per-action override Phase 0 documentado em
	// rationale de actions críticas:
	// - act-cancel-purchase-order: hard-supervised (sempre gate humano)
	// - act-detect-allocation-drift + act-detect-fragmentation-pattern:
	//   collect-and-report (signal a SSC + report; sem state change)

	escalationConditions: [{
		category:    "conflicting-signals"
		description: "Multi-authority overlap (mesmo supplier+category com 2 authorities ativas com binding regimes diferentes — ex.: preferred-designation vigente + one-shot-decision recente para mesma categoria); cache prj-active-purchase-authorities vs sync fallback QuerySourcingDecision divergem (cache stale OR SSC mais recente); claimedAuthorityRef vs resolved authority discrepancy. Canvas escalationCriterion conflicting-authority."
		rationale:   "Cobertura tq-ag-10 mutations (act-emit-purchase-order). Conflito não resolvível por regra é decisão julgativa — fora do escopo do agente per anti-mini-NIM. Cache invalidation cross-BC pós-cancelamento CTR (oq-ssc-5/oq-p2p-2 compartilhada) também emite signal aqui."
	}, {
		category:    "insufficient-context"
		description: "Cache stale > SLO 5s (prj-active-purchase-authorities desatualizada) E sync fallback QuerySourcingDecision indisponível simultaneamente; cache miss + sync failure (SSC down OR network partition) — agente não consegue resolver authorityRef; canvas escalationCriterion insufficient-authority Phase 0 cache miss + sync failure cenário."
		rationale:   "Cobertura tq-ag-10 mutations + canvas insufficient-authority. Indisponibilidade de SoT crítica (SSC authorities) exige fallback humano ou postergação — falta de visibilidade ≠ outcome rejected automático (rejeição implicaria conclusão definitiva, não falta de context). Anti-mini-NIM: agente NÃO interpreta authority incompleta/stale — reconhece insuficiência e escala."
	}, {
		category:    "out-of-scope"
		description: "Authority válida no momento mas budget/volume consumido (canvas escalationCriterion authority-exhausted — preferred-designation com validUntil ainda futuro mas cumulative volume excedeu allocationPolicy split percentage; one-shot exhausted após single PO; strategic-award com expectedContractScope volume saturado); 3 supervisedDecisions (approve-po-without-sourcing-authority + cancel-emitted-po + override-allocation-policy); operações fora autoridade autônoma do agente."
		rationale:   "Cobertura tq-ag-10 + canvas authority-exhausted (renomeado de pool-exhausted per Patch 4 founder canvas — boundary 'P2P NÃO possui supplier pool — apenas purchase authority' refletida na nomenclatura) + 3 supervisedDecisions. Authority-exhausted é cenário operacional real (volume contratado consumido) que NÃO é falha de validation, é exhaustão legítima — exige re-issue de SSC OR override supervised."
	}, {
		category:    "suspicious-input"
		description: "act-detect-fragmentation-pattern emite anomaly (múltiplas POs sub-threshold do mesmo proponente em janela curta — vetor sh-01 manipulação por originadora); act-detect-allocation-drift emite sustained drift signal (vetor sh-05 allocation bias — distribuição real diverge sustentadamente de allocationPolicy declarada); padrões anômalos cross-PO (renegotiation pressure pós-emit detected via análise de PO immutability vs reissue requests — vetor sh-02). Canvas escalationCriterion suspicious-pattern."
		rationale:   "Vetores adversariais sh-01 (originadora) + sh-02 (fornecedor) + sh-05 (allocation bias) per canvas incentiveAnalysis. Fragmentation + sustained drift + renegotiation patterns são padrões conhecidos. Detecção exige decisão humana sobre consequência: pausa de autonomia para proponente, agregação retroativa, OR ajuste de regra SSC. Coordenação cross-BC com BDG (Fracionamento bidirecional) pendente Phase 0 (oq-p2p-6)."
	}, {
		category:    "ambiguous-case"
		description: "Multi-supplier authority cobertura unclear (claimedAuthorityRef cobre supplier mas allocationPolicy split entre múltiplos sem percentage match para volume requerido — split-by-percentage 60/40 e PO requesta volume incompatível com qualquer percentage); RFQScope match ambiguous (categoryRef inferido vs declarado divergem; supplier qualificado em múltiplas categorias); decisionType strategic-award Phase 0 advisory binding (operações sob authority que vai ter hard binding pós-CTR ContractActivated PHASE 1+ — deve emit como advisory ou aguardar CTR?)."
		rationale:   "Caso intermediário entre processo padrão e supervisedDecision explícita. Ambiguidade exige julgamento humano sobre como interpretar cobertura — fora do escopo aplicador do agente. Strategic-award Phase 0 advisory é openQuestion oq-p2p-1 (CTR contract activation bridge) — durante janela de bridge, decisões sobre emit timing são supervised."
	}, {
		category:    "unclassifiable-anomaly"
		description: "Canvas escalationCriterion regulatory-fiscal-ambiguity (Lei 12.846 procurement zona cinza public-private boundary; fiscal anomaly em cross-border supply; sanção a fornecedor durante PO ativa entre emit e CMT formalization); cross-BC drift inesperado (CMT pre-CMT race condition pós-emit antes Cancelled chegar — oq-p2p-2 não modelado Phase 0; CTR ContractActivated não chega após StrategicAward em janela esperada — oq-p2p-1 timing; SSC strategic-award authority transition advisory→hard timing inconsistency — oq-ssc-5 cache stale)."
		rationale:   "Integridade legal é constraint inviolável (nível 1 do CLAUDE.md). Zona cinza exige julgamento humano especializado — compliance officer ou category manager designado. Cross-BC drift sistêmico exige decisão estrutural sobre evolução do context-map, não correção pontual. oq-p2p-1/2 + oq-ssc-5 são openQuestions deferred Phase 1+."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS (stub — completados em Parte 3)
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Stub minimal — completado em Parte 3 (5 artifacts + estimatedBudget)."
		}]
		estimatedBudget: "heavy"
	}

	// =============================================
	// OBSERVABILITY (stub — completados em Parte 3)
	// =============================================

	observability: {
		signals: [{
			code:           "sig-mutation-executed"
			name:           "Mutation Executed"
			description:    "Stub minimal — completado em Parte 3 (9 signals)."
			coversCategory: "mutation"
			trigger:        "Stub completado em Parte 3"
			level:          "info"
		}]
		auditTrail: {
			requiredFields: [
				"timestamp",
				"agent-id",
				"action-code",
				"input-summary",
				"output-summary",
				"decision-rationale",
				"governance-version",
			]
			storageHint: "Stub minimal — storageHint completado em Parte 3 (Event Log P2P imutável + Lei 12.846 retention)."
			rationale:   "Stub minimal — auditTrail rationale completado em Parte 3 com 14 fields rationale."
		}
	}

	rationale: "Agent spec P2P scaffold (Parte 1 de 4): identity + operationalScope + 8 actions completos; stubs mínimos de constraint/escalation/contextRequirements/observability satisfazem schema min-1 e serão substituídos nas Partes 2-3. Outer rationale completo finalizado em Parte 3."
}
