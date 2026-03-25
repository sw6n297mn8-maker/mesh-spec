package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

developerAndIntegratorExperience: artifact_schemas.#AnalyticalLens & {
id:     "lens-developer-and-integrator-experience"
name:   "Experiência do Desenvolvedor e Integrador"

purpose: "Orientar decisões sobre como projetar experiência de developer e integrador — SDKs, docs, sandbox, error messages e time-to-first-value."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como projetar experiência para desenvolvedores que integram com a API da Mesh",
		"a decisão envolve como projetar documentação técnica que habilita integração self-service",
		"a decisão envolve como reduzir time-to-first-integration para novos integradores",
		"a decisão envolve como projetar sandbox e ambientes de teste para integradores",
		"a decisão envolve como suportar integradores com diferentes níveis de sofisticação técnica",
		"a decisão envolve como SDKs, client libraries e code samples aceleram adoção",
		"a decisão envolve como projetar developer portal e experiência de onboarding técnico",
		"a decisão envolve como medir e melhorar satisfação de desenvolvedores que usam a plataforma",
		"a decisão envolve como a experiência de integrador afeta growth da plataforma (developer-led growth)",
		"a decisão envolve como projetar changelog, migration guides e comunicação técnica para breaking changes",
	]
	keywords: [
		"developer experience", "DX", "devex", "experiência do desenvolvedor",
		"integração", "integration", "integrador", "integrator",
		"API", "SDK", "client library", "wrapper",
		"documentação", "documentation", "docs", "reference",
		"sandbox", "ambiente de teste", "staging", "mock",
		"onboarding técnico", "quickstart", "getting started",
		"developer portal", "portal do desenvolvedor", "console",
		"code sample", "exemplo de código", "snippet",
		"changelog", "migration guide", "breaking change",
		"webhook", "callback", "event notification",
		"rate limit", "authentication", "API key", "OAuth",
		"Postman", "OpenAPI", "Swagger", "curl",
		"developer-led growth", "DLG", "bottom-up adoption",
	]
	excludeWhen: [
		"a decisão é sobre design de API como produto (resource modeling, versioning, error design) — usar api-design-as-product",
		"a decisão é sobre segurança de APIs (authentication, authorization, OWASP) — usar security-trust-infrastructure",
		"a decisão é sobre onboarding de usuário final (fornecedor, construtora) — usar jobs-to-be-done-and-workflow-design",
		"a decisão é sobre pricing de API access — usar pricing-and-monetization-architecture",
		"a decisão é sobre documentação interna (mesh-spec, ADRs) — usar knowledge-management",
	]
	rationale: "Toda plataforma B2B que pretende escalar além de integrações manuais precisa de experiência de integrador excepcional — porque integradores são o canal de crescimento que multiplica distribuição sem custo marginal. Na Mesh como plataforma AI-native, integradores são construtoras com equipes técnicas (ERP integration), ERPs e softwares de gestão (parceiros que distribuem), e fintechs que complementam (originadores, factorings que querem usar scoring da Mesh). API-design-as-product cobre o design técnico da API; STI cobre segurança. Esta lens cobre a experiência end-to-end do integrador — de 'nunca ouvi falar da Mesh' até 'minha integração está em produção e funciona perfeitamente'. É o design da jornada que transforma desenvolvedor curioso em integrador ativo e promotor."
}

