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

		A story narra a jornada como a Mesh a opera: o humano expressa a
		intenção, a Mesh conduz o trabalho operacional, e o humano entra só
		onde há informação que só ele tem, julgamento econômico real,
		autoridade ou exceção que a Mesh não resolve — e a Mesh retoma em
		seguida. A ratificação da compra preparada é o gesto humano que
		autoriza o conjunto.
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
			description:       "Interpretar a expressão, estruturar a Requisição de Compra — Centro de Custo, etapa do orçamento que origina a demanda, categoria e escopo —, preencher o que puder ser inferido com segurança da própria expressão, verificar ali mesmo a completude que a triagem vai exigir e pedir ao engenheiro apenas o que só ele sabe, e materializar a requisição, que nasce submetida."
			boundedContextRef: "p2p"
			commandRefs: ["cmd-submit-purchase-requisition"]
			eventRefs: ["evt-purchase-requisition-submitted"]
			termRefs: ["term-requisitante"]
		}
		rationale: "A requisição é o elo de rastreabilidade custo↔obra que as fontes tratam como fundação. No exame original (2026-07-12) este era o vazio mais importante que a story revelou — 'requisi' tinha zero ocorrências em todos os domain-models; FECHADO na mesma data pelo WI-151/adr-174: agg-purchase-requisition materializa a requisição com vínculo a Centro de Custo (costCenterRef) e etapa do orçamento (budgetStageRef, fato-de-origem), e as refs deste passo apontam os elementos reais criados. Sobre a ORIGEM, o passo narra o regime vigente do adr-178: a informação nasce fora do sistema (origem net-new), então o que a Mesh preenche vem da própria expressão — quando o cronograma virar input de sistema, a origem migra para a Generative Form padrão da adr-150 (def-081) sem mudar a forma deste passo. A completude NÃO é julgada aqui: a submissão não tem guard na porta por design (adr-178) — quem devolve o incompleto é a triagem do passo 3 (inv-requisition-completeness). Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): a Mesh persegue a completude já na captura, perguntando ao engenheiro especificamente o que falta, para que a devolução da triagem vire exceção e não o caminho normal; o comando segue sem guard e o invariante segue garantido no passo 3."
	}, {
		actorRef: "sh-05"
		action:   "A Mesh tria a requisição que chega: verifica a completude pela regra e a encaminha para cotação, ou a devolve ao engenheiro dizendo o que falta. A compradora só é chamada quando há motivo para rejeitar a demanda, conflito com outra demanda ou outra exceção que exija decisão dela."
		workItem: {
			description:       "Triar a requisição submetida contra a regra de completude e registrar o desfecho — encaminhada para cotação ou devolvida —, escalando à compradora só o que pede decisão humana (rejeição, conflito, exceção)."
			boundedContextRef: "p2p"
			commandRefs: ["cmd-triage-requisition"]
			eventRefs: ["evt-purchase-requisition-triaged"]
			readModelRefs: ["prj-pending-requisitions"]
			queryRefs: ["qry-pending-requisitions"]
			termRefs: ["term-comprador"]
		}
		rationale: "O protagonista assume a jornada aqui; a triagem é a fronteira requisitante→comprador. No exame original (2026-07-12) o passo dependia da requisição inexistente — vazio em cascata; FECHADO na mesma data pelo WI-151/adr-174: triagem materializada como ATO FORMAL (cmd-triage-requisition com outcome routed-to-sourcing | returned | rejected) sobre a fila consultável (prj-pending-requisitions), refs deste passo. Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): a triagem segue ato formal, mas a verificação de completude é mecânica e não é razão para a compradora estar aqui — o ator passa a ser a Mesh (sh-05). Ficam com a compradora a rejeição da demanda e o conflito, que são julgamento; a fila continua sendo onde essas exceções chegam a ela."
	}, {
		actorRef: "sh-05"
		action:   "A Mesh monta o pool de fornecedores qualificados que atendem a categoria. Quando o pool não basta, ou quando um fornecedor novo precisa de qualificação que exige autoridade de alguém, ela escala só essa questão a quem pode decidi-la."
		workItem: {
			description:       "Consultar o status de qualificação dos participantes da rede, montar o pool qualificado da categoria e iniciar o gate de qualificação para fornecedores novos quando faltar homologado."
			boundedContextRef: "npm"
			readModelRefs: ["prj-participant-status-view"]
			queryRefs: ["qry-participant-status"]
			termRefs: ["term-qualificacao", "term-status-de-participante"]
		}
		rationale: "A qualificação entra INLINE na jornada real (aciona quando falta homologado), não como pré-condição estática — testa a cobertura de leitura do npm no momento de uso. Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): montar o pool é operação, não julgamento: o ator passa a ser a Mesh (sh-05). A aprovação da qualificação continua sendo de quem tem a autoridade no npm — a Mesh leva a questão pronta, não a decide."
	}, {
		actorRef: "sh-05"
		action:   "Com a requisição encaminhada e o pool montado, a Mesh abre a cotação para a categoria junto aos fornecedores do pool, quando as condições da organização para essa cotação estão satisfeitas; quando não estão, escala a abertura."
		workItem: {
			description:       "Abrir o processo de cotação (RFQ) para a categoria com o pool de fornecedores qualificados."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-open-rfq"]
			eventRefs: ["evt-rfq-opened"]
			termRefs: ["term-rfq", "term-categoria-de-compra"]
		}
		rationale: "Primeiro passo da narrativa com lar de escrita completo no modelo — a jornada modelada começa AQUI, quatro passos depois da jornada real. Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): abrir a cotação rotineira é trabalho da Mesh (sh-05). O piso de 'no mínimo três propostas' saiu da ação junto com o ator — já não tinha lastro no glossário do ssc (removido em 8e0202f). O que torna uma cotação rotineira não está definido no repositório: lacuna registrada fora da story."
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
		action:   "Durante a janela, a Mesh conduz a cotação: acompanha quem abriu o convite e quem respondeu, cobra as respostas quando cabe, recota o que o fluxo já determina — item sem proposta viável, convidado que declinou —, trata as pendências que consegue resolver e busca a informação que falta antes de escalar qualquer coisa."
		workItem: {
			description:       "Acompanhar a janela de cotação até o fecho: abertura dos convites, respostas, cobranças, recotação e pendências, mantendo o mapa de cotações vivo."
			boundedContextRef: "ssc"
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-rfq", "term-mapa-de-cotacoes"]
		}
		rationale: "Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): o trabalho que antes caía na compradora sem estar escrito — saber quem abriu, cobrar quem não respondeu, recotar o item sem proposta — passa a ser declarado como da Mesh. commandRefs e eventRefs VAZIOS por LACUNA HONESTA (adr-170): o ssc não tem elemento para acompanhamento, cobrança ou recotação; o mapa é o único lar de leitura. Quando a recotação ganhar forma, é aqui que ela aparece."
	}, {
		actorRef: "sh-05"
		action:   "A Mesh recebe as propostas, estrutura, normaliza e verifica cada uma e, no fecho da janela, aplica a regra publicada da categoria sobre o mapa de cotações: prepara um fornecedor por material — com o motivo, a alternativa mais próxima e a diferença — e identifica onde há espaço para negociar, separando o que a regra resolveu sem margem de dúvida do que exige julgamento humano: valor acima da alçada, proposta mais barata que falha em prazo ou quantidade, fornecedor sem histórico."
		workItem: {
			description:       "Avaliar as cotações recebidas com as fitness rules versionadas da categoria e produzir a proposta de decisão — ranking, política de alocação recomendada e rationale por material — para ratificação humana. O agente propõe; não decide."
			boundedContextRef: "ssc"
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-fitness-rules", "term-fitness-signals", "term-decision-rationale", "term-mapa-de-cotacoes"]
		}
		rationale: "O operador primário da plataforma entra na narrativa. sh-05 é declarado no stakeholder-map como 'o operador primário da plataforma (a Mesh é AI-operated)' e a story não tinha NENHUM passo dele — cinco atores humanos e zero agente, numa jornada que a tese diz ser operada por agente. A preparação da decisão EXISTE no modelo de agente: act-evaluate-and-conclude-rfq (propose-and-wait, human gate antes do emit) + act-generate-decision-rationale, sobre svc-fitness-rule-evaluator e inv-decision-rationale-required. Mas as refs deste passo ficam VAZIAS em comando e evento por LACUNA HONESTA (adr-170): o schema da story não referencia act-/svc-, e o domain-model do ssc não tem elemento para a proposta que aguarda ratificação — nem comando, nem evento, nem projection (prj-active-sourcing-decisions é pós-decisão). O agente prepara para o nada observável. Lacuna descoberta em 2026-09-03 por divergência entre dois artefatos de protótipo, cada um fiel a um lado: um encarnava o agent-spec (proposta do agente), outro encarnava o passo do mapa (comprador comparando sozinho) — a story era a fonte de ambos e não decidia entre eles. Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): o passo passa de 7 a 8 (o 7 agora narra a condução da janela), deixa de propor direto ao comprador — a proposta segue para a negociação e chega à compradora como compra preparada no passo 10 — e ganha o trabalho de receber, normalizar e verificar as propostas, para que ninguém precise reconstruir a comparação. A lacuna de refs continua a mesma, e o adr-196 continua sendo o caminho que a fecha."
	}, {
		actorRef: "sh-05"
		action:   "A Mesh negocia com os melhores colocados: não aceita o primeiro preço, busca reduzir o custo de aquisição e, principalmente, melhorar as condições de pagamento — o fluxo de caixa é o que evita a obra quebrar; havendo cronograma e espaço no canteiro, negocia volume com entregas programadas. Prepara e envia as contrapropostas a partir da equalização e do histórico da categoria, recebe as respostas, acompanha e cobra as rodadas, registra as novas condições e atualiza a análise. Quando o alvo depende de um trade-off que a regra não determina — preço contra prazo, caixa contra condição comercial, ou outra preferência real —, leva à compradora só essa decisão, com as alternativas e o que cada uma implica, e retoma a negociação assim que ela decide."
		workItem: {
			description:       "Registrar as rodadas de negociação (contrapropostas, condições de pagamento, volume e programação de entregas) até as condições finais."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-propose-counter-terms"]
			eventRefs: ["evt-counter-terms-proposed", "evt-quotation-revised", "evt-counter-terms-declined"]
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-contraproposta", "term-rodada-de-negociacao", "term-condicoes-de-pagamento", "term-entregas-programadas"]
		}
		rationale: "O passo que as fontes chamam de 'arte' e apontam como o que salva o fluxo de caixa. No exame original (2026-07-12) era o vazio mais denso em valor da story — zero elementos em qualquer BC; FECHADO em 2026-07-28 pelo WI-161: rodadas de contraproposta→revisão|recusa intra-open (3 commands + 3 events internal, molde dos fatos de cotação — confidencialidade preservada), condições de pagamento e entregas programadas ESTRUTURADAS (vo-payment-terms/vo-delivery-schedule), e a regra de ouro inv-negotiated-terms-materialize-on-quotation: só a revisão do fornecedor materializa condições na cotação — o gate de procedência do adr-177 resolve o preço FINAL na cotação vencedora por construção ('as condições finais que a decisão formaliza'). A mesa da negociação é o próprio mapa (prj/qry-quotation-map, agora com as rodadas), refs deste passo. Revisão de 2026-09-03: o alvo de contraproposta é preparado pelo agente (act-prepare-counter-proposal, propose-and-wait) e EMITIDO pelo comprador — quem invoca cmd-propose-counter-terms segue sendo sh-08. Revisão de 2026-09-07: os refs MUDARAM. A negociação é BILATERAL por construção, e este passo narra um lado só. cmd-revise-quotation e cmd-decline-counter-terms são atos do FORNECEDOR — o domain-model os declara literalmente ('Fornecedor revisa a própria cotação… supplierRef deve match'; 'Fornecedor declina a contraproposta e mantém as condições vigentes'), e a inv-negotiated-terms-materialize-on-quotation faz disso lei estrutural: 'a cotação é do fornecedor; o comprador nunca escreve nela… nenhum caminho de escrita do comprador alcança a ent-quotation'. Mantê-los aqui atribuía a sh-08 comandos que o modelo IMPEDE sh-08 de invocar. Saíram para a ds-supplier-network-journey, passos 7 e 8, escritos no MESMO commit — refs não se movem em dois tempos: tirar de um lado e pôr no outro é uma operação só, mesmo quando o trabalho que a produziu teve etapas. Os eventRefs PERMANECEM os três, e a distinção é deliberada: aqui eles são fatos que o passo CONSOME, não produz. O comprador lê no mapa o desfecho da rodada — a fila dele 'distingue manteve de aguardando' (rationale do cmd-decline-counter-terms) —, e tirar os eventos tiraria o que ele lê. O schema #StoryStep tem UM actorRef e nenhum campo de contraparte, então a bilateralidade não cabe dentro do passo: ela vive na aresta entre as duas stories, declarada aqui e no espelho. Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): o ator passa a ser a Mesh (sh-05): preparar, enviar, acompanhar e cobrar rodadas é trabalho operacional, e a compradora não clica 'enviar' para transportar uma decisão que já tomou. As frases acima de que 'quem invoca cmd-propose-counter-terms segue sendo sh-08' e de que 'o comprador lê no mapa o desfecho da rodada' ficam como proveniência das revisões anteriores; vale agora que quem invoca e lê é a Mesh, e que a compradora entra só para o trade-off que a regra não decide. O limite futuro da autonomia negocial da Mesh não é decidido aqui."
	}, {
		actorRef: "sh-08"
		action:   "A compradora recebe a compra preparada: o resultado que a Mesh já resolveu e verificou, só as decisões que dependem dela — riscos que pedem julgamento, linhas que precisam de destino, exceções — e a evidência disponível para inspecionar quando quiser, inclusive o mapa de cotações, se quiser comparar por conta própria. Decide o que lhe cabe e ratifica o conjunto; a ratificação registra a decisão de sourcing — a proposta ratificada ou a escolha própria, com o motivo — e a cotação se conclui."
		workItem: {
			description:       "Apresentar a compra preparada com as decisões pendentes e a evidência, e formalizar a decisão de sourcing como consequência da ratificação, com rationale de decisão registrado."
			boundedContextRef: "ssc"
			commandRefs: ["cmd-make-one-shot-sourcing-decision"]
			eventRefs: ["evt-sourcing-decision-made", "evt-rfq-concluded"]
			readModelRefs: ["prj-quotation-map"]
			queryRefs: ["qry-quotation-map"]
			termRefs: ["term-sourcing-decision", "term-one-shot-sourcing-decision", "term-decision-rationale", "term-mapa-de-cotacoes", "term-equalizacao-tco"]
		}
		rationale: "A decisão formal EXISTE no modelo (sourcing decision, ssc) — este passo carrega a metade ssc do antigo passo 9. Revisão de 2026-09-03: o antigo passo 9 colapsava DOIS atos de atores distintos — a decisão de sourcing (ssc, ato do PREPARADOR) e a aprovação por Alçada (p2p, ato do APROVADOR) — e citava nos refs o comando da primeira sob o ator da segunda. O WI-157 (def-076 resolved) separou os papéis e o stakeholder-map descreve sh-09 como quem 'revisa a compra preparada pelo comprador e APROVA por Alçada'; os refs do passo não refletiam a separação. O desmembramento a materializa: adr-174 decisão 1 já ordenava 'cotação/decisão de sourcing no ssc → APROVAÇÃO com Gate de Cobertura' como estágios distintos. A atribuição do comando a sh-08 é inferência ratificada pelo founder (2026-09-03): o repositório não nomeia o invocador literalmente, e a leitura alternativa colapsaria a separação preparador×aprovador. Lacuna registrada: o campo decidedBy de cmd-make-one-shot-sourcing-decision é string nominal e NÃO distingue 'ratificou a proposta do agente' de 'escolheu por conta própria' — quando der errado, a auditoria não responde quem errou. Mesma forma estrutural que o def-080 já defere para #Command. Revisão de 2026-09-07 (fatia 0, cobertura derivada): o passo DECIDIA sourcing sem referenciar o mapa sobre o qual a decisão se faz — prj-quotation-map/qry-quotation-map existem no ssc e eram citados nos passos 7, 8 e 9, não aqui. Achado por derivação estrutural (arquétipo do passo: escrevia sem ler), não por leitura. Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): o antigo passo 8 (o comprador lia a proposta material a material e comparava ele mesmo) foi fundido aqui: ler item a item o que a Mesh já resolveu e verificou deixou de ser obrigação, e a comparação própria virou inspeção opcional sobre o mesmo mapa. A ratificação é o gesto humano desta story, e o registro da decisão de sourcing passa a ser consequência dela, não um segundo ato. A lacuna do decidedBy fica mais aguda, não menor: a ratificação do conjunto e a escolha própria numa linha continuam indistinguíveis no comando. Destino de linha sem proposta viável não tem elemento no modelo; a story o narra como decisão da compradora e a lacuna fica registrada fora daqui."
	}, {
		actorRef: "sh-09"
		action:   "O gestor recebe a compra ratificada com a cobertura orçamentária, a Alçada e a procedência de preço já provadas pela Mesh, e a alternativa que foi preterida; aprova ou recusa com motivo, garantindo alinhamento com o planejamento estratégico e financeiro da construtora."
		workItem: {
			description:       "Aprovar a requisição triada sob o portão DUPLO pré-pedido: reserva de cobertura confirmada pelo Gate de Cobertura do bdg (Saldo Disponível + Alçada) e procedência de preço verificada contra a cotação vencedora do ssc."
			boundedContextRef: "p2p"
			commandRefs: ["cmd-approve-purchase"]
			eventRefs: ["evt-purchase-approved", "evt-purchase-approval-rejected"]
			readModelRefs: ["prj-pending-requisitions"]
			queryRefs: ["qry-pending-requisitions"]
			termRefs: ["term-aprovar-compra", "term-compra-aprovada", "term-aprovacao-de-compra-recusada", "term-sourcing-authority"]
		}
		rationale: "O portão MECÂNICO de alçada pré-pedido agora existe (2026-07-12, adr-174/WI-151): cmd-approve-purchase invoca o Gate de Cobertura do bdg (Saldo Disponível + Alçada) na aprovação da requisição, pré-pedido — a divergência de ordem do exame original ('a aprovação do bdg dispara noutro momento') morreu. A separação preparador×aprovador FECHOU em 2026-07-29 pelo WI-157 (def-076 resolved): sh-09 gestor-aprovador é o actorRef deste passo; a operacionalização do papel na borda (quem PODE aprovar) é o desenho de identidade do WI-158. Revisão de 2026-09-03: o passo referenciava nos refs o comando da decisão de sourcing (ssc) sob o ator da aprovação; passa a referenciar o comando REAL do gate, cmd-approve-purchase (p2p), com os dois desfechos do selector de adr-160 (approve/reject). A aprovação NÃO é condicional a limiar: adr-174 decisão 1 põe 'Alçada e saldo são PRÉ-CONDIÇÃO da emissão' e o lifecycle não tem outra rota de triaged→approved — a Alçada é avaliada DENTRO do Gate de Cobertura, não é condição para o passo acontecer. A 'alternativa preterida' que o gestor lê vive na decisão de sourcing (vo-tradeoff, vo-decision-rationale do ssc), não no ato de aprovar — é referência entre agregados, não campo do comando. Revisão de 2026-09-07 (fatia 0): o passo APROVAVA sem referenciar a fila que o gestor lê — o próprio prj-pending-requisitions declara sustentar 'a fila de trabalho do comprador (triagem) e do gestor (aprovação)', e a qry-pending-requisitions lista o gestor entre os consumers. A alternativa preterida segue SEM ref possível, e a razão é estrutural: ela vive no ssc e as refs de passo resolvem só contra o BC do próprio passo (adr-169) — leitura narrada que a forma não comporta. Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): o gestor deixa de revisar o que o portão duplo já prova: o que fica com ele é a autoridade financeira, o de-acordo. Se a aprovação vale sempre ou só quando a compra excede a alçada de quem ratifica não é decidido aqui; o passo preserva o modelo vigente."
	}, {
		actorRef: "sh-05"
		action:   "Aprovada a compra, a Mesh emite o pedido de compra sob a autoridade da decisão de sourcing e o transmite ao fornecedor, com prazo hábil para a entrega não interromper o cronograma (solicitação de quinta, entrega programada para segunda)."
		workItem: {
			description:       "Emitir o pedido de compra sob a authority da decisão de sourcing e publicá-lo ao fornecedor."
			boundedContextRef: "p2p"
			commandRefs: ["cmd-emit-purchase-order"]
			eventRefs: ["evt-purchase-order-emitted", "evt-purchase-requisition-converted"]
			policyRefs: ["pol-purchase-order-converts-requisition"]
			readModelRefs: ["prj-purchase-orders"]
			termRefs: ["term-purchase-order", "term-sourcing-authority"]
		}
		rationale: "O desfecho do recorte, com lar completo (emissão sob authority validada) — e a fronteira da dobra cunha→core: evt-purchase-order-emitted é o que o cmt consome para iniciar o compromisso, fora deste recorte. Revisão de 2026-09-07 (fatia 0): o fecho do ciclo entrou — pol-purchase-order-converts-requisition dispara em evt-purchase-order-emitted, emite cmd-convert-requisition e a requisição vai de approved a converted (evt-purchase-requisition-converted). Achado por derivação (policy do BC disparada por evento que o passo declara), e é o PRIMEIRO policyRefs preenchido em qualquer story: o sc-ds-06 deixa de ser vacuamente verde. Revisão de 2026-10-05 (decisão de produto: a Mesh conduz a operação; o humano entra só onde informação, julgamento, autoridade ou exceção exigem): converter, copiar e enviar o que já está determinado não é razão para a compradora estar aqui: com decisão e autoridade válidas, emitir e transmitir é trabalho da Mesh (sh-05). As refs não mudam."
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

		REGRA DO ATO DO FORNECEDOR (2026-09-07, fatia 0): um ato de sh-02
		aparece NESTA story quando é INSUMO do arco do comprador — a
		submissão da cotação (passo 6) é o que faz existir o mapa que ele
		compara — e vive SÓ na ds-supplier-network-journey quando é RESPOSTA
		dentro da rodada de negociação. É por isso que cmd-submit-quotation
		está nas duas stories e cmd-revise-quotation/cmd-decline-counter-terms
		saíram desta. A assimetria é deliberada e NENHUM GATE A ENXERGA: o
		sc-ds-04 confere que a ref resolve, e ela resolve dos dois lados.
		Consequência medida: a derivação de arestas por interseção de evento
		produz um par com sh-02 dos DOIS lados em evt-quotation-submitted —
		aresta aparente, que esta regra explica e que a story do fornecedor
		já declarava como A2 sem lado comprador.

		Revisão de 2026-10-05: a story deixa de narrar a compradora como
		operadora do procurement assistida pela Mesh e passa a narrar a Mesh
		conduzindo a operação. Triagem mecânica, pool, abertura e condução da
		cotação, análise, negociação operacional e emissão do pedido passam a
		sh-05; o humano permanece onde há informação só dele (passos 1-2),
		julgamento econômico (trade-off na negociação, decisões da compra
		preparada), autoridade (ratificação no passo 10, aprovação no 11) e
		exceção (rejeição na triagem, pool insuficiente, qualificação). O
		antigo passo 8 fundiu-se no 10; o novo passo 7 declara a condução da
		janela de cotação, que antes não tinha dono. A numeração dos passos
		1-6 e 9-12 foi preservada para não envelhecer as citações externas.
		Esta revisão declara a experiência decidida; os artefatos que ainda
		descrevem o comportamento anterior (autonomia dos agentes, textos de
		comandos e do mapa de stakeholders) não foram adaptados nela.
		"""
}
