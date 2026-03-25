package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

mechanismDesign: artifact_schemas.#AnalyticalLens & {
	id:     "lens-mechanism-design"
	name:   "Design de Mecanismo"
	purpose: "Orientar o design de regras que governam interação econômica entre participantes — pricing, scoring, screening, disclosure — garantindo incentive compatibility, participation constraints e robustez a adverse selection, moral hazard e collusion."
	status: "active"

	trigger: {
		conditions: [
			"a decisão envolve desenhar regras que governam interação entre participantes",
			"a decisão envolve pricing, taxas, descontos ou penalidades",
			"a decisão envolve alinhar incentivos entre partes com interesses diferentes",
			"a decisão envolve como distribuir valor, risco ou custo entre participantes",
			"a decisão envolve desenhar scoring, ranking ou reputação",
			"a decisão envolve criar ou alterar mecanismo de antecipação de recebíveis",
			"a decisão envolve o que acontece após desembolso ou após contrato firmado",
			"a decisão envolve alterar regras de um mecanismo já em operação",
			"a decisão envolve desenhar produto para participantes sem histórico",
			"a decisão envolve escolher o que revelar, para quem, com qual granularidade e quando",
			"a decisão envolve iterar mecanismos de scoring ou pricing com dados acumulados",
		]
		keywords: [
			"pricing", "incentivo", "penalidade", "desconto", "taxa",
			"scoring", "reputação", "ranking", "leilão", "alocação",
			"mecanismo", "regra do jogo", "quem paga", "quem ganha",
			"adverse selection", "moral hazard", "free-rider",
			"information rent", "collusion", "commitment",
			"screening", "menu de contratos", "auto-seleção",
			"information design", "disclosure", "persuasão",
			"automated mechanism", "data-driven", "A/B test de mecanismo",
			"simplicidade", "obviously strategy-proof", "complexidade cognitiva",
		]
		excludeWhen: [
			"a decisão é pricing interno da Mesh como SaaS (cost-plus, sem interação entre participantes da rede)",
			"a decisão é puramente de compliance regulatório sem espaço de design (regras impostas pelo Bacen sem alternativa)",
			"a decisão é de infraestrutura ou tecnologia sem componente econômico entre participantes",
			"a decisão é sobre estrutura informacional diagnóstica sem componente de design de regras — usar information-economics",
		]
		rationale: "Toda regra que governa interação econômica entre participantes da Mesh é um mecanismo. Mecanismos mal desenhados criam incentivos perversos que degradam a rede silenciosamente. A Mesh como plataforma AI-native pode iterar mecanismos continuamente — o que torna tanto o design analítico quanto o design data-driven relevantes."
	}

	concepts: [
		{
			id:         "md-incentive-compatibility"
			name:       "Incentive Compatibility"
			nature:     "theoretical"
			role:       "property"
			definition: "Um mecanismo é incentive-compatible quando o comportamento ótimo individual de cada participante coincide com o comportamento desejado pelo sistema. O participante que otimiza para si melhora o todo. IC cobre tanto revelação de informação (dizer a verdade) quanto escolha de ações (agir conforme desejado)."
			meshManifestation: "Na Mesh, o fornecedor que entrega no prazo e com qualidade ganha score maior, que resulta em taxa menor de antecipação e mais visibilidade para compradores. Otimizar para si (score alto) melhora o sistema (dados melhores, cadeia mais confiável). Se o mecanismo não for IC — por exemplo, se o fornecedor ganha score alto apenas por volume independente de qualidade — o sistema degrada."
			meshImplication: "Todo mecanismo na Mesh deve ser testado: o que o participante faz quando otimiza para si? Se a resposta diverge do que o sistema precisa, o mecanismo está errado. Scoring deve medir performance real ponderada por valor, não proxies manipuláveis."
			rationale: "É o critério central de avaliação de qualquer mecanismo na Mesh. Sem ele, regras que parecem razoáveis podem gerar comportamento destrutivo."
		},
		{
			id:         "md-individual-rationality"
			name:       "Individual Rationality (Participation Constraint)"
			nature:     "theoretical"
			role:       "property"
			definition: "Para que um participante entre e permaneça no mecanismo, o payoff de participar deve ser maior ou igual ao payoff da sua melhor alternativa fora do mecanismo (outside option). A outside option deve ser quantificada concretamente, não assumida genericamente."
			meshManifestation: "O fornecedor compara a Mesh com antecipação bancária tradicional (taxa média de desconto para aquele porte e setor) ou com não antecipar (custo de oportunidade de capital parado). O comprador compara com custo de compliance manual + qualificação manual + spread bancário por falta de dados. IR satisfeita marginalmente é vulnerável — qualquer degradação de serviço empurra o participante para a outside option."
			meshImplication: "Quantificar o outside option de cada participante antes de definir pricing ou condições. Monitorar a margem sobre o outside option — se encolhe, o mecanismo está perdendo atratividade. Onboarding pesado ou benefício lento reduz IR percebida mesmo que IR real seja positiva."
			rationale: "Mecanismo que não satisfaz participation constraint não atrai participantes. Quantificar o outside option transforma análise de IR de intuitiva em analítica."
		},
		{
			id:         "md-adverse-selection"
			name:       "Adverse Selection (Pool Composition)"
			nature:     "theoretical"
			role:       "property"
			definition: "Quando participantes têm informação privada sobre seu próprio tipo (risco, qualidade, confiabilidade), o mecanismo pode atrair desproporcionalmente participantes de tipo ruim. Participantes de tipo bom têm alternativas melhores fora do mecanismo; participantes de tipo ruim não têm. O resultado é um pool enviesado, mesmo que cada transação individual satisfaça IC, IR e budget balance."
			meshManifestation: "Na antecipação de recebíveis, fornecedores que não conseguem crédito bancário tradicional (porque o banco avaliou o risco e recusou) são os primeiros a buscar a Mesh. A Mesh oferece alternativa — e é para isso que existe — mas se a composição inicial do pool é dominada por alto risco, o scoring raso não detecta e o spread não cobre."
			meshImplication: "No bootstrap: anchor tenants curados manualmente, scoring conservador quando dados são rasos, screening via menu de contratos para forçar auto-seleção antes de o scoring ter dados. Em escala: monitorar composição da carteira agregada, não apenas risco individual. Taxa de default crescente com volume pode indicar adverse selection, não falha de scoring."
			dependsOn: ["md-individual-rationality"]
			rationale: "Adverse selection é sobre quem participa, não sobre como se comporta. Sem este conceito, o agente constrói carteira que parece boa individualmente mas é ruim em agregado."
		},
		{
			id:         "md-moral-hazard"
			name:       "Moral Hazard (Hidden Action)"
			nature:     "theoretical"
			role:       "property"
			definition: "Após o contrato ser firmado ou o valor desembolsado, o participante pode tomar ações não observáveis ou não verificáveis que prejudicam a outra parte. Distinto de adverse selection (antes da decisão) e de IC geral. Existe em três direções: do fornecedor, do comprador, e da plataforma."
			meshManifestation: "Fornecedor: após receber antecipação, incentivo reduzido para entregar com qualidade. Comprador: após entrar na plataforma, incentivo reduzido para confirmar entregas no prazo — esforço de registrar dados beneficia o scoring do fornecedor, não o comprador. Plataforma: após acumular dados e rede, incentivo para aumentar taxas, priorizar compradores grandes, ou degradar serviço a fornecedores de baixo spread. A fusão banco↔supply chain dá observabilidade parcial (entregas registradas, pagamentos confirmados), mas muitas ações são observáveis sem serem verificáveis."
			meshImplication: "Fornecedor: condicionar liberação de valor a verificações observáveis (entrega confirmada, nota fiscal válida). Incluir janela de observação pós-transação no scoring. Comprador: criar incentivo direto para alimentar dados (acesso a analytics próprios, score do comprador que afeta condições). Plataforma: commitment crível via regras publicadas, governança transparente, e data portability que reduza percepção de lock-in."
			dependsOn: ["md-incentive-compatibility"]
			rationale: "Sem este conceito em suas três direções, o agente ignora risco pós-desembolso, assume que comprador alimenta dados voluntariamente, e não percebe que a Mesh também tem moral hazard."
		},
		{
			id:         "md-observable-vs-verifiable"
			name:       "Observável vs. Verificável"
			nature:     "theoretical"
			role:       "property"
			definition: "Uma ação ou estado é observável quando o sistema pode detectá-lo. É verificável quando o sistema pode prová-lo formalmente a ponto de condicionar consequências contratuais. Mecanismos que condicionam recompensas a eventos observáveis mas não verificáveis são vulneráveis a gaming."
			meshManifestation: "Na Mesh, muitos sinais são observáveis mas não verificáveis. Comprador atrasou pagamento (dado financeiro observável), mas alega disputa comercial (não verificável pela Mesh). Entrega demorou 5 dias além do prazo (observável), mas fornecedor alega força majeure (não verificável)."
			meshImplication: "Cláusulas contratuais condicionadas apenas a eventos verificáveis (pagamento registrado, nota fiscal válida). Scoring condicionado a sinais observáveis agregados probabilisticamente — padrão de atrasos reduz score, sem necessidade de provar causa individual. Nunca condicionar pagamento ou penalidade a evento que é observável mas não verificável — essas cláusulas viram vetores de gaming."
			dependsOn: ["md-moral-hazard"]
			rationale: "A distinção determina que tipo de resposta de design é possível. Sem ela, o agente desenha cláusulas não enforceáveis."
		},
		{
			id:         "md-screening"
			name:       "Screening: Menu Design Estático e Sequential Screening Dinâmico"
			nature:     "theoretical"
			role:       "method"
			definition: "Screening estático (Rothschild/Stiglitz 1976): oferecer menu de opções para que participantes se auto-selecionem e revelem tipo pela escolha. É o mecanismo fundamental de separação quando o sistema não tem dados para inferir tipo. Screening sequencial (Courty/Li 2000, Bergemann/Välimäki 2019): o mecanismo adapta termos conforme informação chega ao longo do tempo. Tipos não são fixos — fornecedor bom pode deteriorar, fornecedor novo acumula dados. O menu inicial é ponto de entrada; o scoring dinâmico é screening continuado. A transição de estático para dinâmico deve ser explícita no design."
			meshManifestation: "Estático: para fornecedores novos sem histórico, menu de contratos de antecipação — D+1 a taxa premium vs D+15 a taxa menor vs D+30 a taxa base. Fornecedor que precisa urgentemente de liquidez revela tipo pela escolha. Dinâmico: conforme dados acumulam, scoring substitui progressivamente o menu. Mas a transição cria risco: fornecedor que entrou pelo menu 'baixo risco' pode deteriorar sem que o scoring detecte imediatamente (lag entre screening inicial e scoring dinâmico). Fornecedor que entrou pelo menu 'alto risco' pode melhorar mas ficar preso no tier inicial se a reclassificação é lenta."
			meshImplication: "Projetar a transição explicitamente: screening estático domina nos primeiros N meses por fornecedor. Scoring dinâmico assume quando dados atingem threshold (ex: 5+ transações concluídas). Durante a transição: menu e scoring coexistem — score dinâmico pode promover ou rebaixar o tier do menu. Reclassificação com cadência definida (não contínua — evita volatilidade percebida). Trade-off: mais opções no menu melhoram separação mas aumentam complexidade cognitiva (conecta com md-mechanism-simplicity)."
			dependsOn: ["md-adverse-selection"]
			crossDependsOn: [{
				lensId:    "lens-information-economics"
				conceptId: "ie-screening-informational"
				context:   "IE cobre o conteúdo informacional revelado pela escolha. MD cobre o design do menu que induz a escolha. IE diagnostica quais dimensões separam tipos; MD implementa o menu que explora essas dimensões."
			}]
			rationale: "Screening estático é o mecanismo primário no bootstrap. Screening sequencial é a transição para scoring. Sem projetar a transição, o agente trata menu e scoring como sistemas independentes quando são fases do mesmo mecanismo."
		},
		{
			id:         "md-revelation-principle"
			name:       "Revelation Principle"
			nature:     "theoretical"
			role:       "framework"
			definition: "Para analisar o que é possível alcançar com qualquer mecanismo, basta analisar mecanismos diretos onde os participantes revelam suas informações verdadeiras. É ferramenta de análise que delimita o espaço do possível — não prescrição de design. Na prática, mecanismos indiretos (scoring automático, pricing menus, inferência de dados, screening) são frequentemente mais simples e robustos que declaração explícita."
			meshManifestation: "A Mesh tem três mecanismos indiretos por ordem de disponibilidade de dados: screening via menu quando dados não existem, inferência de dados operacionais/financeiros quando dados são parciais, scoring ponderado quando dados são ricos."
			meshImplication: "Nunca pedir declaração quando inferência ou screening resolve. A fusão banco↔supply chain é vantagem estrutural para inferência — dados financeiros revelam o que declarações escondem. Declaração direta é último recurso, não default."
			rationale: "O revelation principle delimita o que é alcançável. A implementação prática na Mesh é via mecanismos indiretos — a vantagem competitiva está em não precisar perguntar."
		},
		{
			id:         "md-information-rent"
			name:       "Information Rent"
			nature:     "theoretical"
			role:       "property"
			definition: "Para que participantes com informação privada revelem a verdade ou se auto-selecionem corretamente, o mecanismo paga um 'aluguel' pela informação. Tipo bom recebe benefício acima do custo justo. Este rent é custo para o designer — quanto mais tipos separar, maior o rent total. Trade-off: fineness of screening vs. custo de rent."
			meshManifestation: "Na antecipação, fornecedores com score alto recebem taxa melhor que score baixo — o spread é information rent. Se diferencial é pequeno demais, fornecedores bons não percebem benefício e saem. Se a Mesh tenta 10 tiers de score, o rent acumulado pode ser proibitivo."
			meshImplication: "Calibrar número de tiers: 2-3 no bootstrap, granularidade cresce com volume e dados. O spread entre tiers não é apenas reflexo de risco — é pagamento de rent necessário para separação. Surplus que a Mesh captura diminui a cada tier adicional. Menos tiers pode ser mais eficiente em surplus total."
			dependsOn: ["md-incentive-compatibility", "md-screening"]
			rationale: "Information rent é simultaneamente necessário e custoso. O agente precisa calibrar, não maximizar."
		},
		{
			id:         "md-impossibility-tradeoffs"
			name:       "Impossibility Results e Trade-offs entre Constraints"
			nature:     "theoretical"
			role:       "framework"
			definition: "Myerson-Satterthwaite (1983): em bilateral trade com informação privada de ambos os lados e ranges de valoração sobrepostos, não existe mecanismo simultaneamente IC, IR, eficiente e budget-balanced. Todo mecanismo real nesse contexto sacrifica pelo menos uma constraint. O resultado se aplica quando há incerteza genuína sobre se a transação é eficiente — não quando o excedente é claro."
			meshManifestation: "O impossibility result não se aplica diretamente à antecipação pura de recebíveis — quando o recebível é legítimo, o excedente é claro. Onde o resultado morde é no matching e qualificação: comprador e fornecedor têm informação privada sobre qualidade e confiabilidade com ranges sobrepostos."
			meshImplication: "Na antecipação: trade-off principal é entre cobertura (antecipar para mais fornecedores) e budget balance, agravado por adverse selection no bootstrap. No matching: sacrificar eficiência (nem todo match eficiente acontece) para manter IC e IR. Precisão sobre onde o impossibility se aplica evita sacrifício desnecessário de eficiência na antecipação enquanto ignora o matching onde o trade-off é real."
			dependsOn: ["md-incentive-compatibility", "md-individual-rationality", "md-budget-balance"]
			rationale: "Sem este conceito, o agente busca design impossível ou faz trade-offs implícitos sem consciência do que foi sacrificado."
		},
		{
			id:         "md-dynamic-commitment"
			name:       "Dynamic Commitment, Time Consistency e Ratchet Effect"
			nature:     "theoretical"
			role:       "property"
			definition: "Em mecanismos dinâmicos, o poder de commitment do designer é variável crítica. Se participantes antecipam mudança de regras, o equilíbrio estático não é o real. Dimensão adicional: ratchet effect (Laffont/Tirole 1988) — se o designer usa informação revelada para ajustar termos no período seguinte, participantes antecipam e sub-revelam. Fornecedor que performa excepcionalmente pode ter taxa aumentada no próximo período ('captura de surplus revelado'), então modera performance deliberadamente. O ratchet effect é caso específico de time inconsistency onde a exploração de informação passada destrói incentivos futuros de revelação."
			meshManifestation: "O scoring da Mesh é dinâmico — muda com dados novos. Se fornecedores sabem que performance excepcional leva a redução desproporcional de taxa de antecipação (Mesh 'cobra' pelo bom desempenho via ajuste de spread), otimizam para mediano. Ratchet específico da Mesh: fornecedor com AUROC de 0.90 no scoring interno pode ter spread reduzido até o ponto onde a Mesh captura todo o surplus da informação — fornecedor não percebe benefício incremental de performance excelente. Inversamente: scoring que piora termos rapidamente após deterioração mas melhora lentamente após recuperação cria assimetria que desencoraja investimento em melhoria."
			meshImplication: "Commitment crível: publicar regras de scoring versionadas, garantir que mudanças não se aplicam retroativamente, definir cadência previsível de atualizações. Contra ratchet: garantir que melhoria de performance gera benefício duradouro e proporcional — não capturar todo o surplus de performance excepcional. Regra: melhoria de score melhora taxa em pelo menos X% por Y meses (commitment mínimo). Simetria de velocidade: score sobe e desce na mesma velocidade. Sem commitment, toda mudança de scoring é percebida como arbitrária e participantes reduzem investimento na plataforma."
			dependsOn: ["md-incentive-compatibility"]
			rationale: "Scoring e pricing na Mesh são inerentemente dinâmicos. Sem commitment crível e proteção contra ratchet, fornecedores não investem em performance de longo prazo porque temem captura de surplus."
		},
		{
			id:         "md-collusion"
			name:       "Collusion e Desvios Coordenados"
			nature:     "theoretical"
			role:       "property"
			definition: "Mecanismos IC individuais podem falhar quando participantes coordenam. Duas formas com respostas distintas: collusion vertical (comprador + fornecedor contra o sistema) e collusion horizontal (fornecedores entre si — cartel de preços, rotação de contratos, manipulação cruzada de rankings)."
			meshManifestation: "Vertical: comprador confirma entregas fictícias, fornecedor preferido ganha score artificial, concorrentes perdem ranking. Horizontal: fornecedores de concreto numa região combinam preços ou coordenam para não competir em licitações. Em B2B de construção civil com relações de anos, ambos são cenários esperados."
			meshImplication: "Vertical: verificação cruzada com dados financeiros (pagamento sem nota correspondente), análise estatística (comprador confirma 100% para um fornecedor mas contesta outros), penalidade simétrica. Horizontal: análise de padrões de bidding (preços similares, rotação de vencedores), comparação com benchmarks, escalar suspeita de cartel para análise jurídica (CADE)."
			dependsOn: ["md-incentive-compatibility"]
			rationale: "Em B2B com relações duradouras, collusion vertical e horizontal são expectativa. Cada tipo exige detecção e resposta de design diferentes."
		},
		{
			id:         "md-mechanism-robustness"
			name:       "Robustez do Mecanismo"
			nature:     "theoretical"
			role:       "property"
			definition: "Mecanismo robusto produz resultados aceitáveis sob condições imperfeitas. Três dimensões com respostas diferentes: (a) tipos desconhecidos — usar estratégia dominante em vez de Bayes-Nash, (b) racionalidade limitada — simplificar regras (ver md-mechanism-simplicity para tratamento formal), (c) dados incompletos — defaults conservadores."
			meshManifestation: "As três dimensões coexistem na Mesh. (a) Nos primeiros meses, distribuição de tipos é desconhecida — screening via menu como fallback. (b) Fornecedores variam em sofisticação — regras simples de entender. (c) Dados incompletos no bootstrap — defaults conservadores."
			meshImplication: "Cada dimensão exige resposta diferente. Para (a): mecanismos que funcionam sem calibração fina. Para (b): simplicidade como constraint formal, não afterthought (md-mechanism-simplicity). Para (c): score default conservador quando dados faltam, migrar para score dinâmico conforme dados acumulam. Não existe solução única para 'robustez'."
			rationale: "Princípio ax-05 traduzido para design de mecanismo com precisão operacional. Três tipos de robustez = três tipos de solução."
		},
		{
			id:         "md-budget-balance"
			name:       "Budget Balance"
			nature:     "theoretical"
			role:       "property"
			definition: "O mecanismo não exige subsídio externo permanente. Três variantes: ex ante (em expectativa — pode perder em cenários individuais), interim (para cada tipo, em expectativa), ex post (em cada cenário individual — nunca perde). A escolha de variante muda fundamentalmente o pricing."
			meshManifestation: "Na antecipação: o spread cobre risco na carteira agregada (ex ante) ou em cada antecipação individual (ex post)? Ex ante permite pricing mais agressivo — subsidiar alto risco com lucro de baixo risco. Ex post exige que cada antecipação individual seja lucrativa."
			meshImplication: "Bootstrap: ex ante (aceitar perdas pontuais em troca de adoção e dados). Escala: migrar gradualmente para ex post (reduzir dependência de diversificação). A decisão de variante é uma das primeiras do mecanismo de antecipação — determina toda a curva de pricing."
			rationale: "A distinção temporal determina quão agressivo o pricing pode ser. Sem ela, budget balance é ambígua."
		},
		{
			id:         "md-information-design"
			name:       "Information Design e Bayesian Persuasion"
			nature:     "theoretical"
			role:       "framework"
			definition: "O dual de mechanism design clássico. Em mechanism design, a alocação de informação é dada e o designer escolhe as regras do jogo. Em information design (Bergemann/Morris 2019), o jogo é dado e o designer escolhe a estrutura informacional — o que revelar, para quem, com qual granularidade, em que momento. Bayesian persuasion (Kamenica/Gentzkow 2011): o designer (sender) commita a uma política de disclosure que influencia decisões do receiver via atualização Bayesiana. Ferramenta central: concavificação — o valor ótimo de disclosure depende da convexidade/concavidade do payoff do sender em relação às beliefs do receiver. Não é manipulação nem engano — é design de estrutura informacional sob racionalidade dos participantes."
			meshManifestation: "A Mesh é simultaneamente mechanism designer (regras do jogo) e information designer (o que cada participante vê). Decisões de information design na Mesh: score do fornecedor visível como número exato, faixa ou ranking relativo. Dados de pagamento do comprador visíveis ao fornecedor ou não. Benchmark setorial público ou restrito a participantes com score acima de threshold. Sinal de deterioração de anchor tenant revelado a fornecedores dependentes — quando, com qual detalhe, via qual canal. Relatórios para cotistas de FIDC — granularidade de informação sobre carteira, inadimplência, concentração."
			meshImplication: "Para cada tipo de informação que a Mesh produz, avaliar: (1) o receiver (comprador, fornecedor, cotista) toma decisão diferente com informação mais/menos granular? Se não: disclosure não agrega valor. (2) Disclosure mais granular resolve assimetria maior que o risco de gaming que cria? Score por faixa (3-4 tiers) pode dominar score exato: reduz gaming, reduz overreaction, simplifica decisão. (3) Timing de disclosure: revelar deterioração de anchor tenant imediatamente (previne corrida informada) vs esperar confirmação (previne falso positivo que causa corrida). (4) Disclosure assimétrica: fornecedor vê seu próprio score exato (para melhorar), comprador vê faixa (para decidir). Information design não é transparency por default — é calibração deliberada da estrutura informacional."
			dependsOn: ["md-incentive-compatibility"]
			crossDependsOn: [{
				lensId:    "lens-information-economics"
				conceptId: "ie-disclosure-transparency"
				context:   "IE diagnostica o nível ótimo de transparência. MD-information-design projeta a estrutura de disclosure como variável de controle com ferramental próprio (concavificação, Bayes plausibility). IE é input diagnóstico; information design é output prescritivo."
			}]
			rationale: "A Mesh produz e controla informação em múltiplas direções. Tratar disclosure como afterthought ou default ('transparência total') ignora que a estrutura informacional é variável de design tão importante quanto pricing ou scoring. Bergemann/Morris 2019: information design é o complemento necessário de mechanism design."
		},
		{
			id:         "md-automated-mechanism-design"
			name:       "Automated Mechanism Design e Iteração Data-Driven"
			nature:     "theoretical"
			role:       "method"
			definition: "Mechanism design clássico resolve analiticamente para mecanismos ótimos dadas premissas. Automated mechanism design (AMD — Conitzer/Sandholm 2002, Dütting et al. 2019) usa otimização computacional e ML/RL para descobrir mecanismos a partir de dados. Deep mechanism design (Zheng et al. 2020, PNAS 2024) aplica redes neurais e RL para aprender mecanismos ótimos em ambientes complexos onde solução analítica é intratável. AMD não substitui análise teórica — complementa com iteração empírica. O papel de constraints teóricas (IC, IR, budget balance) é de guardrails: o espaço de busca do AMD deve ser restringido a mecanismos que satisfazem propriedades fundamentais. Sem guardrails, AMD pode convergir para mecanismos que exploram participantes no curto prazo mas destroem participação no longo prazo."
			meshManifestation: "A Mesh é AI-native: agentes IA podem iterar mecanismos continuamente. O espaço de pricing (curva de desconto por score × maturidade × comprador × setor) é grande demais para otimizar analiticamente. A/B testing de variantes de scoring é viável operacionalmente — agentes podem rodar variantes em paralelo e medir impacto em adoção, default, e satisfação. O risco: overfitting a dados recentes. Mecanismo calibrado em 6 meses de boom não funciona em crise. Outro risco: AMD sem guardrails pode descobrir mecanismo que maximiza receita de curto prazo via exploração de bounded rationality dos fornecedores — tecnicamente ótimo, estrategicamente destrutivo."
			meshImplication: "Usar AMD quando: espaço de design é grande, solução analítica é intratável, e dados acumulados são suficientes para iterar. Não usar AMD quando: o mecanismo afeta trust de longo prazo (pricing de anchor tenant), ou quando dados são rasos (bootstrap — usar análise teórica + screening). Guardrails obrigatórios para todo mecanismo aprendido: IC (participante ganha otimizando para si), IR (participante prefere participar), budget balance (não subsidia permanentemente), e fairness (participantes comparáveis recebem tratamento comparável). AMD com guardrails: restringir espaço de busca a mecanismos que satisfazem constraints, depois otimizar dentro desse espaço. Cadência: iterar scoring/pricing trimestralmente com AMD. Commitment: mudanças derivadas de AMD só aplicam no próximo ciclo (não retroativas). Conecta com ro-experimentation-as-option: cada iteração de AMD é compra de opção informacional."
			crossDependsOn: [{
				lensId:    "lens-real-options"
				conceptId: "ro-experimentation-as-option"
				context:   "Cada iteração de AMD é um experimento. RO define quando o experimento vale (falsificação muda decisão) e quando não vale (A=B: não iterar). AMD é o método; RO é o framework de decisão sobre quando aplicar o método."
			}]
			rationale: "A Mesh como plataforma AI-native pode iterar mecanismos de forma que plataformas tradicionais não podem. AMD operacionaliza essa vantagem mas exige guardrails teóricos para evitar que otimização de curto prazo destrua participação de longo prazo."
		},
		{
			id:         "md-mechanism-simplicity"
			name:       "Simplicidade de Mecanismo como Constraint de Design"
			nature:     "theoretical"
			role:       "property"
			definition: "A complexidade do mecanismo é variável de design, não afterthought. Li (2017): mecanismos 'obviously strategy-proof' (OSP) são mais robustos porque participantes não precisam de raciocínio sofisticado para entender que dizer a verdade é ótimo — cada decisão é dominante no momento em que é tomada, sem necessidade de antecipar jogadas futuras. Pycia/Troyan (2023): simplicidade como constraint formal. Um mecanismo ótimo mas complexo pode ter adoção zero. A fronteira eficiente é entre optimalidade teórica (separação máxima entre tipos, rent mínimo) e praticabilidade cognitiva (participantes entendem e confiam). Wilson doctrine (Wilson 1987): mecanismos práticos devem exigir pouca informação sobre preferências dos participantes — 'detail-free'."
			meshManifestation: "Na construção civil brasileira, fornecedores variam enormemente em sofisticação — de MEI com smartphone a empresa média com ERP. Menu de 7 opções de antecipação pode ter separação ótima mas adoção zero porque ninguém entende as diferenças. Scoring com 15 variáveis pode ter AUROC alto mas fornecedor não sabe o que fazer para melhorar. Dashboard com 20 métricas pode ser informacionalmente rico mas cognitivamente inútil."
			meshImplication: "Simplicidade como constraint: número de opções no menu (2-3 no bootstrap, máximo 4-5 em escala), número de tiers visíveis de score (3-4 faixas), número de ações que o fornecedor precisa entender para otimizar (máximo 3 dimensões: prazo, qualidade, documentação). Teste de simplicidade: 'um fornecedor de construção civil sem equipe financeira entende o que precisa fazer para melhorar suas condições?' Se não: simplificar. Se sim mas mecanismo é sub-ótimo: aceitar sub-optimalidade como custo de adoção. Trade-off explícito: cada opção adicional no menu melhora separação em X% e reduz compreensão em Y% — otimizar no ponto onde ganho marginal de separação < perda marginal de adoção. OSP como aspiração: sempre que possível, desenhar mecanismos onde a ação ótima é óbvia sem raciocínio estratégico."
			dependsOn: ["md-screening", "md-mechanism-robustness"]
			crossDependsOn: [{
				lensId:    "lens-behavioral-economics"
				conceptId: "be-cognitive-overload"
				context:   "BE diagnostica os limites cognitivos reais dos participantes. MD-simplicity usa esse diagnóstico como constraint de design. BE diz 'fornecedores não processam mais que N opções'; MD-simplicity diz 'portanto, o menu tem no máximo N opções'."
			}]
			rationale: "Na Mesh com participantes de sofisticação heterogênea, mecanismo ótimo mas incompreensível é pior que mecanismo sub-ótimo mas adotado. Simplicidade não é simplificação — é constraint de design que preserva adoção e confiança."
		},
	]

	reasoningProtocol: [
		{
			question:  "Qual o mecanismo sendo desenhado ou alterado?"
			reveals:   "Delimita o escopo da análise."
			rationale: "Sem delimitar, a análise fica abstrata."
		},
		{
			question:  "Quem são os participantes e quais são seus incentivos individuais?"
			reveals:   "Mapeia interesses de cada parte. Onde divergem, o mecanismo precisa alinhar."
			rationale: "Mecanismo que ignora incentivos reais falha na prática."
		},
		{
			question:  "Qual a informação privada de cada participante e o que é observável vs. verificável pelo sistema?"
			reveals:   "Define a estrutura informacional: o que cada parte sabe que o sistema não sabe, o que o sistema observa (detecta sinais), e o que verifica (prova formalmente). Cláusulas condicionadas a eventos observáveis mas não verificáveis são vulneráveis a gaming."
			rationale: "A fusão banco↔supply chain cria observabilidade atípica. Mapear essa estrutura é pré-condição para qualquer análise de incentivos."
		},
		{
			question:  "O participante tem incentivo a revelar informação verdadeira ou a mentir? O mecanismo pode inferir de dados, oferecer menu que revele tipo pela escolha, ou precisa pedir declaração?"
			reveals:   "Se mentir é vantajoso, dados corrompidos. Três alternativas por preferência: (1) inferir de dados quando disponíveis, (2) screening via menu quando dados são rasos, (3) declaração — último recurso."
			rationale: "A Mesh tem vantagem estrutural para inferência. Screening é fallback quando dados não existem. Declaração é o mecanismo mais frágil."
		},
		{
			question:  "O comportamento ótimo individual de cada participante coincide com o comportamento desejado pelo sistema?"
			reveals:   "Teste de IC amplo — cobre revelação de informação e escolha de ações."
			rationale: "IC é mais amplo que truth-telling. Inclui alinhar ações pós-contratuais."
		},
		{
			question:  "O que acontece após o desembolso ou após o contrato? Quais ações relevantes são observáveis mas não verificáveis? Quais não são sequer observáveis? Existe moral hazard da plataforma?"
			reveals:   "Identifica moral hazard nas três direções. Para cada ação, classifica: verificável (condiciona cláusula), observável não verificável (alimenta scoring), nem observável (risco puro). Inclui ações da plataforma."
			rationale: "Moral hazard é o risco mais concreto na antecipação. A classificação observável/verificável determina que resposta de design é possível."
		},
		{
			question:  "Qual é o outside option concreto de cada participante, e por quanto o mecanismo supera esse outside option?"
			reveals:   "IR quantificada. Fornecedor: taxa bancária atual, custo de não antecipar. Comprador: custo de compliance manual, custo de qualificação sem Mesh. Margem estreita = vulnerabilidade."
			rationale: "IR genérica é intuitiva. IR quantificada contra outside option concreta é analítica."
		},
		{
			question:  "Quem este mecanismo atrai diferenciadamente? A composição do pool é saudável ou enviesada por adverse selection?"
			reveals:   "IR satisfeita para todos os tipos não garante composição saudável. Se IR é robusta para tipos ruins e marginal para tipos bons, pool é enviesado. No bootstrap sem scoring, adverse selection é risco dominante."
			rationale: "Cada transação pode satisfazer IC + IR + budget balance e a carteira agregada ser tóxica por composição."
		},
		{
			question:  "O diferencial de benefício entre tipos é suficiente para separação? Qual o information rent necessário e quantos tiers justificam o custo?"
			reveals:   "Spread pequeno demais e bons saem. Tiers demais e rent consome surplus. Trade-off: granularidade vs. custo de rent."
			rationale: "Separação tem custo. Calibrar tiers é decisão de design, não default."
		},
		{
			question:  "Existem trade-offs inevitáveis entre constraints? Quais constraints estou relaxando e por quê? O impossibility result se aplica neste contexto específico?"
			reveals:   "Myerson-Satterthwaite se aplica quando há incerteza sobre eficiência da transação (ranges sobrepostos). Não quando excedente é claro. O agente identifica onde o trade-off é real vs. onde não é, e explicita o que sacrifica."
			rationale: "Precisão sobre onde impossibility se aplica evita sacrifício desnecessário de eficiência."
		},
		{
			question:  "O mecanismo se sustenta sem subsídio externo permanente? Sob qual variante de budget balance (ex ante ou ex post)?"
			reveals:   "Viabilidade financeira e sob qual definição. Ex ante permite mais agressividade no bootstrap. Ex post é mais seguro para escala."
			rationale: "A variante escolhida determina toda a curva de pricing."
		},
		{
			question:  "O mecanismo é robusto a desvios coordenados? Existem riscos de collusion vertical (comprador + fornecedor) ou horizontal (fornecedores entre si)?"
			reveals:   "Vulnerabilidades que IC individual não captura. Vertical exige verificação cruzada. Horizontal exige análise de padrões competitivos."
			rationale: "Em B2B com relações duradouras, collusion é expectativa. Vertical e horizontal têm respostas diferentes."
		},
		{
			question:  "O mecanismo é dinamicamente consistente? A Mesh vai querer mudar regras ou explorar informação revelada contra o participante (ratchet effect)? Os participantes antecipam isso?"
			reveals:   "Se sim, equilíbrio estático não é o real. Cobre mudança formal de regras, moral hazard da plataforma, e ratchet effect (captura de surplus de performance excepcional que desincentiva revelação futura)."
			rationale: "Dynamic commitment cobre regras. Ratchet cobre exploração de informação. Ambos afetam confiança e investimento de longo prazo."
		},
		{
			question:  "O que a Mesh revela, para quem, com qual granularidade e quando? A estrutura informacional foi projetada ou é default?"
			reveals:   "Information design: score exato vs faixa, dados de cadeia públicos vs restritos, timing de revelação de deterioração. Se a disclosure não foi projetada, é acidental — e mecanismos acidentais degradam."
			appliesWhen: "o mecanismo produz ou controla informação que afeta decisões de participantes"
			rationale: "A estrutura informacional é variável de design tão importante quanto pricing. Disclosure acidental é mecanismo não-desenhado."
		},
		{
			question:  "O mecanismo é simples o suficiente para participantes com menor sofisticação entenderem e confiarem? Quantas opções, dimensões e decisões o participante precisa processar?"
			reveals:   "Teste de simplicidade: um fornecedor de construção civil sem equipe financeira entende o que precisa fazer? Se não: simplificar mesmo ao custo de sub-optimalidade. Cada opção adicional melhora separação mas reduz adoção."
			rationale: "Mecanismo ótimo mas incompreensível é pior que sub-ótimo mas adotado. Simplicidade é constraint, não simplificação."
		},
		{
			question:  "Este mecanismo deve ser otimizado analiticamente ou iterado com dados (AMD)? Se AMD: quais guardrails teóricos restringem o espaço de busca?"
			reveals:   "AMD quando espaço é grande, dados são suficientes, e solução analítica é intratável. Análise teórica quando trust de longo prazo está em jogo ou dados são rasos. Guardrails: IC, IR, budget balance, fairness."
			appliesWhen: "dados acumulados são suficientes para iterar ou o espaço de design é grande demais para resolver analiticamente"
			rationale: "A Mesh como plataforma AI-native pode iterar mecanismos. Saber quando usar AMD vs análise teórica é decisão de método."
		},
	]

	meshExamples: [
		{
			id:       "ex-scoring-manipulation"
			scenario: "Fornecedor descobre que entregar muitos pedidos pequenos aumenta score mais rápido que poucos grandes, e fragmenta entregas artificialmente."
			analysis: "Scoring recompensa frequência em vez de valor. Não é IC: comportamento ótimo individual (fragmentar) degrada o sistema. Mecanismo mede proxy (contagem) em vez de valor real (performance ponderada)."
			recommendation: "Scoring ponderado por valor do compromisso. Performance = (entregas no prazo × valor) / (total comprometido × valor). Fragmentação não melhora score porque denominador captura valor total."
			principlesApplied: ["ax-05", "dp-08"]
			assumptions: [
				"fornecedor tem capacidade de fragmentar entregas sem custo operacional significativo",
				"scoring atual usa contagem de entregas como proxy de performance",
				"ponderação por valor é implementável com dados disponíveis (valor do compromisso registrado)",
			]
			rationale: "Goodhart's Law aplicado a scoring: quando a métrica vira alvo, deixa de ser boa métrica."
		},
		{
			id:       "ex-anticipation-pricing"
			scenario: "Definir taxa de antecipação de recebíveis para fornecedores."
			analysis: "Trade-offs múltiplos. IR quantificada: taxa menor que outside option bancária (CDI + spread para aquele porte). Budget balance: spread cobre custo de capital + risco + operação (ex ante no bootstrap). IC: taxa menor para score alto. Information rent: spread entre tiers suficiente para separação (2-3 tiers no bootstrap). Adverse selection: screening via menu complementa quando scoring é raso. Impossibility result não se aplica diretamente (excedente claro quando recebível é legítimo) — trade-off principal é cobertura vs budget balance. Simplicidade: fornecedor precisa entender 3 opções, não 7."
			recommendation: "Taxa base = custo de capital + margem operacional. Desconto progressivo por score em 2-3 tiers com spread calibrado para pagar information rent. Bootstrap: menu de contratos complementar para screening. Floor que garante budget balance ex ante. Ceiling que garante IR contra outside option. Fornecedores sem histórico e sem screening satisfatório ficam em espera. Menu limitado a 3 opções por simplicidade."
			principlesApplied: ["ax-05", "ax-07", "dp-02", "dp-08"]
			assumptions: [
				"outside option do fornecedor é taxa bancária para aquele porte — verificar por segmento",
				"custo de capital no bootstrap é equity ~25% a.a. — verificar com funding structure",
				"2-3 tiers é suficiente para separação no bootstrap — validar com dados iniciais",
			]
			rationale: "Pricing de antecipação é o mecanismo mais sensível da Mesh. Trade-offs explícitos, outside option quantificada, screening complementar no bootstrap, simplicidade como constraint."
		},
		{
			id:       "ex-collusion-detection"
			scenario: "Comprador e fornecedor preferido coordenam métricas (vertical); fornecedores de um segmento combinam preços (horizontal)."
			analysis: "Vertical: IC individual satisfeita mas coordenação degrada concorrentes. Comprador confirma entregas fictícias. Horizontal: fornecedores combinam não competir ou coordenam preços, eliminando benefício competitivo da plataforma."
			recommendation: "Vertical: verificação cruzada com dados financeiros, análise estatística de padrões, penalidade simétrica. Horizontal: análise de padrões de bidding, comparação com benchmarks de mercado, monitoramento de concentração. Escalar suspeita de cartel horizontal para análise jurídica (CADE)."
			principlesApplied: ["ax-05", "dp-05", "dp-08"]
			assumptions: [
				"volume de transações é suficiente para análise estatística de padrões",
				"dados financeiros de verificação cruzada estão disponíveis via integração bancária",
				"benchmarks de mercado para preços de materiais de construção são acessíveis",
			]
			rationale: "Vertical e horizontal exigem detecção e resposta distintas. Ambos são cenários esperados em B2B de construção civil."
		},
		{
			id:       "ex-bootstrap-screening"
			scenario: "Fornecedor novo sem histórico quer antecipar recebíveis. Scoring não tem dados."
			analysis: "Inferência não funciona sem dados. Declaração não é confiável. Adverse selection é risco máximo: fornecedores que buscam a Mesh no bootstrap são possivelmente os que não conseguem crédito tradicional. Screening sequencial: menu inicial separa tipos, scoring assume quando dados atingem threshold."
			recommendation: "Menu de contratos: (1) D+1 a taxa premium, (2) D+15 a taxa intermediária, (3) D+30 a taxa base. Máximo 3 opções (simplicidade). Fornecedor que precisa urgentemente revela pela escolha. Transição explícita: após 5+ transações concluídas, scoring dinâmico assume e pode promover ou rebaixar tier do menu. Reclassificação trimestral. Complementar com anchor tenants curados e limites conservadores por fornecedor novo."
			principlesApplied: ["ax-03", "ax-05", "dp-08"]
			assumptions: [
				"5 transações é threshold suficiente para scoring — calibrar com dados reais",
				"3 opções de menu é ótimo de simplicidade — validar compreensão com fornecedores piloto",
				"reclassificação trimestral balanceia estabilidade e responsividade — ajustar conforme feedback",
			]
			rationale: "No bootstrap, screening via menu é mecanismo primário de separação. Transição para scoring dinâmico deve ser projetada, não emergente. Simplicidade do menu é constraint de adoção."
		},
		{
			id:       "ex-score-disclosure-design"
			scenario: "Decidir como e quanto revelar do score do fornecedor para comprador, para o próprio fornecedor, e para cotistas do FIDC."
			analysis: "Information design com três receivers diferentes. Comprador: precisa distinguir fornecedores para contratar. Score exato cria overreaction (rejeitar 74, aceitar 76). Faixa simplifica decisão. Fornecedor: precisa saber como melhorar. Faixa é insuficiente — precisa de score granular e quais dimensões impactam. Cotista: precisa avaliar qualidade da carteira. Agregação por faixa + distribuição é informativa sem revelar dados individuais. Ratchet risk: se fornecedor sabe score exato e Mesh ajusta taxa proporcionalmente, fornecedor modera performance para evitar captura de surplus."
			recommendation: "Disclosure assimétrica por receiver: comprador vê faixa (3-4 tiers — Bronze/Prata/Ouro/Platina). Fornecedor vê score numérico + breakdown por dimensão (entrega, documentação, pagamento) + posição dentro do tier. Cotista vê distribuição da carteira por faixa + métricas agregadas (inadimplência por faixa, concentração). Contra ratchet: taxa vinculada à faixa (não ao score exato), com commitment de permanência na faixa por 1 ciclo após promoção."
			principlesApplied: ["ax-05", "ax-07", "dp-08"]
			assumptions: [
				"3-4 tiers é granularidade suficiente para decisão do comprador — validar",
				"disclosure assimétrica é operacionalmente viável na plataforma",
				"commitment de 1 ciclo por faixa é suficiente contra ratchet — monitorar",
			]
			rationale: "Information design aplicado: a mesma informação (score) tem disclosure ótima diferente para cada receiver. Não é 'transparência total' nem 'opacidade' — é calibração deliberada."
		},
	]

	principleIds: ["ax-03", "ax-05", "ax-06", "ax-07", "dp-02", "dp-05", "dp-08"]

	relatedLenses: [
		{
			lensId:   "lens-information-economics"
			relation: "complementsWith"
			context:  "IE mapeia a estrutura informacional em profundidade — assimetrias, sinais, valor da informação. MD usa esse mapa para desenhar regras e disclosure. IE diagnostica; MD projeta. Information design (md-information-design) é a ponte: usa diagnóstico de IE para projetar estrutura informacional como variável de controle."
		},
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "CR avalia risco de default individual e sistêmico. MD desenha incentivos que afetam composição da carteira (adverse selection) e comportamento pós-desembolso (moral hazard). Se MD cria incentivo que atrai adverse selection, CR detecta na composição da carteira."
		},
		{
			lensId:   "lens-market-design"
			relation: "complementsWith"
			context:  "Market design cobre matching, liquidez e estrutura de mercado. MD cobre incentivos e regras. Usar junto quando o mecanismo envolve alocação entre compradores e fornecedores."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "BE prediz comportamento real sob racionalidade limitada. MD assume racionalidade ou projeta para robustez a ela. md-mechanism-simplicity usa diagnóstico de BE (limites cognitivos) como constraint de design. Usar junto em onboarding e decisões de adoção."
		},
		{
			lensId:   "lens-regulatory-strategy"
			relation: "alternativeTo"
			context:  "Quando regulação define as regras do jogo (Bacen, SCD), MD se aplica apenas ao espaço que a regulação permite. Usar RS como primária e MD para o espaço de design residual."
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "feedsInto"
			context:  "O output de MD (pricing, screening, IC analysis) alimenta decisões de intermediação financeira (liquidity management, funding structure). MD define as regras; FI avalia se a Mesh consegue operá-las financeiramente."
		},
		{
			lensId:   "lens-real-options"
			relation: "complementsWith"
			context:  "md-automated-mechanism-design conecta com ro-experimentation-as-option: cada iteração de AMD é compra de opção informacional. RO decide quando iterar (falsificação muda decisão?); AMD é o método de iteração."
		},
		{
			lensId:   "lens-game-theory-applied"
			relation: "complementsWith"
			context:  "GT analisa comportamento estratégico dado o mecanismo. MD desenha o mecanismo dado o comportamento esperado. GT é positivo (o que acontece); MD é normativo (o que projetar). md-collusion usa GT para modelar desvios coordenados; MD responde com design anti-collusion."
		},
	]

	limitations: [
		{
			description: "Mechanism design assume que o desenhista controla as regras do jogo. Na Mesh, algumas regras são impostas por regulação e não podem ser alteradas."
			alternative: "Para decisões onde regulação define as regras, usar regulatory-strategy como primária e mechanism-design apenas para o espaço residual."
			rationale: "Otimizar um mecanismo dentro de constraints regulatórias é diferente de otimizar sem constraints."
		},
		{
			description: "Mechanism design é normativo — diz como desenhar. Não prediz como participantes de fato se comportam quando são boundedly rational."
			alternative: "Para comportamento real sob mecanismos existentes, complementar com behavioral-economics. Para estrutura informacional em profundidade, usar information-economics."
			rationale: "O gap entre design normativo e comportamento real é onde behavioral-economics e information-economics complementam."
		},
		{
			description: "A análise assume agentes individuais ou coalizões estáveis. Não cobre dinâmicas emergentes onde o mecanismo altera a estrutura da rede ao longo do tempo."
			alternative: "Para efeitos sistêmicos e emergentes, complementar com complex-adaptive-systems e network-theory."
			rationale: "Mecanismo que muda a composição da rede cria efeitos de segunda ordem que mechanism design estático não captura."
		},
		{
			description: "Automated mechanism design exige dados suficientes e pode overfittar a condições recentes. Em bootstrap com poucos dados ou em transição macro, AMD é arriscado."
			alternative: "No bootstrap: análise teórica + screening estático. AMD assume quando volume e diversidade de dados justificam iteração empírica."
			rationale: "AMD sem dados suficientes é otimização de ruído. Guardrails teóricos não substituem dados — restringem o espaço de erro."
		},
		{
			description: "Information design assume que o designer pode commitar a uma política de disclosure. Se a Mesh não consegue commitar (ex: regulação exige disclosure total de certos dados), o framework perde poder."
			alternative: "Verificar constraints regulatórias sobre disclosure via regulatory-strategy antes de projetar information design."
			rationale: "Disclosure regulatória é constraint hard que pode eliminar o espaço de design informacional."
		},
	]

	rationale: "A Mesh é um sistema de mecanismos econômicos: scoring, pricing, alocação, reputação, disclosure. Cada um cria incentivos que moldam comportamento de fornecedores e compradores. Mecanismos mal desenhados degradam a rede silenciosamente — e mecanismos ingenuamente desenhados ignoram moral hazard, adverse selection, information rent, impossibility results, collusion e ratchet effect. A Mesh como plataforma AI-native adiciona duas dimensões: pode projetar deliberadamente a estrutura informacional (information design) e pode iterar mecanismos continuamente com dados (automated mechanism design) — desde que guardrails teóricos restrinjam o espaço de busca. Simplicidade de mecanismo é constraint, não afterthought, num mercado com participantes de sofisticação heterogênea. Esta lense é a ferramenta primária para avaliar se as regras do jogo produzem o comportamento desejado, sob condições realistas."
}
