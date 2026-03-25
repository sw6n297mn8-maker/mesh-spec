package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

pricingAndMonetizationArchitecture: artifact_schemas.#AnalyticalLens & {
id:     "lens-pricing-and-monetization-architecture"
name:   "Arquitetura de Pricing e Monetização"

purpose: "Orientar decisões sobre como precificar e monetizar — mecanismos de pricing, incentivos, value capture e alinhamento entre sides."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como a plataforma captura valor financeiro das interações que facilita",
		"a decisão envolve como precificar operações de antecipação — taxa, spread, fee structure",
		"a decisão envolve como distribuir valor entre sides da plataforma (fornecedor, construtora, FIDC, Mesh)",
		"a decisão envolve como precificar risco de forma que reflita dados proprietários e scoring",
		"a decisão envolve trade-offs entre receita por operação e volume de operações",
		"a decisão envolve como projetar pricing que escala (unit economics melhora com volume, não piora)",
		"a decisão envolve se e como cobrar por funcionalidades não-transacionais (dashboard, API, analytics)",
		"a decisão envolve como subsidiar um side para atrair outro sem distorcer economia de longo prazo",
		"a decisão envolve como competir em pricing com incumbentes (factoring, bancos, fintechs)",
		"a decisão envolve como precificação cria ou reforça comportamento desejado (volume, qualidade, retenção)",
	]
	keywords: [
		"pricing", "precificação", "preço", "taxa", "rate",
		"monetização", "monetization", "revenue", "receita",
		"spread", "take rate", "comissão", "fee",
		"unit economics", "LTV", "CAC", "margem",
		"subsídio", "subsidy", "freemium", "free tier",
		"risk-based pricing", "precificação por risco",
		"volume discount", "desconto", "tiered pricing",
		"transaction fee", "subscription", "SaaS",
		"value-based pricing", "cost-plus", "competitor-based",
		"FIDC", "retorno", "yield", "rentabilidade",
		"elasticidade", "elasticity", "sensibilidade a preço",
		"bundling", "unbundling", "cross-sell", "upsell",
	]
	excludeWhen: [
		"a decisão é sobre cold start e incentivos de bootstrap — usar cold-start-and-network-bootstrapping",
		"a decisão é sobre mecanismos de scoring e como risco é medido — usar credit-risk",
		"a decisão é sobre design de mecanismos formais (leilão, matching) — usar mechanism-design",
		"a decisão é sobre UX de plataforma multisided e tensões entre sides — usar multi-sided-platform-ux",
		"a decisão é sobre comunicação de pricing a stakeholders — usar stakeholder-communication",
	]
	rationale: "Toda plataforma precisa de modelo de monetização que capture valor proporcional ao valor criado — sem comprometer adoção, sem distorcer incentivos, e sem ser vulnerável a competição por preço. Na Mesh como intermediário financeiro B2B, pricing é existencial: a taxa de antecipação é o mecanismo de receita, o spread entre taxa do fornecedor e retorno do FIDC é o que sustenta a operação, e a relação entre risco medido (scoring) e preço cobrado (taxa) é o que cria vantagem competitiva. Se pricing é alto demais: fornecedores vão para factoring. Se baixo demais: FIDC não obtém retorno. Se não reflete risco: a carteira deteriora. CS cobre incentivos de bootstrap; CR cobre scoring; MD cobre mecanismos formais; MUX cobre tensões entre sides. Esta lens cobre a arquitetura de pricing e monetização — como capturar valor de forma sustentável, escalável, e alinhada com incentivos de todos os participantes."
}

