package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

dataModelingForAnalyticalPower: artifact_schemas.#AnalyticalLens & {
id:     "lens-data-modeling-for-analytical-power"
name:   "Modelagem de Dados para Poder Analítico"

purpose: "Orientar decisões sobre como modelar dados para maximizar poder analítico — dimensional modeling, aggregations, e query patterns para decisão."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como estruturar dados para habilitar analytics, reporting ou machine learning",
		"a decisão envolve escolher entre modelagem dimensional, data vault, wide tables ou outras abordagens analíticas",
		"a decisão envolve projetar feature store para alimentar modelos de scoring ou ML",
		"a decisão envolve como organizar dados de múltiplos bounded contexts para queries analíticas cross-domain",
		"a decisão envolve trade-offs entre normalização (integridade) e desnormalização (performance de query)",
		"a decisão envolve como implementar slowly changing dimensions para rastrear evolução de entidades ao longo do tempo",
		"a decisão envolve arquitetura de dados — data warehouse, data lake, data lakehouse, data mesh",
		"a decisão envolve como garantir que dados analíticos refletem a realidade operacional com latência aceitável",
		"a decisão envolve lineage — rastrear de onde vem cada dado, por quais transformações passou, e quem consome",
		"a decisão envolve como projetar schemas analíticos que evoluem sem quebrar dashboards e modelos existentes",
		"a decisão envolve como expor dados analíticos para stakeholders (construtora, FIDC, regulador) com granularidade adequada",
	]
	keywords: [
		"data model", "modelagem de dados", "schema analítico",
		"dimensional modeling", "star schema", "snowflake schema",
		"data vault", "hub", "link", "satellite",
		"feature store", "feature engineering", "feature pipeline",
		"data warehouse", "data lake", "lakehouse", "data mesh",
		"ETL", "ELT", "pipeline de dados", "transformação",
		"desnormalização", "wide table", "materialized view",
		"slowly changing dimension", "SCD", "Type 1", "Type 2",
		"lineage", "data catalog", "metadata", "data discovery",
		"fact table", "dimension table", "grain", "granularidade",
		"OLAP", "OLTP", "analytical query", "aggregação",
		"metric", "KPI", "measure", "dimension",
		"dbt", "Spark", "BigQuery", "Snowflake", "DuckDB",
	]
	excludeWhen: [
		"a decisão é sobre qualidade de dados como risco operacional — usar observability-operational-intelligence (ooi-data-quality-operational-risk)",
		"a decisão é sobre event sourcing e projeções — usar event-driven-architecture-patterns",
		"a decisão é sobre design de sistemas distribuídos (consistency, replication) — usar distributed-systems-design",
		"a decisão é sobre design de API para expor dados — usar api-design-as-product",
		"a decisão é sobre segurança e classificação de dados — usar security-trust-infrastructure",
	]
	rationale: "Toda organização data-intensive precisa de modelos de dados que transformem dados operacionais brutos em poder analítico — capacidade de responder perguntas de negócio, alimentar modelos de ML, e gerar insights para stakeholders. Na Mesh como intermediário financeiro AI-native, dados são o ativo competitivo central: cada operação gera dados que melhoram scoring, cada scoring melhora pricing, e dados agregados informam decisões de regulador, investidor e gestores FIDC. Sem modelagem analítica adequada, dados existem mas não podem ser consultados eficientemente (queries de 8s), features de scoring são recalculadas a cada request (desperdício de compute), e relatórios para FIDC requerem queries ad hoc que ninguém sabe se estão corretas. Event-driven (EDA) cobre como dados fluem como eventos; esta lens cobre como dados são estruturados para consumo analítico."
}

