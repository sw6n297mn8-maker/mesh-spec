package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

organizationalResourceAllocation: artifact_schemas.#AnalyticalLens & {
id:     "lens-organizational-resource-allocation"
name:   "Alocação de Recursos Organizacionais"

purpose: "Orientar decisões sobre como alocar recursos escassos (tempo do founder, budget, atenção de agentes) entre prioridades concorrentes numa startup de infraestrutura financeira."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve escolher entre atividades concorrentes dado que recursos são finitos",
		"a decisão envolve priorizar backlog, roadmap ou agenda de trabalho",
		"a decisão envolve quanto recurso (tempo, capital, capacidade computacional) alocar a cada atividade",
		"a decisão envolve o que a organização deliberadamente não faz",
		"a decisão envolve se uma tarefa é delegável a agente IA ou requer julgamento humano",
		"a decisão envolve ordenar atividades que têm dependências entre si",
		"a decisão envolve calibrar velocidade de decisão proporcional à irreversibilidade",
		"a decisão envolve rebalancear alocação entre exploração (aprender) e exploração (extrair)",
		"a decisão envolve identificar e elevar o gargalo que limita throughput do sistema",
		"a decisão envolve avaliar se o custo de esperar supera o custo de agir com informação incompleta",
	]
	keywords: [
		"priorização", "backlog", "roadmap", "sequenciamento",
		"bandwidth", "capacidade", "gargalo", "bottleneck",
		"custo de oportunidade", "trade-off", "o que não fazer",
		"delegação", "automação", "agente", "humano no loop",
		"satisficing", "ótimo vs suficiente",
		"custo de atraso", "cost of delay", "WSJF",
		"slack", "folga", "reserva",
		"exploração", "exploitation", "exploration",
		"velocidade de decisão", "reversibilidade",
		"sprint", "ciclo", "cadência",
	]
	excludeWhen: [
		"a decisão é sobre timing de investimento sob incerteza — usar real-options",
		"a decisão é sobre design de incentivos entre participantes da plataforma — usar mechanism-design",
		"a decisão é sobre estrutura organizacional, custos de agência ou fronteiras da firma — usar organizational-economics",
		"a decisão é sobre alocação de capital financeiro entre operação e reserva — usar financial-intermediation",
		"a decisão é sobre sequenciamento de opções de investimento com gates — usar real-options (ro-staging-gates-adaptive)",
	]
	rationale: "Toda organização enfrenta a questão de alocar recursos escassos entre alternativas concorrentes. O que muda é a escala e a natureza dos recursos, não o framework de raciocínio. Na Mesh pré-revenue com solo founder e agentes IA como operadores primários, recursos são: horas do founder, capital limitado, e capacidade computacional de agentes. Cada hora alocada a uma atividade é indisponível para outra. Sem framework explícito, a alocação é governada por urgência percebida, novidade, ou hábito — não por valor econômico."
}

