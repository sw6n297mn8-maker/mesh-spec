package lenses

import "mesh-spec/architecture/artifact-schemas"

creditRisk: artifact_schemas.#AnalyticalLens & {
	id:      "lens-credit-risk"
	name:    "Risco de Crédito e Dinâmicas de Carteira"
	purpose: "Modelar a exposição econômica, jurídica e estatística criada por antecipação de recebíveis na Mesh, distinguindo risco individual, risco de carteira, risco correlacionado, risco de fraude, risco de diluição e risco regulatório. A lente trata antecipação como posição em carteira, não como transação isolada."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve antecipação de recebíveis ou qualquer forma de exposição financeira",
			"a decisão envolve como medir, precificar ou mitigar risco de default",
			"a decisão envolve composição, concentração ou saúde de uma carteira de crédito",
			"a decisão envolve como o sistema se comporta em cenário de estresse econômico",
			"a decisão envolve definir limites de exposição por participante, cadeia ou setor",
			"a decisão envolve calibração, validação ou monitoramento de modelos de risco",
			"a decisão envolve provisão para perdas, reserva de capital ou subordinação de FIDC",
			"a decisão envolve autenticidade ou legitimidade de recebíveis",
			"a decisão envolve estrutura jurídica de cessão ou antecipação",
		]
		keywords: [
			"default", "inadimplência", "risco de crédito", "exposição",
			"concentração", "carteira", "provisão", "perda",
			"stress test", "cenário de crise", "pro-ciclicalidade",
			"spread", "taxa de desconto", "custo de capital",
			"LGD", "PD", "EAD", "expected loss", "unexpected loss",
			"vintage", "safra", "recuperação", "RAROC",
			"diluição", "cessão", "coobrigação", "regresso",
			"fraude", "duplicata", "registradora", "FIDC",
			"cure rate", "roll rate", "atraso", "2.682",
		]
		excludeWhen: [
			"a decisão é sobre design de incentivos ou regras de interação sem exposição financeira — usar lens-mechanism-design",
			"a decisão é sobre estrutura informacional ou qualidade de sinais sem componente de risco de perda — usar lens-information-economics",
			"a decisão é sobre liquidez, funding ou maturity mismatch sem foco em default — usar lens-financial-intermediation",
			"a decisão é sobre compliance regulatório genérico sem componente de provisão ou capital — usar lens-regulatory-strategy",
		]
		rationale: "A Mesh antecipa recebíveis. Toda antecipação é exposição a crédito. Sem esta lente, o agente trata antecipação como transação isolada em vez de posição em carteira com risco individual, correlacionado, jurídico e sistêmico."
	}

	concepts: [
		{
			id:                "cr-default-definition"
			name:              "Definição Operacional de Default"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Default é evento binário que precisa de definição precisa para que PD, vintage, provisão, capital e stress testing tenham referente consistente. Variáveis da definição incluem dias de atraso, inclusão de reestruturação, tratamento de pagamento parcial e default técnico por covenant. Basileia usa 90 dias como referência; a Resolução 2.682 inicia provisão antes disso."
			meshManifestation: "Na construção civil brasileira, atraso de 15 a 60 dias pode ser endêmico e decorrer de gestão de caixa, não de insolvência. Tratar qualquer atraso como default infla PD; esperar apenas 90 dias para tudo pode atrasar intervenção."
			meshImplication:   "Usar definição em camadas: atraso monitorado a partir de 15 dias; inadimplência provável a partir de 60 dias para restringir novos limites; default formal a 90 dias para PD, provisão integral e recuperação. Para comparabilidade de safra, usar 90 dias como default formal. Para gestão, usar roll rates e buckets anteriores."
			rationale:         "Sem referente operacional de default, toda a cadeia PD → EL → provisão → capital fica semanticamente instável."
		},
		{
			id:                "cr-legal-structure"
			name:              "Estrutura Jurídica da Exposição"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A forma jurídica da antecipação determina quem é o devedor relevante, quantos devedores existem, o que conta como perda e como PD, LGD e EAD devem ser modeladas. As modalidades principais incluem cessão definitiva sem regresso, cessão com coobrigação do cedente e desconto de duplicata com responsabilidade solidária ou equivalente econômica."
			meshManifestation: "Na Mesh, a mesma interface de produto pode esconder estruturas de risco radicalmente diferentes. Em cessão definitiva, o risco principal é do comprador. Em coobrigação, o fornecedor volta para dentro da equação de perda. Em desconto ou estrutura economicamente equivalente, a robustez do regresso muda pricing, limite e capital."
			meshImplication:   "Definir estrutura jurídica antes de modelar risco. Se cessão definitiva, modelar risco primário no comprador. Se há regresso ou coobrigação, modelar probabilidade conjunta de perda e taxa efetiva de recuperação via fornecedor. Registro em registradora deve ser tratado como parte da estrutura, não detalhe operacional."
			rationale:         "A estrutura jurídica define a ontologia do risco. Sem ela, o modelo mira no ator errado."
		},
		{
			id:                "cr-probability-of-default"
			name:              "Probabilidade de Default (PD)"
			nature:            "theoretical"
			role:              "framework"
			definition:        "PD é a probabilidade de que a obrigação atinja a definição operacional de default no horizonte relevante. Deve ser pensada por horizonte, por estrutura jurídica e por regime de informação. PD point-in-time captura condição corrente; PD through-the-cycle captura média ao longo de ciclo econômico. Quando há coobrigação, a perda depende da combinação entre default do comprador e efetividade do regresso sobre o fornecedor."
			meshManifestation: "Na Mesh, o comprador costuma ser o devedor primário do recebível, mesmo quando o fornecedor é o usuário do produto. A vantagem da Mesh está em usar dados operacionais como leading indicators de deterioração antes de atraso formal de pagamento."
			meshImplication:   "Priorizar modelo de PD do comprador. Quando houver coobrigação, modelar explicitamente a taxa de recuperação por regresso ou a probabilidade conjunta de perda. No bootstrap, usar bureau externo e sinais públicos como âncora TTC e overlays PIT com dados operacionais da Mesh conforme forem surgindo."
			dependsOn:         ["cr-default-definition", "cr-legal-structure"]
			rationale:         "PD é o input primário de risco, mas depende de quem é o devedor econômico e do horizonte relevante."
		},
		{
			id:                "cr-maturity-adjustment"
			name:              "Maturidade e Estrutura Temporal do Risco"
			nature:            "theoretical"
			role:              "property"
			definition:        "Recebíveis de prazos diferentes carregam riscos diferentes porque acumulam tempo para deterioração do devedor, disputa, mudança macro e erro de previsão. O horizonte até vencimento ou liquidação altera PD efetiva, spread e capital."
			meshManifestation: "Na construção civil, materiais, equipamentos e serviços podem ter janelas de pagamento muito distintas. O risco de um recebível de 30 dias é estruturalmente diferente do risco de um recebível de 120 dias, mesmo para o mesmo comprador."
			meshImplication:   "Precificar por bucket de maturidade e monitorar mix de prazos na carteira. Quando safras recentes concentram recebíveis mais longos, o risco agregado sobe ainda que a composição por nome aparente estabilidade."
			dependsOn:         ["cr-probability-of-default"]
			rationale:         "Tratamento uniforme de maturidade subprecifica prazo longo e distorce carteira."
		},
		{
			id:                "cr-loss-given-default"
			name:              "Perda Dado Default (LGD)"
			nature:            "theoretical"
			role:              "framework"
			definition:        "LGD é a fração da exposição perdida quando default ocorre. Depende de garantias, senioridade, registrabilidade da cessão, contestabilidade do recebível, eficiência de cobrança e tempo de recuperação. Em crise, PD e LGD tendem a piorar juntas, criando wrong-way risk."
			meshManifestation: "Recebíveis registrados, bem documentados e com entrega confirmada têm LGD menor. Recebíveis contestáveis, sem registro ou contra comprador em recuperação judicial têm LGD muito maior. Em crise da construção, ativos perdem valor, o judiciário congestiona e recuperações caem."
			meshImplication:   "Estimar LGD normal e LGD downturn. Para provisão conservadora e capital, usar LGD downturn. Tratar registro em registradora e confirmação robusta de entrega como alavancas diretas de redução de LGD, não apenas compliance."
			dependsOn:         ["cr-probability-of-default"]
			rationale:         "LGD captura severidade. Ignorar sua deterioração em stress subestima perda justamente no pior cenário."
		},
		{
			id:                "cr-dilution-risk"
			name:              "Risco de Diluição"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Diluição é redução da exposição por eventos não-creditícios antes do vencimento: devolução, nota de débito, compensação, glosa de medição, abatimento por defeito ou atraso operacional. Não é default; é erosão do valor econômico do recebível."
			meshManifestation: "Na construção civil, serviços glosados e materiais contestados são frequentes. A Mesh pode antecipar contra valor nominal que depois se mostra parcialmente inexigível."
			meshImplication:   "Tratar diluição como risco próprio. Aplicar haircut sobre EAD, modelar taxa histórica por comprador, por par e por tipo de operação, e monitorar sua evolução separadamente de default."
			dependsOn:         ["cr-default-definition"]
			rationale:         "Ignorar diluição superestima EAD e desloca perda para a categoria errada."
		},
		{
			id:                "cr-fraud-risk"
			name:              "Fraude e Recebíveis Fictícios"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Fraude em antecipação inclui recebível inexistente, cessão duplicada, falsificação documental e conluio entre partes para fabricar lastro. É risco de perda total e de natureza distinta de crédito: o problema não é inadimplência de obrigação válida, mas inexistência ou invalidez do ativo."
			meshManifestation: "A construção civil brasileira tem histórico de fraude em duplicatas e recebíveis fabricados. A vantagem da Mesh é poder triangular pedido, execução, nota fiscal, confirmação e pagamento, reduzindo espaço para fraude."
			meshImplication:   "Operar controles antifraude como pré-condição de elegibilidade. Registro em registradora elimina cessão duplicada. Anomalias entre capacidade operacional, volume faturado e eventos operacionais devem disparar investigação. Fraude não entra em score como simples risco alto; entra como exclusão ou tratamento separado."
			rationale:         "Fraude não pode ser diluída dentro de PD/LGD como se fosse apenas variação estatística."
		},
	]
}
