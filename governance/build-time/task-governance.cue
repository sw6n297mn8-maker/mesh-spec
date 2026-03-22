package build_time

// task-governance.cue — Regras de execução por template de tarefa.
//
// Source of truth para elegibilidade, aprovação, criticality e lease
// defaults. Ref: ADR-024 (ativação Phase 1), work-governance.cue
// seção sourcesOfTruth.
//
// Escopo: por template. Overrides por task individual são possíveis
// (scope: "task") mas só justificados quando criticality diverge
// materialmente do template. Nesta fase: zero overrides.
// Candidato a override futuro: WI-001 (domain-definition) —
// foundational artifact com blast radius superior à média de
// create-instance.
//
// Nota sobre approvalRequired: nesta fase, toda criação e validação
// relevante continua founder-gated; criticality e lease diferenciam
// urgência e rigor operacional, não necessidade de aprovação.
// approvalRequired poderá diferenciar em Phase 2 quando
// completionValidation com gates determinísticos justificar
// auto-completion para templates de baixo risco.

taskGovernance: [ID=string]: #TaskGovernanceRule

taskGovernance: {
	"tmpl-validate-artifact": #TaskGovernanceRule & {
		scope:                "template"
		templateRef:          "tmpl-validate-artifact@v1"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "low"
		defaultLeaseDuration: "24h"
		rationale:            "Validação não modifica artefatos diretamente e, nesta fase, não tem autoridade de merge ou commit autônomo. Seu blast radius é indireto: findings incorretos podem influenciar decisão, mas não alteram o estado canônico sem novo ciclo de proposta e aprovação."
	}

	"tmpl-create-schema": #TaskGovernanceRule & {
		scope:                "template"
		templateRef:          "tmpl-create-schema@v1"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "Schemas CUE restringem todas as instâncias futuras via cue vet (P1) — erro em schema propaga para cada artefato que unifica com ele. Na Mesh, schemas também governam geração de código (P1: código é gerado, nunca escrito manualmente), amplificando o blast radius."
	}

	"tmpl-create-instance": #TaskGovernanceRule & {
		scope:                "template"
		templateRef:          "tmpl-create-instance@v1"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "medium"
		defaultLeaseDuration: "8h"
		rationale:            "Instâncias são constrangidas pelo artifact schema — risco menor que schema. Self-review (quality-gate.cue) e completionValidation (P10/P11 aplicados ao build-time) adicionam gates antes da proposta ao founder, justificando criticality medium em vez de high."
	}
}
