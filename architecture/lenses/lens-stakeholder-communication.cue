package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

stakeholderCommunication: artifact_schemas.#AnalyticalLens & {
id:     "lens-stakeholder-communication"
name:   "Comunicação com Stakeholders e Signaling"

purpose: "Orientar decisões sobre como comunicar com audiências distintas (fornecedor PME, construtora, FIDC, regulador, investidor) calibrando framing, profundidade e canal."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve o que comunicar, quando e como a um stakeholder externo (investidor, regulador, parceiro, cliente)",
		"a decisão envolve construir credibilidade ou confiança com uma audiência que não tem acesso à informação interna",
		"a decisão envolve enquadrar a mesma informação para audiências diferentes (investidor vs regulador vs fornecedor)",
		"a decisão envolve quanto revelar vs quanto proteger em uma comunicação",
		"a decisão envolve como responder a uma crise, falha ou surpresa negativa perante stakeholders",
		"a decisão envolve calibrar expectativas de stakeholders sobre roadmap, timeline ou performance",
		"a decisão envolve construir narrativa para fundraising, pitch ou posicionamento público",
		"a decisão envolve como comunicar com regulador de forma que construa confiança institucional",
		"a decisão envolve quando não comunicar é estrategicamente superior a comunicar",
		"a decisão envolve tornar claims verificáveis em vez de depender de confiança declarada",
	]
	keywords: [
		"comunicação", "stakeholder", "investidor", "regulador",
		"sinalização", "signaling", "credibilidade", "confiança",
		"pitch", "narrativa", "fundraising", "deck",
		"transparência", "disclosure", "revelar", "proteger",
		"expectativa", "over-promise", "under-deliver",
		"crise", "incidente", "reputação", "confiança",
		"Bacen", "CVM", "regulatório", "compliance",
		"parceiro", "fornecedor", "comprador", "anchor tenant",
		"framing", "enquadramento", "audiência",
		"silêncio estratégico", "timing de comunicação",
	]
	excludeWhen: [
		"a decisão é sobre requisitos regulatórios substantivos (o que o regulador exige) — usar regulatory-strategy",
		"a decisão é sobre design de incentivos entre participantes da plataforma — usar mechanism-design",
		"a decisão é sobre assimetria de informação como propriedade econômica de mercados — usar information-economics",
		"a decisão é sobre governança interna de agentes IA — usar ai-agent-governance",
		"a decisão é sobre alocação de tempo a atividades de comunicação vs outras — usar organizational-resource-allocation",
	]
	rationale: "Toda organização opera num ecossistema de stakeholders que não têm acesso à informação interna. A forma como a organização comunica — o que revela, o que omite, como enquadra, quando fala e quando cala — é determinante para acesso a capital (investidores), permissão de operar (reguladores), acesso a mercado (parceiros e clientes) e reputação (ecossistema). Na Mesh como fintech AI-native pré-revenue, comunicação com stakeholders é infraestrutura estratégica: o regulador precisa confiar que AI governance é robusta, o investidor precisa ver tração e visão, o fornecedor precisa confiar que antecipação é segura. Sem framework, comunicação é ad hoc, inconsistente e reativa."
}

