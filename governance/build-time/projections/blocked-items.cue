package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: blocked-items.
// Reconstruída via scripts/ci/rebuild-projections.sh (per WI-071) —
// replay determinístico de work-events/ filtrando streams cujo
// executionState computado é "blocked".
// Deletável sem perda (P8). Não é source of truth.
//
// Reconstrução atual: zero items bloqueados.

blockedItemsProjection: {
	rebuiltAt: "2026-05-08T19:05:16Z"
	entries: [...build_time.#BlockedItemEntry] & []
}
