package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def089: artifact_schemas.#DeferredDecision & {
	id:     "def-089"
	title:  "Agregação de requisições numa cotação — e a tensão nomeada com o Fracionamento"
	date:   "2026-09-06"
	status: "open"

	description: """
		Agrupar N requisições numa única cotação não tem lar no modelo — o
		limite declarado na triagem é literalmente verdadeiro: nada no p2p
		ou no ssc modela N requisições → 1 RFQ (a RFQ nasce da categoria; a
		relação com as requisições que a motivaram não é representada).
		Fica deferida a decisão de COMO modelar a agregação (a relação
		N-requisições↔RFQ, quem agrega, em que momento, com que efeito
		sobre saldo e aprovação). O único parente no repo é o INVERSO:
		Fracionamento, nos vetores adversariais do cmt (manipulação por
		divisão de compromissos sub-threshold; oq-cmt-5 encomenda a
		detecção) e do bdg (act-detect-fragmentation-pattern). TENSÃO
		NOMEADA: agregar é desejável economicamente (consolidação de volume
		e frete) e fracionar é vetor de ataque (evasão de alçada) — são o
		mesmo eixo percorrido em direções opostas. Qualquer modelagem
		futura de agregação nasce tendo de responder à detecção de
		fracionamento: agregação legítima não pode virar ruído no detector,
		e o detector não pode virar obstáculo à economia.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a agregação opera sobre itens de múltiplas
		requisições — sem a primitiva do item (def-087, frente ativa) e sem
		o elo por item (def-088), a agregação não tem sobre O QUE ser
		modelada; e a tensão com o Fracionamento exige desenho adversarial
		deliberado (cmt/bdg), não um campo acrescentado de passagem. Custo
		evitado: modelagem cross-BC (p2p↔ssc↔cmt/bdg) especulativa antes da
		base existir. Custo de continuar deferindo: compras que a prática
		consolidaria seguem como RFQs separadas — economia de volume e
		frete invisível ao sistema — e o limite da triagem permanece um
		contorno declarado em vez de capacidade.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito): o gatilho real é a fatia de
		agregação abrir após def-087/def-088 entregarem a base — decisão de
		sequenciamento do founder. Predicado de conteúdo sobre
		'agregação/fracionamento' dispara nos vetores adversariais
		existentes de cmt/bdg; predicado de existência cravaria shape
		não-desenhado.
		"""

	originatingArtifacts: [
		"contexts/cmt/canvas.cue",
		"contexts/bdg/agents/bdg-primary-agent.cue",
		"session:passe-de-morada",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			medium porque o caminho um-a-um funciona (cada requisição pode
			ir a mercado sozinha — perde-se economia, não capacidade);
			cross-cutting porque a agregação toca p2p (requisições), ssc
			(RFQ/cotação) e o eixo adversarial cmt/bdg (threshold e
			detecção de fracionamento). Exit: fatia própria de agregação,
			desenhada em resposta explícita à detecção de fracionamento,
			depois que def-087/def-088 derem a base por item.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é a fatia de agregação abrir — sequenciamento do founder, dependente de def-087/def-088 e do desenho adversarial junto a cmt/bdg. Sem predicado livre de falso-positivo: conteúdo sobre agregação/fracionamento dispara nos vetores adversariais já escritos; existência cravaria path de fatia não-desenhada."
	}]
}
