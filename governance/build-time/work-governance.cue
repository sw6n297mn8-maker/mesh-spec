package build_time

// Arquitetura de Governança de Trabalho da Mesh
//
// Especificação formal do sistema de coordenação de agentes no build-time.
// Define como tarefas são definidas, admitidas, executadas e auditadas.
//
// Princípio estrutural: 4 camadas separadas (TaskSpec, Backlog Admission,
// Execution, Projections) eliminam confusão entre o que uma tarefa é,
// quando entra no backlog, quem executa e qual o estado atual.

// ============================================================
// Tipos fundamentais
// ============================================================

#AdmissionState: "defined" | "proposed" | "approved" | "rejected"

#ExecutionState: "unclaimed" | "claimed" | "blocked" | "completed" | "cancelled" | "superseded"
// Nota: não existe estado "released". task-released é evento que
// transiciona claimed → unclaimed. task-unblocked transiciona
// blocked → unclaimed.

#ExecutionStateOrNone: #ExecutionState | "none"

#FinalAdmissionState: "rejected"
#FinalExecutionState: "completed" | "cancelled" | "superseded"

#EventType:
	"task-proposed" |
	"task-approved" |
	"task-rejected" |
	"task-claimed" |
	"task-claim-expired" |
	"task-released" |
	"task-blocked" |
	"task-unblocked" |
	"task-completed" |
	"task-reopened" |
	"task-cancelled" |
	"task-superseded"

#CommandType:
	"ProposeTask" |
	"ApproveTask" |
	"RejectTask" |
	"ClaimTask" |
	"ReleaseTask" |
	"BlockTask" |
	"UnblockTask" |
	"CompleteTask" |
	"CancelTask" |
	"ReopenTask" |
	"SupersedeTask"

#Tier: "Decide" | "Propose" | "Read"
#Role: "founder" | "spec-writer" | "code-agent"
#Criticality: "low" | "medium" | "high" | "critical"

// ============================================================
// Transições de estado
// ============================================================

#StateTransition: {
	from:      string
	to:        string
	trigger:   #EventType
	rationale: string
}

// ============================================================
// Eventos
// ============================================================

// Campos base compartilhados — interno, usado apenas para composição.
// Cada evento carrega taskId e taskVersion para auditabilidade
// independente do stream file que o contém.
_#workEventBase: {
	eventType:   #EventType
	taskId:      string & =~"^WI-[0-9]{3}$"
	taskVersion: int & >=1
	commandId:   string & =~"^WI-[0-9]{3}-[a-z]+-.*$"
	timestamp:   string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"
	actor:       string & !=""
	...
}

#TaskProposedEvent: _#workEventBase & {
	eventType: "task-proposed"
}

#TaskApprovedEvent: _#workEventBase & {
	eventType: "task-approved"
}

#TaskRejectedEvent: _#workEventBase & {
	eventType: "task-rejected"
	reason:    string & !=""
}

#TaskClaimedEvent: _#workEventBase & {
	eventType:      "task-claimed"
	claimExpiresAt: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"
}

#TaskClaimExpiredEvent: _#workEventBase & {
	eventType:              "task-claim-expired"
	originalClaimCommandId: string & !=""
}

#TaskReleasedEvent: _#workEventBase & {
	eventType: "task-released"
	reason:    string & !=""
}

#TaskBlockedEvent: _#workEventBase & {
	eventType:  "task-blocked"
	reason:     string & !=""
	blockedBy?: string & =~"^WI-[0-9]{3}$"
}

#TaskUnblockedEvent: _#workEventBase & {
	eventType:  "task-unblocked"
	resolution: string & !=""
}

#TaskCompletedEvent: _#workEventBase & {
	eventType:            "task-completed"
	completionValidation: #CompletionValidation
}

#TaskReopenedEvent: _#workEventBase & {
	eventType: "task-reopened"
	reason:    string & !=""
}

