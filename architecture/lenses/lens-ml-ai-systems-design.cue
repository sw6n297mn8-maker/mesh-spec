package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

mlAiSystemsDesign: artifact_schemas.#AnalyticalLens & {
id:     "lens-ml-ai-systems-design"
name:   "Design de Sistemas de ML e IA"

purpose: "Orientar decisões sobre como projetar sistemas de ML/IA em produção — training, serving, monitoring, feedback loops e model lifecycle."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como projetar pipelines de ML para treinamento, validação e deploy de modelos em produção",
		"a decisão envolve como garantir que modelos em produção mantêm performance ao longo do tempo (monitoring, retraining)",
		"a decisão envolve como gerenciar o lifecycle de modelos — do experimento ao deploy ao retirement",
		"a decisão envolve como integrar agentes de IA (LLMs) com modelos de ML especializados (scoring, pricing)",
		"a decisão envolve como projetar avaliação e validação de outputs de LLMs em contexto de negócio",
		"a decisão envolve como gerenciar prompts como artefatos versionados e testáveis",
		"a decisão envolve trade-offs entre modelos simples (interpretáveis, auditáveis) e modelos complexos (mais precisos)",
		"a decisão envolve como implementar human-in-the-loop para decisões de ML com impacto financeiro ou regulatório",
		"a decisão envolve como projetar feedback loops entre decisões de modelos e outcomes reais para aprendizado contínuo",
		"a decisão envolve como implementar A/B testing ou shadow mode para validar novos modelos antes de deploy completo",
		"a decisão envolve como lidar com fairness, bias e explicabilidade de modelos em contexto regulado",
	]
	keywords: [
		"machine learning", "ML", "modelo", "model",
		"treinamento", "training", "inference", "inferência",
		"pipeline de ML", "MLOps", "ML pipeline",
		"deploy de modelo", "model serving", "model deployment",
		"monitoring de modelo", "model drift", "data drift", "concept drift",
		"retraining", "retreinamento", "model refresh",
		"feature engineering", "feature pipeline",
		"LLM", "large language model", "agente de IA", "AI agent",
		"prompt engineering", "prompt management", "prompt versioning",
		"scoring model", "credit scoring", "risk model",
		"A/B test de modelo", "shadow mode", "canary deploy",
		"explicabilidade", "interpretabilidade", "SHAP", "LIME",
		"fairness", "bias", "discriminação algorítmica",
		"feedback loop", "closed loop", "learning from outcomes",
		"model registry", "experiment tracking", "MLflow",
		"evaluation", "eval", "benchmark", "golden dataset",
		"RAG", "retrieval augmented generation", "grounding",
	]
	excludeWhen: [
		"a decisão é sobre feature store e modelagem dimensional — usar data-modeling-for-analytical-power",
		"a decisão é sobre dados como moat competitivo e data flywheel — usar data-quality-as-competitive-moat",
		"a decisão é sobre governance de agentes IA (autonomia, escalation, audit trail) — usar ai-agent-governance",
		"a decisão é sobre risco de crédito e métricas de scoring (AUROC, inadimplência) — usar credit-risk",
		"a decisão é sobre observabilidade de sistemas em produção — usar observability-operational-intelligence",
	]
	rationale: "Toda organização que usa ML/IA em decisões de negócio precisa de sistemas confiáveis de treinamento, deploy, monitoring e lifecycle management. Na Mesh como intermediário financeiro AI-native, ML opera em decisões consequentes — scoring de crédito (aprovar ou rejeitar antecipação), pricing (definir taxa), qualificação de fornecedores, detecção de anomalias. LLMs operam como agentes que executam tarefas operacionais sob governance (aag). A coexistência de modelos de ML especializados (scoring) e LLMs generalistas (agentes) é central à arquitetura — cada um com lifecycle, validação e monitoring diferentes. AAG cobre governance de agentes (autonomia, escalation); CR cobre métricas de risco; DM cobre feature store; esta lens cobre o sistema de ML/IA como engenharia — como modelos são treinados, validados, deployed, monitorados e evoluídos de forma confiável."
}