concepts: [
	{
		id:         "pm-value-capture-architecture"
		name:       "Arquitetura de Captura de Valor: Como a Plataforma Monetiza Cada Interação"
		nature:     "theoretical"
		role:       "framework"
		definition: "Parker/Van Alstyne/Choudary (2016, Platform Revolution): plataformas capturam valor por: (1) transaction fee — % ou valor fixo por transação. (2) subscription — acesso recorrente a funcionalidades. (3) enhanced access — cobrar por visibilidade, prioridade, ou features premium. (4) licensing — cobrar por acesso a dados ou propriedade intelectual. Rochet/Tirole (2003): em plataformas multisided, pricing ótimo não é cost-plus por side — é allocation que maximiza interação total. Pode significar subsidiar side A e monetizar side B (negative price para A). Conceito contemporâneo de 'value-based pricing for platforms' (Nagle/Müller 2018, evoluído 2023+): pricing baseado no valor percebido pelo cliente, não no custo de entregar. Se Mesh reduz custo de antecipação de 4% (factoring) para 2.5%: valor criado é 1.5%. Mesh pode capturar fração desse valor. Conceito de 'take rate as platform health metric' (2022+, a16z): take rate = revenue / GMV. Marketplaces: 5-30%. Fintech: 1-5%. Take rate alto demais: desintermediação. Baixo demais: insustentável. Healthy: captura valor suficiente para sustentabilidade sem incentivar bypass."
		meshManifestation: "Na Mesh, revenue streams: (1) spread de antecipação (primary) — diferença entre taxa cobrada do fornecedor e custo de funding do FIDC. Fornecedor paga 2.5%. FIDC recebe 1.5%. Mesh retém 1.0% como spread. Take rate: ~1% do GMV (antecipações). Revenue = spread × volume. (2) fee de gestão (secondary, potencial) — construtora paga fee mensal ou por fornecedor para dashboard de gestão de cadeia. Ou: freemium (básico gratuito, premium com analytics avançado). Ou: fee embutido na operação de antecipação (construtora não paga separado — custo é subsidiado pelo spread). (3) revenue de dados (future) — benchmark de mercado, scoring-as-a-service para terceiros, analytics premium. Não viável no curto prazo — requer volume e reputação. (4) revenue de API (future) — integradores pagam por chamadas de API acima de threshold. Ou: gratuito para incentivar distribution. Value capture architecture: spread de antecipação é 80%+ da receita no curto/médio prazo. Subscription e data são opções futuras."
		meshImplication: "Projetar monetização por estágio: (1) pré-revenue → early revenue: spread de antecipação como única revenue stream. Simples, alinhado com core value (antecipação). Sem subscription. Sem API fee. Razão: cada revenue stream adicional é complexidade de billing, comunicação, e decisão. No cold start: simplicidade > diversificação. (2) tração: avaliar se fee de gestão para construtora faz sentido. Se construtora usa dashboard extensivamente mas não gera antecipações: capturar valor da gestão. Se construtora gera antecipações: gestão é lead gen para antecipação — manter gratuito. Decisão baseada em dados de uso, não em suposição. (3) escala: diversificar. API pricing para integradores de alto volume. Analytics premium. Scoring-as-a-service. Cada nova stream: ADR com rationale. (4) take rate monitoring: calcular mensal. Revenue / GMV = take rate. Target: 0.8-1.5% de GMV. Se >2%: overpricing (risco de desintermediação). Se <0.5%: insustentável. (5) value-based ceiling: fornecedor compara com alternativa (factoring ~4%). Mesh a 2.5%: saving de 1.5pp. Mesh captura ~1pp como spread. Fornecedor retém ~0.5pp de saving. Se Mesh captura 100% do saving (taxa = factoring): zero incentivo para migrar. Rule: fornecedor deve reter pelo menos 50% do saving (taxa Mesh ≤ midpoint entre Mesh cost e factoring). Anti-pattern: cobrar subscription + take rate + API fee + premium simultaneamente de mesmos participantes no early-stage — overmonetization que afugenta antes de hábito."
		rationale: "Parker et al. 2016: monetização de plataformas. Rochet/Tirole 2003: pricing multisided. Nagle/Müller 2018: value-based. Take rate a16z 2022+. Na Mesh, spread de antecipação é o modelo natural e alinhado — monetiza a interação core (antecipação) sem cobrar por ferramentas que atraem (dashboard, API)."
	},
	{
		id:         "pm-risk-based-pricing"
		name:       "Pricing Baseado em Risco: Precificar o que Scoring Revela"
		nature:     "theoretical"
		role:       "framework"
		definition: "Conceito fundamental de credit pricing: taxa deve refletir risco — comprador com mais risco paga mais porque probabilidade de default é maior. Componentes de taxa: (1) funding cost — custo de capital do FIDC (CDI + spread de captação). (2) expected loss — probabilidade de default × loss given default (LGD). (3) operational cost — custo de originar, validar, liquidar. (4) margin — spread de lucro da plataforma. Taxa = funding cost + expected loss + operational cost + margin. Conceito contemporâneo de 'data-driven pricing advantage' (2023+): plataforma com dados proprietários precifica risco com mais precisão que incumbente — menor expected loss para bons compradores (taxa menor → atrai volume) e maior expected loss para maus compradores (taxa maior → protege carteira). Vantagem competitiva: scoring proprietário permite pricing que incumbente com dados públicos não consegue replicar. Conceito de 'adverse selection in pricing' (Akerlof 1970, aplicado a credit 2022+): se plataforma não discrimina por risco: atrai compradores de alto risco (que encontram taxa melhor que em outros lugares) e repele compradores de baixo risco (que encontram taxa melhor no banco). Resultado: carteira concentra em alto risco. Risk-based pricing previne adverse selection."
		meshManifestation: "Na Mesh, decomposição de taxa para operação de R$50k com comprador de score 75 (médio-baixo risco): (1) funding cost: CDI + 2% (custo do FIDC) = ~12.5% a.a. = ~1.5% para 45 dias. (2) expected loss: PD (probabilidade de default para score 75) × LGD (loss given default ~40%). Se PD = 3%: expected loss = 3% × 40% = 1.2%. Para 45 dias: ~0.15%. (3) operational cost: processamento, validação, compliance, infraestrutura. ~0.3% por operação. (4) margin: 0.5-1.0%. Taxa total: 1.5% + 0.15% + 0.3% + 0.7% ≈ 2.65%. Para comprador de score 90 (baixo risco): PD = 0.5%, expected loss = 0.03%. Taxa: 1.5% + 0.03% + 0.3% + 0.7% ≈ 2.53%. Diferença: comprador melhor = taxa menor. Vantagem competitiva: factoring precifica todos a ~4% (não discrimina por risco). Mesh precifica bom comprador a 2.5% e mau comprador a 3.5%. Bom comprador migra para Mesh (taxa melhor). Mau comprador fica no factoring (taxa similar ou pior). Mesh atrai bons compradores → inadimplência baixa → FIDC feliz."
		meshImplication: "Pricing engine: (1) fórmula de taxa: taxa = funding_cost + expected_loss(score) + operational_cost + margin. Cada componente é configurável e auditável. Expected_loss é função do score — curva calibrada com dados reais. (2) pricing table: não free-form pricing por operação. Tabela de preço por faixa de score × prazo × volume. Publicável (transparência). Auditável (regulador pode verificar). Consistente (mesma situação = mesmo preço). (3) dynamic vs static: início: pricing table estática (atualizada mensalmente). Tração: pricing engine dinâmica que recalcula com dados atualizados (funding cost muda com Selic, expected loss muda com inadimplência observada). (4) pricing floor and ceiling: floor: taxa mínima que cobre custos (funding + operational + margin mínima). Se taxa < floor: operação é unprofitable. Ceiling: taxa máxima competitiva (se > factoring: fornecedor não migra). Se floor > ceiling: segmento não é viável (custo de funding alto demais para taxa competitiva). (5) transparência de pricing: fornecedor vê taxa final antes de confirmar. Decomposição simplificada disponível on-demand: 'sua taxa de 2.5% reflete: custo de capital + risco do comprador + custos operacionais.' Não revelar fórmula exata (IP). Revelar fatores que influenciam (score, prazo, volume). (6) feedback loop: se scoring melhora (AUROC sobe): expected loss é estimado com mais precisão → taxa pode ser mais agressiva para bons compradores → mais volume → mais dados → scoring melhora (dq-data-flywheel). Pricing é onde data moat se traduz em vantagem competitiva tangível. Anti-pattern: taxa flat para todos os compradores (não discrimina risco) — atrai adverse selection e desperdiça vantagem de scoring."
		dependsOn: ["pm-value-capture-architecture"]
		crossDependsOn: [
			{
				lensId:    "lens-credit-risk"
				conceptId: "cr-expected-loss-model"
				context:   "CR modela PD, LGD e expected loss para scoring. PM usa expected loss como input de pricing. CR é o modelo de risco; PM é a tradução de risco em preço. CR diz 'PD para score 75 é 3%'; PM diz 'expected loss é 1.2% → taxa inclui 0.15% de expected loss para 45 dias'. Sem CR: pricing é guess. Com CR: pricing é risk-adjusted."
			},
			{
				lensId:    "lens-data-quality-as-competitive-moat"
				conceptId: "dq-data-flywheel"
				context:   "DQ data flywheel gera dados que melhoram scoring. PM traduz scoring melhor em pricing mais preciso. O flywheel se completa: mais dados → scoring melhor → pricing mais competitivo → mais volume → mais dados. PM é o estágio do flywheel onde vantagem de dados se traduz em vantagem de mercado. DQ é o combustível; PM é o output visível."
			},
		]
		rationale: "Credit pricing fundamental. Data-driven pricing advantage 2023+. Adverse selection Akerlof 1970. Na Mesh, risk-based pricing é o mecanismo que traduz scoring proprietário em vantagem competitiva — comprador bom recebe taxa melhor que no factoring (Mesh ganha volume), comprador ruim recebe taxa alta ou rejeição (Mesh protege carteira)."
	},
	{
		id:         "pm-unit-economics"
		name:       "Unit Economics: Cada Operação Sustenta o Negócio?"
		nature:     "operational"
		role:       "property"
		reviewCadence: "monthly"
		definition: "Unit economics: receita e custo por unidade de transação. Em plataformas financeiras: (1) revenue per operation — spread × valor. (2) cost per operation — funding cost + expected loss + operational cost (origination, validation, compliance, serving, monitoring). (3) contribution margin — revenue − variable costs. (4) LTV — lifetime value de participante (total de contribution margin ao longo da relação). (5) CAC — custo de aquisição de participante. LTV/CAC ratio — target >3x para sustentabilidade. Conceito contemporâneo de 'unit economics by cohort' (2022+): medir unit economics por cohort (mês de entry) para ver se melhora com maturidade do produto. Cohort mês 1: LTV/CAC = 1.5x (pré-otimização). Cohort mês 12: LTV/CAC = 4x (scoring melhor + taxa otimizada + retenção melhor). Melhoria por cohort = evidência de flywheel. Conceito de 'contribution margin escalation' (2023+): em plataformas com data flywheel, contribution margin melhora com escala: expected loss diminui (scoring melhora), operational cost per operation diminui (automação), funding cost pode diminuir (FIDC confia mais, aceita spread menor). Volume é alavanca de margem."
		meshManifestation: "Na Mesh, unit economics por operação (exemplo: R$50k, 45 dias, score 75): (1) revenue: spread 1.0% × R$50k = R$500. (2) variable costs: funding cost: 1.5% × R$50k = R$750 (pago ao FIDC — não é custo da Mesh, é custo do capital). Expected loss provision: 0.15% × R$50k = R$75 (provisão para default). Operational cost: origination + validation + compliance + serving ≈ R$50/operação (estimativa). (3) contribution margin per operation: R$500 − R$75 − R$50 = R$375. Contribution margin %: 75% do revenue. (4) por fornecedor: se fornecedor faz 3 operações/mês × R$50k × 12 meses = R$1.8M de volume. Revenue: R$18k. Contribution: ~R$13.5k. LTV (3 anos): ~R$40k. (5) CAC: se founder-led (10h de esforço para construtora que traz 10 fornecedores): CAC = 10h × cost/hour / 10 fornecedores. Se custo/hora do founder = R$300: CAC = R$300/fornecedor. LTV/CAC = R$40k / R$300 = 133x. Excelente — mas reflete que CAC é artificially low (founder time not fully loaded). (6) por cohort: cohort mês 1 (scoring com bureau only, taxa 3.0%): contribution margin = R$450. Cohort mês 12 (scoring proprietário, taxa 2.5%): contribution margin = R$375 mas volume per fornecedor é 2x (retenção melhor + frequency maior). Net: contribution por fornecedor melhora."
		meshImplication: "Monitorar unit economics mensalmente: (1) por operação: revenue, expected loss provision, operational cost, contribution margin. Trend: contribution margin improving ou degrading? Se degrading: custo cresceu (operational) ou expected loss cresceu (inadimplência) ou spread comprimiu (pricing pressure). (2) por fornecedor: operations per month, average ticket, contribution per month, churn risk. Segmentar: high-value (>R$100k/mês, high frequency) vs low-value (<R$10k/mês, infrequent). Investir em retenção de high-value. (3) por construtora: fornecedores ativos, volume total, contribution total. Construtora que traz 30 fornecedores ativos com R$500k/mês de volume: most valuable. (4) LTV/CAC por canal: founder-led CAC vs referral CAC vs developer channel CAC. Se developer channel CAC é R$50/fornecedor (ERP distribui) vs founder-led R$300: developer channel é 6x mais eficiente. Investir em DX. (5) break-even analysis: quantas operações por mês para cobrir fixed costs (infra, salário, ferramentas)? Se fixed costs = R$30k/mês e contribution per operation = R$375: break-even = 80 operações/mês. (6) sensitivity: se inadimplência sobe de 3% para 6%: expected loss dobra. Contribution margin cai 10%. Se funding cost sobe 1%: contribution margin cai 20%. Qual variável é mais sensitive? Funding cost > inadimplência > operational cost. Anti-pattern: não calcular unit economics porque 'estamos em growth mode' — operação que perde dinheiro por operação não se torna lucrativa com volume (a menos que costs per operation decreasem com scale, o que precisa ser demonstrado)."
		dependsOn: ["pm-value-capture-architecture", "pm-risk-based-pricing"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-opportunity-cost"
			context:   "ORA modela custo de oportunidade de recurso alocado. PM unit economics informa ORA: se contribution margin per operation é R$375, e founder-hour de engineering vale R$300: cada hora de engineering que melhora operational efficiency (reduz R$50→R$30 per operation) gera R$20/op × volume. ORA diz 'investir onde ROI é máximo'; PM quantifica ROI de cada melhoria operacional."
		}]
		rationale: "Unit economics fundamental. Cohort analysis 2022+. Contribution margin escalation 2023+. Na Mesh, unit economics por operação é a métrica que determina se o negócio é sustentável — sem isso, growth é venture-subsidized, não self-sustaining."
	},
	{
		id:         "pm-competitive-pricing-positioning"
		name:       "Posicionamento Competitivo de Pricing: Vencer Sem Competir por Preço"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Porter (1980, Competitive Strategy): competição por preço é race to bottom — margem comprime até que ninguém é lucrativo. Alternativa: differentiation pricing — preço premium justificado por valor superior que alternativa não oferece. Conceito de 'total cost of ownership' (TCO) vs 'sticker price' (2022+): em B2B, preço anunciado (taxa de 3.5%) não é custo real. Custo real inclui: taxa + IOF + TAC + custos operacionais + tempo + risco de processo burocrático. Mesh pode ter taxa nominal de 2.5% vs factoring 3.5%, mas se total cost do factoring é 4.5% (taxa + IOF + TAC + tempo): saving real é 2.0%, não 1.0%. Conceito contemporâneo de 'price anchoring in fintech' (2023+): posicionar preço contra âncora mental do cliente. Se fornecedor ancora em 'factoring cobra 3.5%': Mesh a 2.5% parece bom. Se fornecedor ancora em 'banco cobra 1.5% ao mês para linha de capital de giro': Mesh a 2.5% parece caro. Controlar a âncora via comunicação. Conceito de 'competitive pricing moat' (2024+): pricing baseado em dados proprietários que competidor não pode replicar — scoring melhor = expected loss menor = taxa menor para bons compradores = atrai melhores clientes = dados melhores = scoring melhor. Loop que se auto-reforça."
		meshManifestation: "Na Mesh, posicionamento competitivo: (1) vs factoring tradicional — factoring: taxa 3.5-5.0% + IOF ~0.38% + TAC ~R$200 + burocracia (3-5 dias, documentação física). TCO: ~4.5-6.0%. Mesh: taxa 2.0-3.0% + zero IOF (cessão) + zero TAC + digital (<24h). TCO: 2.0-3.0%. Saving real: 2.0-3.0pp. Posicionamento: 'custo total até 50% menor que factoring.' (2) vs banco (antecipação de recebíveis bancária) — banco: taxa 1.5-2.5%/mês + burocracia + limite de crédito restritivo. Mesh: taxa 2.0-3.0% para 45 dias (≈1.3-2.0%/mês) + digital + sem limite restritivo. Competitivo em taxa para PME (que não consegue boas condições no banco). (3) vs fintech de recebíveis — outras fintechs: taxa similar mas sem gestão de cadeia, sem scoring proprietário, sem network effects. Mesh differentiator: taxa risk-based (melhor para bons compradores) + gestão de cadeia integrada + dados que melhoram com uso. (4) pricing advantage from data moat: à medida que scoring melhora (dq-data-flywheel): Mesh pode cobrar taxa menor para bons compradores mantendo margem → atrai volume de baixo risco → inadimplência cai → FIDC feliz → pode aceitar spread menor → taxa pode ser ainda menor. Loop virtuoso."
		meshImplication: "Posicionamento por dimensão: (1) comunicar TCO, não taxa — simulador que mostra: 'custo total com factoring: R$2.250 (taxa + IOF + TAC). Custo total com Mesh: R$1.250. Economia: R$1.000 por operação.' Tangível. (2) anchor against factoring — factoring é a alternativa mais provável para PME (banco é difícil de acessar). Posicionar Mesh como 'alternativa digital ao factoring, não ao banco.' Evitar comparação com banco (perde em taxa). Ganhar na comparação com factoring (ganha em taxa + experiência + velocidade). (3) differentiation beyond price — mesmo se taxa fosse igual ao factoring: Mesh oferece transparência (taxa visível antes), velocidade (<24h vs 3-5 dias), experiência digital (sem papelada), gestão de cadeia para construtora (valor adicional). Preço é condição necessária; diferenciação é o que retém. (4) não competir em price war — se competidor oferece taxa 0.5% menor: não igualar reflexivamente. Investigar: é sustentável? Se sim (funding cost menor): competir por diferenciação. Se não (subsídio para growth): esperar que subsídio acabe. Subsidiar taxa para igualar queima cash sem construir vantagem. (5) pricing transparency como differentiator — 'nossa taxa é transparente: 2.5%. Sem IOF. Sem TAC. Sem taxa escondida.' Comparar com factoring que tem 3 linhas de custo que o fornecedor não entende. Transparência é trust signal (tc-trust-architecture: integrity) e competitive positioning simultaneamente. Anti-pattern: competir por taxa mais baixa sem vantagem estrutural de custo — race to bottom que destrói margem."
		dependsOn: ["pm-value-capture-architecture", "pm-risk-based-pricing"]
		crossDependsOn: [{
			lensId:    "lens-stakeholder-communication"
			conceptId: "sc-audience-specific-framing"
			context:   "SC define framing por audiência. PM competitive positioning usa framing: para fornecedor, frame é 'custo total 50% menor que factoring.' Para FIDC: 'carteira com scoring proprietário e inadimplência <2%.' Para investidor: 'take rate de 1% em mercado de R$50B/ano de antecipação em construção civil.' SC é o framework; PM é o conteúdo de pricing que precisa ser framed diferentemente."
		}]
		rationale: "Porter 1980: differentiation vs cost. TCO 2022+. Price anchoring 2023+. Competitive pricing moat 2024+. Na Mesh, vencer o factoring em TCO (2.5% vs 4.5%) é condição necessária. Vencer por experiência + transparência + dados é o que cria defensibilidade — competidor pode igualar taxa mas não pode replicar scoring + rede + experiência simultaneamente."
	},
	{
		id:         "pm-subsidy-monetization-balance"
		name:       "Equilíbrio Subsídio-Monetização: O Que Dar de Graça e O Que Cobrar"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Eisenmann et al. (2006): em plataformas multisided, subsidy side (side gratuito ou abaixo do custo) gera network que atrai money side (side que paga). Decisão: quem subsidiar e quem monetizar. Anderson (2009, Free: The Future of a Radical Price): 4 modelos de 'free': (1) freemium — versão gratuita com upgrade pago. (2) advertising — gratuito para user, pago por advertiser. (3) cross-subsidy — produto A gratuito subsidizado por produto B pago. (4) gift economy — gratuito por razões não-monetárias. Conceito contemporâneo de 'free as growth lever, not as business model' (2023+): gratuito é tática de aquisição, não modelo de receita. Tudo gratuito = sem negócio. Tudo pago = sem growth. O equilíbrio é: gratuito o que atrai e retém (network building), pago o que extrai valor (monetização)."
		meshManifestation: "Na Mesh, o que é gratuito e o que é pago: (1) gratuito (subsidy) — dashboard de gestão de cadeia para construtora (single-player mode, atrai hard side). API access para integradores (atrai distribution channel). Qualificação básica de fornecedores (gera dados). Documentação e sandbox (habilita integração). Rationale: cada item gratuito atrai participante que gera valor monetizável downstream. (2) pago (monetização) — spread de antecipação (core revenue). Cada operação de antecipação gera receita. (3) potencialmente pago (future) — analytics premium para construtora (insights avançados de cadeia). Scoring-as-a-service para fintechs. API high-volume pricing (acima de threshold gratuito). Relatórios customizados para FIDC. (4) nunca pago — signup, onboarding, suporte básico. Cobrar por acesso básico em cold start = barreira de adoção desnecessária."
		meshImplication: "Framework de decisão gratuito vs pago: (1) para cada funcionalidade: perguntar — 'se cobrar: quantos participantes não usariam? Se não usar: quanto de valor network é perdido?' Se muitos não usariam e valor de rede é alto (dashboard de construtora): gratuito. Se poucos não usariam e valor direto é alto (antecipação): pago. (2) cross-subsidy natural: dashboard gratuito (custo: hosting + dev) → construtora engajada → fornecedores da construtora antecipam → spread de antecipação (revenue). Dashboard é custo de R$X/mês que gera revenue de R$Y/mês via antecipações. Se Y >> X: subsídio é investimento com ROI positivo. Medir: contribution margin de construtora que usa dashboard vs construtora que não usa. Se dashboard users geram 2x mais antecipações: subsídio se paga. (3) freemium para analytics de construtora: basic (gratuito): fornecedores qualificados, compliance status, volume de operações. Premium (pago): tendências, benchmark vs mercado, projeções, custom reports. Monetizar quando construtora demonstra willingness to pay (usa basic extensivamente e pede mais). Não prematuramente (antes de product-market fit de analytics). (4) API pricing: gratuito até N chamadas/mês (generoso o suficiente para POC e small integrators). Pago acima de N: volume pricing proporcional. Threshold: definir quando existirem integradores que ultrapassam. Não criar pricing table para API antes de ter 10 integradores (premature optimization). (5) regra de transição: quando converter gratuito em pago? Quando: (a) participante demonstrou willingness to pay (pediu feature premium). (b) custo de servir gratuito impacta sustentabilidade. (c) mercado validou que feature é premium (benchmarking vs concorrentes). Não converter porque 'precisamos de revenue' se conversão afugenta participantes que geram network value. Anti-pattern: cobrar por dashboard de gestão no cold start — afugenta construtora (hard side) que traria 20 fornecedores (monetizáveis via spread)."
		dependsOn: ["pm-value-capture-architecture"]
		crossDependsOn: [{
			lensId:    "lens-cold-start-and-network-bootstrapping"
			conceptId: "cs-bootstrap-incentives"
			context:   "CS define incentivos de bootstrap (dashboard gratuito, taxa reduzida). PM define quando e como transicionar de subsídio para monetização. CS é a tática de aquisição; PM é a arquitetura de long-term monetização. CS diz 'dashboard gratuito para atrair construtora'; PM diz 'dashboard gratuito é cross-subsidy que se paga via spread de antecipações — custo de hosting << revenue gerada pelos fornecedores da construtora'."
		}]
		rationale: "Eisenmann et al. 2006: subsidy side vs money side. Anderson 2009: Free. Free as growth lever 2023+. Na Mesh, dashboard gratuito para construtora é o investimento de aquisição mais eficiente: custo baixo, valor alto para construtora (standalone), e gera rede que monetiza via spread."
	},
	{
		id:         "pm-pricing-behavioral-effects"
		name:       "Efeitos Comportamentais do Pricing: Preço Como Mecanismo de Incentivo"
		nature:     "theoretical"
		role:       "property"
		definition: "Pricing não é apenas captura de valor — é sinal que influencia comportamento. Thaler/Sunstein (2008, Nudge): pricing architecture é choice architecture — como opções são apresentadas afeta decisão. Conceito de 'pricing as incentive mechanism' (2022+): pricing pode incentivar comportamento desejado: (1) volume discount — taxa menor para mais operações incentiva concentrar na plataforma. (2) loyalty pricing — taxa que melhora com tempo incentiva retenção. (3) quality premium — taxa menor para compradores com bom perfil incentiva manutenção de compliance. (4) timing incentive — taxa menor para antecipação programada vs urgente incentiva previsibilidade. Conceito contemporâneo de 'dynamic pricing in B2B' (2023+): pricing que ajusta em real-time baseado em condições de mercado, risco, e volume. Mais sofisticado que tabela estática. Requer dados e engine. Conceito de 'price framing effects' (Kahneman/Tversky 1979, prospect theory): como preço é apresentado afeta percepção. 'Taxa de 2.5%' vs 'você recebe R$48.750 de R$50.000' — segundo é loss frame (perda de R$1.250), primeiro é percentage frame (2.5% parece abstrato). Testar qual framing gera melhor conversão."
		meshManifestation: "Na Mesh, pricing como incentivo: (1) risk-based como quality incentive — comprador que paga em dia → score sobe → taxa da próxima operação cai. Comprador que atrasa → score cai → taxa sobe. Pricing recompensa bom comportamento e penaliza mau. Comunicar: 'taxa do seu comprador melhorou de 2.8% para 2.3% porque ele manteve pagamentos em dia.' (2) volume como incentivo de concentração — fornecedor que faz >R$200k/mês de antecipação: taxa preferencial (−0.2pp). Incentiva concentrar operações na Mesh (vs dividir entre Mesh e factoring). (3) retention como incentivo de lealdade — fornecedor com >6 meses de uso contínuo: taxa reduzida (−0.1pp). Switching cost informacional (dq-data-flywheel) + taxa melhor = double incentive para ficar. (4) framing: apresentar taxa como benefício relativo ('você economiza R$1.000 comparado com factoring') mais que como custo absoluto ('taxa de R$1.250'). Simulador que mostra economia, não apenas custo."
		meshImplication: "Pricing como behavior design: (1) risk-based core — taxa é função de score. Score melhora com bom comportamento de comprador. Comunicar loop: bom comportamento → score melhor → taxa menor → mais saving. (2) volume tier (quando escala justificar) — tier 1 (<R$100k/mês): taxa standard. Tier 2 (R$100k-500k): −0.2pp. Tier 3 (>R$500k): −0.3pp. Tiers simples (3 max). Comunicar claramente. Não criar 10 tiers que ninguém entende. (3) implementar tiers apenas quando: há volume suficiente para tier 2/3 existir (>10 fornecedores no tier 2). Antes disso: taxa uniforme (risk-based) é suficiente. (4) framing — simulador na interface: 'operação de R$50k, prazo 45 dias. Taxa Mesh: 2.5% (R$1.250). Economia vs factoring: R$1.000. Você recebe: R$48.750.' Foco em: economia (gain frame) e valor recebido (concrete). Não foco em: taxa como perda. (5) no hidden fees — transparência total é pricing behavioral effect positivo. Fornecedor que confia que 2.5% é o custo real (sem IOF, TAC, taxa escondida) tem anxiety menor e conversion maior. (6) A/B test de framing — testar: economia vs custo como primary message. Percentual vs absoluto. Diferentes copy no simulador. Medir: conversion rate por framing. Iterar. Anti-pattern: pricing que é tão complexo que fornecedor precisa de calculadora para entender — cognitive friction que mata conversão."
		dependsOn: ["pm-risk-based-pricing", "pm-competitive-pricing-positioning"]
		crossDependsOn: [{
			lensId:    "lens-behavioral-economics"
			conceptId: "be-framing-effects"
			context:   "BE modela framing effects (gain vs loss, anchoring, prospect theory). PM aplica: pricing presented como economia vs custo, ancorado contra factoring, com percentual vs absoluto. BE é a teoria comportamental; PM é a aplicação em pricing. BE diz 'loss aversion faz R$1.250 de custo parecer pior que R$1.000 de economia, mesmo sendo a mesma operação'; PM diz 'apresentar como economia no simulador'."
		}]
		rationale: "Thaler/Sunstein 2008: choice architecture. Pricing as incentive 2022+. Kahneman/Tversky 1979: prospect theory. Na Mesh, pricing não é apenas captura — é mecanismo que incentiva volume (tiers), qualidade (risk-based), retenção (loyalty), e conversão (framing)."
	},
	{
		id:         "pm-fidc-return-alignment"
		name:       "Alinhamento de Retorno com FIDC: O Lado que Provê Capital"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "quarterly"
		definition: "Em plataforma de intermediação financeira, o funding provider (FIDC) é stakeholder cujo retorno determina sustentabilidade. Se FIDC não obtém retorno atrativo: capital sai, operação para. Conceito de 'funding cost management' (2022+): custo de capital para a plataforma depende de: (1) taxa de captação do FIDC (CDI + spread). (2) inadimplência da carteira (consumida do spread). (3) volume e diversificação (carteira concentrada = risco maior = spread maior). Conceito contemporâneo de 'alignment via information' (2023+): FIDC aceita spread menor se tem confiança no scoring (informação reduz incerteza → menor prêmio de risco). Scoring proprietário com track record: 'inadimplência observada é 1.8% vs projetada de 2.0%' — FIDC vê que modelo funciona → aceita spread menor → taxa pode ser menor para fornecedor. Information alignment: mais informação → melhor alinhamento → melhor pricing para todos."
		meshManifestation: "Na Mesh, relação com FIDC: (1) retorno target do FIDC — CDI + 3-5% ao ano (benchmark de FIDC de recebíveis). Se CDI = 12%: retorno target ~15-17% a.a. Para operações de 45 dias: ~1.8-2.1% por operação. Se Mesh cobra 2.5% do fornecedor e FIDC recebe 1.5-1.8%: spread de Mesh = 0.7-1.0%. (2) inadimplência como variável — se inadimplência real é 1.5%: FIDC retém 0.3-0.6% após perdas. Se inadimplência sobe para 4%: retorno comprime → FIDC insatisfeito → pode exigir spread maior → taxa sobe para fornecedor. (3) transparência como alinhamento — relatório mensal de carteira com: lastro, inadimplência, concentração, performance por safra, projeção (dm-semantic-layer). FIDC que vê dados confiáveis tem menos incerteza → aceita spread menor. (4) scoring como trust mechanism — FIDC vê: 'AUROC do modelo: 0.76. Inadimplência projetada: 2.0%. Observada: 1.8%. Modelo conservador.' → FIDC confia → aceita spread menor."
		meshImplication: "Gestão de relação econômica com FIDC: (1) reporting mensal — relatório automático (dm-data-modeling-review) com métricas definidas na semantic layer. Consistente, auditável, sem manipulação. (2) alignment incentives — se inadimplência é menor que projetada: Mesh pode: (a) reduzir taxa para fornecedor (mais competitivo). (b) aumentar spread de Mesh (mais margem). (c) split o upside com FIDC (incentiva FIDC a continuar). Decisão: proporcional — 50% para taxa menor (growth) + 25% para Mesh (sustentabilidade) + 25% para FIDC (alinhamento). Não capturar 100% do upside — FIDC é parceiro, não adversário. (3) stress testing — quarterly: simular cenários de inadimplência (2%, 4%, 6%, 8%). Em cada cenário: retorno do FIDC, margem da Mesh, taxa para fornecedor. Se cenário de 6% (worst case razoável) torna operação inviável: pricing model precisa de buffer. (4) diversificação como risk reduction — FIDC com carteira diversificada (múltiplas construtoras, múltiplos segmentos): risco menor → aceita spread menor. Concentração (80% em 1 construtora): risco alto → spread alto. Mesh deve diversificar rede para reduzir custo de funding. (5) FIDC competition (futuro) — com track record e volume: múltiplos FIDCs competem para participar. Competição de funding reduz custo → taxa pode ser menor → mais competitivo. Não depender de 1 FIDC indefinidamente. Anti-pattern: maximizar spread de Mesh sem considerar retorno do FIDC — FIDC insatisfeito sai, operação para. FIDC é partner, não supplier genérico."
		dependsOn: ["pm-risk-based-pricing", "pm-unit-economics"]
		crossDependsOn: [{
			lensId:    "lens-stakeholder-communication"
			conceptId: "sc-trust-accumulation"
			context:   "SC modela trust como ativo que acumula com consistência. PM FIDC alignment é trust quantificada: relatório consistente + inadimplência conforme projetada + transparência total = trust que permite spread menor. SC diz 'consistência constrói trust'; PM diz 'FIDC que vê 12 meses de inadimplência conforme projetada aceita spread 0.3% menor — trust se traduz em pricing advantage'."
		}]
		rationale: "Funding cost management 2022+. Alignment via information 2023+. Na Mesh, FIDC é o side que provê capital — retorno adequado é pré-condição existencial. Scoring que performa conforme prometido é o que permite retorno adequado com taxa competitiva para fornecedor. Tudo converge: scoring melhor → inadimplência menor → FIDC aceita spread menor → taxa menor → mais volume → mais dados → scoring melhor."
	},
	{
		id:         "pm-pricing-evolution"
		name:       "Evolução de Pricing: Como o Modelo de Preço Muda com Maturidade"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Conceito de 'pricing maturity model' (2023+): pricing evolui com estágio da empresa. (1) Early (pré-PMF) — pricing simples, possivelmente manual, focado em validar willingness-to-pay. (2) Growth — pricing engine automatizada, risk-based, com tiers. (3) Scale — dynamic pricing, personalizado, multi-product. Conceito de 'pricing as experiment' (2022+): pricing é hipótese — não é fixo. Testar: taxa 2.3% vs 2.5% vs 2.7% para ver impacto em volume. Se elasticidade é alta (−1% de taxa = +30% de volume): otimizar para volume. Se baixa (−1% = +5%): otimizar para margem. Conceito contemporâneo de 'pricing for multi-product platform' (2024+): quando plataforma tem múltiplos produtos (antecipação, gestão de cadeia, analytics, API): pricing architecture define como produtos se relacionam — bundle (desconto por usar múltiplos), unbundle (pagar por cada um separadamente), ou cross-subsidy (um gratuito, outro pago)."
		meshManifestation: "Na Mesh, evolução por estágio: (1) pré-revenue — taxa manual (founder define por operação com base em benchmark + margem). Pricing table simples: taxa por faixa de prazo. Sem tiers, sem dynamic. Objetivo: validar que fornecedores pagam e FIDC obtém retorno. (2) early revenue — pricing engine: taxa = f(score, prazo, funding cost). Automatizada. Publicável. Consistente. Risk-based. Sem tiers de volume (volume muito baixo para segmentar). (3) tração — volume tiers (3 níveis). Loyalty discount (>6 meses). Dynamic funding cost (atualiza com Selic/CDI). Pricing experiments (A/B de taxa marginal). (4) escala — dynamic pricing personalizado por operação. Multi-FIDC (competição de funding). Multi-product pricing (antecipação + gestão premium + API + scoring-as-a-service). Bundle: construtora que usa gestão + antecipação paga taxa 0.2% menor."
		meshImplication: "Evolução disciplinada: (1) cada estágio tem pricing architecture proporcional. Não implementar dynamic pricing com 100 operações — overhead sem benefício. Não manter taxa manual com 10.000 operações — inconsistência e erro humano. (2) pricing experiments — quando volume permite (>500 operações/mês): testar variações. A/B: 10% das operações com taxa +0.2%, 10% com −0.2%, 80% baseline. Medir: conversion rate, volume, revenue. Se −0.2% gera +25% volume: receita total é maior. Se −0.2% gera +5% volume: margem é mais importante. (3) elasticidade por segmento — fornecedores podem ter elasticidade diferente: PME (sensível a preço, volume sensível a taxa) vs médio (menos sensível, valor é conveniência). Pricing pode diferir por segmento quando dados permitem segmentar. (4) multi-product (escala): definir relação entre produtos: (a) gestão de cadeia: gratuito (cross-subsidy por antecipação). (b) analytics premium: subscription para construtora que quer insights avançados. (c) API: gratuito até threshold, pago acima. (d) scoring-as-a-service: pricing por consulta para fintechs externas. (e) bundle: construtora que usa gestão + antecipação: −0.2% na taxa. Incentiva uso de ambos. (5) communication de mudança de pricing: qualquer mudança de preço comunicada com 30 dias de antecedência para participantes afetados. Rationale explicado. Mudança retroativa: nunca (operações existentes mantêm preço original). (6) ADR para cada decisão de pricing: 'taxa padrão definida como [X]% para score 70-80, prazo 30-60 dias. Rationale: competitivo com factoring (4.5%), retorno adequado para FIDC (CDI+4%), margem sustentável (0.8%).' Anti-pattern: mudar preço sem comunicar — fornecedor descobre na hora de submeter e perde trust."
		dependsOn: ["pm-value-capture-architecture", "pm-risk-based-pricing", "pm-unit-economics"]
		crossDependsOn: [{
			lensId:    "lens-real-options"
			conceptId: "ro-experimentation-as-option"
			context:   "RO modela experimentação com gates. PM pricing evolution usa RO: cada mudança de pricing é opção exercida com evidência (A/B test, elasticidade medida). Não mudar pricing por gut feeling — mudar por dado. RO preserva opcionalidade (podemos adicionar tiers quando volume justificar); PM exerce quando evidência confirma."
		}]
		rationale: "Pricing maturity 2023+. Pricing as experiment 2022+. Multi-product pricing 2024+. Na Mesh, pricing evolui de manual (founder decide) para engine (algoritmo decide) para dynamic (mercado + dados decidem). Cada estágio com complexidade proporcional ao volume e à sofisticação necessária."
	},
	{
		id:            "pm-pricing-review"
		name:          "Revisão de Pricing: Inventário Periódico de Preços, Margens e Competitividade"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) revenue — GMV, take rate, revenue total, revenue per operation. Trend. (2) risk-based pricing — taxa por faixa de score. Correlação scoring→taxa→inadimplência. Pricing reflecte risco real? (3) unit economics — contribution margin per operation, LTV/CAC, break-even. Improving by cohort? (4) competitive — pricing vs factoring, banco, fintechs. Still competitive? (5) subsidy — custo de itens gratuitos vs revenue gerada. Cross-subsidy ROI. (6) behavioral — volume por tier, retenção por faixa de taxa, framing effectiveness. (7) FIDC — retorno realizado vs target. Inadimplência vs projetada. Stress test. (8) evolution — pricing engine adequada ao estágio? Próxima evolução necessária?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: unit economics e revenue. Trimestral: competitive analysis + FIDC alignment + pricing experiments."
		meshImplication: "Mensal (30min): revenue — GMV, take rate, contribution margin per operation. Trend up/down? Se margin compressing: investigar (custo subiu? inadimplência subiu? taxa caiu?). Unit economics — LTV/CAC por canal. Improving? Pricing vs inadimplência — taxa reflete risco real? Se score 70 tem taxa 2.5% mas inadimplência é 5%: expected loss underestimated. Ajustar. Trimestral (2h): competitive — survey de taxa de factoring (3-5 fatores). Mesh ainda competitiva? Se gap comprimiu: why? FIDC alignment — retorno realizado vs target. Stress test com inadimplência simulada. FIDC satisfeito? Subsidy ROI — dashboard gratuito gerando antecipações? Conversion de construtoras gratuitas para operações. Se <10%: wedge não funciona como bridge. Pricing experiments — resultados de A/B se rodados. Elasticidade por segmento. Behavioral effects — volume por tier, retenção por faixa. Tiers gerando concentração de operações? Evolution — pricing engine adequate? Tiers needed? Dynamic justified? Se revisão não identifica pelo menos uma ação: ou pricing é perfeito (improvável) ou revisão é superficial."
		dependsOn: ["pm-value-capture-architecture", "pm-risk-based-pricing", "pm-unit-economics", "pm-competitive-pricing-positioning", "pm-subsidy-monetization-balance", "pm-pricing-behavioral-effects", "pm-fidc-return-alignment", "pm-pricing-evolution"]
		rationale: "Pricing degrada com mercado — competidor muda taxa, Selic muda, inadimplência muda. Sem revisão periódica: pricing descola da realidade e ou perde competitividade (taxa alta) ou perde margem (taxa baixa)."
	},
]

