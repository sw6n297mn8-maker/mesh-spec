package bkr

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Banking Rails & Settlement.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// BKR é boundary entre a Mesh (lógica financeira proprietária) e o
// sistema financeiro regulado pelo Bacen (rails comoditizados,
// protocolos uniformes Pix, TED, boleto e, quando aplicável,
// SWIFT/correspondent banking). Executa liquidação física sob
// autorização upstream — não decide mérito econômico de pagamento
// (decisão permanece em FCE/TCM/policy).
//
// Anti-core differentiator: high criticality operacional (movimenta
// dinheiro real, regulado pelo Bacen e integrado ao SPB/PIX por meio
// de instituições autorizadas) com low strategic uniqueness (rails
// substituíveis por qualquer provedor que implemente os mesmos
// protocolos). BKR existe como BC separado para absorver
// heterogeneidade de protocolos bancários atrás de interface
// uniforme — sem isto, FCE absorveria complexidade de cada rail e
// acoplaria lógica financeira proprietária a integrações commodity.
//
// Frase canônica do papel: BKR é o portão técnico para os rails;
// FCE decide a obrigação econômica; o Bacen regula o sistema
// financeiro pelo qual o dinheiro se move.
//
// Authoring manual section-by-section per manualAuthoringProtocol
// (adr-057). Materializado em 7 commits incrementais:
//   1.1 — skeleton: identity + classification + roles + ownership
//         (este commit)
//   1.2 — capabilities
//   1.3 — businessDecisions + stakeholders (generic isento de
//         costsEliminated per tq-cv-10)
//   1.4 — communication (inbound from FCE; outbound settlement
//         events; query-deps a TCM/providers; commands;
//         query-surfaces)
//   1.5 — incentiveAnalysis + governanceScope
//   1.6 — assumptions + openQuestions + verificationMetrics +
//         outer rationale
//   1.7 — SRR srr-bkr-canvas
//
// Cada commit deixa o canvas em shape válido (cue vet ./...) com
// conteúdo placeholder explícito nas seções pendentes — substituído
// por conteúdo substantivo no commit subsequente.

