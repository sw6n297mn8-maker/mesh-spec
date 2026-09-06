package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def088: artifact_schemas.#DeferredDecision & {
	id:     "def-088"
	title:  "Elo requisição↔cotação no nível do ITEM — o terceiro nível que a deliberação do def-079/adr-177 não considerou"
	date:   "2026-09-06"
	status: "open"

	description: """
		def-079 está resolved (resolvedBy: adr-177): o elo requisição↔
		cotação foi formalizado na direção (ii) — o p2p carrega o elo — e a
		alternativa (i-b), requisitionRef em cmd-open-rfq, foi REJEITADA por
		contradição de modelo (o ssc é categoria-escopado; ref obrigatório
		quebra preferred-designation/strategic-award, forçando 1:1 num
		modelo N:1; opcional vira campo semi-morto). Este def NÃO reabre a
		alternativa rejeitada. Ele declara que a deliberação original
		considerou dois níveis — a RFQ e a requisição — e existe um TERCEIRO
		que ela não considerou: o do ITEM. No nível do item o elo não
		contradiz o ssc categoria-escopado: a RFQ segue da categoria (N:1
		preservado) e cada item cotado referencia o item de requisição que o
		originou. Fica deferida a decisão de COMO formalizar o elo por item
		(shape do ref, quem o carrega, em que momento nasce).
		Relação entre defs (em prosa — o schema #DeferredDecision não tem
		campo de relação def↔def): este def SUCEDE def-079 no nível que
		def-079 não deliberou; def-079 permanece resolved e intocado.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a forma do elo por item depende da forma do
		ITEM — que é o território do def-087, frente ativa ainda sem forma
		canonizada. Formalizar o elo antes da primitiva existir repetiria o
		erro que a rejeição de (i-b) evitou: cravar shape cross-BC contra um
		modelo que ainda não tem o nível onde o elo mora. Custo evitado:
		desenho cross-BC especulativo sobre primitiva inexistente. Custo de
		continuar deferindo: a janela do def-079 continua parcialmente
		aberta um nível abaixo — a procedência do adr-177 (unitPrice ×
		quantity == amount) resolve no agregado da cotação, e a
		rastreabilidade fina item-a-item entre o que foi pedido e o que foi
		cotado permanece invisível ao sistema. Depende de def-087.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito): mesma calibração ratificada no
		def-079, de que este é sucessor — o gatilho real é a fatia do item
		(def-087) entregar a primitiva; sem predicado livre de
		falso-positivo (conteúdo dispara em prosa, existência crava naming
		não-decidido).
		"""

	originatingArtifacts: [
		"architecture/deferred-decisions/def-079-requisition-quote-link-and-amount-reconciliation.cue",
		"architecture/adrs/adr-177-requisition-quotation-link-and-price-provenance-gate.cue",
		"session:passe-de-morada",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			medium/cross-artifact — a mesma calibração do def-079, cuja
			janela este def herda um nível abaixo: o acoplamento é p2p (item
			de requisição) ↔ ssc (item cotado), e o gate de procedência do
			adr-177 já protege o agregado; o que falta é a rastreabilidade
			por item. Exit: com a primitiva do item canonizada (def-087),
			desenhar o elo por item na fatia p2p↔ssc correspondente.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é def-087 entregar a primitiva do item — sequenciamento do founder sobre frente ativa, não fato de disco. Predicado de conteúdo sobre o conceito dispararia em prosa existente (inclusive def-079 e adr-177); predicado de existência cravaria shape de fatia não-desenhada. Mesmo desenho de revisita do def-079: a âncora está no ponto de uso."
	}]
}