concepts: [
	{
		id:         "sc-signaling-theory"
		name:       "Signaling: Ações Custosas que Revelam Informação Crível"
		nature:     "theoretical"
		role:       "framework"
		definition: "Spence (1973, 'Job Market Signaling'): em mercados com assimetria de informação, agentes de alta qualidade podem se distinguir dos de baixa qualidade emitindo sinais custosos — custosos o suficiente para que agentes de baixa qualidade não consigam imitá-los. O sinal é crível porque é caro. Cheap talk (Crawford/Sobel 1982): comunicação sem custo não é crível quando interesses divergem — o receptor desconta racionalmente. Connelly et al. (2011, 'Signaling Theory: A Review and Assessment'): para um sinal ser eficaz requer: observabilidade (receptor vê o sinal), custo (emissor paga para emitir), e correlação (sinal correlaciona com qualidade subjacente). Sinais eficazes reduzem assimetria; sinais baratos a aumentam (noise)."
		meshManifestation: "Na Mesh, sinais para cada audiência: Investidor — tração real (anchor tenants, volume, unit economics) é sinal custoso (requer execução). Slide bonito sem tração é cheap talk. Regulador — governance codificada (mesh-spec, audit trail, CLAUDE.md) é sinal custoso (requer investimento em compliance antes de obrigação). Afirmar 'temos governança robusta' sem artefatos é cheap talk. Fornecedor — antecipação paga no prazo é sinal custoso. Marketing sobre 'taxas competitivas' sem histórico é cheap talk. Parceiro — código aberto de schemas, documentação detalhada de APIs é sinal custoso de competência técnica."
		meshImplication: "Para cada stakeholder-chave: (1) identificar qual informação privada a Mesh tem que o stakeholder quer verificar (qualidade do scoring, robustez da governance, capacidade de execução). (2) Identificar sinais custosos que correlacionam com essa qualidade — e que competidores de baixa qualidade não podem imitar. (3) Investir em emitir esses sinais antes de precisar deles. ax-03: pagar complexidade cedo — construir audit trail antes do regulador pedir, validar com anchor tenants antes de fundraising. (4) Evitar cheap talk: afirmações não-verificáveis degradam credibilidade. Cada claim deve ser backed por evidência ou explicitamente declarada como aspiração."
		crossDependsOn: [{
			lensId:    "lens-information-economics"
			conceptId: "ie-information-asymmetry"
			context:   "IE modela assimetria de informação como propriedade econômica — quem sabe o quê, e como isso afeta transações. SC operacionaliza a redução estratégica dessa assimetria via signaling. IE pergunta 'onde está a assimetria'; SC pergunta 'como reduzí-la credivelmente'."
		}]
		rationale: "Spence 1973: signaling é o mecanismo que permite distinguir qualidade em mercados com assimetria. Crawford/Sobel 1982: cheap talk é descontado. Na Mesh, cada stakeholder relationship é mercado com assimetria — a credibilidade da comunicação depende do custo do sinal, não da eloquência."
	},
	{
		id:         "sc-bayesian-persuasion"
		name:       "Persuasão Bayesiana: Disclosure Ótimo de Informação"
		nature:     "theoretical"
		role:       "method"
		definition: "Kamenica/Gentzkow (2011, 'Bayesian Persuasion'): um sender pode influenciar as decisões de um receiver racional escolhendo que informação revelar e com que estrutura — mesmo que o receiver saiba que o sender tem interesse próprio. O sender não mente — escolhe o experiment (qual informação gerar e compartilhar). O receiver atualiza crenças bayesianamente. O poder do sender vem de controlar a estrutura da informação, não o conteúdo. Implicação: transparência total nem sempre é ótima para o sender, e opacidade total nunca é ótima (receiver assume o pior). O ótimo está entre os extremos — depende dos priors do receiver e da função de decisão."
		meshManifestation: "Na Mesh comunicando com investidor: revelar AUROC do scoring sem revelar volume de operações pode levar o investidor a superestimar maturidade. Revelar ambos calibra a crença corretamente. Revelar churn de fornecedores sem contexto (churn era de fornecedores não-qualificados, substituídos por qualificados) leva a conclusão negativa incorreta. A estrutura da informação revelada importa tanto quanto o conteúdo. Com regulador: revelar que agentes IA operam com autonomia sem revelar o framework de governance (lifecycle, blast radius, audit trail) ativa priors negativos sobre IA sem supervisão."
		meshImplication: "Para cada comunicação significativa: (1) Quais são os priors do receptor sobre a Mesh? (investidor: 'fintech early-stage com IA = risco alto'. regulador: 'IA em crédito = caixa preta'). (2) Que informação, se revelada, move os priors na direção correta? (investidor: tração real + unit economics. regulador: governance codificada + audit trail). (3) Que informação, se revelada sem contexto, move os priors na direção errada? (métricas isoladas, falhas sem remediação). (4) Qual é a estrutura ótima de disclosure? Não é revelar tudo nem esconder tudo — é revelar o que calibra crenças corretamente. Regra: nunca mentir (destrói credibilidade permanentemente), mas estruturar disclosure para que o receptor atualize na direção que reflete a realidade."
		dependsOn: ["sc-signaling-theory"]
		rationale: "Kamenica/Gentzkow 2011: o poder está na estrutura da informação, não no conteúdo. Na Mesh, comunicação com cada stakeholder é problema de persuasão bayesiana — o receptor é racional e atualiza crenças. A Mesh controla que informação gerar e revelar, não o que o receptor conclui."
	},
	{
		id:         "sc-audience-specific-framing"
		name:       "Framing por Audiência: Mesma Realidade, Enquadramentos Distintos"
		nature:     "theoretical"
		role:       "method"
		definition: "Tversky/Kahneman (1981, 'The Framing of Decisions and the Psychology of Choice'): a forma como uma informação é apresentada (frame) afeta a decisão do receptor, mesmo quando o conteúdo é idêntico. Fiske/Taylor (2013): processamento de informação é schema-driven — pessoas assimilam informação nova nos schemas existentes. Cada audiência tem schema diferente: investidor processa em termos de retorno/risco/escala; regulador em termos de compliance/risco sistêmico/proteção ao consumidor; fornecedor em termos de custo/benefício/confiabilidade. Enquadrar no schema do receptor não é manipulação — é tradução. A mesma realidade, comunicada no schema errado, é mal compreendida."
		meshManifestation: "Na Mesh, a mesma feature (scoring de compradores por agente IA) enquadrada para audiências diferentes: Investidor: 'scoring proprietário com AUROC 0.72 permite precificação de risco granular, criando moat de dados e unit economics superiores ao benchmark'. Regulador: 'modelo de scoring com trilha de auditoria completa, governance codificada, human-in-the-loop para decisões acima do threshold, e monitoramento contínuo de drift'. Fornecedor: 'seu recebível é avaliado automaticamente em segundos, com taxa definida pelo perfil do comprador — quanto melhor o comprador, menor a taxa'. Comprador: 'fornecedores qualificados entregam melhor e custam menos na plataforma — seu score de pagamento é ativo reputacional'. Mesma feature, quatro frames."
		meshImplication: "Para cada comunicação significativa: (1) Quem é a audiência? (2) Qual é o schema dessa audiência — que categorias usa para processar informação? (3) Enquadrar a informação no schema do receptor. (4) Teste: alguém dessa audiência entenderia e agiria com base neste enquadramento? Se não: re-enquadrar. Consistency constraint: frames diferentes da mesma realidade devem ser consistentes — se investidor ouve 'moat de dados' e regulador ouve 'decisão com trilha de auditoria', ambos devem estar descrevendo o mesmo sistema. Se os frames contradizem: red flag — ou a comunicação é inconsistente ou a realidade é. Manter documento interno que mapeia: realidade → frame investidor → frame regulador → frame fornecedor → frame comprador."
		dependsOn: ["sc-signaling-theory", "sc-bayesian-persuasion"]
		rationale: "Tversky/Kahneman 1981: frame afeta decisão. Fiske/Taylor 2013: processamento é schema-driven. Na Mesh, cada audiência tem schema diferente — comunicar no schema errado não é transparência, é ruído."
	},
	{
		id:         "sc-narrative-economics"
		name:       "Narrative Economics: Narrativas como Força Econômica"
		nature:     "theoretical"
		role:       "framework"
		definition: "Shiller (2019, Narrative Economics): narrativas econômicas se espalham como epidemias — contagious, mutating, and capable of driving major economic events. Narrativas não apenas descrevem a realidade — constroem a realidade percebida que governa decisões. Akerlof/Shiller (2015, Phishing for Phools): narrativas exploram vieses cognitivos. Para organizações: a narrativa sobre a empresa é tão determinante quanto a performance real. Investidores investem em narrativas + dados, não apenas em dados. Reguladores regulam com base em narrativas de risco ('IA sem supervisão é perigosa'). Fornecedores adotam plataformas com base em narrativas de sucesso ('quem está na Mesh cresce')."
		meshManifestation: "Na Mesh, múltiplas narrativas competem: Narrativa positiva: 'banco nativo de supply chain onde dinheiro e operação coexistem — o futuro da intermediação financeira'. Narrativa de risco: 'startup pré-revenue usando IA para decisões de crédito sem histórico'. Narrativa de categoria: 'mais uma fintech de antecipação de recebíveis'. A Mesh compete não apenas por mercado — compete pela narrativa que define como stakeholders a percebem. Se a narrativa dominante for 'mais uma fintech de antecipação', a Mesh é avaliada e regulada como commodity. Se for 'infraestrutura onde supply chain se auto-organiza', é avaliada como categoria nova."
		meshImplication: "Construir e defender narrativa core: 'banco B2B nativo de supply chain — dinheiro, operação e decisão coexistem'. Narrativa deve ser: (1) verdadeira (backed por sinais custosos), (2) simples (comunicável em 30 segundos), (3) distinta (não confundível com categoria existente), (4) contagious (stakeholder repete para terceiros). Testar: investidor consegue explicar a Mesh para outro investidor em 1 minuto sem perder o essencial? Se não: narrativa é complexa demais ou não é contagious. Proteger: monitorar se narrativa de mercado está derivando ('ah, vocês são tipo a Barte'). Se sim: investir em sinais que diferenciam. Narrativa não substitui execução — mas execução sem narrativa não captura o valor que gerou."
		dependsOn: ["sc-signaling-theory"]
		rationale: "Shiller 2019: narrativas são forças econômicas, não apenas comunicação. Na Mesh, a narrativa define como stakeholders percebem, avaliam e decidem — é infraestrutura estratégica, não marketing."
	},
	{
		id:         "sc-commitment-credibility"
		name:       "Credibilidade de Compromissos"
		nature:     "theoretical"
		role:       "property"
		definition: "Schelling (1960, The Strategy of Conflict): um compromisso é crível quando é custoso de quebrar — o emissor 'queima os navios'. Dixit/Nalebuff (1991): credibilidade depende de irreversibilidade, visibilidade e custo de renegação. Williamson (1983): hostage model — ativos específicos investidos na relação funcionam como reféns que tornam abandono custoso. Em comunicação com stakeholders: prometer é cheap talk. Investir recursos irreversíveis na direção prometida é sinal crível. Promessas não-verificáveis são descontadas racionalmente pelo receptor."
		meshManifestation: "Na Mesh: 'Vamos ter SCD em 18 meses' é cheap talk (não verificável, não custoso). 'Contratamos advogado especializado em regulação bancária e iniciamos documentação junto ao Bacen' é sinal custoso (dinheiro gasto, processo iniciado). 'Nosso scoring é robusto' é cheap talk. 'Nosso scoring passou auditoria externa com AUROC 0.72 e trilha completa publicada' é sinal custoso. Para fornecedores: 'taxas competitivas' é cheap talk. 'Primeiras 10 antecipações com taxa fixa de X%, publicada, sem condições ocultas' é compromisso crível (custo: margem reduzida nas primeiras operações)."
		meshImplication: "Para cada compromisso com stakeholder: (1) O compromisso é verificável? Se não: transformar em verificável ou não prometer. (2) O compromisso tem custo de renegação? Se não: receptor desconta racionalmente. (3) Existe mecanismo de enforcement? (contrato, depósito, publicidade que torna renegação visível). Hierarquia de credibilidade: compromisso verificável + irreversível + público > compromisso verificável + reversível > compromisso verbal privado > promessa vaga. Para investidores: milestones verificáveis com timeline > visão inspiradora sem milestones. Para regulador: artefatos entregues > promessas de compliance futuro. Para fornecedores: operação real > material de venda."
		dependsOn: ["sc-signaling-theory"]
		crossDependsOn: [{
			lensId:    "lens-game-theory-applied"
			conceptId: "gt-commitment-devices"
			context:   "GT modela commitment devices como mecanismos de jogo — queimar navios, contratos vinculantes, reputação como ativo em jogos repetidos. SC operacionaliza como construir e comunicar compromissos críveis com stakeholders específicos. GT é a teoria; SC é a aplicação em comunicação."
		}]
		rationale: "Schelling 1960: credibilidade = custo de quebrar. Dixit/Nalebuff 1991: irreversibilidade + visibilidade. Na Mesh, cada promessa a stakeholder é avaliada pela sua credibilidade — não pela sua eloquência."
	},
	{
		id:         "sc-verifiable-claims"
		name:       "Claims Verificáveis: De 'Confie em Mim' para 'Verifique Você'"
		nature:     "theoretical"
		role:       "method"
		definition: "O'Hara (2012, 'Transparency, Open Data, and Trust in Government'): transparência verificável é superior a confiança declarada — reduz custo de monitoramento e aumenta accountability. Botsman (2017, Who Can You Trust?): a era da confiança institucional está migrando para confiança distribuída — baseada em evidência verificável por terceiros, não em autoridade declarada. Zuboff (2019): dados como evidência. Em plataformas digitais: claims verificáveis (dashboard público, dados auditáveis, API aberta) substituem claims declaradas (marketing, promessas) como moeda de confiança. A verificabilidade é especialmente crítica para organizações AI-native porque o stakeholder não pode 'ver' o que o agente faz — precisa de evidência."
		meshManifestation: "Na Mesh AI-native, stakeholders não podem observar diretamente como agentes operam. Verificabilidade é infraestrutura de confiança: Regulador — audit trail consultável, governance as code no repositório versionado, relatórios de drift detection. Não 'temos governance': aqui está o repositório com diff de cada mudança. Investidor — métricas reais em dashboard (volume, default rate, NPS fornecedor), não slides com projeções. Fornecedor — portal com status de antecipação em tempo real, histórico de taxas, tempo médio de pagamento. Comprador — dashboard de performance na plataforma, score visível, benchmark de categoria."
		meshImplication: "Para cada claim que a Mesh faz a stakeholders: (1) É verificável pelo receptor sem depender da Mesh? Se sim: claim forte. Se não: transformar em verificável ou declarar explicitamente como aspiração. (2) Investir em infraestrutura de verificabilidade: dashboards, APIs, repositórios abertos, audit trails consultáveis. ax-07: informação como ativo — a infraestrutura de verificabilidade é ativo que se acumula. (3) Gradiente de verificabilidade por stakeholder: regulador precisa de verificabilidade profunda (audit trail, código). Investidor precisa de métricas agregadas verificáveis. Fornecedor precisa de status individual verificável. Comprador precisa de benchmark verificável. (4) Na Mesh AI-native, verificabilidade compensa a opacidade inerente de agentes IA — o stakeholder não vê o agente decidir, mas vê a trilha completa da decisão."
		dependsOn: ["sc-signaling-theory", "sc-commitment-credibility"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-audit-trail"
			context:   "AAG implementa audit trail para governance interna de agentes. SC usa audit trail como infraestrutura de verificabilidade para stakeholders externos. AAG constrói a trilha; SC a comunica como claim verificável."
		}]
		rationale: "O'Hara 2012: transparência verificável > confiança declarada. Botsman 2017: confiança distribuída baseada em evidência. Na Mesh AI-native, verificabilidade é a resposta para a opacidade inerente de sistemas de IA — e é ativo que se acumula."
	},
	{
		id:         "sc-expectation-management"
		name:       "Gestão de Expectativas: Calibrar para Cumprir"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Oliver (1980, Expectation-Confirmation Theory): satisfação = performance percebida − expectativa. Se expectativa > performance: insatisfação, mesmo que performance seja boa em absoluto. Kahneman/Tversky (1979, Prospect Theory): perdas pesam mais que ganhos — under-deliver relativo à expectativa é mais danoso que over-deliver é benéfico. Implicação para comunicação: calibrar expectativas corretamente é mais importante que maximizar a promessa. Under-promise e over-deliver é superior a over-promise e under-deliver — mesmo quando a performance real é idêntica."
		meshManifestation: "Na Mesh: prometer 'antecipação em 24h' e entregar em 48h = insatisfação. Prometer 'antecipação em até 72h' e entregar em 48h = satisfação. Performance idêntica, expectativa diferente. Com investidor: prometer 'R$10M em volume no Q3' e entregar R$7M = falha. Prometer 'R$5M com stretch de R$8M' e entregar R$7M = sucesso. Com regulador: prometer 'compliance completo no dia 1' e ter gap = perda de confiança. Comunicar 'plano de compliance em fases com marcos verificáveis' e cumprir cada fase = construção de confiança."
		meshImplication: "Regra operacional: para qualquer compromisso com stakeholder, aplicar desconto de 20-30% na promessa relativo ao cenário esperado. O cenário esperado é interno; o comunicado é conservador. Se performance excede comunicado: over-delivery fortalece confiança. Se performance atinge comunicado mas não cenário interno: stakeholder satisfeito, organização sabe que precisa melhorar. Nunca: comunicar cenário otimista como expectativa. Exceção: fundraising exige mostrar upside — neste caso, separar explicitamente 'base case' de 'stretch case' e ancorar expectativa no base. Para agentes que comunicam com stakeholders (notificações, relatórios): templates devem ter buffers embutidos em timelines e promessas."
		dependsOn: ["sc-bayesian-persuasion"]
		rationale: "Oliver 1980: satisfação é relativa à expectativa, não absoluta. Kahneman/Tversky 1979: perdas > ganhos. Na Mesh, calibrar expectativas é a forma mais barata de aumentar satisfação de stakeholders — custa zero e evita dano reputacional."
	},
	{
		id:         "sc-transparency-calibration"
		name:       "Calibração de Transparência: Quanto Revelar vs Quanto Proteger"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Heald (2006, 'Varieties of Transparency'): transparência não é binária — tem dimensões (data transparency, process transparency, decision transparency) e cada dimensão pode ser calibrada por audiência. Etzioni (2010): transparência excessiva pode ser prejudicial — gera information overload, expõe vulnerabilidades a competidores, e sacrifica privacidade. Stiglitz (2000): em mercados, transparência reduz assimetria mas pode reduzir incentivos à inovação (se competidores copiam). A calibração ótima depende de: quem é o receptor, que tipo de transparência precisa, e qual é o custo de revelar para cada tipo."
		meshManifestation: "Na Mesh: transparência total para regulador sobre governance e operações — obrigatória e construtora de confiança. Transparência parcial para investidor — métricas de tração sim, detalhes de scoring model não (proteção de IP). Transparência seletiva para fornecedor — status da sua operação sim, lógica interna de pricing não (competitivo). Transparência mínima para competidores — posicionamento público sim, roadmap detalhado não. Revelar demais ao investidor sobre desafios operacionais granulares pode criar ansiedade desproporcional. Revelar de menos pode criar surpresa negativa quando problema emerge."
		meshImplication: "Mapa de transparência por stakeholder e por dimensão: Para cada par (stakeholder, dimensão de informação), definir: revelar proativamente / revelar se perguntado / proteger. Regulador: revelar proativamente tudo que demonstra compliance e governance. Investidor: revelar proativamente métricas de tração e milestones; revelar se perguntado sobre desafios operacionais com contexto e plano; proteger IP técnico detalhado. Fornecedor: revelar proativamente status individual e condições; proteger dados agregados de outros fornecedores e lógica de scoring. Revisão: mapa de transparência é artefato vivo — o que é protegido hoje pode ser revelado amanhã (ex: abrir metodologia de scoring quando já é moat)."
		dependsOn: ["sc-bayesian-persuasion", "sc-audience-specific-framing"]
		crossDependsOn: [{
			lensId:    "lens-information-economics"
			conceptId: "ie-strategic-disclosure"
			context:   "IE modela o valor econômico de disclosure e retenção de informação. SC operacionaliza como calibrar transparência por stakeholder e por dimensão. IE pergunta 'qual é o valor da informação'; SC pergunta 'para quem revelar, quanto, e em que formato'."
		}]
		rationale: "Heald 2006: transparência é multidimensional e calibrável. Etzioni 2010: transparência excessiva tem custos. Na Mesh, transparência é recurso estratégico — revelar demais é tão perigoso quanto revelar de menos."
	},
	{
		id:         "sc-platform-trust-architecture"
		name:       "Arquitetura de Confiança de Plataforma"
		nature:     "theoretical"
		role:       "framework"
		definition: "Botsman (2017, Who Can You Trust?): confiança evoluiu de local (comunidade) para institucional (bancos, governos) para distribuída (plataformas, peer-to-peer). Plataformas constroem confiança via: (1) mecanismos de reputação (scores, reviews), (2) garantias e seguros, (3) verificação de identidade, (4) transparência de processo. Mayer/Davis/Schoorman (1995): confiança = f(ability, benevolence, integrity). Cada dimensão pode ser construída e comunicada separadamente. Plataformas AI-native adicionam um desafio: o agente é opaco para o participante — confiança requer que o participante confie tanto na plataforma quanto no agente que opera dentro dela."
		meshManifestation: "Na Mesh como plataforma bilateral (compradores e fornecedores) operada por agentes IA: confiança é o ativo central. Fornecedor confia que: antecipação será paga (ability), Mesh não explora assimetria (benevolence), scoring é justo (integrity). Comprador confia que: fornecedores são qualificados (ability), Mesh não favorece indevidamente (benevolence), dados de performance são precisos (integrity). Regulador confia que: operações são lícitas (ability), Mesh não facilita fraude (benevolence), governance é real não cosmética (integrity). Cada dimensão requer sinais diferentes."
		meshImplication: "Mapear confiança por stakeholder e por dimensão (ability, benevolence, integrity): Para cada célula: que sinal a Mesh emite? É custoso ou cheap talk? É verificável? Para fornecedor: ability → histórico de pagamentos no prazo. Benevolence → taxas publicadas sem condições ocultas. Integrity → score transparente com explicação. Para comprador: ability → fornecedores validados com compliance verificado. Benevolence → não vender dados de performance para competidores. Integrity → benchmark anônimo e auditável. Investir em mecanismos de confiança acumulativa: reputação verificável que cresce com uso (conecta com network-theory). Cada operação bem-sucedida é depósito no 'banco de confiança' — mas cada falha é withdrawal desproporcional."
		dependsOn: ["sc-signaling-theory", "sc-verifiable-claims"]
		crossDependsOn: [{
			lensId:    "lens-platform-dynamics"
			conceptId: "pd-trust-and-safety"
			context:   "PD modela trust & safety como propriedade emergente de plataformas bilaterais. SC operacionaliza como construir e comunicar confiança com cada lado. PD pergunta 'que mecanismos de trust a plataforma precisa'; SC pergunta 'como comunicar e sinalizar essa trustworthiness'."
		}]
		rationale: "Botsman 2017: confiança distribuída. Mayer et al. 1995: ability + benevolence + integrity. Na Mesh como plataforma AI-native, confiança é o ativo mais valioso e mais frágil — requer construção ativa em cada dimensão para cada stakeholder."
	},
	{
		id:         "sc-strategic-silence"
		name:       "Silêncio Estratégico: Quando Não Comunicar é Superior"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Dye (1985, 'Disclosure of Nonproprietary Information'): em equilíbrio, silêncio é interpretado negativamente pelo receptor (se fosse boa notícia, teria revelado). Mas Dye também mostra que quando o receptor não sabe se o sender tem informação, silêncio é ambíguo — não necessariamente negativo. Nagar (1999): disclosure tem custos proprietários (competidor aprende) que justificam silêncio mesmo com boa notícia. Beyer et al. (2010): em mercados de capitais, empresas gerenciam strategicamente o timing de disclosure para maximizar impacto. Em comunicação organizacional: falar prematuramente sobre algo incerto gera expectativa que pode não se materializar. Falar sobre fraqueza sem plano de remediação gera ansiedade sem resolução. Responder a cada crítica pública amplifica a crítica."
		meshManifestation: "Na Mesh: anunciar 'estamos buscando SCD' antes de ter certeza de que vai conseguir gera expectativa com regulador e investidor — se não materializar, é under-delivery. Melhor: silêncio sobre SCD até ter progresso concreto, depois comunicar com evidência. Responder a cada comentário negativo sobre 'IA em crédito' em fóruns amplifica a associação. Melhor: deixar resultados falarem e comunicar proativamente quando tiver evidência. Anunciar features em desenvolvimento antes de validar cria expectativa no fornecedor que compete com features que já funcionam."
		meshImplication: "Antes de comunicar, testar: (1) A comunicação muda a decisão do receptor em direção favorável? Se não: silêncio. (2) O receptor espera essa informação? Se não espera e informação é ambígua: silêncio. (3) Tenho evidência ou plano para back a comunicação? Se não: silêncio até ter. (4) A comunicação pode ser amplificada em direção desfavorável? Se sim: avaliar custo de amplificação vs benefício de comunicar. Contextos de silêncio estratégico: features não-validadas, processos regulatórios em andamento, conversas com potenciais parceiros não-fechados, problemas operacionais com remediação em curso. Contextos onde silêncio é perigoso: incidente que afeta stakeholders (regulador/fornecedor) — silêncio é interpretado como cover-up."
		dependsOn: ["sc-bayesian-persuasion", "sc-expectation-management"]
		rationale: "Dye 1985: silêncio é interpretado no contexto. Nagar 1999: custos proprietários justificam silêncio. Beyer et al. 2010: timing de disclosure é gerenciável. Na Mesh, falar prematuramente é tão perigoso quanto calar quando deveria falar — a calibração requer julgamento sobre o que o receptor espera e como interpretará silêncio."
	},
	{
		id:         "sc-crisis-communication"
		name:       "Comunicação de Crise: Quando Algo Dá Errado"
		nature:     "theoretical"
		role:       "method"
		definition: "Coombs (2007, 'Protecting Organization Reputations During a Crisis — SCCT'): Situational Crisis Communication Theory — a resposta à crise deve ser proporcional à responsabilidade percebida. Quanto maior a percepção de culpa, mais forte deve ser a resposta (pedido de desculpas, compensação). Benoit (1997, 'Image Repair Theory'): estratégias vão de negação (contra-produtiva se culpa é real) a ação corretiva (mais eficaz). Weick/Sutcliffe (2015, Managing the Unexpected): organizações resilientes se recuperam rápido porque (1) reconhecem cedo, (2) contêm rápido, (3) comunicam transparentemente, (4) aprendem. Princípio universal: surpresa negativa destrói mais confiança que a mesma informação antecipada."
		meshManifestation: "Na Mesh, crises potenciais incluem: (1) scoring falha — operação aprovada resulta em default significativo. (2) agente aprova antecipação fora dos limites (blast radius breach). (3) dados de fornecedores vazam. (4) regulador questiona operação. (5) anchor tenant sai da plataforma. Cada crise tem stakeholders afetados, responsabilidade percebida e janela de comunicação. Crise não-comunicada: stakeholder descobre por terceiros — confiança destruída. Crise comunicada com atraso: percepção de cover-up. Crise comunicada proativamente com plano: confiança preservada ou até fortalecida."
		meshImplication: "Para cada crise: (1) Reconhecer — internamente, em horas, não dias. (2) Conter — ativar blast radius containment (AAG). (3) Comunicar — proativamente aos stakeholders afetados antes que descubram por terceiros. Template: o que aconteceu (fatos, não especulação) + o que fizemos imediatamente (contenção) + o que vamos fazer (plano de remediação com timeline) + o que mudamos para não recorrer (melhoria sistêmica). (4) Cumprir — executar o plano comunicado (commitment credibility). (5) Reportar — após remediação, comunicar resultado e mudança implementada. Anti-patterns: negar culpa quando há culpa real. Minimizar impacto quando stakeholder sofreu. Culpar terceiro quando causa é interna. Prometer sem plano. Comunicar sem fatos."
		dependsOn: ["sc-commitment-credibility", "sc-expectation-management"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-blast-radius-containment"
			context:   "AAG contém o dano operacional da crise (blast radius). SC governa como comunicar a crise aos stakeholders após a contenção. AAG é a resposta operacional; SC é a resposta comunicacional. Ambas devem ser coordenadas — comunicar antes de conter é prematuro; conter sem comunicar é insuficiente."
		}]
		rationale: "Coombs 2007: resposta proporcional à culpa percebida. Weick/Sutcliffe 2015: reconhecer cedo, conter rápido, comunicar transparentemente. Na Mesh, crise é inevitável em sistema complexo — a variável é a qualidade da resposta, não a ausência de crise."
	},
	{
		id:         "sc-trust-accumulation"
		name:       "Acúmulo de Confiança: Ativo Assimétrico"
		nature:     "theoretical"
		role:       "property"
		definition: "Luhmann (1979): confiança é mecanismo de redução de complexidade — permite agir sob incerteza com base em expectativas sobre o comportamento do outro. Dasgupta (1988): confiança acumula lentamente (cada interação positiva deposita) e depleta rapidamente (uma interação negativa retira desproporcionalmente). Kramer (1999): confiança em organizações é baseada em histórico (track record), categoria (pertence a grupo confiável), e papel (ocupa posição que implica confiabilidade). Assimetria fundamental: construir confiança leva anos de consistência; destruir leva um incidente."
		meshManifestation: "Na Mesh: confiança do fornecedor acumula a cada antecipação paga no prazo, a cada comunicação consistente, a cada taxa conforme prometida. 50 operações sem problema constroem base. 1 atraso significativo de pagamento pode destruir a base e trigger saída do fornecedor (e narrativa negativa no setor). Com regulador: meses de reporting consistente e governance demonstrada constroem goodwill. 1 incidente não-comunicado pode zerar o goodwill e acionar fiscalização. Com investidor: quarters consistentes de tração build credibilidade. 1 miss significativo sem explanation destrói confiança em projeções futuras."
		meshImplication: "Tratar confiança como ativo no balanço — não financeiro, mas estratégico. Cada interação com stakeholder é depósito ou withdrawal. Implicações: (1) Consistência > brilhantismo — 10 entregas boas > 5 boas + 5 ruins + 1 excepcional. (2) Surpresa negativa é o maior destruidor — comunicar proativamente antes de surpresa. (3) Early-stage: banco de confiança é pequeno — cada interação pesa desproporcionalmente. Erro na 5ª operação é pior que erro na 500ª (em termos de % do banco de confiança). (4) Investir em consistência: processos que garantem que o mínimo prometido é sempre entregue — mesmo que o máximo varie. (5) Recovery: após withdrawal, over-delivery imediata e sustentada é o único mecanismo de reconstrução."
		dependsOn: ["sc-signaling-theory", "sc-commitment-credibility"]
		rationale: "Luhmann 1979: confiança reduz complexidade. Dasgupta 1988: acúmulo lento, depleção rápida. Na Mesh early-stage, banco de confiança é pequeno — cada interação é material. Consistência é mais valiosa que brilhantismo."
	},
	{
		id:         "sc-regulatory-communication-protocol"
		name:       "Protocolo de Comunicação Regulatória"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Carpenter (2010, Reputation and Power — FDA): reguladores valorizam organizações que: (1) são proativas (comunicam antes de serem perguntadas), (2) demonstram competência técnica (falam a linguagem do regulador), (3) são consistentes (não mudam narrativa), (4) são transparentes sobre limitações (não vendem capacidade que não têm). Black (2001, 'Decentring Regulation'): regulação é relação, não imposição unilateral — regulador e regulado co-constroem o regime regulatório. A comunicação com regulador é investimento em relação de longo prazo, não compliance transacional."
		meshManifestation: "Na Mesh, reguladores relevantes: Bacen (SCD/SEP/correspondente), CVM (FIDC), Receita Federal (tributário). Cada regulador tem cultura, linguagem e expectativas diferentes. Bacen valoriza rigor técnico, documentação formal, e proatividade. Bacen está ativamente monitorando AI em serviços financeiros — a Mesh pode ser proativa em demonstrar governance. CVM para FIDC: foco em lastro, segregação, e proteção ao cotista. A Mesh comunicando proativamente seu framework de AI governance ao Bacen antes de ser exigido é sinal custoso (investimento antecipado) que constrói credibilidade."
		meshImplication: "Para cada regulador: (1) Mapear expectativas e linguagem. (2) Construir cadência de comunicação proativa — não esperar ser perguntado. (3) Preparar artefatos na linguagem do regulador (não na linguagem interna). (4) Demonstrar governance as code: mostrar que políticas são versionadas, testáveis, auditáveis. (5) Ser transparente sobre limitações: 'nosso scoring tem AUROC 0.72, que é limitação reconhecida — aqui está o plano de evolução' é mais crível que 'nosso scoring é robusto'. (6) Manter interlocutor consistente — regulador constrói relação com pessoa, não com organização abstrata. (7) Documentar toda interação com regulador: data, conteúdo, compromissos assumidos, follow-ups. Para agentes: nenhuma comunicação com regulador sem aprovação humana — sempre tipo 2+ na precedence hierarchy."
		dependsOn: ["sc-signaling-theory", "sc-transparency-calibration", "sc-trust-accumulation"]
		crossDependsOn: [{
			lensId:    "lens-regulatory-strategy"
			conceptId: "rs-regulatory-relationship"
			context:   "RS define a estratégia regulatória (quais licenças, em que ordem, com que argumentos). SC governa como comunicar essa estratégia ao regulador — tom, cadência, formato, linguagem. RS é o 'o que'; SC é o 'como comunicar'."
		}]
		rationale: "Carpenter 2010: reguladores valorizam proatividade, competência e consistência. Black 2001: regulação é relação. Na Mesh, a relação com Bacen é o ativo regulatório mais importante — construída por comunicação, não por compliance passivo."
	},
	{
		id:            "sc-communication-review"
		name:          "Revisão de Comunicação: Inventário Periódico de Stakeholders e Sinais"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) mapa de stakeholders ativos e prioridade, (2) sinais emitidos — custosos vs cheap talk, (3) narrativa core — consistente ou derivando?, (4) expectativas pendentes — algum compromisso próximo de vencer?, (5) banco de confiança por stakeholder — depósitos e withdrawals no período, (6) mapa de transparência — alguma dimensão precisa mudar?, (7) incidentes comunicacionais — over-promise, surpresa negativa, silêncio quando deveria falar."
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (compromissos pendentes, expectativas de investidor/regulador, feedback de fornecedores). Trimestral: macro-revisão com mapa completo."
		meshImplication: "Mensal (1h): compromissos com deadline no próximo trimestre — estamos no caminho? Feedback de fornecedores — confiança acumulando ou depletando? Comunicações com regulador — follow-ups pendentes? Trimestral (2h): inventário completo. Narrativa core ainda é a mesma? Sinais emitidos são custosos ou estamos em cheap talk? Mapa de transparência precisa atualizar (algo que era protegido agora pode ser revelado)? Algum stakeholder negligenciado? Se a revisão não identifica pelo menos um gap ou oportunidade de comunicação: ou a comunicação está perfeita (improvável) ou a revisão é superficial."
		dependsOn: ["sc-signaling-theory", "sc-trust-accumulation", "sc-commitment-credibility", "sc-transparency-calibration"]
		rationale: "Sem revisão periódica, comunicação com stakeholders é reativa e ad hoc. O inventário periódico torna comunicação estratégica — proativa, consistente e calibrada."
	},
]

