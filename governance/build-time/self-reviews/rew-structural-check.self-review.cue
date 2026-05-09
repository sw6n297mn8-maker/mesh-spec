package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

rewStructuralCheck: build_time.#SelfReviewReport & {
	reportId: "srr-rew-structural-check"

	artifactPath:       "architecture/structural-checks/rew-domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

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
		infoCount: 1
		summary: """
			Structural-check rew-domain-model.cue criado per ADR-080
			(domain-invariant kind unificando filesystem + semantic
			enforcement). Phase 3.5 Part 2.1 boundary commit do WI-046
			REW bootstrap — primeiro batch de 5 sc-rew-* rules
			executáveis derivados da War Game Round 2 (founder pressure
			test).

			**BOUNDARY COMMIT principle** (founder ratified): invariants
			declarativos em domain-model deixam de ser DESIGN e passam
			a ser CONTRATO EXECUTÁVEL via structural-check rules.

			**5 sc-rew-* rules diferenciadas por NATUREZA do invariant**
			(founder ajuste — 'NÃO escreva todos no mesmo estilo'):

			- sc-rew-01 (acl-validation-cost-bounded): RUNTIME GUARD
			  coverage runtime-only; build-time enforces field presence
			  em RiskPolicy. Forbidden: silent saturation; rejection
			  draining domain budget; silent drop. errorClassEliminated:
			  'distributed cost attack saturating system silently'.

			- sc-rew-02 (obsolete-evaluation-must-link-successor):
			  SEMANTIC CONSISTENCY coverage validation-time + runtime.
			  Forbidden: orphan computed; emit-failed para obsolescence;
			  broken successor link. errorClassEliminated: 'consumer
			  retry loop on obsolescence misclassified as failure'.

			- sc-rew-03 (successor-chain-bounded): CONSUMER CONTRACT
			  coverage runtime-only consumer-side. Forbidden: unbounded
			  chain following; REW runtime enforcement (out of scope —
			  consumer responsibility). errorClassEliminated: 'consumer
			  livelock via infinite successor chain'.

			- sc-rew-04 (replay-confidence-propagation): METADATA
			  INTEGRITY coverage validation-time + runtime via lineage
			  tracking. Forbidden: derived artifact sem provenance;
			  partial replay como ground truth para training.
			  errorClassEliminated: 'partial replay confidence leaking
			  into authoritative chain via training pipeline'.

			- sc-rew-05 (decision-binding-to-evaluation-version):
			  CROSS-BC CONTRACT (TOCTOU defense) coverage runtime-only
			  consumer-side. Forbidden: action sem evaluationId binding;
			  action sem pre-commit recheck; pre-commit query consultando
			  projection em vez de aggregate. errorClassEliminated:
			  'consumer action against superseded evaluation due to
			  read-action time gap'.

			**inv-rew-undetectable-pattern-risk-declared NÃO tem
			structural-check correspondente** (founder ratified): é
			HONESTY INVARIANT puramente declarativo — força VISIBILIDADE
			em systemFailureModes, NÃO COMPORTAMENTO. NÃO bloqueia,
			NÃO valida, NÃO interfere. Verification via systemFailureModes
			content review (manual). Pattern: 'declarar limitação ≠
			resolver'.

			**Coverage distribution** (5 rules):
			- 1 build-time + runtime (sc-rew-01 fields present)
			- 2 validation-time + runtime (sc-rew-02 + sc-rew-04 event
			  log + lineage analysis)
			- 2 runtime-only (sc-rew-03 + sc-rew-05 consumer-side
			  enforcement)

			**Runtime gaps explicitly declared canonically** em todos
			5 rules — honesty arquitetural por construção. Runtime gaps
			NÃO são falhas; são limites conhecidos. enforcedBy field
			declara MEIO de enforcement runtime (ACL pipeline
			instrumentation; aggregate emit handler; consumer SDK
			pattern; data lineage tracking; cross-BC audit).

			**Forbidden patterns** são state/property prohibitions
			(per founder lint pattern: forbidden é proibição de ESTADO
			OU PROPRIEDADE, NÃO de ação procedural).

			**Cascade ordering preserved**:
			- adr-080 (#StructuralCheck domain-invariant kind) commits
			  precede ✓
			- contexts/rew/domain-model.cue Part 2.1 invariants atualizados
			  no MESMO commit (atomic) — invariantId references válidos
			  ✓
			- Part 2.1 boundary commit unifica declarative + executable

			**INFOS REGISTRADOS (infoCount=1)**:

			[INFO 1/1] PART 2.1 SCOPE: 5 sc-rew-* rules cobrem APENAS
			invariants War Game Round 2 (40-44, plus successor-chain-
			bounded at 45). Pattern-risk-declared (44) NÃO tem
			structural-check (honesty invariant pure). Restantes 39
			invariants Part 1+2 (inv-rew-signal-traceability...inv-rew-
			replay-scope-completeness) DEFERRED a Part 2.2+ commits —
			incremental coverage com evidência empírica de necessidade.
			tq-dm-XX runner já-existente cobre integridade referencial;
			structural-check coverage expansion gradual.

			**SCHEMA SATISFACTION**:
			- ADR-080 #DomainInvariantRule fields todos populados
			  (invariantId regex match; assertion formal logic;
			  coverage 3-flag struct; runtimeGap quando runtimeRequired=
			  true; forbidden state prohibitions) ✓
			- 8 critérios universais de structural-check artifact ✓
			- Backward compat: novos rules são additive; existing
			  sc-* rules unchanged ✓

			**VALIDATIONS POST-CHANGE**:
			- cue vet ./... EXIT=0 (PASSED)
			- structural-check production-guide-coverage (sc-pg-01)
			  N/A (structural-check é meta-artefato sem PG)

			Round único suficiente — structural-check é primeiro batch
			boundary commit; founder dialectic ratified durante War
			Game Round 2 + Part 2.1 boundary planning. Pattern paralelo
			a sc-inv-* (architecture/structural-checks/inv-domain-
			model.cue existe) — schema evolution emergente de WI
			bootstraps preserva compatibility.
			"""
	}]

	findings: {}

	summary: """
		Structural-check rew-domain-model.cue criado per ADR-080. 5
		sc-rew-* rules executáveis cobrindo invariants 40-43+45 (War
		Game Round 2 derived); pattern-risk-declared (44) é honesty
		invariant sem executable check. Coverage diferenciada por
		natureza: runtime guard (sc-rew-01); semantic consistency
		(sc-rew-02); consumer contract (sc-rew-03); metadata integrity
		(sc-rew-04); cross-BC TOCTOU (sc-rew-05). Runtime gaps
		canonically declared em todos rules. Boundary commit principle:
		invariants → executable contracts. Restantes 39 Part 1+2
		invariants deferred a Part 2.2+ incremental expansion. cue vet
		EXIT=0. Pattern paralelo a sc-inv-* per adr-080 reference
		implementation.
		"""

	singleRoundRationale: """
		Structural-check é primeiro batch executable contracts derivados
		direto da founder War Game Round 2 — qualidade incorporada via
		founder dialectic durante pressure test (5+1 ajustes ratified).
		Coverage differentiation por natureza do invariant é founder
		ajuste explícito ('NÃO escreva todos no mesmo estilo'). Runtime
		gaps + forbidden patterns + enforcedBy seguem ADR-080 reference
		implementation (sc-inv-* pattern). Round único suficiente —
		boundary commit unifica declarative (domain-model invariants)
		+ executable (structural-check rules) com refs validados
		(invariantId match cross-file). Restantes 39 invariants
		Part 1+2 explicitly deferred a Part 2.2+ — incremental coverage
		expansion com evidência empírica de necessidade evita massive
		single commit.
		"""
}
