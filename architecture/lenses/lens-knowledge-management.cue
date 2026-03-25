package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

knowledgeManagement: artifact_schemas.#AnalyticalLens & {
id:     "lens-knowledge-management"
name:   "Gestão do Conhecimento e Aprendizagem Organizacional"

purpose: "Orientar decisões sobre como capturar, organizar e tornar acessível o conhecimento acumulado pela plataforma e seus agentes."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como capturar, documentar ou preservar conhecimento organizacional",
		"a decisão envolve como tornar conhecimento acessível a agentes de IA ou novos membros da organização",
		"a decisão envolve documentar uma decisão importante com contexto, alternativas e rationale",
		"a decisão envolve converter conhecimento tácito (na cabeça do founder) em explícito (em artefatos)",
		"a decisão envolve gerenciar a carga cognitiva de quem opera o sistema (humano ou agente)",
		"a decisão envolve como agentes stateless recuperam contexto necessário para raciocinar sobre decisões",
		"a decisão envolve aprender sistematicamente com experiências — não apenas corrigir erros mas questionar premissas",
		"a decisão envolve prevenir perda de conhecimento quando contexto muda, pessoas saem ou sistemas evoluem",
		"a decisão envolve definir cadência de revisão e atualização de conhecimento documentado",
		"a decisão envolve estruturar repositórios de conhecimento (mesh-spec, CLAUDE.md, decision records) para máxima utilidade",
		"a decisão envolve como a organização transforma incidentes, experimentos e interações em aprendizado estruturado",
	]
	keywords: [
		"conhecimento", "documentação", "knowledge base", "wiki",
		"decisão", "decision record", "ADR", "rationale",
		"CLAUDE.md", "mesh-spec", "artefato", "schema",
		"memória organizacional", "contexto", "histórico",
		"aprendizado", "learning", "post-mortem", "retrospectiva",
		"tácito", "explícito", "codificação", "externalização",
		"carga cognitiva", "cognitive load", "onboarding",
		"knowledge graph", "RAG", "retrieval", "embedding",
		"amnésia institucional", "perda de conhecimento", "rotatividade",
		"double-loop", "premissa", "revisão de premissa",
		"refresh", "decay", "obsolescência", "atualização",
	]
	excludeWhen: [
		"a decisão é sobre governance de agentes IA (autonomia, escalation, drift) — usar ai-agent-governance",
		"a decisão é sobre policies codificadas que governam comportamento de agentes — usar ai-agent-governance (aag-governance-as-code)",
		"a decisão é sobre observabilidade de sistemas técnicos — usar observability-operational-intelligence",
		"a decisão é sobre comunicação com stakeholders externos — usar stakeholder-communication",
		"a decisão é sobre alocação de recursos entre atividades de documentação vs outras — usar organizational-resource-allocation",
	]
	rationale: "Toda organização opera com base em conhecimento — sobre o mercado, sobre o produto, sobre decisões passadas, sobre o que funciona e o que não funciona. Na Mesh AI-native, conhecimento organizacional é duplamente crítico: (1) agentes IA são stateless — cada sessão começa do zero, e o conhecimento disponível no mesh-spec é literalmente o limite do que o agente sabe sobre a Mesh. (2) solo founder — todo conhecimento tácito está numa única cabeça, sem redundância. Sem gestão explícita, conhecimento se perde quando contexto muda, decisões passadas são re-litigadas sem memória do rationale, e agentes operam com informação incompleta ou obsoleta. O mesh-spec existe para resolver exatamente isso — esta lens fundamenta por quê e como."
}

