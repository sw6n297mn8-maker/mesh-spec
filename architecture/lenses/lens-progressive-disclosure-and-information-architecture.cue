package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

progressiveDisclosureAndInformationArchitecture: artifact_schemas.#AnalyticalLens & {
id:     "lens-progressive-disclosure-and-information-architecture"
name:   "Progressive Disclosure e Arquitetura de Informação"

purpose: "Orientar decisões sobre como revelar complexidade progressivamente — novato vê o essencial, expert acessa profundidade, ninguém é sobrecarregado."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como organizar informação em camadas que revelam complexidade gradualmente",
		"a decisão envolve como projetar navigation que permite encontrar informação sem conhecer a estrutura completa",
		"a decisão envolve como agrupar e categorizar funcionalidades para diferentes níveis de expertise",
		"a decisão envolve como projetar defaults que servem 80% dos usuários sem configuração",
		"a decisão envolve como revelar opções avançadas sem sobrecarregar iniciantes",
		"a decisão envolve como projetar hierarquia de menus, tabs, e páginas para plataforma complexa",
		"a decisão envolve trade-offs entre flat navigation (tudo acessível) e deep navigation (organizado mas enterrado)",
		"a decisão envolve como patterns de disclosure (accordion, tab, modal, drawer, expandable section) servem diferentes conteúdos",
		"a decisão envolve como projetar wizards vs forms para tarefas multi-step",
		"a decisão envolve como adaptar navigation e disclosure para mobile vs desktop",
	]
	keywords: [
		"progressive disclosure", "revelação progressiva",
		"information architecture", "IA", "arquitetura de informação",
		"navigation", "navegação", "menu", "sidebar", "breadcrumb",
		"hierarchy", "hierarquia", "categorization", "agrupamento",
		"default", "configuração padrão", "zero-config",
		"advanced", "avançado", "opções", "settings",
		"wizard", "stepper", "multi-step", "passo a passo",
		"accordion", "tab", "modal", "drawer", "expandable",
		"flat navigation", "deep navigation", "nested",
		"findability", "discoverability", "descobribilidade",
		"sitemap", "taxonomy", "card sorting",
	]
	excludeWhen: [
		"a decisão é sobre densidade de informação por tela — usar information-density-design",
		"a decisão é sobre visualização de dados (encoding, charts) — usar data-visualization-semiotics",
		"a decisão é sobre tipografia para interfaces densas — usar typographic-systems-for-dense-interfaces",
		"a decisão é sobre jobs e workflows de persona — usar jobs-to-be-done-and-workflow-design",
		"a decisão é sobre design tokens e composição — usar design-tokens-and-systematic-composition",
	]
	rationale: "Toda plataforma complexa precisa organizar centenas de funcionalidades de forma que: iniciante encontra o que precisa sem se perder, expert acessa funcionalidade avançada sem obstáculo, e a complexidade do sistema não é exposta de uma vez. Na Mesh com múltiplas personas (fornecedor, construtora, FIDC) e múltiplos domínios (operações, qualificação, compliance, analytics, configuração), a information architecture governa como cada persona navega e como complexidade é revelada. ID cobre densidade por tela; JTBD cobre workflows e progressive disclosure como princípio de UX. Esta lens cobre a arquitetura de informação completa — como organizar, categorizar, navegar, e revelar conteúdo da plataforma para que cada persona encontre o que precisa no momento que precisa."
}

