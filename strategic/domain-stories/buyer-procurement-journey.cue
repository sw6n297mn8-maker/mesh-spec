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
		actorRef: "sh-05"
		action:   "O agente da Mesh, à medida que as propostas chegam e no fecho da janela de cotação, aplica a regra publicada da categoria sobre o mapa de cotações e propõe ao comprador um fornecedor por material — com o motivo, a alternativa mais próxima e a diferença — separando o que a regra resolveu sem margem de dúvida do que exige julgamento humano: valor acima da alçada, proposta mais barata que falha em prazo ou quantidade, fornecedor sem histórico."
		workItem: {
			description:       "Avaliar as cotações recebidas com as fitness rules versionadas da categoria e produzir a proposta de decisão — ranking, política de alocação recomendada e rationale por material — para ratificação humana. O agente propõe; não decide."
			boundedContextRef: "ssc"
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-fitness-rules", "term-fitness-signals", "term-decision-rationale", "term-mapa-de-cotacoes"]
		}
		rationale: "O operador primário da plataforma entra na narrativa. sh-05 é declarado no stakeholder-map como 'o operador primário da plataforma (a Mesh é AI-operated)' e a story não tinha NENHUM passo dele — cinco atores humanos e zero agente, numa jornada que a tese diz ser operada por agente. A preparação da decisão EXISTE no modelo de agente: act-evaluate-and-conclude-rfq (propose-and-wait, human gate antes do emit) + act-generate-decision-rationale, sobre svc-fitness-rule-evaluator e inv-decision-rationale-required. Mas as refs deste passo ficam VAZIAS em comando e evento por LACUNA HONESTA (adr-170): o schema da story não referencia act-/svc-, e o domain-model do ssc não tem elemento para a proposta que aguarda ratificação — nem comando, nem evento, nem projection (prj-active-sourcing-decisions é pós-decisão). O agente prepara para o nada observável. Lacuna descoberta em 2026-09-03 por divergência entre dois artefatos de protótipo, cada um fiel a um lado: um encarnava o agent-spec (proposta do agente), outro encarnava o passo do mapa (comprador comparando sozinho) — a story era a fonte de ambos e não decidia entre eles."
	}, {
		actorRef: "sh-08"
		action:   "O comprador lê a proposta da Mesh material a material: ratifica o que a regra resolveu e, onde discorda ou onde a regra não resolveu, abre o mapa de cotações — no mínimo três preços lado a lado — e compara ele mesmo preço, prazo de entrega, condições de pagamento e qualidade."
		workItem: {
			description:       "Apresentar ao comprador a comparação consolidada das cotações recebidas no RFQ para suportar a escolha, como caminho de desvio da proposta do passo anterior."
			boundedContextRef: "ssc"
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-equalizacao-tco", "term-mapa-de-cotacoes"]
		}
		rationale: "O 'mapa de cotações' é o instrumento central do comprador nas fontes. No exame original (2026-07-12) o modelo tinha o conceito (equalização TCO como serviço interno) mas NENHUMA projection/query consultável — lacuna de leitura no coração da jornada; FECHADA em 2026-07-13 pelo WI-152: prj-quotation-map/qry-quotation-map materializam a comparação consolidada consultável (viva durante a janela de RFQ, carimbada pela decisão), refs deste passo. Revisão de 2026-09-03: o passo descrevia o caminho manual como ÚNICO; passa a ser o DESVIO da proposta do agente. O mapa não perde centralidade — é para onde o comprador vai quando não ratifica, e é a mesa da negociação do passo seguinte."
	}, {
		actorRef: "sh-08"
		action:   "O comprador negocia com os melhores colocados: não aceita o primeiro preço, busca reduzir o custo de aquisição e, principalmente, melhorar as condições de pagamento — o fluxo de caixa é o que evita a obra quebrar; havendo cronograma e espaço no canteiro, negocia volume com entregas programadas. Parte do alvo de contraproposta que a Mesh prepara a partir da equalização e do histórico da categoria, e decide e envia."
		workItem: {
			description:       "Registrar as rodadas de negociação (contrapropostas, condições de pagamento, volume e programação de entregas) até as condições finais."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-propose-counter-terms", "cmd-revise-quotation", "cmd-decline-counter-terms"]
			eventRefs: ["evt-counter-terms-proposed", "evt-quotation-revised", "evt-counter-terms-declined"]
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-contraproposta", "term-rodada-de-negociacao", "term-condicoes-de-pagamento", "term-entregas-programadas"]
		}
		rationale: "O passo que as fontes chamam de 'arte' e apontam como o que salva o fluxo de caixa. No exame original (2026-07-12) era o vazio mais denso em valor da story — zero elementos em qualquer BC; FECHADO em 2026-07-28 pelo WI-161: rodadas de contraproposta→revisão|recusa intra-open (3 commands + 3 events internal, molde dos fatos de cotação — confidencialidade preservada), condições de pagamento e entregas programadas ESTRUTURADAS (vo-payment-terms/vo-delivery-schedule), e a regra de ouro inv-negotiated-terms-materialize-on-quotation: só a revisão do fornecedor materializa condições na cotação — o gate de procedência do adr-177 resolve o preço FINAL na cotação vencedora por construção ('as condições finais que a decisão formaliza'). A mesa da negociação é o próprio mapa (prj/qry-quotation-map, agora com as rodadas), refs deste passo. Revisão de 2026-09-03: o alvo de contraproposta é preparado pelo agente (act-prepare-counter-proposal, propose-and-wait) e EMITIDO pelo comprador — quem invoca cmd-propose-counter-terms segue sendo sh-08, por isso as refs não mudam."
	}, {
		actorRef: "sh-08"
		action:   "O comprador registra a decisão de sourcing — a proposta ratificada ou a escolha própria, com o motivo por material — e a cotação se conclui."
		workItem: {
			description:       "Formalizar a decisão de sourcing sobre a cotação vencedora, com rationale de decisão registrado."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-make-one-shot-sourcing-decision"]
			eventRefs: ["evt-sourcing-decision-made", "evt-rfq-concluded"]
			termRefs: ["term-sourcing-decision", "term-one-shot-sourcing-decision", "term-decision-rationale"]
		}
		rationale: "A decisão formal EXISTE no modelo (sourcing decision, ssc) — este passo carrega a metade ssc do antigo passo 9. Revisão de 2026-09-03: o antigo passo 9 colapsava DOIS atos de atores distintos — a decisão de sourcing (ssc, ato do PREPARADOR) e a aprovação por Alçada (p2p, ato do APROVADOR) — e citava nos refs o comando da primeira sob o ator da segunda. O WI-157 (def-076 resolved) separou os papéis e o stakeholder-map descreve sh-09 como quem 'revisa a compra preparada pelo comprador e APROVA por Alçada'; os refs do passo não refletiam a separação. O desmembramento a materializa: adr-174 decisão 1 já ordenava 'cotação/decisão de sourcing no ssc → APROVAÇÃO com Gate de Cobertura' como estágios distintos. A atribuição do comando a sh-08 é inferência ratificada pelo founder (2026-09-03): o repositório não nomeia o invocador literalmente, e a leitura alternativa colapsaria a separação preparador×aprovador. Lacuna registrada: o campo decidedBy de cmd-make-one-shot-sourcing-decision é string nominal e NÃO distingue 'ratificou a proposta do agente' de 'escolheu por conta própria' — quando der errado, a auditoria não responde quem errou. Mesma forma estrutural que o def-080 já defere para #Command."
	}, {
		actorRef: "sh-09"
		action:   "O gestor revisa a compra preparada pelo comprador — cobertura orçamentária, Alçada e a alternativa que o comprador preteriu — e aprova ou recusa com motivo, garantindo alinhamento com o planejamento estratégico e financeiro da construtora."
		workItem: {
			description:       "Aprovar a requisição triada sob o portão DUPLO pré-pedido: reserva de cobertura confirmada pelo Gate de Cobertura do bdg (Saldo Disponível + Alçada) e procedência de preço verificada contra a cotação vencedora do ssc."
			boundedContextRef: "p2p"
			commandRefs: ["cmd-approve-purchase"]
			eventRefs: ["evt-purchase-approved", "evt-purchase-approval-rejected"]
			termRefs: ["term-aprovar-compra", "term-compra-aprovada", "term-aprovacao-de-compra-recusada", "term-sourcing-authority"]
		}
		rationale: "O portão MECÂNICO de alçada pré-pedido agora existe (2026-07-12, adr-174/WI-151): cmd-approve-purchase invoca o Gate de Cobertura do bdg (Saldo Disponível + Alçada) na aprovação da requisição, pré-pedido — a divergência de ordem do exame original ('a aprovação do bdg dispara noutro momento') morreu. A separação preparador×aprovador FECHOU em 2026-07-29 pelo WI-157 (def-076 resolved): sh-09 gestor-aprovador é o actorRef deste passo; a operacionalização do papel na borda (quem PODE aprovar) é o desenho de identidade do WI-158. Revisão de 2026-09-03: o passo referenciava nos refs o comando da decisão de sourcing (ssc) sob o ator da aprovação; passa a referenciar o comando REAL do gate, cmd-approve-purchase (p2p), com os dois desfechos do selector de adr-160 (approve/reject). A aprovação NÃO é condicional a limiar: adr-174 decisão 1 põe 'Alçada e saldo são PRÉ-CONDIÇÃO da emissão' e o lifecycle não tem outra rota de triaged→approved — a Alçada é avaliada DENTRO do Gate de Cobertura, não é condição para o passo acontecer. A 'alternativa preterida' que o gestor lê vive na decisão de sourcing (vo-tradeoff, vo-decision-rationale do ssc), não no ato de aprovar — é referência entre agregados, não campo do comando."
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

		Revisão de 2026-09-03: o agente (sh-05) entra na narrativa como
		preparador da decisão de sourcing — a story tinha cinco atores humanos
		e nenhum passo do operador primário da plataforma; e a decisão de
		sourcing (ssc, sh-08) foi desmembrada da aprovação por Alçada (p2p,
		sh-09), atos distintos que o antigo passo 9 colapsava contra a
		separação fechada pelo WI-157. Origem da descoberta: divergência entre
		dois artefatos de protótipo, cada um fiel a um lado da story.
		"""
}
