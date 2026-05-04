package bdg

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// bdg-primary-agent.cue — Agent Spec do BC Budget & Approval.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Aplicação manual do production-guide architecture/production-guides/
// agent-spec.cue (manualAuthoringProtocol per adr-057). Cascade ordering
// per adr-054 dec 13: PG existe; canvas.ownership.domainAgentSpec
// aponta para este path. Manual takeover preventivo por main agent
// (não houve dispatch attempt para agent-spec — PG-A iteração rica
// pós-founder review tornou manual mais previsível que subagent-
// drafted neste momento; observações empíricas idc-primary-agent
// + 3 BCs exemplares como golden examples).
//
// Princípio operacional canônico (per founder review 2026-05-01):
// Spec declara CAPACIDADE; governance envelope declara AUTONOMIA atual
// via promotion criteria + autonomyOverrides intermediários. Phase 0:
// 2 mutation actions propose-and-wait, independente de canvas declarar
// autonomousDecision. "autonomousDecision" no canvas significa "não
// exige julgamento humano (gate determinístico)", NÃO "execução sem
// governança". Promotion para execute-and-log dessas 2 mutations é
// decisão do envelope.governance, não do spec — preserva P10 (gates
// determinísticos validam, agentes recomendam) e habilita rollback
// automático per failureHandling.
//
// Boundaries explicitamente preservadas (per canvas businessDecisions):
// - bd-commitment-not-payment: BDG não consulta TCM nem dispara FCE.
// - bd-allocation-not-treasury: agente NÃO realoca entre Centros de
//   Custo; ajuste de Limite é supervisedDecision externa.
// - bd-cost-center-as-sot: Centro de Custo identificável determinis-
//   ticamente per as-bdg-1.
// - bd-coverage-as-invariant: nenhum BudgetApproved sem Gate de
//   Cobertura aprovar.

