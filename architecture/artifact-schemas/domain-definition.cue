package artifact_schemas

#DomainDefinition: {
	name:    string & !=""
	tagline: string & !=""

	coreThesis: {
		statement: string & !=""
		rationale: string & !=""
	}

	mechanisms: [#Mechanism, ...#Mechanism]

	foundingPrinciples: {
		conflictResolution: {
			// levels ordenados por precedência: o primeiro vence todos os outros.
			// CI valida que todo id em principleIds existe em axioms ou derived.
			levels: [#PrecedenceLevel, ...#PrecedenceLevel]
			reversibilityThreshold: {
				description:             string & !=""
				criteriaForIrreversible: [string & !="", ...string & !=""]
			}
		}
		axioms:  [#Principle, ...#Principle]
		derived: [#DerivedPrinciple, ...#DerivedPrinciple]
	}

	value: {
		costsEliminated:     [#CostEliminated, ...#CostEliminated]
		capabilitiesCreated: [#CapabilityCreated, ...#CapabilityCreated]
	}

	flywheel: {
		description: string & !=""
		// CI valida que todo feedsInto referencia um id existente em steps
		// e que o grafo forma pelo menos um ciclo.
		steps:     [#FlywheelStep, ...#FlywheelStep]
		rationale: string & !=""
	}

	inScope:     [#ScopeEntry, ...#ScopeEntry]
	outOfScope:  [#ScopeEntry, ...#ScopeEntry]
	notIdentity: [#NegativeIdentity, ...#NegativeIdentity]

	antiThesis: [#AntiThesis, ...#AntiThesis]

	// CI valida que o artefato referenciado existe e é parseable.
	designPrinciplesRef: string & !=""

	// CI valida que o artefato referenciado existe e é parseable.
	stakeholderMapRef: string & !=""

	// Metadata do schema — não exportado para instâncias.
	_schema: {
		location: {
			canonicalPathRegex: "^domain/domain-definition\\.cue$"
			fileNameRegex:      "^domain-definition\\.cue$"
			description:        "Definição do domínio: tese central, mecanismos, princípios fundadores, proposta de valor, flywheel, escopo."
			rationale:          "Artefato singleton na raiz do domínio. Nome fixo porque é unique no sistema."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-dd-01"
			description: "Mecanismos concretos e verificáveis"
			test:        "Cada mechanism tem description que descreve uma capacidade verificável empiricamente. Teste de substituição: se a description pudesse se aplicar a qualquer sistema financeiro genérico, está abstrata demais. Cada mechanism deve ser ancorado em pelo menos um artefato ou capacidade específica da Mesh."
			severity:    "fail"
			rationale:   "Mecanismos abstratos não diferenciam a Mesh. Cada mecanismo deve ser rastreável a uma capacidade concreta do sistema."
		}, {
			id:          "tq-dd-02"
			description: "Fronteiras de escopo testáveis"
			test:        "Cada entry em inScope e outOfScope define uma fronteira que um observador externo pode verificar: dado um caso concreto, deve ser possível determinar sem ambiguidade se está dentro ou fora do escopo. Entradas como 'coisas relevantes' ou 'aspectos gerais' falham este teste."
			severity:    "fail"
			rationale:   "Fronteiras vagas não protegem contra scope creep — que é o risco principal que inScope/outOfScope mitigam."
		}]
		rationale: "Domain definition é o artefato fundacional. Critérios garantem que mecanismos são concretos e fronteiras são operacionais, não aspiracionais."
	}
}

// ── Tipos de suporte ──
// Definidos no nível do package para reusabilidade entre schemas.
// TODO: extrair para artifact_schemas_common quando design-principles.cue
// precisar de #Principle.

#Mechanism: {
	// Formato slug mech-* alinhado com consumidores (subdomain, cross-context-flow).
	id:               string & =~"^mech-[a-z][a-z0-9-]*$"
	name:             string & !=""
	description:      string & !=""
	thesisConnection: string & !=""
	stages?: [string & !="", ...string & !=""]
	rationale: string & !=""
}

#PrecedenceLevel: {
	level:       int & >0
	name:        string & !=""
	description: string & !=""
	rationale:   string & !=""
	// CI valida que todo id existe em axioms ou derived.
	principleIds: [string & !="", ...string & !=""]
	tieBreaker?:  string & !=""
	stageWeighting?: {
		preProductMarketFit:  string & !="" // como esse nível se comporta pré-PMF
		postProductMarketFit: string & !="" // como esse nível se comporta pós-PMF
		transitionTrigger:    string & !="" // critério objetivo que define a mudança
	}
}

#Principle: {
	id:        string & !=""
	statement: string & !=""
	rationale: string & !=""
}

#DerivedPrinciple: {
	#Principle
	// CI valida que todo id existe em axioms.
	derivedFrom: [string & !="", ...string & !=""]
}

#CostEliminated: {
	// Formato numérico ce-NN alinhado com consumidores (canvas, subdomain, stakeholder-map).
	id:     string & =~"^ce-[0-9]{2}$"
	cost:   string & !=""
	bearer: string & !=""
	// CI valida que referencia um #Mechanism.id existente.
	mechanismRef:     string & =~"^mech-[a-z][a-z0-9-]*$"
	thesisConnection: string & !=""
	rationale:        string & !=""
}

#CapabilityCreated: {
	// Formato numérico cc-NN alinhado com consumidores (canvas, subdomain).
	id:         string & =~"^cc-[0-9]{2}$"
	capability: string & !=""
	// CI valida que referencia um #Mechanism.id existente, quando aplicável.
	// Pode referenciar efeitos emergentes (ex: efeito de rede) que não são
	// mecanismos declarados — nesses casos, thesisConnection é a rastreabilidade primária.
	enabledBy:        string & !=""
	thesisConnection: string & !=""
	rationale:        string & !=""
}

#FlywheelStep: {
	id:    string & !=""
	order: int & >0
	action: string & !=""
	// CI valida que referencia um id existente em steps.
	// CI valida consistência: order e grafo de feedsInto devem ser coerentes.
	feedsInto: string & !=""
	rationale: string & !=""
}

#ScopeEntry: {
	description: string & !=""
	rationale:   string & !=""
}

#NegativeIdentity: {
	id:          string & !=""
	notThis:     string & !=""
	whyConfused: string & !=""
	distinction: string & !=""
	rationale:   string & !=""
}

#AntiThesis: {
	id:         string & !=""
	assumption: string & !=""
	ifWrong:    string & !=""
	rationale:  string & !=""
}
