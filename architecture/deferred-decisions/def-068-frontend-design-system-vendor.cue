package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def068: artifact_schemas.#DeferredDecision & {
	id:     "def-068"
	title:  "Vendor de design system visual do frontend deferido ao frontend-runtime"
	date:   "2026-06-23"
	status: "open"

	description: """
		Fica deferida a seleção do vendor de design system visual do frontend — tokens, tipografia,
		marca — mais as specs de tela. A capacidade (confirmar override em ação estruturada, P10 na
		superfície) é lei de spec (adr-150 Approval-as-Confirmation); o design system que a veste
		vive atrás da fronteira P2 no frontend-runtime.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a tela de override precisa de COMPONENTES (botão, form) para
		renderizar, mas NÃO da MARCA — identidade visual, tokens e tipografia são porta-de-mão-dupla
		que a fatia da tela escolhe JIT. Cravar o design system agora, antes de existir tela e antes
		de a marca estar definida, é retrabalho. Custo de continuar deferindo: baixo — a capacidade
		(UI de confirmação estruturada) é lei; só o vestido espera.
		"""

	triggerCalibrationRationale: """
		Manual-review-only: a escolha do design system é JIT no frontend-runtime quando a tela é
		construída, decisão de runtime de cliente atrás da fronteira; não há sinal mesh-spec-local
		(repo externo, invisível ao grep — mesma lição de def-060).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-159-decompose-grouped-deferred-decision.cue",
		"architecture/deferred-decisions/def-060-frontend-client-vendor-stack.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque a capacidade de confirmação estruturada (não o design system) é o que a tela
			obedece, e nenhuma tela é construída antes do frontend-runtime; cross-artifact porque o
			impacto se concentra na camada de apresentação do frontend (todas as telas a vestir), não
			no runtime inteiro.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			A condição real de revisita — a fatia da tela escolher o design system JIT quando a
			primeira tela é construída no frontend-runtime — não é machine-evaluable pelo runner do
			mesh-spec (repo externo, invisível ao grep).
			"""
	}]
}
