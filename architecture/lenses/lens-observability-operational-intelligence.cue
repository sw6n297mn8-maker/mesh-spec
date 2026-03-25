package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

observabilityOperationalIntelligence: artifact_schemas.#AnalyticalLens & {
id:     "lens-observability-operational-intelligence"
name:   "Observabilidade e Inteligência Operacional"

purpose: "Orientar decisões sobre como tornar o sistema observável — SLIs, SLOs, alertas, dashboards e inteligência operacional para detectar problemas antes que afetem participantes."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como monitorar a saúde do sistema operacional end-to-end",
		"a decisão envolve definir o que é 'funcionando corretamente' para um pipeline, integração ou serviço",
		"a decisão envolve diagnosticar degradação de performance ou falha não-antecipada no sistema",
		"a decisão envolve definir SLOs, SLIs ou error budgets para serviços da plataforma",
		"a decisão envolve qualidade de dados como precondição de operação confiável",
		"a decisão envolve detectar anomalias no comportamento do sistema que não se encaixam em alertas pré-definidos",
		"a decisão envolve entender dependências entre componentes do sistema e single points of failure",
		"a decisão envolve responder a incidentes operacionais (detecção, triagem, resolução, post-mortem)",
		"a decisão envolve eliminar trabalho manual repetitivo que escala linearmente com o sistema",
		"a decisão envolve injetar falhas controladas para testar resiliência do sistema",
		"a decisão envolve identificar e gerenciar feedback loops que geram comportamento emergente",
	]
	keywords: [
		"observabilidade", "observability", "monitoramento", "monitoring",
		"SLI", "SLO", "SLA", "error budget", "confiabilidade", "reliability",
		"pipeline", "latência", "throughput", "uptime", "disponibilidade",
		"qualidade de dados", "data quality", "freshness", "completude",
		"anomalia", "detecção de anomalia", "alerta", "threshold",
		"incidente", "post-mortem", "root cause", "causa raiz",
		"dependência", "single point of failure", "topologia",
		"chaos engineering", "resiliência", "fault injection",
		"toil", "automação", "trabalho manual", "operação repetitiva",
		"feedback loop", "comportamento emergente", "efeito cascata",
		"traces", "logs", "métricas", "telemetria", "dashboard",
	]
	excludeWhen: [
		"a decisão é sobre governança de agentes IA individuais (autonomia, escalation, drift de agente) — usar ai-agent-governance",
		"a decisão é sobre alocação de recursos entre atividades — usar organizational-resource-allocation",
		"a decisão é sobre monitoramento específico de modelos de scoring/crédito — usar credit-risk",
		"a decisão é sobre arquitetura de bounded contexts ou escolhas de tecnologia — escopo de engenharia",
		"a decisão é sobre requisitos regulatórios de rastreabilidade — usar regulatory-strategy + ai-agent-governance",
	]
	rationale: "Toda organização que opera software em produção precisa observar, diagnosticar e evoluir seu sistema. Na Mesh AI-native, o sistema operacional é composto por agentes IA, pipelines de dados, integrações com terceiros (registradoras, Bacen, bancos parceiros), e fluxos financeiros — cada um com modos de falha próprios e interdependências. Sem observabilidade end-to-end, falhas são detectadas por clientes (fornecedores, construtoras) em vez de pelo sistema, diagnóstico é manual e lento, e degradação silenciosa acumula até se tornar crise. AAG governa agentes individuais; esta lens governa o sistema como um todo."
}

