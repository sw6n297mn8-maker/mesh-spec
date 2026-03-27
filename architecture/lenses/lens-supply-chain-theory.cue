package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

supplyChainTheory: artifact_schemas.#AnalyticalLens & {
	id:      "lens-supply-chain-theory"
	name:    "Teoria de Supply Chain"
	purpose: "Modelar o substrato operacional da cadeia produtiva da construção civil, incluindo fluxo físico, informacional e financeiro. A lente traduz eventos operacionais em elegibilidade, risco, coordenação e valor para a Mesh."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve como a cadeia produtiva da construção civil funciona operacionalmente, incluindo pedido, entrega, medição e pagamento",
			"a decisão envolve visibilidade multi-tier, incluindo o que acontece além do fornecedor direto",
			"a decisão envolve como a performance operacional de um elo afeta outros elos",
			"a decisão envolve transmissão de risco operacional para risco financeiro",
			"a decisão envolve como variabilidade de demanda se amplifica na cadeia, incluindo bullwhip",
			"a decisão envolve classificação de materiais ou serviços por criticidade e risco de fornecimento",
			"a decisão envolve como a Mesh captura dados operacionais reais da cadeia",
			"a decisão envolve coordenação operacional entre compradores e fornecedores",
			"a decisão envolve sazonalidade, ciclo de obra ou dinâmica temporal da construção civil",
			"a decisão envolve supply chain finance e interação entre fluxo financeiro e fluxo físico",
			"a decisão envolve poder de barganha entre elos e como isso afeta comportamento na plataforma",
			"a decisão envolve se o fornecedor opera em regime formal, semi-informal ou informal",
			"a decisão envolve elegibilidade operacional de recebível, incluindo entrega real, contestação, escopo ou retenção",
			"a decisão envolve restrição física de material ou natureza contínua de serviço",
			"a decisão envolve faturamento por medição de avanço, boletim, versus entrega direta",
		]
		keywords: [
			"supply chain", "cadeia produtiva", "cadeia de suprimentos",
			"fornecedor", "comprador", "construtora",
			"entrega", "pedido", "lead time",
			"bullwhip", "amplificação", "variabilidade",
			"multi-tier", "sub-fornecedor", "tier 2",
			"logística", "transporte", "canteiro",
			"material", "concreto", "aço", "areia",
			"serviço", "mão de obra", "elétrica", "hidráulica",
			"obra", "projeto", "fase de obra",
			"sazonalidade", "chuvas", "ciclo",
			"supply chain finance", "SCF",
			"visibilidade", "rastreabilidade",
			"Kraljic", "criticidade", "risco de fornecimento",
			"coordenação", "colaboração",
			"informalidade", "regime informal",
			"disputa", "escopo", "contestação",
			"perecível", "concreto usinado", "janela",
			"capacidade", "ociosidade",
			"medição", "boletim", "avanço físico",
			"retenção contratual", "retention",
		]
		excludeWhen: [
			"a decisão é sobre risco de crédito de operação individual; usar lens-credit-risk",
			"a decisão é sobre estrutura de FIDC ou funding; usar lens-financial-intermediation",
			"a decisão é sobre efeitos de rede e crescimento de plataforma; usar lens-platform-dynamics",
			"a decisão é sobre topologia de rede sem componente de fluxo operacional; usar lens-network-theory",
			"a decisão é sobre design de incentivos abstratos; usar lens-mechanism-design",
			"a decisão é sobre fronteira organizacional; usar lens-theory-of-firm",
			"a decisão é sobre termos contratuais específicos; usar lens-contract-theory",
		]
		rationale: "Supply chain theory modela o substrato operacional: fluxo físico, informacional e financeiro. Na construção civil, materiais e serviços são qualitativamente distintos em verificabilidade, disputa, timing e elegibilidade. Sem essa lente, o agente trata a cadeia como caixa preta."
	}

	concepts: [
		{
			id:                "sc-construction-chain-anatomy"
			name:              "Anatomia da Cadeia: Materiais, Serviços e Dois Modelos de Faturamento"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A cadeia da construção civil é project-based, site-specific e multi-trade. Ela combina três fluxos: físico, informacional e financeiro. Há dois tipos de fornecimento qualitativamente distintos. Material tende a ser verificável por unidade, entregue pontualmente e faturado por entrega direta. Serviço tende a ser contínuo, executado in loco, mais subjetivo na verificação e faturado por medição de avanço. O boletim é o documento econômico central do serviço; a NF é consequência."
			meshManifestation: "Concreto pode seguir pedido, entrega, confirmação e NF. Instalação elétrica pode seguir contrato, execução por semanas, medição, aprovação de boletim, NF e pagamento. A Mesh normalmente vê a NF primeiro, mas o evento econômico relevante é anterior e mais objetivo em material do que em serviço."
			meshImplication:   "A Mesh deve classificar a transação como material ou serviço desde o início. Essa classificação muda elegibilidade, necessidade de confirmação, qualidade do dado, risco de dispute e leitura do payment gap."
			rationale:         "Tratar material e serviço como a mesma coisa subestima o risco de serviço e perde informação causal importante."
		},
		{
			id:                "sc-informality-regimes"
			name:              "Regimes de Informalidade e Risco Trabalhista"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Informalidade é regime operacional, não mero desvio pontual. Há pelo menos três regimes relevantes: formal, semi-informal e informal. Eles diferem em capturabilidade de dados, custo de conversão e risco jurídico. Em serviços com trabalhadores sem registro no canteiro, o risco trabalhista pode transmitir-se ao comprador e depois ao risco financeiro do sacado."
			meshManifestation: "Fornecedor semi-informal pode emitir NF genérica e ter passivos trabalhistas latentes. Um acidente de trabalhador não regularizado pode virar contingência contra a construtora."
			meshImplication:   "Regime deve ser classificado no onboarding e usado como variável de elegibilidade, captura de dados e risco de comprador. Formalização gradual pode expandir TAM e reduzir risco, mas tem custo real."
			rationale:         "Sem separar regimes, a Mesh mistura problema de captura de dados com problema jurídico-operacional."
			dependsOn:         ["sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-retention-and-progress-billing"
			name:              "Retenção Contratual e Progress Billing"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Dois mecanismos típicos da construção civil afetam diretamente o recebível. Primeiro, retenção contratual: parte do valor é retida até marcos futuros ou garantia. Segundo, faturamento por medição: o recebível de serviço nasce economicamente no boletim aprovado, não apenas na NF. Isso alonga o payment gap real."
			meshManifestation: "Um contrato com retenção de 5% pode gerar NF que não corresponde integralmente ao valor exigível no curto prazo. Em serviço, execução, medição, aprovação, NF e pagamento podem formar um ciclo muito maior do que o prazo contratual pós-NF sugere."
			meshImplication:   "Elegibilidade operacional deve descontar retenção e considerar se houve boletim aprovado. Scoring e produto devem medir payment gap desde execução ou medição, não só desde a NF."
			rationale:         "Sem essa distinção, a Mesh antecipa valor que não é exigível ou mede mal o prazo real de capital empatado."
			dependsOn:         ["sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-operational-financial-transmission"
			name:              "Transmissão Operacional-Financeira"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Eventos operacionais viram risco financeiro por caminhos causais específicos. A lente de crédito modela probabilidade; esta lente modela o mecanismo. Atrasos, defeitos, disputa de escopo, sazonalidade, capacidade excedida, falhas multi-tier e informalidade trabalhista podem se transformar em dilution, atraso, perda, suspensão de recebível ou deterioração do sacado."
			meshManifestation: "Uma disputa de escopo em serviço pode virar dilution. Um atraso de tier 2 pode parar entregas de tier 1. Excesso de capacidade comprometida pode gerar subcontratação e perda de qualidade."
			meshImplication:   "A Mesh deve capturar leading indicators operacionais por segmento e conectá-los explicitamente ao risco financeiro esperado."
			rationale:         "Sem mecanismo causal, a operação vira apenas dado histórico, não dado preditivo."
			dependsOn:         ["sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-scope-dispute"
			name:              "Disputa de Escopo e Dilution Endêmica"
			nature:            "theoretical"
			role:              "property"
			definition:        "Disputa de escopo é estrutural na construção civil, especialmente em serviços. A diferença entre NF emitida e valor efetivamente aceito ou pago tende a ser menor em material e maior em serviço, porque a medição de avanço e a qualidade executada são mais disputáveis do que contagem física de unidades."
			meshManifestation: "NF de material pode sofrer ajuste por quantidade ou qualidade objetiva. NF de serviço pode sofrer ajustes maiores por interpretação de escopo, medição ou aceite parcial."
			meshImplication:   "A Mesh deve estimar dilution separadamente por tipo, por par comprador-fornecedor e por segmento. O modelo deve recalibrar periodicamente esses priors e não assumir que serviço se comporta como material."
			rationale:         "Sem tratar dilution como endêmica e diferenciada por tipo, pricing e loss projection ficam estruturalmente errados."
			dependsOn:         ["sc-construction-chain-anatomy", "sc-operational-financial-transmission"]
		},
		{
			id:                "sc-material-constraints"
			name:              "Restrições Físicas de Material e Natureza Contínua de Serviço"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A cadeia combina classes operacionais distintas: material perecível, material durável-pesado, material durável-leve e serviço contínuo. Cada classe tem exigências diferentes de confirmação, janela de verificação, custo de captura e momento econômico relevante."
			meshManifestation: "Concreto pode exigir confirmação quase síncrona. Aço pode admitir validação assíncrona. Serviço contínuo não tem evento de descarga e depende de medição."
			meshImplication:   "A captura de dados e a lógica de elegibilidade devem variar por classe. O custo de captura deve ser proporcional ao valor do recebível e ao quadrante de criticidade."
			rationale:         "Uma única política de captura para todas as classes cria custo excessivo onde não precisa e risco excessivo onde não pode."
			dependsOn:         ["sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-bullwhip-construction"
			name:              "Bullwhip na Construção Civil"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A variabilidade de demanda se amplifica na cadeia e isso tende a ser mais intenso em construção por ser project-based, por ter fases, por operar com lead times variáveis e por ter informação fragmentada. O benchmark relevante é relativo ao segmento e à fase, não um limiar absoluto."
			meshManifestation: "Picos de demanda por concreto ou estrutura podem ser seguidos de quedas bruscas quando várias obras mudam de fase ao mesmo tempo."
			meshImplication:   "A Mesh deve medir variabilidade relativa, inferir fase com cautela quando não houver cronograma explícito e só ativar leituras mais fortes quando houver dados suficientes."
			rationale:         "Sem benchmark relativo, a plataforma confunde crescimento normal, concentração de fase e distorção real."
			dependsOn:         ["sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-kraljic-dynamic"
			name:              "Classificação Dinâmica por Criticidade e Risco"
			nature:            "theoretical"
			role:              "method"
			definition:        "A matriz de Kraljic separa itens por impacto e risco de fornecimento. Na Mesh, ela deve ser tratada como dinâmica e bidirecional: itens podem piorar para bottleneck e também normalizar de volta. Serviços especializados tendem a strategic ou bottleneck com mais frequência do que commodities materiais."
			meshManifestation: "Aço estrutural ou fundação especializada podem ficar críticos em períodos de restrição. Materiais commodity podem parecer bottleneck temporário e depois normalizar."
			meshImplication:   "A Mesh deve classificar itens no onboarding e monitorar sinais de reclassificação para ajustar scoring, matching e custo aceitável de captura."
			rationale:         "Tratamento estático da criticidade engana justamente quando a cadeia muda rápido."
			dependsOn:         ["sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-multi-tier-propagation"
			name:              "Propagação de Falha Multi-Tier"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A visibilidade da cadeia costuma parar em tier 1, mas falhas propagam-se além dele. Essa propagação tem velocidades e abrangências diferentes conforme o insumo ou serviço afetado."
			meshManifestation: "Atrasos simultâneos em vários fornecedores de argamassa podem sinalizar problema upstream em cimento. Problemas em aço podem aparecer mais devagar e afetar subconjuntos diferentes da obra."
			meshImplication:   "A Mesh deve usar proxies de propagação, tipificar velocidade provável por categoria e operar regras explícitas de escalada e desescalada quando sinais multi-tier surgirem."
			rationale:         "Sem tipificação de propagação, a operação responde tarde ou responde demais a ruído local."
			dependsOn:         ["sc-construction-chain-anatomy", "sc-kraljic-dynamic"]
		},
		{
			id:                "sc-power-asymmetry"
			name:              "Assimetria de Poder e Payment Gap"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Poder na cadeia aparece como capacidade de impor prazo real, retenção, timing de medição e aceite. O payment gap relevante é o real, não o contratual, e em serviço inclui o trecho entre execução e aprovação do boletim."
			meshManifestation: "Comprador pode aprovar medição com atraso, alongando o ciclo econômico do fornecedor sem mudar formalmente o prazo pós-NF."
			meshImplication:   "A Mesh deve medir payment gap por tipo, usar esse dado como variável primária de risco e monitorar se a própria antecipação gera moral hazard no comprador."
			rationale:         "Sem medir poder no fluxo real, a plataforma só observa contrato escrito e não a governança operacional de fato."
			dependsOn:         ["sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-scf-mechanism"
			name:              "Mecanismo de SCF: Valor do Dado × Custo de Captura × Criticidade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Supply chain finance reduz prêmio de risco quando a plataforma captura dados operacionais melhores. Mas o valor de cada dado depende de proximidade do evento físico, dificuldade de fabricar o sinal e custo de captura. O investimento correto depende também da criticidade do item ou serviço."
			meshManifestation: "NF existe e custa pouco capturar. Confirmação cruzada de entrega custa mais. Boletim validado em plataforma pode ser muito valioso para serviço estratégico."
			meshImplication:   "A Mesh deve investir primeiro em sinais com melhor razão entre valor informacional, custo de captura e relevância do item. Também deve diagnosticar explicitamente onde o loop SCF está quebrando."
			rationale:         "Nem todo dado operacional merece o mesmo investimento e nem todo SCF falho é problema de pricing."
			dependsOn:         ["sc-operational-financial-transmission", "sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-construction-seasonality"
			name:              "Sazonalidade e Ciclo de Obra"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Sazonalidade climática e ciclo de obra afetam segmentos de forma desigual. Fundação e estrutura sofrem mais com chuva do que acabamento interno. A plataforma precisa separar deterioração real de padrão sazonal esperado."
			meshManifestation: "Março chuvoso pode aumentar atraso em categorias externas sem significar piora estrutural da qualidade do fornecedor."
			meshImplication:   "Scoring e covenants devem usar baseline sazonal quando houver histórico suficiente e operar com maior incerteza antes disso."
			rationale:         "Sem baseline sazonal, a Mesh pune ruído estrutural como se fosse falha idiossincrática."
			dependsOn:         ["sc-construction-chain-anatomy", "sc-bullwhip-construction"]
		},
		{
			id:                "sc-coordination-operational"
			name:              "Coordenação Operacional via Plataforma"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Além de financiar, a Mesh pode coordenar melhor a cadeia ao dar visibilidade sobre fase inferida, capacidade observada e pipeline provável. Essa coordenação é distinta de efeito de rede abstrato: ela emerge de dados operacionais reais da cadeia."
			meshManifestation: "Fornecedor pode perceber concentração excessiva de capacidade em um segmento. Comprador pode perceber que a fase inferida do conjunto de obras sugere queda ou pico de demanda em certo insumo."
			meshImplication:   "A Mesh deve tratar coordenação como produto autônomo de valor, inclusive em single-player mode, e capturar dados que alimentem essa coordenação mesmo quando a antecipação ainda não acontece."
			rationale:         "Coordenação operacional gera retenção e moat mais estrutural do que simples intermediação financeira."
			dependsOn:         ["sc-construction-chain-anatomy", "sc-scf-mechanism"]
		},
		{
			id:                "sc-lead-time-variability"
			name:              "Lead Time, Variabilidade e Capacidade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Lead time, sua variabilidade e a relação entre volume e capacidade são determinantes centrais de risco operacional. Para material, o lead time costuma ser observável entre pedido e confirmação. Para serviço, a variabilidade da medição e do aceite tem papel análogo."
			meshManifestation: "Concreto pode mostrar saturação por janelas de entrega. Serviço pode mostrar variabilidade de medição e rejeição de boletim. Fornecedor pode operar perto do limite da sua capacidade física ou humana."
			meshImplication:   "A Mesh deve medir saturação, ociosidade, variabilidade e benchmark por segmento, usando proxies quando capacidade direta não estiver disponível."
			rationale:         "Capacidade é um leading indicator upstream que antecipa atrasos, disputa e deterioração."
			dependsOn:         ["sc-construction-chain-anatomy"]
		},
		{
			id:                "sc-mesh-supply-chain-health"
			name:              "Saúde da Cadeia, Cobertura de Dados e Bootstrap"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "A saúde da cadeia deve ser observada em três componentes: saúde operacional, cobertura de dados e fase de maturidade da captura. Nem toda métrica está online no bootstrap; parte da disciplina da Mesh é saber o que ainda não sabe e o que só pode operar por proxy."
			meshManifestation: "No início, a Mesh pode ter NF para todos, mas pouca confirmação cruzada, poucos pagamentos observados e quase nenhuma série histórica sazonal. À medida que a operação amadurece, payment gap, dilution, bullwhip e propagação tornam-se progressivamente online."
			meshImplication:   "O dashboard deve separar alertas online de alertas offline, marcar priors não calibrados, ativar métricas por fase e usar resolução explícita quando um alerta volta ao baseline."
			rationale:         "Misturar bootstrap e maturidade plena gera falsa precisão e erro operacional."
		},
	]
}
