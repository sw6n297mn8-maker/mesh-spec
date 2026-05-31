package agent_probes

meta: "architecture/agent-probes": {
	canonicalPath: "architecture/agent-probes"
	purpose:       "Protocolo agent-probe (Ciclo 4) e os probe-records append-only por canvas — validação semântica advisory que dá um canvas fechado a um agente limpo e trata cada buraco como defeito de spec."
	rationale:     "Co-localiza o protocolo singleton e seus registros (records/) num lar canônico (P0), em vez de dispersá-los; o mecanismo de probe é distinto das camadas de gate (structural-checks) e de advisory por-tipo (validation-prompts)."
	conventions: [
		"protocol.cue — instância singleton de #AgentProbeProtocol.",
		"records/<bc>.cue — instância de #AgentProbeRecord, 1 por canvas probado.",
	]
}
