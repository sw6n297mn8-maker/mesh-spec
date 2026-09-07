package domain_stories

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

supplierNetworkJourney: artifact_schemas.#DomainStory & {
	code: "ds-supplier-network-journey"
	name: "Jornada do fornecedor na rede — da entrada à evidência da entrega"

	subdomainRef: "ssc"

	purpose: """
		Cenário concreto: uma distribuidora de materiais quer vender à
		construtora que já opera na Mesh. A jornada vai da entrada na rede
		até a evidência da entrega registrada — o outro lado do arco que a
		ds-buyer-procurement-journey narra do lado comprador. Existe como
		story PRÓPRIA, não como extensão daquela, por decisão do founder
		(2026-09-07): o ator, o ciclo e os comandos são outros; as duas se
		cruzam nas ARESTAS BILATERAIS, que é o que a realidade é. E existe
		porque a jornada só acontece havendo duas partes — cada transição
		que a compradora não completa sozinha é uma aresta, e testar um
		lado só é testar a metade que nunca falha por si.
		Origem: o stakeholder-map dá a sh-02 quatro verbos — 'participa de
		RFQs, cota, negocia (revisa a própria cotação — WI-161) e recebe
		pedidos' — e a story do comprador cobria UM deles, com o próprio
		rationale do passo 6 admitindo por escrito: 'único passo do recorte
		com o fornecedor como ator agindo'.
		Fora do recorte: o pagamento e o recebível (arco pós-entrega), e a
		agregação de requisições numa cotação (def-089).
		"""

	steps: [{
		actorRef: "sh-02"
		action:   "O fornecedor cadastra-se na rede por conta própria, declarando o identificador legal qualificado e os dados cadastrais mínimos."
		workItem: {
			description:       "Registrar o participante e criar a entidade no estado pending — o ponto de entrada canônico do lifecycle. A completude cadastral é verificada de forma determinística na porta: registro incompleto é rejeitado antes de criar entidade."
			boundedContextRef: "npm"
			commandRefs: ["cmd-register-participant"]
			eventRefs: ["evt-participant-registered"]
			termRefs: ["term-status-de-participante"]
		}
		rationale: "A jornada do fornecedor NASCE aqui, e o passo carrega uma divergência declarada: este é o caminho de entrada que o SISTEMA executa — auto-registro —, enquanto o passo 4 da ds-buyer-procurement-journey narra a compradora acionando a qualificação de terceiro, caminho que o modelo NÃO sustenta (nenhum comando registra participante em nome de outro). Não é erro de nenhuma das duas: são caminhos de entrada distintos, e o def-095 nomeia os cinco identificados sem escolher entre eles. Esta story narra o único SUSTENTADO hoje e não espera a decisão — se outro caminho for escolhido, é o ator DESTE passo que muda, não a story inteira. A fricção da porta é real e foi observada na travessia pela borda do dev serve: cadastro sem dados mínimos recusa com inv-registration-completeness nomeada."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor submete a documentação de habilitação — o que a compradora exigirá antes de considerá-lo para qualquer cotação."
		workItem: {
			description:       "Registrar o recebimento da documentação KYC/AML, que sinaliza prontidão para verificação. O shape da documentação é ABERTO no modelo (o agregado não a armazena); a validação de formato e completude é do handler."
			boundedContextRef: "npm"
			commandRefs: ["cmd-submit-qualification-documents"]
			eventRefs: ["evt-qualification-documents-received"]
			termRefs: ["term-qualificacao"]
		}
		rationale: "O ato é do PRÓPRIO fornecedor — o binding org == participantId o impede de submeter documento alheio, e essa é a razão de o passo ser dele e não do comprador. Segunda fricção observada na travessia pela borda: aprovar antes deste passo é recusado com a mensagem 'documentação KYC/AML não recebida — QualificationDocumentsReceived sinaliza prontidão para verificação'. A ordem não é convenção: é gate."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor aguarda — a verificação de identidade e a aprovação da qualificação são atos de terceiros, e ele não os controla."
		workItem: {
			description:       "Transicionar o participante de pending para qualified sob o gate de compliance. Os dois atos que fecham a porta — o registro do sinal de verificação de identidade e a aprovação supervisionada — pertencem a outros atores; do lado do fornecedor este passo é ESPERA, e o que ele pode ler é o próprio status."
			boundedContextRef: "npm"
			eventRefs: ["evt-participant-qualified"]
			readModelRefs: ["prj-participant-status-view"]
			queryRefs: ["qry-participant-status"]
			termRefs: ["term-qualificacao", "term-status-de-participante"]
		}
		rationale: "LACUNA HONESTA declarada, não cobertura pendente: commandRefs fica VAZIO porque nenhum comando deste passo é do fornecedor. cmd-record-identity-verification e cmd-approve-qualification existem no npm e são atos de ops/comprador — referenciá-los aqui repetiria exatamente o defeito que a correção do passo 9 da story do comprador desfez (comandos sob o ator que o modelo impede de invocá-los). O evento e a leitura ficam: o fato de ter sido qualificado é dele, e o status é o que ele consulta. O passo existe porque a ESPERA é parte da jornada — omiti-la faria a entrada parecer contínua quando ela tem um portão com dono alheio."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor toma conhecimento da cotação aberta para a qual foi convidado — o escopo, os itens, o prazo da janela."
		workItem: {
			description:       "Tornar observável ao fornecedor convidado a abertura da RFQ. O evento de abertura é published — é o mínimo de lifecycle público que sustenta a notificação operacional a convidados."
			boundedContextRef: "ssc"
			eventRefs: ["evt-rfq-opened"]
			termRefs: ["term-rfq", "term-fornecedor-qualificado"]
		}
		rationale: "ARESTA BILATERAL A1: o passo 5 da ds-buyer-procurement-journey abre a RFQ; este a recebe; evt-rfq-opened atravessa. A assimetria do que cada lado vê é deliberada e é confidencialidade competitiva: o comprador vê o pool convidado inteiro, o fornecedor vê o escopo e o prazo, NUNCA quem mais foi convidado. commandRefs vazio por lacuna honesta com natureza precisa: não falta comando ao modelo — a descoberta do convite não é ato do fornecedor, é fato que chega até ele. O VEÍCULO da notificação não está modelado (o ntf não é BC; o mesh-spec declara só o papel), e o dev serve do mesh-runtime materializou um stand-in de PULL autenticado como decisão runtime-local. Só entram nesta janela fornecedores com status eligible-for-sourcing: a inv-qualification-as-absolute-precondition faz da qualificação pré-condição absoluta, e é por isso que os passos 1-3 vêm antes."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor monta e submete a proposta: o preço de cada item que decide cotar, a moeda e as condições que quer declarar — podendo cotar só parte do escopo."
		workItem: {
			description:       "Registrar a cotação do fornecedor na RFQ aberta, com o preço POR LINHA. A cotação nasce com status submitted e alimenta o mapa de cotações; a cobertura parcial do escopo é legítima por construção."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-submit-quotation"]
			eventRefs: ["evt-quotation-submitted"]
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-rfq", "term-mapa-de-cotacoes"]
		}
		rationale: "O único ato do fornecedor que a story do comprador já narrava (passo 6 de lá) — aqui ele é o centro, não a exceção. Per adr-198 a proposta é POR LINHA: o fornecedor cota os itens que quer, e o subconjunto é proposta PARCIAL legítima; o item que ele não cota não vira zero, vira ausência de célula. ARESTA BILATERAL A2, e a mais assimétrica das sete: evt-quotation-submitted é INTERNAL por confidencialidade competitiva — o comprador vê a célula no mapa, o fornecedor vê apenas a própria. O mapa aparece nos refs de leitura pelo que ele mostra A ELE (a própria cotação e, adiante, a rodada aberta); a matriz completa nunca é superfície de fornecedor."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor recebe a contraproposta do comprador — o alvo pedido, íntegro: preço, condições de pagamento, programação de entregas."
		workItem: {
			description:       "Tornar visível ao fornecedor a rodada de negociação aberta e endereçada a ele. A contraproposta é PEDIDO, não condição vigente: ela não muta a cotação, apenas abre a rodada aguardando resposta."
			boundedContextRef: "ssc"
			eventRefs: ["evt-counter-terms-proposed"]
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-contraproposta", "term-rodada-de-negociacao"]
		}
		rationale: "ARESTA BILATERAL A3: o passo 9 da story do comprador pede; este recebe. commandRefs vazio pela mesma natureza do passo 4 — receber não é ato. O que importa registrar é a ASSIMETRIA que a inv-negotiated-terms-materialize-on-quotation protege: o comprador PEDE, o fornecedor DECLARA. A cotação é do fornecedor e nenhum caminho de escrita do comprador a alcança — o que chega aqui é um pedido, não uma alteração já feita."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor responde revisando a própria cotação — restabelece o preço de cada linha da cobertura vigente e, se quiser, as condições estruturadas."
		workItem: {
			description:       "Materializar as condições negociadas na cotação, preservando a identidade dela. O preço por linha é restatement completo da cobertura vigente; as condições estruturadas ausentes mantêm as vigentes. O contador de revisões incrementa e a rodada fecha."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-revise-quotation"]
			eventRefs: ["evt-quotation-revised"]
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-rodada-de-negociacao", "term-condicoes-de-pagamento", "term-entregas-programadas"]
		}
		rationale: "ARESTA BILATERAL A4, primeiro desfecho. Este comando ESTAVA nos refs do passo 9 da story do comprador, sob actorRef sh-08, e veio para cá no mesmo commit que o retirou de lá — o domain-model declara 'Fornecedor revisa a própria cotação… supplierRef deve match o da cotação'. A revisão não é withdraw+resubmit: preserva o quotationId, e essa continuidade é o que sustenta o rationale da decisão e o gate de procedência do p2p. É também a regra de ouro da negociação: só a revisão do fornecedor materializa condições na cotação, e é por isso que o preço final que o portão do p2p verifica está na casa canônica por construção."
	}, {
		actorRef: "sh-02"
		action:   "Ou o fornecedor declina a contraproposta e mantém as condições que já ofereceu — resposta seca é resposta legítima."
		workItem: {
			description:       "Fechar a rodada sem revisão, mantendo as condições vigentes. O ato existe para que a manutenção deliberada seja distinguível do silêncio."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-decline-counter-terms"]
			eventRefs: ["evt-counter-terms-declined"]
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-rodada-de-negociacao", "term-contraproposta"]
		}
		rationale: "ARESTA BILATERAL A4, segundo desfecho — par simétrico do passo 7, e o segundo comando que migrou do passo 9 da story do comprador no mesmo commit. A razão de existir está no domain-model e é sobre o OUTRO lado: 'sem o ato de recusa, o silêncio e a manutenção deliberada seriam indistinguíveis — o comprador não saberia se espera ou decide'. Um ato do fornecedor que existe para dar informação ao comprador é a definição de aresta bilateral. declineNote pode ser vazia: a obrigação de justificar é do cancelamento de RFQ, não daqui."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor recebe o pedido de compra — e é por ele que descobre que venceu."
		workItem: {
			description:       "Publicar o pedido de compra emitido ao fornecedor, com o escopo, o valor e a authority que o sustenta."
			boundedContextRef: "p2p"
			eventRefs: ["evt-purchase-order-emitted"]
			readModelRefs: ["prj-purchase-orders"]
			termRefs: ["term-purchase-order"]
		}
		rationale: "ARESTA BILATERAL A6, e a que carrega a consequência de A5. A adjudicação (passo 10 da story do comprador) é a ARESTA CEGA: evt-sourcing-decision-made é internal, e o fornecedor não vê a decisão, o ranking, os concorrentes nem o rationale — a confidencialidade competitiva veta o evento público. Por isso não há passo de 'o fornecedor soube que venceu': o PEDIDO é o canal, e a chegada dele É a notícia. A ausência de um passo entre A5 e A6 não é lacuna de cobertura — é a forma que a confidencialidade impõe à narrativa, e vale registrá-la para que ninguém a preencha por engano."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor entrega o material no canteiro e registra a evidência do que foi entregue — a prova do fato operacional que sustenta o recebível."
		workItem: {
			description:       "Receber a evidência de entrega submetida pelo fornecedor e criar a Verification, que o dlv avalia contra os critérios vigentes."
			boundedContextRef: "dlv"
			commandRefs: ["cmd-record-evidence"]
			eventRefs: ["evt-evidence-recorded"]
		}
		rationale: """
			O fornecedor TEM ato próprio na entrega, contra a expectativa: o
			cmd-record-evidence declara 'alternative: direct submission por
			sh-02/sh-01 (Phase 0 manual; Phase 1+ supplier API)' — a submissão
			direta é caminho declarado, não improviso. O trigger primário é o
			consumo do EvidenceCommitted via ACL; este passo narra a rota
			manual da Phase 0, que é a que existe hoje.

			LIMITE DECLARADO — a story PARA aqui, e por duas razões distintas.

			(1) GRANULARIDADE: a evidência é da entrega inteira. Com o pedido
			itemizado (adr-198), o fornecedor entrega dois itens e registra uma
			evidência só; não há saldo por item onde escrever a divergência. É
			o caso do caminhão do def-091.

			(2) FORMA DO ACEITE — divergência em ABERTO, nenhuma leitura
			decidida. O dlv verifica por evidência de um lado
			(cmd-record-evidence → cmd-evaluate-verification → verified |
			rejected) e não tem a palavra 'bilateral'. A EntregaScreen do
			design system afirma um evt-delivery-accepted que não existe em
			contexts/, com aceite bilateral registrado. Leitura (a): a entrega
			merece aceite bilateral próprio e o modelo está atrás da tese — o
			aceite bilateral É da tese, mas hoje incide sobre o COMPROMISSO
			(cmt), não sobre a execução. Leitura (b): o aceite já está no lugar
			certo e a tela deslocou vocabulário do cmt para o BC errado, porque
			o cmt declara 'não verifica execução operacional (DLV)'. NENHUM DOS
			DOIS ARTEFATOS FOI TESTADO CONTRA A REALIDADE: a ausência no modelo
			não prova erro da tela, nem a presença na tela prova atraso do
			modelo. Ambas as frentes vivem no def-091, que decide as duas
			juntas.

			A story NÃO NARRA o aceite nem a verificação como passo do
			fornecedor porque a forma está em disputa — narrar qualquer uma
			seria escolher. Herdaria a indecisão em vez de declará-la; é a
			mesma falha que o rationale do passo 7 da
			ds-buyer-procurement-journey registra ('a story era a fonte de
			ambos e não decidia entre eles'), e aqui ela é evitada de
			propósito.
			"""
	}]

	rationale: """
		Segunda domain story do repo, e a primeira do lado-vendedor. Existe
		por decisão do founder (2026-09-07) como story PRÓPRIA e não como
		extensão da ds-buyer-procurement-journey: o ator, o ciclo e os
		comandos são outros. A razão de fundo é o que a jornada testa — ela
		só existe porque há duas partes, e cada transição que a compradora
		não completa sozinha é uma ARESTA BILATERAL. Testar um lado só é
		testar a metade que nunca falha por si.

		AS SETE ARESTAS, nomeadas para que o protótipo tenha o que testar:
		A1 convite (passo 5 do comprador ↔ passo 4 daqui, evt-rfq-opened —
		o fornecedor nunca vê quem mais foi convidado); A2 proposta (— ↔
		passo 5, evt-quotation-submitted INTERNAL — cada um vê só a própria);
		A3 contraproposta (passo 9 ↔ passo 6, evt-counter-terms-proposed);
		A4 resposta (passo 9 ↔ passos 7 e 8, evt-quotation-revised |
		evt-counter-terms-declined — o comprador distingue 'manteve' de
		'aguardando'); A5 adjudicação (passo 10 ↔ NENHUM, a aresta CEGA);
		A6 pedido (passo 12 ↔ passo 9, evt-purchase-order-emitted — o canal
		pelo qual o vencedor descobre que venceu); A7 entrega (NENHUM ↔
		passo 10, evt-evidence-recorded — a aresta órfã: o fornecedor tem
		passo, o comprador não tem correspondente em story alguma).

		DUAS ARESTAS SÃO ASSIMÉTRICAS POR DESIGN, não por lacuna: A2 e A5
		atravessam eventos internal por confidencialidade competitiva. A
		consequência é estrutural e está registrada no passo 9 desta story:
		o fornecedor descobre que venceu quando o pedido chega.

		subdomainRef=ssc por centro de gravidade dos ATOS: dos seis atos do
		fornecedor, três são ssc (cotar, revisar, declinar), dois npm
		(cadastrar, submeter documentos) e um dlv (registrar evidência); e é
		o ssc que possui o processo competitivo que o fornecedor atravessa
		repetidamente, enquanto o npm é portão que ele cruza uma vez. A
		story do comprador é do p2p pela mesma lógica aplicada ao arco dela.

		REFS VAZIOS SÃO LACUNA HONESTA COM NATUREZA DECLARADA, e há duas
		naturezas distintas nesta story: nos passos 4, 6 e 9 o
		commandRefs vazio significa 'receber não é ato' — não falta comando
		ao modelo; no passo 3 significa 'o comando existe e é de OUTRO ator'
		— referenciá-lo repetiria o defeito que a correção do passo 9 da
		story do comprador desfez no mesmo commit.

		O QUE ESTA STORY NÃO DECIDE: qual caminho de entrada o produto tem
		(def-095 nomeia cinco; o passo 1 narra o único sustentado hoje) e
		qual a forma do aceite na entrega (def-091, segunda frente; o passo
		10 declara o limite em vez de escolher).

		POR QUE OS PASSOS 7 E 8 VIVEM SÓ AQUI, E O 5 NÃO (2026-09-07, fatia
		0): vale a regra que a ds-buyer-procurement-journey enuncia — ato de
		sh-02 aparece lá quando é INSUMO do arco do comprador, e só aqui
		quando é RESPOSTA dentro da rodada. cmd-submit-quotation é insumo
		(sem cotação não há mapa) e por isso está nas duas; revisar e
		declinar são resposta, e por isso saíram de lá. A aresta A2 registra
		o efeito: o evento cruza, mas com sh-02 dos dois lados — não é
		bilateralidade, é o mesmo ato narrado de dois pontos de vista. E A2
		PERMANECE REGISTRADA COMO ARESTA SEM LADO COMPRADOR: a aparência de
		par vem da regra acima, não de uma contraparte que falte. Ninguém
		deve ler esta regra e concluir que A2 precisa ganhar par.
		"""
}
