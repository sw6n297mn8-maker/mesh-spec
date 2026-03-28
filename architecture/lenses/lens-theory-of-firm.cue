package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

theoryOfFirm: artifact_schemas.#AnalyticalLens & {
	id:      "lens-theory-of-firm"
	name:    "Teoria da Firma e Nova Economia Institucional"
	purpose: "Analisar as fronteiras organizacionais da Mesh, decidindo o que internalizar, delegar ou estruturar de forma híbrida com base em especificidade, complementaridade, controle, capacidade, escala, oportunismo, portabilidade e assimetria de erro."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve build vs buy, internalizar vs delegar a terceiro",
			"a decisão envolve definir o que a Mesh faz internamente vs o que parceiros fazem",
			"a decisão envolve escolher entre integração vertical e contratação via mercado",
			"a decisão envolve avaliar se um BaaS ou provider externo deve ser substituído por solução própria",
			"a decisão envolve estruturar contrato ou parceria de longo prazo com fornecedor de infraestrutura",
			"a decisão envolve classificar subdomínios como core, supporting ou generic",
			"a decisão envolve avaliar dependência de terceiro e risco de lock-in",
			"a decisão envolve definir as fronteiras organizacionais da Mesh",
			"a decisão envolve quem detém controle sobre dados ou ativos gerados na operação",
			"a decisão envolve avaliar se a Mesh tem capacidade para executar internamente",
			"a decisão envolve decidir se a Mesh deve co-localizar ativos complementares ou aceitar separação entre firmas",
			"a decisão envolve calibrar investimento em portabilidade, abstração ou optionality",
			"a decisão envolve avaliar se uma decisão errada é recuperável ou existencial",
		]
		keywords: [
			"build or buy", "make or buy", "internalizar", "terceirizar",
			"BaaS", "parceiro", "provider", "integração vertical",
			"fronteira organizacional", "o que é nosso vs o que é de terceiro",
			"lock-in", "dependência", "trocar de fornecedor",
			"core domain", "supporting", "generic",
			"contrato", "SLA", "especificidade",
			"complementaridade", "direitos sobre dados", "controle",
			"escala mínima", "capacidade organizacional",
			"hold-up", "oportunismo", "residual rights",
			"asset specificity", "switching cost", "portabilidade",
			"governança", "hierarquia", "mercado", "híbrido",
			"refém mútuo", "dependência bilateral", "custos de transação",
		]
		excludeWhen: [
			"a decisão é sobre design de regras de interação entre participantes da rede — usar mechanism-design",
			"a decisão é sobre estrutura informacional entre participantes — usar information-economics",
			"a decisão é sobre risco de crédito ou composição de carteira — usar credit-risk",
			"a decisão é sobre funding, liquidez ou veículo regulatório sem componente de fronteira organizacional — usar financial-intermediation",
			"a decisão é sobre design interno de código ou arquitetura de software sem componente de fronteira organizacional — usar architecture",
			"a decisão é sobre topologia da rede e contágio estrutural — usar network-theory",
		]
		rationale: "Toda decisão sobre os limites da Mesh — o que pertence ao núcleo da firma e o que pode ser coordenado por mercado ou forma híbrida — é decisão de teoria da firma. Sem esta lens, decisões de build vs buy, portabilidade, BaaS, providers de IA, registradoras, administração fiduciária e controle de dados são tomadas por conveniência ou custo imediato, ignorando custos de transação, complementaridade, oportunismo, lock-in, escala mínima, poder de barganha e assimetria de erro."
	}

	concepts: [
		{
			id:                "tf-transaction-costs"
			name:              "Custos de Transação"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Custos de usar o mercado para coordenar uma atividade: busca, seleção, negociação, monitoramento, adaptação contratual, resolução de disputa e substituição de fornecedor. A firma existe quando coordenar internamente custa menos do que transacionar no mercado."
			meshManifestation: "A Mesh enfrenta custos de transação em duas camadas. Externamente, ela existe justamente para reduzir custos de transação entre compradores e fornecedores. Internamente, ela também enfrenta custos de transação ao depender de BaaS, providers de IA, administradores fiduciários, registradoras, bureaus e infraestrutura especializada."
			meshImplication:   "Toda decisão de delegar deve considerar custo total de transação, não apenas preço do fornecedor. Isso inclui negociação, monitoramento, renegociação, troubleshooting, custo de integração e custo de troca. Na Mesh operada por IA, parte desses custos pode cair porque agentes monitoram SLA, extraem evidência e detectam desvios continuamente. Essa redução desloca o limiar de internalização, mas não o elimina."
			rationale:         "É o conceito fundante de Coase. Sem ele, a firma vira coleção de decisões ad hoc."
		},
		{
			id:                "tf-coordination-costs"
			name:              "Custos de Coordenação Interna"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Internalizar uma atividade não elimina custo; troca custo de mercado por custo de coordenação interna. Esses custos incluem alinhamento, QA, manutenção, supervisão, gestão de exceções, burocratização e custo de oportunidade do management."
			meshManifestation: "Na Mesh AI-native, custos de coordenação não são apenas humanos. Incluem manutenção de contexto entre agentes, validação de outputs, drift de modelo, contratos entre componentes, consistência operacional, guardrails, observabilidade e custo de revisão humana nas saídas críticas."
			meshImplication:   "Sempre comparar custos de transação com custos de coordenação. Alta especificidade sem capacidade ou sem regime de QA robusto não justifica internalização imediata. O erro clássico é ver custo de terceiro e ignorar custo total de operar internamente algo crítico."
			dependsOn:         ["tf-transaction-costs"]
			rationale:         "Sem esta metade, a lens fica enviesada pró-build."
		},
		{
			id:                "tf-opportunism"
			name:              "Oportunismo"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Busca de interesse próprio com artifício. Inclui hold-up, shirking, adverse selection pré-contratual e strategic misrepresentation. Oportunismo é mais amplo que descumprimento explícito de contrato."
			meshManifestation: "Um BaaS pode cumprir formalmente o SLA, mas degradar qualidade de suporte para clientes pequenos. Um provider de IA pode induzir lock-in por features proprietárias. Uma registradora pode ganhar poder de barganha depois que a Mesh já internalizou a integração e o fluxo jurídico associado."
			meshImplication:   "Para cada parceiro, mapear quais formas de oportunismo são plausíveis. Monitorar além do contrato. Cláusula contratual é defesa insuficiente se a Mesh não consegue observar, auditar e trocar."
			dependsOn:         ["tf-transaction-costs"]
			rationale:         "Custos de transação são altos porque oportunismo é real, não teórico."
		},
		{
			id:                "tf-asset-specificity"
			name:              "Especificidade de Ativo"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quanto mais um ativo perde valor fora de uma relação específica, mais específico ele é. Alta especificidade aumenta risco de hold-up e tende a favorecer internalização ou governança híbrida mais forte."
			meshManifestation: "Modelos calibrados com dados Mesh, dados de qualificação enriquecidos, embeddings e workflows construídos sobre contratos e estados próprios da plataforma têm especificidade alta. Pix, compute e storage commodity têm especificidade baixa. Há também especificidade temporal: certas atividades só valem se ocorrerem no momento certo."
			meshImplication:   "Mapear especificidade por atividade e por ativo. Especificidade alta em dados, modelos e workflows críticos empurra para internalização ou pelo menos controle mais forte. Especificidade temporal exige SLAs proporcionais à criticidade do timing."
			dependsOn:         ["tf-transaction-costs"]
			rationale:         "É o principal driver estrutural de integração vertical em Williamson."
		},
		{
			id:                "tf-temporal-specificity"
			name:              "Especificidade Temporal"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O valor do ativo ou da transação depende criticamente do momento em que algo ocorre. Quando timing é parte do valor, atraso não é só inconveniência; é destruição econômica do ativo."
			meshManifestation: "Liquidação, registro, elegibilidade de recebível, confirmação operacional e execução de fluxos críticos da Mesh são temporalmente específicos. Um parceiro que entrega com dados certos, mas atrasados, ainda pode destruir valor."
			meshImplication:   "Para toda atividade temporalmente específica, SLA deve ser tratado como requisito estrutural, não como conveniência comercial. Isso afeta build vs buy, redundância, observabilidade e severidade de incidentes."
			dependsOn:         ["tf-asset-specificity"]
			rationale:         "Na Mesh, tempo é parte do ativo, especialmente no plano financeiro-operacional integrado."
		},
		{
			id:                "tf-residual-property-rights"
			name:              "Direitos Residuais de Propriedade"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quem controla o ativo quando o contrato não especifica explicitamente o caso concreto. Direitos residuais importam porque determinam quem investe, quem adapta e quem captura valor em contingências não previstas."
			meshManifestation: "Mesmo quando contrato diz que os dados são da Mesh, o partner pode deter controle de facto se hospeda, processa, restringe exportação, ou define formato difícil de migrar. O mesmo vale para embeddings, traces, features derivadas, outputs e estados operacionais."
			meshImplication:   "Separar controle contratual de controle de facto. Exigir portabilidade técnica e direitos explícitos sobre outputs, dados derivados, logs e artefatos treinados ou calibrados com dados da Mesh. Em ativos centrais, quem investe deve controlar."
			dependsOn:         ["tf-asset-specificity"]
			rationale:         "Controle de facto derrota retórica contratual."
		},
		{
			id:                "tf-asset-complementarity"
			name:              "Complementaridade de Ativos"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Dois ativos são complementares quando juntos geram muito mais valor do que separados. Quando o mercado não consegue intermediar essa complementaridade com baixa perda de qualidade, a co-localização na firma passa a ser economicamente preferível."
			meshManifestation: "O argumento central da Mesh é complementaridade entre dinheiro, operação e informação. Dados financeiros isolados valem menos do que dados financeiros conectados a entrega, disputa, qualificação, recorrência, cadeia e reputação. Muitos serviços externos podem até ser baratos, mas quebram essa complementaridade por latência, perda de contexto ou acesso insuficiente."
			meshImplication:   "A pergunta não é só 'é específico?', mas também 'a separação destrói valor conjunto?'. Se o provider entrega dados e estados com qualidade, completude e latência suficientes, a complementaridade pode ser preservada sem internalização. Se não entrega, a separação desintegra o core e favorece build ou forma híbrida mais forte."
			dependsOn:         ["tf-asset-specificity", "tf-residual-property-rights"]
			rationale:         "A tese da Mesh é de complementaridade estrutural; a lens precisa enxergar isso explicitamente."
		},
		{
			id:                "tf-hold-up-problem"
			name:              "Problema de Hold-Up"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Quando uma parte investiu de forma específica e a outra pode extrair valor dessa dependência depois que o investimento já foi feito. Quanto maior a especificidade e menor a optionality, maior o hold-up risk."
			meshManifestation: "Depois de meses integrando um BaaS ou provider específico, a Mesh pode ficar vulnerável a aumento de preço, piora de condições, atraso estratégico de roadmap ou downgrade de prioridade. O mesmo vale para providers de IA ou parceiros fiduciários muito integrados ao fluxo."
			meshImplication:   "Mitigar hold-up com abstrações, optionality, exportação de dados, contratos com exit real, arquitetura reversível e plano concreto de migração. Mas calibrar defesa pelo risco líquido, não por paranoia genérica."
			dependsOn:         ["tf-opportunism", "tf-asset-specificity"]
			rationale:         "É a manifestação mais clássica do encontro entre especificidade e oportunismo."
		},
		{
			id:                "tf-bilateral-dependence"
			name:              "Dependência Bilateral e Refém Mútuo"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Nem toda dependência é unilateral. Quando ambos os lados investem na relação e ambos perderiam valor relevante se a relação se rompesse, surge dependência bilateral, que reduz o risco líquido de hold-up."
			meshManifestation: "No bootstrap, a dependência da Mesh em parceiros tende a ser unilateral. Com escala, certos parceiros podem passar a depender da Mesh por volume, reputação setorial, referência de mercado ou integração difícil de reproduzir em outro cliente."
			meshImplication:   "Avaliar dependência em ambos os sentidos. Portabilidade máxima é obrigatória quando a dependência é unilateral e o ativo é crítico. Quando a dependência se torna bilateral, a Mesh pode reduzir over-investment em optionality extrema e focar em governança relacional mais eficiente."
			dependsOn:         ["tf-hold-up-problem"]
			rationale:         "Sem isso, a análise superestima risco em relações onde o poder já é mais equilibrado."
		},
		{
			id:                "tf-bounded-rationality"
			name:              "Racionalidade Limitada e Contratos Incompletos"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Nenhuma parte consegue antecipar e descrever ex ante todas as contingências relevantes. Por isso, contratos são incompletos por natureza."
			meshManifestation: "Na Mesh, IA reduz parte da racionalidade limitada porque aumenta capacidade de monitorar, comparar, simular e detectar desvios. Mas não elimina contingências genuinamente novas: mudanças regulatórias, eventos extremos, mudança de mercado, falhas inéditas de provider e comportamentos não previstos de agentes."
			meshImplication:   "Tratar contratos como instrumentos incompletos que precisam ser apoiados por estrutura técnica, observabilidade, optionality e poder de barganha. A hipótese de que IA desloca o limiar de internalização deve ser validada empiricamente, não presumida."
			dependsOn:         ["tf-transaction-costs", "tf-coordination-costs"]
			rationale:         "IA reduz fricção, mas não zera o problema institucional."
		},
		{
			id:                "tf-governance-structures"
			name:              "Estruturas de Governança"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Mercado, hierarquia e híbridos não são equivalentes. Cada forma organiza controle, adaptação, incentivos, disputas e direitos de modo diferente."
			meshManifestation: "BaaS como contrato de serviço, administradores fiduciários como relação regulada e fiduciária, providers de IA como híbridos com alta optionality desejável, registradoras como infraestrutura regulada e parcialmente inevitável."
			meshImplication:   "Não decidir apenas entre build e buy. Em muitos casos, a decisão correta é híbrido: buy com abstração, build parcial, dual-sourcing, contrato relacional, ou delegação com plano explícito de internalização futura. Mapear forma de governança adequada à atividade."
			dependsOn:         ["tf-asset-specificity", "tf-bounded-rationality"]
			rationale:         "A realidade institucional da Mesh é híbrida, não binária."
		},
		{
			id:                "tf-institutional-environment"
			name:              "Ambiente Institucional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "As regras legais, regulatórias e culturais do ambiente alteram custos de transação e viabilidade das estruturas de governança."
			meshManifestation: "No Brasil, enforcement judicial é lento, infraestrutura regulada importa, registradoras mudam economia da cessão, LGPD afeta portabilidade e dados, e normas informais da construção civil afetam execução e confiança."
			meshImplication:   "Se o ambiente institucional é fraco ou lento, a Mesh precisa reforçar proteções ex ante, controle técnico e enforcement privado. Se o ambiente é rigidamente regulado, algumas decisões de fronteira ficam pré-estruturadas pela regulação."
			dependsOn:         ["tf-transaction-costs"]
			rationale:         "A firma não decide no vácuo; decide dentro de um ambiente institucional concreto."
		},
		{
			id:                "tf-minimum-efficient-scale"
			name:              "Escala Mínima Eficiente"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Há atividades que só passam a fazer sentido internamente acima de certo volume, porque exigem custos fixos e capacidade estável que não se diluem em baixa escala."
			meshManifestation: "Operar banking próprio, treinar ou servir certos modelos, manter funções reguladas ou operar componentes sofisticados com qualidade pode ser economicamente inviável cedo demais. IA reduz algumas escalas mínimas, mas não as elimina."
			meshImplication:   "Para toda proposta de build, estimar explicitamente o threshold de escala que tornaria a internalização eficiente. Diferenciar custo greenfield de custo marginal sobre capacidades já existentes."
			dependsOn:         ["tf-coordination-costs"]
			rationale:         "Sem isso, 'internalizar depois' vira frase vaga e não critério de decisão."
		},
		{
			id:                "tf-capability-constraint"
			name:              "Restrição de Capacidade Organizacional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Mesmo quando internalizar é economicamente desejável em tese, a firma pode não ter capacidade para executar com qualidade e segurança no momento atual."
			meshManifestation: "A Mesh precisa distinguir entre 'deveria ser nosso no estado final' e 'conseguimos operar isso agora sem quebrar governança, foco e correção operacional'."
			meshImplication:   "Separar desejabilidade estrutural de viabilidade imediata. Se algo é claramente core, mas a capacidade atual não comporta internalização, a resposta correta é híbrido com plano explícito e threshold de reclassificação — não terceirização inconsciente nem internalização prematura."
			dependsOn:         ["tf-coordination-costs", "tf-minimum-efficient-scale"]
			rationale:         "Capacidade é restrição real, especialmente em empresa AI-native ainda em formação."
		},
		{
			id:                "tf-switching-costs-portability"
			name:              "Custos de Troca, Portabilidade e Optionality"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Switching cost é a tradução prática de lock-in. Portabilidade e optionality são investimentos deliberados para reduzir o custo futuro de trocar."
			meshManifestation: "Abstrações bem desenhadas, formatos exportáveis, contratos com direito real de saída, separação entre domínio e provider, ports and adapters e documentação de migração reduzem dependência futura. Porém optionality excessiva em tudo cria sobrecusto e lentidão."
			meshImplication:   "Calibrar investimento em optionality pelo risco líquido: criticidade do ativo, especificidade, assimetria de poder, reversibilidade e dependência bilateral. Nem tudo merece máxima abstração; o crítico e difícil de reverter merece."
			dependsOn:         ["tf-hold-up-problem", "tf-bilateral-dependence"]
			rationale:         "Optionality precisa ser econômica, não dogmática."
		},
		{
			id:                "tf-error-asymmetry"
			name:              "Assimetria de Erro"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Nem todo erro de fronteira tem o mesmo custo. Internalizar commodity cedo demais costuma gerar desperdício recuperável. Delegar algo existencial cedo demais pode amputar o core."
			meshManifestation: "Delegar scoring, qualificação ou controle sobre ativos informacionais centrais pode comprometer a tese da Mesh. Já internalizar cedo demais uma camada commodity pode apenas atrasar execução."
			meshImplication:   "Toda decisão de fronteira deve registrar custo de errar para cada lado. Isso determina urgência de reavaliação, profundidade analítica e investimento em salvaguardas."
			dependsOn:         ["tf-capability-constraint", "tf-switching-costs-portability"]
			rationale:         "A mesma incerteza exige respostas diferentes dependendo do lado para o qual o erro pesa mais."
		},
		{
			id:                "tf-make-or-buy-framework"
			name:              "Framework Integrado de Make-or-Buy"
			nature:            "theoretical"
			role:              "method"
			definition:        "A decisão correta combina três blocos. Drivers: especificidade, complementaridade e direitos residuais. Moduladores: frequência, incerteza e forma de oportunismo. Restrições: capacidade e escala. O output não é apenas build ou buy; pode ser buy, build, hybrid, buy-now-build-later, ou build-core-buy-envelope."
			meshManifestation: "Qualificação e scoring tendem a cair em build. Banking tende a buy-now-build-later ou hybrid dependendo de SCD, escala e qualidade dos dados do parceiro. Provider de IA tende a hybrid com forte optionality. Infra commodity tende a buy."
			meshImplication:   "Aplicar a hierarquia correta: drivers decidem direção estrutural; moduladores calibram; restrições vetam timing. Não contar fatores como votos equivalentes. A classificação DDD precisa ser coerente com a decisão final."
			dependsOn: [
				"tf-asset-specificity",
				"tf-asset-complementarity",
				"tf-residual-property-rights",
				"tf-opportunism",
				"tf-bounded-rationality",
				"tf-minimum-efficient-scale",
				"tf-capability-constraint",
				"tf-error-asymmetry",
			]
			rationale:         "Integra a lente inteira em uma gramática de decisão operacional."
		},
		{
			id:                "tf-mesh-boundary-map"
			name:              "Mapa de Fronteiras da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "semi-annual"
			definition:        "Artefato vivo que classifica cada atividade relevante da Mesh por governança atual, drivers, moduladores, restrições, switching cost, dependência bilateral, gatilho de reclassificação e assimetria de erro."
			meshManifestation: "O mapa separa com clareza o que é core já internalizado, o que é supporting em híbrido, o que é commodity comprada, o que está em transição, e o que exige optionality reforçada."
			meshImplication:   "Toda decisão desta lens deve atualizar o boundary map. Decisões com erro existencial exigem revisão mais frequente. Decisões recuperáveis podem ser revisadas em ciclo mais longo. O mapa é memória institucional de fronteira."
			dependsOn:         ["tf-make-or-buy-framework", "tf-switching-costs-portability", "tf-error-asymmetry"]
			rationale:         "Sem boundary map, a lente decide bem uma vez e a organização esquece por que decidiu."
		},
	]
}
