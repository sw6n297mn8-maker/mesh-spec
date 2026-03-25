package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

multiSidedPlatformUx: artifact_schemas.#AnalyticalLens & {
id:     "lens-multi-sided-platform-ux"
name:   "UX de Plataforma Multisided"

purpose: "Orientar decisões sobre como projetar experiência per-side numa plataforma multisided — fornecedor, construtora e FIDC têm needs fundamentalmente diferentes."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como projetar experiência para múltiplos sides de uma plataforma com incentivos diferentes",
		"a decisão envolve trade-offs de experiência entre sides — melhorar para um pode piorar para outro",
		"a decisão envolve como a interface comunica valor para cada side e facilita transações entre eles",
		"a decisão envolve como projetar reputação, ratings ou trust signals que informam decisões entre sides",
		"a decisão envolve como balancear transparência de informação entre sides sem expor dados sensíveis",
		"a decisão envolve como projetar experiência que incentiva comportamentos positivos de rede (contribution, compliance)",
		"a decisão envolve como lidar com assimetria de poder entre sides (construtora grande vs fornecedor PME)",
		"a decisão envolve como projetar a experiência do operador/admin da plataforma (não apenas dos sides)",
		"a decisão envolve como cross-side interactions criam valor que single-side não geraria",
		"a decisão envolve como experiência muda conforme a rede cresce (empty state → tração → escala)",
	]
	keywords: [
		"multisided", "multi-sided", "two-sided", "marketplace",
		"plataforma", "platform", "sides", "lados",
		"fornecedor", "construtora", "FIDC", "buyer", "seller",
		"matching", "discovery", "search", "browse",
		"reputação", "reputation", "rating", "review", "trust signal",
		"transparência", "information asymmetry", "disclosure",
		"cross-side", "interaction", "transação", "transaction",
		"poder", "power asymmetry", "bargaining", "negociação",
		"admin", "operador", "backoffice", "governance view",
		"chicken-and-egg", "empty state", "liquidity",
		"curation", "quality control", "standards",
		"subsidize", "subsídio", "cross-subsidization",
	]
	excludeWhen: [
		"a decisão é sobre jobs de cada persona e design de workflows individuais — usar jobs-to-be-done-and-workflow-design",
		"a decisão é sobre confiança e credibilidade como experiência — usar trust-and-credibility-design",
		"a decisão é sobre cold start e bootstrapping de rede — usar cold-start-and-network-bootstrapping",
		"a decisão é sobre network effects como dinâmica econômica — usar platform-dynamics",
		"a decisão é sobre design visual (tipografia, cor, density) — usar lenses de design visual",
	]
	rationale: "Toda plataforma multisided precisa projetar experiências para múltiplos participantes cujos incentivos divergem mas cujo valor depende da interação entre eles. Na Mesh, fornecedor quer dinheiro rápido e taxa baixa; construtora quer governança e compliance; FIDC quer retorno com risco controlado; regulador quer transparência. A interface é onde esses incentivos se encontram — e onde conflitos se materializam. JTBD cobre jobs e workflows de cada persona individualmente; PD cobre network effects e dinâmica econômica; esta lens cobre como projetar a experiência na interseção entre sides — matching, transparência, reputação, assimetria de poder, e como a UX incentiva comportamentos que fortalecem a rede. Trust-and-credibility-design cobre confiança como conceito; esta lens cobre como a experiência entre sides cria ou destrói confiança."
}