concepts: [
	{
		id:         "ooi-observability-vs-monitoring"
		name:       "Observabilidade vs Monitoramento: Diagnosticar o Desconhecido"
		nature:     "theoretical"
		role:       "framework"
		definition: "Sridharan (2018, Distributed Systems Observability): monitoramento verifica condições pré-definidas ('CPU > 90%?'); observabilidade é a capacidade de inferir o estado interno do sistema a partir de outputs externos — logs, métricas, traces — sem precisar antecipar o problema. Majors/Fong-Jones/Miranda (2022, Observability Engineering): um sistema é observável quando qualquer pergunta sobre seu comportamento pode ser respondida sem deployar código novo. Kalman (1960): observabilidade como propriedade de sistemas — o estado completo pode ser reconstituído a partir dos outputs. Distinção operacional: monitoramento responde 'está ok?'; observabilidade responde 'por que não está ok?' e 'o que está acontecendo que não antecipei?'. Monitoramento é subconjunto de observabilidade."
		meshManifestation: "Na Mesh, monitoramento cobre: pipeline de antecipação está rodando? Integração com registradora está respondendo? Scoring retornou em <5s? Observabilidade vai além: por que a taxa de aprovação caiu 30% esta semana sem mudança de policy? Por que latência da registradora dobrou às 14h? Por que 5 fornecedores diferentes reportaram dados inconsistentes no mesmo dia? Sem observabilidade: o sistema reporta 'tudo verde' enquanto qualidade real degrada. Três pilares: (1) logs — eventos discretos com contexto. (2) métricas — séries temporais agregadas. (3) traces — caminho de uma operação end-to-end através de múltiplos componentes."
		meshImplication: "Para cada componente crítico do sistema (scoring pipeline, integração bancária, registradora, compliance engine, notificações): implementar os três pilares de observabilidade. Logs: estruturados (JSON), com correlation ID que conecta uma operação end-to-end. Métricas: RED (Rate, Errors, Duration) para cada serviço. Traces: trace distribuído que mostra o caminho completo de uma operação de antecipação (solicitação → scoring → aprovação → liquidação → registro). Teste de observabilidade: simular falha não-antecipada — o sistema permite diagnosticar sem deploy? Se não: observabilidade insuficiente. Anti-pattern: 1000 dashboards que ninguém olha — observabilidade é capacidade de investigar, não volume de gráficos."
		rationale: "Sridharan 2018 + Majors et al. 2022: observabilidade ≠ monitoramento. Na Mesh com sistema distribuído (agentes + integrações + pipelines), a maioria dos problemas em produção não será antecipável — observabilidade é a capacidade de diagnosticá-los mesmo assim."
	},
	{
		id:            "ooi-sli-slo-error-budget"
		name:          "SLIs, SLOs e Error Budgets: Confiabilidade como Contrato"
		nature:        "operational"
		role:          "framework"
		reviewCadence: "monthly"
		definition:    "Beyer et al. (2016, Site Reliability Engineering — Google): Service Level Indicator (SLI) é métrica que quantifica a experiência do usuário (latência, disponibilidade, throughput). Service Level Objective (SLO) é alvo para o SLI ('99.5% das requests em <500ms'). Error budget = 1 - SLO (0.5% de requests podem falhar). Beyer et al. (2018, The Site Reliability Workbook): error budget governa trade-off entre velocidade de mudança e confiabilidade — enquanto há budget, deploy rápido; quando budget se esgota, congelar mudanças e focar em estabilidade. Hidalgo (2020, Implementing Service Level Objectives): SLOs devem refletir a experiência real do usuário, não métricas internas de infra. Murphy/Beyer/Jones/Petoff (2024, The Site Reliability Workbook 2nd ed.): SLO-based alerting supera threshold-based alerting — alerta dispara quando error budget está sendo consumido mais rápido que o esperado (burn rate), não quando métrica cruza threshold estático."
		meshManifestation: "Na Mesh, os 'usuários' são múltiplos: (1) fornecedor — SLI: tempo entre solicitação de antecipação e crédito na conta. SLO: 95% em <48h. (2) construtora — SLI: tempo de qualificação de fornecedor. SLO: 90% em <24h. (3) operação interna — SLI: latência de scoring. SLO: 99% em <10s. (4) integração bancária — SLI: disponibilidade da integração com banco parceiro. SLO: 99.5% uptime mensal. Error budget: se SLO de antecipação é 95% em <48h, e temos 100 operações/mês, budget é 5 operações que podem exceder 48h. Se 4 já excederam: 1 restante — desacelerar mudanças no pipeline."
		meshImplication: "Para cada fluxo crítico que afeta stakeholder externo: definir SLI (o que medir), SLO (qual o alvo), e error budget (quanto pode falhar). SLIs devem medir experiência do stakeholder, não métrica de infra — 'tempo até crédito na conta', não 'uptime do servidor'. Alerting baseado em burn rate: se error budget de 30 dias está sendo consumido em <3 dias, alerta urgente (1h window). Se em <7 dias, alerta de warning (6h window). Se dentro do esperado, nenhum alerta — mesmo que métricas internas variem. Revisão mensal: SLOs estão calibrados? Muito frouxos (nunca violados) são inúteis. Muito apertados (violados sempre) geram alert fatigue. Error budget realizado vs alvo: se consistentemente esgotado, investir em reliability; se consistentemente sobrando, investir em velocidade de mudança."
		rationale: "Beyer et al. 2016/2018: SLOs são contratos de confiabilidade baseados em experiência do usuário. Hidalgo 2020: SLOs refletem realidade, não aspiração. Murphy et al. 2024: burn rate alerting. Na Mesh, SLOs traduzem 'o sistema funciona?' em métricas verificáveis por stakeholder."
	},
	{
		id:         "ooi-data-quality-operational-risk"
		name:       "Qualidade de Dados como Risco Operacional"
		nature:     "theoretical"
		role:       "framework"
		definition: "Redman (2001, Data Quality): dados de baixa qualidade propagam erros por todo o sistema — decisões baseadas em dados errados são decisões erradas com confiança alta. DAMA-DMBOK2 (2017): seis dimensões de data quality — accuracy (correto?), completeness (completo?), consistency (consistente entre fontes?), timeliness (atualizado?), validity (formato correto?), uniqueness (sem duplicatas?). Sambasivan et al. (2021, 'Everyone wants to do the model work, not the data work' — Google): em sistemas ML, a maioria das falhas em produção origina-se em dados, não em modelos — data cascades são falhas compostas que se propagam silenciosamente. Polyzotis et al. (2019, 'Data Validation for Machine Learning' — Google/TFX): validação de dados deve ser automática, contínua, e integrada ao pipeline — não manual e periódica. Conceito emergente de data observability (Barr Moses et al., 2022, Data Quality Fundamentals): aplicar princípios de observabilidade de software a dados — freshness, volume, distribution, schema, lineage."
		meshManifestation: "Na Mesh, dados são insumo de quase tudo: scoring usa dados financeiros e operacionais, compliance usa documentos de fornecedores, pricing usa histórico de operações, network growth usa dados de relacionamento. Data cascades possíveis: (1) faturamento de comprador desatualizado (timeliness) → scoring produz score inflado → antecipação aprovada com risco subestimado → perda financeira. (2) CNPJ duplicado no cadastro (uniqueness) → mesmo fornecedor aparece como dois → relatórios de concentração incorretos → violação de limite regulatório. (3) formato de CND mudou (validity) → parser falha silenciosamente → compliance aprova documento não-verificado. Cada falha de dados é amplificada pelo sistema — agente IA processa dados errados com a mesma confiança que processaria dados corretos."
		meshImplication: "Para cada pipeline de dados crítico: implementar as 5 dimensões de data observability (Barr Moses et al. 2022): (1) freshness — dado foi atualizado quando esperado? Alerta se dado de faturamento >30 dias. (2) volume — quantidade de registros está no range esperado? Alerta se volume cai >50% sem explicação. (3) distribution — distribuição estatística dos valores está dentro do esperado? Alerta se score médio shift >2σ. (4) schema — estrutura dos dados mudou? Alerta se campo novo aparece ou campo esperado desaparece. (5) lineage — de onde o dado veio e por quais transformações passou? Essencial para diagnóstico. Regra: dado que alimenta scoring ou decisão financeira deve ter validação automática antes de entrar no pipeline (Polyzotis et al. 2019) — rejeitar e alertar, não processar e esperar que alguém perceba. Anti-pattern: tratar data quality como projeto pontual ('limpeza de dados') em vez de propriedade contínua do sistema."
		crossDependsOn: [{
			lensId:    "lens-credit-risk"
			conceptId: "cr-model-monitoring"
			context:   "CR monitora drift em modelos de scoring específicos (AUROC, PSI). OOI monitora qualidade de dados que alimentam o scoring e todo o sistema. Data quality é upstream de model quality — se dados degradam, modelo degrada mesmo sem concept drift. OOI diz 'dados de entrada estão saudáveis?'; CR diz 'modelo está performando dado os dados?'."
		}]
		rationale: "Sambasivan et al. 2021: maioria das falhas ML em produção são de dados. Barr Moses et al. 2022: data observability como prática contínua. Na Mesh onde agentes IA processam dados com confiança alta, dados errados são amplificados — não atenuados — pelo sistema."
	},
	{
		id:         "ooi-chaos-engineering"
		name:       "Chaos Engineering: Descobrir Fraquezas Antes que se Manifestem"
		nature:     "theoretical"
		role:       "method"
		definition: "Rosenthal et al. (2020, Learning Chaos Engineering): disciplina de experimentar em sistemas para construir confiança na capacidade do sistema de suportar condições turbulentas em produção. Baseia-se em: (1) definir steady state (comportamento normal mensurável), (2) hipotetizar que steady state se mantém sob perturbação, (3) introduzir perturbação realista (falha de rede, latência, indisponibilidade de dependência), (4) observar se hipótese se confirma. Principia do Netflix (2014+, Chaos Monkey): destruir intencionalmente componentes para forçar resiliência. Nines/Robbins (2024, Chaos Engineering: System Resiliency in Practice): evolução para 'continuous verification' — não apenas falhas de infra, mas falhas de lógica, dados corrompidos, e condições de corrida. Diferença crítica: chaos engineering não é teste de carga — é experimentação que testa hipóteses sobre comportamento do sistema sob falha."
		meshManifestation: "Na Mesh, dependências externas são múltiplas e cada uma pode falhar: (1) banco parceiro indisponível → liquidação de antecipação atrasa. (2) registradora fora do ar → registro de operação falha. (3) API de consulta de CNPJ retorna timeout → compliance bloqueia. (4) dados de faturamento chegam corrompidos → scoring processa lixo. (5) agente de IA retorna resposta inesperada → pipeline downstream quebra. Cada falha é previsível em tipo mas não em timing. Sem chaos engineering: a primeira vez que o banco parceiro fica indisponível por 4h é em produção com operação real pendente."
		meshImplication: "Implementar chaos engineering proporcional ao estágio: (1) Pré-produção: simular indisponibilidade de cada dependência externa e verificar que o sistema degrada gracefully (retry, fallback, alerta) em vez de falhar silenciosamente. (2) Pós-MVP: game days — sessões programadas onde falhas são injetadas em ambiente de staging com dados realistas. (3) Escala: chaos contínuo em produção com blast radius controlado (apenas % do tráfego). Para cada experimento: definir steady state (ex: 'antecipações são processadas em <48h'), injetar falha (ex: 'registradora indisponível por 2h'), observar (ex: 'operações ficam em fila e são processadas quando registradora retorna, sem perda'). Se hipótese falha: a fraqueza é real e deve ser corrigida antes de acontecer em produção. Priorizar: falhas de dependências externas (não controláveis) antes de falhas internas (mais controláveis)."
		dependsOn: ["ooi-observability-vs-monitoring", "ooi-sli-slo-error-budget"]
		rationale: "Rosenthal et al. 2020: confiança em resiliência vem de experimentação, não de esperança. Nines/Robbins 2024: continuous verification. Na Mesh com múltiplas dependências externas (banco, registradora, Bacen), falhas são certas — chaos engineering transforma surpresas em aprendizado controlado."
	},
	{
		id:         "ooi-operational-topology"
		name:       "Topologia Operacional: Mapa de Dependências e Single Points of Failure"
		nature:     "theoretical"
		role:       "framework"
		definition: "Perrow (1984, Normal Accidents): sistemas com tight coupling e interactive complexity têm acidentes 'normais' — falhas são inevitáveis porque a interação entre componentes é imprevisível. O primeiro passo para resiliência é entender a topologia — quais componentes existem, como dependem uns dos outros, e onde estão os single points of failure (SPOFs). Woods/Hollnagel (2006, Joint Cognitive Systems): sistemas resilientes mantêm modelo mental atualizado da sua própria topologia — 'where we are, what we have, what we can do'. Skelton/Pais (2019, Team Topologies): mapear dependências não apenas técnicas mas organizacionais — quem depende de quem para o quê. Dehghani (2022, Data Mesh): em arquiteturas distribuídas, a topologia de dados é tão crítica quanto a topologia de serviços — quem produz qual dado, quem consome, qual o SLA de freshness e qualidade. Nygard (2018, Release It! 2nd ed.): topology mapping deve incluir failure domains — conjuntos de componentes que falham juntos por compartilharem recurso (mesmo data center, mesma API, mesmo banco de dados). Failure domain ≠ componente individual — um failure domain pode derrubar múltiplos componentes simultâneos."
		meshManifestation: "Na Mesh, a topologia operacional inclui: (1) dependências técnicas internas — scoring depende de data pipeline que depende de integrações que dependem de APIs externas. (2) dependências externas — banco parceiro (liquidação), registradora (registro), Bacen (consultas regulatórias), bureaus (dados de crédito), certificadoras (CNDs). (3) SPOFs — se o banco parceiro único fica indisponível, toda liquidação para. Se o founder fica indisponível, decisões tipo 2+ param. Se o mesh-spec repository corrompe, governance dos agentes para. (4) dependências organizacionais — gestor FIDC (aprovações), correspondente bancário (operação), assessoria jurídica (contratos). (5) failure domains — integração com banco e registradora podem compartilhar mesma VPN ou certificado TLS — falha do certificado derruba ambas simultaneamente. Cloud provider failure afeta scoring + compliance + notificações se todos estão na mesma zona de disponibilidade. (6) topologia de dados (Dehghani 2022) — quem produz dados de faturamento (construtora via API), quem consome (scoring, compliance, relatórios), qual o SLA de freshness entre produtor e consumidor."
		meshImplication: "Manter mapa de dependências atualizado com: (1) cada componente/serviço/dependência, (2) de quem depende (upstream), (3) quem depende dele (downstream), (4) SLO da dependência (se externa: SLA contratual; se interna: SLO definido), (5) fallback se indisponível (existe? é automático?), (6) blast radius se falhar (quantas operações afetadas?), (7) failure domain — quais componentes compartilham infraestrutura e podem falhar juntos? Identificar SPOFs: qualquer componente sem fallback cuja falha bloqueia >50% das operações é SPOF. Para cada SPOF: plano de mitigação (redundância, fallback degradado, buffer de tempo). Para failure domains: se >2 componentes críticos estão no mesmo failure domain, separar ou ter fallback para o domain inteiro. Atualizar mapa: a cada nova integração ou mudança de arquitetura. Topology-aware alerting: alerta de componente upstream deve alertar todos os componentes downstream afetados, não apenas o componente que falhou. Exercício: uma vez por trimestre, para cada failure domain, perguntar 'se isso falha completamente por 4h, o que acontece?' — se a resposta não é conhecida, é gap de topologia."
		dependsOn: ["ooi-observability-vs-monitoring"]
		crossDependsOn: [{
			lensId:    "lens-contract-theory"
			conceptId: "ct-incomplete-contracts"
			context:   "CT modela como contratos incompletos com dependências externas (banco, registradora) criam risco de hold-up e renegociação. OOI mapeia essas dependências operacionalmente — SLAs, fallbacks, blast radius. CT diz 'contrato com banco não cobre cenário X'; OOI diz 'se cenário X acontece, blast radius é Y e fallback é Z'. CT é o risco contratual; OOI é a mitigação operacional."
		}]
		rationale: "Perrow 1984: tight coupling + interactive complexity = acidentes normais. Woods/Hollnagel 2006: resiliência requer modelo mental do sistema. Nygard 2018: failure domains agrupam falhas. Dehghani 2022: topologia de dados é tão crítica quanto de serviços. Na Mesh com múltiplas dependências externas não-controláveis, conhecer a topologia é pré-condição de resiliência."
	},
	{
		id:         "ooi-anomaly-detection"
		name:       "Detecção de Anomalias: Encontrar o que Não se Sabia que Deveria Procurar"
		nature:     "theoretical"
		role:       "method"
		definition: "Chandola/Banerjee/Kumar (2009, 'Anomaly Detection: A Survey'): anomalia é observação que desvia significativamente do comportamento esperado. Três tipos: point (valor individual anômalo), contextual (valor normal em contexto errado), coletiva (conjunto de valores que juntos são anômalos). Ahmad et al. (2017, 'Unsupervised Real-Time Anomaly Detection for Streaming Data' — Numenta): Hierarchical Temporal Memory para detecção em streaming sem labels. Hundman et al. (2018, 'Detecting Spacecraft Anomalies Using LSTMs' — NASA): LSTMs para detecção de anomalias em séries temporais de sistemas complexos. Zhao et al. (2023, 'Survey on LLM-based Anomaly Detection'): LLMs como detectores de anomalias em logs e métricas — interpretam contexto semântico que métodos estatísticos perdem. Evolução: de thresholds estáticos → métodos estatísticos → ML → LLM-enhanced."
		meshManifestation: "Na Mesh, anomalias que thresholds estáticos não capturam: (1) volume de operações cai 40% numa quarta-feira — normal em feriado, anômalo em dia útil (contextual). (2) 3 fornecedores de segmentos diferentes submetem documentos com mesmo padrão de erro — individualmente normal, coletivamente indica problema no formulário ou ataque (coletiva). (3) latência de scoring aumenta 200ms — irrelevante para humano, mas indica possível degradação do modelo ou crescimento de dataset (point, precursor de falha). (4) padrão de operações de um comprador muda — antes solicitava antecipações mensais, agora semanais — pode ser legítimo (crescimento) ou red flag (stress financeiro)."
		meshImplication: "Implementar detecção em três camadas: (1) thresholds estáticos — para anomalias óbvias (SLO violado, erro rate >5%, componente down). Rápido, simples, sempre ativo. (2) detecção estatística — para desvios de baseline (Z-score, IQR, STL decomposition para sazonalidade). Captura drift lento e anomalias contextuais. Implementar para métricas com histórico suficiente (>3 meses). (3) LLM-enhanced — para anomalias semânticas em logs e patterns complexos. Agente IA revisa logs diariamente buscando patterns não-capturados pelas camadas 1-2. Priorizar: falso negativo (anomalia real não detectada) é pior que falso positivo (alerta sem anomalia) para componentes críticos (scoring, liquidação). Inverso para componentes não-críticos (relatórios, dashboards). Toda anomalia detectada: log com contexto + severity + ação sugerida. Não gerar alerta sem ação sugerida — alerta sem next step é ruído."
		dependsOn: ["ooi-observability-vs-monitoring", "ooi-sli-slo-error-budget"]
		rationale: "Chandola et al. 2009: taxonomia de anomalias. Zhao et al. 2023: LLMs como detectors contextuais. Na Mesh, as anomalias mais perigosas são as que ninguém antecipou — detecção em camadas maximiza cobertura."
	},
	{
		id:            "ooi-incident-management"
		name:          "Gestão de Incidentes: Do Alerta ao Aprendizado"
		nature:        "operational"
		role:          "method"
		reviewCadence: "monthly"
		definition:    "Huang et al. (2019, 'AIOps: Real-World Challenges and Research Innovations' — Microsoft): AIOps integra ML ao ciclo de incident management — detecção automatizada, correlação de alertas, root cause analysis assistida. PagerDuty (2020, Incident Response): lifecycle em 5 fases — detect, triage, resolve, post-mortem, prevent. Shorr/Lunney (2023, 'Incident Management for Operations' — Google): incidentes são sintomas de fraquezas sistêmicas — o incidente individual é menos importante que o pattern. Learning from Incidents (Cook/Woods 2023, continuação do trabalho de Woods/Hollnagel): post-mortems 'blameless' revelam mais que post-mortems punitivos porque incentivam disclosure total. Conceito recente de 'resilience engineering' (Woods 2019, 'The Theory of Graceful Extensibility'): sistemas não apenas resistem a falhas — se adaptam e aprendem."
		meshManifestation: "Na Mesh, incidentes potenciais variam em severidade: (1) SEV-1 — perda financeira ou indisponibilidade total (liquidação falha, dados vazam, scoring produz resultado catastroficamente errado). (2) SEV-2 — degradação significativa (antecipação demora >48h, integração com registradora intermitente). (3) SEV-3 — degradação menor (relatório atrasado, dashboard incorreto, notificação duplicada). (4) SEV-4 — cosmético ou edge case. Na Mesh AI-native, o incident commander pode ser agente ou humano dependendo da severidade: SEV-3/4 agente resolve e loga; SEV-2 agente detecta e escala; SEV-1 humano comanda."
		meshImplication: "Protocolo de incident management: (1) Detect — alertas de SLO burn rate + anomaly detection + reports de stakeholders. Agente de monitoramento como first responder 24/7 (humano não escala para vigilância contínua). (2) Triage — classificar severidade (SEV-1 a SEV-4), escalar se necessário, comunicar stakeholders afetados (conecta com sc-crisis-communication). (3) Resolve — para SEV-3/4: agente executa runbook automatizado. Para SEV-1/2: humano + agente colaboram. Documentar timeline em tempo real. (4) Post-mortem — blameless, dentro de 48h para SEV-1/2. Template: timeline, root cause, contributing factors, o que funcionou, o que não funcionou, action items com owner e deadline. (5) Prevent — action items de post-mortem como tickets no backlog com CoD urgente (conecta com ora-cost-of-delay). Métricas: MTTD (Mean Time to Detect), MTTR (Mean Time to Resolve), recurrence rate (% de incidentes recorrentes). Se recurrence >20%: post-mortems não estão gerando prevenção efetiva."
		dependsOn: ["ooi-observability-vs-monitoring", "ooi-anomaly-detection"]
		crossDependsOn: [
			{
				lensId:    "lens-stakeholder-communication"
				conceptId: "sc-crisis-communication"
				context:   "SC define como comunicar crises a stakeholders. OOI define o lifecycle operacional de resposta ao incidente. OOI diz 'incidente detectado, triagem feita, severidade X'; SC diz 'comunicar stakeholder Y com frame Z no timing W'. OOI é o operacional; SC é o comunicacional."
			},
			{
				lensId:    "lens-organizational-resource-allocation"
				conceptId: "ora-cost-of-delay"
				context:   "ORA prioriza action items de post-mortem via CoD. Se action item previne recorrência de SEV-1, CoD é urgente. Se previne SEV-4, CoD é baixo. OOI gera os action items; ORA os prioriza no backlog."
			},
		]
		rationale: "Huang et al. 2019: AIOps para incident management. Cook/Woods 2023: aprendizado blameless. Woods 2019: resiliência é adaptação, não resistência. Na Mesh AI-native, agente como first responder 24/7 é vantagem estrutural — humano é escalado, não perturbado."
	},
	{
		id:         "ooi-feedback-loops-emergence"
		name:       "Feedback Loops e Comportamento Emergente: Efeitos de Segunda Ordem"
		nature:     "theoretical"
		role:       "framework"
		definition: "Meadows (2008, Thinking in Systems): sistemas complexos exibem comportamento emergente — o comportamento do todo não é previsível a partir das partes. Feedback loops (reinforcing e balancing) amplificam ou amortecem sinais. Reinforcing loops criam crescimento exponencial ou colapso; balancing loops criam equilíbrio ou estagnação. Sterman (2000, Business Dynamics): humanos sistematicamente subestimam delays em feedback loops e falham em identificar loops não-intencionais. Sculley et al. (2015, 'Hidden Technical Debt in ML Systems'): em sistemas ML, feedback loops são particularmente perigosos — outputs do modelo afetam inputs futuros (ex: modelo aprova X → mais dados de X → modelo fica melhor em X e pior em Y). Agrawal et al. (2022, Power and Prediction): IA em sistemas econômicos cria novos feedback loops entre predição, decisão e resultado."
		meshManifestation: "Na Mesh, feedback loops potencialmente perigosos: (1) scoring loop — Mesh aprova fornecedores com score alto → esses fornecedores geram mais dados → scoring fica calibrado para perfil 'aprovado' → fornecedores diferentes (novos, menores) recebem score baixo por falta de dados, não por risco real (survivorship bias amplificado). (2) network loop — construtoras grandes entram primeiro → atraem fornecedores → rede fica concentrada em construtoras grandes → construtoras pequenas não encontram oferta → rede não é universal. (3) pricing loop — taxa baixa atrai volume alto → volume alto reduz custo → taxa pode baixar mais → competidor não consegue competir → Mesh captura mercado → pricing power cresce → tentação de aumentar taxa (dynamics of monopoly). Cada loop tem delay: efeito leva meses para se manifestar."
		meshImplication: "Para cada mecanismo principal da Mesh (scoring, pricing, matching, reputation): mapear feedback loops explicitamente. Para cada loop: (1) é reinforcing ou balancing? (2) é intencional ou emergente? (3) qual o delay estimado? (4) qual o risco se loop sair do controle? Monitorar proxies de loops perigosos: distribuição de scores ao longo do tempo (survivorship bias), concentração de rede (Herfindahl), pricing trend (monopoly dynamics). Se proxy indica loop reinforcing sem balancing: intervir — ex: reservar % de volume para fornecedores novos (balancing forçado contra survivorship bias no scoring). Revisão semestral: loops mapeados ainda são os mais relevantes? Novos loops emergiram?"
		crossDependsOn: [
			{
				lensId:    "lens-complex-adaptive-systems"
				conceptId: "cas-emergence"
				context:   "CAS modela emergência como propriedade de sistemas adaptativos complexos. OOI operacionaliza detecção e gerenciamento de feedback loops e comportamento emergente no sistema operacional da Mesh. CAS é a teoria; OOI é a monitoração e intervenção."
			},
			{
				lensId:    "lens-mechanism-design"
				conceptId: "md-feedback-mechanisms"
				context:   "MD desenha mecanismos com feedback loops intencionais (scoring melhora com dados, reputação acumula com performance). OOI monitora se esses loops estão funcionando como projetado — ou se geraram efeitos emergentes não-intencionais. MD cria o loop; OOI verifica se o loop está saudável."
			},
		]
		rationale: "Meadows 2008: feedback loops governam comportamento sistêmico. Sculley et al. 2015: ML amplifica feedback loops. Agrawal et al. 2022: IA cria novos loops. Na Mesh, os loops mais perigosos são os que levam meses para se manifestar e anos para corrigir — mapear e monitorar é a única defesa."
	},
	{
		id:            "ooi-toil-elimination"
		name:          "Eliminação de Toil: Trabalho que Escala Linearmente Deve ser Automatizado"
		nature:        "operational"
		role:          "heuristic"
		reviewCadence: "quarterly"
		definition:    "Beyer et al. (2016, SRE): toil é trabalho manual, repetitivo, automatizável, tático, sem valor duradouro, e que escala linearmente com o crescimento do sistema. SRE alvo: <50% do tempo em toil. Toil não é 'trabalho difícil' — é trabalho que não deveria ser feito por humano. Distinção: toil vs overhead (reuniões, planejamento — necessário mas não-automatizável) vs engineering (cria valor duradouro). Forsgren/Humble/Kim (2018, Accelerate): organizações de alta performance automatizam toil sistematicamente e investem o tempo liberado em engineering. Conceito contemporâneo de 'AI-assisted toil elimination' (2023+): LLMs não apenas executam toil — identificam toil que humanos normalizaram e sugerem automação."
		meshManifestation: "Na Mesh AI-native, toil potencial: (1) revisar manualmente cada documento de fornecedor mesmo quando agente já validou (supervisão excessiva — conecta com aag-hitl-calibration). (2) formatar relatórios de operação manualmente quando pipeline poderia gerar automaticamente. (3) copiar dados entre sistemas que não estão integrados. (4) responder perguntas repetitivas de fornecedores sobre status (automatizável por notificação proativa). (5) reconciliar manualmente liquidações com registros. Cada item de toil consome o constraint (horas do founder) sem gerar valor duradouro. Com agentes IA, a fronteira do que é toil expande: tarefas que antes exigiam julgamento humano podem ser automatizáveis com agent de qualidade suficiente."
		meshImplication: "Inventário trimestral de toil: listar toda atividade repetitiva feita por humano. Para cada: (1) frequência, (2) tempo por ocorrência, (3) é automatizável com tecnologia atual? (4) custo de automatizar vs custo de continuar fazendo manualmente. Priorizar automação por: tempo total consumido × custo de automatizar. Quick wins: automações <1 dia de trabalho que eliminam >2h/semana de toil. Para agentes IA: agente deve flaggar toil detectado — 'esta tarefa foi executada 15 vezes este mês com mesmo pattern — automatizar?'. Target: <20% do tempo do founder em toil. Se >30%: o sistema está consumindo o constraint com trabalho não-engenharia. Se <10%: verificar se toil está sendo feito por agentes de forma invisível (pode estar oculto)."
		dependsOn: ["ooi-observability-vs-monitoring"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-throughput-constraint"
			context:   "ORA identifica que o constraint é horas do founder. OOI identifica e elimina toil que consome o constraint sem gerar valor. Cada hora de toil eliminada é hora devolvida ao constraint. ORA diz 'atenção é escassa'; OOI diz 'esta atividade repetitiva está consumindo atenção desnecessariamente'."
		}]
		rationale: "Beyer et al. 2016: toil <50%. Forsgren et al. 2018: automação de toil diferencia alta de baixa performance. Na Mesh AI-native, a fronteira de toil é mais ampla — agentes podem automatizar tarefas que em organizações tradicionais seriam 'necessárias por humano'. Aproveitar essa fronteira libera o constraint."
	},
	{
		id:         "ooi-platform-reliability-culture"
		name:       "Cultura de Confiabilidade: Propriedade Emergente Organizacional"
		nature:     "theoretical"
		role:       "property"
		definition: "Dekker (2006, The Field Guide to Understanding Human Error): erros humanos não são causas de acidentes — são sintomas de fraquezas sistêmicas. Culpar o humano previne aprendizado. Reason (1997, Managing the Risks of Organizational Accidents): cultura de segurança tem quatro componentes — reporting culture (seguro reportar erros), just culture (accountability proporcional), flexible culture (adapta-se a demanda), learning culture (converte incidentes em melhoria). Westrum (2004, 'A Typology of Organisational Cultures'): três tipos — patológica (esconde informação), burocrática (ignora mensageiros), generativa (busca informação ativamente). Google DORA (2024, State of DevOps Report): cultura generativa é o preditor mais forte de performance em software delivery e operational performance."
		meshManifestation: "Na Mesh solo founder + agentes IA, 'cultura' pode parecer irrelevante — mas não é. O founder define a cultura por como lida com falhas: (1) agente comete erro → founder corrige o CLAUDE.md e melhora governance (generativa) vs founder trata como 'bug do agente' sem investigar causa sistêmica (patológica). (2) incidente operacional → post-mortem blameless com action items (generativa) vs 'vamos ficar mais atentos' sem mudança estrutural (burocrática). (3) erro do founder → documentar e compartilhar aprendizado (generativa) vs não registrar (patológica). A cultura se manifesta nos artefatos: CLAUDE.md, post-mortems, tension-log, decisões documentadas."
		meshImplication: "Implementar práticas que forçam cultura generativa: (1) todo incidente SEV-1/2 gera post-mortem documentado — não opcional. (2) post-mortem é blameless — foco em sistema, não em 'quem errou'. (3) action items de post-mortem são commitments com deadline e owner — não 'vamos melhorar'. (4) tension-log como mecanismo de captura de problemas sistêmicos antes que se tornem incidentes. (5) agentes logam erros e incertezas — não escondem. (6) retrospectiva mensal: o que aprendemos? o que mudamos? Se não mudou nada: não aprendemos. Quando a Mesh crescer: cultura já codificada em artefatos (post-mortem template, tension-log, blameless protocol) é onboarding automático — novo membro absorve cultura pelo sistema, não por conversa."
		dependsOn: ["ooi-incident-management"]
		rationale: "Dekker 2006: culpar humano previne aprendizado. Reason 1997: cultura de segurança em 4 componentes. Westrum 2004: cultura generativa é preditor de performance. Google DORA 2024: evidência quantitativa. Na Mesh, cultura é codificada em artefatos — e artefatos escalam melhor que conversas."
	},
	{
		id:         "ooi-graceful-degradation"
		name:       "Degradação Graciosa: O Sistema Perde Funcionalidade, Não Integridade"
		nature:     "theoretical"
		role:       "property"
		definition: "Nygard (2018, Release It! 2nd ed.): sistemas devem ser projetados para falhar parcialmente — perder funcionalidade não-essencial enquanto preservam funcionalidade core. Três patterns fundamentais: (1) Circuit Breaker — detecta falha de dependência e para de chamá-la, retornando fallback em vez de propagar timeout (Martin Fowler, 2014). (2) Bulkhead — isola componentes em compartimentos para que falha de um não afete outros (analogia com compartimentos de navio). (3) Fallback — resposta degradada mas funcional quando componente primário falha. Tai et al. (2004, 'A Survey on Recovery-Oriented Computing'): recovery-oriented computing prioriza rapidez de recuperação sobre prevenção de falha — porque prevenção total é impossível. Woods (2019, 'The Theory of Graceful Extensibility'): sistemas resilientes não apenas resistem — se estendem graciosamente sob demanda não-antecipada, mantendo core functionality mesmo quando capacidade é excedida. Conceito contemporâneo de progressive degradation (Verma et al. 2023, Google): definir hierarquia de funcionalidades — quais são essenciais, quais são nice-to-have — e desligar progressivamente das menos essenciais para preservar as mais essenciais sob stress."
		meshManifestation: "Na Mesh, hierarquia de funcionalidade: (1) essencial — liquidação de antecipações aprovadas (dinheiro prometido deve chegar ao fornecedor). (2) essencial — integridade de dados financeiros e trilha de auditoria. (3) importante — scoring em tempo real (pode ser adiado sem perda). (4) importante — notificações (pode operar com delay). (5) nice-to-have — dashboards, relatórios, analytics. Se banco parceiro cai: liquidações ficam em fila (essencial preservado via queue), scoring continua operando (independente), dashboards mostram status 'liquidação pendente' (degradado mas informativo). Se scoring cai: novas propostas ficam em fila para scoring posterior, operações já aprovadas continuam liquidando (essencial não afetado). Sem degradação graciosa: falha de scoring bloqueia pipeline inteiro incluindo liquidações já aprovadas — falha de componente secundário derruba funcionalidade essencial."
		meshImplication: "Para cada componente: definir o que acontece quando ele falha. Três respostas possíveis em ordem de preferência: (1) fallback automático — sistema continua com funcionalidade degradada sem intervenção (ex: scoring indisponível → propostas enfileiradas, notificação de delay ao fornecedor). (2) degradação manual — humano ativa modo degradado (ex: banco indisponível → founder autoriza transferência manual via segundo banco). (3) parada controlada — componente e dependentes param de forma segura com dados preservados (ex: data pipeline corrompido → ingestão pausa, último snapshot válido mantido). Nunca: falha silenciosa onde sistema parece funcionar mas produz resultados incorretos — pior que parada. Circuit breaker: para cada integração externa, implementar circuit breaker que abre após N falhas consecutivas e retorna fallback. Bulkhead: isolar pipeline financeiro de pipeline de analytics — falha de relatório não pode afetar liquidação. Testar degradação: cada cenário de degradação deve ser testado via chaos engineering — degradação não-testada é degradação teórica."
		dependsOn: ["ooi-operational-topology", "ooi-chaos-engineering"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-blast-radius-containment"
			context:   "AAG contém blast radius de agentes individuais (caps, staged rollout). OOI projeta degradação graciosa do sistema quando componentes (incluindo agentes) falham. AAG é contenção por componente; OOI é resiliência por sistema. Circuit breaker de OOI pode ser o mecanismo que implementa contenção de AAG."
		}]
		rationale: "Nygard 2018: sistemas devem ser projetados para falhar parcialmente. Woods 2019: graceful extensibility. Verma et al. 2023: progressive degradation com hierarquia. Na Mesh como intermediário financeiro, falha de componente secundário não pode bloquear funcionalidade financeira essencial — dinheiro prometido deve chegar."
	},
	{
		id:            "ooi-operational-debt"
		name:          "Dívida Operacional: O Custo Acumulado de Atalhos na Operação"
		nature:        "operational"
		role:          "property"
		reviewCadence: "quarterly"
		definition:    "Analogia com Cunningham (1992, technical debt): dívida operacional é o custo acumulado de atalhos tomados na operação — processos manuais que deveriam ser automatizados, alertas que deveriam existir mas não existem, fallbacks que deveriam ser testados mas não são, documentação que deveria estar atualizada mas não está. Forsgren/Humble/Kim (2018, Accelerate): dívida operacional reduz deployment frequency, aumenta lead time, aumenta change failure rate, e aumenta MTTR — os quatro DORA metrics. Sculley et al. (2015): em ML systems, dívida operacional é particularmente insidiosa porque inclui dívida de dados (schemas não-validados, pipelines não-monitorados) e dívida de configuração (parâmetros manuais não-versionados). Winters/Manshreck/Wright (2020, Software Engineering at Google): a taxa de acúmulo de dívida é proporcional à velocidade de crescimento — crescer rápido sem pagar dívida é modo de falha comum em startups. Conceito contemporâneo de 'AI debt' (Bogner et al. 2021): em sistemas AI-native, dívida operacional inclui modelos não-monitorados, prompts não-versionados, e drift não-detectado."
		meshManifestation: "Na Mesh, dívida operacional se acumula em: (1) alertas ausentes — scoring pipeline não tem alerta de freshness de dados (funciona até que dados desatualizados causem perda). (2) fallbacks não-testados — 'se banco cair, fazemos manual' mas ninguém testou o processo manual. (3) documentação desatualizada — CLAUDE.md referencia processo que mudou 2 meses atrás. (4) processos manuais — reconciliação de liquidação feita em planilha porque pipeline de reconciliação não foi priorizado. (5) AI debt — prompt do agente de compliance não foi atualizado quando regulação mudou. Dívida operacional é invisível até que cause incidente — e o custo de pagamento aumenta com o tempo."
		meshImplication: "Inventário trimestral de dívida operacional: para cada componente/processo, perguntar: (a) alertas — todos os modos de falha relevantes têm alerta? (b) fallbacks — estão testados nos últimos 90 dias? (c) documentação — está atualizada? (d) automação — processos manuais que deveriam ser automatizados? (e) AI debt — prompts e policies de agentes estão atualizados com realidade atual? Para cada item de dívida: estimar custo de incidente se dívida causar falha (blast radius × probabilidade) e custo de pagamento (horas de engenharia). Priorizar pagamento por: custo esperado de incidente / custo de pagamento. Regra: não acumular dívida em componentes que afetam funcionalidade essencial (liquidação, integridade de dados). Se crescimento está acelerando e dívida está acumulando: dedicar 20% do sprint a pagamento de dívida antes que o custo exponha. Budget de dívida: se >30% dos itens no inventário são 'dívida conhecida não-paga', o sistema está em risco — priorizar pagamento sobre features novas."
		dependsOn: ["ooi-toil-elimination", "ooi-incident-management"]
		rationale: "Cunningham 1992: dívida técnica. Forsgren et al. 2018: dívida degrada DORA metrics. Bogner et al. 2021: AI debt. Na Mesh em crescimento, dívida operacional é silenciosa até causar incidente — inventário e pagamento disciplinado é a defesa."
	},
	{
		id:            "ooi-capacity-planning"
		name:          "Planejamento de Capacidade: Antecipar Demanda Antes que Vire Gargalo"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Hixson (2015, 'Capacity Planning' in SRE Book): capacity planning é o processo de determinar a capacidade de produção necessária para atender demanda futura. Requer: (1) modelo de demanda — quanto volume esperamos? (2) modelo de capacidade — quanto volume cada componente suporta? (3) margem de segurança — buffer para variabilidade e spikes. Hoyer et al. (2022, 'Scaling Machine Learning at Uber'): em sistemas ML, capacity planning inclui compute para treinamento, inferência, e reprocessamento — cada um com perfil de demanda diferente. Conceito contemporâneo de 'AI compute scaling' (Kaplan et al. 2020, 'Scaling Laws for Neural Language Models'): custo de compute para LLMs cresce com volume de uso; capacity planning de agentes IA deve considerar custo marginal de cada interação (tokens consumidos × custo por token × volume). Diferença de capacity planning em AI-native vs traditional: em sistema tradicional, compute é relativamente previsível; em AI-native, cada request pode consumir 10x ou 100x mais compute dependendo da complexidade da tarefa."
		meshManifestation: "Na Mesh, capacity planning cobre: (1) compute de agentes — cada operação de scoring consome N tokens de LLM. Se volume cresce de 100 para 1000 operações/mês, custo de compute cresce proporcionalmente? Ou há economia de batch? (2) capacidade do banco parceiro — SLA do banco suporta 50 liquidações/dia? E 500? Lead time para expandir? (3) capacidade humana — founder processa 20 aprovações tipo 3/dia. Com 200 operações/mês, 30% são tipo 3 = 60 aprovações = 3/dia. Com 2000 operações/mês, 600 aprovações/mês = 30/dia — constraint explode. Quando escalar supervisão humana? (4) capacidade de dados — storage e processamento de dados operacionais cresce linearmente com volume? Ou há bottleneck de query performance?"
		meshImplication: "Trimestral: projetar volume para próximos 6 meses em 3 cenários (base, otimista, pessimista). Para cada componente: a capacidade atual suporta cenário otimista? Se não: qual o lead time para expandir? Se lead time > 3 meses: iniciar agora (ax-03: pagar complexidade cedo). Para agentes IA: custo de compute por operação × volume projetado = budget de compute. Se budget > 20% do custo operacional total: otimizar (batch, cache, modelo menor para tarefas simples). Para capacidade humana: projetar quando o constraint de supervisão exige primeira contratação ou quando delegação a agentes precisa expandir (conecta com aag-agent-capability-lifecycle). Anti-pattern: capacity planning reativo — descobrir que banco não suporta volume quando fornecedor está esperando pagamento. Regra: nunca operar acima de 70% da capacidade nominal de qualquer componente crítico — 30% é margem para spikes e crescimento."
		dependsOn: ["ooi-sli-slo-error-budget", "ooi-operational-topology"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-throughput-constraint"
			context:   "ORA identifica o constraint atual. OOI projeta quando o constraint vai mudar — ex: com volume projetado de 2000 ops/mês, constraint migra de horas do founder para capacidade do banco parceiro. ORA gerencia o constraint presente; OOI antecipa o constraint futuro."
		}]
		rationale: "Hixson 2015: capacity planning antecipa demanda. Hoyer et al. 2022: ML capacity tem perfil próprio. Kaplan et al. 2020: scaling laws de LLM. Na Mesh AI-native, custo de compute escala com uso e capacity planning deve incluir compute de agentes como dimensão primeira — não como custo fixo."
	},
	{
		id:         "ooi-integration-contract-testing"
		name:       "Contract Testing de Integrações: Verificar que Dependências Cumprem o Combinado"
		nature:     "theoretical"
		role:       "method"
		definition: "Clemson (2014, 'Testing Strategies in a Microservice Architecture' — Martin Fowler blog): contract tests verificam que a interface entre dois sistemas funciona conforme esperado — sem testar a lógica interna de cada um. Pact (2015+): framework de consumer-driven contract testing — o consumidor define o contrato (o que espera da API), o provedor verifica que cumpre. Robinson (2023, 'Contract Testing in Practice'): em ecossistemas com múltiplas integrações, contract testing é a camada que detecta breaking changes antes de produção — substitui 'descobrir na hora' por 'descobrir no CI'. Conceito contemporâneo de API observability (Postman 2023, State of APIs Report): monitorar continuamente se APIs de terceiros estão conforme contrato — não apenas no deploy, mas em runtime. Contratos não são apenas schema (campos e tipos) — incluem comportamento (latência esperada, formato de erro, rate limits, encoding)."
		meshManifestation: "Na Mesh, integrações críticas com contratos implícitos que podem quebrar silenciosamente: (1) API do banco parceiro — formato de resposta de liquidação pode mudar sem aviso (campo novo, formato de data diferente, encoding). (2) registradora — formato do protocolo de registro pode ter versão atualizada com campos obrigatórios novos. (3) bureau de crédito — scoring externo pode mudar escala ou formato. (4) certificadoras (CNDs, certidões) — formato de documento ou API pode mudar. Cada mudança não-detectada é data cascade em potencial: parser recebe formato inesperado → processa incorretamente ou falha silenciosamente → decisão downstream afetada. Atualmente: maioria dessas integrações é verificada apenas em produção — quando quebra, é incidente."
		meshImplication: "Para cada integração externa: (1) definir contrato explícito — campos esperados, tipos, ranges de valor, formato de erro, latência máxima, rate limit. (2) implementar contract test automatizado que verifica contrato periodicamente (diário para integrações críticas, semanal para demais). Se contrato violado: alerta + bloqueio de pipeline downstream (não processar dados que não conformam). (3) para APIs de terceiros sem garantia de estabilidade: implementar adapter layer que isola lógica de negócio da interface externa — se API muda, apenas adapter precisa de update. (4) monitorar schema drift: se campo novo aparece ou campo existente muda tipo, alerta mesmo que não quebre parsing atual — pode indicar mudança futura. (5) quando terceiro anuncia deprecação ou mudança de versão: tratar como item de CoD urgente (conecta com ora-cost-of-delay) — janela de adaptação é finita. Anti-pattern: integrar diretamente com API externa sem adapter e sem contract test — acopla lógica de negócio a interface instável."
		dependsOn: ["ooi-operational-topology", "ooi-data-quality-operational-risk"]
		crossDependsOn: [{
			lensId:    "lens-supply-chain-theory"
			conceptId: "sct-supplier-reliability"
			context:   "SCT modela confiabilidade de fornecedores na cadeia. OOI operacionaliza verificação contínua de confiabilidade de fornecedores de tecnologia (APIs, integrações). SCT diz 'diversificar fornecedores para resiliência'; OOI diz 'como verificar continuamente que cada fornecedor de integração está cumprindo o contrato'."
		}]
		rationale: "Clemson 2014: contract tests detectam breaking changes antes de produção. Robinson 2023: contract testing em prática. Postman 2023: API observability contínua. Na Mesh com múltiplas integrações externas não-controláveis, contract testing é a defesa contra breaking changes silenciosas que propagam data cascades."
	},
	{
		id:            "ooi-operational-review"
		name:          "Revisão Operacional: Inventário Periódico de Saúde do Sistema"
		nature:        "operational"
		role:          "method"
		reviewCadence: "monthly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) SLOs — performance vs target, error budget restante, (2) data quality — freshness, volume, anomalias detectadas, (3) incidentes — count por severidade, MTTD, MTTR, recurrence rate, action items pendentes, (4) topologia — SPOFs identificados, fallbacks testados, failure domains validados, (5) toil — inventário, horas consumidas, automações implementadas, (6) feedback loops — proxies monitorados, loops emergentes detectados, (7) chaos experiments — realizados, descobertas, correções, (8) dívida operacional — inventário, itens novos, itens pagos, risco acumulado, (9) capacity — projeção vs realizado, gargalos antecipados, lead times de expansão, (10) contract tests — integrações que falharam contract test, breaking changes detectadas."
		meshManifestation: "Na Mesh: revisão mensal formal. Semanal: micro-revisão (SLOs, alertas pendentes, incidentes abertos, contract tests falhando). Mensal: meso-revisão (data quality trends, toil inventory, incident patterns, dívida operacional, capacity vs projeção). Trimestral: macro-revisão (topologia completa, chaos experiments, feedback loops, cultura, capacity planning para próximos 6 meses, integrations health)."
		meshImplication: "Semanal (20min): SLO dashboard — algum SLO em risco? Error budget sendo consumido rápido? Alertas não-resolvidos? Incidentes abertos? Contract tests falhando? Mensal (2h): data quality — trends de freshness, volume, anomalias. Incidentes — patterns (mesmo componente, mesmo tipo). Toil — o que automatizar este mês? Dívida operacional — itens novos? Algum com blast radius alto? Capacity — volume realizado vs projeção, gargalo mais próximo. Post-mortems pendentes. Trimestral (4h): topologia — atualizada? SPOFs mudaram? Failure domains validados? Chaos experiments — último experimento quando? O que descobriu? Feedback loops — distribuição de scores mudou? Concentração de rede mudou? Capacity planning — reprojetar para próximos 6 meses em 3 cenários. Dívida operacional acumulada — budget de pagamento para próximo trimestre. Cultura — post-mortems sendo feitos? Action items sendo completados? Integrations — alguma API depreciando? Contratos atualizados? Se revisão não identifica pelo menos uma ação: ou sistema é perfeito (improvável) ou revisão é superficial."
		dependsOn: ["ooi-sli-slo-error-budget", "ooi-data-quality-operational-risk", "ooi-incident-management", "ooi-toil-elimination", "ooi-feedback-loops-emergence", "ooi-operational-debt", "ooi-capacity-planning", "ooi-integration-contract-testing"]
		rationale: "Sem revisão periódica, observabilidade é infraestrutura passiva — gera dados que ninguém usa para decisão. O inventário periódico transforma dados em ação."
	},
]

