package artifact_schemas

// agent-spec.cue — Schema para Agent Spec.
//
// O agent spec define o que um agente faz, sobre o que opera,
// quais ações executa, quais restrições obedece e o que observa.
//
// Estratégia desta versão:
// - escopo operacional referencia domain model por prefixos canônicos
// - ações tipadas por categoria e por nível de autonomia
// - contexto operacional declara o que o agente precisa carregar
// - restrições são constraints verificáveis, não guidelines textuais
// - governance operacional vive em artefato separado referenciado por governanceRef
// - observability é contrato explícito, não aspiração
// - escalation cobre incerteza geral, não apenas violação de constraint
//
// Decisão arquitetural (ADR-037):
// Governança de agentes opera em dois níveis:
// 1. Global (architecture/agent-governance.cue): defaults, taxonomias, políticas transversais.
// 2. Per-agent envelope ({agent}.governance.cue): limites, thresholds, overrides locais.
// O #AgentSpec não replica governança; declara comportamento operacional e referencia
// seu envelope via governanceRef.
//
// Fronteira spec ↔ governance:
// - agent-spec declara QUANDO escalar (escalationConditions)
// - governance envelope declara COMO escalar (canal, SLA, destinatário)
// - agent-spec declara nível de autonomia por ação (autonomyLevel)
// - governance envelope declara calibração dinâmica (promoção/regressão)
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária): autonomyLevel, escalation, observability
// - lens-security-trust-infrastructure (secundária): inputTrustLevel, operationalScope
// - lens-regulatory-compliance-as-architecture (terciária): auditTrail, constraints
//
// O que NÃO vive aqui:
// - lifecycle stage → governance envelope
// - blast radius limits/caps → governance envelope
// - drift detection config → governance envelope
// - HITL calibration rules → governance envelope
// - promotion/regression criteria → governance envelope
//
// Limitações conhecidas:
// - Refs usam regex com trailing hyphens aceitos (^xxx-[a-z][a-z0-9-]*$)
//   por consistência com domain-model.cue e glossary.cue.
// - inputTrustLevel é opcional; enforcement de presença em ações com input
//   externo depende de runner (tq-ag-11), não do type system.
// - tq-ag-12 (compatibilidade autonomyLevel × constraints) é critério
//   semântico soft — operacionalizável por exemplos, não por tabela exaustiva.

