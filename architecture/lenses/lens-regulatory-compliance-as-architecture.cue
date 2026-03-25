package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

regulatoryComplianceAsArchitecture: artifact_schemas.#AnalyticalLens & {
id:     "lens-regulatory-compliance-as-architecture"
name:   "Compliance Regulatória como Arquitetura"

purpose: "Orientar decisões sobre como embedar compliance regulatória na arquitetura — Bacen, CVM, LGPD como constraints de design, não afterthoughts."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como projetar sistemas que são compliant by design, não compliant by retrofit",
		"a decisão envolve como regulação de intermediários financeiros (FIDC, cessão de recebíveis, SCD) afeta arquitetura",
		"a decisão envolve como LGPD, sigilo bancário e proteção de dados impactam design de sistemas e dados",
		"a decisão envolve como audit trail, reporting regulatório e prestação de contas são implementados",
		"a decisão envolve como antecipar mudanças regulatórias e projetar flexibilidade para acomodá-las",
		"a decisão envolve como compliance é automatizada por agentes IA mantendo governança e auditabilidade",
		"a decisão envolve como demonstrar compliance para regulador de forma proativa e transparente",
		"a decisão envolve como compliance com múltiplas regulações simultaneamente (financeira, dados, trabalhista) é gerenciada",
		"a decisão envolve como custos de compliance são minimizados sem comprometer rigor",
		"a decisão envolve como regulação afeta decisões de produto (features obrigatórias, proibidas, ou condicionadas)",
	]
	keywords: [
		"regulação", "regulation", "compliance", "conformidade",
		"Bacen", "Banco Central", "CVM", "regulador",
		"FIDC", "cessão", "recebíveis", "antecipação",
		"SCD", "SCR", "registradora", "registro",
		"LGPD", "proteção de dados", "privacy", "privacidade",
		"sigilo bancário", "sigilo", "confidencialidade",
		"audit trail", "auditoria", "rastreabilidade",
		"reporting", "relatório regulatório", "prestação de contas",
		"KYC", "KYB", "PLD/FT", "lavagem de dinheiro",
		"by design", "compliance by design", "privacy by design",
		"licença", "autorização", "sandbox regulatório",
		"open finance", "portabilidade", "interoperabilidade",
	]
	excludeWhen: [
		"a decisão é sobre segurança técnica (encryption, access control, infra) — usar security-trust-infrastructure",
		"a decisão é sobre governança de agentes IA (autonomia, escalation) — usar ai-agent-governance",
		"a decisão é sobre comunicação com stakeholders incluindo regulador — usar stakeholder-communication",
		"a decisão é sobre explicabilidade de modelos para compliance — usar ml-ai-systems-design (ml-explainability)",
		"a decisão é sobre audit trail técnico (event sourcing, logs) — usar event-driven-architecture-patterns",
	]
	rationale: "Toda organização que opera no setor financeiro regulado precisa tratar compliance não como custo ou restrição mas como decisão arquitetural — projetar sistemas que são compliant by design, não que recebem compliance como camada posterior. Na Mesh como intermediário financeiro AI-native operando cessão de recebíveis via FIDC, a regulação governa: quem pode operar (licenciamento), o que pode fazer (cessão, registro, antecipação), como deve operar (governance, reporting, auditabilidade), e como dados são tratados (LGPD, sigilo bancário). STI cobre segurança técnica; AAG cobre governança de agentes; EDA cobre audit trail técnico; ML cobre explicabilidade. Esta lens cobre como regulação informa decisões de arquitetura, produto e operação — transformando obrigações regulatórias em features de produto, vantagem competitiva, e trust institucional."
}

