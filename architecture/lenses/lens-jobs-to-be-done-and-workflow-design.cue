package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

jobsToBeDoneAndWorkflowDesign: artifact_schemas.#AnalyticalLens & {
id:     "lens-jobs-to-be-done-and-workflow-design"
name:   "Jobs-to-Be-Done e Design de Workflows"

purpose: "Orientar decisões sobre como entender e servir os jobs reais dos participantes — não features, mas outcomes que contratam a Mesh para alcançar."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve entender o que o usuário realmente está tentando realizar (job) e por que contrata o produto",
		"a decisão envolve projetar workflows — sequências de passos que o usuário percorre para completar uma tarefa",
		"a decisão envolve priorizar funcionalidades baseado no progresso que o usuário quer fazer na vida/trabalho",
		"a decisão envolve como reduzir fricção em processos operacionais que envolvem múltiplos participantes",
		"a decisão envolve como projetar experiências para diferentes personas (fornecedor, construtora, gestor FIDC, regulador)",
		"a decisão envolve trade-offs entre automação e controle manual em workflows com decisões consequentes",
		"a decisão envolve como medir se o produto está entregando o outcome que o usuário espera",
		"a decisão envolve como projetar onboarding que leva o usuário ao primeiro valor (aha moment) rapidamente",
		"a decisão envolve como adaptar workflows para diferentes níveis de sofisticação tecnológica dos usuários",
		"a decisão envolve como projetar default behaviors e progressive disclosure em interfaces complexas",
	]
	keywords: [
		"JTBD", "jobs to be done", "job", "hiring", "firing",
		"workflow", "fluxo", "processo", "step", "etapa",
		"persona", "user", "usuário", "stakeholder",
		"outcome", "resultado", "progresso", "progress",
		"fricção", "friction", "barreira", "bloqueio",
		"automação", "automation", "manual", "human-in-the-loop",
		"onboarding", "activation", "aha moment", "time-to-value",
		"default", "progressive disclosure", "complexity hiding",
		"task", "tarefa", "ação", "atividade",
		"funnel", "conversão", "drop-off", "abandono",
		"satisfação", "NPS", "CSAT", "effort score",
		"self-service", "guided", "assistido", "wizard",
	]
	excludeWhen: [
		"a decisão é sobre UX de plataforma multisided especificamente — usar multi-sided-platform-ux",
		"a decisão é sobre confiança e credibilidade como experiência — usar trust-and-credibility-design",
		"a decisão é sobre cold start e bootstrapping de rede — usar cold-start-and-network-bootstrapping",
		"a decisão é sobre pricing e monetização — usar pricing-and-monetization-architecture",
		"a decisão é sobre design visual (tipografia, cor, density) — usar lenses de design visual",
	]
	rationale: "Toda plataforma existe para ajudar pessoas a fazer progresso — de um estado atual insatisfatório para um estado desejado melhor. Jobs-to-Be-Done é o framework que revela o que o usuário realmente quer (não o que diz querer), e workflow design é a tradução desse entendimento em experiência operacional. Na Mesh como plataforma B2B com múltiplos participantes (fornecedor, construtora, gestor FIDC, regulador), cada persona tem jobs diferentes e frequentemente conflitantes: fornecedor quer dinheiro rápido, construtora quer governança, FIDC quer retorno com risco controlado, regulador quer compliance. O produto precisa satisfazer múltiplos jobs simultaneamente com workflows que minimizam fricção sem sacrificar controle. Multi-sided-platform-ux cobre dinâmicas de plataforma multisided; trust-and-credibility-design cobre confiança. Esta lens cobre o entendimento profundo do job de cada persona e a tradução em workflows operacionais eficientes."
}

