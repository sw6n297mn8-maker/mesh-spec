package domain

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// stakeholder-map.cue — Catálogo canônico dos stakeholders do ecossistema.
//
// RE-AUTORADO no WI-157 (resolve def-076): a instância anterior usava a
// shape v0 (type/role/influence/concerns/interactsWith) e passava cue vet
// SEM unificar com #StakeholderMap — drift silencioso registrado no
// def-076 (Tempo 1, 2026-07-05). Esta re-autoria unifica com o schema
// evoluído; os 4 campos v0 sem destino caem com a justificativa que o
// próprio schema registra (meshInteraction→canvas; influence→consequência;
// interactsWith→frágil; role→absorvido em description/platformRelationships)
// — o que tinha valor migrou para description/rationale, nada caiu mudo.
//
// IDS PRESERVADOS: sh-01..sh-06 mantêm os codes consumidos (31/24/10/14/
// 30/6 refs estruturais nos canvases, verificado por grep na fatia; a
// story consome sh-01/sh-02 como actorRef). NOVOS: sh-07/08/09 — as
// personas intra-org do lado-comprador que o adr-172 item 5 declarou
// absorvidas em sh-01 Phase 0 e o passo 9 da ds-buyer-procurement-journey
// exigia separadas (preparador × aprovador). Personas são archetypes de
// PESSOA no fluxo interno da originadora — posições no fluxo da
// organização, NÃO tipos cadastrais de participante (adr-172 intocado:
// o npm segue sem papel algum).
//
// sh-06 entra na categoria adversarial-actor-class (adr-181 — extensão
// do enum; os 6 canvases consumidores referenciam por id estável,
// verificado por leitura: zero refs à categoria).
//
// CALIBRAÇÕES D4 (founder, 2026-07-29): sh-03 com vetores DERIVADOS DE
// DOMÍNIO FINANCEIRO (não de canvas — declarado nos rationales); sh-04
// com ce-02 como espelho honesto na description da dor (sem dor
// inventada); costRefs das personas derivados da story com LACUNA
// NOMEADA onde o fit no ce existente é imperfeito — sem ce novo nesta
// fatia.