concepts: [
	{
		id:         "pd-disclosure-layers"
		name:       "Camadas de Disclosure: Revelar Complexidade em Stages, Não de Uma Vez"
		nature:     "theoretical"
		role:       "framework"
		definition: "Nielsen (2006, 'Progressive Disclosure'): mostrar apenas o essencial inicialmente, revelar detalhes sob demanda. Reduz cognitive load sem reduzir capability. Princípio: interface tem mesma potência que interface complexa — mas complexidade é organizada em layers acessíveis progressivamente. Conceito de '3-layer disclosure model' para B2B (2023+): (1) essential layer — visível por default. O que 80% dos usuários precisa 80% do tempo. Zero-config, zero decisão. (2) contextual layer — acessível com 1 click. Opções, configurações, detalhes que explicam o essential. Para usuário que quer entender ou customizar. (3) power layer — acessível via settings, API, ou advanced mode. Full control para experts. Configurações granulares, automações, integrações. Conceito contemporâneo de 'smart defaults as disclosure mechanism' (2024+): default não é ausência de escolha — é a melhor escolha para a maioria. Cada default é decisão de produto que encapsula knowledge. Default de score threshold = 60 encapsula 'análise de inadimplência mostra que <60 tem default >15%.' Expert pode mudar; novato aceita e está protegido."
		meshManifestation: "Na Mesh, 3 layers por funcionalidade: (1) submissão de operação — essential: comprador (dropdown), valor, nota fiscal (upload). Smart defaults: taxa calculada automaticamente, prazo inferido da nota, modalidade = 'definitiva'. Contextual: 'ver detalhes da taxa' (decomposição), 'alterar prazo', 'alterar modalidade'. Power: API para submissão programática com todos os parâmetros, webhook config para notificação custom. (2) configuração de políticas (construtora) — essential: zero-config (defaults seguros aplicados). Construtora opera sem configurar nada. Contextual: wizard de 3 steps para customização comum (tolerância de risco, valor máximo, documentos). Power: painel com todos os parâmetros + regras condicionais + API de configuração. (3) relatório FIDC — essential: dashboard com 4 KPIs (headline). Contextual: drill-down em cada KPI (chart, tabela filtrada). Power: custom report builder, export avançado, API de dados."
		meshImplication: "Para cada funcionalidade: (1) definir os 3 layers antes de implementar — não adicionar 'avançado' depois. (2) essential layer deve funcionar sem qualquer input além do mínimo. Se essential requer decisão que novato não sabe tomar: default. Se não há default razoável: wizard que guia. (3) transition entre layers: click/tap único. 'Opções avançadas ▸' colapsado. 'Ver detalhes' link inline. 'Configurações' em sidebar ou settings page. Nunca: 5 clicks para chegar ao power layer. (4) no feature hiding — power layer é acessível, não escondido. Expert sabe que existe porque contextual layer indica ('para configuração avançada, acesse [Configurações]'). Novato não é sobrecarregado porque power layer não é default. (5) defaults como ADR — cada default documentado: valor, rationale, impacto se mudado. 'Score threshold default = 60. Rationale: scores <60 têm default rate >15%. Se construtora muda para 50: alerta que risco sobe significativamente.' (6) measure layer adoption: % de usuários que usam apenas essential (expected: 60-70%). % que acessam contextual (25-35%). % que usam power (5-10%). Se power layer tem 0% usage: features desperdiçadas ou undiscoverable. Se essential has 30%: muita complexidade no essential — mover para contextual. Anti-pattern: formulário com 30 campos onde 5 são essenciais e 25 são avançados mas todos visíveis simultaneamente — novato não sabe quais preencher."
		rationale: "Nielsen 2006: progressive disclosure. 3-layer B2B 2023+. Smart defaults 2024+. Na Mesh, disclosure em 3 layers é o que permite que fornecedor PME opere em 2 minutos e construtora enterprise customize em 30 minutos — mesmo produto, experiences diferentes."
	},
	{
		id:         "pd-navigation-architecture"
		name:       "Arquitetura de Navegação: Como Personas Encontram o Que Precisam"
		nature:     "theoretical"
		role:       "framework"
		definition: "Rosenfeld/Morville (2015, Information Architecture, 4th ed.): navigation design organiza conteúdo para que usuário encontre informação com mínimo de clicks e mínimo de cognitive load. Tipos: (1) global navigation — presente em toda página (sidebar, top nav). Overview do sistema. (2) local navigation — específica de seção (tabs dentro de página). (3) contextual navigation — links inline que conectam conteúdo relacionado. (4) utility navigation — funcionalidades auxiliares (perfil, settings, help). Conceito de 'navigation depth vs breadth' (2022+): flat (muitos items em 1 nível — fácil de ver, difícil de scan) vs deep (poucos items com sub-níveis — fácil de scan, difícil de encontrar enterrado). Sweet spot: 5-7 items top-level com 2-3 levels max. Conceito contemporâneo de 'role-based navigation' (2023+): em plataformas multisided, navigation é diferente por role. Fornecedor vê: Operações, Documentos, Perfil. Construtora vê: Dashboard, Fornecedores, Operações, Compliance, Configurações. FIDC vê: Carteira, Operações, Relatórios, Risco. Mesma plataforma, navigation diferente. Conceito de 'navigation as progressive disclosure' (2024+): navigation structure é disclosure — top-level items são essential. Sub-items são contextual. Deep settings são power. Navigation IS the information architecture."
		meshManifestation: "Na Mesh, navigation por role: (1) fornecedor (mobile-first, 3-4 items) — bottom tabs: Operações (lista + submissão), Documentos (upload + status), Perfil (dados + settings). Possível 4th: Notificações. Flat: 3-4 items, zero sub-navigation. Tudo acessível em 1 tap. (2) construtora (desktop-first, 5-7 items) — sidebar: Dashboard (overview), Fornecedores (lista + qualificação), Operações (pipeline + histórico), Compliance (status + alertas), Analytics (métricas + reports), Configurações (políticas + integrações). Sub-navigation: Fornecedores → [Todos | Qualificados | Pendentes | Inativos] como tabs dentro da página. (3) FIDC (desktop, 4-5 items) — sidebar: Carteira (overview + detail), Operações (lista + análise), Relatórios (gerados + custom), Risco (métricas + stress test), Configurações. Sub-navigation: Carteira → [Overview | Concentração | Safras | Histórico]."
		meshImplication: "Design de navigation: (1) role-based — cada persona vê navigation diferente. Implementar: role no login determina sidebar/tabs. Não mostrar items irrelevantes. Fornecedor não vê 'Compliance' (construtora concern). FIDC não vê 'Documentos' (fornecedor concern). (2) depth: máximo 3 levels. Level 1: sidebar items (Dashboard, Fornecedores). Level 2: tabs dentro de página ([Todos | Qualificados]). Level 3: expandable sections ou drill-down (detalhe de fornecedor individual). Se >3 levels: reorganizar. (3) breadcrumb: para navigation >2 levels: breadcrumb mostra path. 'Dashboard > Fornecedores > Fornecedor ABC > Operações.' Usuário sabe onde está e pode navegar back. (4) global search: para plataforma com 100+ entities: search global. 'Buscar fornecedor, operação, ou documento...' Search que encontra por: nome, CNPJ, ID de operação, status. Complementa navigation — expert usa search quando sabe o que quer; novato usa navigation quando explora. (5) mobile navigation: fornecedor — bottom tabs (3-4 items, thumb-reachable). Construtora mobile — hamburger menu com items prioritários. FIDC mobile — minimal (4 KPIs + link para desktop). (6) navigation consistency: items sempre na mesma posição. Fornecedor que usa por 6 meses: memory navigation (sabe onde está cada item sem ler). Se items movem: memory breaks. Anti-pattern: sidebar com 15 items sem grouping — construtora procura 'Compliance' em lista de 15 items que inclui Dashboard, Fornecedores, Operações, Pagamentos, Documentos, Relatórios, Analytics, Risco, Compliance, Configurações, Integrações, API, Help, Profile, Billing — scan impossível."
		dependsOn: ["pd-disclosure-layers"]
		crossDependsOn: [{
			lensId:    "lens-multi-sided-platform-ux"
			conceptId: "mux-cross-side-value-design"
			context:   "MUX define value proposition por side. PD navigation architecture implementa: cada side vê navigation que reflete seu value prop. Fornecedor navega para 'Operações' (core value: dinheiro). Construtora navega para 'Dashboard' e 'Fornecedores' (core value: gestão). FIDC navega para 'Carteira' (core value: retorno). MUX define o quê; PD organiza o como."
		}]
		rationale: "Rosenfeld/Morville 2015: IA. Navigation depth vs breadth 2022+. Role-based navigation 2023+. Navigation as disclosure 2024+. Na Mesh com 3 personas com necessidades radicalmente diferentes, role-based navigation é o que permite que mesma plataforma pareça 3 produtos — cada um otimizado."
	},
	{
		id:         "pd-disclosure-patterns"
		name:       "Patterns de Disclosure: Qual Componente para Qual Tipo de Conteúdo"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Cada tipo de conteúdo oculto requer pattern de disclosure diferente: (1) accordion — conteúdo expandível in-place. Para: FAQ, detalhes de item em lista, seções colapsáveis. Context permanece visível. (2) tabs — conteúdo organizado em categorias exclusivas. Para: views diferentes do mesmo entity (fornecedor: Dados | Operações | Compliance). Switching rápido. (3) modal/dialog — conteúdo que interrompe flow. Para: confirmações, formulários curtos, alertas que requerem ação. Blocking: user must interact antes de continuar. (4) drawer/panel — conteúdo lateral que coexiste com main. Para: detail de item selecionado em lista, filtros, configurações contextuais. Non-blocking: user pode interagir com main enquanto drawer está aberto. (5) expandable row — detalhe de row em tabela que expande inline. Para: detalhes de operação em tabela de FIDC sem navegar para outra página. (6) tooltip/popover — informação contextual efêmera. Para: definição de termo, explicação de métrica, help inline. Conceito contemporâneo de 'pattern selection criteria' (2024+): escolher pattern por: (a) permanência — tooltip para efêmero, tab para persistente. (b) context preservation — accordion/drawer preservam context; modal/page-navigation não. (c) content size — tooltip para 1-2 lines, modal para form, page para dashboard."
		meshManifestation: "Na Mesh, patterns por contexto: (1) detalhes de operação em tabela FIDC — expandable row. Click em row: expande inline com: timeline, score breakdown, documentos. FIDC não perde context da tabela (context preservation). Alternative: drawer lateral com detail enquanto tabela permanece. (2) configuração de policy por construtora — wizard (multi-step) para first-time. Tabs para editing subsequente (Geral | Risco | Documentos | Integrações). (3) explicação de métrica — tooltip/popover. Hover em 'Inadimplência 1.8%': popover com 'SUM(valor_em_aberto > 90d) / SUM(valor_total). Período: últimos 12 meses. Source: semantic layer.' (4) submissão de operação (fornecedor) — full page (não modal). Processo consequente que merece focus total. Steps: dados → simulação → confirmação. (5) filtros de tabela — drawer lateral (desktop) ou bottom sheet (mobile). Non-blocking: tabela visível enquanto configura filtros. (6) alertas de compliance — accordion em dashboard. 'Alertas (3)' expandível: lista de alertas com ação. Colapsável quando resolvidos."
		meshImplication: "Pattern selection guide no design system: (1) decision tree: conteúdo efêmero? → tooltip. Conteúdo de decisão/ação? → modal (se blocking) ou full page (se consequente). Detalhe de item? → expandable row (se tabela) ou drawer (se lista). Categorias do mesmo entity? → tabs. Seções colapsáveis? → accordion. Filtros/config contextuais? → drawer. (2) mobile adaptation: modal → bottom sheet. Drawer lateral → bottom sheet. Expandable row → navigate to detail page (inline expansion é confuso em mobile). Tabs → horizontal scrollable tabs ou accordion. Tooltip → long-press popover. (3) consistency: pattern para mesmo tipo de conteúdo é consistente em toda a plataforma. Detail de operação: sempre expandable row (não modal em 1 lugar e drawer em outro). Explicação de métrica: sempre tooltip (não popover em 1 lugar e inline text em outro). (4) max depth: pattern dentro de pattern é confuso. Accordion dentro de modal: avoid. Tab dentro de tab: avoid. Max 1 level de disclosure pattern per interaction. Se precisa de nested pattern: considerar navigation em vez de disclosure. (5) animations: disclosure patterns com animation sutil (expand 200ms, slide 250ms). Sem animation: disclosure é abrupta. Animation lenta (>400ms): feels sluggish. Sweet spot: 200-300ms ease-out. Anti-pattern: modal para tudo — 'ver detalhes' → modal, 'filtrar' → modal, 'configurar' → modal. Modals empilhados são confusing e mobile-unfriendly."
		dependsOn: ["pd-disclosure-layers", "pd-navigation-architecture"]
		crossDependsOn: [{
			lensId:    "lens-interaction-patterns-for-professional-tools"
			conceptId: "ip-interaction-vocabulary"
			context:   "IP define vocabulário de interação (click, hover, drag, keyboard). PD disclosure patterns são implementados via IP: accordion expande com click, tooltip aparece com hover, drawer abre com click + gesture. IP é o vocabulário; PD é a gramática (qual interação para qual disclosure). IP diz 'hover shows tooltip'; PD diz 'tooltip é o pattern para explicação efêmera de métrica'."
		}]
		rationale: "Pattern selection 2024+. Na Mesh, usar pattern correto para conteúdo correto é o que faz disclosure feel natural — expandable row para detail em tabela (FIDC sente eficiente), modal para confirmação de operação (fornecedor sente seguro), tooltip para métrica (construtora sente informada)."
	},
	{
		id:         "pd-findability-discoverability"
		name:       "Findability e Discoverability: Encontrar o Conhecido vs Descobrir o Desconhecido"
		nature:     "theoretical"
		role:       "property"
		definition: "Morville (2005, Ambient Findability): findability é a capacidade de encontrar informação que se sabe que existe ('onde está minha operação?'). Discoverability é a capacidade de descobrir funcionalidades que não se sabia que existiam ('não sabia que podia exportar relatório'). Ambos são necessários mas usam mecanismos diferentes. Findability: search, breadcrumb, clear labeling, predictable navigation. Discoverability: contextual suggestions, empty states informativos, onboarding tips, feature highlights. Conceito contemporâneo de 'just-in-time discovery' (2023+): revelar funcionalidade no momento em que é relevante, não antes. 'Você pode exportar este relatório como PDF' aparece quando usuário está no relatório, não no onboarding 3 meses antes. Conceito de 'feature discovery curve' (2024+): novos usuários descobrem funcionalidades ao longo do tempo, não de uma vez. Week 1: essential features. Month 1: contextual features. Month 3: power features. Design deve suportar esta curva: não empurrar tudo no dia 1, mas garantir que features são discovered quando necessárias."
		meshManifestation: "Na Mesh, findability vs discoverability: (1) findability — fornecedor procura 'minha operação #1234': search global encontra por ID. Construtora procura 'fornecedor ABC': search global encontra por nome. FIDC procura 'operações com score <60': filter na tabela encontra. Breadcrumb mostra onde está: 'Carteira > Operações > Operação #1234.' (2) discoverability — construtora usa dashboard há 2 meses sem saber que pode configurar alerts de compliance. Just-in-time: quando CND de fornecedor está para expirar: 'Configure alertas automáticos para ser notificado antes de expiração. [Configurar].' Fornecedor que fez 5 operações sem saber que pode ver simulação de taxa antes de submeter: após 5ª operação, tip: 'Sabia que pode simular taxa antes de submeter? [Experimentar].' FIDC que gera relatório manualmente sem saber que pode agendar: 'Agende relatório automático para todo dia 1. [Agendar].'."
		meshImplication: "Findability infra: (1) global search — presente em toda tela. Busca por: entity name, ID, CNPJ, status keyword. Results grouped by type: 'Operações (3) | Fornecedores (2) | Documentos (1).' Keyboard shortcut: Cmd+K (desktop). (2) consistent labeling — mesmo item tem mesmo nome em todo lugar. 'Operação' não é 'transação' em outro lugar. 'Fornecedor' não é 'supplier' em outro. (3) breadcrumb — para navigation >2 levels. Always visible. Clickable. (4) URL structure — URLs legíveis: /operations/1234, /suppliers/abc-engenharia. URL é findable: user pode bookmark, share, ou type directly. Discoverability strategy: (5) just-in-time tips — triggered by behavior, not by calendar. User que repetidamente faz ação X manualmente: tip suggesting automation Y. Max 1 tip per session (não spammar). Dismissible. (6) contextual discovery — 'Mais opções' link/icon em contextos onde funcionalidade avançada existe. Expert que procura: encontra. Novato que não procura: não é distraído. (7) empty state discovery — quando fornecedor não tem operações: 'Nenhuma operação ainda. Submeta sua primeira operação de antecipação e receba em <24h. [Submeter operação].' Call-to-action que é discovery de funcionalidade principal. (8) feature discovery tracking — quais features foram discovered (first use) por cohort. If feature X has <10% discovery in 90 days: discoverability problem — add just-in-time tip or contextual link. Anti-pattern: onboarding tour de 15 steps no dia 1 que mostra todas as features — user remembers 0 because cognitive overload."
		dependsOn: ["pd-navigation-architecture", "pd-disclosure-layers"]
		crossDependsOn: [{
			lensId:    "lens-jobs-to-be-done-and-workflow-design"
			conceptId: "jtbd-onboarding-activation"
			context:   "JTBD defines onboarding com aha moment e TTV. PD findability/discoverability é o mecanismo: onboarding guia para aha moment (findability do core value), e progressive discovery revela features ao longo do tempo (discoverability curve). JTBD diz 'fornecedor precisa chegar ao primeiro dinheiro rápido'; PD diz 'navigation direta para submissão de operação + empty state com CTA + simulador discoverable'."
		}]
		rationale: "Morville 2005: findability. Just-in-time discovery 2023+. Feature discovery curve 2024+. Na Mesh, fornecedor que não encontra como submeter operação: churn. Construtora que não descobre alertas de compliance: valor perdido. Findability previne churn; discoverability maximiza valor."
	},
	{
		id:         "pd-wizard-vs-form-design"
		name:       "Wizard vs Form: Quando Guiar Step-by-Step e Quando Apresentar Tudo de Uma Vez"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Wizard (stepper): tarefa dividida em steps sequenciais. Cada step com subset de campos. Navegação: next/previous. Para: tarefas complexas com muitos campos (>10), onde sequência importa, e onde iniciante precisa de orientação. Form (single page): todos os campos visíveis de uma vez. Para: tarefas simples com poucos campos (<10), onde expert quer velocidade (preencher em qualquer ordem), e onde context entre campos ajuda (ver todos os campos ajuda a decidir). Conceito contemporâneo de 'adaptive forms' (2024+): form que começa como wizard (step-by-step para first-time) e evolui para form (single page para repeat user que conhece). Toggle: 'modo simples' (wizard) vs 'modo rápido' (form). Conceito de 'wizard anti-patterns' (2023+): (a) too many steps — wizard com 10 steps: feels endless. Max: 5-6. (b) no progress indicator — user doesn't know how many steps remain. (c) no ability to jump — expert forced to click 'next' 5 times para chegar ao step 4. (d) data loss on back — user clicks back and loses input. (e) validation only on submit — user preenche 6 steps e descobre erro no step 2."
		meshManifestation: "Na Mesh, wizard vs form: (1) onboarding de fornecedor — wizard (3 steps): step 1: dados básicos (CNPJ, email). Step 2: documentos (upload com validação real-time). Step 3: confirmação + ativação. Fornecedor PME: guiado. Expert: 'modo rápido' com form único. (2) submissão de operação (fornecedor) — form (3-4 campos): comprador, valor, nota fiscal, (prazo se não inferido). Poucos campos, expert quer velocidade, contexto entre campos ajuda (ver valor e taxa juntos). Não wizard — 4 campos não justificam 4 steps. (3) configuração de políticas (construtora) — wizard first-time (3 steps): step 1: tolerância de risco (escolha simples). Step 2: valor máximo (número). Step 3: documentos (checklist). Subsequent editing: tabs (Geral | Risco | Documentos) — construtora que já configurou não precisa de wizard. (4) relatório custom FIDC — wizard (4 steps): step 1: período. Step 2: métricas. Step 3: filtros. Step 4: preview + export. FIDC que cria relatório regularmente: saved presets (1 click para repetir)."
		meshImplication: "Decision framework wizard vs form: (1) wizard quando: campos >10 AND sequência importa AND first-time user needs guidance. (2) form quando: campos <10 OR expert quer velocidade OR contexto entre campos é importante. (3) adaptive: first time = wizard. Repeat = form ou saved preset. (4) wizard best practices: (a) max 5 steps. (b) progress indicator: 'step 2 de 4 — Documentos.' (c) validation per step (não acumular para final). (d) persistent input on back navigation. (e) ability to jump to step for expert (click step indicator). (f) summary before confirm: 'você está submetendo: operação de R$50k com comprador ABC. Taxa: 2.5%. [Confirmar] [Voltar para editar].' (5) form best practices: (a) logical grouping (dados do comprador | dados da operação | opções). (b) clear labels + helper text. (c) real-time validation (não esperar submit). (d) smart defaults preenchidos. (e) tab order lógico. (6) mobile: wizard works well (each step is one screen). Form with >5 fields: consider wizard for mobile even if form for desktop. Anti-pattern: wizard para 3 campos (overkill — user clicks 'next' 3 times para preencher 3 campos que caberiam em 1 tela). Form para 20 campos (overwhelm — user não sabe por onde começar)."
		dependsOn: ["pd-disclosure-layers", "pd-disclosure-patterns"]
		crossDependsOn: [{
			lensId:    "lens-trust-and-credibility-design"
			conceptId: "tc-vulnerability-moments"
			context:   "TC identifies vulnerability moments (submeter operação, enviar dados financeiros). PD wizard/form design projects how disclosure happens during vulnerability: summary before confirm (reducing anxiety), progress indicator (reducing uncertainty), real-time validation (reducing fear of error). TC diz 'anxiety é máxima durante submissão'; PD diz 'wizard com summary step reduz anxiety porque user vê exatamente o que vai acontecer antes de confirmar'."
		}]
		rationale: "Wizard vs form fundamental. Adaptive forms 2024+. Wizard anti-patterns 2023+. Na Mesh, fornecedor onboarding como wizard (3 steps, guidance) e submissão de operação como form (4 campos, speed) é calibrado ao task — wizard onde guidance ajuda, form onde velocidade importa."
	},
	{
		id:         "pd-content-organization-taxonomy"
		name:       "Taxonomia de Conteúdo: Como Categorizar Funcionalidades de Forma que Personas Entendam"
		nature:     "operational"
		role:       "property"
		reviewCadence: "semi-annual"
		definition: "Rosenfeld/Morville (2015): taxonomia é a classificação de conteúdo em categorias significativas para o usuário. User-centered taxonomy: categorias refletem modelo mental do usuário, não estrutura interna do sistema. Conceito de 'card sorting' (Spencer 2009, Card Sorting): técnica de research onde usuários organizam items em categorias — revela modelo mental. Open sort: user cria categorias. Closed sort: user organiza em categorias predefinidas. Conceito contemporâneo de 'task-based taxonomy' (2023+): organizar por tarefa do usuário ('O que preciso fazer?'), não por objeto do sistema ('Que entities existem?'). Fornecedor pensa: 'quero antecipar recebível' (task), não 'quero interagir com entity Operação' (object). Navigation labels: 'Antecipar' > 'Operações.' Conceito de 'domain language alignment' (2024+): labels na interface usam linguagem do domínio do usuário, não jargão técnico. Fornecedor de construção civil: 'medição' (domain term), não 'account receivable' (finance term). Construtora: 'fornecedores' (domain), não 'counterparties' (finance)."
		meshManifestation: "Na Mesh, taxonomia por persona: (1) fornecedor — categorias: 'Minhas Operações' (antecipar, ver status, histórico), 'Meus Documentos' (CNDs, certidões, contrato social), 'Meu Perfil' (dados, configurações). Linguagem: 'antecipar', 'operação', 'documentos', 'taxa.' Não: 'cessão', 'recebível', 'lastro.' (2) construtora — categorias: 'Dashboard' (overview), 'Fornecedores' (qualificação, compliance, performance), 'Operações' (pipeline, histórico), 'Compliance' (alertas, documentação), 'Analytics' (métricas, relatórios), 'Configurações' (políticas, integrações). Linguagem: 'fornecedores', 'qualificação', 'compliance', 'políticas.' Não: 'supply chain', 'vendor management.' (3) FIDC — categorias: 'Carteira' (overview, concentração, safras), 'Operações' (detail, análise), 'Relatórios' (periódicos, custom, export), 'Risco' (métricas, stress test), 'Configurações.' Linguagem: 'carteira', 'inadimplência', 'safra', 'concentração', 'sacado.' Termos financeiros OK (FIDC é expert financeiro)."
		meshImplication: "Taxonomy design: (1) user-centered — labels refletem linguagem do usuário, não da implementação. Se interno chama 'ECL': interface chama 'Operações.' Se interno chama 'NGR': interface chama 'Fornecedores.' Mapping: internal name → user-facing label. Documented in design system glossary. (2) task-based primary — top-level navigation por tarefa ('Antecipar', 'Qualificar'), não por objeto ('Operações', 'Fornecedores'). Exception: quando domínio é object-oriented na mente do usuário (FIDC pensa em 'Carteira' como objeto, não como tarefa). (3) domain language per persona — fornecedor: linguagem simples, sem jargão financeiro. FIDC: linguagem financeira (jargão é vocabulary compartilhado). Construtora: linguagem de gestão (fornecedores, compliance, performance). Same concept, different label per persona if needed. (4) validation — card sorting com 5-10 users per persona: 'organize estes 15 items em grupos.' Se 80% agrupa da mesma forma: taxonomy é aligned. Se 50/50: taxonomy precisa de revisão. (5) evolution — taxonomy muda conforme produto cresce. Review semi-annual: novos features caben nas categorias existentes? Se não: nova categoria ou reorganize. Comunicar mudança: 'reorganizamos a navegação — [o que mudou] [por que].' Anti-pattern: taxonomy que reflete arquitetura de microservices — 'ECL Service' e 'NGR Service' como navigation items. User não sabe e não se importa sobre BCs internos."
		dependsOn: ["pd-navigation-architecture"]
		crossDependsOn: [{
			lensId:    "lens-documentation-as-product"
			conceptId: "dp-single-source-of-truth"
			context:   "DP defines SSOT e glossário. PD taxonomy alignment usa glossário como source of truth para labels: 'inadimplência' na interface é a mesma definição do glossário no mesh-spec e da semantic layer. Se interface chama 'inadimplência' e semantic layer chama 'default_rate_90d': mapping deve existir e ser consistent. DP is the source; PD is the presentation layer that must align."
		}]
		rationale: "Rosenfeld/Morville 2015: taxonomy. Card sorting Spencer 2009. Task-based 2023+. Domain language 2024+. Na Mesh, fornecedor que vê 'Cessão de Recebíveis' não entende. Fornecedor que vê 'Antecipar Pagamento' entende e clica. Labels are the interface."
	},
	{
		id:         "pd-empty-states-onboarding-cues"
		name:       "Empty States e Onboarding Cues: Guiar Quando Ainda Não Há Conteúdo"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Empty state é o que usuário vê quando não há dados (zero operações, zero fornecedores, zero relatórios). Empty state design: (1) explain — o que deveria estar aqui. (2) direct — como chegar lá (call-to-action). (3) educate — o que o usuário ganha quando chegar. Conceito contemporâneo de 'empty state as onboarding' (2023+): empty state é a primeira impressão de cada seção. Se empty state é 'nenhum resultado' genérico: user não sabe o que fazer. Se empty state é informativo + actionable: user é guiado. Conceito de 'onboarding cues vs onboarding tour' (2024+): onboarding tour (walkthrough de 10 steps no dia 1) tem retention baixa (user esquece). Onboarding cues (contextual hints no momento relevante) têm retention alta (user aprende quando precisa). Cues: tooltips, empty states informativos, contextual banners, first-use highlights."
		meshManifestation: "Na Mesh, empty states: (1) fornecedor — sem operações: 'Nenhuma operação ainda. Antecipe seu primeiro recebível e receba dinheiro em <24h. [Submeter operação →]' + ilustração simples mostrando: submissão → aprovação → dinheiro. (2) construtora — dashboard vazio: cada KPI card com placeholder + CTA. 'Fornecedores qualificados: — [Convidar fornecedores →].' 'Operações: — [Ativar antecipação →].' 'Compliance: — [Configurar monitoramento →].' Cada card guia para próximo passo. (3) FIDC — carteira vazia: 'Carteira sem operações. Operações serão listadas aqui quando aprovadas. [Ver pipeline de operações].' (4) construtora — tabela de fornecedores vazia: 'Nenhum fornecedor adicionado. Importe de planilha ou convide por email. [Importar →] [Convidar →].' Onboarding cues: (5) first-use de simulador (fornecedor): tooltip pointing ao botão 'Simular': 'Simule taxa antes de submeter — veja quanto recebe.' Dismiss com X. Não reaparece. (6) first-use de filtro (construtora): subtle highlight no botão de filtro com badge 'Novo': 'Filtre fornecedores por status, compliance, ou performance.' Dismiss on use."
		meshImplication: "Empty state + cue design: (1) every page/section has designed empty state — never 'no results' generic. Each empty state: illustration (optional, light), explanation (1-2 lines), CTA (primary action to fill the empty state). (2) CTA hierarchy: se múltiplas ações possíveis: 1 primary CTA (button) + 1-2 secondary (link). 'Importar fornecedores' (primary) | 'Convidar por email' (secondary) | 'Saber mais' (tertiary link). (3) onboarding cues — max 3 per page, revealed progressively (not all at once). Cue types: tooltip (1 line, ephemeral), banner (persistent until dismissed, top of section), badge 'Novo' (on menu item or button, disappears after first use). (4) cue lifecycle: appear on first relevant visit. Dismiss on use or explicit X. Never reappear. If user dismisses without using: cue is gone — not aggressive. (5) empty state evolution: empty state exists only temporarily. After user creates first item: normal state replaces. Design both states — not just empty or just full. (6) error vs empty: empty (no data yet) ≠ error (data failed to load). Empty: explanatory + CTA. Error: error message + retry. Different treatments. Anti-pattern: empty dashboard with 6 blank cards and no explanation — user doesn't know if it's loading, broken, or empty."
		dependsOn: ["pd-findability-discoverability", "pd-disclosure-layers"]
		crossDependsOn: [{
			lensId:    "lens-cold-start-and-network-bootstrapping"
			conceptId: "cs-single-player-mode"
			context:   "CS defines single-player mode — value before network exists. PD empty states are where single-player mode meets user: construtora arrives at empty dashboard. If empty state guides to dashboard value (gestão de cadeia): single-player mode is activated. If empty state says 'no data': construtora leaves. CS is the strategy; PD is the implementation at the UI level."
		}]
		rationale: "Empty state design 2023+. Onboarding cues vs tour 2024+. Na Mesh, empty state é a primeira experiência de cada seção — e frequentemente o first touch com a plataforma (cold start). Empty state informativo + actionable é o que converte visitante em usuário."
	},
	{
		id:            "pd-disclosure-review"
		name:          "Revisão de Disclosure e IA: Inventário Periódico de Arquitetura de Informação"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável."
		meshManifestation: "Na Mesh: revisão trimestral. Mensal: spot-check de findability (1 task per persona)."
		meshImplication: "Mensal (20min): findability test — pick 1 task per persona. Fornecedor: 'encontre status da operação #1234.' Construtora: 'encontre fornecedor com compliance expirada.' FIDC: 'encontre operações com score <60.' Medir: quantos clicks? Quanto tempo? If >3 clicks or >15 seconds: findability problem. Quarterly (1.5h): disclosure layers — essential layer serves 80%? Contextual discoverable? Power accessible? Navigation — role-based working? Items organized per persona mental model? Search global functional? Patterns — correct pattern for each content type? Consistency across platform? Taxonomy — labels aligned with user language? Card sorting validation needed? Empty states — all sections have designed empty states? CTAs clear? Cues — first-use cues appearing? Dismissing correctly? Feature discovery rate for key features? Wizard/form — first-time vs repeat experience calibrated? Adaptive mode working? If review identifies zero improvements: either IA is perfect (unlikely) or review is superficial."
		dependsOn: ["pd-disclosure-layers", "pd-navigation-architecture", "pd-disclosure-patterns", "pd-findability-discoverability", "pd-wizard-vs-form-design", "pd-content-organization-taxonomy", "pd-empty-states-onboarding-cues"]
		rationale: "IA degrades with feature additions — each new feature needs to fit in navigation, have disclosure pattern, have empty state. Without review: features accumulate without structure."
	},
]