concepts: [
	{
		id:         "dm-dimensional-modeling"
		name:       "Modelagem Dimensional: Estruturar Dados para Perguntas de Negócio"
		nature:     "theoretical"
		role:       "framework"
		definition: "Kimball/Ross (2013, The Data Warehouse Toolkit, 3rd ed.): modelagem dimensional organiza dados em dois tipos de tabelas — fact tables (eventos mensuráveis: operação de antecipação, pagamento, scoring) e dimension tables (contexto descritivo: fornecedor, construtora, período, produto). Star schema: fact no centro, dimensions ao redor. Query: SELECT SUM(valor) FROM fact_antecipacao JOIN dim_fornecedor ON ... WHERE segmento = 'construcao' AND periodo = '2026-Q1'. Intuitivo para analistas, performante para queries agregadas. Grain: nível de detalhe de cada row na fact table — uma row por operação? Por dia? Por fornecedor-mês? Definir grain é a decisão mais importante. Inmon (2005, Building the Data Warehouse, 4th ed.): alternativa — normalizado primeiro (3NF), depois dimensional. Conceito contemporâneo de 'wide tables as analytical model' (2022+, BigQuery/Snowflake/Databricks): com columnar storage e compute elástico, wide tables desnormalizadas (100+ colunas, pré-joinadas) podem ser mais simples e igualmente performantes que star schema — eliminam complexidade de join. 'One Big Table' (OBT) pattern. Conceito de 'metrics layer / semantic layer' (dbt Metrics 2022, Cube.js, Looker Semantic Layer, AtScale): camada que define métricas como código sobre modelos dimensionais — 'receita' é definida uma vez, calculada consistentemente em todo report. Elimina 'cada dashboard calcula receita diferente'."
		meshManifestation: "Na Mesh, fatos mensuráveis: (1) fact_antecipacao — grain: uma row por operação. Medidas: valor, taxa, prazo, score_do_comprador, tempo_ate_liquidacao. Dimensões: fornecedor, construtora, período, segmento, modalidade. (2) fact_pagamento — grain: uma row por pagamento recebido. Medidas: valor_pago, dias_de_atraso, valor_em_aberto. Dimensões: comprador, operação, período. (3) fact_scoring — grain: uma row por cálculo de score. Medidas: score, confidence, features_count. Dimensões: comprador, modelo_version, período. (4) fact_qualificacao — grain: uma row por evento de qualificação. Medidas: dias_para_qualificar, documentos_pendentes. Dimensões: fornecedor, construtora, período. Dimensões compartilhadas: dim_fornecedor (CNPJ, nome, segmento, porte, data_onboarding), dim_construtora (CNPJ, nome, porte, região), dim_periodo (data, semana, mês, trimestre, ano), dim_comprador (CNPJ, score_atual, faturamento_mensal)."
		meshImplication: "Modelar dados analíticos com dimensional modeling como base: (1) definir grain de cada fact table antes de qualquer coisa — grain errado invalida toda a análise. Antecipação: grain por operação (não por dia, não por fornecedor — cada operação é fato único). (2) star schema como default — join de facts com dimensions. Para queries simples (total por segmento): performante e intuitivo. (3) wide table como alternativa para casos específicos: se 90% das queries joinam as mesmas 5 dimensions, pré-joinar em wide table. Custo: storage. Benefício: queries sem join, mais simples de entender. (4) metrics layer: definir métricas core como código (dbt metrics ou equivalente). 'Receita' = SUM(valor * taxa) para operações com status in ('settled', 'completed'). 'Inadimplência' = SUM(valor_em_aberto) / SUM(valor_total) para operações com dias_de_atraso > 90. Definir uma vez, usar em todo dashboard e report. (5) naming convention: fact_ prefix para fatos, dim_ prefix para dimensões. Nomes descritivos em snake_case. Consistência absoluta — analista/agente encontra tabela pelo nome sem documentação. Anti-pattern: modelo analítico que é cópia do modelo operacional (normalizado, 15 joins para montar um dashboard). Modelo analítico é projetado para perguntas de negócio, não para integridade transacional."
		rationale: "Kimball/Ross 2013: dimensional modeling como standard de analytics. Wide tables 2022+: alternativa com columnar storage. Metrics layer 2022+: métricas como código. Na Mesh, modelagem dimensional transforma event log bruto em dados consultáveis por stakeholders — sem essa camada, dados existem mas não respondem perguntas."
	},
	{
		id:         "dm-feature-store"
		name:       "Feature Store: Infraestrutura que Alimenta ML com Features Consistentes"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "quarterly"
		definition: "Uber Michelangelo (Hermann et al. 2017): feature store como camada centralizada que computa, armazena e serve features para modelos de ML. Resolve três problemas: (1) feature consistency — mesma feature é calculada da mesma forma em treinamento e inferência (training-serving skew). (2) feature reuse — feature calculada para scoring pode ser reutilizada para pricing sem recalcular. (3) feature freshness — features pré-computadas com freshness definida, não calculadas on-the-fly a cada request. Feast (2020+, open source): feature store com offline store (batch features para treinamento) e online store (low-latency features para inferência). Conceito contemporâneo de 'feature platforms' (Tecton 2021+, Feathr 2022+, Hopsworks 2023+): evolução do feature store — real-time feature computation (stream processing), feature monitoring (drift detection), feature lineage (de onde vem cada feature), e feature discovery (buscar features existentes antes de criar). Conceito de 'feature as product' (2023+): features documentadas, versionadas, e com SLOs (freshness, latency) — consumidores de features tratados como clientes."
		meshManifestation: "Na Mesh, features para scoring e decisão: (1) features do comprador — faturamento_mensal (fonte: dados financeiros via integração), historico_pagamentos_90d (fonte: fact_pagamento), score_externo_bureau (fonte: API de bureau), total_antecipacoes_ativas (fonte: fact_antecipacao), concentracao_por_fornecedor (fonte: fact_antecipacao agregada). (2) features do fornecedor — dias_para_qualificar (fonte: fact_qualificacao), compliance_status (fonte: evento de compliance), historico_operacoes (fonte: fact_antecipacao agregada), taxa_media_praticada (fonte: fact_antecipacao). (3) features de mercado — taxa_selic_atual (fonte: API Bacen), inadimplencia_setor (fonte: relatório ABRAMAT/CBIC). Sem feature store: cada scoring request recalcula features a partir de dados brutos — latência alta, inconsistência entre treinamento e inferência, e duplicação de lógica de cálculo."
		meshImplication: "Implementar feature store proporcional ao estágio: (1) pré-revenue: 'poor man's feature store' — materialized views em PostgreSQL. Feature calculation: query SQL que agrega dados de fact tables. Materialized view atualizada periodicamente (5min para features online, 1h para features batch). Freshness: controlada por refresh interval. Consistência: mesma view serve treinamento e inferência. (2) tração: migrar para Feast ou equivalente. Offline store (parquet/PostgreSQL) para treinamento. Online store (Redis/DynamoDB) para inferência low-latency (<10ms). Feature definitions como código (feature repo versionado). (3) escala: Tecton/Hopsworks para real-time features (stream processing), monitoring, e discovery. Para cada feature: (a) definition — como é calculada, a partir de que fonte, com que transformação. (b) freshness SLO — quão recente precisa ser? Faturamento_mensal: <24h. Score_bureau: <7d. Taxa_selic: <1d. (c) lineage — de onde vem o dado raw, quais transformações, quem consome. Se fonte raw muda formato: quais features são afetadas? (d) monitoring — drift de feature (distribuição mudou?), missing values (% de nulls), latency (tempo de cálculo). (e) ownership — quem é responsável por cada feature? Se quebrar: quem conserta? Anti-pattern: features calculadas inline no código do scoring model sem centralização — impossível reusar, impossível monitorar, impossível garantir consistência training-serving."
		dependsOn: ["dm-dimensional-modeling"]
		crossDependsOn: [
			{
				lensId:    "lens-credit-risk"
				conceptId: "cr-model-monitoring"
				context:   "CR monitora performance de modelos de scoring (AUROC, PSI). Feature store alimenta scoring com features — se feature degrada (freshness, drift), modelo degrada mesmo sem bug no modelo. CR diz 'AUROC caiu'; feature store diz 'feature faturamento_mensal está com 30% de missing values porque integração mudou'. CR é model-level; feature store é feature-level. Diagnosticar degradação de modelo frequentemente começa em diagnosticar degradação de feature."
			},
			{
				lensId:    "lens-observability-operational-intelligence"
				conceptId: "ooi-data-quality-operational-risk"
				context:   "OOI monitora data quality como risco operacional (freshness, volume, distribution). Feature store é consumidor de data quality — features são derivadas de dados operacionais. Se OOI detecta freshness violation nos dados de faturamento, feature store é diretamente afetado. OOI é upstream; feature store é downstream. Monitoramento de feature quality é extensão de data quality de OOI para a camada analítica."
			},
		]
		rationale: "Hermann/Uber 2017: feature store resolve training-serving skew. Feast 2020+: open source. Tecton/Hopsworks 2023+: feature platforms. Na Mesh, scoring é o mecanismo mais consequente (governa decisão de crédito) — features inconsistentes ou stale geram scores errados que geram perdas financeiras. Feature store é a infraestrutura que previne."
	},
	{
		id:         "dm-slowly-changing-dimensions"
		name:       "Slowly Changing Dimensions: Rastrear como Entidades Evoluem ao Longo do Tempo"
		nature:     "theoretical"
		role:       "method"
		definition: "Kimball/Ross (2013): entidades mudam ao longo do tempo — fornecedor muda de porte, construtora muda de região, comprador muda de faturamento. Slowly Changing Dimensions (SCD) são patterns para rastrear essas mudanças: (1) Type 1 — overwrite (atualizar valor sem preservar histórico). Simples mas perde história. (2) Type 2 — add row (nova row para cada versão, com effective_from e effective_to). Preserva história completa. Custo: tabela cresce, join precisa de data de vigência. (3) Type 3 — add column (previous_value e current_value). Preserva apenas 1 versão anterior. (4) Type 6 (híbrido 1+2+3) — combinação para máxima flexibilidade. Conceito contemporâneo de 'temporal tables' (SQL:2011 standard, PostgreSQL temporal tables via pg_temporal 2023+, SQL Server system-versioned tables): suporte nativo de database para tracking de mudanças com period of validity — elimina necessidade de implementação manual de SCD Type 2. 'AS OF' queries: SELECT * FROM fornecedor FOR SYSTEM_TIME AS OF '2025-06-15' — retorna estado da entidade naquela data."
		meshManifestation: "Na Mesh, entidades que mudam e cujo histórico importa: (1) fornecedor — porte muda (cresceu de micro para pequena), segmento muda (adicionou infraestrutura além de construção), compliance status muda (qualificado → suspenso → requalificado). Para relatório de FIDC: 'qual era o porte do fornecedor no momento da antecipação?' Se SCD Type 1: perdeu, responde porte atual. Se SCD Type 2: preserva, responde porte no momento. (2) comprador — faturamento muda mensalmente. Para backtesting de scoring: 'qual era o faturamento quando o score foi calculado?' Event sourcing preserva features_snapshot no evento BuyerScored — mas dim_comprador na camada analítica também precisa de histórico. (3) taxa Selic — muda periodicamente. Para análise de pricing ao longo do tempo: 'qual era a Selic quando esta operação foi precificada?' SCD Type 2 para dim_taxa_referencia."
		meshImplication: "Para cada dimension: decidir SCD type por impacto analítico: (1) SCD Type 2 para dimensões cujo histórico afeta análise financeira ou regulatória: dim_fornecedor (porte, segmento, compliance_status), dim_comprador (faturamento, score), dim_taxa_referencia (Selic, CDI). Implementar com: effective_from, effective_to, is_current flag. Join com fact table: fact.data BETWEEN dim.effective_from AND dim.effective_to. (2) SCD Type 1 para dimensões cujo histórico não afeta análise: dim_fornecedor.nome (se mudou razão social, nome antigo não é analiticamente relevante), dim_fornecedor.endereco (a menos que região seja dimensão analítica). (3) temporal tables (se PostgreSQL suportar ou via extension): preferível a SCD Type 2 manual — database gerencia versioning, queries AS OF são nativas, menos código custom. (4) para feature store: features históricas são pré-calculadas com SCD Type 2 de dimensions — feature 'faturamento_mensal_do_comprador' no momento do score é join de fact_scoring com dim_comprador usando timestamp do score. Sem SCD: feature histórica é incalculável (usa faturamento atual, não o de 6 meses atrás). Anti-pattern: SCD Type 1 para tudo ('simplifica modelo') — perde capacidade de backtesting, auditoria, e análise temporal. Na Mesh como intermediário financeiro, a pergunta 'qual era o perfil do comprador quando aprovamos esta operação?' é inevitável — Type 1 não pode responder."
		dependsOn: ["dm-dimensional-modeling"]
		crossDependsOn: [{
			lensId:    "lens-event-driven-architecture-patterns"
			conceptId: "eda-replay-temporal-queries"
			context:   "EDA replay reconstrói estado de aggregates no momento de uma decisão. SCD reconstrói estado de dimensions analíticas no momento de uma análise. São complementares: EDA replay para auditoria operacional ('reconstruir operação 12345'); SCD para análise analítica ('inadimplência por segmento com porte do fornecedor no momento da operação'). EDA é event-level; SCD é analytical-level."
		}]
		rationale: "Kimball/Ross 2013: SCD types. SQL:2011: temporal tables. pg_temporal 2023+: PostgreSQL nativo. Na Mesh, a capacidade de responder 'qual era o estado de X quando Y aconteceu' é requisito regulatório (auditoria), analítico (backtesting), e de negócio (diagnóstico de inadimplência). SCD Type 2 para dimensões financeiramente relevantes é obrigatório."
	},
	{
		id:         "dm-data-architecture-choice"
		name:       "Arquitetura de Dados: Warehouse, Lake, Lakehouse, Mesh — Cada Estágio Pede Diferente"
		nature:     "theoretical"
		role:       "framework"
		definition: "Quatro paradigmas com trade-offs: (1) Data Warehouse (Inmon 1992, Kimball 1996): dados estruturados, schema-on-write, otimizado para queries analíticas. Maduro, bem-entendido. Limitação: schema rígido, difícil ingerir dados não-estruturados. (2) Data Lake (Dixon 2010): dados raw em formato nativo (JSON, Parquet, CSV), schema-on-read. Flexível. Limitação: sem governance vira 'data swamp' — dados existem mas ninguém sabe o que é o quê. (3) Data Lakehouse (Armbrust et al. 2021, Databricks): combina flexibilidade do lake com management do warehouse — open formats (Delta Lake, Apache Iceberg, Apache Hudi) com ACID transactions, schema enforcement, e time travel sobre data lake storage. Conceito contemporâneo dominante. (4) Data Mesh (Dehghani 2022, Data Mesh — Delivering Data-Driven Value at Scale): descentralizar ownership de dados por domínio. Cada bounded context é responsável por seus 'data products' — dados analíticos com schema, SLOs, e documentação. Plataforma central oferece infraestrutura (compute, storage, governance); domínios oferecem dados. Quatro princípios: domain ownership, data as product, self-serve platform, federated computational governance."
		meshManifestation: "Na Mesh por estágio: (1) pré-revenue: PostgreSQL como warehouse. Dados operacionais e analíticos no mesmo database (schemas separados: operational, analytical). Materialized views como camada analítica. Simples, zero infra adicional. Suficiente para <10k operações. (2) tração: separar OLTP de OLAP. Read replica dedicada para queries analíticas (conecta com dsd-data-replication). dbt como transformation layer — SQL modular, testável, versionado. Parquet para dados históricos e cold storage. DuckDB para queries ad hoc locais. (3) escala: lakehouse com Apache Iceberg sobre object storage (S3). Queries analíticas via Trino/Spark. Feature store integrado. (4) data mesh: quando múltiplas equipes existirem — cada BC (ECL, Scoring, NGR) publica 'data products' com schema, SLOs, e docs. Plataforma central (infra) + domínios (dados)."
		meshImplication: "Arquitetura de dados proporcional ao estágio: (1) pré-revenue: PostgreSQL único com schemas separados. Schema 'operational' para OLTP. Schema 'analytical' com materialized views dimensionais (fact_, dim_). Refresh: pg_cron a cada 5min para views hot, 1h para views cold. dbt para definir transformações como SQL versionado + testável. Zero infra adicional. (2) tração: read replica para OLAP. dbt rodando transformações na replica. Dados históricos em Parquet (exportação diária). DuckDB para análise exploratória sobre Parquet. Feature store: materialized views → Feast com offline/online store. (3) escala: Iceberg tables sobre S3. Trino como query engine. dbt + Great Expectations para transformação + validação. Feature platform (Tecton/Hopsworks). (4) data mesh: quando equipes >3, cada BC publica data products. Catálogo central (DataHub, OpenMetadata). Governance federada com standards de schema e quality. Regra: não pular estágios. PostgreSQL com materialized views para startup com 1000 operações é o sweet spot. Iceberg + Trino para 1000 operações é over-engineering que consome constraint sem benefício."
		dependsOn: ["dm-dimensional-modeling"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-satisficing"
			context:   "ORA define satisficing — 'suficiente' supera 'ótimo' quando custo de busca excede ganho marginal. PostgreSQL como warehouse pré-revenue é satisficing: não é ótimo para analytics (não é columnar, não tem time travel nativo) mas é suficiente e tem custo marginal zero (já existe). Investir em lakehouse antes de ter dados suficientes é otimizar prematuramente. ORA diz 'satisfice para infra de dados no bootstrap'; DM implementa com PostgreSQL + materialized views."
		}]
		rationale: "Inmon 1992, Kimball 1996: warehouse. Armbrust et al. 2021: lakehouse. Dehghani 2022: data mesh. Na Mesh, a arquitetura de dados evolui com o estágio — PostgreSQL → read replica + dbt → lakehouse → data mesh. Cada salto quando evidência (volume, equipes, complexidade) justificar."
	},
	{
		id:            "dm-data-lineage"
		name:          "Data Lineage: Rastrear a Origem, Transformação e Destino de Cada Dado"
		nature:        "operational"
		role:          "property"
		reviewCadence: "quarterly"
		definition:    "DAMA-DMBOK2 (2017): data lineage é a documentação da origem, movimentação e transformação de dados ao longo do pipeline — de onde vem, por quais transformações passa, e onde é consumido. Essencial para: (1) impact analysis — se fonte muda, o que é afetado? (2) debugging — dado está errado no dashboard, onde o erro foi introduzido? (3) compliance — regulador pergunta 'de onde vem este dado?' (4) trust — analista confia no dado porque sabe a proveniência. Conceito contemporâneo de 'automated lineage' (OpenLineage 2022+, Marquez, Atlan 2023+, DataHub 2023+): ferramentas que capturam lineage automaticamente a partir de pipelines — dbt gera lineage de transformações SQL, Spark gera lineage de jobs, Airflow gera lineage de DAGs. Não requer documentação manual. Conceito de 'column-level lineage' (2023+): rastrear não apenas quais tabelas alimentam quais, mas quais colunas — coluna 'inadimplencia' no dashboard FIDC vem de coluna 'valor_em_aberto' na fact_pagamento dividida por 'valor_total' na fact_antecipacao. Se 'valor_em_aberto' muda cálculo: 'inadimplencia' é afetado."
		meshManifestation: "Na Mesh, lineage é crítico para: (1) scoring — feature 'faturamento_mensal' vem de integração com ERP da construtora → pipeline de ingestão → fact_pagamento → feature store → scoring model. Se integração muda formato: toda a cadeia é afetada. Sem lineage: não se sabe que scoring foi afetado até que score esteja errado. (2) relatório FIDC — 'inadimplência da carteira' é KPI regulatório. Vem de: fact_pagamento (pagamentos recebidos) + fact_antecipacao (operações ativas) + dim_comprador (classificação de default). Se cálculo de default muda: KPI muda. Regulador pergunta 'como calculam inadimplência?' — lineage responde completa e automaticamente. (3) data quality — OOI detecta anomalia em volume de fact_antecipacao. Lineage mostra: fact_antecipacao é alimentada por eventos do ECL via projeção. Se projeção parou: volume cai. Sem lineage: debugging manual por inspeção."
		meshImplication: "Implementar lineage proporcional ao estágio: (1) pré-revenue: dbt como transformation layer gera lineage automaticamente. Cada model (transformação SQL) documenta: source tables, transformations, output table. dbt docs gera DAG visual navegável. Lineage de dbt é table-level + column-level. Custo: zero (dbt já é usado para transformações). (2) tração: adicionar OpenLineage para capturar lineage de pipelines não-dbt (ingestão, feature store, scoring pipeline). Integrar com DataHub ou OpenMetadata como catálogo central. (3) escala: lineage end-to-end automatizado — da fonte raw (API de construtora) até o dashboard final (FIDC portfolio report). Column-level lineage para KPIs regulatórios. Para cada KPI regulatório: lineage documentado e testável — 'inadimplência é calculada como SUM(valor_em_aberto WHERE dias_atraso > 90) / SUM(valor_total)'. Se fórmula muda: lineage mostra todos os reports afetados. Impact analysis: antes de mudar schema de tabela, consultar lineage — quais transformações, features, e reports são downstream? Se 0: mudança é safe. Se 10: coordenar. Anti-pattern: pipeline de dados onde ninguém sabe como KPI X é calculado — 3 dashboards mostram 'inadimplência' com valores diferentes porque cada um calcula de forma diferente. Lineage + metrics layer (dm-dimensional-modeling) resolve."
		dependsOn: ["dm-dimensional-modeling", "dm-feature-store"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-data-quality-operational-risk"
			context:   "OOI monitora data quality com 5 dimensões (freshness, volume, distribution, schema, lineage). DM implementa lineage como infraestrutura que torna a dimensão 'lineage' de OOI operacional. OOI diz 'freshness violation em faturamento'; DM lineage diz 'faturamento alimenta feature X que alimenta scoring que alimenta dashboard Y — todos afetados'. Sem lineage: OOI detecta anomalia mas não sabe o impacto downstream."
		}]
		rationale: "DAMA-DMBOK2 2017: lineage para impact analysis e compliance. OpenLineage 2022+: automated lineage. DataHub/Atlan 2023+: catalog com lineage. Na Mesh como intermediário financeiro regulado, lineage é requisito de compliance (regulador pergunta 'de onde vem este dado?') e de operação (debugging sem lineage é adivinhação)."
	},
	{
		id:         "dm-transformation-as-code"
		name:       "Transformação como Código: Pipelines Testáveis, Versionáveis e Auditáveis"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Conceito de 'analytics engineering' (dbt Labs 2016+, Fishtown Analytics): transformações de dados devem ser código — SQL versionado em Git, testável com assertions, documentável com schema descriptions, e orquestrável por CI/CD. dbt (data build tool): standard de facto para ELT transformations. Modelos como SQL SELECT que materializam em tabelas/views. Tests: unique, not_null, accepted_values, custom SQL tests. Docs: auto-generated a partir de schema.yml. Lineage: auto-generated a partir de refs. Conceito contemporâneo de 'data contracts' (Andrew Jones 2023, Data Contracts): acordo formal entre producer e consumer de dados — schema, quality expectations, SLOs, ownership. Análogo a API contract entre serviços. Breaking change em data contract: tratada como breaking change de API (sunset protocol). Conceito de 'data testing pyramid' (2023+): unit tests (transformação correta), integration tests (dados fluem end-to-end), contract tests (producer cumpre contrato), e quality tests (dados em produção estão saudáveis — Great Expectations, Soda)."
		meshManifestation: "Na Mesh, transformações de dados: (1) ingestão — dados de integração (banco, registradora, bureau) transformados para schema interno. (2) staging — dados raw limpos e padronizados (nomes, tipos, nulls). (3) intermediate — joins e agregações intermediárias. (4) marts — modelos dimensionais finais (fact_, dim_). (5) features — feature store alimentado por marts. Cada camada é SQL em dbt. Sem dbt: transformações são scripts ad hoc que ninguém documenta, ninguém testa, e que quebram silenciosamente quando dados mudam."
		meshImplication: "dbt como transformation layer: (1) modelos por camada: staging/ (limpeza), intermediate/ (joins), marts/ (dimensionais), features/ (feature store). (2) naming convention: stg_ecl__operations (staging do ECL, operações), int_operations__with_scores (intermediate com join de scores), fct_antecipacao (fact table final), dim_fornecedor (dimension). (3) tests obrigatórios: (a) unique + not_null para primary keys de toda tabela. (b) accepted_values para enums (status, segmento). (c) referential_integrity para foreign keys (operação referencia fornecedor que existe). (d) custom: valor_antecipacao > 0, score BETWEEN 0 AND 100, effective_from < effective_to para SCD Type 2. (4) data contracts: para cada mart consumido por stakeholder externo (FIDC, regulador): schema versionado com SLOs (freshness, completeness, accuracy). Breaking change: sunset protocol (conecta com api-versioning-evolution). (5) CI: dbt run + dbt test em toda PR que modifica modelo. Se test falha: PR bloqueada. (6) docs: schema.yml com description de cada coluna. dbt docs serve documentação navegável com lineage. (7) Great Expectations ou Soda para data quality tests em produção: volume esperado, distribuição, freshness. Complementa dbt tests (que rodam em build time). Anti-pattern: transformação em Python script não-versionado executado manualmente — impossível testar, impossível auditar, impossível reproduzir."
		dependsOn: ["dm-dimensional-modeling", "dm-data-lineage"]
		crossDependsOn: [{
			lensId:    "lens-knowledge-management"
			conceptId: "km-knowledge-as-code"
			context:   "KM define knowledge as code — versionado, testável, auditável. dbt é knowledge as code para a camada de dados — transformações como SQL versionado em Git, testável por CI, auditável por diff. Lineage é gerada automaticamente. KM diz 'se não está codificado, não existe'; DM diz 'transformação que não está em dbt não é reproduzível e não é confiável'."
		}]
		rationale: "dbt Labs 2016+: analytics engineering. Andrew Jones 2023: data contracts. Data testing pyramid 2023+. Na Mesh, cada KPI que vai para regulador ou investidor deve ser reproduzível — dbt como transformation layer garante que 'inadimplência' é calculada da mesma forma por todo report, testada em CI, e auditável por diff."
	},
	{
		id:         "dm-grain-design"
		name:       "Design de Granularidade: A Decisão que Governa Toda a Análise"
		nature:     "theoretical"
		role:       "property"
		definition: "Kimball/Ross (2013): grain é o nível de detalhe de cada row na fact table — a declaração mais precisa de o que uma row representa. 'Uma row por operação de antecipação' vs 'uma row por fornecedor por mês' vs 'uma row por comprador por dia.' Grain determina: quais perguntas a tabela pode responder, quão grande a tabela fica, e quais dimensões podem ser joinadas. Regra de Kimball: 'declare the grain before adding any facts or dimensions.' Grain errado é bug arquitetural — todos os números derivados estão errados ou imprecisos. Conceito contemporâneo de 'multi-grain fact tables' (2022+): materializar a mesma informação em múltiplas granularidades — grain atômico (1 row por operação) para análise detalhada, grain agregado (1 row por segmento por mês) para dashboards executivos. O atômico é source of truth; o agregado é otimização de query."
		meshManifestation: "Na Mesh, decisões de grain: (1) fact_antecipacao — grain: 1 row por operação (atômico). Cada operação é fato único com valor, taxa, score, timestamps. Permite drill down até operação individual. (2) fact_pagamento — grain: 1 row por pagamento recebido (atômico). Cada pagamento de comprador é fato. Permite análise de inadimplência por operação. (3) fact_scoring_history — grain: 1 row por cálculo de score (atômico). Cada execução de scoring é fato. Permite backtesting. (4) agg_portfolio_monthly — grain: 1 row por comprador por mês (agregado). Pré-calcula: total_ativo, inadimplencia_acumulada, concentracao. Para dashboard FIDC sem query pesada. (5) agg_segmento_trimestral — grain: 1 row por segmento por trimestre (agregado). Para report executivo. Decisão: sempre materializar grain atômico como base. Agregar como conveniência."
		meshImplication: "Para cada fact table: (1) declarar grain em uma frase: 'uma row por [entidade] por [evento/período].' Documentar no schema.yml do dbt. (2) grain atômico como source of truth — sempre materializar. Permite qualquer agregação downstream. (3) grains agregados como otimização — materializar quando query performance exige. Cada agregado é derivado do atômico (dbt ref() chain). Se atômico e agregado divergem: bug no agregado. (4) grain determina dimensões joinable: se grain é 'por operação', pode joinar com dim_fornecedor (fornecedor da operação) e dim_comprador (comprador da operação). Se grain é 'por segmento por mês', não pode joinar com fornecedor individual — informação perdida na agregação. (5) nunca misturar grains na mesma tabela: fact_antecipacao com 1 row por operação + 1 row de total por fornecedor na mesma tabela = números inconsistentes e queries confusas. Anti-pattern: grain não-declarado — ninguém sabe se row é por operação, por dia, ou por fornecedor. Analista que soma valor() pensando que é por operação mas é por pagamento (múltiplos pagamentos por operação) produz número inflado."
		dependsOn: ["dm-dimensional-modeling"]
		rationale: "Kimball/Ross 2013: 'declare the grain before anything else.' Multi-grain 2022+: atômico + agregado. Na Mesh, grain de fact_antecipacao (por operação) vs fact_pagamento (por pagamento) — confundir os dois produz inadimplência calculada errada (divisor errado). Grain declarado e documentado previne."
	},
	{
		id:         "dm-semantic-layer"
		name:       "Semantic Layer: Métricas Definidas Uma Vez, Calculadas Consistentemente"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "quarterly"
		definition: "Conceito contemporâneo de 'metrics layer' / 'semantic layer' (dbt Semantic Layer 2022+, Cube.js 2020+, Looker Modeling Language, AtScale): camada que define métricas como código — 'receita', 'inadimplência', 'volume de operações' são definidas uma vez com fórmula, filtros, e dimensões. Qualquer ferramenta de BI, dashboard, ou query que precisa de 'receita' consome da semantic layer — não recalcula. Resolve: (1) métrica inconsistente — 3 dashboards com 'receita' diferente porque cada um filtra diferente. (2) métrica opaca — analista não sabe como 'inadimplência' é calculada. (3) métrica duplicada — mesma lógica implementada em 5 queries SQL diferentes. Benn Stancil (2022, 'The Missing Piece of the Modern Data Stack'): semantic layer é 'the last mile' — dados transformados existem, mas sem semantic layer não há garantia de que 'receita' significa a mesma coisa em todo contexto."
		meshManifestation: "Na Mesh, métricas core que devem ser consistentes: (1) volume_operacoes — COUNT de operações com status IN ('settled', 'completed') no período. Usada em: dashboard de fornecedor, dashboard de construtora, report de investidor, report de regulador. (2) receita_bruta — SUM(valor_operacao * taxa) para operações settled/completed. Usada em: P&L, investor update, unit economics. (3) inadimplencia — SUM(valor_em_aberto WHERE dias_atraso > 90) / SUM(valor_total_carteira). Usada em: report FIDC, investor update, dashboard de risco. (4) score_medio — AVG(score) por segmento/período. Usada em: dashboard de construtora, analysis de risco. (5) tempo_medio_liquidacao — AVG(settled_at - approved_at). Usada em: SLO de fornecedor, dashboard operacional. Sem semantic layer: 'inadimplência' no report FIDC usa threshold de 90 dias; no dashboard de risco usa 60 dias. Investidor vê números diferentes em reports diferentes."
		meshImplication: "Implementar semantic layer como single source of truth para métricas: (1) definir cada métrica como código (dbt Semantic Layer, Cube.js, ou equivalente): nome, descrição, fórmula (SQL), tipo (sum, count, avg, ratio), filtros (status, período), dimensões disponíveis (segmento, construtora, período). (2) versionamento: métrica é artefato versionado. Mudança de fórmula é tracked em Git com rationale. (3) ownership: cada métrica tem owner (BC ou role responsável). Se métrica muda: owner comunica consumidores (conecta com api-versioning-evolution para métricas expostas a stakeholders). (4) testing: para cada métrica, test que verifica cálculo contra dados de teste conhecidos. 'Inadimplência para dataset X deve ser 4.2%.' Se test falha após mudança: fórmula tem bug. (5) documentação: cada métrica documentada com: definição de negócio (em linguagem natural), fórmula técnica (SQL), filtros e dimensões, ownership, e changelog. Acessível em dbt docs ou catálogo. (6) consumption: todo dashboard, report, e API que expõe métrica consome da semantic layer — não recalcula. Se ferramenta de BI não se integra com semantic layer: exportar metric definition para a ferramenta e validar. Anti-pattern: 'cada analista escreve sua query para calcular receita' — 5 definições diferentes, nenhuma é source of truth."
		dependsOn: ["dm-dimensional-modeling", "dm-transformation-as-code"]
		crossDependsOn: [{
			lensId:    "lens-stakeholder-communication"
			conceptId: "sc-trust-accumulation"
			context:   "SC modela confiança como ativo que acumula com consistência. Semantic layer é o mecanismo que garante consistência numérica — investidor que vê 'inadimplência 3.8%' num report e '4.2%' em outro perde confiança. Semantic layer garante que ambos mostram o mesmo número porque ambos consomem a mesma definição. SC diz 'consistência constrói confiança'; DM semantic layer implementa consistência nas métricas."
		}]
		rationale: "dbt Semantic Layer 2022+: metrics as code. Stancil 2022: semantic layer como missing piece. Na Mesh, métricas que vão para regulador (inadimplência), investidor (receita), e gestor FIDC (carteira) devem ser absolutamente consistentes — semantic layer é a garantia."
	},
	{
		id:         "dm-data-exposure-by-stakeholder"
		name:       "Exposição de Dados por Stakeholder: Cada Audiência Vê o que Precisa, Não Mais"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Princípio de 'need-to-know' aplicado a dados analíticos: cada stakeholder acessa apenas os dados necessários para seu papel, com granularidade adequada. Intersecção de: (1) data classification (sti-data-classification) — dados classificados por sensibilidade. (2) dimensional modeling — dados organizados por perguntas de negócio. (3) role-based access — permissões por stakeholder type. Conceito contemporâneo de 'data products' (Dehghani 2022): dados expostos como produtos com interface definida, SLOs, documentação, e access control — não como tabelas raw. Cada data product serve um consumidor ou grupo de consumidores. Conceito de 'analytical API' (Census 2023+, Hightouch 2023+): reverse ETL — mover dados analíticos de volta para sistemas operacionais e APIs. Dados que foram transformados no warehouse são expostos via API ou sincronizados para CRM, ferramenta de BI, ou aplicação."
		meshManifestation: "Na Mesh, dados expostos por stakeholder: (1) fornecedor — suas operações (status, valor, timestamps), seus documentos, seu score (apenas resultado: aprovado/rejeitado, não score numérico nem features). Granularidade: operação individual. Nunca: dados de outros fornecedores, dados da construtora, score detalhado. (2) construtora — seus fornecedores (qualificação, compliance), suas operações (pipeline completo), dados agregados de performance da cadeia. Granularidade: operação individual + agregações. Nunca: dados financeiros de fornecedores (faturamento), scoring model, dados de outras construtoras. (3) gestor FIDC — carteira (lastro, inadimplência, concentração, performance por safra), dados agregados de risco. Granularidade: operação individual (para lastro) + agregações (para relatórios). Nunca: dados pessoais de representantes, dados de compliance de fornecedores. (4) regulador — tudo que regulação exige: operações, risco, compliance, governance. Granularidade: determinada pelo regulador. (5) investidor — métricas de negócio (volume, receita, inadimplência, NRR, unit economics). Granularidade: agregações por período. Nunca: dados de clientes individuais."
		meshImplication: "Projetar exposure como data products: (1) para cada stakeholder: definir data product com schema, granularidade, filtros, e refresh rate. (2) supplier_operations_data_product — tabela/API com operações do fornecedor, filtrada por supplier_id. Schema público (id, status, valor, timestamps). Refresh: <5s (conecta com eda-projections). (3) builder_chain_data_product — dashboard data com fornecedores, operações, compliance do builder. Filtrada por builder_id. Refresh: <1min. (4) fidc_portfolio_data_product — relatório de carteira com lastro, inadimplência, concentração. Schema definido com gestor FIDC. Refresh: <5min. (5) regulatory_data_product — dados conforme exigência regulatória. Schema conforme normativo. Audit trail completo. (6) access control: cada data product tem access policy. Supplier data product: acessível apenas pelo supplier owner. Builder data product: acessível apenas pelo builder owner. FIDC: acessível pelo gestor autorizado. (7) reverse ETL: se stakeholder consome dados via API (não via dashboard): analytical API ou sync para sistema do stakeholder. Anti-pattern: dar acesso a tabelas raw do warehouse para stakeholder externo — exposição excessiva, sem filtro, sem granularidade adequada, e sem access control."
		dependsOn: ["dm-dimensional-modeling", "dm-semantic-layer"]
		crossDependsOn: [
			{
				lensId:    "lens-security-trust-infrastructure"
				conceptId: "sti-data-classification"
				context:   "STI classifica dados por sensibilidade (confidencial-regulatório, confidencial-comercial, interno, público). DM data exposure implementa a classificação: dados confidencial-regulatório (dados financeiros de construtoras) nunca aparecem em data product de fornecedor. STI define o nível; DM implementa o filtro na camada analítica."
			},
			{
				lensId:    "lens-api-design-as-product"
				conceptId: "api-resource-modeling"
				context:   "API define resource model para consumidores via HTTP. DM define data products para consumidores analíticos. Ambos são interfaces orientadas ao consumidor com ACL separando interno de externo. API serve dados transacionais em tempo real; DM serve dados analíticos com transformações e agregações. Para stakeholders que consomem ambos: consistência entre API response e data product é obrigatória (semantic layer garante)."
			},
		]
		rationale: "Dehghani 2022: data products. Census/Hightouch 2023+: reverse ETL. Na Mesh com 5 tipos de stakeholders com necessidades e permissões radicalmente diferentes, data products são a camada que garante que cada um vê exatamente o que precisa — nem mais (risco de segurança e compliance) nem menos (experiência subótima)."
	},
	{
		id:            "dm-data-modeling-review"
		name:          "Revisão de Modelagem de Dados: Inventário Periódico de Modelos, Métricas e Saúde"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) dimensional models — grains declarados e documentados? Novos fatos ou dimensões necessários? (2) feature store — features com freshness SLO atingido? Training-serving skew detectado? Novas features necessárias para scoring? (3) SCDs — Type 2 para dimensões financeiras? Temporal queries funcionando? (4) data architecture — arquitetura proporcional ao estágio? Próximo bottleneck de dados? (5) lineage — end-to-end para KPIs regulatórios? Impact analysis funcional? (6) transformations — dbt tests passando? Data contracts respeitados? (7) grain — grain de cada fact documentado? Algum grain errado detectado? (8) semantic layer — métricas core definidas e consistentes? Algum dashboard calculando métrica de forma diferente? (9) data products — cada stakeholder tem data product adequado? Access control funcionando?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (dbt test results, feature freshness, projeção lag, semantic layer consistency). Trimestral: macro-revisão com inventário completo."
		meshImplication: "Mensal (30min): dbt tests — todos passando? Algum test novo necessário? Feature store — freshness SLOs atingidos? Features com missing values? Projeções — lag dentro do SLO? Rebuild necessário? Semantic layer — métricas core consistentes entre dashboards? Trimestral (2h): dimensional models — novos fatos necessários (novo tipo de operação, nova métrica)? Grains adequados? SCDs — Type 2 funcionando? Temporal queries testadas? Lineage — KPIs regulatórios têm lineage end-to-end? Impact analysis: mudar coluna X afeta quais reports? Data architecture — volume cresceu? PostgreSQL ainda suficiente? Próximo estágio necessário? Feature store — novas features para scoring v2? Features obsoletas para deprecar? Data products — cada stakeholder satisfeito com dados disponíveis? Novo stakeholder (ex: auditor) precisa de data product? Se revisão não identifica pelo menos uma melhoria: ou modelagem é perfeita (improvável) ou revisão é superficial."
		dependsOn: ["dm-dimensional-modeling", "dm-feature-store", "dm-slowly-changing-dimensions", "dm-data-architecture-choice", "dm-data-lineage", "dm-transformation-as-code", "dm-grain-design", "dm-semantic-layer", "dm-data-exposure-by-stakeholder"]
		rationale: "Sem revisão periódica, modelos de dados fossilizam enquanto negócio evolui — novas métricas sem definição, novos stakeholders sem data product, SCDs não-testados. O inventário periódico mantém a modelagem alinhada com a realidade."
	},
]