concepts: [
	{
		id:         "rc-compliance-by-design"
		name:       "Compliance by Design: Regulação como Requisito Arquitetural, Não como Retrofit"
		nature:     "theoretical"
		role:       "framework"
		definition: "Conceito derivado de 'privacy by design' (Cavoukian 2009, 7 Foundational Principles): incorporar requisitos regulatórios desde o início do design, não como camada adicionada depois. Em software: compliance by design significa que o sistema é estruturalmente capaz de cumprir regulação — não que alguém verifica manualmente depois. Conceito contemporâneo de 'regulatory architecture' (Arner et al. 2020, 'FinTech, RegTech, and the Reconceptualization of Financial Regulation'): regulação é input de arquitetura assim como requisitos funcionais. Cada obrigação regulatória se traduz em: (1) data requirement — quais dados coletar e reter. (2) process requirement — quais workflows seguir. (3) reporting requirement — quais relatórios produzir e quando. (4) audit requirement — quais evidências preservar. (5) control requirement — quais limites e gates implementar. Conceito de 'RegTech' (2019+): tecnologia aplicada à compliance — automação de KYC, monitoring de PLD/FT, reporting automatizado, audit trail digital. Na Mesh AI-native: agentes de compliance são RegTech. Conceito contemporâneo de 'compliance as competitive advantage' (2023+): em setores regulados, organização que faz compliance melhor que competidores: (a) opera mais rápido (aprovação regulatória mais rápida). (b) gasta menos (automação vs manual). (c) gera mais trust (regulador confia → relação melhor). (d) habilita features que competidores não-compliant não podem oferecer."
		meshManifestation: "Na Mesh, compliance by design em 4 camadas: (1) data — event sourcing (eda-event-sourcing) como audit trail nativo. Cada operação é sequência imutável de eventos com timestamps, actors, e dados. Regulador pergunta 'reconstrua operação X': replay. Não é sistema de auditoria separado — é a arquitetura. (2) process — workflows de antecipação incluem gates de compliance: documentação validada, scoring calculado, operação registrada em registradora. Gates são parte do workflow, não verificação posterior. (3) reporting — relatórios regulatórios gerados automaticamente a partir da semantic layer (dm-semantic-layer). Mesmos dados que alimentam dashboard de FIDC alimentam report para regulador. Consistência garantida por design. (4) control — limites de operação, scoring thresholds, e escalation rules são governados por configuração no mesh-spec (aag-governance-as-code). Não são julgamento ad hoc — são regras auditáveis. Compliance não é departamento — é propriedade do sistema."
		meshImplication: "Para cada obrigação regulatória: (1) identificar — qual regulação se aplica? (Bacen, CVM, LGPD, PLD/FT). (2) traduzir em requisito arquitetural — não 'precisamos cumprir LGPD' mas 'dados pessoais classificados por sensibilidade, retention policy por tipo, consentimento rastreado, portabilidade implementada.' (3) implementar como feature do sistema — audit trail não é log separado: é event sourcing. Reporting não é planilha manual: é query na semantic layer. KYC não é verificação manual: é agente que valida automaticamente com fallback humano. (4) testar compliance — assim como se testa funcionalidade (unit tests), testar compliance: 'operação sem documentação válida é rejeitada?' 'Relatório regulatório contém todos os campos obrigatórios?' 'Dados pessoais são mascarados em logs?' Compliance tests em CI. (5) documentar — para cada obrigação: ADR com: regulação, requisito, implementação técnica, teste, e owner. Mapa regulatório no mesh-spec: tabela [regulação] × [requisito] × [implementação] × [status]. (6) treat compliance changes like API changes — nova regulação = novo requisito. Avaliar impact, implementar, testar, deployar. Changelog de compliance. Anti-pattern: compliance como verificação manual trimestral feita por advogado que não entende o sistema — descobre problema 3 meses depois quando já é late."
		rationale: "Cavoukian 2009: privacy by design. Arner et al. 2020: regulatory architecture. RegTech 2019+. Compliance as competitive advantage 2023+. Na Mesh, compliance by design significa que o sistema é estruturalmente compliant — regulador que inspeciona encontra audit trail nativo, não logs reconstruídos à pressas."
	},
	{
		id:         "rc-regulatory-landscape"
		name:       "Mapa Regulatório: Quais Regulações Governam Cada Aspecto da Operação"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "semi-annual"
		definition: "Conceito de 'regulatory mapping' (2022+): inventário de todas as regulações aplicáveis, organizadas por domínio e impacto. Para cada regulação: (1) escopo — o que regula. (2) obrigações — o que exige. (3) autoridade — quem fiscaliza. (4) consequência — o que acontece se violar. (5) status — em vigor, em consulta pública, projetada. Conceito contemporâneo de 'regulatory horizon scanning' (2023+): monitorar não apenas regulação em vigor mas regulação em desenvolvimento — consultas públicas, projetos de lei, sandboxes regulatórios, tendências internacionais que podem ser adotadas localmente. Antecipar regulação futura permite projetar flexibilidade."
		meshManifestation: "Na Mesh, regulações aplicáveis: (1) intermediação financeira — Resolução Bacen nº 4.656/2018 (SCD/SEP), Resolução CMN 2.907/2001 (FIDC), Resolução CMN 4.893/2021 (política de segurança cibernética para IF). Se Mesh opera como correspondente ou via parceria com SCD: requisitos de correspondente. Se Mesh opera SCD própria (futuro): requisitos de capital, reporting, PLD/FT completos. (2) cessão de recebíveis — Lei 9.514/1997, Lei 13.775/2018 (registro de duplicatas). Registro obrigatório em registradora (CIP, CERC, TAG). Cessão sem registro: ineficaz contra terceiros. (3) proteção de dados — LGPD (Lei 13.709/2018). Obrigações: base legal para tratamento, consentimento quando aplicável, portabilidade, DPO, RIPD (Relatório de Impacto à Proteção de Dados), notificação de incidentes. (4) PLD/FT — Lei 9.613/1998 + circulares Bacen. KYC/KYB (identificação de clientes), monitoramento de transações atípicas, comunicação de operações suspeitas (COAF). (5) sigilo bancário — LC 105/2001. Dados financeiros de clientes são sigilosos. Compartilhamento apenas com consentimento ou ordem judicial. (6) defesa do consumidor — CDC (Lei 8.078/1990). Transparência de taxas, condições claras, direito a informação. (7) open finance (futuro) — regulação de compartilhamento de dados financeiros. Pode afetar como Mesh acessa e compartilha dados. (8) regulação de IA (projetada) — PL 2.338/2023 (Marco Legal da IA). Pode exigir explicabilidade, fairness, e auditabilidade de decisões automatizadas. Não é lei ainda mas horizon scanning."
		meshImplication: "Mapa regulatório como artefato no mesh-spec: (1) tabela: [regulação] × [obrigação] × [impacto na Mesh] × [implementação técnica] × [status] × [owner] × [review date]. (2) para cada regulação: traduzir obrigações em requisitos técnicos. LGPD Art. 18 (portabilidade): API de export de dados do participante. LGPD Art. 46 (segurança): sti-data-protection-by-design. PLD/FT (monitoramento): pipeline de detecção de anomalias (ooi-anomaly-detection) com alerta para compliance officer. Registro de cessão: integração com registradora (CIP/CERC/TAG) como step obrigatório no workflow de antecipação. (3) horizon scanning semestral: quais regulações estão em consulta pública? PL de IA: impacto em scoring e agentes. Open finance: impacto em acesso a dados. Novo normativo de registradora: impacto em workflow de registro. Para cada regulação projetada: assessment de impacto + plano de adaptação. (4) assessoria jurídica: mapa regulatório é input para assessoria, não substituto. Para cada obrigação complexa (SCD, FIDC, PLD/FT): validar implementação técnica com assessoria. Mesh não é escritório de advocacia — mas pode implementar compliance melhor que maioria porque é by design. (5) regulatory risk register: para cada regulação, risco de não-compliance: probabilidade × impacto. High risk: multa significativa ou proibição de operar. Priorizar mitigação. Anti-pattern: 'vamos ver quando o regulador exigir' — regulatory surprise é o cenário mais caro (multa + retrabalho + trust damage com FIDC)."
		dependsOn: ["rc-compliance-by-design"]
		crossDependsOn: [{
			lensId:    "lens-regulatory-strategy"
			conceptId: "rs-regulatory-relationship"
			context:   "RS define relação proativa com regulador (transparência, antecipação, diálogo). RC mapa regulatório informa RS: quais regulações existem, quais estão em horizonte, e quais obrigações devem ser comunicadas proativamente ao regulador. RS é a relação; RC é o conteúdo (o que cumprimos e como). RS diz 'demonstrar compliance proativamente'; RC diz 'aqui está o mapa de tudo que cumprimos, como cumprimos, e o que estamos preparando para cumprir'."
		}]
		rationale: "Regulatory mapping 2022+. Horizon scanning 2023+. Na Mesh, operar sem mapa regulatório é navegar sem mapa — cada decisão de produto arrisca violar regulação que não foi mapeada. Mapa no mesh-spec é artefato vivo que agentes consultam antes de implementar."
	},
	{
		id:         "rc-automated-compliance"
		name:       "Compliance Automatizada: Agentes que Cumprem Regulação em Escala"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Conceito de RegTech (Arner et al. 2017, 'FinTech and RegTech in a Nutshell'): tecnologia para compliance regulatória — automação de processos que eram manuais, caros e propensos a erro. Em Mesh AI-native: agentes IA como RegTech — validam documentos, monitoram transações, geram relatórios, e detectam anomalias automaticamente. Conceito contemporâneo de 'continuous compliance' (2023+): em vez de compliance verificada periodicamente (auditoria anual), compliance verificada continuamente — cada operação é validada em tempo real, cada relatório é gerado automaticamente, cada anomalia é detectada quando acontece. Conceito de 'compliance-as-code' (2022+, análogo a governance-as-code): regras de compliance codificadas como configuração ou policy executável — não como documento jurídico que humano interpreta. Se regulação diz 'operação >R$10k requer documentação completa': rule no mesh-spec que bloqueia operação >R$10k sem documentação. Machine-readable, testável, auditável."
		meshManifestation: "Na Mesh, compliance automatizada: (1) KYC/KYB — agente valida CNPJ (Receita Federal), consulta de protestos (Serasa), consulta de processos judiciais, verificação de sócios (PEP — pessoa politicamente exposta). Automático para 90% dos casos. Escalação para humano: sócio é PEP, informações inconsistentes, CNPJ recém-criado (<6 meses). (2) documentação — agente LLM valida CND, certidões, contratos (ml-llm-integration-patterns). Verifica: validade, CNPJ correto, tipo de documento. Automático para documentos padronizados. Escalação: formato incomum, documento ilegível, informação contraditória. (3) registro de cessão — integração automática com registradora (CIP/CERC/TAG). Após aprovação: operação registrada automaticamente. Confirmação de registro como step do workflow. Sem registro: operação não é eficaz contra terceiros — gate obrigatório. (4) PLD/FT — pipeline de monitoramento: flag operações atípicas (valor muito acima do padrão, frequência incomum, beneficiário em lista restritiva). Alert para compliance officer (humano). Comunicação ao COAF se confirmada suspeita. (5) relatório regulatório — gerado automaticamente: carteira do FIDC, operações por período, inadimplência, compliance status. Mesmo semantic layer que dashboard de FIDC (dm-semantic-layer). Formato conforme normativo. (6) LGPD — consentimento rastreado por participante. Portabilidade via API. Dados classificados por sensibilidade (sti-data-classification). Retention policy automatizada (dados expirados são archivados/deletados conforme policy)."
		meshImplication: "Automação com governance: (1) para cada processo de compliance: definir automação + escalation + audit. Automação: agente executa 90%. Escalation: 10% para humano (casos ambíguos). Audit: 100% logado no event store. (2) compliance rules como código no mesh-spec: cada regra de compliance é configuração validável. 'Operação >R$500k: requer aprovação humana.' 'Fornecedor com CND vencida >30 dias: bloquear novas operações.' Rules testáveis em CI: 'se operação de R$600k sem aprovação humana: compliance test falha.' (3) monitoring contínuo: não esperar auditoria trimestral. Dashboards de compliance real-time: documentação expirada (quantos fornecedores?), operações sem registro (deveria ser zero), alertas de PLD/FT (quantos? resolvidos?). (4) custo de compliance: automação reduz custo. KYC manual: ~R$50/verificação × 200 fornecedores = R$10k. KYC automatizado: ~R$5/verificação (API costs) = R$1k. Saving: 90%. Reinvestir saving em cobertura melhor (verificar mais frequentemente, não menos). (5) compliance como feature para construtora: 'seus fornecedores são monitorados continuamente — CNDs verificadas automaticamente, alertas 30 dias antes de vencimento.' Compliance é value proposition, não custo (mux-governance-ux). (6) compliance officer: mesmo com automação, humano como oversight. Compliance officer revisa: alertas de PLD/FT, escalações de KYC, relatórios regulatórios antes de envio, e mudanças de compliance rules. No cold start: founder ou assessor assume role. Com tração: compliance officer dedicado. Anti-pattern: 'agentes fazem tudo, não precisamos de compliance officer' — automação executa, humano supervisiona. Regulador espera que humano seja accountable."
		dependsOn: ["rc-compliance-by-design", "rc-regulatory-landscape"]
		crossDependsOn: [
			{
				lensId:    "lens-ai-agent-governance"
				conceptId: "aag-audit-trail"
				context:   "AAG define audit trail para decisões de agentes. RC automated compliance usa agentes para compliance — cada decisão de compliance (KYC aprovado, documento validado, operação registrada) é logged no audit trail. AAG é a governança genérica de agentes; RC é a aplicação específica para compliance. AAG diz 'agente deve ter audit trail'; RC diz 'audit trail de compliance deve satisfazer requisitos do regulador (reconstituição completa de qualquer decisão)'."
			},
			{
				lensId:    "lens-ml-ai-systems-design"
				conceptId: "ml-llm-integration-patterns"
				context:   "ML define patterns de integração de LLMs (RAG, structured output, guardrails). RC usa LLMs para compliance: validação de documentos via LLM com structured output + guardrails. ML é o how (como integrar LLM); RC é o why (para compliance) e o what (validação de CND, certidões). ML diz 'structured output com schema validation'; RC diz 'output de validação de documento deve ser auditable e challengeable'."
			},
		]
		rationale: "Arner et al. 2017: RegTech. Continuous compliance 2023+. Compliance-as-code 2022+. Na Mesh AI-native, compliance automatizada é o que permite operar com custo 90% menor que compliance manual — e com cobertura contínua em vez de periódica. Agentes como RegTech é core da tese AI-native."
	},
	{
		id:         "rc-audit-trail-architecture"
		name:       "Arquitetura de Audit Trail: Reconstituir Qualquer Decisão em Qualquer Momento"
		nature:     "theoretical"
		role:       "property"
		definition: "Audit trail é o registro completo e imutável de todas as ações, decisões e transições que permite reconstituir o que aconteceu, quando, por quem, e por quê. Em intermediário financeiro regulado: audit trail não é nice-to-have — é obrigação. Conceito de 'audit trail by architecture' (2022+): em vez de construir sistema de auditoria separado (que pode estar incompleto ou inconsistente), usar arquitetura que produz audit trail nativamente — event sourcing é o padrão. Cada transição de estado é evento imutável. Reconstituição: replay de eventos. Conceito contemporâneo de 'AI decision audit trail' (EU AI Act 2024, LGPD Art. 20): para decisões automatizadas que afetam direitos (crédito): audit trail deve incluir não apenas a decisão mas os inputs (features, dados), o modelo (versão, hiperparâmetros), e o rationale (SHAP values, threshold aplicado). Reconstituir por que a decisão foi tomada, não apenas que foi tomada."
		meshManifestation: "Na Mesh, audit trail em 3 dimensões: (1) operacional — cada operação de antecipação: sequência de eventos (eda-event-sourcing). AnticipationRequested → DocumentsValidated → BuyerScored → AnticipationDecided → SettlementInitiated → SettlementConfirmed → OperationRegistered. Cada evento: timestamp, actor (agent_id ou human_id), dados, trace_id. Reconstituição: replay de eventos até qualquer ponto. (2) decisional — cada decisão de scoring: ScoreCalculated com model_version, features_snapshot, score, SHAP values, threshold aplicado, decisão (ml-model-versioning-reproducibility). Reconstituição: 'por que operação X foi aprovada? Score 78, threshold 60, fatores principais: faturamento do comprador (contribuição +12), histórico de pagamento (contribuição +8).' (3) compliance — cada verificação de compliance: KYCCompleted com dados verificados, fonte, resultado, agent_id. DocumentValidated com tipo, validade, CNPJ, confidence do LLM. OperationRegistered com registradora, número de registro, confirmação. Reconstituição: 'compliance de fornecedor Y: KYC em [data], CND válida em [data], operações registradas em [registradora] com números [X, Y, Z].'"
		meshImplication: "Audit trail como propriedade arquitetural: (1) event sourcing como implementação nativa — não construir audit trail separado. Event store é o audit trail. Cada evento é imutável, timestamped, com actor e trace_id. (2) AI decision logging — para cada decisão de agente: log no event store com: input (dados e features), model/prompt (versão), output (decisão), rationale (SHAP values ou reasoning chain), e confidence. Não logging de 'aprovado' — logging de 'aprovado porque [features] com [model v2.3] produziram [score 78 > threshold 60] com [SHAP: faturamento +12, pagamento +8].' (3) retention policy — audit trail de operações financeiras: 5+ anos (regulação). Audit trail de decisões de scoring: 5+ anos (LGPD + regulação). Audit trail operacional (sistema): 1+ ano. Tiered storage: hot (último ano, SSD), warm (1-3 anos, HDD), cold (3-5+ anos, object storage). (4) access control — audit trail é sensível (contém dados financeiros de clientes). Acesso: compliance officer, regulador (sob demanda), auditor externo (sob contrato). Não: developers em geral, agentes sem autorização. (5) tamper-evidence — audit trail deve ser tamper-evident: se alguém altera ou deleta evento, alteração é detectável. Event sourcing com append-only + checksums satisfaz. Para compliance crítica: considerar blockchain-inspired hashing (hash de cada evento inclui hash do anterior — chain detecta alteração). (6) reconstituição testada — trimestralmente: selecionar 5 operações aleatórias e reconstituir completamente via replay. Resultado deve coincidir com estado atual. Se não: bug na cadeia de eventos. Anti-pattern: audit log como tabela separada que 'captura' eventos do sistema principal — inconsistência entre log e sistema é questão de tempo."
		dependsOn: ["rc-compliance-by-design"]
		crossDependsOn: [{
			lensId:    "lens-event-driven-architecture-patterns"
			conceptId: "eda-event-sourcing"
			context:   "EDA define event sourcing como pattern arquitetural. RC audit trail usa event sourcing como implementação de audit trail regulatório. EDA é o pattern (append-only, imutável, replay); RC é o requisito (regulador exige reconstituição). EDA diz 'eventos são imutáveis'; RC diz 'imutabilidade satisfaz requisito regulatório de tamper-evidence'. Sem EDA: RC precisa de sistema de auditoria separado (mais frágil)."
		}]
		rationale: "Audit trail by architecture 2022+. AI decision audit trail EU AI Act 2024, LGPD Art. 20. Na Mesh, event sourcing como audit trail é compliance by design — o regulador não pede 'construam sistema de auditoria'; o sistema já é o audit trail."
	},
	{
		id:         "rc-regulatory-reporting"
		name:       "Reporting Regulatório: Gerar Relatórios que o Regulador Confia"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Regulador exige reporting periódico: carteira de FIDC, operações realizadas, inadimplência, compliance status, PLD/FT. Conceito de 'automated regulatory reporting' (2022+): relatórios gerados automaticamente a partir de mesma source of truth que alimenta dashboards internos — não compilados manualmente com dados de fontes diferentes. Conceito contemporâneo de 'RegTech for reporting' (XBRL 2023+, regulatory APIs 2024+): reguladores cada vez mais aceitam (e preferem) reporting digital em formato estruturado — não PDF manual. XBRL (eXtensible Business Reporting Language) para reporting financeiro. APIs regulatórias para submissão direta. Conceito de 'reporting as trust signal' (2023+): relatório regulatório bem-feito é trust signal para FIDC e investidor — demonstra que a organização tem dados confiáveis, governance robusta, e capacidade de produzir informação precisa sob demanda."
		meshManifestation: "Na Mesh, reports regulatórios: (1) FIDC — relatório de carteira mensal: lastro total, inadimplência (dm-semantic-layer: inadimplencia_90d), concentração por comprador, performance por safra, operações novas e encerradas. Formato: conforme regulamento do FIDC. Gerado automaticamente. (2) registradora — registro de cada cessão com dados obrigatórios (cedente, cessionário, sacado, valor, vencimento). Integração automática no workflow. (3) PLD/FT — relatório para COAF se operação suspeita confirmada. Dados: participante, operação, motivo da suspeita, evidências. (4) LGPD — RIPD (Relatório de Impacto à Proteção de Dados) para tratamentos de alto risco. Inventário de tratamentos, bases legais, medidas de segurança. (5) Bacen (se SCD) — reporting periódico: operações, carteira, inadimplência, capital. Formato conforme normativo Bacen."
		meshImplication: "Reporting automatizado: (1) source of truth — todos os reports regulatórios derivam da semantic layer (dm-semantic-layer). Mesma definição de 'inadimplência' no report FIDC, no dashboard de construtora, e no report para Bacen. Não calcular de formas diferentes para audiências diferentes — inconsistência descoberta pelo regulador destrói trust. (2) generation — script/pipeline que gera report a partir de queries na semantic layer. Versionado, testável, reproduzível. Se regulador pede 'regenere o relatório de março': executar pipeline com dados de março = mesmo resultado. (3) formato — conforme exigência do regulador. Se XBRL: gerar em XBRL. Se PDF: gerar PDF formatado com dados da semantic layer. Se API: integrar com API do regulador. (4) review — mesmo com geração automática: compliance officer revisa antes de envio. Checklist: dados completos? Métricas corretas? Período correto? Formatação conforme? (5) calendar — mapa de deadlines de reporting: FIDC mensal (dia 10 do mês seguinte), registradora per-operation (D+0), COAF quando aplicável, Bacen trimestral (se SCD). Alertas automáticos: 5 dias antes de deadline. (6) archive — reports enviados arquivados com: data de geração, data de envio, versão dos dados, e confirmação de recebimento. Rastreável. (7) reporting como product feature — para FIDC: relatório acessível no portal, gerado automaticamente, exportável. Não precisa esperar Mesh enviar — está disponível real-time. Trust signal: 'seus dados estão sempre disponíveis, sempre atualizados.' Anti-pattern: relatório compilado manualmente em Excel com dados de 3 fontes diferentes — inconsistência, erro, e não-reproduzível."
		dependsOn: ["rc-compliance-by-design", "rc-regulatory-landscape"]
		crossDependsOn: [{
			lensId:    "lens-data-modeling-for-analytical-power"
			conceptId: "dm-semantic-layer"
			context:   "DM semantic layer define métricas como código para consistência. RC regulatory reporting consome: 'inadimplência_90d' é definida uma vez na semantic layer e usada em report FIDC, dashboard de construtora, e report para Bacen. RC é o requisito (report consistente); DM é a implementação (single source of truth). Sem semantic layer: cada report calcula inadimplência diferentemente → regulador encontra inconsistência."
		}]
		rationale: "Automated regulatory reporting 2022+. RegTech for reporting XBRL 2023+. Reporting as trust signal 2023+. Na Mesh, report regulatório gerado da mesma semantic layer que dashboard de FIDC é compliance by design — não é trabalho extra, é subproduto da infraestrutura de dados."
	},
	{
		id:         "rc-lgpd-data-governance"
		name:       "Governança de Dados LGPD: Proteção como Feature, Não como Restrição"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "semi-annual"
		definition: "LGPD (Lei 13.709/2018): princípios de finalidade (tratar para fim específico), necessidade (mínimo necessário), transparência (informar como trata), segurança (proteger contra acesso não-autorizado), e responsabilização (demonstrar compliance). Conceito de 'data governance as product feature' (2023+): em vez de LGPD como restrição ('não podemos fazer X'), LGPD como feature ('seus dados são protegidos: veja como'). Transparência de dados constrói trust. Portabilidade habilita switching sem lock-in forçado. Consentimento claro demonstra respeito. Conceito contemporâneo de 'Privacy-Enhancing Technologies' (PETs, NIST 2023+): técnicas que permitem processar dados mantendo privacidade — differential privacy, federated learning, homomorphic encryption, secure multi-party computation. Na Mesh: PETs potencialmente úteis para analytics agregadas sem expor dados individuais (benchmark de mercado anonimizado)."
		meshManifestation: "Na Mesh, LGPD aplicada: (1) base legal — para cada tipo de dado e tratamento: documentar base legal. Dados de operação: execução de contrato (Art. 7, V). Scoring: legítimo interesse (Art. 7, IX) + RIPD. Dados de compliance (CNDs): obrigação legal (Art. 7, II). Marketing: consentimento (Art. 7, I). (2) direitos do titular — portabilidade (Art. 18, V): API de export para participante baixar seus dados. Correção (Art. 18, III): mecanismo para corrigir dados incorretos. Eliminação (Art. 18, VI): procedimento de exclusão (com exceções legais — dados de operações financeiras retidos por obrigação legal). Explicação (Art. 20): explicação de decisão automatizada (ml-explainability). (3) minimização — coletar apenas dados necessários para operação e compliance. Não 'coletar tudo e filtrar depois.' Para cada campo: rationale de por que é coletado (dq-data-accumulation-strategy documenta). (4) segurança — classificação de dados por sensibilidade (sti-data-classification): confidencial-regulatório (dados financeiros, sigilo bancário), confidencial-comercial (taxa, volume), interno, público. Access control proporcional à classificação. (5) incidentes — notificação à ANPD em prazo razoável (LGPD Art. 48). Notificação a titulares afetados. Post-incident report (tc-trust-recovery). (6) DPO — Data Protection Officer designado. No cold start: pode ser founder ou assessor externo. Com tração: dedicado."
		meshImplication: "LGPD como infraestrutura: (1) inventário de tratamentos — tabela no mesh-spec: [dado] × [finalidade] × [base legal] × [período de retenção] × [compartilhamento com terceiros] × [medidas de segurança]. Revisado semestralmente. (2) consentimento tracking — para tratamentos que requerem consentimento: registro de: quem consentiu, quando, para quê, e se revogou. Consultável por API (participante pode verificar seus consentimentos). (3) portabilidade implementada — API endpoint: GET /me/data-export. Retorna: dados pessoais, operações, documentos, scores (resultado, não modelo). Formato: JSON ou CSV. SLO: <24h para gerar export. Feature comunicada: 'seus dados são seus — exporte a qualquer momento.' (4) privacy policy clara — linguagem acessível (não jurídica). O que coletamos, por que, com quem compartilhamos, por quanto tempo, e como protegemos. Acessível: footer do site + onboarding + portal do participante. (5) RIPD para scoring — scoring usa dados pessoais para decisão automatizada de crédito. RIPD obrigatório: descrever: dados utilizados, lógica do modelo (sem revelar IP), medidas de mitigação de risco (fairness, explicabilidade), e direito a revisão. Revisado quando modelo muda. (6) PETs para analytics — se Mesh publica benchmark de mercado: differential privacy para garantir que dados agregados não permitem identificar participante individual. Threshold: k-anonymity (mínimo k=10 participantes por grupo agregado). Anti-pattern: privacy policy de 50 páginas que ninguém lê — compliance formal sem transparência real. Preferir: 1 página com linguagem clara + detalhes disponíveis on-demand."
		dependsOn: ["rc-compliance-by-design", "rc-regulatory-landscape"]
		crossDependsOn: [{
			lensId:    "lens-security-trust-infrastructure"
			conceptId: "sti-data-protection-by-design"
			context:   "STI implementa proteção técnica de dados (encryption, access control, backup). RC LGPD governance implementa proteção jurídica e processual (base legal, consentimento, portabilidade, RIPD). STI é o como proteger tecnicamente; RC é o como proteger legalmente e demonstrar compliance. Ambos necessários: STI sem RC = protegido mas não-documentado. RC sem STI = documentado mas não-protegido."
		}]
		rationale: "LGPD 2018. Data governance as feature 2023+. PETs NIST 2023+. Na Mesh, LGPD implementada como feature (portabilidade, transparência, explicabilidade) constrói trust e differentiator — 'seus dados são seus e estão protegidos' é value proposition, não legalese."
	},
	{
		id:         "rc-regulatory-flexibility"
		name:       "Flexibilidade Regulatória: Projetar para Regulação que Ainda Não Existe"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Regulação muda — nova lei, novo normativo, nova interpretação. Sistema rígido requer refactoring caro. Sistema flexível acomoda mudança com configuração. Conceito de 'regulatory-ready architecture' (2023+): projetar com buffers e extensibility points que acomodam regulação futura sem reescrita. Analogia com software: open-closed principle (aberto para extensão, fechado para modificação) aplicado a compliance. Conceito contemporâneo de 'regulatory sandbox participation' (Bacen sandbox 2020+, CVM sandbox 2023+): sandboxes regulatórios permitem testar modelos de negócio inovadores com regulação flexibilizada temporariamente. Participar: demonstra engajamento com regulador + permite operar com compliance adaptada enquanto regulação final é definida."
		meshManifestation: "Na Mesh, flexibilidade para regulação projetada: (1) Marco Legal da IA (PL 2.338/2023) — se aprovado: pode exigir explicabilidade obrigatória, auditoria de fairness, e classificação de risco de sistemas de IA. Mesh já implementa: explicabilidade (ml-explainability), fairness (ml-fairness-bias), audit trail (rc-audit-trail-architecture). Compliance com Marco da IA: incremental, não transformacional. (2) Open finance — se regulação exige compartilhamento de dados financeiros via API padrão: Mesh já tem API (api-design-as-product). Adaptar para formato open finance: implementar novo endpoint com formato regulatório sobre dados existentes. (3) mudança de registradora — se nova registradora entra ou formato de registro muda: integração com registradora é adapter (abstração — trocar registradora = trocar adapter, não reescrever pipeline). (4) mudança de threshold regulatório — se Bacen exige score mínimo 70 (em vez de 60): configuração no mesh-spec. Não hardcoded no código. Mudança: PR que altera config, testada, deployada. <1 dia. (5) novo normativo de FIDC — se CVM exige novo campo em relatório: adicionar campo na semantic layer, atualizar pipeline de reporting. Incremental."
		meshImplication: "Projetar para mudança: (1) compliance rules como configuração — thresholds, documentos obrigatórios, campos de reporting: config no mesh-spec, não hardcoded. Mudança de regulação = mudança de config (PR, review, deploy). Não mudança de código. (2) adapter pattern para integrações regulatórias — registradora, bureau, Bacen: cada integração atrás de interface abstrata. Mudar provider = mudar adapter. Interface permanece. (3) extensibility em schemas — schemas de eventos e APIs com campos opcionais e extensíveis. Novo campo regulatório: adicionar como optional (backward compatible), depois tornar required após transition period (eda-schema-evolution). (4) regulatory buffer no design — se regulação exige X campos em report: implementar X+2 campos (os obrigatórios + 2 que são provavelmente próximos). Custo marginal baixo. Benefício: quando regulação adiciona 1 campo: já está implementado. (5) sandbox regulatório — se Bacen ou CVM oferecer sandbox: participar. Benefícios: operar com regulação flexibilizada, demonstrar modelo para regulador, influenciar regulação final, e primeiro-mover advantage quando regulação final é publicada. (6) legal watching — assessoria jurídica com monitoramento de: consultas públicas, projetos de lei, normativos em discussão. Input semestral para horizon scanning (rc-regulatory-landscape). Anti-pattern: implementar compliance com hardcoded values — quando regulação muda: refactoring de 3 semanas em vez de config change de 1 hora."
		dependsOn: ["rc-compliance-by-design", "rc-regulatory-landscape"]
		crossDependsOn: [{
			lensId:    "lens-real-options"
			conceptId: "ro-experimentation-as-option"
			context:   "RO preserva opcionalidade — investir para ter a opção de agir quando informação chegar. RC regulatory flexibility é opcionalidade aplicada: projetar sistema que pode acomodar regulação futura sem reescrita. RO diz 'preservar opção'; RC diz 'config-based compliance preserva opção de adaptar quando regulação mudar'. Custo: marginal (config vs hardcode). Benefício: adaptação em horas vs semanas."
		}]
		rationale: "Regulatory-ready architecture 2023+. Regulatory sandbox Bacen 2020+. Na Mesh, regulação financeira muda regularmente — sistema projetado para flexibilidade acomoda mudança com config change em vez de refactoring. Custo de flexibilidade: marginal. Custo de rigidez: transformacional quando regulação muda."
	},
	{
		id:         "rc-compliance-cost-optimization"
		name:       "Otimização de Custo de Compliance: Cumprir Sem Quebrar"
		nature:     "operational"
		role:       "heuristic"
		reviewCadence: "quarterly"
		definition: "Compliance tem custo — tecnologia, processos, pessoas, assessoria jurídica. Para startup: compliance pode consumir % significativo de resources. Conceito de 'compliance proportionality' (2022+): investimento em compliance proporcional ao risco e ao estágio. Startup pré-revenue não precisa de compliance officer full-time — precisa de assessoria pontual e sistema by design. Conceito contemporâneo de 'compliance automation ROI' (2023+): automação de compliance tem ROI mensurável — custo de automação vs custo de compliance manual × frequency. KYC automatizado: R$5/verificação vs R$50 manual. × 200 verificações/mês = R$9k/mês de saving. ROI > 10x no primeiro ano. Conceito de 'compliance tech stack' (2024+): ferramentas especializadas para compliance — KYC (Serpro, BigData Corp), PLD/FT monitoring (Neoway, Refinitiv), document verification (LLM-based), regulatory reporting (custom + semantic layer). Escolher: build vs buy proporcional ao volume."
		meshManifestation: "Na Mesh, custo de compliance por estágio: (1) pré-revenue — assessoria jurídica pontual (R$5-10k para setup: estruturação FIDC, contrato de cessão, privacy policy). Compliance by design (custo embutido no desenvolvimento). KYC: API de consulta (R$1-2/consulta, baixo volume). Total: R$10-15k inicial + R$1-2k/mês. (2) tração — assessoria recorrente (R$3-5k/mês). KYC automatizado (R$1-5k/mês). Document validation LLM (custo de inference — ml-cost-optimization). Registradora (custo por registro). Compliance monitoring (custo de infra). Total: R$10-20k/mês. (3) escala — compliance officer (R$15-25k/mês). Assessoria especializada. Ferramentas de PLD/FT (R$5-10k/mês). Auditoria externa (R$20-50k/ano). Total: R$40-80k/mês."
		meshImplication: "Compliance proporcional: (1) pré-revenue: by design + assessoria pontual. Não contratar compliance officer. Não comprar ferramenta de PLD/FT de R$10k/mês para 10 operações. O que fazer: privacy policy, contrato de cessão, base legal documentada, event sourcing implementado, LGPD inventário básico. (2) tração: automação de KYC/KYB. Document validation por LLM. Registro automático em registradora. Assessoria recorrente. O que não fazer: auditoria Big4 de R$200k para startup com 200 operações. (3) escala: compliance officer + ferramentas especializadas + auditoria externa. Proporcional ao volume e risco. (4) build vs buy: KYC: buy (APIs de consulta são commodity). Document validation: build (LLM-based, custom para tipos de documentos da construção civil). Reporting: build (semantic layer + custom pipeline — mais flexível que tool genérica). PLD/FT monitoring: buy quando volume justificar. (5) métricas de compliance cost: compliance cost per operation (total compliance cost / operations). Target: <R$20/operação (vs factoring manual: >R$100/operação). Compliance cost as % of revenue. Target: <10% (pré-revenue: higher ok). (6) compliance as competitive advantage metric: se compliance automatizada custa R$5/operação vs manual R$50: 10x advantage. Comunicar: 'compliance é 10x mais eficiente — operações mais rápidas e mais baratas.' Anti-pattern: não investir em compliance porque 'somos pequenos' — multa ou proibição de operar é existencial. Compliance proporcional ≠ compliance zero."
		dependsOn: ["rc-automated-compliance", "rc-regulatory-landscape"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-satisficing"
			context:   "ORA define satisficing — suficiente supera ótimo quando custo excede ganho. RC compliance cost usa satisficing: compliance assessoria pontual é satisficing para pré-revenue (não precisa de compliance officer full-time). Assessoria recorrente é satisficing para tração (não precisa de Big4). Cada estágio com compliance proporcional. ORA diz 'não otimizar quando suficiente basta'; RC diz 'assessoria pontual + by design é suficiente para pré-revenue'."
		}]
		rationale: "Compliance proportionality 2022+. Compliance automation ROI 2023+. Compliance tech stack 2024+. Na Mesh, compliance automatizada (agentes como RegTech) é o que permite cumprir regulação com custo 10x menor que manual — e com cobertura contínua em vez de periódica."
	},
	{
		id:            "rc-compliance-review"
		name:          "Revisão de Compliance: Inventário Periódico de Obrigações, Status e Gaps"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) landscape — mapa regulatório atualizado? Novas regulações? Mudanças? (2) automated compliance — KYC/KYB cobrindo 100% dos participantes? Documentação validada? Registro de cessões completo? PLD/FT monitoring ativo? (3) audit trail — reconstituição testada? Eventos completos? AI decisions logged? (4) reporting — reports gerados no prazo? Métricas consistentes? Regulador satisfeito? (5) LGPD — inventário de tratamentos atualizado? Direitos exercidos? Incidentes? RIPD atualizado? (6) flexibility — regulação projetada que impacta? Config-based rules atualizadas? (7) cost — compliance cost per operation? Trend? Proporcionado ao estágio?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (reporting deadlines, compliance alerts, KYC status). Trimestral: revisão completa."
		meshImplication: "Mensal (30min): reporting deadlines — próximos relatórios e status de preparação. KYC/KYB — % de participantes com KYC válido. Algum expirado? Compliance alerts — PLD/FT flags no período? Resolvidos? Documentação — fornecedores com documentos vencidos? Alerta enviado? Trimestral (2h): mapa regulatório — regulações novas ou em consulta que afetam Mesh? Horizon scanning. Audit trail — reconstituir 3 operações aleatórias via replay. Completo? Consistente? AI decision audit: selecionar 5 decisões de scoring, verificar que log inclui features, model version, SHAP. LGPD — inventário de tratamentos revisado? Algum tratamento sem base legal documentada? Direitos exercidos por participantes? Portabilidade funcional? Automated compliance — KYC automation rate (90%+?). Document validation accuracy (auditoria de amostra). Registro de cessões (100% registrado?). Flexibility — rules de compliance são config-based? Algum hardcoded que deveria ser config? Cost — compliance cost per operation. Trend. Proporcionado? Se revisão não identifica pelo menos uma ação: ou compliance é perfeita (improvável) ou revisão é superficial."
		dependsOn: ["rc-compliance-by-design", "rc-regulatory-landscape", "rc-automated-compliance", "rc-audit-trail-architecture", "rc-regulatory-reporting", "rc-lgpd-data-governance", "rc-regulatory-flexibility", "rc-compliance-cost-optimization"]
		rationale: "Regulação muda, sistemas evoluem, gaps aparecem. Sem revisão periódica: compliance que era adequada degrada — nova regulação não mapeada, audit trail incompleto, LGPD desatualizada. Revisão trimestral mantém compliance viva."
	},
]