#TaskCancelledEvent: _#workEventBase & {
	eventType: "task-cancelled"
	reason:    string & !=""
}

#TaskSupersededEvent: _#workEventBase & {
	eventType:    "task-superseded"
	supersededBy: string & =~"^WI-[0-9]{3}$"
	reason:       string & !=""
}

// União fechada de todos os tipos concretos de evento.
// Usado para validação — não permite campos arbitrários.
#WorkEvent:
	#TaskProposedEvent |
	#TaskApprovedEvent |
	#TaskRejectedEvent |
	#TaskClaimedEvent |
	#TaskClaimExpiredEvent |
	#TaskReleasedEvent |
	#TaskBlockedEvent |
	#TaskUnblockedEvent |
	#TaskCompletedEvent |
	#TaskReopenedEvent |
	#TaskCancelledEvent |
	#TaskSupersededEvent

#CompletionValidation: {
	validationRunId:      string & !=""
	artifactSnapshotHash: string & !=""
	gatesPassed:          [string & !="", ...string & !=""]
}

// ============================================================
// TaskSpec
// ============================================================

#TaskSpec: {
	id:                    string & =~"^WI-[0-9]{3}$"
	version:               int & >=1
	title:                 string & !=""
	templateRef?:          string & !=""
	semanticPrerequisites: [...string & !=""]
	affects:               [...string & !=""]
	outputs:               [...string & !=""]
	rationale:             string & !=""
}

// ============================================================
// Governança operacional
// ============================================================

// Campos base de governança — interno, usado apenas para composição.
_#taskGovernanceBase: {
	eligibleRoles:        [#Role, ...#Role]
	approvalRequired:     bool | *true
	criticality:          #Criticality
	defaultLeaseDuration: string & !=""
	rationale:            string & !=""
	...
}

// União discriminada por scope: regra por tarefa específica ou por template.
#TaskGovernanceRule:
	(_#taskGovernanceBase & {
		scope:        "task"
		taskId:       string & =~"^WI-[0-9]{3}$"
		taskVersion?: int & >=1
	}) |
	(_#taskGovernanceBase & {
		scope:       "template"
		templateRef: string & !=""
	})

// ============================================================
// Autoridade de commands
// ============================================================

#CommandRight: {
	command:      #CommandType
	allowedRoles: [#Role, ...#Role]
	rationale:    string & !=""
}

// ============================================================
// Work graph
// ============================================================

#Phase: {
	id:        string & !=""
	order:     int & >=0
	rationale: string & !=""
}

#Group: {
	id:        string & !=""
	phaseId:   string & !=""
	rationale: string & !=""
}

#ExecutionDependency: {
	taskId: string & =~"^WI-[0-9]{3}$"
	dependsOn: [...{
		taskId:  string & =~"^WI-[0-9]{3}$"
		version: int & >=1
	}]
	phaseId:  string & !=""
	groupId?: string & !=""
}

// ============================================================
// Projeções
// ============================================================

#ReadyQueueEntry: {
	taskId:        string & =~"^WI-[0-9]{3}$"
	version:       int & >=1
	title:         string & !=""
	eligibleRoles: [#Role, ...#Role]
	criticality:   #Criticality
}

// ============================================================
// Stream file
// ============================================================

#WorkItemStream: {
	events: [...#WorkEvent]
}

// ============================================================
// Especificação do sistema
// ============================================================

