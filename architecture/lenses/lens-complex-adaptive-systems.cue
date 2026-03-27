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
}
