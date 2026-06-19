package fce

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// fce-primary-agent.cue — Agent Spec do BC Financial Commitment Execution.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Aplicação manual do production-guide architecture/production-guides/
// agent-spec.cue (manualAuthoringProtocol per adr-057). Cascade ordering
// per adr-054 dec 13: PG existe; canvas.ownership.domainAgentSpec aponta
// para este path. Instanciação per adr-037 (par agent-spec + envelope de
// 2 níveis) — sem ADR novo.
//
// Princípio operacional canônico (per founder review 2026-05-01, espelhado
// de bdg-primary-agent): Spec declara CAPACIDADE; o governance envelope
// declara AUTONOMIA atual via promotion criteria + autonomyOverrides
// intermediários. "autonomousDecision" no canvas significa "não exige
// julgamento humano (gate determinístico)", NÃO "execução sem governança".
// Phase 0: as mutations autônomas (guard/dispatch/settle) são propose-and-
// wait — promoção para execute-and-log é decisão do envelope.governance,
// não do spec (preserva P10: gates determinísticos validam, agentes
// recomendam; habilita rollback automático per failureHandling).
//
// RATIFICAÇÃO adr-155 (estágio 2 / oq-fce-3) — a assimetria que materializa
// a enforcement P10 humano-only do override:
//   - mutations autônomas (gate-pass/dispatch/settle): propose-and-wait
//     PROMOVÍVEL — alvo de promoção declarado no envelope quando a
//     calibração provar o gate (rumo à autonomia 24/7 do canvas, cc-03).
//   - act-resolve-guard-escalation (o override): propose-and-wait
//     PERMANENTE — teto que NUNCA sobe (tq-gv-14 proíbe override→execute-
//     and-log) + atribuição nominal humana obrigatória (cst-override-requires-human-attribution,
//     inv-override-requires-attribution). O agente RECOMENDA, não supre o
//     supervisorId.
// Ambas esperam humano hoje, com destinos OPOSTOS — essa assimetria é a
// fronteira P10/P11 (canvas supervisedDecision override-prepayment-guard).
//
// Boundaries preservadas (per canvas businessDecisions / escalationCriteria):
// - inv-breach-bypasses-escalation: breach (evidência ausente / integridade
//   cripto falha) NUNCA chega ao override — vai a freeze
//   (p11-invariant-breach-detected), não a escalated.
// - O agente não move dinheiro fora do envelope; cada movimento de valor
//   exige proof verificável (P11) e passa pelo gate (P10).

