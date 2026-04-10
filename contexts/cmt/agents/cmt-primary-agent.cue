package cmt

// cmt-primary-agent.cue — Agent Spec: CMT Primary Agent.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Agente primário do CMT. Único operador do BC — processa todo o
// commitment lifecycle: propostas, aceite bilateral, sinalização de
// risco, suspensão, cancelamento e reativação.
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária): autonomyLevel por ação,
//   escalation conditions, observability contract
// - lens-security-trust-infrastructure (secundária): inputTrustLevel
//   para ações com input externo
//
// Fronteira spec ↔ governance (ADR-037):
// - Este spec declara QUANDO escalar e QUAL o nível de autonomia.
// - O governance envelope (cmt-primary-agent.governance.cue, WI-035)
//   declara COMO escalar (canal, SLA), calibração dinâmica e blast radius.
//
// Forward reference: governanceRef aponta para cmt-primary-agent —
// arquivo governance será criado por WI-035. Runner reportará tq-ag-09
// fail até WI-035 completar.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

agentSpec: artifact_schemas.#AgentSpec & {
	code: "agt-cmt-primary"
	name: "CMT Primary Agent"
	description: "Agente primário do Commitment Management. Único operador do BC — processa todo o commitment lifecycle desde proposta até cancelamento. Opera sobre o aggregate Commitment, executa commands, verifica invariants e reage a eventos ACL de REW, DRC, P2P e CTR. Decisões autônomas limitadas a validação determinística, registro de fatos e sinalização/resolução de risco. Decisões com impacto financeiro irreversível (aceite, suspensão, cancelamento, reativação) requerem supervisão humana."

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
			"cmd-cancel-commitment",
			"cmd-handle-dispute-resolution",
		]

		events: [
			"evt-commitment-proposed",
			"evt-commitment-accepted",
			"evt-commitment-state-changed",
			"evt-counterparty-risk-signaled",
			"evt-dispute-resolved-received",
			"evt-suspension-ordered-received",
			"evt-counterparty-risk-cleared",
			"evt-purchase-order-received",
			"evt-contract-terms-activated-received",
			"evt-contract-terms-superseded-received",
		]

		invariants: [
			"inv-mutual-bilateral-acceptance",
			"inv-terms-reference-valid",
			"inv-commitment-id-uniqueness",
			"inv-suspension-requires-supervision",
			"inv-cancellation-irreversible",
			"inv-reactivation-requires-supervision",
			"inv-proposer-counterparty-distinct",
			"inv-cancelled-is-terminal",
		]

		projections: ["prj-commitment-state-view"]
	}

	// =============================================
	// AÇÕES
	// =============================================

	actions: [{
		code:          "act-validate-terms"
		name:          "Validar Referência a Termos Contratuais"
		description:   "Valida que termos contratuais referenciados em proposta existem e estão vigentes em CTR via QueryContractTerms."
		category:      "validation"
		autonomyLevel: "execute-and-log"
		domainModelRefs: ["inv-terms-reference-valid", "cmd-propose-commitment"]
		preconditions: ["Proposta de compromisso recebida com contractTermsRef preenchido"]
		postconditions: ["Termos validados como vigentes em CTR ou proposta rejeitada com razão estruturada"]
	}, {
		code:            "act-propose-commitment"
		name:            "Propor Compromisso a partir de Pedido de Compra"
		description:     "Cria proposta de compromisso bilateral a partir de pedido de compra spot recebido de P2P via ACL. Enriquece com contractTermsRef via QueryContractTerms. Agente prepara proposta — humano aprova antes de registrar."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-propose-commitment", "evt-purchase-order-received", "evt-commitment-proposed", "agg-commitment"]
		preconditions: ["evt-purchase-order-received recebido via ACL de P2P", "Termos contratuais validados em CTR (act-validate-terms)"]
		postconditions: ["Compromisso criado em estado proposed após aprovação humana", "evt-commitment-proposed registrado"]
	}, {
		code:          "act-flag-at-risk"
		name:          "Sinalizar Compromisso At-Risk"
		description:   "Sinaliza compromissos ativos cuja contraparte recebeu alerta de risco de REW. Reação determinística a evt-counterparty-risk-signaled."
		category:      "mutation"
		autonomyLevel: "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-flag-at-risk", "evt-counterparty-risk-signaled", "agg-commitment"]
		preconditions: ["evt-counterparty-risk-signaled recebido", "Compromisso em estado accepted"]
		postconditions: ["Compromisso transicionado para at-risk", "evt-commitment-state-changed publicado"]
	}, {
		code:          "act-clear-risk-flag"
		name:          "Remover Sinalização de Risco"
		description:   "Remove sinalização de risco quando REW resolve alerta de contraparte. Reação determinística a evt-counterparty-risk-cleared."
		category:      "mutation"
		autonomyLevel: "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-clear-risk-flag", "evt-counterparty-risk-cleared", "agg-commitment"]
		preconditions: ["evt-counterparty-risk-cleared recebido", "Compromisso em estado at-risk"]
		postconditions: ["Compromisso retornado para accepted", "evt-commitment-state-changed publicado"]
	}, {
		code:          "act-propose-acceptance"
		name:          "Propor Aceite de Compromisso"
		description:   "Prepara e propõe formalização final do compromisso após gate de aceite bilateral. Agente verifica invariants e propõe — humano aprova execução."
		category:      "mutation"
		autonomyLevel: "propose-and-wait"
		inputTrustLevel: "external-structured"
		domainModelRefs: ["cmd-confirm-commitment-acceptance", "inv-mutual-bilateral-acceptance", "inv-terms-reference-valid", "inv-proposer-counterparty-distinct", "agg-commitment"]
		preconditions: ["Proposta existente em estado proposed", "Confirmação da contraparte recebida"]
		postconditions: ["Compromisso transicionado para accepted após aprovação humana", "CommitmentAccepted publicado para BDG, DRC, TCM"]
	}, {
		code:          "act-propose-suspension"
		name:          "Propor Suspensão de Compromisso"
		description:   "Analisa cenário de risco ou disputa e propõe suspensão. Agente recomenda — humano autoriza via mech-agent-gate."
		category:      "mutation"
		autonomyLevel: "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-suspend-commitment", "inv-suspension-requires-supervision", "evt-suspension-ordered-received", "agg-commitment"]
		preconditions: ["Compromisso em estado accepted ou at-risk", "Sinal de risco ou ordem de suspensão recebido"]
		postconditions: ["Compromisso transicionado para suspended após aprovação humana", "evt-commitment-state-changed publicado"]
	}, {
		code:          "act-propose-cancellation"
		name:          "Propor Cancelamento de Compromisso"
		description:   "Analisa resolução de disputa ou decisão operacional e propõe cancelamento definitivo. Decisão terminal irreversível — requer supervisão."
		category:      "mutation"
		autonomyLevel: "propose-and-wait"
		domainModelRefs: ["cmd-cancel-commitment", "inv-cancellation-irreversible", "inv-cancelled-is-terminal", "agg-commitment"]
		preconditions: ["Compromisso em estado proposed, accepted, at-risk ou suspended"]
		postconditions: ["Compromisso transicionado para cancelled após aprovação humana", "evt-commitment-state-changed publicado"]
	}, {
		code:          "act-propose-reactivation"
		name:          "Propor Reativação de Compromisso"
		description:   "Analisa resolução favorável de disputa e propõe reativação de compromisso suspenso. Restaura obrigações financeiras — requer supervisão."
		category:      "mutation"
		autonomyLevel: "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-reactivate-commitment", "inv-reactivation-requires-supervision", "evt-dispute-resolved-received", "agg-commitment"]
		preconditions: ["Compromisso em estado suspended", "Resolução favorável de disputa recebida de DRC"]
		postconditions: ["Compromisso retornado para accepted após aprovação humana", "evt-commitment-state-changed publicado"]
	}, {
		code:            "act-handle-dispute-resolution"
		name:            "Rotear Resolução de Disputa"
		description:     "Recebe resolução de disputa de DRC e roteia para ação apropriada: propor reativação (act-propose-reactivation), propor cancelamento (act-propose-cancellation) ou manter estado corrente. Supervisionado porque outcomes incluem decisões com impacto financeiro."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-handle-dispute-resolution", "evt-dispute-resolved-received", "agg-commitment"]
		preconditions: ["evt-dispute-resolved-received recebido via ACL de DRC"]
		postconditions: ["Outcome roteado para ação supervisionada correspondente, ou estado mantido com justificativa"]
	}, {
		code:          "act-query-commitment-state"
		name:          "Consultar Estado do Compromisso"
		description:   "Consulta projeção de estado corrente do compromisso para informar decisões operacionais e responder queries de BCs downstream."
		category:      "query"
		autonomyLevel: "execute-and-log"
		domainModelRefs: ["prj-commitment-state-view"]
		preconditions: ["CommitmentId válido"]
		postconditions: ["Estado canônico retornado sem efeito colateral"]
	}]

	// =============================================
	// CONSTRAINTS
	// =============================================

	constraints: [{
		code:         "cst-bilateral-gate"
		name:         "Gate Bilateral Obrigatório"
		description:  "Agente nunca executa aceite de compromisso sem confirmação explícita de ambas as partes sobre termos idênticos."
		verification: "Runner verifica que act-propose-acceptance referencia inv-mutual-bilateral-acceptance e que autonomyLevel é propose-and-wait. Audit trail de cada aceite contém evidência de confirmação bilateral."
		onViolation:  "block-and-escalate"
		rationale:    "inv-mutual-bilateral-acceptance é invariante central do CMT. Violação cria obrigação financeira unilateral — dano irreversível."
	}, {
		code:         "cst-terms-validation-mandatory"
		name:         "Validação de Termos Obrigatória"
		description:  "Agente nunca propõe aceite de compromisso sem validar vigência dos termos contratuais em CTR via QueryContractTerms."
		verification: "Runner verifica que act-validate-terms é precondição de act-propose-acceptance via domainModelRefs compartilhados (inv-terms-reference-valid). Audit trail contém resultado da validação de termos."
		onViolation:  "block-and-escalate"
		rationale:    "Compromisso sem lastro contratual é risco jurídico (canvas: bd-terms-validation). Constraint inviolável por integridade legal."
	}, {
		code:         "cst-distinct-parties"
		name:         "Partes Distintas Obrigatórias"
		description:  "Agente rejeita proposta de compromisso onde proponente e contraparte são a mesma organização."
		verification: "Runner verifica que act-propose-commitment e act-propose-acceptance comparam ParticipantId de proponente e contraparte no audit trail. Proposta com partes idênticas é rejeitada antes de registrar."
		onViolation:  "block-and-escalate"
		rationale:    "inv-proposer-counterparty-distinct: auto-compromisso anula aceite mútuo e abre vetor de manipulação trivial (dp-08)."
	}, {
		code:         "cst-unique-commitment-id"
		name:         "Unicidade de CommitmentId"
		description:  "Agente garante que cada CommitmentId gerado é único globalmente no CMT."
		verification: "Runner verifica que act-propose-commitment gera CommitmentId que não existe na projeção prj-commitment-state-view. Audit trail registra ID gerado e resultado da verificação de unicidade."
		onViolation:  "block-and-escalate"
		rationale:    "inv-commitment-id-uniqueness: ID duplicado quebra rastreabilidade end-to-end (BDG, DLV, INV, FCE)."
	}, {
		code:         "cst-no-action-on-cancelled"
		name:         "Nenhuma Ação sobre Cancelado"
		description:  "Agente rejeita qualquer command de mutação sobre compromisso em estado cancelled."
		verification: "Runner verifica que nenhuma ação de categoria mutation é executada sobre compromisso cujo currentState é cancelled. Audit trail registra rejeição com motivo."
		onViolation:  "block-and-escalate"
		rationale:    "inv-cancelled-is-terminal: estado terminal por definição — nenhuma transição permitida from cancelled."
	}, {
		code:         "cst-supervision-suspension"
		name:         "Suspensão Requer Supervisão"
		description:  "Agente nunca executa suspensão de compromisso sem aprovação humana registrada."
		verification: "Runner verifica que act-propose-suspension tem autonomyLevel propose-and-wait. Audit trail contém approval-id de humano antes da mutação."
		onViolation:  "block-and-escalate"
		rationale:    "inv-suspension-requires-supervision: P10, agentes recomendam, gates validam. Suspensão afeta lifecycle inteiro downstream."
	}, {
		code:         "cst-supervision-cancellation"
		name:         "Cancelamento Requer Supervisão"
		description:  "Agente nunca executa cancelamento de compromisso sem aprovação humana registrada. Decisão terminal irreversível."
		verification: "Runner verifica que act-propose-cancellation tem autonomyLevel propose-and-wait. Audit trail contém approval-id de humano antes da mutação."
		onViolation:  "block-and-escalate"
		rationale:    "inv-cancellation-irreversible: irreversibilidade satisfaz reversibilityThreshold. P10 exige gate humano."
	}, {
		code:         "cst-supervision-reactivation"
		name:         "Reativação Requer Supervisão"
		description:  "Agente nunca executa reativação de compromisso suspenso sem aprovação humana registrada."
		verification: "Runner verifica que act-propose-reactivation tem autonomyLevel propose-and-wait. Audit trail contém approval-id de humano antes da mutação."
		onViolation:  "block-and-escalate"
		rationale:    "inv-reactivation-requires-supervision: restauração de obrigações financeiras exige mesmo nível de supervisão da suspensão."
	}]

	// =============================================
	// ESCALATION CONDITIONS
	// =============================================

	escalationConditions: [{
		category:    "out-of-scope"
		description: "Tipo de compromisso não previsto nos templates existentes — novo vertical, novo padrão de formalização. Agente não tem referência para validar conformidade."
		rationale:   "Canvas escalationCriteria novel-commitment-type. Tipos novos podem ter invariantes não previstas — decisão irreversível se aceito sob premissas incorretas."
	}, {
		category:    "out-of-scope"
		description: "Valor do compromisso excede threshold definido no autonomy envelope. Agente escala para aprovação humana antes de publicar CommitmentAccepted."
		rationale:   "Canvas escalationCriteria high-value-threshold. Blast radius financeiro proporcional ao valor — supervisão é controle de contenção."
	}, {
		category:    "ambiguous-case"
		description: "Termos ou estrutura do compromisso caem em zona cinza regulatória não coberta por regras existentes. Agente não consegue determinar conformidade."
		rationale:   "Canvas escalationCriteria regulatory-ambiguity. Integridade legal é constraint inviolável (nível 1). Zona cinza exige julgamento humano especializado."
	}, {
		category:    "conflicting-signals"
		description: "Sinais contraditórios de REW e DRC sobre mesmo compromisso — e.g., REW sinaliza risco cleared enquanto DRC ordena suspensão. Agente não pode resolver conflito autonomamente."
		rationale:   "Agente com mutations deve cobrir conflicting-signals (tq-ag-10). Conflito entre BCs upstream exige julgamento humano sobre precedência."
	}, {
		category:    "insufficient-context"
		description: "Contexto insuficiente para processar proposta ou transição — e.g., QueryContractTerms retorna dados incompletos, ou confirmação bilateral tem campos ambíguos."
		rationale:   "Agente com mutations deve cobrir insufficient-context (tq-ag-10). Decisão com dados incompletos gera risco de obrigação financeira incorreta."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Canvas define governanceScope (autonomousDecisions, supervisedDecisions, escalationCriteria), stakeholders e incentiveAnalysis — necessário para calibrar autonomia e detectar adversarial patterns."
			requiredSlices: ["ownership", "governanceScope", "incentiveAnalysis", "communication"]
		}, {
			artifactType: "domain-model"
			rationale:    "Domain model define aggregates, commands, events, invariants, policies e lifecycle — mapa operacional completo do agente."
		}, {
			artifactType: "glossary"
			rationale:    "Glossário CMT define termos canônicos — agente precisa interpretar inputs usando linguagem ubíqua do BC."
			requiredSlices: ["terms"]
		}, {
			artifactType: "agent-governance"
			rationale:    "Governance envelope define calibração dinâmica, blast radius limits, thresholds e canais de escalation. Agente consulta envelope para decisões calibráveis."
		}, {
			artifactType: "context-map"
			rationale:    "Context map define relações upstream/downstream e integration patterns — necessário para processar eventos ACL corretamente."
			requiredSlices: ["relationships where upstream or downstream is cmt"]
		}]

		estimatedBudget: "heavy"
	}

	// =============================================
	// OBSERVABILITY
	// =============================================

	observability: {
		signals: [{
			code:           "sig-mutation-executed"
			name:           "Mutação Executada"
			description:    "Emitido após cada command processado pelo aggregate — transição de estado registrada."
			coversCategory: "mutation"
			trigger:        "Command processado com sucesso e evento publicado."
			level:          "info"
		}, {
			code:           "sig-validation-result"
			name:           "Resultado de Validação"
			description:    "Emitido após cada validação de termos contratuais — resultado (pass/fail) com detalhes."
			coversCategory: "validation"
			trigger:        "act-validate-terms executado."
			level:          "info"
		}, {
			code:           "sig-escalation-triggered"
			name:           "Escalation Disparada"
			description:    "Emitido quando agente identifica condição de escalation e transfere decisão para humano."
			coversCategory: "escalation"
			trigger:        "Qualquer escalationCondition satisfeita."
			level:          "warn"
		}, {
			code:           "sig-query-served"
			name:           "Query Atendida"
			description:    "Emitido após cada consulta à projeção de estado — CommitmentId e resultado."
			coversCategory: "query"
			trigger:        "act-query-commitment-state executado."
			level:          "info"
		}, {
			code:           "sig-supervision-requested"
			name:           "Supervisão Humana Solicitada"
			description:    "Emitido quando agente propõe decisão supervisionada (aceite, suspensão, cancelamento, reativação) e aguarda aprovação."
			coversCategory: "mutation"
			trigger:        "Ação com autonomyLevel propose-and-wait submetida para aprovação."
			level:          "warn"
		}, {
			code:           "sig-constraint-violation"
			name:           "Violação de Constraint"
			description:    "Emitido quando ação do agente viola constraint — ação bloqueada e escalada."
			coversCategory: "mutation"
			trigger:        "Constraint com onViolation block-and-escalate ativada."
			level:          "error"
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
				"autonomy-level-applied",
				"constraints-evaluated",
			]

			storageHint: "Event Log imutável do CMT — mesmo store dos domain events, partição separada para audit trail do agente."

			rationale: "Intermediário financeiro regulado (SCD/Bacen) requer reconstituição completa de decisões. Os 7 campos mínimos (_minimumAuditFields) são regulatory-grade. 3 campos adicionais (commitment-id, autonomy-level-applied, constraints-evaluated) permitem correlação com domain events e verificação de compliance do governance envelope."
		}
	}

	rationale: "Agente primário e único do CMT. Domain-agent que opera sobre todo o commitment lifecycle — single aggregate, 8 commands, 10 events, 8 invariants, 5 policies, 1 projection. 10 ações: 4 execute-and-log (validação de termos, sinalização de risco, resolução de risco, consulta de estado) + 6 propose-and-wait (proposta de compromisso via P2P, aceite bilateral, suspensão, cancelamento, reativação, routing de resolução de disputa). 8 constraints verificáveis com block-and-escalate — cobertura 1:1 com os 8 invariants do domain model. 5 escalation conditions cobrindo canvas criteria (novel-commitment-type, high-value-threshold, regulatory-ambiguity) + coerência com tq-ag-10 (conflicting-signals, insufficient-context). 6 signals de observabilidade cobrindo todas as categorias de ação. Audit trail regulatory-grade com 10 campos (7 mínimos + 3 operacionais). Forward reference: governanceRef aponta para cmt-primary-agent.governance.cue (WI-035). Alinhado com canvas, domain-model, context-map v2, lente lens-ai-agent-governance e design principles."
}
