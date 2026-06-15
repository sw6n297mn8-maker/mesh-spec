package bdg

// glossary.cue — Ubiquitous Language: Budget & Approval.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Termos canônicos do BC BDG. Define o vocabulário que agentes,
// código, contratos e interfaces usam ao operar neste contexto.
//
// Lenses aplicadas:
// - lens-domain-language-and-terminology-design (primária):
//   bilingual mapping, term selection, cross-layer consistency
//
// Production-guide aplicado: architecture/production-guides/glossary.cue
//
// Authoring path: subagent dispatch (disp-005) bem-sucedida pós-WI-069
// PG-tension-entry — primeira validação operacional do rollout extension
// per adr-074 para non-PG type. 3 ciclos de red team aplicados pelo
// founder + ajustes substantivos (Alçada loanword, Liberação termEn
// verboso, BudgetCommitmentReleased event, examples adicionados,
// definitions reformuladas).
//
// domainModelRefs permanecem vazios — o domain-model.cue de BDG já
// existe; o preenchimento dos refs é trabalho futuro.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code:              "bdg"
	name:              "Glossário BDG — Budget & Approval"
	boundedContextRef: "bdg"

	terms: [{
		code:       "term-cobertura-orcamentaria"
		name:       "Cobertura Orçamentária"
		termEn:     "Budget Coverage"
		definition: "Confirmação determinística, por compromisso, de duas invariantes simultâneas: (a) existe Saldo Disponível suficiente em Centro de Custo identificado, e (b) o valor está dentro de Alçada satisfeita. Pré-condição inviolável para progressão do commitment lifecycle além de BDG."
		category:   "rule"
		rationale:  "Conceito-âncora de BDG: o que o BC entrega ao spine commitment-lifecycle. Classificado como rule (invariante) per bd-coverage-as-invariant — não é processo negociável nem score, é gate determinístico binário (aprovado/rejeitado). Sem termo canônico, agentes confundem cobertura com 'aprovação' genérica e perdem a propriedade de invariante."
		antiTerms: [{
			term:          "Disponibilidade de Caixa"
			clarification: "Cobertura é prospectiva (orçamento comprometido vs limite); disponibilidade de caixa é efetiva (liquidez para pagar). bd-commitment-not-payment separa: BDG não consulta TCM; FCE não verifica BDG para executar pagamento. Empresa pode ter cobertura sem caixa ou caixa sem cobertura."
		}, {
			term:          "Aprovação de Crédito"
			clarification: "Aprovação de crédito avalia risco da contraparte e pertence a REW. Cobertura avalia se o comprador tem orçamento alocado. São gates independentes — compromisso pode ter cobertura e ser de alto risco, ou vice-versa."
		}]
		rejectedAlternatives: [{
			term:   "Verba"
			reason: "Linguagem coloquial de planejamento; ambíguo entre 'alocação' e 'saldo'. Não captura a propriedade de gate verificado por compromisso."
		}, {
			term:   "Provisão Orçamentária"
			reason: "'Provisão' tem semântica contábil específica em IFRS/CPC (passivo estimado) — confunde controle de comprometimento prospectivo com reconhecimento contábil de obrigação."
		}]
		examples: [{
			context:   "Spine commitment-lifecycle"
			instance:  "Compromisso de R$ 250.000 contra CC-2026-OBRA-XYZ-CONCRETO com Saldo Disponível de R$ 1.200.000 e Alçada do agente operador de R$ 500.000 → invariantes (a) e (b) satisfeitas → Cobertura Orçamentária aprovada → BudgetApproved publicado para DLV."
			rationale: "Demonstra o gate determinístico em caso típico aprovado: ambas invariantes satisfeitas dentro de operação rotineira sem necessidade de escalação."
		}]
		relatedTerms: ["term-centro-de-custo", "term-saldo-disponivel", "term-alcada", "term-comprometimento-orcamentario", "term-gate-de-cobertura"]
	}, {
		code:       "term-centro-de-custo"
		name:       "Centro de Custo"
		termEn:     "Cost Center"
		definition: "Unidade canônica contra a qual todo Comprometimento Orçamentário aprovado é registrado em BDG. Carrega Limite configurado externamente (planejamento anual, revisões trimestrais) e expõe Saldo Disponível derivado de Limite menos comprometimentos ativos. Identificado de forma determinística a partir do compromisso aceito em CMT (escopo, partes, referência contratual de CTR)."
		category:   "entity"
		rationale:  "SoT canônico de BDG per bd-cost-center-as-sot. Vocabulário estabelecido em controladoria — adotá-lo alinha BDG com profissionais (controllers) e instrumentos existentes (ERPs). Tratado como entity porque tem identidade persistente e ciclo de vida (criação, ajuste de limite, descontinuação) governado externamente. Topologia de centros de custo NÃO é decidida em BDG — é input externo (bd-allocation-not-treasury)."
		antiTerms: [{
			term:          "Conta Contábil"
			clarification: "Conta contábil é estrutura do plano de contas (DRE/Balanço) usada para reconhecimento contábil. Centro de custo é unidade de planejamento e controle de comprometimento. Mapeamento entre os dois pertence a controladoria, não a BDG."
		}, {
			term:          "Projeto"
			clarification: "Projeto é construto operacional (uma obra, uma iniciativa) que pode consumir um ou múltiplos centros de custo. BDG opera sobre centros de custo; agregação por projeto é responsabilidade do consumer (controller, reporting)."
		}]
		examples: [{
			context:   "Vertical construção civil"
			instance:  "Centro de custo CC-2026-OBRA-XYZ-CONCRETO com Limite anual de R$ 4.500.000, Saldo Disponível corrente de R$ 1.200.000. Compromisso de fornecimento de concreto da obra XYZ é registrado contra este centro após aprovação."
			rationale: "Demonstra granularidade típica de centro de custo na vertical âncora — combinação obra + categoria de insumo, com limite anual derivado de planejamento."
		}]
		relatedTerms: ["term-saldo-disponivel", "term-limite-de-centro-de-custo", "term-comprometimento-orcamentario", "term-cobertura-orcamentaria"]
	}, {
		code:       "term-saldo-disponivel"
		name:       "Saldo Disponível"
		termEn:     "Available Balance"
		definition: "Valor remanescente de um Centro de Custo passível de novo Comprometimento Orçamentário, calculado como Limite vigente menos soma de comprometimentos ativos (não liberados) registrados contra o centro. Consultado pelo gate determinístico e exposto via QueryCostCenterAvailability."
		category:   "value"
		rationale:  "Saldo é o input numérico primário do gate de cobertura. Termo canônico evita confusão com 'caixa disponível' (TCM) e com 'saldo realizado' (contabilidade financeira). Saldo Disponível em BDG é estritamente prospectivo: reflete o que ainda pode ser comprometido, não o que ainda pode ser pago."
		antiTerms: [{
			term:          "Saldo de Caixa"
			clarification: "Saldo de caixa é posição de liquidez (TCM). Saldo Disponível em BDG é capacidade de comprometimento — pode ser positivo mesmo quando caixa é zero, ou negativo de capacidade mesmo com caixa abundante."
		}, {
			term:          "Saldo Realizado"
			clarification: "Saldo realizado é dimensão de contabilidade financeira (o que foi efetivamente gasto). Saldo Disponível é prospectivo — opera sobre comprometimento, não sobre realização."
		}]
		relatedTerms: ["term-centro-de-custo", "term-limite-de-centro-de-custo", "term-comprometimento-orcamentario"]
	}, {
		code:       "term-limite-de-centro-de-custo"
		name:       "Limite de Centro de Custo"
		termEn:     "Cost Center Limit"
		definition: "Teto configurado externamente que delimita o total de Comprometimento Orçamentário admissível em um Centro de Custo durante um ciclo de planejamento. Ingerido como configuração; ajustes (aumento ou redução) são supervisedDecisions com justificativa documentada — BDG não realoca autonomamente entre centros."
		category:   "value"
		rationale:  "Limite é a configuração que sustenta o cálculo de Saldo Disponível e a invariante de cobertura. Termo separado de Saldo Disponível porque Limite é input estável (mudanças são governadas) enquanto Saldo é derivado em runtime. Decisão de alocação entre centros pertence à diretoria financeira (bd-allocation-not-treasury), não ao agente operador — explicitar como termo torna a fronteira de governance visível na UL."
		antiTerms: [{
			term:          "Orçamento"
			clarification: "'Orçamento' no uso coloquial agrupa plano + alocação + execução. Limite de Centro de Custo é especificamente o teto alocado a um centro — uma faceta dentro do que se chama informalmente 'orçamento'."
		}]
		rejectedAlternatives: [{
			term:   "Teto Orçamentário"
			reason: "Termo ambíguo entre múltiplos níveis (departamento, projeto, conta contábil, conglomerado) — não nomeia o sujeito do limite. 'Limite de Centro de Custo' explicita que o teto é por centro, alinhado com bd-cost-center-as-sot como unidade canônica."
		}, {
			term:   "Dotação"
			reason: "'Dotação' é vocabulário do setor público (orçamento público, LOA). Mesh opera no setor privado — usar termo público introduz acoplamento semântico inadequado."
		}]
		relatedTerms: ["term-centro-de-custo", "term-saldo-disponivel"]
	}, {
		code:       "term-comprometimento-orcamentario"
		name:       "Comprometimento Orçamentário"
		termEn:     "Budget Commitment"
		definition: "Reserva de valor contra um Centro de Custo registrada no Event Log de BDG no momento da aprovação de um compromisso. Reduz Saldo Disponível enquanto ativo; é liberado quando o compromisso é cancelado em CMT, executado integralmente em FCE ou ajustado por supervisão. Distinto de pagamento (FCE) e de realização contábil."
		category:   "value"
		rationale:  "Conceito que diferencia BDG de FCE e da contabilidade: comprometimento é prospectivo e operacional, opera sobre planejamento. Sem termo canônico, agentes confundem com 'pagamento agendado' (TCM/FCE) ou 'despesa reconhecida' (contábil). bd-commitment-not-payment exige termo explícito para sustentar a fronteira."
		antiTerms: [{
			term:          "Pagamento"
			clarification: "Pagamento é execução financeira efetiva em FCE. Comprometimento é reserva orçamentária prospectiva. Um comprometimento gera pagamento futuro (potencialmente múltiplos), mas não é pagamento."
		}, {
			term:          "Despesa"
			clarification: "Despesa é reconhecimento contábil (regime de competência). Comprometimento é controle orçamentário prospectivo — pode existir sem despesa reconhecida (compromisso aceito mas não executado) e despesa pode existir sem comprometimento ativo (após liberação)."
		}, {
			term:          "Encargo"
			clarification: "Encargo no sentido de contabilidade gerencial (accrual) é passivo contábil estimado. Comprometimento opera no plano orçamentário, não no balanço — não cria passivo contábil. (Note: 'encargo' em BR coloquial também significa obrigação fiscal/trabalhista — sentido distinto e fora do escopo do antiterm)."
		}]
		rejectedAlternatives: [{
			term:   "Reserva Orçamentária"
			reason: "Aceitável mas confunde com 'reserva de contingência' (provisão para imprevistos) ou 'reserva técnica' (vocabulário securitário). 'Comprometimento' captura melhor a vinculação a um compromisso CMT específico."
		}, {
			term:   "Encumbrance"
			reason: "Termo idiomático em controladoria pública anglófona; sem equivalência semântica precisa em controladoria privada brasileira. Importação criaria opacidade sem ganho."
		}]
		relatedTerms: ["term-centro-de-custo", "term-saldo-disponivel", "term-cobertura-orcamentaria", "term-liberacao-de-comprometimento", "term-budget-commitment-released"]
		layerMapping: {
			codeTerm: "BudgetCommitment"
			apiTerm:  "budget_commitments"
			uiLabel:  "Comprometimento"
		}
	}, {
		code:       "term-alcada"
		name:       "Alçada"
		termEn:     "Alcada"
		definition: "Faixa de valor dentro da qual um ator (agente operador ou supervisor humano) pode autorizar Aprovação Orçamentária sem escalação. Configurada externamente em tabela vigente; valores acima da alçada do ator exigem escalação ao supervisor (supervisedDecision approve-budget-out-of-alcada). Aprovação fora de alçada por agente viola mech-agent-gate."
		category:   "rule"
		rationale:  "Alçada é o segundo input do gate de cobertura (junto com Saldo Disponível) per capability cc-03 e businessDecision bd-coverage-as-invariant. Termo canônico evita confusão com 'permissão' (controle de acesso técnico em IDC) — alçada é regra de negócio sobre quanto cada papel pode autorizar. termEn usa 'Alcada' sem acento por constraint ASCII do schema #Glossary; a UL em português permanece 'Alçada'. Loanword preservado (vs traduções como Approval Authority ou Authority Level) porque traduções perdem a especificidade do conceito brasileiro de governance financeira (precedente: IDC manteve 'Score' como loanword)."
		antiTerms: [{
			term:          "Permissão de Acesso"
			clarification: "Permissão de acesso (autorização técnica) decide se ator pode invocar um command. Alçada decide o teto de valor que o ator autorizado pode aprovar. Permissão é binária por operação; alçada é numérica por valor."
		}, {
			term:          "Teto Total de Centro de Custo"
			clarification: "O teto agregado de um centro restringe o total comprometido contra o centro (vide Limite de Centro de Custo). Alçada restringe o valor que cada ator pode aprovar individualmente. Um compromisso pode estar dentro do teto do centro mas exceder a Alçada do ator — exige escalação."
		}]
		rejectedAlternatives: [{
			term:   "Limite de Aprovação"
			reason: "Confunde com Limite de Centro de Custo na mesma UL. 'Alçada' é termo estabelecido em governance financeira brasileira para esta noção específica e não compete com Limite no glossário."
		}, {
			term:   "Approval Authority"
			reason: "Tradução aproximada; perde a especificidade do conceito brasileiro. Loanword preserva precisão semântica."
		}]
		relatedTerms: ["term-cobertura-orcamentaria", "term-aprovacao-orcamentaria", "term-fracionamento"]
	}, {
		code:       "term-aprovacao-orcamentaria"
		name:       "Aprovação Orçamentária"
		termEn:     "Budget Approval"
		definition: "Processo determinístico que recebe sinal de CommitmentAccepted (CMT), identifica Centro de Custo aplicável, executa Gate de Cobertura (Saldo Disponível + Alçada), registra Comprometimento Orçamentário em caso de aprovação e publica decisão (BudgetApproved ou BudgetRejected). Operado 24/7 pelo agente per cc-03; humano supervisor atua por exceção."
		category:   "process"
		rationale:  "Capability primária de BDG. Termo canônico distingue de 'aprovação de compromisso' (CMT — bilateral) e de 'aprovação de pagamento' (FCE — execução). Aprovação Orçamentária é especificamente o gate de cobertura no commitment lifecycle."
		relatedTerms: ["term-gate-de-cobertura", "term-cobertura-orcamentaria", "term-approve-budget", "term-budget-approved", "term-comprometimento-orcamentario"]
	}, {
		code:       "term-gate-de-cobertura"
		name:       "Gate de Cobertura"
		termEn:     "Coverage Gate"
		definition: "Mecanismo determinístico que, para cada solicitação de Aprovação Orçamentária, avalia duas invariantes em sequência: (1) Saldo Disponível em Centro de Custo identificado é suficiente; (2) valor do compromisso está dentro da Alçada do ator. Falha em qualquer invariante bloqueia aprovação e dispara rejeição com motivo estruturado ou escalação supervisionada."
		category:   "rule"
		rationale:  "Gate de Cobertura é a materialização operacional de Cobertura Orçamentária — a regra que produz a invariante. Termo separado porque agentes precisam referenciar o mecanismo em si (sequência de checks, motivo de rejeição estruturado, comportamento em escalação) distinto da propriedade que ele garante."
		antiTerms: [{
			term:          "Workflow de Aprovação"
			clarification: "Workflow conota sequência de etapas humanas. Gate de Cobertura é check determinístico instantâneo — não é workflow. Aprovações fora de alçada saem do gate para escalação (mech-agent-gate)."
		}]
		relatedTerms: ["term-cobertura-orcamentaria", "term-aprovacao-orcamentaria", "term-saldo-disponivel", "term-alcada"]
	}, {
		code:       "term-approve-budget"
		name:       "Aprovar Cobertura Orçamentária"
		termEn:     "Approve Budget"
		definition: "Command sync que solicita Aprovação Orçamentária para um CommitmentId. Aceito quando Gate de Cobertura aprova determinísticamente OU supervisor humano autoriza dentro do escopo de governance. Resultado: registro de Comprometimento Orçamentário e publicação de BudgetApproved."
		category:   "command"
		rationale:  "Command canônico do BC declarado no canvas (communication.inbound). Sync porque downstream (DLV) precisa de decisão determinística antes de progredir no commitment lifecycle. Distinto do par RejectBudget — separação explícita aceita/rejeita evita acoplamento implícito de result code."
		relatedTerms: ["term-aprovacao-orcamentaria", "term-budget-approved", "term-gate-de-cobertura", "term-reject-budget"]
		layerMapping: {
			codeTerm: "ApproveBudget"
			apiTerm:  "budget_approvals"
			uiLabel:  "Aprovar Cobertura"
		}
	}, {
		code:       "term-reject-budget"
		name:       "Rejeitar Cobertura Orçamentária"
		termEn:     "Reject Budget"
		definition: "Command sync que solicita registro de rejeição de Aprovação Orçamentária para um CommitmentId quando Gate de Cobertura conclui ausência de cobertura (Saldo Disponível insuficiente, Centro de Custo inválido, Alçada excedida sem aprovação supervisora). Resultado: publicação de BudgetRejected com motivo estruturado. Não cancela o compromisso em CMT — apenas sinaliza ausência de cobertura."
		category:   "command"
		rationale:  "Par direto de ApproveBudget no canvas. Sync por exigência de feedback imediato a CMT para atualização de estado do compromisso. Termo canônico explícito (em vez de tratar rejeição como result negativo de ApproveBudget) preserva auditabilidade do motivo de rejeição como fato de primeira classe."
		relatedTerms: ["term-aprovacao-orcamentaria", "term-budget-rejected", "term-gate-de-cobertura", "term-approve-budget"]
		layerMapping: {
			codeTerm: "RejectBudget"
			apiTerm:  "budget_rejections"
			uiLabel:  "Rejeitar Cobertura"
		}
	}, {
		code:       "term-budget-approved"
		name:       "BudgetApproved"
		termEn:     "Budget Approved"
		definition: "Evento de domínio publicado quando Gate de Cobertura aprova um compromisso e Comprometimento Orçamentário é registrado contra Centro de Custo. Sinal canônico de progressão no commitment lifecycle — DLV consome para habilitar verificação de execução. Spine commitment-lifecycle no context-map (bdg-to-dlv, async)."
		category:   "event"
		rationale:  "Evento outbound mais importante de BDG — único declarado em context-map como spine. Nome em PascalCase passado (Entity+Action) seguindo convenção do domain model. Termo canônico no glossário porque o nome em inglês aparece em código, contratos e logs cross-context — agentes precisam de referência única."
		examples: [{
			context:  "Spine commitment-lifecycle"
			instance: "BudgetApproved {commitmentId: cmt-2026-0042, costCenterId: CC-2026-OBRA-XYZ-CONCRETO, approvedAt: 2026-04-15T10:32:18Z, approvedBy: bdg-primary-agent}. Consumido por DLV que habilita workflow de verificação de execução."
		}]
		relatedTerms: ["term-aprovacao-orcamentaria", "term-approve-budget", "term-comprometimento-orcamentario"]
		layerMapping: {
			codeTerm: "BudgetApproved"
		}
	}, {
		code:       "term-budget-rejected"
		name:       "BudgetRejected"
		termEn:     "Budget Rejected"
		definition: "Evento de domínio publicado quando Gate de Cobertura conclui ausência de cobertura para um compromisso, com motivo estruturado (insufficient-balance, invalid-cost-center, alcada-exceeded). CMT consome para atualizar estado do compromisso; DRC pode consumir para contexto de disputa. Publicação direta para CMT/DRC pendente de formalização no context-map (oq-bdg-2)."
		category:   "event"
		rationale:  "Par de BudgetApproved — preserva rejeição como fato auditável de primeira classe. Estruturação do motivo é deliberada: permite consumers reagirem programaticamente (revisão de centro de custo, escalação, renegociação) sem parsing de string. Status de propagação (relação direta vs query polling) é openQuestion ativa."
		examples: [{
			context:  "Rejeição por saldo insuficiente"
			instance: "BudgetRejected {commitmentId: cmt-2026-0073, costCenterId: CC-2026-OBRA-XYZ-CONCRETO, rejectedAt: 2026-04-22T14:08:42Z, reason: insufficient-balance, requestedAmount: 800000, availableBalance: 320000}. CMT atualiza estado do compromisso para 'pending-coverage-review'; humano controller decide se renegocia escopo, troca centro de custo ou solicita ajuste de limite."
		}]
		relatedTerms: ["term-reject-budget", "term-cobertura-orcamentaria", "term-aprovacao-orcamentaria"]
		layerMapping: {
			codeTerm: "BudgetRejected"
		}
	}, {
		code:       "term-budget-commitment-released"
		name:       "BudgetCommitmentReleased"
		termEn:     "Budget Commitment Released"
		definition: "Evento de domínio publicado quando Liberação de Comprometimento é executada — Comprometimento Orçamentário previamente registrado é revertido e o valor é devolvido ao Saldo Disponível do Centro de Custo. CMT consome para manter consistência interna do estado do compromisso. Publicação direta para CMT pendente de formalização no context-map (oq-bdg-2) — enquanto não declarada, evento permanece em audit trail interno."
		category:   "event"
		rationale:  "Completa o trio de eventos canônicos de BDG (BudgetApproved, BudgetRejected, BudgetCommitmentReleased) — paralelismo importante porque cada evento é fato auditável de primeira classe. Modelar como term mesmo pre-formalização cross-BC é consistente com como cmt/npm modelam eventos publicados (event como entity de UL existe independente de quem consome)."
		relatedTerms: ["term-liberacao-de-comprometimento", "term-comprometimento-orcamentario", "term-saldo-disponivel"]
		layerMapping: {
			codeTerm: "BudgetCommitmentReleased"
		}
	}, {
		code:       "term-liberacao-de-comprometimento"
		name:       "Liberação de Comprometimento"
		termEn:     "Budget Commitment Release"
		definition: "Reversão de Comprometimento Orçamentário previamente registrado, devolvendo o valor reservado ao Saldo Disponível do Centro de Custo. Disparada por cancelamento em CMT, ajuste supervisionado ou conclusão integral de execução em FCE. Fato auditável no Event Log; protocolo de publicação direta para CMT pendente de formalização (oq-bdg-2)."
		category:   "process"
		rationale:  "Sem termo canônico para liberação, agentes confundem com 'estorno' (contábil) ou 'reembolso' (FCE). Liberação é estritamente operação orçamentária — devolve capacidade de comprometimento sem efeito em caixa nem em contabilidade. Necessária para invariante de Saldo Disponível refletir realidade após cancelamentos. termEn 'Budget Commitment Release' (em vez de 'Commitment Release') desambigua de CMT compromisso — o sujeito da liberação é o budget commitment, não o compromisso CMT em si."
		antiTerms: [{
			term:          "Estorno"
			clarification: "Estorno é reversão contábil de lançamento. Liberação é devolução de capacidade orçamentária — opera sobre comprometimento, não sobre lançamento contábil."
		}, {
			term:          "Reembolso"
			clarification: "Reembolso é devolução de pagamento efetuado (FCE). Liberação opera sobre comprometimento prospectivo — não há fluxo financeiro associado."
		}]
		relatedTerms: ["term-comprometimento-orcamentario", "term-saldo-disponivel", "term-centro-de-custo", "term-budget-commitment-released"]
		layerMapping: {
			codeTerm: "BudgetCommitmentRelease"
			uiLabel:  "Liberação"
		}
	}, {
		code:       "term-fracionamento"
		name:       "Fracionamento"
		termEn:     "Fragmentation"
		definition: "Padrão adversarial em que um proponente subdivide deliberadamente um compromisso de valor superior à Alçada em múltiplos sub-compromissos abaixo do threshold, com mesmo par de partes e janela temporal curta, para evitar escalação supervisionada. Detecção é responsabilidade compartilhada com REW por agregação cross-compromisso (oq-bdg-1); ocorrência detectada dispara escalation criterion fragmentation-pattern-detected."
		category:   "rule"
		rationale:  "Fracionamento é vetor de manipulação explícito no incentiveAnalysis do canvas (sh-01) e escalation criterion ativo. Modelar como termo canônico (rule/anti-pattern) torna o conceito visível na UL — agentes referenciam o padrão pelo nome em código de detecção, em escalações e em revisões. Termo familiar em controladoria brasileira (paralelo a 'fracionamento de despesa' como anti-pattern em compras públicas — Lei 8.666 — embora Mesh seja setor privado, o conceito de threshold gaming é o mesmo)."
		antiTerms: [{
			term:          "Parcelamento"
			clarification: "Parcelamento é divisão legítima de execução ou pagamento com cronograma acordado bilateralmente. Fracionamento é divisão deliberada para contornar Alçada — diferença está na intenção e no padrão temporal/relacional, não na divisão em si."
		}]
		rejectedAlternatives: [{
			term:   "Threshold Gaming"
			reason: "Idiomático em segurança/incentivo design mas opaco em conversa de domínio com controllers brasileiros. 'Fracionamento' é termo familiar em controladoria para esta categoria de comportamento."
		}]
		relatedTerms: ["term-alcada", "term-aprovacao-orcamentaria"]
	}]

	rationale: "UL de BDG organiza-se em torno do conceito-âncora Cobertura Orçamentária e seu mecanismo (Gate de Cobertura): unidade canônica de comprometimento (Centro de Custo) com seus inputs numéricos (Saldo Disponível, Limite de Centro de Custo) e regra de autorização (Alçada — preservada como loanword sem tradução); o processo (Aprovação Orçamentária) com seus commands de entrada (Aprovar/Rejeitar Cobertura Orçamentária) e trio canônico de eventos de saída (BudgetApproved spine para DLV, BudgetRejected, BudgetCommitmentReleased — últimos dois pendentes de formalização cross-BC mas modelados como UL terms para preservar paralelismo); o efeito persistente (Comprometimento Orçamentário) e sua reversão (Liberação de Comprometimento, com termEn verboso 'Budget Commitment Release' para desambiguar de CMT compromisso); e o vetor adversarial canônico (Fracionamento) elevado a termo para visibilidade na UL. Termos universais financeiros (pagamento, despesa, conta contábil) NÃO entram — são tratados como antiTerms para fortalecer fronteiras com FCE, contabilidade e TCM. Estados de aprovação (pendente, aprovada, rejeitada, liberada) NÃO viram terms separados per anti-fragmentação — são derivados do lifecycle de Comprometimento Orçamentário. Queries surfaces (QueryBudgetApprovalStatus, QueryCostCenterAvailability) NÃO viram terms — são service-contract concerns consistentes com pattern dos 3 exemplos. Vocabulary respeita convenções brasileiras de controladoria (Centro de Custo, Saldo Disponível, Limite, Alçada, Comprometimento, Aprovação, Liberação, Fracionamento, Cobertura) com loanword justificada onde inglês perderia precisão (Alçada). domainModelRefs permanecem vazios — o domain-model.cue de BDG já existe; o preenchimento dos refs é trabalho futuro."
}