reasoningProtocol: [
	{
		question:  "A funcionalidade tem 3 layers claros (essential, contextual, power)? 80% dos usuários operam no essential sem fricção?"
		reveals:   "Se complexidade é organizada em layers — ou se tudo é apresentado de uma vez."
		rationale: "Nielsen 2006: progressive disclosure. 3-layer B2B 2023+. Se essential layer requer decisão que novato não sabe tomar: missing default."
	},
	{
		question:  "Navigation é role-based? Cada persona vê items relevantes para seu job? Máximo 3 levels de depth?"
		reveals:   "Se navigation é otimizada per persona — ou se one-nav-fits-none."
		rationale: "Role-based navigation 2023+. Na Mesh: fornecedor vê 3-4 items, construtora vê 5-7, FIDC vê 4-5. Sidebar com 15 items: scan impossível."
	},
	{
		question:  "O disclosure pattern correto é usado para cada tipo de conteúdo? Accordion para collapsible, tabs para categories, drawer para detail?"
		reveals:   "Se patterns são consistentes e adequados — ou se modal é usado para tudo."
		rationale: "Pattern selection 2024+. Modal para detail de tabela: context lost. Expandable row: context preserved."
	},
	{
		question:  "Usuário pode encontrar o que sabe que existe (findability) E descobrir o que não sabia (discoverability)?"
		reveals:   "Se ambos mecanismos estão implementados — ou se findability OK mas features avançadas são undiscoverable."
		rationale: "Morville 2005: findability. Just-in-time discovery 2023+. Feature undiscovered = feature that doesn't exist for user."
	},
	{
		question:  "Labels na interface usam linguagem do domínio do usuário? Ou jargão técnico/financeiro que persona não entende?"
		reveals:   "Se taxonomia é user-centered — ou se reflete modelo interno do sistema."
		rationale: "Domain language 2024+. Fornecedor que vê 'Cessão' não entende. 'Antecipar Pagamento' entende."
	},
	{
		question:  "Cada seção tem empty state informativo com CTA? Ou tela vazia genérica?"
		reveals:   "Se empty state guia — ou se user chega em tela vazia e não sabe o que fazer."
		rationale: "Empty state as onboarding 2023+. Empty state é first impression de cada seção. Generic 'no results' is wasted opportunity."
	},
]

