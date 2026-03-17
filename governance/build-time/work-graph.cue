package build_time

// work-graph.cue — Topologia de execução da W001-foundation.
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
	rationale: "Topologia de execução W001. 4 fases progressivas por dependência estrutural, 7 grupos por natureza de artefato."

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
	}]
}
