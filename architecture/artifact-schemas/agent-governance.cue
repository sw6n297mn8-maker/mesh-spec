package artifact_schemas

// agent-governance.cue — Schemas para governança operacional de agentes AI.
//
// ADR-037 estabelece dois níveis de governança:
// 1. #AgentGovernanceGlobal (singleton, architecture/agent-governance.cue):
//    Defaults transversais, taxonomia de lifecycle, políticas de blast radius,
//    drift detection e auditoria que se aplicam a todos os agentes.
// 2. #AgentGovernanceEnvelope (per-agent, contexts/{bc}/agents/{name}.governance.cue):
//    Limites específicos, escalation routing, autonomy overrides, lifecycle stage
//    atual, calibração dinâmica (promoção/regressão).
//
// Fronteira com #AgentSpec (agent-spec.cue):
// - agent-spec declara QUANDO escalar → envelope declara COMO
// - agent-spec declara autonomyLevel por ação → envelope declara calibração
// - agent-spec é operacional → governance é supervisória
// - agent-spec declara observability signals → governance declara drift thresholds
//
// Convenção de naming entre agent-spec e envelope:
// - agent-spec.governanceRef = base name do arquivo envelope (sem .governance.cue)
// - envelope.agentRef = agent-spec.code
// Runner valida bidirecionalidade: dado agent-spec com code "agt-foo" e
// governanceRef "foo", deve existir foo.governance.cue com agentRef "agt-foo".
// tq-gv-06 valida este contrato.
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária): autonomia, escalation, lifecycle, drift, HITL
// - lens-security-trust-infrastructure (primária): blast radius, defense layers
// - lens-regulatory-compliance-as-architecture (secundária): audit trail, versioning
// - lens-observability-operational-intelligence (terciária): drift metrics, anomaly detection
//
// O que NÃO vive aqui:
// - ações e constraints do agente → agent-spec
// - escalation conditions (QUANDO) → agent-spec
// - observability signals e audit trail fields → agent-spec
// - deployment configuration → infrastructure
//
// Convenção de campos temporais:
// Campos que descrevem duração (evaluationCadence, minimumObservationPeriod,
// retentionPeriod) usam formato descritivo legível (e.g., "30 days", "weekly").
// Runner parseia conforme necessidade. ISO 8601 duration (P30D) é aceito
// mas não exigido — legibilidade priorizada sobre parseabilidade nesta fase.

// ========================================
// GLOBAL GOVERNANCE
// ========================================

