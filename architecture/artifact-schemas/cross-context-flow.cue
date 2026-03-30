package artifact_schemas

// cross-context-flow.cue — Schema para fluxos cross-context.
//
// Um CrossContextFlow documenta como bounded contexts independentes
// se compõem para realizar um fluxo de negócio que atravessa fronteiras.
// É artefato descritivo de composição, não artefato executável.
// Não possui estado próprio, regras próprias nem tecnologia de runtime.
// Choreography, orchestration ou saga são decisões posteriores de arquitetura.
//
// Decisão de modelagem desta revisão:
// - ownership primário por bounded context, não por subdomínio
// - ordem canônica é a ordem da lista `phases`
// - v1 suporta fluxo linear; branching/paralelismo ficam explicitamente fora do escopo
// - invariantes emergentes precisam apontar para contribuições concretas de múltiplos contexts
// - conectividade entre fases é verificável: consumedBy referencia sinais da fase emissora

#CrossContextFlow: {
	// Identidade canônica do flow.
	code: string & =~"^[a-z][a-z0-9-]*$"
	name: string & !=""
	purpose: string & !=""

	// Escopo explícito desta versão.
	topology: "linear"

	// Contexto do flow e limites semânticos.
	scope: {
		startsWhen: string & !=""
		endsWhen:   string & !=""
		outOfScope?: [...string]
		rationale:  string & !=""
	}

	// Fases ordenadas do fluxo.
	// A ordem da lista é a ordem canônica.
	// Cada fase é owned por exatamente um bounded context.
	phases: [#FlowPhase, #FlowPhase, ...#FlowPhase]

	// Invariantes que emergem da composição entre contexts.
	// Não são enforçadas por este artefato; são verdadeiras
	// quando os gates locais de cada context funcionam como esperado.
	emergentInvariants: [#EmergentInvariant, ...#EmergentInvariant]

	// Conceitos que nascem em uma fase/context e são consumidos
	// por outras fases/contexts ao longo do flow.
	// O conceito continua pertencendo ao glossário do context de origem;
	// este artefato apenas documenta a travessia.
	crossCuttingConcepts?: [#CrossCuttingConcept, ...#CrossCuttingConcept]

	// Referências que pertencem à composição e não a um único context.
	mechanismRefs?:  [...#MechanismRef]
	costRefs?:       [...#CostRef]
	capabilityRefs?: [...#CapabilityRef]
	policyRefs?:     [...#PolicyRef]

	// Riscos, falhas conhecidas e limitações explícitas do flow.
	failureModes?:     [...#FlowFailureMode]
	knownLimitations?: [...string]
	openQuestions?:     [...string]
	assumptions?:       [...string]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/cross-context-workflows/[a-z][a-z0-9-]*\\.cue$"
			fileNameRegex:      "^[a-z][a-z0-9-]*\\.cue$"
			description:        "Cross-context flow: composição arquitetural entre bounded contexts para um fluxo de negócio linear cross-context."
			rationale:          "Flows cross-context vivem em architecture/cross-context-workflows/ porque descrevem composição entre bounded contexts, permanecendo agnósticos a runtime."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-xf-01"
			description: "Cada fase tem ownership primário explícito por bounded context"
			test:        "Cada phases[] declara ownerContext apontando para um bounded context existente em contexts/. Fase sem ownerContext falha."
			severity:    "fail"
			rationale:   "Gates e decisões de fronteira pertencem a bounded contexts concretos, não a um flow abstrato."
		}, {
			id:          "tq-xf-02"
			description: "Fases formam cadeia conectada sem gaps de responsabilidade"
			test:        "Para cada par de fases consecutivas, ao menos um consumedBy da fase anterior referencia o ownerContext da fase seguinte via campo consumes que aponta para completionSignal ou integrationEvents[] da fase emissora. Fase terminal sem consumedBy é permitida."
			severity:    "fail"
			rationale:   "Gap entre fases é responsabilidade não alocada — o modo de falha mais comum em fluxos cross-context."
		}, {
			id:          "tq-xf-03"
			description: "Invariantes emergentes referenciam contribuições concretas de múltiplos contexts"
			test:        "Cada emergentInvariants[] contém ao menos duas contributions de contexts distintos. Invariante emergente com contribuição única falha."
			severity:    "fail"
			rationale:   "Se só um context implementa a invariante, ela não é emergente; é local."
		}, {
			id:          "tq-xf-04"
			description: "Conceitos cross-cutting têm origem e consumidores explícitos"
			test:        "Cada crossCuttingConcepts[] declara originContext, originPhase, e consumedBy com pelo menos um context downstream."
			severity:    "fail"
			rationale:   "Conceito cross-context sem origem e consumidores claros vira entidade flutuante."
		}, {
			id:          "tq-xf-05"
			description: "Artefato permanece agnóstico a tecnologia de execução"
			test:        "Nenhum campo obrigatório do schema exige runtime específico. Menções a choreography/orchestration/saga podem existir apenas como nota descritiva, nunca como tecnologia concreta."
			severity:    "warn"
			rationale:   "Acoplar fluxo estratégico a runtime reduz independência arquitetural e dificulta evolução."
		}, {
			id:          "tq-xf-06"
			description: "Fluxo declara explicitamente o que está fora do escopo"
			test:        "scope.outOfScope é recomendado quando o flow atravessa regiões cinzentas com outros flows. Ausência não falha, mas degrada clareza."
			severity:    "warn"
			rationale:   "Cross-context flows tendem a se sobrepor. Escopo explícito reduz colisão entre artefatos."
		}, {
			id:          "tq-xf-07"
			description: "Flow que atravessa contexts financeiros declara failure modes"
			test:        "Se algum phases[].ownerContext é context financeiro (fce, rew, scf, bkr, ato) ou o flow envolve movimentação de valor, failureModes deve estar preenchido com ao menos uma entrada. Ausência não bloqueia, mas indica gap de análise de risco."
			severity:    "warn"
			rationale:   "Em fluxos financeiros, happy-path-only é insuficiente — modos de falha não documentados são modos de falha não mitigados."
		}]
		rationale: "Critérios cobrem ownership real por context, conectividade verificável entre fases, rastreabilidade de invariantes emergentes, separação entre composição de domínio e execução, e análise de risco em fluxos financeiros."
	}
}

#FlowPhase: {
	// Nome legível da fase.
	name: string & !=""

	// Bounded context owner da fase.
	ownerContext: #BoundedContextRef

	// Subdomínio owner opcional para rastreabilidade estratégica.
	ownerSubdomain?: #SubdomainRef

	// O que a fase faz no fluxo.
	description: string & !=""

	// Condições para a fase poder começar.
	preconditions?: [...string]

	// Gates locais que precisam estar satisfeitos para a fase completar.
	// São referências a gates do BC, não definições — o BC é a source of truth.
	localGates?: [...string]

	// Sinal canônico de conclusão da fase.
	completionSignal: string & !=""

	// Eventos de integração emitidos ao completar a fase.
	integrationEvents?: [...string]

	// Contexts downstream diretamente dependentes desta fase.
	// Cada consumer referencia o sinal específico que consome,
	// permitindo verificação de conectividade pelo CI.
	consumedBy?: [...#PhaseConsumer]

	rationale: string & !=""
}

#PhaseConsumer: {
	// Bounded context que consome o sinal.
	context: #BoundedContextRef

	// Nome da fase consumidora (deve existir em phases[].name).
	phase?: string & !=""

	// Sinal que este consumer consome (deve existir em
	// completionSignal ou integrationEvents[] da fase emissora).
	consumes: string & !=""
}

#EmergentInvariant: {
	statement: string & !=""

	// Contribuições locais que, juntas, tornam a invariante verdadeira.
	implementedBy: [#InvariantContribution, #InvariantContribution, ...#InvariantContribution]

	// Como verificar a invariante na prática.
	verificationStrategy: string & !=""

	rationale: string & !=""
}

#InvariantContribution: {
	context:      #BoundedContextRef
	phase?:       string & !=""
	contribution: string & !=""
}

#CrossCuttingConcept: {
	name: string & !=""

	// Onde o conceito nasce no flow.
	originPhase:   string & !=""
	originContext: #BoundedContextRef

	// Quem consome o conceito depois que ele nasce.
	consumedBy: [#ConceptConsumer, ...#ConceptConsumer]

	rationale: string & !=""
}

#ConceptConsumer: {
	context: #BoundedContextRef
	phase?:  string & !=""
	usage:   string & !=""
}

#FlowFailureMode: {
	name:        string & !=""
	description: string & !=""
	detectedBy?:  [...string]
	mitigatedBy?: [...string]
	rationale:   string & !=""
}

// Ref para bounded context — tipo novo, padrão consistente com refs existentes.
#BoundedContextRef: string & =~"^[a-z][a-z0-9-]*$"

// Ref para políticas — tipo novo.
#PolicyRef: string & =~"^pol-[a-z][a-z0-9-]*$"
