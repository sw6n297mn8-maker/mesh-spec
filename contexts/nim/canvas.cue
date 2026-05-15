package nim

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Network Intelligence & Mechanism Design.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// =============================================================================
// IDENTITY CANONICAL
// =============================================================================
//
// NIM é mechanism integrity guardian over epistemic substrate.
// Preserva integridade dos mecanismos algorítmicos (scoring,
// matching, ranking, incentives, penalties, governed-suggestions)
// que governam comportamento de rede sob pressão de gaming,
// manipulação, pseudo-objectivity collapse, e covert policy drift.
//
// MECHANISMS ARE GOVERNANCE ARTIFACTS — NOT OPTIMIZATION ARTIFACTS.
//
// NIM NÃO é: scoring service, recommendation API, ML platform,
// learning system genérico, fraud detection layer, A/B testing
// platform, CRM analytics, engagement intelligence engine, truth
// engine, autonomous policy optimizer.
//
// É: constitutional governance layer onde algorithmic mechanisms
// materializam-se com provenance + audit chain integrity + explicit
// governance over mutation paths — paralelo arquitetural ao FCE
// (constitutional infrastructure for economic convergence integrity)
// e NTF (constitutional infrastructure for admissibility integrity
// of communication guarantees).
//
// =============================================================================
// FAMILY MESH PATTERN + META-CONSTITUTIONAL EXTENSION
// =============================================================================
//
// FCE: semantic integrity of economic convergence.
// NTF: admissibility integrity of communication guarantees.
// NIM: mechanism integrity over epistemic substrate.
//
// NIM introduz padrão Family Mesh qualitativamente novo: "Governance
// over governance-producing mechanisms". Protected object NÃO é
// fluxo OR contrato OR admissibilidade OR operação — é autoridade
// epistemológica emergente que outros BCs eventualmente consomem
// como substrate de suas próprias decisões. NIM emerge como primeiro
// guardian META-constitucional da Mesh.
//
// =============================================================================
// BIDIRECTIONAL EPISTEMIC FEEDBACK TOPOLOGY
// =============================================================================
//
// NIM é única camada com dependência bidirecional por design —
// consome sinais de todos BCs operacionais e produz mechanism
// artifacts consumidos cross-BC. Esta topology introduz 2 unique
// drift risks structural:
//
// - REFLEXIVE GOVERNANCE RISK: mechanism altera ambiente que produz
//   sinais que alimentam o próprio mecanismo (recursive reinforcement).
// - EPISTEMIC MONOCULTURE RISK: todos BCs convergem para 'o score
//   já decidiu' como substituto epistemológico universal — mata
//   contextual review + bounded authority + provenance separation
//   + uncertainty preservation downstream.
//
// =============================================================================
// 9 DRIFT CLASSES CANONICAL (em 3 families)
// =============================================================================
//
// CONSTITUTIONAL DRIFT VECTORS (top severity):
//  1. Mechanism gaming — adversarial actors manipulating scoring
//     algorithms (Goodhart's law operationalized)
//  2. Pseudo-objectivity collapse — algorithmic outputs treated as
//     objective truth ('score says X, therefore X')
//  3. Implicit policy creep — mechanism mutations becoming covert
//     policy changes sem governance review
//  4. Objective-function drift — optimization target slowly diverges
//     from declared constitutional objective (quality→engagement,
//     trustworthiness→popularity)
//
// RECURSIVE-SYSTEM DRIFT VECTORS:
//  5. Reputation drift — historical reputation diverging from current
//     performance (stale signals dominating)
//  6. Feedback loop drift — system reinforcing its own outputs
//     (materializes reflexive governance risk)
//  7. Authority delegation drift — consumers consumindo scores como
//     decision substitute ('just follow the score'; materializes
//     epistemic monoculture risk)
//  8. Provenance erosion — signals losing source/time/epistemic-class
//     metadata over time
//
// OPTIMIZATION GRAVITY DRIFT:
//  9. Engagement gravity — popularity-as-quality optimization
//
// =============================================================================
// 15 CONSTITUTIONAL CLAUSES (C1-C15)
// =============================================================================
//
// C1  — Mechanism authority sovereignty
// C2  — Mechanisms are governance artifacts, NOT optimization artifacts
// C3  — Algorithmic-output-is-signal-not-decision
// C4  — Provenance preservation (source + time + epistemic-class)
// C5  — Reputation is emergent NOT assigned
// C6  — No-implicit-policy / mechanism mutation ADR-bound
// C7  — Refuse rather than degrade (mechanism integrity refusal)
// C8  — Anti-gaming structural defense
// C9  — NOT autonomous policy optimizer
// C10 — Bidirectional epistemic feedback topology — explicit identity
// C11 — Anti-reflexive-governance (recursive reinforcement defended)
// C12 — Anti-epistemic-monoculture (substrate diversity defended)
// C13 — Anti-objective-function-drift
// C14 — No-universal-score-authority
// C15 — Mechanism interpretability preservation
//
// =============================================================================
// 6 CANONICAL MECHANISM TYPES + EPISTEMIC SUBSTRATE
// =============================================================================
//
// Mechanism types:
//  - Scoring         (composite score from signals; e.g., IQF, TCO)
//  - Matching        (algorithmic entity pairing)
//  - Ranking         (ordered list per relevance/quality)
//  - Incentive       (reward structure recipe)
//  - Penalty         (sanction structure recipe)
//  - GovernedSuggestion (bounded non-personalized governance suggestion)
//
// Epistemic substrate:
//  - Tier 1   : Signal Substrate (append-only)
//  - Tier 1.Q : Exogenous Signal Quarantine
//  - Tier 2   : Mechanism Artifact Substrate (outputs + versions +
//               lineage + authority + validity envelope)
//  - Gate     : Mechanism Execution Gate (constitutional center)
//  - Matrix   : Mechanism Integrity Matrix (5 violation classes A-E
//               including Class E feedback-loop violation)
//
// 8 mechanism dimensions: input substrate + output type + authority
// surface + interpretability class + mutation governance + temporal
// validity + replay semantics + adversarial-resistance-class.
//
// =============================================================================
// CC1-CC6 COMMUNICATION CLAUSES
// =============================================================================
//
// CC1 — Mechanism integrity facts only (no behavioral inference)
// CC2 — Refusal canonical first-class (gate refusals = success outcomes)
// CC3 — Provenance + authority boundary preserved per output
// CC4 — Mechanism mutation lifecycle explicit (ADR-bound)
// CC5 — Adversarial + feedback markers explicit (resistance class +
//       loop marker visible per execution)
// CC6 — Recursive Epistemological Governance Explicitness (loop
//       markers + lineage preservation + authority boundaries; hidden
//       recursive optimization is forbidden)
//
// =============================================================================
// 5-TUPLE AUTHORITY DISCIPLINE CANONICAL
// =============================================================================
//
// Every capability producing mechanism output for consumer declares
// explicit 5-tuple:
//   - mechanismType
//   - consumerBCs
//   - authoritySurface
//   - forbiddenInterpretations
//   - escapePaths
//
// Textual canonical em Phase 1 canvas; structural materialization
// deferred a Phase 3/4 (domain-model commands/services + agent-spec
// actions); future ADR formalization quando ≥2 BCs require pattern.
//
// =============================================================================
// AUTHORING ORDER (per manualAuthoringProtocol adr-057)
// =============================================================================
//
// Phase 1.0 — charter constitutional (Family Mesh 3rd + meta-constitutional)
// Phase 1.1 — identity + classification + drift classes baseline + C1-C13
// Phase 1.2 — 6 mechanism types + Tier 1/1.Q/2 substrate + 8 dimensions
//             + Integrity Matrix 5 violation classes
// Phase 1.2.B — Mechanism Authority Boundary Review (5-tuple matrix
//               per Mechanism Type × Consumer BC; 7 universal forbidden
//               interpretations; 6 escape paths)
// Phase 1.3 — 13 capabilities derived (+ cap-adversarial-resistance-
//             evaluation)
// Phase 1.4 — 11 businessDecisions + 6 stakeholders + 4 cost refs
// Phase 1.5 — 21 inbound + 16 outbound communication + CC1-CC6
//             + cap-mechanism-governance-mutation-control (cap #14)
// Phase 1.5.B — recursive governance refinement (5-category discipline
//               + loop marker structure + mutation authority topology
//               + cross-BC leakage patterns + lineage propagation +
//               recursive audit semantics)
// Phase 1.6 — 7 incentive misalignments + 3-tier governanceScope
//             (Tier 3 = constitutional integrity containment, NÃO
//             operational incident)
// Phase 1.7 — 6 assumptions + 11 openQuestions + 10 verificationMetrics
//             + outer rationale 15 sections
// Phase 1.8 — SRR srr-nim-canvas