reasoningProtocol: [
	{
		question:  "O modelo de monetização é simples e alinhado com a interação core? Spread de antecipação é o primary revenue?"
		reveals:   "Se captura de valor é natural e compreensível — ou se múltiplas fees confundem e afugentam."
		rationale: "Parker et al. 2016: monetize core interaction. Na Mesh, spread de antecipação é natural. Subscription + API fee + premium no cold start é overmonetization."
	},
	{
		question:  "A taxa reflete risco real (risk-based pricing)? Comprador com score alto paga menos que com score baixo?"
		reveals:   "Se scoring se traduz em vantagem de pricing — ou se taxa é flat e desperdiça advantage de dados."
		rationale: "Risk-based pricing previne adverse selection. Taxa flat atrai alto risco e repele baixo risco."
	},
	{
		question:  "Unit economics por operação está calculado e monitorado? Contribution margin é positiva? Improving by cohort?"
		reveals:   "Se o negócio é sustentável por operação — ou se cada operação perde dinheiro e volume amplifica perda."
		rationale: "Unit economics mensal. Na Mesh, se contribution margin per operation é negativa: crescer é queimar cash faster."
	},
	{
		question:  "Pricing é competitivo em TCO (não apenas taxa nominal) vs factoring? Fornecedor percebe saving real?"
		reveals:   "Se posicionamento competitivo é claro — ou se fornecedor compara taxa nominal e não percebe saving total."
		rationale: "TCO 2022+. Factoring TCO é 4.5%+ vs Mesh 2.5%. Comunicar TCO, não taxa, é o que demonstra saving."
	},
	{
		question:  "O que é gratuito está gerando rede e monetização downstream? Cross-subsidy tem ROI positivo?"
		reveals:   "Se gratuito é investimento em growth — ou se é custo sem retorno."
		rationale: "Free as growth lever 2023+. Dashboard gratuito deve gerar antecipações. Se não: wedge não funciona como bridge."
	},
	{
		question:  "Pricing incentiva comportamento desejado? Volume concentra na Mesh? Comprador mantém bom pagamento por taxa menor?"
		reveals:   "Se pricing é mecanismo de incentivo — ou se é apenas captura passiva."
		rationale: "Pricing as incentive 2022+. Risk-based + volume tiers = pricing que molda comportamento."
	},
	{
		question:  "FIDC está obtendo retorno conforme target? Inadimplência observada ≤ projetada? Relação é sustentável?"
		reveals:   "Se funding provider está alinhado — ou se está insatisfeito e pode sair."
		rationale: "FIDC é partner existencial. Retorno abaixo de target = funding em risco = operação em risco."
	},
	{
		question:  "Pricing é proporcional ao estágio? Manual pré-PMF, engine em growth, dynamic em scale?"
		reveals:   "Se complexidade de pricing é proporcional — ou se é over-engineered (dynamic com 100 ops) ou under-engineered (manual com 10k ops)."
		rationale: "Pricing maturity 2023+. Na Mesh pré-revenue: taxa manual por benchmark. Com tração: engine automatizada. Proporcional."
	},
]

