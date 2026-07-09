package domain_stories

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

buyerProcurementJourney: artifact_schemas.#DomainStory & {
	code: "ds-buyer-procurement-journey"
	name: "Jornada de compras do comprador da construtora — da necessidade ao pedido"

	subdomainRef: "p2p"

	purpose: """
		Cenário concreto: uma construtora em obra ativa precisa comprar materiais
		(ex.: elétrica para iniciar o forro). A jornada vai da identificação da
		necessidade no canteiro até a emissão do pedido de compra ao fornecedor —
		o ciclo demanda-a-pedido que o setor de suprimentos vive hoje, na ordem
		em que a dor acontece. Fonte declarada (tq-dsg-03): entrevistas com
		compradores + vídeos de referência de gestão de compras na construção
		civil (coletados pelo founder, 2026-07). Acompanhamento, recebimento e
		pagamento ficam fora — story futura.
		"""

	steps: [{
		actorRef: "sh-01"
		action:   "O engenheiro da construtora, na visita técnica diária ao canteiro, identifica pelo cronograma físico o que as próximas etapas vão exigir — quantidades, especificações e prazos (ex.: materiais de elétrica para iniciar o forro)."
		workItem: {
			description:       "Registrar a necessidade identificada como demanda rastreável, ancorada na etapa do cronograma que a origina."
			boundedContextRef: "p2p"
			termRefs: ["term-originadora-de-demanda"]
		}
		rationale: "Onde a jornada NASCE na narrativa real — e onde o modelo hoje não tem nenhum elemento de escrita; o passo testa a cobertura da ponta-canteiro do ciclo demanda-a-pedido."
	}, {
		actorRef: "sh-01"
		action:   "O engenheiro formaliza a solicitação de compra no sistema, direto do canteiro, selecionando o centro de custo da obra e vinculando cada item a uma etapa do orçamento (ex.: reboco)."
		workItem: {
			description:       "Criar a requisição de compra com vínculo a centro de custo e etapa do orçamento, garantindo rastreabilidade do custo desde a origem."
			boundedContextRef: "p2p"
			termRefs: ["term-requisitante"]
		}
		rationale: "A requisição é o elo de rastreabilidade custo↔obra que as fontes tratam como fundação — e é o vazio mais importante que a story revela: 'requisi' tem zero ocorrências em todos os domain-models."
	}, {
		actorRef: "sh-01"
		action:   "O comprador, no escritório, recebe a solicitação que chega automaticamente, tria e analisa a necessidade antes de ir a mercado."
		workItem: {
			description:       "Disponibilizar ao comprador a fila de solicitações recebidas para triagem e análise."
			boundedContextRef: "p2p"
			termRefs: ["term-comprador"]
		}
		rationale: "O protagonista assume a jornada aqui; a triagem é a fronteira requisitante→comprador e depende da requisição inexistente — vazio em cascata."
	}, {
		actorRef: "sh-01"
		action:   "O comprador verifica quais fornecedores homologados atendem a categoria; não havendo homologado, busca novos parceiros no mercado e aciona sua qualificação."
		workItem: {
			description:       "Consultar o status de qualificação dos participantes da rede e iniciar o gate de qualificação para fornecedores novos."
			boundedContextRef: "npm"
			readModelRefs: ["prj-participant-status-view"]
			queryRefs: ["qry-participant-status"]
			termRefs: ["term-qualificacao", "term-status-de-participante"]
		}
		rationale: "A qualificação entra INLINE na jornada real (aciona quando falta homologado), não como pré-condição estática — testa a cobertura de leitura do npm no momento de uso."
	}, {
		actorRef: "sh-01"
		action:   "O comprador abre a cotação para a categoria junto aos fornecedores selecionados, pedindo no mínimo três propostas."
		workItem: {
			description:       "Abrir o processo de cotação (RFQ) para a categoria com o pool de fornecedores qualificados."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-open-rfq"]
			eventRefs: ["evt-rfq-opened"]
			termRefs: ["term-rfq", "term-categoria-de-compra"]
		}
		rationale: "Primeiro passo da narrativa com lar de escrita completo no modelo — a jornada modelada começa AQUI, quatro passos depois da jornada real."
	}, {
		actorRef: "sh-02"
		action:   "O fornecedor prepara e submete sua proposta comercial à cotação aberta — preço, prazo de entrega e condições de pagamento."
		workItem: {
			description:       "Receber e registrar a cotação do fornecedor no processo de RFQ aberto."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-submit-quotation"]
			termRefs: ["term-rfq"]
		}
		rationale: "Único passo do recorte com o fornecedor como ator agindo; o comando existe mas NÃO publica evento — a submissão da cotação não vira fato observável."
	}, {
		actorRef: "sh-01"
		action:   "O comprador consolida o mapa de cotações — no mínimo três preços lado a lado — e compara preço, prazo de entrega, condições de pagamento e qualidade."
		workItem: {
			description:       "Apresentar ao comprador a comparação consolidada das cotações recebidas no RFQ para suportar a escolha."
			boundedContextRef: "ssc"
			termRefs: ["term-equalizacao-tco"]
		}
		rationale: "O 'mapa de cotações' é o instrumento central do comprador nas fontes; o modelo tem o conceito (equalização TCO como serviço interno) mas NENHUMA projection/query consultável — lacuna de leitura no coração da jornada."
	}, {
		actorRef: "sh-01"
		action:   "O comprador negocia com os melhores colocados: não aceita o primeiro preço, busca reduzir o custo de aquisição e, principalmente, melhorar as condições de pagamento — o fluxo de caixa é o que evita a obra quebrar; havendo cronograma e espaço no canteiro, negocia volume com entregas programadas."
		workItem: {
			description:       "Registrar as rodadas de negociação (contrapropostas, condições de pagamento, volume e programação de entregas) até as condições finais."
			boundedContextRef: "ssc"
		}
		rationale: "O passo que as fontes chamam de 'arte' e apontam como o que salva o fluxo de caixa — zero elementos em qualquer BC; o vazio mais denso em valor da story."
	}, {
		actorRef: "sh-01"
		action:   "O gestor revisa a compra preparada pelo comprador e aprova no sistema, garantindo alinhamento com o planejamento estratégico e financeiro da construtora."
		workItem: {
			description:       "Formalizar a decisão de sourcing sobre a cotação vencedora, com rationale de decisão registrado."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-make-one-shot-sourcing-decision"]
			eventRefs: ["evt-sourcing-decision-made"]
			termRefs: ["term-sourcing-decision", "term-decision-rationale"]
		}
		rationale: "A decisão formal EXISTE no modelo; o que falta é a separação preparador (comprador) × aprovador (gestor) — alçada de aprovação pré-pedido não existe em nenhum BC; a aprovação do bdg dispara noutro momento (divergência de ordem registrada no relatório da story)."
	}, {
		actorRef: "sh-01"
		action:   "O comprador converte a solicitação aprovada em pedido de compra oficial e o envia ao fornecedor, com prazo hábil para a entrega não interromper o cronograma (solicitação de quinta, entrega programada para segunda)."
		workItem: {
			description:       "Emitir o pedido de compra sob a authority da decisão de sourcing e publicá-lo ao fornecedor."
			boundedContextRef: "p2p"
			commandRefs: ["cmd-emit-purchase-order"]
			eventRefs: ["evt-purchase-order-emitted"]
			readModelRefs: ["prj-purchase-orders"]
			termRefs: ["term-purchase-order", "term-sourcing-authority"]
		}
		rationale: "O desfecho do recorte, com lar completo (emissão sob authority validada) — e a fronteira da dobra cunha→core: evt-purchase-order-emitted é o que o cmt consome para iniciar o compromisso, fora deste recorte."
	}]

	rationale: """
		Primeira domain story do repo: a jornada da dor que a cunha da Mesh ataca
		(fazer o trabalho do setor de compras mais barato, mais rápido e melhor),
		derivada de fonte real na ordem vivida — não do modelo. Executa o teste de
		cobertura dos BCs da cunha e revela onde o modelo começa tarde: a jornada
		real nasce no canteiro (passos 1-3, sem lar de escrita); a modelada nasce
		na cotação (passo 5). Registro canônico per adr-170; refs verificadas
		elemento a elemento contra os domain-models dos BCs de cada passo.
		"""
}
