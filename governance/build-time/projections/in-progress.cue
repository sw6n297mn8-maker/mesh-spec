package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: in-progress.
// Reconstruída via scripts/ci/rebuild-projections.sh (per WI-071) —
// replay determinístico de work-events/ filtrando streams cujo
// executionState computado é "claimed" (claim ativo, não expirado).
// Deletável sem perda (P8). Não é source of truth.
//
// Reconstrução atual: 1 item(s) em progresso.
//   - WI-070 (claimed 2026-05-07T20:01:00Z; expires 2026-05-15T20:01:00Z)

inProgressProjection: {
	rebuiltAt: "2026-05-28T20:40:30Z"
	entries: [...build_time.#InProgressEntry] & [{
		taskId:         "WI-070"
		version:        1
		title:          "Bootstrap Economic Foundation Layers (Layer -1 / Layer 1 / Layer 2 NIM) — emergent from WI-053"
		claimedBy:      "spec-writer"
		claimedAt:      "2026-05-07T20:01:00Z"
		claimExpiresAt: "2026-05-15T20:01:00Z"
		criticality:    "high"
	}]
}
