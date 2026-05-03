package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr008: artifact_schemas.#ADR & {
	id:    "adr-008"
	title: "Work graph phase topology for W001-foundation"
	date:  "2026-03-17"

	decisionClass: "structural"
	decider:       "founder"

	status: "accepted"

	context: """
		Work-governance.cue (ADR-005) define o sistema de coordenação mas
		não materializa a topologia de execução. Para operacionalizar Phase 0,
		são necessários: work-graph com fases e dependências, e TaskSpecs
		individuais para cada work-item do wave-plan W001.
		"""

	decision: """
		Criar work-graph.cue com 4 fases progressivas (validate-and-bootstrap,
		domain-identity, strategic-layer, tactical-and-validation), 7 grupos
		lógicos, e 13 dependências versionadas. Criar TaskSpecs individuais
		em task-specs/{wi-id}.cue conforme layer pattern de work-governance.cue.
		Criar diretório projections/ para Phase 0 (vazio, ready-queue manual).
		Nota: WI-007 recebe dependência explícita em WI-001 ausente no
		wave-plan, porque subdomínios dependem semanticamente de
		domain-definition e a dependência deve ser rastreável pelo
		ready-queue algorithm, não apenas pela barreira de fase.
		"""

	consequences: """
		Positivas: elegibilidade de execução é verificável por grafo, não por
		intuição. Sequência de trabalho é transparente. TaskSpecs adicionam
		templateRef que conecta cada tarefa ao seu protocolo de execução.
		Negativas: overhead de 15 arquivos para 13 tarefas. Aceitável porque
		a estrutura escala para waves futuras sem mudança de design.
		Divergência: WI-007.dependsOn no work-graph inclui WI-001, ausente no
		wave-plan. Wave-plan é planejamento; work-graph é execução. A
		dependência semântica é real e deve ser rastreável.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: []

	plannedOutputs: [
		"governance/build-time/work-graph.cue",
		"governance/build-time/task-specs/",
		"governance/build-time/projections/",
	]

	principlesApplied: ["P0", "P12"]

	rationale: "Operacionaliza Phase 0 do work-governance (ADR-005). Fases derivadas da análise de dependências do wave-plan W001. Dependência WI-007→WI-001 tornada explícita para rastreabilidade."
}