concepts: [
	{
		id:         "km-organizational-memory"
		name:       "Memória Organizacional: Onde o Conhecimento Reside e Como é Recuperado"
		nature:     "theoretical"
		role:       "framework"
		definition: "Walsh/Ungson (1991, 'Organizational Memory'): memória organizacional é informação armazenada da história da organização que pode ser recuperada para decisões presentes. Reside em cinco repositórios: (1) indivíduos (memória humana), (2) cultura (normas, valores, pressupostos compartilhados), (3) transformações (procedimentos, rotinas codificadas), (4) estruturas (papéis, hierarquia), (5) ecologia (layout físico, artefatos). Stein (1995): memória organizacional tem três processos — aquisição (capturar), retenção (armazenar), e recuperação (acessar quando necessário). Argote/Miron-Spektor (2011, 'Organizational Learning: From Experience to Knowledge'): aprendizado organizacional é o processo de criação, retenção e transferência de conhecimento — a memória é o estoque; o aprendizado é o fluxo. Conceito contemporâneo de 'AI as organizational memory' (Mollick 2024, Co-Intelligence): LLMs como repositórios e interfaces de acesso à memória organizacional — não substituem a memória, mas a tornam acessível de forma conversacional."
		meshManifestation: "Na Mesh, memória organizacional reside em: (1) founder — todo conhecimento tácito sobre estratégia, mercado, relações com stakeholders, intuições não-documentadas. SPOF de conhecimento: se founder fica indisponível, organização perde acesso a ~80% do conhecimento. (2) mesh-spec — decisões arquiteturais, design principles, analytical lenses, schemas CUE. É a memória explícita codificada. (3) código e configuração — como o sistema funciona, quais integrações existem, quais parâmetros governam comportamento. (4) histórico de operações — dados de antecipações, scoring, compliance. Memória factual. (5) post-mortems e tension-logs — aprendizado de falhas e tensões. (6) conversas com Claude Code — decisões tomadas em sessões, mas perdidas se não documentadas no mesh-spec. Gap crítico: a distância entre (1) e (2) — quanto do conhecimento do founder não está codificado?"
		meshImplication: "Mapear gaps de memória: para cada área crítica (arquitetura, mercado, regulação, operação, finanças), avaliar — o conhecimento necessário está em artefato acessível ou está apenas na cabeça do founder? Se apenas na cabeça: é SPOF de conhecimento. Priorizar codificação dos SPOFs de conhecimento mais críticos (decisões arquiteturais irreversíveis, premissas de mercado, relações regulatórias). Para sessões com agentes IA: regra — toda decisão significativa (tipo 2+) gera artefato que persiste no mesh-spec. Se a decisão foi tomada na conversa mas não no repositório, não foi tomada — o próximo agente não saberá. Testar recuperação: mensalmente, simular que founder está indisponível — agente consegue operar com base apenas nos artefatos existentes? Se não: a memória é insuficiente. Métrica: % de decisões tipo 2+ com ADR no mesh-spec. Se <70%: gap de memória crítico. Se >90%: memória explícita é robusta."
		crossDependsOn: [
			{
				lensId:    "lens-organizational-resource-allocation"
				conceptId: "ora-throughput-constraint"
				context:   "ORA identifica que horas do founder são o constraint. KM identifica que o founder é também SPOF de conhecimento. A mesma pessoa é constraint de execução E repositório primário de memória — codificar conhecimento libera não apenas bus factor mas também atenção futura (não precisa re-derivar). Cada hora investida em externalização economiza horas futuras de reconstrução de contexto."
			},
			{
				lensId:    "lens-information-economics"
				conceptId: "ie-information-as-asset"
				context:   "IE modela informação como ativo com valor econômico. KM operacionaliza a criação e preservação desse ativo. O mesh-spec é o ativo informacional mais valioso da Mesh — sua depreciação (knowledge decay) reduz o valor da organização. IE diz 'informação tem valor proprietário'; KM diz 'como produzir, manter e proteger esse valor'."
			},
		]
		rationale: "Walsh/Ungson 1991: cinco repositórios de memória. Argote/Miron-Spektor 2011: memória é estoque, aprendizado é fluxo. Mollick 2024: IA como interface de memória. Na Mesh solo founder + agentes stateless, a distância entre conhecimento tácito e conhecimento codificado é risco existencial."
	},
	{
		id:         "km-tacit-explicit-conversion"
		name:       "Conversão Tácito-Explícito: Tornar o Saber Articulável e Codificável"
		nature:     "theoretical"
		role:       "method"
		definition: "Nonaka/Takeuchi (1995, The Knowledge-Creating Company): conhecimento organizacional é criado pela conversão contínua entre tácito (pessoal, difícil de articular — intuição, experiência, habilidade) e explícito (articulável, codificável — documentos, schemas, código). Quatro modos de conversão (SECI): (1) Socialização (tácito→tácito): aprender por observação e prática compartilhada. (2) Externalização (tácito→explícito): articular intuição em conceitos, modelos, frameworks. (3) Combinação (explícito→explícito): organizar, classificar, sintetizar conhecimento explícito. (4) Internalização (explícito→tácito): aprender pela prática de conhecimento documentado. Polanyi (1966, The Tacit Dimension): 'we can know more than we can tell' — nem todo conhecimento tácito é convertível. Collins (2010, Tacit and Explicit Knowledge): três tipos de tácito — relacional (depende de relação), somático (depende de corpo), e coletivo (depende de comunidade). Apenas parte é explicitável."
		meshManifestation: "Na Mesh, a conversão mais crítica é Externalização (tácito→explícito) — transformar o que o founder sabe em artefatos que agentes podem usar. Exemplos: (1) founder sabe intuitivamente que 'construtoras de médio porte são mais receptivas que grandes' — tácito. Externalizado como critério no lens de segmentação com rationale: 'médias têm dor de supply chain sem ter departamento de compras sofisticado'. (2) founder sabe que 'Bacen valoriza proatividade' — tácito. Externalizado como princípio no sc-regulatory-communication: 'comunicar proativamente antes de ser demandado'. (3) founder desenvolveu intuição sobre quais schemas CUE funcionam e quais são over-engineered — tácito. Externalizado como design principles com rationale. O SECI model na Mesh: Socialização é limitada (solo founder, sem equipe humana para observar). Combinação é o trabalho do mesh-spec (organizar lenses, schemas, principles). Internalização acontece quando agente 'aprende' pela leitura do CLAUDE.md."
		meshImplication: "Prática de externalização sistemática: para cada decisão tipo 2+ que o founder toma baseado em intuição ou experiência, perguntar — 'consigo articular por que tomei essa decisão?' Se sim: documentar no mesh-spec como ADR, design principle, ou conceito de lens. Se não: documentar o que sabe, incluindo 'não consigo articular completamente o rationale — intuição baseada em [experiência X]'. Documentação parcial é melhor que nenhuma. Collins 2010: aceitar que parte do conhecimento não é explicitável — para essas áreas, manter nível de autonomia baixo para agentes (tipo 2-3), não delegar decisões que dependem de tácito não-codificado. Quando contratar: priorizar Socialização — primeiro membro da equipe deve trabalhar com founder para absorver tácito antes de operar independentemente. Anti-pattern: founder documenta tudo perfeitamente mas nunca valida se agente interpreta corretamente — externalização sem validação é externalização ilusória."
		dependsOn: ["km-organizational-memory"]
		crossDependsOn: [{
			lensId:    "lens-behavioral-economics"
			conceptId: "be-overconfidence"
			context:   "BE modela overconfidence bias — tendência de acreditar que sabe mais do que sabe. Na externalização, o risco é acreditar que o artefato captura o tácito quando na verdade captura versão simplificada. BE diz 'humanos superestimam o que sabem articular'; KM diz 'validar externalização — agente interpreta corretamente o que foi codificado?'."
		}]
		rationale: "Nonaka/Takeuchi 1995: SECI como motor de criação de conhecimento. Polanyi 1966: limites do explicitável. Collins 2010: três tipos de tácito. Na Mesh solo founder, externalização é a conversão mais urgente — porque agentes stateless só acessam o explícito."
	},
	{
		id:         "km-decision-records"
		name:       "Registros de Decisão: Documentar o Quê, Por Quê, e o Que Foi Descartado"
		nature:     "operational"
		role:       "method"
		reviewCadence: "event-driven"
		definition: "Nygard (2011, 'Documenting Architecture Decisions'): Architecture Decision Records (ADRs) documentam decisões significativas com: contexto, decisão, alternativas consideradas, consequências, e status. A chave é documentar não apenas o que foi decidido mas por que, e especialmente o que foi descartado e por quê — porque daqui a 6 meses, sem esse registro, a decisão será re-litigada desde o início. Tyree/Akerman (2005, 'Architecture Decisions: Demystifying Architecture'): decisões devem ser first-class artifacts, não efeitos colaterais de documentos. Conceito contemporâneo de 'decision intelligence' (Pratt 2019, Link): decisões como unidade de trabalho organizacional — cada decisão tem inputs (dados, contexto), processo (análise, discussão), output (escolha), e outcome (resultado observado). Documenter a cadeia completa permite aprender não apenas com decisões erradas mas com decisões certas que funcionaram por razões diferentes das esperadas."
		meshManifestation: "Na Mesh, decisões tipo 1-3 da precedence hierarchy devem ter ADR. Exemplos: (1) 'escolhemos CUE em vez de JSON Schema para contratos' — contexto (necessidade de validação + interoperabilidade), decisão (CUE), alternativas descartadas (JSON Schema: sem expressividade; Protobuf: complexidade de toolchain), consequências (dependência do ecossistema CUE, curva de aprendizado). (2) 'operar como correspondente antes de SCD' — contexto (velocidade vs controle), decisão (correspondente), alternativas (SCD direto: lead time 2+ anos; parceria com banco existente: dependência), consequências (limitação de produto, mas validação rápida). Cada ADR no mesh-spec é consultável por agente — agente que propõe 'migrar de CUE para JSON Schema' encontra o ADR e entende por que CUE foi escolhido antes de re-litigar."
		meshImplication: "Para toda decisão tipo 1-3: criar ADR no mesh-spec com: (1) id: decisão com id único (dec-YYYY-MM-NNN). (2) contexto: o que motivou a decisão, que problema existia. (3) decisão: o que foi decidido. (4) alternativas: o que foi considerado e descartado, com rationale de descarte para cada uma. (5) consequências: o que muda, o que fica mais fácil, o que fica mais difícil. (6) principleIds: quais design principles informaram. (7) status: proposed → accepted → deprecated → superseded. (8) revisão: quando reconsiderar (data ou condição). Para agentes: antes de propor mudança em decisão documentada, ler o ADR e articular por que as condições mudaram desde a decisão original. Se condições não mudaram: a decisão está vigente. Se mudaram: propor revisão com referência ao ADR original. Anti-pattern: ADR que é escrito e nunca revisado — conhecimento fossilizado. Todo ADR com condição de revisão deve ser verificado na cadência definida."
		dependsOn: ["km-organizational-memory"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-governance-as-code"
			context:   "AAG codifica policies de agentes em artefatos versionáveis. KM codifica decisões organizacionais em ADRs versionáveis. O princípio é o mesmo (knowledge as code), o escopo é diferente: AAG governa comportamento de agentes; KM preserva rationale de decisões organizacionais. O mesh-spec é repositório para ambos."
		}]
		rationale: "Nygard 2011: ADRs como first-class artifacts. Tyree/Akerman 2005: decisões devem ser documentadas. Pratt 2019: decisão como unidade de trabalho. Na Mesh, ADRs previnem re-litigação e dão ao agente o contexto para entender por que o sistema é como é."
	},
	{
		id:         "km-knowledge-as-code"
		name:       "Knowledge as Code: Conhecimento Versionável, Testável e Auditável"
		nature:     "operational"
		role:       "framework"
		reviewCadence: "quarterly"
		definition: "Extensão de Infrastructure as Code (Morris 2016) e Governance as Code (aag-governance-as-code) para todo o conhecimento organizacional. O princípio: conhecimento que governa decisões deve ser tratado como código — versionado em Git, revisado por pull request, testável por CI, e auditável por diff. Rother (2009, Toyota Kata): routines de melhoria codificadas geram mais aprendizado que routines informais. Forsgren/Humble/Kim (2018, Accelerate): organizações de alta performance versionam tudo que governa comportamento do sistema. Conceito contemporâneo de 'specification as single source of truth' (CUE lang, Dhall, Jsonnet — 2019+): linguagens de configuração que permitem expressar não apenas dados mas constraints, relações e validações — conhecimento estruturado, não apenas texto."
		meshManifestation: "Na Mesh, knowledge as code se materializa no mesh-spec: (1) design-principles.cue — axiomas e princípios como código validável. (2) analytical-lens.cue — schema que governa como agentes raciocinam. (3) lenses/*.cue — instâncias de lenses como código com constraints tipados. (4) decisions/*.md — ADRs versionados. (5) CLAUDE.md — instruções para agentes como artefato versionado. (6) precedence-hierarchy.cue — classificação de decisões como código. Tudo em Git: toda mudança tem autor, data, diff, e review. CI valida: principleId referenciado existe? ConceptId em dependsOn é válido? Schema está consistente? Conhecimento que não está no mesh-spec, para agentes, não existe."
		meshImplication: "Regra: todo conhecimento que governa decisão de agente deve estar no mesh-spec. Se um agente deveria saber algo mas não sabe: a falha é do repositório, não do agente. Workflow: (1) novo conhecimento → branch → PR com rationale → review → merge. (2) mudança de conhecimento → diff auditable → CI verifica consistência. (3) knowledge que referencia external facts (taxa Selic, regulação Bacen, market data) → tem data de validade e cadência de refresh. Para agentes: o CLAUDE.md aponta para o mesh-spec como fonte canônica. Agente não inventa — consulta. Se consulta e não encontra: flag como gap de conhecimento (tensão no tension-log). Anti-pattern: conhecimento em Slack, emails, conversas com Claude que não é destilado em artefato — existe para quem estava lá, não existe para quem chega depois."
		dependsOn: ["km-decision-records", "km-tacit-explicit-conversion"]
		rationale: "Morris 2016: code > documents. Forsgren et al. 2018: versionar tudo. Na Mesh, o mesh-spec é literalmente a memória do sistema — seu formato (CUE versionado em Git) garante as propriedades de código: versionável, testável, auditável, consultável."
	},
	{
		id:         "km-cognitive-load-management"
		name:       "Gestão de Carga Cognitiva: Reduzir o Custo de Operar e Decidir"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Sweller (1988, 'Cognitive Load During Problem Solving'): carga cognitiva tem três tipos — intrínseca (complexidade do domínio), estranha (ruído do formato/apresentação), e germane (esforço de aprendizado). Reduzir carga estranha libera capacidade para carga intrínseca e germane. Skelton/Pais (2019, Team Topologies): carga cognitiva organizacional — cada equipe tem limite de complexidade que consegue gerenciar. Exceder o limite degrada qualidade de decisão e velocidade. Miller (1956, 'The Magical Number Seven'): working memory humana processa ~7±2 chunks simultaneamente. Conceito contemporâneo de 'prompt engineering as cognitive load design' (2023+): o design do prompt para LLMs é essencialmente design de carga cognitiva — qual informação incluir, em que ordem, em que formato, para maximizar qualidade de output do agente sem exceder context window."
		meshManifestation: "Na Mesh, carga cognitiva afeta: (1) founder — cada decisão tipo 2+ requer carregar contexto de múltiplas dimensões (arquitetura, regulação, mercado, finanças). Se o contexto não está organizado e acessível, o founder gasta tempo reconstruindo antes de decidir. (2) agentes IA — o CLAUDE.md e mesh-spec são o 'contexto' do agente. Se CLAUDE.md tem 500 linhas de instruções desestruturadas, carga estranha é alta — agente gasta tokens processando formato em vez de raciocinar sobre o problema. (3) futuros membros da equipe — se documentação é extensa mas desorganizada, onboarding é lento e learning curve é alta. Carga estranha no mesh-spec: lenses com 20 conceitos cada × 17 lenses = 340 conceitos. Agente que precisa raciocinar sobre decisão de pricing não precisa de todos os 340 — precisa de 20-30 relevantes. Sem organização: carga estranha massiva."
		meshImplication: "Projetar artefatos para minimizar carga estranha: (1) CLAUDE.md estruturado com seções claras e hierarquia — agente encontra instrução relevante sem ler tudo. (2) lenses com trigger conditions precisas — agente ativa apenas lenses relevantes, não todas. (3) lens-map.cue como índice navegável — agente consulta mapa antes de decidir qual lens ler. (4) ADRs com template consistente — o formato familiar reduz carga de parsing. (5) progressive disclosure — informação em camadas: summary → detail → rationale. Agente que precisa de overview lê summary; agente que analisa profundamente lê até rationale. Para founder: batch decisions do mesmo contexto juntas (ora-attention-as-resource) para minimizar carga de context switching. Métrica proxy: se agente precisa de >3 lenses para uma decisão, possivelmente lenses estão fragmentadas demais ou a decisão precisa ser decomposta."
		dependsOn: ["km-knowledge-as-code"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-attention-as-resource"
			context:   "ORA modela atenção como recurso escasso e context switching como custo. KM reduz o custo de usar atenção — artefatos bem-organizados reduzem tempo de reconstrução de contexto. ORA diz 'atenção é finita'; KM diz 'projetar artefatos para consumir mínimo de atenção por unidade de decisão'."
		}]
		rationale: "Sweller 1988: três tipos de carga cognitiva. Skelton/Pais 2019: carga cognitiva organizacional. Miller 1956: working memory finita. Na Mesh, carga estranha do mesh-spec é diretamente traduzível em tokens desperdiçados do agente e horas desperdiçadas do founder. Reduzir carga estranha é ROI direto."
	},
	{
		id:         "km-rag-knowledge-access"
		name:       "Retrieval-Augmented Generation: Como Agentes Acessam Conhecimento Organizacional"
		nature:     "theoretical"
		role:       "framework"
		definition: "Lewis et al. (2020, 'Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks' — Facebook AI): RAG combina recuperação de informação com geração de linguagem — o modelo busca documentos relevantes antes de gerar resposta, evitando alucinação e usando conhecimento atualizado. Gao et al. (2024, 'Retrieval-Augmented Generation for Large Language Models: A Survey'): evolução de RAG — naive RAG (retrieve + generate), advanced RAG (query rewriting, re-ranking, chunk optimization), e modular RAG (pipelines composáveis de retrieval). Barnett et al. (2024, 'Seven Failure Points When Engineering a RAG System'): sete pontos de falha — missing content, missed top ranked, not extracted, not in context, wrong format, incorrect specificity, incomplete. Ram et al. (2023, 'In-Context Retrieval-Augmented Language Models'): retrieval em context window vs fine-tuning — trade-offs de atualidade, custo e controle. Conceito contemporâneo de 'agentic RAG' (2024+): agente decide quando buscar, o que buscar, e avalia qualidade do retrieval antes de usar — não é pipeline fixo mas decisão do agente."
		meshManifestation: "Na Mesh, agentes IA acessam conhecimento organizacional via: (1) CLAUDE.md — instrução direta em context window (in-context, não RAG). (2) mesh-spec como repositório consultável — agente pode ler arquivos CUE, lenses, ADRs. (3) futuro: RAG sobre mesh-spec + histórico de operações + documentação + decisões para perguntas que não estão diretamente no CLAUDE.md. Failure points de RAG no contexto Mesh: (a) missing content — knowledge gap no mesh-spec; agente busca mas não encontra. (b) wrong format — lens em CUE com constraints complexos que o agente não parseia adequadamente. (c) incorrect specificity — agente recupera lens inteira quando precisava de 1 conceito. (d) not in context — context window insuficiente para incluir todos os documentos relevantes."
		meshImplication: "Para acesso atual (pré-RAG): estruturar mesh-spec para máxima navegabilidade — lens-map.cue como índice, naming conventions consistentes, cross-references explícitas (relatedLenses, crossDependsOn). Agente navega pelo mapa, não por busca cega. Para RAG futuro: (1) chunk optimization — cada conceito é um chunk natural (id, definition, meshManifestation, meshImplication). Não chunkar no meio de conceito. (2) metadata — cada chunk com metadata (lensId, conceptId, nature, role) para filtrar retrieval. (3) query routing — pergunta sobre scoring route para lenses de credit-risk + mechanism-design, não para todas as 20+. (4) fallback — se retrieval não encontra resposta: flag como knowledge gap, não alucinar. (5) freshness — retrieval deve priorizar versão mais recente de artefatos. Se ADR foi superseded, retrieval deve retornar o substituto, não o original. Testar: periodicamente, fazer perguntas que o agente deveria responder com base no mesh-spec. Se resposta é incorreta ou incompleta: gap de retrieval ou gap de conteúdo."
		dependsOn: ["km-knowledge-as-code", "km-cognitive-load-management"]
		rationale: "Lewis et al. 2020: RAG como paradigma. Gao et al. 2024: evolução para modular RAG. Barnett et al. 2024: sete failure points. Na Mesh AI-native, a qualidade do acesso ao conhecimento determina a qualidade das decisões do agente — RAG bem-projetado é infraestrutura crítica."
	},
	{
		id:         "km-context-preservation"
		name:       "Preservação de Contexto para Agentes Stateless"
		nature:     "operational"
		role:       "method"
		reviewCadence: "monthly"
		definition: "Problema fundamental de agentes LLM: cada sessão começa sem memória das sessões anteriores. O contexto necessário para decisão precisa ser reconstruído a cada interação — via system prompt, documentos, ou retrieval. Shanahan (2024, Talking About Large Language Models): LLMs não têm experiência persistente — o que 'lembram' é o que está no context window. Sumers et al. (2024, 'Cognitive Architectures for Language Agents'): arquiteturas cognitivas para agentes incluem memória de longo prazo (persistent storage), memória de trabalho (context window), e mecanismos de recuperação (retrieval). O design da memória determina a capacidade do agente. Conceito contemporâneo de 'memory architectures for AI agents' (Park et al. 2023, 'Generative Agents: Interactive Simulacra of Human Behavior'): agentes com memória estruturada (observações → reflexões → planos) operam com coerência muito superior a agentes sem memória."
		meshManifestation: "Na Mesh, o problema de contexto é concreto: (1) sessão de Claude Code na segunda-feira discute decisão sobre estrutura de FIDC. Na quarta, nova sessão do Claude Code precisa continuar — mas não sabe o que foi decidido na segunda a menos que esteja documentado. (2) agente de scoring opera 100 operações/dia. Cada operação é stateless — agente não sabe que a operação anterior do mesmo comprador foi rejeitada, a menos que dados estejam disponíveis. (3) founder tem conversa com regulador, aprende insight sobre expectativas do Bacen. Se insight não é externalizado: agentes não podem incorporar. O mesh-spec é a solução arquitetural: é a memória de longo prazo compartilhada entre todas as sessões. CLAUDE.md é a 'memória de trabalho compactada' — o subset do mesh-spec mais relevante para qualquer sessão."
		meshImplication: "Protocolo de preservação de contexto: (1) fim de sessão — antes de encerrar sessão com agente, documentar: decisões tomadas (como ADR se tipo 2+), mudanças propostas (como PR ou diff), aprendizados (como nota no tension-log ou conceito de lens). Regra: se a sessão produziu decisão que afeta sessões futuras e não foi documentada, a decisão não existe. (2) início de sessão — CLAUDE.md como boot loader: carrega contexto mínimo necessário. Para contexto adicional: agente consulta mesh-spec sob demanda. (3) dados operacionais — estado persistente (scores, status de operações, histórico de comprador) em database consultável, não em memória de sessão. (4) reflexões — periodicamente, compilar aprendizados de múltiplas sessões em atualização do CLAUDE.md ou nova lens/conceito. Park et al. 2023: reflexão é o que transforma observações em conhecimento reutilizável. Anti-pattern: sessão longa e rica que termina sem nenhum artefato persistente — todo o valor da conversa é perdido."
		dependsOn: ["km-organizational-memory", "km-knowledge-as-code"]
		rationale: "Shanahan 2024: LLMs não têm experiência persistente. Sumers et al. 2024: memória determina capacidade. Park et al. 2023: reflexão transforma observação em conhecimento. Na Mesh, o mesh-spec é a prótese cognitiva que compensa statelessness — mas só funciona se for alimentada consistentemente."
	},
	{
		id:         "km-double-loop-learning"
		name:       "Aprendizado de Double-Loop: Questionar Premissas, Não Apenas Corrigir Erros"
		nature:     "theoretical"
		role:       "framework"
		definition: "Argyris/Schön (1978, Organizational Learning): single-loop learning corrige erros dentro do framework existente ('termostatoajusta temperatura'). Double-loop learning questiona o próprio framework ('deveríamos estar medindo temperatura?'). Triple-loop learning (Bateson 1972, via Tosey/Mathison 2009) questiona o processo de aprendizado ('como aprendemos a aprender?'). Senge (1990, The Fifth Discipline): organizações que aprendem combinam personal mastery, mental models, shared vision, team learning, e systems thinking. Edmondson (2019, The Fearless Organization): psychological safety é precondição de double-loop — questionar premissas requer segurança para dizer 'e se estivermos errados?'. Conceito contemporâneo de 'learning from success' (Schoemaker/Gunther McGrath 2023): organizações aprendem desproporcionalmente com falhas; aprender com sucesso requer disciplina igual — por que funcionou? Foi pela razão que pensamos?"
		meshManifestation: "Na Mesh, single-loop e double-loop coexistem: (1) single-loop — scoring produziu falso negativo → recalibrar threshold → scoring melhora. Framework não questionado: 'scoring baseado nessas features é a abordagem correta'. (2) double-loop — por que estamos usando scoring baseado em features financeiras? E se o preditor mais forte for operacional (frequência de entregas, pontualidade, diversidade de clientes)? Framework questionado: a premissa 'features financeiras preveem risco' pode estar errada. (3) single-loop — correspondente bancário limita produtos → buscar novo correspondente. Double-loop — por que estamos operando como correspondente? As limitações são inerentes ao modelo? SCD é necessário mais cedo que planejado? Na Mesh solo founder, o founder é o único que faz double-loop — agentes por default fazem single-loop (operam dentro do framework do CLAUDE.md). Double-loop requer sessões intencionais de questionamento de premissas."
		meshImplication: "Institucionalizar double-loop: (1) revisão trimestral de premissas — lista explícita de premissas que fundamentam estratégia e decisões (ex: 'construção civil é o melhor vertical inicial', 'scoring operacional é superior a scoring financeiro', 'correspondente antes de SCD é a sequência correta'). Para cada premissa: evidência a favor, evidência contra, condição que invalidaria. (2) pre-mortem (Klein 1998) — antes de decisão irreversível: 'imagine que falhou em 12 meses. Por quê?' Isso força double-loop prospectivo. (3) para agentes: instruir que quando análise com lens produz recomendação que contradiz premissa do mesh-spec, o agente deve flaggar a contradição — não resolver silenciosamente em favor da premissa. O flag é trigger de double-loop. (4) aprender com sucesso: quando algo funciona, documentar por que funcionou e verificar se a razão é a esperada. Se scoring AUROC é 0.72 mas as features mais preditivas são diferentes das esperadas: double-loop sobre quais features investir."
		dependsOn: ["km-organizational-memory"]
		crossDependsOn: [{
			lensId:    "lens-real-options"
			conceptId: "ro-experimentation-as-option"
			context:   "RO modela experimentação como opção — investir pouco para aprender antes de investir muito. KM modela como o aprendizado da experimentação é capturado e usado. RO diz 'experimente com gate de falsificação'; KM diz 'o que aprendemos com o experimento e como esse aprendizado é preservado para decisões futuras'."
		}]
		rationale: "Argyris/Schön 1978: double-loop questiona framework, não apenas resultado. Edmondson 2019: safety para questionar. Schoemaker/Gunther McGrath 2023: aprender com sucesso. Na Mesh, premissas não-questionadas são o maior risco estratégico — double-loop institucionalizado é a defesa."
	},
	{
		id:         "km-after-action-review"
		name:       "After-Action Review: Aprendizado Estruturado Pós-Evento"
		nature:     "operational"
		role:       "method"
		reviewCadence: "event-driven"
		definition: "US Army (1993, A Leader's Guide to After-Action Reviews): AAR é processo estruturado pós-evento com quatro perguntas: (1) o que deveria ter acontecido? (2) o que aconteceu? (3) por que houve diferença? (4) o que podemos fazer diferente? Diferente de post-mortem (focado em incidentes/falhas): AAR se aplica a qualquer evento significativo — sucesso, falha, experimento, decisão. Morrison/Meliza (1999): AAR é mais eficaz quando feito próximo ao evento (<48h), quando inclui todos os participantes, e quando foca em ações futuras (não em culpa). Conceito contemporâneo de 'learning review' em product development (Thomke 2020, Experimentation Works): revisão estruturada de experimentos — o que a hipótese era, o que observamos, o que aprendemos, o que muda."
		meshManifestation: "Na Mesh, AARs se aplicam a: (1) pós-incidente (SEV-1/2) — o que já é coberto por post-mortem de OOI. (2) pós-experimento — testamos pricing com anchor tenant; o que aprendemos? Hipótese confirmada ou falsificada? O que muda no modelo? (3) pós-decisão significativa — depois de 3 meses operando como correspondente, a decisão se mostrou acertada? Por que sim/não? O que não antecipamos? (4) pós-interação com stakeholder — reunião com Bacen, pitch para investidor, demo para construtora. O que funcionou? O que ajustar? (5) pós-sessão de desenvolvimento intensa — sprint de arquitetura de 2 semanas. O que produzimos? O que aprendemos sobre o processo?"
		meshImplication: "Protocolo de AAR para eventos significativos: (1) Dentro de 48h do evento, documentar: objetivo original, resultado real, delta, fatores que explicam o delta, ações para próxima vez. (2) Formato: conciso — 1 página máximo. Não é relatório — é destilação de aprendizado. (3) Armazenamento: no mesh-spec se aprendizado afeta decisões futuras. Em tension-log se é tensão a ser processada. Em ADR se revisa decisão anterior. (4) Para agentes: AAR de sessão pode ser simplificado — 'esta sessão produziu [outputs]. Aprendizados que afetam sessões futuras: [lista]. Artefatos atualizados: [lista].' (5) Cadência mínima: AAR para todo incidente SEV-1/2, todo experimento com gate, toda decisão tipo 2+, toda interação com regulador. Para eventos menores: aggregar em retrospectiva mensal. Anti-pattern: AAR que gera 10 action items mas nenhum é implementado — aprendizado sem ação é exercício intelectual."
		dependsOn: ["km-double-loop-learning", "km-decision-records"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-incident-management"
			context:   "OOI define post-mortem para incidentes operacionais. KM generaliza o processo de aprendizado pós-evento para qualquer evento significativo — não apenas falhas. OOI cobre o 'aprender com o que deu errado'; KM cobre 'aprender com tudo que aconteceu'."
		}]
		rationale: "US Army 1993: AAR como disciplina de aprendizado. Thomke 2020: learning review de experimentos. Na Mesh, o valor de cada interação com mercado, regulador e stakeholders é multiplicado quando o aprendizado é capturado e preservado — e desperdiçado quando não é."
	},
	{
		id:         "km-knowledge-decay-refresh"
		name:       "Decaimento e Refresh de Conhecimento: Informação que Não é Revisada Degrada"
		nature:     "operational"
		role:       "property"
		reviewCadence: "quarterly"
		definition: "De Holan/Phillips (2004, 'Remembrance of Things Past? The Dynamics of Organizational Forgetting'): organizações esquecem — conhecimento que não é praticado, referenciado ou atualizado degrada ao longo do tempo. Esquecimento pode ser acidental (staff turnover, mudança de sistema) ou deliberado (descartar conhecimento obsoleto). Argote (1999, Organizational Learning): curvas de aprendizado e esquecimento — organizações que não reforçam conhecimento experimentam 'depreciation of knowledge'. Kransdorff (1998, Corporate Amnesia): organizações sistematicamente falham em preservar experiência e repetam erros. Conceito contemporâneo de 'knowledge freshness in AI systems' (2023+): em sistemas que usam RAG ou knowledge bases para LLMs, conhecimento desatualizado é pior que ausência — o agente confia em informação que não é mais verdadeira, e a confiança do agente não diminui com a idade do documento."
		meshManifestation: "Na Mesh, conhecimento decai em: (1) premissas de mercado — 'taxa média de factoring no setor é 3.5% a.m.' documentada há 6 meses. Ainda é verdade? Se mercado mudou e premissa não foi atualizada: scoring model ou pricing baseado em premissa obsoleta. (2) regulação — 'Bacen não exige reporte específico sobre IA' documentada há 4 meses. Regulação evolui; se resolução nova foi publicada e documentação não atualizou: compliance risk. (3) design decisions — ADR de 8 meses atrás: 'Amazon Ion para serialização'. O ecossistema evoluiu? Alternativas que eram piores agora são melhores? (4) lenses — conceito de lens referencia paper de 2019 como 'estado da arte'. Em 2026, o campo avançou? Lens está desatualizada? (5) CLAUDE.md — instrução 'priorizar validação de demanda sobre tudo' era correta pré-revenue. Pós-revenue, ainda é? Conhecimento desatualizado no mesh-spec é mais perigoso que knowledge gap — porque o agente age com confiança sobre informação errada."
		meshImplication: "Para cada artefato no mesh-spec: definir TTL (time-to-live) — prazo máximo sem revisão. Após TTL: artefato é flaggado como 'review needed'. TTLs por tipo: (1) premissas de mercado: 3 meses. (2) regulação: 3 meses (ou event-driven se nova resolução). (3) ADRs tipo 1-2: 6 meses. (4) ADRs tipo 3: 12 meses. (5) lenses: 12 meses. (6) CLAUDE.md: 1 mês. (7) design principles: 12 meses. Revisão não significa reescrever — significa verificar que informação ainda é válida. Se válida: atualizar timestamp de revisão. Se inválida: atualizar conteúdo ou deprecar. Para agentes: instrução no CLAUDE.md — 'se artefato tem review_date > TTL, flaggar como potencialmente obsoleto antes de usar como base para decisão'. Automação: CI job que verifica TTLs e gera relatório semanal de artefatos que precisam de revisão. Anti-pattern: mesh-spec com 200 artefatos onde 40% estão desatualizados — o repositório se torna não-confiável e agentes/humanos param de consultar."
		dependsOn: ["km-knowledge-as-code", "km-organizational-memory"]
		crossDependsOn: [{
			lensId:    "lens-credit-risk"
			conceptId: "cr-model-monitoring"
			context:   "CR monitora drift em modelos de scoring (AUROC, PSI). KM monitora decay em premissas que alimentam esses modelos e toda a operação. CR diz 'modelo está drifting'; KM pergunta 'as premissas que fundamentam o modelo foram revisadas?'. Data drift pode ser causado por knowledge decay — premissa de mercado desatualizada que o scoring continua usando."
		}]
		rationale: "De Holan/Phillips 2004: organizações esquecem. Kransdorff 1998: corporate amnesia. Na Mesh AI-native, conhecimento desatualizado no mesh-spec é amplificado pelo agente que opera com confiança — TTL e refresh são defesas contra degradação silenciosa."
	},
	{
		id:         "km-institutional-amnesia-prevention"
		name:       "Prevenção de Amnésia Institucional: Proteger Contra Perda Catastrófica de Conhecimento"
		nature:     "theoretical"
		role:       "property"
		definition: "Kransdorff (1998, Corporate Amnesia): organizações perdem conhecimento crítico quando pessoas saem, projetos terminam, ou sistemas são substituídos. A perda é frequentemente invisível até que uma decisão precise de conhecimento que não está mais acessível. DeLong (2004, Lost Knowledge): quatro categorias de risco de perda — conhecimento tácito de experts, redes de relacionamento, conhecimento embarcado em processos, e cultura organizacional. Conceito contemporâneo de 'bus factor' em engineering: se uma única pessoa fica indisponível e o projeto para, bus factor = 1. Em startup solo founder, bus factor = 1 por definição para todo conhecimento não-codificado."
		meshManifestation: "Na Mesh solo founder: bus factor = 1 para todo conhecimento tácito do founder. Cenários de perda: (1) founder fica doente por 2 semanas — agentes operam com base no mesh-spec, mas decisões tipo 2+ param. Se mesh-spec é robusto: operação tipo 3-4 continua. Se mesh-spec é pobre: tudo para. (2) founder contrata primeiro funcionário — o que sabe está codificado o suficiente para onboarding? Ou precisa de meses de shadowing? (3) founder pivota — conhecimento sobre direção anterior é preservado para entender por que pivotou? Ou é perdido e decisões futuras repetem erros? (4) agente de IA faz sessão rica onde explora alternativas, compara trade-offs, e conversa produz insights — mas sessão termina e nada é persistido. Amnésia de sessão."
		meshImplication: "Três estratégias de prevenção: (1) codificação contínua — fluxo constante de tácito para explícito via ADRs, lenses, design principles, CLAUDE.md. Meta: se founder ficar indisponível por 2 semanas, operação tipo 3-4 não é afetada e decisões tipo 2 podem ser adiadas com contexto suficiente para retomada. (2) redundância de acesso — mesh-spec em Git (distribuído por design), backups automatizados. Relações com stakeholders: documentar contatos-chave, histórico de interação, contexto de cada relação. Se founder ficar indisponível: substituto pode acessar contexto mínimo. (3) onboarding como teste de memória — quando primeiro membro da equipe for contratado, o tempo de onboarding é métrica de qualidade do mesh-spec. Se onboarding requer 3 meses de shadowing: mesh-spec é insuficiente. Se 2-4 semanas com leitura do mesh-spec + 2 semanas de shadowing: mesh-spec é funcional. Testar anualmente: 'se eu desaparecer amanhã, o mesh-spec permite que alguém entenda por que cada decisão arquitetural foi tomada?'"
		dependsOn: ["km-organizational-memory", "km-tacit-explicit-conversion", "km-knowledge-as-code"]
		crossDependsOn: [{
			lensId:    "lens-organizational-economics"
			conceptId: "oe-knowledge-assets"
			context:   "OE modela knowledge assets como componente da fronteira e vantagem competitiva da firma. KM operacionaliza a proteção desses assets contra perda. OE diz 'conhecimento proprietário é vantagem competitiva'; KM diz 'se bus factor = 1 e founder fica indisponível, vantagem competitiva evapora'. Prevenção de amnésia é proteção do ativo competitivo modelado por OE."
		}]
		rationale: "Kransdorff 1998: corporate amnesia. DeLong 2004: quatro categorias de perda. Na Mesh solo founder, bus factor = 1 é risco existencial. O mesh-spec é a mitigação — mas só funciona se for alimentado continuamente. A qualidade do mesh-spec é diretamente proporcional à resiliência da organização."
	},
	{
		id:         "km-collaborative-knowledge-creation"
		name:       "Criação Colaborativa de Conhecimento com IA: O Agente como Co-Autor"
		nature:     "theoretical"
		role:       "method"
		definition: "Conceito emergente (2023+): em organizações AI-native, LLMs não são apenas consumidores de conhecimento organizacional — são co-criadores. O agente que analisa decisão com lens, propõe alternativas, identifica gaps e red-teama premissas está gerando conhecimento novo que antes exigia múltiplos humanos. Mollick (2024, Co-Intelligence): a combinação humano+IA produz output superior ao de cada um isoladamente — o humano traz julgamento, contexto e intuição; a IA traz velocidade, amplitude de conhecimento e ausência de vieses emocionais. Wilson/Daugherty (2018, Human + Machine): três tipos de contribuição da IA — amplificar (humano faz melhor), interagir (IA faz interface), e incorporar (IA está no processo). Murray et al. (2023, 'Large Language Models as Simulated Economic Agents'): LLMs simulam raciocínio econômico com qualidade suficiente para gerar insights novos — não apenas recuperar conhecimento existente. Noy/Zhang (2023, 'Experimental Evidence on the Productivity Effects of Generative AI'): ganho de produtividade de 40% em tarefas de escrita profissional com LLMs, com maior ganho para workers menos experientes — IA democratiza competência."
		meshManifestation: "Na Mesh, o agente de IA é co-criador de: (1) lenses analíticas — founder define o escopo e valida, agente pesquisa frameworks, propõe conceitos, identifica gaps, red-teama. O output (lens completa com 10-15 conceitos, reasoning protocol, examples) não existiria sem a colaboração. (2) ADRs — founder descreve contexto e preferência, agente estrutura alternativas, analisa trade-offs, documenta. (3) design de mecanismos — agente explora espaço de incentivos e propõe designs que founder sozinho não teria pensado. (4) red team — agente ataca premissas do founder de forma que o founder não faria sozinho (combate echo chamber of one). O conhecimento criado pela interação humano+IA é qualitativamente diferente do que cada um criaria sozinho — não é nem 'conhecimento do founder' nem 'output da IA' mas conhecimento emergente da colaboração."
		meshImplication: "Projetar sessões com agentes para maximizar criação de conhecimento: (1) não tratar agente como executor — tratar como sparring partner. Apresentar dilema, não tarefa. 'Analise se devemos usar cessão definitiva ou coobrigação' gera mais conhecimento que 'escreva o contrato de cessão'. (2) instruir agente a questionar premissas do founder, não apenas confirmá-las. 'Red-teame esta decisão' é instrução produtiva. (3) capturar o output da co-criação: a lens, o ADR, o red team report é o artefato que persiste — a conversa é efêmera. (4) validar antes de incorporar: agente pode gerar insight plausível mas incorreto. Founder valida com julgamento e, para premissas de mercado, com evidência externa. (5) iterar: primeira versão da co-criação é draft; revisão humana + round adicional com agente produz versão significativamente melhor. Na Mesh, o mesh-spec é literalmente produto de co-criação humano+IA — reconhecer isso e otimizar o processo gera knowledge de qualidade superior."
		dependsOn: ["km-tacit-explicit-conversion", "km-context-preservation"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-hitl-calibration"
			context:   "AAG calibra intensidade de supervisão proporcional à maturidade. KM calibra intensidade de co-criação: para knowledge creation, supervisão não é overhead — é ingrediente. HITL em co-criação de conhecimento é mais intenso que HITL em execução de tarefa, porque o output requer julgamento humano para validação, não apenas verificação de erro."
		}]
		rationale: "Mollick 2024: co-intelligence produz output superior. Noy/Zhang 2023: ganho de 40% em produtividade. Murray et al. 2023: LLMs como simuladores de raciocínio econômico. Na Mesh, o mesh-spec é produto de co-criação — otimizar esse processo é otimizar o principal ativo de conhecimento da organização."
	},
	{
		id:         "km-deliberate-forgetting"
		name:       "Esquecimento Deliberado: Descartar Conhecimento Obsoleto para Reduzir Ruído"
		nature:     "operational"
		role:       "heuristic"
		reviewCadence: "semi-annual"
		definition: "De Holan/Phillips (2004): organizações precisam não apenas adquirir e reter conhecimento mas também descartar — esquecimento deliberado. Conhecimento obsoleto que permanece no repositório gera ruído: agentes que buscam informação encontram artefatos contraditórios (decisão antiga vs decisão nova), conceitos que não se aplicam mais ao contexto atual, e premissas invalidadas que confundem em vez de informar. Hedberg (1981, 'How Organizations Learn and Unlearn'): unlearning é precondição de relearning — a organização que não descarta o modelo mental antigo não consegue adotar o novo. Martin de Holan/Phillips (2011): esquecimento organizacional pode ser gerenciado — não é apenas perda acidental, mas curadoria ativa do que manter e o que descartar. Conceito contemporâneo de 'knowledge base hygiene' (2023+): em sistemas RAG, documentos obsoletos não removidos contaminam retrieval — agente recupera informação desatualizada com a mesma probabilidade que informação atual, porque o retrieval não distingue por freshness a menos que configurado para isso."
		meshManifestation: "Na Mesh, conhecimento a ser deliberadamente descartado ou deprecado: (1) ADRs superseded — decisão original substituída por nova. ADR antigo não deve ser deletado (histórico) mas deve ser marcado 'superseded by [novo ADR]' e excluído de retrieval ativo. (2) premissas invalidadas — 'mercado opera com cessão definitiva' foi invalidado quando gestores FIDC revelaram coobrigação. Premissa antiga deve ser deprecada com timestamp e razão. (3) lenses obsoletas — se lens foi superseded por versão com conceitos significativamente diferentes, a versão antiga deve ser archived, não coexistir. (4) instruções do CLAUDE.md que não se aplicam mais — 'priorizar validação de demanda sobre tudo' não faz sentido pós-validação. Manter gera confusão. (5) schemas CUE de versões anteriores que não são mais usados. Cada artefato obsoleto no mesh-spec é custo: ocupa espaço cognitivo, aparece em retrieval, e pode ser usado por agente como base para decisão incorreta."
		meshImplication: "Revisão semi-anual de esquecimento deliberado: para cada artefato no mesh-spec, perguntar — (1) ainda é verdadeiro e atual? Se não: deprecar com razão e data. (2) ainda é útil para decisões futuras? Se não: archiver (mover para /archive, fora do retrieval ativo). (3) é contraditório com artefato mais recente? Se sim: um dos dois deve ser deprecado — identificar qual e por quê. Para agentes: artefatos com status 'deprecated' ou 'superseded' devem ser excluídos de retrieval ativo. Se agente referencia artefato deprecated: flag automático. Métricas de hygiene: ratio artefatos ativos / artefatos totais. Se <60%: mesh-spec está acumulando lixo — limpar. Se >95%: possivelmente não está deprecando o suficiente — tudo não pode ser atual. Distinção: deletar vs deprecar vs archiver. Deletar: nunca (perda de histórico). Deprecar: marcar como não-vigente, manter acessível para histórico. Archiver: mover para fora do retrieval ativo, acessível apenas por consulta explícita."
		dependsOn: ["km-knowledge-decay-refresh", "km-knowledge-as-code"]
		rationale: "De Holan/Phillips 2004: esquecimento deliberado é tão importante quanto aquisição. Hedberg 1981: unlearning precede relearning. Na Mesh, mesh-spec que acumula artefatos obsoletos sem curadoria se torna não-confiável — agente não sabe o que é vigente. Curadoria ativa é o que mantém o repositório vivo e confiável."
	},
	{
		id:            "km-learning-review"
		name:          "Revisão de Aprendizagem: Inventário Periódico de Conhecimento e Gaps"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) gaps de memória — áreas onde conhecimento crítico está apenas na cabeça do founder, (2) externalização — quanto tácito foi codificado no período, (3) ADRs — decisões documentadas vs decisões tomadas sem registro, (4) mesh-spec health — artefatos com TTL expirado, artefatos referenciados vs não-referenciados, artefatos deprecados vs ativos (hygiene ratio), (5) cognitive load — CLAUDE.md está crescendo demais? Lenses estão fragmentadas? (6) RAG/retrieval — agentes estão encontrando a informação que precisam?, (7) AARs — eventos significativos tiveram AAR?, (8) double-loop — premissas foram revisadas? Alguma invalidada?, (9) amnésia — bus factor mudou? Onboarding seria possível com artefatos atuais?, (10) co-criação — sessões de co-criação com agente produziram artefatos persistentes? Qualidade validada?, (11) esquecimento deliberado — artefatos obsoletos foram deprecados/archived? Hygiene ratio está saudável?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (TTLs expirados, ADRs pendentes, AARs não-feitos). Trimestral: macro-revisão com inventário completo."
		meshImplication: "Mensal (1h): artefatos com TTL expirado — atualizar ou deprecar. ADRs pendentes — decisões tipo 2+ tomadas sem ADR? Documentar retroativamente. AARs — eventos significativos sem AAR? Fazer agora (melhor tarde que nunca). Sessões de Claude Code que produziram decisões sem persistir — recuperar e documentar. Co-criação — sessões recentes geraram artefatos de qualidade? Agente está sendo usado como sparring partner ou apenas executor? Trimestral (2h): gaps de memória — nova área (ex: FIDC, novo segmento) tem conhecimento codificado ou é apenas tácito? Mesh-spec health — quantos artefatos existem, quantos têm TTL expirado, quantos são referenciados pelo CLAUDE.md? Se >30% expirado: priorizar refresh. Hygiene ratio — quantos artefatos são 'deprecated' ou 'superseded'? Se acumulando: semi-annual cleanup. Cognitive load — CLAUDE.md excede tamanho razoável? Progressive disclosure funciona? Double-loop — lista de premissas revisada? Alguma premissa invalidada por evidência? Bus factor — se founder saísse amanhã, o que aconteceria? Melhorou desde último trimestre? Esquecimento deliberado — artefatos obsoletos foram archived? Retrieval está contaminado com conteúdo desatualizado? Se revisão não identifica pelo menos um gap ou uma atualização necessária: ou conhecimento é perfeito (improvável) ou revisão é superficial."
		dependsOn: ["km-organizational-memory", "km-knowledge-decay-refresh", "km-double-loop-learning", "km-after-action-review", "km-institutional-amnesia-prevention", "km-context-preservation", "km-collaborative-knowledge-creation", "km-deliberate-forgetting"]
		rationale: "Sem revisão periódica, gestão de conhecimento é aspiração, não prática. O inventário periódico fecha o loop entre criação de conhecimento e manutenção."
	},
]

