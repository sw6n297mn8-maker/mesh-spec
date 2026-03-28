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
		{
			id:                "pd-buyer-concentration-risk"
			name:              "Concentração do Lado Comprador e Assimetria de Poder"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quando um lado é muito concentrado e o outro muito fragmentado, a plataforma fica estruturalmente dependente dos poucos participantes grandes do lado concentrado. Isso cria fragilidade de rede e assimetria de barganha."
			meshManifestation: "Na construção civil, poucos compradores relevantes podem concentrar a maior parte do volume, enquanto centenas de fornecedores dependem deles. Perder um anchor buyer pode significar perder dezenas de fornecedores ativos e degradar simultaneamente dados, matching, funding e retenção."
			meshImplication:   "Medir HHI do lado comprador, top-3 share e dependência indireta via fornecedores trazidos por cada buyer. Tratar aquisição do segundo e terceiro anchor como prioridade estrutural, não apenas comercial. Não conceder termos que tornem a plataforma refém do comprador dominante."
			dependsOn:         ["pd-multi-sided-structure", "pd-local-network-effects"]
			rationale:         "Na Mesh, concentração do lado comprador não é apenas risco comercial; é risco existencial de plataforma."
		},
		{
			id:                "pd-chicken-and-egg"
			name:              "Chicken-and-Egg, Cold Start e Penguin Problem"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Chicken-and-egg é a interdependência circular entre lados: um não entra sem o outro. Cold start é o problema de lançar com liquidez zero. Penguin problem é a resistência sequencial mesmo depois que a direção estratégica já foi resolvida: todos reconhecem o caminho, mas cada participante espera o outro se mover primeiro."
			meshManifestation: "A Mesh pode resolver chicken-and-egg com um anchor tenant, mas ainda enfrentar meses de resistência dos fornecedores desse anchor. Além disso, a autoridade do comprador sobre o fornecedor varia: pode ser alta para fornecedores substituíveis e baixa para fornecedores críticos."
			meshImplication:   "Separar os problemas. Primeiro resolver direção: qual lado entra primeiro? Depois resolver mobilização: como fazer os participantes realmente se moverem? Para fornecedores substituíveis, o buyer pode impor adoção. Para críticos, é preciso incentivo financeiro e onboarding high-touch. Single-player mode deve ser validado cedo; se falhar, pivotar o hook de entrada."
			dependsOn:         ["pd-friction-threshold", "pd-multi-sided-structure", "pd-local-network-effects"]
			rationale:         "Ter a sequência certa não basta; é preciso superar a hesitação real dos participantes."
		},
		{
			id:                "pd-single-player-mode"
			name:              "Single-Player Mode e Valor Pré-Rede"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Single-player mode é o valor que a plataforma entrega a um lado mesmo antes da rede estar completa. É a principal forma de quebrar cold start sem depender imediatamente de efeitos de rede plenos."
			meshManifestation: "Para compradores, pode ser qualificação, documentação e compliance. Para fornecedores, pode ser antecipação, cadastro único e visibilidade futura. Mas o single-player mode só conta se for realmente usado de forma recorrente sem o outro lado plenamente presente."
			meshImplication:   "Testar retenção do single-player mode de forma explícita. Se compradores usam por 2 semanas e abandonam, o single-player mode não é real. Se falhar, não insistir por apego conceitual: mudar o hook para o lado com dor mais aguda."
			dependsOn:         ["pd-chicken-and-egg", "pd-friction-threshold"]
			rationale:         "Muitas plataformas se iludem achando que têm single-player mode quando têm apenas curiosidade inicial."
		},
		{
			id:                "pd-data-network-effects"
			name:              "Data Network Effects: Scoring e Matching"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Dados gerados pela rede só constituem DNE real quando melhoram o produto de forma proprietária, perceptível e cumulativa. Na Mesh, há duas curvas distintas: DNE de scoring e DNE de matching. Elas não devem ser tratadas como uma só."
			meshManifestation: "Mais transações podem melhorar accuracy de risco sem necessariamente melhorar match. Mais diversidade de fornecedores pode melhorar matching sem necessariamente melhorar PD. Além disso, o valor dos dados decai no tempo: dados antigos não substituem fluxo recente."
			meshImplication:   "Validar separadamente: AUROC vs volume para scoring; taxa de match vs diversidade para matching. Comparar scoring Mesh com baseline de bureau. Se o ganho do cruzamento financeiro-operacional for pequeno, o moat precisa vir de outro lugar. Priorizar retenção de volume ativo, não apenas crescimento de cadastro."
			dependsOn:         ["pd-network-effects"]
			rationale:         "Sem separar scoring e matching, a tese de flywheel fica inflada e pouco falsificável."
		},
		{
			id:                "pd-disintermediation-risk"
			name:              "Desintermediação: Bypass Temporário e Estrutural"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Desintermediação é quando os participantes usam a plataforma para se encontrar ou iniciar a relação e depois transacionam fora dela. Há duas formas: bypass temporário e bypass estrutural."
			meshManifestation: "Fornecedor que não usa a Mesh neste mês porque não precisa antecipar, mas volta depois, é bypass temporário. Comprador e fornecedor que internalizam a relação permanentemente fora da plataforma após o primeiro match são bypass estrutural."
			meshImplication:   "Desenhar mecanismos diferentes. Contra bypass temporário: valor contínuo, analytics, compliance e elegibilidade vinculada ao uso recorrente. Contra bypass estrutural: embedar a Mesh no workflow do comprador e no ciclo econômico do fornecedor. Monitorar receita por par ativo, não apenas cadastros totais."
			dependsOn:         ["pd-single-player-mode", "pd-data-network-effects"]
			rationale:         "Sem distinguir temporal de estrutural, a plataforma reage errado ao leakage."
		},
		{
			id:                "pd-subsidization-pricing"
			name:              "Subsídio Cruzado e Estrutura de Monetização"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Em plataformas multi-sided, o lado que gera maior externalidade cruzada deve ser mais subsidiado. A lógica correta é externalidade marginal, não simples elasticidade-preço."
			meshManifestation: "Um comprador relevante pode trazer dezenas de fornecedores. Um investidor adicional pode reduzir custo de funding sem mudar matching. Um fornecedor adicional pode melhorar densidade de um nicho específico, mas também aumentar congestion."
			meshImplication:   "Subsidiar o lado cuja entrada mais altera a rede. Em bootstrap, isso tende a ser o comprador anchor. Em crescimento, a lógica pode mudar conforme a externalidade marginal se reduz. A monetização deve acompanhar a mudança de estágio."
			dependsOn:         ["pd-multi-sided-structure", "pd-chicken-and-egg"]
			rationale:         "Subsídio sem lógica de externalidade vira CAC mal disfarçado."
		},
		{
			id:                "pd-multi-homing-switching"
			name:              "Multi-Homing, Single-Homing e Switching Costs"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Multi-homing é o uso simultâneo de múltiplas plataformas. Seu significado varia por lado: pode ser ameaça ou oportunidade. Switching costs são defensáveis quando baseados em valor acumulado real, não em aprisionamento artificial."
			meshManifestation: "Fornecedores podem antecipar com múltiplos canais. Compradores tendem a single-home mais cedo se integrarem workflow. Investidores provavelmente multi-home por natureza, e isso pode ser benéfico para reduzir custo de capital."
			meshImplication:   "Analisar multi-homing por lado. Multi-homing alto em fornecedores indica switching cost insuficiente ou valor contínuo fraco. Multi-homing alto em investidores pode ser saudável. A Mesh deve construir switching cost legítimo via score acumulado, integração operacional e workflow dependence."
			dependsOn:         ["pd-data-network-effects", "pd-network-effects"]
			rationale:         "Tratar multi-homing como problema uniforme gera estratégia errada."
		},
		{
			id:                "pd-liquidity"
			name:              "Liquidez de Plataforma"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Liquidez é a probabilidade de um participante encontrar contraparte adequada em tempo aceitável. É função de composição, timing e densidade local, não apenas de volume agregado."
			meshManifestation: "Ter muitos fornecedores não resolve se não houver os fornecedores certos por segmento, região e timing. O mesmo vale para antecipação: não basta haver funding total, é preciso funding acessível no momento e no tipo de operação que importa."
			meshImplication:   "Medir taxa de match e tempo até match por cluster local. Diagnosticar falha de liquidez como problema de volume ou de composição. Corrigir composição antes de perseguir volume bruto."
			dependsOn:         ["pd-local-network-effects", "pd-network-effects"]
			rationale:         "Volume sem liquidez é rede de vaidade."
		},
		{
			id:                "pd-critical-mass"
			name:              "Massa Crítica e Tipping Point"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Cada mercado local tem um threshold abaixo do qual a plataforma degrada e acima do qual passa a auto-reforçar crescimento, retenção e dados. O tipping point raramente é global; ele é local e segmentado."
			meshManifestation: "Uma região pode ter massa crítica em concreto e aço, mas não em hidráulica. A rede pode parecer grande, mas continuar sem tipping point real em segmentos decisivos para o comprador."
			meshImplication:   "Definir massa crítica por segmento e região. Não expandir geograficamente antes de resolver segmentos centrais na praça atual. Triggers de expansão devem combinar retenção, match e DNE real."
			dependsOn:         ["pd-liquidity", "pd-local-network-effects"]
			rationale:         "Sem granularidade local, massa crítica vira slogan."
		},
		{
			id:                "pd-platform-governance"
			name:              "Governança da Plataforma e Curation"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Governança de plataforma tem duas direções: a plataforma pode agir oportunisticamente contra participantes, e participantes podem degradar a qualidade da plataforma e uns dos outros. Curation é a função que separa signal de noise e protege a qualidade da rede."
			meshManifestation: "Fornecedores podem fraudar documentação, compradores podem atrasar estrategicamente, investidores podem pressionar por estrutura que degrada qualidade, e a própria Mesh pode favorecer participantes mais lucrativos em detrimento da justiça percebida da rede."
			meshImplication:   "Governança deve tratar oportunismo da plataforma e dos participantes. No bootstrap, a prioridade costuma ser curation e controle de qualidade do lado dos participantes, porque um match ruim destrói mais valor do que um usuário a menos. Em growth, fairness e transparência passam a ser mais relevantes."
			dependsOn:         ["pd-multi-sided-structure"]
			rationale:         "Plataforma sem curation vira canal de tráfego, não infraestrutura confiável."
		},
		{
			id:                "pd-platform-defensibility"
			name:              "Defensibilidade, Moat e Envelopment"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A plataforma é defensável quando concorrentes não conseguem replicar facilmente o conjunto de dados, workflows, integração e confiança acumulada. Envelopment ocorre quando uma plataforma adjacente usa sua base para entrar no mesmo espaço."
			meshManifestation: "Banco pode tentar adicionar supply-chain. ERP pode tentar adicionar crédito. Marketplace pode tentar adicionar antecipação. A defensibilidade da Mesh depende de quão difícil é replicar o cruzamento financeiro-operacional, o workflow do comprador e o histórico acumulado de performance."
			meshImplication:   "Testar moat empiricamente. Se scoring proprietário não melhora materialmente sobre bureau, não contar com ele como moat principal. Priorizar defensibilidade onde a replicação é mais difícil: cruzamento de camadas, workflow, integração transacional recorrente e reputação validada pela rede. Projetar para winner-takes-most por nicho, não para winner-takes-all genérico."
			dependsOn:         ["pd-data-network-effects", "pd-multi-homing-switching", "pd-platform-governance"]
			rationale:         "Sem moat real, a Mesh vira um estágio transitório na cadeia de valor de outro player."
		},
		{
			id:                "pd-mesh-platform-metrics"
			name:              "Métricas de Saúde da Plataforma por Estágio"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "Métricas diagnósticas mudam por estágio. Bootstrap: onboarding rate do anchor, retenção do single-player mode, tempo até primeira transação de valor, cobertura regional mínima por segmento crítico. Growth: taxa de match, cohort retention por lado, AUROC vs volume, taxa de match vs diversidade, receita por par ativo, bypass rate, HHI de compradores. Maturity: multi-homing por lado, switching cost realizado, sinais de envelopment, share of workflow do comprador."
			meshManifestation: "Cadastros totais e GMV bruto podem crescer enquanto bypass aumenta, retenção cai e a plataforma se fragiliza. Sem métricas por estágio, crescimento aparente mascara degradação estrutural."
			meshImplication:   "No bootstrap, monitorar semanalmente onboarding, retenção inicial e time to first value. Em growth, monitorar mensalmente taxa de match, retention, DNE e leakage. Alertas: buyer concentration acelerando, bypass estrutural, AUROC estagnando apesar de mais volume, segmentos com massa crítica falsa."
			rationale:         "Métrica errada faz a plataforma parecer saudável quando está apenas inflando superfície."
		},
	]
}