reasoningProtocol: [
	{
		question:  "Quem é o stakeholder? Qual é o schema dessa audiência — que categorias usa para processar informação?"
		reveals:   "Se a comunicação está enquadrada no schema do receptor ou no schema do emissor. Investidor, regulador, fornecedor e comprador processam informação de formas radicalmente diferentes."
		rationale: "Tversky/Kahneman 1981: frame afeta decisão. Fiske/Taylor 2013: processamento é schema-driven."
	},
	{
		question:  "Que informação privada o stakeholder quer verificar? Qual é a assimetria de informação relevante?"
		reveals:   "O que o stakeholder não sabe e gostaria de saber. Toda comunicação eficaz reduz assimetria relevante — não qualquer assimetria."
		rationale: "Spence 1973: signaling resolve assimetria específica. Comunicar informação irrelevante é noise, não signal."
	},
	{
		question:  "O sinal que estou emitindo é custoso ou é cheap talk? Competidor de baixa qualidade poderia emitir o mesmo sinal?"
		reveals:   "Se a comunicação é crível ou será descontada pelo receptor. Cheap talk é racionalmente descontado."
		rationale: "Crawford/Sobel 1982: cheap talk com interesses divergentes não é crível. Sinais custosos são."
	},
	{
		question:  "Quais são os priors do receptor? Que estrutura de disclosure move os priors na direção correta?"
		reveals:   "Se a informação revelada calibra ou distorce a crença do receptor. Informação sem contexto pode mover priors na direção errada."
		rationale: "Kamenica/Gentzkow 2011: poder está na estrutura da informação, não no conteúdo."
	},
	{
		question:  "O compromisso é verificável, custoso de quebrar, e com mecanismo de enforcement? Ou é promessa verbal?"
		reveals:   "Se o compromisso é crível. Hierarquia: verificável + irreversível + público > promessa verbal."
		rationale: "Schelling 1960: credibilidade = custo de quebrar. Promessa sem custo é descontada."
	},
	{
		question:  "As expectativas que estou criando são calibradas? Consigo entregar consistentemente acima delas?"
		reveals:   "Se há risco de over-promise/under-deliver. Satisfação = performance − expectativa."
		rationale: "Oliver 1980: satisfação é relativa à expectativa. Under-promise + over-deliver > over-promise + under-deliver."
	},
	{
		question:  "Quanto revelar vs quanto proteger? A calibração de transparência é adequada para este stakeholder e esta dimensão?"
		reveals:   "Se transparência é calibrada ou se está no extremo (revelar tudo / proteger tudo) — ambos sub-ótimos."
		rationale: "Heald 2006: transparência é multidimensional. Etzioni 2010: excessiva tem custos. Calibrar por audiência e dimensão."
	},
	{
		question:  "Deveria comunicar agora ou o silêncio é estrategicamente superior? Tenho evidência para back a comunicação?"
		reveals:   "Se comunicar prematuramente cria expectativa que não pode ser cumprida, ou se silêncio será interpretado negativamente."
		appliesWhen: "informação é incerta, parcial ou potencialmente amplificável em direção desfavorável"
		rationale: "Dye 1985: silêncio é interpretado no contexto. Nagar 1999: custos proprietários justificam silêncio. Comunicar sem evidência é cheap talk."
	},
	{
		question:  "Se é situação de crise: os stakeholders afetados sabem antes de descobrir por terceiros? A comunicação inclui fatos + contenção + plano + melhoria?"
		reveals:   "Se a crise está sendo gerenciada comunicacionalmente ou se há risco de surpresa negativa e percepção de cover-up."
		appliesWhen: "incidente, falha, ou surpresa negativa que afeta stakeholders"
		rationale: "Coombs 2007: resposta proporcional. Weick/Sutcliffe 2015: reconhecer cedo, comunicar transparentemente. Surpresa negativa destrói confiança desproporcionalmente."
	},
	{
		question:  "O claim é verificável pelo receptor sem depender da Mesh? Existe infraestrutura de verificabilidade (dashboard, audit trail, API)?"
		reveals:   "Se a comunicação é backed por evidência verificável ou é apenas declaração. Claims não-verificáveis degradam credibilidade acumulativamente."
		rationale: "Botsman 2017: confiança distribuída baseada em evidência. O'Hara 2012: transparência verificável > confiança declarada."
	},
	{
		question:  "Esta comunicação é consistente com a narrativa core e com comunicações anteriores a este e outros stakeholders?"
		reveals:   "Se há risco de contradição entre frames (mesma realidade, audiências diferentes) ou de inconsistência temporal (prometeu X antes, agora diz Y)."
		rationale: "Shiller 2019: narrativa é contagious — inconsistência é detectada e amplificada. Frames diferentes devem ser consistentes entre si."
	},
]

