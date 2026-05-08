package inv

// inv-primary-agent.governance.cue — Governance Envelope: INV Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Phase 5 do WI-053 INV bootstrap (close-out). Materializa control plane
// supervisório sobre execution layer Phase 4 (inv-primary-agent.cue):
// routing + caps + drift + calibration + failureHandling.
//
// Fronteira com agent-spec (inv-primary-agent.cue) per adr-037:
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → envelope pode override
//   (Phase 0: nenhum override declarado; promoção via calibration crossing
//    thresholds, NÃO via override retroativo — tq-gv-14 forbid execute-and-log
//    direto a mutations preserva P10 unconditionally)
// - agent-spec declara observability signals → envelope define drift thresholds
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária)
// - lens-regulatory-compliance-as-architecture (primária — Lei NF-e/SCD/Bacen)
// - lens-incentive-alignment (secundária — defesa cascade INV→SCF→REW
//   via realization-gap segmentado + value-concentration cross-metric)
// - lens-organizational-resource-allocation (secundária — caps + lifecycle)
//
// Phase 0 caveats:
// - governanceGlobalVersion "0.1" forward-ref canônico (per cmt/ctr/idc/npm/bdg/ssc).
// - Nenhum autonomyOverride: 2 mutations (act-issue-invoice + act-cancel-invoice)
//   propose-and-wait per spec; 2 validations + 1 escalation per spec.
//   Promoção para execute-and-log via calibration crossing thresholds —
//   tq-gv-14 forbid override direto preserva P10.
// - INV severity tier ALTO: fronteira fiscal-regulatório (Lei NF-e/SCD/Bacen)
//   + origem ativo financeiro da rede. Founder canonical R3: "INV é guardrail
//   do ponto onde sistema cria dinheiro; se frouxo, INV vira vetor de ataque,
//   SCF amplifica, REW legitima — perde a rede".
//
// Authoring manual Phase 0 per founder dialectic R3+R4+R5+:
// - R3: blast radius conservador 2/30 (vs gateway-padrão 2/50); SLA agressivo
//       2h/2h/12h (vs SSC 4h/4h/24h); routing precedence canonical 7-tier;
//       scope elevation rule suspicious-input; HALT recovery protocol.
// - R4: drift segmentação multi-camada (espacial + temporal); multi-actor
//       distributed probing detection; retry diferenciado intra/cross-BC;
//       value-concentration sophisticated attack detection.
// - R5: realization-gap delay-attack vector (p95 settlement > 45d); value-
//       concentration cross-metric requirement; combined adversarial signal
//       rule (weak + weak = strong); unknown event safety rule (HALT default);
//       multi-match resolution rule (highest precedence wins); HALT recovery
//       4-condition (root cause + revalidation + safe replay + auth).
//
// Founder canonical R5+ META capturado: "INV transcends de 'agente que emite
// nota' → 'sistema que decide quando pode confiar em si mesmo'; software
// que vira infraestrutura econômica via 3 camadas de segurança fechadas
// (prevenção structural gates + detecção drift multi-camada + contenção
// escalation + HALT_AGENT)".

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

invPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-inv-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING (5 routes — match spec.escalationConditions)
	// 3 routes com sub-routing split via rationale (out-of-scope replay/cancel;
	// suspicious-input UNCERTAIN/VERIFIED; unclassifiable-anomaly recovery).
	// Tensão schema-level T1 capturada em rationale top-level.
	// =============================================

	escalationRouting: [{
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta em 2h horário comercial. Block scope: item-specific (tuple-specific commitmentRef+evidenceRef); outras tuples continuam fluindo."
		recipient:      "founder"
		rationale: """
			Folded scenarios per spec: (A) ISSUE projection unavailable/incomplete/stale (BD4) OR verificationOutcome != approved; (B) CANCEL invoice not found in aggregate canonical state OR Invoice.status != issued; (C) REACTIVE BLOCK staleness == stale detected (Trap T-R4 endereçado, distinto de missing). DECISION local ABORT_ACTION; ESCALATION DEFERRED com structured failureReason classified.

			Block scope: item-specific (tuple-specific). NÃO global agent halt.

			SLA 2h (vs SSC 4h): atraso em INV trava emissão NF-e operacional + spine financeiro downstream (Receivable bloqueado bloqueia SCF antecipação). Lei NF-e exige reconciliação contínua — gap silencioso é regulatory exposure.
			"""
	}, {
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "DEFAULT: 12h (replay anômalo / idempotency violation). OVERRIDE: sync-human-review com SLA 4h para cancel out-of-window OR post-finality (REGULATORY VIOLATION — pode indicar erro operacional grave OR tentativa manipulação fiscal)."
		recipient:      "founder"
		rationale: """
			ROUTING SPLIT (MANDATORY) — runner dispatcha conforme sub-classification do gate disparado:

			(A) ISSUE idempotency violation (cst-gate-issue-idempotency-pre-execution) — replay legítimo é normal; SOFT severity systemic; pattern threshold-based.
			    → channel: async-queue; SLA: 12h (default da categoria).

			(B) CANCEL out-of-window OR post-finality (sc-inv-05 cancellation-boundary OR cst-gate-cancel-finality-protection) — REGULATORY VIOLATION HARD imediato (janela fiscal NÃO se reabre; non-retryable structural).
			    → channel OVERRIDE: sync-human-review; SLA OVERRIDE: 4h.
			    Rationale do override: cancel fora janela é IRREVERSÍVEL (block já consumado pelo gate) MAS pode indicar (1) erro operacional grave OR (2) tentativa manipulação fiscal (vetor adversarial). Default async-queue 12h inadequado — esses 2 cenários exigem flagging a humano em janela útil para investigação raiz, não batch review. SLA 4h é meio-termo (founder R3 refinement): não emergência sub-2h (block consumado pelo gate), não 12h batch.

			TENSÃO SCHEMA-LEVEL T1 capturada (cross-route — ver rationale top-level): #EscalationRoute single channel; routing condicional via rationale + sub-classification spec. Phase 1+ candidate: sub-routing field at #EscalationRoute.

			Block scope: item-specific em ambos cenários (replay = action específica; cancel out-of-window = invoice específica).
			"""
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "DEFAULT: 2h (VERIFICATION-UNCERTAIN — DB timeout / projection unavailable / glitch retry-eligible). OVERRIDE: sync-human-review com SLA 2h para INFRASTRUCTURE-BREACH VERIFIED OR TEMPORAL-INCONSISTENCY VERIFIED (real structural failure / tentativa exploração ativa). Block scope ELEVÁVEL: actor-affected default; network-segment quando pattern coordenado (ver scope elevation rule em rationale top-level)."
		recipient:      "founder"
		rationale: """
			ROUTING SPLIT (MANDATORY) per founder R3 directive 'UNCERTAIN ≠ VERIFIED; Evidência → humano':

			(A) VERIFICATION-UNCERTAIN — agent NÃO consegue verificar gate (DB timeout durante state lookup; projection unavailable; leitura inconsistente; clockSource canonical unreachable; aggregate state evaluation incomplete). Verify failed mas violação NÃO confirmed. SOFT retry-eligible.
			    → channel: alert-and-block; SLA: 2h (default).
			    → Block scope: actor-affected (commitmentRef OR receivedBy em janela detecção).
			    → Pattern detection counter; HARD apenas em pattern sustained.

			(B) INFRASTRUCTURE-BREACH VERIFIED OR TEMPORAL-INCONSISTENCY VERIFIED — outbox primitive CONFIRMED unavailable; partial state CONFIRMED post-emit; clock skew CONFIRMED via cross-source comparison; ordering inversion CONFIRMED via aggregate state contradiction. Real structural breach. HARD imediato.
			    → channel OVERRIDE: sync-human-review; SLA: 2h.
			    Rationale do override: VERIFIED breach equivale a tentativa exploração ativa (não suspeita estatística; evidência confirmada). Channel sync garante founder review imediato + investigação raiz; alert-and-block (paralelo a outras operations) insuficiente para severity tier verificado. Founder R3 canonical: 'Evidência → humano'.
			    → Block scope ELEVÁVEL: ator-afetado default; elevação network-segment per rule explícita em rationale top-level. Cascade INV→SCF→REW reforça severity — fraude em INV amplifica downstream.

			Founder R2 distinção preserved (verify-failed ≠ invariant-violated): VERIFIED é evidence; UNCERTAIN é hypothesis. Routing reflete ontologically.

			TENSÃO SCHEMA-LEVEL T1 capturada (paralelo a out-of-scope; ver rationale top-level).

			SLA 2h (vs SSC 4h): INV cria ativo financeiro; pattern sustentado escala risco sistêmico se não contido. Founder canonical R3: 'INV é guardrail do ponto onde sistema cria dinheiro'.
			"""
	}, {
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta em 2h. Issue path bloqueado para tuples cuja regimeVersion é anomalous; outras tuples com regime resolvido continuam fluindo."
		recipient:      "founder"
		rationale: """
			REACTIVE ESCALATE per spec (act-escalate-regime-anomaly): regimeVersion observed conflita com expected pattern (CMT projection canonical source). Classifications: anomalous-jump (non-monotonic version progression); expired-but-active (regime past validity but tagged active); missing (commitmentRef sem resolved regimeVersion). DECISION local ABORT_ACTION-FOR-ISSUE + DO_NOT_CORRECT (anti-mini-ATO Trap T-R1; ATO/CMT owns regime correction logic). ESCALATION HARD imediato — DOMAIN-INCONSISTENCY classification.

			Boundary preservation crítica per spec (Trap T-R1): agent NÃO corrige regime; detection é INV responsibility, correction é ATO/CMT responsibility. Routing alert-and-block seria insuficiente — regime anomaly indica drift cross-BC INV↔CMT (CMT projection regime-version-history canonical) que exige sync resolution humana, NÃO pattern threshold.

			Channel sync-human-review (não alert-and-block): HARD severity é domain-inconsistency, NÃO regulatory violation — resolução humana sync apropriada (founder coordena com ATO/CMT owners). Block scope: tuples afetadas (commitmentRef-specific); outras tuples com regime OK continuam fluindo — NÃO global halt.

			SLA 2h: regime anomaly sustentada bloqueia issue path para múltiplas tuples; cada hora adicional acumula backlog operacional + risco drift INV↔CMT expandir.
			"""
	}, {
		category:       "unclassifiable-anomaly"
		channel:        "sync-human-review"
		slaDescription: "Resposta em 2h. HARD blocking: HALT_AGENT (agent-wide stop per spec) — TODAS actions param até reconciliação domain. Distinto de ABORT_ACTION (action-specific). Resume é EXPLICIT (não automático; não timeout-based; ver recovery protocol 4-condição em rationale)."
		recipient:      "founder"
		rationale: """
			POST-EXECUTION invariant violation: sc-inv-* audit detecta invariant violado APESAR de gates passing pre-emit. Examples: amount mismatch Invoice↔Receivable; orphan Invoice OR orphan Receivable (BD7 atomic dual emission breach); cardinalidade != 1; status outside enum; fiscalDocRef mutation. DECISION local HALT_AGENT (agent-wide, NÃO action-specific) per spec — distinção crítica vs ABORT_ACTION. ESCALATION HARD imediato — DOMAIN-CORRUPTION.

			Channel sync HARD (founder R3 directive: 'unclassifiable em INV nunca silencioso, nunca assíncrono'): unclassifiable indica regime fiscal ambíguo OR conflito de legislação OR bug de modelagem — zona regulatória direta (Lei NF-e/SCD/Bacen). Approval autônomo OR pattern threshold seria inaceitável — exige julgamento humano especializado imediato.

			Block scope: agent-wide HALT (NÃO item-specific): domain corruption afeta agent confidence inteira — invariant pós-emit violado significa que gates anteriores podem ter sido contornados; continuar operando autonomamente em qualquer action é risco amplificado. Justificativa de bloqueio amplo per tq-gvg-10: severity tier máximo (regulatory + financial asset corruption — INV cria receivable; cascade SCF/REW).

			SLA 2h: HALT_AGENT stops sistema inteiro INV — atraso é throughput zero + risco de cascade para downstream. Founder canonical R3: 'INV é fronteira fiscal + origem ativo financeiro; erro silencioso aqui = vetor de ataque amplificado'.

			RECOVERY PROTOCOL (MANDATORY per founder R3+R5+ directive — sem isso, HALT vira pausa, NÃO proteção; 'halt sem protocolo de saída vira soft-failure permanente'):
			Agent permanece HALTED até ALL 4 condições satisfeitas SEQUENCIALMENTE:
			(1) root cause identified — investigação humana + audit trail reconciliation MUST conclude qual gate foi contornado, qual sub-component falhou, OR qual evento externo gerou corruption;
			(2) invariants revalidated against canonical state — sc-inv-* check re-executado contra projection canonical pós-reconciliação; corruption MUST estar resolvida em domain state (NÃO apenas mascarada);
			(3) SAFE STATE REPLAY EXECUTED [founder R5+ condition NEW] — replay determinístico de eventos pós-corruption sobre canonical state revalidated; verifica que invariants permanecem válidos DURANTE replay (não apenas em snapshot estático). Previne soft-failure permanente onde corruption está mascarada mas reaparece em next operation;
			(4) explicit human authorization to resume — founder authorization explícita (NÃO automático; NÃO timeout-based; NÃO threshold-based recovery).

			Resume requires audit trail entry: AgentResumedAfterHalt event com fields {haltedAt, haltCause (sc-inv-* code violado), rootCauseSummary, revalidatedInvariants, replayValidationResults, authorizedBy='founder', resumedAt}. Audit trail é auditável — Lei NF-e/Bacen exige trace completo de halt+resume durante operação fiscal.

			Recovery Phase 0: humano + audit trail; agent NÃO 'corrige' domain corruption (fora envelope de autonomy).
			"""
	}]

	// =============================================
	// BLAST RADIUS CAPS — 2/30 (founder R3: INV severity tier alto)
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 2
		maxDailyActions:        30
		rationale: """
			INV: 5 actions (2 mutations issue/cancel com BD7 atomic dual emission semantics + 2 validations + 1 escalation). maxConcurrentMutations 2 limita execução paralela das 2 mutations — ambas com cross-BC impact (Receivable consumed by SCF + REW; cascade INV→SCF→REW founder canonical).

			maxDailyActions 30 (vs SSC/BDG gateways 50): founder R3 directive — 'INV não é só throughput; INV cria ativo financeiro; 50/dia em onboarding é superfície grande demais para erro silencioso em ponto onde sistema cria dinheiro'. 30/dia preserva blast radius pequeno enquanto onboarding acumula track record. Promoção a 50+ via calibration crossing thresholds (validation→operational stage).

			Sanity check: 30 daily ≥ 2 concurrent ✓.

			Lifecycle×caps monotonicidade (tq-gvg-07): faixa onboarding canônica 1-2/20-50; 2/30 mid-band conservador (vs 2/50 upper-end gateway-padrão SSC/BDG). INV severity tier ALTO (fiscal-regulatório Lei NF-e/SCD/Bacen + origem ativo financeiro) justifica posição mid-band em vez de upper-end gateway-padrão.

			Founder canonical R3 capturado: 'guardrail do ponto onde sistema cria dinheiro; se frouxo, INV vira vetor de ataque, SCF amplifica, REW legitima — perde a rede'.
			"""
	}

	// =============================================
	// DRIFT DETECTION (6 métricas — 1 OPERATIONAL + 3 HYBRID + 2 ADVERSARIAL)
	// Founder R3+R4+R5 anti-gaming: multi-camada (single-actor + multi-actor;
	// agregado + segmentado; volume + valor; spatial + temporal).
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-invoice-issuance-cycle-time"
			name:        "Tempo de Ciclo Issue (DLV→Invoice)"
			description: "p95 entre evt-delivery-verified (terminal verificationOutcome=approved) e evt-invoice-issued para mesmo (commitmentRef, evidenceRef) em janela semanal."
			baseline:    "p95 ≤ 30 minutos em horário fiscal operacional"
			threshold:   "p95 > 4 horas em janela semanal"
			rationale:   "[CLASS: OPERATIONAL pure] Latência elevada indica gate friction (insufficient-context DLV stale retentions OR projection lag). NÃO signal adversarial primário — ataque infla volume/valor, não latência. Threshold 4h onboarding-conservador; janela quotation comercial razoável."
		}, {
			code:        "dm-cancel-rate"
			name:        "Taxa de Cancel dentro da Janela Legal"
			description: "% invoices issued período T que sofrem cancel dentro janela fiscal (sc-inv-05) janela semanal. Segregado por reasonCode + emissor."
			baseline:    "< 3% das invoices issued"
			threshold:   "> 8% janela semanal OR > 2 cancellations same emissor em 24h"
			rationale:   "[CLASS: HYBRID op/adv] (a) operacional: DLV classification errors / commitment data inconsistente; (b) ADVERSARIAL: cancel-then-reissue laundering (atacante emite, observa downstream signal, cancela, reemite com params adjusted para evade). Sub-threshold same-emissor 24h captura coordenação intra-actor. Anti-gaming standalone: atacante distribui across emissors → defesa secundária via dm-receivable-realization-gap cross-actor."
		}, {
			code:        "dm-structural-gate-block-rate"
			name:        "Taxa de Block Gates Pre-Execution (multi-camada detection)"
			description: "% actions disparam structural gate block (cst-gate-issue-* OR cst-gate-cancel-*) sobre total actions iniciadas. Segregado por gate code + emissor. ANÁLISE MULTI-CAMADA per founder R4: total + concentration single-emissor + distribuição multi-emissor."
			baseline:    "< 2% total (gates safety-net; volume operacional não dispara regularmente)"
			threshold:   "DETECÇÃO DUAL: (1) > 5% total janela semanal (drift básico); (2) Single emissor concentration > 30% blocks (intra-actor probing) — 1 evaluation HARD; (3) Multi-actor distribution: ≥ 4 emissores DISTINTOS com block-rate individual > 8% no mesmo período + total > 5% — DISTRIBUTED PROBING PATTERN — 1 evaluation HARD"
			rationale:   "[CLASS: HYBRID op/adv com adv-CRITICAL] Detecção MULTI-CAMADA per founder R4 canonical 'single-actor concentration detecta ataque simples; multi-actor distribution detecta ataque sofisticado — você precisa dos dois'. (a) operacional: agent confiança baixa em pre-conditions (rebate de gates = aggregate/projection drift); (b) ADVERSARIAL CRÍTICO: probing pattern coordenado. Single-actor concentration > 30% captura coordenação intra-actor; multi-actor distribution (≥ 4 emissores com block-rate individual > 8% simultâneo + total > 5%) captura DISTRIBUTED PROBING — atacante usa múltiplos emissores cada um abaixo de 30% para evitar single-actor flag. Tolerance 1 evaluation em ambos."
		}, {
			code:        "dm-receivable-realization-gap"
			name:        "Gap de Realização Receivable (FRAUD SIGNAL — segmentado 5-camadas)"
			description: "% receivables emitidos período T que NÃO se materializam em pagamento real (settled) janela 60d post-issuance. SEGMENTAÇÃO MANDATORY per founder R4: agregado global + por emissor + por pagador + por cluster emissor↔receptor (quando disponível). Cadência: mensal."
			baseline:    "< 5% global + < 8% individual emissor (defaults legítimos + disputas comerciais)"
			threshold:   "DETECÇÃO MULTI-CAMADA (espacial + temporal): (1) Global > 12% janela mensal — HARD trigger 1 evaluation; (2) Global sustained > 8% por 4 weeks consecutivas — regression trigger; (3) Qualquer emissor individual > 15% janela mensal — HARD trigger 1 evaluation (BOLSÃO de fraude); (4) Cluster emissor↔receptor recorrente com gap > 10% — colusão coordenada; (5) p95 settlement time > 45 dias janela mensal — DELAYED REALIZATION PATTERN [founder R5]"
			rationale:   "[CLASS: ADVERSARIAL fundamental] MÉTRICA CRÍTICA per founder R3 — ÚNICO drift que LIGA INV à realidade econômica. Sem isso, sistema não sabe se emite 'valor real' ou 'valor fantasma'. SEGMENTAÇÃO MANDATORY per founder R4 canonical: 'fraude real não aparece primeiro no agregado; aparece em bolsões'. TEMPORAL DIMENSION (camada 5) per founder R5 canonical: 'fraude não é só não pagar; fraude também é pagar tarde o suficiente para explorar o sistema' — atacante paga com atraso controlado dentro janela 60d para evitar gap absoluto mas explora capital tied up downstream (SCF amplification time-window). Sem dimensão temporal, detecção chega tarde demais. Anti-gaming INERENTE: settlement REAL externo (não declarado pelo agent); difícil distribuir realization-gap entre many actors porque pagamento downstream é signal externo verificável."
		}, {
			code:        "dm-value-concentration"
			name:        "Concentração de Valor por Emissor (sophisticated attack detection)"
			description: "% valor total receivable issued gerado por top N emissores (N=3 para INV pre-PMF) janela mensal. Mede concentração de VALOR — não volume. Cadência: mensal."
			baseline:    "< 50% top-3 emissores (operação saudável tem distribuição razoável)"
			threshold:   "DETECÇÃO COMBINADA per founder R5 'concentração isolada = ambígua; concentração + comportamento = sinal': (1) > 70% top-3 emissores janela mensal — drift trigger isolated (warn-level); (2) > 40% single emissor sustained (2 evaluations consecutivas) — drift trigger isolated (warn-level); (3) CROSS-METRIC HARD: > 40% single emissor AND (realization-gap individual > 10% OR cancel-rate emissor > 6% OR gate-block-rate emissor > 8%) — sophisticated attack signal CONFIRMED"
			rationale:   "[CLASS: ADVERSARIAL sophisticated] Per founder R4 canonical: 'ataques sofisticados não aumentam volume; concentram valor'. Atacante limitado por blast-radius caps (30/dia) MAXIMIZA valor por action — concentration captura este vetor enquanto realization-gap captura fraude pós-emit. Cross-metric requirement (3) per founder R5: concentração SEM behavioral anomaly é warn-level (não fail) — operação real pode ter clientes grandes legítimos; concentração + qualquer behavioral red flag (gap individual / cancel anômalo / gate-block anômalo) = strong signal. Cross-reference: alta concentração + alto realization-gap individual + delay pattern = COMBO CRÍTICO (probable fictional-value pattern em scale via emissor concentrated + delayed realization para evade temporal detection)."
		}, {
			code:        "dm-blast-radius-utilization"
			name:        "Utilização de Capacidade Blast Radius"
			description: "% médio utilização maxDailyActions (30/dia) janela semanal."
			baseline:    "< 50% utilização média"
			threshold:   "> 85% utilização média em janela semanal"
			rationale:   "[CLASS: HYBRID op/adv] (a) operacional: cap subdimensionado para demanda real; (b) ADVERSARIAL: volume probe pattern (atacante testa limits antes scaling). Threshold 85% (vs SSC 90%) — INV severity tier alto não tolera near-cap crônico. Sustained breach → reduce-autonomy via regression trigger."
		}]
		rationale: """
			6 métricas com classificação explícita op/adv per founder R3+R4+R5 anti-gaming directive: 1 OPERATIONAL pure (cycle-time), 3 HYBRID (cancel-rate / gate-block-rate multi-camada / cap-util), 2 ADVERSARIAL (realization-gap segmentado 5-camadas + value-concentration sophisticated com cross-metric requirement).

			SEGMENTAÇÃO MANDATORY em métricas adversariais per founder R4: realization-gap (global + individual emissor + cluster + temporal); gate-block-rate (single-actor + multi-actor distribution); value-concentration (top-N + single emissor sustained + cross-metric HARD).

			Cadência semanal exceto realization-gap + value-concentration mensal (janela 60d settlement realista).

			Bindings drift→action (tq-gvg-06): cancel-rate breach → reduce-autonomy via regression trigger; gate-block (concentration OR distributed-probing) → suspend-and-escalate; realization-gap (global > 12% OR emissor individual > 15% OR cluster recurrent OR p95 settlement > 45d) → suspend-and-escalate (HARD 1 evaluation; tier máximo); value-concentration cross-metric → suspend (combo); cap-util > 85% sustained → reduce-autonomy.

			Detecção multi-camada per founder R3+R4+R5 canonical: 'fraude real não aparece no agregado, aparece em bolsões'; 'ataques sofisticados não aumentam volume, concentram valor'; 'single-actor + multi-actor — você precisa dos dois'; 'fraude também é pagar tarde o suficiente para explorar o sistema'; 'concentração isolada = ambígua; concentração + comportamento = sinal'.
			"""
	}

	// =============================================
	// CALIBRATION (promotion 15/60 → 50/90 com anti-gaming criteria;
	// 7 regression triggers incluindo combined adversarial signal rule R5)
	// =============================================

	calibration: {
		promotionCriteria: [{
			description: "Promoção onboarding → validation"
			metric: """
				≥ 15 invoices issued+cancelled combined
				AND ZERO violação invariante (todos sc-inv-* PASSING em audit)
				AND taxa aprovação ≥ 97% em mutations propose-and-wait
				AND supervisor-override-rate ≤ 8% sustentado
				AND COVERAGE: invoices de ≥ 5 emissores DISTINTOS em ≥ 3 categorias fiscais distintas
				AND zero ocorrência unclassifiable-anomaly em observation period
				AND realization-gap ≤ 8% em ≥ 4 weeks consecutivas (amostra settlement real)
				"""
			minimumObservationPeriod: "60 days"
			rationale: """
				ANTI-GAMING criteria embutidas: (1) COVERAGE multi-emitter/multi-categoria previne single-emitter gaming (atacante operando 1 caso fácil sem variabilidade real); (2) ZERO unclassifiable-anomaly previne gaming via hiding domain corruption (qualquer corruption pós-emit invalida observation period); (3) realization-gap requirement track record settlement REAL pós-issuance — não pode ser declarado pelo agent; (4) supervisor-override ≤ 8% intermediário (entre baseline 10% e drift threshold 20%) — exige operação aproximando target sem ainda atingir.
				15 invoices em 60 days = volume mínimo para track record significativo INV pré-PMF (<1 invoice/dia esperado). 97% approval reflete severity tier alto fiscal-regulatório.
				"""
		}, {
			description: "Promoção validation → operational"
			metric: """
				≥ 50 invoices issued+cancelled
				AND ZERO violação invariante
				AND taxa aprovação ≥ 99%
				AND supervisor-override-rate ≤ 5% sustentado por 8 semanas
				AND COVERAGE: ≥ 12 emissores distintos em ≥ 4 categorias fiscais
				AND realization-gap ≤ 5% sustentado por 8 semanas
				AND zero unclassifiable-anomaly
				AND audit trail verificável: reconstrução bem-sucedida amostra 10 invoices cobrindo audit fields (timestamp, commitmentRef, evidenceRef, regimeVersion, fiscalDocRef)
				"""
			minimumObservationPeriod: "90 days"
			rationale: """
				Critérios escalados: volume 50 (vs 15), approval 99% (vs 97%), override ≤ 5% (vs 8%), realization-gap ≤ 5% (vs 8%), coverage ampliada (12 emissores / 4 categorias). 90 days exposição múltiplos ciclos fiscais. Audit trail reconstrução é ANTI-GAMING crítico — Lei NF-e/Bacen exige reconstituição completa; gating promotion em reconstrução real previne 'parecer auditável' sem ser.
				"""
		}]
		regressionTriggers: [{
			description:     "Violação autonomy boundary (P10 invariant)"
			metric:          "Qualquer ação executada fora autonomyLevel declarado em spec OR override no envelope"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Tolerance-zero per P10. INV: violação inclui emit sem DLV approved (cst-gate); cancel fora janela legal sem human gate (sc-inv-05 boundary); ABORT_ACTION ignorado e action prosseguindo. suspend-and-escalate — agent NÃO pode operar enquanto causa não identificada."
		}, {
			description:     "Realization-gap HARD trigger (FRAUD SIGNAL — multi-camada)"
			metric:          "dm-receivable-realization-gap viola QUALQUER das 5 camadas: global > 12% OR individual emissor > 15% OR cluster recurrent > 10% OR p95 settlement > 45 dias OR sustained > 8% por 4 weeks"
			threshold:       "1 evaluation mensal (NÃO 2 consecutivas)"
			immediateAction: "suspend-and-escalate"
			rationale:       "TIER MÁXIMO per founder R3+R4+R5 — fictional-value pattern é vetor adversarial fundamental (cascade INV→SCF→REW). Tolerance 1 evaluation reflete severity: 1 mês de gap em qualquer camada já é signal de produção de receivable sintético em escala detectável. Anti-gaming: settlement real é externo (não controlado pelo agent), gap só esconde via tempo (mais severidade quanto mais sustentado)."
		}, {
			description:     "Drift sustained cancel-rate"
			metric:          "dm-cancel-rate > 8% janela semanal OR > 2 cancellations same emissor em 24h"
			threshold:       "2 evaluations consecutivas (semanais)"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach indica laundering pattern OR DLV classification systematic error. reduce-autonomy 1 level por 2 weeks enquanto causa investigada."
		}, {
			description:     "Gate-block concentration OR distributed probing"
			metric:          "dm-structural-gate-block-rate viola: single-emissor concentration > 30% OR multi-actor distribution (≥ 4 emissores com block individual > 8% + total > 5%)"
			threshold:       "1 evaluation"
			immediateAction: "suspend-and-escalate"
			rationale:       "Probe pattern coordenado (intra-actor OR distributed) — atacante mapeando boundaries antes de evade attempt; severity tier alto justifica halt vs reduce-autonomy gradual."
		}, {
			description:     "Cap breach blast radius"
			metric:          "maxConcurrentMutations OR maxDailyActions excedido"
			threshold:       "1 ocorrência em janela 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach amplifica risco fiscal-regulatório (Lei NF-e gap audit) + cascade SCF/REW. Reduce-autonomy enquanto causa investigada (cap subdimensionado vs comportamento anômalo)."
		}, {
			description:     "Cross-BC regime drift sustained INV↔CMT"
			metric:          "Frequência conflicting-signals escalations (regime anomalous-jump / expired-but-active / missing) > 3 em janela semanal"
			threshold:       "1 evaluation"
			immediateAction: "suspend-and-escalate"
			rationale:       "Drift sustained INV↔CMT regime resolution indica corruption upstream (CMT regime-version-history projection inconsistente) OR vetor adversarial (manipulação regime para evade fiscal classification). Tolerance 1 evaluation; anti-mini-ATO preserved (correção em ATO/CMT, não INV); halt previne propagação enquanto cross-BC reconciliation."
		}, {
			description:     "Combined adversarial signal (founder R5 'weak + weak = strong')"
			metric:          "≥ 2 métricas classificadas adversarial OR hybrid simultâneas violadas em janela mensal: dm-cancel-rate breach OR dm-structural-gate-block-rate (concentration OR distributed) OR dm-receivable-realization-gap (qualquer das 5 camadas) OR dm-value-concentration cross-metric (camada 3)"
			threshold:       "1 evaluation"
			immediateAction: "suspend-and-escalate"
			rationale: """
				Per founder R5 canonical: 'ataques reais quase nunca aparecem em UMA métrica só; aparecem em combinações; weak signal + weak signal = strong signal'. Upgrade automático para suspend (não reduce-autonomy) reconhece que 2 sinais adversariais simultâneos é evidência de pattern coordenado, não ruído operacional independente.
				Cobertura: combo 'value-concentration cross-metric + realization-gap individual' (sophisticated attack); combo 'cancel-rate + gate-block distributed' (laundering + probing coordenado); combo 'realization-gap delayed + value-concentration sustained' (capital exploitation pattern).
				TENSÃO SCHEMA-LEVEL T2 capturada: combined signal rule ad-hoc em regression trigger Phase 0; Phase 1+ candidate structural field para multi-metric trigger declaration.
				"""
		}]
		rationale: """
			Promoção 2 estágios: 15/60 onboarding→validation com 4 anti-gaming criteria embutidas (coverage multi-emitter/categoria; zero unclassifiable; realization-gap settlement-real; supervisor-override intermediário); 50/90 validation→operational com escalation ampla + audit trail reconstrução real (ANTI-GAMING crítico Lei NF-e/Bacen).
			7 regression triggers Phase 0: P10 boundary tolerance-zero (suspend); realization-gap multi-camada HARD 1 evaluation (suspend; tier máximo fictional-value pattern); cancel-rate sustained (reduce); gate-block concentration OR distributed (suspend; probe pattern); cap breach (reduce); cross-BC regime drift (suspend; INV↔CMT corruption / regime manipulation); COMBINED ADVERSARIAL SIGNAL (suspend per founder R5 'weak + weak = strong').
			Calibração CONSERVADORA per founder R3: INV é 'guardrail do ponto onde sistema cria dinheiro' — priorizar safety sobre throughput axiomático.
			"""
	}

	// =============================================
	// FAILURE HANDLING (3 events; respeitam gates, não contornam — anti-bypass)
	// =============================================

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Erro interno agent (exception, comportamento não-determinístico em invariant evaluation, gate logic failure): halt operations imediato; founder root cause analysis antes resume. INV severity tier alto — agent não-determinístico em fiscal gateway compromete spine financeiro (Receivable downstream consumer SCF/REW); Lei NF-e/Bacen exige reproducibilidade do gate. NÃO retry — erro estrutural, não transient."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "DIFERENCIADO por escopo per founder R4 'retry mínimo para diferenciar infra failure vs domain inconsistency': (1) Queries projection intra-BC (prj-invoice-by-tuple OR prj-receivable-by-invoice): max 1 retry com exponential backoff (initial 2s); (2) QueryRegimeVersion cross-BC CMT: max 1 retry CURTO (1-2s window) — diferencia infra failure (rede / latency spike / CMT momentary unavailability) vs domain inconsistency. Se 2º retry falha cross-BC → suspend imediato via insufficient-context routing; (3) sc-inv-* audit timeout (post-emit invariant check): SEM RETRY — bug determinístico em audit logic; suspend imediato."
			description: "Timeout split per founder R4. Intra-BC projection: 1 retry exponential (transient lag tolerável). Cross-BC CMT regime: 1 retry curto 1-2s (rede/CMT momentary unavailability ≠ regime drift); 2º falha = estrutural confirmado → suspend insufficient-context. Audit logic timeout: ZERO retry — não diferenciar entre bug e flakiness em gate evaluation; suspend imediato. ANTI-BYPASS CRITICAL: retry NUNCA contorna gates — gate failure é gate failure independente de retry; retry é APENAS para query infrastructure flakiness OR cross-BC infra differentiation, JAMAIS para gate evaluation OR invariant check."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: "3 falhas em 24h indica issue sistêmico (CMT QueryRegimeVersion sustained degradation OR projection prj-invoice-by-tuple corrompida OR audit logic bug OR cross-BC reconciliation impossible). Suspend + immediate founder notification. INV NÃO tolera operação degraded sustentada — amplifica risco procurement audit gap cross-BC (Receivable inconsistente bloqueia SCF antecipação) + Lei NF-e exposure."
		}
		rationale: """
			Per adr-058 promotion tech debt narrative → field first-class. INV severity tier ALTO (gateway fiscal-regulatório Lei NF-e/SCD/Bacen + origem ativo financeiro):
			- suspend-and-escalate em todos 3 events Phase 0 default
			- retry conservador em onTimeout APENAS queries projection intra-BC (não cross-BC sem 1 retry curto; NUNCA gate evaluation)
			- 3/24h threshold paralelo SSC/BDG tier alto financeiro
			ANTI-BYPASS DISCIPLINE per founder R3+R4 directive: failureHandling NUNCA contorna gates — retry é APENAS para query infrastructure flakiness OR cross-BC infra differentiation, JAMAIS para gate evaluation OR invariant check OR cross-BC critical resolution. Gate failure suspende; retry não 'salva' gate. P10 preserved: gates determinísticos validam sem ser bypassáveis via retry/timeout fallback.
			"""
	}

	// =============================================
	// ENVELOPE-LEVEL RATIONALE (closing — captura cross-section discipline)
	// =============================================

	rationale: """
		Envelope governança agt-inv-primary lifecycle onboarding. INV é fronteira fiscal-regulatório (Lei NF-e/SCD/Bacen) + origem ativo financeiro da rede (founder canonical R3: 'guardrail do ponto onde sistema cria dinheiro').

		BIDIRECTIONAL REF VALIDATED (tq-gv-06): agent-spec.code 'agt-inv-primary' == agentRef; agent-spec.governanceRef 'inv-primary-agent' == base name deste arquivo (sem .governance.cue suffix).

		ESCALATION ROUTING: 5 rotas cobrindo 5 categorias spec.escalationConditions (tq-gvg-02 coverage). 3 rotas com routing split via rationale (out-of-scope replay/cancel; suspicious-input UNCERTAIN/VERIFIED; unclassifiable-anomaly recovery protocol).

		ROUTING PRECEDENCE CANONICAL (founder R3 Refinement 1; resolve conflicts entre múltiplos matches simultâneos no runner — sem isso, dois engenheiros implementam runners diferentes → comportamento divergente):
		1. unclassifiable-anomaly (HALT_AGENT) — highest precedence
		2. conflicting-signals (sync-human-review)
		3. suspicious-input VERIFIED (sync-human-review override)
		4. out-of-scope CANCEL ilegal (sync-human-review override)
		5. insufficient-context (alert-and-block)
		6. suspicious-input UNCERTAIN (alert-and-block)
		7. out-of-scope replay (async-queue) — lowest precedence
		Rule: highest precedence match wins; overrides em rationale MUST respect this ordering.

		MULTI-MATCH RESOLUTION RULE (founder R5+ Patch B): se múltiplas categorias são acionadas simultaneamente em um mesmo evento (ex: suspicious-input + conflicting-signals; insufficient-context + out-of-scope) — aplicar SEMPRE a de maior precedência (per ordering 1-7 acima); ignorar side-effects das demais (no double escalation; no double routing; no race conditions); audit trail registra TODAS as categorias matched + qual foi aplicada (rastreabilidade preservada). Garante determinismo global no runner.

		SCOPE ELEVATION RULE (founder R3 Refinement 2; aplicável a suspicious-input):
		- Default scope: actor-affected (commitmentRef OR receivedBy em janela detecção).
		- Elevate to network-segment WHEN: (a) ≥ 2 distinct actors involved within time window OR (b) repeated suspicious-input across linked counterparties (cluster emissor↔receptor).

		UNKNOWN EVENT SAFETY RULE (founder R5+ Patch A; anti-modelagem-incompleta — 'o que quebra sistemas não é o conhecido; é o que não foi modelado'): qualquer evento observado pelo agent que NÃO mapeia para spec.escalationConditions[].category (5 categorias declaradas) OR driftDetection.metrics (6 métricas declaradas) OR failureHandling events (onAgentError / onTimeout / onRepeatedFailure) — MUST ser classified como unclassifiable-anomaly por DEFAULT → HALT_AGENT obrigatório (recovery protocol 4-condições; ver route unclassifiable-anomaly rationale). Honesty arquitetural recursive: schema declara o que conhece + DEFAULT explícito para o que não conhece.

		BLAST RADIUS CAPS: 2/30 mid-band conservador (vs gateway-padrão upper-end 2/50 SSC/BDG). Founder R3 directive: INV severity tier alto + cascade INV→SCF→REW justifica conservadorismo.

		DRIFT DETECTION: 6 métricas com classificação op/adv (1 OPERATIONAL pure / 3 HYBRID / 2 ADVERSARIAL fundamental). Detecção multi-camada: realization-gap espacial (global+individual+cluster) + TEMPORAL (p95 settlement > 45d delayed-attack); gate-block single-actor + multi-actor distributed; value-concentration cross-metric requirement. Cadência semanal (mensal para realization-gap + value-concentration).

		CALIBRATION: 15/60 onboarding→validation + 50/90 validation→operational com 4 anti-gaming criteria embutidas (coverage multi-emitter/categoria; zero unclassifiable; realization-gap settlement-real; supervisor-override intermediário). Audit trail reconstrução requirement em validation→operational.

		REGRESSION TRIGGERS (7 incluindo combined adversarial signal R5): P10 boundary tolerance-zero (suspend); realization-gap multi-camada HARD 1 evaluation (suspend); cancel-rate sustained (reduce); gate-block concentration OR distributed (suspend); cap breach (reduce); cross-BC regime drift (suspend); COMBINED ADVERSARIAL SIGNAL — ≥ 2 métricas adversarial/hybrid simultâneas (suspend per founder R5 'weak + weak = strong').

		FAILURE HANDLING (adr-058 first-class): suspend-and-escalate em 3 events. Retry diferenciado per founder R4: intra-BC projection 1 retry exponential; cross-BC CMT regime 1 retry curto 1-2s (infra vs domain differentiation); audit logic ZERO retry. ANTI-BYPASS DISCIPLINE: retry NUNCA contorna gates — retry é APENAS para query infrastructure flakiness OR cross-BC infra differentiation, JAMAIS para gate evaluation OR invariant check.

		AUTONOMY OVERRIDES: empty Phase 0 per founder R3 directive + PG canonical heuristic. Promotion via calibration crossing thresholds — tq-gv-14 forbid execute-and-log override direto a mutations preserva P10 unconditional.

		ENVELOPE-IS-CONTROL-PLANE (tq-gvg-09): routing + caps + calibration + drift + lifecycle + failureHandling. Nenhuma business logic vazada — invariants Invoice/Receivable + BD7 atomic dual emission + structural gates + audit invariants + regime classification + fiscal docRef integrity + lifecycle 2-state + 3 events + 2 commands vivem em agent-spec.constraints + domain-model.

		TENSÕES STRUCTURAL-LEVEL CAPTURADAS para Phase 1+ enhancement (per founder meta-rule '3 usos → ADR + schema evolution obrigatória'):
		(T1) Sub-routing within category — #EscalationRoute single channel field; routing condicional dentro mesma categoria via rationale + sub-classification spec. 3 usos em este envelope (out-of-scope split replay/cancel; suspicious-input split UNCERTAIN/VERIFIED; unclassifiable-anomaly recovery protocol). PRIMEIRO ENVELOPE REAL CONCENTRANDO ≥ 3 SUB-ROUTING USAGES — track for ADR future quando aparecer em 2º envelope (totalizing 3 envelopes com pattern para promote a schema field).
		(T2) Combined signal rule — ad-hoc em regression trigger Phase 0; Phase 1+ candidate structural field para multi-metric trigger declaration (e.g., #CombinedTrigger com refs a múltiplas métricas).
		(T3) Statistical confidence threshold — gate-block multi-actor distribution + realization-gap segmentation + value-concentration cross-metric usam thresholds estatísticos sem confidence interval explicit declaration; Phase 1+ candidate confidence threshold field per #DriftMetric (z-score / IQR / mediana ± kσ).

		FOUNDER CANONICAL CAPTURED:
		R3: 'INV é guardrail do ponto onde sistema cria dinheiro; se frouxo, INV vira vetor de ataque, SCF amplifica, REW legitima — perde a rede'.
		R4: 'fraude real não aparece no agregado, aparece em bolsões'; 'ataques sofisticados não aumentam volume, concentram valor'; 'single-actor + multi-actor — você precisa dos dois'; 'retry mínimo para diferenciar infra failure vs domain inconsistency'.
		R5: 'fraude é pagar tarde o suficiente para explorar o sistema'; 'concentração isolada = ambígua; concentração + comportamento = sinal'; 'weak signal + weak signal = strong signal'.
		R5+: 'o que quebra sistemas não é o conhecido; é o que não foi modelado' (unknown event safety rule); 'halt sem protocolo de saída vira soft-failure permanente' (HALT recovery 4-condition).
		R5++ META: 'INV transcends de "agente que emite nota" → "sistema que decide quando pode confiar em si mesmo"'; 'sistema que não depende de confiar no comportamento; depende de detectar quando o comportamento deixa de ser confiável'.

		3 CAMADAS DE SEGURANÇA fechadas: prevenção (structural gates pre-execution em spec.constraints) + detecção (drift multi-camada espacial+temporal+behavioral) + contenção (escalation routing precedence canonical + HALT_AGENT recovery 4-condition + UNKNOWN EVENT default).

		Boundaries spec preservadas: BD2 deterministic-fiscal-projection (drift metrics não interpretam — observam outcomes); BD7 atomic-dual-emission (regression trigger HARD para orphan Invoice/Receivable via unclassifiable-anomaly); BD10 anti-orchestrator (conflicting-signals routing preserva anti-mini-ATO; agent SINALIZA NÃO corrige).

		Lenses: agent-governance (primária); regulatory-compliance-as-architecture (primária — Lei NF-e/SCD/Bacen); incentive-alignment (secundária — defesa cascade INV→SCF→REW via realization-gap segmentado + value-concentration cross-metric); organizational-resource-allocation (secundária — caps + lifecycle).
		"""
}
