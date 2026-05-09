package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr085: artifact_schemas.#ADR & {
	id:    "adr-085"
	title: "Extract REW Phase 3 as 'decision-systems-with-truth-boundaries' pattern via lens — replicável a CMT/FCE/SCF/NIM"
	date:  "2026-05-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		**RELATIONSHIP TO ADR-081 + ADR-084**: This ADR REFINES adr-081
		(interpretation contracts layer) + adr-084 (production-safety
		hardening) by extracting REW Phase 3 + War Game Round 2 hardened
		artifacts as REUSABLE pattern via lens artifact. adr-081/084
		estabeleceram base structures; adr-085 reconhece que primeiro
		exemplar completo emergiu (REW) e codifica pattern para
		replicação cross-BC.

		Refinement chain: adr-081 → adr-084 → adr-085 (pattern maturity).
		Documented in prose (refines field NÃO existe; mantido per adr-084
		decision para defer schema addition until ≥3 ADRs justify).

		---

		**Origin: WI-046 REW Phase 3 closure pre-fase**.

		REW completou Phase 3 com:
		- 46 invariants (24 Part 1 + 8 S5 + 4 production-safety + 7 War
		  Game Round 2 + 3 final pressure)
		- 16 events (incluindo emit-failed = ABORT + emit-superseded-by-
		  newer = OBSOLESCENCE + signal-rejected = ACL boundary)
		- 4 aggregates com consistencyBoundary contracts
		- 1 systemConsistencyModel (consumerProtocol + systemFailureModes
		  + replayScopeStrategy + conflictResolution)
		- 1 decisionAuthorityModel (authoritative + LIMITATION declared)
		- 5 sc-rew-* executable structural-checks (boundary commit:
		  invariants → executable contracts)
		- def-016 cross-BC enforcement deferred (governance Phase 3)

		Founder Phase 3 closure analysis:
		'Você não está fechando um work item. Você está fechando a
		primeira instância completa de um padrão arquitetural da Mesh.
		Esse não é só o REW — é um template replicável para CMT, FCE,
		SCF, NIM.'

		**Risk se simple closure**: padrão se PERDE; próximo BC
		reimplementa parcialmente; invariants críticos esquecidos;
		divergência silenciosa cross-BC. closure padrão = perda da
		codificação explícita do padrão.

		3 alternativas consideradas:
		(A1) Simple closure (work-events task-completed only).
		     REJEITADA — padrão perdido; próximo BC reinventa.
		(A2) Novo artifact type 'pattern' em architecture/patterns/.
		     REJEITADA — cria nova categoria sem precedente; cascade
		     refactor (schema + PG + structural-check + repo-structure
		     + README) é overkill para primeira extração.
		(A3) Híbrido ADR-085 + lens em architecture/lenses/. ADOPTED
		     — leverage existing lens infrastructure (architecture/lenses/
		     já é canonical mechanism para 'guidance for decisions');
		     ADR documenta DECISION de extrair; lens captura PATTERN
		     consumível durante Phase 3 de outros BCs via lens
		     application protocol.
		"""

	decision: """
		ADOPT 2 mudanças coordenadas:

		(D1) Create architecture/lenses/lens-decision-systems-with-
		     truth-boundaries.cue capturando pattern transversal
		     extraído de REW Phase 3. Lens estrutura per #AnalyticalLens
		     schema:
		     - trigger.conditions: 5 activation criteria (incluindo
		       CRITICAL: 'decisions can become invalid without explicit
		       mutation event' — força validUntilTimestamp; sem este,
		       pattern é overkill)
		     - trigger.excludeWhen: applicabilityTest 'If removing
		       validUntilTimestamp does NOT break correctness, this
		       lens should NOT be applied'
		     - 6 concepts agrupados por categoria (founder ajuste —
		       framework mental, não checklist linear):
		         1. Truth boundaries
		         2. Temporal correctness
		         3. Semantic determinism (incluindo precedence + obsolescence
		            ≠ failure)
		         4. Execution integrity (invariants → structural-checks
		            executáveis)
		         5. Boundary integrity (ACL validation + rejection
		            explícito + interpretation contracts)
		         6. Honesty invariants (declarar limitações como
		            structural facts, não silenciar)
		     - limitations: 3 (cross-entity correlation; cross-BC technical
		       enforcement; calibration risk)
		     - reference: REW como canonical implementation com pointers
		       para 4 aggregates + 46 invariants + 5 sc-rew-*
		       structural-checks

		(D2) ADR-085 documenta DECISION de extrair pattern + nonPattern
		     Elements explicitly enumerated (founder ajuste — sem isso,
		     próximo BC vai 'copiar o sistema inteiro achando que está
		     aplicando o padrão'):
		     **PATTERN ELEMENTS (transversais — capturados na lens)**:
		     - validUntilTimestamp + replayConfidence + emit-failed vs
		       emit-superseded-by-newer (truth boundaries)
		     - decision ≠ state; decision = state + tempo (temporal)
		     - precedence explícita; obsolescence ≠ failure (semantic)
		     - input vs decision rule independence WHEN versioned
		       separately (NÃO 'model vs policy' — generalização per
		       founder ajuste)
		     - ACL validation; rejection explícito; never drop
		     - invariants → structural-checks (declarative → enforceable)
		     - consistencyBoundary + systemConsistencyModel +
		       decisionAuthorityModel (interpretation contracts)
		     - undetectable risk declared (honesty invariant)

		     **NON-PATTERN ELEMENTS (REW-specific — NÃO transversais)**:
		     - risk score semantics (vo-risk-score with calibrationProfile;
		       scale enum probability/normalized/custom)
		     - eligibility decision structure (vo-eligibility-decision
		       with decision enum eligible/conditionally_eligible/
		       ineligible)
		     - alert lifecycle specifics (open→acknowledged→resolved
		       with reasonCode/severity REW-domain)
		     - adversarial signal taxonomy (signalType kyc|device|
		       behavioral|fiscal — risk-domain specific)
		     - signalSnapshotIds + replayHash semantic (REW choice;
		       outras BCs podem ter different replay anchor)
		     - 5-layer ontological structure (Reality/Epistemic/
		       Decision/Control/Actor — REW glossary specific;
		       outras BCs podem ter different ontology)
		     - sh-06 'Adversário Econômico' stakeholder (REW + cross-
		       cutting; outras BCs podem ter different adversarial
		       modeling)
		     - 4 specific aggregates (agg-risk-evaluation/alert/model/
		       policy — REW domain decomposition)

		**Application protocol** (lens consumed durante Phase 3 de
		future BCs):
		1. BC matches activationCriteria (5 conditions) → lens activated
		2. BC reviews 6 concepts as reasoning protocol pre-decision
		3. BC validates pattern elements coverage in domain-model
		4. BC declines NON-PATTERN ELEMENTS (NÃO copia REW-specific)
		5. BC documents lens application em domain-model rationale
		6. Second BC application VALIDATES if it's truly pattern OR
		   coincidence — só com 2+ instâncias é pattern confirmed
		"""

	consequences: """
		(a) lens-decision-systems-with-truth-boundaries vira mecanismo
		    canonical para CMT/FCE/SCF/NIM aplicarem em Phase 3 deles —
		    pattern reusável codificado.

		(b) REW como reference implementation explícita: future BCs
		    podem comparar suas decisions com REW Phase 3 directly
		    (pointers em lens.concepts).

		(c) NON-PATTERN ELEMENTS enumerated previne 'copy whole system'
		    anti-pattern — próximo BC sabe o que NÃO copiar.

		(d) 'Generalization input vs decision rule independence' (vs
		    'model vs policy') torna pattern aplicável a BCs sem
		    versioning model/policy split (e.g., CMT pode ter different
		    versioned inputs/rules; pattern aplica via generalização).

		(e) Causalidade preservada via SEQUENTIAL commits (founder ajuste):
		    Commit A pattern extraction → Commit B WI-046 closure
		    referencing pattern. NUNCA atomic — atomic implicaria
		    'padrão nasceu pronto'; sequential establece 'REW gerou
		    padrão; padrão permite closure'.

		(f) lens applicabilityTest ('If removing validUntilTimestamp
		    does NOT break correctness, lens should NOT be applied')
		    previne overuse — pattern NÃO é applied a todos BCs;
		    apenas decision systems with truth boundaries necessity.

		(g) Validation real só vem com SECOND APPLICATION em outro
		    BC — adr-085 documenta isso explicitly como teste
		    definitivo. Após CMT (OR FCE/SCF/NIM) Phase 3 aplicar
		    lens, founder revisita: 'isso é padrão OR coincidência
		    bem construída?'

		(h) Pattern paralelo a adr-080 (#StructuralCheck domain-
		    invariant) + adr-081 (interpretation contracts) + adr-084
		    (production-safety hardening) — sequência de schema/lens
		    evolution emergente de WI bootstraps demonstra metodologia
		    'evolução governada via descoberta empírica'.

		(i) Vantagem estrutural Mesh-level moat: cada BC futuro que
		    aplica lens herda 46 invariants + 5 structural-checks +
		    interpretation contracts maturity. Aceleração compounding
		    cross-BC bootstrap quando pattern matures.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/lenses/lens-decision-systems-with-truth-boundaries.cue",
	]

	plannedOutputs: [
		"lens-decision-systems-with-truth-boundaries (architecture/lenses/) com 6 concepts agrupados + 5 activation criteria + applicabilityTest + 3 limitations + REW reference",
	]

	derivedArtifacts: [
		"WI-046 closure rationale referencing adr-085 + lens (Commit B sequencial)",
		"contexts/cmt/domain-model.cue (Phase 3 future) — primeira aplicação validating pattern OR coincidence",
	]

	principlesApplied: [
		"P10-deterministic-gates-vs-stochastic-recommendations",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-081-domain-model-interpretation-contracts-layer",
		"adr-084-production-safety-hardening-system-consistency-model",
	]

	rationale: """
		Reversibility medium: lens addition é additive (não modifica
		existing BCs); REW reference unchanged. Remoção pos-adoção
		exigiria deprecation lens + ADR documenting (lens existing
		with status='active' = consumed by future BCs).
		BlastRadius cross-cutting: lens é cross-BC mechanism; afeta
		Phase 3 de TODOS BCs futuros que matchem activationCriteria.

		Decisão prioriza PATTERN CODIFICATION ('definir como sistemas
		são construídos') sobre IMMEDIATE CLOSURE ('fechar work item').
		Justificativa: REW Phase 3 é primeira instância completa de
		decision-systems-with-truth-boundaries; sem extração explícita,
		padrão se perde + próximo BC reinventa parcialmente.

		**Refinement chain explícito**: adr-085 REFINES adr-081 +
		adr-084. Documentado em prose (refines field defer per adr-084
		decision). Sem chain de refinamento, evolução vira ruptura
		invisível — futuro reader entende sequência: interpretation
		contracts (adr-081) → production-safety (adr-084) → pattern
		maturity (adr-085).

		**NON-PATTERN ELEMENTS enumeration crítico** (founder ajuste):
		sem lista explícita do que NÃO faz parte do padrão, próximo BC
		copia REW inteiro (anti-pattern 'copy whole system thinking
		it's pattern application'). NON-PATTERN list é defesa explícita.

		**Generalization 'input vs decision rule independence'** (vs
		REW-specific 'model vs policy'): pattern aplicável a BCs sem
		exact REW vocabulary. CMT pode ter pricing-model vs business-
		rule independence; FCE pode ter sanction-list vs evaluation-
		policy independence — todos compartilham princípio (input
		versioning ⊥ rule versioning).

		**Sequential commits** (founder ajuste): Commit A pattern →
		Commit B closure preserva CAUSALIDADE correta. Atomic implicaria
		'padrão nasceu pronto'; sequential demonstra 'REW gerou padrão;
		padrão permite closure'. Pequena ordem importa para audit
		trail + future BC understanding.

		**applicabilityTest crítico** (founder ajuste): lens NÃO é
		applied a todos BCs. Test 'remove validUntilTimestamp; if
		correctness still holds, lens NOT applicable' separa cases
		reais (decisions invalidate sem mutation event — REW, fraud
		detection, pricing dinâmico) de cases triviais (state-only
		systems).

		**Real validation só com second application**: adr-085 documenta
		explicitly que pattern é HYPOTHESIS até second BC aplicar. Após
		CMT Phase 3 (OR FCE/SCF/NIM), founder revisita: pattern OR
		coincidence? Se confirmed pattern, future ADR pode formalizar
		(elevate lens status='draft' → 'active'; create #Pattern
		artifact type if ≥3 patterns emerge).

		Pattern emergente: schema/lens evolution segue WI bootstraps.
		INV bootstrap descobriu domain-invariant kind (adr-080); REW
		bootstrap descobriu interpretation contracts (adr-081) +
		production-safety (adr-084) + pattern maturity (adr-085).
		Próximas BCs aplicam pattern + descobrem próximas refinements.
		Metodologia 'evolução governada via descoberta empírica' é
		Mesh-level moat.
		"""
}
