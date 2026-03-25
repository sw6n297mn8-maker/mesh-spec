package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

informationDensityDesign: artifact_schemas.#AnalyticalLens & {
id:     "lens-information-density-design"
name:   "Design de Densidade Informacional"

purpose: "Orientar decisões sobre como maximizar informação útil por pixel em interfaces profissionais — densidade sem clutter para power users financeiros."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve quanta informação exibir por unidade de espaço de tela",
		"a decisão envolve trade-offs entre mostrar mais dados (power user quer) e simplificar (novato precisa)",
		"a decisão envolve como projetar dashboards, tabelas ou interfaces data-rich para profissionais B2B",
		"a decisão envolve como maximizar data-ink ratio sem sacrificar legibilidade",
		"a decisão envolve como projetar interfaces que profissionais usam 8h/dia sem fatiga visual",
		"a decisão envolve como determinar o nível correto de detalhe para cada contexto e persona",
		"a decisão envolve como interfaces profissionais (Bloomberg, Figma, Datadog) equilibram densidade e usabilidade",
		"a decisão envolve como adaptar densidade para diferentes devices (desktop data-rich vs mobile summary)",
	]
	keywords: [
		"densidade", "density", "information density",
		"data-ink ratio", "chart junk", "Tufte",
		"dashboard", "painel", "overview", "summary",
		"tabela", "table", "grid", "lista densa",
		"power user", "profissional", "expert interface",
		"scan", "glance", "at-a-glance", "scan pattern",
		"whitespace", "espaço em branco", "padding", "margin",
		"compact", "compacto", "comfortable", "spacious",
		"cognitive load", "carga cognitiva", "overwhelm",
		"data-rich", "information-rich", "dense UI",
		"sparkline", "mini chart", "inline visualization",
		"responsive density", "adaptive", "breakpoint",
	]
	excludeWhen: [
		"a decisão é sobre progressive disclosure e arquitetura de informação — usar progressive-disclosure-and-information-architecture",
		"a decisão é sobre semiótica de visualização de dados — usar data-visualization-semiotics",
		"a decisão é sobre tipografia — usar typographic-systems-for-dense-interfaces",
		"a decisão é sobre cor como linguagem funcional — usar color-as-functional-language",
		"a decisão é sobre design tokens e composição — usar design-tokens-and-systematic-composition",
	]
	rationale: "Toda interface B2B profissional enfrenta o dilema de densidade: usuários profissionais querem ver muita informação de uma vez (gestor FIDC quer carteira, inadimplência, concentração, trend num olhar), mas excesso de informação causa overload cognitivo que impede decisão. Na Mesh com construtoras, fornecedores, gestores FIDC e regulador — cada persona tem necessidade diferente de densidade: fornecedor PME quer scan rápido ('minha operação foi aprovada?'), construtora quer dashboard operacional ('quantos fornecedores qualificados? Pendências?'), FIDC quer data-rich analytics ('carteira por safra com inadimplência por cohort'). Bloomberg Terminal mostra que alta densidade funciona quando bem-projetada. Google Search mostra que simplicidade funciona quando informação é escassa. Mesh precisa de ambos — por persona, por contexto, por device. As lenses irmãs (tipografia, cor, visualização, interaction, design tokens, progressive disclosure) cobrem mecanismos específicos. Esta lens cobre o princípio meta: quanto mostrar, para quem, em que contexto."
}

