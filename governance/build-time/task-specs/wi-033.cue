// BACKFILLED — missing task-spec from commit c9b584c (2026-04-02)
// Reconstructed faithfully from wave-plan + work-event approved 2026-04-02T17:01Z.
//
// Original commit (c9b584c) created governance/build-time/work-events/wi-033.cue
// + entry em governance/wave-plan.cue mas NUNCA criou este task-spec —
// inconsistência referencial detectada na sessão claude/resume-mesh-work-jv2MC.
//
// Reconstrução é restauração de integridade estrutural, não nova decisão
// semântica: founder approved WI-033 em 2026-04-02 via task-approved event.
// Backfill restaura o task-spec ausente; estado de execução do WI permanece
// no log de events (último event = task-approved, work não-completed).
//
// Output target (architecture/artifact-schemas/shared-types.cue) NÃO existe
// no filesystem atual. Path em affects "architecture-communication-canvas.cue"
// também não existe atualmente — refletem estado declarado no wave-plan
// 2026-04-02, não estado verificado no commit do backfill.
package task_specs

taskSpecs: "WI-033": {
	version:     1
	title:       "Criar shared-types.cue para tipos utilitários do package artifact_schemas"
	templateRef: "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"Package artifact_schemas existente em architecture/artifact-schemas/",
		"Definições de #NonEmptyString, #ChannelCode e refs canônicos existem dispersos nos arquivos listados em affects (per rationale do wave-plan 2026-04-02)",
	]
	outputs: [{
		artifact: "architecture/artifact-schemas/shared-types.cue"
		type:     "create"
	}]
	affects: [
		"architecture/artifact-schemas/agent-spec.cue",
		"architecture/artifact-schemas/canvas.cue",
		"architecture/artifact-schemas/architecture-communication-canvas.cue",
	]
	rationale: "Tipos utilitários compartilhados (#NonEmptyString, #ChannelCode, refs canônicos) estão espalhados nos arquivos que os introduziram. Centralizar em shared-types.cue elimina dependências conceituais implícitas e facilita descoberta. Migração: mover definições dos arquivos originais, que passam a consumir do shared-types. Candidatos de rollout subsequente: agent-governance.cue, glossary.cue, domain-model.cue, stakeholder-map.cue."
}
