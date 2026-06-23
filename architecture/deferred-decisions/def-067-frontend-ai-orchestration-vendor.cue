package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def067: artifact_schemas.#DeferredDecision & {
	id:     "def-067"
	title:  "Vendor de orquestração de agente IA do frontend deferido ao frontend-runtime"
	date:   "2026-06-23"
	status: "open"

	description: """
		Fica deferida a seleção do vendor de runtime de orquestração de agente IA do frontend —
		não-determinístico, distinto do vendor do WorkflowPort de domínio (def-043). É a camada
		cujo isolamento adr-150 fixa como lei (FF-FE-01/02/08: acesso só por bridge dedicado, zero
		business logic no orquestrador, camada de IA não penetra o domínio); o vendor que a
		implementa vive atrás da fronteira P2 no frontend-runtime.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a 1ª tela (override do FCE, human-facing) NÃO exercita um padrão
		de orquestração de agente — o agente recomenda, o humano confirma em ação estruturada; não
		há superfície de orquestração multi-passo que prove o vendor. Escolher o runtime de
		orquestração agora é especulação sem caso. Custo de continuar deferindo: baixo — o
		isolamento (FF-FE-01/02/08) é lei e independe do vendor; nenhuma tela que orquestre agente
		é construída antes do frontend-runtime.
		"""

	triggerCalibrationRationale: """
		Manual-review-only: o vendor vive no frontend-runtime, invisível ao runner do mesh-spec
		(mesma lição de def-060/def-043). O sinal real de revisita é uma tela que de fato exercite
		orquestração de agente (além do confirm unitário do override) ser construída no runtime —
		evento de outro repo, não aferível por grep no spec.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-159-decompose-grouped-deferred-decision.cue",
		"architecture/deferred-decisions/def-060-frontend-client-vendor-stack.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque a 1ª tela não orquestra agente e o isolamento (FF-FE-01/02/08), não o vendor,
			é o que ela obedece; cross-artifact porque o impacto se concentra na camada de IA do
			frontend e seu bridge com o domínio, não no runtime inteiro.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			A condição real de revisita — uma tela que exercite orquestração de agente (além do
			confirm unitário) ser construída no frontend-runtime — não é machine-evaluable pelo
			runner do mesh-spec (repo externo, invisível ao grep).
			"""
	}]
}
