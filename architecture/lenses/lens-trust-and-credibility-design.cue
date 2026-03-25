package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// ════════════════════════════════════════════════════════════════
// lens-trust-and-credibility-design
// ════════════════════════════════════════════════════════════════

trustAndCredibilityDesign: artifact_schemas.#AnalyticalLens & {
id:     "lens-trust-and-credibility-design"
name:   "Design de Confiança e Credibilidade"

purpose: "Orientar decisões sobre como construir e manter confiança — transparência calibrada, credibilidade visual, e trust como asset cumulativo."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como construir confiança de participantes que estão transacionando com desconhecidos via plataforma",
		"a decisão envolve como demonstrar credibilidade de uma plataforma nova para participantes que nunca ouviram falar dela",
		"a decisão envolve como reduzir percepção de risco em transações financeiras digitais",
		"a decisão envolve como projetar sinais de confiança na interface (social proof, security signals, transparency)",
		"a decisão envolve como lidar com momentos de vulnerabilidade do usuário (enviar dinheiro, compartilhar dados financeiros)",
		"a decisão envolve como construir confiança entre participantes que não se conhecem pessoalmente",
		"a decisão envolve como recuperar confiança após incidente (falha de sistema, erro de dados, breach)",
		"a decisão envolve como escalar confiança — de confiança individual (1:1) para confiança institucional (na plataforma)",
		"a decisão envolve como demonstrar competência e segurança para stakeholders sofisticados (FIDC, regulador, investidor)",
		"a decisão envolve como calibrar transparência — quando mostrar mais constrói confiança vs quando mostrar mais gera ansiedade",
	]
	keywords: [
		"confiança", "trust", "credibilidade", "credibility",
		"segurança percebida", "perceived security", "safety",
		"social proof", "prova social", "depoimento", "testimonial",
		"transparência", "transparency", "openness",
		"reputação", "reputation", "track record", "histórico",
		"risco percebido", "perceived risk", "anxiety", "medo",
		"onboarding trust", "first impression", "primeira impressão",
		"institutional trust", "trust transfer", "certificação",
		"recovery", "recuperação", "incidente", "breach",
		"competência", "competence", "expertise", "profissionalismo",
		"vulnerability", "vulnerabilidade", "dados sensíveis",
		"seal", "selo", "badge", "certificado",
		"guarantee", "garantia", "escrow", "proteção",
	]
	excludeWhen: [
		"a decisão é sobre UX de plataforma multisided em geral — usar multi-sided-platform-ux",
		"a decisão é sobre governança e regras da plataforma — usar multi-sided-platform-ux (mux-governance-ux)",
		"a decisão é sobre comunicação com stakeholders estratégicos — usar stakeholder-communication",
		"a decisão é sobre segurança técnica (encryption, access control) — usar security-trust-infrastructure",
		"a decisão é sobre scoring e mecanismos de reputação formal — usar mechanism-design",
	]
	rationale: "Toda plataforma financeira opera sobre confiança — participantes enviam dinheiro, compartilham dados sensíveis, e dependem de decisões automatizadas que afetam seu negócio. Na Mesh como plataforma nova, sem histórico, operando em domínio financeiro onde fraude e desconfiança são comuns, confiança não é adquirida — é construída intencionalmente em cada interação, cada pixel, cada decisão de design. MUX cobre experiência multi-sided; SC cobre comunicação com stakeholders; STI cobre segurança técnica. Esta lens cobre como projetar a experiência que constrói, mantém e recupera confiança — desde a primeira impressão até momentos de crise. É o design da percepção de segurança, competência e integridade que faz participantes agirem quando poderiam hesitar."
}