#AgentGovernanceGlobal: {
	// Versão semântica da governança global.
	// Rastreada no audit trail de toda decisão de agente (governance-version).
	// Bump exige reavaliação de envelopes: runner valida que todo envelope
	// referencia a versão corrente (tq-gv-12).
	version: string & =~"^[0-9]+\\.[0-9]+$"

	// Default de autonomia para novos agentes/ações sem override no envelope.
	// P10: agentes recomendam, gates validam — default conservador.
	defaultAutonomyLevel: #AutonomyLevel

	// Taxonomia de lifecycle stages.
	// Vocabulário compartilhado entre todos os envelopes.
	// Cada stage define quais níveis de autonomia são permitidos.
	// Unicidade de stages na lista: enforcement por runner (tq-gv-01).
	lifecycleStages: [#LifecycleStageDefinition, ...#LifecycleStageDefinition]

	// Defaults de escalation aplicados quando envelope não especifica routing
	// para uma categoria. Garante que nenhuma escalation fica sem destino.
	escalationDefaults: #EscalationDefaults

	// Política global de drift detection — cadência e métricas padrão.
	driftDetectionPolicy: #DriftDetectionPolicy

	// Política global de blast radius — limites máximos que nenhum envelope
	// pode exceder (tq-gv-09). Define o teto do sistema.
	blastRadiusPolicy: #BlastRadiusPolicy

	// Política global de auditoria — complementa auditTrail do agent-spec.
	auditPolicy: #AuditPolicy

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/agent-governance\\.cue$"
			fileNameRegex:      "^agent-governance\\.cue$"
			description:        "Governança global de agentes: defaults, taxonomias, políticas transversais."
			rationale:          "Singleton em architecture/ porque governa todos os agentes cross-BC. Referenciado por envelopes via governanceGlobalVersion."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-gv-01"
			description: "Lifecycle stages são únicos e cobrem progressão de autonomia"
			test:        "lifecycleStages[] contém ao menos 3 stages distintos — nenhum stage duplicado. Runner usa a ordem fixa da enum #LifecycleStage (onboarding < validation < operational < mature) e a ordem ordinal de #AutonomyLevel (no-autonomous-action < collect-and-report < propose-and-wait < execute-and-log) para validar que allowedAutonomyLevels é não-decrescente: o max ordinal de cada stage é >= o max ordinal do stage anterior. Validação por runner."
			severity:    "fail"
			rationale:   "Lifecycle sem progressão de autonomia não modela maturidade — agentes não têm caminho para ganhar confiança. Duplicata quebra unicidade da taxonomia."
		}, {
			id:          "tq-gv-02"
			description: "Escalation defaults cobrem fallback para todas as categorias"
			test:        "escalationDefaults.fallbackChannel e fallbackRecipient estão definidos como último recurso. Se categoryDefaults estiver presente, categories nele são cobertas diretamente; demais categories usam fallback. Nenhuma escalation category fica sem destino. Validação por runner."
			severity:    "fail"
			rationale:   "Escalation sem destino é escalation perdida — agente para e ninguém sabe."
		}, {
			id:          "tq-gv-03"
			description: "Drift detection tem ao menos uma métrica mensurável"
			test:        "driftDetectionPolicy.defaultMetrics[] contém ao menos uma métrica com baseline e threshold numéricos ou comparáveis. Métricas puramente qualitativas falham. Validação por runner."
			severity:    "fail"
			rationale:   "Drift detection sem métrica mensurável é aspiração, não política."
		}, {
			id:          "tq-gv-04"
			description: "Blast radius policy tem limites proporcionais ao risco da fase"
			test:        "blastRadiusPolicy.rationale justifica os limites escolhidos em relação à fase atual (pré-PMF, pós-PMF) e ao contexto regulatório. maxConcurrentMutations e maxDailyActions são coerentes entre si: daily >= concurrent. Validação por runner."
			severity:    "warn"
			rationale:   "Campos numéricos já são garantidos pelo type system. O critério valida proporcionalidade: limites arbitrários sem justificativa de risco são governança nominal."
		}, {
			id:          "tq-gv-05"
			description: "Version segue formato e é não-vazia"
			test:        "version match ^[0-9]+\\.[0-9]+$. Runner valida que envelopes referenciam esta versão."
			severity:    "fail"
			rationale:   "governance-version no audit trail deve ser rastreável. Versão ausente ou mal-formada quebra reconstituição de auditoria."
		}]
		rationale: "Critérios cobrem progressão e unicidade de lifecycle (tq-gv-01), completude de escalation (tq-gv-02), mensurabilidade de drift (tq-gv-03), enforceability de blast radius (tq-gv-04) e rastreabilidade de versão (tq-gv-05)."
	}
}

// ========================================
// PER-AGENT ENVELOPE
// ========================================

