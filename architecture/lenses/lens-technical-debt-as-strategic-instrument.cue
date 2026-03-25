package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

technicalDebtAsStrategicInstrument: artifact_schemas.#AnalyticalLens & {
id:     "lens-technical-debt-as-strategic-instrument"
name:   "Dívida Técnica como Instrumento Estratégico"

purpose: "Orientar decisões sobre quando aceitar e quando pagar dívida técnica — debt como ferramenta estratégica com registro, juros e plano de pagamento."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve aceitar implementação subótima deliberadamente para ganhar velocidade",
		"a decisão envolve quando e como pagar dívida técnica acumulada",
		"a decisão envolve trade-off entre velocidade de entrega e qualidade/manutenibilidade do código",
		"a decisão envolve como priorizar refactoring contra features novas",
		"a decisão envolve como medir e comunicar impacto de dívida técnica na velocidade de desenvolvimento",
		"a decisão envolve como evitar que dívida técnica acumule além do ponto onde paralisa desenvolvimento",
		"a decisão envolve como distinguir dívida técnica deliberada (estratégica) de acidental (negligência)",
		"a decisão envolve como projetar sistemas para que dívida técnica seja contida em módulos, não sistêmica",
		"a decisão envolve como agentes IA acumulam e gerenciam dívida técnica em contexto de development contínuo",
	]
	keywords: [
		"dívida técnica", "technical debt", "tech debt",
		"refactoring", "rewrite", "cleanup", "limpeza",
		"velocidade", "velocity", "throughput", "delivery speed",
		"qualidade", "quality", "manutenibilidade", "maintainability",
		"shortcut", "atalho", "hack", "workaround", "gambiarra",
		"legacy", "legado", "acúmulo", "accrual",
		"juros", "interest", "custo composto", "compound cost",
		"trade-off", "speed vs quality", "rápido vs correto",
		"modularity", "isolamento", "blast radius de debt",
		"sprint tax", "overhead", "slowdown",
		"boy scout rule", "broken windows", "entropy",
	]
	excludeWhen: [
		"a decisão é sobre alocação de recursos em geral — usar organizational-resource-allocation",
		"a decisão é sobre arquitetura de sistemas distribuídos — usar distributed-systems-design",
		"a decisão é sobre cross-cutting concerns — usar cross-cutting-concern-integration",
		"a decisão é sobre documentação como produto — usar documentation-as-product",
		"a decisão é sobre decisões reversíveis vs irreversíveis em geral — usar real-options",
	]
	rationale: "Toda organização que constrói software acumula dívida técnica — implementações subótimas que funcionam hoje mas criam custo futuro. A metáfora de Cunningham (1992) é financeira: assim como dívida financeira, dívida técnica tem principal (custo de corrigir) e juros (custo contínuo de operar com a dívida). Dívida técnica não é inerentemente ruim — é instrumento. Empresa que nunca assume dívida técnica move devagar demais. Empresa que assume demais fica paralisada por juros. Na Mesh AI-native operada por agentes, dívida técnica tem dinâmica diferente: agentes geram código em volume — podem acumular dívida mais rápido que humanos. Mas agentes também podem pagar dívida mais rápido (refactoring automatizado). ORA cobre alocação de recursos; RO cobre decisões reversíveis; DSD cobre arquitetura. Esta lens cobre como usar dívida técnica como instrumento estratégico — quando assumir, como conter, como medir, e quando pagar."
}

