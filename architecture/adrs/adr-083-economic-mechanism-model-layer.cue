package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr083: artifact_schemas.#ADR & {
	id:    "adr-083"
	title: "Introduce #EconomicMechanismModel as Layer 1 above Economic Reality (mechanism design layer reducing exploitability)"
	date:  "2026-05-07"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		ADR-082 introduziu Layer -1 (Economic Reality) declarando 9
		reality invariants (ri-01..09 pos R4++ attack discovery) que
		representam realidades empíricas do ambiente adversarial.
		Realities são propriedades NÃO controladas pelo sistema (sistema
		sobrevive APESAR de). Seguinte questão: como sistema reage
		economicamente a essa realidade declarada?

		Founder R4++ adversarial validation (documented em mesh-economic-
		assumptions.self-review.cue Round 2) demonstrou via end-to-end
		attack 'Loop de Extração Colusivo Multi-BC' que v1 mechanism
		proposals (anti-spam + anti-collusion + anti-recycling) FALHAM
		composicionalmente: payoff_privado > 0 AND impacto_sistêmico < 0
		achievable via formally valid actions only. 4 breakpoints BP-1..4
		identificados em v1; 4 required mechanism upgrades U1-U4 mapped.

		v2 mechanisms (M1 Cold Start Discriminator + M2 Local Anti-
		Collusion + M3 Recycling Constraint + M4 Payoff Alignment)
		propostas pos-R4++ com 4 tensões T-v2-1..4 explicitly identified
		(M1 cold-start false-positive; M2 cluster-boundary detection
		undefined; M3 legitimate factoring vs recycling; M4 valor_real_
		gerado undecidable). Pattern recursive: declarar mecanismos com
		failure surface canonical, NÃO esconder tensões.

		Necessidade: introduzir nova categoria ontológica formal — Layer 1
		Mechanism Design Layer — distinct de:
		- Domain rules (sistema enforça invariants of itself)
		- Reality invariants (sistema sobrevive apesar de — Layer -1)
		- ADRs (decisões reversíveis)
		- Axiomas (hipóteses tensionáveis)

		Layer 1 mechanisms REDUCE exploitability — não eliminate, não
		solve. Sistema deixa de ser permissivo (v1: observe fraud) e
		passa a ser economicamente restritivo (v2: disincentivize fraud).

		Critical design constraint emerged from R4++ adversarial: hidden
		risk = silent failure surface. tq-emm-03 honesty enforcement é
		foundational property — schema MUST require explicit failure
		surface declaration. Founder R5+ canonical: 'O problema não é o
		sistema ter falhas. O problema é o sistema não saber onde falha.'
		"""

	decision: """
		ADOPT introduction of new artifact type #EconomicMechanismModel
		as Layer 1 (above Layer -1 Economic Reality):

		(D1) New schema architecture/artifact-schemas/economic-
		     mechanism-model.cue declarando #EconomicMechanismModel +
		     #EconomicMechanism + #ResidualRisk + #RealityInvariantRef +
		     #SystemImplicationRef + #EconomicMechanismRef discriminated
		     types. 4 quality criteria tq-emm-01..04 (protectsAgainst
		     non-empty + enforces non-empty + honesty enforcement +
		     prefix discipline).

		(D2) Cardinality: singleton (1 instance per system); canonical
		     path strategic/economic-model/mesh-economic-mechanisms.cue
		     (co-resides com Layer -1 mesh-economic-assumptions.cue em
		     mesma diretório strategic/economic-model/ — both são
		     economic-* concerns; Layer separation visível via filename
		     convention mesh-economic-{layer}.cue).

		(D3) Prefix discipline canonical (tq-emm-04 enforces):
		     - mech-NN para economic mechanisms (DISTINCT de mech-*
		       para subdomain mechanisms per existing #MechanismRef em
		       subdomain.cue — name collision avoided via type alias
		       #EconomicMechanismRef)
		     - rr-NN para residual risks
		     - protectsAgainst refs ri-NN (Layer -1)
		     - enforces refs imp-NN (Layer -1)

		(D4) #ArtifactType enum extended em quality-criteria.cue com
		     'economic-mechanism-model'; abbreviation 'emm' registered
		     em comment block conventions.

		(D5) First instance strategic/economic-model/mesh-economic-
		     mechanisms.cue formaliza 4 mechanisms (mech-01..04) v2
		     pos-R4++ adversarial validation. 4 tensões T-v2-1..4
		     explicitly declared como falsePositiveRisks +
		     underspecifications + residualRisks per tq-emm-03 honesty
		     discipline (NÃO ocultadas).

		(D6) tq-emm-03 honesty enforcement Phase 0 runner-verified;
		     Phase 1+ structural CUE pattern (len-sum constraint OR
		     alternative CUE pattern) OR CI gate materializes 'at
		     least one of (falsePositiveRisks / underspecifications /
		     residualRisks) non-empty' por mechanism. CUE disjunction
		     pattern attempted Phase 0 mas creates ambiguous unification
		     quando multiple honesty fields populated simultaneously;
		     deferred a Phase 1+ alternative.

		(D7) Phase A scope ONLY (declarative-only): NO cross-cutting
		     economicMechanismRefs em BCs; NO structural-check
		     enforcement of mechanism-violation. Phase B (futuro)
		     cross-cutting refs + enforcement + adversarial Round 2
		     SRR + potential v3 mechanisms quando NIM bootstrap
		     (Network Intelligence & Mechanism Design BC). Mechanism-
		     level concerns operacional (when attack pays vs costs;
		     incentive landscape modeling; valor_real_gerado function
		     definition) delegadas a economic-mechanism-model.cue
		     refinements + NIM future artifacts.

		**Conceito central introduzido**: 'mechanisms reduce
		exploitability — não eliminate, não solve'. Distinção
		ontológica:
		- Domain invariant (inv-*): sistema enforça
		- Reality invariant (ri-*): sistema sobrevive apesar de
		- Economic mechanism (mech-*): sistema desincentiva exploit
		- ADR: decisão arquitetural reversível
		- Axiom (ax-*): hipótese estratégica tensionável

		Pattern emergente 'Layer 1' (acima de Layer -1) — Economic
		Mechanism Layer materializes mechanism design discipline
		canonical-no-repo.

		**Honesty enforcement structural** (founder R5+ critical):
		tq-emm-03 obriga mecanismos a declarar failure surface
		explicitly. 'Complexidade não é proxy de risco; cobertura
		de falha é'. Hidden risk = silent failure = inválido por
		construção.
		"""

	consequences: """
		(a) Sistema declara canonicamente como reage economicamente a
		    realidade adversarial (Layer -1 ri-NN) — mecanismos
		    explicitly grounded em realidade declared via protectsAgainst
		    refs.

		(b) Mechanism design discipline ganha lugar canônico — não
		    fragmenta em SRRs por BC nem vira heurística operacional
		    perdida.

		(c) NIM bootstrap futuro herda fundação clara: mechanisms são
		    INPUT requirements para incentive landscape modeling;
		    NIM transforma Layer 1 mechanisms em operational policies
		    (scoring + pricing + credit propagation + payoff alignment).

		(d) Honesty enforcement structural (tq-emm-03): cada mechanism
		    obrigado a declarar falsePositiveRisks OR underspecifications
		    OR residualRisks. Hidden risk impossible by discipline
		    (Phase 0 runner-verified; Phase 1+ structural enforcement).

		(e) Pattern recursive falsifiability: paralelo a Round 2 schema
		    economic-assumption-model.self-review.cue (declares schema
		    incompleteness; refinements são EPISTÊMICOS); economic-
		    mechanism-model declares mechanism incompleteness via
		    failure surface fields. Mechanism design admits own
		    limitations canonically.

		(f) Cross-prefix discipline preserved: mech-* (Layer 1)
		    distinct de inv-* (domain rules) e ri-* (reality) e
		    imp-* (implications); type alias #EconomicMechanismRef
		    avoids collision com existing #MechanismRef em
		    subdomain.cue (different ontology — subdomain mechanisms
		    NÃO economic mechanisms).

		(g) Phase B deferred preserves blast-radius small Phase 0;
		    cross-cutting binding aguardará volume real de mechanism
		    instances + NIM design clarity + Round 2 adversarial
		    validation results.

		(h) Tooling impact mínimo Phase 0: #ArtifactType enum +1;
		    sc-pg-01 coveredSchemas inalterado (singleton justifica
		    skip PG); no structural-check kind new yet.

		(i) Reversibility medium: schema é additive non-breaking;
		    remoção pós-adoção exigiria backward-incompat ADR + migration
		    de instance singleton + downstream BC ref cleanup. BlastRadius
		    cross-cutting: foundation for NIM + all future BC mechanism
		    refs Phase B+.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/economic-mechanism-model.cue (#EconomicMechanismModel schema)",
		"#EconomicMechanism + #ResidualRisk discriminated types",
		"mech-NN prefix convention for economic mechanisms (distinct from existing #MechanismRef em subdomain.cue via #EconomicMechanismRef alias)",
		"economic-mechanism-model added to #ArtifactType enum + abbrev emm in conventions",
		"strategic/economic-model/mesh-economic-mechanisms.cue (first instance, 4 mechanisms M1-M4 v2 pos-R4++ com 4 tensões T-v2-1..4 explicitly declared)",
		"tq-emm-03 honesty enforcement (runner-verified Phase 0; structural CUE pattern OR CI gate Phase 1+)",
	]

	derivedArtifacts: [
		"strategic/economic-model/mesh-economic-mechanisms.cue (first instance materializes v2 mechanisms with explicit tensões)",
	]

	principlesApplied: [
		"P0-zero-duplicacao — mechanisms declared once canonically; protectsAgainst/enforces refs são pointers",
		"P10-deterministic-gates-vs-stochastic-recommendations — mechanism design is deterministic constraint declaration; runtime evaluation segue gate discipline",
		"adr-040-structural-vs-semantic-validation-separation — Layer 1 mechanisms são structural design constraints, NÃO advisory recommendations",
		"adr-082-economic-assumption-model-layer — Layer -1 reality é input para Layer 1 mechanisms; ontological cascade",
	]

	rationale: """
		Reversibility medium: schema addition é optional/non-breaking;
		first instance singleton; remoção pós-adoção exigiria backward-
		incompat ADR + migration. BlastRadius cross-cutting: foundation
		for NIM bootstrap + future BC mechanism refs (Phase B+).

		Decisão prioriza HONESTY ENFORCEMENT sobre SCHEMA SIMPLICITY.
		Alternatives consideradas (founder R4++ + R5+ dialectic):
		(A1) Encode v1 mechanisms direto sem adversarial validation —
		     REJECTED por agent push-back (cristalizaria falsa proteção;
		     v1 falhou em R4++ attack); discipline 'adversarial review
		     BEFORE write' applied recursively.
		(A2) Defer mechanism encoding to NIM bootstrap full —
		     REJECTED (Layer 1 declarative-only é stable target para
		     NIM design; sem Layer 1 canonical, NIM design floats sem
		     foundation).
		(A3) Encode mechanisms WITHOUT honesty enforcement (assume
		     hidden risks acceptable) — REJECTED categórico (founder
		     R5+ canonical: hidden risk = silent failure = inválido
		     por construção).
		(B) Layer 1 mechanism schema com tq-emm-03 honesty enforcement
		     + 4 v2 mechanisms instance com tensões T-v2-1..4 explicit —
		     ADOPTED (Esta decisão).

		Conceito central founder R5+: 'O problema não é o sistema ter
		falhas. O problema é o sistema não saber onde falha.'
		Mechanism design transforma sistema de:
		'observa exploits' → 'desincentiva exploits + declara onde
		 mecanismo falha'.

		Sem este shift, BCs futuros + NIM design vão depender de
		mechanism heuristics dispersas em SRRs/comentários sem
		failure surface declarado. Com este shift, sistema declara
		canonicamente mechanism design discipline + honesty —
		Phase B cross-cutting + NIM design operam dentro de boundaries
		explicitamente documentados.

		R4++ adversarial pre-encoding methodology applied recursively
		(produced v2 com tensões captured BEFORE first commit;
		paralelo a R4+ pre-encoding pattern em ADR-082 que added
		ri-07/08 antes de first commit). Pattern emergente:
		adversarial review BEFORE write > post-hoc revision applied
		em cada novo Layer.

		Pattern paralelo a evolução governada via descoberta empírica
		(WI-053 sequence: ADR-077 → ADR-078/079 → ADR-080 → ADR-082 →
		ADR-083). Mesh-level moat: 'modelando ANTES dos problemas se
		manifestarem' (founder framing R4) extended a mechanism
		design (founder R4++ + R5+ disciplines).
		"""
}