concepts: [
	{
		id:         "dx-developer-journey"
		name:       "Jornada do Desenvolvedor: De Discover a Advocate"
		nature:     "theoretical"
		role:       "framework"
		definition: "Conceito de 'developer journey' (Reddy 2020, 'API as Product'): a experiência do desenvolvedor segue estágios análogos a um funil: (1) discover — desenvolvedor descobre que API existe. (2) evaluate — avalia se resolve seu problema (docs, pricing, capabilities). (3) learn — aprende como usar (quickstart, tutorials, reference). (4) build — constrói integração (sandbox, SDKs, code samples). (5) launch — coloca em produção (go-live checklist, support). (6) maintain — opera em produção (monitoring, changelog, migration). (7) advocate — recomenda para outros desenvolvedores. Conceito contemporâneo de 'time-to-first-hello-world' (TTFHW, 2022+): métrica de quanto tempo o desenvolvedor leva do primeiro acesso à documentação até executar sua primeira chamada de API com sucesso. Benchmark: <5 minutos para APIs modernas. Stripe: famosamente <5 min. Conceito de 'developer-led growth' (DLG, Redpoint 2023+, Heavybit 2023+): pattern onde developers adotam produto bottom-up (testam API, constroem integração, convencem decisores a comprar). Oposto de top-down sales. DLG requer: DX excepcional (baixa fricção), documentação self-service, freemium/sandbox gratuito. Conceito de 'DX = UX for developers' (Fagerholm/Munch 2012, evoluído 2023+): DX é a experiência cognitiva, emocional e prática de desenvolvedores ao interagir com ferramentas, APIs e plataformas. Inclui: clareza de documentação, qualidade de error messages, consistência de API design, velocidade de feedback loop."
		meshManifestation: "Na Mesh, integradores e suas jornadas: (1) ERP de construtora (ex: Sienge, UAU) — integração para automatizar fluxo de antecipação e qualificação de fornecedores diretamente do ERP. Jornada: descoberta via parceria comercial → avaliação técnica → integração de sandbox → piloto com construtora → produção. (2) equipe técnica de construtora grande — integração custom para automatizar workflows internos. Jornada: avaliação via decisor interno → quickstart → sandbox → build custom → produção. (3) fintech complementar (originador, factoring) — usa scoring ou operação da Mesh como componente. Jornada: discovery via API docs → evaluate capabilities → build integration → produção. Cada tipo de integrador tem sofisticação diferente: ERP tem equipe técnica dedicada; construtora pode ter 1 dev generalista; fintech tem equipe especializada em APIs. TTFHW target: <15min (criar conta sandbox, obter API key, fazer primeira chamada com curl/Postman). Se >30min: fricção excessiva."
		meshImplication: "Para cada estágio da jornada: (1) discover — landing page de developer portal com value prop clara: 'Integre antecipação de recebíveis e gestão de cadeia na sua aplicação. [Documentação] [Sandbox gratuito] [Quickstart 5min].' SEO para termos técnicos do setor ('API antecipação recebíveis construção civil'). (2) evaluate — docs com capabilities list, use cases por tipo de integrador, pricing de API (se aplicável), e comparação com alternativas. Sem login para ler docs — docs abertas é signal de confiança. (3) learn — quickstart em 3 steps: (a) criar conta sandbox, (b) obter API key, (c) fazer primeira chamada (curl example que funciona copy-paste). Tutorial por use case: 'submeter operação de antecipação', 'consultar status', 'receber webhook de aprovação'. (4) build — sandbox com dados de teste realistas (fornecedores fictícios, construtoras fictícias, operações simuláveis). SDKs para linguagens comuns (Python, Node.js, Java). Code samples para cada endpoint. Postman collection importável. (5) launch — go-live checklist: 'antes de produção: (a) webhook endpoint configurado, (b) error handling implementado, (c) idempotência testada, (d) rate limits compreendidos.' (6) maintain — changelog com breaking vs non-breaking. Migration guides para cada breaking change. Status page para health da API. (7) advocate — developer community (Discord/Slack). Case studies de integrações bem-sucedidas. Anti-pattern: API documentation que requer login para acessar, sandbox que requer aprovação manual, e quickstart que leva 45 minutos."
		rationale: "Reddy 2020: developer journey. TTFHW 2022+. DLG Redpoint/Heavybit 2023+. Fagerholm/Munch 2012: DX. Na Mesh, cada integrador que completa a jornada até produção é canal de distribuição que multiplica alcance — ERP integrado distribui Mesh para todas as construtoras que usam aquele ERP."
	},
	{
		id:         "dx-documentation-excellence"
		name:       "Documentação como Produto: Onde Desenvolvedor Gasta 90% do Tempo"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "quarterly"
		definition: "Procida (2023, Diátaxis Framework): documentação eficaz é organizada em 4 tipos: (1) tutorials — aprendizado orientado ('faça X para aprender Y'). (2) how-to guides — resolução de problema orientada ('como fazer X'). (3) reference — informação orientada (endpoint spec, parâmetros, tipos). (4) explanation — entendimento orientado ('por que X funciona assim'). Cada tipo serve necessidade diferente do developer em momento diferente. Misturar tipos gera docs que não servem ninguém bem. Conceito contemporâneo de 'docs-as-code' (2020+, Redocly, ReadMe, Mintlify): documentação versionada no mesmo repositório que o código, built com CI/CD, testável (code samples executáveis), e deployada automaticamente. Conceito de 'interactive documentation' (2023+, Mintlify, Stoplight, Redocly): docs com 'Try It' inline — developer testa endpoint direto na documentação sem sair da página. Reduz TTFHW dramaticamente. Conceito de 'documentation-driven development' (2022+): escrever a documentação antes de implementar a API — docs é o primeiro artefato, não o último. Se docs é difícil de escrever: API é difícil de usar."
		meshManifestation: "Na Mesh, documentação por tipo Diátaxis: (1) tutorials — 'Quickstart: Sua primeira operação de antecipação em 5 minutos.' 'Tutorial: Integrar webhooks de status.' 'Tutorial: Consultar fornecedores qualificados.' Step-by-step com code samples copy-paste. (2) how-to guides — 'Como submeter operação de antecipação.' 'Como tratar erros de validação.' 'Como implementar retry com exponential backoff.' 'Como migrar de v1 para v2 da API.' Orientados a problema, não a conceito. (3) reference — OpenAPI spec completa. Cada endpoint com: description, parameters, request body, response body, error codes, examples. Auto-gerada a partir de OpenAPI spec. (4) explanation — 'Como funciona o ciclo de vida de uma operação (ECL).' 'Como scoring influencia aprovação.' 'Modelo de dados: entidades e relações.' Conceitual — developer lê para entender o sistema antes de construir."
		meshImplication: "Docs como produto: (1) Diátaxis como framework — organizar docs nos 4 tipos. Developer que quer aprender: tutorials. Que quer resolver problema: how-to. Que quer especificação exata: reference. Que quer entender por quê: explanation. (2) docs-as-code — docs no repositório mesh-spec (ou repo dedicado). Markdown + OpenAPI spec. CI/CD: build e deploy automático a cada merge. Code samples testados automaticamente (se code sample quebra: CI falha). (3) interactive — 'Try It' em cada endpoint. Developer clica, ajusta parâmetros, executa contra sandbox, vê resposta. Sem instalar nada. Tools: Mintlify, Redocly, ou custom. (4) OpenAPI spec como source of truth — reference gerada automaticamente da spec. SDKs gerados da spec. Postman collection gerada da spec. Consistência garantida. Se spec muda: docs, SDKs, e collection atualizam automaticamente. (5) search — docs com search funcional. Developer busca 'webhook' e encontra: tutorial de webhook + how-to de configuração + reference de webhook endpoint + explanation de modelo de eventos. (6) freshness — docs desatualizada é pior que sem docs (developer confia e implementa errado). Ownership: cada seção de docs tem owner. Review trimestral: docs reflete realidade? Code samples funcionam? (7) métricas — page views por seção (o que developers mais lêem?), search terms (o que procuram e não encontram?), TTFHW (quanto tempo até primeira chamada?), doc feedback (útil? não-útil?). Anti-pattern: docs como afterthought — API é construída, docs é escrita 3 meses depois por quem não construiu, com examples que não funcionam."
		dependsOn: ["dx-developer-journey"]
		crossDependsOn: [{
			lensId:    "lens-api-design-as-product"
			conceptId: "api-documentation-as-interface"
			context:   "API define docs como interface e Diátaxis como framework. DX operacionaliza: docs como produto com CI/CD, interactive docs, e métricas de developer engagement. API é o design da documentação; DX é a operação e manutenção como produto live. API diz 'docs devem ter 4 tipos'; DX diz 'docs são built com CI/CD, testadas automaticamente, e medidas por TTFHW'."
		}]
		rationale: "Procida 2023: Diátaxis. Docs-as-code 2020+. Interactive docs 2023+. Documentation-driven development 2022+. Na Mesh, developer que não consegue entender a API pela documentação não vai ligar para suporte — vai para alternativa. Docs é onde 90% da experiência acontece."
	},
	{
		id:         "dx-sandbox-testing"
		name:       "Sandbox e Testes: Ambiente Onde Integrador Pode Errar Sem Consequência"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Sandbox é ambiente de teste que replica produção sem consequências reais — developer pode submeter operações, testar webhooks, simular erros, sem afetar dados ou dinheiro real. Conceito de 'sandbox fidelity' (2022+): quanto mais o sandbox se parece com produção: melhor a integração resultante. High fidelity: sandbox com mesmos endpoints, mesmos schemas, mesma autenticação, mesmos error codes. Low fidelity: mock que retorna respostas estáticas sem lógica. Conceito contemporâneo de 'magic test values' (Stripe, 2014+): valores especiais que simulam cenários em sandbox — cartão 4242 4242 4242 4242 sempre aprova, 4000 0000 0000 0002 sempre recusa. Developer testa cenários sem implementar mock. Conceito de 'contract testing for integrators' (PactFlow 2022+, Postman Contract Testing 2023+): integrador define contrato (request/response esperado) e verifica automaticamente que API cumpre. Se API muda de forma incompatível: contrato quebra antes de produção."
		meshManifestation: "Na Mesh, sandbox com: (1) dados de teste realistas — fornecedores fictícios com CNPJs de teste, construtoras fictícias, operações simuláveis. Não dados genéricos ('Empresa Teste 1'): dados que parecem reais ('Construtora São Paulo Engenharia Ltda', CNPJ 11.222.333/0001-44'). Developer entende o domínio pelos dados de teste. (2) magic values para scoring — CNPJ 11.111.111/0001-11: score sempre 80 (aprovado). CNPJ 22.222.222/0001-22: score sempre 45 (rejeitado). CNPJ 33.333.333/0001-33: score sempre 62 (zona cinzenta — escala para review). Developer testa todos os cenários de decisão sem implementar mock de scoring. (3) webhook testing — sandbox envia webhooks reais para endpoint configurado pelo developer. Webhook tester integrado: developer vê payloads recebidos no portal sem precisar de ngrok/tunnel. (4) error simulation — endpoints de sandbox aceitam header X-Simulate-Error: timeout, rate-limit, validation-error, server-error. Developer testa error handling sem esperar erro real. (5) time simulation — sandbox permite 'avançar tempo' para simular fluxo completo: submeter operação → avançar 1 dia → liquidação simulada → avançar 45 dias → pagamento recebido. Developer testa lifecycle inteiro em minutos, não em 45 dias."
		meshImplication: "Sandbox como first-class product: (1) same API, different data — endpoints de sandbox são idênticos a produção (mesma URL base com prefixo sandbox., mesmos schemas, mesmos error codes). Diferença: dados são fictícios e sem efeito financeiro. Developer que integrou com sandbox: mudar para produção = trocar URL base e API key. (2) magic values documentados — tabela na documentação: 'CNPJs de teste e comportamentos simulados.' Developer memoriza os magic values. (3) auto-provisioning — signup no developer portal cria conta sandbox automaticamente. Sem aprovação manual. API key gerada em <1 minuto. TTFHW começa aqui. (4) reset — developer pode resetar sandbox a qualquer momento (limpar operações, restaurar dados default). 'Meu sandbox ficou bagunçado' → 1 botão para recomeçar. (5) webhook tester — no portal: aba 'Webhooks' com log de todos os webhooks enviados. Payload completo, timestamp, response code. Developer debugga webhook sem configurar infraestrutura. (6) rate limits relaxados — sandbox tem rate limits mais generosos que produção (developer fazendo load test não deve ser bloqueado em sandbox). (7) data isolation — cada developer tem sandbox isolado. Dados de developer A não vazam para developer B. (8) monitoring de sandbox usage — quantos developers criaram sandbox? Quantos fizeram primeira chamada? Quantos atingiram integração completa (todos os endpoints testados)? Funnel de sandbox = leading indicator de integrações futuras. Anti-pattern: sandbox que requer aprovação manual ('solicite acesso e aguarde 3 dias') — developer desiste e vai para alternativa."
		dependsOn: ["dx-developer-journey", "dx-documentation-excellence"]
		crossDependsOn: [{
			lensId:    "lens-api-design-as-product"
			conceptId: "api-sandbox-testing"
			context:   "API define sandbox com magic values e contract testing como patterns de API design. DX operacionaliza: sandbox como produto com auto-provisioning, webhook tester, error simulation, e time simulation. API é o pattern; DX é a implementação como experiência. API diz 'sandbox com magic values'; DX diz 'sandbox provisionado em <1min com webhook tester no portal e reset de 1 botão'."
		}]
		rationale: "Sandbox fidelity 2022+. Magic test values Stripe 2014+. PactFlow 2022+. Na Mesh, developer que testa em sandbox high-fidelity produz integração que funciona em produção sem surpresas — o investimento em sandbox se paga em menos issues pós-launch."
	},
	{
		id:         "dx-sdk-tooling"
		name:       "SDKs e Tooling: Reduzir Boilerplate, Acelerar Integração"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "SDK (Software Development Kit) é client library que abstrai HTTP requests em chamadas idiomáticas da linguagem do developer. Conceito de 'SDK as DX multiplier' (2022+): SDK bem-feito reduz código de integração em 5-10x — developer chama mesh.operations.create(params) em vez de construir HTTP request manualmente com headers, auth, serialização, e error handling. Conceito contemporâneo de 'SDK generation' (Stainless 2023+, Speakeasy 2023+, openapi-generator): gerar SDKs automaticamente a partir de OpenAPI spec — consistency garantida, manutenção reduzida, múltiplas linguagens sem esforço manual. Conceito de 'developer tooling ecosystem' (2023+): além de SDK, o ecossistema inclui: (1) CLI — ferramenta de linha de comando para operações comuns. (2) Postman collection — importável para teste rápido. (3) OpenAPI spec — para code generation e contract testing. (4) GitHub Actions / CI integrations — para automação de deploy. (5) Terraform provider — para infrastructure-as-code (se aplicável). Conceito de 'progressive tooling' (2024+): oferecer ferramentas proporcionais à sofisticação do developer. Beginner: curl + Postman. Intermediate: SDK. Advanced: OpenAPI spec + code generation + CI integration."
		meshManifestation: "Na Mesh, tooling por sofisticação: (1) beginner (construtora com 1 dev generalista) — curl examples copy-paste na documentação. Postman collection importável com 1 clique. Webhook tester no portal. Sem instalar nada. (2) intermediate (equipe de ERP) — SDKs: Python (para data/analytics), Node.js (para web), Java/Kotlin (para backend enterprise). Cada SDK com: typed models (operação, fornecedor, score), error handling nativo (MeshApiError com code, message, details), pagination helpers, webhook signature verification, retry com backoff. (3) advanced (fintech, equipe técnica grande) — OpenAPI spec para code generation em qualquer linguagem. Contract testing com PactFlow. CI/CD integration (GitHub Action que verifica API compatibility). Webhook delivery com Svix (garantia de entrega + retry + dashboard). (4) todos — changelog como feed (RSS, Atom). Status page (uptime, incidents). SDK changelogs por linguagem."
		meshImplication: "SDKs com qualidade: (1) SDK generation — gerar a partir de OpenAPI spec (Stainless ou Speakeasy). Garantia de consistência SDK ↔ API. Quando API muda: SDK atualiza automaticamente. Manual SDK para 3 linguagens = insustentável para solo founder. Generated SDK = sustentável. (2) priorizar linguagens por integrador — Python (construtoras com analytics, fintechs), Node.js (web apps, ERPs modernos), Java/Kotlin (ERPs enterprise). Priorizar 2 linguagens first, expandir por demanda. (3) SDK quality checklist — (a) typed models (não dicts/maps genéricos). (b) error handling idiomático (exceptions em Python, Result em Kotlin). (c) auto-retry com exponential backoff. (d) webhook signature verification built-in. (e) pagination built-in (cursor-based, não manual offset). (f) README com quickstart de 5 linhas. (g) publicado em package manager (PyPI, npm, Maven). (4) Postman collection — gerada da OpenAPI spec. Environment variables: sandbox API key, base URL. Pre-request scripts para autenticação. Publicada e atualizada automaticamente. (5) progressive: não exigir SDK para integrar — raw HTTP sempre funciona. SDK é conveniência, não requisito. Developer que prefere curl ou HTTP client nativo: documentação de raw HTTP deve ser completa. (6) versionamento — SDK versão é semver. Breaking change no SDK requer major version bump + migration guide. SDK version não precisa ser 1:1 com API version — SDK pode evoluir independentemente. Anti-pattern: SDK que é wrapper fino de HTTP client sem valor adicional — não justifica dependência. SDK deve adicionar: typed models, error handling, retry, pagination, webhook verification."
		dependsOn: ["dx-documentation-excellence", "dx-sandbox-testing"]
		crossDependsOn: [{
			lensId:    "lens-api-design-as-product"
			conceptId: "api-paradigm-choice"
			context:   "API define REST-first como paradigma. DX SDKs traduzem REST em chamadas idiomáticas por linguagem — developer não pensa em HTTP verbs mas em operações de domínio (mesh.operations.create, mesh.suppliers.get). API é o paradigma; DX é a abstração sobre o paradigma que torna uso natural."
		}]
		rationale: "SDK as DX multiplier 2022+. SDK generation Stainless/Speakeasy 2023+. Progressive tooling 2024+. Na Mesh, SDK gerado da OpenAPI spec garante consistência e sustentabilidade — solo founder não pode manter SDKs manuais em 3 linguagens."
	},
	{
		id:         "dx-developer-onboarding"
		name:       "Onboarding de Developer: De Zero a Primeira Chamada em Minutos"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Conceito de 'developer activation' (análogo a user activation — jtbd-onboarding-activation): o momento onde developer faz primeira chamada bem-sucedida à API é o aha moment técnico. Antes disso: está avaliando. Depois: está construindo. Conceito contemporâneo de 'zero-friction onboarding' (2023+): developer signup → API key → primeira chamada sem: (a) aprovação manual. (b) call com vendedor. (c) contrato assinado. (d) configuração complexa. Benchmark: Stripe, Twilio, SendGrid — signup to first API call in <5 minutes. Conceito de 'quickstart as the most important page' (2022+): quickstart é a página mais visitada da documentação e a mais determinante de conversion. Se quickstart funciona perfeitamente: developer continua. Se falha: developer sai. Quickstart deve ser testável — code sample deve funcionar copy-paste sem modificação (exceto API key)."
		meshManifestation: "Na Mesh, onboarding de developer: (1) signup — developer portal com signup por email ou GitHub SSO. Sem formulário de 15 campos. Nome, email, empresa (opcional). (2) API key — gerada automaticamente após signup. Visível no dashboard do developer. Sandbox key separada de production key. (3) quickstart — 'Sua primeira operação em 5 minutos.' 3 steps: (a) instalar SDK (pip install mesh-sdk). (b) configurar API key. (c) executar code sample: 'import mesh; client = mesh.Client(api_key=...); op = client.operations.simulate(buyer_cnpj='11.111.111/0001-11', value=50000); print(op.status, op.estimated_rate)'. Output: 'approved, 2.3%'. Developer vê: funciona. (4) next steps — após quickstart: 'agora que funcionou, explore: [Submeter operação real em sandbox] [Configurar webhooks] [Consultar fornecedores] [Ver API reference completa].' Progressive — não despejar tudo, guiar próximo passo."
		meshImplication: "Onboarding otimizado: (1) TTFHW como North Star metric de DX — tempo do signup até primeira chamada bem-sucedida (medido automaticamente: timestamp de account creation → timestamp de first 200 response em sandbox). Target: <15min. Benchmark: <5min para APIs simples. Mesh tem domínio complexo (fintech B2B): 15min é realista. (2) quickstart testado semanalmente — script automatizado que executa quickstart do zero (signup → install SDK → run code sample). Se falha: fix imediatamente. Quickstart que não funciona é pior que sem quickstart. (3) error messages que ensinam — se developer faz chamada errada: error response explica o que está errado E como corrigir. Não: '400 Bad Request'. Sim: '400: campo buyer_cnpj é obrigatório. Formato esperado: XX.XXX.XXX/XXXX-XX. Exemplo: 11.222.333/0001-44. [Link para documentação].' (4) zero-approval sandbox — sem aprovação humana para sandbox. Production key pode requerer aprovação (KYC do integrador). Sandbox: instantâneo. (5) video walkthrough — para developers que preferem: video de 3 min mostrando signup → quickstart → resultado. Complementa docs, não substitui. (6) developer office hours — semanalmente (ou bi-weekly): sessão aberta onde developers fazem perguntas ao vivo. Baixo custo, alto trust. Early-stage: founder responde pessoalmente. (7) medir funnel: signup → API key generated → first call → first successful call → integration complete → production. Cada stage com conversion rate. Se drop-off entre 'first call' e 'first successful call' >50%: error messages ou quickstart têm problema. Anti-pattern: 'agende uma call com nosso time para receber acesso ao sandbox' — developer foi embora."
		dependsOn: ["dx-developer-journey", "dx-documentation-excellence", "dx-sandbox-testing"]
		crossDependsOn: [{
			lensId:    "lens-jobs-to-be-done-and-workflow-design"
			conceptId: "jtbd-onboarding-activation"
			context:   "JTBD define onboarding e activation para end-users (fornecedor, construtora). DX define onboarding para developers. Princípios são idênticos: TTV rápido, aha moment claro, progressive disclosure, funnel medido. JTBD é user onboarding; DX é developer onboarding. Ambos seguem: reduzir fricção até primeiro valor, medir drop-off por step, iterar no step com maior abandono."
		}]
		rationale: "Developer activation 2023+. Zero-friction onboarding 2023+. Quickstart as most important page 2022+. Na Mesh, developer que não consegue fazer primeira chamada em 15 minutos está a 1 tab de distância de testar a alternativa."
	},
	{
		id:         "dx-changelog-migration"
		name:       "Changelog e Migração: Comunicar Mudanças Sem Quebrar Integrações"
		nature:     "operational"
		role:       "method"
		reviewCadence: "event-driven"
		definition: "Toda API evolui — novos endpoints, novos campos, deprecações, breaking changes. Como essa evolução é comunicada determina se integradores confiam na estabilidade da plataforma. Conceito de 'API changelog as trust signal' (2022+): changelog regular e detalhado comunica: (1) API está viva e mantida. (2) mudanças são deliberadas e comunicadas. (3) integrador pode planejar e não ser surpreendido. Conceito contemporâneo de 'breaking change protocol' (Stripe 2019+, API versioning best practices 2023+): (1) announce — comunicar breaking change com antecedência (mínimo 90 dias para breaking change material). (2) provide migration path — guia de como migrar da versão antiga para nova. (3) support both — manter versão antiga funcional durante sunset period. (4) sunset — deprecar versão antiga com data anunciada. Conceito de 'API lifecycle communication' (2024+): não apenas changelog mas comunicação proativa: (a) preview — 'estamos desenvolvendo endpoint X — feedback?' (b) beta — 'endpoint X disponível em beta — use em sandbox, não em produção.' (c) stable — 'endpoint X é stable — safe para produção.' (d) deprecated — 'endpoint X será removido em [data] — migre para Y.' (e) sunset — 'endpoint X removido.'"
		meshManifestation: "Na Mesh, lifecycle de API changes: (1) non-breaking changes (90% das mudanças) — novo endpoint, novo campo opcional, performance improvement. Comunicação: changelog entry. Não requer ação do integrador. (2) breaking changes (raro, <10%) — campo obrigatório adicionado, endpoint removido, response schema alterado. Comunicação: changelog + email direto + migration guide + sunset period. (3) cenários concretos: (a) novo campo 'modalidade_cessao' obrigatório em POST /operations — breaking para integrador que não envia. Sunset: 90 dias. Migration guide: 'adicione campo modalidade_cessao com valor default 'definitiva' se não aplicável.' (b) endpoint GET /suppliers/search deprecado em favor de GET /suppliers com query params — non-breaking (antigo continua funcionando) mas deprecated (sunset em 6 meses). (c) webhook payload v2 com campo adicional — non-breaking (campo novo é ignorado por integrador que não processa). Comunicação: changelog only."
		meshImplication: "Protocolo de mudanças: (1) changelog — publicado a cada release. Formato: data, tipo (feature/improvement/fix/deprecation/breaking), description, migration guide link (se aplicável). Feed RSS/Atom para integradores que querem notificação automática. (2) breaking change protocol: (a) announce (dia 0) — email para todos os integradores afetados + changelog entry + migration guide. 'Breaking change em [endpoint]: [descrição]. Ação necessária: [o que fazer]. Deadline: [data, mínimo 90 dias].' (b) reminder (30 dias antes do deadline) — email de lembrete. 'Breaking change em [endpoint] será efetivada em [data]. Verificamos que sua integração ainda usa o formato antigo. [Migration guide].' (c) sunset — versão antiga desativada. Se integrador não migrou: error response amigável ('esta versão foi descontinuada. Migre para v2: [link]') em vez de 500 genérico. (3) preview/beta lifecycle — para features significativas: announce preview → beta em sandbox → beta em produção (opt-in) → stable. Developer que participa de beta: feedback que molda a versão final. (4) versioning contract: 'API version tem suporte por mínimo 12 meses após lançamento de nova version.' Comunicar upfront — integrador sabe que investimento em integração é protegido. (5) SDK version alignment — quando API muda: SDK atualiza. Se breaking change: SDK major version bump. Migration guide inclui diff de SDK code. (6) medir: % de integradores que migraram antes do deadline. Se <50% em 60 dias: migration guide insuficiente ou change é muito difícil — estender deadline ou simplificar migration. Anti-pattern: breaking change sem aviso — integrador descobre quando integração quebra em produção às 3h da manhã. Destrói trust institucional."
		dependsOn: ["dx-documentation-excellence", "dx-sdk-tooling"]
		crossDependsOn: [{
			lensId:    "lens-api-design-as-product"
			conceptId: "api-versioning-evolution"
			context:   "API define additive-only como strategy e sunset protocol de 12 meses. DX operacionaliza a comunicação: changelog, email, migration guide, reminder, error amigável no sunset. API é a política de versioning; DX é a experiência do integrador ao vivenciar a evolução. API diz 'sunset em 12 meses'; DX diz 'email com migration guide 90 dias antes + reminder 30 dias antes + error amigável no dia'."
		}]
		rationale: "API changelog as trust signal 2022+. Breaking change protocol Stripe 2019+. API lifecycle communication 2024+. Na Mesh, integrador que confia que mudanças são comunicadas com antecedência investe mais na integração — porque sabe que investimento é protegido."
	},
	{
		id:         "dx-developer-success-metrics"
		name:       "Métricas de Sucesso do Developer: Medir se DX Está Funcionando"
		nature:     "operational"
		role:       "property"
		reviewCadence: "monthly"
		definition: "Conceito de 'developer metrics' (2023+): métricas específicas para developer experience — diferentes de user metrics. Types: (1) activation — TTFHW, % de signups que fazem first call. (2) engagement — API calls per developer per month, endpoints used, error rate. (3) conversion — % de sandbox que migra para produção. (4) satisfaction — developer NPS, developer survey, support ticket volume. (5) growth — new developers per month, integrations live, developer referrals. Conceito contemporâneo de 'developer relations metrics' (DevRel 2023+): (a) docs engagement (page views, time on page, search terms). (b) community engagement (questions asked, questions answered, Discord/Slack activity). (c) SDK adoption (downloads, version distribution). (d) support quality (response time, resolution time, developer satisfaction post-support)."
		meshManifestation: "Na Mesh, métricas DX: (1) activation — TTFHW: mediana <15min target. % signup → first call: target >70%. % first call → first successful call: target >80% (se <80%: error messages ou docs têm problema). (2) engagement — API calls/developer/mês em sandbox (indica building activity). Endpoints used per developer (diversidade de integração). Error rate per developer (alto = integração com problema). (3) conversion — % sandbox → produção: target >30% (70% que não converte: avaliou e não era fit, ou friction de go-live). Time sandbox → produção: mediana target <30 dias. (4) satisfaction — developer NPS: target >40 (Stripe benchmark: ~70). Support tickets per developer (menor = DX melhor). (5) growth — new developer signups/mês. Integrations live em produção. Developer referrals ('como soube de nós?')."
		meshImplication: "Dashboard de DX metrics: (1) funnel — signup → API key → first call → first success → sandbox complete → production application → production live. Conversion rate entre cada step. Step com maior drop-off = prioridade de otimização. (2) TTFHW tracking — automático (event: account_created → event: first_200_response). Se mediana >30min: investigar (quickstart broken? sandbox provisioning lento? signup complicado?). (3) developer health score — per developer: calls/month, error rate, last active date. If inactive >30 days: outreach ('precisando de ajuda com integração?'). If error rate >10%: proactive support ('notamos que suas chamadas estão com taxa de erro alta — podemos ajudar?'). (4) satisfaction — NPS survey após marco: first production call, 30 days in production, 90 days. Qualitative: 'o que poderia ser melhor?' Top feedback themes → DX roadmap. (5) docs metrics — most viewed pages (invest in quality). Most searched terms not found (content gaps). Average time on quickstart (long = confused, short = copy-paste worked). (6) report mensal: TTFHW trend, funnel conversion, NPS, new developers, integrations live. Trend > absolute. Se all improving: DX is working. Se stagnant: invest more. Anti-pattern: medir apenas API uptime como DX metric — API up 99.99% mas TTFHW de 2 horas: DX é ruim apesar de API estar 'saudável'."
		dependsOn: ["dx-developer-journey", "dx-developer-onboarding"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-sli-slo-error-budget"
			context:   "OOI define SLIs/SLOs para serviços técnicos (latência, uptime). DX define SLIs/SLOs para developer experience (TTFHW, funnel conversion, NPS). OOI é SLO técnico; DX é SLO de experiência. API pode ter SLO de 99.9% uptime (OOI) E SLO de <15min TTFHW (DX). Ambos necessários: API up com DX ruim = developers frustrados. DX boa com API down = integração impossível."
		}]
		rationale: "Developer metrics 2023+. DevRel metrics 2023+. Na Mesh, DX metrics são leading indicators de integrations live — que são leading indicators de platform distribution. Se TTFHW é 2h e conversion é 10%: DX é o bottleneck de growth via integradores."
	},
	{
		id:         "dx-developer-as-growth-channel"
		name:       "Developer como Canal de Growth: Integrações que Distribuem a Plataforma"
		nature:     "theoretical"
		role:       "property"
		definition: "Conceito de 'developer-led growth' (DLG, Redpoint 2023+): developers adotam produto bottom-up, constroem integração, e criam dependency organizacional que leva a compra top-down. Twilio, Stripe, Segment cresceram assim. Em B2B: developer é influencer + builder + champion. Conceito contemporâneo de 'integration as distribution' (2023+): cada integração com ERP, software de gestão, ou fintech é canal de distribuição. ERP integrado com Mesh distribui Mesh para todos os clientes daquele ERP. Partnership técnica = distribution partnership. Conceito de 'developer ecosystem as moat' (2024+): ecossistema de developers e integrações cria switching cost — construtora que integrou ERP com Mesh via API: migrar para alternativa requer re-integrar. Quanto mais integrações live: maior o switching cost coletivo."
		meshManifestation: "Na Mesh, developers como growth channel: (1) ERPs de construção civil — Sienge, UAU, Mega, eConstruir. Se Sienge integra com Mesh: todas as construtoras que usam Sienge podem ativar Mesh com 1 clique dentro do ERP. Distribution: 1 integração = centenas de construtoras potenciais. (2) softwares de gestão financeira — sistemas que construtoras usam para gestão de caixa. Se integrar com Mesh: antecipação é funcionalidade dentro do fluxo de gestão. (3) fintechs complementares — originadores que querem usar scoring da Mesh, factorings que querem operar via plataforma. Cada integração é canal. (4) construtora enterprise com equipe técnica — integração custom que automatiza workflow interno. Developer da construtora é champion interno que expande uso."
		meshImplication: "Developer growth strategy: (1) priorizar integrações por reach — quantos end-users cada integração atinge? ERP com 500 construtoras > fintech com 10 clientes. Investir em DX excepcional para integradores de alto reach. (2) partnership técnica com ERPs — não apenas 'integre conosco' mas co-development: 'vamos construir juntos a experiência ideal de antecipação dentro do Sienge.' Co-branded. (3) developer program — para integradores ativos: early access a features, dedicated support, co-marketing. Não é programa de benefícios genérico — é investimento em integradores que distribuem. (4) integration marketplace — listar integrações disponíveis. Construtora que entra na Mesh vê: 'integra com Sienge, UAU, Excel.' Mais integrações = mais atraente para construtora (NE via integrações). (5) medir: integrations live × reach per integration = total addressable distribution. Se 3 integrações com ERPs que servem 1000 construtoras = 1000 construtoras potenciais alcançáveis sem sales adicional. (6) switching cost via integrações: construtora que usa Mesh integrado ao ERP: migrar para alternativa = re-integrar ERP. Custo de switching proporcional à profundidade de integração. Deep integration (webhooks bidirecionais, data sync, embedded UI) > shallow integration (link externo). Anti-pattern: tratar developers como afterthought — DX medíocre que repele o canal de distribution mais escalável."
		dependsOn: ["dx-developer-journey", "dx-developer-success-metrics"]
		crossDependsOn: [{
			lensId:    "lens-cold-start-and-network-bootstrapping"
			conceptId: "cs-manual-to-organic-transition"
			context:   "CS define transição de founder-led para network-driven growth. DX developer-as-growth é um dos growth loops que habilita transição: integração com ERP distribui Mesh para clientes do ERP sem founder selling. CS é a transição; DX é um dos mecanismos (developer loop). CS diz 'organic ratio deve crescer'; DX diz 'cada ERP integrado aumenta organic ratio porque construtoras descobrem Mesh dentro do ERP, não via founder'."
		}]
		rationale: "DLG Redpoint 2023+. Integration as distribution 2023+. Developer ecosystem as moat 2024+. Na Mesh, 1 integração com ERP top (Sienge) potencialmente distribui para centenas de construtoras — ROI de DX excepcional para integradores de alto reach é desproporcional a qualquer outro canal de growth."
	},
	{
		id:            "dx-developer-experience-review"
		name:          "Revisão de DX: Inventário Periódico de Experiência do Integrador"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) journey — funnel de developer (signup → production) com conversion por step. Drop-off por step. (2) docs — pages mais visitadas, search terms sem resultado, code samples testados, freshness. (3) sandbox — usage, magic values adequados, webhook tester funcional, time simulation útil. (4) SDKs — downloads, version adoption, issues reportados. (5) onboarding — TTFHW trend, quickstart funciona copy-paste? (6) changelog — changes comunicados, migration guides publicados, breaking changes com protocol. (7) metrics — TTFHW, NPS, conversion sandbox→production, error rate. (8) growth — integrations live, reach per integration, developer referrals."
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (TTFHW, funnel, NPS). Trimestral: docs audit + sandbox test + SDK health."
		meshImplication: "Mensal (30min): TTFHW trend — melhorando? Piorando? Se piorando: quickstart ou sandbox degradou. Funnel — drop-off por step. Qual step com maior abandono? NPS — feedback themes de developers. Top 3 complaints. New developers — signups trend. Integrations live — novas em produção? Trimestral (2h): docs audit — executar quickstart do zero. Funciona? Code samples de 5 endpoints aleatórios: funcionam? Search terms sem resultado: content gaps para criar. Sandbox — criar conta nova, provisionar, testar magic values, webhook tester. Tudo funciona? SDK — latest version instala sem erros? README quickstart funciona? Issues no GitHub? Changelog — todas as mudanças dos últimos 3 meses foram comunicadas? Breaking changes seguiram protocol? Developer interviews — falar com 2-3 developers ativos. 'O que é mais difícil? O que melhoraria?' Se revisão não identifica pelo menos uma melhoria: ou DX é perfeita (improvável) ou revisão é superficial."
		dependsOn: ["dx-developer-journey", "dx-documentation-excellence", "dx-sandbox-testing", "dx-sdk-tooling", "dx-developer-onboarding", "dx-changelog-migration", "dx-developer-success-metrics", "dx-developer-as-growth-channel"]
		rationale: "DX degrada silenciosamente — quickstart que funcionava quebra porque SDK atualizou, docs desatualiza, sandbox provisioning fica lento. A revisão periódica mantém DX como produto live, não como artefato estático."
	},
]

