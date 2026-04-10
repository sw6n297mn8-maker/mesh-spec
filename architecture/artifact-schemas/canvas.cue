package artifact_schemas

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"

// canvas.cue — Artifact schema para Bounded Context Canvas.
//
// O BC Canvas é o documento raiz de identidade de cada bounded context.
// É a primeira coisa que um agente lê ao operar dentro de um contexto.
//
// O que vive aqui: identidade, contorno, domain roles, capabilities,
// comunicação inbound/outbound, decisões de negócio, stakeholders,
// custos eliminados, incentivos, ownership, governance, assumptions,
// open questions e métricas de verificação.
//
// O que NÃO vive aqui:
// - topologia entre BCs → context map
// - implementação técnica → Architecture Communication Canvas / ADRs
// - contratos de API → OpenAPI / AsyncAPI specs
// - infrastructure transversals → Architecture Communication Canvas
// - agent override / translation responsibility → agent specs
//
// Estratégia desta versão:
// - communication é union discriminado por tipo de interação
// - command-handler e command-invocation declaram interactionMode (sync/async)
// - todo BC tem domain agent (Mesh é AI-operated)
// - sourceContext, targetContext e consumers usam refs tipados
// - resultingEvents é plural (um command pode produzir múltiplos eventos)
// - capability flags dirigem completude condicional (enforced por runner)
// - ubiquitousLanguageRef usa regex canônica
// - costsEliminated é opcional no schema; runner enforça para core/supporting
// - ownership.domainAgentSpec é SoT local; context map replica para visão global
// - assumptions e open questions capturam estado epistêmico