concepts: [
	{
		id:         "mux-value-proposition-per-side"
		name:       "Proposta de Valor por Side: Cada Participante Vê Produto Diferente"
		nature:     "theoretical"
		role:       "framework"
		definition: "Parker/Van Alstyne/Choudary (2016, Platform Revolution): em plataformas multisided, cada side experimenta produto diferente — producer vê ferramenta de criação/oferta, consumer vê ferramenta de descoberta/consumo, operador vê ferramenta de governance. A plataforma não tem 'uma UX' — tem UX por side, e o valor emerge da interação entre eles. Eisenmann/Parker/Van Alstyne (2006, 'Strategies for Two-Sided Markets'): plataforma precisa subsidizar o side mais sensível a preço para atrair o side que gera mais valor. O design de UX reflete isso — o side subsidiado tem experiência mais polida, onboarding mais suave, barriers mais baixas. Conceito contemporâneo de 'platform experience stack' (2023+): camada base compartilhada (infra, identity, payments) + camada específica por side (interfaces, workflows, dashboards, notificações). Cada side tem sua 'app' dentro da plataforma. Conceito de 'value unit' (Parker et al. 2016): a unidade de valor que a plataforma facilita — no Airbnb é a reserva, no Uber é a viagem. Na Mesh: a operação de antecipação. Toda UX deve otimizar para criação, discovery e consumo da value unit."
		meshManifestation: "Na Mesh, produto por side: (1) fornecedor vê: ferramenta de antecipação de recebíveis. Interface: submeter operação, acompanhar status, ver histórico, ver taxa. Value proposition: 'receba mais rápido, mais barato que factoring.' (2) construtora vê: plataforma de gestão de cadeia. Interface: dashboard de fornecedores, compliance, operações, gastos. Value proposition: 'gerencie sua cadeia com governança automática e fornecedores pré-qualificados.' (3) gestor FIDC vê: ferramenta de gestão de carteira. Interface: relatório de carteira, métricas de risco, concentração, performance. Value proposition: 'carteira com risco visível, compliance automática, relatórios gerados.' (4) operador (Mesh) vê: governance console. Interface: métricas da rede, alertas, config de políticas, override de decisões. Value proposition: 'visibilidade total da rede com controle sobre edge cases.' Value unit: a operação de antecipação — fornecedor submete, agente processa, construtora confirma (se necessário), FIDC financia, regulador audita. Toda UX otimiza para que mais value units sejam criadas e processadas com menos fricção."
		meshImplication: "Para cada side: (1) definir value proposition em 1 frase. Se não cabe em 1 frase: não está clara. (2) projetar interface específica por side — fornecedor nunca vê interface de FIDC. Construtora nunca vê detalhes de scoring. Cada side tem sua 'app' com navigation, dashboards e workflows próprios. (3) subsidiar o hard side com UX — na Mesh, fornecedor é o hard side (sem fornecedores, construtoras não vêm). Fornecedor: onboarding mais suave (jtbd-onboarding-activation), menos documentação, interface mais simples. Construtora: pode ter onboarding mais complexo (integração ERP, configuração de políticas) porque é mais motivated (quer governança). (4) value unit como métrica de design: toda decisão de UX avaliada por 'isso aumenta criação de value units (operações)?' Se feature não contribui para mais operações ou operações melhores: deprioritizar. (5) shared experience layer: identity (CNPJ-based), notifications (multi-channel), help center, status tracking — compartilhados entre sides com personalização por role. Anti-pattern: uma interface para todos os sides com toggle de 'persona' — fornecedor vê menu com 20 opções das quais 5 são relevantes."
		rationale: "Parker et al. 2016: platform experience por side. Eisenmann et al. 2006: subsidize hard side. Platform experience stack 2023+. Na Mesh, cada side vê produto diferente — a plataforma é 4 produtos que compartilham infrastructure e value unit (operação de antecipação)."
	},
	{
		id:         "mux-information-architecture-between-sides"
		name:       "Arquitetura de Informação entre Sides: O Que Cada Participante Pode Ver"
		nature:     "theoretical"
		role:       "property"
		definition: "Em plataformas multisided, informação é assimétrica por design — cada side tem informação que outros não têm, e a plataforma decide quanto revelar. Akerlof (1970, 'The Market for Lemons'): assimetria de informação pode destruir mercados — se comprador não sabe a qualidade do vendedor, paga menos, vendedores bons saem, qualidade cai. Plataformas resolvem com: (1) disclosure rules — quanta informação cada side vê do outro. (2) curation — plataforma valida qualidade (ratings, verificações, certificações). (3) signals — informação selecionada que indica qualidade sem revelar tudo (badge 'verificado', score de reputação, taxa de completion). Conceito contemporâneo de 'information design for platforms' (Bergemann/Morris 2019, evoluído 2023+): a plataforma é information designer — decide estrutura de informação que maximiza transações. Revelar demais: participantes negociam fora da plataforma (disintermediation). Revelar de menos: confiança cai, transações não acontecem. Conceito de 'differential privacy in UX' (2023+): mostrar dados agregados que informam sem expor dados individuais — 'fornecedores neste segmento têm taxa média de 2.5%' sem revelar taxa de fornecedor específico."
		meshManifestation: "Na Mesh, informação por side: (1) fornecedor vê: suas operações (status, taxa, valores). Score do comprador: apenas resultado (aprovado/rejeitado), não score numérico. Taxa: a taxa que receberá, não a composição (risco + margem + funding cost). Outros fornecedores: não vê dados de nenhum outro fornecedor. (2) construtora vê: seus fornecedores (qualificação, compliance, performance operacional). Operações dos seus fornecedores (volume, status). Não vê: dados financeiros do fornecedor (faturamento, outras operações com outros compradores), detalhes de scoring, dados de FIDC. (3) gestor FIDC vê: carteira (operações, inadimplência, concentração, performance). Dados de risco agregados. Não vê: dados individuais de fornecedores (CNPJ, nome — anonimizado ou identificado conforme contrato), detalhes de compliance operacional de cada fornecedor. (4) regulador vê: tudo que regulação exige — operações, compliance, governance, auditoria. Acesso amplo com trilha auditável. (5) operador Mesh vê: tudo — dados de todos os sides, métricas de rede, alertas, override capability. Acesso completo com audit trail."
		meshImplication: "Para cada tipo de informação: (1) disclosure matrix — tabela que define para cada campo de dados: quais sides podem ver? Nível de detalhe (granular vs agregado vs oculto)? Condições (sempre vs sob request vs nunca)? Exemplo: faturamento_mensal_comprador: scoring agent = granular, construtora = oculto, fornecedor = oculto, FIDC = agregado por faixa, regulador = granular sob request. (2) signals em vez de raw data: fornecedor não precisa saber score numérico do comprador (65 vs 72 é irrelevante para ele). Precisa saber: 'comprador aprovado com risco baixo/médio/alto.' Signal é suficiente para decisão sem expor modelo. (3) aggregated insights como valor: construtora vê 'seus fornecedores têm taxa média de compliance de 92%' — valor informacional sem expor fornecedor individual. FIDC vê 'inadimplência da carteira por segmento' — insight sem expor operação individual. (4) disintermediation prevention: não revelar contato direto entre construtora e fontes de financiamento — se construtora souber quem é o FIDC, pode negociar diretamente. Mesh é intermediário; informação entre funding e origination é protegida. (5) evolução: à medida que confiança cresce, disclosure pode expandir. Early-stage: disclosure mínima (proteção máxima). Escala: disclosure calibrada (mais dados para sides que demonstraram confiança). Disclosure como privilégio ganho, não default. Anti-pattern: 'transparência total para todos' — fornecedor vê score de 65 e contesta. Construtora vê taxa e renegocia diretamente com FIDC. FIDC vê dados de fornecedor individual e faz due diligence paralela. Cada disclosure não-calibrada é risco de disintermediation ou conflito."
		dependsOn: ["mux-value-proposition-per-side"]
		crossDependsOn: [
			{
				lensId:    "lens-information-economics"
				conceptId: "ie-information-as-asset"
				context:   "IE modela informação como ativo econômico com valor que depende de quem tem acesso. MUX operacionaliza: a disclosure matrix é o mecanismo pelo qual a Mesh controla fluxo de informação entre sides para maximizar transações e proteger intermediação. IE diz 'informação assimétrica pode criar ou destruir mercado'; MUX diz 'esta disclosure matrix equilibra informação suficiente para confiança com proteção suficiente para intermediação'."
			},
			{
				lensId:    "lens-security-trust-infrastructure"
				conceptId: "sti-data-classification"
				context:   "STI classifica dados por sensibilidade. MUX disclosure matrix implementa classificação na camada de UX — dados confidenciais não aparecem na interface de quem não deve ver. STI é a política de classificação; MUX é a implementação na experiência do usuário."
			},
		]
		rationale: "Akerlof 1970: information asymmetry. Bergemann/Morris 2019: information design. Differential privacy in UX 2023+. Na Mesh como intermediário financeiro, informação é o ativo mais sensível — quem vê o quê determina se a plataforma mantém intermediação ou se sides negociam diretamente."
	},
	{
		id:         "mux-reputation-trust-signals"
		name:       "Reputação e Trust Signals: Como Sides Avaliam Confiabilidade Mútua"
		nature:     "theoretical"
		role:       "framework"
		definition: "Resnick/Zeckhauser (2002, 'Trust Among Strangers in Internet Transactions'): sistemas de reputação online são mecanismos que permitem transações entre desconhecidos — o rating substitui a relação pessoal como fonte de confiança. Bolton/Ockenfels (2012): design de sistema de reputação afeta comportamento — ratings inflados (grade inflation) destroem informatividade; ratings punitivos demais desincentivam participação. Conceito contemporâneo de 'multi-dimensional reputation' (2022+): reputação não é um número — é perfil com múltiplas dimensões. Fornecedor tem: pontualidade de entrega, qualidade de documentação, compliance rate, diversidade de construtoras, volume histórico. Cada dimensão é relevante para diferentes decisões. Conceito de 'platform-mediated trust' (Möhlmann/Zalmanson 2017): em plataformas, confiança não é entre os participants diretamente — é entre cada participant e a plataforma. 'Confio que a Mesh verificou este fornecedor' em vez de 'confio neste fornecedor.' A plataforma é intermediária de confiança. Conceito de 'verifiable credentials' (W3C 2022+): credenciais verificáveis que participante pode carregar entre plataformas — portabilidade de reputação. Early-stage mas relevante: se fornecedor pode levar reputação da Mesh para outra plataforma, switching cost diminui mas portabilidade é mandato ético (dq-data-ethics-and-boundaries)."
		meshManifestation: "Na Mesh, reputação por side: (1) comprador (visto pelo fornecedor e scoring) — dimensões: historico_pagamentos (% on-time, avg_atraso_dias), volume_operacoes, tempo_na_plataforma, score (interno, não-revelado para fornecedor). Signal visível para fornecedor: badge 'pagador confiável' (se >90% on-time nos últimos 6 meses). (2) fornecedor (visto pela construtora) — dimensões: compliance_rate (% de documentos válidos), pontualidade_entrega (auto-reportado ou verificado), diversidade_construtoras (opera com quantas), tempo_na_plataforma. Signal visível para construtora: 'qualificado ✓', 'compliance 95%', 'opera com 3 construtoras.' (3) construtora (vista pelo fornecedor e FIDC) — dimensões: pontualidade_confirmacao (confirma operações em tempo?), volume_cadeia, compliance_own (próprios documentos em dia). Signal visível para fornecedor: 'construtora verificada.' (4) Mesh (vista por todos) — reputação da plataforma: tempo de operação, volume processado, taxa de default da carteira, regulação cumprida. Signals: regulado por Bacen, auditado, track record publicado."
		meshImplication: "Projetar sistema de reputação: (1) multi-dimensional — reputação não é score único. Para cada dimensão: dado objetivo (calculado automaticamente de dados de operação) + frequência de atualização + como é apresentado. (2) platform-mediated — confiança é na Mesh verificar, não no participante autodeclarar. 'Mesh verificou que fornecedor está com CNDs válidas' é mais confiável que 'fornecedor diz que está regular.' (3) earned signals — badges/status são ganhos por comportamento verificável, não por autodeclaração. 'Pagador confiável' requer >90% on-time em >10 operações nos últimos 6 meses. Não é comprável, não é autodeclarável. (4) visibility calibrada — fornecedor vê signals do comprador relevantes para sua decisão (confiança de receber). Construtora vê signals do fornecedor relevantes para sua decisão (compliance, qualidade). FIDC vê métricas agregadas de risco. Cada signal é calibrado por relevância do destinatário, não expõe mais que necessário. (5) freshness — reputação baseada em dados recentes (últimos 6 meses). Performance de 2 anos atrás é menos relevante que dos últimos 3 meses. Decay: performance antiga pesa menos. (6) cold start de reputação — novo participante não tem reputação. Signal: 'novo na plataforma — verificação de documentos concluída.' Não penalizar por falta de histórico — penalizar por comportamento negativo verificado. (7) no grade inflation — se 95% dos participantes têm badge 'confiável': badge perde significado. Calibrar thresholds para que badges sejam informativos (~70% qualify). (8) anti-gaming — se fornecedor descobre que compliance_rate é dimensão: pode submeter documentos sem substância. Validação por agente previne gaming (documentos realmente validados, não apenas submetidos). Anti-pattern: rating de 1-5 estrelas entre sides — fornecedor dá 1 estrela para comprador que atrasou 2 dias. Rating vira arma. Ratings devem ser objetivos (dados de operação), não subjetivos (opinião)."
		dependsOn: ["mux-value-proposition-per-side", "mux-information-architecture-between-sides"]
		crossDependsOn: [{
			lensId:    "lens-mechanism-design"
			conceptId: "md-reputation-systems"
			context:   "MD projeta mecanismos de reputação como incentivo — participante que se comporta bem ganha reputação que gera mais oportunidades. MUX projeta como reputação é apresentada na interface — quais signals, para quem, como. MD é o mecanismo; MUX é a materialização na UX. MD diz 'reputação baseada em performance verificável'; MUX diz 'badge com 3 dimensões visível na card do fornecedor'."
		}]
		rationale: "Resnick/Zeckhauser 2002: reputação online. Bolton/Ockenfels 2012: design de reputation systems. Multi-dimensional reputation 2022+. Möhlmann/Zalmanson 2017: platform-mediated trust. Na Mesh, a reputação substitui a relação pessoal como fonte de confiança entre sides — design inadequado (grade inflation, gaming, subjectivity) destrói informatividade."
	},
	{
		id:         "mux-power-asymmetry-design"
		name:       "Design para Assimetria de Poder: Proteger o Lado Fraco sem Alienar o Lado Forte"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Em plataformas B2B, sides frequentemente têm poder desigual — comprador grande vs vendedor pequeno, employer vs freelancer, landlord vs tenant. Hagiu/Wright (2015, 'Multi-Sided Platforms'): a plataforma pode rebalancear poder via: (1) information provision — dar ao lado fraco informação que antes só o lado forte tinha (preço justo, benchmark, alternativas). (2) standardization — impor padrões que protegem o lado fraco (contratos padronizados, prazos obrigatórios, dispute resolution). (3) liquidity — dar ao lado fraco acesso a múltiplas contrapartes (reduz dependência de uma). Conceito contemporâneo de 'platform fairness' (Culpepper/Thelen 2020, evoluído 2023+): plataformas que são percebidas como injustas perdem o lado fraco (que tem menos voz mas pode sair silenciosamente). Fairness percebida: (a) distributive — resultados são justos? (b) procedural — processos são justos? (c) informational — informação é acessível? Conceito de 'platform as regulator' (2022+): em mercados onde regulação é fraca, a plataforma assume papel de regulador de facto — impondo standards que o governo não impõe. Na construção civil brasileira: compliance de fornecedores é irregular. Mesh impõe compliance como pré-requisito — regulador de facto."
		meshManifestation: "Na Mesh, assimetria de poder: construtora grande (comprador) vs fornecedor PME (vendedor). Assimetrias: (1) bargaining power — construtora pode ditar prazo de pagamento (60-90 dias). Fornecedor aceita porque precisa do contrato. (2) information — construtora sabe mais sobre sua saúde financeira que fornecedor. Fornecedor não sabe se construtora vai pagar. (3) alternatives — construtora tem muitos fornecedores; fornecedor pode ter poucas construtoras. (4) consequences — se construtora não paga: fornecedor pode quebrar. Se fornecedor não entrega: construtora encontra outro. Mesh rebalanceia: (a) information — scoring do comprador informa risco ao fornecedor (indiretamente via badge). Fornecedor sabe se comprador é confiável antes de operar. (b) standardization — taxa de antecipação é baseada em risco do comprador, não em poder de barganha. Fornecedor PME com comprador bom paga mesma taxa que fornecedor grande. (c) liquidity — fornecedor opera com múltiplas construtoras na rede. Não depende de uma. (d) timing — antecipação de recebível dá ao fornecedor independência temporal: não precisa esperar o prazo da construtora."
		meshImplication: "Projetar UX que protege o lado fraco: (1) transparência de risco para fornecedor — antes de solicitar antecipação: signal do comprador (confiável/moderado/novo). Fornecedor faz escolha informada. Não esconder risco para maximizar volume — isso sacrifica fornecedor para beneficiar plataforma. (2) pricing justo — taxa baseada em risco calculado, não em poder de negociação. Fornecedor PME com comprador sólido: taxa baixa. Fornecedor grande com comprador arriscado: taxa alta. Meritocrático, não político. (3) termos padronizados — contrato de antecipação padronizado pela Mesh. Fornecedor não precisa negociar termos com construtora. Termos são justos porque plataforma os define. (4) liquidez de demanda — construtora que quer fornecedores vê catálogo de qualificados. Fornecedor qualificado é visível para múltiplas construtoras. Dependência de uma construtora diminui. (5) complaint mechanism — se fornecedor percebe injustiça: canal de dispute. Mesh avalia baseado em dados (não em poder). (6) anti-pattern: otimizar UX para construtora (anchor tenant, poder de barganha) às custas do fornecedor (UX complexa, documentação excessiva, taxa escondida). Fornecedores insatisfeitos saem silenciosamente — sem fornecedores, construtora não tem valor. (7) comunicar fairness: em materiais para fornecedor: 'taxa baseada em risco do comprador, não em seu porte.' 'Termos iguais para todos.' Fairness percebida é tão importante quanto fairness real."
		dependsOn: ["mux-value-proposition-per-side", "mux-information-architecture-between-sides"]
		crossDependsOn: [{
			lensId:    "lens-behavioral-economics"
			conceptId: "be-fairness-norms"
			context:   "BE modela normas de fairness e como violações afetam comportamento — ultimatum game mostra que pessoas rejeitam ofertas percebidas como injustas mesmo quando rejeição custa. MUX aplica: fornecedor que percebe taxa como injusta (comparada com taxa de fornecedor grande) abandona a plataforma mesmo que taxa seja menor que factoring. BE é o modelo; MUX é o design que garante fairness percebida."
		}]
		rationale: "Hagiu/Wright 2015: rebalancing power. Culpepper/Thelen 2020: platform fairness. Platform as regulator 2022+. Na Mesh, o fornecedor PME é o lado fraco com menos bargaining power, menos informação, e menos alternativas. A UX deve rebalancear — não por caridade, mas porque fornecedores insatisfeitos saem e a rede colapsa."
	},
	{
		id:         "mux-cross-side-interaction-design"
		name:       "Design de Interação Cross-Side: Onde o Valor Realmente é Criado"
		nature:     "theoretical"
		role:       "method"
		definition: "Parker et al. (2016): em plataformas, o valor não está nos sides isoladamente — está na interação entre eles. A plataforma deve projetar 'core interaction' — a ação que conecta producer e consumer e gera value unit. Core interaction tem 3 componentes: (1) participant — quem interage. (2) value unit — o que é trocado. (3) filter — como a plataforma curates e facilita o match. Conceito contemporâneo de 'interaction velocity' (2023+): plataformas devem otimizar não apenas para que interações aconteçam, mas para que aconteçam rapidamente e com baixa fricção. Interaction velocity = número de value units transacionadas por unidade de tempo por participante. Conceito de 'managed marketplace' (Cuofano 2022+): em vez de marketplace aberto onde sides negociam livremente, plataforma gerencia interação — define preço, match, e termos. Controle maior = experiência mais consistente + governance mais forte. Trade-off: menos liberdade para participantes. Na Mesh como intermediário financeiro: managed por necessidade — taxa definida por scoring, match por qualificação, termos por contrato padronizado."
		meshManifestation: "Na Mesh, core interaction: fornecedor solicita antecipação de recebível que será financiada com recursos do FIDC, de operação com construtora. 3 participantes + agentes + FIDC. A interação é managed — taxa é calculada (não negociada), aprovação é automatizada (não manual), termos são padronizados (não negociados). Cross-side interactions: (1) fornecedor × construtora — qualificação: construtora define requisitos, fornecedor submete documentação, Mesh valida. Interação indireta: construtora não fala com fornecedor via Mesh (falam diretamente na obra). Mesh facilita a dimensão financeira e compliance. (2) fornecedor × FIDC — o fornecedor não interage diretamente com FIDC. Mesh intermedia: antecipação solicitada → Mesh processa → FIDC financia. Fornecedor não sabe qual FIDC financiou. FIDC não sabe qual fornecedor específico (anonimizado ou por contrato). (3) construtora × FIDC — construtora é o comprador cuja saúde financeira é core para o FIDC. Interação pode ser direta (FIDC quer conhecer anchor tenant) ou intermediada (Mesh reporta performance)."
		meshImplication: "Projetar core interaction para máxima velocity com governance: (1) reduzir steps de core interaction: fornecedor solicita → automação processa → resultado em <30s (para automáticos). Cada step adicionado é fricção que reduz velocity. (2) managed marketplace como default — taxa, termos e aprovação definidos pela plataforma. Participantes não negociam entre si na Mesh. Benefício: experiência consistente, fairness, velocidade. Trade-off: menos flexibilidade. Se participante quer flexibilidade: escalação para custom (progressive disclosure). (3) cross-side value visibility: cada side vê o valor que o outro contribui. Construtora vê: 'fornecedor X antecipou Y operações — demonstra comprometimento com a cadeia.' Fornecedor vê: 'construtora Z tem badge de pagador confiável — baixo risco.' FIDC vê: 'cadeia com 50 fornecedores qualificados, score médio de compradores 72 — carteira diversificada.' (4) interaction metrics: volume de value units por mês, interaction velocity (time from request to settlement), conversion rate (% de solicitações que viram operações), repeat rate (% de fornecedores que fazem segunda operação). (5) anti-pattern: plataforma que facilita match mas não gerencia transação — fornecedor e construtora negociam taxa diretamente. Mesh perde intermediação e governance. Managed marketplace previne."
		dependsOn: ["mux-value-proposition-per-side", "mux-information-architecture-between-sides"]
		crossDependsOn: [{
			lensId:    "lens-platform-dynamics"
			conceptId: "pd-network-effects"
			context:   "PD modela network effects como propriedade econômica. MUX projeta a UX da core interaction que ativa network effects. PD diz 'cross-side NE: mais fornecedores = mais valor para construtoras'; MUX diz 'a interface de discovery de fornecedores pela construtora é o ponto onde NE se materializa — search, filtros, reputação, match'. PD é a dinâmica; MUX é a experiência que a ativa."
		}]
		rationale: "Parker et al. 2016: core interaction. Interaction velocity 2023+. Managed marketplace 2022+. Na Mesh, a operação de antecipação é a core interaction — toda UX é projetada para que mais operações aconteçam, mais rápido, com governance. Managed marketplace garante consistência e fairness."
	},
	{
		id:         "mux-network-stage-adaptation"
		name:       "Adaptação por Estágio da Rede: UX que Evolui com a Plataforma"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Chen (2022, The Cold Start Problem): a experiência da plataforma muda dramaticamente conforme a rede cresce. Empty state (zero sides) → early traction (poucos participantes) → growth (rede crescendo) → maturity (rede estável). Cada estágio requer UX diferente: empty state precisa de onboarding e value demonstration; early traction precisa de curation manual e hand-holding; growth precisa de automação e scale; maturity precisa de retention e expansion. Conceito contemporâneo de 'empty state design' (2022+): empty state não é 'nada para mostrar' — é oportunidade de: (a) explicar o valor, (b) guiar primeiro action, (c) mostrar exemplo de como será quando populado. Empty state design é first impression — e pode ser a única chance. Conceito de 'degraded experience at low density' (2023+): em plataforma com poucos participantes, experiência pode ser pior que alternativa não-plataforma. Construtora com 3 fornecedores na Mesh vs 50 no modelo atual: Mesh parece vazia. Projetar para que experiência com poucos participantes seja boa — não excelente, mas suficiente para reter até rede crescer."
		meshManifestation: "Na Mesh por estágio: (1) empty state — dashboard vazio. 'Nenhuma operação ainda.' UX: placeholder com valor explicado + CTA. 'Aqui você verá suas operações. Cada operação aprovada aparece em <30s. [Submeter primeira operação].' (2) early traction (1-5 anchor tenants, 10-30 fornecedores) — catálogo de fornecedores: 25 entries. Não parece 'marketplace vibrante.' UX: não mostrar catálogo como search (25 results é deprimente). Mostrar como lista curada: 'seus 25 fornecedores qualificados.' Dashboard de construtora: operações estão começando. Mostrar: trend (+3 operações este mês vs 1 mês passado), não apenas número absoluto (3 operações parece pouco). (3) growth — catálogo cresce. Search e filtros fazem sentido. Dashboard se popula. Automação substitui curation manual. (4) maturity — retenção e expansion. Features avançadas (analytics, API, custom reports). Segments dentro da rede (por região, por segmento)."
		meshImplication: "Para cada estágio: (1) empty state — para cada tela vazia: placeholder informativo + CTA. Nunca tela em branco. Nunca 'nenhum resultado encontrado' sem contexto. (2) early traction — números absolutos pequenos: mostrar relativos. 'Seus fornecedores: 25 qualificados (92% compliance rate).' Não: 'total de fornecedores na plataforma: 25.' (3) metrics que mudam com estágio: early traction: mostrar growth rate e trends (momentum). Growth: mostrar absolutos e comparações. Maturity: mostrar per-segment e benchmarks. (4) features gated por estágio: search avançado quando catálogo >50. Custom reports quando operações >100. API quando integrador solicitar. Não construir features de maturity no empty state — desperdício de constraint. (5) curation manual no early stage: no início, Mesh (founder/agente) faz curation manual — selecionar anchor tenants, garantir qualidade de primeiros fornecedores, hand-hold primeiro workflow. À medida que rede cresce: automação substitui curation manual. Regra: 'do things that don't scale' (Graham 2013) durante cold start. (6) degrade gracefully at low density: construtora com 5 fornecedores qualificados na Mesh: experiência deve ser útil (não excelente). Lista simples com status e compliance é útil — mesmo sem search avançado, recomendação ou benchmark. Anti-pattern: projetar UX de escala durante cold start — search com filtros avançados para catálogo de 25 fornecedores, analytics sofisticado para 10 operações."
		dependsOn: ["mux-value-proposition-per-side", "mux-cross-side-interaction-design"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-satisficing"
			context:   "ORA define satisficing — suficiente supera ótimo no contexto de constraint. MUX network stage adapta: UX de early traction é satisficing — boa o suficiente para reter, não perfeita. Investir em UX de maturity durante cold start é otimizar para cenário que não existe. ORA diz 'alocar proporcional ao estágio'; MUX diz 'UX proporcional ao tamanho da rede'."
		}]
		rationale: "Chen 2022: network stages. Empty state design 2022+. Degraded experience at low density 2023+. Na Mesh pré-revenue, UX de empty state é o que os primeiros anchor tenants experimentam — precisa ser suficiente para reter até rede crescer, não precisa ser UX de escala."
	},
	{
		id:         "mux-governance-operator-experience"
		name:       "Experiência do Operador: A Plataforma Precisa de UX Para Quem a Opera"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "semi-annual"
		definition: "Em plataformas multisided, existe um 'side' frequentemente ignorado: o operador — a equipe (ou AI) que gerencia a plataforma. O operador precisa de: (1) visibility — ver o que está acontecendo em toda a rede (métricas, alertas, tendências). (2) control — agir quando necessário (override de decisão, suspend participante, ajustar política). (3) investigation — investigar incidentes (por que operação falhou? por que fornecedor foi rejeitado? por que inadimplência subiu?). Conceito contemporâneo de 'internal tools as product' (Retool 2020+, Airplane 2022+, Interval 2023+): ferramentas internas para operadores devem ter a mesma qualidade de UX que ferramentas externas — operadores são usuários também. Internal tools mal-projetadas = operação lenta, erros, burnout. Conceito de 'operator dashboard for AI-native platforms' (2024+): em plataformas operadas por AI agents, o operador não executa — supervisiona. Dashboard mostra: o que agentes decidiram, quais alertas dispararam, onde intervenção é necessária. Operador como supervisor, não executor."
		meshManifestation: "Na Mesh AI-native, operador é o founder (Leo) supervisionando agentes: (1) visibility — dashboard de rede: operações por período, taxa de aprovação, inadimplência, NPS por persona, funnel de onboarding, alertas. Drill-down: por construtora, por fornecedor, por comprador. (2) control — override: rejeitar operação aprovada automaticamente (com justificativa). Suspend: suspender fornecedor ou comprador por compliance issue. Policy: ajustar threshold de scoring, alterar documentos requeridos, mudar limites. (3) investigation — timeline de operação: todos os eventos (eda-event-sourcing) de uma operação em ordem cronológica. Quem fez o quê, quando, com que dados. Score com SHAP values. Documentos validados com resultado. Decisão com rationale. (4) agent supervision — quais agentes estão ativos, o que decidiram, taxa de escalação, taxa de erro, custo de LLM. Alertas de agentes: drift detectado, DLQ não-vazia, feature store stale."
		meshImplication: "Projetar operator experience como produto: (1) governance dashboard — tela principal do operador: health da rede (green/yellow/red), operações hoje, alertas não-resolvidos, métricas de agentes. Nível de detalhe: overview → drill-down → investigation. Progressive disclosure para operador: overview primeiro, detalhes sob demanda. (2) action center — lista de items que requerem ação humana: operações escaladas, alertas, overrides pendentes, compliance issues. Priorizado por urgência e impacto. (3) investigation tools — busca por operação, por CNPJ, por período. Timeline de eventos. Score explanation. Document trail. Exportável para auditoria. (4) policy editor — interface para ajustar políticas (scoring thresholds, documentos requeridos, limites de automação) com preview de impacto: 'se threshold mudar de 60 para 70: ~15% mais escalações, ~8% menos inadimplência estimada.' (5) agent dashboard — status de cada agente, métricas de performance (accuracy, latência, custo), alertas. Para AI-native: operador supervisiona agentes como gerente supervisiona equipe — não micro-manage, mas visibilidade e intervenção quando necessário. (6) audit trail — toda ação do operador (override, suspension, policy change) logada com timestamp, rationale, e quem. Operador é accountable. Anti-pattern: operador usa SQL direto no database para investigar e API calls para override — zero UX, high error risk, no audit trail."
		dependsOn: ["mux-value-proposition-per-side", "mux-information-architecture-between-sides"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-observability-contract"
			context:   "AAG define que cada agente deve ter observability contract — o que é monitorado, como, quais métricas. MUX operator experience é a materialização desse contrato na interface do operador — agent dashboard mostra métricas definidas pelo observability contract. AAG é o contrato; MUX é a visualização."
		}]
		rationale: "Internal tools as product 2020+: operadores são usuários. Operator dashboard for AI-native 2024+: supervisor, não executor. Na Mesh AI-native, o operador (founder) supervisiona agentes — a governance console é o cockpit de controle da plataforma."
	},
	{
		id:         "mux-incentive-aligned-ux"
		name:       "UX Alinhada a Incentivos: Design que Incentiva Comportamento Positivo na Rede"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Thaler/Sunstein (2008, Nudge): design de choice architecture influencia decisão sem restringir escolha — defaults, framing, salience afetam comportamento. Em plataformas: UX pode incentivar comportamentos que fortalecem a rede (compliance, pagamento no prazo, qualidade) ou comportamentos que a enfraquecem (gaming, free-riding, disintermediation). Conceito contemporâneo de 'behavioral design for platforms' (2023+): usar nudges para alinhar incentivos individuais com saúde da rede: (a) compliance nudge — 'CND vence em 7 dias — atualizar agora garante qualificação contínua.' (b) payment nudge — 'pagar fornecedores no prazo melhora seu score de pagador — destaque na rede.' (c) engagement nudge — 'fornecedores qualificados com documentação completa recebem taxa preferencial.' Conceito de 'gamification sem infantilização' em B2B (2023+): em B2B, gamification funciona quando ligada a valor real — não badges decorativos, mas status que gera benefício (taxa menor, visibilidade, prioridade). Badge 'Top Pagador' que não gera taxa menor: decorativo e eventualmente ignorado."
		meshManifestation: "Na Mesh, comportamentos desejados e nudges: (1) fornecedor manter compliance — desejado: documentação sempre atualizada. Nudge: notificação proativa 'CND vence em 7 dias — atualizar agora.' Incentivo real: fornecedor com compliance 100% tem acesso a taxas preferenciais (conexão com pricing). Desincentivo: compliance <80% suspende qualificação. (2) comprador pagar no prazo — desejado: pagamento on-time. Nudge: 'seu score de pagador é 92% on-time — top 10% da rede.' Incentivo real: comprador confiável = fornecedores preferem operar com ele (mais fornecedores qualificados disponíveis). Desincentivo: atraso afeta score → taxa sobe para operações futuras (internalizar externalidade). (3) construtora ativar cadeia — desejado: convidar fornecedores, usar plataforma. Nudge: checklist de onboarding com progresso visível. Incentivo real: cadeia ativa = governance automática + compliance tracking. (4) todos: não desintermediar — desejado: operar via Mesh, não fora. Nudge: toda transação via Mesh gera dados que melhoram score e taxa (data flywheel tangível para participante). Desincentivo: operação fora da Mesh não gera reputação — missing out."
		meshImplication: "Para cada comportamento desejado: (1) identificar incentivo natural (alinhado com job do participante). (2) projetar nudge na UX (timing, framing, salience). (3) conectar com benefício real (taxa, acesso, visibilidade). (4) medir: rate do comportamento pré vs pós nudge. Se nudge não muda comportamento: incentivo não é forte o suficiente ou nudge não é saliente. Exemplos implementáveis: (a) compliance dashboard com countdown — 'CND válida por mais 7 dias' em amarelo. '<3 dias' em vermelho. 1-click 'atualizar agora.' (b) payment feedback — comprador vê: 'pagamento on-time: +0.5 no score. Atraso: -2.0 no score. Seu score atual: 88.' Transparência sobre como comportamento afeta reputação. (c) onboarding checklist — 'setup 60% completo. Próximo: convidar fornecedores [convidar agora].' Progress bar visível. (d) taxa preferencial comunicada — fornecedor com compliance 100%: 'taxa preferencial: 2.1% (taxa standard: 2.5%). Economia de R$200 por operação de R$50k.' Benefício tangível comunicado em reais, não em %. Anti-pattern: gamification desconectada de valor — badge 'Super Fornecedor' que não gera nenhum benefício. Participantes ignoram."
		dependsOn: ["mux-reputation-trust-signals", "mux-power-asymmetry-design"]
		crossDependsOn: [{
			lensId:    "lens-behavioral-economics"
			conceptId: "be-nudge-architecture"
			context:   "BE define nudge theory e choice architecture. MUX aplica nudges na UX da plataforma para alinhar incentivos. BE é a ciência comportamental; MUX é a implementação no design. BE diz 'defaults influenciam escolha'; MUX diz 'default de documentação é mínimo necessário, com nudge para documentação completa que gera benefício'."
		}]
		rationale: "Thaler/Sunstein 2008: nudge. Behavioral design for platforms 2023+. Gamification sem infantilização B2B 2023+. Na Mesh, UX que incentiva compliance, pagamento on-time e engagement cria rede mais saudável — não por imposição, mas por design que torna o comportamento positivo a escolha fácil e recompensada."
	},
	{
		id:            "mux-platform-ux-review"
		name:          "Revisão de UX de Plataforma: Inventário Periódico de Experiência por Side"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) value proposition — clara por side? Fornecedor sabe por que usar? Construtora sabe? FIDC? (2) information architecture — disclosure matrix atualizada? Algum side vendo mais do que deveria? Disintermediation risk? (3) reputation — trust signals informativos? Grade inflation? Gaming detectado? (4) power asymmetry — fornecedor PME satisfeito com fairness? Construtora não abusando poder? (5) cross-side interaction — interaction velocity trend? Conversion rate? Value units per month? (6) network stage — em que estágio? UX proporcional? Empty states adequados? (7) operator — governance console funcional? Investigation tools suficientes? Agent supervision ativo? (8) incentive alignment — nudges funcionando? Compliance rates melhorando? Behavior change medido?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (outcome metrics por side, interaction velocity, complaint volume por side)."
		meshImplication: "Mensal (30min): outcome metrics por side — TTV, CES, retention por persona. Interaction velocity — time from request to settlement. Complaints — volume por side, top issues. Any side deteriorating? Trimestral (2h): value proposition — conversar com 2-3 users por side. 'Por que usa? O que melhoraria?' Information architecture — disclosure matrix review. Algum dado exposto que não deveria? Reputation — trust signals ainda informativos? Percentual com badge? Se >90%: grade inflation. Power asymmetry — fornecedor PME feedback sobre fairness. Construtora feedback sobre governance. Cross-side — conversion rate, repeat rate, value units trend. Network stage — UX adequada ao estágio atual? Features de maturity construídas prematuramente? Operator — governance console cobre todos os use cases? Investigation foi possível para todos os incidents? Incentives — compliance rate trend. Payment on-time trend. Nudges com impact mensurável? Se revisão não identifica pelo menos uma melhoria por side: ou experiência é perfeita (improvável) ou revisão é superficial."
		dependsOn: ["mux-value-proposition-per-side", "mux-information-architecture-between-sides", "mux-reputation-trust-signals", "mux-power-asymmetry-design", "mux-cross-side-interaction-design", "mux-network-stage-adaptation", "mux-governance-operator-experience", "mux-incentive-aligned-ux"]
		rationale: "Sem revisão periódica, experiência de um side degrada enquanto outro é priorizado — fornecedor esquecido, construtora over-served, operator sem tools. O inventário periódico garante atenção equilibrada a todos os sides."
	},
]

