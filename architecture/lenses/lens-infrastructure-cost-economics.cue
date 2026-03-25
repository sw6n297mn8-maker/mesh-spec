package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

infrastructureCostEconomics: artifact_schemas.#AnalyticalLens & {
id:     "lens-infrastructure-cost-economics"
name:   "Economia de Custos de Infraestrutura"

purpose: "Orientar decisões sobre como otimizar custo de infraestrutura — cost-per-operation, right-sizing, build-vs-buy e cost-aware architecture decisions."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve quanto custa rodar cada componente do sistema (compute, storage, AI inference, database, networking)",
		"a decisão envolve trade-offs entre qualidade técnica (modelo mais sofisticado, mais réplicas, mais redundância) e custo operacional",
		"a decisão envolve como o custo de infraestrutura escala com volume de operações, dados armazenados ou participantes",
		"a decisão envolve se a Mesh gera receita suficiente (spread + SaaS fee) para cobrir custo de infraestrutura por operação",
		"a decisão envolve como otimizar custo de inference de modelos de IA (scoring, compliance, agentes) por decisão",
		"a decisão envolve como escolher entre soluções managed (mais caras, menos operação) e self-hosted (mais baratas, mais operação)",
		"a decisão envolve como projetar architecture decisions com constraint de custo (não apenas performance e correção)",
		"a decisão envolve como monitorar e alertar sobre cost anomalies antes que virem surpresa na fatura",
	]
	keywords: [
		"custo", "cost", "preço", "pricing", "fatura", "billing",
		"infraestrutura", "infrastructure", "cloud", "AWS", "GCP", "Azure",
		"compute", "CPU", "GPU", "instance", "container", "serverless",
		"storage", "armazenamento", "S3", "RDS", "database cost",
		"inference", "inferência", "token", "API call", "model cost",
		"unit economics", "custo por operação", "cost per transaction",
		"managed service", "self-hosted", "build vs buy",
		"scaling", "escalabilidade", "auto-scaling", "right-sizing",
		"FinOps", "cost optimization", "cost allocation", "tagging",
		"margem", "margin", "spread", "receita vs custo",
		"budget", "orçamento", "forecast", "projeção de custo",
		"reserved instance", "spot", "savings plan",
	]
	excludeWhen: [
		"a decisão é sobre pricing e monetização para o cliente (quanto cobrar) — usar pricing-and-monetization-architecture",
		"a decisão é sobre alocação de founder time como recurso — usar organizational-resource-allocation",
		"a decisão é sobre escolha de technology stack — usar o ADR relevante",
		"a decisão é sobre performance e latência — usar distributed-systems-design ou observability-operational-intelligence",
	]
	rationale: "Se a Mesh consome mais em compute, storage e AI inference do que gera em spread e receita de software: ela morre — independente de quão elegante seja a arquitetura. Nenhuma das lenses existentes força o agente a considerar o custo computacional das suas decisões de arquitetura. Escolher modelo de ML mais sofisticado para scoring pode melhorar AUROC em 3% mas triplicar custo de inference por decisão. Adicionar 3 réplicas de read para performance perfeita pode custar 3x mais database sem necessidade no volume atual. Usar GPT-4 para compliance checking quando heurística simples resolve 95% dos casos: desperdício. PM lens cobre quanto cobrar do cliente (receita). ORA cobre tempo do founder. Esta lens cobre o outro lado da equação: quanto custa rodar a plataforma, como custo escala com volume, como cada decisão técnica tem implicação financeira, e como manter unit economics positiva — custo por operação < receita por operação em todo estágio de crescimento."
}

