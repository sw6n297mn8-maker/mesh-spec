package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def079: artifact_schemas.#DeferredDecision & {
	id:     "def-079"
	title:  "Elo formal requisição↔cotação (p2p↔ssc) e reconciliação do amount aprovado vs valor da cotação vencedora (fonte-de-verdade no ssc)"
	date:   "2026-07-12"
	status: "open"

	description: """
		O portão de aprovação (adr-174/WI-151) carrega amount como CAMPO DE
		ENTRADA em cmd-approve-purchase e evt-purchase-approved: o valor da
		cotação vencedora do sourcing, aprovado pelo gestor e reservado pelo
		Gate de Cobertura. Mas a FONTE-DE-VERDADE do valor é a cotação no ssc
		— e nenhum elo formal conecta a requisição à cotação que a precifica:
		não há quoteRef cross-BC, e nada reconcilia o approve-amount digitado
		com o quote-amount vencedor. Fica deferida a decisão de COMO
		formalizar o elo requisição↔cotação (shape do ref, quem o carrega,
		em que momento nasce) e como reconciliar os dois valores (gate
		determinístico? tolerância? divergência escala?) — o desenho da
		fatia p2p↔ssc.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: o campo amount resolve o portão oco desta
		fatia (o Gate de Cobertura precisa de um valor para reservar
		saldo+alçada), mas o elo formal e a reconciliação exigem abrir a
		superfície do ssc (onde a cotação vive) — trabalho de OUTRA fatia,
		que a fatia da requisição deliberadamente NÃO abre (uma fatia por
		vez, mesmo princípio do WI-153). Custo evitado: desenhar o contrato
		cross-BC p2p↔ssc no meio da fatia da requisição, sem o mapa de
		cotações consultável (WI-152 ainda pendente — a query de comparação
		que o elo naturalmente referenciaria não existe). Custo de continuar
		deferindo: janela em que o amount aprovado é entrada solta —
		divergência approve-amount vs quote-amount é possível e invisível ao
		sistema até a fatia p2p↔ssc fechar o elo.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito, não fail): o gatilho real é a
		fatia p2p↔ssc abrir — decisão de sequenciamento do founder, não fato
		de disco. Não há predicado livre de falso-positivo: trigger de
		conteúdo sobre 'quoteRef' dispararia em prosa/rationales que já
		mencionam o conceito (inclusive este def e o rationale do amount);
		trigger de existência sobre artefato da fatia futura cravaria path
		não-decidido (frágil contra renomeação e contra o G2). O elo natural
		de revisita já existe no disco: o rationale do amount em
		cmd-approve-purchase aponta este def pelo número — quem abrir a
		superfície de aprovação reencontra a dívida no ponto de uso.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-174-approval-as-gate-before-order.cue",
		"contexts/p2p/domain-model.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			medium porque o portão FUNCIONA nesta fatia (amount entra, gate
			reserva, aprovação efetiva) — o que falta é a verificação de
			procedência do valor, cuja ausência só vira dano se approve-amount
			divergir do quote-amount vencedor sem ninguém notar; cross-artifact
			porque o acoplamento é p2p (aprovação carrega o valor) ↔ ssc
			(cotação é fonte-de-verdade do valor). Exit: desenhar o elo
			quoteRef + reconciliação quando a fatia p2p↔ssc abrir — idealmente
			após WI-152 (mapa de cotações consultável) materializar a
			superfície de leitura que o elo referenciaria.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é a fatia p2p↔ssc abrir (decisão de sequenciamento do founder, não fato de disco); sem predicado livre de falso-positivo — trigger de conteúdo sobre quoteRef dispararia em prosa que já menciona o conceito, e trigger de existência cravaria path de fatia não-desenhada. A revisita está ancorada no ponto de uso: o rationale do amount em cmd-approve-purchase cita def-079."
	}]
}