workGovernance: {
	_metadata: {
		title:   "Arquitetura de Governança de Trabalho"
		version: "1.0.0"
		rationale: """
			Define como agentes coordenam trabalho dentro do mesh-spec.
			Garante governança explícita, auditabilidade, tolerância a erro
			de agentes, coordenação determinística e robustez contra
			comportamento incorreto de IA.
			"""
	}

	// ────────────────────────────────────────────────────────
	// Separação de camadas
	// ────────────────────────────────────────────────────────
	layers: {
		rationale: "Separação elimina confusões entre o que uma tarefa é, quando ela entra no backlog, quem executa e qual é o estado atual."
		taskSpec: {
			description: "Definição normativa da tarefa"
			location:    "governance/build-time/task-specs/{wi-id}.cue"
		}
		backlogAdmission: {
			description: "Ativação da tarefa no backlog via evento task-proposed"
			location:    "governance/build-time/work-events/{wi-id}.cue"
		}
		execution: {
			description: "Execução da tarefa (claim, block, complete)"
			location:    "governance/build-time/work-events/{wi-id}.cue"
		}
		projections: {
			description: "Estado derivado, reconstruível e descartável"
			location:    "governance/build-time/projections/"
		}
	}

	// ────────────────────────────────────────────────────────
	// Máquina de estados: admission
	// ────────────────────────────────────────────────────────
	admissionStateMachine: {
		rationale: "Controla entrada da tarefa no backlog. Requer aprovação explícita do founder antes de execução."
		states: ["defined", "proposed", "approved", "rejected"]
		finalStates: ["rejected"]
		transitions: [{
			from: "defined", to: "proposed", trigger: "task-proposed"
			rationale: "TaskSpec ativado no backlog."
		}, {
			from: "proposed", to: "approved", trigger: "task-approved"
			rationale: "Founder confirma que a tarefa faz sentido no momento."
		}, {
			from: "proposed", to: "rejected", trigger: "task-rejected"
			rationale: "Founder rejeita a proposta."
		}]
	}

	// ────────────────────────────────────────────────────────
	// Máquina de estados: execution
	// ────────────────────────────────────────────────────────
	executionStateMachine: {
		rationale: """
			Controla ciclo de vida da execução. Estados são: unclaimed,
			claimed, blocked, completed, cancelled, superseded. Não existe
			estado 'released' — task-released é evento que transiciona
			claimed → unclaimed. task-unblocked transiciona
			blocked → unclaimed.
			"""
		states: ["unclaimed", "claimed", "blocked", "completed", "cancelled", "superseded"]
		finalStates: ["completed", "cancelled", "superseded"]
		transitions: [{
			from: "unclaimed", to: "claimed", trigger: "task-claimed"
			rationale: "Agente reivindica a tarefa com lease."
		}, {
			from: "claimed", to: "unclaimed", trigger: "task-released"
			rationale: "Agente libera a tarefa voluntariamente. Retorna ao pool."
		}, {
			from: "claimed", to: "unclaimed", trigger: "task-claim-expired"
			rationale: "Lease expirado. Recuperação automática peer-based."
		}, {
			from: "claimed", to: "blocked", trigger: "task-blocked"
			rationale: "Impedimento encontrado durante execução."
		}, {
			from: "claimed", to: "completed", trigger: "task-completed"
			rationale: "Tarefa concluída com prova de validação."
		}, {
			from: "blocked", to: "unclaimed", trigger: "task-unblocked"
			rationale: "Impedimento resolvido. Tarefa retorna ao pool para novo claim."
		}, {
			from: "unclaimed", to: "cancelled", trigger: "task-cancelled"
			rationale: "Tarefa cancelada antes de execução."
		}, {
			from: "claimed", to: "cancelled", trigger: "task-cancelled"
			rationale: "Tarefa cancelada durante execução."
		}, {
			from: "blocked", to: "cancelled", trigger: "task-cancelled"
			rationale: "Tarefa cancelada enquanto bloqueada."
		}, {
			from: "unclaimed", to: "superseded", trigger: "task-superseded"
			rationale: "Tarefa substituída por outra versão ou tarefa."
		}, {
			from: "completed", to: "unclaimed", trigger: "task-reopened"
			rationale: "Conclusão incorreta detectada. Tarefa reaberta."
		}]
	}

	// ────────────────────────────────────────────────────────
	// Pares válidos admission × execution
	// ────────────────────────────────────────────────────────
	validStatePairs: {
		rationale: "Execution state só existe após admission atingir 'proposed'. Execution só avança além de 'unclaimed' após admission atingir 'approved'."
		pairs: [{
			admission: "defined"
			execution: "none"
			rationale: "TaskSpec existe, sem atividade no backlog."
		}, {
			admission: "proposed"
			execution: "unclaimed"
			rationale: "Aguardando aprovação."
		}, {
			admission: "approved"
			execution: "unclaimed"
			rationale: "Pronto para claim."
		}, {
			admission: "approved"
			execution: "claimed"
			rationale: "Em execução."
		}, {
			admission: "approved"
			execution: "blocked"
			rationale: "Bloqueado durante execução."
		}, {
			admission: "approved"
			execution: "completed"
			rationale: "Concluído."
		}, {
			admission: "approved"
			execution: "cancelled"
			rationale: "Cancelado após aprovação."
		}, {
			admission: "approved"
			execution: "superseded"
			rationale: "Substituído por outra tarefa."
		}, {
			admission: "rejected"
			execution: "none"
			rationale: "Terminal — sem estado de execução."
		}]
	}

	// ────────────────────────────────────────────────────────
	// Versionamento
	// ────────────────────────────────────────────────────────
	versioning: {
		rationale: """
			Identidade de tarefa é (id, version). Apenas uma versão pode
			estar ativa no backlog. version é int, não string. Rótulo
			humano WI-XXX@vN é convenção textual, não valor estrutural.
			"""
		identityKey:       "(TaskSpec.id, TaskSpec.version)"
		versionType:       "int"
		humanLabel:        "WI-{id}@v{version}"
		humanLabelExample: "WI-001@v1"
		constraint:        "Apenas uma versão ativa no backlog por id. Versão anterior deve estar em estado final antes de nova versão ser proposta."
	}

	// ────────────────────────────────────────────────────────
	// Idempotência
	// ────────────────────────────────────────────────────────
	idempotency: {
		rationale:            "Todo command carrega commandId único. Mesmo commandId = mesmo efeito. CI valida unicidade dentro da stream do work-item."
		admissionIdempotency: "Para cada (taskId, taskVersion), no máximo um task-proposed."
		commandIdFormat:      "{wi-id}-{command-type}-{discriminator}"
		discriminatorNote:    "Discriminator é agent-id ou timestamp. Para task-claim-expired, é determinístico: {wi-id}-expire-claim-{original-claimCommandId}."
	}

	// ────────────────────────────────────────────────────────
	// Emissão de commands
	// ────────────────────────────────────────────────────────
	commandEmission: {
		rationale: """
			O agente materializa um command como proposta de append de
			evento ao stream. O evento só se torna fato canônico após
			validação no merge + CI. Não existe camada separada de
			command-proposals.
			"""
		mechanism:    "Agente appenda evento ao stream file, commita com mensagem convencional, faz push."
		commitFormat: "work: {CommandType} {wi-id}@v{version}"
		acceptance:   "merge + CI validation"
		ciValidations: [
			"Evento estruturalmente válido (cue vet)",
			"Transição de estado válida (product state machine)",
			"Agente tem autoridade (command-rights.cue)",
			"commandId único na stream",
			"No máximo um task-claimed ativo por work-item",
		]
	}

	// ────────────────────────────────────────────────────────
	// Autoridade (mapeamento tier → commands)
	// ────────────────────────────────────────────────────────
	commandAuthority: {
		rationale: "Alinhado com modelo de tiers Read/Propose/Decide da Mesh."
		rights: [{
			command: "ApproveTask", allowedRoles: ["founder"]
			rationale: "Decisão de admissão é exclusiva do founder."
		}, {
			command: "RejectTask", allowedRoles: ["founder"]
			rationale: "Rejeição é decisão, não proposta."
		}, {
			command: "SupersedeTask", allowedRoles: ["founder"]
			rationale: "Substituição altera topologia — requer autoridade Decide."
		}, {
			command: "CancelTask", allowedRoles: ["founder"]
			rationale: "Cancelamento é irreversível."
		}, {
			command: "ReopenTask", allowedRoles: ["founder"]
			rationale: "Reabertura reverte conclusão — requer autoridade Decide."
		}, {
			command: "ProposeTask", allowedRoles: ["spec-writer"]
			rationale: "Agente propõe, founder aprova."
		}, {
			command: "ClaimTask", allowedRoles: ["spec-writer"]
			rationale: "Agente reivindica para executar."
		}, {
			command: "ReleaseTask", allowedRoles: ["spec-writer"]
			rationale: "Agente libera tarefa que reivindicou."
		}, {
			command: "BlockTask", allowedRoles: ["spec-writer"]
			rationale: "Agente sinaliza impedimento."
		}, {
			command: "UnblockTask", allowedRoles: ["spec-writer"]
			rationale: "Agente resolve impedimento."
		}, {
			command: "CompleteTask", allowedRoles: ["spec-writer"]
			rationale: "Agente conclui com prova de validação."
		}]
	}

	// ────────────────────────────────────────────────────────
	// Claims com lease
	// ────────────────────────────────────────────────────────
	claimLeases: {
		rationale: "Claims possuem expiração para recuperação automática de tarefas abandonadas. Verificação peer-based elimina necessidade de scheduler central."
		defaults: [{
			criticality: "low", defaultLease: "24h"
			rationale: "Tarefas de baixa prioridade podem levar mais tempo."
		}, {
			criticality: "medium", defaultLease: "8h"
			rationale: "Balanço entre autonomia e recuperação."
		}, {
			criticality: "high", defaultLease: "4h"
			rationale: "Tarefas importantes recuperam rápido."
		}, {
			criticality: "critical", defaultLease: "2h"
			rationale: "Máxima urgência de recuperação."
		}]
		expirationMechanism: "peer-based"
		expirationDescription: """
			Qualquer agente que computa a ready-queue inspeciona
			claimExpiresAt. Se now > claimExpiresAt, emite
			task-claim-expired antes de prosseguir. Seguro porque:
			evento idempotente (commandId determinístico), first valid
			event wins (serialização por git), CI valida unicidade.
			"""
	}

	// ────────────────────────────────────────────────────────
	// Conclusão de tarefa
	// ────────────────────────────────────────────────────────
	taskCompletion: {
		rationale: "Prova de validação obrigatória. Alinhado com P10 (stochastic recommendations, deterministic gates) e P11 (evidence-backed movements) aplicados ao build-time."
		requires:  "completionValidation com validationRunId, artifactSnapshotHash, gatesPassed"
	}

	// ────────────────────────────────────────────────────────
	// Topologia: fases e grupos
	// ────────────────────────────────────────────────────────
	topology: {
		phases: {
			rationale: "Fase é estágio ordenado de trabalho. Todas as tarefas de uma fase devem estar em estado final antes que tarefas da fase seguinte se tornem elegíveis."
			semantics: "Barreira de execução: fase N+1 só inicia quando fase N está completa."
		}
		groups: {
			rationale: "Agrupamento lógico dentro de uma fase. Sem ordenação de execução entre groups."
			semantics: "Groups podem ser usados como heurística de descoberta, mas nunca como fonte de autoridade ou elegibilidade. Elegibilidade vem exclusivamente de task-governance.cue."
		}
		dependencyRule: "Dependências sempre apontam para versão específica: {taskId, version}. Nunca referência sem versão."
	}

	// ────────────────────────────────────────────────────────
	// Serialização e armazenamento
	// ────────────────────────────────────────────────────────
	eventStorage: {
		rationale: """
			Event sourcing leve sobre git — não há event store dedicado,
			replay engine, nem snapshots. Git fornece linearização,
			persistência e auditabilidade. Eventos dentro de stream files
			fornecem semântica de domínio.
			"""
		canonicalOrder:    "commit SHA → dentro do commit: path + ordem textual"
		streamFilePattern: "governance/build-time/work-events/{wi-id}.cue"
		appendOnly: """
			Eventos nunca são removidos, editados ou reordenados dentro de
			um stream file. Correções exclusivamente por novos eventos
			compensatórios.
			"""
		scalingNote: """
			Sistema assume dezenas a baixas centenas de work-items ativos.
			Se volume exceder essa ordem de grandeza, armazenamento pode
			migrar para batch files agrupados por fase ou período. Migração
			não altera semântica — apenas layout físico.
			"""
	}

	// ────────────────────────────────────────────────────────
	// Projeções
	// ────────────────────────────────────────────────────────
	projections: {
		rationale: """
			Estado derivado. Alinhado com P0 (Three Sources of Truth) e
			P8 (Projections as Materializations). Projeções podem ser
			deletadas a qualquer momento sem perda de informação.
			Reconstrução a partir das fontes de verdade restaura o estado
			completo.
			"""
		location: "governance/build-time/projections/"
		examples: ["ready-queue.cue", "blocked-items.cue", "in-progress.cue"]
		authoritative:        false
		reconstructible:      true
		deletableWithoutLoss: true
	}

	// ────────────────────────────────────────────────────────
	// Fontes de verdade
	// ────────────────────────────────────────────────────────
	sourcesOfTruth: {
		rationale: "Tudo fora destas fontes é materialização reconstruível e descartável."
		sources: [{
			artifact: "task-specs/"
			role:     "Definição normativa das tarefas"
		}, {
			artifact: "task-governance.cue"
			role:     "Regras de execução"
		}, {
			artifact: "work-graph.cue"
			role:     "Topologia de dependências"
		}, {
			artifact: "work-events/"
			role:     "Fatos imutáveis (eventos)"
		}, {
			artifact: "command-rights.cue"
			role:     "Autoridade de commands"
		}]
	}

	// ────────────────────────────────────────────────────────
	// Correção de erros
	// ────────────────────────────────────────────────────────
	errorCorrection: {
		rationale: """
			Erros são corrigidos com novos eventos, nunca editando eventos
			existentes. Git revert corrige artefatos de código. Eventos
			corrigem estado semântico do backlog. Mecanismos complementares
			em camadas diferentes.
			"""
		compensatoryEvents: [{
			error: "Conclusão incorreta", correction: "task-reopened"
		}, {
			error: "Claim abandonado", correction: "task-claim-expired"
		}, {
			error: "Tarefa substituída", correction: "task-superseded"
		}]
	}

	// ────────────────────────────────────────────────────────
	// Orquestração descentralizada
	// ────────────────────────────────────────────────────────
	orchestration: {
		rationale: "Não existe orchestrator central. Backlog executável é derivado das fontes de verdade. Qualquer agente pode computar a ready-queue."
		readyQueueAlgorithm: [
			"Ler todos os stream files e reconstruir estado atual de cada work-item",
			"Filtrar tarefas com admission=approved, execution=unclaimed",
			"Verificar que todas as dependências (work-graph) estão em estado final",
			"Verificar que a fase da tarefa é elegível (todas as tarefas de fases anteriores em estado final)",
			"Resultado: lista de tarefas elegíveis",
		]
	}

	// ────────────────────────────────────────────────────────
	// Interação com modelo de operação existente
	// ────────────────────────────────────────────────────────
	existingModelInteraction: {
		rationale: "Este sistema complementa as regras do CLAUDE.md — não as substitui."
		mappings: [{
			existing:   "Proposta Antes de Implementar"
			equivalent: "Agente só executa tarefa com admission=approved. Aprovação no work governance É a aprovação do founder."
		}, {
			existing:   "Tiers Read/Propose/Decide"
			equivalent: "Mapeados em command-rights.cue"
		}, {
			existing:   "Founder é a única autoridade"
			equivalent: "Founder detém commands Decide"
		}, {
			existing:   "Nunca prosseguir com incerteza"
			equivalent: "Agente emite BlockTask com motivo"
		}]
		unchanged: [
			"Agente mostra conteúdo proposto no chat antes de escrever",
			"Founder aprova cada artefato individualmente",
			"cue vet obrigatório antes de commit",
			"Validação semântica em sessão separada obrigatória",
		]
		added: [
			"Visibilidade formal do que precisa ser feito",
			"Ordem de execução verificável",
			"Histórico de quem fez o quê e quando",
			"Recuperação automática de claims abandonados",
			"Prova de conclusão",
		]
	}

	// ────────────────────────────────────────────────────────
	// Estrutura de diretórios
	// ────────────────────────────────────────────────────────
	directoryStructure: {
		rationale: "Layout físico do sistema de governança de trabalho."
		root:      "governance/build-time/"
		directories: {
			"task-specs/":  "TaskSpecs: definição normativa de cada tarefa"
			"work-events/": "Streams de eventos: um arquivo por work-item"
			"projections/": "Estado derivado (reconstruível e descartável)"
		}
		files: {
			"task-governance.cue": "Regras de execução: roles, aprovação, criticality, lease defaults"
			"work-graph.cue":      "Topologia: dependências, fases, grupos"
			"command-rights.cue":  "Autoridade: quem pode emitir cada command"
			"work-governance.cue": "Este arquivo: especificação arquitetural do sistema"
		}
	}

	// ────────────────────────────────────────────────────────
	// Implementação incremental
	// ────────────────────────────────────────────────────────
	implementationPhases: {
		rationale: "Sistema não precisa existir no dia 1. Construção incremental por evidência de necessidade."
		phases: [{
			id:      "phase-0"
			name:    "Mínimo funcional"
			trigger: "Agora"
			includes: [
				"TaskSpecs para tarefas conhecidas",
				"work-graph.cue com dependências e fases",
				"Projeção ready-queue manual (agente computa na sessão)",
			]
			excludes: [
				"Events, claims, leases",
				"Founder aprova via chat (modelo atual)",
			]
		}, {
			id:      "phase-1"
			name:    "Governança formal"
			trigger: "Quando houver 2+ agentes"
			includes: [
				"task-governance.cue com roles, aprovação e lease defaults",
				"command-rights.cue com mapeamento tier→commands",
				"Stream files com eventos",
				"CI valida transições e unicidade de claims",
			]
		}, {
			id:      "phase-2"
			name:    "Robustez"
			trigger: "Quando houver evidência de falha"
			includes: [
				"Claims com lease e expiração peer-based",
				"completionValidation com artifactSnapshotHash",
				"Projeções automatizadas",
			]
		}]
	}

	// ────────────────────────────────────────────────────────
	// Comportamento do agente
	// ────────────────────────────────────────────────────────
	agentBehavior: {
		rationale: "Define o fluxo padrão de operação do agente neste sistema."
		standardFlow: [
			"Ler ready-queue (projeção) ou computar a partir das fontes de verdade",
			"Verificar elegibilidade: role do agente ∈ eligibleRoles da tarefa",
			"Emitir ClaimTask (append evento + commit + push)",
			"Executar a tarefa seguindo templateRef e regras do CLAUDE.md",
			"Validar outputs (cue vet, gates obrigatórios)",
			"Emitir CompleteTask com completionValidation (append evento + commit + push)",
		]
		prohibitions: [
			"Editar projeções diretamente",
			"Alterar eventos existentes em stream files",
			"Ignorar governança (command-rights, task-governance)",
			"Assumir dependências implícitas (sempre consultar work-graph)",
			"Executar tarefa sem claim ativo e não-expirado",
		]
	}
}
