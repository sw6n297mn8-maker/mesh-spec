package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr080ExtendStructuralCheckDomainInvariants: build_time.#SelfReviewReport & {
	reportId: "srr-adr-080"

	artifactPath:       "architecture/adrs/adr-080-extend-structural-check-domain-invariants.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-07"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-080 estende #StructuralCheck com novo kind
			'domain-invariant' fundando Phase 3.5 enforcement INV.
			Decisão derivada de tensão estrutural identificada
			durante WI-053 INV bootstrap Phase 3.5 design session:
			invariantes de domínio do INV (8 invariants em
			contexts/inv/domain-model.cue) NÃO cabem nos 8 kinds
			existentes do #StructuralCheck (filesystem-level apenas).

			Trade-offs avaliados pre-decisão (founder + agent
			dialectic):
			(A1) Novo artifact type #DomainEnforcementSpec —
			REJEITADO: fragmenta enforcement em múltiplos lugares.
			(B) Adaptar a existing kinds — REJEITADO: perde
			atomicidade + idempotência + boundary temporal (5/8
			invariantes críticos).
			(A2) Extend #StructuralCheck com novo kind isolado —
			ADOPTED: preserva 8 kinds existentes + unifica
			enforcement filesystem + semântico no mesmo mecanismo.

			Decisão materializa princípio 'garantia + limite
			explícito': sistema declara canonicamente o que É
			garantido + o que NÃO É (runtimeGap field) + onde está
			enforcement do gap (enforcedBy field). Runtime gaps NÃO
			são falhas — são limites conhecidos e documentados.
			Honesty arquitetural por construção.

			3 mudanças coordenadas em
			architecture/artifact-schemas/structural-check.cue:
			(D1) 'domain-invariant' adicionado a #StructuralCheckKind
			enum (8 → 9 kinds). (D2) #DomainInvariantRule adicionado
			a #StructuralCheckRule disjunction + branch correspondente
			em #StructuralCheck discriminated union. (D3) Definido
			#DomainInvariantRule com fields: invariantId (regex
			^inv-*) + assertion? + coverage struct (buildTime +
			validationTime + runtimeRequired) + runtimeGap? struct
			(description + enforcedBy) + forbidden? list.

			Restrições preservadas:
			- 0 alterações nos 8 kinds existentes (backward compat)
			- 0 campos novos em top-level #StructuralCheck (rule shape
			  isolation)
			- Tooling atual funcional (instances sc-cv-*, sc-pg-*,
			  sc-adr-* continuam válidas sem mudança)

			Reversibility medium: schema addition é optional/
			non-breaking; remoção pós-adoção exigiria backward-incompat
			ADR + migration de instances domain-invariant. BlastRadius
			cross-cutting: enforcement transversal + potencial backfill
			para múltiplos BCs com domain-model (after Phase 3.5 INV
			validates the pattern).

			Backward-compat: 0 instances de #StructuralCheck existentes
			afetadas; novo kind opcional/aditivo. cue vet
			./architecture/artifact-schemas/ EXIT=0 pos-mod confirma
			zero breaking change.

			Schema satisfação tq-adr-XX: tq-adr-01 (alternatives
			consideradas com substância — A1 + B + A2 avaliadas com
			rationale rejeição) ✓; tq-adr-02 (reversibility medium +
			blastRadius cross-cutting refletem decisão real) ✓;
			tq-adr-03 (affectedArtifacts path real
			architecture/artifact-schemas/structural-check.cue) ✓;
			tq-adr-04 (impacto rastreável — affectedArtifacts +
			plannedOutputs + derivedArtifacts non-empty satisfaz
			at-least-one-of-3 per sc-adr-01) ✓.

			Round único suficiente — qualidade incorporada via founder
			pre-write template canônico (founder forneceu ADR + schema
			diff + first INV check format, agent transcreve adaptando
			a schema reality detectada via cue vet). Pre-write founder
			review aplicou enquadramento conceitual: 'novo kind isolado
			+ rule shape isolation + 0 mudança em existing kinds' —
			constraints incorporadas no schema mod.

			Lessons learned: (a) extensão de schema critical
			infrastructure (#StructuralCheck) é decisão arquitetural
			não-trivial mesmo quando aditiva; ADR isola decision
			rationale + plannedOutputs + reversibility; (b) sequência
			emergente WI-053 (ADR-077 schema add → ADR-078 PG hardening
			→ ADR-079 PG empirical refinement → ADR-080 schema
			fundação Phase 3.5) demonstra metodologia 'evolução
			governada via descoberta empírica' como Mesh-level moat
			real (não placebo).
			"""
	}]

	findings: {}

	summary: """
		ADR-080 (Extend #StructuralCheck with domain-invariant kind)
		funda Phase 3.5 INV enforcement via 3 mudanças coordenadas:
		'domain-invariant' kind add + #DomainInvariantRule type
		definition + branch em discriminated union. Pattern paralelo
		ADR-077 (schema add isolated). Conceito central 'garantia +
		limite explícito' (runtimeGap declarado canonicamente).
		Backward compat: 0 mudança em 8 kinds existentes. Reversibility
		medium; blastRadius cross-cutting (potencial backfill multi-BC).
		3 alternatives avaliadas (A1 novo artifact REJEITADO; B adapt
		existing REJEITADO; A2 extend ADOPTED). tq-adr-01..04
		satisfeitos. cue vet clean.
		"""

	singleRoundRationale: """
		Authoring via founder pre-write template canônico (founder
		forneceu ADR-080 text + schema diff + first INV check shape
		em sessão Phase 3.5 design). Agent transcreve adaptando a
		schema reality detectada (founder example tinha 'target' field
		que não existe no schema; real schema usa artifactType +
		errorMessage required + id regex sc-X-NN). Round único —
		qualidade incorporada via founder review iterativo durante
		composição (constraints absorbed: 0 mudança em existing kinds;
		rule shape isolation; backward compat). Pattern paralelo
		ADR-077 schema add isolation discipline.
		"""
}