reasoningProtocol: [
	{
		question:  "Quanto tempo developer leva do signup até primeira chamada bem-sucedida (TTFHW)? O quickstart funciona copy-paste?"
		reveals:   "Se primeiro contato do developer com a API é positivo — ou se 15 minutos de frustração afasta antes de começar."
		rationale: "TTFHW 2022+: benchmark <15min. Quickstart que não funciona copy-paste é quickstart que não funciona."
	},
	{
		question:  "Docs estão organizados em 4 tipos (tutorials, how-to, reference, explanation)? Code samples são testados em CI?"
		reveals:   "Se documentação serve cada necessidade do developer — ou se é monólito que não serve nenhuma bem."
		rationale: "Procida 2023: Diátaxis. Docs-as-code 2020+: testável, deployável. Code sample que não funciona destrói trust."
	},
	{
		question:  "Sandbox tem magic values para todos os cenários de decisão? Webhook tester? Error simulation? Auto-provisioning?"
		reveals:   "Se developer pode testar integração completa sem infra própria — ou se precisa de mock manual e ngrok."
		rationale: "Sandbox fidelity 2022+. Magic values Stripe 2014+. Sandbox que requer aprovação manual perde developer."
	},
	{
		question:  "SDKs são gerados da OpenAPI spec? Cobrem linguagens dos integradores? Têm typed models, retry, webhook verification?"
		reveals:   "Se SDK é multiplicador de produtividade — ou se é wrapper fino que não justifica dependência."
		rationale: "SDK generation 2023+. SDK que não adiciona valor sobre raw HTTP é overhead sem benefício."
	},
	{
		question:  "Breaking changes seguem protocol (90 dias, migration guide, reminder, error amigável no sunset)?"
		reveals:   "Se integrador confia na estabilidade — ou se vive com medo de integração quebrar sem aviso."
		rationale: "Stripe breaking change protocol 2019+. Trust institucional em API é proporcional à previsibilidade de mudanças."
	},
	{
		question:  "Funnel de developer (signup → production) está medido? Qual step tem maior drop-off?"
		reveals:   "Se DX é gerenciada por dados — ou se é 'achamos que está bom' sem evidência."
		rationale: "Developer metrics 2023+. Step com 50% drop-off é o step que mais precisa de investimento."
	},
	{
		question:  "Developers/integradores são vistos como canal de growth? Integrations live × reach são rastreados?"
		reveals:   "Se DX é investimento em distribution — ou se é custo de compliance ('precisamos de API docs')."
		rationale: "DLG 2023+. Integration as distribution 2023+. 1 ERP integrado = centenas de construtoras alcançáveis."
	},
]

