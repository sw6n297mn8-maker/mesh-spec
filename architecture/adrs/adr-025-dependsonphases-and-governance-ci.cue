package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr025: artifact_schemas.#ADR & {
	id:    "adr-025"
	title: "Dependência positiva entre phases e ativação de governança CI"
	date:  "2026-03-21"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Phase 1 da governança de trabalho está ativa (ADR-024), com
		event streams, command-rights e task-governance operacionais.
		Faltam dois elementos: (1) CI validation dos work-events —
		sem enforcement automatizado, as regras de state machine,
		autoridade e idempotência existem apenas como especificação,
		não como gate; (2) projeções complementares (blocked-items,
		in-progress) que completam a visibilidade do estado do sistema.
		Estes WIs pertencem a uma dimensão de governança independente
		das phases de domínio (p0-p3). O schema #Phase atual impõe
		barreira sequencial global por order — phases de governança
		ficariam bloqueadas por phases de domínio sem necessidade.
		Alternativa considerada: campo independentOf (lista negativa
		de phases das quais NÃO depender). Rejeitada porque é exceção
		negativa sobre regra global implícita — difícil de ler, fácil
		de esquecer, e menos explícita que dependência positiva.
		"""

	decision: """
		(1) Estender #Phase com campo opcional dependsOnPhases: lista
		positiva explícita de phase IDs dos quais a phase depende.
		Semântica: se presente (inclusive []), governa readiness; se
		ausente, semântica legada por order (backward-compatible).
		[] significa phase explicitamente independente.
		O algoritmo de readiness (work-governance.cue seção
		orchestration.readyQueueAlgorithm) passa a resolver
		elegibilidade de phase por dependsOnPhases quando presente,
		e por order como fallback quando ausente.
		(2) Criar duas phases de governança: pg1-governance-enforcement
		(dependsOnPhases: [], independente) e pg2-governance-robustness
		(dependsOnPhases: ["pg1-governance-enforcement"]).
		(3) Criar WI-015 a WI-019 cobrindo CI validation, projeções
		complementares, claim expiration, completion-gates e drift
		detection.
		"""

	consequences: """
		Positivas: phases de governança executam independentemente das
		phases de domínio — enforcement pode ser implantado enquanto
		domain work continua; dependsOnPhases é modelo positivo que
		escala para qualquer topologia futura de phases; CI validation
		transforma regras especificadas em gates automatizados.
		Negativas: schema #Phase ganha complexidade (campo adicional
		com semântica condicional: presente governa readiness, ausente
		usa fallback por order); mitigado pela regra de fallback que
		mantém semântica legada quando o campo está ausente — phases
		existentes (p0-p3) não precisam de alteração.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/build-time/work-governance.cue",
		"governance/build-time/work-graph.cue",
		"governance/build-time/task-specs/wi-015.cue",
		"governance/build-time/task-specs/wi-016.cue",
		"governance/build-time/task-specs/wi-017.cue",
		"governance/build-time/task-specs/wi-018.cue",
		"governance/build-time/task-specs/wi-019.cue",
		"governance/build-time/work-events/wi-015.cue",
		"governance/build-time/work-events/wi-016.cue",
		"governance/build-time/work-events/wi-017.cue",
		"governance/build-time/work-events/wi-018.cue",
		"governance/build-time/work-events/wi-019.cue",
		"governance/build-time/projections/ready-queue.cue",
	]

	principlesApplied: [
		"P12",
		"P0",
		"P8",
	]

	rationale: """
		Dependência positiva explícita é modelo mais robusto que
		exceção negativa — alinhado com preferência da Mesh por
		explicitude sobre conveniência. Ativação de CI validation
		é consequência natural de Phase 1: sem enforcement, as
		regras de governança existem apenas como documentação.
		"""
}