reasoningProtocol: [
	{
		question:  "O sistema é compliant by design? Audit trail, reporting e controles são nativos da arquitetura ou adicionados depois?"
		reveals:   "Se compliance é propriedade do sistema — ou se é verificação manual que pode estar incompleta."
		rationale: "Cavoukian 2009: by design. Na Mesh, event sourcing como audit trail é by design. Log separado é retrofit."
	},
	{
		question:  "Mapa regulatório está atualizado? Cada regulação tem tradução em requisito técnico e implementação documentada?"
		reveals:   "Se todas as obrigações são conhecidas e implementadas — ou se alguma regulação foi ignorada por desconhecimento."
		rationale: "Regulatory mapping 2022+. Regulação ignorada descoberta pelo regulador = multa + trust damage."
	},
	{
		question:  "Compliance é automatizada por agentes? KYC, documentação, registro, monitoramento PLD/FT operam continuamente?"
		reveals:   "Se compliance é contínua e escalável — ou se depende de verificação manual periódica."
		rationale: "RegTech Arner et al. 2017. Continuous compliance 2023+. Manual = caro, periódico, incompleto. Automatizado = barato, contínuo, auditável."
	},
	{
		question:  "Audit trail permite reconstituir qualquer operação e decisão de qualquer momento? Com inputs, modelo, e rationale?"
		reveals:   "Se regulador pode inspecionar e receber resposta completa — ou se reconstituição é parcial ou impossível."
		rationale: "AI decision audit EU AI Act 2024. Na Mesh, 'reconstrua operação X' é pergunta inevitável — event sourcing + AI decision logging responde por design."
	},
	{
		question:  "Reports regulatórios são gerados da mesma source of truth que dashboards internos? Consistentes e reproduzíveis?"
		reveals:   "Se reporting é confiável — ou se regulador pode encontrar número diferente do que FIDC vê."
		rationale: "Automated reporting 2022+. Inconsistência entre reports para audiências diferentes = red flag para regulador."
	},
	{
		question:  "LGPD está implementada como feature? Portabilidade, explicabilidade, transparência são acessíveis pelo participante?"
		reveals:   "Se proteção de dados é experienciada como valor — ou se é documento jurídico que ninguém lê."
		rationale: "Data governance as feature 2023+. Na Mesh, portabilidade via API e explicação de scoring são features que constroem trust."
	},
	{
		question:  "Sistema é flexível para mudança regulatória? Rules são config-based? Integrações são abstraídas por adapters?"
		reveals:   "Se regulação nova requer config change (horas) ou refactoring (semanas)."
		rationale: "Regulatory-ready architecture 2023+. Na Mesh, threshold de scoring como config: mudança em horas. Hardcoded: semanas."
	},
	{
		question:  "Custo de compliance é proporcional ao estágio? Automação gera ROI vs compliance manual?"
		reveals:   "Se compliance é sustentável — ou se consome % desproporcional de resources sem necessidade."
		rationale: "Compliance proportionality 2022+. KYC automatizado: 10x mais barato. Compliance officer full-time pré-revenue: desproporcional."
	},
]