meshExamples: [
	{
		id:       "ex-quickstart-optimization"
		scenario: "TTFHW medido é 42 minutos. Funnel: signup 100% → API key 95% → first call 60% → first success 40%. Drop-off de 55% entre API key e first successful call."
		analysis: "Developer que obteve API key mas não conseguiu fazer primeira chamada com sucesso: 55% perdidos. Causas possíveis: (1) quickstart code sample não funciona (SDK version incompatível, import errado, endpoint mudou). (2) error messages não ajudam ('400 Bad Request' sem detalhe). (3) sandbox provisioning lento (developer clica 'send' mas sandbox não está pronto). (4) authentication confusa (onde coloco API key? Header? Query param?). (5) code sample requer setup não-documentado (variável de ambiente, dependência)."
		recommendation: "(1) Execute quickstart do zero — criar conta nova, seguir cada step literalmente. Onde falha? Se code sample não funciona: fix imediatamente + CI test para nunca quebrar novamente. (2) Error messages — para os 5 erros mais comuns em first call: garantir que response inclui: o que está errado, por que, e como corrigir. Exemplo: 'Authentication failed. API key não encontrada no header Authorization. Formato esperado: Authorization: Bearer sk_test_xxx. Verifique que está usando API key de sandbox (começa com sk_test_).' (3) Sandbox readiness — após signup: sandbox deve estar pronto em <10 segundos. Se provisionamento leva 2 minutos: developer abandona. Se não pode ser instantâneo: progress indicator ('configurando seu ambiente de teste... 30s'). (4) Authentication simplificada — API key no header Authorization: Bearer. Nada mais. Sem OAuth para sandbox. Sem token refresh para teste. Simplificar para TTFHW, não para segurança. (5) Zero-dependency quickstart — code sample que funciona com curl (zero install): 'curl -X POST https://sandbox.mesh.com/v1/operations/simulate -H \"Authorization: Bearer sk_test_xxx\" -H \"Content-Type: application/json\" -d '{\"buyer_cnpj\": \"11.111.111/0001-11\", \"value\": 50000}'. Se curl funciona: problema não é API — é SDK/setup. Se curl não funciona: problema é API/sandbox. (6) Medir post-fix: TTFHW deve cair de 42min para <15min. First success rate deve subir de 40% para >75%."
		principlesApplied: ["ax-01", "ax-02", "dp-01"]
		assumptions: [
			"55% de drop-off é medição real — tracking pode ter gaps",
			"quickstart com curl resolve a maioria dos issues de first call — se problema é conceitual (developer não entende domínio): curl não ajuda",
			"10 segundos de sandbox provisioning é factível — depende de infraestrutura",
			"API key no header é suficiente para sandbox — produção pode requerer OAuth",
		]
		rationale: "TTFHW 2022+: benchmark <15min. Zero-friction 2023+. Na Mesh, 42min de TTFHW com 55% de drop-off significa que a maioria dos developers que tentam integrar falham na primeira tentativa — cada developer perdido é integração (e distribution) perdida."
	},
	{
		id:       "ex-erp-integration-partnership"
		scenario: "Sienge (ERP líder em construção civil no Brasil com 500+ construtoras) demonstra interesse em integrar com Mesh. É a maior oportunidade de distribution via developer channel."
		analysis: "1 integração com Sienge = distribuição potencial para 500+ construtoras. Cada construtora que ativa Mesh via Sienge traz seus fornecedores. Multiplier: 500 construtoras × 20 fornecedores = 10.000 fornecedores potenciais. ROI de investir em DX excepcional para Sienge é desproporcional. Mas: Sienge tem equipe técnica com padrões próprios. Integração precisa ser deep (embedded experience, não apenas link externo). Timeline de Sienge pode ser longa (enterprise). DX precisa ser impecável para que equipe do Sienge avance sem depender de suporte constante da Mesh."
		recommendation: "(1) Dedicated DX: para Sienge, ir além de docs e sandbox genéricos. (a) Partner guide: documentação específica para ERPs — 'Integrating Mesh into your ERP: architecture guide.' Cobre: embedded UI patterns, data sync bidirectional, webhook handling, error recovery. (b) Sienge-specific sandbox: sandbox pré-populado com dados que simulam construtora usando Sienge. (c) Dedicated Slack channel: para equipe técnica do Sienge — response time <4h. (2) Co-design integration: não 'aqui está a API, integrem' — 'vamos projetar juntos a experiência ideal.' Sessões de design com equipe do Sienge. Entender: como construtora usa Sienge? Onde antecipação faz sentido no fluxo? Como embedding deve funcionar? Co-design resulta em integração que é natural para usuário do Sienge, não bolted-on. (3) Technical support: engineer dedicado para primeiras 4 semanas de integração. Code review de integração do Sienge. Pair programming se necessário. Investimento: alto. Return: 500+ construtoras alcançáveis. (4) Beta program: antes de launch público, 3-5 construtoras do Sienge testam integração. Feedback → iterar → launch. (5) Co-marketing: anúncio conjunto: 'Sienge + Mesh: antecipação de recebíveis integrada ao ERP.' Webinar conjunto. Case study de construtora beta. (6) medir: time-to-integration (do kickoff ao first beta user). Target: <8 semanas. Post-launch: % de construtoras Sienge que ativam Mesh em 6 meses. Target: >5% (25 construtoras). Revenue attributable ao channel."
		principlesApplied: ["ax-01", "ax-03", "ax-07"]
		assumptions: [
			"Sienge está disposto a co-develop — pode preferir integração self-service sem envolvimento da Mesh",
			"500+ construtoras é base ativa — nem todas são target para antecipação",
			"8 semanas para integration é realista — enterprise integration pode levar 4-6 meses",
			"5% de ativação em 6 meses é conservador — depende de marketing do Sienge e product-market fit",
		]
		rationale: "Integration as distribution 2023+. Developer ecosystem as moat 2024+. Na Mesh, Sienge integrado é o growth hack mais poderoso: 1 integração que distribui para centenas de construtoras. Investir DX excepcional (co-design, dedicated support, partner guide) é proporcional ao retorno."
	},
	{
		id:       "ex-breaking-change-communication"
		scenario: "Mesh precisa adicionar campo obrigatório 'registration_type' em POST /operations (para compliance com nova regulação). 15 integradores ativos em produção serão afetados."
		analysis: "Breaking change: request que antes era válida sem 'registration_type' será rejeitada. 15 integradores precisam atualizar código. Se implementar sem aviso: 15 integrações quebram em produção. Operações de antecipação falham. Fornecedores não recebem dinheiro. Trust de integradores destruída. Se comunicar com protocol: integradores atualizam com tempo, zero downtime."
		recommendation: "Protocol de 90 dias: (1) Dia 0 — announce: (a) Changelog entry: 'Breaking change: campo registration_type será obrigatório em POST /operations a partir de [data, +90 dias]. Valores aceitos: definitiva, condicional. Migration guide: [link].' (b) Email para 15 integradores: subject 'Ação necessária: atualização de API até [data].' Body: o que muda, por que (compliance regulatória), o que fazer (adicionar campo), migration guide, timeline, e suporte ('dúvidas? Responda este email ou Slack #api-support'). (c) Banner no developer portal: 'Breaking change em 90 dias. [Ver detalhes].' (d) SDK update: versão nova que inclui campo. Versão antiga loga warning ('registration_type será obrigatório a partir de [data]'). (2) Dia 60 — reminder: email para integradores que não atualizaram (verificar via API: chamadas de produção sem campo). 'Faltam 30 dias. Verificamos que sua integração ainda não inclui registration_type. [Migration guide] [Precisa de ajuda? Agende call].' (3) Dia 85 — final notice: email urgente para integradores remanescentes. 'Em 5 dias, chamadas sem registration_type serão rejeitadas. [Migration guide] [Suporte prioritário].' (4) Dia 90 — enforcement: (a) chamadas sem campo retornam 400 com message clara: 'Campo registration_type é obrigatório desde [data]. Valores aceitos: definitiva, condicional. Migration guide: [link].' Não 500 genérico. (b) Se integrador crítico (ERP com muitas construtoras) não migrou: considerar grace period adicional de 7 dias com notificação diária. (5) Post-migration: confirmar com cada integrador que migração está funcional. 'Verificamos que sua integração está atualizada. Obrigado pela colaboração.' (6) Documentar: ADR 'Breaking change registration_type: anunciada [data], enforcement [data], 15 integradores migrados, 0 downtime.' Para próximo breaking change: replicar protocol."
		principlesApplied: ["ax-01", "ax-02", "ax-06"]
		assumptions: [
			"90 dias é suficiente — integradores enterprise podem precisar de mais (sprint planning, release cycle)",
			"API pode verificar quais integradores não migraram — requer tracking de chamadas por integrador",
			"grace period para integrador crítico é aceitável regulatoriamente — verificar deadline da regulação",
			"15 integradores é gerenciável com email individual — para 150: automação necessária",
		]
		rationale: "Stripe breaking change protocol 2019+. API lifecycle communication 2024+. Na Mesh, 15 integrações quebrando em produção porque breaking change não foi comunicada = 15 construtoras sem antecipação + 15 integradores que nunca confiam novamente. Protocol de 90 dias previne."
	},
	{
		id:       "ex-developer-growth-measurement"
		scenario: "Mesh quer entender se investimento em DX está gerando growth. 6 meses de developer portal live, 45 developers cadastrados, 8 integrações em produção."
		analysis: "45 developers, 8 em produção = 18% conversion rate (sandbox→production). Bom? Depende de benchmark e contexto. Para B2B API fintech: 15-25% é típico. 18% é within range. Mas: 8 integrações servem quantos end-users? Se 3 são ERPs que servem 200 construtoras: reach é alto. Se 8 são integrações custom de construtoras individuais: reach é baixo. DX investment ROI = integrations × reach per integration."
		recommendation: "(1) Segmentar por tipo: dos 8 integradores em produção: quantos são ERPs (high reach), quantos são construtoras (medium reach), quantos são fintechs (variable reach)? (2) Calcular reach: ERP com 200 construtoras + 2 construtoras custom + 1 fintech com 50 clientes = reach total de 252 clientes potenciais. Se 10% ativam: 25 construtoras via developer channel sem founder selling. (3) Funnel detalhado: 45 signups → 38 first call → 28 first success → 20 sandbox active → 12 production applied → 8 production live. Drop-offs: signup→first call: 84% (good). First call→success: 74% (ok — can improve). Sandbox→production applied: 60% (some evaluating and leaving). Applied→live: 67% (go-live process has friction). (4) Ações por drop-off: first call→success 74%: error messages e quickstart podem melhorar (target: >85%). Sandbox→applied 60%: developers que usam sandbox mas não aplicam para produção — why? Survey: 'o que impediu de ir para produção?' Possível: pricing, missing feature, integration complexity. Applied→live 67%: go-live process tem friction — simplificar checklist, oferecer dedicated support para go-live. (5) Developer channel attribution: para cada construtora que entra na Mesh: como entrou? Se 'via Sienge' ou 'via integração': atribuir ao developer channel. Medir: % de construtoras adquiridas via developer channel vs founder-led vs referral. Target em 12 meses: >20% via developer channel. (6) ROI: investimento em DX (tempo de engineering + tools + docs) vs receita atribuível a integrações live. Se 8 integrações geraram 25 construtoras que geraram R$X de receita: ROI = R$X / investment."
		principlesApplied: ["ax-01", "ax-07"]
		assumptions: [
			"18% conversion é benchmark adequado — varia por vertical e complexidade de integração",
			"reach per integration é estimável — depende de ativação do ERP partner",
			"survey de developers que não converteram produz insight acionável — developer pode não responder",
			"developer channel attribution é possível — requer tracking de source por construtora",
		]
		rationale: "Developer metrics 2023+. Integration as distribution 2023+. Na Mesh, 8 integrações em produção parece pouco — mas se 3 são ERPs com 200 construtoras: developer channel alcança 200 construtoras sem sales adicional. DX ROI é função de reach, não apenas de count."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-api-design-as-product"
		relation: "complementsWith"
		context:  "API define design técnico (resource modeling, versioning, error design, sandbox patterns). DX define experiência end-to-end do desenvolvedor ao usar a API. API é o que é oferecido; DX é como é experimentado. API projeta a sandbox; DX projeta o auto-provisioning e webhook tester. API define error codes; DX define error messages que ensinam."
	},
	{
		lensId:   "lens-jobs-to-be-done-and-workflow-design"
		relation: "complementsWith"
		context:  "JTBD projeta experiência para end-users (fornecedor, construtora). DX projeta experiência para developers. Princípios são compartilhados: TTV rápido, friction mapping, progressive disclosure, activation metrics. JTBD é UX; DX é developer UX. Ambos seguem: entender job (developer quer integrar rápido), mapear friction, medir activation."
	},
	{
		lensId:   "lens-cold-start-and-network-bootstrapping"
		relation: "complementsWith"
		context:  "CS define transition de manual para organic growth. DX developer-as-growth é um dos loops que habilita transição: ERP integrado distribui Mesh para clientes do ERP sem founder selling. CS é a estratégia de bootstrap; DX é um dos mecanismos de growth (developer channel)."
	},
	{
		lensId:   "lens-knowledge-management"
		relation: "complementsWith"
		context:  "KM define knowledge as code e documentation standards. DX documentation-excellence é KM aplicada a developers: docs versionadas, testadas, deployadas por CI/CD. KM governa documentação interna (mesh-spec); DX governa documentação externa (API docs). Mesmos princípios: docs-as-code, freshness, ownership."
	},
	{
		lensId:   "lens-trust-and-credibility-design"
		relation: "complementsWith"
		context:  "TC constrói trust. DX constrói trust para developers: docs profissionais (first impression), sandbox funcional (ability), breaking change protocol (integrity), support responsivo (benevolence). TC é trust para end-users; DX é trust para developers. Mesmos 3 pilares: ability, benevolence, integrity — manifestados diferentemente."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI monitora API health (uptime, latência). DX monitora developer health (TTFHW, funnel, NPS). OOI é SLO técnico; DX é SLO de experiência. API pode estar 99.99% up (OOI) com TTFHW de 2h (DX ruim). Ambos necessários."
	},
	{
		lensId:   "lens-stakeholder-communication"
		relation: "complementsWith"
		context:  "SC comunica com stakeholders. DX comunica com developers via changelog, migration guides, status page. SC é communication framework; DX aplica para audience técnica. Mesmos princípios: transparência, antecipação, credibilidade. Aplicação diferente: developers preferem changelog técnico a newsletter genérica."
	},
	{
		lensId:   "lens-data-quality-as-competitive-moat"
		relation: "complementsWith"
		context:  "DQ modela dados como moat. DX integrações geram dados (ERPs integrados enviam dados de faturamento, operações). Cada integração é data acquisition channel. DQ diz 'exhaust capture'; DX diz 'integração com ERP captura dados de faturamento como exhaust — custo: zero (integrador envia no fluxo normal)'."
	},
]

