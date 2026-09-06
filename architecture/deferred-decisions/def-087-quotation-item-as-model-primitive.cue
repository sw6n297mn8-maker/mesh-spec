package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def087: artifact_schemas.#DeferredDecision & {
	id:     "def-087"
	title:  "Item de cotação como primitiva do modelo (matriz item × fornecedor)"
	date:   "2026-09-06"
	status: "open"

	description: """
		O modelo de sourcing não tem o ITEM como primitiva: vo-rfq-scope é
		escopo único (categoryRef + description + estimatedVolume singular) e
		a cotação carrega unitPrice no nível da proposta inteira — a
		comparação item a item que a prática de compras usa não existe no
		modelo. Veredito do founder (2026-09-06): MODELO INCOMPLETO, a tela
		está certa. Fundamentação: o mapa de cotação é canonicamente uma
		matriz item × fornecedor; a economia é medida por item e por compra;
		e a consolidação de frete tem razão econômica que só o nível do item
		expressa (adjudicar itens a fornecedores distintos vs consolidar a
		entrega). Fica deferida a decisão de COMO o item entra no modelo
		(forma, morada p2p/ssc, relação com RFQScope e com a cotação).
		"""

	deferralRationale: """
		Estatuto: FRENTE ATIVA — este def nasce já sendo trabalhado. A
		frente §0 + L1 (laboratório/frontend) está resolvendo exatamente
		este território, e a forma do item está sendo descoberta em execução
		antes de virar lei. Deferir a canonização AGORA é deliberado: fixar
		o shape do item no spec antes da evidência da frente é pré-estruturar
		— o mesmo antipadrão que o laboratório existe para evitar. Custo
		evitado: modelagem cross-BC (p2p↔ssc) especulativa, provável
		retrabalho quando a frente devolver a forma real. Custo de continuar
		deferindo: o modelo diz singular onde a prática é plural — toda
		superfície que compara cotações contorna o modelo em vez de
		consumi-lo. Registrado como o território que a frente está
		resolvendo, não como pendência parada.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito): o gatilho real é a frente
		§0 + L1 devolver a forma do item — decisão de sequenciamento do
		founder sobre trabalho vivo fora deste repo, não fato de disco.
		Trigger de conteúdo sobre 'item' seria chuva de falso-positivo;
		trigger de existência cravaria naming não-decidido (mesma
		calibração ratificada em def-079).
		"""

	originatingArtifacts: [
		"contexts/ssc/domain-model.cue",
		"session:passe-de-morada",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			medium porque a frente ativa já trabalha o território — o
			deferimento é da CANONIZAÇÃO, não da descoberta; cross-cutting
			porque o item atravessa ssc (escopo e cotação), p2p (requisição
			e pedido) e as superfícies de comparação. Exit: a frente devolve
			a forma do item e a fatia de modelagem sobe ao spec via ADR.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é a frente §0 + L1 devolver a forma do item — trabalho vivo fora deste repo, decisão de sequenciamento do founder, não fato de disco avaliável pelo runner. Predicado de conteúdo sobre 'item' dispara em prosa que já usa o conceito; predicado de existência cravaria path/naming de fatia não-desenhada."
	}]
}