meshExamples: [
	{
		id:       "ex-compliance-by-design-cessao"
		scenario: "Mesh precisa projetar workflow de antecipação que garante compliance com regulação de cessão de recebíveis — registro obrigatório, documentação completa, e auditabilidade."
		analysis: "Regulação exige: (1) cessão registrada em registradora autorizada (CIP, CERC, TAG) para eficácia contra terceiros. (2) documentação do cedente (fornecedor) e sacado (comprador) completa. (3) auditabilidade — reconstituir qualquer operação com todos os dados do momento. Se workflow não inclui registro como gate: operação pode ser ineficaz (outro credor registra primeiro). Se documentação incompleta: cessão questionável juridicamente. Se audit trail incompleto: regulador não pode verificar."
		recommendation: "Workflow com compliance by design: (1) step 1 — fornecedor submete operação. Documentos obrigatórios verificados pelo agente: nota fiscal (ou duplicata), contrato (se aplicável), documentos do fornecedor (CND, contrato social). Se qualquer documento missing ou inválido: operação bloqueada com feedback imediato ('documento X pendente — envie para continuar'). Gate: documentação 100% validada. (2) step 2 — scoring e decisão. Score calculado com features, SHAP values, e model_version logados no event store (rc-audit-trail-architecture). Threshold aplicado conforme config no mesh-spec. Gate: score ≥ threshold (ou escalação para humano). (3) step 3 — registro em registradora. Após aprovação: integração automática com registradora (CIP/CERC/TAG). Dados enviados: cedente, cessionário (FIDC), sacado, valor, vencimento, chave do título. Confirmação de registro recebida. Gate: registro confirmado antes de liquidação. Se registro falha (registradora indisponível): retry automático. Se falha persistente: escalar + não liquidar (operação sem registro não é eficaz). (4) step 4 — liquidação. Apenas após registro confirmado: instrução de liquidação enviada. (5) step 5 — event sourcing registra tudo: OperationSubmitted, DocumentsValidated, ScoreCalculated, OperationApproved, RegistrationRequested, RegistrationConfirmed, SettlementInitiated, SettlementConfirmed. Cada evento com timestamp, actor, dados. Reconstituição: replay até qualquer ponto. Compliance by design: registro como gate no workflow (não como verificação posterior). Documentação como gate (não como 'verificar depois'). Audit trail como arquitetura (event sourcing)."
		principlesApplied: ["ax-03", "ax-05", "ax-07", "dp-01"]
		assumptions: [
			"registradora aceita integração via API — verificar disponibilidade de API de cada registradora",
			"registro em D+0 é factível — pode haver janela de processamento da registradora",
			"todos os documentos obrigatórios são verificáveis automaticamente — documentos não-padronizados podem requerer humano",
			"retry automático para registro resolve falhas transitórias — falha persistente pode requerer intervenção manual",
		]
		rationale: "Compliance by design: cada obrigação é gate no workflow, não verificação posterior. Registro como gate: operação sem registro não liquida. Documentação como gate: operação sem docs não é scored. Na Mesh, compliance não atrasa — compliance gates são <1 minuto (automação). O que atrasaria é compliance manual que leva dias."
	},
	{
		id:       "ex-lgpd-portabilidade"
		scenario: "Fornecedor solicita portabilidade de dados conforme LGPD Art. 18, V — quer exportar todos os seus dados da Mesh para outra plataforma."
		analysis: "LGPD exige: fornecer dados pessoais ao titular em formato estruturado, interoperável. Desafio: quais dados? Em que formato? Quanto tempo para gerar? O que não incluir (dados de terceiros, modelo de scoring IP)? Oportunidade: portabilidade bem-implementada é trust signal ('seus dados são seus — leve quando quiser')."
		recommendation: "(1) Escopo de dados exportados: (a) dados pessoais do fornecedor: CNPJ, nome, contato, endereço, documentos uploadados. (b) operações: todas as operações submetidas com: status, valor, taxa, datas, comprador (apenas identificação que o fornecedor já sabe). (c) qualificação: status de qualificação com cada construtora, documentos validados. (d) score: resultado de scoring (aprovado/rejeitado) com fatores explicativos. Não incluir: score numérico exato (IP do modelo), features de outros participantes, dados de comprador que não são do fornecedor, dados internos de governance. (2) formato: JSON (estruturado, interoperável) + CSV para dados tabulares (operações). Zipado. (3) API endpoint: GET /me/data-export. Response: link temporário (24h) para download do arquivo. SLO: geração em <24h. (4) interface: no portal do fornecedor: botão 'Exportar meus dados.' Sem burocracia. Sem contato com suporte. Self-service. (5) comunicação: na privacy policy e no onboarding: 'seus dados são seus. Exporte a qualquer momento em [Portal > Meus Dados > Exportar].' Trust signal. (6) o que manter após export: dados de operações financeiras são retidos por obrigação legal (sigilo bancário, regulação de FIDC). Informar: 'dados exportados. Alguns dados são retidos por obrigação legal — veja detalhes em [link].' Não deletar tudo automaticamente (portabilidade ≠ eliminação). (7) log: ExportRequested como evento no audit trail. Timestamp, dados exportados, formato. Rastreável."
		principlesApplied: ["ax-01", "ax-06", "dp-01"]
		assumptions: [
			"JSON + CSV é formato adequado para interoperabilidade — regulação pode exigir formato específico no futuro",
			"<24h de SLO é aceitável — LGPD não especifica prazo exato mas 'prazo razoável'",
			"fornecedor entende diferença entre portabilidade e eliminação — comunicar claramente",
			"self-service é preferível a processo manual — se volume de requests é alto: automação é necessária",
		]
		rationale: "LGPD Art. 18, V: portabilidade. Data governance as feature 2023+. Na Mesh, portabilidade implementada como botão self-service é trust signal: 'não estamos prendendo seus dados — estão aqui porque é bom para você, não porque você não pode sair.' Value lock-in, não data lock-in (dq-data-ethics-and-boundaries)."
	},
	{
		id:       "ex-horizon-scanning-marco-ia"
		scenario: "PL 2.338/2023 (Marco Legal da IA) avança no Congresso. Assessoria jurídica alerta: se aprovado, pode exigir classificação de risco de sistemas de IA, auditoria de fairness, e explicabilidade obrigatória para decisões automatizadas de crédito."
		analysis: "Impact assessment: (1) classificação de risco — scoring de crédito seria provavelmente 'alto risco'. Requisitos: registro, governance, transparência, supervisão humana. (2) auditoria de fairness — verificar que scoring não discrimina. Mesh já implementa ml-fairness-bias (sliced metrics, proxy detection, counterfactual tests). Gap: auditoria formal periódica com relatório documentado (não apenas métricas internas). (3) explicabilidade — LGPD Art. 20 já exige. Marco Legal pode especificar padrão mínimo de explicação. Mesh já implementa ml-explainability (SHAP, contrastive). Gap: formato de explicação pode ser regulamentado. (4) supervisão humana — Mesh já implementa HITL (aag-hitl-calibration). Gap: regulação pode exigir HITL para toda decisão de crédito (não apenas >threshold)."
		recommendation: "(1) Gap analysis: tabela [requisito projetado] × [implementação atual] × [gap] × [ação]. (a) Classificação de risco: implementação atual = nenhuma formal. Gap: registrar scoring como 'alto risco.' Ação: criar registro no mesh-spec com: sistema, finalidade, riscos, medidas de mitigação. Custo: baixo (documentação). (b) Auditoria de fairness: implementação atual = sliced metrics internas. Gap: auditoria formal com relatório. Ação: formalizar auditoria trimestral com relatório documentado (ml-fairness-bias review + ADR). Custo: baixo (formalizar o que já fazemos). (c) Explicabilidade: implementação atual = SHAP + contrastive. Gap: formato regulamentado (pode divergir do atual). Ação: projetar explicabilidade como output formatável — mesmo SHAP values, formatado diferentemente por audiência. Se regulação exige formato X: adapter que traduz SHAP para formato X. Custo: marginal. (d) Supervisão humana: implementação atual = HITL >threshold. Gap: pode exigir HITL para toda decisão. Ação: projetar como config — se regulação muda: config de 'HITL when score <65' para 'HITL always.' Impacto: operação mais lenta se HITL obrigatório (delay de human review). Preparar: processo de review rápido (<1h SLO). (2) Proactive compliance: não esperar aprovação para agir. Implementar gaps de baixo custo agora (registro, formalização de fairness audit). Gaps de custo médio (formato de explicabilidade adaptável): implementar como option (pronto para ativar). (3) Comunicar para investidor e FIDC: 'Marco Legal da IA em tramitação. Gap analysis realizado. 80% já compliance. 20% restante: ações planejadas com custo marginal.' Demonstra maturidade regulatória. (4) Participar de consulta pública: se houver — input da perspectiva de fintech AI-native. Influenciar regulação para ser viável para inovação sem comprometer proteção."
		principlesApplied: ["ax-05", "ax-07", "dp-01"]
		assumptions: [
			"PL 2.338/2023 será aprovado em formato similar ao atual — pode mudar significativamente durante tramitação",
			"scoring de crédito será classificado como alto risco — depende da definição final de categorias",
			"gap analysis cobre requisitos projetados — requisitos finais podem diferir",
			"custo marginal é estimativa — formalizar fairness audit pode requerer assessoria adicional",
		]
		rationale: "Horizon scanning 2023+. Regulatory-ready architecture 2023+. Na Mesh, proactive compliance com Marco da IA demonstra: (1) para regulador — seriedade e engagement. (2) para investidor — maturidade regulatória. (3) para FIDC — risco regulatório gerenciado. O custo de preparar é marginal vs o custo de ser surpreendido."
	},
	{
		id:       "ex-compliance-cost-kycautomation"
		scenario: "Mesh tem 200 fornecedores ativos. KYC manual (consulta ao Serpro + verificação de sócios + check de PEP) leva 30 min/fornecedor e custa ~R$50 (tempo + consultas). Founder faz pessoalmente. 200 × R$50 = R$10k/mês em KYC. Founder gasta 100h/mês em KYC — 60% do seu tempo."
		analysis: "KYC manual consome 60% do founder time — constraint máxima (ora-throughput-constraint). A R$50/fornecedor e 200 fornecedores: R$10k/mês. Se rede cresce para 500: R$25k/mês e 250h/mês de founder time (impossível). KYC automatizado: API do Serpro (R$2/consulta) + API de PEP (R$3/consulta) + agente que processa resultado = ~R$5/fornecedor. Para 200: R$1k/mês. Saving: R$9k/mês + 95h/mês de founder time liberado."
		recommendation: "(1) Implementar KYC automatizado: (a) pipeline: trigger = novo fornecedor ou re-verificação (trimestral). (b) step 1: consulta CNPJ via API Serpro/Receita — ativo, situação cadastral, data de abertura, sócios. (c) step 2: consulta PEP para cada sócio — lista oficial. (d) step 3: consulta de protestos/processos — Serasa/BigData Corp API. (e) step 4: agente analisa resultados — approved (tudo ok), review (sócio PEP, CNPJ <6 meses, inconsistência), rejected (CNPJ inapto, sócio em lista restritiva). (f) approved: KYCCompleted logado no event store. Review: escalado para founder com dados compilados (founder gasta 5min vs 30min). Rejected: KYCRejected com motivo. (2) ROI: custo de implementação (APIs + agente): ~20h de dev + R$200/mês de APIs. Saving: R$9k/mês + 95h/mês de founder time. ROI: payback em <1 semana. (3) Re-verificação automática: trimestral, trigger automático. Se algo mudou (CNPJ tornou-se inapto, novo protesto): alerta. Continuous compliance, não verificação única. (4) Métricas: KYC automation rate (% processado sem humano). Target: >90%. Time per KYC: <2 min (automático) vs 30 min (manual). Cost per KYC: <R$5 vs R$50. (5) Founder time liberated: 95h/mês → investir em anchor tenants, produto, strategy. Compliance automatizada é o que libera o constraint mais valioso. Anti-pattern: founder fazendo KYC manual com 500 fornecedores — compliance consome 100% do tempo e negócio para."
		principlesApplied: ["ax-01", "ax-03", "dp-01"]
		assumptions: [
			"APIs de Serpro/Receita são confiáveis e acessíveis — verificar disponibilidade e SLA",
			"consulta de PEP cobre lista atualizada — verificar frequência de atualização da fonte",
			"agente pode analisar resultados de API com accuracy >95% — verificar com dados reais",
			"R$5/fornecedor é custo sustentável — escala bem (500 fornecedores = R$2.5k/mês)",
		]
		rationale: "Compliance automation ROI 2023+. ORA throughput-constraint. Na Mesh, KYC automatizado não é luxo — é necessidade existencial quando founder time é o constraint. R$9k/mês de saving + 95h/mês liberadas — o investimento mais consequente que o founder pode fazer."
	},
]