concepts: [
	{
		id:         "ora-throughput-constraint"
		name:       "Throughput Constraint: O Gargalo que Limita o Sistema"
		nature:     "theoretical"
		role:       "framework"
		definition: "Goldratt (1984, Theory of Constraints): em qualquer sistema, existe um único constraint que limita o throughput total. Otimizar componentes que não são o constraint não melhora o sistema — apenas acumula work-in-progress antes do gargalo. O constraint muda quando é elevado: resolver o gargalo atual revela o próximo. O ciclo é: (1) identificar o constraint, (2) decidir como explorá-lo ao máximo, (3) subordinar tudo ao constraint, (4) elevar o constraint, (5) repetir. Goldratt (1997, Critical Chain): em projetos, o constraint geralmente é a cadeia crítica de dependências, não tarefas individuais."
		meshManifestation: "Na Mesh pré-revenue, o constraint primário é quase sempre horas do founder — não capital, não compute, não tecnologia. Agentes IA executam tarefas mas requerem supervisão, direcionamento e decisão do founder. Acumular tarefas para agentes sem resolver o gargalo de supervisão gera work-in-progress parado. Quando a Mesh escala e contrata: o constraint migra de horas do founder para outros recursos (capital de funding, capacidade de onboarding, compliance officer)."
		meshImplication: "Step 0 de qualquer decisão de alocação: qual é o constraint atual? Se horas do founder: toda alocação que não passa pelo founder (tarefas plenamente delegáveis a agentes) é free e deve ser maximizada. Toda alocação que consome horas do founder compete com todas as outras. Subordinar: tarefas que não estão no caminho do constraint não devem interromper o constraint (founder não deve ser interrompido para aprovar tarefa que agente poderia concluir autonomamente). Elevar: investir em reduzir a dependência do founder — melhor CLAUDE.md, melhor governance para agentes, melhor onboarding de novos agentes. Monitorar: quando constraint muda (ex: capital vira gargalo porque demanda excede funding), o regime de alocação muda inteiro."
		rationale: "Goldratt 1984: otimizar fora do constraint é ilusão de progresso. Na Mesh solo founder, identificar e explorar o constraint é a decisão de alocação mais importante — precede todas as outras."
	},
	{
		id:         "ora-opportunity-cost"
		name:       "Custo de Oportunidade: O Preço Implícito de Toda Alocação"
		nature:     "theoretical"
		role:       "property"
		definition: "Robbins (1932): economia é a ciência da alocação de meios escassos entre fins alternativos. Buchanan (1969, Cost and Choice): custo de oportunidade é o valor da melhor alternativa renunciada ao escolher uma ação. Não é custo contábil — é custo subjetivo, prospectivo, e só existe no momento da decisão. Custo de oportunidade é invisível: o que não foi feito não aparece em nenhum relatório. Só aparece quando a alternativa renunciada teria mudado materialmente o resultado."
		meshManifestation: "Na Mesh, cada hora do founder alocada a refinar arquitetura CUE é uma hora não alocada a conversar com construtoras (validação de demanda), estruturar FIDC (funding), ou prospectar parceiros regulatórios. Cada uma dessas alternativas tem valor econômico diferente em momentos diferentes. No bootstrap pré-revenue, o custo de oportunidade de não validar demanda é potencialmente existencial — sem demanda confirmada, arquitetura perfeita é irrelevante."
		meshImplication: "Para toda alocação significativa (>4h/semana ou >5% do capital), articular explicitamente: o que estou não fazendo ao fazer isso? Qual o valor da melhor alternativa renunciada? Se o valor da alternativa é maior e o switching cost é baixo: realocar. Se o valor é incerto: experimentar antes de comprometer (conecta com ro-experimentation-as-option). Custo de oportunidade muda com o estágio: pré-demanda (validação domina), pós-demanda pré-funding (funding domina), pós-funding (execução domina). Revisão semanal: as 3 atividades com mais horas alocadas são as 3 de maior custo de oportunidade alternativo mais baixo?"
		dependsOn: ["ora-throughput-constraint"]
		rationale: "Buchanan 1969: custo é subjetivo e prospectivo. Na Mesh, custo de oportunidade é o conceito que torna alocação econômica em vez de inercial."
	},
	{
		id:         "ora-cost-of-delay"
		name:       "Custo de Atraso e WSJF"
		nature:     "theoretical"
		role:       "method"
		definition: "Reinertsen (2009, Principles of Product Development Flow): Cost of Delay (CoD) é a derivada parcial do valor total esperado em relação ao tempo — quanto valor se perde por mês de atraso. Weighted Shortest Job First (WSJF) = CoD / Duração. WSJF maximiza valor total entregue num período dado capacidade escassa. Reinertsen: ~85% dos product managers não sabem o CoD dos seus projetos, e estimativas intuitivas variam 50:1. CoD torna explícito o que é implícito em toda decisão de sequenciamento. Quatro perfis de CoD: linear (constante por mês), urgente (alto e crescente — janela de oportunidade), standard (moderado, estável), intangível (baixo, difuso). O perfil determina a prioridade — urgente antes de standard mesmo que standard tenha valor absoluto maior."
		meshManifestation: "Na Mesh, atividades têm perfis de CoD muito diferentes. Licenciamento SCD: CoD urgente se Bacen abre janela regulatória — atraso de 3 meses pode significar 6 meses de espera adicional (filas regulatórias). Validação de demanda: CoD alto e crescente — cada mês sem validação é mês de burn sem aprendizado (existencial pré-revenue). Refatoração de schema CUE: CoD baixo e estável — qualidade melhora mas o custo de 1 mês de atraso é marginal. Feature de dashboard para fornecedor: CoD depende de se há fornecedores ativos esperando ou não."
		meshImplication: "Para cada atividade no backlog, estimar CoD em uma de quatro categorias: urgente (janela fecha), alto-estável (valor acumula linearmente), moderado (valor acumula mas lentamente), baixo (pode esperar meses sem impacto material). WSJF simplificado: CoD_relativo / Duração_relativa. Sequenciar por WSJF, não por valor absoluto nem por interesse pessoal. No bootstrap: não precisa de estimativa financeira precisa — ranking relativo de CoD já muda sequenciamento materialmente. Reinertsen: 'se você quantificar apenas uma coisa, quantifique o custo de atraso.' Revisão: reclassificar CoD mensalmente — perfil muda com contexto (feature com CoD baixo vira urgente quando anchor tenant pede)."
		dependsOn: ["ora-opportunity-cost"]
		rationale: "Reinertsen 2009: CoD é o 'golden key' de priorização. WSJF supera FIFO, HVF, e SJF em valor total entregue. Na Mesh com capacidade limitada, sequenciar por WSJF é a alavanca de alocação com maior impacto imediato."
	},
	{
		id:         "ora-attention-as-resource"
		name:       "Atenção como Recurso Escasso"
		nature:     "theoretical"
		role:       "framework"
		definition: "Ocasio (1997, Attention-Based View of the Firm): comportamento organizacional é resultado de como a firma canaliza e distribui a atenção dos seus decisores. O que decisores fazem depende de para quais issues e respostas focam atenção. Simon (1971): abundância de informação gera escassez de atenção. Davenport/Beck (2001): atenção é o recurso mais escasso da economia da informação. Atenção é finita, excludente (focar em A impede focar em B), e degradável (atenção fragmentada produz decisões piores que atenção concentrada). Diferente de tempo: é possível alocar tempo sem alocar atenção (reunião onde se pensa em outra coisa)."
		meshManifestation: "Na Mesh AI-native, a atenção do founder é o recurso mais escasso e menos fungível. Agentes IA têm compute abundante mas atenção zero — precisam de direcionamento. Cada tarefa que interrompe o founder para decisão de baixo impacto consome atenção desproporcional ao valor (context switching + re-entry cost). O founder com 10 threads abertas simultâneas (arquitetura, scoring, regulação, funding, produto) tem atenção fragmentada que degrada qualidade de cada decisão. Atenção não é linear: 4h concentradas > 8h fragmentadas."
		meshImplication: "Projetar o dia/semana para proteger blocos de atenção concentrada. Batching: agrupar decisões de mesmo contexto (todas as decisões de arquitetura no mesmo bloco, não intercaladas com funding). Agentes devem acumular decisões não-urgentes para batch review em vez de interromper em tempo real. Threshold: interrupção do founder só se (a) decisão é tipo 2+ na precedence hierarchy, OU (b) custo de atraso da decisão > custo de interrupção (~30min de re-entry). Métrica: número de context switches por dia. Se > 8: atenção está fragmentada, reestruturar. Se < 3: possivelmente sub-delegando (agentes esperando desnecessariamente)."
		rationale: "Ocasio 1997: firma é sistema de distribuição de atenção. Simon 1971: informação abundante gera atenção escassa. Na Mesh, a atenção do founder é mais escassa que tempo e mais valiosa que capital pré-revenue."
	},
	{
		id:         "ora-reversibility-indexed-speed"
		name:       "Velocidade de Decisão Indexada à Reversibilidade"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Eisenhardt (1989, 'Making Fast Strategic Decisions in High-Velocity Environments'): decisores rápidos não são menos analíticos — usam mais informação em tempo real, consideram mais alternativas simultaneamente, e integram decisão com execução. Bezos (Type 1/Type 2): decisões irreversíveis (Type 1) merecem análise profunda; decisões reversíveis (Type 2) devem ser tomadas rápido com ~70% da informação desejada. O custo de decidir devagar uma decisão reversível é maior que o custo de decidir errado e corrigir. O custo de decidir rápido uma decisão irreversível é potencialmente catastrófico."
		meshManifestation: "Na Mesh, a precedence hierarchy já distingue 4 tipos de decisão. ORA operacionaliza: tipo 4 (tático, reversível) deve ser decidido em minutos pelo agente — não escalar. Tipo 3 (design significativo, reversível em >4 semanas-engenheiro) merece análise com lens em horas. Tipo 2 (arquitetural) merece dias. Tipo 1 (axiomática) merece semanas. O erro mais comum: tratar decisão tipo 4 como tipo 2 (análise excessiva que consome o constraint — horas do founder) ou tratar decisão tipo 2 como tipo 4 (velocidade excessiva em decisão irreversível)."
		meshImplication: "Para cada decisão: classificar na precedence hierarchy. Se tipo 4: agente decide com log. Se tipo 3: agente analisa com lens e propõe; founder aprova em batch review. Se tipo 2: análise formal, founder decide com artefato. Se tipo 1: escalar, tempo ilimitado. Heurística de investimento analítico: tempo máximo de análise ≤ 10% do custo de reverter a decisão. Se reverter custa 1 semana: analisar no máximo 4h. Se reverter custa 6 meses: analisar semanas é justificado. Se a decisão é reversível em <1 dia: decidir agora, não amanhã."
		dependsOn: ["ora-throughput-constraint", "ora-attention-as-resource"]
		crossDependsOn: [{
			lensId:    "lens-real-options"
			conceptId: "ro-irreversibility-and-timing"
			context:   "RO modela irreversibilidade no contexto de investimento sob incerteza (Dixit/Pindyck). ORA usa irreversibilidade para calibrar velocidade de decisão em qualquer contexto operacional — não apenas investimentos. RO pergunta 'quando investir dado risco'; ORA pergunta 'quanto tempo gastar analisando dado reversibilidade'."
		}]
		rationale: "Eisenhardt 1989 + Bezos: velocidade de decisão calibrada à reversibilidade. Na Mesh com constraint de atenção do founder, decidir rápido o reversível é tão importante quanto decidir bem o irreversível."
	},
	{
		id:         "ora-satisficing"
		name:       "Satisficing: Quando Suficiente Supera Ótimo"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Simon (1956, 'Rational Choice and the Structure of the Environment'): sob racionalidade limitada, agentes não otimizam — satisfazem. Definem threshold de aceitabilidade e escolhem a primeira alternativa que atinge o threshold. Schwartz (2004, Paradox of Choice): o custo de buscar o ótimo cresce com o número de alternativas e frequentemente excede o ganho marginal sobre o satisfatório. Otimizar é justificável quando: (a) a diferença entre ótimo e satisfatório é material, (b) o custo de busca é baixo relativo ao ganho, (c) a decisão é irreversível. Fora dessas condições, satisficing é racionalmente superior."
		meshManifestation: "Na Mesh: escolher BaaS provider — 3 opções atendem requirements mínimos. Otimizar entre os 3 consome 2 semanas do founder. Diferença entre melhor e segundo melhor: marginal (todos serão abstraídos por camada de interface). Satisficing: escolher o primeiro que atende requirements e seguir. Inversamente: escolher estrutura jurídica de cessão (definitiva vs coobrigação) — impacto material em todo o modelo de risco. Otimizar justificado."
		meshImplication: "Para cada decisão: (1) a diferença entre alternativas candidatas é material para o negócio? Se < 10% de impacto: satisfice. (2) O custo de busca (tempo do founder + atraso) excede o ganho marginal? Se sim: satisfice. (3) A decisão é reversível em < 4 semanas-engenheiro? Se sim: satisfice e corrigir se necessário. Heurística operacional: para decisões tipo 4: satisfice sempre. Tipo 3: satisfice exceto se impacto > 20% em métrica core. Tipo 2: otimizar. Tipo 1: otimizar com rigor. Default de agentes IA: apresentar primeira alternativa que atende requirements + flag se existem alternativas materialmente superiores. Não apresentar 7 alternativas para decisão tipo 4."
		dependsOn: ["ora-reversibility-indexed-speed"]
		rationale: "Simon 1956: racionalidade limitada torna satisficing superior quando custo de busca excede ganho marginal. Na Mesh com constraint de atenção, otimizar tudo é a forma mais eficiente de não entregar nada."
	},
	{
		id:         "ora-strategic-neglect"
		name:       "Negligência Estratégica: O Que a Organização Deliberadamente Não Faz"
		nature:     "theoretical"
		role:       "property"
		definition: "Porter (1996, 'What Is Strategy?'): estratégia é tanto sobre o que não fazer quanto sobre o que fazer. Trade-offs são a essência do posicionamento. Rumelt (2011, Good Strategy Bad Strategy): 'bad strategy' tenta acomodar todas as demandas em vez de fazer escolhas. Strategic neglect é escolha deliberada, documentada e comunicada do que a organização não faz — não por incapacidade mas por decisão de foco. Distinto de negligência por omissão (não fazer por não ter pensado) e de procrastinação (não fazer por evitar). Strategic neglect requer: (a) a alternativa foi considerada, (b) a decisão de não fazer foi explícita, (c) os critérios são documentados, (d) a revisão é periódica."
		meshManifestation: "Na Mesh: não construir mobile app no bootstrap (foco em API/web). Não servir varejo (foco em construção civil). Não otimizar UX de dashboard antes de ter 5+ anchor tenants (foco em validação, não em polish). Não perseguir SCD antes de validar demanda via correspondente (sequenciamento). Cada 'não' libera bandwidth e atenção para os 'sim' que importam."
		meshImplication: "Manter lista explícita de 'não-agora' com: atividade, rationale, critério de revisão (quando reconsiderar), e data de próxima revisão. Revisão trimestral da lista: condições mudaram? Se sim: reconsiderar. Se não: manter e não gastar atenção re-litigando. Para agentes: lista de 'não-agora' é input — agente não deve propor atividades na lista sem flag explícito de mudança de condição. Tamanho da lista: se < 5 itens, possivelmente não está fazendo trade-offs reais. Se > 20: lista virou backlog disfarçado — priorizar o que realmente é estratégico."
		dependsOn: ["ora-opportunity-cost"]
		rationale: "Porter 1996: trade-offs são a essência da estratégia. Rumelt 2011: bad strategy é a recusa de fazer escolhas. Na Mesh com constraint extremo de bandwidth, o que não fazer é tão decisivo quanto o que fazer."
	},
	{
		id:         "ora-delegation-fitness"
		name:       "Fitness de Delegação: O Que é Delegável vs O Que Requer Julgamento Central"
		nature:     "theoretical"
		role:       "method"
		definition: "Aghion/Tirole (1997, 'Formal and Real Authority in Organizations'): autoridade formal (direito de decidir) pode ser delegada; autoridade real (capacidade informada de decidir) depende de quem tem a informação. Delegação é ótima quando o agente tem informação superior e o custo de comunicar essa informação excede o custo de desalinhamento. Jensen/Meckling (1992): co-localizar autoridade de decisão com conhecimento específico. Na Mesh AI-native, o 'agente' é literal — agentes IA com informação sobre o contexto operacional mas sem julgamento sobre consequências de segunda ordem."
		meshManifestation: "Agentes IA da Mesh têm informação superior em: dados operacionais em tempo real, estado do repositório, compliance de documentos, cálculos de scoring. Founder tem julgamento superior em: consequências estratégicas, trade-offs entre stakeholders, calibração de risco existencial, relações com regulador. Zona cinzenta: decisões que requerem dados (agente tem) + julgamento (founder tem) — ex: recalibrar scoring quando drift detectado (dados) com implicação em carteira (julgamento)."
		meshImplication: "Classificar por 2×2: (informação do agente suficiente × consequência tolerável se errado). Se informação suficiente + consequência tolerável: delegar completamente (tipo 4). Se informação suficiente + consequência séria: agente propõe com análise, founder aprova (tipo 3). Se informação insuficiente + consequência tolerável: founder decide rápido (satisfice). Se informação insuficiente + consequência séria: founder analisa com lens (tipo 2/1). Investir em aumentar o quadrante 'delegar completamente': melhor CLAUDE.md, governance de agentes, e thresholds de autonomia documentados. Cada tarefa movida de 'founder aprova' para 'agente decide' libera o constraint."
		dependsOn: ["ora-throughput-constraint", "ora-reversibility-indexed-speed"]
		crossDependsOn: [{
			lensId:    "lens-organizational-economics"
			conceptId: "oe-delegation-and-trust"
			context:   "OE modela o problema de agência na delegação — custos de agência, alinhamento de incentivos, confiança. ORA modela os critérios de fitness para decidir o que delegar — dado que o problema de agência é gerenciado (via governance). OE pergunta 'como alinhar incentivos do agente'; ORA pergunta 'esta tarefa específica é delegável dados os critérios de fitness'."
		}]
		rationale: "Aghion/Tirole 1997: co-localizar decisão com informação. Na Mesh AI-native, a questão não é se delegar — é quanto e com quais guardrails. Cada delegação efetiva eleva o constraint."
	},
	{
		id:         "ora-sequencing-under-dependency"
		name:       "Sequenciamento sob Dependência"
		nature:     "theoretical"
		role:       "method"
		definition: "Goldratt (1997, Critical Chain): em projetos com dependências, o caminho crítico (cadeia mais longa de tarefas dependentes) determina a duração total. Otimizar tarefas fora do caminho crítico não encurta o projeto. Reinertsen (2009): em product development, dependências não são apenas técnicas — incluem regulatórias (Bacen precisa aprovar antes de operar), de mercado (anchor tenant precisa adotar antes de escalar), e de informação (dados precisam acumular antes de treinar modelo). Adner (2012, The Wide Lens): dependências de ecossistema (complementores) são frequentemente invisíveis e subestimadas."
		meshManifestation: "Cadeia crítica da Mesh pré-revenue: validar demanda → estruturar correspondente bancário → operar piloto → acumular dados → treinar scoring → estruturar FIDC. Cada step depende do anterior. Fazer scoring antes de ter dados operacionais é otimizar fora do caminho crítico. Dependências regulatórias: SCD exige aprovação Bacen (meses) — iniciar processo antes de precisar. Dependências de ecossistema: gestor FIDC + registradora + custodiante — cada um com lead time próprio."
		meshImplication: "Mapear dependências explicitamente: para cada atividade no backlog, quais atividades devem estar concluídas antes? Identificar o caminho crítico: cadeia mais longa de dependências. Alocar recurso ao caminho crítico primeiro — atividades fora dele são secondary. Paralelizar: atividades no caminho crítico que são independentes entre si podem rodar em paralelo (agentes IA). Lead times regulatórios: iniciar com antecedência máxima (ax-03: pagar complexidade cedo). Não confundir urgência percebida com dependência real: atividade urgente mas fora do caminho crítico não merece re-priorização sobre atividade menos urgente no caminho crítico."
		dependsOn: ["ora-throughput-constraint", "ora-cost-of-delay"]
		crossDependsOn: [{
			lensId:    "lens-real-options"
			conceptId: "ro-staging-gates-adaptive"
			context:   "RO sequencia investimentos sob incerteza com meta-gate e falsificação. ORA sequencia atividades sob dependência com caminho crítico e paralelização. RO pergunta 'em que ordem investir dado incerteza'; ORA pergunta 'em que ordem executar dado dependências'. Complementares: RO define os gates, ORA define a execução entre gates."
		}]
		rationale: "Goldratt 1997: caminho crítico determina throughput. Reinertsen 2009: dependências em product development incluem mercado e regulação. Na Mesh, dependências regulatórias têm lead times que não podem ser comprimidos — ignorá-las no sequenciamento é modo de falha."
	},
	{
		id:         "ora-allocation-regime"
		name:       "Regime de Alocação: Explorar vs Extrair"
		nature:     "theoretical"
		role:       "framework"
		definition: "March (1991, 'Exploration and Exploitation in Organizational Learning'): organizações dividem recursos entre exploração (buscar novidade, experimentar, tolerar falha) e exploração (refinar, otimizar, extrair valor do conhecido). O'Reilly/Tushman (2004, 'The Ambidextrous Organization'): organizações bem-sucedidas fazem ambos simultaneamente (ambidexterity), mas com estruturas separadas. Gupta/Smith/Shalley (2006): o equilíbrio ótimo depende do estágio — early-stage exige mais exploration; escala exige mais exploitation. Não é alocação 50/50 fixa — é regime que muda com o estágio e com o que já foi validado."
		meshManifestation: "Na Mesh pré-revenue: regime deveria ser ~70-80% exploration (validar demanda, testar scoring, pilotar com anchor tenants, experimentar posicionamento) e ~20-30% exploitation (documentar o que funciona, automatizar processos validados, consolidar artefatos). Se o regime é invertido prematuramente (70% exploitation de algo não validado), a Mesh otimiza para o cenário errado. Se o regime nunca muda (100% exploration indefinidamente), a Mesh nunca captura valor do que aprendeu."
		meshImplication: "Declarar o regime atual explicitamente: 'estamos em X% exploration / Y% exploitation.' Critérios de transição: mover 10% de exploration para exploitation quando premissa é validada por gate (conecta com ro-experimentation-as-option). No bootstrap: demanda validada (≥5 construtoras com volume ≥R$500k/mês) move antecipação de 'exploration' para 'exploitation'. Scoring com AUROC >0.70 move scoring de 'exploration' para 'exploitation.' Segmento novo (infraestrutura, varejo) permanece em 'exploration' até gate próprio. Revisão trimestral do regime. Flag: se >50% do tempo está em exploitation de algo não validado por gate, o regime está invertido."
		dependsOn: ["ora-opportunity-cost"]
		crossDependsOn: [{
			lensId:    "lens-organizational-economics"
			conceptId: "oe-exploration-exploitation"
			context:   "OE modela a teoria (March 1991) e a tensão organizacional entre exploration e exploitation. ORA operacionaliza como alocação concreta: % de recursos, critérios de transição, thresholds de gate. OE pergunta 'por que exploration e exploitation competem'; ORA pergunta 'quanto alocar a cada um agora'."
		}]
		rationale: "March 1991: o equilíbrio exploration/exploitation é a decisão de alocação de maior consequência. O'Reilly/Tushman 2004: requer estruturas separadas. Na Mesh, declarar o regime explicitamente e definir critérios de transição previne dois modos de falha: otimizar prematuramente (exploitation sem validação) e explorar indefinidamente (exploration sem captura)."
	},
	{
		id:         "ora-slack-as-strategic-asset"
		name:       "Slack Organizacional: Buffer Estratégico vs Desperdício"
		nature:     "theoretical"
		role:       "property"
		definition: "Nohria/Gulati (1996): relação entre slack e inovação é U-invertido. Sem slack: nenhuma experimentação possível (variância alta demais sem buffer para absorver falha). Com slack excessivo: disciplina de seleção desaparece e investimentos wasteful proliferam. O ponto ótimo depende do estágio e da incerteza do ambiente. Sharfman et al. (1988): slack absorvido (recursos comprometidos mas subutilizados) difere de slack não-absorvido (recursos líquidos disponíveis). Cyert/March (1963): slack estabiliza a organização absorvendo flutuações."
		meshManifestation: "Na Mesh pré-revenue com capital limitado: slack é precioso e perigoso. Slack de tempo: 10-15% da semana não alocada permite responder a oportunidades imprevistas (regulador abre consulta pública, anchor tenant quer reunião). Sem slack: toda oportunidade é perdida ou desloca atividade planejada. Slack de capital: reserva para UL em credit-risk é slack financeiro necessário. Slack excessivo: 30% da semana não alocada numa startup pré-revenue é desperdício — incerteza alta exige experimentação, não espera."
		meshImplication: "Slack de tempo alvo: 10-15% da semana (4-6h) não-alocada a atividades planejadas — buffer para oportunidades e interrupções inevitáveis. Se slack < 5%: agenda está sobrecarregada — qualquer imprevisto desloca algo importante. Se slack > 20%: sub-alocação — provavelmente evitando tarefas difíceis ou acumulando opções sem exercer (flag Tipo 7). Slack de capital: conforme financial-intermediation (fi-capital-allocation). Slack computacional: agentes devem ter capacidade para tarefas imprevistas — não alocar 100% da capacidade a pipelines batch."
		rationale: "Nohria/Gulati 1996: U-invertido. Sem slack, adaptação impossível. Com excesso, disciplina desaparece. Na Mesh, 10-15% é heurística calibrada para startup pré-revenue com alta incerteza."
	},
	{
		id:         "ora-sunk-cost-immunity"
		name:       "Imunidade a Sunk Cost na Realocação"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Arkes/Blumer (1985): indivíduos e organizações persistem em investimentos falidos porque já investiram (sunk cost fallacy). Thaler (1980): custos irrecuperáveis não deveriam afetar decisões prospectivas — mas afetam sistematicamente. Em alocação de recursos, sunk cost bias se manifesta como: continuar alocando a projeto X porque 'já investimos Y horas/capital', mesmo quando valor prospectivo de X é inferior ao de alternativas. O custo já gasto é irrelevante — a única pergunta é: dado os recursos restantes, onde o valor prospectivo é maior?"
		meshManifestation: "Na Mesh: founder investiu 3 meses desenhando arquitetura para cenário A. Evidência nova sugere cenário B é mais promissor. Sunk cost: 'mas já investimos 3 meses em A.' Decisão correta: comparar valor prospectivo de continuar A vs pivotar para B, ignorando os 3 meses já gastos. Agentes IA não têm sunk cost bias naturalmente — mas o founder que direciona os agentes tem. O viés contamina a alocação via direcionamento, não via execução."
		meshImplication: "Em toda decisão de continuar vs realocar: articular explicitamente 'quanto já investimos é irrelevante — o que importa é: dado os recursos restantes, A ou B tem maior valor prospectivo?' Flag obrigatório quando justificativa para continuar inclui referência ao que já foi investido — isso é sinal de sunk cost, não argumento prospectivo. Conecta com ro-option-to-abandon: critérios ex ante de abandono previnem que sunk cost governe a decisão no momento. Para agentes: ao propor continuar projeto, nunca incluir 'já investimos X' como argumento. Incluir apenas: valor prospectivo de continuar vs valor prospectivo de realocar."
		dependsOn: ["ora-opportunity-cost"]
		crossDependsOn: [{
			lensId:    "lens-behavioral-economics"
			conceptId: "be-sunk-cost"
			context:   "BE diagnostica o viés cognitivo. ORA operacionaliza a imunidade como prática de alocação — flag obrigatório, critérios prospectivos, protocolo de realocação."
		}]
		rationale: "Arkes/Blumer 1985: sunk cost bias é universal e sistemático. Na Mesh solo founder, o viés é amplificado por investimento emocional pessoal. A imunidade não é natural — requer protocolo."
	},
	{
		id:         "ora-resource-velocity"
		name:       "Velocidade de Recurso: Ciclo Alocação-Uso-Aprendizado-Realocação"
		nature:     "theoretical"
		role:       "property"
		definition: "Stalk/Hout (1990, Competing Against Time): vantagem competitiva vem não apenas de alocar melhor mas de ciclar mais rápido. Reinertsen (2009): batch size pequeno e ciclos curtos reduzem work-in-progress e aceleram aprendizado. Thomke (2020, Experimentation Works): quanto mais rápido o ciclo de experimentação, mais aprendizado por unidade de tempo. Velocidade de recurso = velocidade com que recursos completam o ciclo alocar → usar → aprender → realocar. Alta velocidade: sprint de 1 semana, feedback em 2 dias, realocação imediata. Baixa velocidade: projeto de 6 meses, feedback no final, realocação após post-mortem."
		meshManifestation: "Na Mesh AI-native, velocidade de recurso é estruturalmente alta para agentes (task → execução → resultado em horas) e estruturalmente baixa para o founder (decisão → implementação por agentes → resultado observável → feedback em dias/semanas). O gargalo de velocidade não é execução (agentes são rápidos) — é o ciclo de feedback e realocação (founder precisa observar resultado, aprender, e redirecionar). Processos regulatórios têm velocidade mínima imposta (meses) — não comprimível."
		meshImplication: "Maximizar velocidade onde possível: ciclos semanais de alocação (não mensais). Sprint semanal com revisão na sexta-feira: o que foi alocado, o que foi entregue, o que aprendemos, o que realocamos. Para agentes: ciclo de feedback deve ser < 24h para tarefas tipo 4. Para decisões do founder: resultado observável em < 1 semana sempre que possível — se feedback demora mais de 2 semanas, o ciclo está lento demais para early-stage. Exceção: lead times regulatórios são estruturalmente lentos — aceitar e não tentar comprimir. Métrica: número de ciclos alocar-aprender-realocar por mês. Se < 4: velocidade sub-ótima para startup. Se > 12: possivelmente reagindo demais e sem dar tempo para resultados maturarem."
		dependsOn: ["ora-throughput-constraint", "ora-cost-of-delay"]
		rationale: "Stalk/Hout 1990: time-based competition. Reinertsen 2009: batch size pequeno. Na Mesh AI-native, a velocidade de execução dos agentes só gera valor se o ciclo de feedback e realocação for igualmente rápido."
	},
	{
		id:            "ora-mesh-allocation-review"
		name:          "Revisão de Alocação: Inventário Periódico de Recursos e Regime"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) constraint atual e se mudou, (2) backlog priorizado por WSJF, (3) lista de 'não-agora' revisada, (4) regime exploration/exploitation com % e critérios de transição, (5) slack realizado vs alvo, (6) delegação: o que moveu de 'founder decide' para 'agente decide', (7) velocidade de recurso: ciclos por mês e tendência, (8) sunk costs flaggados e decisão prospectiva."
		meshManifestation: "Na Mesh: revisão trimestral formal. Semanal: micro-revisão (WSJF do backlog, context switches, slack). Mensal: meso-revisão (regime exploration/exploitation, constraint, delegação). Trimestral: macro-revisão completa com todos os campos."
		meshImplication: "Semanal (30min): reordenar backlog por WSJF. Contar context switches. Verificar slack. Mensal (2h): regime exploration/exploitation — condições mudaram? Constraint — ainda é o mesmo? Delegação — o que pode mover? Trimestral (4h): revisão completa. Atualizar lista 'não-agora'. Verificar sunk costs. Recalibrar CoD de atividades principais. Ajustar regime se gates foram atingidos. Se a revisão não produz pelo menos uma realocação: ou está tudo perfeito (improvável) ou a revisão é superficial."
		dependsOn: ["ora-throughput-constraint", "ora-cost-of-delay", "ora-allocation-regime", "ora-strategic-neglect"]
		rationale: "Sem revisão periódica, conceitos de alocação são exercício intelectual, não prática operacional. O inventário periódico é o que torna a lens viva."
	},
]