meshExamples: [
	{
		id:       "ex-risk-based-pricing-design"
		scenario: "Mesh precisa projetar pricing engine para antecipação de recebíveis. FIDC target: CDI+4% ao ano. Funding cost: ~1.5% por operação de 45 dias. Factoring benchmark: 3.5-5.0% (excluindo IOF/TAC)."
		analysis: "Pricing engine: taxa = funding_cost + expected_loss(score) + operational_cost + margin. Variáveis: funding cost (1.5%, exógeno — depende de Selic/FIDC). Expected loss (função de score, endógeno — melhora com dados). Operational cost (~0.3%, reduz com automação). Margin (0.5-1.0%, decisão estratégica). Constraint: taxa ≤ factoring benchmark (competitivo) AND taxa ≥ funding cost + costs (sustentável). Window: 2.0-3.5% para a maioria dos perfis."
		recommendation: "(1) Pricing table v1: score 80-100 (baixo risco): taxa = 2.0-2.3%. Score 65-79 (médio risco): taxa = 2.3-2.8%. Score 50-64 (alto risco): taxa = 2.8-3.5%. Score <50: rejeitar (risco inaceitável). Dentro de cada faixa: interpolação linear ou lookup table por score × prazo. (2) Decomposição para score 75, prazo 45 dias: funding cost 1.50% + expected loss 0.15% + operational 0.30% + margin 0.70% = 2.65%. (3) Competitivo? Factoring TCO para mesmo perfil: ~4.5%. Saving: 1.85pp. Fornecedor retém ~1.15pp de saving (>50%). Mesh retém 0.70pp de margin. FIDC retém 1.50pp de retorno. Balanced. (4) Implementação: pricing table codificada como configuração (não hardcoded). Atualizável sem deploy. Funding cost: atualizado quando FIDC renegocia ou Selic muda. Expected loss: recalibrado quando scoring model muda. Margin: decisão de management, revisada trimestralmente. (5) Transparência: fornecedor vê taxa final e economia vs factoring. Não vê decomposição completa (funding cost e margin são internos). Vê: 'taxa reflete risco do comprador + prazo + custo de capital.' (6) Validação: para primeiras 50 operações: verificar que taxa real é competitiva E inadimplência real é ≤ expected loss. Se inadimplência > expected loss: recalibrar (taxa ou score threshold)."
		principlesApplied: ["ax-01", "ax-03", "ax-07"]
		assumptions: [
			"CDI + 4% é target realista para FIDC de recebíveis de construção civil — verificar com mercado",
			"operational cost de 0.3% por operação é estimativa — medir com dados reais",
			"factoring TCO de 4.5% é benchmark preciso — verificar com fornecedores reais",
			"scoring calibrado para expected loss — se AUROC é 0.65 (pré-dados proprietários): expected loss pode ser underestimated",
		]
		rationale: "Risk-based pricing fundamental. Na Mesh, pricing table v1 é simples (3 faixas), risk-based (taxa = f(score)), e competitiva (saving vs factoring). Evolui para engine dinâmica com mais dados e volume."
	},
	{
		id:       "ex-unit-economics-sensitivity"
		scenario: "Mesh está em tração com 200 operações/mês, ticket médio R$40k, taxa média 2.6%. Founder precisa entender: qual variável mais afeta sustentabilidade?"
		analysis: "Revenue: 200 ops × R$40k × 1.0% spread ≈ R$80k/mês. Variable costs: expected loss provision (200 × R$40k × 0.15% = R$12k) + operational (200 × R$50 = R$10k) = R$22k. Contribution margin: R$58k/mês. Fixed costs (infra, tools, salário estimado): R$35k/mês. Net: R$23k/mês. Sensitivity: (a) se inadimplência dobra (expected loss 0.30%): provision = R$24k. Contribution: R$46k. Net: R$11k. Impacto: −52%. (b) se funding cost sobe 0.5% (Selic sobe): spread comprime 0.5%, revenue cai para R$40k. Net: −R$17k (negativo). Impacto: fatal. (c) se volume cai 30% (construtora anchor churns): revenue = R$56k. Net: −R$1k. Impacto: break-even."
		recommendation: "(1) Variável mais sensível: funding cost. 0.5% de aumento torna operação negativa. Mitigar: (a) FIDC com taxa pré-fixada por período (6 meses). (b) diversificar funding (múltiplos FIDCs quando possível). (c) buffer de margem: se funding cost pode subir 0.5%: precificar com buffer de 0.3% já incluso. (2) Segunda variável: volume. Perda de anchor tenant é existencial. Mitigar: diversificar base (>5 construtoras contribuindo >10% cada). Retention como prioridade. (3) Terceira variável: inadimplência. Dobrar é severo mas não fatal (contribution margin cai 20%). Mitigar: scoring improvement contínuo (dq-data-flywheel). (4) Ações: (a) negociar taxa de FIDC com lock por 6 meses. (b) pipeline de novas construtoras para diversificar. (c) monitorar inadimplência mensal vs expected loss — se diverge >20%: recalibrar pricing. (5) Comunicar para investidor: 'unit economics positivo: R$23k/mês net. Sensitivity: funding cost é maior risco. Mitigação: lock de taxa + diversificação de funding. Break-even at 140 ops/mês (70% do atual — buffer de 30%).'"
		principlesApplied: ["ax-01", "ax-05", "ax-07"]
		assumptions: [
			"R$50/operação de operational cost é estimativa — medir e refinar com dados reais",
			"fixed costs de R$35k/mês é estimativa para solo founder com infra cloud — pode variar",
			"inadimplência dobrando é stress test razoável — pode ser otimista (triplicar em crise)",
			"FIDC aceita lock de taxa por 6 meses — depende do contrato",
		]
		rationale: "Unit economics sensitivity. Na Mesh, funding cost é variável de maior impacto porque: (a) é exógena (Mesh não controla Selic). (b) afeta 100% das operações. (c) variação de 0.5% é plausível. Pricing deve incluir buffer para absorver variação sem tornar operação negativa."
	},
	{
		id:       "ex-subsidy-dashboard-roi"
		scenario: "Dashboard de gestão de cadeia é gratuito para construtoras. 15 construtoras usam. 10 geram antecipações (fornecedores antecipam). 5 usam apenas dashboard sem antecipação. Custo de servir 15 construtoras: R$3k/mês (hosting + compute + support)."
		analysis: "Cross-subsidy: R$3k/mês de custo. 10 construtoras geram antecipações = ~R$60k/mês de revenue (spread). ROI: 20:1. 5 construtoras gratuitas sem antecipação: custo de R$1k/mês sem revenue direta. Mas: (1) dados de cadeia coletados (dq-data-accumulation-strategy). (2) construtoras podem converter para antecipação no futuro. (3) social proof (15 construtoras > 10 construtoras). Questão: as 5 gratuitas vão converter? Se não: free riders."
		recommendation: "(1) ROI geral: 20:1 é excelente — subsídio se paga com sobra. Mesmo se 5 construtoras nunca convertem: custo marginal (R$1k/mês) é noise vs revenue (R$60k/mês). Manter dashboard gratuito. (2) Monitorar conversion: para as 5 não-converting: qual é o engagement? Se usam dashboard diariamente: potencial de conversão (estão engajadas, just haven't needed antecipação yet). Se usam <1x/semana: baixo potencial (free rider ou low pain). (3) Nudge para conversion: para construtoras engajadas sem antecipação: 'seus fornecedores podem antecipar recebíveis com taxa a partir de 2.0%. Ativar em 1 clique.' Periodic reminder (mensal), não agressivo. (4) Não converter gratuito em pago: custo de R$1k/mês para 5 construtoras é insignificante vs risco de afugentar potencial converters. Se cobrar R$500/mês por dashboard: algumas das 10 converting podem reconsiderar ('agora cobram E cobram taxa de antecipação'). Trust damage > revenue de R$2.5k/mês. (5) Quando cobrar por dashboard: se >50 construtoras usam sem antecipação E custo de servir > 5% do revenue total: avaliar premium tier com features adicionais (não tirar gratuito, adicionar premium). (6) Métrica: dashboard-to-antecipation conversion rate. Target: >50% em 6 meses. Se <30%: dashboard não funciona como bridge — investigar por que construtoras não facilitam antecipação."
		principlesApplied: ["ax-01", "ax-03"]
		assumptions: [
			"R$3k/mês de custo é estimativa — inclui hosting compartilhado + suporte proporcional",
			"5 construtoras gratuitas eventualmente convertem — pode ser que nunca (dor não é suficiente)",
			"cobrar R$500/mês afugentaria construtoras converting — depende de price sensitivity",
			"50% conversion target em 6 meses é realista — pode ser agressivo",
		]
		rationale: "Cross-subsidy ROI. Anderson 2009: free as growth lever. Na Mesh, dashboard gratuito com ROI de 20:1 é o investimento de growth mais eficiente. 5 free riders a R$1k/mês é custo aceitável pelo potencial de conversão + dados + social proof."
	},
	{
		id:       "ex-fidc-alignment-inadimplencia"
		scenario: "FIDC reporta insatisfação: inadimplência realizada de 3.2% nos últimos 3 meses vs projeção de 1.8%. Retorno abaixo de target. FIDC ameaça endurecer critérios ou reduzir capital."
		analysis: "Inadimplência quase dobrou vs projeção: pricing não reflete risco real. Consequências: (1) FIDC perde margem (retorno comprimido). (2) Se FIDC endurece critérios: menos operações aprovadas → menos volume → menos receita. (3) Se FIDC reduz capital: limite de operações cai → fornecedores não conseguem antecipar → churn. Causa raiz possível: (a) scoring model degradou (drift — ml-model-monitoring-production). (b) novo perfil de comprador entrou na carteira (mix shift). (c) macro deterioração (setor de construção em stress). (d) expected loss underestimated no pricing."
		recommendation: "(1) Investigar causa raiz imediatamente: (a) modelo performance — AUROC dos últimos 3 meses vs baseline. Se caiu >0.03: drift confirmado → retrain. (b) mix analysis — operações que defaultaram: perfil diferente do treinamento? Novos compradores sem histórico? Concentração em 1-2 compradores? (c) macro check — inadimplência do setor subiu? CBIC/ABRAMAT data. Se setor: não é problema do modelo — é problema do mercado. (2) Comunicar para FIDC: transparência imediata. 'Identificamos inadimplência acima do projetado. Causas investigadas: [achados]. Ações: [lista].' Não esperar ter solução para comunicar — reconhecer + agir (tc-trust-recovery). (3) Ações por causa: (a) se drift: retrain modelo + recalibrar expected loss no pricing. Taxa pode subir 0.2-0.3% para refletir risco real. (b) se mix shift: adicionar rules para novos compradores (cap de valor menor, margem maior) ou excluir perfis de alto risco. (c) se macro: ajustar expected loss para cenário macro atual. Stress test com cenário de deterioração continuada. (4) Pricing adjustment: se expected loss real é 3.2% (não 1.8%): pricing precisa absorver. Taxa sobe de 2.65% para ~2.85% (expected loss +1.4pp para 45 dias = ~0.18pp adicional). Comunicar para fornecedores: 'ajuste de taxa para refletir condições de mercado.' Antecedência de 30 dias. (5) FIDC alignment meeting: reunião presencial para: apresentar causa raiz, ações tomadas, projeção corrigida, e commitment de transparência contínua. Oferecer: relatório semanal (não mensal) até inadimplência normalizar. (6) Preventivo: implementar early warning — 30-day delinquency como proxy de 90-day default (ml-model-monitoring-production). Se 30-day sobe: agir antes de 90-day materializar."
		principlesApplied: ["ax-05", "ax-06", "ax-07"]
		assumptions: [
			"3.2% de inadimplência é medição de 3 meses — pode ser volátil com amostra pequena",
			"FIDC aceita adjustment se transparência é total — depende de contrato e relação",
			"taxa pode subir 0.2% sem perder competitividade — depende de gap vs factoring",
			"30-day delinquency prevê 90-day default — correlação precisa ser validada",
		]
		rationale: "FIDC alignment. TC trust recovery: transparência + ação. Na Mesh, inadimplência acima do projetado é crise de pricing E de trust. Resolver: (1) causa raiz técnica (scoring, mix, macro). (2) pricing adjustment. (3) transparência com FIDC. (4) preventivo para futuro. Silêncio é o pior cenário — FIDC que descobre por relatório mensal em vez de comunicação proativa perde trust irreversivelmente."
	},
]

