package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr024: artifact_schemas.#ADR & {
	id:    "adr-024"
	title: "Ativação de Phase 1 da governança de trabalho"
	date:  "2026-03-20"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		ADR-005 definiu a arquitetura de governança de trabalho com
		implementação incremental em 3 fases. Phase 0 (mínimo funcional)
		está operacional: task-specs, work-graph e ready-queue manual
		existem. Porém, sem event streams, não há registro formal de
		o que foi feito, quando, por quem, nem prova de conclusão.
		O founder não consegue inspecionar o estado do sistema sem
		reconstruir mentalmente a partir do filesystem — o que é
		frágil, não escala e viola P0 (Three Sources of Truth).
		Alternativa considerada: adicionar campos de status diretamente
		nas task-specs. Rejeitada porque viola a separação de camadas
		definida em ADR-005 (TaskSpec = definição normativa, não
		estado mutável) e impede auditabilidade — overwrite destrói
		histórico.
		"""

	decision: """
		Ativar Phase 1 da governança de trabalho conforme definido em
		work-governance.cue seção implementationPhases.phases[1].
		Criar os artefatos faltantes na seguinte ordem:
		(1) command-rights.cue — extrair autoridade de commands da
		narrativa em work-governance.cue para artefato formal;
		(2) task-governance.cue — regras de execução por template;
		(3) work-events/ — diretório de streams + backfill retroativo
		de tarefas já concluídas com timestamps extraídos do git log;
		(4) projections/ — materialização do estado atual.
		O trigger original de Phase 1 era "quando houver 2+ agentes".
		A ativação antecipada se justifica porque o problema de
		visibilidade é real agora — o founder não sabe o estado das
		tarefas sem inferência manual.
		"""

	consequences: """
		Positivas: estado de cada tarefa consultável formalmente;
		histórico auditável de quem fez o quê e quando; projeções
		materializadas eliminam reconstrução mental; infraestrutura
		pronta para múltiplos agentes quando necessário.
		Negativas: overhead de emitir eventos para cada transição
		(mitigado pelo fato de que as transições já acontecem — o
		evento apenas as registra); backfill retroativo usa timestamps
		aproximados do git log (aceitável porque o objetivo é
		rastreabilidade, não precisão de relógio).
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/build-time/work-governance.cue",
		"governance/build-time/work-graph.cue",
		"governance/build-time/projections/",
	]

	plannedOutputs: [
		"governance/build-time/command-rights.cue",
		"governance/build-time/task-governance.cue",
		"governance/build-time/work-events/",
	]

	principlesApplied: [
		"P0",
		"P8",
		"P12",
	]

	rationale: """
		Visibilidade formal do estado de trabalho é necessidade
		operacional imediata, não apenas preparação para multi-agente.
		Ativar Phase 1 agora elimina inferência manual e estabelece
		a infraestrutura de auditabilidade antes que o volume de
		tarefas torne o problema irreversível.
		"""
}