concepts: [
	{
		id:         "jtbd-jobs-theory"
		name:       "Jobs-to-Be-Done: O Que o Usuário Está Contratando o Produto Para Fazer"
		nature:     "theoretical"
		role:       "framework"
		definition: "Christensen et al. (2016, Competing Against Luck): pessoas não compram produtos — contratam produtos para fazer um job. O job é o progresso que a pessoa quer fazer numa circunstância particular. O job tem 3 dimensões: (1) funcional — o que precisa ser feito ('antecipar recebível para pagar fornecedor de materiais amanhã'). (2) emocional — como quer se sentir ('seguro de que não vou ficar sem caixa'). (3) social — como quer ser percebido ('empresa que paga em dia, confiável'). Ulwick (2016, Jobs to Be Done: Theory to Practice): framework de outcome-driven innovation — jobs são estáveis (fornecedor sempre vai querer receber dinheiro rápido), soluções mudam. Mapear o job completo: (a) definir o job, (b) localizar o job, (c) preparar, (d) confirmar, (e) executar, (f) monitorar, (g) modificar, (h) concluir. Conceito contemporâneo de 'demand-side sales' (Moesta 2020, Demand-Side Sales 101): entender os 4 forças que governam switching — push (insatisfação atual), pull (atração da nova solução), anxiety (medo de mudar), habit (inércia do status quo). Vender é amplificar push + pull e reduzir anxiety + habit. Conceito de 'hiring criteria' (Klement 2018, When Coffee and Kale Compete): o que faz o usuário 'contratar' um produto não é feature list — é fit com o job na circunstância. Feature que não serve o job é desperdício."
		meshManifestation: "Na Mesh, jobs por persona: (1) fornecedor — job funcional: 'receber dinheiro que me devem antes do prazo para manter meu caixa girando.' Job emocional: 'não quero ficar dependendo da boa vontade da construtora para pagar.' Job social: 'quero ser visto como fornecedor profissional que não precisa implorar por pagamento.' Circunstância: fornecedor de material de construção, PME, com ciclo de recebimento de 60-90 dias, caixa apertado, precisa pagar seus próprios fornecedores. (2) construtora — job funcional: 'gerenciar minha cadeia de fornecedores com eficiência — saber quem está qualificado, quem está com documentação em dia, onde estou gastando.' Job emocional: 'não quero surpresas — fornecedor que para de entregar, problema de compliance que me pega.' Job social: 'quero ser reconhecido como construtora organizada que paga bem e atrai bons fornecedores.' (3) gestor FIDC — job funcional: 'maximizar retorno da carteira com risco controlado e compliance impecável.' Job emocional: 'quero dormir tranquilo sabendo que a carteira está saudável.' Job social: 'quero reportar para cotistas números sólidos com governança transparente.' (4) regulador — job funcional: 'garantir que operações estão em conformidade com a regulação.' Job emocional: 'não quero que algo passe despercebido que cause problema depois.' Cada persona 'contrata' a Mesh para um job diferente — o produto precisa servir todos sem otimizar um às custas do outro."
		meshImplication: "Para cada feature e decisão de produto: (1) identificar qual job serve — se não serve nenhum job claramente: questionar se vale a pena. (2) priorizar por 'underserved outcomes' — jobs que estão mal-atendidos pela solução atual (factoring tradicional para fornecedor: caro, burocrático, opaco. Construtora: gestão manual de fornecedores em planilha). (3) mapear as 4 forças por persona: para fornecedor — push: taxa alta de factoring tradicional + burocracia. Pull: Mesh oferece taxa menor + processo digital. Anxiety: 'e se a plataforma não funcionar? E se eu perder meus dados?' Habit: 'já tenho relação com meu fator, é mais fácil continuar.' Produto deve amplificar push+pull (transparência de taxa, simplicidade) e reduzir anxiety+habit (onboarding suave, garantia de dados, migração assistida). (4) job map completo por persona — para fornecedor: (a) definir: 'preciso antecipar recebível'. (b) localizar: 'qual plataforma oferece?' (c) preparar: 'preciso me cadastrar, enviar documentos.' (d) confirmar: 'a taxa oferecida compensa?' (e) executar: 'submeter operação.' (f) monitorar: 'em que status está?' (g) modificar: 'posso alterar valor ou prazo?' (h) concluir: 'recebi o dinheiro.' Cada step é ponto de fricção potencial — minimizar. (5) revisar jobs trimestralmente — jobs mudam com circunstância. Se economia muda, se regulação muda: jobs de fornecedor e construtora podem mudar."
		rationale: "Christensen et al. 2016: jobs theory. Ulwick 2016: outcome-driven innovation. Moesta 2020: 4 forces. Klement 2018: hiring criteria. Na Mesh, cada persona contrata a plataforma para job diferente — entender jobs é o que permite priorizar features que geram progresso real, não features que parecem boas."
	},
	{
		id:         "jtbd-workflow-mapping"
		name:       "Workflow Mapping: Traduzir Jobs em Sequências de Passos Executáveis"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Workflow é a tradução do job em sequência de passos que o usuário percorre para completar a tarefa. Cada step tem: (1) actor — quem executa (fornecedor, agente, construtora). (2) action — o que faz. (3) input — o que precisa para fazer. (4) output — o que produz. (5) decision point — se há escolha ou gate. (6) friction — o que pode impedir ou atrasar. Conceito de 'service blueprint' (Shostack 1984, evoluído por Gibbons 2017 NNg): mapeamento que distingue frontstage (o que o usuário vê), backstage (o que acontece atrás dos panos), e support processes (infraestrutura). Na Mesh: fornecedor vê 'operação aprovada em 30s' (frontstage); atrás: agente validou documentos, consultou feature store, calculou score, aplicou rules, decidiu (backstage). Conceito contemporâneo de 'workflow as code' (Temporal 2020+, n8n 2022+, Inngest 2023+): workflows definidos como código, não como diagramas estáticos — versionáveis, testáveis, observáveis. Cada step é executável, com retry, timeout, e compensation. Conceito de 'human-in-the-loop workflows' (2023+): workflows onde decisões consequentes requerem aprovação humana — mas o default é automação, e human approval é exception, não regra. Projetar para 'automation first, escalation when needed' (aag-hitl-calibration)."
		meshManifestation: "Na Mesh, workflows core: (1) antecipação — fornecedor submete → agente valida documentos → agente consulta score → rules engine aplica políticas → decisão (aprovar/rejeitar/escalar) → se aprovado: liquidação → confirmação → registro. 7-9 steps. Frontstage: fornecedor vê status em cada step. Backstage: 6 subsistemas operando. (2) qualificação de fornecedor — construtora convida → fornecedor se cadastra → submete documentos → agente valida → compliance check → qualificado/pendente/rejeitado. 5-6 steps. (3) onboarding de construtora — signup → integração com ERP (se aplicável) → importar fornecedores → configurar políticas → primeira operação. 4-5 steps. (4) relatório FIDC — agente coleta dados de carteira → agrega por período → aplica métricas (dm-semantic-layer) → gera relatório → gestor revisa → publica para cotistas. Para cada workflow: identificar o step com maior fricção (onde usuários abandonam ou reclamam) e otimizar primeiro."
		meshImplication: "Para cada workflow: (1) mapear end-to-end com service blueprint: frontstage (o que cada persona vê), backstage (o que agentes fazem), support (infra — feature store, event store, broker). (2) identificar friction points — para cada step: quanto tempo leva? Qual % de usuários abandona? O que impede progresso? (3) priorizar redução de fricção no step com maior drop-off — se 40% dos fornecedores abandonam no step 'submeter documentos': simplificar (menos documentos, upload mais fácil, pré-preenchimento, OCR). Se 20% abandonam em 'aguardar aprovação >24h': acelerar (automação de scoring, decisão em <30s). (4) workflow as code — workflows core definidos em Temporal ou equivalente (eda-choreography-vs-orchestration). Cada step com: timeout (se step não completa em X: escalar), retry (se falha transiente: retry automático), compensation (se step downstream falha: rollback ou compensação). (5) happy path + exception paths — projetar o caminho feliz primeiro (tudo funciona). Depois: o que acontece se documento é inválido? Se score está indisponível? Se pagamento não confirma? Cada exception tem tratamento explícito, não silêncio. (6) métricas por workflow: completion rate (% que completa do início ao fim), time-to-completion (tempo médio), drop-off por step (onde abandonam), error rate por step. Anti-pattern: workflow desenhado em Figma que nunca é implementado como código — diverge de produção em semanas."
		dependsOn: ["jtbd-jobs-theory"]
		crossDependsOn: [{
			lensId:    "lens-event-driven-architecture-patterns"
			conceptId: "eda-choreography-vs-orchestration"
			context:   "EDA define choreography vs orchestration para coordenação de fluxos. JTBD workflows são implementados como sagas orquestradas (fluxo de antecipação com compensação) ou eventos choreographed (qualificação com side effects independentes). EDA é o mecanismo; JTBD é o design do fluxo orientado ao job do usuário. O workflow map traduz job → steps; EDA implementa steps → eventos/sagas."
		}]
		rationale: "Shostack 1984: service blueprint. Temporal 2020+: workflow as code. Human-in-the-loop 2023+: automation first. Na Mesh com múltiplos participantes e agentes, workflows são a tradução de jobs em experiência operacional — sem mapeamento explícito, cada persona tem experiência inconsistente e friction points invisíveis."
	},
	{
		id:         "jtbd-friction-mapping"
		name:       "Mapeamento de Fricção: Identificar e Eliminar o que Impede Progresso"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Fricção é qualquer força que impede o usuário de completar seu job. Tipos: (1) cognitive friction — complexidade que exige pensamento excessivo ('que documentos preciso enviar?', 'o que esse status significa?'). (2) operational friction — steps desnecessários, esperas, processos manuais ('preciso ligar para confirmar', 'preciso esperar 3 dias'). (3) emotional friction — ansiedade, incerteza, medo ('será que meu dinheiro está seguro?', 'será que vou ser aprovado?'). (4) systemic friction — limitações de infraestrutura, indisponibilidade, lentidão ('sistema fora do ar', 'página demora 8s'). Conceito contemporâneo de 'effort score' (CEB/Gartner 2013, evoluído 2022+): métrica que mede esforço percebido pelo usuário para completar uma tarefa — mais preditivo de lealdade que satisfação (CSAT) ou recomendação (NPS). Baixo esforço = retenção. Alto esforço = churn. Conceito de 'friction audit' (2023+): exercício sistemático de percorrer cada step do workflow como se fosse o usuário, identificar todo ponto de fricção, classificar por severidade e frequência, e priorizar remoção. Conceito de 'good friction' (Zaltman 2003, evoluído 2023+): nem toda fricção é ruim — fricção intencional pode proteger o usuário (confirmação antes de operação irreversível), criar confiança (mostrar que validação de compliance é rigorosa), ou prevenir erro (guardrail em automação). Remover toda fricção cria produto rápido mas inseguro."
		meshManifestation: "Na Mesh, friction map por persona: (1) fornecedor — cognitive: 'qual a taxa final? Como é calculada?' → transparência de pricing. Operational: 'preciso enviar 7 documentos para cada operação' → reduzir para documentos estritamente necessários, pré-preencher, cache de documentos válidos. Emotional: 'será que vou receber o dinheiro mesmo?' → status tracking em tempo real, notificações proativas. Systemic: 'submeti operação às 18h e só recebi resposta às 9h do dia seguinte' → automação 24/7 com agentes. (2) construtora — cognitive: 'como saber se meu fornecedor está qualificado?' → dashboard claro com status. Operational: 'preciso verificar manualmente se CNDs estão válidas todo mês' → monitoramento automático por agente. Emotional: 'e se tiver problema de compliance que eu não detectei?' → alertas proativos. (3) gestor FIDC — cognitive: 'como calcular inadimplência da carteira com confiança?' → semantic layer com métricas definidas (dm-semantic-layer). Operational: 'preciso compilar relatório manualmente a cada mês' → relatório gerado automaticamente. (4) fricção boa na Mesh: confirmação de operação >R$100k (prevenir erro), validação de documentos rigorosa (compliance), cooling period antes de primeira operação com novo comprador (risco)."
		meshImplication: "Friction audit trimestral: (1) para cada workflow core: percorrer como se fosse a persona. Registrar cada ponto onde: parei para pensar (cognitive), esperei (operational), me preocupei (emotional), algo falhou (systemic). (2) classificar por impacto × frequência: high impact + high frequency → eliminar urgentemente. Low impact + low frequency → backlog. (3) priorizar: (a) operational friction que causa drop-off mensurável ('40% abandonam upload de documentos' → simplificar). (b) emotional friction que impede conversão ('medo de taxa escondida' → transparência total, simulador de taxa). (c) cognitive friction que gera support tickets ('o que significa status X?' → rename + tooltip + notificação com contexto). (4) preservar good friction: confirmação para operações irreversíveis, validação rigorosa de compliance, review humana para decisões acima de threshold. Documentar: 'esta fricção é intencional porque [protege contra X].' (5) medir esforço: Customer Effort Score (CES) por workflow. 'Quão fácil foi submeter uma operação de antecipação? 1 (muito difícil) a 7 (muito fácil).' Target: CES >5 para workflows core. Se <4: friction audit urgente. (6) instrument drop-off: para cada step do workflow, tracking de: entrou no step, completou o step, tempo no step, abandonou (e voltou depois? ou nunca?). Funnel analysis por workflow. Anti-pattern: otimizar UX sem friction map — polir o step 7 enquanto 40% dos usuários abandonam no step 2."
		dependsOn: ["jtbd-workflow-mapping"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-sli-slo-error-budget"
			context:   "OOI define SLIs/SLOs para serviços. JTBD friction mapping define SLOs para experiência — CES por workflow, time-to-completion por step, drop-off rate. OOI é SLO técnico (latência, availability); JTBD é SLO de experiência (effort, completion, drop-off). Ambos necessários: serviço disponível com latência ok mas workflow confuso = experiência ruim."
		}]
		rationale: "CEB/Gartner 2013: effort score. Friction audit 2023+: exercício sistemático. Zaltman 2003: good friction. Na Mesh, a principal barreira à adoção não é feature missing — é fricção nos workflows existentes. Fornecedor que abandona upload de documentos não precisa de nova feature — precisa de upload mais fácil."
	},
	{
		id:         "jtbd-onboarding-activation"
		name:       "Onboarding e Ativação: Levar o Usuário ao Primeiro Valor Rapidamente"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Cagan (2017, Inspired): o momento mais crítico da experiência é o onboarding — do signup ao primeiro valor (aha moment). Se o usuário não experimenta valor rapidamente: abandona antes de formar hábito. Conceito de 'time-to-value' (TTV): quanto tempo do signup até o usuário experimentar o core value do produto? Para B2B SaaS: medido em minutos (self-service) a semanas (enterprise). Conceito de 'activation metric' (Reeves 2019): evento específico que, quando completado, correlaciona fortemente com retenção. Não é signup — é a ação que demonstra que o usuário entendeu e experimentou o valor. Facebook: 'adicionar 7 amigos em 10 dias'. Slack: 'enviar 2000 mensagens como equipe'. Conceito contemporâneo de 'product-led onboarding' (Pendo 2022+, Appcues 2023+): onboarding guiado pelo produto (tooltips, checklists, empty states informativos) em vez de onboarding humano. Reduz custo e escala melhor. Conceito de 'graduated onboarding' (2023+): em produtos complexos, onboarding progressivo — primeiro valor simples rapidamente, funcionalidades avançadas desbloqueadas gradualmente. Não sobrecarregar no dia 1."
		meshManifestation: "Na Mesh, aha moment por persona: (1) fornecedor — aha moment: 'submeti operação e recebi dinheiro em <24h.' Não é signup. Não é upload de documentos. É receber dinheiro. TTV ideal: <3 dias (signup → documentação → primeira operação → dinheiro). Se TTV >7 dias: fricção excessiva no onboarding. (2) construtora — aha moment: 'consigo ver todos os meus fornecedores qualificados e seus status num dashboard.' TTV ideal: <1 semana (signup → importar fornecedores → dashboard populado). (3) gestor FIDC — aha moment: 'vejo relatório de carteira com métricas confiáveis sem compilar manualmente.' TTV ideal: <2 semanas (setup → primeiras operações na carteira → relatório gerado). Activation metrics candidatas: fornecedor: primeira operação settled. Construtora: 5 fornecedores qualificados. FIDC: primeiro relatório gerado. Monitorar: % de signups que atingem activation metric em 30 dias. Se <30%: onboarding precisa de otimização."
		meshImplication: "Projetar onboarding por persona: (1) fornecedor — graduated onboarding: (a) dia 1: signup simples (CNPJ + email). Sem formulário de 20 campos. (b) dia 1-2: upload de documentos mínimos (CND, contrato social). Assistido por agente que valida em real-time e dá feedback imediato ('documento aceito' ou 'documento expirado — envie versão atualizada'). (c) dia 2-3: primeira operação de antecipação. Guia step-by-step. Simulador de taxa antes de submeter (reduz anxiety). (d) dia 3-5: dinheiro na conta. Aha moment atingido. Funcionalidades avançadas (histórico, analytics, múltiplas operações) desbloqueadas depois. (2) construtora — (a) signup com integração opcional (ERP). Se integra: fornecedores importados automaticamente. Se não: cadastro manual simplificado. (b) convidar fornecedores por email/WhatsApp. Template pronto. (c) dashboard com dados populados assim que fornecedores começam a interagir. (3) empty states informativos — quando dashboard está vazio (zero operações, zero fornecedores): não mostrar tela vazia. Mostrar: 'nenhuma operação ainda. Aqui é onde você verá suas antecipações. [Submeter primeira operação].' Call-to-action claro. (4) checklist de onboarding — progresso visível: 'setup 60% completo. Faltam: enviar CND, submeter primeira operação.' Checklists aumentam completion rate (Zeigarnik effect). (5) medir: funnel de onboarding por persona. Signup → documentação → activation → retenção 30d. Se drop-off entre signup e documentação >50%: simplificar documentação ou adicionar assistência. Anti-pattern: exigir integração com ERP antes de qualquer uso — construtora pequena não tem ERP. Graduated: funciona sem ERP, funciona melhor com ERP."
		dependsOn: ["jtbd-jobs-theory", "jtbd-friction-mapping"]
		crossDependsOn: [{
			lensId:    "lens-stakeholder-communication"
			conceptId: "sc-expectation-management"
			context:   "SC define gestão de expectativas com stakeholders. JTBD onboarding é o momento mais crítico de expectation management — fornecedor que espera dinheiro em 24h e recebe em 5 dias: expectativa violada. SC diz 'set expectations explicitly'; JTBD diz 'comunicar TTV esperado no onboarding e entregar dentro ou antes da promessa'."
		}]
		rationale: "Cagan 2017: onboarding é o momento mais crítico. Reeves 2019: activation metric. Product-led onboarding 2022+: guiado pelo produto. Graduated onboarding 2023+: progressivo. Na Mesh, fornecedor que não recebe dinheiro em <5 dias do signup está em risco de churn antes de experimentar valor — onboarding precisa minimizar tempo até dinheiro na conta."
	},
	{
		id:         "jtbd-progressive-disclosure"
		name:       "Progressive Disclosure: Mostrar Complexidade Gradualmente, Não de Uma Vez"
		nature:     "theoretical"
		role:       "method"
		definition: "Nielsen (2006, 'Progressive Disclosure'): interfaces complexas devem mostrar apenas o essencial inicialmente, revelando funcionalidades avançadas sob demanda. Reduz cognitive load (cognitive friction) sem reduzir capability. Princípio: 'easy things easy, hard things possible.' Krug (2014, Don't Make Me Think, 3rd ed.): 'o objetivo não é fazer o usuário pensar que algo é simples — é não fazer o usuário pensar sobre como usar o produto.' Conceito contemporâneo de 'smart defaults' (2022+): em vez de apresentar 15 opções, apresentar 1 default otimizado. Usuário avançado pode customizar; usuário normal aceita o default. Defaults são decisões de produto — cada default comunica 'achamos que para a maioria dos casos, isso é o melhor'. Conceito de 'progressive complexity' em B2B (2023+): em plataformas B2B complexas (Stripe, Segment, Datadog), experiência é projetada em camadas: (1) zero-config — funciona out of the box com defaults. (2) guided config — wizard para customização comum. (3) full config — API/config para power users. Cada camada serve um segmento de usuários sem que a complexidade de uma camada polua a outra."
		meshManifestation: "Na Mesh, progressive disclosure por funcionalidade: (1) submissão de operação — layer 1: 'antecipar recebível' com campos mínimos (comprador, valor, nota fiscal). Smart defaults: taxa calculada automaticamente, prazo inferido pela nota. Layer 2: 'configurações avançadas' (taxa custom, prazo custom, prioridade). Layer 3: API para submissão programática com parâmetros completos. (2) dashboard de construtora — layer 1: overview com números agregados (fornecedores qualificados, operações pendentes, gastos totais). Smart defaults: período = último mês, agrupamento = por fornecedor. Layer 2: drill-down por fornecedor, filtros avançados, comparação de períodos. Layer 3: export de dados, API de analytics, custom reports. (3) configuração de políticas — layer 1: defaults seguros (score mínimo = 60, valor máximo = R$100k, documentos requeridos = padrão). Construtora não precisa configurar nada para começar. Layer 2: customizar thresholds (score mínimo, valor máximo por comprador, documentos adicionais). Layer 3: regras condicionais complexas ('se fornecedor é novo E valor >R$50k: exigir aprovação manual'). (4) scoring explanation — layer 1: 'aprovado' ou 'rejeitado' com motivo principal em uma frase. Layer 2: fatores contribuintes (SHAP top 5). Layer 3: SHAP completo com counterfactuals (para regulador)."
		meshImplication: "Para cada funcionalidade: (1) definir 3 layers de disclosure: basic (80% dos usuários), advanced (15%), expert (5%). (2) smart defaults para layer basic — cada default é decisão de produto documentada. 'Score mínimo default = 60 porque: análise de inadimplência mostra que scores <60 têm taxa de default >15% — inaceitável para FIDC inicial.' Se default muda: é decision record (km-decision-records). (3) nunca exigir configuração para começar — zero-config funciona. Configuração é otimização, não pré-requisito. (4) sinalizar que advanced existe sem impor — 'opções avançadas ▸' colapsado. Não desaparece — está acessível para quem precisa. (5) diferentes personas usam diferentes layers: fornecedor PME usa layer 1 (submeter operação, ver status). Construtora enterprise usa layer 2 (customizar políticas, analytics avançado). Integrador usa layer 3 (API). Cada persona experimenta complexidade proporcional à sua necessidade. (6) anti-pattern: interface que mostra tudo de uma vez — formulário de operação com 30 campos, dashboard com 20 métricas, configuração com 50 opções. Cognitive overload que aumenta esforço e reduz adoption."
		dependsOn: ["jtbd-jobs-theory", "jtbd-friction-mapping"]
		rationale: "Nielsen 2006: progressive disclosure. Krug 2014: don't make me think. Smart defaults 2022+. Progressive complexity B2B 2023+. Na Mesh com personas de sofisticação tecnológica variada (fornecedor PME que usa WhatsApp vs gestor FIDC que usa Excel vs integrador que usa API), progressive disclosure é o que permite que o mesmo produto sirva todos sem sobrecarregar nenhum."
	},
	{
		id:         "jtbd-automation-human-balance"
		name:       "Equilíbrio Automação-Humano: Automatizar o Rotineiro, Escalar o Consequente"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Em plataformas AI-native, a questão não é 'automatizar ou não' — é 'quanto automatizar cada decisão.' Parasuraman et al. (2000, 'A Model for Types and Levels of Human Interaction with Automation'): 10 níveis de automação, do 'humano decide tudo' ao 'sistema decide tudo.' Cada tarefa pode ter nível diferente. Conceito contemporâneo de 'appropriate automation' (2023+): automatizar decisões de baixo risco completamente; decisões de alto risco com human-in-the-loop; decisões de risco médio com automation + audit. O nível de automação é proporcional ao blast radius (aag-blast-radius-containment). Conceito de 'automation bias' (Mosier/Skitka 1996): humanos tendem a aceitar output de sistema automatizado sem questionar — 'se o sistema aprovou, deve estar certo.' Em contexto financeiro: automation bias pode levar a aprovar operações de alto risco porque o score diz 75. Contramedida: não automatizar decisões acima de threshold de risco sem revisão, e apresentar dados que encorajem análise (não apenas resultado)."
		meshManifestation: "Na Mesh, automação por tipo de decisão: (1) full automation (low risk, high frequency) — validação de formato de documento (data, CNPJ, tipo). Atualização de compliance status (CND venceu). Cálculo de score. Geração de relatório FIDC. Notificação de status para fornecedor. Sem intervenção humana. (2) automation + audit (medium risk) — aprovação de antecipação <R$50k com score >70. Agente aprova automaticamente; sample de 10% auditado weekly por humano. Se auditoria detecta problema: ajustar rules ou modelo. (3) human-in-the-loop (high risk) — primeira operação com comprador novo (sem histórico). Operação >R$200k. Score entre 55-65 (zona cinzenta). Agente prepara análise com recomendação; humano decide. (4) human-only (critical) — mudança de política de scoring (threshold de aprovação). Exceção a regra (override de rejeição). Onboarding de anchor tenant. Mudança de contrato com FIDC."
		meshImplication: "Para cada decisão operacional: (1) classificar por risco × frequência: high freq + low risk → full automation. Low freq + high risk → human-in-the-loop. Medium: automation + audit. (2) definir thresholds explícitos (governados por config, não hardcoded): antecipação automática se: score >70 AND valor <R$50k AND comprador tem >3 operações históricas AND documentos válidos. Se qualquer condição falha: escalar. (3) apresentar dados, não apenas decisão: quando human-in-the-loop, agente apresenta: score com SHAP values, histórico do comprador, comparação com perfil similar, e recomendação com confidence. Humano decide informado — não rubber-stamp de score. (4) calibrar automação ao longo do tempo: à medida que scoring melhora e confiança cresce: expandir automação (reduzir threshold de escalação). Se scoring degrada: restringir (aumentar threshold). Calibração baseada em evidência (AUROC, taxa de default), não em conforto. (5) automation bias mitigation: para decisions automatizadas auditadas: auditor recebe dados completos (features, SHAP, outcome) sem ver a decisão do sistema primeiro — avaliação independente. Comparar decisão do auditor com decisão do sistema: se diverge >10%: investigar. (6) monitorar: taxa de escalação (% de decisões que escalam para humano). Se muito alta (>30%): automação é insuficiente (rules muito conservadoras) ou modelo é fraco. Se muito baixa (<1%): verificar se não está automatizando demais (automation bias). Anti-pattern: 'automatizar tudo porque somos AI-native' — decisão de R$500k com comprador novo aprovada automaticamente porque score diz 72."
		dependsOn: ["jtbd-workflow-mapping", "jtbd-friction-mapping"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-hitl-calibration"
			context:   "AAG define HITL calibration — quando agente escala para humano. JTBD operacionaliza no contexto de workflows específicos: para cada step de cada workflow, qual nível de automação. AAG é a política de escalação genérica; JTBD é a aplicação por workflow e por tipo de decisão. AAG diz 'escalar quando blast radius >X'; JTBD diz 'no workflow de antecipação, escalar quando valor >R$200k OU score <65 OU comprador novo'."
		}]
		rationale: "Parasuraman et al. 2000: 10 levels of automation. Appropriate automation 2023+. Mosier/Skitka 1996: automation bias. Na Mesh como intermediário financeiro, automação excessiva = risco financeiro não-contido. Automação insuficiente = experiência lenta e custo alto. O equilíbrio é proporcional ao risco de cada decisão."
	},
	{
		id:         "jtbd-multi-persona-orchestration"
		name:       "Orquestração Multi-Persona: Quando o Workflow Envolve Múltiplos Participantes"
		nature:     "theoretical"
		role:       "framework"
		definition: "Em plataformas B2B multisided, workflows envolvem múltiplos participantes com jobs, timelines e incentivos diferentes. Cada participante está num step diferente do mesmo workflow, e a experiência de um depende da ação do outro. Conceito de 'handoff design' (2022+): projetar a transição entre participantes — quando fornecedor submete operação, o 'bastão' passa para o agente de scoring. Quando agente aprova, o bastão passa para liquidação. Cada handoff é ponto de fricção potencial: delay, perda de contexto, informação inconsistente. Conceito contemporâneo de 'async collaboration in B2B' (2023+): em B2B, participantes operam em timelines diferentes — fornecedor submete às 18h, construtora aprova às 9h do dia seguinte, liquidação acontece às 14h. Workflow deve suportar operação assíncrona sem bloquear participantes. Conceito de 'transparency per role' (2022+): cada participante vê informação diferente do mesmo workflow — fornecedor vê 'em análise', construtora vê 'aguardando aprovação do comprador', gestor FIDC vê 'nova operação na carteira candidata'. Mesma realidade, perspectivas diferentes."
		meshManifestation: "Na Mesh, workflow de antecipação envolve 4+ participantes: (1) fornecedor — submete, monitora, recebe. Timeline: quer tudo em <24h. (2) agentes IA — validam, scoram, decidem. Timeline: <30s para decisão automática. (3) construtora (como comprador) — pode ter que confirmar obrigação. Timeline: pode demorar 1 dia (assíncrono). (4) banco/FIDC — liquida. Timeline: D+0 a D+2. (5) registradora — registra cessão. Timeline: D+0 a D+1. Cada participante tem perspectiva: fornecedor vê 'status: aguardando liquidação.' Banco vê 'nova instrução de liquidação.' Registradora vê 'nova cessão para registro.' Handoffs: fornecedor→agente (submission), agente→construtora (confirmação se necessário), agente→banco (liquidação), banco→registradora (registro). Cada handoff: ponto de delay potencial."
		meshImplication: "Projetar para múltiplos participantes: (1) para cada handoff: definir SLO de latência. Fornecedor→agente: <30s (automação). Agente→construtora: notificação imediata, resposta SLO <24h. Agente→banco: instrução enviada em <1h após aprovação. Banco→registradora: SLO do banco (Mesh monitora mas não controla). (2) transparency per role: cada participante tem view do workflow que mostra: status atual, próximo step, quem está 'com a bola', e ETA. Fornecedor não vê detalhes internos (score, rules). Construtora não vê dados financeiros do FIDC. Cada role vê o que precisa para acompanhar, não mais. (3) notificação proativa: quando handoff acontece, participante seguinte é notificado. Quando delay excede SLO: participante afetado é notificado com ETA atualizado. Não forçar o fornecedor a verificar status manualmente — push, não pull. (4) async-first design: nenhum participante é bloqueado por outro se possível. Se construtora precisa confirmar: operação fica em 'aguardando confirmação' — fornecedor vê status e ETA. Se confirmação não chega em SLO: escalar (notificar construtora, alertar agente). (5) single timeline: apesar de múltiplas perspectivas, há uma timeline canônica (event log — eda-event-sourcing). Cada participante vê projeção da timeline filtrada por role. Se discordância: timeline canônica resolve. (6) dead-end prevention: nenhum step do workflow pode ficar 'parado' sem timeout e escalação. Se documento pendente >48h: notificar + oferecer assistência. Se confirmação pendente >SLO: escalar para nível superior. Workflow sem timeout = operação que morre silenciosamente. Anti-pattern: workflow que bloqueia fornecedor por 3 dias porque construtora não viu email de confirmação — fornecedor não sabe por que está parado."
		dependsOn: ["jtbd-workflow-mapping", "jtbd-friction-mapping"]
		crossDependsOn: [{
			lensId:    "lens-stakeholder-communication"
			conceptId: "sc-audience-specific-framing"
			context:   "SC define framing por audiência — mesma informação apresentada diferentemente para diferentes stakeholders. JTBD multi-persona operacionaliza: fornecedor vê 'aprovado em 30s', construtora vê 'operação de antecipação aprovada para fornecedor X, valor Y', gestor FIDC vê 'nova operação na carteira, score 75, valor Y'. Mesma operação, 3 perspectivas. SC é o princípio de framing; JTBD é a implementação por role no workflow."
		}]
		rationale: "Handoff design 2022+: transições entre participantes. Async collaboration B2B 2023+: timelines diferentes. Transparency per role 2022+: perspectivas diferentes. Na Mesh com 4+ participantes por workflow, cada handoff e cada perspectiva é ponto de fricção ou ponto de valor — projetar explicitamente é a diferença entre workflow fluido e workflow onde ninguém sabe o status."
	},
	{
		id:         "jtbd-outcome-metrics"
		name:       "Métricas de Outcome: Medir se o Produto Está Entregando o Progresso Prometido"
		nature:     "operational"
		role:       "property"
		reviewCadence: "monthly"
		definition: "Ulwick (2016): outcome-driven innovation mede não o que o produto faz (features, usage) mas o que o produto entrega (progresso no job do usuário). Métricas de outcome: (1) job completion rate — % de tentativas que completam o job. (2) time-to-outcome — tempo do início ao resultado desejado. (3) effort score — esforço percebido para completar. (4) satisfaction — satisfação com o resultado. Conceito contemporâneo de 'pirate metrics' / AARRR (McClure 2007, atualizado 2023+): Acquisition → Activation → Revenue → Retention → Referral. Cada stage tem métricas: Activation = % que atinge aha moment. Retention = % que volta em 30/60/90 dias. Revenue = receita por usuário. Conceito de 'leading vs lagging indicators' (2022+): lagging (AUROC do scoring, inadimplência, receita) confirmam resultado após o fato. Leading (activation rate, CES, time-to-value, feature adoption) preveem resultado antes. Investir em leading indicators que têm poder preditivo sobre lagging."
		meshManifestation: "Na Mesh, outcome metrics por persona: (1) fornecedor — lagging: receita (volume antecipado × taxa), retenção 90d (% que faz segunda operação em 90 dias). Leading: activation rate (% que completa primeira operação em 30 dias), TTV (dias do signup ao primeiro dinheiro), CES de submissão de operação, NPS. (2) construtora — lagging: volume de operações na cadeia, taxa de retenção de fornecedores, compliance rate. Leading: onboarding completion rate, % de fornecedores qualificados em 30 dias, dashboard engagement (frequency of login). (3) FIDC — lagging: retorno da carteira, inadimplência, concentração. Leading: tempo de geração de relatório, confidence do gestor no relatório (qualitativo), adesão a SLOs de compliance. (4) plataforma — lagging: GMV (volume total transacionado), take rate, churn. Leading: funnel de onboarding por persona, activation rates, CES médio."
		meshImplication: "Definir e monitorar por persona: (1) para cada persona: 1 North Star metric (a métrica que melhor representa progresso no job) + 3-5 supporting metrics. Fornecedor: North Star = volume antecipado (progresso no job 'receber dinheiro'). Supporting: TTV, CES, taxa média, retention 90d. (2) dashboard de outcomes: métricas visíveis para founder e agentes. Leading indicators atualizados daily. Lagging monthly (quando disponíveis). (3) correlation analysis: qual leading indicator melhor prevê o lagging? Se TTV <3 dias correlaciona fortemente com retention 90d >70%: TTV é o leading indicator mais importante → otimizar. (4) targets por estágio: pré-revenue: TTV <5 dias, activation >30%. Tração: TTV <3 dias, activation >50%, CES >5, retention 90d >60%. Escala: TTV <2 dias, activation >70%, CES >6, retention 90d >80%. (5) não medir tudo: para cada métrica, perguntar — 'se essa métrica melhorar 20%, o produto é materially melhor para a persona?' Se não: não é outcome metric, é vanity metric. (6) qualitative complement: métricas não capturam tudo. Conversa mensal com 3-5 usuários por persona: 'o que é mais difícil? O que faria você usar mais? O que quase fez você desistir?' Insights qualitativos informam priorização de friction audit. Anti-pattern: medir DAU/MAU para B2B fintech — fornecedor usa quando precisa antecipar, não diariamente. Retenção por operação é melhor que por login."
		dependsOn: ["jtbd-jobs-theory", "jtbd-workflow-mapping", "jtbd-onboarding-activation"]
		crossDependsOn: [{
			lensId:    "lens-data-modeling-for-analytical-power"
			conceptId: "dm-semantic-layer"
			context:   "DM semantic layer define métricas como código para consistência. JTBD outcome metrics são métricas de negócio que devem ser calculadas consistentemente. 'Retention 90d' é métrica definida na semantic layer: % de fornecedores cuja primeira operação foi há >90 dias E que fizeram pelo menos 1 operação adicional. DM garante cálculo consistente; JTBD define quais métricas importam."
		}]
		rationale: "Ulwick 2016: outcome-driven. AARRR 2007/2023+: pirate metrics. Leading vs lagging 2022+. Na Mesh, medir features shipped ou DAU não informa se o produto está entregando progresso no job do fornecedor — outcome metrics (TTV, CES, retention, activation) informam."
	},
	{
		id:            "jtbd-workflow-review"
		name:          "Revisão de Jobs e Workflows: Inventário Periódico de Experiência e Progresso"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) jobs — jobs de cada persona continuam válidos? Circunstância mudou? Novo job emergiu? (2) workflows — workflow map atualizado? Novos workflows necessários? (3) friction — friction audit realizado? Top 3 friction points por persona? Ações de redução de fricção implementadas? (4) onboarding — TTV por persona? Activation rate? Funnel de onboarding sem bottleneck? (5) progressive disclosure — defaults adequados? Layers definidos? Complexidade escondida sem remover capability? (6) automation — taxa de escalação adequada? Automação calibrada? Automation bias detectado? (7) multi-persona — handoffs com SLO? Timeouts funcionando? Nenhum step morto? (8) outcomes — North Star por persona trending up? Leading indicators preditivos de lagging?"
		meshManifestation: "Na Mesh: revisão trimestral formal com conversation com 3-5 usuários. Mensal: micro-revisão (outcome metrics, funnel, friction points mais frequentes em support)."
		meshImplication: "Mensal (30min): outcome metrics — TTV, activation, CES, retention por persona. Trending up ou down? Funnel — drop-off por step. Algum step com drop-off >30%? Support tickets — top 5 complaints. São friction points conhecidos? Trimestral (2h): jobs review — conversar com 3-5 usuários por persona. 'O que é mais difícil? O que mudou?' Workflow update — novos steps necessários? Steps que podem ser eliminados? Friction audit — percorrer workflows core como persona. Registrar friction points. Comparar com trimestre anterior: melhorou? Onboarding — TTV trend. Activation rate trend. Funnel analysis. Onde otimizar? Automation calibration — taxa de escalação. Decisões automatizadas auditadas: concordância humano-sistema. Multi-persona — handoff SLOs cumpridos? Timeouts ativados? Workflows sem dead-end? Progressive disclosure — defaults ainda adequados? Feedback de usuários sobre complexidade? Se revisão não identifica pelo menos uma melhoria: ou experiência é perfeita (improvável) ou revisão é superficial."
		dependsOn: ["jtbd-jobs-theory", "jtbd-workflow-mapping", "jtbd-friction-mapping", "jtbd-onboarding-activation", "jtbd-progressive-disclosure", "jtbd-automation-human-balance", "jtbd-multi-persona-orchestration", "jtbd-outcome-metrics"]
		rationale: "Sem revisão periódica, workflows fossilizam enquanto jobs evoluem — fricção acumula, onboarding degrada, automação descalibra. O inventário periódico mantém a experiência alinhada com o progresso que as personas realmente buscam."
	},
]

