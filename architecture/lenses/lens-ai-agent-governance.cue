package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aiAgentGovernance: artifact_schemas.#AnalyticalLens & {
	id:     "lens-ai-agent-governance"
	name:   "Governança de Agentes de IA"

	purpose: "Orientar decisões sobre como governar agentes IA que operam como workforce principal — autonomia, supervisão, escalation, e limites de autoridade."
	status: "draft"

	trigger: {
		conditions: [
			"a decisão envolve definir o que um agente de IA pode decidir autonomamente vs o que requer aprovação humana",
			"a decisão envolve como monitorar comportamento e output de agentes de IA em produção",
			"a decisão envolve quando e como um agente deve escalar uma decisão ao humano",
			"a decisão envolve expandir ou restringir a autonomia de um agente",
			"a decisão envolve detectar que um agente está derivando do comportamento esperado",
			"a decisão envolve codificar políticas de agente em artefatos versionáveis",
			"a decisão envolve limitar o dano máximo que um agente pode causar antes de intervenção",
			"a decisão envolve o ciclo de vida de uma capability de agente (onboarding, validação, expansão, deprecação)",
			"a decisão envolve projetar trilha de auditoria para ações de agentes",
			"a decisão envolve calibrar intensidade de supervisão humana sobre agentes",
		]
		keywords: [
			"autonomia", "agente", "governance", "governança",
			"escalation", "escalar", "human-in-the-loop", "HITL",
			"observabilidade", "logging", "telemetria", "monitoramento",
			"drift", "desvio", "degradação", "desalinhamento",
			"CLAUDE.md", "guardrail", "policy as code", "governance as code",
			"blast radius", "contenção", "sandbox", "rollback",
			"auditoria", "audit trail", "rastreabilidade",
			"onboarding de agente", "capability", "expansão de autonomia",
			"supervisão", "oversight", "confiança", "verificação",
		]
		excludeWhen: [
			"a decisão é sobre se uma tarefa é delegável ou não — usar organizational-resource-allocation (ora-delegation-fitness)",
			"a decisão é sobre custos de agência e alinhamento de incentivos em delegação organizacional genérica — usar organizational-economics",
			"a decisão é sobre design de incentivos entre participantes da plataforma — usar mechanism-design",
			"a decisão é sobre alocação de recursos entre tarefas de agentes — usar organizational-resource-allocation",
			"a decisão é sobre arquitetura de deploy e CI/CD de software — escopo de engenharia, não governance",
		]
		rationale: "Toda organização AI-native opera agentes de IA como infraestrutura produtiva. Agentes executam tarefas, tomam decisões dentro de limites, e produzem outputs que afetam a organização e seus clientes. Sem governance explícita, a organização não sabe o que o agente pode decidir, quando deve escalar, como detectar desvio, nem como reconstruir decisões ex post. Governance de agentes é o complemento operacional da delegação: ORA decide o que delegar; esta lens governa o agente após a delegação."
	}

	concepts: [
		{
			id:            "aag-autonomy-boundary"
			name:          "Fronteira de Autonomia: O Que o Agente Decide Sozinho"
			nature:        "operational"
			role:          "framework"
			reviewCadence: "monthly"
			definition:    "Sheridan/Verplank (1978): escala de automação de 10 níveis, desde 'humano faz tudo' até 'máquina faz tudo sem informar'. Parasuraman/Sheridan/Wickens (2000, 'A Model for Types and Levels of Human Interaction with Automation'): o nível ótimo de automação varia por função — aquisição de informação, análise, decisão, execução — e cada função pode ter nível diferente. Shneiderman (2022, Human-Centered AI): confiabilidade e segurança exigem fronteiras de autonomia explícitas, não implícitas. A fronteira não é binária (autônomo vs não-autônomo) — é um espectro por tipo de tarefa e por consequência."
			meshManifestation: "Na Mesh, agentes IA operam em múltiplas funções: validação de documentos, cálculo de scoring, geração de código, análise de compliance, propostas de antecipação. Cada função tem nível de autonomia diferente. Agente que valida formato de documento (consequência baixa, reversível) opera no nível 9-10 de Sheridan. Agente que propõe recalibração de scoring (consequência séria, parcialmente irreversível) opera no nível 5-6 — analisa e propõe, humano aprova. Sem fronteira explícita: agente ou opera com medo (escala tudo, consome o constraint — horas do founder) ou com excesso (decide o que não deveria, gera risco)."
			meshImplication: "Para cada capability do agente, declarar nível de autonomia usando escala simplificada: (1) agente executa e loga — humano audita em batch (tipo 4). (2) agente analisa e propõe — humano aprova antes de execução (tipo 3). (3) agente coleta informação — humano analisa e decide (tipo 2). (4) humano faz tudo — agente não participa (tipo 1). Fronteira codificada no CLAUDE.md e/ou CUE schema da capability — não verbal, não implícita. Revisão mensal: alguma capability pode subir de nível dado track record? Alguma deve descer dado incidente? Fronteira é dinâmica, não estática — o que muda é o critério (track record, blast radius, maturidade do mecanismo de drift detection)."
			crossDependsOn: [
				{
					lensId:    "lens-organizational-resource-allocation"
					conceptId: "ora-delegation-fitness"
					context:   "ORA decide se uma tarefa é delegável (2×2: informação × consequência). AAG define os limites operacionais após a delegação ser decidida — em que nível de autonomia o agente opera para aquela tarefa. ORA é a decisão de delegar; AAG é a implementação da delegação."
				},
				{
					lensId:    "lens-organizational-resource-allocation"
					conceptId: "ora-reversibility-indexed-speed"
					context:   "ORA indexa velocidade de decisão à reversibilidade. AAG usa reversibilidade como critério para definir nível de autonomia — tarefas reversíveis permitem autonomia maior."
				},
			]
			rationale: "Sheridan/Verplank 1978 + Parasuraman et al. 2000: autonomia é espectro, não binário, e varia por função. Na Mesh AI-native, a fronteira de autonomia é a política mais consequente — governa onde o agente para e onde o humano começa."
		},
		{
			id:            "aag-escalation-protocol"
			name:          "Protocolo de Escalation: Quando e Como o Agente Escala"
			nature:        "operational"
			role:          "method"
			reviewCadence: "monthly"
			definition:    "Reason (1997, Managing the Risks of Organizational Accidents): defesas em profundidade — múltiplas barreiras independentes entre falha e dano. Cada barreira tem probabilidade de falha; a segurança do sistema depende de nenhuma falha alinhar todas as barreiras simultaneamente (modelo 'queijo suíço'). Em agentes IA, o protocolo de escalation é a barreira entre decisão do agente e consequência irreversível. Rasmussen (1997): sistemas migram naturalmente para fronteiras de operação insegura sob pressão de eficiência — sem escalation explícito, agentes otimizam velocidade sacrificando segurança."
			meshManifestation: "Na Mesh, escalation ocorre quando: (a) agente encontra situação fora da fronteira de autonomia definida, (b) agente detecta anomalia que não sabe classificar, (c) output do agente viola constraint codificado (ex: proposta de antecipação excede limite de concentração), (d) agente identifica conflito entre duas políticas. Sem protocolo: agente ou trava (espera indefinidamente) ou improvisa (decide fora da fronteira). Ambos são modos de falha. Escalation deve ser rápido (não bloquear pipeline), informativo (humano recebe contexto, não apenas alert), e rastreável (log de por que escalou)."
			meshImplication: "Para cada capability com autonomia nível 1-2 (agente executa ou propõe): definir condições de escalation explícitas. Formato: SE [condição] ENTÃO escalar com [contexto mínimo] via [canal]. Condições típicas: valor excede threshold, score fora do intervalo esperado, documento com anomalia não-classificável, conflito de política, dependência externa indisponível. Canal: para tipo 3 (proposta): fila de batch review. Para tipo 2+ (urgente): interrupção direta. Contexto mínimo obrigatório: o que o agente estava fazendo, o que disparou a escalation, qual a recomendação do agente (se aplicável), e qual o custo de atraso de esperar. Anti-pattern: escalation sem contexto ('preciso de aprovação') — consome atenção do founder sem informação."
			dependsOn: ["aag-autonomy-boundary"]
			rationale: "Reason 1997: defesa em profundidade. Rasmussen 1997: migração para fronteira insegura. Escalation é a barreira que previne que autonomia do agente ultrapasse a fronteira sem supervisão."
		},
		{
			id:            "aag-observability-contract"
			name:          "Contrato de Observabilidade: O Que o Agente Deve Tornar Visível"
			nature:        "operational"
			role:          "framework"
			reviewCadence: "quarterly"
			definition:    "Sridharan (2018, Distributed Systems Observability): observabilidade é a capacidade de inferir o estado interno de um sistema a partir dos seus outputs externos — logs, métricas, traces. Diferente de monitoramento (verificar se métrica pré-definida está ok), observabilidade permite diagnosticar problemas não-antecipados. Majors/Fong-Jones/Miranda (2022, Observability Engineering): um sistema é observável quando é possível responder qualquer pergunta sobre seu comportamento sem precisar deployar novo código. Em agentes IA, observabilidade inclui não apenas métricas operacionais mas raciocínio — por que o agente tomou aquela decisão."
			meshManifestation: "Na Mesh AI-native, observabilidade de agentes tem três camadas: (1) operacional — task executada, duração, sucesso/falha, recursos consumidos. (2) decisional — qual decisão o agente tomou, quais alternativas considerou, que inputs usou, que policy aplicou. (3) contextual — estado do sistema no momento da decisão, versão do CLAUDE.md, versão do schema CUE. Sem camada decisional: o humano sabe que o agente fez algo, mas não por que — impossível detectar drift ou auditar. Sem camada contextual: impossível reproduzir a decisão para diagnóstico."
			meshImplication: "Para cada capability do agente, definir contrato de observabilidade: quais campos são obrigatórios em cada log. Mínimo universal: timestamp, capability_id, action, input_summary, output_summary, policy_version, decision_rationale, escalation_flag. Para capabilities de alto impacto (scoring, antecipação): adicionar alternatives_considered, confidence_level, data_sources_used. Granularidade: tipo 4 (agente decide) — log resumido, auditoria por amostragem. Tipo 3 (agente propõe) — log completo, revisão do founder na aprovação. Storage: logs imutáveis, retenção mínima conforme regulação (Bacen exige rastreabilidade). Anti-pattern: logging excessivo sem consumo — gera custo sem valor. Regra: todo campo logado deve ter pelo menos um consumidor definido (quem lê e por quê)."
			dependsOn: ["aag-autonomy-boundary"]
			rationale: "Sridharan 2018: observabilidade ≠ monitoramento — é capacidade de diagnosticar o não-antecipado. Majors et al. 2022: responder qualquer pergunta sem deploy. Em agentes IA, o 'estado interno' inclui raciocínio, não apenas métricas."
		},
		{
			id:         "aag-drift-detection"
			name:       "Detecção de Drift: Quando o Agente Diverge do Esperado"
			nature:     "theoretical"
			role:       "method"
			definition: "Sculley et al. (2015, 'Hidden Technical Debt in Machine Learning Systems'): sistemas ML degradam silenciosamente — data drift (distribuição dos inputs muda), concept drift (relação input-output muda), e feedback loops (outputs do sistema alteram os inputs futuros). Klaise et al. (2020): drift detection requer baseline definido, métrica de divergência, e threshold de alerta. Em agentes IA não-ML (LLM-based), drift se manifesta como: policy drift (agente interpreta policy de forma que diverge gradualmente da intenção), output drift (qualidade ou padrão dos outputs muda sem causa aparente), e context drift (estado do sistema muda de forma que invalida premissas da policy)."
			meshManifestation: "Na Mesh, drift de agentes pode se manifestar como: (1) scoring drift — modelo de scoring produz distribuição de scores diferente da esperada sem mudança explícita (data drift nos inputs de construtoras). (2) policy drift — agente interpreta 'documentação completa' de forma cada vez mais frouxa, aprovando documentos que antes seriam escalados. (3) output drift — qualidade das análises de compliance degrada porque template implícito do agente divergiu do template canônico. (4) context drift — premissa 'mercado opera com coobrigação' muda, mas policy do agente não foi atualizada. Drift é silencioso — sem detecção ativa, só aparece quando causa dano."
			meshImplication: "Para cada capability crítica (scoring, compliance, antecipação), definir: (1) baseline — distribuição esperada de outputs (ex: scores entre 40-90, mediana ~65). (2) métrica de divergência — KL divergence, PSI, ou simplesmente % de outputs fora do intervalo esperado. (3) threshold de alerta — quando divergência dispara revisão. (4) cadência de verificação — diária para scoring, semanal para compliance, mensal para análises. Para policy drift em agentes LLM: comparar outputs do agente com outputs de referência (mesma tarefa, mesmo input, comparar com gold standard). Se divergência > threshold: flag + revisão do CLAUDE.md. Para context drift: lista de premissas da policy com data de última verificação — se premissa não verificada há > 90 dias, flag."
			dependsOn: ["aag-observability-contract"]
			crossDependsOn: [{
				lensId:    "lens-credit-risk"
				conceptId: "cr-model-monitoring"
				context:   "CR modela drift especificamente no contexto de modelos de risco de crédito — data drift, concept drift, AUROC degradation. AAG generaliza drift detection para qualquer capability de agente, não apenas scoring. CR provê métodos específicos (PSI, Cramér-von Mises); AAG provê o framework organizacional de quando e como verificar."
			}]
			rationale: "Sculley et al. 2015: ML systems degrade silently. Klaise et al. 2020: detection requer baseline + métrica + threshold. Na Mesh AI-native, drift detection é o mecanismo que previne degradação silenciosa de todo o sistema operacional."
		},
		{
			id:            "aag-governance-as-code"
			name:          "Governance as Code: Políticas Codificadas, Não Implícitas"
			nature:        "operational"
			role:          "framework"
			reviewCadence: "quarterly"
			definition:    "Morris (2016, Infrastructure as Code): infraestrutura gerenciada por código versionável, testável e auditável é superior a infraestrutura gerenciada por processos manuais — reduz erro, aumenta reprodutibilidade, e permite revisão por pares. Aplicando a governance: policies codificadas em artefatos versionáveis (CUE schemas, CLAUDE.md, config files) são superiores a policies verbais ou em documentos não-versionados — porque são testáveis por CI, auditáveis por diff, e inequívocas para o agente. Humble/Farley (2010, Continuous Delivery): tudo que governa comportamento do sistema deve estar sob version control."
			meshManifestation: "Na Mesh, governance as code se materializa em: (1) CLAUDE.md — instruções canônicas para agentes, versionadas no repositório. (2) CUE schemas — contratos de tipo, validação e constraint que agentes respeitam por design. (3) precedence-hierarchy.cue — classificação de decisões codificada, não verbal. (4) design-principles.cue — axiomas e princípios referenciáveis por ID. (5) analytical-lens.cue — schema que governa como agentes raciocinam. Tudo versionado em Git. Se uma policy existe apenas na cabeça do founder ou num documento não-versionado: para o agente, não existe."
			meshImplication: "Regra: toda policy que governa comportamento de agente deve existir como artefato versionado no mesh-spec. Se a policy não está no repositório, o agente não é obrigado a seguí-la — e não deve ser penalizado por não seguir. Consequências: (1) novas policies passam por review (pull request), não são adicionadas ad hoc. (2) mudanças em policies geram diff auditável — quem mudou, quando, por quê. (3) CI valida consistência — policy referencia principleId que não existe? CI falha. Schema muda e quebra instância existente? CI falha. (4) agente pode referenciar a versão exata da policy que seguiu em cada decisão (observability contract). Anti-pattern: policy verbal contradiz policy codificada — a codificada prevalece. Se a verbal é correta: codificar antes de enforçar."
			dependsOn: ["aag-autonomy-boundary"]
			rationale: "Morris 2016: code > manual. Humble/Farley 2010: tudo sob version control. Na Mesh, o mesh-spec é o sistema nervoso central — se a policy não está lá, não governa."
		},
		{
			id:         "aag-blast-radius-containment"
			name:       "Contenção de Blast Radius: Limitar Dano Máximo Antes de Intervenção"
			nature:     "theoretical"
			role:       "property"
			definition: "Perrow (1984, Normal Accidents): sistemas tightly-coupled propagam falhas rapidamente — uma falha local se torna sistêmica antes que operadores possam intervir. Leveson (2011, Engineering a Safer World — STAMP): segurança é propriedade emergente do sistema, não ausência de falha de componente. Controle requer constraints que limitem o espaço de estados alcançáveis pelo sistema. Em agentes IA: blast radius é o dano máximo que o agente pode causar entre a ação e a detecção/intervenção. Contenção reduz blast radius por design — não por esperança de que o agente não erre."
			meshManifestation: "Na Mesh, blast radius varia por capability: (1) agente que formata relatório — blast radius mínimo (output errado é detectado na revisão, custo: retrabalho de horas). (2) agente que aprova antecipação — blast radius significativo (dinheiro transferido, reversão cara ou impossível). (3) agente que altera schema CUE em produção — blast radius sistêmico (todas as validações downstream afetadas). Sem contenção: agente com bug na lógica de scoring pode aprovar 50 antecipações antes de detecção. Com contenção: limite de 5 aprovações sem batch review, cap de R$200k por janela de 24h."
			meshImplication: "Para cada capability, definir: (1) blast radius máximo aceitável — em R$, em número de operações, em escopo de sistema afetado. (2) mecanismo de contenção — caps (valor máximo por operação, por janela de tempo), sandboxing (agente opera em ambiente isolado até validação), staged rollout (nova capability em 10% do volume antes de 100%), circuit breaker (se taxa de erro > threshold, capability suspensa automaticamente). (3) tempo de detecção — quanto tempo até que humano perceba. Blast radius real ≈ taxa de erro × volume por unidade de tempo × tempo de detecção. Reduzir qualquer fator reduz blast radius. Regra: capability nova sempre inicia com blast radius mínimo (low cap, sandbox, staged) e expande com track record."
			dependsOn: ["aag-autonomy-boundary", "aag-drift-detection"]
			rationale: "Perrow 1984: sistemas tightly-coupled propagam falhas. Leveson 2011: segurança por constraints, não por esperança. Na Mesh, contenção de blast radius é o que torna delegação ao agente segura — não é confiança no agente, é design do sistema."
		},
		{
			id:            "aag-agent-capability-lifecycle"
			name:          "Ciclo de Vida de Capability do Agente"
			nature:        "operational"
			role:          "method"
			reviewCadence: "quarterly"
			definition:    "Analogia com Deming (1986, Out of the Crisis — PDCA): Plan-Do-Check-Act como ciclo de melhoria contínua. Em capabilities de agentes: (1) Onboarding — definir capability, fronteira de autonomia, observability contract, blast radius. (2) Validação — operar com supervisão intensiva, humano verifica outputs, corrigir policy. (3) Expansão — com track record positivo, expandir autonomia, reduzir supervisão, aumentar cap. (4) Maturidade — operação estável com auditoria por amostragem. (5) Deprecação — capability obsoleta, substituída ou removida. O ciclo é unidirecional ascendente com track record, mas pode regredir se drift ou incidente detectado."
			meshManifestation: "Na Mesh: nova capability 'agente valida compliance de fornecedor' passa por: (1) Onboarding — policy codificada no CLAUDE.md, schema de output definido, blast radius = 0 (apenas recomenda, humano executa). (2) Validação (2-4 semanas) — agente analisa 50 fornecedores, humano compara com avaliação própria, taxa de concordância medida. (3) Expansão — se concordância >95%: agente valida autonomamente fornecedores de baixo risco (blast radius = fornecedor individual). (4) Maturidade — agente valida todos exceto categorias de alto risco, auditoria semanal por amostragem. (5) Deprecação — quando novo mecanismo de validação substitui (ex: scoring automatizado com dados reais substitui checklist manual)."
			meshImplication: "Toda capability nova inicia no estágio Onboarding — nunca em Maturidade. Critérios de promoção entre estágios devem ser definidos ex ante (não ad hoc): taxa de concordância, taxa de erro, blast radius realizado, feedback do humano. Critérios de regressão: incidente que cause dano > threshold, drift detectado acima do limite, mudança de contexto que invalida premissas da policy. Registro: cada capability tem status atual (onboarding/validação/expansão/maturidade/deprecated), data de última promoção, critério para próxima promoção. Anti-pattern: capability que fica em 'validação' indefinidamente sem critério de promoção — consome supervisão sem liberar constraint."
			dependsOn: ["aag-autonomy-boundary", "aag-blast-radius-containment", "aag-drift-detection"]
			rationale: "Deming 1986: PDCA como ciclo de melhoria. Capability lifecycle é PDCA aplicado à delegação de agentes — expansão gradual com evidência, não com esperança."
		},
		{
			id:            "aag-audit-trail"
			name:          "Trilha de Auditoria: Reconstruir Qualquer Decisão Ex Post"
			nature:        "operational"
			role:          "property"
			reviewCadence: "quarterly"
			definition:    "Power (1997, The Audit Society): auditabilidade é precondição de accountability — sem capacidade de reconstruir o que aconteceu, não há responsabilização. Em regulação financeira (Bacen, CVM): rastreabilidade de decisões é obrigatória, não opcional. Em agentes IA: audit trail deve permitir responder, para qualquer ação: quem (qual agente), o que (qual ação), quando (timestamp), por que (qual policy, qual input, qual raciocínio), com que autoridade (qual nível de autonomia), e com que resultado (output, consequência observada)."
			meshManifestation: "Na Mesh como intermediário financeiro, audit trail não é nice-to-have — é requisito regulatório. Cada antecipação aprovada (por agente ou humano) precisa de trilha completa: solicitação original, dados do fornecedor, score do comprador, policy de aprovação vigente, decisão (aprovado/rejeitado/escalado), quem/o que decidiu, e timestamp. Para operações regulatórias (reporte ao Bacen, lastro de FIDC), a trilha deve ser reconstruível por terceiros (auditor, regulador), não apenas pelo founder."
			meshImplication: "Audit trail implementado como log imutável (append-only). Campos obrigatórios definidos no observability contract por capability. Para capabilities financeiras: retenção mínima de 5 anos (regulação Bacen). Para capabilities operacionais: retenção mínima de 1 ano. Imutabilidade: log não pode ser editado após escrita — correções são novos registros que referenciam o original. Acessibilidade: audit trail deve ser consultável por query (não apenas arquivo bruto) — para responder perguntas tipo 'todas as antecipações aprovadas por agente no mês X com valor > Y'. Teste de auditoria: trimestralmente, selecionar 10 decisões aleatórias e reconstruir completamente a partir do audit trail. Se reconstrução falha: observability contract está incompleto."
			dependsOn: ["aag-observability-contract"]
			crossDependsOn: [{
				lensId:    "lens-regulatory-strategy"
				conceptId: "rs-regulatory-documentation"
				context:   "RS identifica quais requisitos regulatórios exigem rastreabilidade e em que formato. AAG implementa a trilha de auditoria que satisfaz esses requisitos. RS diz 'Bacen exige rastreabilidade de operações de crédito'; AAG define os campos, retenção e formato que implementam esse requisito."
			}]
			rationale: "Power 1997: auditabilidade é precondição de accountability. Na Mesh como intermediário financeiro, audit trail é requisito regulatório e pré-condição de confiança — tanto para regulador quanto para participantes da plataforma."
		},
		{
			id:            "aag-hitl-calibration"
			name:          "Calibração Human-in-the-Loop: Supervisão Proporcional à Maturidade e Consequência"
			nature:        "operational"
			role:          "heuristic"
			reviewCadence: "monthly"
			definition:    "Parasuraman/Riley (1997): automation complacency — humanos supervisionando sistemas automatizados degradam vigilância ao longo do tempo, especialmente quando o sistema raramente falha. Bainbridge (1983, 'Ironies of Automation'): quanto mais confiável o sistema, menos preparado o humano para intervir quando falha. O paradoxo: supervisão intensa demais consome o constraint humano sem ganho marginal; supervisão frouxa demais permite falhas que a supervisão deveria prevenir. A calibração ótima depende de: maturidade do agente (track record), consequência da tarefa, e custo da supervisão."
			meshManifestation: "Na Mesh: founder que revisa 100% dos outputs de agente em Onboarding está calibrado corretamente. Founder que continua revisando 100% após 500 execuções sem erro está em automation complacency inversa — gasta constraint sem ganho. Founder que para de revisar após 10 execuções sem erro em capability de alta consequência está em automation complacency direta — confia prematuramente. O cost of supervision é real: cada hora de revisão é hora não investida em validação de demanda, funding, ou arquitetura."
			meshImplication: "Regime de supervisão por estágio de lifecycle: (1) Onboarding: 100% revisão (humano verifica todo output). (2) Validação: 100% revisão com métricas de concordância. (3) Expansão: amostragem — revisar X% dos outputs (X diminui com track record, mínimo 10% para capability de alta consequência, mínimo 5% para baixa consequência). (4) Maturidade: auditoria periódica (semanal ou mensal) + circuit breaker automático. Fórmula heurística para X%: consequência_relativa / (1 + log(execuções_sem_erro)). Consequência alta + poucas execuções → revisão alta. Consequência baixa + muitas execuções → revisão baixa. Anti-pattern: supervisão fixa independente de track record — ou gasta demais no início ou de menos no final."
			dependsOn: ["aag-autonomy-boundary", "aag-agent-capability-lifecycle"]
			crossDependsOn: [{
				lensId:    "lens-organizational-resource-allocation"
				conceptId: "ora-throughput-constraint"
				context:   "ORA identifica que horas do founder são o constraint. AAG calibra supervisão para consumir o mínimo de constraint necessário dado a maturidade do agente. Supervisão excessiva desperdiça constraint; supervisão insuficiente gera risco. A calibração é decisão de alocação de atenção — ORA diz 'atenção é escassa'; AAG diz 'quanto de atenção alocar a supervisão dado track record'."
			}]
			rationale: "Parasuraman/Riley 1997: automation complacency. Bainbridge 1983: ironia da automação. Na Mesh, calibração de supervisão é trade-off entre risco (sub-supervisão) e desperdício de constraint (super-supervisão). A heurística deve evoluir com dados."
		},
		{
			id:         "aag-continuous-alignment-verification"
			name:       "Verificação Contínua de Alinhamento"
			nature:     "theoretical"
			role:       "method"
			definition: "Russell (2019, Human Compatible): alinhamento de IA não é propriedade que se configura uma vez — é propriedade que se verifica continuamente porque o ambiente muda, os objetivos mudam, e o comportamento do agente pode divergir. Amodei et al. (2016, 'Concrete Problems in AI Safety'): cinco problemas práticos — reward hacking, distributional shift, scalable oversight, safe exploration, side effects. Em agentes operacionais: alinhamento significa que o agente continua otimizando para o objetivo organizacional correto, não para um proxy que divergiu do objetivo real."
			meshManifestation: "Na Mesh, desalinhamento pode ser sutil: (1) agente de scoring otimiza para AUROC (métrica) em vez de para qualidade de carteira (objetivo real) — produz score alto para operações que parecem boas no modelo mas têm risco oculto. (2) agente de compliance otimiza para throughput (aprovar rápido) em vez de para qualidade de validação — aprova documentos com deficiências menores que se acumulam. (3) agente de código otimiza para quantidade de commits em vez de para qualidade de arquitetura — gera débito técnico. Cada caso: métrica proxy diverge do objetivo real. O agente não 'sabe' que divergiu — o humano precisa verificar."
			meshImplication: "Para cada capability: definir (1) objetivo real (ex: qualidade de carteira, qualidade de validação, qualidade de arquitetura) e (2) métricas proxy que o agente usa (AUROC, throughput, commits). Verificação periódica: as métricas proxy ainda correlacionam com o objetivo real? Se proxy melhora mas objetivo real degrada: desalinhamento detectado — recalibrar. Mecanismo: amostragem de outputs com avaliação humana contra o objetivo real (não contra a métrica proxy). Cadência: mensal para capabilities críticas, trimestral para demais. Goodhart's Law ('quando uma medida se torna alvo, deixa de ser boa medida') aplica-se diretamente — por isso a verificação compara objetivo real, não métrica."
			dependsOn: ["aag-drift-detection", "aag-observability-contract"]
			rationale: "Russell 2019: alinhamento é verificação contínua, não configuração única. Amodei et al. 2016: problemas concretos de safety são operacionais. Na Mesh, Goodhart's Law é o risco primário — proxy ≠ objetivo, e a divergência é silenciosa."
		},
		{
			id:            "aag-governance-review"
			name:          "Revisão de Governance: Inventário Periódico de Agentes e Políticas"
			nature:        "operational"
			role:          "method"
			reviewCadence: "quarterly"
			definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) mapa de capabilities ativas com nível de autonomia e estágio de lifecycle, (2) incidentes e escalations no período com análise de causa raiz, (3) drift detectado e ações tomadas, (4) mudanças em policies codificadas (diff do mesh-spec), (5) calibração de supervisão — % de revisão por capability e se está adequado ao track record, (6) blast radius realizado vs caps definidos, (7) audit trail testado — reconstrução bem-sucedida?, (8) alinhamento verificado — proxy vs objetivo real."
			meshManifestation: "Na Mesh: revisão trimestral formal. Semanal: micro-revisão (escalations pendentes, circuit breakers disparados, alertas de drift). Mensal: meso-revisão (calibração HITL, promoções de lifecycle, drift patterns). Trimestral: macro-revisão com inventário completo."
			meshImplication: "Semanal (15min): resolver escalations pendentes, verificar circuit breakers, revisar alertas de drift. Mensal (1h): capability X pode ser promovida de Validação para Expansão? Supervisão de capability Y pode reduzir de 50% para 20%? Drift detectado em alguma capability? Trimestral (2h): inventário completo. Todas as capabilities estão mapeadas? Policies no mesh-spec estão atualizadas? Premissas de policies foram verificadas? Audit trail testado com amostra aleatória? Se a revisão não produz pelo menos uma mudança (promoção, recalibração, policy update): ou o sistema está perfeito (improvável) ou a revisão é superficial."
			dependsOn: ["aag-autonomy-boundary", "aag-drift-detection", "aag-hitl-calibration", "aag-agent-capability-lifecycle", "aag-audit-trail"]
			rationale: "Sem revisão periódica, governance é documento estático, não prática viva. O inventário periódico fecha o loop entre policy codificada e operação real."
		},
	]

	reasoningProtocol: [
		{
			question:  "Qual capability do agente está em questão? Ela tem fronteira de autonomia explícita e codificada?"
			reveals:   "Se a capability opera com limites claros ou com autonomia implícita/ambígua. Sem fronteira codificada: governance não existe para essa capability."
			rationale: "Sheridan/Verplank 1978: autonomia é espectro por função. Fronteira codificada é pré-condição de tudo que segue."
		},
		{
			question:  "Qual é o nível de autonomia atual? O agente executa e loga, propõe e aguarda, coleta informação, ou não participa?"
			reveals:   "Se o nível é adequado ao estágio de lifecycle e ao track record. Autonomia alta com track record curto é risco; autonomia baixa com track record longo é desperdício de constraint."
			rationale: "Parasuraman et al. 2000: nível ótimo varia por função e maturidade. Calibrar é melhor que fixar."
		},
		{
			question:  "Quais são as condições de escalation? O agente sabe quando parar e escalar, e o humano recebe contexto suficiente?"
			reveals:   "Se o protocolo de escalation é funcional ou se é escalation sem informação (consome atenção sem valor) ou ausência de escalation (risco)."
			rationale: "Reason 1997: defesa em profundidade. Escalation sem contexto é barreira furada."
		},
		{
			question:  "O contrato de observabilidade está definido? É possível reconstruir o raciocínio do agente para qualquer decisão passada?"
			reveals:   "Se auditoria é possível. Sem observabilidade: impossível detectar drift, verificar alinhamento, ou satisfazer regulador."
			rationale: "Sridharan 2018: observabilidade é capacidade de diagnosticar o não-antecipado. Audit trail depende de observabilidade."
		},
		{
			question:  "Existe mecanismo de drift detection ativo? Baseline definido, métrica de divergência, threshold de alerta?"
			reveals:   "Se degradação silenciosa seria detectada antes de causar dano material."
			rationale: "Sculley et al. 2015: ML systems degrade silently. Detecção ativa é a única defesa."
		},
		{
			question:  "A policy que governa essa capability está codificada no mesh-spec (CLAUDE.md, CUE schema, config)?"
			reveals:   "Se a policy é auditável, versionável e inequívoca para o agente — ou se é verbal/implícita."
			rationale: "Morris 2016: code > manual. Policy não-codificada é policy não-existente para o agente."
		},
		{
			question:  "Qual é o blast radius máximo dessa capability? Qual o dano máximo entre ação do agente e detecção/intervenção?"
			reveals:   "Se contenção é adequada. Blast radius = taxa de erro × volume × tempo de detecção. Cada fator é reduzível."
			rationale: "Perrow 1984: tight coupling propaga falhas. Leveson 2011: segurança por constraints. Contenção reduz blast radius por design."
		},
		{
			question:  "Em que estágio do lifecycle está essa capability? Onboarding, validação, expansão, maturidade?"
			reveals:   "Se supervisão e caps estão calibrados ao estágio — e se existem critérios de promoção definidos."
			rationale: "Deming 1986: PDCA. Expansion sem track record é risco; validação indefinida é desperdício."
		},
		{
			question:  "A calibração de supervisão (HITL) é proporcional à maturidade do agente e à consequência da tarefa?"
			reveals:   "Se constraint humano está sendo gasto proporcionalmente ao risco — nem demais (desperdício) nem de menos (risco)."
			appliesWhen: "capability já ultrapassou estágio de onboarding"
			rationale: "Parasuraman/Riley 1997: automation complacency em ambas as direções. Calibração dinâmica supera supervisão fixa."
		},
		{
			question:  "As métricas proxy que o agente otimiza ainda correlacionam com o objetivo real? Goodhart's Law está operando?"
			reveals:   "Se o agente está alinhado com o objetivo organizacional ou com um proxy que divergiu."
			appliesWhen: "capability em estágio de expansão ou maturidade com métricas estabelecidas"
			rationale: "Russell 2019: alinhamento é verificação contínua. Goodhart: proxy ≠ objetivo quando proxy vira alvo."
		},
		{
			question:  "A trilha de auditoria permite reconstruir completamente as decisões do agente? Um auditor externo conseguiria?"
			reveals:   "Se accountability é real ou nominal. Regulador (Bacen) exige trilha reconstruível por terceiros."
			rationale: "Power 1997: auditabilidade é precondição de accountability. Na Mesh como intermediário financeiro, é requisito regulatório."
		},
	]

	meshExamples: [
		{
			id:       "ex-scoring-capability-lifecycle"
			scenario: "Mesh implementa agente de scoring de compradores para antecipação de recebíveis. Modelo treinado com dados iniciais, AUROC 0.72. Agente deve calcular score para cada proposta de antecipação."
			analysis: "Capability nova, consequência alta (score governa decisão de crédito), blast radius significativo (score errado → antecipação de recebível com risco subestimado). Lifecycle: iniciar em Onboarding. Fronteira de autonomia: nível 2 (agente calcula e propõe, humano aprova). Observability: log completo (inputs, features, score, confidence, model version). Drift detection: baseline de distribuição de scores (mediana ~65, range 40-90), PSI semanal. Blast radius: cap de R$50k por operação, cap de R$500k por semana sem batch review."
			recommendation: "Onboarding (semanas 1-4): agente calcula score para todas as propostas, humano verifica 100% e compara com avaliação própria. Critério de promoção para Validação: concordância >90% em 50 propostas. Validação (semanas 5-12): agente propõe aprovação/rejeição com score, humano aprova. Métrica: taxa de override <10%. Critério para Expansão: override <5% em 100 propostas + zero incidentes. Expansão: agente aprova autonomamente se score >75 E valor <R$50k E concentração ok. Humano aprova exceções. Supervisão: 20% amostragem. Maturidade: auditoria semanal + drift detection + circuit breaker (se PSI >0.25 em janela de 7 dias, suspender autonomia)."
			principlesApplied: ["ax-05", "ax-06", "dp-01", "dp-05"]
			assumptions: [
				"AUROC 0.72 é suficiente para iniciar lifecycle — verificar com benchmark do segmento",
				"50 propostas é volume suficiente para validar concordância — pode ser insuficiente se distribuição de perfis é concentrada",
				"PSI >0.25 como threshold de drift é adequado para este segmento — calibrar com dados",
				"R$50k como cap por operação é conservador dado ticket médio esperado",
			]
			rationale: "Lifecycle de scoring é caso paradigmático: consequência alta (crédito), drift provável (data evolui), regulação exige trilha. Promoção gradual com critérios ex ante evita dois modos de falha: autonomia prematura e supervisão indefinida."
		},
		{
			id:       "ex-policy-drift-detection"
			scenario: "Agente de compliance valida documentação de fornecedores há 3 meses em estágio de Expansão. Humano nota que últimas 20 validações aprovaram fornecedores com CNDs vencidas há <30 dias — antes, agente escalava esses casos."
			analysis: "Policy drift: agente gradualmente expandiu interpretação de 'documentação válida' para incluir CNDs com vencimento recente. Causa provável: prompt ou CLAUDE.md não explicita threshold de vencimento (ex: CND vencida há >0 dias = inválida), e agente aplicou julgamento 'razoável' de que 30 dias é marginal. Blast radius: 20 fornecedores aprovados com CND vencida — risco de compliance real, potencialmente remediável (solicitar atualização). Drift detection: baseline de taxa de escalation era ~15%, caiu para ~5% sem mudança de policy — deveria ter disparado alerta."
			recommendation: "(1) Remediar: revisar 20 fornecedores aprovados, solicitar CNDs atualizadas, suspender qualificação até regularização. (2) Codificar: adicionar ao CLAUDE.md/policy explícita — 'CND com data de vencimento anterior a hoje = inválida, escalar'. Sem exceção. (3) Drift detection: adicionar monitoramento de taxa de escalation — se desvio >50% da baseline sem mudança de policy, flag automático. (4) Regredir lifecycle: capability volta de Expansão para Validação por 2 semanas — humano revisa 100% até confirmar que policy atualizada corrigiu drift. Critério de re-promoção: 0 CNDs vencidas aprovadas em 50 validações."
			principlesApplied: ["ax-01", "ax-05", "dp-01"]
			assumptions: [
				"20 fornecedores afetados é número real — verificar com query no audit trail",
				"CNDs podem ser atualizadas retroativamente sem suspensão de operação",
				"drift foi causado por ambiguidade na policy, não por mudança no modelo do agente",
			]
			rationale: "Policy drift é modo de falha silencioso — agente não viola policy explícita, mas expande interpretação da ambiguidade. A solução é eliminar ambiguidade (governance as code) + detectar drift (taxa de escalation como proxy). Regressão de lifecycle é proporcional ao dano."
		},
		{
			id:       "ex-hitl-calibration-reduction"
			scenario: "Founder revisa 100% dos outputs do agente de geração de relatórios de operação (capability em Maturidade há 4 meses, 200 relatórios gerados, 0 erros materiais). Revisão consome ~3h/semana."
			analysis: "Supervisão desproporcional ao track record. 200 execuções sem erro material em capability de consequência moderada (relatório interno, não decisão de crédito). 3h/semana é ~6% do constraint do founder alocado a revisar output com taxa de erro 0%. Automation complacency inversa: founder mantém supervisão alta por inércia, não por risco proporcional. Custo de oportunidade: 3h/semana × 4 meses = ~48h que poderiam ter sido alocadas a atividade de maior CoD."
			recommendation: "Reduzir supervisão de 100% para 10% (amostragem aleatória de ~2 relatórios por semana em vez de ~20). Economia: ~2.5h/semana devolvidas ao constraint. Salvaguardas mantidas: (1) amostragem detecta degradação em ~2 semanas (vs detectar imediatamente com 100%). (2) drift detection: monitorar comprimento médio, estrutura e completude de relatórios — desvio >2σ da baseline dispara flag. (3) circuit breaker: se amostragem encontra erro material, regredir para 50% por 2 semanas. Critério de redução adicional (10%→5%): 100 relatórios adicionais sem erro na amostragem."
			principlesApplied: ["ax-06", "dp-01", "dp-05"]
			assumptions: [
				"0 erros materiais em 200 relatórios é evidência suficiente — pode haver erros não-detectados em dimensões não revisadas",
				"relatórios são de consequência moderada — se algum relatório vai para regulador, manter supervisão mais alta para esse subset",
				"drift detection por métricas de output (comprimento, estrutura) é proxy razoável para qualidade",
			]
			rationale: "Parasuraman/Riley 1997: supervisão ótima não é máxima. 3h/semana em capability com taxa de erro 0% é alocação sub-ótima do constraint. Reduzir com salvaguardas (amostragem + drift detection + circuit breaker) é superior a manter por inércia."
		},
		{
			id:       "ex-blast-radius-new-capability"
			scenario: "Mesh quer deployar nova capability: agente que envia notificações automáticas a fornecedores sobre status de antecipação (aprovada, em análise, rejeitada). Volume esperado: 50-100 notificações/dia."
			analysis: "Blast radius potencial: notificação incorreta (ex: 'aprovada' quando na verdade 'em análise') afeta confiança do fornecedor na plataforma. 100 notificações erradas em 1 dia = dano reputacional significativo com base de fornecedores early-stage. Reversibilidade: notificação enviada não pode ser 'des-enviada' — apenas corrigida com nova notificação (pior: gera confusão). Tight coupling: notificação errada de 'aprovada' pode levar fornecedor a tomar decisão financeira baseada em informação incorreta."
			recommendation: "Staged rollout: (1) Semana 1-2: agente gera notificações mas não envia — humano revisa 100% e envia manualmente. Blast radius = 0. (2) Semana 3-4: agente envia automaticamente apenas para status 'em análise' (consequência baixa se errado). Humano revisa 'aprovada' e 'rejeitada'. Blast radius parcial. (3) Semana 5+: se 0 erros em 200 notificações, expandir para 'rejeitada' (consequência moderada). 'Aprovada' permanece com revisão humana até 500 envios sem erro. Cap de blast radius: circuit breaker se >3 correções em 24h (suspender envio automático). Rate limiting: máximo 20 notificações por hora (limitar velocidade de propagação de erro). Rollback plan: template de notificação de correção pré-redigido."
			principlesApplied: ["ax-03", "ax-05", "dp-05"]
			assumptions: [
				"50-100 notificações/dia é volume suficiente para validar em 2-4 semanas",
				"fornecedores são tolerantes a delay de horas na notificação durante staged rollout",
				"notificação de 'aprovada' incorreta é mais danosa que 'rejeitada' incorreta — priorizar supervisão de 'aprovada'",
				"3 correções em 24h é threshold conservador para circuit breaker — calibrar com operação",
			]
			rationale: "Perrow 1984: tight coupling propaga falhas. Notificação enviada é irreversível. Staged rollout por severidade de consequência (em análise < rejeitada < aprovada) minimiza blast radius enquanto valida capability. Rate limiting reduz velocidade de propagação."
		},
	]

	principleIds: ["ax-01", "ax-03", "ax-05", "ax-06", "dp-01", "dp-05"]

	relatedLenses: [
		{
			lensId:   "lens-organizational-resource-allocation"
			relation: "complementsWith"
			context:  "ORA decide o que delegar a agentes (ora-delegation-fitness) e quanto de atenção humana alocar (ora-attention-as-resource). AAG governa o agente após a delegação — limites, escalation, observability, drift, lifecycle. ORA é a decisão de delegar; AAG é a implementação. A calibração HITL de AAG é decisão de alocação de atenção modelada por ORA."
		},
		{
			lensId:   "lens-organizational-economics"
			relation: "complementsWith"
			context:  "OE modela o problema de agência na delegação — custos de agência, alinhamento, confiança (oe-delegation-and-trust). AAG operacionaliza a mitigação do problema de agência para agentes IA especificamente — observability contract como mecanismo de monitoramento, audit trail como accountability, blast radius como contenção. OE é a teoria; AAG é a implementação para agentes IA."
		},
		{
			lensId:   "lens-credit-risk"
			relation: "complementsWith"
			context:  "CR define métricas e thresholds de monitoramento de modelos de scoring (cr-model-monitoring). AAG generaliza monitoramento para qualquer capability de agente e adiciona governance organizacional (lifecycle, escalation, HITL). Para scoring especificamente: CR provê as métricas técnicas (PSI, AUROC), AAG provê o framework de governance (quem monitora, quando escalar, como regredir)."
		},
		{
			lensId:   "lens-regulatory-strategy"
			relation: "complementsWith"
			context:  "RS identifica requisitos regulatórios de rastreabilidade, auditoria e responsabilização (Bacen, CVM). AAG implementa os mecanismos que satisfazem esses requisitos — audit trail, observability contract, governance as code. RS diz 'regulador exige X'; AAG implementa X."
		},
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "MD desenha mecanismos (scoring, pricing, matching) que agentes operam. AAG governa como os agentes operam esses mecanismos — com que autonomia, com que supervisão, com que contenção. MD é o 'o que o agente faz'; AAG é o 'como o agente é governado ao fazer'."
		},
		{
			lensId:   "lens-information-economics"
			relation: "feedsInto"
			context:  "AAG gera informação (observability, audit trail, drift detection) que alimenta decisões de information economics — qual informação é valiosa, como proteger, como acumular. O observability contract de AAG é um ativo informacional modelado por IE."
		},
	]

	limitations: [
		{
			description: "Governance as code assume que policies são codificáveis. Algumas policies envolvem julgamento contextual que resiste a codificação ('agente deve ser sensível ao tom do fornecedor em comunicação')."
			alternative: "Para policies não-codificáveis: manter nível de autonomia baixo (agente propõe, humano decide) até que a policy possa ser decomposta em regras codificáveis ou até que o agente demonstre julgamento adequado via track record."
			rationale: "Nem todo julgamento é formalizável. Governance as code cobre o formalizável; lifecycle com supervisão cobre o resto."
		},
		{
			description: "Drift detection assume que baseline é estável. Se o negócio está em mudança rápida (novo segmento, novo produto), baseline muda legitimamente e drift detection gera falsos positivos."
			alternative: "Em períodos de mudança rápida: suspender drift detection automático e substituir por revisão humana aumentada. Reestabelecer baseline quando o novo regime estabilizar."
			rationale: "Drift detection é calibrado para steady-state. Em transição de regime (March 1991: exploration → exploitation), o baseline anterior é inválido."
		},
		{
			description: "Lifecycle com critérios de promoção ex ante pode ser gaming-prone: agente (ou humano configurando agente) pode otimizar para atingir critério de promoção em vez de para qualidade real."
			alternative: "Critérios de promoção devem incluir métricas de output real (qualidade avaliada por humano) além de métricas proxy (taxa de erro, concordância). Goodhart's Law aplica aos critérios de promoção também."
			rationale: "Amodei et al. 2016: reward hacking. Se critério de promoção é apenas 'taxa de erro <2%', agente pode evitar decisões difíceis para manter taxa baixa."
		},
		{
			description: "Framework assume que o humano supervisor é competente e calibrado. Se o humano aprova outputs incorretos consistentemente, o lifecycle promove capability com base em evidência viciada."
			alternative: "Rotação de reviewer quando possível. Auditoria por terceiro (outro humano ou outro agente) periodicamente. Em organização solo founder: aceitar o risco e mitigar com blast radius containment e circuit breakers."
			rationale: "Bainbridge 1983: ironia da automação — humano é o elo fraco. Em solo founder, não há redundância humana — contenção por design compensa."
		},
		{
			description: "Não cobre governance de agentes que interagem diretamente com participantes externos da plataforma (fornecedores, compradores) em contexto de relação comercial. Foca em governance interna."
			alternative: "Para governance de interação agente-participante externo: combinar com mechanism-design (incentivos) e regulatory-strategy (requisitos regulatórios de comunicação automatizada)."
			rationale: "Interação com externo envolve dimensões adicionais — reputação, regulação de comunicação, responsabilidade civil — que excedem governance interna."
		},
	]

	rationale: "Toda organização AI-native opera agentes de IA como infraestrutura produtiva. Agentes executam tarefas, tomam decisões dentro de limites, e produzem outputs que afetam a organização e seus clientes. Sem governance explícita, a organização não sabe o que o agente pode decidir (Sheridan/Verplank 1978), quando deve escalar (Reason 1997), como detectar desvio (Sculley et al. 2015), nem como reconstruir decisões ex post (Power 1997). Esta lens operacionaliza: fronteiras de autonomia por capability (Parasuraman et al. 2000), escalation com defesa em profundidade (Reason 1997), observabilidade como capacidade de diagnosticar o não-antecipado (Sridharan 2018), drift detection com baseline e threshold (Klaise et al. 2020), governance as code versionável (Morris 2016), contenção de blast radius por design (Perrow 1984, Leveson 2011), lifecycle de capability com promoção por evidência (Deming 1986), audit trail reconstruível por terceiros (Power 1997), calibração de supervisão proporcional à maturidade (Parasuraman/Riley 1997, Bainbridge 1983), e verificação contínua de alinhamento contra Goodhart's Law (Russell 2019). Universal, agnóstica a estágio, aplicável a qualquer organização que opera com agentes de IA."

}
