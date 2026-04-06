package npm

// npm-primary-agent.cue — Agent Spec: NPM Primary Agent.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Agente primário do NPM. Único operador do BC — processa todo o
// participant lifecycle: registro, qualificação, suspensão,
// reativação e terminação.
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária): autonomyLevel por ação,
//   escalation conditions, observability contract
// - lens-security-trust-infrastructure (secundária): inputTrustLevel
//   para ações com input externo
//
// Fronteira spec ↔ governance (ADR-037):
// - Este spec declara QUANDO escalar e QUAL o nível de autonomia.
// - O governance envelope (npm-primary-agent.governance.cue)
//   declara COMO escalar (canal, SLA), calibração dinâmica e blast radius.
//
// Forward reference: governanceRef aponta para npm-primary-agent —
// arquivo governance será criado posteriormente. Runner reportará
// tq-ag-09 fail até governance envelope existir.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

agentSpec: artifact_schemas.#AgentSpec & {
	code: "agt-npm-primary"
	name: "NPM Primary Agent"
	description: "Agente primário do Network Participant Management. Único operador do BC — processa todo o participant lifecycle desde registro até terminação. Opera sobre o aggregate Participant, executa commands, verifica invariants e reage a evento ACL de IDC. Decisões autônomas limitadas a validação determinística (completude cadastral, formato documental, expiração), solicitação de verificação a IDC e publicação de eventos. Decisões com impacto cross-context (qualificação, suspensão, reativação, terminação) requerem supervisão humana."

	boundedContextRef: "npm"
	role:              "domain-agent"
	governanceRef:     "npm-primary-agent"

	// =============================================
	// ESCOPO OPERACIONAL
	// =============================================

	operationalScope: {
		aggregates: ["agg-participant"]

		commands: [
			"cmd-register-participant",
			"cmd-submit-qualification-documents",
			"cmd-approve-qualification",
			"cmd-suspend-participant",
			"cmd-reactivate-participant",
			"cmd-terminate-participant",
			"cmd-record-identity-verification",
		]

		events: [
			"evt-participant-registered",
			"evt-participant-qualified",
			"evt-participant-suspended",
			"evt-participant-terminated",
			"evt-participant-reactivated",
			"evt-qualification-documents-received",
			"evt-identity-verification-received",
		]

		invariants: [
			"inv-qualification-gate",
			"inv-approval-requires-identity-verification",
			"inv-termination-irreversible",
			"inv-supervision-required-for-material-decisions",
			"inv-registration-completeness",
			"inv-single-active-identity",
		]

		projections: [
			"prj-participant-status-view",
			"prj-participant-profile-view",
		]
	}

	// =============================================
	// AÇÕES
	// =============================================

	actions: [{
		code:            "act-validate-registration"
		name:            "Validar Completude Cadastral"
		description:     "Valida completude de dados cadastrais na submissão de registro — CNPJ, razão social, dados de contato. Validação determinística sem margem para julgamento."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: ["cmd-register-participant", "inv-registration-completeness", "agg-participant"]
		preconditions: ["Submissão de registro recebida com dados cadastrais"]
		postconditions: ["Dados validados como completos ou submissão rejeitada com campos faltantes identificados"]
	}, {
		code:            "act-register-participant"
		name:            "Registrar Participante"
		description:     "Cria participante em estado pending após validação de completude cadastral. Publica ParticipantRegistered para NGR, REW e NIM. Verifica unicidade de CNPJ antes de criar."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: ["cmd-register-participant", "inv-registration-completeness", "inv-single-active-identity", "evt-participant-registered", "agg-participant"]
		preconditions: ["Dados cadastrais validados (act-validate-registration)", "Nenhum participante ativo com mesmo CNPJ (inv-single-active-identity)"]
		postconditions: ["Participante criado em estado pending", "evt-participant-registered publicado"]
	}, {
		code:          "act-request-identity-verification"
		name:          "Solicitar Verificação de Identidade"
		description:   "Solicita a IDC verificação de identidade do participante recém-registrado. Requisição determinística e sem efeito colateral no domínio NPM — apenas inicia processo em IDC. Resultado retorna assincronamente via evt-identity-verification-received."
		category:      "mutation"
		autonomyLevel: "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["evt-participant-registered", "agg-participant"]
		preconditions: ["Participante registrado em estado pending (evt-participant-registered emitido)"]
		postconditions: ["Requisição de verificação de identidade enviada a IDC", "Resultado esperado assincronamente via ACL"]
	}, {
		code:            "act-receive-qualification-documents"
		name:            "Receber Documentação de Qualificação"
		description:     "Recebe e registra documentação KYC/AML submetida pelo participante. Validação de formato e completude documental é autônoma. Conteúdo da documentação é avaliado na qualificação supervisionada."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-untrusted-freeform"
		domainModelRefs: ["cmd-submit-qualification-documents", "evt-qualification-documents-received", "agg-participant"]
		preconditions: ["Participante em estado pending", "Documentação KYC/AML submetida"]
		postconditions: ["Documentação registrada", "evt-qualification-documents-received emitido internamente"]
	}, {
		code:            "act-record-identity-verification"
		name:            "Registrar Verificação de Identidade"
		description:     "Reação a evt-identity-verification-received (ACL de IDC). Atualiza flag de verificação no aggregate. Reação determinística — policy event→command."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-record-identity-verification", "evt-identity-verification-received", "agg-participant"]
		preconditions: ["evt-identity-verification-received recebido via ACL de IDC"]
		postconditions: ["Flag identityVerified atualizada no aggregate"]
	}, {
		code:            "act-monitor-qualification-expiry"
		name:            "Monitorar Expiração de Documentos"
		description:     "Monitora expiração de documentos de qualificação com cadência periódica. Sinaliza necessidade de renovação sem alterar status — sinalização não é suspensão."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["agg-participant", "prj-participant-profile-view"]
		preconditions: ["Participante em estado qualified"]
		postconditions: ["Sinalização de expiração emitida ou nenhuma ação se documentos vigentes"]
	}, {
		code:            "act-propose-qualification"
		name:            "Propor Aprovação de Qualificação"
		description:     "Prepara e propõe aprovação de qualificação após KYC/AML completo. Verifica pré-condição: identidade confirmada em IDC via query pull (QueryIdentityVerificationStatus). Agente prepara — supervisor aprova."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-approve-qualification", "inv-qualification-gate", "inv-approval-requires-identity-verification", "inv-supervision-required-for-material-decisions", "evt-participant-qualified", "agg-participant"]
		preconditions: ["Participante em estado pending", "Documentação KYC/AML recebida", "Identidade verificada em IDC (query pull confirma)"]
		postconditions: ["Participante transicionado para qualified após aprovação humana", "evt-participant-qualified publicado"]
	}, {
		code:            "act-propose-suspension"
		name:            "Propor Suspensão de Participante"
		description:     "Analisa irregularidade detectada e propõe suspensão temporária. Agente recomenda — supervisor autoriza. Suspensão bloqueia operações em BCs downstream."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-suspend-participant", "inv-supervision-required-for-material-decisions", "evt-participant-suspended", "agg-participant"]
		preconditions: ["Participante em estado qualified", "Irregularidade detectada (monitoramento contínuo, sinal externo ou análise manual)"]
		postconditions: ["Participante transicionado para suspended após aprovação humana", "evt-participant-suspended publicado"]
	}, {
		code:            "act-propose-reactivation"
		name:            "Propor Reativação de Participante"
		description:     "Analisa resolução de irregularidade e propõe reativação. Agente verifica evidência — supervisor autoriza restauração de operações na rede."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-reactivate-participant", "inv-supervision-required-for-material-decisions", "evt-participant-reactivated", "agg-participant"]
		preconditions: ["Participante em estado suspended", "Evidência de resolução de irregularidade apresentada"]
		postconditions: ["Participante transicionado para qualified após aprovação humana", "evt-participant-reactivated publicado"]
	}, {
		code:            "act-propose-termination"
		name:            "Propor Terminação de Participante"
		description:     "Analisa cenário de terminação (fraude, sanção regulatória, decisão judicial, saída voluntária) e propõe exclusão definitiva. Decisão irreversível — requer supervisão com justificativa documentada."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["cmd-terminate-participant", "inv-termination-irreversible", "inv-supervision-required-for-material-decisions", "evt-participant-terminated", "agg-participant"]
		preconditions: ["Participante em estado pending, qualified ou suspended", "Justificativa documentada para terminação"]
		postconditions: ["Participante transicionado para terminated após aprovação humana", "evt-participant-terminated publicado", "Estado terminal irreversível"]
	}, {
		code:            "act-query-participant-status"
		name:            "Consultar Status de Participante"
		description:     "Consulta projeção de status para atender queries de CTR (gate binário) e SSC (decisão de sourcing). Sem efeito colateral."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["prj-participant-status-view"]
		preconditions: ["ParticipantId válido"]
		postconditions: ["Status canônico retornado (4 estados internos + data de última transição)"]
	}, {
		code:            "act-query-participant-profile"
		name:            "Consultar Perfil de Participante"
		description:     "Consulta projeção de perfil completo para SSC (decisão de sourcing). Inclui dados cadastrais e histórico de qualificação. Sem efeito colateral."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["prj-participant-profile-view"]
		preconditions: ["ParticipantId válido"]
		postconditions: ["Perfil completo retornado sem efeito colateral"]
	}]

	// =============================================
	// CONSTRAINTS
	// =============================================

	constraints: [{
		code:         "cst-qualification-gate"
		name:         "Gate de Qualificação Enforçado"
		description:  "Agente nunca referencia participante como qualified sem confirmar status via projeção canônica."
		verification: "Runner verifica que act-propose-qualification referencia inv-qualification-gate. Audit trail de cada qualificação contém status anterior e posterior com timestamp."
		onViolation:  "block-and-escalate"
		rationale:    "inv-qualification-gate é invariante central do NPM. Qualificação sem enforcement expõe toda a rede a participante não verificado."
	}, {
		code:         "cst-identity-verification-required"
		name:         "Verificação de Identidade Obrigatória"
		description:  "Agente nunca propõe aprovação de qualificação sem confirmação de identidade em IDC via query pull. Evento previamente recebido não basta — query prevalece."
		verification: "Runner verifica que act-propose-qualification referencia inv-approval-requires-identity-verification. Audit trail contém resultado de QueryIdentityVerificationStatus no momento da decisão."
		onViolation:  "block-and-escalate"
		rationale:    "inv-approval-requires-identity-verification: integração dual com IDC — evento push como trigger, query pull como SoT. Query é autoridade."
	}, {
		code:         "cst-termination-irreversible"
		name:         "Terminação Irreversível Enforçada"
		description:  "Agente rejeita qualquer command de mutação sobre participante em estado terminated."
		verification: "Runner verifica que nenhuma ação de categoria mutation é executada sobre participante cujo currentStatus.state é terminated. Audit trail registra rejeição com motivo."
		onViolation:  "block-and-escalate"
		rationale:    "inv-termination-irreversible: estado terminal por definição — nenhuma transição de saída. Violação equivale a reverter sanção máxima."
	}, {
		code:         "cst-supervision-material-decisions"
		name:         "Supervisão para Decisões Materiais"
		description:  "Agente nunca executa qualificação, suspensão, reativação ou terminação sem aprovação humana registrada."
		verification: "Runner verifica que act-propose-qualification, act-propose-suspension, act-propose-reactivation e act-propose-termination têm autonomyLevel propose-and-wait. Audit trail contém approval-id de humano antes da mutação."
		onViolation:  "block-and-escalate"
		rationale:    "inv-supervision-required-for-material-decisions: P10, agentes recomendam, gates validam. Cada decisão habilita, bloqueia ou exclui participante — blast radius cross-context."
	}, {
		code:         "cst-registration-completeness"
		name:         "Completude Cadastral Obrigatória"
		description:  "Agente rejeita registro com dados cadastrais incompletos antes de criar entidade."
		verification: "Runner verifica que act-register-participant referencia inv-registration-completeness. Audit trail contém checklist de campos validados e resultado."
		onViolation:  "block-and-escalate"
		rationale:    "inv-registration-completeness: participante sem dados mínimos não pode seguir para qualificação — previne entidades órfãs."
	}, {
		code:         "cst-single-active-identity"
		name:         "Unicidade de Identidade Ativa"
		description:  "Agente verifica que não existe participante ativo (pending, qualified, suspended) com mesmo CNPJ antes de registrar novo participante."
		verification: "Runner verifica que act-register-participant referencia inv-single-active-identity. Audit trail contém resultado de verificação de unicidade por CNPJ."
		onViolation:  "block-and-escalate"
		rationale:    "inv-single-active-identity: duplicidade contornaria terminação — participante terminado que se re-registra passa por qualificação completa."
	}]

	// =============================================
	// ESCALATION CONDITIONS
	// =============================================

	escalationConditions: [{
		category:    "out-of-scope"
		description: "Tipo de organização não previsto nos templates de qualificação existentes — novo segmento de mercado, estrutura jurídica atípica. Agente não tem referência para validar requisitos KYC/AML aplicáveis."
		rationale:   "Canvas escalationCriteria novel-participant-type. Tipos novos podem ter requisitos regulatórios não previstos — qualificação sob premissas incorretas é risco de compliance."
	}, {
		category:    "out-of-scope"
		description: "Mudança regulatória que afeta requisitos de KYC/AML ou qualificação de participantes. Agente não pode avaliar impacto em qualificações existentes."
		rationale:   "Canvas escalationCriteria regulatory-change. Compliance regulatório é constraint inviolável (nível 1). Mudança pode invalidar qualificações vigentes."
	}, {
		category:    "ambiguous-case"
		description: "Condição que dispararia suspensão de múltiplos participantes simultaneamente — expiração em massa de documento obrigatório. Agente não decide estratégia de rollout."
		rationale:   "Canvas escalationCriteria mass-suspension-trigger. Blast radius proporcional ao número de participantes — pode paralisar segmento inteiro da rede."
	}, {
		category:    "ambiguous-case"
		description: "Participante contesta terminação ou suspensão — alega erro ou desproporcionalidade. Agente não resolve disputa com implicação jurídica."
		rationale:   "Canvas escalationCriteria contested-termination. Decisão incorreta expõe Mesh a responsabilidade (dp-10). DRC é o BC de disputas."
	}, {
		category:    "conflicting-signals"
		description: "Sinais contraditórios sobre participante — e.g., IDC reporta identidade verificada via evento mas query retorna pendente, ou monitoramento contínuo detecta irregularidade enquanto reativação está em curso."
		rationale:   "Agente com mutations deve cobrir conflicting-signals (tq-ag-10). Conflito entre sinais exige julgamento humano sobre precedência."
	}, {
		category:    "insufficient-context"
		description: "Contexto insuficiente para processar qualificação ou transição — e.g., QueryIdentityVerificationStatus indisponível, documentação incompleta com campos ambíguos, dados cadastrais com inconsistências não resolvíveis autonomamente."
		rationale:   "Agente com mutations deve cobrir insufficient-context (tq-ag-10). Decisão de qualificação com dados incompletos gera risco de habilitar participante não verificado."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Canvas define governanceScope (autonomousDecisions, supervisedDecisions, escalationCriteria) e incentiveAnalysis — necessário para calibrar autonomia e detectar padrões adversariais."
			requiredSlices: ["ownership", "governanceScope", "incentiveAnalysis", "communication"]
		}, {
			artifactType: "domain-model"
			rationale:    "Domain model define aggregate, commands, events, invariants, policies, lifecycle e projections — mapa operacional completo do agente."
		}, {
			artifactType: "glossary"
			rationale:    "Glossário NPM define termos canônicos — agente precisa interpretar inputs usando linguagem ubíqua do BC."
			requiredSlices: ["terms"]
		}, {
			artifactType: "agent-governance"
			rationale:    "Governance envelope define calibração dinâmica, blast radius limits, thresholds e canais de escalation. Agente consulta envelope para decisões calibráveis."
		}, {
			artifactType: "context-map"
			rationale:    "Context map define relações upstream/downstream (IDC, NGR) e integration patterns — necessário para processar evento ACL de IDC e sinal de NGR corretamente."
			requiredSlices: ["relationships where upstream or downstream is npm"]
		}]

		estimatedBudget: "moderate"
	}

	// =============================================
	// OBSERVABILITY
	// =============================================

	observability: {
		signals: [{
			code:           "sig-mutation-executed"
			name:           "Mutação Executada"
			description:    "Emitido após cada command processado pelo aggregate — transição de lifecycle registrada."
			coversCategory: "mutation"
			trigger:        "Command processado com sucesso e evento emitido."
			level:          "info"
		}, {
			code:           "sig-validation-result"
			name:           "Resultado de Validação"
			description:    "Emitido após validação de completude cadastral ou monitoramento de expiração — resultado (pass/fail) com detalhes."
			coversCategory: "validation"
			trigger:        "act-validate-registration ou act-monitor-qualification-expiry executado."
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
			description:    "Emitido após cada consulta a projeções de status ou perfil — ParticipantId e tipo de query."
			coversCategory: "query"
			trigger:        "act-query-participant-status ou act-query-participant-profile executado."
			level:          "info"
		}, {
			code:           "sig-supervision-requested"
			name:           "Supervisão Humana Solicitada"
			description:    "Emitido quando agente propõe decisão supervisionada (qualificação, suspensão, reativação, terminação) e aguarda aprovação."
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
				"participant-id",
				"autonomy-level-applied",
				"constraints-evaluated",
				"supervisor-id",
			]

			storageHint: "Event Log imutável do NPM — mesmo store dos domain events, partição separada para audit trail do agente."

			rationale: "Intermediário financeiro regulado (SCD/Bacen) requer reconstituição completa de decisões. Os 7 campos mínimos (_minimumAuditFields) são regulatory-grade. 4 campos adicionais (participant-id, autonomy-level-applied, constraints-evaluated, supervisor-id) permitem correlação com domain events, verificação de compliance do governance envelope e rastreabilidade de aprovações humanas."
		}
	}

	rationale: "Agente primário e único do NPM. Domain-agent que opera sobre todo o participant lifecycle — single aggregate, 7 commands, 7 events, 6 invariants, 1 policy, 2 projections. 12 ações: 6 execute-and-log (validação cadastral, registro, solicitação de verificação a IDC, recepção de documentos, registro de verificação ACL, monitoramento de expiração) + 2 execute-and-log queries (status, perfil) + 4 propose-and-wait (qualificação, suspensão, reativação, terminação). 6 constraints verificáveis com block-and-escalate — cobertura 1:1 com os 6 invariants do domain model. 6 escalation conditions cobrindo canvas criteria (novel-participant-type, regulatory-change, mass-suspension-trigger, contested-termination) + coerência com tq-ag-10 (conflicting-signals, insufficient-context). 6 signals de observabilidade cobrindo todas as categorias de ação. Audit trail regulatory-grade com 11 campos (7 mínimos + 4 operacionais). Forward reference: governanceRef aponta para npm-primary-agent.governance.cue. Alinhado com canvas, domain-model, glossary, context-map v2, lente lens-ai-agent-governance e design principles."
}
