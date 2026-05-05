package ssc

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// ssc-primary-agent.cue — Agent Spec do BC Strategic Sourcing & Category.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Aplicação manual do production-guide architecture/production-guides/
// agent-spec.cue (manualAuthoringProtocol per adr-057). Cascade ordering
// per adr-054 dec 13: PG existe; canvas.ownership.domainAgentSpec
// aponta para este path. Manual takeover per founder choice (Phase 4
// do WI-060 SSC bootstrap, paralelo a BDG approach).
//
// Princípio operacional canônico (per founder review 2026-05-01,
// canonizado em BDG agent-spec): Spec declara CAPACIDADE; governance
// envelope declara AUTONOMIA atual via promotion criteria +
// autonomyOverrides intermediários. Phase 0: 3 mutation actions
// propose-and-wait + 1 execute-and-log (act-revalidate-rfq-pool —
// escalation path cobre pool<2 sem precisar gate humano global).
// "autonomousDecision" no canvas significa "não exige julgamento
// humano (gate determinístico)", NÃO "execução sem governança".
// Promotion para execute-and-log das 3 mutations propose-and-wait é
// decisão do envelope.governance — preserva P10 (gates determinísticos
// validam, agentes recomendam) e habilita rollback automático per
// failureHandling.
//
// Boundaries explicitamente preservadas (per canvas businessDecisions):
// - bd-deterministic-decision-from-structured-signals (RECTOR): SSC
//   APLICA fitness rules versionadas sobre fitnessSignals; NÃO
//   interpreta nem infere reputation/performance (anti-mini-NIM).
// - bd-decision-type-is-declared-upfront: tipo declarado pré-RFQ via
//   cmd-open-rfq; agente aplica regras, não decide tipo de processo.
// - bd-qualification-as-absolute-precondition: NPM single-owner; SSC
//   re-valida em 2 momentos críticos (RFQ open + decision time).
// - bd-rfq-lifecycle-public-minimal: 3 events públicos pareados;
//   avaliação interna preserva confidencialidade competitiva.
// - bd-procurement-requires-sourcing-authority: P2P só emite pedido sob
//   decisão SSC vigente OU contrato CTR vigente; SSC NÃO formaliza
//   contrato (CTR) nem executa pedido (P2P).
//
// Anti-mini-NIM como invariant transversal materializado em 5 layers
// herdados do domain-model SSC (commit 2757b20):
// (a) inv-decision-from-structured-signals como RECTOR;
// (b) vo-fitness-signals como struct externa consumida (não computada);
// (c) vo-fitness-rule-snapshot versionado em config externa;
// (d) svc-fitness-rule-evaluator aplicação determinística;
// (e) prj-rfq-history-by-category como signal SSC-mantido (não input
//     manipulável de fornecedor) per as-ssc-2.

