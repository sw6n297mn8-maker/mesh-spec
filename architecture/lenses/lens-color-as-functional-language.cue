package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

colorAsFunctionalLanguage: artifact_schemas.#AnalyticalLens & {
	id:     "lens-color-as-functional-language"
	name:   "Cor como Linguagem Funcional"

	purpose: "Orientar decisões sobre como usar cor como linguagem funcional — status, severidade, categorias e acessibilidade em interfaces financeiras."
	status: "draft"

	trigger: {
		conditions: [
			"a decisão envolve como definir sistema de cores semânticas (success, warning, error, info, neutral) para comunicar status e estados",
			"a decisão envolve como usar cor para comunicar risco, prioridade, compliance e saúde operacional em interface fintech",
			"a decisão envolve como garantir acessibilidade de cor (contrast ratios WCAG, color blindness, redundant encoding)",
			"a decisão envolve como definir paletas de dados para charts, heatmaps e visualizações quantitativas",
			"a decisão envolve como cor interage com dark mode, themes customizados e white-labeling",
			"a decisão envolve como manter consistência de significado de cor em toda a plataforma (cross-persona, cross-interface)",
			"a decisão envolve como definir cores de brand vs cores funcionais e onde cada uma é usada",
			"a decisão envolve como cor funciona em different density modes e contexts (compact table vs spacious card)",
		]
		keywords: [
			"cor", "color", "colour", "paleta", "palette",
			"semântica", "semantic", "status", "success", "warning", "error", "info",
			"contraste", "contrast", "WCAG", "acessibilidade", "accessibility", "a11y",
			"daltonismo", "color blindness", "deuteranopia", "protanopia", "CVD",
			"heatmap", "data palette", "sequential", "diverging", "categorical",
			"dark mode", "theme", "tema", "light mode", "high contrast",
			"badge", "status indicator", "alert", "notification", "banner",
			"brand color", "primary color", "accent",
			"conditional formatting", "color coding", "traffic light",
		]
		excludeWhen: [
			"a decisão é sobre tipos de gráficos e encoding visual de dados — usar data-visualization-semiotics",
			"a decisão é sobre tipografia e weight hierarchy — usar typographic-systems-for-dense-interfaces",
			"a decisão é sobre density de layout e dashboard composition — usar information-density-design",
			"a decisão é sobre design tokens como infraestrutura holística — usar design-tokens-and-systematic-composition",
		]
		rationale: "Cor em B2B fintech não é decoração nem branding — é linguagem funcional. Verde = aprovado, seguro, dentro do limite. Vermelho = rejeitado, risco, acima do limite. Este mapeamento semântico, quando consistente, permite scan preattentive (Healey 1996) que detecta anomalias em <200ms. Mas cor mal-implementada desinforma: contraste insuficiente, significado inconsistente, inacessível para daltônicos (8% dos homens). DV cobre charts; TS cobre tipografia; ID cobre layout. Esta lens cobre como cor comunica significado funcional — sistema semântico, acessibilidade, paletas de dados, themes, conditional formatting, e consistência."
	}

	concepts: [
		{
			id:         "cl-semantic-color-system"
			name:       "Sistema de Cores Semânticas: Cada Cor Tem Significado Fixo em Toda a Plataforma"
			nature:     "theoretical"
			role:       "framework"
			definition: "Cores semânticas: cores com significado funcional fixo, independente de contexto ou persona. Standard consolidado (Material Design 2014+, Lightning 2019+, Carbon 2020+): success (verde) = positivo. Warning (amarelo/laranja) = atenção. Error (vermelho) = problema. Info (azul) = informacional neutro. Neutral (cinza) = inativo. Conceito de 'semantic color consistency' (2023+): se verde = success no KPI card, então verde = success no badge, na notification, no chart, no ícone. Cross-interface, cross-persona. Conceito de 'functional color budget' (2024+): limitar a 5 intents. Cada com 3 variants: primary (text/icons, alto contraste), subtle (backgrounds, baixa saturação), border (outlines). 5 × 3 = 15 semantic tokens + brand + gray scale = ~30-35 total."
			meshManifestation: "Na Mesh: success (verde) = qualificado, aprovado, compliance ok, score >70, inadimplência <target. Warning = doc expirando, score 50-70, inadimplência approaching target, pendente. Error = compliance falhou, score <50, inadimplência >target, rejeitado, default. Info (azul) = novo, em análise, informativo. Neutral = inativo, cancelado, disabled. Brand (navy) = buttons, links, active nav — distinto de info (sky blue)."
			meshImplication: "Implementation: (1) 5 intents × 3 variants = 15 tokens: --color-success-primary: hsl(142, 71%, 29%). --color-success-subtle: hsl(142, 76%, 95%). --color-success-border: hsl(142, 71%, 65%). Same for warning, error, info, neutral. (2) status mapping documented: every status classified into exactly 1 intent. New status requires classification before UI work. (3) no dual meaning: red = problem only. Green = positive only. (4) inverted semantics for specific metrics: inadimplência ↓ = success (decrease is good). DeltaIndicator has invertPositive prop. System handles inversion. (5) for agents: CLAUDE.md: 'use semantic tokens. approved → success. rejected → error. Never hardcode hex.' Anti-pattern: verde para 'novo' — 'novo' is info, not success. User assumes positive, discovers neutral. Trust broken."
			rationale: "Material Design, Lightning, Carbon: standard. Semantic consistency 2023+. Functional color budget 2024+. Na Mesh, 5 intents × 3 variants = complete system. Verde = success everywhere."
		},
		{
			id:         "cl-contrast-and-wcag"
			name:       "Contraste e WCAG: Legibilidade em Todas as Condições"
			nature:     "theoretical"
			role:       "heuristic"
			definition: "WCAG 2.1 AA: normal text ≥4.5:1, large text (≥18px or ≥14px bold) ≥3:1, non-text ≥3:1. Conceito de 'pre-checked combinations' (2023+): design system provides validated pairs — developer picks from menu, not spectrum. Zero violations by design. Conceito de 'ambient light margin' (2024+): target 5:1 not 4.5:1. Extra absorbs: ambient light, monitor calibration, rendering variation. Conceito de 'green challenge': bright greens often fail contrast on white. Solution: darker greens (lower lightness) for text. success-primary: hsl(142, 71%, 29%) = 5.2:1 ✓."
			meshManifestation: "Na Mesh: text-primary (#111) on white: 18.6:1. text-secondary (#666) on white: 5.74:1 (margin). Previous #999: 2.85:1 — failed. Semantic text (success-primary dark green on white): 5.2:1. Badge text on subtle background: pre-checked. Chart elements: ≥3:1."
			meshImplication: "Implementation: (1) contrast matrix documenting all planned fg/bg combinations with ratios. Developer picks from matrix. (2) green challenge: dark greens for text, light greens for backgrounds. (3) CI: axe-core contrast audit every PR. (4) Figma: Stark plugin checks in design phase. (5) margin policy: target 5:1 normal text, 3.5:1 non-text. (6) disabled text ≥3:1 (not invisible). Placeholder text ≥3:1. Anti-pattern: #bbb secondary text on white (1.93:1) — 'looks elegant in Figma on Retina.' Reality: illegible on Windows 1080p in office with windows."
			dependsOn: ["cl-semantic-color-system"]
			crossDependsOn: [{
				lensId:    "lens-typographic-systems-for-dense-interfaces"
				conceptId: "ts-typographic-scale"
				context:   "TS defines font sizes (11-28px). CL contrast interacts: 11px text needs ≥4.5:1 (normal text). 24px+ needs only ≥3:1 (large text). Smaller text = stricter contrast. CL must ensure semantic colors pass 4.5:1 at smallest TS sizes."
			}]
			rationale: "WCAG 2.1 AA. Pre-checked 2023+. Ambient light 2024+. #666 at 5.74:1 is legible in office with windows. #999 at 2.85:1 is not."
		},
		{
			id:         "cl-color-independent-encoding"
			name:       "Encoding Independente de Cor: Nunca Depender Apenas de Cor"
			nature:     "theoretical"
			role:       "heuristic"
			definition: "CVD affects ~8% males. WCAG 1.4.1: color not the only visual means. Always pair with: text label, icon/shape, pattern, position, typography. Conceito de 'grayscale test' (2023+): convert to grayscale — if information is lost, encoding depends on color only → fix. Conceito de 'redundant encoding' (2023+): each color encoding has ≥1 non-color channel. StatusBadge: color + text + icon = 3 channels. Chart series: color + dash pattern + label. In 10-person FIDC team: 47% probability ≥1 has CVD."
			meshManifestation: "Na Mesh: status badge = color + text ('APROVADO') + icon (✓). Table conditional = color + bold weight. Chart series = color + dash + direct label. Heatmap = luminance gradient (not hue). Compliance dot = color + text label."
			meshImplication: "Rules: (1) StatusBadge component requires status enum → generates color + text + icon automatically. Cannot create color-only badge. (2) chart Series requires color + dashArray + label. (3) quarterly grayscale test on 3 screens. (4) CVD simulator (Chrome DevTools) quarterly. (5) never: color-only status dots, red-green only chart differentiator, traffic lights without text. Anti-pattern: compliance column with only colored circles (● green, ● red) — 8% of male users see identical brownish circles."
			dependsOn: ["cl-semantic-color-system", "cl-contrast-and-wcag"]
			crossDependsOn: [{
				lensId:    "lens-data-visualization-semiotics"
				conceptId: "dv-chart-accessibility"
				context:   "DV defines chart accessibility with redundant encoding. CL provides the framework: color-independent is the principle; DV applies to charts (dash patterns, shapes). CL defines rule; DV implements for visualizations."
			}]
			rationale: "WCAG 1.4.1. CVD 8% males. Grayscale test 2023+. StatusBadge with 3 channels: accessible to 100%. Color-only dot: inaccessible to 8%."
		},
		{
			id:         "cl-data-palettes"
			name:       "Paletas de Dados: Cores para Visualizações Quantitativas"
			nature:     "operational"
			role:       "property"
			reviewCadence: "semi-annual"
			definition: "3 palette types: (1) sequential (single hue, varying luminance) for continuous ordered data. (2) diverging (2 hues meeting at neutral center) for data with midpoint. (3) categorical (distinct hues) for nominal unrelated categories, max 6-8. Conceito de 'perceptually uniform palettes' (2023+): equal data steps = equal perceived color change. viridis, CARTOcolors. Rainbow is perceptually non-uniform — yellow band creates false threshold artifact. Conceito de 'CVD-safe palettes' (2024+): categorical avoids red-green pair. Uses blue, orange, teal, purple, pink, brown. Sequential based on luminance (all CVD types perceive luminance). Diverging: blue-red instead of green-red."
			meshManifestation: "Na Mesh: sequential (risk) = white→light peach→salmon→red→dark red. For: inadimplência heatmap, concentration gradient. Diverging (performance) = blue→white→red. For: score deviation, performance vs benchmark. Categorical = blue, orange, teal, purple, pink, brown. For: safras, segmentos, chart series."
			meshImplication: "Implementation: (1) tokens: --palette-seq-1 through --palette-seq-5. --palette-cat-1 through --palette-cat-6. (2) usage: continuous → sequential. Midpoint → diverging. Nominal → categorical (max 6). >6 categories: aggregate 'Outros' in gray. (3) never rainbow — chart components have no rainbow option. (4) legend always. (5) tooltip for precision (color imprecise for exact values). (6) test: render in deuteranopia simulator. Sequential gradient visible? Categorical 6 distinguishable? Anti-pattern: rainbow heatmap — yellow band creates false threshold, CVD users lose red-green distinction."
			dependsOn: ["cl-semantic-color-system", "cl-color-independent-encoding"]
			crossDependsOn: [{
				lensId:    "lens-data-visualization-semiotics"
				conceptId: "dv-marks-and-channels"
				context:   "DV defines color as channel. CL provides specific values: sequential for continuous, categorical for nominal. DV says 'encode in color'; CL says 'which specific colors, CVD-safe, perceptually uniform.'"
			}]
			rationale: "Perceptually uniform 2023+. CVD-safe 2024+. Sequential white→red: luminance gradient perceivable by all. Rainbow: worst palette."
		},
		{
			id:         "cl-surface-and-elevation"
			name:       "Superfícies e Elevação: Hierarquia Espacial por Cor e Sombra"
			nature:     "operational"
			role:       "property"
			reviewCadence: "semi-annual"
			definition: "Surface color + shadow communicate spatial hierarchy. Conceito de 'surface color hierarchy' (2023+): canvas (deepest, light gray) → surface-primary (cards, white) → surface-secondary (sidebar, slightly darker) → surface-elevated (modals/dropdowns, white + shadow). Shadow scale: sm (cards), md (dropdowns), lg (modals). Surfaces separated by background color difference, reducing need for borders (less visual clutter)."
			meshManifestation: "Na Mesh (light mode): canvas hsl(0,0%,97%). surface-primary white. surface-secondary hsl(0,0%,95%). surface-elevated white + shadow-md. surface-interactive hsl(0,0%,94%) for hover."
			meshImplication: "5 surface tokens + 3 shadow tokens. Cards separated from canvas by color (no border needed). Modal: elevated + shadow-lg. Dark mode: canvas near-black, surfaces progressively lighter, shadows subtle. Density: spacing changes, surface colors don't. Anti-pattern: all surfaces white, separated only by borders → 'boxy' with visual noise."
			dependsOn: ["cl-semantic-color-system"]
			rationale: "Surface hierarchy 2023+. Cards on canvas (white on light gray): separation without borders. Cleaner, less cluttered."
		},
		{
			id:         "cl-brand-vs-functional-color"
			name:       "Brand vs Funcional: Dois Sistemas de Cor com Propósitos Distintos"
			nature:     "theoretical"
			role:       "property"
			definition: "Two color systems coexist: brand (identity — buttons, links, active states, <5% visual area) and functional/semantic (meaning — status, alerts, formatting, ~8% visual area). Must be visually distinct. Conceito de 'brand color restraint B2B' (2023+): B2B tools: 90%+ neutral + semantic. Brand is accent. Consumer apps: brand-heavy. Conceito de separation: brand-primary hue must differ from nearest semantic by perceivable amount (≥30° hue or significant lightness difference)."
			meshManifestation: "Brand-primary: navy hsl(215, 60%, 25%). Info: sky blue hsl(200, 80%, 50%). Distinguishable by lightness. Brand presence: ~3% of dashboard area. Brand used for: buttons, links, active sidebar. Never for: status, data vis, backgrounds, emphasis."
			meshImplication: "Brand tokens separate from semantic. White-labeling: brand tokens override (navy → client blue). Semantic unchanged: success still green, error still red. Meaning preserved; identity customized. Test: apply red brand color. Conflict with error-red? If yes: adjust brand-red hue/saturation to distinguish. Anti-pattern: 'our brand is green, so all badges are green' — status info: zero."
			dependsOn: ["cl-semantic-color-system"]
			rationale: "Brand restraint B2B 2023+. Brand ~3% visual area. Data dominates; brand is accent."
		},
		{
			id:         "cl-dark-mode-and-theming"
			name:       "Dark Mode e Theming: Cor que Adapta via Token Override"
			nature:     "operational"
			role:       "method"
			reviewCadence: "annual"
			definition: "Dark mode via token override: semantic tokens resolve to different values per theme. Component code unchanged. Conceito de 'theme-agnostic design' (2024+): components use semantic token names; themes define values. Conceito de 'semantic color adjustment for dark mode' (2024+): success green in dark mode must be lighter (to contrast against dark background). Each semantic color has dark-mode-specific value optimized for contrast."
			meshManifestation: "Light mode default. Dark mode as option (settings). FIDC may prefer dark (working late). White-labeling: brand tokens per client, semantic unchanged."
			meshImplication: "All colors as CSS custom properties. Zero hardcoded hex (grep verification). Dark theme: :root[data-theme='dark'] overrides all tokens. Contrast re-verified in dark mode. Data palettes adjusted (sequential center changes from white to dark neutral). Priority: light mode first → stable → dark mode. Not simultaneously. Anti-pattern: dark mode as afterthought with hardcoded colors everywhere: 3 months of fixes."
			dependsOn: ["cl-semantic-color-system", "cl-contrast-and-wcag"]
			crossDependsOn: [{
				lensId:    "lens-design-tokens-and-systematic-composition"
				conceptId: "dt-token-architecture"
				context:   "DT 3-layer tokens enable CL theming: semantic tokens (alias layer) resolve to different global values per theme. Components reference aliases; themes override. DT is infrastructure; CL uses for theme switching."
			}]
			rationale: "Theme-agnostic 2024+. Semantic adjustment 2024+. Zero hardcoded hex = theme switching is configuration, not rewrite."
		},
		{
			id:         "cl-conditional-formatting"
			name:       "Conditional Formatting: Cor Dinâmica Baseada em Dados"
			nature:     "operational"
			role:       "method"
			reviewCadence: "quarterly"
			definition: "Apply color dynamically based on data value. Preattentive processing (Healey 1996): colored anomaly detected in <200ms vs conscious scan ~2.5s per number. For 50 rows: 600ms (conditional) vs 125s (manual). 200x efficiency. Conceito de 'threshold-based rules' (2023+): configurable per construtora: {metric, operator, value, style}. Conceito de 'multi-level formatting' (2024+): score 0-40 error, 40-60 warning, 60-80 neutral, 80-100 success. Cell communicates zone without reading number."
			meshManifestation: "Score: 0-40 error+bold, 40-60 warning, 60-80 neutral, 80-100 success. Inadimplência: <target success, approaching warning, >target error. Concentração: <70% limit neutral, 70-90% warning, >90% error+bold."
			meshImplication: "Rules as configuration (not hardcoded). ConditionalCell component: value + rules → computed style via semantic tokens. Multi-level: most severe wins. Background formatting for strong emphasis. Always pair: color + bold (redundant for CVD). Configurable per construtora (A threshold 60, B threshold 70). Anti-pattern: hardcoded threshold misleads construtora B whose policy differs."
			dependsOn: ["cl-semantic-color-system", "cl-color-independent-encoding"]
			crossDependsOn: [{
				lensId:    "lens-information-density-design"
				conceptId: "id-professional-data-tables"
				context:   "ID defines data tables. CL conditional formatting is the color layer: table structure (ID) + color encoding (CL) = scannable data-rich tables."
			}]
			rationale: "Healey 1996 preattentive. Threshold-based 2023+. Multi-level 2024+. Conditional formatting: 200x scan efficiency."
		},
		{
			id:            "cl-color-review"
			name:          "Revisão de Cor: Inventário Periódico"
			nature:        "operational"
			role:          "method"
			reviewCadence: "quarterly"
			definition:    "Inventário: (1) semantic consistency. (2) contrast WCAG. (3) color-independent encoding. (4) data palettes. (5) surfaces. (6) brand vs functional. (7) conditional formatting. (8) zero hardcoded hex."
			meshManifestation: "Revisão trimestral + monthly spot-check de contrast em nova feature."
			meshImplication: "Quarterly (1h): (a) semantic audit: trace 'success' through KPI, table, notification, chart. Any misuse? (b) contrast: 5 pairs checked. All ≥4.5:1? Secondary ≥5:1? (c) CVD simulator on 3 screens. (d) grayscale test. (e) grep hardcoded hex in components. (f) charts: any rainbow? (g) conditional rules match config? (h) brand ≤5%?"
			dependsOn: ["cl-semantic-color-system", "cl-contrast-and-wcag", "cl-color-independent-encoding", "cl-data-palettes", "cl-surface-and-elevation", "cl-brand-vs-functional-color", "cl-dark-mode-and-theming", "cl-conditional-formatting"]
			rationale: "Color meaning drifts. Quarterly audit + monthly spot-check maintains integrity."
		},
	]

	reasoningProtocol: [
		{
			question:  "Cada cor semântica tem significado fixo e consistente em TODA a plataforma?"
			reveals:   "Se cor é linguagem confiável — ou se verde às vezes é success, às vezes é info."
			rationale: "Semantic consistency 2023+. Dual meaning breaks trust."
		},
		{
			question:  "Todas combinações text-background passam WCAG AA (≥4.5:1) com margem (≥5:1)?"
			reveals:   "Se texto é legível em condições reais — ou se 'parece bom no Figma Retina.'"
			rationale: "WCAG 2.1 AA. Ambient light 2024+."
		},
		{
			question:  "Todo status tem cor + text + ícone (3 channels)? Grayscale test passa?"
			reveals:   "Se 100% dos usuários recebem informação — ou se 8% dos homens perdem."
			rationale: "WCAG 1.4.1. CVD 8% males."
		},
		{
			question:  "Paletas são perceptually uniform? Sequential por luminance? Categorical CVD-safe? Zero rainbow?"
			reveals:   "Se charts comunicam truthfully — ou se palette cria artifacts."
			rationale: "Perceptually uniform 2023+. Rainbow creates false patterns."
		},
		{
			question:  "Brand ≤5% da área visual? Distinto de semânticas? Usado apenas para identity?"
			reveals:   "Se brand e function coexistem — ou se brand invade semantic space."
			rationale: "Brand restraint B2B 2023+."
		},
		{
			question:  "Conditional formatting usa regras configuráveis com multi-level + redundant encoding?"
			reveals:   "Se tabelas são scannable via preattentive — ou se gestor lê cada número."
			rationale: "Healey 1996. Threshold-based 2023+."
		},
		{
			question:  "Todos valores de cor são tokens? Zero hex hardcoded?"
			reveals:   "Se theming é possível via config — ou se requer rewrite."
			rationale: "Theme-agnostic 2024+."
		},
	]

	meshExamples: [
		{
			id:       "ex-semantic-inconsistency-diagnosis"
			scenario: "Audit: green badge = 'qualificado' in fornecedores, 'aprovado' in operations, 'novo' in onboarding. 'Novo' is not positive. User: 'I thought novo meant approved.'"
			analysis: "Semantic violation: green = success, but 'novo' is info (neutral temporal state). User applies success meaning → incorrect assumption → trust in color broken."
			recommendation: "(1) Reclassify 'novo' → info (blue badge). (2) Complete mapping: qualificado→success, pendente→warning, inativo→neutral, rejeitado→error, novo→info, em análise→info, completo→success, expirado→error. (3) Document in design system. (4) StatusBadge component: status enum → intent pre-defined. Developer uses enum, component renders correct color. (5) Communicate change to users. (6) Validate with original reporter."
			principlesApplied: ["ax-01", "ax-06", "dp-01"]
			assumptions: ["5 intents cover all statuses — yes, edge cases resolve with classification", "blue for 'novo' is intuitive — standard info association", "users adapt quickly — brief transition"]
			rationale: "Green = success always. 'Novo' is info, not success. Fix: blue for info. Trust restored."
		},
		{
			id:       "ex-contrast-remediation"
			scenario: "Helper text under form inputs uses #aaa on white. Contrast: 2.32:1. Users can't read it in bright office."
			analysis: "#aaa on white: 2.32:1. Fails WCAG AA (4.5:1 required). In bright ambient: effectively invisible. Helper text serves first-time users most — the ones who need it can't read it."
			recommendation: "(1) Replace #aaa with #666 (5.74:1). Comfortable margin. (2) Update token: --color-text-muted: #666. All components auto-update. (3) Pre-checked matrix update. (4) CI: axe-core contrast audit every PR. (5) Margin policy: ≥5:1 for normal text. (6) Audit all muted text: placeholders, timestamps, disabled labels. Common culprits: #ccc→#888, #bbb→#777, #999→#666."
			principlesApplied: ["ax-01", "ax-04"]
			assumptions: ["#666 maintains hierarchy vs #111 primary — yes, 18.6:1 vs 5.74:1 is clear distinction", "#666 is readable 8h/day — standard B2B treatment"]
			rationale: "WCAG AA. #aaa at 2.32:1: functionally invisible. #666 at 5.74:1: comfortable margin. Token change: 15 min fix, product-wide impact."
		},
		{
			id:       "ex-heatmap-palette-redesign"
			scenario: "FIDC heatmap uses rainbow (blue→green→yellow→red). Gestor: 'sharp jump at yellow zone.' Analysis: no threshold in data — it's rainbow's perceptual artifact."
			analysis: "Rainbow: (1) yellow band has highest luminance → perceptual 'bump' regardless of data. (2) CVD-hostile (red-green indistinguishable). (3) grayscale: non-monotonic luminance."
			recommendation: "(1) Sequential white→dark red (5 steps). Luminance decreases monotonically. (2) Perceptually uniform: no false thresholds. (3) CVD-safe: luminance-based. (4) Grayscale: white→dark gray monotonic. (5) Legend with values. (6) Tooltip for exact numbers. (7) Design system: Heatmap default = sequential. No rainbow option. (8) Validate: show redesigned to gestor — false threshold gone. Real patterns still visible."
			principlesApplied: ["ax-01", "ax-06", "dp-01"]
			assumptions: ["sequential white→red aligns with 'red=danger' cultural association", "gestor won't miss rainbow's 'richness' — accuracy > aesthetics"]
			rationale: "Perceptually uniform 2023+. Rainbow created false threshold that misled analysis. Sequential: truthful. Not aesthetic preference — accuracy of risk perception."
		},
		{
			id:       "ex-conditional-formatting-configuration"
			scenario: "Construtora A: score threshold 60. Construtora B: 70. Conditional formatting hardcoded at 60. B sees score 62 as neutral (no formatting) when it's below their threshold."
			analysis: "Hardcoded threshold serves A, misleads B. Score 62 for B should be error — formatting says 'normal.' Formatting should reflect each construtora's policy."
			recommendation: "(1) Rules as config per construtora: threshold configurable. (2) Multi-level: <threshold×0.8 error+bold, threshold×0.8-threshold warning, threshold-threshold×1.2 neutral, >threshold×1.2 success. (3) A (60): <48 error, 48-60 warning, 60-72 neutral, >72 success. B (70): <56 error, 56-70 warning, 70-84 neutral, >84 success. (4) Settings UI: construtora adjusts threshold + sees impact preview. (5) FIDC portal: per-construtora formatting when drilling into specific portfolio. (6) Migration: current 60 = default. B overrides to 70."
			principlesApplied: ["ax-01", "ax-03", "ax-04"]
			assumptions: ["configurable thresholds are implementable — simple rules engine", "relative zones (80% of threshold) work — make zone boundaries configurable too"]
			rationale: "Threshold-based rules 2023+. Hardcoded formatting misleads B. Configurable serves each policy. Conditional formatting is policy visualization."
		},
	]

	principleIds: ["ax-01", "ax-02", "ax-04", "ax-06", "dp-01"]

	relatedLenses: [
		{
			lensId:   "lens-information-density-design"
			relation: "complementsWith"
			context:  "ID define dashboard composition e density. CL provê cores: KPI card uses success for positive delta, table uses conditional formatting. ID is layout; CL is meaning."
		},
		{
			lensId:   "lens-data-visualization-semiotics"
			relation: "complementsWith"
			context:  "DV define encoding visual. CL provê palettes: sequential for heatmaps, categorical for series. DV says 'encode in color'; CL says 'which colors, CVD-safe, uniform.'"
		},
		{
			lensId:   "lens-typographic-systems-for-dense-interfaces"
			relation: "complementsWith"
			context:  "TS + CL = complete hierarchy: size + weight (TS) + color (CL). Badge = xs + all-caps + medium (TS) + semantic color (CL)."
		},
		{
			lensId:   "lens-design-tokens-and-systematic-composition"
			relation: "complementsWith"
			context:  "DT tokenizes colors. CL defines meaning and values; DT encodes as tokens. CL says 'success-primary is dark green'; DT says '--color-success-primary: hsl(142,71%,29%)'."
		},
		{
			lensId:   "lens-trust-and-credibility-design"
			relation: "complementsWith"
			context:  "TC trust via consistency. CL color consistency is trust signal: consistent green = user trusts green means safe."
		},
		{
			lensId:   "lens-progressive-disclosure-and-information-architecture"
			relation: "complementsWith"
			context:  "PD layers. CL provides information scent: warning badge signals 'drill down here.' Color guides drill-down path."
		},
		{
			lensId:   "lens-interaction-patterns-for-professional-tools"
			relation: "complementsWith"
			context:  "IP feedback patterns use CL colors: success toast, error inline, loading skeleton neutral."
		},
	]

	limitations: [
		{
			description: "5 semantic intents may not classify every status cleanly. Edge: 'on hold', 'escalated', 'draft'."
			alternative: "Classify into closest: 'on hold'→warning, 'escalated'→warning, 'draft'→neutral. If genuinely new intent needed: consider carefully — each new intent dilutes memorability."
			rationale: "5 is established across major systems. Edge cases resolve with classification."
		},
		{
			description: "HSL values vary by display calibration and browser rendering."
			alternative: "Generous margins (5:1 not 4.5:1). Test on representative devices. Avoid threshold-adjacent values."
			rationale: "Design for realistic conditions. Margins absorb variation."
		},
		{
			description: "Dark mode doubles color maintenance."
			alternative: "Ship dark mode after light mode is stable. Systematic mapping (invert lightness). Automated contrast check both themes."
			rationale: "Dark mode is enhancement. Sequential: light first."
		},
		{
			description: "Configurable conditional formatting adds complexity."
			alternative: "Default thresholds (industry standard). Override per construtora. Test: default + 3 representative overrides."
			rationale: "Configurability necessary (different policies). Bounded defaults + representative testing."
		},
		{
			description: "CVD simulation tools approximate, not replicate."
			alternative: "Simulator as screening. For critical: test with actual CVD users. Redundant encoding (3 channels) covers regardless."
			rationale: "Simulation catches 90%. Redundant encoding covers 100%."
		},
	]

	rationale: "Cor em B2B fintech é linguagem funcional. Na Mesh, esta lens operacionaliza: sistema semântico com 5 intents × 3 variants e consistency enforcement (Material Design, Lightning, semantic consistency 2023+, functional color budget 2024+), contraste WCAG AA com margem ambient (WCAG 2.1, ambient light 2024+, pre-checked 2023+), encoding color-independent com 3 channels redundantes (WCAG 1.4.1, CVD 8% males, grayscale 2023+), paletas perceptually uniform CVD-safe (perceptually uniform 2023+, CVD-safe 2024+), superfícies e elevação (surface hierarchy 2023+), brand vs funcional com restraint <5% (brand restraint B2B 2023+), dark mode via theme-agnostic tokens (theme-agnostic 2024+, semantic adjustment 2024+), e conditional formatting configurável com multi-level (Healey 1996, threshold-based 2023+, multi-level 2024+). Universal como sistema de cor funcional; específica na aplicação a fintech B2B onde cor comunica risco, compliance, e status financeiro."

}
