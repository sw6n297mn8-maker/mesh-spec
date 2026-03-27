package lenses

import "mesh-spec/architecture/artifact-schemas"

commonsCollectiveAction: artifact_schemas.#AnalyticalLens & {
	id:      "lens-commons-collective-action"
	name:    "Commons e Ação Coletiva"
	purpose: "Modelar os recursos compartilhados que a Mesh cria e governa — dados, scoring, reputação, compliance e funding — quando seu valor depende de contribuição coletiva, regras de acesso, monitoramento e proteção contra free-riding, degradação e enclosure. A lente distingue problemas de contribuição, coordenação, governança e captura da infraestrutura comum pela própria plataforma."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve recursos compartilhados na plataforma, como dados, scoring, reputação, compliance ou funding pool",
			"a decisão envolve quem pode acessar, contribuir ou extrair valor de recursos compartilhados",
			"a decisão envolve risco de degradação de recurso compartilhado por uso excessivo, contribuição insuficiente ou monitoramento fraco",
			"a decisão envolve free-riding ou benefício sem contribuição proporcional",
			"a decisão envolve como incentivar contribuição voluntária de dados, compliance ou qualidade operacional",
			"a decisão envolve governança de recurso compartilhado, incluindo quem define regras de acesso e uso",
			"a decisão envolve como proteger qualidade de dados coletivos contra gaming, negligência ou baixa capacidade de contribuição",
			"a decisão envolve pool de funding compartilhado e externalidades impostas ao conjunto",
			"a decisão envolve como distribuir benefícios gerados coletivamente entre participantes individuais",
			"a decisão envolve risco de captura do commons pela própria plataforma",
			"a decisão envolve participantes com capacidades assimétricas de contribuição ou monitoramento",
		]
		keywords: [
			"commons", "recurso compartilhado", "bem comum",
			"free rider", "carona", "contribuição",
			"tragédia dos comuns", "degradação", "depleção",
			"ação coletiva", "collective action", "cooperação",
			"Ostrom", "governança", "regras de acesso",
			"qualidade de dados", "gaming", "manipulação",
			"pool", "FIDC", "recurso coletivo",
			"externalidade", "extração",
			"club good", "bem de clube", "excludabilidade",
			"enclosure", "captura",
			"heterogeneidade", "coordenação",
			"monitoramento", "sanção", "portabilidade",
		]
		excludeWhen: [
			"a decisão é sobre design de incentivos individuais sem componente de recurso compartilhado; usar lens-mechanism-design",
			"a decisão é sobre estrutura informacional ou valor privado da informação para um participante; usar lens-information-economics",
			"a decisão é sobre efeitos de rede sem componente de recurso compartilhado; usar lens-platform-dynamics",
			"a decisão é sobre risco de crédito ou composição de carteira sem recurso compartilhado; usar lens-credit-risk",
			"a decisão é sobre funding ou estrutura regulatória sem externalidade de commons; usar lens-financial-intermediation",
		]
		rationale: "A Mesh cria recursos compartilhados que não existiam antes: pool de dados, scoring coletivo, reputação de rede, compliance verificável e funding compartilhado. O valor desses recursos depende de contribuição coletiva, mas cada participante pode ter incentivo para contribuir menos do que o sistema precisa ou extrair mais do que seria saudável. Além disso, a própria plataforma governa e explora esses commons, criando risco de enclosure. Sem esta lente, o agente trata recursos compartilhados como ativos proprietários simples da plataforma e ignora que qualidade, confiança e sustentabilidade dependem de governança evolutiva."
	}

	concepts: [
		{
			id:                "ca-commons-lifecycle"
			name:              "Lifecycle do Commons e Governança por Fase"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Commons mudam de natureza ao longo do tempo. Na formação, o problema dominante é massa crítica e insuficiência de contribuição inicial, não free-riding. No crescimento, a governança ainda é informal e dependente de relações sociais e atenção dedicada. Na escala, surgem free-riding, gaming, heterogeneidade relevante e necessidade de regras formais. Na maturidade, o risco dominante passa a incluir enclosure e governança unilateral da infraestrutura comum."
			meshManifestation: "No bootstrap da Mesh, a principal dificuldade é fazer o commons existir: digitalizar, estruturar, confirmar e registrar dados básicos. Em crescimento, anchor tenants ainda conseguem sustentar normas informais. Em escala, isso deixa de funcionar e o sistema precisa de excludabilidade, monitoramento e sanções. Em maturidade, participantes passam a questionar mudanças unilaterais da Mesh em scoring, analytics, uso de dados e preço de acesso."
			meshImplication:   "Antes de prescrever governança, identificar a fase do commons. Formação pede subsídio, digitalização e baixa excludabilidade. Crescimento pede formalização de monitoramento. Escala pede regras explícitas, excludabilidade e sanções graduais. Maturidade pede mecanismos anti-enclosure e participação de stakeholders na governança."
			rationale:         "Sem lifecycle, a governança vira estática e inadequada para a fase."
			appliesWhen:       "a decisão envolve desenho ou mudança de governança de um recurso compartilhado"
		},
		{
			id:                "ca-resource-typology"
			name:              "Tipologia de Recursos Compartilhados"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Recursos compartilhados diferem por rivalidade e excludabilidade. Na Mesh, dados, scoring, reputação e compliance funcionam majoritariamente como bens de clube: excludáveis, mas com uso amplamente não-rival. Já o funding pool opera como club good com congestion: a Mesh consegue excluir, mas o capital é rival e cada operação impõe externalidade ao conjunto."
			meshManifestation: "Um dado a mais melhora scoring para muitos ao mesmo tempo. Já capital do FIDC alocado a uma operação não pode ser simultaneamente alocado a outra, e ainda altera concentração, correlação e risco agregado."
			meshImplication:   "Para bens de clube, a principal ferramenta é excludabilidade condicionada a contribuição. Para funding pool, além de acesso condicionado, é preciso pricing da externalidade e disciplina de concentração."
			rationale:         "Classificação errada do recurso leva ao instrumento errado de governança."
			dependsOn:         ["ca-commons-lifecycle"]
			crossDependsOn: [
				{lensId: "lens-financial-intermediation", conceptId: "fi-fidc-structure", context: "pool de funding exige tratamento distinto do commons de dados ou reputação"},
			]
		},
		{
			id:                "ca-participant-heterogeneity"
			name:              "Heterogeneidade de Participantes e Contribuição Assimétrica"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Participantes diferem simultaneamente em capacidade de contribuir e em importância para a qualidade do commons. A governança precisa considerar pelo menos duas dimensões: capacidade digital e relevância sistêmica da contribuição. Grupos privilegiados sustentam mais facilmente o commons; grupos latentes só contribuem se o custo for muito baixo ou se houver forte retorno individual."
			meshManifestation: "Construtoras grandes e anchors têm alta capacidade digital e alta relevância. Fornecedores médios podem ter alta relevância, mas baixa capacidade operacional de contribuição digital. Fornecedores pequenos e informais frequentemente têm baixa capacidade e baixa importância marginal individual, embora em agregado importem para cobertura da rede."
			meshImplication:   "Governança deve variar por quadrante. Alta capacidade e alta importância suportam obrigação contratual. Alta capacidade e baixa importância suportam incentivo leve. Baixa capacidade e alta importância exigem investimento da Mesh em digitalização. Baixa capacidade e baixa importância exigem automação e extração passiva sempre que possível."
			rationale:         "Governança uniforme falha porque capacidade e relevância não são distribuídas uniformemente."
			dependsOn:         ["ca-commons-lifecycle"]
			crossDependsOn: [
				{lensId: "lens-behavioral-economics", conceptId: "be-friction-defaults-choice", context: "custo de contribuição precisa ser compatível com a capacidade real de cada classe"},
			]
		},
		{
			id:                "ca-coordination-vs-contribution"
			name:              "Coordenação vs Contribuição"
			nature:            "theoretical"
			role:              "heuristic"
			definition:        "Nem toda falha aparente de contribuição é free-riding. Muitas falhas são de coordenação: o participante quer contribuir, mas não sabe como, não tem capacidade, não tem o dado em formato utilizável ou não percebe quem deve agir. A diferença entre problema de incentivo e problema de coordenação muda completamente a intervenção."
			meshManifestation: "Comprador que não confirma recebimento pode ser free-rider, mas também pode simplesmente não ter fluxo nem responsável claros. Fornecedor informal pode deixar de enviar dado não por oportunismo, mas porque o dado não existe digitalmente."
			meshImplication:   "Toda falha de contribuição deve ser diagnosticada primeiro como coordenação ou incentivo. Coordenação pede simplificação, digitalização, definição de focal point e canais adequados. Incentivo pede benefício individual, excludabilidade ou sanção."
			rationale:         "Punir problema de coordenação destrói participação de quem queria contribuir."
			dependsOn:         ["ca-participant-heterogeneity"]
		},
		{
			id:                "ca-data-as-commons"
			name:              "Dados como Commons"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O pool de dados é o commons mais valioso da Mesh porque alimenta scoring, matching, analytics e disciplina da rede. Sua qualidade depende de contribuição coletiva, integridade das fontes, verificabilidade e monitoramento. O desafio central é que, em muitos segmentos, os dados ainda nem existem em formato digital antes de existir problema de governança."
			meshManifestation: "Dados de entrega, qualidade e prazo podem estar em papel, WhatsApp, memória do engenheiro, apontamento manual ou simplesmente não serem registrados de forma estruturada. Sem criação do dado, não há commons a governar."
			meshImplication:   "Separar fase de criação do commons de dados da fase de governança. Primeiro digitalizar ou extrair. Depois governar contribuição, qualidade, peso relativo de fontes, verificação cruzada e detecção de gaming. Dados bilaterais e verificáveis devem ter peso maior do que auto-relato unilateral."
			rationale:         "Na construção civil, governar dados pressupõe primeiro produzi-los ou capturá-los."
			dependsOn:         ["ca-resource-typology", "ca-coordination-vs-contribution"]
			crossDependsOn: [
				{lensId: "lens-information-economics", conceptId: "ie-value-of-information", context: "nem todo dado vale o mesmo; governança deve refletir valor marginal e verificabilidade"},
				{lensId: "lens-supply-chain-theory", conceptId: "sc-scf-mechanism", context: "a hierarquia de dados operacionais influencia o valor do commons de dados"},
			]
		},
		{
			id:                "ca-free-rider-problem"
			name:              "Free-Riding e Contribuição Subótima"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Free-riding assume três formas principais: consumo sem contribuição, contribuição mínima e extração desproporcional. Em grupos maiores, contribuição voluntária tende a ser insuficiente se não houver governança explícita. Ainda assim, é crucial distinguir free-riding genuíno de incapacidade ou problema de coordenação."
			meshManifestation: "Fornecedor pode usar o score como referência para negociar fora. Comprador pode usar benefícios do compliance coletivo sem confirmar entregas. Participante de alto risco pode consumir funding desproporcional em relação ao valor que agrega ao commons."
			meshImplication:   "Consumo sem contribuição pede acesso condicionado. Contribuição mínima pede automação e benefício individual visível. Extração desproporcional pede pricing de externalidade e limites. Mas tudo isso só faz sentido depois de excluir hipótese de coordenação."
			rationale:         "A categoria de free-riding importa, mas o diagnóstico de causa raiz importa ainda mais."
			dependsOn:         ["ca-resource-typology", "ca-coordination-vs-contribution"]
		},
		{
			id:                "ca-tragedy-of-commons"
			name:              "Tragédia dos Comuns"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A degradação do commons tende a ser gradual, cumulativa e pouco visível por transação individual. O recurso não precisa colapsar abruptamente para já estar estruturalmente piorando. Isso torna leading indicators mais importantes do que danos observados tardiamente."
			meshManifestation: "Cada dado impreciso reduz ligeiramente a utilidade coletiva do score. Cada confirmação ausente reduz um pouco a confiabilidade do sistema. Cada operação concentrada no funding pool piora um pouco a externalidade para todos. Isoladamente parece irrelevante; em agregado corrói o commons."
			meshImplication:   "Monitorar leading indicators por tipo de commons e diagnosticar se a degradação observada vem realmente de problema de commons, e não de macro, amostra ou mudança de mix. Só depois prescrever sanção, excludabilidade ou redesign."
			rationale:         "A tragédia é perigosa precisamente porque sua trajetória é invisível até tarde."
			dependsOn:         ["ca-data-as-commons", "ca-free-rider-problem"]
		},
		{
			id:                "ca-adverse-selection-intra-commons"
			name:              "Seleção Adversa Intra-Commons"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Se o commons nivela excessivamente benefícios, participantes de alta qualidade passam a subsidiar os de qualidade inferior. Isso gera saída dos melhores perfis com boa outside option e deteriora a composição do próprio commons. O problema não é apenas churn total, mas churn seletivo dos perfis que mais sustentam a qualidade do recurso."
			meshManifestation: "Se score alto não recebe benefício materialmente diferente de score apenas aceitável, os melhores fornecedores que têm acesso a banco ou alternativa fora da Mesh saem. Os que ficam podem ser justamente os que mais dependem do pooling coletivo."
			meshImplication:   "A Mesh precisa recompensar contribuição e qualidade diferenciadas dentro do commons. Isso implica pricing granular, benefícios exclusivos e monitoramento de churn desagregado por quartil e outside option, não apenas churn médio."
			rationale:         "Commons que nivela demais expulsa exatamente quem mais o sustenta."
			dependsOn:         ["ca-resource-typology", "ca-free-rider-problem"]
			crossDependsOn: [
				{lensId: "lens-market-design", conceptId: "md-participation-constraints", context: "outside option determina quais bons participantes o commons consegue reter"},
			]
		},
		{
			id:                "ca-ostrom-governance"
			name:              "Governança Evolutiva Inspirada em Ostrom"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Commons sustentáveis exigem fronteiras claras, regras proporcionais ao contexto, monitoramento, sanções graduais, resolução de conflitos e, em fases mais maduras, algum grau de participação dos membros na formação das regras. Em commons digitais, esses princípios não são copiados literalmente, mas continuam sendo excelente framework de desenho."
			meshManifestation: "No bootstrap, a Mesh inevitavelmente define regras unilateralmente. Em crescimento, transparência passa a importar. Em escala, contestação, regras publicadas e algum conselho consultivo tornam-se necessários para que o commons continue legítimo."
			meshImplication:   "Planejar governança evolutiva. Não instalar participação formal prematuramente, mas também não perpetuar unilateralidade além da fase em que ela é justificável. Monitoramento e sanções precisam escalar; resolução de conflitos precisa ser acessível e confiável."
			rationale:         "Ostrom continua útil porque o problema central continua sendo governar recurso compartilhado sem destruí-lo."
			dependsOn:         ["ca-tragedy-of-commons", "ca-commons-lifecycle"]
		},
		{
			id:                "ca-monitoring-cost"
			name:              "Custo de Monitoramento"
			nature:            "theoretical"
			role:              "property"
			definition:        "Monitoramento não é gratuito e, em commons digitais operados por plataforma, tende a recair desproporcionalmente sobre o operador. Se seu custo cresce mais rápido que a receita ou benefício gerado, a própria plataforma passa a ter incentivo para monitorar menos justamente quando mais escala exige monitorar mais."
			meshManifestation: "Verificação cruzada, anomaly detection, revisão de exceções, validação documental, detecção de gaming e resolução de conflitos geram custo marginal e custo fixo. Falsos positivos ainda exigem revisão humana."
			meshImplication:   "Toda regra de governança deve ser avaliada também por custo de monitoramento. Automatizar quando possível, distribuir custo quando viável e tornar visível quando ele é parte estrutural do spread ou da taxa. Monitorar o próprio monitoramento."
			rationale:         "Commons que depende de monitoramento caro e invisível tende a degradar silenciosamente."
			dependsOn:         ["ca-ostrom-governance"]
		},
		{
			id:                "ca-enclosure-risk"
			name:              "Risco de Enclosure"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Enclosure ocorre quando a plataforma privatiza em benefício próprio um recurso cujo valor foi produzido coletivamente. O risco não é apenas econômico, mas institucional: participantes passam a perceber que contribuem para algo que a Mesh pode reconfigurar unilateralmente a seu favor."
			meshManifestation: "Restringir analytics antes compartilhados, vender dados agregados sem limites claros, mudar scoring unilateralmente, usar dados de uma parte para favorecer outra ou tornar opaco aquilo que antes parecia commons partilhado."
			meshImplication:   "A Mesh precisa de mecanismos anti-enclosure: política de dados explícita, versionamento de mudanças, portabilidade de dados próprios, transparência sobre o que é exportável e sobre o que permanece dependente do commons, e evolução gradual de participação na governança."
			rationale:         "O commons morre quando os participantes percebem que produzem valor coletivo que será capturado sem contrapartida."
			dependsOn:         ["ca-ostrom-governance"]
			crossDependsOn: [
				{lensId: "lens-regulatory-strategy", conceptId: "rs-lgpd-operational", context: "portabilidade, uso de dados e limites de captura precisam respeitar LGPD e confiança institucional"},
			]
		},
		{
			id:                "ca-funding-pool-commons"
			name:              "Funding Pool como Club Good com Congestion"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O funding pool é um caso especial de commons: o acesso é altamente excludável, mas o recurso é rival e cada operação altera o risco agregado do conjunto. O principal problema é a externalidade que cada participante impõe ao pool, não apenas a dificuldade de excluir."
			meshManifestation: "Cada operação adiciona concentração, correlação, risco de seleção adversa e, em casos extremos, potencial de deterioração de confiança do funding como um todo. Em bootstrap, a falta de diversificação torna limites rígidos potencialmente destrutivos."
			meshImplication:   "Gerir funding pool com pricing de externalidade, monitoramento intensivo, transparência de composição e limites que evoluem com a fase. Em fases iniciais, monitoramento e prêmio de congestion podem ser mais adequados do que limites formais excessivamente rígidos."
			rationale:         "Racionar apenas por limite ignora que o problema estrutural é a externalidade imposta ao conjunto."
			dependsOn:         ["ca-resource-typology", "ca-tragedy-of-commons", "ca-commons-lifecycle"]
			crossDependsOn: [
				{lensId: "lens-financial-intermediation", conceptId: "fi-run-risk", context: "degradação do pool coletivo pode gerar run ou encarecimento do funding"},
				{lensId: "lens-credit-risk", conceptId: "cr-concentration-risk", context: "externalidade coletiva do pool se manifesta como concentração e correlação de risco"},
			]
		},
		{
			id:                "ca-excludability-design"
			name:              "Design de Excludabilidade"
			nature:            "theoretical"
			role:              "method"
			definition:        "Excludabilidade é a principal ferramenta de governança para bens de clube, mas precisa ser calibrada por fase, segmento e capacidade real de contribuição. Excluir cedo demais pode matar crescimento ou empurrar participantes para informalidade; excluir de menos em escala alimenta free-riding."
			meshManifestation: "No início, abrir demais pode ser necessário para formar o commons. Depois, acesso a analytics, reputação e scoring coletivo pode ser gradualmente condicionado a participação real e qualidade de contribuição."
			meshImplication:   "Desenhar camadas progressivas de acesso e benefícios. Nunca excluir por incapacidade digital em segmento que a Mesh sabe que ainda não consegue contribuir de forma ativa. Excluir por ausência real de participação, não por incapacidade estrutural de gerar determinado dado."
			rationale:         "Excludabilidade é poderosa, mas mal calibrada se torna ferramenta de autossabotagem do commons."
			dependsOn:         ["ca-free-rider-problem", "ca-ostrom-governance", "ca-commons-lifecycle"]
		},
		{
			id:                "ca-collective-reputation"
			name:              "Reputação Coletiva"
			nature:            "theoretical"
			role:              "property"
			definition:        "A reputação da rede é um commons porque incidentes locais afetam a percepção do sistema como um todo. Spillovers negativos atingem bons participantes, enquanto boa reputação sistêmica beneficia novos entrantes. Reputação coletiva, portanto, precisa de curation, monitoramento e resposta proporcional a incidentes."
			meshManifestation: "Fraude não detectada em um fornecedor afeta confiança de investidores e compradores em todo o score. Incidentes bem tratados, com transparência e resposta justa, podem fortalecer confiança sistêmica."
			meshImplication:   "Tratar curation, detecção precoce e resposta a incidentes como investimentos em commons reputacional, não apenas em gestão de risco pontual. Reter os melhores participantes também é proteger reputação coletiva."
			rationale:         "Sem commons reputacional, cada incidente corrói mais do que o caso individual sugere."
			dependsOn:         ["ca-data-as-commons", "ca-adverse-selection-intra-commons"]
		},
		{
			id:                "ca-contribution-incentives"
			name:              "Incentivos de Contribuição"
			nature:            "theoretical"
			role:              "method"
			definition:        "A forma mais sustentável de resolver ação coletiva é fazer o participante perceber retorno individual claro ao contribuir. Sanção é útil como backstop; norma social ajuda em grupos menores; mas benefício individual visível, simples e próximo no tempo é o mecanismo mais escalável."
			meshManifestation: "Atualizar documentação melhora score, prioridade ou acesso. Confirmar dados gera analytics melhores. Contribuir para verificação aumenta confiança e reduz fricção futura. Para novos participantes, porém, o retorno pode ser pequeno no início, exigindo subsídio temporal."
			meshImplication:   "Ligar cada contribuição relevante a um benefício individual visível e rápido. Projetar onboarding e primeiros ciclos com subsídio de contribuição inicial, especialmente para novos participantes, porque cada novo membro vive seu próprio micro-bootstrap dentro do commons."
			rationale:         "Contribuição coletiva só escala quando parece racional individualmente."
			dependsOn:         ["ca-free-rider-problem", "ca-excludability-design", "ca-participant-heterogeneity"]
			crossDependsOn: [
				{lensId: "lens-mechanism-design", conceptId: "md-incentive-compatibility", context: "o commons precisa de incentivos individuais alinhados, não apenas de boa vontade coletiva"},
			]
		},
		{
			id:                "ca-mesh-commons-health"
			name:              "Saúde dos Commons da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "A saúde dos commons deve ser monitorada por tipo de recurso e por fase. Dados, compliance, funding, reputação e monitoramento têm leading indicators próprios, além de métricas de fase, custo de governança, sinais de seleção adversa e percepção de enclosure."
			meshManifestation: "No bootstrap, indicadores mais relevantes são cobertura de digitalização, existência mínima do commons e contribuição inicial. Em crescimento, surgem free-riding e queda de verificações. Em escala, importam efetividade de sanções, custo de monitoramento, churn seletivo e questionamentos de governança."
			meshImplication:   "Operar dashboard por commons com thresholds calibráveis e bridges explícitas para outras lenses. Monitorar também o custo de manter o commons saudável, porque esse custo pode se tornar restrição estrutural."
			rationale:         "Commons degradam silenciosamente se não forem observados como sistema próprio."
			appliesWhen:       "o commons já existe em alguma escala operacional e sua qualidade precisa ser acompanhada"
		},
	]

	reasoningProtocol: [
		{
			question:  "Em que fase está este commons: formação, crescimento, escala ou maturidade?"
			reveals:   "A fase determina o problema dominante e a governança adequada."
			rationale: "Sem identificar fase, a prescrição de governança tende a errar o timing."
		},
		{
			question:  "Qual recurso compartilhado está em jogo: dados, scoring, reputação, compliance ou funding pool?"
			reveals:   "Tipos diferentes de recurso exigem instrumentos diferentes."
			rationale: "Classificar o recurso vem antes de escolher a ferramenta."
		},
		{
			question:  "Os participantes diferem em capacidade digital e importância para a qualidade do commons?"
			reveals:   "Mostra se governança uniforme será destrutiva."
			rationale: "Commons com heterogeneidade alta exigem desenho diferenciado."
		},
		{
			question:  "A falha observada é de coordenação ou de incentivo?"
			reveals:   "Coordenação pede facilitação; incentivo pede alinhamento ou sanção."
			rationale: "Diagnóstico errado aqui costuma gerar punição contraproducente."
		},
		{
			question:  "Qual é a outside option de cada classe de participante relevante?"
			reveals:   "Determina holding power, risco de churn e necessidade de diferenciação."
			rationale: "Sem outside option, excludabilidade e incentivos podem ser mal calibrados."
		},
		{
			question:  "A soma das contribuições exigidas por todos os commons é viável para cada classe?"
			reveals:   "Mostra quando o sistema está exigindo mais do que a atenção e a capacidade reais suportam."
			rationale: "Custo agregado de contribuição importa mais do que custo isolado."
			appliesWhen: "múltiplos commons pedem ação do mesmo participante"
		},
		{
			question:  "Existe free-riding e, se existe, qual tipo: consumo sem contribuição, contribuição mínima ou extração desproporcional?"
			reveals:   "Cada forma pede instrumento diferente."
			rationale: "Nem todo free-rider é igual."
			appliesWhen: "fase >= crescimento"
		},
		{
			question:  "O commons está degradando e a causa parece ser realmente de commons, não macro, coorte ou mudança de mix?"
			reveals:   "Evita prescrever governança para um problema que não é governança."
			rationale: "Diagnóstico de causa raiz vem antes da intervenção."
			appliesWhen: "há degradação de métricas ou percepção de queda de qualidade"
		},
		{
			question:  "O design de excludabilidade está adequado à fase, à capacidade dos participantes e ao risco de empurrar gente para fora do sistema?"
			reveals:   "Mostra se o commons está sendo protegido ou sufocado."
			rationale: "Excludabilidade é poderosa, mas sensível ao contexto."
			appliesWhen: "a decisão envolve acesso, tiers, analytics ou score coletivo"
		},
		{
			question:  "Existe seleção adversa intra-commons, especialmente entre perfis de alta qualidade com boa outside option?"
			reveals:   "Mostra se o commons está expulsando quem mais o sustenta."
			rationale: "Churn seletivo é mais grave do que churn médio."
			appliesWhen: "há churn diferenciado por qualidade, porte ou outside option"
		},
		{
			question:  "Existe risco de enclosure pela própria Mesh?"
			reveals:   "Mostra se a plataforma está corroendo a legitimidade do commons."
			rationale: "Sem anti-enclosure, confiança institucional é frágil."
			appliesWhen: "a decisão envolve mudança de regras, uso de dados ou acesso ao valor coletivo"
		},
		{
			question:  "A governança atende o nível apropriado de monitoramento, sanções graduais, resolução de conflito e participação para a fase atual?"
			reveals:   "Mostra se a arquitetura institucional do commons está madura o suficiente."
			rationale: "Governança insuficiente ou prematura destrói o commons por vias opostas."
			appliesWhen: "a decisão é sobre regras, monitoramento ou sanções"
		},
		{
			question:  "Há bridges acionadas com outras lenses, como queda de AUROC, aumento de HHI, queda de completude ou churn seletivo?"
			reveals:   "Mostra se o problema já migrou de commons para outra dimensão do sistema."
			rationale: "Commons bem analisado precisa saber quando passar o bastão para outra lente."
		},
	]

	meshExamples: [
		{
			id:                "ex-data-quality-degradation"
			scenario:          "Depois que o commons de dados cresce, a qualidade do score começa a cair junto com a completude de confirmação bilateral."
			analysis:          "O commons já saiu da fase de formação. Há indício de degradação do recurso compartilhado, mas a causa pode ser coordenação, incentivo ou gaming. Se compradores não confirmam porque o fluxo é ruim, é coordenação. Se não confirmam apesar de fluxo simples, é free-riding. Se auto-relatos divergem de fontes verificáveis, é gaming."
			recommendation:    "Separar criação e governança do commons. Redesenhar canal de confirmação para o agente real de operação, reforçar peso de dados bilaterais, reduzir peso de auto-relato unilateral e ativar monitoramento de divergência. Se AUROC não estabilizar, acionar lens-credit-risk para recalibração."
			principlesApplied: ["ax-05", "ax-07", "dp-05", "dp-09"]
			assumptions: [
				"a deterioração não foi causada principalmente por macro ou mudança extrema de mix",
				"há pelo menos uma fonte verificável independente para contraste",
			]
			rationale: "O caso mostra commons de dados degradando por mistura de coordenação, free-riding e gaming."
		},
		{
			id:                "ex-funding-pool-concentration"
			scenario:          "O funding pool depende fortemente de poucos compradores no bootstrap, e limite formal de concentração destruiria o próprio mercado nascente."
			analysis:          "O funding pool é club good com congestion. O problema não é acesso, mas externalidade. Como o sistema ainda está em formação, governança de escala aplicada cedo demais seria autodestrutiva."
			recommendation:    "Usar monitoramento intensivo, pricing de congestion e plano explícito de diversificação antes de impor limite rígido de concentração. Comunicar claramente a fase e a trajetória esperada para investidores."
			principlesApplied: ["ax-05", "ax-07", "dp-05"]
			assumptions: [
				"há pipeline plausível de diversificação",
				"o custo de concentração no bootstrap ainda é administrável com monitoramento forte",
			]
			rationale: "O caso mostra a importância de lifecycle e tipologia correta do commons."
		},
		{
			id:                "ex-q1-churn-from-commons-leveling"
			scenario:          "Perfis de alta qualidade com outside option bancária começam a sair porque o commons nivela demais o benefício entre bons e medianos."
			analysis:          "O commons está sofrendo seleção adversa intra-commons. A saída não é uniforme: ela afeta os participantes mais valiosos para qualidade do score e reputação da rede. O sistema perde exatamente os perfis que mais sustentam o recurso compartilhado."
			recommendation:    "Introduzir diferenciação material por qualidade e contribuição, com pricing granular, benefícios exclusivos e monitoramento de churn desagregado por quartil e outside option. Não tratar o problema como churn médio."
			principlesApplied: ["ax-05", "ax-06", "dp-02"]
			assumptions: [
				"a outside option bancária é real para esses perfis",
				"a diferença atual de benefício entre top quartil e medianos é insuficiente",
			]
			rationale: "O caso mostra que commons mal calibrado pode expulsar quem mais o torna valioso."
		},
	]

	principleIds: ["ax-03", "ax-05", "ax-06", "ax-07", "dp-05", "dp-09"]

	relatedLenses: [
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Commons identifica o problema de contribuição, free-riding e externalidade; mechanism-design desenha o mecanismo específico de incentivo, monitoramento, verificação e sanção."
		},
		{
			lensId:   "lens-information-economics"
			relation: "complementsWith"
			context:  "Information-economics ajuda a modelar valor, externalidade e verificabilidade da informação; commons trata a governança coletiva do recurso informacional."
		},
		{
			lensId:   "lens-platform-dynamics"
			relation: "complementsWith"
			context:  "Platform-dynamics modela crescimento e data network effects; commons modela como a qualidade do recurso compartilhado sustenta ou degrada esses efeitos."
		},
		{
			lensId:   "lens-credit-risk"
			relation: "feedsInto"
			context:  "Degradação do commons de dados afeta AUROC, model risk e risco de concentração. Commons informa quando credit-risk precisa recalibrar."
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "complementsWith"
			context:  "Financial-intermediation modela estrutura do FIDC e do funding; commons modela o pool como recurso compartilhado com externalidades e congestion."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "Behavioral-economics ajuda a entender fricção, reciprocidade e percepção de justiça; commons usa isso para calibrar contribuição, sanções e legitimidade."
		},
		{
			lensId:   "lens-network-theory"
			relation: "complementsWith"
			context:  "Network-theory mede cobertura, blind spots e clusters; commons explica como regras de contribuição e acesso afetam a qualidade do recurso que a rede produz."
		},
	]

	limitations: [
		{
			description: "No bootstrap, muitos problemas de commons ainda são potenciais e podem parecer prematuros."
			alternative: "Usar a lente seletivamente no início, principalmente para criação do commons, digitalização e lifecycle, e não para burocratizar governança cedo demais."
			rationale:   "A infraestrutura do commons nasce cedo, mas a governança pesada não."
		},
		{
			description: "A Mesh governa o commons e ao mesmo tempo explora valor dele."
			alternative: "Projetar mecanismos anti-enclosure desde cedo e evoluir para participação e contestação conforme a escala cresce."
			rationale:   "Judge in her own case é risco estrutural, não detalhe operacional."
		},
		{
			description: "Em segmentos informais, pressupor contribuição voluntária de dados digitais pode ser simplesmente falso."
			alternative: "Tratar digitalização e extração de dados como investimento da Mesh antes de exigir governança ativa de contribuição."
			rationale:   "Não se governa contribuição de dado que ainda não existe."
		},
		{
			description: "Os princípios de Ostrom foram formulados para commons físicos e locais, não diretamente para commons digitais operados por plataforma."
			alternative: "Usá-los como framework adaptado, não como transposição literal."
			rationale:   "A analogia é poderosa, mas não substitui contextualização."
		},
		{
			description: "Métricas de degradação de commons frequentemente têm causas concorrentes fora do commons."
			alternative: "Sempre separar diagnóstico de causa raiz da prescrição de governança."
			rationale:   "Sem essa separação, a lente passa a culpar o commons por tudo."
		},
		{
			description: "Monitoramento pode escalar pior do que a receita que o commons gera."
			alternative: "Automatizar, distribuir custo, explicitar monitoramento como custo estrutural e medir a saúde do próprio monitoramento."
			rationale:   "Commons mal monitorado degrada silenciosamente justamente quando cresce."
		},
	]

	rationale: "A Mesh cria e governa múltiplos commons digitais e financeiros cujo valor depende de contribuição coletiva, confiança institucional e governança progressivamente mais sofisticada. A lente distingue criação do commons de governança do commons; coordenação de incentivo; bens de clube de club goods com congestion; e free-riding de enclosure. Seu núcleo é que recursos compartilhados não são simplesmente 'ativos da plataforma': eles são infraestrutura coletiva cuja qualidade depende de lifecycle, heterogeneidade de participantes, excludabilidade calibrada, monitoramento escalável e proteção contra captura pela própria Mesh."
}
