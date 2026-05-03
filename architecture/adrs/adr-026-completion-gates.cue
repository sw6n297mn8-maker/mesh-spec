package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr026: artifact_schemas.#ADR & {
	id:    "adr-026"
	title: "Completion gates formais com override por task"
	date:  "2026-03-22"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		completionValidation.gatesPassed em task-completed events aceita
		qualquer lista de strings (work-governance.cue #CompletionValidation).
		Sem definição formal de quais gates existem nem quais são obrigatórios
		por template, o campo é declarativo sem enforcement — o agente pode
		listar gates arbitrários e CI não valida. Isso viola P10 (agentes
		recomendam, gates determinísticos validam). Adicionalmente, a
		obrigação de ADR para mudanças semânticas em architecture/ e
		governance/ (CLAUDE.md) depende do output path da task, não do
		template — tmpl-create-instance@v1 serve tanto artefatos de domínio
		(sem ADR) quanto de governance (com ADR). Modelar adr-coevolution
		como gate estático por template super-restringiria instâncias de
		domínio ou sub-restringiria instâncias de governance.
		"""

	decision: """
		Criar completion-gates.cue com três camadas:
		1. Catálogo de gates: definição formal de cada gate com id,
		   description, kind (deterministic|evidence) e rationale.
		2. templateGateRequirements: mapeamento template → gates
		   obrigatórios como regra default.
		3. taskGateOverrides: override por taskId com precedência sobre
		   template, para quando a obrigação depende de propriedades da
		   task individual (output path, criticality específica).
		Extensão do pipeline ev-NN com ev-11: CI valida que gatesPassed
		contém todos os gates requeridos (override > template > backfill).
		ev-11 também valida que cada gate referenciado em requiredGates
		existe no catálogo — typo é erro, não silêncio.
		"""

	consequences: """
		Positivas: gatesPassed passa de declarativo a enforced; templates
		de baixo risco (validate-artifact) exigem menos gates que templates
		de alto risco (create-schema); tasks de governance podem exigir
		adr-coevolution sem forçar todas as instâncias de domínio.
		Negativas: taskGateOverrides exige manutenção por task — cada WI
		com output em governance/ precisa de override explícito. Aceitável
		nesta fase (volume baixo). Se padrão se tornar recorrente, considerar
		gate condicional por path (Opção B não adotada agora).
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"governance/build-time/event-validation.cue",
	]

	plannedOutputs: [
		"governance/build-time/completion-gates.cue",
	]

	principlesApplied: [
		"dp-10",
	]

	rationale: """
		Override por task é a solução mínima que resolve o gap semântico
		(obrigação condicional por output path) sem redesenhar o modelo
		de templates. Gate condicional por path (Opção B) seria mais
		elegante mas adiciona complexidade ao ev-11 sem necessidade
		imediata — volume de overrides é baixo e explicitamente rastreável.
		Adicionar adr-coevolution a tmpl-create-instance@v1 (Opção C)
		foi rejeitada porque super-restringe instâncias de domínio.
		"""
}