reasoningProtocol: [
	{
		question:  "Cada side tem value proposition clara em 1 frase? O produto para cada side está diferenciado?"
		reveals:   "Se cada participante entende por que usar — ou se 'plataforma de supply chain' é vago para todos."
		rationale: "Parker et al. 2016: cada side vê produto diferente. Value proposition vaga = ninguém sabe por que usar."
	},
	{
		question:  "A disclosure matrix está definida? Cada side vê apenas o que precisa? Risco de disintermediation?"
		reveals:   "Se informação entre sides é calibrada — ou se dados sensíveis estão expostos ou informação útil está escondida."
		rationale: "Akerlof 1970: information design. Revelar demais = disintermediation. Revelar de menos = desconfiança."
	},
	{
		question:  "Trust signals são objetivos, multi-dimensionais e resistentes a gaming? Grade inflation?"
		reveals:   "Se reputação informa decisão — ou se todos têm 5 estrelas e signal é inútil."
		rationale: "Resnick/Zeckhauser 2002: reputação online. Bolton/Ockenfels 2012: design afeta informatividade."
	},
	{
		question:  "O lado fraco é protegido? Transparência, pricing justo, termos padronizados, liquidez?"
		reveals:   "Se plataforma rebalanceia poder — ou se otimiza para o lado forte às custas do fraco."
		rationale: "Hagiu/Wright 2015: platform rebalances power. Fornecedores insatisfeitos saem silenciosamente."
	},
	{
		question:  "A core interaction tem velocity crescente? Steps minimizados? Conversion rate estável ou crescendo?"
		reveals:   "Se a interação entre sides é fluida — ou se fricção impede value units."
		rationale: "Parker et al. 2016: core interaction. Velocity é proxy de saúde da rede."
	},
	{
		question:  "A UX é proporcional ao estágio da rede? Empty states informativos? Features de maturity adiadas?"
		reveals:   "Se experiência serve o estágio atual — ou se é sobre-engenheirada para escala que não existe."
		rationale: "Chen 2022: stages. UX de maturity no cold start é investimento com retorno zero."
	},
	{
		question:  "O operador tem governance console com visibility, control e investigation? Agent supervision?"
		reveals:   "Se quem opera a plataforma tem ferramentas — ou se opera via SQL e API calls."
		rationale: "Internal tools as product 2020+. Operador sem tools = operação lenta e error-prone."
	},
	{
		question:  "Nudges na UX estão incentivando comportamentos positivos? Compliance, pagamento on-time, engagement?"
		reveals:   "Se design alinha incentivos com saúde da rede — ou se comportamento é apenas consequência de regras."
		rationale: "Thaler/Sunstein 2008: nudge. UX que incentiva > UX que apenas impõe."
	},
]

