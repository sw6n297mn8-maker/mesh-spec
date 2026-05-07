package artifact_schemas

// economic-mechanism-model.cue — Layer 1 schema declarando mechanisms
// que reduzem exploitability dos reality invariants (Layer -1 economic-
// assumption-model.cue) via constraint design.
//
// Distinção ontológica fundamental:
//   inv-* (Domain Invariant)   = regra que sistema enforça
//   ri-*  (Reality Invariant)  = propriedade do mundo (Layer -1)
//   imp-* (System Implication) = derivação de ri-NN
//   mech-* (Economic Mechanism)= constraint que reduz exploitability (Layer 1)
//
// Honesty by discipline (founder R5+ canonical): "O problema não é o
// sistema ter falhas. O problema é o sistema não saber onde falha."
// Schema declares mechanism failure surface obligations via tq-emm-03
// quality criterion (runner-verified Phase 0; Phase 1+ structural CUE
// pattern OR CI gate enforces 'at least one of falsePositiveRisks /
// underspecifications / residualRisks non-empty' by construction).
//
// Mechanism design constraint canonical (founder R4++): "v1 sistema
// observa fraude; v2 sistema desincentiva fraude". Mechanisms NÃO
// eliminate exploits — REDUCE exploitability. Sistema deixa de ser
// permissivo e passa a ser economicamente restritivo.

#EconomicMechanismModel: {
	_schema: {
		location: {
			canonicalPathRegex: "^strategic/economic-model/mesh-economic-mechanisms\\.cue$"
			fileNameRegex:      "^mesh-economic-mechanisms\\.cue$"
			description:        "Layer 1 — Economic Mechanism Model: mechanisms that reduce exploitability of declared reality invariants."
			rationale: """
				Materializes mechanism design layer above Layer -1 (Economic
				Reality). Mechanisms protect against realities declared in
				#EconomicAssumptionModel; enforces system implications;
				explicitly declares failure surface (falsePositiveRisks +
				underspecifications + residualRisks) via structurally
				enforced honesty discipline (tq-emm-03 via CUE discriminated
				union).

				Distintamente de domain rules (sistema enforça invariants of
				itself) e reality invariants (sistema sobrevive apesar de):
				mecanismos REDUCE EXPLOITABILITY de reality invariants. Não
				eliminate, não solve — REDUCE. v1 sistema observa fraude;
				v2 sistema desincentiva fraude.
				"""
			cardinality: "singleton"
			allowNested: false
		}
	}

	mechanisms: [#EconomicMechanism, ...#EconomicMechanism]
	rationale: string & !=""

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-emm-01"
			description: "Mechanisms must declare at least one reality invariant they protect against"
			test:        "Each mechanisms[].protectsAgainst is non-empty + references existing ri-NN em economic-assumption-model.cue instance."
			severity:    "fail"
			rationale:   "Mechanism without protection target is purposeless; ground each mechanism in declared reality."
		}, {
			id:          "tq-emm-02"
			description: "Mechanisms must declare at least one system implication they enforce"
			test:        "Each mechanisms[].enforces is non-empty + references existing imp-NN em economic-assumption-model.cue instance."
			severity:    "fail"
			rationale:   "Mechanism without enforced implication is unmoored; trace each mechanism to declared system response."
		}, {
			id:          "tq-emm-03"
			description: "Mechanism must explicitly declare failure surface (honesty enforcement)"
			test: """
				For each mechanism:
				MUST satisfy at least one of:
				- falsePositiveRisks non-empty
				- underspecifications non-empty
				- residualRisks non-empty
				AND
				MUST cover at least one of:
				- misclassification risk (false positive / false negative)
				- model incompleteness (underspecification)
				- adversarial exploitability (residual risk)
				Failure to declare any of these is considered hidden risk → FAIL.

				Phase 0 enforcement: runner-verified per this tq-emm-03 (CUE
				disjunction approach for structural type-system enforcement
				creates ambiguous unification when multiple honesty fields
				populated simultaneously; alternative CUE patterns —
				len-sum constraint OR CI gate — Phase 1+).
				Phase 1+ enforcement: structural CUE pattern OR CI script
				asserting 'len(falsePositiveRisks) + len(underspecifications)
				+ len(residualRisks) >= 1' por mechanism. Plus semantic
				coverage verification of 3 categorias (NLU on field content).
				"""
			severity: "fail"
			rationale: """
				Mechanism validity is not defined by correctness alone, but by
				explicit declaration of its failure surface. Hidden risk is
				more dangerous than known risk. 'Complexidade não é proxy de
				risco; cobertura de falha é' (founder R5+ canonical).
				"""
		}, {
			id:          "tq-emm-04"
			description: "ID prefix discipline (distinct from realities/invariants/implications)"
			test:        "mechanisms[].id uses mech-NN; residualRisks[].id uses rr-NN. Distinct from inv-* (domain) / ri-* (reality) / imp-* (implications) prefixes."
			severity:    "fail"
			rationale:   "Prefix preserves cross-artifact ref disambiguation: mech-* identifies mechanisms (Layer 1) distinct from realities + implications + domain rules."
		}]
		rationale: "Quality criteria garantem schema funciona como Layer 1 mechanism design honesty layer — mecanismos grounded em realidade (tq-emm-01), implications declared (tq-emm-02), failure surface declared per discipline (tq-emm-03 runner-verified Phase 0; structural CUE pattern OR CI gate Phase 1+), prefix discipline preserved (tq-emm-04)."
	}
}

// #EconomicMechanism — base type for mechanism instances. Honesty
// discipline (tq-emm-03) requires at least one of (falsePositiveRisks /
// underspecifications / residualRisks) non-empty. Structural enforcement
// via CUE discriminated union deferred (CUE disjunction creates
// ambiguous unification when multiple honesty fields populated
// simultaneously); Phase 0 enforcement is runner-verified per tq-emm-03;
// Phase 1+ CI enforcement OR alternative CUE pattern (e.g., len-sum
// constraint) materializes structural discipline.
//
// Future NIM refinement (per founder R5+ note): 3 honesty categorias
// são semantically distinct (NÃO equivalentes):
//   falsePositiveRisks  → error of CLASSIFICATION (false positive/negative)
//   underspecifications → error of MODEL (incomplete formalization)
//   residualRisks       → error INEVITABLE (adversarial exploitability)
// Phase 0 trata como equivalentes para honesty enforcement; semantic
// distinction structural type Phase 1+ NIM territory.
#EconomicMechanism: {
	id:              string & =~"^mech-[0-9]{2}$"
	name:            string & !=""
	protectsAgainst: [#RealityInvariantRef, ...#RealityInvariantRef]
	enforces:        [#SystemImplicationRef, ...#SystemImplicationRef]
	rule:            string & !=""
	formalization?:  string & !=""
	interactionDependencies?: [...#EconomicMechanismRef]
	falsePositiveRisks?: [string & !="", ...string & !=""]
	underspecifications?: [string & !="", ...string & !=""]
	residualRisks?: [#ResidualRisk, ...#ResidualRisk]
	rationale: string & !=""
}

#RealityInvariantRef:  string & =~"^ri-[0-9]{2}$"
#SystemImplicationRef: string & =~"^imp-[0-9]{2}$"
#EconomicMechanismRef:         string & =~"^mech-[0-9]{2}$"

#ResidualRisk: {
	id:          string & =~"^rr-[0-9]{2}$"
	description: string & !=""
	severity:    "low" | "medium" | "high"
	rationale:   string & !=""
}
