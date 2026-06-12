package task_specs

// Task-spec materializado na execução do WI (par exigido por sc-wg-01 para o
// stream homônimo). TRANSCRIÇÃO da entry do wave-plan
// (governance/wave-plan.cue, grupo W006-fce-terminal-validation —
// title/outputs/rationale verbatim), não autoria nova.
// NOTA DE PATH (decisão de reuso, registrada também no stream e no PR): o
// wave-plan previa contexts/fce/terminal-validations/ sob a hipótese de tipo
// novo; a execução decidiu REUSAR #GoldenExample com marcação explícita
// (evitar proliferar schema para n=1) — o local acompanha o tipo reusado:
// contexts/fce/golden-examples/prepayment-guard-terminal.cue.
taskSpecs: "WI-138": {
	version:     1
	title:       "Definir cenário de validação terminal do FCE PrePaymentGuard sobre o walking skeleton"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"WI-137 completed (golden-example CMT provado — o terminal só faz sentido após o pipeline estar provado no CMT, per adr-138 decisão 3)",
		"contexts/fce/{glossary,domain-model,schemas,aggregate-manifests,port-manifest} materializados (fatias WI-043/WI-140 — âncoras formais do cenário)",
	]
	outputs: [{
		artifact: "contexts/fce/golden-examples/prepayment-guard-terminal.cue"
		type:     "create"
	}]
	affects: [
		"contexts/fce/domain-model.cue",
		"contexts/fce/port-manifest.cue",
	]
	rationale: """
		PrePaymentGuard (money-on-proof, P11) é cross-BC por construção;
		valida que o template do golden-example COMPÕE entre BCs, não só
		num aggregate isolado. Reuso de #GoldenExample marcado
		explicitamente como terminal-validation (decisão em execução
		prevista no wave-plan: 'decide entre criar #TerminalValidation ou
		reusar #GoldenExample marcado'). Terminal: roda após o pipeline
		estar provado no CMT.
		"""
}
