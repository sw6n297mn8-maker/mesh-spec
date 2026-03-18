package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr007: artifact_schemas.#ADR & {
	id:            "adr-007"
	title:         "Task templates para protocolo de execução de tarefas"
	date:          "2026-03-17"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"

	context: """
		TaskSpecs no work-governance definem o "quê" de cada tarefa, mas não o
		"como". Agentes redescobrem o protocolo de execução a cada tarefa.
		Três padrões repetitivos foram identificados nas 13 tasks do W001:
		create-schema (4 tasks), validate-artifact (4 tasks), create-instance
		(5 tasks). O campo templateRef existe em #TaskSpec mas não havia
		artefato correspondente nem formato definido.
		"""

	decision: """
		Criar schema #TaskTemplate em architecture/artifact-schemas/task-template.cue
		e instâncias em ai-orchestration/agent-instructions/task-templates.cue.
		Templates são mapa indexado por ID (map pattern CUE) em arquivo singleton.
		Cada template carrega version e kind (enum fechado: create-schema,
		validate-artifact, create-instance). templateRef em #TaskSpec passa a
		obrigatório com formato "tmpl-xxx@vN". preReads usam target + targetType
		para distinguir paths, globs, referências indiretas e patterns contextuais.
		Red team identificou e corrigiu: colisão de campos CUE (→ map pattern),
		referências a Phase 1 em contexto Phase 0 (→ chat-based signaling),
		ausência de versionamento (→ version + @vN), ambiguidade em step order
		(→ posição na lista), gates opcionais (→ removido mandatory), placeholders
		semânticos em paths (→ targetType tipado).
		"""

	consequences: """
		Positivas: protocolo de execução reutilizável e versionado; agentes
		não redescobrem "como fazer" a cada tarefa; templateRef obrigatório
		vincula toda TaskSpec a versão específica do template; kind permite
		roteamento e analytics; targetType elimina ambiguidade em preReads.
		Negativas: mais um artefato para manter; templates podem ficar
		desatualizados se não evoluírem com o processo; templateRef obrigatório
		exige atualização retroativa das TaskSpecs existentes no wave-plan.
		Mitigação: version explícito + CI pode validar que templateRef
		aponta para versão existente e kind corresponde ao tipo de tarefa.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/task-template.cue",
		"ai-orchestration/agent-instructions/task-templates.cue",
		"governance/build-time/work-governance.cue",
	]
	derivedArtifacts: []

	principlesApplied: [
		"P1: schema-first — template schema antes das instâncias",
		"P0: zero duplicação — protocolo definido uma vez, referenciado por templateRef",
		"P12: governance as code — protocolo de execução é artefato versionado, não documentação informal",
	]

	supersedes: []

	rationale: "Três padrões repetitivos de execução (create-schema, validate-artifact, create-instance) justificam extração para templates formais versionados, eliminando redescoberta de protocolo a cada tarefa."
}
