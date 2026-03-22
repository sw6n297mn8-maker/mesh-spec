package build_time

// projection-drift.cue — Drift detection entre projeções e fontes de verdade.
//
// CI recalcula cada projeção registrada a partir das SoTs e compara
// com o arquivo commitado. Drift > 0 → fail. Agente propõe
// atualização, founder aprova — auto-rebuild rejeitado (CLAUDE.md
// seção Proposta Antes de Implementar).
//
// Este arquivo NÃO é uma projeção — é governança sobre projeções.
// Vive em governance/build-time/, não em projections/.
//
// Ref: P8 (design-principles.cue) — projeções são materialização descartável.
// Ref: P12 (design-principles.cue) — governança como código, fitness functions no CI.
// Ref: work-governance.cue — readyQueueAlgorithm e sourcesOfTruth.

// ── Tipo de entry no registro ───────────────────────────────────

// União discriminada: algorithmRef XOR algorithm.
// algorithmRef aponta para algoritmo canonizado em work-governance.cue
// (single source of truth). algorithm inline descreve a reconstrução
// quando não há algoritmo canonizado.
#ProjectionEntry: {
	id:             string & =~"^proj-[a-z][a-z0-9-]*$"
	description:    string & !=""
	projectionPath: string & =~"^governance/build-time/projections/[a-z-]+\\.cue$"
	sources: [string & !="", ...string & !=""]
	rationale: string & !=""
} & ({
	algorithmRef: string & !=""
	algorithm?:   _|_
} | {
	algorithm:    string & !=""
	algorithmRef?: _|_
})

// ── Registro de projeções ───────────────────────────────────────
//
// Toda projeção em projections/ deve estar registrada aqui.
// drift-02 valida essa invariante.

projectionRegistry: [ID=string]: #ProjectionEntry & {id: ID}

projectionRegistry: {
	"proj-ready-queue": {
		id:             "proj-ready-queue"
		description:    "Tarefas elegíveis para execução: admission=approved, execution=unclaimed, dependências satisfeitas, fase elegível."
		projectionPath: "governance/build-time/projections/ready-queue.cue"
		sources: [
			"governance/build-time/work-events/",
			"governance/build-time/work-graph.cue",
			"governance/build-time/task-specs/",
			"governance/build-time/task-governance.cue",
		]
		algorithmRef: "work-governance.cue seção orchestration.readyQueueAlgorithm"
		rationale:    "Ready-queue é a projeção primária do sistema de trabalho — guia qual tarefa o agente deve executar. Sources incluem task-specs (title, eligibleRoles) e task-governance (criticality) além de work-events e work-graph."
	}
	"proj-blocked-items": {
		id:             "proj-blocked-items"
		description:    "Work-items com executionState=blocked."
		projectionPath: "governance/build-time/projections/blocked-items.cue"
		sources: [
			"governance/build-time/work-events/",
			"governance/build-time/task-specs/",
		]
		algorithm: """
			1. Replay work-events para computar executionState de cada WI.
			2. Filtrar: executionState=blocked.
			3. Enriquecer com metadata de task-specs (title).
			4. Extrair reason e blockedBy do task-blocked event.
			5. Resultado: lista de #BlockedItemEntry.
			"""
		rationale: "Visibilidade de bloqueios permite priorização e desbloqueio proativo. task-specs necessário para title (não presente nos eventos)."
	}
	"proj-in-progress": {
		id:             "proj-in-progress"
		description:    "Work-items com executionState=claimed e claim não expirado."
		projectionPath: "governance/build-time/projections/in-progress.cue"
		sources: [
			"governance/build-time/work-events/",
			"governance/build-time/task-specs/",
			"governance/build-time/task-governance.cue",
		]
		algorithm: """
			1. Replay work-events para computar executionState de cada WI.
			2. Filtrar: executionState=claimed.
			3. Para cada claimed: verificar claimExpiresAt > timestamp de
			   referência (último evento da stream ou timestamp de CI run).
			4. Enriquecer com metadata de task-specs (title) e
			   task-governance (criticality).
			5. Resultado: lista de #InProgressEntry.
			"""
		rationale: "Visibilidade de WIs em execução ativa previne claims duplicados e informa capacidade. Nota: claim expiry depende de timestamp de referência — projeção é snapshot, não real-time."
	}
}

// ── Pipeline de drift detection ─────────────────────────────────
//
// Pipeline CI separado do ev-NN (validação de eventos).
// ev-NN opera sobre events, drift detection sobre projeções.
// Namespaces distintos: ev-NN vs drift-NN.

#DriftCheck: {
	id:          string & =~"^drift-[0-9]{2}$"
	description: string & !=""
	severity:    "fail" | "warn"
	enforcement: "procedural"
	algorithm:   string & !=""
	rationale:   string & !=""
}

driftDetectionPipeline: {
	rationale:      "Pipeline CI que valida consistência entre projeções commitadas e estado computado das SoTs. Separado do ev-NN — drift detection opera sobre projeções derivadas, não sobre eventos imutáveis."
	executionModel: "procedural-ci-over-spec"

	checks: [...#DriftCheck] & [{
		id:          "drift-01"
		description: "Projeção commitada é consistente com estado reconstruído das SoTs"
		severity:    "fail"
		enforcement: "procedural"
		algorithm: """
			Para cada entry em projectionRegistry:
			1. Ler sources declarados.
			2. Executar algorithm (ou algorithmRef) para computar
			   estado esperado (entries da projeção).
			3. Normalizar ambas as listas (esperada e commitada) por
			   taskId antes da comparação — ordem de lista não é
			   semântica, apenas taskId e campos estruturais.
			   rebuiltAt é ignorado (timestamp de reconstrução,
			   não estado semântico).
			4. Comparar entries normalizadas. Se divergência (entry
			   faltando, entry sobrando, ou campos divergentes):
			   fail com diff detalhado.
			"""
		rationale: "Drift silencioso em projeções cria decisões baseadas em estado stale — agente pode trabalhar em WI que já está claimed, ou ignorar WI que já está ready. Na Mesh, onde agentes operam com autonomia limitada sobre um backlog derivado, projeção stale é desinformação operacional."
	}, {
		id:          "drift-02"
		description: "Todo .cue em projections/ está registrado em projectionRegistry"
		severity:    "fail"
		enforcement: "procedural"
		algorithm: """
			1. Listar todos os .cue em governance/build-time/projections/.
			2. Para cada arquivo: verificar que existe entry em
			   projectionRegistry cujo projectionPath corresponde.
			3. Erro se arquivo de projeção não está registrado —
			   projeção fora do registro escapa de drift detection.
			"""
		rationale: "Projeção não registrada é blind spot — CI não detecta drift porque não sabe que existe. Registry completo é pré-condição de drift-01."
	}]
}

// ── Política de drift ───────────────────────────────────────────

driftPolicy: {
	tolerance: "exact-match"
	onDriftDetected: """
		CI falha. Agente identifica causa do drift (evento novo não
		acompanhado de rebuild, ou rebuild parcial). Propõe atualização
		da projeção ao founder. Founder aprova. Agente commita.
		Auto-rebuild com commit automático rejeitado — viola modelo
		proposta-antes-de-implementar (CLAUDE.md).
		"""
	rationale: """
		Tolerância zero na fase atual: volume de projeções é baixo (3),
		custo de manter consistência é marginal. Qualquer divergência é
		sinal de processo incompleto — o agente deve atualizar projeções
		no mesmo commit que altera SoTs. Se volume crescer e custo de
		zero-drift se tornar proibitivo, considerar tolerância por
		criticality da projeção.
		"""
}
