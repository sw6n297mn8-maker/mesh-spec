package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: ready-queue.
// Reconstruída via scripts/ci/rebuild-projections.sh (per WI-071) a partir de
// work-events/, work-graph.cue, task-specs/, task-governance.cue.
// Deletável sem perda (P8). Não é source of truth.
//
// Algorithm aplicado: admission=approved + execution=unclaimed + todas
// as deps em estado final (task-completed) + task-spec existe.
//
// 18 candidato(s) prontos para claim.

readyQueueProjection: {
	rebuiltAt: "2026-05-08T19:05:16Z"
	entries: [...build_time.#ReadyQueueEntry] & [{
		taskId:        "WI-014"
		version:       1
		title:         "Alinhar domain/stakeholder-map.cue com glossário universal"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-027"
		version:       2
		title:         "Definir convenção OpenAPI/AsyncAPI por capability flags"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-030"
		version:       1
		title:         "Criar schema #ArchitectureCommunicationCanvas"
		eligibleRoles: ["spec-writer"]
		criticality:   "high"
	}, {
		taskId:        "WI-032"
		version:       1
		title:         "Criar runner de validação cross-artifact"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-033"
		version:       1
		title:         "Criar shared-types.cue para tipos utilitários do package artifact_schemas"
		eligibleRoles: ["spec-writer"]
		criticality:   "high"
	}, {
		taskId:        "WI-045"
		version:       1
		title:         "Criar artefatos de domínio para Network Intelligence & Mechanism Design (NIM)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-047"
		version:       1
		title:         "Criar artefatos de domínio para Accounting & Tax Operations (ATO)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-049"
		version:       1
		title:         "Criar artefatos de domínio para Disputes, Reversals & Corrections (DRC)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-050"
		version:       1
		title:         "Criar artefatos de domínio para Identity & Data Governance (IDC)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-054"
		version:       1
		title:         "Criar artefatos de domínio para Logistics & Operational Evidence (LOG)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-055"
		version:       1
		title:         "Criar artefatos de domínio para Network Participant Management (NPM)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-056"
		version:       1
		title:         "Criar artefatos de domínio para Observability & Operational Intelligence (OBS)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-058"
		version:       1
		title:         "Criar artefatos de domínio para Platform & Infrastructure Services (PLT)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-061"
		version:       1
		title:         "Criar artefatos de domínio para Treasury & Cash Management (TCM)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-062"
		version:       1
		title:         "Criar artefatos de domínio para Banking Rails & Settlement (BKR)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-063"
		version:       1
		title:         "Criar artefatos de domínio para Notifications & Communications (NTF)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-064"
		version:       1
		title:         "Criar artefatos de domínio para Storage & Document Management (STR)"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-065"
		version:       1
		title:         "Criar scripts/build/generate-claude-md.sh para regenerar CLAUDE.md a partir do CUE fonte"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}]
}
