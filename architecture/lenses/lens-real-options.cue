package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

artifact_schemas.#AnalyticalLens & {
	id:     "lens-real-options"
	name:   "Opções Reais"

	purpose: "Modelar timing, sequência e valor de espera em decisões irreversíveis sob incerteza — quando agir, quando esperar, quando abandonar, e como staging com gates reduz risco sem perder janela competitiva."

	status: "draft"

	trigger: {
		conditions: [
			"a decisão envolve investimento irreversível ou parcialmente irreversível sob incerteza",
			"a decisão envolve timing — agir agora vs esperar por mais informação",
			"a decisão envolve staging — sequenciar investimentos em etapas com gates de decisão",
			"a decisão envolve abandonar um caminho já iniciado (sunk cost vs option value de pivotar)",
			"a decisão envolve expandir para novo segmento, produto ou mercado a partir de posição existente",
			"a decisão envolve escolha de tecnologia ou arquitetura com lock-in",
			"a decisão envolve licenciamento regulatório com custo e timing incertos (SCD, FIDC próprio)",
			"a decisão envolve experimentação — testar hipótese antes de investir plenamente",
			"a decisão envolve manter opcionalidade vs comprometer-se para obter vantagem",
			"a decisão envolve valor de esperar vs custo de esperar (preemption por concorrente)",
		]
		keywords: [
			"opção real", "real option", "opcionalidade",
			"irreversibilidade", "irreversible", "sunk cost",
			"timing", "agora vs esperar", "when to invest",
			"staging", "etapas", "gates", "phase gate",
			"abandonar", "pivotar", "pivot", "abandon",
			"expandir", "expansão", "novo segmento",
			"lock-in", "path dependence", "switching cost",
			"experimentação", "teste", "hipótese", "MVP",
			"incerteza", "uncertainty", "volatilidade",
			"valor de esperar", "option to wait",
			"compromisso", "commitment", "flexibilidade",
			"modularidade", "reversibilidade",
		]
		excludeWhen: [
			"a decisão é sobre design de mecanismos de incentivo — usar mechanism-design",
			"a decisão é sobre termos contratuais — usar contract-theory",
			"a decisão é sobre comportamento estratégico de outros jogadores — usar game-theory-applied",
			"a decisão é sobre estrutura organizacional interna — usar organizational-economics",
			"a decisão é sobre risco de crédito individual — usar credit-risk",
		]
		rationale: "As outras lenses modelam o que fazer e como. Real-options modela quando e em que sequência — e o valor de não decidir agora. NPV tradicional diz 'invista se valor > custo.' Real options diz 'esperar tem valor se a incerteza se resolve com tempo e a informação melhora a decisão.' Na Mesh pré-revenue: quase toda decisão é investimento irreversível sob incerteza — tecnologia, regulação, mercado, produto. O framework clássico (Dixit/Pindyck 1994) é enriquecido por: Bloom (2009) sobre como incerteza afeta timing de investimento, Gans/Stern/Wu (2019) sobre estratégia empreendedora como portfólio de opções, McGrath (2010) sobre discovery-driven planning, Kerr/Nanda/Rhodes-Kropf (2014) sobre empreendedorismo como experimentação com opções, Manso (2011) sobre tolerância ao fracasso como condição para inovação, Smit/Trigeorgis (2017) sobre interação entre opções reais e jogos estratégicos, e Adner/Levinthal (2004) sobre como real options interagem com aprendizado organizacional."
	}

	concepts: [
		{
			id:         "ro-irreversibility-uncertainty"
			name:       "Irreversibilidade e Incerteza: Quando Esperar Tem Valor"
			nature:     "theoretical"
			role:   "framework"
			definition: "Dixit/Pindyck (1994): investimento irreversível sob incerteza tem valor de espera — a opção de investir amanhã com mais informação vale mais que investir hoje com menos. NPV positivo não é suficiente para investir — precisa superar threshold que inclui valor da opção de esperar. Bloom (2009): aumento de incerteza (macro, regulatória, tecnológica) eleva o threshold — firmas pausam investimentos não porque NPV caiu, mas porque option value de esperar subiu. Na Mesh: três fontes de incerteza simultâneas: (a) mercado (construtoras querem antecipar? volume?), (b) regulatória (PL de IA, cadastro positivo, reforma tributária — rs-regulatory-risk), (c) tecnológica (modelo de IA evolui, Drex muda infraestrutura). Irreversibilidade varia por decisão: tecnologia (CUE, Kotlin — parcialmente irreversível, custo de migração), regulação (SCD — investimento de 6-18 meses, capital — altamente irreversível), mercado (anchor — reversível com custo reputacional), produto (scoring methodology — parcialmente reversível com custo de recalibração e comunicação). A contribuição de Bloom sobre Dixit/Pindyck: não é apenas 'se' incerteza existe, mas 'quanta' — e incerteza regulatória no Brasil é alta e crescente (rs-regulatory-risk: cenários correlacionados), o que eleva o threshold de investimento irreversível."
			meshManifestation: "Decisão: obter SCD agora (custo: R$500k + 12 meses + capital mínimo) vs esperar. Incerteza: Bacen pode reinterpretar servicer como IF (→ SCD necessária) ou não (→ desperdício). Se esperar: informação chega (Bacen publica guideline). Se investir agora e Bacen não exige: custo afundado. Se esperar e Bacen exige: 12 meses de atraso. Decisão: escolher CUE como schema language. Parcialmente irreversível: 17 lenses + schemas + CI. Migrar: custo de reescrever. Se CUE se torna padrão: benefício. Se não: lock-in em tecnologia de nicho. Decisão: entrar no segmento de infraestrutura. Irreversível: scoring novo, Kraljic novo, anchors novos, branding. Se não funciona: sunk cost + distração (oe-exploration-exploitation)."
			meshImplication: "Para cada decisão de investimento: (1) qual o grau de irreversibilidade? (alto: SCD. Médio: tecnologia. Baixo: pricing). (2) Qual a incerteza relevante? (regulatória, mercado, tecnológica). (3) A incerteza se resolve com tempo? Se sim: esperar tem valor. Se não (incerteza permanente): esperar não ajuda — investir se NPV > 0. (4) O custo de esperar é alto? Se concorrente se move (gt-competitive-dynamics: preemption) ou janela fecha: esperar tem custo que pode superar valor. Trade-off: valor de esperar (informação) vs custo de esperar (preemption, opportunity cost, competitive moat que não se forma). Para Tipo 7 awareness: 'estou agindo agora porque informação justifica? Ou porque esperar é tedioso e agir é excitante?' Se segundo: o framework pede espera."
			rationale: "Dixit/Pindyck + Bloom: irreversibilidade + incerteza = valor de espera. Não basta NPV > 0. Threshold inclui option value."
		},
		{
			id:         "ro-staging-gates"
			name:       "Staging e Phase Gates: Investimento em Etapas com Decisão Condicional"
			nature:     "theoretical"
			role:   "method"
			definition: "Trigeorgis (1996), Huchzermeier/Loch (2001): investimento em etapas com gate de decisão entre elas. Cada etapa resolve parte da incerteza. No gate: continuar (se informação favorável), pivotar (se informação mista), ou abandonar (se desfavorável). McGrath (1999, 2010 — discovery-driven planning): para ventures com alta incerteza, o plano não é 'executar roadmap' — é 'testar premissas sequencialmente, investindo o mínimo necessário para resolver a próxima premissa.' Cada teste é compra de opção: gasta pouco, aprende muito, decide se exerce (continua) ou deixa expirar (abandona). Kerr/Nanda/Rhodes-Kropf (2014): empreendedorismo é experimentação — cada experimento compra informação. O custo do experimento é o prêmio da opção. O retorno é a informação que permite decisão melhor. Ewens/Nanda/Rhodes-Kropf (2018): custo de experimentação caiu com tecnologia — na Mesh IA-first, testar com agentes de IA custa fração do que custaria com equipe humana."
			meshManifestation: "Bootstrap da Mesh é sequência de gates, não roadmap fixo. Gate 0 (custo: ~zero + tempo): construtoras querem antecipar? Teste: conversa com 5-10 construtoras. Se não: pivotar antes de investir. Gate 1 (custo: R$X + 3 meses): antecipação via correspondente funciona? Teste: 50 operações com 1 correspondente. Se default > [Y%]: repensar scoring. Gate 2 (custo: R$XX + 6 meses): FIDC terceirizado viável? Teste: montar FIDC com gestor, originar R$Z M. Se investidor não aparece: repensar estrutura. Gate 3 (custo: R$XXX + 12 meses): escalar? SCD necessária? Teste: volume > threshold, regulação clara. Se não: manter estrutura atual. Cada gate: custo mínimo para resolver a premissa mais arriscada. Ewens et al.: custo de cada gate na Mesh é baixo (IA-first: agentes testam, não humanos contratados)."
			meshImplication: "Para cada decisão de investimento: decompor em gates. Para cada gate: (1) qual premissa está sendo testada? (2) Qual o custo mínimo para testar? (3) Qual informação resolve a incerteza? (4) Critérios de continuar/pivotar/abandonar — definidos antes do gate, não depois (evita bias de confirmação). Para a Mesh: sequência de premissas mais arriscadas primeiro (McGrath): (a) demanda existe? (mais arriscada — se não: tudo irrelevante). (b) Scoring funciona? (se não: proposta de valor falha). (c) Funding disponível? (se não: não escala). (d) Regulação permite? (se não: reestruturar). Cada premissa testada com custo mínimo. Ewens: IA-first reduz custo de cada gate — agente testa em horas o que equipe faria em semanas. Para Tipo 7: gates com critérios pré-definidos previnem que founder avance sem validação ('vamos para o próximo gate' sem ter validado o atual — excitement bias)."
			dependsOn: ["ro-irreversibility-uncertainty"]
			rationale: "McGrath + Kerr/Nanda: descoberta > planejamento. Gates com critérios pré-definidos. IA-first reduz custo de experimentação."
		},
		{
			id:         "ro-option-to-expand"
			name:       "Opção de Expandir: Valor da Plataforma como Portfólio de Opções Futuras"
			nature:     "theoretical"
			role:   "property"
			definition: "Trigeorgis (1996): investimento inicial cria opções de expansão futura — valor do investimento inclui o valor dessas opções, não apenas NPV do investimento isolado. Gans/Stern/Wu (2019): estratégia empreendedora é portfólio de opções — cada decisão abre ou fecha opções futuras. A Mesh na construção civil cria opções de expansão: (a) novos segmentos (infraestrutura, energia, varejo — Mesh como plataforma multi-vertical), (b) novos produtos (matching premium, analytics, compliance-as-a-service), (c) novos mercados geográficos, (d) novos lados da plataforma (seguradoras, órgãos públicos). O valor de construir scoring robusto na construção civil não é apenas o NPV da antecipação na construção — é o valor de ter scoring + rede + dados que habilitam expansão. Adner/Levinthal (2004): real options interagem com learning — cada opção exercida gera aprendizado que muda o valor das opções remanescentes. Aprendizado na construção civil (informalidade, sazonalidade, scoring) pode ser transferível para outros segmentos com dinâmica similar, ou pode ser não-transferível (muito específico). Se transferível: opção de expansão é valiosa. Se não: opção existe mas tem custo de exercício alto (novo scoring, novo Kraljic, novo onboarding)."
			meshManifestation: "Scoring robusto na construção civil: NPV da antecipação = X. Opção de expansão para infraestrutura usando mesmo scoring: valor adicional Y (se transferível). Se construção civil não funciona: opções de expansão expiram (worthless). Se funciona: opções de expansão estão in-the-money. O investimento em dados operacionais (sc-scf-mechanism) tem valor além do uso imediato: cada dado é investimento em opções futuras. CUE como schema language: abre opção de portabilidade de artefatos para outros domínios. Se CUE se torna padrão: opção valiosa. Se não: opção expira."
			meshImplication: "Para cada investimento: valor = NPV direto + valor das opções futuras que cria. Se opções são valiosas: justifica investir mais que NPV direto sugere. Para a Mesh: (a) scoring genérico vs específico — scoring muito específico para construção civil fecha opções de expansão. Scoring com camada genérica (credit fundamentals) + camada específica (construção): preserva opção. (b) Dados operacionais genéricos (lead time, payment gap, confirmação) vs específicos (sazonalidade de chuvas, Kraljic de construção): genéricos são transferíveis, específicos não. Investir em ambos, mas saber qual é transferível. (c) Tecnologia modular (oe-context-window-constraint: composição hierárquica): modularidade preserva opções. Monolito fecha. (d) Para expansão: não exercer prematuramente (oe-exploration-exploitation: exploitation first). Opção existe sem ser exercida — e perder a opção (por foco inadequado) é diferente de não exercê-la (por timing)."
			dependsOn: ["ro-staging-gates"]
			rationale: "Gans/Stern/Wu: portfólio de opções. Adner/Levinthal: learning muda opções. Modularidade preserva. Especificidade fecha."
		},
		{
			id:         "ro-option-to-abandon"
			name:       "Opção de Abandonar: Sunk Cost Discipline e Tolerância ao Fracasso"
			nature:     "theoretical"
			role:   "property"
			definition: "McDonald/Siegel (1986): opção de abandonar limita downside — se investimento não funciona, perdas são limitadas ao investido. Manso (2011): inovação requer tolerância ao fracasso no curto prazo — punir fracasso precoce desincentiva experimentação. O founder que abandona experimento que não funcionou está exercendo a opção de abandonar — não é fracasso, é decisão ótima. Mas: sunk cost bias (be-sunk-cost) faz founder continuar investindo em caminho fracassado. Na Mesh com Tipo 7: paradoxo — Tipo 7 tende a abandonar rápido demais por busca de novidade (não por análise) e simultaneamente pode ter sunk cost bias em projetos que se tornou emocional. O framework de opções resolve: abandone quando informação diz que opção expirou (fundamentado), não quando novo é mais excitante (impulsivo). E continue quando informação justifica, não quando sunk cost emocional impede abandono."
			meshManifestation: "Cenário: Mesh investiu 6 meses em anchor X. Anchor não engajou. Sunk cost: 6 meses de esforço + relacionamento. Opção de abandonar: se critérios de gate não foram atingidos após [X semanas] (gt-entry-game: deadline de negociação), abandonar anchor e buscar alternativo. Sunk cost bias: 'já investi 6 meses, se insistir mais um pouco...' Real options: 'informação diz que anchor não funciona. Option value de insistir < option value de tentar outro.' Cenário: scoring V1 não discrimina bem. Sunk cost: meses de desenvolvimento. Opção: pivotar para V2 com metodologia diferente. Se V1 é sunk cost mas V2 tem dados melhores: pivotar."
			meshImplication: "Para cada investimento: definir critérios de abandono antes de investir (McGrath: assumptions-to-knowledge). 'Abandonamos se [condição X] não for atingida em [prazo Y].' Critérios definidos ex ante, não ex post (evita sunk cost bias e rationalization). Para Tipo 7: distinguir abandono fundamentado (gate não atingido → exercer opção de abandonar) de abandono impulsivo (novo é mais excitante → não é opção real, é fuga — oe-exploration-exploitation). Para tolerância ao fracasso (Manso): se gate diz abandonar, não é fracasso — é informação. Codificar: 'se experiment X não atinge [critério] em [prazo]: abandonar é a decisão correta, não falha.' Para o tension-log: registrar abandono com rationale (oe-organizational-knowledge) — futuro agente sabe por que foi abandonado, não apenas que foi."
			dependsOn: ["ro-staging-gates"]
			rationale: "Manso: tolerância ao fracasso. Sunk cost bias vs opção de abandonar. Critérios ex ante. Tipo 7: abandono fundamentado ≠ fuga."
		},
		{
			id:         "ro-option-to-switch"
			name:       "Opção de Pivotar: Flexibilidade de Reconfiguração"
			nature:     "theoretical"
			role:   "property"
			definition: "Trigeorgis (1996): opção de switch — mudar de um modo de operação para outro. Não é abandonar (exercer opção de saída) nem expandir (exercer opção de crescimento). É reconfigurar: mudar scoring methodology, mudar segmento, mudar via regulatória, mudar tecnologia. O custo de switch é o custo de exercício da opção. Gans/Stern/Wu (2019): a capacidade de pivotar é a opção mais valiosa de um empreendedor — mas pivot tem custo (path dependence, switching costs internos, reputação, confusão de stakeholders). Quanto maior o investimento em caminho atual: maior o custo de switch (cas-path-dependence). Modularidade (oe-context-window-constraint, arquitetura técnica) reduz custo de switch — mudar um módulo sem reescrever tudo."
			meshManifestation: "Pivots potenciais da Mesh: (a) scoring methodology: trocar de model-based para ML — custo de revalidar, recalibrar, comunicar (ct-commitment-and-optionality: contrato é reference point, mudança de scoring = mudança de reference point → aggrievement). (b) Segmento: construção civil → infraestrutura — custo de novo Kraljic, novo scoring, novos anchors, novo branding parcial. (c) Via regulatória: correspondente → FIDC → SCD — custo de reestruturação + tempo. (d) Tecnologia: CUE → outra schema language — custo de reescrever 17 lenses + CI. Custo de switch é função de: especificidade do investimento (tf-asset-specificity), complementaridades (oe-complementarities), e comunicação a stakeholders (ct-commitment-and-optionality: se Mesh prometeu scoring estável e muda: credibilidade — gt-commitment-credibility)."
			meshImplication: "Para preservar opção de switch: (1) modularidade técnica — camadas separáveis (liquidação, scoring, matching, compliance). Se precisa trocar scoring: não reescreve matching. (2) Modularidade de artefatos — lenses como módulos (oe-context-window-constraint: composição hierárquica). Se expande para infraestrutura: adiciona lenses sem reescrever core. (3) Comunicação com stakeholders: não prometer mais especificidade que necessário. 'Scoring é auditável e evolui' (preserva opção de mudar) > 'scoring usa modelo X para sempre' (mata opção). (4) Antes de switch: custo de switch (técnico + stakeholders + credibilidade) vs valor do novo caminho. Se custo > valor: manter. Se valor > custo: pivotar com plano de comunicação. (5) Path dependence awareness: quanto mais investe em caminho atual, mais caro é pivotar. Investir com consciência de que está 'comprando' caminho — e 'vendendo' opção de switch."
			dependsOn: ["ro-irreversibility-uncertainty"]
			rationale: "Gans/Stern/Wu: pivot como opção valiosa. Custo de switch = custo de exercício. Modularidade reduz custo."
		},
		{
			id:         "ro-preemption-vs-waiting"
			name:       "Preemption vs Espera: Quando Esperar Custa Mais que Agir"
			nature:     "theoretical"
			role:   "framework"
			definition: "Dixit/Pindyck (1994): esperar tem valor sob incerteza. Mas Smit/Trigeorgis (2017), Lambrecht/Perraudin (2003): se competidor pode se mover primeiro e capturar valor (preemption), esperar tem custo. O trade-off: valor de informação (esperar → saber mais) vs custo de preemption (esperar → concorrente captura moat). Na Mesh: data-enabled learning (gt-competitive-dynamics) cria retornos crescentes — quem acumula dados primeiro tem moat. Se Mesh espera para investir em scoring e banco se move: banco captura dados. Se Mesh investe antes de validar demanda: risco de sunk cost. Grenadier (2002): em mercados com competição, option value de esperar é menor — porque concorrentes não esperam. O threshold de investimento cai quando competição é alta. Interação com gt-competitive-dynamics: se janela é curta (incumbente reage em 12 meses): preemption domina. Se longa (dados são barreira alta): esperar com experimentação é viável."
			meshManifestation: "Cenário: banco regional lança antecipação para construção. Mesh em gate 1 (testando com correspondente). Se esperar para completar gate 1: banco acumula dados e fornecedores (preemption). Se acelerar sem validar: risco de escalar sem product-market fit. Trade-off: testar mais (gate discipline) vs mover mais rápido (preemption). Resolução: Ewens et al. (2018) — custo de experimentação é baixo na Mesh IA-first. Pode testar rápido E mover rápido. Não é 'testar OU mover' — é 'testar rápido para mover informado.'"
			meshImplication: "Para cada decisão de timing: (1) existe preemption risk? Se concorrente se move e captura dados/rede: sim. (2) Qual a janela? Se curta (< 12 meses): preemption domina → investir mais rápido, aceitar mais risco. Se longa (> 24 meses): esperar com experimentação é viável. (3) O custo de experimentação é baixo? (Ewens: IA-first → sim). Se baixo: testar rápido reduz incerteza sem perder janela. (4) Qual é o mínimo viável para capturar posição? Não é 'investir tudo agora' — é 'investir o suficiente para capturar dados/rede antes do concorrente, validando em paralelo.' Para Mesh: dados operacionais (sc-scf-mechanism) são o ativo que preemption ameaça — cada mês de operação acumula dados não-replicáveis. Se banco acumula 12 meses antes da Mesh: moat do banco. Se Mesh acumula: moat da Mesh. Timing de operação (não de investimento pesado) é o que importa."
			dependsOn: ["ro-irreversibility-uncertainty", "ro-staging-gates"]
			rationale: "Smit/Trigeorgis: competição reduz option value de esperar. Ewens: custo baixo de experimentação permite testar rápido. Dados são ativo de preemption."
		},
		{
			id:         "ro-experimentation-as-option"
			name:       "Experimentação como Compra de Opção: Lean Startup como Real Options"
			nature:     "theoretical"
			role:   "method"
			definition: "Kerr/Nanda/Rhodes-Kropf (2014): empreendedorismo é experimentação — cada teste compra informação (opção). O custo do teste é o prêmio. O retorno é a informação. Ries (2011): Lean Startup é, formalmente, real options reasoning aplicado — build-measure-learn é exercise-observe-decide. Ewens/Nanda/Rhodes-Kropf (2018): custo de experimentação caiu com tecnologia. Na Mesh IA-first: custo cai mais (agente testa em horas). Manso (2011): para inovação, o sistema deve tolerar fracasso experimental — punir fracasso precoce mata experimentação. Gans/Stern/Wu (2019): experimento tem valor se muda a decisão. Se o resultado do teste não muda o que founder faria: teste é desperdício. Teste tem valor = P(resultado muda decisão) × valor da decisão melhor. Se P é baixo (founder faria a mesma coisa independente): não testar — investir."
			meshManifestation: "Teste: 'construtoras querem antecipar?' Custo: 2 semanas de conversa (prêmio da opção). Resultado: sim/não (informação). Se sim: exerce (investe). Se não: opção expira (pivota antes de investir). Valor: se resultado muda decisão (entre continuar e pivotar): alto. Se founder construiria Mesh independente da resposta: teste inútil (não muda decisão). Teste: 'scoring V1 discrimina?' Custo: 3 meses de dados (prêmio). Resultado: AUROC > [0.7] ou não. Se AUROC < 0.7: pivotar metodologia. Se > 0.7: escalar. Gans: se founder escalaria com qualquer AUROC: teste é wasteful."
			meshImplication: "Para cada experimento proposto: (1) o resultado muda a decisão? Se não: não testar — investir ou não investir. (2) Qual é o custo mínimo para obter a informação? (Ewens: IA-first → baixo — mas não zero). (3) Qual é o prazo? (experimento sem prazo não tem gate → vira projeto → sunk cost). (4) Critérios de decisão definidos antes: 'se resultado > [X]: continuar. Se < [Y]: abandonar. Se entre: refinar e re-testar.' Para bootstrap da Mesh: premissas testáveis em sequência (McGrath): demanda → scoring → funding → regulação. Cada premissa é experimento com prêmio (custo), informação (resultado), e gate (decisão). Para Tipo 7: experimentação é perigosa porque parece produtiva ('estou testando!') mas pode ser procrastinação de decisão ('testo mais um pouco em vez de decidir'). Gate com prazo força decisão."
			dependsOn: ["ro-staging-gates", "ro-option-to-abandon"]
			rationale: "Kerr/Nanda: experimentação = compra de opção. Gans: teste só vale se muda decisão. Ewens: IA-first reduz custo. Prazo força decisão."
		},
		{
			id:         "ro-commitment-flexibility-tradeoff"
			name:       "Trade-off Commitment × Flexibilidade: Quando Comprometer Destrói ou Cria Valor"
			nature:     "theoretical"
			role:   "framework"
			definition: "Schelling (1960) + Dixit/Pindyck (1994): commitment e flexibilidade são opostos. Commitment cria credibilidade (gt-commitment-credibility) e captura valor (lock-in de participantes, preemption). Flexibilidade preserva opções (esperar, pivotar, expandir). O trade-off é real e não tem solução genérica — depende de: grau de incerteza (alta → flexibilidade vale mais), competição (alta → commitment vale mais para preemption), credibilidade necessária (alta → commitment), reversibilidade (baixa → cautela com commitment). Smit/Trigeorgis (2017): em jogos competitivos, commitment estratégico pode mudar o jogo — comprometer-se com preço ou capacidade muda comportamento do concorrente. Mas commitment errado é pior que flexibilidade — porque não pode desfazer. Interação com ct-commitment-and-optionality (Hart/Moore 2008): contrato é reference point — commitment contratual cria expectativa. Flexibilidade contratual cria aggrievement. O framework de opções adiciona: commitment contratual é exercício de opção — irreversível, deve ser feito quando informação justifica."
			meshManifestation: "Commitment de pricing: taxa fixa 12 meses para anchor (gt-commitment-credibility: sinal + ct-commitment-and-optionality: reference point estável). Se incerteza de funding é alta (taxa pode precisar subir): commitment de 12 meses é exercício de opção arriscado. Se incerteza é baixa: commitment cria credibilidade e retém. Commitment de tecnologia: CUE como schema language. Se incerteza de CUE como padrão é alta: commitment é arriscado. Se adoção cresce: commitment cria vantagem. Flexibilidade de scoring: 'scoring evolui' preserva opção de mudar. 'Scoring usa modelo X' destrói. Mas: excesso de flexibilidade reduz credibilidade ('scoring muda o tempo todo' → participante não confia)."
			meshImplication: "Para cada decisão de commitment: (1) qual a incerteza residual? Se alta: preservar flexibilidade (não comprometer). Se baixa: comprometer (captura valor). (2) Competição exige commitment? Se concorrente captura com commitment (preço, exclusividade): comprometer. Se não: manter opção. (3) Credibilidade exige commitment? (gt-commitment-credibility: scoring automático, pricing cap). Se sim: comprometer nas dimensões que geram credibilidade. (4) Reversibilidade? Se irreversível (SCD, tecnologia): threshold alto para comprometer. Se reversível (pricing mensal): threshold baixo. Para a Mesh: comprometer seletivamente — credibilidade em dimensões que importam (scoring auditável, LGPD, pricing cap por período), flexibilidade em dimensões que mudam (features, segmento, metodologia). Codificar: quais decisões são commitments (exercício de opção) e quais preservam opções."
			dependsOn: ["ro-preemption-vs-waiting", "ro-irreversibility-uncertainty"]
			rationale: "Smit/Trigeorgis: commitment muda jogo. Commitment seletivo: credibilidade onde importa, flexibilidade onde muda."
		},
		{
			id:         "ro-modular-architecture-options"
			name:       "Arquitetura Modular como Preservação Sistemática de Opções"
			nature:     "theoretical"
			role:   "property"
			definition: "Baldwin/Clark (2000, 'Design Rules'): modularidade em arquitetura cria options — cada módulo pode ser substituído, melhorado ou abandonado independentemente. Modularidade é investimento em flexibilidade: custa mais no design (interfaces, abstrações) mas preserva opções futuras. Na Mesh: arquitetura modular (CUE schemas, camada de liquidação separável, scoring separável de matching) preserva opções de switch (ro-option-to-switch) e expansão (ro-option-to-expand). Monolito (tudo acoplado) é mais barato no curto prazo mas destrói opções. Gans/Stern/Wu (2019): arquitetura modular é meta-opção — a opção de ter opções. Cada decisão de arquitetura é decisão de quanto investir em meta-opção."
			meshManifestation: "Scoring como módulo: se separado de matching e antecipação, pode ser substituído (V1 → V2) sem reescrever matching. Se acoplado: mudar scoring requer reescrever matching. Liquidação como módulo: se separável, Drex substitui registradora sem afetar scoring. Se acoplado: Drex requer reescrever tudo. Lenses como módulos: cada lense é módulo de conhecimento (oe-context-window-constraint). Se modular: adicionar lense de infraestrutura sem reescrever construção civil. Se monolítico: cada adição exige refatorar."
			meshImplication: "Para cada decisão de arquitetura: (1) quais opções futuras esta arquitetura preserva ou destrói? (2) O custo de modularidade (interfaces, abstrações) é justificado pelo valor das opções preservadas? Se incerteza é alta e opções de switch/expansão são valiosas: investir em modularidade. Se incerteza é baixa e caminho é claro: monolito é mais eficiente. Na Mesh pré-revenue com incerteza alta: modularidade é investimento correto. Para design: scoring, matching, liquidação, compliance como módulos com interfaces definidas. CUE como interface entre lenses. API de registradora como interface de liquidação (substituível por Drex). Cada módulo: substituível sem afetar adjacentes. Custo: design mais caro no início. Retorno: opções preservadas."
			dependsOn: ["ro-option-to-switch", "ro-option-to-expand"]
			rationale: "Baldwin/Clark: modularidade = meta-opção. Investir quando incerteza alta."
		},
		{
			id:         "ro-learning-and-option-value"
			name:       "Aprendizado como Fonte de Valor de Opção (Adner/Levinthal 2004)"
			nature:     "theoretical"
			role:   "property"
			definition: "Adner/Levinthal (2004): real options interagem com aprendizado organizacional. Cada opção exercida gera aprendizado que muda o valor das opções remanescentes. Aprendizado pode aumentar valor (descoberta de oportunidade) ou diminuir (descoberta de limitação). O viés: organizational learning tende a explotar o conhecido (exploitation bias) — agente aprende mais sobre o que já faz e menos sobre alternativas. Isso reduz perceived value de opções não exercidas (parecem mais arriscadas porque menos conhecidas) e aumenta perceived value da opção exercida (parece mais segura porque mais conhecida). Na Mesh: cada mês de operação na construção civil gera aprendizado que (a) melhora scoring (data-enabled learning — gt-competitive-dynamics), (b) melhora artefatos (oe-organizational-knowledge), mas (c) reduz propensão a explorar alternativas (construção civil parece 'o caminho' porque é o mais conhecido). O framework prescreve: reconhecer que aprendizado é tanto ativo (melhora decisão atual) quanto viés (reduz exploração de alternativas)."
			meshManifestation: "12 meses na construção civil: scoring calibrado, sazonalidade entendida, Kraljic mapeado, anchors identificados. Opção de expandir para infraestrutura existe — mas parece arriscada porque 'não conheço infraestrutura.' Na realidade: infraestrutura pode ter ROI superior, mas aprendizado em construção civil viesa a percepção. Adner/Levinthal: o founder que passou 12 meses aprendendo construção civil sobrestima o valor de continuar e subestima o valor de expandir."
			meshImplication: "Para avaliação de opções: corrigir para learning bias. Se opção de expansão parece arriscada: é porque genuinamente arriscada ou porque é menos conhecida (aprendizado concentrado no atual)? Para correção: avaliar opções com dados objetivos (TAM, competição, transferibilidade de scoring) não com feeling ('construção civil parece mais seguro'). Para aprendizado como ativo: cada dado operacional é investimento que melhora opções atuais E pode melhorar futuras (se transferível). Para aprendizado como viés: revisão anual de opções de expansão com critérios objetivos — não 'deveríamos expandir?' (que aprendizado viesa para 'não') mas 'dados objetivos suportam expansão? TAM > [X], transferibilidade > [Y%], competição < [Z]?' Para tension-log: registrar quando opção foi avaliada e rejeitada — e por quê. Se razão é 'não conheço': flag de learning bias."
			dependsOn: ["ro-option-to-expand", "ro-experimentation-as-option"]
			rationale: "Adner/Levinthal: aprendizado é ativo e viés. Learning bias reduz exploração. Corrigir com dados objetivos."
		},
		{
			id:            "ro-mesh-options-portfolio"
			name:          "Portfólio de Opções da Mesh: Inventário e Avaliação"
			nature:        "operational"
			role:   "heuristic"
			reviewCadence: "semi-annual"
			definition:    "Inventário das opções reais da Mesh com avaliação qualitativa (não quantitativa — real options pricing é intratável para a maioria das decisões empreendedoras). Para cada opção: tipo (esperar, expandir, abandonar, switch), custo de exercício estimado, incerteza relevante (e se se resolve com tempo), valor estimado (qualitativo: alto/médio/baixo), prazo (quando expira ou quando informação chega), preemption risk, e status (alive, exercised, expired, abandoned). Opções da Mesh por categoria: (a) Regulatórias: SCD (esperar vs obter — incerteza: Bacen reinterpreta?), FIDC próprio (esperar vs montar — incerteza: volume justifica?), Open Finance (aderir vs esperar — incerteza: reciprocidade?). (b) Mercado: novo segmento (expandir — incerteza: demanda + transferibilidade), novo produto (expandir — incerteza: willingness to pay), geography (expandir). (c) Tecnológicas: Drex (esperar — incerteza: timing + formato), modelo de IA (switch — incerteza: capability shifts), schema/arquitetura (switch — custo: path dependence). (d) Operacionais: anchor (abandonar se gate não atingido — incerteza: engajamento), scoring methodology (switch — custo: recalibração + comunicação), via regulatória (switch: correspondente → FIDC → SCD)."
			meshManifestation: "Bootstrap: maioria das opções alive (não exercidas). Conforme avança: algumas exercidas (correspondente → FIDC), algumas expiradas (anchor que não engajou), algumas abandonadas (scoring V1 que não discriminou). Revisão semi-annual: quais opções novas surgiram? Quais expiraram? Quais deveriam ser exercidas?"
			meshImplication: "Inventário semi-annual. Para cada opção: status + avaliação + próximo gate. Se opção está alive e preemption risk crescente: considerar exercer antes do gate ideal (trade-off informação vs preemption). Se opção está alive mas incerteza não se resolve com tempo: exercer ou abandonar — esperar não agrega. Se opção expirou sem ser notada: flag de atenção (founder não estava monitorando). Para learning bias (ro-learning-and-option-value): revisar opções de expansão com critérios objetivos anualmente. Para Tipo 7: inventário previne que founder crie opções novas sem exercer ou abandonar as existentes (acúmulo de opcionalidade sem decisão — que é procrastinação disfarçada de estratégia)."
			rationale: "Inventário qualitativo. Avaliação por critérios. Preemption risk. Learning bias. Tipo 7: acúmulo de opções sem decisão."
		},
	]

	reasoningProtocol: [
		{
			question:  "A decisão envolve investimento irreversível sob incerteza? Qual o grau de irreversibilidade (alto: SCD, licença. Médio: tecnologia, metodologia. Baixo: pricing, feature)? Qual incerteza (regulatória, mercado, tecnológica)? A incerteza se resolve com tempo? Se sim: esperar tem valor (Dixit/Pindyck). Se não (incerteza permanente): esperar não ajuda."
			reveals:   "Se irreversibilidade alta + incerteza resolúvel: esperar. Se irreversibilidade baixa: agir (downside limitado). Se incerteza permanente: NPV decide."
			rationale: "Bloom: incerteza eleva threshold."
		},
		{
			question:  "Existe preemption risk? Concorrente pode capturar dados/rede/posição se Mesh espera? Qual a janela (< 12 meses: preemption domina; > 24 meses: esperar viável)? O custo de experimentação é baixo o suficiente para testar rápido E mover rápido (Ewens)?"
			reveals:   "Se preemption risk alto + janela curta: investir mais rápido, aceitar mais risco. Se baixo: esperar com experimentação."
			rationale: "Smit/Trigeorgis: competição reduz option value de esperar."
		},
		{
			question:  "A decisão pode ser decomposta em gates (staging)? Qual premissa está sendo testada? Custo mínimo do teste? Critérios de continuar/pivotar/abandonar definidos antes? Sequência: premissa mais arriscada primeiro (McGrath)."
			reveals:   "Se decomponível: staging reduz risco. Se não (decisão binária): commitment vs flexibilidade direto."
			rationale: "McGrath: premissas sequenciais com gates."
		},
		{
			question:    "O resultado do experimento/teste mudaria a decisão? Se founder faria a mesma coisa independente do resultado: teste é desperdício (Gans/Stern/Wu). O teste tem prazo definido? Se sem prazo: vira projeto (não é opção — é sunk cost acumulando)."
			reveals:     "Teste que não muda decisão = desperdício. Sem prazo = procrastinação."
			appliesWhen: "proposta de experimento, MVP, teste de hipótese"
			rationale:   "Gans: teste vale se muda decisão. Prazo força gate."
		},
		{
			question:    "Quais opções futuras esta decisão cria ou destrói? NPV direto + valor de opções? Se modular: preserva opções. Se específico/monolítico: destrói. Se investimento em dados transferíveis: opção de expansão. Se dados muito específicos: opção limitada."
			reveals:     "Valor total = NPV + opções. Modularidade preserva. Especificidade destrói."
			appliesWhen: "decisão de arquitetura, tecnologia, segmento, ou investimento estratégico"
			rationale:   "Gans/Stern/Wu: portfólio de opções."
		},
		{
			question:    "Existe sunk cost bias? Founder está continuando porque informação justifica ou porque já investiu? Se gate não atingido: abandonar é decisão correta, não fracasso (Manso). Se abandono é por fuga (Tipo 7: novo é mais excitante): não é opção real. Critérios de abandono foram definidos antes?"
			reveals:     "Sunk cost bias: continuar sem justificativa. Tipo 7: abandonar sem justificativa. Critérios ex ante resolvem ambos."
			appliesWhen: "decisão de continuar vs abandonar caminho, OU Tipo 7 quer mudar para algo novo"
			rationale:   "Manso + sunk cost. Critérios ex ante."
		},
		{
			question:    "Commitment ou flexibilidade? Incerteza residual alta → flexibilidade. Competição exige → commitment. Credibilidade exige → commitment seletivo. Irreversibilidade alta → cautela. O commitment é nas dimensões certas (credibilidade: scoring, pricing) e flexibilidade nas certas (features, segmento)?"
			reveals:     "Commitment seletivo: credibilidade onde importa, flexibilidade onde muda."
			appliesWhen: "decisão de comprometer-se com preço, tecnologia, parceiro, ou segmento"
			rationale:   "Smit/Trigeorgis + Schelling."
		},
		{
			question:    "Learning bias: opção de expansão parece arriscada porque genuinamente é ou porque é menos conhecida? Dados objetivos (TAM, competição, transferibilidade) suportam avaliação? Se rejeitou opção por 'não conheço': flag."
			reveals:     "Aprendizado viesa: familiar parece seguro, novo parece arriscado. Corrigir com dados."
			appliesWhen: "avaliação de opção de expansão, ou revisão do portfólio"
			rationale:   "Adner/Levinthal."
		},
	]

	meshExamples: [
		{
			id:       "ex-scd-timing"
			scenario: "Mesh opera como servicer de FIDC terceirizado há 8 meses. Volume crescente. Questão: obter SCD agora ou esperar?"
			analysis: "Irreversibilidade: alta (R$500k + 12 meses + capital mínimo). Incerteza: (a) Bacen pode exigir para servicer que origina (rs-regulatory-risk) — incerteza regulatória que se resolve com tempo (Bacen publica ou não). (b) Volume justifica internalizar (incerteza de mercado — resolúvel com mais dados de volume). Preemption: concorrente com SCD pode oferecer produtos que Mesh não pode (conta, crédito direto) — mas esses produtos são necessários agora? Se fornecedores estão satisfeitos com antecipação via FIDC: preemption limitada. Gates: gate seria 'volume > [R$X M/mês] por 3 meses consecutivos E regulação clarifica OR tendência forte.' Opções criadas: SCD habilita conta transacional (opção de expandir produto). Opções destruídas: capital imobilizado reduz runway (opção de esperar erode). Learning bias: 8 meses de operação na construção via FIDC fazem SCD parecer 'próximo passo natural' — mas pode ser que melhorar FIDC gere mais valor. Tipo 7: SCD é projeto novo e excitante. FIDC existente é tedioso."
			recommendation: "(1) Não obter agora — incerteza regulatória resolúvel com tempo (Bacen), volume não atingiu gate. (2) Gate definido: volume > [R$X M/mês] por 3 meses E (Bacen exige OU produtos de SCD têm demanda validada). (3) Preparar: documentação, capital provisório, governança — para que quando gate for atingido, processo leve 6 meses não 18. Custo de preparação é prêmio da opção — baixo comparado com investimento total. (4) Preemption check: monitorar se concorrente com SCD captura fornecedores que Mesh não atende. Se sim: reavaliar timing. (5) Tipo 7 check: 'estou querendo SCD porque é necessário ou porque FIDC é tedioso?' Se segundo: voltar para exploitation."
			assumptions: [
				"volume não atingiu gate — verificar",
				"Bacen não clarificou — monitorar",
				"preparação reduz tempo — verificar processo",
				"preemption limitada — monitorar churn",
			]
			principlesApplied: ["ax-03", "dp-04", "dp-07"]
			rationale: "Irreversibilidade alta + incerteza resolúvel = esperar com preparação. Gate definido. Preemption monitorada. Tipo 7 check."
		},
		{
			id:       "ex-new-segment-option"
			scenario: "Após 14 meses na construção civil, founder considera expandir para infraestrutura. Scoring calibrado, churn controlado, 3 anchors."
			analysis: "Opção de expansão: infraestrutura (energia, saneamento, transporte). Incerteza: demanda, transferibilidade de scoring, novos anchors. Custo de exercício: novo Kraljic, adaptação de scoring, onboarding de segmento, branding (alto). Valor: TAM de infraestrutura > construção civil. Learning: 14 meses de construção civil geram expertise transferível (parcialmente — supply chain finance é similar, sazonalidade e materiais são diferentes). Learning bias (Adner/Levinthal): construção civil parece mais segura porque é conhecida. Infraestrutura parece arriscada porque não é. Verificar com dados: TAM de infraestrutura, competição, overlap de fornecedores/compradores. Gates: gate 0 (custo ~zero): 10 conversas com construtoras de infraestrutura. Se demanda confirmada: gate 1 (custo: R$XX, 3 meses): pilotar com 1 construtora de infra, testar scoring existente. Se scoring discrimina: gate 2 (custo: R$XXX, 6 meses): adaptar e escalar. Se não discrimina: adaptar scoring (custo de switch). Exploitation check (oe-exploration-exploitation): construção civil exploitation está estável? Se sim: exploration com [20%] bandwidth e gates."
			recommendation: "(1) Não exercer opção agora — gates primeiro. (2) Gate 0: 10 conversas (custo: 2 semanas). 'Resultado muda decisão?' Se nenhuma construtora de infra quer: opção não vale (Gans). Se 3+ querem: gate 1. (3) Gate 1: pilotar com 1 construtora. Scoring existente funciona? AUROC em infra > [0.65]? Se sim: adaptação marginal. Se não: custo de switch alto. (4) Learning bias check: 'estou rejeitando infra porque é genuinamente pior ou porque construção é mais familiar?' TAM + competição + transferibilidade como critérios objetivos. (5) Exploitation check: se construção estável (scoring calibrado, churn OK, lenses active): exploration com gates é adequada. Se instável: não explorar. (6) Opções preservadas: modularidade — scoring com camada genérica + específica. Se genérica funciona em infra: opção é mais valiosa."
			assumptions: [
				"exploitation estável — verificar métricas",
				"transferibilidade parcial — testar em gate 1",
				"TAM infra > construção — pesquisar",
				"10 conversas mudam decisão — founder comprometido com resultado",
			]
			principlesApplied: ["ax-03", "ax-05", "dp-07"]
			rationale: "Opção de expansão com gates. Learning bias check. Exploitation stable. Modularidade preserva."
		},
		{
			id:       "ex-scoring-pivot"
			scenario: "Scoring V1 (linear, 8 variáveis) operando há 5 meses. AUROC: 0.62. Target: 0.70. Founder quer pivotar para ML-based scoring."
			analysis: "Opção de switch: V1 → ML. Custo de switch: desenvolvimento (agente IA: semanas), recalibração (dados existentes), comunicação a participantes (ct-commitment-and-optionality: se pricing mudou = reference point shift → aggrievement), credibilidade (gt-commitment-credibility: se scoring muda frequentemente = 'instável'). Sunk cost: 5 meses de V1. Opção de abandonar V1: gate não atingido (AUROC 0.62 < 0.70). Se critério pré-definido era 'AUROC > 0.70 em 6 meses': tem 1 mês para atingir ou pivotar. Informação: 0.62 é por falta de dados (5 meses) ou por modelo inadequado? Se dados: esperar mais 3 meses (informação resolve incerteza). Se modelo: pivotar (incerteza não se resolve com tempo no V1). Regulatory: se PL de IA exige explicabilidade (rs-ai-regulation-scoring), ML pode ser menos explicável que linear (Carroll 2015: linearidade como defesa regulatória). ML com AUROC 0.75 mas inexplicável vs linear com 0.68 e explicável: trade-off real."
			recommendation: "(1) Diagnóstico: AUROC 0.62 é por dados insuficientes ou modelo? Se AUROC melhora com cada mês de dados (tendência positiva): dados → esperar 2-3 meses. Se estagnado (5 meses sem melhoria): modelo → pivotar. (2) Se pivotar: não para ML full — para V1.5 (mais variáveis no modelo linear). Carroll: linearidade é maxmin-ótima sob incerteza de ações E defesa regulatória. ML com AUROC marginal melhor mas inexplicável: pior trade-off. (3) Se V1.5 não atinge em 3 meses: então ML com explicabilidade (SHAP values, feature importance documentada). (4) Comunicação: 'scoring evolui com dados' (já comunicado). Mudança de metodologia: comunicar ao gestor FIDC antes (rs-fidc-regulatory-framework: decisão que afeta FIDC). (5) Sunk cost: 5 meses de V1 não são argumento para manter V1. Critério é forward-looking: V1 atinge 0.70? Se não: pivotar. (6) Tipo 7: 'estou pivotando porque informação justifica ou porque ML é mais excitante que calibrar V1?' Se V1 tem tendência positiva e founder quer ML: provavelmente excitação."
			assumptions: [
				"AUROC 0.62 é diagnóstico real — verificar",
				"tendência de AUROC — plotar por mês",
				"V1.5 viável — mais variáveis disponíveis?",
				"PL de IA explicabilidade — monitorar tramitação",
			]
			principlesApplied: ["ax-03", "dp-04", "dp-07"]
			rationale: "Gate: AUROC 0.70 em 6 meses. Dados vs modelo: esperar ou pivotar. Carroll: linearidade como defesa. Sunk cost: forward-looking. Tipo 7 check."
		},
	]

	principleIds: ["ax-03", "ax-05", "dp-04", "dp-07"]

	relatedLenses: [
		{
			lensId:   "lens-organizational-economics"
			relation: "complementsWith"
			context:  "OE modela bandwidth e delegação. RO modela timing e sequência de uso da bandwidth. oe-exploration-exploitation: RO formaliza — exploration é exercer opção de expansão; exploitation é capturar valor de opção exercida. oe-solo-founder-bottleneck: gates são decisões tipo 3 do founder — timing de gate é design temporal (oe-cadência). Learning bias interage com multitask distortion."
		},
		{
			lensId:   "lens-game-theory-applied"
			relation: "complementsWith"
			context:  "GT modela interação estratégica. RO modela timing. Smit/Trigeorgis (2017): real options em jogos — preemption reduz option value de esperar. gt-competitive-dynamics: janela competitiva é prazo de opção. gt-commitment-credibility: commitment é exercício de opção. gt-switching-costs: lock-in é destruição de opção de switch."
		},
		{
			lensId:   "lens-regulatory-strategy"
			relation: "complementsWith"
			context:  "RS modela landscape regulatório. RO modela timing de licenciamento. rs-licensing-sequencing é staging de opções regulatórias. rs-regulatory-risk: incerteza regulatória eleva threshold (Bloom). SCD é opção de esperar. FIDC próprio é opção de expandir. Drex é opção futura."
		},
		{
			lensId:   "lens-contract-theory"
			relation: "complementsWith"
			context:  "CT modela termos. RO modela timing. ct-commitment-and-optionality: commitment é exercício de opção (Hart/Moore reference point). ct-contract-menu: camadas são staging (A → B → C é exercício progressivo). Renegociação: opção preservada por ajuste automático."
		},
		{
			lensId:   "lens-platform-dynamics"
			relation: "complementsWith"
			context:  "PD modela crescimento. RO modela sequência. pd-chicken-and-egg: sequência de entrada é staging com gates. pd-critical-mass: massa crítica é gate. pd-data-network-effects: cada dado é investimento em opção de scoring futuro."
		},
		{
			lensId:   "lens-complex-adaptive-systems"
			relation: "complementsWith"
			context:  "CAS modela adaptação. RO formaliza. cas-path-dependence: cada opção exercida é path dependence. cas-adaptation-goodhart: scoring V1 que underperforms pode ser por Goodhart (gaming) ou por modelo — diagnóstico muda a opção (recalibrar vs pivotar)."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "BE modela vieses. RO interage. be-sunk-cost: bias contra abandonar opção exercida. be-overconfidence: sobrestima valor de opção favorita. be-present-bias: subestima valor de opção futura. Tipo 7 exploration bias: cria opções sem exercer. Tipo 7 under stress (→1): congela e não exerce nenhuma."
		},
		{
			lensId:   "lens-supply-chain-theory"
			relation: "complementsWith"
			context:  "SCT modela cadeia. RO: dados operacionais são investimento em opção de scoring futuro (learning). sc-scf-mechanism: loop dados→scoring→taxa→participantes é exercício progressivo de opção. Cada dado é prêmio."
		},
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "MD projeta mecanismos. RO modela quando implementar. Menu de contratos: implementar camada C agora (commitment) ou manter apenas A e B (preservar opção de ajustar C com mais dados)?"
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "complementsWith"
			context:  "FI modela funding. RO: FIDC próprio é opção de expansão. Subordinação é commitment (capital). Skin in the game é custo de opção (prêmio para obter FIDC). Staging: FIDC terceirizado → próprio."
		},
	]

	limitations: [
		{
			description: "Real options pricing formal (Black-Scholes adaptado, binomial trees) é intratável para decisões empreendedoras — parâmetros (volatilidade, correlações) são desconhecidos."
			alternative: "Avaliação qualitativa: alto/médio/baixo para valor, custo, incerteza. Inventário de opções com status. Não tentar precificar — tentar ordenar e priorizar."
			rationale: "Qualitativo > nada. Quantitativo preciso é ilusão."
		},
		{
			description: "Tipo 7 pode usar real options como justificativa para nunca decidir — 'estou preservando opcionalidade' é indistinguível de procrastinação."
			alternative: "Gates com prazo forçam decisão. Se opção está alive sem gate há > [6 meses]: é procrastinação disfarçada. Revisão semi-annual do inventário. Cada opção precisa de próximo gate com data."
			rationale: "Opcionalidade sem gate = procrastinação."
		},
		{
			description: "TDAH pode fazer founder exercer opções prematuramente (hyperfocus → commitment impulsivo) e abandonar sem fundamentação."
			alternative: "Critérios de exercício e abandono definidos antes (ex ante). Se founder quer exercer/abandonar fora de gate: pausa de 48h + tension-log antes de decidir."
			rationale: "Impulsividade mitigada por delay e critérios."
		},
		{
			description: "Learning bias (Adner/Levinthal) é difícil de auto-diagnosticar — founder não sabe o que não sabe sobre alternativas."
			alternative: "Revisão anual de opções de expansão com dados objetivos (TAM, competição, transferibilidade). Se rejeição de opção é por 'não conheço': flag explícito, não descarte."
			rationale: "Dados > feeling."
		},
		{
			description: "Modularidade tem custo real de design — interfaces, abstrações, overhead. Pode ser over-engineering para startup que precisa de velocidade."
			alternative: "Modularidade proporcional à incerteza: se caminho é claro, monolito é OK. Se incerto: modular. Construção civil com 4 cenários regulatórios em andamento: modularidade justificada."
			rationale: "Modularidade proporcional."
		},
		{
			description: "Preemption risk é estimativa — founder não sabe quando concorrente se move."
			alternative: "Monitorar sinais (gt-competitive-dynamics: churn competitivo, lançamento de produto). Se sinal: reavaliar timing. Se sem sinal: manter gates."
			rationale: "Sinais > previsão."
		},
		{
			description: "Inventário de opções pode crescer indefinidamente — cada ideia é 'opção.' Sem disciplina: portfólio de opções vira backlog infinito."
			alternative: "Cap: [10-15] opções alive simultaneamente. Se quer adicionar: remover uma (abandonar ou exercer). Forçar priorização."
			rationale: "Portfólio finito."
		},
	]

	rationale: "NPV não basta sob incerteza — esperar tem valor se informação resolve incerteza e investimento é irreversível (Dixit/Pindyck 1994, Bloom 2009). Na Mesh: quase toda decisão é irreversível sob incerteza tripla (mercado, regulação, tecnologia). Staging com gates (Trigeorgis, McGrath, Huchzermeier/Loch) decompõe investimento em etapas — cada gate testa premissa mais arriscada com custo mínimo. Experimentação é compra de opção (Kerr/Nanda/Rhodes-Kropf 2014) — teste só vale se resultado muda decisão (Gans/Stern/Wu 2019). Custo de experimentação é baixo em organização IA-first (Ewens/Nanda/Rhodes-Kropf 2018). Preemption (Smit/Trigeorgis 2017, Lambrecht/Perraudin 2003) reduz option value de esperar quando concorrente captura dados/rede. Commitment seletivo: credibilidade onde importa (scoring, pricing), flexibilidade onde muda (features, segmento). Modularidade é meta-opção (Baldwin/Clark 2000) — investir quando incerteza alta. Aprendizado é ativo (melhora decisão) e viés (reduz exploração — Adner/Levinthal 2004). Opção de abandonar limita downside — critérios ex ante previnem sunk cost bias e Tipo 7 fuga. Tolerância ao fracasso (Manso 2011) como condição de inovação. Portfólio de opções com inventário, gates e cap (não backlog infinito)."
}