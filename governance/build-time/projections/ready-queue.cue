package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: ready-queue.
// Reconstruída via readyQueueAlgorithm (work-governance.cue) a partir de
// work-events/, work-graph.cue, task-specs/, task-governance.cue.
// Deletável sem perda (P8). Não é source of truth.
//
// Última reconstrução: 2026-03-21.

readyQueue: [...build_time.#ReadyQueueEntry] & [{
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
}]