#AgentGovernanceEnvelope: {
	// Referência ao agent-spec que este envelope governa.
	// Runner valida bidirecionalidade: agent-spec.code == agentRef e
	// agent-spec.governanceRef == base name deste arquivo (tq-gv-06).
	agentRef: string & =~"^agt-[a-z][a-z0-9-]*$"

	// Versão da governança global contra a qual este envelope foi calibrado.
	// Runner valida match com version em architecture/agent-governance.cue (tq-gv-12).
	governanceGlobalVersion: string & =~"^[0-9]+\\.[0-9]+$"

	// Lifecycle stage atual do agente.
	// Deve ser um stage definido na taxonomia global (tq-gv-08).
	lifecycleStage: #LifecycleStage

	// Routing de escalation — COMO escalar, por categoria.
	// Cobre categories declaradas em agent-spec.escalationConditions.
	// Categories sem routing aqui usam escalationDefaults da governança global.
	escalationRouting: [#EscalationRoute, ...#EscalationRoute]

	// Overrides de autonomia por ação.
	// Substitui o autonomyLevel no agent-spec quando presente.
	// Usado para calibração temporária sem alterar o spec.
	// tq-gv-13 alerta overrides expirados. tq-gv-14 valida P10.
	autonomyOverrides?: [#AutonomyOverride, ...#AutonomyOverride]

	// Caps de blast radius per-agent.
	// Devem ser <= limites da blastRadiusPolicy global (tq-gv-09).
	blastRadiusCaps: #BlastRadiusCaps

	// Drift detection config per-agent.
	driftDetection: #DriftDetectionConfig

	// Regras de calibração — promoção e regressão de autonomia.
	calibration: #CalibrationRules

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/agents/[a-z][a-z0-9-]*\\.governance\\.cue$"
			fileNameRegex:      "^[a-z][a-z0-9-]*\\.governance\\.cue$"
			description:        "Governance envelope per-agent: limites, calibração, lifecycle."
			rationale:          "Sibling do agent-spec no mesmo diretório. Linked via agent-spec.governanceRef."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-gv-06"
			description: "agentRef aponta para agent-spec existente com governanceRef recíproco"
			test:        "No diretório do envelope, existe agent-spec com code == agentRef e governanceRef == base name do arquivo envelope (sem .governance.cue). Runner valida bidirecionalidade."
			severity:    "fail"
			rationale:   "Link bidirecional garante que spec e envelope se referenciam mutuamente — sem isso, envelope pode ficar órfão ou spec apontar para envelope errado."
		}, {
			id:          "tq-gv-07"
			description: "Escalation routing cobre categorias do agent-spec"
			test:        "Para cada category em agent-spec.escalationConditions[], existe escalationRouting[] com mesma category ou categoryDefaults/fallback global cobrem. Runner valida cobertura."
			severity:    "warn"
			rationale:   "Routing incompleto não é bloqueante se global defaults cobrem — mas indica calibração incompleta."
		}, {
			id:          "tq-gv-08"
			description: "lifecycleStage pertence à taxonomia global"
			test:        "lifecycleStage é um dos stages definidos em architecture/agent-governance.cue lifecycleStages[].stage. Runner valida."
			severity:    "fail"
			rationale:   "Stage fora da taxonomia é vocabulário desalinhado."
		}, {
			id:          "tq-gv-09"
			description: "blastRadiusCaps não excedem política global"
			test:        "blastRadiusCaps.maxConcurrentMutations <= blastRadiusPolicy.maxConcurrentMutations e blastRadiusCaps.maxDailyActions <= blastRadiusPolicy.maxDailyActions. Runner valida."
			severity:    "fail"
			rationale:   "Envelope que excede limites globais derrota a hierarquia de governança."
		}, {
			id:          "tq-gv-10"
			description: "Calibration criteria são mensuráveis e time-bounded"
			test:        "Cada promotionCriteria[] e regressionTriggers[] em calibration tem métrica mensurável e período. Critérios como 'quando o agente estiver pronto' falham. Validação por runner."
			severity:    "warn"
			rationale:   "Calibração sem métrica é promoção por feeling — inconsistente com P12."
		}, {
			id:          "tq-gv-11"
			description: "autonomyOverrides referenciam actions válidas do agent-spec"
			test:        "Cada autonomyOverrides[].actionRef corresponde a actions[].code no agent-spec. Runner valida."
			severity:    "fail"
			rationale:   "Override de ação inexistente é configuração fantasma."
		}, {
			id:          "tq-gv-12"
			description: "governanceGlobalVersion corresponde à versão corrente"
			test:        "governanceGlobalVersion == architecture/agent-governance.cue version. Mismatch indica envelope desatualizado. Runner valida."
			severity:    "warn"
			rationale:   "Escolha deliberada de rollout: warn permite bump gradual do global sem bloquear todos os envelopes simultaneamente. Estado final desejado é fail para agentes em operational/mature — requer severity condicional por stage, não suportada pelo sistema de critérios atual."
		}, {
			id:          "tq-gv-13"
			description: "Autonomy overrides não estão expirados"
			test:        "Cada autonomyOverrides[].validUntil, quando presente, é >= data atual. Override expirado indica calibração stale que deve ser removida ou renovada. Runner valida."
			severity:    "warn"
			rationale:   "Override expirado é configuração morta que polui o envelope e obscurece o estado real de autonomia."
		}, {
			id:          "tq-gv-14"
			description: "Autonomy overrides não concedem execute-and-log a mutations"
			test:        "Nenhum autonomyOverrides[] concede execute-and-log a uma ação cuja category é mutation no agent-spec. Runner cruza overrideLevel com agent-spec actions[].category."
			severity:    "fail"
			rationale:   "P10: agentes recomendam, gates validam. category mutation não distingue financeira de não-financeira — regra se aplica a toda mutation como default conservador para intermediário financeiro regulado."
		}, {
			id:          "tq-gv-15"
			description: "Unicidade de envelope por agentRef no diretório"
			test:        "No diretório agents/ do BC, existe no máximo um arquivo .governance.cue com agentRef == X para cada X. Runner valida por scan do diretório."
			severity:    "fail"
			rationale:   "Dois envelopes para o mesmo agente criam ambiguidade de governança — qual prevalece é indeterminado."
		}]
		rationale: "Critérios cobrem integridade referencial bidirecional (tq-gv-06, tq-gv-11), cobertura de escalation (tq-gv-07), alinhamento com governança global (tq-gv-08, tq-gv-09, tq-gv-12), qualidade de calibração (tq-gv-10), higiene de overrides (tq-gv-13), compliance com P10 (tq-gv-14) e unicidade de envelope (tq-gv-15)."
	}
}