concepts: [
	{
		id:         "ic-cost-per-operation"
		name:       "Custo por Operação: A Métrica Fundamental de Viabilidade"
		nature:     "theoretical"
		role:       "framework"
		definition: "Cost per operation é o custo total de infraestrutura para processar 1 operação de antecipação end-to-end: from submission to settlement. Inclui: compute (API processing, business logic), database (read/write/storage), AI inference (scoring, compliance), messaging (events, notifications), storage (documents, audit logs), networking (API calls to bank, external services). Conceito de 'fully-loaded cost per transaction' (2023+): não apenas custo direto de compute mas: (a) direct costs — compute, storage, network, AI inference para esta operação. (b) shared costs — database servidor (compartilhado entre operações), monitoring infra, CI/CD. Allocated: pro-rata por volume. (c) operational costs — time de founder/agent para operar plataforma. Allocated: pro-rata. Formula: cost_per_op = (direct + shared/volume + operational/volume). Conceito de 'cost-revenue threshold' (2024+): para cada operação, Mesh gera receita (spread no deságio + taxa de plataforma). Viabilidade: cost_per_op < revenue_per_op. Se cost = R$5 e revenue = R$8: margem = R$3 (viable). Se cost = R$5 e revenue = R$3: margem = -R$2 (cada operação perde dinheiro — escalar piora). Concepto de 'cost scaling curve' (2024+): como cost_per_op muda com volume. Ideal: decreasing (economies of scale — shared costs diluem com volume). Risk: increasing (complexity costs grow faster than volume — cada operação requer mais processing conforme sistema cresce). Na prática: decreasing para shared costs, constant para direct costs (compute por operação é ~constante), increasing se AI inference becomes more complex com mais dados."
		meshManifestation: "Na Mesh, cost breakdown por operação de antecipação (estimativa para MVP/early stage): **Direct costs per operation:** (1) API compute: ~R$0,01 (request processing: create, approve, settle — 3-5 API calls, ~100ms each, small compute). (2) scoring inference: ~R$0,05-0,50 (depends on model: simple logistic regression on features = R$0,01. LLM-based analysis = R$0,50. XGBoost on structured features = R$0,05). (3) compliance check: ~R$0,02 (document validation, Receita API call). (4) event processing: ~R$0,01 (3-5 events per operation). (5) notification: ~R$0,01 (email/push). (6) bank API: ~R$0,02 (liquidation call + status check). Total direct: ~R$0,12-0,62 per operation (highly dependent on scoring model choice). **Shared costs (monthly, allocated pro-rata):** database: R$200-500/month (managed PostgreSQL). Monitoring: R$50-100/month. CI/CD: R$50/month. Domain/TLS: R$10/month. Total shared: R$310-660/month. At 100 ops/month: R$3,10-6,60 per op (dominant cost). At 1.000 ops/month: R$0,31-0,66 per op. At 10.000 ops/month: R$0,03-0,07 per op. **Revenue per operation (illustrative):** antecipação de R$50.000 com taxa total de 2,5%: spread = R$1.250. Se Mesh captura 10% do spread como platform fee: R$125 por operação. **Unit economics:** at 100 ops/month: cost ~R$3,70-7,22 per op. Revenue ~R$125. Margin: R$118-121. Massively positive because revenue per op is high relative to infrastructure cost. **Critical insight:** for Mesh, unit economics are DOMINATED by revenue side (spread on financial operations), not cost side. Infrastructure cost is rounding error compared to financial revenue. The concern is not 'can we afford compute?' — it's 'can we acquire enough operations to cover fixed costs (team, legal, FIDC setup)?'"
		meshImplication: "Cost per operation tracking: (1) **instrument costs** — tag cloud resources by: component (scoring, api, database, events), tenant (for allocation), and operation_type (antecipação, compliance_check, reporting). Cloud provider tags enable: cost allocation by dimension. (2) **cost dashboard** — monthly: cost by component (pie chart: scoring 40%, database 30%, compute 15%, other 15%). Cost per operation trend (line chart: monthly). Revenue per operation vs cost per operation (margin trend). (3) **alert thresholds** — cost anomaly: if daily cost > 2x rolling 7-day average: alert. Component anomaly: if scoring cost spikes 3x: alert (model may be stuck in loop, or traffic spike). (4) **cost modeling for decisions** — every architecture decision: estimate cost impact. ADR template includes: 'estimated cost impact: +R$X/month at current volume, +R$Y/month at 10x volume.' Agent creating ADR: models cost. Founder: approves with cost awareness. (5) **cost-aware agent instructions** — CLAUDE.md: 'when selecting between alternatives (managed vs self-hosted, sophisticated vs simple model, more replicas vs fewer): estimate cost difference. If alternatives are functionally equivalent: prefer lower cost. If cost difference is <10%: prefer simplicity. If cost difference is >3x: requires explicit justification in ADR.' (6) **cost review cadence** — monthly: review cloud bill. Compare: budget vs actual. Identify: top 3 cost drivers. Action: optimize if >20% over budget. Anti-pattern: 'we need 3 read replicas, an ElasticSearch cluster, a Redis cache, a Kafka cluster, and a GPU instance for ML' — for a platform processing 50 operations/month. Infrastructure for 50.000 ops/month when you have 50: R$5.000/month wasted. Right-size for current volume + headroom (2-3x), not for fantasy scale."
		rationale: "Fully-loaded cost 2023+. Cost-revenue threshold 2024+. Cost scaling curve 2024+. Na Mesh, unit economics are revenue-dominated (R$125 revenue vs R$5 cost per operation at 100 ops/month). Infrastructure cost is not existential risk — customer acquisition and volume are. But: cost discipline prevents waste that distracts from growth."
	},
	{
		id:         "ic-ai-inference-economics"
		name:       "Economia de Inference de IA: Custo por Decisão de Agente"
		nature:     "operational"
		role:       "property"
		reviewCadence: "monthly"
		definition: "Em AI-native platform, AI inference é cost driver significativo — pode ser o maior custo direto por operação. Conceito de 'inference cost spectrum' (2024+): custo varia ordens de magnitude por approach: (1) **rule-based / heuristic:** ~R$0,001/decision. Simple if/then logic. Zero inference cost. Example: 'if compliance docs expired: reject.' (2) **classical ML (logistic regression, XGBoost):** ~R$0,01-0,05/decision. Feature engineering + model inference. CPU-based, fast. Example: scoring with 10 structured features. (3) **embedding + neural network:** ~R$0,05-0,20/decision. Feature embedding + neural inference. May need GPU. Example: scoring with text features (company description embedding). (4) **LLM (Claude, GPT-4):** ~R$0,50-5,00/decision. Full prompt + response. Token-based pricing. Example: compliance document analysis with natural language reasoning. (5) **LLM + tools + multi-turn:** ~R$2,00-20,00/decision. Multi-turn reasoning with tool use. Example: complex due diligence with web search, document analysis, and reasoning chain. Conceito de 'model selection by task value' (2024+): match model cost to task value. Task that affects R$50.000 operation: R$0,50 inference is 0.001% — negligible. Task that affects notification preference: R$0,50 inference is absurd — use heuristic. Conceito de 'tiered inference' (2024+): not every operation needs the same model. Score > 80 (clear approve): simple model. Score 40-80 (ambiguous): sophisticated model. Score < 40 (clear reject): simple model. Sophisticated model reserved for ambiguous cases where it adds value. 80% of operations: simple model (cheap). 20%: sophisticated model (expensive but justified)."
		meshManifestation: "Na Mesh, inference cost per agent type: **Scoring agent:** (1) simple model (XGBoost on 10 features): R$0,02/operation. Adequate for: operations with clear signal (strong payment history, established relationship). (2) sophisticated model (XGBoost + text embeddings): R$0,15/operation. For: ambiguous cases, new fornecedores, edge cases. (3) LLM-enhanced scoring (Claude for reasoning explanation): R$1,00/operation. For: operations requiring human-readable explanation (FIDC due diligence, disputed scores). Tiered: 70% simple + 25% sophisticated + 5% LLM = weighted average ~R$0,07/operation (vs R$1,00 if all LLM). **Compliance agent:** (1) rule-based check (doc expiry, format validation): R$0,001/check. 90% of compliance. (2) document classification (is this a certidão negativa?): R$0,05/doc (ML classifier). (3) document content analysis (does certidão match CNPJ?): R$0,30/doc (LLM). Tiered: 90% rule + 8% classifier + 2% LLM = ~R$0,01/check average. **Reporting agent:** (1) aggregation queries (SQL): R$0,001/report. (2) narrative generation (LLM writes summary): R$0,50/report. Tiered: reports sem narrative = SQL only. Reports with narrative (monthly FIDC report): LLM. Frequency: 1 LLM report/FIDC/month vs 100 SQL reports = blended ~R$0,01/report."
		meshImplication: "AI cost optimization: (1) **tiered inference as default** — for each agent type: define tiers by case complexity. Simple cases (80%): cheapest adequate model. Ambiguous (15%): sophisticated model. Complex (5%): most expensive. Tier assignment: rule-based (score > threshold → simple tier). (2) **caching** — if same features → same score (deterministic model): cache score for feature hash. If fornecedor re-submits with unchanged features: cached score, zero inference. Cache hit rate: depends on how often features change. Potential savings: 20-40% of inference calls. (3) **batching** — if model supports batch inference: process 10-50 operations in single model call. Batch overhead < 10 × individual overhead. XGBoost: batch is ~10x cheaper per item than individual. LLM: limited batching (context window constraint). (4) **model selection with cost constraint** — ADR for model selection: 'Model A: AUROC 0.76, cost R$0,02/op. Model B: AUROC 0.79, cost R$0,50/op. AUROC improvement: +0.03. Cost increase: 25x. At 1000 ops/month: Model B costs R$480/month more than Model A. Is +0.03 AUROC worth R$480/month?' Decision: depends on marginal value of accuracy improvement. If 0.03 AUROC prevents 1 default/month worth R$5.000: yes (ROI: 10x). If prevents 0.1 default/month worth R$500: no (ROI: 1x, marginal). (5) **inference cost monitoring** — per agent type: monthly cost, cost per decision, cost trend. Alert: if scoring cost/operation increases >50%: investigate (model change? traffic pattern? bug causing retries?). (6) **LLM cost containment** — when using Claude/GPT: (a) minimize prompt size (only necessary context — dp-agent-consumability). (b) limit max_tokens in response. (c) use cheaper model when possible (Haiku for simple tasks, Sonnet for complex). (d) cache responses for identical inputs. (e) rate limit: max N LLM calls per operation. (7) **build vs buy for inference** — self-hosted XGBoost: R$0,001/inference (compute only). API-based LLM: R$0,50/inference (token pricing). For structured ML: self-host (orders of magnitude cheaper). For NLP/reasoning: API (capability gap too large to self-build). Hybrid: structured ML self-hosted + LLM API for reasoning = optimal cost/capability. Anti-pattern: using Claude Opus for every scoring decision (R$2/op) when XGBoost achieves 95% of the accuracy at R$0,02/op. Or: self-hosting LLM to save on API costs when hosting costs R$5.000/month and API would cost R$500/month."
		dependsOn: ["ic-cost-per-operation"]
		crossDependsOn: [{
			lensId:    "lens-ml-ai-systems-design"
			conceptId: "ml-model-selection"
			context:   "ML defines model selection by accuracy, latency, and complexity. IC adds cost dimension: model selection must consider cost per inference alongside accuracy. ML says 'Model B has higher AUROC'; IC says 'Model B costs 25x more per inference — is the accuracy improvement worth it at projected volume?' ML is capability optimization; IC is cost-constrained capability optimization."
		}]
		rationale: "Inference cost spectrum 2024+. Model selection by task value 2024+. Tiered inference 2024+. Na Mesh, tiered inference: 70% simple (R$0,02) + 25% sophisticated (R$0,15) + 5% LLM (R$1,00) = R$0,07/op average vs R$1,00/op if all LLM. 14x savings. Same accuracy distribution: simple model is accurate for clear cases."
	},
	{
		id:         "ic-right-sizing"
		name:       "Right-Sizing: Infraestrutura Proporcional ao Volume Real, Não ao Volume Imaginado"
		nature:     "operational"
		role:       "heuristic"
		reviewCadence: "monthly"
		definition: "Right-sizing é ajustar capacidade de infraestrutura ao volume real de uso, não ao volume aspiracional. Conceito de 'premature scaling' (2023+): provisionar infraestrutura para 100.000 operações/mês quando volume real é 100. Custo: 1000x mais do que necessário. Startup com 100 operações/mês não precisa: multi-region deployment, 3 read replicas, dedicated Kafka cluster, GPU instances, ElasticSearch cluster, dedicated Redis cluster. Precisa: 1 managed PostgreSQL, 1 small application server, API for AI inference. Conceito de 'headroom budgeting' (2024+): provision for current volume + 2-3x headroom (for spikes and near-term growth). Not 1000x headroom. If processing 100 ops/month: provision for 300. If grows to 250: scale to 750. Scale steps, not scale everything upfront. Concepto de 'managed vs self-hosted economics' (2024+): managed services (RDS, CloudSQL, managed Kafka, managed Redis): higher per-unit cost, zero operational cost. Self-hosted: lower per-unit cost, significant operational cost (patches, backups, monitoring, troubleshooting). For solo founder: managed wins — operational cost of self-hosting is founder time, which is the most expensive resource (ORA throughput-constraint). For team of 5+: self-hosted may be cheaper if dedicated ops person. Rule: self-host only when: (a) managed option doesn't exist for needed capability. (b) cost difference is >5x AND volume justifies operational investment."
		meshManifestation: "Na Mesh at MVP stage (100 ops/month): **Right-sized infrastructure:** (1) database: 1× managed PostgreSQL (smallest production tier: ~R$200/month on Railway, Supabase, or Neon). Not: 3-node HA cluster + 2 read replicas (R$2.000/month). (2) application: 1× small container (2 vCPU, 4GB RAM, ~R$100/month). Not: Kubernetes cluster with auto-scaling (R$500/month minimum). (3) AI inference: API calls to Claude/model endpoint. No self-hosted GPU. Cost: per-operation (R$0,07/op × 100 = R$7/month). Not: dedicated GPU instance (R$1.500/month running 24/7 for 100 calls). (4) event processing: in-process (transactional outbox + poller). Not: managed Kafka (R$300/month) or dedicated event broker. (5) file storage: S3-compatible (R$5/month for documents). (6) monitoring: free tier of monitoring tool (Grafana Cloud free, or self-hosted with small instance). Not: Datadog at R$500/month. **Total monthly: ~R$320/month.** At 100 ops/month: R$3,20/op shared cost. Revenue: ~R$12.500/month (100 × R$125). Margin: ~R$12.180. **Growth trigger for scaling:** when 300 ops/month approached: evaluate database performance, application CPU, inference latency. Scale individual components as needed, not wholesale upgrade."
		meshImplication: "Right-sizing implementation: (1) **start minimal** — smallest production-viable instance of each component. Not development-tier (unreliable) but not enterprise-tier (wasteful). Production-viable: managed, backed up, monitored, but small. (2) **scale triggers** — for each component: define metric that triggers scaling. Database: when CPU >70% sustained or storage >80%: scale up. Application: when P95 latency >500ms: add instance. AI inference: when queue depth >10: investigate (batching? Caching? Model optimization?). (3) **no premature multi-region** — single region for MVP. Multi-region when: regulatory requires (data residency) or latency requires (users in multiple geographies). Brazilian construção civil: single region (sa-east-1 or equivalent) is sufficient. Multi-region: adds complexity + cost without benefit until international. (4) **serverless where appropriate** — functions that run infrequently (monthly FIDC report generation, nightly reconciliation): serverless (pay per execution). Functions that run constantly (API server): container (pay per hour is cheaper than pay per request at constant load). (5) **reserved instances / savings plans** — after 3 months of stable usage: evaluate reserved capacity. Database: reserved instance saves 30-40% vs on-demand. Application: savings plan for consistent compute. Not before 3 months: usage pattern may change. (6) **cost per component visibility** — cloud provider tags: every resource tagged with component (scoring, api, database) and environment (production, staging). Monthly: report by tag. Top 3 cost drivers: visible. Optimization: targeted. (7) **FinOps practice** — monthly: 30 minutes reviewing cloud bill. Questions: any resource idle? Any resource over-provisioned? Any service with free-tier alternative? Any unexpected cost spike? (8) **for agents:** CLAUDE.md: 'when proposing infrastructure: size for current volume × 3 headroom. Not for 1000x. If recommending managed service: note monthly cost. If recommending new infrastructure component: justify — is existing component insufficient? Can function be achieved with existing infrastructure?' Anti-pattern: architecture diagram with 15 services, 3 databases, Kafka, Redis, ElasticSearch, and a GPU cluster for a platform processing 50 operations/month. Total cost: R$8.000/month. Revenue: R$6.250/month. Negative unit economics from infrastructure bloat."
		dependsOn: ["ic-cost-per-operation"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-throughput-constraint"
			context:   "ORA identifies founder time as throughput constraint. IC right-sizing applies: managed services are more expensive per-unit but free the constraint (founder doesn't spend time on ops). Self-hosting is cheaper per-unit but consumes constraint (founder debugs database issues instead of building product). ORA says 'don't waste constraint time'; IC says 'managed services trade money for constraint time — at early stage, money is cheaper than time.'"
		}]
		rationale: "Premature scaling 2023+. Headroom budgeting 2024+. Managed vs self-hosted 2024+. Na Mesh at 100 ops/month: R$320/month total infrastructure. Revenue: R$12.500/month. Infrastructure is not the bottleneck — volume is. Right-size for today + 3x, not for 1000x."
	},
	{
		id:         "ic-cost-scaling-model"
		name:       "Modelo de Escalabilidade de Custo: Como Custo Cresce com Volume"
		nature:     "theoretical"
		role:       "property"
		definition: "Nem todo componente escala linearmente com volume. 3 patterns: **(1) constant cost** — doesn't change with volume. Domain registration, TLS certificate, basic monitoring. R$50/month whether 10 or 10.000 ops. **(2) step-function cost** — constant within tier, jumps at tier boundary. Database: R$200/month up to 1.000 ops. R$500/month at 1.000-10.000. R$2.000/month at 10.000-100.000. Steps defined by: CPU, storage, connections. **(3) linear cost** — proportional to volume. AI inference: R$0,07/op × N operations. Storage: R$X per GB × documents stored. Event processing: per-message pricing. **(4) super-linear cost** — cost grows faster than volume. Complex queries on growing dataset: O(n²) query on 10x data = 100x compute. Training ML model on larger dataset: cost grows with data size. Aggregation reports on larger datasets: heavier queries. Conceito de 'cost model per component' (2024+): for each infrastructure component: define cost function f(volume). Use to: forecast monthly cost at projected volume. Identify: which components will dominate cost at scale."
		meshManifestation: "Na Mesh, cost scaling by component: **Constant (volume-independent):** domain, TLS, DNS, basic monitoring, CI/CD base: ~R$110/month. Irrelevant at scale. **Step-function:** database: R$200 (to 500 ops) → R$500 (to 5.000) → R$2.000 (to 50.000) → R$5.000 (to 500.000). Application server: R$100 (to 500 ops) → R$300 (to 5.000) → R$1.000 (to 50.000). Steps: infrequent, planned, budgetable. **Linear:** scoring inference: R$0,07 × N. Event processing: R$0,01 × N × 4 (4 events/op). Notifications: R$0,01 × N. Storage: R$0,001 × docs stored. Bank API: R$0,02 × N. **Super-linear (watch):** analytical queries: report generation time grows with data volume. If inadimplência query scans all operations: O(n). If concentration query does self-join: O(n²). Mitigation: materialized views, pre-aggregation. ML training: grows with training data size. Mitigation: sample, incremental training. **Cost at milestones:** 100 ops/month: ~R$320 (dominated by constants + database step). 1.000 ops/month: ~R$600 (database step + linear emerges). 10.000 ops/month: ~R$2.700 (linear dominates: scoring R$700, database R$2.000). 100.000 ops/month: ~R$12.000 (linear: scoring R$7.000, database R$5.000). Revenue at 100.000 ops: ~R$12.500.000/month. Cost is 0.1% of revenue."
		meshImplication: "Cost modeling implementation: (1) **cost model spreadsheet** — for each component: cost function, current volume, projected volume at 6/12/24 months, projected cost. Updated quarterly. Identifies: when next step-function jump occurs, when linear costs become material, when super-linear costs need optimization. (2) **dominant cost identification** — at each stage: identify top 3 cost drivers. At 100 ops: database + application (step-function base). At 10.000: database + scoring inference (step + linear). At 100.000: scoring + database + storage (linear dominates). Optimize: the dominant driver, not everything. (3) **super-linear detection** — monitor: query execution time as data grows. If report generation time doubles when data doubles: linear (acceptable). If quadruples: super-linear (needs optimization). Dashboard: query time trends for top 10 queries. (4) **optimization priorities** — optimize by ROI: component with highest cost × easiest optimization = highest ROI. Scoring inference at R$7.000/month with 3x reduction possible via tiered approach: save R$4.600/month. Database at R$5.000/month with limited optimization: save R$500/month. Prioritize: scoring optimization. (5) **forecast for fundraising** — investor question: 'what are your infrastructure costs at 10x/100x?' Cost model with clear functions: 'at 100x volume: infrastructure costs R$12.000/month, revenue is R$12.5M/month, infra is 0.1% of revenue.' Compelling: shows cost doesn't grow faster than revenue. (6) **for agents:** CLAUDE.md: 'when adding infrastructure component: estimate monthly cost at current volume AND at 10x volume. If cost at 10x is >R$5.000/month: document in ADR with justification. Prefer solutions that scale linearly or step-function over super-linear.' Anti-pattern: no cost model — monthly cloud bill is a surprise. 'Why did we spend R$3.000 this month when budget was R$500?' Without cost model: impossible to attribute, predict, or optimize."
		dependsOn: ["ic-cost-per-operation"]
		rationale: "Cost model per component 2024+. Na Mesh, cost at 100.000 ops/month (~R$12.000) is 0.1% of revenue (~R$12.5M/month). Infrastructure cost is not a threat to economics — but unmodeled cost is a threat to planning and investor confidence."
	},
	{
		id:         "ic-build-vs-buy-economics"
		name:       "Build vs Buy: Quando Construir, Quando Comprar, Quando Usar Free-Tier"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Every infrastructure component: decision between build (self-host, custom), buy (managed service, SaaS), or free-tier (open source + free cloud tier). Conceito de 'total cost of ownership for infrastructure' (2024+): buy cost = subscription fee. Build cost = development time + hosting + maintenance + opportunity cost of founder time. TCO often: build < buy in dollar cost but build > buy in total cost when founder time is valued. Conceito de 'capability gap' (2024+): for some capabilities (LLM inference, payment processing), the gap between build and buy is so large that build is not viable regardless of cost. Self-hosting LLM with comparable quality to Claude: requires ML team + GPU infrastructure + training data. Cost: millions. Buy: API call. For other capabilities (CRUD API, simple queue): build is trivial, buy adds unnecessary dependency. Decision framework: (1) **core differentiator** → build (scoring algorithm, supply chain intelligence — this is competitive advantage). (2) **complex commodity** → buy (database, monitoring, LLM inference — commodity that requires deep expertise to operate well). (3) **simple commodity** → build or free-tier (CRUD endpoints, simple queue, file storage — trivial to implement, free alternatives exist)."
		meshManifestation: "Na Mesh, build vs buy decisions: **Build (core differentiator):** scoring model (competitive advantage — how Mesh prices risk differently). Supply chain intelligence (proprietary — graph analysis of cadeia). Antecipação workflow engine (domain-specific — state machine of ECL). **Buy (complex commodity):** database: managed PostgreSQL (Railway, Supabase, Neon, or RDS). Monitoring: managed (Grafana Cloud, Sentry). LLM inference: API (Anthropic Claude). Payment processing: banking partner API. Email: managed (Resend, SendGrid). **Free-tier / open source:** web framework: Ktor (Kotlin) or FastAPI (Python) — open source. Event processing: in-process outbox (no external service). File storage: S3-compatible free tier (Cloudflare R2: 10GB free). CI/CD: GitHub Actions free tier. Auth: self-implemented JWT (simple for MVP) → Auth0/Clerk when multi-org complexity justifies."
		meshImplication: "Decision framework implementation: (1) **decision tree per component:** Is it core differentiator? → Build. Is it complex commodity? → Buy managed. Is it simple commodity? → Build with open source or use free-tier. (2) **managed service evaluation:** for each buy decision: evaluate 3 options by: monthly cost at current volume, cost at 10x, feature set, lock-in risk, exit strategy. Choose: cheapest that meets requirements with acceptable lock-in. (3) **free-tier maximization** — at early stage: maximize free tiers. GitHub Actions: 2.000 min/month free. Cloudflare R2: 10GB free. Grafana Cloud: 10k metrics free. Supabase: 500MB database free. Total free-tier infrastructure: sufficient for MVP development and early production. Cost: R$0/month until thresholds exceeded. (4) **lock-in assessment** — for each managed service: how hard is migration to alternative? Database: PostgreSQL is portable (migrate to any PostgreSQL provider). Proprietary database (DynamoDB): locked to AWS. Auth service (Auth0): moderate lock-in (user data exportable, integration code needs rewrite). Rule: prefer portable technologies for core data (PostgreSQL over DynamoDB), accept lock-in for ephemeral services (monitoring, email). (5) **buy threshold** — when to switch from build/free to buy: when free-tier limit exceeded AND time to operate exceeds time to pay. If managing self-hosted monitoring takes 4h/month and managed costs R$50/month: buy (4h of founder time >> R$50). (6) **review triggers** — quarterly: any free-tier approaching limit? Any managed service with cheaper alternative? Any build that should be bought (too much maintenance time)? Any buy that should be built (too expensive for commodity feature)? Anti-pattern: buying Datadog (R$500/month), Auth0 (R$200/month), managed Kafka (R$300/month), Twilio (R$100/month) for platform with 50 ops/month and R$6.250/month revenue. R$1.100/month in managed services = 18% of revenue. Free-tier alternatives: sufficient for this volume."
		dependsOn: ["ic-cost-per-operation", "ic-right-sizing"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-opportunity-cost"
			context:   "ORA defines opportunity cost — founder time spent on X is not spent on Y. IC build-vs-buy uses: build cost includes opportunity cost of founder time. If founder spends 8h/month managing self-hosted database: those 8h could have been spent on customer acquisition (potentially R$10.000+ in pipeline). Managed database at R$200/month: ROI of buying is R$10.000/R$200 = 50x. ORA says 'value constraint time'; IC says 'managed services buy back constraint time — evaluate ROI of time saved.'"
		}]
		rationale: "TCO for infrastructure 2024+. Capability gap 2024+. Na Mesh solo founder, managed services for complex commodity: database, monitoring, LLM. Build for core differentiator: scoring, supply chain intelligence. Free-tier for everything else at early stage. Decision: maximize founder time for core product, not infrastructure operations."
	},
	{
		id:         "ic-cost-anomaly-detection"
		name:       "Detecção de Anomalias de Custo: Saber Antes da Fatura Surpresa"
		nature:     "operational"
		role:       "method"
		reviewCadence: "monthly"
		definition: "Cost anomalies: unexpected spikes in infrastructure cost. Causes: (a) traffic spike (legitimate growth or attack). (b) runaway process (infinite loop, stuck batch job). (c) misconfiguration (wrong instance size, forgotten test environment). (d) pricing change from provider. (e) data growth exceeding free tier. Conceito de 'cost alerting' (2023+): automated alerts when cost exceeds threshold: daily spend > 2x rolling average. Component cost > budget. Approaching free-tier limit (80%). New resource created (unexpected). Concepto de 'cost attribution' (2024+): every cost is attributable to: component (which service), environment (production, staging, development), tenant (if allocating per-tenant), purpose (scoring, storage, compute). Attribution enables: 'scoring costs R$700/month, 60% of total. Database costs R$300/month, 25%.' Without attribution: 'total is R$1.200/month' — can't optimize what can't be attributed."
		meshManifestation: "Na Mesh, cost monitoring: (1) **daily cost tracking:** cloud provider billing API → daily cost by service. Compare: today's cost vs 7-day rolling average. If >2x: alert. (2) **component attribution:** tags on all resources. scoring-service: compute + API calls. database: RDS/managed PostgreSQL. storage: S3/R2. monitoring: observability tools. events: messaging costs. Monthly report: cost by component (pie chart). (3) **free-tier monitoring:** each free-tier service: track usage vs limit. At 80%: alert 'approaching limit for X. Current: Y/Z. At current growth: limit reached in N days. Action: evaluate paid tier or alternative.' (4) **staging/development cost:** separate tracking. Alert if staging cost > 30% of production cost (should be minimal — staging doesn't need same scale)."
		meshImplication: "Cost monitoring implementation: (1) **cloud billing alerts** — set budget in cloud provider: monthly budget = current average × 1.5. Alert at 50%, 80%, 100%, 120% of budget. Email to founder. (2) **resource tagging discipline** — every cloud resource: tagged with component, environment, owner. Untagged resource: alert 'untagged resource created — tag or justify.' CI: infrastructure-as-code (Terraform/Pulumi) with required tags. Manual resource creation: discouraged. (3) **monthly cost review** — 30 minutes: (a) total cost vs budget. (b) cost by component — any component growing faster than others? (c) cost per operation — improving (economies of scale) or degrading? (d) idle resources — any resource with <5% utilization? Resize or remove. (e) upcoming free-tier limits — any service approaching? Plan: upgrade or migrate. (4) **cost forecasting** — based on growth trend: project cost 3/6/12 months out. If cost grows faster than revenue: investigate which component is super-linear. (5) **for agents:** when agent provisions new resource (creates database, deploys service): log estimated monthly cost. If >R$100/month: flag for founder review. CLAUDE.md: 'when creating infrastructure: estimate monthly cost. If >R$100/month: document in ADR. If temporary (testing, experiment): set auto-delete timer.' Anti-pattern: test database provisioned for debugging, forgotten, runs for 6 months at R$200/month = R$1.200 wasted. Auto-delete for non-production resources: default 7 days, extendable with justification."
		dependsOn: ["ic-cost-per-operation", "ic-right-sizing"]
		rationale: "Cost alerting 2023+. Cost attribution 2024+. Na Mesh, monthly cost review (30 min) prevents: surprise bills, idle resources, free-tier overages. At early stage: R$200 surprise is significant (6% of R$3.200 total). At scale: R$2.000 surprise is noise (0.02% of revenue). But: discipline established early carries forward."
	},
	{
		id:         "ic-database-cost-optimization"
		name:       "Otimização de Custo de Database: O Componente de Custo Mais Previsível e Otimizável"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Database é tipicamente o maior custo fixo (step-function) em B2B SaaS. Optimization levers: (1) **right-size instance** — if CPU <30% average: smaller instance would work. If CPU >80%: queries may be inefficient (optimize before scaling up). (2) **query optimization** — slow queries consume more compute. Top 10 slow queries: optimize (indexes, query rewrite, materialized views). Each optimization: reduces compute → extends current instance tier. (3) **storage optimization** — archive old data (operations >2 years: move to cold storage). Compress: TOAST compression for large text fields. Partitioning: time-based partitioning for operations table (queries only scan relevant partition). (4) **connection pooling** — too many connections: overhead. PgBouncer or built-in pooling: reduces connection overhead. (5) **read replicas** — only when read load justifies. At 100-1000 ops/month: primary handles everything. At 10.000+: evaluate read replica for analytical queries (reporting doesn't compete with operational writes)."
		meshManifestation: "Na Mesh, database optimization by stage: **MVP (100 ops):** smallest managed PostgreSQL. No read replica. No partitioning. Focus: correct schema, proper indexes for common queries. Cost: R$200/month. Optimization: ensure no obvious N+1 queries. **Growth (1.000 ops):** same instance may suffice (PostgreSQL handles this easily). Add: indexes for new query patterns. Monitor: slow query log. Cost: R$200-500/month. **Scale (10.000 ops):** evaluate: is instance CPU >50%? If yes: optimize queries first (cheaper than bigger instance). Then: scale instance if needed. Consider: read replica for reporting/analytics (separate analytical load from operational). Partitioning: operations by month (queries for 'last 30 days' scan 1 partition, not entire table). Cost: R$2.000/month. **Large scale (100.000 ops):** definitely: read replicas for analytics. Partitioning. Query optimization. Possibly: separate analytical database (materialized views replicated to analytical PostgreSQL or data warehouse). Cost: R$5.000/month."
		meshImplication: "Database cost strategy: (1) **optimize before scaling** — slow query? Index or rewrite. Don't: scale to bigger instance to make slow query bearable. Bigger instance: R$300/month more. Index: R$0 more + 15 minutes of work. (2) **slow query monitoring** — PostgreSQL: pg_stat_statements extension. Top 10 queries by: total time, calls, mean time. Monthly: review top 10. Any >100ms mean that could be faster? (3) **storage management** — operations table: grows continuously. At 100k ops × 10 events each × 1KB per event: ~1GB/year of events. Storage is cheap (R$0,10/GB/month). But: queries on large tables slow down. Partitioning: table remains fast regardless of total size. (4) **connection management** — at MVP: direct connections (no pooler). At 100+ concurrent connections (unlikely at early stage): add PgBouncer. Over-provisioning connections: wastes memory. (5) **backup optimization** — continuous backup (WAL archiving): free on most managed providers. Point-in-time recovery: essential for financial system. Don't cut: backup is not optional. (6) **reserved pricing** — after 3 months of stable usage: switch to reserved instance (30-40% savings). 1-year commitment: reasonable if database need is certain (financial system needs database). Anti-pattern: running 3 read replicas at R$600/month each for a system with 200 queries/hour — primary handles 20.000 queries/hour comfortably. Replicas idle, cost: R$1.800/month wasted."
		dependsOn: ["ic-cost-per-operation", "ic-right-sizing"]
		rationale: "Database is predictable step-function cost. Optimization: queries (free), indexes (free), partitioning (free), right-sizing (reduces cost). Na Mesh, optimize queries before scaling instance = R$0 investment, same or better result as R$300/month bigger instance."
	},
	{
		id:         "ic-cost-aware-architecture-decisions"
		name:       "Decisões de Arquitetura com Consciência de Custo: ADR Inclui Impacto Financeiro"
		nature:     "operational"
		role:       "heuristic"
		reviewCadence: "quarterly"
		definition: "Every architecture decision has cost implication. Conceito de 'cost as architectural requirement' (2024+): alongside performance, correctness, and maintainability: cost is a first-class requirement in architecture decisions. ADR template includes: 'cost impact: estimated monthly cost at current volume and at 10x volume.' Decision alternatives evaluated on: functionality, complexity, cost, and cost-at-scale. Concepto de 'cost-performance pareto' (2024+): for each decision: identify the cost-performance pareto frontier. Some alternatives: more expensive AND worse. Eliminate. Remaining: trade cost vs performance/quality. Choose: the point on the frontier that matches current stage. Pre-revenue: optimize cost. Post-PMF: optimize capability. Scale: optimize efficiency (cost per unit of capability)."
		meshManifestation: "Na Mesh, cost-aware ADR examples: (1) **event store choice:** EventStoreDB (dedicated): R$300/month + better replay performance. PostgreSQL + Marten (existing): R$0 additional + adequate performance for <100k events. Decision: PostgreSQL (R$0 additional, adequate). ADR: 'cost impact: R$0/month. Trigger to reconsider: replay >10s or events >100k.' (2) **monitoring:** Datadog: R$500/month, full-featured. Grafana Cloud free-tier + Sentry free-tier: R$0/month, adequate for MVP. Decision: free-tier. ADR: 'cost impact: R$0/month. Trigger: when free-tier limits exceeded or observability gaps emerge.' (3) **scoring model:** XGBoost on structured features: R$0,02/inference, AUROC 0.74. Neural network with embeddings: R$0,15/inference, AUROC 0.77. Decision: XGBoost for MVP (+0.03 AUROC doesn't justify 7.5x cost at current volume). ADR: 'cost impact: R$2/month (100 ops × R$0,02) vs R$15/month. Trigger: when AUROC gap causes measurable default rate difference.'"
		meshImplication: "Cost-aware ADR process: (1) **ADR template addition:** 'Cost Impact' section: estimated monthly cost at current volume, at 10x, at 100x. Comparison: cost of alternatives. (2) **cost-performance analysis:** for each alternative: plot cost vs key metric (performance, accuracy, capability). Identify: pareto-optimal alternatives. Choose: appropriate point for current stage. (3) **stage-appropriate optimization:** pre-revenue: minimize cost (free-tier, simplest adequate solution). Post-PMF: balance cost and capability (invest in what drives growth). Scale: maximize efficiency (cost per operation, cost per user). (4) **cost trigger in ADR:** every cost-optimization ADR: 'trigger to reconsider: when [condition]. Action: [evaluate more expensive alternative].' Prevents: forever stuck on cheapest option when business justifies investment. (5) **for agents:** CLAUDE.md: 'every ADR must include cost impact section. When proposing alternatives: estimate cost of each. When cost difference is <10%: prefer simpler. When cost difference is >3x: require explicit justification for more expensive option.' Anti-pattern: ADR that evaluates 5 alternatives on 10 dimensions but doesn't mention cost — team selects most capable option, deploys, monthly bill doubles, founder surprised."
		dependsOn: ["ic-cost-per-operation", "ic-ai-inference-economics", "ic-right-sizing", "ic-build-vs-buy-economics"]
		rationale: "Cost as architectural requirement 2024+. Cost-performance pareto 2024+. Na Mesh, ADR with cost impact: every architecture decision is cost-conscious. Pre-revenue: optimize cost. Post-PMF: invest where ROI justifies. The cost section in ADR prevents: expensive solutions adopted without awareness."
	},
	{
		id:            "ic-cost-review"
		name:          "Revisão de Custos: Inventário Periódico de Economia de Infraestrutura"
		nature:        "operational"
		role:          "method"
		reviewCadence: "monthly"
		definition:    "Inventário periódico: (1) total cost vs budget — within 20%? (2) cost per operation — improving with scale? (3) cost by component — any unexpected growth? (4) AI inference — tiered approach working? Average cost per decision? (5) right-sizing — any over-provisioned resources? Any idle? (6) free-tiers — any approaching limits? (7) anomalies — any spikes explained? (8) forecast — next 3 months: projected cost? Within revenue trajectory?"
		meshManifestation: "Na Mesh: revisão mensal (30 min). Cloud bill analysis + cost per operation trend."
		meshImplication: "Monthly (30min): (a) total: cloud bill vs budget. Within 20%? If over: identify cause. (b) cost per operation: total cost ÷ operations this month. Trend: improving (economies of scale) or degrading? (c) by component: top 3 costs. Any growing >20% MoM without corresponding volume growth? (d) AI inference: average cost per scoring decision. Tiered approach: what % at each tier? Can more be shifted to cheaper tier? (e) idle resources: any resource with <10% utilization? Resize or remove. (f) free-tiers: approaching 80% of any limit? Plan: upgrade or migrate. (g) anomalies: any day with >2x average cost? Explained? (h) forecast: at current growth rate: cost in 3 months? Affordable? Quarterly (additionally): (i) build-vs-buy review: any managed service that should be replaced? Any self-hosted that should be managed? (j) reserved capacity: stable workloads eligible for reserved pricing? (k) cost model update: growth assumptions still valid? Cost functions still accurate?"
		dependsOn: ["ic-cost-per-operation", "ic-ai-inference-economics", "ic-right-sizing", "ic-cost-scaling-model", "ic-build-vs-buy-economics", "ic-cost-anomaly-detection", "ic-database-cost-optimization", "ic-cost-aware-architecture-decisions"]
		rationale: "Monthly 30-minute cost review: discipline that prevents surprises. At early stage: R$200 savings is material. At scale: cost review ensures unit economics remain positive as volume grows."
	},
]