concepts: [
	{
		id:         "ml-ml-lifecycle"
		name:       "ML Lifecycle: Do Experimento ao Produção ao Retirement"
		nature:     "theoretical"
		role:       "framework"
		definition: "Sculley et al. (2015, 'Hidden Technical Debt in Machine Learning Systems'): código de ML é fração mínima do sistema — a maioria é infraestrutura de dados, serving, monitoring e configuração. ML lifecycle fases: (1) problem framing — definir o que modelo prediz e por que importa. (2) data preparation — coletar, limpar, feature engineering. (3) experimentation — treinar múltiplos modelos, comparar métricas. (4) validation — avaliar em dados held-out, testar fairness. (5) deployment — mover modelo para produção (serving). (6) monitoring — acompanhar performance com dados reais. (7) retraining — retreinar quando performance degrada. (8) retirement — descontinuar modelo obsoleto. Conceito contemporâneo de 'MLOps' (Google 2020, MLOps maturity model): aplicar DevOps a ML — CI/CD para modelos, infra as code para pipelines, monitoring automatizado. 3 níveis de maturidade: Level 0 (manual), Level 1 (pipeline automatizado), Level 2 (CI/CD de pipeline). Conceito de 'ML system design vs ML model design' (Huyen 2022, Designing Machine Learning Systems): model é o algoritmo; system é tudo ao redor — data pipeline, feature store, serving, monitoring, feedback loops. System >> model em complexidade e impacto."
		meshManifestation: "Na Mesh, modelos de ML em produção ou planejados: (1) scoring model — prediz probabilidade de default de comprador. Input: features do comprador (dm-feature-store). Output: score (0-100) + confidence. Consequência: aprovação/rejeição de antecipação + taxa. Lifecycle completo: experiment → validate → deploy → monitor → retrain. (2) pricing model — define taxa de antecipação dado risco e condições de mercado. Input: score, prazo, valor, condições macro. Output: taxa sugerida. (3) anomaly detection — detecta operações ou comportamentos fora do padrão. Input: features de operação. Output: anomaly score + flag. (4) document validation — classifica e valida documentos submetidos por fornecedores. Input: documento (PDF/imagem). Output: tipo, validade, campos extraídos. (5) supplier matching — recomenda fornecedores para construtoras. Input: necessidades da construtora + profile de fornecedores. Output: ranking de fornecedores. Cada modelo tem lifecycle próprio com cadência de retraining, métricas de monitoring, e critérios de retirement diferentes."
		meshImplication: "Para cada modelo: documentar lifecycle completo: (1) model card (Mitchell et al. 2019): nome, objetivo, métricas, dados de treinamento, limitações conhecidas, fairness considerations, owner, version, date. Artefato no mesh-spec. (2) pipeline de treinamento como código — reproduzível, versionado, testável. Não notebook ad hoc. (3) validation gate antes de deploy — modelo novo só vai para produção se: (a) métricas > threshold (AUROC > 0.70 para scoring), (b) fairness test passa, (c) shadow mode validado. (4) deployment strategy — shadow mode primeiro (modelo roda em paralelo sem afetar decisão), depois canary (% pequeno do tráfego), depois full rollout. (5) monitoring contínuo — métricas de performance, drift de dados, drift de conceito (ml-monitoring-drift). (6) retraining trigger — quando performance degrada abaixo do threshold ou quando volume de dados novos justifica. (7) retirement — modelo obsoleto desativado com rollback plan. (8) experiment tracking — MLflow ou equivalente para registrar experimentos com hiperparâmetros, métricas, artifacts. Proporcional ao estágio: pré-revenue, notebook + scripts versionados + MLflow local. Tração: pipeline automatizado. Escala: CI/CD de pipeline (MLOps Level 2)."
		rationale: "Sculley et al. 2015: hidden technical debt. Google 2020: MLOps maturity. Huyen 2022: ML system design. Mitchell et al. 2019: model cards. Na Mesh, scoring model decide se R$80k de antecipação é aprovada — o lifecycle não pode ser ad hoc. Pipeline reproduzível, validation gate, shadow mode e monitoring são o que transforma 'modelo no notebook' em 'sistema confiável em produção'."
	},
	{
		id:         "ml-monitoring-drift"
		name:       "Monitoring e Drift: Detectar Quando o Modelo Deixa de Funcionar"
		nature:     "theoretical"
		role:       "method"
		definition: "Conceito de 'model decay' — modelos treinados em dados históricos degradam quando a distribuição dos dados muda. Três tipos de drift: (1) data drift (covariate shift) — distribuição dos inputs muda (faturamento médio dos compradores subiu 30% por inflação). Modelo não viu essa distribuição no treinamento. (2) concept drift — relação entre inputs e target muda (antes, comprador com faturamento >R$500k era low risk; após crise no setor, não mais). Modelo aprendeu relação obsoleta. (3) prediction drift — distribuição dos outputs muda (modelo aprova 60% antes, agora aprova 80% — por que?). Pode indicar data drift ou concept drift. Conceito contemporâneo de 'ML monitoring as first-class concern' (Huyen 2022, EvidentlyAI 2021+, Arize 2022+, WhyLabs 2022+): ferramentas dedicadas a ML monitoring — detectam drift, track performance, alert on degradation. Não usar apenas métricas de software (latência, error rate) — precisa de métricas de ML (AUROC, precision, recall, feature distributions, prediction distributions). Conceito de 'ground truth delay' (2023+): em muitos problemas, ground truth (o comprador realmente defaultou?) só está disponível semanas ou meses depois da predição. Monitoring sem ground truth: usar proxies — prediction drift, feature drift, confidence distribution."
		meshManifestation: "Na Mesh, drift scenarios: (1) data drift — pós-pandemia, faturamento médio dos compradores caiu 20%. Features financeiras mudaram distribuição. Scoring model treinado com dados pré-crise vê distribuição que nunca viu — scores podem ser erráticos. (2) concept drift — setor de construção entra em recessão. Compradores que antes pagavam em dia começam a atrasar. Relação features → default mudou. Modelo mantém AUROC alto em dados antigos mas performance real degrada. (3) prediction drift — modelo v2 aprovando 75% das operações vs 60% do v1. Se real default rate subiu: v2 está over-approving. Se default rate está estável: v2 é melhor. Diferenciar requer ground truth. (4) ground truth delay — antecipação aprovada hoje, pagamento vence em 60 dias. Ground truth (pagou ou defaultou) disponível em D+60 a D+120. Durante 60-120 dias: monitoring sem ground truth."
		meshImplication: "Monitoring em 3 camadas: (1) real-time (sem ground truth) — feature drift: distribuição de cada feature de input comparada com distribuição de treinamento. Se KL divergence ou PSI > threshold: alerta. Prediction drift: distribuição de scores comparada com histórico. Se mean score mudou >10%: investigar. Confidence distribution: se modelo está mais incerto (confidence drops): investigar. Ferramenta: EvidentlyAI ou custom com Great Expectations. Cadência: diário. (2) delayed (com ground truth parcial) — quando pagamento vence e outcome é observado: calcular métricas reais (AUROC, precision, recall, calibration). Comparar com métricas de treinamento. Se AUROC cai >0.03: alerta. Cadência: mensal (à medida que ground truth acumula). (3) periodic deep review — retreinar modelo com dados recentes e comparar com modelo em produção. Se modelo retreinado performa significativamente melhor: deploy modelo novo. Se performa igual: modelo atual ainda é válido. Cadência: trimestral. Para cada alerta de drift: (a) investigar causa (mudança de mercado, data quality issue, bug no pipeline). (b) decidir ação (retreinar, ajustar threshold, revert para modelo anterior). (c) documentar em ADR. Anti-pattern: deploy de modelo sem monitoring — modelo degrada silenciosamente por 6 meses enquanto aprova operações com risco real muito maior do que estimado."
		dependsOn: ["ml-ml-lifecycle"]
		crossDependsOn: [{
			lensId:    "lens-credit-risk"
			conceptId: "cr-model-monitoring"
			context:   "CR define métricas de monitoring de scoring (AUROC, PSI, calibration). ML define o sistema de monitoring — como métricas são coletadas, como drift é detectado, como alertas são gerados, como retraining é triggered. CR é 'o que monitorar'; ML é 'como monitorar'. CR diz 'AUROC caiu 0.04'; ML diz 'data drift detectado em feature faturamento_mensal, retraining triggered automaticamente'."
		}]
		rationale: "Huyen 2022: monitoring como first-class concern. EvidentlyAI/Arize/WhyLabs 2021+/2022+: ML monitoring tools. Ground truth delay 2023+. Na Mesh, scoring model que degrada silenciosamente é risco financeiro direto — cada operação aprovada com score inflado é perda potencial. Monitoring em 3 camadas (real-time sem ground truth, delayed com ground truth, periodic deep review) cobre o espectro."
	},
	{
		id:         "ml-validation-strategy"
		name:       "Estratégia de Validação: Provar que o Modelo Funciona Antes de Afetar Decisões Reais"
		nature:     "theoretical"
		role:       "method"
		definition: "Validação de ML vai além de train/test split: (1) offline validation — métricas em dados held-out (AUROC, precision, recall, calibration, fairness). (2) backtesting — replay de dados históricos com modelo novo (conecta com eda-replay-temporal-queries). 'Se modelo v2 existisse 6 meses atrás, quais decisões teriam sido diferentes? Essas decisões teriam sido melhores?' (3) shadow mode — modelo novo roda em paralelo com modelo em produção. Ambos recebem mesmos inputs. Modelo novo não afeta decisões. Comparar outputs: v2 aprova mais? Menos? Para os mesmos casos? (4) canary deployment — modelo novo serve % pequeno do tráfego real. Monitorar métricas do canary vs controle. Se métricas do canary são melhores ou equivalentes: ampliar. Se piores: rollback. (5) A/B testing — quando ground truth está disponível, comparar outcomes reais de modelo A vs B. Conceito contemporâneo de 'online evaluation for ML' (2023+): avaliação contínua em produção — não apenas antes do deploy. Inclui: holdout sets renovados, interleaving experiments, bandit approaches. Conceito de 'evaluation-driven development' (2024+): para LLMs, evaluation é o bottleneck — não treinamento. Eval suites com golden datasets, automated judges (LLM-as-judge), e human review."
		meshManifestation: "Na Mesh, validação por tipo de modelo: (1) scoring — offline: AUROC, precision@recall=0.90, calibration (score de 70 → ~30% default rate real?). Backtesting: replay de 6 meses de operações com modelo novo — quantas decisões mudariam? Para decisões que mudariam: outcome real (default ou not) sugere que novo modelo é melhor ou pior? Shadow mode: v2 roda por 30 dias em paralelo. Comparar distribuição de scores. Se v2 é mais discriminante (mais 0s e 100s, menos 50s): potencialmente melhor. Canary: 10% do tráfego por 2 semanas. Ground truth em 60-120 dias. (2) document validation — golden dataset de 200 documentos manualmente classificados. Accuracy, precision, recall por tipo de documento. (3) anomaly detection — golden dataset de anomalias conhecidas + operações normais. Precision (poucos falsos positivos), recall (poucas anomalias missed). (4) LLM agents — eval suite com cenários predefinidos (golden inputs → expected outputs). LLM-as-judge para quality scoring. Human review para 5% das decisões."
		meshImplication: "Para cada modelo, validation pipeline: (1) offline validation gate — antes de qualquer deploy: métricas em test set. Threshold: scoring AUROC > 0.70, calibration error < 0.05. Se não atinge: não deploy. (2) backtesting — para scoring: replay de 6 meses de events com modelo novo (eda-replay-temporal-queries). Comparar decisões e outcomes. Report: '12 operações que v1 aprovou e v2 rejeitaria — 8 dessas defaultaram. v2 seria melhor.' Backtesting é a validação mais convincente porque usa dados reais. (3) shadow mode (obrigatório para scoring e pricing) — 30 dias mínimo. Output de shadow model é logged mas não usado. Comparar com modelo em produção. Se shadow é significativamente diferente: investigar por que antes de decidir qual é melhor. (4) canary (obrigatório para scoring) — 10% do tráfego por 2 semanas mínimo. Rollback automático se métricas degradam >X%. (5) A/B testing quando ground truth disponível — comparar default rates entre modelo A e B. Requer volume suficiente para significância estatística. (6) para LLM agents — eval suite com 50+ cenários gold. Rodar antes de cada update de prompt ou modelo. LLM-as-judge para escala + human review para validação. Pass rate > 95% para deploy. Anti-pattern: deploy direto de notebook para produção sem shadow mode — se modelo tem bug ou bias, toda a operação é afetada."
		dependsOn: ["ml-ml-lifecycle"]
		crossDependsOn: [{
			lensId:    "lens-event-driven-architecture-patterns"
			conceptId: "eda-replay-temporal-queries"
			context:   "EDA replay permite temporal queries — reconstruir estado do sistema em qualquer ponto no tempo. ML backtesting usa replay para simular modelo novo contra dados históricos. EDA provê o mecanismo (replay de eventos); ML define o uso (backtesting de modelo). Sem event sourcing: backtesting requer snapshot manual de features a cada decisão. Com: replay nativo."
		}]
		rationale: "Shadow mode, canary, backtesting 2023+: validation como pipeline, não como passo. Evaluation-driven development 2024+: para LLMs. Na Mesh, scoring decide se R$80k é aprovado — validation pipeline rigoroso (offline → backtesting → shadow → canary) é o que previne que modelo bugado ou biased afete operações reais."
	},
	{
		id:         "ml-model-interpretability"
		name:       "Interpretabilidade e Explicabilidade: Por Que o Modelo Decidiu Isso?"
		nature:     "theoretical"
		role:       "property"
		definition: "Rudin (2019, 'Stop Explaining Black Box Machine Learning Models'): em decisões consequentes (crédito, saúde, justiça), usar modelos interpretáveis por design (logistic regression, decision trees, scorecards) é preferível a modelos opacos (deep learning) com explicações post-hoc (SHAP, LIME). Modelo interpretável: humano pode entender diretamente como inputs se relacionam com output. Modelo opaco + explicação: humano vê aproximação da lógica real — explicação pode ser imprecisa. Lundberg/Lee (2017, SHAP): SHapley Additive exPlanations — método de explicabilidade baseado em teoria dos jogos que atribui importância a cada feature para cada predição individual. Global explanations (feature importance para o modelo inteiro) e local explanations (por que esta predição específica). Conceito contemporâneo de 'explainability for regulated industries' (EBA 2020, Bacen Resolução 403/2024): reguladores de crédito exigem explicabilidade — devedor tem direito de saber por que foi rejeitado. 'Seu score é 45' não é suficiente; 'fatores que mais contribuíram: histórico de atraso de pagamento, concentração de dívida' é exigido. Conceito de 'tiered interpretability' (2023+): diferentes stakeholders precisam de diferentes níveis — regulador precisa de explicação completa, fornecedor precisa de razão simples, data scientist precisa de SHAP values por feature."
		meshManifestation: "Na Mesh, explicabilidade por stakeholder: (1) fornecedor — 'sua antecipação foi rejeitada porque o comprador tem histórico recente de atraso (fator principal) e alta concentração de dívida.' Linguagem simples, top 2-3 fatores, sem números técnicos. (2) gestor FIDC — 'carteira tem concentração em compradores com score médio 65 — risk factors: 40% do risco vem de histórico de pagamento, 25% de faturamento, 20% de diversificação de fornecedores.' Feature importance agregada. (3) regulador — explicação completa: modelo type (gradient boosting), features usadas (lista completa), SHAP values para decisões auditadas, fairness metrics, model card. (4) data scientist/agente — SHAP waterfall plot por predição, feature importance global, partial dependence plots, correlation analysis."
		meshImplication: "Estratégia de interpretabilidade em 2 camadas: (1) modelo interpretável quando possível — para scoring v1: logistic regression ou scorecard. Interpretabilidade por design. Cada coeficiente é diretamente explicável: 'atraso de pagamento aumenta risco em X pontos.' Adequado para pré-revenue (modelo simples, poucos dados, compliance straightforward). (2) modelo opaco + explicação quando necessário — para scoring v2+ com features complexas: gradient boosting (XGBoost, LightGBM) com SHAP explanations. Performance superior justifica opacidade se explicação está disponível. SHAP obrigatório para cada predição: top-N features com impacto positivo/negativo no score. (3) tiered explanations: (a) fornecedor — template: 'Sua solicitação foi [aprovada/rejeitada]. Fatores principais: [top 2-3 em linguagem natural].' Gerado automaticamente a partir de SHAP. (b) FIDC — report de feature importance agregada por período. (c) regulador — model card + SHAP analysis completa para operações auditadas. (d) interno — MLflow com all metrics, plots, feature importances. (4) armazenar explicação com decisão — cada ScoreCalculated event inclui: score, features usadas, model_version, top_shap_features (top 5 features com SHAP values). Immutável no event log. Se regulador pergunta 'por que esta operação foi aprovada 6 meses atrás': replay + explicação preservada. (5) fairness como parte de explicabilidade — se modelo rejeita desproporcionalmente fornecedores de certo segmento ou região: SHAP revela se feature proxy está causando discriminação. Anti-pattern: modelo opaco sem explicação em produção para decisão de crédito — viola regulação e impede diagnóstico quando modelo erra."
		dependsOn: ["ml-ml-lifecycle"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-audit-trail"
			context:   "AAG define audit trail para decisões de agentes — reconstituir qualquer decisão com todos os dados e context. ML interpretabilidade gera o conteúdo do audit trail para decisões de ML: score + features + SHAP values + model_version. AAG é o framework (toda decisão tem trail); ML é a implementação para decisões de modelo (trail inclui explicação do modelo)."
		}]
		rationale: "Rudin 2019: interpretable models preferíveis. Lundberg/Lee 2017: SHAP. EBA 2020, Bacen 2024: explicabilidade regulatória. Tiered interpretability 2023+. Na Mesh, scoring de crédito é decisão regulada — fornecedor tem direito de saber por que foi rejeitado, regulador exige explicação, e FIDC precisa entender risco. Explicabilidade não é nice-to-have."
	},
	{
		id:         "ml-llm-integration"
		name:       "Integração de LLMs: Agentes Generalistas com Modelos Especializados"
		nature:     "theoretical"
		role:       "framework"
		definition: "Na Mesh, dois tipos de IA coexistem: (1) modelos especializados (ML clássico) — scoring, pricing, anomaly detection. Treinados em dados da Mesh, task-specific, determinísticos ou quasi-determinísticos, métricas claras (AUROC, precision). (2) LLMs generalistas — agentes que executam tarefas operacionais (validar documentos, qualificar fornecedores, comunicar com stakeholders, analisar dados). Pré-treinados, adaptados via prompt engineering e RAG, probabilísticos, métricas de avaliação menos definidas. Conceito contemporâneo de 'compound AI systems' (Zaharia et al. 2024, 'The Shift from Models to Compound AI Systems'): sistemas de IA modernos não são um único modelo — são composição de múltiplos modelos, retrievers, tools, e lógica programática. Scoring pipeline: LLM extrai dados de documento → feature store fornece features → ML model calcula score → LLM gera explicação em linguagem natural → governance layer valida. Conceito de 'LLM as orchestrator' (2024+): LLM como camada que coordena — decide qual tool/model invocar, interpreta resultado, e compõe resposta. Diferente de ML model que faz uma predição pontual: LLM orquestra workflow multi-step."
		meshManifestation: "Na Mesh, compound AI system: (1) fluxo de antecipação — agente LLM recebe solicitação → LLM valida completude de documentos → ML model de document classification classifica tipos → LLM extrai campos relevantes (OCR + NLP) → feature store fornece features do comprador → ML scoring model calcula score → LLM interpreta score e features para gerar razão de aprovação/rejeição → governance layer valida decisão contra policies. (2) qualificação de fornecedor — agente LLM analisa documentos de compliance → ML model verifica autenticidade → LLM sintetiza análise em report de qualificação → governance valida. (3) comunicação com stakeholder — LLM gera investor update a partir de métricas (dm-semantic-layer) + template + context. (4) análise exploratória — agente LLM consulta dados analíticos (dm) para responder perguntas de negócio ad hoc. Em cada caso: LLM é o orquestrador; ML models são tools especializados que o LLM invoca."
		meshImplication: "Projetar a integração em 3 camadas: (1) ML models como tools — cada modelo de ML é exposto como tool invocável: endpoint com input schema, output schema, latency SLO. Scoring model: input = buyer_id, output = {score, confidence, top_shap_features}. Document classifier: input = document_bytes, output = {type, confidence, extracted_fields}. LLM invoca tools conforme necessidade do workflow. (2) LLM como orquestrador — LLM decide qual tool invocar, em que ordem, e como interpretar resultados. Orquestração definida por prompt + context + policies (governance). LLM não 'inventa' score — invoca scoring tool e interpreta resultado. (3) governance layer como guardrail — entre LLM decision e action: governance valida contra policies (aag-autonomy-boundary). Se LLM sugere aprovar operação com score 45 (abaixo do threshold 60): governance bloqueia e escala. Governance opera sobre outputs de ML models e decisões de LLM. Para cada integração: (a) interface clara entre LLM e ML — schema de input/output documentado. LLM não pode 'modificar' output de ML model (ex: não pode 'ajustar' score). (b) responsabilidade — ML model é responsável pela predição; LLM é responsável pela interpretação e orquestração; governance é responsável pela validação. Se decisão é questionada: qual camada errou? (c) fallback — se ML model falha (timeout, error): LLM não adivinha. Escala para human ou aplica policy conservadora. (d) latency budget — fluxo end-to-end tem latency budget (ex: 5s para decisão de scoring). Alocar: feature fetch 200ms + ML inference 100ms + LLM orchestration 2s + governance 100ms = 2.4s. Margem. Anti-pattern: LLM que 'calcula score' sem invocar scoring model — hallucination de score é catastrófico em decisão financeira."
		dependsOn: ["ml-ml-lifecycle", "ml-model-interpretability"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-autonomy-boundary"
			context:   "AAG define boundaries de autonomia de agentes — o que podem decidir sozinhos e o que escala. ML-LLM integration implementa: LLM como orquestrador opera dentro de boundaries. Se ML model retorna score abaixo do threshold: boundary é triggered, decisão escala. AAG é o framework de boundaries; ML-LLM integration é a arquitetura que implementa dentro do compound AI system."
		}]
		rationale: "Zaharia et al. 2024: compound AI systems. LLM as orchestrator 2024+. Na Mesh AI-native, a separação LLM (orquestrador) + ML (tools especializados) + governance (guardrail) é a arquitetura que combina flexibilidade do LLM com precisão do ML e segurança da governance. LLM não calcula score; ML calcula. LLM não decide sozinho; governance valida."
	},
	{
		id:         "ml-prompt-management"
		name:       "Gestão de Prompts: Prompts como Artefatos de Engenharia Versionados e Testáveis"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Conceito contemporâneo de 'prompt engineering as software engineering' (2023+): prompts que controlam LLMs em produção são código — devem ser versionados, testados, reviewed, e deployed com o mesmo rigor de software. Prompt change pode causar regression tão grave quanto code change. Conceito de 'prompt testing' (2024+, PromptFoo, Braintrust, HumanLoop): frameworks para testar prompts com datasets de avaliação. Para cada prompt: golden dataset de (input, expected_output). Test: rodar prompt com inputs, comparar outputs com expected. Métricas: accuracy, consistency, safety, adherence to format. Conceito de 'prompt decomposition' (2024+): prompts complexos decompostos em componentes reutilizáveis — system prompt (papel do agente), task prompt (o que fazer agora), context (dados relevantes), constraints (policies e boundaries). Cada componente versionado independentemente. Conceito de 'prompt as configuration' no mesh-spec: prompts são artefatos CUE/YAML no repositório, versionados por Git, testáveis por CI."
		meshManifestation: "Na Mesh, prompts em produção: (1) agente de validação de documentos — system prompt define papel ('você é um agente especialista em validação de documentos de construção civil'), task prompt varia por tipo de documento, constraints incluem policies de compliance. (2) agente de qualificação — system prompt define critérios de qualificação, context inclui profile do fornecedor, constraints incluem regulação. (3) agente de comunicação — system prompt define tom e audiência, context inclui métricas e dados, constraints incluem policies de disclosure. (4) agente de análise — system prompt define capacidades analíticas, context inclui dados do query, constraints incluem confidencialidade. Cada prompt é artefato que afeta comportamento do sistema. Prompt change sem teste pode causar: agente que aprova documento inválido, qualificação que perde critério regulatório, comunicação que divulga dado confidencial."
		meshImplication: "Prompts como artefatos no mesh-spec: (1) estrutura — cada agente tem diretório no mesh-spec com: system_prompt.md, task_prompts/ (por tarefa), constraints/ (policies), eval/ (golden datasets). (2) versionamento — Git. Cada change é PR com review. Diff mostra exatamente o que mudou. Rollback é git revert. (3) testing — para cada prompt, eval suite: 20+ cenários gold com input e expected behavior. Rodar eval em CI a cada PR que modifica prompt. Métricas: pass rate (>95% para deploy), regression check (novo prompt não piora cenários que passavam). (4) decomposição — separar system prompt (estável, muda raramente) de task prompt (muda conforme tarefa evolui) de constraints (muda conforme governance evolui). Permite atualizar constraints sem tocar em system prompt. (5) environment promotion — prompt em dev → eval passa → prompt em staging → shadow test → prompt em production. Mesmo rigor de deploy de código. (6) monitoring — para prompts em produção: sample 5% dos outputs e avaliar qualidade (LLM-as-judge ou human review). Se qualidade cai: investigar (modelo mudou? dados mudaram? prompt precisa de update?). (7) prompt-model coupling — quando modelo LLM é atualizado (nova versão de Claude): re-rodar eval suite completa. Novo modelo pode interpretar prompt diferentemente. Anti-pattern: prompt armazenado em variável no código sem versioning, sem testing, sem review — 'alguém mudou o prompt e agora o agente está aprovando documentos inválidos'."
		dependsOn: ["ml-llm-integration"]
		crossDependsOn: [{
			lensId:    "lens-knowledge-management"
			conceptId: "km-knowledge-as-code"
			context:   "KM define knowledge as code — versionado, testável, auditável. Prompts são knowledge as code para agentes — definem como agente raciocina e decide. KM diz 'knowledge deve ser versionado e testável'; ML diz 'prompts são artefatos de engenharia com o mesmo rigor de código'. Prompt no mesh-spec é knowledge codificada sobre como agente opera."
		}]
		rationale: "Prompt engineering as software engineering 2023+. PromptFoo/Braintrust/HumanLoop 2024+: prompt testing frameworks. Prompt decomposition 2024+. Na Mesh AI-native onde agentes operam sob governance, prompts são o mecanismo que traduz policies em comportamento. Prompt sem teste é policy sem enforcement."
	},
	{
		id:         "ml-feedback-loops"
		name:       "Feedback Loops: Aprender com Outcomes Reais para Melhorar Continuamente"
		nature:     "theoretical"
		role:       "property"
		definition: "Conceito de 'closed-loop ML' — modelo faz predição, decisão é tomada, outcome é observado, outcome alimenta retraining. O loop fecha quando outcome real retroalimenta o modelo. Sculley et al. (2015): feedback loops em ML podem ser virtuosos (modelo melhora com outcomes) ou viciosos (modelo cria self-fulfilling prophecies — rejeita quem nunca teve chance de provar que seria bom pagador, reforçando o viés). Conceito contemporâneo de 'causal ML' (Pearl 2018, Imbens/Rubin 2015, 2023+): para aprender com outcomes, é necessário entender causalidade — 'comprador X defaultou porque era de alto risco' ou 'porque reduzimos crédito e ele ficou sem caixa'? Se ação do modelo causa o outcome: loop é enviesado. Conceito de 'selective labels problem' (2019+, Lakkaraju et al.): modelo de scoring só observa outcomes de quem foi aprovado — não sabe o que teria acontecido com quem foi rejeitado. Se modelo rejeita 40% dos compradores: 40% dos outcomes são missing. Treinar apenas com aprovados: survivorship bias."
		meshManifestation: "Na Mesh, feedback loops: (1) scoring → approval → payment outcome → retraining. Loop fecha em 60-120 dias (prazo de pagamento). Score de 78 para comprador X → aprovado → pagou em dia em D+45. Data point positivo. Score de 55 para comprador Y → rejeitado → outcome desconhecido (selective labels). (2) pricing → taxa → volume → inadimplência → pricing adjustment. Taxa alta → menos volume → menos dados → scoring piora → taxa sobe. Loop vicioso potencial. Taxa baixa → mais volume → mais dados → scoring melhora → taxa pode baixar. Loop virtuoso. (3) qualificação → fornecedor qualificado → performance observada → qualificação adjustada. Loop fecha quando performance de entregas é observada. (4) document validation → agente aprova documento → human review sample → feedback para prompt/model. Loop fecha quando human review corrige agente."
		meshImplication: "Projetar feedback loops conscientemente: (1) scoring loop — capturar outcome para toda operação aprovada: pagou? Atrasou? Defaultou? Em quanto tempo? Outcome é label para retraining. Cadência de retraining: quando N outcomes novos acumulam (ex: 50 novos outcomes) E performance degradou. (2) selective labels — para compradores rejeitados: não se sabe o outcome. Mitigações: (a) exploration: aprovar pequena % de casos marginais (score entre 55-65) para observar outcome. Custo: risco real. Benefício: dados que modelo não teria. (b) inverse propensity weighting: ajustar peso de amostras pelo probability de ter sido aprovado — corrige viés de seleção no treinamento. (c) cautious modeling: não generalizar para população rejeitada — modelo é válido para população que seria aprovada. (3) pricing loop — monitorar: taxa está gerando volume suficiente para manter flywheel? Se volume cai: taxa está alta demais? Se inadimplência sobe: taxa está baixa demais? Feedback entre inadimplência real e pricing adjustment deve ser explícito, não implícito. (4) human-in-the-loop feedback — para agentes LLM: human review de 5-10% das decisões. Feedback (correto/incorreto/parcial) alimenta: prompt improvement, eval suite expansion, e edge case identification. (5) anti-feedback-loop vicioso — monitorar: modelo está rejeitando sistematicamente algum grupo? Se sim: grupo nunca tem chance de gerar outcome positivo → modelo nunca aprende que grupo poderia ser low risk → rejection se auto-reforça. Quebrar com exploration ou external data."
		dependsOn: ["ml-monitoring-drift", "ml-validation-strategy"]
		crossDependsOn: [{
			lensId:    "lens-behavioral-economics"
			conceptId: "be-feedback-loops"
			context:   "BE modela como feedback loops comportamentais operam — incentivos geram comportamento que reforça o incentivo. ML feedback loops são análogos: modelo gera decisão que afeta outcome que alimenta modelo. BE diz 'feedback loop pode criar path dependency'; ML diz 'scoring que rejeita sistematicamente cria survivorship bias que reforça a rejeição'. Consciência de BE feedback loops é necessária para projetar ML feedback loops que não se auto-reforçam viciosamente."
		}]
		rationale: "Sculley et al. 2015: feedback loops em ML. Pearl 2018, Imbens/Rubin: causal ML. Selective labels 2019+. Na Mesh, o scoring loop é o mecanismo pelo qual o data flywheel opera — outcome de pagamento retroalimenta modelo. Mas selective labels (só observa quem foi aprovado) e self-fulfilling prophecies (rejeitar reforça rejeição) são riscos reais que devem ser projetados conscientemente."
	},
	{
		id:         "ml-model-simplicity-bias"
		name:       "Viés de Simplicidade: Começar Simples, Complicar com Evidência"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Conceito de 'start simple' (Google Rules of ML 2023, Rule #1): 'Don't be afraid to launch a product with no machine learning. Machine learning is cool, but it requires data.' Regra: resolver o problema com a abordagem mais simples primeiro. Se heurística resolve: não precisa de ML. Se logistic regression resolve: não precisa de gradient boosting. Se gradient boosting resolve: não precisa de deep learning. Cada nível de complexidade adiciona: custo de manutenção, dificuldade de debugging, necessidade de dados, e dificuldade de explicabilidade. Conceito contemporâneo de 'LLM vs classical ML' (2024+): para muitos problemas, LLM pode resolver sem treinamento (zero-shot ou few-shot) mas com custo de inferência alto e explicabilidade baixa. ML clássico requer treinamento mas tem inferência barata e explicabilidade alta. Trade-off: cost of development vs cost of inference vs interpretability. Conceito de 'complexity budget' (2023+): cada decisão de adicionar complexidade ao sistema de ML deve ser justificada por improvement mensurável em métrica de negócio — não por elegância técnica."
		meshManifestation: "Na Mesh, progressão de simplicidade: (1) scoring — v0: regras heurísticas (score bureau > 70 AND valor < 30k AND docs completos → approve). Zero ML. Operable em cold start. v1: logistic regression com 5 features. Interpretável por design. Suficiente se AUROC > 0.70. v2: gradient boosting (XGBoost) com 12 features. Mais preciso. Requer SHAP para explicabilidade. Justificado se AUROC v2 > AUROC v1 + 0.03. v3+: ensemble ou deep learning. Justificado apenas se AUROC improvement > 0.03 e volume justifica complexidade. (2) document validation — v0: checklist manual (humano verifica). v1: regex + heurísticas para extração de campos. v2: LLM para classificação e extração (zero-shot). v3: fine-tuned model para tipos específicos. (3) anomaly detection — v0: regras estáticas (valor > 3 × media → flag). v1: statistical (z-score, IQR). v2: isolation forest. v3: autoencoder."
		meshImplication: "Regra de complexidade: (1) definir baseline com abordagem mais simples. Se baseline é suficiente: parar. 'Suficiente' = atende threshold de métrica de negócio (AUROC > 0.70, accuracy > 0.90, latency < 500ms). (2) para cada incremento de complexidade: justificar com improvement mensurável. 'XGBoost melhora AUROC em 0.05 sobre logistic regression com custo de perder interpretabilidade direta — SHAP compensa, investment justificado.' Se improvement < 0.02: não justifica. (3) custo de complexidade inclui: manutenção (mais hiperparâmetros, mais features, mais infra), debugging (mais opaco), compliance (mais difícil explicar para regulador), retraining (mais dados necessários). (4) para LLM tasks: avaliar se classical ML resolve. Document classification: LLM zero-shot accuracy = 0.92, fine-tuned BERT accuracy = 0.95, custo de inferência LLM = 10x BERT. Se volume é alto: BERT. Se volume é baixo: LLM (custo de dev é menor). (5) complexity budget: para o sistema total, definir budget de complexidade. Se scoring já é XGBoost + SHAP + feature store + monitoring: adicionar mais complexidade neste pipeline tem custo marginal crescente. Investir em melhorar feature quality (dm) ou diversificar dados (dq) pode ter ROI maior que modelo mais complexo. Anti-pattern: deep learning para scoring com 300 operações de dados — overfitting garantido, manutenção cara, explicabilidade zero, e logistic regression provavelmente performa igual."
		dependsOn: ["ml-ml-lifecycle"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-satisficing"
			context:   "ORA define satisficing — 'suficiente' supera 'ótimo' quando custo excede ganho marginal. ML simplicidade é satisficing aplicado a modelos: logistic regression que atinge AUROC 0.72 satisfice quando XGBoost atingiria 0.75 mas com 3x mais complexidade de manutenção. ORA diz 'satisfice'; ML diz 'começar simples, complicar com evidência de improvement mensurável'."
		}]
		rationale: "Google Rules of ML 2023: start simple. LLM vs classical ML 2024+: trade-offs. Complexity budget 2023+. Na Mesh solo founder, cada incremento de complexidade consome constraint. Logistic regression com 5 features que atinge AUROC 0.72 é operável; deep learning que atinge 0.77 com 300 dados é overfitting que ninguém mantém."
	},
	{
		id:         "ml-fairness-and-bias"
		name:       "Fairness e Bias: Garantir que Modelos Não Discriminam"
		nature:     "theoretical"
		role:       "property"
		definition: "Barocas/Hardt/Narayanan (2019, Fairness and Machine Learning): modelos de ML podem aprender e amplificar discriminação presente nos dados — se dados históricos refletem práticas discriminatórias, modelo reproduz. Tipos de bias: (1) historical bias — dados refletem preconceitos passados (setor X historicamente discriminou fornecedores de região Y). (2) representation bias — dados não representam população completa (apenas compradores urbanos no treinamento). (3) measurement bias — proxy variables correlacionam com atributos protegidos (CEP como proxy de renda/etnia). Métricas de fairness: demographic parity (taxas de aprovação iguais entre grupos), equalized odds (taxas de erro iguais entre grupos), individual fairness (indivíduos similares recebem decisões similares). Conceito contemporâneo de 'responsible AI frameworks' (NIST AI RMF 2023, UNESCO 2022, EU AI Act 2024): regulação crescente exigindo fairness assessment, transparency, e accountability para sistemas de IA em decisões consequentes. Bacen Resolução 403/2024: requisitos de transparência e não-discriminação em modelos de crédito."
		meshManifestation: "Na Mesh, riscos de bias: (1) geographic bias — dados de treinamento concentrados em Rio de Janeiro/São Paulo. Modelo pode performar mal para compradores de outras regiões (representation bias). (2) size bias — modelo treinado com construtoras grandes pode discriminar pequenas (features como faturamento alto = low risk pode não se aplicar a micro construtoras que operam diferente). (3) proxy discrimination — features como 'número de consultas no bureau' podem correlacionar com região/renda — usar como feature sem investigar causality pode discriminar. (4) historical bias — se dados de default refletem práticas passadas de crédito discriminatórias do setor: modelo reproduz. (5) supplier qualification — se critérios de qualificação favorecem fornecedores formalizados de grande porte: micro e pequenas empresas informais são sistematicamente excluídas."
		meshImplication: "Fairness como parte obrigatória do validation pipeline: (1) antes de deploy de qualquer modelo: fairness assessment — calcular métricas de fairness por grupos relevantes (região, porte, tempo de CNPJ como proxy de maturidade). Se disparidade > threshold: investigar e mitigar. (2) feature audit — para cada feature: testar correlação com atributos sensíveis (região, porte). Se feature é proxy: avaliar se inclusão é justificada por predictive power vs risco de discriminação (conecta com dq-data-ethics-and-boundaries). (3) regular fairness monitoring — trimestral: calcular taxas de aprovação e default por grupo. Se grupo X tem taxa de rejeição 2x maior que média sem justificativa por risco real: investigar. (4) counterfactual fairness — 'se este comprador fosse de outra região, com todas as outras features iguais, a decisão seria diferente?' Se sim: modelo está usando região (direta ou via proxy). (5) documentation — para cada modelo: seção de fairness no model card com: grupos avaliados, métricas de fairness, limitações conhecidas, mitigações implementadas. (6) Bacen compliance — Resolução 403/2024 exige transparência e não-discriminação. Manter documentação de fairness assessment acessível para regulador. Anti-pattern: 'nosso modelo não usa gênero/raça como feature, então é fair' — proxy features podem discriminar sem usar atributo protegido diretamente."
		dependsOn: ["ml-model-interpretability", "ml-validation-strategy"]
		crossDependsOn: [{
			lensId:    "lens-data-quality-as-competitive-moat"
			conceptId: "dq-data-ethics-and-boundaries"
			context:   "DQ define limites éticos para coleta e uso de dados. ML fairness operacionaliza para modelos: features que são proxy de discriminação são limitadas por DQ ethics e testadas por ML fairness. DQ diz 'não usar CEP como proxy'; ML diz 'feature audit + counterfactual fairness + monitoring regular para garantir que nenhuma feature discrimina via proxy'. DQ é a policy; ML é a implementação técnica."
		}]
		rationale: "Barocas/Hardt/Narayanan 2019: fairness em ML. NIST AI RMF 2023: responsible AI. EU AI Act 2024. Bacen 403/2024: transparência em crédito. Na Mesh, scoring de crédito é decisão regulada com impacto real — rejeição injusta priva fornecedor de crédito que deveria receber. Fairness assessment obrigatório não é compliance checkbox — é ética operacionalizada."
	},
	{
		id:            "ml-ai-systems-review"
		name:          "Revisão de Sistemas de ML/IA: Inventário Periódico de Modelos, Agentes e Saúde"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) model inventory — quantos modelos em produção? Model cards atualizados? (2) monitoring — drift detectado? Performance degradou? Alertas pendentes? (3) validation — shadow mode e canary para modelos novos rodaram? Resultados? (4) interpretability — explicações disponíveis para todas as decisões? Regulador satisfeito? (5) LLM integration — compound system saudável? Latency budget respeitado? (6) prompts — eval suites passando? Prompt changes reviewed? (7) feedback loops — outcomes capturados? Retraining pipeline funcional? Selective labels mitigados? (8) simplicity — algum modelo poderia ser simplificado sem perda significativa? Complexidade justificada? (9) fairness — assessment atualizado? Disparidades detectadas? Mitigações implementadas?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (drift alerts, eval suite pass rate, feature store freshness). Trimestral: macro-revisão com inventário completo."
		meshImplication: "Mensal (30min): scoring drift — PSI e KL divergence dentro do threshold? Alertas pendentes? Prompt eval — pass rate > 95%? Regression em algum cenário? Feature store — freshness SLOs atingidos? Missing values? Model performance — AUROC trend (se ground truth disponível). Trimestral (2h): model inventory — todos os modelos em produção com model card atualizado. Monitoring review — drift events no período, ações tomadas, outcomes. Validation — modelos deployados passaram por shadow mode e canary? Backtesting rodado? Interpretability — explicações preservadas nos events? Regulador satisfeito? LLM integration — compound system latency dentro do budget? Fallback funcionando? Prompt management — changes no período revisados? Eval suite expandida com novos edge cases? Feedback loops — outcomes capturados? Retraining pipeline triggered? Selective labels addressed? Simplicity — algum modelo over-engineered? Poderia simplificar? Fairness — assessment atualizado? Disparidades? Se revisão não identifica pelo menos uma ação: ou sistemas de ML são perfeitos (improvável) ou revisão é superficial."
		dependsOn: ["ml-ml-lifecycle", "ml-monitoring-drift", "ml-validation-strategy", "ml-model-interpretability", "ml-llm-integration", "ml-prompt-management", "ml-feedback-loops", "ml-model-simplicity-bias", "ml-fairness-and-bias"]
		rationale: "Sem revisão periódica, modelos degradam, prompts desatualizam, fairness não é monitorado, e feedback loops ficam abertos. O inventário periódico mantém sistemas de ML/IA saudáveis e alinhados com requisitos de negócio e regulação."
	},
]

