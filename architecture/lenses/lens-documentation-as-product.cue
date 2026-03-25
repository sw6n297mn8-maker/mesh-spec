package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

documentationAsProduct: artifact_schemas.#AnalyticalLens & {
id:     "lens-documentation-as-product"
name:   "Documentação como Produto"

purpose: "Orientar decisões sobre como tratar documentação como produto — SSOT, freshness, audience-awareness e documentation-driven development."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como projetar documentação que serve como cognitive prosthetic para agentes IA sem memória persistente",
		"a decisão envolve como estruturar o mesh-spec para que agentes encontrem informação relevante sem search exaustivo",
		"a decisão envolve como manter documentação viva que evolui com o sistema em vez de fossilizar",
		"a decisão envolve como documentação interna (mesh-spec, ADRs, lenses) difere de documentação externa (API docs, user docs)",
		"a decisão envolve como medir se documentação está cumprindo seu propósito (agentes tomam decisões melhores? Humanos entendem o sistema?)",
		"a decisão envolve como projetar documentação consumível por máquina (schemas, catalogs) e por humano (narrativas, explicações)",
		"a decisão envolve trade-offs entre completude de documentação e custo de manutenção",
		"a decisão envolve como documentação suporta onboarding de novos agentes (cada sessão é novo agente sem contexto)",
		"a decisão envolve como evitar documentação duplicada, conflitante ou desatualizada",
		"a decisão envolve como documentação se integra com workflows de desenvolvimento (docs-as-code, CI validation)",
	]
	keywords: [
		"documentação", "documentation", "docs",
		"mesh-spec", "spec", "especificação", "specification",
		"ADR", "decision record", "registro de decisão",
		"cognitive prosthetic", "prótese cognitiva", "memória",
		"knowledge base", "base de conhecimento",
		"README", "CLAUDE.md", "CONTRIBUTING",
		"schema", "catálogo", "catalog", "inventário",
		"Diátaxis", "tutorial", "how-to", "reference", "explanation",
		"docs-as-code", "versionamento de docs", "CI de docs",
		"freshness", "staleness", "desatualização",
		"single source of truth", "SSOT", "fonte canônica",
		"onboarding de agente", "context window", "session boundary",
		"machine-readable", "human-readable", "dual-audience",
	]
	excludeWhen: [
		"a decisão é sobre documentação de API para integradores externos — usar developer-and-integrator-experience",
		"a decisão é sobre knowledge management organizacional em geral — usar knowledge-management",
		"a decisão é sobre compliance e audit trail — usar regulatory-compliance-as-architecture",
		"a decisão é sobre design de schemas CUE — usar o schema relevante diretamente",
		"a decisão é sobre comunicação com stakeholders externos — usar stakeholder-communication",
	]
	rationale: "Na Mesh AI-native onde agentes IA são os operadores primários do sistema, documentação não é artefato complementar — é infraestrutura cognitiva. Cada sessão de agente começa sem memória das sessões anteriores — o mesh-spec é a prótese cognitiva que permite que agente novo opere como se tivesse contexto completo. Documentação ruim = agente que toma decisão errada, reinventa solução existente, ou viola pattern estabelecido. Documentação boa = agente que encontra context relevante, aplica decisões passadas, e produz output consistente com o sistema existente. DX cobre docs de API para integradores; KM cobre knowledge management organizacional; RC cobre compliance docs. Esta lens cobre documentação como produto — como projetar, manter e medir o mesh-spec e artefatos associados para que sirvam tanto agentes quanto humanos como cognitive infrastructure viva."
}

