package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: in-progress.
// Reconstruída via replay de work-events/ filtrando streams cujo
// executionState computado é "claimed" (claim ativo, não expirado).
// Deletável sem perda (P8). Não é source of truth.
//
// Reconstrução atual: zero items em progresso.
// Nenhuma stream possui task-claimed sem task-completed,
// task-released ou task-claim-expired subsequente.

inProgressProjection: {
	rebuiltAt: "2026-03-22T12:00:00Z"
	entries: [...build_time.#InProgressEntry] & []
}
