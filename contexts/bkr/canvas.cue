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
	// COMMUNICATION — placeholder; conteúdo em commit 1.4
	// =============================================

	communication: {
		rationale: "Placeholder — communication completa entra em commit 1.4. Esperado: inbound (PaymentInstruction de FCE — sync command); sinais operacionais de disponibilidade/estado de liquidação vindos de TCM ou providers, sem autoridade econômica de timing; outbound (SettlementCompleted/SettlementFailed/SettlementPending events consumidos por FCE/TCM/ATO); query-deps (AccountStatus externo via providers; estado operacional de TCM); commands (DispatchPayment sync); query-surfaces (QuerySettlementStatus). Ordering aprovado seguirá padrão DLV: businessDecisions (1.3) ANTES de communication (1.4)."
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
	// INCENTIVE ANALYSIS — placeholder; conteúdo em commit 1.5
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Placeholder — preenchido em commit 1.5."
			desiredBehavior:           "Placeholder."
			correctOperationIncentive: "Placeholder."
			manipulationVector:        "Placeholder."
			manipulationCost:          "Placeholder."
			vsBenefit:                 "Placeholder."
			designResponse:            "Placeholder."
			rationale:                 "Skeleton; vetores adversariais substantivos (esperados: rail provider downtime/SLA breach; replay de settlement; misrouting between rails; provider opacity para verificação de confirmação) em commit 1.5."
		}]
		rationale: "Placeholder — incentive analysis completo entra em commit 1.5. BKR commodity reduz vetores estratégicos (provider substituível) mas eleva vetores operacionais (rail SLA, double-settlement, misrouting)."
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 1.5
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/bkr/agents/bkr-primary-agent.cue"
		governanceScope: {}
		rationale:       "Skeleton commit 1.1 estabelece domainAgentSpec canônico (forward reference — agent-spec será autorado em Phase 4 do bootstrap WI-062). governanceScope completo (esperado: autonomousDecisions cobrindo rail selection + retry strategy + timeout escalation; supervisedDecisions cobrindo manual reconciliation + provider override; escalationCriteria cobrindo Bacen regulatory breach + cross-rail orphan + economic value mismatch detected post-dispatch) entra em commit 1.5."
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 1.6
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + businessDecisions + anti-decision economic authority + commodity Wardley justification + cross-BC integration cascade FCE→BKR→external + lenses ativadas) entra em commit 1.6."
}