principleIds: ["ax-01", "ax-03", "ax-05", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-credit-risk"
		relation: "complementsWith"
		context:  "CR modela risco (PD, LGD, expected loss). PM traduz risco em preço (taxa = f(expected_loss)). CR é input; PM é output. CR diz 'PD = 3% para score 75'; PM diz 'expected loss = 0.15% por operação → taxa inclui este componente.' Sem CR: pricing é guess. Com CR: pricing é risk-adjusted."
	},
	{
		lensId:   "lens-data-quality-as-competitive-moat"
		relation: "complementsWith"
		context:  "DQ data flywheel gera scoring melhor. PM traduz scoring melhor em pricing mais competitivo. O flywheel completo: dados → scoring → pricing → volume → dados. PM é o estágio onde vantagem de dados se torna vantagem de mercado. DQ é invisível para cliente; PM é tangível (taxa menor)."
	},
	{
		lensId:   "lens-cold-start-and-network-bootstrapping"
		relation: "complementsWith"
		context:  "CS define incentivos de bootstrap (taxa reduzida, dashboard gratuito). PM define o modelo de monetização de longo prazo. CS é tática de aquisição; PM é arquitetura de sustentabilidade. CS diz 'taxa reduzida na primeira operação'; PM diz 'taxa regular pós-primeira é 2.5%, e o modelo sustenta com >80 ops/mês'."
	},
	{
		lensId:   "lens-stakeholder-communication"
		relation: "complementsWith"
		context:  "SC comunica pricing para diferentes audiências. PM define o conteúdo. Para fornecedor: 'economia de 50% vs factoring.' Para FIDC: 'retorno de CDI+4% com inadimplência projetada de 2%.' Para investidor: 'take rate de 1% em TAM de R$50B.' SC é o como; PM é o quê."
	},
	{
		lensId:   "lens-behavioral-economics"
		relation: "complementsWith"
		context:  "BE modela vieses (framing, anchoring, loss aversion). PM aplica em pricing: economia como gain frame, ancoragem contra factoring, volume tiers como incentivo. BE é a teoria; PM é a aplicação."
	},
	{
		lensId:   "lens-mechanism-design"
		relation: "complementsWith"
		context:  "MD projeta mecanismos formais (scoring, matching). PM usa output de mecanismos como input de pricing (score → taxa). MD é o mecanismo que mede; PM é o mecanismo que cobra. Ambos devem ser incentive-compatible."
	},
	{
		lensId:   "lens-multi-sided-platform-ux"
		relation: "complementsWith"
		context:  "MUX gerencia tensões entre sides. PM é onde tensão pricing se manifesta: fornecedor quer taxa baixa, FIDC quer retorno alto, Mesh quer spread. MUX projeta como tensão é percebida; PM projeta como tensão é resolvida economicamente."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA aloca recursos. PM unit economics informa: cada melhoria operacional (reduzir operational cost per operation) tem ROI calculável. ORA diz 'investir onde ROI é máximo'; PM quantifica ROI de cada melhoria via impact em contribution margin."
	},
	{
		lensId:   "lens-real-options"
		relation: "complementsWith"
		context:  "RO modela experimentação. PM pricing experiments são opções: testar taxa variante, medir impact, exercer se positivo. RO preserva opcionalidade (podemos adicionar tiers); PM exerce quando evidência justifica."
	},
]