concepts: [
	{
		id:         "id-density-spectrum"
		name:       "Espectro de Densidade: De Sparse a Ultra-Dense, Cada Nível Serve um Contexto"
		nature:     "theoretical"
		role:       "framework"
		definition: "Tufte (1983, The Visual Display of Quantitative Information): data-ink ratio — maximizar tinta usada para dados, minimizar tinta decorativa. Alta data-ink ratio = alta densidade informacional. Mas: Tufte projetava para papel (consumo linear), não para interfaces interativas (consumo não-linear com hover, click, scroll). Conceito contemporâneo de 'density levels' para interfaces digitais (2022+): (1) sparse — grande whitespace, poucos elementos, foco em 1 ação. Mobile consumer apps (Instagram, Uber). (2) comfortable — whitespace moderado, múltiplos elementos, scan fácil. SaaS B2B padrão (Stripe Dashboard, Notion). (3) compact — whitespace reduzido, muitos elementos, scan rápido para quem conhece layout. Professional tools (Jira, Figma, Slack). (4) dense — whitespace mínimo, máximo de dados por tela, requer familiaridade. Financial terminals (Bloomberg, Refinitiv). (5) ultra-dense — pixel-level optimization, cada célula comunica. Trading desks, control rooms. Few (2023, Designing with Data): interfaces analíticas devem ser projetadas pelo tipo de pergunta que o usuário faz — se pergunta é 'está tudo ok?' (scan): density moderate. Se pergunta é 'qual a distribuição por safra nos últimos 6 meses?' (analysis): density high."
		meshManifestation: "Na Mesh, density level por persona × context: (1) fornecedor — mobile: sparse-comfortable. 'Operação aprovada. R$48.850 em <24h.' Tela com 1 card e 1 CTA. Desktop: comfortable. Lista de operações com status, valor, data. (2) construtora — desktop: compact. Dashboard com fornecedores qualificados (tabela), operações pendentes (lista), compliance alerts (badges), gastos (mini chart). Muita informação mas organizada por zona. (3) FIDC — desktop: dense. Carteira por safra (tabela), inadimplência por cohort (heatmap), concentração por sacado (bar chart), trend de volume (line chart). Gestor quer ver tudo numa tela sem scroll. (4) regulador — desktop: comfortable-compact. Relatório com métricas canônicas, drill-down on-demand. Não ultra-dense (regulador não usa 8h/dia). (5) admin/ops — desktop: compact-dense. Monitoring de operações em tempo real, alertas, filas de processamento. Operador quer scan rápido de status."
		meshImplication: "Definir density level por persona × context: (1) density token no design system — density: 'sparse' | 'comfortable' | 'compact' | 'dense'. Cada density define: padding (24px | 16px | 8px | 4px), font-size (16px | 14px | 13px | 12px), row-height (56px | 44px | 36px | 28px), icon-size (24px | 20px | 16px | 14px). Componente recebe density prop → adapta automaticamente. (2) persona-density mapping — fornecedor mobile: sparse. Fornecedor desktop: comfortable. Construtora: compact. FIDC: dense. Ops: compact-dense. (3) user-selectable density — para power users: toggle density (compact | comfortable) como preference. Construtora que quer ver mais: switch para compact. Que quer respirar: switch para comfortable. Default por persona, customizável por user. (4) context-adaptive density — mesma interface, density varia por seção: dashboard header (sparse — título + KPIs primários), main content (compact — tabelas e charts), sidebar (comfortable — filtros e navegação). Não uma density para tudo: density por zona. (5) mobile como constraint, não como afterthought — mobile força density reduction. Fornecedor mobile: sparse com progressive disclosure (jtbd-progressive-disclosure). Informação detalhada: desktop. Mobile: status + valor + ação. Anti-pattern: dashboard de FIDC com mesma density que landing page de fornecedor — FIDC quer dense, fornecedor quer sparse. 1 density para todos = ninguém satisfeito."
		rationale: "Tufte 1983: data-ink ratio. Few 2023: designing with data. Density levels 2022+. Na Mesh, density não é estilo — é decisão de produto por persona × context. FIDC que vê dashboard sparse precisa de 10 clicks para montar mental model. FIDC que vê dashboard dense: 1 glance."
	},
	{
		id:         "id-scan-patterns"
		name:       "Scan Patterns: Como o Olho Profissional Percorre Interface Densa"
		nature:     "theoretical"
		role:       "property"
		definition: "Nielsen (2006, F-pattern): usuários web escaneiam em F — horizontal top, horizontal mid, vertical left. Para interfaces data-rich: scan pattern é mais complexo. Conceito de 'professional scan patterns' (2022+): profissionais que usam ferramenta diariamente desenvolvem scan pattern especializado — gestor FIDC olha: (1) top-left: KPI principal (lastro total). (2) top-right: KPI de risco (inadimplência). (3) mid: tabela de detalhes. (4) bottom: trends. Pattern é aprendido e estável — mudança de layout quebra pattern e desorienta. Conceito contemporâneo de 'anchor-exception pattern' (Few 2023): profissional escaneia para 2 coisas: (1) anchors — métricas familiares que confirmam normalidade ('lastro R$5M, como esperado'). (2) exceptions — anomalias que requerem atenção ('inadimplência subiu 1.5pp este mês'). Interface densa deve: posicionar anchors em locations previsíveis e highlights exceptions com saliência visual (cor, tamanho, posição)."
		meshManifestation: "Na Mesh, scan patterns por persona: (1) fornecedor — scan vertical de lista: operação mais recente → status → valor. Pattern: 'minha operação foi aprovada? Quanto vou receber? Quando?' 3 data points em <3 segundos. (2) construtora — dashboard scan: top-left (fornecedores qualificados), top-right (pendências/alerts), mid (tabela de operações recentes), bottom (trend de volume). Anchors: números que confirmam normalidade. Exceptions: badges vermelhos, counts acima de zero para pendências. (3) FIDC — analytical scan: top (KPIs: lastro, inadimplência, concentração), mid-left (tabela por safra), mid-right (charts de trend), bottom (detailed breakdown). Anchors: KPIs comparados com target. Exceptions: KPI que viola threshold (inadimplência >3% → destaque)."
		meshImplication: "Projetar para scan pattern da persona: (1) layout estável — uma vez definido, não mudar sem necessidade forte. Profissional que usa dashboard diariamente desenvolveu muscle memory. Mudança de layout = reaprendizagem que custa produtividade por semanas. (2) anchors em posição previsível — KPIs primários: top-left (most salient). Mesmo KPI, mesmo lugar, toda vez. Se lastro é sempre top-left: gestor FIDC não precisa procurar — olha e sabe. (3) exceptions com saliência — anomalia precisa se destacar sem que interface inteira grite. Técnicas: (a) conditional formatting — número que viola threshold muda de cor (neutral → warning → danger). (b) sparkline com trend — número + mini chart mostra direção sem hover. (c) badge count — 'Pendências: 3' com badge vermelho na zona top-right. (d) deviation indicator — '↑ 1.5pp vs mês anterior' ao lado do número. (4) information hierarchy dentro de zona — cada zona tem: primary (número grande, bold), secondary (label, unidade), tertiary (comparação, trend). Eye flow: primary → secondary → tertiary. (5) whitespace como separator — entre zonas: whitespace que separa conceptually. Dentro de zona: compact. Whitespace não é desperdício — é organização. Anti-pattern: dashboard onde todos os números têm mesmo tamanho, mesma cor, mesmo peso — gestor não sabe o que é anchor e o que é exception. Tudo parece igual = nada se destaca."
		dependsOn: ["id-density-spectrum"]
		crossDependsOn: [{
			lensId:    "lens-color-as-functional-language"
			conceptId: "cl-semantic-color"
			context:   "Color defines semantic color system (success/warning/danger/neutral). ID scan patterns uses color as exception indicator: KPI within threshold = neutral. KPI violating = danger. Color is the mechanism; scan pattern is the context of use. Color lens defines the palette; density lens defines when and where color signals exceptions."
		}]
		rationale: "Nielsen 2006: F-pattern. Few 2023: anchor-exception. Professional scan patterns 2022+. Na Mesh, FIDC gestor que escaneia dashboard em 3 segundos e identifica que inadimplência subiu: design funcional. Gestor que precisa de 30 segundos para encontrar inadimplência: design que falha."
	},
	{
		id:         "id-data-tables"
		name:       "Tabelas de Dados: O Componente Mais Denso e Mais Importante"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Tabelas são o componente de maior density em interfaces profissionais — e o mais frequente. Few (2004, Show Me the Numbers): tabelas são melhores que gráficos quando: precisão numérica importa, comparação entre muitos items é necessária, e lookup de valor específico é o goal. Conceito contemporâneo de 'professional data tables' (2023+): tabelas em ferramentas profissionais (Airtable, Figma, Linear, Datadog) evoluíram: (1) fixed headers — scroll de dados sem perder headers. (2) column resizing — user ajusta largura por importância. (3) sorting e filtering inline — sem sair da tabela. (4) row-level actions — actions no hover ou via context menu. (5) inline editing — editar direto na célula. (6) density toggle — compact/comfortable switch. (7) virtual scrolling — render apenas visible rows para performance com 10k+ rows. (8) conditional formatting — células mudam cor por valor. (9) pinned columns — ID e status sempre visíveis no scroll horizontal. Conceito de 'table as interface, not just display' (2024+): tabela não é visualização passiva — é interface de interação onde profissional toma decisões (aprovar, rejeitar, escalar, filtrar, exportar)."
		meshManifestation: "Na Mesh, tabelas core: (1) tabela de operações do fornecedor — colunas: operação_id (link), comprador, valor, taxa, status (badge colorido), data_submissão, data_aprovação. Density: comfortable (fornecedor PME). Sort: por data (mais recente primeiro). Filter: por status (pendente/aprovado/rejeitado). Action: ver detalhes, solicitar revisão. (2) tabela de fornecedores da construtora — colunas: fornecedor (nome + CNPJ), compliance status (badge), qualificação (badge), docs pendentes (count), performance (sparkline ou %). Density: compact (construtora). Sort: por compliance status (pendentes primeiro). Filter: por status, por segmento. Action: ver perfil, notificar, desqualificar. (3) tabela de carteira do FIDC — colunas: operação_id, fornecedor, comprador, valor, score, status, data_vencimento, dias_atraso, safra. Density: dense (FIDC). Sort: por dias_atraso (maior risco primeiro). Filter: por safra, por comprador, por status. Action: drill-down, exportar. Conditional formatting: dias_atraso >30 = warning, >90 = danger."
		meshImplication: "Table design system: (1) table component com density prop — density='comfortable' (row height 44px, font 14px), density='compact' (36px, 13px), density='dense' (28px, 12px). Default por persona. User-selectable. (2) standard features para toda tabela: fixed header, sortable columns (click header), filterable (filter bar above table), virtual scrolling (for >100 rows), responsive (horizontal scroll with pinned columns on narrow screens). (3) conditional formatting system — cells accept formatting rules: value >threshold → warning color. Value >critical_threshold → danger color. Value trend ↑ → success. Value trend ↓ → danger. Rules defined by domain (inadimplência thresholds differ from volume thresholds). (4) action patterns — row hover: action icons appear (view, edit, delete). Row select: batch action bar appears (approve all, export selected). Context menu: right-click for full actions. (5) empty state — table with 0 rows: not blank. Show: explanation + CTA. 'Nenhuma operação pendente. [Submeter operação].' (6) loading state — skeleton loading that matches table density (same row heights, column widths). Not spinner — skeleton is less jarring for data-rich interfaces. (7) pagination vs infinite scroll — for <100 rows: show all (no pagination). For 100-1000: pagination (10/25/50/100 per page). For >1000: virtual scrolling. Professional users prefer: seeing total count + pagination over infinite scroll (need to know 'how many?'). Anti-pattern: tabela com 50 colunas sem horizontal scroll ou pinning — user perde context (ID) ao scrollar para ver coluna 40."
		dependsOn: ["id-density-spectrum", "id-scan-patterns"]
		crossDependsOn: [{
			lensId:    "lens-typographic-systems-for-dense-interfaces"
			conceptId: "ts-size-scale"
			context:   "Typography defines type scale (size steps, weight, line-height). ID data tables consumes: cell font size, header weight, numeric alignment from type system. Typography provides the raw material; density defines how it's applied in table context. Typography says '12px for dense, 13px for compact'; density says 'FIDC table uses dense (12px)'."
		}]
		rationale: "Few 2004: tables for precision. Professional data tables 2023+. Table as interface 2024+. Na Mesh, tabela de operações é a interface mais usada por toda persona — design system de tabelas é investimento que impacta 80% das interações."
	},
	{
		id:         "id-kpi-dashboard-patterns"
		name:       "Patterns de Dashboard e KPIs: Overview que Informa Sem Sobrecarregar"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Few (2006, Information Dashboard Design): dashboard eficaz cabe em 1 tela sem scroll, mostra o estado atual do que importa, e destaca exceções. Conceito de 'KPI card' (2022+): componente que mostra: (1) metric name, (2) current value (large, prominent), (3) comparison (vs target, vs previous period, vs benchmark), (4) trend (sparkline or arrow), (5) status (on-track / at-risk / critical). KPI card é a unidade atômica de dashboard. Conceito contemporâneo de 'dashboard composition patterns' (2023+): (1) KPI row — 3-5 KPI cards em row horizontal (summary). (2) primary + detail — KPI row + tabela ou chart abaixo (drill-down). (3) comparison grid — múltiplas dimensões comparadas (by segment, by period). (4) monitoring wall — múltiplos dashboards simultâneos (control room). Conceito de 'dashboard as conversation' (Few 2023): dashboard responde perguntas em sequência: (1) 'está tudo ok?' (KPIs overview). (2) 'o que mudou?' (exceptions + trends). (3) 'por quê?' (drill-down). (4) 'o que fazer?' (actions). Dashboard que responde as 4 perguntas em 1 tela: eficaz."
		meshManifestation: "Na Mesh, dashboards por persona: (1) fornecedor dashboard — pergunta: 'como estão minhas operações?' KPI row: total antecipado (R$), operações ativas (count), próxima liquidação (date + value). Abaixo: lista de operações (tabela comfortable). 1 tela, sem scroll, responde 'está ok' em 3 segundos. (2) construtora dashboard — pergunta: 'como está minha cadeia?' KPI row: fornecedores qualificados (count + % do total), pendências de compliance (count — exception se >0), volume antecipado (R$ este mês), taxa média (%). Abaixo: tabela de fornecedores (compact) + mini chart de volume mensal. 1 tela. (3) FIDC dashboard — pergunta: 'como está a carteira?' KPI row: lastro total (R$), inadimplência 90d (% — exception se >3%), concentração top 3 (% — exception se >50%), retorno acumulado (%). Abaixo-left: tabela por safra (dense). Abaixo-right: trend charts (inadimplência, volume, concentração). 1 tela, dense, sem scroll."
		meshImplication: "Dashboard design principles: (1) 1 screen, no scroll — professional dashboard cabe na viewport. Se precisa de scroll: tem informação demais ou layout é ineficiente. Exception: relatório detalhado (não é dashboard — é report). (2) KPI row como first thing — top da tela. 3-5 KPIs. Cada KPI card: value + comparison + trend + status. Card width proporcional à importância: primary KPI = wider. (3) exception-first design — default state: tudo ok (neutral colors). Exception state: badge count, color change, trend indicator. Profissional que abre dashboard e vê tudo neutral: '1 second — está ok, próximo task.' Profissional que vê badge vermelho: 'preciso investigar inadimplência.' (4) drill-down from dashboard — click em KPI → drill-down (tabela filtrada, chart detalhado). Dashboard é overview; drill-down é detail. Progressive disclosure aplicada a analytics. (5) personalization — construtora pode pin KPIs que mais importa. FIDC pode rearranjar layout. Default é bom para 80%; personalization serve 20%. (6) real-time vs batch — fornecedor dashboard: quasi real-time (status de operação muda em minutos). FIDC dashboard: batch (métricas atualizadas diariamente ou em frequência da projeção — eda-projections). Indicar freshness: 'atualizado às 14:30' ou 'dados de ontem.' Anti-pattern: dashboard com 15 KPIs + 3 tabelas + 5 charts = information overload. Profissional não sabe onde olhar. Se tudo é importante: nada é importante."
		dependsOn: ["id-density-spectrum", "id-scan-patterns"]
		crossDependsOn: [{
			lensId:    "lens-data-modeling-for-analytical-power"
			conceptId: "dm-semantic-layer"
			context:   "DM semantic layer defines metrics as code (inadimplência, receita, volume). ID KPI dashboards consume metrics from semantic layer. Every KPI card displays metric defined once in semantic layer — consistency across dashboards for all personas. DM provides the metric; ID provides the visual presentation. If FIDC dashboard shows inadimplência 2.8% and construtora dashboard shows 3.1%: inconsistency (not density problem — semantic layer problem)."
		}]
		rationale: "Few 2006: dashboard design. KPI card 2022+. Dashboard composition 2023+. Dashboard as conversation Few 2023. Na Mesh, dashboard que responde 'está tudo ok?' em 3 segundos é dashboard que funciona. Dashboard que requer 30 segundos para encontrar inadimplência: falhou."
	},
	{
		id:         "id-inline-visualizations"
		name:       "Visualizações Inline: Máxima Informação em Mínimo Espaço"
		nature:     "theoretical"
		role:       "method"
		definition: "Tufte (2006, Beautiful Evidence): sparklines — 'word-sized graphics' que comunicam trend em espaço de texto. Sparkline de inadimplência ao lado do número: 2.8% ↗ com mini-chart de 6 meses. Profissional vê valor + direção sem clicar. Conceito contemporâneo de 'micro-visualizations' (2023+): além de sparklines: (1) progress bars — % de conclusão inline. (2) bullet charts — valor atual vs target em espaço compact. (3) heatmap cells — cor da célula comunica magnitude. (4) deviation bars — bar que mostra quão longe do target (positive/negative). (5) status indicators — dots/badges com semantic color. Conceito de 'glanceable data' (2024+): informação que comunica em <1 segundo sem interação. Micro-visualizations são glanceable por design — diferente de charts que requerem eixos, legendas, e análise."
		meshManifestation: "Na Mesh, inline visualizations: (1) sparkline de volume mensal — ao lado de 'Volume: R$1.2M' na construtora dashboard. 6 meses de trend. Glanceable: crescendo ou caindo? (2) progress bar de compliance — na tabela de fornecedores: '4/5 docs' com progress bar. Glanceable: quase completo ou apenas começou? (3) heatmap de inadimplência por safra — na tabela do FIDC: cada célula de inadimplência com cor proporcional ao valor. Glanceable: safra com problema = célula vermelha sem ler número. (4) status dot — na lista de operações do fornecedor: ● verde (aprovada), ● amarelo (pendente), ● vermelho (rejeitada). Glanceable: status sem ler text. (5) deviation bar — KPI card de inadimplência: barra que mostra distância do target. Verde se abaixo, vermelho se acima. Glanceable: estamos no target? (6) score indicator — ao lado de 'Score: 75': bar preenchida até 75% com cor (verde >70, amarelo 50-70, vermelho <50). Glanceable: score é bom?"
		meshImplication: "Micro-viz library no design system: (1) sparkline component — props: data (array of values), width (default 80px), height (default 20px), color (auto based on trend: positive = success, negative = danger). Use: inline em tabelas, KPI cards, listas. (2) progress bar component — props: current, total, color (auto based on completion %). Use: compliance docs, onboarding steps, qualification progress. (3) status dot — props: status (success | warning | danger | neutral | info), size (sm | md). Use: operation status, compliance status, system health. (4) heatmap cell — props: value, min, max, colorScale (sequential from neutral to danger). Use: inadimplência por safra, score por segmento, concentração por comprador. (5) deviation bar — props: value, target, tolerance. Use: KPI comparison with target. (6) rule: micro-viz é supplement, não substitute para número. Sempre mostrar valor numérico + micro-viz. Número para precision; viz para pattern. Sparkline sem número: direction sem magnitude. Número sem sparkline: magnitude sem direction. Ambos: complete picture. (7) accessibility — micro-viz deve ter aria-label descritivo: 'trend de volume: crescendo 15% nos últimos 6 meses.' Color não pode ser único sinal: combinar com shape (↑↓), position (acima/abaixo de baseline), e text (label de status). Anti-pattern: tabela onde toda célula tem micro-viz mas nenhum número — design que parece bonito mas impede precision."
		dependsOn: ["id-density-spectrum", "id-scan-patterns"]
		crossDependsOn: [{
			lensId:    "lens-data-visualization-semiotics"
			conceptId: "dvs-encoding-principles"
			context:   "DVS defines visual encoding principles (position, size, color, shape for data). ID inline visualizations applies encoding at micro scale — sparkline uses position (line), heatmap uses color (saturation), progress bar uses length. DVS is the grammar; ID applies for micro-visualizations that are glanceable. DVS defines which encoding is effective for which data type; ID applies in dense, inline contexts."
		}]
		rationale: "Tufte 2006: sparklines. Micro-visualizations 2023+. Glanceable data 2024+. Na Mesh, sparkline de inadimplência ao lado do número permite que FIDC gestor veja valor + trend em <1 segundo. Chart separado em outra página: 2 clicks e 10 segundos. Inline viz é 10x mais eficiente para professional workflow."
	},
	{
		id:         "id-responsive-density"
		name:       "Densidade Responsiva: Adaptar Informação ao Device e Viewport"
		nature:     "operational"
		role:       "property"
		reviewCadence: "semi-annual"
		definition: "Concepto de 'responsive density' (2023+): não apenas layout responsivo (reorganizar elementos) mas density responsivo (mudar quanta informação por viewport). Desktop (1920px): dense dashboard com 5 KPIs + tabela + 2 charts. Tablet (1024px): compact dashboard com 3 KPIs + tabela simplificada. Mobile (375px): sparse lista com 1 KPI + status list. Conceito de 'content priority by viewport' (2024+): em viewport menor, priorizar: (1) actionable info (o que o usuário precisa fazer), (2) exceptions (o que precisa de atenção), (3) summary (overview). Detalhe analítico: desktop only ou on-demand."
		meshManifestation: "Na Mesh, density por viewport: (1) fornecedor mobile (375px) — sparse: status da operação mais recente (1 card: status + valor + ETA). Lista de operações (id + status + valor). Action: submeter nova operação. Sem charts, sem analytics. (2) fornecedor desktop (1440px) — comfortable: lista de operações (tabela com mais colunas), simulador de antecipação, histórico. (3) construtora tablet (1024px) — compact: KPIs (2 row), tabela de fornecedores (colunas essenciais). Charts: hidden, accessible via tab. (4) construtora desktop (1920px) — compact: KPIs (5), tabela completa, charts inline. Tudo em 1 tela. (5) FIDC desktop (1920px) — dense: todos os KPIs, tabelas, charts. FIDC não usa mobile para análise de carteira — desktop only com nota 'para melhor experiência, use desktop.'"
		meshImplication: "Responsive density system: (1) breakpoints com density mapping — <640px (mobile): sparse. 640-1024px (tablet): comfortable. 1024-1440px (desktop): compact. >1440px (wide): dense. Cada breakpoint define: columns, font sizes, padding, visible components. (2) content priority list por persona — para cada persona: ordered list de content blocks. Mobile mostra top N; desktop mostra all. Fornecedor mobile: [status_card, operations_list]. Fornecedor desktop: [status_card, operations_table, simulator, history]. (3) hide vs simplify — em mobile: não esconder tabela inteira (fornecedor precisa ver operações). Simplificar: tabela com 3 colunas (id, status, valor) em vez de 8. Charts: hide on mobile, link to 'ver analytics no desktop.' (4) touch targets — mobile density considera touch: min 44px × 44px per interactive element. Dense (28px row height) é impossível para touch. Mobile: comfortable minimum. (5) progressive enhancement — base experience em mobile (funcional, minimal). Desktop adds: more columns, charts, analytics, batch actions. Mobile é not desktop shrunk — é experience redesigned. Anti-pattern: dashboard desktop shrunk para mobile com horizontal scroll e 4px font — unusable. Mobile requer redesign, não resize."
		dependsOn: ["id-density-spectrum"]
		crossDependsOn: [{
			lensId:    "lens-design-tokens-and-systematic-composition"
			conceptId: "dt-spacing-scale"
			context:   "Design tokens defines spacing scale (4px, 8px, 12px, 16px, 24px, 32px). ID responsive density uses spacing tokens per breakpoint: mobile padding 16px, desktop compact 8px, desktop dense 4px. Tokens are the raw values; density system maps tokens to breakpoints. Change spacing token once → all density levels update consistently."
		}]
		rationale: "Responsive density 2023+. Content priority by viewport 2024+. Na Mesh, fornecedor que verifica operação no celular às 22h precisa de sparse experience que funciona em 375px. FIDC gestor que analisa carteira às 9h no desktop 1920px precisa de dense experience. Mesmo plataforma, experiences radicalmente diferentes."
	},
	{
		id:         "id-cognitive-load-management"
		name:       "Gestão de Carga Cognitiva: Densidade Alta que Não Sobrecarrega"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Miller (1956, 'The Magical Number Seven'): working memory holds 7±2 chunks. Interface que exige processamento de >7 elementos simultâneos: overload. Sweller (1988, Cognitive Load Theory): 3 tipos: (1) intrinsic — complexidade inerente da tarefa ('inadimplência por safra' é inerentemente complexo). (2) extraneous — complexidade adicionada por design ruim (layout confuso, labels ambíguos). (3) germane — esforço cognitivo que constrói entendimento (patterns, relationships). Design deve: minimizar extraneous, respeitar intrinsic, maximizar germane. Conceito contemporâneo de 'chunking for dense interfaces' (2023+): agrupar informação em chunks significativos reduz load — 15 KPIs dispersos = overload. 3 grupos de 5 KPIs (financeiro, operacional, risco) = manageable. Grupos proveem structure que reduz extraneous load. Conceito de 'progressive cognitive engagement' (2024+): interface densa não sobrecarrega se: (1) overview é glanceable (3 seconds). (2) detail é available on demand. (3) relationships between elements are visual (proximity, color, alignment)."
		meshManifestation: "Na Mesh, cognitive load management: (1) chunking de KPIs — dashboard FIDC não tem 12 KPIs em row. Tem: grupo 'Carteira' (lastro, volume, operações) + grupo 'Risco' (inadimplência, concentração, score médio) + grupo 'Retorno' (retorno acumulado, yield). 3 chunks × 3-4 KPIs. (2) visual grouping — tabela de fornecedores com: zona de identificação (nome, CNPJ), zona de compliance (docs, status), zona de performance (métricas). Zonas separadas por subtle dividers ou background. (3) progressive engagement — dashboard: overview glanceable em 3s (KPIs com exceptions highlighted). Detail: click em KPI ou zona → drill-down. Profissional que quer overview: 3 seconds. Que quer detail: 1 click. (4) consistent patterns — todo KPI card segue mesmo layout (value, comparison, trend, status). Todo table segue mesmo pattern (header, sort, filter, actions). Consistency reduz extraneous load — profissional aprende pattern 1 vez, aplica em toda a interface."
		meshImplication: "Cognitive load reduction techniques: (1) group by meaning — nunca lista flat de >7 items sem grouping. Dashboard: groups by domain. Table: sections by category if applicable. Sidebar: grouped navigation. (2) visual hierarchy — every screen has: 1 primary focal point (most important info), 2-3 secondary (supporting), and rest is tertiary (available but not prominent). Hierarchy via: size (larger = more important), weight (bolder = more important), position (top-left = first scanned), color (accent = attention). (3) whitespace as cognitive relief — between groups: generous whitespace. Within groups: tight. Whitespace communicates 'these are different topics.' Tight spacing communicates 'these are related.' (4) reduce extraneous — remove decorative elements, unnecessary borders, redundant labels, non-functional icons. Every pixel should communicate. If it doesn't: remove. (5) loading as opportunity — when data loads: show skeleton that matches final layout. Brain starts processing layout before data arrives — reduces perceived cognitive load when data appears. (6) max items per view — KPIs per group: 3-5. Table columns visible without scroll: 5-8. Charts per dashboard: 2-4. If exceeding: reconsider what's truly essential vs nice-to-have. Anti-pattern: dashboard that looks like cockpit of 747 — impressive but overwhelming. Professional tools that succeed (Figma, Linear, Stripe) are dense but not overwhelming because of masterful chunking and hierarchy."
		dependsOn: ["id-density-spectrum", "id-scan-patterns"]
		crossDependsOn: [{
			lensId:    "lens-jobs-to-be-done-and-workflow-design"
			conceptId: "jtbd-progressive-disclosure"
			context:   "JTBD defines progressive disclosure — show complexity gradually. ID cognitive load applies: dense interface works when overview is glanceable (layer 1) and detail is progressive (layer 2+). JTBD provides the principle (layers of disclosure); ID provides the implementation for dense data interfaces (KPI overview → drill-down → raw data)."
		}]
		rationale: "Miller 1956: 7±2. Sweller 1988: cognitive load theory. Chunking 2023+. Progressive cognitive engagement 2024+. Na Mesh, dashboard FIDC com 12 KPIs em flat list: overload. 3 groups × 4 KPIs com visual separation: manageable. Density alta funciona quando cognitive load é gerenciado."
	},
	{
		id:            "id-density-review"
		name:          "Revisão de Densidade: Inventário Periódico de Eficácia Visual"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) density levels — cada persona tem density adequada? Feedback de que é dense demais ou sparse demais? (2) scan patterns — layout estável? Profissionais encontram info rapidamente? Exceptions highlighted? (3) tables — performance ok com volume real? Conditional formatting útil? Columns adequadas? (4) dashboards — cabe em 1 tela? KPIs respondem 'está ok?' em 3 seconds? (5) inline viz — sparklines e micro-viz adicionando valor? Ou decorativos? (6) responsive — mobile funcional? Desktop maximiza viewport? (7) cognitive load — users reportam overwhelm? Chunking eficaz?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: user feedback on density. Trimestral: usability review per persona."
		meshImplication: "Mensal (20min): user feedback — fornecedor reclama de informação demais ou de menos? Construtora consegue gerenciar cadeia no dashboard? FIDC encontra métricas rapidamente? Support tickets sobre 'não encontro X' ou 'interface confusa': indica density/layout problem. Quarterly (1.5h): usability test per persona — observar (ou inferir de analytics): 3 seconds test: open dashboard, can user identify 'is everything ok?' in 3 seconds? Exception detection: anomaly was introduced — did user notice? Table usability: sort, filter, find specific item — how long? Mobile: complete core task on mobile — possible? How long? Comparison: dashboard at 3 months old vs current — did changes improve or degrade? If no feedback: either perfect (rare) or users adapted to imperfection (common). Actively seek feedback."
		dependsOn: ["id-density-spectrum", "id-scan-patterns", "id-data-tables", "id-kpi-dashboard-patterns", "id-inline-visualizations", "id-responsive-density", "id-cognitive-load-management"]
		rationale: "Density choices are hypotheses — validated by whether professionals can work efficiently. Quarterly review with user feedback ensures density serves users, not designer's aesthetic."
	},
]

