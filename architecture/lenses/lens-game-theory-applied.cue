package lenses

import "mesh-spec/architecture/artifact-schemas"

gameTheoryApplied: artifact_schemas.#AnalyticalLens & {
	id:      "lens-game-theory-applied"
	name:    "Teoria dos Jogos Aplicada"
	purpose: "Analisar comportamento estratégico de participantes, concorrentes e da própria Mesh dado um conjunto de regras, incentivos e restrições. A lente é usada para entender reação, barganha, cooperação, defecção, multi-homing, bypass e competição dinâmica."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve como um participante reagirá estrategicamente a uma ação da Mesh",
			"a decisão envolve competição entre a Mesh e incumbentes, como bancos, fatores, ERPs, ou novos entrantes",
			"a decisão envolve decisão de entrada ou saída de participante",
			"a decisão envolve sinalização, isto é, como participante comunica tipo por ações",
			"a decisão envolve barganha entre partes com poder assimétrico",
			"a decisão envolve coordenação entre participantes que precisam convergir",
			"a decisão envolve credibilidade de compromisso da Mesh ou de participante",
			"a decisão envolve cooperação ou defecção em interações repetidas",
			"a decisão envolve switching costs, lock-in, multi-homing, ou risco de bypass",
			"a decisão envolve investimento ou desinvestimento em reputação, ou inflação de scores",
			"a decisão envolve composição do pool de participantes e risco de adverse selection",
			"a decisão envolve sequência de movimentos, em que quem age primeiro importa",
		]
		keywords: [
			"estratégia", "strategy", "estratégico",
			"competição", "concorrente", "incumbent",
			"entrada", "entry", "saída", "exit",
			"sinalização", "signaling", "separating",
			"barganha", "bargaining", "negociação",
			"coordenação", "coordination game",
			"compromisso", "commitment", "credibilidade",
			"cooperação", "defecção", "retaliação",
			"switching cost", "lock-in", "bypass",
			"multi-homing", "uso parcial", "diversificação",
			"reputação", "reputation", "desinvestimento",
			"inflação de score", "reputation inflation",
			"envelopment", "plataforma adjacente",
			"adverse selection", "pool", "composição",
			"guerra de atrito", "war of attrition",
			"data moat", "learning", "retornos crescentes",
		]
		excludeWhen: [
			"a decisão é sobre design de mecanismos ótimos, como screening e revelation; usar lens-mechanism-design",
			"a decisão é sobre termos contratuais específicos; usar lens-contract-theory",
			"a decisão é sobre efeitos de rede agregados e chicken-and-egg; usar lens-platform-dynamics",
			"a decisão é sobre vieses comportamentais; usar lens-behavioral-economics",
			"a decisão é sobre topologia de rede; usar lens-network-theory",
			"a decisão é sobre estrutura de mercado, como thickness, timing e congestion; usar lens-market-design",
		]
		rationale: "Mechanism design projeta mecanismos. Teoria dos jogos analisa comportamento estratégico dado regras, inclusive interações fora do controle direto da Mesh. Na Mesh, entrada é jogo de coordenação, composição é adverse selection, formalização é sinal crível, cooperação é jogo repetido, competição ocorre sob multi-homing provável, barganha depende de outside options e switching costs, reputação é investimento depreciável sujeito a inflação, bypass é defecção recorrente, e credibilidade é stock assimétrico."
	}

	concepts: [
		{
			id:                "gt-coordination-entry"
			name:              "Jogo de Coordenação na Entrada"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O payoff de entrar depende de quem mais entra. Platform-dynamics modela o agregado; esta lente modela a decisão individual e a sequência estratégica. Pontos focais e anti-cascades importam: poucos participantes podem esperar pelos outros, e investidores podem inferir negativamente da ausência de adesão."
			meshManifestation: "Fornecedor pensa que sem comprador anchor não vale a pena entrar. Investidor vê meses sem adesão e pode inferir problema oculto. Anchor, fornecedores e investidor formam uma sequência em que o timing afeta a percepção."
			meshImplication:   "A Mesh deve reduzir risco de entrada unilateral, criar modos de valor parcial no bootstrap e sequenciar adesão de forma deliberada. Se esperar domina entrar, é preciso alterar o payoff de entrada."
			rationale:         "A entrada não é apenas problema de produto; é problema estratégico de coordenação e inferência."
		},
		{
			id:                "gt-adverse-selection-pool"
			name:              "Adverse Selection na Composição do Pool"
			nature:            "theoretical"
			role:              "framework"
			definition:        "No bootstrap, participantes que entram espontaneamente podem ser desproporcionalmente os que têm piores outside options. Isso deteriora o pool, aumenta perdas e pode afastar funding e participantes de melhor qualidade."
			meshManifestation: "Fornecedores que não conseguem crédito em outros canais entram primeiro. Bons fornecedores, com desconto direto ou relação bancária, adiam entrada. O resultado é um pool inicial enviesado negativamente."
			meshImplication:   "Estratégias anchor-first e curated pools são superiores a aquisição aberta sem filtro no início. A Mesh deve comparar performance de curated versus self-selected e limitar exposição a pools adversos."
			rationale:         "No bootstrap, composição do pool pode ser risco existencial."
			dependsOn:         ["gt-coordination-entry"]
		},
		{
			id:                "gt-signaling-strategic"
			name:              "Sinalização Estratégica Voluntária"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Sinais separam tipos quando seu custo é diferencial. Cheap talk pode transmitir informação, mas com ruído e limites. Sinalização voluntária é distinta de screening desenhado pela Mesh."
			meshManifestation: "Formalização, transparência operacional, retention e publicação de comportamento de pagamento funcionam como sinais. Roadmaps e promessas ao investidor funcionam como cheap talk parcial."
			meshImplication:   "A Mesh deve privilegiar sinais com custo diferencial, sustentáveis e verificáveis. Comunicação sem custo real deve ser tratada como complementar, não como base de decisão."
			rationale:         "Sinais críveis mudam equilíbrio; sinais baratos apenas influenciam percepção."
			dependsOn:         ["gt-coordination-entry"]
		},
		{
			id:                "gt-reputation-investment"
			name:              "Reputação como Investimento Depreciável e Risco de Inflação"
			nature:            "theoretical"
			role:              "property"
			definition:        "Reputação é um stock que acumula e se deprecia. Seu valor depende do horizonte do participante e da capacidade do sistema de manter poder discriminatório. Se scores inflacionam, perdem capacidade de separar tipos."
			meshManifestation: "Um fornecedor pode investir em reputação enquanto horizonte é longo e desinvestir em crise. Se a média dos scores sobe e a variância cai sem melhora operacional correspondente, um score alto deixa de distinguir bom de mediano."
			meshImplication:   "A Mesh deve monitorar derivadas de comportamento, distribuição de scores e necessidade de recalibração. Variáveis objetivas e mais granulares são melhores do que confirmações binárias excessivamente permissivas."
			rationale:         "Reputação sem discriminação informacional deixa de ser ativo estratégico."
			dependsOn:         ["gt-coordination-entry"]
		},
		{
			id:                "gt-switching-costs-lockin"
			name:              "Switching Costs, Multi-Homing e Portabilidade Seletiva"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Em muitos mercados, inclusive na construção civil, multi-homing é mais provável que single-homing. Isso reduz switching costs efetivos, preserva outside options e transforma competição em disputa por share, não em winner-take-all."
			meshManifestation: "Fornecedor usa Mesh para parte dos recebíveis e fator tradicional para outra parte. A Mesh vê só parte do histórico, o que enfraquece inferência e pode permitir seleção estratégica de quais recebíveis mandar para cada canal."
			meshImplication:   "A estratégia da Mesh deve assumir coexistência e buscar crescimento de share pela superioridade informacional e econômica demonstrada dentro da parcela operada, não por exclusividade forçada."
			rationale:         "Multi-homing muda switching costs, barganha, moat e dinâmica competitiva."
			dependsOn:         ["gt-coordination-entry"]
		},
		{
			id:                "gt-repeated-games-cooperation"
			name:              "Jogos Repetidos, Cooperação e Threshold de Desconto"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Cooperação em jogos repetidos depende de horizonte, detectabilidade de desvio e punição crível. Quando o desconto implícito cai, relações migram de regime relacional para regime mais formal."
			meshManifestation: "Em relações estáveis, reputação sustenta cooperação. Em crise, comportamento pode degradar rapidamente. Em ambientes ruidosos, respostas binárias e sem perdão geram ruptura indevida."
			meshImplication:   "A Mesh deve distinguir ruído de defecção, calibrar punição proporcional e entender quando precisa sair de regime relacional para regime contratual mais duro."
			rationale:         "A principal variável prática é o threshold em que cooperação deixa de ser estável."
			dependsOn:         ["gt-coordination-entry"]
		},
		{
			id:                "gt-competitive-dynamics"
			name:              "Dinâmica Competitiva, Envelopment e Data-Enabled Learning"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Competição não depende apenas de preço. Importam diferenciação, envelopment por plataformas adjacentes, multi-homing e aprendizado cumulativo baseado em dados. Em cenário multi-homing, learning compounding costuma ser moat mais robusto do que lock-in puro."
			meshManifestation: "Banco compete por taxa, ERP com parceiro financeiro pode envelopar o caso de uso, e a Mesh só se diferencia se usar dados operacionais para precificar e decidir melhor do que concorrentes com menos contexto."
			meshImplication:   "A Mesh deve competir por share crescente, priorizar transações que melhoram o modelo e tratar cada interação como investimento em aprendizado, não só em margem imediata."
			rationale:         "Em ambiente com multi-homing, data-enabled learning é defesa mais robusta do que switching costs artificiais."
			dependsOn:         ["gt-coordination-entry", "gt-switching-costs-lockin"]
		},
		{
			id:                "gt-bargaining-asymmetric"
			name:              "Barganha com Outside Options, Switching Costs e Timing"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Poder de barganha depende de outside options, paciência, timing e custos de mudança. Em multi-homing, outside options permanecem mais fortes, o que reduz a alavanca da Mesh baseada apenas em lock-in."
			meshManifestation: "Um anchor pode aceitar a Mesh, mas manter parte do fluxo fora. Isso preserva sua BATNA e torna a inversão de poder mais lenta do que em cenário single-homing."
			meshImplication:   "A Mesh deve entrar em barganhas com BATNA explícita, evitar negociar sob pressão e usar vantagem informacional e valor demonstrado como principal alavanca, não só custo de mudança."
			rationale:         "Barganha piora quando a Mesh depende demais de uma contraparte e superestima seu próprio lock-in."
			dependsOn:         ["gt-switching-costs-lockin", "gt-competitive-dynamics"]
		},
		{
			id:                "gt-commitment-credibility"
			name:              "Commitment e Credibilidade como Stock Assimétrico"
			nature:            "theoretical"
			role:              "property"
			definition:        "Compromissos só são críveis quando existe custo real de revogação ou enforcement efetivo. Credibilidade acumula lentamente e pode ser destruída rapidamente. Automação pode funcionar como commitment device."
			meshManifestation: "Regras automáticas de scoring, pricing e punição tornam promessas mais críveis do que decisões totalmente discricionárias. Exceções arbitrárias corroem confiança rapidamente."
			meshImplication:   "A Mesh deve automatizar compromissos críticos sempre que possível e manter tolerância baixíssima a rompimentos explícitos de promessa, sobretudo em sistemas centrais."
			rationale:         "Credibilidade é ativo estratégico assimétrico: lenta para construir, rápida para destruir."
			dependsOn:         ["gt-signaling-strategic", "gt-repeated-games-cooperation"]
		},
		{
			id:                "gt-platform-bypass"
			name:              "Platform Bypass como Defecção em Jogo Repetido"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Bypass ocorre quando partes usam a Mesh para descobrir, qualificar ou viabilizar uma transação e depois a executam fora para evitar taxa ou governança. Isso é diferente de multi-homing legítimo em transações diferentes."
			meshManifestation: "Fornecedor usa a Mesh para antecipar uma primeira operação, ganha confiança com comprador e depois tenta operar fora nas próximas para evitar pagamento de taxa."
			meshImplication:   "A Mesh precisa distinguir bypass de multi-homing, investir em detectabilidade e garantir valor incremental por transação suficiente para tornar bypass menos atraente. Eliminá-lo completamente é improvável."
			rationale:         "Bypass é defecção recorrente, não simples churn."
			dependsOn:         ["gt-switching-costs-lockin", "gt-repeated-games-cooperation", "gt-coordination-entry"]
		},
		{
			id:                "gt-coordination-standards"
			name:              "Jogos de Coordenação com Padrões Concorrentes"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quando há padrões concorrentes reais, a decisão estratégica envolve compatibilidade, coexistência ou battle of standards. Sem concorrência efetiva de padrão, o problema tende a ser mais de adoção agregada do que de coordenação estratégica bilateral."
			meshManifestation: "Template da Mesh pode competir com padrão imposto por ERP ou canal financeiro já estabelecido. Participantes resistem se precisarem operar em dois padrões incompatíveis."
			meshImplication:   "A Mesh deve preferir compatibilidade com padrões existentes quando isso não destrói diferenciação essencial. Battle of standards só faz sentido quando há vantagem estrutural suficiente."
			rationale:         "Compatibilidade costuma ser superior a imposição quando a empresa ainda está consolidando adoção."
			dependsOn:         ["gt-coordination-entry"]
		},
		{
			id:                "gt-strategic-information-revelation"
			name:              "Revelação Estratégica e Unraveling Verificável"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Informação tende a ser revelada estrategicamente quando é verificável e sua omissão gera suspeita. Sem verificabilidade, comunicação vira cheap talk. Tendências ao longo do tempo costumam ser mais úteis do que snapshots isolados."
			meshManifestation: "Comprador publicar histórico real de pagamento só funciona como sinal se puder ser verificado. Dados de tendência de atraso, disputa e conformidade geram separação melhor do que snapshots pontuais."
			meshImplication:   "A Mesh deve priorizar campos verificáveis, séries temporais e mecanismos de revelação que aumentem separação sem depender apenas de autodeclaração."
			rationale:         "Sem verificabilidade, revelação estratégica perde poder disciplinador."
			dependsOn:         ["gt-signaling-strategic", "gt-coordination-standards"]
		},
		{
			id:                "gt-mesh-strategic-health"
			name:              "Métricas de Saúde Estratégica"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "semi-annual"
			definition:        "A Mesh precisa acompanhar métricas estratégicas que indiquem estado do equilíbrio e transições relevantes, como defecção versus ruído, adverse selection entre cohorts, churn competitivo, share por participante, inflação de score, bypass e taxa de aprendizado informacional."
			meshManifestation: "No bootstrap, cooperação é frágil, multi-homing é alto, switching costs são baixos e a qualidade do scoring ainda está em formação. Sem métricas estratégicas, esses fenômenos parecem apenas ruído operacional."
			meshImplication:   "O dashboard estratégico deve monitorar composição do pool, participação relativa da Mesh, sinais de desinvestimento em reputação, calibração do scoring e se dados realmente estão gerando vantagem de aprendizado."
			rationale:         "Sem métricas estratégicas, a empresa só enxerga sintomas tardios e confunde dinâmica estrutural com variação operacional."
		},
	]

	// Seções pendentes: reasoningProtocol, meshExamples, principleIds,
	// relatedLenses, limitations, rationale.
	// Serão fornecidas pelo founder em seguida.
}
