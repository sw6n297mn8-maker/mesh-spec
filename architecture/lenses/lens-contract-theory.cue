package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

contractTheory: artifact_schemas.#AnalyticalLens & {
	id:      "lens-contract-theory"
	name:    "Teoria de Contratos"
	purpose: "Traduzir incentivos, direitos, obrigações e enforcement em instrumentos jurídico-operacionais concretos. A lente trata o contrato como mecanismo imperfeito, incompleto e renegociável, inserido em ambiente real de informalidade, verificabilidade limitada e regulação brasileira."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve design de termos contratuais entre a Mesh e participantes, incluindo fornecedores, compradores e investidores",
			"a decisão envolve o que incluir ou excluir de um contrato e como lidar com contingências não previstas",
			"a decisão envolve contratos incompletos e o que acontece quando a realidade diverge do contratado",
			"a decisão envolve renegociação de termos ou adaptação contratual a circunstâncias mudadas",
			"a decisão envolve contratos relacionais ou private ordering institucionalizado via plataforma",
			"a decisão envolve covenants, triggers ou condições contratuais que ativam direitos ou obrigações",
			"a decisão envolve alocação de direitos residuais, isto é, quem decide o que não está no contrato",
			"a decisão envolve como o contrato subjacente entre comprador e fornecedor afeta o recebível antecipado",
			"a decisão envolve enforcement de contratos em contexto de informalidade",
			"a decisão envolve multi-party contracting ou contratos interdependentes na cadeia",
			"a decisão envolve se uma variável é verificável por terceiro ou apenas observável pelas partes",
			"a decisão envolve cessão de recebíveis, registro em registradora, perfection de cessão ou true sale",
			"a decisão envolve conflito de interesse da Mesh como originador e servicer",
			"a decisão envolve representations and warranties e consequências de declaração falsa",
			"a decisão envolve remédios contratuais, incluindo consequência de violação de obrigação",
		]
		keywords: [
			"contrato", "contract", "termos", "cláusula",
			"incompleto", "incomplete", "contingência",
			"renegociação", "renegotiation", "adaptação",
			"covenant", "trigger", "condição",
			"relacional", "relational", "private ordering",
			"enforcement", "execução", "cumprimento",
			"direitos residuais", "residual rights",
			"moral hazard contratual", "hold-up",
			"cessão", "assignment", "true sale", "perfection",
			"informalidade", "informal", "verbal",
			"multi-party", "cadeia contratual",
			"verificável", "observável", "verificabilidade",
			"registradora", "duplicata", "protesto",
			"menu de contratos", "screening contratual",
			"servicer", "originador", "conflito de interesse",
			"reps", "warranties", "declaração",
			"remédio", "cláusula penal", "regresso",
			"adesão", "penalty default",
		]
		excludeWhen: [
			"a decisão é sobre design de mecanismos de incentivo em nível abstrato, como screening ou revelation; usar lens-mechanism-design",
			"a decisão é sobre fronteira organizacional make-or-buy; usar lens-theory-of-firm",
			"a decisão é sobre estrutura de FIDC como veículo financeiro; usar lens-financial-intermediation",
			"a decisão é sobre risco de crédito de operações individuais; usar lens-credit-risk",
			"a decisão é sobre topologia de rede; usar lens-network-theory",
		]
		rationale: "Mechanism design desenha incentivos abstratos. Contract theory implementa esses incentivos em instrumentos jurídico-operacionais no mundo real, onde contratos são incompletos, enforcement é imperfeito, variáveis nem sempre são verificáveis, há informalidade relevante e a infraestrutura legal brasileira molda o desenho da cessão, do regresso, do covenant e do remédio."
	}

	concepts: [
		{
			id:                "ct-verifiability-gap"
			name:              "Gap de Verificabilidade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A distinção central da teoria de contratos não é apenas entre o que as partes sabem, mas entre o que é observável e o que é verificável por terceiros. Verificabilidade também não é binária: diferentes níveis de enforcement exigem diferentes padrões de evidência. A Mesh pode atuar como produtora de verificabilidade, elevando um fato observado a fato utilizável contratualmente."
			meshManifestation: "Entrega percebida por comprador e fornecedor pode bastar para enforcement privado, mas não para protesto, execução ou auditoria de investidor. NF registrada, confirmação cruzada e trilha auditável elevam o nível de verificabilidade."
			meshImplication:   "Cada variável contratual deve ser desenhada para o nível de enforcement pretendido. Se o contrato depende de tribunal, precisa de prova documental mais forte. Se depende de investidor ou auditor, precisa de dado verificável por terceiro ou auditoria independente."
			rationale:         "Sem distinguir observável de verificável, o contrato parece completo no papel e falha justamente quando precisa ser aplicado."
		},
		{
			id:                "ct-incomplete-contracts"
			name:              "Contratos Incompletos, Direitos Residuais e Penalty Defaults"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Contratos são necessariamente incompletos. Por isso, importa quem decide quando o caso não previsto acontece. Também importa como defaults e penalty defaults distribuem o custo da omissão de informação e forçam revelação de quem sabe mais."
			meshManifestation: "Antecipação não cobre todas as contingências de atraso, disputa, mudança operacional ou deterioração de scoring. Defaults mal calibrados podem favorecer justamente a parte menos informada ou mais oportunista."
			meshImplication:   "A Mesh deve alocar explicitamente direitos residuais, desenhar defaults que pressionem revelação e, no bootstrap, usar contratos que especificam processos de colaboração e adaptação quando a incerteza ainda é alta."
			rationale:         "O problema não é eliminar incompletude. É decidir quem absorve o vazio contratual e com que incentivos."
			dependsOn:         ["ct-verifiability-gap"]
		},
		{
			id:                "ct-relational-contracts"
			name:              "Contratos Relacionais e Private Ordering"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Há pelo menos três regimes de enforcement relevantes: formal-judicial, relacional-bilateral e private ordering institucionalizado. Em construção civil, relações frequentemente começam como relacionais. A Mesh pode construir private ordering, mas isso depende de maturidade real da infraestrutura, não apenas de intenção."
			meshManifestation: "Uma relação histórica entre comprador e fornecedor pode sustentar cooperação fora do contrato formal. Já um score da Mesh sem histórico suficiente ainda não é um registry institucional com legitimidade plena."
			meshImplication:   "A Mesh deve distinguir o que já pode ser tratado como infraestrutura institucional e o que ainda depende de relações bilaterais ou reforço formal. No bootstrap, enforcement institucional robusto é aspiracional; na escala, pode se tornar funcional."
			rationale:         "Confundir private ordering maduro com reputação unilateral da plataforma gera excesso de confiança e desenho ruim de remédios."
			dependsOn:         ["ct-verifiability-gap", "ct-incomplete-contracts"]
		},
		{
			id:                "ct-contract-chain"
			name:              "Cadeia Contratual e Contrato Subjacente"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O recebível antecipado depende de um contrato subjacente comprador-fornecedor. A qualidade jurídica e econômica desse recebível depende da existência, validade, exigibilidade, ausência de disputa material e, em certos casos, também da regularidade trabalhista associada ao fornecimento."
			meshManifestation: "Um recebível pode parecer legítimo na relação Mesh↔fornecedor, mas ser frágil porque o contrato subjacente é informal, contestável, compensável ou contaminado por risco trabalhista de serviço."
			meshImplication:   "A Mesh deve sempre perguntar se o contrato subjacente sustenta a antecipação. NF, confirmação, ausência de disputa, cadeia de título e regularidade mínima relevante são partes da leitura contratual do ativo."
			rationale:         "Recebível ruim sobre contrato frágil continua ruim depois da cessão."
			dependsOn:         ["ct-verifiability-gap", "ct-incomplete-contracts"]
		},
		{
			id:                "ct-brazilian-legal-infrastructure"
			name:              "Infraestrutura Legal Brasileira para Cessão"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O desenho contratual da cessão no Brasil depende de infraestrutura específica, incluindo duplicata escritural, registradoras, falência, cessão oponível a terceiros e bases legais de tratamento de dados por fluxo. A distinção entre validade inter partes e perfection contra terceiros é central."
			meshManifestation: "Uma cessão pode ser válida entre as partes e ainda assim ser frágil contra terceiros se não houver registro e fluxo correto de perfeição. A mesma operação também envolve bases legais distintas de LGPD conforme o fluxo de dados e a contraparte."
			meshImplication:   "Contratos e operação devem ser desenhados com perfection como requisito estrutural, não detalhe opcional. A leitura de LGPD deve ser por fluxo: fornecedor, comprador, investidor e revisão de decisão automatizada têm bases e obrigações diferentes."
			rationale:         "Sem infraestrutura legal brasileira explícita, a lente fica genérica demais para a Mesh."
			dependsOn:         ["ct-verifiability-gap", "ct-contract-chain"]
		},
		{
			id:                "ct-enforcement-gradient"
			name:              "Gradação de Enforcement"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Enforcement não é binário. Há níveis graduais com custos e velocidades diferentes, do enforcement privado e institucional ao protesto, execução e ação ordinária. O desenho contratual deve considerar qual nível é economicamente justificável para cada faixa de valor."
			meshManifestation: "Recebíveis pequenos podem justificar alerta, score e protesto, mas não execução judicial custosa. Recebíveis maiores podem justificar escalada mais cara."
			meshImplication:   "A Mesh deve projetar escalação por nível e tratar custo de enforcement como parte do spread, da elegibilidade mínima e do desenho de remédios."
			rationale:         "Sem gradação, a empresa ou judicializa demais ou ameaça mecanismos que nunca vai usar."
			dependsOn:         ["ct-brazilian-legal-infrastructure", "ct-relational-contracts"]
		},
		{
			id:                "ct-contractual-moral-hazard"
			name:              "Moral Hazard Contratual"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O contrato pode criar ou reduzir moral hazard em três pontos especialmente relevantes: a Mesh como servicer e originador, a assimetria de informação na originação, e o comportamento do fornecedor depois que já recebeu a antecipação."
			meshManifestation: "A Mesh pode ser incentivada a privilegiar volume sobre qualidade. O fornecedor antecipado pode perder incentivo para cooperar na cobrança. Investidor pode ficar exposto ao conflito entre originação e servicing."
			meshImplication:   "Retention, reporting por safra, auditoria, regras de cooperação pós-antecipação e desenho explícito de recourse parcial ou obrigações de colaboração são mecanismos contratuais centrais."
			rationale:         "Sem tratar moral hazard na forma contratual concreta, o conflito fica invisível até deteriorar qualidade de carteira."
			dependsOn:         ["ct-verifiability-gap", "ct-contract-chain"]
		},
		{
			id:                "ct-reps-warranties"
			name:              "Representations and Warranties"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Representations and warranties alocam risco ex post sobre fatos anteriores ou presentes. Elas não substituem verificação ex ante, mas cobrem o residual quando a verificação é imperfeita. Sua intensidade deve variar conforme a camada contratual e o nível de documentação disponível."
			meshManifestation: "Em camada mais simples, reps amplas podem ser a principal proteção da Mesh. Em camada mais formalizada, reps se tornam mais seletivas porque a documentação já cobre parte maior do risco."
			meshImplication:   "A Mesh deve calibrar reps por camada, separar boa-fé de fraude e definir consequências proporcionais, compreensíveis e operáveis."
			rationale:         "Reps mal calibradas viram ou ilusão de segurança ou fonte excessiva de atrito."
			dependsOn:         ["ct-verifiability-gap", "ct-contract-chain", "ct-contract-menu"]
		},
		{
			id:                "ct-remedies-design"
			name:              "Design de Remédios Contratuais"
			nature:            "theoretical"
			role:              "method"
			definition:        "Enforcement responde ao como. Remédios respondem ao quê. Cláusula penal, regresso, restrição de acesso, rescisão, protesto e judicialização precisam ser calibrados por gravidade, capacidade econômica da contraparte, adesão e risco de abusividade."
			meshManifestation: "Atraso simples pode justificar remédio reputacional e operacional. Fraude pode justificar regresso total, exclusão e protesto. Boa-fé com erro verificável pode justificar remédio proporcional."
			meshImplication:   "A Mesh deve operar remédios graduais por tipo de falha, preservar compreensibilidade em contratos de adesão e evitar penalidades que parecem fortes no papel mas não sobrevivem a escrutínio jurídico ou reputacional."
			rationale:         "Remédio inadequado destrói adesão, enforcement ou ambos."
			dependsOn:         ["ct-enforcement-gradient", "ct-reps-warranties", "ct-contract-menu"]
		},
		{
			id:                "ct-covenant-design"
			name:              "Design de Covenants e Triggers"
			nature:            "theoretical"
			role:              "method"
			definition:        "Covenants e triggers são instrumentos de transferência contingente de controle. O desenho correto depende do que dispara o trigger, quem recebe o direito, se essa parte tem informação para exercê-lo bem e se o mecanismo discrimina entre deterioração real e ruído sazonal ou temporário."
			meshManifestation: "Um covenant univariado de inadimplência pode disparar controle em período sazonalmente ruim sem distinguir entre deterioração estrutural e ruído esperado."
			meshImplication:   "A Mesh deve preferir covenants compostos, graduados, sazonais quando necessário e acompanhados de obrigação de informar antes da decisão da contraparte."
			rationale:         "Trigger sem informação suficiente transfere controle para quem não consegue usá-lo bem."
			dependsOn:         ["ct-incomplete-contracts", "ct-verifiability-gap"]
		},
		{
			id:                "ct-renegotiation"
			name:              "Renegociação e Adaptação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Renegociação é inevitável em contratos de médio prazo e em ambientes incertos. A questão não é evitá-la, mas canalizá-la para adaptação eficiente e reduzir hold-up, barganha oportunista e renegociação puramente ad hoc."
			meshManifestation: "Mudança de custo de funding, melhoria de scoring ou surgimento de concorrente podem pressionar taxa, prazo, lock-up ou exclusividade."
			meshImplication:   "A Mesh deve usar mecanismos de ajuste automático quando possível, revisão periódica com critérios explícitos, prazos definidos e dispositivos que reduzam poder excessivo de renegociação de uma parte isolada."
			rationale:         "Renegociação sem canal pré-desenhado vira disputa de poder."
			dependsOn:         ["ct-incomplete-contracts", "ct-enforcement-gradient"]
		},
		{
			id:                "ct-contract-menu"
			name:              "Menu de Contratos e Screening Contratual"
			nature:            "theoretical"
			role:              "framework"
			definition:        "A Mesh não precisa operar com contrato único. Um menu de contratos permite screening por auto-seleção, mas cada camada continua sujeita a seleção adversa interna, custo contratual próprio e possibilidade de arbitragem se o desenho for ruim."
			meshManifestation: "Camadas mais leves atraem quem não consegue cumprir ou custear camadas mais fortes. Camadas mais robustas reduzem risco, mas podem se tornar inviáveis para tickets pequenos se o custo contratual all-in for alto demais."
			meshImplication:   "A Mesh deve desenhar camadas economicamente viáveis, mitigar seleção adversa intra-camada com score individual, safra e caps, e preferir camada por fornecedor em vez de camada por operação quando a arbitragem entre camadas for relevante."
			rationale:         "Sem menu, a empresa perde capacidade de servir heterogeneidade. Com menu mal desenhado, ganha arbitragem e seleção adversa."
			dependsOn:         ["ct-verifiability-gap", "ct-brazilian-legal-infrastructure"]
		},
		{
			id:                "ct-commitment-and-optionality"
			name:              "Commitment e Optionality"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Contratos distribuem commitment e optionality por instrumentos como lock-up, cap de pricing, exclusividade, renovação e penalidade de saída. O ponto central é equilibrar confiança e adaptabilidade conforme a fase da relação."
			meshManifestation: "Bootstrap pode exigir mais commitment de ambos os lados para viabilizar aprendizagem e confiança. Escala pode exigir mais optionality sem destruir credibilidade."
			meshImplication:   "A Mesh deve explicitar o que está comprometendo, por quanto tempo, com que enforcement e em troca de qual contrapartida."
			rationale:         "Commitment implícito vira frustração; optionality excessiva destrói confiança."
			dependsOn:         ["ct-renegotiation", "ct-incomplete-contracts"]
		},
		{
			id:                "ct-multi-party-alignment"
			name:              "Alinhamento Multi-Party"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Em cadeia com múltiplos contratos interdependentes, otimizar cada bilateral isoladamente pode piorar o sistema. O desenho contratual precisa verificar compatibilidade entre incentivos, covenants, dados exigidos, velocidade de decisão e realidade operacional da cadeia."
			meshManifestation: "Termos que fazem sentido no contrato com investidor podem conflitar com atraso operacional endêmico da obra ou com o desenho de antecipação ao fornecedor."
			meshImplication:   "A Mesh deve revisar alinhamento de cadeia, não só qualidade de cada contrato individual. Isso vale especialmente para funding, servicing, subjacente e menu de contratos."
			rationale:         "O risco sistêmico aparece no desalinhamento entre bilaterais, não apenas em cláusulas ruins isoladas."
			dependsOn:         ["ct-contract-chain", "ct-covenant-design"]
		},
		{
			id:                "ct-mesh-contract-health"
			name:              "Saúde Contratual da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "semi-annual"
			definition:        "A saúde contratual deve ser observada por métricas de disputa, renegociação, perfection, overrides, safra, custo de enforcement, custo contratual por camada, distribuição do menu e desalinhamentos recorrentes entre contratos da cadeia."
			meshManifestation: "Waivers recorrentes, perfeição incompleta, renegociação excessiva, camada A estagnada, custo de enforcement alto demais ou safra recente pior que a carteira são sinais de desenho contratual ruim ou desalinhado."
			meshImplication:   "O dashboard contratual da Mesh deve ser específico por tipo de contraparte e por camada, com gatilhos claros para revisão de menu, covenant, remédio e elegibilidade."
			rationale:         "Infraestrutura contratual é invisível até falhar; métricas evitam que a falha apareça só tarde demais."
		},
	]
}
