package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: ready-queue.
// Reconstruída via readyQueueAlgorithm (work-governance.cue) a partir de
// work-events/, work-graph.cue, task-specs/, task-governance.cue.
// Deletável sem perda (P8). Não é source of truth.
//
// pg1-governance-enforcement completa (WI-015 + WI-016 completed).
// pg2-governance-robustness completa (WI-017 + WI-018 + WI-019 completed).
// WI-007 (subdomínios), WI-011 (schema #Canvas) e WI-012 (schema #Subdomain) completed.
//
// Exclusões desta reconstrução:
// - WI-010: dep WI-009 (approved, unclaimed) não satisfeita

readyQueueProjection: {
	rebuiltAt: "2026-03-28T01:00:00Z"
	entries: [...build_time.#ReadyQueueEntry] & [{
		taskId:        "WI-008"
		version:       1
		title:         "Criar strategic/context-map.cue"
		eligibleRoles: ["spec-writer"]
		criticality:   "high"
	}, {
		taskId:        "WI-009"
		version:       1
		title:         "Criar contexts/cmt/canvas.cue — primeiro BC"
		eligibleRoles: ["spec-writer"]
		criticality:   "high"
	}]
}
