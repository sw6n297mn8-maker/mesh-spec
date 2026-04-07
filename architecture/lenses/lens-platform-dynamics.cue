package lenses

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

platformDynamics: artifact_schemas.#AnalyticalLens & {
	id:      "lens-platform-dynamics"
	name:    "Dinâmicas de Plataforma"
	purpose: "Analisar como a Mesh cria, acelera, sustenta e defende efeitos de plataforma entre compradores, fornecedores e investidores, identificando condições de bootstrap, massa crítica, retenção, desintermediação, concentração e defensibilidade."
	status:  "draft"

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode:            "vertical-specific"
		primaryVertical: "construction"
		rationale: """
			Núcleo teórico de platform dynamics (Rochet-Tirole,
			network effects, multi-sided markets, chicken-and-egg,
			anchor tenants, envelopment, switching costs) é
			universal e aplicável a qualquer plataforma multi-sided.
			O artefato atual desta lens, no entanto, não opera
			nesse nível de abstração: está instanciado de forma
			substantiva na Mesh como plataforma bootstrapada em
			construção civil brasileira, sem pontos de variação
			explicitados.

			O purpose declara explicitamente analisar "como a
			Mesh cria, acelera, sustenta e defende efeitos de
			plataforma"; conceitos centrais como pd-friction-threshold,
			pd-multi-sided-structure, pd-platform-lifecycle e
			pd-single-player-mode embutem premissas
			construção-específicas (concentração de compradores,
			fornecedores como geradores de necessidade de crédito,
			qualificação manual cara, fricção setorial)
			diretamente em suas meshManifestation; o reasoning
			protocol pergunta sobre "a Mesh", não sobre
			plataformas em geral; e a própria seção de limitations
			declara que "construção civil não generaliza
			automaticamente para outras cadeias".

			Portanto, a classificação correta do artefato atual é
			vertical-specific, ainda que uma re-autoria futura
			possa produzir uma versão vertical-agnostic ou
			vertical-adaptable da mesma lens — re-autoria
			registrada como observação separada, fora do escopo
			deste backfill.
			"""
	}

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

	reasoningProtocol: [
		{
			question:  "A fricção que a Mesh resolve é realmente alta o suficiente para sustentar uma plataforma, ou estamos chamando de plataforma algo que é apenas serviço melhor embalado?"
			reveals:   "Se a fricção for baixa em todos os lados, não há base para estratégia de plataforma."
			rationale: "Este é o gate zero da lente."
		},
		{
			question:  "Em que estágio a Mesh está: pré-launch, bootstrap, growth ou maturity? Quais 2-3 dinâmicas são prioritárias neste estágio?"
			reveals:   "Reduz escopo analítico ao que realmente importa agora."
			rationale: "Sem estágio, a análise perde foco."
		},
		{
			question:  "Qual lado tem a dor mais intensa e a fricção mais insuportável hoje? Esse lado deve ser o hook inicial?"
			reveals:   "Define entry point real em vez de entry point ideológico."
			rationale: "A dor mais aguda costuma quebrar cold start."
		},
		{
			question:  "Existe single-player mode real? O participante continua usando mesmo sem a rede plenamente formada?"
			reveals:   "Distingue valor pré-rede de curiosidade passageira."
			rationale: "Single-player mode falso gera falsa confiança no go-to-market."
		},
		{
			question:  "O problema principal é chicken-and-egg estratégico ou penguin problem operacional? Quem precisa se mover primeiro e quem resiste mesmo depois disso?"
			reveals:   "Separa direção estratégica de mobilização prática."
			rationale: "Resolver um não resolve automaticamente o outro."
		},
		{
			question:  "Os efeitos de rede relevantes são locais ou amplos? A massa crítica foi atingida na região e no segmento corretos?"
			reveals:   "Evita confundir escala agregada com liquidez local real."
			rationale: "Na Mesh, quase tudo relevante é local antes de ser nacional."
		},
		{
			question:  "O crescimento do lado fornecedor está aumentando valor líquido ou apenas congestionando o mesmo-side effect?"
			reveals:   "Distingue expansão de valor de expansão destrutiva."
			rationale: "Mais oferta nem sempre ajuda."
		},
		{
			question:  "O data network effect é real e mensurável? Separadamente: DNE de scoring e DNE de matching."
			reveals:   "Mostra se há flywheel real ou narrativa de flywheel."
			rationale: "Toda tese de moat depende disso."
		},
		{
			question:  "A concentração do lado comprador é tolerável? O que acontece se o maior comprador sair ou negociar termos agressivos?"
			reveals:   "Mapeia fragilidade estrutural e assimetria de poder."
			rationale: "Concentração de buyer side pode matar a rede inteira."
		},
		{
			question:  "Quem deve ser subsidiado e por quê? A externalidade cruzada justifica esse subsídio?"
			reveals:   "Força lógica econômica do pricing multi-sided."
			rationale: "Subsídio sem externalidade é apenas queima de caixa."
		},
		{
			question:  "Há multi-homing relevante? Em quais lados ele é ameaça e em quais é oportunidade?"
			reveals:   "Evita estratégia uniforme para comportamentos distintos."
			rationale: "Fornecedor e investidor não multi-home da mesma forma."
		},
		{
			question:  "Existe bypass? Ele é temporário ou estrutural? O que a Mesh perde em cada caso: dados, receita, retenção, ou posição no workflow?"
			reveals:   "Diagnostica leakage com precisão útil."
			rationale: "Bypass estrutural exige resposta mais profunda."
		},
		{
			question:  "A governança e a curation estão preservando a qualidade da rede ou apenas maximizando quantidade de participantes?"
			reveals:   "Identifica se a plataforma está crescendo degradando a si mesma."
			rationale: "Match ruim destrói confiança de todos os lados."
		},
		{
			question:  "O moat principal é real ou assumido? Se um banco, ERP ou marketplace adjacente entrar, o que exatamente eles não conseguem replicar rápido?"
			reveals:   "Expõe se a defensibilidade é concreta ou narrativa."
			rationale: "Moat assumido é uma das crenças mais caras em plataformas."
		},
		{
			question:  "Qual elo mais fraco pode causar unraveling da rede: funding, retenção, bypass, baixa liquidez local, concentração de buyer, ou falha de curation?"
			reveals:   "Aponta o ponto de quebra mais provável e o mecanismo de mitigação prioritário."
			rationale: "A rede não quebra por média; quebra pelo elo mais fraco."
		},
	]

	meshExamples: [
		{
			id:       "ex-construction-bootstrap"
			scenario: "Lançar a Mesh na construção civil em São Paulo sem participantes iniciais."
			analysis: "A primeira pergunta não é chicken-and-egg, mas friction threshold. Se a dor mais intensa estiver no crédito do fornecedor e não na qualificação do comprador, o hook inicial deve ser financeiro. Depois, vem a distinção entre direção e mobilização: um anchor buyer pode resolver direção, mas não o penguin problem dos fornecedores. Além disso, o single-player mode do comprador precisa ser testado, não assumido."
			recommendation: "Validar fricção em ambos os lados antes de escolher a sequência. Se o single-player mode do comprador não retiver, pivotar para hook financeiro do fornecedor. Escolher anchor buyer que tenha autoridade sobre fornecedores substituíveis e usar incentivos financeiros para os fornecedores críticos. Planejar o onboarding como processo de meses, não semanas."
			assumptions: [
				"fricção financeira do fornecedor é maior que a de qualificação do comprador",
				"há anchor buyer disposto a forçar ou incentivar adoção",
				"São Paulo oferece densidade local suficiente para atingir massa crítica primeiro",
			]
			principlesApplied: ["ax-05", "ax-06", "ax-07"]
			rationale: "Bootstrap correto depende mais de ordem e foco do que de intensidade comercial bruta."
		},
		{
			id:       "ex-dne-validation"
			scenario: "Após 8 meses, a Mesh tem 150 fornecedores e 5 compradores. Precisar decidir se está construindo moat real ou apenas crescendo cadastro."
			analysis: "A pergunta central é separar DNE de scoring e DNE de matching. Se AUROC melhora com o volume e supera bureau de forma material, há valor proprietário real. Se taxa de match melhora apenas marginalmente apesar do crescimento da base, o matching ainda não virou flywheel robusto. Se receita por par ativo cai, pode haver bypass, o que enfraquece o DNE por reduzir fluxo recente."
			recommendation: "Comparar explicitamente scoring Mesh vs baseline externo. Medir taxa de match por segmento e região. Priorizar retenção de volume ativo sobre novos cadastros. Se o cruzamento proprietário não agregar o suficiente, deslocar o investimento de moat para workflow, compliance e embed operacional."
			assumptions: [
				"há dados suficientes para medir AUROC com confiança mínima",
				"matching pode ser medido por taxa de match real e não apenas busca ou cadastro",
			]
			principlesApplied: ["ax-05", "dp-09"]
			rationale: "Plataforma saudável acumula uso valioso, não apenas superfície."
		},
		{
			id:       "ex-expansion-vs-deepening"
			scenario: "A Mesh já tem presença em São Paulo e precisa decidir entre expandir para Rio de Janeiro ou aprofundar São Paulo."
			analysis: "A decisão correta depende de local network effects e massa crítica segmentada. Se São Paulo ainda não tem densidade suficiente em segmentos centrais, expandir para RJ significa abrir novo bootstrap antes de consolidar o primeiro. A expansão geográfica só faz sentido quando a praça atual já gera flywheel relativamente autossustentado."
			recommendation: "Aprofundar São Paulo primeiro até que os segmentos críticos tenham liquidez real e retenção estável. Só abrir RJ se houver bridge concreta — por exemplo, anchor buyer com atuação nas duas regiões — e se a operação atual já suportar dois bootstraps simultâneos sem degradação de qualidade."
			assumptions: [
				"São Paulo ainda não atingiu massa crítica uniforme em segmentos importantes",
				"RJ exigiria bootstrap quase do zero na maior parte das relações",
			]
			principlesApplied: ["ax-05", "ax-06", "dp-02"]
			rationale: "Expandir cedo demais transforma uma rede promissora em duas redes frágeis."
		},
	]

	principleIds: ["ax-05", "ax-06", "ax-07", "dp-02", "dp-09"]

	relatedLenses: [
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Platform-dynamics identifica onde estão as dinâmicas e os gargalos da plataforma. Mechanism-design desenha os mecanismos específicos para pricing, retenção, anti-bypass, onboarding e governance."
		},
		{
			lensId:   "lens-information-economics"
			relation: "complementsWith"
			context:  "Information-economics ajuda a avaliar se os dados realmente criam DNE proprietário, qual o valor marginal desse dado e onde ele decai mais rápido."
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "complementsWith"
			context:  "Sem liquidez financeira, a liquidez da plataforma quebra. Funding e plataforma são interdependentes na Mesh."
		},
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "Buyer concentration em platform-dynamics e concentração de EAD em credit-risk são dimensões complementares do mesmo risco estrutural."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "Penguin problem, onboarding, switching cost percebido e adoção inicial são parcialmente comportamentais."
		},
		{
			lensId:   "lens-network-theory"
			relation: "feedsInto"
			context:  "Platform-dynamics formula as perguntas de crescimento, massa crítica, concentração e liquidez; network-theory fornece parte das ferramentas topológicas para respondê-las quantitativamente."
		},
		{
			lensId:   "lens-market-design"
			relation: "complementsWith"
			context:  "Platform-dynamics trata crescimento, composição e posição competitiva da plataforma. Market-design trata como o mercado dentro da plataforma é estruturado, limpa oferta e demanda e aloca recursos escassos."
		},
	]

	limitations: [
		{
			description: "A lens assume que a Mesh é ou pode virar plataforma de verdade. Se os efeitos de rede forem fracos, a análise superestima dinâmicas de plataforma."
			alternative: "Validar empiricamente DNE, massa crítica, retenção e bypass antes de investir pesado em moat de plataforma."
			rationale:   "Nem todo negócio com múltiplos lados é plataforma defensável."
		},
		{
			description: "Calibração depende fortemente da vertical. Construção civil não generaliza automaticamente para outras cadeias."
			alternative: "Recalibrar friction threshold, local network effects, buyer concentration e chicken-and-egg em cada vertical nova."
			rationale:   "O padrão de concentração e coordenação muda por setor."
		},
		{
			description: "A lens não modela regulação como constraint direta."
			alternative: "Complementar com regulatory-strategy quando LGPD, Bacen, portabilidade ou estrutura regulatória mudarem switching costs e DNE."
			rationale:   "Regulação pode limitar efeitos de plataforma."
		},
		{
			description: "A capacidade operacional do operador pode ser o gargalo real, independentemente de a dinâmica teórica de plataforma parecer favorável."
			alternative: "Tratar capacidade como constraint explícita em bootstrap e expansão."
			rationale:   "Rede cresce na velocidade que pode ser operada sem degradar qualidade."
		},
	]

	rationale: "A Mesh não é apenas produto; é potencialmente uma plataforma multi-sided. Esta lente existe para distinguir plataforma real de narrativa de plataforma. Ela começa onde deveria começar: validar se a fricção é suficiente para sustentar coordenação multi-sided. Depois disso, organiza o problema por estágio, separa chicken-and-egg de penguin problem, trata efeitos de rede locais, distingue DNE de scoring e de matching, separa bypass temporário de estrutural, mede concentração do lado comprador, define lógica de subsídio cruzado, interpreta multi-homing por lado, trata curation como parte central da governança e testa se o moat é real ou assumido. O objetivo não é explicar genericamente como plataformas crescem, mas dar à Mesh uma lente operacional para decidir como iniciar, aprofundar, defender e expandir sua rede sem confundir crescimento aparente com plataforma saudável."
}