reasoningProtocol: [
	{
		question:  "Este modelo tem lifecycle documentado — model card, pipeline reproduzível, validation gate, monitoring, retraining trigger, retirement criteria?"
		reveals:   "Se o modelo é gerenciado como sistema — ou se é notebook ad hoc que ninguém sabe como foi treinado."
		rationale: "Sculley et al. 2015: ML system >> ML model. Modelo sem lifecycle é dívida técnica que se materializa como decisão errada em produção."
	},
	{
		question:  "O modelo em produção está sendo monitorado para drift (data, concept, prediction)? Ground truth delay é endereçado com proxies?"
		reveals:   "Se degradação é detectada proativamente — ou se modelo performa mal por meses sem que ninguém saiba."
		rationale: "Huyen 2022: monitoring como first-class. Ground truth delay 2023+. Na Mesh com D+60-120 para outcome: monitoring sem ground truth via feature drift e prediction drift é obrigatório."
	},
	{
		question:  "O modelo novo passou por validation pipeline completo (offline → backtesting → shadow → canary) antes de afetar decisões reais?"
		reveals:   "Se deploy é seguro — ou se modelo novo afeta operações reais sem validação em produção."
		rationale: "Shadow mode + canary = safety net. Sem: deploy é gamble."
	},
	{
		question:  "Cada decisão do modelo é explicável para o stakeholder relevante? Fornecedor sabe por que foi rejeitado? Regulador pode auditar?"
		reveals:   "Se interpretability é implementada — ou se modelo é caixa-preta para quem é afetado por suas decisões."
		rationale: "Rudin 2019: interpretability. EBA 2020, Bacen 2024: explicabilidade regulatória. Decisão sem explicação em crédito regulado é violação."
	},
	{
		question:  "A integração LLM + ML é projetada com responsabilidade clara? LLM orquestra, ML prediz, governance valida?"
		reveals:   "Se compound system tem separação de responsabilidade — ou se LLM 'inventa' scores e governance não existe."
		rationale: "Zaharia et al. 2024: compound AI systems. Na Mesh, LLM que hallucina score é catastrófico. Separação clara: ML calcula, LLM interpreta, governance valida."
	},
	{
		question:  "Prompts são versionados, testados e deployed com rigor de código? Eval suite cobre edge cases?"
		reveals:   "Se prompts são artefatos de engenharia — ou se são strings coladas que alguém muda sem testar."
		rationale: "Prompt engineering as software engineering 2023+. Na Mesh AI-native: prompt change sem test é policy change sem validation."
	},
	{
		question:  "Feedback loops estão fechados? Outcomes alimentam retraining? Selective labels são endereçados? Self-fulfilling prophecies monitoradas?"
		reveals:   "Se o sistema aprende com outcomes reais — ou se modelo estático degrada enquanto mundo muda."
		rationale: "Sculley et al. 2015: feedback loops. Selective labels 2019+. Na Mesh, scoring loop fecha em D+60-120 — se outcomes não alimentam modelo: flywheel não gira."
	},
	{
		question:  "A abordagem mais simples que resolve o problema foi tentada primeiro? Complexidade adicional é justificada por improvement mensurável?"
		reveals:   "Se complexidade é deliberada — ou se deep learning foi usado porque é 'cool' com 300 dados."
		rationale: "Google Rules of ML 2023: start simple. Na Mesh solo founder: cada unidade de complexidade tem custo de manutenção."
	},
	{
		question:  "Fairness assessment foi feito? Taxas de aprovação equitativas entre grupos? Proxy features investigadas? Bias histórico mitigado?"
		reveals:   "Se modelo é justo — ou se discrimina via proxy sem que ninguém saiba."
		rationale: "Barocas et al. 2019: fairness. Bacen 403/2024: não-discriminação. Modelo que discrimina é risco regulatório, ético e reputacional."
	},
]

