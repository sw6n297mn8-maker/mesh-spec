package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr091: artifact_schemas.#ADR & {
	id:    "adr-091"
	title: "Strategic Alignment Guardrail — deterministic category and schema"
	date:  "2026-05-21"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/strategic-alignment-guardrail.cue",
	]

	plannedOutputs: [
		"architecture/strategic-alignment-guardrails/",
	]

	context: """
		ADR-090 D3 autorizou criação da categoria "Strategic Alignment
		Guardrail" paralela a structural-check, quality-gate e policy.
		Categoria preenche gap entre validators existentes:

		- structural-check valida shape sintática de artifacts
		- quality-gate valida qualidade interna de autoria
		- policy valida workflow de governance
		- (gap) coerência evolutiva entre strategic intent declarado e
		  materialização nos artifacts do BC

		Este ADR materializa schema canonical da nova categoria com
		escopo limitado a deterministic constraints (identity,
		capability, abstraction). Heuristic constraints (semantic drift,
		ontology sprawl, rationale depth) deferidos para ADR-094+ por
		instabilidade de métricas: risco de pseudo-precisão e governance
		performativa supera benefício atual.

		Cascade ordering com BC Identity Capsule (ADR-092 anticipated):
		schema deste guardrail referencia interface canonicalIdentity via
		identityCapsuleRef; ADR-092 materializará schema do Capsule
		conforme essa interface.
		"""

	decision: """
		D1 — CATEGORIA CANONICAL: introduzir Strategic Alignment Guardrail
		como categoria de governance paralela a structural-check,
		quality-gate e policy. Escopo Phase 1 limitado a deterministic
		constraints.

		D2 — SCHEMA #StrategicAlignmentGuardrail materializado em
		architecture/artifact-schemas/strategic-alignment-guardrail.cue
		com campos canonical: id (sag- prefix), name, description,
		appliesToBoundedContextRef, constraintClass, constraintKind,
		enforcementLevel, stability, identityCapsuleRef, checkSpec,
		onViolation, rationale.

		D3 — 3 DETERMINISTIC CONSTRAINT KINDS CANONICAL Phase 1:
		- constraintClass=identity, constraintKind=mismatch: role ou
		  semanticCenter declarado divergente do Capsule
		- constraintClass=capability, constraintKind=unauthorized-
		  expansion: capabilityRef em canvas/domain-model não
		  autorizada pelo Capsule
		- constraintClass=abstraction, constraintKind=forbidden-tier-
		  breach: tier semântico além do permitido pelo Capsule
		Todos stability=canonical Phase 1.

		D4 — ENFORCEMENT TIMING per ADR-090 D6 (constraints no caminho
		operacional):
		- hard-fail roda pre-materialization (durante autoria) OU
		  pre-merge (CI gate antes de merge)
		- soft-warn roda post-analysis como advisory
		- 4 onViolation valores canonical: block-pre-materialization,
		  block-pre-merge, emit-warning, escalate-to-founder
		Post-commit detection NÃO admissível como hard-fail — viola
		princípio P10 estendido (constraints precisam estar no caminho
		operacional, não detecção tardia).

		D5 — TRANSIÇÃO DE FASE com BC Identity Capsule (ADR-092):
		- Phase 1 (este ADR-091 only, sem Capsule schema materializado):
		  missing Capsule produz non-blocking warning. Guardrail roda
		  em modo informativo até Capsule schema existir.
		- Phase 2 (após ADR-092 materializar Capsule schema): missing
		  Capsule para BC alvo de bootstrap se torna hard-fail. Não
		  pode bootstrap BC sem Capsule declarado.
		Transição automática quando ADR-092 commit registra Capsule
		schema canonical.

		D6 — ESCOPO NON-INCLUDED EXPLICITO (deferred decisions registradas):
		- Heuristic constraints (semantic-center-drift, ontology-sprawl,
		  rationale-depth-overflow) deferidos para ADR-094+ por
		  instabilidade de métricas
		- Complexity Budget schema separado em ADR-093
		- BC Identity Capsule schema separado em ADR-092
		- Instâncias específicas por BC em commits subsequentes após
		  ADR-092 + ADR-093 materializados
		"""

	consequences: """
		Positive:
		- 3 deterministic constraint kinds cobrem failure modes core
		  observados em ADR-090 (identity escalation, capability
		  expansion, abstraction tier breach)
		- Schema permite extensibilidade futura para heuristic
		  constraints sem refactor (campo stability suporta
		  experimental kinds)
		- Lifecycle separation entre subdomain strategic e identity
		  capsule enforcement-anchor previne coupling circular
		- Branch isolada + PR separado preserva blast radius pequeno
		- Transição Phase 1 → Phase 2 explícita previne no-op
		  permanente (per ajuste founder)

		Negative:
		- Diretório novo a manter (architecture/strategic-alignment-
		  guardrails/)
		- Schema espera ADR-092 (Capsule schema) para tornar-se
		  totalmente operacional; Phase 1 funciona apenas em modo
		  warning
		- 3 deterministic kinds não cobrem todos os failure modes
		  observados em ADR-090; heuristic kinds ficam para ADR-094+
		- Enforcement requer integração futura no manualAuthoringProtocol
		  (ADR de amendment separado)
		- Bootstrap velocity decreases temporariamente até cascade
		  completar (ADR-091 → ADR-092 → ADR-093 → amendment)
		"""

	principlesApplied: [
		"P10-stochastic-vs-deterministic — deterministic kinds only Phase 1",
		"adr-040-structural-vs-semantic-validation-separation — guardrail é deterministic gate, não LLM advisory",
		"adr-088-formalize-mcm-execution-class — precedent: schema delta canonical via ADR",
		"adr-089-add-observation-action-category — precedent: additive constitutional extension",
		"adr-090-semantic-escalation-bc-bootstrap-reboot-authorization — autoriza criação desta categoria (D3)",
	]

	rationale: """
		Categoria preenche gap arquitetural identificado em ADR-090: PG +
		structural-check + quality-gate + policy não validavam coerência
		evolutiva entre strategic intent e materialização. Resultado foi
		escalada semântica em FCE/NTF/NIM v1.

		3 deterministic kinds (identity-mismatch, unauthorized-capability-
		expansion, forbidden-abstraction-tier-breach) derivam diretamente
		dos 3 failure modes core observados durante escalada de
		FCE/NTF/NIM. Heuristic kinds excluídos por instabilidade de
		métricas — risco de pseudo-precisão (semantic-drift métrica não
		robusta, ontology-sprawl thresholds não defensáveis) é maior
		que benefício atual.

		Cascade ordering com Capsule (ADR-092): criar o validador
		primeiro força o validado a se adequar à interface
		canonicalIdentity, não o contrário. Pattern reverso (Capsule
		primeiro sem validator) gera Capsule sem enforcement —
		governance-by-guidance que ADR-090 explicitly substituiu por
		governance-by-construction.

		Identity Capsule em strategic/identity-capsules/{bc}.cue, NÃO
		embedded em strategic/subdomains/{bc}.cue, per founder ajuste:
		- subdomain.cue é strategic declaration (intent original)
		- identity-capsule.cue é enforcement anchor (operational
		  envelope)
		- Lifecycle e cadence diferentes; coupling circular evitado

		Reversibility medium: schema é additive (não-breaking para
		artifacts existentes que não consomem guardrails). Revert exige
		remoção do schema + instâncias materializadas em commits
		subsequentes.

		BlastRadius cross-cutting: schema novo afeta categoria de
		governance (cross-artifact entre todos BCs futuros). Não
		repo-wide porque CI workflows e tooling não requerem changes
		neste commit (instâncias virão depois).

		Phase 1 → Phase 2 transition (D5) preserva non-no-op canonical:
		guardrail Phase 1 emite warning informativo enquanto Capsule
		schema não existe; transição automática para hard-fail quando
		ADR-092 materializa Capsule schema. Previne risco de "no-op
		buraco permanente" identificado por founder.

		Precedent ADR-088 + ADR-089: schema delta additive via ADR
		canonical para constitutional design intent precisando schema
		anchor. ADR-091 herda mesmo pattern.

		Cascade ordering preservado: este ADR materializa schema mas
		NÃO materializa instâncias. ADR-092 materializa Capsule schema;
		ADR-093 materializa Complexity Budget schema; amendment do
		manualAuthoringProtocol integra guardrails como pré-condição
		executável; só então instâncias específicas por BC.
		"""
}