reasoningProtocol: [
	{
		question:  "Onde está o conhecimento necessário para esta decisão? Em artefato acessível ou apenas na cabeça de alguém?"
		reveals:   "Se o conhecimento necessário é explícito e acessível — ou se depende de memória humana (SPOF de conhecimento)."
		rationale: "Walsh/Ungson 1991: memória organizacional em cinco repositórios. Se conhecimento está apenas no founder: vulnerável e inacessível para agentes."
	},
	{
		question:  "Esta decisão está documentada como ADR com contexto, alternativas descartadas e rationale? Se não: por quê?"
		reveals:   "Se decisões significativas estão sendo preservadas para consulta futura — ou se serão re-litigadas em 6 meses."
		rationale: "Nygard 2011: ADRs previnem re-litigação. Pratt 2019: decisão como unidade de trabalho documentável."
	},
	{
		question:  "Existe conhecimento tácito relevante que poderia ser externalizado? Consigo articular por que tomo esta decisão desta forma?"
		reveals:   "Se há oportunidade de converter intuição em artefato — expandindo o que agentes e futuros membros podem acessar."
		rationale: "Nonaka/Takeuchi 1995: externalização é o modo de conversão mais valioso. Collins 2010: nem tudo é explicitável — mas tentar já ajuda."
	},
	{
		question:  "O artefato que estou consultando está atualizado? Quando foi a última revisão? O TTL expirou?"
		reveals:   "Se a informação é confiável ou potencialmente obsoleta. Conhecimento desatualizado usado com confiança é pior que lacuna."
		rationale: "De Holan/Phillips 2004: organizações esquecem. Na Mesh, mesh-spec desatualizado é amplificado pelo agente que opera com confiança."
	},
	{
		question:  "A carga cognitiva do artefato/documento é apropriada? Informação está em camadas (summary → detail → rationale) ou é bloco monolítico?"
		reveals:   "Se o formato facilita ou dificulta o uso. Carga estranha alta = tokens desperdiçados (agente) e tempo desperdiçado (humano)."
		rationale: "Sweller 1988: reduzir carga estranha libera capacidade. Skelton/Pais 2019: carga cognitiva organizacional tem limite."
	},
	{
		question:  "O agente consegue encontrar a informação que precisa no mesh-spec? O retrieval está funcionando?"
		reveals:   "Se a infraestrutura de acesso ao conhecimento está adequada — ou se o agente alucina por não encontrar a resposta."
		rationale: "Barnett et al. 2024: sete failure points de RAG. Missing content e wrong format são os mais comuns e perigosos."
	},
	{
		question:  "Esta sessão produziu decisão ou aprendizado que afeta sessões futuras? Está documentado em artefato persistente?"
		reveals:   "Se o valor da sessão será preservado — ou se será perdido quando a sessão terminar (amnésia de sessão)."
		rationale: "Shanahan 2024: LLMs não têm experiência persistente. Sessão sem artefato = valor efêmero."
	},
	{
		question:  "Estamos fazendo single-loop (corrigir erro no framework) ou double-loop (questionar o framework)? Deveríamos estar fazendo double-loop?"
		reveals:   "Se a organização está otimizando dentro de premissas não-questionadas — ou se está questionando premissas quando deveria."
		appliesWhen: "resultado inesperado ou performance consistentemente abaixo do esperado"
		rationale: "Argyris/Schön 1978: single-loop corrige; double-loop transforma. Premissa não-questionada é maior risco que execução imperfeita."
	},
	{
		question:  "Este evento significativo teve AAR? O que deveria ter acontecido, o que aconteceu, por que a diferença, o que fazer diferente?"
		reveals:   "Se a organização está capturando aprendizado de eventos ou se eventos são consumidos e esquecidos."
		appliesWhen: "após incidente, experimento, decisão importante, ou interação significativa com stakeholder"
		rationale: "US Army 1993: AAR dentro de 48h. Thomke 2020: learning review de experimentos. Aprendizado não-capturado é aprendizado perdido."
	},
	{
		question:  "Se o founder ficasse indisponível por 2 semanas: o mesh-spec permite que agentes e eventuais substitutos operem? O que pararia?"
		reveals:   "O bus factor real da organização — e quais gaps de codificação são mais urgentes."
		rationale: "Kransdorff 1998: corporate amnesia. DeLong 2004: lost knowledge. Na Mesh solo founder, esta pergunta revela o estado real da memória organizacional."
	},
	{
		question:  "Esta sessão com agente está sendo usada para co-criar conhecimento (sparring, red-team, análise de alternativas) ou apenas para executar tarefa? Poderia gerar mais valor como co-criação?"
		reveals:   "Se o potencial de co-criação humano+IA está sendo aproveitado — ou se o agente está sendo subutilizado como executor quando poderia ser sparring partner."
		rationale: "Mollick 2024: co-intelligence. Noy/Zhang 2023: ganho de produtividade. Sessão de co-criação gera conhecimento novo; sessão de execução gera output pontual."
	},
	{
		question:  "O mesh-spec tem artefatos obsoletos, deprecados ou superseded que estão contaminando retrieval ou gerando confusão? Hygiene ratio está saudável?"
		reveals:   "Se o repositório de conhecimento é curado ativamente ou se está acumulando ruído que degrada confiabilidade."
		rationale: "De Holan/Phillips 2004: esquecimento deliberado. Hedberg 1981: unlearning precede relearning. Mesh-spec com 40% de artefatos obsoletos é mesh-spec não-confiável."
	},
]