reasoningProtocol: [
	{
		question:  "Qual é o grain desta fact table? O que exatamente cada row representa? Está documentado?"
		reveals:   "Se a unidade de análise é definida e clara — ou se números derivados podem estar errados por confusão de grain."
		rationale: "Kimball/Ross 2013: 'declare the grain before anything else.' Grain não-declarado é bug arquitetural que invalida toda análise downstream."
	},
	{
		question:  "As features que alimentam o scoring são calculadas de forma consistente entre treinamento e inferência? Existe feature store?"
		reveals:   "Se training-serving skew é prevenido — ou se scoring em produção usa features calculadas diferente do treinamento."
		rationale: "Hermann/Uber 2017: feature store resolve training-serving skew. Feature inconsistente gera score incorreto com confiança alta."
	},
	{
		question:  "Para dimensões que mudam ao longo do tempo (porte, faturamento, score): o histórico é preservado (SCD Type 2) ou sobrescrito (Type 1)?"
		reveals:   "Se análises temporais e auditoria são possíveis — ou se 'qual era o perfil no momento da decisão' não pode ser respondido."
		rationale: "Kimball/Ross 2013: SCD types. Na Mesh, regulador pergunta 'qual era o perfil do comprador na aprovação' — Type 1 não responde."
	},
	{
		question:  "A arquitetura de dados é proporcional ao estágio? PostgreSQL com materialized views ou lakehouse com Iceberg?"
		reveals:   "Se infraestrutura de dados é adequada ao volume e constraint — ou se é over-engineered (lakehouse para 1000 operações) ou under-engineered (queries de 8s em PostgreSQL sem otimização)."
		rationale: "ORA satisficing: PostgreSQL satisfice para bootstrap. Lakehouse quando volume justificar."
	},
	{
		question:  "Para cada KPI regulatório ou de investidor: existe lineage end-to-end documentada? De onde vem o dado, que transformações, que fórmula?"
		reveals:   "Se KPIs são reproduzíveis e auditáveis — ou se regulador/investidor pergunta 'como calculam isso?' e ninguém sabe responder com certeza."
		rationale: "DAMA-DMBOK2 2017: lineage para compliance. OpenLineage 2022+: automated lineage. KPI sem lineage é KPI não-auditável."
	},
	{
		question:  "As transformações de dados são código versionado e testado (dbt) ou scripts ad hoc que ninguém documenta?"
		reveals:   "Se pipeline analítico é reproduzível e confiável — ou se 'inadimplência mudou porque alguém alterou a query sem avisar'."
		rationale: "dbt Labs 2016+: analytics engineering. Transformação não-versionada é transformação não-auditável."
	},
	{
		question:  "As métricas core (receita, inadimplência, volume) são definidas uma vez na semantic layer ou calculadas independentemente em cada dashboard?"
		reveals:   "Se números são consistentes entre reports — ou se investidor vê 'receita X' enquanto regulador vê 'receita Y'."
		rationale: "Stancil 2022: semantic layer como missing piece. Métrica sem single source of truth é fonte de desconfiança."
	},
	{
		question:  "Cada stakeholder tem data product com granularidade, filtro e access control adequados? Alguém vê mais dados do que deveria?"
		reveals:   "Se exposure de dados é governada — ou se fornecedor pode ver dados de outro fornecedor, ou construtora pode ver scoring model."
		rationale: "Dehghani 2022: data as product. STI data classification. Need-to-know aplicado a analytics."
	},
	{
		question:  "Se scoring model precisa de nova feature: a feature já existe no feature store ou precisa ser criada do zero?"
		reveals:   "Se feature store habilita reuso — ou se cada iteração de modelo recalcula tudo desde o raw data."
		rationale: "Feast/Tecton 2020+/2021+: feature reuse. Calcular feature do zero a cada iteração é desperdício de compute e tempo."
	},
]

