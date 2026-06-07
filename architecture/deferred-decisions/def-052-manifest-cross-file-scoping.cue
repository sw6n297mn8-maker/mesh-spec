package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def052: artifact_schemas.#DeferredDecision & {
	id:     "def-052"
	title:  "Scoping dos cross-file checks de manifest: plain (global) vs instance-scoped (same-BC)"
	date:   "2026-06-05"
	status: "open"

	description: """
		adr-144 item 5 escolheu PLAIN cross-file-id-exists para os manifest-ref-integrity (sc-mri-01/
		02) -- existencia na uniao GLOBAL dos arquivos-alvo. Fica deferida a decisao de apertar para
		INSTANCE-SCOPED (same-BC, kind instance-scoped-cross-file-id-exists, adr-113), AMPLIADA para
		cobrir tambem a existencia de cmd-*/evt-*/inv- do AggregateManifest no domain-model do BC
		(buildavel, deferida do C4.1). Os dois sao a mesma pergunta de scoping.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: item 5 escolheu plain explicitamente -- precedente provado
		(service-contract sc-sv-01 usa plain para boundedContextRef) e dormant-safe. O aperto para
		instance-scoped (garantir que aggregateRef/boundedContextRef resolvam contra o PROPRIO BC do
		manifest, nao a uniao global -- least-privilege) so se justifica com evidencia de
		falso-positivo real: uma ref cross-BC indevida que passa no plain. O mesmo vale para
		materializar o check de existencia de cmd/evt/inv (mesma decisao plain-vs-instance-scoped).
		Custo evitado: introduzir scoping per-instancia + os checks de existencia antes de haver
		manifests que os exercitem. Custo de continuar deferindo: uma ref cross-BC indevida passaria
		nos ref-integrity plain, e a existencia de cmd/evt/inv fica confiada a review -- aceitavel
		porque nenhum manifest existe ainda (zero superficie de falso-positivo ate WI-140).
		"""

	triggerCalibrationRationale: """
		manual-review: a decisao plain-vs-instance-scoped exige julgamento do founder sobre se o
		escopo global gera falso-positivo REAL em uso -- nao um file-exists isolado. So com
		instancias de manifest suficientes (pos-WI-140) da para avaliar se uma ref cross-BC indevida
		ocorre na pratica; so entao decidir apertar para instance-scoped e materializar os checks de
		existencia cmd/evt/inv. Antes disso nao ha sinal observavel pelo runner.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-144-manifest-artifact-governance.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			low porque nenhum manifest existe ainda -- sem instancias, o escopo global nao tem como
			gerar falso-positivo, e a existencia cmd/evt/inv nao tem o que checar. cross-cutting porque
			o scoping afeta os manifest checks de todos os BCs. Exit: decidir plain-vs-instance-scoped
			+ materializar os checks de existencia apos WI-140.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Revisitar quando houver instancias de manifest suficientes (pos-WI-140) para avaliar se o escopo global gera falso-positivo real (ref cross-BC indevida) -- entao decidir plain vs instance-scoped e materializar os checks de existencia cmd/evt/inv."
	}]
}
