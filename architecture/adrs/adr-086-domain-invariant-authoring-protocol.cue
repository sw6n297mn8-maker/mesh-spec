package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr086: artifact_schemas.#ADR & {
	id:    "adr-086"
	title: "Canonicalize Domain-Invariant Structural Check Authoring Protocol (PG extension)"
	date:  "2026-05-11"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		ADR-080 (2026-05-07) estendeu schema #StructuralCheck adicionando
		kind 'domain-invariant', com scope explícito SCHEMA-ONLY
		(affectedArtifacts limita a architecture/artifact-schemas/
		structural-check.cue; plannedOutputs apenas 3 items schema-level).
		ADR-080 NÃO promete extensão do PG correspondente.

		INV bootstrap aplicou primeira instância (architecture/structural-
		checks/inv-domain-model.cue per derivedArtifacts de ADR-080).
		REW Phase 3.5a (2026-05-09) aplicou segunda instância (15
		sc-rew-* rules) durante a qual emergiu via founder dialectic
		(14 fissures iteradas pre-batch) um protocolo canônico que
		NÃO foi formalizado em nenhum artefato:

		(1) Estrutura de camadas analíticas — labeled internamente
		    'meta-template level-2' (origem histórica) — descrevendo
		    dimensões progressivas de validação que invariants podem
		    invocar selectively conforme natureza.

		(2) Disciplina de coverage flags (build-time / validation-time /
		    runtime-required) declaring explicit cobertura por dimensão.

		(3) Protocolo de runtimeGap declaration para honest architectural
		    declaration de limite quando build-time enforcement não cobre.

		(4) Protocolo de founder dialectic war-game derivation — REGRA
		    FINAL V2 ('esse erro continuaria válido ao longo do tempo?')
		    + TESTE EPISTEMOLÓGICO V2 ('novo BC consegue interpretar +
		    provar uso correto + detectar drift sem contexto adicional?').

		(5) Disciplina de behavioral non-applicability declaration para
		    invariants cuja natureza é arquitetural/anti-corrupção (não
		    structurally enforceable).

		Estado atual:
		- Schema tem o kind domain-invariant ✅
		- PG structural-check.cue NÃO menciona domain-invariant
		  (grep confirmou; lista explicitamente apenas os 4 kinds
		  originais em múltiplos lugares — gapPolicy, heuristics,
		  finalValidation)
		- Protocolo canônico vive APENAS em SRR rew-structural-check-
		  3-5a.self-review.cue (não-canonical)
		- 2/10 BCs com domain-invariant rules (INV + REW); 8 BCs pendentes
		  (bdg/cmt/ctr/dlv/idc/npm/p2p/ssc)

		Sem canonicalização do protocolo, backfill aos 8 BCs vira
		template-copy de INV/REW — anti-pattern EXPLICITAMENTE proibido
		pelo PG atual (gapPolicy: 'rule sem caso concreto é ruído sobre
		o gate determinístico'; 'NÃO infira rules por simetria').

		Tensão estrutural:
		- Forçar founder dialectic ad-hoc per BC sem guidance = 8x
		  pressure cycles sem template para minimum quality
		- Bulk-copy sem dialectic = anti-pattern
		- Defer indefinidamente = manter P10 violation em 80% do mesh

		Decisão necessária: canonicalizar o protocolo emergente como
		authoring discipline canônica para kind domain-invariant ANTES
		de bulk authoring aos 8 BCs.
		"""

	decision: """
		ADOPT 7 decisões coordenadas:

		(D1) NAMING CANONICAL: o protocolo é canonizado como
		     **Domain-Invariant Structural Check Authoring Protocol**.
		     Sigla 'DISCAP' permitida apenas como alias interno em
		     referências subsequentes (NÃO como identidade primária —
		     evita degradação para jargão). Naming 'meta-template
		     level-2' permanece em rationale como origem histórica
		     (emergência REW Phase 3.5a) mas NÃO é o nome canônico.

		(D2) PROGRESSIVE APPLICABILITY LADDER (7 LAYERS):

		     L1 PRESENCE — campo/bloco DEVE existir
		     L2 CROSS-FIELD — relação entre fields/blocks coerente
		     L2.5 ADOPTION PROOF — semanticHash binding (proof of
		          real adoption, not just declarative)
		     L3 RESOLVABLE CONTRACT — refs DEVEM resolver
		     L4 VERSIONED — version-frozen at decision time
		     L5 FRESHNESS HEURISTIC — temporal validity bounds
		     L6 DECISION↔INTERPRETATION COHERENCE — decisão DEVE seguir
		        de interpretation (não diverge silenciosamente)
		     L7 DECISION CONTEXT — scope + magnitude declarados +
		        RE-VALIDATION REQUIREMENT

		     Layers são INDEPENDENTLY APPLICABLE per rule. NÃO é
		     obrigação rígida que toda rule invoque todos 7 layers.

		     OBRIGAÇÃO POR RULE:
		     - Declarar applicable layers (lista explícita)
		     - Para cada layer NON-applicable, declarar rationale
		       explícito de non-applicability
		     - RE-VALIDATION REQUIREMENT (RE-VAL flag) declared quando
		       invariant tem evolução temporal/contextual

		     Anti-pattern proibido: silent omission de layers (sem
		     declaration nem rationale).

		     Exemplo empírico REW Phase 3.5a (matriz canônica):
		     - sc-rew-08 bounded-score: ALL layers + RE-VAL (full
		       ladder — invariant complexo)
		     - sc-rew-12 model-version-binding: L1+L2+L4 apenas
		       (subset — invariant estrutural simples)
		     - sc-rew-15 temporal-tolerance: L2+L5+RE-VAL (subset
		       temporal-only)

		(D3) COVERAGE FLAGS DISCIPLINE:

		     Per rule, declarar coverage struct {buildTime,
		     validationTime, runtimeRequired} per schema #DomainInvariant
		     Rule.coverage (per ADR-080).

		     - buildTime=true: enforceable em commit por build-time
		       validation tooling
		     - validationTime=true: enforceable em instance validation
		       step (advisory layer)
		     - runtimeRequired=true: requer runtime context (não
		       enforceable build-time)

		     At least one flag MUST be true; quando runtimeRequired=true,
		     runtimeGap field MANDATORY.

		(D4) RUNTIMEGAP DECLARATION PROTOCOL:

		     Per ADR-080, runtimeGap field disponível. Domain-Invariant
		     Structural Check Authoring Protocol canoniza conteúdo
		     obrigatório:
		     - description: o que NÃO é build-time-enforceable
		     - enforcedBy: onde runtime enforcement vive (aggregate
		       lifecycle / build-time tooling / external system)

		     Honesty arquitetural pattern paralelo a cst-system-boundary-
		     acknowledged (INV agent-spec): declaração canônica de
		     limite real, não omissão silenciosa.

		(D5) FOUNDER DIALECTIC WAR-GAME PATTERN:

		     Cada candidate rule MUST emerge de UM dos seguintes via
		     dialectic pressure-test 'como exatamente quebra em
		     produção?':
		     - concrete production-break case observado, OR
		     - credible pre-production failure mode (com cenário
		       articulado explícito, NÃO especulação genérica)

		     Permite rules preventivas legítimas pre-PMF/pre-production
		     enquanto preserva anti-template-copy discipline.

		     REGRA FINAL V2: 'esse erro continuaria válido ao longo do
		     tempo?' — triggers obrigatórios quando aplicável:
		     - replay (re-verificação determinística)
		     - periodic audit
		     - pre-critical consumer commit
		     - freshness expiry
		     - Phase N+1 telemetry

		     TESTE EPISTEMOLÓGICO V2: 'novo BC consegue interpretar +
		     provar uso correto + detectar drift sem contexto adicional?'
		     — requires checking whether L3 (resolvable contract), L2.5
		     (adoption proof) and L5 (freshness heuristic) apply; if not
		     applicable, explicit non-applicability rationale required.
		     Pattern preserved: progressive ladder, NÃO rigid checklist.

		     Anti-pattern proibido: rule emerging from symmetry com
		     outros BCs (template-copy). Cada rule deriva de UM caso
		     concreto observable OR pre-production failure mode
		     articulado.

		(D6) BEHAVIORAL NON-APPLICABILITY DECLARATION:

		     Invariants behavioral puras (architectural review;
		     anti-corruption discipline) que NÃO são structurally
		     enforceable DEVEM ser declared explicit como
		     non-applicable estruturalmente em domain-invariant rule
		     comment OR no domain-invariant rule rationale.

		     Empirical pattern REW Phase 3.5a: 2 invariants Part 1
		     (model-policy-independence + payload-opacity) declaradas
		     non-applicable; deferred a validation-prompts advisory
		     Phase N+1.

		     Anti-pattern proibido: forçar structural rule em behavioral
		     invariant (produces false-positives ou aspirational gates).

		(D7) PG `structural-check.cue` PATCH como plannedOutput desta ADR:

		     Adicionar:
		     (a) Nova section 'domain-invariant-authoring' no workOrder
		         OR sub-blocks por kind nas sections existentes (decisão
		         estrutural deferida ao patch authoring)
		     (b) Novos tq-scg-NN criteria específicos para Domain-Invariant
		         Structural Check Authoring Protocol (estimativa: +5-7
		         critérios cobrindo layer declaration, coverage flags,
		         runtimeGap protocol, war-game derivation, behavioral
		         non-applicability)
		     (c) Novos finalValidation steps cobrindo o protocol
		     (d) Atualizar gapPolicy + heuristics existentes para incluir
		         5º kind operacional (domain-invariant)
		     (e) Atualizar exemplos para incluir sc-inv-* e sc-rew-* como
		         referências canônicas

		RESTRIÇÕES (manter compatibility):
		- 4 kinds originais (required-block, reference-exists,
		  same-artifact-consistency, conditional-file-presence)
		  authoring guidance INALTERADA
		- tq-scg-01..03 existentes INALTERADOS (Domain-Invariant
		  Structural Check Authoring Protocol adiciona; não substitui)
		- Backward compat: INV + REW existing instances DEVEM passar
		  audit retroativo (ou ter follow-up corrective patches
		  declarados)
		"""

	consequences: """
		(a) Bulk authoring aos 8 BCs (bdg/cmt/ctr/dlv/idc/npm/p2p/ssc)
		    structural-checks vira PG-guided process com discipline
		    consistente; cada BC tem founder section-gate cycle real
		    (não template-copy).

		(b) Pattern transferable: protocol formalizado significa que
		    backfill futuro (BC novo OR primary-agent revision) carrega
		    same authoring discipline.

		(c) Honesty arquitetural preserved: layer applicability
		    declaration + non-applicability rationale forçam disclosure
		    de cobertura real; silent omission é detectável.

		(d) Cross-BC consistency: same protocol applied → same shape de
		    rules → comparable structural-checks entre BCs. Pattern
		    analysis emerge (which BCs need L7? which only L1+L2?).

		(e) Founder dialectic remains essential: protocolo NÃO substitui
		    founder review; STRUCTURES founder review fornecendo
		    framework de pressure-test (REGRA FINAL V2 + TESTE
		    EPISTEMOLÓGICO V2).

		(f) Progressive ladder permite simple invariants permanecerem
		    simple: rules com only L1+L2 (presence + cross-field) são
		    canonical, não inferior. Rigid 7-layer obligation rejeitada
		    explicitamente.

		(g) Pattern paralelo ADR-085 (pattern extraction lens
		    decision-systems-with-truth-boundaries): ADR-085 extrai
		    SUBSTÂNCIA do pattern (truth boundaries como decision
		    domain); este ADR extrai FORMA de authoring (how to
		    formalize invariants of any decision system). Substância
		    vs forma são complementary; ambos pos-INV/REW empirical
		    generalization.

		(h) RE-VAL flag canonicalization fecha drift detection: invariants
		    sujeitos a evolução declaram explicit triggers (replay /
		    audit / freshness / Phase N+1 telemetry). Sem RE-VAL,
		    invariant valida POINT IN TIME; com RE-VAL, valida
		    OVER TIME.

		(i) Retroactive audit: INV + REW existing structural-checks
		    DEVEM ser auditados contra Domain-Invariant Structural
		    Check Authoring Protocol. Provável gap: INV (Phase 3.5
		    monolithic pre-meta-template) pode ter gaps de declaration;
		    REW Phase 3.5a was the genesis dialectic so likely
		    conforming. Audit findings produzem corrective patch WIs
		    (separate from this ADR).

		(j) ADR-080 scope retroactively clarified: ADR-080 = schema
		    extension; ADR-086 = authoring discipline. Decoupled
		    decisions; ADR-086 não modifica ADR-080.

		(k) Pre-production failure mode admissibility (D5 ajuste): permite
		    rules preventivas legítimas baseadas em cenário articulado
		    pre-production, enquanto preserva anti-template-copy
		    discipline. Crítico para BCs com low operational volume
		    Phase 0 que ainda não têm production-break cases observados.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/production-guides/structural-check.cue",
	]

	plannedOutputs: [
		"New section OR sub-blocks for domain-invariant authoring in production-guides/structural-check.cue workOrder",
		"New tq-scg-NN criteria specific to Domain-Invariant Structural Check Authoring Protocol (≥5 criteria covering layer declaration + coverage flags + runtimeGap + war-game derivation + behavioral non-applicability)",
		"New finalValidation steps for the protocol discipline",
		"Update gapPolicy + heuristics for 5th kind operational (domain-invariant)",
		"Update canonical examples to include sc-inv-* and sc-rew-* references",
	]

	derivedArtifacts: [
		"Retroactive audit reports for architecture/structural-checks/inv-domain-model.cue + architecture/structural-checks/rew-domain-model.cue (separate WIs; gaps produce corrective patches)",
		"Forward-application of Domain-Invariant Structural Check Authoring Protocol to 8 BCs pending structural-checks (bdg/cmt/ctr/dlv/idc/npm/p2p/ssc) — separate WIs per BC",
	]

	principlesApplied: [
		"P10-deterministic-gates-vs-stochastic-recommendations",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-053-universal-coverage-cascade-ordering",
		"adr-057-manual-authoring-protocol-section-gates",
		"adr-080-extend-structural-check-domain-invariants (complementary at PG layer)",
		"adr-085-pattern-extraction-decision-systems-with-truth-boundaries (parallel post-empirical generalization)",
	]

	rationale: """
		Reversibility medium: protocol é canonical mas evolutivo —
		patches futuros possíveis quando empirical evidence justificar
		layer additions/refinements. Mudança material exigiria ADR
		supersession + migration de existing instances (INV + REW +
		any new). Layers atuais (7) refletem REW Phase 3.5a empirical
		emergence; n=3+ BCs aplicando o protocolo podem revelar layer
		adições legítimas (e.g., L8 ADVERSARIAL-RESISTANCE se BC
		adversarial-heavy emerge).

		BlastRadius cross-cutting: afeta authoring discipline
		transversal — todos future domain-invariant authoring + 8
		BCs pending + INV/REW retroactive audit + pattern
		formalization.

		Decisão prioriza DISCIPLINE OVER UNIFORMITY:
		- Progressive ladder (D2) > rigid obligation: simple invariants
		  permanecem simple; complex invariants invocam more layers
		  conforme natureza demanda
		- Explicit non-applicability declaration (D2) > silent omission:
		  founder pode auditar choice de layers; drift detectable
		- War-game derivation (D5) > template copy: each rule earns
		  its place via concrete production-break case OR articulated
		  pre-production failure mode

		Naming '**Domain-Invariant Structural Check Authoring Protocol**'
		(per founder ajuste explícito) — substitui internal emergence
		label 'meta-template level-2' que era origin marker not
		destination name. Naming é semantically explicit: domain-invariant
		kind + authoring + protocol. Sigla 'DISCAP' permitida apenas
		como alias interno em referências subsequentes — NÃO como
		identidade primária (evita degradação para jargão).

		**Origem histórica do protocolo** (rationale preservation):
		Meta-template level-2 emergiu em REW Phase 3.5a (2026-05-09)
		via founder dialectic iterativo pre-batch:
		- Iteração sc-rew-08 round 1: 5 fissures (range→semantic;
		  local→cross-BC; implicit→resolvable; static→versioned;
		  authoritative→strategy)
		- Iteração sc-rew-08 round 2: 4 fissures (calibration
		  freshness; discoverability ≠ adoption; replay ≠ contextual;
		  interpretation ≠ action)
		- Iteração sc-rew-08 round 3: 4 fissures (TOCTOU semântico;
		  hash ≠ significado; freshness local ≠ global; multi-BC
		  feedback loop)
		- Edge crack final: coerente ≠ correto (decision context
		  declaration L7)
		Capturado em governance/build-time/self-reviews/rew-structural-
		check-3-5a.self-review.cue.

		**3 transformational jumps registered** (REW Phase 3.5a SRR):
		(a) 'validar dados → validar decisões'
		(b) 'validar decisões → validar significado compartilhado'
		(c) 'validar significado → validar evolução do erro ao longo
		    do tempo'
		Layers correspondem progressivamente a essas jumps:
		L1+L2 (validar dados) → L3+L4+L2.5 (validar decisões) →
		L5+L6 (validar significado) → L7+RE-VAL (validar evolução).

		**Pattern paralelo ADR-085**:
		ADR-085 extraiu pattern decision-systems-with-truth-boundaries
		como lens (capturing SUBSTÂNCIA do pattern emergente em REW).
		Esta ADR extrai FORMA de authoring protocol (capturing HOW to
		formalize invariants of decision systems). Substância (lens)
		+ Forma (protocol) são complementary contributions of REW Phase
		3.5a empirical work.

		**Sequencing rationale**:
		PG patch é plannedOutput desta ADR (NÃO part of ADR file).
		ADR estabelece a decisão arquitetural; PG patch instancia.
		Separation respects CLAUDE.md classification: ADR para
		semantic change (canonical protocol formalization); PG patch
		é derivation. Per cascade ordering, PG patch DEVE ser commited
		antes de bulk authoring aos 8 BCs (cascade: ADR → PG patch →
		BC instances).

		**Pre-production failure mode admissibility** (D5 founder ajuste):
		Versão inicial draft exigia 'production-break case concreto'
		strictly. Founder ajuste expandiu para incluir 'credible
		pre-production failure mode com cenário articulado'. Rationale:
		Phase 0 mesh-spec é pre-PMF — muitos BCs ainda não têm volume
		operacional que produz production-break cases observados.
		Forçar production-only admissibility bloquearia rules preventivas
		legítimas. Salvaguarda contra abuse: pre-production failure
		mode DEVE ter cenário articulado explícito (não especulação
		genérica) — preserva anti-template-copy discipline enquanto
		permite preventive structural-checks.

		**Phase 0 alignment**:
		Build-time validation tooling que executa structural-checks
		ainda é Phase 1+ (post-WI-068). Mas existência das rules +
		protocol canonicalization são valiosos pré-tooling: (a) rules
		são executable specifications; (b) protocol forma canonical
		authoring discipline; (c) audit trail evidences invariants
		were declared rigorously, not aspirationally — esta evidência
		é audit grade per LGPD/Bacen exposure standards.

		**Anti-pattern guard explicit**:
		PG atual gapPolicy proíbe 'rules especulativas' + 'inferência
		por simetria entre artifactTypes'. Este protocolo estende esta
		proteção para domain-invariant kind: war-game derivation (D5)
		é a discipline anti-template-copy specifically for domain-
		invariant. Sem o protocolo canonizado, 8 BCs bulk authoring
		violaria current PG gapPolicy by construction.

		**TESTE EPISTEMOLÓGICO V2 progressive form** (D5 founder ajuste):
		Versão inicial draft especificava 'requires L3 + L2.5 + L5'
		— contradizia progressive ladder per D2. Founder ajuste:
		teste verifica WHETHER L3, L2.5, L5 apply; non-applicability
		exige rationale explícito. Preserves ladder consistency:
		teste epistemológico é OBLIGATORY check, mas resultado pode
		ser layer-non-applicable com rationale — não obrigação rígida
		de invocar os 3 layers.
		"""
}
