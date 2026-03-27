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
			question:  "Qual atividade real está sendo executada?"
			reveals:   "Enquadramento regulatório correto"
			rationale: "Regulação segue o efeito, não o nome"
		},
		{
			question:  "Quais regimes essa atividade aciona?"
			reveals:   "Mapa regulatório"
			rationale: "Evita análise parcial"
		},
		{
			question:  "Existe conflito entre regimes?"
			reveals:   "Pontos de risco"
			rationale: "Conflitos são onde erros ocorrem"
		},
		{
			question:  "A decisão cruza alguma fronteira de regime?"
			reveals:   "Mudança de enquadramento"
			rationale: "Fronteiras são perigosas"
		},
		{
			question:  "No pior cenário regulatório, ainda funciona?"
			reveals:   "Robustez"
			rationale: "Projetar para pior caso"
		},
	]

	meshExamples: [
		{
			id:             "ex-bootstrap"
			scenario:       "Definir estrutura regulatória inicial"
			analysis:       "Decisão envolve múltiplos regimes e trade-offs de autonomia"
			recommendation: "Escolher caminho que minimize lock-in estrutural"
			principlesApplied: ["ax-01", "ax-03"]
			assumptions: ["há múltiplas opções viáveis"]
			rationale: "Licenciamento define trajetória"
		},
		{
			id:             "ex-recovery"
			scenario:       "Sacado entra em recuperação judicial"
			analysis:       "Formalização não elimina risco econômico"
			recommendation: "Gerenciar concentração e exposição"
			principlesApplied: ["ax-05"]
			assumptions: ["exposição relevante ao sacado"]
			rationale: "Enforcement real difere do teórico"
		},
	]

	principleIds: [
		"ax-01",
		"ax-03",
		"ax-05",
		"dp-04",
		"dp-05",
	]

	limitations: [
		{
			description: "Regulação muda constantemente"
			alternative: "Atualização contínua"
			rationale:   "Evitar obsolescência"
		},
		{
			description: "Não substitui aconselhamento jurídico"
			alternative: "Usar como framework"
			rationale:   "Aumenta qualidade da decisão"
		},
	]

	rationale: "Esta lente garante que decisões respeitem e utilizem a regulação como parte do sistema, não como restrição externa."
}
