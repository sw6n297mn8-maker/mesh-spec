package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def091: artifact_schemas.#DeferredDecision & {
	id:     "def-091"
	title:  "Recebimento por item — onde o dinheiro se move, a granularidade não pode ser grossa"
	date:   "2026-09-06"
	status: "open"

	description: """
		O recebimento por ITEM não existe no modelo. Fica deferida a
		modelagem de: etapas do recebimento (entrada/recebimento provisório
		· conferência quantitativa · conferência qualitativa ·
		regularização), saldo no ITEM do pedido, relação n-para-n entre
		recebimento e item (várias entregas atendem o mesmo item; uma
		entrega atende vários itens), rota de divergência com dono, limite
		duro de recusa, repercussão fiscal do recebido efetivo, e
		conferência cega (o conferente registra a quantidade sem acesso à
		nota que originou o recebimento — controle antiancoragem nativo do
		setor). O caso que define a lacuna (founder, 2026-09-06): a compra
		é manta com a Vedacit e primer com a Impersul. Chega o caminhão da
		Vedacit com 300 m² de manta em vez de 400. Quem confere no canteiro
		só pode registrar 'a entrega chegou' ou 'a entrega não chegou' — e
		nenhuma das duas é verdade, com consequência de dinheiro em cada
		uma: aceitar faz nascer o recebível inteiro e paga 400 por 300; não
		aceitar deixa sem pagamento 300 m² que estão na obra e serão usados
		amanhã. O sistema não registra errado: NÃO TEM ONDE ESCREVER. A
		lacuna não foi criada pelo item de cotação — ela já existia (a
		requisição sempre descreveu vários materiais e a entrega sempre foi
		de escopo); o item apenas a torna visível. Depende de def-087: o
		saldo por item herda a forma do item.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: o saldo por item herda a forma do item —
		sem a primitiva (def-087, frente ativa), o recebimento por item não
		tem sobre o que assentar; e a fatia pós-PO (recebimento → recebível
		→ pagamento) é arco próprio que a frente atual deliberadamente não
		abre. Custo evitado: modelar o elo mais delicado da cadeia (o que
		prova o fato operacional que move dinheiro) sobre base ainda em
		descoberta. Custo de continuar deferindo: está descrito no caso do
		caminhão — pagamento contra fato não provado ou material em uso sem
		pagamento, sem terceiro registro possível.
		Fontes da prática (PESQUISA EXTERNA NÃO VERIFICADA CONTRA NORMA
		PRIMÁRIA — secundárias, citadas como origem de conhecimento, não
		como lei): etapas nomeadas do recebimento em material de
		treinamento de almoxarifado público; conferência POR ITEM como
		norma em instrução normativa de almoxarifado municipal (avaliar o
		quantitativo de cada item comprado, não apenas o total; informar o
		comprador ao encontrar divergência; recusar quando o valor da nota
		excede o da ordem de compra); entrega parcial e saldo no item em
		documentação de ERP (estados 'saldo total para receber' e 'saldo
		parcial para receber' no item do pedido; várias notas atendendo o
		mesmo pedido e o mesmo item); repercussão fiscal: divergência de
		quantidade não se corrige por carta de correção (Ajuste SINIEF
		01/2007 exclui quantidade, valor e base de cálculo) e resposta a
		consulta da SEFAZ-SP orienta lançar a nota pelo valor efetivamente
		recebido; conferência cega em documentação de ERP (conferente
		registra a quantidade de cada item sem acesso à nota fiscal; o
		cruzamento contra pedido e nota vem depois).
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito): o gatilho real é def-087
		entregar a forma do item e o founder abrir o arco pós-PO —
		sequenciamento, não fato de disco; predicados de conteúdo/existência
		teriam os mesmos falso-positivos dos irmãos def-087/088.
		"""

	originatingArtifacts: [
		"contexts/p2p/domain-model.cue",
		"session:passe-de-morada",
	]

	costOfDeferral: {
		severity:    "high"
		blastRadius: "cross-cutting"
		description: """
			high — calibração do founder: é o único def deste passe em que
			o custo do adiamento é PAGAMENTO INDEVIDO, não retrabalho. Na
			Mesh o dinheiro se move quando o fato operacional está provado,
			e a prova é o aceite; há informação fina em todos os elos
			anteriores (requisição, cotação, decisão por item, pedido) e
			granularidade grossa exatamente onde o dinheiro se move — a
			cadeia de evidência muda de granularidade no último passo.
			cross-cutting porque toca p2p (pedido/saldo), o arco fiscal do
			recebido efetivo e o nascimento do recebível. Exit: fatia
			própria do recebimento por item, após def-087 dar a forma.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é a forma do item (def-087) existir e o founder abrir o arco pós-PO do recebimento — decisão de sequenciamento sobre frente ativa, não fato de disco; predicado de conteúdo sobre recebimento/conferência dispararia em prosa e predicado de existência cravaria path de fatia não-desenhada."
	}]
}
