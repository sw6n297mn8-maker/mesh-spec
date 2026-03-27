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

	reasoningProtocol: [
		{
			question:  "Qual contrato está em jogo e qual é a contraparte relevante?"
			reveals:   "Define a dinâmica básica do problema contratual."
			rationale: "Não existe contrato genérico; Mesh↔fornecedor, Mesh↔comprador, Mesh↔investidor e subjacente têm lógicas diferentes."
		},
		{
			question:  "Qual regime de enforcement prevalece na prática: formal-judicial, relacional-bilateral ou privado-institucional?"
			reveals:   "Mostra qual infraestrutura de cumprimento realmente sustenta o contrato."
			rationale: "O contrato escrito pode existir, mas o enforcement real pode estar em outra camada."
		},
		{
			question:  "Se o contrato é relacional, as três condições de sustentabilidade estão presentes?"
			reveals:   "Mostra se o contrato relacional é robusto ou frágil."
			rationale: "Valor do futuro, outside option pior e detectabilidade do desvio são a base mínima."
			appliesWhen: "há componente relacional relevante"
		},
		{
			question:  "As variáveis contratuais importantes são verificáveis para o nível de enforcement pretendido?"
			reveals:   "Expõe o gap entre o que o contrato condiciona e o que ele consegue provar."
			rationale: "Contrato bom em variável errada é contrato fraco."
		},
		{
			question:  "Quais contingências relevantes não estão cobertas e quem recebe o direito residual de decidir?"
			reveals:   "Mostra se o vazio contratual está alocado de forma coerente."
			rationale: "Incompletude sempre existirá; a questão é quem governa o não previsto."
		},
		{
			question:  "Há penalty defaults ou defaults que incentivam revelação da parte mais informada?"
			reveals:   "Mostra se o contrato usa a assimetria de informação a seu favor."
			rationale: "Defaults são decisões de design, não acidentes."
		},
		{
			question:  "O contrato subjacente sustenta juridicamente e economicamente o recebível?"
			reveals:   "Testa a qualidade real do ativo antecipado."
			rationale: "Recebível depende do subjacente."
			appliesWhen: "há antecipação, cessão ou análise de elegibilidade"
		},
		{
			question:  "A cessão está perfeita e oponível a terceiros?"
			reveals:   "Distingue validade inter partes de proteção estrutural real."
			rationale: "Sem perfection, true sale e prioridade ficam frágeis."
			appliesWhen: "há cessão ou estrutura com FIDC"
		},
		{
			question:  "O nível de enforcement escolhido é economicamente viável para o valor em risco?"
			reveals:   "Mostra se o contrato ameaça algo que nunca valerá a pena executar."
			rationale: "Custo de enforcement faz parte do contrato real."
		},
		{
			question:  "Os remédios são proporcionais, compreensíveis e sustentáveis em contrato de adesão?"
			reveals:   "Mostra se o contrato sobreviveria a disputa, escrutínio jurídico e percepção de justiça."
			rationale: "Remédio excessivo ou obscuro destrói enforcement útil."
		},
		{
			question:  "Existe moral hazard relevante de servicer, originador ou pós-antecipação?"
			reveals:   "Expõe onde o contrato precisa alinhar melhor incentivos."
			rationale: "Boa parte do risco sistêmico vem de conflito contratual implícito."
			appliesWhen: "há FIDC, servicing, originação ou cooperação pós-antecipação"
		},
		{
			question:  "Covenants e triggers transferem controle com informação suficiente e calibrada?"
			reveals:   "Mostra se o trigger discrimina bem e se a parte que recebe o direito sabe usá-lo."
			rationale: "Transferência de controle sem informação é fonte de erro."
			appliesWhen: "há covenants, triggers ou rights transfer contingente"
		},
		{
			question:  "O contrato antecipa renegociação e adaptações prováveis?"
			reveals:   "Mostra se a mudança futura será absorvida por regra ou por barganha improvisada."
			rationale: "A boa renegociação é desenhada antes de acontecer."
			appliesWhen: "há relação de médio ou longo prazo"
		},
		{
			question:  "Há menu contratual suficiente para servir heterogeneidade sem abrir arbitragem excessiva?"
			reveals:   "Mostra se a Mesh está operando one-size-fits-all ou screening contratual viável."
			rationale: "Heterogeneidade real pede contratos diferentes, mas isso precisa continuar operacionalmente governável."
			appliesWhen: "há participantes heterogêneos ou desenho de novos templates"
		},
		{
			question:  "Os contratos interdependentes da cadeia estão alinhados entre si?"
			reveals:   "Expõe desalinhamento sistêmico entre bilaterais."
			rationale: "Otimização local pode destruir coerência da cadeia."
		},
		{
			question:  "O custo contratual all-in torna essa estrutura economicamente viável para o ticket e o segmento?"
			reveals:   "Fecha a análise jurídica com a validação econômica real."
			rationale: "Contrato tecnicamente correto mas economicamente inviável não será adotado."
		},
	]

	meshExamples: [
		{
			id:                "ex-informal-receivable"
			scenario:          "Fornecedor de areia pede antecipação de R$30 mil com base em pedido por WhatsApp e relação recorrente com a construtora."
			analysis:          "O contrato relevante é Mesh↔fornecedor, apoiado em subjacente frágil. O regime é majoritariamente relacional com reforço privado-institucional inicial. O problema central é elevar verificabilidade sem impor custo contratual que inviabilize o ticket. Também é preciso distinguir inclusão real de seleção adversa contratual."
			recommendation:    "Usar camada contratual mínima com NF simplificada, confirmação operacional suficiente para enforcement privado, reps acessíveis, perfection sempre que houver cessão, remédios graduais e caminho explícito de migração para camada mais forte conforme histórico e formalização cresçam."
			principlesApplied: ["ax-03", "ax-07", "dp-02"]
			assumptions: [
				"há relação prévia relevante entre comprador e fornecedor",
				"o custo contratual adicional ainda cabe no ticket",
			]
			rationale: "O caso mostra como contrato mínimo viável pode servir inclusão sem fingir robustez jurídica inexistente."
		},
		{
			id:                "ex-covenant-seasonal-trigger"
			scenario:          "A inadimplência de fevereiro sobe acima do trigger do FIDC em meio a atraso sazonal de obra."
			analysis:          "O problema é um covenant mal calibrado que transfere controle com pouca discriminação entre ruído sazonal e deterioração real. A variável é verificável, mas o trigger univariado é informacionalmente pobre."
			recommendation:    "Redesenhar o covenant como composto, incorporar sazonalidade quando material, impor obrigação prévia de informar com dado verificável e escalonar as consequências em vez de acionar suspensão binária imediata."
			principlesApplied: ["ax-05", "dp-05"]
			assumptions: [
				"há histórico mínimo para distinguir sazonalidade de piora estrutural",
			]
			rationale: "O caso mostra que trigger ruim não é apenas número ruim; é transferência ruim de controle."
		},
		{
			id:                "ex-anchor-renegotiation"
			scenario:          "Anchor relevante pede condição especial depois de ganhar outside option com concorrente."
			analysis:          "Há risco de hold-up, enfraquecimento do commitment inicial e desalinhamento com fairness do resto da base. A proposta concorrente pode nem ser verificável integralmente, mas a mudança de outside option é real."
			recommendation:    "Evitar exceção puramente discricionária em preço-base, preservar coerência do modelo, usar benefícios contratuais ou operacionais mais defensáveis, renovar em estrutura com compromisso mútuo explícito e reduzir dependência de um único anchor ao longo do tempo."
			principlesApplied: ["ax-05", "ax-06", "dp-02"]
			assumptions: [
				"o anchor representa parcela material do volume",
				"a concorrência é suficientemente crível para afetar barganha",
			]
			rationale: "O caso mostra a interseção entre renegociação, commitment, optionality e alinhamento sistêmico."
		},
	]

	principleIds: ["ax-03", "ax-05", "ax-06", "ax-07", "dp-02", "dp-05"]

	relatedLenses: [
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Mechanism design define a arquitetura abstrata do incentivo; esta lente a implementa em cláusulas, defaults, menu, remédios e enforcement."
		},
		{
			lensId:   "lens-theory-of-firm"
			relation: "complementsWith"
			context:  "Theory of firm decide fronteira e governance organizacional; esta lente decide direitos, obrigações e enforcement uma vez que a relação foi contratualizada."
		},
		{
			lensId:   "lens-financial-intermediation"
			relation: "complementsWith"
			context:  "Financial intermediation trata o veículo e a estrutura econômica; esta lente trata os termos que fazem a estrutura operar juridicamente e disciplinam o conflito entre partes."
		},
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "Credit risk mede probabilidade e perda; esta lente define os termos que afetam LGD, cure, dilution, recourse, safra e elegibilidade."
		},
		{
			lensId:   "lens-information-economics"
			relation: "complementsWith"
			context:  "Information economics explica assimetria; esta lente transforma assimetria em exigência de verificabilidade, menu, reps e enforcement."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "Behavioral economics ajuda a desenhar termos compreensíveis, evitar surpresas destrutivas e calibrar percepção de fairness e confiança."
		},
		{
			lensId:   "lens-commons-collective-action"
			relation: "complementsWith"
			context:  "Commons and collective action ajuda a pensar enforcement e reputação institucionalizados; esta lente traduz isso em cláusulas, sanções e private ordering."
		},
		{
			lensId:   "lens-market-design"
			relation: "complementsWith"
			context:  "Market design estrutura o mercado; esta lente implementa pricing, commitment, lock-up, menu e restrições em termos contratuais executáveis."
		},
		{
			lensId:   "lens-complex-adaptive-systems"
			relation: "complementsWith"
			context:  "Complex adaptive systems ajuda a pensar adaptação, path dependence e coevolução; esta lente traduz isso em renegociação, optionality e cláusulas de adaptação."
		},
	]

	limitations: [
		{
			description: "Muitos participantes operam com documentação imperfeita ou informalidade relevante."
			alternative: "Usar menu de formalização progressiva e construir verificabilidade em camadas, em vez de exigir perfeição documental desde o início."
			rationale:   "Excluir toda informalidade destruiria a tese de acesso e limitaria demais a base servível."
		},
		{
			description: "Enforcement judicial é lento e caro."
			alternative: "Projetar gradação de enforcement e usar private ordering, protesto e execução econômica antes de depender de ação ordinária."
			rationale:   "Contrato útil precisa considerar enforcement real, não só enforcement teórico."
		},
		{
			description: "Covenants não antecipam todos os cenários inéditos."
			alternative: "Usar gatilhos compostos, obrigação de informar, waivers estruturados e mecanismos de interpretação antes da transferência binária de controle."
			rationale:   "Trigger simples demais vira fonte de ruído e conflito."
		},
		{
			description: "Contratos relacionais são difíceis de medir e o private ordering maduro não existe automaticamente no bootstrap."
			alternative: "Avaliar periodicamente as condições de sustentabilidade do relacional e construir infraestrutura institucional de forma gradual."
			rationale:   "Relação histórica ajuda, mas não substitui maturidade institucional real."
		},
		{
			description: "Contratos de adesão podem conter assimetria excessiva de drafting e risco de abusividade."
			alternative: "Operar linguagem clara, menu compreensível, remédios proporcionais e teste explícito de abusividade antes de deployar termos."
			rationale:   "Surpresa contratual destrói trust e aumenta risco jurídico."
		},
		{
			description: "Menu contratual pode ser gamificado por arbitragem entre camadas."
			alternative: "Preferir camada por fornecedor quando necessário e complementar com score individual, caps e monitoramento de safra."
			rationale:   "Sem isso, screening vira convite à seleção adversa e gaming."
		},
		{
			description: "O marco legal e regulatório pode mudar, especialmente em dados, scoring e cessão."
			alternative: "Manter cláusulas de adaptação regulatória e revisão periódica da infraestrutura contratual."
			rationale:   "A robustez contratual da Mesh depende de capacidade de adaptação institucional."
		},
		{
			description: "Contrato tecnicamente correto pode ser economicamente inviável em tickets pequenos."
			alternative: "Medir custo contratual all-in e simplificar estrutura quando o custo marginal superar o valor econômico da proteção adicional."
			rationale:   "Viabilidade econômica é o teste final de adoção e utilidade."
		},
	]

	rationale: "Teoria de Contratos, na Mesh, existe para transformar relações econômicas imperfeitas em instrumentos operáveis sob verificabilidade limitada, enforcement gradual e regulação brasileira específica. A lente distingue observável de verificável, assume incompletude contratual como dado, trata direitos residuais e defaults como escolhas de design, reconhece a coexistência entre enforcement formal, relacional e institucional, e conecta o recebível ao contrato subjacente que o sustenta. Também integra a infraestrutura legal brasileira de cessão, perfection e LGPD por fluxo, desenha gradação de enforcement e de remédios, trata moral hazard do servicer e do originador, calibra reps por camada, estrutura covenants e renegociação, e usa menu de contratos para servir heterogeneidade sem perder governança. Seu papel é fechar o gap entre mecanismo ideal e contrato real, de forma economicamente viável, juridicamente defensável e operacionalmente usável pela Mesh."
}
