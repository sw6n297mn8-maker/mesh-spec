package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr027: artifact_schemas.#ADR & {
	id:    "adr-027"
	title: "Drift detection formal entre projeções e fontes de verdade"
	date:  "2026-03-22"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Projeções (ready-queue, blocked-items, in-progress) são
		materializações derivadas das SoTs (P8). Hoje são reconstruídas
		manualmente pelo agente e commitadas sem enforcement de
		consistência. Se o agente altera SoTs (emite evento, completa
		task) sem reconstruir a projeção correspondente, o repositório
		contém estado stale sem sinal visível. Agentes subsequentes
		operam sobre backlog desatualizado — decisões baseadas em
		desinformação operacional.
		"""

	decision: """
		Criar projection-drift.cue com três componentes:
		1. projectionRegistry: catálogo formal de projeções com sources,
		   algorithm (inline) ou algorithmRef (ponteiro para work-governance.cue),
		   mutuamente exclusivos via união discriminada CUE.
		2. driftDetectionPipeline (namespace drift-NN, separado de ev-NN):
		   drift-01 recalcula cada projeção e compara com commitada
		   (normalização por taskId, order-insensitive, rebuiltAt ignorado);
		   drift-02 valida que todo .cue em projections/ está registrado.
		3. driftPolicy: tolerance exact-match, CI falha em qualquer
		   divergência, agente propõe atualização ao founder.
		Auto-rebuild com commit automático rejeitado — viola modelo
		proposta-antes-de-implementar (CLAUDE.md).
		"""

	consequences: """
		Positivas: divergência entre projeções e SoTs se torna detectável
		por CI; registry formal elimina blind spots (projeções não
		rastreadas); pipeline drift-NN com IDs estáveis permite referência
		em logs e relatórios.
		Negativas: manutenção manual de projeções permanece — agente deve
		reconstruir no mesmo commit que altera SoTs. Custo aceitável na
		fase atual (3 projeções). Se volume crescer, considerar tooling
		de rebuild assistido (sem auto-commit).
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"governance/build-time/projections/ready-queue.cue",
		"governance/build-time/projections/blocked-items.cue",
		"governance/build-time/projections/in-progress.cue",
	]

	plannedOutputs: [
		"governance/build-time/projection-drift.cue",
	]

	principlesApplied: [
		"dp-08",
		"dp-12",
	]

	rationale: """
		Drift detection via CI é a extensão natural de P8 (projeções
		descartáveis) + P12 (fitness functions). A alternativa — auto-rebuild
		com commit automático — viola o modelo proposta-antes-de-implementar
		que governa toda escrita no repositório. Pipeline separado (drift-NN)
		ao invés de extensão do ev-NN reflete a diferença de domínio:
		ev-NN valida eventos imutáveis, drift-NN valida estado derivado.
		União discriminada algorithmRef/algorithm garante single source of
		truth quando algoritmo canonizado existe.
		"""
}
