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
	]
}
