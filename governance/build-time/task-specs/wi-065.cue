package task_specs

taskSpecs: "WI-065": {
	version:               1
	title:                 "Criar scripts/build/generate-claude-md.sh para regenerar CLAUDE.md a partir do CUE fonte"
	templateRef:           "tmpl-create-script@v1"
	semanticPrerequisites: [
		"adr-042 aceito — template tmpl-create-script@v1 existe e está registrado em task-governance",
		"architecture/artifact-schemas/task-template.cue com kind estendido para incluir 'create-script'",
		"governance/claude/config.cue e governance/claude/output.cue presentes e validados por cue vet",
		"Script deve usar cue export sobre o package claude (governance/claude/) como fonte única de geração — evita múltiplas implementações divergentes em WIs futuras",
	]
	outputs: [{
		artifact: "scripts/build/generate-claude-md.sh"
		type:     "create"
	}, {
		artifact: "CLAUDE.md"
		type:     "update"
	}]
	affects: [
		"governance/claude/config.cue",
		"governance/claude/output.cue",
	]
	rationale: """
		CLAUDE.md é artefato derivado de governance/claude/config.cue +
		governance/claude/output.cue, mas hoje é regenerado manualmente.
		Drift entre source CUE e derivado é risco operacional direto:
		o agente opera a partir do CLAUDE.md renderizado, não do CUE
		fonte.

		Escopo mínimo desta WI (explicitamente limitado por adr-042 e
		decisão do founder):
		- regenerar CLAUDE.md via cue export sobre o package claude
		  (governance/claude/), usando output.cue como template de
		  geração — fonte única de geração, evita implementações
		  divergentes em WIs futuras
		- checagem empírica de idempotência (duas execuções produzem
		  output idêntico byte-a-byte)
		- falha explícita quando geração não reproduz exatamente o
		  conteúdo esperado, quando cue CLI não está no PATH, ou
		  quando os sources CUE não validam

		Fora de escopo desta WI (candidatos a WIs subsequentes):
		- integração com pre-commit hook
		- drift detection contra o CLAUDE.md committed
		- enforcement automático no pipeline de CI

		Criticality medium (default de tmpl-create-script): script de
		build de artefato derivado de governança, sem movimento
		financeiro nem decisão regulatória. Blast radius limitado ao
		próprio CLAUDE.md — reversível por edição manual caso o
		script introduza defeito.
		"""
}