reasoningProtocol: [
	{
		question:  "O sistema tem observabilidade ou apenas monitoramento? Posso responder perguntas não-antecipadas sobre o comportamento do sistema sem deployar código?"
		reveals:   "Se a infraestrutura de observabilidade é suficiente para diagnosticar problemas novos — ou se apenas verifica condições pré-definidas."
		rationale: "Sridharan 2018: observabilidade > monitoramento. Se não pode diagnosticar o inesperado, observabilidade é insuficiente."
	},
	{
		question:  "Os SLOs estão definidos e baseados na experiência do stakeholder externo? O error budget está sendo trackado?"
		reveals:   "Se confiabilidade é gerenciada como contrato mensurável ou como impressão subjetiva ('parece estar funcionando')."
		rationale: "Beyer et al. 2016: SLOs são contratos de confiabilidade. Sem SLO: impossível saber se 'funciona' ou 'funciona bem o suficiente'."
	},
	{
		question:  "A qualidade dos dados que alimentam o sistema é monitorada continuamente? As 5 dimensões (freshness, volume, distribution, schema, lineage) estão cobertas?"
		reveals:   "Se data quality é tratada como propriedade contínua ou como projeto pontual. Dados ruins processados com confiança alta = dano amplificado."
		rationale: "Sambasivan et al. 2021: maioria das falhas ML vem de dados. Barr Moses et al. 2022: data observability contínua."
	},
	{
		question:  "Conheço a topologia operacional do sistema? Sei quais são os SPOFs e quais têm fallback?"
		reveals:   "Se falha de componente é surpresa ou é cenário antecipado com plano de mitigação."
		rationale: "Perrow 1984: tight coupling propaga falhas. Conhecer a topologia é pré-condição de resiliência."
	},
	{
		question:  "Já testei a resiliência do sistema com falhas injetadas (chaos engineering)? Ou a primeira falha real será em produção?"
		reveals:   "Se resiliência é verificada ou assumida. Resiliência assumida não é resiliência."
		rationale: "Rosenthal et al. 2020: confiança vem de experimentação. Nines/Robbins 2024: continuous verification."
	},
	{
		question:  "A detecção de anomalias cobre os três níveis — thresholds estáticos, detecção estatística, e análise contextual?"
		reveals:   "Se apenas anomalias óbvias são detectadas (threshold) ou se o sistema captura anomalias sutis e contextuais."
		rationale: "Chandola et al. 2009: anomalias contextuais e coletivas escapam de thresholds. Zhao et al. 2023: LLMs capturam semântica."
	},
	{
		question:  "O ciclo de incident management está completo — detect, triage, resolve, post-mortem, prevent? Post-mortems geram ações que são realmente implementadas?"
		reveals:   "Se incidentes geram aprendizado sistêmico ou se são tratados como eventos isolados que se repetem."
		rationale: "Cook/Woods 2023: aprendizado é o output mais valioso de um incidente. Shorr/Lunney 2023: patterns > incidentes individuais."
	},
	{
		question:  "Existem feedback loops no sistema que não estão sendo monitorados? Algum loop reinforcing pode estar gerando efeito emergente?"
		reveals:   "Se comportamento emergente é antecipado e monitorado — ou se será surpresa quando se manifestar."
		appliesWhen: "o sistema tem componentes que interagem ciclicamente (output de um afeta input de outro)"
		rationale: "Meadows 2008: feedback loops governam sistemas. Sculley et al. 2015: ML amplifica loops. Delays mascaram efeitos."
	},
	{
		question:  "Quanto tempo do constraint (humano) está sendo consumido por toil? Há atividades repetitivas que deveriam ser automatizadas?"
		reveals:   "Se o constraint está sendo gasto em trabalho que deveria ser feito por máquina."
		rationale: "Beyer et al. 2016: toil <50%. Na Mesh AI-native, a fronteira de toil é mais ampla — mais é automatizável."
	},
	{
		question:  "Como a organização lida com erros — cultura generativa (busca informação, blameless) ou patológica (esconde, culpa)?"
		reveals:   "Se o sistema aprende com falhas ou se falhas são escondidas/ignoradas até virarem crises."
		rationale: "Westrum 2004: cultura generativa é preditor de performance. Dekker 2006: culpar humano previne aprendizado."
	},
	{
		question:  "Se o componente mais crítico falhar agora: o sistema degrada graciosamente ou falha catastroficamente? Existe hierarquia de funcionalidade definida?"
		reveals:   "Se degradação é projetada ou improvisada. Degradação não-projetada é falha catastrófica disfarçada."
		rationale: "Nygard 2018: projetar para falha parcial. Woods 2019: graceful extensibility. Funcionalidade essencial (liquidação) não pode ser bloqueada por falha de funcionalidade secundária (dashboard)."
	},
	{
		question:  "Quanto de dívida operacional está acumulada? Alertas ausentes, fallbacks não-testados, documentação desatualizada, AI debt?"
		reveals:   "Se o sistema está acumulando risco silencioso que vai se manifestar como incidente. Dívida não-paga é incidente adiado."
		rationale: "Cunningham 1992: dívida tem juros compostos. Bogner et al. 2021: AI debt inclui prompts e policies desatualizados. Inventário trimestral é o mínimo."
	},
	{
		question:  "A capacidade do sistema suporta o volume projetado para os próximos 6 meses? Onde está o gargalo mais próximo e qual o lead time para expandir?"
		reveals:   "Se capacity planning é proativo ou se gargalos são descobertos quando causam degradação. Lead times longos (banco parceiro) exigem antecipação."
		rationale: "Hixson 2015: capacity planning antecipa demanda. Kaplan et al. 2020: compute de LLM escala com uso. Nunca operar acima de 70% de capacidade nominal."
	},
	{
		question:  "As integrações externas têm contract tests automatizados? Uma breaking change de API de terceiro seria detectada antes de afetar produção?"
		reveals:   "Se breaking changes de dependências externas são detectadas no CI/monitoramento ou se são descobertas quando causam incidente em produção."
		rationale: "Robinson 2023: contract testing em prática. Postman 2023: API observability contínua. Na Mesh, breaking change silenciosa de registradora ou banco é data cascade em potencial."
	},
]

