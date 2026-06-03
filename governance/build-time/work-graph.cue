package build_time

// work-graph.cue — Topologia de execução W001-W005.
//
// Define fases (barreiras de execução), grupos (agrupamento lógico)
// e dependências versionadas por tarefa. Fonte de verdade para
// elegibilidade de execução junto com task-governance.cue.
//
// Phase 0 do sistema de governança: fases e dependências existem,
// eventos e claims não. Agente computa ready-queue manualmente
// a partir deste grafo.
//
// Dependência de tipos: #Phase, #Group e #ExecutionDependency são
// definidos em work-governance.cue, mesmo package build_time.
// Este arquivo é instância; work-governance.cue é schema.
// Validação deve rodar no package inteiro
// (cue vet ./governance/build-time/), nunca neste arquivo isolado.
// Mover este arquivo para outro package exige import explícito.

workGraph: {
	rationale: "Topologia de execução W001-W005. W001 (foundation): 4 fases de domínio progressivas por order, 2 fases de governança com dependsOnPhases explícito, 1 fase de correção ontológica independente, 1 fase de BC bootstrap. W002 (DDD strategic & meta): p6 independente. W003 (cross-context flows): p7 depende de p5. W004 (C4): p8 depende de p5+p9. W005 (stack): p9 depende de p6 (Conway informa stack)."

	phases: [#Phase & {
		id:        "p0-validate-and-bootstrap"
		order:     0
		rationale: "Validações de artefatos existentes e criação de schemas sem dependências. Quick wins que estabelecem baseline de conformidade e habilitam instâncias nas fases seguintes."
	}, #Phase & {
		id:        "p1-domain-identity"
		order:     1
		rationale: "Identidade do domínio (domain-definition.cue). Fase própria porque é L-size e não deve bloquear schemas e validações que não dependem dela."
	}, #Phase & {
		id:        "p2-strategic-layer"
		order:     2
		rationale: "Camada estratégica: subdomínios e context-map. Dependem de domain-identity (fase 1) e schemas criados em fase 0."
	}, #Phase & {
		id:        "p3-tactical-and-validation"
		order:     3
		rationale: "Primeiro BC canvas e validation prompts. Convergem dependências de todas as fases anteriores."
	}, #Phase & {
		id:              "pg1-governance-enforcement"
		order:           4
		dependsOnPhases: []
		rationale:       "CI validation de work-events e projeções complementares. Independente de phases de domínio — enforcement pode avançar em paralelo com domain work."
	}, #Phase & {
		id:              "pg2-governance-robustness"
		order:           5
		dependsOnPhases: ["pg1-governance-enforcement"]
		rationale:       "Extensões de robustez (claim expiration, completion gates, drift detection) que dependem da infraestrutura CI criada em pg1."
	}, #Phase & {
		id:              "p4-ontology-correction"
		order:           6
		dependsOnPhases: []
		rationale:       "Correção de ontologia raiz: domain-definition incompleto contaminou subdomínios, context map e canvas existentes. Cadeia linear WI-036→037→038→039. Independente de phases de governança — correção de domínio pode avançar em paralelo."
	}, #Phase & {
		id:              "p5-bc-domain-bootstrap"
		order:           7
		dependsOnPhases: []
		rationale:       "Bootstrap de artefatos de domínio para 23 BCs restantes. Independente de phases de governança. Dependências reais são por WI (schemas + golden examples + inter-BC), não por phase barrier — permite início assim que padrões CMT/CTR estejam estabelecidos."
	}, #Phase & {
		id:              "p6-strategic-completion"
		order:           8
		dependsOnPhases: []
		rationale:       "W002 — DDD strategic & meta completion. Independente de outras phases; pode avançar paralelo a p5 bootstrap. Output (Conway/Team Topology) informa p9 stack definition."
	}, #Phase & {
		id:              "p9-stack-definition"
		order:           9
		dependsOnPhases: ["p6-strategic-completion"]
		rationale:       "W005 — Stack definition. Depende de p6 porque Conway alignment (WI-116) informa stack choices: team topology constrains architecture choice (Skelton/Pais). Stack keystone-first per adr-139: adr-140 (codegen/contracts) + adr-141 (kernel/Port contracts + topologia lógica); seleção de vendor/runtime deferida (def-040..045), materializada JIT."
	}, #Phase & {
		id:              "p7-cross-context-workflows-expansion"
		order:           10
		dependsOnPhases: ["p5-bc-domain-bootstrap"]
		rationale:       "W003 — Cross-context-workflows expansion. Depende de p5 BC bootstrap porque flows referenciam aggregates + integration events dos BCs envolvidos. Sem BCs instanciados, flows seriam place-holders não-verificáveis."
	}, #Phase & {
		id:              "p8-c4-architecture"
		order:           11
		dependsOnPhases: ["p5-bc-domain-bootstrap", "p9-stack-definition"]
		rationale:       "W004 — C4 architecture. Depende de p5 (L3 per BC refere domain-model dos BCs) + p9 (L2 reflete container topology que depende de stack choices). L1 sozinho seria stack-agnóstico, mas wave está unificada para coherência."
	}]

	groups: [#Group & {
		id:        "g0-validations"
		phaseId:   "p0-validate-and-bootstrap"
		rationale: "Validações de artefatos pré-existentes. Todas S-size, sem dependências."
	}, #Group & {
		id:        "g0-schemas"
		phaseId:   "p0-validate-and-bootstrap"
		rationale: "Schemas novos sem dependências. Habilitam instâncias nas fases seguintes."
	}, #Group & {
		id:        "g1-domain"
		phaseId:   "p1-domain-identity"
		rationale: "domain-definition.cue — artefato fundacional de identidade do domínio."
	}, #Group & {
		id:        "g2-subdomains"
		phaseId:   "p2-strategic-layer"
		rationale: "Instâncias de subdomínios. Dependem de domain-definition (identidade) e schema #Subdomain (estrutura)."
	}, #Group & {
		id:        "g2-topology"
		phaseId:   "p2-strategic-layer"
		rationale: "Context-map — topologia de integração entre BCs. Depende de subdomínios."
	}, #Group & {
		id:        "g3-first-bc"
		phaseId:   "p3-tactical-and-validation"
		rationale: "Primeiro BC canvas (CMT — Economic Commitment Lifecycle)."
	}, #Group & {
		id:        "g3-validation-prompts"
		phaseId:   "p3-tactical-and-validation"
		rationale: "Validation prompts para os artefatos mais críticos da wave."
	}, #Group & {
		id:        "g3-tactical-schemas"
		phaseId:   "p3-tactical-and-validation"
		rationale: "Schemas táticos derivados do primeiro BC canvas. Dependem de canvas como input para design do shape — dependência de descoberta, não apenas formal."
	}, #Group & {
		id:        "g3-tactical-instances"
		phaseId:   "p3-tactical-and-validation"
		rationale: "Instâncias táticas: glossários, agent specs, domain models, stakeholder maps. Materializam artefatos concretos sobre schemas definidos."
	}, #Group & {
		id:        "g3-tactical-integration"
		phaseId:   "p3-tactical-and-validation"
		rationale: "Wiring e validação cross-artifact: alinhamento de refs no context-map, runners de validação, correções de canvas e envelopes de governança."
	}, #Group & {
		id:        "g4-governance-ci"
		phaseId:   "pg1-governance-enforcement"
		rationale: "CI validation de work-events e projeções de visibilidade."
	}, #Group & {
		id:        "g5-governance-robustness"
		phaseId:   "pg2-governance-robustness"
		rationale: "Extensões de robustez: claim expiration, completion gates, drift detection."
	}, #Group & {
		id:        "g6-ontology-correction"
		phaseId:   "p4-ontology-correction"
		rationale: "Correção de ontologia raiz: domain-definition, subdomínios, context map e canvas. Cadeia linear com dependências explícitas."
	}, #Group & {
		id:        "g7-core-bc-bootstrap"
		phaseId:   "p5-bc-domain-bootstrap"
		rationale: "BCs core: proposta de valor direta da rede. Prioridade de execução por impacto. 5 BCs: DLV, FCE, NGR, NIM, REW."
	}, #Group & {
		id:        "g7-supporting-bc-bootstrap"
		phaseId:   "p5-bc-domain-bootstrap"
		rationale: "BCs supporting: habilitam operações do core. 15 BCs. Executáveis em paralelo do ponto de vista das dependências inter-BC após schemas disponíveis."
	}, #Group & {
		id:        "g7-generic-bc-bootstrap"
		phaseId:   "p5-bc-domain-bootstrap"
		rationale: "BCs generic: capabilities transversais. 3 BCs: BKR, NTF, STR. Menor prioridade — shape mais estável, menor risco de redesign."
	}, #Group & {
		id:        "g7-interaction-surfaces"
		phaseId:   "p5-bc-domain-bootstrap"
		rationale: "Superfícies de interação (events.cue + api/async-api) derivadas do domain-model dos BCs do slice CMT/DLV/INV. Camada de contratos e tipos — posterior ao bootstrap de domínio do mesmo BC."
	}, #Group & {
		id:        "g8-discovery-and-method"
		phaseId:   "p6-strategic-completion"
		rationale: "W002 — BC discovery method, volatility analysis, splits/merges governance, event storming canonical schema + golden example."
	}, #Group & {
		id:        "g8-tier-and-ownership"
		phaseId:   "p6-strategic-completion"
		rationale: "W002 — Strategic ADR tier classification, Domain Expert canonical per BC, Team Topology/Conway alignment ADR + lens."
	}, #Group & {
		id:        "g8-stability-and-evolution"
		phaseId:   "p6-strategic-completion"
		rationale: "W002 — Aggregate identity stability ADR, UL drift detection check, Strategic refactoring discipline ADR."
	}, #Group & {
		id:        "g9-flows-inventory"
		phaseId:   "p7-cross-context-workflows-expansion"
		rationale: "W003 — ADR de inventário formal + roadmap de cross-context-flows candidatos."
	}, #Group & {
		id:        "g9-flows-instances"
		phaseId:   "p7-cross-context-workflows-expansion"
		rationale: "W003 — 6 cross-context-flow instances (settlement, refund-and-reward, dispute-resolution, onboarding-and-credit, tax-and-accounting, insurance-coverage)."
	}, #Group & {
		id:        "g10-c4-foundation"
		phaseId:   "p8-c4-architecture"
		rationale: "W004 — ADR generation strategy, schemas C4 (Workspace/View/Element/Relationship), ADR container topology."
	}, #Group & {
		id:        "g10-c4-instances"
		phaseId:   "p8-c4-architecture"
		rationale: "W004 — Instâncias C4: L1 (system context), L2 (containers), L3 per BC (10 instâncias para BCs existentes)."
	}, #Group & {
		id:        "g10-c4-tooling"
		phaseId:   "p8-c4-architecture"
		rationale: "W004 — Codegen script (CUE → Structurizr DSL) + CI drift detection."
	}, #Group & {
		id:        "g11-stack-adrs"
		phaseId:   "p9-stack-definition"
		rationale: "W005 — stack keystone-first per adr-139: adr-140 (codegen/contracts) + adr-141 (kernel/Port contracts + topologia lógica) + quality criteria família tq-stack-NN; vendors/runtime deferidos JIT (def-040..045)."
	}]

	dependencies: [#ExecutionDependency & {
		taskId:    "WI-002"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-validations"
	}, #ExecutionDependency & {
		taskId:    "WI-003"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-validations"
	}, #ExecutionDependency & {
		taskId:    "WI-004"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-schemas"
	}, #ExecutionDependency & {
		taskId:    "WI-005"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-validations"
	}, #ExecutionDependency & {
		taskId:    "WI-006"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-validations"
	}, #ExecutionDependency & {
		taskId:    "WI-011"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-schemas"
	}, #ExecutionDependency & {
		taskId:    "WI-012"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-schemas"
	}, #ExecutionDependency & {
		taskId:    "WI-013"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-schemas"
	}, #ExecutionDependency & {
		taskId:    "WI-021"
		dependsOn: []
		phaseId:   "p0-validate-and-bootstrap"
		groupId:   "g0-schemas"
	}, #ExecutionDependency & {
		taskId: "WI-029"
		dependsOn: [{taskId: "WI-004", version: 1}]
		phaseId: "p0-validate-and-bootstrap"
		groupId: "g0-schemas"
	}, #ExecutionDependency & {
		taskId: "WI-030"
		dependsOn: [{taskId: "WI-004", version: 1}]
		phaseId: "p0-validate-and-bootstrap"
		groupId: "g0-schemas"
	}, #ExecutionDependency & {
		taskId:    "WI-001"
		dependsOn: []
		phaseId:   "p1-domain-identity"
		groupId:   "g1-domain"
	}, #ExecutionDependency & {
		taskId: "WI-007"
		dependsOn: [{taskId: "WI-001", version: 1}, {taskId: "WI-012", version: 1}]
		phaseId: "p2-strategic-layer"
		groupId: "g2-subdomains"
	}, #ExecutionDependency & {
		taskId: "WI-008"
		dependsOn: [{taskId: "WI-007", version: 1}]
		phaseId: "p2-strategic-layer"
		groupId: "g2-topology"
	}, #ExecutionDependency & {
		taskId: "WI-009"
		dependsOn: [
			{taskId: "WI-001", version: 1},
			{taskId: "WI-007", version: 1},
			{taskId: "WI-011", version: 1},
		]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-first-bc"
	}, #ExecutionDependency & {
		taskId: "WI-010"
		dependsOn: [
			{taskId: "WI-001", version: 1},
			{taskId: "WI-009", version: 1},
			{taskId: "WI-013", version: 1},
		]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-validation-prompts"
	}, #ExecutionDependency & {
		taskId:    "WI-014"
		dependsOn: []
		phaseId:   "p3-tactical-and-validation"
		groupId:   "g3-first-bc"
	}, #ExecutionDependency & {
		taskId: "WI-020"
		dependsOn: [{taskId: "WI-009", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-schemas"
	}, #ExecutionDependency & {
		taskId: "WI-022"
		dependsOn: [{taskId: "WI-009", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-schemas"
	}, #ExecutionDependency & {
		taskId: "WI-027"
		dependsOn: [{taskId: "WI-009", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-schemas"
	}, #ExecutionDependency & {
		taskId: "WI-023"
		dependsOn: [{taskId: "WI-009", version: 1}, {taskId: "WI-021", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-instances"
	}, #ExecutionDependency & {
		taskId: "WI-024"
		dependsOn: [{taskId: "WI-009", version: 1}, {taskId: "WI-022", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-instances"
	}, #ExecutionDependency & {
		taskId: "WI-025"
		dependsOn: [{taskId: "WI-020", version: 1}, {taskId: "WI-023", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-instances"
	}, #ExecutionDependency & {
		taskId: "WI-028"
		dependsOn: [{taskId: "WI-022", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-instances"
	}, #ExecutionDependency & {
		taskId: "WI-031"
		dependsOn: [{taskId: "WI-029", version: 1}, {taskId: "WI-001", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-instances"
	}, #ExecutionDependency & {
		taskId: "WI-026"
		dependsOn: [{taskId: "WI-024", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-integration"
	}, #ExecutionDependency & {
		taskId: "WI-032"
		dependsOn: [{taskId: "WI-020", version: 1}, {taskId: "WI-021", version: 1}, {taskId: "WI-022", version: 1}, {taskId: "WI-025", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-integration"
	}, #ExecutionDependency & {
		taskId: "WI-034"
		dependsOn: [{taskId: "WI-009", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-integration"
	}, #ExecutionDependency & {
		taskId: "WI-035"
		dependsOn: [{taskId: "WI-024", version: 1}, {taskId: "WI-028", version: 1}]
		phaseId: "p3-tactical-and-validation"
		groupId: "g3-tactical-integration"
	}, #ExecutionDependency & {
		taskId:    "WI-015"
		dependsOn: []
		phaseId:   "pg1-governance-enforcement"
		groupId:   "g4-governance-ci"
	}, #ExecutionDependency & {
		taskId:    "WI-016"
		dependsOn: []
		phaseId:   "pg1-governance-enforcement"
		groupId:   "g4-governance-ci"
	}, #ExecutionDependency & {
		taskId: "WI-017"
		dependsOn: [{taskId: "WI-015", version: 1}]
		phaseId: "pg2-governance-robustness"
		groupId: "g5-governance-robustness"
	}, #ExecutionDependency & {
		taskId: "WI-018"
		dependsOn: [{taskId: "WI-015", version: 1}]
		phaseId: "pg2-governance-robustness"
		groupId: "g5-governance-robustness"
	}, #ExecutionDependency & {
		taskId: "WI-019"
		dependsOn: [{taskId: "WI-016", version: 1}]
		phaseId: "pg2-governance-robustness"
		groupId: "g5-governance-robustness"
	}, #ExecutionDependency & {
		taskId:    "WI-033"
		dependsOn: []
		phaseId:   "p3-tactical-and-validation"
		groupId:   "g3-tactical-integration"
	}, #ExecutionDependency & {
		taskId:    "WI-065"
		dependsOn: []
		phaseId:   "pg2-governance-robustness"
		groupId:   "g5-governance-robustness"
	}, #ExecutionDependency & {
		taskId:    "WI-036"
		dependsOn: []
		phaseId:   "p4-ontology-correction"
		groupId:   "g6-ontology-correction"
	}, #ExecutionDependency & {
		taskId: "WI-037"
		dependsOn: [{taskId: "WI-036", version: 1}]
		phaseId: "p4-ontology-correction"
		groupId: "g6-ontology-correction"
	}, #ExecutionDependency & {
		taskId: "WI-038"
		dependsOn: [{taskId: "WI-037", version: 1}]
		phaseId: "p4-ontology-correction"
		groupId: "g6-ontology-correction"
	}, #ExecutionDependency & {
		taskId: "WI-039"
		dependsOn: [{taskId: "WI-038", version: 1}]
		phaseId: "p4-ontology-correction"
		groupId: "g6-ontology-correction"
	}, #ExecutionDependency & {
		taskId: "WI-040"
		dependsOn: [{taskId: "WI-037", version: 1}]
		phaseId: "p4-ontology-correction"
		groupId: "g6-ontology-correction"
	},

	// ============================================================
	// Phase p5: BC domain bootstrap (WI-042 a WI-064)
	// ============================================================
	#ExecutionDependency & {
		taskId: "WI-042" // DLV
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-core-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-043" // FCE
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
			{taskId: "WI-046", version: 1},
			{taskId: "WI-053", version: 1},
			{taskId: "WI-062", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-core-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-044" // NGR
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
			{taskId: "WI-045", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-core-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-045" // NIM
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-core-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-046" // REW
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-core-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-047" // ATO
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-048" // BDG
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-049" // DRC
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-050" // IDC
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-051" // INS
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
			{taskId: "WI-046", version: 1},
			{taskId: "WI-059", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-052" // ITC
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
			{taskId: "WI-047", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-053" // INV
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-054" // LOG
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-055" // NPM
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-056" // OBS
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-057" // P2P
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-058" // PLT
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-059" // SCF
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
			{taskId: "WI-046", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-060" // SSC
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-061" // TCM
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-supporting-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-062" // BKR
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-generic-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-063" // NTF
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-generic-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-064" // STR
		dependsOn: [
			{taskId: "WI-009", version: 1},
			{taskId: "WI-011", version: 1},
			{taskId: "WI-020", version: 1},
			{taskId: "WI-021", version: 1},
			{taskId: "WI-022", version: 1},
			{taskId: "WI-028", version: 1},
		]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-generic-bc-bootstrap"
	}, #ExecutionDependency & {
		taskId: "WI-070" // Economic Foundation Layers
		dependsOn: [
			{taskId: "WI-053", version: 1},
		]
		phaseId: "p0-validate-and-bootstrap"
		groupId: "g0-schemas"
	}, #ExecutionDependency & {
		taskId:    "WI-071" // Rebuild projections script
		dependsOn: []
		phaseId:   "pg2-governance-robustness"
		groupId:   "g5-governance-robustness"
	},

	// ============================================================
	// Phase p6: W002 strategic completion (WI-110..113, WI-114..119)
	// ============================================================
	#ExecutionDependency & {
		taskId:    "WI-110"
		dependsOn: []
		phaseId:   "p6-strategic-completion"
		groupId:   "g8-discovery-and-method"
	}, #ExecutionDependency & {
		taskId: "WI-111"
		dependsOn: [{taskId: "WI-110", version: 1}]
		phaseId: "p6-strategic-completion"
		groupId: "g8-discovery-and-method"
	}, #ExecutionDependency & {
		taskId: "WI-112"
		dependsOn: [{taskId: "WI-111", version: 1}]
		phaseId: "p6-strategic-completion"
		groupId: "g8-discovery-and-method"
	}, #ExecutionDependency & {
		taskId: "WI-113"
		dependsOn: [{taskId: "WI-110", version: 1}]
		phaseId: "p6-strategic-completion"
		groupId: "g8-discovery-and-method"
	}, #ExecutionDependency & {
		taskId:    "WI-114"
		dependsOn: []
		phaseId:   "p6-strategic-completion"
		groupId:   "g8-tier-and-ownership"
	}, #ExecutionDependency & {
		taskId:    "WI-115"
		dependsOn: []
		phaseId:   "p6-strategic-completion"
		groupId:   "g8-tier-and-ownership"
	}, #ExecutionDependency & {
		taskId: "WI-116"
		dependsOn: [{taskId: "WI-115", version: 1}]
		phaseId: "p6-strategic-completion"
		groupId: "g8-tier-and-ownership"
	}, #ExecutionDependency & {
		taskId: "WI-117"
		dependsOn: [{taskId: "WI-112", version: 1}]
		phaseId: "p6-strategic-completion"
		groupId: "g8-stability-and-evolution"
	}, #ExecutionDependency & {
		taskId:    "WI-118"
		dependsOn: []
		phaseId:   "p6-strategic-completion"
		groupId:   "g8-stability-and-evolution"
	}, #ExecutionDependency & {
		taskId: "WI-119"
		dependsOn: [{taskId: "WI-114", version: 1}]
		phaseId: "p6-strategic-completion"
		groupId: "g8-stability-and-evolution"
	},

	// ============================================================
	// Phase p7: W003 cross-context-workflows (WI-120..126)
	// ============================================================
	#ExecutionDependency & {
		taskId:    "WI-120"
		dependsOn: []
		phaseId:   "p7-cross-context-workflows-expansion"
		groupId:   "g9-flows-inventory"
	}, #ExecutionDependency & {
		taskId: "WI-121"
		dependsOn: [{taskId: "WI-120", version: 1}]
		phaseId: "p7-cross-context-workflows-expansion"
		groupId: "g9-flows-instances"
	}, #ExecutionDependency & {
		taskId: "WI-122"
		dependsOn: [{taskId: "WI-120", version: 1}]
		phaseId: "p7-cross-context-workflows-expansion"
		groupId: "g9-flows-instances"
	}, #ExecutionDependency & {
		taskId: "WI-123"
		dependsOn: [{taskId: "WI-120", version: 1}]
		phaseId: "p7-cross-context-workflows-expansion"
		groupId: "g9-flows-instances"
	}, #ExecutionDependency & {
		taskId: "WI-124"
		dependsOn: [{taskId: "WI-120", version: 1}]
		phaseId: "p7-cross-context-workflows-expansion"
		groupId: "g9-flows-instances"
	}, #ExecutionDependency & {
		taskId: "WI-125"
		dependsOn: [{taskId: "WI-120", version: 1}]
		phaseId: "p7-cross-context-workflows-expansion"
		groupId: "g9-flows-instances"
	}, #ExecutionDependency & {
		taskId: "WI-126"
		dependsOn: [{taskId: "WI-120", version: 1}]
		phaseId: "p7-cross-context-workflows-expansion"
		groupId: "g9-flows-instances"
	},

	// ============================================================
	// Phase p8: W004 C4 architecture (WI-127 + WI-086..101)
	// ============================================================
	#ExecutionDependency & {
		taskId:    "WI-127"
		dependsOn: []
		phaseId:   "p8-c4-architecture"
		groupId:   "g10-c4-foundation"
	}, #ExecutionDependency & {
		taskId: "WI-086"
		dependsOn: [{taskId: "WI-127", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-foundation"
	}, #ExecutionDependency & {
		taskId: "WI-087"
		dependsOn: [
			{taskId: "WI-127", version: 1},
			{taskId: "WI-102", version: 1},
			{taskId: "WI-103", version: 1},
		]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-foundation"
	}, #ExecutionDependency & {
		taskId: "WI-088"
		dependsOn: [{taskId: "WI-086", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-089"
		dependsOn: [
			{taskId: "WI-087", version: 1},
			{taskId: "WI-088", version: 1},
		]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-090" // BDG
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-091" // CMT
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-092" // CTR
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-093" // DLV
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-094" // IDC
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-095" // INV
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-096" // NPM
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-097" // P2P
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-098" // REW
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-099" // SSC
		dependsOn: [{taskId: "WI-089", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-instances"
	}, #ExecutionDependency & {
		taskId: "WI-100"
		dependsOn: [{taskId: "WI-086", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-tooling"
	}, #ExecutionDependency & {
		taskId: "WI-101"
		dependsOn: [{taskId: "WI-100", version: 1}]
		phaseId: "p8-c4-architecture"
		groupId: "g10-c4-tooling"
	},

	// ============================================================
	// Phase p9: W005 stack definition (WI-102, WI-103, WI-109) — per adr-139
	// ============================================================
	#ExecutionDependency & {
		taskId:    "WI-102"
		dependsOn: []
		phaseId:   "p9-stack-definition"
		groupId:   "g11-stack-adrs"
	}, #ExecutionDependency & {
		taskId: "WI-103"
		dependsOn: [{taskId: "WI-102", version: 1}]
		phaseId: "p9-stack-definition"
		groupId: "g11-stack-adrs"
	}, #ExecutionDependency & {
		taskId: "WI-109"
		dependsOn: [
			{taskId: "WI-102", version: 1},
			{taskId: "WI-103", version: 1},
		]
		phaseId: "p9-stack-definition"
		groupId: "g11-stack-adrs"
	},

	// ============================================================
	// Phase p5 (g7-interaction-surfaces): superfícies do slice CMT/DLV/INV
	// (WI-129..131). Backfill — admitidos/executados antes de wiring no grafo.
	// WI-129 dependsOn [] (prereqs CMT domain-model + shared-schemas são
	// baseline anterior ao slice); WI-130←129 (coerência de envelope); WI-131←
	// 130 (consome DeliveryVerified).
	// ============================================================
	#ExecutionDependency & {
		taskId:    "WI-129"
		dependsOn: []
		phaseId:   "p5-bc-domain-bootstrap"
		groupId:   "g7-interaction-surfaces"
	}, #ExecutionDependency & {
		taskId: "WI-130"
		dependsOn: [{taskId: "WI-129", version: 1}]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-interaction-surfaces"
	}, #ExecutionDependency & {
		taskId: "WI-131"
		dependsOn: [{taskId: "WI-130", version: 1}]
		phaseId: "p5-bc-domain-bootstrap"
		groupId: "g7-interaction-surfaces"
	}]
}
