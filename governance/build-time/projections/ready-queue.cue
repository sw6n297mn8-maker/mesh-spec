package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: ready-queue.
// Reconstruída via readyQueueAlgorithm (work-governance.cue) a partir de
// work-events/, work-graph.cue, task-specs/, task-governance.cue.
// Deletável sem perda (P8). Não é source of truth.
//
// pg1-governance-enforcement completa (WI-015 + WI-016 completed).
// pg2-governance-robustness desbloqueada: dependsOnPhases satisfeito.
// WI-017 e WI-018 completaram — saem da ready queue.
//
// Exclusões desta reconstrução:
// - WI-007: dep WI-012 (unclaimed) não satisfeita
// - WI-008: dep WI-007 (unclaimed) não satisfeita
// - WI-009: deps WI-007 e WI-011 (unclaimed) não satisfeitas
// - WI-010: dep WI-009 (unclaimed) não satisfeita

readyQueueProjection: {
	rebuiltAt: "2026-03-22T13:30:00Z"
	entries: [...build_time.#ReadyQueueEntry] & [{
		taskId:        "WI-011"
		version:       1
		title:         "Criar schema #Canvas"
		eligibleRoles: ["spec-writer"]
		criticality:   "high"
	}, {
		taskId:        "WI-012"
		version:       1
		title:         "Criar schema #Subdomain"
		eligibleRoles: ["spec-writer"]
		criticality:   "high"
	}, {
		taskId:        "WI-019"
		version:       1
		title:         "Criar drift-detection entre projeções e events"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}]
}
