package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def048: artifact_schemas.#DeferredDecision & {
	id:     "def-048"
	title:  "Notificação downstream de modify_terms para consumidores de termos"
	date:   "2026-06-03"
	status: "open"

	description: """
		Quando modify_terms (resolução de disputa autoritativa) altera os termos de um compromisso já
		accepted, consumidores que fizeram snapshot dos termos (BDG para orçamento, INV para fatura)
		ficam com termos defasados. A forma da notificação é decisão de design pendente: evento publicado
		novo (CommitmentTermsModified) vs reuso de outro mecanismo de re-sync.
		"""

	deferralRationale: """
		A notificação é decisão cross-BC — BDG e INV consomem termos do compromisso e precisariam
		re-sincronizar após modify_terms. Resolver agora ampliaria a Fatia B de intra-CMT para
		cross-cutting (evento publicado novo + adaptação dos consumidores). Custo evitado por deferir:
		amplificação cross-cutting de uma fatia que é intra-CMT. Custo de continuar deferindo: uma janela
		conhecida em que consumidores podem operar sobre termos pré-modificação após um modify_terms —
		incômodo operacional, não catastrófico (modify_terms via disputa é caminho de exceção, não fluxo
		normal; e o termsHash recomputado já garante a consistência interna do CMT).
		"""

	triggerCalibrationRationale: """
		A condição de revisita é uma decisão de design (evento dedicado vs sync manual) somada à
		frequência observada de modify_terms em produção — nenhuma das duas é detectável por análise
		estática da spec, logo manual-review (não há artefato de mesh-spec cuja existência/conteúdo
		sinalize a maturidade dessa decisão).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-143-cmt-dispute-orchestration.cue",
		"session:fix-cmt-dispute-orchestration",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			Até a notificação existir, BDG (orçamento) e INV (fatura) podem operar sobre o snapshot
			pré-modificação após um modify_terms — janela conhecida e rastreada. blastRadius cross-artifact
			porque a resolução tocará BDG/INV (consumidores), embora o gap atual seja contido ao caminho de
			exceção da disputa.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Não há proxy machine-evaluable a partir de mesh-spec: a forma da notificação é decisão de
			design que depende da frequência de modify_terms em produção — caso raro favorece sync manual;
			frequente justifica evento dedicado. Founder decide quando houver clareza.
			"""
	}]
}