meshExamples: [
	{
		id:       "ex-scoring-lifecycle-v1-to-v2"
		scenario: "Scoring model v1 (logistic regression, 5 features, AUROC 0.72) está em produção há 6 meses. Feature store tem 12 features disponíveis. Equipe propõe v2 (XGBoost, 12 features). Como validar e migrar?"
		analysis: "v1 atende threshold mínimo (AUROC 0.70) mas v2 potencialmente melhora. XGBoost adiciona complexidade: perde interpretability direta, requer SHAP, mais hiperparâmetros, mais sensível a data quality. Trade-off: +AUROC esperado vs +complexidade. Validação rigorosa é obrigatória porque v2 afetará decisões de crédito reais."
		recommendation: "(1) Offline validation: treinar v2 com mesmos dados de v1 + 6 meses de dados novos. AUROC v2 = 0.78 vs v1 = 0.72. Gap de 0.06 — significativo. Calibration: score 70 em v2 corresponde a ~30% default rate real? Fairness: taxas de aprovação por região e porte — disparidade aceitável? (2) Backtesting: replay 6 meses de operações com v2. 15 operações que v1 aprovou e v2 rejeitaria — 10 defaultaram (v2 teria evitado 10 defaults). 5 operações que v1 rejeitou e v2 aprovaria — 4 eram low risk confirmado (v2 teria capturado volume). Net: v2 é superior. (3) SHAP analysis: para v2, top features — historico_pagamentos_90d (30%), faturamento_mensal (18%), total_antecipacoes_ativas (15%), concentracao_fornecedores (12%). Features proprietárias dominam. (4) Shadow mode: deploy v2 em shadow por 30 dias. v2 recebe mesmos inputs que v1. Outputs logados, não usados. Comparar: distribuição de scores, % de divergências com v1, casos onde v2 rejeitaria mas v1 aprovou. (5) Canary: após shadow satisfatório: 10% do tráfego para v2 por 2 semanas. Monitor drift, latency, error rate. Se stable: 25% → 50% → 100%. (6) Rollback plan: se v2 em canary mostra degradação (AUROC cai, error rate sobe): rollback para v1 em <5min. (7) Documentation: model card v2 com todas as métricas, fairness assessment, SHAP analysis, deployment log."
		principlesApplied: ["ax-01", "ax-03", "ax-07", "dp-01"]
		assumptions: [
			"0.06 de AUROC improvement é significativo — verificar confidence interval (dados podem ser insuficientes para diferença estatisticamente significativa)",
			"SHAP adequado para explicabilidade regulatória — Bacen pode exigir modelo interpretável por design (logistic regression) em vez de opaco + explicação",
			"shadow mode de 30 dias é suficiente — pode precisar de mais se volume é baixo",
			"rollback de v1 é possível em <5min — requer model registry com versões e deploy automatizado",
		]
		rationale: "Google MLOps 2020: validation pipeline. Mitchell et al. 2019: model cards. Na Mesh, migração de v1 para v2 é decisão consequente — validation pipeline (offline → backtesting → shadow → canary) é o que previne que modelo inferior afete operações. Backtesting com dados reais é a evidência mais forte."
	},
	{
		id:       "ex-llm-scoring-guardrail"
		scenario: "Agente LLM orquestrando fluxo de antecipação recebe resultado do scoring model: score = 45 (abaixo do threshold 60). LLM analisa contexto adicional: comprador é anchor tenant com 50 operações históricas sem default. LLM sugere aprovar 'por contexto operacional'."
		analysis: "Situação perigosa: LLM está overriding decisão do ML model baseado em 'contexto'. Se permitido: (1) governance de scoring é bypassada — threshold existe por razão. (2) precedente: LLM pode override em qualquer caso com 'justificativa de contexto'. (3) se comprador defalta: quem errou? ML (score 45 era correto)? LLM (override era errado)? Ninguém é accountable. (4) audit trail confuso — 'aprovado apesar de score 45 porque LLM decidiu'. Regulador questiona. Contraponto: threshold fixo pode ser rígido demais. Comprador com 50 operações sem default é genuinamente low risk que o modelo pode estar subavaliando (data quality, feature missing)."
		recommendation: "(1) Regra: LLM nunca override ML model para decisão de crédito. ML model é source of truth para scoring. LLM interpreta e comunica, não decide contra. (2) Governance layer: se LLM sugere ação que contradiz ML output: governance bloqueia e escala para human review. Evento: GovernanceEscalation com reason='LLM proposed override of scoring threshold'. (3) Para o caso específico: escalar para founder/human com context: 'score 45 (threshold 60), mas comprador tem 50 ops históricas sem default. Possível que modelo esteja subavaliando. Decisão humana.' (4) Se pattern se repete (modelo subavalia anchor tenants): não ajustar via LLM override — adicionar feature ao modelo (total_operacoes_historicas, default_rate_historica) e retreinar. Se feature melhora AUROC e scoring de anchor tenants sobe: modelo corrigido por design, não por override. (5) Documentar: ADR 'LLM não pode override scoring model. Se modelo parece errado para um caso: escalar para humano e investigar se modelo precisa de feature ou retraining.' (6) CLAUDE.md: instrução clara — 'ao receber score abaixo do threshold, nunca aprovar por context. Escalar para human review com justificativa.'"
		principlesApplied: ["ax-03", "ax-05", "ax-07"]
		assumptions: [
			"threshold de 60 é calibrado e adequado — se não é: ajustar threshold, não override caso a caso",
			"comprador com 50 ops sem default é genuinamente low risk — pode ser survivorship bias (sempre foi aprovado porque sempre teve score alto antes)",
			"feature total_operacoes_historicas melhora scoring — testar antes de adicionar",
			"human review é possível em tempo aceitável — se operação é time-sensitive e human não está disponível: política conservadora (rejeitar)",
		]
		rationale: "AAG autonomy-boundary: LLM opera dentro de boundaries. ML-LLM integration: ML prediz, LLM interpreta, governance valida. Na Mesh, LLM que override scoring model para decisão de crédito é risco financeiro e regulatório. Se modelo parece errado: corrigir o modelo, não permitir override ad hoc."
	},
	{
		id:       "ex-prompt-regression-detection"
		scenario: "Prompt do agente de validação de documentos é atualizado para melhorar handling de novos tipos de documento (NFS-e eletrônica). Após deploy, agent review sample mostra que 15% dos CNDs (Certidões Negativas de Débito) estão sendo classificados incorretamente (eram 2% antes)."
		analysis: "Prompt change causou regression em tipo de documento existente (CND) ao tentar melhorar handling de tipo novo (NFS-e). Sem eval suite: regression detectada apenas por human review sample 3 dias depois. 3 dias × volume de operações = N fornecedores com documentos incorretamente classificados. Se CND classificada como 'inválida' quando é válida: fornecedor rejeitado incorretamente (false negative). Se classificada como 'válida' quando é inválida: compliance risk (false positive)."
		recommendation: "(1) Rollback imediato: reverter prompt para versão anterior. Git revert. Deploy em <5min. Regression eliminada. (2) Investigar: prompt change que melhorou NFS-e handling inadvertidamente mudou classificação de CND — provavelmente regex ou instrução de classificação que overlaps. (3) Fix: modificar prompt para melhorar NFS-e sem afetar CND. Test: (a) golden dataset de CND: 30 exemplos (valid + invalid). Pass rate target: >98%. (b) golden dataset de NFS-e: 20 exemplos. Pass rate target: >95%. (c) golden dataset de outros tipos: 50 exemplos. Pass rate target: >97%. Rodar eval suite antes de deploy do fix. Se todos passam: deploy. Se CND regride: fix está errado. (4) Expand eval suite: adicionar 15 cenários de CND que foram misclassificados como regression tests permanentes. Futuros prompt changes que afetam CND serão detectados em CI. (5) Process improvement: para todo prompt change — obrigatório rodar eval suite completa antes de deploy. Se eval suite não existia para o tipo de documento: criar antes de fazer change. (6) Impacted operations: identificar operações afetadas nos 3 dias de regression. Reclassificar documentos. Notificar fornecedores se foram incorretamente rejeitados."
		principlesApplied: ["ax-03", "ax-05", "ax-07"]
		assumptions: [
			"rollback para versão anterior resolve regression — se prompt anterior também tinha issues: fix is needed regardless",
			"golden dataset de 30 CNDs é representativo — pode precisar de mais se variedade de CNDs é alta",
			"eval suite em CI previne futuras regressions — se LLM model é atualizado (nova versão de Claude): eval precisa re-rodar mesmo sem prompt change",
			"3 dias de regression afetou N operações — quantificar impacto real para decidir se remediation é necessária",
		]
		rationale: "Prompt engineering as software engineering 2023+. PromptFoo 2024+: regression testing. Na Mesh, prompt change sem eval suite é code change sem test — regression é descoberta em produção por humano 3 dias depois, afetando operações reais. Eval suite em CI previne por design."
	},
	{
		id:       "ex-selective-labels-exploration"
		scenario: "Scoring model rejeita ~35% das solicitações (score < 60). Após 12 meses, observa-se que 100% dos dados de outcome são de compradores aprovados (score ≥ 60). Modelo é retreinado com estes dados. Preocupação: modelo está aprendendo apenas sobre compradores que já passaram no filtro."
		analysis: "Selective labels problem: modelo nunca observa outcome de compradores com score < 60. Se entre os rejeitados existem compradores que seriam bons pagadores: modelo nunca aprende isso. Modelo retreinado com dados enviesados reforça viés — rejeita quem nunca teve chance, aprende que 'rejeitar estes perfis é correto' porque nunca viu outcome positivo deles. Self-fulfilling prophecy. Consequências: (1) moat subestimado — data flywheel gira apenas para aprovados, 35% da população é data gap. (2) pricing potencialmente alto demais — modelo conservador porque não conhece todo o espectro de risco. (3) volume perdido — compradores viáveis são rejeitados pelo modelo que nunca os conheceu."
		recommendation: "(1) Exploration controlada: para 5-10% dos casos com score entre 50-60 (marginalmente abaixo do threshold): aprovar com condições conservadoras — valor máximo reduzido (50% do cap normal), documentação extra obrigatória, monitoramento intensivo. Objetivo: observar outcome para esta faixa. (2) Budget de exploration: máximo 5% do volume total em exploration. Perda esperada (se 50% dos explorados defalta com valor médio R$15k): R$X/mês. Comparar com valor de informação (dados que melhoram modelo para 35% da população). Se valor de informação > perda esperada: exploration é investimento. (3) Inverse propensity weighting: para retraining, pesar cada amostra pela probabilidade de ter sido aprovada. Comprador com score 62 (marginalmente aprovado): peso 1.0. Comprador explorado com score 55: peso mais alto (ele teve menor probabilidade de ser aprovado — dados dele são mais informativos). (4) Após 3-6 meses de exploration: outcomes disponíveis para faixa 50-60. Se 70% pagou em dia: modelo estava rejeitando compradores viáveis — threshold pode ser ajustado para 55. Se 80% defaultou: threshold de 60 é adequado, modelo estava correto. (5) Monitorar: model fairness por grupo — se exploration revela que compradores de região X com score 55 pagam em dia enquanto outros com score 55 defaultam: feature de região (ou proxy) está capturando algo real. (6) Comunicar: documentar exploration como investimento em data quality — 'aprovamos 5% abaixo do threshold para gerar dados de outcome que melhoram o modelo para toda a população.'"
		principlesApplied: ["ax-01", "ax-07", "dp-01"]
		assumptions: [
			"exploration de 5-10% dos cases marginais é volume suficiente para gerar dados estatisticamente úteis — depende de volume total",
			"condições conservadoras (valor reduzido, docs extras) mitigam risco suficientemente — pode não ser suficiente se default rate na faixa 50-60 é alta",
			"inverse propensity weighting corrige viés suficientemente — técnica tem limitações com amostras pequenas",
			"3-6 meses é suficiente para observar outcomes — depende de prazo de pagamento",
		]
		rationale: "Selective labels 2019+. Sculley et al. 2015: self-fulfilling prophecy. Na Mesh, 35% da população de compradores é invisible para o modelo — exploration controlada é o investimento que fecha o gap informacional e pode revelar volume perdido que estava sendo rejeitado injustamente."
	},
]