#AgentSpec: {
	code: string & =~"^agt-[a-z][a-z0-9-]*$"
	name: string & !=""
	description: string & !=""

	// Referência ao BC onde este agente opera.
	// Runner valida que corresponde ao canvas.code do BC.
	boundedContextRef: #BoundedContextRef

	// Papel do agente neste BC.
	role: #AgentRole

	// Referência ao envelope de governança deste agente.
	// Valor é o nome base do arquivo governance: para agente em
	// contexts/{bc}/agents/{name}.cue, envelope está em
	// contexts/{bc}/agents/{governanceRef}.governance.cue.
	// Runner constrói path: contexts/{boundedContextRef}/agents/{governanceRef}.governance.cue
	// e valida existência.
	governanceRef: string & =~"^[a-z][a-z0-9-]*$"

	// Escopo operacional — sobre quais building blocks do domain model
	// este agente tem responsabilidade. Refs usam prefixos canônicos.
	// Runner valida existência no domain-model.cue.
	operationalScope: #OperationalScope

	// Ações que este agente pode executar.
	// Tipadas por categoria e por nível de autonomia.
	actions: [#AgentAction, ...#AgentAction]

	// Restrições que este agente obedece.
	// Constraints verificáveis, não guidelines textuais.
	constraints: [#AgentConstraint, ...#AgentConstraint]

	// Condições de escalation geral — quando o agente para e escala.
	// Cobre incerteza, ambiguidade e anomalia, não apenas violação de constraint.
	// O agent-spec declara QUANDO escalar; o governance envelope declara COMO
	// (canal, SLA, destinatário).
	escalationConditions: [#EscalationCondition, ...#EscalationCondition]

	// O que o agente precisa carregar para operar.
	// Informa context window budget e retrieval patterns.
	contextRequirements: #ContextRequirements

	// Contrato de observabilidade — o que o agente reporta.
	observability: #ObservabilityContract

	// Por que este agente existe como unidade separada.
	// Especialmente relevante quando há múltiplos agentes no mesmo BC.
	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/agents/[a-z][a-z0-9-]*\\.cue$"
			fileNameRegex:      "^[a-z][a-z0-9-]*\\.cue$"
			description:        "Agent spec: definição operacional de um agente dentro de um BC."
			rationale:          "Agent specs vivem em contexts/{bc}/agents/ porque são subordinados ao canvas do BC. Múltiplos agentes por BC são permitidos."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-ag-01"
			description: "Escopo operacional referencia building blocks válidos do domain model"
			test:        "Cada ref em operationalScope (aggregates, commands, events, invariants) existe no domain-model.cue do mesmo BC. Validação por runner."
			severity:    "fail"
			rationale:   "Agente operando sobre building block inexistente é responsabilidade fantasma."
		}, {
			id:          "tq-ag-02"
			description: "Ações referenciam building blocks dentro do escopo operacional"
			test:        "Cada domainModelRef em actions[] aponta para um building block listado em operationalScope. Agente não pode agir fora do seu escopo."
			severity:    "fail"
			rationale:   "Ação fora do escopo viola o princípio de least privilege."
		}, {
			id:          "tq-ag-03"
			description: "Agent code corresponde ao domainAgentSpec do canvas"
			test:        "Ao menos um agent spec no BC tem code que corresponde ao canvas.ownership.domainAgentSpec. Validação por runner."
			severity:    "fail"
			rationale:   "Canvas referenciando agent spec inexistente é ownership fantasma."
		}, {
			id:          "tq-ag-04"
			description: "Constraints são verificáveis, não aspiracionais"
			test:        "Cada constraints[].verification descreve como a constraint pode ser verificada mecanicamente ou por runner. Constraint sem mecanismo de verificação é guideline, não constraint."
			severity:    "warn"
			rationale:   "Constraint sem verificação é promessa vazia em sistema AI-operated."
		}, {
			id:          "tq-ag-05"
			description: "Observability emite ao menos um sinal por categoria de ação"
			test:        "Para cada categoria de ação presente em actions[], ao menos um signal em observability.signals cobre essa categoria."
			severity:    "warn"
			rationale:   "Ação sem observabilidade é operação invisível."
		}, {
			id:          "tq-ag-06"
			description: "Context requirements são coerentes com escopo operacional"
			test:        "Cada artefato listado em contextRequirements.artifacts é necessário para operar sobre ao menos um building block do operationalScope."
			severity:    "warn"
			rationale:   "Contexto carregado sem uso no escopo é desperdício de context window."
		}, {
			id:          "tq-ag-07"
			description: "Codes de ações são únicos"
			test:        "Nenhum code duplicado em actions[]."
			severity:    "fail"
			rationale:   "Code duplicado quebra rastreabilidade de auditoria."
		}, {
			id:          "tq-ag-08"
			description: "Codes de constraints são únicos"
			test:        "Nenhum code duplicado em constraints[]."
			severity:    "fail"
			rationale:   "Code duplicado quebra rastreabilidade de governança."
		}, {
			id:          "tq-ag-09"
			description: "governanceRef aponta para governance envelope existente"
			test:        "No diretório contexts/{boundedContextRef}/agents/, existe arquivo {governanceRef}.governance.cue. Runner constrói path a partir de boundedContextRef + governanceRef e valida existência."
			severity:    "fail"
			rationale:   "Ponte para governança sem alvo é delegação para o vazio — agente opera sem envelope."
		}, {
			id:          "tq-ag-10"
			description: "Escalation conditions são coerentes com role e escopo"
			test:        "escalationConditions[] contém ao menos uma condição. As categorias declaradas são coerentes com o role do agente e o operationalScope: integration-agent e validation-agent que processam input externo incluem ao menos suspicious-input ou ambiguous-case; agentes com mutations incluem ao menos conflicting-signals ou insufficient-context. Runner verifica coerência, não cobertura exaustiva de #EscalationCategory."
			severity:    "warn"
			rationale:   "Agente sem condições de escalation opera com autonomia implícita ilimitada — escala apenas por violação de constraint, não por incerteza."
		}, {
			id:          "tq-ag-11"
			description: "Ações com input externo não-confiável declaram inputTrustLevel"
			test:        "Toda ação cujo domainModelRefs inclui building blocks que recebem dados de fontes externas (documentos, APIs de terceiros) declara inputTrustLevel. Ações puramente internas podem omitir. Runner identifica building blocks externos via integration patterns no context-map."
			severity:    "warn"
			rationale:   "Input externo não-classificado impede defesas proporcionais — prompt injection em freeform requer sanitização diferente de structured API."
		}, {
			id:          "tq-ag-12"
			description: "Compatibilidade semântica entre autonomyLevel e constraints"
			test:        "Para cada ação: o conjunto de constraints aplicáveis (via domainModelRefs compartilhados) é compatível com o autonomyLevel declarado. Exemplos de incoerência que o runner deve flaggear: (a) execute-and-log onde todas as constraints aplicáveis têm onViolation log-only — agente sem freio real; (b) no-autonomous-action com constraints que têm onViolation log-only — constraint que nunca dispara porque humano já controla."
			severity:    "warn"
			rationale:   "Autonomia e constraints são dimensões ortogonais mas não independentes — combinações incoerentes indicam modelagem incompleta."
		}, {
			id:          "tq-ag-13"
			description: "Audit trail contém campos mínimos regulatory-grade"
			test:        "auditTrail.requiredFields contém ao menos: timestamp, agent-id, action-code, input-summary, output-summary, decision-rationale, governance-version. Runner valida que _minimumAuditFields ⊆ requiredFields."
			severity:    "fail"
			rationale:   "Intermediário financeiro regulado requer reconstituição completa de decisões — audit trail sem campos mínimos é auditoria nominal."
		}]
		rationale: "Critérios cobrem integridade referencial com domain model (tq-ag-01, tq-ag-02), alinhamento com canvas (tq-ag-03), verificabilidade de constraints (tq-ag-04), cobertura de observabilidade (tq-ag-05), eficiência de contexto (tq-ag-06), unicidade (tq-ag-07, tq-ag-08), ponte de governança (tq-ag-09), completude de escalation (tq-ag-10), classificação de input (tq-ag-11), coerência autonomia-constraints (tq-ag-12) e mínimo de audit trail (tq-ag-13)."
	}
}