concepts: [
	{
		id:         "tc-trust-architecture"
		name:       "Arquitetura de Confiança: Os 3 Pilares que Governam se Alguém Confia"
		nature:     "theoretical"
		role:       "framework"
		definition: "Mayer/Davis/Schoorman (1995, 'An Integrative Model of Organizational Trust'): confiança é função de 3 atributos percebidos do trustee: (1) ability — competência para fazer o que promete ('a plataforma consegue processar minha antecipação corretamente?'). (2) benevolence — intenção de agir no interesse do trustor, além do motivo egoísta ('a plataforma se importa comigo ou só quer minha taxa?'). (3) integrity — aderência a princípios que o trustor considera aceitáveis ('a plataforma é honesta sobre taxas, riscos e limitações?'). McKnight et al. (2002, 'Developing and Validating Trust Measures for e-Commerce'): em contexto digital, trust inicial (antes de experiência) depende de: institution-based trust (regulação, certificação, selos), dispositional trust (tendência pessoal de confiar), e cognition-based trust (sinais de interface — design profissional, informação clara). Conceito contemporâneo de 'trust velocity' (2023+): velocidade com que confiança é construída ou destruída. Construção: lenta (cada interação positiva adiciona um pouco). Destruição: rápida (um incidente destrói meses de construção). Assimetria fundamental: construir trust é 10x mais lento que destruir. Conceito de 'appropriate trust' (Lee/See 2004, evoluído 2024+): o objetivo não é maximizar confiança — é calibrar confiança para que corresponda à capacidade real do sistema. Over-trust (confiar mais do que o sistema merece) é tão perigoso quanto under-trust (confiar menos)."
		meshManifestation: "Na Mesh, os 3 pilares por persona: (1) fornecedor — ability: 'a Mesh vai depositar meu dinheiro corretamente e no prazo?' (demonstrar: tracking em tempo real, comprovante de depósito). Benevolence: 'a Mesh se importa com meu negócio ou sou só um número?' (demonstrar: explicação de rejeição com ação, suporte acessível, comunicação proativa). Integrity: 'a Mesh é honesta sobre taxas e condições?' (demonstrar: taxa exibida antes de submeter, sem letras miúdas, comparação com mercado). (2) construtora — ability: 'a Mesh vai gerenciar compliance dos meus fornecedores sem falhas?' Benevolence: 'a Mesh entende as necessidades da construção civil?' Integrity: 'a Mesh é transparente sobre como scoring funciona?' (3) FIDC — ability: 'a Mesh vai entregar carteira com risco conforme prometido?' Benevolence: 'a Mesh prioriza saúde da carteira ou volume a qualquer custo?' Integrity: 'os números são confiáveis e auditáveis?' (4) regulador — ability: 'a plataforma opera conforme a regulação?' Integrity: 'a plataforma é transparente sobre operações e riscos?' Trust velocity: fornecedor que recebe dinheiro correto 5x constrói trust gradualmente. 1 depósito errado destrói. FIDC que vê relatórios consistentes por 6 meses constrói trust. 1 número errado destrói."
		meshImplication: "Para cada pilar, para cada persona: (1) identificar sinais que demonstram — ability: que evidência a persona vê de que Mesh é competente? Benevolence: que evidência de que Mesh se importa? Integrity: que evidência de que Mesh é honesta? (2) projetar sinais na experiência — não dizer 'somos confiáveis' — demonstrar com design. Ability: interface profissional, processo sem erros, tracking preciso. Benevolence: explicação de rejeição com ação sugerida, suporte rápido, comunicação que antecipa necessidade. Integrity: taxa transparente, termos claros, métricas auditáveis. (3) proteger contra trust destruction: identificar momentos onde trust é mais frágil (primeira transação, primeiro erro, primeira rejeição) e projetar com extra cuidado. (4) calibrar para appropriate trust: não prometer mais do que pode entregar. Se TTV realista é 3 dias: dizer 3 dias, não '24h'. Se scoring tem limitação: documentar. Over-promise que não se cumpre destrói trust mais que under-promise que superdelivers. (5) medir trust: NPS como proxy. Trust survey periódico: 'quão confiante você está de que a Mesh processará sua operação corretamente? 1-10.' Segmentar por persona e por tempo de uso (trust deve crescer com experiência)."
		rationale: "Mayer et al. 1995: ability + benevolence + integrity. McKnight et al. 2002: trust em e-commerce. Trust velocity 2023+: assimetria construir/destruir. Appropriate trust Lee/See 2004. Na Mesh, fornecedor PME enviando documentos financeiros para plataforma nova precisa de evidência dos 3 pilares — sem isso, não age."
	},
	{
		id:         "tc-first-impression-trust"
		name:       "Trust de Primeira Impressão: Os Primeiros 30 Segundos Decidem"
		nature:     "theoretical"
		role:       "property"
		definition: "Lindgaard et al. (2006, 'Attention Web Designers: You Have 50 Milliseconds to Make a Good First Impression!'): usuários formam julgamento sobre credibilidade de website em <50ms baseado em design visual. Fogg (2003, Stanford Web Credibility Research): 46.1% dos julgamentos de credibilidade são baseados em design (layout, tipografia, cor, qualidade visual). Se o design parece amador: baixa credibilidade independente do conteúdo. Conceito de 'trust cues hierarchy' (2022+): em contexto de fintech/financeiro: (1) design profissional (baseline — se falha aqui, nada mais importa). (2) social proof (outros usam e confiam). (3) institutional signals (regulado, certificado, parceiro reconhecido). (4) transparency (informação clara sem esconder). (5) track record (dados de performance). Conceito contemporâneo de 'trust in AI-first products' (2024+): desafio adicional — participante confia não apenas na plataforma mas em decisões tomadas por IA. 'Um algoritmo decidiu que minha antecipação foi rejeitada?' Requer explicabilidade (ml-explainability), transparência sobre papel da IA, e recurso humano."
		meshManifestation: "Na Mesh, primeira impressão por touchpoint: (1) landing page / convite — fornecedor recebe convite da construtora. Primeiros 5 segundos: design profissional? Parece fintech legítima ou scam? Logo, tipografia, qualidade visual são sinais imediatos. (2) signup — formulário simples e seguro? HTTPS visível? Campos mínimos? Ou formulário de 20 campos que parece phishing? (3) primeira operação — simulador de taxa é transparente? Processo é guiado ou confuso? Feedback é imediato ou silêncio? (4) primeiro contato com IA — 'agente validou seus documentos em 30 segundos.' Impressionante ou assustador? Depende de como é comunicado: 'documentos validados por IA + revisão automática de compliance' é diferente de 'processado automaticamente' (primeiro explica, segundo é opaco). Para FIDC: primeira impressão é o portal — se é planilha Excel: trust zero. Se é dashboard profissional com dados auditáveis: trust inicial. Para investidor: pitch deck e site. Consistência visual entre pitch e produto é sinal de competência."
		meshImplication: "Projetar cada primeiro touchpoint como momento de trust: (1) design como baseline de trust — investir em design profissional nos primeiros touchpoints (landing page, signup, email de convite, primeira tela após login). Não precisa ser sofisticado — precisa ser profissional, limpo, sem erros. Erros de português, layout quebrado, imagens genéricas destroem trust imediatamente. (2) social proof no momento certo — no convite: 'sua construtora [nome] e [N] fornecedores já usam Mesh.' No signup: '[X] operações processadas com sucesso.' Na primeira operação: 'operações são processadas em média em [Y] minutos.' Números reais — não inventados. Se pré-revenue: 'construído com [parceiro/tecnologia reconhecida]' como proxy. (3) institutional signals — 'regulado por [autoridade]' (quando aplicável). 'Parceiro [banco/FIDC reconhecido].' 'Dados protegidos com [certificação].' Posicionar onde ansiedade é maior (antes de enviar documentos financeiros, antes de primeira operação). (4) transparency como trust signal — taxa visível antes de qualquer ação. Termos claros e curtos (não 50 páginas de juridiquês). 'Como funciona' em 3 steps visuais. FAQ com perguntas reais. (5) AI transparency — 'documentos validados por inteligência artificial com supervisão humana.' 'Decisões de crédito baseadas em modelo de scoring com explicação disponível.' Não esconder que IA toma decisões — comunicar com transparência e com recurso humano disponível. Anti-pattern: landing page que diz 'plataforma líder em supply chain finance' (nenhuma evidência) com stock photos e sem número real — grita 'não confie em mim'."
		dependsOn: ["tc-trust-architecture"]
		crossDependsOn: [{
			lensId:    "lens-stakeholder-communication"
			conceptId: "sc-signaling-theory"
			context:   "SC modela signaling — ações custosas que comunicam qualidade. TC first impression usa sinais custosos: design profissional (custa investimento real), números reais de operações (custa ter operado), certificação (custa processo regulatório). SC diz 'sinais custosos são críveis'; TC diz 'os primeiros sinais que o participante vê devem ser custosos — design profissional, não stock photos'."
		}]
		rationale: "Lindgaard et al. 2006: 50ms para primeira impressão. Fogg 2003: 46% de credibilidade é design. Trust cues hierarchy 2022+. Trust in AI-first 2024+. Na Mesh, fornecedor PME que recebe convite por WhatsApp decide em 5 segundos se clica ou ignora — design do convite, da landing page, e do signup são a primeira e possivelmente última chance."
	},
	{
		id:         "tc-vulnerability-moments"
		name:       "Momentos de Vulnerabilidade: Quando o Usuário Está Mais Exposto e Mais Atento"
		nature:     "theoretical"
		role:       "property"
		definition: "Conceito de 'moments of truth' (Carlzon 1987, evoluído para digital 2020+): momentos onde a experiência define a relação — o cliente está atento, emotivo, e a interação forma memória duradoura. Em fintech, moments of truth são moments of vulnerability: quando o usuário expõe algo valioso (dados financeiros, dinheiro, decisão que afeta negócio). Conceito contemporâneo de 'anxiety gradient in financial UX' (2023+): a ansiedade do usuário cresce proporcionalmente ao valor em risco na interação. Upload de CNPJ: baixa ansiedade. Upload de balanço: média. Submeter operação de R$100k: alta. Esperar dinheiro que não chegou: crítica. Design deve investir cuidado proporcional à ansiedade — mais informação, mais feedback, mais controle, mais sinais de segurança nos momentos de alta ansiedade. Conceito de 'progressive trust building' (2022+): não pedir vulnerabilidade máxima no início. Construir trust com interações de baixo risco antes de pedir interações de alto risco. Signup (baixo risco) → upload de documentos (médio) → primeira operação pequena (médio-alto) → operações grandes (alto)."
		meshManifestation: "Na Mesh, momentos de vulnerabilidade ranqueados por ansiedade: (1) share dados financeiros (upload de documentos, faturamento, balanço) — 'estou entregando informação sensível para plataforma que não conheço.' Anxiety: alta. Design: explicar por que cada documento é necessário, mostrar política de privacidade inline, comunicar proteção de dados. (2) primeira operação de antecipação — 'estou dependendo desta plataforma para receber R$50k.' Anxiety: muito alta. Design: simulação antes de confirmar, confirmação explícita com resumo ('você receberá R$48.850 em sua conta XX em até 24h'), tracking em tempo real após submissão. (3) espera após aprovação — 'foi aprovado mas cadê meu dinheiro?' Anxiety: crítica (escalona com tempo). Design: notificação a cada mudança de status, ETA explícito, contato de suporte visível ('não recebeu? Fale conosco'). (4) rejeição — 'fui rejeitado, será que sou ruim? Meu comprador é ruim? Perdi meus dados?' Anxiety: emocional (frustração + incerteza). Design: explicação clara + fatores + ação + recurso (mux-governance-ux + ml-explainability). (5) erro ou inconsistência — 'o valor depositado é diferente do que esperava.' Anxiety: pânico. Design: canal imediato de resolução, reconhecimento rápido do erro, correção com timeline."
		meshImplication: "Para cada momento de vulnerabilidade: (1) mapear — listar todos os momentos onde participante está exposto (dados, dinheiro, decisão). Ranquear por anxiety level (low/medium/high/critical). (2) investir design proporcionalmente — moments de low anxiety: design padrão suficiente. Moments de high/critical anxiety: design extra — mais informação contextual, mais feedback, mais sinais de segurança, mais controle (opção de cancelar, confirmar, pausar). (3) antecipar ansiedade com informação — antes de cada moment de vulnerabilidade: comunicar o que vai acontecer, o que é esperado do usuário, e o que acontece se algo der errado. 'Ao submeter esta operação: (a) documentos serão validados em <1 minuto. (b) score será calculado automaticamente. (c) se aprovado: dinheiro em <24h. (d) se rejeitado: explicação + opção de recurso.' Informação reduz ansiedade. (4) feedback durante, não apenas depois — durante operação: progress bar ('validando documentos...' → 'calculando score...' → 'aprovado!'). Não tela branca por 30 segundos — cada segundo sem feedback amplifica ansiedade. (5) recovery design: se algo dá errado em momento de alta vulnerability (depósito errado, timeout durante operação): response time de suporte é SLO crítico. <1h para issue financeiro. <4h para issue operacional. Reconhecer erro imediatamente, mesmo antes de ter solução: 'identificamos um problema com sua operação — estamos investigando. Update em 30 minutos.' Silêncio em momento de pânico destrói trust irreversivelmente. (6) progressive trust: primeira operação com cap de valor baixo (jtbd-automation-human-balance). Fornecedor testa com R$10k. Se funciona: confiança para R$50k. Se funciona: R$100k. Não pedir R$200k na primeira operação. Anti-pattern: tela de 'processando' por 45 segundos sem feedback durante operação de R$80k — fornecedor pensa que travou, fechou o browser, perdeu dados."
		dependsOn: ["tc-trust-architecture", "tc-first-impression-trust"]
		crossDependsOn: [{
			lensId:    "lens-behavioral-economics"
			conceptId: "be-loss-aversion"
			context:   "BE modela loss aversion — perdas são sentidas 2x mais que ganhos equivalentes. TC vulnerability moments são onde loss aversion é mais intensa — fornecedor que pode perder R$50k sente ansiedade desproporcional ao potencial ganho. BE é o modelo; TC é o design que mitiga ansiedade nos momentos onde loss aversion é máxima (feedback, controle, informação)."
		}]
		rationale: "Carlzon 1987: moments of truth. Anxiety gradient 2023+: ansiedade proporcional ao valor em risco. Progressive trust building 2022+. Na Mesh, cada momento onde fornecedor expõe dados ou dinheiro é momento onde trust é testada — design nesses momentos determina se fornecedor volta ou abandona."
	},
	{
		id:         "tc-social-proof-mechanisms"
		name:       "Mecanismos de Prova Social: Outros Confiam, Logo Eu Posso Confiar"
		nature:     "theoretical"
		role:       "method"
		definition: "Cialdini (2006, Influence, revised ed.): social proof é heurística onde pessoas usam comportamento de outros como guia para seu próprio comportamento. Em incerteza, 'se outros estão fazendo, deve ser bom.' Eficaz quando: (1) incerteza é alta (plataforma nova, domínio desconhecido). (2) proof vem de similares (fornecedor confia em depoimento de outro fornecedor mais que de investidor). (3) números são específicos (1.247 operações > 'milhares de operações'). Conceito contemporâneo de 'B2B social proof' (2023+): em B2B, social proof é diferente de B2C. Não é número de downloads ou likes — é: (a) logos de empresas reconhecidas que usam. (b) case studies com métricas verificáveis ('fornecedor X reduziu custo de antecipação em 35%'). (c) referência de pessoa para pessoa (CEO recomenda para outro CEO). (d) dados agregados de uso (volume transacionado, número de operações). Conceito de 'earned vs manufactured social proof' (2024+): social proof earned (baseada em uso real, métricas verificáveis) é mais crível que manufactured (depoimentos escritos pela empresa, números inflados). Em fintech: social proof manufactured destrói credibilidade se descoberta."
		meshManifestation: "Na Mesh, social proof por estágio: (1) pré-revenue — nenhuma operação real. Social proof escassa. Proxy: parceiros e advisors reconhecidos, tecnologia (parceria com Anthropic/Claude como AI partner), equipe com credenciais relevantes, construtoras que sinalizaram intenção. (2) early revenue (<100 operações) — números pequenos mas reais. 'R$2.3M em antecipações processadas com sucesso. Taxa média: 2.4%. Tempo médio de aprovação: 23 minutos.' Números pequenos mas específicos e verificáveis > números grandes genéricos. (3) tração (100-1000 operações) — case studies. 'Fornecedor [nome, com permissão] reduziu custo de antecipação de 4.2% para 2.5% — economia de R$127k em 6 meses.' Construtora: 'reduziu tempo de qualificação de fornecedores de 15 dias para 2 dias.' (4) escala (>1000 operações) — dados agregados como social proof. 'R$50M+ transacionados. 200+ fornecedores. 15 construtoras. Inadimplência: 1.8%.' Benchmark de mercado publicado como content (dq-data-accumulation-strategy)."
		meshImplication: "Social proof como prática de design: (1) números reais, nunca inflados — se 47 operações foram processadas, dizer 47. Não 'dezenas'. Número específico é mais crível que arredondado. Em fintech: descobrir número inflado = destruição de trust irreversível. (2) posicionar onde ansiedade é maior — no signup: '[N] fornecedores já usam.' Na primeira operação: '[N] operações processadas com sucesso, R$[X]M.' Na espera: 'tempo médio de depósito: [X] horas.' (3) social proof de similares — fornecedor PME confia mais em depoimento de outro fornecedor PME que de construtora grande. Segmentar proof por persona e porte. (4) case study como asset — a cada milestone (primeiro fornecedor que antecipou R$100k, primeiro que voltou para segunda operação): capturar como case study com permissão. Formato: problema → solução → resultado com números. (5) B2B referral — o social proof mais poderoso em B2B é referência de pessoa para pessoa. Programa: 'indique outro fornecedor → se ele usar → [benefício].' Não por desconto — por reconhecimento ('fornecedores que indicam: [badge de referência]'). (6) institutional proof — quando regulação/certificação for obtida: exibir prominentemente. Logo de parceiro reconhecido (banco, FIDC, certificadora). 'Operações registradas em [registradora].' Anti-pattern: seção de 'depoimentos' com fotos de stock e nomes genéricos ('João, empresário satisfeito') — grita manufactured."
		dependsOn: ["tc-trust-architecture", "tc-first-impression-trust"]
		crossDependsOn: [{
			lensId:    "lens-stakeholder-communication"
			conceptId: "sc-commitment-credibility"
			context:   "SC modela commitment credibility — promessas críveis por sinais custosos. TC social proof é mecanismo de credibilidade — números verificáveis, case studies com nomes reais, certificações que custaram processo. SC diz 'commitments devem ser backed por sinais custosos'; TC diz 'social proof crível é earned (operações reais) não manufactured (depoimentos falsos)'."
		}]
		rationale: "Cialdini 2006: social proof. B2B social proof 2023+: logos, case studies, referrals. Earned vs manufactured 2024+. Na Mesh pré-revenue, social proof é escassa — proxy (parceiros, equipe, tecnologia) até earned proof (operações reais) acumular. Nunca manufactured."
	},
	{
		id:         "tc-transparency-calibration"
		name:       "Calibração de Transparência: Quando Mostrar Mais Constrói Trust vs Quando Gera Ansiedade"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Transparência não é binário (total vs opaco) — é espectro calibrado por contexto. Excesso de transparência pode gerar: (1) ansiedade — mostrar todos os passos de validação de compliance em tempo real pode assustar ('por que estão verificando tantas coisas?'). (2) overload — mostrar 50 métricas no dashboard de FIDC sobrecarrega. (3) gaming — revelar scoring model completo permite gaming. Transparência insuficiente gera: (1) desconfiança — 'o que estão escondendo?' (2) frustração — 'por que fui rejeitado? ninguém explica.' (3) risco regulatório — LGPD Art. 20 exige explicação. Conceito de 'calibrated transparency' (2023+): para cada tipo de informação e cada persona: qual nível de detalhe maximiza trust sem gerar efeitos negativos? Conceito de 'transparency paradox' (Bernstein 2012, 'The Transparency Paradox'): excesso de transparência pode reduzir performance — trabalhadores monitorados excessivamente performam pior. Em plataformas: participantes excessivamente monitorados sentem-se vigiados, não protegidos."
		meshManifestation: "Na Mesh, calibração por informação × persona: (1) taxa — transparência máxima. Fornecedor vê taxa exata antes de submeter, com decomposição se possível. Esconder taxa = desconfiança imediata. Fintech que esconde custo é inaceitável. (2) scoring — transparência calibrada. Fornecedor vê: decisão + top fatores + o que mudaria (ml-explainability layers 1-2). Não vê: score numérico exato, features com pesos, thresholds (gaming risk). FIDC vê: score + distribuição + performance do modelo. Regulador vê: tudo. (3) processo de validação — transparência moderada. Fornecedor vê: 'documentos validados ✓' (resultado). Não vê: log detalhado de cada verificação de compliance que o agente fez (gera ansiedade, não trust). Se fornecedor quer mais detalhes: on-demand ('ver detalhes da validação'). (4) performance da plataforma — transparência seletiva. Publicar: volume transacionado, inadimplência, tempo médio de processamento (social proof + trust). Não publicar: detalhes de incidentes de segurança que foram mitigados sem impacto (gera ansiedade desnecessária). Publicar incidentes com impacto: transparência total + post-mortem (tc-trust-recovery). (5) dados de outros participantes — transparência mínima. Fornecedor não vê dados de outros fornecedores. Construtora não vê dados financeiros de fornecedores. Agregações anônimas quando útil."
		meshImplication: "Regra de calibração: (1) para cada informação: perguntar 'se o participante vê isso: (a) confia mais? (b) decide melhor? (c) pode usar para gaming? (d) pode ficar mais ansioso sem necessidade?' Se (a)+(b) sim e (c)+(d) não: transparência. Se (c) ou (d) sim: calibrar (agregar, simplificar, ou on-demand). (2) layers de transparência: layer 1 (default): resultado + motivo principal. Layer 2 (on-demand): detalhes + fatores. Layer 3 (regulatory): tudo. Cada participante começa em layer 1; acessa layer 2 se quiser; layer 3 é para regulador/auditor. (3) transparência de processo, não de mecanismo: mostrar que scoring funciona (resultado transparente, explicação de fatores) sem mostrar como scoring funciona (modelo, features, pesos). Analogia: restaurante mostra o prato servido (resultado), não a receita secreta (mecanismo). (4) proactive transparency para positivo: 'sua taxa caiu de 2.8% para 2.3% porque o perfil de pagamento do seu comprador melhorou.' — proativo, positivo, constrói trust. (5) reactive transparency para negativo: quando algo dá errado, ser transparente rapidamente é melhor que esconder: 'identificamos um atraso na liquidação — causa: processamento do banco. ETA atualizado: amanhã 10h. Pedimos desculpas.' Anti-pattern: transparência seletivamente conveniente — mostrar números bons (volume) e esconder números ruins (inadimplência). Quando participante descobre: trust destruída por percepção de manipulação."
		dependsOn: ["tc-trust-architecture", "tc-vulnerability-moments"]
		crossDependsOn: [{
			lensId:    "lens-ml-ai-systems-design"
			conceptId: "ml-explainability"
			context:   "ML define 3 layers de explicabilidade (global, local, contrastivo). TC transparency calibration governa qual layer cada persona vê por default: fornecedor vê layer 1-2 (contrastivo + fatores), regulador vê layer 3 (SHAP completo). ML é a implementação técnica; TC é o design de quem vê o quê para maximizar trust sem habilitar gaming."
		}]
		rationale: "Calibrated transparency 2023+. Bernstein 2012: transparency paradox. Na Mesh, transparência de taxa é obrigatória (esconder custo é inaceitável em fintech). Transparência de scoring é calibrada (explicar fatores sem revelar modelo). Transparência de incidentes positivos é proativa; de negativos é reativa e rápida."
	},
	{
		id:         "tc-trust-recovery"
		name:       "Recuperação de Confiança: Quando Algo Dá Errado, Como Reconstruir"
		nature:     "operational"
		role:       "method"
		reviewCadence: "event-driven"
		definition: "Conceito de 'service recovery paradox' (Tax/Brown/Chandrashekaran 1998): em alguns casos, cliente que experimenta falha + boa recovery fica mais satisfeito que cliente que nunca experimentou falha. A recovery bem-feita demonstra ability, benevolence e integrity simultaneamente. Grönroos (2007, Service Management): recovery eficaz requer: (1) speed — reconhecer e agir rapidamente. (2) apology — pedir desculpas genuinamente. (3) empowerment — resolver sem burocracia (agente autorizado a compensar). (4) explanation — explicar o que aconteceu e o que será feito para prevenir. (5) follow-up — confirmar que foi resolvido e que não se repetiu. Conceito contemporâneo de 'incident communication for trust' (Atlassian Statuspage 2020+, PagerDuty 2022+): em produtos digitais, comunicação durante incidente é mais importante que a resolução para trust — participantes toleram falhas se: sabem que a empresa sabe, sabem o que está acontecendo, e sabem quando será resolvido. Silêncio durante incidente é o que destrói trust, não a falha em si."
		meshManifestation: "Na Mesh, cenários de falha e recovery: (1) depósito atrasado — fornecedor esperava dinheiro às 10h, são 15h e não recebeu. Causa: banco processou com delay. Recovery: (a) notificação proativa às 10:30 ('identificamos atraso — ETA: 16h'). (b) explicação ('processamento bancário fora do horário habitual'). (c) follow-up às 16h ('depositado — confirmação: [comprovante]'). (d) post-incident: 'pedimos desculpas pelo atraso. Para evitar no futuro: estamos priorizando Pix como canal de liquidação.' (2) score errado — modelo calculou score com feature desatualizada (freshness issue). Operação que deveria ser aprovada foi rejeitada. Recovery: (a) reconhecer ('identificamos que sua operação foi avaliada com dados desatualizados'). (b) corrigir ('recalculamos: operação aprovada. Liquidação inicia imediatamente'). (c) compensar (prioridade na fila de liquidação). (d) prevenir (fix no feature store). (3) data breach — dados de fornecedor expostos. Recovery: (a) notificação imediata (LGPD exige). (b) explicação do que foi exposto e o que não foi. (c) ações tomadas (reset de credenciais, investigação). (d) follow-up (resultado da investigação, medidas preventivas). (e) para regulador: relatório completo."
		meshImplication: "Protocolo de recovery em 5 steps: (1) detect + acknowledge (<30min para issue financeiro, <2h para operacional) — não esperar ter solução para comunicar. 'Identificamos [problema]. Estamos investigando. Próximo update em [X].' (2) explain — o que aconteceu, por que aconteceu (se sabemos), o que estamos fazendo. Linguagem clara, não técnica. 'O depósito atrasou porque o banco processou fora do horário habitual' — não 'houve um timeout no webhook de settlement.' (3) resolve — resolver o mais rápido possível. Empowerment: agente autorizado a re-processar operação, priorizar liquidação, ou compensar sem escalação para humano (dentro de limites). (4) compensate (se aplicável) — não necessariamente financeiro. Pode ser: prioridade na próxima operação, waiver de taxa na próxima, ou simplesmente um 'obrigado pela paciência' genuíno. Compensação desproporcional ao dano pode parecer culpa ('o que estão escondendo?'). (5) prevent + follow-up — comunicar o que foi feito para que não se repita. 'Implementamos [medida]. Monitoraremos por 30 dias.' Follow-up em 30 dias: 'conforme prometido — incidente não se repetiu.' O follow-up é o que demonstra que a empresa realmente se importou, não apenas gerenciou a crise. Para cada tipo de incidente: playbook pré-definido no mesh-spec com: quem comunica, o que comunica, para quem, em que timeline, e quem resolve. Playbook testado trimestralmente (fire drill). Anti-pattern: silêncio durante incidente ('não vamos alarmar') seguido de comunicação tardia ('houve um problema na semana passada...') — participante descobre por conta e conclui que a plataforma ou não percebeu ou escondeu."
		dependsOn: ["tc-trust-architecture", "tc-vulnerability-moments", "tc-transparency-calibration"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-incident-management"
			context:   "OOI define incident management lifecycle (detect → triage → resolve → post-mortem). TC trust recovery define o componente de comunicação do incident — como cada persona é notificada, o que é comunicado, e como follow-up acontece. OOI é o processo técnico; TC é a experiência do participante durante o incidente. OOI detecta e resolve; TC comunica e reconstrói trust."
		}]
		rationale: "Tax et al. 1998: service recovery paradox. Grönroos 2007: 5 elements de recovery. Incident communication 2020+/2022+. Na Mesh, incidentes são inevitáveis — o que determina se trust sobrevive é a qualidade da recovery, não a ausência de falhas. Silêncio é o destruidor; comunicação rápida e honesta é o reconstrutor."
	},
	{
		id:         "tc-institutional-trust-building"
		name:       "Construção de Trust Institucional: De 'Confio na Pessoa' para 'Confio na Plataforma'"
		nature:     "theoretical"
		role:       "framework"
		definition: "Zucker (1986, 'Production of Trust: Institutional Sources of Economic Structure'): três modos de produção de trust: (1) process-based — trust construída por interação repetida (cada operação bem-sucedida adiciona trust). (2) characteristic-based — trust baseada em similaridade (construtora confia em plataforma fundada por alguém do setor). (3) institution-based — trust transferida de instituição reconhecida (regulação, certificação, parceiro conhecido). Conceito de 'trust scaling problem' (2022+): no early-stage, trust é pessoal — 'confio porque conheço o fundador.' Para escalar: trust precisa ser institucional — 'confio porque a plataforma é regulada, tem track record, e outros confiam.' Transição: person-based → process-based → institution-based. Conceito contemporâneo de 'trust infrastructure' (2024+): combinação de mecanismos que produzem trust em escala — scoring como mecanismo de trust (não apenas de risco), audit trail como mecanismo de accountability, governance transparente como mecanismo de fairness. A plataforma é a trust infrastructure que permite que desconhecidos transacionem."
		meshManifestation: "Na Mesh, transição de trust: (1) pré-revenue (person-based) — 'confio porque o Leo me explicou como funciona.' Anchor tenants confiam na pessoa do founder. Não escala. (2) early revenue (process-based) — 'confio porque já fiz 5 operações e todas deram certo.' Cada operação bem-sucedida é evidência. Mas confiança é individual (cada fornecedor precisa ter suas 5 operações). (3) tração (institution-based emerging) — 'confio porque 200 fornecedores usam, porque é regulado, porque a construtora [conhecida] usa.' Trust transferida de instituições e grupo social. (4) escala (institution-based) — 'confio porque a Mesh é a infraestrutura — como confio no Pix porque o Bacen garante.' Trust é na plataforma, não na pessoa. Mecanismos: scoring como trust signal ('se a Mesh diz que o comprador é confiável, provavelmente é'), audit trail como accountability ('cada operação é rastreável'), governance como fairness ('regras são claras e iguais para todos')."
		meshImplication: "Projetar para transição de trust: (1) pré-revenue: aceitar que trust é pessoal. Founder como face da plataforma. Reunião 1:1 com primeiros anchor tenants. Cada interação pessoal constrói trust que habilita primeira operação. (2) early revenue: automatizar construction de process-based trust. Cada operação bem-sucedida é comunicada como evidence: '5ª operação completada com sucesso. Tempo médio: 23 minutos. Total antecipado: R$230k.' Números crescentes são social proof pessoal. (3) tração: investir em institutional signals. Regulação (quando obtida): exibir proeminentemente. Parceiros reconhecidos: logos na landing page. Press/content: publicação em mídia relevante. Track record publicado: volume, inadimplência, tempo médio. (4) escala: plataforma é trust infrastructure. Scoring é mecanismo de trust que construtora usa para confiar em fornecedor e FIDC usa para confiar em carteira. Mesh não precisa de Leo dizendo 'este comprador é bom' — scoring diz, com dados, de forma auditável. (5) cada estágio coexiste: mesmo em escala, process-based (experiência repetida constrói trust pessoal) reforça institution-based. Não abandonar person-based por completo — suporte humano disponível demonstra que há pessoas por trás da plataforma. Anti-pattern: tentar institution-based trust antes de ter process-based — 'somos regulados pelo Bacen' sem ter 1 operação real. Instituição valida competência — mas competência precisa existir antes de ser validada."
		dependsOn: ["tc-trust-architecture", "tc-social-proof-mechanisms"]
		crossDependsOn: [{
			lensId:    "lens-mechanism-design"
			conceptId: "md-reputation-systems"
			context:   "MD projeta mecanismos de reputação como scoring e rating. TC institution trust usa esses mecanismos como trust infrastructure — scoring não é apenas mecanismo de risco (para FIDC) mas mecanismo de trust (para construtora: 'se Mesh diz que fornecedor é qualificado, confio'). MD projeta o mecanismo; TC projeta como o mecanismo é percebido como fonte de trust."
		}]
		rationale: "Zucker 1986: 3 modos de produção de trust. Trust scaling problem 2022+: person → process → institution. Trust infrastructure 2024+: scoring + audit + governance como mecanismos de trust. Na Mesh, a transição de 'confio no Leo' para 'confio na Mesh' é a transição que habilita escala — cada estágio requer investimento diferente em sinais de trust."
	},
	{
		id:         "tc-trust-in-ai-decisions"
		name:       "Trust em Decisões de IA: Quando o Algoritmo Decide, Como o Humano Confia?"
		nature:     "theoretical"
		role:       "property"
		definition: "Conceito de 'algorithm aversion' (Dietvorst et al. 2015, 'Algorithm Aversion: People Erroneously Avoid Algorithms After Seeing Them Err'): humanos perdem confiança em algoritmos mais rapidamente que em humanos — mesmo que o algoritmo performe melhor no agregado. Um erro do algoritmo é sentido como 'sistema quebrado'; um erro humano é 'humanamente compreensível.' Conceito de 'algorithm appreciation' (Logg et al. 2019): em contraste, em alguns contextos (previsão objetiva, dados complexos), pessoas preferem algoritmos a humanos. O contexto determina aversion vs appreciation. Conceito contemporâneo de 'human-AI trust calibration' (2024+): projetar interação para que humano tenha trust calibrada na IA — nem over-trust (aceitar tudo sem questionar — automation bias) nem under-trust (rejeitar porque 'é máquina'). Mecanismos: (1) explicabilidade (ml-explainability) — 'por que o algoritmo decidiu isso?' (2) track record — 'o algoritmo acertou em X% dos casos.' (3) human recourse — 'não concorda? Humano pode revisar.' (4) graceful uncertainty — IA comunica quando não tem certeza ('confidence baixa — recomendamos revisão')."
		meshManifestation: "Na Mesh AI-native, IA toma decisões consequentes: (1) scoring — agente IA decide se antecipação é aprovada ou rejeitada. Fornecedor rejeitado: 'um algoritmo decidiu que meu comprador não é confiável?' Potential algorithm aversion. Mitigação: explicação contrastiva + recurso humano. (2) compliance — agente IA valida documentos. Construtora: 'como sei que a IA não aprovou documento falso?' Potential under-trust. Mitigação: auditoria periódica com resultado publicado ('99.5% de accuracy em validação de documentos — auditoria trimestral com sample de 200 documentos'). (3) pricing — taxa calculada por modelo. Fornecedor: 'como sei que a taxa é justa e não arbitrária?' Mitigação: transparência de fórmula (benchmark + risco + spread) + comparação com mercado. (4) matching — agente sugere fornecedores para construtora. Construtora: 'como sei que a sugestão é baseada em qualidade e não em quem paga mais?' Mitigação: transparência de critérios ('sugerido por: segmento compatível, compliance em dia, performance >90%')."
		meshImplication: "Trust em IA por design: (1) framing — não dizer 'IA decidiu.' Dizer 'análise baseada em dados decidiu' ou 'seu comprador foi avaliado com base em histórico de pagamento, faturamento e compliance.' Humanos confiam em dados mais que em algoritmos. (2) explicabilidade como trust mechanism — cada decisão de IA que afeta participante: explicação disponível. Rejeição: fatores + contrastivo. Aprovação: confirmação com resumo. Pricing: decomposição. (3) track record publicado — 'modelo de scoring acertou em [X]% dos casos nos últimos [Y] meses.' Publicar periodicamente. Track record demonstra competência (tc-trust-architecture: ability). (4) human recourse sempre disponível — para toda decisão de IA consequente: 'não concorda? Solicite revisão humana.' O fato de existir recourse reduz anxiety mesmo que 95% nunca use. (5) graceful uncertainty — quando IA tem confidence baixa: comunicar. 'Análise inconclusiva — encaminhamos para avaliação detalhada.' Melhor que fingir certeza e errar. (6) AI transparency in onboarding — no primeiro uso: comunicar que IA toma decisões E que humanos supervisionam E que recurso existe. Não esconder uso de IA — transparência constrói trust. Mas não enfatizar excessivamente — 'AI-powered' em toda tela é marketing, não trust. (7) progressive AI trust — primeira decisão de IA: com supervisão humana explícita ('validado por IA, confirmado por equipe'). Décima decisão: 'validado automaticamente' (confiança construída). Centésima: participante nem nota que é IA (trust institucional na plataforma). Anti-pattern: 'nossa IA infalível processa tudo automaticamente' — over-promise que será falsificada no primeiro erro, amplificado por algorithm aversion."
		dependsOn: ["tc-trust-architecture", "tc-transparency-calibration"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-hitl-calibration"
			context:   "AAG define HITL calibration — quando agente IA escala para humano. TC trust in AI usa HITL como trust mechanism: 'se IA não tem certeza, humano revisa' é sinal de integrity e ability. AAG é a política de escalação; TC é como a escalação é percebida pelo participante como sinal de trust."
		}]
		rationale: "Dietvorst et al. 2015: algorithm aversion. Logg et al. 2019: algorithm appreciation. Human-AI trust calibration 2024+. Na Mesh AI-native, cada decisão de IA que afeta fornecedor ou construtora é momento de trust — explicabilidade + track record + recourse humano são os 3 mecanismos que calibram trust para appropriate level."
	},
	{
		id:            "tc-trust-review"
		name:          "Revisão de Trust: Inventário Periódico de Confiança por Persona e Estágio"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) trust architecture — ability, benevolence, integrity percebidos por cada persona? NPS/trust score trend? (2) first impression — primeiros touchpoints profissionais? Conversão de first visit → signup? (3) vulnerability moments — feedback nos momentos de alta ansiedade? Drop-off em moments críticos? (4) social proof — números reais atualizados? Case studies novos? Referrals? (5) transparency — calibração adequada? Reclamações de opacidade ou overload? (6) recovery — incidentes no período? Recovery seguiu playbook? Follow-up feito? (7) institutional trust — transição happening? De person-based para process-based para institution-based? (8) AI trust — explicabilidade satisfaz? Reclamações de 'decisão injusta da IA'? Recourse utilizado?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: NPS e trust score por persona. Incidentes e recovery. Trimestral: análise completa."
		meshImplication: "Mensal (30min): NPS por persona — trend up/down? Trust score (survey) — trend? Incidentes no período — recovery seguiu playbook? Follow-up confirmado? Support tickets sobre trust/fairness — top complaints. Conversão first visit → signup — first impression holding? Trimestral (2h): trust architecture — ability, benevolence, integrity por persona. Qual pilar é mais fraco? First impression audit — visitar landing page, signup, primeira tela como se fosse novo. Profissional? Sinais de trust presentes? Vulnerability moments — percorrer workflow de primeira operação. Feedback em cada step? Informação suficiente? Ansiedade mitigada? Social proof — números atualizados? Novos case studies? Referrals happening? Transparency — calibração adequada? Algum dado que deveria ser mais transparente? Algum dado excessivamente transparente (gaming risk)? Recovery — playbook testado? Fire drill realizado? AI trust — % de recourse requests. Se >5%: explicabilidade insuficiente ou modelo tem problema. Se <0.1%: ou trust é excelente ou participantes não sabem que recourse existe. Institutional — em que estágio da transição person→process→institution? O que falta para o próximo estágio? Se revisão não identifica pelo menos uma ação: ou trust é perfeita (improvável) ou revisão é superficial."
		dependsOn: ["tc-trust-architecture", "tc-first-impression-trust", "tc-vulnerability-moments", "tc-social-proof-mechanisms", "tc-transparency-calibration", "tc-trust-recovery", "tc-institutional-trust-building", "tc-trust-in-ai-decisions"]
		rationale: "Trust degrada silenciosamente — NPS cai gradualmente, complaints aumentam incrementalmente, churn começa sem causa óbvia. A revisão periódica detecta erosão antes que seja irreversível."
	},
]