principleIds: ["ax-01", "ax-03", "ax-05", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governa agentes IA — autonomia, escalation, audit trail. ML define como modelos de ML e LLMs são projetados, validados e deployed dentro do framework de governance. AAG é 'quais boundaries'; ML é 'como os sistemas de ML operam dentro dessas boundaries'. AAG diz 'agente escala se score < threshold'; ML diz 'scoring model calcula score com estas features, validado por este pipeline, explicável com SHAP'."
	},
	{
		lensId:   "lens-credit-risk"
		relation: "complementsWith"
		context:  "CR modela risco de crédito com métricas específicas (AUROC, calibration, inadimplência). ML define o sistema que implementa scoring — lifecycle, monitoring, validation, retraining. CR é 'o que medir e qual threshold'; ML é 'como projetar, validar e manter o sistema que mede'. CR diz 'AUROC target 0.75'; ML diz 'validation pipeline: offline → backtesting → shadow → canary para atingir e manter target'."
	},
	{
		lensId:   "lens-data-modeling-for-analytical-power"
		relation: "complementsWith"
		context:  "DM fornece feature store e modelos dimensionais. ML consome features do feature store para treinamento e inferência. DM é a infraestrutura de dados; ML é o consumidor. DM dm-feature-store garante consistency training-serving; ML ml-feedback-loops garante que outcomes retroalimentam features. DM diz 'feature freshness SLO'; ML diz 'se feature stale: scoring degrada'."
	},
	{
		lensId:   "lens-data-quality-as-competitive-moat"
		relation: "complementsWith"
		context:  "DQ modela dados como moat competitivo — data flywheel, learning curve, AUROC gap. ML implementa o sistema que transforma dados em predição — se ML system é fraco: dados existem mas moat não se materializa. DQ diz 'data flywheel requer que dados melhorem scoring'; ML diz 'feedback loop closes em D+60, retraining triggered, AUROC melhora'. DQ é a estratégia; ML é a execução."
	},
	{
		lensId:   "lens-event-driven-architecture-patterns"
		relation: "complementsWith"
		context:  "EDA fornece event sourcing e replay. ML usa replay para backtesting — simular modelo novo contra eventos históricos. EDA é o mecanismo (replay de eventos); ML é o uso (backtesting de modelo). EDA eda-event-sourcing preserva features_snapshot em ScoreCalculated; ML ml-model-interpretability usa para explicar decisões passadas."
	},
	{
		lensId:   "lens-knowledge-management"
		relation: "complementsWith"
		context:  "KM define knowledge as code. ML ml-prompt-management implementa para prompts — versionados, testáveis, auditáveis. ML model cards são knowledge codificada sobre modelos. KM diz 'knowledge deve ser reproduzível'; ML diz 'pipeline de ML e prompts são artefatos reproduzíveis no mesh-spec'."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI monitora sistemas em produção. ML ml-monitoring-drift adiciona dimensão de ML monitoring — feature drift, prediction drift, AUROC trend. OOI é monitoring de infraestrutura (latency, error rate); ML é monitoring de modelo (drift, performance, fairness). Ambos necessários para ML system saudável."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA aloca recursos proporcionalmente ao estágio. ML ml-model-simplicity-bias respeita: logistic regression para pré-revenue (complexidade mínima), XGBoost para tração (complexidade justificada por improvement). ORA ora-satisficing governa: modelo simples que atinge threshold satisfice."
	},
	{
		lensId:   "lens-security-trust-infrastructure"
		relation: "complementsWith"
		context:  "STI protege dados e sistemas. ML systems processam dados sensíveis (features financeiras, scores). STI sti-ai-specific-security cobre: prompt injection em LLM agents, model extraction attacks, adversarial inputs em scoring model. STI é a segurança; ML é o sistema a ser protegido."
	},
]