reasoningProtocol: [
	{
		question:  "Qual density level é adequada para esta persona neste context? Sparse, comfortable, compact, ou dense?"
		reveals:   "Se density é escolhida intencionalmente — ou se é o default do framework CSS sem consideração de persona."
		rationale: "Density levels 2022+. Na Mesh: fornecedor mobile = sparse. FIDC desktop = dense. Default para todos = ninguém satisfeito."
	},
	{
		question:  "O profissional consegue responder 'está tudo ok?' em 3 segundos olhando o dashboard?"
		reveals:   "Se overview funciona — ou se profissional precisa de 30 seconds para encontrar informação que deveria ser glanceable."
		rationale: "Few 2006: dashboard design. 3-second test é o benchmark de eficácia de dashboard."
	},
	{
		question:  "Exceptions (anomalias, desvios) se destacam visualmente? Ou tudo parece igual?"
		reveals:   "Se anchor-exception pattern funciona — ou se profissional precisa analisar número por número para encontrar problema."
		rationale: "Few 2023: anchor-exception. Exception que não se destaca em interface densa: exception invisible."
	},
	{
		question:  "Tabelas têm density adequada, sorting, filtering, conditional formatting, e virtual scroll?"
		reveals:   "Se a interface mais usada (tabela) é profissional — ou se é HTML table sem funcionalidade."
		rationale: "Professional data tables 2023+. Tabela é 80% da interação em B2B tool."
	},
	{
		question:  "Micro-visualizações (sparklines, progress bars, status dots) complementam números? Ou são decoração?"
		reveals:   "Se inline viz adiciona informação (trend, completion, status) — ou se é visual noise."
		rationale: "Tufte 2006: sparklines add information. Viz que não informa é chart junk."
	},
	{
		question:  "Mobile experience é redesigned (não resized)? Fornecedor consegue completar core task no celular?"
		reveals:   "Se mobile é experiência planejada — ou se é desktop shrunk com 4px font."
		rationale: "Responsive density 2023+. Desktop shrunk para mobile: unusable."
	},
]

