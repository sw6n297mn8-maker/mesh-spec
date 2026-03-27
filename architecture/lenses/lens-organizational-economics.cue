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
}
