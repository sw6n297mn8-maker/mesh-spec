package build_time

// claim-expiration-validation.cue — Regras de validação CI para expiração de claims.
//
// Extensão do pipeline de event-validation.cue com checks específicos
// para task-claim-expired. Define fórmula determinística de commandId
// e validações de referência ao claim original.
//
// Ref: work-governance.cue seção claimLeases (mecanismo peer-based).
// Ref: #TaskClaimExpiredEvent (work-governance.cue).
//
// Composição: o pipeline efetivo de validação é a união de
// eventValidationPipeline.checks (event-validation.cue) e
// claimExpirationValidation.checks (este arquivo). IDs ev-08..ev-10
// pertencem ao mesmo namespace lógico (ev-NN).

// ── Fórmula determinística de commandId ────────────────────────
//
// Qualquer agente que detecta expiração gera o mesmo commandId.
// Git serializa: first valid event wins. ev-04 rejeita duplicatas.

claimExpirationCommandIdFormula: {
	pattern: "{taskId}-claim-expired-{originalClaimCommandId}"
	example: "WI-016-claim-expired-WI-016-claim-20260322"
	rationale: """
		Determinismo garante idempotência peer-based: N agentes
		detectando a mesma expiração produzem o mesmo commandId.
		Combinado com ev-04 (unicidade), apenas o primeiro commit
		vence. Nota: regex de commandId (^WI-[0-9]{3}-[a-z]+-.*$)
		captura 'claim' como verbo e '-expired-...' como sufixo —
		compatível sintaticamente, verbo semântico real é
		'claim-expired'.
		"""
}

// ── Validação de claim expiration ──────────────────────────────

claimExpirationValidation: {
	rationale: "Checks específicos para task-claim-expired. Complementam o pipeline base (ev-01..ev-07) com validações que só se aplicam a eventos de expiração peer-based."

	checks: [...#EventValidationCheck] & [{
		id:          "ev-08"
		description: "originalClaimCommandId referencia claim existente na stream"
		severity:    "fail"
		enforcement: "procedural"
		source:      "#TaskClaimExpiredEvent.originalClaimCommandId → #TaskClaimedEvent.commandId"
		algorithm: """
			Para cada task-claim-expired na stream: buscar evento com
			eventType 'task-claimed' cujo commandId ==
			originalClaimCommandId. Erro se não encontrado. Busca
			restrita à mesma stream (mesmo taskId).
			"""
		rationale: "Referência a claim inexistente invalida o evento inteiro — expiração sem claim é contradição lógica."
	}, {
		id:          "ev-09"
		description: "commandId de task-claim-expired segue fórmula determinística"
		severity:    "fail"
		enforcement: "procedural"
		source:      "claimExpirationCommandIdFormula (este arquivo)"
		algorithm: """
			Para cada task-claim-expired: verificar que commandId ==
			'{taskId}-claim-expired-{originalClaimCommandId}'.
			Erro se commandId não conforma com a fórmula.
			"""
		rationale: "commandId não-determinístico quebra idempotência peer-based — dois agentes detectando a mesma expiração gerariam commandIds diferentes, violando unicidade (ev-04)."
	}, {
		id:          "ev-10"
		description: "Claim efetivamente expirado no momento do evento"
		severity:    "fail"
		enforcement: "procedural"
		source:      "#TaskClaimedEvent.claimExpiresAt vs #TaskClaimExpiredEvent.timestamp"
		algorithm: """
			Para cada task-claim-expired: buscar task-claimed
			referenciado (ev-08). Extrair claimExpiresAt. Verificar
			que task-claim-expired.timestamp >= claimExpiresAt.
			Erro se timestamp < claimExpiresAt (claim ainda válido).
			"""
		rationale: "Emitir expiração antes do prazo é falso-positivo — corrompe estado do work-item e pode causar claim conflict se o agente original ainda está trabalhando."
	}]
}
