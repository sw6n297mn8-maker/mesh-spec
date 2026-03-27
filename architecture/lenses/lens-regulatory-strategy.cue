package lenses

import "mesh-spec/architecture/artifact-schemas"

regulatoryStrategy: artifact_schemas.#AnalyticalLens & {
	id:      "lens-regulatory-strategy"
	name:    "Estratégia Regulatória"
	purpose: "Tratar regulação como infraestrutura de operação, dados e capital. Avalia decisões que alteram enquadramento, permissões, obrigações e viabilidade econômica da Mesh."
	status:  "active"

	trigger: {
		conditions: [
			"a decisão envolve licença, autorização ou enquadramento regulatório",
			"a decisão envolve FIDC, incluindo CVM 175, servicer, gestão de fato ou liquidação antecipada",
			"a decisão envolve cessão, registradora, trava bancária ou enforcement de recebíveis",
			"a decisão envolve LGPD, PLD, sigilo bancário ou conflitos entre regimes",
			"a decisão envolve regulação de IA, incluindo explicabilidade ou responsabilidade civil",
			"a decisão envolve Open Finance, cadastro positivo ou compartilhamento de dados",
			"a decisão envolve IOF, tributação ou impacto regulatório no unit economics",
			"a decisão envolve CDC ou fornecedor pequeno vulnerável",
			"a decisão envolve fronteira de regime ou atividade acidentalmente regulada",
		]
		keywords: [
			"regulação", "licença", "Bacen", "CVM", "ANPD", "CADE", "COAF",
			"FIDC", "cessão", "registradora", "trava bancária",
			"LGPD", "PLD", "sigilo bancário",
			"Open Finance", "cadastro positivo",
			"IOF", "tributação",
			"CDC", "consumidor",
			"Drex", "perfection", "KYC",
		]
		excludeWhen: [
			"termos contratuais específicos → lens-contract-theory",
			"risco de crédito individual → lens-credit-risk",
			"estrutura financeira do FIDC → lens-financial-intermediation",
		]
		rationale: "Regulação define o que pode existir, operar e escalar. É constraint estrutural e mecanismo de criação de valor."
	}

	concepts: [
		{
			id:                "rs-legal-capital"
			name:              "Capital Legal como Infraestrutura"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Recebíveis tornam-se financiáveis quando passam por módulos jurídicos como documentação, registro e cessão. A Mesh facilita acesso a esses módulos."
			meshManifestation: "NF, duplicata e registro transformam fluxo informal em ativo financiável."
			meshImplication:   "Compliance que habilita capital deve ser tratado como core do produto."
			rationale:         "Sem estrutura jurídica, não existe capital financiável."
		},
		{
			id:                "rs-regulatory-map"
			name:              "Mapa Regulatório Integrado"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A Mesh opera sob múltiplos regimes simultâneos que podem entrar em conflito."
			meshManifestation: "Uma operação pode envolver CVM, LGPD, PLD e tributação ao mesmo tempo."
			meshImplication:   "Toda decisão deve mapear regimes e conflitos explicitamente."
			rationale:         "Erro ocorre na interseção entre regimes."
		},
		{
			id:                "rs-licensing-strategy"
			name:              "Estratégia de Licenciamento"
			nature:            "theoretical"
			role:              "method"
			definition:        "Diferentes caminhos regulatórios implicam trade-offs entre velocidade, autonomia e margem."
			meshManifestation: "Parceria acelera entrada, mas reduz controle."
			meshImplication:   "Escolhas devem ser feitas como se a empresa já estivesse em escala."
			rationale:         "Licenciamento define trajetória."
			dependsOn:         ["rs-regulatory-map"]
		},
		{
			id:                "rs-lgpd-architecture"
			name:              "Arquitetura LGPD"
			nature:            "theoretical"
			role:              "method"
			definition:        "LGPD exige separação por finalidade, explicabilidade e retenção adequada."
			meshManifestation: "Scoring explicável não pode depender de dados confidenciais de PLD."
			meshImplication:   "Arquitetura deve separar camadas de decisão e compliance."
			rationale:         "Misturar camadas gera conflito regulatório."
			dependsOn:         ["rs-regulatory-map"]
		},
		{
			id:                "rs-ai-governance"
			name:              "Governança de IA"
			nature:            "theoretical"
			role:              "property"
			definition:        "Decisões automatizadas com impacto econômico exigem auditabilidade e fallback humano."
			meshManifestation: "Decisão de crédito precisa ser explicável e rastreável."
			meshImplication:   "Separar sistemas críticos de sistemas experimentais."
			rationale:         "IA sem governança vira passivo."
			dependsOn:         ["rs-lgpd-architecture"]
		},
		{
			id:                "rs-tax-impact"
			name:              "Impacto Regulatório no Unit Economics"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Custos regulatórios podem inviabilizar economicamente certas operações."
			meshManifestation: "IOF e registradora consomem margem em tickets pequenos."
			meshImplication:   "Produto deve ter thresholds explícitos."
			rationale:         "Regulação impacta diretamente viabilidade."
			dependsOn:         ["rs-regulatory-map"]
		},
		{
			id:                "rs-fidc-boundary"
			name:              "Fronteira de Gestão em FIDC"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Diferença entre recomendar e gerir é crítica."
			meshManifestation: "Servicer pode cruzar linha para gestão de fato."
			meshImplication:   "Papéis devem ser explicitamente definidos."
			rationale:         "Erro aqui é existencial."
		},
		{
			id:                "rs-regulatory-boundaries"
			name:              "Fronteiras de Regime"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Software pode se tornar atividade regulada dependendo do efeito produzido."
			meshManifestation: "Feature de pagamento pode virar atividade regulada."
			meshImplication:   "Fronteiras devem ser explicitamente modeladas."
			rationale:         "Erro nasce de não perceber a fronteira."
		},
		{
			id:                "rs-regulatory-risk"
			name:              "Risco Regulatório Correlacionado"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Mudanças regulatórias podem ocorrer de forma combinada."
			meshManifestation: "LGPD + IA + Open Finance mudando juntos."
			meshImplication:   "Decisões devem resistir ao pior cenário plausível."
			rationale:         "Correlação aumenta impacto."
		},
		{
			id:                "rs-regulatory-health"
			name:              "Saúde Regulatória"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "Monitorar poucos indicadores críticos de conformidade e risco."
			meshManifestation: "KYC, SLA e compliance crítico como métricas centrais."
			meshImplication:   "Foco em métricas existenciais."
			rationale:         "Evita falsa sensação de controle."
		},
	]

	reasoningProtocol: [
		{
			question:  "Qual atividade concreta está sendo proposta e quais regimes ela aciona?"
			reveals:   "Mapa inicial de enquadramento a partir do fato operacional."
			rationale: "A unidade de análise é a atividade real."
		},
		{
			question:  "A decisão cruza alguma fronteira de regime?"
			reveals:   "Se a empresa está entrando em território regulado sem tratar explicitamente."
			rationale: "Muitos erros vêm de chamar de software algo que produz efeito regulado."
		},
		{
			question:  "Que módulo de capital legal esta decisão habilita ou fragiliza?"
			reveals:   "Conexão entre obrigação regulatória e efeito econômico real."
			rationale: "Regulação importa tanto pelo que proíbe quanto pelo que permite."
		},
		{
			question:  "Existe conflito entre explicabilidade, confidencialidade, retenção ou reporte?"
			reveals:   "Colisões entre regimes que exigem separação arquitetural."
			rationale: "Risco surge quando dados estão sob obrigações incompatíveis."
		},
		{
			question:  "O recebível é elegível de fato, considerando ônus, trava e recuperação judicial?"
			reveals:   "Diferença entre elegibilidade aparente e real."
			rationale: "O loop quebra quando o ativo falha no enforcement."
			appliesWhen: "cessão, elegibilidade ou funding"
		},
		{
			question:  "A solução cria dependência estrutural de parceiro, licença ou interpretação frágil?"
			reveals:   "Lock-ins e fragilidades de trajetória."
			rationale: "Decisões devem ser tomadas como se a empresa já estivesse em escala."
			appliesWhen: "bootstrap regulatório ou parceria"
		},
		{
			question:  "No pior cenário regulatório plausível, a solução continua operável e defensável?"
			reveals:   "Robustez sob estresse regulatório combinado."
			rationale: "Escolhas devem resistir ao pior caso plausível."
		},
		{
			question:  "Que guardrails e métricas precisam nascer junto com a decisão?"
			reveals:   "Controles operacionais concretos necessários."
			rationale: "Governança nasce junto com execução."
		},
	]

	meshExamples: [
		{
			id:                "ex-bootstrap-regulatory"
			scenario:          "A Mesh precisa escolher sua sequência regulatória inicial para operar antecipação de recebíveis."
			analysis:          "A atividade aciona CVM, registradora, PLD, LGPD e tributação simultaneamente. Escolher apenas pela entrada mais rápida ignora lock-in e compatibilidade futura."
			recommendation:    "Implementar KYC proporcional, consulta de ônus, separação scoring/compliance e trilha auditável desde o dia 1. Avaliar via de entrada por autonomia e compatibilidade com arquitetura alvo."
			principlesApplied: ["ax-01", "ax-03", "dp-04"]
			assumptions: [
				"existe via regulatória viável de entrada",
				"a Mesh pretende evoluir para maior autonomia",
			]
			rationale: "Decisão regulatória inicial já deve ser feita com mentalidade de estado final."
		},
		{
			id:                "ex-sacado-recuperacao"
			scenario:          "Construtora relevante entra em recuperação judicial após cessão de duplicatas ao FIDC."
			analysis:          "Cessão melhora posição jurídica, mas não elimina risco econômico do sacado. Problema passa a ser enforcement, concentração e continuidade do funding."
			recommendation:    "Suspender novas exposições, comunicar gestor e administrador, provisionar conservadoramente e tratar monitoramento de saúde do pagador como controle estrutural."
			principlesApplied: ["ax-05", "dp-05", "dp-09"]
			assumptions: [
				"o fundo está exposto materialmente ao sacado",
			]
			rationale: "Qualidade jurídica do recebível não substitui gestão de risco de contraparte."
		},
		{
			id:                "ex-regimes-simultaneos"
			scenario:          "Fornecedor pequeno contesta taxa e decisão automatizada enquanto cadastro positivo pressiona compartilhamento."
			analysis:          "Três regimes convergem: compartilhamento informacional, proteção do vulnerável e explicabilidade. O risco aparece na interface operacional."
			recommendation:    "Separar dados operacionais de crédito, revisar camada contratual para CDC, implementar contestação acessível e garantir explicação de scoring apenas com variáveis explicáveis."
			principlesApplied: ["ax-07", "dp-05"]
			assumptions: [
				"o fornecedor pode ser tratado como parte vulnerável",
			]
			rationale: "Robustez real aparece quando múltiplos regimes incidem sobre a mesma operação."
		},
	]

	principleIds: [
		"ax-01",
		"ax-03",
		"ax-05",
		"ax-06",
		"ax-07",
		"dp-02",
		"dp-04",
		"dp-05",
		"dp-09",
	]

	relatedLenses: [
		{
			lensId:   "lens-contract-theory"
			relation: "complementsWith"
			context:  "Esta lente enquadra limites regulatórios; contract-theory traduz em cláusulas e desenho contratual."
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "complementsWith"
			context:  "Enquadramento regulatório define permissões; financial-intermediation modela viabilidade econômica."
		},
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "Regulação define elegibilidade e fronteiras; credit-risk traduz em PD, LGD e política de exposição."
		},
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Regulação define limites do observável e exigível; mechanism-design estrutura incentivos dentro desses limites."
		},
	]

	limitations: [
		{
			description: "Regulação muda frequentemente e parte relevante está em evolução."
			alternative: "Manter a lente como artefato vivo e operar pelo cenário mais restritivo plausível."
			rationale:   "O objetivo é robustez decisória sob mudança."
		},
		{
			description: "Muitas fronteiras dependem de fatos e interpretação jurídica contextual."
			alternative: "Usar a lente para estruturar hipóteses e escalar para opinião legal formal em decisões críticas."
			rationale:   "A lente melhora enquadramento, mas não substitui validação especializada."
		},
		{
			description: "Custos regulatórios podem inviabilizar tickets pequenos."
			alternative: "Usar thresholds, agrupamento e comunicação honesta sobre limites econômicos."
			rationale:   "Prometer viabilidade universal sem sustentação econômica é erro de produto."
		},
	]

	rationale: "Regulação na Mesh não é camada acessória. Ela determina quem opera, quais dados circulam, quais decisões são explicáveis, quais ativos são financiáveis e quais custos inviabilizam promessas de produto. A lente força a empresa a tratar enquadramento regulatório como infraestrutura, não como compliance reativo."
}