concepts: [
	{
		id:         "td-debt-quadrant"
		name:       "Quadrante de Dívida: Deliberada vs Acidental, Prudente vs Imprudente"
		nature:     "theoretical"
		role:       "framework"
		definition: "Fowler (2009, 'Technical Debt Quadrant'): dívida técnica classificada em 2 dimensões: (1) deliberate vs inadvertent — tomou a decisão conscientemente ou não percebeu? (2) prudent vs reckless — decisão era razoável dadas as circunstâncias ou era negligência? 4 quadrantes: (a) deliberate-prudent: 'sabemos que este design não é ótimo, mas precisamos entregar agora e refatorar depois.' Melhor tipo — decisão informada com plano de pagamento. (b) deliberate-reckless: 'não temos tempo para fazer direito.' Sem plano de pagamento — acumula juros. (c) inadvertent-prudent: 'agora que entendemos o domínio melhor, percebemos que o design deveria ser diferente.' Natural — aprendizado gera debt em implementações anteriores. (d) inadvertent-reckless: 'não sabíamos o que estávamos fazendo.' Negligência — debt acumulada por falta de skill ou cuidado. Conceito contemporâneo de 'debt as investment' (Allman 2012, evoluído 2023+): dívida técnica deliberada-prudente é investimento — gasta principal (custo de corrigir depois) para obter retorno (velocidade agora). ROI: se velocity gained × time-to-market value > cost of fixing + interest accrued: debt was good investment. Conceito de 'interest rate of debt' (2022+): nem toda dívida tem mesma taxa de juros. Debt em módulo isolado que raramente muda: juros baixos (custo contínuo mínimo). Debt em módulo central que todo mundo toca: juros altos (custo contínuo amplificado por cada interação)."
		meshManifestation: "Na Mesh, exemplos por quadrante: (1) deliberate-prudent — 'usamos PostgreSQL como event store (Marten) em vez de EventStoreDB dedicado porque já temos PostgreSQL e o custo de operar novo database não se justifica com 100 operações. Quando escala justificar: migrar.' Plan: ADR documentado, migration path identificado, trigger definido (>10k eventos/mês). (2) deliberate-reckless — 'scoring model v1 hardcoda features no código porque é mais rápido que feature store.' Sem plan de migração, sem trigger. Features adicionadas depois requerem deploy a cada mudança. (3) inadvertent-prudent — 'desenhamos ECL com 5 estados. Depois de operar 6 meses, percebemos que precisamos de 7 (estado de 'em disputa'). Refactor necessário.' Natural — domínio é melhor entendido com operação. (4) inadvertent-reckless — 'agente gerou 15 endpoints com patterns inconsistentes (alguns REST, alguns RPC, error formats diferentes) porque CLAUDE.md não tinha guideline de API design.' Falta de governance gerou debt."
		meshImplication: "Para cada decisão que gera debt: (1) classificar no quadrante — é deliberada? É prudente? (2) para deliberate-prudent: ADR obrigatório com: o que é a debt, por que assumiu, qual o custo estimado de pagar, qual o trigger para pagar (volume, equipe, regulação), e qual o interest rate (módulo central vs isolado). (3) para deliberate-reckless: flag como risk — debt sem plan é debt que acumula indefinidamente. Converter em deliberate-prudent adicionando plan. (4) para inadvertent-prudent: natural e saudável — registrar como debt quando percebida, planejar pagamento. Não é falha — é aprendizado. (5) para inadvertent-reckless: root cause analysis — por que debt foi criada sem perceber? Falta de governance? Falta de review? Agente sem guideline? Fix root cause + pay debt. (6) em contexto AI-native: agentes geram código que pode ser deliberate-prudent (instruído a simplificar) ou inadvertent-reckless (sem guideline gera padrão inconsistente). CLAUDE.md e mesh-spec como guardrails reduzem inadvertent debt. Code review (humano ou agente reviewer) catch antes de merge. Anti-pattern: toda dívida técnica tratada como 'negligência' — deliberate-prudent é instrumento legítimo que acceleration-stage startups precisam usar."
		rationale: "Fowler 2009: quadrante. Allman 2012: debt as investment. Interest rate 2022+. Na Mesh, dívida técnica deliberada-prudente (PostgreSQL como event store) é investimento que preserve constraint (founder time) para throughput máximo (features). Dívida reckless (patterns inconsistentes) é custo sem retorno."
	},
	{
		id:         "td-interest-rate-assessment"
		name:       "Taxa de Juros da Dívida: Quanto Custa Manter vs Pagar"
		nature:     "theoretical"
		role:       "property"
		definition: "Cunningham (1992): dívida técnica acumula juros — custo contínuo de operar com implementação subótima. Juros se manifestam como: (1) velocity tax — cada feature nova leva mais tempo por causa de workarounds. (2) bug rate — implementação frágil gera mais bugs. (3) cognitive load — developer/agente precisa entender e navegar complexidade desnecessária. (4) risk — debt em módulo crítico pode causar incident. (5) onboarding cost — novo developer/agente leva mais tempo para entender sistema com debt. Conceito de 'debt interest rate' (Tornhill 2022, 'Software Design X-Rays'): medir interest pela frequência de interação com o módulo endividado. Módulo com debt que é tocado 50x/mês: juros altos (cada interação paga juros). Módulo com debt tocado 1x/ano: juros desprezíveis. Priorizar pagamento por interest rate, não por 'feiúra' do código. Conceito contemporâneo de 'compound interest in tech debt' (2023+): debt interage com debt — módulo A com debt torna módulo B (que depende de A) mais difícil de mudar. Debt compounds: custo de mudar B inclui custo de navegar debt de A. Quanto mais modules com debt interdependentes: compound interest acelera."
		meshManifestation: "Na Mesh, debt por interest rate: (1) alta taxa de juros — scoring pipeline com features hardcoded: toda feature nova requer code change + deploy + regression test. Tocado ~2x/mês (feature iteration). Interest: ~4h/mudança × 2 mudanças/mês = 8h/mês. Em 6 meses: 48h = 1 semana+ de trabalho em juros. (2) média taxa — API error messages inconsistentes (alguns RFC 9457, alguns custom format): toda integração nova requer documentar ambos formatos. Tocado ~1x/mês (novo integrador). Interest: ~2h/mês. (3) baixa taxa — script de setup de ambiente que tem steps manuais: incomoda mas usado 1x a cada 2 meses. Interest: ~1h/bimestre. (4) compound — scoring pipeline com features hardcoded + feature store não-implementado + model versioning manual: 3 debts interagem — mudar qualquer coisa no scoring requer navegar 3 debts. Compound interest: 12h/mudança em vez de 4h."
		meshImplication: "Priorizar pagamento por interest rate: (1) para cada debt conhecida: estimar interest rate = (horas de overhead por interação) × (frequência de interação por mês). Sort by descending. Top 3: prioridade de pagamento. (2) identify compound debt: debts que interagem e amplificam custo. Se 3 debts no scoring pipeline compõem para 12h/mudança: pagar as 3 juntas (não 1 isolada — benefit é maior combinado). (3) interest rate threshold: se interest > 10h/mês: pagar urgentemente (debt consome >25% de capacity semanal). Se 2-10h/mês: planejar no próximo ciclo. Se <2h/mês: backlog (pagar quando conveniente). (4) não pagar debt com interest rate zero: módulo que funciona, nunca é tocado, e não interage com nada: debt teórica sem juros. Pagar é custo sem benefício. Refactoring de código que ninguém toca é vanity, não strategy. (5) comunicar interest em termos tangíveis: não 'precisamos refatorar porque código é feio.' Sim: 'scoring pipeline tem debt que custa 8h/mês. Pagar custa 20h. Payback: 2.5 meses. Depois: economia permanente de 8h/mês.' ROI quantificado. Anti-pattern: priorizar debt pela 'gravidade técnica' (código duplicado é 'grave' mas se nunca é tocado: interest rate zero). Priorizar por impact, não por purismo."
		dependsOn: ["td-debt-quadrant"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-cost-of-delay"
			context:   "ORA modela cost of delay — valor perdido por não entregar feature. TD interest rate é custo contínuo de não pagar debt. Trade-off: pagar debt agora (investimento) para reduzir interest (saving futuro) vs entregar feature agora (revenue) e pagar debt depois (com juros acumulados). ORA quantifica o trade-off; TD fornece os dados (interest rate) para a decisão."
		}]
		rationale: "Cunningham 1992: juros de debt. Tornhill 2022: interaction frequency como proxy de interest rate. Compound interest 2023+. Na Mesh, scoring pipeline com 8h/mês de juros e 20h de payoff: payback em 2.5 meses. Não pagar: 48h de juros em 6 meses. Decisão é financeira, não estética."
	},
	{
		id:         "td-debt-containment"
		name:       "Contenção de Dívida: Limitar Blast Radius do que Foi Aceito"
		nature:     "theoretical"
		role:       "method"
		definition: "Conceito de 'debt containment' (2022+): quando dívida técnica é assumida deliberadamente, conter em módulo isolado para que juros não se propaguem. Analogia: incêndio controlado — fogo em uma sala, não em todo o prédio. Patterns: (1) anti-corruption layer (ACL) — módulo com debt comunica com o resto via interface limpa. Debt é interna; interface é saudável. Quando debt é paga: interface não muda — consumidores não percebem. (2) feature flag isolation — funcionalidade com debt é flag-gated. Se debt causa problema: desabilitar flag sem afetar rest. (3) bounded context boundary — debt em BC isolado não contamina outros BCs. Cada BC pode ter debt level diferente. Conceito contemporâneo de 'debt surface area' (2023+): superfície da debt é quantos módulos/consumidores são afetados. Debt com 1 consumidor: surface area = 1 (contida). Debt com 20 consumidores: surface area = 20 (sistêmica). Reduzir surface area antes de acumular debt."
		meshManifestation: "Na Mesh, containment por debt: (1) scoring pipeline com features hardcoded — debt contida se: scoring pipeline tem interface limpa (input: buyer_id → output: score + shap_values). Internamente: features hardcoded. Externamente: consumidor não sabe. Quando migrar para feature store: interface não muda — scoring pipeline internamente refatorado, consumidores inalterados. ACL funciona. (2) PostgreSQL como event store (em vez de EventStoreDB) — debt contida porque: event store é acessado via repository interface. Se migrar para EventStoreDB: mudar implementation, interface permanece. Consumers (projeções, replay) não percebem. (3) API error messages inconsistentes — debt NÃO contida: 15 integradores consumem diretamente. Cada formato diferente é surface area. Corrigir: standardizar em RFC 9457 — mas 15 integradores precisam adaptar. Surface area alta = custo alto de pagamento. Deveria ter sido contido desde o início (error formatting via middleware, não por endpoint)."
		meshImplication: "Conter antes de assumir: (1) para cada decisão de debt: antes de assumir, perguntar 'qual é a surface area? Quantos consumidores são afetados? Se precisar pagar: quantos precisam mudar?' (2) surface area target: debt deliberada deve ter surface area ≤ 3. Se >3: conter com ACL ou interface antes de assumir. (3) ACL como pattern padrão: quando assumir debt em módulo: implementar interface limpa entre módulo e consumidores. Custo de ACL: pequeno. Benefício: quando pagar debt, consumidores são protegidos. (4) boundary as containment: debt em ECL não contamina NGR porque bounded context boundary isola. Cada BC pode ter debt level diferente. Debt em BC com poucos consumidores: contida naturalmente. (5) para agentes: quando agente gera implementação com debt conhecida: instruir a conter. CLAUDE.md: 'se implementação simplificada: isolar atrás de interface limpa. Documentar debt no código (// DEBT: features hardcoded, migrate to feature store when >20 features. ADR: xxx).' (6) monitoring: para cada debt conhecida: medir surface area trimestralmente. Se surface area cresce (mais consumidores usando módulo com debt): pagar antes que custo de pagamento cresça. Anti-pattern: debt em shared library usada por todo sistema — surface area = infinity. Qualquer mudança na library afeta tudo. Debt em shared library é debt sistêmica."
		dependsOn: ["td-debt-quadrant", "td-interest-rate-assessment"]
		crossDependsOn: [{
			lensId:    "lens-distributed-systems-design"
			conceptId: "dsd-consistency-at-boundary"
			context:   "DSD define ACL e contract evolution na fronteira entre BCs. TD debt containment usa ACL para isolar debt — debt é interna ao módulo; interface (contract) é limpa e estável. DSD é o pattern de boundary; TD é a aplicação para conter debt. DSD diz 'ACL protege consumidor de detalhes internos'; TD diz 'ACL protege consumidor de debt interna — quando pagar, consumidor não percebe'."
		}]
		rationale: "Debt containment 2022+. Debt surface area 2023+. ACL como containment. Na Mesh, debt em scoring pipeline com ACL (interface limpa): pagar = refactoring interno. Debt em API error format sem ACL: pagar = 15 integradores migram. Contenção antes de assumir é 10x mais barato que contenção depois."
	},
	{
		id:            "td-debt-inventory"
		name:          "Inventário de Dívida: Registro Explícito de Toda Debt Conhecida"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Conceito de 'tech debt register' (2022+): lista explícita de toda dívida técnica conhecida com: description, quadrant (deliberate/inadvertent × prudent/reckless), interest rate estimate, surface area, containment status, trigger for payment, and owner. Registro é o que torna debt gerenciável — debt não-registrada é debt invisível que acumula juros silenciosamente. Conceito contemporâneo de 'debt visibility as culture' (2023+): organizações que tratam debt como segredo ('não fale sobre tech debt') acumulam mais que organizações que tratam como fact ('debt existe, está registrada, e tem plano'). Visibilidade habilita priorização informada. Conceito de 'debt budget' (2024+): assim como budget financeiro, alocar % de capacity para pagamento de debt — 15-25% da capacity de engineering como maintenance/debt-payment. Se 0%: debt acumula até paralisar. Se 100%: zero features novas."
		meshManifestation: "Na Mesh, debt inventory como artefato no mesh-spec: (1) cada debt registrada com: id (td-NNN), description, quadrant, interest_rate (h/mês), surface_area (consumidores afetados), containment (ACL? bounded?), trigger_for_payment (volume? equipe? regulação?), estimated_cost_to_pay (horas), owner, created_date, status (active/planned/paid). (2) exemplos: td-001: 'Features de scoring hardcoded em código.' Quadrant: deliberate-prudent. Interest: 8h/mês. Surface: 1 (ACL). Trigger: >20 features ou model v3. Cost to pay: 20h. Owner: scoring-agent. td-002: 'API error messages inconsistentes.' Quadrant: inadvertent-reckless. Interest: 2h/mês. Surface: 15 integradores. Trigger: next API version. Cost to pay: 40h (migration guide + fix). Owner: api-agent. td-003: 'PostgreSQL como event store (Marten em vez de dedicado).' Quadrant: deliberate-prudent. Interest: 0h/mês (Marten funciona). Trigger: >10k eventos/mês com performance degradação. Cost to pay: 80h (migration). Owner: infra. Status: active (no trigger atingido)."
		meshImplication: "Debt inventory como prática: (1) registro obrigatório — toda debt deliberada: ADR + entry no inventory. Debt descoberta (inadvertent): registrar quando descoberta. Agente que implementa shortcut: comment no código (// DEBT: td-NNN) + entry no inventory. (2) review trimestral — para cada debt: interest rate mudou? Surface area cresceu? Trigger foi atingido? Se trigger atingido: planejar payment. Se interest rate subiu significativamente: reavaliar prioridade. (3) debt budget — alocar 20% do tempo de development para debt payment + maintenance. Se capacity = 160h/mês: 32h para debt. Priorizar: sort by interest rate descending, pagar top items até budget esgotado. (4) debt dashboard — total de debts ativas, total interest rate (h/mês), top 5 por interest rate, trend (growing? stable? shrinking?). Se total interest >25% da capacity: debt crisis — aumentar budget temporariamente. (5) debt in code — cada shortcut no código: comment com debt ID. `// DEBT: td-001 — features hardcoded. See mesh-spec/debt/td-001.` Agente que encontra debt no código: sabe contexto + plan sem investigar. (6) celebrate payment — quando debt é paga: ADR de closure + remoção do inventory. Comunicar: 'td-001 paga — scoring pipeline migrado para feature store. Interest eliminated: 8h/mês.' Anti-pattern: debt inventory que cresce indefinidamente sem pagamento — inventory vira lista de culpa, não ferramenta de gestão."
		dependsOn: ["td-debt-quadrant", "td-interest-rate-assessment", "td-debt-containment"]
		crossDependsOn: [{
			lensId:    "lens-knowledge-management"
			conceptId: "km-decision-records"
			context:   "KM define ADRs para decisões. TD debt inventory usa ADRs: cada debt deliberada tem ADR com rationale, trigger, e plan. Debt paga tem ADR de closure. KM é o framework de documentação; TD é a aplicação para dívida técnica. KM diz 'decisão não-documentada é decisão esquecida'; TD diz 'debt não-registrada é debt invisível que acumula juros silenciosamente'."
		}]
		rationale: "Tech debt register 2022+. Debt visibility as culture 2023+. Debt budget 2024+. Na Mesh, debt inventory no mesh-spec é consultável por agentes — agente que vai modificar scoring pipeline: consulta inventory e sabe que td-001 existe, qual o plan, e se trigger foi atingido."
	},
	{
		id:         "td-strategic-debt-decisions"
		name:       "Decisões Estratégicas de Debt: Quando Assumir É a Decisão Correta"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Conceito de 'speed vs quality spectrum' (2022+): não é binário (rápido OU bom) — é espectro onde cada decisão tem ponto ótimo baseado em contexto. Pre-PMF: velocidade > qualidade (está construindo a coisa certa?). Post-PMF scaling: qualidade ganha importância (sistema precisa suportar carga). Maturity: qualidade domina (estabilidade é expectativa). Conceito contemporâneo de 'debt as real option' (2023+): debt deliberada preserva opcionalidade — implementação simples agora permite pivotar se necessário. Se investir 80h em 'implementação perfeita' e domínio muda em 3 meses: 80h desperdiçadas. Se investir 20h em 'implementação com debt' e domínio muda: 20h desperdiçadas + debt descartada (pivot). Debt = option premium para manter flexibilidade. Conceito de 'reversibility as debt criterion' (conecta com RO): dívida em decisão reversível é menos custosa que em irreversível. Debt em código (refatorável): reversível. Debt em schema público de API (integradores dependem): difícil de reverter. Debt em contrato com FIDC: irreversível."
		meshManifestation: "Na Mesh, decisões estratégicas de debt: (1) pré-revenue: velocidade máxima com debt contida. PostgreSQL para tudo (event store, feature store, analytics). Scoring com features hardcoded. API com error handling básico. Razão: domínio não está validado — investir em 'implementação perfeita' de ECL com 7 estados pode ser desperdício se ECL muda para 5 estados após feedback real. (2) post-PMF: pagar debts com interest rate alto e assumir novas apenas se conteníveis. Migrar features de hardcoded para feature store (interest rate alto, trigger atingido). Manter PostgreSQL como event store (interest rate zero, trigger não atingido). (3) escala: pagar debts sistêmicas. Migrar event store se necessário. Standardizar error handling. API consistency. Debt residual: apenas low-interest, contained. Decisões que NÃO devem ter debt (irreversíveis): (a) schema de evento publicado (consumidores dependem — breaking change é caro). (b) API pública (integradores dependem). (c) modelo de dados de FIDC (contrato regulatório). (d) governance de segurança e compliance (non-negotiable). Para essas: investir tempo proporcional mesmo em early-stage."
		meshImplication: "Framework de decisão: (1) para cada decisão de implementação: 'qual o custo de fazer 'bem' vs 'bom o suficiente'? Se diferença é 2h: fazer bem (custo marginal baixo). Se diferença é 40h: avaliar.' (2) se diferença é significativa: 'a decisão é reversível?' Se reversível (código interno, implementação privada): debt deliberada-prudente aceitável com ADR + containment + trigger. Se irreversível (API pública, schema de evento, contrato): investir. (3) 'qual o interest rate esperado?' Se módulo vai ser tocado frequentemente: interest rate alto → investir. Se módulo vai ser estável por meses: interest rate baixo → debt aceitável. (4) 'qual o estágio do produto?' Pre-PMF: bias para velocidade (80% das implementações podem ter debt contida). Post-PMF: bias para qualidade (20% de debt aceitável, concentrada em low-interest). Escala: zero tolerance para debt em modules críticos. (5) decision tree simplificado: (a) irreversível? → investir em qualidade. (b) reversível + high interest rate? → investir. (c) reversível + low interest rate + pre-PMF? → debt com ADR. (d) reversível + low interest rate + post-PMF? → debt se pressão de tempo justifica, investir se não. (6) para agentes: CLAUDE.md com guidance: 'para implementações internas sem consumidores externos: simplificar é aceitável com DEBT comment + ADR. Para APIs públicas, schemas de eventos, e componentes de compliance: implementar corretamente — debt não é aceitável.' Anti-pattern: 'sempre fazer bem' que paralisa delivery pre-PMF — e 'sempre ser rápido' que acumula debt sistêmica post-PMF."
		dependsOn: ["td-debt-quadrant", "td-interest-rate-assessment", "td-debt-containment"]
		crossDependsOn: [{
			lensId:    "lens-real-options"
			conceptId: "ro-reversibility-assessment"
			context:   "RO modela reversibilidade de decisões. TD usa reversibilidade como critério: debt em decisão reversível (código interno) é opção barata — custo de reverter é baixo. Debt em decisão irreversível (API pública) é commitment caro — custo de reverter é alto. RO diz 'decisões reversíveis: velocidade. Irreversíveis: deliberação'; TD diz 'debt aceitável em reversíveis, investir em irreversíveis'."
		}]
		rationale: "Speed vs quality spectrum 2022+. Debt as real option 2023+. Reversibility criterion. Na Mesh pre-PMF, debt deliberada-prudente em implementações reversíveis é investimento em velocidade com opção de pivot. Debt em API pública ou schema de evento é custo que amplifica com cada consumidor."
	},
	{
		id:         "td-ai-native-debt-dynamics"
		name:       "Dinâmicas de Debt em Sistemas AI-Native: Agentes como Geradores e Pagadores"
		nature:     "theoretical"
		role:       "property"
		definition: "Conceito emergente de 'AI-generated tech debt' (2024+): agentes IA que geram código podem acumular debt em velocidade sem precedentes — código funcional mas inconsistente, patterns divergentes entre sessões, soluções que funcionam mas não se integram com arquitetura existente. Sem governance: cada sessão de agente pode gerar debt inadvertent. Com governance (CLAUDE.md, mesh-spec, CI): debt é contida. Conceito de 'AI as debt payer' (2024+): agentes também podem pagar debt mais rápido que humanos — refactoring automatizado, migration scripts, consistency fixes. Volume de código que agente pode refatorar em 1h: ordens de magnitude acima de humano. Conceito de 'session boundary problem' (2024+): agente não tem memória persistente entre sessões. Debt assumida na sessão 1 pode ser desconhecida na sessão 2 (que assume mais debt no mesmo módulo). Sem debt inventory consultável: debt compound sem visibilidade."
		meshManifestation: "Na Mesh operada por agentes: (1) debt generation risk — agente cria 3 endpoints numa sessão com pattern X. Na sessão seguinte (sem contexto): cria 2 endpoints com pattern Y. Resultado: 5 endpoints inconsistentes = debt inadvertent. CLAUDE.md mitiga (define patterns), mas context loss entre sessões é real. (2) debt payment opportunity — agente recebe instrução: 'refatorar scoring pipeline de features hardcoded para feature store.' Agente em 2h pode: identificar todas as features, criar feature store schema, migrar lógica, atualizar tests, gerar ADR. Humano levaria 2 dias. (3) session boundary — debt td-001 registrada no inventory. Sessão nova: agente consulta inventory antes de modificar scoring → sabe que debt existe → pode pagar ou trabalhar com (não cria mais debt no mesmo módulo). Sem inventory: agente trabalha no módulo sem saber da debt → compound."
		meshImplication: "Governance de debt em contexto AI-native: (1) CLAUDE.md como guardrail — patterns obrigatórios para agentes: 'API endpoints seguem RFC 9457 para errors. Event schemas seguem #EventSchema. Naming conventions: snake_case.' Reduz inadvertent debt por inconsistência. (2) mesh-spec como memory — debt inventory consultável pelo agente no início de cada sessão relevante. 'Antes de modificar scoring pipeline: consultar mesh-spec/debt/ para debts conhecidas neste módulo.' (3) CI como gate — linting e tests que detectam inconsistência: 'endpoint com error format não-RFC 9457 → CI failure.' Agente corrige antes de merge. (4) agente como debt payer — instrução periódica: 'revisar debt inventory. Para debts com trigger atingido: propor plan de pagamento.' Agente analisa, propõe, humano aprova, agente executa. (5) code review entre agentes — agente reviewer que verifica output de agente builder: 'este código segue patterns do CLAUDE.md? Cria debt não-registrada? É consistente com modules existentes?' (6) session handoff — no final de cada sessão de development: agente gera summary com: o que foi feito, quais debts foram criadas (com ID), quais debts foram pagas, e quais modules foram modificados. Summary é contexto para próxima sessão. (7) debt trend metric — medir: debts criadas vs debts pagas por mês. Se criadas > pagas consistentemente: debt está crescendo — aumentar debt budget ou melhorar governance. Target: criadas ≤ pagas (debt level estável ou decrescente). Anti-pattern: agente que gera 500 linhas de código por sessão sem review ou governance — 500 linhas de código funcional com 50 linhas de debt inadvertente × 20 sessões/mês = debt acumulando exponencialmente."
		dependsOn: ["td-debt-quadrant", "td-debt-inventory"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-governance-as-code"
			context:   "AAG codifica governance de agentes — CLAUDE.md, policies, boundaries. TD AI-native dynamics usa governance como debt prevention: CLAUDE.md com patterns obrigatórios reduz inadvertent debt. AAG governa o que agente pode fazer; TD governa a qualidade do output com respeito a debt acumulada. Sem AAG: agente gera debt reckless. Com AAG: agente gera debt prudent (quando instruído) ou zero debt (quando padrões são claros)."
		}]
		rationale: "AI-generated tech debt 2024+. AI as debt payer 2024+. Session boundary problem 2024+. Na Mesh AI-native, agentes são simultaneamente o maior risco (debt rápida sem governance) e a maior oportunidade (payment rápido com instrução) de tech debt. Governance (CLAUDE.md + inventory + CI) é o que calibra."
	},
	{
		id:         "td-payment-strategies"
		name:       "Estratégias de Pagamento: Como e Quando Pagar Dívida Técnica"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Conceito de 'debt payment strategies' (2022+): (1) big bang — refactoring completo de módulo num único esforço. Risco: alto (pode introduzir bugs). Custo: concentrado. Benefit: debt eliminada de uma vez. (2) incremental — boy scout rule ('deixe o código melhor do que encontrou'). Cada mudança no módulo paga um pouco de debt. Risco: baixo. Custo: distribuído. Benefit: debt reduz gradualmente. (3) strangler fig — construir replacement ao lado do original, migrar consumidores gradualmente, descomissionar original. Risco: médio. Custo: distribuído. Benefit: rollback fácil. (4) scheduled — alocar tempo explícito (debt sprint, hack week, 20% time). Risco: baixo. Custo: previsível. Benefit: progresso garantido. Conceito contemporâneo de 'debt spike' (2023+): antes de pagar, investigar — quanto realmente custa? Quais dependências? Quais risks? Spike de 2-4h para entender scope antes de commit."
		meshManifestation: "Na Mesh, estratégias por debt type: (1) scoring features hardcoded (td-001) — strangler fig. Construir feature store (materialized views). Migrar features uma a uma. Quando todas migradas: remover hardcoded. Rollback: voltar para hardcoded se feature store tem issue. Timeline: 2-3 semanas incrementais. (2) API error messages inconsistentes (td-002) — incremental + middleware. Implementar error formatting middleware (RFC 9457). Cada endpoint migrado: next time it's touched. New endpoints: middleware by default. Old endpoints: migrar quando tocar. Timeline: 2-3 meses distributed. (3) PostgreSQL como event store (td-003) — big bang (quando trigger atingido). Migrar event store inteiro para EventStoreDB num weekend/maintenance window. Test extensivamente antes. Rollback: voltar para PostgreSQL. Timeline: 2-4 semanas concentrated. Mas: trigger não atingido — no payment needed yet."
		meshImplication: "Estratégia por contexto: (1) high interest + containable: strangler fig. Build replacement, migrate incrementally. Scoring features: build feature store → migrate → remove hardcoded. Low risk, high benefit, distributed cost. (2) high interest + systemic: incremental + middleware. Error handling: middleware standardizes, endpoints migrate gradually. Each fix reduces interest. (3) low interest + no trigger: defer. PostgreSQL as event store: works fine, no interest. Pay when trigger (performance issue, scale requirement) fires. (4) compound debt: address as cluster. 3 debts in scoring pipeline: plan that addresses all 3 in coordinated effort (feature store + model versioning + experiment tracking). Synergy: fixing together is less expensive than fixing separately because understanding context once. (5) debt sprint: quarterly, allocate 1 week to pay top 3 debts by interest rate. Agente executes, humano reviews. (6) spike before commit: for any debt with estimated cost >20h: spend 2-4h investigating actual scope before committing to payment. Estimate may be wrong — spike reveals true cost. (7) measure payment: after paying debt, measure interest reduction. If td-001 was 8h/mês and after payment is 0h/mês: confirmed. If still 4h/mês: payment was partial — more work needed. Anti-pattern: 'refactoring week' that addresses random debts chosen by developer preference rather than by interest rate — time spent on vanity refactoring instead of high-impact debt."
		dependsOn: ["td-debt-quadrant", "td-interest-rate-assessment", "td-debt-inventory"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-throughput-constraint"
			context:   "ORA identifies founder hours as throughput constraint. TD payment strategies respect constraint: agente pays debt (not founder). Founder reviews plan and approves. ORA says 'allocate constraint to throughput-maximizing activity'; TD says 'agente executing debt payment = constraint (founder) freed for strategy. Agente can refactor 10x faster than founder.'"
		}]
		rationale: "Payment strategies 2022+. Debt spike 2023+. Na Mesh AI-native, agente como debt payer é force multiplier — founder decides what to pay (strategic), agente executes payment (tactical). Strangler fig for scoring, incremental for API, deferred for event store — each strategy matched to debt characteristics."
	},
	{
		id:            "td-debt-review"
		name:          "Revisão de Dívida Técnica: Inventário Periódico de Debt, Juros e Saúde"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) inventory — debts ativas, novas, pagas. Total interest rate. Trend. (2) quadrant distribution — % deliberate-prudent vs others. Se inadvertent-reckless cresce: governance gap. (3) interest rates — top 5 by interest. Any trigger atingido? (4) containment — surface areas stable? Any debt became systemic? (5) AI dynamics — debts criadas por agentes vs pagas. Session handoff quality. (6) payment — debts pagas no período. Interest eliminated. Budget utilizado. (7) strategic — estágio do produto mudou? Debt tolerance should change?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: interest rate total e trigger check. Trimestral: full inventory review."
		meshImplication: "Mensal (30min): total interest rate — soma de todas as debts ativas × frequency. Trending up? Down? Stable? If up >20% vs last month: investigate — new debts? Or existing debts' interest rate increasing? Trigger check — any debt's trigger atingido? If yes: plan payment. Trimestral (2h): full inventory — each debt: interest rate reassessed, surface area checked, containment verified. Quadrant distribution — new debts classified. If inadvertent-reckless >20%: governance (CLAUDE.md, CI) needs improvement. AI dynamics — debts created vs paid this quarter by agents. Session summaries quality — are agents documenting debt? Payment plan — top 3 debts by interest: plan payment for next quarter. Budget: 20% of capacity allocated. Strategic — product stage changed? If moved from pre-PMF to PMF: debt tolerance should decrease. Shift from 'accept deliberate-prudent debt freely' to 'accept only if contained and low-interest.' Debt health indicator — total interest rate as % of monthly capacity. <10%: healthy. 10-25%: manageable. >25%: crisis — increase debt budget to 40% temporarily. >50%: paralysis — stop features, focus on debt. If review identifies zero debts: either codebase is pristine (unlikely) or debts are invisible (inventory incomplete)."
		dependsOn: ["td-debt-quadrant", "td-interest-rate-assessment", "td-debt-containment", "td-debt-inventory", "td-strategic-debt-decisions", "td-ai-native-debt-dynamics", "td-payment-strategies"]
		rationale: "Debt inventory that isn't reviewed degrades — debts accumulate, triggers are missed, interest compounds. Quarterly review is the mechanism that keeps debt managed, not just registered."
	},
]