concepts: [
	{
		id:         "dp-docs-as-cognitive-infrastructure"
		name:       "Documentação como Infraestrutura Cognitiva: O Sistema que Pensa Depende do Sistema que Documenta"
		nature:     "theoretical"
		role:       "framework"
		definition: "Conceito original de 'cognitive prosthetic' aplicado a AI agents: em sistemas AI-native sem memória persistente entre sessões, documentação é a memória externa que permite continuidade. Sem ela: cada sessão é ground zero. Com ela: cada sessão começa com context acumulado de todas as sessões anteriores. Conceito de 'documentation as interface' (2022+): documentação não é narrativa sobre o sistema — é interface para o sistema. Agente consome mesh-spec da mesma forma que consome API: como input estruturado que informa decisão. Conceito contemporâneo de 'dual-audience documentation' (2024+): em AI-native orgs, documentação serve 2 audiências com necessidades diferentes: (1) agentes IA — precisam de informação estruturada, machine-parseable, com schemas validáveis, hierarquias navegáveis, e referências cruzadas explícitas. (2) humanos — precisam de narrativas, rationales, exemplos, e explanations que contextualizam decisões. Projetar para ambos: schema (machine) + rationale (human) no mesmo artefato. Conceito de 'documentation-driven architecture' (2023+, evoluído de documentation-driven development): arquitetura que emerge da documentação — decisões são documentadas primeiro, implementadas depois. Mesh-spec como source of truth que governa implementação, não que descreve implementação."
		meshManifestation: "Na Mesh, documentação como infraestrutura cognitiva: (1) mesh-spec como cognitive prosthetic — quando agente Claude Code inicia sessão: lê CLAUDE.md → lê schema relevante → lê ADRs relevantes → lê lenses relevantes → toma decisão informada pelo acumulado de todas as sessões anteriores. Sem mesh-spec: agente opera no escuro. (2) dual-audience — CUE schemas são machine-readable (validáveis, parseable). Rationale fields são human-readable (explicam por quê). Mesma definição de lens contém: conceitos (machine: structure + IDs) + rationale (human: por que este conceito, que evidência suporta). (3) documentation-driven — nova feature começa com: ADR → schema update → implementation. Não: implementation → 'ah, precisa documentar.' Se agente não encontra spec: agente não implementa (ou implementa errado — o que é pior). (4) CLAUDE.md como entry point — documento que cada sessão de agente lê primeiro. Contém: arquitetura atual, conventions, decisões ativas, onde encontrar informação. É o 'onboarding doc' que todo novo agente recebe."
		meshImplication: "Projetar docs como infra: (1) mesh-spec como SSOT — se existe no mesh-spec: é verdade. Se não existe: não é oficial. Se conflita com código: mesh-spec governa (código está errado ou spec precisa de update). (2) CLAUDE.md como entry point — manter atualizado com: overview da arquitetura atual, link para schemas, link para ADRs recentes, conventions de naming/style/pattern, e 'onde encontrar X' para os 10 tipos de informação mais buscados. CLAUDE.md é a página mais importante do mesh-spec — se desatualiza: toda sessão de agente começa com context errado. (3) dual-format para cada artefato — schema (CUE: machine) + description (markdown: human) + rationale (markdown: human) + examples (both). Agente consome schema; humano lê rationale. Ambos no mesmo arquivo. (4) cross-references explícitas — todo conceito referencia conceitos relacionados. Agente que lê lens X e encontra referência a lens Y: pode navegar. Sem referência: agente não sabe que Y existe. (5) freshness como SLI — doc desatualizada é doc que desinforma. Medir: quando foi o último update de cada artefato? Se >3 meses sem update e sistema mudou: doc é potencialmente stale. (6) documentation review como parte de PR — cada PR que muda sistema: atualiza docs correspondentes. PR sem docs update quando necessário: blocked (ou flagged). Anti-pattern: 'mesh-spec perfeito mas nunca lido' — doc que ninguém consome é overhead sem valor. Medir consumo (agentes referenciam? Decisões citam?)."
		rationale: "Cognitive prosthetic para AI agents. Documentation as interface 2022+. Dual-audience 2024+. Documentation-driven architecture 2023+. Na Mesh AI-native, mesh-spec é a diferença entre agente que sabe o que fazer (context completo) e agente que adivinha (ground zero)."
	},
	{
		id:         "dp-information-architecture"
		name:       "Arquitetura de Informação do Mesh-Spec: Onde Cada Tipo de Conhecimento Vive"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "semi-annual"
		definition: "Conceito de 'information architecture for knowledge bases' (Rosenfeld/Morville 2015, Information Architecture, 4th ed.): organizar informação para que seja findable, understandable, e usable. Em mesh-spec: agente deve encontrar resposta para 'como implementar endpoint de antecipação?' em <2 minutos de navegação. Procida (2023, Diátaxis): 4 tipos de documentação (tutorials, how-to, reference, explanation) com propósitos distintos — misturar tipos gera docs que não serve ninguém. Conceito contemporâneo de 'layered documentation' (2024+): documentação em camadas de abstração: (1) principles (axiomas, design principles — estáveis, raramente mudam). (2) architecture (decisões de arquitetura, ADRs — mudam com decisões). (3) specifications (schemas, catalogs, interfaces — mudam com implementação). (4) guides (how-to, tutorials — mudam com produto). (5) records (changelogs, decision logs — append-only). Cada camada tem frequência de mudança e audiência diferente."
		meshManifestation: "Na Mesh, estrutura do mesh-spec: (1) /foundations — axiomas (ax-01..ax-07), design principles (dp-01..dp-10). Estáveis. Mudam raramente. Informam todas as decisões. (2) /governance — CLAUDE.md, tension-log schema, agent config (#AgentConfig), precedence hierarchy. Mudam com evolução de governance. (3) /architecture — ADRs, technology stack document, bounded context map, event catalog. Mudam com decisões de arquitetura. (4) /lenses — analytical lenses (esta coleção). Mudam com domínio e conhecimento. (5) /schemas — CUE schemas de artefatos, eventos, configurações. Mudam com implementação. (6) /guides — how-to guides para tarefas comuns (como criar endpoint, como adicionar evento ao catálogo, como registrar debt item). Mudam com processos. (7) /records — changelogs, decision logs, debt register, review logs. Append-only."
		meshImplication: "IA do mesh-spec: (1) hierarchy clara — agente navega: CLAUDE.md → foundations (princípios) → architecture (decisões) → schemas (especificações) → lenses (reasoning frameworks) → guides (como fazer). Cada nível tem purpose. (2) naming convention — diretórios e arquivos com nomes que informam conteúdo sem abrir: /architecture/adrs/adr-007-postgresql-as-event-store.md. /lenses/lens-credit-risk.cue. /schemas/event-catalog/ecl.AnticipationRequested.cue. Agente que lista diretório entende o que existe. (3) index files — cada diretório tem README.md ou INDEX.md que lista conteúdo com 1-line description. Agente que lê index: overview sem abrir cada arquivo. (4) cross-references como links — em ADR, referência a lens: 'conforme lens-credit-risk (cr-expected-loss-model).' Em lens, referência a ADR: 'implementação: ver ADR-007.' Referências são navigáveis. (5) search-friendly — nomes de conceitos e IDs são únicos e searchable. Agente que busca 'event sourcing' encontra: ADR-007 (decision), eda-event-sourcing (conceito), schema de event (spec). (6) não duplicar — se informação existe em um lugar (schema de evento no event catalog): não copiar para guia. Referenciar. Duplicação = divergência eventual. SSOT: informação vive em 1 lugar e é referenciada de N. Anti-pattern: mesh-spec com 500 arquivos sem hierarquia, naming inconsistente, e sem index — agente gasta 10 minutos procurando em vez de 30 segundos navegando."
		dependsOn: ["dp-docs-as-cognitive-infrastructure"]
		crossDependsOn: [{
			lensId:    "lens-knowledge-management"
			conceptId: "km-organizational-memory"
			context:   "KM define organizational memory como ativo. DP information architecture é a implementação de organizational memory para AI-native org: mesh-spec como memória organizacional estruturada, navigável, e consumível por agentes. KM diz 'preservar decisões e context'; DP diz 'estruturar em layers com IA clara para que agente encontre em <30 segundos'."
		}]
		rationale: "Rosenfeld/Morville 2015: information architecture. Procida 2023: Diátaxis. Layered documentation 2024+. Na Mesh, agente que navega mesh-spec hierárquico com index files encontra informação em 30 segundos. Agente que navega flat folder com 200 arquivos: 10 minutos ou desiste."
	},
	{
		id:         "dp-documentation-types"
		name:       "Tipos de Documentação: Cada Tipo Serve Necessidade Diferente"
		nature:     "theoretical"
		role:       "property"
		definition: "Procida (2023, Diátaxis): 4 tipos fundamentais — (1) tutorials — learning-oriented. 'Aprenda fazendo.' Guia passo-a-passo para novato. (2) how-to guides — task-oriented. 'Resolva problema X.' Para quem sabe o básico e quer completar tarefa. (3) reference — information-oriented. 'Especificação de X.' Completa, precisa, seca. (4) explanation — understanding-oriented. 'Por que X funciona assim?' Contexto, rationale, alternatives considered. Conceito adicional para AI-native: (5) machine-readable specifications — schemas, catalogs, configs que agentes consomem programmaticamente. Não é para leitura humana — é para parsing. CUE schemas, AsyncAPI specs, OpenAPI specs. (6) decision records — ADRs que preservam não apenas decisão mas context, alternatives, e rationale. Agente que lê ADR entende por que decisão foi tomada, não apenas o que foi decidido."
		meshManifestation: "Na Mesh, tipos de doc por audiência: (1) tutorials — 'Como configurar nova sessão de Claude Code com context do mesh-spec.' 'Como criar primeiro endpoint no padrão Mesh.' Para onboarding de novos contributors ou agentes em tarefas novas. (2) how-to guides — 'Como adicionar evento ao event catalog.' 'Como registrar debt item.' 'Como criar nova lens analítica.' Task-oriented, assume conhecimento básico do sistema. (3) reference — CUE schemas (cada campo com description). Event catalog (cada evento com schema completo). API reference (cada endpoint). Config reference (cada configuração com values aceitos e defaults). (4) explanation — rationale de cada ADR ('por que PostgreSQL como event store?'). Rationale de cada lens ('por que esta lens existe?'). Rationale de cada axioma e design principle. (5) machine-readable — CUE schemas validáveis. AsyncAPI spec do event catalog. OpenAPI spec da API. Config schemas. (6) decision records — ADRs com: context, decision, rationale, alternatives, consequences, status."
		meshImplication: "Para cada artefato de documentação: (1) identify type — é tutorial, how-to, reference, explanation, machine-readable, ou decision record? (2) write for type — tutorial é step-by-step com resultado visível a cada step. Reference é completa e precisa sem narrativa. Explanation é conceitual com rationale. Não misturar: reference com storytelling não é reference; tutorial sem steps não é tutorial. (3) locate by type — tutorials em /guides/tutorials/. How-to em /guides/how-to/. Reference em /schemas/ e /architecture/. Explanation em rationale fields e /foundations/. Decision records em /architecture/adrs/. Machine-readable: co-located com o que descrevem (schema de evento junto com event catalog, OpenAPI junto com API code). (4) maintain by frequency — tutorials e how-to: mudam quando processo muda (quarterly review). Reference: muda quando sistema muda (per-PR update). Explanation: muda quando decisão muda (per-ADR). Machine-readable: muda com código (automated via CI). (5) coverage target — por tipo: reference: 100% coverage (todo schema, endpoint, evento documentado). Explanation: 100% coverage para decisões arquiteturais (todo ADR com rationale). How-to: top 10 tasks mais frequentes. Tutorial: top 3 onboarding scenarios. Anti-pattern: mesh-spec que é 100% reference (schemas) sem explanation (rationale) — agente sabe o que existe mas não sabe por que, e toma decisão que contradiz intent."
		dependsOn: ["dp-information-architecture"]
		rationale: "Procida 2023: Diátaxis 4 types. Machine-readable + decision records para AI-native. Na Mesh, cada tipo serve momento diferente: agente novo lê tutorial. Agente que implementa feature lê how-to. Agente que toma decisão lê explanation + ADR. Agente que valida output lê reference."
	},
	{
		id:            "dp-freshness-maintenance"
		name:          "Freshness e Manutenção: Doc que Desatualiza Desinforma"
		nature:        "operational"
		role:          "method"
		reviewCadence: "monthly"
		definition:    "Concepto de 'documentation decay' (2022+): documentação desatualiza naturalmente — sistema muda, docs não acompanha. Decay rate depende de: frequência de mudança do sistema, coupling entre docs e código, e process de atualização. Conceito contemporâneo de 'docs-as-code' (2020+, Redocly, Mintlify): documentação versionada no mesmo repositório que código, built por CI/CD, testável. Benefício: docs e código evoluem juntos. Se PR muda API: PR deve atualizar API docs (enforced por CI). Conceito de 'documentation testing' (2023+): testes automatizados que verificam: (a) code samples executam sem erro. (b) schema references existem (link não-quebrado). (c) ADR references são válidos. (d) freshness (arquivo não modificado há >N meses enquanto código relacionado mudou). Conceito de 'ownership model for documentation' (2023+): cada seção de docs tem owner responsável por freshness. Owner é notificado quando seção pode estar stale. Sem owner: orphan doc que fossiliza."
		meshManifestation: "Na Mesh, freshness challenges: (1) CLAUDE.md — se desatualiza (lista BCs que não existem mais, conventions que mudaram): toda sessão de agente começa com context errado. Freshness: critical. Update: per-decision que afeta architecture ou conventions. Owner: founder. (2) event catalog — se evento muda schema e catálogo não atualiza: agente implementa com schema errado. Freshness: high. Update: per-PR que muda evento. Owner: BC owner. (3) ADRs — ADR que foi superseded sem update de status: agente aplica decisão revogada. Freshness: medium. Update: quando nova decisão supersede. Owner: decision maker. (4) lenses — lens que não reflete evolução de domínio: agente raciocina com framework obsoleto. Freshness: medium. Update: quarterly review. Owner: founder. (5) how-to guides — guia que descreve processo que mudou: agente segue processo errado. Freshness: medium. Update: quando processo muda."
		meshImplication: "Freshness management: (1) docs-as-code — mesh-spec no mesmo repositório (ou linked) que código. PR que muda: schema → update reference docs. API endpoint → update API docs. Convention → update CLAUDE.md. CI check: 'se arquivo X mudou, arquivo Y deve ter mudado também' (co-change detection). (2) freshness badges — cada documento com: last_updated date, related_code (link para código que docs descreve). CI: se related_code mudou mais recentemente que docs: warning 'docs may be stale.' (3) ownership — cada seção do mesh-spec tem owner no index: '/architecture/adrs/ — owner: founder. /schemas/events/ — owner: BC maintainer. /lenses/ — owner: founder.' Owner é notificado quando freshness warning triggers. (4) automated testing — (a) CUE schemas: validate against test data (CI). Se schema inválido: CI fails. (b) cross-references: validate que IDs referenciados existem (lens-credit-risk referencia cr-expected-loss-model — verify cr-expected-loss-model exists). (c) code sample testing: samples em guides executam sem erro (CI). (5) scheduled review — monthly: CLAUDE.md review (most critical). Quarterly: lens review (medium critical). Semi-annual: architecture review (low frequency change). (6) staleness prevention — when agente or human modifies code: prompt 'docs affected? [list of potentially stale docs].' Make doc update part of the workflow, not afterthought. Anti-pattern: mesh-spec updated enthusiastically in month 1, never touched again — by month 6: 50% stale, agentes operating with mixed context (some current, some outdated)."
		dependsOn: ["dp-docs-as-cognitive-infrastructure", "dp-information-architecture"]
		crossDependsOn: [{
			lensId:    "lens-cross-cutting-concern-integration"
			conceptId: "cc-concern-consistency-verification"
			context:   "CC defines concern consistency verification — proving concerns are applied everywhere. DP freshness is the documentation concern: 'is docs consistent with code?' CC verification approach applies: automated checks (CI verifies docs freshness), coverage metrics (% of schemas with docs, % of ADRs with status), and periodic audit (quarterly review of staleness). CC is the framework; DP is the application for documentation freshness."
		}]
		rationale: "Documentation decay 2022+. Docs-as-code 2020+. Documentation testing 2023+. Na Mesh AI-native, stale CLAUDE.md is worse than no CLAUDE.md — agente trusts it and operates with wrong context. Freshness is not nice-to-have — it's correctness of cognitive infrastructure."
	},
	{
		id:         "dp-agent-consumability"
		name:       "Consumibilidade por Agente: Projetar Docs que IA Processa Eficientemente"
		nature:     "theoretical"
		role:       "property"
		definition: "Em AI-native orgs, documentação é consumida por LLMs com context window limitado. Conceito de 'context-window-aware documentation' (2024+): documentação projetada para caber eficientemente em context window: (1) layered loading — agente não precisa ler tudo. CLAUDE.md (summary) → relevant schema (detail) → relevant ADR (decision). Cada layer adiciona context conforme necessidade. (2) self-contained sections — cada seção pode ser lida independentemente sem ler todo o documento. Cross-references para context adicional, mas seção faz sentido sozinha. (3) structured metadata — IDs, tags, e headers que permitem agente filtrar rapidamente. (4) conciseness without ambiguity — compacto para economizar tokens, mas preciso o suficiente para evitar interpretação errada. Conceito de 'documentation as prompt engineering' (2024+): CLAUDE.md e guias são, efetivamente, system prompts para agentes. Clareza, specificidade, e structura de docs afeta qualidade do output do agente da mesma forma que prompt engineering afeta qualidade de LLM output."
		meshManifestation: "Na Mesh, agent consumability: (1) CLAUDE.md — compacto (~2-4k tokens ideal). Overview de arquitetura em 10 linhas. Conventions em bullets. Links para detail (não inline detail). Agente lê em <10 segundos. Se CLAUDE.md tem 20k tokens: agente consome context window que poderia ser usado para task. (2) lenses — cada lens é self-contained: trigger (quando usar), concepts (o que saber), reasoning (como pensar), examples (como aplicar). Agente que precisa de credit risk reasoning: carrega lens-credit-risk. Não precisa carregar todas as 40 lenses. (3) schemas — CUE com descriptions inline. Agente que lê schema entende cada campo sem precisar de documento separado. (4) ADRs — structured: context (por que decidir), decision (o que), rationale (por que assim), alternatives (o que mais considerou), consequences (o que resulta). Agente extrai decisão relevante rapidamente. (5) event catalog — cada evento com: ID, description, schema, producer, consumers. Agente que processa eventos: carrega catalog do BC relevante, não todo o catalog."
		meshImplication: "Design for agent consumption: (1) CLAUDE.md budget — máximo 3k tokens. Se excede: mover detalhe para docs linkados. CLAUDE.md é index + critical conventions, não encyclopedia. (2) progressive detail loading — agente carrega: CLAUDE.md (overview) → relevant dir listing (o que existe) → relevant file (detail). Cada step adiciona detail. Agente decide quanto detail precisa. (3) self-contained files — cada arquivo faz sentido sozinho. ADR tem context suficiente sem ler outros ADRs. Lens tem rationale suficiente sem ler outras lenses. Cross-references para quem quer mais, não para quem precisa do mínimo. (4) structured headers — agente scan por headers para encontrar seção relevante. Headers informativos: '## Scoring com Event Sourcing: Por que e Como' > '## Seção 3.2.' (5) IDs como anchors — todo conceito tem ID único (eda-event-sourcing, cr-expected-loss-model). Agente referencia por ID, não por frase. IDs são estáveis (não mudam com rewording). (6) examples as grounding — cada conceito com exemplo concreto da Mesh. Agente que lê conceito abstrato + exemplo concreto: aplica melhor do que conceito abstrato sozinho. Exemplos são o 'few-shot' do mesh-spec. (7) avoid narrative sprawl — docs técnicos não são blog posts. Cada frase deve informar, não entreter. Se frase pode ser removida sem perder informação: remover. Token budget é recurso escasso. Anti-pattern: lens de 10k tokens com 40% de narrative filler que poderia ser 6k tokens com mesma informação — agente consome 40% mais context sem benefício."
		dependsOn: ["dp-docs-as-cognitive-infrastructure", "dp-documentation-types"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-governance-as-code"
			context:   "AAG defines governance como código consultável por agentes. DP agent consumability projetar para que governance docs (policies, boundaries, conventions) sejam eficientemente consumíveis no context window. AAG codifica policies; DP garante que policies são concisas, structured, e loadable incrementalmente."
		}]
		rationale: "Context-window-aware docs 2024+. Documentation as prompt engineering 2024+. Na Mesh, cada token de docs no context window de agente é token indisponível para task. Docs conciso e structured maximiza: context relevante / context total."
	},
	{
		id:            "dp-documentation-metrics"
		name:          "Métricas de Documentação: Medir se Docs Está Funcionando"
		nature:        "operational"
		role:          "property"
		reviewCadence: "quarterly"
		definition:    "Conceito de 'documentation effectiveness' (2023+): medir não volume de docs (vanity) mas impacto: (1) findability — agente/humano encontra informação necessária? (2) accuracy — informação encontrada está correta e atual? (3) usability — informação encontrada é suficiente para tomar decisão ou completar tarefa? (4) efficiency — quanto tempo levou para encontrar e usar? Conceito contemporâneo de 'documentation as product metrics' (2024+): tratar docs como produto com métricas: (a) consumption — quais docs são mais acessados? (b) coverage — % de sistema documentado. (c) freshness — % de docs atualizados nos últimos 3 meses. (d) quality — feedback de consumers (agents e humans). (e) impact — decisões melhoradas por docs? Retrabalho evitado?"
		meshManifestation: "Na Mesh, métricas de docs: (1) agent consumption — quais arquivos do mesh-spec são mais frequentemente lidos por agentes? Se CLAUDE.md é lido 100% das sessões (expected). Se lenses são lidas 30% (on-demand, expected). Se ADRs são lidos 10% (when relevant, expected). Se schema de evento nunca é lido: agente não sabe que existe → melhorar referência em CLAUDE.md. (2) coverage — % de BCs com schema documentado. % de ADRs com status atualizado. % de eventos com entry no catálogo. % de endpoints com API reference. Target: 100% para schemas e catalog. (3) freshness — % de docs modificados nos últimos 3 meses onde código relacionado mudou. Target: >90% (some docs are stable because code is stable). (4) decision quality proxy — agente que consulta mesh-spec toma decisão que é accepted sem revision? Se 80% das decisões de agente são accepted: docs inform well. Se 40%: docs may be insufficient or misleading. (5) retrabalho — frequência de 'agente implementou X e depois descobriu que ADR Y dizia para fazer diferente.' Cada retrabalho = docs não was found or not read."
		meshImplication: "Medir e melhorar: (1) consumption tracking — se agente sessions são logged: quais arquivos foram acessados? Heatmap de docs consumption. Docs nunca acessados: either unnecessary (remove) or unfindable (improve discoverability). (2) coverage dashboard — automated: scan mesh-spec directories. Count: schemas, events, ADRs, lenses, guides. For each: documented? Updated? Coverage %: report quarterly. (3) freshness dashboard — for each doc: last_updated vs last_code_change for related component. If code changed after doc: flag as potentially stale. Report: % stale. (4) decision quality — track: agent decisions accepted vs revised. Correlate: did agent reference mesh-spec? If referenced and accepted: docs worked. If not referenced and revised: docs not found or not used. If referenced and revised: docs insufficient or wrong. (5) quarterly doc review — review metrics. Top action: (a) stale docs: update. (b) gap docs: create. (c) unused docs: evaluate if needed. (d) poor quality docs: improve based on agent feedback. Anti-pattern: 'mesh-spec has 500 files' as success metric — volume is vanity. Impact (decisions informed, retrabalho avoided) is reality."
		dependsOn: ["dp-freshness-maintenance", "dp-agent-consumability"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-sli-slo-error-budget"
			context:   "OOI defines SLIs/SLOs for services. DP documentation metrics defines SLIs/SLOs for documentation: freshness >90%, coverage >95%, agent decision acceptance rate >75%. OOI monitors technical health; DP monitors cognitive infrastructure health. Both are infrastructure — both need SLOs."
		}]
		rationale: "Documentation effectiveness 2023+. Documentation as product metrics 2024+. Na Mesh, mesh-spec com 500 files e 50% stale é pior que mesh-spec com 100 files e 95% fresh. Metrics inform where to invest."
	},
	{
		id:         "dp-single-source-of-truth"
		name:       "Single Source of Truth: Cada Informação Vive em Exatamente 1 Lugar"
		nature:     "theoretical"
		role:       "property"
		definition: "DRY (Don't Repeat Yourself — Hunt/Thomas 1999, The Pragmatic Programmer) aplicado a documentação: cada peça de informação tem exatamente 1 authoritative location. Todos os outros lugares que precisam dessa informação: referenciam, não duplicam. Se duplicada: eventualmente diverge. Quando diverge: qual é a verdade? Conceito de 'documentation coupling' (2023+): quando doc A duplica informação de doc B, mudança em B requer mudança em A. Se A não é atualizado: inconsistência. Quanto mais duplicação: mais coupling, mais inconsistência, mais custo de manutenção. Conceito contemporâneo de 'generated documentation' (2024+): documentação que é gerada automaticamente de source of truth: API reference gerada de OpenAPI spec. Event catalog gerado de schema files. Metrics definitions gerada de dbt semantic layer. Gerada = always in sync. Escrita manualmente = eventually stale."
		meshManifestation: "Na Mesh, SSOT por tipo de informação: (1) schema de evento — vive no event catalog (/schemas/events/). Referenciado por: lenses, ADRs, guides. Não duplicado. Se lens menciona AnticipationRequested: referência ao catalog, não cópia do schema. (2) decisão de arquitetura — vive no ADR (/architecture/adrs/adr-NNN.md). Referenciada por: CLAUDE.md, lenses, guides. Se CLAUDE.md menciona 'PostgreSQL como event store': link para ADR-007, não re-explicação. (3) métricas de negócio — vivem na semantic layer (dm-semantic-layer). Referenciadas por: lenses, reports, dashboards. Se lens menciona 'inadimplência': referência à definição na semantic layer, não definição própria. (4) conventions — vivem no CLAUDE.md (ou linked doc). Referenciadas por: lenses, guides, schemas. Se guia menciona naming convention: link para CLAUDE.md, não re-explicação. (5) axiomas e design principles — vivem em /foundations/. Referenciados por ID (ax-01, dp-05) em todo o mesh-spec."
		meshImplication: "SSOT discipline: (1) for each information type: identify authoritative location. Document in index. (2) when writing new doc: before adding information, check — does this information already exist elsewhere? If yes: reference (link + ID), don't copy. (3) when information changes: change in authoritative location. All references automatically point to updated version (if referencing by link/ID). (4) generated where possible: API reference generated from OpenAPI spec (DX docs). Event catalog generated from schema files. Config reference generated from CUE schemas with descriptions. Generated docs are always in sync. (5) when duplication is detected: remove duplicate, replace with reference. Add CI check: 'definition of X appears in only 1 file.' (6) for agents: CLAUDE.md instructs 'when referencing concept, use ID (e.g., eda-event-sourcing) — do not copy definition. Definitions live in their authoritative location.' Agent output that copies definition instead of referencing: review feedback. Anti-pattern: mesh-spec where 'inadimplência' is defined in 3 lenses with slightly different definitions — when regulador asks 'how do you define inadimplência?': which definition is authoritative? Nobody knows."
		dependsOn: ["dp-information-architecture"]
		rationale: "DRY Hunt/Thomas 1999. Documentation coupling 2023+. Generated documentation 2024+. Na Mesh, SSOT previne o cenário mais perigoso: agente que lê definição A em lens X e definição B em lens Y e não sabe qual é correta. 1 definição, 1 location, N references."
	},
	{
		id:         "dp-docs-lifecycle"
		name:       "Lifecycle de Documentação: Criar, Manter, Deprecar, Remover"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Documentação tem lifecycle como software: create → maintain → deprecate → remove. Docs que não são removidas quando obsoletas: acumulam como dead weight que confunde. Conceito de 'documentation debt' (2023+): docs desatualizados, duplicados, ou obsoletos que custam tempo para navegar e geram confusão. Análogo a technical debt. Conceito contemporâneo de 'living documentation' (Martraire 2019, Living Documentation): documentação que se atualiza automaticamente ou que é intrinsecamente ligada ao código que descreve — quando código muda, doc muda. Annotations no código que geram docs. Schemas que incluem descriptions. Tests que servem como documentation de behavior."
		meshManifestation: "Na Mesh, lifecycle por tipo: (1) ADR — create: quando decisão é tomada. Maintain: status update (proposed → accepted → deprecated → superseded). Deprecate: quando nova decisão supersede. Remove: nunca (ADRs são historical record — deprecated ADR mantido com status 'superseded by ADR-NNN'). (2) schema — create: quando novo artefato é definido. Maintain: quando schema evolui. Deprecate: quando artefato é deprecated. Remove: quando artefato é removido do sistema. (3) lens — create: quando novo reasoning framework é necessário. Maintain: quarterly review (conceitos novos, exemplos atualizados). Deprecate: quando domínio muda e lens não é mais relevante. Remove: quando deprecated lens não é referenciada por nenhum artefato. (4) guide — create: quando novo processo é estabelecido. Maintain: quando processo muda. Deprecate: quando processo é substituído. Remove: quando deprecated guide confunde mais que informa. (5) CLAUDE.md — create: once. Maintain: every decision that affects architecture or conventions. Deprecate: never (always current). Remove: never."
		meshImplication: "Lifecycle management: (1) creation gate — before creating new doc: does this information already exist (SSOT)? Is it a recognized type (Diátaxis)? Does it have owner? If no owner: don't create (orphan doc will fossilize). (2) maintenance trigger — per-PR: if code changes affect doc: update. Quarterly: review freshness metrics. If stale: update or deprecate. (3) deprecation protocol — when doc is obsolete: mark status = 'deprecated'. Add note: 'this document is deprecated. See [replacement] for current information.' Do not remove immediately — consumers may still reference. (4) removal — after 3 months deprecated with no references: remove. Or: if deprecated doc is never accessed (metrics): remove sooner. (5) documentation debt tracking — add 'doc debt' items to debt register (td-debt-inventory): 'lens-X has 3 outdated examples. Interest: agents apply outdated patterns. Effort to fix: 2h.' Prioritize by interest rate (how frequently accessed × how wrong). (6) living documentation where possible — CUE schemas with inline descriptions are living docs (change schema = change docs). OpenAPI spec with descriptions are living docs. Prefer living docs over separate docs for reference material. Anti-pattern: mesh-spec that only grows and never shrinks — 500 files where 100 are deprecated but not removed, 50 are duplicated, and 30 are contradicted by newer docs."
		dependsOn: ["dp-freshness-maintenance", "dp-single-source-of-truth"]
		crossDependsOn: [{
			lensId:    "lens-technical-debt-as-strategic-instrument"
			conceptId: "td-debt-inventory"
			context:   "TD defines debt register for tracking technical debt. DP documentation debt is tracked in the same register: stale docs, duplicate content, missing coverage. TD provides the tracking mechanism; DP provides the documentation-specific debt items. 'Lens X has outdated examples' is documentation debt tracked alongside 'endpoint Y has no error handling' (code debt)."
		}]
		rationale: "Documentation debt 2023+. Martraire 2019: living documentation. Na Mesh, mesh-spec that accumulates without lifecycle management becomes the problem it was designed to solve — instead of enabling agents, it confuses them with mixed signals of current and obsolete information."
	},
	{
		id:            "dp-documentation-review"
		name:          "Revisão de Documentação: Inventário Periódico de Saúde do Mesh-Spec"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) cognitive infrastructure — CLAUDE.md current? Agents referencing mesh-spec? Decisions improved? (2) information architecture — hierarchy clear? New content in right location? Index files updated? (3) documentation types — each type has coverage? Tutorials for common tasks? Reference for all schemas? (4) freshness — % stale docs? Stale docs in critical areas? (5) agent consumability — CLAUDE.md within token budget? Docs concise? (6) metrics — consumption, coverage, freshness, decision quality. (7) SSOT — duplication detected? References instead of copies? (8) lifecycle — deprecated docs marked? Dead docs removed?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: CLAUDE.md freshness check (most critical). Trimestral: full mesh-spec health audit."
		meshImplication: "Mensal (20min): CLAUDE.md — still accurate? Architecture changed? New conventions? New decisions? If any: update immediately. Stale CLAUDE.md invalidates every agent session until fixed. Quarterly (1.5h): coverage — schemas documented? Events cataloged? ADRs have status? Lenses reviewed? Freshness — % of docs where related code changed more recently. If >20% stale: prioritize update. Agent consumption — any feedback from agent sessions indicating missing or misleading info? SSOT — any definition appearing in >1 location? Cross-references valid? Lifecycle — any docs deprecated >3 months ago that should be removed? Any docs never accessed that should be evaluated? Documentation debt — items in debt register. Interest rate. Priority. If review identifies zero improvements: either mesh-spec is perfect (unlikely) or review is superficial."
		dependsOn: ["dp-docs-as-cognitive-infrastructure", "dp-information-architecture", "dp-documentation-types", "dp-freshness-maintenance", "dp-agent-consumability", "dp-documentation-metrics", "dp-single-source-of-truth", "dp-docs-lifecycle"]
		rationale: "Mesh-spec degrades like any infrastructure — entropy increases without maintenance. Monthly CLAUDE.md check + quarterly full audit keeps cognitive infrastructure healthy and agents effective."
	},
]

