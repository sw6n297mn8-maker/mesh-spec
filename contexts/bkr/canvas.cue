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
	// STAKEHOLDERS — placeholder; conteúdo em commit 1.3
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Placeholder — completado em commit 1.3."
		impactDescription: "Placeholder — completado em commit 1.3."
		rationale:         "Skeleton stakeholder; stakeholders substantivos (provavelmente: sh-01 originadora consumindo settlement outcome para fluxo; sh-02 fornecedor recebendo crédito final; sh-04 instituição financeira parceira como provider de rails; sh-05 operador agente BKR) em commit 1.3."
	}]

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