limitations: [
	{
		description: "MLOps maturity Level 2 (CI/CD de pipeline) requer investimento significativo em infraestrutura. Solo founder não pode implementar full MLOps com experiment tracking, model registry, automated retraining, e monitoring dashboard."
		alternative: "Proporcional ao estágio: pré-revenue = notebook versionado + manual deploy + basic monitoring (PSI check mensal). Tração = MLflow local + semi-automated pipeline + EvidentlyAI. Escala = full MLOps. Cada nível quando volume e equipe justificarem."
		rationale: "Google 2020: MLOps maturity levels. Pular para Level 2 com 1 pessoa e 300 dados é over-engineering."
	},
	{
		description: "Ground truth delay (D+60-120 para scoring) significa que monitoring sem ground truth (feature drift, prediction drift) pode gerar falsos positivos — drift detectado pode ser mudança legítima no mercado, não degradação do modelo."
		alternative: "Two-stage monitoring: (1) real-time drift como early warning (investigate, don't panic). (2) delayed ground truth como confirmação (AUROC com outcomes reais). Só retreinar quando ground truth confirma degradação. Feature drift sem AUROC drop: mercado mudou mas modelo ainda é válido."
		rationale: "Ground truth delay 2023+. False positives em drift detection consomem recursos de investigação. Two-stage monitoring equilibra speed vs accuracy de alarme."
	},
	{
		description: "Fairness em ML é campo com métricas mutuamente incompatíveis — demographic parity e equalized odds não podem ser satisfeitas simultaneamente (Chouldechova 2017, Kleinberg et al. 2016). Não existe modelo 'perfeitamente fair' por todas as métricas."
		alternative: "Escolher métrica de fairness alinhada com o contexto regulatório e ético. Para crédito: equalized odds (taxas de erro iguais entre grupos) é geralmente mais adequada que demographic parity (taxas de aprovação iguais). Documentar escolha e justificativa. Transparência sobre trade-offs."
		rationale: "Chouldechova 2017: impossibility theorem. Na Mesh, escolher métrica de fairness é decisão de design — não existe resposta universalmente correta. Documentar e justificar é o standard."
	},
	{
		description: "Eval suites para LLMs são approximation — LLM-as-judge tem seus próprios biases, e golden datasets não cobrem todos os edge cases. Pass rate de 95% não garante zero problemas em produção."
		alternative: "Defense in depth: eval suite (pre-deploy) + human review sample (post-deploy) + governance guardrails (runtime) + incident response (when things go wrong). Nenhuma camada é suficiente sozinha; todas juntas reduzem risco."
		rationale: "Evaluation-driven development 2024+: eval é necessário mas não suficiente. Defense in depth para LLMs combina múltiplas camadas de validação."
	},
	{
		description: "Exploration para selective labels (aprovar abaixo do threshold) é investimento com custo real — 5% de volume em exploration com default rate possivelmente alta gera perda financeira."
		alternative: "Budget de exploration definido e orçado como investimento em data quality — com cap máximo de perda. Se perda excede cap: parar exploration. Se outcomes são informativos: ajustar modelo e threshold com dados reais. Valor de informação deve justificar custo."
		rationale: "Selective labels 2019+: exploration como investimento. Custo é real; benefício é informacional. Budget com cap protege contra downside."
	},
]

