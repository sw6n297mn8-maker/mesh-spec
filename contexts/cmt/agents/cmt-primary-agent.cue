package cmt

// cmt-primary-agent.cue — Agent Spec: CMT Primary Agent.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Agente primário do CMT. Opera sobre o aggregate Commitment,
// processando propostas, aceite bilateral, sinalização de risco
// e gestão de estado do compromisso.
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária):
//   autonomyLevel por ação, escalation conditions, observability
// - lens-security-trust-infrastructure (secundária):
//   inputTrustLevel para commands com input externo
// - lens-regulatory-compliance-as-architecture (terciária):
//   auditTrail regulatory-grade para intermediário financeiro

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

cmtPrimaryAgent: artifact_schemas.#AgentSpec & {
	code:        "agt-cmt-primary"
	name:        "CMT Primary Agent"
	description: "Agente primário do Commitment Management. Opera o lifecycle do compromisso: processa propostas, executa aceite bilateral, sinaliza e limpa risco, reage a sinais de disputa, e gerencia suspensão/cancelamento/reativação sob supervisão. Operador principal referenciado pelo canvas."

	boundedContextRef: "cmt"
	role:              "domain-agent"
	governanceRef:     "cmt-primary-agent"

	// =============================================
	// ESCOPO OPERACIONAL
	// =============================================

	operationalScope: {
		aggregates: ["agg-commitment"]

		commands: [
			"cmd-propose-commitment",
			"cmd-confirm-commitment-acceptance",
			"cmd-flag-at-risk",
			"cmd-clear-risk-flag",
			"cmd-suspend-commitment",
			"cmd-reactivate-commitment",
			"cmd-handle-dispute-resolution",
			"cmd-cancel-commitment",
		]

		events: [
			"evt-commitment-proposed",
			"evt-commitment-accepted",
			"evt-commitment-state-changed",
			"evt-counterparty-risk-signaled",
			"evt-counterparty-risk-cleared",
			"evt-dispute-resolved-received",
			"evt-suspension-ordered-received",
		]

		invariants: [
			"inv-mutual-bilateral-acceptance",
			"inv-terms-reference-valid",
			"inv-commitment-id-uniqueness",
			"inv-proposer-counterparty-distinct",
			"inv-suspension-requires-supervision",
			"inv-cancellation-irreversible",
			"inv-reactivation-requires-supervision",
			"inv-cancelled-is-terminal",
		]

		projections: ["prj-commitment-state-view"]
	}

	// =============================================
	// AÇÕES
	// =============================================

	actions: [{
		code:            "act-process-proposal"
		name:            "Processar Proposta de Compromisso"
		description:     "Recebe ProposeCommitment, valida termos contra CTR (sync), verifica partes distintas, gera CommitmentId e registra proposta."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: ["cmd-propose-commitment", "agg-commitment", "evt-commitment-proposed", "inv-terms-reference-valid", "inv-proposer-counterparty-distinct", "inv-commitment-id-uniqueness"]
		preconditions: [
			"Termos contratuais referenciados existem e estão vigentes em CTR",
			"Proponente e contraparte são organizações distintas",
		]
		postconditions: [
			"Aggregate criado em estado proposed com CommitmentId único",
			"evt-commitment-proposed emitido (interno)",
		]
	}, {
		code:            "act-execute-bilateral-acceptance"
		name:            "Executar Aceite Bilateral"
		description:     "Recebe ConfirmCommitmentAcceptance, verifica identidade de termos entre proposta e confirmação, executa gate de aceite mútuo bilateral, publica CommitmentAccepted."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "external-structured"
		domainModelRefs: ["cmd-confirm-commitment-acceptance", "agg-commitment", "evt-commitment-accepted", "inv-mutual-bilateral-acceptance", "inv-terms-reference-valid"]
		preconditions: [
			"Compromisso em estado proposed",
			"Termos da confirmação são idênticos aos da proposta",
		]
		postconditions: [
			"Compromisso transiciona para accepted",
			"evt-commitment-accepted publicado para BDG e DRC",
		]
	}, {
		code:           "act-flag-at-risk"
		name:           "Sinalizar Compromisso em Risco"
		description:    "Reage a evt-counterparty-risk-signaled (ACL de REW), executa cmd-flag-at-risk em compromissos ativos da contraparte."
		category:       "mutation"
		autonomyLevel:  "execute-and-log"
		domainModelRefs: ["cmd-flag-at-risk", "agg-commitment", "evt-counterparty-risk-signaled", "evt-commitment-state-changed"]
		preconditions: [
			"Compromisso em estado accepted",
			"Sinal de risco recebido de REW via ACL",
		]
		postconditions: [
			"Compromisso transiciona para at-risk",
			"evt-commitment-state-changed emitido",
		]
	}, {
		code:           "act-clear-risk-flag"
		name:           "Limpar Sinalização de Risco"
		description:    "Reage a evt-counterparty-risk-cleared (ACL de REW), executa cmd-clear-risk-flag para retornar compromisso at-risk a accepted."
		category:       "mutation"
		autonomyLevel:  "execute-and-log"
		domainModelRefs: ["cmd-clear-risk-flag", "agg-commitment", "evt-counterparty-risk-cleared", "evt-commitment-state-changed"]
		preconditions: [
			"Compromisso em estado at-risk",
			"Sinal de resolução de risco recebido de REW via ACL",
		]
		postconditions: [
			"Compromisso retorna a accepted",
			"evt-commitment-state-changed emitido",
		]
	}, {
		code:           "act-recommend-suspension"
		name:           "Recomendar Suspensão de Compromisso"
		description:    "Reage a evt-suspension-ordered-received (ACL de DRC) ou escalação de at-risk. Propõe cmd-suspend-commitment ao supervisor humano com contexto de severidade."
		category:       "mutation"
		autonomyLevel:  "propose-and-wait"
		domainModelRefs: ["cmd-suspend-commitment", "agg-commitment", "evt-suspension-ordered-received", "evt-commitment-state-changed", "inv-suspension-requires-supervision"]
		preconditions: [
			"Compromisso em estado accepted ou at-risk",
			"Gate de supervisão humana pendente",
		]
		postconditions: [
			"Após aprovação: compromisso transiciona para suspended",
			"evt-commitment-state-changed emitido",
		]
	}, {
		code:           "act-recommend-reactivation"
		name:           "Recomendar Reativação de Compromisso"
		description:    "Propõe cmd-reactivate-commitment ao supervisor humano quando causa de suspensão foi resolvida. Exclusivo para transição suspended → accepted."
		category:       "mutation"
		autonomyLevel:  "propose-and-wait"
		domainModelRefs: ["cmd-reactivate-commitment", "agg-commitment", "evt-commitment-state-changed", "inv-reactivation-requires-supervision"]
		preconditions: [
			"Compromisso em estado suspended",
			"Causa de suspensão resolvida (disputa ou risco)",
		]
		postconditions: [
			"Após aprovação: compromisso transiciona para accepted",
			"evt-commitment-state-changed emitido",
		]
	}, {
		code:           "act-recommend-cancellation"
		name:           "Recomendar Cancelamento de Compromisso"
		description:    "Propõe cmd-cancel-commitment ao supervisor humano. Decisão terminal irreversível — requer contexto completo de impacto downstream."
		category:       "mutation"
		autonomyLevel:  "propose-and-wait"
		domainModelRefs: ["cmd-cancel-commitment", "agg-commitment", "evt-commitment-state-changed", "inv-cancellation-irreversible", "inv-cancelled-is-terminal"]
		preconditions: [
			"Compromisso em estado proposed, accepted, at-risk ou suspended",
		]
		postconditions: [
			"Após aprovação: compromisso transiciona para cancelled (terminal)",
			"evt-commitment-state-changed emitido",
		]
	}, {
		code:           "act-route-dispute-resolution"
		name:           "Rotear Resolução de Disputa"
		description:    "Reage a evt-dispute-resolved-received (ACL de DRC), executa cmd-handle-dispute-resolution. Aggregate inspeciona resolução e decide internamente: reativar, cancelar ou manter. Supervisão está nos commands terminais, não no routing."
		category:       "mutation"
		autonomyLevel:  "execute-and-log"
		domainModelRefs: ["cmd-handle-dispute-resolution", "agg-commitment", "evt-dispute-resolved-received"]
		preconditions: [
			"Compromisso em estado suspended ou at-risk",
			"Resolução de disputa recebida de DRC via ACL",
		]
		postconditions: [
			"Aggregate executa transição apropriada ao tipo de resolução",
		]
	}, {
		code:           "act-query-commitment-state"
		name:           "Consultar Estado do Compromisso"
		description:    "Atende QueryCommitmentState via projeção. Retorna estado canônico por CommitmentId."
		category:       "query"
		autonomyLevel:  "execute-and-log"
		domainModelRefs: ["prj-commitment-state-view", "qry-commitment-state"]
	}, {
		code:            "act-validate-terms-reference"
		name:            "Validar Referência a Termos Contratuais"
		description:     "Consulta CTR via QueryContractTerms para validar existência e vigência de termos referenciados. Decisão autônoma e determinística."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["inv-terms-reference-valid", "agg-commitment"]
		preconditions: [
			"CTR acessível via QueryContractTerms",
		]
		postconditions: [
			"Termos validados como existentes e vigentes, ou rejeição da proposta",
		]
	}]

	// =============================================
	// CONSTRAINTS
	// =============================================

	constraints: [{
		code:         "cst-no-unilateral-acceptance"
		name:         "Aceite Bilateral Obrigatório"
		description:  "Agente nunca publica CommitmentAccepted sem confirmação explícita de ambas as partes sobre termos idênticos."
		verification: "Runner verifica que toda invocação de act-execute-bilateral-acceptance passa pelo guard inv-mutual-bilateral-acceptance antes de emitir evt-commitment-accepted."
		onViolation:  "block-and-escalate"
		rationale:    "Invariante central do CMT. Violação cria compromisso unilateral — risco jurídico e financeiro."
	}, {
		code:         "cst-supervised-state-changes"
		name:         "Transições Supervisionadas Requerem Aprovação"
		description:  "Agente nunca executa suspensão, cancelamento ou reativação sem aprovação humana explícita. Propõe e aguarda."
		verification: "Runner verifica que ações com autonomyLevel propose-and-wait sobre cmd-suspend, cmd-cancel, cmd-reactivate nunca completam sem registro de aprovação humana no audit trail."
		onViolation:  "block-and-escalate"
		rationale:    "P10: agentes recomendam, gates validam. Transições supervisionadas afetam todo o commitment lifecycle downstream."
	}, {
		code:         "cst-no-action-on-cancelled"
		name:         "Nenhuma Ação em Compromisso Cancelado"
		description:  "Agente rejeita qualquer command direcionado a compromisso em estado cancelled."
		verification: "Runner verifica que nenhuma ação muta aggregate com currentState == cancelled. inv-cancelled-is-terminal é guard em todas as transições."
		onViolation:  "block-and-escalate"
		rationale:    "Cancelamento é terminal e irreversível. Qualquer mutação pós-cancelamento é bug ou tentativa de manipulação."
	}, {
		code:         "cst-terms-validated-before-acceptance"
		name:         "Termos Validados Antes de Aceite"
		description:  "Agente nunca progride proposta para accepted sem validação sync de termos contra CTR."
		verification: "Runner verifica que act-execute-bilateral-acceptance sempre invoca act-validate-terms-reference como precondition. Falha de validação bloqueia aceite."
		onViolation:  "block-and-escalate"
		rationale:    "Compromisso sem lastro contratual é risco jurídico. Validação é determinística e bloqueante."
	}, {
		code:         "cst-commitment-id-immutable"
		name:         "CommitmentId Imutável Após Criação"
		description:  "Agente nunca altera CommitmentId após geração em act-process-proposal."
		verification: "Runner verifica que nenhuma ação modifica campo commitmentId após criação do aggregate."
		onViolation:  "rollback-and-escalate"
		rationale:    "CommitmentId é fio de rastreabilidade end-to-end. Alteração quebraria vínculo com toda a cadeia downstream (BDG, DLV, INV, FCE)."
	}]

	// =============================================
	// ESCALATION CONDITIONS
	// =============================================

	escalationConditions: [{
		category:    "out-of-scope"
		description: "Tipo de compromisso não previsto nos templates existentes — novo vertical, novo padrão de formalização."
		rationale:   "Canvas escalation novel-commitment-type. Tipos novos podem ter invariantes não previstas. Decisão irreversível se compromisso for aceito sob premissas incorretas."
	}, {
		category:    "ambiguous-case"
		description: "Valor do compromisso excede threshold definido no autonomy envelope."
		rationale:   "Canvas escalation high-value-threshold. Compromissos de alto valor têm blast radius financeiro proporcional. Supervisão humana é controle de contenção."
	}, {
		category:    "ambiguous-case"
		description: "Termos ou estrutura do compromisso caem em zona cinza regulatória não coberta por regras existentes."
		rationale:   "Canvas escalation regulatory-ambiguity. Integridade legal é constraint inviolável (nível 1). Zona cinza exige julgamento humano especializado."
	}, {
		category:    "conflicting-signals"
		description: "Sinal de risco de REW contradiz estado operacional do compromisso — e.g., risco sinalizado para compromisso já suspenso por motivo diferente."
		rationale:   "Sinais conflitantes indicam situação não modelada. Agente não deve combinar ações sem supervisão."
	}, {
		category:    "suspicious-input"
		description: "Proposta de compromisso com padrão anômalo — valor inconsistente com histórico, partes não reconhecidas, termos fora do padrão do vertical."
		rationale:   "dp-08: custos de manipulação devem exceder benefícios. Padrões anômalos podem indicar tentativa de manipulação. Agente sinaliza antes de processar."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Governance scope define boundaries de autonomia e escalation criteria. Agente consulta para decidir autonomy level por ação."
			requiredSlices: ["ownership.governanceScope", "businessDecisions", "communication"]
		}, {
			artifactType: "domain-model"
			rationale:    "Building blocks operacionais: aggregate, commands, events, invariants, lifecycle transitions. Agente precisa do modelo completo para operar."
		}, {
			artifactType: "glossary"
			rationale:    "Linguagem ubíqua para interpretar input e gerar output na linguagem do BC. Essencial para tradução ACL de sinais externos."
			requiredSlices: ["terms"]
		}, {
			artifactType: "agent-governance"
			rationale:    "Envelope de governança com thresholds, calibração, blast radius caps. Agente consulta limites antes de cada ação."
		}]

		estimatedBudget: "moderate"
	}

	// =============================================
	// OBSERVABILITY
	// =============================================

	observability: {
		signals: [{
			code:           "sig-proposal-processed"
			name:           "Proposta Processada"
			description:    "Emitido após act-process-proposal completar. Inclui CommitmentId, resultado de validação de termos, partes."
			coversCategory: "mutation"
			trigger:        "Conclusão de processamento de ProposeCommitment."
			level:          "info"
		}, {
			code:           "sig-acceptance-completed"
			name:           "Aceite Bilateral Completado"
			description:    "Emitido após act-execute-bilateral-acceptance com aprovação humana. Inclui CommitmentId, timestamp de aceite."
			coversCategory: "mutation"
			trigger:        "Publicação de CommitmentAccepted após aprovação de supervisão."
			level:          "info"
		}, {
			code:           "sig-state-transition"
			name:           "Transição de Estado Executada"
			description:    "Emitido em qualquer transição de estado do lifecycle. Inclui previousState, newState, causeType, originContext."
			coversCategory: "mutation"
			trigger:        "Emissão de evt-commitment-state-changed."
			level:          "info"
		}, {
			code:           "sig-terms-validation-failed"
			name:           "Validação de Termos Falhou"
			description:    "Emitido quando act-validate-terms-reference rejeita — termos inexistentes ou expirados em CTR."
			coversCategory: "validation"
			trigger:        "QueryContractTerms retorna termos inválidos ou CTR indisponível."
			level:          "warn"
		}, {
			code:           "sig-escalation-triggered"
			name:           "Escalação Disparada"
			description:    "Emitido quando agente escala decisão ao supervisor. Inclui categoria, contexto mínimo, recomendação."
			coversCategory: "escalation"
			trigger:        "Qualquer condição de escalation atingida."
			level:          "warn"
		}, {
			code:           "sig-query-served"
			name:           "Consulta Atendida"
			description:    "Emitido após atender QueryCommitmentState. Inclui CommitmentId, estado retornado, consumer."
			coversCategory: "query"
			trigger:        "Atendimento de QueryCommitmentState via projeção."
			level:          "info"
		}]

		auditTrail: {
			requiredFields: [
				"timestamp",
				"agent-id",
				"action-code",
				"input-summary",
				"output-summary",
				"decision-rationale",
				"governance-version",
				"commitment-id",
				"previous-state",
				"new-state",
				"supervision-approval-ref",
			]
			storageHint: "Event Log do CMT — append-only, criptograficamente verificável via DGV."
			rationale:    "Campos mínimos regulatory-grade (tq-ag-13) mais campos domain-specific (commitment-id, states, supervision ref) para reconstituição completa de decisões sobre compromissos financeiros."
		}
	}

	rationale: "Agente primário e único do CMT. Opera como domain-agent sobre o aggregate Commitment com 10 ações: 4 autônomas determinísticas (processar proposta, flag/clear risco, routing de disputa), 1 autônoma de leitura (query), 1 autônoma de validação (termos CTR), 4 supervisionadas (aceite bilateral, suspensão, reativação, cancelamento). Autonomia segue canvas governance scope: ações determinísticas sem impacto financeiro irreversível são execute-and-log; ações que criam obrigação financeira ou afetam lifecycle downstream são propose-and-wait. Routing de disputa é execute-and-log porque o routing é mecânico — supervisão está nos commands terminais downstream. 5 constraints verificáveis cobrem aceite bilateral, supervisão de estado, terminality, validação de termos e imutabilidade de CommitmentId. 5 escalation conditions cobrem canvas criteria (tipo novo, alto valor, regulatória) mais sinais conflitantes e input suspeito. Observabilidade: 1 signal por categoria de ação + audit trail regulatory-grade com campos domain-specific."
}
