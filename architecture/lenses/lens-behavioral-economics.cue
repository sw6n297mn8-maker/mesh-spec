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
}
