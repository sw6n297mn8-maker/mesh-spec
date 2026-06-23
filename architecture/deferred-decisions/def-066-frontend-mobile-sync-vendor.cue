package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def066: artifact_schemas.#DeferredDecision & {
	id:     "def-066"
	title:  "Vendor de sync mobile offline do frontend deferido ao frontend-runtime"
	date:   "2026-06-23"
	status: "open"

	description: """
		Fica deferida a seleção do vendor de sync mobile offline do frontend — o motor que
		implementa FF-FE-07 (operações criadas offline — inspeção, aceite de entrega —
		sincronizam sem perda quando a conexão é restaurada). O vendor vive atrás da fronteira
		P2 no frontend-runtime; adr-150 ratifica o comportamento (FF-FE-07), não o vendor.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: nenhuma tela de captura de campo existe ainda, logo não há
		padrão de dado de campo (shape, modelo de conflito, granularidade de merge) contra o
		qual escolher e validar um motor de sync. Cravar o vendor agora pinaria um modelo de
		resolução de conflito sem caso real — retrabalho garantido quando a primeira superfície
		de captura materializar. Custo de continuar deferindo: baixo — FF-FE-07 (o
		comportamento) é lei; só o vendor espera, e nenhuma tela offline é construída antes do
		frontend-runtime.
		"""

	triggerCalibrationRationale: """
		Manual-review-only: o vendor vive no frontend-runtime, invisível ao runner determinístico
		do mesh-spec (mesma lição de def-060/def-043 — âncora em repo externo). O sinal real de
		revisita é a primeira superfície de captura de campo offline ser construída no runtime,
		evento de outro repo que grep no mesh-spec não afere.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-159-decompose-grouped-deferred-decision.cue",
		"architecture/deferred-decisions/def-060-frontend-client-vendor-stack.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque nenhuma tela offline é construída antes do frontend-runtime e FF-FE-07 (não
			o vendor) é o que a primeira captura obedecerá; cross-artifact porque o impacto se
			concentra na camada mobile + seu contrato de dado de sync, não no runtime inteiro.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			A condição real de revisita — a primeira superfície de captura de campo offline ser
			construída no frontend-runtime, materializando o padrão de dado contra o qual o motor de
			sync é escolhido — não é machine-evaluable pelo runner do mesh-spec (repo externo,
			invisível ao grep).
			"""
	}]
}