canvas: artifact_schemas.#Canvas & {
	code: "bkr"
	name: "Banking Rails & Settlement"

	purpose: """
		Executar liquidação física via rails bancários (Pix via SPI,
		TED via STR/SITRAF, boleto via SILOC/CIP e, quando aplicável,
		SWIFT/correspondent banking em transição MT→MX/ISO 20022)
		sob autorização upstream. BKR é boundary entre a Mesh (lógica
		financeira proprietária) e o sistema financeiro regulado pelo
		Bacen e integrado ao SPB (SPI/STR/SILOC) por meio de
		instituição autorizada parceira ou PSTI homologada. Não
		decide mérito econômico de pagamento — decisão permanece
		upstream em FCE/TCM/policy. BKR pode tomar decisões técnicas
		de roteamento e rail selection (qual protocolo usar; retry
		strategy; timeout handling) restritas a parâmetros técnicos
		+ constraints upstream-declared; nunca decisão econômica
		(autorizar pagamento, definir valor, alterar destinatário,
		escolher rail com fee/timing diferente do declarado).

		Anti-core differentiator: high criticality operacional
		(movimenta dinheiro real, regulado pelo Bacen e integrado
		ao SPB/SPI por meio de instituições autorizadas) com low
		strategic uniqueness (rails substituíveis por qualquer
		PSTI/IP/banco parceiro que implemente os mesmos protocolos).
		BKR existe como BC separado para absorver heterogeneidade
		de protocolos bancários atrás de interface uniforme — sem
		isto, FCE absorveria complexidade de cada rail e acoplaria
		lógica financeira proprietária a integrações commodity.

		Identidade canônica BKR: deterministic settlement
		orchestration boundary under externally authorized
		economic intent.
		"""

	ubiquitousLanguageRef: "contexts/bkr/glossary.cue"

	classification: {
		subdomainType:    "generic"
		businessRole:     "operational-enabler"
		wardleyEvolution: "commodity"
		rationale: """
			Generic porque rails bancários (Pix, TED, boleto e,
			quando aplicável, SWIFT/correspondent banking) são
			infraestrutura comoditizada — protocolos definidos pelo
			Bacen e instituições financeiras, não pela Mesh.
			Diferenciação competitiva reside em FCE (quando/por que
			pagar) e REW (sob quais condições), não em como o
			dinheiro se move fisicamente. BKR é substituível por
			construção: qualquer provedor que implemente os mesmos
			protocolos realiza a mesma função.

			Operational-enabler porque BKR habilita execução
			operacional do sistema (liquidação física) sem ser fonte
			de receita (revenue-generator é CMT/SCF), engajamento
			(engagement-creator é NGR/NPM) ou compliance regulatório
			primário (compliance-enforcer é IDC para LGPD/KYC, ATO
			para fiscal). BKR está sob constraint regulatório do
			Bacen, mas seu papel funcional é executor habilitador,
			não enforcer. Distinção análoga ao papel DLV (compliance
			interna da tese vs externa): BKR sob regulação externa
			Bacen é boundary constraint, não papel ativo de
			enforcement.

			Commodity (Wardley) reflete maturidade dos rails:
			Pix/TED/boleto estabelecidos há anos; SWIFT desde 1973;
			padrões ISO 20022 amplamente adotados. Não é product
			(rails não são solução de mercado vendida pela Mesh);
			não é custom (protocolos não construídos pela Mesh); não
			é genesis (problema completamente resolvido em escala
			global).
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Rails bancários (Pix, TED, boleto e, quando aplicável,
			SWIFT/correspondent banking) são protocolos uniformes
			definidos pelo Bacen e instituições financeiras —
			aplicam-se identicamente a qualquer vertical (construção,
			agronegócio, serviços, comércio exterior, energia).
			Diferenciação por vertical reside em FCE (regras de
			liquidação por contrato) e ATO (compliance fiscal por
			regime tributário do setor), não em como o dinheiro se
			move fisicamente. Estrutura preservada: BKR permanece
			estável enquanto verticais expandem; expansão vertical
			adiciona contratos upstream sem alterar engine de rails.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["execution"]
		rationale: """
			Gateway como primário: BKR é boundary topológico entre
			Mesh e sistema financeiro regulado externo. Captura papel
			de tradução entre vocabulário interno Mesh
			(PaymentInstruction, SettlementRequest) e protocolos
			externos (ISO 20022, COMPE, SWIFT MT). Frase canônica:
			BKR é o portão técnico para os rails; FCE decide a
			obrigação econômica; o Bacen regula o sistema financeiro
			pelo qual o dinheiro se move.

			Execution como secundário: BKR executa liquidação física
			sob autorização upstream — recebe instrução finalizada,
			despacha para rail apropriado, recebe confirmação/falha,
			emite resultado de settlement. A dupla gateway+execution
			captura a tensão fundamental do BKR: topologicamente
			boundary com sistema externo, funcionalmente executor de
			instruções recebidas. NÃO 'analysis' (REW analisa risco;
			BKR não avalia); NÃO 'specification' (FCE especifica
			liquidação; BKR consome especificação); NÃO 'engagement'
			(NPM domain); NÃO 'draft' (não há autoria de proposta —
			BKR recebe instruções finalizadas).

			Anti-decision (boundary explícita): BKR é deliberadamente
			sem autoridade de decisão econômica. Decisões técnicas
			(rail selection, retry strategy, timeout handling)
			permitidas no escopo gateway/execution; decisões
			econômicas (autorizar pagamento, definir valor, alterar
			destinatário) fora do escopo — pertencem a FCE/TCM
			upstream.
			"""
	}

	// =============================================
	// CAPABILITIES — Phase 1.2 WI-062
	// =============================================

	capabilities: {
		operational: [{
			capabilityRef: "cc-03"
			description: """
				Despachar PaymentInstruction recebida de FCE (já
				autorizada upstream) para o rail bancário declarado
				na instrução OU deterministically selected by technical
				routing policy (e.g., latency, provider availability,
				fee tier) quando FCE delega seleção. Despacho é
				puramente técnico: não avalia mérito econômico da
				instrução nem altera valor, destinatário ou obrigação
				declarada. Rail selection nunca altera custo, prioridade
				econômica ou destinatário sem autorização upstream.
				"""
			rationale: """
				Encapsula heterogeneidade de protocolos atrás de
				interface uniforme. Sem despacho centralizado, FCE
				absorveria seleção de rail (decisão commodity)
				acoplando lógica financeira a integrações substituíveis.
				cc-03 (operação 24/7) habilitada por mech-agent-gate:
				BKR consome PaymentInstruction como unidade atômica
				autorizada e despacha sem janelas batch nem intervenção
				rotineira. Routing policy é determinística e auditável
				— quando aplicada, registra escolha + critério no event
				log para replay.
				"""
		}, {
			capabilityRef: "cc-03"
			description: """
				Traduzir vocabulário interno Mesh (PaymentInstruction,
				SettlementRequest, structured fields) para formatos
				externos de rails — ISO 20022 (pacs.008 credit transfer
				/ pacs.002 status / pacs.004 return para SPI; ISO 20022
				também em STR via TED), formatos CIP/SILOC para boletos
				cobrança e DOC/TEC legacy, SWIFT MT/MX para
				correspondent banking — sem reinterpretar semântica
				financeira. Inclui interação com DICT (Diretório de
				Identificadores de Contas Transacionais) para Pix key
				resolution, claims, infractions e refunds. Tradução é
				estrutural campo a campo per spec do protocolo.
				"""
			rationale: """
				Boundary técnico. Protocolos externos evoluem (Pix v2,
				SWIFT MT→MX migration ISO 20022, Drex CBDC emergente)
				sem precisar alterar contratos internos Mesh. cc-03
				(operação 24/7) habilitada por absorver volatilidade
				de formato dentro do BKR: FCE permanece estável
				enquanto rails mudam. Tradução é função pura sobre
				instrução autorizada — output é representação
				isomórfica em protocolo externo, não reinterpretação.
				Separação rails vs infra vs messaging: rails (Pix/TED/
				boleto/SWIFT) são produtos; infra (SPI/STR/SITRAF/SILOC/
				CIP) são sistemas de liquidação; messaging (ISO 20022
				pacs.*, SWIFT MT/MX) são formatos. BKR opera nas 3
				camadas simultaneamente sem colapsá-las.
				"""
		}, {
			capabilityRef: "cc-04"
			description: """
				Consumir confirmação ou falha emitida pelo rail
				(synchronous response síncrono via pacs.002 para Pix
				em SPI; async callback ou polling para TED via STR/
				SITRAF; arquivos CNAB / API retorno para boleto via
				SILOC), reconciliar com PaymentInstruction original
				via identifiers correlacionáveis (instructionId
				upstream FCE; attemptId per tentativa BKR;
				railReferenceId externo — endToEndId Pix, ISPB+
				identifiers TED, Nosso Número boleto), e emitir
				SettlementCompleted / SettlementFailed como evento
				canônico Mesh consumido por FCE/TCM/ATO. Estado
				interno explícito: dispatched-awaiting-confirmation /
				reconciled-completed / reconciled-failed /
				indeterminate (timeout sem resposta definitiva).
				Apenas estados reconciled-* emitem outcome canônico;
				indeterminate é operationally non-final — escala
				para classification (capability 6), nunca emite
				outcome sob ambiguidade.
				"""
			rationale: """
				Rails têm semânticas heterogêneas de confirmação (Pix
				instantâneo síncrono via SPI; TED D+0 com janelas STR;
				boleto D+1/D+2 async via SILOC; SWIFT multi-hop
				correspondent). BKR uniformiza outcome em vocabulário
				Mesh sem alterar estado real nem reinterpretar
				economicamente o resultado. cc-04 (auditoria contínua)
				habilitada por mech-three-sots: reconciliação
				determinística produz events que feed audit trail
				imutável; cada settlement é rastreável da instrução
				upstream à confirmação rail via instructionId →
				attemptId → railReferenceId chain. Indeterminate
				explicitamente modelado como estado operacional não-
				final previne emissão otimista de outcome canônico
				downstream.
				"""
		}, {
			capabilityRef: "cc-04"
			description: """
				Garantir que despacho repetido NÃO produz settlement
				duplicado. Distinção crítica entre 4 identifiers:
				  - instructionId (business correlation, FCE-owned):
				    identifica a obrigação econômica única; pode
				    haver múltiplas tentativas legítimas sob mesmo
				    instructionId (e.g., recurring payment,
				    cancel-then-reissue).
				  - attemptId (per execution attempt, BKR-owned):
				    identifica cada tentativa de despacho técnico;
				    derivado deterministicamente de instructionId +
				    counter monotônico.
				  - railReferenceId (rail-owned external identifier):
				    endToEndId Pix; Nosso Número boleto; ISPB+
				    identifiers TED. BKR consome como output do rail;
				    não gera.
				  - idempotencyKey (BKR-constructed for enforcement):
				    derivado de attemptId; estável por tentativa.
				    Mesma key → no-op idempotente (retorna resultado
				    anterior).
				BKR enforça idempotency POR idempotencyKey (per
				attempt), NÃO por instructionId (per business
				correlation). Recurring legítimo permitido sob mesmo
				instructionId + novo attemptId + novo idempotencyKey.
				Replay de mesma attempt bloqueado.
				"""
			rationale: """
				Pix/TED/SWIFT têm semânticas distintas de retry —
				alguns aceitam idempotency nativamente (Pix endToEndId
				como railReferenceId), outros não. BKR provê garantia
				uniforme upstream para FCE: mesma attempt não é
				executada duas vezes mesmo sob falha de rede, retry de
				FCE ou re-delivery de evento. Distinção 4-way previne
				duas falhas opostas: (1) replay attack via reuse de
				instructionId em mesma attempt (bloqueado por
				idempotencyKey); (2) recurring payment legítimo bloqueado
				por idempotency confundindo business correlation com
				execution lineage (permitido por separar instructionId
				de attemptId). cc-04 requer correção por construção:
				event log sem duplicação é precondição para audit
				trail confiável. Idempotency é capability central que
				precede retry — retry sem idempotency vira vector de
				double-settlement.
				"""
		}, {
			capabilityRef: "cc-03"
			description: """
				Aplicar política de retry e timeout determinística para
				falhas técnicas transitórias (rail timeout, transient
				provider error, network partition). Política codificada
				(max retries, backoff schedule, escalation timeout) por
				classe de falha técnica E por rail — Pix opera 24/7
				via SPI; TED respeita horários STR/SITRAF definidos
				pelo Bacen; boleto via SILOC tem janelas D+0/D+1.
				Operational hours são constraint determinística de
				retry policy (retry fora da janela do rail aguarda
				próxima janela, não falha).

				Atomic state machine sobre cada attempt:
				requested → in-flight → (confirmed | failed |
				indeterminate). Retry permitido apenas em transição
				in-flight expirado → indeterminate, gerando NOVO
				attemptId + idempotencyKey (technical lineage
				explícita, não mesma execução prolongada). Race
				condition guard: se confirmação chega enquanto retry
				está in-flight, retry-in-flight é invalidado por
				idempotency (capability 4) — provider rejeita ou
				retorna no-op para attempt redundante. Após confirmed
				ou failed terminais, retry proibido — caso transita
				para reconciliation/escalation.
				"""
			rationale: """
				Falhas técnicas transitórias são commonplace em
				integrações externas (rails de terceiros). Política
				determinística habilita replay, audit e supersession
				(P10 — agentes estocásticos recomendam; gates
				determinísticos validam). cc-03 (operação 24/7) requer
				resiliência sem intervenção humana rotineira. Retry
				como lineage técnica explícita (novo attemptId per
				tentativa) supera ambiguidade de 'mesma execução
				prolongada': cada attempt é evento auditável
				independente, ligado a instructionId pela cadeia
				causal. Bloqueio post-confirmação é não-negociável:
				retry após confirmação é vector direto de
				double-settlement, que é falha em economia real
				(dinheiro movido duas vezes). Idempotency (capability
				4) é precondição estrutural; retry guard é precondição
				comportamental; operational hours são precondição
				temporal.
				"""
		}, {
			capabilityRef: "cc-03"
			description: """
				Classificar falhas em categorias canônicas com routing
				distinto. 3-way distinction crítica baseada em
				ownership causal de classificação:

				A) Structural (BKR autoritativo — conhece schema da
				   instrução, valida deterministicamente):
				   - 'structural-instruction-invalid' (campos
				     malformados, schema violation, missing required
				     fields, type mismatch, authorization proof
				     ausente ou malformada)
				   - Routing: reject at BKR boundary com rejection
				     event contendo categoria + field-specific error
				     code estruturado.

				B) Technical (BKR autoritativo — observa rail/provider
				   sob policy interna):
				   - 'technical-transient' / 'provider-unavailable' /
				     'rail-rate-limited' / 'rail-out-of-hours'
				   - Routing: retry interno determinístico (capability
				     5) dentro de operational hours per rail.

				C) Regulatory + Economic (BKR NÃO autoritativo —
				   rail ou external compliance decide; BKR só observa
				   retorno):
				   - 'rail-rejected' (genérico — provider rejeitou
				     sem categoria fina)
				   - 'regulatory-block' (sanctions list hit, AML
				     trigger, limite operacional excedido)
				   - 'economic-instruction-invalid' (semantic merit
				     — destinatário inexistente, valor inválido)
				   - Routing: escalation a FCE para decisão sobre
				     reissuance/cancellation.

				Side-channel mitigation: classification event emitido
				para FCE (upstream authorizer) pode ser detailed;
				events públicos a outros consumers (audit log
				agregado, sh-02 fornecedor downstream) carregam
				apenas categoria genérica + outcome — sem detail que
				vaze compliance info (e.g., 'rail-rejected' não
				revela sanctions hit specifically, evitando vazamento
				de status regulatório de partes).
				"""
			rationale: """
				cc-03 (operação 24/7) requer routing determinístico
				de falhas — humanos intervêm por exceção, não por
				rotina. Ownership causal de classificação é o eixo
				crítico: BKR só classifica autoritativamente o que
				BKR pode observar diretamente (structural sobre
				schema próprio; technical sobre comportamento
				rail/provider). Regulatory + economic vêm de
				external authority (rail processor, compliance
				upstream, FCE) — BKR é pass-through, não juiz.
				Handoff respeita boundary anti-decision: BKR rejeita
				structural sem escalar (custo de escalation > custo
				de rejection; BKR é local validador); BKR escala
				economic+regulatory sem rejeitar (rejeitar exigiria
				julgamento de mérito que BKR não tem). Side-channel
				mitigation impede que classification vire vetor de
				vazamento de informação sensível para parties que
				não têm need-to-know — categorias genéricas
				downstream, detail para upstream authority.
				"""
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// =============================================
	// COMMUNICATION — Phase 1.4 WI-062
	// =============================================

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "FCE emite PaymentInstruction com authorization proof (cryptographic signature canonical + nonce + issued-at + validity window + claim chain — per bd-settlement-authorization-upstream). BKR valida proof estruturalmente antes de qualquer dispatch."
			command:         "DispatchPayment"
			resultingEvents: ["SettlementCompleted", "SettlementFailed", "SettlementIndeterminate", "DispatchClassification"]
			description:     "Primary BKR command. FCE como autoridade econômica delega execução técnica a BKR sob authorization proof verificável. instructionId carregado em PaymentInstruction; BKR atribui attemptId per tentativa; railReferenceId emerge do rail post-dispatch."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "FCE solicita cancellation de instructionId+attemptId ainda em estado dispatched-awaiting-confirmation (pre-finality). Solicitação é NON-GUARANTEED — alguns rails aceitam cancel request (e.g., pacs.057 em SPI), outros best-effort, outros já entraram em clearing irreversível mesmo sem confirmation local."
			command:         "RequestSettlementCancellation"
			resultingEvents: ["DispatchCancellationAcknowledged", "DispatchCancellationRejected", "SettlementCompleted", "SettlementFailed"]
			description:     "BKR may request cancellation before settlement finality, but settlement finality remains determined by the underlying rail. Rejeitado se attemptId já em estado reconciled-* (post-finality cancel exige reverse settlement upstream — fora de Phase 0). Race condition: cancel + confirmation podem colidir; idempotency (capability 4) resolve via attemptId state machine."
		}, {
			type:          "event-consumer"
			sourceContext: "tcm"
			event:         "CashOperationalStatusUpdated"
			reaction:      "BKR ajusta retry policy (capability 5) e operational availability classification (capability 6). TCM informs operational liquidity constraints (e.g., posição em conta PI suficiente para próxima janela TED), NOT settlement authorization nem timing econômico. BKR não decide PAGAR baseado em sinal TCM; apenas executa OU aguarda janela apropriada conforme constraint operacional informado."
			description:   "Boundary semantic crítica: FCE autoriza economicamente; TCM informa constraint operacional de liquidez; BKR executa tecnicamente; rail determina finality. TCM evento NÃO é authorization signal — confundir destruiria separação BC. Per Phase 1.3 sh-04 + identidade canônica BKR."
		}, {
			type:          "event-consumer"
			sourceContext: "ext-partner-bank-or-psti"
			event:         "RailProviderStatusUpdated"
			reaction:      "Atualiza operational state de cada rail família (SPI/STR/SITRAF/SILOC/SWIFT) surfaceada pelo partner/PSTI integrator. Informa retry policy + classification (categoria technical: provider-unavailable, rail-out-of-hours, rail-rate-limited). BKR observa status; não decide settlement economic merit baseado em status."
			description:   "Integration physical via PSTI homologada ou banco parceiro autorizado (per Phase 1.1 purpose); status events surfacem rail-level semantics (finality, retry, window) através do integration partner. Granularidade rail-by-rail preservada em query-deps + command-invocations (refs ext-spi-bacen, ext-str-bacen, etc.); event-consumer single porque integration boundary é única."
		}, {
			type:        "query-surface"
			query:       "QuerySettlementStatus"
			returnType:  "SettlementStatusView"
			description: "Read model from event log canonical. Consultável por instructionId (business correlation) | attemptId (execution lineage) | railReferenceId (external reference). Retorna estado canônico ∈ {dispatched-awaiting-confirmation, reconciled-completed, reconciled-failed, indeterminate, cancellation-requested, cancellation-acknowledged}. Não emite outcome canonical sob estados não-finais — consumers downstream observam estado, não decidem por ele."
		}, {
			type:        "query-surface"
			query:       "QueryDispatchClassification"
			returnType:  "DispatchClassificationView"
			description: "Failure classification detail consultável por instructionId | attemptId. Side-channel-aware: payload detalhado retornado apenas para callers identificáveis como upstream authorizer (FCE); demais consumers (audit, downstream observers) recebem categoria genérica + outcome sem detail que vaze compliance info (e.g., 'rail-rejected' sem revelar sanctions hit specifically). Per Phase 1.2 cap 6 side-channel mitigation."
		}]

		outbound: [{
			type:    "event-publisher"
			trigger: "Reconciliação determinística com confirmação rail (capability 3) atinge estado reconciled-completed."
			event:   "SettlementCompleted"
			consumers: ["fce", "tcm", "ato"]
			description: "Outcome canonical — único evento de sucesso. Payload carrega instructionId + attemptId + railReferenceId + settlement timestamp final + rail discriminator. FCE consome para confirmation closure; TCM consome para cash position commit; ATO consome para repercussão fiscal/contábil. Não emitido sob estado intermediário ou indeterminate."
		}, {
			type:    "event-publisher"
			trigger: "Reconciliação determinística com confirmação rail atinge estado reconciled-failed (rail rejeitou explicitamente; classification per capability 6)."
			event:   "SettlementFailed"
			consumers: ["fce", "tcm", "ato"]
			description: "Outcome canonical de falha. Payload para fce inclui classification detail (side-channel-aware); payload para tcm/ato carrega outcome + categoria genérica sem detail sensível. FCE decide reissuance/cancellation; TCM reverte cash position reservado (se aplicável); ATO no-op fiscal ou annulment de prévio reconhecimento."
		}, {
			type:    "event-publisher"
			trigger: "Estado attempt transita para indeterminate (timeout sem resposta definitiva do rail; provider em estado ambíguo) após esgotar retry policy interna."
			event:   "SettlementIndeterminate"
			consumers: ["fce"]
			description: "Operational non-final escalation. Indeterminate é epistemicamente distinto de Failed — não sabemos outcome ainda, não que falhou. Evento separado preserva replay safety, reconciliation semantics e operational auditability — colapsar em Failed destruiria essas propriedades. FCE decide manual reconciliation, external check (e.g., consultar saldo via STR pull), ou aguardar próxima janela rail."
		}, {
			type:    "event-publisher"
			trigger: "Failure classification (capability 6) categoriza falha por ownership causal (structural BKR-authoritative | technical BKR-authoritative | regulatory+economic pass-through)."
			event:   "DispatchClassification"
			consumers: ["fce"]
			description: "Routing de failure handoff per Phase 1.2 cap 6. Detail completo enviado a fce (upstream authorizer com need-to-know); audit aggregate emitido em separado (não aqui) para outros consumers, sanitizado contra side-channel leak. Categorias canônicas: structural-instruction-invalid, technical-transient, provider-unavailable, rail-rate-limited, rail-out-of-hours, rail-rejected, regulatory-block, economic-instruction-invalid."
		}, {
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "ext-spi-bacen"
			command:         "SubmitPixPayment"
			trigger:         "PaymentInstruction validada (authorization proof + DICT resolution + structural validation) com rail=Pix. Despacho via PSTI/partner como integration physical."
			description:     "ISO 20022 pacs.008 credit transfer message. Confirmação síncrona via pacs.002 (status report) recebida no mesmo round-trip OU async callback. endToEndId Pix emerge como railReferenceId. SPI 24/7 — operational window não é constraint temporal; provider/DICT availability é. Per Phase 1.2 cap 2 protocol translation."
		}, {
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "ext-str-bacen"
			command:         "SubmitTedTransfer"
			trigger:         "PaymentInstruction validada com rail=TED. Despacho dentro de janela STR (horários Bacen) OU SITRAF como alternativa via CIP."
			description:     "ISO 20022 (em transição via STR modernization) ou formato STR legacy. Confirmação settlement via STR canonical message dentro de mesma data útil. SITRAF é alternative path via CIP com semantics similar; rail selection (capability 1) determina qual. ISPB+identifiers TED como railReferenceId."
		}, {
			type:            "command-invocation"
			interactionMode: "sync"
			targetContext:   "ext-siloc-cip"
			command:         "SubmitBoletoPayment"
			trigger:         "PaymentInstruction validada com rail=boleto. Despacho sync ao partner CIP; settlement async per SILOC schedule (D+0 ou D+1)."
			description:     "CNAB 240/400 padrões ou API CIP. SILOC processa em batch com janelas determinísticas; confirmação settlement chega via retorno SILOC (file ou API push) async. Nosso Número como railReferenceId. Reconciliação consome retorno SILOC (capability 3)."
		}, {
			type:            "command-invocation"
			interactionMode: "async"
			targetContext:   "ext-swift-network"
			command:         "SubmitSwiftPayment"
			trigger:         "PaymentInstruction validada com rail=SWIFT/correspondent banking (cross-border ou specific routing). Despacho via banco correspondente."
			description:     "SWIFT MX (ISO 20022 pacs.008) por default; MT103 legacy fallback apenas para correspondent partners ainda em transição MT→MX (deadline finalizada nov/2025). Confirmation multi-hop async via correspondent bank chain; UETR (Unique End-to-End Transaction Reference) SWIFT como railReferenceId. Reconciliação cross-hop pode levar minutos a horas — indeterminate state mais provável nessa rail."
		}, {
			type:          "query-dependency"
			targetContext: "ext-spi-bacen"
			query:         "ResolvePixKey"
			purpose:       "Authoritative external resolution prerequisite (NÃO structural-local validation). DICT (Diretório de Identificadores de Contas Transacionais) é external source of truth para Pix key → account info (ISPB, agency, account, account type, holder name proof). BKR consulta como pré-requisito de dispatch; não valida semanticamente, apenas resolve via autoridade externa oficial. Falha de resolução (key não existe, conta inativa, holder mismatch) → structural-instruction-invalid classification — instrução é estruturalmente inválida porque DICT (authoritative) rejeitou o identifier."
			description:   "DICT como external source of truth distingue resolução autorizada de validação local. BKR não infere validade — DICT decide. Per Phase 1.2 cap 2."
		}, {
			type:          "query-dependency"
			targetContext: "ext-partner-bank-or-psti"
			query:         "QueryAccountAvailability"
			purpose:       "Verificar account active + within operational limits no partner/PSTI antes de dispatch. Provider obligation under arranjo de pagamento — BKR observa estado retornado pelo partner, não enforça policy."
			description:   "Pre-dispatch account check no integration boundary físico (partner bank ou PSTI). Falha → technical (provider-unavailable) ou regulatory (account-blocked) classification per capability 6."
		}, {
			type:          "query-dependency"
			targetContext: "tcm"
			query:         "QueryCashOperationalAvailability"
			purpose:       "Verificar constraint operacional de liquidez para próxima janela de rail target — TCM informs operational liquidity, NOT settlement authorization. BKR consome para garantir operational viability (e.g., conta PI tem saldo para próxima janela STR), não para decidir mérito econômico ou timing econômico."
			description:   "Separação BC explícita: FCE autorização econômica; TCM constraint operacional; BKR execução técnica; rail finality. Sinal TCM é gate operacional advisory, não authorization."
		}, {
			type:          "query-dependency"
			targetContext: "ext-spi-bacen"
			query:         "QuerySpiOperationalStatus"
			purpose:       "Verificar SPI uptime + incident flag (Bacen publica status). SPI é 24/7 mas tem incidentes documentados — query informa retry policy + classification."
			description:   "Status pull complementar ao event-consumer push (RailProviderStatusUpdated). Útil para pre-dispatch sanity check em momentos sensíveis."
		}, {
			type:          "query-dependency"
			targetContext: "ext-str-bacen"
			query:         "QueryStrWindowStatus"
			purpose:       "Verificar STR window atual (open/closed para a data; horários Bacen). Constraint determinística de retry policy (capability 5 — operational hours per rail)."
			description:   "STR opera em janelas business hours definidas por Bacen. Despacho fora da janela aguarda próxima — não falha."
		}, {
			type:          "query-dependency"
			targetContext: "ext-sitraf-cip"
			query:         "QuerySitrafWindowStatus"
			purpose:       "Verificar SITRAF window atual (alternative TED path via CIP). Distinto de STR — diferentes finality semantics, diferentes operational windows, diferentes trust assumptions."
			description:   "Granularidade preservada vs STR — SITRAF e STR são alternative paths para TED com semantics distintas. Rail selection (capability 1) determina qual usar dado upstream constraints."
		}, {
			type:          "query-dependency"
			targetContext: "ext-siloc-cip"
			query:         "QuerySilocWindowStatus"
			purpose:       "Verificar SILOC batch window (D+0/D+1 schedule). SILOC processa em batch — confirmação settlement não é instantânea. Query informa expected reconciliation timing."
			description:   "Boleto via SILOC tem reconciliation semantics diferente de Pix/TED — batch processing. Indeterminate state mais comum nessa rail durante janelas de transição."
		}, {
			type:          "query-dependency"
			targetContext: "ext-swift-network"
			query:         "QuerySwiftConnectivity"
			purpose:       "Verificar correspondent bank availability + SWIFT network connectivity. Cross-border tem múltiplos hops — connectivity é cumulativa."
			description:   "SWIFT multi-hop tem trust assumption cumulativa (correspondent chain) distinta de Pix/TED direct. Connectivity check informa retry policy + escalation timeout."
		}]

		rationale: """
			Communication boundary modela BKR como deterministic
			boundary managing the transition from economically
			authorized intent into externally finalized settlement
			under heterogeneous finality semantics — não é
			payment API genérica nem banking adapter simples.
			Esta identidade é constitutiva: cada inbound, outbound,
			query-dependency e command-invocation reflete a
			disciplina de separação BC.

			Separação canônica das responsabilidades cross-BC:
			  - FCE: autorização econômica (mérito de pagar,
			    valor, destinatário, condições);
			  - TCM: constraint operacional de liquidez (saldo
			    disponível, posição em conta PI, próxima janela);
			  - BKR: execução técnica determinística (dispatch,
			    translation, reconciliation, retry, classification,
			    cancel-request);
			  - rail (SPI/STR/SITRAF/SILOC/SWIFT): finality
			    semantics (quando dinheiro é considerado movido
			    irrevocavelmente).
			Confundir essas camadas degrada BKR a mini-treasury
			(absorvendo TCM), mini-payment-engine (absorvendo FCE),
			ou banking adapter genérico (ignorando rail heterogeneity).

			Inbound: command-handlers (FCE→BKR sob authorization
			proof verificável); event-consumers (TCM operational
			liquidity; partner/PSTI rail status aggregate);
			query-surfaces (read model side-channel-aware para
			settlement state e classification detail). 6 entries
			cobrindo todos os ingress paths.

			Outbound: event-publishers (4 outcomes canônicos —
			Completed/Failed/Indeterminate/Classification, com
			Indeterminate explicitly preservado como evento
			separado por ser epistemicamente distinto de Failed);
			command-invocations (4 rails família — SubmitPixPayment
			via SPI, SubmitTedTransfer via STR, SubmitBoletoPayment
			via SILOC, SubmitSwiftPayment via SWIFT/correspondent);
			query-dependencies (8 — DICT authoritative resolution,
			partner account availability, TCM operational liquidity,
			5 rail-specific window/connectivity checks preservando
			granularidade per-rail semantics).

			External system refs granulares (ext-spi-bacen,
			ext-str-bacen, ext-sitraf-cip, ext-siloc-cip,
			ext-swift-network, ext-partner-bank-or-psti)
			preservam informação arquitetural: cada rail tem
			finality semantics, retry semantics, operational
			windows, reconciliation semantics e trust assumptions
			distintas. Colapsar em ext-rail-provider destruiria
			topologia regulada modelada como external integration
			genérico.

			DICT modelado como authoritative external resolution
			prerequisite (não structural-local validation): DICT
			é external source of truth para Pix key → account
			mapping; BKR consulta autoridade externa oficial, não
			infere validade local. Falha de resolução é
			structural-instruction-invalid porque DICT (authoritative)
			rejeitou o identifier — não porque BKR validou
			semanticamente.

			RequestSettlementCancellation modelada como NON-GUARANTEED
			(best-effort pre-finality): BKR may request cancellation
			before settlement finality, but settlement finality
			remains determined by the underlying rail. Alguns rails
			aceitam cancel (pacs.057 SPI), outros best-effort,
			outros já clearing-irreversible mesmo sem confirmation
			local. Reverse settlement (post-finality) é nova
			obrigação econômica — fora de Phase 0 BKR scope (open
			question Phase 1.6, envolve DRC/FCE).

			Reverse settlement / estornos NÃO modelados em Phase 1.4
			— envolvem nova obrigação econômica (pacs.004, refund,
			dispute, judicial reversal, chargeback analogue) que
			explode BC boundary e aproxima BKR de dispute/payment
			engine. Defer correto a Phase 1.6 open question.

			Drex (CBDC brasileira emergente 2026) NÃO modelada em
			Phase 1.4 — pode introduzir paradigm shift (programmable
			money, atomic settlement) que reshape entire
			communication model. Defer a Phase 1.6 open question.

			Open Finance ITP NÃO modelada em Phase 1.4 — authorization
			owner ambiguity (consent OF user vs FCE Mesh) requer
			ADR separado. Defer a Phase 1.6 open question.
			"""
	}

	// =============================================
	// BUSINESS DECISIONS — Phase 1.3 WI-062
	// =============================================

	businessDecisions: [{
		id: "bd-rail-selection-is-technical-only"
		decision: """
			Rail selection é technical routing apenas — escolha entre
			Pix (SPI), TED (STR/SITRAF), boleto (SILOC/CIP) ou SWIFT/
			correspondent banking baseada em technical availability,
			protocol compatibility, operational latency, operational
			hours per rail, and upstream-declared constraints
			(limites/tier/timing window declarados em PaymentInstruction).
			Custo/fee/timing só entram como constraint declarada
			upstream, não otimização local de BKR. Selection nunca
			altera prioridade econômica, destinatário, nem settlement
			timing semantics (Pix instant ≠ TED D+0 ≠ boleto D+1 —
			escolher entre eles é decisão econômica que pertence a
			FCE, não BKR).
			"""
		rationale: """
			FCE delega a BKR seleção de rail apenas quando a instrução
			não a especifica. Mesmo quando delegada, seleção é função
			determinística sobre parâmetros técnicos + constraints
			upstream-declared — não envolve julgamento de mérito
			financeiro. Tratar rail selection como decisão econômica
			(incluindo otimização de fee) acoplaria FCE a especificidade
			de protocolos commodity e abriria vector de manipulação
			(BKR escolhe rail X com fee Y diferente do desejado por FCE).
			"""
		consequences: """
			BKR registra rail-selected + critério aplicado em event log
			(audit trail completo via cc-04); FCE pode reverter seleção
			declarando rail explícito em PaymentInstruction; mudança de
			rail provider/protocolo (e.g., novo Pix v2, novo provider
			PSP) impacta apenas BKR (substituição de protocol module),
			sem cascada em FCE; fee/cost considerations sempre vêm de
			constraints upstream — BKR não otimiza independente.
			"""
	}, {
		id: "bd-settlement-authorization-upstream"
		decision: """
			Settlement authorization deve originar-se upstream de BKR
			(FCE para liquidação, TCM para timing operacional, policy
			para boundaries). BKR não autoriza settlements — apenas
			executa instrução autorizada. BKR rejects instructions
			without verifiable upstream authorization proof. Proof
			spec (Phase 1 minimal viable):
			  - cryptographic signature sobre payload canonical
			    (PaymentInstruction fields ordenados + nonce +
			    issued-at timestamp) usando key da identity FCE-
			    publisher registrada no agent governance envelope
			    FCE (cross-BC trust anchor).
			  - signature validity window declarada upstream
			    (issued-at + TTL), bounded por operational window do
			    rail alvo (e.g., Pix: janela curta minutos; TED: até
			    janela STR de mesma data; boleto: dia útil) — janela
			    NÃO derivada do estado do rail downstream, mas
			    declarada na própria instrução pelo authorizer.
			  - claim chain rastreável: command-id FCE →
			    authorization-id FCE → instructionId BKR, todos
			    auditáveis e ligados por integridade criptográfica.
			correlationId sozinho não é proof; correlationId é
			correlation, não authority. Proof spec detalhada será
			consolidada com agent-governance envelope Phase 5.
			"""
		rationale: """
			Anti-decision boundary é constitutiva do BKR. Autorização
			requer julgamento econômico (mérito de pagar, valor correto,
			destinatário válido, timing apropriado) — capacidades fora
			do escopo BKR commodity. Permitir BKR autorizar settlements
			(ou aceitar instrução sem proof de autoridade) introduziria
			autonomia em camada que move dinheiro real sem evidência+gate
			upstream, violando mech-agent-gate. correlationId pode ser
			forjado em isolamento; proof exige cryptographic signature
			ou claim chain verificável que ancora a autoridade a FCE
			(quem detém autoridade econômica).
			"""
		consequences: """
			PaymentInstruction recebida por BKR é validada estruturalmente
			(authorization proof presente + verificável) ANTES de qualquer
			dispatch; FCE+TCM são responsáveis por validar mérito antes
			de emitir instruction; BKR rejeita PaymentInstruction sem
			authorization proof com erro estruturado
			(structural-instruction-invalid); tentativas de injetar
			settlement direto em BKR (e.g., manual override por operador)
			requerem path supervisionado fora do flow normal, registrado
			como exception event.
			"""
	}, {
		id: "bd-no-value-payee-mutation"
		decision: """
			Nenhuma mutação de valor, destinatário (payee), conta de
			origem ou condições econômicas dentro do BKR. Mutações
			operacionais técnicas (format conversion, correlation ID
			transcription, retry counter increment, protocol field
			mapping) permitidas; mutações econômicas estritamente
			proibidas. Currency conversion is out of BKR Phase 0 scope
			unless represented as a separate upstream-authorized
			instruction.
			"""
		rationale: """
			Imutabilidade econômica da PaymentInstruction é precondição
			para audit trail confiável (cc-04). Permitir BKR alterar
			valor ou destinatário introduziria ponto de manipulação
			invisível downstream de FCE — quem autorizou X poderia ter
			Y executado. Distinção técnica vs econômica é binária:
			structural (sim, mapeamento campo a campo) vs semantic
			(não, alteração de meaning). FX/currency conversion é
			explicitamente fora do scope BKR Phase 0 — abrir FX dentro
			do BKR introduziria spread/rate decisions que são pricing
			(domínio de TCM/policy upstream).
			"""
		consequences: """
			BKR consome PaymentInstruction como struct imutável após
			authorization upstream; necessidade de modificar
			valor/destinatário pós-autorização requer cancelamento +
			reissuance via FCE (path explícito, auditável);
			FX/currency conversion deferred — futuras necessidades de
			cross-currency settlement requerem ADR + WI separado
			expandindo o scope ou modelando FX como BC separado (e.g.,
			FXC) que emite PaymentInstruction final em moeda destino
			para BKR.
			"""
	}, {
		id: "bd-rail-failure-is-not-payment-decision"
		decision: """
			Falha de provider ou rail (technical-transient,
			provider-unavailable, regulatory-block, rail-rejected,
			economic-instruction-invalid) NÃO cria payment decision
			dentro do BKR. Falhas técnicas: retry interno determinístico
			(capability 5) sobre mesmo rail/mesma instrução. Falhas
			terminais: escalation a FCE para decisão sobre
			reissuance/cancellation. Cross-rail failover may change
			settlement semantics (e.g., different settlement window,
			different fee structure, different reconciliation timing)
			and therefore requires upstream authorization unless
			pre-authorized in the instruction via explicit fallback
			rails declarados.
			"""
		rationale: """
			Tratar rail failure como autorização para alternative routing
			(e.g., 'rail X falhou, BKR seleciona rail Y') seria payment
			decision implícita — escolher continuar pagando com diferente
			caminho técnico cuja semântica financeira (timing, finalidade,
			costs) difere. Anti-decision boundary preserva: BKR informa
			FCE da falha; FCE decide se reissua, cancela ou aceita.
			Pre-authorized fallback rails são possíveis se FCE declara em
			PaymentInstruction (e.g., 'Pix primary, TED fallback if Pix
			unavailable'), mas decisão pertence a FCE no momento da
			autorização original, não a BKR no momento da falha.
			"""
		consequences: """
			Cross-rail failover (Pix→TED após Pix indisponível) só ocorre
			se pre-authorized via fallbackRails em PaymentInstruction OU
			se FCE emite nova PaymentInstruction; BKR pode oferecer a
			FCE informação sobre rail availability como sinal advisory
			(não como autorização); rail provider downtime prolongado
			escala automaticamente — não vira workaround silencioso;
			BKR não pode 'salvar' liquidação trocando rail sem permissão
			explícita.
			"""
	}, {
		id: "bd-settlement-state-post-reconciliation"
		decision: """
			Settlement state (SettlementCompleted, SettlementFailed,
			SettlementPending) é canonical apenas após reconciliation
			com confirmação de rail (capability 3). Estado intermediário
			(dispatched-awaiting-confirmation, retry-in-progress) é
			interno ao BKR e não emitido como event downstream.
			"""
		rationale: """
			Rails têm semânticas de latência distintas — Pix instantâneo,
			TED com janelas D+0/D+1, boleto D+1/D+2 com refeitura, SWIFT
			multi-hop com confirmações em cascata. Emitir
			SettlementCompleted otimisticamente (e.g., após dispatch
			successful sem aguardar confirmação rail) criaria estado
			incorreto downstream caso provider rejeite asynchronously ou
			reverta. Apenas reconciliation com confirmação rail fecha o
			loop. Sem isto, audit trail (cc-04) perde correspondência
			com realidade financeira — event log diverge do estado real
			de dinheiro movido.
			"""
		consequences: """
			FCE/TCM/ATO consomem apenas eventos pós-reconciliation —
			ledger downstream reflete realidade rail; despachos pendentes
			não aparecem em ledger até confirmados; estado ambíguo
			(provider sem resposta dentro do timeout) escala como
			exception, não vira default 'pending forever'; idempotency
			(capability 4) garante que mesma instrução não dispara dois
			settlements canonicalizados mesmo em caso de retry após
			ambiguidade.
			"""
	}]

	// =============================================
	// STAKEHOLDERS — Phase 1.3 WI-062
	// =============================================

	stakeholders: [{
		stakeholderRef: "sh-01"
		roleInContext: """
			Originadora upstream cuja PaymentInstruction (emitida via
			FCE) é executada por BKR. Consumidora indireta de
			settlement outcome para coordenação de fluxo financeiro
			(e.g., baixa de obrigação, atualização de status interno,
			kickoff de próxima etapa operacional).
			"""
		impactDescription: """
			Velocidade e confiabilidade de settlement determinam ciclo
			de caixa da operação. Failures recorrentes de BKR podem
			travar liquidações downstream impactando relação com
			fornecedores e capacidade de SCF (antecipação depende de
			settlements limpos). Ambiguidade de estado
			(não-reconciliação) gera incerteza operacional sobre
			cumprimento de compromissos.
			"""
		rationale: """
			sh-01 é raiz econômica do macrofluxo
			(P2P→CMT→...→FCE→BKR). BKR move o dinheiro que sh-01
			autorizou via FCE. Embora sh-01 não interaja diretamente
			com BKR (canais via FCE), seu interesse em settlement
			determinístico é primário — BKR é último ponto antes da
			obrigação econômica ser cumprida fisicamente.
			"""
	}, {
		stakeholderRef: "sh-02"
		roleInContext: """
			Beneficiário final — recebe crédito real via rail bancário
			no fim da cadeia. BKR é o ponto onde a obrigação econômica
			gerada upstream (em CMT/FCE) materializa-se em dinheiro
			movido para sh-02.
			"""
		impactDescription: """
			Settlement success/failure afeta diretamente recebimento
			físico de fundos. Ambiguidade pós-dispatch (sem
			reconciliation) gera incerteza operacional — sh-02 não
			pode atuar sobre crédito esperado até reconciliation
			confirmar. Failures terminais ou delays prolongados
			impactam fluxo de caixa de sh-02 (especialmente para
			fornecedores com baixa folga operacional).
			"""
		rationale: """
			sh-02 é beneficiário direto do output BKR — o crédito chega
			via rail consumido por BKR. Confiabilidade BKR (incluindo
			idempotency, reconciliation, classification) é determinante
			para experiência sh-02. Sem reconciliation canonical, sh-02
			não sabe se foi pago, gerando follow-ups manuais que custam
			tempo a ambos lados.
			"""
	}, {
		stakeholderRef: "sh-04"
		roleInContext: """
			Regulador do sistema financeiro pelo qual BKR opera —
			SPB/SPI/STR/SITRAF/SILOC operados pelo Bacen ou pela CIP
			sob supervisão Bacen. Define operational limits, settlement
			rules, payment arrangement requirements e provider
			obligations sobre rails que BKR utiliza. Bacen NÃO consome
			eventos BKR diretamente — reporting compliance flui via
			instituição autorizada parceira (PSTI homologada ou banco
			parceiro) sob arranjo de pagamento. Modelado como stakeholder
			por schema accommodation (canvas exige sh-NN refs para
			actors materially affecting BC); semanticamente é boundary
			constraint provider, não downstream consumer.
			"""
		impactDescription: """
			Boundary constraint provider (não stakeholder consumer
			downstream). Regulação Bacen define o universo de rails
			utilizáveis e limites operacionais aplicáveis (limites
			Pix, horários STR, requisitos PSTI/IP/SCD em arranjos de
			pagamento). Mudanças regulatórias (Pix v2, limites
			prudenciais, novos arranjos, Drex CBDC emergente 2026)
			impactam capabilities BKR (precisam refletir nova spec do
			rail) e business model upstream (e.g., SCD R$ 5M capital
			requirement 2026 para conta transacional Pix), mas não
			autoridade econômica BKR (que permanece em FCE/SCF/policy).
			"""
		rationale: """
			sh-04 é boundary constraint sobre operações BKR. Diferente
			de atuar como compliance-enforcer ativo dentro do BKR
			(papel de IDC/NPM/FCE para KYC/AML/Bacen reporting), Bacen
			impacta BKR via spec dos rails e requisitos operacionais
			sobre provedores. BKR opera no espaço definido pelo Bacen,
			mas não enforça policy regulatória — apenas executa dentro
			das regras de protocolo já incorporadas nos rails.
			Reporting Bacen flui via parceiro autorizado (PSTI/banco/
			IP), não via BKR direto — BKR não tem conta no Bacen nem
			interage com endpoints regulatórios externos diretamente.
			"""
	}, {
		stakeholderRef: "sh-05"
		roleInContext: """
			Operador primário do BKR — dispatcha PaymentInstruction
			recebida de FCE, monitora reconciliation, aplica retry
			policy determinística, classifica failures, escala
			exceptions a FCE quando boundary anti-decision é tocada.
			Atua dentro do governanceScope definido em Phase 1.5.
			"""
		impactDescription: """
			Saúde operacional do agente determina disponibilidade
			contínua de BKR (cc-03 — operação 24/7). Decisões técnicas
			autônomas (rail selection determinístico, retry sob policy
			codificada) requerem boundaries explícitas em capabilities +
			businessDecisions + governanceScope para não vazarem em
			decisões econômicas. Drift de comportamento do agente vira
			fonte de risco operacional direto sobre dinheiro real.
			"""
		rationale: """
			sh-05 é o ator que materializa as decisões técnicas do BKR
			no dia-a-dia operacional. Diferente de DLV (analysis
			primary), BKR agent é gateway+execution — recebe, traduz,
			despacha, reconcilia, classifica. Anti-decision boundary do
			BKR depende crucialmente da disciplina do agente em rejeitar
			tentações de remediação econômica (e.g., 'rail X falhou,
			talvez tentar rail Y faria FCE economizar tempo');
			governance envelope Phase 1.5 codifica essas boundaries
			determinísticas.
			"""
	}]

	// =============================================
	// COSTS ELIMINATED — intentionally omitted (generic BC)
	// =============================================
	//
	// BKR é classification.subdomainType "generic" — schema permite
	// omissão de costsEliminated (campo optional `costsEliminated?`).
	// Quality criterion tq-cv-10 enforça presença apenas para
	// core/supporting; generic é isento por design.
	//
	// Rationale da isenção: BKR não faz claim direto de
	// cost-elimination per se. Valor agregado é risk/complexity
	// isolation entre Mesh (lógica financeira proprietária) e rails
	// regulados externos (commodity infrastructure). Sem BKR como BC
	// separado, FCE absorveria custo de complexidade de cada
	// rail/provider — esse custo evitado é benefício arquitetural
	// (clean boundary FCE↔BKR↔external), não cost-elimination
	// strategic claim que mereça ce-NN ref formal.
	//
	// Articulação completa em outer rationale Phase 1.6.

	// =============================================
	// INCENTIVE ANALYSIS — Phase 1.5 WI-062
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:  "sh-01"
			participantType: "Upstream economic intent issuer (originadora autorizando PaymentInstruction via FCE)"
			desiredBehavior: """
				Emitir PaymentInstruction com authorization proof válida
				(cryptographic signature canonical + nonce + issued-at +
				validity window upstream-declared + claim chain). Usar
				RequestSettlementCancellation apenas para attempts ainda
				em estado dispatched-awaiting-confirmation, ciente que
				é NON-GUARANTEED (rail determina finality).
				"""
			correctOperationIncentive: """
				Settlement determinístico = ciclo de caixa previsível +
				SCF antecipação habilitada por settlements limpos + audit
				trail confiável para auditorias internas/externas + boa
				reputação na rede Mesh (sh-01 não quer settlement
				ambíguo nem reversal traumático em sua relação com
				fornecedores).
				"""
			manipulationVector: """
				Forged authorization proof OR premature cancellation
				request during non-final settlement window.
				"""
			manipulationCost: """
				Cryptographic gates rejeitam proof inválida (signature
				não verifica contra key registrada, TTL expirada, claim
				chain quebrada). Forgery em escala requer comprometimento
				de FCE-publisher key (custo material — cross-BC trust
				anchor protegido por agent governance envelope Phase 5).
				Premature cancel não causa damage real (rail decide
				finality; cancel request honored apenas se rail aceita
				cancel pré-finality).
				"""
			vsBenefit: """
				Custo de forgery (key compromise + detection via signature
				verification failure + audit trail forensics) >> benefício
				potencial (single fraudulent settlement detectable via
				downstream FCE/audit reconciliation). Premature cancel
				não rende benefício porque cancel não muda finalidade
				se rail já clearou.
				"""
			designResponse: """
				bd-settlement-authorization-upstream + Phase 5 agent-
				governance cross-BC trust anchor + 4-way ID separation
				(instructionId vs attemptId vs railReferenceId vs
				idempotencyKey) + cancellation NON-GUARANTEED semantics
				per Phase 1.4 communication + escalation
				ec-authorization-proof-verification-failure.
				"""
			rationale: """
				sh-01 é raiz econômica do macrofluxo Mesh. Suas
				PaymentInstructions originam settlements BKR. Vetores
				focam authorization integrity (proof gates) e
				cancellation window discipline (não confundir
				cancel-request pré-finality com reverse settlement
				pós-finality que vive em DRC/FCE).
				"""
		}, {
			stakeholderRef:  "sh-02"
			participantType: "Downstream settlement consumer (beneficiário aguardando crédito real via rail)"
			desiredBehavior: """
				Aguardar SettlementCompleted canonical event (post-
				reconciliation) antes de atuar sobre crédito esperado.
				Não inferir completion a partir de absence-of-failure
				ou estado intermediário observável.
				"""
			correctOperationIncentive: """
				Settlement confirmação canonical = decisão operacional
				confiável (atualização de status interno, kickoff de
				próxima etapa, baixa de obrigação contra sh-01).
				Acting on canonical events evita follow-ups manuais
				custosos quando settlement reverte ou era indeterminate.
				"""
			manipulationVector: """
				Acting on inferred settlement completion before canonical
				event — assumir Pix instant pelo dispatch sem aguardar
				pacs.002 reconciliation, OR observar absence de
				SettlementFailed e concluir success.
				"""
			manipulationCost: """
				Custo operacional concreto: sh-02 ageu sobre crédito
				inferido (e.g., libera mercadoria, dispara próxima
				etapa); BKR depois emite SettlementFailed OR
				SettlementIndeterminate; sh-02 carrega custo de reverter
				ação operacional + perda de confiança no parceiro.
				Rail-level (Pix) ambiguidade pré-pacs.002 é janela
				curta mas existe.
				"""
			vsBenefit: """
				Velocidade de ação inferida (minutos) vs custo de reversão
				operacional + reputational damage + descalce contábil.
				Custo >> benefício para qualquer fornecedor com folga
				operacional mínima.
				"""
			designResponse: """
				SettlementCompleted/Failed/Indeterminate emitidos APENAS
				post-reconciliation (capability 3); estado intermediário
				dispatched-awaiting-confirmation não emitido externamente;
				QuerySettlementStatus query-surface expõe estado canonical
				para consultas explícitas — sh-02 pode polling consulta
				se precisar de visibilidade, mas resposta é estado
				canonical, nunca speculative.
				"""
			rationale: """
				sh-02 é último ponto da cadeia onde o dinheiro chega.
				Vetor é optimism premature — agir antes do canonical.
				Side-channel detail (classification regulatory/economic)
				NÃO é entregue a sh-02 (Phase 1.4 side-channel mitigation);
				vector de side-channel inferral foi movido para sh-06.
				"""
		}, {
			stakeholderRef:  "sh-04"
			participantType: "Regulatory boundary constraint authority (Bacen — NÃO adversarial)"
			desiredBehavior: """
				Publicar spec changes (Pix v2, novos arranjos, limites
				prudenciais, Drex CBDC emergent 2026) com janela de
				adoção suficiente para sistemas integrados absorverem
				sem breaking. BKR responde via capability schema update
				+ Phase-driven evolution.
				"""
			correctOperationIncentive: """
				Bacen ganha quando sistemas integrados absorvem spec
				changes determinísticamente — reduz incidents, melhora
				estabilidade SPB/SPI agregada. Misaligned integrators
				geram dispatches inválidos que poluem audit + reporting.
				"""
			manipulationVector: """
				Regulatory boundary drift — spec/regulatory change not
				absorbed by BKR (vetor é absence-of-adaptation por parte
				do BKR, não malicious action por Bacen).
				"""
			manipulationCost: """
				Custo de drift recai sobre BKR + instituição autorizada
				parceira (PSTI/banco): dispatches rejeitados por rail
				com regulatory-block, reporting inconsistente, possível
				suspensão de arranjo de pagamento. Bacen não absorve
				custo material — está do lado da spec.
				"""
			vsBenefit: """
				BKR não tem benefício em desalinhamento — apenas custo.
				Adoption discipline é dominant strategy.
				"""
			designResponse: """
				Capability schema designed para extensão (cap 2 protocol
				translation absorve novos formatos; cap 5 retry policy
				absorve novos operational windows). RailProviderStatusUpdated
				event-consumer (Phase 1.4) e QueryRailWindowStatus
				query-deps surfacem spec-aware status. Phase-driven
				evolution: novos rails (e.g., Drex) entram via canvas
				revision + new external system ref + new command-invocation.
				Escalation ec-regulatory-boundary-misalignment detecta
				drift via rail behavior diverging from BKR expectations.
				"""
			rationale: """
				sh-04 é boundary constraint authority, não adversarial.
				ManipulationVector aqui é structural-absence (BKR não
				absorvendo spec change) não malicious-action. Modelado
				para preservar simetria do schema #IncentiveParticipant
				sem implicar adversarial role do regulador.
				"""
		}, {
			stakeholderRef:  "sh-05"
			participantType: "Primary operator agent BKR (sh-05 Agente IA Mesh executando dispatch, reconciliation, retry, classification)"
			desiredBehavior: """
				Operar dentro de autonomousDecisions sob policy
				determinística; escalar via supervisedDecisions /
				escalationCriteria quando boundary anti-decision é
				tocada; preservar disciplina técnica vs econômica em
				toda decisão.
				"""
			correctOperationIncentive: """
				Agent calibração: drift detection in subagent-execution-log;
				governance envelope Phase 5 com bounded autonomy +
				transparent escalation paths; audit trail (cc-04) torna
				agent decisions reviewable post-hoc — agent ganha
				estabilidade operacional sob disciplina.
				"""
			manipulationVector: """
				Autonomous decision drift — rail selection optimizing
				for agent-internal metric (latency self-preservation,
				retry self-extension além de operational hours),
				classification side-channel leak por descuido
				(detail vazado a downstream consumers fora da policy
				side-channel-aware), OR aceitar provider result após
				suspected tampering sem escalation.
				"""
			manipulationCost: """
				Drift detectado via: structural-checks pós-commit;
				governanceScope boundaries explícitas em CUE; escalation
				criteria executable; audit trail imutável. Custo
				operacional de drift (incidents, reversal, regulatory
				exposure) é caro e visível.
				"""
			vsBenefit: """
				Agent não tem benefício pessoal em drift — está sob
				governance envelope. Drift = governance violation =
				reputational + operational cost. Dominant strategy é
				disciplina.
				"""
			designResponse: """
				governanceScope com 5 autonomousDecisions (boundaries
				técnicas estritas) + 6 supervisedDecisions (anti-decision
				boundaries) + 9 escalationCriteria (incluindo
				ec-classification-side-channel-leak-detected meta-escalation
				sobre próprio agent vazar info sensível). Agent governance
				envelope Phase 5 codifica boundaries em CUE executable;
				subagent-execution-log Phase 5 captura agent decisions
				para calibration.
				"""
			rationale: """
				sh-05 é actor primário de BKR. Vetor de drift é o mais
				operacionalmente relevante porque agent toma N decisões
				por minuto sob policy. Governance disciplina codificada
				em CUE > confiança comportamental.
				"""
		}, {
			stakeholderRef:  "sh-06"
			participantType: "External adversarial actor (vetor adversarial canonical cross-BC per stakeholder-map)"
			desiredBehavior: """
				N/A — sh-06 é vetor adversarial por definição; design
				do sistema é para tornar ataques impraticáveis, não
				motivar 'correct operation'.
				"""
			correctOperationIncentive: """
				N/A — sh-06 não tem incentivo a operar corretamente.
				Sistema design assumes worst-case adversarial behavior
				para mecanismos relevantes.
				"""
			manipulationVector: """
				Settlement-boundary exploitation — explora a transição
				determinística entre intent autorizado e finality
				externamente determinada para induzir comportamento
				incorreto do sistema.
				"""
			manipulationCost: """
				4-way ID separation + cryptographic authorization proof
				+ idempotency-by-attemptId + ownership-causal classification
				+ side-channel mitigation + reconciliation determinística
				+ structural validations via DICT/account availability
				eliminam classes inteiras de attacks (replay, forgery,
				duplicate-settlement, classification inferral, status
				manipulation). Custo de exploit residual sobe rapidamente
				com defense-in-depth.
				"""
			vsBenefit: """
				Para exploits residuais (e.g., timing arbitrage sob
				rail selection delegada): benefício marginal limitado;
				custo de detection (audit trail completo, classification
				ownership rastreável) alto.
				"""
			designResponse: """
				Vetor agregador inclui (detail nesta rationale): (a)
				duplicate settlement via replay — bloqueado por
				idempotencyKey per attempt; (b) PSTI/provider tampering
				— detectável via signature mismatch + payload mutation
				detection + ec-provider-tampering-suspected escalation;
				(c) rail status manipulation forjando RailProviderStatusUpdated
				— mitigado por dual-source verification (event-consumer
				push + query-deps pull) + Phase 1.6 open question
				sobre tampering detection robusta; (d) cross-rail timing
				arbitrage — neutralizado por bd-rail-selection-is-technical-only
				(timing como decisão econômica FCE, não BKR); (e)
				settlement indeterminate exploited as completed —
				preservado pela disciplina de NÃO emitir outcome canonical
				sob estado não-final (capability 3 + SettlementIndeterminate
				event separado).
				"""
			rationale: """
				sh-06 representa worst-case adversarial threat model
				cross-BC (per domain/stakeholder-map.cue). Vetor agregador
				captura settlement-boundary exploitation como categoria;
				design responses específicos enumerados em rationale
				preservam granularidade analítica sem fragmentar em
				múltiplos participants. sh-06 não está em Phase 1.3
				stakeholders[] porque não é affected actor; é adversarial
				vector reservado para incentive analysis.
				"""
		}]

		rationale: """
			5 participants (sh-01, sh-02, sh-04, sh-05, sh-06) cobrem
			os 8 vetores adversariais identificados: (1) duplicate
			settlement / replay → sh-06; (2) forged authorization proof
			→ sh-01; (3) rail/provider status manipulation → sh-06; (4)
			PSTI/provider tampering → sh-06; (5) settlement indeterminate
			exploited as completed → sh-02 (premature acting) + sh-06
			(adversarial); (6) cross-rail timing arbitrage → sh-06; (7)
			failure-classification side-channel leakage → sh-05 (operator
			drift) + sh-06 (adversarial inferral); (8) cancellation/reversal
			confusion → sh-01 (premature cancel during non-final window).

			Design pattern across participants: cryptographic gates +
			4-way ID separation + ownership-causal classification +
			side-channel mitigation + indeterminate preservation +
			anti-decision boundary anchoring. Cada vetor mapeia a
			designResponse específica que materializa em capabilities,
			businessDecisions, communication patterns e governanceScope
			boundaries.

			sh-04 (Bacen) preservado como boundary constraint authority
			não adversarial — manipulationVector modelado como structural-
			absence (BKR não absorvendo spec change), não malicious-action.
			sh-06 (adversário econômico) usa vetor agregador
			(settlement-boundary exploitation) com detail enumerado em
			rationale para honrar schema single-field constraint sem
			perder granularidade analítica.
			"""
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 1.5
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/bkr/agents/bkr-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "ad-rail-selection-under-upstream-constraints"
				description: "Selecionar entre Pix (SPI), TED (STR/SITRAF), boleto (SILOC/CIP) ou SWIFT/correspondent banking conforme upstream-declared constraints (limites/tier/timing window em PaymentInstruction) + operational windows do rail + rail availability observada. Selection é função determinística sobre parâmetros técnicos."
				rationale:   "Per bd-rail-selection-is-technical-only. Autonomia restrita a parâmetros técnicos — sem decisão econômica (custo/timing/destinatário). FCE delega seleção apenas quando instrução não a especifica; mesmo quando delegada, é technical routing."
			}, {
				id:          "ad-protocol-translation"
				description: "Traduzir PaymentInstruction interna Mesh para formato externo do rail target — ISO 20022 pacs.008/002/004 (SPI/STR), CNAB SILOC, SWIFT MX/MT — sem reinterpretar semântica financeira. Campo a campo per spec do protocolo."
				rationale:   "Per capability 2 protocol translation. Função pura sobre instrução autorizada — output é representação isomórfica em protocolo externo, não reinterpretação econômica."
			}, {
				id:          "ad-idempotency-duplicate-handling"
				description: "Detectar idempotencyKey duplicado e retornar resultado anterior (no-op idempotente) sem nova execução de dispatch nem nova consulta a rail. Enforcement POR idempotencyKey (per execution attempt), NÃO por instructionId (per business correlation) — recurring legítimo sob mesmo instructionId + novo attemptId permitido."
				rationale:   "Per capability 4 + 4-way ID separation. Idempotency é capability central que precede retry — retry sem idempotency vira vector de double-settlement (cap 5 prerequisite)."
			}, {
				id:          "ad-deterministic-retry-while-non-final"
				description: "Aplicar política de retry e timeout determinística para falhas técnicas transitórias enquanto attempt em estado dispatched-awaiting-confirmation OU indeterminate. Retry pode ser re-query/reconciliation OU nova tentativa de dispatch conforme policy classification. When policy permits a new technical attempt, generate a new attemptId and idempotencyKey under the same instructionId. Bloqueado post-confirmation (reconciled-completed | reconciled-failed terminais)."
				rationale:   "Per capability 5. Retry como lineage técnica explícita — nem todo retry gera novo dispatch; reconciliation/status re-query é também retry path. Anti-double-settlement por construção: novo attemptId quando policy autoriza, idempotencyKey separation, terminal state lockout."
			}, {
				id:          "ad-failure-classification-structural-technical-pass-through"
				description: "Classificar falhas em 3 ownership tiers: (A) Structural — BKR-authoritative sobre schema → reject at BKR boundary; (B) Technical — BKR-authoritative sobre rail/provider observation → retry policy interna (ad-deterministic-retry-while-non-final); (C) Regulatory+Economic — BKR NÃO authoritative → pass-through escalation para FCE (supervisedDecisions). Side-channel mitigation aplicada por construção (categoria genérica downstream; detail apenas para FCE upstream)."
				rationale:   "Per capability 6 + ownership causal. Autonomia restrita a tiers A+B onde BKR tem authority epistemic; tier C é pass-through obrigatório sem julgamento."
			}]
			supervisedDecisions: [{
				id:          "sd-override-indeterminate-settlement"
				description: "Forçar transição de attempt indeterminate para reconciled-completed ou reconciled-failed sem proof rail determinístico. Operação que colapsa epistemic distinction entre indeterminate (não sabemos outcome) e Failed/Completed (sabemos)."
				rationale:   "Indeterminate is operationally non-final — override exige human judgment porque destrói distinção epistêmica preservada por design (Phase 1.4 SettlementIndeterminate evento separado). Auto-override invalidaria replay safety + reconciliation semantics + audit trail confiável."
			}, {
				id:          "sd-force-completion-failure-without-deterministic-rail-proof"
				description: "Emitir SettlementCompleted ou SettlementFailed canonical sem confirmação rail explícita (e.g., manual após audit forensics, judicial order, batch gap recovery). Operação substitui mecanismo determinístico por decisão human-authoritative."
				rationale:   "BKR perde determinismo se autoriza outcome canonical sem proof rail; quebra audit trail cc-04. Decisão exige human judgment + justificativa registrada."
			}, {
				id:          "sd-cross-rail-failover-not-pre-authorized"
				description: "Trocar rail (e.g., Pix→TED) durante execução de uma instrução sem pre-authorized fallbackRails declarado em PaymentInstruction. Failover muda settlement semantics (timing, finality, fee structure)."
				rationale:   "Per bd-rail-failure-is-not-payment-decision. Cross-rail failover é payment decision implícita — exige authorization explícita upstream OU manual escalation para FCE decidir reissuance."
			}, {
				id:          "sd-reverse-settlement-refund-estorno"
				description: "Executar reverse settlement post-finality (pacs.004 refund, chargeback analog, judicial reversal). Nova obrigação econômica, não cancellation."
				rationale:   "Reverse settlement envolve nova obrigação econômica + DRC/FCE orchestration + possível dispute workflow. Out of Phase 0 BKR scope; modeled em Phase 1.6 open question. Tentativas autonomous violariam anti-decision boundary."
			}, {
				id:          "sd-manual-provider-reconciliation"
				description: "Reconciliar manualmente com provider quando event-driven reconciliation falha (provider lost data, batch gap, communication failure persistente). Substitui mecanismo determinístico por procedure operacional human-driven."
				rationale:   "Manual reconciliation é decisão sobre validade de procedure não-determinística — exige human judgment para reconciliar BKR state com provider ground truth. Auto-acceptance abriria vector de drift silencioso."
			}, {
				id:          "sd-accept-provider-result-after-suspected-tampering"
				description: "Aceitar resultado provider quando há sinal de tampering (PSTI signature mismatch, payload mutation inesperada, rail-level discriminator inconsistente, escalation ec-provider-tampering-suspected disparada)."
				rationale:   "Aceitar resultado sob suspeita seria amplification de attack vector. Exige human decision após security review + provenance verification."
			}]
			escalationCriteria: [{
				id:        "ec-double-settlement-detected"
				condition: "idempotencyKey hit + provider confirms second dispatch despite no-op response from BKR; OR reconciled-completed event emitted twice for same attemptId; OR rail emits second SettlementCompleted for same instructionId+attemptId across separate dispatch paths."
				action:    "Halt all dispatch for affected instructionId; emit DuplicateSettlementAnomaly event para fce + audit; sh-05 escala human-in-the-loop para diagnóstico (race bug interno OR idempotency failure OR provider behavior OR tampering — análise determina cause)."
				rationale: "Double-settlement é falha em economia real (dinheiro movido duas vezes). Detection via idempotency violation OR audit log duplication. DuplicateSettlementAnomaly como categoria diagnóstica genérica — ProviderTamperingSuspected only triggered se evidência específica."
			}, {
				id:        "ec-authorization-proof-verification-failure"
				condition: "Cryptographic signature inválida OR TTL expirada OR claim chain quebrada OR signature válida mas FCE-publisher key não registrada em agent-governance envelope FCE."
				action:    "Reject dispatch with structural-instruction-invalid classification; emit AuthorizationProofRejected event para fce (upstream authorizer com need-to-know); audit trail registra rejection com categoria de falha proof; sh-05 não retry — failure terminal."
				rationale: "Per bd-settlement-authorization-upstream. Authorization proof failure é structural rejection (BKR autoritativo sobre schema do proof) — não tentar dispatch. Detection é primeira linha de defesa contra forged authorization vector."
			}, {
				id:        "ec-rail-finality-irreversibility-conflict"
				condition: "Rail confirma SettlementCompleted mas BKR internal state inconsistent (e.g., cancellation acknowledged + completion confirmed for same attemptId; OR reconciled-failed previamente registrado para mesma attemptId que agora rail confirma como completed)."
				action:    "Halt subsequent dispatch para affected accounts; emit RailFinalityConflict event para fce + audit; trigger sd-manual-provider-reconciliation; security + audit review com forensics completo."
				rationale: "Rail finality é authoritative (fora do BKR control); BKR state local conflitando com rail authoritative state é sinal de race/bug/tampering. Conservar safety > continuar dispatch."
			}, {
				id:        "ec-cross-rail-failover-attempted-without-pre-authorization"
				condition: "sh-05 agent attempts dispatch on rail Y após rail X failure, sem fallbackRails pre-authorized declared em PaymentInstruction."
				action:    "Block failover dispatch (ad-rail-selection-under-upstream-constraints constraint enforcement); emit CrossRailFailoverBlocked event para fce + sh-05 audit; FCE decide reissuance via nova PaymentInstruction."
				rationale: "Per bd-rail-failure-is-not-payment-decision. Detection prevents agent drift de transformar rail failure em payment decision implícita."
			}, {
				id:        "ec-indeterminate-state-exceeds-operational-window"
				condition: "Attempt em estado indeterminate por tempo > operational window do rail target (e.g., Pix > N minutes sem pacs.002; TED > end-of-business-day STR sem confirmação; boleto > D+2 sem retorno SILOC; SWIFT > N hours sem confirmação multi-hop)."
				action:    "Emit SettlementIndeterminate canonical event para fce (Phase 1.4 outbound); classification update; aguardar fce decision sobre manual reconciliation, external check (ex: STR balance pull) ou aguardar próxima janela rail."
				rationale: "Indeterminate além do operational window não pode permanecer estado interno indefinido. Escalation operacional preserva separação BCs — fce decide próximo passo econômico; BKR apenas reporta epistemic state."
			}, {
				id:        "ec-classification-side-channel-leak-detected"
				condition: "DispatchClassification event ou QueryDispatchClassification response carregando compliance-sensitive detail (regulatory-block category, sanctions list inference, AML trigger specifics) para consumer NÃO identificado como upstream authorizer (e.g., regulatory-block detail emitido para audit aggregate consumer OR retornado em query para sh-02)."
				action:    "Halt classification event emission para consumer não-FCE; audit emission history para affected events; review side-channel policy enforcement; trigger security review sobre como leak ocorreu (agent drift OR policy misconfig OR routing bug)."
				rationale: "Meta-escalation sobre próprio BKR vazar info sensível. Side-channel mitigation Phase 1.2 cap 6 + Phase 1.4 communication depende de detection mechanism funcionar. Compliance info leak é vector de risk amplification (informa attacker sobre sanctions/AML target state)."
			}, {
				id:        "ec-provider-tampering-suspected"
				condition: "PSTI/partner retorna unexpected payload mutation OR signature mismatch sobre response OR rail-level discriminator inconsistente com submitted instruction OR repeated divergence entre expected rail behavior e observed responses."
				action:    "Halt dispatch via affected provider (ad-rail-selection-under-upstream-constraints exclui provider sob suspeita); failover apenas para backup integration se pre-authorized; trigger sd-accept-provider-result-after-suspected-tampering escalation a fce + sh-05 human + security review."
				rationale: "PSTI/partner é single point para SCD acessar rails; compromise vector tem high impact. Detection antes de auto-acceptance previne attack amplification."
			}, {
				id:        "ec-regulatory-classification-routing"
				condition: "Rail submission rejected with regulatory-block category (e.g., destinatário em sanctions list externa, AML trigger upstream, limite operacional regulatório excedido) per Phase 1.2 cap 6 tier C ownership."
				action:    "Escalate to fce com sanitized classification (regulatory-block categoria genérica, sem revelar específico sanctions hit ou AML trigger — per side-channel mitigation); downstream consumers (audit, sh-02) recebem outcome SettlementFailed com categoria genérica sem detail."
				rationale: "Regulatory-block é resposta normal do rail dado compliance externa upstream — não BKR regulatory breach, mas pass-through enforcement. Routing escala upstream para fce (que detém authorization e pode reissuance com correção upstream). Distinto de ec-regulatory-boundary-misalignment (que é BKR drift)."
			}, {
				id:        "ec-regulatory-boundary-misalignment"
				condition: "Bacen-published spec change (Pix v2, novos arranjos, limites prudenciais, Drex CBDC) NÃO absorvida em BKR capabilities — detectado via rail behavior diverging persistently from BKR expectations (multiple dispatches rejected with unexpected categories OR responses with unrecognized fields/formats) indicando spec drift."
				action:    "Halt rail-specific dispatch para rail afetado; emit RegulatoryBoundaryMisalignment event para fce/ato + sh-05 + ops audit; trigger capability schema update review + spec absorption work item."
				rationale: "Boundary misalignment é structural drift do BKR relative ao Bacen spec — requires capability evolution. Distinto de ec-regulatory-classification-routing (instância regulatory-block é roteada upstream; misalignment é falha sistêmica de BKR adaptar)."
			}]
		}
		rationale: """
			BKR autonomy is technical only. Economic finality, reversal,
			beneficiary mutation and payment authorization are always
			upstream/supervised. Esta regra constitutiva materializa-se
			em:
			  - 5 autonomousDecisions cobrindo technical execution
			    boundaries (rail selection sob constraints, protocol
			    translation, idempotency, retry while non-final,
			    classification structural-technical pass-through).
			  - 6 supervisedDecisions formalizando anti-decision
			    boundaries (indeterminate override, force outcome
			    sem proof, cross-rail failover sem authorization,
			    reverse settlement, manual reconciliation, accept
			    after tampering).
			  - 9 escalationCriteria cobrindo executable triggers
			    para drift detection (double-settlement,
			    authorization failure, finality conflict, failover
			    sem auth, indeterminate timeout, side-channel leak,
			    provider tampering, regulatory classification routing,
			    regulatory boundary misalignment).

			Cada criterion mapeia condição observável + action
			determinística + rationale ancorando ownership causal.
			Agent governance envelope Phase 5 materializará boundaries
			executable em CUE com cross-BC trust anchor para FCE
			authorization proof verification.

			domainAgentSpec forward-reference (contexts/bkr/agents/
			bkr-primary-agent.cue) será autorado em Phase 4 do bootstrap
			WI-062.
			"""
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 1.6
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + businessDecisions + anti-decision economic authority + commodity Wardley justification + cross-BC integration cascade FCE→BKR→external + lenses ativadas) entra em commit 1.6."
}
