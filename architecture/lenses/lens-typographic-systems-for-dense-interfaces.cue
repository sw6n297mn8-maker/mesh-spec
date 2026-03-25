package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// ════════════════════════════════════════════════════════════════
// lens-typographic-systems-for-dense-interfaces
// ════════════════════════════════════════════════════════════════

typographicSystemsForDenseInterfaces: artifact_schemas.#AnalyticalLens & {
id:     "lens-typographic-systems-for-dense-interfaces"
name:   "Sistemas Tipográficos para Interfaces Densas"

purpose: "Orientar decisões sobre como usar tipografia como sistema funcional — hierarchy, tabular figures, alignment e legibilidade em interfaces financeiras densas."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como definir escala tipográfica (sizes, weights, line heights) para interface B2B com alta densidade de dados",
		"a decisão envolve como garantir legibilidade em interfaces com centenas de números, labels e status simultâneos",
		"a decisão envolve quando usar monospace vs proportional fonts e como ativar tabular figures para colunas numéricas",
		"a decisão envolve como tipografia cria e reforça hierarquia visual (headline vs body vs caption vs label) em dashboards e tabelas",
		"a decisão envolve como escolher typeface para interface profissional de fintech B2B",
		"a decisão envolve como calibrar line-height e letter-spacing para density modes (compact, default, spacious)",
		"a decisão envolve como tipografia se adapta entre desktop e mobile sem perder legibilidade",
		"a decisão envolve como definir tratamento tipográfico para números financeiros (currency, percentual, scores)",
	]
	keywords: [
		"tipografia", "typography", "typeface", "font", "fonte",
		"tamanho", "font-size", "size", "scale", "escala tipográfica",
		"peso", "font-weight", "bold", "semibold", "regular", "medium",
		"line-height", "leading", "espaçamento", "spacing", "tracking",
		"monospace", "tabular figures", "tabular nums", "tnum",
		"hierarquia", "hierarchy", "headline", "body", "caption", "label",
		"legibilidade", "readability", "legibility", "x-height",
		"Inter", "IBM Plex", "Source Sans", "typeface selection",
		"compact", "dense", "condensed", "tight",
		"currency", "moeda", "percentual", "number formatting",
	]
	excludeWhen: [
		"a decisão é sobre densidade informacional e composição de layout — usar information-density-design",
		"a decisão é sobre sistema de cores — usar color-as-functional-language",
		"a decisão é sobre design tokens holísticos — usar design-tokens-and-systematic-composition",
		"a decisão é sobre labels e text em charts especificamente — usar data-visualization-semiotics",
	]
	rationale: "Em interfaces B2B densas com centenas de números, labels e status, tipografia é o veículo primário de informação — mais de 90% do conteúdo é textual ou numérico. A escala tipográfica determina se headline se destaca de body, se body é legível em compact mode, e se números alinham em tabelas financeiras. Na Mesh com tabelas de 500 operações, KPI dashboards com 8 cards, e portais multi-persona (fornecedor PME, construtora, FIDC), tipografia mal-calibrada produz: hierarquia flat (tudo do mesmo tamanho = nada se destaca), ilegibilidade em compact (13px sem line-height adequado), e desalinhamento numérico em tabelas financeiras (proportional figures em colunas de currency). ID cobre quanta informação por tela; CL cobre cores; DT tokeniza. Esta lens cobre como tipografia comunica: escala que cria hierarquia, pesos que criam ênfase, tabular figures que alinham números, typeface que suporta tudo, e line-height que calibra legibilidade por density."
}