meshExamples: [
	{
		id:       "ex-fidc-dashboard-density"
		scenario: "Gestor FIDC reclama: 'preciso abrir 4 páginas para entender saúde da carteira. Quero ver tudo num olhar.'"
		analysis: "FIDC experience atual: KPIs em página 1, tabela de operações em página 2, charts em página 3, detalhamento de safra em página 4. Informação existe mas é distribuída — gestor precisa de mental model assembly across 4 pages. Professional expectation: Bloomberg-style — tudo em 1 tela, dense, scannable."
		recommendation: "(1) Single-screen dashboard: viewport 1920×1080. Layout: top row (120px): 5 KPI cards — lastro total, inadimplência 90d (com sparkline 6m), concentração top 3, retorno acumulado, volume este mês. Each card: value (24px bold) + comparison ('vs target: ↓0.3pp') + sparkline (60px wide). Mid-left (500px × 500px): tabela de carteira por safra — safra, volume, inadimplência, default count. Density: dense (28px rows). Conditional formatting: inadimplência cells colored by severity. Mid-right (500px × 500px): 2 charts stacked — inadimplência trend (line, 12 months) + concentração by comprador (horizontal bar, top 10). Bottom (100px): action bar — export, filter by period, refresh. (2) Total information on screen: 5 KPIs + 1 table (8 safras × 4 columns) + 2 charts + 5 sparklines. Dense but organized: 3 zones (KPIs, detail, trends) with clear visual separation. (3) 3-second test: gestor opens dashboard → scans KPI row (2 seconds) → sees inadimplência within target (green) + concentração above target (yellow badge) → knows: 'carteira ok except concentration risk.' 3 seconds. (4) Drill-down: click inadimplência KPI → filter table by safras with inadimplência >threshold. Click comprador in concentration bar → detail of operations with that comprador. Progressive: overview → exception → detail."
		principlesApplied: ["ax-01", "ax-02", "dp-01"]
		assumptions: [
			"1920×1080 viewport is standard for FIDC gestor — verify",
			"5 KPIs are the essential ones — may need 6-7 based on FIDC requirements",
			"dense (28px rows) is readable for FIDC audience — test with actual users",
			"2 charts + 1 table fit in 1 screen — depends on chart complexity and table row count",
		]
		rationale: "Few 2006: 1 screen dashboard. Dense for professional. Na Mesh, FIDC gestor que vê tudo em 1 tela: decisions faster. 4 pages: decisions delayed, context lost between pages."
	},
	{
		id:       "ex-fornecedor-mobile-sparse"
		scenario: "Fornecedor PME verifica status de operação no celular (iPhone SE, 375px width). Current interface: desktop dashboard shrunk — 4px font, horizontal scroll, tappable areas 20px."
		analysis: "Desktop shrunk: unusable on mobile. 4px font: unreadable. 20px tap target: un-tappable. Horizontal scroll on table: fornecedor loses context. Fornecedor mobile job: 'minha operação foi aprovada? Quando recebo?' 2 data points. Desktop dashboard shows 50+ data points. Mobile needs 2."
		recommendation: "(1) Mobile-first design for fornecedor: 375px viewport. Top: greeting + notification badge ('1 operação aprovada'). Card: operation most recent — status (approved ✓ large green badge), value (R$48.850 — 20px), ETA ('depósito amanhã 14h' — 16px). Below card: action button ('Submeter nova operação' — 48px height, full width). Below action: list of previous operations (id, status badge, value — 3 columns max). (2) Information density: sparse. 1 primary card + 1 CTA + 1 simple list. Font minimum: 14px. Tap target minimum: 44px. Whitespace: generous (16px padding). (3) What's NOT on mobile: charts, analytics, detailed table with 8 columns, comparison with previous period, sparklines. All of this: desktop (with link 'ver detalhes no computador'). (4) Progressive: tap on operation card → detail view (full timeline: submitted → validated → scored → approved → settling → deposited). Still mobile-friendly (vertical list of steps with checkmarks). (5) Notifications: push notification when status changes. Fornecedor doesn't need to open app to check — notification says 'Operação #1234 aprovada. Depósito amanhã.'"
		principlesApplied: ["ax-01", "ax-02", "ax-04"]
		assumptions: [
			"iPhone SE (375px) is smallest target — verify most common device for fornecedor PME",
			"fornecedor checks status on mobile — may also submit on mobile (different flow)",
			"push notification reduces need to open app — depends on notification settings",
			"'ver detalhes no computador' is acceptable — fornecedor may not have easy computer access",
		]
		rationale: "Responsive density 2023+. Content priority 2024+. Na Mesh, fornecedor PME que verifica status às 22h no celular: precisa de 1 card com status + valor + ETA. Não precisa de dashboard com 50 data points."
	},
	{
		id:       "ex-table-conditional-formatting"
		scenario: "Tabela de carteira do FIDC tem 200 operações. Gestor precisa identificar operações com risco: atraso >30 dias, score <60, concentração alta. Currently: all rows look the same — white background, black text."
		analysis: "200 rows × 8 columns = 1600 cells. Gestor scanning for exceptions: must read each cell of dias_atraso column to find >30. Must mentally cross-reference with score column. Must aggregate by comprador for concentration. Without conditional formatting: 10+ minutes of manual scanning. With: 3 seconds (red cells jump out)."
		recommendation: "(1) Conditional formatting rules: (a) dias_atraso column: 0-29 = neutral (no highlight). 30-59 = warning (amber background, dark text). 60-89 = danger-light (orange). ≥90 = danger (red background, white text). (b) score column: ≥70 = neutral. 50-69 = warning (amber). <50 = danger (red). (c) row-level: if any cell in row is danger: subtle left border in danger color (red left border — row stands out without coloring entire row). (2) Sort default: dias_atraso descending. Most risky operations at top. Gestor scans from top: first 10 rows are the ones that need attention. (3) Filter presets: [Todos] [Em atraso] [Alto risco] [Concentração]. 'Em atraso' = dias_atraso >30. 'Alto risco' = score <60 OR dias_atraso >60. One-click filter. (4) Summary row: at bottom or top of table: 'Total: 200 operações. Em atraso: 12 (6%). Alto risco: 5 (2.5%).' Summary provides context without scrolling. (5) Heatmap view (toggle): switch from table to heatmap — operações as cells colored by risk. Glanceable: where is risk concentrated? Which safra? Which comprador? (6) Accessibility: conditional formatting uses color + icon. Danger cell: red + ⚠ icon. Warning: amber + ● icon. Not color-only (color blind users)."
		principlesApplied: ["ax-01", "ax-02"]
		assumptions: [
			"200 operations fit in dense table with virtual scroll — verify performance",
			"dias_atraso thresholds (30/60/90) are standard for FIDC — confirm with gestor",
			"color + icon is sufficient for accessibility — test with color blind mode",
			"summary row is useful — may clutter if table has many filter states",
		]
		rationale: "Conditional formatting transforms table from passive display to active exception detector. 200 rows with formatting: 3 seconds to find risk. Without: 10+ minutes. For FIDC gestor reviewing daily: difference between proactive and reactive risk management."
	},
	{
		id:       "ex-density-toggle-construtora"
		scenario: "Construtora with 5 fornecedores finds compact density comfortable. Construtora with 80 fornecedores requests: 'can I see more rows without scrolling? Current spacing wastes screen.'"
		analysis: "Same interface, different needs based on data volume. 5 fornecedores: compact (36px rows) shows all without scroll — comfortable. 80 fornecedores: compact shows ~20 without scroll — must scroll to see 60 more. Dense (28px rows) shows ~30 — still scrolling but less. Ultra-dense may be too small. Solution: user-selectable density, not one-size-fits-all."
		recommendation: "(1) Density toggle in table toolbar: [Comfortable] [Compact] [Dense]. Icons: ☰ with different spacing. Default: compact (appropriate for most construtoras). (2) Comfortable (row 44px, font 14px): for construtoras with <20 fornecedores. Spacious, easy to read. (3) Compact (row 36px, font 13px): for construtoras with 20-50 fornecedores. Good balance. Default. (4) Dense (row 28px, font 12px): for construtoras with >50 fornecedores. Maximum rows visible. Requires familiarity with interface. (5) Persist preference: construtora that selects 'dense' keeps it across sessions. Stored as user preference. (6) Auto-suggest: when fornecedor count >30 and density is comfortable: subtle suggestion 'Dica: mude para visão compacta para ver mais fornecedores.' One-time, dismissible. (7) Design system: density toggle is standard component available in all tables across the platform. Same toggle for operations table (fornecedor), portfolio table (FIDC), etc. Consistent interaction."
		principlesApplied: ["ax-01", "ax-04"]
		assumptions: [
			"users understand density toggle — may need tooltip explanation",
			"dense (28px) is readable for all users — may be difficult for users with vision issues",
			"preference persists across sessions — requires user preference storage",
			"same density toggle for all tables is consistent — some tables may need different defaults",
		]
		rationale: "User-selectable density 2023+. Na Mesh, construtora with 5 fornecedores and construtora with 80 have different density needs. Toggle lets each optimize without designer making universal compromise."
	},
]