meshExamples: [
	{
		id:       "ex-investor-pitch-signaling"
		scenario: "Mesh prepara pitch para investidores seed. Tem 3 anchor tenants validados, scoring AUROC 0.72, 150 operações, governance codificada em mesh-spec. Ainda pré-revenue."
		analysis: "Priors do investidor: 'fintech early-stage com IA = risco alto, muitas promessas, poucas entregas'. Assimetria: investidor não sabe se tração é real, se scoring funciona, se team executa. Sinais custosos disponíveis: 3 anchors nomeáveis (verificável), 150 operações (dados), AUROC 0.72 (métrica técnica), mesh-spec no GitHub (governance verificável). Cheap talk a evitar: 'vamos revolucionar a construção civil', 'nosso AI é state-of-the-art', 'mercado de R$X trilhões'."
		recommendation: "Estrutura do pitch — bayesian persuasion: abrir com tração (sinal custoso que move priors imediatamente), não com visão (cheap talk). Sequência: (1) Problema concreto com dados — construtora X paga Y% de taxa por antecipação porque banco não vê operação. (2) Tração — 3 anchors, 150 operações, R$Z antecipados. (3) Como funciona — scoring + governance (diferenciar de 'mais uma fintech'). (4) Moat — dados operacionais que acumulam, não copiaveis. (5) Ask — quanto, para quê, milestones verificáveis. Narrativa core: 'banco B2B nativo de supply chain'. Expectation management: projeção conservadora como base case, stretch case separado. Claims verificáveis: oferecer acesso ao mesh-spec e dashboard de operações."
		principlesApplied: ["ax-01", "ax-07"]
		assumptions: [
			"3 anchor tenants estão dispostos a ser nomeados — verificar",
			"AUROC 0.72 é benchmark aceitável para o segmento — contextualizar",
			"investidores seed em fintech valorizam tração sobre visão — depende do perfil do fundo",
			"mesh-spec no GitHub é diferenciador compreensível para investidor — pode precisar traduzir",
		]
		rationale: "Spence 1973: sinais custosos. Kamenica/Gentzkow 2011: estrutura de disclosure. Abrir com tração move priors mais que abrir com visão. Claims verificáveis são superiores a claims declaradas."
	},
	{
		id:       "ex-regulator-proactive-governance"
		scenario: "Mesh opera como correspondente bancário e quer demonstrar proativamente ao Bacen que AI governance é robusta — antes de ser questionada. Objetivo: construir goodwill regulatório."
		analysis: "Priors do Bacen: 'AI em crédito = caixa preta, risco de discriminação, risco sistêmico, risco de compliance'. Sinal custoso: demonstrar governance codificada (investimento real em compliance antes de obrigação). Oportunidade de bayesian persuasion: revelar o framework de governance estruturadamente para mover priors de 'caixa preta' para 'sistema governado'. Risco: revelar demais sobre modelo de scoring pode gerar questionamentos que a Mesh não está preparada para responder. Calibrar transparência: governance sim, detalhes proprietários de modelo não (exceto se perguntado)."
		recommendation: "(1) Preparar documento técnico na linguagem do Bacen (não na linguagem interna): 'Framework de Governança de Agentes de IA na Mesh — Relatório Voluntário'. (2) Conteúdo: fronteiras de autonomia codificadas, escalation protocol, observability contract, drift detection, audit trail, lifecycle de capabilities, human-in-the-loop. Cada seção com evidência verificável (links para artefatos no repositório). (3) Tom: técnico, sóbrio, transparente sobre limitações ('AUROC 0.72 é limitação reconhecida — plano de evolução: acumular dados operacionais, recalibrar trimestralmente'). (4) Canal: solicitar reunião técnica com área de inovação do Bacen. (5) Follow-up: enviar relatório periódico voluntário (trimestral) com evolução das métricas e mudanças em policies. (6) Não mencionar: roadmap especulativo, SCD como plano (silêncio estratégico até ter progresso concreto)."
		principlesApplied: ["ax-03", "ax-05", "ax-07"]
		assumptions: [
			"Bacen tem área de inovação receptiva a interlocução voluntária — verificar canal correto",
			"documento técnico voluntário é percebido positivamente (não como admissão de risco) — calibrar tom",
			"mesh-spec é apresentável para regulador sem exposição de IP competitivo — revisar conteúdo",
		]
		rationale: "Carpenter 2010: reguladores valorizam proatividade. Sinal custoso: investimento em governance antes de obrigação. Bayesian persuasion: mover priors de 'caixa preta' para 'sistema governado' com evidência estruturada."
	},
	{
		id:       "ex-crisis-scoring-failure"
		scenario: "Agente de scoring aprova antecipação de R$200k para fornecedor cujo comprador entra em recuperação judicial 2 semanas depois. Fornecedor impactado. Investidor informado de que scoring é 'robusto'."
		analysis: "Crise com múltiplos stakeholders afetados: (1) fornecedor — perda financeira potencial, confiança na plataforma abalada. (2) investidor — narrativa de 'scoring robusto' desafiada. (3) regulador — se tomar conhecimento, questiona governança. Responsabilidade da Mesh: scoring não previu (limitação real do modelo, não negligência). Blast radius: R$200k (contido pelos caps de AAG). Banco de confiança: fornecedor é early adopter com 15 operações anteriores sem problema. Investidor informado recentemente de AUROC 0.72. Risco máximo: fornecedor sai + investidor perde confiança + regulador questiona. Risco mínimo: transparência + remediação preserva todos."
		recommendation: "Fornecedor (24h): comunicar proativamente. Template: 'Identificamos que [comprador] entrou em recuperação judicial. Situação da sua antecipação: [status]. Medidas imediatas: [contenção — bloqueio de novas operações com este comprador, ativação de coobrigação se aplicável]. Plano: [timeline de resolução]. Mudança sistêmica: [recalibração de scoring para incorporar indicadores de judicial recovery].' Tom: factual, empático, com plano. Investidor (48h): comunicar na próxima interação regular (não esperar que pergunte). Frame: 'Um caso de default de R$200k em comprador que entrou em RJ. Contenção funcionou (cap operava). Scoring não previu — limitação reconhecida, plano de recalibração em andamento. Tax de default acumulada: X% — dentro do esperado para segmento. Uma operação, não padrão.' Regulador: não comunicar proativamente este caso individual (volume não-sistêmico). Documentar internamente com trilha completa. Se perguntado: demonstrar que governance funcionou (blast radius contido, trilha completa, remediação em curso). Internamente: post-mortem — scoring deveria ter capturado? Quais sinais antecedentes existiam? Incorporar no modelo."
		principlesApplied: ["ax-01", "ax-05", "dp-01"]
		assumptions: [
			"coobrigação é aplicável neste caso — verificar estrutura jurídica da operação",
			"R$200k é volume não-sistêmico que não requer comunicação proativa ao regulador — verificar thresholds",
			"investidor preferirá transparência a descoberta tardia — verdade para maioria dos investidores sérios",
			"fornecedor early adopter com 15 operações tem banco de confiança suficiente para absorver o impacto com comunicação adequada",
		]
		rationale: "Coombs 2007: resposta proporcional. Dasgupta 1988: confiança depleta rápido com surpresa negativa. Comunicar proativamente com plano é superior a esperar que stakeholder descubra. Frame para investidor: incidente, não padrão."
	},
	{
		id:       "ex-silence-scd-process"
		scenario: "Mesh iniciou conversas exploratórias com advogado sobre viabilidade de SCD. Nenhum processo formal aberto. Investidor pergunta sobre planos regulatórios no próximo check-in."
		analysis: "Silêncio estratégico vs disclosure. Comunicar 'estamos buscando SCD': cria expectativa com investidor (milestone esperado), mas processo é incerto (aprovação Bacen é imprevisível). Se não materializar: under-delivery. Se materializar após muito tempo: expectativa desnecessariamente longa. Comunicar que advogado foi contratado: sinal custoso (dinheiro gasto), mas prematuro (conversas exploratórias ≠ decisão). Risco adicional: investidor comunica a terceiros, informação vaza, regulador questiona antes de a Mesh estar preparada."
		recommendation: "Resposta calibrada: 'Estamos estruturando nossa estratégia regulatória de forma faseada. Atualmente operamos via correspondente bancário. Estamos avaliando caminhos de evolução regulatória — quando tivermos uma decisão concreta com timeline, compartilhamos.' Não mentir (está avaliando). Não prometer (não disse SCD). Não criar expectativa (sem timeline). Sinal de competência: 'estratégia regulatória faseada' demonstra que há pensamento estruturado. Se investidor pressionar por especificidade: 'as opções incluem SCD, SEP e evolução do correspondente. Cada uma tem trade-offs de timeline, custo e flexibilidade. Vamos decidir com base em dados do piloto.' Frame: decisão racional, não promessa. Silêncio parcial: detalhes específicos (advogado contratado, conversas com Bacen) ficam protegidos até serem fatos concretos."
		principlesApplied: ["ax-01", "ax-05"]
		assumptions: [
			"investidor aceita resposta calibrada sem interpretar como evasão — depende da relação",
			"mencionar SCD como opção não cria expectativa excessiva se enquadrado entre alternativas",
			"informação sobre processo regulatório tem custo proprietário se vaza — justifica proteção",
		]
		rationale: "Dye 1985: silêncio é aceitável quando receptor não sabe se sender tem informação conclusiva. Nagar 1999: custo proprietário justifica. Comunicar parcialmente (há estratégia) sem comprometer (sem SCD prometido) é calibração ótima entre silêncio total (interpretado negativamente) e disclosure completo (cria expectativa)."
	},
]

