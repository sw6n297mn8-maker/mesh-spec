package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def051: artifact_schemas.#DeferredDecision & {
	id:     "def-051"
	title:  "True-coverage entidade->manifest: exige kind novo (declared-id-requires-file) + instancias"
	date:   "2026-06-05"
	status: "open"

	description: """
		adr-144 materializa manifest-conformance + manifest-ref-integrity (5 checks). Fica deferida a
		TRUE-COVERAGE na direcao entidade->manifest: garantir que toda entidade que DEVE ter manifest
		(BC que consome Port -> PortManifest; aggregate -> AggregateManifest) de fato TEM o manifest
		correspondente. E a direcao inversa dos ref-integrity (que vao manifest->entidade).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a true-coverage nao e expressivel com os kinds v1 de structural-
		check. Exige um kind NOVO -- "declared-id-requires-file": um id declarado num artefato (BC em
		context-map, aggregate em domain-model) exige a existencia de um arquivo correspondente (o
		manifest). E, ao contrario dos 5 checks do C5 (dormant-safe), a true-coverage NAO seria
		dormante: aggregates e BCs JA existem no disco, manifests NAO -- o check falharia
		imediatamente em toda entidade existente, contradizendo born-warn/dormancia. Custo evitado:
		introduzir um kind novo no runner + um check que nasce vermelho antes de WI-140 existir.
		Custo de continuar deferindo: "toda entidade tem manifest" fica confiado a review, nao a
		gate -- aceitavel porque nenhum manifest existe ainda (nada a cobrir ate WI-140).
		"""

	triggerCalibrationRationale: """
		manual-review: a revisita depende da CONJUNCAO de duas pre-condicoes que o founder avalia.
		(i) o kind "declared-id-requires-file" ser adicionado ao runner (decisao de schema/engine que
		o founder toma, precedente adr-100/adr-102). (ii) WI-140 materializar instancias de manifest
		-- senao o check falha trivialmente em toda entidade. So com (i) E (ii) a true-coverage vira
		gate nao-trivial. Nenhuma das duas e um file-exists isolado avaliavel pelo runner hoje, por
		isso manual-review.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-144-manifest-artifact-governance.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			low porque nenhum manifest existe ainda -- nao ha cobertura a impor ate WI-140 materializar
			instancias; ate la a true-coverage seria vacua. cross-cutting porque cobre toda entidade
			(BCs e aggregates) que deveria ter manifest, em todos os BCs. Exit: kind novo + check
			apos WI-140.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Revisitar quando (i) o kind declared-id-requires-file for adicionado ao runner E (ii) WI-140 materializar instancias de manifest -- so entao a true-coverage entidade->manifest vira gate nao-trivial (antes falha trivialmente em toda entidade ja existente)."
	}]
}