meshExamples: [
	{
		id:       "ex-grain-decision-antecipacao"
		scenario: "Mesh precisa criar fact table para operações de antecipação. Equipe propõe grain 'uma row por fornecedor por mês' para simplificar queries de relatório."
		analysis: "Grain proposto (fornecedor-mês) pré-agrega: perde detalhe de operação individual. Consequências: (1) não pode responder 'qual operação específica teve maior taxa?' (2) não pode join com dim_comprador por operação (cada operação pode ter comprador diferente). (3) não pode calcular inadimplência por operação (precisa saber quais operações defaultaram). (4) report de FIDC precisa de lastro por operação individual — grain agregado não serve. (5) backtesting de scoring precisa de score por operação — grain agregado perde. O grain 'por fornecedor por mês' serve para dashboard executivo mas não para análise detalhada, compliance, ou ML."
		recommendation: "Dois grains: (1) fact_antecipacao com grain atômico: 1 row por operação. Colunas: operation_id, supplier_id, buyer_id, value, rate, score_at_approval, settlement_date, registration_date, status, timestamps. Source of truth. Serve: análise detalhada, FIDC lastro, backtesting, compliance. (2) agg_antecipacao_fornecedor_mensal: grain agregado derivado. 1 row por fornecedor por mês. Colunas: supplier_id, month, total_operations, total_value, avg_rate, avg_score, default_count. dbt model: SELECT supplier_id, date_trunc('month', created_at) as month, COUNT(*), SUM(value), ... FROM fact_antecipacao GROUP BY 1, 2. Serve: dashboard executivo, trend analysis. Regra: atômico é materializado sempre. Agregado é conveniência derivada. Se atômico e agregado divergem: bug no agregado, não no atômico."
		principlesApplied: ["ax-01", "ax-02", "ax-07"]
		assumptions: [
			"operação é o grain atômico correto — verificar se sub-operações existem (parcelas, tranches)",
			"dashboard executivo é satisfeito por agregação mensal — pode precisar de semanal ou diário",
			"dbt ref() chain garante que agregado deriva do atômico — testar que SUM(agg) = SUM(fact)",
			"FIDC aceita lastro no formato fact_antecipacao — verificar schema exigido pelo gestor",
		]
		rationale: "Kimball/Ross 2013: grain atômico como base. Grain agregado pré-maturo perde informação que não pode ser reconstruída. Na Mesh, regulador e FIDC precisam de operação individual — grain agregado como source of truth é insuficiente."
	},
	{
		id:       "ex-feature-store-scoring-v2"
		scenario: "Scoring model v1 usa 5 features calculadas inline no código do modelo. Model v2 precisa de 12 features, incluindo 3 que requerem agregação de 6 meses de histórico. Cálculo inline de 12 features a cada scoring request leva 3s (vs 200ms para v1). Latência SLO de scoring: <1s."
		analysis: "Feature calculation inline é insustentável: (1) latência 3s > SLO 1s. (2) features históricas (agregação de 6 meses) recalculadas a cada request — compute desperdiçado. (3) se lógica de feature muda: mudar no código do modelo + no pipeline de treinamento — risk de training-serving skew. (4) 12 features × 100 scorings/dia × 3s = 1h de compute por dia em feature calculation que deveria ser pré-computada."
		recommendation: "Implementar feature store: (1) pré-revenue: materialized views em PostgreSQL como feature store. (a) mv_buyer_financial_features: faturamento_mensal (última atualização), historico_pagamentos_90d (avg dias de atraso), total_antecipacoes_ativas (SUM valor WHERE status = 'active'). Refresh: a cada 1h. (b) mv_buyer_operational_features: frequencia_entregas_90d (COUNT de entregas recebidas), diversidade_fornecedores (COUNT DISTINCT supplier_id), score_externo (último score do bureau). Refresh: a cada 6h. (c) mv_buyer_historical_features: inadimplencia_historica_180d, variacao_faturamento_180d, tendencia_score_180d. Refresh: diário. (2) scoring pipeline: lê features da materialized view por buyer_id — single SELECT, <10ms. Features são pré-computadas, não recalculadas. (3) training pipeline: usa mesma materialized view (snapshot para training dataset) — garantia de consistency. (4) monitoring: freshness de cada MV como SLI. Se mv_buyer_financial_features não atualiza há 2h: alerta. Missing values: se >5% de buyers sem faturamento_mensal: investigar. (5) evolução: quando Feast for necessário (online store para <1ms, offline store para training datasets granulares): migrar — MVs são o stepping stone."
		principlesApplied: ["ax-01", "ax-03", "dp-01"]
		assumptions: [
			"materialized views com refresh de 1h são fresh o suficiente para scoring — se operação precisa de score com dados de <5min, MV é insuficiente",
			"PostgreSQL performance de MV refresh é aceitável — depende de volume de dados e complexidade da query",
			"training-serving consistency com MV snapshot é adequada — para high-frequency retraining, pode precisar de point-in-time correctness mais rigorosa",
			"12 features é set final para v2 — feature selection pode mudar durante desenvolvimento do modelo",
		]
		rationale: "Hermann/Uber 2017: feature store. Feast 2020+: offline/online store. Na Mesh, 3s de latência por feature calculation inline é 10x acima do SLO e desperdício de compute. Materialized views como feature store são satisficing: latência <10ms, consistency garantida, zero infra adicional."
	},
	{
		id:       "ex-scd-buyer-rating-audit"
		scenario: "Bacen solicita: 'para as 10 maiores operações de antecipação do Q3 2026, informar o faturamento mensal do comprador no momento da aprovação.' dim_comprador tem apenas faturamento atual (SCD Type 1)."
		analysis: "SCD Type 1: faturamento atual do comprador é R$1.2M. Mas no Q3 2026 (momento da aprovação), faturamento era R$850k. Type 1 sobrescreveu — informação histórica perdida. Responder ao regulador: impossível com dados atuais. Alternativas: (1) buscar no event log — se BuyerScored carrega features_snapshot com faturamento: resposta é possível via replay (eda-replay-temporal-queries). (2) se features_snapshot não inclui faturamento (apenas score calculado): impossível. Conclusão: event sourcing salva para auditoria de scoring, mas camada analítica (dim_comprador) não tem histórico — qualquer análise que não é 'reconstruir scoring' mas sim 'análise de portfólio por perfil do comprador ao longo do tempo' não pode ser feita."
		recommendation: "(1) Migrar dim_comprador para SCD Type 2 imediatamente: adicionar effective_from, effective_to, is_current. A cada atualização de faturamento: nova row com effective_from = now(), row anterior com effective_to = now(). (2) recuperar histórico: se dados de faturamento histórico estão disponíveis (event log de integrações, snapshots de bureau): backfill dim_comprador com versões históricas. Se não: aceitar perda e começar a preservar a partir de agora. (3) join temporal: queries que precisam de perfil do comprador no momento da operação: JOIN dim_comprador ON fact.buyer_id = dim.buyer_id AND fact.approved_at BETWEEN dim.effective_from AND dim.effective_to. (4) temporal tables (se PostgreSQL suportar): implementar como system-versioned temporal table — database gerencia versioning automaticamente. (5) para o regulador: responder com dados disponíveis (score no momento da aprovação via event log) + nota de que faturamento histórico não estava sendo preservado + ação corretiva (SCD Type 2 implementado). (6) regra: toda dimensão que pode ser questionada pelo regulador 'no momento da operação' é SCD Type 2. Faturamento, score, porte, segmento, compliance status."
		principlesApplied: ["ax-05", "ax-07", "dp-01"]
		assumptions: [
			"faturamento histórico pode ser recuperado de event log ou integração — se não pode, perda é permanente",
			"PostgreSQL performance com SCD Type 2 é aceitável — tabela dim_comprador cresce com cada update de faturamento",
			"join temporal (BETWEEN effective_from AND effective_to) é correto e performante — indexar effective_from + buyer_id",
			"regulador aceita 'não tínhamos histórico, corrigimos' como resposta — pode haver consequência",
		]
		rationale: "Kimball/Ross 2013: SCD Type 2 preserva história. SQL:2011: temporal tables. Na Mesh, pergunta do regulador 'qual era o perfil no momento da aprovação' é inevitável — SCD Type 1 para dados financeiros é dívida que se materializa como incapacidade de responder ao regulador."
	},
	{
		id:       "ex-semantic-layer-inconsistency"
		scenario: "Investidor aponta discrepância: investor update mostra 'inadimplência 2.8%' mas dashboard de risco mostra 'inadimplência 3.5%'. Founder investiga e descobre que investor update calcula inadimplência sobre operações settled+completed com threshold de 90 dias, enquanto dashboard de risco calcula sobre todas as operações ativas com threshold de 60 dias."
		analysis: "Dois cálculos legítimos para contextos diferentes, mas ambos chamados 'inadimplência'. Investidor perde confiança: 'qual é a inadimplência real?' Causa raiz: cada dashboard implementa sua própria query com definição diferente. Sem semantic layer: não há single source of truth. O problema vai piorar: quando FIDC precisar de 'inadimplência' e regulador precisar de 'inadimplência', serão 4 definições diferentes."
		recommendation: "(1) Definir no semantic layer 2 métricas distintas: (a) inadimplencia_90d — SUM(valor_em_aberto WHERE dias_atraso > 90 AND status IN ('settled', 'completed')) / SUM(valor_total WHERE status IN ('settled', 'completed')). Uso: investor update, report FIDC. (b) risco_inadimplencia_60d — SUM(valor_em_aberto WHERE dias_atraso > 60 AND status = 'active') / SUM(valor_total WHERE status = 'active'). Uso: dashboard de risco operacional (early warning). (2) naming: nunca usar 'inadimplência' sem qualificador. Sempre 'inadimplência 90d (settled)' ou 'risco de inadimplência 60d (active)'. (3) metrics layer: ambas definidas como dbt metrics com SQL, description, e ownership. Todo dashboard que precisa de 'inadimplência' consome da metrics layer — não escreve query própria. (4) testing: para dataset de teste conhecido, inadimplencia_90d deve retornar 2.8% e risco_inadimplencia_60d deve retornar 3.5%. Test em CI. (5) documentação: para cada métrica, description inclui: o que mede, como calcula, para que audiência serve, e por que é diferente de métricas similares. (6) comunicação: atualizar investor update com nota: 'inadimplência reportada é inadimplência realizável (>90 dias, operações settled) — conforme definição Bacen.' Dashboard de risco: 'risco de inadimplência é early warning (>60 dias, operações ativas) — não é inadimplência realizada.' Investidor entende a diferença se comunicada; não entende se descobre por conta."
		principlesApplied: ["ax-01", "ax-06", "ax-07"]
		assumptions: [
			"threshold de 90 dias para inadimplência realizada é conforme regulação Bacen — verificar",
			"threshold de 60 dias para early warning é adequado — pode precisar de calibração",
			"investidor aceita duas métricas diferentes se bem-comunicadas — depende do investidor",
			"dbt metrics cobre as necessidades de semantic layer — avaliar Cube.js se BI tool não se integra com dbt",
		]
		rationale: "Stancil 2022: semantic layer como single source of truth. SC trust-accumulation: inconsistência destrói confiança. Na Mesh, 'inadimplência' é a métrica mais consequente — investidor, regulador e FIDC devem ver números consistentes e explicáveis. Semantic layer garante; naming preciso comunica."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "ax-05", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-event-driven-architecture-patterns"
		relation: "complementsWith"
		context:  "EDA define como dados fluem como eventos e como projeções materializam read models. DM define como dados são estruturados para consumo analítico. EDA projeções são o pipeline; DM modelos dimensionais são o output. EDA (eda-replay-temporal-queries) complementa DM (dm-slowly-changing-dimensions): replay para auditoria operacional; SCD para análise analítica temporal. EDA é fluxo; DM é estrutura."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI monitora data quality como risco operacional (freshness, volume, distribution). DM consome data quality como input — features e modelos dimensionais dependem de dados saudáveis. OOI detecta anomalia; DM lineage mostra impacto downstream. OOI é upstream (qualidade do dado); DM é downstream (estrutura e consumo analítico)."
	},
	{
		lensId:   "lens-credit-risk"
		relation: "complementsWith"
		context:  "CR modela risco de crédito e scoring. DM (dm-feature-store) alimenta scoring com features consistentes. DM (dm-slowly-changing-dimensions) preserva histórico para backtesting. DM (dm-semantic-layer) define métricas de inadimplência usadas por CR. CR é o modelo; DM é a infraestrutura de dados que o modelo consome."
	},
	{
		lensId:   "lens-stakeholder-communication"
		relation: "complementsWith"
		context:  "SC comunica métricas a stakeholders. DM (dm-semantic-layer) garante que métricas são consistentes. DM (dm-data-exposure-by-stakeholder) define quais dados cada stakeholder vê. SC diz 'comunicar inadimplência 2.8% ao investidor'; DM garante que 2.8% é calculado corretamente e consistentemente."
	},
	{
		lensId:   "lens-security-trust-infrastructure"
		relation: "complementsWith"
		context:  "STI classifica dados e controla acesso. DM (dm-data-exposure-by-stakeholder) implementa classificação na camada analítica — dados confidenciais não aparecem em data products de quem não deve ver. STI é a política; DM é a implementação na camada de dados."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA aloca recursos proporcionalmente ao estágio. DM (dm-data-architecture-choice) respeita: PostgreSQL para bootstrap, lakehouse para escala. ORA (ora-satisficing) governa: materialized views satisfice como feature store pré-revenue. Investir em Tecton quando volume e equipe justificarem."
	},
	{
		lensId:   "lens-knowledge-management"
		relation: "complementsWith"
		context:  "KM define knowledge as code. DM (dm-transformation-as-code) é knowledge as code para dados — dbt models como SQL versionado, testado, documentado. DM (dm-data-lineage) complementa KM: lineage de dados é knowledge about data provenance. Ambos versionados no repositório."
	},
	{
		lensId:   "lens-api-design-as-product"
		relation: "complementsWith"
		context:  "API define interface transacional para integradores. DM define interface analítica para stakeholders. Ambos separam modelo público de modelo interno (ACL). Para stakeholders que consomem ambos (construtora: API + dashboard): consistência entre API response e data product é obrigatória — semantic layer garante."
	},
]

