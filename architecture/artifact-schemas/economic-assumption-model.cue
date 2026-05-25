package artifact_schemas

// economic-assumption-model.cue — Layer -1 schema declarando
// invariâncias do ambiente econômico que constrange todos os BCs.
//
// Distinção ontológica fundamental (per ADR-082):
//   inv-* (Domain Invariant)   = regra que sistema enforça
//   ri-*  (Reality Invariant)  = propriedade do mundo onde sistema sobrevive
//
// Reality invariants NÃO são tensionáveis por decisão arquitetural;
// representam realidades empíricas do ambiente econômico adversarial.
// Sistema deve operar APESAR delas, NÃO assumir ausência delas.
//
// Disciplina canonical (founder R4+ alert): omitir ri-* crítico =
// falha estrutural silenciosa (sistema implicitamente assume que não
// existe). Adicionar ri-* errado = ruído arquitetural. Cada ri-NN
// MUST representar realidade empírica não-tensionável do ambiente.

#EconomicAssumptionModel: {
	_schema: {
		location: {
			canonicalPathRegex: "^strategic/economic-model/mesh-economic-assumptions\\.cue$"
			fileNameRegex:      "^mesh-economic-assumptions\\.cue$"
			description:        "Economic reality layer (Layer -1) — invariants of environment that constrain all BCs."
			rationale: """
				Defines truths about the economic environment that are NOT design decisions.
				Upstream of all BCs. Must be assumed by all downstream artifacts.
				Distintamente de #Invariant (domain rule, sistema enforça): #RealityInvariant
				é propriedade do mundo (sistema deve sobreviver apesar de).
				"""
			cardinality: "singleton"
			allowNested: false
		}
	}

	realityInvariants: [#RealityInvariant, ...#RealityInvariant]
	adversarialCapabilities: [#AdversarialCapability, ...#AdversarialCapability]
	systemImplications: [#SystemImplication, ...#SystemImplication]

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-eam-01"
			description: "Reality invariants stated as absolute truths, not probabilistic possibilities"
			test:        "Each realityInvariants[].statement uses declarative absolute language; no 'may/can/could/might/possibly/approaching/tends/likely' as primary verb. 'Can' allowed em adversarialCapabilities (capability statements são intrinsically modal)."
			severity:    "fail"
			rationale:   "Prevents modeling uncertainty instead of reality. 'Cost approaching zero' (gradient/probabilistic) ≠ 'Cost does not constitute reliable limiting factor' (absolute property)."
		}, {
			id:          "tq-eam-02"
			description: "Reality invariants must NOT encode mechanism, enforcement, or solution"
			test:        "Each realityInvariants[].statement describes WHAT IS in environment, not HOW system responds. Solutions live in implications + downstream BCs (mechanism design responsibility — economic-mechanism-model.cue future)."
			severity:    "fail"
			rationale:   "Separates reality (what exists) from design response (how system handles)."
		}, {
			id:          "tq-eam-03"
			description: "Each system implication traces to ≥1 reality invariant or capability"
			test:        "Each systemImplications[].derivedFrom non-empty + references existing ri-NN OR cap-adv-NN."
			severity:    "fail"
			rationale:   "Ensures implications grounded in declared reality."
		}, {
			id:          "tq-eam-04"
			description: "Reality invariants distinct from domain invariants (prefix discipline)"
			test:        "realityInvariants[].id uses ri-NN (NOT inv-NN domain); capabilities use cap-adv-NN; implications use imp-NN. Prefix prevents semantic collision: inv-* (system enforces) vs ri-* (system survives despite of)."
			severity:    "fail"
			rationale:   "inv-* refs em agent-spec apontam para enforceable domain invariants; ri-* refs apontam para environment properties (não enforceable, must be designed for)."
		}]
		rationale: "Quality criteria garantem que o artifact funciona como Layer -1 honesty arquitetural — declarando realidade adversarial, NÃO design decisions. Disciplina prefix (tq-eam-04) preserva ontologia distinct entre o que sistema enforça (inv-*) vs sobre o que sistema deve sobreviver (ri-*)."
	}
}

#RealityInvariant: {
	id:        string & =~"^ri-[0-9]{2}$"
	statement: string & !=""
	rationale: string & !=""
}

#AdversarialCapability: {
	id:        string & =~"^cap-adv-[0-9]{2}$"
	statement: string & !=""
	rationale: string & !=""
}

#SystemImplication: {
	id: string & =~"^imp-[0-9]{2}$"
	statement: string & !=""
	derivedFrom: [string, ...string]
	rationale: string & !=""
}
