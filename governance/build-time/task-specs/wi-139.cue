package task_specs

// Task-spec materializado retroativamente (2026-06-11); o contrato original
// viveu no wave-plan + PR aprovado; fluxo founder<->agente sem task-spec a
// epoca. TRANSCRICAO do wave-plan (title/outputs/rationale verbatim), nao
// autoria nova. Par exigido por sc-wg-01 para o stream de work-events
// homonimo (backfill do ledger).
// templateRef: update de instancia de production-guide (golden-example).
// dependsOn real no wave-plan: [WI-136, WI-137]. SATISFEITO POR CONSTRUCAO
// (espelha o stream wi-139): o PG nasceu em 40fba2f (junto de WI-136) ja com
// template-role (P3c), exemplar ge-cmt e criterio de generalizacao (divergencia
// estrutural > 0 sem ADR = sinal N3 de adr-138); provado em uso no run-001.
// dependsOn nao foi respeitado na execucao original — registro reflete realidade.
taskSpecs: "WI-139": {
	version:     1
	title:       "Extrair template do golden-example + codificar critério de generalização (N3)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/production-guides/golden-example.cue"
		type:     "update"
	}]
	affects: []
	rationale: """
		Promove o golden-example CMT a template reusável (P3c de adr-138) e codifica o sinal de falha do fan-out: zero divergência estrutural do template NÃO EXPLICADA por ADR (divergência é permitida desde que registrada em ADR — não é zero divergência absoluta). Gate antes de comprometer os 14 BCs.
		"""
}
