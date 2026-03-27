package lenses

import "mesh-spec/architecture/artifact-schemas"

creditRisk: artifact_schemas.#AnalyticalLens & {
	id:      "lens-credit-risk"
	name:    "Risco de Crédito e Dinâmicas de Carteira"
	purpose: "Modelar a exposição econômica, jurídica e estatística criada por antecipação de recebíveis na Mesh, distinguindo risco individual, risco de carteira, risco correlacionado, risco de fraude, risco de diluição e risco regulatório. A lente trata antecipação como posição em carteira, não como transação isolada."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve antecipação de recebíveis ou qualquer forma de exposição financeira",
			"a decisão envolve como medir, precificar ou mitigar risco de default",
			"a decisão envolve composição, concentração ou saúde de uma carteira de crédito",
			"a decisão envolve como o sistema se comporta em cenário de estresse econômico",
			"a decisão envolve definir limites de exposição por participante, cadeia ou setor",
			"a decisão envolve calibração, validação ou monitoramento de modelos de risco",
			"a decisão envolve provisão para perdas, reserva de capital ou subordinação de FIDC",
			"a decisão envolve autenticidade ou legitimidade de recebíveis",
			"a decisão envolve estrutura jurídica de cessão ou antecipação",
		]
		keywords: [
			"default", "inadimplência", "risco de crédito", "exposição",
			"concentração", "carteira", "provisão", "perda",
			"stress test", "cenário de crise", "pro-ciclicalidade",
			"spread", "taxa de desconto", "custo de capital",
			"LGD", "PD", "EAD", "expected loss", "unexpected loss",
			"vintage", "safra", "recuperação", "RAROC",
			"diluição", "cessão", "coobrigação", "regresso",
			"fraude", "duplicata", "registradora", "FIDC",
			"cure rate", "roll rate", "atraso", "2.682",
		]
		excludeWhen: [
			"a decisão é sobre design de incentivos ou regras de interação sem exposição financeira — usar lens-mechanism-design",
			"a decisão é sobre estrutura informacional ou qualidade de sinais sem componente de risco de perda — usar lens-information-economics",
			"a decisão é sobre liquidez, funding ou maturity mismatch sem foco em default — usar lens-financial-intermediation",
			"a decisão é sobre compliance regulatório genérico sem componente de provisão ou capital — usar lens-regulatory-strategy",
		]
		rationale: "A Mesh antecipa recebíveis. Toda antecipação é exposição a crédito. Sem esta lente, o agente trata antecipação como transação isolada em vez de posição em carteira com risco individual, correlacionado, jurídico e sistêmico."
	}

	concepts: [
		{
			id:                "cr-default-definition"
			name:              "Definição Operacional de Default"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Default é evento binário que precisa de definição precisa para que PD, vintage, provisão, capital e stress testing tenham referente consistente. Variáveis da definição incluem dias de atraso, inclusão de reestruturação, tratamento de pagamento parcial e default técnico por covenant. Basileia usa 90 dias como referência; a Resolução 2.682 inicia provisão antes disso."
			meshManifestation: "Na construção civil brasileira, atraso de 15 a 60 dias pode ser endêmico e decorrer de gestão de caixa, não de insolvência. Tratar qualquer atraso como default infla PD; esperar apenas 90 dias para tudo pode atrasar intervenção."
			meshImplication:   "Usar definição em camadas: atraso monitorado a partir de 15 dias; inadimplência provável a partir de 60 dias para restringir novos limites; default formal a 90 dias para PD, provisão integral e recuperação. Para comparabilidade de safra, usar 90 dias como default formal. Para gestão, usar roll rates e buckets anteriores."
			rationale:         "Sem referente operacional de default, toda a cadeia PD → EL → provisão → capital fica semanticamente instável."
		},
		{
			id:                "cr-legal-structure"
			name:              "Estrutura Jurídica da Exposição"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A forma jurídica da antecipação determina quem é o devedor relevante, quantos devedores existem, o que conta como perda e como PD, LGD e EAD devem ser modeladas. As modalidades principais incluem cessão definitiva sem regresso, cessão com coobrigação do cedente e desconto de duplicata com responsabilidade solidária ou equivalente econômica."
			meshManifestation: "Na Mesh, a mesma interface de produto pode esconder estruturas de risco radicalmente diferentes. Em cessão definitiva, o risco principal é do comprador. Em coobrigação, o fornecedor volta para dentro da equação de perda. Em desconto ou estrutura economicamente equivalente, a robustez do regresso muda pricing, limite e capital."
			meshImplication:   "Definir estrutura jurídica antes de modelar risco. Se cessão definitiva, modelar risco primário no comprador. Se há regresso ou coobrigação, modelar probabilidade conjunta de perda e taxa efetiva de recuperação via fornecedor. Registro em registradora deve ser tratado como parte da estrutura, não detalhe operacional."
			rationale:         "A estrutura jurídica define a ontologia do risco. Sem ela, o modelo mira no ator errado."
		},
		{
			id:                "cr-probability-of-default"
			name:              "Probabilidade de Default (PD)"
			nature:            "theoretical"
			role:              "framework"
			definition:        "PD é a probabilidade de que a obrigação atinja a definição operacional de default no horizonte relevante. Deve ser pensada por horizonte, por estrutura jurídica e por regime de informação. PD point-in-time captura condição corrente; PD through-the-cycle captura média ao longo de ciclo econômico. Quando há coobrigação, a perda depende da combinação entre default do comprador e efetividade do regresso sobre o fornecedor."
			meshManifestation: "Na Mesh, o comprador costuma ser o devedor primário do recebível, mesmo quando o fornecedor é o usuário do produto. A vantagem da Mesh está em usar dados operacionais como leading indicators de deterioração antes de atraso formal de pagamento."
			meshImplication:   "Priorizar modelo de PD do comprador. Quando houver coobrigação, modelar explicitamente a taxa de recuperação por regresso ou a probabilidade conjunta de perda. No bootstrap, usar bureau externo e sinais públicos como âncora TTC e overlays PIT com dados operacionais da Mesh conforme forem surgindo."
			dependsOn:         ["cr-default-definition", "cr-legal-structure"]
			rationale:         "PD é o input primário de risco, mas depende de quem é o devedor econômico e do horizonte relevante."
		},
		{
			id:                "cr-maturity-adjustment"
			name:              "Maturidade e Estrutura Temporal do Risco"
			nature:            "theoretical"
			role:              "property"
			definition:        "Recebíveis de prazos diferentes carregam riscos diferentes porque acumulam tempo para deterioração do devedor, disputa, mudança macro e erro de previsão. O horizonte até vencimento ou liquidação altera PD efetiva, spread e capital."
			meshManifestation: "Na construção civil, materiais, equipamentos e serviços podem ter janelas de pagamento muito distintas. O risco de um recebível de 30 dias é estruturalmente diferente do risco de um recebível de 120 dias, mesmo para o mesmo comprador."
			meshImplication:   "Precificar por bucket de maturidade e monitorar mix de prazos na carteira. Quando safras recentes concentram recebíveis mais longos, o risco agregado sobe ainda que a composição por nome aparente estabilidade."
			dependsOn:         ["cr-probability-of-default"]
			rationale:         "Tratamento uniforme de maturidade subprecifica prazo longo e distorce carteira."
		},
		{
			id:                "cr-loss-given-default"
			name:              "Perda Dado Default (LGD)"
			nature:            "theoretical"
			role:              "framework"
			definition:        "LGD é a fração da exposição perdida quando default ocorre. Depende de garantias, senioridade, registrabilidade da cessão, contestabilidade do recebível, eficiência de cobrança e tempo de recuperação. Em crise, PD e LGD tendem a piorar juntas, criando wrong-way risk."
			meshManifestation: "Recebíveis registrados, bem documentados e com entrega confirmada têm LGD menor. Recebíveis contestáveis, sem registro ou contra comprador em recuperação judicial têm LGD muito maior. Em crise da construção, ativos perdem valor, o judiciário congestiona e recuperações caem."
			meshImplication:   "Estimar LGD normal e LGD downturn. Para provisão conservadora e capital, usar LGD downturn. Tratar registro em registradora e confirmação robusta de entrega como alavancas diretas de redução de LGD, não apenas compliance."
			dependsOn:         ["cr-probability-of-default"]
			rationale:         "LGD captura severidade. Ignorar sua deterioração em stress subestima perda justamente no pior cenário."
		},
		{
			id:                "cr-dilution-risk"
			name:              "Risco de Diluição"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Diluição é redução da exposição por eventos não-creditícios antes do vencimento: devolução, nota de débito, compensação, glosa de medição, abatimento por defeito ou atraso operacional. Não é default; é erosão do valor econômico do recebível."
			meshManifestation: "Na construção civil, serviços glosados e materiais contestados são frequentes. A Mesh pode antecipar contra valor nominal que depois se mostra parcialmente inexigível."
			meshImplication:   "Tratar diluição como risco próprio. Aplicar haircut sobre EAD, modelar taxa histórica por comprador, por par e por tipo de operação, e monitorar sua evolução separadamente de default."
			dependsOn:         ["cr-default-definition"]
			rationale:         "Ignorar diluição superestima EAD e desloca perda para a categoria errada."
		},
		{
			id:                "cr-fraud-risk"
			name:              "Fraude e Recebíveis Fictícios"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Fraude em antecipação inclui recebível inexistente, cessão duplicada, falsificação documental e conluio entre partes para fabricar lastro. É risco de perda total e de natureza distinta de crédito: o problema não é inadimplência de obrigação válida, mas inexistência ou invalidez do ativo."
			meshManifestation: "A construção civil brasileira tem histórico de fraude em duplicatas e recebíveis fabricados. A vantagem da Mesh é poder triangular pedido, execução, nota fiscal, confirmação e pagamento, reduzindo espaço para fraude."
			meshImplication:   "Operar controles antifraude como pré-condição de elegibilidade. Registro em registradora elimina cessão duplicada. Anomalias entre capacidade operacional, volume faturado e eventos operacionais devem disparar investigação. Fraude não entra em score como simples risco alto; entra como exclusão ou tratamento separado."
			rationale:         "Fraude não pode ser diluída dentro de PD/LGD como se fosse apenas variação estatística."
		},
		{
			id:                "cr-cure-roll-rate"
			name:              "Cure Rate e Roll Rate"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Cure rate mede probabilidade de uma exposição em atraso voltar a correnteza antes de atingir default. Roll rate mede probabilidade de migração entre buckets de atraso. Juntas, essas métricas distinguem atraso operacional endêmico de deterioração real."
			meshManifestation: "Na construção civil, há compradores que atrasam de forma crônica e ainda assim pagam quase sempre. Outros começam em atraso moderado e escalam rapidamente. Sem separar esses padrões, a Mesh contrai crédito de bons pagadores tardios ou relaxa demais com devedores deteriorando."
			meshImplication:   "Construir curvas de roll rate e cura por comprador, setor e segmento. Tratar migração 30→60 e 60→90 como sinais qualitativamente diferentes. Usar essa leitura também como produto informacional para fornecedores."
			dependsOn:         ["cr-default-definition"]
			rationale:         "É o mecanismo que separa atraso estrutural do setor de risco de crédito real."
		},
		{
			id:                "cr-exposure-at-default"
			name:              "Exposição no Momento do Default (EAD)"
			nature:            "theoretical"
			role:              "framework"
			definition:        "EAD é o valor efetivamente em risco quando default ocorre. Em antecipação de recebíveis, deve considerar saldo em aberto, amortizações, diluição esperada e, quando relevante, exposição agregada por comprador, fornecedor e par."
			meshManifestation: "A Mesh pode parecer diversificada pelo número de fornecedores e, ao mesmo tempo, ter EAD fortemente concentrada em poucos compradores. Essa concentração só aparece quando a exposição é agregada corretamente."
			meshImplication:   "Medir EAD nominal e efetiva. Agregar por comprador, fornecedor, par, setor e região. Usar EAD como base viva de concentração, não apenas valor nominal por operação."
			dependsOn:         ["cr-dilution-risk"]
			rationale:         "Sem EAD corretamente medida, EL, concentração e stress testing ficam errados em valor absoluto."
		},
		{
			id:                "cr-expected-loss"
			name:              "Perda Esperada, Perda Inesperada e RAROC"
			nature:            "theoretical"
			role:              "framework"
			definition:        "EL representa o custo médio esperado do risco e deve ser coberta pelo spread. UL representa risco acima da média e exige capital ou subordinação. RAROC compara retorno após perdas e custos contra o capital consumido pelo risco."
			meshManifestation: "Uma operação pode ter spread alto e ainda assim consumir tanto capital por concentração, maturidade ou correlação que destrói valor ajustado ao risco. Em FIDC, EL e UL aparecem como exigências diferentes: spread mínimo e subordinação necessária."
			meshImplication:   "Separar claramente custo do negócio e risco de cauda. Exigir que pricing cubra EL + custo operacional + custo de capital. Usar RAROC para priorizar entre operações e segmentos, não apenas spread nominal."
			dependsOn:         ["cr-probability-of-default", "cr-loss-given-default", "cr-exposure-at-default"]
			rationale:         "Sem separar EL de UL, a Mesh confunde lucratividade média com sustentabilidade de carteira."
		},
		{
			id:                "cr-concentration-risk"
			name:              "Risco de Concentração"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Concentração ocorre quando parcela relevante da exposição depende de poucos nomes, setores, regiões ou cadeias. A aparente diversificação por número de fornecedores pode esconder concentração econômica no mesmo comprador ou cluster."
			meshManifestation: "Na construção civil, muitos fornecedores pequenos podem depender da mesma construtora grande. A carteira parece pulverizada por cedente, mas é concentrada por sacado."
			meshImplication:   "Medir concentração por HHI e por limites simples de exposição por nome, setor, região e cadeia. Usar concentração por comprador como métrica primária no bootstrap. Acrescentar add-on de granularidade no capital para carteiras pequenas e concentradas."
			dependsOn:         ["cr-exposure-at-default"]
			rationale:         "É o principal mecanismo de transformação de risco individual em risco sistêmico na Mesh."
		},
		{
			id:                "cr-correlation-of-defaults"
			name:              "Correlação de Defaults e Risco de Rede"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Defaults não são independentes. Crises macro, setoriais, topológicas e operacionais produzem clusters de perdas. Além da correlação por fator comum, a rede comprador-fornecedor cria canais de contágio que agravam deterioração."
			meshManifestation: "Uma única construtora em dificuldade pode contaminar dezenas de fornecedores, que então degradam entrega e liquidez em outros relacionamentos. A Mesh vê o grafo real das dependências e consegue detectar nós críticos e dependências assimétricas."
			meshImplication:   "Nunca assumir independência simples. Incorporar correlação por setor, por comprador e por dependência de cadeia. Identificar nós críticos, dependência excessiva e canais de contágio indireto."
			dependsOn:         ["cr-concentration-risk"]
			rationale:         "A rede operativa da Mesh torna correlação observável e economicamente decisiva."
			crossDependsOn: [
				{lensId: "lens-supply-chain-theory", conceptId: "sc-multi-tier-propagation", context: "a topologia operacional informa a correlação econômica de defaults"},
			]
		},
		{
			id:                "cr-procyclicality"
			name:              "Pro-ciclicalidade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Modelos excessivamente sensíveis ao presente tendem a expandir crédito no boom e contrair no estresse, reforçando ciclos. A mitigação exige âncoras through-the-cycle, floors, buffers contracíclicos e disciplina de provisão."
			meshManifestation: "Se a Mesh só olhar dados recentes, verá qualidade crescente em boom e contrairá violentamente em crise, exatamente quando a cadeia mais precisa de liquidez seletiva."
			meshImplication:   "Usar âncoras externas TTC no bootstrap, floors por rating, buffer contracíclico e governança explícita para evitar expansão excessiva em períodos benignos."
			dependsOn:         ["cr-probability-of-default", "cr-expected-loss"]
			rationale:         "Pro-ciclicalidade faz o sistema parecer seguro quando acumula risco e parecer perigoso quando o risco já explodiu."
		},
		{
			id:                "cr-operational-transmission"
			name:              "Transmissão Operacional → Financeira"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A vantagem distintiva da Mesh está em ligar eventos operacionais a deterioração financeira por cadeias causais com lead times identificáveis. Isso não é apenas feature engineering; é modelo causal do setor."
			meshManifestation: "Queda de pedidos, aumento de disputas, atraso em confirmação de entrega, mudança de padrão de obra, parada de canteiro e concentração de dependência podem preceder atraso financeiro em 30, 60 ou 90 dias."
			meshImplication:   "Operar painel explícito de leading indicators operacionais e seus lead times, com overlays de PD e restrição de limites antes do atraso financeiro formal aparecer."
			rationale:         "É a principal vantagem competitiva de risco da Mesh sobre financiadores que veem só fluxo financeiro."
			crossDependsOn: [
				{lensId: "lens-supply-chain-theory", conceptId: "sc-operational-financial-transmission", context: "supply-chain-theory fornece mecanismo setorial; credit-risk transforma em overlay de risco e limite"},
			]
		},
		{
			id:                "cr-vintage-analysis"
			name:              "Análise de Safra (Vintage)"
			nature:            "theoretical"
			role:              "method"
			definition:        "Vintage analysis acompanha performance por coorte de originação ao longo do tempo, permitindo detectar deterioração de underwriting, mudança de composição e efeitos de ciclo. Em construção civil, precisa controlar por sazonalidade e ciclo do projeto."
			meshManifestation: "Safras de janeiro não são comparáveis a julho sem ajuste. Relações em final de obra se comportam diferente de relações em fase de estrutura."
			meshImplication:   "Comparar safras no mesmo ponto temporal, mesma estação e, quando possível, mesma composição de ciclo de projeto. Usar vintage como early warning primário de deterioração de originação."
			dependsOn:         ["cr-default-definition"]
			rationale:         "Sem controle de confounders setoriais, vintage gera alarme falso ou conforto falso."
		},
		{
			id:                "cr-stress-testing"
			name:              "Stress Testing"
			nature:            "theoretical"
			role:              "method"
			definition:        "Stress testing avalia a carteira sob cenários adversos históricos, hipotéticos e reversos, quantificando impacto em PD, LGD, EAD, EL, UL e suficiência de reserva ou subordinação."
			meshManifestation: "Cenários relevantes incluem recessão, crise imobiliária, recuperação judicial do maior comprador, indisponibilidade operacional e choque de funding combinado com deterioração de sacados."
			meshImplication:   "Rodar stress test trimestral. No bootstrap, priorizar cenários idiossincráticos de concentração. Em escala, incluir cenários macro e setoriais com correlação e LGD downturn. Manter stress reverso como ferramenta de ponto de quebra."
			dependsOn:         ["cr-expected-loss", "cr-concentration-risk", "cr-correlation-of-defaults"]
			rationale:         "Modelos médios não capturam o que quebra a firma; stress testing sim."
			crossDependsOn: [
				{lensId: "lens-complex-adaptive-systems", conceptId: "cas-nonlinearity-tipping", context: "stress testing precisa capturar mudanças não lineares, não só deslocamentos suaves de parâmetros"},
			]
		},
		{
			id:                "cr-model-risk"
			name:              "Risco de Modelo e Validação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Model risk é o risco de que o modelo esteja errado estruturalmente, degradado pela mudança de população, mal calibrado ou excessivamente otimista. Discriminação, calibração e estabilidade da população precisam ser validadas separadamente."
			meshManifestation: "No bootstrap, a Mesh terá poucos defaults observados e muito uso de proxies. O maior risco pode ser acreditar cedo demais na própria modelagem. Em crescimento, mudança de segmento, de porte de comprador ou de geografia pode degradar o modelo antes que defaults apareçam."
			meshImplication:   "Monitorar PSI, discriminação e calibração em cadências diferentes. Definir triggers explícitos de recalibração e uso conservador enquanto a amostra própria ainda é rasa."
			rationale:         "No bootstrap, risco de modelo é muitas vezes maior que risco estimado do portfólio."
		},
		{
			id:                "cr-regulatory-provisioning"
			name:              "Provisão Regulatória Brasileira"
			nature:            "theoretical"
			role:              "constraint"
			definition:        "A provisão regulatória e os requisitos prudenciais criam um piso obrigatório que pode exceder a visão do modelo interno. A lógica econômica da Mesh precisa conviver com regras brasileiras de classificação, provisão e, quando aplicável, estrutura de FIDC."
			meshManifestation: "Em carteira com atraso endêmico, a provisão regulatória pode se mostrar mais severa que o modelo econômico, consumindo capital e alterando unit economics."
			meshImplication:   "Calcular provisão regulatória em paralelo ao modelo interno e operar sempre pelo maior requisito. No caso de FIDC, traduzir a lógica de perda e estresse em subordinação e desenho compatíveis com o rating e o regulamento do veículo."
			dependsOn:         ["cr-expected-loss", "cr-default-definition"]
			rationale:         "O modelo econômico não substitui o constrangimento prudencial."
			crossDependsOn: [
				{lensId: "lens-regulatory-strategy", conceptId: "rs-brazil-financial-regime", context: "regulatory-strategy define o enquadramento; credit-risk calcula o efeito prudencial concreto"},
			]
		},
		{
			id:                "cr-mesh-credit-health"
			name:              "Métricas de Saúde de Crédito da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "monthly"
			definition:        "Conjunto de métricas para acompanhar saúde do portfólio: PD média e por segmento, EAD por comprador e HHI, roll rates por bucket, cure rate, diluição por par, LGD realizada vs estimada, safra por coorte, concentração por cadeia, EL implícita, UL estimada, RAROC por segmento e gap entre provisão regulatória e provisão por modelo."
			meshManifestation: "No bootstrap, poucas métricas terão profundidade estatística, mas concentração, EAD, buckets de atraso, safra e sinais operacionais já são acionáveis. Em escala, o painel passa a suportar overlays, restrição de limites e reprecificação."
			meshImplication:   "Operar painel mensal e revisão mais profunda trimestral. Tratar comprador, não fornecedor, como eixo principal de concentração. Mostrar métricas agregadas e desagregadas por vertical, região, estrutura jurídica e maturidade."
			rationale:         "Sem painel operacional unificado, a lente vira teoria sem governança recorrente."
		},
	]
}
