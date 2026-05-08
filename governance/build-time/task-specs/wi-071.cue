package task_specs

taskSpecs: "WI-071": {
	version:     1
	title:       "Criar script automático de rebuild para projections (in-progress + ready-queue + blocked-items)"
	templateRef: "tmpl-create-script@v1"
	semanticPrerequisites: [
		"P8 declara projections deletáveis sem perda; reconstrução via replay de work-events/ é determinística por design",
		"Schemas #InProgressEntry + #ReadyQueueEntry + #BlockedItemEntry vigentes em governance/build-time/work-governance.cue",
		"readyQueueAlgorithm declarado em work-governance.cue: admission=approved + execution=unclaimed + todas deps em estado final + task-spec existe",
		"Gap descoberto em test session 2026-05-08 pós-WI-070 commit (b771ff8): projeções in-progress.cue + ready-queue.cue out-of-sync com work-events; rebuild manual executado, mas drift cumulative ao longo de N commits sem rebuild = governance maturity gap",
	]
	outputs: [{
		artifact: "scripts/ci/rebuild-projections.sh"
		type:     "create"
	}]
	affects: [
		"governance/build-time/projections/in-progress.cue",
		"governance/build-time/projections/ready-queue.cue",
		"governance/build-time/projections/blocked-items.cue",
	]
	rationale: """
		Gap identificado em test session 2026-05-08 do governance structure: projections (in-progress.cue + ready-queue.cue + blocked-items.cue) são reconstruídas MANUALMENTE via scan visual de work-events/. Comentários nos arquivos confirmam: 'Verificado por scan de work-events/'. Comando find scripts -name '*rebuild*' retorna vazio (zero scripts existentes).

		Conseqüência: projeções drift silently conforme work-events accumulate. Em b771ff8 (test session) foram descobertas 2 projeções stale: in-progress missing WI-070 claimed; ready-queue listing WI-053 já completed. Manual rebuild custoso + error-prone + escala mal conforme repo cresce.

		Script proposto:
		- Input: governance/build-time/work-events/*.cue + governance/build-time/task-specs/*.cue + governance/build-time/work-graph.cue
		- Algorithm: replay events per stream; compute admission state (proposed/approved/rejected/cancelled); compute execution state (unclaimed/claimed/expired/released/blocked/completed); aplicar readyQueueAlgorithm per work-governance.cue; emit 3 projection files
		- Output: substitui governance/build-time/projections/*.cue (overwrite determinístico)
		- Idempotent: rebuild repetido produz mesmo resultado se inputs não mudaram
		- Determinístico (P10): rebuild é gate determinístico, NÃO stochastic — qualquer LLM-based reconstruction violaria P10

		Integração futura possível (fora escopo desta WI): hook post-commit OR CI gate verificando projection consistency (rebuild + diff + fail se drift detectado). Esses são candidatos a WIs subsequentes ou extensions desta.

		Criticality medium (default tmpl-create-script@v1): script automatiza P8 derivation; NÃO modifica source-of-truth (work-events permanecem canonical); reversível por delete + rerun manual.

		Esta WI emerge de gap session 2026-05-08 — paralelo metodológico a WI-070 (Economic Foundation Layers — emergent from WI-053). Diferença ontológica: WI-070 é emergent-from-WI escopo (3 layers crossing); WI-071 é standalone tooling (single script output). NÃO usa header 'OUTPUTS STATUS [(]structured[)]:' porque NÃO é WI emergent multi-layer com outputs parciais; é WI standard single-output. def-015 trigger não conta este WI como recurrence — pattern self-match permanece em 3 (def-015 + srr-def-015 + wi-070).
		"""
}