limitations: [
	{
		description: "Modelagem dimensional assume que perguntas de negócio são conhecidas antecipadamente — fact tables e dimensions são projetadas para queries esperadas. Perguntas genuinamente novas podem não ser respondíveis pelo modelo existente."
		alternative: "Manter grain atômico como source of truth — permite responder perguntas não-antecipadas (embora com performance menor que modelo dimensional otimizado). Wide tables como fallback para queries exploratórias. Lakehouse com schema-on-read para análises genuinamente ad hoc."
		rationale: "Kimball: modelos dimensionais otimizam queries conhecidas. Grain atômico preserva flexibilidade para queries desconhecidas — com trade-off de performance."
	},
	{
		description: "Feature store adiciona infraestrutura e complexidade. Para modelos simples com poucas features (v1 com 5 features), feature store é over-engineering."
		alternative: "Materialized views como 'poor man's feature store' para <20 features. Feature store formal (Feast/Tecton) quando: features > 20, múltiplos modelos compartilham features, ou training-serving skew é detectado. Proporcional ao estágio."
		rationale: "Hermann/Uber 2017: feature store para ML em escala. Para Mesh v1 com 5 features: MV é suficiente. Para v2 com 12+: avaliar."
	},
	{
		description: "SCD Type 2 faz dimension tables crescerem significativamente — comprador com faturamento atualizado mensalmente gera 12 rows/ano. Com 1000 compradores × 5 anos: 60.000 rows em dim_comprador. Joins temporais (BETWEEN) são mais lentos que joins simples."
		alternative: "SCD Type 2 apenas para dimensões com relevância regulatória/financeira. Type 1 para dimensões sem impacto analítico temporal. Index adequado (buyer_id + effective_from) mitiga performance. Para volume muito alto: particionar por effective_year."
		rationale: "Trade-off: storage e performance vs capacidade de análise temporal. Para intermediário financeiro: análise temporal é requisito, não opção."
	},
	{
		description: "Semantic layer requer que toda métrica seja centralizada — isso cria dependência na camada semântica para todo report. Se semantic layer tem bug ou fica indisponível: todos os dashboards são afetados."
		alternative: "Semantic layer como source of truth, mas dashboards podem ter cache local de últimos valores. Se semantic layer indisponível: degradação graciosa (dados stale, não ausência total). Bug na fórmula: test em CI pega antes de produção. Ownership claro de cada métrica para fix rápido."
		rationale: "Single point of truth pode ser single point of failure. Mitigar com testes, cache, e ownership claro — não eliminando a centralização (que é o benefício)."
	},
	{
		description: "Data products por stakeholder requerem manutenção — cada stakeholder novo ou necessidade nova requer novo data product ou extensão de existente. Custo de manutenção cresce com número de stakeholders."
		alternative: "Priorizar data products para stakeholders de alto impacto (FIDC, regulador, investidor). Para stakeholders menores: acesso a views analíticas com filtro por role (menos customizado mas menos manutenção). Data products full apenas quando a customização gera valor desproporcional."
		rationale: "Dehghani 2022: data products requerem investimento. Nem todo stakeholder justifica data product customizado — proporcionar ao impacto."
	},
]

