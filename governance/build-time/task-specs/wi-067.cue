package task_specs

taskSpecs: "WI-067": {
	version:     1
	title:       "Criar 4 validation-prompts ausentes (production-guide, tension-entry, adopted-artifacts, readme-config)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"#ValidationPrompt schema disponível em architecture/artifact-schemas/validation-prompt.cue",
		"Prompts existentes em architecture/validation-prompts/ servem como patterns: validate-adr.cue, validate-artifact-schema.cue, validate-self-review-report.cue (4 checks cada)",
		"Coverage gap registrado em sessão 2026-04-29 (commits b1f6d9b..92c9e4e): 4 artifactTypes carecem de design review advisory",
		"Reviews advisory são NUNCA gating (per P10/adr-040) — ferramentas de feedback ao founder, não bloqueio de fluxo",
	]
	outputs: [{
		artifact: "architecture/validation-prompts/validate-production-guide.cue"
		type:     "create"
	}, {
		artifact: "architecture/validation-prompts/validate-tension-entry.cue"
		type:     "create"
	}, {
		artifact: "architecture/validation-prompts/validate-adopted-artifacts.cue"
		type:     "create"
	}, {
		artifact: "architecture/validation-prompts/validate-readme-config.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Sessão 2026-04-29 (adr-053 + 11 commits subsequentes) materializou
		artefatos de 4 artifactTypes que não têm validation-prompt
		correspondente em mesh nem em tekton-spec/portfolio: production-guide
		(meta-guide instance), tension-entry (ten-011), adopted-artifacts
		(entry no manifest), readme-config (item em tree.entries).
		Coverage gap registrado formalmente per CLAUDE.md "Validação"
		item 5; agentes prosseguem sem bloqueio mas advisory layer fica
		ausente para esses tipos.

		Esta WI fecha o gap criando os 4 prompts ausentes. Cada prompt:
		(a) declara matchPatterns regex precisa contra o canonicalPathRegex
		do schema correspondente; (b) declara appliesTo com o artifactType;
		(c) define 3-5 checks com question (pergunta semântica), lookFor
		(padrões a procurar), outputMode (pass-fail | finding-only |
		narrative), severity (fail | warn | info), e rationale; (d) lista
		references obrigatórias para o subagente isolado consultar.

		Granularidade dos checks segue precedente dos 3 prompts existentes
		(validate-adr.cue, validate-artifact-schema.cue,
		validate-self-review-report.cue): 4 checks por prompt em média,
		focados em dimensões interpretativas que cue vet e structural-checks
		não alcançam (genuinidade de conteúdo, honestidade de trade-offs,
		conexão lógica, completude de rastreabilidade).

		Para production-guide: checks focados em qualidade autoral
		(process[].action acionável, doneCriteria avaliável, gapPolicy
		substantiva, sources adequadas ao schema alvo). Para tension-entry:
		genuinidade da tensão (não é bug travestido), concretude da
		resolution, rastreabilidade da manifestação. Para adopted-artifacts:
		integridade do double-anchor (sourceVersion + sourceCommitHash),
		consistência localContentHash com arquivo, adoptionMode coerente.
		Para readme-config: coerência tree.entries ↔ filesystem,
		consistência de naming conventions, rationales que justificam
		estrutura.

		Esta WI não tem prazo. criticality medium (default): edição de
		governança que adiciona advisory layer. Sem movimento financeiro
		ou regulatório. Reversível por delete dos arquivos criados.
		Modo de execução pretendido: sessão dedicada onde os 4 prompts
		são propostos individualmente ao founder, com referência a
		patterns dos 3 prompts existentes.

		Out-of-wave: WI-067 não pertence ao W001 work-graph (segue padrão
		WI-065/WI-066 que também ficaram fora). Pode ser executada em
		qualquer ordem após semanticPrerequisites cumpridos.
		"""
}