reasoningProtocol: [
	{
		question:  "O mesh-spec é a source of truth que governa implementação? Ou é descrição que acompanha (e eventualmente diverge de) código?"
		reveals:   "Se documentação é infraestrutura cognitiva viva — ou se é artefato decorativo que fossiliza."
		rationale: "Documentation-driven architecture 2023+. Na Mesh: spec governa. Código que diverge de spec: código está errado."
	},
	{
		question:  "CLAUDE.md está atualizado e cabe em ~3k tokens? Agente que lê CLAUDE.md obtém context correto para iniciar sessão?"
		reveals:   "Se entry point cognitivo é funcional — ou se agente começa com context errado ou incompleto."
		rationale: "CLAUDE.md é o document mais importante do mesh-spec. Stale CLAUDE.md = every agent session starts wrong."
	},
	{
		question:  "Cada tipo de doc (tutorial, how-to, reference, explanation, machine-readable, ADR) existe e é usado para seu propósito?"
		reveals:   "Se documentação serve cada necessidade — ou se é monólito que não serve nenhuma bem."
		rationale: "Procida 2023: Diátaxis. Tipos servem necessidades diferentes. Reference without explanation: agente sabe o quê mas não por quê."
	},
	{
		question:  "Docs freshness é monitorada? % de docs stale é conhecido? Docs em áreas críticas estão atualizados?"
		reveals:   "Se freshness é gerenciada — ou se docs fossiliza silenciosamente até agente aplicar pattern obsoleto."
		rationale: "Documentation decay 2022+. Stale doc that agent trusts is worse than no doc."
	},
	{
		question:  "Docs é conciso e structured para consumo por agente? CLAUDE.md cabe no budget de tokens? Seções são self-contained?"
		reveals:   "Se docs respeita context window — ou se agente precisa carregar 20k tokens para encontrar 500 tokens relevantes."
		rationale: "Context-window-aware 2024+. Token budget é recurso escasso. Concise + structured = máximo context relevante."
	},
	{
		question:  "Cada informação vive em exatamente 1 lugar (SSOT)? Ou existem definições duplicadas que podem divergir?"
		reveals:   "Se verdade é unambígua — ou se agente encontra definições conflitantes e não sabe qual é correta."
		rationale: "DRY 1999. Na Mesh: 'inadimplência' definida em 1 lugar na semantic layer. Toda referência aponta para lá."
	},
]