reasoningProtocol: [
	{
		question:  "Esta implementação subótima é deliberada-prudente (com plan) ou é negligência? Está classificada no quadrante?"
		reveals:   "Se debt é instrumento estratégico — ou se é acidente sem plano de pagamento."
		rationale: "Fowler 2009: quadrant. Deliberate-prudent é investment; inadvertent-reckless é negligência. Mesma debt, contextos diferentes."
	},
	{
		question:  "Qual é a taxa de juros desta debt? Quanto custa por mês manter? Quantas vezes o módulo é tocado?"
		reveals:   "Se debt é high-priority (juros altos, tocado frequentemente) ou low-priority (juros baixos, raramente tocado)."
		rationale: "Tornhill 2022: interaction frequency. Debt em módulo central tocado 50x/mês: pagar urgentemente. Debt em módulo estável: defer."
	},
	{
		question:  "A debt está contida (ACL, bounded context) ou é sistêmica (afeta múltiplos consumidores)?"
		reveals:   "Se custo de pagamento é proporcional — ou se pagar requer migrar 15 integradores."
		rationale: "Debt surface area 2023+. Surface area 1: pagar = refactoring interno. Surface area 15: pagar = migration project."
	},
	{
		question:  "O debt inventory está atualizado? Agentes consultam antes de modificar módulos com debt?"
		reveals:   "Se debt é visível e gerenciada — ou se é invisível e compound sem controle."
		rationale: "Tech debt register 2022+. Debt não-registrada acumula juros silenciosamente. Agente sem contexto cria mais debt no mesmo módulo."
	},
	{
		question:  "A decisão de assumir debt é reversível ou irreversível? API pública vs código interno?"
		reveals:   "Se debt é option barata (reversível) ou commitment caro (irreversível)."
		rationale: "Debt as real option 2023+. Debt em código interno: opção com premium baixo. Debt em API pública: commitment com custo alto de reverter."
	},
	{
		question:  "No estágio atual do produto: qual o nível de tolerance para debt? Pre-PMF (alto) vs escala (baixo)?"
		reveals:   "Se debt tolerance é calibrada ao estágio — ou se é 'zero debt' paralisante ou 'qualquer debt' destrutivo."
		rationale: "Speed vs quality spectrum 2022+. Pre-PMF: velocidade > qualidade. Escala: qualidade > velocidade. Calibrar."
	},
]