meshExamples: [
	{
		id:       "ex-construtora-policy-wizard"
		scenario: "Nova construtora faz login pela primeira vez. Seção 'Configurações' mostra 25 campos de configuração de políticas. Construtora não sabe o que significam a maioria dos campos. Abandona sem configurar."
		analysis: "25 campos sem disclosure = cognitive overload. Construtora não é expert em scoring ou compliance automation — é expert em construção civil. Campos como 'score_threshold', 'concentration_limit', 'aml_check_interval' são incompreensíveis. Resultado: abandono ou configuração errada (mais perigoso)."
		recommendation: "(1) Essential layer (zero-config): defaults seguros aplicados automaticamente. Construtora não precisa configurar nada para começar. 'Configuração padrão aplicada. Seus fornecedores já podem solicitar antecipação.' Link: 'Personalizar configuração ▸.' (2) Contextual layer (wizard): se construtora clica 'Personalizar': wizard de 3 steps em linguagem de negócio. Step 1: 'Qual sua tolerância de risco?' [Conservador | Moderado | Agressivo] — traduz para score threshold (70/60/50). Step 2: 'Qual o valor máximo por operação?' Slider ou input numérico com suggestion baseada no porte da construtora. Step 3: 'Quais documentos seus fornecedores devem ter?' Checklist com defaults pré-marcados (CND federal ✓, CND estadual ✓, contrato social ✓) + opcionais (certidão trabalhista, FGTS). (3) Power layer (tabs): após first-time wizard, 'Configurações' mostra tabs: Geral (nome, contatos) | Risco (score threshold, valor máximo, concentração) | Documentos (checklist detalhado) | Integrações (API, ERP) | Avançado (AML interval, custom rules). Expert acessa campos individuais. Labels com tooltips que explicam cada campo. (4) Resultado: construtora que quer simples: zero-config ou wizard em 2 minutos. Construtora que quer controle: power layer com 25 campos acessíveis via tabs organizadas."
		principlesApplied: ["ax-01", "ax-02", "ax-04"]
		assumptions: [
			"defaults seguros atendem 80% das construtoras — validar com primeiros anchor tenants",
			"wizard de 3 steps cobre customização mais comum — pode precisar de 4 se integrações são comuns",
			"'Conservador/Moderado/Agressivo' mapeia para thresholds razoáveis — calibrar com dados de inadimplência",
			"construtora entende checklist de documentos — pode precisar de explicação do que cada documento é",
		]
		rationale: "3-layer disclosure: zero-config (essential) → wizard (contextual) → tabs (power). Construtora que abandonava com 25 campos: opera com 0 campos (defaults) ou 3 steps (wizard). Expert: 25 campos acessíveis via tabs."
	},
	{
		id:       "ex-fidc-operation-detail-pattern"
		scenario: "Gestor FIDC analisa tabela com 500 operações. Quer ver detalhes de operação suspeita (score 55). Atualmente: click em operação → nova página carrega → analisa → volta para tabela → perde posição de scroll → repete para próxima operação. Workflow: lento e frustrante."
		analysis: "Pattern errado: page navigation para detail. FIDC que analisa múltiplas operações: cada page navigation é context switch (perde posição na tabela). 5 operações suspeitas = 10 navigations + 5 scroll-to-find. Correct pattern: expandable row ou drawer — preserva context."
		recommendation: "(1) Replace page navigation with expandable row: click em row → expande inline abaixo da row com: timeline (events), score breakdown (SHAP top 5), documentos (status), comprador detail (faturamento, histórico), ação (aprovar/rejeitar/escalar). Row expande com 200ms animation. (2) Alternative: drawer lateral. Click em row → drawer abre à direita com detail. Tabela permanece à esquerda (width reduzida). FIDC escaneia tabela à esquerda, vê detail à direita. Close drawer → tabela volta a full width. (3) Keyboard navigation: arrow keys navegam entre rows. Enter expande. Escape colapsa. FIDC expert: mouse-free analysis. (4) Multi-select: FIDC pode selecionar 5 operações suspeitas → batch action (escalar todas para revisão). (5) Keep filter/sort state: quando expandable colapsa: tabela mantém exatamente a mesma posição, sort, e filter. Zero state loss. (6) Test: FIDC analisa 5 operações suspeitas em <2 minutos com expandable row. Vs >5 minutos com page navigation. Speed improvement: 2.5x."
		principlesApplied: ["ax-01", "ax-02"]
		assumptions: [
			"expandable row funciona com 500 rows + virtual scroll — may need optimization",
			"drawer lateral funciona em 1440px+ desktop — may not fit at 1024px",
			"FIDC prefers expandable over drawer — test both and measure preference",
			"keyboard navigation é useful para FIDC — may be unfamiliar for some users",
		]
		rationale: "Context preservation > page navigation for repetitive analysis. Expandable row keeps FIDC in tabela while revealing detail. Drawer is alternative if detail is too large for inline expansion."
	},
	{
		id:       "ex-fornecedor-empty-state"
		scenario: "Fornecedor PME faz signup e vê tela 'Minhas Operações' com: lista vazia e texto 'Nenhum resultado encontrado.' Fornecedor não sabe o que fazer a seguir."
		analysis: "Generic empty state 'nenhum resultado' não informa, não guia, não educa. Fornecedor está no momento mais vulnerável (just signed up, doesn't know platform). Empty state é a primeira experiência de 'Operações' — e comunica 'nada aqui.' Deveria comunicar: 'aqui é onde suas operações aparecerão — e aqui está como criar a primeira.'"
		recommendation: "(1) Redesign empty state: center-aligned, with: (a) illustration simples: fornecedor → submit → dinheiro (3-step visual). (b) headline: 'Nenhuma operação ainda.' (c) explanation: 'Suas operações de antecipação aparecerão aqui. Submeta sua primeira operação e receba dinheiro em <24h.' (d) primary CTA: [Submeter Primeira Operação →] (button, primary color). (e) secondary: 'Como funciona? Veja em 2 minutos.' (link para vídeo ou tutorial). (2) Contextual information: abaixo do CTA: '✓ Seus documentos estão em dia.' ou '⚠ Envie seus documentos antes de submeter operação. [Enviar documentos].' Status que informa se fornecedor está ready. (3) After first operation: empty state é substituído por lista com 1 operação. Empty state nunca mais aparece (unless all operations are completed/archived and list is empty again — different empty state: 'todas as operações concluídas. [Ver histórico] [Nova operação]'). (4) Mobile: same content, stacked vertically. CTA thumb-reachable at bottom."
		principlesApplied: ["ax-01", "ax-02", "ax-04"]
		assumptions: [
			"ilustração adiciona valor e não é chartjunk — keep simple and functional",
			"fornecedor clica CTA — if conversion is low: CTA isn't compelling enough",
			"status de documentos no empty state é implementável — requires checking compliance status",
			"'<24h' como promessa é cumprível — if not: don't promise",
		]
		rationale: "Empty state as onboarding 2023+. Na Mesh, empty state de 'Operações' para fornecedor novo é possivelmente o touchpoint mais importante — é onde fornecedor decide se vai submeter ou abandonar. Investir design proporcional à importância."
	},
	{
		id:       "ex-navigation-role-optimization"
		scenario: "Construtora reclama: 'preciso de 4 clicks para chegar em compliance de fornecedor. Dashboard → Fornecedores → selecionar fornecedor → tab Compliance. É o que mais uso e está mais longe.'"
		analysis: "4 clicks para funcionalidade mais usada: navigation não reflete uso real. Navigation foi organizada por modelo de dados (Dashboard → Entidade → Detalhe → Atributo), não por frequência de uso. Se compliance é o que construtora mais acessa: deveria estar em <2 clicks."
		recommendation: "(1) Analytics de navigation: medir clicks e frequência. Se 60% das visitas de construtora incluem compliance: compliance é top-level, não nested. (2) Reorganize: adicionar 'Compliance' como item top-level no sidebar (ao lado de Dashboard e Fornecedores). Compliance page: lista de fornecedores com compliance status (ok/alerta/crítico), filterable, com ações inline (notificar fornecedor, ver detalhe). 1 click from anywhere. (3) Dashboard shortcut: card 'Compliance' no dashboard com: 'X alertas | Y expirados | Z pendentes. [Ver todos →].' 1 click. (4) Alternative: keep current navigation but add shortcuts. Quick-access bar: '⚡ Compliance (3 alertas) | Operações (2 pendentes).' Always visible. 1 click for most-used. (5) Navigation personalization (power): construtora pode reorder sidebar items. Drag 'Compliance' para posição 2. Personalizable for power users, default order for new users. (6) Rule: funcionalidade usada >3x/semana por >50% da persona: must be ≤2 clicks from any screen. If >2 clicks: promote in navigation."
		principlesApplied: ["ax-01", "ax-02"]
		assumptions: [
			"60% das visitas incluem compliance — measure before redesigning",
			"top-level navigation item doesn't overload sidebar — 5-7 items is ok, 8+ may be too many",
			"construtora aceita navigation change — communicate 'reorganizamos para acesso mais rápido'",
			"sidebar reordering is technically feasible — requires persistence per user",
		]
		rationale: "Navigation should reflect usage, not data model. If compliance is most-used: 1-2 clicks, not 4. Analytics-driven navigation optimization: measure → reorganize → measure again."
	},
]

