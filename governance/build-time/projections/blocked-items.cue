package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: blocked-items.
// Reconstruída via replay de work-events/ filtrando streams cujo
// executionState computado é "blocked".
// Deletável sem perda (P8). Não é source of truth.
//
// Reconstrução atual: zero items bloqueados.
// Nenhuma stream contém task-blocked sem task-unblocked subsequente.

blockedItemsProjection: {
	rebuiltAt: "2026-03-22T12:00:00Z"
	entries: [...build_time.#BlockedItemEntry] & []
}