reasoningProtocol: [
	{
		question:  "Custo por operação é conhecido? Revenue por operação cobre custo com margem saudável em todo estágio de crescimento?"
		reveals:   "Se unit economics são viáveis — ou se cada operação perde dinheiro e escalar piora."
		rationale: "Cost-revenue threshold 2024+. Na Mesh: revenue >> cost per operation. But: must be measured, not assumed."
	},
	{
		question:  "AI inference usa tiered approach (simples para casos claros, sofisticado para ambíguos)? Ou modelo mais caro é usado para tudo?"
		reveals:   "Se inference cost é otimizado — ou se LLM a R$1/decisão é usado quando XGBoost a R$0,02 resolve 80% dos casos."
		rationale: "Tiered inference 2024+. 80% simple + 20% sophisticated = 14x savings vs all-expensive."
	},
	{
		question:  "Infraestrutura é right-sized para volume atual × 3 headroom? Ou provisioned para volume aspiracional 1000x?"
		reveals:   "Se recursos são proporcionais — ou se R$5.000/month de infra serve 50 ops/month."
		rationale: "Premature scaling 2023+. Right-size for today × 3. Scale when trigger hit."
	},
	{
		question:  "Cada ADR inclui cost impact? Alternativas avaliadas por custo além de funcionalidade?"
		reveals:   "Se custo é first-class architectural requirement — ou se decisões são tomadas sem awareness de impacto financeiro."
		rationale: "Cost as architectural requirement 2024+. ADR without cost: decision without complete information."
	},
	{
		question:  "Build vs buy é decidido por: core differentiator (build), complex commodity (buy managed), simple commodity (free-tier)?"
		reveals:   "Se decisões de infraestrutura maximizam founder time — ou se founder opera database em vez de construir produto."
		rationale: "Managed frees constraint. Build costs constraint. At early stage: time >> money."
	},
	{
		question:  "Cost anomalies são detectadas por alertas automáticos? Monthly review de 30 min acontece?"
		reveals:   "Se custos são monitorados — ou se fatura é surpresa mensal."
		rationale: "Cost alerting 2023+. 30 min/month prevents: idle resources, surprise bills, free-tier overages."
	},
	{
		question:  "Database é otimizado (queries, indexes, partitioning) antes de escalar para instância maior?"
		reveals:   "Se optimization precede scaling — ou se problem é masked by throwing more money at it."
		rationale: "Optimize before scale. Index (R$0) > bigger instance (R$300/month). Same or better result."
	},
]

