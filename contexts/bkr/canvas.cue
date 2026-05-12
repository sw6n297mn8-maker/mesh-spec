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
		Executar liquidação física via rails bancários (Pix, TED,
		boleto e, quando aplicável, SWIFT/correspondent banking) sob
		autorização upstream. BKR é boundary entre a Mesh (lógica
		financeira proprietária) e o sistema financeiro regulado pelo
		Bacen e integrado ao SPB/PIX por meio de instituições
		autorizadas (rails comoditizados, protocolos uniformes). Não
		decide mérito econômico de pagamento — decisão de quando e
		por que pagar permanece upstream em FCE (liquidação), TCM
		(tesouraria) ou policy. BKR pode tomar decisões técnicas de
		roteamento e rail selection (qual protocolo usar; retry
		strategy; timeout handling), mas nunca decisão econômica
		(autorizar pagamento, definir valor, alterar destinatário).

		Anti-core differentiator: high criticality operacional
		(movimenta dinheiro real, regulado pelo Bacen e integrado ao
		SPB/PIX por meio de instituições autorizadas) com low
		strategic uniqueness (rails substituíveis por qualquer
		provedor que implemente os mesmos protocolos). BKR existe
		como BC separado para absorver heterogeneidade de protocolos
		bancários atrás de interface uniforme — sem isto, FCE
		absorveria complexidade de cada rail e acoplaria lógica
		financeira proprietária a integrações commodity.
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
				externos de rails (ISO 20022 MX, COMPE 22-9, SWIFT MT,
				formatos próprios de providers). Tradução é estrutural
				— campo a campo per spec do protocolo — sem reinterpretar
				semântica financeira nem omitir/criar informação
				econômica.
				"""
			rationale: """
				Boundary técnico. Protocolos externos evoluem (Pix v2,
				SWIFT MT→MX migration, ISO 20022 fases) sem precisar
				alterar contratos internos Mesh. cc-03 (operação 24/7)
				habilitada por absorver volatilidade de formato dentro
				do BKR: FCE permanece estável enquanto rails mudam.
				Tradução é função pura sobre instrução autorizada —
				output é representação isomórfica em protocolo externo,
				não reinterpretação.
				"""
		}, {
			capabilityRef: "cc-04"
			description: """
				Consumir confirmação ou falha emitida pelo rail
				(synchronous response ou async callback), reconciliar
				com PaymentInstruction original via identifiers
				correlacionáveis (correlationId, endToEndId), e emitir
				SettlementCompleted / SettlementFailed / SettlementPending
				como evento canônico Mesh consumido por FCE/TCM/ATO.
				"""
			rationale: """
				Rails têm semânticas heterogêneas de confirmação (Pix
				instantâneo síncrono, TED D+0 com janelas, boleto
				D+1/D+2 async, SWIFT multi-hop). BKR uniformiza outcome
				em vocabulário Mesh sem alterar estado real nem
				reinterpretar economicamente o resultado. cc-04
				(auditoria contínua) habilitada por mech-three-sots:
				reconciliação determinística produz events que feed
				audit trail imutável; cada settlement é rastreável da
				instrução à confirmação rail por correlation IDs
				estáveis.
				"""
		}, {
			capabilityRef: "cc-04"
			description: """
				Garantir que despacho repetido da mesma PaymentInstruction
				(mesmo correlationId/endToEndId) NÃO produz settlement
				duplicado. Detecção por idempotency key estável;
				comportamento em duplicate-detected: retornar resultado
				anterior ou rejeitar conforme estado do settlement
				anterior (no-op idempotente).
				"""
			rationale: """
				Pix/TED/SWIFT têm semânticas distintas de retry —
				alguns aceitam idempotency nativamente (Pix endToEndId),
				outros não. BKR provê garantia uniforme upstream para
				FCE: instrução não é executada duas vezes mesmo sob
				falha de rede, retry de FCE ou re-delivery de evento.
				Sem isto, FCE absorveria duplicate-prevention per rail.
				cc-04 (auditoria contínua) requer correção por construção:
				event log sem duplicação é precondição para audit trail
				confiável. Idempotency é capability central que precede
				retry — retry sem idempotency vira vector de
				double-settlement.
				"""
		}, {
			capabilityRef: "cc-03"
			description: """
				Aplicar política de retry e timeout determinística para
				falhas técnicas transitórias (rail timeout, transient
				provider error, network partition). Política codificada
				(max retries, backoff schedule, escalation timeout) por
				classe de falha técnica; não envolve julgamento contextual
				nem altera instrução econômica. Retry permitido apenas
				enquanto settlement final NÃO foi confirmado; após
				confirmação ou estado ambíguo (indeterminate provider
				state), retry é proibido e o caso transita para
				reconciliation (capability 3) ou escalation (capability 6),
				nunca para nova tentativa de dispatch.
				"""
			rationale: """
				Falhas técnicas transitórias são commonplace em
				integrações externas (rails de terceiros). Política
				determinística habilita replay, audit e supersession
				(P10 — agentes estocásticos recomendam; gates
				determinísticos validam). cc-03 (operação 24/7) requer
				resiliência sem intervenção humana rotineira. Bloqueio
				post-confirmação é não-negociável: retry após confirmação
				é vector direto de double-settlement, que é falha em
				economia real (dinheiro movido duas vezes). Idempotency
				(capability 4) é precondição estrutural; retry guard é
				precondição comportamental.
				"""
		}, {
			capabilityRef: "cc-03"
			description: """
				Classificar falhas em categorias canônicas e roteá-las
				para handoff apropriado:
				  - 'technical-transient' / 'provider-unavailable':
				    retry interno determinístico via capability 5.
				  - 'structural-instruction-invalid' (campos malformados,
				    schema violation, missing required fields, type
				    mismatch): reject at BKR boundary com rejection
				    event indicando structural error específico —
				    BKR conhece schema da instrução e pode validar
				    deterministicamente.
				  - 'rail-rejected' / 'regulatory-block' /
				    'economic-instruction-invalid' (limite excedido,
				    destinatário bloqueado por compliance externa,
				    valor inconsistente com policy): escalation a FCE
				    (originador da instrução) sem tentativa de
				    remediação automática.
				"""
			rationale: """
				cc-03 (operação 24/7) requer routing determinístico de
				falhas — humanos intervêm por exceção, não por rotina.
				Handoff respeita boundary anti-decision: structural
				rejection é técnico (BKR validador local sobre schema
				declarado); economic/regulatory rejection requer
				reinterpretação de mérito (alterar valor, destinatário
				ou condições) — fora do escopo BKR por construção.
				Escalation devolve a FCE quem autorizou originalmente
				e pode decidir reissuance, cancellation ou ajuste de
				instrução. Distinção structural vs economic invalidity
				é boundary explícita: BKR rejeita structural sem
				escalar (custo de escalation > custo de rejection); BKR
				escala economic sem rejeitar (rejeitar economic exigiria
				julgamento que BKR não tem).
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
			Pix, TED, boleto ou SWIFT/correspondent banking baseada em
			technical availability, protocol compatibility, operational
			latency, and upstream-declared constraints (limites/tier
			declarados em PaymentInstruction). Custo/fee só entra como
			constraint declarada upstream, não otimização local de BKR.
			Selection nunca altera prioridade econômica ou destinatário.
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
			without upstream authorization proof: cada PaymentInstruction
			deve carregar evidência verificável de autoridade
			(authorization signature, attested commandId, claim chain
			de FCE→BKR rastreável). correlationId sozinho não é proof
			de autoridade.
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
			Regulador do sistema financeiro pelo qual BKR opera (SPB/PIX
			integration via instituições autorizadas). Define operational
			limits, settlement rules, payment arrangement requirements,
			and provider obligations sobre rails que BKR utiliza.
			"""
		impactDescription: """
			Regulação Bacen define o universo de rails utilizáveis e
			limites operacionais aplicáveis (e.g., limites Pix, horários
			TED, requisitos de instituições autorizadas em arranjos de
			pagamento). Mudanças regulatórias (novo Pix versão, limites
			prudenciais, novos arranjos) impactam capabilities BKR
			(precisam reflexar nova spec do rail) mas não autoridade
			econômica BKR (que permanece em FCE/SCF upstream).
			"""
		rationale: """
			sh-04 é boundary constraint sobre operações BKR. Diferente
			de atuar como compliance-enforcer ativo dentro do BKR
			(papel de IDC/NPM/FCE para KYC/AML/Bacen reporting), Bacen
			impacta BKR via spec dos rails e requisitos operacionais
			sobre provedores. BKR opera no espaço definido pelo Bacen,
			mas não enforça policy regulatória — apenas executa dentro
			das regras de protocolo já incorporadas nos rails.
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