principleIds: ["ax-01", "ax-03", "ax-05", "ax-07", "dp-01", "dp-05"]

relatedLenses: [
	{
		lensId:   "lens-information-economics"
		relation: "complementsWith"
		context:  "IE modela assimetria de informação como propriedade econômica — valor de informação, adverse selection, moral hazard. SC operacionaliza a redução estratégica dessa assimetria via signaling, disclosure e framing. IE pergunta 'onde está a assimetria e qual o custo'; SC pergunta 'como reduzí-la credivelmente para cada stakeholder'."
	},
	{
		lensId:   "lens-regulatory-strategy"
		relation: "complementsWith"
		context:  "RS define a estratégia regulatória substantiva — quais licenças, requisitos, timeline. SC governa como comunicar essa estratégia ao regulador — tom, cadência, formato, framing. RS é o conteúdo regulatório; SC é a comunicação regulatória. Sobreposição: sc-regulatory-communication-protocol operacionaliza a comunicação que RS define como necessária."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG implementa governance interna de agentes — audit trail, blast radius, observability. SC usa esses artefatos como infraestrutura de claims verificáveis para stakeholders externos. AAG constrói a evidência; SC a comunica. Sobreposição: sc-verifiable-claims depende de aag-audit-trail e aag-observability-contract como fonte de evidência."
	},
	{
		lensId:   "lens-game-theory-applied"
		relation: "complementsWith"
		context:  "GT modela commitment devices e jogos repetidos como mecanismos de credibilidade. SC operacionaliza como construir e comunicar compromissos críveis em contextos específicos (investidor, regulador, parceiro). GT é a teoria; SC é a aplicação em comunicação com stakeholders."
	},
	{
		lensId:   "lens-behavioral-economics"
		relation: "complementsWith"
		context:  "BE diagnostica vieses cognitivos que afetam como stakeholders processam comunicação — framing effects, anchoring, loss aversion, availability bias. SC incorpora esses vieses no design da comunicação — framing por audiência, expectation management (loss aversion), sequência de disclosure (anchoring)."
	},
	{
		lensId:   "lens-platform-dynamics"
		relation: "complementsWith"
		context:  "PD modela dinâmicas de plataforma bilateral — chicken-and-egg, trust & safety, network effects. SC governa como comunicar com cada lado da plataforma para construir confiança e atrair adoção. PD define os mecanismos; SC define a comunicação que suporta esses mecanismos."
	},
	{
		lensId:   "lens-mechanism-design"
		relation: "complementsWith"
		context:  "MD desenha mecanismos de incentivo (scoring, pricing, matching). SC comunica esses mecanismos aos participantes de forma que gere confiança e adoção. MD é o mecanismo; SC é como o mecanismo é comunicado e percebido."
	},
]