reasoningProtocol: [
	{
		question:  "Qual é o job que cada persona está tentando completar? Funcional, emocional e social?"
		reveals:   "Se o produto é orientado ao progresso do usuário — ou se está construindo features que parecem boas mas não servem nenhum job claro."
		rationale: "Christensen 2016: jobs theory. Feature sem job é desperdício. Na Mesh, cada persona contrata a plataforma para job diferente."
	},
	{
		question:  "Cada workflow core está mapeado end-to-end (frontstage + backstage)? Onde estão os friction points?"
		reveals:   "Se a experiência operacional é projetada intencionalmente — ou se é resultado acidental de como features foram adicionadas."
		rationale: "Shostack 1984: service blueprint. Workflow não-mapeado = friction points invisíveis até que usuário reclame ou abandone."
	},
	{
		question:  "Qual é o step com maior drop-off no workflow? Por quê?"
		reveals:   "Se o maior gargalo é conhecido e sendo tratado — ou se polimos step 7 enquanto 40% abandonam no step 2."
		rationale: "Friction audit: priorizar pelo impacto × frequência. Drop-off é sinal de fricção que precisa de ação."
	},
	{
		question:  "Quanto tempo do signup até o primeiro valor (TTV)? A activation metric está definida e monitorada?"
		reveals:   "Se onboarding leva ao aha moment rapidamente — ou se usuário passa dias em setup antes de experimentar valor."
		rationale: "Cagan 2017: momento mais crítico. TTV alto = churn antes de hábito."
	},
	{
		question:  "A complexidade está escondida em layers (progressive disclosure) ou exposta toda de uma vez?"
		reveals:   "Se a interface serve tanto PME quanto enterprise — ou se sobrecarrega PME e subutiliza enterprise."
		rationale: "Nielsen 2006: progressive disclosure. Smart defaults: 80% usa layer 1. Mostrar tudo = cognitive overload."
	},
	{
		question:  "Para cada decisão automatizada: o nível de automação é proporcional ao risco? Automation bias é mitigado?"
		reveals:   "Se automação é calibrada — ou se automatiza demais (risco) ou de menos (lentidão)."
		rationale: "Parasuraman 2000: levels of automation. Na Mesh, antecipação de R$500k com comprador novo automatizada é risco não-contido."
	},
	{
		question:  "Handoffs entre participantes têm SLO de latência? Nenhum step está 'morto' sem timeout?"
		reveals:   "Se workflows multi-persona fluem — ou se operação morre silenciosamente porque construtora não viu email."
		rationale: "Handoff design: cada transição é ponto de delay. Timeout + notificação previne dead-end."
	},
	{
		question:  "North Star metric e leading indicators por persona estão definidos e trending up?"
		reveals:   "Se estamos medindo progresso real — ou se métricas são vanity (DAU para fintech B2B que não é usada diariamente)."
		rationale: "Ulwick 2016: outcome-driven. Leading indicators preveem resultado; lagging confirmam após o fato."
	},
]

