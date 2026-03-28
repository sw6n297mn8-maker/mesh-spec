package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

theoryOfFirm: artifact_schemas.#AnalyticalLens & {
	id:      "lens-theory-of-firm"
	name:    "Teoria da Firma e Nova Economia Institucional"
	purpose: "Analisar as fronteiras organizacionais da Mesh, decidindo o que internalizar, delegar ou estruturar de forma híbrida com base em especificidade, complementaridade, controle, capacidade, escala, oportunismo, portabilidade e assimetria de erro."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve build vs buy, internalizar vs delegar a terceiro",
			"a decisão envolve definir o que a Mesh faz internamente vs o que parceiros fazem",
			"a decisão envolve escolher entre integração vertical e contratação via mercado",
			"a decisão envolve avaliar se um BaaS ou provider externo deve ser substituído por solução própria",
			"a decisão envolve estruturar contrato ou parceria de longo prazo com fornecedor de infraestrutura",
			"a decisão envolve classificar subdomínios como core, supporting ou generic",
			"a decisão envolve avaliar dependência de terceiro e risco de lock-in",
			"a decisão envolve definir as fronteiras organizacionais da Mesh",
			"a decisão envolve quem detém controle sobre dados ou ativos gerados na operação",
			"a decisão envolve avaliar se a Mesh tem capacidade para executar internamente",
			"a decisão envolve decidir se a Mesh deve co-localizar ativos complementares ou aceitar separação entre firmas",
			"a decisão envolve calibrar investimento em portabilidade, abstração ou optionality",
			"a decisão envolve avaliar se uma decisão errada é recuperável ou existencial",
		]
		keywords: [
			"build or buy", "make or buy", "internalizar", "terceirizar",
			"BaaS", "parceiro", "provider", "integração vertical",
			"fronteira organizacional", "o que é nosso vs o que é de terceiro",
			"lock-in", "dependência", "trocar de fornecedor",
			"core domain", "supporting", "generic",
			"contrato", "SLA", "especificidade",
			"complementaridade", "direitos sobre dados", "controle",
			"escala mínima", "capacidade organizacional",
			"hold-up", "oportunismo", "residual rights",
			"asset specificity", "switching cost", "portabilidade",
			"governança", "hierarquia", "mercado", "híbrido",
			"refém mútuo", "dependência bilateral", "custos de transação",
		]
		excludeWhen: [
			"a decisão é sobre design de regras de interação entre participantes da rede — usar mechanism-design",
			"a decisão é sobre estrutura informacional entre participantes — usar information-economics",
			"a decisão é sobre risco de crédito ou composição de carteira — usar credit-risk",
			"a decisão é sobre funding, liquidez ou veículo regulatório sem componente de fronteira organizacional — usar financial-intermediation",
			"a decisão é sobre design interno de código ou arquitetura de software sem componente de fronteira organizacional — usar architecture",
			"a decisão é sobre topologia da rede e contágio estrutural — usar network-theory",
		]
		rationale: "Toda decisão sobre os limites da Mesh — o que pertence ao núcleo da firma e o que pode ser coordenado por mercado ou forma híbrida — é decisão de teoria da firma. Sem esta lens, decisões de build vs buy, portabilidade, BaaS, providers de IA, registradoras, administração fiduciária e controle de dados são tomadas por conveniência ou custo imediato, ignorando custos de transação, complementaridade, oportunismo, lock-in, escala mínima, poder de barganha e assimetria de erro."
	}

	concepts: [
		{
			id:                "tf-transaction-costs"
			name:              "Custos de Transação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Custos de usar o mercado para coordenar uma atividade: busca, seleção, negociação, monitoramento, adaptação contratual, resolução de disputa e substituição de fornecedor. A firma existe quando coordenar internamente custa menos do que transacionar no mercado."
			meshManifestation: "A Mesh enfrenta custos de transação em duas camadas. Externamente, ela existe justamente para reduzir custos de transação entre compradores e fornecedores. Internamente, ela também enfrenta custos de transação ao depender de BaaS, providers de IA, administradores fiduciários, registradoras, bureaus e infraestrutura especializada."
			meshImplication:   "Toda decisão de delegar deve considerar custo total de transação, não apenas preço do fornecedor. Isso inclui negociação, monitoramento, renegociação, troubleshooting, custo de integração e custo de troca. Na Mesh operada por IA, parte desses custos pode cair porque agentes monitoram SLA, extraem evidência e detectam desvios continuamente. Essa redução desloca o limiar de internalização, mas não o elimina."
			rationale:         "É o conceito fundante de Coase. Sem ele, a firma vira coleção de decisões ad hoc."
		},
		{
			id:                "tf-coordination-costs"
			name:              "Custos de Coordenação Interna"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Internalizar uma atividade não elimina custo; troca custo de mercado por custo de coordenação interna. Esses custos incluem alinhamento, QA, manutenção, supervisão, gestão de exceções, burocratização e custo de oportunidade do management."
			meshManifestation: "Na Mesh AI-native, custos de coordenação não são apenas humanos. Incluem manutenção de contexto entre agentes, validação de outputs, drift de modelo, contratos entre componentes, consistência operacional, guardrails, observabilidade e custo de revisão humana nas saídas críticas."
			meshImplication:   "Sempre comparar custos de transação com custos de coordenação. Alta especificidade sem capacidade ou sem regime de QA robusto não justifica internalização imediata. O erro clássico é ver custo de terceiro e ignorar custo total de operar internamente algo crítico."
			dependsOn:         ["tf-transaction-costs"]
			rationale:         "Sem esta metade, a lens fica enviesada pró-build."
		},
		{
			id:                "tf-opportunism"
			name:              "Oportunismo"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Busca de interesse próprio com artifício. Inclui hold-up, shirking, adverse selection pré-contratual e strategic misrepresentation. Oportunismo é mais amplo que descumprimento explícito de contrato."
			meshManifestation: "Um BaaS pode cumprir formalmente o SLA, mas degradar qualidade de suporte para clientes pequenos. Um provider de IA pode induzir lock-in por features proprietárias. Uma registradora pode ganhar poder de barganha depois que a Mesh já internalizou a integração e o fluxo jurídico associado."
			meshImplication:   "Para cada parceiro, mapear quais formas de oportunismo são plausíveis. Monitorar além do contrato. Cláusula contratual é defesa insuficiente se a Mesh não consegue observar, auditar e trocar."
			dependsOn:         ["tf-transaction-costs"]
			rationale:         "Custos de transação são altos porque oportunismo é real, não teórico."
		},
		{
			id:                "tf-asset-specificity"
			name:              "Especificidade de Ativo"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quanto mais um ativo perde valor fora de uma relação específica, mais específico ele é. Alta especificidade aumenta risco de hold-up e tende a favorecer internalização ou governança híbrida mais forte."
			meshManifestation: "Modelos calibrados com dados Mesh, dados de qualificação enriquecidos, embeddings e workflows construídos sobre contratos e estados próprios da plataforma têm especificidade alta. Pix, compute e storage commodity têm especificidade baixa. Há também especificidade temporal: certas atividades só valem se ocorrerem no momento certo."
			meshImplication:   "Mapear especificidade por atividade e por ativo. Especificidade alta em dados, modelos e workflows críticos empurra para internalização ou pelo menos controle mais forte. Especificidade temporal exige SLAs proporcionais à criticidade do timing."
			dependsOn:         ["tf-transaction-costs"]
			rationale:         "É o principal driver estrutural de integração vertical em Williamson."
		},
		{
			id:                "tf-temporal-specificity"
			name:              "Especificidade Temporal"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O valor do ativo ou da transação depende criticamente do momento em que algo ocorre. Quando timing é parte do valor, atraso não é só inconveniência; é destruição econômica do ativo."
			meshManifestation: "Liquidação, registro, elegibilidade de recebível, confirmação operacional e execução de fluxos críticos da Mesh são temporalmente específicos. Um parceiro que entrega com dados certos, mas atrasados, ainda pode destruir valor."
			meshImplication:   "Para toda atividade temporalmente específica, SLA deve ser tratado como requisito estrutural, não como conveniência comercial. Isso afeta build vs buy, redundância, observabilidade e severidade de incidentes."
			dependsOn:         ["tf-asset-specificity"]
			rationale:         "Na Mesh, tempo é parte do ativo, especialmente no plano financeiro-operacional integrado."
		},
	]
}