principleIds: ["ax-01", "ax-03", "ax-05", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-security-trust-infrastructure"
		relation: "complementsWith"
		context:  "STI implementa proteção técnica (encryption, access control, backup). RC implementa compliance jurídica e processual (LGPD, regulação financeira, audit trail). STI é o como proteger; RC é o quê cumprir e como demonstrar. Ambos necessários: STI sem RC = protegido mas não-documentado para regulador. RC sem STI = documentado mas não-protegido tecnicamente."
	},
	{
		lensId:   "lens-event-driven-architecture-patterns"
		relation: "complementsWith"
		context:  "EDA define event sourcing como pattern. RC usa event sourcing como audit trail regulatório. EDA é a arquitetura; RC é o requisito regulatório que event sourcing satisfaz nativamente. EDA diz 'eventos imutáveis'; RC diz 'imutabilidade satisfaz requisito de tamper-evidence para regulador'."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governa agentes (autonomia, escalation, audit). RC aplica governance para compliance: agentes de KYC, document validation, PLD/FT monitoring operando sob policies de compliance. AAG é governance genérica; RC é governance aplicada a compliance regulatória."
	},
	{
		lensId:   "lens-ml-ai-systems-design"
		relation: "complementsWith"
		context:  "ML implementa explicabilidade e fairness. RC define os requisitos regulatórios que explicabilidade e fairness devem satisfazer (LGPD Art. 20, EU AI Act, Marco Legal IA). ML é a implementação; RC é o requisito. ML diz 'SHAP + contrastive'; RC diz 'LGPD exige explicação em linguagem clara com recurso para revisão'."
	},
	{
		lensId:   "lens-data-modeling-for-analytical-power"
		relation: "complementsWith"
		context:  "DM semantic layer define métricas como código. RC regulatory reporting consome: mesma definição de inadimplência em report FIDC e report Bacen. DM garante consistência; RC exige consistência para regulador."
	},
	{
		lensId:   "lens-regulatory-strategy"
		relation: "complementsWith"
		context:  "RS define relação proativa com regulador. RC define o conteúdo de compliance que RS comunica. RS é a relação; RC é a substância. RS diz 'ser transparente com regulador'; RC diz 'aqui está o mapa regulatório, o audit trail, e os reports que demonstram compliance'."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA aloca constraint (founder time). RC compliance cost optimization libera constraint: KYC automatizado libera 95h/mês de founder time. ORA diz 'alocar constraint no throughput máximo'; RC diz 'automação de compliance é o investimento que mais libera constraint no early-stage'."
	},
	{
		lensId:   "lens-real-options"
		relation: "complementsWith"
		context:  "RO preserva opcionalidade. RC regulatory flexibility preserva opcionalidade para regulação futura: config-based compliance rules, adapter pattern para integrações, extensible schemas. RO é o princípio; RC é a aplicação para regulação."
	},
	{
		lensId:   "lens-trust-and-credibility-design"
		relation: "complementsWith"
		context:  "TC constrói trust. RC compliance by design é trust signal: sistema auditável, dados protegidos, reporting consistente. TC diz 'demonstrar integrity'; RC diz 'compliance by design demonstra integrity — o sistema é estruturalmente incapaz de não cumprir regulação'. Para FIDC: compliance impecável é pré-condição de trust."
	},
	{
		lensId:   "lens-data-quality-as-competitive-moat"
		relation: "complementsWith"
		context:  "DQ define ética e limites de dados. RC LGPD governance operacionaliza: base legal documentada, minimização, portabilidade, consentimento rastreado. DQ diz 'moat ético'; RC diz 'LGPD compliance implementa o framework ético como obrigação legal'."
	},
]

