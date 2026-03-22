package build_time

// command-rights.cue — Source of truth formal de autoridade de commands.
//
// Materializa o modelo Read/Propose/Decide (README.md) como
// mapeamento command → roles autorizado. Ref: ADR-025.
//
// Relação com work-governance.cue: a seção commandAuthority.rights
// em work-governance.cue é contexto arquitetural (motivação e design).
// Este arquivo é a SoT consumível por CI para enforcement.
//
// Limitação: modelo é single-emission — um role emite o command.
// Não suporta co-assinatura (ex: spec-writer + founder para
// CompleteTask). Se necessário, evolução requer novo campo.
//
// Ausência de code-agent: tier Read não emite commands no sistema
// de governança de trabalho. code-agents consomem projeções
// derivadas, nunca alteram estado do backlog.

commandRights: {
	ProposeTask: #CommandRight & {
		command:       "ProposeTask"
		allowedRoles:  ["spec-writer"]
		decisionClass: "propose"
		effectClass:   "admission"
		rationale:     "Separação proposta/aprovação materializa tier Propose — agente sugere, nunca decide admissão."
	}

	ApproveTask: #CommandRight & {
		command:       "ApproveTask"
		allowedRoles:  ["founder"]
		decisionClass: "decide"
		effectClass:   "admission"
		rationale:     "Admissão determina o que entra no backlog — priorização é decisão estratégica, não operacional."
	}

	RejectTask: #CommandRight & {
		command:       "RejectTask"
		allowedRoles:  ["founder"]
		decisionClass: "decide"
		effectClass:   "admission"
		rationale:     "Rejeição elimina tarefa do pipeline — decisão com custo de oportunidade requer visão estratégica."
	}

	ClaimTask: #CommandRight & {
		command:       "ClaimTask"
		allowedRoles:  ["spec-writer"]
		decisionClass: "propose"
		effectClass:   "allocation"
		rationale:     "Claim é auto-alocação com lease — risco limitado pela expiração automática."
	}

	ReleaseTask: #CommandRight & {
		command:       "ReleaseTask"
		allowedRoles:  ["spec-writer"]
		decisionClass: "propose"
		effectClass:   "allocation"
		rationale:     "Release é voluntário e retorna tarefa ao pool — sem risco de perda."
	}

	BlockTask: #CommandRight & {
		command:       "BlockTask"
		allowedRoles:  ["spec-writer"]
		decisionClass: "propose"
		effectClass:   "execution_signal"
		rationale:     "Agente é quem descobre impedimentos durante execução — sinalização imediata reduz tempo de bloqueio."
	}

	UnblockTask: #CommandRight & {
		command:       "UnblockTask"
		allowedRoles:  ["spec-writer"]
		decisionClass: "propose"
		effectClass:   "execution_signal"
		rationale:     "Resolução de impedimento é operacional — agente confirma que a condição de bloqueio foi resolvida."
	}

	CompleteTask: #CommandRight & {
		command:       "CompleteTask"
		allowedRoles:  ["spec-writer"]
		decisionClass: "propose"
		effectClass:   "evidence_gated"
		rationale:     "Conclusão exige completionValidation com prova — o gate determinístico substitui aprovação humana por evidência."
	}

	CancelTask: #CommandRight & {
		command:       "CancelTask"
		allowedRoles:  ["founder"]
		decisionClass: "decide"
		effectClass:   "destructive"
		rationale:     "Cancelamento destrói trabalho em andamento e altera dependências — custo irreversível requer decisão estratégica."
	}

	ReopenTask: #CommandRight & {
		command:       "ReopenTask"
		allowedRoles:  ["founder"]
		decisionClass: "decide"
		effectClass:   "destructive"
		rationale:     "Reabertura invalida conclusão aceita e reinicia ciclo de execução — questiona a prova de validação anterior."
	}

	SupersedeTask: #CommandRight & {
		command:       "SupersedeTask"
		allowedRoles:  ["founder"]
		decisionClass: "decide"
		effectClass:   "topology_mutating"
		rationale:     "Substituição altera topologia do work-graph — dependências downstream precisam ser reavaliadas."
	}
}
