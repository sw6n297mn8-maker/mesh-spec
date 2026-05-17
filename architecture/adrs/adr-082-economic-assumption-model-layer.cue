package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr082: artifact_schemas.#ADR & {
	id:    "adr-082"
	title: "Introduce #EconomicAssumptionModel as Layer -1 economic reality declaration (upstream of all BCs)"
	date:  "2026-05-07"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		R4 + R4+ founder adversarial review (post-Phase 4 INV bootstrap
		completion) identificou 8 vetores adversariais econômicos (E1-E6
		canvas + A7 cross-BC composition + A8 payoff asymmetry) que NÃO
		são propriedades de qualquer BC individual — são propriedades da
		REDE (cross-BC composition em ambiente adversarial).

		Tensão estrutural emergent durante R4 dialectic: declarar esses
		vetores em qualquer BC (e.g., INV) viola encapsulamento (BCs não
		herdam automaticamente); declarar como SRR confunde validação
		com hipótese; declarar como ADR direto permite supersession
		(collusion não vira opcional via decisão); declarar como
		governance file vira documento morto sem enforcement.

		Distinção crítica founder R4 dialectic:
		- ADRs (Architecture Decision Records) são REVERSÍVEIS por nova
		  decisão; representam escolhas arquiteturais.
		- INVARIÂNCIAS DO AMBIENTE (adversarial reality) são propriedades
		  empiricamente observadas do mundo onde o sistema opera; NÃO
		  são tensionáveis por decisão; sistema deve operar APESAR delas.

		Necessidade: introduzir nova categoria ontológica formal —
		'truths that constrain design but are not design decisions' —
		distinct de domain invariants (sistema enforça), structural
		checks (validação), ADRs (decisões), governance (políticas), e
		axiomas (hipóteses estratégicas tensionáveis em domain-
		definition.cue).

		R4+ refined adversarial pre-write iteration: founder R4+ pass
		identificou 3 critical gaps na primeira proposta de instance
		(ri-01 marginal cost language gradient/probabilistic; A7 cross-
		BC composition reality não declarada; A8 payoff asymmetry
		reality não declarada) — corrigidos pre-commit via ri-01
		strengthening + ri-07 + ri-08 additions. Pattern emergente:
		adversarial review BEFORE first commit produces stronger
		artifact than post-hoc revision.
		"""

	decision: """
		ADOPT introduction of new artifact type #EconomicAssumptionModel
		as Layer -1 (upstream de todos BCs):

		(D1) New schema architecture/artifact-schemas/economic-
		     assumption-model.cue declarando #EconomicAssumptionModel
		     struct + #RealityInvariant + #AdversarialCapability +
		     #SystemImplication discriminated types. 4 quality criteria
		     (tq-eam-01..04) garantem absolute language + reality-not-
		     mechanism + grounded implications + prefix discipline.

		(D2) Cardinality: singleton (1 instance per system); canonical
		     path strategic/economic-model/[a-z0-9-]+.cue.

		(D3) Prefix discipline canonical (tq-eam-04 enforces):
		     - ri-NN para reality invariants (DISTINCT de inv-NN domain
		       invariants per #InvariantRef agent-spec.cue regex)
		     - cap-adv-NN para adversarial capabilities
		     - imp-NN para system implications

		(D4) #ArtifactType enum extended em quality-criteria.cue com
		     'economic-assumption-model'; abbreviation 'eam' registered
		     em comment block conventions.

		(D5) First instance strategic/economic-model/mesh-economic-
		     assumptions.cue formaliza 8 reality invariants
		     (ri-01..08) + 3 adversarial capabilities (cap-adv-01..03)
		     + 8 system implications (imp-01..08). R4 attack vectors
		     E1-E6 + R4+ A7 (cross-BC composition) + R4+ A8 (payoff
		     asymmetry) materializados como reality invariants
		     canonical.

		(D6) Phase A scope ONLY (declarative-only): NO cross-cutting
		     economicModelRefs em BCs; NO structural-check enforcement
		     of 'BC decisions MUST NOT violate economic assumptions';
		     NO authoring-policy entry yet. Phase B (futuro)
		     cross-cutting refs + enforcement quando NIM bootstrap
		     (Network Intelligence & Mechanism Design BC) — incentive
		     landscape modeling + mechanism-level concerns delegadas
		     a economic-mechanism-model.cue future artifact.

		**Conceito central introduzido**: 'truths that constrain design
		but are not design decisions'. Distinção ontológica:
		- Domain invariant (inv-*): sistema enforça
		- Reality invariant (ri-*): sistema sobrevive apesar de
		- ADR: decisão arquitetural reversível
		- Axiom (ax-*): hipótese estratégica tensionável
		- Reality invariant: propriedade empírica não negociável

		Pattern emergente 'Layer -1' (antes do domínio) — Economic
		Reality Layer upstream de Glossary/Domain-Model/Structural-
		Checks/Agent-Spec.

		**Disciplina canonical** (founder R4+ alert): omitir ri-*
		crítico = falha estrutural silenciosa (sistema implicitamente
		assume que não existe). Adicionar ri-* errado = ruído
		arquitetural. tq-eam-* + adversarial review pré-commit
		mitigam.
		"""

	consequences: """
		(a) Sistema declara canonicamente o que NÃO controla
		    (adversarial environment com 8 reality invariants) DISTINCT
		    de o que enforça (domain invariants per BC) — honesty
		    arquitetural mature pattern.

		(b) Cross-BC concerns (collusion, latency arbitrage, specification
		    gaming, cross-BC composition exploitation, payoff asymmetry)
		    ganham lugar canônico de declaração — não fragmenta em SRRs
		    por BC nem vira prose perdida em ADRs.

		(c) NIM bootstrap futuro herda fundação clara: realityInvariants
		    são INPUT requirements para mechanism design; NIM transforma
		    invariantes em mecanismos via economic-mechanism-model.cue
		    (incentive landscape modeling — when attack pays vs costs;
		    auto-protection mechanisms).

		(d) Prefix discipline ri-* vs inv-* previne semantic confusion
		    cross-artifact (agent-spec refs inv-* esperam enforceable
		    domain invariants; ri-* refs sinalizam non-enforceable
		    environment property — must be designed for, NÃO assumed
		    away).

		(e) Phase B deferred preserves blast-radius small Phase 0;
		    cross-cutting binding esperará volume real de BCs consuming
		    economic model + NIM design clarity.

		(f) Tooling impact mínimo Phase 0: #ArtifactType enum +1;
		    sc-pg-01 coveredSchemas inalterado (singleton + cardinality
		    1 justifica skip PG; meta-PG aplicável só para tipos com
		    múltiplas instances); no structural-check kind new yet.

		(g) Reversibility medium: schema é additive non-breaking; remoção
		    pós-adoção exigiria backward-incompat ADR + migration de
		    instance singleton. BlastRadius cross-cutting: foundation
		    for all future BC economic concerns; NIM bootstrap depends.

		(h) Ontology vocabulary expansion: 'reality invariant' termo
		    canonical introduzido — distinct semantics from existing
		    'invariant' (domain rule), 'axiom' (strategic hypothesis),
		    'principle' (architectural guideline).
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/economic-assumption-model.cue (#EconomicAssumptionModel schema)",
		"#RealityInvariant + #AdversarialCapability + #SystemImplication discriminated types",
		"ri-NN prefix convention for reality invariants (distinct from inv-NN domain invariants per tq-eam-04)",
		"economic-assumption-model added to #ArtifactType enum + abbrev eam in conventions",
		"strategic/economic-model/mesh-economic-assumptions.cue (first instance, 8 ri-NN + 3 cap-adv-NN + 8 imp-NN)",
	]

	derivedArtifacts: [
		"strategic/economic-model/mesh-economic-assumptions.cue (first instance materializes E1-E8 reality invariants)",
	]

	principlesApplied: [
		"P0-zero-duplicacao — economic reality declared once canonically, referenced via ri-NN refs",
		"P10-deterministic-gates-vs-stochastic-recommendations — reality invariants são empirical declarations not interpretive recommendations",
		"adr-040-structural-vs-semantic-validation-separation — Layer -1 reality é structural foundation, NÃO advisory layer",
		"adr-080-extend-structural-check-domain-invariants — paralelo ontological extension pattern",
	]

	rationale: """
		Reversibility medium: schema é additive non-breaking; first
		instance singleton; remoção pós-adoção exigiria backward-
		incompat ADR. BlastRadius cross-cutting: foundation for cross-BC
		economic concerns; NIM bootstrap depends; Phase B cross-cutting
		refs to all BCs eventually.

		Decisão prioriza ONTOLOGICAL CLARITY sobre CONVENIENCE.
		Alternatives consideradas (founder R4 dialectic):
		(A1) Document em SRR INV (declarative cross-BC concerns) —
		     REJECTED (SRR = validation; R4 = environment definition;
		     mistura confusa; SRR vira business semantics)
		(A2) Document em ADR direto — REJECTED (ADR = decision; R4 =
		     reality empírica; supersession would falsify reality —
		     'collusion exists' não pode virar opcional)
		(A3) Add axioms ax-08..13 em domain-definition.cue —
		     REJECTED (axioms são strategic hypotheses tensionáveis
		     per CLAUDE.md; reality invariants NÃO são tensionáveis)
		(A4) New governance file sem schema — REJECTED (sem schema =
		     drift por construção; CLAUDE.md mandate; risco virar
		     documento morto)
		(B) Novo artifact type Layer -1 — ADOPTED (Esta decisão;
		     ontological clarity + cardinality singleton + Phase A
		     scope tight + Phase B cross-cutting deferred)

		Conceito central founder R4: 'truths that constrain design but
		are not design decisions' transforma sistema de:
		'declara invariantes que enforça' →
		'declara invariantes que enforça + propriedades do ambiente
		 onde o sistema deve sobreviver'.

		Sem este shift, BCs futuros + NIM design vão depender de
		descoberta empírica adversarial dispersa em SRRs/ADRs/
		comentários. Com este shift, sistema declara canonicamente
		realidade adversarial — Phase B cross-cutting + NIM design
		operam dentro de boundaries explicitamente documentados.

		R4+ adversarial pre-commit iteration produced stronger first
		instance: 3 critical gaps identificados pre-write (ri-01
		marginal cost gradient language; A7 cross-BC composition
		missing; A8 payoff asymmetry missing) corrigidos antes de
		first commit. Pattern: adversarial review BEFORE first
		commit > post-hoc revision.

		Pattern paralelo a evolução governada via descoberta empírica
		(WI-053 sequence: ADR-077 schema add → ADR-078/079 PG hardening
		→ ADR-080 structural-check kind add → ADR-082 Layer -1
		introduction). Mesh-level moat: 'modelando ANTES dos
		problemas se manifestarem' (founder R4 framing). Pattern
		emergente 3 níveis de declaration honesty: agent-level
		enforced + agent-level acknowledged + Layer -1 reality
		declared.
		"""
}
