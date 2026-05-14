package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentSpecMcmExecutionClassSchemaDelta: build_time.#SelfReviewReport & {
	reportId: "srr-agent-spec-mcm-execution-class-schema-delta"

	artifactPath:       "architecture/artifact-schemas/agent-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/quality-criteria.cue"
	artifactType:       "artifact-schema"

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
			Schema delta em architecture/artifact-schemas/agent-spec.cue
			per ADR-088 (commit afad087). Anti-drift defense via
			formalização de MCM exception class schema-anchored.

			Mudanças (todas non-breaking — fields adicionados são
			optional; pre-existing instances permanecem valid):

			(1) #AgentAction extension:
			    + mutationExecutionClass?: "standard" | "mechanically-compelled"
			    + mechanicallyCompelledPredicates?: #MechanicallyCompelledPredicates

			(2) New type #MechanicallyCompelledPredicates:
			    - invariantTriggerRef: #InvariantRef (P1)
			    - mechanicallyDerivableFrom: #NonEmptyString (P2)
			    - blastRadiusScope: "single-dispatch" | "single-certification-entity" | "single-claim-entity" (P3)
			    - auditSignalEmitted: #ObservabilitySignalRef (P4)
			    - noSemanticDiscretionRationale: #NonEmptyString (P5)

			(3) _qualityCriteria additions:
			    + tq-ag-14 (severity: fail): 5-predicate completeness +
			      ref validity. Test inclui:
			      - mutationExecutionClass='mechanically-compelled' ⇒
			        mechanicallyCompelledPredicates presente
			      - invariantTriggerRef ∈ invariants[] (runner cross-
			        artifact)
			      - auditSignalEmitted ∈ observability.signals[]
			      - blastRadiusScope ∈ enumerable
			      - mechanicallyDerivableFrom + noSemanticDiscretion
			        Rationale non-empty
			      - inverse: 'standard' OR omitted ⇒ predicates struct
			        absent
			    + tq-ag-15 (severity: fail): direção ONE-WAY apenas
			      (MCM ⇒ execute-and-log). Inverso intencionalmente
			      NÃO enforced — preserva pathways formais alternativas
			      para execute-and-log mutation governadas via
			      autonomyLevel + envelope.

			(4) _qualityCriteria.rationale ampliada para documentar
			    tq-ag-14/15 dentro da enumeração canonical (formalização
			    anti-drift de MCM exception class per adr-088).

			Founder ajustes integrated literalmente (Phase 4.2 review
			explícito):
			- Ajuste #1: "standard" significa "mutation sem MCM
			  exception" NÃO "default propose-and-wait" — preserva
			  future formal pathways para execute-and-log mutation
			  sob governance envelope clause distinta. Materializado
			  em mutationExecutionClass field comment + ADR-088
			  decision section.
			- Ajuste #2: tq-ag-15 direção one-way apenas — NÃO
			  enforça inverso. Materializado em tq-ag-15 test string
			  explícito + rationale field.

			Anti-pattern surfaces (declared explicit em schema comments
			+ rationale):
			- "Standard" naming-as-default risk: mitigated via comment
			  literal "NÃO força propose-and-wait universalmente — é
			  discriminador de classe, NÃO prescrição de autonomy
			  level".
			- "Mechanical merit semantic validation": schema enforces
			  presence only; semantic merit (genuine triggering,
			  mechanical-only) validada via advisory layer (Phase 5
			  governance envelope metrics + future validation prompt).
			- "Schema-as-gate temptation": tq-ag-14/15 são severity
			  fail mas vivem em _qualityCriteria (advisory per CLAUDE.md
			  validation layer separation). Promoção a structural-
			  check post-commit blocking gate é separate WI (gap
			  conhecido: architecture/structural-checks/agent-spec.
			  cue não existe ainda).

			Backward compatibility:
			- Pre-existing #AgentAction instances (fce-primary-agent.
			  cue + bdg-primary-agent.cue + cmt-primary-agent.cue +
			  outros) permanecem valid — novos fields são optional.
			- FCE primary agent retroactive assessment SRR-tracked
			  para Phase 4.6 NTF (separate amendment WI se backfill
			  aplicável).

			Validation:
			- cue vet ./... EXIT=0 post-commit (CLEAN)
			- Schema shape: #AgentAction closed struct preserved com
			  2 optional fields added; #MechanicallyCompelledPredicates
			  como new typed reference; #ObservabilitySignalRef +
			  #InvariantRef ja existentes (não introduce new ref types)
			- Quality criteria additions são extension simples ao
			  array _qualityCriteria.criteria
			"""
	}]

	findings: {}

	summary: """
		Schema delta em agent-spec.cue per ADR-088: 2 optional fields
		em #AgentAction + 1 new typed struct (#MechanicallyCompelled
		Predicates) + 2 quality criteria (tq-ag-14/15). Non-breaking
		— pre-existing #AgentAction instances permanecem valid.
		Anti-drift defense formalizada: MCM exception class agora
		tem schema anchor (structural contract); semantic merit
		validada via advisory layer (governance envelope Phase 5 +
		future validation prompt). 2 founder ajustes integrated
		literalmente: "standard" não força propose-and-wait (#1);
		tq-ag-15 direção one-way MCM ⇒ execute-and-log NÃO inverso
		(#2). FCE retroactive assessment deferred para Phase 4.6
		NTF SRR tracking.
		"""

	singleRoundRationale: """
		Round único per ADR-088 anchor: schema delta executa
		exatamente o decision section declarado em ADR-088 (commit
		afad087); founder ajustes pre-write integrated literalmente
		(Phase 4.2 conversational dialog).

		Round 1 verifica:
		(a) cue vet ./... EXIT=0 post-commit;
		(b) Schema shape canonical: 2 optional fields + 1 new typed
		    struct + 2 quality criteria addition canonical;
		(c) Founder ajustes #1 + #2 integrated literalmente em field
		    comments + criteria test strings + rationale fields;
		(d) Backward compatibility: pre-existing instances valid;
		(e) Anti-pattern mitigations explicit (standard-as-default,
		    schema-as-merit-gate, structural-check absence
		    acknowledged).

		Multiple rounds seriam ritual: schema delta é mechanical
		execution of ADR-088 decision; nenhuma ambiguidade que
		rounds adicionais resolveriam. ADR-088 carries arquitetural
		decision-record canonical; este SRR documenta schema-level
		execution evidence.

		Cascade ordering documented: schema (este commit) → Phase
		4.6 NTF first instance materialization → Phase 5 governance
		envelope metrics + ADR-gate clause → future FCE retroactive
		assessment SRR-tracked.
		"""
}