canvas: artifact_schemas.#Canvas & {
	code: "nim"
	name: "Network Intelligence & Mechanism Design"

	purpose: """
		Preservar mechanism integrity over epistemic substrate sob
		pressão de gaming, manipulação, pseudo-objectivity collapse,
		e covert policy drift. NIM é constitutional governance layer
		onde algorithmic mechanisms (scoring, matching, ranking,
		incentives, penalties, governed-suggestions) materializam-se
		com provenance + audit chain integrity + explicit governance
		over mutation paths.

		NIM consome signals de todos BCs operacionais (NPM, DLV, FCE,
		NTF, P2P, CTR, INV, CMT, BKR, BDG, REW, SSC, IDC) e produz
		canonical mechanism outputs consumidos por NPM (eligibility
		signals), REW (risk inputs), SSC (sourcing rankings), NGR
		(growth insights), P2P (payment incentive structures), CTR
		(contract incentive/penalty structures), DRC (dispute penalty
		inputs), e adicionalmente FCE/DLV em uso limitado (risk/
		behavioral signal para convergence analysis e performance
		evaluation respectivamente). Esta é bidirectional epistemic
		feedback topology — única camada do sistema com essa
		característica arquitetural por design.

		NIM NÃO entrega decisões. NIM preserva mechanism authority
		integrity + epistemic substrate provenance under recursive
		network influence. Anti-goals canonicalmente declarados: NÃO
		é scoring service, NÃO é recommendation API, NÃO é ML
		platform, NÃO é learning system genérico, NÃO é fraud
		detection layer, NÃO é A/B testing platform, NÃO é CRM
		analytics, NÃO é engagement intelligence engine, NÃO é truth
		engine, NÃO é autonomous policy optimizer.

		É: constitutional governance layer paralelo arquitetural ao
		FCE (semantic integrity of economic convergence) e NTF
		(admissibility integrity of communication guarantees). NIM
		emerge como primeiro guardian META-constitucional da Mesh —
		protected object é autoridade epistemológica emergente que
		outros BCs eventualmente consomem como substrate de suas
		próprias decisões. Mechanisms são governance artifacts,
		NOT optimization artifacts (canonical clause foundation).

		Boundary canônico: bidirectional epistemic feedback topology
		introduz 2 unique drift risks structural — (a) reflexive
		governance risk: mechanism altera ambiente que produz sinais
		que alimentam o próprio mecanismo (recursive reinforcement);
		(b) epistemic monoculture risk: todos BCs convergem para 'o
		score já decidiu' como substituto epistemológico universal,
		matando contextual review + bounded authority + provenance
		separation + uncertainty preservation downstream.
		"""

	ubiquitousLanguageRef: "contexts/nim/glossary.cue"

	classification: {
		subdomainType:    "core"
		businessRole:     "compliance-enforcer"
		wardleyEvolution: "genesis"
		rationale: """
			Core subdomain per WI-045 + subdomain definition: corpus
			proprietário de dados operacionais é parte do moat de
			IA; NIM é flywheel de inteligência cumulativa não
			replicável sem o mesmo volume de transações.

			BusinessRole 'compliance-enforcer' (paralelo FCE precedent
			canonical) captura posture constitutional: NIM enforces
			mechanism integrity via algorithmic governance —
			estructuralmente similar à FCE compliance-enforcer
			posture (constitutional integrity guardian governing via
			contract-level enforcement) mas via mechanism-level
			governance. Mechanism design é governance materializing
			as algorithms. Anti-pattern explicit: businessRole NÃO é
			'engagement-creator' (defended via drift class #6 +
			anti-goal engagement intelligence engine) nem 'operational-
			enabler' (subestima constitutional posture).

			Wardley genesis canonical: domínio experimental de
			mechanism design; cada novo mechanism type expands a
			ontology e abre nova authority surface. Evolution
			velocity é alta mas governed — mechanism mutations são
			explicit ADR-bound (per drift class #3 implicit policy
			creep top-3 + drift class #9 objective-function drift).
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: "NIM é por construção vertical-agnostic — mechanism design + epistemic substrate operam independente de vertical de cadeia produtiva. Substitutability preservation cross-vertical canonical (paralelo FCE + NTF universal applicability)."
	}

	domainRoles: {
		primary: "specification"
		secondary: ["analysis"]
		rationale: """
			Primary 'specification': NIM produces canonical mechanism
			specifications (scoring formulae, matching algorithms,
			ranking rules, incentive structures, penalty taxonomies,
			governed-suggestion templates) consumed downstream —
			mechanism = governance artifact canonical framing implies
			specification authority over operational artifacts.

			Secondary 'analysis': NIM analyzes signals to derive
			mechanism inputs (provenance classification + signal
			weighting + temporal aggregation). Analysis é secundário
			a specification — analysis serves mechanism design, NÃO
			opera autonomamente como analytics engine.

			Specification authority precedes analytical sophistication
			(per Phase 1.1 founder ajuste canonical clause): o erro
			mais perigoso seria inverter (analysis primary +
			specification secondary), fazendo NIM gravitacionalmente
			virar intelligence layer / analytics engine / inference
			platform. O núcleo real é mechanism specification
			authority; analysis existe apenas para alimentar
			weighting + provenance + calibration + mechanism evolution.

			Rejected alternative: primary 'gateway' (paralelo NTF
			admissibility gate) considered mas rejected porque NIM
			NÃO gates pass-through traffic — produz canonical
			artifacts (mechanism specs) que downstream consumes.
			Gateway framing implicaria NIM control flow per request,
			inverso do bidirectional epistemic feedback topology.
			"""
	}

	capabilities: {
		operational: [{
			description: "Signal substrate ingestion — Tier 1 append-only canonical para signals de 13 BCs operacionais (NPM, DLV, FCE, NTF, P2P, CTR, INV, CMT, BKR, BDG, REW, SSC, IDC) com provenance preservation (source + observation-time + epistemic-class). 5-tuple: N/A substrate-level + ALL operational BCs + Tier 1 append-only authority + forbidden signal mutation post-emission + escape signal corruption→quarantine OR NIM operator escalation."
			rationale:   "Per Phase 1.3 cap-signal-substrate-ingestion. Tier 1 substrate hygiene canonical per 7 invariants (Phase 1.2 Section B). Source diversity preserved (anti-monoculture structural C12)."
		}, {
			description: "Exogenous signal quarantine — Tier 1.Q layer entre exogenous sources (ext-economic-indicator | ext-regulatory-signal | ext-market-intelligence | ext-counterparty-public) e Tier 1 canonical promotion. Provenance + freshness + source reliability check obrigatórios. 5-tuple: N/A substrate-level + 4 exogenous categories + Tier 1.Q pre-validation authority + forbidden canonical-promotion sem quarantine clearance + escape quarantine fail→signal blocked + audit event."
			rationale:   "Per Phase 1.3 cap-exogenous-signal-quarantine + Phase 1.2 ajuste #4. Asymmetric epistemic ontology — exogenous signals carry higher uncertainty; quarantine é structural defense, NÃO operational filter."
		}, {
			description: "Mechanism artifact substrate maintenance — Tier 2 lifecycle canonical (outputs + versions + lineage + authority + validity envelope). 5-tuple: ALL mechanism types + ALL declared consumers + Tier 2 versioning/lineage/validity authority + forbidden artifact mutation post-emission OR lineage truncation + escape provenance degradation→artifact blocked per escape path #6."
			rationale:   "Per Phase 1.3 cap-mechanism-artifact-substrate-maintenance + Phase 1.2 ajuste #3. Tier 2 carries outputs + versions + lineage + authority + validity envelope; immutability canonical."
		}, {
			description: "Mechanism Execution Gate — constitutional center entre Tier 1/Tier 1.Q substrate e Tier 2 mechanism artifact output. 8-dimension declaration validation + Mechanism Integrity Matrix application (Class A/B/C/D/E violation detection). 5-tuple: ALL mechanism types + gates output a ALL declared consumers + Tier 1→Tier 2 promotion authority + forbidden Tier 1 signal auto-promotion sem gate execution OR opaque-blocked interpretability OR mechanism execution sem 5-tuple declared + escape Class A/B/C/D/E violation→refused + audit event."
			rationale:   "Per Phase 1.3 cap-mechanism-execution-gate (constitutional center; paralelo NTF admissibility gate C8). Materializa C1 mechanism authority sovereignty + C14 no-universal-score + C15 interpretability preservation. Every Tier 2 output passa por este gate."
		}, {
			description: "Scoring mechanism execution — composite scores derived from signal weighting (e.g., IQF supplier quality, TCO total cost composite). 5-tuple: Scoring + [NPM, REW, SSC, NGR, FCE-limited, DLV-limited] + composite score como decision INPUT per consumer canonical + forbidden score AS verdict (eligibility/risk/sourcing/growth/convergence/delivery) OR universal substrate OR opaque inference OR truth claim collapse + escape insufficient signal escape (path #1) OR provenance degradation escape (path #6)."
			rationale:   "Per Phase 1.3 cap-scoring-mechanism-execution. Scoring authority bounded per consumer per Phase 1.2.B matrix. FCE/DLV limited consumers per Phase 1.2.B founder ajuste — FCE consome scoring para convergence contextual analysis (forbidden: alterar settlement/convergence outcome); DLV consome para operational evaluation (forbidden: substitute evidence of real delivery)."
		}, {
			description: "Matching mechanism execution — algorithmic pair proposal. 5-tuple: Matching + [SSC, NPM] + pair proposal como sourcing/qualification INPUT + forbidden match AS sourcing pair OR qualification verdict OR bypass consumer canonical authority + escape authority overflow escape (path #4) OR conflicting mechanism escape (path #2)."
			rationale:   "Per Phase 1.3 cap-matching-mechanism-execution. Pair suggestion bounded; consumer reviews + applies own canonical authority per Phase 1.2.B matrix."
		}, {
			description: "Ranking mechanism execution — ordered list per relevance/quality. 5-tuple: Ranking + [SSC, NGR, NPM] + ordered list como priority INPUT + forbidden ranking AS sourcing priority OR growth strategy OR promotion verdict OR 'top N' auto-shortlist + escape authority overflow escape (path #4)."
			rationale:   "Per Phase 1.3 cap-ranking-mechanism-execution. Ordering bounded; sequence é signal NOT decision per Phase 1.2.B matrix."
		}, {
			description: "Incentive mechanism execution — reward structure recipe (volume discounts, loyalty terms, status promotion structures). 5-tuple: Incentive + [P2P, CTR, NPM] + structure recipe como contract/payment/promotion INPUT + forbidden recipe AS payment OR contract OR promotion authority OR auto-application sem consumer canonical pathway + escape insufficient signal escape (path #1)."
			rationale:   "Per Phase 1.3 cap-incentive-mechanism-execution. Structure recipe bounded; consumer applies via own canonical contract/payment authority per Phase 1.2.B matrix."
		}, {
			description: "Penalty mechanism execution — sanction structure recipe. 5-tuple: Penalty + [REW, NPM, CTR, DRC] + sanction recipe como risk/demotion/contract/dispute INPUT + forbidden recipe AS risk pricing OR demotion OR contract penalty OR dispute resolution authority + escape authority overflow escape (path #4)."
			rationale:   "Per Phase 1.3 cap-penalty-mechanism-execution. Sanction structure bounded; consumer applies via own canonical authority (esp. DRC dispute resolution remains DRC canonical) per Phase 1.2.B matrix."
		}, {
			description: "GovernedSuggestion execution — bounded non-personalized governance suggestion (evaluation criteria template, sourcing framework). 5-tuple: GovernedSuggestion + [SSC, NGR, NPM] + non-personalized governance suggestion como input + forbidden suggestion AS decision template OR personalized suggestion per actor (engagement gravity defended) OR recommendation engine framing + escape authority overflow escape (path #4)."
			rationale:   "Per Phase 1.3 cap-governed-suggestion-execution. Naming 'GovernedSuggestion' canonical per Phase 1.2 ajuste #2 — distinguishes governance suggestion from engagement recommendation gravity vector. NÃO personalized canonical per Phase 1.1 founder direction explicit."
		}, {
			description: "Mechanism authority boundary enforcement — 5-tuple compliance validation per dispatch + 7 universal forbidden interpretation detection. 5-tuple: ALL mechanism types + validates per consumer × mechanism pair + 5-tuple compliance authority + forbidden consumer interpretation outside declared 5-tuple boundary OR mechanism authority surface extension via consumer self-authorization + escape boundary violation detected→audit event + escalation to NIM operator + consumer notification."
			rationale:   "Per Phase 1.3 cap-mechanism-authority-boundary-enforcement. Materializa Phase 1.2.B authority matrix em runtime. Constitutional anchor C14 + C15."
		}, {
			description: "Feedback loop detection — monitors consumer × mechanism × input substrate intersection para recursive reinforcement patterns. 5-tuple: ALL mechanism types + monitors all consumer-substrate intersections + loop marker validation authority + forbidden mechanism consumption sem explicit loop marker quando consumer detected upstream do mechanism input substrate + escape feedback loop escape (path #5) — explicit loop marker + bounded review."
			rationale:   "Per Phase 1.3 cap-feedback-loop-detection. Materializa Violation Class E (Phase 1.2 ajuste #5) + reflexive governance risk defense (Phase 1.0 ajuste). Recursive reinforcement detection structural."
		}, {
			description: "Adversarial resistance evaluation — mechanism stress review + gaming pattern detection + anti-Goodhart analysis + mechanism exploit simulation + adversarial pressure classification + resistance-class validation. 5-tuple: ALL mechanism types + internal substrate (mechanism design surface) + adversarial-resistance-class assessment authority + forbidden adaptive silent retuning OR opaque anti-gaming heuristics OR hidden weight mutation + escape governance freeze + architectural review."
			rationale:   "Per Phase 1.3 cap-adversarial-resistance-evaluation (NEW Phase 1.3 ajuste). Drift class #1 mechanism gaming surface explícito + C8 anti-gaming structural defense. Adversarial pressure tratada como first-class governance concern, NÃO operational tuning detail. Pair canonical com cap-mechanism-governance-mutation-control = 2 antídotos centrais contra (a) exploitation por adversary + (b) virar política sem admitir."
		}, {
			description: "Mechanism governance mutation control — explicit ADR-bound mechanism mutation paths + autonomous mutation forbidden + objective-function drift detection + implicit policy creep detection + founder-only mutation classes + observation cycles canonical (90-day default; 180-day critical para replay-sensitive + recursive-feedback + cross-BC-authority + adversarial-resistance-critical domains). 5-tuple: ALL mechanism types + internal substrate + platform operators + audit/observability + mechanism mutation gate authority + forbidden autonomous mutation OR learning-driven mutation sem governance OR covert policy mutation OR metric-substitution mutation OR operational-convenience mutation + escape mutation refused→governance review L3/L4 + ADR consideration + ntf-forensic-integrity-reviewer-equivalent forensic pathway if integrity threat detected."
			rationale:   "Per Phase 1.3 cap #14 (Phase 1.5 emergence). 4 FORBIDDEN canonical mutations: adversarial-resistance-class downgrade + 5-tuple field removal + interpretability class relaxation + objective-function substitution. Materializes governance mutation control como architectural antidote — capability é operational surface canonical at canvas level; envelope materializes operational metrics + thresholds + cycle automation Phase 5+. NIM mutation governance já nasce muito próximo de constitutional governance (forward observation Phase 1.7)."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	businessDecisions: [{
		id:           "bd-mechanism-integrity-over-optimization"
		decision:     "Mechanisms são governance artifacts, NÃO optimization artifacts (per Phase 1.1 founder canonical clause). Optimization-driven mechanism evolution forbidden por construção; mechanism evolution é ADR-bound governance act."
		consequences: "cap-mechanism-governance-mutation-control + C9 NOT autonomous policy optimizer + 4 FORBIDDEN mutations canonical (adversarial-resistance downgrade + 5-tuple removal + interpretability relaxation + objective-function substitution). Anti-pattern 'autonomous mechanism improvement' framing rejected estructuralmente."
		rationale:    "Sem this decision, NIM lentamente vira ML platform sob narrativa 'AI-driven optimization' — colapso ontológico do BC inteiro (engagement intelligence engine attractor). C2 + Anti-optimization Family Mesh inheritance."
	}, {
		id:           "bd-two-tier-substrate-with-quarantine"
		decision:     "Substrate canonical two-tier (Tier 1 Signal + Tier 2 Mechanism Artifact) com Tier 1.Q quarantine layer entre exogenous signals e Tier 1 canonical promotion. Provenance + freshness + source reliability check obrigatórios."
		consequences: "cap-exogenous-signal-quarantine canonical capability. Exogenous signals NUNCA enter Tier 1 directly; devem cruzar quarantine. Asymmetric epistemic ontology — internal vs exogenous signals tratados distintamente."
		rationale:    "C4 + Phase 1.2 ajuste #4. Sem quarantine, exogenous signal contamination cross-substrate canonical (regulatory authority misclassification, market intelligence vendor methodology shifts, etc.). Quarantine é structural defense, NÃO operational filter."
	}, {
		id:           "bd-bounded-authority-via-5-tuple"
		decision:     "Cada mechanism output carries explicit 5-tuple authority boundary (mechanism type + consumer BC + authority surface + forbidden interpretation + escape path). Generic mechanism authority forbidden por construção. Authority boundary precede mechanism execution canonical."
		consequences: "5-tuple discipline textual em capabilities Phase 1 canvas; structural materialization Phase 3/4 (domain-model commands/services + agent-spec actions). 7 universal forbidden interpretations cross-mechanism + 6 escape paths canonical taxonomy."
		rationale:    "C14 + Phase 1.2.B matrix. Phase 1.4 founder ajuste #2 — authority boundary PRECEDES execution canonical (bd order: this BEFORE mechanism execution gate). Sem 5-tuple discipline, generic capability tipo 'GenerateScore' vira universal authority — drift #7 + epistemic monoculture attractor."
	}, {
		id:           "bd-mechanism-execution-gate-as-constitutional-center"
		decision:     "cap-mechanism-execution-gate é constitutional center — Tier 1 → Tier 2 promotion + 8-dimension validation + Mechanism Integrity Matrix application (Class A/B/C/D/E violation detection). Auto-promotion forbidden; opaque-blocked interpretability forbidden."
		consequences: "Constitutional center canonical (paralelo NTF admissibility gate C8). Every Tier 2 output passa por este gate. 5 violation classes canonical (A structural + B authority + C interpretability + D governance + E feedback-loop)."
		rationale:    "C1 mechanism authority sovereignty + Phase 1.2 Section D Mechanism Integrity Matrix. Gate é constitutional center — sem este, Tier 1 silent promotion vira ontological collapse."
	}, {
		id:           "bd-no-universal-substrate-substitution"
		decision:     "No single mechanism output may become universal authority substrate across BCs. Each consumer × mechanism pair declared bounded; aggregation cross-BC requires ADR. Pre-hegemonic drift defended estructuralmente."
		consequences: "C14 enforcement via cap-mechanism-authority-boundary-enforcement runtime detection + 4ª FORBIDDEN mutation row (provider-claim-as-fact-style universal substrate impossible canonical) + Phase 1.5.B cross-BC authority leakage Pattern #2 CRITICAL+ existential vector defense."
		rationale:    "C14 + Phase 1.2.B matrix + Phase 1.5.B Pattern #2 (authority chain reinforcement — score→legitimacy→policy→invisible authority). Sem this decision, NIM scores convergem inevitably para universal authority — drift class #7 + epistemic monoculture risk."
	}, {
		id:           "bd-interpretability-as-structural-property"
		decision:     "Mechanism interpretability é structural property (8-dimension dimension #4: inspectable-full / inspectable-lineage / opaque-blocked); opaque-blocked NÃO permitido em canonical authority surface. Inspectable lineage minimum canonical."
		consequences: "C15 enforcement via Mechanism Execution Gate (interpretability dimension validation). Mechanism artifacts NÃO podem ser opaque-blocked em canonical authority surface — escapes para governance review. Audit chain inviolability + court-grade reconstruction (paralelo NTF tc-regulatory-evidentiary)."
		rationale:    "C15 + Phase 1.2 dimension #4. Opaque mechanism outputs lead to invisible governance + accountability erosion. Interpretability é first-class structural property, NÃO operational concern."
	}, {
		id:           "bd-asymmetric-exogenous-ontology"
		decision:     "Exogenous signals carry distinct epistemic class + higher uncertainty weighting; quarantine clearance via Tier 1.Q obrigatório antes de Tier 1 canonical promotion. NÃO uniform treatment with internal signals."
		consequences: "vo-observation-provenance distinct class para exogenous; Tier 1.Q validation rules (provenance + freshness + source reliability) canonical; asymmetric weighting downstream-visible em mechanism outputs."
		rationale:    "Paralelo NTF claim-vs-fact asymmetric ontology. Exogenous signal uniform treatment com internal signals → epistemic substrate contamination + drift #4 reputation drift acelerada. Asymmetry preserva substrate diversity (C12)."
	}, {
		id:           "bd-feedback-loop-explicit-marker"
		decision:     "Consumer × mechanism × input substrate intersection sem explicit loop marker = Violation Class E. Reflexive governance risk defended via cap-feedback-loop-detection + escape path #5 (feedback loop escape: explicit loop marker + bounded review)."
		consequences: "Loop marker structure canonical (loopId + recursionDepth + recursionPath + boundedReviewRequired + loopOriginRef + loopRiskClass per Phase 1.5.B ajuste). Consumer acknowledgment requirement; consumption sem acknowledgment = Class E violation. loopRiskClass adicional: alguns loops curtos são mais perigosos que longos (cross-BC propagation + adversarial reinforcement potential)."
		rationale:    "C11 + Phase 1.2 ajuste #5 + Phase 1.5.B ajuste #2. Recursive epistemological governance loops MUST remain explicit, inspectable, bounded (CC6 canonical clause). Hidden recursive optimization forbidden."
	}, {
		id:           "bd-adversarial-resistance-as-mechanism-property"
		decision:     "adversarial-resistance-class é structural mechanism dimension (8-dimension dimension #8: low/medium/high/critical); critical-resistance mechanisms require governance review per execution. cap-adversarial-resistance-evaluation canonical capability dedicated."
		consequences: "Adversarial-resistance-class downgrade = 1st FORBIDDEN mutation canonical. Gaming pressure tratada como drift constitucional (drift class #1 top-3 severity), NÃO operational detail. cap-adversarial-resistance-evaluation + cap-mechanism-governance-mutation-control = 2 antídotos centrais."
		rationale:    "C8 + Phase 1.2 ajuste #1. Gaming inevitabilidade structural (assumption canonical as-nim-adversarial-pressure-structural). Sem dedicated capability, gaming detection vira incidental operational concern → drift #1 catastrophic vector."
	}, {
		id:           "bd-mechanism-mutation-governance-explicit"
		decision:     "Mechanism mutations (formulae change, weighting recalibration, new mechanism type, authority surface expansion) são explicit ADR-bound governance acts. Autonomous 'learning improvement' forbidden por construção (NÃO autonomous policy optimizer per Phase 1.1 founder anti-goal). cap-mechanism-governance-mutation-control canonical capability."
		consequences: "10 mutation classification rows + 4 FORBIDDEN canonical (adversarial-resistance downgrade + 5-tuple removal + interpretability relaxation + objective-function substitution). 90-day default cycle; 180-day critical para replay-sensitive + recursive-feedback + cross-BC-authority + adversarial-resistance-critical domains (per Phase 1.5 ajuste #4)."
		rationale:    "C6 + C9 + drift #3 + #9. Phase 1.5 ajuste #5 + Phase 1.7 forward observation: NIM mutation governance já nasce muito próximo de constitutional governance — em NIM, mudar mecanismo = mudar política, mudar weighting = redistribuir poder, mudar objective function = alterar comportamento sistêmico da rede."
	}, {
		id:           "bd-truth-claim-collapse-forbidden"
		decision:     "Mechanism outputs NUNCA framed como objective truth ('score says X, therefore X'). Outputs são signals com declared epistemic class; consumers consume via canonical decision pathway. Truth engine framing forbidden por construção."
		consequences: "CC1 mechanism integrity facts only + universal forbidden interpretation #5 (truth claim collapse) + cap-mechanism-authority-boundary-enforcement detection. Anti-pattern 'sistema sabe quem é bom' explicit rejected."
		rationale:    "C3 + Phase 1.1 anti-goal NOT-truth-engine. Pseudo-objectivity collapse (drift class #2 top-3 severity) começa exactly em truth claim framing. NIM sabe sinais + provenance + weighting rules + mechanism outputs — NUNCA 'truth'."
	}]

	communication: {
		inbound: [
			// === SIGNAL INGESTION (13 BC event-consumers per 5-category discipline) ===
			{
				type:          "event-consumer"
				sourceContext: "npm"
				event:         "EligibilityDecisionEmitted"
				reaction:      "Signal ingestion category — ingest to Tier 1 with provenance preservation (source: npm, observation-time, epistemic-class: internal-decision); NÃO direct mechanism trigger."
				description:   "NPM eligibility decisions + qualification status changes + supplier onboarding signals consumed para scoring (IQF) + matching mechanism inputs. Per Phase 1.5 ajuste #1: signal-ingestion category canonical."
			},
			{
				type:          "event-consumer"
				sourceContext: "dlv"
				event:         "DeliveryConfirmed"
				reaction:      "Signal ingestion — Tier 1 com provenance preservation. Performance signals canonical para IQF scoring + ranking mechanism inputs."
				description:   "DLV delivery outcomes + evidence validations + performance observations. DLV é consumer limitado per Phase 1.2.B (recebe scoring para operational evaluation; forbidden substitute evidence de real delivery)."
			},
			{
				type:          "event-consumer"
				sourceContext: "fce"
				event:         "PaymentObligationSettled"
				reaction:      "Signal ingestion — Tier 1. Settlement outcomes consumed para TCO scoring + reputation drift detection. FCE é consumer limitado per Phase 1.2.B (recebe risk/behavioral signal para convergence contextual analysis; forbidden alter settlement/convergence outcome)."
				description:   "FCE settlement outcomes + authorization convergence observations + payment obligation failures. Bidirectional epistemic feedback topology — FCE outputs feedback into NIM signal substrate (feedback loop detection via cap-feedback-loop-detection)."
			},
			{
				type:          "event-consumer"
				sourceContext: "ntf"
				event:         "DispatchConfirmedTransportLayer"
				reaction:      "Signal ingestion — Tier 1. Admissibility + delivery facts canonical (asymmetric provenance per NTF C10 inherited)."
				description:   "NTF admissibility events + transport-layer delivery facts. Provenance class preservada per NTF observation-provenance ontology (provider-claim HIGH suspicion vs transport-observed LOW suspicion)."
			},
			{
				type:          "event-consumer"
				sourceContext: "p2p"
				event:         "PaymentExecuted"
				reaction:      "Signal ingestion — Tier 1. Payment outcome signals canonical para reliability scoring."
				description:   "P2P payment events (executed, settled, failed) consumed para TCO + IQF scoring inputs. Bidirectional: P2P consome incentive mechanism outputs back."
			},
			{
				type:          "event-consumer"
				sourceContext: "ctr"
				event:         "ContractSigned"
				reaction:      "Signal ingestion — Tier 1. Contract lifecycle signals canonical."
				description:   "CTR contract lifecycle events (signed, breached, renewed) consumed para reputation + risk inputs. Bidirectional: CTR consome incentive + penalty structures back."
			},
			{
				type:          "event-consumer"
				sourceContext: "inv"
				event:         "InvoiceApproved"
				reaction:      "Signal ingestion — Tier 1. Invoice events consumed para IQF reliability components."
				description:   "INV invoice events (approved, rejected, disputed) consumed para scoring + ranking inputs."
			},
			{
				type:          "event-consumer"
				sourceContext: "cmt"
				event:         "CommitmentCreated"
				reaction:      "Signal ingestion — Tier 1. Commitment lifecycle signals canonical."
				description:   "CMT commitment lifecycle events (created, cancelled, milestone achieved) consumed para reputation + sourcing pattern signals."
			},
			{
				type:          "event-consumer"
				sourceContext: "bkr"
				event:         "SettlementOutcomeObserved"
				reaction:      "Signal ingestion — Tier 1. Banking rail outcomes canonical (asymmetric provenance preservada per NTF inherited)."
				description:   "BKR settlement outcomes + banking rail execution events consumed para TCO + reliability scoring."
			},
			{
				type:          "event-consumer"
				sourceContext: "bdg"
				event:         "BudgetReserved"
				reaction:      "Signal ingestion — Tier 1. Budget signals consumed para sourcing pattern + TCO inputs."
				description:   "BDG budget reservation + release events. Bidirectional epistemic feedback — BDG consume scoring potencialmente downstream."
			},
			{
				type:          "event-consumer"
				sourceContext: "rew"
				event:         "RiskDecisionEmitted"
				reaction:      "Signal ingestion — Tier 1. Risk outcomes canonical. Bidirectional: REW consome scoring + penalty outputs back."
				description:   "REW risk decision outcomes + risk classification changes. Critical bidirectional path — feedback loop detection mandatory via cap-feedback-loop-detection (REW consume score → REW decision → signal back to NIM → score recalculate)."
			},
			{
				type:          "event-consumer"
				sourceContext: "ssc"
				event:         "SourcingDecisionEmitted"
				reaction:      "Signal ingestion — Tier 1. Sourcing outcomes canonical. Bidirectional FEEDBACK LOOP SURFACE — SSC consome ranking/matching/scoring/governed-suggestion outputs; sourcing decisions emit signals back to NIM."
				description:   "SSC sourcing decision outcomes + supplier selection events. CRITICAL feedback loop surface — Class E feedback-loop violation detection canonical aqui (sourcing decision based on NIM ranking → sourcing outcome signal → NIM ranking recalculate; loop marker mandatory)."
			},
			{
				type:          "event-consumer"
				sourceContext: "idc"
				event:         "IdentityChanged"
				reaction:      "Signal ingestion — Tier 1. Identity + governance signals canonical."
				description:   "IDC identity changes + governance signals consumed para participant identity tracking + provenance integrity."
			},

			// === SIGNAL INGESTION (4 exogenous quarantine entries — Tier 1.Q) ===
			{
				type:          "event-consumer"
				sourceContext: "ext-economic-indicator"
				event:         "EconomicIndicatorObserved"
				reaction:      "Signal ingestion (exogenous) — Tier 1.Q quarantine via cap-exogenous-signal-quarantine. Provenance + freshness + source reliability check obrigatórios antes de Tier 1 canonical promotion. NÃO uniform treatment with internal signals."
				description:   "Exogenous economic indicators (FX rates, commodity prices, inflation indexes). Asymmetric epistemic ontology — higher uncertainty weighting downstream-visible em mechanism outputs."
			},
			{
				type:          "event-consumer"
				sourceContext: "ext-regulatory-signal"
				event:         "RegulatorySignalObserved"
				reaction:      "Signal ingestion (exogenous) — Tier 1.Q quarantine canonical."
				description:   "Exogenous regulatory signals (compliance authority notices, regulatory framework changes). Quarantine validation includes regulatory source authority verification."
			},
			{
				type:          "event-consumer"
				sourceContext: "ext-market-intelligence"
				event:         "MarketIntelligenceObserved"
				reaction:      "Signal ingestion (exogenous) — Tier 1.Q quarantine canonical."
				description:   "Exogenous market intelligence (industry benchmarks, market reports). Vendor methodology validation obrigatória."
			},
			{
				type:          "event-consumer"
				sourceContext: "ext-counterparty-public"
				event:         "CounterpartyPublicEventObserved"
				reaction:      "Signal ingestion (exogenous) — Tier 1.Q quarantine canonical."
				description:   "Publicly disclosed counterparty events (regulatory actions, public financial events). Asymmetric ontology — higher uncertainty + manipulation risk."
			},

			// === MUTATION AUTHORITY (2 platform operator command-handlers) ===
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Platform operator submits mechanism mutation proposal (ADR-bound governance pathway start per Phase 1.5.B mutation authority topology)"
				command:         "SubmitMechanismMutationProposal"
				resultingEvents: ["MechanismMutationProposalCreated", "MechanismMutationGovernanceDecisionEmitted"]
				description:     "Mutation-authority category per Phase 1.5 ajuste #1 (futura authority class separation candidate per Phase 1.7 forward observation #1). cap-mechanism-governance-mutation-control validation: 10 classification rows + 4 FORBIDDEN rejected at submission. Critical mutations (replay-sensitive + recursive-feedback + cross-BC-authority + adversarial-resistance-critical) follow 180-day cycle (per Phase 1.5 ajuste #4)."
			},
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Platform operator requests mechanism execution (within spec; explicit invocation)"
				command:         "RequestMechanismExecution"
				resultingEvents: ["MechanismArtifactLifecycleEvent", "MechanismExecutionGateRefusal"]
				description:     "Mutation-authority category. Triggers cap-mechanism-execution-gate (constitutional center) — Class A/B/C/D/E violation detection canonical. Per Phase 1.6 ajuste #2: Tier 3 escalation = constitutional integrity containment, NÃO operational incident."
			},

			// === AUDIT/OBSERVABILITY (2 query surfaces) ===
			{
				type:        "query-surface"
				query:       "QueryMechanismOutputState"
				returnType:  "MechanismOutputView (5-tuple authority boundary + lineage + temporal validity + interpretability class)"
				description: "Audit-observability category — consumer queries mechanism output state com 5-tuple metadata explicit. Inspectable-lineage canonical minimum (C15 mechanism interpretability preservation)."
			},
			{
				type:        "query-surface"
				query:       "RequestMechanismAuditReconstruction"
				returnType:  "MechanismAuditChain (court-grade lineage com causal precedence preserved + recursive loops unfolded as DAG per Phase 1.5.B Section F audit semantics)"
				description: "Audit-observability category — regulatory + governance audit reconstruction. Recursive loops audit: causal precedence preserved + each cycle discrete event + acyclic DAG reconstruction + no compressed audit. Per CC6 + C15 + Phase 1.5.B Section F."
			},
		]
		outbound: [
			// === MECHANISM CONSUMPTION (6 mechanism output events per type) ===
			{
				type:      "event-publisher"
				trigger:   "Scoring mechanism executed via Mechanism Execution Gate (Tier 2 promotion)"
				event:     "ScoringMechanismOutputEmitted"
				consumers: ["npm", "rew", "ssc", "ngr", "fce", "dlv"]
				description: "Mechanism-consumption category. Carries 5-tuple authority boundary metadata per consumer (NPM eligibility input, REW risk input, SSC sourcing ranking input, NGR growth opportunity input, FCE-limited convergence contextual analysis input, DLV-limited operational evaluation input). FCE/DLV consumers limited per Phase 1.2.B founder ajuste."
			},
			{
				type:      "event-publisher"
				trigger:   "Matching mechanism executed via gate"
				event:     "MatchingMechanismOutputEmitted"
				consumers: ["ssc", "npm"]
				description: "Mechanism-consumption category. Pair proposal canonical; consumer canonical authority preserved (SSC sourcing committee, NPM qualification flow). NÃO sourcing decision OR qualification verdict."
			},
			{
				type:      "event-publisher"
				trigger:   "Ranking mechanism executed via gate"
				event:     "RankingMechanismOutputEmitted"
				consumers: ["ssc", "ngr", "npm"]
				description: "Mechanism-consumption category. Ordered list canonical; ordering é signal NOT decision. 'Top N auto-shortlist' interpretation forbidden per Phase 1.2.B matrix."
			},
			{
				type:      "event-publisher"
				trigger:   "Incentive mechanism executed via gate"
				event:     "IncentiveMechanismOutputEmitted"
				consumers: ["p2p", "ctr", "npm"]
				description: "Mechanism-consumption category. Reward structure recipe canonical; consumer applies via own canonical contract/payment/promotion authority. NÃO auto-application sem consumer canonical pathway."
			},
			{
				type:      "event-publisher"
				trigger:   "Penalty mechanism executed via gate"
				event:     "PenaltyMechanismOutputEmitted"
				consumers: ["rew", "npm", "ctr", "drc"]
				description: "Mechanism-consumption category. Sanction structure recipe canonical; consumer applies via own canonical authority (esp. DRC dispute resolution remains DRC canonical). NÃO recipe AS authority."
			},
			{
				type:      "event-publisher"
				trigger:   "GovernedSuggestion mechanism executed via gate"
				event:     "GovernedSuggestionEmitted"
				consumers: ["ssc", "ngr", "npm"]
				description: "Mechanism-consumption category. NÃO personalized canonical per Phase 1.1 founder direction explicit. NÃO recommendation engine framing. Evaluation criteria template / sourcing framework / qualification framework canonical examples."
			},

			// === GOVERNANCE-FEEDBACK (6 refusal/violation/governance events) ===
			{
				type:      "event-publisher"
				trigger:   "Mechanism Execution Gate produces Class A/B/C/D/E violation verdict"
				event:     "MechanismExecutionGateRefusal"
				consumers: ["obs", "fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc", "ngr", "drc"]
				description: "Governance-feedback category. Refusal canonical first-class per CC2 (paralelo NTF refusal-as-success). Class A structural / B authority / C interpretability / D governance / E feedback-loop violations. Per Phase 1.6 ajuste #2: Tier 3 escalation = constitutional integrity containment, NÃO operational incident."
			},
			{
				type:      "event-publisher"
				trigger:   "Authority boundary 5-tuple violation detected via cap-mechanism-authority-boundary-enforcement"
				event:     "MechanismAuthorityBoundaryViolated"
				consumers: ["obs"]
				description: "Governance-feedback category. CRITICAL+ severity quando Pattern #2 (authority chain reinforcement) detected per Phase 1.6 ajuste #3 — bypass normal pathways + direct constitutional review pathway. score→legitimacy→policy→invisible governance substrate é mais profundo que simples authority leakage."
			},
			{
				type:      "event-publisher"
				trigger:   "Feedback loop detected via cap-feedback-loop-detection (Violation Class E)"
				event:     "FeedbackLoopDetected"
				consumers: ["obs"]
				description: "Governance-feedback category. Loop marker structure canonical (loopId + recursionDepth + recursionPath + boundedReviewRequired + loopOriginRef + loopRiskClass). loopRiskClass critical → constitutional review pathway."
			},
			{
				type:      "event-publisher"
				trigger:   "Provenance degradation detected (output loses lineage/source/time/epistemic-class)"
				event:     "ProvenanceDegradationDetected"
				consumers: ["obs"]
				description: "Governance-feedback category. Escape path #6 (provenance degradation escape) — output blocked até reconstruction OR re-execution per Phase 1.2.B founder ajuste #3."
			},
			{
				type:      "event-publisher"
				trigger:   "Adversarial resistance class evaluation via cap-adversarial-resistance-evaluation"
				event:     "AdversarialResistanceEvaluated"
				consumers: ["obs"]
				description: "Governance-feedback category. Resistance class transitions (low→medium→high→critical) + exploitation pattern detection. Drift class #1 mechanism gaming surface explícito."
			},
			{
				type:      "event-publisher"
				trigger:   "Mechanism mutation approved/rejected (post governance cycle)"
				event:     "MechanismMutationGovernanceDecisionEmitted"
				consumers: ["obs", "fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc", "ngr", "drc"]
				description: "Governance-feedback category. Cycle outcome canonical per ADR-bound mutation pathway (90/180-day per Phase 1.5 ajuste #4). Per CC4 mutation lifecycle explicit."
			},

			// === AUDIT/OBSERVABILITY (4 substrate + governance events) ===
			{
				type:      "event-publisher"
				trigger:   "Exogenous signal cleared quarantine → Tier 1 promotion"
				event:     "ExogenousSignalQuarantineCleared"
				consumers: ["obs"]
				description: "Audit-observability category. Quarantine validation outcome (provenance + freshness + source reliability passed)."
			},
			{
				type:      "event-publisher"
				trigger:   "Exogenous signal blocked at quarantine (validation failure)"
				event:     "ExogenousSignalQuarantineBlocked"
				consumers: ["obs"]
				description: "Audit-observability category. Validation failure preserved canonical com cause explicit."
			},
			{
				type:      "event-publisher"
				trigger:   "Mechanism artifact emitted OR lifecycle state change (Tier 2 substrate)"
				event:     "MechanismArtifactLifecycleEvent"
				consumers: ["obs"]
				description: "Audit-observability category. Tier 2 Mechanism Artifact Substrate lifecycle (outputs + versions + lineage + authority + validity envelope changes)."
			},
			{
				type:      "event-publisher"
				trigger:   "Mechanism mutation proposal submitted (ADR-bound pathway start)"
				event:     "MechanismMutationProposalCreated"
				consumers: ["obs"]
				description: "Audit-observability category. Proposal canonical com initiator + pathway + classification + reversibility class + affected consumer BCs + cross-BC authority impact + recursive loop impact (per Phase 1.5.B mutation authority topology)."
			},
		]
		rationale: """
			37 communication entries (21 inbound + 16 outbound) organized
			em 5-category discipline canonical per Phase 1.5 founder ajuste
			#1: signal-ingestion (17 inbound) + mutation-authority (2
			inbound) + audit-observability (2 inbound + 4 outbound) +
			mechanism-consumption (6 outbound) + governance-feedback (6
			outbound).

			Distinction critical per Phase 1.7 forward observation #1:
			mutation-authority NÃO é apenas categoria operacional — é
			início de futura separação entre governance traffic +
			operational traffic + constitutional traffic. Hoje aparece
			como categoria de comunicação; no futuro provavelmente vira
			classe de autoridade.

			Bidirectional epistemic feedback topology canonical visible:
			REW/SSC/NPM/P2P/CTR/DRC/BDG consomem mechanism outputs
			downstream + emit signals back to NIM substrate upstream.
			Feedback loop detection mandatory via cap-feedback-loop-
			detection — SSC explicit CRITICAL feedback loop surface
			(sourcing decision based on ranking → sourcing outcome
			signal → ranking recalculate cycle).

			Exogenous signals (4 categories) tratados via Tier 1.Q
			quarantine canonical — asymmetric epistemic ontology
			preserva substrate diversity (C12 anti-monoculture) +
			higher uncertainty weighting downstream-visible.

			Consumer enumeration per mechanism output reflete Phase 1.2.B
			authority matrix bounded: cada mechanism × consumer pair
			carries declared 5-tuple authority boundary; aggregation
			cross-consumer = universal substrate substitution Class A
			violation (defended via C14 + Pattern #2 CRITICAL+).

			Refusal events first-class canonical (paralelo Family Mesh
			inheritance FCE Defer + NTF Refused): MechanismExecutionGate
			Refusal + MechanismAuthorityBoundaryViolated + FeedbackLoop
			Detected + ProvenanceDegradationDetected são success outcomes
			ontologicamente (preservaram integrity); medir como failure
			= drift class #2 pseudo-objectivity collapse + drift class
			#12-equivalent refusal-reinterpretation gravity (inherited
			anti-fatigue clause Family Mesh canonical).
			"""
	}

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Construtora recipient — subject of mechanism outputs (scoring, ranking, incentive structures applied to them as buyer-side actor)"
		impactDescription: "Experiences NIM indirectly via consumer BC decisions (NPM qualification + SSC sourcing + REW risk pricing + P2P payment terms). Mechanism integrity affects fairness perception + economic outcomes. Adversarial gaming pressure structural — construtoras estructuralmente incentivized para manipulate signals affecting own reputation (incentive misalignment #4)."
		rationale:         "End user B2B Mesh — interage com NIM via downstream consumer BC decisions. Mechanism integrity directly affects experiência de equity + accountability."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Fornecedor recipient — subject of supplier-side mechanisms (IQF scoring, status promotion/demotion recipes, supplier rankings)"
		impactDescription: "Direct economic impact via reputation outputs consumed by SSC sourcing decisions + REW risk pricing + NPM qualification. Adversarial gaming pressure structural — fornecedores estructuralmente incentivized para discover + exploit scoring/ranking gaming paths (Goodhart operationalized; incentive misalignment #1)."
		rationale:         "Primary subject of mechanism outputs canonical. NIM scoring integrity directly affects supplier economic outcomes."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulator — may consume audit trail for mechanism integrity verification (algorithmic accountability emerging regulatory surface)"
		impactDescription: "Auditability + interpretability + provenance preservation regulatory-relevant. Pressure surface emergent (EU AI Act + Brazilian frameworks emerging) per incentive misalignment #5 — pode misalign with mechanism integrity canonical posture via fairness-driven mechanism mutation expectations."
		rationale:         "Regulatory environment for algorithmic systems intensifying globally. C15 interpretability + audit chain inviolability canonical defense."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Platform operator — operates substrate ingestion + quarantine + Mechanism Execution Gate + adversarial resistance evaluation + mechanism governance mutation control"
		impactDescription: "Operationally exposed to all 9 drift classes + 5-tuple discipline enforcement responsibility + mutation governance authority. Institutional pressure surface (incentive misalignment #2) — pressured for 'autonomous mechanism improvement' via ML-platform norms. Anti-pattern explicit: 'autonomous improvement' framing forbidden."
		rationale:         "Primary operational stakeholder. Mechanism governance discipline + adversarial pressure response + recursive governance signaling responsibility canonical."
	}, {
		stakeholderRef:    "sh-06"
		roleInContext:     "Adversary — structurally misaligned (mechanism gaming + Goodhart exploitation + pseudo-objectivity manipulation são adversarial strategies)"
		impactDescription: "Design rejects estructuralmente via cap-adversarial-resistance-evaluation + C8 + drift class #1 defense + adversarial-resistance-class structural dimension. Adversarial sophistication escalates in response to visible mechanism success (assumption canonical as-nim-adversarial-sophistication-escalation Phase 1.7 ajuste)."
		rationale:         "Adversary explicit canonical (paralelo NTF sh-06). Pre-emptively rejected via mechanism design integrity posture."
	}, {
		stakeholderRef:    "sh-07"
		roleInContext:     "Downstream BC consumers as institutional class (NPM, REW, SSC, NGR, P2P, CTR, DRC + FCE/DLV limited) — direct functional stakeholders consumindo mechanism outputs"
		impactDescription: "Institutional pressure surface (incentive misalignment #3) — pressured to 'trust the score' + outsource decisions to NIM outputs ('score já decidiu' narrative). Per Phase 1.2.B authority matrix: consumer canonical authority preserved per BC; mechanism outputs são INPUT decision, NÃO decision verdict. Authority chain reinforcement (Pattern #2 CRITICAL+) é existential drift vector."
		rationale:         "Downstream BC consumers added per Phase 1.4 founder ajuste #3 — stakeholder map sem class institutional dos consumidores ficava focado demais nos sujeitos do mecanismo. Esta é a class onde authority delegation drift (drift #7) + universal substrate convergence (drift class #7) materializam."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:           "sh-06"
			participantType:          "adversary (mechanism gaming actor)"
			desiredBehavior:          "Refuse to gamethe mechanism; transparent signal contribution."
			correctOperationIncentive: "None structural — adversary é structurally misaligned canonical. Disincentive applied via cap-adversarial-resistance-evaluation + adversarial-resistance-class dimension + drift #1 detection."
			manipulationVector:       "Goodhart's law operationalized — adversarial actors estructuralmente incentivized to discover + exploit mechanism gaming paths (timing transactions to boost IQF, fake transactions to influence ranking, collusive matching algorithm gaming, reputation cycling drop-rejoin patterns)."
			manipulationCost:         "Adversarial sophistication escalates in response to visible mechanism success (assumption as-nim-adversarial-sophistication-escalation). Cost grows non-linearly com defense maturity — cap-adversarial-resistance-evaluation + 8-dimension adversarial-resistance-class structural + mechanism evolution via cap-mechanism-governance-mutation-control."
			vsBenefit:                "Defense canonical asymmetric (structural defense via construction) vs adversarial sophistication evolving — long-term equilibrium requires sustained adversarial-resistance investment + governance discipline. NÃO assumed transient pressure."
			designResponse:           "cap-adversarial-resistance-evaluation (cap #13) dedicated capability + adversarial-resistance-class downgrade FORBIDDEN canonical + drift class #1 top-3 severity + 180-day cycle critical para adversarial-resistance-critical mechanism mutations. Paired com cap-mechanism-governance-mutation-control = 2 antídotos centrais."
			rationale:                "Per Phase 1.6 misalignment #1 + as-nim-adversarial-pressure-structural assumption. Gaming pressure structural canonical, NÃO operational concern."
		}, {
			stakeholderRef:           "sh-05"
			participantType:          "platform operator (institutional pressure surface)"
			desiredBehavior:          "Operate substrate + gate + mutation governance per canonical discipline; resist 'autonomous improvement' narrative; preserve mechanism integrity over operational efficiency."
			correctOperationIncentive: "Family Mesh constitutional posture canonical — mechanism integrity preservation aligns com long-term platform credibility + regulatory robustness + adversarial resistance + Mesh family canonical inheritance."
			manipulationVector:       "Institutional pressure for 'autonomous mechanism improvement' via ML-platform norms (KPI dashboards showing mechanism 'performance' trends, 'AI-driven optimization' narrative pressure, A/B testing for mechanism variants, 'autonomous mechanism evolution' framing). Drift class #3 implicit policy creep + #9 objective-function drift surface."
			manipulationCost:         "Drift detection canonical via cap-mechanism-governance-mutation-control + 4 FORBIDDEN mutation classes + 90/180-day observation cycles + ADR-bound mechanism evolution. governance-cannot-self-weaken canonical clause inheritance from Family Mesh — short-term throughput vs long-term constitutional integrity asymmetric."
			vsBenefit:                "Cost of operating canonical discipline >> benefit of 'autonomous improvement' speedup (which would cascade into existential drift via #3 + #9 + legitimacy capture vectors)."
			designResponse:           "C9 NOT autonomous policy optimizer canonical clause + cap-mechanism-governance-mutation-control (cap #14) + 10 mutation classification rows + 4 FORBIDDEN canonical (adversarial-resistance downgrade + 5-tuple removal + interpretability relaxation + objective-function substitution). Anti-pattern 'autonomous improvement' framing forbidden por construção."
			rationale:                "Per Phase 1.6 misalignment #2 + as-nim-institutional-improvement-pressure-inevitable assumption."
		}, {
			stakeholderRef:           "sh-07"
			participantType:          "downstream BC consumer (institutional delegation pressure surface)"
			desiredBehavior:          "Consume mechanism outputs as INPUT to canonical decision pathway; preserve own bounded authority; respect 5-tuple boundary per output."
			correctOperationIncentive: "Decision quality + accountability + audit traceability preserved via canonical consumer authority pathway. Outsourcing to NIM scores cria authority delegation drift + legitimacy accumulation risk + universal substrate convergence."
			manipulationVector:       "Institutional pressure to 'trust the score' — outsource decisions to NIM mechanism outputs (operational efficiency narrative 'score já decidiu' + liability deflection 'seguimos o algoritmo' + standardization narrative 'score torna decisões consistentes'). Drift class #7 authority delegation + Pattern #2 CRITICAL+ authority chain reinforcement."
			manipulationCost:         "Authority leakage detection canonical via cap-mechanism-authority-boundary-enforcement + cross-BC authority leakage Pattern detection (Phase 1.5.B Section D 4 patterns) + 5-tuple discipline runtime validation. Pattern #2 (CRITICAL+ existential) = score→legitimacy→policy→invisible authority chain detected → bypass normal pathways + direct constitutional review."
			vsBenefit:                "Cost of preserving canonical consumer authority << cost of becoming invisible NIM authority substrate (legitimacy capture trajectory)."
			designResponse:           "C14 no-universal-score-authority canonical + Phase 1.2.B authority matrix per consumer × mechanism + cap-mechanism-authority-boundary-enforcement (cap #11) runtime detection + Pattern #2 CRITICAL+ direct constitutional review pathway per Phase 1.6 ajuste #3."
			rationale:                "Per Phase 1.6 misalignment #3 + drift class #7 authority delegation."
		}, {
			stakeholderRef:           "sh-02"
			participantType:          "fornecedor / participant (reputation manipulation pressure surface)"
			desiredBehavior:          "Operate transparent transaction patterns; legitimate reputation building via observed performance."
			correctOperationIncentive: "Reputation é emergent NOT assigned (C5 canonical) — sustained legitimate operation produces canonical reputation outputs sem manipulation."
			manipulationVector:       "Network participants estructuralmente incentivized to manipulate signals affecting own reputation (distinct from #1 gaming — institutional-level manipulation): lobbying NIM operators para change mechanism weighting, disputing legitimate negative signals to suppress mechanism input, strategic transaction patterning to game IQF/TCO composition rules."
			manipulationCost:         "Signal provenance preservation canonical (cap-signal-substrate-ingestion + 7 substrate invariants) + bd-evidence-as-substrate (signal authenticity required) + drift class #4 reputation drift detection."
			vsBenefit:                "Manipulation cost (substrate provenance audit + reputation drift detection + mechanism mutation governance) >> benefit (slight reputation improvement) sob sustained operation."
			designResponse:           "C5 reputation emergent NÃO assigned + cap-signal-substrate-ingestion provenance preservation + drift class #4 reputation drift + cap-mechanism-governance-mutation-control prevents lobbying-driven mutation."
			rationale:                "Per Phase 1.6 misalignment #4."
		}, {
			stakeholderRef:           "sh-04"
			participantType:          "regulator (algorithmic accountability pressure surface)"
			desiredBehavior:          "Consume mechanism integrity audit via canonical interpretability + audit chain; engage com NIM via consumer-side regulatory framework adaptation, NÃO mechanism-side framework substitution."
			correctOperationIncentive: "NIM canonical interpretability (C15 inspectable-lineage minimum) + audit chain inviolability + court-grade reconstruction provide structural compliance surface — interpretability dimension stable canonical defense."
			manipulationVector:       "Emerging regulatory environment may pressure NIM to provide 'explainable outputs' beyond canonical interpretability OR provide 'fairness guarantees' that misalign with mechanism integrity canonical posture (mechanism integrity guardian role conflicts com fairness-driven mechanism mutation expectations)."
			manipulationCost:         "Interpretability dimension structurally bounded — operational mappings to regulatory frameworks via consumer-side adaptation (consumer BC compliance translation layers), NÃO NIM-side framework substitution. 'Fairness-driven mechanism mutation' framing forbidden — fairness é consumer-canonical decision-pathway concern, NÃO mechanism-design concern (avoids objective-function drift class #9)."
			vsBenefit:                "NIM-side framework substitution = objective-function drift catastrophic + universal substrate substitution. Consumer-side adaptation = bounded regulatory compliance preserving mechanism integrity."
			designResponse:           "C15 interpretability preservation + audit chain inviolability + tc-regulatory-evidentiary-paralelo audit substrate + consumer-side regulatory framework adaptation pattern (NIM produces canonical mechanism outputs; consumers translate per regulatory framework)."
			rationale:                "Per Phase 1.6 misalignment #5."
		}, {
			stakeholderRef:           "sh-05"
			participantType:          "platform operator (governance evolution pressure surface — existential)"
			desiredBehavior:          "Recognize mutation governance vs operational governance distinction; preserve mutation governance discipline canonical even as adoption scales."
			correctOperationIncentive: "Constitutional-split-review pathway forward candidate (Phase 1.5.B forward observation) preserva sistema canonical integrity quando complexity exceeds single envelope."
			manipulationVector:       "As NIM matures, structural pressure emerge para promote NIM mutation governance itself como governance object (per Phase 1.5.B founder observation: 'NIM may become the first Mesh BC where governance evolution itself becomes a governed domain object'). Tension structural entre operational governance simplicity vs constitutional governance complexity."
			manipulationCost:         "Forward-canonical observation registered (NÃO immediate defense — recognized as architectural evolution surface). Phase 1.7 outer rationale captures forward-evolution candidate. Constitutional-split-review pathway forward."
			vsBenefit:                "NÃO current threat; structural evolution surface. Recognition pre-emptive preserves option canonical for future architectural separation."
			designResponse:           "Forward-canonical observation registered Phase 1.7 outer rationale + constitutional-split-review pathway forward candidate (Phase 1.5.B). 'Governance over governance-producing mechanisms' qualitative META-constitutional framing canonical."
			rationale:                "Per Phase 1.6 misalignment #6 + Phase 1.5.B forward observation. Existential evolutionary surface NÃO immediate threat."
		}, {
			stakeholderRef:           "sh-07"
			participantType:          "downstream BC consumers + ecosystem actors (legitimacy capture pressure — pre-hegemonic drift)"
			desiredBehavior:          "Consume mechanism outputs without elevating to institutional legitimacy substrate; preserve epistemic diversity."
			correctOperationIncentive: "Mechanism integrity preservation + epistemic substrate diversity + bounded authority canonical => long-term legitimacy stability + adversarial resilience."
			manipulationVector:       "À medida que mecanismos NIM se tornam economicamente relevantes, atores começam a disputar não apenas outputs, mas a própria legitimidade institucional do mecanismo. Formas: 'esse score deveria ser referência oficial' + 'o mercado inteiro usa isso' + 'se todos usam, então é neutro' + pressão para transformar mechanism artifact em institutional authority substrate. Drift pré-hegemônico — distinto de gaming (#1) + authority delegation (#3) + policy creep (#5)."
			manipulationCost:         "Defense canonical multi-layer: C14 no-universal-score-authority + cap-mechanism-authority-boundary-enforcement + Phase 1.5.B Pattern #2 CRITICAL+ + Pattern #3 universal substrate convergence detection + vm-nim-legitimacy-accumulation-monitoring + Phase 1.7 forward observation #6 Legitimacy accumulation risk."
			vsBenefit:                "Legitimacy capture transforms NIM scores → institutional legitimacy → invisible governance substrate — catastrophic existential drift trajectory. Defense canonical preserves substrate diversity + bounded authority + epistemic plurality."
			designResponse:           "C14 + Phase 1.5.B Pattern #2 CRITICAL+ + Phase 1.7 forward observation #6 + vm-nim-legitimacy-accumulation-monitoring metric + cap-mechanism-authority-boundary-enforcement Pattern detection. Future Phase 5 governance envelope materializes detection + escalation."
			rationale:                "Per Phase 1.6 misalignment #7 NEW (founder Phase 1.6 ajuste #1). Pre-hegemonic drift vector — alvo é transformar adoção em legitimidade + legitimidade em soberania epistemológica."
		}]
		rationale: """
			7 incentive misalignments canonical materializados per
			founder Phase 1.6 framework — distintos vetores adversarial
			+ institutional + structural. Density superior vs FCE/NTF
			reflete NIM constitutional complexity (mechanism design
			toca múltiplos drift vectors: adversarial sophistication +
			institutional pressure + delegation pressure + manipulation
			pressure + regulatory pressure + governance evolution
			pressure + legitimacy capture pre-hegemonic drift).

			Critical observation per Phase 1.7 framing: cap-adversarial-
			resistance-evaluation + cap-mechanism-governance-mutation-
			control = 2 antídotos centrais contra colapso típico de
			sistemas algorítmicos:
			- gaming = ataque externo ao mecanismo
			- policy creep = mutação interna de autoridade sem
			  reconhecimento institucional
			Distintos vetores normalmente conflated como single
			"fairness" OR "safety" problem em sistemas modernos; NIM
			separa explicit canonical.

			Misalignment #7 (Mechanism Legitimacy Capture) é pre-
			hegemonic drift — alvo NÃO é gaming nem delegation nem
			policy creep, mas transformação de adoção em legitimidade
			+ legitimidade em soberania epistemológica. Phase 1.7
			forward observation #6 (Legitimacy accumulation risk)
			amarra monoculture + authority reinforcement + recursive
			governance + constitutional split + invisible policy
			emergence.

			Per founder Section 13 outer rationale: 'The primary risk
			is not explicit authoritarian control, but gradual
			epistemic dependency normalization.' Esta é provavelmente
			a frase mais importante do BC inteiro — captura hegemonia
			epistemológica emergente + naturalização do score +
			invisibilidade do drift + legitimidade acumulada +
			recursive governance collapse.
			"""
	}

	costsEliminated: [{
		costRef: "ce-04"
		contribution: """
			Custo de avaliação de risco com dados incompletos reduzido
			via cap-signal-substrate-ingestion + accumulated provenance
			substrate + 6 canonical mechanism types operating sobre
			Tier 1 Signal Substrate (NPM eligibility events + DLV
			delivery outcomes + FCE settlement results + 10 outros
			BCs operacionais).

			Mechanism outputs (scoring, matching, ranking, incentive,
			penalty, governed-suggestion) fornecem inputs estructurados
			consumidos por REW (risk pricing) + NPM (eligibility) + SSC
			(sourcing) + NGR (growth) + outros consumer BCs canonical
			per Phase 1.2.B authority matrix.

			Substrate canonical é flywheel anti-incomplete-data: cada
			signal ingested + each mechanism execution + each audit
			emission preserves provenance chain canonical, accumulating
			canonical evidence substrate over time. NÃO replicável por
			concorrentes sem o mesmo volume de transações (canonical
			moat de IA per WI-045 + subdomain definition).

			Contribution bounded: NIM produces canonical mechanism
			outputs com 5-tuple authority boundary explicit; consumer
			BCs apply own canonical decision pathways. Cost reduction
			é structural input, NÃO decision substitute (preserves C3
			algorithmic-output-is-signal-not-decision + C14 no-
			universal-score-authority).
			"""
		rationale: "Per ce-04 + subdomain costRefs. NIM substrate canonical reduz incomplete-data cost via accumulated provenance + 6 mechanism types operating sobre Tier 1 Signal Substrate. Future cost refs (ce-NIM-01 gaming mitigation + ce-NIM-03 monoculture risk mitigation) deferred to separate WI quando domain/domain-definition.cue updated com novos ce-* canonical refs (ce-NIM-02 governance cost intentionally paid NÃO entra costsEliminated per Phase 1.4 founder ajuste #4 framing)."
	}]

	ownership: {
		domainAgentSpec: "contexts/nim/agents/nim-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "signal-substrate-ingestion-provenance-preservation"
				description: "Ingest signals from 13 BCs operacionais para Tier 1 substrate com provenance preservation per substrate invariants 1-7. Mechanical execution per spec; NÃO judgment."
				rationale:   "Per Tier 1 substrate canonical + 7 invariants Phase 1.2. Source diversity preserved (C12 anti-monoculture)."
			}, {
				id:          "exogenous-signal-quarantine-validation"
				description: "Quarantine validation mechanical (provenance + freshness + source reliability check) per Tier 1.Q rules. Cleared → Tier 1 promotion; blocked → quarantine event + audit."
				rationale:   "Per cap-exogenous-signal-quarantine + Phase 1.2 ajuste #4. Validation rules mechanical, NÃO discretionary."
			}, {
				id:          "mechanism-execution-within-spec"
				description: "Execute mechanism per declared specification (within 8-dimension spec) — Mechanism Execution Gate validates 5-tuple compliance + Mechanism Integrity Matrix (Class A/B/C/D/E violations); valid execution produces Tier 2 artifact."
				rationale:   "Per cap-mechanism-execution-gate + C1 mechanism authority sovereignty. Within-spec execution é deterministic; mutation outside spec → supervised (mutation proposal pathway)."
			}, {
				id:          "tuple-boundary-validation-runtime"
				description: "Per-dispatch 5-tuple authority boundary validation (cap-mechanism-authority-boundary-enforcement) — mechanism × consumer × authority surface × forbidden interpretation × escape path compliance."
				rationale:   "Per C14 + Phase 1.2.B authority matrix. Runtime validation mechanical."
			}, {
				id:          "lineage-propagation-tracking"
				description: "Track mechanism lineage propagation per Phase 1.5.B Section E rules — Tier 1 input signals lineage preserved through Tier 2 output + consumer acknowledgment + downstream propagation reference obligation."
				rationale:   "Per CC3 provenance + authority boundary preserved + C4 provenance preservation."
			}, {
				id:          "audit-chain-emission-immutable"
				description: "Emit audit chain entries canonical immutable append-only per OP7-equivalent (paralelo NTF audit chain inviolability) — court-grade reconstruction support."
				rationale:   "Per CC6 + CC3 + tc-regulatory-evidentiary-paralelo audit substrate. Audit emission mechanical."
			}, {
				id:          "feedback-loop-detection-bounded-review-trigger"
				description: "Detect recursive loop patterns via cap-feedback-loop-detection — emit loop marker (loopId + recursionDepth + recursionPath + boundedReviewRequired + loopOriginRef + loopRiskClass); trigger bounded review quando boundedReviewRequired=true OR loopRiskClass=critical."
				rationale:   "Per C11 + CC6 + Phase 1.2 ajuste #5 + Phase 1.5.B ajuste #2. Detection mechanical; bounded review trigger structural."
			}, {
				id:          "adversarial-resistance-periodic-evaluation"
				description: "Periodic mechanism stress review + gaming pattern detection + anti-Goodhart analysis via cap-adversarial-resistance-evaluation."
				rationale:   "Per C8 + drift class #1 + cap #13. Periodic evaluation mechanical canonical."
			}]
			supervisedDecisions: [{
				id:          "mechanism-mutation-proposal-evaluation"
				description: "Mechanism mutation proposals (10 classification rows per Phase 1.5 cap-mechanism-governance-mutation-control) — ADR-bound governance pathway evaluation. Founder approval per classification (architectural reviewer OR founder-only). 4 FORBIDDEN canonical rejected at submission."
				rationale:   "Per C6 + C9 + cap #14. Mutation governance é explicit canonical, NÃO autonomous."
			}, {
				id:          "new-mechanism-type-declaration"
				description: "New mechanism type declaration (beyond 6 canonical types: Scoring/Matching/Ranking/Incentive/Penalty/GovernedSuggestion). Founder-only + ADR + parallel SRR + 90-day cycle minimum; 180-day cycle critical para replay-sensitive + recursive-feedback + cross-BC-authority + adversarial-resistance-critical domains (per Phase 1.5 ajuste #4)."
				rationale:   "Per cap-mechanism-governance-mutation-control mutation row 4 + Phase 1.5 ajuste #4 critical domain expansion."
			}, {
				id:          "authority-surface-expansion-new-consumer-bc"
				description: "Authority surface expansion (new consumer BC added to mechanism × consumer matrix) — founder-only + ADR + parallel SRR + 180-day cycle critical canonical (cross-BC-authority domain)."
				rationale:   "Per Phase 1.2.B authority matrix + C14 + 180-day cycle critical."
			}, {
				id:          "adversarial-resistance-class-upgrade"
				description: "Adversarial-resistance-class upgrade (low → medium → high → critical) per observed adversarial patterns. Founder-only approval; downgrade FORBIDDEN canonical."
				rationale:   "Per C8 + adversarial-resistance-class FORBIDDEN downgrade canonical."
			}, {
				id:          "mechanism-mutation-classification-recategorization"
				description: "Re-categorization of mutation classification (e.g., moving mutation type from architectural reviewer to founder-only). Sovereignty-defining canonical — founder-only approval."
				rationale:   "Per cap-mechanism-governance-mutation-control mutation classification table sovereignty-defining row."
			}, {
				id:          "exogenous-signal-category-additions"
				description: "New exogenous signal category additions (beyond 4 canonical: ext-economic-indicator + ext-regulatory-signal + ext-market-intelligence + ext-counterparty-public) OR Tier 1.Q quarantine validation rule modifications."
				rationale:   "Per cap-exogenous-signal-quarantine. New ext categories expand substrate ontology — supervised governance canonical."
			}]
			escalationCriteria: [{
				id:        "forbidden-mutation-attempt"
				condition: "Mutation proposal contém any of 4 FORBIDDEN classifications: adversarial-resistance-class downgrade OR 5-tuple field removal OR interpretability class relaxation (downgrade to opaque-blocked) OR objective-function substitution."
				action:    "Reject canonical at submission + audit event + escalation L4 forensic-integrity-equivalent review (founder + ntf-forensic-integrity-reviewer-equivalent). Tier 3 = constitutional integrity containment, NÃO operational incident (per Phase 1.6 ajuste #2)."
				rationale: "Per cap-mechanism-governance-mutation-control + governance-cannot-self-weaken canonical Family Mesh inheritance. FORBIDDEN canonical NÃO negociáveis."
			}, {
				id:        "mechanism-integrity-matrix-violation-class-a-to-e"
				condition: "Mechanism Execution Gate detects Class A (structural) OR Class B (authority) OR Class C (interpretability) OR Class D (governance) OR Class E (feedback-loop) violation."
				action:    "Halt mechanism execution + audit reconstruction + governance review per severity. Class A/B/C = HIGH escalation; Class D/E = CRITICAL escalation (governance pathway bypass OR feedback loop blindness)."
				rationale: "Per Mechanism Integrity Matrix canonical + 5 violation classes Phase 1.2.D + Phase 1.2 ajuste #5 Class E."
			}, {
				id:        "cross-bc-authority-leakage-pattern-detected"
				condition: "cap-mechanism-authority-boundary-enforcement detects Pattern 1 (authority surface extension) OR Pattern 2 (authority chain reinforcement) OR Pattern 3 (universal substrate convergence) OR Pattern 4 (cross-decision propagation)."
				action:    "Pattern #2 CRITICAL+ existential: BYPASS normal pathways + DIRECT constitutional review pathway (per Phase 1.6 ajuste #3) — score→legitimacy→policy→invisible authority é mais profundo que simples authority leakage. Patterns 1/3/4 HIGH-CRITICAL: halt + cross-BC coordination protocol."
				rationale: "Per Phase 1.5.B Section D + Phase 1.6 ajuste #3. Pattern #2 é CRITICAL+ existential drift vector — drift mais perigoso do sistema inteiro (transforma mechanism → legitimacy → invisible governance substrate)."
			}, {
				id:        "recursive-loop-bounded-review-trigger"
				condition: "cap-feedback-loop-detection detects loopRiskClass=critical OR boundedReviewRequired=true (recursionDepth > threshold OR cross-BC propagation OR adversarial reinforcement potential)."
				action:    "HIGH severity: bounded review per loopId + governance escalation. loopRiskClass=critical → constitutional review pathway (NÃO operational review per Phase 1.7 openQuestion #4 constitutional evolution surface)."
				rationale: "Per C11 + CC6 + Phase 1.5.B loop marker structure + Phase 1.5.B ajuste #2 loopRiskClass."
			}, {
				id:        "provenance-degradation-detected"
				condition: "Mechanism output detected sem complete lineage (source OR observation-time OR epistemic-class OR weighting metadata missing) per escape path #6."
				action:    "HIGH: output blocked + reconstruction OR re-execution pathway. Provenance integrity é structural property (C4); degradation triggers governance pathway."
				rationale: "Per escape path #6 (Phase 1.2.B founder ajuste #3) + C4 provenance preservation."
			}, {
				id:        "lineage-rewriting-detected"
				condition: "Downstream consumer rewrites lineage semantically (forbidden case #4 Phase 1.5.B): score → 'selo de qualidade'; ranking → 'lista recomendada'; confidence class → 'aprovação'. Meaning-preserving mapping forbidden."
				action:    "CRITICAL+: halt + founder review + downstream consumer notification + lineage forensic protocol (Phase 1.7 openQuestion #8 surface)."
				rationale: "Per Phase 1.5.B Section E forbidden case #4 (founder ajuste #5). Lineage rewriting produz authority leakage invisível via semantic transformation."
			}, {
				id:        "active-adversarial-exploitation-detected"
				condition: "cap-adversarial-resistance-evaluation detects active exploitation pattern (sustained gaming behavior + Goodhart pattern + collusive manipulation)."
				action:    "CRITICAL: halt affected mechanism + adversarial response coordination + governance review per Phase 1.7 openQuestion #1."
				rationale: "Per C8 + drift class #1 + cap #13. Active exploitation requires governance response (NÃO autonomous adaptive retuning — that would be FORBIDDEN mutation pathway)."
			}, {
				id:        "mechanism-mutation-classification-rejection-pattern"
				condition: "Mechanism mutation proposal containing FORBIDDEN classification submitted (pre-rejection event canonical) — indicates institutional pressure for forbidden mutation."
				action:    "CRITICAL: rejection canonical + audit event + escalation review (pattern of forbidden attempts may indicate institutional drift; per vm-nim-forbidden-mutation-attempt-rate sustained pattern monitoring)."
				rationale: "Per vm-nim-forbidden-mutation-attempt-rate metric Phase 1.7. Sustained pattern indicates institutional drift requiring governance attention."
			}, {
				id:        "audit-chain-integrity-breach"
				condition: "Audit chain integrity breach detected (cryptographic chain validation failure OR chain link missing OR audit event mutation post-emission)."
				action:    "CRITICAL: L4 forensic-integrity-equivalent immediate review (paralelo NTF). Audit chain inviolability é structural property; breach is security/integrity incident."
				rationale: "Per CC6 audit chain inviolability + paralelo NTF L4 forensic-integrity-immediate canonical."
			}, {
				id:        "refusal-suppression-narrative-pressure-detected"
				condition: "Governance artifact OR metric proposal OR dashboard OR ADR OR KPI proposal OR wording shift reframing refusal/conservatism/escalation as throughput inefficiency, UX friction, optimization target (paralelo NTF dm-refusal-suppression-pressure-signals)."
				action:    "CRITICAL: suspend governance mutation pathway + founder review (meta-governance defense per Family Mesh inheritance — drift começa na linguagem)."
				rationale: "Per NTF inheritance + governance-cannot-self-weaken canonical. Linguistic drift é precursor constitucional (NÃO sinal fraco) — first vector of ontological collapse."
			}]
		}
		rationale: """
			Ownership canonical: domainAgentSpec aponta a nim-primary-
			agent.cue (Phase 4 bootstrap; cascade ordering enforced).
			GovernanceScope 3-tier paralelo Family Mesh (FCE/NTF
			canonical inheritance):

			- AUTONOMOUS (8 decisions): deterministic protocol execution
			  within declared mechanism spec — signal ingestion +
			  quarantine validation + mechanism execution within spec
			  + 5-tuple boundary validation + lineage propagation +
			  audit emission + feedback loop detection + adversarial
			  resistance periodic evaluation.

			- SUPERVISED (6 decisions): canonical change requiring
			  architectural reviewer OR founder approval — mechanism
			  mutation proposals + new mechanism type declarations +
			  authority surface expansion + adversarial-resistance-class
			  upgrade + mutation classification re-categorization +
			  exogenous signal category additions.

			- ESCALATION (10 criteria): Tier 3 = constitutional
			  integrity containment per Phase 1.6 ajuste #2 (NÃO
			  operational incident). FORBIDDEN mutation attempts + 5
			  violation classes Class A-E + cross-BC authority leakage
			  patterns 1-4 (Pattern #2 CRITICAL+ existential bypass) +
			  recursive loop bounded review + provenance degradation +
			  lineage rewriting + active adversarial exploitation +
			  mutation classification rejection pattern + audit chain
			  integrity breach + refusal-suppression narrative pressure.

			NIM-specific governance posture clause canonical:
			'Mechanism governance becomes constitutional governance
			when mechanism outputs influence network-wide authority
			topology' (per Phase 1.6 ajuste #4 reformulated — preserves
			gradation; nem toda mutation é constitucional, mas algumas
			inevitavelmente se tornam).

			Anti-fatigue + governance-cannot-self-weaken clauses
			canonical Family Mesh inheritance: refusal/escalation rate
			é integrity preservation signal NÃO operational performance
			metric; sustained high escalation rate may indicate sistema
			operating em adversarial environment correctly, NÃO
			governance inefficiency.
			"""
	}

	assumptions: [{
		id:                 "as-nim-adversarial-pressure-structural-1"
		assumption:         "Gaming pressure é structural NÃO transient; adversarial actors estructuralmente incentivized to discover exploitation paths (Goodhart's law operationalized). Mechanism design must persist asymmetric defensive posture per construction, NÃO temporary defense."
		invalidationSignal: "Sustained 3+ years sem any detected gaming attempt across all mechanism types AND independent adversarial red-team confirms no exploitable patterns. Currently no evidence; assumption holds robustly."
		rationale:          "Per founder Phase 1.7 ajuste + drift class #1 + cap-adversarial-resistance-evaluation. Gaming inevitability structural é foundational design assumption — sem this, defense vira temporary tactical concern."
	}, {
		id:                 "as-nim-institutional-improvement-pressure-inevitable-2"
		assumption:         "Operational pressure for 'autonomous mechanism improvement' via ML-platform norms é inevitable em mature operation. Surface as: KPI dashboards showing mechanism 'performance' trends, AI-driven optimization narrative pressure, A/B testing for mechanism variants, 'autonomous mechanism evolution' framing."
		invalidationSignal: "12+ months sustained operation sem ANY autonomous-improvement narrative emerging from product/ops/executive functions. Would invalidate AND require recalibration of governance envelope drift sensitivity."
		rationale:          "Per founder framing + drift class #3 + #9 + C9 NOT autonomous policy optimizer + cap-mechanism-governance-mutation-control. Institutional improvement pressure é predictable adversarial vector — governance envelope (Phase 5) must defend permanently."
	}, {
		id:                 "as-nim-recursive-governance-complexity-superlinear-3"
		assumption:         "As mechanism adoption scales, recursive epistemological governance loops + cross-BC authority propagation + legitimacy accumulation pressure grow super-linearly. Linear governance envelope assumption may fail; constitutional-split-review pathway é forward-evolution candidate not premature optimization."
		invalidationSignal: "Mechanism adoption reaches N consumer BCs without recursive complexity emergence beyond bounded review thresholds (loopRiskClass=critical OR boundedReviewRequired=true sustained <1% of executions). Constitutional-split-review pathway becomes premature optimization if invalidated."
		rationale:          "Per Phase 1.5.B forward observation + Phase 1.7 forward observation #2 + #3. Recursive governance complexity é NIM-specific phenomenon paralelo a Family Mesh constitutional posture mas adicionando recursive epistemological dimension."
	}, {
		id:                 "as-nim-mechanism-economic-relevance-creates-legitimacy-pressure-4"
		assumption:         "As substrate evolves + signal coverage expands + mechanism outputs become economically consequential, legitimacy capture pressure (incentive misalignment #7 Phase 1.6 NEW) becomes existential drift vector. Future BC bootstraps may need NIM-pattern constitutional posture inheritance."
		invalidationSignal: "Mechanism outputs remain operationally consequential WITHOUT creating institutional legitimacy substrate pressure across 3+ year sustained adoption. Currently unsupported — pre-hegemonic drift trajectory canonical (Phase 1.7 forward observation #6 Legitimacy accumulation risk)."
		rationale:          "Per Phase 1.6 misalignment #7 NEW + Phase 1.7 forward observation #6. Legitimacy capture é distinct vector from gaming/delegation/policy-creep — pre-hegemonic drift trajectory existential."
	}, {
		id:                 "as-nim-algorithmic-regulatory-pressure-intensifying-5"
		assumption:         "Regulatory environment for algorithmic systems intensifying globally (EU AI Act + emerging Brazilian frameworks). Pressure may misalign with mechanism integrity canonical posture via fairness-driven mechanism mutation expectations."
		invalidationSignal: "Regulatory environment shifts toward acceptance of inspectable-lineage interpretability AS sufficient (vs demanding fairness-driven mechanism mutation). Defense canonical preserves: C15 + audit chain inviolability + consumer-side regulatory framework adaptation."
		rationale:          "Per Phase 1.6 misalignment #5 + C15 interpretability preservation + regulatory pressure context emerging globally."
	}, {
		id:                 "as-nim-adversarial-sophistication-escalation-6"
		assumption:         "Adversarial sophistication escalates in response to visible mechanism success. Mechanisms that become economically consequential attract progressively more capable gaming actors over time. Pressure NÃO é constante; é evolutiva."
		invalidationSignal: "Sustained adversarial pressure baseline observed sem sophistication escalation correlated com mechanism adoption AND economic consequence. Would invalidate temporal asymmetry assumption."
		rationale:          "Per founder Phase 1.7 ajuste NEW. Captura evolução adaptativa do adversário + assimetria temporal + inevitabilidade de escalada. Fecha lacuna entre #1 (gaming estrutural) + #4 (legitimacy pressure) + adversarial-resistance-class evolution."
	}]

	openQuestions: [{
		id:       "oq-nim-mechanism-gaming-response-protocol-1"
		question: "Quando adversarial gaming pattern detected via cap-adversarial-resistance-evaluation, qual canonical response (halt mechanism / freeze evolution / adversarial-resistance-class upgrade)?"
		impact:   "Defines NIM adversarial incident response semantics. Sem protocol explicit, response varia caso-a-caso → drift class #1 effective response erodes."
		rationale: "Per founder Phase 1.7 + drift class #1. Adversarial response protocol é operational specification gap pendente."
	}, {
		id:       "oq-nim-constitutional-split-review-formalization-2"
		question: "Quando NIM mutation governance separates structurally from operational governance (Phase 1.7 forward observation)? Trigger conditions canonical?"
		impact:   "Architectural evolution surface — constitutional evolution surface per founder Phase 1.7 ajuste #2 priority marking."
		rationale: "Per Phase 1.5.B forward observation + Phase 1.7 forward observation #2. Constitutional evolution surface — quando se manifesta?"
	}, {
		id:       "oq-nim-legitimacy-accumulation-threshold-3"
		question: "Quando cross-BC mechanism adoption cross from 'operational usefulness' to 'implicit institutional legitimacy' (Phase 1.7 forward observation #6)? Detection signal canonical?"
		impact:   "Precursor canonical do constitutional split + universal substrate collapse + invisible governance emergence. Constitutional evolution surface per founder Phase 1.7 ajuste #2 priority marking."
		rationale: "Per Phase 1.6 misalignment #7 + Phase 1.7 forward observation #6 Legitimacy accumulation risk. Pre-hegemonic drift detection canonical."
	}, {
		id:       "oq-nim-recursive-loop-escalation-pathway-4"
		question: "Quando loopRiskClass=critical, escalation to constitutional review pathway OR operational review pathway? Boundary canonical?"
		impact:   "Recursive epistemological governance operational interpretation surface."
		rationale: "Per CC6 + Phase 1.5.B loop marker + Phase 1.5.B ajuste #2 loopRiskClass."
	}, {
		id:       "oq-nim-authority-chain-reinforcement-containment-5"
		question: "Quando Pattern #2 detected (CRITICAL+ existential), containment canonical (rollback consumer event / governance ADR / structural review)?"
		impact:   "Defines existential drift response. Constitutional evolution surface per founder Phase 1.7 ajuste #2 priority marking."
		rationale: "Per Phase 1.5.B Pattern #2 CRITICAL+ + Phase 1.6 ajuste #3 bypass normal pathways. Existential drift mais perigoso do sistema inteiro."
	}, {
		id:       "oq-nim-interpretability-regulatory-alignment-6"
		question: "Quando regulatory pressure demands 'fairness explanations' beyond canonical interpretability, qual pathway preserves both (NIM integrity + regulatory compliance)?"
		impact:   "Defines NIM-vs-regulatory boundary. C15 interpretability preservation canonical vs regulatory framework substitution risk."
		rationale: "Per Phase 1.6 misalignment #5 + as-nim-algorithmic-regulatory-pressure-intensifying-5. Regulatory pressure surface emerging."
	}, {
		id:       "oq-nim-mutation-classification-edge-cases-7"
		question: "Proposed mutations spanning multiple classification rows (e.g., weighting calibration with unintended objective-function impact) — como classify canonically?"
		impact:   "Mutation governance precision. Edge cases sem canonical handling lead to inconsistent governance pathway selection."
		rationale: "Per cap-mechanism-governance-mutation-control + 10 classification rows + drift class #9 objective-function drift."
	}, {
		id:       "oq-nim-lineage-rewriting-forensic-protocol-8"
		question: "Quando downstream consumer rewrites lineage semantically (Phase 1.5.B forbidden case #4: 'score' → 'selo'), qual forensic + audit + governance pathway?"
		impact:   "Authority leakage forensic operational protocol. Without protocol, lineage rewriting detection vira inconsistent response."
		rationale: "Per Phase 1.5.B Section E forbidden case #4 + Phase 1.5.B ajuste #5 + lineage rewriting escalation criterion."
	}, {
		id:       "oq-nim-adversarial-resistance-upgrade-triggers-9"
		question: "Quais observed adversarial patterns warrant resistance class upgrade (low → medium → high → critical)? Detection thresholds canonical?"
		impact:   "Mechanism resistance evolution governance. Sem thresholds explicit, upgrade decisions varia caso-a-caso."
		rationale: "Per C8 + cap-adversarial-resistance-evaluation + adversarial-resistance-class dimension."
	}, {
		id:       "oq-nim-exogenous-source-reliability-evolution-10"
		question: "Quando exogenous source reliability changes (regulatory authority adds signal type; market intelligence vendor changes methodology), qual Tier 1.Q integration pathway?"
		impact:   "Substrate evolution governance. New exogenous signal handling sem canonical pathway erodes Tier 1.Q discipline."
		rationale: "Per cap-exogenous-signal-quarantine + 4 exogenous categories + bd-asymmetric-exogenous-ontology."
	}, {
		id:       "oq-nim-multi-bc-concurrent-mutation-conflict-11"
		question: "Mechanism mutation requested by multiple consumer BCs concurrently com conflicting requirements (NPM wants stricter scoring, REW wants looser) — qual protocol canonical?"
		impact:   "Cross-BC governance coordination. Conflict resolution sem protocol explicit leads to ad-hoc decisions."
		rationale: "Per cap-mechanism-governance-mutation-control + Phase 1.5.B mutation authority topology + cross-BC authority leakage patterns."
	}]

	verificationMetrics: [{
		id:     "vm-nim-zero-silent-mechanism-mutation"
		metric: "Count of mechanism mutations sem ADR-bound governance cycle"
		target: "0 occurrences canonical; ANY occurrence triggers L4 constitutional integrity containment review"
		onBreach: {
			escalationRef: "forbidden-mutation-attempt"
			rationale:     "Per C6 + C9 + cap-mechanism-governance-mutation-control. Silent mutation = governance bypass canonical."
		}
		rationale: "Mechanism mutation canonical é ADR-bound governance act; silent mutation = drift class #3 implicit policy creep materialized."
	}, {
		id:     "vm-nim-mechanism-gaming-detection-rate"
		metric: "Adversarial pattern detection rate per cap-adversarial-resistance-evaluation"
		target: "OBSERVED metric (NÃO optimization target). Sustained increase warrants analysis NÃO mechanism relaxation. **Lower detection count is NOT interpreted as lower adversarial activity** (per Phase 1.7 founder ajuste #3 — anti-antifraud-maturity-drift defense; redução artificial de sensibilidade vira drift de observabilidade canonical)."
		onBreach: {
			escalationRef: "active-adversarial-exploitation-detected"
			rationale:     "Per C8 + drift class #1 + as-nim-adversarial-sophistication-escalation-6. Detection rate é integrity preservation signal."
		}
		rationale: "Materializa drift class #1 + cap-adversarial-resistance-evaluation. Anti-fatigue framing canonical Family Mesh inheritance + explicit anti-antifraud-maturity-drift defense per founder Phase 1.7 ajuste #3."
	}, {
		id:     "vm-nim-authority-chain-reinforcement-prevention"
		metric: "Count of Pattern #2 cross-BC authority leakage detected (CRITICAL+ existential vector — authority chain reinforcement: score → legitimacy → policy → invisible governance substrate)"
		target: "0 canonical; ANY occurrence = constitutional review immediate (bypass normal pathways per Phase 1.6 ajuste #3)"
		onBreach: {
			escalationRef: "cross-bc-authority-leakage-pattern-detected"
			rationale:     "Per Phase 1.5.B Pattern #2 CRITICAL+ + Phase 1.6 ajuste #3. Drift mais perigoso do sistema inteiro."
		}
		rationale: "Materializa CRITICAL+ existential drift vector mechanically. Pattern #2 = mechanism → legitimacy → invisible governance substrate."
	}, {
		id:     "vm-nim-tier-boundary-integrity"
		metric: "Count of Tier 1 signals auto-promoted to Tier 2 sem Mechanism Execution Gate execution"
		target: "0 canonical; ANY occurrence indicates gate compromise"
		onBreach: {
			escalationRef: "mechanism-integrity-matrix-violation-class-a-to-e"
			rationale:     "Per C1 + bd-mechanism-execution-gate-as-constitutional-center. Gate bypass = sovereignty violation."
		}
		rationale: "Materializa Tier 1/Tier 1.Q/Tier 2 substrate separation mechanically (paralelo NTF Tier 1/Tier 2 separation integrity)."
	}, {
		id:     "vm-nim-interpretability-class-preservation"
		metric: "Count of mechanism outputs em opaque-blocked interpretability class"
		target: "0 canonical; warning at any non-inspectable-lineage emergence"
		onBreach: {
			escalationRef: "mechanism-integrity-matrix-violation-class-a-to-e"
			rationale:     "Per C15 + Phase 1.2 dimension #4. Opaque mechanism outputs = invisible governance + accountability erosion."
		}
		rationale: "Materializa C15 mechanism interpretability preservation mechanically."
	}, {
		id:     "vm-nim-recursive-loop-bounded-review-adherence"
		metric: "Count of recursive loops detected sem bounded review trigger when boundedReviewRequired=true"
		target: "0 canonical; ANY = governance bypass detected"
		onBreach: {
			escalationRef: "recursive-loop-bounded-review-trigger"
			rationale:     "Per C11 + CC6 + Phase 1.5.B Section B loop marker mechanics. Bounded review bypass = reflexive governance defense erosion."
		}
		rationale: "Materializa CC6 recursive epistemological governance explicitness mechanically."
	}, {
		id:     "vm-nim-lineage-integrity"
		metric: "Count of lineage truncation OR aggregation OR opacity OR rewriting events (4 forbidden cases Phase 1.5.B Section E)"
		target: "0 canonical; ANY = Class C/D violation + forensic protocol"
		onBreach: {
			escalationRef: "lineage-rewriting-detected"
			rationale:     "Per C4 + C15 + Phase 1.5.B Section E + Phase 1.5.B ajuste #5 lineage rewriting forbidden case #4."
		}
		rationale: "Materializa mechanism lineage propagation discipline canonical mechanically."
	}, {
		id:     "vm-nim-forbidden-mutation-attempt-rate"
		metric: "Count of 4 FORBIDDEN mutation proposals rejected at submission"
		target: "OBSERVED (NÃO optimization target). Sustained pattern indicates institutional pressure requiring governance review."
		onBreach: {
			escalationRef: "mechanism-mutation-classification-rejection-pattern"
			rationale:     "Per cap-mechanism-governance-mutation-control + 4 FORBIDDEN canonical. Sustained attempts = institutional drift signal."
		}
		rationale: "Anti-fatigue framing canonical — rejection rate é institutional pressure signal NÃO operational metric."
	}, {
		id:     "vm-nim-legitimacy-accumulation-monitoring"
		metric: "Count of cross-BC consumption patterns approaching universal-substrate-substitution threshold (pre-hegemonic drift trajectory monitoring per Phase 1.7 forward observation #6 Legitimacy accumulation risk)"
		target: "OBSERVED; tracks pre-hegemonic drift trajectory canonical"
		onBreach: {
			escalationRef: "cross-bc-authority-leakage-pattern-detected"
			rationale:     "Per Phase 1.7 forward observation #6 + Phase 1.6 misalignment #7 + Phase 1.5.B Pattern #3 universal substrate convergence."
		}
		rationale: "Materializa Legitimacy accumulation risk monitoring mechanically. Captures pre-hegemonic drift trajectory antes de Pattern #2/#3 critical materialization."
	}, {
		id:     "vm-nim-objective-function-drift-detection"
		metric: "Count of mechanism mutations correlating com target substitution patterns (proxy substitution detection — quality→engagement, reliability→response rate, epistemic confidence→throughput, trustworthiness→popularity)"
		target: "OBSERVED; tracks drift class #9 objective-function drift surface"
		onBreach: {
			escalationRef: "forbidden-mutation-attempt"
			rationale:     "Per C13 + drift class #9 + 4th FORBIDDEN canonical (objective-function substitution). Substitution patterns = covert governance transformation."
		}
		rationale: "Materializa drift class #9 objective-function drift mechanically + 4th FORBIDDEN mutation surface detection."
	}]

	rationale: """
		Bounded context canvas: Network Intelligence & Mechanism Design.
		NIM é mechanism integrity guardian over epistemic substrate —
		preservation infrastructure paralelo arquitetural ao FCE
		(constitutional infrastructure for economic convergence) e NTF
		(constitutional infrastructure for admissibility integrity), com
		extension qualitativamente nova como primeiro guardian META-
		constitucional da Mesh.

		=========================================================================
		Section 1 — IDENTITY PRESERVATION CANONICAL
		=========================================================================

		NIM é mechanism integrity guardian over epistemic substrate
		(charter Phase 1.0 canonical). Preserva integridade dos
		mecanismos algorítmicos (scoring, matching, ranking, incentives,
		penalties, governed-suggestions) que governam comportamento de
		rede sob pressão de gaming, manipulação, pseudo-objectivity
		collapse, e covert policy drift.

		Anti-goals canonicalmente declarados (11 total — 4 subdomain +
		5 Phase 1.1 + 2 founder NEW): NÃO é scoring service / NÃO é
		recommendation API / NÃO é ML platform / NÃO é learning system
		genérico / NÃO é fraud detection layer / NÃO é A/B testing
		platform / NÃO é CRM analytics / NÃO é engagement intelligence
		engine / NÃO é truth engine / NÃO é autonomous policy optimizer
		/ NÃO é qualificação de participantes (NPM) / NÃO é precificação
		de risco (REW) / NÃO é monitoramento ambiental (ext-monitoring-
		systems) / NÃO é seleção estratégica de fornecedores (SSC).

		Mechanisms são governance artifacts, NOT optimization artifacts
		(canonical clause foundation per Phase 1.1 founder ajuste).

		=========================================================================
		Section 2 — FAMILY MESH EXTENSION + META-CONSTITUTIONAL FRAMING
		=========================================================================

		FCE: semantic integrity of economic convergence.
		NTF: admissibility integrity of communication guarantees.
		NIM: mechanism integrity over epistemic substrate.

		NIM introduz padrão Family Mesh qualitativamente novo:
		'Governance over governance-producing mechanisms'. Protected
		object NÃO é fluxo OR contrato OR admissibilidade OR operação
		— é autoridade epistemológica emergente que outros BCs
		eventualmente consomem como substrate de suas próprias decisões.
		NIM emerge como primeiro guardian META-constitucional da Mesh.

		Pattern hierarchy emergente:
		- BC operacional → governa decisões locais
		- BC constitucional (FCE/NTF/NIM) → governa integrity surfaces
		- BC META-constitucional (NIM emerging) → governa substrate que
		  produz authority em outros domínios

		Same Family Mesh posture canonical (refusal-centered + evidence-
		grounded + anti-degradation + governance-cannot-self-weaken) com
		different protected substrates. NIM-specific addition: recursive
		epistemological governance discipline canonical.

		=========================================================================
		Section 3 — BIDIRECTIONAL EPISTEMIC FEEDBACK TOPOLOGY
		=========================================================================

		NIM é única camada com dependência bidirecional por design —
		consome sinais de todos BCs operacionais e produz mechanism
		artifacts consumidos cross-BC. Esta topology introduz 2 unique
		drift risks structural:

		- REFLEXIVE GOVERNANCE RISK: mechanism altera ambiente que
		  produz sinais que alimentam o próprio mecanismo (recursive
		  reinforcement) — defended via cap-feedback-loop-detection +
		  CC6 + escape path #5.
		- EPISTEMIC MONOCULTURE RISK: todos BCs convergem para 'o
		  score já decidiu' como substituto epistemológico universal —
		  mata contextual review + bounded authority + provenance
		  separation + uncertainty preservation downstream. Defended
		  via C12 + Phase 1.5.B Pattern #3.

		Bidirectional dependency é characteristic identity explícita —
		NÃO accident operacional. Pattern arquitetural canonical.

		=========================================================================
		Section 4 — 9 DRIFT CLASSES EM 3 FAMILIES
		=========================================================================

		Constitutional drift vectors (top severity per Phase 1.1 founder
		ajuste #3 promotion):
		 1. Mechanism gaming — adversarial actors manipulating scoring
		    algorithms (Goodhart operationalized)
		 2. Pseudo-objectivity collapse — algorithmic outputs treated
		    as objective truth
		 3. Implicit policy creep — mechanism mutations becoming covert
		    policy changes sem governance review
		 4. Objective-function drift (NEW per Phase 1.1 founder ajuste
		    #5) — optimization target slowly diverges from declared
		    constitutional objective via local metric substitutions

		Recursive-system drift vectors:
		 5. Reputation drift — historical reputation diverging from
		    current performance
		 6. Feedback loop drift — system reinforcing its own outputs
		    (materializes reflexive governance risk)
		 7. Authority delegation drift — consumers consumindo scores
		    como decision substitute (materializes epistemic monoculture
		    risk)
		 8. Provenance erosion — signals losing metadata over time

		Optimization gravity drift:
		 9. Engagement gravity — popularity-as-quality optimization

		Grouping em 3 families per Phase 1.1 founder ajuste #3 prepara
		escalation severity calibration + governance envelope + future
		drift metrics.

		=========================================================================
		Section 5 — 15 CONSTITUTIONAL CLAUSES C1-C15
		=========================================================================

		C1  — Mechanism authority sovereignty
		C2  — Mechanisms are governance artifacts, NOT optimization artifacts
		C3  — Algorithmic-output-is-signal-not-decision
		C4  — Provenance preservation (source + time + epistemic-class)
		C5  — Reputation is emergent NOT assigned
		C6  — No-implicit-policy / mechanism mutation ADR-bound
		C7  — Refuse rather than degrade (mechanism integrity refusal)
		C8  — Anti-gaming structural defense
		C9  — NOT autonomous policy optimizer
		C10 — Bidirectional epistemic feedback topology — explicit identity
		C11 — Anti-reflexive-governance (recursive reinforcement defended)
		C12 — Anti-epistemic-monoculture (substrate diversity defended)
		C13 — Anti-objective-function-drift
		C14 — No-universal-score-authority
		C15 — Mechanism interpretability preservation

		Cross-class reinforcement matrix:
		- C1 (sovereignty) ↔ C8 (anti-gaming) ↔ C14 (no-universal):
		  authority sovereignty cluster
		- C4 (provenance) ↔ C5 (emergent reputation) ↔ C15
		  (interpretability): substrate hygiene cluster
		- C9 (NOT autonomous) ↔ C6 (no-implicit-policy) ↔ C13 (anti-
		  objective-drift): governance discipline cluster
		- C10 (bidirectional) ↔ C11 (anti-reflexive) ↔ C12 (anti-
		  monoculture): recursive governance cluster

		Per Phase 1.7 founder ajuste #6: C1-C15 stays — legitimacy
		accumulation remains forward observation NÃO promoted to
		constitutional clause (preserves hierarchy; clauses não viram
		observações; constitutional layer não infla semanticamente).

		=========================================================================
		Section 6 — 11 ANTI-GOALS EXPANDED + 6 CANONICAL MECHANISM TYPES
		=========================================================================

		11 anti-goals canonical: 4 subdomain (NPM/REW/monitoring/SSC) +
		5 Phase 1.1 (learning system / recommendation API / fraud
		detection / A/B testing / CRM analytics) + 2 founder NEW
		(NOT truth engine / NOT autonomous policy optimizer).

		6 canonical mechanism types: Scoring + Matching + Ranking +
		Incentive + Penalty + GovernedSuggestion (renamed from
		'Governed-recommendation' per Phase 1.2 ajuste #2 — evita
		gravidade semântica de recommendation engine).

		Epistemic substrate canonical:
		- Tier 1   : Signal Substrate (append-only)
		- Tier 1.Q : Exogenous Signal Quarantine (per Phase 1.2 ajuste
		             #4 — exogenous signals NÃO enter Tier 1 directly)
		- Tier 2   : Mechanism Artifact Substrate (outputs + versions +
		             lineage + authority + validity envelope — per
		             Phase 1.2 ajuste #3 naming)
		- Gate     : Mechanism Execution Gate (constitutional center)
		- Matrix   : Mechanism Integrity Matrix (5 violation classes
		             A-E — Class E feedback-loop violation per Phase
		             1.2 ajuste #5)

		7 substrate invariants: append-only signal + provenance
		preservation + identity immutability + temporal causal ordering
		+ weighting lineage explicit + source diversity preserved +
		audit chain integrity.

		8 mechanism dimensions: input substrate + output type +
		authority surface + interpretability class + mutation governance
		+ temporal validity + replay semantics + adversarial-resistance-
		class (8th NEW per Phase 1.2 ajuste #1).

		=========================================================================
		Section 7 — 7 INCENTIVE MISALIGNMENTS + 14 CAPABILITIES
		=========================================================================

		7 incentive misalignments canonical (per Phase 1.6 6 + Phase 1.6
		ajuste #1 Mechanism Legitimacy Capture NEW — pre-hegemonic
		drift): adversarial gaming + institutional improvement + consumer
		delegation + participant reputation manipulation + regulatory
		algorithmic accountability + governance evolution + mechanism
		legitimacy capture. Densidade superior vs FCE/NTF reflete NIM
		constitutional complexity.

		14 capabilities canonical (per Phase 1.3 13 + Phase 1.5 cap-
		mechanism-governance-mutation-control emergence):

		Substrate operations (3): signal-substrate-ingestion + exogenous-
		signal-quarantine + mechanism-artifact-substrate-maintenance.

		Mechanism Execution Gate (1 — constitutional center): mechanism-
		execution-gate.

		Mechanism execution caps (6 — one per mechanism type, per Phase
		1.3 founder ajuste #2 separação preserves bounded authority
		auditability): scoring + matching + ranking + incentive + penalty
		+ governed-suggestion execution.

		Governance + defensive caps (4): mechanism-authority-boundary-
		enforcement + feedback-loop-detection + adversarial-resistance-
		evaluation (Phase 1.3 ajuste #4) + mechanism-governance-mutation-
		control (Phase 1.5 emergence).

		Critical observation per Phase 1.4 founder framing: cap-
		adversarial-resistance-evaluation + cap-mechanism-governance-
		mutation-control = 2 antídotos centrais contra colapso típico de
		sistemas algorítmicos:
		- gaming = ataque externo ao mecanismo
		- policy creep = mutação interna de autoridade sem
		  reconhecimento institucional

		=========================================================================
		Section 8 — 5-TUPLE DISCIPLINE CANONICAL
		=========================================================================

		Every capability producing mechanism output declares explicit
		5-tuple authority boundary:
		- mechanismType
		- consumerBCs
		- authoritySurface
		- forbiddenInterpretations
		- escapePaths

		Per Phase 1.4 founder decision: 5-tuple permanece textual no
		Canvas; structural materialization deferida a Phase 3 (domain-
		model commands/services) + Phase 4 (agent-spec actions); future
		ADR formalization quando ≥2 BCs require pattern (paralelo
		ADR-088 MCM expansion gate pattern).

		7 universal forbidden interpretations cross-mechanism (per
		Phase 1.2.B Section C): universal score substrate + opaque
		inference + autonomous decision substitution + personalization
		gravity + truth claim collapse + authority extension + feedback
		loop blindness.

		6 escape pathway classes canonical (per Phase 1.2.B Section D
		+ Phase 1.2.B founder ajuste #3): insufficient signal + conflicting
		mechanism + stale mechanism + authority overflow + feedback loop
		+ provenance degradation.

		=========================================================================
		Section 9 — CC1-CC6 COMMUNICATION CLAUSES + 5-CATEGORY DISCIPLINE
		=========================================================================

		CC1 — Mechanism integrity facts only
		CC2 — Refusal canonical first-class
		CC3 — Provenance + authority boundary preserved
		CC4 — Mechanism mutation lifecycle explicit
		CC5 — Adversarial + feedback markers explicit
		CC6 — Recursive Epistemological Governance Explicitness (NEW
		      per Phase 1.5 founder ajuste #2 — closes feedback loop +
		      authority delegation + objective-function drift + epistemic
		      monoculture)

		5-category communication discipline canonical (per Phase 1.5
		founder ajuste #1): signal-ingestion + mechanism-consumption +
		governance-feedback + mutation-authority + audit-observability.
		37 communication entries (21 inbound + 16 outbound) classified
		per category.

		Per Phase 1.7 forward observation #1: mutation-authority NÃO é
		apenas categoria operacional — é início de futura separação
		entre governance traffic + operational traffic + constitutional
		traffic. Hoje aparece como categoria de comunicação; no futuro
		provavelmente vira classe de autoridade.

		=========================================================================
		Section 10 — 3-TIER GOVERNANCE SCOPE + MUTATION TOPOLOGY
		=========================================================================

		Autonomous (8 deterministic protocol execution decisions) +
		Supervised (6 canonical change decisions) + Escalation (10
		criteria — constitutional integrity containment per Phase 1.6
		ajuste #2; NÃO operational incident).

		Mutation classification asymmetric: 10 rows canonical (additive
		operational reviewer → architectural reviewer semantic →
		founder-only identity-altering → 4 FORBIDDEN constitutional
		core não-negociável):

		4 FORBIDDEN canonical:
		1. Adversarial-resistance-class downgrade
		2. 5-tuple field removal
		3. Interpretability class relaxation (downgrade to opaque-blocked)
		4. Objective-function substitution

		Pathway taxonomy (per Phase 1.5.B mutation authority topology):
		- ADR-bound (architectural reviewer)
		- parallel-SRR (architectural reviewer + 30-day observation)
		- observation-cycle-90d (founder-only + ADR + SRR)
		- observation-cycle-180d-critical (founder-only + ADR + SRR +
		  forensic-integrity-reviewer-equivalent) — replay-sensitive +
		  recursive-feedback + cross-BC-authority + adversarial-
		  resistance-critical mechanisms (per Phase 1.5 ajuste #4 +
		  Phase 1.5 ajuste #4 critical domain expansion).

		Trigger #3 (authority chain reinforcement CRITICAL+) explicitly
		bypassa pathways normais + direct constitutional review pathway
		per Phase 1.6 ajuste #3 — drift mais perigoso do sistema
		inteiro (mechanism → legitimacy → invisible governance
		substrate).

		=========================================================================
		Section 11 — 4 ANTI-DRIFT CLAUSES INHERITED (defense in depth)
		=========================================================================

		Anti-routing-optimization (paralelo NTF Phase 5.1) — protege
		topology.

		Anti-metric-gaming (paralelo NTF Phase 5.2) — protege
		observability. Plus NIM-specific: 'Lower detection count is NOT
		interpreted as lower adversarial activity' (per Phase 1.7
		founder ajuste #3 — anti-antifraud-maturity-drift defense).

		Anti-fatigue (paralelo NTF Phase 5.2 duplo: inline + central)
		— protege semantics.

		Governance-cannot-self-weaken (paralelo NTF Phase 5.0 + Family
		Mesh inheritance + meta-imunological clause) — protege o próprio
		sistema imune. Aplicação NIM-specific: includes recursive
		epistemological governance preservation (per CC6).

		=========================================================================
		Section 12 — MECHANISM GOVERNANCE BECOMES CONSTITUTIONAL GOVERNANCE
		=========================================================================

		Per Phase 1.6 ajuste #4 graduated formulation:

		'Mechanism governance becomes constitutional governance when
		mechanism outputs influence network-wide authority topology.'

		Nem toda mutation é constitucional; algumas inevitavelmente se
		tornam, quando crossing authority topology threshold. NIM
		mutation governance therefore inherits constitutional posture
		canonical AND adds recursive epistemological governance
		discipline — preparing pathway constitutional-split-review
		forward evolution candidate when mutation governance + operational
		governance require structural separation.

		Em NIM:
		- mudar mecanismo = mudar política
		- mudar weighting = redistribuir poder
		- mudar objective function = alterar comportamento sistêmico
		  da rede

		Implication canonical: future architectural evolution may need
		two distinct governance envelopes for NIM (operational +
		constitutional-mutation), OR mutation governance promoted to
		standalone meta-BC.

		The primary risk is not explicit authoritarian control, but
		gradual epistemic dependency normalization. (Per Phase 1.7
		founder ajuste #5 — provavelmente frase mais importante do BC
		inteiro; captura hegemonia epistemológica emergente + naturalização
		do score + invisibilidade do drift + legitimidade acumulada +
		recursive governance collapse.)

		=========================================================================
		Section 13 — 6 FORWARD-CANONICAL OBSERVATIONS
		=========================================================================

		(a) mutation-authority traffic category → future authority class
		    separation (Phase 1.5.B founder ajuste #1)

		(b) constitutional-split-review pathway forward evolution
		    candidate (Phase 1.5.B founder ajuste #3) — quando algumas
		    mutações em NIM deixam de ser evolução operacional e passam
		    a ser mudança constitucional da rede

		(c) Governance evolution as governed domain object: 'NIM may
		    become the first Mesh BC where governance evolution itself
		    becomes a governed domain object' (Phase 1.5.B founder
		    ajuste #7) — governance deixa de ser só metacamada e passa
		    a ser parcialmente operacionalizada como substrate explícito

		(d) Mutation governance + operational governance structural
		    separation candidate (Phase 1.5 founder ajuste #5) — em
		    NIM, mudar mecanismo = mudar política; mudar weighting =
		    redistribuir poder; mudar objective function = alterar
		    comportamento sistêmico da rede

		(e) Recursive audit 3-layer separation (temporal + causal +
		    epistemic) forward-note (Phase 1.5.B founder ajuste #6) —
		    loops recursivos quebram auditoria linear simples

		(f) Legitimacy accumulation risk (Phase 1.6 founder ajuste #5
		    NEW): 'As mechanism adoption scales, repeated cross-BC
		    consumption may gradually transform operational usefulness
		    into implicit institutional legitimacy, creating pressure
		    toward universal epistemic authority.' Amarra monoculture
		    + authority reinforcement + recursive governance +
		    constitutional split + legitimacy capture + invisible policy
		    emergence.

		=========================================================================
		Section 14 — NIM-SPECIFIC GOVERNANCE POSTURE + META-CONSTITUTIONAL
		=========================================================================

		Family Mesh inheritance canonical (refusal-centered + evidence-
		grounded + anti-degradation + governance-cannot-self-weaken) +
		NIM-specific addition (recursive epistemological governance
		discipline canonical).

		META-CONSTITUTIONAL FRAMING CANONICAL (per Phase 1.7 founder
		architectural observation):

		NIM introduces qualitatively new Family Mesh pattern beyond
		FCE/NTF: 'Governance over governance-producing mechanisms'.

		- FCE protege convergência (semantic integrity of economic
		  decisions)
		- NTF protege admissibilidade (admissibility integrity of
		  communication guarantees)
		- NIM protege legitimidade epistemológica do sistema inteiro
		  (mechanism integrity over epistemic substrate que produz
		  authority em outros domínios)

		NIM emerge como primeiro guardian META-constitucional da Mesh —
		seu protected object NÃO é fluxo OR contrato OR admissibilidade
		OR operação, mas autoridade epistemológica emergente que outros
		BCs eventualmente consomem como substrate de suas próprias
		decisões.

		Pattern precursor relevante quando: (a) meta-governance emerge
		canonical; (b) BCs disputam weighting authority; (c) mutation
		governance deixa de caber em envelope operacional único.

		Governance hierarchy emergente:
		- BC operacional → governa decisões locais
		- BC constitucional (FCE/NTF/NIM) → governa integrity surfaces
		- BC META-constitucional (NIM emerging) → governa substrate que
		  produz authority em outros domínios

		=========================================================================
		Section 15 — PHASE 1 CLOSURE + WI-045 CASCADE
		=========================================================================

		Canvas Phase 1 closed via section-by-section authoring per
		manualAuthoringProtocol (adr-057) em 9 sub-phases iterativas
		com founder review pre-write integrated:

		- Phase 1.0 charter constitutional (4 ajustes + OP8 inheritance)
		- Phase 1.1 identity + classification + drift classes baseline
		  + C1-C13 (4 ajustes)
		- Phase 1.2 mechanism types + substrate model (5 ajustes +
		  Tier 1.Q quarantine + Violation Class E + GovernedSuggestion
		  naming + Mechanism Artifact Substrate naming + 8th dimension
		  adversarial-resistance-class)
		- Phase 1.2.B authority boundary review (4 ajustes — FCE/DLV
		  limited consumers + provenance degradation escape path #6 +
		  count fix 7 forbidden interpretations + capability discipline
		  5-tuple mandatory)
		- Phase 1.3 capabilities derived (5 ajustes — 13 capabilities
		  + cap-adversarial-resistance-evaluation NEW + Phase 1.5
		  emergence cap-mechanism-governance-mutation-control declared
		  + 5-tuple formalization decision + 6 mechanism execution
		  caps separation + 3 substrate caps preserved)
		- Phase 1.4 businessDecisions + stakeholders + costs (5 ajustes
		  — 5-tuple textual canonical Phase 3/4 deferred + bd reorder
		  bounded-authority before gate + 6th stakeholder downstream BC
		  consumers + ce-NIM-02 reframed governance cost intentionally
		  paid + cap-mechanism-governance-mutation-control Phase 1.5
		  explicit emergence)
		- Phase 1.5 communication + CC clauses + cap #14 emergence (5
		  directional ajustes — 5-category communication discipline +
		  CC6 NEW + 10+4 FORBIDDEN mutation classification + 180-day
		  cycle critical candidates expanded + Phase 1.5.B confirmation)
		- Phase 1.5.B recursive governance refinement (7 ajustes —
		  mutation-authority forward observation + loopRiskClass field
		  + constitutional-split-review pathway forward candidate +
		  Pattern #2 CRITICAL+ existential marking + 4th forbidden
		  lineage-rewriting + recursive audit 3-layer separation
		  forward note + governance evolution as governed domain
		  object NEW forward observation)
		- Phase 1.6 incentiveAnalysis + governanceScope (5 ajustes —
		  7th incentive Mechanism Legitimacy Capture pre-hegemonic +
		  Tier 3 = constitutional integrity containment NÃO operational
		  incident + Trigger #3 explicit constitutional review bypass
		  + Governance posture clause graduada + 6th forward-canonical
		  Legitimacy accumulation risk)
		- Phase 1.7 assumptions + openQuestions + verificationMetrics
		  + outer rationale (7 ajustes — as-nim-adversarial-sophistication-
		  escalation-6 NEW + #2/#3/#5 marked constitutional evolution
		  surfaces + vm-mechanism-gaming-detection-rate enhanced anti-
		  antifraud-maturity-drift clause + outer rationale reorder +
		  Section 13 final canonical clause + C1-C15 stay + file size
		  acceptable)

		Total ~57 founder ajustes integrated batch-by-batch across 9
		sub-phases (densidade superior vs FCE WI-043 + NTF WI-063
		bootstraps — reflete NIM constitutional complexity).

		Phase 1.8 (SRR srr-nim-canvas) closes Phase 1. Phase 2-5
		cascade (glossary + domain-model + agent-spec + governance
		envelope) close WI-045 NIM bootstrap — paralelo Family Mesh
		canonical inheritance pattern (FCE WI-043 closed 52fb840 + NTF
		WI-063 closed 491417f).

		Identity gravity preserved: NIM é mechanism integrity guardian
		over epistemic substrate — primeiro guardian META-constitucional
		da Mesh, NÃO scoring service / recommendation API / ML platform
		/ engagement intelligence engine. Mechanisms são governance
		artifacts, NOT optimization artifacts.

		'The primary risk is not explicit authoritarian control, but
		gradual epistemic dependency normalization.' (Phase 1.7 ajuste
		#5 canonical — provavelmente frase mais importante do BC
		inteiro.)
		"""
}
