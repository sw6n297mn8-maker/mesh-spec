package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: ready-queue.
// Reconstruída via readyQueueAlgorithm (work-governance.cue) a partir de
// work-events/, work-graph.cue, task-specs/, task-governance.cue.
// Deletável sem perda (P8). Não é source of truth.
//
// WI-015 e WI-016 entram na ready queue porque pertencem a
// pg1-governance-enforcement, cuja readiness é governada por
// dependsOnPhases: [] (explicitamente independente), não pela
// barreira sequencial legada por order. Ref: ADR-025.
//
// Exclusões desta reconstrução:
// - WI-007: dep WI-012 (unclaimed) não satisfeita
// - WI-008: dep WI-007 (unclaimed) não satisfeita
// - WI-009: deps WI-007 e WI-011 (unclaimed) não satisfeitas
// - WI-010: dep WI-009 (unclaimed) não satisfeita
// - WI-017: dep WI-015 (unclaimed) não satisfeita
// - WI-018: dep WI-015 (unclaimed) não satisfeita
// - WI-019: dep WI-016 (unclaimed) não satisfeita

readyQueueProjection: {
	rebuiltAt: "2026-03-21T12:00:00Z"
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
		taskId:        "WI-015"
		version:       1
		title:         "Criar CI validation de work-events"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}, {
		taskId:        "WI-016"
		version:       1
		title:         "Criar projeções blocked-items e in-progress"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}]
}