reasoningProtocol: [
	{
		question:  "Para cada persona: ability, benevolence e integrity estão demonstrados na experiência? Qual pilar é mais fraco?"
		reveals:   "Se trust está sendo construída equilibradamente — ou se demonstra competência (ability) mas não cuidado (benevolence), ou vice-versa."
		rationale: "Mayer et al. 1995: 3 pilares. Na Mesh, fornecedor pode ver que Mesh é competente (ability) mas não sentir que Mesh se importa (benevolence) — rejeição sem explicação."
	},
	{
		question:  "Os primeiros touchpoints (convite, landing, signup) comunicam profissionalismo e credibilidade? Em <5 segundos?"
		reveals:   "Se primeira impressão constrói trust — ou se design amador destrói credibilidade antes de qualquer interação substantiva."
		rationale: "Lindgaard et al. 2006: 50ms. Fogg 2003: 46% é design. Fornecedor PME que vê email genérico com link suspeito: não clica."
	},
	{
		question:  "Nos momentos de alta vulnerabilidade (enviar dados, submeter operação, esperar dinheiro): design investiu cuidado proporcional?"
		reveals:   "Se anxiety é mitigada nos momentos críticos — ou se os momentos mais importantes têm o design mais genérico."
		rationale: "Anxiety gradient 2023+: investir design ∝ vulnerability. Tela de 'processando' genérica durante operação de R$80k = ansiedade máxima."
	},
	{
		question:  "Social proof é real e earned? Números verificáveis, case studies com nomes, referrals orgânicos?"
		reveals:   "Se credibilidade é construída sobre evidência — ou sobre marketing vazio que será desmascarado."
		rationale: "Earned vs manufactured 2024+. Na fintech, social proof manufactured descoberta = destruição de trust irreversível."
	},
	{
		question:  "Transparência está calibrada? Taxa visível, scoring explicado suficiente (sem gaming), incidentes comunicados rapidamente?"
		reveals:   "Se transparência constrói trust sem efeitos colaterais — ou se excesso gera ansiedade ou insuficiência gera desconfiança."
		rationale: "Calibrated transparency 2023+. Taxa escondida em fintech é inaceitável. Score completo revelado é gaming risk. Calibrar por informação × persona."
	},
	{
		question:  "Existe playbook de recovery para incidentes? Comunicação em <30min? Follow-up confirmado?"
		reveals:   "Se a organização está preparada para o inevitável — ou se o primeiro incidente será gerenciado ad hoc com silêncio e demora."
		rationale: "Tax et al. 1998: recovery paradox. Na Mesh, incidentes são inevitáveis — recovery planejada > recovery improvisada."
	},
	{
		question:  "Trust está transitando de person-based para institution-based? O que falta para o próximo estágio?"
		reveals:   "Se trust escala — ou se depende do founder para cada novo participante (não escala)."
		rationale: "Zucker 1986: person → process → institution. Na Mesh, 'confio porque conheço o Leo' serve para 10 construtoras. Para 100: precisa ser 'confio na Mesh'."
	},
	{
		question:  "Decisões de IA têm explicação, track record publicado, e recourse humano? Participante sabe que IA decide?"
		reveals:   "Se trust em IA é calibrada — ou se participante over-trusts (automation bias) ou under-trusts (algorithm aversion)."
		rationale: "Dietvorst 2015: algorithm aversion. Human-AI trust 2024+. Na Mesh AI-native, cada decisão de IA é momento de trust — calibrar é obrigatório."
	},
]