limitations: [
	{
		description: "Mapa regulatório assume que regulações aplicáveis são identificáveis. Na prática, interpretação de regulação é ambígua — duas assessorias podem discordar se Mesh precisa de licença SCD ou pode operar como correspondente."
		alternative: "Para ambiguidades: consultar 2+ assessorias. Documentar interpretação escolhida como ADR com rationale. Se regulador discorda: revisão com agilidade (compliance flexível). Não assumir que 1 opinião jurídica é verdade — é interpretação."
		rationale: "Regulação financeira brasileira é interpretativa. Documentar escolha + projetar flexibilidade para mudar se interpretação for questionada."
	},
	{
		description: "Compliance automatizada por LLMs (validação de documentos) tem falsos positivos e negativos — documento expirado aprovado como válido, documento válido rejeitado."
		alternative: "LLM com guardrails + auditoria periódica de amostra (ml-llm-integration-patterns). Não confiar 100% em LLM para compliance — auditoria humana de sample detecta erros. Para documentos críticos: LLM + human review."
		rationale: "LLM como RegTech é poderoso mas não infalível. Auditoria humana periódica é safety net necessária."
	},
	{
		description: "Compliance by design pode criar rigidez — gates obrigatórios no workflow (registro, documentação) adicionam latência. Se fornecedor quer antecipação em 5 minutos: gates de compliance adicionam 10-30 minutos."
		alternative: "Otimizar gates para velocidade: registro via API (<1min), validação de documentos por LLM (<30s), KYC cached (verificação trimestral, não per-operation). Compliance rápida ≠ compliance ausente. Se gate é >5min: otimizar implementação, não remover gate."
		rationale: "Compliance não é desculpa para lentidão. Na Mesh automatizada: cada gate de compliance é <1 minuto. Total de compliance no workflow: <5 minutos. Vs factoring manual: dias."
	},
	{
		description: "Framework assume que regulação é estável o suficiente para projetar. Se regulação muda drasticamente (novo marco regulatório que muda modelo de negócio inteiro): flexibilidade de config não basta."
		alternative: "Para mudanças drásticas: strategic assessment (não apenas compliance adjustment). Se regulação proíbe modelo atual: pivot, não config change. Horizon scanning detecta sinais cedo o suficiente para planejar. Participar de consultas públicas para influenciar."
		rationale: "Flexibilidade de config resolve 90% das mudanças regulatórias. Para os 10% drásticos: estratégia de negócio, não config."
	},
	{
		description: "Custo de compliance proporcional ao estágio assume que founder entende requisitos regulatórios suficientemente para estimar proporção. Se underestimate: não-compliance. Se overestimate: desperdício."
		alternative: "Assessoria jurídica pontual para calibrar: 'para nosso estágio e modelo, o que é obrigatório e o que é nice-to-have?' Assessoria de 2-4h com especialista em fintech regulada economiza semanas de over/under-compliance."
		rationale: "Founder não é advogado. Assessoria pontual calibra proporção. Investimento mínimo com retorno máximo em clareza."
	},
]