reasoningProtocol: [
	{
		question:  "Qual é o throughput constraint atual? O que está limitando o output do sistema como um todo?"
		reveals:   "Se horas do founder, capital, capacidade computacional, ou dependência externa. Toda alocação subsequente é subordinada ao constraint."
		rationale: "Goldratt: otimizar fora do constraint é ilusão. Identificar o constraint é step 0."
	},
	{
		question:  "Para cada atividade candidata: qual é o custo de atraso? O perfil é urgente (janela fecha), alto-estável, moderado, ou baixo?"
		reveals:   "Prioridade relativa. Urgente antes de alto-estável mesmo que alto-estável tenha valor absoluto maior."
		rationale: "Reinertsen 2009: CoD é o golden key. Sequenciar por WSJF supera todas as alternativas."
	},
	{
		question:  "WSJF: custo de atraso relativo / duração relativa. Qual atividade tem maior WSJF?"
		reveals:   "Sequenciamento ótimo dado capacidade escassa."
		rationale: "WSJF maximiza valor total entregue por unidade de tempo."
	},
	{
		question:  "O que estou deliberadamente não fazendo? A lista de 'não-agora' está atualizada e as condições de revisão são claras?"
		reveals:   "Se os trade-offs são explícitos ou se a organização tenta fazer tudo."
		rationale: "Porter 1996: estratégia é tanto sobre o que não fazer."
	},
	{
		question:  "Qual é o regime atual de alocação? Estou em X% exploration / Y% exploitation? Isso é coerente com o que já está validado?"
		reveals:   "Se o regime é apropriado para o estágio. Exploitation prematura de algo não validado é modo de falha."
		rationale: "March 1991: equilíbrio exploration/exploitation é a decisão de alocação de maior consequência."
	},
	{
		question:  "Para cada atividade que consome o constraint (horas do founder): é delegável? Informação do agente é suficiente e consequência é tolerável?"
		reveals:   "Se o constraint está sendo consumido por tarefas que poderiam ser delegadas."
		rationale: "Aghion/Tirole 1997: co-localizar decisão com informação. Cada delegação efetiva eleva o constraint."
	},
	{
		question:  "As atividades estão sequenciadas respeitando dependências? A atividade prioritária está no caminho crítico?"
		reveals:   "Se recursos estão no caminho crítico ou sendo gastos em atividades que não encurtam o timeline."
		rationale: "Goldratt 1997: atividade fora do caminho crítico não encurta o projeto."
	},
	{
		question:  "Esta decisão é reversível em quanto tempo? O investimento analítico é proporcional à irreversibilidade?"
		reveals:   "Se estamos gastando análise excessiva em decisão reversível ou velocidade excessiva em decisão irreversível."
		rationale: "Eisenhardt 1989: decisores rápidos não são menos analíticos — calibram velocidade à consequência."
	},
	{
		question:  "Para esta decisão: estou otimizando ou satisficing? A diferença entre alternativas justifica o custo de busca?"
		reveals:   "Se o custo de otimizar excede o ganho marginal sobre o satisfatório."
		appliesWhen: "múltiplas alternativas candidatas para uma decisão"
		rationale: "Simon 1956: satisficing é racionalmente superior quando custo de busca excede ganho marginal."
	},
	{
		question:  "A justificativa para continuar uma atividade menciona o que já foi investido? Se sim: é sunk cost ou argumento prospectivo?"
		reveals:   "Se sunk cost bias está governando a alocação."
		appliesWhen: "decisão de continuar vs realocar recurso de atividade em andamento"
		rationale: "Arkes/Blumer 1985: sunk cost bias é universal. Protocolo explícito é a única defesa."
	},
	{
		question:  "Existe slack suficiente (10-15%) para absorver oportunidades e imprevistos? Se não: o que liberar?"
		reveals:   "Se a organização está sobrecarregada (sem adaptabilidade) ou sub-alocada (sem disciplina)."
		rationale: "Nohria/Gulati 1996: U-invertido entre slack e performance."
	},
	{
		question:  "Qual é a velocidade do ciclo alocação-aprendizado-realocação? Estou aprendendo e realocando rápido o suficiente?"
		reveals:   "Se o ciclo de feedback é compatível com early-stage ou se resultados levam semanas para informar próxima alocação."
		rationale: "Stalk/Hout 1990: vantagem vem de ciclar mais rápido, não apenas de alocar melhor."
	},
]

