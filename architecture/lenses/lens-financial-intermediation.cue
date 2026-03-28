package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

financialIntermediation: artifact_schemas.#AnalyticalLens & {
	id:      "lens-financial-intermediation"
	name:    "Intermediação Financeira"
	purpose: "Analisar como a Mesh financia antecipações, estrutura veículos e funding, transforma maturidade e risco, administra liquidez, subordinação, covenants e continuidade de funding em cada estágio de escala."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve de onde vem o dinheiro para antecipar recebíveis",
			"a decisão envolve estrutura de funding (capital próprio, FIDC, parceiro bancário, warehouse)",
			"a decisão envolve descasamento de prazos entre captação e aplicação",
			"a decisão envolve capacidade de atender demanda de antecipação",
			"a decisão envolve o que acontece se muitos fornecedores pedem antecipação ao mesmo tempo",
			"a decisão envolve priorização de quem antecipa quando liquidez é escassa",
			"a decisão envolve o papel da Mesh como intermediário entre quem tem dinheiro e quem precisa",
			"a decisão envolve estruturação societária ou veículos para operação de crédito",
			"a decisão envolve subordinação, credit enhancement ou estruturação de FIDC",
			"a decisão envolve cessão de recebíveis para veículo de securitização",
			"a decisão envolve elegibilidade de recebíveis ou covenants de carteira",
			"a decisão envolve run risk, capacidade de rolagem ou continuidade de funding",
			"a decisão envolve custo real de capital e viabilidade econômica da operação",
		]
		keywords: [
			"funding", "liquidez", "FIDC", "cota", "subordinação",
			"warehouse", "capital", "captação", "maturity mismatch",
			"descasamento", "run risk", "corrida", "resgate",
			"priorização", "fila", "capacidade", "alocação de capital",
			"SCD", "estrutura societária", "veículo", "SPE",
			"custo de capital", "WACC", "linha de crédito",
			"elegibilidade", "covenant", "amortização antecipada",
			"servicer", "commingling", "true sale", "first-loss",
			"cota sênior", "cota subordinada", "rating",
			"IOF", "IRRF", "tributação", "revolving", "warehouse line",
			"credit enhancement", "bankruptcy remoteness", "escrow",
		]
		excludeWhen: [
			"a decisão é sobre risco de default ou composição de carteira de crédito sem componente de liquidez ou funding — usar credit-risk",
			"a decisão é sobre design de incentivos ou regras de interação — usar mechanism-design",
			"a decisão é sobre licenciamento ou compliance regulatório sem componente de estruturação financeira — usar regulatory-strategy",
			"a decisão é sobre pricing de antecipação sem questão de funding ou liquidez — usar credit-risk e mechanism-design",
			"a decisão é sobre fronteira organizacional de build vs buy sem foco na estrutura financeira — usar theory-of-firm",
		]
		rationale: "A Mesh senta entre quem tem dinheiro e quem precisa dele. O problema não é apenas se o devedor paga ou não; é também se a Mesh consegue financiar a antecipação, em que veículo, com qual custo real, com qual subordinação, com qual risco de liquidez, com qual proteção jurídica e com qual resiliência quando o mercado seca. Sem esta lens, o agente desenha antecipação como se liquidez fosse infinita, funding fosse neutro e covenants fossem detalhe operacional."
	}

	concepts: [
		{
			id:                "fi-intermediation-role"
			name:              "O Papel do Intermediário Financeiro"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Um intermediário financeiro existe porque reduz custo de coordenação entre quem tem capital e quem precisa dele. Suas funções clássicas incluem monitoramento delegado, transformação de maturidade, transformação de risco e produção de informação. O spread remunera esse conjunto, não apenas o risco de crédito pontual."
			meshManifestation: "A Mesh monitora compradores e fornecedores com dados que investidores não veem diretamente, antecipa recebíveis curtos para transformar tempo e caixa, combina múltiplos ativos para diluir risco e produz informação proprietária via integração entre dinheiro e operação."
			meshImplication:   "A Mesh não pode ser tratada como simples software que conecta partes. Ela é intermediário financeiro de fato, com responsabilidades próprias de funding, liquidez, governança de veículos e credibilidade perante investidores e parceiros."
			rationale:         "Sem esse enquadramento, o agente subestima a profundidade econômica da operação."
		},
		{
			id:                "fi-regulatory-vehicle"
			name:              "Veículo Regulatório e Estrutura de Operação"
			nature:            "operational"
			role:              "framework"
			reviewCadence:     "annual"
			definition:        "A estrutura regulatória define o que a Mesh pode fazer, com que funding e em que sequência. SCD, FIDC, correspondente bancário, parceiro bancário e estruturas afins não são equivalentes; cada uma altera limites de funding, escopo operacional, lead time e custo de escala."
			meshManifestation: "No bootstrap, a Mesh pode operar com capital próprio via estrutura permitida e depois ceder créditos para FIDC para ganhar escala. A sequência regulatória importa porque o funding economicamente desejável pode depender de uma estrutura ainda não disponível."
			meshImplication:   "A sequência regulatória deve preceder a sequência financeira. Não faz sentido modelar escala via FIDC, warehouse ou estrutura híbrida sem ter mapeado o caminho legal e o lead time correspondente."
			dependsOn:         ["fi-intermediation-role"]
			rationale:         "A intermediação é moldada pelo que a estrutura regulatória permite."
		},
		{
			id:                "fi-funding-structure"
			name:              "Estrutura de Funding por Estágio"
			nature:            "operational"
			role:              "framework"
			reviewCadence:     "semi-annual"
			definition:        "Funding não é monolítico. Capital próprio, warehouse, FIDC aberto, FIDC fechado, parceiro bancário e estruturas mistas têm custos, capacidade, velocidade, optionality e riscos distintos. Cada estágio da Mesh tende a usar combinação diferente."
			meshManifestation: "Bootstrap tende a operar com capital próprio e capacidade limitada. Escala exige transição para estruturas com capital de terceiros. Funding mais barato geralmente vem com mais governança, mais covenants e menos flexibilidade."
			meshImplication:   "A Mesh deve pensar funding como sequência evolutiva, não como escolha única. A pergunta correta é: qual estrutura é adequada agora, qual vem depois, e qual lead time exige preparação antecipada?"
			dependsOn:         ["fi-regulatory-vehicle"]
			rationale:         "Sem sequência, a Mesh chega ao limite de capital sem ponte para a etapa seguinte."
		},
		{
			id:                "fi-fidc-structure"
			name:              "Estrutura do FIDC: Subordinação, Elegibilidade e Covenants"
			nature:            "operational"
			role:              "framework"
			reviewCadence:     "semi-annual"
			definition:        "O FIDC não é funding genérico; é veículo com regras próprias. Subordinação, critérios de elegibilidade, covenants, eventos de amortização e estrutura revolving ou amortizante definem custo, escala real e robustez do veículo."
			meshManifestation: "A Mesh pode originar recebíveis que, no papel, parecem bons para o negócio, mas que não entram no FIDC por prazo, concentração, tipo de lastro ou forma de confirmação. Mesmo quando entram, a subordinação exigida consome capital próprio relevante."
			meshImplication:   "A política de originação precisa nascer compatível com o veículo de funding. Recebível bom para a operação, mas inelegível para o FIDC, é ativo que consome capacidade errada. Covenant não é detalhe; é gatilho potencial de interrupção do funding."
			dependsOn:         ["fi-funding-structure"]
			rationale:         "O FIDC molda a carteira tanto quanto a carteira molda o FIDC."
		},
		{
			id:                "fi-true-sale-commingling"
			name:              "True Sale, Segregação Patrimonial e Commingling"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Para que o veículo seja robusto, os ativos precisam estar efetivamente segregados da Mesh, a cessão precisa ser economicamente e juridicamente defensável, e os fluxos precisam evitar mistura indevida entre caixa operacional e caixa do veículo."
			meshManifestation: "Se o recebível cedido ao FIDC ainda é disputável em insolvência da Mesh, ou se o dinheiro do comprador transita por contas operacionais antes de chegar ao veículo, o risco estrutural aumenta e a qualidade do funding piora."
			meshImplication:   "True sale, bankruptcy remoteness e mitigação de commingling devem ser tratados como fundação da estrutura, não como refinamento posterior. Sem isso, rating, custo e confiança do investidor degradam."
			dependsOn:         ["fi-fidc-structure", "fi-regulatory-vehicle"]
			rationale:         "Sem segregação jurídica e operacional, a intermediação fica estruturalmente frágil."
		},
		{
			id:                "fi-servicer-risk"
			name:              "Risco de Servicer e Continuidade Operacional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quem origina ou monitora a carteira pode também ser o servicer, mas isso cria risco operacional específico: se o servicer falha, a carteira e o funding sofrem mesmo sem deterioração intrínseca dos ativos."
			meshManifestation: "A Mesh pode ser excelente em originar e monitorar, mas ainda assim ser percebida como servicer mais frágil do que banco ou operador estabelecido. Para investidores, isso afeta confiança e custo."
			meshImplication:   "Servicer backup, documentação de processos, separação funcional e continuidade operacional precisam existir cedo. Em estruturas com FIDC, esse risco é parte do produto financeiro, não apenas da operação interna."
			dependsOn:         ["fi-intermediation-role", "fi-fidc-structure"]
			rationale:         "Funding de terceiros compra a carteira, mas também compra a capacidade da Mesh de servi-la."
		},
		{
			id:                "fi-maturity-transformation"
			name:              "Transformação de Maturidade e Maturity Mismatch"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A intermediação transforma prazos. Quando o funding vence, pode ser resgatado ou precisa ser rolado antes do vencimento econômico dos ativos, surge risco de maturity mismatch."
			meshManifestation: "Mesmo com recebíveis bons, a Mesh pode entrar em aperto se o funding é mais curto, mais instável ou mais sensível do que a maturidade média da carteira."
			meshImplication:   "Maturity gap precisa ser monitorado explicitamente. Estruturas de funding que parecem baratas podem carregar fragilidade excessiva se exigem rolagem frequente ou estão expostas a secas de mercado."
			dependsOn:         ["fi-funding-structure"]
			rationale:         "A clássica crise do intermediário não é só insolvência; é liquidez insuficiente no tempo errado."
		},
		{
			id:                "fi-liquidity-risk"
			name:              "Risco de Liquidez"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Risco de não conseguir atender saídas, nova demanda de antecipação ou obrigações do veículo, apesar de a carteira poder ser economicamente boa. Liquidez e crédito são riscos diferentes, com velocidades diferentes."
			meshManifestation: "A carteira pode estar saudável, mas a demanda por antecipação pode exceder caixa disponível. Ou o mercado pode fechar para novas séries, resgates ou warehouse exatamente quando a demanda aumenta."
			meshImplication:   "A Mesh precisa modelar buffer de liquidez, janelas de estresse, concentração temporal de vencimentos e política de escassez. Funding congelado por 30, 60 ou 90 dias precisa ser cenário padrão de análise."
			dependsOn:         ["fi-maturity-transformation", "fi-funding-structure"]
			rationale:         "Liquidez mata mais rápido do que crédito."
		},
		{
			id:                "fi-run-risk"
			name:              "Risco de Corrida"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Run risk é a materialização extrema da perda de confiança. Sua forma concreta depende do funding: resgates, não rolagem, impossibilidade de nova série, early termination, ou fuga de fornecedores e parceiros."
			meshManifestation: "Com equity puro, não há run clássico de funding, mas há run de usuários. Em FIDC aberto, há resgate. Em FIDC fechado, a corrida aparece como secura na próxima emissão. Em warehouse, pode aparecer como saída abrupta do financiador."
			meshImplication:   "A Mesh precisa mapear run risk específico por estágio e por fonte de funding. A mitigação correta muda conforme a estrutura: lock-up, diversificação, comunicação, protocolo de crise, pipeline alternativo, buffer e confiabilidade operacional."
			dependsOn:         ["fi-liquidity-risk"]
			rationale:         "Corrida é dinâmica de confiança, não apenas de números."
		},
		{
			id:                "fi-ramp-up-reinvestment"
			name:              "Ramp-Up, Reinvestimento e Utilização do Veículo"
			nature:            "operational"
			role:              "framework"
			reviewCadence:     "semi-annual"
			definition:        "Veículos de funding precisam de pipeline compatível. Originação lenta, sazonalidade ou quebra de pipeline geram ociosidade, que corrói retorno e pode consumir subordinação."
			meshManifestation: "Na construção civil, sazonalidade e ciclos de projeto afetam geração de recebíveis. Um fundo lançado no momento errado pode carregar caixa quando deveria carregar ativos."
			meshImplication:   "Dimensionar veículo pelo pipeline sustentável, não pelo pico narrativo. Medir utilização e não relaxar originação para 'encher o fundo'. Caixa ocioso prolongado é sintoma estrutural, não ruído operacional."
			dependsOn:         ["fi-fidc-structure", "fi-funding-structure"]
			rationale:         "Funding sem pipeline adequado destrói retorno e incentiva adverse selection."
		},
		{
			id:                "fi-delegated-monitoring"
			name:              "Monitoramento Delegado"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Investidores aceitam expor capital porque delegam ao intermediário a função de monitorar, detectar deterioração e reagir cedo. Se o monitoramento não for melhor que a outside option, a intermediação perde legitimidade econômica."
			meshManifestation: "A vantagem da Mesh está em monitorar com dados que combinam operação e dinheiro. Se isso não resultar em detecção mais cedo, melhor discriminação e menos surpresa, o diferencial econômico perante capital externo fica fraco."
			meshImplication:   "Monitoramento deve ser reportado como capability financiável: detecção precoce, estabilidade do modelo, fraude capturada, qualidade de servicing, integridade do lastro. Funding escalável depende de essa função ser visível e crível."
			dependsOn:         ["fi-intermediation-role"]
			rationale:         "Investidores compram capacidade de monitoramento, não só ativos."
		},
		{
			id:                "fi-cost-of-capital"
			name:              "Custo de Capital e Spread Mínimo Viável"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "O custo real de capital inclui muito mais do que o custo aparente da tranche sênior ou da linha de funding. Deve incorporar custo da subordinação, custos estruturais, custo de oportunidade do capital retido, tributos, atrito operacional e margem mínima de sustentabilidade."
			meshManifestation: "Um FIDC com cota sênior aparentemente barata pode continuar economicamente pesado para a Mesh quando se inclui junior retida, estrutura, IOF, tributos, servicing e equity presa."
			meshImplication:   "O spread mínimo viável precisa ser calculado de forma completa. Decisão de go/no-go sobre antecipação, segmento ou estrutura de funding não pode usar custo parcial. Se o spread mínimo real fica acima da outside option do cliente, o modelo não fecha naquele recorte."
			dependsOn:         ["fi-funding-structure", "fi-fidc-structure"]
			rationale:         "Subprecificar custo de capital é forma silenciosa de autossabotagem."
		},
		{
			id:                "fi-capital-allocation"
			name:              "Alocação de Capital: Operação, Reserva, Crescimento e Subordinação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Capital próprio da Mesh disputa quatro usos ao mesmo tempo: suportar operação direta, cobrir buffers e UL, financiar crescimento, e ser retido como first-loss em estruturas escaláveis. Esses usos não são intercambiáveis sem custo."
			meshManifestation: "Quando a Mesh avança para FIDC, parte do equity deixa de estar disponível para crescimento e passa a ficar presa em subordinação. Isso pode dar a ilusão de escala sem mostrar o custo real de capital comprometido."
			meshImplication:   "Planejamento de capital deve explicitar quanto fica em operação, quanto em reserva, quanto em growth e quanto em first-loss. Toda rodada ou planejamento de caixa precisa refletir isso com clareza."
			dependsOn:         ["fi-cost-of-capital", "fi-fidc-structure"]
			rationale:         "Capital escasso mal alocado compromete funding e execução ao mesmo tempo."
		},
		{
			id:                "fi-funding-fragility"
			name:              "Fragilidade de Funding e Sequência de Colapso"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O funding pode quebrar por encadeamento: incidente reputacional, covenant breach, pipeline insuficiente, deterioração de servicing, concentração excessiva ou fechamento de mercado. O colapso raramente vem de um fator isolado."
			meshManifestation: "Uma fraude detectada tarde pode piorar confiança, aumentar spread da próxima série, reduzir capacidade, limitar atendimento de fornecedores, secar dados ativos e enfraquecer o core ao mesmo tempo."
			meshImplication:   "A Mesh precisa mapear a sequência de unraveling do funding: o que quebra primeiro, com que velocidade, e qual mitigação existe em cada elo. Sem isso, o plano de funding parece robusto até o momento em que deixa de existir."
			dependsOn:         ["fi-run-risk", "fi-liquidity-risk", "fi-delegated-monitoring"]
			rationale:         "Funding quebra por cadeia, não apenas por evento único."
		},
		{
			id:                "fi-mesh-funding-map"
			name:              "Mapa de Funding da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "Artefato vivo que registra estrutura atual de funding, custo real por fonte, subordinação exigida, covenants, buffers, ramp-up, pipeline, run risks específicos, triggers de transição e fragilidades principais."
			meshManifestation: "O mapa mostra o estágio atual, a próxima estrutura alvo, o lead time para chegar nela, as dependências regulatórias, os thresholds de reavaliação e os pontos de quebra mais prováveis."
			meshImplication:   "Toda decisão desta lens deve atualizar o funding map. Sem isso, a organização perde memória institucional sobre por que escolheu determinado funding, o que a estrutura exige e quando a decisão precisa ser revista."
			dependsOn: [
				"fi-funding-structure",
				"fi-fidc-structure",
				"fi-cost-of-capital",
				"fi-capital-allocation",
				"fi-funding-fragility",
			]
			rationale: "Sem mapa vivo, a intermediação vira sequência de decisões isoladas sem coerência temporal."
		},
	]
}