// ==============================
// AGENT ROLE
// ==============================

// Papel do agente dentro do BC.
// domain-agent: opera sobre o domain model do BC (default, obrigatório).
// integration-agent: opera nas fronteiras com outros BCs ou sistemas externos.
// validation-agent: especializado em verificação de invariantes e compliance.
// observation-agent: especializado em monitoramento e detecção de anomalias.
#AgentRole:
	"domain-agent" |
	"integration-agent" |
	"validation-agent" |
	"observation-agent"

// ==============================
// AUTONOMY LEVEL
// ==============================

// Nível de autonomia por ação, baseado na escala de Sheridan/Verplank
// simplificada para 4 níveis operacionais.
// O nível descreve até onde o agente vai antes de envolver humano.
// Calibração dinâmica (promoção/regressão) vive no governance envelope.
#AutonomyLevel:
	"execute-and-log" |        // Agente executa e registra. Humano audita em batch.
	"propose-and-wait" |       // Agente analisa e propõe. Humano aprova antes de execução.
	"collect-and-report" |     // Agente coleta informação. Humano analisa e decide.
	"no-autonomous-action"     // Humano faz tudo. Agente não participa desta ação.

// ==============================
// INPUT TRUST LEVEL
// ==============================

// Classificação de confiança do input que a ação processa.
// Informa defesas proporcionais: sanitização, validação, isolamento.
// Ações puramente internas podem omitir (default implícito: trusted-internal).
#InputTrustLevel:
	"trusted-internal" |             // Sinais internos de outros BCs ou do próprio domain model.
	"external-structured" |          // Input externo com schema definido (API de bureau, registradora).
	"external-untrusted-freeform"    // Input externo sem schema (PDF, texto livre de fornecedor).

