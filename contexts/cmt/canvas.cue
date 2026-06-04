package cmt

// canvas.cue — Bounded Context Canvas: Commitment Management.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// CMT é o ponto de formalização do commitment lifecycle.
// Recebe sinais upstream de P2P (pedido de compra spot) e de CTR
// (termos ativados via sourcing estratégico SSC→CTR→CMT).
// CommitmentId nasce aqui e permeia todos os contexts downstream.
//
// 3 rounds de red team + 4 ajustes do founder.

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

canvas: artifact_schemas.#Canvas & {
	code: "cmt"
	name: "Commitment Management"

	purpose: """
		Formalizar compromissos econômicos entre organizações com aceite
		mútuo bilateral, gerenciar o estado canônico do compromisso como
		entidade rastreável, e garantir que CommitmentId — o fio de
		rastreabilidade end-to-end do commitment lifecycle — nasça com
		integridade. Sem CMT como unidade separada, a criação e o aceite
		de compromissos ficam distribuídos entre contratos (CTR) e
		execução financeira (FCE), sem owner canônico do estado do
		compromisso. CMT é o ponto de entrada do commitment lifecycle:
		compromisso mal formalizado degrada verificação, faturamento e
		liquidação downstream.
		"""

	ubiquitousLanguageRef: "contexts/cmt/glossary.cue"

	// ==============================
	// CLASSIFICAÇÃO ESTRATÉGICA
	// ==============================

	classification: {
		subdomainType:    "core"
		businessRole:     "revenue-generator"
		wardleyEvolution: "custom"
		rationale: """
			Core porque a formalização de compromissos econômicos com aceite
			mútuo e rastreabilidade é proprietária da Mesh — não existe
			padrão de mercado. Revenue-generator porque todo fluxo financeiro
			da plataforma (antecipação, pagamento, liquidação) nasce de um
			compromisso formalizado em CMT. Custom porque a solução é
			proprietária mas o problema (formalização de acordos) é
			compreendido — não é genesis.
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode:            "vertical-adaptable"
		primaryVertical: "construction"
		rationale: """
			Os mecanismos centrais do CMT — aceite mútuo bilateral
			como invariante, CommitmentId como fio de rastreabilidade
			end-to-end, validação síncrona de termos contra CTR,
			communication patterns de command/event/query, e
			governance scope separando automação permitida,
			supervisão e escalation conforme criticidade decisória —
			são padrões universais de teoria dos contratos B2B e
			domain-driven design, reutilizáveis em qualquer cadeia
			produtiva com formalização de compromissos econômicos
			rastreáveis.

			Os pontos de variação por vertical estão explicitamente
			enumerados pelo próprio canvas como assumptions e open
			questions, configurando adaptable e não agnostic:

			- as-cmt-1 escopa "aceite bilateral síncrono" ao
			  "vertical de construção civil", reconhecendo que outros
			  verticais podem exigir workflow assíncrono multi-step.
			- as-cmt-3 reconhece que "construção civil demanda
			  compromissos hierárquicos (contrato guarda-chuva com
			  sub-compromissos por medição)" — vocabulário de obra
			  (medição) embebido na premissa de modelagem.
			- oq-cmt-2 declara textualmente: "Mesh planeja expansão
			  multi-vertical. Invariante que funciona na construção
			  civil pode não funcionar em logística ou energia",
			  autoatestando a fronteira vertical da invariante de
			  aceite bilateral.

			Stakeholders confirmam o anchoring construção: sh-01 é
			"Construtora — nó central da cadeia", proponente que
			"submete propostas vinculadas a contratos de obra". Os
			demais papéis (fornecedor, IF parceira, regulador, agente
			operador) são descritos em vocabulário neutro e
			reaproveitáveis cross-vertical.

			Não há validatedVerticals declaradas: o canvas só foi
			validado contra construção até o momento. Adaptação a
			logística, energia, agricultura ou manufatura exige
			revisão das três premissas enumeradas (sincronia,
			hierarquia, padrão cultural de aceite) — não revisão
			do núcleo.
			"""
	}

	// ==============================
	// DOMAIN ROLES
	// ==============================

	domainRoles: {
		primary: "execution"
		secondary: ["draft"]
		rationale: """
			Execution como primário: CMT opera o ciclo de vida do
			compromisso com gates determinísticos — proposta, negociação,
			confirmação bilateral. O gate de aceite mútuo é o ponto
			crítico. Draft como secundário: a fase de proposta e
			negociação envolve composição e formalização de termos antes
			do gate de confirmação.
			"""
	}

	// ==============================
	// CAPABILITIES
	// ==============================

	capabilities: {
		operational: [{
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua de compromissos: cada formalização,
				aceite e mudança de estado é registrada como fato imutável
				no Event Log, habilitando auditoria em tempo real.
				"""
			rationale: "Compromissos são a base do commitment lifecycle. Se não são auditáveis desde a formalização, a cadeia inteira perde rastreabilidade."
		}, {
			description: """
				Formalização automatizada de compromissos: agentes
				processam documentos de proposta, validam termos contra
				CTR, e preparam aceite bilateral. Gates determinísticos
				verificam invariantes de aceite mútuo antes de autorizar
				progressão.
				"""
			rationale: "Automatização via agentes com gates reduz custo de compliance documental (ce-02) e elimina latência humana no fluxo de formalização."
		}, {
			description: """
				Gestão de estado do compromisso: mantém o estado canônico
				(proposto, aceito, suspenso, cancelado) como SoT, publica
				transições como eventos, e reage a sinais externos (risco,
				disputas) que afetam compromissos ativos.
				"""
			rationale: "Sem SoT de estado, BCs downstream (BDG, DLV, DRC) operam sobre estado inconsistente ou desatualizado do compromisso."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// ==============================
	// COMUNICAÇÃO
	// ==============================

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Parte proponente submete proposta de compromisso com termos, partes e escopo."
			command:         "ProposeCommitment"
			resultingEvents: ["CommitmentProposed"]
			// [AJUSTE 3] Explicitar que CommitmentProposed é evento interno.
			description: "Inicia o ciclo de vida do compromisso. Agente valida completude e referências a termos contratuais (CTR). CommitmentProposed é evento interno do BC — não cruza fronteira. Serve como trigger para workflows internos de negociação e preparação de aceite."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Contraparte confirma aceite do compromisso proposto."
			command:         "ConfirmCommitmentAcceptance"
			resultingEvents: ["CommitmentAccepted"]
			description:     "Gate de aceite mútuo bilateral — invariante central do CMT. Sync porque a contraparte precisa de confirmação imediata."
		}, {
			type:          "event-consumer"
			sourceContext: "rew"
			event:         "CounterpartyRiskAlertRaised"
			reaction:      "Sinaliza compromissos ativos com contraparte sob risco elevado. Pode suspender formalização em andamento."
			description:   "REW retroalimenta CMT com deterioração de risco pós-formalização."
		}, {
			type:          "event-consumer"
			sourceContext: "rew"
			event:         "CounterpartyRiskAlertCleared"
			reaction:      "Remove sinalização de risco de compromissos at-risk cuja contraparte teve alerta resolvido. Retorna a accepted."
			description:   "REW retroalimenta CMT com resolução de alertas de risco. Par reverso de CounterpartyRiskAlertRaised."
		}, {
			type:          "event-consumer"
			sourceContext: "drc"
			event:         "DisputeResolved"
			reaction:      "Atualiza o compromisso conforme a resolução (enum local ACL #DisputeResolution {cancel | modify_terms | maintain}; canonicalização DRC deferida a def-047, per adr-143): cancel cancela; modify_terms revalida CTR (fail-closed) e é override autoritativo do DRC; maintain sobre suspended exige reativação supervisionada (não auto-reativa)."
		}, {
			type:          "event-consumer"
			sourceContext: "drc"
			event:         "CommitmentSuspensionOrdered"
			reaction:      "Suspende compromisso ativo por determinação de disputa."
		}, {
			type:          "event-consumer"
			sourceContext: "p2p"
			event:         "PurchaseOrderEmitted"
			reaction:      "Inicia formalização de compromisso econômico bilateral a partir de pedido de compra. Agente traduz pedido (demanda unilateral) para proposta de compromisso (bilateral) via ACL."
			description:   "P2P é upstream — pedido de compra precede compromisso no macrofluxo spot."
		}, {
			type:          "event-consumer"
			sourceContext: "ctr"
			event:         "ContractTermsActivated"
			reaction:      "Habilita referência a novos termos em compromissos futuros. Agente atualiza pool de termos disponíveis para formalização."
			description:   "CTR publica lifecycle de termos; CMT reage para manter referências válidas."
		}, {
			type:          "event-consumer"
			sourceContext: "ctr"
			event:         "ContractTermsSuperseded"
			reaction:      "Sinaliza que termos referenciados por compromissos existentes foram superseded. Compromissos existentes mantêm referência snapshot; novos compromissos devem usar versão active."
			description:   "CTR publica supersession; CMT reage para garantir que novos compromissos referenciam termos vigentes."
		}, {
			type:          "event-consumer"
			sourceContext: "ctr"
			event:         "ContractTermsCancelled"
			reaction:      "Sinaliza que termos referenciados foram invalidados (fraude, erro, regulatória). Compromissos ativos que referenciam termos cancelados devem ser avaliados — cancelamento é mais grave que supersession (invalidação irreversível, não substituição)."
			description:   "CTR publica cancelamento; CMT reage para identificar compromissos impactados por termos invalidados."
		}, {
			type:        "query-surface"
			query:       "QueryCommitmentState"
			returnType:  "CommitmentState"
			description: "Expõe estado canônico do compromisso para consulta por BCs downstream."
		}]
		outbound: [{
			type:        "event-publisher"
			trigger:     "Gate de aceite mútuo bilateral aprovado com sucesso."
			event:       "CommitmentAccepted"
			consumers:   ["bdg", "drc", "tcm", "inv"]
			description: "Sinal canônico de entrada no commitment lifecycle. BDG inicia aprovação orçamentária; DRC registra contexto para disputas futuras; TCM projeta obrigação futura na posição de caixa; INV materializa projection cache read-only de commitment terms para cômputo fiscal apply-only no momento de faturamento. Publicado SOMENTE na transição proposed→accepted (CommitmentStateChanged cobre as demais transições — sem sobreposição). Payload carrega termsHash + confirmedBy como evidência mech-evidence do aceite."
		}, {
			type:        "event-publisher"
			trigger:     "Transição de estado do compromisso por sinal externo (risco, disputa) ou ação interna (suspensão, cancelamento, reativação)."
			event:       "CommitmentStateChanged"
			consumers:   ["drc", "tcm"]
			description: "DRC consome para atualizar contexto de disputas com estado corrente do compromisso. TCM atualiza projeções de caixa."
		}, {
			type:          "query-dependency"
			targetContext: "ctr"
			query:         "QueryContractTerms"
			purpose:       "Validar que termos referenciados no compromisso existem e estão vigentes em CTR."
			description:   "CMT consome termos contratuais como pré-condição para formalização. ACL traduz modelo de CTR para linguagem de compromisso."
		}]
		rationale: """
			Inbound: 2 commands (proposta async + aceite bilateral sync),
			8 event consumers (risco e resolução de risco de REW +
			2 sinais de disputa de DRC + pedido de compra de P2P +
			3 sinais de lifecycle de termos de CTR), 1 query surface
			(estado canônico). Outbound: 2 event publishers
			(CommitmentAccepted para BDG/DRC/TCM + CommitmentStateChanged
			para DRC/TCM), 1 query dependency (termos contratuais de CTR).
			CommitmentProposed é evento interno — não publicado cross-context.
			Padrão: CMT recebe upstream de procurement/sourcing (P2P, CTR)
			e publica sinais que desencadeiam cadeia downstream do
			commitment lifecycle, incluindo projeção de caixa (TCM).
			"""
	}

	// ==============================
	// DECISÕES DE NEGÓCIO
	// ==============================

	businessDecisions: [{
		id:           "bd-mutual-acceptance"
		decision:     "Aceite mútuo bilateral é invariante inviolável, materializado de forma assimétrica: o proponente confirma implicitamente via ProposeCommitment (que fixa os termos e gera o termsHash de referência) e a contraparte confirma explicitamente via ConfirmCommitmentAcceptance. 'Termos idênticos' é verificado criptograficamente por igualdade de hash (sha256 de {contractTermsRef, scope})."
		rationale:    "Compromissos unilaterais são fonte de disputas e fraude. Aceite bilateral é barreira determinística contra compromissos fraudulentos (dp-08) e garante responsabilidade jurídica identificável (dp-10)."
		consequences: "Todo compromisso exige a proposta (1ª confirmação, implícita) e a confirmação da contraparte com termsHash idêntico (2ª) antes de publicar CommitmentAccepted; hash divergente é rejeitado. Aumenta latência de formalização, mas elimina classe inteira de disputas e torna 'o que foi acordado' criptograficamente reconstituível."
	}, {
		id:           "bd-commitment-id-origin"
		decision:     "CommitmentId é gerado exclusivamente em CMT e permeia todos os contexts downstream como fio de rastreabilidade."
		rationale:    "Sem ponto único de origem, rastreabilidade end-to-end depende de correlação probabilística. CommitmentId canônico garante vínculo determinístico entre compromisso, orçamento, entrega, fatura e pagamento."
		consequences: "Todos os BCs downstream (BDG, DLV, INV, FCE) devem carregar CommitmentId. Cria acoplamento de dados cross-cutting, mas o custo é justificado pela rastreabilidade."
	}, {
		id:           "bd-terms-validation"
		decision:     "Compromisso só é formalizado se termos contratuais referenciados existem e estão vigentes em CTR."
		rationale:    "Compromisso sem lastro contratual é risco jurídico. Validação sync contra CTR garante que termos são verificáveis no momento da formalização."
		// [AJUSTE 4] Consequência em nível de negócio/arquitetura, sem detalhes de implementação.
		consequences: "Dependência sync de CTR introduz ponto de falha. Política definida: fail-closed em propose-time — se QueryContractTerms não responde, ProposeCommitment é rejeitado (sem lastro verificável → sem compromisso). O SLA numérico de indisponibilidade é deferido a def-046 (pendente de telemetria de produção)."
	}, {
		id:           "bd-dispute-bounded-by-ctr"
		decision:     "Resolução de disputa não pode criar termo material fora do CTR. modify_terms revalida os novos termos contra o CTR (fail-closed se indisponível); termos impostos por autoridade externa fora do CTR exigem ADR próprio (mudança da hierarquia DRC/CTR/CMT)."
		rationale:    "Disputa não deve virar canal lateral para criar termo material fora do CTR — o lastro contratual é inviolável mesmo sob resolução autoritativa (dp-08, dp-10). Materializado por inv-dispute-modify-terms-revalidates-ctr (sc-cmt-09); carve-out do aceite bilateral em ten-014; per adr-143."
		consequences: "modify_terms aplica termos só com lastro CTR; sem CTR disponível, a modificação é rejeitada e o estado preservado. A notificação a consumidores que fizeram snapshot (BDG/INV) é deferida a def-048."
	}]

	// ==============================
	// STAKEHOLDERS
	// ==============================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Proponente primário de compromissos — submete propostas vinculadas a contratos de obra."
		impactDescription: "Formalização automatizada reduz tempo e custo de criação de compromissos. Aceite bilateral protege contra compromissos contestáveis."
		rationale:         "Construtora é o nó central da cadeia. Sem construtora propondo compromissos, não há fluxo financeiro."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Contraparte de compromissos — confirma aceite bilateral."
		impactDescription: "Aceite bilateral dá ao fornecedor garantia formal de que o compromisso é reconhecido por ambas as partes. CommitmentId vincula o compromisso à cadeia downstream de entrega e pagamento."
		rationale:         "Fornecedor é quem mais sofre com assimetria informacional. Compromisso formal rastreável reduz risco de não-pagamento."
	}, {
		stakeholderRef:    "sh-03"
		roleInContext:     "Consumidor indireto — qualidade do compromisso formalizado determina qualidade do lastro para operações de crédito."
		impactDescription: "Compromissos com aceite bilateral e rastreabilidade criptográfica melhoram a qualidade e verificabilidade do lastro de recebíveis."
		rationale:         "IF parceira depende de compromissos bem formalizados para decisão de crédito. Compromisso mal formalizado degrada toda a cadeia."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulador — define envelope operacional para formalização de compromissos vinculados a operações de crédito via SCD."
		impactDescription: "Rastreabilidade end-to-end de compromissos atende requisitos de transparência e auditabilidade do Bacen."
		rationale:         "Compliance regulatório é constraint inviolável. CMT deve operar dentro do framework definido pelo Bacen para SCDs."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Operador primário — processa propostas, valida termos, prepara aceite, monitora risco de compromissos ativos."
		impactDescription: "Governance scope com boundaries claras de autonomia permite operação eficiente com segurança."
		rationale:         "Agente IA é operador primário (ax-01). Sem boundaries explícitas, agente opera em zona cinza que compromete auditabilidade."
	}]

	// ==============================
	// CUSTOS ELIMINADOS
	// ==============================

	costsEliminated: [{
		costRef: "ce-02"
		contribution: """
			CMT elimina custo de compliance documental na formalização de
			compromissos: agentes processam propostas e validam documentação
			automaticamente, gates determinísticos verificam completude e
			conformidade antes de aceitar. Processo que hoje leva dias com
			múltiplos profissionais é reduzido a minutos com verificação
			determinística.
			"""
		rationale: "ce-02 é o custo de transação mais diretamente eliminado por CMT. Agentes processam; gates validam; compliance é automática e auditável."
	}]

	// ==============================
	// ANÁLISE DE INCENTIVOS
	// ==============================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:             "sh-01"
			participantType:           "proponente"
			desiredBehavior:           "Submeter propostas de compromisso com termos precisos, escopo claro e documentação completa."
			correctOperationIncentive: "Compromissos bem formalizados progridem mais rápido no lifecycle — aprovação orçamentária, verificação de entrega e pagamento dependem de dados precisos de formalização."
			manipulationVector:        "Inflar escopo ou valor do compromisso para obter maior cobertura orçamentária ou antecipação de recebíveis."
			manipulationCost:          "Compromisso inflado é verificado contra evidência operacional em DLV. Discrepância entre compromisso e execução bloqueia progressão e gera alerta de risco em REW."
			vsBenefit:                 "Benefício de inflação é limitado ao gap entre compromisso e verificação. Custo inclui bloqueio do commitment lifecycle inteiro, alerta de risco persistente em REW que afeta futuras operações, e potencial disputa em DRC."
			designResponse:            "Gates determinísticos validam coerência entre termos (CTR), compromisso (CMT) e evidência (DLV). Cadeia de evidência criptográfica (mech-evidence) torna adulteração detectável. CommitmentId vincula compromisso a toda a cadeia downstream — inflação é rastreável end-to-end."
			rationale:                 "Construtora como proponente tem incentivo para inflar. Design response usa cadeia completa de verificação para tornar manipulação mais cara que operação correta."
		}, {
			stakeholderRef:             "sh-02"
			participantType:           "contraparte"
			desiredBehavior:           "Confirmar aceite apenas de compromissos cujos termos e escopo foram verificados e são realizáveis."
			correctOperationIncentive: "Aceite de compromisso realizável garante que entrega será verificável e pagamento será liberado. Aceite de compromisso irrealizável resulta em falha de verificação em DLV e bloqueio de pagamento."
			manipulationVector:        "Aceitar compromisso com escopo sub-dimensionado para garantir aceite fácil e depois renegociar por excesso de escopo."
			manipulationCost:          "Compromisso aceito é vinculado a termos de CTR e verificado contra evidência em DLV. Escopo sub-dimensionado é detectado na verificação, bloqueando pagamento e gerando disputa."
			vsBenefit:                 "Benefício de sub-dimensionamento é aceite rápido. Custo é bloqueio de pagamento, disputa em DRC, e deterioração de score de risco em REW que afeta todas as operações futuras."
			designResponse:            "Aceite bilateral é gate determinístico — ambas as partes confirmam termos idênticos. Termos são validados contra CTR. CommitmentId vincula aceite à cadeia de verificação downstream."
			rationale:                 "Fornecedor como contraparte tem incentivo para aceitar rápido. Design response vincula aceite a consequências downstream verificáveis."
		}, {
			stakeholderRef:             "sh-05"
			participantType:           "operador-plataforma"
			desiredBehavior:           "Processar propostas de compromisso com imparcialidade, validar termos sem favoritismo e preparar aceite bilateral sem omissão seletiva."
			correctOperationIncentive: "Operação imparcial mantém confiança de ambas as partes na plataforma. Favoritismo detectado degrada credibilidade da Mesh como intermediário neutro e pode gerar responsabilidade jurídica (dp-10)."
			manipulationVector:        "Favoritismo na ordenação de processamento (priorizar propostas de determinado proponente), omissão seletiva (não processar ou atrasar propostas de fornecedores específicos), ou enviesamento na preparação de aceite (apresentar informação de forma que favoreça aprovação para cliente preferencial). Precondição: agente com acesso irrestrito ao pipeline de propostas e poder de priorização dentro do envelope autônomo."
			manipulationCost:          "Superfície de detecção: Event Log imutável registra timestamps de recebimento e processamento de cada proposta — desvio estatístico de latência por proponente é detectável por REW. Gates determinísticos (mech-agent-gate) verificam invariantes independentemente do agente — validação enviesada é bloqueada pelo gate, não pelo agente. Toda decisão supervisionada requer aprovação humana — agente não pode escalar autonomamente."
			vsBenefit:                 "Benefício de favoritismo é retenção de cliente preferencial. Custo: Event Log torna padrão detectável, gates bloqueiam validação enviesada, supervisão humana em decisões críticas elimina margem de ação autônoma, e responsabilidade jurídica recai sobre operador da plataforma (dp-10)."
			designResponse:            "mech-agent-gate separa processamento (agente) de validação (gate determinístico). Event Log imutável (mech-evidence) cria trail auditável de cada ação do agente com timestamps. Decisões com impacto financeiro são supervisionadas — agente propõe, humano aprova. REW pode monitorar padrões cross-proposta para detectar favoritismo estatístico. Autonomy envelope limita escopo de ação autônoma."
			rationale:                 "Agente IA como operador tem poder assimétrico sobre o pipeline. Design response usa separação de responsabilidades (agente processa, gate valida, humano aprova) + auditabilidade temporal + envelope de autonomia para tornar manipulação detectável e contida. Risco residual: viés sutil de priorização dentro do envelope autônomo que não viola gates mas degrada fairness. Detecção (Event Log + REW) é necessária mas insuficiente — detecta desvio post-facto sem preveni-lo. Gap estrutural (oq-cmt-4): falta alignment layer proativo — métricas de fairness no agente, penalização automática por desvio estatístico, e feedback loop REW→comportamento do agente que feche o ciclo entre detecção e correção."
		}, {
			stakeholderRef:             "sh-01"
			participantType:           "coalizão-proponente-contraparte"
			desiredBehavior:           "Proponente e contraparte formalizam compromissos que refletem transações econômicas reais, com escopo e valores verificáveis."
			correctOperationIncentive: "Compromissos reais progridem pelo lifecycle inteiro até liquidação. Compromissos fictícios ou inflados são detectados na verificação de entrega (DLV) e bloqueiam pagamento."
			manipulationVector:        "Proponente (sh-01) e contraparte (sh-02) coordenam aceite bilateral de compromisso inflado ou fictício para gerar recebível antecipável via SCF. Aceite mútuo é satisfeito por design — ambos confirmam termos idênticos deliberadamente inflados. Precondição: ambas as partes aceitam risco coordenado e a cadeia downstream de verificação tem latência suficiente para extrair valor antes da detecção."
			manipulationCost:          "Superfície de detecção: DLV verifica compromisso contra evidência operacional — entrega fictícia não produz evidência verificável (mech-evidence). Conluio sofisticado pode escalar para fabricação de evidência física (comprovantes falsos), mas isso eleva o vetor de manipulação digital para fraude documental criminal — território de dp-10 (responsabilidade jurídica) e potencial tipificação penal, com custo desproporcional ao benefício. REW monitora padrões cross-participante — mesmas partes com compromissos recorrentes de alto valor sem execução proporcional geram alerta. Score de risco deteriora para ambas as partes, afetando todas as operações futuras na plataforma."
			vsBenefit:                 "Benefício: antecipação de recebível fictício via SCF — valor financeiro imediato. Custo: bloqueio em DLV quando evidência não materializa, alerta em REW que degrada score permanentemente, disputa em DRC com base documental desfavorável (ambos aceitaram termos que não se materializam), e potencial responsabilidade jurídica por fraude (dp-10 — constraint inviolável)."
			designResponse:            "Aceite bilateral não detecta conluio — mas downstream sim. DLV exige evidência operacional verificável (mech-evidence) que conluio não produz. REW aplica análise cross-participante que detecta padrões anômalos (pares recorrentes, valores atípicos, gaps execução/compromisso). SCF valida elegibilidade contra evidência de execução, não apenas contra compromisso. CommitmentId vincula toda a cadeia — rastreabilidade end-to-end torna a fraude reconstituível para fins jurídicos."
			rationale:                 "Conluio é o vetor que mais diretamente bypassa o gate de aceite bilateral — design response transfere detecção para downstream (DLV, REW, SCF) onde evidência operacional é inescapável. Risco residual: janela temporal entre CommitmentAccepted e verificação em DLV — se SCF antecipa antes de DLV verificar, o dano financeiro já ocorreu. Requisito estrutural pendente (oq-cmt-3): SCF deve condicionar elegibilidade de antecipação a milestone de execução verificada em DLV, não apenas a compromisso aceito. Sem este gate, dp-08 é violável por conluio coordenado — o sistema depende de detecção tardia onde o dano financeiro já ocorreu."
		}, {
			stakeholderRef:             "sh-01"
			participantType:           "proponente-sub-threshold"
			desiredBehavior:           "Submeter compromissos com valores que refletem o escopo real da transação, independentemente de thresholds de escalação."
			correctOperationIncentive: "Valores precisos garantem orçamento adequado em BDG e verificação proporcional em DLV. Valores artificialmente reduzidos geram insuficiência orçamentária e discrepância na verificação."
			manipulationVector:        "Proponente calibra valor do compromisso logo abaixo do threshold de escalação (oq-cmt-1) para evitar supervisão humana em high-value-threshold. Pode fracionar compromisso grande em múltiplos sub-threshold para manter cada um no envelope autônomo. Precondição: threshold é conhecido ou inferível pelo proponente, e não há detecção de fracionamento."
			manipulationCost:          "Superfície de detecção: REW pode monitorar padrões de fracionamento — múltiplos compromissos entre mesmas partes em janela temporal curta com valor agregado acima do threshold geram alerta. BDG verifica coerência orçamentária — múltiplos compromissos fracionados para mesmo escopo são detectáveis na agregação. CommitmentId vincula cada compromisso à cadeia, tornando fracionamento rastreável."
			vsBenefit:                 "Benefício: evitar supervisão humana e obter aprovação autônoma mais rápida. Custo: fracionamento é detectável por análise de padrão em REW e por agregação em BDG, e se detectado, todas as propostas do proponente passam a escalação mandatória — custo de reputação supera benefício de velocidade."
			designResponse:            "Threshold com detecção de fracionamento: REW monitora valor agregado por par de partes em janela temporal, não apenas valor individual. BDG agrega compromissos por escopo/contrato. Gap estrutural pendente (oq-cmt-5): escalação por padrão além de valor deve ser implementada antes ou junto com a definição do threshold (oq-cmt-1). Sem detecção de fracionamento ativa, threshold cria incentivo imediato para gaming."
			rationale:                 "Threshold gaming é inevitável em sistemas com escalação por valor. Design response usa detecção de fracionamento (REW + BDG) + threshold adaptativo por proponente. Risco residual: threshold ainda não definido (oq-cmt-1, deadline 2026-06-01) — enquanto threshold não existe, toda decisão de aceite é supervisionada, o que elimina este vetor temporariamente. Vetor ativa quando threshold for implementado. Detecção de fracionamento (oq-cmt-5) deve estar operacional antes do threshold — caso contrário, o sistema cria o incentivo e a vulnerabilidade simultaneamente."
		}]
		rationale: """
			Análise cobre 5 participantes em 3 classes de vetor: (a) economic
			manipulation — proponente infla valor (sh-01), contraparte sub-
			dimensiona escopo (sh-02), coalizão infla para arbitragem via SCF
			(sh-01+sh-02); (b) governance bypass — proponente fraciona
			compromisso para evitar threshold de escalação (sh-01); (c) agent
			misalignment — operador plataforma com favoritismo ou omissão
			seletiva (sh-05). Todos os vetores têm custos que excedem
			benefícios por design: cadeia de evidência criptográfica, gates
			determinísticos, rastreabilidade end-to-end via CommitmentId,
			monitoramento cross-participante em REW e supervisão humana para
			decisões com impacto financeiro (dp-08). Riscos residuais
			declarados: janela temporal pré-DLV para conluio, viés sutil
			dentro do envelope autônomo, threshold gaming ativável apenas
			quando oq-cmt-1 for definido.
			"""
	}

	// ==============================
	// OWNERSHIP & GOVERNANCE
	// ==============================

	ownership: {
		// [AJUSTE 1] Referência canônica por path — verificável por runner.
		domainAgentSpec: "contexts/cmt/agents/cmt-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "validate-terms-reference"
				description: "Validar automaticamente que termos contratuais referenciados existem e estão vigentes em CTR."
				rationale:   "Validação é determinística — não requer julgamento. Agente pode executar autonomamente."
			}, {
				id:          "record-commitment-state"
				description: "Registrar transições de estado do compromisso no Event Log e publicar eventos correspondentes."
				rationale:   "Registro de fatos é append-only e determinístico. Sem margem para erro de julgamento."
			}, {
				id:          "flag-at-risk-commitments"
				description: "Sinalizar compromissos ativos cuja contraparte recebeu alerta de risco de REW."
				rationale:   "Sinalização é reação determinística a evento externo. Não altera estado do compromisso — apenas marca para supervisão."
			}, {
				id:          "clear-risk-flag-commitments"
				description: "Remover sinalização de risco de compromissos at-risk quando REW resolve alerta de contraparte."
				rationale:   "Par reverso de flag-at-risk-commitments. Se sinalização é autônoma, resolução também é — reação determinística a evento externo."
			}]
			supervisedDecisions: [{
				id:          "accept-commitment"
				description: "Aprovar formalização final do compromisso após gate de aceite bilateral."
				rationale:   "Aceite cria obrigação financeira. Gate é determinístico, mas a decisão de aceitar deve ser supervisionada até que o autonomy envelope seja expandido com histórico suficiente."
			}, {
				id:          "suspend-commitment"
				description: "Suspender compromisso ativo por sinalização de risco ou disputa."
				rationale:   "Suspensão afeta todo o commitment lifecycle downstream. Requer julgamento sobre severidade e impacto."
			}, {
				id:          "cancel-commitment"
				description: "Cancelar compromisso definitivamente — decisão terminal irreversível."
				rationale:   "Cancelamento afeta todo o commitment lifecycle downstream e é irreversível. Satisfaz critério de reversibilityThreshold. P10 exige gate humano."
			}, {
				id:          "reactivate-commitment"
				description: "Reativar compromisso suspenso após resolução favorável de disputa ou redução de risco."
				rationale:   "Reativação restaura obrigações financeiras que foram suspensas por humano — restaurar exige mesmo nível de supervisão. Simétrico com suspend-commitment."
			}]
			escalationCriteria: [{
				id:        "novel-commitment-type"
				condition: "Tipo de compromisso não previsto nos templates existentes (novo vertical, novo padrão de formalização)."
				action:    "Escalar ao founder para definição de template e validação de conformidade."
				rationale: "Tipos novos podem ter invariantes não previstas. Decisão irreversível se compromisso for aceito sob premissas incorretas."
			}, {
				id:        "high-value-threshold"
				condition: "Valor do compromisso excede threshold definido no autonomy envelope."
				action:    "Escalar ao humano designado para aprovação antes de publicar CommitmentAccepted."
				rationale: "Compromissos de alto valor têm blast radius financeiro proporcional. Supervisão humana é controle de contenção (conflictResolution nível 2)."
			}, {
				id:        "regulatory-ambiguity"
				condition: "Termos ou estrutura do compromisso caem em zona cinza regulatória não coberta por regras existentes."
				action:    "Escalar ao compliance officer para parecer antes de prosseguir."
				rationale: "Integridade legal é constraint inviolável (nível 1). Zona cinza exige julgamento humano especializado."
			}]
		}
		// [AJUSTE 2] Canvas é SoT de domainAgentSpec.
		// Context map deve replicar este mesmo identificador (path canônico).
		// Descrição do papel do agente vive no agent spec, não em domainAgentSpec.
		rationale: """
			cmt-primary-agent como operador, referenciado por path canônico
			(contexts/cmt/agents/cmt-primary-agent.cue) — SoT local do BC.
			O context map replica este identificador para visão global; em
			caso de drift, o canvas prevalece. 4 decisões autônomas
			(validação determinística, registro de fatos, sinalização e
			resolução de risco), 4 decisões supervisionadas (aceite de
			compromisso, suspensão, cancelamento, reativação) e 3 critérios
			de escalação (tipo novo, alto valor,
			ambiguidade regulatória). Boundaries refletem mech-agent-gate:
			agente processa, gate valida, supervisão humana para decisões
			com impacto financeiro irreversível ou ambiguidade regulatória.
			"""
	}

	// ==============================
	// ESTADO EPISTÊMICO
	// ==============================

	assumptions: [{
		id:                 "as-cmt-1"
		assumption:         "Aceite bilateral síncrono é viável para todos os tipos de compromisso no vertical de construção civil."
		invalidationSignal: "Surgimento de tipo de compromisso onde aceite requer workflow assíncrono multi-step com aprovações intermediárias."
		rationale:          "Invariante de aceite mútuo assume que confirmação é atômica. Se não for, o modelo de commands precisa evoluir."
	}, {
		id:                 "as-cmt-2"
		assumption:         "CTR como SoT de termos contratuais está disponível com latência aceitável para validação síncrona."
		invalidationSignal: "Latência de QueryContractTerms consistentemente acima de SLA ou indisponibilidade frequente de CTR."
		rationale:          "Dependência sync de CTR é ponto de falha. Se CTR não é confiável, CMT precisa de estratégia de resiliência."
	}, {
		id:                 "as-cmt-3"
		assumption:         "Mapeamento 1:1 entre compromisso e CommitmentId é suficiente — não há necessidade de hierarquia de compromissos (master/sub)."
		invalidationSignal: "Vertical de construção civil demanda compromissos hierárquicos (e.g., contrato guarda-chuva com sub-compromissos por medição)."
		rationale:          "Hierarquia de compromissos adiciona complexidade significativa ao modelo. Premissa deve ser validada com primeiros clientes."
	}]

	openQuestions: [{
		id:        "oq-cmt-1"
		question:  "Qual o threshold de valor para escalação de aceite de compromisso? Como definir thresholds por vertical?"
		impact:    "Sem threshold definido, toda decisão de aceite requer supervisão humana, eliminando o benefício de automação."
		deadline:  "2026-06-01"
		rationale: "Threshold deve ser calibrado com dados reais de operação. Bloqueante para autonomy envelope completo."
	}, {
		id:        "oq-cmt-2"
		question:  "Como CMT deve tratar compromissos em verticais onde aceite bilateral não é padrão cultural?"
		impact:    "Se aceite bilateral é barreira de adoção em algum vertical, a invariante central do CMT precisa ser revisitada."
		rationale: "Mesh planeja expansão multi-vertical. Invariante que funciona na construção civil pode não funcionar em logística ou energia."
	}, {
		id:        "oq-cmt-3"
		question:  "Como condicionar elegibilidade de antecipação em SCF a milestone de execução verificada em DLV, sem degradar latência do pipeline de crédito?"
		impact:    "Sem este gate, conluio proponente-contraparte pode gerar antecipação de recebível fictício antes que DLV detecte a fraude. dp-08 depende de custo de manipulação exceder benefício — mas na janela pré-DLV o benefício é extraível e o custo ainda não materializou. Maior risco financeiro do sistema hoje."
		deadline:  "2026-05-15"
		rationale: "Não é melhoria — é requisito para que dp-08 se sustente no cenário de conluio. Trade-off: gate mais restritivo em SCF reduz velocidade de antecipação; gate ausente cria janela de arbitragem. Prioridade máxima: protege caixa real."
	}, {
		id:        "oq-cmt-4"
		question:  "Como implementar agent alignment layer que vá além de detecção — métricas de fairness, penalização por desvio estatístico e feedback loop REW→comportamento do agente?"
		impact:    "Sem alignment proativo, o agente pode operar 'no limite do aceitável' dentro do envelope autônomo sem violar nenhum gate, mas degradando fairness sistematicamente. Detecção via Event Log é post-facto — o dano à confiança já ocorreu quando o padrão é detectado."
		deadline:  "2026-07-01"
		rationale: "Diferença entre sistema que detecta viés e sistema que previne viés. Detecção é necessária mas não suficiente para dp-08 quando o operador é o próprio agente com poder assimétrico. Aplica-se cross-BC a todo agente primário da Mesh."
	}, {
		id:        "oq-cmt-5"
		question:  "Como implementar detecção de fracionamento (REW + BDG) de forma que esteja operacional antes ou simultaneamente à definição do threshold de escalação (oq-cmt-1)?"
		impact:    "Threshold sem detecção de fracionamento cria incentivo imediato para gaming. O sistema passaria a ter uma vulnerabilidade conhecida e um incentivo econômico para explorá-la no mesmo momento."
		deadline:  "2026-06-01"
		rationale: "Dependência temporal: oq-cmt-5 deve ser resolvido no mesmo timeline de oq-cmt-1. Implementar threshold sem fracionamento detection é pior que não implementar threshold."
	}]

	// ==============================
	// MÉTRICAS DE VERIFICAÇÃO
	// ==============================

	verificationMetrics: [{
		id:        "commitment-formalization-time"
		metric:    "Tempo médio entre ProposeCommitment e CommitmentAccepted"
		target:    "< 4 horas para compromissos standard"
		rationale: "Mede eficiência do fluxo automatizado vs processo manual (dias)."
	}, {
		id:        "bilateral-acceptance-rate"
		metric:    "Percentual de propostas que atingem aceite bilateral"
		target:    "> 85% das propostas submetidas"
		rationale: "Taxa baixa indica problema de qualidade de proposta ou de alinhamento entre partes."
	}, {
		id:        "commitment-dispute-rate"
		metric:    "Percentual de compromissos aceitos que geram disputa em DRC"
		target:    "< 5% dos compromissos aceitos"
		rationale: "Taxa alta invalida a premissa de que aceite bilateral elimina disputas de formalização."
	}, {
		id:        "agent-processing-fairness"
		metric:    "Coeficiente de variação de latência de processamento por proponente (desvio de tempo entre recebimento e primeiro ato do agente)"
		target:    "CV < 0.3 entre proponentes com volume comparável"
		rationale: "Mede fairness operacional do agente. Desvio alto indica favoritismo temporal — sinal de alerta antes que o padrão se consolide."
	}]

	rationale: """
		Canvas do CMT como documento raiz de identidade. CMT é o ponto de
		formalização do commitment lifecycle — recebe upstream de P2P
		(spot) e CTR (sourcing estratégico via SSC→CTR→CMT) — e gera
		CommitmentId, o conceito cross-cutting mais referenciado do
		sistema. Core porque a formalização de compromissos com aceite
		mútuo e rastreabilidade é proprietária da Mesh. Execution como
		archetype primário porque opera gates determinísticos de aceite
		bilateral. Communication alinhada com context map v2: inbound de
		P2P (pedido de compra), CTR (lifecycle de termos), REW (risco e
		resolução de risco) e DRC (disputas); outbound para BDG
		(lifecycle), DRC (contexto) e TCM (projeção de caixa); query
		dependency de CTR (termos). CommitmentProposed é evento interno —
		não cruza fronteira. Governance scope separa decisões
		determinísticas (autônomas: validação, registro, flag/clear risco)
		de decisões com impacto financeiro (supervisionadas: aceite,
		suspensão, cancelamento, reativação). domainAgentSpec referenciado
		por path canônico — canvas é SoT, context map replica. Incentive
		analysis demonstra que manipulação por proponente ou contraparte é
		mais cara que operação correta, por design (mech-evidence +
		mech-agent-gate + rastreabilidade end-to-end).
		"""
}