meshExamples: [
	{
		id:       "ex-adr-serialization-choice"
		scenario: "Mesh precisa escolher formato de serialização para payloads entre bounded contexts. Alternativas: JSON, Protobuf, Amazon Ion, Avro. Founder escolheu Amazon Ion após análise de 2 semanas."
		analysis: "Decisão tipo 2 (arquitetural, afeta múltiplos BCs). Sem ADR: em 6 meses, quando agente precisa integrar novo BC e questiona 'por que Ion e não Protobuf?', a resposta é 'porque sim' — re-litigação. Com ADR: agente lê contexto (necessidade de tipos ricos + legibilidade humana + binary/text dual format), alternativas descartadas (JSON: sem tipos fortes; Protobuf: não human-readable, toolchain pesada; Avro: schema evolution bom mas ecossistema menor), e rationale (Ion combina tipos ricos com legibilidade, dual format permite debug humano e performance em produção)."
		recommendation: "Criar ADR: dec-2025-06-001. Contexto: necessidade de serialização entre BCs com tipos ricos e legibilidade. Decisão: Amazon Ion. Alternativas descartadas com rationale para cada. Consequências: dependência do ecossistema Ion (menor que JSON/Protobuf), necessidade de libraries Ion em Kotlin e Python. PrincipleIds: ax-01 (problema real: interop entre BCs), ax-04 (modularidade com contrato explícito). Status: accepted. Revisão: 12 meses ou se novo BC revelar limitação do Ion. Para agentes: ao propor mudança de serialização, obrigatório ler este ADR primeiro e articular por que condições mudaram desde a decisão."
		principlesApplied: ["ax-01", "ax-04", "ax-06"]
		assumptions: [
			"Amazon Ion tem libraries maduras em Kotlin e Python — verificar",
			"dual format (text/binary) é vantagem real vs apenas JSON para debug — validar com uso real",
			"ecossistema Ion é suficiente para necessidades da Mesh a médio prazo — revisitar em 12 meses",
		]
		rationale: "Nygard 2011: ADRs como first-class artifacts. Decisão arquitetural sem ADR é decisão que será re-litigada. O custo do ADR (30min) << custo da re-litigação (horas/dias de análise repetida)."
	},
	{
		id:       "ex-tacit-externalization-regulatory"
		scenario: "Founder teve 3 conversas informais com profissionais do mercado regulatório. Aprendeu que Bacen valoriza organizações que demonstram 'maturidade operacional' antes de solicitar licenças, e que submissões com evidência de governance robusta são processadas mais favoravelmente. Nada disso está documentado."
		analysis: "Conhecimento tácito valioso — afeta estratégia regulatória, comunicação com regulador, e sequenciamento de licenciamento. Reside exclusivamente na memória do founder. Se founder não externaliza: agente que prepara documentação regulatória não incorpora esses insights. Decisões futuras sobre timing de SCD não consideram esse contexto. É SPOF de conhecimento: 3 conversas cujo valor se perde se founder esquecer ou ficar indisponível."
		recommendation: "Externalizar em três artefatos: (1) atualizar lens-regulatory-strategy — adicionar conceito ou enriquecer existente com insight sobre 'maturidade operacional como precondição percebida pelo regulador'. MeshManifestation: 'conversas com mercado indicam que Bacen processa favoravelmente submissões de organizações que já demonstram governance — audit trail, compliance, supervisão de IA'. MeshImplication: 'demonstrar maturidade operacional antes de solicitar SCD, não apenas no momento da solicitação'. (2) atualizar sc-regulatory-communication — adicionar nota sobre 'maturidade percebida' como componente de comunicação regulatória. (3) criar nota no tension-log: 'premissa \"governance robusta acelera licenciamento\" baseada em conversas informais — não em evidência formal. Verificar com assessoria jurídica e outros players do mercado.' Cada externalização: 15-30min. Valor: permanente e acessível a todos os agentes futuros."
		principlesApplied: ["ax-07", "ax-03"]
		assumptions: [
			"insights de conversas informais são representativos — podem ser viés de amostra pequena",
			"Bacen realmente processa favoravelmente — verificar com mais fontes",
			"externalizar como conceito de lens é nível de formalização adequado — pode ser nota simples em ADR",
		]
		rationale: "Nonaka/Takeuchi 1995: externalização é o modo SECI mais valioso para a Mesh. Collins 2010: parte do tácito é explicitável se o esforço for feito. 30min de documentação transforma insight efêmero em ativo permanente."
	},
	{
		id:       "ex-double-loop-vertical"
		scenario: "Mesh opera há 8 meses em construção civil. Tração existe mas cresce mais devagar que esperado: 4 anchor tenants em vez dos 10 projetados. Founder questiona: é problema de execução (single-loop) ou de premissa (double-loop)?"
		analysis: "Single-loop analysis: 'estamos executando mal — melhorar pitch, melhorar onboarding, melhorar pricing.' Double-loop analysis: 'a premissa \"construção civil é o melhor vertical inicial\" pode estar errada — por quê?' Evidência para revisar premissa: (1) ciclo de venda de construtoras é mais longo que esperado (3-4 meses vs 1-2 projetados). (2) decisores em construtoras são conservadores — adoção de fintech nova é barreira cultural, não apenas funcional. (3) infraestrutura (outro segmento) mostrou interesse orgânico não-solicitado — 2 empresas de infraestrutura pediram demo sem prospecção. (4) volume por anchor em construção é menor que projetado (R$200k/mês vs R$500k projetados). Premissa original: 'construção civil combina dor forte + volume alto + mercado acessível'. Double-loop: dor é forte sim, mas mercado é menos acessível que projetado (ciclo longo, conservadorismo), e volume por cliente é menor."
		recommendation: "Não pivotar imediatamente — mas ativar double-loop formal: (1) documentar premissas originais da escolha de vertical (ADR se não existe). (2) para cada premissa, comparar expectativa vs realidade em 8 meses. (3) articular claramente por que tração é 4 em vez de 10: é execução (solvável com mais tempo/recurso) ou estrutural (solvável apenas mudando vertical ou abordagem)? (4) se estrutural: quanto de exploration alocar a infraestrutura como vertical alternativo? (conecta com ora-allocation-regime). (5) gate de decisão: em 3 meses, com dados de infraestrutura piloto, revisitar premissa com evidência dos dois verticais. (6) preservar aprendizado: mesmo que pivote, documentar tudo que aprendeu sobre construção civil — é conhecimento valioso que evita repetir erros no novo vertical. (7) sunk cost immunity: os 8 meses em construção civil são irrelevantes — só importa valor prospectivo de cada vertical (conecta com ora-sunk-cost-immunity)."
		principlesApplied: ["ax-01", "ax-05", "ax-06"]
		assumptions: [
			"4 anchors em 8 meses é underperformance real — pode ser normal para o estágio e deve ser benchmarkado",
			"interesse orgânico de infraestrutura é sinal válido — pode ser ruído de 2 contatos",
			"3 meses é tempo suficiente para pilotar infraestrutura — pode precisar de mais",
			"construção civil e infraestrutura são suficientemente similares para reaproveitar stack — verificar",
		]
		rationale: "Argyris/Schön 1978: double-loop questiona a premissa, não a execução. Schoemaker/Gunther McGrath 2023: aprender com o que funciona e o que não funciona. 4 vs 10 anchor tenants pode ser single-loop (execução) ou double-loop (premissa). A disciplina é distinguir — e documentar o aprendizado independente do resultado."
	},
	{
		id:       "ex-context-preservation-session"
		scenario: "Sessão de 3h com Claude Code para explorar arquitetura do bounded context de NPM (Network Performance Monitoring). Sessão produziu: modelo de domínio com 5 aggregates, decisão de separar NPM de NTI, mapeamento de 8 domain events, e descoberta de que NPM precisa de dados de SCT (Supply Chain Theory) que não estão na arquitetura atual."
		analysis: "Sessão extremamente produtiva — mas todo o output está no chat. Se sessão termina sem artefatos: (1) próxima sessão de Claude Code não sabe o que foi decidido — começa do zero ou, pior, toma decisões diferentes sobre os mesmos temas. (2) founder esquece detalhes em 1-2 semanas — nuances de trade-offs entre alternativas se perdem. (3) dependência descoberta (NPM → SCT) não é trackada e vira gap invisível. Valor da sessão: ~3h de trabalho denso. Valor preservado sem artefatos: ~0 (tudo volátil). Custo de re-derivar: provavelmente 2-4h (parte do raciocínio é irrecuperável)."
		recommendation: "Antes de encerrar sessão, produzir: (1) ADR: 'separação NPM/NTI' — contexto, decisão, alternativas consideradas (merge num único BC vs separação), consequências. 5min. (2) Domain model artifact: 5 aggregates com descrição, commands, events. Persistir no mesh-spec como artefato de domínio. 10min. (3) Dependência NPM→SCT: registrar no tension-log como tensão arquitetural a resolver. 2min. (4) Event catalog: 8 domain events com producer/consumer. Persistir como artefato. 5min. (5) Session summary no CLAUDE.md ou em nota dedicada: 'sessão de [data] explorou NPM. Decisões: X, Y, Z. Pendências: A, B.' 3min. Total: ~25min adicionais. ROI: 3h de trabalho preservado vs 3h perdido. Regra: toda sessão >1h que produz decisões ou insights deve terminar com 15-30min de preservação. Se o tempo parece muito: é porque o valor da sessão foi alto — e perder valor alto é mais caro que preservar."
		principlesApplied: ["ax-07", "ax-06"]
		assumptions: [
			"founder consegue manter disciplina de 25min de documentação ao final de sessão intensa — pode haver fadiga",
			"formato de session summary é suficientemente padronizado para ser útil",
			"agente de Claude Code pode ajudar a gerar artefatos durante a sessão — não precisa ser pós-sessão",
			"mesh-spec tem estrutura para receber esses artefatos sem reorganização",
		]
		rationale: "Shanahan 2024: LLMs não têm experiência persistente. Park et al. 2023: reflexão transforma observação em conhecimento. 25min de preservação para 3h de trabalho é 14% de overhead para 100% de retenção. Sem preservação: 0% de retenção."
	},
	{
		id:       "ex-knowledge-decay-scoring-premise"
		scenario: "Lens de credit-risk inclui premissa: 'taxa de inadimplência no setor de construção civil para antecipação de recebíveis é ~4-6% a.a.' Premissa documentada há 9 meses com base em relatório da ABRAMAT 2024. Nenhuma revisão desde então."
		analysis: "TTL recomendado para premissas de mercado: 3 meses. Premissa está 6 meses vencida. Possíveis mudanças: (1) cenário macroeconômico mudou (Selic subiu/desceu, construção acelerou/desacelerou). (2) relatório ABRAMAT 2025 pode ter dados atualizados. (3) dados reais da Mesh (se operando) podem divergir do benchmark do setor. Risco de premissa desatualizada: se inadimplência real é 8% e não 5%, o pricing da Mesh está sub-precificando risco — cada operação gera perda esperada não-contabilizada. Se inadimplência real é 2%, Mesh está sobre-precificando — cobrando mais que necessário e perdendo competitividade."
		recommendation: "(1) Imediato: flag a premissa como 'review overdue'. (2) Buscar: relatório ABRAMAT 2025 ou fontes equivalentes (Bacen, CBIC, operadores de FIDC de construção). (3) Comparar: se Mesh já tem dados operacionais — calcular inadimplência realizada e comparar com benchmark. Se diverge >50%: premissa precisa de atualização material, não cosmética. (4) Atualizar: premissa no mesh-spec com nova fonte, nova data, e timestamp de revisão. (5) Propagar: se premissa mudou materialmente — verificar quais conceitos de quais lenses dependem dessa premissa. Scoring model que usa 5% como prior precisa de recalibração? Pricing que assume 5% precisa de ajuste? (6) Automatizar: adicionar premissa à lista de TTL tracking com alerta automático em 3 meses."
		principlesApplied: ["ax-05", "ax-07"]
		assumptions: [
			"taxa de inadimplência do setor é dado público obtível — pode ter lag de publicação",
			"dados da ABRAMAT são fonte confiável — verificar se há fontes mais granulares",
			"premissa desatualizada afeta pricing e scoring materialmente — depende de quão sensível o modelo é a esse input",
			"3 meses é cadência de refresh adequada para dados macro de setor — pode ser mais frequente em período de volatilidade",
		]
		rationale: "De Holan/Phillips 2004: organizações esquecem. Na Mesh, premissa de inadimplência alimenta scoring e pricing — se está errada, todo o modelo financeiro está calibrado incorretamente. TTL com refresh forçado é a defesa contra degradação silenciosa de premissas críticas."
	},
	{
		id:       "ex-deliberate-forgetting-mesh-spec"
		scenario: "Mesh-spec tem 18 meses de acúmulo. Inventário revela: 47 artefatos totais (12 lenses, 8 ADRs, 15 conceitos de domínio, 7 schemas, 5 documentos auxiliares). Desses, 3 ADRs foram superseded por decisões posteriores, 2 conceitos de domínio referem-se a arquitetura abandonada (modelo de cessão definitiva), 1 lens (draft nunca finalizado) está incompleta, e 4 documentos auxiliares não são referenciados por nenhum outro artefato. Agente de Claude Code em sessão recente citou premissa de ADR superseded como base para recomendação — gerando recomendação inconsistente com decisão vigente."
		analysis: "Mesh-spec com hygiene ratio de ~79% (37 ativos / 47 totais). Os 10 artefatos obsoletos estão contaminando retrieval: agente recuperou ADR superseded porque estava no repositório com mesmo peso que ADR vigente. Dois conceitos de cessão definitiva são vestígios de arquitetura abandonada — se agente os lê, pode inferir que cessão definitiva ainda é considerada. Lens draft incompleta cria ambiguidade — agente não sabe se está vigente ou abandonada. Custo de manter: confusão + recomendações incorretas + tempo do founder corrigindo agente. Custo de limpar: ~2h de revisão e tagging."
		recommendation: "(1) ADRs superseded: adicionar campo 'status: superseded' e 'supersededBy: [id do ADR novo]'. Mover para /archive/decisions/. Configurar retrieval para excluir /archive/ de busca ativa. (2) Conceitos de cessão definitiva: deprecar com nota: 'conceito elaborado para modelo de cessão definitiva, abandonado em [data] quando mercado revelou operação por coobrigação — ver ADR dec-XXXX-XX-XXX'. Mover para /archive/domain/. (3) Lens draft incompleta: se é resgatável (>70% completo), finalizar ou deprecar. Se <70%: deprecar com nota 'draft não-finalizado, conceitos parciais podem ser reutilizados em [lens X]'. (4) Documentos não-referenciados: para cada um, perguntar — algum artefato deveria referenciá-lo? Se sim: adicionar referência. Se não: o documento é órfão — archiver. (5) CI check: adicionar job que detecta artefatos não-referenciados por >6 meses e artefatos com status deprecated/superseded que ainda estão no diretório ativo. (6) Regra para agentes: instrução no CLAUDE.md — 'artefatos em /archive/ são histórico, não vigente. Não usar como base para recomendação. Se encontrar contradição entre artefato ativo e archived, prevalecer o ativo.'"
		principlesApplied: ["ax-01", "ax-02", "ax-07"]
		assumptions: [
			"~2h é tempo suficiente para tagger e archiver 10 artefatos — pode ser mais se cada requer análise de dependências",
			"agentes respeitarão instrução de excluir /archive/ de retrieval ativo — precisa de teste",
			"79% hygiene ratio é aceitável — target deveria ser >90% para repositório confiável",
			"documentos não-referenciados são genuinamente órfãos — verificar se algum é consultado diretamente por founder sem referência formal",
		]
		rationale: "De Holan/Phillips 2004: esquecimento deliberado. Martin de Holan/Phillips 2011: curadoria ativa do que manter. Agente que cita ADR superseded é evidência concreta de que lixo acumulado contamina decisões. 2h de cleanup previne recorrência indefinida de recomendações baseadas em conhecimento obsoleto."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-05", "ax-06", "ax-07", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG codifica policies de agentes (governance as code). KM codifica todo o conhecimento organizacional (knowledge as code). O mesh-spec é o repositório compartilhado. AAG governa o que o agente pode fazer; KM garante que o agente tem o conhecimento necessário para decidir. Observability contract de AAG gera dados; KM transforma dados em conhecimento via AARs e reflexão. AAG (aag-governance-as-code) e KM (km-knowledge-as-code) usam o mesmo princípio (versionável, testável, auditável) em escopos complementares."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA aloca recursos, incluindo tempo para documentação e aprendizado. KM justifica a alocação: cada hora investida em codificar conhecimento economiza horas futuras de re-derivação. ORA diz 'quanto tempo alocar a documentação?'; KM diz 'o custo de não documentar é re-litigação em 6 meses + agentes sem contexto + bus factor = 1'. ora-attention-as-resource conecta com km-cognitive-load-management: ambas tratam atenção como recurso escasso. ORA (ora-satisficing) governa profundidade da documentação — ADR de 1 página satisfice > nenhum ADR."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI gera dados operacionais (logs, métricas, incidentes). KM transforma esses dados em conhecimento preservado (post-mortems como ADRs, patterns de incidentes como conceitos de lens, feedback loops como premissas documentadas). OOI detecta; KM preserva. OOI post-mortem é subset de KM AAR. OOI (ooi-operational-debt) e KM (km-knowledge-decay-refresh) são faces da mesma moeda — dívida operacional e dívida de conhecimento degradam o sistema silenciosamente."
	},
	{
		lensId:   "lens-real-options"
		relation: "complementsWith"
		context:  "RO modela experimentação com gates de falsificação. KM modela como o aprendizado de cada experimento é preservado e acessível para decisões futuras. RO diz 'experimente com gate'; KM diz 'o que aprendemos com o experimento e como preservar para não repetir'. Sem KM, cada gate de RO é re-derivado do zero. KM (km-double-loop-learning) é o mecanismo que questiona as premissas que fundamentam os gates de RO."
	},
	{
		lensId:   "lens-credit-risk"
		relation: "complementsWith"
		context:  "CR depende de premissas de mercado (taxa de inadimplência, perfil de risco do segmento) que KM gerencia via TTL e refresh. Se premissa de inadimplência está obsoleta (km-knowledge-decay-refresh), o modelo de CR está calibrado incorretamente. CR (cr-model-monitoring) detecta drift no modelo; KM pergunta se o drift origina-se de premissa desatualizada que alimenta o modelo. CR é a qualidade do modelo; KM é a qualidade das premissas que fundamentam o modelo."
	},
	{
		lensId:   "lens-stakeholder-communication"
		relation: "complementsWith"
		context:  "SC modela como comunicar com stakeholders. KM preserva o que foi comunicado, o que foi aprendido em cada interação, e o histórico de relação com cada stakeholder. Regulatory communication de SC depende de KM — histórico de interações com Bacen documentado previne contradição e constrói consistência. SC comunica; KM preserva. SC (sc-narrative-economics) requer narrativa coerente ao longo do tempo — KM garante que a narrativa documentada evolui mas não se contradiz."
	},
	{
		lensId:   "lens-behavioral-economics"
		relation: "complementsWith"
		context:  "BE diagnostica vieses cognitivos. KM os mitiga via estrutura: ADRs previnem sunk cost bias (rationale prospectivo documentado), double-loop previne confirmation bias (questionar premissas), TTL previne anchoring em informação desatualizada, deliberate forgetting previne status quo bias (manter artefato obsoleto por inércia). BE diz 'por que erramos'; KM diz 'como estruturar conhecimento para errar menos'."
	},
	{
		lensId:   "lens-information-economics"
		relation: "feedsInto"
		context:  "KM cria e organiza informação que IE modela como ativo econômico. O mesh-spec é ativo informacional da Mesh — tem custo de produção, valor de uso, e custo de perda. IE diz 'informação tem valor'; KM diz 'como produzir, preservar e tornar acessível'. Knowledge decay de KM é depreciação do ativo informacional de IE. Deliberate forgetting de KM é amortização planejada de ativo obsoleto."
	},
	{
		lensId:   "lens-complex-adaptive-systems"
		relation: "complementsWith"
		context:  "CAS modela como sistemas complexos aprendem e se adaptam. KM operacionaliza o aprendizado organizacional como prática — captura, preservação, retrieval, refresh, esquecimento deliberado. CAS diz 'organizações são sistemas adaptativos que aprendem'; KM diz 'como projetar o mecanismo de aprendizado para que funcione consistentemente'. Double-loop de KM é o mecanismo que permite à organização adaptar-se (CAS) em vez de apenas reagir."
	},
]

