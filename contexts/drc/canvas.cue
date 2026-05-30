package drc

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// canvas.cue — Bounded Context Canvas: Disputes, Reversals & Corrections.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// DRC é o BC supporting que orquestra o lifecycle de exceções — disputas,
// contestações, não conformidades, penalidades e estornos —, separando o
// fluxo de exceção do fluxo normal do compromisso (CMT). Owner do estado da
// disputa e da invariante de que toda resolução é ancorada em evidência
// verificável (mech-evidence).
//
// Segunda aplicação de P13/adr-125 em modo batch (boundary-derivation
// registrada em adr-129; não materializa campo no canvas — schema #Canvas é
// struct fechada). O ciclo cmt↔drc é tipado bidirectional-orchestration
// (adr-122, W1) — DRC conforma ao kind já canônico, não deriva kind novo.

canvas: artifact_schemas.#Canvas & {
	code: "drc"
	name: "Disputes, Reversals & Corrections"

	purpose: """
		Orquestrar o lifecycle de exceções — disputas, contestações, não
		conformidades, penalidades e estornos —, separando o fluxo de exceção
		do fluxo normal do compromisso. DRC é owner do estado da disputa
		(alegação→evidência→resolução→impacto) e da invariante de que toda
		resolução é ancorada em evidência verificável (mech-evidence).

		Existe como unidade SEPARADA de CMT (que governa o fluxo normal do
		compromisso), FCE (que executa estornos financeiros) e CTR (que define
		cláusulas de penalidade): sem DRC, CMT absorveria a complexidade de
		reversões, inflando a state machine do lifecycle com lógica
		inerentemente excepcional e regulatoriamente pesada. DRC decide
		reversões e penalidades; não as executa (FCE) nem as define (CTR). A
		resolução de disputa contextualiza-se no estado do compromisso (CMT) e
		na evidência de verificação (DLV), mas o lifecycle de exceção — com
		prazos, stakeholders e regras próprios — é exclusivamente do DRC.
		"""

	ubiquitousLanguageRef: "contexts/drc/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque a gestão de disputas, embora complexa, é domínio
			com padrões exógenos estabelecidos (processos de contestação, regras
			de estorno, prazos regulatórios) — o valor proprietário está em COMO
			a Mesh resolve disputas usando evidência verificável (mech-evidence),
			não na orquestração do processo em si (drc.cue:53-59).
			operational-enabler porque DRC viabiliza o recovery e a correção do
			fluxo quando o caminho normal falha — não é gate de bloqueio
			categórico do fluxo normal (≠ compliance-enforcer do FCE, que bloqueia
			movimento de dinheiro): disputas são excepcionais e o fluxo normal do
			compromisso opera sem elas. product na evolução Wardley porque
			processos de disputa/contestação/estorno são amplamente compreendidos
			e endereçados por soluções de mercado; a Mesh adapta o padrão
			ancorando resolução em evidência verificável.
			"""
	}

	verticalApplicability: {
		mode: "vertical-agnostic"
		rationale: """
			O lifecycle de disputa (alegação→evidência→resolução→impacto) opera
			sobre primitivas universais — alegação, evidência, decisão de
			resolução, impacto econômico — sem depender da vertical de construção
			civil. A semântica vertical (o que se disputa, quais critérios de
			entrega) vive upstream em CMT/DLV/CTR; a execução do estorno é
			delegada ao FCE. Regras regulatórias de prazo/contestação entram como
			configuração externa, não como estrutura do BC. Paralelo INV/BDG:
			engine horizontal, semântica vertical externa.
			"""
	}

	domainRoles: {
		primary: "execution"
		secondary: ["analysis"]
		rationale: """
			Primary execution: DRC é o engine de orquestração do workflow de
			resolução — alegação→evidência→resolução→impacto — com prazos,
			stakeholders e regras próprios (drc.cue:11-18). O enum #Archetype não
			tem "orchestrator"; a orquestração do lifecycle de exceção mapeia para
			execution como papel central. Secondary analysis: diferente do FCE
			(gateway secondary), o DRC GENUINAMENTE avalia a disputa — pondera
			alegação contra evidência (DeliveryVerified/Rejected de DLV) e contra
			termos (QueryContractClauses de CTR) para chegar à resolução. Essa
			dimensão analítica é a distinção real do DRC: resolução de disputa
			material não é categórica (P10) — exige análise + julgamento humano,
			diferente do gate determinístico do FCE.
			"""
	}

	capabilities: {
		operational: [{
			description: """
				Orquestração do lifecycle de disputa: registra alegação, anexa
				evidência (de DLV, CTR e partes), conduz o fluxo
				alegação→evidência→resolução→impacto com prazos e stakeholders
				próprios, e publica a decisão. Cada disputa tem estado canônico
				(open→under-evaluation→resolved) owned exclusivamente pelo DRC.
				"""
			rationale: """
				Capability local (sem cc-XX) — o subdomain drc.cue não declara
				capabilityRefs; esta é a capability core do DRC. Separa o fluxo
				de exceção do fluxo normal do compromisso (CMT), evitando que a
				state machine do lifecycle absorva lógica de reversão.
				"""
		}, {
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua e regulatory-grade do processo de disputa:
				cada alegação, evidência anexada, decisão de resolução e impacto
				econômico é fato imutável no Event Log, reconstituível em qualquer
				data. Disputa carrega trail completo (commitmentRef, evidenceRefs,
				resolutionOutcome, decidedBy, decidedAt) — exigência regulatória
				para reversões e estornos.
				"""
			rationale: """
				cc-04 (auditoria contínua, domain-definition:512) aplicado como
				ref local — o subdomain não lista capabilityRefs, mas disputa é
				regulatoriamente pesada (drc.cue:24-27) e o trail é precondition
				de defesa jurídica. Pattern INV/BDG (cc-04 como audit ref).
				"""
		}, {
			description: """
				Resolução ancorada em evidência verificável: a decisão de
				resolução é avaliada contra DeliveryVerified/DeliveryRejected (DLV)
				e contra termos/cláusulas contratuais (CTR) via mech-evidence.
				Alegação sem lastro de evidência não progride para resolução
				favorável — a invariante própria do DRC.
				"""
			rationale: """
				Capability local ancorada em mech-evidence (domain-definition:48)
				— a invariante que torna o DRC mais que um workflow engine genérico
				(drc.cue:53-59). Sustenta bd-resolution-requires-evidence. Não
				produz a evidência (DLV) nem define os termos (CTR): consome e
				avalia.
				"""
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	communication: {
		inbound: [{
			type:          "event-consumer"
			sourceContext: "cmt"
			event:         "CommitmentAccepted"
			reaction: """
				Registra contexto do compromisso para disputas futuras —
				materializa referência read-only (commitmentRef, parties, terms)
				que contextualiza eventual alegação. Aresta do ciclo tipado
				cmt↔drc (bidirectional-orchestration, adr-122 W1).
				"""
			description: "Per cmt-to-drc + cmt canvas (CommitmentAccepted consumers inclui drc, cmt:232)."
		}, {
			type:          "event-consumer"
			sourceContext: "cmt"
			event:         "CommitmentStateChanged"
			reaction: """
				Atualiza contexto de disputas em curso com o estado corrente do
				compromisso (suspensão, cancelamento, reativação) — a disputa
				referencia o estado vigente do compromisso que a originou.
				"""
			description: "Per cmt-to-drc + cmt canvas (CommitmentStateChanged consumers inclui drc, cmt:238)."
		}, {
			type:          "event-consumer"
			sourceContext: "dlv"
			event:         "DeliveryRejected"
			reaction: """
				Entry point imediato de disputa: rejeição de entrega é gatilho
				natural de contestação. DRC abre disputa contextualizada pela
				evidência de rejeição.
				"""
			description: "Per dlv-to-drc + dlv canvas (DeliveryRejected como entry point imediato de disputa, dlv:258-259)."
		}, {
			type:          "event-consumer"
			sourceContext: "dlv"
			event:         "DeliveryVerified"
			reaction: """
				Contexto para disputa posterior dentro da economic finality
				window (post-verification-dispute path): mesmo uma entrega
				verificada pode ser contestada dentro da janela. DRC retém como
				base de evidência.
				"""
			description: "Per dlv-to-drc + dlv canvas (DeliveryVerified como contexto para post-verification-dispute, dlv:259-262)."
		}, {
			type:          "event-consumer"
			sourceContext: "ctr"
			event:         "ContractTermsSuperseded"
			reaction: """
				Reavalia disputas em curso cujo embasamento referencia termos
				superseded — a base contratual da disputa pode mudar quando termos
				são substituídos dentro da janela de uma disputa ativa.
				"""
			description: "Per ctr-to-drc + ctr canvas (DRC reage a supersessão, ctr:111)."
		}, {
			type:          "event-consumer"
			sourceContext: "ctr"
			event:         "ContractTermsCancelled"
			reaction: """
				Reavalia disputas cujo embasamento referencia termos cancelados —
				cancelamento de termos pode alterar a base jurídica de uma disputa
				ativa.
				"""
			description: "Per ctr-to-drc + ctr canvas (DRC reage a cancelamento de termos)."
		}, {
			type:       "query-surface"
			query:      "QueryDisputeStatus"
			returnType: "DisputeStatusView (disputeId + commitmentRef + status ∈ {open,under-evaluation,resolved} + resolutionOutcome? + openedAt + resolvedAt?)"
			description: """
				Superfície síncrona exposta pelo DRC para consulta de estado de
				disputa por disputeId ou commitmentRef. Read model do event log;
				habilita consumidores a verificar se um compromisso tem disputa
				ativa antes de progredir.
				"""
		}]

		outbound: [{
			type: "event-publisher"
			trigger: """
				Disputa atinge estado resolved (resolução ancorada em evidência,
				decisão registrada). Resolução material passou por human gate
				(governanceScope).
				"""
			event:     "DisputeResolved"
			consumers: ["cmt", "fce"]
			description: """
				Fato canônico de resolução de disputa. CMT consome para atualizar
				estado do compromisso (cancelar, modificar termos ou manter,
				cmt:191); FCE consome para executar consequência financeira quando
				houver. Aresta drc-to-cmt é do ciclo tipado (bidirectional-
				orchestration, adr-122 W1); aresta drc-to-fce per context-map.
				NOTA: canvas FCE ainda não enumera DisputeResolved como source
				(forward-ref — WI de reconciliação, oq-drc-4).
				"""
		}, {
			type: "event-publisher"
			trigger: """
				Resolução determina suspensão do compromisso (disputa material que
				exige pausar o fluxo normal até correção).
				"""
			event:     "CommitmentSuspensionOrdered"
			consumers: ["cmt"]
			description: """
				Ordem de suspensão consumida por CMT (cmt:196 — suspende
				compromisso ativo por determinação de disputa). Aresta drc-to-cmt
				do ciclo tipado bidirectional-orchestration.
				"""
		}, {
			type: "event-publisher"
			trigger: """
				Resolução determina compensação/estorno financeiro (reversão de
				movimento monetário devida a uma das partes).
				"""
			event:     "FinancialCompensationOrdered"
			consumers: ["fce"]
			description: """
				DRC DECIDE a compensação; FCE EXECUTA a movimentação (bd-decides-
				reversal-not-executes). Per drc-to-fce context-map. NOTA: canvas
				FCE ainda não enumera FinancialCompensationOrdered como source
				(forward-ref — WI de reconciliação, oq-drc-4).
				"""
		}, {
			type:          "query-dependency"
			targetContext: "ctr"
			query:         "QueryContractTerms"
			purpose: """
				Avaliar disputa contra os termos contratuais formalizados
				(version-pinned) que embasam o compromisso disputado.
				"""
			description: "Per ctr-to-drc (queries) + ctr canvas (QueryContractTerms consumida por DRC, ctr:162)."
		}, {
			type:          "query-dependency"
			targetContext: "ctr"
			query:         "QueryContractClauses"
			purpose: """
				Avaliar disputa contra cláusulas específicas (penalidade,
				retenção) — base contratual para aplicar penalidade quando a
				cláusula é invocada.
				"""
			description: "Per ctr-to-drc (queries) + ctr canvas (QueryContractClauses consumida por DRC para avaliar disputas, ctr:167)."
		}]

		rationale: """
			Inbound event-driven: 6 event-consumers (cmt ×2 contexto de
			compromisso; dlv ×2 — DeliveryRejected entry point + DeliveryVerified
			post-verification-dispute; ctr ×2 reavaliação por supersessão/
			cancelamento) + 1 query-surface exposta (QueryDisputeStatus). Outbound:
			3 event-publishers (DisputeResolved→cmt/fce; CommitmentSuspensionOrdered
			→cmt; FinancialCompensationOrdered→fce) + 2 query-dependencies (ctr,
			avaliação contra termos/cláusulas). TODAS as relations cross-checked
			com context-map: cmt-to-drc/drc-to-cmt (ciclo bidirectional-
			orchestration, adr-122 W1), dlv-to-drc, ctr-to-drc, drc-to-fce — todas
			formalizadas. O ciclo cmt↔drc é tipado e excluído do grafo de
			acyclicity por edgeFilter (adr-122) — sc-cm-07 permanece 0 ciclos.
			drc-to-fce é formalizado no context-map, mas o consumo dos eventos no
			canvas FCE é forward-ref (oq-drc-4, mesmo padrão WI-043 do FCE).
			"""
	}

	businessDecisions: [{
		id: "bd-dispute-lifecycle-separate"
		decision: """
			O lifecycle de disputa (alegação→evidência→resolução→impacto) é
			estado de domínio próprio do DRC, separado do lifecycle do
			compromisso (CMT). Nenhuma transição de disputa muta diretamente o
			estado do compromisso — o impacto é comunicado via evento
			(DisputeResolved/CommitmentSuspensionOrdered), e o CMT decide a
			transição do seu próprio estado.
			"""
		rationale: """
			Anti-CMT boundary (drc.cue:30-36): fundir disputa e compromisso
			misturaria regras de progressão (normal) com regras de reversão
			(excepcional), inflando a state machine do lifecycle com lógica
			inerentemente excepcional. Separação preserva o core do CMT enxuto.
			"""
		consequences: """
			DRC owns o aggregate Dispute; CMT owns o aggregate Commitment. O
			ciclo cmt↔drc é resolvido por orquestração bidirecional tipada
			(bidirectional-orchestration, adr-122), não por mutação direta
			cross-BC. CMT atualiza seu estado reagindo a eventos DRC, preservando
			ownership canônico de cada lado.
			"""
	}, {
		id: "bd-resolution-requires-evidence"
		decision: """
			Toda resolução de disputa é ancorada em evidência verificável: a
			decisão é avaliada contra DeliveryVerified/DeliveryRejected (DLV) e
			contra termos/cláusulas contratuais (CTR). Alegação sem lastro de
			evidência não progride para resolução favorável.
			"""
		rationale: """
			A invariante própria do DRC (drc.cue:53-59), ancorada em mech-evidence
			(domain-definition:48): é o que distingue o DRC de um workflow engine
			genérico e o que torna o valor proprietário (resolver disputa usando
			evidência verificável, não testemunho). Sem essa âncora, disputa vira
			vetor de fraude (alegação infundada para atrasar pagamento legítimo).
			"""
		consequences: """
			O agente de disputa exige evidenceRefs verificáveis antes de
			propor resolução; alegação sem evidência suficiente escala ou é
			rejeitada. Audit trail (cc-04) registra a cadeia evidência→decisão,
			tornando a resolução reconstituível e defensável juridicamente.
			"""
	}, {
		id: "bd-decides-reversal-not-executes"
		decision: """
			DRC DECIDE que um estorno/compensação é devido e emite
			FinancialCompensationOrdered; FCE EXECUTA a movimentação reversa de
			dinheiro. DRC nunca move dinheiro.
			"""
		rationale: """
			Anti-FCE boundary (drc.cue:38-43): separar a decisão de reversão da
			orquestração financeira mantém a decisão de disputa desacoplada da
			execução de pagamento. Espelho do drc-to-fce no context-map: DRC é
			autoridade de decisão de reversão; FCE é executor.
			"""
		consequences: """
			Toda reversão financeira passa pelo FCE (que aplica seu próprio
			PrePaymentGuard/P11 sobre a operação reversa). DRC não tem aggregate
			de pagamento nem toca rails. Correção financeira pós-settlement do
			FCE é justamente o que o FCE delega ao DRC (fce bd-no-supersession-
			reaction / "correção é DRC").
			"""
	}, {
		id: "bd-applies-penalty-not-defines"
		decision: """
			DRC APLICA penalidades quando a cláusula contratual é invocada numa
			disputa; CTR DEFINE as cláusulas de penalidade e retenção. DRC
			consome QueryContractClauses para aplicar, não para definir.
			"""
		rationale: """
			Anti-CTR boundary (drc.cue:45-50): separar aplicação de definição
			permite que termos contratuais evoluam (CTR) sem alterar a
			orquestração de disputas (DRC). DRC lê a cláusula como input
			read-only e a aplica ao caso concreto.
			"""
		consequences: """
			DRC não versiona nem cria cláusulas; depende de QueryContractClauses
			(CTR) como input. Mudança de cláusula é mudança no CTR, não no DRC.
			Penalidade aplicada referencia a cláusula+versão que a embasou
			(rastreabilidade).
			"""
	}, {
		id: "bd-material-resolution-human-gated"
		decision: """
			Resolução de disputa MATERIAL exige human gate — o agente recomenda,
			o humano decide (P10). O threshold de materialidade (valor, tipo de
			disputa, dimensão regulatória) é INPUT UPSTREAM (policy/contrato/
			regulação), não interpretação autônoma do DRC: o agente classifica a
			disputa contra o threshold declarado e escala quando material.
			"""
		rationale: """
			P10 (agentes recomendam, gates validam): resolução de disputa
			material não é categórica — envolve julgamento sobre suficiência de
			evidência e equidade que não é determinístico. Definir o threshold
			como input upstream (não decisão do DRC) protege contra escalation-
			bypass por mis-classification: o agente não pode rebaixar uma disputa
			material para autônoma reinterpretando o threshold a seu favor.
			"""
		consequences: """
			O agente DRC resolve autonomamente apenas disputas abaixo do threshold
			de materialidade (determinístico: classificação contra threshold
			declarado); disputas materiais escalam para supervisedDecision. O
			threshold vive em configuração externa (policy/contrato), versionada e
			auditável — mudança de threshold é supervisedDecision, não auto-tuning.
			"""
	}]

	stakeholders: [{
		stakeholderRef: "sh-01"
		roleInContext:  "Parte em disputa — construtora cujos compromissos podem ser contestados ou que contesta entrega/qualidade."
		impactDescription: """
			Construtora pode ser proponente ou alvo de disputa. Resolução
			ancorada em evidência (mech-evidence) protege contra contestação
			infundada da contraparte e dá previsibilidade ao desfecho — disputa
			não se resolve por poder de barganha, mas por evidência verificável.
			"""
		rationale: "sh-01 é o nó central da cadeia; disputas afetam diretamente seu fluxo de caixa e relação com fornecedores. Resolução baseada em evidência reduz o custo de litígio."
	}, {
		stakeholderRef: "sh-02"
		roleInContext:  "Parte em disputa — fornecedor cuja entrega pode ser contestada ou que contesta não-pagamento."
		impactDescription: """
			Fornecedor (lado de menor poder de barganha) é protegido por
			resolução ancorada em evidência: uma entrega verificada (DLV) é base
			documental favorável numa disputa, e o estorno indevido exige
			evidência. Sem DRC, contestações se resolveriam por assimetria de
			poder, não por fato.
			"""
		rationale: "sh-02 é quem mais ganha com disputa baseada em evidência — sua entrega verificada vira lastro defensável contra não-pagamento ou estorno injustificado."
	}, {
		stakeholderRef: "sh-04"
		roleInContext:  "Regulador — disputas, reversões e estornos têm dimensão regulatória e exigem trail auditável."
		impactDescription: """
			Bacen espera rastreabilidade de reversões e correções financeiras na
			operação SCD. DRC mantém audit trail regulatory-grade (cc-04) de cada
			alegação, evidência, decisão e impacto — reconstituível em qualquer
			data. Reversão sem trail auditável é exposição regulatória.
			"""
		rationale: "Reversões e estornos são pontos sensíveis de compliance prudencial; DRC produz o trail que sustenta a legitimidade regulatória dessas operações."
	}, {
		stakeholderRef: "sh-05"
		roleInContext:  "Operador do lifecycle de disputa — agente que conduz alegação→evidência→resolução e escala disputas materiais."
		impactDescription: """
			Agente IA conduz o workflow de disputa dentro do envelope: resolve
			autonomamente disputas abaixo do threshold de materialidade
			(classificação determinística contra threshold upstream) e escala
			disputas materiais como supervisedDecision. Resolução material nunca
			é autônoma (P10).
			"""
		rationale: "Sem sh-05 explícito, decisões de design tratam o agente como ferramenta; o threshold de materialidade como input upstream preserva a clareza do limite de autonomia (concern primária do agente)."
	}]

	costsEliminated: [{
		costRef: "ce-02"
		contribution: """
			DRC substitui processo documental manual de contestação/resolução por
			fluxo ancorado em evidência verificável (mech-evidence) + audit trail
			estrutural (cc-04): alegação, evidência e decisão são fatos imutáveis,
			eliminando a montagem manual de dossiê de disputa. Encaixe defensável
			mas NÃO dispute-specific — ce-08 (custo de resolução de disputa/
			litígio) é candidato futuro se o padrão recorrer em outros BCs
			supporting.
			"""
		rationale: "ce-02 (compliance documental, mech-agent-gate) aplica porque resolução de disputa é etapa de compliance que envolve documentação e validação — automatizada via evidência verificável + gate."
	}, {
		costRef: "ce-03"
		contribution: """
			DRC reduz custo de reconciliação financeira ao tornar correções e
			estornos rastreáveis a fatos canônicos (DisputeResolved,
			FinancialCompensationOrdered) vinculados ao commitmentRef e à
			evidência: a correção não é ajuste manual ad-hoc entre sistemas, mas
			consequência auditável de uma resolução. Encaixe defensável mas NÃO
			dispute-specific — ver nota ce-08 em ce-02.
			"""
		rationale: "ce-03 (reconciliação multi-sistema, mech-three-sots) aplica porque reversões são fonte clássica de divergência orçamento-vs-realizado; resolução com trail canônico remove a divergência na origem."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-06"
			participantType:           "Classe de actor adversarial canonical (R4+++) com intenção primária de extrair valor via gaming do processo de disputa."
			desiredBehavior:           "Usar o processo de disputa de boa-fé — contestar apenas quando há base de evidência genuína."
			correctOperationIncentive: "Disputa de boa-fé com evidência é resolvida rápido e favoravelmente; o custo de uma disputa frívola (detecção + reputação degradada cross-network) excede o ganho de atrasar um pagamento legítimo."
			manipulationVector: """
				Disputa fraudulenta / gaming: abrir contestação infundada para
				atrasar pagamento legítimo (delay attack via dispute), OU forjar
				alegação para extrair estorno indevido, OU contestar repetidamente
				dentro da economic finality window para travar o fluxo.
				"""
			manipulationCost: """
				bd-resolution-requires-evidence: resolução é ancorada em DLV
				(DeliveryVerified/Rejected) e CTR (termos) verificáveis —
				alegação sem lastro de evidência não progride para resolução
				favorável. Audit trail cross-BC (cc-04) torna o padrão de
				disputa frívola detectável (ratio de disputas perdidas por
				proponente). Estorno indevido exige FinancialCompensationOrdered
				que o FCE executa sob seu próprio P11 — dupla barreira.
				"""
			vsBenefit: """
				Ganho de atrasar um pagamento via disputa frívola é temporário
				(janela até resolução por evidência) e detectável; custo é
				degradação de reputação cross-network + potencial responsabilidade
				por má-fé (dp-10) + perda de credibilidade em disputas futuras
				(boy-who-cried-wolf). Inviável estruturalmente.
				"""
			designResponse: """
				bd-resolution-requires-evidence (âncora em mech-evidence) +
				cc-04 audit trail (detecção de padrão de disputa frívola) +
				bd-decides-reversal-not-executes (estorno passa pelo P11 do FCE) +
				threshold de materialidade como input upstream (disputa material
				escala para humano, não é resolvida por heurística).
				"""
			rationale: "Mesh é AI-operated e disputa é o vetor clássico de gaming (delay attack). sh-06 canonical (REW WI-046) cobre o adversário primário; a defesa é a âncora de evidência, que torna alegação infundada não-progressiva por construção."
		}, {
			stakeholderRef:            "sh-01"
			participantType:           "Parte em disputa (construtora) — pode ser proponente ou alvo de contestação."
			desiredBehavior:           "Contestar de boa-fé quando há divergência genuína sobre entrega/qualidade; honrar resolução ancorada em evidência."
			correctOperationIncentive: "Resolução baseada em evidência protege a construtora contra contestação infundada do fornecedor e dá desfecho previsível — disputa não vira leverage de negociação."
			manipulationVector: """
				Usar a posição de pagador para abrir disputa estratégica e reter
				pagamento devido (contestar entrega legítima para postergar
				desembolso), explorando a assimetria de poder com o fornecedor.
				"""
			manipulationCost: """
				DeliveryVerified (DLV) é evidência imutável favorável ao
				fornecedor; contestar entrega verificada exige base de evidência
				que a contradiga, não mera alegação. Disputa perdida sem base
				gera padrão detectável (cc-04) e não bloqueia o fluxo
				indefinidamente (resolução por evidência dentro da janela).
				"""
			vsBenefit: "Ganho de postergar desembolso é limitado à janela de resolução; custo é reputação + base documental desfavorável (entrega verificada) + potencial penalidade contratual aplicada pelo próprio DRC. Assimetria de poder neutralizada por evidência."
			designResponse: "bd-resolution-requires-evidence neutraliza disputa-como-leverage: a entrega verificada do fornecedor (DLV) é lastro defensável; o par proponente(sh-01)-contestante(sh-02) é arbitrado por fato, não por poder de barganha."
			rationale: "O par sh-01(pagador)↔sh-02(fornecedor) é o eixo adversarial estrutural da disputa; a âncora de evidência protege o lado de menor poder (sh-02) contra disputa estratégica do lado de maior poder (sh-01)."
		}]
		rationale: """
			Dois vetores: (a) adversário canonical (sh-06) que usa disputa
			frívola como delay attack ou forja alegação para estorno indevido —
			contido pela âncora de evidência (resolução não progride sem lastro)
			+ audit de padrão + estorno sob P11 do FCE; (b) assimetria de poder
			sh-01(pagador)↔sh-02(fornecedor) — disputa-como-leverage neutralizada
			porque a entrega verificada (DLV) é evidência imutável que arbitra por
			fato, não por barganha. Em ambos, o custo de manipular excede o
			benefício por design (dp-08), e a defesa comum é
			bd-resolution-requires-evidence.
			"""
	}

	ownership: {
		domainAgentSpec: "contexts/drc/agents/drc-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "register-dispute"
				description: "Registrar abertura de disputa no Event Log a partir de gatilho válido (DeliveryRejected, alegação de parte) com contexto do compromisso e referências de evidência iniciais."
				rationale:   "Registro é append-only e determinístico — abrir disputa não decide o desfecho. Sem julgamento sobre mérito nesta etapa."
			}, {
				id:          "attach-evidence"
				description: "Anexar evidência verificável (DeliveryVerified/Rejected de DLV, termos de CTR, documentos das partes) ao aggregate Dispute, com integrityProof quando aplicável."
				rationale:   "Coleta e anexação de evidência é operação determinística de agregação; não pondera mérito. A ponderação ocorre na etapa de resolução."
			}, {
				id:          "resolve-immaterial-dispute"
				description: "Resolver autonomamente disputas ABAIXO do threshold de materialidade (classificação determinística contra threshold upstream declarado), quando a evidência é categórica (e.g., DeliveryRejected sem contra-evidência)."
				rationale:   "Disputa imaterial com evidência categórica é determinística (within-threshold + evidência conclusiva). bd-material-resolution-human-gated reserva o julgamento para disputas materiais."
			}]
			supervisedDecisions: [{
				id:          "resolve-material-dispute"
				description: "Resolver disputa MATERIAL (acima do threshold de materialidade upstream) — exige confirmação humana. NUNCA autônoma: resolução material envolve julgamento sobre suficiência de evidência e equidade."
				rationale:   "Linha central do DRC (P10): resolução de disputa material não é categórica. bd-material-resolution-human-gated — o agente recomenda, o humano decide. Threshold é input upstream, protegendo contra escalation-bypass."
			}, {
				id:          "order-financial-compensation"
				description: "Emitir FinancialCompensationOrdered (estorno/compensação) — decisão com impacto monetário direto, sempre supervisionada."
				rationale:   "Reversão de dinheiro é irreversível em impacto; mesmo decidida pelo DRC, exige human gate antes de instruir o FCE. Impacto financeiro nunca é autônomo."
			}, {
				id:          "apply-contractual-penalty"
				description: "Aplicar penalidade contratual invocada numa disputa (consumindo QueryContractClauses) — exige confirmação humana sobre a aplicabilidade da cláusula ao caso concreto."
				rationale:   "Aplicação de penalidade envolve julgamento sobre se a cláusula se aplica ao caso — não é subsunção automática. Supervisão preserva responsabilidade jurídica (dp-10)."
			}]
			escalationCriteria: [{
				id:        "material-dispute-threshold-exceeded"
				condition: "Disputa classificada como material por exceder o threshold upstream (valor, tipo, dimensão regulatória declarados em policy/contrato)."
				action:    "Escalar para supervisor designado para resolução humana antes de publicar DisputeResolved. Não cachear decisão entre disputas similares."
				rationale: "Threshold de materialidade é o gate central de autonomia do DRC; disputa material exige julgamento humano (bd-material-resolution-human-gated). Threshold como input upstream impede rebaixamento por mis-classification."
			}, {
				id:        "evidence-insufficient-or-conflicting"
				condition: "Evidência disponível (DLV, CTR, partes) é insuficiente ou conflitante para resolução ancorada — não há lastro categórico para decidir."
				action:    "Escalar para supervisor; não resolver autonomamente. Pode solicitar evidência adicional às partes ou aguardar dentro da janela regulatória."
				rationale: "bd-resolution-requires-evidence: sem evidência suficiente, resolução autônoma violaria a invariante do DRC. Resolução sob evidência insuficiente é o caminho clássico de erro/fraude."
			}, {
				id:        "suspected-dispute-fraud"
				condition: "Padrão de disputa frívola detectado (ratio elevado de disputas perdidas por proponente, ou indícios de alegação forjada — vetor sh-06)."
				action:    "Escalar para founder/compliance + security review; pausar autonomia de resolução para o proponente afetado até decisão."
				rationale: "Disputa fraudulenta (delay attack / alegação forjada) é vetor adversarial sh-06; detecção exige decisão humana sobre consequência (revogação, ajuste de elegibilidade, reporte)."
			}, {
				id:        "regulatory-deadline-at-risk"
				condition: "Prazo regulatório de resolução de disputa em risco de violação (janela de contestação/estorno próxima do limite legal)."
				action:    "Escalar para supervisor com prioridade; integridade de prazo regulatório é constraint inviolável (nível 1)."
				rationale: "Prazos de disputa/estorno são regulados; violação é exposição legal. Escalation prioritária preserva compliance prudencial."
			}]
		}
		rationale: """
			drc-primary-agent como operador (forward reference — agent spec ainda
			não autorado). 3 autonomousDecisions cobrem operações determinísticas
			(registro, anexação de evidência, resolução de disputa IMATERIAL com
			evidência categórica); 4 supervisedDecisions cobrem o núcleo de
			julgamento do DRC (resolução material, ordem de compensação financeira,
			aplicação de penalidade); 4 escalationCriteria cobrem threshold de
			materialidade, evidência insuficiente, suspeita de fraude (sh-06) e
			prazo regulatório. INVERSÃO deliberada vs FCE: no FCE o default da
			operação é autonomia (gate determinístico); no DRC o default da
			RESOLUÇÃO é supervisão (julgamento não-categórico, P10). O threshold de
			materialidade como input upstream (não interpretação do DRC) é a
			proteção contra escalation-bypass por mis-classification.
			"""
	}

	assumptions: [{
		id:                 "as-drc-1"
		assumption:         "A evidência verificável de DLV (DeliveryVerified/Rejected) e os termos de CTR são suficientes para resolução determinística da maioria das disputas imateriais."
		invalidationSignal: "Taxa elevada de disputas imateriais que escalam por evidência insuficiente/conflitante — indicando que o lastro de evidência não cobre os tipos de disputa recorrentes."
		rationale:          "bd-resolution-requires-evidence + resolve-immaterial-dispute pressupõem que evidência categórica existe para o caso comum; se a maioria exige julgamento, a autonomia do DRC regride a quase-zero."
	}, {
		id:                 "as-drc-2"
		assumption:         "O threshold de materialidade é input upstream estável (policy/contrato/regulação), não exige recálculo dinâmico pelo DRC em runtime."
		invalidationSignal: "Demanda recorrente de ajuste de threshold intra-disputa ou por dimensão não capturada (e.g., materialidade por contraparte, não só por valor)."
		rationale:          "bd-material-resolution-human-gated define threshold como input externo; se múltiplas dimensões dinâmicas forem necessárias, a classificação determinística material-vs-imaterial ganha complexidade não trivial."
	}, {
		id:                 "as-drc-3"
		assumption:         "Toda reversão financeira passa pelo FCE — o DRC nunca move dinheiro, apenas emite FinancialCompensationOrdered."
		invalidationSignal: "Necessidade de o DRC executar qualquer movimentação direta (e.g., ajuste de saldo) sem intermediação do FCE."
		rationale:          "bd-decides-reversal-not-executes é o boundary anti-FCE; violá-lo daria ao DRC um aggregate de pagamento e tocaria rails, fundindo decisão de disputa com execução financeira."
	}, {
		id:                 "as-drc-4"
		assumption:         "Prazos regulatórios de contestação/estorno são conhecidos e configuráveis como input externo, não derivados pelo DRC."
		invalidationSignal: "Surgimento de tipos de disputa cujo prazo regulatório exige interpretação jurídica caso-a-caso em vez de configuração declarativa."
		rationale:          "escalation regulatory-deadline-at-risk pressupõe prazo declarado; prazo interpretativo transformaria o gate determinístico de prazo em julgamento jurídico contínuo."
	}]

	openQuestions: [{
		id:       "oq-drc-1"
		question: "Quando autorar contexts/drc/glossary.cue (ubiquitousLanguageRef forward-ref)?"
		impact:   "ubiquitousLanguageRef aponta para arquivo ainda inexistente; consolida a ubiquitous language de disputa (alegação, evidência, resolução, impacto, reversão, penalidade)."
		deadline: "2026-07-15"
		rationale: "Glossary é precondição para domain-model do DRC; forward-ref consciente (pattern fce/bdg)."
	}, {
		id:       "oq-drc-2"
		question: "Quando autorar contexts/drc/agents/drc-primary-agent.cue (domainAgentSpec forward-ref)?"
		impact:   "domainAgentSpec referencia agent spec não-materializado; o operador do lifecycle de disputa + autonomy envelope formal dependem dele. DRC tem governança rica (resolução supervisionada) que o agent spec detalhará."
		deadline: "2026-08-31"
		rationale: "Agent spec materializa o operador que executa o governanceScope; forward-ref consciente."
	}, {
		id:       "oq-drc-3"
		question: "Quando autorar contexts/drc/api.yaml e contexts/drc/async-api.yaml (superfícies hasSyncSurface/hasAsyncSurface=true)?"
		impact:   "sc-cv-02/sc-cv-03 esperam os specs; o canvas materializa com flags true/true espelhando o precedente bdg/fce (gap conhecido, não-bloqueante)."
		deadline: "2026-07-31"
		rationale: "Spec authoring é trabalho rotineiro pendente sem trade-off (WI, não deferred-decision); flags refletem a verdade das superfícies (query inbound + events)."
	}, {
		id:       "oq-drc-4"
		question: "Quando o canvas FCE enumera o consumo de DisputeResolved e FinancialCompensationOrdered (aresta drc-to-fce)?"
		impact:   "Forward-ref cross-BC: a aresta drc-to-fce é formalizada no context-map, mas o canvas FCE (mergeado em #88) não lista DRC como source. Até o FCE materializar o consumo, a relação não é bidirecional-validada no canvas FCE."
		deadline: "2026-07-15"
		rationale: "WI de reconciliação cross-BC, mesmo padrão de WI-043 (PaymentObligationDefaulted-em-rew do FCE). DRC publica; FCE formaliza consumo depois — não bloqueia o scaffold do DRC (tq-cv-02 satisfeito pela relation no context-map)."
	}]

	verificationMetrics: [{
		id:     "resolution-without-evidence"
		metric: "Número de DisputeResolved publicados sem evidenceRefs verificáveis suficientes (resolução não ancorada)."
		target: "0 — toda resolução é ancorada em evidência (bd-resolution-requires-evidence)."
		onBreach: {
			escalationRef: "evidence-insufficient-or-conflicting"
			rationale:     "Resolução sem evidência viola a invariante central do DRC; mapeia para o escalationCriterion de evidência insuficiente (resolução deveria ter escalado, não progredido)."
		}
		rationale: "Control metric — viola bd-resolution-requires-evidence diretamente; causalidade determinística (resolução não-ancorada → deveria ter escalado)."
	}, {
		id:     "material-dispute-auto-resolved"
		metric: "Número de disputas materiais (acima do threshold) resolvidas autonomamente sem human gate."
		target: "0 — resolução material é sempre supervisionada (bd-material-resolution-human-gated)."
		onBreach: {
			escalationRef: "material-dispute-threshold-exceeded"
			rationale:     "Disputa material auto-resolvida é breach da linha central de governança do DRC; mapeia para o escalationCriterion de threshold de materialidade (escalation-bypass detectado)."
		}
		rationale: "Control metric — viola P10 + bd-material-resolution-human-gated; detecta escalation-bypass por mis-classification do threshold."
	}, {
		id:     "dispute-resolution-time"
		metric: "Tempo médio entre abertura de disputa e DisputeResolved, por classe de materialidade."
		target: "Imateriais < 48h; materiais dentro do prazo regulatório aplicável (provisório — calibração Phase 1)."
		rationale: "Observability-only — latência de resolução depende de complexidade, disponibilidade de evidência e janela regulatória; sem threshold crítico determinístico de breach (o prazo regulatório tem escalation própria via regulatory-deadline-at-risk)."
	}, {
		id:     "frivolous-dispute-rate"
		metric: "Ratio de disputas perdidas (resolvidas contra o proponente por falta de evidência) por proponente, em janela temporal."
		target: "< 15% por proponente (provisório — calibração Phase 1); ratio elevado correlaciona com gaming sh-06."
		rationale: "Observability-only — ratio elevado é diagnóstico de possível disputa frívola, mas exige análise contextual (um proponente pode perder disputas de boa-fé). Candidata a promoção a control via suspected-dispute-fraud se Phase 1+ identificar padrão estável e reproduzível."
	}]

	rationale: """
		DRC é o BC supporting que orquestra o lifecycle de exceções da Mesh —
		disputas, contestações, reversões, penalidades e estornos —, separando o
		fluxo de exceção do fluxo normal do compromisso (CMT). businessRole
		operational-enabler (viabiliza recovery/correção, não enforça invariante
		categórica), archetype primary execution + secondary analysis (avalia
		disputa contra evidência — distinção real vs gateway do FCE), product na
		evolução Wardley. A invariante própria é bd-resolution-requires-evidence
		(ancorada em mech-evidence): toda resolução é lastreada em evidência
		verificável (DLV) e termos (CTR) — o que torna o DRC mais que um workflow
		engine genérico e protege contra disputa-como-fraude. Fronteiras: DRC
		decide reversão, FCE executa (bd-decides-reversal-not-executes); DRC
		aplica penalidade, CTR define (bd-applies-penalty-not-defines); disputa
		tem lifecycle próprio, CMT governa o compromisso (bd-dispute-lifecycle-
		separate). Governança: INVERSÃO vs FCE — o default da resolução é
		supervisão (julgamento não-categórico, P10), não autonomia; o threshold
		de materialidade é input upstream (não interpretação do DRC), protegendo
		contra escalation-bypass. Topologia das relações: o ciclo cmt↔drc é
		tipado bidirectional-orchestration (adr-122, W1) — DRC conforma ao kind
		já canônico, não deriva kind novo; dlv-to-drc, ctr-to-drc e drc-to-fce
		são unidirecionais acíclicas. Teste de remoção (P13): remover DRC para o
		tratamento de exceções por perda de função, não acoplamento — o fluxo
		normal do compromisso (CMT) opera sem disputas. Segunda aplicação de P13
		(adr-129), primeira em modo batch.
		"""
}