rationale: "Toda organização que usa ML/IA em decisões de negócio precisa de sistemas confiáveis — não apenas modelos. Na Mesh como intermediário financeiro AI-native, ML e LLMs operam em decisões consequentes (scoring, pricing, qualificação, comunicação) que afetam fornecedores, construtoras, investidores e regulador. Esta lens operacionaliza: ML lifecycle completo com model cards e MLOps proporcional (Sculley et al. 2015, Google 2020, Mitchell et al. 2019, Huyen 2022), monitoring e drift detection com ground truth delay (EvidentlyAI 2021+, Arize/WhyLabs 2022+), validation pipeline rigoroso com backtesting, shadow mode e canary (2023+), interpretabilidade tiered para stakeholders regulados (Rudin 2019, Lundberg/Lee 2017, EBA 2020, Bacen 2024), compound AI systems integrando LLMs e ML models (Zaharia et al. 2024), prompt management como software engineering (PromptFoo/Braintrust 2024+), feedback loops com selective labels e causal awareness (Sculley et al. 2015, Pearl 2018, Lakkaraju et al. 2019+), simplicity bias com complexity budget (Google Rules of ML 2023), e fairness assessment obrigatório para decisões reguladas (Barocas et al. 2019, NIST AI RMF 2023, EU AI Act 2024, Bacen 403/2024). Universal, agnóstica a estágio, aplicável a qualquer organização com ML/IA em decisões de negócio."

}