limitations: [
	{
		description: "DX excepcional requer investimento contínuo em docs, sandbox, SDKs, e tooling — que compete com investimento em produto core. Solo founder pode não ter bandwidth para manter DX excepcional e produto simultamente."
		alternative: "Proporcional ao estágio: pré-revenue — docs + sandbox básico (curl examples, auto-provisioning). Tração — SDKs gerados + interactive docs. Escala — developer portal completo + partner program. Não investir em developer portal premium antes de ter 10 integradores potenciais."
		rationale: "DX investment deve ser proporcional ao número e importância de integradores. DX premium para 2 integradores é over-investment."
	},
	{
		description: "Developer-led growth assume que developers têm poder de decisão ou influência na organização do cliente. Em construção civil, decisão de adotar fintech pode ser do CFO, não do developer."
		alternative: "DLG puro pode não funcionar em construção civil. Modelo híbrido: developer faz POC (bottom-up), CFO aprova (top-down). DX habilita POC rápido (sandbox, quickstart); sales fecha com CFO usando resultados do POC. Developer é facilitador, não decisor."
		rationale: "Construção civil é setor tradicional — decision maker é C-level, não developer. DLG funciona melhor quando developer tem agency. Adaptar para modelo híbrido."
	},
	{
		description: "SDK gerado automaticamente pode ter DX inferior a SDK artesanal — nomes de métodos genéricos, patterns não-idiomáticos, documentação auto-gerada sem nuance."
		alternative: "Gerar e depois customizar: auto-generate como base, polish manualmente os 5 métodos mais usados (criar operação, consultar status, configurar webhook). 80% auto-gerado + 20% polido = sustentável com boa DX."
		rationale: "100% auto-gerado: sustentável mas DX mediana. 100% manual: DX boa mas insustentável. Híbrido é sweet spot."
	},
	{
		description: "Métricas de DX (TTFHW, funnel) são ruidosas com poucos developers — 45 signups não geram estatística significativa por step."
		alternative: "Complementar quantitativo com qualitativo: falar com 3-5 developers que abandonaram em cada step. 'O que impediu?' Um insight qualitativo de developer frustrado vale mais que conversion rate com n=10."
		rationale: "Quantitativo com amostra pequena guia; qualitativo explica. Ambos necessários em early-stage."
	},
	{
		description: "Framework assume API como interface primária. Se integradores preferem no-code (Zapier, n8n) ou embedded UI (iframe, widget): DX de API é insuficiente."
		alternative: "Oferecer múltiplas interfaces de integração: API (para developers), widget embeddable (para low-code), Zapier/n8n connector (para no-code). Cada interface tem DX própria. Priorizar por segmento de integrador."
		rationale: "Nem todo integrador é developer. Construtora PME pode preferir widget a API. ERP enterprise prefere API. Progressive tooling cobre todos."
	},
]