meshExamples: [
	{
		id:       "ex-tiered-scoring-inference"
		scenario: "All scoring uses Claude Sonnet for natural-language-enhanced risk analysis. Cost: R$0,80/operation. At 1.000 ops/month: R$800/month in scoring alone. Founder asks: 'can we reduce scoring cost without sacrificing quality?'"
		analysis: "R$800/month for scoring at 1.000 ops. Revenue: R$125.000/month. Scoring is 0.64% of revenue — not existential. But: at 100.000 ops → R$80.000/month. Still 0.64% of revenue (linear scaling). However: 80% of operations have clear features (high score or low score). Only 20% are ambiguous and benefit from LLM reasoning. Using LLM for clear cases: paying for sophistication where heuristic suffices."
		recommendation: "(1) Implement tiered inference: Tier 1 (clear approve, score >80 predicted by feature heuristic): XGBoost only. R$0,02/op. ~40% of operations. Tier 2 (mid-range, 40-80): XGBoost + feature engineering. R$0,05/op. ~40% of operations. Tier 3 (ambiguous, <40 or edge cases): XGBoost + Claude Sonnet reasoning explanation. R$0,80/op. ~20% of operations. (2) Weighted cost: 40% × R$0,02 + 40% × R$0,05 + 20% × R$0,80 = R$0,008 + R$0,02 + R$0,16 = R$0,188/op. (3) Savings: R$0,80 → R$0,19 per op. 76% reduction. At 1.000 ops: R$190/month instead of R$800. At 100.000 ops: R$19.000 instead of R$80.000. (4) Quality impact: Tier 1 and 2 (80% of ops): XGBoost is sufficient for clear cases — AUROC difference vs LLM is <0.01 for operations where signal is clear. Tier 3 (20%): LLM provides reasoning explanation valued by FIDC for ambiguous cases. Net: quality equivalent where it matters, cheaper where it doesn't. (5) Implementation: pre-scoring heuristic: feature-based classifier predicts tier. If historical score for similar features >80 or <40: Tier 1 or 3. Middle: Tier 2. Heuristic: simple, fast, ~R$0,001. (6) Monitoring: per-tier: volume, accuracy (vs eventual outcome), cost. If Tier 1 accuracy degrades: tighten threshold (more ops go to Tier 2)."
		principlesApplied: ["ax-01", "ax-03"]
		assumptions: [
			"40/40/20 split is realistic — validate with historical score distribution",
			"XGBoost for clear cases matches LLM accuracy — validated: for score >80, features are unambiguous",
			"pre-scoring heuristic is accurate tier classifier — may need training on historical data",
			"FIDC values LLM reasoning for ambiguous cases — validate with FIDC stakeholder",
		]
		rationale: "Tiered inference 2024+. Model selection by task value. 76% cost reduction by matching model cost to case complexity. LLM for ambiguous (value). XGBoost for clear (efficiency). Same outcome, 1/4 of cost."
	},
	{
		id:       "ex-premature-scaling-prevention"
		scenario: "Agent proposes architecture: 'Kubernetes cluster with 3 nodes, managed Kafka for events, ElasticSearch for search, Redis for caching, dedicated PostgreSQL HA cluster with read replica.' Platform processes 50 operations/month."
		analysis: "Proposed infrastructure cost: Kubernetes (R$500), Kafka (R$300), ElasticSearch (R$400), Redis (R$200), PostgreSQL HA + replica (R$800). Total: R$2.200/month. Revenue at 50 ops: R$6.250/month. Infrastructure: 35% of revenue. Each component is technically justifiable ('Kafka for event sourcing! ElasticSearch for full-text! Redis for caching!'). But at 50 ops/month: PostgreSQL handles events (transactional outbox), search (LIKE query or trigram index), caching (no cache needed — 50 ops/month = no hot path), and HA (managed PostgreSQL with automated backups is sufficient)."
		recommendation: "(1) Right-sized alternative: 1× managed PostgreSQL (R$200). 1× small application container (R$100). Claude API for scoring (R$0,07 × 50 = R$3,50). S3-compatible storage free tier (R$0). GitHub Actions CI (free tier). Monitoring free tier (R$0). Total: ~R$305/month. (2) Savings: R$2.200 → R$305 = R$1.895/month saved. 86% reduction. (3) What gets deferred (not eliminated): Kafka → transactional outbox in PostgreSQL (adequate for 50-5.000 ops/month). ElasticSearch → PostgreSQL LIKE + trigram index (adequate for <10.000 records). Redis → no caching layer (50 ops/month = zero contention). K8s → single container on Railway/Fly.io (adequate until horizontal scaling needed). HA PostgreSQL → managed PostgreSQL with automated backups (acceptable risk at 50 ops). (4) Scaling triggers documented in ADR: 'when outbox poller latency >5s: evaluate Kafka. When search queries >1s on >10.000 records: evaluate ElasticSearch. When API P95 >500ms at >100 concurrent users: evaluate K8s. When database failover time is unacceptable for SLA: evaluate HA cluster.' (5) Each trigger: specific, measurable, tied to volume. Not: 'when we feel we need it.'"
		principlesApplied: ["ax-01", "ax-03", "dp-01"]
		assumptions: [
			"PostgreSQL handles 50-5.000 ops/month without dedicated event broker — easily, PostgreSQL handles millions of rows",
			"LIKE + trigram is sufficient for search at <10.000 records — yes, with GIN index on trigram",
			"single container is reliable enough for MVP — managed platforms (Railway, Fly.io) provide restart on crash",
			"scaling triggers are accurate — validate with benchmarks at trigger thresholds",
		]
		rationale: "Premature scaling 2023+. 50 ops/month does not need: K8s, Kafka, ElasticSearch, Redis, HA cluster. It needs: PostgreSQL + container + API. R$305/month vs R$2.200/month. The difference: R$1.895/month = 23 months of runway at current burn. Right-size for today, scale when triggers fire."
	},
	{
		id:       "ex-cost-aware-adr"
		scenario: "ADR for monitoring solution. Options: (A) Datadog — full-featured, APM, logs, metrics. R$500/month. (B) Grafana Cloud free-tier + Sentry free-tier — metrics + error tracking. R$0/month. (C) Self-hosted Grafana + Loki — full-featured, open-source. R$100/month (hosting) + 4h/month founder maintenance."
		analysis: "Option A: R$500/month, zero maintenance, best features. Option B: R$0/month, zero maintenance, basic but sufficient for MVP. Option C: R$100/month, 4h/month maintenance (at founder opportunity cost of R$250/h = R$1.000/month equivalent). True cost: A=R$500, B=R$0, C=R$1.100 (including opportunity cost)."
		recommendation: "**ADR: Monitoring Solution.** Context: MVP stage, 50-100 ops/month, solo founder. **Decision: Option B (Grafana Cloud free + Sentry free).** Cost impact: R$0/month at current volume. At 10x: likely still within free tier. At 100x: may exceed free tier (evaluate paid tier ~R$50-100/month). Functionality: metrics (Grafana free: 10.000 metrics), error tracking (Sentry free: 5.000 events/month), basic alerting. Gaps vs Datadog: no APM (acceptable — 50 ops/month doesn't need APM), no log aggregation (acceptable — console logs + Sentry errors sufficient), no synthetic monitoring (acceptable — not needed for MVP). **Rejected: Option A (Datadog)** — R$500/month for capabilities not needed at 50 ops. 8% of revenue spent on monitoring. Trigger to reconsider: when free-tier limits exceeded AND gaps (APM, log aggregation) cause operational pain. **Rejected: Option C (self-hosted)** — R$100/month + 4h/month founder time. TCO: R$1.100/month (with opportunity cost). Worse than both A and B. Founder time on monitoring infra: not building product."
		principlesApplied: ["ax-01", "ax-03"]
		assumptions: [
			"Grafana Cloud free tier handles 50-100 ops monitoring — 10.000 metrics is generous for this volume",
			"Sentry free tier handles error volume — 5.000 events/month is generous for MVP",
			"founder opportunity cost is ~R$250/h — based on value of time spent on product vs infrastructure",
			"APM is not needed at MVP — correct: 50 ops/month, latency is not critical optimization target yet",
		]
		rationale: "Cost as architectural requirement 2024+. Build vs buy + TCO analysis. Option B: R$0/month with acceptable gaps. Option A: R$500/month with capabilities not needed. Option C: R$1.100/month TCO when opportunity cost included. ADR with cost section: decision is informed and justified."
	},
	{
		id:       "ex-database-optimize-before-scale"
		scenario: "Database CPU at 75% sustained. Founder's instinct: 'scale up to next tier (R$200 → R$500/month).' Investigation reveals: 1 query (concentration report) runs every 15 minutes, takes 8 seconds, scans entire operations table (50.000 rows), and consumes 40% of CPU."
		analysis: "75% CPU with 1 query consuming 40%: removing that query's impact → 35% CPU (comfortable). The query: SELECT sacado_id, SUM(valor) as total, SUM(valor)/portfolio_total as concentration FROM operations WHERE status = 'active' GROUP BY sacado_id. No index on status. Full table scan. Runs every 15 minutes for dashboard refresh."
		recommendation: "(1) Don't scale up. Optimize query first. (2) Add index: CREATE INDEX idx_operations_status ON operations (status) WHERE status = 'active' (partial index — only indexes active operations). Impact: query scans index instead of full table. Time: 8s → 0.2s. CPU: 40% → 2%. (3) Add materialized view: CREATE MATERIALIZED VIEW concentration_summary AS (SELECT ...). REFRESH every 15 minutes (or on operation state change). Dashboard reads materialized view: O(sacados) instead of O(operations). (4) Post-optimization: CPU drops from 75% to ~37%. Instance handles 2x more volume before next scaling trigger. (5) Cost: R$0 (index + materialized view are free). Time: 2 hours. vs scaling: R$300/month additional ongoing. (6) ROI: 2 hours of work saves R$300/month = R$3.600/year. ROI: immediate. (7) If after optimization CPU still >70%: THEN scale. But optimize first — always. (8) Add to CLAUDE.md: 'when database performance degrades: first check pg_stat_statements for slow queries. Optimize (index, materialized view, query rewrite) before scaling instance. Document optimization in ADR.'"
		principlesApplied: ["ax-01", "ax-03"]
		assumptions: [
			"partial index on status='active' significantly reduces scan — yes, if 80% of operations are non-active",
			"materialized view refresh every 15 min is acceptable latency for concentration dashboard — for dashboard: yes",
			"2 hours of optimization work is feasible — for developer/agent: straightforward PostgreSQL optimization",
			"CPU will drop from 75% to ~37% — validate with actual measurement post-optimization",
		]
		rationale: "Optimize before scale. Index (R$0, 2h work) reduces query from 8s to 0.2s, CPU from 75% to 37%. Scaling instance (R$300/month): masks the problem without solving it. At next growth point: same query will be slow again, requiring yet another scale-up. Optimization: solves the problem permanently."
	},
]

