package build_time

// event-validation.cue — Regras de validação CI para work-events.
//
// Define o pipeline de validação que CI executa sobre streams de eventos.
// Não duplica regras existentes — referencia work-governance.cue (state
// machines) e command-rights.cue (autoridade) como fontes de verdade.
//
// Contribuições próprias deste artefato:
// 1. Mapeamento eventType → commandType (relação não formalizada nos fontes)
// 2. Invariantes procedurais (idempotência, claim exclusivo, admission gate,
//    taskVersion consistency)
// 3. Pipeline ordenado com IDs referenciáveis em logs de CI
//
// Bootstrap: eventos de WI-015 foram emitidos antes deste artefato.
// CI não os valida retroativamente — mesma lógica do backfill (ADR-024).
//
// Acoplamento: eventCommandMappings deve cobrir todos os valores de
// #EventType. Se novo eventType for adicionado a work-governance.cue,
// mapeamento correspondente deve ser adicionado aqui. CI deve emitir
// warning quando encontrar eventType sem mapeamento.

// ── Dependências intra-package ───────────────────────────────────
//
// Os tipos abaixo são definidos em work-governance.cue (mesmo package
// build_time) e resolvidos por CUE package unification — sem import:
//   #CommandType  — union de command types válidos
//   #EventType    — union de event types válidos
//   #CommandRight — schema de direito de command (command-rights.cue)

// ── Mapeamento evento → command ──────────────────────────────────
//
// Formaliza a relação implícita entre eventos (fatos imutáveis) e
// commands (intenções que os originaram). CI usa este mapeamento +
// command-rights.cue para validar autoridade do actor.

#EventCommandMapping: {
	commandType: #CommandType
	peerBased:   *false | true
	rationale:   string & !=""
}

// Struct indexado por eventType para lookup direto por CI.
eventCommandMappings: {
	"task-proposed": #EventCommandMapping & {
		commandType: "ProposeTask"
		rationale:   "Agente propõe tarefa para admissão no backlog."
	}
	"task-approved": #EventCommandMapping & {
		commandType: "ApproveTask"
		rationale:   "Founder aprova tarefa para execução."
	}
	"task-rejected": #EventCommandMapping & {
		commandType: "RejectTask"
		rationale:   "Founder rejeita proposta de tarefa."
	}
	"task-claimed": #EventCommandMapping & {
		commandType: "ClaimTask"
		rationale:   "Agente reivindica tarefa com lease."
	}
	"task-claim-expired": #EventCommandMapping & {
		commandType: "ClaimTask"
		peerBased:   true
		rationale:   "task-claim-expired não corresponde semanticamente a ClaimTask; o mapeamento reutiliza ClaimTask apenas como proxy de authority porque o sistema ainda não possui commandType específico para expiração peer-based."
	}
	"task-released": #EventCommandMapping & {
		commandType: "ReleaseTask"
		rationale:   "Agente libera tarefa que reivindicou."
	}
	"task-blocked": #EventCommandMapping & {
		commandType: "BlockTask"
		rationale:   "Agente sinaliza impedimento durante execução."
	}
	"task-unblocked": #EventCommandMapping & {
		commandType: "UnblockTask"
		rationale:   "Agente resolve impedimento."
	}
	"task-completed": #EventCommandMapping & {
		commandType: "CompleteTask"
		rationale:   "Agente conclui tarefa com prova de validação."
	}
	"task-reopened": #EventCommandMapping & {
		commandType: "ReopenTask"
		rationale:   "Founder reabre tarefa concluída incorretamente."
	}
	"task-cancelled": #EventCommandMapping & {
		commandType: "CancelTask"
		rationale:   "Founder cancela tarefa."
	}
	"task-superseded": #EventCommandMapping & {
		commandType: "SupersedeTask"
		rationale:   "Founder substitui tarefa por nova versão."
	}
}

// ── Pipeline de validação ────────────────────────────────────────

#EventValidationCheck: {
	id:          string & =~"^ev-[0-9]{2}$"
	description: string & !=""
	severity:    "fail" | "warn"
	enforcement: "cue-native" | "procedural"
	source?:     string & !=""
	algorithm?:  string & !=""
	rationale:   string & !=""
}