limitations: [
	{
		description: "Risk-based pricing requer scoring calibrado. Com poucos dados (cold start), scoring é impreciso — taxa pode underestimate risco (perde dinheiro) ou overestimate (não é competitiva)."
		alternative: "Cold start: taxa conservadora (margem de segurança) baseada em benchmark + dados públicos. À medida que dados proprietários acumulam e scoring calibra: taxa se torna risk-based. Transition gradual, não binary."
		rationale: "Risk-based pricing sem scoring calibrado é precision theater. Conservadorismo honesto é melhor que precisão falsa."
	},
	{
		description: "Unit economics por operação assume que custos são atribuíveis. Na realidade, custo de infraestrutura, scoring, e compliance são compartilhados — atribuição é estimativa."
		alternative: "Usar activity-based costing aproximado: estimar custo por operação baseado em total costs / total operations. Refinar quando granularity de dados melhorar. Não paralisar por falta de atribuição perfeita."
		rationale: "Unit economics aproximado é infinitamente mais útil que nenhum unit economics. Refinar com dados, não com perfeição teórica."
	},
	{
		description: "Pricing experiments (A/B testing de taxa) podem ser controversos em fintech — fornecedor A pagou 2.5% e fornecedor B pagou 2.3% para mesma operação. Se descoberto: percepção de unfairness."
		alternative: "A/B test por cohort temporal (não simultâneo): taxa 2.5% no mês 1, taxa 2.3% no mês 2, medir diferença. Ou: A/B por segmento com justificativa ('taxa promocional para novos fornecedores'). Transparência: se perguntado, explicar que testa pricing para encontrar equilíbrio justo."
		rationale: "Fairness perception em fintech é mais sensível que em e-commerce. A/B de preço requer cuidado com comunicação e justificativa."
	},
	{
		description: "FIDC alignment assume que Mesh pode influenciar termos de funding. Na prática, FIDC pode impor condições que Mesh não pode negociar (solo founder sem track record)."
		alternative: "No cold start: aceitar termos do FIDC (custo de funding é given, não negotiable). Com track record: renegociar. Com volume: múltiplos FIDCs competindo. Poder de negociação é função de track record e volume."
		rationale: "Solo founder com zero track record não negocia custo de funding. Aceitar, provar, depois negociar."
	},
	{
		description: "Framework assume mercado racional — fornecedor escolhe opção mais barata (Mesh vs factoring). Na prática, hábito, relação pessoal com fator, e desconhecimento de alternativas podem superar vantagem de preço."
		alternative: "Pricing competitivo é condição necessária mas não suficiente. Comunicação de TCO (educação sobre custo real do factoring), social proof (outros fornecedores economizaram X), e experiência superior (velocidade, transparência) são complementos. 4 forças de Moesta: push + pull > anxiety + habit."
		rationale: "B2B é relacional, não puramente racional. Pricing ganha no Excel; relação, confiança e experiência ganham na decisão real."
	},
]

