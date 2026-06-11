package task_specs

// Task-spec materializado retroativamente (2026-06-11); o contrato original
// viveu no wave-plan + PR aprovado; fluxo founder<->agente sem task-spec a
// epoca. TRANSCRICAO do wave-plan (title/outputs/rationale verbatim), nao
// autoria nova. Par exigido por sc-wg-01 para o stream de work-events
// homonimo (backfill do ledger).
// templateRef: #Assertion e shared-schema (gramatica formal) — create-schema.
taskSpecs: "WI-133": {
	version:     1
	title:       "Autorar gramática #Assertion (shared-schema) — fonte estruturada do codegen"
	templateRef: "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"adr-138 aceito (estratégia de runtime bootstrap)",
		"design canônico do #Assertion descrito no README (governance/readme/config.cue): #Assertion(subject, variables, predicate), #Variable, #Predicate",
	]
	outputs: [{
		artifact: "architecture/shared-schemas/assertion-schema.cue"
		type:     "create"
	}]
	affects: [
		"architecture/artifact-schemas/structural-check.cue",
		"contexts/cmt/domain-model.cue",
	]
	rationale: """
		Gramática formal #Assertion (subject/variables/predicate) como container estruturado das assertions; o gerador de testes no CI do mesh-runtime consome via codegen — CUE define estrutura, codegen produz executável (padrão CUE→código, adr-146). Autoria PUXADA do WI-128 (single-ownership do path; WI-128 perde este output). domain-invariant (adr-080) referencia #Assertion por id — affects sinaliza a convenção de referência a definir na execução, NÃO edição obrigatória do CMT agora.
		"""
}