rationale: "Toda plataforma B2B que pretende escalar além de integrações manuais precisa de experiência de integrador excepcional. Na Mesh como plataforma AI-native com ERPs, fintechs e equipes técnicas de construtoras como integradores, DX é canal de distribution que multiplica alcance. Esta lens operacionaliza: jornada do developer de discover a advocate com developer-led growth (Reddy 2020, TTFHW 2022+, DLG Redpoint/Heavybit 2023+, Fagerholm/Munch 2012), documentação como produto com Diátaxis e docs-as-code (Procida 2023, docs-as-code 2020+, interactive docs Mintlify 2023+), sandbox high-fidelity com magic values e error simulation (sandbox fidelity 2022+, Stripe magic values 2014+, PactFlow 2022+), SDKs gerados com progressive tooling (SDK generation Stainless/Speakeasy 2023+, progressive tooling 2024+), onboarding com TTFHW <15min e zero-friction (developer activation 2023+, zero-friction 2023+, quickstart 2022+), changelog e migration com breaking change protocol de 90 dias (Stripe 2019+, API lifecycle 2024+), métricas de developer success com funnel e NPS (developer metrics 2023+, DevRel 2023+), e developer como canal de growth com integration-as-distribution (DLG Redpoint 2023+, integration as distribution 2023+, developer ecosystem as moat 2024+). Universal, agnóstica a estágio, aplicável a qualquer plataforma B2B com API como interface de integração."

}
