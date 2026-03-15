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
			canonicalPathPattern: "^domain/domain-definition\\.cue$"
			fileNamePattern:      "^domain-definition\\.cue$"
			description:          "Definição do domínio: tese central, mecanismos, princípios fundadores, proposta de valor, flywheel, escopo."
			rationale:            "Artefato singleton na raiz do domínio. Nome fixo porque é unique no sistema."
		}
	}
}

// ── Tipos de suporte ──
// Definidos no nível do package para reusabilidade entre schemas.
// TODO: extrair para artifact_schemas_common quando design-principles.cue
// precisar de #Principle.

#Mechanism: {
	id:               string & !=""
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
	id: string & !=""
	cost:   string & !=""
	bearer: string & !=""
	// CI valida que referencia um #Mechanism.id existente.
	mechanismRef:     string & !=""
	thesisConnection: string & !=""
	rationale:        string & !=""
}

#CapabilityCreated: {
	id:         string & !=""
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