principleIds: ["ax-01", "ax-02", "ax-04", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-progressive-disclosure-and-information-architecture"
		relation: "complementsWith"
		context:  "Progressive disclosure defines layers of information revealed on demand. ID density defines how much information per layer. Both are needed: density determines how much the overview layer shows; progressive disclosure determines how to access detail layers. ID is 'how much per screen'; PD is 'how to navigate between screens/layers'."
	},
	{
		lensId:   "lens-data-visualization-semiotics"
		relation: "complementsWith"
		context:  "DVS defines visual encoding grammar (position, color, size, shape for data). ID applies encoding at micro scale (sparklines, heatmap cells, status dots). DVS is the grammar; ID is the vocabulary for inline, glanceable visualizations."
	},
	{
		lensId:   "lens-typographic-systems-for-dense-interfaces"
		relation: "complementsWith"
		context:  "Typography defines type scale, weight, and hierarchy. ID consumes typography: dense tables use 12px, compact use 13px, comfortable use 14px. Typography provides the system; density defines which level each persona and context uses."
	},
	{
		lensId:   "lens-color-as-functional-language"
		relation: "complementsWith"
		context:  "Color defines semantic color system (success, warning, danger, neutral). ID uses color for exception highlighting in dense interfaces: KPI exceeding threshold changes from neutral to danger. Color is the signal; density is the context where signal must be visible."
	},
	{
		lensId:   "lens-design-tokens-and-systematic-composition"
		relation: "complementsWith"
		context:  "Design tokens defines spacing, size, and color scales as tokens. ID density levels map to token values: dense = spacing-1 (4px), compact = spacing-2 (8px), comfortable = spacing-3 (16px). Tokens are the values; density system is the mapping."
	},
	{
		lensId:   "lens-interaction-patterns-for-professional-tools"
		relation: "complementsWith"
		context:  "Interaction patterns defines how users interact with professional interfaces (keyboard shortcuts, batch actions, drag-drop). ID defines what's visible; interaction defines how users act on it. Dense table is useless without sorting, filtering, and row actions."
	},
	{
		lensId:   "lens-jobs-to-be-done-and-workflow-design"
		relation: "complementsWith"
		context:  "JTBD defines jobs and workflows per persona. ID implements density per persona based on job: fornecedor (quick scan → sparse), construtora (operational management → compact), FIDC (analytical deep-dive → dense). JTBD defines what persona needs; ID defines how densely to present it."
	},
	{
		lensId:   "lens-data-modeling-for-analytical-power"
		relation: "complementsWith"
		context:  "DM semantic layer defines metrics consistently. ID dashboards consume metrics from semantic layer for KPI cards. DM provides consistent numbers; ID provides consistent visual presentation. Both needed: wrong number beautifully presented and correct number poorly presented are both failures."
	},
]