principleIds: ["ax-01", "ax-02", "ax-04", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-information-density-design"
		relation: "complementsWith"
		context:  "ID defines how much information per screen. PD defines how information is organized across screens and layers. ID is density per view; PD is structure across views. ID says '4 KPI cards at headline level'; PD says 'KPI cards are essential layer, table is contextual, drill-down is power.'"
	},
	{
		lensId:   "lens-jobs-to-be-done-and-workflow-design"
		relation: "complementsWith"
		context:  "JTBD defines progressive disclosure as UX principle and workflows per persona. PD operationalizes: how to implement disclosure layers, which patterns to use, and how navigation supports workflows. JTBD says 'fornecedor needs 3 layers'; PD says 'layer 1 = form with 4 fields, layer 2 = settings drawer, layer 3 = API.'"
	},
	{
		lensId:   "lens-multi-sided-platform-ux"
		relation: "complementsWith"
		context:  "MUX defines experience per side. PD implements role-based navigation and taxonomy per side. MUX says 'each side has different value prop'; PD says 'each side has different sidebar items, different labels, different disclosure patterns.'"
	},
	{
		lensId:   "lens-trust-and-credibility-design"
		relation: "complementsWith"
		context:  "TC identifies vulnerability moments. PD designs disclosure during vulnerability: wizard summary before confirm, progress indicator during multi-step, empty state that guides instead of confusing. TC says 'anxiety during first operation'; PD says 'wizard with preview step reduces anxiety.'"
	},
	{
		lensId:   "lens-cold-start-and-network-bootstrapping"
		relation: "complementsWith"
		context:  "CS defines single-player mode for bootstrap. PD empty states are where single-player mode meets user: empty dashboard with CTAs that activate standalone value. CS is strategy; PD is the UI implementation during cold start."
	},
	{
		lensId:   "lens-interaction-patterns-for-professional-tools"
		relation: "complementsWith"
		context:  "IP defines interaction vocabulary (click, hover, keyboard). PD disclosure patterns are implemented via IP interactions. IP is the interaction primitives; PD is the grammar that composes them into disclosure experiences."
	},
	{
		lensId:   "lens-documentation-as-product"
		relation: "complementsWith"
		context:  "DP defines SSOT and glossary. PD taxonomy uses glossary as source for labels. If interface says 'inadimplência' and glossary says 'default_rate_90d': mapping must exist. DP is source; PD is user-facing presentation."
	},
	{
		lensId:   "lens-design-tokens-and-systematic-composition"
		relation: "complementsWith"
		context:  "DT defines design tokens for spacing, sizing, and component variants. PD uses tokens to implement disclosure: accordion animation duration (token), drawer width (token), wizard step indicator sizing (token). DT is the system; PD is the application."
	},
]

