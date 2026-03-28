package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

complexAdaptiveSystems: artifact_schemas.#AnalyticalLens & {
	id:      "lens-complex-adaptive-systems"
	name:    "Sistemas Adaptativos Complexos"
	purpose: "Modelar a Mesh como sistema adaptativo complexo quando o comportamento observado não pode ser explicado adequadamente por lenses componentes isoladas. A lente trata emergência, feedback loops, delays, adaptação, tipping points, heterogeneidade, path dependence e coevolução como propriedades sistêmicas centrais."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve efeitos de segunda ou terceira ordem que podem surpreender, em que a intervenção gera reação não prevista",
			"a decisão envolve entender por que o sistema se comporta de forma diferente do que modelos lineares ou análises por componente preveem",
			"a decisão envolve feedback loops que amplificam ou atenuam efeitos de intervenção",
			"a decisão envolve tipping points ou transições abruptas de regime no comportamento da rede ou do mercado",
			"a decisão envolve como participantes adaptam comportamento em resposta a regras da plataforma, incluindo Goodhart's Law e gaming",
			"a decisão envolve padrões emergentes que nenhum participante individual planejou",
			"a decisão envolve stress testing que precisa capturar cenários não-lineares",
			"a decisão envolve path dependence, em que decisões iniciais constrangem opções futuras de forma desproporcional",
			"a decisão envolve resiliência do sistema como um todo, não apenas de participantes individuais",
			"a decisão envolve por que intervenções bem intencionadas produzem efeitos opostos ao desejado",
			"a decisão envolve delays entre causa e efeito que obscurecem atribuição de causalidade",
			"a decisão envolve calibrar rigidez de governança, em que regras demais ossificam e regras de menos geram caos",
		]
		keywords: [
			"emergência", "emergente", "complexidade",
			"feedback loop", "retroalimentação", "amplificação",
			"não-linear", "não-linearidade", "desproporcional",
			"tipping point", "transição", "regime", "fase",
			"adaptação", "Goodhart", "gaming", "reação",
			"path dependence", "lock-in", "irreversibilidade",
			"resiliência", "fragilidade", "antifragilidade",
			"efeito colateral", "segunda ordem", "terceira ordem",
			"sistêmico", "sistema", "holístico",
			"imprevisível", "surpresa", "cisne negro",
			"delay", "defasagem", "oscilação", "overshoot",
			"edge of chaos", "rigidez", "flexibilidade",
			"heterogeneidade", "velocidade de adaptação",
		]
		excludeWhen: [
			"a decisão é sobre efeitos de rede como dinâmica de plataforma sem componente de emergência ou não-linearidade; usar lens-platform-dynamics",
			"a decisão é sobre topologia de rede sem componente de dinâmica adaptativa; usar lens-network-theory",
			"a decisão é sobre risco de crédito modelável com ferramentas estatísticas convencionais; usar lens-credit-risk",
			"a decisão é sobre design de incentivos assumindo comportamento estável; usar lens-mechanism-design",
			"a decisão é sobre vieses comportamentais individuais; usar lens-behavioral-economics",
		]
		rationale: "As outras lenses modelam partes do sistema assumindo relativa estabilidade local. CAS modela o sistema como um todo quando essa estabilidade quebra: participantes adaptam, efeitos cascateiam não-linearmente, padrões emergem, delays obscurecem causalidade, e intervenções produzem consequências não previstas. Na Mesh, plataforma multi-sided com participantes heterogêneos, funding, scoring, supply chain e governança acoplados, CAS é invocada quando lenses componentes divergem, explicações locais entram em conflito, ou o comportamento agregado passa a ter propriedades próprias."
	}

	concepts: [
		{
			id:                "cas-emergence"
			name:              "Emergência: Padrões Macro de Interações Micro"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Emergência é a propriedade pela qual o sistema exibe padrões que não estão presentes em nenhum componente isolado e não são previsíveis por simples agregação dos componentes. Em sistemas adaptativos complexos, padrões macro surgem da interação local entre agentes, regras, informação e restrições. Esses padrões depois retroagem sobre os próprios componentes que os geraram, fenômeno frequentemente descrito como downward causation."
			meshManifestation: "Na Mesh, preço efetivo de antecipação, qualidade percebida do score, cultura da rede, velocidade de churn, confiança de investidores e disciplina de pagamento de compradores não são determinados por uma única lense. Eles emergem da interação entre credit-risk, platform-dynamics, financial-intermediation, behavioral-economics, contract-theory, commons e governance. Por exemplo, uma cultura emergente de oportunismo pode surgir se os primeiros participantes que prosperam forem os que exploram brechas, e essa norma emergente passa a influenciar novos participantes."
			meshImplication:   "A Mesh não deve tentar prever resultados sistêmicos apenas pela soma de análises locais. Deve projetar condições de interação que favoreçam emergência benéfica, monitorar padrões que divergem das predições locais, e intervir nas regras de interação quando padrões emergentes adversos aparecem. A pergunta central deixa de ser 'qual componente causou isso?' e passa a ser 'que padrão de interação tornou isso provável?'"
			rationale:         "Emergência é o núcleo do que CAS adiciona. Sem emergência, a lente seria apenas agregação de componentes."
		},
		{
			id:                "cas-feedback-loops"
			name:              "Feedback Loops: Amplificação, Atenuação e Dominância"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Feedback loops podem ser reforçadores, quando amplificam a trajetória em curso, ou balanceadores, quando a corrigem. Em sistemas reais, múltiplos loops coexistem, competem e mudam de dominância ao longo do tempo. O comportamento observado do sistema depende menos da existência de um loop isolado e mais de qual loop domina no regime atual."
			meshManifestation: "Na Mesh, coexistem loops como: mais fornecedores → mais dados → scoring melhor → taxas melhores → mais fornecedores; mais fornecedores → mais demanda por funding → congestion → frustração → churn; dados ruins → scoring pior → bons saem → dados piores; incidente de confiança → churn → menor visibilidade → mais incidentes. Cada lense componente enxerga um ou poucos loops. CAS enxerga a interação entre eles."
			meshImplication:   "Toda análise sistêmica deve identificar os stocks canônicos afetados, os fluxos que os movem, os loops associados e qual deles parece dominante no momento. Antes de intervir, a Mesh deve perguntar se a intervenção altera dominância de loop ou apenas o sintoma. Intervenções que parecem corretas sob um loop podem se inverter quando outro loop passa a dominar."
			rationale:         "O insight exclusivo não é a existência de loops, mas a competição entre loops e a troca de dominância."
			dependsOn:         ["cas-emergence"]
		},
		{
			id:                "cas-delays"
			name:              "Delays e Estrutura Temporal de Causalidade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Delays entre causa e efeito tornam sistemas complexos contraintuitivos. Eles geram oscilação, overshoot, falsa atribuição de causalidade, empilhamento prematuro de intervenções e leituras enganosas de sucesso ou fracasso. Muitas vezes o problema não é a existência de feedback, mas o fato de o sistema responder tarde demais para a percepção humana e gerencial."
			meshManifestation: "Na Mesh, onboarding leva meses até gerar scoring útil. Mudança de regra leva semanas ou meses até produzir adaptação comportamental observável. Deterioração operacional de comprador pode demorar 60 a 90 dias para aparecer financeiramente. Mudanças de composição de carteira podem levar semanas ou meses para impactar yield do funding. Um score hoje pode refletir comportamento de meses atrás."
			meshImplication:   "Toda intervenção deve ser avaliada contra um delay map explícito. Se o delay esperado é maior do que a janela de avaliação, a Mesh não deve empilhar novas intervenções nem declarar fracasso cedo demais. Também deve considerar cenários 'better before worse' e 'worse before better', em que o sinal inicial da intervenção não revela seu efeito estrutural."
			rationale:         "Sem modelar delays, causalidade sistêmica vira ilusão retrospectiva."
			dependsOn:         ["cas-feedback-loops"]
		},
		{
			id:                "cas-agent-heterogeneity"
			name:              "Heterogeneidade de Agentes e Velocidade Diferencial de Adaptação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Agentes diferem em sofisticação, velocidade de aprendizagem, incentivos, recursos e acesso à informação. Em sistemas adaptativos complexos, não é a média dos agentes que define a dinâmica, mas a distribuição dos tipos e a velocidade dos mais adaptativos ou mais influentes. A mudança na composição dos tipos pode alterar qualitativamente a dinâmica do sistema."
			meshManifestation: "Na Mesh, fornecedores pequenos podem adaptar lentamente, enquanto construtoras grandes e investidores profissionais adaptam rapidamente. Poucos agentes sofisticados podem descobrir exploits e mudar o comportamento do sistema inteiro. Se perfis Q1 churnam, o sistema pode ficar mais lento em adaptação, mas também menos disciplinado e menos informativo. A reação de um tipo gera cascata sobre os outros tipos."
			meshImplication:   "A Mesh deve modelar não apenas segmentos, mas cascatas inter-tipos. Para cada regra relevante, deve perguntar como o agente mais sofisticado reage primeiro, como essa adaptação se difunde, e como isso altera o comportamento de grupos menos sofisticados. A cadência de recalibração deve seguir o participante mais rápido, não o médio."
			rationale:         "A distribuição de tipos determina a dinâmica emergente; a média oculta isso."
			dependsOn:         ["cas-emergence", "cas-feedback-loops"]
		},
		{
			id:                "cas-adaptation-goodhart"
			name:              "Adaptação, Goodhart e Prazo de Validade de Regras"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Mesmo regras que parecem boas estaticamente degradam quando participantes aprendem a otimizá-las. Goodhart não é apenas um problema lógico de métrica-alvo; é uma dinâmica temporal em que participantes descobrem, difundem e exploram atalhos. Toda regra e toda métrica têm prazo de validade."
			meshManifestation: "Se a Mesh prioriza entregas no prazo, participantes podem sacrificar qualidade para preservar prazo. Se penaliza disputas, participantes podem deixar de registrar disputas. Se monitora concentração por comprador, podem criar estruturas formais para mascarar concentração. A difusão do exploit pode acontecer em semanas em grupos sofisticados e em meses no restante da rede."
			meshImplication:   "A Mesh deve tratar toda regra como temporária, com cadência de revisão proporcional à velocidade dos participantes mais sofisticados e à velocidade de difusão da informação. Métricas mais robustas são aquelas que usam múltiplas fontes, integridade cruzada e sinais independentes difíceis de otimizar simultaneamente."
			rationale:         "Mechanism-design pergunta se algo é gamável. CAS pergunta quando e como isso se degrada."
			dependsOn:         ["cas-emergence", "cas-agent-heterogeneity"]
		},
		{
			id:                "cas-nonlinearity-tipping"
			name:              "Não-Linearidade e Tipping Points"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Sistemas complexos podem parecer estáveis por longos períodos e depois mudar abruptamente de regime. Pequenas mudanças podem produzir efeitos desproporcionais quando thresholds ocultos são cruzados. A recuperação costuma ser muito mais cara do que a prevenção."
			meshManifestation: "Confiança de investidores pode parecer estável até um incidente adicional causar run. Churn pode acelerar abruptamente após perder um conjunto crítico de participantes Q1. Massa crítica pode parecer inalcançável até um threshold ser cruzado e o sistema passar a crescer quase sozinho. O funding pode parecer robusto até concentração excessiva produzir colapso em poucas semanas."
			meshImplication:   "A Mesh deve monitorar não apenas estado atual, mas indicadores de proximidade de tipping point: desaceleração de crescimento, convergência de indicadores negativos, aumento de variância, concentração excessiva, compressão de buffers. Intervenção preventiva é muito mais barata do que intervenção após transição de regime."
			rationale:         "Tipping points explicam por que sistemas parecem estáveis até não parecerem mais."
			dependsOn:         ["cas-feedback-loops", "cas-delays"]
		},
		{
			id:                "cas-path-dependence"
			name:              "Path Dependence e Lock-In"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Decisões iniciais moldam irreversivelmente, ou quase irreversivelmente, as opções futuras do sistema. Em sistemas novos, o paradoxo é forte: no bootstrap há menos informação e, ao mesmo tempo, maior dependência de trajetória."
			meshManifestation: "Primeiro anchor condiciona segmento, região, dados disponíveis e cultura da rede. Regras iniciais de scoring viram referência. Escolhas tecnológicas, de contrato, de mercado inicial e de governança tornam-se difíceis de reverter depois que o sistema cresce sobre elas."
			meshImplication:   "A Mesh deve classificar decisões de bootstrap em reversíveis e irreversíveis. As de alto lock-in exigem mais análise e mais cautela. Também deve documentar onde a expansão futura exigirá recalibração para não universalizar prematuramente aprendizados de um contexto local."
			rationale:         "Bootstrap combina máxima irreversibilidade com mínima informação."
			dependsOn:         ["cas-emergence"]
		},
		{
			id:                "cas-governance-calibration"
			name:              "Calibração de Governança: Edge of Chaos"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Sistemas adaptativos complexos performam melhor na fronteira entre ordem excessiva e caos excessivo. Governança rígida demais produz workarounds, conformidade superficial e exclusão de participantes válidos. Governança flexível demais produz incoerência, perda de confiança e incapacidade de aprender sistemicamente."
			meshManifestation: "Na Mesh, regras rígidas podem excluir fornecedores menores e informalmente organizados que operam bem no mundo real. Regras frouxas demais podem tornar o score pouco discriminante, a elegibilidade inconsistente e a plataforma incapaz de gerar confiança institucional."
			meshImplication:   "A Mesh deve calibrar rigidez por domínio, fase e distribuição de participantes. Compliance regulatório e integridade financeira pedem rigidez. Operação e onboarding pedem adaptabilidade. Essa calibração deve ser revisada sempre que a fase do sistema muda ou a composição dos participantes muda significativamente."
			rationale:         "O problema não é escolher ordem ou caos, mas operar na fronteira certa para o domínio certo."
			dependsOn:         ["cas-emergence", "cas-adaptation-goodhart", "cas-agent-heterogeneity"]
		},
		{
			id:                "cas-resilience-fragility"
			name:              "Resiliência, Fragilidade e Antifragilidade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Um sistema pode responder a stress de forma frágil, resiliente ou antifrágil. Fragilidade implica dano desproporcional. Resiliência implica absorção e recuperação. Antifragilidade implica aprendizado ou fortalecimento sob stress moderado."
			meshManifestation: "Funding concentrado e confiança dependente de zero incidentes são frágeis. Scoring que aprende com defaults e incidentes bem tratados que aumentam trust operacional podem ser antifrágeis. Muitos componentes críticos começam frágeis por padrão."
			meshImplication:   "A Mesh deve projetar cada componente crítico para pelo menos resiliência e, onde possível, criar mecanismos de aprendizado sob stress controlado, como fire drills, simulações e pós-mortems estruturados."
			rationale:         "Sistemas projetados apenas para cenário médio tendem a ser frágeis."
			dependsOn:         ["cas-nonlinearity-tipping", "cas-feedback-loops"]
		},
		{
			id:                "cas-coevolution"
			name:              "Coevolução"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Sistema, participantes, concorrentes e ambiente regulatório evoluem ao mesmo tempo. Não há equilíbrio permanente; há sucessivos equilíbrios temporários. Cada ajuste da Mesh muda o ambiente ao qual os participantes respondem, e essa resposta muda novamente a Mesh."
			meshManifestation: "Scoring funciona em uma fase, é explorado na seguinte, é recalibrado, gera novo equilíbrio, enquanto concorrentes, regulador e investidores também se ajustam. A vantagem competitiva passa a depender da velocidade de adaptação, não apenas da qualidade do estado atual."
			meshImplication:   "A Mesh deve otimizar capacidade de adaptação contínua: revisão periódica de regras, recalibração de scoring, atualização de pricing e arquitetura que suporte evolução rápida sem colapso de governança."
			rationale:         "Em sistema adaptativo, estabilidade permanente é ilusão."
			dependsOn:         ["cas-adaptation-goodhart", "cas-path-dependence"]
		},
		{
			id:                "cas-leverage-points"
			name:              "Leverage Points e Intervenção Sistêmica"
			nature:            "theoretical"
			role:              "method"
			definition:        "Nem toda intervenção vale o mesmo. Parâmetros têm impacto relativamente baixo; estrutura de fluxos, regras, estrutura de informação, objetivos e paradigma têm impacto crescente, mas também custo e dificuldade maiores. A maior parte das intervenções falha porque atua no nível errado."
			meshManifestation: "Ajustar spread pode não resolver churn se o problema estiver na estrutura de informação. Melhorar parâmetro do score pode não resolver gaming se o problema estiver nas regras ou no paradigma do que a plataforma recompensa."
			meshImplication:   "A Mesh deve começar pelo nível mais baixo que resolve e subir apenas quando necessário. Se ajustes paramétricos falham repetidamente, o diagnóstico deve migrar para estrutura de informação, regras ou paradigma."
			rationale:         "Problemas graves raramente são resolvidos só com tuning paramétrico."
			dependsOn:         ["cas-feedback-loops", "cas-emergence"]
		},
		{
			id:                "cas-regime-classification"
			name:              "Classificação de Regime do Sistema"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "O sistema deve ser classificado periodicamente em um de quatro regimes: crescimento, estável, degradação ou transição. Transição é o regime mais perigoso, porque agregados podem parecer saudáveis enquanto submétricas já mostram deterioração estrutural."
			meshManifestation: "Onboarding pode continuar alto enquanto churn Q1 dobra. AUROC agregado pode melhorar enquanto cohorts recentes pioram. NPS médio pode mascarar colapso em um lado específico do mercado."
			meshImplication:   "Toda revisão sistêmica deve começar classificando o regime com métricas desagregadas. Se sinais de transição aparecerem, a lente CAS passa de complementar a prioritária. Triggers relevantes devem antecipar reclassificação sem esperar a revisão trimestral."
			rationale:         "Operar com classificação de regime obsoleta produz decisões erradas mesmo com boas métricas locais."
		},
		{
			id:                "cas-mesh-system-health"
			name:              "Saúde Sistêmica, Stocks Canônicos e Delay Map"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "A análise CAS precisa de três artefatos vivos: lista de stocks canônicos do sistema, métricas de saúde sistêmica e mapa de delays relevantes. Esses artefatos formam a fonte única de verdade para loops, regime, dominância e avaliação temporal."
			meshManifestation: "Stocks canônicos incluem participantes ativos por lado, qualidade de dados, confiança por lado, composição e NAV do funding, distribuição de scores, capacidade operacional do founder e buffers institucionais. O delay map inclui onboarding até scoring, mudança de regra até adaptação, deterioração operacional até impacto financeiro, default até perda observável, difusão de informação e composição até yield."
			meshImplication:   "A Mesh deve manter dashboard sistêmico separado dos dashboards por componente. Toda análise de loop, tipping point, dominância e timing deve referenciar explicitamente esses artefatos. Delays devem ser estimados no bootstrap e recalibrados com dados observados."
			rationale:         "Sem fonte única de stocks e delays, CAS vira narrativa solta em vez de disciplina operacional."
		},
	]

	reasoningProtocol: [
		{
			question:  "O que motivou invocar CAS? Qual lense componente está produzindo resultado diferente do previsto, comparado a qual contrafactual, e essa divergência excede variância normal?"
			reveals:   "CAS é justificada quando há surpresa real, não qualquer flutuação."
			rationale: "Signal versus noise. CAS complementa, não substitui, as outras lenses."
		},
		{
			question:  "Em que timescale a dinâmica principal opera: dias, semanas, meses ou anos?"
			reveals:   "Timescale determina urgência, cadência de monitoramento e risco de empilhamento de intervenções."
			rationale: "Dinâmicas em escalas temporais diferentes exigem respostas diferentes."
		},
		{
			question:  "Quais feedback loops estão em jogo sobre os stocks canônicos e qual loop domina no regime atual?"
			reveals:   "O comportamento observado depende da dominância, não apenas da existência dos loops."
			rationale: "Intervenção sem diagnóstico de loop dominante tende a atacar sintoma."
		},
		{
			question:  "Participantes estão adaptando comportamento? Há Goodhart, gaming ou prazo de validade expirando nas regras? Existe cascata inter-tipos?"
			reveals:   "Mostra se a divergência é de adaptação comportamental e qual grupo acelera a degradação."
			rationale: "CAS precisa checar adaptação como rotina, não só quando o gaming já ficou óbvio."
		},
		{
			question:  "Que delays relevantes se aplicam e a intervenção recente já teve tempo de produzir efeito observável?"
			reveals:   "Evita falsa atribuição de causalidade, empilhamento prematuro e leitura errada de sucesso ou fracasso."
			rationale: "Delays são uma das maiores fontes de erro de gestão sistêmica."
		},
		{
			question:  "Há sinais de proximidade de tipping point ou convergência de indicadores negativos?"
			reveals:   "Mostra se prevenção imediata é mais importante do que análise incremental."
			rationale: "Intervenção antes da transição de regime é muito mais barata."
			appliesWhen: "múltiplos indicadores deterioram ao mesmo tempo"
		},
		{
			question:  "A decisão atual cria path dependence material? O custo de reversão em dois anos é alto ou baixo?"
			reveals:   "Distingue escolhas reversíveis de escolhas que exigem cautela estrutural."
			rationale: "Bootstrap tem máxima sensibilidade a lock-in."
			appliesWhen: "a decisão é estrutural ou fundacional"
		},
		{
			question:  "A governança está rígida demais ou flexível demais para o domínio, fase e distribuição de participantes?"
			reveals:   "Mostra se o sistema está ossificado ou caótico."
			rationale: "Edge of chaos precisa ser calibrado continuamente."
			appliesWhen: "há fricção com regras, contornos frequentes ou baixa discriminação"
		},
		{
			question:  "Na dimensão crítica, o sistema está frágil, resiliente ou antifrágil?"
			reveals:   "Mostra a qualidade estrutural da resposta a stress."
			rationale: "Não basta sobreviver ao cenário médio."
			appliesWhen: "a decisão envolve robustez, shock response ou funding/confiança"
		},
		{
			question:  "O problema está em parâmetro, estrutura de informação, regras, objetivos ou paradigma?"
			reveals:   "Identifica o leverage point mais adequado."
			rationale: "Intervenções falham quando atuam no nível errado."
		},
		{
			question:  "Se a intervenção falhar, ela falha por amplificação, adaptação ou delay, e que indicador permitiria detectar isso em 3 a 6 meses?"
			reveals:   "Transforma pre-mortem em checklist operacional."
			rationale: "Consequências não-intencionais em CAS seguem poucos mecanismos recorrentes."
		},
		{
			question:  "Dado o regime, timescale e delays, a decisão correta é intervir agora, monitorar com trigger ou esperar?"
			reveals:   "Fecha a análise com postura operacional clara."
			rationale: "CAS não serve só para explicar; serve para decidir quando agir."
		},
	]

	meshExamples: [
		{
			id:                "ex-scoring-goodhart"
			scenario:          "Após alguns meses, a taxa de entrega 'no prazo' melhora fortemente, enquanto reclamações de qualidade sobem e a relação entre score e default real piora."
			analysis:          "O sistema passou a otimizar a métrica, não o resultado desejado. A melhoria aparente é compatível com Goodhart temporal. Fornecedores mais sofisticados provavelmente adaptaram primeiro e difundiram a nova norma. O delay entre regra, adaptação e deterioração permitiu uma janela em que a mudança parecia sucesso."
			recommendation:    "Intervir no nível de regras e estrutura de informação, não apenas em parâmetros. Introduzir sinais independentes de qualidade, integridade cruzada entre prazo e satisfação e cadência de revisão mais curta para regras que afetam participantes sofisticados."
			principlesApplied: ["ax-03", "ax-05", "dp-05"]
			assumptions: [
				"a melhoria de prazo não é explicada por melhoria real de operação",
				"a reclamação de qualidade é confiável como sinal independente",
			]
			rationale: "O caso mostra Goodhart como dinâmica temporal e emergente, não só como falha lógica de métrica."
		},
		{
			id:                "ex-convergence-crisis"
			scenario:          "AUROC por cohort cai, NPS de fornecedores cai e churn de perfis Q1 sobe ao mesmo tempo, embora métricas agregadas ainda não pareçam catastróficas."
			analysis:          "Há convergência entre múltiplos indicadores e provável regime de transição. O problema pode estar em loop reforçador de degradação: piores dados, pior score, melhores perfis saindo, dados piores ainda. A composição da rede está mudando e isso altera a própria dinâmica do sistema."
			recommendation:    "Classificar imediatamente como transição, identificar temporalidade da degradação, agir no leverage point que interrompe o loop reforçador mais crítico e evitar empilhar mudanças antes do delay mínimo relevante."
			principlesApplied: ["ax-05", "dp-05", "dp-09"]
			assumptions: [
				"não houve choque exógeno dominante no mesmo período",
				"os indicadores desagregados são mais confiáveis do que os agregados para este caso",
			]
			rationale: "O caso mostra por que métricas agregadas mascaram transições perigosas."
		},
		{
			id:                "ex-path-dependence-bootstrap"
			scenario:          "A Mesh precisa escolher entre dois anchors iniciais com perfis setoriais e geográficos diferentes, sabendo que o primeiro anchor moldará scoring, cultura e expansão futura."
			analysis:          "A decisão ocorre no ponto de máxima path dependence e mínima informação. O anchor escolhido mudará dados disponíveis, velocidade de aprendizagem, composição de participantes e tipo de governança tolerável. Além disso, um anchor com base mais heterogênea exige governança mais calibrada para não excluir participantes válidos por excesso de rigidez."
			recommendation:    "Escolher o anchor não apenas por ticket ou prestígio, mas por capacidade de acelerar massa crítica, gerar dados generalizáveis, reduzir delays de calibração e manter governança no edge of chaos. Documentar explicitamente as dependências de trajetória criadas e os pontos de recalibração futura."
			principlesApplied: ["ax-03", "ax-04", "ax-06"]
			assumptions: [
				"o primeiro anchor terá efeito desproporcional sobre composição da rede",
				"há diferença relevante de generalização entre os dois contextos",
			]
			rationale: "O caso mostra CAS como ferramenta para decisão fundacional sob alta irreversibilidade."
		},
	]

	principleIds: ["ax-03", "ax-04", "ax-05", "dp-05", "dp-07", "dp-09"]

	relatedLenses: [
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "Credit-risk modela risco com ferramentas estatísticas e causais locais. CAS complementa quando risco passa a ser produto de loops, delays, composição dinâmica e tipping points."
		},
		{
			lensId:   "lens-platform-dynamics"
			relation: "complementsWith"
			context:  "Platform-dynamics modela flywheels, massa crítica e efeitos de rede. CAS complementa tratando mudanças abruptas de regime, dominância de loops, tipping points e delays entre adoção e qualidade sistêmica."
		},
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Mechanism-design testa incentivos e gamabilidade em estado relativamente estável. CAS complementa com velocidade de adaptação, prazo de validade das regras e difusão de exploits."
		},
		{
			lensId:   "lens-commons-collective-action"
			relation: "complementsWith"
			context:  "Commons modela degradação e governança de recursos compartilhados. CAS complementa com tipping points, dominância de loops e delays entre degradação local e crise sistêmica."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "Behavioral-economics modela vieses individuais. CAS complementa mostrando como adaptações de um tipo de agente cascata sobre outros tipos e mudam a dinâmica agregada."
		},
		{
			lensId:   "lens-network-theory"
			relation: "complementsWith"
			context:  "Network-theory modela topologia e conectividade. CAS complementa com evolução dinâmica da topologia, resiliência sistêmica e propagação não-linear."
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "complementsWith"
			context:  "Financial-intermediation modela estrutura de funding e veículo. CAS complementa com run risk, colapso abrupto de confiança, delays entre composição e yield e fragilidade sistêmica."
		},
	]

	limitations: [
		{
			description: "CAS é framework de pensamento e diagnóstico, não modelo quantitativo fechado."
			alternative: "Usar CAS para orientar, classificar e localizar intervenções, deixando quantificação para outras lenses quando apropriado."
			rationale:   "CAS complementa modelagem quantitativa; não a substitui."
		},
		{
			description: "CAS pode ser usada como desculpa para paralisia, porque 'tudo é complexo'."
			alternative: "Forçar análise em loops, delays, leverage points e decisão terminal explícita: intervir, monitorar ou esperar."
			rationale:   "Complexidade não elimina ação; exige ação melhor estruturada."
		},
		{
			description: "No bootstrap, parte da emergência sistêmica ainda é fraca."
			alternative: "Usar CAS seletivamente no início, sobretudo para path dependence, regime e governança; intensificar uso conforme interdependência sistêmica cresce."
			rationale:   "Nem todo problema inicial é sistêmico, mas alguns já são irreversivelmente estruturais."
		},
		{
			description: "A hierarquia de leverage points é heurística e pode ser difícil de aplicar com precisão."
			alternative: "Começar pelo menor nível que plausivelmente resolve e subir apenas quando falhar repetidamente."
			rationale:   "Evita tanto tuning inútil quanto reformulação prematura de paradigma."
		},
		{
			description: "Pre-mortems nunca antecipam todas as consequências não-intencionais."
			alternative: "Usar checklist estruturado de amplificação, adaptação e delay, combinado com monitoramento pós-intervenção."
			rationale:   "Checklist disciplinado é mais robusto do que imaginação livre."
		},
		{
			description: "Delay map é impreciso no bootstrap e só melhora com dados longitudinais."
			alternative: "Começar com estimates explícitos e recalibrar semestralmente conforme o sistema acumula observações."
			rationale:   "Estimate imperfeita ainda é melhor do que ignorar delays completamente."
		},
	]

	rationale: "Sistemas Adaptativos Complexos é a lente usada quando a Mesh deixa de se comportar como a soma de componentes relativamente estáveis e passa a exibir propriedades sistêmicas próprias. Ela trata emergência, loops, delays, heterogeneidade de agentes, adaptação, Goodhart temporal, tipping points, path dependence, coevolução, fragilidade e calibragem de governança como partes de uma única dinâmica. Seu papel não é substituir as outras lenses, mas explicar quando elas passam a divergir, entram em conflito ou falham em antecipar o comportamento agregado. Operacionalmente, a lente exige stocks canônicos, mapa de delays, classificação de regime, análise de dominância de loops, leverage points e decisão terminal explícita."
}