#Canvas: {
	// Código lowercase do BC.
	// CI valida que code coincide com o nome do diretório em contexts/<code>/.
	code: string & =~"^[a-z][a-z0-9-]*$"

	// Nome completo do Bounded Context.
	name: string & !=""

	// Por que este contexto existe como unidade separada.
	// Deve justificar o contorno — explicar qual responsabilidade
	// é exclusivamente deste BC.
	purpose: string & !=""

	// Referência ao glossário da Ubiquitous Language deste BC.
	// Regex alinhada com a convenção canônica do repositório.
	// CI valida que o artefato referenciado existe.
	ubiquitousLanguageRef: string & =~"^contexts/[a-z][a-z0-9-]*/glossary\\.cue$"

	// Classificação estratégica.
	classification: #BCClassification

	// Aplicabilidade por vertical de cadeia produtiva.
	// Opcional na Fase 1 do rollout definido em adr-043:
	// novos bounded contexts devem declarar; canvases existentes
	// permanecem válidos sob backfill progressivo guiado pelo
	// warning de tq-cv-13. Fase 2 (ADR posterior) promove a
	// obrigatório estrutural.
	verticalApplicability?: shared_types.#VerticalApplicability

	// Domain roles — archetypes do BC Canvas canônico.
	domainRoles: #DomainRoles

	// Capabilities declaradas — governam completude condicional.
	// Runner usa capability flags para determinar artefatos esperados:
	//   hasSyncSurface  → espera OpenAPI spec em contexts/{bc}/
	//   hasAsyncSurface → espera AsyncAPI spec em contexts/{bc}/
	// Agent specs são sempre esperados (todo BC tem domain agent).
	capabilities: #Capabilities

	// Comunicação inbound/outbound — perspectiva interna do BC.
	// Union discriminado por tipo de interação.
	// command-handler e command-invocation declaram interactionMode.
	communication: #BCCommunication

	// Decisões de negócio que moldam este BC.
	businessDecisions?: [...#BusinessDecision]

	// Stakeholders afetados por este BC, com referência ao mapa canônico.
	stakeholders: [#CanvasStakeholder, ...#CanvasStakeholder]

	// Custos de transação que este BC elimina.
	// Opcional no schema. Runner enforça presença para core/supporting (tq-cv-10).
	// BCs generic são isentos.
	costsEliminated?: [...#CanvasCostContribution]

	// Análise de incentivos — alinhamento com dp-08.
	incentiveAnalysis: #IncentiveAnalysis

	// Ownership e governance.
	// domainAgentSpec é SoT local do BC.
	// O context map replica para visão global. Em caso de drift, o canvas prevalece.
	ownership: #BCOwnership

	// Estado epistêmico do BC.
	assumptions?:   [...#Assumption]
	openQuestions?: [...#OpenQuestion]

	// Métricas de verificação de propósito.
	verificationMetrics?: [...#VerificationMetric]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/canvas\\.cue$"
			fileNameRegex:      "^canvas\\.cue$"
			description:        "Bounded Context Canvas: documento raiz de identidade e capabilities de cada BC."
			rationale:          "Canvas é o rootArtifact do sistema de completude. Vive na raiz do diretório do BC porque é a primeira coisa que um agente deve ler ao operar no contexto."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-cv-01"
			description: "Purpose justifica o contorno do BC"
			test:        "O campo purpose explica por que este contexto é separado e qual responsabilidade é exclusivamente dele. Purpose que descreve funcionalidade genérica ou que se aplicaria a outro BC falha."
			severity:    "fail"
			rationale:   "Purpose guia decisões de contorno. Se não justifica separação, o BC não tem critério para aceitar ou rejeitar responsabilidades."
		}, {
			id:          "tq-cv-02"
			description: "Stakeholder refs apontam para IDs existentes no stakeholder map"
			test:        "Cada stakeholders[].stakeholderRef corresponde a um code válido em domain/stakeholder-map.cue."
			severity:    "fail"
			rationale:   "Referências quebradas a stakeholders tornam a rastreabilidade ilusória."
		}, {
			id:          "tq-cv-03"
			description: "Incentive analysis identifica manipulação com custo concreto"
			test:        "incentiveAnalysis.participants contém pelo menos uma entrada com manipulationCost e vsBenefit preenchidos. Custo deve ser concreto e comparável ao benefício."
			severity:    "fail"
			rationale:   "dp-08 exige que custos de manipulação excedam benefícios por design."
		}, {
			id:          "tq-cv-04"
			description: "Custos eliminados são rastreáveis ao domínio quando presentes"
			test:        "Cada costRef em costsEliminated referencia ce-NN existente em domain/domain-definition.cue. contribution explica como ESTE BC especificamente contribui."
			severity:    "fail"
			rationale:   "Cost elimination é a justificativa econômica do BC. Referência quebrada ou contribuição genérica derrota a rastreabilidade."
		}, {
			id:          "tq-cv-05"
			description: "Archetype primário está declarado"
			test:        "domainRoles.primary é um archetype válido."
			severity:    "fail"
			rationale:   "Sem archetype, agentes não sabem se o BC é executor de workflows, gateway ou analítico."
		}, {
			id:          "tq-cv-06"
			description: "Communication entries são coerentes com capability flags"
			test:        "Se capabilities.hasSyncSurface, ao menos uma entrada com interactionMode 'sync' existe em communication (command-handler sync, query-surface, command-invocation sync, ou query-dependency). Se capabilities.hasAsyncSurface, ao menos uma entrada async existe (event-consumer, event-publisher, command-handler async, ou command-invocation async)."
			severity:    "warn"
			rationale:   "Capability flag sem comunicação correspondente indica canvas incompleto ou flag incorreto."
		}, {
			id:          "tq-cv-07"
			description: "Governance scope separa decisões autônomas de supervisionadas"
			test:        "ownership.governanceScope declara ao menos uma decisão em autonomousDecisions ou supervisedDecisions."
			severity:    "warn"
			rationale:   "Agente sem boundaries claras de autonomia é risco operacional."
		}, {
			id:          "tq-cv-08"
			description: "Assumptions têm sinal de invalidação"
			test:        "Cada assumptions[].invalidationSignal é não-vazio."
			severity:    "warn"
			rationale:   "Assumption sem sinal de invalidação é premissa que nunca será revisitada."
		}, {
			id:          "tq-cv-09"
			description: "Open questions têm impacto declarado"
			test:        "Cada openQuestions[].impact é não-vazio."
			severity:    "warn"
			rationale:   "Questão sem impacto declarado não orienta priorização."
		}, {
			id:          "tq-cv-10"
			description: "BC core ou supporting tem costsEliminated preenchido"
			test:        "Se classification.subdomainType é 'core' ou 'supporting', costsEliminated contém ao menos uma entrada. Validação por runner, não pelo schema."
			severity:    "fail"
			rationale:   "BCs core e supporting existem para eliminar custos de transação. BCs generic são isentos."
		}, {
			id:          "tq-cv-11"
			description: "Capability flags dirigem artefatos esperados pelo runner"
			test:        "hasSyncSurface → runner espera OpenAPI spec. hasAsyncSurface → runner espera AsyncAPI spec. Agent specs são sempre esperados. Validação por runner/unificação."
			severity:    "warn"
			rationale:   "Flags sem artefatos correspondentes indicam sistema incompleto."
		}, {
			id:          "tq-cv-12"
			description: "Refs de comunicação apontam para nós válidos do context map"
			test:        "Cada sourceContext, targetContext e consumer ref em communication deve corresponder a um context (contexts[].context) ou external system (ext-* em relationships[].source.code/target.code) declarado no context map. Validação por runner/unificação."
			severity:    "fail"
			rationale:   "Ref de comunicação apontando para nó inexistente é fronteira fantasma."
		}, {
			id:          "tq-cv-13"
			description: "Aplicabilidade por vertical declarada (Fase 1 advisory)"
			test:        "O campo verticalApplicability está presente e declara explicitamente o modo (vertical-agnostic, vertical-specific ou vertical-adaptable) com rationale. Ausência do campo é warning na Fase 1 do rollout definido em adr-043; novos canvases devem declarar o campo já na criação. Canvases existentes permanecem estruturalmente válidos e entram em backfill progressivo guiado por este warning."
			severity:    "warn"
			rationale:   "adr-043 Fase 1: campo opcional no schema, obrigatoriedade normativa de authoring sinalizada por warn advisory. Fase 2 promove a fail após backfill completo verificado."
		}]
		rationale: "Critérios cobrem contorno (purpose), rastreabilidade (stakeholders, costs, communication refs), alinhamento econômico (incentive analysis, costsEliminated condicional), identidade operacional (archetypes, communication discriminada, governance), completude condicional (capability flags) e estado epistêmico (assumptions, open questions)."
	}
}

// ==============================
// CLASSIFICATION
// ==============================

#BCClassification: {
	subdomainType:    "core" | "supporting" | "generic"
	businessRole:     "revenue-generator" | "engagement-creator" | "compliance-enforcer" | "operational-enabler"
	wardleyEvolution: "genesis" | "custom" | "product" | "commodity"
	rationale:        string & !=""
}

// ==============================
// DOMAIN ROLES
// ==============================

#DomainRoles: {
	primary:    #Archetype
	secondary?: [...#Archetype]
	rationale:  string & !=""
}

#Archetype:
	"analysis" |
	"draft" |
	"execution" |
	"gateway" |
	"specification" |
	"engagement"

// ==============================
// CAPABILITIES
// ==============================

#Capabilities: {
	operational: [#OperationalCapability, ...#OperationalCapability]

	// Flags que dirigem completude condicional.
	// Runner usa estes flags para determinar artefatos esperados:
	//   hasSyncSurface  → contexts/{bc}/ deve conter OpenAPI spec
	//   hasAsyncSurface → contexts/{bc}/ deve conter AsyncAPI spec
	// Agent specs são sempre esperados (todo BC tem domain agent).
	hasSyncSurface:  bool
	hasAsyncSurface: bool
}

#OperationalCapability: {
	// Referência a cc-NN de domain-definition.cue, quando aplicável.
	// CI valida que capabilityRef existe em domain-definition.cue se preenchido.
	capabilityRef?: string & =~"^cc-[0-9]+$"

	// Descrição da capability no contexto específico deste BC.
	description: string & !=""

	rationale: string & !=""
}