limitations: [
	{
		description: "Role-based navigation assumes clear role boundaries. If user has multiple roles (founder is fornecedor AND construtora AND admin), single-role navigation is insufficient."
		alternative: "Role switcher: user can toggle between roles (fornecedor view, construtora view). Each role has its navigation. Or: unified navigation with all items, organized by domain, not role. For Mesh early-stage: roles are distinct (fornecedor ≠ construtora). For expansion: evaluate."
		rationale: "Distinct roles work for construction civil. Other sectors may have fluid roles."
	},
	{
		description: "Smart defaults require domain knowledge to set correctly. Wrong default (score threshold too low) is worse than no default (user must decide) because user trusts default without questioning."
		alternative: "Calibrate defaults with data and expert input. Document rationale. When default is uncertain: don't set default — require decision but guide with recommendation ('we recommend 60 based on [rationale]. You can change to [range].')"
		rationale: "Default communicates 'this is the right choice.' Wrong default is wrong recommendation with authority."
	},
	{
		description: "Just-in-time discovery cues can feel intrusive if poorly timed or too frequent. User who sees 3 tooltips per page: overwhelmed, not guided."
		alternative: "Max 1 cue per page per session. Cue dismissed = never returns. Rate limit: max 3 new cues per week total. Priority: cues for features that solve immediate pain > cues for nice-to-have features."
		rationale: "Cue fatigue is real. Over-cueing trains user to dismiss all cues, defeating the purpose."
	},
	{
		description: "Card sorting and user research for taxonomy is ideal but expensive and time-consuming. Solo founder may not have resources for formal research."
		alternative: "Lightweight validation: ask 3-5 users to organize navigation items. Informal but informative. Or: analytics-driven — measure which items users click and reorganize based on usage data. Or: follow competitor patterns (how do similar B2B fintechs organize navigation?)."
		rationale: "Some validation > no validation. Analytics-driven taxonomy improvement is continuous and low-cost."
	},
	{
		description: "Empty state design is one-time per section but requires maintenance — CTA targets may change, copy may become stale, illustrations may become inconsistent with evolved design system."
		alternative: "Empty states as components in design system: parameterized (headline, body, CTA, illustration) and maintained alongside other components. When design system evolves: empty states evolve too."
		rationale: "Empty states that look different from rest of app: incoherence. Empty states maintained as design system components: coherence."
	},
]

