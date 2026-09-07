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

		SEGUNDA FRENTE (2026-09-07) — A FORMA DO ACEITE, divergência em
		ABERTO. Além da granularidade, este def passa a cobrir a QUESTÃO
		DA CERIMÔNIA: há um momento de aceite ENTRE AS PARTES na entrega,
		ou a entrega se prova por evidência verificada de um lado só? Duas
		leituras estão sobre a mesa e NENHUMA está decidida:
		(a) A ENTREGA MERECE ACEITE BILATERAL PRÓPRIO, e o modelo está
		atrás da tese. O aceite bilateral É da tese — mas hoje mora no cmt
		('compromisso é acordo bilateral com aceite mútuo', subdomains/
		p2p.cue; 'confirmação bilateral' + 'invariantes de aceite mútuo' +
		'aceite bilateral registrado como fato com integridade
		criptográfica via CAS/DSSE, o primeiro elo da cadeia de
		evidência', subdomains/cmt.cue), e incide sobre o COMPROMISSO. Se
		o fato que move dinheiro é a entrega, e se a prova desse fato
		exige as duas partes concordando e não apenas o comprador
		conferindo, então falta ao dlv um ato que a tese já sustenta em
		outro nível — e a fronteira cmt/dlv se desloca.
		(b) O ACEITE JÁ ESTÁ NO LUGAR CERTO e o que falta é vocabulário. O
		cmt declara explicitamente que 'não verifica execução operacional
		(DLV)'; o dlv verifica execução por evidência (cmd-record-evidence
		→ cmd-evaluate-verification → evt-delivery-verified |
		evt-delivery-rejected), sem cerimônia entre partes. Nesta leitura
		a entrega é VERIFICADA, não aceita, e um 'aceite de entrega' seria
		o vocabulário do cmt aplicado ao BC errado.
		ORIGEM DA DIVERGÊNCIA: a EntregaScreen do design system afirma um
		evt-delivery-accepted que NÃO existe em contexts/ (verificado:
		zero ocorrências), com gate de aceite físico e 'aceite bilateral
		registrado'; o dlv não tem a palavra 'bilateral' uma única vez.
		NENHUM DOS DOIS FOI TESTADO CONTRA A REALIDADE — a ausência no
		modelo não é prova de que a tela errou, e a presença na tela não é
		prova de que o modelo está atrás. É divergência entre dois
		artefatos, cada um fiel a uma leitura, sem árbitro empírico. Molde
		reconhecido: o rationale do passo 7 da ds-buyer-procurement-journey
		registra a mesma forma ('divergência entre dois artefatos de
		protótipo, cada um fiel a um lado') — lá a story era fonte dos dois
		e não decidia; aqui a story do fornecedor herdaria a indecisão, e
		por isso a declara como limite em vez de escolher.
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
		"contexts/dlv/domain-model.cue",
		"session:passe-de-morada",
		"session:divergencia-aceite-entrega",
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
			recebido efetivo e o nascimento do recebível — e, com a segunda
			frente (2026-09-07), também dlv (a forma do aceite) e a
			fronteira cmt/dlv que a leitura (a) deslocaria. A severidade
			NÃO muda com a frente nova: continua high pelo mesmo motivo
			(pagamento indevido), e a indecisão sobre a cerimônia não
			acrescenta custo cumulativo próprio — ela custa quando a fatia
			abrir e precisar escolher. Exit: fatia própria do recebimento
			por item, após def-087 dar a forma, decidindo as duas frentes
			juntas (granularidade e cerimônia) — separá-las modelaria o
			saldo por item sob uma forma de aceite ainda não escolhida.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é a forma do item (def-087) existir e o founder abrir o arco pós-PO do recebimento — decisão de sequenciamento sobre frente ativa, não fato de disco; predicado de conteúdo sobre recebimento/conferência dispararia em prosa e predicado de existência cravaria path de fatia não-desenhada."
	}]
}