// ==============================
// COMMUNICATION
// ==============================

// Perspectiva interna do BC: o que recebe e o que emite.
// Union discriminado por tipo de interação.
// command-handler e command-invocation declaram interactionMode
// para distinguir sync de async sem ambiguidade.
// sourceContext, targetContext e consumers usam #ContextOrSystemRef
// para referenciar BCs internos ou sistemas externos do context map.
// tq-cv-12 valida existência por runner/unificação.
#BCCommunication: {
	inbound?:  [...#InboundEntry]
	outbound?: [...#OutboundEntry]
	rationale: string & !=""
}

#InteractionMode: "sync" | "async"

// Referência a um bounded context interno ou sistema externo.
// BCs internos: "cmt", "rew", etc. (sem prefixo).
// Sistemas externos: "ext-banco-central", "ext-spe", etc. (prefixo ext-).
// Deve corresponder a um nó declarado no context map.
// Runner valida existência (tq-cv-12).
#ContextOrSystemRef: string & =~"^([a-z][a-z0-9-]*|ext-[a-z][a-z0-9-]*)$"

// --- Inbound: o que este BC recebe ---

#InboundEntry:
	#InboundCommandHandler |
	#InboundEventConsumer |
	#InboundQuerySurface

#InboundCommandHandler: {
	type:            "command-handler"
	interactionMode: #InteractionMode
	trigger:         string & !=""
	command:         string & !=""
	resultingEvents: [string & !="", ...(string & !="")]
	description?:    string & !=""
}

