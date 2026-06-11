package work_events

// wi-109.cue — Stream de WI-109 (admissao backfill + decisao terminal N2).
// Decisao terminal (2026-06-11, founder, reconciliacao N2): CANCELLED.
// proposed/approved sao backfill da admissao (historico truncado em c64e470;
// data real nao capturada); o evento terminal e decisao REAL de hoje (sem
// sufixo -backfill).
streams: "WI-109": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-109"
	taskVersion: 1
	commandId:   "WI-109-propose-backfill"
	timestamp:   "2026-05-28T18:34:30Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-109"
		taskVersion: 1
		commandId:   "WI-109-approve-backfill"
		timestamp:   "2026-05-28T18:34:30Z"
		actor:       "founder"
	},
	{
		eventType:   "task-cancelled"
		taskId:      "WI-109"
		taskVersion: 1
		commandId:   "WI-109-cancel-portfolio-reconciliation-n2"
		timestamp:   "2026-06-11T17:45:00Z"
		actor:       "founder"
		reason:      "coerencia de stack provada pela mecanica mais forte — run-001: geracao+compilacao+teste vivos; padrao def-055, check estatico redundante"
	}]