meshExamples: [
	{
		id:       "ex-first-operation-trust-design"
		scenario: "Fornecedor PME está prestes a submeter primeira operação de antecipação de R$45k. Nunca usou plataforma de antecipação digital. Ansiedade alta."
		analysis: "Momento de vulnerabilidade máxima: R$45k em jogo, plataforma nova, processo desconhecido. 3 pilares em teste simultâneo: ability ('vai funcionar?'), benevolence ('e se der errado, vão me ajudar?'), integrity ('a taxa é realmente 2.5% ou tem custo escondido?'). Fornecedor busca sinais de cada pilar antes de confirmar. Se sinais são insuficientes: abandona. Se sinais são claros: submete."
		recommendation: "Projetar tela de submissão para máxima trust: (1) simulação antes de confirmar — 'Antecipação de nota fiscal #4521. Valor: R$45.000. Taxa: 2.5% (R$1.125). Você recebe: R$43.875. Prazo de pagamento do comprador: 45 dias. Depósito previsto: amanhã até 14h.' Tudo visível antes de clicar 'Confirmar.' Transparency de taxa = integrity signal. (2) comparação implícita — 'Taxa Mesh: 2.5%. Taxa típica de factoring para este perfil: 3.8-4.5%.' Demonstra value sem ser agressivo. (3) sinais de segurança — 'Dados protegidos com criptografia. Operação registrada em [registradora].' Pequenos mas presentes. Não ocupar 50% da tela — 1 linha com ícone de cadeado. (4) social proof contextual — 'Operação #1.247 na Mesh. Tempo médio de processamento: 23 minutos.' Número específico e real. (5) feedback em tempo real após confirmar — 'Operação submetida ✓' → 'Documentos validados ✓ (30s)' → 'Score calculado ✓ (15s)' → 'Operação aprovada ✓ — liquidação iniciada.' Progress bar com cada step. Não tela branca por 45 segundos. (6) pós-aprovação — 'Depósito de R$43.875 previsto para amanhã até 14h. Você será notificado quando depositado. Dúvidas? [Falar com suporte].' Suporte visível = benevolence signal. (7) se rejeitado — não 'operação negada.' Sim: 'Operação não aprovada neste momento. Motivo principal: histórico de pagamento do comprador com atraso médio de 22 dias. O que pode mudar: se comprador melhorar pagamentos. Não concorda? [Solicitar revisão humana].' Integrity + benevolence."
		principlesApplied: ["ax-01", "ax-02", "ax-04"]
		assumptions: [
			"fornecedor PME processa informação visual — simulação visual é mais eficaz que texto",
			"comparação com factoring é motivadora — pode ser irrelevante se fornecedor nunca usou factoring",
			"progress bar reduz ansiedade — pode criar ansiedade se um step demora muito (timeout visual)",
			"suporte visível é signal de benevolence — se suporte não responde em <2h: signal se inverte",
		]
		rationale: "Vulnerability moments: primeira operação é pico de ansiedade. Mayer et al. 1995: ability (funciona), benevolence (se importa), integrity (taxa transparente). Na Mesh, cada pixel da tela de primeira submissão é oportunidade de construir ou destruir trust — projetar com cuidado proporcional."
	},
	{
		id:       "ex-trust-recovery-deposit-error"
		scenario: "Fornecedor recebeu R$42.100 em vez de R$43.875. Diferença de R$1.775. Fornecedor liga para suporte em pânico: 'depositaram errado, meu dinheiro sumiu.'"
		analysis: "Momento de crise: dinheiro envolvido, fornecedor dependia do valor exato (caixa apertado), e valor errado sugere incompetência ou fraude. Trust destruction em potencial máximo. Causa possível: (1) bug no cálculo. (2) taxa foi ajustada e comunicação não chegou. (3) banco processou com dedução que Mesh não previu. (4) erro de digitação no valor. Independente da causa: fornecedor precisa de resposta imediata. Service recovery paradox: se recovery é excelente, fornecedor pode confiar mais do que antes."
		recommendation: "Recovery em 5 steps: (1) acknowledge (<10min) — 'Obrigado por nos avisar. Identificamos que há uma diferença entre o valor esperado e o depositado. Estamos investigando agora. Você terá uma resposta em no máximo 2 horas.' Tom: calmo, profissional, sem defensividade. Não dizer 'deve ser do banco' (não culpe terceiro antes de investigar). (2) investigate (1-2h) — verificar: cálculo correto? Taxa comunicada = taxa aplicada? Banco deduziu alguma taxa? Erro de pipeline? (3) explain + resolve (<2h) — cenário A (bug da Mesh): 'Identificamos um erro no cálculo da sua operação. O valor correto é R$43.875. A diferença de R$1.775 será depositada nas próximas 2 horas. Pedimos sinceras desculpas.' Cenário B (dedução do banco): 'O banco aplicou uma tarifa de processamento de R$1.775 que não estava prevista. Estamos creditando esse valor para você — depósito complementar em até 4 horas.' (4) compensate — waiver de taxa na próxima operação. Não pedir desculpas sem ação. Ação demonstra benevolence. (5) follow-up (24h depois) — 'Confirmando: o valor complementar de R$1.775 foi depositado ontem às 16h. Tomamos medidas para que isso não se repita: [medida específica]. Se precisar de qualquer coisa: [contato direto do responsável, não genérico].' Contato direto = pessoa se importa, não número de protocolo. Post-incident: ADR documentando causa, fix, e medida preventiva. Se bug: fix deployado + test case adicionado. Se banco: negociar tarifa ou incluir no cálculo."
		principlesApplied: ["ax-01", "ax-02", "ax-05"]
		assumptions: [
			"<10min de acknowledgment é factível — requer suporte com SLO de response time",
			"2h de investigação é suficiente — se causa é complexa, comunicar update intermediário",
			"waiver de taxa é compensação adequada — para fornecedor PME com caixa apertado, R$1.775 é significativo",
			"contato direto é escalável — pode não ser em escala; em early-stage, é diferenciador",
		]
		rationale: "Tax et al. 1998: recovery paradox. Grönroos 2007: speed + apology + explanation + follow-up. Na Mesh, fornecedor que recebeu R$1.775 a menos e foi tratado com velocidade, transparência e compensação pode se tornar o fornecedor mais leal — recovery excelente demonstra ability + benevolence + integrity simultaneamente."
	},
	{
		id:       "ex-ai-trust-scoring-rejection"
		scenario: "Fornecedor foi rejeitado pela segunda vez em 30 dias. Ambas as vezes por scoring do comprador. Fornecedor reclama: 'essa IA é burra, meu comprador é bom, eu trabalho com ele há 10 anos.'"
		analysis: "Algorithm aversion: fornecedor tem informação pessoal (10 anos de relação) que o modelo não captura. Fornecedor percebe IA como incompetente ('burra') porque contradiz sua experiência. Possibilidades: (1) modelo está certo — comprador tem risco que fornecedor não percebe (faturamento em queda, outros pagamentos atrasados). (2) modelo está errado — comprador é bom mas dados são insuficientes (poucos data points, feature desatualizada). (3) modelo está parcialmente certo — comprador era bom e está deteriorando (fornecedor não sabe). Independente: fornecedor precisa de: explicação que faça sentido com sua experiência, validação de que sua experiência é considerada, e caminho para resolução."
		recommendation: "(1) Explicação contextualizada: não 'score do comprador é 52.' Sim: 'Nosso modelo avaliou que o comprador [nome] apresenta alguns sinais de risco no momento: (a) pagamentos recentes com atraso médio de 18 dias (dados dos últimos 3 meses). (b) faturamento com queda de 12% no último trimestre. Sabemos que você tem relação longa com este comprador, e esses fatores podem não refletir toda a história.' Reconhece a informação do fornecedor sem invalidá-la. (2) Caminho de resolução: 'Você pode: (a) Solicitar revisão humana — nossa equipe avaliará com contexto adicional que você possa fornecer. [Solicitar revisão]. (b) Submeter novamente quando dados atualizarem — próxima atualização de faturamento do comprador: estimativa [data].' Não dead-end. (3) Revisão humana: fornecedor informa: '10 anos de relação, sempre pagou.' Humano revisa: dados de scoring + informação do fornecedor. Se modelo tem data quality issue (faturamento desatualizado): corrigir e reavaliar. Se modelo está correto mas fornecedor tem informação que modelo não captura: considerar 'soft information' como exceção com cap de valor menor + monitoramento intensificado. (4) Comunicar resultado: se aprovado após revisão: 'Após avaliação adicional com as informações que você forneceu, sua operação foi aprovada com [condições]. Monitoraremos de perto.' Se mantido rejeitado: 'Após revisão, mantemos a avaliação porque [fatores objetivos]. Se a situação do comprador melhorar, você pode tentar novamente.' (5) Feedback loop: a informação de '10 anos de relação sem problema' é dado que pode ser capturado como feature futura (relationship_tenure). Se múltiplos fornecedores reportam que modelo rejeita compradores 'bons': investigar se feature importante está missing."
		principlesApplied: ["ax-01", "ax-02", "ax-05", "ax-06"]
		assumptions: [
			"fornecedor aceita explicação com dados mesmo que contradiga experiência — pode não aceitar",
			"revisão humana em <48h é factível — depende de volume de requests",
			"'soft information' como exceção com cap é regulatoriamente aceitável — verificar com compliance",
			"relationship_tenure é feature útil para scoring futuro — validar com dados quando disponível",
		]
		rationale: "Dietvorst 2015: algorithm aversion — humanos perdem trust em algoritmo após 1 erro. Na Mesh, fornecedor que foi rejeitado 2x por 'IA burra' está a 1 interação de churn. Recovery: reconhecer experiência do fornecedor + explicar com dados + oferecer revisão humana + capturar feedback para melhorar modelo. Trust não é 'aceite a decisão da IA' — é 'entendemos que você discorda, aqui está o caminho'."
	},
	{
		id:       "ex-institutional-trust-transition"
		scenario: "Mesh opera há 18 meses com 800 operações. Founder percebe que toda construtora nova pede reunião com ele antes de aderir. Trust é person-based — não escala para 50 construtoras/ano."
		analysis: "Trust scaling problem: trust é pessoal (founder). Cada nova construtora requer investimento de tempo do founder (reunião de 1-2h). Se target é 50 construtoras/ano: 100h apenas em trust-building. Founder time é o constraint máximo (ora-throughput-constraint). Precisar escalar trust de person-based para process-based + institution-based sem eliminar person-based (ainda útil para key accounts)."
		recommendation: "(1) Process-based trust assets: (a) produto demonstra competência — landing page com números reais: '800 operações, R$15M transacionados, inadimplência 1.8%, tempo médio 23min.' Track record verificável. (b) case studies com nomes: '3 construtoras publicam resultados — [Construtora A] reduziu custo de antecipação em 35%. [Construtora B] qualificou 40 fornecedores em 2 semanas.' (c) demo gravada: vídeo de 5min mostrando dashboard de construtora, workflow de antecipação, relatório de FIDC. Disponível na landing page — construtora assiste quando quiser, sem depender de agenda do founder. (d) pilot simplificado: 'comece com 5 fornecedores por 30 dias — sem custo, sem compromisso.' Risco baixo para construtora. Process-based trust constrói durante pilot sem reunião. (2) Institution-based signals: (a) parceria com banco/FIDC reconhecido — logo na landing page. (b) regulação (quando obtida) — selo. (c) press/content — artigo em mídia do setor (construção civil). (d) advisor reconhecido do setor — nome no 'quem somos.' (3) calibrar person-based: founder faz reunião para anchor tenants (top 10 construtoras por volume potencial). Para construtoras menores: processo self-service (demo + pilot + suporte). (4) medir transição: % de construtoras que aderem sem reunião com founder. Target: 0% hoje → 30% em 6 meses → 70% em 12 meses. Se construtora adere sem reunião e retention 90d é similar às que tiveram reunião: transition happening. (5) não eliminar person-based: para key accounts, reunião com founder é differentiator. Para volume: self-service com trust assets. Ambos coexistem."
		principlesApplied: ["ax-01", "ax-03", "ax-07"]
		assumptions: [
			"demo gravada é substituto aceitável para reunião — pode não transmitir mesma confiança",
			"pilot de 30 dias sem custo é viável financeiramente — custo de onboarding vs LTV da construtora",
			"70% de adesão sem reunião é atingível em 12 meses — depende de maturidade do mercado e qualidade dos trust assets",
			"retention 90d é comparable entre self-service e reunião — construtoras self-service podem ter menor engagement",
		]
		rationale: "Zucker 1986: person → process → institution. Trust scaling 2022+. Na Mesh, founder como bottleneck de trust é risco de escala. Trust assets (case studies, demo, pilot, institutional signals) são investimento que libera founder time e habilita growth sem perder trust quality."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-05", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-stakeholder-communication"
		relation: "complementsWith"
		context:  "SC comunica com stakeholders (framing, signaling, expectation management). TC projeta a experiência que constrói trust — sinais na interface, momentos de vulnerabilidade, recovery. SC é comunicação verbal/escrita; TC é comunicação via experiência e design. SC diz 'sinal custoso é crível'; TC diz 'design profissional, números reais, explicação de rejeição são sinais custosos embeddados na experiência'."
	},
	{
		lensId:   "lens-multi-sided-platform-ux"
		relation: "complementsWith"
		context:  "MUX projeta experiência cross-side (visibility, governance, tension). TC projeta trust por side e entre sides. MUX governance UX é onde TC se manifesta — regras claras, feedback, recurso são TC applied to governance. MUX é a estrutura multi-sided; TC é o tecido de confiança que conecta os sides."
	},
	{
		lensId:   "lens-ml-ai-systems-design"
		relation: "complementsWith"
		context:  "ML projeta explicabilidade e fairness de modelos. TC traduz explicabilidade em trust — SHAP values sozinhas não constroem trust; explicação contrastiva em linguagem de negócio com recurso humano constrói. ML é a implementação técnica; TC é o design de como explicação é experienciada."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governa agentes com HITL calibration. TC usa HITL como trust mechanism — 'humano pode revisar' é sinal de integrity e benevolence. AAG é a política; TC é a percepção da política pelo participante."
	},
	{
		lensId:   "lens-mechanism-design"
		relation: "complementsWith"
		context:  "MD projeta scoring e reputação como mecanismos formais. TC projeta como esses mecanismos são percebidos como fontes de trust — scoring não é apenas risco (para FIDC) mas trust signal (para construtora: 'se Mesh qualificou, confio'). MD é o mecanismo; TC é a percepção."
	},
	{
		lensId:   "lens-behavioral-economics"
		relation: "complementsWith"
		context:  "BE modela vieses (loss aversion, algorithm aversion, social proof). TC aplica: vulnerability moments são onde loss aversion é máxima (design proporcional), algorithm aversion é mitigada por explicabilidade + recourse, social proof é mecanismo de trust. BE é o modelo; TC é o design."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI gerencia incidentes tecnicamente. TC gerencia trust durante incidentes — comunicação rápida, explicação, follow-up. OOI detecta e resolve; TC comunica e reconstrói trust. Recovery sem OOI é lenta; recovery sem TC é silenciosa."
	},
	{
		lensId:   "lens-security-trust-infrastructure"
		relation: "complementsWith"
		context:  "STI implementa segurança técnica (encryption, access control, compliance). TC comunica segurança percebida — selos, linguagem de proteção, sinais visuais. STI é a segurança real; TC é a segurança percebida. Ambas necessárias: segurança real sem percepção = participante não confia. Percepção sem segurança real = incidente inevitável."
	},
	{
		lensId:   "lens-jobs-to-be-done-and-workflow-design"
		relation: "complementsWith"
		context:  "JTBD projeta workflows por persona. TC mapeia momentos de vulnerabilidade dentro dos workflows — cada step com anxiety level e design proporcional. JTBD é o fluxo; TC é o tecido de trust dentro do fluxo. Step de 'submeter operação' é step de JTBD e vulnerability moment de TC simultaneamente."
	},
]