stakeholderMap: artifact_schemas.#StakeholderMap & {
	description: "Atores do ecossistema Mesh: participantes da cadeia produtiva da construção civil, personas intra-organização do lado-comprador (WI-157), instituições financeiras, reguladores, o operador-agente da plataforma e a classe adversarial canônica."

	stakeholders: [{
		code:        "sh-01"
		name:        "Construtora"
		description: "Empresa responsável pela execução da obra — a ORGANIZAÇÃO originadora de demanda. Contrata fornecedores, gerencia cronograma e é tomadora de crédito. Nas relações da rede ocupa posições (originadora no p2p; tomadora no crédito) — papéis são posicionais, nunca atributo de cadastro (adr-172). As personas internas do seu lado-comprador (sh-07 engenheiro requisitante, sh-08 comprador, sh-09 gestor aprovador) são archetypes próprios desde o WI-157; sh-01 permanece a entidade organizacional que os canvases referenciam."
		category:    "network-participant"
		platformRelationships: ["direct-user"]
		interests: [{
			code:        "int-cheaper-credit"
			description: "Acesso a crédito com custo menor que o mercado, lastreado na operação real da obra."
			priority:    "critical"
			rationale:   "Motivo econômico primário de adesão da organização — herdado do concern v0; sustentado por ce-05 (o spread de intermediação sem vantagem informacional é o custo que a Mesh internaliza)."
		}, {
			code:        "int-cashflow-visibility"
			description: "Visibilidade do fluxo de caixa da obra — compromissos, vencimentos e cobertura num plano só."
			priority:    "important"
			rationale:   "Concern v0 preservado; o fluxo de caixa é o que evita a obra quebrar (fonte: narrativa da ds-buyer-procurement-journey, passo da negociação)."
		}, {
			code:        "int-operational-simplicity"
			description: "Simplicidade operacional na submissão de evidências e demandas — o canteiro não opera sistemas complexos."
			priority:    "important"
			rationale:   "Concern v0 preservado; a fricção operacional é o limite de adoção na ponta (passos 1-2 da jornada)."
		}]
		painPoints: [{
			code:        "pp-intermediation-spread"
			description: "Paga spread bancário por intermediação que não agrega informação — quem tem o dado operacional da obra é a rede, não o banco."
			costRef:     "ce-05"
			severity:    "degrading"
			rationale:   "ce-05 nomeia sh-01 como bearer explícito ('Tomador de crédito (sh-01)') — mapeamento direto."
		}, {
			code:        "pp-manual-compliance"
			description: "Compliance documental manual da operação de crédito (CNDs, ARTs, alvarás, seguros) — dias de processo e múltiplos profissionais por operação."
			costRef:     "ce-02"
			severity:    "degrading"
			rationale:   "ce-02 nomeia 'tomador de crédito' como bearer — a construtora é a tomadora; exemplos do próprio ce (CNDs, ARTs) são da construção."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"Crédito mais barato lastreado na própria operação",
				"Obra sem ruptura de suprimento nem surpresa de caixa",
				"Trilha de auditoria que reduz custo de conformidade",
			]
			manipulationVectors: [{
				code:            "mv-fragmentation"
				description:     "Fracionar demanda de valor supra-threshold em múltiplas compras sub-threshold (mesma categoria, janela curta) para evitar o processo competitivo formal e os gates de aprovação."
				expectedBenefit: "Velocidade e escolha direcionada de fornecedor sem passar pelo ciclo SSC/alçada."
				attackSurface:   "p2p (emissão de POs sub-threshold — detection via prj-purchase-history-by-category) e bdg (Alçada gaming — o precedente que o glossário do bdg canonizou como Fracionamento)."
				rationale:       "Vetor verbatim do canvas do p2p (incentiveAnalysis sh-01: 'fragmentation pattern') e do precedente bdg; a detecção cross-PO existe exatamente por ele."
			}, {
				code:            "mv-maverick-abuse"
				description:     "Abusar do caminho supervisionado de exceção (maverick) de forma sustentada — emitir POs sem authority canônica alegando emergência que não é."
				expectedBenefit: "Bypass do RECTOR bd-procurement-requires-sourcing-authority mantendo aparência de conformidade (aprovação supervised existe)."
				attackSurface:   "p2p supervisedDecision approve-po-without-sourcing-authority; audit trail captura authorityRef ausente e maverick-rate sustained é métrica observável."
				rationale:       "Vetor verbatim do canvas do p2p (incentiveAnalysis sh-01: 'bypass do RECTOR via abuse do escape hatch supervised')."
			}]
			rationale: "A organização originadora tem os incentivos corretos dominantes (crédito/caixa/simplicidade), e os dois vetores conhecidos atacam os gates de compra — ambos com detection estrutural declarada nos canvases (dp-08). Os vetores de PERSONA (quem executa o fracionamento é o comprador; quem carimba o maverick é o gestor) vivem em sh-07/08/09."
		}
		rationale: "É o nó central da cadeia produtiva — sem construtora não há obra, e sem obra não há fluxo financeiro a intermediar (rationale v0 preservado). Permanece como entrada ORGANIZACIONAL após o WI-157: canvases referenciam sh-01 nas relações de BC (31 refs estruturais); as personas internas são archetypes próprios (sh-07/08/09) para a story e o modelo de identidade (WI-158) referenciarem com precisão."
	}, {
		code:        "sh-02"
		name:        "Fornecedor"
		description: "Empresa que fornece materiais ou serviços à construtora. Possui recebíveis vinculados a medições/entregas de obra; nas relações da rede ocupa a posição de fornecedor (adr-172 — a mesma organização pode ser compradora noutra relação). Cede recebíveis lastreados em evidência de entrega; participa de RFQs, cota, negocia (revisa a própria cotação — WI-161) e recebe pedidos."
		category:    "network-participant"
		platformRelationships: ["direct-user"]
		interests: [{
			code:        "int-shorter-receivable-cycle"
			description: "Redução do ciclo de recebimento (hoje 60-120 dias na construção civil)."
			priority:    "critical"
			rationale:   "Concern v0 preservado; é a dor mais aguda e o driver primário de adoção (ce-06 rationale verbatim)."
		}, {
			code:        "int-payment-transparency"
			description: "Transparência sobre status de pagamento — saber quando e quanto entra."
			priority:    "important"
			rationale:   "Concern v0 preservado; a assimetria informacional do ciclo é o que o fornecedor mais sofre (rationale v0)."
		}, {
			code:        "int-fair-anticipation-cost"
			description: "Custo de antecipação competitivo versus alternativas de mercado (desconto de duplicata, factoring)."
			priority:    "important"
			rationale:   "Concern v0 preservado; a antecipação só ganha adoção se o custo bater as alternativas."
		}]
		painPoints: [{
			code:        "pp-long-receivable-cycle"
			description: "Financia a cadeia involuntariamente: entrega o material e espera 60-120 dias sem visibilidade, arcando com o custo de capital do ciclo."
			costRef:     "ce-06"
			severity:    "blocking"
			rationale:   "ce-06 nomeia sh-02 como bearer explícito; blocking porque é o driver de entrada na rede (sem resolver, o fornecedor não adere — 'driver primário de adoção')."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"Receber mais cedo com custo justo, lastreado em entrega verificada",
				"Previsibilidade contratual (PO imutável pós-emissão)",
				"Relacionamento recorrente com compradores da rede (preferred designation)",
			]
			manipulationVectors: [{
				code:            "mv-renegotiation-pressure"
				description:     "Pressionar comprador ou agente por renegociação pós-PO (price drift sustentado) explorando a dependência operacional da obra em andamento."
				expectedBenefit: "Margem melhor no pedido específico após o lock-in operacional."
				attackSurface:   "p2p pós-emissão (PO imutável por design; override-rate sustained vira drift signal ao SSC)."
				rationale:       "Vetor verbatim do canvas do p2p (incentiveAnalysis sh-02); a imutabilidade do PO existe exatamente por ele."
			}, {
				code:            "mv-quotation-collusion"
				description:     "Coordenar com outros fornecedores para inflar cotações na RFQ (collusion upstream), degradando o mecanismo competitivo."
				expectedBenefit: "Preço artificialmente alto com aparência de competição."
				attackSurface:   "ssc (janela de RFQ; confidencialidade competitiva reduz superfície de coordenação; equalização e histórico por categoria expõem outliers)."
				rationale:       "Vetor verbatim do canvas do p2p ('collusion upstream que P2P só observa via override patterns') — o lar do risco é o ssc."
			}, {
				code:            "mv-low-balling"
				description:     "Cotar abaixo de range sustentável para vencer a RFQ e recuperar depois (renegociação, aditivo, qualidade) — o par do vetor de renegociação."
				expectedBenefit: "Vencer a decisão de sourcing com preço que não será honrado na prática."
				attackSurface:   "ssc (detecção estatística de cotação fora de range via prj-rfq-history-by-category — mediana + variância da categoria)."
				rationale:       "Vetor derivado do design response EXISTENTE do ssc ('anti-low-balling design response' do prj-rfq-history-by-category — o mecanismo de detecção nomeia o vetor que defende)."
			}]
			rationale: "O fornecedor tem o incentivo correto mais forte da rede (ce-06 blocking) e três vetores conhecidos — todos com design response estrutural já declarada (imutabilidade de PO; confidencialidade + equalização; detecção estatística). dp-08 satisfeito com fontes."
		}
		rationale: "É quem mais sofre com a assimetria informacional — entrega material mas depende de ciclos longos de pagamento sem visibilidade (rationale v0 preservado). Segundo lado de toda relação da cunha; ator do passo da cotação na jornada (actorRef do passo 6)."
	}, {
		code:        "sh-03"
		name:        "Instituição financeira parceira"
		description: "Banco ou fundo que fornece funding para operações de crédito intermediadas pela Mesh. Consome dados de risco e evidência para decisão de alocação de capital; não opera diretamente na plataforma."
		category:    "financial-institution"
		platformRelationships: ["indirect-beneficiary"]
		interests: [{
			code:        "int-verifiable-collateral"
			description: "Qualidade e verificabilidade do lastro dos recebíveis — evidência criptográfica em vez de laudo confiado."
			priority:    "critical"
			rationale:   "Concern v0 preservado; é a proposta de valor central da Mesh ao funder (ce-07)."
		}, {
			code:        "int-regulatory-conformity"
			description: "Conformidade regulatória da SCD nas operações que financia."
			priority:    "critical"
			rationale:   "Concern v0 preservado; funding institucional não entra em veículo não-conforme."
		}, {
			code:        "int-risk-adjusted-return"
			description: "Retorno ajustado ao risco das operações — spread compatível com a qualidade do lastro."
			priority:    "important"
			rationale:   "Concern v0 preservado; o capital é o input mais crítico do flywheel (ce-07 rationale)."
		}]
		painPoints: [{
			code:        "pp-manual-collateral-diligence"
			description: "Due diligence manual sobre lastro de recebíveis — auditoria caso a caso, cara e lenta, para verificar o que a evidência estruturada provaria programaticamente."
			costRef:     "ce-07"
			severity:    "degrading"
			rationale:   "ce-07 nomeia sh-03 como bearer explícito — mapeamento direto."
		}, {
			code:        "pp-opaque-risk-assessment"
			description: "Avaliação de risco com dados incompletos e auto-reportados (balanços, laudos) em vez de dados operacionais verificados da cadeia."
			costRef:     "ce-04"
			severity:    "degrading"
			rationale:   "ce-04 nomeia 'Financiador' como bearer — mapeamento direto; a rede resolve com dados de performance acumulados."
		}, {
			code:        "pp-costly-release-verification"
			description: "Custo de verificação presencial/laudo para liberar tranches financeiras (medição de obra, vistoria, laudo de engenheiro — R$2-5k por visita e dias de atraso)."
			costRef:     "ce-01"
			severity:    "degrading"
			rationale:   "ce-01 nomeia 'Financiador (banco, fundo, incorporadora)' como bearer — mapeamento direto."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"Portfólio com lastro verificável programaticamente",
				"Originação com custo de diligence marginal",
				"Visibilidade contínua da carteira (não snapshot trimestral)",
			]
			manipulationVectors: [{
				code:            "mv-portfolio-cherry-picking"
				description:     "Selecionar apenas os recebíveis de melhor qualidade da originação (adverse selection contra o veículo), deixando o risco residual concentrado na SCD/na rede."
				expectedBenefit: "Retorno ajustado superior extraído da assimetria de seleção, às custas da carteira remanescente."
				attackSurface:   "Interface de alocação de funding (critérios de elegibilidade de carteira; a mitigação clássica é regra de alocação pro-rata/aleatorizada e transparência de critérios)."
				rationale:       "DERIVADO DE DOMÍNIO FINANCEIRO, não de canvas (calibração D4 do founder): adverse selection em estruturas de funding é vetor clássico de originate-to-distribute; nenhum canvas modela hoje a interface de funding — quando o BC correspondente nascer, o vetor migra para análise por posição."
			}]
			rationale: "O funder viabiliza escala sem capital próprio proporcional (rationale v0) — e é participante economicamente ativo (categoria obrigada per tq-sm-04). Vetor único declarado com derivação de domínio explícita; refinamento por posição pertence ao canvas futuro da interface de funding."
		}
		rationale: "A Mesh como SCD origina e gerencia crédito, mas pode usar funding externo — o parceiro financeiro viabiliza escala sem capital próprio proporcional (rationale v0 preservado). 10 refs estruturais em canvases."
	}, {
		code:        "sh-04"
		name:        "Bacen"
		description: "Banco Central do Brasil. Regula SCDs, define requisitos prudenciais, de capital e de reporting. Define o envelope operacional da Mesh como SCD; compliance é constraint inviolável (nível 1 de conflictResolution). A dor registrada abaixo é o ESPELHO FISCALIZADOR do ce-02 (custo de compliance documental): a Mesh não elimina um custo DO regulador — reduz a opacidade que torna a supervisão cara, dando rastreabilidade estruturada ao que hoje é verificado documento a documento (calibração D4: espelho honesto, sem dor inventada)."
		category:    "government-authority"
		platformRelationships: ["regulator"]
		interests: [{
			code:        "int-prudential-conformity"
			description: "Conformidade prudencial e de capital da SCD."
			priority:    "critical"
			rationale:   "Concern v0 preservado; é o mandato primário do regulador sobre o veículo."
		}, {
			code:        "int-system-protection"
			description: "Proteção do sistema financeiro nacional — o veículo não pode ser vetor de risco sistêmico ou lavagem."
			priority:    "critical"
			rationale:   "Concern v0 preservado; KYC/AML e integridade legal são invioláveis no desenho da Mesh."
		}, {
			code:        "int-operation-traceability"
			description: "Transparência e rastreabilidade das operações — supervisão sobre dado estruturado, não sobre prosa."
			priority:    "important"
			rationale:   "Concern v0 preservado; o event log imutável e o audit trail são o que a Mesh oferece de melhor ao supervisor."
		}]
		painPoints: [{
			code:        "pp-opaque-supervision"
			description: "Supervisionar operações reconstituídas de documentos dispersos e auto-reportados — o espelho fiscalizador do custo de compliance documental (ce-02): quando a operação é opaca para o operador, é duplamente opaca para o supervisor."
			costRef:     "ce-02"
			severity:    "annoying"
			rationale:   "Calibração D4 do founder: ce-02 como espelho honesto — o bearer canônico do ce-02 é tomador/financiador; a entrada registra o REFLEXO no supervisor (rastreabilidade estruturada reduz custo de supervisão), sem inventar custo eliminado próprio do regulador. Severity annoying: fricção real, não impedimento do mandato."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"SCD conforme e supervisionável com custo baixo",
				"Rastreabilidade nativa das operações reguladas",
			]
			rationale: "Categoria government-authority é isenta de manipulationVectors (tq-sm-04): o regulador não transaciona no ecossistema — obrigatoriedade seria artificial (rationale do próprio critério)."
		}
		rationale: "Operar como SCD sem conformidade com o Bacen é ilegal; toda decisão de design deve ser compatível com o framework regulatório vigente (rationale v0 preservado). 14 refs estruturais em canvases."
	}, {
		code:        "sh-05"
		name:        "Agente de IA Mesh"
		description: "Agente autônomo que opera o sistema dentro de autonomy envelopes e gates determinísticos — o operador primário da plataforma (a Mesh é AI-operated). Recomenda decisões, executa operações aprovadas por gates, escala o que excede o envelope ao humano designado. Um agent-spec por BC declara capacidade; governance envelope declara autonomia."
		category:    "platform-operator"
		platformRelationships: ["direct-user"]
		interests: [{
			code:        "int-clear-autonomy-envelope"
			description: "Clareza dos limites de autonomia por domínio — o que pode executar, o que propõe, o que escala."
			priority:    "critical"
			rationale:   "Concern v0 preservado; envelope ambíguo é risco operacional e jurídico (dp-10)."
		}, {
			code:        "int-input-data-quality"
			description: "Disponibilidade e qualidade dos dados de entrada — signals estruturados, projections frescas."
			priority:    "important"
			rationale:   "Concern v0 preservado; agente sem dado degrada para escalação (insufficient-context)."
		}, {
			code:        "int-decision-traceability"
			description: "Rastreabilidade de cada decisão para auditoria — decide-vs-execute separados e registrados."
			priority:    "critical"
			rationale:   "Concern v0 preservado; a trilha é o que torna a operação por agente defensável (Lei 12.846, dp-10)."
		}]
		painPoints: [{
			code:        "pp-reconciliation-burden"
			description: "Reconciliação manual entre sistemas que discordam sobre o que aconteceu — trabalho que só existe porque as fontes divergem; os 3 SoTs imutáveis eliminam a divergência na origem."
			costRef:     "ce-03"
			severity:    "degrading"
			rationale:   "ce-03 nomeia 'Operador financeiro (SCD)' como bearer — o agente É o operador da SCD; mapeamento direto."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"Operar dentro do envelope com gates determinísticos (recomendar sem decidir o que é humano)",
				"Escalar honestamente quando contexto falta",
				"Trilha completa que reduz blast radius e responsabilidade residual",
			]
			manipulationVectors: [{
				code:            "mv-allocation-bias"
				description:     "Desvio sistemático da allocationPolicy declarada pelo SSC no roteamento multi-supplier — favorecer certos fornecedores em vez de convergir ao agregado."
				expectedBenefit: "Simplificação operacional (favorecer fornecedor conhecido) — drift, não fraude deliberada."
				attackSurface:   "p2p (prj-allocation-tracking compara emissão vs policy; sig-allocation-bias observável)."
				rationale:       "Vetor verbatim do canvas do p2p (incentiveAnalysis sh-05)."
			}, {
				code:            "mv-stale-cache-emission"
				description:     "Emitir POs sob cache de authority desatualizado (authority expirada/revogada) sem revalidação sync."
				expectedBenefit: "Latência menor evitando a consulta de revalidação."
				attackSurface:   "p2p (freshness do cache de authority; OBS drift metrics rastreiam)."
				rationale:       "Vetor verbatim do canvas do p2p (incentiveAnalysis sh-05)."
			}, {
				code:            "mv-collusion-with-originator"
				description:     "Coalizão agente↔originadora: emitir POs maverick em volume alinhado aos desejos de sh-01, normalizando a exceção supervisionada."
				expectedBenefit: "Aparência de operação fluida às custas do RECTOR de authority."
				attackSurface:   "p2p (correlação founder-approval-rate × maverick-rate sustained — founder review)."
				rationale:       "Vetor verbatim do canvas do p2p (incentiveAnalysis sh-05: 'coalizão sh-01-sh-05')."
			}]
			rationale: "Tratar o agente como stakeholder com vetores próprios é dp-08 aplicado ao operador (drift de agente é vetor real, não hipótese) — os 3 vetores têm detection declarada nos canvases; anti-mini-NIM e decide-vs-execute são as defesas transversais."
		}
		rationale: "Sem o agente como stakeholder explícito, decisões de design tratam IA como ferramenta em vez de ator — e o sistema perde coerência com sua tese central (ax-01, ax-02; rationale v0 preservado). Categoria platform-operator: o agente é o operador da rede (30 refs estruturais em canvases)."
	}, {
		code:        "sh-06"
		name:        "Adversário econômico"
		description: "Actor externo ou interno cuja função é extrair valor do sistema via exploração de incentivos econômicos. Não é fornecedor, comprador, banco ou operador legítimo — classe de actor cujos vetores R4+++ (delay attack, value concentration, probing distribuído, cancel-then-reissue laundering, coordenação cross-actor) representam intenção primária, não desvio comportamental. Identidade adversarial PRIMÁRIA, não derivada de stakeholders legítimos (por isso a categoria própria — adr-181)."
		category:    "adversarial-actor-class"
		platformRelationships: ["direct-user"]
		interests: [{
			code:        "int-value-extraction"
			description: "Capturar valor via exploração de gaps em incentivos econômicos."
			priority:    "critical"
			rationale:   "Concern v0 preservado — o 'interesse' da classe é a própria função adversarial; registrá-lo como interest mantém a análise simétrica (o design defende contra um otimizador, não contra ruído)."
		}, {
			code:        "int-detection-avoidance"
			description: "Evitar detecção via patterns adversariais sofisticados (classe R4+++)."
			priority:    "critical"
			rationale:   "Concern v0 preservado; a defesa multi-camada existe porque o adversário composto satisfaz mecanismos legítimos simultaneamente."
		}, {
			code:        "int-unmodeled-boundaries"
			description: "Identificar boundaries que o sistema NÃO modela (unknown event safety vs system-level unknown)."
			priority:    "important"
			rationale:   "Concern v0 preservado; o vetor estrutural de cego é exatamente o que a modelagem explícita do adversário combate."
		}]
		painPoints: [{
			code:        "pp-cumulative-detection-cost"
			description: "A dor que a Mesh IMPÕE (entrada invertida — dor do adversário é design response do sistema): detecção multi-camada encarece cada tentativa, e reputação cross-network degradada é custo cumulativo que persiste entre ataques."
			costRef:     "ce-04"
			severity:    "degrading"
			rationale:   "Entrada deliberadamente invertida: para a classe adversarial, painPoint registra o custo que o DESIGN impõe ao ataque — o espelho do ce-04 (dados de performance acumulados pela rede são o que torna o adversário detectável e o risco avaliável). Lacuna nomeada: não há ce 'custo imposto ao adversário' — ce-04 é o mecanismo mais próximo (a rede acumula o dado que o pune); sem ce novo nesta fatia (calibração D4)."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"Extração de valor não-detectada",
				"Assimetria persistente entre custo de ataque e custo de defesa",
			]
			manipulationVectors: [{
				code:            "mv-delay-attack"
				description:     "Usar disputa/atraso como instrumento de gaming — travar liquidação para extrair concessão."
				expectedBenefit: "Concessão ou vantagem de caixa extraída do atraso."
				attackSurface:   "drc (disputa como vetor clássico; a âncora de evidência torna alegação infundada não-progressiva por construção)."
				rationale:       "Vetor da definição R4+++ (v0) com lar declarado no canvas do drc (verificado por leitura na fatia)."
			}, {
				code:            "mv-value-concentration"
				description:     "Concentrar valor em poucos pontos de captura (single-actor concentration) para maximizar extração por ataque."
				expectedBenefit: "Payoff máximo por superfície comprometida."
				attackSurface:   "rew (detection de concentração single-actor é camada nomeada da defesa multi-camada)."
				rationale:       "Vetor da definição R4+++ (v0); rew é a origem do sh-06 canônico (WI-046)."
			}, {
				code:            "mv-distributed-probing"
				description:     "Sondar limites do sistema de forma distribuída (multi-actor, sub-threshold) para mapear o que não é detectado."
				expectedBenefit: "Mapa dos boundaries não-modelados com custo de detecção diluído."
				attackSurface:   "rew (multi-actor distribution detection) + bkr (side-channel inferral — vetor movido para sh-06, verificado por leitura)."
				rationale:       "Vetor da definição R4+++ (v0) com lares declarados em rew e bkr."
			}, {
				code:            "mv-cancel-then-reissue-laundering"
				description:     "Lavar valor via ciclo cancelar-e-reemitir — usar cancelamento legítimo como mecanismo de reciclagem."
				expectedBenefit: "Movimentação de valor sem prova correspondente, sob aparência de operação normal."
				attackSurface:   "fce (RequestSettlementCancellation — o canvas do fce cita o vetor verbatim como diretamente aplicável)."
				rationale:       "Vetor da definição R4+++ (v0) com lar declarado no canvas do fce (verificado por leitura)."
			}, {
				code:            "mv-cross-actor-coordination"
				description:     "Coordenar múltiplos atores (ou identidades) para satisfazer mecanismos legítimos simultaneamente — o adversário composto."
				expectedBenefit: "Passar por gates desenhados para atores individuais."
				attackSurface:   "scf (fraude de lastro coordenada — canvas cita sh-06 para forja/inflação de lastro) + rew (combined adversarial signals)."
				rationale:       "Vetor da definição R4+++ (v0); a modelagem em INV Round 2 SRR demonstrou empiricamente adversários compostos satisfazendo mecanismos legítimos (rationale v0 preservado)."
			}]
			rationale: "Vetores são a ESSÊNCIA da classe (adr-181: a categoria entra na lista de obrigados do tq-sm-04 exatamente por isso) — os 5 vetores R4+++ da definição v0 agora carregam attackSurface com lar verificado nos canvases que os citam (bkr/drc/fce/rew/scf)."
		}
		rationale: "Sem modelagem explícita de adversário canonical, sistemas implicitamente assumem que ele não existe — vetor estrutural de cego. Adversário como sh-06 canonical permite que BCs declarem manipulationVector + designResponse com identidade adversarial primária — não derivada de stakeholders legítimos. Introduzido em Phase 1 do REW canvas (WI-046); reusable cross-BC (rationale v0 preservado). Categoria adversarial-actor-class per adr-181; 6 canvases consumidores por id estável."
	}, {
		code:        "sh-07"
		name:        "Engenheiro requisitante"
		description: "Persona do lado-comprador: o engenheiro da construtora que, na visita técnica ao canteiro, identifica pelo cronograma físico o que as próximas etapas vão exigir e formaliza a solicitação de compra (passos 1-2 da ds-buyer-procurement-journey). Archetype de PESSOA no fluxo interno da originadora (sh-01) — posição no fluxo da organização, não tipo cadastral de participante (adr-172 intocado). Separado de sh-01 pelo WI-157 (fim da absorção Phase 0 do adr-172 item 5)."
		category:    "network-participant"
		platformRelationships: ["direct-user"]
		interests: [{
			code:        "int-frictionless-demand-capture"
			description: "Registrar a necessidade direto do canteiro, no momento da observação, sem retrabalho de escritório."
			priority:    "critical"
			rationale:   "Fonte: passos 1-2 da story ('na visita técnica diária... formaliza direto do canteiro') — a fricção da captura é o limite de adoção na ponta."
		}, {
			code:        "int-schedule-fidelity"
			description: "Materiais certos chegando no prazo que o cronograma físico exige — a demanda que ele origina não pode virar ruptura de etapa."
			priority:    "critical"
			rationale:   "Fonte: passo 1 ('o que as próximas etapas vão exigir — quantidades, especificações e prazos') e passo 10 ('prazo hábil para a entrega não interromper o cronograma')."
		}]
		painPoints: [{
			code:        "pp-untraceable-demand-origin"
			description: "A necessidade observada no canteiro vira demanda por canal informal (telefone, mensagem) — sem vínculo rastreável com a etapa do cronograma e o centro de custo que a originou; o dado operacional se perde na origem."
			costRef:     "ce-04"
			severity:    "degrading"
			rationale:   "Derivado da story (o exame original mediu 'zero elementos' nos passos 1-2 — a jornada real nascia fora do sistema). LACUNA NOMEADA (calibração D4): o bearer canônico do ce-04 é o financiador; a persona é o ELO onde o dado incompleto NASCE — o custo canônico por-persona não existe como ce e não nasce nesta fatia."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"Demanda registrada em segundos, com rastreabilidade automática à etapa e ao centro de custo",
				"Etapa do cronograma sem ruptura de material",
			]
			manipulationVectors: [{
				code:            "mv-fabricated-urgency"
				description:     "Fabricar urgência ('emergência de obra') para empurrar a demanda pelo caminho de exceção supervisionado, contornando triagem e processo competitivo."
				expectedBenefit: "Material mais rápido e/ou fornecedor de preferência pessoal, sem o ciclo formal."
				attackSurface:   "p2p (o caminho maverick supervisionado existe para emergências GENUÍNAS — o canvas nomeia o abuso do escape hatch; a fabricação de urgência é a forma-persona desse abuso na origem da demanda)."
				rationale:       "Derivado do vetor org-level do canvas do p2p ('usar maverick path apenas em emergências/exceções genuínas' — o desired behavior nomeia exatamente o desvio); a persona requisitante é quem declara a urgência."
			}]
			rationale: "A persona tem os incentivos mais alinhados da jornada (obra andando) e um vetor específico: a urgência é declarada por ela — dp-08 na origem da demanda."
		}
		rationale: "O passo 1 da jornada real nasce nesta persona — e o exame original da story mediu que o modelo começava 4 passos depois. Separá-la de sh-01 dá ao modelo de identidade (WI-158) e à story o ator preciso: quem OBSERVA e REGISTRA não é quem tria nem quem aprova. actorRef dos passos 1-2 re-apontado nesta fatia."
	}, {
		code:        "sh-08"
		name:        "Comprador"
		description: "Persona do lado-comprador: o profissional de suprimentos que tria a fila de requisições, verifica fornecedores homologados, abre a cotação, consolida o mapa, NEGOCIA com os melhores colocados e converte a aprovação em pedido (passos 3-5, 7-8 e 10 da ds-buyer-procurement-journey; o glossário do p2p canoniza term-comprador). Archetype de PESSOA no fluxo interno da originadora (sh-01) — posição no fluxo, não tipo cadastral (adr-172 intocado)."
		category:    "network-participant"
		platformRelationships: ["direct-user"]
		interests: [{
			code:        "int-competitive-sourcing"
			description: "Processo competitivo saudável — no mínimo três propostas comparáveis por cotação."
			priority:    "critical"
			rationale:   "Fonte: passo 5 da story ('pedindo no mínimo três propostas') — a régua que a persona usa."
		}, {
			code:        "int-payment-terms-leverage"
			description: "Condições de pagamento melhores — o eixo da negociação que protege o fluxo de caixa da obra."
			priority:    "critical"
			rationale:   "Fonte: passo 8 da story ('principalmente, melhorar as condições de pagamento — o fluxo de caixa é o que evita a obra quebrar'); estruturado no WI-161 (vo-payment-terms)."
		}, {
			code:        "int-comparable-map"
			description: "Comparação consolidada e equalizada (preço, prazo, condições, qualidade) em vez de planilha manual."
			priority:    "important"
			rationale:   "Fonte: passo 7 da story ('consolida o mapa de cotações... e compara') — o instrumento central da persona, materializado no prj-quotation-map."
		}]
		painPoints: [{
			code:        "pp-manual-quotation-map"
			description: "Consolidar cotações manualmente (planilha, e-mail, telefone) para comparar preço, prazo, condições e qualidade — a comparação que sustenta a escolha era invisível e não-auditável."
			costRef:     "ce-04"
			severity:    "degrading"
			rationale:   "Derivado da story (o exame original mediu a lacuna de leitura no coração da jornada — 'o modelo tinha o conceito mas NENHUMA projection consultável'). LACUNA NOMEADA (calibração D4): bearer canônico do ce-04 é o financiador; a persona sofre a forma operacional do mesmo custo (decisão sobre dado incompleto/manual) — sem ce por-persona nesta fatia."
		}, {
			code:        "pp-cashflow-blind-negotiation"
			description: "Negociar condições de pagamento sem instrumento — rodadas por telefone/e-mail, sem registro das contrapropostas nem do delta obtido; o que salva o caixa da obra não deixava rastro."
			costRef:     "ce-05"
			severity:    "degrading"
			rationale:   "Derivado do passo 8 da story (fechado pelo WI-161: rodadas registradas, preço inicial vs vigente observável). LACUNA NOMEADA (calibração D4): ce-05 é o custo de capital da organização (bearer sh-01) que a negociação da persona protege — o fit é pelo custo defendido, não por bearer; sem ce novo."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"Escolha defensável (mapa equalizado + rationale registrado)",
				"Condições finais melhores que a primeira proposta — com o delta visível",
				"Ciclo demanda-a-pedido curto sem atropelar o processo",
			]
			manipulationVectors: [{
				code:            "mv-fragmentation-execution"
				description:     "Executar o fracionamento: dividir a compra em POs sub-threshold (mesma categoria, janela curta) para ficar sob a alçada e evitar RFQ formal — a forma-persona do mv-fragmentation de sh-01."
				expectedBenefit: "Velocidade e/ou direcionamento a fornecedor preferido sem processo competitivo."
				attackSurface:   "p2p (prj-purchase-history-by-category — frequência por requester + categoria + janela + evidência de threshold gaming) e bdg (Alçada)."
				rationale:       "Vetor verbatim do canvas do p2p atribuído à originadora — quem OPERA a divisão é a persona compradora; a detecção por requester existe exatamente para localizar o operador."
			}, {
				code:            "mv-supplier-favoritism"
				description:     "Direcionar a escolha a fornecedor de preferência pessoal — via pool convidado enviesado, uso do maverick, ou condução da negociação para justificar o favorito."
				expectedBenefit: "Benefício relacional/pessoal às custas do processo competitivo (o vetor clássico de corrupção de compras)."
				attackSurface:   "ssc (pool qualificado por NPM + fitness rules versionadas + decisionRationale obrigatório + equalização determinística tornam o direcionamento visível) e p2p (maverick supervisionado)."
				rationale:       "Forma-persona do abuso de maverick/direcionamento que os canvases modelam org-level; as defesas do ssc (inv-decision-from-structured-signals, inv-decision-rationale-required) existem para tornar a escolha auditável contra exatamente isso."
			}]
			rationale: "O comprador é o protagonista operacional da jornada (6 dos 10 passos) e o operador humano dos dois vetores conhecidos do lado-comprador — dp-08 exige nomeá-los na persona que os executa, não só na organização."
		}
		rationale: "O protagonista assume a jornada na triagem (passo 3) e a conduz até o pedido (passo 10) — o glossário do p2p já canonizava term-comprador; o mapa agora dá à persona identidade própria para a story (actorRef dos passos 3-5, 7-8, 10) e para o modelo de identidade do WI-158 (quem prepara ≠ quem aprova)."
	}, {
		code:        "sh-09"
		name:        "Gestor aprovador"
		description: "Persona do lado-comprador: o gestor que revisa a compra preparada pelo comprador e APROVA por Alçada — o de-acordo humano do portão duplo pré-pedido (passo 9 da ds-buyer-procurement-journey; adr-174 braço de cobertura + adr-177 braço de procedência). Archetype de PESSOA no fluxo interno da originadora (sh-01) — posição no fluxo, não tipo cadastral (adr-172 intocado). A separação preparador (sh-08) × aprovador (sh-09) é a segregação que o passo 9 exigia e o def-076 deferiu."
		category:    "network-participant"
		platformRelationships: ["direct-user"]
		interests: [{
			code:        "int-informed-approval"
			description: "Aprovar com os dois braços provados — cobertura reservada (bdg) e procedência de preço contra a cotação vencedora (ssc) — em vez de confiar em prosa."
			priority:    "critical"
			rationale:   "Fonte: passo 9 da story ('garantindo alinhamento com o planejamento estratégico e financeiro') mecanizado pelo portão duplo adr-174/adr-177 — o instrumento da persona."
		}, {
			code:        "int-identifiable-accountability"
			description: "Responsabilidade identificável pelo de-acordo — quem aprovou, sob qual alçada, com que evidência."
			priority:    "critical"
			rationale:   "dp-10 (responsabilidade jurídica explícita) aplicado à persona; o slot de ator no envelope é o desenho do WI-158."
		}]
		painPoints: [{
			code:        "pp-uninstrumented-approval"
			description: "Aprovar compras revisando documentos dispersos, sem gate que prove cobertura e procedência — o de-acordo era assinatura sobre confiança, não sobre verificação."
			costRef:     "ce-02"
			severity:    "degrading"
			rationale:   "Derivado do passo 9 da story + rationale do exame original ('a atribuição do de-acordo a um papel-gestor específico aguarda os papéis intra-org'). LACUNA NOMEADA (calibração D4): ce-02 (compliance documental, bearer tomador) é o custo canônico mais próximo — a aprovação manual é uma das suas formas; sem ce por-persona nesta fatia."
		}]
		incentiveProfile: {
			desiredOutcomes: [
				"De-acordo rápido E defensável (os gates provam; o gestor decide)",
				"Alçada respeitada sem virar gargalo da obra",
			]
			manipulationVectors: [{
				code:            "mv-rubber-stamping"
				description:     "Aprovar exceções supervisionadas (maverick, pool insuficiente, divergência de valor) sem escrutínio — o carimbo que normaliza o caminho de exceção."
				expectedBenefit: "Fluidez operacional e menos atrito interno às custas do controle que a supervisão existe para exercer."
				attackSurface:   "p2p/ssc supervisedDecisions (o canvas do p2p nomeia o risco residual verbatim: 'maverick approvals sustained se founder aprovar sem escrutínio' — pre-PMF o aprovador é o founder; pós-PMF, esta persona) — taxa de aprovação supervised × maverick-rate é o observável."
				rationale:       "Risco residual nomeado no canvas do p2p elevado a vetor da persona: rubber-stamping é O vetor do papel aprovador — a segregação preparador×aprovador só protege se o aprovador exercer o escrutínio."
			}]
			rationale: "A persona existe para ser o controle humano do portão — seu vetor único é a abdicação desse controle; nomeá-lo é o que torna a taxa de supervised-approvals um observável de design, não só métrica operacional."
		}
		rationale: "O passo 9 da story exigia a separação preparador×aprovador que o mapa não tinha (adr-172 item 5: absorção Phase 0; def-076: re-autoria deferida) — sh-09 encerra a absorção e dá ao WI-158 o papel que o modelo de identidade referencia para o de-acordo por Alçada. actorRef do passo 9 re-apontado nesta fatia; termo de glossário do gestor entra com o desenho de identidade (lacuna nomeada no adr-172, fora desta fatia)."
	}]

	rationale: "Re-autoria completa na shape v1 (WI-157; resolve def-076): 9 archetypes — 2 organizações da cadeia (sh-01/sh-02), 3 personas intra-org do lado-comprador (sh-07/08/09 — fim da absorção Phase 0 do adr-172 item 5; a story re-aponta os actorRefs e o WI-158 ganha os papéis que o modelo de identidade referencia), 1 funder (sh-03, vetores derivados de domínio financeiro — calibração D4), 1 regulador (sh-04, ce-02 como espelho honesto sem dor inventada), o operador-agente (sh-05, platform-operator — vetores verbatim dos canvases) e a classe adversarial canônica (sh-06, adversarial-actor-class per adr-181 — os 5 vetores R4+++ com lares verificados nos 6 canvases consumidores). Todos os painPoints rastreiam a ce-01..07 do domain-definition; onde o fit por-persona é imperfeito, a lacuna está NOMEADA no rationale do painPoint (sem ce novo nesta fatia — calibração D4). Ids sh-01..06 preservados (115 refs estruturais em canvases seguem válidas); sh-07/08/09 aguardam referência de canvas (esperado: sc-sm-02 warn até a operacionalização das personas no WI-158+)."
}