// ==============================
// ESCALATION CONDITIONS
// ==============================

// Condição que faz o agente parar e escalar.
// Cobre incerteza geral, não apenas violação de constraint.
// O agent-spec declara QUANDO escalar (condição + categoria).
// O governance envelope declara COMO escalar (canal, SLA, destinatário).
#EscalationCondition: {
	category:    #EscalationCategory
	description: #NonEmptyString
	rationale:   #NonEmptyString
}

#EscalationCategory:
	"ambiguous-case" |           // Caso com múltiplas interpretações válidas.
	"out-of-scope" |             // Situação fora do escopo operacional declarado.
	"conflicting-signals" |      // Sinais contraditórios de fontes diferentes.
	"insufficient-context" |     // Contexto insuficiente para decidir com confiança.
	"suspicious-input" |         // Input com padrão suspeito (possível injection, anomalia).
	"unclassifiable-anomaly"     // Anomalia que o agente não consegue classificar.

// ==============================
// OPERATIONAL SCOPE
// ==============================

// Building blocks do domain model sob responsabilidade deste agente.
// Refs usam prefixos canônicos do domain-model.cue.
// Runner valida existência.
#OperationalScope: {
	// Aggregates que o agente pode operar.
	aggregates: [#AggregateRef, ...#AggregateRef]

	// Commands que o agente pode processar.
	commands?: [...#CommandRef]

	// Events que o agente pode consumir ou reagir.
	events?: [...#EventRef]

	// Invariants que o agente é responsável por verificar.
	invariants?: [...#InvariantRef]

	// Projections que o agente pode consultar.
	projections?: [...#ProjectionRef]
}

// ==============================
// ACTIONS
// ==============================

// Ação que o agente pode executar.
// Tipada por categoria e por nível de autonomia.
#AgentAction: {
	code: string & =~"^act-[a-z][a-z0-9-]*$"
	name: #NonEmptyString
	description: #NonEmptyString

	// Categoria da ação — determina o que o runner audita.
	category: #ActionCategory

	// Nível de autonomia desta ação específica.
	// Calibração dinâmica (promoção/regressão por track record) vive
	// no governance envelope. O spec declara o nível operacional atual.
	autonomyLevel: #AutonomyLevel

	// Classificação de confiança do input que esta ação processa.
	// Obrigatório se a ação processa input de fonte externa (tq-ag-11).
	// Omitir apenas se a ação opera exclusivamente sobre sinais internos.
	inputTrustLevel?: #InputTrustLevel

	// Building blocks do domain model envolvidos nesta ação.
	// Refs com prefixos de operationalScope (agg-/cmd-/evt-/inv-/prj-)
	// devem estar dentro do operationalScope (tq-ag-02 least privilege).
	// Refs com prefixos não representados diretamente em operationalScope
	// (vo-/ent-/qry-/mod-/svc-/pol-) são permitidas pelo regex de
	// #DomainModelRef e associadas via parent (vo-/ent- via aggregate;
	// qry- via projection) ou por scope próprio quando declarados como
	// building blocks top-level. Ver PG-A heuristic correspondente
	// para discipline detalhada.
	domainModelRefs: [#DomainModelRef, ...#DomainModelRef]

	// Condições que devem ser verdadeiras para a ação ser permitida.
	preconditions?: [...#NonEmptyString]

	// O que muda após a ação ser executada.
	postconditions?: [...#NonEmptyString]
}

// Categorias de ação para auditoria e observabilidade.
#ActionCategory:
	"query" |          // Leitura sem efeito colateral
	"mutation" |       // Alteração de estado via command
	"validation" |     // Verificação de invariante ou regra
	"generation" |     // Geração de artefato (código, spec, documento)
	"escalation"       // Escalação para supervisão humana

// ==============================
// CONSTRAINTS
// ==============================

// Restrição que o agente obedece.
// Constraints são verificáveis — não são guidelines textuais.
#AgentConstraint: {
	code: string & =~"^cst-[a-z][a-z0-9-]*$"
	name: #NonEmptyString
	description: #NonEmptyString

	// Como esta constraint pode ser verificada mecanicamente.
	// Deve ser concreto o suficiente para um runner implementar.
	verification: #NonEmptyString

	// Consequência quando a constraint é violada.
	onViolation: #ViolationResponse

	rationale: #NonEmptyString
}

// O que acontece quando uma constraint é violada.
#ViolationResponse:
	"block-and-escalate" |    // Bloqueia a ação e escala para humano
	"warn-and-continue" |     // Emite warning mas permite continuar
	"rollback-and-escalate" | // Reverte a ação e escala para humano
	"log-only"                // Apenas registra para auditoria

// ==============================
// CONTEXT REQUIREMENTS
// ==============================

// O que o agente precisa carregar para operar.
// Informa context window budget e assembly de contexto.
#ContextRequirements: {
	// Artefatos que o agente precisa no contexto.
	artifacts: [#ContextArtifact, ...#ContextArtifact]

	// Estimativa de peso do contexto total.
	estimatedBudget: #ContextBudget
}

#ContextArtifact: {
	// Tipo do artefato que o agente precisa carregar.
	artifactType: #ContextArtifactType

	// Por que o agente precisa deste artefato.
	rationale: #NonEmptyString

	// Quais seções ou slices do artefato são necessários.
	// Agentes não precisam de artefatos inteiros.
	requiredSlices?: [...#NonEmptyString]
}

#ContextArtifactType:
	"canvas" |
	"domain-model" |
	"glossary" |
	"api-spec" |
	"async-api-spec" |
	"agent-governance" |
	"context-map"

#ContextBudget:
	"light" |      // < 4K tokens estimados
	"moderate" |   // 4K–16K tokens estimados
	"heavy"        // > 16K tokens estimados

// ==============================
// OBSERVABILITY
// ==============================

// Contrato de observabilidade — o que o agente reporta.
// Não é aspiração; é contrato. Runner verifica compliance.
#ObservabilityContract: {
	// Sinais que o agente emite durante operação.
	signals: [#ObservabilitySignal, ...#ObservabilitySignal]

	// Formato do audit trail que o agente produz.
	auditTrail: #AuditTrailSpec
}

#ObservabilitySignal: {
	code: string & =~"^sig-[a-z][a-z0-9-]*$"
	name: #NonEmptyString
	description: #NonEmptyString

	// Categoria de ação que este sinal cobre.
	coversCategory: #ActionCategory

	// Quando o sinal é emitido.
	trigger: #NonEmptyString

	// Nível de severidade do sinal.
	level: #SignalLevel
}

#SignalLevel:
	"info" |
	"warn" |
	"error" |
	"critical"

#AuditTrailSpec: {
	// O que cada entrada do audit trail deve conter.
	// Deve incluir ao menos os campos em _minimumAuditFields (tq-ag-13).
	requiredFields: [#NonEmptyString, ...#NonEmptyString]

	// Campos mínimos regulatory-grade para intermediário financeiro.
	// Runner valida que _minimumAuditFields ⊆ requiredFields.
	_minimumAuditFields: [
		"timestamp",
		"agent-id",
		"action-code",
		"input-summary",
		"output-summary",
		"decision-rationale",
		"governance-version",
	]

	// Onde o audit trail é persistido.
	// Detalhes de implementação vivem no Architecture Communication Canvas.
	storageHint: #NonEmptyString

	rationale: #NonEmptyString
}

// ==============================
// REFS
// ==============================

// Refs ao domain model usando prefixos canônicos.
#DomainModelRef:  string & =~"^(evt|cmd|inv|vo|agg|ent|mod|svc|pol|prj|qry)-[a-z][a-z0-9-]*$"
#AggregateRef:    string & =~"^agg-[a-z][a-z0-9-]*$"
#CommandRef:      string & =~"^cmd-[a-z][a-z0-9-]*$"
#EventRef:        string & =~"^evt-[a-z][a-z0-9-]*$"
#InvariantRef:    string & =~"^inv-[a-z][a-z0-9-]*$"
#ProjectionRef:   string & =~"^prj-[a-z][a-z0-9-]*$"

#BoundedContextRef: string & =~"^[a-z][a-z0-9-]*$"
#NonEmptyString:    string & !=""
