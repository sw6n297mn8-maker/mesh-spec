package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

organizationalEconomics: artifact_schemas.#AnalyticalLens & {
	id:      "lens-organizational-economics"
	name:    "Economia Organizacional"
	purpose: "Modelar como a Mesh se organiza internamente para decidir, delegar, supervisionar e escalar com agentes de IA e founder humano no loop. A lente trata organização como sistema de autoridade, artefatos, cadência e alocação de atenção sob restrições reais."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve como a Mesh se organiza internamente, incluindo quem faz o quê e quem decide o quê",
			"a decisão envolve delegação de decisão para agentes de IA e o design de supervisão humana",
			"a decisão envolve o solo founder como gargalo ou single point of failure",
			"a decisão envolve escalar operação sem adicionar hierarquia humana tradicional",
			"a decisão envolve como conhecimento organizacional é mantido entre sessões de agentes de IA",
			"a decisão envolve complementaridades entre decisões organizacionais",
			"a decisão envolve trade-off entre exploration e exploitation",
			"a decisão envolve design de autoridade, incluindo autoridade formal versus real",
			"a decisão envolve como artefatos, como CLAUDE.md, lenses e schemas, escalam o founder",
			"a decisão envolve context window finito como restrição de design de artefatos",
			"a decisão envolve reclassificação de decisões conforme capability de IA muda",
			"a decisão envolve cadência operacional, batching ou mode-switching do founder",
		]
		keywords: [
			"organização", "organizational", "interna",
			"delegação", "delegation", "autoridade",
			"solo founder", "bottleneck", "gargalo",
			"escalar", "scaling", "crescimento interno",
			"agente de IA", "AI agent", "Claude Code",
			"supervisão", "human-in-the-loop", "oversight",
			"conhecimento", "knowledge", "memória organizacional",
			"CLAUDE.md", "tension-log", "governance",
			"complementaridade", "interdependência",
			"exploração", "exploitation", "inovação",
			"context window", "contexto", "sessão",
			"capability", "jagged frontier",
			"multitask", "alocação de atenção",
			"dívida organizacional", "debt",
			"cadência", "batching", "mode-switching",
		]
		excludeWhen: [
			"a decisão é sobre fronteira organizacional make-or-buy; usar lens-theory-of-firm",
			"a decisão é sobre design de incentivos para participantes externos; usar lens-mechanism-design",
			"a decisão é sobre estrutura de mercado ou pricing; usar lens-market-design",
			"a decisão é sobre efeitos de rede e crescimento de plataforma; usar lens-platform-dynamics",
			"a decisão é sobre termos contratuais com terceiros; usar lens-contract-theory",
		]
		rationale: "Theory of firm decide a fronteira da firma. Economia organizacional modela o que acontece dentro dela: autoridade, delegação, coordenação, conhecimento, complementaridades, atenção e escala. Na Mesh, esses problemas aparecem de forma específica porque a organização é IA-first, com contexto finito, capability dinâmica e founder com bandwidth limitada."
	}

	concepts: [
		{
			id:                "oe-solo-founder-bottleneck"
			name:              "Solo Founder como Bottleneck Multidimensional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O solo founder acumula papéis de decisor estratégico, supervisor, designer de sistema e instância residual. O gargalo não é apenas capacidade total; inclui alocação multitarefa, custo de mode-switching, degradação de qualidade ao longo de blocos de decisão, risco de single point of failure e padrões de estresse que pioram julgamento."
			meshManifestation: "O founder alterna entre pensar arquitetura, revisar exceções operacionais, supervisionar agentes e resolver edge cases. Blocos longos de exceções degradam a qualidade das últimas decisões; interrupções durante trabalho profundo consomem horas invisíveis."
			meshImplication:   "A Mesh precisa classificar tipos de decisão, impor cadência temporal explícita, limitar decisões por bloco e tratar a indisponibilidade do founder como risco arquitetural, não apenas risco pessoal."
			rationale:         "Sem modelar o bottleneck em várias dimensões, a empresa tende a atacar apenas volume e ignorar qualidade, cadência e SPOF."
		},
		{
			id:                "oe-ai-delegation"
			name:              "Delegação para Agentes de IA com Contexto Limitado e Drift"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Delegação para IA não sofre de self-interest clássico, mas sofre de contexto limitado, inconsistência inter-sessão, capability irregular e drift. Autoridade formal pode permanecer com o founder enquanto autoridade real migra para o agente quando outputs são aceitos sem revisão substantiva."
			meshManifestation: "Um agente implementa uma interpretação incompleta porque o artefato tinha lacuna. O founder não revisa a fundo e, na prática, a decisão já foi tomada pelo agente, mesmo sem delegação explícita."
			meshImplication:   "A Mesh deve distinguir drift de gaming, definir autoridade por tipo de decisão, revisar amostras de output e usar artefatos, schemas e CI como mecanismos de consistência organizacional."
			rationale:         "O problema central não é motivação adversária; é delegação sobre base informacional incompleta e capability irregular."
			dependsOn:         ["oe-solo-founder-bottleneck"]
		},
		{
			id:                "oe-context-window-constraint"
			name:              "Context Window como Restrição Organizacional"
			nature:            "theoretical"
			role:              "property"
			definition:        "Contexto finito por sessão cria uma restrição organizacional inédita: mais artefatos aumentam conhecimento disponível, mas podem reduzir acessibilidade prática. O problema não é só partição; é também unknown unknowns, quando o agente não sabe o que precisa carregar."
			meshManifestation: "A Mesh acumula lenses e artefatos suficientes para externalizar conhecimento, mas um agente pode deixar de buscar uma lens relevante porque não havia trigger operacional claro."
			meshImplication:   "Artefatos devem ser localmente úteis, hierarquicamente compostos e conectados por cross-triggers condicionais. Em decisões multi-lens, composição sequencial costuma ser superior a carregar tudo ao mesmo tempo."
			rationale:         "Sem tratar context window como constraint organizacional, conhecimento cresce mais rápido do que capacidade de usá-lo."
			dependsOn:         ["oe-ai-delegation"]
		},
		{
			id:                "oe-organizational-knowledge"
			name:              "Conhecimento Organizacional como Artefato"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Na Mesh, conhecimento organizacional vive em artefatos como CLAUDE.md, lenses, tension-log, schemas, CI e código. Esses artefatos funcionam como memória, extensão cognitiva e mecanismo de escala. O oposto disso é dívida organizacional: edge cases não codificados, rationale ausente e artefatos desatualizados."
			meshManifestation: "Quando um edge case é resolvido e não vira artefato, ele precisa ser reaprendido pelo founder ou reencenado por agentes. Quando vira artefato bom, a decisão passa a escalar."
			meshImplication:   "A empresa deve tratar codificação de conhecimento como investimento com ROI, manter rationale explícito e operar cadências de revisão que evitem falsa cobertura por artefatos obsoletos."
			rationale:         "Escala organizacional em uma empresa IA-first depende mais de qualidade de artefato do que de hierarquia humana."
			dependsOn:         ["oe-ai-delegation"]
		},
		{
			id:                "oe-complementarities"
			name:              "Complementaridades Organizacionais"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Decisões organizacionais frequentemente são complementares: o valor de uma aumenta quando a outra também existe. Mudanças locais em componentes fortemente complementares degradam o sistema inteiro quando feitas isoladamente."
			meshManifestation: "Alterar scoring sem ajustar pricing ou covenants cria desalinhamento. Criar nova lens sem atualizar o artefato raiz reduz usabilidade, porque agentes não sabem que ela existe."
			meshImplication:   "Mudanças relevantes devem consultar um mapa de complementaridades e diferenciar o que pode ser alterado localmente do que exige rollout coordenado."
			rationale:         "Sem complementaridades explícitas, a organização parece modular quando, na prática, não é."
			dependsOn:         ["oe-organizational-knowledge"]
		},
		{
			id:                "oe-exploration-exploitation"
			name:              "Exploration e Exploitation em Dois Níveis"
			nature:            "theoretical"
			role:              "framework"
			definition:        "O trade-off entre exploration e exploitation opera em nível macro e micro. Macro: a empresa inteira pode estar em fase de validação. Micro: subsistemas específicos podem já exigir exploração baixa e otimização alta. Além disso, há diferentes tipos de exploration e diferentes formas de exploitation."
			meshManifestation: "A Mesh pode ainda estar validando a tese no mercado, mas já precisar explorar menos e operar com rigidez maior em scoring crítico ou em infraestrutura regulatória."
			meshImplication:   "Toda alocação deve perguntar primeiro em que fase macro a empresa está e depois distinguir se a proposta é novo segmento, nova feature, nova tecnologia ou novo artefato. Isso evita confundir fuga para novidade com trabalho realmente estratégico."
			rationale:         "Sem separar macro e micro, a empresa superotimiza o não validado ou experimenta demais no que já deveria estar estável."
			dependsOn:         ["oe-solo-founder-bottleneck"]
			crossDependsOn: [
				{
					lensId:    "lens-platform-dynamics"
					conceptId: "pd-critical-mass"
					context:   "A fase macro de PMF em plataforma pode ser assimétrica por lado, então o diagnóstico de exploration e exploitation depende também de massa crítica por participante."
				},
			]
		},
		{
			id:                "oe-authority-design"
			name:              "Design de Autoridade com Capability Dinâmica"
			nature:            "theoretical"
			role:              "method"
			definition:        "Autoridade deve ser desenhada por tipo de decisão e revisada conforme capability muda. A distinção central é entre decisões automatizáveis, supervisionáveis, reservadas e estratégicas. Além disso, cada tipo precisa de failure mode explícito e protocolo de pausa quando drift ou erro ultrapassa o aceitável."
			meshManifestation: "Um fluxo que ontem exigia revisão manual pode se tornar supervisionável após melhora de modelo e artefatos. O oposto também ocorre quando drift cresce e o sistema precisa ser temporariamente reescalado ao founder."
			meshImplication:   "A Mesh deve usar progressão gradual de delegação, failure analysis antes de automatizar, thresholds claros para escalação e pausa temporária quando a taxa de inconsistência excede o tolerável."
			rationale:         "Delegar sem failure mode e sem reclassificação dinâmica transforma ganho de escala em erro em escala."
			dependsOn:         ["oe-ai-delegation", "oe-complementarities"]
		},
		{
			id:                "oe-organizational-culture-external"
			name:              "Cultura Percebida via Defaults e Exceções"
			nature:            "theoretical"
			role:              "heuristic"
			definition:        "Em uma organização IA-first, cultura interna aparece externamente principalmente em defaults e políticas de exceção. A maior parte dos usuários vê os outputs frequentes; uma minoria vê edge cases. Ambos moldam reputação."
			meshManifestation: "A diferença entre uma aprovação fria e uma aprovação transparente, ou entre exceção rígida e exceção humanizada, altera percepção de marca mesmo sem qualquer mudança formal de estratégia."
			meshImplication:   "A Mesh deve mapear touchpoints frequentes, definir tom e transparência como defaults e codificar explicitamente como trata exceções legítimas versus fraude ou não conformidade."
			rationale:         "Cultura não é só valor declarado; é comportamento codificado em artefatos e executado por agentes."
			dependsOn:         ["oe-organizational-knowledge", "oe-authority-design"]
		},
		{
			id:                "oe-scaling-without-hierarchy"
			name:              "Escalar sem Hierarquia Humana Tradicional"
			nature:            "theoretical"
			role:              "framework"
			definition:        "Escalar em uma organização IA-first significa adicionar agentes e melhorar artefatos, não necessariamente adicionar camadas gerenciais humanas. O bottleneck principal migra para qualidade de especificação, consistência e coordenação entre agentes concorrentes."
			meshManifestation: "A operação pode crescer de dezenas para centenas de decisões por dia com mais agentes, mas a variância entre eles cresce se artefatos forem incompletos ou se anomalias não forem broadcastadas imediatamente."
			meshImplication:   "A Mesh deve seguir a sequência especificar, validar, delegar, monitorar e ajustar. Também precisa de mecanismos de broadcast e pausa de categoria quando um agente detecta anomalia sistêmica."
			rationale:         "Escala sem hierarquia é viável, mas só quando consistência e coordenação são tratadas como problemas de arquitetura."
			dependsOn:         ["oe-ai-delegation", "oe-organizational-knowledge", "oe-complementarities", "oe-context-window-constraint"]
		},
		{
			id:                "oe-mesh-organizational-health"
			name:              "Saúde Organizacional da Mesh"
			nature:            "operational"
			role:              "method"
			reviewCadence:     "quarterly"
			definition:        "A saúde organizacional deve ser monitorada com poucas métricas primárias, como taxa de escalação, tempo médio de decisão supervisionada e dívida organizacional, e com métricas secundárias acionadas sob demanda, como variância interagente, ratio criação-manutenção, saturação de contexto e alinhamento entre capability e classificação."
			meshManifestation: "No bootstrap, escalação é alta e pode ser saudável. Com amadurecimento, a meta é reduzir escalação por melhoria real de artefatos, não por revisão menos cuidadosa."
			meshImplication:   "O dashboard organizacional deve manter poucas métricas sempre visíveis e usar as demais apenas para diagnóstico quando houver sinal de problema. Isso evita overhead analítico que piora o próprio bottleneck."
			rationale:         "Métrica em excesso pode se tornar mais um sintoma do problema organizacional em vez de solução."
		},
	]

	reasoningProtocol: [
		{
			question:  "Que tipo de decisão é esta: automatizável, supervisionável, reservada ou estratégica?"
			reveals:   "Define a camada correta de autoridade e evita tanto bottleneck artificial quanto delegação prematura."
			rationale: "Classificação vem antes de execução."
		},
		{
			question:  "Se a decisão for delegada, qual é o failure mode principal e qual é o safety net correspondente?"
			reveals:   "Expõe risco real antes da delegação e obriga a pensar em pausa, anomaly detection ou revisão."
			rationale: "Delegar sem failure analysis é aposta organizacional."
		},
		{
			question:  "A capability atual mudou desde a última classificação dessa decisão?"
			reveals:   "Mostra se há bottleneck artificial ou automação obsoleta."
			rationale: "A jagged frontier se move; a organização precisa se mover com ela."
		},
		{
			question:  "Existe artefato suficiente, atualizado e localmente útil para suportar essa decisão?"
			reveals:   "Mostra se a decisão é realmente delegável ou se depende de conhecimento tácito não externalizado."
			rationale: "Artefato é condição de escala organizacional."
		},
		{
			question:  "Quais complementaridades organizacionais essa mudança afeta?"
			reveals:   "Distingue mudança local de mudança que exige rollout coordenado."
			rationale: "Alterações isoladas em sistemas complementares degradam o todo."
		},
		{
			question:  "A alocação atual favorece exploration ou exploitation, e isso combina com a fase macro da empresa?"
			reveals:   "Expõe distorções de atenção, fuga para novidade ou otimização prematura."
			rationale: "March sem fase macro vira diagnóstico incompleto."
			appliesWhen: "alocação de esforço, novo projeto, novo artefato ou novo experimento"
		},
		{
			question:  "O founder está em stress, hyperfocus, fuga para novidade ou fadiga de julgamento?"
			reveals:   "Mostra distorções de decisão que parecem estratégicas, mas são fisiológicas ou comportamentais."
			rationale: "O sistema precisa ser robusto também contra erro do próprio founder."
			appliesWhen: "bloco longo de decisões, domínio ignorado por dias ou decisão crítica sob pressão"
		},
		{
			question:  "A autoridade formal coincide com a autoridade real?"
			reveals:   "Identifica migração silenciosa de decisão para agentes ou, no sentido oposto, intervenção excessiva do founder."
			rationale: "Formal e real divergem facilmente em operação IA-first."
			appliesWhen: "delegação, revisão, inconsistência de outputs ou mudança de processo"
		},
		{
			question:  "A dívida organizacional está crescendo mais rápido que a capacidade de manutenção?"
			reveals:   "Mostra se a organização está consumindo amanhã para ganhar velocidade ilusória hoje."
			rationale: "Dívida organizacional compõe de forma silenciosa."
		},
		{
			question:  "O contexto necessário cabe e os cross-triggers relevantes existem?"
			reveals:   "Mostra se o problema é de conteúdo ausente ou de conteúdo inacessível."
			rationale: "Em organizações IA-first, contexto é recurso escasso."
			appliesWhen: "multi-lens, crescimento de artefatos ou outputs inconsistentes"
		},
		{
			question:  "Que cultura essa decisão projeta nos defaults e nas exceções?"
			reveals:   "Traduz decisão interna em percepção externa de confiança, rigidez, transparência e humanidade."
			rationale: "Defaults definem marca; exceções definem reputação."
			appliesWhen: "touchpoints frequentes, edge cases ou mudança em comunicação de decisão"
		},
	]

	meshExamples: [
		{
			id:                "ex-scoring-change-complementarities"
			scenario:          "O founder quer adicionar variabilidade de lead time ao scoring."
			analysis:          "A decisão não é só técnica. Ela afeta scoring, pricing, covenants, prompts de validação e artefatos raiz. Se for tratada como ajuste local, cria desalinhamento entre componentes fortemente complementares. Além disso, se vier no meio de fadiga decisória, a calibração piora."
			recommendation:    "Tratar a mudança como decisão reservada com rollout coordenado. Verificar estabilidade do scoring atual antes de expandi-lo, mapear complementaridades afetadas, usar dual-track ou shadow mode, registrar rationale e calibrar em bloco cognitivo fresco."
			principlesApplied: ["ax-03", "dp-04", "dp-07"]
			assumptions: [
				"a nova variável tem plausibilidade econômica e operacional",
				"há capacidade de testar o impacto antes de produção plena",
			]
			rationale: "O caso mostra que complementaridades e qualidade cognitiva do founder importam tanto quanto a variável em si."
		},
		{
			id:                "ex-delegation-antecipation"
			scenario:          "A Mesh opera 30 antecipações por dia com revisão do founder em todas e quer escalar para 100."
			analysis:          "A operação está tratando decisão supervisionável como decisão reservada. Isso cria bottleneck de capacidade, fragmenta atenção e degrada qualidade em blocos grandes. Ao mesmo tempo, certos failure modes ainda exigem proteção adicional, então não basta automatizar tudo."
			recommendation:    "Reclassificar a maioria das antecipações para fluxo tipo 1 ou 2, com thresholds explícitos de escalação, anomaly detection para padrões catastróficos, blocos fixos de revisão, cap de exceções por bloco e amostragem periódica. Definir também broadcast imediato para categorias anômalas."
			principlesApplied: ["ax-01", "ax-02", "dp-04"]
			assumptions: [
				"a maior parte do volume é suficientemente padronizável",
				"há dados mínimos para definir thresholds de escalação",
			]
			rationale: "Escala exige redesign de autoridade, não apenas mais esforço do founder."
		},
		{
			id:                "ex-drift-detected-reactive"
			scenario:          "O founder encontra antecipações já processadas com dilution incorreta porque agentes aplicaram regra errada a serviços."
			analysis:          "O problema pode ser artefato incompleto, trigger ausente, revisão insuficiente ou combinação dos três. Enquanto isso não é diagnosticado, outros agentes podem continuar propagando o mesmo erro."
			recommendation:    "Broadcastar pausa imediata da categoria afetada, reclassificá-la temporariamente para revisão mais alta, diagnosticar se a falha foi de conteúdo ou carregamento, corrigir artefato e trigger, registrar o incidente em tension-log e comunicar repricing ou absorção de perda com transparência adequada."
			principlesApplied: ["ax-02", "dp-05", "dp-07"]
			assumptions: [
				"há como isolar a categoria afetada sem paralisar toda a operação",
				"a regra correta pode ser explicitada de forma operacional",
			]
			rationale: "Em operação multiagente, latência de correção amplia blast radius rapidamente."
		},
	]

	principleIds: ["ax-01", "ax-02", "ax-03", "dp-04", "dp-05", "dp-07"]

	relatedLenses: [
		{
			lensId:   "lens-theory-of-firm"
			relation: "complementsWith"
			context:  "Theory of firm trata a fronteira da firma; esta lente trata a arquitetura interna de autoridade, artefatos, conhecimento e coordenação dentro dessa fronteira."
		},
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "Mechanism design projeta incentivos externos; esta lente trata mecanismos internos como artefatos, thresholds, workflows e regras de supervisão."
		},
		{
			lensId:   "lens-complex-adaptive-systems"
			relation: "complementsWith"
			context:  "Complex adaptive systems ajuda a entender adaptação e coevolução do sistema; esta lente traduz isso para desenho organizacional interno, drift e dívida."
		},
		{
			lensId:   "lens-behavioral-economics"
			relation: "complementsWith"
			context:  "Behavioral economics ajusta o modelo para vieses do founder e limitações humanas; esta lente usa esses vieses como restrição interna de desenho organizacional."
		},
		{
			lensId:   "lens-commons-collective-action"
			relation: "complementsWith"
			context:  "Esta lente trata artefatos como commons internos; commons and collective action ajuda a pensar manutenção, degradação e free-riding sobre esse acervo."
		},
		{
			lensId:   "lens-platform-dynamics"
			relation: "complementsWith"
			context:  "Platform dynamics modela crescimento externo e critical mass; esta lente conecta isso à capacidade interna de sustentar o estágio certo de exploration e exploitation."
		},
		{
			lensId:   "lens-market-design"
			relation: "complementsWith"
			context:  "Market design estrutura decisões de mercado; esta lente define quem internamente pode projetar, revisar e operar essas estruturas."
		},
		{
			lensId:   "lens-contract-theory"
			relation: "complementsWith"
			context:  "Contract theory trata contratos com terceiros; esta lente trata artefatos internos como contratos incompletos que distribuem autoridade e direitos residuais."
		},
		{
			lensId:   "lens-information-economics"
			relation: "complementsWith"
			context:  "Information economics modela assimetria entre agentes econômicos; esta lente modela a assimetria invertida entre founder com conhecimento tácito e agentes com capacidade de processamento."
		},
	]

	limitations: [
		{
			description: "Economia organizacional aplicada a organizações IA-first ainda é um campo pouco estabilizado."
			alternative: "Usar os clássicos como base e adaptar empiricamente os mecanismos à prática real da Mesh."
			rationale:   "A lente é framework de trabalho, não teoria fechada."
		},
		{
			description: "Boa parte da modelagem assume um solo founder como premissa operacional central."
			alternative: "Quando a organização mudar, reavaliar desenho de autoridade, cadência e divisão de trabalho, preservando o que continua válido nos artefatos."
			rationale:   "A estrutura futura pode mudar, mas muitos princípios de coordenação e conhecimento permanecem."
		},
		{
			description: "Consistência interagente é difícil de medir diretamente."
			alternative: "Usar amostragem, incidentes, taxa de escalação e variância observada como proxies operacionais."
			rationale:   "Medição perfeita custa mais do que a organização comporta no bootstrap."
		},
		{
			description: "Artefato incompleto pode ser pior do que ausência de artefato, porque transmite falsa cobertura."
			alternative: "Marcar maturidade, manter revisão periódica e não usar artefatos críticos como base de delegação ampla sem validação."
			rationale:   "Falsa confiança é mais perigosa do que incerteza explícita."
		},
		{
			description: "Vieses do founder resistem a auto-observação estável."
			alternative: "Converter parte do autocontrole em sistema: gates, caps por bloco, cadência fixa, alertas e critérios explícitos."
			rationale:   "Sistema robusto é mais confiável do que disciplina subjetiva."
		},
		{
			description: "Context window e capacidades de IA podem mudar rapidamente com a tecnologia."
			alternative: "Tratar a implementação atual como contingente, preservando princípios mais profundos de conhecimento, autoridade, partição e complementaridade."
			rationale:   "A forma muda antes dos princípios."
		},
		{
			description: "Artefact-centrism pode se tornar parcialmente obsoleto se agentes ganharem memória persistente melhor."
			alternative: "Preservar a lógica de knowledge externalization e governança, mesmo que o suporte técnico deixe de ser apenas textual."
			rationale:   "O meio pode mudar, mas a necessidade de explicitude e auditabilidade permanece."
		},
		{
			description: "Degradação de qualidade do founder não é apenas fadiga simples; inclui carryover emocional e contaminação entre tipos de decisão."
			alternative: "Separar blocos por tipo, reservar janelas frescas para decisões estratégicas e limitar volume por bloco."
			rationale:   "Julgamento é recurso finito e contextual, não só tempo disponível."
		},
	]

	rationale: "Economia Organizacional, na Mesh, trata da arquitetura interna da decisão. Enquanto theory of firm decide a fronteira, esta lente decide como operar dentro dela quando a organização é IA-first, o founder é gargalo real e agentes têm contexto finito, capability irregular e autoridade real crescente. O foco está em classificar decisões, desenhar autoridade dinâmica, transformar artefatos em memória e escala, coordenar complementaridades, regular exploration e exploitation, reduzir mode-switching destrutivo, conter dívida organizacional e tornar a organização robusta contra erro humano e erro da própria IA. Em uma empresa como a Mesh, organização não é camada administrativa. É parte do mecanismo central de correção operacional, governança e escala."
}
