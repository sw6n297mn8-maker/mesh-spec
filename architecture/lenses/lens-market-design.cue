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
}