rationale: "Toda organização data-intensive precisa de modelos de dados que transformem dados operacionais brutos em poder analítico. Na Mesh como intermediário financeiro AI-native, dados são o ativo competitivo central — cada operação gera dados que melhoram scoring, pricing, e decisões de stakeholders. Esta lens operacionaliza: modelagem dimensional com star schema e wide tables para queries de negócio (Kimball/Ross 2013, wide tables 2022+), metrics layer como single source of truth para métricas (dbt Semantic Layer 2022+, Stancil 2022), feature store como infraestrutura para ML com consistency training-serving (Hermann/Uber 2017, Feast 2020+, Tecton 2021+, Hopsworks 2023+), slowly changing dimensions para análise temporal e auditoria (Kimball/Ross 2013, SQL:2011, pg_temporal 2023+), arquitetura de dados proporcional ao estágio — warehouse, lake, lakehouse, mesh (Inmon 1992, Kimball 1996, Armbrust et al. 2021, Dehghani 2022), data lineage automatizado para impact analysis e compliance (DAMA-DMBOK2 2017, OpenLineage 2022+, DataHub/Atlan 2023+), transformação como código com testing pyramid (dbt Labs 2016+, Andrew Jones 2023, Great Expectations), grain design como decisão arquitetural fundamental (Kimball/Ross 2013), semantic layer para consistência de métricas (dbt 2022+, Cube.js 2020+), e data products por stakeholder com access control (Dehghani 2022, Census/Hightouch 2023+). Universal, agnóstica a estágio, aplicável a qualquer organização que precisa de dados analíticos confiáveis."

}
