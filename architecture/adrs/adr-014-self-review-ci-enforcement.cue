package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr014: artifact_schemas.#ADR & {
	id:            "adr-014"
	title:         "CI enforcement for self-review evidence on governed artifacts"
	date:          "2026-03-19"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		ADR-013 criou self-review report como evidência estruturada,
		mas sem enforcement no CI a existência do report ainda depende
		de disciplina do agente. Alternativas consideradas:
		(1) Sem CI enforcement, confiar que agentes sempre produzem
		    reports — rejeitada pelo mesmo argumento de ADR-013:
		    disciplina sem verificação decai.
		(2) Enforcement completo sobre todos os artefatos governados
		    desde o dia 1 (all-governed) — rejeitado porque exige
		    backfill massivo de reports para artefatos já existentes,
		    com alto blast radius e baixo retorno imediato.
		"""

	decision: """
		Criar governance/build-time/self-review-ci-policy.cue com
		rollout changed-only: o CI exige self-review report apenas
		para artefatos governados novos ou alterados. Seis checks:
		existência do report, conformidade com #SelfReviewReport,
		associação artifactPath, compatibilidade artifactType,
		coerência status↔findings, e conformidade estrutural do
		artefato com seu schema. Phase self-review-evidence adicionada
		a repo-structure.cue.
		"""

	consequences: """
		Positivas: self-review deixa de ser opcional na prática;
		pipeline bloqueia artefatos sem prova de autovalidação;
		enforcement incremental minimiza fricção de adoção.
		Negativas: aumento de complexidade do CI; artefatos legados
		ficam temporariamente sem evidência até serem alterados.
		"""

	affectedArtifacts: [
		"governance/repo-structure.cue",
	]

	plannedOutputs: [
		"governance/build-time/self-review-ci-policy.cue",
		"scripts/ci/check-self-review.sh",
		".github/workflows/self-review-check.yml",
	]

	principlesApplied: ["P0", "P12"]

	rationale: """
		P0: separa contrato de evidência (ADR-013) de política de
		enforcement (este ADR) — permite evoluir rollout sem alterar
		o formato do report.
		P12: governança sem enforcement determinístico é sugestão,
		não governança.
		"""
}
