package lenses

import "mesh-spec/architecture/artifact-schemas"

behavioralEconomics: artifact_schemas.#AnalyticalLens & {
	id:      "lens-behavioral-economics"
	name:    "Economia Comportamental"
	purpose: "Modelar como fornecedores, compradores, investidores e humanos no loop processam informação, risco, confiança e outputs de IA de forma não plenamente racional, para que a Mesh desenhe jornadas, comunicações e defaults robustos ao comportamento real."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve como participantes reais, e não agentes plenamente racionais, tomam decisões de adoção, uso ou abandono",
			"a decisão envolve design de onboarding, first-use experience ou reativação",
			"a decisão envolve por que participantes não adotam apesar de benefício aparente",
			"a decisão envolve como apresentar score, taxa, risco ou incerteza para que participantes processem corretamente",
			"a decisão envolve por que participantes reagem de forma desproporcional a eventos negativos, mudanças de regra ou notícias",
			"a decisão envolve reduzir friction de adoção ou aumentar engajamento recorrente",
			"a decisão envolve como vieses cognitivos afetam decisões financeiras ou operacionais dos participantes",
			"a decisão envolve comunicação de crise, renegociação ou mudança de política para participantes ou investidores",
			"a decisão envolve como humanos processam outputs de agentes de IA, incluindo aceitação cega e rejeição após erro",
			"a decisão envolve percepção de fairness entre participantes que recebem tratamento diferenciado",
		]
		keywords: [
			"viés", "bias", "heurística", "nudge", "boost",
			"adoção", "onboarding", "friction", "abandono",
			"aversão à perda", "loss aversion", "status quo", "inércia",
			"ancoragem", "anchoring", "framing", "enquadramento",
			"overconfidence", "excesso de confiança", "planning fallacy",
			"present bias", "desconto hiperbólico", "imediatismo",
			"social proof", "prova social", "herding",
			"default", "opt-in", "opt-out",
			"confiança", "medo", "pânico", "resistência",
			"simplicidade", "complexidade cognitiva",
			"sunk cost", "escalation", "commitment device",
			"automation bias", "algorithm aversion",
			"fairness", "justiça", "reciprocidade",
			"reference point", "regret", "arrependimento",
		]
		excludeWhen: [
			"a decisão é sobre design de regras e incentivos assumindo racionalidade estável — usar lens-mechanism-design",
			"a decisão é sobre estrutura informacional sem componente de processamento comportamental — usar lens-information-economics",
			"a decisão é sobre risco de crédito, perda esperada ou composição de carteira — usar lens-credit-risk",
			"a decisão é sobre funding, liquidez ou veículo regulatório — usar lens-financial-intermediation",
			"a decisão é sobre topologia de rede sem componente de processamento humano — usar lens-network-theory",
		]
		rationale: "Mechanism-design assume racionalidade suficiente para que participantes respondam a incentivos conforme o modelo. Behavioral-economics entra quando isso falha: participantes são boundedly rational, usam heurísticas, têm aversão a perda, resistem a mudança por inércia, super-reagem a eventos salientes, e interagem com IA com automation bias ou algorithm aversion. Na construção civil brasileira, com fornecedores de baixa sofisticação, compradores institucionais com DMU complexa e redes informais de reputação, esse gap é grande e recorrente."
	}

	concepts: [
		{
			id:                "be-bounded-rationality-real"
			name:              "Racionalidade Limitada na Prática"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Participantes reais não maximizam utilidade com processamento perfeito de informação. Eles usam heurísticas que funcionam suficientemente bem no contexto cotidiano, mas geram vieses previsíveis. A bounded rationality relevante aqui é cognitiva e comportamental: como o participante processa informação disponível, não apenas sua incapacidade de prever contingências contratuais."
			meshManifestation: "Fornecedor pequeno compara taxa com uma referência simples e com a relação pessoal com o gerente, não com custo efetivo anualizado. Comprador institucional julga a Mesh pela experiência inicial e pelo risco pessoal do recomendador, não por NPV total. Investidor reage a evento saliente com peso desproporcional. Humano no loop pode aceitar output de IA sem checagem ou rejeitar todo o sistema depois de um erro."
			meshImplication:   "Toda decisão de produto, comunicação ou operação deve ser testada contra comportamento real, não contra usuário idealizado. Antes de classificar um comportamento como viés, verificar se é ecological rationality, ou seja, adaptação razoável a um contexto em que a Mesh ainda não oferece atributos que o participante valoriza."
			rationale:         "É o conceito fundante da lente. Sem ele, toda a camada comportamental é tratada como ruído em vez de estrutura previsível."
		},
		{
			id:                "be-loss-aversion"
			name:              "Aversão à Perda"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Perdas são sentidas de forma mais intensa que ganhos equivalentes. O ponto central não é apenas que o participante gosta de ganhar, mas que ele evita trocar um estado conhecido por outro que possa ser percebido como perda, mesmo quando o saldo esperado é positivo."
			meshManifestation: "Fornecedor prefere continuar com banco caro e conhecido porque a perda percebida da relação existente é mais concreta do que o ganho potencial com a Mesh. Comprador evita trocar processo manual por processo melhor se a mudança é percebida como risco de perder controle."
			meshImplication:   "Quando loss aversion domina, framing de adição é superior a framing de substituição. Exemplo: 'use a Mesh junto do banco' no início, em vez de 'abandone o banco'. Testes, trials e escopo limitado reduzem perda percebida."
			dependsOn:         ["be-bounded-rationality-real"]
			rationale:         "Explica por que propostas objetivamente melhores ainda assim encontram resistência."
		},
		{
			id:                "be-status-quo-endowment"
			name:              "Status Quo Bias, Inércia e Endowment"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Status quo bias é a tendência de manter o estado atual. Pode decorrer de loss aversion, de inércia pura ou de endowment effect. Inércia é custo de agir. Endowment é sobrevalorização do que já se possui. As três coisas parecem iguais externamente, mas exigem intervenções diferentes."
			meshManifestation: "Fornecedor não migra por não ter energia para subir documentos, por valorizar demais a relação atual com o banco, ou por perceber troca como perda. Comprador institucional mantém ERP ruim porque já está implantado."
			meshImplication:   "Diagnosticar o mecanismo dominante. Se for inércia, reduzir passos. Se for endowment, permitir uso sem compromisso. Se for loss aversion, reduzir perda percebida e usar framing de continuidade."
			dependsOn:         ["be-loss-aversion"]
			rationale:         "Sem separar os mecanismos, o design usa um remédio genérico que resolve só parte do problema."
		},
		{
			id:                "be-sunk-cost-escalation"
			name:              "Sunk Cost e Escalation of Commitment"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Participantes continuam investindo em alternativa inferior porque já investiram tempo, dinheiro ou reputação nela. Em contexto organizacional, isso é reforçado por self-justification e risco social de admitir erro."
			meshManifestation: "Construtora mantém processo ou sistema ineficiente porque já investiu muito nele. Fornecedor mantém banco ruim porque a relação é de 10 anos e abandonar isso parece desperdiçar investimento relacional."
			meshImplication:   "Nunca atacar sunk cost com framing de substituição frontal. Separar custo passado, que é irrecuperável, de custo futuro, que ainda pode ser evitado. Em compradores institucionais, usar framing de ROI incremental e coexistência temporária."
			dependsOn:         ["be-bounded-rationality-real"]
			rationale:         "Sunk cost explica persistência em caminhos ruins mesmo quando o ganho futuro da mudança é claro."
		},
		{
			id:                "be-overconfidence"
			name:              "Overconfidence e Planning Fallacy"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Overconfidence inclui sobrestimar capacidade própria, achar-se melhor que a média e ter excesso de precisão nos próprios julgamentos. Planning fallacy é o caso em que prazos, custos e riscos são sistematicamente subestimados."
			meshManifestation: "Comprador acredita que seu processo interno já é superior ao mercado e não precisa da Mesh. Fornecedor acredita que conseguirá absorver atraso futuro. Comprador subestima atraso de obra e, por consequência, de pagamento."
			meshImplication:   "Para overplacement, usar benchmarks externos concretos. Para overestimation, usar cenários financeiros com números do próprio participante. Para planning fallacy, gerar flags comportamentais que credit-risk possa consumir em cure rate e transmissão operacional-financeira."
			dependsOn:         ["be-bounded-rationality-real"]
			rationale:         "Explica resistência que não decorre nem de medo nem de atrito, mas de confiança excessiva."
			crossDependsOn: [
				{lensId: "lens-credit-risk", conceptId: "cr-cure-roll-rate", context: "planning fallacy do comprador altera a leitura de atraso e cura"},
				{lensId: "lens-credit-risk", conceptId: "cr-operational-transmission", context: "viés recorrente de prazo pode antecipar risco financeiro por padrão comportamental"},
			]
		},
		{
			id:                "be-present-bias"
			name:              "Present Bias e Desconto Hiperbólico"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Participantes sobrevalorizam custos e benefícios imediatos em relação aos futuros. A distinção crítica é entre agentes naive, que não reconhecem esse viés em si mesmos, e sophisticated, que reconhecem e aceitam mecanismos de compromisso."
			meshManifestation: "Fornecedor procrastina onboarding porque o custo é hoje e o ganho é futuro. Outro fornecedor quer travar antecipação automática porque sabe que, sem um commitment device, deixará para depois."
			meshImplication:   "Para naive, reduzir distância temporal entre ação e valor percebido. Para sophisticated, oferecer commitment devices. Em investidores, calibrar reporting para não gerar miopia excessiva sobre flutuações curtas."
			dependsOn:         ["be-bounded-rationality-real"]
			rationale:         "É um dos vieses mais diretamente ligados à adoção e ao uso recorrente da Mesh."
		},
		{
			id:                "be-reference-point-adaptation"
			name:              "Reference Point Adaptation"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O ponto de referência do participante se adapta à experiência corrente. Um benefício temporário rapidamente vira baseline subjetivo. Quando a condição volta ao normal, a normalização é sentida como perda, não como retorno à média."
			meshManifestation: "Taxa promocional de onboarding vira a nova referência do fornecedor. Quando sobe para o patamar normal, ele compara com a própria experiência anterior na Mesh, não com a outside option."
			meshImplication:   "Toda condição temporária deve ser explicitamente comunicada como temporária desde o início. Benefícios introdutórios precisam ser ancorados no estado final esperado. Sinal de adaptação: reclamações que usam condição anterior da Mesh como referência, e não o banco ou benchmark externo."
			dependsOn:         ["be-present-bias", "be-anchoring-framing"]
			rationale:         "Evita criar frustrações futuras ao resolver problemas de curto prazo."
		},
		{
			id:                "be-anchoring-framing"
			name:              "Ancoragem e Framing"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O primeiro número, comparação ou enquadramento molda a interpretação posterior. A mesma informação econômica pode ser percebida de forma diferente conforme o frame usado."
			meshManifestation: "Fornecedor interpreta 1,8% ao mês de forma diferente de 'receba R$98.200 hoje'. Score '78/100' é processado de forma diferente de 'top 20%'."
			meshImplication:   "Escolher âncoras e frames por audiência. Fornecedor pequeno tende a processar melhor valor líquido e comparações simples. Comprador sofisticado pode usar percentil, benchmark e ROI. O design deve controlar a forma, não apenas o conteúdo."
			dependsOn:         ["be-bounded-rationality-real"]
			rationale:         "É uma das alavancas de maior impacto e menor custo da lente."
		},
		{
			id:                "be-mental-accounting"
			name:              "Contabilidade Mental"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Participantes tratam dinheiro como se pertencesse a contas mentais separadas, embora ele seja fungível. O custo percebido depende da categoria mental em que a despesa ou receita é colocada."
			meshManifestation: "Fornecedor pode ver a taxa da Mesh como custo de crédito, custo comercial ou desconto por antecipação, e cada enquadramento gera reação diferente. Comprador vê a Mesh como assinatura, software ou investimento em governança."
			meshImplication:   "Apresentar antecipação de forma compatível com a conta mental do participante. Na construção civil, 'desconto por antecipação' ou 'valor líquido hoje' costuma ser cognitivamente mais acessível do que jargão financeiro puro."
			dependsOn:         ["be-anchoring-framing"]
			rationale:         "Explica por que a mesma economia objetiva pode gerar respostas subjetivas opostas."
		},
		{
			id:                "be-social-proof-organizational"
			name:              "Prova Social e Decisão Organizacional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quando a incerteza é alta, participantes observam decisões alheias. Em B2B, isso interage com a DMU: procurement, financeiro, jurídico e TI respondem a provas sociais diferentes."
			meshManifestation: "Fornecedor responde a anchor tenant visível e casos concretos. Comprador institucional pode ter procurement convencido e CFO ainda cético porque o tipo de validação que convence um não convence o outro."
			meshImplication:   "Mapear DMU antes de desenhar prova social. Entregar benchmark, case e evidência diferentes para cada stakeholder. Em fornecedores, usar anchors e rede local; em compradores, usar prova social funcional por papel."
			dependsOn:         ["be-bounded-rationality-real"]
			rationale:         "Evita aplicar prova social genérica onde a decisão é distribuída entre atores diferentes."
		},
		{
			id:                "be-regret-aversion-dmu"
			name:              "Regret Aversion e Risco Pessoal na DMU"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Em contextos organizacionais, o decisor ou recomendador pode evitar recomendar inovação não porque a solução seja pior, mas porque o risco pessoal de errar é concentrado, enquanto o custo de não agir é difuso."
			meshManifestation: "Gerente acredita na Mesh mas evita recomendá-la ao CFO porque, se der errado, ele será identificado como o responsável pela mudança."
			meshImplication:   "Converter adoção em decisão reversível. Pilot de escopo pequeno, safe-to-fail, ownership compartilhada e saída simples reduzem regret anticipation. Quando o piloto funciona, tornar visível que o recomendador gerou valor."
			dependsOn:         ["be-social-proof-organizational"]
			rationale:         "Explica o last mile de bloqueio em adoção institucional."
		},
		{
			id:                "be-trust-multidimensional"
			name:              "Confiança Multidimensional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Confiança tem pelo menos três dimensões relevantes: competence trust, integrity trust e continuity trust. Cada uma responde a sinais diferentes e a falhas diferentes."
			meshManifestation: "Fornecedor tende a se preocupar com continuidade. Investidor, com competência do modelo. Comprador, com integridade no uso dos dados e na imparcialidade da plataforma."
			meshImplication:   "Diagnosticar qual dimensão está deficitária por lado e por estágio da jornada. Quebras de confiança devem ser classificadas pela dimensão atingida para que a resposta seja específica."
			dependsOn:         ["be-bounded-rationality-real"]
			rationale:         "Confiança genérica gera comunicação genérica. Esta tipologia permite intervenção precisa."
		},
		{
			id:                "be-automation-algorithm-bias"
			name:              "Automation Bias e Algorithm Aversion"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Humanos podem aceitar recomendação algorítmica de forma acrítica ou rejeitá-la desproporcionalmente após um erro. Em sistemas AI-native, esses dois extremos coexistem e precisam ser desenhados explicitamente."
			meshManifestation: "Fornecedor aceita antecipação sem processar condições. Comprador aceita score sem questionar. Depois de um erro visível, o mesmo ator pode rejeitar toda a recomendação futura do sistema."
			meshImplication:   "Introduzir friction deliberada em decisões de alto impacto e automação progressiva à medida que confiança e familiaridade crescem. Quando houver erro, comunicar com contexto, correção e plano de melhoria, sem prometer perfeição."
			dependsOn:         ["be-trust-multidimensional"]
			rationale:         "É um risco estrutural de uma plataforma operada por IA com humanos no loop."
		},
		{
			id:                "be-fairness-reciprocity"
			name:              "Fairness, Inequity Aversion e Reciprocidade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Participantes avaliam não apenas o benefício absoluto, mas o benefício relativo frente a outros e frente à justificativa percebida como legítima. Tratamento desigual percebido como injusto pode gerar churn mesmo quando o participante está objetivamente melhor do que na outside option."
			meshManifestation: "Fornecedor pequeno descobre que outro recebe taxa melhor e interpreta isso como injustiça, ainda que sua própria taxa siga melhor que a do banco. Resolução justa de disputa gera defensores; resolução percebida como arbitrária gera detratores vocais."
			meshImplication:   "Justificar diferenciação em linguagem de mérito, histórico ou risco observável, não de poder bruto. Em disputas, priorizar procedimento percebido como justo, não apenas decisão tecnicamente correta."
			dependsOn:         ["be-anchoring-framing", "be-trust-multidimensional"]
			rationale:         "Na rede informal da construção civil, percepção de injustiça se propaga rápido e custa caro."
		},
		{
			id:                "be-friction-defaults-choice"
			name:              "Friction, Defaults e Arquitetura de Escolha"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Cada passo, campo e decisão adicional reduz conversão. Defaults moldam o comportamento da maioria. A arquitetura de escolha determina mais comportamento do que a descrição abstrata da opção."
			meshManifestation: "Fornecedor desiste no onboarding porque o processo é longo. Recebíveis elegíveis exigem ação ativa demais. Participante toma decisão de alto impacto em momento de baixa energia cognitiva."
			meshImplication:   "Meta explícita de poucos passos até primeira ação de valor. Defaults pró-valor quando eticamente aceitáveis. Menus curtos. Timing adequado à bandwidth cognitiva do participante. Sempre verificar efeitos de segunda ordem sobre composição de risco."
			dependsOn:         ["be-present-bias", "be-bounded-rationality-real"]
			rationale:         "Friction é um destruidor silencioso de adoção e recorrência."
			crossDependsOn: [
				{lensId: "lens-credit-risk", conceptId: "cr-expected-loss", context: "defaults e simplificações podem alterar composição e, portanto, EL e RAROC"},
			]
		},
		{
			id:                "be-overreaction-availability"
			name:              "Availability Bias, Recency e Overreaction"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Eventos recentes, vívidos e emocionalmente marcantes recebem peso desproporcional. Em crises, isso pode transformar incidente pontual em colapso de confiança percebida."
			meshManifestation: "Notícia de default ou incidente operacional pequeno gera percepção de que a Mesh inteira está em risco. Canais informais da construção amplificam narrativa rápida e imprecisa."
			meshImplication:   "Ter comunicação de crise preparada por audiência. Comunicar fatos, impacto real, ações tomadas e continuidade esperada antes que a narrativa informal se estabilize."
			dependsOn:         ["be-trust-multidimensional"]
			rationale:         "Sem resposta rápida, percepção distorcida vira realidade comportamental."
		},
		{
			id:                "be-mesh-behavioral-map"
			name:              "Mapa Comportamental da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "semi-annual"
			definition:        "Inventário vivo dos vieses e barreiras dominantes por lado, por estágio de jornada e, no caso de compradores, por stakeholder da DMU. Para cada hipótese comportamental: viés dominante, experimento proposto, métrica, threshold e decisão de continuidade."
			meshManifestation: "Fornecedor no onboarding pode ter friction como hipótese dominante. CFO pode ter overconfidence ou regret aversion indireta. Investidor em crise pode ter availability bias e myopic loss aversion."
			meshImplication:   "Transformar teoria comportamental em backlog experimental: hipótese falsificável, intervenção, métrica e threshold. Revisar semestralmente e após mudanças importantes de produto, crise ou segmento."
			rationale:         "Sem mapa operacional, a lente fica só como repertório conceitual."
		},
	]

	reasoningProtocol: [
		{
			question:  "Quem é o participante relevante e, no caso de comprador institucional, quem compõe a DMU? Procurement, financeiro, jurídico, TI, dono ou gerente operacional?"
			reveals:   "Mostra se a decisão é individual ou distribuída. Em DMU, cada ator tem vieses e incentivos diferentes."
			rationale: "Intervenção comportamental sem mapear quem decide tende a errar o alvo."
		},
		{
			question:  "O comportamento observado é realmente enviesado ou é adaptação racional ao contexto real do participante, dado o que a Mesh hoje oferece?"
			reveals:   "Se for ecological rationality, o problema pode ser a oferta e não o viés."
			rationale: "Evita usar nudges para mascarar proposta de valor insuficiente."
		},
		{
			question:  "Qual é o viés ou barreira dominante aqui: loss aversion, inércia, endowment, sunk cost, overconfidence, present bias, friction, trust deficit, regret aversion, fairness ou overreaction?"
			reveals:   "Permite escolher intervenção específica em vez de genérica."
			rationale: "A maior parte das falhas de adoção envolve barreiras compostas; identificar a dominante é o leverage point."
		},
		{
			question:  "Existe interação entre vieses que cria barreira composta? Se uma for removida, qual destrói o maior pedaço da barreira?"
			reveals:   "Mostra onde agir primeiro quando recurso de design é limitado."
			rationale: "Nem toda barreira precisa ser atacada ao mesmo tempo."
		},
		{
			question:  "A intervenção adequada é nudge, boost, mudança de processo, ou mudança de proposta de valor? O participante aprovaria a intervenção se soubesse exatamente o que estamos fazendo?"
			reveals:   "Define o espaço ético e pragmático da intervenção."
			rationale: "Behavioral design sem limite ético vira manipulação e destrói confiança."
		},
		{
			question:  "A intervenção proposta cria efeitos de segunda ordem? Muda composição de carteira, cria reference point problemático ou gera incentivo adverso em outra lente?"
			reveals:   "Mostra se o remédio comportamental desloca problema para risco, pricing ou governança."
			rationale: "Toda intervenção comportamental relevante muda comportamento agregado, não só conversão local."
		},
		{
			question:  "Qual é o reference point atual do participante e como ele mudará se a intervenção der certo?"
			reveals:   "Evita criar benefício temporário que depois vira perda percebida."
			rationale: "Especialmente importante para taxas promocionais, pilotos e onboarding assistido."
		},
		{
			question:  "A friction é o problema? Em qual step há abandono? O momento da decisão favorece baixa ou alta carga cognitiva?"
			reveals:   "Distingue problema de atrito de problema de confiança ou valor."
			rationale: "Friction é comum e corrigível; deve ser verificada cedo."
		},
		{
			question:  "O default e a arquitetura de escolha estão otimizados? Opt-in, opt-out, recomendação visual, menu curto?"
			reveals:   "Mostra se a maioria está sendo ajudada ou bloqueada pela própria interface."
			rationale: "Defaults são alavancas potentes e precisam de controle ético."
		},
		{
			question:  "A informação está apresentada no formato certo para esta audiência? Qual âncora, qual frame e qual conta mental estão sendo ativados?"
			reveals:   "Distingue falha de conteúdo de falha de apresentação."
			rationale: "Muitos problemas de adoção são problemas de apresentação, não de economia subjacente."
		},
		{
			question:  "Social proof, herding ou regret aversion da DMU estão travando a decisão? Qual prova social convence cada stakeholder?"
			reveals:   "Identifica se o bloqueio é reputacional, social ou informacional."
			rationale: "Em B2B, a decisão raramente é apenas técnica."
		},
		{
			question:  "Qual dimensão de confiança está deficitária: competência, integridade ou continuidade? E há risco de automation bias ou algorithm aversion?"
			reveals:   "Direciona sinais de confiança e desenho do humano no loop."
			rationale: "Confiança unidimensional gera respostas erradas."
		},
		{
			question:  "Há risco de overreaction ou availability bias? Existe plano de comunicação pronto por audiência?"
			reveals:   "Mostra se incidente pequeno pode virar crise comportamental."
			rationale: "Crise de percepção pode destruir valor antes da crise objetiva."
		},
		{
			question:  "Existe percepção de unfairness relevante? A diferenciação parece mérito, risco ou privilégio arbitrário?"
			reveals:   "Mostra se pricing ou tratamento diferenciado criará backlash."
			rationale: "Na construção civil, fairness percebida circula rápido via rede informal."
		},
	]

	meshExamples: [
		{
			id:                "ex-supplier-onboarding-friction"
			scenario:          "Conversão de onboarding do primeiro anchor está em 35% e a maioria abandona no terceiro passo."
			analysis:          "A hipótese dominante é friction, possivelmente reforçada por present bias e trust deficit. Antes de concluir isso, é preciso verificar se a exigência documental é realmente proporcional para esse fornecedor. Se a exigência é desproporcional, o problema é parcialmente de oferta."
			recommendation:    "Reduzir passos até a primeira ação de valor, automatizar coleta de documentos, validar em menos de 24 horas e entregar valor no mesmo dia. Só depois testar trust ou overconfidence residual."
			assumptions: [
				"o abandono realmente se concentra no passo 3",
				"parte relevante da documentação pode ser buscada automaticamente",
			]
			principlesApplied: ["ax-03", "ax-06", "dp-02"]
			rationale:         "Mostra aplicação prática da lente em onboarding com hipótese falsificável."
		},
		{
			id:                "ex-buyer-institutional-adoption"
			scenario:          "Procurement quer adotar a Mesh, mas CFO bloqueia e o gerente que recomendou não quer se expor."
			analysis:          "Há DMU explícita. Procurement está convencido, mas CFO pode estar em overconfidence ou present bias, enquanto o gerente sofre regret aversion. Se houver sunk cost em ERP existente, isso reforça o bloqueio."
			recommendation:    "Para CFO, usar boost com benchmark e calculadora de ROI. Para o gerente, converter adoção em piloto reversível e safe-to-fail. Para o ERP existente, framing de complementaridade, não substituição."
			assumptions: [
				"há investimento prévio relevante em processo ou sistema existente",
				"o piloto pode ser desenhado com escopo pequeno e reversível",
			]
			principlesApplied: ["ax-05", "ax-06", "dp-02"]
			rationale:         "Mostra intervenção comportamental diferenciada por stakeholder da DMU."
		},
		{
			id:                "ex-crisis-communication"
			scenario:          "Um comprador entra em default e a notícia circula rapidamente em canais informais."
			analysis:          "Availability bias e overreaction dominam. Investidores testam competence e continuity trust. Fornecedores testam continuidade e risco de contágio. Se a Mesh comunicou antes do boato consolidar, controla framing; se não, reage a narrativa já formada."
			recommendation:    "Comunicar em até 24h com fatos, impacto real, ações tomadas e implicação por audiência. Se o modelo previu, usar isso como prova de competência. Se não previu, admitir erro com plano concreto de correção para evitar algorithm aversion generalizada."
			assumptions: [
				"o impacto real da exposição já pode ser quantificado rapidamente",
				"há canal direto com cada audiência relevante",
			]
			principlesApplied: ["ax-05", "dp-05"]
			rationale:         "Mostra a lente em comunicação de crise, não apenas em onboarding."
		},
	]

	principleIds: ["ax-03", "ax-05", "ax-06", "ax-07", "dp-02"]

	relatedLenses: [
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Mechanism-design desenha regras assumindo resposta suficientemente racional; behavioral-economics testa se participantes reais entendem, aceitam e executam o mecanismo."
		},
		{
			lensId:   "lens-platform-dynamics"
			relation: "complementsWith"
			context:  "Platform-dynamics modela chicken-and-egg e massa crítica; behavioral-economics explica resistência individual e organizacional à travessia inicial."
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "complementsWith"
			context:  "Financial-intermediation trata run risk e funding; behavioral-economics explica como medo, disponibilidade e ambiguidade amplificam esses riscos."
		},
		{
			lensId:   "lens-information-economics"
			relation: "complementsWith"
			context:  "Information-economics define o que revelar; behavioral-economics define como revelar para que a informação seja processada de forma útil."
		},
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "Behavioral-economics diagnostica padrões de atraso, reação a score e composição afetada por defaults e nudges; credit-risk traduz isso em provisão, pricing e limite."
		},
		{
			lensId:   "lens-theory-of-firm"
			relation: "complementsWith"
			context:  "Theory-of-firm trata bounded rationality contratual e governança; behavioral-economics trata processamento enviesado da informação e risco pessoal dos decisores."
		},
	]

	limitations: [
		{
			description: "Muitos vieses foram estudados em laboratório ou em contextos diferentes do canteiro e da DMU da construção civil."
			alternative: "Tratar magnitude como hipótese e validar com dados reais, testes e pesquisa qualitativa."
			rationale:   "A direção do efeito é útil, mas a intensidade é contextual."
		},
		{
			description: "Nudges não corrigem proposta de valor fraca."
			alternative: "Sempre testar se a barreira é comportamental ou se a oferta ainda não é competitiva."
			rationale:   "Behavioral design não substitui product-market fit."
		},
		{
			description: "A lente foca em vieses individuais e organizacionais próximos; não modela cultura de cluster ou dinâmica social mais ampla."
			alternative: "Complementar com lens-platform-dynamics, lens-complex-adaptive-systems e pesquisa de campo."
			rationale:   "Muitos efeitos comportamentais são amplificados por dinâmicas sociais maiores."
		},
		{
			description: "A fronteira entre nudge legítimo e manipulação é contextual."
			alternative: "Aplicar teste de transparência e, na dúvida, preferir boost ou intervenção mais explícita."
			rationale:   "Manipulação percebida destrói trust mais rápido do que qualquer ganho de conversão compensa."
		},
		{
			description: "A interação humano-IA em B2B de construção civil ainda é pouco documentada empiricamente."
			alternative: "Monitorar automation bias e algorithm aversion como hipóteses operacionais explícitas no mapa comportamental."
			rationale:   "AI-native sem observabilidade da interface humano-IA opera com blind spot estrutural."
		},
		{
			description: "Nudges perdem efetividade com repetição e habituação."
			alternative: "Monitorar decay longitudinal e rotacionar framing, canal ou formato; usar boosts quando possível."
			rationale:   "Intervenção que funciona no mês 1 pode falhar no mês 12."
		},
	]

	rationale: "Mechanism-design presume resposta racional suficiente a regras e incentivos. Esta lente entra quando a resposta real se desvia disso de forma sistemática e previsível. Na Mesh, isso inclui loss aversion, status quo, sunk cost, overconfidence, present bias, reference point adaptation, anchoring, mental accounting, trust multidimensional, proof social em DMUs, regret aversion de recomendadores, fairness e vieses na interação humano-IA. Como a Mesh é AI-native, com humanos no loop e com participantes muito heterogêneos em sofisticação, o espaço entre comportamento idealizado e comportamento real não é detalhe de UX: é parte central da arquitetura do produto, da operação e da governança."
}