meshExamples: [
	{
		id:       "ex-fornecedor-job-map"
		scenario: "Mesh precisa projetar o fluxo completo de antecipação do ponto de vista do fornecedor — do momento em que precisa de dinheiro até receber."
		analysis: "Job do fornecedor: 'receber dinheiro que me devem antes do prazo para manter meu caixa girando.' 4 forças: push (taxa alta do fator, processo burocrático, demora de 3-5 dias). Pull (Mesh: taxa menor, processo digital, <24h). Anxiety (plataforma nova, será que funciona?, será que é seguro?). Habit (já tenho relação com meu fator, conheço o processo). Job map: (1) define: 'preciso de dinheiro para pagar material amanhã.' (2) localize: 'quem antecipa? Fator? Mesh? Banco?' (3) prepare: 'preciso ter documentos, nota fiscal, cadastro.' (4) confirm: 'a taxa compensa? Melhor que fator?' (5) execute: 'submeter operação.' (6) monitor: 'está aprovada? Quando recebo?' (7) conclude: 'dinheiro na conta.' Friction points: step 3 (preparação de documentos — 7 tipos, upload complexo), step 6 (espera — ansiedade de não saber quando recebe), step 2 (discovery — como saber que Mesh existe?)."
		recommendation: "Workflow otimizado: (1) step 2 (discovery) — fornecedor é convidado pela construtora (não precisa descobrir sozinho). Email/WhatsApp com: 'sua construtora [nome] usa Mesh para antecipação. Taxa estimada: X%. [Cadastrar-se].' Reduz friction de discovery. (2) step 3 (prepare) — signup com CNPJ apenas. Documentos: solicitar apenas os obrigatórios (CND federal, CND estadual, contrato social). Upload: drag-and-drop com validação real-time por agente. Pré-preenchimento via API de dados públicos (CNPJ → nome, endereço). Cache: documentos válidos por 30 dias (não re-enviar a cada operação). (3) step 4 (confirm) — simulador de taxa antes de submeter: 'para nota de R$50k com vencimento em 45 dias: taxa estimada 2.3%, você recebe R$48.850.' Transparência total. Comparação: 'taxa típica de factoring para este perfil: 3.5-4.5%.' (4) step 5 (execute) — formulário com 3 campos: comprador (dropdown), valor, nota fiscal (upload). Smart defaults: prazo inferido da nota. Taxa calculada automaticamente. Submissão em <2 minutos. (5) step 6 (monitor) — notificação push a cada mudança de status: 'documentos validados ✓', 'score calculado ✓', 'operação aprovada ✓', 'liquidação iniciada', 'dinheiro depositado.' Timeline visual com ETA. (6) step 7 (conclude) — confirmação com comprovante: 'R$48.850 depositados na conta XX. Prazo de pagamento: 45 dias.' CES survey: 'quão fácil foi? 1-7.' TTV target: <3 dias do signup ao dinheiro."
		principlesApplied: ["ax-01", "ax-02", "ax-04"]
		assumptions: [
			"fornecedor aceita ser convidado pela construtora — pode querer encontrar por conta própria",
			"3 documentos são suficientes para compliance inicial — pode precisar de mais dependendo da regulação",
			"simulador de taxa com comparação não revela pricing strategy — taxa do competidor é estimativa",
			"notificação push é canal adequado — fornecedor PME pode preferir WhatsApp",
		]
		rationale: "Christensen 2016: job map. Moesta 2020: 4 forces. Na Mesh, o job do fornecedor é receber dinheiro rápido — cada step do workflow é avaliado por quanto contribui para esse outcome. Upload de 7 documentos não contribui para receber dinheiro — é friction. Reduzir para 3 + cache é otimizar para o job."
	},
	{
		id:       "ex-progressive-disclosure-policies"
		scenario: "Construtora quer configurar políticas de aprovação (score mínimo, valor máximo, documentos requeridos). Interface atual mostra 15 campos de configuração num único formulário. Construtora pequena (5 fornecedores) abandona sem configurar. Construtora enterprise (200 fornecedores) reclama que faltam opções."
		analysis: "Dois segmentos com necessidades opostas: construtora pequena quer simplicidade (o menos possível). Construtora enterprise quer controle (o mais granular possível). Formulário único de 15 campos: muito para pequena, insuficiente para enterprise. Progressive disclosure resolve: layers para cada segmento."
		recommendation: "3 layers: (1) layer zero-config — defaults seguros aplicados automaticamente. Construtora não precisa configurar nada para começar. Defaults: score mínimo = 60, valor máximo por operação = R$100k, documentos requeridos = CND federal + estadual + contrato social, aprovação automática se score ≥ 70 e valor ≤ R$50k. Comunicar: 'configuração padrão aplicada. Seus fornecedores já podem solicitar antecipação. [Customizar].' (2) layer guided — wizard de 3 steps para customização comum. Step 1: 'Qual sua tolerância de risco?' [Conservador / Moderado / Agressivo] → traduz para score mínimo (70/60/50). Step 2: 'Qual o valor máximo por operação?' [R$50k / R$100k / R$200k / Custom]. Step 3: 'Documentos adicionais?' [Nenhum / Certidão trabalhista / Custom]. Wizard traduz escolhas humanas em config técnica. Construtora pequena completa em 2 minutos. (3) layer full-config — para enterprise: painel com todos os 15+ campos + regras condicionais. 'Se fornecedor é novo E valor >R$80k: exigir aprovação manual do gestor.' 'Se segmento é infraestrutura: score mínimo = 70 (mais conservador).' API para configuração programática. Documentar cada default: 'score mínimo default = 60 porque análise mostra que scores <60 têm taxa de default >15% em construção civil.' Se construtora muda default para <50: warning — 'atenção: scores abaixo de 50 têm taxa de default >25% historicamente.' Não bloquear — informar."
		principlesApplied: ["ax-01", "ax-02", "ax-04"]
		assumptions: [
			"construtora pequena não precisa de configuração avançada — pode ter necessidade específica não coberta pelo wizard",
			"wizard de 3 steps cobre 80% das necessidades — validar com user research",
			"defaults são seguros para FIDC (score mínimo 60 = inadimplência aceitável) — calibrar com dados reais",
			"construtora enterprise aceita layer full-config como suficiente — pode precisar de API mais rica",
		]
		rationale: "Nielsen 2006: progressive disclosure. Smart defaults 2022+. Na Mesh, construtora que abandona configuração porque formulário tem 15 campos não é construtora que 'não precisa da feature' — é construtora que precisa de layer zero-config. Construtora enterprise que reclama que faltam opções precisa de layer full-config. Ambas servidas pelo mesmo produto."
	},
	{
		id:       "ex-automation-calibration"
		scenario: "Mesh opera há 6 meses. 90% das antecipações são aprovadas automaticamente (score >70, valor <R$50k, comprador com histórico). Taxa de escalação para humano: 10%. Auditoria mensal de 20 decisões automáticas revela: 2 operações aprovadas tinham comprador com deterioração de faturamento nos últimos 2 meses — score não capturou porque feature de faturamento atualiza mensalmente."
		analysis: "Automação está funcionando (90% automático, throughput alto, fornecedor feliz com <30s de decisão). Mas auditoria revelou: 10% de error rate na amostra auditada (2/20). Extrapolando: ~10% das aprovações automáticas podem ser questionáveis. Causa: feature de faturamento com freshness de 30 dias — deterioração nos últimos 2 meses não é capturada entre atualizações. Não é bug no modelo — é gap no feature store (dm-feature-store freshness). Opções: (1) melhorar freshness da feature (atualizar faturamento semanalmente em vez de mensalmente). (2) adicionar regra de automação: 'se faturamento caiu >20% no último update: escalar para human.' (3) restringir automação: reduzir threshold de automação de score >70 para >75 (mais conservador, mais escalação). (4) combinar: melhorar freshness + regra de deterioração."
		recommendation: "(1) Curto prazo — adicionar regra de deterioração: 'se faturamento no último update caiu >20% vs update anterior: escalar para human review, mesmo que score >70.' Implementação: <1 dia. Impacto: ~3-5% de operações adicionais escaladas. Fornecedor afetado recebe 'em análise detalhada' em vez de aprovação imediata — delay de <24h. (2) Médio prazo — melhorar freshness de faturamento: de mensal para quinzenal (integrações que permitem). Reduz janela de deterioração não-detectada de 30 para 15 dias. (3) não restringir threshold de automação de 70 para 75: isso afeta todos os compradores (95% dos quais não têm problema). Regra de deterioração é targeted — afeta apenas compradores com faturamento em queda. (4) medir impacto: após implementar regra, auditar novamente em 30 dias. Se error rate cai de 10% para <3%: regra eficaz. Se não: investigar outros gaps. (5) recalibrar audit: aumentar amostra de 20 para 50 por mês. 20 é insuficiente para detectar error rate <5% com confiança. (6) documentar: ADR 'Regra de deterioração de faturamento adicionada ao automation engine — fornecedores com faturamento em queda >20% são escalados para human review.' Princípio: 'automação robusta requer monitoring + regras de exception, não apenas score threshold.'"
		principlesApplied: ["ax-03", "ax-05", "dp-01"]
		assumptions: [
			"2/20 na auditoria é representativo — amostra pequena, error rate real pode ser 5% ou 15%",
			"deterioração de faturamento >20% é threshold adequado — calibrar com dados de default",
			"escalação para human adiciona <24h de delay — aceitável para fornecedor?",
			"integrações permitem atualização quinzenal — depende do ERP da construtora",
		]
		rationale: "Parasuraman 2000: calibrar automação continuamente. Automation audit 2023+. Na Mesh, 90% de automação é excelente para experiência — mas 10% de error rate é inaceitável para intermediário financeiro. Regra de deterioração é cirúrgica: afeta poucos, protege todos."
	},
	{
		id:       "ex-multi-persona-handoff"
		scenario: "Fornecedor submete operação de antecipação às 17h de sexta-feira. Agente aprova em 30s. Liquidação depende de confirmação do banco que opera em horário comercial (9h-17h). Fornecedor esperava dinheiro na conta no mesmo dia — recebe segunda-feira às 10h. NPS do fornecedor: 5 (detrator). Fornecedor liga para suporte: 'aprovaram mas não depositaram, que adianta?'"
		analysis: "Gap entre expectation (aprovação = dinheiro) e realidade (aprovação = início de liquidação, que depende de banco com horário comercial). Problema de multi-persona orchestration: aprovação é Mesh (24/7), liquidação é banco (horário comercial). Handoff Mesh→banco não é instantâneo e depende de janela operacional externa. Fornecedor não sabia que aprovação ≠ dinheiro porque comunicação não separou os conceitos. Emotional friction: frustração por expectativa violada. Não é bug de sistema — é bug de comunicação e expectation management."
		recommendation: "(1) Antes de submeter: comunicar timeline realista. 'Operações submetidas até 15h em dias úteis: liquidação no mesmo dia ou D+1. Operações submetidas após 15h ou fins de semana: liquidação no próximo dia útil.' Na interface de submissão: 'se submeter agora (sexta 17h): liquidação prevista segunda 10h.' Expectativa setada antes da decisão — fornecedor decide se submete ou espera. (2) Após aprovação: separar comunicação de 'aprovado' e 'dinheiro a caminho'. Notificação 1: 'operação aprovada ✓ — liquidação será processada no próximo dia útil (segunda-feira).' Notificação 2 (segunda): 'liquidação iniciada — previsão: hoje até 14h.' Notificação 3: 'R$48.850 depositados ✓.' (3) Timeline visual: no tracking do fornecedor, mostrar: aprovação (concluída) → liquidação (agendada: segunda 10h) → depósito (pendente). ETA visível em cada step. (4) Longo prazo: avaliar Pix como canal de liquidação — disponível 24/7, sem janela de horário comercial. Se viável: liquidação em <1h após aprovação, mesmo sexta às 17h. Elimina gap de handoff com banco. (5) Medir: CES para operações submetidas em horário comercial vs fora. Se CES é significativamente menor para fora: confirma gap. Após comunicação melhorada: CES deve subir."
		principlesApplied: ["ax-02", "ax-04"]
		assumptions: [
			"banco não processa liquidação fora de horário comercial — verificar se há opção de Pix 24/7",
			"comunicação prévia de timeline reduz frustração — validar com NPS após mudança",
			"fornecedor prefere receber segunda com expectativa correta do que expectativa de sexta frustrada — assumir que sim",
			"Pix como canal de liquidação é viável regulatoriamente — verificar com assessoria",
		]
		rationale: "SC expectation-management: set expectations before delivery. Handoff design: Mesh→banco é handoff com janela operacional. Na Mesh, a frustração não é com a demora — é com a surpresa. Fornecedor que sabe 'segunda 10h' antes de submeter é menos frustrado que fornecedor que descobre depois de ser aprovado."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-05", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-event-driven-architecture-patterns"
		relation: "complementsWith"
		context:  "EDA define como workflows são implementados tecnicamente (sagas, orchestration, events). JTBD define como workflows são projetados orientados ao job do usuário. EDA é o 'como implementar'; JTBD é o 'o que projetar'. Workflow map traduz job → steps; EDA implementa steps → eventos + sagas com compensação."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governa quando agentes escalam para humano (HITL calibration). JTBD define automação por tipo de decisão no workflow — full automation, automation+audit, HITL, human-only. AAG é a política genérica; JTBD é a aplicação por step de cada workflow."
	},
	{
		lensId:   "lens-stakeholder-communication"
		relation: "complementsWith"
		context:  "SC comunica com stakeholders (framing, expectation management, trust). JTBD multi-persona orchestration aplica: cada participante do workflow recebe comunicação calibrada por role. SC é o princípio; JTBD é a operacionalização por step do workflow."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI monitora sistema técnico (latência, availability). JTBD define SLOs de experiência (CES, TTV, drop-off rate). Ambos necessários: sistema rápido com workflow confuso = experiência ruim. OOI é infra; JTBD é experiência."
	},
	{
		lensId:   "lens-data-modeling-for-analytical-power"
		relation: "complementsWith"
		context:  "DM semantic layer define métricas como código. JTBD outcome metrics são métricas de negócio que devem ser calculadas consistentemente pela semantic layer. JTBD define quais métricas importam; DM garante cálculo consistente."
	},
	{
		lensId:   "lens-behavioral-economics"
		relation: "complementsWith"
		context:  "BE modela como vieses cognitivos afetam decisão. JTBD friction mapping identifica pontos onde vieses impactam experiência: anxiety (loss aversion na decisão de antecipar), status quo bias (habit com fator tradicional), cognitive overload (progressive disclosure). BE é o modelo teórico; JTBD é a aplicação no design de workflows."
	},
	{
		lensId:   "lens-mechanism-design"
		relation: "complementsWith"
		context:  "MD desenha mecanismos (scoring, pricing, reputação) que governam interação. JTBD projeta workflows que operacionalizam esses mecanismos — fornecedor interage com scoring via workflow de submissão, não diretamente com o modelo. MD é o mecanismo; JTBD é a experiência de interação com o mecanismo."
	},
	{
		lensId:   "lens-platform-dynamics"
		relation: "complementsWith"
		context:  "PD modela dinâmicas de plataforma multisided. JTBD projeta experiência para cada side da plataforma com jobs diferentes. PD diz 'fornecedor e construtora têm incentivos diferentes'; JTBD diz 'workflow de antecipação atende job do fornecedor (dinheiro rápido) e da construtora (governança) simultaneamente'."
	},
]