meshExamples: [
	{
		id:       "ex-slo-definition-anticipation-flow"
		scenario: "Mesh precisa definir SLOs para o fluxo de antecipação de recebíveis end-to-end: da solicitação do fornecedor até o crédito na conta."
		analysis: "Stakeholder: fornecedor. O que o fornecedor experimenta: submete solicitação → espera → recebe ou não o crédito. SLI candidato: tempo entre submissão e crédito na conta (ou rejeição comunicada). O fluxo interno: solicitação → validação de documentos → scoring → decisão (aprovação/rejeição/escalation) → liquidação via banco → notificação. Cada etapa tem latência variável. Maior variabilidade: scoring (depende de dados disponíveis), liquidação (depende de banco parceiro), escalation (depende de humano). SLO deve refletir experiência end-to-end, não etapas internas."
		recommendation: "SLI: tempo entre submissão de solicitação e resolução (crédito ou comunicação de rejeição). SLO: 95% resolvidas em <48h, 99% em <72h. Error budget mensal (100 operações): 5 podem exceder 48h, 1 pode exceder 72h. SLIs internos (para diagnóstico, não SLO para stakeholder): scoring <10s (99%), validação de documentos <2h (95%), liquidação <24h (95%). Alerting: burn rate de error budget — se 3 operações excedem 48h nos primeiros 10 dias do mês, alerta de warning. Se 5 excedem em 15 dias, alerta urgente (congelar mudanças no pipeline, investigar). Revisão mensal: SLO atingido? Se consistentemente atingido com margem >50%: considerar apertar (move para 97%). Se consistentemente violado: investir em etapa mais lenta (provavelmente liquidação ou escalation)."
		principlesApplied: ["ax-01", "ax-06", "dp-01"]
		assumptions: [
			"95% em <48h é expectativa realista dado banco parceiro — verificar SLA do banco",
			"100 operações/mês é volume suficiente para error budget ser significativo",
			"fornecedor considera 48h aceitável — validar com pesquisa ou feedback",
			"etapa mais lenta é liquidação bancária — verificar com dados reais",
		]
		rationale: "Beyer et al. 2016: SLO baseado em experiência do stakeholder. Hidalgo 2020: SLO reflete realidade. Error budget governa trade-off velocidade vs estabilidade. SLIs internos para diagnóstico, SLO externo para contrato de confiabilidade."
	},
	{
		id:       "ex-data-cascade-stale-revenue"
		scenario: "Agente de scoring aprova antecipação de R$200k para comprador cujo faturamento caiu 60% nos últimos 2 meses. Dados de faturamento no sistema estavam com 45 dias de defasagem. Score calculado com dados antigos: 78 (acima do threshold). Score com dados atuais teria sido: 42 (abaixo do threshold)."
		analysis: "Data cascade clássica (Sambasivan et al. 2021): dado desatualizado (timeliness) → score inflado → decisão errada → perda financeira. Root cause: pipeline de ingestão de dados de faturamento não tinha monitoramento de freshness. Nenhum alerta disparou porque nenhum alerta estava configurado para verificar se dados >30 dias estavam sendo usados. O agente de scoring processou dados antigos com a mesma confiança que processaria dados frescos — sem flag de incerteza."
		recommendation: "(1) Imediato: implementar gate de freshness no scoring pipeline — rejeitar automaticamente scoring se dados de faturamento >30 dias, escalar para atualização manual. (2) Data observability: para cada campo usado em scoring, definir freshness SLO (faturamento: <30d, CNPJ: <90d, documentação: <180d). Alertar se freshness violada. (3) Confidence flag: agente de scoring deve incluir no output: data_freshness_days e confidence_adjustment — se dados >15d, confidence cai proporcionalmente, e se >30d, scoring não executa. (4) Retroactive: auditar todas as operações onde dados de faturamento tinham >30d no momento do scoring. Quantificar exposição. (5) Pipeline: rastrear lineage — de onde vem o dado de faturamento, quando foi atualizado pela última vez, quais transformações passou. (6) Post-mortem: documentar como data cascade blameless, com action items e deadlines."
		principlesApplied: ["ax-05", "ax-07", "dp-01"]
		assumptions: [
			"30 dias é threshold adequado para freshness de faturamento — pode variar por setor e sazonalidade",
			"dados de faturamento são obtidos de fonte única — se há múltiplas fontes, reconciliação adicional",
			"gate de freshness não bloqueia volume significativo de operações legítimas — verificar",
			"R$200k é dentro do blast radius aceitável — se não, cap de AAG precisa revisão",
		]
		rationale: "Sambasivan et al. 2021: data cascades propagam silenciosamente. Barr Moses et al. 2022: freshness é dimensão crítica. O scoring processou dados errados com confiança alta — o problema não é o modelo, é o dado. Gate de freshness é defense-in-depth upstream do scoring."
	},
	{
		id:       "ex-chaos-experiment-bank-unavailable"
		scenario: "Mesh depende de banco parceiro único para liquidação de antecipações. Nenhum teste de resiliência foi feito. Founder quer verificar: o que acontece se banco ficar indisponível por 4h durante horário comercial?"
		analysis: "SPOF identificado no mapa de topologia: banco parceiro é single point of failure para liquidação. Se indisponível: nenhuma antecipação aprovada é liquidada, fornecedores não recebem, SLO de 48h é violado para operações em trânsito. Impacto estimado: ~5-10 operações em trânsito durante janela de 4h. Blast radius: R$500k-1M em liquidações atrasadas. Atualmente: nenhum fallback, nenhuma fila de retry, nenhuma comunicação automática para fornecedores sobre atraso."
		recommendation: "Chaos experiment em staging: (1) Definir steady state: operações de liquidação são processadas em <4h após aprovação. (2) Hipótese: se banco indisponível por 4h, operações ficam em fila e são processadas automaticamente quando banco retorna, sem perda e com notificação proativa ao fornecedor. (3) Injetar falha: simular timeout/503 do banco por 4h no ambiente de staging. (4) Observar: operações são enfileiradas? Retry funciona? Notificação de atraso é enviada? Quando banco retorna, fila é processada em ordem? SLO de 48h ainda é atingido? (5) Descobertas esperadas: provavelmente retry não está implementado, fila não existe, e notificação de atraso não é enviada. Cada descoberta vira action item. Implementar: (a) fila persistente para liquidações pendentes com retry exponencial. (b) notificação automática a fornecedor: 'sua antecipação está aprovada, liquidação em processamento — previsão atualizada: [timestamp]'. (c) alerting: se fila >10 operações ou >2h, escalar para humano. (d) longo prazo: segundo banco parceiro como fallback (eliminar SPOF)."
		principlesApplied: ["ax-03", "ax-05", "dp-05"]
		assumptions: [
			"4h é duração realista de indisponibilidade — verificar SLA do banco parceiro e histórico",
			"staging é suficientemente representativo de produção para o experimento ser válido",
			"segundo banco parceiro é viável operacionalmente e financeiramente — avaliar custos e timeline",
			"fornecedor aceita notificação de atraso como mitigação — vs expectativa de 0 atraso",
		]
		rationale: "Rosenthal et al. 2020: experimentar antes que a falha aconteça. Perrow 1984: SPOF em sistema tightly-coupled. Na Mesh, banco parceiro indisponível é questão de quando, não se. Chaos experiment transforma quando em agora-controlado."
	},
	{
		id:       "ex-feedback-loop-scoring-bias"
		scenario: "Mesh opera há 12 meses. Análise de distribuição de scores revela: score médio subiu de 65 para 74 ao longo do período. Taxa de aprovação subiu de 60% para 82%. Inadimplência permanece em 1.5%. Founder suspeita de feedback loop."
		analysis: "Feedback loop de survivorship bias: (1) meses 1-3: scoring treina com dados diversos (todos que se candidatam). (2) meses 4-6: scoring aprova melhor perfil → melhores perfis retornam e geram mais dados → perfis marginais são rejeitados e saem do dataset. (3) meses 7-12: scoring está calibrado para perfil que ele mesmo selecionou — score médio sobe porque o pool filtrado é melhor, não porque scoring melhorou. Taxa de aprovação sobe porque pool é mais homogêneo. Inadimplência estável porque perfis aprovados são de fato bons — mas o modelo perdeu capacidade de avaliar perfis diferentes. (4) Risco: se Mesh entrar em novo segmento (infraestrutura) ou se base de fornecedores mudar, scoring performará mal porque nunca viu perfis diferentes. Delay do loop: ~6 meses para score médio mudar visivelmente. Sem monitoramento de distribuição: loop opera por anos sem detecção."
		recommendation: "(1) Confirmar loop: comparar distribuição de features dos candidatos (todos) vs aprovados (subset) ao longo do tempo. Se divergência crescente: loop confirmado. (2) Monitorar: PSI da distribuição de scores mensal. Se PSI >0.25 sem mudança de policy: flag de drift. (3) Balancing mechanism: reservar 5-10% do volume para 'exploração' — aprovar fornecedores com score marginal (55-65) com cap de valor baixo (R$10k) para gerar dados de perfis que o scoring não está vendo. Custo controlado, aprendizado valioso. (4) Out-of-time validation: testar scoring periodicamente em dados que não foram gerados pelo próprio loop (dados históricos pré-Mesh, dados de parceiros, dados sintéticos representativos). Se AUROC cai em OOT validation: scoring está overfitted ao pool selecionado. (5) Documentar: feedback loop mapeado, mecanismo de balancing definido, proxy monitorado (PSI), cadência de OOT validation (trimestral)."
		principlesApplied: ["ax-05", "ax-07", "dp-01"]
		assumptions: [
			"survivorship bias é a causa principal do score shift — podem haver outras causas (melhoria real do pool, mudança de mercado)",
			"5-10% de volume exploratório é aceitável financeiramente — custo de inadimplência nesse subset deve ser orçado",
			"OOT validation com dados históricos é representativo — perfil de fornecedor pode ter mudado estruturalmente",
			"PSI >0.25 é threshold adequado — calibrar com dados reais",
		]
		rationale: "Sculley et al. 2015: feedback loops em ML são hidden technical debt. Meadows 2008: reinforcing loops sem balancing divergem. Na Mesh, scoring loop é particularmente perigoso porque parece melhorar (score sobe, inadimplência estável) enquanto perde capacidade de avaliar diversidade. Monitoramento + exploration forçada é o balancing mechanism."
	},
	{
		id:       "ex-integration-breaking-change"
		scenario: "Registradora atualiza API de registro de operações — campo 'tipo_cessao' que era opcional tornou-se obrigatório. Mesh não tem contract test para essa integração. Na segunda-feira, pipeline de registro começa a retornar erro 400 para todas as operações. 47 operações aprovadas e liquidadas não são registradas por 6h até detecção manual."
		analysis: "Falha de integration contract: terceiro mudou interface sem aviso (ou aviso não foi processado). Sem contract test, breaking change detectada apenas em produção quando pipeline falha. Sem alerta de taxa de erro da registradora, falha detectada 6h depois por inspeção manual. Blast radius: 47 operações não-registradas — risco regulatório (operação de crédito sem registro é irregular) e operacional (reconciliação futura complicada). Dívida operacional materializada: (1) contract test ausente, (2) alerta de erro rate da registradora ausente, (3) fallback de registro não definido."
		recommendation: "(1) Remediar: registrar as 47 operações manualmente ou via batch re-submission com campo corrigido. Verificar se há multa ou penalidade regulatória por delay no registro. (2) Contract test: implementar contract test diário para API da registradora — verificar schema, campos obrigatórios, formato de resposta, latência. Se contrato violado: alerta imediato + bloqueio de novas operações até correção. (3) Adapter layer: isolar lógica de registro do formato da API — quando API muda, apenas adapter precisa de update. (4) Alerta de erro rate: implementar alerta se taxa de erro da registradora >2% em janela de 30min (teria detectado em 30min vs 6h). (5) Fallback: se registradora indisponível, operações ficam em fila com retry automático + notificação proativa ao regulador se delay >24h. (6) Comunicação: incluir no regulatory update — 'incidente de registro com delay de 6h, causa raiz identificada, correções implementadas'. (7) Post-mortem: documentar como incidente de dívida operacional materializada — contract test e alerta eram dívida conhecida? Se sim: falha de priorização. Se não: falha de mapeamento de risco."
		principlesApplied: ["ax-03", "ax-05", "dp-01"]
		assumptions: [
			"registradora aceita batch re-submission para operações atrasadas — verificar",
			"delay de 6h no registro não gera penalidade regulatória automática — verificar com assessoria",
			"contract test diário é frequência suficiente — se registradora atualiza em off-hours, pode precisar de monitoramento contínuo",
			"47 operações é volume real do gap — verificar com audit trail de liquidação vs registro",
		]
		rationale: "Robinson 2023: contract testing previne exatamente este cenário. Cunningham 1992: dívida operacional (contract test ausente) se materializa como incidente. A integração mais estável ainda pode mudar — contract testing é a defesa. Custo do incidente (47 operações não-registradas + remediação + risco regulatório) >> custo do contract test (1 dia de implementação)."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-05", "ax-07", "dp-01", "dp-05"]

relatedLenses: [
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governa agentes individuais — autonomia, escalation, drift, lifecycle. OOI governa o sistema end-to-end — pipelines, integrações, dados, feedback loops, degradação graciosa. AAG pergunta 'este agente está operando dentro da fronteira?'; OOI pergunta 'o sistema como um todo está saudável?'. Observability contract de AAG é subset da observabilidade sistêmica de OOI. Circuit breaker de OOI pode implementar blast radius containment de AAG. Sobreposição explícita: drift detection de AAG (agente individual) complementa anomaly detection de OOI (sistema); escalation protocol de AAG alimenta incident management de OOI."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA aloca recursos entre atividades. OOI gera informação que alimenta alocação — incidentes revelam onde investir, toil revela o que automatizar, SLOs revelam onde confiabilidade precisa de investimento, capacity planning antecipa quando constraint vai mudar. Action items de post-mortem e itens de dívida operacional são inputs para WSJF de ORA. OOI diz 'pipeline de registro falha 3x/mês'; ORA diz 'CoD de fix é urgente, priorizar'."
	},
	{
		lensId:   "lens-credit-risk"
		relation: "complementsWith"
		context:  "CR monitora modelos de scoring específicos (AUROC, PSI, calibration). OOI monitora qualidade de dados upstream do scoring, feedback loops que afetam o scoring downstream, e capacity do pipeline de scoring. CR é model-level; OOI é system-level. Data quality de OOI é precondição de model quality de CR. Feedback loop detection de OOI (survivorship bias no scoring) alimenta model recalibration de CR."
	},
	{
		lensId:   "lens-complex-adaptive-systems"
		relation: "complementsWith"
		context:  "CAS modela teoria de emergência e adaptação em sistemas complexos. OOI operacionaliza detecção e gerenciamento de comportamento emergente no sistema real. CAS diz 'por que emergência acontece'; OOI diz 'como detectar e gerenciar emergência na Mesh'. CAS provê a teoria de feedback loops; OOI provê o monitoramento de proxies e os balancing mechanisms."
	},
	{
		lensId:   "lens-mechanism-design"
		relation: "complementsWith"
		context:  "MD desenha mecanismos com feedback loops intencionais (scoring melhora com dados, reputação acumula com performance). OOI monitora se loops intencionais estão operando como projetado e se loops não-intencionais emergiram. MD cria o mecanismo e seus loops; OOI verifica em runtime se o mecanismo está saudável e se o loop não gerou efeito colateral."
	},
	{
		lensId:   "lens-stakeholder-communication"
		relation: "complementsWith"
		context:  "SC define como comunicar incidentes e crises a stakeholders. OOI define o lifecycle operacional de detecção e resposta. OOI detecta e resolve; SC comunica. Incidente SEV-1 de OOI trigger protocolo de crise de SC. SLOs de OOI são base para expectation management de SC — 'prometemos 48h' porque SLO é 95% em <48h."
	},
	{
		lensId:   "lens-contract-theory"
		relation: "complementsWith"
		context:  "CT modela contratos incompletos e risco de hold-up em dependências. OOI monitora operacionalmente se dependências estão cumprindo contratos (contract testing) e projeta fallbacks quando não cumprem (degradação graciosa). CT diz 'contrato com banco é incompleto — cenário X não está coberto'; OOI diz 'para cenário X, fallback é Y e circuit breaker Z'."
	},
	{
		lensId:   "lens-real-options"
		relation: "complementsWith"
		context:  "RO modela investimentos reversíveis e timing sob incerteza. OOI gera informação que reduz incerteza para exercício de opções — dados operacionais, trends de volume, health de integrações. Chaos engineering de OOI é experimentação controlada que informa se a organização está pronta para exercer opção (ex: chaos test de volume 10x informa se é seguro escalar). RO pergunta 'quando expandir?'; OOI informa 'sistema suporta expansão com margem de X%'."
	},
]

limitations: [
	{
		description: "Observabilidade gera volume de dados que pode se tornar ingerível — mais dados ≠ melhor diagnóstico. Log overload degrada capacidade de investigação."
		alternative: "Aplicar princípio de sampling e agregação: nem tudo precisa de log detalhado. Operações de alta consequência: log completo. Operações de rotina: log resumido com sampling de 10% para detalhamento. Investir em ferramentas de query e visualização, não apenas em volume de coleta."
		rationale: "Majors et al. 2022: observabilidade é capacidade de investigar, não volume de dados. Dados sem capacidade de query são custo, não ativo."
	},
	{
		description: "Chaos engineering em produção pode causar dano real se blast radius não for contido. Em startup pré-revenue com poucos clientes, cada falha é visível e reputacionalmente cara."
		alternative: "Pré-revenue: chaos exclusivamente em staging com dados representativos. Pós-tração: chaos em produção com blast radius controlado (shadow traffic, % mínimo). Nunca chaos em produção sem circuit breaker e rollback testados."
		rationale: "Rosenthal et al. 2020: chaos engineering é investimento em confiança — mas o custo deve ser controlado. Em early-stage, reputação > experimentação."
	},
	{
		description: "SLOs podem gerar Goodhart's Law — equipe/agentes otimizam para SLO em vez de para experiência real do stakeholder. SLO de 48h pode levar a pipeline que entrega tudo em 47h59m em vez de otimizar para <24h."
		alternative: "SLOs como floor, não como target. Monitorar distribuição completa (percentis P50, P90, P99), não apenas se SLO foi atingido. Complementar com feedback qualitativo do stakeholder."
		rationale: "Goodhart's Law opera em toda métrica que vira target. SLO é contrato mínimo — experiência ótima está acima do SLO."
	},
	{
		description: "Detecção de anomalias gera falsos positivos que causam alert fatigue — humano ignora alertas porque 90% são falso alarme."
		alternative: "Calibrar thresholds agressivamente — falso positivo deve ser <20% para alertas de ação humana. Alertas informativos (agente processa) podem ter falso positivo mais alto. Implementar alert suppression inteligente: se anomalia recorre diariamente às 2am por 30 dias, é padrão — não anomalia."
		rationale: "Alert fatigue é modo de falha real: equipe de ops que ignora alertas é pior que equipe sem alertas — falsa sensação de segurança."
	},
	{
		description: "Framework assume que o sistema é instrumentável — que logs, métricas e traces podem ser adicionados. Para integrações com terceiros (banco, registradora), observabilidade depende do que o terceiro expõe."
		alternative: "Para dependências externas: monitorar o que é observável (latência, disponibilidade, erro rate da API) e inferir o resto. Negociar SLAs com fornecedores que incluam métricas de observabilidade. Aceitar que observabilidade de dependências externas é estruturalmente limitada. Contract testing monitora conformidade de interface; não monitora estado interno do terceiro."
		rationale: "Observabilidade plena requer instrumentação. Dependências externas são caixas-pretas parciais — monitorar o envelope, não o interior."
	},
	{
		description: "Dívida operacional é difícil de priorizar porque o custo é probabilístico (risco × impacto) enquanto o custo de features novas é determinístico (horas de engenharia). Pressão por features tende a superar investimento em pagamento de dívida."
		alternative: "Reservar budget fixo (20% do sprint) para pagamento de dívida — não compete com features no backlog. Se dívida em componentes essenciais (liquidação, dados financeiros) excede threshold: priorizar incondicionalmente sobre features."
		rationale: "Forsgren et al. 2018: organizações de alta performance investem continuamente em qualidade operacional. Dívida em componentes essenciais é risco existencial, não trade-off."
	},
	{
		description: "Capacity planning em startup pré-revenue é especulativo — projeções de volume são incertas por definição. Investir demais em capacidade antes de validação é desperdício; investir de menos causa degradação quando demanda chega."
		alternative: "Capacity planning em early-stage deve focar em lead times, não em precisão de volume. Perguntar 'se volume 5x chegar em 3 meses, consigo expandir capacidade a tempo?' é mais útil que 'qual será o volume exato'. Priorizar componentes com lead time longo (banco, regulador) sobre componentes com lead time curto (compute cloud)."
		rationale: "Hixson 2015: capacity planning com incerteza requer margem. Na Mesh pré-revenue, lead time > projeção de volume como driver de decisão."
	},
]

rationale: "Toda organização que opera software em produção precisa observar, diagnosticar e evoluir seu sistema. Na Mesh AI-native, o sistema é composto por agentes IA, pipelines de dados, integrações com terceiros e fluxos financeiros — cada um com modos de falha e interdependências. Esta lens operacionaliza: observabilidade como capacidade de diagnosticar o desconhecido (Sridharan 2018, Majors et al. 2022), SLOs como contratos de confiabilidade baseados em experiência do stakeholder com burn rate alerting (Beyer et al. 2016/2018, Hidalgo 2020, Murphy et al. 2024), qualidade de dados como risco operacional contínuo com 5 dimensões de data observability (Sambasivan et al. 2021, Barr Moses et al. 2022, Polyzotis et al. 2019), chaos engineering como verificação de resiliência contínua (Rosenthal et al. 2020, Nines/Robbins 2024), topologia operacional com SPOFs, failure domains e topologia de dados (Perrow 1984, Skelton/Pais 2019, Nygard 2018, Dehghani 2022), detecção de anomalias em três camadas incluindo LLM-enhanced (Chandola et al. 2009, Zhao et al. 2023), incident management com AIOps e resilience engineering (Huang et al. 2019, Cook/Woods 2023, Woods 2019), feedback loops e emergência com monitoramento de proxies (Meadows 2008, Sterman 2000, Sculley et al. 2015, Agrawal et al. 2022), eliminação de toil com AI-assisted detection (Beyer et al. 2016, Forsgren et al. 2018), degradação graciosa com circuit breaker, bulkhead e hierarquia de funcionalidade (Nygard 2018, Woods 2019, Verma et al. 2023), dívida operacional como risco acumulado incluindo AI debt (Cunningham 1992, Forsgren et al. 2018, Bogner et al. 2021), capacity planning com compute scaling para agentes IA (Hixson 2015, Hoyer et al. 2022, Kaplan et al. 2020), contract testing de integrações com API observability contínua (Clemson 2014, Robinson 2023, Postman 2023), e cultura de confiabilidade generativa como propriedade emergente codificada em artefatos (Dekker 2006, Westrum 2004, Reason 1997, Google DORA 2024). Universal, agnóstica a estágio, aplicável a qualquer organização com sistema operacional em produção."

}
