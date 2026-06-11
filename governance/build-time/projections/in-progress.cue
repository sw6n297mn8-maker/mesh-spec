package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: in-progress.
// Reconstruída via scripts/ci/rebuild-projections.sh (per WI-071) —
// replay determinístico de work-events/ filtrando streams cujo
// executionState computado é "claimed" (claim ativo, não expirado).
// Deletável sem perda (P8). Não é source of truth.
//
// Reconstrução atual: zero items em progresso.

inProgressProjection: {
	rebuiltAt: "2026-06-11T17:17:34Z"
	entries: [...build_time.#InProgressEntry] & []
}
