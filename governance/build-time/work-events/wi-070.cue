package work_events

streams: {
	"WI-070": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-070"
			taskVersion: 1
			commandId:   "WI-070-propose-economic-foundation"
			timestamp:   "2026-05-07T20:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-070"
			taskVersion: 1
			commandId:   "WI-070-approve-economic-foundation"
			timestamp:   "2026-05-07T20:00:30Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-070"
			taskVersion:    1
			commandId:      "WI-070-claim-economic-foundation"
			timestamp:      "2026-05-07T20:01:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-15T20:01:00Z"
		}, {
			// Backfill: o claim expirou em 2026-05-15 sem conclusão. WI-070 foi
			// PARCIALMENTE executado — Layer -1 (assumptions) + Layer 1 (mechanisms)
			// entregues (6/9 outputs); Layer 2 NIM (value-function-model +
			// strategic/nim/mesh-value-function-v0 + adr-084) nunca materializada.
			// task-claim-expired (não task-completed) reflete a realidade:
			// trabalho inacabado, claim lapsado, retorno a unclaimed. A Layer 2
			// NIM permanece trabalho disponível, tratada como item de roadmap
			// separado (conecta com mech-04 → operacionalização NIM pendente).
			eventType:              "task-claim-expired"
			taskId:                 "WI-070"
			taskVersion:            1
			commandId:              "WI-070-claim-expired-backfill"
			timestamp:              "2026-05-15T20:01:00Z"
			actor:                  "spec-writer"
			originalClaimCommandId: "WI-070-claim-economic-foundation"
		}, // ── Append 2026-06-11 (reconciliacao N2; append-only, eventos acima intactos) ──
			// Released: o claim caducou ha meses; o registro reflete o fato sem decidir o
			// destino do trabalho restante (Layer 2 NIM) — re-scope e decisao posterior.
			{
				eventType:   "task-released"
				taskId:      "WI-070"
				taskVersion: 1
				commandId:   "WI-070-release-portfolio-reconciliation-n2"
				timestamp:   "2026-06-11T17:45:00Z"
				actor:       "founder"
				reason:      "claim de 2026-03 expirado sem completion; 6/9 outputs entregues (Layers -1 e 1 completos: economic-assumption + economic-mechanism, schemas+instancias+adr-082/083); Layer 2 NIM (value-function x3) pendente; re-scope/split e decisao posterior do founder"
			}]
	}
}
