package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

rewDomainModel: build_time.#SelfReviewReport & {
	reportId: "srr-rew-domain-model"

	artifactPath:       "contexts/rew/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-09"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 7
		summary: """
			Domain Model REW (Risk Engine & Risk Observability) Phase 3
			Part 1 do WI-046 materializado via authoring manual section-
			by-section per manualAuthoringProtocol (adr-057). 7 sections
			(S1 identity + module decomposition; S2 invariants; S3 value
			objects; S4 events + commands; S5 aggregates; S6 policies +
			projections + outer rationale) approved sequencialmente via
			founder dialectic R3+R4+R5++++ section-gate cycles —
			qualidade incorporada pre-write em vez de post-hoc rounds.

			**FRASE CANONICAL Phase 2 ancorada** (preservada em outer
			rationale): 'Glossary não define palavras — define o que o
			sistema está autorizado a considerar verdade.' Domain model
			COMPILA o glossary em building blocks DDD onde violações
			tornam-se erros de compilação OU rules estruturais
			executáveis (Phase 3 Part 3 deferred).

			**REGRA DE 3 CAMADAS** (founder Phase 3 directive — Opção A
			ratified pre-write): VO define forma (CUE schema-time);
			invariant define verdade (rule + rationale); structural-
			check impõe verdade (Phase 3 Part 3 architecture/structural-
			checks/rew-domain-model.cue deferred). Schema #ValueObject
			closed (sem `...`) impede conditional fields cross-field;
			enforcement migrado para structural-check layer. Opção B
			(schema extension) explicitamente rejeitada por founder —
			blast radius cross-BC desnecessário.

			**ESTRUTURA — counts finais Part 1**:

			- 13 events (signal layer 2 + evaluation layer 4 + alert
			  layer 3 + model lifecycle 2 + policy lifecycle 2)
			- 9 commands (incluindo cmd-mark-evaluation-stale internal
			  orchestration — Opção 6 founder ratified com
			  actorAuthority='automated-policy' only)
			- 24 invariants (12 originais Phase 3 dialectic + 1 explicit-
			  supersede-only S4 round 1 + 6 final founder pressure
			  S4 + 5 último round pressure)
			- 17 valueObjects (4 utility + 5 signal/payload + 5 domain
			  core + 3 type catalog + 1 scale-metadata; cada VO declara
			  errorClassEliminated explícito per REGRA-GOV-VO-01)
			- 1 aggregate skeleton (agg-risk-evaluation com lifecycle
			  3-estados emitted/stale/superseded; identity por
			  evaluationId surrogate per founder 'identidade ≠
			  determinismo')
			- 1 entity (ent-reasoning-trace owned por agg-risk-evaluation;
			  identity própria porque trace é evidência auditável, NÃO
			  attribute opcional)
			- 1 policy (pol-mark-stale-on-relevant-signal — única
			  automation justificável Phase 0)
			- 1 projection (prj-active-risk-evaluations OBRIGATÓRIA per
			  inv-rew-active-evaluation-rule — append-only sem regra de
			  leitura = sistema inutilizável)
			- modules: 0 (decomposition documentada em header comment;
			  materialização deferred Part 2 quando 4 aggregates
			  completos)

			**SECTION-GATE PROTOCOL APLICADO** (manualAuthoringProtocol
			adr-057):
			- S1 (identity + counts outline): approved com 4 ajustes —
			  reduzir overfitting de policies/projections, ACL module
			  rationale anti-corruption explícita, hardening replayHash
			  SHA-256 + canonical serialization, temporal invariant
			  com tolerance window
			- S2 (invariants 12 originais): approved com 5 ajustes —
			  intermediateSteps ≥2, signalRef capturedAt mandatory,
			  payloadVoCode binding via structural-check, scale-value
			  conditional via structural-check, allowedEntitySources
			  policy-defined
			- S3 (value objects 14→17): approved com 7 correções
			  obrigatórias — vo-scale-metadata dedicada (não
			  vo-version-stamp wrapping), vo-uncertainty-driver +
			  vo-decision-reason como TYPE catalog (não merge),
			  payloadInstance via vo-external-ref (não string solta),
			  vo-signal-ref reusa vo-external-ref + sourceContext,
			  entityRef NÃO hardcoded em RiskPolicy (canvas primary)
			- S4 (events + commands + 13 invariants final): approved
			  via 4 rounds de pressão — discriminated causation
			  (causationKind/causationRef), signalSnapshotIds em
			  computed event, active-evaluation uniqueness rule,
			  compute-emit ordering invariant, alert-dedupe via
			  (evaluationId, alertCategory), authority validation
			  S7 mapping, signal-corruption discard explícito,
			  staleness-tracking automation, no-staleness-feedback-
			  loop, command-idempotency com payload integrity,
			  snapshot-temporal-consistency separado, alert-
			  evaluation-binding-immutability, evaluation-completeness
			  global gate, event-emission-boundedness final
			- S5 (aggregate skeleton): approved — agg-risk-evaluation
			  com lifecycle 3-estados; identity surrogate;
			  parentEvaluationId lineage; 20 invariants protected;
			  ent-reasoning-trace nested entity
			- S6 (policy + projection): approved — pol-mark-stale com
			  cmd-mark-evaluation-stale internal target (Opção B
			  founder ratified); prj-active-risk-evaluations
			  OBRIGATÓRIA com 2 query capabilities
			- S7 (structural-checks file): explicitly DEFERRED to
			  Part 3 — 21+ sc-rew-* rules listadas como queue em outer
			  rationale + cada constraint string declara sc-rew-* rule
			  target

			**CASCADE ORDERING preserved**:
			- stakeholder-map sh-06 'Adversário Econômico' (Phase 1
			  cross-cutting, commit fbe0b2d) ✓
			- canvas REW Phase 1 (commit fbe0b2d 'top 0.1%') ✓
			- glossary REW Phase 2 (commit 7854cc7, 12 terms em 5
			  camadas ontológicas) ✓
			- lens-domain-language-and-terminology-design existente ✓
			- Schema #DomainModel NÃO modificado (Opção A — blast
			  radius zero; INV/DLV/SSC/PG existentes preservados)

			**REGRA-GOV-VO-01 governance** (founder Phase 3 ratified):
			Nenhum VO criado sem errorClassEliminated explícito.
			Aplicado retroativamente aos 17 VOs (cada VO rationale
			declara classe de erro que elimina).

			**REGRA-GOV-WRITE-01 governance** (founder Phase 3
			ratified): Commit incremental NÃO pode introduzir
			ambiguidade semântica mesmo que incompleto. Part 1 é
			estado intermediário COERENTE — known divergences/
			deferimentos explicitamente documentados em outer
			rationale (não placeholders TODO disfarçados).

			**INFOS REGISTRADOS (infoCount=7)** — known gaps Part 1
			explicitamente documentados em outer rationale (não
			ambiguidade silenciosa per REGRA-GOV-WRITE-01):

			[INFO 1/7] tq-dm-01 partial: 6 commands declarados
			(cmd-acknowledge-risk-alert, cmd-resolve-risk-alert,
			cmd-activate-risk-model, cmd-deprecate-risk-model,
			cmd-activate-risk-policy, cmd-deprecate-risk-policy)
			NÃO handled por agg-risk-evaluation — aguardam
			aggregates Part 2 (agg-risk-alert + agg-risk-model
			+ agg-risk-policy). Runner emitirá warn até Part 2
			alignment. Documentado em outer rationale know-divergences.

			[INFO 2/7] tq-dm-02 partial: 7 events emitidos por
			aggregates Part 2 (alert lifecycle 3 events; model 2
			events; policy 2 events) NÃO emitted por agg-risk-
			evaluation. Aguardam Part 2.

			[INFO 3/7] tq-dm-03 partial: 4 invariants protected por
			aggregates Part 2 (inv-rew-alert-lifecycle, inv-rew-alert-
			dedupe, inv-rew-alert-evaluation-binding-immutability,
			inv-rew-model-policy-independence). Runner emitirá warn
			até Part 2.

			[INFO 4/7] tq-dm-11 alignment debt: Canvas Phase 1
			declarou RiskScoreEmitted + EligibilityEmitted como
			events separados; Phase 3 design unificou em evt-risk-
			evaluation-emitted (decision atômica score+eligibility+
			confidence). Canvas alignment commit pos Part 2 tracked
			como implicit work. Runner emitirá warn.

			[INFO 5/7] tq-dm-12 NÃO aplica a cmd-mark-evaluation-
			stale (internal orchestration command — não exposto via
			canvas inbound per Opção 6 founder ratified). Outras
			6 commands aguardam Part 2 aggregates para canvas
			inbound alignment.

			[INFO 6/7] Schema limitations honestos (Opção A founder
			ratified): #ValueObject.fields é closed (sem `...`) —
			conditional fields cross-field NÃO expressáveis em VO
			schema. Workarounds aplicados com declaração explícita:
			(a) primitive string + structural-check element validation
			(uncertaintyDrivers, constraints, blockingReasons,
			missingSignals, signalSnapshotIds — VO catalog define TYPE,
			storage é string); (b) regex em prosa em constraints[]
			array — enforcement migrado para sc-rew-* rules em Part 3.

			[INFO 7/7] S7 structural-checks file (architecture/
			structural-checks/rew-domain-model.cue) explicitly DEFERRED
			to Phase 3 Part 3. ≥21 sc-rew-* rules listadas como queue
			em outer rationale. Cada constraint[] string em cada VO
			declara sc-rew-* rule target — quando Part 3 materializa,
			rules existem com referências consistent. Pattern paralelo
			a INV (architecture/structural-checks/inv-domain-model.cue
			existe); REW Part 3 segue mesmo pattern.

			**SCHEMA SATISFACTION POR INSPEÇÃO**:

			- tq-dm-04 (VOs usados por aggregate ou entity): 17 VOs;
			  agg-risk-evaluation.usesValueObjects[] referencia 17
			  VOs ✓ (todos consumidos)
			- tq-dm-05 (policies refs valid): pol-mark-stale-on-
			  relevant-signal triggeredByEvent='evt-signal-received'
			  (existe) + issuesCommand='cmd-mark-evaluation-stale'
			  (existe) + guards refs invariants existentes ✓
			- tq-dm-06 (projections refs valid events): prj-active-
			  risk-evaluations.consumesEvents=[evt-risk-evaluation-
			  emitted, evt-risk-evaluation-superseded, evt-risk-
			  evaluation-marked-stale, evt-signal-received] — todos
			  existem em events[] ✓
			- tq-dm-07 (lifecycle transitions valid): agg-risk-
			  evaluation.lifecycle.transitions[].triggeredByCommand
			  ∈ commands[] ✓; emitsEvents ∈ events[] ✓; guards ∈
			  invariants[] ✓
			- tq-dm-08 (lifecycle states): agg-risk-evaluation.
			  lifecycle.states=[emitted, stale, superseded];
			  initialState='emitted' ∈ states ✓; transitions
			  from/to ∈ states ✓
			- tq-dm-13 (codes únicos + prefixes): inspeção visual
			  + cue vet PASSED (CUE detectaria duplicates por
			  unification) — regex prefixes evt-/cmd-/inv-/vo-/
			  agg-/ent-/pol-/prj-/qry- conformam ✓
			- tq-dm-14 (VO refs valid): cada value-object-ref em
			  fields aponta para vo-* existente em valueObjects[] ✓
			- tq-dm-17 (cross-aggregate state dep): nenhum invariant
			  declara dependsOnAggregateState — cross-aggregate
			  enforcement vive em structural-checks Part 3 ✓ (N/A
			  para esta phase)

			**VALIDATIONS POST-WRITE**:
			- cue vet ./... EXIT=0 (PASSED)
			- check-self-review.sh: SRR criada por este file (resolved)
			- structural-check inv-domain-model.cue NÃO aplica (REW-
			  specific rules em Part 3 deferred)
			- validation-prompt validate-domain-model.cue: existe;
			  advisory review post-commit per CLAUDE.md seção 14

			**LENS APLICADA** (capturada no rationale):
			Primary: lens-domain-language-and-terminology-design
			(herdada do glossary Phase 2)
			- dl-bilingual-terminology: pt-BR canonical + termEn
			  quando aplicável; loanwords (Score, Confidence,
			  Signal, Trace) preservados
			- dl-term-selection-criteria: 17 VOs selecionados via
			  REGRA-GOV-VO-01 (errorClassEliminated obrigatório);
			  derivados não primitivos EXCLUÍDOS por term promotion
			  criteria (Phase 2 hardening)
			- dl-cross-layer-consistency: 5 layers ontológicas
			  preservadas (Reality/Epistemic/Decision/Control/Actor);
			  misturar camadas é erro estrutural

			Round único suficiente — qualidade incorporada via founder
			dialectic 7-section gate iterativo durante composição.
			Pattern paralelo a Phase 2 glossary REW + INV/DLV domain-
			model approach. Pre-commit fix mecânico se necessário
			(cue vet passou na primeira tentativa — zero correções
			sintáticas).
			"""
	}]

	findings: {}

	summary: """
		Domain Model REW (Risk Engine & Risk Observability) Phase 3
		Part 1 do WI-046 materializado via manualAuthoringProtocol
		section-by-section (adr-057). 7 sections approved + 24
		invariants ratified + 17 VOs com errorClassEliminated +
		1 aggregate skeleton com lifecycle 3-estados + 1 entity
		owned + 1 policy (pol-mark-stale internal orchestration) +
		1 projection (prj-active-risk-evaluations OBRIGATÓRIA per
		active-evaluation-rule). REGRA DE 3 CAMADAS aplicada
		(VO=forma, invariant=verdade, structural-check=execução
		Part 3 deferred). REGRA-GOV-VO-01 governance applied
		retroativamente. REGRA-GOV-WRITE-01 honrada (Part 1 coerente
		mesmo incompleto). Cascade ordering preserved (canvas Phase 1
		+ glossary Phase 2 + sh-06 stakeholder + lens-domain-language).
		Schema #DomainModel NÃO modificado (Opção A blast radius zero).
		7 known gaps documentados explicitamente (tq-dm-01/02/03/11/12
		partial alignment até Part 2; Part 3 structural-checks
		deferred). cue vet ./... EXIT=0. Round único; founder
		dialectic 7-section gate substituiu rounds pos-hoc.
		"""

	singleRoundRationale: """
		Authoring manual section-by-section per manualAuthoringProtocol
		(adr-057) com 7 founder dialectic R3+R4+R5++++ section-gate
		cycles aplicados pre-write durante composição (cada section
		recebeu múltiplos ajustes obrigatórios — qualidade incorporada
		pre-write em vez de post-hoc rounds). Pattern paralelo a
		Phase 1 canvas REW (top 0.1% nivel founder) + Phase 2 glossary
		REW (3 sections + 3 hardenings) + INV/DLV domain-model Phase 3
		approach. Cascade ordering preserved (canvas REW Phase 1
		fbe0b2d + glossary REW Phase 2 7854cc7 + sh-06 stakeholder +
		lens-domain-language existem). 5 rounds de pressão founder
		incorporados pre-commit:
		(R1 S3 VO structure) discriminated unions + versioning +
		coupling invisível + uncertaintyDrivers + calibrationProfile +
		VO explosion guardrail; absorvido com 5 correções obrigatórias.
		(R2 S3 governance) REGRA-GOV-VO-01 + 3 ajustes finais (allowed-
		EntitySources canvas-primary + payloadInstance vo-external-ref
		+ vo-signal-ref sourceContext via composição); absorvido.
		(R3 S4 events+commands) 8 falhas estruturais (causation
		discriminado + signalSnapshot em computed + active uniqueness
		+ compute-emit ordering + alert-dedupe + authority validation
		+ corruption discard + staleness automation); absorvido com
		6 corrections + 1 new invariant (staleness-tracking).
		(R4 S4 final pressure) 8 estados impossíveis (no-staleness-
		feedback-loop + active-uniqueness fechamento + command-
		idempotency + snapshot-temporal + alert-binding-immutability +
		policy-emits-event friction (Opção 6 ratified) + lineage +
		evaluation-completeness); absorvido com 5 new invariants +
		policy decision Opção B + parentEvaluationId field.
		(R5 final mesmo) 1 invariant final (event-emission-
		boundedness); absorvido. Round único suficiente — founder
		dialectic 7-section gate substituiu rounds pos-hoc; cue vet
		PASSED na primeira tentativa (zero correções sintáticas
		exigidas).
		"""
}
