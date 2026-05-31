package task_specs

taskSpecs: "WI-132": {
	version:     1
	title:       "Audit de cobertura CLAUDE.md ↔ enforcement: mapear mandates sem contraparte determinística e dispor lacunas"
	templateRef: "tmpl-validate-artifact@v1" // STOPGAP — ver Finding #0 no rationale
	semanticPrerequisites: [
		"CLAUDE.md — mandates operacionais a auditar (derivado de governance/claude/config.cue; auditar o conteúdo efetivo).",
		".github/workflows/*.yml + scripts/ci/*.py + scripts/ci/*.sh — gates de CI atuais e runners por trás deles.",
		"architecture/structural-checks/ + architecture/artifact-schemas/structural-check.cue — enforcement determinístico por artifactType + adr-040 (separação gate vs advisory): base para classificar o que É gateável.",
		"governance/build-time/quality-gate.cue + governance/build-time/self-review-report.cue — regime de self-review pré-proposta e seu limite (artifactType ∈ #ArtifactType).",
		"architecture/artifact-schemas/quality-criteria.cue (#ArtifactType) + governance/build-time/work-governance.cue (#TaskSpec) — para mapear o gap de tipagem do Finding #0.",
	]
	outputs: [{
		artifact: "governance/build-time/claude-enforcement-coverage.cue"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-035-task-spec-self-review-typing-gap.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Cada mandate operacional do CLAUDE.md tem contraparte determinística
		(schema / structural-check / workflow) que garante seu cumprimento? Onde
		não tem, classificar e dispor — nenhuma lacuna fica solta.

		Classificação obrigatória de cada mandate (respeita adr-040/P10 — NÃO gerar
		gate determinístico para diretriz interpretativa):
		(a) enforced-by-schema; (b) enforced-by-CI/structural-check;
		(c) procedural/manual-only (interpretativo, P10 — enforcement é advisory via
		validation-prompt ou disciplina humana, não gate); (d) unsupported (gateável
		mas sem contraparte → gera WI de remediação); (e) contradictory. Toda lacuna
		(d)/(e) recebe disposition explícita (WI / deferred-decision / ADR).

		Execução em 4 waves: (1) ler fontes canônicas + inventariar mandates;
		(2) mapear mandate→mecanismo + classificar (a–e) no artefato de cobertura CUE;
		(3) criar dispositions para (d)/(e); (4) cue vet + self-review antes da
		proposta de conclusão.

		Finding #0 (descoberto no pre-flight, semente do próprio audit):
		#TaskSpec.templateRef é regex-constrained a ^tmpl-*@vN^ e NÃO tem escape hatch
		para tarefa sem template canônico; não existe template de audit. Logo este
		task-spec usa tmpl-validate-artifact@v1 como STOPGAP declarado (não fingido),
		e a lacuna vira o def-035 deste output — caso vivo de mandate procedural
		(Autovalidação Pré-Proposta exige self-review para "qualquer artefato") que o
		regime tipado de #SelfReviewReport (artifactType ∈ #ArtifactType, sem
		task-spec) não consegue representar.

		Criticality medium. Reversível — o audit mapeia e propõe dispositions; não muta
		nenhum mecanismo de enforcement existente.
		"""
}