limitations: [
	{
		description: "Jobs-to-Be-Done assume que jobs são estáveis e descobríveis. Em mercados novos ou categorias emergentes, jobs podem ser mal-definidos ou em evolução — usuários não sabem o que querem porque a possibilidade não existia."
		alternative: "Para categorias emergentes: combinar JTBD (o que existe hoje) com experimentação (testar novas possibilidades). Fornecedor nunca teve acesso a antecipação digital — job é inferido de analog (factoring) + pain points. Iterar com usuários reais para refinar jobs."
		rationale: "Christensen 2016 foca em jobs existentes. Para innovation radical: jobs são hipóteses a serem validadas, não fatos a serem descobertos."
	},
	{
		description: "Workflow mapping para plataforma pré-revenue é especulativo — baseado em suposições sobre como personas vão interagir, não em dados de uso real."
		alternative: "Mapear workflows como hipótese v1. Instrumentar cada step para coletar dados. Iterar baseado em dados reais após launch. Primeiro workflow funcional é mais valioso que workflow perfeito no papel."
		rationale: "Lean Startup: build-measure-learn. Workflow v1 é hipótese; dados de uso real informam v2."
	},
	{
		description: "Friction mapping pode levar a over-optimization de workflow existente em vez de repensar fundamentalmente. Otimizar upload de documentos é bom; eliminar necessidade de upload é melhor."
		alternative: "Além de friction audit (otimizar steps): job-level rethink trimestral — 'este step precisa existir? Ou existe porque sempre existiu?' Conecta com dq-data-accumulation-strategy: se dados já estão disponíveis via integração, upload manual é step eliminável."
		rationale: "Friction audit otimiza incrementalmente. Rethink questiona fundamentalmente. Ambos necessários."
	},
	{
		description: "Progressive disclosure funciona quando layers são bem-definidos. Se boundaries entre layers são arbitrários, usuários ficam confusos ('onde está a opção X?')."
		alternative: "Testar layers com usuários reais de cada segmento. Se fornecedor PME procura opção que está em layer 3: boundary está errado. Iterar layers baseado em observação de uso, não em suposição de designer."
		rationale: "Layers são decisões de produto que precisam ser validadas. Layer arbitrário é pior que sem layer (pelo menos tudo é encontrável)."
	},
	{
		description: "Outcome metrics para B2B fintech têm feedback loop longo — retention de 90 dias demora 90 dias para medir. Decisões de produto baseadas em lagging indicators são sempre atrasadas."
		alternative: "Investir em leading indicators com poder preditivo: TTV, CES, activation rate. Validar correlação leading→lagging trimestralmente. Se leading prevê lagging com >70% accuracy: confiar em leading para decisões rápidas."
		rationale: "Leading indicators são aproximações — melhores que esperar 90 dias, piores que feedback instantâneo. Calibrar correlação é o que torna approximation confiável."
	},
]

