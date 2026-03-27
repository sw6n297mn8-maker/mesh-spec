package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

marketDesign: artifact_schemas.#AnalyticalLens & {
	id:      "lens-market-design"
	name:    "Market Design"
	purpose: "Estruturar os mercados que a Mesh opera, definindo participação, timing, alocação, pricing, safety e sequenciamento. A lente analisa o mercado como sistema, não apenas incentivos individuais dentro de uma transação."
	status:  "active"

	trigger: {
		conditions: [
			"a decisão envolve como o mercado de antecipação de recebíveis é estruturado, incluindo quem pode participar, quando e como",
			"a decisão envolve como a taxa de antecipação é determinada e se o spread é justo",
			"a decisão envolve alocação de recurso escasso, incluindo funding limitado ou capacidade operacional",
			"a decisão envolve se o mercado é espesso o suficiente para funcionar",
			"a decisão envolve congestion, em que demanda por antecipação excede capacidade de processamento ou funding",
			"a decisão envolve timing de transações, incluindo batch versus contínuo, elegibilidade ou janelas",
			"a decisão envolve se participantes confiam o suficiente no mercado para participar honestamente",
			"a decisão envolve matching de fornecedores a compradores por capacidade, segmento ou região",
			"a decisão envolve por que o mercado não está funcionando apesar de participantes e regras existirem",
			"a decisão envolve se o custo all-in de participar na Mesh supera a outside option para algum segmento",
			"a decisão envolve o papel dual da Mesh como operadora e participante do mercado",
			"a decisão envolve lançar novo mercado, novo segmento, nova região ou novo produto",
			"a decisão envolve qual mercado ativar primeiro no bootstrap e como sequenciar",
		]
		keywords: [
			"mercado", "market", "marketplace",
			"price discovery", "preço", "taxa", "spread",
			"alocação", "allocation", "prioridade",
			"matching", "casamento", "pareamento",
			"espessura", "thickness", "liquidez de mercado",
			"congestion", "congestionamento", "fila",
			"clearing", "compensação", "settlement",
			"elegibilidade", "timing", "janela",
			"safety", "segurança de mercado", "participação",
			"repugnance", "rejeição", "aceitabilidade",
			"outside option", "alternativa", "banco",
			"market making", "intermediário", "arquitetura",
			"strategy-proof", "simplicidade",
			"sequenciamento", "bootstrap", "gatekeeper",
		]
		excludeWhen: [
			"a decisão é sobre design de incentivos individuais dentro de transação já estruturada; usar lens-mechanism-design",
			"a decisão é sobre efeitos de rede e crescimento de plataforma; usar lens-platform-dynamics",
			"a decisão é sobre risco de crédito de operações individuais; usar lens-credit-risk",
			"a decisão é sobre estrutura de funding ou veículo regulatório; usar lens-financial-intermediation",
			"a decisão é sobre topologia ou propagação na rede; usar lens-network-theory",
		]
		rationale: "A Mesh opera três mercados simultâneos e interdependentes: antecipação, supply chain e funding. Market design estrutura esses mercados: quem participa, quando, com que regras de clearing, como recursos escassos são alocados e por que o mercado pode falhar. Mechanism design desenha interações individuais dentro de mercados já estruturados; esta lente desenha a estrutura dos mercados em si."
	}

	concepts: [
		{
			id:                "md-market-making-architecture"
			name:              "Arquitetura de Market Making e Rendas Informacionais"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O mercado de antecipação da Mesh é estruturalmente um market making administrado: a Mesh controla a arquitetura do mercado, intermedia bilateralmente as transações e captura rendas pela posição arquitetônica de ver dados operacionais e financeiros ao mesmo tempo. Fornecedores não veem termos de outros fornecedores e investidores não interagem diretamente com fornecedores."
			meshManifestation: "A Mesh define a taxa de cada operação e aloca operações a tranches ou fontes de funding administrativamente. O spread é restringido por outside options de fornecedores e investidores, não por price discovery competitivo entre os lados."
			meshImplication:   "A Mesh não deve planejar transição para mercado competitivo puro de price discovery, mas sim compressão progressiva de rendas informacionais conforme dados se acumulam, infraestrutura amortiza e a plataforma ganha legitimidade. O spread justo deve ser decomposto em funding, operação, risco e renda informacional."
			rationale:         "Tratar esse mercado como exchange em formação gera recomendações erradas. O modelo correto é intermediário com rendas arquitetônicas."
		},
		{
			id:                "md-participation-constraints"
			name:              "Restrições de Participação e Composição de Mercado"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A restrição de participação não é homogênea: ela varia por tipo de participante, segmento, qualidade e outside option. O que importa não é só se um participante entra, mas se o conjunto que entra produz composição suficientemente boa e espessa para o mercado funcionar."
			meshManifestation: "Fornecedores pequenos sem crédito bancário aceitam condições diferentes de fornecedores Q1 com acesso bancário barato. Compradores especializados têm outside option pior que compradores de commodities. Investidores exigem prêmio por iliquidez, novidade e risco institucional."
			meshImplication:   "Toda decisão de pricing, friction, timing e onboarding deve ser testada contra o mapa de outside options por segmento. Se o custo all-in excede a outside option do conjunto de participantes necessário para o mercado funcionar, o mercado falhará mesmo com boa mecânica interna."
			rationale:         "A composição do mercado depende da heterogeneidade de IR, não de uma média abstrata."
			dependsOn:         ["md-market-making-architecture"]
		},
		{
			id:                "md-market-thickness"
			name:              "Espessura de Mercado"
			nature:            "theoretical"
			role:              "property"
			definition:        "Um mercado só funciona bem quando é thick: participantes suficientes de ambos os lados, ativos no momento certo, para produzir matching e pricing adequados. Thickness é dinâmica, varia por tempo, composição, sazonalidade e mercado específico."
			meshManifestation: "O mercado de antecipação pode estar thin do lado de recebíveis elegíveis ou do lado de funding. O mercado de supply chain pode ser thick em uma categoria e thin em outra. O mercado de funding pode parecer amplo no papel e concentrado na prática."
			meshImplication:   "A Mesh deve medir thickness por mercado e por submercado, em vez de usar apenas métricas agregadas. Quando o mercado estiver thin, a intervenção correta é atrair o lado faltante ou ajustar timing, não sofisticar o mecanismo."
			rationale:         "Mecanismo bom em mercado thin continua produzindo resultado ruim."
			dependsOn:         ["md-participation-constraints"]
		},
		{
			id:                "md-market-safety"
			name:              "Safety e Aceitabilidade do Mercado"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Safety é a propriedade institucional de fazer participantes se sentirem seguros para participar honestamente e revelar informação útil. Sem safety, o mercado sofre fuga para informalidade, manipulação, participação parcial e repugnance."
			meshManifestation: "Fornecedor pode temer que seus dados sejam usados contra ele. Comprador pode desconfiar da qualificação da Mesh. Investidor pode desconfiar da honestidade da originação. Termos percebidos como predatórios podem gerar rejeição mesmo se forem economicamente defensáveis."
			meshImplication:   "Safety deve ser tratada como condição de contorno anterior à otimização. Regras transparentes, resolução de disputas, proteção contra enclosure e positioning adequado são parte do design de mercado, não cosmética."
			rationale:         "Mercado unsafe falha mesmo quando thickness e pricing parecem suficientes."
			dependsOn:         ["md-participation-constraints"]
		},
		{
			id:                "md-dual-role-governance"
			name:              "Governança do Papel Dual da Mesh"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A Mesh simultaneamente desenha regras, aloca operações e lucra com o mercado. Isso cria conflito estrutural: toda decisão de design tem implicação direta de receita. O mercado precisa de compromissos críveis para que participantes acreditem que a posição arquitetônica não será explorada de modo abusivo."
			meshManifestation: "Investidores podem temer alocação enviesada entre tranches. Fornecedores podem desconfiar de spreads persistentemente altos. Compradores sofisticados podem suspeitar de qualificação tendenciosa em favor do que monetiza mais."
			meshImplication:   "A Mesh deve implementar, progressivamente, transparência de critérios, auditabilidade de alocação, separação funcional entre scoring, pricing e allocation, benchmark externo e instâncias de supervisão compatíveis com a fase da empresa."
			rationale:         "Sem governança do papel dual, safety e funding se deterioram."
			dependsOn:         ["md-market-making-architecture", "md-market-safety"]
		},
		{
			id:                "md-congestion"
			name:              "Congestion e Gerenciamento de Capacidade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Congestion ocorre quando há participantes e demanda suficientes, mas capacidade de funding, operação ou supervisão é insuficiente para processar tudo no tempo necessário. Isso é diferente de thinning."
			meshManifestation: "Fim de mês pode gerar muitas solicitações elegíveis ao mesmo tempo. Funding ou supervisão do founder podem não acompanhar."
			meshImplication:   "A Mesh deve distinguir thinning de congestion. Quando houver congestion, precisa de política explícita de alocação e provisão antecipada de capacidade, em vez de degradar em FIFO ou improvisação."
			rationale:         "Mercado congested desperdiça valor e cria churn previsível."
			dependsOn:         ["md-market-thickness"]
		},
		{
			id:                "md-allocation-under-scarcity"
			name:              "Alocação sob Escassez"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quando funding ou capacidade são escassos, a escolha do mecanismo de alocação altera composição de carteira, fairness percebida, thickness futura e risco de unraveling. Market design analisa essas consequências sistêmicas."
			meshManifestation: "FIFO favorece corrida. Precificação por quem aceita mais spread piora composição. Alocação puramente por score pode excluir novos participantes e empobrecer thickness futura."
			meshImplication:   "A Mesh deve escolher alocação com base não apenas em eficiência de curto prazo, mas também em impacto sobre composição, retenção de bons participantes, onboarding de novos e estabilidade do mercado ao longo do tempo."
			rationale:         "Toda alocação resolve a escassez de hoje e molda o mercado de amanhã."
			dependsOn:         ["md-congestion"]
		},
		{
			id:                "md-pricing-regime"
			name:              "Regime de Precificação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Em market making administrado, pricing tem pelo menos três dimensões: nível do spread, diferenciação entre perfis e dinâmica ao longo do tempo. Cada uma responde a lógica distinta: outside options, adverse selection e compressão de rendas."
			meshManifestation: "Spread uniforme tende a expulsar melhores perfis. Spread muito alto sobre segmentos sensíveis rompe participação. Spread que não comprime com amadurecimento da plataforma gera percepção de enclosure."
			meshImplication:   "A Mesh deve decompor pricing nessas três dimensões e calibrá-las separadamente. A granularidade mínima deve preservar perfis desejáveis sem destruir simplicidade operacional."
			rationale:         "Misturar nível, diferenciação e dinâmica em um único debate sobre taxa produz decisões confusas."
			dependsOn:         ["md-market-making-architecture", "md-participation-constraints"]
		},
		{
			id:                "md-obvious-strategyproofness"
			name:              "Obvious Strategy-Proofness para Baixa Sofisticação"
			nature:            "theoretical"
			role:              "heuristic"
			definition:        "Mesmo mecanismos com bons incentivos abstratos falham quando participantes não conseguem entender, em poucos segundos, qual ação melhora seu resultado. Na Mesh, isso vale para fornecedores e também para compradores."
			meshManifestation: "Fornecedor entende semáforo e passos simples melhor do que score ponderado opaco. Comprador expressa demanda melhor em interface curta do que em intake muito complexo."
			meshImplication:   "A Mesh deve manter sofisticação interna e simplicidade externa. Interfaces e regras expostas aos participantes devem tornar a ação desejada óbvia sem exigir raciocínio contingente complexo."
			rationale:         "Mecanismo incompreensível é mecanismo inutilizável."
			dependsOn:         ["md-participation-constraints"]
		},
		{
			id:                "md-matching-market"
			name:              "Matching como Função do Mercado de Supply Chain"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O mercado de supply chain é, antes de tudo, um mercado de matching. Sua qualidade depende de thickness, informação e timing. Matching ruim pode ser problema de pouca oferta, intake ruim ou critério errado."
			meshManifestation: "Comprador pode precisar de fornecedor em região e categoria específicas. Mesmo com muitos fornecedores na base, matching pode falhar por critério errado, informação ruim ou momento inadequado."
			meshImplication:   "A Mesh deve medir taxa de match, satisfação pós-match e performance pós-match, distinguindo falhas de thickness, intake e ranking."
			rationale:         "Sem modelar matching como função de mercado separada, o mercado de supply chain fica subespecificado."
			dependsOn:         ["md-market-thickness"]
		},
		{
			id:                "md-timing-clearing"
			name:              "Timing de Mercado e Clearing"
			nature:            "theoretical"
			role:              "method"
			definition:        "Timing define quando transações podem ocorrer; clearing define como oferta e demanda são casadas. Contínuo prioriza velocidade, batch prioriza composição ou otimalidade. A escolha depende do mercado, do ticket e da urgência."
			meshManifestation: "Antecipação pequena e de baixo risco pode exigir fluxo contínuo para competir com banco. Operações grandes ou concentradas podem ser melhor tratadas em batch. Matching de supply chain pode tolerar clearing mais lento."
			meshImplication:   "A Mesh deve escolher timing e clearing por mercado e por faixa operacional, comunicando SLA explícito e comparando o atraso da própria plataforma com as outside options dos participantes."
			rationale:         "Velocidade pode ser proposta de valor central; batch pode ser necessário para preservar composição."
			dependsOn:         ["md-congestion", "md-allocation-under-scarcity"]
		},
		{
			id:                "md-market-failure-modes"
			name:              "Modos de Falha de Mercado"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Mercados podem falhar por thinning, congestion, unraveling, unsafe ou repugnance. Esses modos têm mecanismos diferentes e exigem respostas diferentes. Unraveling, em especial, pode vir tanto de vantagem de timing quanto de medo de escassez."
			meshManifestation: "Fim de mês pode gerar corrida por funding. Participantes podem revelar demanda cedo demais por medo de ficar sem acesso. Mercado pode parecer ter regras e participantes, mas ainda falhar por percepção de injustiça ou insegurança."
			meshImplication:   "A Mesh deve diagnosticar explicitamente o modo de falha antes de intervir. Safety é prioridade de contorno; thinning e congestion exigem respostas diferentes; unraveling exige distinguir sua causa."
			rationale:         "Sem diagnóstico do modo de falha, a correção tende a atacar o sintoma errado."
			dependsOn:         ["md-market-thickness", "md-congestion", "md-market-safety"]
		},
		{
			id:                "md-market-sequencing"
			name:              "Sequenciamento de Mercados no Bootstrap"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Como antecipação, supply chain e funding são interdependentes, quebrar a circularidade exige sequenciamento. Essa é uma decisão arquitetônica, de path dependence, sobre qual mercado atuar primeiro, qual subsidiar e qual deixar emergir depois."
			meshManifestation: "A empresa pode começar por hook financeiro, hook operacional ou hook de capital, dependendo de qual lado tem outside option pior e de qual recurso é mais acessível ao founder."
			meshImplication:   "A Mesh deve documentar explicitamente o mercado gatekeeper, as condições mínimas de thickness e o recurso seed necessário antes de lançar novo segmento, região ou produto."
			rationale:         "Sequenciamento errado pode travar um ecossistema inteiro antes mesmo de qualquer mecanismo individual ser testado."
			dependsOn:         ["md-market-thickness", "md-participation-constraints"]
		},
		{
			id:                "md-mesh-market-health"
			name:              "Saúde dos Mercados da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "A saúde dos mercados deve ser medida por mercado: antecipação, supply chain e funding. Isso inclui thickness, clearing, tempo, congestion, matching, concentração de funding e comparação do custo efetivo da Mesh com outside options por segmento."
			meshManifestation: "Um mercado pode parecer saudável no agregado e ainda assim estar thin em categorias críticas, congestionado no fim do mês ou perdendo Q1 para bancos."
			meshImplication:   "A Mesh deve manter dashboard por mercado e um mapa de outside options atualizado, usando esses sinais para distinguir gargalo de mercado, gargalo de mecanismo e gargalo inter-mercados."
			rationale:         "Sem métricas separadas por mercado, a empresa confunde sintomas locais com saúde sistêmica."
		},
	]

	reasoningProtocol: [
		{
			question:  "A participação é racional para os tipos de participante que a Mesh precisa atrair, considerando custo all-in e outside option real?"
			reveals:   "Mostra se a restrição de participação já está violada antes de qualquer refinamento de mecanismo."
			rationale: "Sem participação racional, o mercado falha na origem."
		},
		{
			question:  "Qual dos três mercados está em questão e o gargalo está nele ou em outro mercado interdependente?"
			reveals:   "Distingue o mercado sintoma do mercado causa."
			rationale: "Intervir no mercado errado desperdiça esforço e capital."
		},
		{
			question:  "O mercado está thick o suficiente, por lado e por timing?"
			reveals:   "Mostra se o problema é falta de participantes ativos no momento de clearing."
			rationale: "Thickness é pré-condição dinâmica de funcionamento."
		},
		{
			question:  "O mercado é safe e percebido como aceitável pelos participantes relevantes?"
			reveals:   "Mostra se a plataforma sofre de desconfiança, manipulação, repugnance ou conflito de legitimidade."
			rationale: "Safety é condição de contorno, não otimização tardia."
		},
		{
			question:  "Há congestion e, se houver, quais consequências de mercado a regra atual de alocação está produzindo?"
			reveals:   "Mostra se a regra atual piora composição, fairness, onboarding ou stability."
			rationale: "Escassez mal alocada degrada o mercado além da operação do dia."
		},
		{
			question:  "O regime de pricing está correto em nível, diferenciação e dinâmica?"
			reveals:   "Mostra se a Mesh está cobrando demais, diferenciando de menos ou comprimindo de forma insuficiente ao longo do tempo."
			rationale: "Pricing ruim pode destruir participação e legitimidade."
		},
		{
			question:  "As regras e interfaces expostas são obviously strategy-proof para os lados com menor sofisticação?"
			reveals:   "Mostra se o mercado é operacionalmente compreensível."
			rationale: "Mecanismo incompreensível falha na prática, mesmo sendo bom no abstrato."
		},
		{
			question:  "O timing e o clearing atuais estão calibrados para o valor central do mercado, velocidade ou composição?"
			reveals:   "Mostra se o desenho atual está sacrificando a dimensão errada."
			rationale: "Batch e contínuo resolvem problemas diferentes."
		},
		{
			question:  "Qual modo de falha está operando: thinning, congestion, unraveling, unsafe ou repugnance?"
			reveals:   "Distingue a falha dominante e evita remédio errado."
			rationale: "Cada modo de falha pede intervenção diferente."
		},
		{
			question:  "Uma intervenção neste mercado cria problema em outro mercado interdependente?"
			reveals:   "Mostra spillovers entre antecipação, supply chain e funding."
			rationale: "Os mercados são analiticamente separados, mas operacionalmente acoplados."
			appliesWhen: "a decisão altera pricing, timing, alocação ou matching"
		},
		{
			question:  "A decisão é fundacional, envolvendo bootstrap, novo segmento, nova região ou novo produto?"
			reveals:   "Mostra se a decisão é de sequenciamento arquitetônico e não apenas de operação corrente."
			rationale: "Sequenciamento é decisão de path dependence."
			appliesWhen: "lançamento ou expansão de mercado"
		},
	]

	meshExamples: [
		{
			id:                "ex-end-of-month-congestion"
			scenario:          "No fim do mês, a demanda por antecipação excede funding disponível de forma recorrente e parte dos fornecedores migra temporariamente para bancos."
			analysis:          "O mercado não está thin; ele está congestionado. A regra de alocação atual pode estar criando corrida, medo de escassez e piora de composição. O problema central é de alocação e provisão, não de falta total de participação."
			recommendation:    "Trocar alocação cega por regra que preserve composição, comunicar disponibilidade de funding, ajustar timing em batchs curtos no pico, reservar espaço para novos e provisionar funding adicional quando o padrão sazonal de congestion for previsível."
			principlesApplied: ["ax-05", "ax-07", "dp-02"]
			assumptions: [
				"há padrão recorrente e não evento isolado",
				"fornecedores têm outside option bancária real no período",
			]
			rationale: "O caso mostra congestion previsível com risco de unraveling e churn evitável."
		},
		{
			id:                "ex-participation-constraint-binding"
			scenario:          "Após alguns meses, fornecedores de melhor qualidade passam a sair da Mesh para bancos, mesmo sem reclamar de segurança ou produto."
			analysis:          "A restrição de participação está binding para um subsegmento com outside option forte. O problema não é safety, mas custo all-in efetivo maior do que a alternativa relevante."
			recommendation:    "Redesenhar pricing e friction especificamente para o subsegmento que a Mesh ainda deseja reter, testando se a compressão de renda informacional faz sentido econômico. Se não fizer, aceitar explicitamente que esse subsegmento não é target competitivo no momento."
			principlesApplied: ["ax-05", "ax-07", "dp-02"]
			assumptions: [
				"o churn é puxado por outside option melhor, não por desconfiança",
				"há dados suficientes para decompor custo all-in",
			]
			rationale: "O caso mostra que nem todo churn é problema de confiança; pode ser restrição econômica binding."
		},
		{
			id:                "ex-dual-role-investor-concern"
			scenario:          "Investidor questiona se a Mesh pode favorecer uma tranche mais lucrativa para si na alocação das melhores operações."
			analysis:          "O problema central é safety sob papel dual. O investidor não está questionando apenas retorno; está questionando legitimidade da arquitetura de alocação."
			recommendation:    "Implementar regra de alocação determinística e auditável, publicar critérios de composição por tranche, manter logs verificáveis e criar mecanismos crescentes de governança externa compatíveis com a fase da empresa."
			principlesApplied: ["ax-05", "dp-05", "dp-08"]
			assumptions: [
				"há múltiplas tranches ou pools com incentivos econômicos distintos",
				"a preocupação do investidor é racional e não meramente retórica",
			]
			rationale: "O caso mostra como o papel dual pode elevar custo de funding se a governança não for crível."
		},
	]

	principleIds: ["ax-05", "ax-06", "ax-07", "dp-02", "dp-05", "dp-08"]

	relatedLenses: [
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Mechanism design desenha incentivos e propriedades estratégicas de mecanismos individuais. Esta lente define a estrutura dos mercados, seus gargalos, regras de participação, timing, matching, pricing e sequenciamento."
		},
		{
			lensId:   "lens-information-economics"
			relation: "complementsWith"
			context:  "Information economics explica valor e efeito da assimetria informacional. Esta lente modela como a arquitetura do mercado cria, usa e eventualmente comprime rendas baseadas nessa assimetria."
		},
		{
			lensId:   "lens-platform-dynamics"
			relation: "complementsWith"
			context:  "Platform dynamics modela chicken-and-egg, massa crítica e crescimento agregado. Esta lente trata thickness, matching e sequenciamento como propriedades de mercado operável."
		},
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "Credit risk modela risco individual e de carteira. Esta lente modela como estrutura de alocação e participação afeta composição agregada do mercado e, por consequência, risco."
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "complementsWith"
			context:  "Financial intermediation trata veículo, funding e estrutura econômica. Esta lente trata o mercado de funding como mercado, incluindo thickness, safety e governança de alocação."
		},
		{
			lensId:   "lens-commons-collective-action"
			relation: "complementsWith"
			context:  "Commons and collective action ajuda a pensar funding e dados como recursos compartilhados sob congestion e governança. Esta lente traduz isso em estrutura de mercado."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "Behavioral economics ajuda a modelar bounded rationality, framing, fairness e repugnance. Esta lente usa isso para safety, OSP e aceitabilidade do mercado."
		},
		{
			lensId:   "lens-complex-adaptive-systems"
			relation: "complementsWith"
			context:  "Complex adaptive systems ajuda a explicar emergência, path dependence e unraveling. Esta lente ancora esses fenômenos em estrutura de mercado, regras de clearing e sequencing."
		},
	]

	limitations: [
		{
			description: "A decomposição em três mercados é ferramenta analítica; na prática, as interdependências podem dominar a dinâmica observada."
			alternative: "Usar a decomposição para diagnóstico, mas sempre verificar spillovers inter-mercados antes de intervir."
			rationale:   "Separação ajuda a pensar; acoplamento continua sendo real."
		},
		{
			description: "No bootstrap, mercados podem estar thin demais para justificar market design sofisticado."
			alternative: "Operar market making administrativo simples até que haja thickness mínima e usar esta lente principalmente para sequenciamento, restrição de participação e condições de lançamento."
			rationale:   "Mecanismo sofisticado em mercado muito thin gera overhead sem benefício."
		},
		{
			description: "Outside options mudam com concorrência, regulação e evolução do mercado."
			alternative: "Manter mapa de outside options atualizado periodicamente e usar churn por segmento como sinal de mudança na restrição binding."
			rationale:   "A restrição de participação é dinâmica."
		},
		{
			description: "O modelo de market making monopolista pressupõe que a Mesh ainda ocupa posição arquitetônica singular em seu nicho."
			alternative: "Monitorar entrada de concorrentes e, se houver fragmentação real, revisar a lente para cenário de multi-homing, competição de market structure e compressão exógena de renda."
			rationale:   "A forma de mercado muda se o monopólio arquitetônico deixa de valer."
		},
		{
			description: "Governança crível do papel dual tem custo operacional relevante, sobretudo no bootstrap."
			alternative: "Implementar compromissos por fases: transparência primeiro, auditabilidade depois, governança externa quando a escala justificar."
			rationale:   "Confiança institucional também é investimento."
		},
		{
			description: "Participantes de baixa sofisticação podem não responder bem a mecanismos complexos, mesmo quando os incentivos estão corretos."
			alternative: "Manter complexidade dentro da Mesh e simplificar radicalmente a interface e a regra percebida pelos participantes."
			rationale:   "OSP é requisito operacional, não detalhe de UX."
		},
	]

	rationale: "Market Design, na Mesh, trata dos mercados como sistemas interdependentes: antecipação, supply chain e funding. A lente parte do fato de que a Mesh ocupa posição arquitetônica de market maker administrado, com rendas informacionais restringidas por outside options e legitimidade percebida. A restrição de participação é anterior à espessura; thickness é pré-condição dinâmica; safety é condição de contorno institucional; congestion exige alocação com consequências sistêmicas; pricing precisa ser entendido em nível, diferenciação e dinâmica; matching é a função central do mercado de supply chain; e o sequenciamento de mercados no bootstrap é decisão fundacional, não operacional. A lente existe para impedir que a Mesh trate falhas de mercado como se fossem apenas problemas de mecanismo local, de risco individual ou de crescimento de plataforma."
}
