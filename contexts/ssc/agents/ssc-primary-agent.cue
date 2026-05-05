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
	// ACTIONS (stub — completados em Parte 2)
	// =============================================

	actions: [{
		code:            "act-build-supplier-pool"
		name:            "Build Supplier Pool"
		description:     "Stub minimal — completado em Parte 2 (actions catalog completo: 13 actions)."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-sourcing-process",
		]
	}]

	// =============================================
	// CONSTRAINTS (stub — completados em Parte 2)
	// =============================================

	constraints: [{
		code:         "cst-fitness-rules-deterministic-application"
		name:         "Fitness Rules Deterministic Application"
		description:  "Stub minimal — completado em Parte 2 (8 constraints derivados 1:1 dos invariantes + 1 operacional)."
		verification: "Stub minimal — completado em Parte 2."
		onViolation:  "block-and-escalate"
		rationale:    "Stub para satisfazer #AgentSpec.constraints min-1. derivedFromInvariant: inv-decision-from-structured-signals (RECTOR anti-mini-NIM). Completado em Parte 2."
	}]

	// =============================================
	// ESCALATION CONDITIONS (stub — completados em Parte 2)
	// =============================================

	escalationConditions: [{
		category:    "conflicting-signals"
		description: "Stub minimal — completado em Parte 2 (6 escalation conditions cobrindo tq-ag-10 mutations + 5 categorias canvas)."
		rationale:   "Stub para satisfazer #AgentSpec.escalationConditions min-1 + tq-ag-10 (mutations declaram conflicting-signals). Completado em Parte 2."
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