rationale: "Toda plataforma existe para ajudar pessoas a fazer progresso — de um estado atual insatisfatório para um estado desejado melhor. Na Mesh como intermediário financeiro B2B com múltiplos participantes, cada persona contrata o produto para um job diferente e interage via workflows com fricção, handoffs e decisões automatizadas. Esta lens operacionaliza: Jobs-to-Be-Done como framework de entendimento de personas com 4 forças e job map (Christensen et al. 2016, Ulwick 2016, Moesta 2020, Klement 2018), workflow mapping com service blueprint e workflow as code (Shostack 1984, Temporal 2020+, Inngest 2023+), friction mapping com effort score e good friction (CEB/Gartner 2013, friction audit 2023+, Zaltman 2003), onboarding e activation com TTV e graduated onboarding (Cagan 2017, Reeves 2019, product-led 2022+, graduated 2023+), progressive disclosure com smart defaults e progressive complexity (Nielsen 2006, Krug 2014, smart defaults 2022+, B2B progressive complexity 2023+), equilíbrio automação-humano com automation bias mitigation (Parasuraman et al. 2000, appropriate automation 2023+, Mosier/Skitka 1996), orquestração multi-persona com handoff design e async-first (handoff design 2022+, async B2B 2023+, transparency per role 2022+), e outcome metrics com pirate metrics e leading indicators (Ulwick 2016, AARRR 2007/2023+). Universal, agnóstica a estágio, aplicável a qualquer plataforma B2B com múltiplos participantes."

}