// event-consumer é sempre async por natureza.
#InboundEventConsumer: {
	type:          "event-consumer"
	sourceContext: #ContextOrSystemRef
	event:         string & !=""
	reaction:      string & !=""
	description?:  string & !=""
}

// query-surface é sempre sync por natureza.
#InboundQuerySurface: {
	type:         "query-surface"
	query:        string & !=""
	returnType:   string & !=""
	description?: string & !=""
}

// --- Outbound: o que este BC emite proativamente ---

#OutboundEntry:
	#OutboundEventPublication |
	#OutboundCommandInvocation |
	#OutboundQueryDependency

// event-publisher é sempre async por natureza.
#OutboundEventPublication: {
	type:         "event-publisher"
	trigger:      string & !=""
	event:        string & !=""
	consumers:    [#ContextOrSystemRef, ...#ContextOrSystemRef]
	description?: string & !=""
}

#OutboundCommandInvocation: {
	type:            "command-invocation"
	interactionMode: #InteractionMode
	targetContext:   #ContextOrSystemRef
	command:         string & !=""
	trigger:         string & !=""
	description?:    string & !=""
}

// query-dependency é sempre sync por natureza.
#OutboundQueryDependency: {
	type:          "query-dependency"
	targetContext: #ContextOrSystemRef
	query:         string & !=""
	purpose:       string & !=""
	description?:  string & !=""
}

// ==============================
// BUSINESS DECISIONS
// ==============================

#BusinessDecision: {
	id:           string & =~"^bd-[a-z][a-z0-9-]+$"
	decision:     string & !=""
	rationale:    string & !=""
	consequences: string & !=""
}

// ==============================
// STAKEHOLDERS
// ==============================

#CanvasStakeholder: {
	// Referência ao sh-NN canônico em domain/stakeholder-map.cue.
	// CI valida existência.
	stakeholderRef: string & =~"^sh-[0-9]{2}$"

	// Papel específico deste stakeholder no contexto deste BC.
	roleInContext: string & !=""

	// Impacto deste BC sobre o stakeholder.
	impactDescription: string & !=""

	rationale: string & !=""
}

