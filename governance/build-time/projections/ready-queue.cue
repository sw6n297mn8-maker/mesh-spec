package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: ready-queue.
// Reconstruída via readyQueueAlgorithm (work-governance.cue) a partir de
// work-events/, work-graph.cue, task-specs/, task-governance.cue.
// Deletável sem perda (P8). Não é source of truth.
//
// WI-016 permanece na ready queue porque ainda não houve task-claimed;
// trabalho preparatório nesta sessão não altera o estado canônico até
// emissão do evento.
//
// Exclusões desta reconstrução:
// - WI-007: dep WI-012 (unclaimed) não satisfeita
// - WI-008: dep WI-007 (unclaimed) não satisfeita
// - WI-009: deps WI-007 e WI-011 (unclaimed) não satisfeitas
// - WI-010: dep WI-009 (unclaimed) não satisfeita
// - WI-017: phase pg2-governance-robustness bloqueada por pg1-governance-enforcement incompleta (WI-016 unclaimed)
// - WI-018: phase pg2-governance-robustness bloqueada por pg1-governance-enforcement incompleta (WI-016 unclaimed)
// - WI-019: dep WI-016 (unclaimed) não satisfeita

readyQueueProjection: {
	rebuiltAt: "2026-03-22T12:00:00Z"
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
		taskId:        "WI-016"
		version:       1
		title:         "Criar projeções blocked-items e in-progress"
		eligibleRoles: ["spec-writer"]
		criticality:   "medium"
	}]
}