principleIds: ["ax-01", "ax-03", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-pricing-and-monetization-architecture"
		relation: "complementsWith"
		context:  "PM defines revenue side: how much to charge per operation, what pricing model. IC defines cost side: how much each operation costs to process. Together: unit economics — revenue per op (PM) vs cost per op (IC). PM says 'charge R$125/op via spread capture'; IC says 'costs R$5/op to process.' Margin: R$120. Both needed for viability assessment."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA identifies founder time as constraint. IC builds on: managed services buy back constraint time (build vs buy). IC right-sizing prevents: founder debugging over-provisioned infrastructure instead of building product. ORA says 'protect constraint time'; IC says 'managed services are how you buy time.'"
	},
	{
		lensId:   "lens-ml-ai-systems-design"
		relation: "complementsWith"
		context:  "ML defines model selection, training, deployment. IC adds cost dimension: model selection includes cost per inference. ML says 'Model B has higher AUROC'; IC says 'Model B costs 25x more — is the accuracy improvement worth it?' Cost-constrained model selection."
	},
	{
		lensId:   "lens-technical-debt-as-strategic-instrument"
		relation: "complementsWith"
		context:  "TD covers when to accept technical debt for speed. IC adds: over-engineering (premature scaling, expensive infrastructure) is a form of cost debt — paying for capacity you don't use. Right-sizing is debt-free: pay for what you need. Over-provisioning: debt that manifests as monthly bill."
	},
	{
		lensId:   "lens-distributed-systems-design"
		relation: "complementsWith"
		context:  "DSD defines distributed patterns (microservices, event broker, replicas). IC adds cost reality: each distributed component is a cost center. Monolith: 1 cost center. 5 microservices + Kafka + Redis: 7 cost centers. IC says 'each component must justify its cost at current volume.'"
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI defines monitoring infrastructure. IC evaluates monitoring cost: Datadog R$500/month vs Grafana free. OOI says 'monitor everything'; IC says 'monitor what matters within cost budget.' Together: adequate observability at appropriate cost."
	},
	{
		lensId:   "lens-data-modeling-for-analytical-power"
		relation: "complementsWith"
		context:  "DM defines analytical data model (semantic layer, aggregations). IC evaluates cost: analytical queries can be super-linear if not optimized. Materialized views: trade storage for compute. IC says 'optimize analytical queries before scaling database.'"
	},
]