concepts: [
	{
		id:         "ts-typographic-scale"
		name:       "Escala Tipográfica: Ratios que Criam Hierarquia Perceptível"
		nature:     "theoretical"
		role:       "framework"
		definition: "Bringhurst (2004, The Elements of Typographic Style, 3rd ed.): type scale cria hierarquia visual através de relações proporcionais de tamanho. Modern approach: modular scale baseada em ratio — minor second (1.125), minor third (1.200), major third (1.250), perfect fourth (1.333). Scale com ratio grande (1.333): saltos visíveis, range amplo (consumer apps 12-48px). Scale com ratio pequeno (1.125): transições suaves, range comprimido (dense B2B). Conceito de 'compact typographic scale for B2B' (2023+): interfaces B2B densas requerem scale comprimida — range de caption (11px) a headline (24px), ratio de ~2:1. Consumer apps usam 4:1. Razão: headline compete com 50 elementos — 48px headline domina excessivamente e desperdiça vertical space. 24px headline se destaca suficientemente. Conceito de 'named sizes vs numeric sizes' (2024+): 6 named sizes semânticos (xs, sm, base, md, lg, xl) que mapeiam para px per density mode. Developer usa 'base' — sistema resolve 13px (compact) ou 14px (default) ou 16px (spacious). Abstração previne ad hoc e habilita density modes."
		meshManifestation: "Na Mesh, typographic scale por density mode: **Compact (FIDC):** xs=11, sm=12, base=13, md=14, lg=16, xl=20px. Range 1.82:1. **Default (construtora):** xs=12, sm=13, base=14, md=16, lg=20, xl=24px. Range 2:1. **Spacious (fornecedor):** xs=13, sm=14, base=16, md=18, lg=24, xl=28px. Range 2.15:1. Usage: xs=timestamp/breadcrumb, sm=table header/label, base=body/cell, md=card title/subheading, lg=heading, xl=KPI hero number."
		meshImplication: "Implementation: (1) CSS tokens per density: --font-size-xs through --font-size-xl. body.density-compact overrides all. (2) 6 named sizes ONLY — no 12.5px or 15px. If between: use nearest. (3) minimum: 11px desktop, 13px mobile. CI flag below minimum. (4) ratio check: xl/xs should be 1.8-2.2:1. (5) vertical rhythm: font-size × line-height aligns to 4px grid. 14×1.43≈20px. Anti-pattern: 15 different font-sizes — hierarchy collapses because transitions are imperceptible. 6 sizes with clear jumps: hierarchy functional."
		rationale: "Bringhurst 2004: type scale. Compact scale B2B 2023+. Named sizes 2024+. Na Mesh, 6-step scale cria hierarquia clara sem consumir vertical space excessivo."
	},
	{
		id:         "ts-font-weight-system"
		name:       "Sistema de Pesos: Ênfase por Contraste de Weight, Não por Bold em Tudo"
		nature:     "operational"
		role:       "property"
		reviewCadence: "semi-annual"
		definition: "4 weights para B2B: regular (400) body, medium (500) labels/headers, semibold (600) headings/active states, bold (700) hero numbers/critical alerts. Conceito de 'weight restraint' (2023+): bold deve ser <5% do texto visível. Semibold+bold <15%. Os 85% restantes regular/medium criam contraste que faz bold funcionar. Conceito de 'weight as signal-to-noise ratio' (2024+): se 50% é bold: signal-to-noise = 1:1, sem contraste. Se 5% bold: 1:19, bold items pop via preattentive processing."
		meshManifestation: "Na Mesh: Regular (400) — table cells, body, descriptions, breadcrumbs, helpers. Medium (500) — table headers, form labels, inactive nav, badge text. Semibold (600) — section headings, card titles, active nav, dialog title. Bold (700) — KPI hero numbers, critical alert text, anomalous scores. Dashboard construtora: 4 KPI numbers bold (~4% of text). Everything else regular/medium."
		meshImplication: "Rules: (1) body always regular. (2) table headers medium, cells regular. Exception: anomaly cell = semibold. (3) KPI hero = bold. Card label = regular. (4) nav active = semibold, inactive = regular. (5) 5% audit: screenshot → count bold coverage. >5%: identify culprits (usually card titles or table headers that should be medium). (6) never light/thin (100-300): illegible at small sizes. Minimum: regular 400. (7) design system components enforce weight per role — developer doesn't choose."
		dependsOn: ["ts-typographic-scale"]
		crossDependsOn: [{
			lensId:    "lens-information-density-design"
			conceptId: "id-visual-hierarchy"
			context:   "ID define 3 níveis de hierarquia visual. TS font weight implementa: headline = bold (700), context = medium (500), detail = regular (400). ID é o princípio; TS é a implementação tipográfica com <5% bold para garantir contraste funcional."
		}]
		rationale: "Weight restraint 2023+. Signal-to-noise 2024+. Na Mesh, bold KPI contra regular table text: KPI pops. Se tudo bold: nada pops."
	},
	{
		id:         "ts-tabular-figures-and-number-formatting"
		name:       "Tabular Figures e Formatação Numérica: Números que Alinham e Comunicam"
		nature:     "operational"
		role:       "property"
		reviewCadence: "annual"
		definition: "Proportional figures: cada dígito tem largura diferente. Bom para prosa, ruim para tabelas (zigzag). Tabular figures (tabular-nums): mesma largura por dígito. Alignment perfeito em colunas. CSS: font-variant-numeric: lining-nums tabular-nums. Conceito de 'number presentation in fintech' (2024+): (a) tabular figures para alignment. (b) consistent decimal places (R$1.234,56 sempre 2 decimais). (c) thousand separators pt-BR (ponto para milhar). (d) right-alignment em columns numéricas. (e) R$ prefix sem espaço. (f) negative: parênteses (R$1.234,56) ou minus + error color. Oldstyle vs lining: interfaces sempre lining (mesma altura que maiúsculas)."
		meshManifestation: "Na Mesh: (1) table currency: R$48.750,00 — tabular, right-aligned, 2 decimais always. (2) percentual: 1,80% — tabular, right-aligned, 2 decimais. (3) KPI hero: R$2,3M — proportional OK (standalone). Tooltip: precision completa. (4) scores: 65 — tabular em table, proportional em gauge. (5) dates: dd/mmm/yyyy em monospace para alignment. (6) IDs: #OP-2026-00547 — JetBrains Mono. (7) negativos: (R$1.234,56) + error color."
		meshImplication: "Implementation: (1) table global CSS: font-variant-numeric: lining-nums tabular-nums. (2) .col-numeric: text-align right. (3) formatCurrency(), formatPercent(), formatScore() library — Intl.NumberFormat pt-BR. Never manual. (4) always 2 decimais for currency/percent. (5) abbreviation >1M: R$2,3M. Tooltip: full. (6) monospace for IDs: JetBrains Mono. (7) negative convention: choose 1 (parênteses or minus), apply consistently. (8) CLAUDE.md: 'use formatting library. Tables: tabular-nums. Numeric columns: right-aligned.'"
		dependsOn: ["ts-typographic-scale"]
		crossDependsOn: [{
			lensId:    "lens-information-density-design"
			conceptId: "id-professional-data-tables"
			context:   "ID define table design com alignment rules. TS implementa: tabular-nums + right-align + consistent decimals + formatCurrency(). ID diz 'números right-aligned'; TS provê o stack completo que transforma zigzag em coluna aligned."
		}]
		rationale: "Tabular figures non-negotiable para financial data. Na Mesh FIDC com 500 operations: tabular = scan 2s. Proportional = read each number = 30s+."
	},
	{
		id:         "ts-typeface-selection"
		name:       "Seleção de Typeface: Funcional, Legível, Profissional, Sustentável"
		nature:     "operational"
		role:       "property"
		reviewCadence: "annual"
		definition: "8 critérios ordenados: (1) legibilidade 11-13px. (2) tabular figures. (3) glyph distinction Il1/O0/5S. (4) aparência profissional. (5) 4+ weights. (6) pt-BR completo. (7) performance (web font). (8) licenciamento. **Inter** (Rasmus Andersson): todas 8 ✓✓. Desenhada para telas, otimizada small sizes, tall x-height, excellent tabular figures, Il1 claramente distintos, 9 weights (100-900), SIL Open Font License, variable font ~300KB. **IBM Plex Sans**: similar, slightly more corporate. **Source Sans Pro**: reliable alternative."
		meshManifestation: "Na Mesh: primary = Inter (400, 500, 600, 700). Variable font, subset latin-ext. Monospace = JetBrains Mono (400, 600) para IDs e technical strings. Fallback: -apple-system, BlinkMacSystemFont, Segoe UI, sans-serif. Loading: preload variable font, font-display: swap."
		meshImplication: "Rules: (1) single typeface family for all UI (Inter). Consistency > variety. (2) monospace only for technical data. (3) never: serif (blur at 11px), decorative (legibility penalty), condensed as primary. (4) preload + swap + subset. Cache with long lifetime. (5) glyph test at 11px: 'I l 1 | O 0 | 5 S.' If confusable: investigate rendering. (6) CLAUDE.md: 'all text Inter. Technical data JetBrains Mono .font-mono. No other fonts.' (7) Futura, Montserrat, etc for marketing only — not interface."
		dependsOn: ["ts-typographic-scale", "ts-font-weight-system"]
		rationale: "Typeface selection is criteria-driven engineering. Inter checks 8/8. Single typeface + monospace: maximum consistency, minimum complexity."
	},
	{
		id:         "ts-line-height-and-vertical-rhythm"
		name:       "Line Height e Ritmo Vertical: Legibilidade em Densidade Variável"
		nature:     "operational"
		role:       "property"
		reviewCadence: "semi-annual"
		definition: "Line height por contexto: headlines 1.1-1.2 (tight, single line). Body 1.4-1.6 (standard readability). Compact text (table cells) 1.2-1.4 (tight, short text). Data tables 1.2 (tightest acceptable). Bringhurst 2004: vertical rhythm — line-height × font-size alinhados ao spacing grid (4px) cria ordem visual subliminal. Conceito de 'density-responsive line-height' (2024+): line-height varia por density mode. Compact body = 1.3, default = 1.5, spacious = 1.6. Compact table cell = 1.2, default = 1.3, spacious = 1.4. Redução de line-height é 'free' density gain com minimal legibility cost para short text."
		meshManifestation: "Na Mesh: **Compact:** headline 1.1, body 1.3, table cell 1.2, form 1.2. **Default:** headline 1.15, body 1.5, table cell 1.3, form 1.3. **Spacious:** headline 1.2, body 1.6, table cell 1.4, form 1.4. Grid: 4px. Compact base: 13×1.23≈16px. Default: 14×1.43≈20px."
		meshImplication: "Implementation: (1) tokens: --line-height-tight, --line-height-normal, --line-height-relaxed per density. (2) table row height derived: text + padding. Compact: 16+8=24px. Default: 18+18=36px. Spacious: 22+26=48px. (3) multi-line in tight: if cell wraps 2+ lines at 1.2: truncate + tooltip. Tight for 3+ lines: degrades. (4) letter-spacing: ALL-CAPS labels +0.05em. Large headlines -0.01em. (5) mobile body minimum 1.4 even in compact. (6) anti-pattern: uniform 1.5 everywhere — headlines waste space, tables waste rows."
		dependsOn: ["ts-typographic-scale"]
		rationale: "Bringhurst 2004: vertical rhythm. Density-responsive 2024+. Compact 13px×1.2 → 24px rows → 55% more data than default, minimal legibility cost for short text."
	},
	{
		id:         "ts-responsive-typography"
		name:       "Tipografia Responsiva: Adaptar ao Device sem Perder Legibilidade"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Conceito de 'typographic minimums by device' (2024+): mobile constraints: (a) min font 14px (13px borderline, 12px illegible). (b) min tap target 44×44px. (c) reduced scale range 14-24px vs desktop 11-24px. (d) increased line-height ≥1.4. Desktop allows compact (11px min). Tablet: default only (touch + medium size). Mobile: spacious-influenced with minimums enforced."
		meshManifestation: "Na Mesh: desktop >1024px: full scale per density. Tablet 640-1024px: default only. Mobile <640px: xs=13, sm=14, base=16, md=18, lg=22, xl=26px. Line-height ≥1.4 mobile body. Compact mode: desktop only."
		meshImplication: "(1) media queries override tokens at mobile breakpoint: @media (max-width: 640px) { --font-size-base: 16px; --line-height-normal: 1.5; }. (2) compact never on mobile/tablet. (3) do not use CSS clamp() for data interfaces — need predictable sizes, not fluid. (4) test at 375px: all text ≥14px? KPI readable? No horizontal scroll? (5) table on mobile: if columns don't fit at 14px: hide non-essential columns, not shrink text."
		dependsOn: ["ts-typographic-scale", "ts-line-height-and-vertical-rhythm"]
		crossDependsOn: [{
			lensId:    "lens-information-density-design"
			conceptId: "id-responsive-density"
			context:   "ID define responsive density per persona × device. TS implements: desktop compact=11px min, mobile spacious=14px min. ID says 'mobile shows essential layer'; TS says 'mobile essential uses 16px base, 1.5 line-height — legible for quick scan.'"
		}]
		rationale: "Typographic minimums 2024+. Fornecedor celular com 16px: reads in 2s. Same at 11px (leaked compact): squints, zooms."
	},
	{
		id:         "ts-typography-for-financial-communication"
		name:       "Tipografia para Comunicação Financeira: 4 Roles para Números"
		nature:     "operational"
		role:       "property"
		reviewCadence: "quarterly"
		definition: "Conceito de 'typographic treatment hierarchy for numbers' (2024+): 4 roles: (1) hero numbers (KPI) — xl + bold + proportional + left-aligned + primary color. Standalone prominent. (2) data numbers (table) — base + regular + tabular + right-aligned + primary color. Column scanning. (3) delta numbers (comparison) — sm + regular + tabular + semantic color. Contextual change. (4) reference numbers (thresholds) — sm + regular + secondary color. Benchmarks. This hierarchy ensures: hero grabs attention, data aligns for scanning, delta provides context, reference provides benchmark."
		meshManifestation: "Na Mesh: hero: 'R$2,3M' xl bold. Data: 'R$48.750,00' base regular tabular right. Delta: '↑8,3%' sm regular semantic. Reference: 'target: 2,5%' sm regular muted. Score: table=base regular tabular, gauge=lg semibold. Currency in prose: base regular proportional."
		meshImplication: "Design system: (1) define 4 number role components: NumberHero, NumberData, NumberDelta, NumberReference. Each has: font-size, weight, variant-numeric, alignment, color preset. (2) developer uses role component, not raw styling. (3) formatting via library for all roles. (4) CLAUDE.md: 'numbers follow 4 roles: hero (KPI), data (table), delta (comparison), reference (threshold). Use appropriate component.' Anti-pattern: all numbers same size/weight — KPI 2.3M same as table 48.750 same as comparison 8.3%. No hierarchy."
		dependsOn: ["ts-typographic-scale", "ts-font-weight-system", "ts-tabular-figures-and-number-formatting"]
		rationale: "Number treatment hierarchy 2024+. In fintech, numbers are primary content. 4-role hierarchy ensures each number type communicates its role."
	},
	{
		id:         "ts-typographic-anti-patterns"
		name:       "Anti-Patterns Tipográficos: Catálogo do Que Nunca Fazer"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "8 anti-patterns: (1) 'all-bold' — 35% bold, nothing stands out. Fix: <5% bold. (2) 'font-size explosion' — 15+ sizes. Fix: 6 named. (3) 'decorative typeface for data' — Futura for tables. Fix: Inter. (4) 'proportional in tables' — zigzag columns. Fix: tabular-nums. (5) 'uniform line-height' — 1.5 everywhere. Fix: per-context. (6) 'thin on screen' — 100-300 weight. Fix: min 400. (7) 'center-align everything.' Fix: left text, right numbers. (8) 'text as image' — SVG text. Fix: real HTML text."
		meshManifestation: "Na Mesh, prevention: agent-generated ad hoc sizes → CLAUDE.md + CI lint. Proportional in tables → global CSS. All-bold dashboard → DS components enforce weight. Detection: quarterly anti-pattern scan against 8 items."
		meshImplication: "CI enforcement: (1) lint for raw font-size values not in token list. (2) lint for raw font-weight values not in token list. (3) lint for missing tabular-nums on table components. (4) quarterly: screenshot → squint test (hierarchy visible?), count unique font-sizes (>8?), count bold coverage (>5?), check table alignment. Each anti-pattern detected: fix + prevention rule."
		dependsOn: ["ts-typographic-scale", "ts-font-weight-system", "ts-tabular-figures-and-number-formatting", "ts-typeface-selection", "ts-line-height-and-vertical-rhythm"]
		rationale: "Anti-patterns recur because they're tempting. Cataloguing enables: automated prevention (CI) + periodic detection (quarterly review)."
	},
	{
		id:            "ts-typography-review"
		name:          "Revisão Tipográfica: Inventário Periódico"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário: (1) scale — 6 sizes only? Zero rogue? (2) weight — bold <5%? (3) tabular — numeric columns aligned? Consistent decimals? (4) typeface — Inter loaded? Monospace for IDs? (5) line height — per context/density? (6) responsive — mobile ≥14px? Compact desktop-only? (7) number roles — 4 roles applied? (8) anti-patterns — any of 8 detected?"
		meshManifestation: "Na Mesh: revisão trimestral. Mensal: spot-check 1 table + 1 KPI card + 1 form."
		meshImplication: "Monthly (20min): inspect table (tabular-nums? right-aligned? decimals?), KPI card (hero bold? label regular? delta semantic?), form (labels medium? input regular?). Quarterly (1h): devtools font-size audit (unique values?), weight audit (bold %?), tabular audit (all tables?), responsive test (375px), anti-pattern scan. If zero issues: review is superficial."
		dependsOn: ["ts-typographic-scale", "ts-font-weight-system", "ts-tabular-figures-and-number-formatting", "ts-typeface-selection", "ts-line-height-and-vertical-rhythm", "ts-responsive-typography", "ts-typography-for-financial-communication", "ts-typographic-anti-patterns"]
		rationale: "Typography drifts with feature additions. Quarterly audit + monthly spot-check maintains system."
	},
]