meshExamples: [
	{
		id:       "ex-bootstrap-week-allocation"
		scenario: "Semana típica da Mesh pré-revenue. Founder tem ~50h produtivas. Backlog inclui: refinar scoring model, conversar com 3 construtoras (validação), iniciar documentação para correspondente bancário, melhorar CLAUDE.md, pesquisar gestores FIDC."
		analysis: "Constraint: horas do founder. CoD de cada atividade: conversar com construtoras = urgente (sem demanda validada, tudo é especulação — existencial). Correspondente bancário = alto-estável (lead time longo, começar cedo). Scoring = moderado (precisa de dados que ainda não existem — depend de construtoras). CLAUDE.md = baixo (melhora incremental). Gestores FIDC = baixo agora (depende de correspondente + dados). WSJF: construtoras (CoD urgente / duração curta = alto), correspondente (CoD alto / duração média = médio-alto), scoring (CoD moderado mas bloqueado por dependência = sequenciar após dados). Caminho crítico: construtoras → correspondente → piloto → dados → scoring → FIDC."
		recommendation: "Semana: 20h construtoras (constraint + caminho crítico + CoD urgente). 10h correspondente (caminho crítico + lead time longo). 5h CLAUDE.md (delegável a agente — satisfice, não otimizar). 5h scoring conceitual (preparation, não execução — depende de dados). 10h slack + batch review de agentes. Gestores FIDC: lista 'não-agora' com revisão quando correspondente estiver operando. Scoring execution: agente prepara pipeline quando dados chegarem."
		principlesApplied: ["ax-01", "ax-03", "ax-06"]
		assumptions: [
			"50h produtivas por semana é realista — verificar",
			"construtoras acessíveis para conversa em 1-2 semanas",
			"correspondente bancário aceita iniciar com documentação parcial",
			"CLAUDE.md é delegável a agente com revisão do founder",
		]
		rationale: "Alocação governada por: constraint (founder), WSJF (construtoras domina), caminho crítico (correspondente antes de FIDC), e strategic neglect (gestores FIDC é não-agora)."
	},
	{
		id:       "ex-sunk-cost-architecture-pivot"
		scenario: "Founder investiu 2 meses desenhando arquitetura de scoring para cessão definitiva. Conversa com gestores FIDC revela que mercado opera com coobrigação. Requer reestruturação significativa do modelo."
		analysis: "Sunk cost: 2 meses de trabalho em scoring para cessão definitiva. Valor prospectivo de continuar: scoring funciona para cessão definitiva mas mercado não opera assim — valor limitado a cenário hipotético. Valor prospectivo de pivotar: scoring para coobrigação alinha com mercado real, mas requer ~3 semanas de reestruturação. Os 2 meses investidos são irrecuperáveis independentemente da decisão."
		recommendation: "Pivotar. Os 2 meses são sunk cost — irrelevantes para decisão prospectiva. Valor prospectivo de coobrigação >> cessão definitiva dado mercado real. Custo de pivot: 3 semanas (reversível). Custo de não pivotar: meses de trabalho em direção que o mercado não valida (potencialmente existencial). Flag para agentes: em todo documento futuro, não mencionar '2 meses investidos em cessão definitiva' como argumento para manter — é sunk cost, não argumento."
		principlesApplied: ["ax-01", "ax-05"]
		assumptions: [
			"mercado realmente opera com coobrigação — validar com mais de um gestor",
			"reestruturação de 3 semanas é estimativa realista",
			"parte da arquitetura é reutilizável (feature store, pipeline) — verificar",
		]
		rationale: "Arkes/Blumer 1985: sunk cost bias. Decisão correta ignora o investido e compara apenas valor prospectivo. 3 semanas de pivot < meses em direção errada."
	},
	{
		id:       "ex-regime-transition"
		scenario: "Mesh operou 6 meses em modo exploration: 3 anchor tenants validados, scoring AUROC 0.72, 150 operações concluídas. Founder mantém 80% do tempo em exploration (novos segmentos, novos features, novos parceiros)."
		analysis: "Regime invertido. Com demanda validada (3 anchors), scoring funcional (AUROC >0.70), e operações reais (150), antecipação já deveria ter transitado de exploration para exploitation. 80% exploration neste estágio indica: (a) acúmulo de opções sem exercer, (b) novidade é mais excitante que consolidação, (c) não há critérios de transição definidos. O custo: valor validado não é capturado, dados de operação real não são maximizados, receita potencial não é gerada."
		recommendation: "Transicionar antecipação para exploitation: 60% exploitation (escalar com anchors existentes, otimizar pricing, automatizar pipeline) + 40% exploration (novo segmento, scoring V2). Critério de transição respeitado: AUROC >0.70 + ≥5 construtoras com volume. Próxima transição: quando novo segmento validar seu próprio gate, mover 10% adicional para exploitation. Manter exploration para dimensões genuinamente não-validadas (novo vertical, Drex, SCD)."
		principlesApplied: ["ax-01", "ax-06", "dp-08"]
		assumptions: [
			"3 anchors e AUROC 0.72 é validação suficiente para transicionar — verificar critérios de gate",
			"60/40 é split adequado para este estágio — ajustar com dados",
			"exploitation não significa parar de aprender — significa aprender otimizando, não experimentando",
		]
		rationale: "March 1991: exploration indefinida sem captura é modo de falha. O'Reilly/Tushman 2004: ambidexterity requer estruturas separadas. Transicionar com critérios explícitos, não com feeling."
	},
	{
		id:       "ex-delegation-expansion"
		scenario: "Founder revisa todas as propostas de antecipação individualmente (~8h/semana). Volume crescendo. Throughput constraint: horas do founder alocadas a aprovação."
		analysis: "Classificação 2×2: propostas dentro de limites pré-aprovados (valor <R$50k, comprador com score >75, documentação completa) — agente tem informação suficiente e consequência é tolerável. Propostas fora dos limites — consequência potencialmente séria, requer julgamento. Atualmente: founder revisa todas (0% delegação de aprovação). Potencial: ~70% das propostas estão dentro de limites — poderiam ser aprovadas por agente."
		recommendation: "Definir limites de autonomia para agente: aprovar automaticamente se (valor <R$50k) E (score comprador >75) E (documentação completa) E (EAD comprador não excede limite de concentração). Founder revisa apenas exceções (~30%). Liberação estimada: ~5.5h/semana devolvidas ao constraint. Fase 1: agente aprova + founder verifica em batch diário (validação do mecanismo). Fase 2: se taxa de erro <2% em 30 dias, remover verificação diária, manter auditoria semanal."
		principlesApplied: ["ax-06", "dp-01", "dp-05"]
		assumptions: [
			"70% das propostas dentro de limites — verificar com dados reais",
			"limites de R$50k e score >75 são conservadores o suficiente",
			"taxa de erro <2% é threshold aceitável para delegação plena",
		]
		rationale: "Aghion/Tirole 1997: co-localizar decisão com informação. Cada proposta delegada libera o constraint. Fase 1→2 é screening sequencial da confiabilidade do agente."
	},
]