meshExamples: [
	{
		id:       "ex-scoring-features-debt-payment"
		scenario: "Scoring pipeline (td-001) tem features hardcoded há 8 meses. Interest rate: 8h/mês (cada feature change = deploy + regression). Feature store seria solução. Trigger: model v3 precisa de 8 novas features. Total interest acumulado: ~64h. Cost to pay: 20h."
		analysis: "Debt está custando 8h/mês há 8 meses = 64h de juros acumulados. Cost to pay: 20h. Se tivesse pago no mês 1: savings = 56h. Payback retroativo: 2.5 meses (20h investidos ÷ 8h/mês saved). Agora: payback futuro = 2.5 meses. Model v3 trigger: sem feature store, 8 novas features = 8 deploys × 4h cada = 32h. Com feature store: 8 features = 8 config changes × 0.5h = 4h. Savings no v3 alone: 28h."
		recommendation: "(1) Pay now: strangler fig strategy. (a) build feature store as materialized views em PostgreSQL (dm-feature-store poor man's version). (b) migrate features one-by-one: cada feature movida de hardcoded para MV. (c) scoring pipeline: lê de feature store em vez de calcular inline. (d) test: same scores para mesmos inputs. (e) deploy: gradual — score 50% from feature store, compare with hardcoded. If match: 100%. (2) Timeline: 2 semanas. Agente executes, founder reviews. (3) Cost: 20h estimated. (4) After payment: future feature changes = config update + MV refresh. No deploy. Interest: ~0h/mês. (5) ADR closure: 'td-001 paid. Features migrated from hardcoded to feature store (materialized views). Interest eliminated: 8h/mês. Total interest paid over 8 months: ~64h. Lesson: should have paid at month 3 (payback 2.5 months, would have saved ~40h).' (6) Prevention: for future scoring changes, pattern is feature store first — CLAUDE.md updated."
		principlesApplied: ["ax-01", "ax-03", "dp-01"]
		assumptions: [
			"20h estimate is accurate — spike first to verify",
			"materialized views work as feature store — sufficient for current volume",
			"scoring output is deterministic — same features = same score (verifiable)",
			"2 weeks is realistic for agente execution — depends on complexity of current implementation",
		]
		rationale: "Tornhill 2022: pay debt with highest interest first. Na Mesh, td-001 with 8h/mês interest and 20h cost: payback 2.5 months. Every month unpaid: 8h wasted. With model v3 needing 8 features: 28h additional savings. Total ROI of payment: ~100h saved in next year."
	},
	{
		id:       "ex-deliberate-debt-prerevenue"
		scenario: "Mesh está pré-revenue. Founder precisa decidir: implementar event sourcing com Marten (40h, correct architecture) ou usar simple CRUD com audit table (15h, faster but debt)."
		analysis: "Event sourcing: architecturally correct for intermediário financeiro (audit trail by design, replay, temporal queries). 40h. CRUD + audit table: funciona para MVP com 100 operações. Audit table logs state changes. Não tem replay nativo, não tem temporal queries. 15h. Difference: 25h. Debt type: deliberate-prudent. Interest rate: near-zero initially (poucas operações, audit table sufficient). Rises when: regulador pede reconstituição (audit table doesn't support replay natively), backtest de scoring (requires temporal queries). Containment: repository interface — whether backend is event sourcing or CRUD, consumers access via same interface. Reversibility: reversível — migrate from CRUD to event sourcing by replaying audit table into event store."
		recommendation: "(1) Assess: is 25h difference material for pré-revenue? If founder-hours are the constraint (ora-throughput-constraint): 25h = 3+ days. 3 days earlier for first operation with anchor tenant may be more valuable than architecturally correct event sourcing. (2) Decision framework: (a) irreversível? No — repository interface ACL means migration is internal. (b) interest rate? Near-zero now. Rises when volume or regulatory scrutiny increases. (c) trigger? When regulador asks for reconstituição OR when backtest needed for scoring v2. (d) estágio? Pré-revenue — velocity > perfection. (3) Recommendation: CRUD + audit table with ADR. ADR: 'td-004: CRUD with audit table instead of event sourcing. Quadrant: deliberate-prudent. Interest: 0h/mês currently. Trigger: regulatory audit request OR scoring backtest requirement. Cost to migrate: 40h (implement event sourcing + replay audit table into events). Containment: repository interface — consumers unaffected by migration. Reversibility: high.' (4) Containment: repository interface from day 1. OperationRepository.save(operation) internally does CRUD + audit log. When migrating: internally does event append. Consumers: zero change. (5) When trigger fires: agente executes migration. Audit table entries → events. Event store replaces CRUD. 40h concentrated effort. (6) If trigger never fires (product pivots before regulatory scrutiny): 25h saved, zero interest paid. Debt was free option."
		principlesApplied: ["ax-01", "ax-03", "ax-05"]
		assumptions: [
			"25h difference is accurate — event sourcing with Marten may be faster than estimated (good docs)",
			"audit table is sufficient for basic compliance — verify with assessoria before relying",
			"repository interface ACL is implementable without overhead — may add 2-3h",
			"trigger may not fire before product pivot — if it fires in month 2: 25h saved was net negative (paid 40h late instead of 40h early)",
		]
		rationale: "Debt as real option 2023+. Reversibility criterion. Na Mesh pré-revenue, CRUD + audit table is deliberate-prudent debt: saves 25h (velocity), contained (ACL), low interest (near-zero), reversible (migration path clear). Event sourcing is correct architecture — but correct architecture pré-PMF may be premature optimization if domínio changes."
	},
	{
		id:       "ex-ai-agent-debt-accumulation"
		scenario: "After 3 months of agent-driven development, code review reveals: 12 API endpoints with 4 different error handling patterns. 8 event schemas with inconsistent naming (some camelCase, some snake_case). 5 agent configs with different escalation rule formats."
		analysis: "Inadvertent-reckless debt from multiple agent sessions without sufficient governance. Root causes: (1) CLAUDE.md didn't specify error handling pattern explicitly. (2) Event schema naming convention wasn't enforced by CUE validation. (3) Agent config schema wasn't strict enough. Each session: agent followed local consistency but global inconsistency accumulated across sessions. Interest rate: moderate — every new endpoint, event, or config encounters inconsistency and takes longer. Developer/agent seeing 4 error patterns: which to follow? Compound: inconsistency breeds more inconsistency."
		recommendation: "(1) Pay debt: (a) error handling: implement middleware (RFC 9457). Agente refactors all 12 endpoints in 1 session (~4h). (b) event naming: define convention in CUE schema (snake_case only). Agente renames inconsistent fields with schema migration + upcaster (~3h). (c) agent config: strict CUE schema for escalation rules. Agente normalizes 5 configs (~2h). Total: ~9h. (2) Prevent recurrence: (a) CLAUDE.md updated: 'API errors: RFC 9457 format via error middleware. Event naming: snake_case. Agent config: follows #AgentConfig schema.' (b) CUE validation: event schemas validated on commit — camelCase field → CI failure. (c) CI linting: endpoint without error middleware → failure. Config not conforming to schema → failure. (3) Root cause ADR: 'Inadvertent-reckless debt from insufficient governance in agent sessions 1-3. Fix: CLAUDE.md + CUE schemas + CI linting. Cost of debt: ~20h of confusion over 3 months. Cost of fix: 9h + governance setup 4h = 13h. Lesson: governance setup before agent development starts saves more than it costs.' (4) Debt trend: after fix, monitor — new inadvertent debts per quarter should drop to near-zero if governance is effective."
		principlesApplied: ["ax-03", "ax-05", "dp-01"]
		assumptions: [
			"agente can refactor 12 endpoints in 1 session — depends on complexity and test coverage",
			"event schema rename is backward compatible with upcaster — verify with existing consumers",
			"CI linting catches all future inconsistencies — may need iterative rule improvement",
			"governance setup cost of 4h is sufficient — may need more if CLAUDE.md was minimal",
		]
		rationale: "AI-generated tech debt 2024+. Session boundary problem 2024+. Na Mesh, 3 months of agent development without sufficient governance generated 20h of confusion debt. 13h to fix + prevent. Lesson: invest 4h in governance before first agent session saves 20h+ of inadvertent debt."
	},
	{
		id:       "ex-debt-budget-allocation"
		scenario: "Mesh has 160h/month of development capacity (founder + agents). Debt inventory shows total interest of 18h/month (11% of capacity). 5 active debts. Feature backlog has 8 items requested by anchor tenants."
		analysis: "18h/month of interest = 11% of capacity lost to debt. Not crisis (>25%) but significant. If debt grows to 25%: 40h/month lost — equivalent to 1 full week. If unchecked for 6 more months: compound interest likely pushes to 30h/month. Feature backlog: anchor tenants waiting for features → delay risks churn of early adopters. Trade-off: allocate capacity to debt payment (reduce future interest) vs features (retain anchor tenants)."
		recommendation: "(1) Debt budget: 20% = 32h/month. Allocate to top 2 debts by interest rate this quarter. (2) Top debts: td-001 (scoring features, 8h/mês interest, 20h to pay). td-002 (API errors, 2h/mês interest, 40h to pay — high cost, lower priority). td-005 (test infrastructure, 5h/mês interest, 15h to pay). (3) This month: pay td-001 (20h) + start td-005 (12h of 15h). Remaining 128h: features for anchor tenants. (4) Next month: finish td-005 (3h). Start td-002 if interest justifies (2h/mès may not justify 40h — reassess). Remaining: features. (5) Post-payment: interest drops from 18h to 5h/month (td-001: -8, td-005: -5 = -13h). Capacity freed: 13h/month permanently. (6) ROI of debt month: invested 32h. Returns 13h/month perpetually. Payback: 2.5 months. (7) Communication to anchor tenants: 'we're investing in platform reliability this month — your requested features are scheduled for next month. This investment will accelerate delivery speed for all future features.' Frame as investment, not delay. (8) Ongoing: maintain 20% debt budget. If interest drops <5%: reduce to 10%. If rises >20%: increase to 30%."
		principlesApplied: ["ax-01", "ax-03", "ax-07"]
		assumptions: [
			"160h/month includes agent hours at estimated capacity — agent capacity may vary",
			"interest rate estimates are accurate — measure actual time after payment to verify",
			"anchor tenants accept 1 month delay for features — communicate proactively",
			"td-002 (40h, 2h/mès) may not be worth paying now — reassess in 3 months",
		]
		rationale: "Debt budget 2024+. Na Mesh, 11% interest is manageable but growing. Paying td-001 + td-005 (32h investment) eliminates 13h/month perpetually. Payback: 2.5 months. Every month after: 13h freed for features. Not paying: 13h/month lost forever. Decision is financial, not aesthetic."
	},
]