meshExamples: [
	{
		id:       "ex-claude-md-optimization"
		scenario: "CLAUDE.md cresceu para 8k tokens com detalhes de cada BC, convention, e decision. Agente consome 40% do context window apenas com CLAUDE.md. Performance de agente degradou: respostas mais lentas e menos context para task."
		analysis: "CLAUDE.md excedeu budget. Com 8k tokens: agente tem menos espaço para task context, schemas, e código. Performance degrada não porque agente é ruim — mas porque context window está saturado com meta-information em vez de task information. CLAUDE.md original (3k tokens) era overview + links. Cresceu porque cada decisão adicionou detalhe inline em vez de linkar para ADR."
		recommendation: "(1) Audit CLAUDE.md: para cada seção: é overview ou detail? Overview permanece. Detail move para doc linkado. 'PostgreSQL é usado como event store (ver ADR-007)' — 15 tokens. vs 'PostgreSQL é usado como event store porque EventStoreDB adiciona complexidade operacional e para o estágio atual com <10k eventos PostgreSQL com Marten satisfaz requisitos de...' — 80 tokens. (2) CLAUDE.md structure: 3 seções obrigatórias: (a) Architecture overview (10 linhas max): BCs, stack, data flow. (b) Active conventions (bullet list): naming, patterns, tools, anti-patterns. (c) Where to find (index): '/schemas/ for event schemas. /architecture/adrs/ for decisions. /lenses/ for reasoning frameworks.' (3) Token budget: target 2.5-3k tokens. Maximum 4k. CI check: 'CLAUDE.md exceeds 4000 tokens — trim or move detail to linked docs.' (4) Linked detail: cada tópico em CLAUDE.md tem link para deep doc. Agente que precisa de detail: carrega linked doc on-demand. Agente que precisa de overview: CLAUDE.md é suficiente. Progressive loading. (5) Test: nova sessão de agente com CLAUDE.md otimizado. Task: 'criar endpoint para listar operações de fornecedor.' Agente lê CLAUDE.md (3k) → identifica que precisa de schemas + conventions → carrega schema relevante (2k) + convention (1k). Total context: 6k. vs antes: 8k CLAUDE.md + 2k schema + 1k convention = 11k. Saving: 5k tokens for task."
		principlesApplied: ["ax-01", "ax-03", "dp-01"]
		assumptions: [
			"3k tokens é suficiente para overview — pode ser tight para sistema complexo com 10+ BCs",
			"agente carrega linked docs on-demand — depends on agent workflow (some load everything upfront)",
			"CI check de token count é implementável — simple script counting tokens",
			"performance degrada com CLAUDE.md grande — depends on model and task complexity",
		]
		rationale: "Context-window-aware 2024+. Documentation as prompt engineering 2024+. Na Mesh, CLAUDE.md é system prompt que every agent session loads. Bloated system prompt = degraded performance. Optimize for signal/noise ratio."
	},
	{
		id:       "ex-ssot-violation-detection"
		scenario: "Agente criando novo ADR define 'inadimplência' como 'operações com atraso >60 dias.' Revisão detecta: semantic layer define inadimplência como 'operações com atraso >90 dias' (dm-semantic-layer). Lente de credit risk define como 'PD × LGD para operações com atraso >90 dias.' Definição no ADR conflita."
		analysis: "SSOT violation: 'inadimplência' definida em 3 lugares com 2 definições diferentes (60d vs 90d). Consequência: se ADR é implementado com 60d: relatório de FIDC (que usa semantic layer com 90d) mostra número diferente. Investidor vê inconsistência. Causa raiz: agente não consultou semantic layer antes de definir termo. CLAUDE.md não referencia semantic layer como SSOT para métricas."
		recommendation: "(1) Fix imediato: ADR atualizado para referenciar definição da semantic layer: 'inadimplência conforme definida na semantic layer (>90 dias). Ver dm-semantic-layer.' Não redefinir. (2) Prevention — CLAUDE.md update: adicionar em conventions: 'métricas de negócio (inadimplência, receita, volume) são definidas na semantic layer. Quando mencionar em ADR, lens, ou guide: referenciar definição da semantic layer por ID. Não redefinir.' (3) SSOT enforcement: CI check que scans para termos-chave (inadimplência, receita, volume, etc.) em novos docs e verifica se são referências (contêm link/ID para definição) ou definições (contêm 'é definido como' ou equivalente). Se definição detectada fora de SSOT: warning 'term X appears to be redefined. Authoritative definition is in [location]. Reference instead of redefine.' (4) Glossário como SSOT index: /foundations/glossary.md com: cada termo de negócio → authoritative location. 'inadimplência → semantic layer (dm-semantic-layer, metric: inadimplencia_90d). taxa → pricing engine (pm-risk-based-pricing). score → scoring model (ml-model-versioning-reproducibility, model card).' Agente que precisa de definição: consulta glossário → navega para SSOT."
		principlesApplied: ["ax-01", "ax-06", "dp-01"]
		assumptions: [
			"CI scan de termos-chave é implementável — requires NLP or keyword matching",
			"glossário é consultado por agentes antes de definir termos — depends on CLAUDE.md instruction",
			"3 locations com definições conflitantes é detectable — requires awareness of all locations",
			"semantic layer é o SSOT correto para inadimplência — verify with FIDC and regulador",
		]
		rationale: "DRY 1999. SSOT. Na Mesh, 'inadimplência' definida como 60d em ADR vs 90d na semantic layer: investidor que vê números diferentes perde trust. SSOT violation em métrica financeira é compliance risk + trust risk. Glossário + CI detection previnem."
	},
	{
		id:       "ex-agent-session-onboarding"
		scenario: "Nova sessão de agente Claude Code para implementar webhook endpoint para notificação de operação aprovada. Agente não tem context prévio. Como docs habilita agente a implementar corretamente sem reinventar?"
		analysis: "Agente precisa: (1) conventions (naming, error handling, auth pattern). (2) event schema (OperationApproved — quais campos?). (3) API pattern (webhook design — retry, signature, format). (4) architecture (onde webhook endpoint vive — qual BC?). Sem docs: agente inventa naming, cria schema from scratch, implementa webhook sem retry. Com docs: agente aplica patterns existentes."
		recommendation: "Workflow documentado do agente: (1) Agente lê CLAUDE.md — obtém: architecture overview, conventions (snake_case, RFC 9457 errors, @authenticated), e where to find ('schemas in /schemas/, API patterns in /guides/'). 2.5k tokens. (2) Agente navega /schemas/events/ — encontra ecl.OperationApproved.cue com: event_id, operation_id, supplier_id, buyer_id, value, approved_at, score, model_version. 500 tokens. Não precisa inventar schema. (3) Agente navega /guides/how-to/webhook-implementation.md — encontra: 'webhooks follow Svix pattern: POST to subscriber URL with JSON payload, HMAC-SHA256 signature in header, retry with exponential backoff (1s, 5s, 30s, 5min), idempotency via event_id. See api-async-patterns concept.' 300 tokens. (4) Agente navega /architecture/adrs/ se necessário — ADR-012 'webhook design: Svix pattern for external, internal events via event broker.' 200 tokens. Total context loaded: ~3.5k tokens. Context remaining for implementation: >>50% of window. (5) Agente implementa: webhook endpoint com naming correto, schema from catalog, retry pattern from guide, auth from convention. Output é consistent com sistema existente. (6) PR review: CI verifica auth middleware, schema conformance, test presence. Human reviews business logic. Merge. Documenting this flow in /guides/how-to/implement-webhook.md enables any future agent session to follow same path. Cada guide é investment in all future agent sessions."
		principlesApplied: ["ax-01", "ax-03", "dp-01"]
		assumptions: [
			"agente follows CLAUDE.md instruction to navigate docs — depends on CLAUDE.md clarity",
			"3.5k tokens of context is sufficient for webhook implementation — depends on complexity",
			"schemas and guides are findable via directory navigation — depends on IA quality",
			"CI catches deviations from patterns — depends on CI rule coverage",
		]
		rationale: "Cognitive prosthetic. Agent consumability 2024+. Na Mesh, agente que navega mesh-spec em 2 minutes e loads 3.5k tokens of relevant context: implements webhook correctly with zero reinvention. Same agent without docs: reinvents schema, misses retry, uses wrong naming. Docs are the difference."
	},
	{
		id:       "ex-documentation-freshness-audit"
		scenario: "Quarterly docs review reveals: 15 of 40 ADRs have status 'accepted' but 3 were superseded by newer decisions without status update. Event catalog has 12 events but 2 were renamed in code without catalog update. CLAUDE.md references 'ECL bounded context' but code now calls it 'Operations' module."
		analysis: "Documentation decay: 3 superseded ADRs without update (agent may apply revoked decision). 2 events renamed (agent may reference wrong event name). CLAUDE.md with old terminology (agent confused by mismatch between docs and code). Total stale items: 6. Impact: any agent session may encounter stale information and make wrong decision. Severity: medium (no single item is critical, but cumulative confusion)."
		recommendation: "(1) Fix 6 stale items immediately: (a) 3 ADRs: update status to 'superseded by ADR-NNN.' Add note linking to new decision. (b) 2 events: update catalog with new names. Update all references in lenses and guides. (c) CLAUDE.md: update terminology from 'ECL bounded context' to 'Operations module' (or whatever current name is). (2) Prevention measures: (a) ADR lifecycle rule: 'when creating new ADR that supersedes existing: update status of superseded ADR in same PR.' CI: 'new ADR references superseded ADR → verify superseded has updated status.' (b) Event rename protocol: 'when renaming event: update catalog + all references in same PR.' CI: 'event name in code must match event name in catalog.' (c) CLAUDE.md review: add to monthly check: 'terminology in CLAUDE.md matches current codebase naming.' (3) Freshness dashboard: implement script that: (a) for each ADR: check if status field exists and is one of [proposed, accepted, deprecated, superseded]. (b) for each event in catalog: check if event name matches code. (c) for CLAUDE.md: check last_modified vs last code architecture change. Report: freshness score = (fresh docs / total docs) × 100. Target: >95%. Current: (34/40 ADRs + 10/12 events + 0/1 CLAUDE.md) / 53 = 83%. Below target. (4) Debt register: add 'documentation freshness maintenance — 3 items found. Interest: agents may apply wrong decision or reference wrong event. Priority: high for CLAUDE.md (every session), medium for ADRs and events (on-demand).'"
		principlesApplied: ["ax-03", "ax-06", "dp-01"]
		assumptions: [
			"6 stale items detected means review is working — may be more that review didn't catch",
			"CI checks for event name match are implementable — requires naming convention + tooling",
			"monthly CLAUDE.md check is sufficient — may need per-decision check for fast-moving periods",
			"freshness score of 83% is diagnosable — need to identify which items are most impactful",
		]
		rationale: "Documentation decay 2022+. Freshness maintenance. Na Mesh, 3 superseded ADRs without update = 3 potential wrong decisions by agent. 2 renamed events without catalog update = 2 potential wrong implementations. CLAUDE.md with old terminology = every agent session confused. Proactive detection + systematic fix + prevention > discovering stale docs when agent error occurs."
	},
]