eventValidationPipeline: {
	rationale:      "Pipeline ordenado de validações CI sobre work-events. Cada check tem ID estável para referência em logs e relatórios de CI."
	executionModel: "procedural-ci-over-spec"

	checks: [...#EventValidationCheck] & [{
		id:          "ev-01"
		description: "Evento estruturalmente válido"
		severity:    "fail"
		enforcement: "cue-native"
		source:      "work-governance.cue (#WorkEvent closed union)"
		rationale:   "Barreira estrutural: cue vet rejeita eventos malformados antes de qualquer validação semântica."
	}, {
		id:          "ev-02"
		description: "Transição de estado válida conforme state machines"
		severity:    "fail"
		enforcement: "procedural"
		source:      "work-governance.cue seções admissionStateMachine e executionStateMachine"
		algorithm: """
			Para cada stream: replay sequencial dos eventos computando
			(admissionState, executionState) a partir do estado inicial
			(defined, none). Para cada evento, verificar que (fromState,
			trigger) → toState existe em transitions[] da state machine
			correspondente. Admission events alteram admissionState,
			execution events alteram executionState. Erro se transição
			não existe na tabela.
			"""
		rationale: "State machine é a invariante fundamental — transição inválida corrompe o estado derivado do work-item."
	}, {
		id:          "ev-03"
		description: "Actor tem autoridade para o command correspondente"
		severity:    "fail"
		enforcement: "procedural"
		source:      "command-rights.cue via eventCommandMappings (este arquivo)"
		algorithm: """
			Para cada evento: (1) lookup eventType em eventCommandMappings
			→ commandType; (2) lookup commandType em commandRights →
			allowedRoles; (3) verificar evento.actor ∈ allowedRoles.
			Erro se actor não tem autoridade para o command.
			"""
		rationale: "Sem enforcement de autoridade, qualquer actor emite qualquer command — modelo de tiers Read/Propose/Decide se torna decorativo."
	}, {
		id:          "ev-04"
		description: "commandId único dentro da stream"
		severity:    "fail"
		enforcement: "procedural"
		algorithm: """
			Para cada stream: coletar todos os commandId. Verificar
			unicidade. Erro se duplicata encontrada.
			"""
		rationale: "Unicidade de commandId é o mecanismo de idempotência (P6) — duplicata destrói a garantia de exactly-once."
	}, {
		id:          "ev-05"
		description: "No máximo um claim ativo por work-item"
		severity:    "fail"
		enforcement: "procedural"
		algorithm: """
			Para cada stream: computar executionState via replay (ev-02).
			Se executionState computado é 'claimed' e novo task-claimed
			aparece, erro. Claim ativo é definido pelo estado computado,
			não pela presença ou ausência de eventos específicos.
			"""
		rationale: "Múltiplos claims simultâneos criam conflito de execução — exatamente o cenário que leases existem para evitar."
	}, {
		id:          "ev-06"
		description: "Eventos de execução só após admission approved"
		severity:    "fail"
		enforcement: "procedural"
		source:      "work-governance.cue seção validStatePairs"
		algorithm: """
			Para cada stream: computar admissionState via replay (ev-02).
			Eventos cujo trigger aparece em executionStateMachine.transitions
			só podem ocorrer quando admissionState computado é 'approved'.
			Erro se evento de execução precede task-approved na sequência.
			"""
		rationale: "Execução sem admissão aprovada viola separação de camadas — agente não pode auto-autorizar trabalho."
	}, {
		id:          "ev-07"
		description: "taskVersion consistente dentro da stream"
		severity:    "fail"
		enforcement: "procedural"
		algorithm: """
			Para cada stream: verificar que todos os eventos carregam
			o mesmo taskVersion. Mudança de versão requer task-superseded
			(stream antiga) + nova stream. Erro se taskVersion varia
			dentro da mesma stream.
			"""
		rationale: "Stream é indexada por taskId. Versão é parte da identidade (id, version). Misturar versões na mesma stream corrompe identidade."
	}]
}