bdgPrimaryAgent: artifact_schemas.#AgentSpec & {
	code:              "agt-bdg-primary"
	name:              "BDG Primary Agent"
	description:       "Agente operador único do BC Budget & Approval. Executa Gate de Cobertura determinístico (Saldo Disponível em Centro de Custo identificado + Alçada satisfeita), registra Comprometimento Orçamentário no aggregate agg-cost-center, publica decisões (BudgetApproved/BudgetRejected) e propõe Liberação de Comprometimento sob supervisão. Não consulta caixa em TCM, não executa pagamento em FCE, não realoca orçamento entre Centros de Custo (boundaries inviolável per canvas businessDecisions)."
	boundedContextRef: "bdg"
	role:              "domain-agent"
	governanceRef:     "bdg-primary-agent"

	// =============================================
	// OPERATIONAL SCOPE
	// =============================================

	operationalScope: {
		aggregates: [
			"agg-cost-center",
		]
		commands: [
			"cmd-approve-budget",
			"cmd-reject-budget",
			"cmd-release-budget-commitment",
		]
		events: [
			"evt-budget-approved",
			"evt-budget-rejected",
			"evt-budget-commitment-released",
			"evt-commitment-accepted-received",
		]
		invariants: [
			"inv-coverage-gate-deterministic",
			"inv-cost-center-required",
			"inv-alcada-respected",
			"inv-commitment-not-payment",
			"inv-allocation-not-treasury",
			"inv-released-amount-matches-commitment",
			"inv-commitment-id-uniqueness-per-cost-center",
		]
		projections: [
			"prj-budget-approval-status",
			"prj-cost-center-availability",
		]
	}

	// =============================================
	// ACTIONS (operações executáveis)
	// =============================================

	actions: [{
		code:        "act-identify-cost-center"
		name:        "Identify Cost Center"
		description: "Identificar deterministicamente o Centro de Custo aplicável a partir do escopo do compromisso (CommitmentScope: descrição, valor, partes, referência contratual de CTR). Pré-condição de cmd-approve-budget. Impact: read-only (consulta a configuração externa de Centros de Custo + escopo CMT; sem state change). Per as-bdg-1 a identificação é determinística; ambiguidade dispara escalation supervisedDecision approve-budget-with-cost-center-ambiguity."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"vo-cost-center-id",
			"cmd-approve-budget",
			"evt-commitment-accepted-received",
		]
		preconditions: [
			"CommitmentScope recebido via evt-commitment-accepted-received (ACL)",
			"Plano de Centros de Custo disponível como configuração externa",
		]
		postconditions: [
			"CostCenterId identificado OR escalation triggered (cost-center-ambiguity)",
		]
	}, {
		code:        "act-execute-coverage-gate"
		name:        "Execute Coverage Gate"
		description: "Executar Gate de Cobertura determinístico: (1) consultar Saldo Disponível do Centro de Custo identificado via prj-cost-center-availability; (2) verificar Alçada vigente do agente contra valor solicitado. Propõe/materializa conforme governance envelope: (a) approved — Saldo suficiente + Alçada satisfeita ⇒ ApproveBudget aceito, registra Comprometimento, emite BudgetApproved; (b) rejected — Saldo insuficiente / Centro de Custo inválido / Alçada excedida sem override ⇒ RejectBudget aceito, emite BudgetRejected; (c) ambiguous — Centro de Custo não identificável OR mudança em curso de configuração ⇒ escalate (insufficient-context | conflicting-signals | ambiguous-case). Impact: state-change + cross-bc (DLV consume BudgetApproved spine; CMT/DRC consume BudgetRejected pendente oq-bdg-2). Decide-vs-execute audit (tq-agg-09): NÃO monolítico — outcome é função do gate determinístico (numerical comparisons), não julgamento; rejeição definitiva não é decisão separada do agente. AutonomyLevel: propose-and-wait Phase 0 — deterministic-gated mas governance-promotion candidate via envelope (preserva P10)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-approve-budget",
			"cmd-reject-budget",
			"agg-cost-center",
			"evt-budget-approved",
			"evt-budget-rejected",
			"inv-coverage-gate-deterministic",
			"inv-cost-center-required",
			"inv-alcada-respected",
			"inv-commitment-id-uniqueness-per-cost-center",
			"prj-cost-center-availability",
		]
		preconditions: [
			"Centro de Custo identificado por act-identify-cost-center",
			"prj-cost-center-availability disponível com latência aceitável",
			"Tabela de Alçadas vigente acessível como configuração externa",
			"CommitmentId NÃO tem Comprometimento Orçamentário ATIVO em agg-cost-center (per inv-commitment-id-uniqueness-per-cost-center; histórico de liberados não bloqueia)",
		]
		postconditions: [
			"Outcome approved: Comprometimento Orçamentário registrado contra Centro de Custo + evt-budget-approved emitido + Saldo Disponível decrementado",
			"Outcome rejected: evt-budget-rejected emitido com RejectionReason estruturado (insufficient-balance | invalid-cost-center | alcada-exceeded)",
			"Outcome ambiguous: nenhuma transition; escalation triggered",
		]
	}, {
		code:        "act-propose-budget-commitment-release"
		name:        "Propose Budget Commitment Release"
		description: "Propor Liberação de Comprometimento Orçamentário previamente registrado, devolvendo o valor reservado ao Saldo Disponível do Centro de Custo. Trigger: cancelamento sinalizado em CMT, conclusão integral em FCE, ou ajuste supervisionado interno. Impact: state-change + cross-bc (CMT consome BudgetCommitmentReleased pendente oq-bdg-2). Decide-vs-execute split correto: propor é decisão do agente; executar (materializar reversão da reserva + emit event) requer aprovação humana em Phase 0 enquanto trigger cross-BC não é formalizado. Per inv-released-amount-matches-commitment, valor liberado = valor reservado (referência por BudgetCommitmentId obrigatória)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-release-budget-commitment",
			"agg-cost-center",
			"evt-budget-commitment-released",
			"inv-released-amount-matches-commitment",
		]
		preconditions: [
			"BudgetCommitmentId referenciado existe e está ATIVO em agg-cost-center",
			"Sinal observável de causa de liberação (cancelamento upstream, conclusão FCE, ajuste supervisionado)",
		]
		postconditions: [
			"Recommendation gerada com BudgetCommitmentId + CommitmentReleaseReason estruturado + impact estimate sobre Saldo Disponível",
			"Aguarda human gate; após aprovação: status do Comprometimento active→released + evt-budget-commitment-released emitido + Saldo Disponível reabastecido",
		]
	}, {
		code:        "act-query-budget-approval-status"
		name:        "Query Budget Approval Status"
		description: "Atender query QueryBudgetApprovalStatus consumida por CMT (visibilidade pós-formalização) e DRC (contexto de disputa). Retorna BudgetApprovalStatus vigente para um CommitmentId (pending, approved, rejected, released). Impact: read-only (consulta a prj-budget-approval-status)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-budget-approval-status",
			"qry-budget-approval-status",
		]
		preconditions: ["CommitmentId fornecido"]
		postconditions: ["BudgetApprovalStatus retornado OR not-found se nenhum compromisso correspondente existe"]
	}, {
		code:        "act-query-cost-center-availability"
		name:        "Query Cost Center Availability"
		description: "Atender query QueryCostCenterAvailability consumida por controllers, supervisores e (cenário evolutivo per oq-bdg-3) por CMT para previsão de cobertura pré-formalização. Retorna CostCenterAvailability (Limite, Saldo Disponível, comprometimentos ativos). Impact: read-only (consulta a prj-cost-center-availability)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-cost-center-availability",
			"qry-cost-center-availability",
		]
		preconditions: ["CostCenterId fornecido"]
		postconditions: ["CostCenterAvailability retornado OR not-found se Centro de Custo desconhecido"]
	}, {
		code:        "act-validate-commitment-scope"
		name:        "Validate Commitment Scope"
		description: "Validar estruturalmente o CommitmentScope recebido via ACL: presença de campos mínimos (descrição, valor, partes), formato de Money (currency ISO 4217), consistência com configuração de Centros de Custo. Pré-condição de act-identify-cost-center. Impact: read-only (validação técnica sobre payload; sem state change)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"vo-money",
			"evt-commitment-accepted-received",
		]
		preconditions: ["evt-commitment-accepted-received recebido via ACL"]
		postconditions: ["CommitmentScope validado OR escalation triggered (suspicious-input se payload malformado)"]
	}, {
		code:        "act-generate-budget-decision-rationale"
		name:        "Generate Budget Decision Rationale"
		description: "Gerar rationale estruturado da decisão de aprovação/rejeição: numericals usados no gate (Saldo consultado, Limite, valor solicitado, valor já comprometido), Centro de Custo identificado, Alçada aplicada, fonte da configuração consultada. Anexado ao audit trail e ao payload de evt-budget-approved/rejected. Impact: read-only (geração de descritor; sem state change). Sustenta auditoria contínua (cap-04 do canvas)."
		category:        "generation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"vo-rejection-reason",
			"evt-budget-approved",
			"evt-budget-rejected",
		]
		preconditions: ["Outcome do Gate de Cobertura determinado (approved/rejected)"]
		postconditions: ["Rationale estruturado anexado ao audit trail + payload do event de decisão"]
	}, {
		code:        "act-detect-fragmentation-pattern"
		name:        "Detect Fragmentation Pattern"
		description: "Self-monitoring estatístico de padrões de Fracionamento — múltiplos compromissos sub-threshold do mesmo proponente, mesmo Centro de Custo, em janela temporal curta — que sugerem evasão de Alçada. Impact: read-only. Mecanismo SECUNDÁRIO de defesa per canvas oq-bdg-1: defesa primária estrutural depende de coordenação cross-BC com REW (ainda não formalizada). Em Phase 0, agente sinaliza padrões observáveis no escopo local; agregação cross-BC permanece dependência estrutural."
		category:        "escalation"
		autonomyLevel:   "collect-and-report"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-cost-center",
			"evt-budget-approved",
		]
		preconditions: ["Histórico recente de aprovações por proponente × Centro de Custo disponível"]
		postconditions: ["Anomaly report + recommendation para revisão humana; nenhum state change"]
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
		code:         "cst-coverage-gate-mandatory"
		name:         "Coverage Gate Mandatory"
		description:  "act-execute-coverage-gate NUNCA emite evt-budget-approved sem Gate de Cobertura ter verificado Saldo Disponível ≥ valor solicitado E valor ≤ Alçada do agente."
		verification: "Runner verifica que para cada evt-budget-approved emitido, audit trail contém: (a) snapshot de prj-cost-center-availability com Saldo Disponível ≥ amount; (b) referência à Alçada vigente com valor ≤ limite da Alçada. Aprovação sem ambos snapshots bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-coverage-gate-deterministic. enforcementLevel: agent (gate pré-emissão consulta projeção + tabela) + domain (handler de cmd-approve-budget no agg-cost-center re-valida atomicamente para prevenir race com aprovação concorrente). Sem gate determinístico, compromissos progridem para DLV/INV/FCE sem lastro orçamentário (inadimplência programática) — bd-coverage-as-invariant."
	}, {
		code:         "cst-cost-center-required-and-identified"
		name:         "Cost Center Required and Identified"
		description:  "act-execute-coverage-gate NUNCA registra Comprometimento sem Centro de Custo identificado e válido. Compromissos cujo Centro de Custo é ambíguo são escalados via supervisedDecision approve-budget-with-cost-center-ambiguity, não aprovados autonomamente."
		verification: "Runner verifica que para cada evt-budget-approved, costCenterId.value é não-vazio E corresponde a Centro de Custo válido na configuração externa vigente no momento da aprovação. Aprovação sem Centro de Custo identificado bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-cost-center-required. enforcementLevel: agent (act-identify-cost-center é gate pré-coverage) + external (configuração de Centros de Custo é mantida fora do BDG; agente consulta). bd-cost-center-as-sot exige unidade canônica de Comprometimento — sem ela controle orçamentário regride a agregações ad-hoc."
	}, {
		code:         "cst-alcada-respected-autonomous"
		name:         "Alcada Respected Autonomously"
		description:  "act-execute-coverage-gate NUNCA aprova autonomamente compromisso cujo valor excede Alçada do agente. Aprovação fora de Alçada é supervisedDecision (approve-budget-out-of-alcada) que requer autorização humana."
		verification: "Runner verifica que para cada evt-budget-approved emitido autonomamente (sem approver-id humano em audit trail), amount ≤ alcada-limite vigente do agente. Aprovação autônoma fora de Alçada bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-alcada-respected. enforcementLevel: agent (validação in-line antes de submit do command) + external (tabela de Alçadas é configuração externa fora do BDG BC; agente consulta). Aprovação fora de Alçada por agente viola mech-agent-gate e P10 — promovido para humano via escalation routing."
	}, {
		code:         "cst-commitment-not-payment"
		name:         "Commitment Not Payment"
		description:  "Agente NUNCA consulta TCM (caixa) durante aprovação orçamentária nem dispara execução em FCE. BDG controla comprometimento prospectivo; pagamento efetivo é responsabilidade de FCE."
		verification: "Runner verifica que audit trail de act-execute-coverage-gate NÃO contém referência a TCM (queries de caixa, eventos de TCM) nem comandos para FCE. Mistura é detectável por inspeção de operationalScope + payload de eventos consumidos."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-commitment-not-payment. enforcementLevel: agent (operationalScope NÃO inclui aggregates/commands de TCM/FCE — schema-level guard) + domain (command handlers de cmd-approve-budget não acessam TCM/FCE por design). bd-commitment-not-payment: misturar acumularia em BDG responsabilidade de TCM e FCE — drift para 'BC Deus' financeiro."
	}, {
		code:         "cst-allocation-not-autonomous"
		name:         "Allocation Not Autonomous"
		description:  "Agente NUNCA realoca orçamento entre Centros de Custo autonomamente. Ajustes de Limite por Centro de Custo (aumento ou redução) são supervisedDecisions externos ao escopo operacional do agente."
		verification: "Runner verifica que agente NÃO emite commands de mutação sobre Limite de Centro de Custo (cmd inexistente em operationalScope.commands) nem aprova compromissos que excedam Limite vigente — Saldo Disponível negativo é cenário bloqueado por cst-coverage-gate-mandatory."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-allocation-not-treasury. enforcementLevel: agent (operationalScope NÃO declara command de ajuste de Limite — schema-level guard) + external (alocação estratégica vive em planejamento financeiro fora do BDG BC). Decidir quanto cada Centro de Custo recebe pertence à diretoria financeira, não ao agente."
	}, {
		code:         "cst-released-amount-matches-commitment"
		name:         "Released Amount Matches Commitment"
		description:  "act-propose-budget-commitment-release NUNCA propõe liberação cujo valor difere do valor reservado pelo Comprometimento referenciado. BudgetCommitmentId é obrigatório na referência; valor é derivado, não fornecido."
		verification: "Runner verifica que recommendation gerada por act-propose-budget-commitment-release referencia BudgetCommitmentId existente em agg-cost-center E o releasedAmount é exatamente o amount original do Comprometimento referenciado. Liberação com valor divergente bloqueia recommendation."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-released-amount-matches-commitment. enforcementLevel: domain (handler de cmd-release-budget-commitment no agg-cost-center deriva releasedAmount do Comprometimento referenciado — não aceita amount externo). Agente apenas propõe BudgetCommitmentId; valor é função do estado persistido. Garante invariante Saldo Disponível = Limite − Σ(comprometimentos ativos) sem drift numérico."
	}, {
		code:         "cst-commitment-id-uniqueness-per-cost-center"
		name:         "Commitment ID Uniqueness Per Cost Center"
		description:  "act-execute-coverage-gate NUNCA registra novo Comprometimento Orçamentário ATIVO para CommitmentId que já tem Comprometimento ATIVO em agg-cost-center. Re-aprovação requer liberação prévia."
		verification: "Runner verifica que handler de cmd-approve-budget consulta agg-cost-center por CommitmentId ANTES de registrar; se Comprometimento ATIVO existe, command é rejeitado. Histórico de Comprometimentos liberados (status=released) NÃO bloqueia (BudgetCommitmentIds distintos preservados)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-commitment-id-uniqueness-per-cost-center. enforcementLevel: domain (lookup atômico no agg-cost-center antes de registrar — handler do command é o gate). Idempotência ao nível de compromisso previne double-booking que inflaria comprometimento agregado contra o Centro de Custo. Sustenta cálculo correto de Saldo Disponível."
	}, {
		code:         "cst-release-and-out-of-alcada-require-supervision"
		name:         "Release and Out-of-Alcada Require Supervision"
		description:  "act-propose-budget-commitment-release e aprovações fora de Alçada NUNCA materializam state change sem aprovação humana em Phase 0."
		verification: "Runner verifica que para cada evt-budget-commitment-released emitido E para cada evt-budget-approved emitido com amount > alcada-limite vigente, audit trail contém approval timestamp + approver-id ANTES de emitir o event. autonomyLevel propose-and-wait é hard gate."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: (operacional, sustenta canvas supervisedDecisions approve-budget-out-of-alcada + adjust-cost-center-limit + propor liberação pendente oq-bdg-2). enforcementLevel: agent (autonomyLevel propose-and-wait declarado no spec). Liberação afeta Saldo Disponível e cadeia downstream (CMT consume); override de Alçada excede authority autônoma — irreversíveis operacionalmente exigem human gate Phase 0."
	}]

	// =============================================
	// ESCALATION CONDITIONS (when to halt and escalate)
	// =============================================
	//
	// Default global. Per-action override Phase 0 documentado em
	// rationale de actions críticas quando criticality diverge
	// significativamente do global.

	escalationConditions: [{
		category:    "conflicting-signals"
		description: "Configuração de Centro de Custo divergente entre fontes (e.g., escopo CMT aponta para Centro X, configuração externa associa o tipo de operação a Centro Y) OR mudança em curso de plano de Centros de Custo afetando aprovação em andamento."
		rationale:   "Cobertura tq-ag-10 para mutations (act-execute-coverage-gate, act-propose-budget-commitment-release). Sem escalation, agente operaria com autonomia implícita ilimitada em divergência de configuração — viola P10."
	}, {
		category:    "insufficient-context"
		description: "prj-cost-center-availability indisponível ou stale durante avaliação; tabela de Alçadas não acessível; configuração de Centros de Custo em janela de transição (as-bdg-3 invalidation signal)."
		rationale:   "Cobertura tq-ag-10 para mutations. Indisponibilidade de SoT crítica exige fallback humano ou postergação — não é caso para outcome rejected automático (rejeição implicaria conclusão definitiva de ausência de cobertura, não falta de visibilidade)."
	}, {
		category:    "ambiguous-case"
		description: "Centro de Custo aplicável a um compromisso é ambíguo — escopo cobre múltiplos Centros, OR Centro indicado conflita com escopo declarado em CMT (canvas supervisedDecision approve-budget-with-cost-center-ambiguity)."
		rationale:   "Cobertura tq-ag-10. Caso intermediário entre identificação determinística (as-bdg-1) e impossibilidade de identificação — ambiguidade exige julgamento humano sobre qual Centro responde."
	}, {
		category:    "out-of-scope"
		description: "Aprovação fora de Alçada do agente (canvas supervisedDecision approve-budget-out-of-alcada) OR ajuste de Limite de Centro de Custo solicitado (canvas supervisedDecision adjust-cost-center-limit, fora do escopo operacional do agente per inv-allocation-not-treasury) OR liberação de Comprometimento com trigger cross-BC ainda não formalizado (oq-bdg-2)."
		rationale:   "Cobertura tq-ag-10. Operações fora da autoridade autônoma do agente são escaladas por design — não há autonomia para override de Alçada ou realocação."
	}, {
		category:    "suspicious-input"
		description: "Padrão de Fracionamento detectado por act-detect-fragmentation-pattern — múltiplos compromissos sub-threshold do mesmo proponente, mesmo Centro de Custo, em janela curta (canvas escalationCriteria fragmentation-pattern-detected)."
		rationale:   "Threshold gaming é vetor adversarial conhecido per canvas incentiveAnalysis (sh-01 manipulationVector). Detecção exige decisão humana sobre consequência — agregação retroativa, revogação ou ajuste de regra. Coordenação com REW pendente (oq-bdg-1)."
	}, {
		category:    "unclassifiable-anomaly"
		description: "Compromisso envolve estrutura orçamentária em zona cinza fiscal ou regulatória — Centro de Custo associado a operação tributária não rotineira, comprometimento que pode requerer reporte específico (canvas escalationCriteria regulatory-or-fiscal-ambiguity)."
		rationale:   "Integridade legal é constraint inviolável (nível 1). Zona cinza exige julgamento humano especializado — compliance officer ou controller designado."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Canvas BDG declara purpose, capabilities (cap-04 auditoria contínua, cc-03 24/7 via gate determinístico), businessDecisions (bd-coverage-as-invariant, bd-commitment-not-payment, bd-cost-center-as-sot, bd-allocation-not-treasury), governance scope (autonomous + supervised + escalation criteria), incentive analysis (sh-01/sh-05 vetores adversariais). Slices necessários para operar gate de cobertura, escalations supervisionadas e reconciliação cross-BC."
			requiredSlices: [
				"ownership",
				"governanceScope",
				"capabilities",
				"communication",
				"incentiveAnalysis",
			]
		}, {
			artifactType: "domain-model"
			rationale:    "Source of truth para operationalScope refs (1 aggregate, 3 commands, 4 events, 7 invariants, 2 projections). Necessário para cada action validar domainModelRefs ⊆ operationalScope per tq-ag-02."
		}, {
			artifactType: "glossary"
			rationale:    "Terminologia canônica do BC BDG (Centro de Custo, Saldo Disponível, Limite, Comprometimento Orçamentário, Alçada, Aprovação Orçamentária, Gate de Cobertura, Liberação, Fracionamento — 15 terms). Action names + audit trail field semantics + rationale alinham com glossary."
			requiredSlices: ["terms"]
		}, {
			artifactType: "agent-governance"
			rationale:    "Envelope bdg-primary-agent.governance.cue declara autonomyOverrides atuais, escalationRouting (channel + SLA + recipient por category), blastRadiusCaps, calibration (promotion/regression criteria), driftDetection. Agent consulta envelope para resolver QUANDO escalar (do spec) → COMO escalar (do envelope)."
		}, {
			artifactType: "context-map"
			rationale:    "BDG integra cross-BC: CMT (consume CommitmentAccepted spine + BudgetRejected pendente oq-bdg-2), DLV (consume BudgetApproved spine), DRC (consume BudgetRejected pendente oq-bdg-2), FCE (consume BudgetCommitmentReleased pendente oq-bdg-2). Context map slice de relationships informa contracts e identifica pendências de formalização."
			requiredSlices: ["relationships"]
		}]
		estimatedBudget: "moderate"
	}

	// =============================================
	// OBSERVABILITY
	// =============================================

	observability: {
		signals: [{
			code:           "sig-mutation-executed"
			name:           "Mutation Executed"
			description:    "Sinal emitido após command processado (post-approval em propose-and-wait). Cobertura: act-execute-coverage-gate (outcome approved/rejected), act-propose-budget-commitment-release (post-approval)."
			coversCategory: "mutation"
			trigger:        "Imediatamente após state transition em agg-cost-center + emit event"
			level:          "info"
		}, {
			code:           "sig-validation-result"
			name:           "Validation Result"
			description:    "Sinal emitido após act-identify-cost-center e act-validate-commitment-scope. Reporta outcome (success/ambiguity/failure) + rationale técnico."
			coversCategory: "validation"
			trigger:        "Após validação concluída"
			level:          "info"
		}, {
			code:           "sig-generation-result"
			name:           "Generation Result"
			description:    "Sinal emitido após act-generate-budget-decision-rationale. Reporta rationale estruturado anexado ao audit trail e payload do event de decisão."
			coversCategory: "generation"
			trigger:        "Após geração de rationale concluída"
			level:          "info"
		}, {
			code:           "sig-escalation-triggered"
			name:           "Escalation Triggered"
			description:    "Sinal emitido quando qualquer escalationCondition dispara. Captura category + rationale + action que disparou + recommendation se aplicável."
			coversCategory: "escalation"
			trigger:        "EscalationCondition disparada (any category)"
			level:          "warn"
		}, {
			code:           "sig-query-served"
			name:           "Query Served"
			description:    "Sinal emitido após cada query atendida. Cobertura: act-query-budget-approval-status, act-query-cost-center-availability."
			coversCategory: "query"
			trigger:        "Após retorno de query consumida por CMT/DRC/controllers/supervisores"
			level:          "info"
		}, {
			code:           "sig-supervision-requested"
			name:           "Supervision Requested"
			description:    "Sinal emitido quando autonomyLevel propose-and-wait gera recommendation aguardando aprovação humana. Cobertura: act-execute-coverage-gate (Phase 0), act-propose-budget-commitment-release."
			coversCategory: "mutation"
			trigger:        "Recommendation criada, aguardando aprovação"
			level:          "info"
		}, {
			code:           "sig-constraint-violation"
			name:           "Constraint Violation"
			description:    "Sinal emitido quando onViolation block-and-escalate ativada em qualquer constraint. Captura constraint code + invariant origem + violation context."
			coversCategory: "mutation"
			trigger:        "Constraint violation detectada"
			level:          "error"
		}, {
			code:           "sig-budget-decision-emitted"
			name:           "Budget Decision Emitted"
			description:    "Sinal BDG-specific emitido após decisão registrada (BudgetApproved ou BudgetRejected). Captura commitmentId, costCenterId, amount, outcome (approved/rejected), reason (quando rejected), saldo consultado pré-decisão, alçada aplicada. Permite reconstrução do gate independente do agent log para auditoria contínua (cap-04)."
			coversCategory: "mutation"
			trigger:        "Decisão materializada e event publicado"
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
				"commitment-id",
				"cost-center-id",
				"budget-commitment-id",
				"available-balance-snapshot",
				"alcada-applied",
			]
			storageHint: "Event Log imutável do BDG com retention regulatory-grade (mínimo 5 anos per Bacen) — cada solicitação, decisão e liberação é fato imutável referenciável por outros SoTs (CMT, FCE, DRC) via CommitmentId. Audit trail do agente em partição dedicada."
			rationale:   "7 mínimos cobrem reconstituição genérica (timestamp/agent-id/action-code/input-summary/output-summary/decision-rationale/governance-version). 5 BDG-specific cobrem reconstituição de contexto específica do BC: commitment-id vincula audit ao compromisso CMT (root para reconciliação cross-BC); cost-center-id sustenta inv-cost-center-required auditável; budget-commitment-id é root identity de Comprometimento (null para queries/validations sem registro); available-balance-snapshot sustenta inv-coverage-gate-deterministic (Saldo no momento da decisão é evidência reproduzível do gate); alcada-applied sustenta inv-alcada-respected auditável (qual faixa de Alçada vigente foi consultada). Audit reconstrutível (teste canônico): dado o registro, é possível reconstituir inputs + decisão + rationale + outcome — sustenta cap-04 auditoria contínua."
		}
	}

	rationale: """
		BDG é gate de cobertura orçamentária do commitment lifecycle —
		consome CommitmentAccepted de CMT e publica BudgetApproved
		para DLV (spine commitment-lifecycle no context-map).
		agt-bdg-primary é o operador único deste BC: executa Gate de
		Cobertura determinístico (Saldo Disponível em Centro de Custo
		identificado + Alçada satisfeita), registra Comprometimento
		Orçamentário no agg-cost-center, publica decisões e propõe
		(sob supervisão) Liberação de Comprometimento.

		Spec ↔ Governance separation per ADR-037: este spec declara
		CAPACIDADE operacional + QUANDO escalar; envelope (bdg-primary-
		agent.governance.cue, par sequencial) declara AUTONOMIA atual
		via promotion criteria + autonomyOverrides intermediários +
		COMO escalar (channel/SLA/recipient).

		Princípio canônico (post-founder review 2026-05-01):
		Phase 0 baseline TODAS mutations propose-and-wait, mesmo
		actions deterministic-gated (act-execute-coverage-gate,
		act-propose-budget-commitment-release). Canvas autonomous-
		Decisions (verify-coverage-deterministic, evaluate-alcada-
		deterministic, register-budget-commitment, publish-decision-
		events) significam "não exigem julgamento humano (gate
		determinístico)", NÃO "execução sem governança". Promotion
		para execute-and-log dessas 2 mutation actions propose-and-
		wait é decisão do envelope.governance via promotion criteria
		+ métricas (budget-approval-time, supervisor-override-rate)
		+ rollback automático per failureHandling — preserva P10
		(gates determinísticos validam, agentes recomendam dentro do
		envelope de autonomia governado). tq-gv-14 bloqueia override
		execute-and-log direto; envelope poderá declarar promotion
		path com intermediários (collect-and-report, propose-and-wait
		com fast-track) sem violar P10.

		Decide-vs-execute pattern (tq-agg-09) em Phase 0:
		Para mutations com impacto irreversível ou cross-BC, o padrão
		decide→execute NÃO é modelado como pares de actions distintos.
		Em vez disso, o gate humano é implementado via autonomyLevel
		"propose-and-wait" — a "decisão" ocorre no momento da aprovação
		humana e a execução é consequência direta dessa aprovação.
		Aplica a:
		- act-propose-budget-commitment-release (trigger cross-BC
		  pendente oq-bdg-2; gate humano hard-required)
		Exceção explícita: act-execute-coverage-gate NÃO segue split
		decide-X/execute-X porque seu outcome é determinístico
		(approved/rejected/ambiguous) a partir do gate (numerical
		comparisons sobre Saldo + Alçada) — não há decisão julgativa
		a separar da execução. Gate é função, não julgamento. Revisão
		futura: após promotion (governance envelope ativo), o padrão
		pode ser reavaliado.

		Canonical removal test (tq-agg-10): SE remover agt-bdg-
		primary, das 7 invariantes:
		- 4 ficam totalmente protegidas por outros enforcers (inv-
		  released-amount-matches-commitment via handler do agg-
		  cost-center que deriva releasedAmount do estado persistido;
		  inv-commitment-id-uniqueness-per-cost-center via lookup
		  atômico no aggregate; inv-commitment-not-payment via
		  schema-level guard — operationalScope sem TCM/FCE; inv-
		  allocation-not-treasury via schema-level guard — sem
		  command de ajuste de Limite no operationalScope).
		- 3 ficam com cobertura parcial Phase 0 (inv-coverage-gate-
		  deterministic, inv-cost-center-required, inv-alcada-
		  respected) — agente é único enforcer operacional do gate
		  como PROCESSO; mecanismos estruturais (handler atômico no
		  aggregate re-validando saldo, validação de configuração
		  externa de Centros de Custo, gate de Alçada como middleware
		  determinístico) são complementos parciais. Pós-resolução
		  estrutural (oq-bdg-1 detecção cross-BC de Fracionamento;
		  domain-level enforcement do gate como handler atômico),
		  enforcement migra mais para domain.
		NÃO é red flag oculto — é red flag conhecido, declarado em
		canvas (mech-agent-gate é design pattern, não bug), com
		caminho de resolução documentado em openQuestions.

		Phase 0 caveats explícitos:
		- act-propose-budget-commitment-release modela fluxo cujo
		  trigger cross-BC ainda não é formalizado (oq-bdg-2 — bdg→
		  cmt direct relation pendente) — anchor para futura
		  ativação; gate humano hard-required.
		- act-detect-fragmentation-pattern é mecanismo SECUNDÁRIO
		  per canvas — defesa primária estrutural depende de
		  coordenação cross-BC com REW (oq-bdg-1, ainda não
		  formalizada).
		- evt-budget-rejected e evt-budget-commitment-released
		  modelados como published mas propagação direta cross-BC
		  pendente oq-bdg-2 — em Phase 0 servem audit trail interno
		  e anchor para futura ativação; consumers (CMT, DRC)
		  descobrem via query polling (act-query-budget-approval-
		  status) enquanto não declarada relação direta.
		- as-bdg-1 (identificação determinística de Centro de Custo
		  a partir do escopo CMT) é premissa de act-identify-cost-
		  center; se invalidada (taxa de escalação por ambiguidade
		  alta), Gate de Cobertura regride para semi-manual e cc-03
		  fica comprometida.

		Volume catalog: 8 actions (2 mutation actions propose-and-
		wait + 2 queries + 2 validations + 1 generation + 1
		escalation), 8 constraints (7 derivadas 1:1 de invariantes +
		1 operacional sustentando supervision Phase 0), 6 escalation
		conditions (cobertura tq-ag-10 + categorias canvas), 8
		signals (7 canônicos + sig-budget-decision-emitted BDG-
		specific), 12 audit fields (7 mínimos + 5 BDG-specific para
		reconstituição cap-04 auditoria contínua). estimatedBudget
		moderate (5 artifacts, predominantemente same-BC).

		Glossary alignment: action names + signal codes + audit
		field names alinhados com glossary BDG (15 terms). 'Alcada'
		em codes/fields em ASCII per schema regex; 'Alçada' em
		descriptions/rationale em PT-BR per UL local. Sem
		divergências terminológicas identificadas nesta autoria.
		"""
}