reasoningProtocol: [
	{
		question:  "Escala tipográfica tem exatamente 6 named sizes (xs-xl) com ratio ~2:1? Zero rogue sizes?"
		reveals:   "Se hierarquia é sistematizada — ou se ad hoc sizing diluiu em 15+ valores."
		rationale: "Compact scale B2B 2023+. 6 sizes com clear jumps: hierarchy functional."
	},
	{
		question:  "Bold (700) é <5% do texto na tela? Hierarchy funciona por contraste?"
		reveals:   "Se weight creates emphasis — ou se 'everything is important = nothing is.'"
		rationale: "Weight restraint 2023+. 5% bold = hero pops. 35% bold = nothing pops."
	},
	{
		question:  "Colunas numéricas usam tabular figures, right-aligned, decimais consistentes?"
		reveals:   "Se tabelas financeiras são scannable — ou se coluna zigzagueia."
		rationale: "Number presentation fintech 2024+. Tabular: scan 2s. Proportional: read each = 30s."
	},
	{
		question:  "Typeface passa nos 8 critérios? Legibility 11px, tabular, glyph distinction, weights, pt-BR?"
		reveals:   "Se typeface é funcional — ou se foi escolhida por estética ignorando requisitos."
		rationale: "Criteria-driven. Inter: 8/8. Futura: 3/8."
	},
	{
		question:  "Line-height calibrado por context e density? Tight headlines, normal body, compact cells?"
		reveals:   "Se vertical space é otimizado — ou se uniform line-height desperdiça/comprime."
		rationale: "Density-responsive 2024+. Table cells 1.2. Body 1.5. Headlines 1.1."
	},
	{
		question:  "Números seguem 4 roles (hero/data/delta/reference) com tratamento distinto?"
		reveals:   "Se hierarquia numérica é projetada — ou se all numbers same treatment."
		rationale: "Number treatment hierarchy 2024+. Numbers are primary content in fintech."
	},
	{
		question:  "Mobile ≥14px body? Compact mode desktop-only? No leaked compact on mobile?"
		reveals:   "Se responsive typography funciona — ou se 11px compact renderiza em celular."
		rationale: "Typographic minimums 2024+. Mobile 14px is legibility threshold."
	},
]