principleIds: ["ax-01", "ax-03", "ax-05", "ax-06", "dp-01", "dp-05", "dp-08"]

relatedLenses: [
	{
		lensId:   "lens-organizational-economics"
		relation: "complementsWith"
		context:  "OE modela a organização como unidade econômica — custos de agência, incentivos, fronteiras. ORA modela como a organização aloca recursos entre alternativas concorrentes. OE pergunta 'quem faz o quê e por quê'; ORA pergunta 'o que fazer primeiro, com quanto, e o que não fazer'. Sobreposições explícitas: ora-delegation-fitness complementa oe-delegation-and-trust (OE: agência; ORA: fitness criteria). ora-allocation-regime operacionaliza oe-exploration-exploitation (OE: teoria; ORA: % e thresholds)."
	},
	{
		lensId:   "lens-real-options"
		relation: "complementsWith"
		context:  "RO modela timing e sequência de investimentos sob incerteza — quando exercer opções. ORA modela alocação de recursos entre atividades em horizonte operacional — como distribuir bandwidth dado que é finita. RO define os gates; ORA define a execução entre gates. ora-sequencing-under-dependency complementa ro-staging-gates-adaptive (RO: gates sob incerteza; ORA: caminho crítico sob dependência)."
	},
	{
		lensId:   "lens-behavioral-economics"
		relation: "complementsWith"
		context:  "BE diagnostica vieses cognitivos que distorcem alocação — sunk cost, overconfidence, present bias, planning fallacy. ORA operacionaliza contra-medidas: flags obrigatórios, protocolos prospectivos, thresholds de satisficing. BE diz por que erramos; ORA diz o que fazer para errar menos."
	},
	{
		lensId:   "lens-financial-intermediation"
		relation: "complementsWith"
		context:  "FI modela alocação de capital financeiro entre operação, reserva e crescimento. ORA modela alocação de todos os recursos (tempo, atenção, compute, capital). Quando o constraint é capital: FI domina. Quando é tempo/atenção: ORA domina. Ambas coexistem."
	},
	{
		lensId:   "lens-mechanism-design"
		relation: "complementsWith"
		context:  "MD desenha incentivos para participantes externos. ORA aloca recursos internos. Conexão: md-automated-mechanism-design consome recursos que ORA precisa alocar. WSJF de ORA prioriza quando investir em iterar mecanismos via AMD vs outras atividades."
	},
	{
		lensId:   "lens-regulatory-strategy"
		relation: "complementsWith"
		context:  "RS identifica lead times regulatórios não-comprimíveis. ORA incorpora esses lead times no sequenciamento (dependências regulatórias no caminho crítico). RS diz 'SCD leva N meses'; ORA diz 'portanto, iniciar no mês X para não bloquear o caminho crítico no mês Y'."
	},
]