limitations: [
	{
		description: "Codificação de conhecimento consome o constraint (horas do founder). Se excesso de tempo é gasto documentando em vez de executando, a organização documenta mas não produz."
		alternative: "Satisficing para documentação: ADR de 1 página > ADR de 10 páginas. Documentação parcial > documentação perfeita. Priorizar codificação dos SPOFs de conhecimento mais críticos (decisões irreversíveis, premissas de mercado, relações regulatórias). Para decisões tipo 3-4: documentação mínima (log + decisão + rationale em 1 parágrafo). Para tipo 1-2: ADR completo."
		rationale: "ORA (satisficing): documentação perfeita que consome todo o constraint é pior que documentação suficiente que libera constraint para execução."
	},
	{
		description: "Nem todo conhecimento tácito é explicitável. Intuição do founder sobre quem confiar, timing de mercado, ou calibração de risco envolve pattern recognition que resiste à articulação."
		alternative: "Para conhecimento genuinamente tácito: (1) manter nível de autonomia baixo para agentes em decisões que dependem desse conhecimento. (2) documentar ao menos o output da intuição ('desconfio de X por razões que não consigo articular completamente — tratar como flag'). (3) quando contratar: priorizar socialização (Nonaka) para transmissão de tácito."
		rationale: "Polanyi 1966: 'we can know more than we can tell'. Collins 2010: parte do tácito é estruturalmente não-articulável. Aceitar o limite e mitigar."
	},
	{
		description: "Mesh-spec pode crescer a ponto de se tornar ingerível — muitos artefatos, muitas lenses, muitos ADRs. Carga cognitiva de navegar o repositório excede benefício."
		alternative: "Governance do mesh-spec: (1) lens-map como índice navegável — atualizar sempre. (2) deprecar agressivamente — artefatos não-referenciados há 6 meses são candidatos. (3) progressive disclosure — summary layers para cada seção. (4) meta-artefato: 'guia de navegação do mesh-spec' para humanos e agentes."
		rationale: "Sweller 1988: carga estranha. Mesh-spec que cresceu além da capacidade de navegação é mesh-spec que não é consultado — e conhecimento não-consultado é conhecimento inexistente."
	},
	{
		description: "RAG e retrieval para agentes LLM são tecnologia em evolução rápida. A infraestrutura de acesso ao conhecimento que é ótima hoje pode ser obsoleta em 12 meses."
		alternative: "Investir em conteúdo (knowledge as code com boa estrutura) mais do que em infraestrutura de retrieval. Conteúdo bem-estruturado funciona com qualquer mecanismo de retrieval; infraestrutura sem conteúdo é inútil. Quando tecnologia de RAG avançar: migrar mecanismo, manter conteúdo."
		rationale: "Gao et al. 2024: RAG evolui rapidamente. O mesh-spec é o ativo duradouro; o mecanismo de acesso é commodity substituível."
	},
	{
		description: "Double-loop learning requer psychological safety para questionar premissas. Em solo founder, o risco é 'echo chamber of one' — founder confirma próprias premissas sem questionamento externo."
		alternative: "Usar agentes IA como sparring partners para double-loop — instruir agente a 'red-team' premissas do founder. Buscar mentores ou advisors que questionem premissas regularmente. Usar pre-mortems (Klein 1998) como mecanismo estruturado de questionamento prospectivo."
		rationale: "Edmondson 2019: safety para questionar. Solo founder não tem equipe para questionar — precisa de mecanismos substitutos (agente como red-team, advisor externo, pre-mortem disciplinado)."
	},
	{
		description: "Co-criação com LLM pode gerar artefatos plausíveis mas incorretos (hallucination, raciocínio aparentemente válido mas com premissa errada). Agente co-cria com confiança independente de correção."
		alternative: "Todo output de co-criação passa por validação humana antes de incorporar ao mesh-spec. Para premissas de mercado e regulação: validar com fonte externa (não apenas com raciocínio do agente). Para decisões tipo 1-2: co-criação como draft, não como output final. Red-team do output co-criado em sessão separada."
		rationale: "Mollick 2024: co-intelligence requer julgamento humano para validação. Noy/Zhang 2023: ganho de produtividade é real, mas qualidade requer oversight. Artefato plausível mas incorreto no mesh-spec é pior que gap — porque agente futuro confia nele."
	},
	{
		description: "Esquecimento deliberado pode ser usado como justificativa para descartar conhecimento inconveniente em vez de obsoleto. O risco é 'esquecimento motivado' disfarçado de curadoria."
		alternative: "Todo artefato deprecated deve ter razão documentada e link para artefato substituto (se existir). Se não há substituto: é gap de conhecimento, não esquecimento legítimo. Distinção: 'este ADR foi superseded porque decisão mudou' (legítimo) vs 'este ADR é inconveniente porque mostra que mudamos de direção sem justificativa' (esquecimento motivado)."
		rationale: "De Holan/Phillips 2004: esquecimento pode ser acidental ou deliberado. O deliberado deve ser justificado e auditável. Esquecimento motivado é sunk cost bias ao contrário — descartar evidência de erro para evitar desconforto."
	},
]