sscPrimaryAgent: artifact_schemas.#AgentSpec & {
	code:              "agt-ssc-primary"
	name:              "SSC Primary Agent"
	description:       "Agente operador único do BC Strategic Sourcing & Category. Aplica fitness rules versionadas sobre fitnessSignals estruturados para emitir 3 tipos de decisão (one-shot/preferred-designation/strategic-award) conforme tipo declarado upfront em cmd-open-rfq, opera lifecycle público de RFQ (open → concluded | cancelled) emitindo trio canônico (RFQOpened/RFQConcluded/RFQCancelled), captura decisionRationale rico em vo-decision-rationale, e re-valida qualificação NPM em 2 momentos críticos (RFQ open + decision time) via QueryParticipantStatus. NÃO computa reputation/performance (anti-mini-NIM): consome signals externos e estrutura RFQ-internal. NÃO formaliza contrato (CTR) nem executa pedido (P2P) — boundary preservada via separation of concerns."
	boundedContextRef: "ssc"
	role:              "domain-agent"
	governanceRef:     "ssc-primary-agent"

	// =============================================
	// OPERATIONAL SCOPE
	// =============================================

	operationalScope: {
		aggregates: [
			"agg-sourcing-process",
		]
		commands: [
			"cmd-open-rfq",
			"cmd-submit-quotation",
			"cmd-withdraw-quotation",
			"cmd-make-one-shot-sourcing-decision",
			"cmd-designate-preferred-supplier",
			"cmd-complete-strategic-award",
			"cmd-cancel-rfq",
			"cmd-revalidate-rfq-pool",
		]
		events: [
			"evt-sourcing-decision-made",
			"evt-preferred-supplier-designated",
			"evt-strategic-award-completed",
			"evt-rfq-opened",
			"evt-rfq-concluded",
			"evt-rfq-cancelled",
			"evt-network-participant-status-changed-received",
		]
		invariants: [
			"inv-decision-from-structured-signals",
			"inv-decision-type-declared-upfront",
			"inv-qualification-as-precondition",
			"inv-decision-rationale-required",
			"inv-rfq-public-lifecycle-events",
			"inv-competitive-pool-or-supervised-exception",
			"inv-fitness-rules-versioned-config",
		]
		projections: [
			"prj-active-sourcing-decisions",
			"prj-sourcing-decision-by-id",
			"prj-rfq-history-by-category",
		]
	}

	// =============================================
	// ACTIONS (operações executáveis)
	// =============================================

	actions: [{
		code:        "act-build-supplier-pool"
		name:        "Build Supplier Pool"
		description: "Construir pool qualificado de fornecedores para uma categoria consultando NPM (QueryParticipantStatus, sync) e aplicando filtros de scope (location, capacity range, qualification per category). Output: lista de SupplierRef qualificados que entram em RFQ. Pré-condição estrutural de act-open-rfq. Impact: read-only (cross-bc query NPM). Anti-mini-NIM: SSC consome status binário eligible/non-eligible — NÃO revalida compliance KYC/AML (responsabilidade NPM)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-sourcing-process",
			"inv-qualification-as-precondition",
		]
		preconditions: [
			"Demanda recebida de category manager (sh-01) com categoryRef + RFQScope",
			"NPM acessível via QueryParticipantStatus com latência aceitável",
		]
		postconditions: [
			"Pool qualificado construído com ≥1 SupplierRef OR escalation triggered (insufficient-context se NPM indisponível; out-of-scope se pool < 2 e exceção sole-source não declarada)",
		]
	}, {
		code:        "act-validate-rfq-scope"
		name:        "Validate RFQ Scope"
		description: "Validar estruturalmente RFQScope antes de abrir RFQ: presença de campos obrigatórios (categoryRef, description, estimatedVolume, deadline), formato de Money (currency ISO 4217 quando aplicável), consistência com taxonomia de Categoria de Compra. Pré-condição de act-open-rfq. Impact: read-only (validação técnica sobre payload de demanda)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-sourcing-process",
		]
		preconditions: [
			"Demanda recebida de category manager com payload estruturado",
		]
		postconditions: [
			"RFQScope validado OR escalation triggered (suspicious-input se payload malformado; ambiguous-case se categoria multi-aplicável)",
		]
	}, {
		code:        "act-open-rfq"
		name:        "Open RFQ"
		description: "Abrir RFQ emitindo cmd-open-rfq: cria agg-sourcing-process directly em initialState=open com decisionType declarado upfront (one-shot / preferred-designation / strategic-award), invitedSuppliers snapshot do pool qualificado construído por act-build-supplier-pool, validityPeriod (se preferred-designation), expectedContractScope (se strategic-award), e emite evt-rfq-opened para subscription transversal NTF (notificação aos fornecedores convidados) + OBS. Phase 0 propose-and-wait: agente prepara recommendation, human gate aprova abertura. Impact: state-change (cria aggregate) + cross-bc (NTF transversal notifica fornecedores externos). Decide-vs-execute audit (tq-agg-09): NÃO monolítico — decisão de abrir é do category manager (sh-01); agente apenas prepara command estruturado, gate humano confirma. AutonomyLevel propose-and-wait Phase 0 mesmo sendo canvas autonomousDecision per BDG canon."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-open-rfq",
			"evt-rfq-opened",
			"agg-sourcing-process",
			"inv-decision-type-declared-upfront",
			"inv-qualification-as-precondition",
		]
		preconditions: [
			"Pool qualificado construído por act-build-supplier-pool com ≥1 SupplierRef",
			"RFQScope validado por act-validate-rfq-scope",
			"decisionType declarado pelo category manager (one-shot / preferred-designation / strategic-award)",
			"validityPeriod fornecido se decisionType=preferred-designation; expectedContractScope se strategic-award",
		]
		postconditions: [
			"agg-sourcing-process criado em status=open + evt-rfq-opened emitido (NTF transversal notifica fornecedores) + audit timestamp requestedAt < rfqOpenedAt registrado",
			"Pool registrado em invitedSuppliers como snapshot na abertura",
		]
	}, {
		code:        "act-evaluate-signal-sufficiency"
		name:        "Evaluate Signal Sufficiency"
		description: "Verificar completude estrutural do fitnessSignals antes de aplicar fitness rules: required Phase 0 signals presentes e não-nulos (NPM eligibility binária + RFQ context + RFQ responses). optional Phase 0 (NIM performanceScore + CTR existingCommitments) podem ser null sem bloquear (caveats Phase 0 per oq-ssc-1/7). Decisão boolean: emitir → fitness application; não-emitir → escalation insufficient-context. Anti-mini-NIM: agente NÃO interpreta signal incompleto — reconhece insuficiência e escala. Impact: read-only."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-sourcing-process",
			"inv-decision-from-structured-signals",
		]
		preconditions: [
			"agg-sourcing-process em status=open com quotations submitidas (≥1 ent-quotation status=submitted)",
			"fitnessSignals struct construído (NPM eligibility consultada + RFQ context populated + rfqResponses agregadas)",
		]
		postconditions: [
			"sufficient=true → próxima ação act-revalidate-qualification + act-evaluate-and-conclude-rfq",
			"sufficient=false → escalation insufficient-context com signals faltantes/inconsistentes listados",
		]
	}, {
		code:        "act-revalidate-qualification"
		name:        "Revalidate Qualification Pre-Decision"
		description: "Re-consultar QueryParticipantStatus (sync NPM) antes de emitir decisão; remover do pool fornecedores rebaixados entre RFQ open e decision time. Defesa secundária a pol-revalidate-on-status-changed (defesa primária via NPM event ACL). Pool resultante < 2 dispara escalation out-of-scope (insufficient-qualified-pool). Impact: read-only (cross-bc query NPM)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-sourcing-process",
			"inv-qualification-as-precondition",
			"inv-competitive-pool-or-supervised-exception",
		]
		preconditions: [
			"act-evaluate-signal-sufficiency retornou sufficient=true",
			"NPM acessível via QueryParticipantStatus",
		]
		postconditions: [
			"Pool re-validado: fornecedores rebaixados removidos de evaluatedSuppliers candidato; pool ≥ 2 → próxima ação act-evaluate-and-conclude-rfq",
			"Pool < 2 → escalation out-of-scope (insufficient-qualified-pool); supervisedDecision approve-decision-with-insufficient-pool é caminho permitido com justificativa",
		]
	}, {
		code:        "act-evaluate-and-conclude-rfq"
		name:        "Evaluate and Conclude RFQ"
		description: "Aplicar fitness rules versionadas (vo-fitness-rule-snapshot) sobre fitnessSignals para produzir output determinístico via svc-fitness-rule-evaluator: scoresPerCriterion (output direto da fórmula declarada — sem inferência) + ranking + allocationPolicy recomendada + tradeoffs estruturados. Capturar decisionRationale rico em vo-decision-rationale (delegado a act-generate-decision-rationale). Emitir 1 de 3 events conforme rfq.decisionType: SourcingDecisionMade (one-shot, hard binding P2P) | PreferredSupplierDesignated (preferred, soft binding P2P + validityPeriod) | StrategicAwardCompleted (strategic-award, hard binding CTR + advisory P2P). Emitir evt-rfq-concluded pareado (per inv-rfq-public-lifecycle-events). Aggregate transition open→concluded atomic (lifecycle do agg-sourcing-process). Impact: state-change + cross-bc (3 published events com consumers reais). Decide-vs-execute audit (tq-agg-09): NÃO monolítico — outcome é função determinística do gate (fitness rules + signals → ranking + allocation), não julgamento; rejeição/escalation não é decisão separada do agente, é consequência de signals insuficientes (act-evaluate-signal-sufficiency anterior) ou pool inadequado (act-revalidate-qualification anterior). Phase 0 propose-and-wait: human gate aprova decisão antes de emit. Anti-mini-NIM rigorously enforced: scoresPerCriterion são output da fórmula declarada — agente NÃO interpreta nem infere; reaplicação produce mesmo output (testável via property-based test)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-make-one-shot-sourcing-decision",
			"cmd-designate-preferred-supplier",
			"cmd-complete-strategic-award",
			"evt-sourcing-decision-made",
			"evt-preferred-supplier-designated",
			"evt-strategic-award-completed",
			"evt-rfq-concluded",
			"agg-sourcing-process",
			"inv-decision-from-structured-signals",
			"inv-decision-type-declared-upfront",
			"inv-qualification-as-precondition",
			"inv-decision-rationale-required",
			"inv-rfq-public-lifecycle-events",
			"inv-competitive-pool-or-supervised-exception",
			"inv-fitness-rules-versioned-config",
			"prj-active-sourcing-decisions",
		]
		preconditions: [
			"act-revalidate-qualification retornou pool ≥ 2 OR supervisedDecision approve-decision-with-insufficient-pool autorizada",
			"fitness rules vigentes carregadas com versionId (vo-fitness-rule-snapshot)",
			"act-generate-decision-rationale produziu vo-decision-rationale completo (criteria + weights + evaluatedSuppliers + tradeoffs)",
			"Comando de conclusão match decisionType da RFQ (per inv-decision-type-declared-upfront)",
		]
		postconditions: [
			"agg-sourcing-process status open→concluded + sourcingDecisionId populated + selectedSuppliers + allocationPolicy + decisionRationale + fitnessRuleSnapshot anexados ao aggregate",
			"1 de 3 decision events emitido conforme decisionType + evt-rfq-concluded emitido (atomic transition)",
			"Consumers cross-BC notificados: P2P (hard binding one-shot, soft binding preferred, advisory strategic), CTR (mandatory strategic), NIM (intelligence learning loop pendente oq-ssc-2)",
		]
	}, {
		code:        "act-cancel-rfq"
		name:        "Cancel RFQ"
		description: "Cancelar RFQ aberta antes de decisão emitindo cmd-cancel-rfq: anula compromisso com fornecedores convidados via NTF transversal (justificativa documentada obrigatória). Trigger: escalationCriterion rfq-no-quotations-received OU mudança estratégica do category manager OU pool inadequado sem path de exception. Sempre supervisedDecision per canvas (custo reputacional para fornecedores convidados é decisão julgativa). Impact: state-change + cross-bc (NTF notifica fornecedores). autonomyLevel propose-and-wait + escalationOverride hard-supervised: cancelamento exige aprovação humana mesmo se governance envelope promover demais mutations."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-cancel-rfq",
			"evt-rfq-cancelled",
			"agg-sourcing-process",
			"inv-rfq-public-lifecycle-events",
		]
		preconditions: [
			"agg-sourcing-process em status=open (não pode cancelar concluded/cancelled)",
			"Justificativa documentada por solicitante (category manager OR founder em escalation)",
			"Aprovação humana registrada antes de emit (autonomyLevel propose-and-wait + canvas supervised)",
		]
		postconditions: [
			"agg-sourcing-process status open→cancelled + evt-rfq-cancelled emitido com reason + cancelledBy + cancelledAt",
			"Fornecedores convidados notificados via NTF transversal (audit reputacional preserved)",
		]
	}, {
		code:        "act-revalidate-rfq-pool"
		name:        "Revalidate RFQ Pool"
		description: "Reavaliar pool de fornecedores qualificados quando NetworkParticipantStatusChangedReceived (ACL de NPM event) afeta participante convidado em RFQ ativa. Triggered async por pol-revalidate-on-status-changed; agente executa cmd-revalidate-rfq-pool. Mutação intra-state (status open mantido): remove fornecedor rebaixado de invitedSuppliers. Phase 0 capability: execute-and-log quando remoção preserva pool ≥ 2 (mutation determinística, sem julgamento — fornecedor rebaixado em NPM é fato externo autoritativo). Pool < 2 pós-revalidation triggera escalationCondition out-of-scope (insufficient-qualified-pool) via escalationOverride conditional — humano decide manter (sole-source) ou cancelar RFQ. Override execute-and-log da BDG canon (TODAS mutations propose-and-wait) é justificado por: (a) signal source autoritativo (NPM single-owner per dp-04); (b) ação determinística sem inferência; (c) escalation path já cobre cenário risky (pool < 2)."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-revalidate-rfq-pool",
			"evt-network-participant-status-changed-received",
			"agg-sourcing-process",
			"inv-qualification-as-precondition",
		]
		preconditions: [
			"evt-network-participant-status-changed-received recebido via ACL NPM",
			"Participante afetado existe em invitedSuppliers de ≥1 RFQ ativa em status=open",
		]
		postconditions: [
			"invitedSuppliers atualizado com fornecedor rebaixado removido (audit log preservado)",
			"Pool ≥ 2 mantido → continuação normal de RFQ (execute-and-log, sem human gate); pool < 2 → escalation out-of-scope para decisão sobre cancelamento OR aprovação supervisada",
		]
	}, {
		code:        "act-generate-decision-rationale"
		name:        "Generate Decision Rationale"
		description: "Gerar vo-decision-rationale estruturado capturando criteria aplicados (per fitness rule snapshot), weights vigentes da categoria, evaluatedSuppliers (todos cotantes válidos com scoresPerCriterion + finalRank), tradeoffs articulados (justificativa de escolha vs alternativa específica em determinado critério). Quotations com status=withdrawn NÃO entram em evaluatedSuppliers. Anexado ao audit trail (via decisionRationaleRef/hash) e ao payload do decision event (objeto completo). Sustenta inv-decision-rationale-required + cap-04 auditoria contínua + moat de inteligência (consumo NIM futuro pendente oq-ssc-2). Impact: read-only (geração de descritor; sem state change)."
		category:        "generation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"evt-sourcing-decision-made",
			"evt-preferred-supplier-designated",
			"evt-strategic-award-completed",
			"agg-sourcing-process",
			"inv-decision-rationale-required",
		]
		preconditions: [
			"Outcome do fitness evaluation determinado (selectedSuppliers + allocationPolicy + ranking)",
			"fitnessRuleSnapshot vigente capturada (versionId + content + appliedAt)",
		]
		postconditions: [
			"vo-decision-rationale completo (criteria + weights + evaluatedSuppliers + tradeoffs + allocationPolicy) anexado ao payload do decision event + decisionRationaleRef/hash anexado ao audit trail",
		]
	}, {
		code:        "act-detect-fragmentation-pattern"
		name:        "Detect Fragmentation Pattern"
		description: "Self-monitoring estatístico de padrões de Fracionamento — múltiplas RFQs sub-threshold do mesmo proponente (category manager) na mesma categoria em janela curta — que sugerem evasão de Alçada ou supervised gate via splitting. Defesa estrutural primária depende de coordenação cross-BC com BDG (term-fracionamento bidirecional, oq-bdg-1 análogo); Phase 0 SSC sinaliza padrões observáveis no escopo local via prj-rfq-history-by-category. Vetor adversarial sh-01 (originadora) per canvas incentiveAnalysis. Impact: read-only. Mecanismo SECUNDÁRIO de defesa per canvas escalationCriterion fragmentation-pattern-detected: Phase 0 limitação reconhecida — agregação cross-BC pendente."
		category:        "escalation"
		autonomyLevel:   "collect-and-report"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-sourcing-process",
			"prj-rfq-history-by-category",
			"evt-rfq-opened",
		]
		preconditions: [
			"prj-rfq-history-by-category populada com janela mínima viável (≥30 dias de RFQs)",
		]
		postconditions: [
			"Anomaly report estruturado (proponente + categoria + RFQs envolvidas + janela + threshold gaming evidence) + recommendation para revisão humana; nenhum state change",
		]
	}, {
		code:        "act-detect-suspicious-quotation"
		name:        "Detect Suspicious Quotation"
		description: "Self-monitoring estatístico de cotações fora de range vs histórico da categoria via prj-rfq-history-by-category (mediana + variância de preço). Detecção de low-balling (cotação muito abaixo da mediana sustentada — anti-low-balling design response per canvas incentiveAnalysis sh-02) ou inflation (cotação muito acima — possível collusion). Defesa estrutural via comparação estatística contra histórico SSC-mantido (signal robusto per as-ssc-2, NÃO input manipulável de fornecedor). Impact: read-only. Mecanismo SECUNDÁRIO: detecção exige decisão humana sobre consequência (rejeição da cotação, escalation, ou inclusão com flag)."
		category:        "escalation"
		autonomyLevel:   "collect-and-report"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-rfq-history-by-category",
			"agg-sourcing-process",
		]
		preconditions: [
			"prj-rfq-history-by-category populada com janela mínima viável + variância calculada per categoria",
			"≥1 ent-quotation status=submitted no agg-sourcing-process",
		]
		postconditions: [
			"Anomaly report estruturado (rfqId + supplierRef + cotação + mediana histórica + desvio padrão + classificação low-balling/inflation/collusion-suspect) + recommendation para revisão humana; nenhum state change",
		]
	}, {
		code:        "act-query-active-sourcing-decisions"
		name:        "Query Active Sourcing Decisions"
		description: "Atender query QueryActiveSourcingDecisions consumida por P2P (cache de policies aplicáveis a múltiplos pedidos) e controllers (reporting). Retorna ActiveSourcingDecisions por categoria — lista de decisões vigentes com tipo + selectedSuppliers + allocationPolicy + validade + scope. Impact: read-only (consulta a prj-active-sourcing-decisions)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-active-sourcing-decisions",
		]
		preconditions: ["categoryRef fornecido"]
		postconditions: ["ActiveSourcingDecisions retornado (lista filtrada por categoria) OR not-found se categoria sem decisões vigentes"]
	}, {
		code:        "act-query-sourcing-decision"
		name:        "Query Sourcing Decision"
		description: "Atender query QuerySourcingDecision consumida por P2P (validar autoridade de procurement per bd-procurement-requires-sourcing-authority) e CTR (validar strategic award pré-formalização contratual). Retorna SourcingDecision por sourcingDecisionId — payload completo incluindo decisionRationale + fitnessRuleSnapshot + selectedSuppliers + allocationPolicy. Impact: read-only (consulta a prj-sourcing-decision-by-id)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-sourcing-decision-by-id",
		]
		preconditions: ["sourcingDecisionId fornecido"]
		postconditions: ["SourcingDecision retornado (payload completo) OR not-found se sourcingDecisionId desconhecido"]
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
		code:         "cst-fitness-rules-deterministic-application"
		name:         "Fitness Rules Deterministic Application"
		description:  "act-evaluate-and-conclude-rfq NUNCA emite decisão sem fitness rules versionadas (vo-fitness-rule-snapshot) serem aplicadas deterministicamente sobre fitnessSignals estruturados. NÃO há campo de inferência subjetiva, classificação preditiva, ou interpretação julgativa de signals — anti-mini-NIM rigorously enforced."
		verification: "Runner verifica que para cada decision event emitido (SourcingDecisionMade / PreferredSupplierDesignated / StrategicAwardCompleted), payload contém: (a) vo-fitness-rule-snapshot (versionId + content + appliedAt) referenciando regras vigentes em config externa; (b) vo-decision-rationale com criteria/weights/evaluatedSuppliers/tradeoffs derivados da aplicação da fórmula declarada. Decisão sem snapshot ou rationale parcial bloqueia emissão. Reaplicação dado mesmos inputs (signals + snapshot) produce MESMO output (testável via property-based test)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-decision-from-structured-signals (RECTOR). enforcementLevel: agent (fitness rules carregadas + aplicadas in-line via svc-fitness-rule-evaluator antes de submit) + domain (handler dos 3 commands de conclusão re-valida snapshot vinculado ao aggregate). bd-deterministic-decision-from-structured-signals + P10 (gates determinísticos validam, agentes recomendam). Sem este gate, agente vira intérprete de signals — viola integridade do gate e moat de inteligência regrede a mini-NIM duplicado."
	}, {
		code:         "cst-decision-type-must-match-rfq"
		name:         "Decision Type Must Match RFQ"
		description:  "act-evaluate-and-conclude-rfq NUNCA executa cmd-make-one-shot-sourcing-decision em RFQ tipo preferred-designation (etc). Comando de conclusão deve match tipo declarado em cmd-open-rfq (campo decisionType do agg-sourcing-process). Mapeamento canônico: one-shot → SourcingDecisionMade; preferred-designation → PreferredSupplierDesignated; strategic-award → StrategicAwardCompleted."
		verification: "Runner verifica que para cada decision event emitido, agg-sourcing-process.decisionType corresponde ao mapeamento canônico do event type. Audit trail registra requestedAt < rfqOpenedAt < concludedAt confirmando declaração upfront. Mismatch (ex.: SourcingDecisionMade emitido em RFQ preferred-designation) bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-decision-type-declared-upfront. enforcementLevel: agent (validação in-line antes de submit do command de conclusão) + domain (handler dos commands valida correspondência). bd-decision-type-is-declared-upfront. Evita autonomy creep — agente APLICA regras, NÃO decide tipo de processo. Tipo classificado retroativamente vira agente julgando; declaração upfront preserva fronteira agent vs human (category manager declara tipo)."
	}, {
		code:         "cst-qualification-revalidation-mandatory"
		name:         "Qualification Revalidation Mandatory"
		description:  "act-evaluate-and-conclude-rfq NUNCA emite decisão sem re-validation NPM no decision time via QueryParticipantStatus (sync). Validação obrigatória em 2 momentos críticos: RFQ open (qualificação inicial do pool via act-build-supplier-pool) e decision time (re-validation pre-emit via act-revalidate-qualification). Fornecedor rebaixado entre os pontos é excluído automaticamente."
		verification: "Runner verifica que para cada decision event emitido, audit trail contém timestamp de QueryParticipantStatus consultado < timestamp de emit (re-validation no decision time). Selected/preferred/awarded suppliers no event têm NPM eligibility=eligible-for-sourcing no momento da consulta. Decisão sem re-validation ou com supplier não-eligible bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-qualification-as-precondition. enforcementLevel: agent (re-validation pre-emit é gate hard) + external (NPM single-owner de qualification status per dp-04; SSC consume status binário, NÃO revalida compliance KYC/AML). bd-qualification-as-absolute-precondition. Janela de risco entre RFQ open e decision time é mitigada por defesa primária (pol-revalidate-on-status-changed via NPM event ACL) + defesa secundária (act-revalidate-qualification sync pre-emit)."
	}, {
		code:         "cst-decision-rationale-mandatory"
		name:         "Decision Rationale Mandatory"
		description:  "act-evaluate-and-conclude-rfq NUNCA emite decisão sem decisionRationale completo: criteria aplicados (per fitness rule snapshot), weights vigentes da categoria, evaluatedSuppliers (todos os cotantes válidos com scoresPerCriterion + finalRank), tradeoffs articulados (justificativa de escolha vs alternativa específica em determinado critério). decisionRationale vazio ou parcial bloqueia emissão. Quotations com status=withdrawn NÃO entram em evaluatedSuppliers."
		verification: "Runner verifica que para cada decision event emitido, payload.decisionRationale tem criteria.length ≥ 1, weights populated, evaluatedSuppliers.length ≥ 1 com scoresPerCriterion + finalRank por supplier, tradeoffs.length ≥ 1 (mesmo single-supplier deve ter tradeoff vs alternativa hipotética OR no-bid baseline). evaluatedSuppliers NÃO contém quotations status=withdrawn. Rationale incompleto bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-decision-rationale-required. enforcementLevel: agent (act-generate-decision-rationale é gate pré-emit via precondition de act-evaluate-and-conclude-rfq) + runner (validation pós-submit do payload do event). DecisionRationale rico é o output canônico estruturado — sustenta auditoria de processo competitivo (Lei 12.846) + reconciliação spend + consumo NIM futuro (oq-ssc-2). Sem rationale, decisão é caixa-preta — viola moat de inteligência da Mesh."
	}, {
		code:         "cst-rfq-lifecycle-events-paired"
		name:         "RFQ Lifecycle Events Paired"
		description:  "Toda RFQ que percorre fluxo normal (open → decisão emitida) DEVE emitir RFQOpened seguido de RFQConcluded. Toda RFQ cancelada antes de decisão DEVE emitir RFQOpened seguido de RFQCancelled. Não há saída do lifecycle sem evento público correspondente."
		verification: "Runner verifica que para cada agg-sourcing-process status=concluded, event log contém RFQOpened anterior + RFQConcluded posterior pareados (rfqId match). Para cada agg-sourcing-process status=cancelled, RFQOpened + RFQCancelled pareados. Saída de lifecycle sem evento pareado bloqueia transition (lifecycle do aggregate enforce atomic emit)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-rfq-public-lifecycle-events. enforcementLevel: domain (atomic transition no lifecycle do agg-sourcing-process emite RFQConcluded/RFQCancelled atomicamente com decision event ou cancellation event). bd-rfq-lifecycle-public-minimal. Notificação a fornecedores convidados (NTF transversal) + observabilidade (OBS) dependem destes events. Avaliação interna (cotações, equalização, decisionRationale) permanece intra-SSC — confidencialidade competitiva preservada via separation public lifecycle vs internal evaluation."
	}, {
		code:         "cst-competitive-pool-or-supervision"
		name:         "Competitive Pool Or Supervised Exception"
		description:  "act-evaluate-and-conclude-rfq NUNCA emite decisão AUTOMATICAMENTE com pool < 2 fornecedores qualificados no decision time. Pool < 2 (incluindo cenário sole-source genuíno: item proprietário, fornecedor único qualificado, urgência operacional) dispara escalation out-of-scope (insufficient-qualified-pool); supervisedDecision approve-decision-with-insufficient-pool com justificativa documentada é caminho permitido — sem bloqueio absoluto, apenas escalation para gate humano."
		verification: "Runner verifica que para cada decision event emitido autonomamente (sem approver-id humano em audit trail), evaluatedSuppliers.length ≥ 2 no momento da emissão. Decision events com evaluatedSuppliers.length < 2 require approver-id + justification em audit trail. Aprovação autônoma com pool insuficiente bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-competitive-pool-or-supervised-exception. enforcementLevel: agent (gate pré-emit via act-revalidate-qualification + escalation routing). Pool < 2 quebra premissa de seleção competitiva no caso default, mas sole-source é caso real e legítimo em algumas categorias — exige decisão humana com justificativa, não bloqueio absoluto. Sustenta as-ssc-1 (pool qualificado viável) como assumption operacional."
	}, {
		code:         "cst-fitness-rules-snapshot-immutable"
		name:         "Fitness Rules Snapshot Immutable"
		description:  "act-evaluate-and-conclude-rfq NUNCA emite decisão sem vo-fitness-rule-snapshot (versionId + content + appliedAt) imutável carregado no event. Snapshot referencia regras vigentes no momento da decisão; configuração e atualização de regras (configure-fitness-rules) são supervisedDecisions externas ao escopo aplicador do agente."
		verification: "Runner verifica que para cada decision event emitido, payload.fitnessRuleSnapshot tem versionId não-vazio + content struct populated + appliedAt timestamp ≤ event timestamp. SnapshotId é única por (versionId + appliedAt) — drift de regras pós-emit não invalida snapshot histórico (audit reproducibility preservada)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-fitness-rules-versioned-config. enforcementLevel: agent (snapshot capture in-line antes de submit) + external (config externa governada — agente NÃO modifica regras, apenas consulta vigente + captura snapshot). Sem snapshot versionado, audit não consegue reconstituir como decisão foi tomada (drift de regras invalida histórico). Shape e infraestrutura de configuração externa é openQuestion oq-ssc-8."
	}, {
		code:         "cst-supervised-operations-require-human-gate"
		name:         "Supervised Operations Require Human Gate"
		description:  "act-cancel-rfq NUNCA materializa state change (cancelled) sem aprovação humana em Phase 0. Operations equivalentes (override-fitness-rule, approve-decision-with-insufficient-pool, configure-fitness-rules) são supervisedDecisions externas ao escopo aplicador do agente — agente apenas escala via escalationCondition out-of-scope; humano materializa a decisão via canal próprio (governance envelope)."
		verification: "Runner verifica que para cada evt-rfq-cancelled emitido, audit trail contém approval timestamp + approver-id ANTES de emit. autonomyLevel propose-and-wait + canvas supervised é hard gate. Override de fitness rule, aprovação com pool insuficiente, e configuração de fitness rules NÃO produzem events emitidos pelo agente — são canais paralelos governados via supervisedDecision externa."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: (operacional, sustenta canvas supervisedDecisions Phase 0). enforcementLevel: agent (autonomyLevel propose-and-wait declarado no spec). Cancelamento tem custo reputacional para fornecedores convidados; override de fitness rule ajusta gate determinístico em exceção; aprovação com pool insuficiente quebra premissa competitiva; configuração de regras é decisão estratégica. Todas excedem authority autônoma do agente (mech-agent-gate) — operacionalmente irreversíveis ou estrategicamente julgativas exigem human gate Phase 0."
	}]

	// =============================================
	// ESCALATION CONDITIONS (when to halt and escalate)
	// =============================================
	//
	// Default global. Per-action override Phase 0 documentado em
	// rationale de actions críticas:
	// - act-cancel-rfq: hard-supervised (sempre gate humano)
	// - act-revalidate-rfq-pool: conditional (escala se pool drop < 2)

	escalationConditions: [{
		category:    "conflicting-signals"
		description: "fitnessSignals contém signals contraditórios sem path determinístico de resolução: (a) NPM eligibility=true mas existingCommitments indica fornecedor at-capacity; (b) NIM performanceScore baixo (pendente oq-ssc-1) mas RFQ price competitivo; (c) supplier qualification scope expirado mas eligibility=eligible-for-sourcing (drift de NPM state)."
		rationale:   "Cobertura tq-ag-10 mutations (act-evaluate-and-conclude-rfq + act-open-rfq + act-revalidate-rfq-pool). Conflito não resolvível por regra é decisão julgativa — fora do escopo do agente per anti-mini-NIM. Canvas escalationCriterion conflicting-fitness-signals."
	}, {
		category:    "insufficient-context"
		description: "Required Phase 0 signals incompleto (NPM eligibility / RFQ context / RFQ responses ausentes ou inconsistentes) OR projection stale acima de SLO 5s OR rfq-no-quotations-received (janela de cotação fechou sem propostas válidas) OR fitness rules vigentes não acessíveis."
		rationale:   "Cobertura tq-ag-10 mutations + canvas escalationCriterion insufficient-fitness-signal + rfq-no-quotations-received. Indisponibilidade de SoT crítica exige fallback humano ou postergação — falta de visibilidade ≠ outcome rejected automático (rejeição implicaria conclusão definitiva, não falta de context). Anti-mini-NIM: agente NÃO interpreta signal incompleto."
	}, {
		category:    "out-of-scope"
		description: "Pool qualified < 2 fornecedores no decision time (canvas supervisedDecision approve-decision-with-insufficient-pool é caminho permitido) OR override-fitness-rule solicitado OR configure-fitness-rules solicitado OR cancel-rfq triggered (escalationCriterion rfq-no-quotations-received OU mudança estratégica) OR ajuste de validityPeriod de preferred designation pós-emit (não modelado Phase 0)."
		rationale:   "Cobertura tq-ag-10 + canvas insufficient-qualified-pool + 4 supervisedDecisions. Operações fora da autoridade autônoma do agente são escaladas por design — não há autonomia para override de regras, configuração estratégica, ou cancelamento com custo reputacional."
	}, {
		category:    "suspicious-input"
		description: "act-detect-fragmentation-pattern emite anomaly (múltiplas RFQs sub-threshold do mesmo proponente em janela curta — vetor sh-01 manipulação por category manager) OR act-detect-suspicious-quotation detecta low-balling (cotação muito abaixo da mediana sustentada via prj-rfq-history-by-category — vetor sh-02) OR cotação muito acima da mediana (possível collusion)."
		rationale:   "Vetores adversariais sh-01 (originadora) + sh-02 (fornecedor) per canvas incentiveAnalysis. Threshold gaming + low-balling são patterns conhecidos. Detecção exige decisão humana sobre consequência: pausa de autonomia para proponente/fornecedor, agregação retroativa, OR ajuste de regra. Coordenação cross-BC com BDG (Fracionamento bidirecional) pendente Phase 0."
	}, {
		category:    "ambiguous-case"
		description: "RFQScope cobre múltiplas categorias sem critério de partição claro (cross-category sourcing) OR allocationPolicy split unclear sem critério estruturado (multi-supplier sem percentage distribution declarada) OR decisionType declarado pelo category manager incompatível com pool (ex.: strategic-award com pool reduzido pós-revalidation)."
		rationale:   "Caso intermediário entre processo padrão e supervisedDecision explícita. Ambiguidade exige julgamento humano sobre como partir/decidir — fora do escopo aplicador do agente."
	}, {
		category:    "unclassifiable-anomaly"
		description: "Decisão envolve zona cinza regulatória (Lei 12.846 procurement public-private boundary, fiscal anomaly em cross-border supply, sanção a fornecedor durante RFQ ativa) OR cross-BC drift inesperado (CTR cancela contrato pós-StrategicAward sem signal Phase 0 — oq-ssc-5; preferred designation com override-rate sustentado em P2P sinalizando drift de fitness — oq-ssc-3)."
		rationale:   "Integridade legal é constraint inviolável (nível 1 do CLAUDE.md). Zona cinza exige julgamento humano especializado — compliance officer ou category manager designado. Cross-BC drift sistêmico exige decisão estrutural sobre evolução do context-map, não correção pontual."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS (stub — completados em Parte 3)
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Stub minimal — completado em Parte 3 (5 artifacts com slices + estimatedBudget heavy)."
		}]
		estimatedBudget: "moderate"
	}

	// =============================================
	// OBSERVABILITY (stub — completados em Parte 3)
	// =============================================

	observability: {
		signals: [{
			code:           "sig-mutation-executed"
			name:           "Mutation Executed"
			description:    "Stub minimal — completado em Parte 3 (9 signals: 7 canônicos + sig-decision-emitted + sig-anomaly-pattern-detected SSC-specific)."
			coversCategory: "mutation"
			trigger:        "Stub minimal — completado em Parte 3."
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
			storageHint: "Stub minimal — completado em Parte 3."
			rationale:   "Stub com 7 mínimos canônicos satisfazendo #AuditTrail._minimumAuditFields. 6 SSC-specific fields adicionados em Parte 3."
		}
	}

	rationale: "Agent Spec SSC scaffold (Parte 1 de 3): operationalScope completo (1 aggregate + 8 commands + 7 events + 7 invariants + 3 projections); stubs mínimos de actions/constraints/escalation/contextRequirements/observability serão substituídos nas Partes 2-3. Outer rationale completo finalizado em Parte 3."
}
