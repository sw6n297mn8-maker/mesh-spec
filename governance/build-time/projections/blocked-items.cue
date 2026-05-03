package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: blocked-items.
// Reconstruída via replay de work-events/ filtrando streams cujo
// executionState computado é "blocked".
// Deletável sem perda (P8). Não é source of truth.
//
// Reconstrução atual: zero items bloqueados.
// Nenhuma stream contém task-blocked sem task-unblocked subsequente.
// (Verificado por scan de work-events/ — nenhum eventType=task-blocked
// como último event em qualquer stream.)

blockedItemsProjection: {
	rebuiltAt: "2026-05-03T18:15:00Z"
	entries: [...build_time.#BlockedItemEntry] & []
}
