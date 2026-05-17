package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr089: artifact_schemas.#ADR & {
	id:    "adr-089"
	title: "Add 'observation' action category to #ActionCategory enum"
	date:  "2026-05-17"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/agent-spec.cue",
		"architecture/production-guides/agent-spec.cue",
	]

	context: """
		Durante WI-045 NIM Phase 4.0 Section 1 (scope-and-action-catalog)
		authoring, founder identificou gap constitucional: NIM Primary Agent
		opera surveillance contínua sobre authority topology cross-aggregate
		(11 aggregates + 19 cross-aggregate dependencies + drift detection
		via 10 projections + Cluster E enforcement runtime). Esta surveillance
		é qualitatively distinta de query reativa pontual.

		Founder direction (literal Section 1 ajuste #7): "NIM não é apenas
		query/reactive. Ele mantém vigilância constitucional contínua. Sem
		isso, o modelo operacional implicitamente reduz surveillance a
		polling manual."

		Schema atual #ActionCategory enum strict = {query, mutation, validation,
		generation, escalation}. NIM agent actions de surveillance (e.g.,
		act-observe-authority-topology-drift) podem ser misclassified como
		query — collapsing constitutional distinction entre:
		(a) reactive read pontual triggered por explicit invocation; vs
		(b) continuous/event-driven surveillance running without explicit
		    external invocation (autonomous monitoring of topology state).

		Risk vectors sem formalização:
		(R1) Surveillance dissolved em query category produz drift implícito:
		     observers reclassified como manual queries; continuous monitoring
		     degraded to polling discipline.
		(R2) Schema-anchor absence: structural-check post-commit + validation-
		     prompts não podem distinguish observation discipline de query
		     reactivity sem field discriminante.
		(R3) Cross-BC pattern collapse: outros BCs com runtime surveillance
		     needs (FCE drift detection, NTF admissibility monitoring) herdam
		     mesmo gap silent.
		(R4) Constitutional design intent erosion: surveillance é design
		     intent estructural canonical (NIM META-constitutional natureza
		     requires continuous monitoring), NÃO implementation detail.

		Founder constitutional argument: NIM Phase 3 protected object é
		ontology formation; Phase 4 protected object é what agent is
		authorized to do over the existing ontology. Continuous surveillance
		é canonical agent capability category — adjacent to query mas
		semantically distinct.
		"""

	decision: """
		ADOPT additive enum extension a #ActionCategory:

		(D1) ADD "observation" value a #ActionCategory enum em
		architecture/artifact-schemas/agent-spec.cue. Position canonical:
		segundo valor (after query, before mutation) reflecting semantic
		adjacency a query (both read-domain) mas distinct (continuous vs
		reactive).

		(D2) ENDURECER schema docstring para observation com trigger
		independence canonical:

		"Continuous or event-driven surveillance that MAY trigger without
		explicit invocation; does not directly mutate domain state. Per
		ADR-089: observation actions MUST NOT require explicit external
		invocation to execute (trigger independence canonical)."

		Trigger independence canonical é defining property — observation
		que SÓ executa quando externally invoked é misclassified (deveria
		ser query). Trigger pode ser scheduler-driven, event-driven, OR
		invariant-trigger-driven; explicit external invocation NÃO é
		admissible single trigger.

		(D3) NON-EXAMPLES canonical declarados (founder direction ajuste #2:
		"sem negativo, o sistema vira: se parece com observation, é
		observation"):

		Non-example 1:
		- Description: "Manual read triggered by user request"
		- Classification: query
		- Rationale: reactive, requires explicit invocation; trigger
		  é human user → fails trigger independence canonical

		Non-example 2:
		- Description: "Scheduled job that only runs when invoked externally"
		- Classification: query
		- Rationale: external invocation requirement disqualifies; not
		  autonomous surveillance

		Non-example 3:
		- Description: "Batch recompute triggered by command"
		- Classification: mutation
		- Rationale: state-changing operation, not observation; even
		  scheduled, command-triggered mutation classifies por effect,
		  NÃO por trigger pattern

		Non-example 4 (canonical NIM boundary case):
		- Description: "Polling job consulting projection on operator demand"
		- Classification: query
		- Rationale: operator-on-demand falls trigger independence test;
		  reactive read pattern, NÃO continuous surveillance

		(D4) FUTURE ENFORCEMENT CLAUSE (advisory layer):

		Validation-prompts/validate-agent-spec.cue (future amendment cycle)
		SHOULD include check:
		- For each actions[] with category="observation", verify trigger
		  declaration in rationale OR future trigger field indicates
		  independence from explicit external invocation
		- For each actions[] with category="query", verify trigger requires
		  explicit invocation (mirror check)

		Future enforcement materializa via validation-prompt amendment +
		structural-check post-WI-068 (when agent-spec structural-checks
		coverage materialized). NÃO bloqueia esta ADR — declarative
		obligation registered.

		(D5) PG editorial update em architecture/production-guides/agent-
		spec.cue: 5→6 canonical category list updated em 2 locations
		(scope-and-action-catalog section process + finalValidation step).
		Editorial only (não-semantic) — propagates new enum value para
		PG canonical references.

		Pattern paralelo ADR-088 (autonomyLevel "mechanically-compelled"
		additive extension): same shape de schema enum delta + ADR
		canonical anchor + non-breaking additive extension.
		"""

	consequences: """
		- Schema #ActionCategory enum expandido 5→6 values (additive, non-breaking para existing instances).
		- Existing agent-specs (cmt/ctr/npm/ntf primary agents) unchanged — não usam observation; additive enum extension não invalida instances pre-existentes.
		- NIM Phase 4.0 Section 1 desbloqueado: act-observe-authority-topology-drift + future observation actions classifiable canonical.
		- Future BCs (FCE retroactive opcional + outros pendentes) gain canonical pathway para surveillance discipline distinct from query.
		- PG agent-spec.cue editorial update propagates new category to canonical references (5→6 locations).
		- Validation-prompts/validate-agent-spec.cue future amendment cycle: trigger independence check declarative obligation (D4).
		- Structural-checks coverage gap (post-WI-068): observation discipline enforcement gain candidate field para structural validation.
		- Cluster E semantic hardening precedent: 'observation ≠ query' é canonical distinction analog a 'GovernedSuggestion ≠ Recommendation' Phase 3 founder canonical pattern.
		- Drift prevention canonical: schema-anchor previne reclassification creep ('observation que só roda quando chamada' silently degraded to query).
		"""

	principlesApplied: [
		"P0-zero-duplication",
		"P10-stochastic-vs-deterministic — schema-anchor permite structural enforcement future, agent advisory layer",
		"adr-040-structural-vs-semantic-validation-separation — D4 future enforcement clause reflects deterministic gate (structural-check) + advisory layer (validation-prompt) separation",
		"adr-088-formalize-mcm-execution-class — precedent canonical: additive enum extension via ADR for constitutional design intent that needs schema anchor",
	]

	rationale: """
		Reversibility medium: schema addition é additive enum extension
		(non-breaking para instances pre-existentes). Revert requires
		enum value removal + instance updates onde observation declared.
		Future enforcement (validation-prompt + structural-check) é
		advisory layer — não bloqueia revert.

		BlastRadius cross-artifact: afeta agent-spec.cue schema + agent-
		spec PG + future agent-spec instances using observation category
		(NIM primary agent + retroactive opcional FCE). Não cross-cutting:
		structural-checks + CI workflows não requerem changes neste commit
		(enforcement futuro post-WI-068 via mecanismo existente).

		Decisão prioriza CONSTITUTIONAL DISTINCTION OVER CATEGORICAL
		PARSIMONY:
		- Founder Section 1 ajuste #7 explicit: surveillance constitucional
		  contínua é design intent estructural, NÃO query reactive pontual.
		- Trigger independence canonical (D2) é defining property —
		  permite structural validation future (validation-prompt detection
		  of misclassification).
		- Non-examples canonical (D3) previnem semantic drift: sem
		  negativos enumerados, sistema deriva para "se parece com
		  observation, é observation" — drift inevitable.
		- Future enforcement clause (D4) registra obligation sem blocking
		  esta ADR: pattern adr-040 advisory layer.

		Family Mesh constitutional design pattern:
		FCE WI-043 estabeleceu refusal-as-success canonical via state
		machine. NTF WI-063 estabeleceu admissibility-as-sovereignty via
		certification gate. NIM WI-045 estabelece mechanism integrity
		over epistemic substrate via authority topology + drift detection.
		ADR-089 extends agent design constitutional discipline: surveillance
		discipline é structural property, NÃO operational convention.

		Pattern canonical: "continuous observation OR reactive query —
		jamais surveillance dissolved into query via silent reclassification".

		Cascade ordering preservado:
		Schema delta + PG editorial + ADR + 2 SRRs (este commit) → NIM
		Phase 4.0 Section 1 resumes → Section 2-3 + governance.cue
		pursuant WI-045 closure → future FCE/NTF amendment cycle if
		retroactive observation actions emerge.

		Future enforcement obligation tracking:
		- Validation-prompt amendment (post-WI-068 agent-spec coverage):
		  trigger independence check para observation OR query
		  classification merit
		- Structural-check coverage: observation discipline validation
		  via reference-exists kind (e.g., trigger declaration field
		  presence)
		- Both deferred per cascade ordering — não bloqueiam esta ADR
		"""
}