// ========================================
// LIFECYCLE
// ========================================

// Stages do lifecycle de um agente.
// Progressão onboarding → validation → operational → mature.
// Cada stage habilita níveis de autonomia diferentes.
#LifecycleStage:
	"onboarding" |     // Agente novo, sob observação intensiva
	"validation" |     // Agente em validação com dados reais, autonomia limitada
	"operational" |    // Agente operando com autonomia calibrada
	"mature"           // Agente com track record comprovado, autonomia máxima permitida

#LifecycleStageDefinition: {
	stage:       #LifecycleStage
	description: #NonEmptyString

	// Condições que devem ser satisfeitas para entrar neste stage.
	entryConditions: #NonEmptyString

	// Quais níveis de autonomia são permitidos neste stage.
	// Progressão: stages avançados permitem ao menos os mesmos níveis.
	// Ordem ordinal de #AutonomyLevel (menor → maior autonomia):
	//   no-autonomous-action < collect-and-report < propose-and-wait < execute-and-log
	// Runner usa esta ordem para validar progressão não-decrescente (tq-gv-01).
	allowedAutonomyLevels: [#AutonomyLevel, ...#AutonomyLevel]

	rationale: #NonEmptyString
}

// ========================================
// ESCALATION
// ========================================

// Canal por onde a escalation é entregue.
#EscalationChannel:
	"sync-human-review" |      // Humano revisa em tempo real
	"async-queue" |            // Fila assíncrona para revisão posterior
	"alert-and-block" |        // Alerta + bloqueia operação até resolução
	"alert-and-continue"       // Alerta mas permite continuar

// Defaults de escalation na governança global.
#EscalationDefaults: {
	// Defaults por categoria — quando o envelope não especifica routing
	// para uma categoria, estes defaults se aplicam antes do fallback.
	categoryDefaults?: [#EscalationRoute, ...#EscalationRoute]

	// Canal fallback para categorias sem routing específico no envelope
	// NEM em categoryDefaults.
	fallbackChannel: #EscalationChannel

	// SLA padrão para resposta à escalation.
	fallbackSlaDescription: #NonEmptyString

	// Quem recebe escalations por default.
	fallbackRecipient: #NonEmptyString

	rationale: #NonEmptyString
}

// Routing de escalation no envelope — por categoria.
#EscalationRoute: {
	// Qual categoria de escalation esta rota cobre.
	category: #EscalationCategory

	// Canal de entrega.
	channel: #EscalationChannel

	// SLA de resposta.
	slaDescription: #NonEmptyString

	// Quem recebe a escalation.
	recipient: #NonEmptyString

	rationale: #NonEmptyString
}

// ========================================
// AUTONOMY OVERRIDES
// ========================================

