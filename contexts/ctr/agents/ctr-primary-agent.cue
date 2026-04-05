package ctr

// ctr-primary-agent.cue — Agent Spec: CTR Primary Agent.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Agente primário do CTR. Opera sobre o aggregate Contract Terms,
// registrando versões de termos, validando participantes em NPM,
// gerenciando lifecycle (draft→active→superseded→expired→cancelled)
// e expondo Published Language para CMT, SCF e DRC.
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária):
//   autonomyLevel por ação, escalation conditions, observability
// - lens-contractual-and-legal-architecture (secundária):
//   imutabilidade pós-ativação, supervisão de decisões que criam base jurídica
// - lens-regulatory-compliance-as-architecture (terciária):
//   auditTrail regulatory-grade para intermediário financeiro

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ctrPrimaryAgent: artifact_schemas.#AgentSpec & {
	code:        "agt-ctr-primary"
	name:        "CTR Primary Agent"
	description: "Agente primário do Contract & Terms Registry. Opera o lifecycle de termos contratuais: registra versões em draft, valida qualificação de participantes em NPM, recomenda ativação e cancelamento sob supervisão, detecta expiração temporal e publica eventos de lifecycle para CMT, SCF e DRC. Operador principal referenciado pelo canvas."

	boundedContextRef: "ctr"
	role:              "domain-agent"
	governanceRef:     "ctr-primary-agent"

	// =============================================
	// ESCOPO OPERACIONAL
	// =============================================

	operationalScope: {
		aggregates: ["agg-contract-terms"]

		commands: [
			"cmd-register-contract-terms",
			"cmd-activate-contract-terms",
			"cmd-register-terms-revision",
			"cmd-cancel-contract-terms",
			"cmd-expire-contract-terms",
		]

		events: [
			"evt-contract-terms-drafted",
			"evt-contract-terms-activated",
			"evt-contract-terms-superseded",
			"evt-contract-terms-cancelled",
			"evt-contract-terms-expired",
		]

		invariants: [
			"inv-single-active-version",
			"inv-post-activation-immutability",
			"inv-activation-requires-supervision",
			"inv-cancellation-requires-supervision",
			"inv-valid-participant-qualification",
			"inv-lineage-integrity",
			"inv-draft-only-mutable",
		]

		projections: [
			"prj-contract-terms-view",
			"prj-contract-clauses-view",
		]
	}

	// =============================================
	// AÇÕES
	// =============================================

	actions: [{
		code:            "act-register-contract-terms"
		name:            "Registrar Termos Contratuais"
		description:     "Recebe RegisterContractTerms, valida completude estrutural e qualificação de partes em NPM (sync), gera ContractTermsId e registra versão v1 em estado draft."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: ["cmd-register-contract-terms", "agg-contract-terms", "evt-contract-terms-drafted", "inv-valid-participant-qualification"]
		preconditions: [
			"Partes referenciadas existem e estão qualificadas em NPM",
			"Escopo contratual (contrato+escopo) informado",
		]
		postconditions: [
			"Aggregate criado com versão v1 em estado draft",
			"evt-contract-terms-drafted emitido (interno)",
		]
	}, {
		code:           "act-recommend-activation"
		name:           "Recomendar Ativação de Termos"
		description:    "Prepara e propõe ActivateContractTerms ao supervisor humano. Apresenta versão draft com cláusulas, partes e vigência para revisão. Se existir versão active anterior, informa que será supersedida atomicamente."
		category:       "mutation"
		autonomyLevel:  "propose-and-wait"
		domainModelRefs: ["cmd-activate-contract-terms", "agg-contract-terms", "evt-contract-terms-activated", "evt-contract-terms-superseded", "inv-single-active-version", "inv-activation-requires-supervision"]
		preconditions: [
			"Versão alvo em estado draft",
			"Gate de supervisão humana pendente",
		]
		postconditions: [
			"Após aprovação: versão transiciona para active",
			"evt-contract-terms-activated publicado para CMT e SCF",
			"Se versão anterior active: evt-contract-terms-superseded publicado",
		]
	}, {
		code:            "act-register-terms-revision"
		name:            "Registrar Revisão de Termos"
		description:     "Recebe RegisterTermsRevision, valida qualificação de partes em NPM (sync) e cria nova versão em draft com lineage para versão anterior. Revalidação de partes é obrigatória porque revisão cria nova base jurídica potencial — partes podem ter perdido qualificação desde o registro original."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: ["cmd-register-terms-revision", "agg-contract-terms", "evt-contract-terms-drafted", "inv-lineage-integrity", "inv-valid-participant-qualification"]
		preconditions: [
			"Aggregate existente com ao menos uma versão",
			"Partes referenciadas existem e estão qualificadas em NPM",
		]
		postconditions: [
			"Nova versão criada em draft com lineage para versão anterior",
			"evt-contract-terms-drafted emitido (interno)",
		]
	}, {
		code:           "act-recommend-cancellation"
		name:           "Recomendar Cancelamento de Termos"
		description:    "Propõe CancelContractTerms ao supervisor humano com contexto de impacto: compromissos em CMT que referenciam a versão, disputas em DRC. Decisão terminal irreversível."
		category:       "mutation"
		autonomyLevel:  "propose-and-wait"
		domainModelRefs: ["cmd-cancel-contract-terms", "agg-contract-terms", "evt-contract-terms-cancelled", "inv-cancellation-requires-supervision"]
		preconditions: [
			"Versão em estado draft ou active",
			"Gate de supervisão humana pendente",
		]
		postconditions: [
			"Após aprovação: versão transiciona para cancelled (terminal)",
			"evt-contract-terms-cancelled publicado para CMT e DRC",
		]
	}, {
		code:           "act-expire-contract-terms"
		name:           "Expirar Termos por Vigência"
		description:    "Executado por pol-detect-expired-terms quando data de expiração é atingida. Verifica estado corrente da versão antes de transicionar — se já supersedida ou cancelada, descarta como no-op idempotente."
		category:       "mutation"
		autonomyLevel:  "execute-and-log"
		domainModelRefs: ["cmd-expire-contract-terms", "agg-contract-terms", "evt-contract-terms-expired"]
		preconditions: [
			"Data de expiração da vigência atingida",
		]
		postconditions: [
			"Se versão ainda estiver active: transiciona para expired e emite evt-contract-terms-expired",
			"Se versão já estiver superseded ou cancelled: command é descartado como no-op idempotente",
		]
	}, {
		code:            "act-validate-participant-qualification"
		name:            "Validar Qualificação de Participantes"
		description:     "Consulta NPM via QueryParticipantStatus para validar existência e qualificação de partes. Decisão autônoma e determinística — resposta binária."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: ["inv-valid-participant-qualification", "agg-contract-terms"]
		preconditions: [
			"NPM acessível via QueryParticipantStatus",
		]
		postconditions: [
			"Partes validadas como existentes e qualificadas, ou rejeição do registro",
		]
	}, {
		code:           "act-query-contract-terms"
		name:           "Consultar Termos e Cláusulas Contratuais"
		description:    "Atende QueryContractTerms e QueryContractClauses via projeções. Retorna termos por ID+versão ou versão active por contrato+escopo, e cláusulas por tipo."
		category:       "query"
		autonomyLevel:  "execute-and-log"
		domainModelRefs: ["prj-contract-terms-view", "prj-contract-clauses-view", "qry-contract-terms", "qry-contract-clauses"]
	}, {
		code:           "act-publish-lifecycle-events"
		name:           "Propagar Eventos de Lifecycle"
		description:    "Materializa a entrega operacional de eventos de lifecycle já produzidos pelo aggregate para consumers downstream (CMT, SCF, DRC). Não decide o fato — apenas assegura propagação confiável via outbox ou mecanismo equivalente. Side effect operacional das transições de estado, não decisão de negócio."
		category:       "mutation"
		autonomyLevel:  "execute-and-log"
		domainModelRefs: ["evt-contract-terms-activated", "evt-contract-terms-superseded", "evt-contract-terms-cancelled"]
	}]

	// =============================================
	// CONSTRAINTS
	// =============================================

	constraints: [{
		code:         "cst-no-direct-activation"
		name:         "Ativação Nunca Sem Supervisão"
		description:  "Agente nunca executa ActivateContractTerms sem aprovação humana explícita. Sempre propõe e aguarda."
		verification: "Runner verifica que toda invocação de act-recommend-activation tem autonomyLevel propose-and-wait e que audit trail contém registro de aprovação humana antes de emissão de evt-contract-terms-activated."
		onViolation:  "block-and-escalate"
		rationale:    "Ativação cria base jurídica para CMT e SCF. inv-activation-requires-supervision é invariante central — violação expõe sistema a compromissos sob termos não revisados."
	}, {
		code:         "cst-no-direct-cancellation"
		name:         "Cancelamento Nunca Sem Supervisão"
		description:  "Agente nunca executa CancelContractTerms sem aprovação humana explícita. Decisão terminal irreversível."
		verification: "Runner verifica que toda invocação de act-recommend-cancellation tem autonomyLevel propose-and-wait e audit trail contém aprovação humana antes de emissão de evt-contract-terms-cancelled."
		onViolation:  "block-and-escalate"
		rationale:    "Cancelamento invalida base jurídica referenciada por compromissos downstream. inv-cancellation-requires-supervision é constraint inviolável."
	}, {
		code:         "cst-immutability-post-activation"
		name:         "Nenhuma Mutação Pós-Ativação"
		description:  "Agente nunca altera campos de versão em estado active, superseded, expired ou cancelled. Alterações requerem nova versão via RegisterTermsRevision."
		verification: "Runner verifica que nenhuma ação muta campos de ent-terms-version com state != draft. inv-post-activation-immutability e inv-draft-only-mutable são guards em todas as mutações."
		onViolation:  "block-and-escalate"
		rationale:    "Imutabilidade é pré-requisito de reconstrução temporal e auditoria regulatória. Mutação pós-ativação quebraria rastreabilidade de termos referenciados por compromissos."
	}, {
		code:         "cst-participants-validated-before-registration"
		name:         "Partes Validadas Antes de Registro"
		description:  "Agente nunca registra termos (registro inicial ou revisão) sem validação sync de qualificação de partes em NPM."
		verification: "Runner verifica que act-register-contract-terms e act-register-terms-revision sempre invocam act-validate-participant-qualification como precondition. Falha de validação bloqueia registro."
		onViolation:  "block-and-escalate"
		rationale:    "Termos com partes não qualificadas são risco jurídico. Revisão revalida porque partes podem ter perdido qualificação desde o registro original. inv-valid-participant-qualification é invariante do domínio."
	}, {
		code:         "cst-lineage-integrity"
		name:         "Integridade de Lineage Preservada"
		description:  "Agente garante que cada versão criada por revisão referencia exatamente a versão anterior. Cadeia linear, sem gaps nem branching."
		verification: "Runner verifica que act-register-terms-revision atribui lineage com chainOrigin=false e previousVersion apontando para a versão anterior existente. inv-lineage-integrity é guard."
		onViolation:  "block-and-escalate"
		rationale:    "Cadeia de lineage quebrada impede reconstrução temporal de evolução contratual pelo regulador."
	}]

	// =============================================
	// ESCALATION CONDITIONS
	// =============================================

	escalationConditions: [{
		category:    "out-of-scope"
		description: "Tipo de contrato não previsto nos templates existentes — novo vertical, novo instrumento jurídico."
		rationale:   "Canvas escalation novel-contract-type. Tipos novos podem ter cláusulas e requisitos regulatórios não previstos. Decisão irreversível se termos ativados sob premissas incorretas."
	}, {
		category:    "ambiguous-case"
		description: "Valor do contrato excede threshold definido no autonomy envelope."
		rationale:   "Canvas escalation high-value-contract. Contratos de alto valor têm blast radius jurídico e financeiro proporcional."
	}, {
		category:    "ambiguous-case"
		description: "Cláusulas ou estrutura do contrato caem em zona cinza regulatória não coberta por regras existentes."
		rationale:   "Canvas escalation regulatory-ambiguity. Integridade legal é constraint inviolável (nível 1). Zona cinza exige julgamento humano especializado."
	}, {
		category:    "suspicious-input"
		description: "Termos submetidos com padrão anômalo — cláusulas incomuns, vigência atípica, partes sem histórico, valor fora de faixa do vertical."
		rationale:   "dp-08: custos de manipulação devem exceder benefícios. Padrões anômalos podem indicar termos enviesados (canvas incentive analysis sh-01). Agente sinaliza antes de registrar."
	}, {
		category:    "insufficient-context"
		description: "NPM retorna status ambíguo ou indisponível para qualificação de partes. Agente não consegue decidir com confiança."
		rationale:   "Canvas assumption as-ctr-2: NPM disponível com latência aceitável. Se assumption falha, agente não deve prosseguir com validação parcial."
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
			rationale:    "Linguagem ubíqua para interpretar input contratual e gerar output na linguagem do BC."
			requiredSlices: ["terms"]
		}, {
			artifactType: "agent-governance"
			rationale:    "Envelope de governança com thresholds de valor, calibração de supervisão, blast radius caps. Agente consulta limites antes de cada ação."
		}]

		estimatedBudget: "moderate"
	}

	// =============================================
	// OBSERVABILITY
	// =============================================

	observability: {
		signals: [{
			code:           "sig-terms-registered"
			name:           "Termos Registrados"
			description:    "Emitido após act-register-contract-terms ou act-register-terms-revision completar. Inclui ContractTermsId, versionNumber, resultado de validação de partes."
			coversCategory: "mutation"
			trigger:        "Conclusão de processamento de RegisterContractTerms ou RegisterTermsRevision."
			level:          "info"
		}, {
			code:           "sig-activation-recommended"
			name:           "Ativação Recomendada"
			description:    "Emitido quando act-recommend-activation propõe ativação ao supervisor. Inclui ContractTermsId, versionNumber, impacto de supersessão."
			coversCategory: "mutation"
			trigger:        "Proposta de ativação submetida ao gate de supervisão."
			level:          "info"
		}, {
			code:           "sig-lifecycle-transition"
			name:           "Transição de Lifecycle Executada"
			description:    "Emitido em qualquer transição de estado do lifecycle. Inclui previousState, newState, triggerCommand."
			coversCategory: "mutation"
			trigger:        "Emissão de qualquer evento de lifecycle."
			level:          "info"
		}, {
			code:           "sig-participant-validation-failed"
			name:           "Validação de Participante Falhou"
			description:    "Emitido quando act-validate-participant-qualification rejeita — parte inexistente ou não qualificada em NPM."
			coversCategory: "validation"
			trigger:        "QueryParticipantStatus retorna qualificação inválida ou NPM indisponível."
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
			description:    "Emitido após atender QueryContractTerms ou QueryContractClauses. Inclui ContractTermsId, tipo de query, consumer."
			coversCategory: "query"
			trigger:        "Atendimento de query via projeção."
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
				"contract-terms-id",
				"version-number",
				"terms-state",
				"supervision-approval-ref",
			]
			storageHint: "Event Log do CTR — append-only, criptograficamente verificável via DGV."
			rationale:    "Campos mínimos regulatory-grade (tq-ag-13) mais campos domain-specific (contract-terms-id, version-number, terms-state, supervision ref) para reconstituição completa de decisões sobre termos contratuais em intermediário financeiro regulado."
		}
	}

	rationale: "Agente primário e único do CTR. Opera como domain-agent sobre o aggregate Contract Terms com 8 ações: 4 autônomas determinísticas (registrar termos, registrar revisão com revalidação de partes, expirar por vigência com no-op idempotente, propagar eventos de lifecycle), 1 autônoma de leitura (query termos e cláusulas), 1 autônoma de validação (qualificação de partes em NPM), 2 supervisionadas (ativação e cancelamento). Autonomia segue canvas governance scope: ações determinísticas sem impacto jurídico irreversível são execute-and-log; ações que criam ou invalidam base jurídica são propose-and-wait. 5 constraints verificáveis cobrem supervisão de ativação e cancelamento, imutabilidade pós-ativação, validação de participantes em registro e revisão, e integridade de lineage. 5 escalation conditions cobrem canvas criteria (tipo novo, alto valor, regulatória) mais input suspeito e contexto insuficiente (NPM indisponível). Observabilidade: 1 signal por categoria de ação + audit trail regulatory-grade com campos domain-specific."
}