meshExamples: [
	{
		id:       "ex-disclosure-matrix-design"
		scenario: "Mesh precisa definir quais informações cada side pode ver sobre operação de antecipação. Fornecedor quer ver taxa detalhada. Construtora quer ver volume de operações dos seus fornecedores. FIDC quer ver perfil de risco completo. Regulador quer ver tudo."
		analysis: "Conflitos de disclosure: (1) fornecedor quer ver composição da taxa (risco + spread + funding). Se vê composição: pode entender que spread da Mesh é X% e comparar com competidores. Risco: pressão sobre margem. Mas transparência de taxa constrói confiança. (2) construtora quer ver volume de operações de seus fornecedores. Se vê: sabe quanto fornecedor depende de antecipação (informação financeira sensível do fornecedor). Risco: construtora usa informação para negociar preços ('sei que você precisa antecipar, aceite meu preço'). (3) FIDC quer perfil de risco completo. Se vê dados individuais: pode fazer due diligence paralela e eventualmente desintermediar (financiar diretamente). (4) regulador: deve ver tudo — mas acesso auditável."
		recommendation: "Disclosure matrix: (1) taxa para fornecedor: mostrar taxa final (2.3%) + decomposição simplificada (taxa base + ajuste por risco + prazo). Não mostrar: margem da Mesh separadamente, funding cost. Rationale: transparência suficiente para confiança sem expor unit economics. (2) volume de fornecedores para construtora: mostrar volume agregado ('fornecedor X antecipou N operações nos últimos 3 meses') sem valor. Não mostrar: valor total antecipado, taxa praticada, % da receita do fornecedor que vem de antecipação. Rationale: construtora sabe que fornecedor é ativo na plataforma (positivo para cadeia) sem informação financeira que gere power asymmetry. (3) perfil de risco para FIDC: mostrar dados agregados de carteira (inadimplência por segmento, concentração por comprador, performance de safra). Dados de comprador: identificado por CNPJ (necessário para regulação) mas sem detalhes operacionais de fornecedores individuais. Não mostrar: detalhes de compliance de cada fornecedor, features de scoring individuais. Rationale: FIDC avalia carteira, não fornecedores individuais — reduz risco de disintermediation. (4) regulador: acesso completo sob demanda com audit trail. Formato conforme exigência normativa. (5) disclosure review: semestral. Para cada campo na matrix: ainda necessário? Disclosure expandida ou restrita?"
		principlesApplied: ["ax-01", "ax-06", "ax-07"]
		assumptions: [
			"fornecedor aceita decomposição simplificada sem ver margem da Mesh — pode questionar",
			"construtora aceita volume sem valor — pode pedir mais detalhes",
			"FIDC aceita dados agregados sem fornecedores individuais — contrato pode exigir mais",
			"disclosure matrix é implementável no backend (role-based access) — requer data-exposure-by-stakeholder",
		]
		rationale: "Bergemann/Morris 2019: information design. STI data classification. Na Mesh, cada campo de informação na interface é decisão estratégica — revelar ou esconder afeta confiança, intermediação e dinâmica de poder. A disclosure matrix é o artefato que governa."
	},
	{
		id:       "ex-reputation-anti-gaming"
		scenario: "Fornecedores descobrem que compliance_rate é dimensão de reputação que construtoras veem. Alguns fornecedores passam a submeter documentos genéricos (foto de documento alheio, PDF em branco com nome correto) para inflar compliance_rate. Taxa de documentos rejeitados sobe de 5% para 15%."
		analysis: "Gaming clássico de reputation system: métrica observável está sendo manipulada. Goodhart's Law — 'quando uma medida se torna meta, deixa de ser boa medida.' Fornecedores estão otimizando para a métrica (compliance_rate) não para o outcome (estar realmente em compliance). Causa: compliance_rate conta documentos submetidos vs requeridos, sem ponderação por validade. Documento rejeitado + resubmetido = submission counts up, rate inflada."
		recommendation: "(1) Mudar métrica: compliance_rate = documentos válidos / documentos requeridos (não submetidos). Documento rejeitado não conta como submission. Rate reflete compliance real, não effort. (2) validation rigorosa: agente LLM + rules engine valida cada documento. Documento em branco: rejeitado imediatamente com motivo 'documento ilegível.' Documento de terceiro: rejeitado com motivo 'CNPJ não confere.' Feedback imediato para fornecedor — sabe que gaming não funciona. (3) penalidade por gaming: se fornecedor submete >3 documentos rejeitados por motivo 'inválido' (não 'expirado' — expirado é legítimo): flag. Flag visível para construtora como warning: 'fornecedor com documentação sob revisão.' Não suspender imediatamente (pode ser erro genuíno) mas sinalizar. (4) positive framing: em vez de penalizar gaming, reforçar compliance real. 'Compliance rate 95% — seus documentos estão sempre válidos. Elegível para taxa preferencial.' Incentivo positivo > punição. (5) anti-gaming by design: não mostrar compliance_rate numérico. Mostrar: badge 'compliance verificada' (sim/não), com tooltips '100% documentos válidos nos últimos 90 dias.' Badge é binário — não tem gradiente para otimizar. Ou está compliant ou não. (6) monitorar: taxa de documentos rejeitados como signal de gaming. Se sobe: investigar. Se cai após mudança: medida funcionou."
		principlesApplied: ["ax-01", "ax-05"]
		assumptions: [
			"15% de rejeição é causada por gaming e não por problemas genuínos — verificar breakdown de motivos de rejeição",
			"métrica binária (badge) reduz gaming — pode reduzir informatividade para construtora",
			"agente LLM detecta documentos fraudulentos com accuracy suficiente — false positive rate?",
			"penalidade por 3+ rejeições é threshold adequado — calibrar com dados",
		]
		rationale: "Bolton/Ockenfels 2012: design de reputation afeta comportamento. Goodhart's Law: métrica como meta. Na Mesh, compliance_rate que pode ser gamada perde informatividade e destrói confiança da construtora nos trust signals — mudança de métrica + validação rigorosa + badge binário resolve."
	},
	{
		id:       "ex-power-asymmetry-pricing"
		scenario: "Construtora anchor tenant (gera 40% do volume) solicita taxa preferencial para seus fornecedores: 'queremos taxa 1.5% para nossos fornecedores, em vez de 2.5% standard.' Argumenta que traz volume. Se Mesh aceita: taxa do FIDC não cobre risco. Se recusa: construtora pode sair."
		analysis: "Power asymmetry materializada: construtora grande usa bargaining power para pressionar preço. Se Mesh aceita: (1) FIDC prejudicado (retorno menor). (2) precedente: próxima anchor tenant pedirá o mesmo. (3) fornecedores de construtoras menores pagam taxa maior — unfair. Se recusa: (1) risco de perder 40% do volume (cold start fragile). (2) construtora pode buscar factoring direto. Trade-off: short-term volume vs long-term sustainability e fairness."
		recommendation: "(1) Não aceitar taxa fixa abaixo do risco calculado. Princípio: taxa é função de risco do comprador, não de poder de barganha. Se comprador da construtora tem score 85: taxa natural é ~1.8%. Se score é 65: taxa natural é ~2.8%. Taxa preferencial por poder político: viola fairness. (2) Oferecer alternativa value-based: 'taxa é baseada em risco do comprador. Seus compradores têm score médio de 78 — taxa média para seus fornecedores já é 2.0%, abaixo do standard. Se quiser taxa menor: ajude seus compradores a melhorar score (pagar mais no prazo).' Reenquadra: taxa menor é ganhada por comportamento, não por poder. (3) Volume discount como alternativa legítima: se construtora traz volume que reduz custo operacional da Mesh: refletir em spread da Mesh (não na taxa de risco). 'Para volume >R$500k/mês: spread da Mesh reduz 0.2%.' Transparente, baseado em custo real, disponível para qualquer construtora que atinja volume. (4) Comunicar fairness: 'na Mesh, taxa é baseada em risco calculado — igual para todos. Isso protege seus fornecedores: PME com comprador bom paga a mesma taxa que fornecedor grande. Fairness é o que faz fornecedores confiarem na plataforma.' (5) Se construtora sai: aceitar a perda. 40% de volume com pricing insustentável é pior que 60% de volume com pricing saudável. Reconstruir com construtoras que valorizam fairness. Documentar: ADR 'taxa preferencial por bargaining power rejeitada — princípio de pricing risk-based preservado.'"
		principlesApplied: ["ax-01", "ax-06", "ax-05"]
		assumptions: [
			"FIDC não aceita taxa abaixo do risco — verificar contrato e margem",
			"construtora realmente sairia ou é bluff — avaliar dependência mútua",
			"volume discount de 0.2% para >R$500k/mês é sustentável — modelar unit economics",
			"fornecedores PME valorizam fairness o suficiente para preferir Mesh — assumir que sim baseado em job de fornecedor",
		]
		rationale: "Hagiu/Wright 2015: platform rebalances power. Culpepper/Thelen 2020: fairness percebida. Na Mesh, ceder a power asymmetry de anchor tenant cria precedente que destrói fairness — e fairness é o que diferencia a Mesh de factoring tradicional (onde taxa é negociação de poder, não cálculo de risco)."
	},
	{
		id:       "ex-operator-governance-console"
		scenario: "Founder precisa investigar por que inadimplência subiu de 3% para 5% no último mês. Atualmente: query SQL direto no database, cruzamento manual de tabelas, análise em spreadsheet. Tempo: 4h. Frequência: mensal."
		analysis: "Operador sem governance console: investigation manual via SQL. Problemas: (1) 4h de founder time por investigação — constraint crítico (ora-throughput-constraint). (2) risco de erro: query errada = conclusão errada. (3) não-reproduzível: próximo mês, mesma investigação do zero. (4) sem audit trail: investigação não documentada. (5) insights perdidos: se encontra causa, fix é manual e não versionado."
		recommendation: "Governance console com investigation flow: (1) dashboard de inadimplência: gráfico mensal com drill-down. Click no pico de 5%: lista de operações em default no período. (2) slicing automático: inadimplência por comprador, por segmento, por construtora, por score range, por período de originação (safra). 'Inadimplência subiu para compradores com score 60-65 originados nos últimos 3 meses.' Diagnóstico em 5 minutos, não 4h. (3) root cause candidates: sistema sugere hipóteses baseado em slicing. 'Comprador X responsável por 60% do aumento — 3 operações em default. Score no momento da aprovação: 63. Faturamento caiu 30% após aprovação (feature de faturamento era mensal).' (4) action: a partir do diagnóstico, operador pode: (a) ajustar policy — 'score mínimo para comprador X: 75 (em vez de 60).' (b) trigger retraining — 'dados de default deste mês adicionados ao training set.' (c) add rule — 'se faturamento caiu >20% após aprovação: flaggar próxima operação do comprador.' (5) todo o investigation flow é logado: timestamp, queries realizadas, diagnóstico, ações tomadas. Reproduzível e auditável. (6) custo de build: proporcional ao estágio. MVP: dashboard com gráfico + slicing em 3 dimensões. Avançado: root cause suggestions + policy editor. Build quando founder gasta >2h/semana em investigation — ROI positivo."
		principlesApplied: ["ax-01", "ax-03", "ax-07"]
		assumptions: [
			"inadimplência de 5% é significativa o suficiente para investigar — threshold depende do FIDC",
			"slicing por comprador/segmento/score revela causa — pode ser multi-causal",
			"governance console MVP é construível em semanas — depende de stack e prioridade",
			"founder gasta >2h/semana em investigation — medir antes de build",
		]
		rationale: "Internal tools as product 2020+. ORA throughput-constraint: founder time é o constraint. Na Mesh, 4h de investigação manual por mês é 4h de constraint gasto em operação que poderia ser 30min com tool adequada. Governance console não é luxury — é infraestrutura de operação."
	},
]