rationale: "Toda plataforma financeira precisa de modelo de pricing que capture valor proporcional ao valor criado, sustente operação, e alinhe incentivos de todos os participantes. Na Mesh como intermediário financeiro B2B com fornecedores, construtoras e FIDC, pricing é onde scoring proprietário se traduz em vantagem competitiva tangível. Esta lens operacionaliza: arquitetura de captura de valor com take rate e monetização de core interaction (Parker et al. 2016, Rochet/Tirole 2003, Nagle/Müller 2018, take rate a16z 2022+), pricing risk-based com decomposição e data-driven advantage (credit pricing fundamental, Akerlof 1970, data-driven pricing 2023+), unit economics com contribution margin e LTV/CAC por cohort (unit economics fundamental, cohort analysis 2022+, contribution margin escalation 2023+), posicionamento competitivo com TCO e price anchoring (Porter 1980, TCO 2022+, price anchoring 2023+, competitive pricing moat 2024+), equilíbrio subsídio-monetização com cross-subsidy ROI (Eisenmann et al. 2006, Anderson 2009, free as growth lever 2023+), efeitos comportamentais do pricing com incentivos e framing (Thaler/Sunstein 2008, pricing as incentive 2022+, Kahneman/Tversky 1979), alinhamento de retorno com FIDC via information alignment (funding cost management 2022+, alignment via information 2023+), e evolução de pricing por estágio com experiments (pricing maturity 2023+, pricing as experiment 2022+, multi-product 2024+). Universal, agnóstica a estágio, aplicável a qualquer plataforma financeira que intermedia transações com funding externo."

}
