package lenses

import "mesh-spec/architecture/artifact-schemas"

informationEconomics: artifact_schemas.#AnalyticalLens & {
	id:      "lens-information-economics"
	name:    "Economia da Informação"
	purpose: "Modelar a estrutura informacional da Mesh: quem sabe o quê, quais assimetrias importam economicamente, quais sinais realmente carregam informação, onde há externalidades informacionais, e quando transparência, inferência, sinalização ou screening fazem sentido. A lente diagnostica o problema informacional; o desenho das regras que o resolvem pertence principalmente a mechanism-design."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve mapear quem sabe o quê e qual o custo econômico da ignorância",
			"a decisão envolve avaliar se um dado, evento ou atributo é realmente informativo ou apenas noise",
			"a decisão envolve definir quais dados coletar, de quem, em que ordem e com qual prioridade econômica",
			"a decisão envolve definir que informação é pública, privada, bilateral ou compartilhada na rede",
			"a decisão envolve avaliar se transparência resolve, agrava ou desloca um problema",
			"a decisão envolve entender por que participantes não adotam apesar de benefício aparente",
			"a decisão envolve diagnosticar degradação de qualidade em um pool de participantes",
			"a decisão envolve distinguir adverse selection de moral hazard",
			"a decisão envolve avaliar se a fusão banco↔supply chain realmente elimina uma assimetria ou apenas a reduz",
			"a decisão envolve identificar externalidades informacionais que travam o flywheel da Mesh",
			"a decisão envolve distinguir cascata informacional racional de herding comportamental",
			"a decisão envolve definir o nível ótimo de disclosure por tipo de informação e por direção entre participantes",
		]
		keywords: [
			"assimetria", "informação privada", "opacidade", "ignorância",
			"sinal", "noise", "signaling", "screening",
			"lemons", "adverse selection", "moral hazard",
			"disclosure", "transparência", "revelação",
			"externalidade informacional", "valor da informação",
			"cascata", "herding", "certificação",
			"verificabilidade", "inferência", "observabilidade",
			"pool quality", "data quality", "informational moat",
		]
		excludeWhen: [
			"a decisão é sobre como desenhar regras de interação, menus, pricing ou penalidades dado que a assimetria já foi mapeada; usar lens-mechanism-design",
			"a decisão é sobre infraestrutura de armazenamento, pipeline ou integração de dados sem componente econômico; usar lente de arquitetura apropriada",
			"a decisão é sobre compliance de dados sem componente estratégico ou econômico; usar lens-regulatory-strategy",
			"a decisão é sobre modelo quantitativo de risco de crédito, calibração estatística ou provisão; usar lens-credit-risk",
			"a decisão é sobre governança de recurso compartilhado sem foco principal na estrutura informacional; usar lens-commons-collective-action",
		]
		rationale: "A Mesh existe porque informação que o banco não tem está na operação, e informação que a supply chain não tem está no fluxo financeiro. Economia da informação diagnostica a estrutura dessas assimetrias, avalia o valor de reduzi-las e identifica quando sinalização, screening, inferência ou disclosure são economicamente relevantes. O design das regras que operacionalizam essa redução pertence, em geral, a mechanism-design."
	}

	concepts: [
		{
			id:                "ie-information-asymmetry"
			name:              "Assimetria Informacional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Há assimetria informacional quando uma parte possui informação economicamente relevante que outra parte não possui no momento da decisão. A consequência central é que preço, seleção, monitoramento e confiança passam a refletir ignorância, não realidade. Duas famílias de problema derivam daqui: adverse selection, quando a assimetria afeta quem entra, quem é escolhido ou como o pool se compõe antes da transação; e moral hazard, quando afeta o comportamento depois que a transação já ocorreu."
			meshManifestation: "Fornecedor sabe mais sobre sua capacidade real, sua disciplina operacional e suas dificuldades atuais do que comprador e Mesh. Comprador sabe mais sobre sua disposição real de pagar, sua saúde financeira e sua intenção de honrar prazo do que fornecedor. A Mesh, por sua vez, pode passar a saber mais sobre ambos do que qualquer um isoladamente quando cruza dados operacionais e financeiros."
			meshImplication:   "Mapear explicitamente cada assimetria relevante por direção: fornecedor→comprador, comprador→fornecedor, participante→Mesh, Mesh→participante, Mesh→investidor e investidor→Mesh. Para cada uma: qual é o custo concreto da ignorância, quem suporta esse custo, e a fusão banco↔supply chain elimina, reduz ou não altera a assimetria."
			rationale:         "É o conceito fundante. Sem mapa explícito de assimetrias, o resto da lente vira intuição vaga."
		},
		{
			id:                "ie-lemons-problem"
			name:              "Problema dos Lemons"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quando compradores não conseguem distinguir qualidade alta de baixa antes da transação, oferecem preço médio. Esse preço médio expulsa os bons e atrai ou mantém os ruins, degradando a composição do mercado. O problema não é apenas injustiça de preço; é deterioração progressiva da qualidade média e eventual inviabilidade do mercado."
			meshManifestation: "Sem informação confiável sobre fornecedores, a construção civil depende de indicação, qualificação manual, reputação informal e preço como proxy imperfeito. Bons fornecedores não capturam o valor de sua qualidade. Ruins conseguem competir escondendo defeitos até tarde. O mercado fica mais caro, mais lento e menos confiável."
			meshImplication:   "A Mesh precisa funcionar como mecanismo anti-lemons: distinguir qualidade antes da transação com sinais críveis, verificáveis e economicamente relevantes. Se o score não for confiável, visível e útil no momento da escolha, o lemons problem apenas migra para dentro da Mesh."
			rationale:         "É a justificativa econômica mais direta para por que o mercado precisa de uma camada como a Mesh."
			dependsOn:         ["ie-information-asymmetry"]
			crossDependsOn: [
				{lensId: "lens-market-design", conceptId: "md-participation-constraints", context: "se os bons com outside option saem, o mercado volta a degradar por seleção adversa"},
			]
		},
		{
			id:                "ie-signaling"
			name:              "Sinalização"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Sinalização ocorre quando a parte informada realiza uma ação ou apresenta uma característica que é mais fácil ou menos custosa para o tipo bom do que para o tipo ruim. A credibilidade do sinal depende de custo de imitação, correlação com o atributo relevante e verificabilidade por quem recebe o sinal."
			meshManifestation: "Entrega consistente no prazo é sinal forte porque exige capacidade real. Certificação setorial é sinal médio: custa obter, mas não garante performance corrente. Auto-declaração de capacidade é sinal fraco: custo de imitação quase zero. Histórico de pagamento do comprador é sinal forte para o fornecedor; promessa verbal de que paga em dia é sinal fraco."
			meshImplication:   "Toda variável candidata a score, matching ou qualificação deve ser avaliada como sinal: quão difícil é falsificar, quão correlacionada é com o que realmente importa e quão verificável ela é na infraestrutura da Mesh. Sinais fracos podem existir, mas não devem ocupar o mesmo peso que sinais fortes."
			rationale:         "Scoring sem teoria de sinalização vira mistura de features sem disciplina econômica."
			dependsOn:         ["ie-information-asymmetry", "ie-lemons-problem"]
		},
		{
			id:                "ie-screening-diagnostic"
			name:              "Screening como Diagnóstico"
			nature:            "theoretical"
			role:              "method"
			definition:        "Screening é relevante quando a parte menos informada consegue criar condições sob as quais tipos diferentes se auto-selecionam de maneira reveladora. Nesta lente, o foco não é desenhar o menu ou a regra, mas diagnosticar se a assimetria é do tipo que screening pode resolver e qual informação potencialmente seria revelada."
			meshManifestation: "A Mesh observa escolhas que já carregam informação: rapidez com que fornecedor envia documentação, disposição de entrar em camada contratual mais exigente, tolerância a retenção, urgência de liquidez, aceitação de verificações adicionais, padrão de resposta a exigências de onboarding."
			meshImplication:   "Para cada assimetria residual, perguntar: a Mesh consegue inferir diretamente de dados? Se não, os tipos são distinguíveis pela escolha entre opções? Se sim, screening é viável e deve alimentar mechanism-design. Se não, screening provavelmente é fraco e a solução terá de vir por sinalização, monitoramento ou aceitação de incerteza residual."
			rationale:         "Sem esse diagnóstico, há tendência de empurrar toda assimetria para menus que não separam nada."
			dependsOn:         ["ie-information-asymmetry"]
			crossDependsOn: [
				{lensId: "lens-mechanism-design", conceptId: "md-screening", context: "esta lente decide se screening faz sentido; mechanism-design desenha o mecanismo concreto"},
			]
		},
		{
			id:                "ie-value-of-information"
			name:              "Valor da Informação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O valor econômico de uma informação é a melhoria de decisão que ela possibilita em relação ao custo de obtê-la, mantê-la e processá-la. Esse valor costuma ser marginalmente decrescente: os primeiros dados mudam muito a decisão; dados adicionais confirmam o que já se sabe."
			meshManifestation: "O primeiro ciclo pago de um fornecedor novo pode mudar radicalmente a avaliação. O centésimo pagamento confirma tendência já conhecida. Dados de estresse, crise, atraso anômalo ou comportamento fora do padrão tendem a valer mais do que dados em contexto normal e previsível."
			meshImplication:   "Priorizar investimento em dados onde a curva de valor marginal ainda é íngreme: fornecedores novos, compradores novos, segmentos novos, regimes informais em digitalização, cenários atípicos e períodos de stress. Reduzir investimento onde a informação já está saturada e não muda mais decisão materialmente."
			rationale:         "Sem esse conceito, a Mesh tende a coletar tudo indiscriminadamente ou a subinvestir justamente onde o dado muda mais a qualidade da decisão."
		},
		{
			id:                "ie-information-externality"
			name:              "Externalidade Informacional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Há externalidade informacional quando a informação gerada por uma transação ou contribuição individual melhora a decisão de outros agentes além do gerador do dado. Como o gerador normalmente não captura todo esse valor social, a produção de informação tende a ficar abaixo do nível socialmente ótimo."
			meshManifestation: "Comprador que paga pela Mesh ajuda a calibrar reputação de pagamento para todos os fornecedores que com ele lidam. Fornecedor que confirma entrega com qualidade ajuda a melhorar score setorial. Cada transação produz aprendizado que beneficia a rede inteira, não apenas as partes envolvidas."
			meshImplication:   "Identificar os dados com maior gap entre valor privado e valor social: são esses que exigem maior esforço de internalização. Se a parte que gera o dado não percebe benefício próprio, o commons informacional será subalimentado."
			rationale:         "O flywheel da Mesh depende de externalidades informacionais positivas serem reconhecidas e internalizadas."
			dependsOn:         ["ie-value-of-information"]
			crossDependsOn: [
				{lensId: "lens-commons-collective-action", conceptId: "ca-data-as-commons", context: "externalidade informacional é o elo entre decisão privada e qualidade do pool compartilhado"},
			]
		},
		{
			id:                "ie-information-cascade-and-herding"
			name:              "Cascata Informacional e Herding"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Cascata informacional é adoção ou rejeição baseada em inferência racional a partir das decisões observáveis de agentes anteriores. Herding é imitação por vieses, conveniência ou medo social, sem inferência robusta. Os dois parecem semelhantes do lado de fora, mas respondem a intervenções diferentes."
			meshManifestation: "Primeiros anchors que adotam a Mesh podem gerar cascata racional se o mercado interpreta sua adesão como informação confiável. Já boatos de que uma empresa saiu, ou a sensação de que 'ninguém está usando', podem gerar herding negativo mesmo quando os fundamentos econômicos continuam bons."
			meshImplication:   "Diagnosticar se adoção ou rejeição está sendo guiada por inferência ou por imitação comportamental. Se for cascata, disclosure e evidência concreta ajudam. Se for herding, será preciso complementar com behavioral-economics, fricção menor, framing melhor e sinais sociais mais bem desenhados."
			rationale:         "Misturar cascata racional com herding leva a reforçar com informação um problema que é principalmente comportamental."
		},
		{
			id:                "ie-disclosure-transparency"
			name:              "Disclosure e Transparência Estratégica"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Transparência não é um bem absoluto. O nível ótimo de disclosure depende do tipo de informação, da capacidade de interpretação do receptor, do risco de gaming e da assimetria que a revelação resolve. Informação demais pode criar overreaction, ruído, manipulação e perda de vantagem informacional; informação de menos mantém opacidade destrutiva."
			meshManifestation: "A Mesh decide o que mostrar ao comprador sobre fornecedor, ao fornecedor sobre si mesmo, e ao fornecedor sobre comprador. Cada direção tem objetivos e riscos distintos. A opacidade do comprador para o fornecedor é especialmente cara porque eleva spread implícito em toda a cadeia."
			meshImplication:   "Calibrar disclosure por direção e por tipo de dado. Em muitos casos, o nível ótimo não será número exato público para todos, mas faixas, reputações compostas, histórico resumido, score próprio detalhado e score de contraparte em forma interpretável. A decisão ótima pode ser diferente para comprador, fornecedor, investidor e operador."
			rationale:         "Transparência mal calibrada resolve uma assimetria enquanto cria outra."
			dependsOn:         ["ie-information-asymmetry", "ie-signaling"]
			crossDependsOn: [
				{lensId: "lens-regulatory-strategy", conceptId: "rs-lgpd-operational", context: "disclosure ótimo economicamente ainda precisa respeitar base legal, minimização e revisão"},
				{lensId: "lens-behavioral-economics", conceptId: "be-bounded-rationality-real", context: "nível ótimo de disclosure depende da capacidade real de interpretação do receptor"},
			]
		},
		{
			id:                "ie-inference-vs-observation"
			name:              "Inferência vs Observação Direta"
			nature:            "theoretical"
			role:              "heuristic"
			definition:        "Algumas assimetrias podem ser resolvidas por observação direta; outras apenas por inferência a partir de múltiplos sinais imperfeitos. Inferência é inevitável quando o atributo economicamente relevante não é observável diretamente, mas seu uso precisa ser disciplinado porque inferência sobre dado fraco pode parecer conhecimento sem realmente sê-lo."
			meshManifestation: "Capacidade operacional real de um fornecedor, propensão futura de um comprador a atrasar e risco de disputa futura em contrato de serviço raramente são observáveis de forma direta antes do evento. A Mesh depende de inferência a partir de histórico, comportamento, composição de dados operacionais e financeiros, documentação e contexto."
			meshImplication:   "Distinguir claramente, em cada decisão, o que a Mesh sabe diretamente e o que apenas infere. Quanto mais inferência e menos observação, maior a necessidade de transparência interna sobre incerteza, confiança do sinal e margem de erro."
			rationale:         "Boa parte do poder da Mesh vem de inferir melhor do que o mercado; o risco é confundir inferência com fato."
			dependsOn:         ["ie-information-asymmetry", "ie-signaling"]
		},
		{
			id:                "ie-verifiability-hierarchy"
			name:              "Hierarquia de Verificabilidade"
			nature:            "theoretical"
			role:              "property"
			definition:        "Nem toda informação economicamente útil é igualmente verificável. Há uma hierarquia: auto-relato, observação unilateral, observação bilateral, confirmação documental, validação por terceiro independente, e fato registrável em infraestrutura externa. Quanto mais alta a verificabilidade, mais robusta a informação para uso em score, pricing, matching e governança."
			meshManifestation: "Declaração do fornecedor sobre capacidade é fraca. Confirmação do comprador é melhor. NF eletrônica, registradora, histórico de pagamento e confirmação cruzada em trilha auditável sobem significativamente na hierarquia."
			meshImplication:   "Toda arquitetura informacional da Mesh deve favorecer a migração de sinais de baixa verificabilidade para sinais de alta verificabilidade. Onde isso não for possível, tratar o dado com peso, confiança e uso adequados ao seu nível na hierarquia."
			rationale:         "Sem hierarquia de verificabilidade, dados de qualidades muito diferentes acabam tratados como equivalentes."
			dependsOn:         ["ie-signaling", "ie-inference-vs-observation"]
			crossDependsOn: [
				{lensId: "lens-contract-theory", conceptId: "ct-verifiability-gap", context: "verificabilidade econômica e verificabilidade contratual se reforçam, mas não são idênticas"},
			]
		},
		{
			id:                "ie-pool-quality-degradation"
			name:              "Degradação de Qualidade do Pool"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Um pool de participantes pode degradar mesmo sem aumento aparente de volume, quando bons participantes saem, sinais perdem poder informacional, gaming aumenta, qualidade média cai ou a distribuição interna do pool muda de forma adversa. O problema é composicional, não apenas estatístico."
			meshManifestation: "A Mesh pode continuar crescendo em número de participantes enquanto perde os perfis de mais alta qualidade, mais verificáveis ou com melhor outside option. Também pode manter o mesmo número de participantes, mas com pior qualidade média de dado ou maior opacidade residual."
			meshImplication:   "Sempre diagnosticar qualidade de pool separadamente de crescimento bruto. Se adoção cresce enquanto qualidade do dado, qualidade dos participantes ou poder preditivo do score pioram, o problema é informacional e estrutural, não apenas de volume."
			rationale:         "Mercado pode parecer maior e estar economicamente pior."
			dependsOn:         ["ie-lemons-problem", "ie-information-externality", "ie-disclosure-transparency"]
			crossDependsOn: [
				{lensId: "lens-commons-collective-action", conceptId: "ca-adverse-selection-intra-commons", context: "degradação do pool pode ser produzida por saída seletiva dos melhores contribuidores"},
				{lensId: "lens-credit-risk", conceptId: "cr-model-risk", context: "piora do pool costuma aparecer antes como deterioração do poder informacional do modelo"},
			]
		},
		{
			id:                "ie-mesh-informational-advantage"
			name:              "Vantagem Informacional da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "A vantagem informacional da Mesh não é abstrata; ela precisa ser testada continuamente. A pergunta central é: em cada assimetria relevante da cadeia, a Mesh sabe algo economicamente útil que o banco isolado, o ERP isolado, o fornecedor ou o comprador isolados não sabem — e esse algo melhora decisão real?"
			meshManifestation: "A Mesh deveria ser capaz de prever melhor risco, qualidade, atraso, disputa, confiabilidade de pagamento e qualidade de matching do que atores que veem apenas um lado do sistema. Se não consegue, a fusão banco↔supply chain está gerando menos valor informacional do que a tese promete."
			meshImplication:   "Operar revisão periódica da vantagem informacional por caso de uso: risco de crédito, matching, qualificação, disclosure de comprador, disclosure de fornecedor e alocação de funding. Onde a vantagem informacional não existir ou não for material, reduzir investimento ou redesenhar o fluxo de dados."
			rationale:         "A lente precisa testar a tese central da Mesh, não apenas assumi-la."
			appliesWhen:       "a decisão envolve priorização estratégica de coleta, modelagem, disclosure ou produto"
		},
	]
}