limitations: [
	{
		description: "Framework assume que stakeholders são racionais bayesianos que atualizam crenças com informação. Na prática, vieses cognitivos (confirmation bias, availability heuristic) distorcem processamento. Framing perfeito não garante atualização correta."
		alternative: "Combinar com behavioral-economics para antecipar como vieses distorcem recepção. Testar comunicação com representantes da audiência antes de emitir em escala."
		rationale: "Kamenica/Gentzkow 2011 assume receptor bayesiano. Na prática, racionalidade é limitada — framework é heurística, não garantia."
	},
	{
		description: "Signaling theory assume que sinais custosos são inimitáveis. Na prática, competidores podem imitar sinais (copiar governance framework, fabricar métricas). O receptor pode não distinguir sinal genuíno de imitação."
		alternative: "Investir em sinais que são difíceis de imitar sem a capacidade subjacente — ex: tração real com anchor tenants é difícil de fabricar. Dashboard com dados reais verificáveis é difícil de falsificar. Combinar múltiplos sinais independentes."
		rationale: "Connelly et al. 2011: sinal eficaz requer correlação com qualidade. Sinais que podem ser emitidos sem qualidade perdem valor."
	},
	{
		description: "Framework foca em comunicação one-to-one ou one-to-few (investidor específico, regulador específico). Comunicação one-to-many (mercado, mídia, ecossistema) tem dinâmicas adicionais — amplificação, distorção, viralidade — não plenamente cobertas."
		alternative: "Para comunicação pública em escala: complementar com expertise em PR/comunicação institucional. Princípios de signaling e framing aplicam-se mas execução requer competências diferentes."
		rationale: "Comunicação pública amplifica tanto sinais quanto ruído. Framework é insuficiente para gestão de narrativa em escala mediática."
	},
	{
		description: "Calibração de transparência é julgamento — não existe fórmula. O mapa de transparência é heurística, não algoritmo. Erro de calibração (revelar demais ou de menos) é provável e só detectável ex post."
		alternative: "Começar conservador (proteger) e expandir transparência incrementalmente com feedback. Cada expansão é experiment — observar reação e ajustar."
		rationale: "Heald 2006: calibração é contextual. Sem fórmula, a melhor defesa é incrementalismo e observação da reação."
	},
	{
		description: "Não cobre comunicação interna (entre áreas, entre founder e equipe futura). Foca em stakeholders externos. Comunicação interna tem dinâmicas diferentes — menos assimetria, mais frequência, cultura organizacional como variável."
		alternative: "Para comunicação interna: usar organizational-economics (alinhamento de incentivos) e este framework como inspiração, mas adaptar para contexto de menor assimetria e maior frequência."
		rationale: "Comunicação interna é canal diferente com dinâmicas diferentes. Framework é calibrado para assimetria alta (externo), não para assimetria baixa (interno)."
	},
]

rationale: "Toda organização opera num ecossistema de stakeholders que não têm acesso à informação interna. A forma como a organização comunica — o que revela, o que omite, como enquadra, quando fala e quando cala — é determinante para acesso a capital, permissão de operar, acesso a mercado e reputação. Esta lens operacionaliza: signaling com sinais custosos (Spence 1973), disclosure ótimo via persuasão bayesiana (Kamenica/Gentzkow 2011), framing por audiência (Tversky/Kahneman 1981), narrativa como força econômica (Shiller 2019), credibilidade de compromissos (Schelling 1960), claims verificáveis sobre confiança declarada (Botsman 2017, O'Hara 2012), gestão de expectativas via prospect theory (Kahneman/Tversky 1979), calibração de transparência (Heald 2006), arquitetura de confiança de plataforma (Botsman 2017, Mayer et al. 1995), silêncio estratégico (Dye 1985, Beyer et al. 2010), comunicação de crise (Coombs 2007), acúmulo assimétrico de confiança (Dasgupta 1988), e protocolo regulatório (Carpenter 2010). Universal, agnóstica a estágio, aplicável a qualquer organização que opera com stakeholders externos."

}
