package work_events

meta: "governance/build-time/work-events": {
	canonicalPath: "governance/build-time/work-events"
	purpose:       "Eventos append-only do event sourcing de work governance."
	conventions: [
		"Um arquivo por work item agregando seus eventos; nome no formato wi-XXXXX.cue.",
		"_constraints.cue define o shape dos eventos e invariants relacionais.",
		"Eventos committed não são editados retroativamente.",
	]
	rationale: "Container de eventos: o diretório torna explícito que o source de verdade do fluxo de trabalho é o histórico de eventos, não os read models derivados."
}