meshExamples: [
	{
		id:       "ex-numeric-alignment-fix"
		scenario: "FIDC gestor reviewing table of 500 operations: column of values (R$48.750,00 / R$1.234,56 / R$123.456,78) doesn't align. Digits zigzag. Decimals don't align. Scanning for largest value requires reading each number: 30+ seconds."
		analysis: "Root cause: proportional figures. Digit '1' is 60% width of '0'. Right-alignment without tabular: right edge aligns but digits still zigzag internally. Decimal comma doesn't align because preceding digits vary."
		recommendation: "(1) font-variant-numeric: lining-nums tabular-nums on all tables. Every digit same width. (2) .col-currency: text-align right. (3) formatCurrency(value) always 2 decimals. (4) Thousand separator always. (5) DataTable component applies automatically per column type 'currency'. (6) Result: gestor scans 500-row column vertically in <3 seconds. Largest values visually obvious. (7) Effort: 1 CSS line + 20-line formatting wrapper. <1 hour."
		principlesApplied: ["ax-01", "ax-02"]
		assumptions: ["Inter tabular-nums works well — verified", "500-row tabular is performant — CSS property, not JS", "gestor scans vertically — standard financial reading pattern"]
		rationale: "Tabular figures: 1 CSS line transforms 'read each number' into 'scan column visually.' Permanent improvement."
	},
	{
		id:       "ex-hierarchy-weight-audit"
		scenario: "Dashboard audit: 35% of text bold. KPI numbers, card titles, table headers, nav labels, breadcrumbs, helper text — all bold. Gestor: 'everything looks same importance, can't find what matters.'"
		analysis: "35% bold → signal-to-noise 1:2. Needed: 1:19. KPI numbers (should be loudest) compete with bold breadcrumbs. Mechanism destroyed: bold works via contrast, and contrast requires non-bold majority."
		recommendation: "(1) Weight reassignment: KPIs bold (700) ✓. Card titles → semibold (600). Table headers → medium (500). Nav active → semibold, inactive → regular. Breadcrumbs → regular. Helpers → regular. (2) Post-fix: bold ~4%, semibold ~8%, medium ~12%, regular ~76%. (3) KPIs pop against regular. Eyes go to KPIs first (preattentive bold detection). (4) DS components enforce: MetricCard.value = bold. TableHeader = medium. Developer doesn't choose. (5) Squint test: KPIs are darkest/heaviest elements? Yes = hierarchy works."
		principlesApplied: ["ax-01", "ax-02"]
		assumptions: ["reducing bold from 35% to 4% won't look 'weak' — standard in Linear, Figma, Notion", "squint test is valid — established UX technique"]
		rationale: "From 35% to 4% bold: KPI numbers become undisputed priority. Every other element supports, not competes."
	},
	{
		id:       "ex-compact-mode-legibility"
		scenario: "FIDC wants 50+ rows without scrolling. Default shows 18. Team considers: 10px font, 0 padding. Gestor tests: 'more rows but can't read them.'"
		analysis: "Brute force (10px, 0 padding) = illegible. Systematic compact: 13px Inter with 1.2 line-height is legible for short text. Row height derived from typography, not arbitrary."
		recommendation: "(1) base=13px, line-height=1.2 → text block ≈16px. Padding 4px+4px. Row=24px. (2) vs default 36px: 55% more rows (28 vs 18). (3) Header=12px medium. Column padding=8px. Long values: truncate+tooltip. (4) Virtual scroll for >screen-height (50+ rows at 24px = 1200px > screen). (5) Compact = desktop-only toggle. FIDC default. Switch to default for extended reading."
		principlesApplied: ["ax-01", "ax-03"]
		assumptions: ["13px Inter legible at 1.2 for short text — validated 1080p+", "24px row sufficient click target with mouse — yes, not touch", "virtual scroll handles 500+ rows — standard technique"]
		rationale: "Systematic compact respects legibility thresholds. 13px+1.2+4px = 24px rows: legible AND dense. 10px+1.0+0px: illegible."
	},
	{
		id:       "ex-typeface-evaluation"
		scenario: "Designer proposes Futura for interface. Rationale: 'clean, modern, distinctive.' Developer: 'hard to read at small sizes in table.'"
		analysis: "Futura against 8 criteria: (1) legibility 11-13px: POOR — geometric forms, low x-height. (2) tabular figures: POOR — not included. (3) glyph distinction: POOR — Il1 nearly identical. O/0 both perfect circles. (4) professional: GOOD. (5) weights: MEDIUM — limited free. (6) pt-BR: GOOD. (7) performance: MEDIUM. (8) licensing: POOR — commercial. Score: 3/8. Inter: 8/8."
		recommendation: "(1) Reject Futura for interface. Failure modes: Il1 ambiguous in operation IDs, proportional digits zigzag, low x-height at 13px. (2) Inter for all interface. (3) Futura for marketing: website hero, pitch deck, brand collateral. (4) Document as ADR: 'Interface: Inter. Brand: Futura (marketing). Rationale: 8 functional criteria.' (5) Separate interface and brand typeface is standard practice (Stripe does this)."
		principlesApplied: ["ax-01", "ax-03"]
		assumptions: ["Inter is optimal — IBM Plex also viable", "separate brand/interface fonts is acceptable — standard B2B practice"]
		rationale: "Criteria-driven: Futura beautiful at 48px, problematic at 13px. Inter functional at 11px, pleasant at 48px. In B2B data: function dominates."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-information-density-design"
		relation: "complementsWith"
		context:  "ID define density modes e composição. TS implementa: compact=13px+1.2+24px rows. Default=14px+1.5+36px. TS popula density modes de ID. ID diz '28 rows compact'; TS diz '13px+1.2+4px padding=24px rows → 28 rows.'"
	},
	{
		lensId:   "lens-color-as-functional-language"
		relation: "complementsWith"
		context:  "CL define semantic colors. TS define type. Juntos: headline=xl+bold+primary color. Error=sm+regular+error color. Multi-dimensional hierarchy via size+weight+color."
	},
	{
		lensId:   "lens-data-visualization-semiotics"
		relation: "complementsWith"
		context:  "DV charts need text. TS defines: axis labels=xs+regular, data labels=sm+tabular-nums, chart title=md+semibold. TS garante labels legíveis e números alinhados em charts."
	},
	{
		lensId:   "lens-design-tokens-and-systematic-composition"
		relation: "complementsWith"
		context:  "DT tokeniza: --font-size-base, --font-weight-bold, --line-height-normal. TS define valores e rationale; DT encodes como tokens. TS=design decision; DT=implementation encoding."
	},
	{
		lensId:   "lens-progressive-disclosure-and-information-architecture"
		relation: "complementsWith"
		context:  "PD define layers. TS provê tipografia por layer: overview headline=xl+bold. Detail body=base+regular. TS diferencia layers visualmente."
	},
	{
		lensId:   "lens-trust-and-credibility-design"
		relation: "complementsWith"
		context:  "TC builds trust. TS contribui: consistent number formatting (tabular, aligned, precise decimals) signals professionalism. Inconsistency signals carelessness. In fintech: typography consistency is trust signal."
	},
	{
		lensId:   "lens-multi-sided-platform-ux"
		relation: "complementsWith"
		context:  "MUX define experiência por lado. TS calibra: FIDC=compact (13px), construtora=default (14px), fornecedor=spacious (16px). Same system, different density per side."
	},
]

