package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

coldStartAndNetworkBootstrapping: artifact_schemas.#AnalyticalLens & {
	id:     "lens-cold-start-and-network-bootstrapping"
	name:   "Cold Start e Bootstrapping de Rede"

	purpose: "Orientar decisões sobre como resolver o cold start problem — bootstrap de rede quando não há participantes, dados nem transações."
	status: "draft"

	trigger: {
		conditions: [
			"a decisão envolve como atrair os primeiros participantes para uma plataforma que ainda não tem rede",
			"a decisão envolve qual side da plataforma atrair primeiro (chicken-and-egg)",
			"a decisão envolve como criar valor para early adopters antes de network effects operarem",
			"a decisão envolve como selecionar e conquistar anchor tenants que trazem a rede",
			"a decisão envolve como projetar incentivos para bootstrap que não distorcem economia de longo prazo",
			"a decisão envolve como transicionar de crescimento manual (founder-led) para crescimento orgânico (network-driven)",
			"a decisão envolve como medir se network effects estão começando a operar",
			"a decisão envolve como evitar negative network effects durante crescimento inicial (qualidade vs quantidade)",
			"a decisão envolve como sequenciar expansão (vertical antes de horizontal, nicho antes de generalizar)",
			"a decisão envolve como manter engajamento de early adopters enquanto rede ainda é pequena",
		]
		keywords: [
			"cold start", "bootstrap", "bootstrapping", "chicken-and-egg",
			"primeiro usuário", "first user", "early adopter",
			"anchor tenant", "seed user", "lead customer",
			"rede", "network", "efeito de rede", "network effect",
			"crescimento", "growth", "tração", "traction",
			"subsídio", "subsidy", "incentivo", "freemium",
			"hard side", "easy side", "single-player mode",
			"nicho", "niche", "vertical", "beachhead",
			"viralidade", "viral", "referral", "word-of-mouth",
			"atomic network", "rede atômica", "mínimo viável",
			"onboarding", "ativação", "activation",
			"supply", "demand", "marketplace",
			"go-to-market", "GTM", "launch", "lançamento",
		]
		excludeWhen: [
			"a decisão é sobre network effects como dinâmica econômica em estado estável — usar platform-dynamics",
			"a decisão é sobre UX de plataforma multisided em operação — usar multi-sided-platform-ux",
			"a decisão é sobre cold start de dados para scoring — usar data-quality-as-competitive-moat (dq-cold-start-strategy)",
			"a decisão é sobre pricing e monetização em estado estável — usar pricing-and-monetization-architecture",
			"a decisão é sobre onboarding de usuário individual — usar jobs-to-be-done-and-workflow-design",
		]
		rationale: "Toda plataforma multisided enfrenta o chicken-and-egg problem: side A não vem sem side B, side B não vem sem side A. Cold start é o período mais vulnerável — sem rede, sem dados, sem social proof, sem revenue. A maioria das plataformas morre no cold start, não na competição. Na Mesh como plataforma B2B com fornecedores, construtoras e FIDC, o cold start é triplo: fornecedor não vem sem construtora, construtora não vem sem fornecedores qualificados, FIDC não financia sem operações. Platform-dynamics cobre dinâmicas de rede em estado estável; DQ cold start cobre dados para scoring; JTBD cobre onboarding individual. Esta lens cobre a estratégia de bootstrap da rede inteira — quem atrair primeiro, como criar valor antes de rede existir, como transicionar de manual para orgânico, e como medir que o cold start terminou."
	}

	concepts: [
		{
			id:         "cs-chicken-and-egg"
			name:       "Chicken-and-Egg: Entender a Interdependência para Quebrá-la"
			nature:     "theoretical"
			role:       "framework"
			definition: "Caillaud/Jullien (2003, 'Chicken & Egg: Competition Among Intermediation Service Providers'): em plataformas multisided, valor de cada side depende da presença do outro — criando impasse. Estratégias de resolução: (1) subsidize one side — atrair um side com custo abaixo do mercado ou gratuito, monetizar o outro. (2) marquee user — atrair participante de alto perfil que atrai os demais por reputação. (3) single-player value — oferecer valor standalone que não depende de rede (side usa mesmo sozinho, rede é bônus). (4) sequential entry — atrair sides em sequência, não simultaneamente. Chen (2022, The Cold Start Problem): framework de 5 estágios — (1) the cold start problem (identificar hard side), (2) tipping point (rede atômica começa a funcionar), (3) escape velocity (network effects impulsionam crescimento), (4) hitting the ceiling (crescimento desacelera), (5) the moat (defensibilidade). Conceito contemporâneo de 'atomic network' (Chen 2022): a menor rede que funciona — o mínimo de participantes de cada side necessários para que a interação core entregue valor. Para Uber: 1 bairro com riders e drivers suficientes para <5min de espera. Para Mesh: 1 construtora com seus fornecedores + 1 FIDC = interação core funciona."
			meshManifestation: "Na Mesh, chicken-and-egg triplo: (1) fornecedor-construtora — fornecedor só quer antecipar se sua construtora está na Mesh (recebível é contra comprador específico). Construtora só quer entrar se fornecedores dela se beneficiam. Interdependência mas pré-existente: fornecedor e construtora já têm relação comercial. Mesh não precisa criar match — precisa que a relação existente opere dentro da Mesh. (2) operação-FIDC — FIDC só financia se há operações com risco aceitável. Operações só existem se há funding. Resolução: FIDC comprometido antes da primeira operação (capital reservado), operações geradas pelos anchor tenants. (3) dados-scoring — scoring precisa de dados para funcionar bem. Dados vêm de operações. Operações precisam de scoring. Resolução: scoring conservador com dados públicos no cold start, progressivamente proprietário com dados acumulados (dq-cold-start-strategy). Atomic network da Mesh: 1 construtora + 5-10 fornecedores dela + 1 FIDC = fluxo de antecipação funciona end-to-end. Se esta atomic network gera valor: replicar com próxima construtora."
			meshImplication: "Resolver chicken-and-egg sequencialmente: (1) FIDC primeiro — sem capital, nada funciona. Garantir commitment de FIDC antes de atrair construtoras. FIDC decision: 'a tese faz sentido? Risco é aceitável? Retorno projetado?' Não precisa de rede para decidir — precisa de tese convincente + governance + scoring model (mesmo conservador). (2) construtora como hard side — construtora tem poder (traz seus fornecedores). Atrair 3-5 anchor tenant construtoras com approach direto (founder-led sales). Construtora traz 10-50 fornecedores cada = 30-250 fornecedores na rede via 3-5 construtoras. (3) fornecedores como easy side — fornecedores vêm porque construtora convida (not organic discovery). Barreira de entry: baixa (signup, documentos). Motivação: dinheiro mais rápido e barato. (4) atomic network: construtora A + 10 fornecedores + FIDC = primeira operação. Se funciona: expandir. Se não: iterar antes de escalar. (5) não resolver tudo simultaneamente — resolver em sequência: capital → construtora → fornecedores → operação → dados → scoring melhora → mais operações. Anti-pattern: tentar atrair fornecedores organicamente antes de ter construtoras — fornecedor não tem o que fazer na Mesh sem sua construtora."
			rationale: "Caillaud/Jullien 2003: chicken-and-egg strategies. Chen 2022: atomic network. Na Mesh, o chicken-and-egg é resolvível porque a relação fornecedor-construtora pré-existe — Mesh não cria match, facilita operação financeira dentro de relação existente. A construtora é a key que traz a rede."
		},
		{
			id:         "cs-hard-side-identification"
			name:       "Identificação do Hard Side: Quem É Mais Difícil de Atrair e Mais Valioso Quando Vem"
			nature:     "theoretical"
			role:       "property"
			definition: "Chen (2022): o hard side é o lado da plataforma mais difícil de atrair mas que gera mais valor quando presente. Em ride-sharing: drivers são hard side (precisam investir tempo, carro, verificação) e riders são easy side (baixam app em 2min). Atrair hard side resolve cold start porque easy side segue. Hagiu/Wright (2015, 'Multi-Sided Platforms'): o hard side frequentemente é o lado que: (1) tem mais alternativas (pode não usar a plataforma), (2) precisa investir mais para participar (onboarding complexo), (3) é mais exigente em qualidade da plataforma, e (4) gera mais valor para os outros sides quando participa. Conceito contemporâneo de 'hard side economics' (2023+): o hard side frequentemente precisa ser subsidiado no início — não com dinheiro, mas com atenção (white-glove onboarding), valor standalone (ferramenta útil mesmo sem rede), ou acesso prioritário (features exclusivas para early adopters)."
			meshManifestation: "Na Mesh, quem é o hard side? (1) FIDC — mais difícil de atrair (decisão institucional, due diligence longo, commitment de capital). Mas essencial: sem capital, plataforma não funciona. Hard side #1 para viabilizar operação. (2) construtora — moderadamente difícil (precisa integrar, mudar processo, confiar em plataforma nova). Mas gera mais valor network: cada construtora traz 10-50 fornecedores. Hard side #2 para escalar rede. (3) fornecedor — mais fácil de atrair (motivação clara: dinheiro mais rápido/barato, convite da construtora, onboarding simples). Easy side: segue construtora. Sequência de resolução: FIDC (viabilidade) → construtora (rede) → fornecedor (volume). Cada hard side resolve o próximo."
			meshImplication: "Investir desproporcionalmente no hard side: (1) FIDC — founder-led relationship. Deck detalhado com tese, governance, scoring, projeção de carteira. Reuniões presenciais. Legal review. Timeline: 3-6 meses para commitment. Custo: tempo do founder. Return: viabilidade de toda a operação. (2) construtora — founder-led sales para 3-5 anchor tenants. Seleção: construtora de porte médio (suficiente para volume, pequena o suficiente para decisão rápida), com cadeia ativa de fornecedores, com dor de gestão de cadeia (push do JTBD). Value proposition standalone: 'dashboard de gestão de cadeia gratuito — qualificação de fornecedores, compliance automática.' Se construtora usa dashboard sem antecipação: valor standalone. Se fornecedores começam a antecipar: cross-side value. White-glove onboarding: founder configura pessoalmente, importa fornecedores, acompanha primeiras semanas. (3) fornecedor — onboarding assistido pelo convite da construtora. Email/WhatsApp: 'sua construtora [nome] usa Mesh.' Motivação: dinheiro mais rápido. Barreira: mínima. (4) medir: tempo de aquisição de hard side vs easy side. Se construtora leva 45 dias e fornecedor leva 3 dias: confirma quem é hard. Investir tempo proporcional. Anti-pattern: investir igualmente nos 3 sides — 'vamos fazer marketing para todos.' Hard side requer atenção desproporcional; easy side segue."
			dependsOn: ["cs-chicken-and-egg"]
			crossDependsOn: [{
				lensId:    "lens-organizational-resource-allocation"
				conceptId: "ora-throughput-constraint"
				context:   "ORA identifica horas do founder como throughput constraint. CS hard side identification direciona o constraint: founder time vai desproporcionalmente para FIDC e construtoras (hard sides). Fornecedores (easy side) recebem onboarding self-service. ORA diz 'alocar constraint no throughput máximo'; CS diz 'throughput máximo é hard side — cada construtora conquistada gera 10-50 fornecedores'."
			}]
			rationale: "Chen 2022: hard side. Hagiu/Wright 2015: harder to attract, more valuable. Hard side economics 2023+: subsidiar com atenção. Na Mesh, construtora é o hard side que gera rede — cada construtora conquistada resolve cold start para 10-50 fornecedores simultaneamente."
		},
		{
			id:         "cs-anchor-tenant-strategy"
			name:       "Estratégia de Anchor Tenant: Os Primeiros Clientes que Definem o DNA da Rede"
			nature:     "operational"
			role:       "method"
			reviewCadence: "event-driven"
			definition: "Conceito de 'anchor tenant' originalmente de shopping centers (Pashigian/Gould 1998): grande loja que atrai tráfego e viabiliza lojas menores. Em plataformas: participante de alto perfil que atrai outros participantes por reputação, rede, ou volume. Evans/Schmalensee (2016, Matchmakers): anchor tenants são os primeiros participantes que: (1) geram volume suficiente para a atomic network funcionar, (2) atraem outros participantes pela reputação ('se [construtora conhecida] usa, deve ser bom'), (3) fornecem feedback que molda o produto, e (4) se tornam referência (case study, testimonial). Conceito contemporâneo de 'founder-customer fit' (2023+): no early-stage, os primeiros clientes devem ser aqueles cujo problema o founder entende profundamente e pode resolver pessoalmente. Não é o maior cliente — é o cliente mais adequado para iterar rápido. Conceito de 'anchor tenant selection criteria' (2022+): selecionar por: (a) pain intensity (dor alta = motivação para tolerar produto imperfeito), (b) network density (traz muitos participantes do outro side), (c) feedback quality (articulado sobre o que funciona e o que não), (d) referencibility (nome que funciona como social proof)."
			meshManifestation: "Na Mesh, anchor tenant = construtora. Critérios de seleção: (1) pain intensity — construtora que sofre com: factoring caro para fornecedores (fornecedores reclamam), gestão manual de cadeia (planilha de compliance), falta de visibilidade (não sabe se fornecedores estão qualificados). Quanto mais dor: mais tolerante com produto imperfeito. (2) network density — construtora com 20-50 fornecedores ativos > construtora com 3. Cada fornecedor é potencial usuário da antecipação. (3) decision speed — construtora de porte médio (R$50-200M faturamento) decide mais rápido que construtora tier 1 (R$1B+). No cold start: velocity de decisão > tamanho do contrato. (4) referencibility — construtora reconhecida no setor (não precisa ser a maior — precisa ser respeitada). 'Se [construtora X] usa Mesh' é social proof para outras construtoras. (5) geographical proximity — no early-stage, construtora acessível para reunião presencial e white-glove onboarding. Relação pessoal acelera trust (tc-institutional-trust-building: person-based)."
			meshImplication: "Estratégia de aquisição de anchor tenants: (1) pipeline de 10 construtoras candidatas — ranquear por critérios (pain × network density × decision speed × referencibility). Top 5 = target. (2) approach: founder-led, personalizado. Não email marketing. Reunião presencial com decisor. Apresentar: problema (factoring caro + gestão manual), solução (Mesh: antecipação + governance), evidência (scoring model, governance, projeção de taxa), ask (pilot de 30 dias com 5-10 fornecedores). (3) pilot: 30 dias, sem custo, sem compromisso. Construtora importa 5-10 fornecedores. Fornecedores fazem primeira antecipação. Se funciona: converter para operação regular. Se não: feedback para iterar. (4) white-glove: founder configura dashboard, importa fornecedores, acompanha primeiro workflow, resolve issues em tempo real. Não escala — mas no cold start, cada anchor tenant merece atenção desproporcional. (5) convert para referência: anchor tenant que passa do pilot → case study com métricas reais. 'Construtora [nome] reduziu custo de antecipação dos fornecedores em 35% e qualificou 20 fornecedores em 2 semanas.' (6) target: 3-5 anchor tenants em 6 meses. Se <3: approach ou value proposition precisa de ajuste. Se >5: capacidade de atender com qualidade pode ser insuficiente (não adquirir mais do que pode servir bem). Anti-pattern: atrair construtora tier 1 (R$1B+) como primeiro anchor — ciclo de venda de 9 meses, integração complexa, requisitos enterprise. Construtora média decide em 4-6 semanas e tem dor equivalente."
			dependsOn: ["cs-chicken-and-egg", "cs-hard-side-identification"]
			crossDependsOn: [{
				lensId:    "lens-stakeholder-communication"
				conceptId: "sc-audience-specific-framing"
				context:   "SC define framing por audiência — mesma solução apresentada diferentemente para diferentes stakeholders. CS anchor tenant approach é case de framing: para construtora, frame é 'governance de cadeia + custo menor para seus fornecedores.' Para fornecedor: 'dinheiro mais rápido e barato.' Para FIDC: 'carteira com scoring proprietário.' SC é o framework de comunicação; CS é a aplicação no contexto de aquisição de anchor tenants."
			}]
			rationale: "Pashigian/Gould 1998: anchor tenants. Evans/Schmalensee 2016: anchor em plataformas. Founder-customer fit 2023+. Na Mesh, 3-5 construtoras anchor com 10-50 fornecedores cada = rede inicial de 30-250 participantes. Atomic network que permite iterar produto com dados reais."
		},
		{
			id:         "cs-single-player-mode"
			name:       "Single-Player Mode: Valor que Funciona Antes da Rede Existir"
			nature:     "theoretical"
			role:       "method"
			definition: "Chen (2022): single-player mode é valor que o produto oferece para um participante individual antes de a rede existir. Instagram era app de filtros de foto (single-player) antes de ser rede social. Airtable era spreadsheet (single-player) antes de ser plataforma colaborativa. Single-player mode resolve cold start porque: (1) atrai participantes por valor imediato, sem depender de rede. (2) gera dados e conteúdo que tornam a rede valiosa quando ativada. (3) reduz risco para early adopter ('mesmo se a rede não cresce, a ferramenta é útil'). Conceito contemporâneo de 'wedge product' (2022+): produto narrow que resolve um problema específico e depois expande para plataforma. Stripe começou como API de pagamento (wedge) e expandiu para plataforma financeira. Conceito de 'come for the tool, stay for the network' (2020+): padrão de adoção onde participante adota por valor de ferramenta (tool) e fica por valor de rede (network). Tool é o wedge; network é o moat."
			meshManifestation: "Na Mesh, single-player mode por side: (1) construtora — dashboard de gestão de cadeia de fornecedores. Funciona sem antecipação: qualificação de fornecedores, monitoramento de compliance (CNDs, certidões), performance tracking. Valor standalone: construtora que usa planilha hoje ganha ferramenta digital. Antecipação é upsell — não pré-requisito. 'Come for the tool (gestão de cadeia), stay for the network (antecipação para fornecedores).' (2) fornecedor — limitado. Sem construtora na rede e sem antecipação: fornecedor não tem single-player value. Mas: 'perfil verificado de fornecedor' pode ter valor standalone em mercado de construção ('tenho certificação Mesh de compliance'). Potencial futuro, não imediato. (3) FIDC — relatório de carteira. Se FIDC opera com Mesh: relatório automatizado com métricas é valor standalone vs compilar manualmente. Mas FIDC só entra se há operações — single-player limitado."
			meshImplication: "Projetar single-player mode para hard side (construtora): (1) dashboard de gestão de cadeia como wedge product — funcionalidade: importar fornecedores, monitorar compliance (CND federal, estadual, trabalhista, FGTS — check automatizado), alertar quando documento expira, profile com performance. Valor: substituir planilha + verificação manual. Custo: gratuito (subsídio para atrair hard side). (2) anti-dependency design — dashboard funciona sem módulo de antecipação ativo. Construtora que usa apenas gestão de cadeia por 3 meses: ok. Enquanto usa, fornecedores são qualificados, dados são coletados (dq-data-accumulation-strategy), e construtora desenvolve trust na plataforma (tc-institutional-trust-building: process-based). (3) bridge to network — quando construtora está engajada com dashboard: introduzir antecipação. 'Seus fornecedores qualificados agora podem antecipar recebíveis com taxa a partir de X%. Ativar antecipação.' Cross-sell natural. (4) medir: % de construtoras que usam dashboard sem antecipação → % que ativa antecipação em 90 dias. Se conversion <20%: bridge é fraco (dashboard não leva a antecipação). Se >40%: wedge funciona. (5) risco: construtora usa dashboard gratuito indefinidamente sem converter para antecipação (free rider). Aceitável se: (a) custo marginal de servir é baixo e (b) dados de cadeia coletados alimentam flywheel (dq-data-flywheel). Não aceitável se: custo de servir impacta sustentabilidade. Anti-pattern: 'tudo funciona sem rede' — se single-player mode é tão bom que ninguém precisa de rede: plataforma é tool, não plataforma. Single-player é wedge, não destino."
			dependsOn: ["cs-chicken-and-egg", "cs-hard-side-identification"]
			crossDependsOn: [{
				lensId:    "lens-data-quality-as-competitive-moat"
				conceptId: "dq-data-accumulation-strategy"
				context:   "DQ define que exhaust capture tem custo ~0 e valor futuro alto. CS single-player mode gera exhaust: construtora usando dashboard produz dados de cadeia (fornecedores, compliance, relações) antes de qualquer antecipação. Esses dados alimentam feature store e flywheel quando antecipação ativar. CS gera o uso; DQ captura o dado. Sem single-player mode: dados só vêm com operação de antecipação (mais lento)."
			}]
			rationale: "Chen 2022: single-player mode. Wedge product 2022+. Come for tool stay for network 2020+. Na Mesh, dashboard de gestão de cadeia é o wedge que atrai construtora (hard side) com valor standalone, coleta dados, constrói trust, e bridge para antecipação (cross-side value)."
		},
		{
			id:         "cs-sequencing-expansion"
			name:       "Sequenciamento de Expansão: Nicho Primeiro, Depois Generalizar"
			nature:     "theoretical"
			role:       "method"
			definition: "Moore (1991, Crossing the Chasm): começar em nicho (beachhead market) onde o produto resolve problema agudo para grupo específico, dominar, e depois expandir para mercados adjacentes. Em plataformas: começar com vertical narrow onde: (1) dor é aguda (motivação alta), (2) participantes se conhecem (word-of-mouth natural), (3) rede é densa (poucos participantes necessários para massa crítica), e (4) dynamics são replicáveis para próximo vertical. Thiel (2014, Zero to One): 'start with a very small market that you can monopolize.' Conceito contemporâneo de 'vertical then horizontal' (2022+, Lenny Rachitsky/a16z): padrão de plataformas bem-sucedidas — começar como vertical (Veeva para pharma CRM, Procore para construction management) e expandir horizontalmente quando vertical está dominado. Conceito de 'bowling pin strategy' (Moore 1991, evoluído 2023+): cada vertical conquistado é um 'pino' que derruba o próximo por adjacência — construtoras residenciais → construtoras comerciais → infraestrutura → industrial."
			meshManifestation: "Na Mesh, sequenciamento: (1) vertical inicial: construção civil — antecipação de recebíveis. Por quê: (a) dor aguda (fornecedores PME com ciclo de 60-90 dias e caixa apertado). (b) cadeia densa (construtora trabalha com 20-50 fornecedores regulares). (c) recebíveis são padronizáveis (nota fiscal, contrato, medição). (d) founder tem domínio do setor. (2) sub-vertical dentro de construção: construtoras de porte médio (R$50-200M) em São Paulo/Rio. Por quê: (a) decisão rápida vs tier 1. (b) dor equivalente. (c) acessível para founder-led sales. (d) densidade de fornecedores alta. (3) expansão adjacente (pós-tração): (a) construtoras de infraestrutura (adjacente por setor, dynamics similares). (b) construtoras de outros estados (adjacente por geografia). (c) outros setores com cadeia de fornecedores e antecipação (logística, agronegócio — adjacente por modelo). (4) cada expansão requer: scoring model adaptado (features podem diferir), fornecedores com perfil diferente, e dynamics de cadeia diferentes. Não assumir que modelo de construção civil funciona em agro sem validação."
			meshImplication: "Sequenciamento disciplinado: (1) beachhead: construção civil, construtoras médias, SP/RJ. Dominar: 10-20 construtoras, 200+ fornecedores, 1000+ operações. Métricas de domínio: market share no nicho (% de construtoras médias no beachhead que usam Mesh), NPS >40, retention 90d >70%. (2) gate de expansão: expandir para próximo sub-vertical apenas quando beachhead mostra: unit economics positivo (ou convergindo), scoring AUROC >0.70, churn <10% mensal, e at least 1 métrica de NE operando (dq-data-network-effects). Se gates não atingidos: iterar no beachhead, não expandir. (3) próximo pino: infraestrutura (adjacente) ou construtoras grandes (up-market). Escolher por: adjacency score (quanto do modelo atual é reusável — scoring, workflow, governance), pain intensity (dor no segmento), e founder access (pode acessar decisores?). (4) cada pino: partial cold start — precisa de novos anchor tenants no novo segmento, mas pode alavancear social proof do anterior ('20 construtoras de obras residenciais usam Mesh — agora para infraestrutura'). Scoring pode ter cold start parcial (features comuns transferem, features específicas do novo segmento precisam de dados). (5) não generalizar prematuramente — 'Mesh para todas as cadeias produtivas' antes de dominar construção civil = dispersão de foco, scoring genérico, experiência genérica, network effects diluídos. Anti-pattern: expandir para agro com 50 operações em construção civil — nem beachhead está dominado."
			dependsOn: ["cs-chicken-and-egg", "cs-anchor-tenant-strategy"]
			crossDependsOn: [{
				lensId:    "lens-real-options"
				conceptId: "ro-experimentation-as-option"
				context:   "RO modela experimentação com gates de falsificação. CS sequencing usa RO: cada expansão para novo sub-vertical é opção exercida apenas com evidência (gates de beachhead atingidos). Expandir prematuramente = exercer opção sem evidência = investimento desperdiçado. RO preserva opcionalidade (podemos expandir para agro quando dados justificarem); CS define os gates (unit economics + AUROC + retention no beachhead)."
			}]
			rationale: "Moore 1991: crossing the chasm. Thiel 2014: small market first. Vertical then horizontal 2022+. Bowling pin 2023+. Na Mesh, construção civil é beachhead com dor aguda e cadeia densa. Dominar antes de expandir — expansão prematura dilui foco e network effects."
		},
		{
			id:         "cs-bootstrap-incentives"
			name:       "Incentivos de Bootstrap: Atrair Sem Distorcer a Economia de Longo Prazo"
			nature:     "operational"
			role:       "heuristic"
			reviewCadence: "quarterly"
			definition: "Eisenmann/Parker/Van Alstyne (2006): plataformas frequentemente subsidiam um side para atrair o outro — mas subsídio cria dependência se não transicionar para valor de rede. Conceito de 'subsidy trap' (2022+): incentivo que atrai participantes que só ficam pelo incentivo — quando incentivo acaba: churn massivo. Sinal: growth que é proporcional ao incentivo, não ao produto. Conceito contemporâneo de 'good subsidy' (2023+): subsídio que: (1) atrai participante que teria valor natural da rede quando rede cresce. (2) diminui gradualmente à medida que valor de rede substitui. (3) é direcionado (não universal — para segmento que mais precisa). (4) gera dados que melhoram o produto (cada uso subsidiado produz dado). 'Bad subsidy' atrai free riders que nunca convertem. Conceito de 'intrinsic vs extrinsic motivation alignment' (Deci/Ryan 1985, evoluído para platforms 2023+): se incentivo extrínseco (desconto, cashback) é alinhado com motivação intrínseca (fornecedor quer dinheiro rápido — desconto na taxa é alinhado), subsídio reforça valor. Se desalinhado (cashback para construtora usar dashboard que não resolve dor): subsídio é desperdício."
			meshManifestation: "Na Mesh, incentivos de bootstrap: (1) para construtora (hard side) — dashboard de gestão gratuito (single-player mode). Não é desconto — é valor real standalone. Custo marginal: baixo (infra compartilhada). Transição: quando antecipação ativa, dashboard continua gratuito + fee por operação. Construtora não perde nada na transição. Alinhado: construtora quer gestão de cadeia (intrínseco). Dashboard resolve (incentivo = produto). (2) para fornecedor (easy side) — primeira operação com taxa reduzida ('primeira antecipação: taxa de 1.5% vs 2.5% regular'). Custo: ~1% × valor médio = ~R$500 por fornecedor. Objetivo: superar habit (fator tradicional) e anxiety (plataforma nova). Transição: segunda operação em diante com taxa regular. Se fornecedor percebeu valor (velocidade, transparência): fica. Se não: dados indicam que value proposition é insuficiente. (3) para FIDC — condições favoráveis no início (comissão reduzida de Mesh nos primeiros R$5M). Transição: comissão regular quando volume justificar. FIDC aceita se projeção de retorno é atrativa. (4) anti-incentivo: não dar crédito pré-aprovado sem scoring ('antecipe sem análise!'). Atrai volume mas gera inadimplência que destrói carteira e trust de FIDC."
			meshImplication: "Incentivos com discipline: (1) para cada incentivo: documentar como ADR — quem recebe, quanto, por quanto tempo, quando transiciona, e qual o gate de transição. (2) subsidy budget: quanto a Mesh pode investir em subsídio mensal sem comprometer sustentabilidade? Se runway é 18 meses e subsídio consome 5% do cash: sustentável. Se 20%: revisar. (3) transition design: cada incentivo tem sunset natural. Dashboard gratuito: permanente (custo marginal baixo, gera dados). Taxa reduzida: apenas primeira operação (1-shot, não recurring). FIDC comissão reduzida: primeiros R$5M ou 6 meses (o que vier primeiro). (4) medir signal vs noise: após incentivar, participante ficou por valor do produto ou por incentivo? Teste: % de fornecedores que fazem 2ª operação (taxa regular) após 1ª (taxa reduzida). Se >60%: valor do produto retém. Se <30%: valor é insuficiente — o problema é produto, não incentivo. (5) não competir por subsídio: se competidor oferece taxa zero: não igualar. Competir por valor (velocidade, transparência, experience) não por desconto. Subsidy war é race to bottom. (6) intrinsic alignment: cada incentivo deve estar alinhado com motivação intrínseca da persona. Fornecedor quer dinheiro rápido e barato → taxa reduzida é alinhada. Construtora quer gestão eficiente → dashboard gratuito é alinhado. FIDC quer retorno → comissão reduzida preserva retorno. Anti-pattern: incentivo desalinhado — 'ganhe R$50 em crédito para usar dashboard' para construtora que não tem dor de gestão. Atrai free rider, não early adopter."
			dependsOn: ["cs-chicken-and-egg", "cs-hard-side-identification", "cs-single-player-mode"]
			crossDependsOn: [{
				lensId:    "lens-behavioral-economics"
				conceptId: "be-incentive-design"
				context:   "BE modela como incentivos afetam comportamento — crowding out (incentivo extrínseco destrói motivação intrínseca), loss aversion (framing de incentivo como 'não perca' vs 'ganhe'). CS bootstrap incentives aplica: taxa reduzida framed como 'sua primeira antecipação com taxa especial de boas-vindas' (gain frame) vs 'taxa regular é 2.5% — você está perdendo R$500 por não usar' (loss frame para re-engagement). BE é o modelo comportamental; CS é a aplicação para bootstrap."
			}]
			rationale: "Eisenmann et al. 2006: subsidy strategies. Subsidy trap 2022+. Good subsidy 2023+. Deci/Ryan 1985: intrinsic motivation. Na Mesh, incentivo de bootstrap deve resolver barreira real (habit, anxiety) sem criar dependência. Dashboard gratuito é o melhor incentivo: valor real, custo baixo, gera dados, e bridge para monetização."
		},
		{
			id:         "cs-manual-to-organic-transition"
			name:       "Transição Manual para Orgânico: De Founder-Led para Network-Driven"
			nature:     "operational"
			role:       "method"
			reviewCadence: "quarterly"
			definition: "Conceito de 'do things that don't scale' (Graham 2013): no early-stage, crescimento é manual — founder recruta clientes um a um, resolve problemas pessoalmente, opera processos que deveriam ser automatizados. Isso é correto e necessário: entendimento profundo do cliente + velocidade de iteração. Mas precisa transicionar para crescimento orgânico antes que founder-time se torne bottleneck. Conceito contemporâneo de 'growth loops' (Reforge 2020+): crescimento sustentável vem de loops — cada cohort de usuários gera a próxima cohort. Types: (1) viral loop — usuário convida outros (Mesh: construtora convida fornecedores que convidam outras construtoras). (2) content loop — uso gera conteúdo que atrai novos (Mesh: benchmark publicado atrai interesse). (3) paid loop — receita financia aquisição que gera mais receita. (4) data loop — uso gera dados que melhoram produto que atrai mais (dq-data-flywheel). Conceito de 'organic pull metric' (2023+): métrica que indica que growth está transitioning de push (founder-led) para pull (network-driven) — % de novos participantes que vêm por referral vs direct outreach."
			meshManifestation: "Na Mesh, transição: (1) fase manual (0-50 operações) — founder vende para construtoras 1:1. Founder faz white-glove onboarding. Founder resolve issues pessoalmente. Growth = f(founder hours). Necessário: founder entende profundamente o problema, itera produto real-time, constrói trust pessoal. (2) fase assistida (50-200 operações) — templates de onboarding testados e documentados. Agente IA assume parte do onboarding (validação de documentos, qualificação). Founder foca em anchor tenants novos, não em operação de existentes. Growth = f(founder hours + referral de anchor tenants). (3) fase orgânica (200+ operações) — construtora existente convida nova construtora ('Mesh resolveu nossa gestão de cadeia, vocês deveriam experimentar'). Fornecedor que opera com 2 construtoras: quando 3ª construtora entra, fornecedor já está qualificado. Growth = f(network effects + referral + data flywheel). Founder foca em estratégia e key accounts, não em aquisição de volume. Loops da Mesh: (1) network loop — construtora A convida fornecedores → fornecedores operam com construtora B → construtora B descobre Mesh → construtora B entra. (2) data loop — mais operações → scoring melhora → taxa melhora → mais operações. (3) content loop — benchmark de mercado publicado atrai interesse → construtoras descobrem Mesh → entram."
			meshImplication: "Planejar transição explicitamente: (1) métricas de transição: % de novos participantes por canal — founder outreach vs construtora referral vs fornecedor word-of-mouth vs organic (search/content). Target: founder outreach cai de 100% (fase manual) para <30% (fase orgânica). Se founder outreach permanece >70% após 12 meses: network effects não estão operando — investigar por que. (2) automação de onboarding: cada passo que founder faz manualmente: documentar, automatizar, delegar para agente. Sequência: (a) documentação validada manualmente → agente valida. (b) dashboard configurado manualmente → self-service. (c) fornecedores importados manualmente → convite automatizado. (d) issues resolvidos por founder → suporte por agente + escalação. (3) enable viral loop: facilitar que construtora convide outra construtora. 'Indique uma construtora → se ela usar: [benefício para ambos].' Referral de fornecedor para construtora nova: 'seus fornecedores já usam Mesh — active para gerenciar sua cadeia.' (4) enable content loop: publicar benchmark (inadimplência por segmento, taxa média, tempo de processamento). Anonimizado. Atrai construtoras que buscam dados de mercado. SEO para termos de construção civil + fintech. (5) enable data loop: comunicar que scoring melhora com volume. Para early adopters: 'sua taxa caiu de 2.8% para 2.3% porque acumulamos 300 operações de performance.' Incentiva uso → gera dados → melhora produto → incentiva mais uso. (6) founder exit criteria: founder pode sair da operação diária quando: onboarding é self-service ou agent-led, issues são resolvidos sem escalação >90%, e % de novos participantes por referral >40%. Enquanto não: founder stays hands-on. Anti-pattern: 'automatizar tudo' no mês 3 antes de entender profundamente o que funciona — automatiza processo errado."
			dependsOn: ["cs-anchor-tenant-strategy", "cs-bootstrap-incentives"]
			crossDependsOn: [{
				lensId:    "lens-data-quality-as-competitive-moat"
				conceptId: "dq-data-flywheel"
				context:   "DQ data flywheel é o loop de dados que habilita transição de manual para orgânico — mais operações → scoring melhora → taxa melhora → mais operações sem founder selling. CS transição é o período onde data flywheel começa a girar. DQ mede o flywheel (AUROC vs volume, learning curve); CS usa o flywheel como alavanca de crescimento orgânico."
			}]
			rationale: "Graham 2013: do things that don't scale. Growth loops Reforge 2020+. Organic pull metric 2023+. Na Mesh, founder-led growth é necessário no início (entender, iterar, construir trust) mas insustentável para escala. A transição para network-driven é o que habilita crescimento além do constraint de founder-hours."
		},
		{
			id:         "cs-network-effects-activation"
			name:       "Ativação de Network Effects: Medir se a Rede Está Começando a Funcionar"
			nature:     "operational"
			role:       "property"
			reviewCadence: "monthly"
			definition: "Network effects existem quando valor para cada participante cresce com número de participantes. Mas NE não são binários (on/off) — ativam gradualmente. Conceito de 'tipping point' (Chen 2022): momento onde NE são fortes o suficiente para que crescimento se auto-sustente sem subsídio ou push manual. Antes do tipping point: cada novo participante precisa ser 'empurrado.' Depois: participantes vêm porque rede é atrativa. Conceito contemporâneo de 'NE activation metrics' (2023+): métricas que indicam se NE estão operando: (1) organic-to-paid ratio — % de novos participantes que vêm organicamente vs aquisição paga/manual. Crescendo = NE ativando. (2) engagement vs network size — se engagement (operações/mês) cresce mais rápido que network size (participantes): NE amplifica. Se engagement é flat enquanto rede cresce: NE não opera (participantes entram mas não interagem). (3) retention vs cohort — cohorts mais recentes retém melhor que cohorts mais antigas? Se sim: produto melhorou com mais dados/rede. (4) cross-side activity ratio — % de participantes de side A que interagem com side B. Se cresce: rede é ativa. Se cai: participantes estão mas não interagindo."
			meshManifestation: "Na Mesh, métricas de ativação de NE: (1) organic-to-manual ratio — fornecedores que entram por convite de construtora (organic) vs outreach direto (manual). Se convite > outreach: rede puxa. Construtoras que entram por referral de outra construtora vs outreach de founder. Se referral cresce: NE cross-side. (2) operations per supplier — se fornecedores fazem mais operações por mês à medida que rede cresce: engagement amplifica com rede. Se flat: rede não adiciona valor de recurrence. (3) multi-homing reduction — fornecedor que opera com 1 construtora na Mesh vs 3 construtoras. Se % de fornecedores multi-construtora cresce: rede é sticky. (4) scoring improvement — AUROC cresce com volume (dq-data-compounding). Se cresce: data NE operando. Se plateau: retornos decrescentes (mais volume do mesmo tipo não ajuda). (5) retention by cohort — fornecedores que entraram no mês 6 retém melhor que os do mês 1? Se sim: produto melhorou com dados/rede. Se não: melhorias não estão impactando experiência."
			meshImplication: "Monitorar e comunicar mensalmente: (1) dashboard de NE activation: organic ratio, operations per supplier, multi-homing %, AUROC trend, retention by cohort. Trend lines mais importantes que números absolutos. (2) tipping point indicators: quando organic ratio >50% (mais vêm por rede que por push) E operations per supplier cresce mês-a-mês E retention de cohorts recentes > cohorts antigas: tipping point atingido ou próximo. (3) se NE não ativam após 12+ meses e 500+ operações: investigar fundamentalmente. Possibilidades: (a) atomic network muito pequena — precisa de mais construtoras para rede funcionar. (b) value proposition insuficiente — participantes entram mas não percebem valor de rede. (c) friction excessiva — participantes querem interagir mas processo é difícil. (d) wrong beachhead — nicho não tem dynamics de NE (participantes não se referenciam mutuamente). Cada possibilidade tem ação diferente. (4) comunicar para investidor: NE metrics são evidência de moat emerging. 'Organic ratio: 35% e crescendo. Operations per supplier: 2.3/mês, up from 1.5.' Trend > absolute number. (5) comunicar para participantes: tornar NE tangível. 'Sua taxa caiu porque mais operações geraram dados melhores.' 'Fornecedor [novo] já está pré-qualificado porque trabalha com construtora [existente].' Participantes não percebem NE abstratamente — percebem benefícios concretos. Anti-pattern: afirmar 'temos network effects' sem métricas. NE é hipótese até que dados confirmem."
			dependsOn: ["cs-chicken-and-egg", "cs-manual-to-organic-transition"]
			crossDependsOn: [{
				lensId:    "lens-platform-dynamics"
				conceptId: "pd-network-effects"
				context:   "PD modela NE como propriedade econômica de plataformas (direct, indirect, cross-side, data NE). CS NE activation mede quando NE começam a operar na prática. PD é a teoria ('NE criam moat'); CS é a medição ('NE estão ativando? Evidência: organic ratio 35%'). PD diz o que NE são; CS diz quando e se NE estão acontecendo."
			}]
			rationale: "Chen 2022: tipping point. NE activation metrics 2023+. Na Mesh, network effects são a tese de defensibilidade — mas são hipótese até que métricas confirmem. Monitorar mensalmente e iterar se não ativam é o que diferencia 'temos NE' (afirmação) de 'NE estão operando: organic ratio 50%' (evidência)."
		},
		{
			id:            "cs-cold-start-review"
			name:          "Revisão de Cold Start: Inventário Periódico de Progresso de Bootstrap"
			nature:        "operational"
			role:          "method"
			reviewCadence: "monthly"
			definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) chicken-and-egg — atomic network funcionando? Cada side tem valor? Algum side missing? (2) hard side — progresso com FIDC e construtoras? Pipeline? Conversion rate? (3) anchor tenants — quantas? Quality? Feedback? Converteram para referência? (4) single-player mode — engagement de construtoras com dashboard? Conversion para antecipação? (5) sequencing — ainda no beachhead? Gates atingidos para expansão? (6) incentives — incentivos operando? Conversion post-incentive? Subsidy budget? (7) transition — founder-led vs organic ratio? Onboarding automatizado? (8) NE activation — organic ratio? Operations per supplier? Retention by cohort? AUROC trend?"
			meshManifestation: "Na Mesh: revisão mensal durante cold start (mais frequente que lenses em estado estável). Quando NE tipping point atingido: reduzir para trimestral."
			meshImplication: "Mensal (1h): anchor tenants — pipeline atualizado. Novas construtoras em approach? Em pilot? Convertidas? Atomic network — operações este mês? Cada side ativo? Algum side com engagement caindo? Single-player — construtoras usando dashboard? % que converteu para antecipação? NE activation — organic ratio. Operations per supplier. Retention. Todos trending up? Incentives — fornecedores pós-taxa-reduzida: % que fez 2ª operação? Transition — % de onboarding ainda founder-led vs agent-led? Ready to automate mais? FIDC — carteira healthy? Retorno conforme projeção? Feedback? Beachhead — still focused? Tentação de expandir prematuramente? Gates atingidos? Se operando há 6+ meses e atomic network não funciona: pivot assessment. O que não funciona? Hard side não vem? Value proposition insuficiente? Beachhead errado? Pivot ≠ desistir — é ajustar direção com aprendizado acumulado. Se NE tipping point atingido: celebrar e transicionar review para trimestral. Foco muda de cold start para growth."
			dependsOn: ["cs-chicken-and-egg", "cs-hard-side-identification", "cs-anchor-tenant-strategy", "cs-single-player-mode", "cs-sequencing-expansion", "cs-bootstrap-incentives", "cs-manual-to-organic-transition", "cs-network-effects-activation"]
			rationale: "Cold start é o período mais vulnerável — review mensal é proporcional ao risco. Sem monitoramento frequente, sinais de que bootstrap não funciona são detectados tarde demais. Mensal permite ajuste rápido."
		},
	]

	reasoningProtocol: [
		{
			question:  "A atomic network está definida? Quantos participantes de cada side são necessários para a interação core funcionar?"
			reveals:   "Se o mínimo viável de rede é conhecido — ou se 'precisamos de muitos usuários' é vago demais para guiar ação."
			rationale: "Chen 2022: atomic network. Na Mesh: 1 construtora + 5-10 fornecedores + 1 FIDC = atomic network. Se definido: bootstrap é target-oriented."
		},
		{
			question:  "Qual é o hard side e está recebendo investimento desproporcional? Founder time alocado proporcionalmente?"
			reveals:   "Se o bottleneck de bootstrap está sendo atacado — ou se esforço é disperso entre sides com retorno desigual."
			rationale: "Chen 2022: invest in hard side. Na Mesh: construtora é hard side que gera rede. Cada construtora = 10-50 fornecedores."
		},
		{
			question:  "Anchor tenants estão sendo selecionados por critérios claros (pain, network density, decision speed, referencibility)?"
			reveals:   "Se primeiros clientes são escolhidos estrategicamente — ou se são quem apareceu primeiro."
			rationale: "Anchor tenant criteria 2022+. Primeiros clientes definem DNA da rede — selecionar deliberadamente."
		},
		{
			question:  "Existe single-player mode para o hard side? Valor antes da rede existir?"
			reveals:   "Se hard side tem razão para entrar antes de cross-side value existir — ou se 'entre e espere os outros virem'."
			rationale: "Chen 2022: come for tool, stay for network. Na Mesh: dashboard de gestão é single-player que wedge para antecipação."
		},
		{
			question:  "Expansão está sequenciada? Beachhead está sendo dominado antes de generalizar?"
			reveals:   "Se foco é disciplinado — ou se tentação de 'servir todo mundo' está diluindo network effects."
			rationale: "Moore 1991: crossing the chasm. Thiel 2014: monopolize small market. Expansão prematura = NE diluídos."
		},
		{
			question:  "Incentivos de bootstrap são alinhados com motivação intrínseca e têm sunset natural? Ou criam dependência?"
			reveals:   "Se subsídio acelera adoção legítima — ou se atrai free riders que churn quando incentivo acaba."
			rationale: "Good subsidy 2023+. Subsidy trap 2022+. Taxa reduzida para primeira operação é alinhada. Cashback genérico não."
		},
		{
			question:  "Transição de founder-led para network-driven está acontecendo? Organic ratio está crescendo?"
			reveals:   "Se growth está se tornando sustentável — ou se depende indefinidamente de founder-hours."
			rationale: "Graham 2013: things that don't scale → scale. Se organic ratio não cresce após 12 meses: NE não estão ativando."
		},
		{
			question:  "Network effects estão ativando? Métricas concretas (organic ratio, operations per supplier, retention by cohort) confirmam?"
			reveals:   "Se NE são realidade ou aspiração — 'temos NE' sem métrica é afirmação, não evidência."
			rationale: "NE activation metrics 2023+. Na Mesh, NE é tese central — precisa ser validada com dados, não assumida."
		},
	]

	meshExamples: [
		{
			id:       "ex-atomic-network-first-construtora"
			scenario: "Mesh está prestes a lançar. FIDC comprometido. Founder precisa conquistar primeira construtora anchor tenant para ativar atomic network."
			analysis: "Sem construtora: zero fornecedores, zero operações, zero dados. Construtora é o hard side que traz a rede. Primeira construtora define: (1) se product-market fit existe para este segmento. (2) quais workflows funcionam e quais precisam de iteração. (3) base de fornecedores para primeiras operações. (4) primeira referência para próximas construtoras. Seleção é a decisão mais importante do cold start."
			recommendation: "(1) Seleção: pipeline de 10 construtoras candidatas. Critérios: pain (factoring caro + gestão manual), network (20+ fornecedores ativos), decision speed (porte médio, decisor acessível), referencibility (nome respeitado no setor), proximity (SP/RJ para founder-led). Ranquear e abordar top 3 sequencialmente (não paralelo — founder time é constraint). (2) Approach: reunião presencial com decisor (diretor financeiro ou de suprimentos). Pitch: 'seus fornecedores pagam 4%+ de factoring — podemos reduzir para <3%. Ao mesmo tempo: dashboard gratuito para gestão de cadeia e compliance.' Demonstrar: mock-up de dashboard com fornecedores da construtora (pesquisar antes). Simulação de taxa com dados reais do setor. (3) Pilot: 30 dias, 5-10 fornecedores selecionados pela construtora (que tenham recebíveis para antecipar). Gratuito para construtora. Taxa reduzida para fornecedores (1.5% vs 2.5%). Founder faz white-glove: configura dashboard, importa fornecedores, acompanha cada operação. (4) Métricas de sucesso do pilot: ≥3 operações completadas end-to-end. Fornecedor recebeu dinheiro corretamente. Construtora usou dashboard ≥3x na semana. NPS >6. TTV <5 dias. (5) Conversão: se pilot sucesso → contrato regular. Case study com métricas. Construtora como referência para próximas. (6) Se pilot falha: diagnóstico — value proposition insuficiente? Workflow tem friction inaceitável? Fornecedores não querem? Cada diagnóstico tem ação diferente. Pilot falho com aprendizado > não tentar."
			principlesApplied: ["ax-01", "ax-02", "ax-03"]
			assumptions: [
				"construtora de porte médio aceita pilot de 30 dias — pode exigir mais tempo ou formalização",
				"5-10 fornecedores são suficientes para pilot significativo — depende de frequência de antecipação",
				"founder consegue acessar decisor diretamente — pode precisar de introdução via rede pessoal",
				"taxa de 1.5% para pilot é financeiramente viável com FIDC — verificar com gestor",
			]
			rationale: "Chen 2022: atomic network. Evans/Schmalensee 2016: anchor tenant. Na Mesh, a primeira construtora é a decisão mais importante do cold start — selecionar bem e fazer white-glove maximiza probabilidade de atomic network funcionar."
		},
		{
			id:       "ex-single-player-dashboard-wedge"
			scenario: "Construtora candidata diz: 'interessante, mas não sei se meus fornecedores vão querer usar. E se ninguém antecipar?' Anxiety de construtora: investir tempo em plataforma que pode não gerar retorno."
			analysis: "Construtora está avaliando risco de adoção. Se antecipação não funciona (fornecedores não usam): tempo investido é perdido. Anxiety legítima. O que reduziria anxiety: valor que funciona independente de antecipação. Se construtora tem valor mesmo se zero fornecedores antecipam: risco de adoção cai para ~zero."
			recommendation: "(1) Reframe: 'a antecipação é uma funcionalidade — a gestão de cadeia é a base. Mesmo que nenhum fornecedor antecipe: você ganha dashboard de gestão de seus fornecedores com compliance automática.' (2) Demonstrar standalone value: 'Atualmente você verifica CNDs de fornecedores como? [planilha/manualmente]. Dashboard Mesh: monitora automaticamente. CND que vence: alerta 30 dias antes. Fornecedor com documentação pendente: visível no dashboard. Performance agregada: % de entregas on-time.' (3) ROI standalone: 'tempo gasto verificando compliance manualmente: ~10h/mês. Com Mesh: ~1h/mês (review de alertas). Economia: 9h/mês × valor/hora = R$X.' Tangível. (4) antecipação como upsell natural: 'quando seus fornecedores estiverem no sistema e qualificados, ativar antecipação é 1 clique. Se funcionar: ótimo. Se não: o dashboard continua sendo útil.' Zero risco de downside para construtora. (5) pilot: 'comece com dashboard apenas. Importe 5 fornecedores. Use por 2 semanas. Se gostar: ativamos antecipação.' Progressive commitment: baixo risco → teste → valor demonstrado → compromisso maior."
			principlesApplied: ["ax-01", "ax-02", "ax-04"]
			assumptions: [
				"construtora realmente tem dor de gestão de compliance — se não tem (terceiriza): wedge não funciona",
				"dashboard é útil com 5 fornecedores — pode precisar de 20+ para ser significativo",
				"compliance automática funciona em pilot (CNDs verificáveis automaticamente) — depende de integração com fontes",
				"9h/mês de economia é estimativa realista — validar com dados de construtoras reais",
			]
			rationale: "Chen 2022: single-player mode. Come for tool stay for network 2020+. Na Mesh, dashboard de gestão de cadeia como wedge resolve anxiety da construtora ('e se antecipação não funcionar?') porque funciona independentemente — zero downside risk para construtora experimentar."
		},
		{
			id:       "ex-ne-activation-measurement"
			scenario: "Mesh opera há 10 meses com 8 construtoras e 120 fornecedores. 450 operações. Founder quer saber: network effects estão ativando ou crescimento é puramente founder-driven?"
			analysis: "Métricas para distinguir: (1) como construtoras 6-8 entraram? Se founder vendeu todas 8: 100% manual. Se construtoras 6-8 foram referral de 1-5: NE cross-side ativando. (2) fornecedores multi-construtora: quantos fornecedores operam com >1 construtora na Mesh? Se 15 de 120 (12.5%): rede começando a cruzar. Se 0: silos isolados. (3) operations per supplier: mês 1: 1.2 ops/fornecedor. Mês 10: se 2.5: engagement cresce com rede. Se 1.2: flat — rede não amplifica. (4) organic ratio: % de novos fornecedores que entram por convite de construtora (organic) vs outreach direto. (5) retention by cohort: fornecedores que entraram no mês 3 retém melhor em 90d que os do mês 1?"
			recommendation: "(1) Calcular métricas: (a) construtora acquisition channel — das 8, quantas por: founder outreach (manual), referral de construtora existente (NE), referral de fornecedor (NE), inbound/content (organic)? Se 6 founder + 2 referral: organic ratio = 25%. Trending up? (b) supplier multi-homing — SELECT supplier_id, COUNT(DISTINCT builder_id) FROM operations GROUP BY supplier_id HAVING COUNT > 1. Se 18/120 (15%): rede cruzando. (c) operations per supplier por mês — trend. Crescendo ou flat? (d) retention by cohort — cohort mês 3 vs cohort mês 8: qual retém melhor em 90d? Se recente retém melhor: product improving with data/network. (2) Interpretar: (a) organic ratio 25% em 10 meses: positivo mas não tipping point. NE começando mas não self-sustaining. (b) multi-homing 15%: rede começando a cruzar — fornecedores percebem valor de estar em múltiplas construtoras. Amplificar: 'você já está qualificado para construtora B — nenhum documento adicional necessário.' (c) ops/supplier crescendo: engagement amplifica com rede. Se flat: investigar. (3) Ações: (a) amplificar NE nascentes — facilitar referral de construtora (template de indicação, benefício). (b) amplificar multi-homing — quando fornecedor opera com construtora B: notificar construtora C que o fornecedor está pré-qualificado. (c) publicar metrics — para investidor: 'organic ratio 25% e crescendo. Multi-homing: 15%. Operations per supplier: 2.3, up 45% em 6 meses.' Evidência de NE emerging. (4) Target para tipping point: organic ratio >50%, multi-homing >30%, operations per supplier crescendo >10%/mês. Quando atingido: growth é network-driven, não founder-driven."
			principlesApplied: ["ax-01", "ax-07"]
			assumptions: [
				"8 construtoras e 120 fornecedores são suficientes para medir NE — amostra pequena, métricas podem ser ruidosas",
				"referral é rastreável — construtora pode ter vindo por múltiplos canais simultaneamente",
				"multi-homing de 15% é significativo — depende de estrutura do mercado (se fornecedores tipicamente trabalham com 1 construtora: 15% é alto)",
				"ops/supplier crescendo indica NE — pode ser sazonalidade ou maturação natural",
			]
			rationale: "NE activation metrics 2023+. Chen 2022: tipping point. Na Mesh, 'temos network effects' é hipótese. 'Organic ratio 25% e crescendo, multi-homing 15%, ops/supplier +45%' é evidência. Evidência guia decisão; hipótese guia esperança."
		},
		{
			id:       "ex-expansion-gate-decision"
			scenario: "Mesh domina beachhead (construção civil residencial, SP/RJ) com 15 construtoras, 350 fornecedores, 2000 operações. Founder recebe oportunidade de expandir para construtoras de infraestrutura em MG. Tentação é alta."
			analysis: "Oportunidade atrativa: novo segmento, nova geografia, mais volume. Mas: (1) infraestrutura tem dynamics diferentes — recebíveis de longo prazo (>120 dias), compradores públicos (risco diferente), documentação regulatória adicional. (2) MG é nova geografia — sem rede de contatos, sem brand awareness. (3) scoring model treinado com dados de residencial SP/RJ — pode não performar para infra MG. (4) operação em novo segmento + nova geografia simultaneamente é risco duplo. Verificar gates de expansão."
			recommendation: "(1) Check gates: (a) unit economics positivo no beachhead? Se ainda negativo: resolver antes de expandir (não exportar problema). (b) scoring AUROC >0.70 no beachhead? Se sim: model funciona para residencial. Para infra: features são diferentes — scoring terá cold start parcial. (c) retention 90d >70% no beachhead? Se sim: produto retém. Se não: fixing retenção é prioridade sobre expansão. (d) NE ativando? Organic ratio >40%? Se sim: beachhead está network-driven. Se não: founder-driven growth não pode split para 2 fronts. (2) Se gates atingidos: expandir com disciplina. (a) separar variáveis: expandir para infra em SP (mesmo geography, new segment) OU residencial em MG (same segment, new geography) — não ambos. (b) se infra SP: testar com 1-2 construtoras de infra que o founder pode acessar via rede existente. Scoring com features conservadoras (bureau + heurísticas) até dados de infra acumulem. (c) se residencial MG: replicar playbook do beachhead com anchor tenant local. Scoring transfere (mesmo segmento). (3) Se gates não atingidos: agradecer oportunidade em MG e focar no beachhead. 'Não estamos prontos para infraestrutura — nosso modelo funciona para residencial e estamos otimizando. Quando estiver pronto: retornamos.' Dizer não a oportunidade é mais difícil e mais correto que dizer sim prematuramente. (4) Documentar como decision record: 'Oportunidade de expansão para infra/MG: avaliada em [data]. Gates: [status]. Decisão: [expandir/postergar]. Rationale: [evidência].' Para investidor: demonstra disciplina de expansão."
			principlesApplied: ["ax-01", "ax-05", "ax-07"]
			assumptions: [
				"gates são binárias — na prática, pode estar 'quase' atingido em algumas e claramente atingido em outras",
				"separar variáveis é possível — pode não haver construtoras de infra em SP acessíveis",
				"scoring de residencial não transfere para infra — features de bureau transferem; features operacionais podem diferir",
				"dizer não a oportunidade é estrategicamente correto — depende de urgência de crescimento e pressão de investidor",
			]
			rationale: "Moore 1991: dominar beachhead antes de expandir. RO experimentation: gate de expansão. Na Mesh, expandir para infra/MG com 2000 operações em residencial/SP é tentador — mas se gates não estão atingidos, é dispersão que enfraquece ambos os fronts."
		},
	]

	principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-05", "ax-07", "dp-01"]

	relatedLenses: [
		{
			lensId:   "lens-platform-dynamics"
			relation: "complementsWith"
			context:  "PD modela dinâmicas econômicas de plataforma em estado estável (NE, pricing, subsidies). CS modela como iniciar — de zero a NE ativados. PD é o estado estável; CS é a transição para chegar lá. PD diz 'NE criam moat'; CS diz 'como ativar NE a partir de rede zero'."
		},
		{
			lensId:   "lens-data-quality-as-competitive-moat"
			relation: "complementsWith"
			context:  "DQ modela cold start de dados para scoring (dq-cold-start-strategy). CS modela cold start de rede (participantes). Ambos são interdependentes: sem participantes não há dados; sem dados não há scoring; sem scoring não há produto. DQ resolve cold start informacional; CS resolve cold start de rede. Sequência: CS traz participantes → DQ captura dados → scoring melhora → CS facilita mais participantes."
		},
		{
			lensId:   "lens-jobs-to-be-done-and-workflow-design"
			relation: "complementsWith"
			context:  "JTBD projeta workflows por persona. CS projeta como atrair a primeira persona antes de workflow funcionar. JTBD é o produto; CS é a aquisição pré-produto. JTBD onboarding é relevante: TTV rápido durante cold start é mais crítico que em estado estável — early adopter que espera 7 dias abandona para sempre."
		},
		{
			lensId:   "lens-trust-and-credibility-design"
			relation: "complementsWith"
			context:  "TC constrói trust. CS opera quando trust é mínima (plataforma nova, sem track record). TC institutional trust building é CS: transição person→process→institution. CS precisa de TC para converter anchor tenants (trust pessoal no founder). TC precisa de CS para ter participantes que gerem trust (operações bem-sucedidas)."
		},
		{
			lensId:   "lens-stakeholder-communication"
			relation: "complementsWith"
			context:  "SC comunica com stakeholders. CS aplica comunicação diferenciada por side no bootstrap: para FIDC (tese + governance), construtora (gestão + taxa menor para fornecedores), fornecedor (dinheiro rápido). SC é o framework; CS é a aplicação no contexto de aquisição."
		},
		{
			lensId:   "lens-organizational-resource-allocation"
			relation: "complementsWith"
			context:  "ORA aloca constraint (founder time). CS direciona: founder time desproporcionalmente para hard side (construtoras + FIDC). ORA (ora-throughput-constraint) governa: cada hora de founder gasta em easy side (fornecedor) é hora indisponível para hard side que gera 10x mais rede."
		},
		{
			lensId:   "lens-real-options"
			relation: "complementsWith"
			context:  "RO modela experimentação com gates. CS sequencing expansion usa gates: expandir para novo segmento apenas com evidência de beachhead dominado. RO preserva opcionalidade; CS exerce opções quando gates são atingidos. Expansão prematura = opção exercida sem evidência."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "BE modela incentivos e vieses. CS bootstrap incentives aplica: taxa reduzida (alinhada com motivação intrínseca do fornecedor), dashboard gratuito (alinhado com dor da construtora), framing de incentivos (gain vs loss). BE é a teoria; CS é a aplicação no bootstrap."
		},
	]

	limitations: [
		{
			description: "Framework assume que cold start é resolvível com estratégia. Em mercados com barreiras estruturais (regulação que proíbe intermediação, incumbents com contratos exclusivos), cold start pode ser bloqueado por fatores externos, não internos."
			alternative: "Antes de bootstrap strategy: validar que não há bloqueio estrutural. Regulação permite intermediação financeira de recebíveis? Construtoras não têm contratos exclusivos com factorings? Se bloqueio existe: resolver antes de bootstrap (regulatory strategy)."
			rationale: "Estratégia de bootstrap sem viabilidade regulatória é exercício teórico. Na Mesh: validar viabilidade de FIDC + SCD/SCR antes de investir em bootstrap."
		},
		{
			description: "Anchor tenant strategy depende de founder com acesso a decisores no setor. Founder sem rede de contatos em construção civil enfrenta barreira de acesso que estratégia não resolve."
			alternative: "Se founder não tem acesso: (a) advisor com rede no setor (accelerator, mentor). (b) warm intro via rede secundária (investidor, parceiro). (c) content marketing como door opener (publicar benchmark do setor → construtoras procuram). (d) evento do setor (conferência, feira) para networking."
			rationale: "Founder-led sales requer acesso a decisores. Acesso é pré-condição, não consequência de estratégia."
		},
		{
			description: "Single-player mode (dashboard de gestão) pode ser copiado por concorrente que não precisa resolver chicken-and-egg (apenas a ferramenta, sem plataforma). Se ferramenta standalone é commodity: wedge não funciona."
			alternative: "Single-player mode com dados que se tornam mais valiosos com uso (dq-data-compounding) — dashboard que aprende padrões de compliance do setor, sugere fornecedores baseado em performance. Competidor pode copiar a ferramenta; não pode copiar dados acumulados. Tool é copiável; tool + data é defensável."
			rationale: "Wedge product que qualquer um replica em 2 semanas não é wedge — é commodity. Wedge precisa de defensibilidade crescente com uso."
		},
		{
			description: "Métricas de NE activation são ruidosas em volumes pequenos (<500 operações). Organic ratio pode ser 40% porque 2 de 5 construtoras vieram por referral — amostra muito pequena para conclusão."
			alternative: "Complementar métricas quantitativas com qualitative signals: construtora mencionou Mesh para outra espontaneamente? Fornecedor indicou colega? Feedback qualitativo de 'ouvi falar bem' precede métrica quantitativa. Não depender apenas de números com amostra pequena."
			rationale: "NE em early-stage são mais feeling que fact. Qualitative signal + small quantitative signal = reasonable confidence. Puramente quantitativo com n=5: conclusão frágil."
		},
		{
			description: "Transição de manual para orgânico pode não acontecer — produto pode ser inerentemente high-touch (B2B enterprise fintech com decisões complexas). Crescimento orgânico puro pode não ser possível; crescimento assistido (sales-led com referral) pode ser o steady state."
			alternative: "Aceitar que 'orgânico puro' pode não ser o destino para B2B fintech. Alvo realista: 50% referral + 30% sales-led + 20% content/inbound. Não 90% organic como consumer app. Recalibrar expectativas de organic ratio para o tipo de negócio."
			rationale: "B2B enterprise fintech não é consumer social network. Growth loops são diferentes. Referral + sales-assisted é o 'orgânico' do B2B."
		},
	]

	rationale: "Toda plataforma multisided enfrenta chicken-and-egg — e a maioria morre no cold start, não na competição. Na Mesh como plataforma B2B com fornecedores, construtoras e FIDC, cold start é triplo e o período mais vulnerável. Esta lens operacionaliza: resolução de chicken-and-egg com atomic network e sequential entry (Caillaud/Jullien 2003, Chen 2022), identificação e investimento desproporcional no hard side (Chen 2022, Hagiu/Wright 2015, hard side economics 2023+), estratégia de anchor tenant com founder-customer fit e seleção por critérios (Pashigian/Gould 1998, Evans/Schmalensee 2016, founder-customer fit 2023+), single-player mode como wedge product com come-for-tool-stay-for-network (Chen 2022, wedge product 2022+), sequenciamento de expansão com beachhead e bowling pin strategy (Moore 1991, Thiel 2014, vertical then horizontal 2022+), incentivos de bootstrap com good subsidy e intrinsic alignment (Eisenmann et al. 2006, subsidy trap 2022+, good subsidy 2023+, Deci/Ryan 1985), transição manual para orgânico com growth loops (Graham 2013, Reforge 2020+, organic pull metric 2023+), e ativação de network effects com métricas concretas e tipping point (Chen 2022, NE activation metrics 2023+). Universal, agnóstica a estágio, aplicável a qualquer plataforma multisided em fase de bootstrap."

}