limitations: [
	{
		description: "Trust é subjetiva e difícil de medir diretamente — NPS e trust surveys são proxies imprecisos. Participante pode dizer que confia e ainda assim hesitar em agir."
		alternative: "Combinar métricas declarativas (NPS, trust survey) com comportamentais (conversion rate, drop-off em vulnerability moments, time to first operation, operation frequency). Comportamento é melhor proxy de trust do que declaração."
		rationale: "O que as pessoas dizem vs o que fazem frequentemente diverge. Medir ambos e triangular."
	},
	{
		description: "Framework assume que trust é construível por design. Em mercados onde desconfiança é cultural (B2B em construção civil no Brasil: relações baseadas em pessoalidade), design pode ser insuficiente sem relação pessoal."
		alternative: "Não eliminar person-based trust — complementar com process-based e institution-based. Person-based para anchor tenants (onde importa mais). Self-service com trust assets para volume (onde escala mais). Cultural awareness: em mercado relacional, suporte humano acessível é trust signal mais forte que selo na landing page."
		rationale: "Construção civil brasileira é setor relacional — 'conheço fulano' supera 'vi o selo.' Design ajuda mas não substitui relação em mercado relacional."
	},
	{
		description: "Service recovery paradox (cliente mais satisfeito após recovery) não é garantido — depende de severidade do incidente e qualidade da recovery. Para incidentes graves (data breach, perda financeira significativa), recovery raramente supera o dano."
		alternative: "Investir em prevenção mais do que em recovery. Recovery é para incidentes operacionais (atraso, erro de valor). Para incidentes graves: prevenção (STI security, OOI monitoring) é a estratégia; recovery é damage control. Não planejar 'basta ter boa recovery' para riscos graves."
		rationale: "Recovery paradox funciona para falhas operacionais, não para falhas existenciais. Atraso de depósito + boa recovery = trust preservada. Breach de dados + qualquer recovery = trust destruída para maioria."
	},
	{
		description: "Trust em IA está em evolução rápida — algorithm aversion de 2015 pode não refletir percepção de 2026 (onde IA é normalizada). Framework pode over-invest em mitigação de aversion que não existe mais."
		alternative: "Monitorar percepção de IA periodicamente. Se fornecedores não mencionam 'IA' como concern em NPS comments ou support tickets: aversion pode ter diminuído. Calibrar investimento em AI transparency proporcionalmente à percepção real, não ao modelo teórico."
		rationale: "Percepção de IA evolui rapidamente. Em 2020: 'IA decide meu crédito?!' Em 2026: 'claro, é IA.' Monitorar e adaptar."
	},
	{
		description: "Foco em trust building pode levar a over-communication — notificação a cada step, email a cada status change, follow-up após follow-up. Notificação excessiva gera fatigue, não trust."
		alternative: "Calibrar volume de comunicação: notificação para eventos que importam (aprovação, depósito, problema), não para cada micro-step. Permitir que participante configure nível de notificação (minimal, standard, verbose). Default: standard (eventos importantes). Notification fatigue destrói o benefício de proactive communication."
		rationale: "Comunicação é trust signal até o ponto onde vira noise. 3 notificações para operação de 5 steps: adequado. 10 notificações: fatigue."
	},
]