principleIds: ["ax-01", "ax-03", "ax-05", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA allocates resources (founder time, agent capacity). TD informs: debt interest consumes X h/month of capacity — effectively reducing available capacity for features. ORA says 'allocate constraint optimally'; TD quantifies the tax that debt imposes on capacity. ORA + TD: 'debt payment is capacity investment with quantifiable ROI.'"
	},
	{
		lensId:   "lens-real-options"
		relation: "complementsWith"
		context:  "RO models reversibility and optionality. TD uses: debt in reversible decisions is cheap option; debt in irreversible decisions is expensive commitment. RO preserves optionality; TD says 'debt in internal code preserves option to refactor; debt in public API eliminates option.' Both converge: pre-PMF, maintain optionality via contained reversible debt."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governs agent behavior (CLAUDE.md, boundaries, audit). TD AI-native dynamics: agents generate and pay debt. AAG governance (patterns, schemas, CI) prevents inadvertent debt. Without AAG: agents generate reckless debt at scale. With AAG: agents generate only deliberate-prudent debt when instructed."
	},
	{
		lensId:   "lens-knowledge-management"
		relation: "complementsWith"
		context:  "KM defines ADRs and knowledge as code. TD debt inventory is knowledge about debt — documented, versioned, consultable by agents. Each debt has ADR. Each payment has closure ADR. KM is the framework; TD is the content about debt."
	},
	{
		lensId:   "lens-distributed-systems-design"
		relation: "complementsWith"
		context:  "DSD defines ACL and bounded context boundaries. TD debt containment uses ACL to isolate debt — debt behind interface is internal; migration doesn't affect consumers. DSD provides the architectural pattern; TD applies for debt isolation."
	},
	{
		lensId:   "lens-cross-cutting-concern-integration"
		relation: "complementsWith"
		context:  "CC ensures concerns are applied consistently. TD can create debt in concern application (endpoint without auth = security debt). CC verification catches concern debt in CI. CC + TD: concern debt has high interest rate (security gap) and must be paid immediately."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI monitors system health. TD debt can manifest as OOI issues: tech debt in error handling → more 500s → worse SLIs. OOI detects symptom; TD identifies root cause (debt in module X). OOI + TD: 'SLI degradation may be debt interest — check debt inventory for affected module.'"
	},
]