fcePrimaryAgent: artifact_schemas.#AgentSpec & {
	code:              "agt-fce-primary"
	name:              "FCE Primary Agent"
	description:       "Agente operador único do BC Financial Commitment Execution. Executa o PrePaymentGuard determinístico (fatura válida [INV] + elegibilidade satisfeita [REW] + cadeia de evidência íntegra [verify cripto]) sobre o agg-payment, conduz o Payment de guarded a settled sob proof, e PROPÕE a resolução de escaladas do guard sob supervisão humana (override do adr-155). Não move dinheiro fora do envelope; breach de P11 vai a freeze, jamais a override autônomo."
	boundedContextRef: "fce"
	role:              "domain-agent"
	governanceRef:     "fce-primary-agent"

	// =============================================
	// OPERATIONAL SCOPE
	// =============================================

	operationalScope: {
		aggregates: [
			"agg-payment",
		]
		commands: [
			"cmd-materialize-payment",
			"cmd-authorize-payment",
			"cmd-dispatch-payment-instruction",
			"cmd-settle-payment",
			"cmd-resolve-guard-escalation",
		]
		events: [
			"evt-payment-authorized",
			"evt-payment-instruction-dispatched",
			"evt-payment-settled",
			"evt-payment-guard-escalated",
			"evt-payment-guard-overridden",
			"evt-payment-guard-override-refused",
			"evt-payment-obligation-defaulted",
			// inbound triggers consumidos (espelha BDG com evt-commitment-accepted-received):
			"evt-invoice-issued",
			"evt-settlement-finalized",
		]
		invariants: [
			"inv-money-moves-only-on-proof",
			"inv-guard-deterministic",
			"inv-at-most-once-dispatch",
			"inv-no-partial-settlement",
			"inv-settled-fact-canonical",
			"inv-override-requires-attribution",
			"inv-breach-bypasses-escalation",
		]
		// projections OMITIDO — o FCE não declara prj-* (canvas/domain-model);
		// reads miram o agg-payment rehidratado e os eventos consumidos.
	}

	// =============================================
	// ACTIONS (operações executáveis)
	// =============================================

	actions: [{
		code:        "act-materialize-payment"
		name:        "Materialize Payment"
		description: "Materializar o Payment em guarded a partir da tupla (commitmentRef, invoice) ao observar a emissão de fatura (evt-invoice-issued do INV). Aggregate birth determinística: o paymentId deriva da tupla, tornando re-materialização um no-op estrutural (primeira metade de inv-at-most-once-dispatch). Impact: aggregate birth em guarded — NÃO move dinheiro (pré-money); nenhuma das 3 condições do PrePaymentGuard avaliada ainda. AutonomyLevel: execute-and-log — P10-financeiro não vincula (materialize não é command de movimento de valor); birth determinística sem discrição."
		category:        "mutation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-materialize-payment",
			"agg-payment",
			"vo-payment-id",
			"vo-commitment-ref",
			"evt-invoice-issued",
		]
		preconditions: [
			"evt-invoice-issued recebido do INV (fatura emitida para a tupla commitmentRef/invoice)",
			"paymentId derivado da tupla; re-materialização da mesma tupla é no-op idempotente",
		]
		postconditions: [
			"Payment criado em guarded para (commitmentRef, invoice) OR no-op idempotente se já existe",
		]
	}, {
		code:        "act-execute-prepayment-guard"
		name:        "Execute PrePayment Guard"
		description: "Executar o PrePaymentGuard determinístico sobre um Payment em guarded: avaliar as 3 condições (fatura válida [INV] + elegibilidade satisfeita [REW] + cadeia de evidência íntegra [verify cripto]). Outcome-split (tq-dmg-06): (a) clean-pass — as 3 condições satisfeitas ⇒ propõe autorização + emissão de proof; após human gate, guarded→authorized (PaymentAuthorized); (b) non-clean — uma condição stale/incompleta/ambígua-mas-PRESENTE ⇒ guarded→escalated (PaymentGuardEscalated), aguarda act-resolve-guard-escalation; (c) breach — evidência ausente OU integridade cripto FALHA ⇒ NÃO escala: permanece guarded e dispara o escalationCriterion p11-invariant-breach-detected (freeze, inv-breach-bypasses-escalation). Impact: state-change financeiro (decisão de pagar). AutonomyLevel: propose-and-wait Phase 0 — gate determinístico (sim/não, não julgamento), PROMOVÍVEL: governance-promotion candidate via envelope rumo à autonomia 24/7 do canvas (autonomousDecision dispatch-on-guard-pass, cc-03), candidato a MCM/execute-and-log quando a calibração provar o gate (adr-088); preserva P10."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-authorize-payment",
			"agg-payment",
			"evt-payment-authorized",
			"evt-payment-guard-escalated",
			"inv-money-moves-only-on-proof",
			"inv-guard-deterministic",
			"inv-breach-bypasses-escalation",
			"vo-authorization-proof",
			"vo-eligibility-decision",
			"vo-overridden-guard-conditions",
		]
		preconditions: [
			"Payment em guarded",
			"Fato de fatura (evt-invoice-issued, INV) disponível para a tupla",
			"Decisão de elegibilidade (REW, contrato-de-consumo) disponível",
			"Endereço + proof de evidência disponíveis para verify cripto (EvidencePort)",
		]
		postconditions: [
			"Outcome clean-pass: recommendation de autorização + proof; após human gate, guarded→authorized + evt-payment-authorized",
			"Outcome non-clean: guarded→escalated + evt-payment-guard-escalated (aguarda act-resolve-guard-escalation)",
			"Outcome breach: permanece guarded; escalationCriterion p11-invariant-breach-detected disparado (freeze)",
		]
	}, {
		code:        "act-dispatch-payment-instruction"
		name:        "Dispatch Payment Instruction"
		description: "Despachar a PaymentInstruction ao BKR sob a authorization proof, para um Payment em authorized. At-most-once por (commitmentRef, invoice) — segunda metade de inv-at-most-once-dispatch: nenhum dispatch prévio pode existir no stream. Impact: state-change financeiro (move dinheiro ao rail) + cross-bc (BKR). AutonomyLevel: propose-and-wait Phase 0 — PROMOVÍVEL: é a operação autônoma central do canvas (dispatch-on-guard-pass, cc-03 24/7); governance-promotion candidate via envelope rumo a execute-and-log quando o gate estiver provado; preserva P10."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-dispatch-payment-instruction",
			"agg-payment",
			"evt-payment-instruction-dispatched",
			"inv-at-most-once-dispatch",
			"vo-authorization-proof",
		]
		preconditions: [
			"Payment em authorized (com proof válida)",
			"Nenhum PaymentInstructionDispatched prévio para a tupla (at-most-once)",
		]
		postconditions: [
			"Recommendation de dispatch + InstructionId; após human gate, authorized→dispatched + evt-payment-instruction-dispatched ao BKR sob proof",
		]
	}, {
		code:        "act-settle-payment"
		name:        "Settle Payment"
		description: "Liquidar o Payment em dispatched ao reconciliar o SettlementFinalized do BKR (evt-settlement-finalized): dispatched→settled, emitindo o fato canônico PaymentSettled exatamente uma vez (inv-settled-fact-canonical). Liquidação integral — nunca parcial (inv-no-partial-settlement): exige PaymentAuthorized E PaymentInstructionDispatched prévios no stream. Impact: state-change financeiro (fato canônico de dinheiro-moveu; consumers REW/SCF/ATO/TCM) + cross-bc (BKR consumido). AutonomyLevel: propose-and-wait Phase 0 — PROMOVÍVEL: reconciliação determinística (não julgamento); governance-promotion candidate via envelope; preserva P10."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-settle-payment",
			"agg-payment",
			"evt-payment-settled",
			"inv-no-partial-settlement",
			"inv-settled-fact-canonical",
			"evt-settlement-finalized",
		]
		preconditions: [
			"Payment em dispatched",
			"evt-settlement-finalized recebido e reconciliado do BKR (railReferenceId)",
			"PaymentAuthorized E PaymentInstructionDispatched presentes no stream (integralidade)",
		]
		postconditions: [
			"Recommendation de liquidação; após human gate, dispatched→settled + evt-payment-settled (fato canônico publicado)",
		]
	}, {
		code:        "act-resolve-guard-escalation"
		name:        "Resolve Guard Escalation"
		description: "Sobre um Payment em escalated (o guard reprovou não-limpo: stale/incompleto/ambíguo-mas-PRESENTE), o agente PROPÕE a recomendação de resolução (override→authorized OU recusa→refused) com o contexto da escalada. NÃO executa autonomamente e NÃO supre o supervisorId: a atribuição nominal é humana (inv-override-requires-attribution). O supervisor decide e aprova; só então cmd-resolve-guard-escalation emite PaymentGuardOverridden (escalated→authorized, com proof) ou PaymentGuardOverrideRefused (escalated→refused). AutonomyLevel: propose-and-wait PERMANENTE — linha vermelha P10/P11 (supervisedDecision override-prepayment-guard do canvas); JAMAIS promovível a execute-and-log (tq-gv-14). Impact: state-change financeiro sancionado. Breach (evidência ausente/cripto-falha) NUNCA chega aqui — vai a freeze (inv-breach-bypasses-escalation)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-resolve-guard-escalation",
			"agg-payment",
			"evt-payment-guard-overridden",
			"evt-payment-guard-override-refused",
			"inv-override-requires-attribution",
			"vo-supervisor-id",
			"vo-overridden-guard-conditions",
		]
		preconditions: [
			"Payment em escalated (via evt-payment-guard-escalated)",
			"Contexto da escalada disponível (quais das 3 condições estão não-limpas)",
		]
		postconditions: [
			"Recommendation gerada (override OU recusa) + rationale, SEM supervisorId (atribuição é humana)",
			"Após human gate com supervisorId + reason: escalated→authorized (PaymentGuardOverridden + proof) OU escalated→refused (PaymentGuardOverrideRefused)",
		]
	}, {
		code:        "act-query-payment-status"
		name:        "Query Payment Status"
		description: "Atender query sobre o estado vigente de um Payment (guarded/escalated/authorized/dispatched/settled/refused) para a tupla (commitmentRef, invoice). Impact: read-only (rehidrata o estado do stream do Payment; sem state change)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-payment",
			"vo-payment-id",
		]
		preconditions: [
			"paymentId OR tupla (commitmentRef, invoice) fornecido",
		]
		postconditions: [
			"Estado vigente do Payment retornado OR not-found se nenhum Payment correspondente existe",
		]
	}, {
		code:        "act-generate-guard-decision-rationale"
		name:        "Generate Guard Decision Rationale"
		description: "Gerar o rationale estruturado de uma decisão do PrePaymentGuard (quais das 3 condições passaram/falharam, com referências às evidências) para o audit trail e para subsidiar a proposta de override quando o Payment está escalado. Impact: read-only (gera explicação a partir do estado + fatos; sem state change). É recomendação de IA, não gate (P10): o rationale informa o humano, não decide."
		category:        "generation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-payment",
			"inv-money-moves-only-on-proof",
			"vo-overridden-guard-conditions",
		]
		preconditions: [
			"Decisão do guard disponível (clean / non-clean / breach) com as condições avaliadas",
		]
		postconditions: [
			"Rationale estruturado gerado (condições + evidências) para audit trail / proposta de override",
		]
	}, {
		code:        "act-detect-breach-or-replay"
		name:        "Detect Breach or Replay"
		description: "Detectar e coletar sinais dos escalationCriteria do canvas: p11-invariant-breach-detected (dispatch ocorrido/tentado sem as 3 condições — tripwire/reconciliação), replay-or-double-pay-attempt (2º dispatch para a mesma tupla OU replay de instruction), prepayment-guard-systemic-failure (gate indisponível/não-reproduzível), regulatory-or-juridical-ambiguity (zona cinza regulatória/jurídica). Impact: read-only + escalation (coleta o sinal e reporta; o agente NÃO 'corrige' — containment fail-safe é freeze/decisão humana, dp-04: parar de mover dinheiro, não degradar a verificação). AutonomyLevel: collect-and-report — o agente reúne a evidência da anomalia; o humano decide o containment."
		category:        "escalation"
		autonomyLevel:   "collect-and-report"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-payment",
			"inv-money-moves-only-on-proof",
			"inv-at-most-once-dispatch",
			"inv-breach-bypasses-escalation",
			"evt-payment-obligation-defaulted",
		]
		preconditions: [
			"Acesso ao stream do Payment + reconciliação BKR + sinais de tripwire do gate",
		]
		postconditions: [
			"Anomaly coletada e reportada (breach / replay / systemic-failure / regulatory) → escalation triggered; nenhum state change autônomo",
		]
	}]

	// =============================================
	// CONSTRAINTS (regras enforced pelo agente)
	// =============================================
	//
	// Cada constraint declara em rationale: enforcementLevel (agent / runner /
	// domain / external) per tq-agg-05 e derivedFromInvariant per tq-agg-06.
	// Schema não modela esses campos como first-class hoje (heuristic-level).

	constraints: [{
		code:         "cst-money-moves-only-on-proof"
		name:         "Money Moves Only On Proof"
		description:  "act-execute-prepayment-guard NUNCA propõe autorização (e nenhum dispatch ocorre) sem as 3 condições do PrePaymentGuard satisfeitas: fatura válida (INV) + elegibilidade satisfeita (REW) + cadeia de evidência íntegra (verify cripto). Qualquer condição ausente/falha bloqueia a autorização (fail-closed)."
		verification: "Runner verifica que para cada evt-payment-authorized emitido, audit trail contém as 3 condições satisfeitas com referências verificáveis (fato de fatura, decisão de elegibilidade, receipt de verify cripto válido). Autorização sem as 3 bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-money-moves-only-on-proof (P11, linha vermelha nível-1). enforcementLevel: agent (gate determinístico in-line pré-autorização) + domain (handler de cmd-authorize-payment re-valida). Sem o gate, dinheiro moveria sem lastro de evidência — fraude por construção."
	}, {
		code:         "cst-guard-deterministic"
		name:         "Guard Deterministic"
		description:  "act-execute-prepayment-guard NUNCA produz decisão não-reproduzível: a mesma entrada (fatura/elegibilidade/evidência) produz a mesma decisão em replay. O agente nunca despacha diretamente; o override do guard é sempre supervisedDecision (act-resolve-guard-escalation)."
		verification: "Runner verifica que a decisão do guard é função determinística das 3 condições (re-execução sobre o mesmo input produz o mesmo outcome); divergência entre execuções roteia a prepayment-guard-systemic-failure (escalation insufficient-context). Nenhum dispatch autônomo direto sem o gate."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-guard-deterministic. enforcementLevel: agent (re-verify do receipt, rtd-012) + domain. P10: agentes recomendam, gates determinísticos validam — um guard não-reproduzível não é gate."
	}, {
		code:         "cst-at-most-once-dispatch"
		name:         "At Most Once Dispatch"
		description:  "act-dispatch-payment-instruction NUNCA despacha 2ª PaymentInstruction para a mesma tupla (commitmentRef, invoice) com dispatch prévio no stream. 2º dispatch/replay roteia a replay-or-double-pay-attempt (escalation suspicious-input)."
		verification: "Runner verifica que para cada evt-payment-instruction-dispatched, nenhum PaymentInstructionDispatched prévio existe para a tupla; 2ª tentativa é rejeitada (no-op idempotente) e dispara anomaly."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-at-most-once-dispatch. enforcementLevel: agent (lookup no stream pré-dispatch) + domain (handler idempotente por eventId/globalPosition). Double-pay é o vetor adversarial sh-06; idempotência é fail-safe."
	}, {
		code:         "cst-no-partial-settlement"
		name:         "No Partial Settlement"
		description:  "act-settle-payment NUNCA liquida parcialmente: settle só fecha a cadeia íntegra guard→authorize→dispatch — exige PaymentAuthorized E PaymentInstructionDispatched prévios no stream."
		verification: "Runner verifica que para cada evt-payment-settled, o stream contém PaymentAuthorized E PaymentInstructionDispatched; settle sobre cadeia incompleta bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-no-partial-settlement. enforcementLevel: agent (verificação de cadeia pré-settle) + domain. Liquidação parcial deixaria o Payment inconsistente entre dispatched e settled."
	}, {
		code:         "cst-settled-fact-canonical"
		name:         "Settled Fact Canonical"
		description:  "act-settle-payment emite PaymentSettled exatamente uma vez por Payment — o fato canônico de dinheiro-moveu, consumido por REW/SCF/ATO/TCM. Nenhum 2º PaymentSettled."
		verification: "Runner verifica que para cada Payment, no máximo um evt-payment-settled existe no stream; 2ª emissão bloqueia (idempotência do fato canônico)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-settled-fact-canonical. enforcementLevel: agent + domain (handler único). Consumers downstream dependem do fato canônico único; duplicata corromperia REW/SCF/ATO/TCM."
	}, {
		code:         "cst-override-requires-human-attribution"
		name:         "Override Requires Human Attribution"
		description:  "act-resolve-guard-escalation NUNCA materializa a transição de override (escalated→authorized) nem a recusa (escalated→refused) sem atribuição nominal humana: supervisorId + reason presentes ANTES da transição. O agente PROPÕE a recomendação mas NÃO supre o supervisorId — a atribuição é exclusivamente humana."
		verification: "Runner verifica que para cada evt-payment-guard-overridden E cada evt-payment-guard-override-refused emitido, audit trail contém supervisorId nominal não-vazio + reason ANTES da transição escalated→authorized/refused. Transição sem supervisorId humano bloqueia emissão. autonomyLevel propose-and-wait é hard gate; o agente jamais preenche o supervisorId."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-override-requires-attribution (P10/P11 linha vermelha nível-1; canvas supervisedDecision override-prepayment-guard). enforcementLevel: agent (autonomyLevel propose-and-wait no spec) + domain (handler de cmd-resolve-guard-escalation exige supervisorId+reason). É o DENTE da permanência: mover dinheiro sem as 3 condições é override de gate — julgamento humano nominalmente atribuído, jamais decisão autônoma do agente."
	}, {
		code:         "cst-breach-bypasses-escalation"
		name:         "Breach Bypasses Escalation"
		description:  "Breach de P11 (evidência ausente OU integridade cripto FALHA) NUNCA chega a act-resolve-guard-escalation: o Payment permanece em guarded e dispara o escalationCriterion p11-invariant-breach-detected (freeze). Só falha NÃO-LIMPA (stale/incompleta/ambígua-mas-PRESENTE) escala. vo-overridden-guard-conditions não tem flag de integridade-cripto — breach é inexpressável como condição overridável."
		verification: "Runner verifica que nenhum evt-payment-guard-escalated é emitido para caso de breach (evidência ausente/cripto-falha); breach roteia a p11-invariant-breach-detected (escalation unclassifiable-anomaly → freeze no envelope). overriddenConditions nunca contém flag de integridade-cripto."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-breach-bypasses-escalation (o PISO inoverridável do adr-155). enforcementLevel: agent (roteamento por classe de condição) + domain (vo-overridden-guard-conditions sem flag cripto — breach inexpressável por construção). Breach que escapasse ao override seria dinheiro movido sobre prova forjada — furo de integridade legal nível-1."
	}, {
		code:         "cst-override-never-autonomous"
		name:         "Override Never Autonomous"
		description:  "O autonomyLevel de act-resolve-guard-escalation é propose-and-wait PERMANENTE — teto que NUNCA sobe. Diferente das mutations autônomas (gate/dispatch/settle, promovíveis), o override jamais é promovido a execute-and-log: nenhuma promotionCriteria do envelope o tem como alvo, e tq-gv-14 proíbe autonomyOverride concedendo execute-and-log a esta mutation."
		verification: "Runner verifica (tq-gv-14, no envelope) que nenhum autonomyOverrides[] do envelope concede execute-and-log a act-resolve-guard-escalation (category mutation), e que promotionCriteria não referencia esta ação. Promoção do override bloqueia."
		onViolation:  "block-and-escalate"
		rationale:    "enforcementLevel: agent (autonomyLevel propose-and-wait no spec) + runner (tq-gv-14 cruza override level × category mutation, no envelope). É a outra metade do DENTE da permanência (com cst-override-requires-human-attribution): a atribuição é humana E o teto nunca sobe. A assimetria com as mutations promovíveis é a enforcement P10 que ratifica o adr-155."
	}]

	// =============================================
	// ESCALATION CONDITIONS (when to halt and escalate)
	// =============================================
	//
	// Mapeamento dos escalationCriteria + supervisedDecisions do canvas
	// (contexts/fce/canvas.cue) nas 6 categorias de #EscalationCategory.

	escalationConditions: [{
		category:    "conflicting-signals"
		description: "Sinais divergentes entre as fontes do guard: fatura (INV), decisão de elegibilidade (REW) e cadeia de evidência apontam para conclusões inconsistentes para a mesma tupla; OR lineage cancel-then-reissue com divergência (canvas supervisedDecision authorize-cancel-then-reissue, sh-06)."
		rationale:   "Cobertura tq-ag-10 para as mutations autônomas. Divergência de input do gate não é caso para autorização nem para reject automático — exige reconciliação humana antes de mover dinheiro (P10)."
	}, {
		category:    "insufficient-context"
		description: "Inputs do guard indisponíveis ou stale além de threshold (REW/INV stale, EvidencePort indisponível) — canvas escalationCriteria prepayment-guard-systemic-failure; OR SettlementIndeterminate persistente além da janela operacional (canvas supervisedDecision resolve-settlement-indeterminate-persistent)."
		rationale:   "Cobertura tq-ag-10. SoT crítica indisponível/stale exige fallback humano ou postergação — não degradar a verificação (dp-04); gate comprometido = nenhum pagamento autônomo (fail-safe)."
	}, {
		category:    "ambiguous-case"
		description: "O PrePaymentGuard reprova NÃO-LIMPO: uma das 3 condições está stale, incompleta ou ambígua-mas-PRESENTE (a prova subjacente EXISTE mas frescor/interpretação está em questão) — canvas supervisedDecision override-prepayment-guard. Caso intermediário entre clean-pass (determinístico) e breach (freeze): guarded→escalated, resolvido por act-resolve-guard-escalation sob atribuição humana."
		rationale:   "Cobertura tq-ag-10. É a escalada CENTRAL do adr-155 — o override humano-only. Distinto de breach (que vai a freeze, NÃO escala): aqui o humano julga que a prova existe; jamais autônomo (cst-override-requires-human-attribution)."
	}, {
		category:    "out-of-scope"
		description: "Decisão fora da autoridade do gate determinístico: declarar PaymentObligationDefaulted (impacto reputacional/risco em REW — canvas supervisedDecision confirm-payment-obligation-default); OR autorizar reemissão após cancelamento (cancel-then-reissue, sh-06) que exige verificação anti-laundering."
		rationale:   "Cobertura tq-ag-10. Declarar default ou autorizar lineage adversarial não é puramente determinístico — excede a autoridade autônoma do agente; pertence a julgamento humano (REW/compliance)."
	}, {
		category:    "suspicious-input"
		description: "Vetor adversarial detectado: 2º dispatch para a mesma tupla (commitmentRef, invoice) OR replay de PaymentInstruction — canvas escalationCriteria replay-or-double-pay-attempt (sh-06)."
		rationale:   "Cobertura tq-ag-10. Double-pay/replay é vetor adversarial sh-06; o reject é fail-safe determinístico (no-op idempotente), mas o padrão exige análise humana de origem (bug vs ataque) via security review."
	}, {
		category:    "unclassifiable-anomaly"
		description: "BREACH de P11 detectado: dispatch ocorrido/tentado sem as 3 condições satisfeitas (violação do gate por reconciliação/tripwire) — canvas escalationCriteria p11-invariant-breach-detected, a violação mais grave (integridade legal nível-1); OR zona cinza regulatória/jurídica (regulatory-block BKR, AML/sanctions, enquadramento incerto — canvas escalationCriteria regulatory-or-juridical-ambiguity)."
		rationale:   "Cobertura tq-ag-10. Breach de P11 é a violação nível-1: containment fail-safe primeiro (freeze, ADR-079), diagnóstico depois. O ROUTING desta categoria no envelope (escalationRouting) materializa o freeze como alert-and-block — é o (ii) do rtd-018 (freeze-routing do breach). Integridade legal é constraint inviolável."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Canvas FCE declara purpose (gate money-on-proof), capabilities (cc-03 24/7 via gate determinístico), businessDecisions (bd-payment-canonical-state, bd-settlement-fact-canonical), governanceScope (3 autonomousDecisions + 4 supervisedDecisions + 4 escalationCriteria), incentiveAnalysis (sh-05/sh-06 vetores adversariais). Slices necessários para operar o gate, as escaladas supervisionadas e a detecção de breach."
			requiredSlices: [
				"ownership",
				"governanceScope",
				"capabilities",
				"communication",
				"incentiveAnalysis",
			]
		}, {
			artifactType: "domain-model"
			rationale:    "Source of truth para operationalScope refs (1 aggregate, 5 commands, 9 events, 7 invariants, 0 projections). Necessário para cada action validar domainModelRefs ⊆ domain-model do BC per tq-ag-01/tq-ag-02 (sc-ag-01)."
		}, {
			artifactType: "glossary"
			rationale:    "Terminologia canônica do FCE (Payment, PrePaymentGuard, Authorization Proof, Settlement, Financialization, Payment Guard Escalated/Overridden/Override Refused — 19 terms). Action names + audit trail field semantics + rationale alinham com glossary."
			requiredSlices: ["terms"]
		}, {
			artifactType: "agent-governance"
			rationale:    "Envelope fce-primary-agent.governance.cue (par sequencial) declara AUTONOMIA atual: promotionCriteria das mutations autônomas (rumo ao 24/7 do canvas), autonomyOverrides intermediários, escalationRouting (channel/SLA/recipient por category — incl. unclassifiable-anomaly→alert-and-block para o freeze do breach), blastRadiusCaps, calibration, driftDetection. Agente consulta o envelope para resolver QUANDO escalar (do spec) → COMO escalar (do envelope)."
		}, {
			artifactType: "context-map"
			rationale:    "FCE integra cross-BC: consome InvoiceIssued (INV) e a faceta eligibility de RiskEvaluationEmitted (REW), despacha ao BKR e consome SettlementFinalized, publica PaymentSettled para REW/SCF/ATO/TCM e PaymentObligationDefaulted para REW. Context map slice de relationships informa contracts e ACLs."
			requiredSlices: ["relationships"]
		}]
		estimatedBudget: "moderate"
	}

	// =============================================
	// OBSERVABILITY
	// =============================================

	observability: {
		signals: [{
			code:           "sig-payment-mutation-executed"
			name:           "Payment Mutation Executed"
			description:    "Sinal emitido após command de mutation processado (post-approval em propose-and-wait; direto em execute-and-log do materialize). Cobertura: act-materialize-payment, act-execute-prepayment-guard, act-dispatch-payment-instruction, act-settle-payment, act-resolve-guard-escalation."
			coversCategory: "mutation"
			trigger:        "Imediatamente após state transition em agg-payment + emit event"
			level:          "info"
		}, {
			code:           "sig-supervision-requested"
			name:           "Supervision Requested"
			description:    "Sinal emitido quando autonomyLevel propose-and-wait gera recommendation aguardando aprovação humana. Cobertura: as 3 mutations autônomas (Phase 0) + act-resolve-guard-escalation (override, permanente)."
			coversCategory: "mutation"
			trigger:        "Recommendation criada, aguardando aprovação humana"
			level:          "info"
		}, {
			code:           "sig-escalation-triggered"
			name:           "Escalation Triggered"
			description:    "Sinal emitido quando qualquer escalationCondition dispara. Captura category + rationale + action que disparou + recommendation se aplicável. Inclui o breach (unclassifiable-anomaly) que aciona o freeze."
			coversCategory: "escalation"
			trigger:        "EscalationCondition disparada (any category)"
			level:          "warn"
		}, {
			code:           "sig-query-served"
			name:           "Query Served"
			description:    "Sinal emitido após cada query atendida. Cobertura: act-query-payment-status."
			coversCategory: "query"
			trigger:        "Após retorno de query"
			level:          "info"
		}, {
			code:           "sig-generation-result"
			name:           "Generation Result"
			description:    "Sinal emitido após act-generate-guard-decision-rationale. Reporta o rationale estruturado anexado ao audit trail e à proposta de override."
			coversCategory: "generation"
			trigger:        "Após geração de rationale concluída"
			level:          "info"
		}, {
			code:           "sig-constraint-violation"
			name:           "Constraint Violation"
			description:    "Sinal emitido quando onViolation block-and-escalate ativada em qualquer constraint. Captura constraint code + invariant origem + violation context."
			coversCategory: "mutation"
			trigger:        "Constraint violation detectada"
			level:          "error"
		}, {
			code:           "sig-payment-fact-emitted"
			name:           "Payment Fact Emitted"
			description:    "Sinal FCE-specific emitido após cada fato de Payment (PaymentAuthorized / PaymentInstructionDispatched / PaymentSettled). Captura paymentId, commitmentRef, outcome, authorization-proof ref, e o snapshot das 3 condições do guard pré-decisão. Permite reconstrução do gate money-on-proof independente do agent log para auditoria contínua (nível-1)."
			coversCategory: "mutation"
			trigger:        "Fato de Payment materializado e event publicado"
			level:          "info"
		}, {
			code:           "sig-override-resolved"
			name:           "Override Resolved"
			description:    "Sinal FCE-specific emitido após resolução de escalada (PaymentGuardOverridden / PaymentGuardOverrideRefused). Captura supervisorId nominal, reason, overriddenConditions e proof (no caso de override). É o registro auditável do ato humano sancionado — o trail que cst-override-requires-human-attribution exige (fronteira nível-1)."
			coversCategory: "mutation"
			trigger:        "Override ou recusa materializado após aprovação humana"
			level:          "info"
		}]
		auditTrail: {
			requiredFields: [
				"timestamp",
				"agent-id",
				"action-code",
				"input-summary",
				"output-summary",
				"decision-rationale",
				"governance-version",
				"payment-id",
				"commitment-ref",
				"authorization-proof-ref",
				"guard-conditions-snapshot",
				"supervisor-id",
				"override-reason",
				"overridden-conditions",
			]
			storageHint: "Event Log imutável do FCE com retention regulatory-grade (nível-1, Bacen/SCD) — cada decisão do guard, dispatch, liquidação e override é fato imutável referenciável por outros SoTs (REW/SCF/ATO/TCM/CMT) via paymentId/commitmentRef. Audit trail do agente em partição dedicada."
			rationale:   "7 mínimos cobrem reconstituição genérica (timestamp/agent-id/action-code/input-summary/output-summary/decision-rationale/governance-version). 7 FCE-specific cobrem a reconstituição nível-1: payment-id é root identity; commitment-ref vincula ao compromisso CMT (root cross-BC); authorization-proof-ref sustenta inv-money-moves-only-on-proof auditável (a prova que autorizou o movimento); guard-conditions-snapshot sustenta inv-guard-deterministic (as 3 condições no momento da decisão são evidência reproduzível do gate); supervisor-id + override-reason + overridden-conditions são o TRAIL do override humano (a atribuição nominal que cst-override-requires-human-attribution verifica — sem ela a permanência não é auditável). Audit reconstrutível (teste canônico): dado o registro, reconstitui-se inputs + decisão + proof + outcome + atribuição humana do override."
		}
	}

	rationale: """
		FCE é a camada de execução do commitment lifecycle — consome
		InvoiceIssued (INV) e SettlementFinalized (BKR), e publica
		PaymentSettled (fato canônico de dinheiro-moveu, consumido por
		REW/SCF/ATO/TCM). agt-fce-primary é o operador único deste BC:
		executa o PrePaymentGuard determinístico (money-on-proof, P11),
		conduz o Payment de guarded a settled sob proof, e PROPÕE a
		resolução de escaladas do guard sob supervisão humana.

		Spec ↔ Governance separation per ADR-037: este spec declara
		CAPACIDADE operacional + QUANDO escalar; o envelope
		(fce-primary-agent.governance.cue, par sequencial) declara
		AUTONOMIA atual via promotion criteria + autonomyOverrides +
		COMO escalar (channel/SLA/recipient).

		Princípio canônico (post-founder review 2026-05-01): Phase 0
		baseline as mutations autônomas (guard/dispatch/settle) são
		propose-and-wait, mesmo deterministic-gated. Canvas
		autonomousDecisions (dispatch-on-guard-pass, release-retention-
		on-proof, reissue-on-transient) significam "não exigem julgamento
		humano (gate determinístico)", NÃO "execução sem governança".
		cc-03 (24/7) é o ALVO de promoção declarado no envelope quando a
		calibração provar o gate (candidato a MCM/execute-and-log,
		adr-088) — não o baseline. Preserva P10.

		RATIFICAÇÃO adr-155 (estágio 2 / oq-fce-3): a enforcement P10
		humano-only do override materializa-se na ASSIMETRIA entre as duas
		naturezas de mutation — ambas propose-and-wait hoje, com destinos
		OPOSTOS:
		- as mutations autônomas (gate/dispatch/settle) são PROMOVÍVEIS: o
		  envelope pode subi-las a execute-and-log quando o gate
		  determinístico estiver provado.
		- act-resolve-guard-escalation (o override) é PERMANENTE: teto que
		  NUNCA sobe — cst-override-never-autonomous (tq-gv-14 proíbe
		  override→execute-and-log; promotionCriteria não o referencia) +
		  cst-override-requires-human-attribution (supervisorId nominal +
		  reason ANTES da transição; o agente jamais supre o supervisorId).
		Mover dinheiro sem as 3 condições é override de gate — julgamento
		humano nominalmente atribuído, jamais decisão autônoma. Essa
		assimetria É a enforcement P10 que ratifica o adr-155
		(proposed→accepted).

		Decide-vs-execute (tq-agg-09): em Phase 0 o gate humano é o
		autonomyLevel propose-and-wait — a "decisão" ocorre na aprovação
		humana, a execução é consequência. O gate-pass (act-execute-
		prepayment-guard clean-pass) é função determinística das 3
		condições (não há julgamento a separar da execução); o OVERRIDE é
		onde o julgamento humano vive (act-resolve-guard-escalation).

		PISO inoverridável (adr-155): breach (evidência ausente OU
		integridade cripto FALHA) NUNCA chega ao override — vai a freeze
		(p11-invariant-breach-detected, escalation unclassifiable-anomaly,
		cujo routing o envelope materializa como alert-and-block).
		vo-overridden-guard-conditions não tem flag de integridade-cripto:
		breach é inexpressável como condição overridável
		(cst-breach-bypasses-escalation).

		Canonical removal test (tq-agg-10): SE remover agt-fce-primary, das
		7 invariantes — money-on-proof, guard-deterministic,
		at-most-once-dispatch, no-partial-settlement, settled-fact-canonical
		são re-enforçadas pelos handlers do agg-payment (ownership exclusivo
		bd-payment-canonical-state); override-requires-attribution e
		breach-bypasses-escalation são piso de domínio (handler exige
		supervisorId; VO sem flag cripto). O agente é o OPERADOR (executa o
		gate, propõe, escala), não o único enforcer — o domínio sustenta as
		invariantes; o agente opera dentro delas sob governança.

		Tensão com axiomas: NENHUMA. O agente CUMPRE P10 (recomenda; gates
		determinísticos validam; aprovação humana no override) e P11
		(money-on-proof). A permanência do override HONRA a linha vermelha
		P10/P11 (canvas supervisedDecision override-prepayment-guard) — não
		a tensiona.
		"""
}
