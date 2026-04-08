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

	"tmpl-create-script": #TaskGovernanceRule & {
		scope:                "template"
		templateRef:          "tmpl-create-script@v1"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "medium"
		defaultLeaseDuration: "8h"
		rationale:            "Script de build/governança (ref adr-042) tem blast radius limitado ao artefato derivado ou ao check que implementa — não propaga para instâncias futuras como schema (high) nem fica isolado como validação (low). Criticality medium alinhada com tmpl-create-instance. Gates de idempotência, reprodutibilidade e atomicidade script↔derivado no template reduzem risco residual antes da proposta ao founder."
	}

	"tmpl-create-convention": #TaskGovernanceRule & {
		scope:                "template"
		templateRef:          "tmpl-create-convention@v1"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "medium"
		defaultLeaseDuration: "8h"
		rationale:            "Convenção cross-artefato (ref adr-046) governa relação entre 2+ tipos já existentes — blast radius é o par de tipos afetados, não o sistema inteiro (schema, high) nem isolado (validação, low). Criticality medium alinhada com tmpl-create-instance e tmpl-create-script. Gates de governedTypes explícitos, upstreamSources canônico, separação determinístico/advisory per adr-040 no template reduzem risco residual antes da proposta ao founder."
	}

	// ────────────────────────────────────────────────────────
	// Overrides por task: BCs com criticality high
	// ────────────────────────────────────────────────────────
	// Dois níveis semânticos dentro de high:
	// - high-regulated-core: controla decisão ou movimento de dinheiro
	//   (FCE, SCF, BKR, REW, IDC)
	// - high-regulated-support: boundary regulatório e obrigação acessória
	//   (ATO, INS, ITC)
	// O schema só aceita "high" como valor formal; a distinção semântica
	// está no rationale de cada override.

	// --- high-regulated-core ---
	"WI-043-fce": #TaskGovernanceRule & {
		scope:                "task"
		taskId:               "WI-043"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "FCE controla liquidação financeira condicionada a gates de risco. Movimento de dinheiro regulado por Bacen/SCD."
	}
	"WI-046-rew": #TaskGovernanceRule & {
		scope:                "task"
		taskId:               "WI-046"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "REW controla decisões de elegibilidade que condicionam liquidação e financiamento. Scoring incorreto gera exposição sistêmica."
	}
	"WI-050-idc": #TaskGovernanceRule & {
		scope:                "task"
		taskId:               "WI-050"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "IDC controla identidade, autorização e integridade criptográfica. LGPD e KYC/AML impõem constraints invioláveis."
	}
	"WI-059-scf": #TaskGovernanceRule & {
		scope:                "task"
		taskId:               "WI-059"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "SCF estrutura produtos financeiros sobre recebíveis e opera como SCD. Cessão e FIDC exigem precisão regulatória."
	}
	"WI-062-bkr": #TaskGovernanceRule & {
		scope:                "task"
		taskId:               "WI-062"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "BKR é boundary com sistema financeiro regulado. Execução física de settlement via SPB/PIX."
	}

	// --- high-regulated-support ---
	"WI-047-ato": #TaskGovernanceRule & {
		scope:                "task"
		taskId:               "WI-047"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "ATO materializa obrigações fiscais e tributárias derivadas de operações. Boundary regulatório — não controla dinheiro, mas non-compliance tem consequência legal direta."
	}
	"WI-051-ins": #TaskGovernanceRule & {
		scope:                "task"
		taskId:               "WI-051"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "INS intermedia instrumentos de proteção sob regime SUSEP/IRB. Boundary regulatório securitário — não controla dinheiro diretamente, mas especificação incorreta gera exposição de cobertura."
	}
	"WI-052-itc": #TaskGovernanceRule & {
		scope:                "task"
		taskId:               "WI-052"
		eligibleRoles:        ["spec-writer"]
		approvalRequired:     true
		criticality:          "high"
		defaultLeaseDuration: "4h"
		rationale:            "ITC governa comércio exterior sob Siscomex, câmbio e legislação aduaneira. Boundary regulatório — obrigação acessória com consequência legal e aduaneira."
	}
}
