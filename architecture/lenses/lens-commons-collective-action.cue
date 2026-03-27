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
	]
}