// ==============================
// COSTS ELIMINATED
// ==============================

#CanvasCostContribution: {
	// Referência ao ce-NN canônico em domain/domain-definition.cue.
	// CI valida existência.
	costRef: string & =~"^ce-[0-9]{2}$"

	// Como este BC contribui para a eliminação deste custo.
	contribution: string & !=""

	rationale: string & !=""
}

// ==============================
// INCENTIVE ANALYSIS
// ==============================

#IncentiveAnalysis: {
	// Análise por participante — alinhamento com dp-08.
	participants: [#IncentiveParticipant, ...#IncentiveParticipant]

	rationale: string & !=""
}

#IncentiveParticipant: {
	// Referência ao sh-NN canônico — rastreabilidade com stakeholder-map.
	stakeholderRef: string & =~"^sh-[0-9]{2}$"

	// Tipo de participante no contexto deste BC (e.g., "comprador", "fornecedor").
	participantType: string & !=""

	// Comportamento desejado pelo design do sistema.
	desiredBehavior: string & !=""

	// Incentivo que o sistema cria para este participante operar corretamente.
	correctOperationIncentive: string & !=""

	// Vetor de manipulação que este participante poderia explorar.
	manipulationVector: string & !=""

	// Custo concreto que o participante paga ao tentar manipular.
	manipulationCost: string & !=""

	// Comparação: por que custo de manipulação > benefício potencial.
	vsBenefit: string & !=""

	// Resposta de design do sistema ao vetor de manipulação.
	designResponse: string & !=""

	rationale: string & !=""
}

// ==============================
// OWNERSHIP & GOVERNANCE
// ==============================

#BCOwnership: {
	// Identificador do agent spec primário deste BC.
	// Este campo é SoT local. O context map replica para visão global.
	// Em caso de drift, o canvas prevalece.
	// Todo BC na Mesh tem domain agent — este campo é sempre obrigatório.
	domainAgentSpec: string & !=""

	// Boundaries de autonomia do agente.
	governanceScope: #GovernanceScope

	rationale: string & !=""
}

// Ao menos um dos blocos deve estar presente.
// CUE não tem "at least one optional" nativo.
// Enforcement via tq-cv-07 (warn).
// Listas tipadas com MinItems(1) quando presentes.
#GovernanceScope: {
	autonomousDecisions?: [#GovernanceDecision, ...#GovernanceDecision]
	supervisedDecisions?: [#GovernanceDecision, ...#GovernanceDecision]
	escalationCriteria?:  [#EscalationCriterion, ...#EscalationCriterion]
}

#GovernanceDecision: {
	id:          string & =~"^[a-z][a-z0-9-]*$"
	description: string & !=""
	rationale:   string & !=""
}

#EscalationCriterion: {
	id:        string & =~"^[a-z][a-z0-9-]*$"
	condition: string & !=""
	action:    string & !=""
	rationale: string & !=""
}

// ==============================
// ASSUMPTIONS & OPEN QUESTIONS
// ==============================

#Assumption: {
	id:                 string & =~"^as-[a-z][a-z0-9-]+-[0-9]+$"
	assumption:         string & !=""
	invalidationSignal: string & !=""
	rationale:          string & !=""
}

#OpenQuestion: {
	id:        string & =~"^oq-[a-z][a-z0-9-]+-[0-9]+$"
	question:  string & !=""
	impact:    string & !=""
	deadline?: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
	rationale: string & !=""
}

// ==============================
// VERIFICATION METRICS
// ==============================

#VerificationMetric: {
	id:        string & =~"^[a-z][a-z0-9-]*$"
	metric:    string & !=""
	target:    string & !=""
	rationale: string & !=""
}
