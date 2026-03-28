package lenses

import "mesh-spec/architecture/artifact-schemas"

networkTheory: artifact_schemas.#AnalyticalLens & {
	id:      "lens-network-theory"
	name:    "Teoria de Redes e Topologia"
	purpose: "Modelar a estrutura comprador-fornecedor como um grafo bipartito multi-layer para identificar dependências, centralidades, comunidades, vulnerabilidades, divergências inter-camada e canais de contágio que afetam risco, crescimento e resiliência da Mesh."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve entender a estrutura de dependências entre participantes da rede",
			"a decisão envolve identificar quais participantes são críticos para a rede (hubs, bridges, SPOFs)",
			"a decisão envolve avaliar como um choque (default, saída, fraude, paralisação) se propaga pela rede",
			"a decisão envolve medir resiliência da rede a remoção de participantes ou deterioração gradual",
			"a decisão envolve detectar clusters, comunidades ou sub-redes naturais",
			"a decisão envolve como a topologia muda conforme a Mesh cresce",
			"a decisão envolve medir dependência assimétrica entre participantes",
			"a decisão envolve priorizar aquisição, retenção ou monitoramento com base em posição na rede",
			"a decisão envolve avaliar contágio entre compradores e fornecedores conectados",
			"a decisão envolve detectar divergência entre camadas financeira, operacional e informacional",
			"a decisão envolve distinguir diversificação aparente de diversificação real",
			"a decisão envolve avaliar se a rede está ficando mais resiliente ou apenas maior",
		]
		keywords: [
			"grafo", "rede", "topologia", "nó", "aresta",
			"centralidade", "hub", "bridge", "betweenness",
			"contágio", "cascata", "propagação", "falha",
			"resiliência", "robustez", "vulnerabilidade",
			"cluster", "comunidade", "subrede",
			"dependência", "assimetria", "concentração",
			"single point of failure", "SPOF",
			"grau", "degree", "eigenvector", "authority", "hub score",
			"bipartito", "projeção", "multi-layer",
			"divergência", "sobreposição", "backbone",
			"assortativity", "percolation", "community detection",
			"preferential attachment", "coverage",
		]
		excludeWhen: [
			"a decisão é sobre efeitos de rede de plataforma (chicken-and-egg, multi-homing, pricing multi-sided) sem componente topológico — usar platform-dynamics",
			"a decisão é sobre PD, LGD, spread ou provisão sem componente estrutural de rede — usar credit-risk",
			"a decisão é sobre desenho de incentivos ou regras de interação — usar mechanism-design",
			"a decisão é sobre fronteira organizacional e internalização — usar theory-of-firm",
			"a decisão é sobre supply chain apenas como fluxo operacional sem quantificação estrutural do grafo — usar supply-chain-theory",
		]
		rationale: "A Mesh enxerga a cadeia produtiva como um grafo real, não como lista de contrapartes isoladas. A rede comprador-fornecedor tem topologia, centralidades, comunidades, dependências assimétricas e múltiplas camadas que bancos e ERPs isolados não observam juntos. Network-theory transforma essa estrutura em ferramenta analítica para risco, expansão, retenção, contingência e resiliência. Sem esta lente, o agente vê relacionamentos, mas não vê estrutura."
	}

	concepts: [
		{
			id:                "nt-graph-representation"
			name:              "Representação em Grafo Bipartito Multi-Layer"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A rede da Mesh é um grafo bipartito, direcionado, ponderado e temporal. Bipartito porque há dois tipos de nós — compradores e fornecedores — e arestas apenas entre tipos. Direcionado porque fluxo operacional e financeiro têm sentido. Ponderado porque relações diferem em volume, frequência, prazo e criticidade. Temporal porque arestas surgem, desaparecem e mudam de peso ao longo do tempo. Multi-layer porque a mesma relação existe em camadas distintas: financeira (pagamentos, antecipações), operacional (pedidos, entregas, disputas) e informacional (score, compliance, qualificação, overrides)."
			meshManifestation: "A Mesh vê o mesmo par comprador↔fornecedor em múltiplas camadas. Um par pode estar forte na camada financeira e fraco na operacional, ou o inverso. A estrutura é assimétrica: poucos compradores, muitos fornecedores. Em construção civil, isso é especialmente relevante porque uma construtora grande ancora dezenas de fornecedores pequenos."
			meshImplication:   "Toda análise topológica deve começar declarando explicitamente: (a) qual camada está sendo analisada, (b) qual janela temporal, e (c) se a análise opera no bipartito completo ou em projeção. Nunca colapsar tudo em um único grafo sem justificar. Divergência entre camadas é informação, não ruído."
			rationale:         "O grafo multi-layer é a ontologia mínima correta. Sem isso, análises posteriores misturam estruturas incompatíveis."
		},
		{
			id:                "nt-graph-coverage"
			name:              "Cobertura do Grafo Observado"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O grafo que a Mesh observa é subconjunto da rede econômica real. Há arestas invisíveis por multi-homing, transações fora da plataforma, bypass pós-match, e participantes não-onboarded. Cobertura é a proporção estimada da rede relevante que passa pela Mesh. Todas as métricas topológicas dependem dessa cobertura."
			meshManifestation: "Fornecedor que parece depender 80% de um comprador na Mesh pode, na realidade, vender também para outros fora da plataforma. Comprador que parece periférico pode ser central na rede real por arestas invisíveis. A cobertura varia por segmento, região e estágio de adoção."
			meshImplication:   "Qualificar toda conclusão com o nível de cobertura estimado. Se cobertura >80%, a análise topológica pode suportar decisões fortes. Entre 50-80%, conclusões são úteis mas precisam de qualificação explícita. Entre 30-50%, tratar resultados como lower bounds e evitar prescrição definitiva. Abaixo de 30%, a análise formal é prematura — usar share por par, HHI e diagnóstico qualitativo."
			dependsOn:         ["nt-graph-representation"]
			rationale:         "Sem cobertura, a análise parece precisa mas não é confiável."
		},
		{
			id:                "nt-temporal-windowing"
			name:              "Janelas Temporais, Arestas Ativas e Arestas Latentes"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Topologia depende da janela temporal usada. Uma aresta pode ser ativa (houve atividade recente), latente (relação existe mas sem atividade recente), ou morta (relação encerrada). Grafo cumulativo mistura relações vivas e mortas e distorce centralidade, comunidade e resiliência."
			meshManifestation: "Fornecedor que vendeu para uma construtora há 18 meses mas não vende mais não deve influenciar a topologia operacional atual como se a relação estivesse viva. Já uma relação sem transação nos últimos 45 dias mas com contrato recorrente pode ser latente, não morta."
			meshImplication:   "Definir janela padrão por caso de uso: 30 dias para dinâmica recente, 90 dias para estrutura operacional corrente, 365 dias para histórico estratégico. Marcar explicitamente arestas ativas, latentes e encerradas. Métricas estruturais operacionais devem usar arestas ativas; análises de oportunidade comercial podem incluir latentes."
			dependsOn:         ["nt-graph-representation"]
			rationale:         "A mesma rede muda radicalmente dependendo da janela. Sem separar ativo de histórico, a análise perde aderência operacional."
		},
		{
			id:                "nt-bipartite-analysis"
			name:              "Análise Bipartida e Projeções Weighted"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A estrutura da Mesh é bipartida, e isso altera profundamente a interpretação de métricas. Muitas ferramentas genéricas funcionam mal diretamente no bipartito. Por isso, a análise correta exige decidir entre: (a) operar no bipartito com métricas bipartite-aware, ou (b) projetar para um grafo unimodal weighted relevante. Projeção de compradores conecta compradores que compartilham fornecedores; projeção de fornecedores conecta fornecedores que compartilham compradores."
			meshManifestation: "Na projeção de compradores, construtoras que compartilham muitos fornecedores têm risco estrutural parcialmente comum. Na projeção de fornecedores, fornecedores que compartilham muitos compradores competem ou são substitutos funcionais. Em ambos os casos, peso importa: compartilhar um fornecedor de grande volume não é equivalente a compartilhar um fornecedor residual."
			meshImplication:   "Pergunta sobre risco conjunto entre compradores → projeção weighted de compradores. Pergunta sobre substituição/competição entre fornecedores → projeção weighted de fornecedores. Pergunta sobre bridges reais entre lados → bipartito com métricas específicas. Nunca usar projeção unweighted. Nunca usar ferramenta genérica no bipartito sem validar se ela é estruturalmente adequada."
			dependsOn:         ["nt-graph-representation"]
			rationale:         "A escolha da representação é a decisão metodológica mais consequente da lente."
		},
		{
			id:                "nt-backbone-extraction"
			name:              "Backbone da Rede e Filtragem de Relações Relevantes"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Redes econômicas têm distribuição heavy-tailed: poucas arestas concentram a maior parte do valor, enquanto muitas são residuais. Métricas topológicas em grafo ruidoso produzem resultados ruidosos. Extrair o backbone significa manter apenas relações estruturalmente relevantes para o tipo de análise."
			meshManifestation: "Fornecedor com 1 transação residual de baixo valor com um comprador e 40 transações recorrentes com outro. Sem backbone, a aresta residual entra em comunidade, centralidade e caminhos como se fosse estruturalmente equivalente."
			meshImplication:   "Antes de rodar centralidade, comunidade, resiliência ou contágio estrutural, extrair backbone. No bootstrap, usar filtros conservadores para não apagar ties emergentes. Em growth, adotar filtros mais exigentes por frequência e share de volume. Preservar o grafo completo para fraude e investigação forense; usar backbone para análise estrutural."
			dependsOn:         ["nt-bipartite-analysis", "nt-temporal-windowing"]
			rationale:         "Sem backbone, o grafo formaliza ruído como estrutura."
		},
		{
			id:                "nt-centrality-measures"
			name:              "Centralidade Bipartite-Aware"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Centralidade mede importância estrutural de um nó, mas em grafos bipartitos assimétricos cada métrica tem interpretação específica. Weighted degree mede volume/frequência. Betweenness bipartite mede controle real de fluxo, descontando artefatos da bipartição. Hub/authority distingue compradores que estruturam a rede e fornecedores validados pelos melhores compradores."
			meshManifestation: "Comprador grande com muitas conexões é hub. Fornecedor atendido por compradores de alta qualidade e alta centralidade é authority. Bridge entre comunidades pode ter betweenness mais relevante que volume absoluto."
			meshImplication:   "Usar weighted degree para atividade, hub/authority para relevância econômica, e betweenness bipartite para vulnerabilidade estrutural. Para retenção, bridge entre comunidades pode ser mais valioso que hub local. Para aquisição, nó que aumenta conectividade entre comunidades pode ser superior a nó de grande volume local."
			dependsOn:         ["nt-bipartite-analysis", "nt-backbone-extraction"]
			rationale:         "Centralidade sem adaptação ao bipartito confunde volume com importância estrutural."
		},
		{
			id:                "nt-assortativity"
			name:              "Assortatividade e Padrão de Conexão entre Graus"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Assortatividade mede se nós de alto grau tendem a se conectar a outros nós de alto grau ou a nós de baixo grau. Redes buyer-supplier são tipicamente disassortativas: hubs compradores se conectam a periferia fornecedora. Isso altera velocidade e abrangência do contágio."
			meshManifestation: "Construtoras grandes ligadas a muitos fornecedores pequenos criam estrutura onde choque em hub se espalha diretamente para periferia. Isso torna o contágio via comprador central mais rápido e abrangente."
			meshImplication:   "Monitorar assortatividade como métrica estrutural. Rede mais disassortativa tende a ser mais frágil a choques em hubs compradores. Mudanças na assortatividade ao longo do tempo indicam transformação da estrutura da rede e podem exigir revisão de stress tests."
			dependsOn:         ["nt-centrality-measures"]
			rationale:         "Assortatividade muda como choques se espalham mesmo sem mudar volume agregado."
		},
	]
}
