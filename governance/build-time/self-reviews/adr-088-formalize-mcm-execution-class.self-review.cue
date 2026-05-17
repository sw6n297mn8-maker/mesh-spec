package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr088FormalizeMcmExecutionClass: build_time.#SelfReviewReport & {
	reportId: "srr-adr-088-formalize-mcm-execution-class"

	artifactPath:       "architecture/adrs/adr-088-formalize-mcm-execution-class.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-14"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-088 + schema delta materializados em commit afad087 sob
			direção explícita founder durante WI-063 NTF agent-spec Phase
			4.2 review.

			Decisão: FORMALIZE Mechanically-Compelled Mutation (MCM)
			como exception class schema-anchored em #AgentAction —
			NÃO conceito narrativo informal. Founder direction literal
			Phase 4.2 ajuste: 'precisa virar tipo formal, não apenas
			conceito narrativo'.

			Schema delta executado:
			(D1) #AgentAction.mutationExecutionClass: optional
			"standard" | "mechanically-compelled". "standard" significa
			mutation SEM MCM exception (NÃO força propose-and-wait
			universalmente per founder ajuste #1 explicit).
			(D2) #AgentAction.mechanicallyCompelledPredicates: nested
			struct obrigatório quando MCM, declarando 5 canonical
			predicates (invariantTriggerRef, mechanicallyDerivableFrom,
			blastRadiusScope, auditSignalEmitted,
			noSemanticDiscretionRationale).
			(D3) tq-ag-14 (fail): 5-predicate completeness + ref
			validity check. tq-ag-15 (fail): MCM ⇒ execute-and-log
			direção ONE-WAY apenas (per founder ajuste #2 explicit:
			nem todo execute-and-log mutation é MCM; pathways formais
			alternativas preserved).

			Founder ajustes integrados pre-commit:
			- Ajuste #1: standard NÃO força propose-and-wait — preservar
			  future formal pathways para execute-and-log mutation sob
			  governance envelope clause distinta.
			- Ajuste #2: tq-ag-15 direção one-way (MCM → execute-and-log)
			  — não enforça inverso.

			Anti-drift defense pattern (paralelo adr-040 structural-vs-
			semantic separation):
			- 5 predicates como structural contract (schema-validated)
			- Semantic merit (genuine triggering, true mechanical-only)
			  validada via advisory layer (governance envelope metrics
			  + future validation prompt)

			Governance envelope Phase 5 obligation declared (NÃO
			materialized neste commit):
			- vm-ntf-mcm-vs-standard-mutation-ratio (observed metric)
			- vm-ntf-mcm-expansion-rate-quarterly (alerta gradual creep)
			- gate clause: "MCM class expansion requires ADR + parallel
			  SRR"
			Phase 5 governance envelope responsibility.

			Cascade ordering preservado:
			Schema delta (este commit) → Phase 4.6 NTF first instance
			(4 MCM actions: act-emit-admissibility-refusal-mechanical,
			act-emit-admissibility-conservatism-mechanical, act-execute-
			replay-forbidden-isolation-containment, act-execute-strong-
			negative-evidence-revocation) → Phase 5 governance envelope
			materializa metrics + ADR-gate clause → future FCE
			retroactive assessment SRR-tracked.

			Validation:
			- cue vet ./... EXIT=0 post-commit (CLEAN)
			- ADR shape: id, title, date, decisionClass=structural,
			  decider=founder, status=accepted, context, decision,
			  consequences, reversibility=medium, blastRadius=cross-
			  artifact, affectedArtifacts (3), plannedOutputs (7),
			  principlesApplied (3), rationale — all required #ADR
			  fields satisfied.
			- Schema additions cue vet clean: #AgentAction extension
			  non-breaking (2 optional fields); #MechanicallyCompelled
			  Predicates new type; 2 quality criteria added (tq-ag-
			  14/15); _qualityCriteria.rationale ampliada.

			Anti-pattern avoidance verificada:
			- "Standard" naming risk (sugere "default"): mitigated via
			  explicit comment "standard = mutation sem MCM exception,
			  NÃO default behavior".
			- Inverse direction risk (não todo execute-and-log = MCM):
			  mitigated via tq-ag-15 one-way framing explicit.
			- Schema enforcement absent for genuine-mechanical-only
			  semantics: mitigated via advisory layer declaration
			  (governance envelope + future validation prompt).
			"""
	}]

	findings: {}

	summary: """
		ADR-088 formaliza MCM exception class schema-anchored em
		#AgentAction (2 optional fields + nested predicates struct +
		2 quality criteria) per founder direction Phase 4.2 ajuste.
		Anti-drift defense pattern paralelo adr-040: structural
		contract (5 predicates schema-validated) + semantic merit
		(advisory layer governance envelope + future validation
		prompt). 2 founder ajustes integrated pre-commit: (#1)
		"standard" não força propose-and-wait universal; (#2)
		tq-ag-15 direção one-way (MCM ⇒ execute-and-log, NÃO
		inverso). Governance envelope Phase 5 obligation declared
		(vm-mcm-ratio + vm-mcm-expansion-rate + ADR-gate clause).
		Cascade ordering preservado: schema → Phase 4.6 NTF first
		instance → Phase 5 envelope materialization → future FCE
		retroactive assessment.
		"""

	singleRoundRationale: """
		Round único per founder iterative review pre-commit: 2
		ajustes founder explicit integrated antes de write (literais
		em Phase 4.2 conversational dialog). Schema delta é
		non-breaking (optional fields); ADR é structural decision
		documented com 5 predicates já estabelecidos em charter
		Phase 4.0.

		Round 1 verifica:
		(a) cue vet ./... EXIT=0 (schema additions + ADR shape
		    canonical);
		(b) Founder ajustes #1 + #2 integrated literalmente em ADR
		    decision section + rationale + tq-ag-14/15 rationale;
		(c) Anti-pattern surfaces (standard-as-default,
		    inverse-direction-coupling) mitigated explicit em
		    comments + rationale;
		(d) Cascade ordering documented (Phase 4.6 NTF + Phase 5
		    envelope + future FCE assessment).

		Multiple rounds seriam ritual sem ganho — decisão
		arquitetural cristalizada via founder dialectic Phase 4.2;
		schema delta executes founder direction explícita; nenhuma
		ambiguidade pendente que rounds adicionais resolveriam.

		Per CLAUDE.md guardrail self-review-check: SRR é ÚNICA forma
		de evidência permitida; este SRR cobre ADR-088 artifactPath
		integralmente. Agent-spec.cue schema delta tem SRR separado
		dedicado (srr-agent-spec-mcm-execution-class-schema-delta).
		"""
}
