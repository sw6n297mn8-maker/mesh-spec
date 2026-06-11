package work_events

// wi-092.cue — Stream de WI-092 (admissao backfill + decisao terminal N2).
// Decisao terminal (2026-06-11, founder, reconciliacao N2): CANCELLED.
// proposed/approved sao backfill da admissao (historico truncado em c64e470;
// data real nao capturada); o evento terminal e decisao REAL de hoje (sem
// sufixo -backfill).
streams: "WI-092": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-092"
	taskVersion: 1
	commandId:   "WI-092-propose-backfill"
	timestamp:   "2026-05-28T18:34:30Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-092"
		taskVersion: 1
		commandId:   "WI-092-approve-backfill"
		timestamp:   "2026-05-28T18:34:30Z"
		actor:       "founder"
	},
	{
		eventType:   "task-cancelled"
		taskId:      "WI-092"
		taskVersion: 1
		commandId:   "WI-092-cancel-portfolio-reconciliation-n2"
		timestamp:   "2026-06-11T17:45:00Z"
		actor:       "founder"
		reason:      "arco re-planejavel pos-fan-out; no paradigma spec-executavel a topologia deriva dos manifests — precedente: WI-087 absorvido por adr-141 item 8"
	}]