limitations: [
	{
		description: "11px minimum may be too small for visual impairment, older users, or low-res monitors."
		alternative: "Respect browser zoom (WCAG 2.1 AA: resizable to 200%). Density toggle: compact → default → spacious. 11px is default on modern displays; users who need larger: zoom or toggle."
		rationale: "Accessibility > density. Zoom and density toggle are escape hatches."
	},
	{
		description: "Single typeface (Inter) may not differentiate brand."
		alternative: "Inter for interface. Brand typeface for marketing. Interface serves data; marketing serves identity. Standard B2B practice."
		rationale: "Brand differentiation through: color, spacing, components, logo — not interface typeface."
	},
	{
		description: "4-weight system may feel restrictive."
		alternative: "4 weights × 6 sizes = 24 combinations. If intermediate emphasis needed: change size (md vs base) not weight (450). Fewer weights = each more distinctive."
		rationale: "More weights = each weight carries less meaning."
	},
	{
		description: "Tabular figures in running text look slightly spaced."
		alternative: "Tabular only in tables and data components. Proportional in prose. Context-appropriate figure style via CSS scope."
		rationale: "Tabular for alignment contexts. Proportional for reading. Both have purpose."
	},
	{
		description: "Vertical rhythm 4px grid is hard to maintain perfectly with varying components."
		alternative: "Approximate: line-height × font-size approximately aligns. Spacing tokens are 4px multiples. Accept ~90% alignment — provides 95% of visual benefit. Don't spend engineering time on pixel-perfect."
		rationale: "Vertical rhythm is perceptual. Close alignment ≈ perfect alignment to human eye."
	},
]

rationale: "Em interfaces B2B densas, tipografia é veículo de >90% da informação. Na Mesh fintech com tabelas de 500 operações, KPI dashboards, e portais multi-persona, esta lens operacionaliza: escala tipográfica compacta com 6 named sizes e ratio ~2:1 (Bringhurst 2004, compact scale 2023+, named sizes 2024+), sistema de pesos com restraint <5% bold e signal-to-noise ratio (weight restraint 2023+, signal-to-noise 2024+), tabular figures e formatação numérica para fintech (lining-nums tabular-nums, number presentation 2024+), seleção de typeface por 8 critérios funcionais (Inter, criteria-driven), line-height e ritmo vertical calibrados por density (Bringhurst 2004, density-responsive 2024+), tipografia responsiva com minimums por device (typographic minimums 2024+), 4-role hierarchy para números financeiros (number treatment hierarchy 2024+), e catálogo de 8 anti-patterns com CI enforcement. Universal para B2B data-dense; específica para fintech multi-persona."

}