rationale: "Toda organização que opera no setor financeiro regulado precisa tratar compliance como decisão arquitetural. Na Mesh como intermediário financeiro AI-native operando cessão de recebíveis via FIDC, compliance governa viabilidade da operação. Esta lens operacionaliza: compliance by design com regulação como requisito arquitetural (Cavoukian 2009, Arner et al. 2020, RegTech 2019+, compliance as competitive advantage 2023+), mapa regulatório com horizon scanning (regulatory mapping 2022+, horizon scanning 2023+), compliance automatizada por agentes como RegTech com continuous compliance (Arner et al. 2017, continuous compliance 2023+, compliance-as-code 2022+), audit trail como propriedade arquitetural via event sourcing com AI decision logging (audit trail by architecture 2022+, AI decision audit EU AI Act 2024), reporting regulatório automatizado da semantic layer (automated reporting 2022+, RegTech for reporting XBRL 2023+, reporting as trust signal 2023+), LGPD como feature com portabilidade e PETs (LGPD 2018, data governance as feature 2023+, PETs NIST 2023+), flexibilidade regulatória com config-based rules e adapter pattern (regulatory-ready 2023+, regulatory sandbox Bacen 2020+), e otimização de custo de compliance proporcional ao estágio (compliance proportionality 2022+, compliance automation ROI 2023+, compliance tech stack 2024+). Universal, agnóstica a estágio, aplicável a qualquer organização em setor financeiro regulado."

}