rationale: "Toda plataforma complexa precisa organizar informação para que cada persona encontre o que precisa sem se perder na complexidade. Na Mesh com fornecedores, construtoras e FIDC, a information architecture governa como centenas de funcionalidades são organizadas, reveladas e navegadas. Esta lens operacionaliza: disclosure em 3 layers com smart defaults (Nielsen 2006, 3-layer B2B 2023+, smart defaults 2024+), navigation architecture role-based com depth management (Rosenfeld/Morville 2015, depth vs breadth 2022+, role-based 2023+, navigation as disclosure 2024+), disclosure patterns com selection criteria por content type (accordion, tabs, modal, drawer, expandable — pattern selection 2024+), findability e discoverability com search global e just-in-time discovery (Morville 2005, just-in-time 2023+, feature discovery curve 2024+), wizard vs form com adaptive experience (wizard anti-patterns 2023+, adaptive forms 2024+), taxonomia user-centered com domain language alignment (Rosenfeld/Morville 2015, Spencer 2009, task-based 2023+, domain language 2024+), e empty states como onboarding com contextual cues (empty state as onboarding 2023+, onboarding cues 2024+). Universal, agnóstica a estágio, aplicável a qualquer plataforma B2B com múltiplas personas e funcionalidades que precisam ser organizadas progressivamente."

}
