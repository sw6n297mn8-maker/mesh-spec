package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-087": {
	version:     1
	title:       "Criar ADR — Container topology (1:1 BC↔container vs agrupamento vs polyglot)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/adrs/adr-098-container-topology.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Container topology: a visão LÓGICA (BC→módulo) é absorvida pelo adr-141 (kernel/Port contracts, P7 module boundary); a topologia FÍSICA/de deploy é deferida a def-038 (runtime). Re-escopado per adr-139 (stack puro): o output id (adr-098), o título e o cleanup estrutural de C4 (incl. deps) ficam para a reconciliação W004/C4 separada — não tratados neste pacote.
		"""
}
