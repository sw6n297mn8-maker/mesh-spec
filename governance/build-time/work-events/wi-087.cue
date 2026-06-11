package work_events

// wi-087.cue — Stream de WI-087 (admissao backfill + decisao terminal N2).
// Decisao terminal (2026-06-11, founder, reconciliacao N2): SUPERSEDED por
// WI-103 (que entregou adr-141; item 8 absorve a topologia de containers).
// proposed/approved sao backfill da admissao (historico truncado em c64e470;
// data real nao capturada); o evento terminal e decisao REAL de hoje (sem
// sufixo -backfill).
streams: "WI-087": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-087"
	taskVersion: 1
	commandId:   "WI-087-propose-backfill"
	timestamp:   "2026-05-28T18:34:30Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-087"
		taskVersion: 1
		commandId:   "WI-087-approve-backfill"
		timestamp:   "2026-05-28T18:34:30Z"
		actor:       "founder"
	},
	{
		eventType:    "task-superseded"
		taskId:       "WI-087"
		taskVersion:  1
		commandId:    "WI-087-supersede-adr-141-item-8"
		timestamp:    "2026-06-11T17:45:00Z"
		actor:        "founder"
		supersededBy: "WI-103"
		reason:       "escopo absorvido por adr-141 item 8 (topologia LOGICA de containers deriva do kernel: BC->modulo; topologia fisica deferida a def-038); adr-141 entregue por WI-103 (rationale do proprio wave-plan: 'absorvendo o escopo de WI-087')"
	}]