principleIds: ["ax-01", "ax-03", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-knowledge-management"
		relation: "complementsWith"
		context:  "KM defines organizational memory and knowledge as code. DP operationalizes: mesh-spec as the implementation of organizational memory for AI-native org. KM is the principle (preserve knowledge); DP is the product (mesh-spec designed for findability, freshness, and dual-audience consumption)."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governs agents with policies and boundaries. DP provides the cognitive infrastructure that agents consume to operate within governance: CLAUDE.md with conventions, lenses with reasoning frameworks, ADRs with decisions. AAG defines what agent must follow; DP ensures agent can find it."
	},
	{
		lensId:   "lens-developer-and-integrator-experience"
		relation: "complementsWith"
		context:  "DX covers API documentation for external developers. DP covers internal documentation (mesh-spec) for agents and founders. Same principles (Diátaxis, freshness, testing), different audience. DX is external docs; DP is internal docs. Both are products, not afterthoughts."
	},
	{
		lensId:   "lens-technical-debt-as-strategic-instrument"
		relation: "complementsWith"
		context:  "TD tracks technical debt including documentation debt. DP identifies stale, duplicate, or missing docs as debt items. TD provides tracking mechanism (debt register); DP provides the specific items (CLAUDE.md stale, ADR status outdated)."
	},
	{
		lensId:   "lens-cross-cutting-concern-integration"
		relation: "complementsWith"
		context:  "CC defines concern consistency and verification. DP documentation freshness is a cross-cutting concern: every component (BC, API, event, agent) should have docs, and docs should be fresh. CC provides the verification framework; DP applies for documentation."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI monitors system health with SLIs/SLOs. DP defines SLIs for documentation: freshness >90%, coverage >95%, CLAUDE.md within token budget. Both are infrastructure that needs monitoring."
	},
	{
		lensId:   "lens-data-modeling-for-analytical-power"
		relation: "complementsWith"
		context:  "DM semantic layer defines metrics as code (SSOT for business metrics). DP uses semantic layer as authoritative location for metric definitions. When lens references 'inadimplência': references semantic layer, doesn't redefine. DM is the SSOT; DP references."
	},
	{
		lensId:   "lens-event-driven-architecture-patterns"
		relation: "complementsWith"
		context:  "EDA defines event catalog as canonical inventory of events. DP treats event catalog as documentation product: each event documented with schema, producer, consumers, version. EDA defines what events are; DP ensures they're documented and discoverable."
	},
]

