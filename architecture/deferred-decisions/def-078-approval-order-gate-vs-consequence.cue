package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def078: artifact_schemas.#DeferredDecision & {
	id:     "def-078"
	title:  "Ordem da aprovação de compra: aprovação-como-gate (gestor aprova antes do pedido) vs aprovação-como-consequência (bdg dispara após o commitment)"
	date:   "2026-07-12"
	status: "resolved" // decisão do founder 2026-07-12: PORTÃO (opção A) — resolvida na conversa de modelo que abriu o WI-151, exatamente como o trigger manual-review previa
	resolvedBy: "architecture/adrs/adr-174-approval-as-gate-before-order.cue"

	description: """
		A jornada real de compras vive a aprovação como GATE: o gestor aprova
		por alçada ANTES de a requisição virar pedido — nada compromete
		orçamento sem o de-acordo prévio. O modelo atual assume o oposto:
		aprovação como CONSEQUÊNCIA — o bdg dispara o controle orçamentário
		DEPOIS que o commitment (pedido) já existe. As duas ordens produzem
		invariantes diferentes: no gate, a alçada é pré-condição da emissão do
		pedido; na consequência, a alçada é reação ao pedido já emitido. Fica
		deferida a decisão de qual ordem o modelo adota — e como bdg e p2p se
		acoplam em cada caso (quem valida a alçada, em que momento, contra qual
		saldo).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: é DECISÃO DE MODELO do founder, não lacuna de
		execução — a ordem certa depende de como a operação real de compras
		trata o de-acordo do gestor, e a fatia da requisição (que desenha a
		triagem/alçada) ainda não foi executada. Decidir a ordem sem a fatia na
		mesa especularia sobre o ponto de acoplamento antes de vê-lo. Custo
		evitado: reescrever o acoplamento bdg↔p2p (invariantes de alçada +
		momento da validação) sem o desenho da triagem à frente. Custo de
		continuar deferindo: a fatia da requisição não pode fechar o passo de
		triagem/alçada sem esta decisão — por isso ela está acoplada como
		pré-requisito da requisição, não como item paralelo.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito, não fail): o gatilho real é o
		founder resolver gate vs consequência na conversa de modelo que abre a
		fatia da requisição (WI-151). Não há predicado de disco livre de
		falso-positivo para 'a ordem foi decidida' — o domain-model do p2p já
		referencia authority/alçada, então um trigger de conteúdo dispararia
		espúrio de imediato, e um trigger de existência de arquivo cravaria o
		número de um WI irmão criado no mesmo lote (frágil contra o G2). O
		acoplamento com a fatia está expresso no semanticPrerequisites do
		WI-151 (direção robusta, protegida pelo G2 stop-on-divergence).
		"""

	originatingArtifacts: [
		"strategic/domain-stories/buyer-procurement-journey.cue",
		"contexts/p2p/domain-model.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			medium porque a ordem da aprovação define invariantes de alçada que
			a fatia da requisição precisa para fechar o passo de triagem — não
			bloqueia o resto do modelo, mas bloqueia o passo 3 da jornada de
			compras; cross-context porque o acoplamento é bdg (controle
			orçamentário/alçada) ↔ p2p (emissão do pedido). Exit: decidir gate
			vs consequência quando a fatia da requisição abrir a conversa de
			modelo da triagem/alçada.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é decisão de modelo do founder — aprovação-como-gate vs aprovação-como-consequência — resolvida na conversa que abre a fatia da requisição (WI-151); o passo de triagem/alçada não fecha sem ela. Sem predicado de disco livre de falso-positivo: o domain-model do p2p já referencia authority/alçada."
	}]
}