principleIds: ["ax-01", "ax-02", "ax-04", "ax-05", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-platform-dynamics"
		relation: "complementsWith"
		context:  "PD modela dinâmicas econômicas de plataformas (network effects, chicken-and-egg, pricing entre sides). MUX projeta a UX que materializa essas dinâmicas — core interaction design ativa NE, disclosure matrix protege intermediação, reputation signals reduzem information asymmetry. PD é a economia; MUX é a experiência."
	},
	{
		lensId:   "lens-information-economics"
		relation: "complementsWith"
		context:  "IE modela informação como ativo econômico (assimetria, adverse selection). MUX operacionaliza com disclosure matrix — quem vê o quê na interface, como signals substituem raw data. IE é a teoria; MUX é a implementação na UX."
	},
	{
		lensId:   "lens-jobs-to-be-done-and-workflow-design"
		relation: "complementsWith"
		context:  "JTBD projeta experiência de cada persona individualmente (jobs, workflows, friction, onboarding). MUX projeta a experiência na interseção entre personas (disclosure, reputation, power, cross-side interaction). JTBD é single-side; MUX é cross-side. Ambos necessários: workflow do fornecedor (JTBD) acontece no contexto de interação com construtora e FIDC (MUX)."
	},
	{
		lensId:   "lens-mechanism-design"
		relation: "complementsWith"
		context:  "MD desenha mecanismos (scoring, pricing, reputação). MUX projeta como mecanismos são apresentados na interface por side. MD diz 'reputação baseada em performance verificável'; MUX diz 'badge com 3 dimensões visível na card do fornecedor para construtora'. MD é o motor; MUX é o painel."
	},
	{
		lensId:   "lens-behavioral-economics"
		relation: "complementsWith"
		context:  "BE modela vieses cognitivos e nudge theory. MUX aplica nudges na UX para alinhar incentivos (compliance nudge, payment nudge, engagement nudge). BE é a ciência; MUX é o design. BE diz 'defaults influenciam'; MUX diz 'default de compliance é mínimo com nudge para completo'."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governa agentes. MUX operator experience materializa governance na interface — agent dashboard, override capability, investigation tools. AAG é a política; MUX é a visualização e interação."
	},
	{
		lensId:   "lens-security-trust-infrastructure"
		relation: "complementsWith"
		context:  "STI classifica dados e controla acesso. MUX disclosure matrix implementa classificação na UX — dados confidenciais não aparecem na interface de quem não deve ver. STI é a política técnica; MUX é a implementação na experiência."
	},
	{
		lensId:   "lens-stakeholder-communication"
		relation: "complementsWith"
		context:  "SC comunica com stakeholders (framing, expectation, trust). MUX aplica por side na interface — cada participante vê framing diferente do mesmo dado. SC é o princípio de comunicação; MUX é a implementação per-role."
	},
]

