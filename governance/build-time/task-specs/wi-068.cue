package task_specs

taskSpecs: "WI-068": {
	version:     1
	title:       "Criar structural-checks ausentes para tipos governados (production-guide, adr, tension-entry, task-spec, self-review-report)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"#StructuralCheck schema em architecture/artifact-schemas/structural-check.cue",
		"Pattern existente: canvas.cue com 3 checks (sc-cv-01..03) cobrindo same-artifact-consistency e conditional-file-presence",
		"4 kinds suportados (adr-041 + adr-049): required-block, reference-exists, same-artifact-consistency, conditional-file-presence",
		"Apenas structural-checks são gating determinístico (adr-040); validation-prompts são advisory",
		"Coverage gap registrado em sessão 2026-04-29/30 (commits b1f6d9b..03bd1b7)",
	]
	outputs: [{
		artifact: "architecture/structural-checks/production-guide.cue"
		type:     "create"
	}, {
		artifact: "architecture/structural-checks/adr.cue"
		type:     "create"
	}, {
		artifact: "architecture/structural-checks/tension-entry.cue"
		type:     "create"
	}, {
		artifact: "architecture/structural-checks/task-spec.cue"
		type:     "create"
	}, {
		artifact: "architecture/structural-checks/self-review-report.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Mesh tem apenas 1 structural-check materializado (canvas.cue com 3
		regras sc-cv-01..03). Sessão 2026-04-29/30 expandiu a estrutura
		governada com novos artifactTypes (production-guide, tension-entry,
		self-review-report) e edits a artifactTypes existentes (adopted-
		artifacts, readme-config, adr, task-spec) — todos sem cobertura
		de gate estrutural pós-commit.

		Esta WI fecha o gap criando structural-checks para 5 tipos onde
		regras semânticas existem mas não são capturáveis por cue vet:

		production-guide: sc-pg-01 (workOrder == keys(sections) —
		same-artifact-consistency); sc-pg-02 (sections[].target resolve
		para tipo CUE existente — pode exigir novo kind).

		adr: sc-adr-01 (supersedes refs com status=superseded simétricos —
		adr-consistency parcial já no CI); sc-adr-02 (principlesApplied
		ids existem em design-principles.cue — reference-exists);
		sc-adr-03 (affectedArtifacts paths existem ou são output direto).

		tension-entry: sc-te-01 (relatedADR aponta para ADR existente);
		sc-te-02 (tensionTarget como path resolve para arquivo).

		task-spec: sc-ts-01 (templateRef registrado em fonte de templates);
		sc-ts-02 (outputs[].artifact paths conformes a canonicalPathRegex
		dos schemas de destino).

		self-review-report: sc-srr-01 (artifactPath existe);
		sc-srr-02 (artifactSchemaPath match canonicalPathRegex do tipo).

		Kinds além dos 4 atuais (e.g., cross-file-type-reference para
		sc-pg-02) podem exigir extensão do framework via ADR análogo a
		adr-049. Esta WI captura intenção; sub-tasks ou ADRs podem
		desdobrar.

		NÃO inclui:
		- adopted-artifacts: localContentHash exige filesystem hash
		  comparison; custo operacional alto, deferido.
		- readme-config: já coberto por scripts/ci/check-readme-coevolution.sh
		  externamente; cobertura adequada por script bash.

		Sem prazo. criticality medium. Reversível por delete. Modo:
		sessão dedicada com proposta-aprovação-commit por structural-check.
		Out-of-wave (segue padrão WI-065/066/067).
		"""
}