limitations: [
	{
		description: "Density levels (sparse/comfortable/compact/dense) are simplification — real interfaces need per-component density, not per-page. Dashboard may have sparse header + compact table + dense chart area."
		alternative: "Use density as zone property, not page property. Each zone of the layout has its own density. Design system supports density per component, not just per page."
		rationale: "Per-page density is too coarse. Per-zone density matches how professionals actually scan: different zones serve different purposes."
	},
	{
		description: "Dense interfaces designed for experts are hostile to newcomers. New construtora user facing dense dashboard: overwhelmed. But reducing density for onboarding means expert user later needs to switch."
		alternative: "Default to comfortable for new users. After N sessions (or explicit preference): suggest compact/dense. Or: onboarding mode that highlights key areas with tooltips, then fades into regular density. Progressive familiarity."
		rationale: "Expert interface that alienates novice never becomes expert interface (user churned). Graduated density respects learning curve."
	},
	{
		description: "Responsive density across breakpoints requires maintaining multiple layouts — mobile sparse + tablet comfortable + desktop compact + wide dense = 4 layouts per interface. Maintenance cost is high."
		alternative: "Prioritize 2 breakpoints: mobile (sparse, essential actions) and desktop (compact-dense, full experience). Tablet inherits from desktop with minor adjustments. Wide is desktop with more space. 2 primary layouts, not 4."
		rationale: "4 fully designed breakpoints for every interface is unsustainable for solo founder. 2 primary (mobile + desktop) covers >90% of usage."
	},
	{
		description: "Micro-visualizations (sparklines, heatmap cells) require data pipeline that computes trends and aggregations. Sparkline needs 6 months of historical data points per metric. If data pipeline doesn't support: sparkline shows partial or stale data."
		alternative: "Implement micro-viz only for metrics where historical data is available and fresh. For metrics without history: show number only. Add sparkline when data pipeline matures. Better: number without sparkline > sparkline with stale data."
		rationale: "Sparkline with 2 data points or stale data is worse than no sparkline — suggests trend that may not be real."
	},
	{
		description: "User-selectable density assumes user knows what they want. Many users won't discover toggle or won't know which density suits them."
		alternative: "Smart default: set density based on data volume (>50 items: suggest compact. >200: suggest dense). User can override. Default that adapts is better than default that guesses once."
		rationale: "Most users use defaults. Make default smart, not static."
	},
]

rationale: "Toda interface B2B profissional enfrenta o dilema de densidade — profissionais querem ver muita informação de uma vez mas excesso causa overload. Na Mesh com fornecedores, construtoras, FIDC e regulador, cada persona tem necessidade radicalmente diferente de density. Esta lens operacionaliza: espectro de density de sparse a ultra-dense por persona e context (Tufte 1983, Few 2023, density levels 2022+), scan patterns profissionais com anchor-exception design (Nielsen 2006, Few 2023, professional scan patterns 2022+), data tables como componente mais denso com professional features (Few 2004, professional data tables 2023+, table as interface 2024+), KPI dashboards que respondem '4 perguntas' em 1 tela (Few 2006, KPI card 2022+, dashboard composition 2023+), inline micro-visualizations para glanceable data (Tufte 2006, micro-visualizations 2023+, glanceable data 2024+), responsive density que adapta per device (responsive density 2023+, content priority 2024+), e cognitive load management com chunking e progressive engagement (Miller 1956, Sweller 1988, chunking 2023+, progressive cognitive engagement 2024+). Universal, agnóstica a estágio, aplicável a qualquer interface B2B profissional que serve múltiplas personas com necessidades de density diferentes."

}