limitations: [
	{
		description: "Alocação de recursos assume que a organização sabe quais são as alternativas. Se o espaço de alternativas é desconhecido (ambiguidade profunda), a priorização por WSJF ou caminho crítico não se aplica."
		alternative: "Para ambiguidade profunda (Nível 4 Courtney), usar real-options com experimentação e shaping antes de alocar."
		rationale: "WSJF requer que alternativas sejam enumeráveis e que CoD seja estimável. Sem isso, o framework gera falsa precisão."
	},
	{
		description: "Framework assume recursos fungíveis dentro de cada tipo. Na prática, horas do founder em arquitetura ≠ horas do founder em vendas — competência e energia variam por tipo de tarefa."
		alternative: "Considerar fungibilidade parcial: alocar tarefas de alto CoD ao bloco de energia/competência onde o founder performa melhor. Energy management complementa resource allocation."
		rationale: "Alocação ótima por WSJF pode ser sub-ótima se a tarefa de maior WSJF exige competência que o founder não tem ou energia que não tem naquele momento."
	},
	{
		description: "Satisficing e velocidade de decisão podem ser usados como justificativa para evitar análise quando análise é necessária (decisão irreversível tratada como reversível)."
		alternative: "Sempre classificar na precedence hierarchy antes de aplicar satisficing. Tipo 1/2: não satisfice. Tipo 3/4: satisfice quando critérios são atendidos."
		rationale: "A heurística de velocidade tem modos de falha em ambas as direções. A precedence hierarchy é o guardrail."
	},
	{
		description: "WSJF e CoD são estimativas — não métricas precisas. Viés de ancoragem na estimativa de CoD pode distorcer priorização tanto quanto ausência de estimativa."
		alternative: "Usar ranking relativo (A > B > C) em vez de estimativa absoluta quando precisão não é possível. Reinertsen: ranking relativo de CoD já melhora sequenciamento materialmente."
		rationale: "Reinertsen 2009: estimativas intuitivas de CoD variam 50:1. Ranking relativo é mais robusto que estimativa absoluta com falsa precisão."
	},
	{
		description: "Não cobre alocação de recursos entre organizações (parcerias, terceirização, joint ventures). Foca em alocação interna."
		alternative: "Para decisões de fronteira organizacional (make vs buy, parceria vs internalizar), usar theory-of-firm."
		rationale: "ORA modela como alocar recursos dentro dos limites da organização. A definição dos limites é questão de theory-of-firm."
	},
]

rationale: "Toda organização aloca recursos escassos entre alternativas concorrentes. Na Mesh pré-revenue com solo founder e agentes IA, os recursos são: horas do founder (constraint primário), capital limitado, e capacidade computacional. Cada hora alocada a uma atividade é indisponível para outra (Buchanan 1969). Sem framework explícito, alocação é governada por urgência percebida, novidade, ou sunk cost — não por valor econômico. Esta lens operacionaliza: identificação do constraint (Goldratt 1984), priorização por custo de atraso (Reinertsen 2009), velocidade calibrada à reversibilidade (Eisenhardt 1989), regime exploration/exploitation com transição por gates (March 1991, O'Reilly/Tushman 2004), negligência estratégica documentada (Porter 1996), delegação baseada em fitness (Aghion/Tirole 1997), atenção como recurso finito (Ocasio 1997), slack calibrado (Nohria/Gulati 1996), imunidade a sunk cost (Arkes/Blumer 1985), e velocidade de ciclo (Stalk/Hout 1990). Universal, agnóstica a estágio, aplicável a qualquer bounded context."

}