limitations: [
	{
		description: "Documentation as cognitive prosthetic assumes that agents read and follow docs. In practice, agent may ignore docs if: context window is too small to load them, docs are poorly structured, or agent prompt doesn't instruct to consult."
		alternative: "Enforce docs consumption: CLAUDE.md as mandatory first read (instruction in agent prompt). Scaffold that generates code from spec (agent doesn't need to read — scaffold embodies docs). CI that verifies output matches spec (docs are verified post-hoc, not just pre-hoc)."
		rationale: "Docs that aren't consumed have zero value. Make consumption automatic (scaffold) or verified (CI), not optional."
	},
	{
		description: "Maintaining docs freshness for AI-native development is harder than traditional — agents generate and modify code faster, docs fall behind faster."
		alternative: "Living documentation priority: CUE schemas with inline descriptions > separate markdown docs. Generated docs from source of truth > manually written docs. For what can't be auto-generated: strict co-change rule (PR that changes code must change docs)."
		rationale: "In AI-native dev, code velocity is high. Docs velocity must match. Living docs are the only sustainable approach at high velocity."
	},
	{
		description: "SSOT discipline is difficult when multiple agents in different sessions create content — each session may create new definitions unaware of existing ones."
		alternative: "CLAUDE.md instructs: 'before defining term, check glossary.' CI detects duplicate definitions. Post-session review scans for SSOT violations. Glossary as mandatory reference."
		rationale: "Multiple agents without shared memory will duplicate unless instructed and verified. CLAUDE.md instruction + CI detection + review is the defense."
	},
	{
		description: "Token budget for CLAUDE.md (~3k) may be insufficient for complex systems with 10+ BCs, 40+ lenses, and 50+ ADRs. Overview that fits 3k tokens may be too shallow."
		alternative: "Layered CLAUDE.md: core (2k) with links to domain-specific supplements. Agent working on scoring: loads CLAUDE.md (2k) + scoring-supplement.md (1k). Agent working on compliance: loads CLAUDE.md (2k) + compliance-supplement.md (1k). Total: 3k, but domain-specific."
		rationale: "One-size-fits-all CLAUDE.md doesn't scale. Domain-specific supplements are the progressive disclosure of cognitive infrastructure."
	},
	{
		description: "Documentation metrics (consumption, freshness, decision quality) are difficult to measure precisely — especially for AI agent sessions where tool usage may not be logged at artifact level."
		alternative: "Proxy metrics: PR acceptance rate (proxy for decision quality), CI docs-related failures (proxy for freshness), agent session output consistency (proxy for consumption). Qualitative: founder reviews 5 agent sessions/quarter — was mesh-spec referenced? Was output consistent? Proxies + qualitative > no measurement."
		rationale: "Perfect metrics are impossible. Imperfect proxies + qualitative review are sufficient to guide improvement."
	},
]

