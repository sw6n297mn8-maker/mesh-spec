package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr013: artifact_schemas.#ADR & {
	id:            "adr-013"
	title:         "Structured self-review report as auditable evidence"
	date:          "2026-03-19"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		quality-gate.cue define o protocolo de autovalidação pré-proposta
		e config.cue instrui o agente a executá-lo, mas sem um artefato
		de saída estruturado o sistema depende de obediência do agente
		sem verificação. Alternativas consideradas:
		(1) Continuar sem evidência estruturada, confiando na disciplina
		    do agente — rejeitada porque disciplina sem verificação decai
		    conforme o volume de artefatos cresce.
		(2) Resumo em texto livre no output da proposta — rejeitado porque
		    texto livre não é machine-verifiable e não serve como input
		    para CI.
		"""

	decision: """
		Criar governance/build-time/self-review-report.cue com
		#SelfReviewReport como contrato canônico de evidência. O report
		usa união discriminada por status (padrão de #ADR): stable proíbe
		fail findings estruturalmente via fail?: _|_; max-rounds-reached
		permite. Instâncias vivem em
		governance/build-time/self-reviews/*.self-review.cue
		(package self_reviews com import de build_time).
		Adicionar #QualityCriterionFinding a quality-criteria.cue como
		tipo de saída para findings. Mover #ArtifactType de quality-gate.cue
		para quality-criteria.cue — é tipo transversal de classificação,
		não do protocolo de self-review.
		"""

	consequences: """
		Positivas: self-review passa de comportamento esperado a evidência
		auditável; founder revisa semântica em vez de atuar como
		compilador humano; CI pode bloquear proposta sem report válido.
		Negativas: um artefato adicional por proposta; aumento de overhead
		no fluxo build-time proporcional ao número de artefatos governados.
		"""

	affectedArtifacts: [
		"governance/build-time/self-review-report.cue",
		"governance/build-time/self-reviews/",
		"governance/build-time/quality-gate.cue",
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	principlesApplied: ["P0", "P12"]

	rationale: """
		P0: separa norma (quality-gate.cue), instrução comportamental
		(config.cue) e evidência (self-review-report.cue) — três
		artefatos distintos com responsabilidades claras.
		P12: transforma comportamento esperado em governança
		estruturada e verificável por máquina.
		"""
}
