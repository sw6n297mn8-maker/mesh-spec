package bdg

// canvas.cue — Bounded Context Canvas: Budget & Approval.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// BDG é o gate de cobertura orçamentária do commitment lifecycle.
// Consome CommitmentAccepted de CMT (upstream) e publica
// BudgetApproved para DLV (downstream). Sem BDG, gate orçamentário
// ficaria diluído entre CMT (formalização) e FCE (execução
// financeira) — sem owner canônico do comprometimento. Authoring
// manual por main agent após dispatch subagent timeout (per
// adr-074 revisit condition (b)). PG canvas (commit ef5195f)
// aplicado section-by-section.
//
// Fronteiras (per strategic/subdomains/bdg.cue):
// - Não formaliza compromissos (CMT)
// - Não executa pagamentos (FCE)
// - Não verifica execução operacional (DLV)
// - Não precifica risco (REW)
// - Não processa disputas orçamentárias (DRC)
// - Não governa fluxo de procurement (P2P)
// - Não gerencia tesouraria (TCM)

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

canvas: artifact_schemas.#Canvas & {
	code: "bdg"
	name: "Budget & Approval"

	purpose: """
		Verificar cobertura orçamentária para compromissos econômicos
		formalizados em CMT e gerar gate canônico de aprovação que
		habilita progressão do commitment lifecycle. BDG é owner
		exclusivo do estado de comprometimento orçamentário por
		centro de custo, das regras de alçada de aprovação e da
		invariante de que nenhum compromisso avança sem cobertura
		verificada. Sem BDG como unidade separada, o gate orçamentário
		ficaria diluído entre CMT (formalização) e FCE (execução
		financeira) — comprometimento prospectivo e pagamento efetivo
		se confundiriam, e a invariante de cobertura prévia perderia
		enforcement determinístico.
		"""

	ubiquitousLanguageRef: "contexts/bdg/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "compliance-enforcer"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque controle orçamentário é domínio com
			padrões bem estabelecidos (planejamento, comprometimento,
			ERP) — não é a proposta de valor final da Mesh. O valor
			proprietário está na vinculação do gate orçamentário ao
			commitment lifecycle como pré-condição formal verificada,
			não no controle orçamentário em si. Compliance-enforcer
			porque BDG impede que compromissos progridam sem cobertura
			— gate determinístico que protege a rede contra inadimplência
			programática. Product na evolução Wardley porque o problema
			(controle de comprometimento por centro de custo com
			alçadas) é amplamente compreendido e endereçado por
			soluções de mercado (ERPs); a Mesh adapta o padrão
			integrando-o ao commitment lifecycle como gate auditável.
			"""
	}

	verticalApplicability: {
		mode: "vertical-agnostic"
		rationale: """
			Controle orçamentário por centro de custo, alçada e comprometimento
			é padrão operacional transversal. BDG nasce aplicado à construção
			civil pela sequência CMT → BDG → DLV, mas seus primitives não
			dependem da vertical: qualquer cadeia com commitments, budgets,
			cost centers e approval gates pode reutilizar o BC com vocabulário
			adaptado.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["execution"]
		rationale: """
			Gateway como primário: BDG é gate de progressão do
			commitment lifecycle — resultado para downstream (DLV) é
			binário (approved ou rejected). Sem aprovação de BDG, DLV
			não habilita verificação de execução. Execution como
			secundário: BDG executa o processo de aprovação com steps
			determinísticos (consulta saldo, verifica alçada, registra
			comprometimento, publica decisão) e mantém o estado
			canônico do comprometimento como SoT operável.
			"""
	}

	capabilities: {
		operational: [{
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua de comprometimento orçamentário:
				cada solicitação de aprovação, decisão (aprovação ou
				rejeição), liberação e ajuste de alçada é fato imutável
				no Event Log. Regulador, controllers e auditoria
				interna podem reconstituir comprometimento por centro
				de custo em qualquer data.
				"""
			rationale: "Comprometimento orçamentário é base de compliance fiscal e contábil — sem trail auditável, controle orçamentário regride a snapshots desconectados do commitment lifecycle."
		}, {
			capabilityRef: "cc-03"
			description: """
				Aprovação orçamentária 24/7 via gate determinístico:
				agente verifica saldo disponível por centro de custo,
				valida alçada aplicável e emite decisão de cobertura
				sem intervenção humana rotineira. Humano supervisor
				atua por exceção (threshold excedido, ambiguidade de
				centro de custo, ajuste de limite).
				"""
			rationale: "cc-03 (operação 24/7) aplica diretamente: aprovação orçamentária é gate de fluxo cuja latência humana bloquearia o commitment lifecycle inteiro. Determinismo de saldo + alçada permite automação com supervisão por exceção."
		}, {
			description: """
				Gate determinístico de cobertura orçamentária:
				invariante de que nenhum compromisso avança sem (a)
				saldo disponível em centro de custo identificado e
				(b) alçada de aprovação satisfeita. Falha em qualquer
				invariante bloqueia aprovação e registra rejeição com
				motivo estruturado para que CMT e DRC possam reagir.
				"""
			rationale: "Invariante central do BDG. Sem gate determinístico de cobertura, compromissos progridem para DLV/INV/FCE sem lastro orçamentário — risco de inadimplência programática que a Mesh existe para eliminar."
		}, {
			description: """
				Modelo canônico de comprometimento orçamentário
				exposto via query síncrono para consulta de saldo e
				estado de aprovação por CommitmentId.
				"""
			rationale: "Múltiplos consumidores potenciais (CMT para visibilidade pós-formalização, DRC para contexto de disputa, controllers para reporting) precisam referenciar a mesma fonte de comprometimento. SoT exposta via query elimina divergência entre cópias."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Avaliação determinística conclui que compromisso tem cobertura e alçada satisfeitas, OU supervisor aprova exceção dentro do escopo de governance."
			command:         "ApproveBudget"
			resultingEvents: ["BudgetApproved"]
			description:     "Gate de cobertura — invariante central do BDG. Sync porque downstream (DLV) precisa de decisão determinística antes de progredir. Comprometimento é registrado contra centro de custo no momento da aprovação. BudgetApproved é o sinal canônico publicado externamente."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Avaliação determinística conclui que compromisso não tem cobertura (saldo insuficiente, centro de custo inválido, alçada excedida sem aprovação supervisora)."
			command:         "RejectBudget"
			resultingEvents: ["BudgetRejected"]
			description:     "Decisão terminal de rejeição com motivo estruturado. Sync porque CMT precisa do resultado para atualizar estado do compromisso. Rejeição não cancela o compromisso em CMT — apenas sinaliza ausência de cobertura; CMT decide consequência. Publicação de BudgetRejected para CMT/DRC pendente de formalização no context-map (oq-bdg-2)."
		}, {
			type:          "event-consumer"
			sourceContext: "cmt"
			event:         "CommitmentAccepted"
			reaction:      "Inicia processo de aprovação orçamentária. Agente identifica centro de custo aplicável a partir do compromisso, consulta saldo disponível e alçada, executa gate determinístico."
			description:   "Sinal canônico de entrada do commitment lifecycle no escopo de BDG. Spine commitment-lifecycle no context-map (cmt-to-bdg, async)."
		}, {
			type:        "query-surface"
			query:       "QueryBudgetApprovalStatus"
			returnType:  "BudgetApprovalStatus"
			description: "Retorna estado de aprovação orçamentária de um CommitmentId — pendente, aprovado, rejeitado, liberado — com motivo estruturado e centro de custo associado. Consumido por CMT para visibilidade pós-formalização e por DRC quando disputa referencia compromisso aprovado."
		}, {
			type:        "query-surface"
			query:       "QueryCostCenterAvailability"
			returnType:  "CostCenterAvailability"
			description: "Retorna saldo disponível por centro de custo, comprometimentos ativos e limites configurados. Consumido por controllers, supervisores e — em cenário evolutivo — por CMT para previsão de cobertura antes da formalização (oq-bdg-3)."
		}]
		outbound: [{
			type:        "event-publisher"
			trigger:     "Gate de cobertura aprovado — saldo verificado, alçada satisfeita, comprometimento registrado contra centro de custo."
			event:       "BudgetApproved"
			consumers: ["dlv"]
			description: "Sinal canônico de progressão no commitment lifecycle. DLV consome para habilitar verificação de execução. Spine commitment-lifecycle no context-map (bdg-to-dlv, async)."
		}]
		rationale: """
			Inbound: 2 commands (aprovação sync + rejeição sync), 1
			event consumer (CMT — CommitmentAccepted como spine), 2
			query surfaces (status de aprovação por CommitmentId +
			disponibilidade por centro de custo). Outbound: 1 event
			publisher (BudgetApproved spine para DLV). Per PG canvas
			tq-cv-02: TODA relation cross-checked com strategic/
			context-map.cue. Apenas 2 relations declaradas em
			context-map (cmt-to-bdg + bdg-to-dlv) — modeladas como
			factual. Eventos secundários (BudgetRejected para CMT/DRC,
			BudgetCommitmentReleased para CMT, CommitmentStateChanged
			consumption) referenciam relations não-formalizadas;
			ficam em openQuestions (oq-bdg-2) com flag explícito,
			não em communication.
			"""
	}

	businessDecisions: [{
		id:           "bd-coverage-as-invariant"
		decision:     "Cobertura orçamentária verificada é invariante inviolável — nenhum compromisso progride para DLV sem BudgetApproved emitido por BDG."
		rationale:    "Sem invariante determinístico de cobertura, compromissos avançam para verificação de execução, faturamento e liquidação sem lastro orçamentário, criando inadimplência programática. Gate determinístico transforma cobertura de premissa implícita em fato auditável."
		consequences: "DLV depende de BudgetApproved como pré-condição. Indisponibilidade de BDG bloqueia o spine commitment-lifecycle. Estratégia de resiliência (timeout, fallback supervisionado) deve ser definida no Architecture Communication Canvas do BDG."
	}, {
		id:           "bd-commitment-not-payment"
		decision:     "BDG controla comprometimento orçamentário (prospectivo); FCE executa pagamento (efetivo). BDG não verifica disponibilidade de caixa nem altera projeções de fluxo financeiro."
		rationale:    "Comprometimento e caixa têm cadências distintas: empresa pode ter orçamento sem caixa (BDG aprovou mas TCM não tem liquidez) ou caixa sem orçamento. Misturar acumularia em BDG responsabilidade de TCM e FCE — drift para 'BC Deus' financeiro. Fronteira explícita preserva linguagem orçamentária pura."
		consequences: "BDG não consulta TCM para aprovar e não bloqueia execução em FCE. Aprovação orçamentária pode preceder a posição de caixa correspondente — gestão de liquidez é responsabilidade de TCM, e execução condicional ao caixa é responsabilidade de FCE."
	}, {
		id:           "bd-cost-center-as-sot"
		decision:     "Centro de custo é a unidade canônica de comprometimento — todo compromisso aprovado é registrado contra exatamente um centro de custo identificado, com limites configurados externamente ao BDG."
		rationale:    "Sem unidade canônica de comprometimento, controle orçamentário se dilui em agregações contábeis ad-hoc. Centro de custo é o vocabulário estabelecido em controladoria (linguagem própria do subdomínio per strategic/subdomains/bdg.cue) — adotá-lo como SoT alinha BDG com profissionais (controllers) e instrumentos existentes."
		consequences: "Compromissos sem centro de custo identificável são bloqueados na entrada — agente solicita esclarecimento ou escala. Mudanças no plano de centros de custo são governadas externamente (planejamento anual, revisões trimestrais) e ingeridas como configuração — BDG não decide topologia de centros de custo."
	}, {
		id:           "bd-allocation-not-treasury"
		decision:     "BDG não decide alocação estratégica de orçamento entre centros de custo — apenas verifica e registra comprometimento contra alocações pré-existentes. Ajustes de limite por centro de custo são supervisedDecisions, não capabilities operacionais autônomas."
		rationale:    "Decidir quanto cada centro de custo recebe é decisão estratégica anual (planejamento) que pertence à diretoria financeira, não ao agente operador. BDG operacionaliza o gate; a calibragem da alocação vive fora do BC. Misturar operação e calibragem geraria conflito de incentivos no agente."
		consequences: "Limites por centro de custo são input externo para BDG. Mudança de limite passa por ajuste supervisionado e auditável — não há autonomia para reallocate. Falha de cobertura por limite restritivo é escalada, não resolvida internamente pelo agente."
	}]

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Originadora de comprometimento orçamentário — construtora cujos compromissos formalizados em CMT consomem orçamento de centros de custo controlados em BDG."
		impactDescription: "Aprovação automatizada com gate determinístico reduz latência de progressão do commitment lifecycle. Rejeição com motivo estruturado permite ajuste rápido (revisão de centro de custo, escalação de limite) em vez de bloqueio opaco."
		rationale:         "Construtora é o nó central da cadeia produtiva — cada compromisso da construtora consome orçamento. Eficiência e clareza do gate orçamentário afetam diretamente a velocidade de operação da contraparte primária."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Beneficiário indireto de cobertura — fornecedor cujo compromisso só progride para verificação e pagamento se BDG aprovou."
		impactDescription: "Cobertura aprovada como pré-condição declarada reduz risco de não-pagamento por insuficiência orçamentária pós-formalização — diferencia compromisso aprovado de compromisso aceito mas sem lastro."
		rationale:         "Fornecedor é o lado da cadeia com menor poder de barganha sobre verificação prévia de cobertura. BDG transforma promessa orçamentária implícita em fato auditável que protege fornecedor contra inadimplência programática."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulador — espera trail auditável de comprometimento orçamentário como evidência de governança financeira da SCD."
		impactDescription: "BDG mantém Event Log imutável de cada solicitação, decisão e liberação por centro de custo. Regulador pode reconstituir comprometimento histórico em qualquer data."
		rationale:         "Auditabilidade de comprometimento é elemento de prudência financeira que sustenta a operação SCD. Embora BDG não seja o BC primário de compliance regulatório (NPM/IDC), o trail de comprometimento alimenta reporting agregado."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Operador primário — processa solicitações de aprovação, executa gate determinístico (saldo + alçada), registra comprometimento, publica decisões e propõe escalações de limite."
		impactDescription: "Governance scope com boundaries claras: validação determinística e registro autônomos; ajuste de limite, override de alçada e exceções supervisionados. Manipulação por favoritismo é endereçada por gate determinístico e Event Log."
		rationale:         "Agente IA opera o gate; sem boundaries explícitas, decisões de aprovação seriam zona cinza com poder assimétrico do agente sobre o spine commitment-lifecycle. P10 exige separação operação/decisão para mutações com impacto financeiro."
	}]

	costsEliminated: [{
		costRef: "ce-02"
		contribution: """
			BDG elimina custo de compliance documental no comprometimento
			orçamentário: agentes verificam cobertura e alçada
			automaticamente, gates determinísticos validam invariantes
			(saldo suficiente, alçada satisfeita, centro de custo
			válido). Processo manual de aprovação por controller
			(consulta planilha, valida limite, registra comprometimento,
			comunica decisão) é substituído por gate em segundos com
			trail auditável.
			"""
		rationale: "ce-02 aplica diretamente: comprometimento orçamentário é etapa de compliance financeira que envolve documentação, validação e registro — exatamente o tipo de custo que mech-agent-gate elimina por automação determinística."
	}, {
		costRef: "ce-03"
		contribution: """
			BDG reduz custo de reconciliação financeira multi-sistema
			entre comprometimento prospectivo (orçamento) e pagamento
			efetivo (caixa): SoT de comprometimento por centro de
			custo, vinculada a CommitmentId, elimina divergência entre
			planilhas de controller, ERP e ledger. Cada aprovação e
			liberação é fato imutável referenciável por outros SoTs
			(CMT, FCE, ATO) via CommitmentId.
			"""
		rationale: "ce-03 aplica porque reconciliação orçamento-vs-realizado é um dos pontos clássicos de divergência multi-sistema em controladoria. SoT canônico de comprometimento via mech-three-sots remove a divergência na origem."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Originadora de comprometimento — construtora que submete compromissos a aprovação orçamentária."
			desiredBehavior:           "Submeter compromissos com centro de custo correto e valor que reflete o escopo real, respeitando alçadas configuradas para cada nível de decisão."
			correctOperationIncentive: "Compromissos com centro de custo correto e dentro de alçada são aprovados em segundos pelo gate determinístico — progressão automática para DLV. Compromissos com escopo inflado ou centro de custo incorreto são rejeitados ou escalados, gerando latência."
			manipulationVector:        "Atribuir compromisso a centro de custo com saldo abundante quando o escopo real pertence a outro centro restrito, ou fracionar compromisso grande em múltiplos sub-threshold para evitar escalação de alçada."
			manipulationCost:          "Centro de custo é validado contra escopo declarado em CMT e contra evidência operacional em DLV — divergência entre centro de custo aprovado e natureza da execução é detectável e gera revisão. Fracionamento é detectável por agregação cross-compromisso por par de partes em janela temporal — padrão coordenado entre BDG e REW (oq-bdg-1)."
			vsBenefit:                 "Benefício de mascarar centro de custo é aprovação rápida de compromisso que seria escalado. Custo: detecção por reconciliação cross-BC (CMT/DLV/BDG), reversal de aprovação com responsabilização documentada, escalada de severidade para escalações futuras do mesmo proponente, e potencial responsabilidade jurídica (dp-10) se mascaramento configurar fraude orçamentária."
			designResponse:            "Gate determinístico exige centro de custo identificado e válido (bd-cost-center-as-sot). Reconciliação cross-BC compara centro de custo declarado em BDG com escopo em CMT e evidência em DLV. Detecção de fracionamento é responsabilidade compartilhada com REW (oq-bdg-1). Override de alçada é supervisedDecision — não há autonomia para o agente aprovar fora de alçada."
			rationale:                 "Originadora tem incentivo para acelerar aprovação ao mascarar centro de custo ou fracionar compromisso. Design response usa cross-BC reconciliation + supervisão obrigatória para override + Event Log imutável para tornar manipulação mais cara que operação correta."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "Operador da plataforma — agente que executa gate determinístico de cobertura e alçada."
			desiredBehavior:           "Executar gate (saldo + alçada) com imparcialidade, registrar comprometimento sem favoritismo, escalar exceções dentro do escopo de governance e nunca aprovar fora de alçada autonomamente."
			correctOperationIncentive: "Operação imparcial mantém credibilidade do gate como mecanismo de proteção da rede contra inadimplência programática. Favoritismo detectado degrada confiança em todo o spine commitment-lifecycle e gera responsabilidade jurídica (dp-10)."
			manipulationVector:        "Aplicar critério mais leniente para compromissos de proponente preferencial (interpretar alçada de forma elástica, classificar centro de custo de forma favorável a saldo abundante), ou postergar liberação de comprometimento em casos onde liberação prejudicaria proponente preferencial."
			manipulationCost:          "Event Log imutável registra timestamps de cada solicitação, decisão e liberação — desvio estatístico de latência e de classificação por proponente é detectável por REW. Gates determinísticos (mech-agent-gate) verificam invariantes (saldo, alçada) independentemente do agente — interpretação elástica é bloqueada pelo gate. Override de alçada é supervisedDecision — agente não aprova fora de alçada autonomamente."
			vsBenefit:                 "Benefício de favoritismo é retenção de cliente preferencial ou velocidade aparente. Custo: Event Log torna padrão detectável por REW, gates bloqueiam aprovação fora de invariantes, supervisão humana em todas as decisões materiais (override, ajuste de limite, exceção), responsabilidade jurídica recai sobre operador da plataforma (dp-10)."
			designResponse:            "mech-agent-gate separa execução (agente) de validação (gate determinístico). Event Log imutável (mech-evidence) cria trail temporal auditável. Override de alçada e ajuste de limite são supervisedDecisions. REW pode monitorar padrões cross-proponente para detectar favoritismo estatístico. Risco residual: viés sutil de classificação dentro do envelope autônomo — gap cross-BC compartilhado com outros BCs operados por agente."
			rationale:                 "Operador tem poder assimétrico sobre classificação e priorização dentro do envelope. Design response combina gate determinístico, Event Log e supervisão humana para tornar manipulação detectável e contida. Detecção é necessária mas não suficiente — alignment proativo é gap cross-BC."
		}]
		rationale: """
			Análise cobre 2 vetores adversariais primários: (a)
			originadora mascara centro de custo ou fraciona compromisso
			para contornar alçada (sh-01); (b) operador classifica de
			forma enviesada ou prioriza fila por favoritismo (sh-05).
			Vetores individuais com custos que excedem benefícios por
			design (mech-agent-gate, mech-evidence, supervisão humana
			para decisões materiais, rastreabilidade end-to-end via
			CommitmentId). Vetores de coalizão proponente-aprovador
			e detecção de fracionamento cross-BC ficam em openQuestions
			(oq-bdg-1) — endereçamento estrutural pendente.
			Stakeholders sh-04 (regulador) não é participante ativo —
			é observador/consumidor indireto.
			"""
	}

	ownership: {
		domainAgentSpec: "contexts/bdg/agents/bdg-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "verify-coverage-deterministic"
				description: "Verificar automaticamente que centro de custo identificado tem saldo disponível suficiente para o valor do compromisso, conforme limites configurados externamente."
				rationale:   "Verificação é determinística — comparação numérica entre saldo e valor. Sem margem para julgamento."
			}, {
				id:          "evaluate-alcada-deterministic"
				description: "Avaliar automaticamente se valor do compromisso está dentro da alçada do agente conforme tabela de alçadas vigente."
				rationale:   "Tabela de alçadas é configuração externa; avaliação é função determinística do valor + tabela. Decisões dentro de alçada são executadas; decisões fora de alçada são escaladas."
			}, {
				id:          "register-budget-commitment"
				description: "Registrar comprometimento orçamentário no Event Log e atualizar saldo disponível por centro de custo após aprovação."
				rationale:   "Registro é append-only e determinístico. Atualização de saldo deriva da aprovação registrada — sem decisão adicional."
			}, {
				id:          "publish-decision-events"
				description: "Publicar BudgetApproved ou BudgetRejected após decisão registrada."
				rationale:   "Publicação de fatos é append-only. Downstream decide como reagir."
			}]
			supervisedDecisions: [{
				id:          "approve-budget-out-of-alcada"
				description: "Aprovar compromisso cujo valor excede a alçada do agente — supervisor humano avalia caso a caso."
				rationale:   "Override de alçada é gate de governance — aprovação fora de alçada por agente violaria mech-agent-gate e P10. Supervisor designado é responsável nominalmente pela decisão."
			}, {
				id:          "approve-budget-with-cost-center-ambiguity"
				description: "Aprovar compromisso quando centro de custo aplicável é ambíguo (escopo cobre múltiplos centros, ou centro indicado conflita com escopo declarado em CMT)."
				rationale:   "Ambiguidade de centro de custo exige julgamento humano — classificação errada propaga para reconciliação contábil. Supervisor decide qual centro responde."
			}, {
				id:          "adjust-cost-center-limit"
				description: "Ajustar limite configurado de centro de custo (aumento ou redução) — decisão de alocação."
				rationale:   "bd-allocation-not-treasury: alocação estratégica entre centros de custo é decisão de planejamento financeiro, não capability operacional do agente. Mudança de limite é supervisedDecision com justificativa documentada."
			}]
			escalationCriteria: [{
				id:        "out-of-alcada-threshold"
				condition: "Valor do compromisso excede alçada do agente conforme tabela vigente."
				action:    "Escalar ao supervisor designado para aprovação humana antes de publicar BudgetApproved. Não cachear decisão entre requisições."
				rationale: "Alçada é controle de contenção. Aprovação fora de alçada por agente viola mech-agent-gate."
			}, {
				id:        "fragmentation-pattern-detected"
				condition: "REW ou agregação interna sinaliza padrão de fracionamento — múltiplos compromissos sub-threshold do mesmo proponente, mesmo centro de custo, em janela temporal curta."
				action:    "Escalar ao founder ou supervisor designado para revisão agregada — pode resultar em revogação de aprovações ou em ajuste de threshold/alçada. Pausar autonomia para o proponente afetado até decisão."
				rationale: "Threshold gaming é vetor adversarial conhecido. Detecção exige decisão humana sobre consequência — agregação, revogação ou ajuste de regra."
			}, {
				id:        "cost-center-policy-change"
				condition: "Mudança em plano de centros de custo, alçadas ou limites configurados que afeta compromissos pendentes ou ativos."
				action:    "Notificar founder, pausar aprovações afetadas, escalar para revisão de continuidade ou rollback."
				rationale: "Mudanças em configuração de governance financeira têm impacto cross-compromisso. Decisão de continuidade exige humano com visibilidade do contexto de planejamento."
			}, {
				id:        "regulatory-or-fiscal-ambiguity"
				condition: "Compromisso envolve estrutura orçamentária em zona cinza fiscal ou regulatória — centro de custo associado a operação tributária não rotineira, comprometimento que pode requerer reporte específico."
				action:    "Escalar ao compliance officer ou controller designado para parecer antes de aprovar."
				rationale: "Integridade legal é constraint inviolável (nível 1). Zona cinza exige julgamento humano especializado."
			}]
		}
		rationale: """
			bdg-primary-agent como operador, referenciado por path
			canônico (forward reference — agent-spec ainda não autorado
			na primeira fase do BC bootstrap). 4 decisões autônomas
			(verificações determinísticas, registro, publicação), 3
			supervisedDecisions (override de alçada, ambiguidade de
			centro de custo, ajuste de limite), 4 escalation criteria
			(alçada excedida, fracionamento, mudança de policy,
			ambiguidade fiscal/regulatória). Counts respeitam
			doneCriteria relaxed do PG canvas (≥1/≥1/≥3): autônomos
			cobrem operações puramente determinísticas; supervisedDecisions
			cobrem decisões com julgamento; escalation criteria cobrem
			4 conditions concretas. Boundaries refletem mech-agent-gate:
			agente verifica e registra, supervisão humana para
			overrides + alocação + padrões anômalos. bd-allocation-not-treasury
			explicitamente preservada — agente não realoca orçamento
			entre centros de custo.
			"""
	}

	assumptions: [{
		id:                 "as-bdg-1"
		assumption:         "Centro de custo aplicável a um compromisso é identificável de forma determinística a partir do compromisso aceito em CMT (escopo, partes, referência contratual de CTR)."
		invalidationSignal: "Surgimento recorrente de compromissos cuja atribuição a centro de custo exige julgamento humano — taxa de escalação por ambiguidade de centro de custo acima de threshold operacional."
		rationale:          "bd-cost-center-as-sot pressupõe identificação automática. Se identificação exigir interpretação subjetiva como regra (não exceção), gate determinístico regride para gate semi-manual e a invariante de aprovação 24/7 (cc-03) fica comprometida."
	}, {
		id:                 "as-bdg-2"
		assumption:         "Limites por centro de custo configurados externamente são suficientes como controle de exposição — não há necessidade de limites dinâmicos calculados em runtime pelo BDG (e.g., limites por contraparte, por instrumento, por janela temporal além do centro de custo)."
		invalidationSignal: "Demanda regulatória ou de governance que exija dimensão de limite não capturada por centro de custo — concentração por contraparte que centro de custo não distingue."
		rationale:          "BDG opera como gate determinístico sobre dimensão única (centro de custo). Se múltiplas dimensões forem necessárias, o modelo de comprometimento precisa evoluir e o gate determinístico ganha complexidade não trivial."
	}, {
		id:                 "as-bdg-3"
		assumption:         "Cadência de evolução do plano de centros de custo (anual com revisões trimestrais) é suficiente para acomodar mudanças no escopo operacional da rede — não há necessidade de mutação contínua de estrutura de centros de custo."
		invalidationSignal: "Volume de mudanças intra-trimestre que sobrecarrega supervisão humana ou que cria janelas frequentes onde compromissos pendentes referenciam centros de custo em mutação."
		rationale:          "Governance externa do plano de centros de custo (planejamento + revisões trimestrais) é premissa estrutural. Cadência insuficiente força BDG a internalizar mudanças contínuas — drift para responsabilidade que pertence à diretoria financeira."
	}]

	openQuestions: [{
		id:        "oq-bdg-1"
		question:  "Como implementar detecção de fracionamento (BDG + REW) que opere sobre dimensões múltiplas — proponente, centro de custo, par de partes, janela temporal — antes que threshold gaming se torne vetor explorável?"
		impact:    "Threshold de alçada sem detecção de fracionamento ativa cria incentivo imediato para originadores fracionarem compromissos para evitar escalação. Coordenação cross-BC (BDG ↔ REW ↔ CMT) é necessária para que dimensões agregáveis tenham SoT consistente."
		deadline:  "2026-06-15"
		rationale: "Detecção de fracionamento é dependência estrutural do gate de alçada. Sem ela, o sistema cria a vulnerabilidade e o incentivo simultaneamente."
	}, {
		id:        "oq-bdg-2"
		question:  "BDG deve publicar BudgetRejected e BudgetCommitmentReleased diretamente para CMT (relação bdg→cmt) e DRC (relação bdg→drc), ou cada consumidor descobre via query sync?"
		impact:    "Sem relação direta formalizada, CMT e DRC dependem de query polling para descobrir rejeição ou liberação — latência pode ser significativa. Relação direta async permite reação imediata mas requer formalização no context-map."
		deadline:  "2026-07-01"
		rationale: "Context-map v2 declara apenas bdg→dlv como relação outbound de BDG. Eventos de rejeição e liberação são pendentes de formalização — enquanto não declarados, BDG não modela operacionalmente publicação para esses consumers."
	}, {
		id:        "oq-bdg-3"
		question:  "BDG deve oferecer query síncrona pré-formalização para CMT validar cobertura antes de aceitar compromisso, ou aprovação permanece exclusivamente pós-formalização?"
		impact:    "Sem query pré-formalização, CMT pode aceitar compromisso bilateralmente e descobrir indisponibilidade orçamentária apenas em BDG — exige cancelamento ou renegociação. Com query pré, CMT pode pré-validar cobertura, mas introduz acoplamento sync no caminho crítico de aceite."
		deadline:  "2026-07-15"
		rationale: "Trade-off entre antecipação de falha e acoplamento sync. Decisão depende de dados reais de operação — frequência observada de rejeição pós-aceite é o sinal primário."
	}]

	verificationMetrics: [{
		id:        "budget-approval-time"
		metric:    "Tempo médio entre CommitmentAccepted (consumido) e BudgetApproved ou BudgetRejected (publicado)"
		target:    "< 5 minutos para 95% dos compromissos dentro de alçada"
		rationale: "Mede latência do gate determinístico. Latência alta indica que verificação saldo+alçada não está operando como gate sub-segundo — possível regressão para semi-manual ou ambiguidade frequente de centro de custo."
	}, {
		id:        "budget-rejection-rate"
		metric:    "Percentual de compromissos aceitos em CMT que são rejeitados em BDG por insuficiência de cobertura"
		target:    "< 3% dos compromissos avaliados"
		rationale: "Taxa alta indica desalinhamento entre formalização (CMT) e governance orçamentária — possíveis causas: configuração de limite restritiva, falta de visibilidade pré-formalização (oq-bdg-3) ou drift de plano de centros de custo (as-bdg-3)."
	}, {
		id:        "supervisor-override-rate"
		metric:    "Percentual de aprovações que requerem supervisedDecision (override de alçada, ambiguidade de centro de custo)"
		target:    "< 10% das aprovações totais"
		rationale: "Taxa alta indica que regras determinísticas não cobrem o espectro operacional — possível necessidade de revisar tabela de alçadas, plano de centros de custo, ou capacidade de classificação automática (as-bdg-1)."
	}]

	rationale: """
		BDG é gate de cobertura orçamentária do commitment lifecycle
		— consome CommitmentAccepted de CMT e publica BudgetApproved
		para DLV (spine commitment-lifecycle no context-map).
		Supporting + compliance-enforcer + product (Wardley) reflete
		domínio com padrões estabelecidos integrado ao flow Mesh
		como gate auditável. Vertical-agnostic — primitives de
		controle orçamentário não dependem da vertical de aplicação.
		Gateway primary + execution secondary captura papel de
		progressão + steps determinísticos. 4 businessDecisions
		codificam invariants core: cobertura como invariante
		inviolável (bd-coverage-as-invariant), separação entre
		comprometimento e pagamento (bd-commitment-not-payment),
		centro de custo como SoT canônico (bd-cost-center-as-sot),
		alocação fora do escopo do agente (bd-allocation-not-treasury).
		4 stakeholders concretos (sh-01/02/04/05) + 2 incentive
		vectors adversariais (mascaramento por originadora,
		favoritismo por operador) com custos estruturalmente maiores
		que benefícios. Governance: 4 autonomous + 3 supervised + 4
		escalation criteria respeitando relaxation do PG canvas
		(≥1/≥1/≥3). 3 assumptions + 3 openQuestions + 3
		verificationMetrics capturam estado epistêmico. Communication
		modela apenas relations formalizadas em context-map (cmt-to-bdg,
		bdg-to-dlv); secundárias (BudgetRejected, CommitmentStateChanged,
		BudgetCommitmentReleased) ficam em openQuestions per tq-cv-02.
		"""
}