limitations: [
	{
		description: "Interest rate estimation is subjective — '8h/mês' is estimate based on developer/agent experience, not measurement. Actual interest may be higher or lower."
		alternative: "Measure after payment: track time spent on module before and after paying debt. Retrospective validates or corrects estimate. Over time: estimates improve. But even imprecise estimate > no estimate."
		rationale: "Imprecise ROI calculation is infinitely better than no ROI calculation. 'Costs roughly 8h/mès' enables prioritization; 'costs something' doesn't."
	},
	{
		description: "Debt inventory requires discipline to maintain — every debt must be registered, reviewed, and updated. In practice, debts are created faster than registered, especially by agents."
		alternative: "Automate what's possible: CI that detects TODO/FIXME/HACK/DEBT comments and creates inventory entries. Agent session summaries that flag debts created. Quarterly review catches unregistered debts. Perfect inventory is unrealistic; useful inventory is achievable."
		rationale: "Inventory with 80% of debts is better than no inventory. Automate registration to reduce discipline required."
	},
	{
		description: "Debt budget of 20% may be insufficient if debt accumulated significantly before inventory was established — existing debt may require 40-50% of capacity to address in reasonable timeline."
		alternative: "If debt crisis (interest >25% of capacity): temporary increase to 40% debt budget for 1-2 quarters. Communicate to stakeholders: 'investing in platform reliability — feature delivery temporarily reduced but long-term velocity will increase significantly.' Return to 20% when interest drops below 10%."
		rationale: "20% is maintenance budget. If debt accumulated without management: catch-up requires temporary higher budget. Then maintain at 20%."
	},
	{
		description: "Framework assumes debt is identifiable and measurable. Some debt is invisible until it manifests as incident or development slowdown — 'unknown unknowns.'"
		alternative: "Use proxy metrics to detect invisible debt: development velocity trend (features per sprint declining?), bug rate trend (increasing?), onboarding time for new agents/developers (increasing?). If proxies worsen without explanation: investigate for hidden debt."
		rationale: "Invisible debt reveals itself through symptoms. Monitoring symptoms catches what inventory misses."
	},
	{
		description: "In AI-native context, the boundary between 'debt' and 'normal code that could be better' is blurry — agent generates functional code that isn't ideal but isn't clearly debt either."
		alternative: "Apply pragmatic threshold: if code works, passes CI, follows CLAUDE.md patterns, and no one has complained about maintaining it — it's not debt, even if theoretically improvable. Debt = measurable negative impact on velocity, quality, or risk. Theoretical imperfection ≠ debt."
		rationale: "Not every suboptimal line of code is debt. Debt requires measurable impact. Perfectionism disguised as debt management is counter-productive."
	},
]

