package task_specs

meta: "governance/build-time/task-specs": {
	canonicalPath: "governance/build-time/task-specs"
	purpose:       "Specs dos work items consumidos pelo motor de work governance."
	conventions: [
		"Um arquivo por work item; nome no formato wi-XXXXX.cue.",
		"_constraints.cue define invariants globais sobre task-specs.",
		"Conforma com o schema de task spec em governance/build-time/work-governance.cue.",
	]
	rationale: "Container de instâncias: task-specs são a entrada operacional do motor de work governance e devem permanecer separadas dos protocolos que governam sua execução."
}
