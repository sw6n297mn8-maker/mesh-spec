package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

platformDynamics: artifact_schemas.#AnalyticalLens & {
	id:      "lens-platform-dynamics"
	name:    "Dinâmicas de Plataforma"
	purpose: "Analisar como a Mesh cria, acelera, sustenta e defende efeitos de plataforma entre compradores, fornecedores e investidores, identificando condições de bootstrap, massa crítica, retenção, desintermediação, concentração e defensibilidade."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve como atrair participantes para a rede (compradores, fornecedores, investidores)",
			"a decisão envolve qual lado da plataforma subsidiar e qual monetizar",
			"a decisão envolve resolver chicken-and-egg — como iniciar sem massa crítica",
			"a decisão envolve como o valor da plataforma muda conforme a rede cresce",
			"a decisão envolve retenção, churn ou switching costs dos participantes",
			"a decisão envolve como dados gerados pela rede melhoram o produto",
			"a decisão envolve expansão para nova cadeia produtiva, região ou vertical",
			"a decisão envolve como a posição da Mesh se fortalece ou enfraquece com escala",
			"a decisão envolve multi-homing — participantes que usam plataformas concorrentes simultaneamente",
			"a decisão envolve governança da plataforma ou equilíbrio de poder entre lados",
			"a decisão envolve risco de desintermediação — participantes transacionando fora da plataforma",
			"a decisão envolve concentração de rede — dependência de poucos participantes grandes",
			"a decisão envolve validar se a fricção no mercado é suficiente para sustentar plataforma",
			"a decisão envolve distinguir crescimento de rede real de crescimento apenas aparente",
			"a decisão envolve se a Mesh é de fato plataforma ou apenas serviço com linguagem de plataforma",
		]
		keywords: [
			"efeito de rede", "network effect", "plataforma", "marketplace",
			"chicken and egg", "cold start", "bootstrap", "massa crítica",
			"multi-sided", "dois lados", "subsidiar", "monetizar",
			"data network effect", "flywheel", "moat", "defensibilidade",
			"multi-homing", "single-homing", "switching cost",
			"winner takes all", "winner takes most", "tipping point", "liquidity",
			"churn", "retenção", "engajamento", "GMV",
			"desintermediação", "bypass", "leakage",
			"concentração", "anchor tenant", "dependência",
			"local network effect", "regional", "expansão",
			"fricção", "friction threshold", "viabilidade",
			"cold start problem", "penguin problem", "single-player mode",
			"cross-side", "same-side", "envelopment",
		]
		excludeWhen: [
			"a decisão é sobre design de regras de interação específicas (pricing, scoring, menus) — usar mechanism-design",
			"a decisão é sobre estrutura informacional ou qualidade de sinais — usar information-economics",
			"a decisão é sobre risco de crédito ou composição de carteira — usar credit-risk",
			"a decisão é sobre funding, liquidez financeira ou veículo regulatório — usar financial-intermediation",
			"a decisão é sobre fronteira organizacional make-or-buy sem componente de efeito de rede — usar theory-of-firm",
			"a decisão é sobre topologia do grafo e contágio estrutural — usar network-theory",
			"a decisão é sobre desenho do próprio mercado (alocação, clearing, timing) — usar market-design",
		]
		rationale: "A Mesh é plataforma multi-sided: compradores, fornecedores e investidores interagem por meio de infraestrutura compartilhada. O valor não depende apenas de ter produto melhor, mas de como a rede cresce, de quais lados entram primeiro, de como o valor cruzado entre lados se acumula, de como a plataforma evita bypass e de se os efeitos de rede são reais ou ilusórios. Sem esta lente, o agente trata crescimento como aquisição linear e perde os loops, tipping points, assimetrias de poder e riscos de falsa plataforma."
	}

	concepts: [
		{
			id:                "pd-friction-threshold"
			name:              "Friction Threshold e Viabilidade de Plataforma"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Uma plataforma só se sustenta se a fricção que resolve for grande o suficiente para justificar a coordenação multi-sided. B2B exchanges historicamente fracassaram quando a fricção era menor do que parecia: compradores e vendedores já conseguiam se encontrar, negociar e executar fora da plataforma com custo aceitável. Nesse caso, a plataforma adiciona overhead, não valor estrutural."
			meshManifestation: "Na construção civil brasileira, a hipótese da Mesh é que a fricção é material: qualificação manual cara, opacidade na cadeia, crédito caro ou indisponível para fornecedores menores, compliance fragmentado e dificuldade de encontrar fornecedores confiáveis fora de relações pessoais. Mas essa fricção pode ser alta para um lado e insuficiente para outro."
			meshImplication:   "Antes de resolver chicken-and-egg, validar fricção por lado. Se compradores resolvem qualificação de forma 'boa o suficiente', mas fornecedores têm dor extrema em crédito, o hook inicial precisa ser financeiro, não supply-chain. Se a fricção é baixa em todos os lados, a tese de plataforma é fraca e a Mesh deve ser tratada como serviço especializado, não como rede."
			rationale:         "Fricção insuficiente mata a plataforma antes mesmo de o efeito de rede ter chance de aparecer."
		},
		{
			id:                "pd-platform-lifecycle"
			name:              "Lifecycle da Plataforma e Priorização por Estágio"
			nature:            "theoretical"
			role:              "framework"
			definition:        "As dinâmicas relevantes mudam radicalmente por estágio: pré-launch, bootstrap, growth e maturity. Cada estágio tem perguntas dominantes. No início, o problema é viabilidade e cold start. Depois, passa a ser retenção, liquidez, multi-homing, defensibilidade e governança."
			meshManifestation: "A Mesh está em estágio de pré-launch/bootstrap. Portanto, as dinâmicas mais importantes agora são friction threshold, chicken-and-egg, single-player mode, anchor tenant, penguin problem, concentração do lado comprador e capacidade operacional do operador."
			meshImplication:   "Toda análise deve começar identificando estágio. Em bootstrap, priorizar 2-3 dinâmicas: fricção, sequenciamento de lados, onboarding e retenção inicial. Multi-homing, governance sofisticada e envelopment são secundários até que exista rede real para defender. Além disso, a capacidade real do operador — IA + humano no loop — é constraint de crescimento, não detalhe operacional."
			dependsOn:         ["pd-friction-threshold"]
			rationale:         "Sem lifecycle, a lente vira checklist enciclopédico em vez de instrumento de decisão."
		},
		{
			id:                "pd-network-effects"
			name:              "Efeitos de Rede Cross-Side e Same-Side"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Efeitos de rede descrevem como o valor para um participante muda quando a base de participantes muda. Efeitos cross-side são positivos quando a entrada de um lado aumenta o valor do outro. Efeitos same-side podem ser positivos ou negativos; em supply chain B2B, eles são frequentemente negativos do lado dos fornecedores porque mais fornecedores do mesmo tipo implicam mais competição, congestion e pressão de margem."
			meshManifestation: "Mais compradores atraem fornecedores porque geram recebíveis, receita e visibilidade. Mais fornecedores atraem compradores porque aumentam a probabilidade de match. Mas mais fornecedores do mesmo segmento e da mesma região também podem reduzir o valor para os próprios fornecedores se o mercado não estiver expandindo do lado comprador na mesma velocidade."
			meshImplication:   "Medir efeito líquido por segmento e por região. Não assumir que 'mais fornecedores' sempre melhora a rede. Se o same-side negativo superar o cross-side positivo em certo segmento, a aquisição adicional nesse segmento destrói valor para parte relevante da rede."
			dependsOn:         ["pd-platform-lifecycle"]
			rationale:         "Confundir crescimento bruto com ganho líquido de valor é um erro clássico de plataformas."
		},
		{
			id:                "pd-local-network-effects"
			name:              "Efeitos de Rede Locais"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Os efeitos de rede da Mesh são localmente delimitados por geografia, setor, especialidade e densidade econômica. A plataforma não opera como rede única nacional homogênea. Cada região e cada submercado relevante precisa atingir sua própria massa crítica funcional."
			meshManifestation: "Fornecedor de concreto em São Paulo não melhora diretamente o matching de um comprador no Recife. Um fornecedor de instalações industriais não melhora a liquidez do cluster de acabamento residencial. O scoring pode aproveitar informação nacional, mas o matching é local e setorial."
			meshImplication:   "Tratar cada região/vertical como mercado local. Não expandir para nova praça antes de atingir massa crítica suficiente na atual. Métrica central: fornecedores relevantes por segmento por região, não total de fornecedores cadastrados no país."
			dependsOn:         ["pd-network-effects"]
			rationale:         "Agregação nacional mascara ausência de liquidez local."
		},
		{
			id:                "pd-multi-sided-structure"
			name:              "Estrutura Multi-Sided e Interdependência entre Lados"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A Mesh conecta lados economicamente interdependentes: compradores, fornecedores e investidores. A plataforma cria valor ao coordenar interações entre esses lados e internalizar externalidades cruzadas entre eles."
			meshManifestation: "Compradores geram demanda e recebíveis. Fornecedores geram oferta, histórico operacional e necessidade de crédito. Investidores financiam a antecipação. O produto de um lado muda o valor do outro: crédito depende de dados operacionais; supply chain depende de liquidez; funding depende de qualidade e volume de originação."
			meshImplication:   "Toda decisão deve mapear efeitos de segunda ordem entre lados. Não basta dizer que uma mudança afeta 'a plataforma' — é preciso estimar como afeta compradores, fornecedores e investidores separadamente, com magnitude suficiente para alterar a decisão."
			dependsOn:         ["pd-network-effects"]
			rationale:         "Sem decompor por lado, a análise multi-sided fica vaga."
		},
	]
}
