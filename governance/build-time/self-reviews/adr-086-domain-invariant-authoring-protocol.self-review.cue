package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr086: build_time.#SelfReviewReport & {
	reportId: "srr-adr-086-domain-invariant-authoring-protocol"

	artifactPath:       "architecture/adrs/adr-086-domain-invariant-authoring-protocol.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-11"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-086 canonicaliza Domain-Invariant Structural Check
			Authoring Protocol como autoria discipline canônica para
			kind 'domain-invariant' (added by ADR-080).

			**Gap origem**: ADR-080 (2026-05-07) estendeu schema
			#StructuralCheck com kind domain-invariant scope schema-only
			(affectedArtifacts limitado a artifact-schemas; NÃO PG).
			REW Phase 3.5a (2026-05-09) emergiu meta-template via founder
			dialectic (14 fissures); captured APENAS em SRR
			rew-structural-check-3-5a.self-review.cue. PG structural-
			check.cue NÃO atualizado (grep confirmou — 4 kinds originais
			listed em gapPolicy/heuristics/finalValidation, zero menções
			a domain-invariant).

			**Diagnóstico estrutural**: gap NÃO é dívida de implementação
			de ADR-080 (scope schema-only explicit); é descoberta empírica
			pós-ADR-080. Por isso ADR novo (não patch direto de PG).

			**Decisão**: 7 decisões coordenadas:
			(D1) Naming canonical 'Domain-Invariant Structural Check
			     Authoring Protocol' (sigla DISCAP só como alias interno).
			(D2) Progressive applicability ladder (7 LAYERS); obrigação
			     per rule = declare applicable + explicit non-applicability
			     rationale.
			(D3) Coverage flags discipline (build-time / validation-time
			     / runtime-required) com runtimeGap mandatory quando
			     runtime-required=true.
			(D4) RuntimeGap declaration protocol — description + enforcedBy.
			(D5) Founder dialectic war-game pattern — REGRA FINAL V2 +
			     TESTE EPISTEMOLÓGICO V2; admite production-break case
			     OR credible pre-production failure mode.
			(D6) Behavioral non-applicability declaration para invariants
			     non-structurally-enforceable.
			(D7) PG structural-check.cue patch como plannedOutput (não
			     part of ADR file; separate commit downstream).

			**4 founder ajustes pre-write incorporados**:
			(1) Naming primary = full string; sigla 'DISCAP' demoted a
			    alias interno apenas (evita degradação para jargão).
			(2) D5 admissibility expandida: 'concrete production-break
			    case OR credible pre-production failure mode' (com cenário
			    articulado; preserva anti-template-copy enquanto permite
			    preventive rules pre-PMF/Phase 0).
			(3) D5 TESTE EPISTEMOLÓGICO V2 reformulado: 'requires checking
			    whether L3, L2.5 and L5 apply; if not applicable, explicit
			    non-applicability rationale required' (preserva progressive
			    ladder; teste é OBLIGATORY check mas layer applicability
			    pode ser non-applicable com rationale).
			(4) D3 'enforceable em commit por runner' → 'enforceable em
			    commit por build-time validation tooling' (evita vazamento
			    runtime semantics).

			**Schema satisfaction**:
			- id 'adr-086' regex match
			- title concreto declarando scope (PG extension)
			- decisionClass 'structural' (extension de PG canônico)
			- decider 'founder'
			- status 'accepted'
			- context + decision + consequences + rationale todos
			  substantivos
			- reversibility 'medium' + blastRadius 'cross-cutting'
			  proporcional ao impacto
			- affectedArtifacts (production-guides/structural-check.cue)
			- plannedOutputs (5 items para PG patch)
			- derivedArtifacts (retroactive audit INV/REW + forward 8 BCs)
			- principlesApplied (6 ADRs/principles anchoring)

			cue vet ./... EXIT=0.

			Pattern paralelo ADR-085 (lens extraction) + ADR-080 (schema
			extension) — sequência empirical generalization post-INV/REW.
			"""
	}]

	findings: {}

	summary: """
		ADR-086 canonicaliza Domain-Invariant Structural Check Authoring
		Protocol como autoria discipline para kind 'domain-invariant'
		adicionado por ADR-080. Fechamento de gap empirical pós-ADR-080:
		schema teve extensão mas PG NÃO (verified via grep). Meta-template
		level-2 emergente em REW Phase 3.5a (captured em SRR únicamente)
		formalizado canonicamente.

		7 decisões coordenadas: D1 naming canonical (sigla DISCAP só
		alias); D2 progressive 7 LAYERS ladder com applicable/non-
		applicable declaration discipline; D3 coverage flags (build-time/
		validation-time/runtime-required) + runtimeGap mandatory quando
		runtime-required; D4 runtimeGap content protocol; D5 war-game
		derivation (REGRA FINAL V2 + TESTE EPISTEMOLÓGICO V2) com
		admissibility production-break OR credible pre-production
		failure mode; D6 behavioral non-applicability declaration; D7
		PG structural-check.cue patch como plannedOutput.

		4 founder ajustes pre-write incorporados (naming demotion da
		sigla; D5 admissibility expansion; teste epistemológico
		progressive form; build-time tooling naming). cue vet ./... EXIT=0.

		Sequence next: PG patch como plannedOutput (separate commit) →
		retroactive audit INV/REW + forward authoring aos 8 BCs (separate
		WIs).
		"""

	singleRoundRationale: """
		ADR-086 emergiu como decisão direta sintetizando protocolo já
		pressure-tested empiricamente em REW Phase 3.5a (14 fissures
		founder dialectic iterativas; meta-template level-2 ratificado).
		Trabalho dialectic ocorreu DURANTE REW Phase 3.5a authoring;
		ADR-086 é canonicalization artifact desse trabalho — não exige
		rounds dialectic adicionais para si próprio.

		Founder review pré-write produziu 4 ajustes substantivos (naming
		demotion da sigla; D5 admissibility expansion; teste epistemológico
		progressive form; build-time tooling naming) incorporados antes
		do write — equivalent functional a um round de revisão consolidado
		em pre-write phase.

		Pattern paralelo a srr-rew-structural-check-3-5a (also single-
		round): meta-template ratificado via founder dialectic iterativo
		pre-batch; round único pós-write suficiente quando dialectic já
		consumiu sua função em pre-batch phase.
		"""
}
