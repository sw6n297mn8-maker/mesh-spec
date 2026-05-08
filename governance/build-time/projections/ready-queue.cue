package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: ready-queue.
// Reconstruída via readyQueueAlgorithm (work-governance.cue) a partir de
// work-events/, work-graph.cue, task-specs/, task-governance.cue.
// Deletável sem perda (P8). Não é source of truth.
//
// Algorithm aplicado: admission=approved + execution=unclaimed + todas
// as deps em estado final (task-completed) + task-spec existe.
//
// 19 candidatos prontos para claim (WI-053 INV bootstrap closed
// 2026-05-08T17:04:10Z em commit 4c4b5be — Phase 5 governance envelope
// + R5 SRR; removido da ready-queue). 5 candidatos approved bloqueados
// por deps inter-BC ainda em task-approved (não completed): WI-043,
// 044, 051, 052, 059. WI-040 ainda em task-proposed (aguarda approval).
// WI-066/067/068/069 admission=defined (task-spec existe, sem work-event).
// WI-034 task-cancelled (final state). 40 WIs em task-completed
// (WI-053 INV bootstrap incluído pós-2026-05-08; WI-060 SSC bootstrap
// closed 2026-05-05; WI-057 P2P bootstrap closed 2026-05-06; WI-042
// DLV bootstrap closed 2026-05-06).
// WI-070 (Economic Foundation Layers — emergent from WI-053) NÃO está
// em ready-queue: criada já com task-claimed (in-progress projection).

readyQueueProjection: {
	rebuiltAt: "2026-05-08T17:59:20Z"
	entries: [...build_time.#ReadyQueueEntry] & [{
		taskId:        "WI-014"
		version:       1
		title:         "Alinhar domain/stakeholder-map.cue com glossário universal"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-027"
		version:       1
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
		taskId:        "WI-046"
		version:       1
		title:         "Criar artefatos de domínio para Risk Engine & Risk Observability (REW)"
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