rationale: "Toda organização opera com base em conhecimento — sobre mercado, produto, decisões passadas, e o que funciona. Na Mesh AI-native com solo founder, conhecimento organizacional é duplamente crítico: agentes IA são stateless e conhecem apenas o que está no mesh-spec; todo conhecimento tácito está numa única cabeça sem redundância. Esta lens operacionaliza: memória organizacional em múltiplos repositórios (Walsh/Ungson 1991, Argote/Miron-Spektor 2011), conversão tácito-explícito como prática contínua (Nonaka/Takeuchi 1995, Polanyi 1966, Collins 2010), decision records como first-class artifacts (Nygard 2011, Tyree/Akerman 2005, Pratt 2019), knowledge as code versionável e testável (Morris 2016, Forsgren et al. 2018), gestão de carga cognitiva para humanos e agentes (Sweller 1988, Skelton/Pais 2019, Miller 1956), RAG e acesso ao conhecimento com failure points documentados (Lewis et al. 2020, Gao et al. 2024, Barnett et al. 2024, Ram et al. 2023), preservação de contexto para agentes stateless com memory architectures (Shanahan 2024, Sumers et al. 2024, Park et al. 2023), double-loop learning que questiona premissas (Argyris/Schön 1978, Edmondson 2019, Schoemaker/Gunther McGrath 2023), after-action review para aprendizado pós-evento (US Army 1993, Thomke 2020), decaimento e refresh de conhecimento com TTL (De Holan/Phillips 2004, Argote 1999, Kransdorff 1998), prevenção de amnésia institucional com bus factor como métrica (Kransdorff 1998, DeLong 2004), criação colaborativa de conhecimento com IA como co-autor (Mollick 2024, Noy/Zhang 2023, Wilson/Daugherty 2018, Murray et al. 2023), e esquecimento deliberado como curadoria ativa do repositório (De Holan/Phillips 2004, Hedberg 1981, Martin de Holan/Phillips 2011). Universal, agnóstica a estágio, aplicável a qualquer organização que opera com conhecimento como ativo."

}