// Override temporário de autonomia para uma ação específica.
// Permite calibração sem alterar o agent-spec.
#AutonomyOverride: {
	// Code da ação no agent-spec (act-*).
	actionRef: string & =~"^act-[a-z][a-z0-9-]*$"

	// Nível de autonomia override.
	// tq-gv-14 valida que execute-and-log não é concedido a mutations (P10).
	overrideLevel: #AutonomyLevel

	// Data até quando o override é válido (ISO 8601 date).
	// Omitir significa "até nova calibração".
	// Runner alerta overrides expirados (tq-gv-13).
	validUntil?: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"

	rationale: #NonEmptyString
}

// ========================================
// BLAST RADIUS
// ========================================

// Política global de blast radius — teto do sistema.
// Define os limites máximos que nenhum envelope pode exceder.
#BlastRadiusPolicy: {
	maxConcurrentMutations: int & >=1
	maxDailyActions:        int & >=1
	rationale:              #NonEmptyString
}

// Caps de blast radius per-agent — limites do envelope.
// Devem ser <= limites correspondentes em #BlastRadiusPolicy (tq-gv-09).
#BlastRadiusCaps: {
	maxConcurrentMutations: int & >=1
	maxDailyActions:        int & >=1
	rationale:              #NonEmptyString
}

// ========================================
// DRIFT DETECTION
// ========================================

// Política global de drift detection.
#DriftDetectionPolicy: {
	// Cadência padrão de avaliação (e.g., "daily", "weekly").
	evaluationCadence: #NonEmptyString
	defaultMetrics:    [#DriftMetric, ...#DriftMetric]
	rationale:         #NonEmptyString
}

// Drift detection config per-agent.
#DriftDetectionConfig: {
	// Cadência de avaliação para este agente (e.g., "daily", "weekly").
	evaluationCadence: #NonEmptyString
	metrics:           [#DriftMetric, ...#DriftMetric]
	rationale:         #NonEmptyString
}

// Métrica de drift — baseline + threshold = detecção.
// baseline e threshold são strings descritivas; runner parseia e valida
// que são mensuráveis (tq-gv-03). Exemplos: "< 5%", "> 95%", "< 30min".
#DriftMetric: {
	code:        string & =~"^dm-[a-z][a-z0-9-]*$"
	name:        #NonEmptyString
	description: #NonEmptyString
	baseline:    #NonEmptyString
	threshold:   #NonEmptyString
	rationale:   #NonEmptyString
}

// ========================================
// AUDIT POLICY
// ========================================

// Política global de auditoria — complementa auditTrail do agent-spec.
// governance-version em toda decisão é garantido estruturalmente:
// envelope exige governanceGlobalVersion e agent-spec inclui
// governance-version em _minimumAuditFields.
#AuditPolicy: {
	// Período mínimo de retenção (e.g., "5 years", "10 years").
	retentionPeriod: #NonEmptyString

	// Se auditores externos podem acessar o trail.
	externalAuditAccess: bool

	rationale: #NonEmptyString
}

// ========================================
// CALIBRATION
// ========================================

// Regras de calibração — promoção e regressão de autonomia.
#CalibrationRules: {
	promotionCriteria:  [#CalibrationCriterion, ...#CalibrationCriterion]
	regressionTriggers: [#RegressionTrigger, ...#RegressionTrigger]
	rationale:          #NonEmptyString
}

// Critério para promoção de autonomia ou lifecycle stage.
#CalibrationCriterion: {
	description: #NonEmptyString

	// Métrica mensurável que deve ser satisfeita.
	metric: #NonEmptyString

	// Período mínimo de observação antes de promover (e.g., "30 days").
	minimumObservationPeriod: #NonEmptyString

	rationale: #NonEmptyString
}

// Trigger para regressão de autonomia ou lifecycle stage.
#RegressionTrigger: {
	description: #NonEmptyString

	// Métrica que dispara regressão quando threshold é atingido.
	metric: #NonEmptyString

	// Threshold que dispara a regressão.
	threshold: #NonEmptyString

	// Ação imediata quando trigger dispara.
	immediateAction: #RegressionAction

	rationale: #NonEmptyString
}

// O que acontece imediatamente quando um regression trigger dispara.
#RegressionAction:
	"reduce-autonomy" |           // Reduz autonomyLevel das ações afetadas
	"revert-to-previous-stage" |  // Volta ao lifecycle stage anterior
	"suspend-and-escalate"        // Suspende o agente e escala para humano
