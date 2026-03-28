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
	]
}
