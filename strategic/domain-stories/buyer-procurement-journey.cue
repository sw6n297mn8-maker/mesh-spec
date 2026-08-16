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
		actorRef: "sh-07"
		action:   "O engenheiro da construtora, na visita técnica diária ao canteiro, identifica pelo cronograma físico o que as próximas etapas vão exigir — quantidades, especificações e prazos (ex.: materiais de elétrica para iniciar o forro) — e expressa ali mesmo o que precisa, com as informações que possui naquele momento."
		workItem: {
			description:       "Receber a expressão do engenheiro como insumo da interpretação. Nada se materializa neste passo: a observação do canteiro não tem cerimônia de escrita própria no modelo — o fato-de-origem entra como campo da requisição que o passo seguinte cria."
			boundedContextRef: "p2p"
			termRefs: ["term-originadora-de-demanda"]
		}
		rationale: "Onde a jornada NASCE na narrativa real, e onde a fricção da captura decide a adoção na ponta (sh-07, int-frictionless-demand-capture). As refs vazias deste passo NÃO são cobertura pendente: são a decisão registrada — o fato-de-origem vive como CAMPO (budgetStageRef, WI-151) e o adr-178 declarou que a observação no canteiro não ganha cerimônia própria. O passo segue sendo o teste da ponta-canteiro: se um dia a expressão precisar de lar de escrita, é aqui que a falta aparece."
	}, {
		actorRef: "sh-07"
		action:   "O engenheiro formaliza a solicitação de compra direto do canteiro: confirma a Requisição de Compra que a Mesh estruturou a partir do que ele expressou, respondendo apenas o que ela não conseguiu resolver com segurança."
		workItem: {
			description:       "Interpretar a expressão, estruturar a Requisição de Compra — Centro de Custo, etapa do orçamento que origina a demanda, categoria e escopo —, preencher o que puder ser inferido com segurança da própria expressão, pedir ao engenheiro apenas o que restar, e materializar a requisição, que nasce submetida e entra na fila de triagem."
			boundedContextRef: "p2p"
			commandRefs: ["cmd-submit-purchase-requisition"]
			eventRefs: ["evt-purchase-requisition-submitted"]
			termRefs: ["term-requisitante"]
		}
		rationale: "A requisição é o elo de rastreabilidade custo↔obra que as fontes tratam como fundação. No exame original (2026-07-12) este era o vazio mais importante que a story revelou — 'requisi' tinha zero ocorrências em todos os domain-models; FECHADO na mesma data pelo WI-151/adr-174: agg-purchase-requisition materializa a requisição com vínculo a Centro de Custo (costCenterRef) e etapa do orçamento (budgetStageRef, fato-de-origem), e as refs deste passo apontam os elementos reais criados. Sobre a ORIGEM, o passo narra o regime vigente do adr-178: a informação nasce fora do sistema (origem net-new), então o que a Mesh preenche vem da própria expressão — quando o cronograma virar input de sistema, a origem migra para a Generative Form padrão da adr-150 (def-081) sem mudar a forma deste passo. A completude NÃO é julgada aqui: a submissão não tem guard na porta por design (adr-178) — quem devolve o incompleto é a triagem do passo 3 (inv-requisition-completeness)."
	}, {
		actorRef: "sh-08"
		action:   "O comprador, no escritório, recebe a solicitação que chega automaticamente, tria e analisa a necessidade antes de ir a mercado."
		workItem: {
			description:       "Disponibilizar ao comprador a fila de solicitações recebidas para triagem e análise."
			boundedContextRef: "p2p"
			commandRefs: ["cmd-triage-requisition"]
			eventRefs: ["evt-purchase-requisition-triaged"]
			readModelRefs: ["prj-pending-requisitions"]
			queryRefs: ["qry-pending-requisitions"]
			termRefs: ["term-comprador"]
		}
		rationale: "O protagonista assume a jornada aqui; a triagem é a fronteira requisitante→comprador. No exame original (2026-07-12) o passo dependia da requisição inexistente — vazio em cascata; FECHADO na mesma data pelo WI-151/adr-174: triagem materializada como ATO FORMAL (cmd-triage-requisition com outcome routed-to-sourcing | returned | rejected) sobre a fila consultável (prj-pending-requisitions), refs deste passo."
	}, {
		actorRef: "sh-08"
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
		actorRef: "sh-08"
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
			eventRefs: ["evt-quotation-submitted"]
			termRefs: ["term-rfq"]
		}
		rationale: "Único passo do recorte com o fornecedor como ator agindo. No exame original (2026-07-12) o comando existia mas NÃO publicava evento — a submissão não virava fato observável; FECHADO em 2026-07-13 pelo WI-152: evt-quotation-submitted (internal — fato intra-BC; a confidencialidade competitiva veta evento público, não o fato existir) torna a submissão observável e alimenta o mapa de cotações."
	}, {
		actorRef: "sh-08"
		action:   "O comprador consolida o mapa de cotações — no mínimo três preços lado a lado — e compara preço, prazo de entrega, condições de pagamento e qualidade."
		workItem: {
			description:       "Apresentar ao comprador a comparação consolidada das cotações recebidas no RFQ para suportar a escolha."
			boundedContextRef: "ssc"
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-equalizacao-tco", "term-mapa-de-cotacoes"]
		}
		rationale: "O 'mapa de cotações' é o instrumento central do comprador nas fontes. No exame original (2026-07-12) o modelo tinha o conceito (equalização TCO como serviço interno) mas NENHUMA projection/query consultável — lacuna de leitura no coração da jornada; FECHADA em 2026-07-13 pelo WI-152: prj-quotation-map/qry-quotation-map materializam a comparação consolidada consultável (viva durante a janela de RFQ, carimbada pela decisão), refs deste passo."
	}, {
		actorRef: "sh-08"
		action:   "O comprador negocia com os melhores colocados: não aceita o primeiro preço, busca reduzir o custo de aquisição e, principalmente, melhorar as condições de pagamento — o fluxo de caixa é o que evita a obra quebrar; havendo cronograma e espaço no canteiro, negocia volume com entregas programadas."
		workItem: {
			description:       "Registrar as rodadas de negociação (contrapropostas, condições de pagamento, volume e programação de entregas) até as condições finais."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-propose-counter-terms", "cmd-revise-quotation", "cmd-decline-counter-terms"]
			eventRefs: ["evt-counter-terms-proposed", "evt-quotation-revised", "evt-counter-terms-declined"]
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-contraproposta", "term-rodada-de-negociacao", "term-condicoes-de-pagamento", "term-entregas-programadas"]
		}
		rationale: "O passo que as fontes chamam de 'arte' e apontam como o que salva o fluxo de caixa. No exame original (2026-07-12) era o vazio mais denso em valor da story — zero elementos em qualquer BC; FECHADO em 2026-07-28 pelo WI-161: rodadas de contraproposta→revisão|recusa intra-open (3 commands + 3 events internal, molde dos fatos de cotação — confidencialidade preservada), condições de pagamento e entregas programadas ESTRUTURADAS (vo-payment-terms/vo-delivery-schedule), e a regra de ouro inv-negotiated-terms-materialize-on-quotation: só a revisão do fornecedor materializa condições na cotação — o gate de procedência do adr-177 resolve o preço FINAL na cotação vencedora por construção ('as condições finais que a decisão formaliza'). A mesa da negociação é o próprio mapa (prj/qry-quotation-map, agora com as rodadas), refs deste passo."
	}, {
		actorRef: "sh-09"
		action:   "O gestor revisa a compra preparada pelo comprador e aprova no sistema, garantindo alinhamento com o planejamento estratégico e financeiro da construtora."
		workItem: {
			description:       "Formalizar a decisão de sourcing sobre a cotação vencedora, com rationale de decisão registrado."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-make-one-shot-sourcing-decision"]
			eventRefs: ["evt-sourcing-decision-made"]
			termRefs: ["term-sourcing-decision", "term-decision-rationale"]
		}
		rationale: "A decisão formal EXISTE no modelo (sourcing decision, ssc). O portão MECÂNICO de alçada pré-pedido agora existe (2026-07-12, adr-174/WI-151): cmd-approve-purchase invoca o Gate de Cobertura do bdg (Saldo Disponível + Alçada) na aprovação da requisição, pré-pedido — a divergência de ordem do exame original ('a aprovação do bdg dispara noutro momento') morreu. A separação preparador×aprovador FECHOU em 2026-07-29 pelo WI-157 (def-076 resolved): sh-09 gestor-aprovador é o actorRef deste passo; a operacionalização do papel na borda (quem PODE aprovar) é o desenho de identidade do WI-158."
	}, {
		actorRef: "sh-08"
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
		cobertura dos BCs da cunha e revelou, no exame original (2026-07-12), onde
		o modelo começava tarde: a jornada real nasce no canteiro e os passos 1-3
		não tinham lar de escrita — a modelada nascia na cotação (passo 5). Os
		passos 2-3 fecharam pelo WI-151/adr-174 (ver rationales dos passos); o
		passo 1 permanece sem cerimônia própria POR DECISÃO (adr-178). Registro
		canônico per adr-170; refs verificadas elemento a elemento contra os
		domain-models dos BCs de cada passo.
		"""
}