limitations: [
	{
		description: "Disclosure matrix assume que informação pode ser particionada entre sides. Em prática, sides se comunicam fora da plataforma — construtora pode contar taxa ao fornecedor, fornecedor pode contar volume à construtora. Disclosure é leaky."
		alternative: "Projetar para disclosure leaky: não depender de sigilo absoluto para modelo funcionar. Se fornecedor souber taxa do competidor: pricing deve ser defensável (baseado em risco, não em margem secreta). Se construtora souber volume de antecipação do fornecedor: não é catastrófico se plataforma oferece valor além de intermediação de informação."
		rationale: "Information barriers em plataformas B2B são porosos. Design deve ser robusto a leaks, não dependente de sigilo."
	},
	{
		description: "Reputation systems resistentes a gaming adicionam complexidade — validação rigorosa, badge binário, penalidades. Complexidade pode desincentivar participação se percebida como burocrática."
		alternative: "Balancear rigor com simplicidade: validação rigorosa no backend (agentes verificam), experiência simples no frontend (fornecedor submete, sistema responde). Complexidade de anti-gaming deve ser invisível para participante legítimo."
		rationale: "Anti-gaming que adiciona fricção para todos para pegar poucos gamers: net negative. Design deve punir gamers sem impactar legítimos."
	},
	{
		description: "Power asymmetry design pode alienar o lado forte (construtora anchor tenant) que subsidia a plataforma. Proteger demais o lado fraco pode fazer o lado forte sair."
		alternative: "Fairness como valor, não como punição do lado forte. Construtora anchor tenant recebe valor real (governance, compliance automática, fornecedores qualificados) — fairness para fornecedores não reduz valor para construtora. Se construtora valoriza fairness na sua cadeia: alignment natural."
		rationale: "Rebalancear poder não significa punir o lado forte. Significa dar ao lado fraco informação, liquidez e proteção — o lado forte mantém seu valor."
	},
	{
		description: "Governance console para AI-native platform é investimento significativo — investigation tools, policy editor, agent dashboard. Para solo founder pré-revenue: pode ser prematura."
		alternative: "Build proporcional ao estágio: pré-revenue: SQL + dashboards básicos (Metabase/Grafana). Tração: governance console MVP (investigation flow). Escala: full console com policy editor e agent supervision. Investir quando founder gasta >2h/semana em operation que console resolveria."
		rationale: "ORA satisficing: governance console é necessária mas proporcional. SQL para 10 operações. Console para 1000."
	},
	{
		description: "Incentive alignment via nudges assume que participantes respondem racionalmente a incentivos. Em prática, inércia, cognitive load e prioridades concorrentes reduzem eficácia de nudges."
		alternative: "Não depender apenas de nudges: combinar com defaults (compliance é default, opt-out é difícil), automation (compliance verificada automaticamente, não depende de ação do participante), e incentivos materiais (taxa preferencial, visibilidade). Nudge é complemento, não substituto."
		rationale: "Thaler/Sunstein 2008: nudges ajudam mas não resolvem. Automation + defaults + incentivos materiais são mais robustos que nudges isolados."
	},
]

