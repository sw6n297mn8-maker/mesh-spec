package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-013": artifact_schemas.#DeferredDecision & {
	id:    "def-013"
	title: "Maturação de tipagem para envelope governance: payloadSchema typed em #ObservabilitySignal + variants extensions em #ClearanceCondition; runtime evaluation engine como separação arquitetural"
	date:  "2026-05-06"

	description: """
		Caminho D' (adr-075, materializado em Phase 5 do WI-057
		P2P bootstrap) introduziu 3 schema additions optional para
		envelope governance: ObservabilitySignal payloadFields,
		RegressionTrigger scopedBySignal + clearanceCondition,
		EscalationRoute queue governance fields. As 3 additions
		resolvem fraquezas estruturais identificadas (actor-scoping
		runner-implicit, Tier 3 sem auto-effect, bounded wait sem
		queue governance) via composição de primitives existentes
		em vez de criar novos types.

		Phase 0 acknowledged limitations de tipagem que ficam para
		maturação futura quando padrão repetir cross-BC:

		(1) payloadFields é list-of-string (declara campos do payload
		    do signal) sem typed schema. Validação enforced é apenas
		    PRESENCE de campos; tipagem (e.g., requesterRef: string,
		    statisticalEvidence: struct) fica em prose do signal
		    description. Validação completa via PayloadType +
		    payloadSchema map fieldName-to-type é gap Phase 0 — runner
		    valida presence; type mismatch é caught por code review,
		    não pelo schema.

		(2) ClearanceCondition é discriminated union com 1 variant
		    Phase 0 (ClearanceByNoSignalInWindow). Outros patterns
		    operacionais comuns (clearance-by-metric-below-threshold,
		    clearance-by-duration-elapsed, clearance-by-manual-review)
		    serão modelados como variants futuros quando primeira
		    instância requisitá-los. Extension não-breaking via
		    discriminated union pattern (paralelo a DomainEvent +
		    DomainField extensions historicamente).

		(3) Runtime evaluation é externalizada do schema e tratada
		    como concern arquitetural separado por design. Schema
		    declara contracts (typed fields, discriminated unions,
		    fail-safe enums); runtime engine executa o que está
		    declarado — separation of concerns canônica entre policy
		    (declarativa) e enforcement (operacional). Phase 0
		    materializa schema-side; Phase 1+ runner materialization
		    implementa execution-side via WI-069 follow-ups. NÃO é
		    dívida implícita: é divisão de responsabilidades
		    sustentando Mesh principles (P10 gates determinísticos
		    validam — schema é o gate; runner é executor).

		Quando triggers fire, decidir entre:
		(a) promover payloadFields para typed shape (PayloadType
		    enum + payloadSchema map fieldName-to-type); migrar
		    signals existentes; estender tq-ag-XX para validar typing
		(b) adicionar variants em ClearanceCondition discriminated
		    union conforme cases concretos (extension não-breaking)
		(c) formalizar runtime evaluation engine em adr separado +
		    schema artifact (e.g., EnvelopeRuntimeEngine) com
		    interface contracts + WI materialization integrada
		    com Phase 1+ runner stack
		"""

	originatingArtifacts: [
		"architecture/artifact-schemas/agent-governance.cue",
		"architecture/artifact-schemas/agent-spec.cue",
		"contexts/p2p/agents/p2p-primary-agent.governance.cue",
	]

	deferralRationale: """
		Pattern ten-009 expand-when-needed: D' é primeira
		instância dos 3 patterns (signal-as-contract +
		clearanceCondition + queue governance inline). Outros
		envelopes existentes (CMT/CTR/IDC/NPM/BDG/SSC) NÃO usam
		esses fields opcionais — zero recurrência cross-BC ainda.
		Maturar tipagem (typed payloadSchema, more variants) sem
		≥2 cases concretos seria especulação sobre (a) quais types
		de payload são canônicos cross-BC (b) quais clearance
		patterns emergem além de no-signal-in-window. Runtime
		evaluation engine é separação arquitetural por design — sua
		formalização vincula-se a Phase 1+ runner stack maturity,
		não a defeito da tipagem do schema.

		Custo evitado: design + implementation + retroativos sem
		evidence empírica. payloadSchema typed afeta audit trail
		format (cross-cutting concern). Runtime engine architecture
		é infrastructure decision com implications para Phase 1+
		runner stack architecture inteira — premature design
		ata-se a constraints de implementação que podem mudar.

		Custo de continuar deferindo:
		- Tipagem fica heuristic Phase 0; code review catches type
		  mismatches em payload signals (factível com 1 envelope P2P
		  usando o pattern; cresce com volume).
		- Variants além de no-signal-in-window: quando emergir, adicionar
		  é minor schema diff (extension não-breaking via discriminated
		  union); zero migration.
		- Runtime evaluation como concern separado: Phase 0 envelopes
		  declaram contracts ricos (typed fields, fail-safe enums);
		  runtime engine architecture formaliza-se quando Phase 1+
		  runner stack progredir — paralelo a separação que pre-WI-069
		  existia entre authoring policy declarativa (Phase 0) e
		  subagent dispatch operacional (Phase 1+).

		Trade-off favorável a aguardar:
		- ≥2 envelopes usando scopedBySignal pattern (P2P é #1;
		  recorrência justifica typed payloadSchema)
		- ≥3 envelopes precisando clearanceCondition (justifica
		  variant extensions concretas)
		- WI-069 Phase 1+ runner materialization (justifica runtime
		  evaluation engine formal architecture)
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence kind) usa pattern para detectar
		assignment de scopedBySignal em envelope instances + scope
		file-content + threshold=2. Pattern força match em ASSIGNMENT
		(scopedBySignal seguido por colon-whitespace-quote: typed ref
		string assignment), NÃO match em schema definition
		(scopedBySignal?: ObservabilitySignalRef — sem aspas após
		colon). Baseline pós-D' = 1 (P2P único envelope com o
		pattern). Threshold=2 fires no primeiro cross-BC adoption
		(P2P + 1 outro envelope) — evidência inicial de recurrence
		justificando typed maturation.

		Trigger 2 (recurrence kind) usa pattern para detectar
		assignment de clearanceCondition em envelope instances +
		scope file-content + threshold=3. Pattern força match em
		assignment com struct (clearanceCondition seguido por
		colon-whitespace-brace: struct assignment), NÃO match em
		schema definition (clearanceCondition?: ClearanceCondition
		— sem brace após colon). Baseline pós-D' = 1. Threshold=3
		fires com P2P + 2 outros — múltiplos cases concretos,
		justifica variant extensions decision OR typed maturation
		parallel.

		Pattern self-match check (paralelo def-012): def-013 prose
		menciona scopedBySignal e clearanceCondition SEM
		colon-string-quote ou colon-brace sequences literais —
		uso conceitual em prose, não literal assignment. Verified
		clean por inspeção pós-write.

		Trigger 3 (manual-review) escape para runtime evaluation
		engine: founder revisita quando Phase 1+ runner
		materialization progredir suficientemente para formalizar
		EnvelopeRuntimeEngine architecture. Separation entre
		schema typing (campos validáveis via cue vet) e runtime
		architecture (engine que processa contracts declarados)
		preserva ortogonalidade — eixos podem maturar em ordens
		distintas. Trigger automático não cabe aqui porque
		'runner materialization progrediu o suficiente' é judgment
		founder, não condição machine-evaluable.
		"""

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Severity low porque tipagem ausente é gap em
			VALIDATION (não em CORRECTNESS): envelope structure é
			conforme schema atual; mismatches de payload semantics
			são caught por code review humana + audit trail
			inspection. Manual review permanece factível com 1
			envelope (P2P) usando os patterns Phase 0. BlastRadius
			local porque escopo é envelope governance subsystem
			(architecture/artifact-schemas/agent-governance.cue +
			agent-spec.cue + envelopes em contexts/*/agents/);
			outros artifact types não afetados. Runtime evaluation
			como concern separado preserva blast radius — Phase 1+
			runner architecture decisões não bloqueiam Phase 0
			envelope governance evolution.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "scopedBySignal:\\s*\""
		scope:     "file-content"
		threshold: 2
	}, {
		kind:      "recurrence"
		pattern:   "clearanceCondition:\\s*\\{"
		scope:     "file-content"
		threshold: 3
	}, {
		kind:   "manual-review"
		reason: "Founder revisita runtime evaluation engine architecture quando Phase 1+ runner materialization progredir suficientemente — formalização como adr separado + schema artifact (e.g., EnvelopeRuntimeEngine) com interface contracts + WI integrado com runner stack maturity. Separação arquitetural por design entre policy (Phase 0 schema) e enforcement (Phase 1+ runner) preserva ortogonalidade; trigger automático não cabe porque progressão runner é judgment founder, não condição machine-evaluable."
	}]

	status: "open"
}