rationale: "Na Mesh AI-native onde agentes IA operam sem memória persistente, documentação não é artefato complementar — é infraestrutura cognitiva que determina qualidade de cada sessão de agente. Esta lens operacionaliza: documentação como cognitive prosthetic com dual-audience design (cognitive prosthetic original, documentation as interface 2022+, dual-audience 2024+, documentation-driven architecture 2023+), information architecture com layered structure e progressive loading (Rosenfeld/Morville 2015, Procida 2023, layered documentation 2024+), tipos de documentação com Diátaxis estendido para machine-readable e ADRs (Procida 2023, machine specs, decision records), freshness como SLI com docs-as-code e automated testing (documentation decay 2022+, docs-as-code 2020+, documentation testing 2023+), agent consumability com context-window-aware design e token budgeting (context-window-aware 2024+, documentation as prompt engineering 2024+), métricas de eficácia com consumption e decision quality proxy (documentation effectiveness 2023+, docs as product metrics 2024+), SSOT com DRY e generated documentation (Hunt/Thomas 1999, documentation coupling 2023+, generated docs 2024+), e lifecycle com documentation debt tracking (documentation debt 2023+, Martraire 2019 living documentation). Universal na architecture (layered, typed, fresh); específica na application (mesh-spec como cognitive prosthetic para AI agents)."

}
