package projections

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Projeção derivada: in-progress.
// Reconstruída via replay de work-events/ filtrando streams cujo
// executionState computado é "claimed" (claim ativo, não expirado).
// Deletável sem perda (P8). Não é source of truth.
//
// Reconstrução atual: 1 item em progresso.
// WI-070 (Economic Foundation Layers — emergent from WI-053) tem
// task-claimed como último event (2026-05-07T20:01:00Z) sem
// task-completed/released/expired subsequente; claim válido até
// 2026-05-15T20:01:00Z (lease estendida vs default 4h dada
// natureza retroativa do registro + Layer 2 NIM bootstrap pendente
// em 3 outputs).
// (Verificado por scan de work-events/ — único stream com
// task-claimed terminal.)

inProgressProjection: {
	rebuiltAt: "2026-05-08T17:59:20Z"
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