rationale: "Toda plataforma multisided precisa projetar experiências na interseção entre sides com incentivos divergentes. Na Mesh como intermediário financeiro B2B com fornecedor, construtora, FIDC e regulador, a UX é onde conflitos de informação, poder e incentivos se materializam. Esta lens operacionaliza: proposta de valor por side com value unit e platform experience stack (Parker/Van Alstyne/Choudary 2016, Eisenmann et al. 2006), arquitetura de informação com disclosure matrix e information design (Akerlof 1970, Bergemann/Morris 2019, differential privacy in UX 2023+), reputação multi-dimensional platform-mediated resistente a gaming (Resnick/Zeckhauser 2002, Bolton/Ockenfels 2012, Möhlmann/Zalmanson 2017, W3C verifiable credentials 2022+), design para power asymmetry com fairness percebida (Hagiu/Wright 2015, Culpepper/Thelen 2020, platform as regulator 2022+), cross-side interaction design com managed marketplace e interaction velocity (Parker et al. 2016, managed marketplace 2022+, interaction velocity 2023+), adaptação por estágio da rede com empty state design (Chen 2022, empty state 2022+, degraded experience 2023+), governance e operator experience com internal tools as product (Retool 2020+, operator dashboard AI-native 2024+), e UX alinhada a incentivos com behavioral design e nudges B2B (Thaler/Sunstein 2008, behavioral design platforms 2023+, gamification B2B 2023+). Universal, agnóstica a estágio, aplicável a qualquer plataforma multisided."

}