rationale: "Toda organização que constrói software acumula dívida técnica — e a diferença entre organizações eficazes e ineficazes não é zero debt vs some debt, é managed debt vs unmanaged debt. Na Mesh AI-native operada por agentes, debt tem dinâmica amplificada: agentes geram código (e debt) em volume, mas também podem pagar debt em volume. Esta lens operacionaliza: classificação de debt com quadrante deliberate/inadvertent × prudent/reckless (Fowler 2009, Allman 2012, debt as investment 2023+), assessment de interest rate por frequência de interação e compound interest (Cunningham 1992, Tornhill 2022, compound interest 2023+), contenção de debt com ACL e surface area minimization (debt containment 2022+, debt surface area 2023+), inventário como artefato gerenciável no mesh-spec com debt budget (tech debt register 2022+, debt visibility 2023+, debt budget 2024+), decisões estratégicas de debt com reversibilidade e estágio do produto (speed vs quality 2022+, debt as real option 2023+), dinâmicas AI-native com agents como geradores e pagadores de debt (AI-generated debt 2024+, AI as debt payer 2024+, session boundary 2024+), e estratégias de pagamento com strangler fig, incremental, e scheduled (payment strategies 2022+, debt spike 2023+). Universal, agnóstica a estágio, aplicável a qualquer organização que constrói software e aceita que debt é instrumento, não falha."

}
