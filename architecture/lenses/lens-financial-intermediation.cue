package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

financialIntermediation: artifact_schemas.#AnalyticalLens & {
	id:      "lens-financial-intermediation"
	name:    "Intermediação Financeira"
	purpose: "Analisar como a Mesh financia antecipações, estrutura veículos e funding, transforma maturidade e risco, administra liquidez, subordinação, covenants e continuidade de funding em cada estágio de escala."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve de onde vem o dinheiro para antecipar recebíveis",
			"a decisão envolve estrutura de funding (capital próprio, FIDC, parceiro bancário, warehouse)",
			"a decisão envolve descasamento de prazos entre captação e aplicação",
			"a decisão envolve capacidade de atender demanda de antecipação",
			"a decisão envolve o que acontece se muitos fornecedores pedem antecipação ao mesmo tempo",
			"a decisão envolve priorização de quem antecipa quando liquidez é escassa",
			"a decisão envolve o papel da Mesh como intermediário entre quem tem dinheiro e quem precisa",
			"a decisão envolve estruturação societária ou veículos para operação de crédito",
			"a decisão envolve subordinação, credit enhancement ou estruturação de FIDC",
			"a decisão envolve cessão de recebíveis para veículo de securitização",
			"a decisão envolve elegibilidade de recebíveis ou covenants de carteira",
			"a decisão envolve run risk, capacidade de rolagem ou continuidade de funding",
			"a decisão envolve custo real de capital e viabilidade econômica da operação",
		]
		keywords: [
			"funding", "liquidez", "FIDC", "cota", "subordinação",
			"warehouse", "capital", "captação", "maturity mismatch",
			"descasamento", "run risk", "corrida", "resgate",
			"priorização", "fila", "capacidade", "alocação de capital",
			"SCD", "estrutura societária", "veículo", "SPE",
			"custo de capital", "WACC", "linha de crédito",
			"elegibilidade", "covenant", "amortização antecipada",
			"servicer", "commingling", "true sale", "first-loss",
			"cota sênior", "cota subordinada", "rating",
			"IOF", "IRRF", "tributação", "revolving", "warehouse line",
			"credit enhancement", "bankruptcy remoteness", "escrow",
		]
		excludeWhen: [
			"a decisão é sobre risco de default ou composição de carteira de crédito sem componente de liquidez ou funding — usar credit-risk",
			"a decisão é sobre design de incentivos ou regras de interação — usar mechanism-design",
			"a decisão é sobre licenciamento ou compliance regulatório sem componente de estruturação financeira — usar regulatory-strategy",
			"a decisão é sobre pricing de antecipação sem questão de funding ou liquidez — usar credit-risk e mechanism-design",
			"a decisão é sobre fronteira organizacional de build vs buy sem foco na estrutura financeira — usar theory-of-firm",
		]
		rationale: "A Mesh senta entre quem tem dinheiro e quem precisa dele. O problema não é apenas se o devedor paga ou não; é também se a Mesh consegue financiar a antecipação, em que veículo, com qual custo real, com qual subordinação, com qual risco de liquidez, com qual proteção jurídica e com qual resiliência quando o mercado seca. Sem esta lens, o agente desenha antecipação como se liquidez fosse infinita, funding fosse neutro e covenants fossem detalhe operacional."
	}

	concepts: [
		{
			id:                "fi-intermediation-role"
			name:              "O Papel do Intermediário Financeiro"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Um intermediário financeiro existe porque reduz custo de coordenação entre quem tem capital e quem precisa dele. Suas funções clássicas incluem monitoramento delegado, transformação de maturidade, transformação de risco e produção de informação. O spread remunera esse conjunto, não apenas o risco de crédito pontual."
			meshManifestation: "A Mesh monitora compradores e fornecedores com dados que investidores não veem diretamente, antecipa recebíveis curtos para transformar tempo e caixa, combina múltiplos ativos para diluir risco e produz informação proprietária via integração entre dinheiro e operação."
			meshImplication:   "A Mesh não pode ser tratada como simples software que conecta partes. Ela é intermediário financeiro de fato, com responsabilidades próprias de funding, liquidez, governança de veículos e credibilidade perante investidores e parceiros."
			rationale:         "Sem esse enquadramento, o agente subestima a profundidade econômica da operação."
		},
		{
			id:                "fi-regulatory-vehicle"
			name:              "Veículo Regulatório e Estrutura de Operação"
			nature:            "operational"
			role:              "framework"
			reviewCadence:     "annual"
			definition:        "A estrutura regulatória define o que a Mesh pode fazer, com que funding e em que sequência. SCD, FIDC, correspondente bancário, parceiro bancário e estruturas afins não são equivalentes; cada uma altera limites de funding, escopo operacional, lead time e custo de escala."
			meshManifestation: "No bootstrap, a Mesh pode operar com capital próprio via estrutura permitida e depois ceder créditos para FIDC para ganhar escala. A sequência regulatória importa porque o funding economicamente desejável pode depender de uma estrutura ainda não disponível."
			meshImplication:   "A sequência regulatória deve preceder a sequência financeira. Não faz sentido modelar escala via FIDC, warehouse ou estrutura híbrida sem ter mapeado o caminho legal e o lead time correspondente."
			dependsOn:         ["fi-intermediation-role"]
			rationale:         "A intermediação é moldada pelo que a estrutura regulatória permite."
		},
		{
			id:                "fi-funding-structure"
			name:              "Estrutura de Funding por Estágio"
			nature:            "operational"
			role:              "framework"
			reviewCadence:     "semi-annual"
			definition:        "Funding não é monolítico. Capital próprio, warehouse, FIDC aberto, FIDC fechado, parceiro bancário e estruturas mistas têm custos, capacidade, velocidade, optionality e riscos distintos. Cada estágio da Mesh tende a usar combinação diferente."
			meshManifestation: "Bootstrap tende a operar com capital próprio e capacidade limitada. Escala exige transição para estruturas com capital de terceiros. Funding mais barato geralmente vem com mais governança, mais covenants e menos flexibilidade."
			meshImplication:   "A Mesh deve pensar funding como sequência evolutiva, não como escolha única. A pergunta correta é: qual estrutura é adequada agora, qual vem depois, e qual lead time exige preparação antecipada?"
			dependsOn:         ["fi-regulatory-vehicle"]
			rationale:         "Sem sequência, a Mesh chega ao limite de capital sem ponte para a etapa seguinte."
		},
		{
			id:                "fi-fidc-structure"
			name:              "Estrutura do FIDC: Subordinação, Elegibilidade e Covenants"
			nature:            "operational"
			role:              "framework"
			reviewCadence:     "semi-annual"
			definition:        "O FIDC não é funding genérico; é veículo com regras próprias. Subordinação, critérios de elegibilidade, covenants, eventos de amortização e estrutura revolving ou amortizante definem custo, escala real e robustez do veículo."
			meshManifestation: "A Mesh pode originar recebíveis que, no papel, parecem bons para o negócio, mas que não entram no FIDC por prazo, concentração, tipo de lastro ou forma de confirmação. Mesmo quando entram, a subordinação exigida consome capital próprio relevante."
			meshImplication:   "A política de originação precisa nascer compatível com o veículo de funding. Recebível bom para a operação, mas inelegível para o FIDC, é ativo que consome capacidade errada. Covenant não é detalhe; é gatilho potencial de interrupção do funding."
			dependsOn:         ["fi-funding-structure"]
			rationale:         "O FIDC molda a carteira tanto quanto a carteira molda o FIDC."
		},
		{
			id:                "fi-true-sale-commingling"
			name:              "True Sale, Segregação Patrimonial e Commingling"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Para que o veículo seja robusto, os ativos precisam estar efetivamente segregados da Mesh, a cessão precisa ser economicamente e juridicamente defensável, e os fluxos precisam evitar mistura indevida entre caixa operacional e caixa do veículo."
			meshManifestation: "Se o recebível cedido ao FIDC ainda é disputável em insolvência da Mesh, ou se o dinheiro do comprador transita por contas operacionais antes de chegar ao veículo, o risco estrutural aumenta e a qualidade do funding piora."
			meshImplication:   "True sale, bankruptcy remoteness e mitigação de commingling devem ser tratados como fundação da estrutura, não como refinamento posterior. Sem isso, rating, custo e confiança do investidor degradam."
			dependsOn:         ["fi-fidc-structure", "fi-regulatory-vehicle"]
			rationale:         "Sem segregação jurídica e operacional, a intermediação fica estruturalmente frágil."
		},
		{
			id:                "fi-servicer-risk"
			name:              "Risco de Servicer e Continuidade Operacional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quem origina ou monitora a carteira pode também ser o servicer, mas isso cria risco operacional específico: se o servicer falha, a carteira e o funding sofrem mesmo sem deterioração intrínseca dos ativos."
			meshManifestation: "A Mesh pode ser excelente em originar e monitorar, mas ainda assim ser percebida como servicer mais frágil do que banco ou operador estabelecido. Para investidores, isso afeta confiança e custo."
			meshImplication:   "Servicer backup, documentação de processos, separação funcional e continuidade operacional precisam existir cedo. Em estruturas com FIDC, esse risco é parte do produto financeiro, não apenas da operação interna."
			dependsOn:         ["fi-intermediation-role", "fi-fidc-structure"]
			rationale:         "Funding de terceiros compra a carteira, mas também compra a capacidade da Mesh de servi-la."
		},
		{
			id:                "fi-maturity-transformation"
			name:              "Transformação de Maturidade e Maturity Mismatch"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A intermediação transforma prazos. Quando o funding vence, pode ser resgatado ou precisa ser rolado antes do vencimento econômico dos ativos, surge risco de maturity mismatch."
			meshManifestation: "Mesmo com recebíveis bons, a Mesh pode entrar em aperto se o funding é mais curto, mais instável ou mais sensível do que a maturidade média da carteira."
			meshImplication:   "Maturity gap precisa ser monitorado explicitamente. Estruturas de funding que parecem baratas podem carregar fragilidade excessiva se exigem rolagem frequente ou estão expostas a secas de mercado."
			dependsOn:         ["fi-funding-structure"]
			rationale:         "A clássica crise do intermediário não é só insolvência; é liquidez insuficiente no tempo errado."
		},
		{
			id:                "fi-liquidity-risk"
			name:              "Risco de Liquidez"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Risco de não conseguir atender saídas, nova demanda de antecipação ou obrigações do veículo, apesar de a carteira poder ser economicamente boa. Liquidez e crédito são riscos diferentes, com velocidades diferentes."
			meshManifestation: "A carteira pode estar saudável, mas a demanda por antecipação pode exceder caixa disponível. Ou o mercado pode fechar para novas séries, resgates ou warehouse exatamente quando a demanda aumenta."
			meshImplication:   "A Mesh precisa modelar buffer de liquidez, janelas de estresse, concentração temporal de vencimentos e política de escassez. Funding congelado por 30, 60 ou 90 dias precisa ser cenário padrão de análise."
			dependsOn:         ["fi-maturity-transformation", "fi-funding-structure"]
			rationale:         "Liquidez mata mais rápido do que crédito."
		},
		{
			id:                "fi-run-risk"
			name:              "Risco de Corrida"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Run risk é a materialização extrema da perda de confiança. Sua forma concreta depende do funding: resgates, não rolagem, impossibilidade de nova série, early termination, ou fuga de fornecedores e parceiros."
			meshManifestation: "Com equity puro, não há run clássico de funding, mas há run de usuários. Em FIDC aberto, há resgate. Em FIDC fechado, a corrida aparece como secura na próxima emissão. Em warehouse, pode aparecer como saída abrupta do financiador."
			meshImplication:   "A Mesh precisa mapear run risk específico por estágio e por fonte de funding. A mitigação correta muda conforme a estrutura: lock-up, diversificação, comunicação, protocolo de crise, pipeline alternativo, buffer e confiabilidade operacional."
			dependsOn:         ["fi-liquidity-risk"]
			rationale:         "Corrida é dinâmica de confiança, não apenas de números."
		},
		{
			id:                "fi-ramp-up-reinvestment"
			name:              "Ramp-Up, Reinvestimento e Utilização do Veículo"
			nature:            "operational"
			role:              "framework"
			reviewCadence:     "semi-annual"
			definition:        "Veículos de funding precisam de pipeline compatível. Originação lenta, sazonalidade ou quebra de pipeline geram ociosidade, que corrói retorno e pode consumir subordinação."
			meshManifestation: "Na construção civil, sazonalidade e ciclos de projeto afetam geração de recebíveis. Um fundo lançado no momento errado pode carregar caixa quando deveria carregar ativos."
			meshImplication:   "Dimensionar veículo pelo pipeline sustentável, não pelo pico narrativo. Medir utilização e não relaxar originação para 'encher o fundo'. Caixa ocioso prolongado é sintoma estrutural, não ruído operacional."
			dependsOn:         ["fi-fidc-structure", "fi-funding-structure"]
			rationale:         "Funding sem pipeline adequado destrói retorno e incentiva adverse selection."
		},
		{
			id:                "fi-delegated-monitoring"
			name:              "Monitoramento Delegado"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Investidores aceitam expor capital porque delegam ao intermediário a função de monitorar, detectar deterioração e reagir cedo. Se o monitoramento não for melhor que a outside option, a intermediação perde legitimidade econômica."
			meshManifestation: "A vantagem da Mesh está em monitorar com dados que combinam operação e dinheiro. Se isso não resultar em detecção mais cedo, melhor discriminação e menos surpresa, o diferencial econômico perante capital externo fica fraco."
			meshImplication:   "Monitoramento deve ser reportado como capability financiável: detecção precoce, estabilidade do modelo, fraude capturada, qualidade de servicing, integridade do lastro. Funding escalável depende de essa função ser visível e crível."
			dependsOn:         ["fi-intermediation-role"]
			rationale:         "Investidores compram capacidade de monitoramento, não só ativos."
		},
		{
			id:                "fi-cost-of-capital"
			name:              "Custo de Capital e Spread Mínimo Viável"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "O custo real de capital inclui muito mais do que o custo aparente da tranche sênior ou da linha de funding. Deve incorporar custo da subordinação, custos estruturais, custo de oportunidade do capital retido, tributos, atrito operacional e margem mínima de sustentabilidade."
			meshManifestation: "Um FIDC com cota sênior aparentemente barata pode continuar economicamente pesado para a Mesh quando se inclui junior retida, estrutura, IOF, tributos, servicing e equity presa."
			meshImplication:   "O spread mínimo viável precisa ser calculado de forma completa. Decisão de go/no-go sobre antecipação, segmento ou estrutura de funding não pode usar custo parcial. Se o spread mínimo real fica acima da outside option do cliente, o modelo não fecha naquele recorte."
			dependsOn:         ["fi-funding-structure", "fi-fidc-structure"]
			rationale:         "Subprecificar custo de capital é forma silenciosa de autossabotagem."
		},
		{
			id:                "fi-capital-allocation"
			name:              "Alocação de Capital: Operação, Reserva, Crescimento e Subordinação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Capital próprio da Mesh disputa quatro usos ao mesmo tempo: suportar operação direta, cobrir buffers e UL, financiar crescimento, e ser retido como first-loss em estruturas escaláveis. Esses usos não são intercambiáveis sem custo."
			meshManifestation: "Quando a Mesh avança para FIDC, parte do equity deixa de estar disponível para crescimento e passa a ficar presa em subordinação. Isso pode dar a ilusão de escala sem mostrar o custo real de capital comprometido."
			meshImplication:   "Planejamento de capital deve explicitar quanto fica em operação, quanto em reserva, quanto em growth e quanto em first-loss. Toda rodada ou planejamento de caixa precisa refletir isso com clareza."
			dependsOn:         ["fi-cost-of-capital", "fi-fidc-structure"]
			rationale:         "Capital escasso mal alocado compromete funding e execução ao mesmo tempo."
		},
		{
			id:                "fi-funding-fragility"
			name:              "Fragilidade de Funding e Sequência de Colapso"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O funding pode quebrar por encadeamento: incidente reputacional, covenant breach, pipeline insuficiente, deterioração de servicing, concentração excessiva ou fechamento de mercado. O colapso raramente vem de um fator isolado."
			meshManifestation: "Uma fraude detectada tarde pode piorar confiança, aumentar spread da próxima série, reduzir capacidade, limitar atendimento de fornecedores, secar dados ativos e enfraquecer o core ao mesmo tempo."
			meshImplication:   "A Mesh precisa mapear a sequência de unraveling do funding: o que quebra primeiro, com que velocidade, e qual mitigação existe em cada elo. Sem isso, o plano de funding parece robusto até o momento em que deixa de existir."
			dependsOn:         ["fi-run-risk", "fi-liquidity-risk", "fi-delegated-monitoring"]
			rationale:         "Funding quebra por cadeia, não apenas por evento único."
		},
		{
			id:                "fi-mesh-funding-map"
			name:              "Mapa de Funding da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "Artefato vivo que registra estrutura atual de funding, custo real por fonte, subordinação exigida, covenants, buffers, ramp-up, pipeline, run risks específicos, triggers de transição e fragilidades principais."
			meshManifestation: "O mapa mostra o estágio atual, a próxima estrutura alvo, o lead time para chegar nela, as dependências regulatórias, os thresholds de reavaliação e os pontos de quebra mais prováveis."
			meshImplication:   "Toda decisão desta lens deve atualizar o funding map. Sem isso, a organização perde memória institucional sobre por que escolheu determinado funding, o que a estrutura exige e quando a decisão precisa ser revista."
			dependsOn: [
				"fi-funding-structure",
				"fi-fidc-structure",
				"fi-cost-of-capital",
				"fi-capital-allocation",
				"fi-funding-fragility",
			]
			rationale: "Sem mapa vivo, a intermediação vira sequência de decisões isoladas sem coerência temporal."
		},
	]

	reasoningProtocol: [
		{
			question:  "Qual estrutura regulatória permite a operação atual e qual estrutura será necessária para a próxima fase de funding?"
			reveals:   "Define o espaço legal e a sequência temporal do funding."
			rationale: "A estrutura econômica só importa se a estrutura regulatória permitir."
		},
		{
			question:  "Qual é a fonte de funding atual, qual seu custo real, sua capacidade e sua fragilidade específica?"
			reveals:   "Distingue funding aparente de funding economicamente e operacionalmente sustentável."
			rationale: "Sem isso, a Mesh trata qualquer funding como equivalente."
		},
		{
			question:  "Se a próxima estrutura é FIDC ou semelhante, quais são subordinação, elegibilidade, covenants, eventos de amortização e requisitos de servicing?"
			reveals:   "Mostra a verdadeira constraint imposta pelo veículo."
			rationale: "O veículo define parte do comportamento ótimo da carteira."
		},
		{
			question:  "A estrutura garante segregação patrimonial, true sale e mitigação de commingling com qualidade suficiente para suportar custo de funding competitivo?"
			reveals:   "Avalia robustez jurídica da intermediação."
			rationale: "Funding barato exige segurança estrutural, não só narrativa."
		},
		{
			question:  "Qual é o spread mínimo viável com custo completo de capital, subordinação, estrutura, tributos, OpEx e margem?"
			reveals:   "Mostra se o produto fecha economicamente no segmento e estágio analisados."
			rationale: "Sem spread mínimo completo, a operação parece mais bonita do que é."
		},
		{
			question:  "Existe pipeline suficiente, previsível e compatível com a utilização do funding pretendido? Há sazonalidade ou ciclos de projeto que distorcem o pipeline?"
			reveals:   "Separa capacidade nominal de funding de capacidade real de usar o funding bem."
			rationale: "Funding sem pipeline adequado destrói retorno."
		},
		{
			question:  "Há maturity mismatch? O que acontece se o funding não rolar, atrasar ou encarecer antes de os ativos vencerem?"
			reveals:   "Torna visível o risco clássico do intermediário solvente porém ilíquido."
			rationale: "Transformação de maturidade sem mapear o gap é cegueira estrutural."
		},
		{
			question:  "Se a liquidez for escassa, quem antecipa primeiro e por quê? A política é consistente com o veículo, com os covenants e com a sustentabilidade da rede?"
			reveals:   "Impede improvisação sob escassez."
			rationale: "Liquidez apertada revela incoerência de política mais rápido do que crescimento normal."
		},
		{
			question:  "Qual é o run risk específico desta estrutura de funding? Como ele se manifesta na prática e quais mitigações já existem?"
			reveals:   "Traduz 'corrida' para a forma concreta do estágio atual."
			rationale: "Run risk muda de forma conforme o funding muda."
		},
		{
			question:  "Como o capital próprio está dividido entre operação, reserva, crescimento e subordinação? Essa alocação é consistente com o estágio?"
			reveals:   "Expõe trade-offs reais que a narrativa de escala costuma esconder."
			rationale: "Equity preso em first-loss não está disponível para tudo o mais."
		},
		{
			question:  "A Mesh prova, com dados, que seu monitoramento delegado é melhor que a outside option do investidor?"
			reveals:   "Conecta qualidade do monitoramento ao custo e continuidade do funding."
			rationale: "Funding escala quando a função de intermediação é confiável, não apenas quando o pitch é bom."
		},
		{
			question:  "Qual a sequência de fragilidade do funding? O que quebra primeiro, qual o segundo efeito, e qual mitigação existe em cada elo?"
			reveals:   "Mapeia o unraveling antes da crise."
			rationale: "Funding robusto é aquele cuja sequência de quebra já foi pensada antes."
		},
		{
			question:  "Qual trigger quantitativo reabre esta decisão? Escala, custo, spread, subordinação, utilization, covenant pressure, run indicator ou deterioração do monitoramento?"
			reveals:   "Transforma a decisão em política reavaliável."
			rationale: "Sem trigger, a estrutura envelhece até quebrar."
		},
	]

	meshExamples: [
		{
			id:       "ex-fidc-structuring"
			scenario: "A Mesh acumulou track record inicial e quer estruturar seu primeiro FIDC para sair da dependência exclusiva de capital próprio."
			analysis: "A pergunta não é apenas se o FIDC reduz custo da tranche sênior, mas se a estrutura completa fecha. Subordinação retida consome equity, custos estruturais comem spread, pipeline precisa ser sustentável, e elegibilidade pode excluir parte relevante dos recebíveis que o negócio gostaria de originar. Além disso, lançar cedo demais pode aprisionar capital em junior sem gerar capacidade econômica líquida suficiente."
			recommendation: "Dimensionar o primeiro FIDC de forma conservadora, compatível com o pipeline sustentável e com a capacidade da Mesh de reter subordinação sem asfixiar growth. Validar elegibilidade antes da originação, não depois. Construir o caso econômico com spread mínimo completo e não com custo parcial da tranche sênior."
			assumptions: [
				"há pipeline elegível suficiente para utilização estável do veículo",
				"a Mesh consegue reter a subordinação sem comprometer crescimento crítico",
				"os custos estruturais e tributários foram modelados integralmente",
			]
			principlesApplied: ["ax-03", "ax-04", "ax-05"]
			rationale: "FIDC bem estruturado escala; FIDC mal dimensionado só redistribui fragilidade."
		},
		{
			id:       "ex-covenant-pressure"
			scenario: "Um comprador excelente geraria volume adicional muito atrativo, mas sua entrada empurraria a concentração da carteira para perto do limite do veículo."
			analysis: "O ativo individual pode ser ótimo, mas a estrutura de funding pode não comportar sua entrada sem degradar o veículo. A decisão correta não depende apenas da qualidade do comprador, e sim do efeito marginal sobre concentração, covenants, flexibilidade futura e risco de amortização forçada."
			recommendation: "Não avaliar a operação apenas por retorno individual. Comparar alternativas: originar parcialmente, alocar fora do veículo, criar série ou funding dedicado, ou crescer a base antes de absorver esse volume. O veículo é constraint de primeira ordem."
			assumptions: [
				"o covenant realmente se aproxima do ponto de violação",
				"há alternativas operacionais fora do veículo ou via funding complementar",
			]
			principlesApplied: ["ax-05", "dp-05", "dp-08"]
			rationale: "Violação estrutural por bom ativo individual continua sendo má decisão de funding."
		},
		{
			id:       "ex-public-fraud-incident"
			scenario: "Uma fraude detectada em recebível vira notícia pública e a Mesh precisa avaliar o impacto no funding atual e futuro."
			analysis: "A perda econômica direta pode ser pequena, mas o dano potencial está no canal de confiança. O investidor não reage apenas à perda; reage à percepção sobre a qualidade do monitoramento delegado, do servicing e do controle estrutural do veículo. Dependendo do estágio, a corrida aparece como resgate, não rolagem, spread maior na próxima série ou fuga de usuários."
			recommendation: "Responder por canal de funding. Explicar materialidade, impacto econômico real, o que o controle detectou, o que foi corrigido e por que o caso prova a capacidade de monitoramento em vez de negá-la. Comunicar cedo e com dados. Tratar o incidente como evento de funding, não apenas de fraude."
			assumptions: [
				"a fraude foi detectada pelo monitoramento da Mesh e não por terceiro",
				"a materialidade econômica direta é baixa em relação ao patrimônio do veículo",
			]
			principlesApplied: ["ax-05", "dp-05"]
			rationale: "Na intermediação, incidente reputacional é também incidente de liquidez futura."
		},
	]

	principleIds: ["ax-03", "ax-04", "ax-05", "ax-07", "dp-05", "dp-08"]

	relatedLenses: [
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "Credit-risk avalia perda esperada, concentração e risco de default. Financial-intermediation avalia funding, liquidez, subordinação, custo de capital e continuidade da estrutura que carrega essa carteira."
		},
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Mechanism-design desenha regras de priorização, elegibilidade operacional e alocação em escassez. Financial-intermediation define as constraints reais de funding dentro das quais essas regras precisam operar."
		},
		{
			lensId:   "lens-regulatory-strategy"
			relation: "complementsWith"
			context:  "Regulatory-strategy define o que a Mesh pode estruturar e em que sequência. Financial-intermediation decide qual estrutura é economicamente correta dentro desse espaço regulatório."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "Run risk, confiança de investidores e reação a incidentes têm forte componente comportamental. Financial-intermediation modela a fragilidade estrutural; behavioral-economics modela a dinâmica de confiança."
		},
		{
			lensId:   "lens-information-economics"
			relation: "feedsInto"
			context:  "A força do monitoramento delegado depende da qualidade, exclusividade e utilidade da informação gerada pela Mesh. Information-economics ajuda a provar que esse monitoramento merece funding mais barato."
		},
		{
			lensId:   "lens-theory-of-firm"
			relation: "complementsWith"
			context:  "Decisões como BaaS vs estrutura própria, servicer backup, administração fiduciária e infraestrutura de fluxo passam por theory-of-firm. Financial-intermediation avalia a estrutura econômica e de liquidez resultante."
		},
	]

	limitations: [
		{
			description: "A lens é calibrada para a realidade brasileira de antecipação, SCD, cessão e FIDC."
			alternative: "Ao expandir para outros produtos ou jurisdições, recalibrar veículos, impostos, funding sources e dinâmicas de mercado."
			rationale:   "A forma institucional da intermediação muda bastante por país e produto."
		},
		{
			description: "Ela não substitui credit-risk; assume que a carteira já está sendo avaliada por lens própria."
			alternative: "Usar em conjunto com credit-risk sempre que o funding depende da qualidade do ativo."
			rationale:   "Funding e crédito são dimensões distintas que se acoplam."
		},
		{
			description: "Mercados de funding podem mudar abruptamente e tornar premissas econômicas obsoletas em pouco tempo."
			alternative: "Usar funding map, triggers trimestrais e stress de liquidez com cenários de congelamento e encarecimento abrupto."
			rationale:   "Intermediação é altamente sensível a regime de mercado."
		},
		{
			description: "Uma estrutura elegante no papel pode falhar por servicing fraco, pipeline insuficiente ou má disciplina operacional."
			alternative: "Tratar servicing, ramp-up e monitoramento como parte do produto financeiro, não como execução secundária."
			rationale:   "Funding ruim muitas vezes nasce de operação ruim, não só de estrutura mal desenhada."
		},
	]

	rationale: "A Mesh é intermediário financeiro de fato, não apenas software com feature de antecipação. Isso exige pensar funding, liquidez, custo de capital, veículos, subordinação, maturity mismatch, run risk, servicing, pipeline e fragilidade estrutural como parte do core decisório. Credit-risk responde se a carteira é boa. Financial-intermediation responde se a Mesh consegue carregar essa carteira, em que estrutura, com qual custo real, com qual capital preso, sob quais covenants e com que robustez quando o mercado seca. Em uma empresa AI-native que quer ligar dinheiro e operação no mesmo plano, a qualidade da intermediação não é acessória: ela é a condição para transformar tese em loop econômico sustentável."
}