rationale: "Toda plataforma financeira opera sobre confiança — participantes enviam dinheiro, compartilham dados sensíveis, e dependem de decisões automatizadas. Na Mesh como plataforma nova, sem histórico, em domínio financeiro, trust não é adquirida — é construída intencionalmente. Esta lens operacionaliza: arquitetura de confiança com 3 pilares (ability, benevolence, integrity) e trust velocity (Mayer et al. 1995, McKnight et al. 2002, trust velocity 2023+, appropriate trust Lee/See 2004), design de primeira impressão com trust cues hierarchy (Lindgaard et al. 2006, Fogg 2003, trust in AI-first 2024+), momentos de vulnerabilidade com anxiety gradient e progressive trust building (Carlzon 1987, anxiety gradient 2023+, progressive trust 2022+), social proof com earned vs manufactured evidence (Cialdini 2006, B2B social proof 2023+, earned vs manufactured 2024+), calibração de transparência com transparency paradox (calibrated transparency 2023+, Bernstein 2012), recovery com service recovery paradox e incident communication (Tax et al. 1998, Grönroos 2007, Atlassian/PagerDuty 2020+/2022+), construção de trust institucional com transição person→process→institution (Zucker 1986, trust scaling 2022+, trust infrastructure 2024+), e trust em decisões de IA com algorithm aversion e human-AI calibration (Dietvorst et al. 2015, Logg et al. 2019, human-AI trust 2024+). Universal, agnóstica a estágio, aplicável a qualquer plataforma financeira que opera sobre confiança."

}