limitations: [
	{
		description: "Cost estimates for AI inference change rapidly as model pricing evolves (prices have decreased 90%+ in 2 years)."
		alternative: "Review cost assumptions quarterly. Don't optimize for today's prices if prices are falling rapidly — optimization ROI may be short-lived. Focus on: architecture that enables cost optimization (tiered inference, caching) rather than specific price optimization."
		rationale: "Optimize architecture (tiered, cached) not specific prices. Architecture persists; prices change."
	},
	{
		description: "Cost per operation metric can be misleading if operations have very different complexity (simple antecipação vs complex due diligence)."
		alternative: "Segment cost per operation type. Simple antecipação: R$0,10/op. Complex due diligence: R$5,00/op. Blended: misleading. Per-type: actionable. Revenue also segmented: simple has lower spread, complex has higher."
		rationale: "Segmented metrics > blended averages for decision-making."
	},
	{
		description: "Free-tier reliance creates risk: provider changes terms, free tier is removed, or limits change without notice."
		alternative: "For each free-tier dependency: documented migration path to paid tier or alternative. 'If Grafana Cloud free tier is removed: migrate to self-hosted Grafana (8h effort, R$50/month) or paid tier (~R$50/month).' Risk: managed, not eliminated."
		rationale: "Free tier is not permanent. Migration path documented = risk managed."
	},
	{
		description: "Opportunity cost of founder time is estimated (R$250/h) — actual value varies and is hard to measure."
		alternative: "Use as directional, not precise. R$250/h means: 4h on infrastructure ops = R$1.000 opportunity cost. Managed service at R$200/month: clearly worth it. At R$2.000/month: less clear. Use for order-of-magnitude decisions, not precise accounting."
		rationale: "Opportunity cost is imprecise but directionally correct. R$250/h founder time >> R$200/month managed service."
	},
	{
		description: "Cost optimization at early stage (50-100 ops) saves small absolute amounts (R$100-200/month) — effort may not justify savings."
		alternative: "At early stage: don't micro-optimize. Right-size (avoid gross over-provisioning) but don't spend 8h saving R$50/month (ROI: 6 months). Focus on: avoiding premature scaling (saves R$1.000+/month) and building cost discipline that scales. Monthly 30-min review: sufficient."
		rationale: "Early stage: avoid waste (premature scaling), don't micro-optimize. Discipline now: pays at scale."
	},
]

rationale: "Se a Mesh consome mais em infraestrutura do que gera em receita: morre. Na Mesh como B2B fintech AI-native com solo founder, esta lens operacionaliza: custo por operação como métrica fundamental de viabilidade (fully-loaded cost 2023+, cost-revenue threshold 2024+, cost scaling curve 2024+), economia de inference de IA com tiered approach (inference cost spectrum 2024+, model selection by task value 2024+, tiered inference 2024+), right-sizing proporcional ao volume real (premature scaling 2023+, headroom budgeting 2024+, managed vs self-hosted 2024+), modelo de escalabilidade de custo com constant/step/linear/super-linear (cost model per component 2024+), build vs buy por capability gap e TCO (TCO 2024+, capability gap 2024+), detecção de anomalias de custo com alertas e attribution (cost alerting 2023+, cost attribution 2024+), otimização de database antes de scaling (query optimization, indexing, partitioning, materialized views), e decisões de arquitetura com cost impact obrigatório no ADR (cost as architectural requirement 2024+, cost-performance pareto 2024+). Na Mesh, unit economics são dominados por receita (R$125/op vs R$5 custo/op) — infraestrutura não é risco existencial. Mas cost discipline estabelecida early: previne waste e demonstra viabilidade para investidores."

}
