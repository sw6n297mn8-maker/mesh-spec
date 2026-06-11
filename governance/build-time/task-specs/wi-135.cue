package task_specs

// Task-spec materializado retroativamente (2026-06-11); o contrato original
// viveu no wave-plan + PR aprovado; fluxo founder<->agente sem task-spec a
// epoca. TRANSCRICAO do wave-plan (title/outputs/rationale verbatim), nao
// autoria nova. Par exigido por sc-wg-01 para o stream de work-events
// homonimo (backfill do ledger).
// templateRef: pm-cmt e instancia de #PortManifest (adr-144).
taskSpecs: "WI-135": {
	version:     1
	title:       "Materializar contrato EventLogPort como #PortManifest (CMT) + adapter-stub spec-side"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "contexts/cmt/port-manifest.cue"
		type:     "create"
	}]
	affects: [
		"architecture/design-principles.cue",
	]
	rationale: """
		EventLogPort (P7) modelado como o #PortManifest que declara o Port consumido pelo CMT para event logging — adr-141 item 4: PortManifest é a SoT exclusiva de superfície de Port. Texto original (#ServiceContract) tornado obsoleto por adr-141 item 4 (#ServiceContract é API externa do BC com refs ao domain-model, não superfície de Port de infra); reinterpretado como o nó mínimo CMT-PortManifest do golden-example. O adapter-stub é scaffold de validação SPEC-SIDE apenas: NÃO introduz código de adapter de runtime de produção e NÃO modifica o mesh-runtime (repo subordinado, fora de escopo). Prova o uso do Port sem runtime real (gate CONTINUAR de adr-138).
		"""
}
