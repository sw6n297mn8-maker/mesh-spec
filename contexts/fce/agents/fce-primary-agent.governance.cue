package fce

// fce-primary-agent.governance.cue — Governance Envelope: FCE Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do FCE.
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, calibração de autonomia e failure
// handling. Atua como freio operacional do FCE — agente que move
// dinheiro real exige governance mais conservador que peers.
//
// Fronteira com agent-spec (fce-primary-agent.cue):
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → este envelope NÃO override
//   (defense-in-depth via supervised-forever stack — ver rationale outer)
// - agent-spec declara observability signals → este envelope define drift thresholds
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária):
//   aag-autonomy-boundary, aag-escalation-protocol, aag-blast-radius-containment,
//   aag-agent-capability-lifecycle, aag-hitl-calibration, aag-drift-detection
// - lens-security-trust-infrastructure (primária):
//   blast radius caps mínimos absolutos Phase 0, defense in depth contra
//   adversarial input via source-bc-affected scope, anti-drift estrutural
//   via payload-hash tolerance-zero
// - lens-regulatory-compliance-as-architecture (secundária):
//   governanceGlobalVersion rastreável, audit trail regulatory-grade via
//   spec, retention via global policy (forward-ref)
//
// Limitações conhecidas:
// - governanceGlobalVersion "0.1" é forward reference para
//   architecture/agent-governance.cue ainda não materializado.
//   Estruturalmente permitido (campo é string com regex no type system);
//   match com versão do global é validação de runner (tq-gv-12, warn).
//   Será satisfeito quando global for criado com version "0.1".
// - Baselines numéricos para dm-settling-window-p95 e dm-escalation-rate-
//   by-category ficam pending empirical calibration — números fixos a
//   priori criariam falsa precisão. Behavior interim: act-resolve-prolonged-
//   settling (router humano) governa settling prolongado caso a caso;
//   safety cap > 30 escalations/category/week aplica enquanto distribuição
//   real é coletada.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

fcePrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-fce-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING (6 routes, 1:1 com categories do spec)
	// =============================================

	escalationRouting: [{
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Payment afetado bloqueado até resolução; demais payments continuam."
		recipient:      "founder"
		rationale: """
			Block scope: payment-specific (apenas o payment_id em conflito é retido;
			demais payments e operações cross-aggregate continuam normalmente).
			Conflito entre fontes upstream (REW/INV/TCM/BKR/DRC) sobre o mesmo
			payment exige julgamento humano sobre precedência — agente não tem
			autoridade para decidir qual fonte prevalece. Canal sync porque
			conflito não resolvido propaga incerteza cross-BC (ATO, SCF, REW
			consomem PaymentSettled posterior); resolução rápida contém propagação.
			SLA 4h úteis: conservador para Phase 0; pode estreitar via calibration
			quando padrões de conflito forem caracterizados. Contexto mínimo a
			anexar à escalation: PaymentId, snapshot dos eventos ACL conflitantes,
			snapshot do estado interno do payment, refs aos invariants potencialmente
			violados.
			"""
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Payment afetado bloqueado até contexto fornecido; demais payments continuam."
		recipient:      "founder"
		rationale: """
			Block scope: payment-specific (apenas o payment_id sem contexto é
			retido; demais payments continuam). Contexto insuficiente para gate
			determinístico (e.g., QueryCashAvailability timeout em TCM persistente,
			CommitmentId não resolve em CMT, payload BKR ACK sem BankTransferRef
			esperado) viola integridade da decisão — prosseguir geraria movimento
			sem evidência completa. alert-and-block escolhido sobre sync-human-review
			porque a action é frequentemente bloqueante por design (gate guarda
			contra inputs faltantes); humano precisa fornecer contexto ou autorizar
			alternativa. SLA 4h úteis alinhado com conflicting-signals. Precedência:
			insufficient-context precede conflicting-signals quando ambas co-trigger
			porque ausência de contexto bloqueia antes da resolução de conflito —
			o conflito não é plenamente classificável sem contexto mínimo.
			Contexto mínimo: PaymentId, qual input falta, BC source esperado,
			qual gate está bloqueado.
			"""
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Payment afetado bloqueado até interpretação confirmada; demais payments continuam."
		recipient:      "founder"
		rationale: """
			Block scope: payment-specific (apenas o payment_id ambíguo é retido).
			Parâmetros do payment ou compensation fora de zona rotineira (valor
			excede high-value-threshold, rail BKR não previsto, parties em
			jurisdição cross-border não suportada, FinancialCompensationOrdered
			com semântica não-financeira) exigem decisão humana sobre conformidade
			legal e operacional. Canal sync porque ambiguidade em zona regulatória
			ou rail desconhecido é caso onde julgamento humano especializado é
			mais rápido que recursive policy lookup. SLA 4h úteis.
			Contexto mínimo: PaymentId, atributos fora de zona (valor, rail,
			jurisdição), match contra zonas rotineiras conhecidas.
			"""
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Resposta immediate until operational SLA calibration exists. Ingestão ACL do BC source suspeito é retida até validação; outras sources continuam normalmente."
		recipient:      "founder"
		rationale: """
			Block scope: source-bc-affected (e.g., suspeita em payload de DRC →
			evt-dispute-resolved-received e evt-financial-compensation-ordered-received
			de DRC são retidos enquanto humano valida; eventos de INV, REW, BKR
			continuam sendo ingeridos). Guard de precedência: quando source for
			BKR e suspicious input envolver BankTransferRef ownership/anomaly
			(e.g., ref nunca emitida pelo FCE, ref duplicada, schema unexpected
			em payload de ACK), precedence eleva para unclassifiable-anomaly e
			agent-wide block — anomalia estrutural no canal mais crítico do FCE
			justifica bloqueio amplo.
			Padrão suspeito em input ACL externo (evt-financial-compensation-
			ordered-received com amount desproporcional; payload BKR com schema
			unexpected; sequence de events sugerindo replay/manipulation;
			BankTransferRef de evt-bank-settlement-confirmed-received nunca
			emitido pelo FCE) requer escalation imediata — pode ser vetor de
			injection/manipulation/fraude. Canal alert-and-block com SLA
			immediate-until-calibrated porque adversarial input que prossegue
			mesmo por minutos pode disparar mutations financeiras irreversíveis
			downstream. Source-bc-affected é o menor escopo seguro: bloquear
			apenas o BC source do payload suspeito preserva operações com
			outras sources legítimas; bloquear agent-wide criaria DoS via single
			suspicious event (exceto no guard BKR-anomaly acima).
			Contexto mínimo: source BC, event type, payload diff vs schema
			esperado, sequence/temporal pattern detectado, exemplos de
			ocorrências semelhantes recentes (se houver).
			"""
	}, {
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "Resposta dentro de 24 horas. Solicitação específica é retida em queue; operações em andamento continuam."
		recipient:      "founder"
		rationale: """
			Block scope: item-specific (apenas a solicitação fora de escopo entra
			na queue; payments em andamento não são afetados). Operações fora do
			escopo declarado do FCE (KYC/AML/sanctions screening, FX conversion,
			tax calculation, request to change credit pricing or risk score,
			queries cross-BC para as quais FCE não é autoritativo) não são
			bloqueantes do pipeline — agente apenas recusa e enfileira para
			humano clarificar BC apropriado (REW para pricing/risk, SCF para
			antecipação, ATO para tax, etc.) ou rejeitar definitivamente.
			async-queue é o canal correto: sem urgência operacional, mas
			registro auditável de solicitações fora de escopo (útil para
			identificar padrões repetidos que justifiquem extensão de escopo
			via ADR ou criação de novo BC). SLA 24h.
			Contexto mínimo: tipo de solicitação, BC de destino sugerido (se
			identificável), source da solicitação.
			"""
	}, {
		category:       "unclassifiable-anomaly"
		channel:        "alert-and-block"
		slaDescription: "Resposta immediate until operational SLA calibration exists. Agente inteiro suspenso até auditoria de integridade; nenhuma nova action processada até resolução."
		recipient:      "founder"
		rationale: """
			Block scope: agent-wide (todo agt-fce-primary é suspenso até auditoria).
			Anomalias estruturais não classificáveis (BKR ACK para BankTransferRef
			nunca emitido pelo FCE — potencial misrouting ou ataque; ledger event
			não correlacionável a CommitmentId ou PaymentId existente; mismatch
			payload-hash entre recommendation aprovada e execute attempt) indicam
			falha em invariantes do sistema, não apenas no payment individual.
			Bloqueio agent-wide é justificado por severity tier: anomalia
			estrutural pode comprometer integridade de qualquer payment subsequente
			(não apenas o que disparou o sinal); operar sob anomalia não
			classificada é assumir risco sistêmico sem evidência. SLA immediate-
			until-calibrated porque anomalia que prossegue contamina audit trail
			e ledger irreversivelmente. Justificativa de severity tier per
			tq-gvg-10: anomaly estrutural = potencial integridade comprometida
			do FCE como executor financeiro; bloqueio amplo é proporcional ao
			blast radius potencial (dinheiro real + ledger SoT regulatório).
			Contexto mínimo: tipo de anomalia, snapshot do estado do agente,
			sequência de actions imediatamente anteriores, hipóteses iniciais
			(misrouting / attack / bug / corrupção de state).
			"""
	}]

	// =============================================
	// BLAST RADIUS CAPS (1/30 Phase 0)
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 1
		maxDailyActions:        30
		rationale: """
			Caps mínimos absolutos para Phase 0 de FCE. maxConcurrentMutations: 1
			— concorrência é o vetor de risco mais perigoso quando dinheiro real
			está em movimento; serialização forçada elimina race conditions entre
			BankTransferRef emission, BKR ACK routing e ledger event recording
			no nível do agent. maxDailyActions: 30 — janela de observação ampla
			o suficiente para acumular volume operacional significativo (≥1 payment
			ciclo completo por dia em throughput normal) sem expor blast radius
			sistêmico. Sanity: daily (30) ≥ concurrent (1). Comparativo: CMT 5/80
			(compromissos não movem dinheiro); FCE 1/30 (movimento financeiro real).
			Promotion para caps maiores via calibration — planned calibration path
			NÃO-binding: onboarding (1/30) → validation (2/50) → operational
			(3/70) → mature (5/100 teto). Planned curve documenta intenção de
			progressão para tornar calibration auditável, mas valores são
			indicativos — actual promotion requires Section calibration criteria
			satisfeitos + founder/governance approval. Acima de mature exige
			decisão governamental explícita (ADR).
			"""
	}

	// =============================================
	// DRIFT DETECTION (7 metrics, cadência mista)
	// =============================================

	driftDetection: {
		evaluationCadence: "mixed (continuous for deterministic; daily/weekly for statistical)"
		metrics: [{
			code:        "dm-payload-hash-mismatch-rate"
			name:        "Taxa de Mismatch de Payload-Hash"
			description: "Mismatches detectados entre payload-hash da recommendation aprovada e payload-hash do command emitido em act-execute-approved-* (3 actions supervised-forever). Drift determinístico — tolerance-zero."
			baseline:    "0 mismatches (qualquer ocorrência indica anti-drift estrutural falhou)"
			threshold:   "≥ 1 ocorrência (tolerance-zero, drift determinístico)"
			rationale: """
				Drift determinístico per tq-gvg-11: anti-drift via payload-hash é
				barreira inviolável entre approval humano e execução de movimento
				financeiro irreversível. Mismatch = aprovação humana foi desviada
				por modificação do payload entre approve e execute (bug, attack,
				ou corrupção de state). Tolerance-zero porque a métrica mede
				integridade estrutural do supervised-forever stack, não comportamento
				estatístico. Avaliação continuous (a cada emit de execute-approved
				action). Vinculada a immediate suspend-and-escalate em regressionTriggers.
				"""
		}, {
			code:        "dm-compensation-payload-mismatch-rate"
			name:        "Taxa de Mismatch de Payload de Compensação"
			description: "Mismatches detectados entre amount/parties/rationale do evt-financial-compensation-ordered-received originário (DRC) e payload do cmd-execute-financial-compensation emitido. Drift determinístico — tolerance-zero."
			baseline:    "0 mismatches (FCE preservou byte-idêntico ao payload DRC)"
			threshold:   "≥ 1 ocorrência (tolerance-zero, drift determinístico)"
			rationale: """
				Drift determinístico per tq-gvg-11: cst-compensation-respects-drc-decision
				exige preservação byte-idêntica de amount/parties/rationale do payload
				DRC originário. Mismatch = FCE modificou, recalculou ou reinterpretou
				decisão DRC (viola Discipline 5 — FCE não é compensating authority).
				Tolerance-zero porque qualquer modificação compromete separation of
				concerns crítica para integridade do sistema de disputa. Avaliação
				continuous (a cada emit de act-execute-approved-financial-compensation).
				Vinculada a immediate suspend-and-escalate em regressionTriggers.
				"""
		}, {
			code:        "dm-bank-transfer-ref-no-owner-rate"
			name:        "Taxa de BankTransferRef Sem Ownership"
			description: "Percentual de evt-bank-settlement-confirmed-received cujo BankTransferRef não resolve para nenhum aggregate (no-owner case em act-route-bank-settlement-by-ownership). Drift estatístico — anomaly detection."
			baseline:    "< 0.5% dos BKR ACKs observados (margem para race conditions e reconciliação pendente)"
			threshold:   "> 2% em janela sustained de 7 days OR pattern repetido (≥3 ocorrências em 24h) para mesma reference"
			rationale: """
				Drift estatístico per tq-gvg-11: BKR ACK para BankTransferRef
				no-owner é caso possível em race conditions de observabilidade,
				atraso de persistência de ownership, ou ACK duplicado/tardio de
				integração BKR — pequena taxa baseline é tolerada. Taxa sustained
				acima de 2% ou pattern repetido sugere misrouting BKR, attack
				vector, ou corrupção de ownership tracking. Janela 7 days adequada
				para volume Phase 0 (≤ 30 daily actions; em 7 days acumula ~210
				actions). Confidence threshold: 2% requer ≥4 no-owner em janela
				de 7 days (1% do baseline esperado); escopo de contenção
				source-bc-affected (BKR) por default; agent-wide se pattern
				for adversarial (precedence). Vinculada a reduce-autonomy
				em regressionTriggers (statistical drift).
				"""
		}, {
			code:        "dm-settling-window-p95"
			name:        "p95 da Janela Settling"
			description: "p95 do tempo entre emissão de cmd-initiate-bank-transfer e BankSettlementConfirmed observado, por rail. Drift estatístico — operational health."
			baseline:    "baseline pending rail-specific calibration"
			threshold:   "threshold pending governance calibration; until calibrated, prolonged settling escalates conservatively via act-resolve-prolonged-settling (router humano com sync-human-review)"
			rationale: """
				Drift estatístico per tq-gvg-11: settling window é métrica de
				saúde operacional. Baselines numéricos por rail (PIX, TED,
				boleto, SWIFT) não são fixados no envelope Phase 0 — values
				ainda não calibrados contra produção; falsa precisão criaria
				norma artificial. Behavior interim: act-resolve-prolonged-settling
				(router humano com propose-and-wait) é o gate operacional —
				humano decide rota por payment conforme settling se prolonga;
				governance envelope não automatiza decisão sem rail-specific
				data. Calibration window (≥30 days operational data) define
				baselines per rail em amendment futuro do envelope. Cadência
				de avaliação: daily (uma vez calibrado).
				"""
		}, {
			code:        "dm-payment-default-rate"
			name:        "Taxa de Payment Default"
			description: "Percentual de payments emitidos (atingiram settling) que terminam em defaulted (vs settled). Drift estatístico — operational health + risk signal."
			baseline:    "< 1% dos payments emitidos resultam em default (baseline interno Phase 0)"
			threshold:   "> 3% em janela sustained de 30 days"
			rationale: """
				Drift estatístico per tq-gvg-11: default rate alto indica
				problemas estruturais (rail BKR instável, threshold de
				PrePaymentGuard frouxo permitindo payments sem cobertura
				efetiva, ou padrão sistêmico de timeout não tratado).
				Baseline < 1% é conservador Phase 0 — valor interno calibrável
				contra produção. Threshold 3% sustained 30 days cobre flutuação
				operacional sem ser insensível a degradação. Janela 30 days
				adequada para volume Phase 0. Vinculada a reduce-autonomy em
				regressionTriggers (statistical drift) — agente continua
				operando com caps reduzidos enquanto causa raiz é investigada.
				"""
		}, {
			code:        "dm-supervision-approval-rate"
			name:        "Taxa de Aprovação de Supervisão Humana"
			description: "Percentual de recommendations produzidas por propose actions (act-propose-*) que humano aprova (vs rejeita ou modifica) via mech-agent-gate. Drift estatístico — recommendation quality."
			baseline:    "≥ 95% das recommendations são aprovadas sem modificação"
			threshold:   "< 85% em janela sustained de 30 days OR < 70% em qualquer janela de 7 days"
			rationale: """
				Drift estatístico per tq-gvg-11: aprovação rate mede qualidade
				das recommendations do agente — taxa baixa indica recommendation
				ruim (calibração inadequada, contexto insuficiente, ou drift
				de raciocínio). 95% baseline alinha com CMT (também 95%). Dois
				thresholds: sustained moderate (< 85% em 30 days) e acute (< 70%
				em 7 days) — acute captura degradação rápida que sustained perderia.
				Modificações pelo humano contam como não-aprovação porque indicam
				recommendation imperfeita. Vinculada a reduce-autonomy + revisão
				mandatória pelo founder antes de promotion (calibration).
				"""
		}, {
			code:        "dm-escalation-rate-by-category"
			name:        "Taxa de Escalation por Category"
			description: "Volume e distribuição de escalations disparadas, agregadas por category (das 6 routes). Drift estatístico — escalation calibration health."
			baseline:    "baseline pending empirical calibration; expected early pattern: out-of-scope and insufficient-context likely dominate"
			threshold:   "threshold pending empirical calibration; until calibrated, any category showing sustained operational overload triggers review. Safety cap: > 30 escalations/category/week dispara reduce-autonomy independente de baseline calibrado"
			rationale: """
				Drift estatístico per tq-gvg-11: escalation rate alto numa category
				indica miscalibração — condição de escalation está disparando
				ruidosamente (escalation conditions calibradas frouxas) OU agente
				está operando frequentemente em condições para as quais não tem
				autonomia (operational scope mal-dimensionado). Distribuição
				numérica de baselines por category não é fixada Phase 0 — pattern
				real emergirá com operação; thresholds percentuais a priori
				criariam falsa precisão. Behavior interim: safety cap >30
				escalations/category/week é absoluto (overload detection
				independente de baseline calibrado). Calibration window
				(≥30 days operational data) refinará baselines e thresholds
				estatísticos em amendment futuro. Vinculada a reduce-autonomy
				+ revisão de escalation conditions no agent-spec (potencial
				amendment futuro do spec).
				"""
		}]
		rationale: """
			7 metrics cobrindo: integridade estrutural (dm-payload-hash-mismatch,
			dm-compensation-payload-mismatch — tolerance-zero deterministic),
			ownership routing health (dm-bank-transfer-ref-no-owner — statistical),
			operational health (dm-settling-window-p95, dm-payment-default-rate —
			statistical), recommendation quality (dm-supervision-approval-rate —
			statistical), escalation calibration (dm-escalation-rate-by-category —
			statistical). Cadência mista reflete natureza das métricas: deterministic
			avaliada continuous; statistical avaliada daily ou weekly. Diferenciação
			determinístico vs estatístico per tq-gvg-11 — deterministic triggers
			immediate suspend-and-escalate; statistical triggers reduce-autonomy
			com janela sustained. 2 metrics têm baseline/threshold pending empirical
			calibration (settling window, escalation rate) — behavior interim
			explícito em cada uma evita falsa precisão.
			"""
	}

	// =============================================
	// CALIBRATION (promotion + regression + rationale)
	// =============================================

	calibration: {
		promotionCriteria: [{
			description: "Promoção de onboarding para validation"
			metric: """
				(a) ≥ 30 payments processados end-to-end (terminal state: settled,
				defaulted ou aborted); (b) ≥ 10 evt-bank-settlement-confirmed-received
				observados e routed corretamente via act-route-bank-settlement-by-ownership
				(ownership-resolution=match-payment OR match-compensation; zero no-owner
				unresolved); (c) zero violações de qualquer constraint financeira
				(cst-bank-transfer-supervised, cst-compensation-respects-drc-decision,
				cst-cash-availability-checked, cst-settled-requires-bkr-confirmation,
				cst-payment-evidence-required) E zero violações de qualquer constraint
				de integridade (cst-ledger-append-only, cst-post-settle-immutability,
				cst-commitment-id-preserved); (d) zero dm-payload-hash-mismatch +
				zero dm-compensation-payload-mismatch; (e) dm-supervision-approval-rate
				≥ 95% em todo o período; (f) dm-settling-window-p95 dentro de qualquer
				baseline calibrado por rail (se calibrado) OR ausência de act-resolve-
				prolonged-settling invocations recorrentes não-resolvidas.
				"""
			minimumObservationPeriod: "30 days"
			rationale: """
				30 payments é volume mínimo para padrão significativo Phase 0
				(caps 1/30 permitem 1 payment/day média; 30 days garante 1 cycle
				mensal completo). 10 BKR ACKs routed corretamente é floor
				absoluto — o coração operacional do FCE é BKR ACK routing;
				promotion sem evidência de routing correto é prematura. Critérios
				(c)+(d) tolerance-zero alinham com regressionTriggers (qualquer
				violação financeira ou mismatch deterministic já dispara regression
				imediata; aqui confirma que NENHUMA ocorreu durante observação).
				(e) qualidade de recommendation alinhada com CMT (95% baseline).
				(f) settling health alinhada com act-resolve-prolonged-settling —
				promotion não pode coexistir com prolonged settling endêmico
				não-tratado.
				"""
		}, {
			description: "Promoção de validation para operational"
			metric: """
				(a) ≥ 100 payments processados end-to-end; (b) ≥ 50 BKR ACKs
				routed corretamente com zero no-owner BankTransferRef anomalies
				unresolved (closure formal de Discipline 10); (c) zero violações
				financeiras ou de integridade sustained por 60 days; (d) zero
				deterministic drift events (payload-hash, compensation-payload);
				(e) dm-supervision-approval-rate ≥ 98% sustained 60 days;
				(f) dm-bank-transfer-ref-no-owner-rate dentro de baseline
				(< 0.5%) sustained 60 days; (g) dm-payment-default-rate dentro
				de baseline (< 1%) sustained 60 days; (h) audit trail
				reconstrutível em amostra aleatória de 20 operações end-to-end —
				if present, include compensations/defaults/aborted; otherwise
				use simulated/replay audit cases para cobrir cenários terminais
				não-naturais.
				"""
			minimumObservationPeriod: "60 days"
			rationale: """
				Volume 100 payments + 50 BKR ACKs reflete operação validada com
				margem estatística significativa. Closure formal de Discipline 10
				(b) é gate explícito — zero no-owner anomalies unresolved fecha
				o ownership guard. (e) aprovação 98% alinha com PG heuristic.
				(f)+(g) drift metrics estáveis em baseline (não apenas abaixo de
				threshold) demonstra calibração madura. (h) audit trail
				reconstrutível em amostra de 20 operações — condicional sobre
				disponibilidade orgânica de compensations/defaults/aborted, com
				fallback para simulated/replay cases para evitar forçar default
				ou compensation real como pré-condição de promoção. 60 days
				garante exposição a múltiplos ciclos contábeis + ≥1 ciclo mensal
				de reconciliação cross-BC (ATO/SCF/TCM).
				"""
		}]

		regressionTriggers: [{
			description:     "Mismatch de payload-hash em execute-approved action"
			metric:          "dm-payload-hash-mismatch-rate"
			threshold:       "≥ 1 ocorrência (tolerance-zero, drift determinístico)"
			immediateAction: "suspend-and-escalate"
			rationale: """
				Mismatch detected: anti-drift estrutural falhou. Suspend imediato
				do agente até root cause analysis. Drift determinístico per
				tq-gvg-11 — tolerance-zero porque a métrica mede integridade do
				supervised-forever stack, não comportamento estatístico.
				"""
		}, {
			description:     "Mismatch de payload de compensação vs ordem DRC"
			metric:          "dm-compensation-payload-mismatch-rate"
			threshold:       "≥ 1 ocorrência (tolerance-zero, drift determinístico)"
			immediateAction: "suspend-and-escalate"
			rationale: """
				FCE modificou, recalculou ou reinterpretou decisão DRC. Suspend
				imediato. Discipline 5 (frase canônica) violada estruturalmente.
				"""
		}, {
			description:     "Tentativa de mutação retroativa em ledger event registrado"
			metric:          "Qualquer command rejected pelo lifecycle de prj-financial-ledger por tentar update/delete em ledger event existente"
			threshold:       "≥ 1 ocorrência (tolerance-zero)"
			immediateAction: "suspend-and-escalate"
			rationale: """
				Discipline 8 (Ledger append-only) violada estruturalmente.
				Tentativa de mutação retroativa indica bug crítico no agente
				(deveria emitir novo ledger event via FinancialCompensation,
				não update). Suspend imediato preserva integridade do SoT
				financeiro auditável.
				"""
		}, {
			description:     "Emit de cmd-initiate-bank-transfer ou cmd-execute-financial-compensation sem approval-id"
			metric:          "Audit trail de qualquer act-execute-approved-bank-transfer ou act-execute-approved-financial-compensation sem approval-id presente OR com approval-id que não resolve para recommendation aprovada"
			threshold:       "≥ 1 ocorrência (tolerance-zero)"
			immediateAction: "suspend-and-escalate"
			rationale: """
				cst-bank-transfer-supervised + cst-compensation-respects-drc-decision
				violados estruturalmente. Movimento financeiro irreversível
				emitido sem audit autorizado — irreparável. Suspend imediato +
				forense urgente sobre o emit.
				"""
		}, {
			description:     "Violação de qualquer constraint financeira"
			metric:          "Qualquer ocorrência de onViolation block-and-escalate em cst-payment-evidence-required, cst-settled-requires-bkr-confirmation, cst-bank-transfer-supervised, cst-cash-availability-checked, cst-compensation-respects-drc-decision"
			threshold:       "≥ 1 ocorrência (tolerance-zero)"
			immediateAction: "suspend-and-escalate"
			rationale: """
				Constraint financeira violada = potencial movimento sem evidência
				ou sem supervisão. Tolerance-zero: financial constraint violations
				exigem suspend-and-escalate imediato.
				"""
		}, {
			description:     "Violação de constraint de integridade não-financeira"
			metric:          "Qualquer ocorrência de onViolation block-and-escalate em cst-ledger-append-only, cst-post-settle-immutability, cst-commitment-id-preserved"
			threshold:       "≥ 1 ocorrência (tolerance-zero)"
			immediateAction: "suspend-and-escalate"
			rationale: """
				Constraint de integridade violada = corrupção potencial de audit
				trail, ledger ou rastreabilidade cross-BC. Tolerance-zero.
				"""
		}, {
			description:     "Drift estatístico sustained em dm-bank-transfer-ref-no-owner-rate"
			metric:          "dm-bank-transfer-ref-no-owner-rate"
			threshold:       "> 2% em janela sustained de 7 days"
			immediateAction: "reduce-autonomy"
			rationale: """
				Drift estatístico per tq-gvg-11: redução de autonomia (caps menores)
				força throughput mais baixo enquanto humano investiga causa raiz
				(BKR misrouting, attack, corruption). Confidence threshold + janela
				7 days conforme dm baseline.
				"""
		}, {
			description:     "Drift estatístico sustained em dm-payment-default-rate"
			metric:          "dm-payment-default-rate"
			threshold:       "> 3% em janela sustained de 30 days"
			immediateAction: "reduce-autonomy"
			rationale: """
				Drift estatístico per tq-gvg-11: default rate alto sustained
				indica problema estrutural (rail, guard frouxo, timeout pattern).
				Reduce-autonomy força investigação.
				"""
		}, {
			description:     "Drift estatístico sustained em dm-supervision-approval-rate"
			metric:          "dm-supervision-approval-rate"
			threshold:       "< 85% em sustained 30 days OR < 70% em qualquer 7 days"
			immediateAction: "reduce-autonomy"
			rationale: """
				Drift estatístico per tq-gvg-11: qualidade de recommendation
				degradou. Reduce-autonomy reduz throughput enquanto recalibração
				ocorre. Dual threshold (sustained + acute) per dm rationale.
				"""
		}, {
			description:     "Drift estatístico em dm-escalation-rate-by-category"
			metric:          "dm-escalation-rate-by-category"
			threshold:       "Safety cap absoluto: > 30 escalations/category/week (até baseline empírico calibrado, este é o trigger único)"
			immediateAction: "reduce-autonomy"
			rationale: """
				Drift estatístico per tq-gvg-11: escalation calibration miscalibrada.
				Phase 0 sem baseline empírico calibrado — safety cap >30/category/
				week opera como threshold único. Reduce-autonomy + flag para
				potencial amendment do agent-spec.
				"""
		}, {
			description:     "Drift estatístico em dm-settling-window-p95"
			metric:          "dm-settling-window-p95"
			threshold:       "Quando calibrado: p95 > threshold por rail sustained 7 days. Until calibrated: act-resolve-prolonged-settling recorrente não-resolvido como proxy"
			immediateAction: "reduce-autonomy"
			rationale: """
				Drift estatístico per tq-gvg-11: settling health degradada.
				Behavior interim alinhado com dm baseline (pending rail-specific
				calibration).
				"""
		}, {
			description:     "Blast radius cap breach"
			metric:          "maxConcurrentMutations (1) ou maxDailyActions (30) excedido"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale: """
				Cap breach = subdimensionamento OU comportamento anômalo. Reduce-
				autonomy contém blast radius enquanto causa é investigada (vs
				suspend, que seria desproporcional para cap operacional).
				"""
		}]

		rationale: """
			Calibration em dois estágios — onboarding→validation (30 payments, 10 BKR
			ACKs routed, 30 days) e validation→operational (100 payments, 50 BKR ACKs
			com Discipline 10 closure, 60 days). 12 regression triggers segregados em
			2 grupos:

			IMMEDIATE SUSPEND (tolerance-zero, deterministic/structural):
			  1. dm-payload-hash-mismatch (anti-drift estrutural falhou)
			  2. dm-compensation-payload-mismatch (Discipline 5 violada)
			  3. Tentativa de mutação retroativa em ledger (Discipline 8)
			  4. Emit unapproved bank transfer (cst-bank-transfer-supervised)
			  5. Qualquer constraint financeira (5 constraints — payment-evidence,
			     settled-bkr, bank-transfer-supervised, cash-availability,
			     compensation-drc)
			  6. Qualquer constraint de integridade não-financeira (3 constraints —
			     ledger-append-only, post-settle-immutability, commitment-id-preserved)

			REDUCE CAPS (statistical drift sustained / operational containment):
			  7. dm-bank-transfer-ref-no-owner sustained
			  8. dm-payment-default sustained
			  9. dm-supervision-approval sustained
			  10. dm-escalation-rate-by-category sustained
			  11. dm-settling-window-p95 sustained
			  12. Blast radius cap breach

			Calibração conservadora Phase 0 reflete FCE como executor de dinheiro
			real — preferência por suspend over reduce-autonomy quando integridade
			estrutural está em jogo; reduce-autonomy reservado para drift
			operacional estatístico onde investigação humana pode acompanhar
			operação com throughput reduzido. Planned calibration path indicativo
			(1/30 → 2/50 → 3/70 → 5/100) é non-binding — promotion exige critérios
			satisfeitos + founder approval, não promoção automática.
			"""
	}

	// =============================================
	// FAILURE HANDLING (per adr-058)
	// =============================================

	failureHandling: {
		onAgentError: {
			action: "suspend-and-escalate"
			description: """
				Erro interno do agente (exception não-tratada, comportamento
				não-determinístico, falha de raciocínio, output mal-formado):
				halt operations imediato. Forense via founder review antes de
				retomar. FCE move dinheiro real — qualquer erro interno é
				potencial vetor de corrupção de state ou movimento incorreto.
				"""
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "Max 1 retry com exponential backoff (initial 2s)"
			description: """
				Timeout técnico em operação do agente (e.g., consulta a TCM via
				QueryCashAvailability sem resposta, leitura de projection trava,
				chamada BKR API para submit ou lookup sem resposta, persistência
				de audit event sem completion): retry once com backoff; falha
				persiste = suspend + escalate via insufficient-context routing.
				Distinção crítica: BKR ACK ausente para uma transferência já
				emitida NÃO é timeout de operação do agente — é settling
				prolongado governado por act-resolve-prolonged-settling (router
				humano) e dm-settling-window-p95; failure handling cobre apenas
				timeouts em operações iniciadas pelo agente.
				"""
		}
		onRepeatedFailure: {
			action:     "suspend-and-escalate"
			threshold:  "3 failures attributable to agent/runtime OR unresolved external dependency failures affecting FCE operations in 24h"
			timeWindow: "24h"
			description: """
				3 failures atribuíveis ao agente/runtime (agent errors, timeouts
				técnicos do próprio agente) OR external dependency failures
				não-resolvidas afetando operações do FCE (e.g., TCM persistently
				unavailable bloqueando PrePaymentGuard; BKR API down impedindo
				submit de cmd-initiate-bank-transfer) em janela de 24h sugere
				issue estrutural não acidental. Suspend operations + immediate
				founder notification + forense de pattern. Distinção entre
				agent/runtime failure vs external dependency failure preserva
				attribution — falhas externas repetidas não devem punir o agente
				mas justificam suspend até dependency restaurada (e.g., BKR
				maintenance, TCM downtime). Threshold conservador Phase 0 (vs
				CMT também 3/24h) porque FCE move dinheiro — não há margem para
				padrão de erro silencioso acumulando.
				"""
		}
		rationale: """
			Per adr-058 promotion de tech debt narrative para field first-class
			enforced. Defaults conservadores Phase 0 alinhados com CMT/SSC/CTR/NPM:
			suspend-and-escalate em todos os 3 eventos; retry once em onTimeout;
			threshold 3/24h para repeated failure. Diferenciais FCE: rationale
			explicita por que conservatism é mandatório (dinheiro real,
			irreversibilidade de movements); onTimeout distingue timeout técnico
			do agente vs settling prolongado (governado em outro lugar);
			onRepeatedFailure distingue agent/runtime failures de external
			dependency failures (attribution justa). Calibração BC-specific
			futura via amendment se padrões operacionais justificarem (e.g.,
			retryPolicy diferente por tipo de dependência externa, dependendo
			de characteristics observadas).
			"""
	}

	// =============================================
	// RATIONALE OUTER
	// =============================================

	rationale: """
		Envelope de governança do agt-fce-primary em lifecycle onboarding.
		FCE move dinheiro real via rails BKR e mantém o ledger financeiro
		canônico (SoT) cross-BC — envelope dimensionado como freio operacional
		conservador, não como config administrativa. 6 routes de escalation
		cobrindo 1:1 as 6 categories do agent-spec (conflicting-signals,
		insufficient-context, ambiguous-case, suspicious-input, out-of-scope,
		unclassifiable-anomaly); blast radius caps mínimos absolutos
		(1 concurrent / 30 daily) para Phase 0; drift detection com 7 metrics
		mistas (2 deterministic tolerance-zero + 5 statistical sustained);
		calibration com promotion criteria de 2 estágios (onboarding→validation,
		validation→operational) ancorados em volume + BKR ACK floor + integrity
		clean record; 12 regression triggers segregados (6 immediate suspend
		para drift deterministic + violations financeiras/integridade; 6 reduce
		caps para drift estatístico + cap breach); failureHandling per adr-058
		com distinção entre timeouts técnicos do agente vs settling prolongado
		e entre agent/runtime failures vs external dependency failures.

		═══ SUPERVISED-FOREVER CANONICAL LIST ═══

		As seguintes 3 actions do agt-fce-primary mantêm supervisão humana
		obrigatória via mech-agent-gate + payload-hash match. Não muda por
		calibration cycle — mudança desta lista exige decisão governamental
		explícita (ADR no schema #AgentGovernanceEnvelope ou versão major
		do governance global), nunca calibration automática:

		  1. act-execute-approved-bank-transfer
		     (emit cmd-initiate-bank-transfer → BKR rail)
		     Movimento real de dinheiro irreversível.

		  2. act-execute-approved-financial-compensation
		     (emit cmd-execute-financial-compensation → BKR rail)
		     Movimento real de dinheiro corretivo irreversível.

		  3. act-execute-approved-mark-default
		     (emit cmd-mark-defaulted + publish PaymentObligationDefaulted)
		     Reputação financeira da contraparte irreversível downstream em REW.

		Mecanismo de enforcement (defense-in-depth):
		  (a) Spec declara estas 3 actions como execute-and-log COM precondition
		      obrigatória de approval-id + payload-hash match
		  (b) cst-bank-transfer-supervised + cst-compensation-respects-drc-decision
		      têm onViolation block-and-escalate
		  (c) Este envelope NÃO declara autonomyOverrides para estas 3 actions
		      (não há nível de autonomia válido que remova supervisão)
		  (d) Drift metric dm-payload-hash-mismatch-rate tem tolerance-zero
		      com immediate action suspend-and-escalate
		  (e) Drift metric dm-compensation-payload-mismatch-rate tem
		      tolerance-zero com immediate action suspend-and-escalate
		  (f) Calibration promotion criteria não removem supervised-forever —
		      promotion eleva caps e cadência, NÃO remove gates de aprovação

		═══ ROUTING PRECEDENCE (when multiple categories may co-trigger) ═══

		Quando uma única action satisfaz condições de múltiplas categories
		simultaneamente, precedência canônica (mais alta precedência primeiro):

		  1. unclassifiable-anomaly    (agent-wide block, immediate)
		  2. suspicious-input          (source-bc-affected block, immediate)
		  3. insufficient-context      (payment-specific block, 4h)
		  4. conflicting-signals       (payment-specific block, 4h)
		  5. ambiguous-case            (payment-specific block, 4h)
		  6. out-of-scope              (item-specific, 24h)

		Princípios aplicados (per tq-gvg-05):
		  - blocking > non-blocking: anomaly e suspicious precedem out-of-scope
		  - mutation-related > informational: categories que afetam decisão de
		    movimento financeiro (1-5) precedem categories informacionais (6)
		  - explicit route > fallback: todas as 6 categories têm route declarada;
		    fallback global não é alcançado em situações normais

		Guard de elevação BKR (per Section 1B suspicious-input rationale):
		quando source for BKR e suspicious input envolver BankTransferRef
		ownership/anomaly, precedence eleva para unclassifiable-anomaly e
		agent-wide block — anomalia estrutural no canal mais crítico do FCE
		justifica bloqueio amplo. Exemplo: BKR ACK chega com BankTransferRef
		nunca emitido pelo FCE (anomaly) + payload com schema unexpected
		(suspicious-input) → resolve para unclassifiable-anomaly.

		═══ BLOCK SCOPE TAXONOMY ═══

		Routes declaram block scope explícito no rationale (per tq-gvg-10):
		6 routes declaram block scope; 3 são bloqueios fortes via alert-and-block.
		Granularidade Phase 0:

		  - payment-specific:     conflicting-signals, insufficient-context,
		                          ambiguous-case (3 routes)
		  - source-bc-affected:   suspicious-input (1 route)
		  - item-specific:        out-of-scope (1 route)
		  - agent-wide:           unclassifiable-anomaly (1 route)

		Escopos reservados não-utilizados Phase 0:
		  - commitment-affected: scope reservado para futuro quando múltiplos
		    payments ligados ao mesmo CommitmentId estiverem ativos simultaneamente;
		    Phase 0 usa payment-specific para manter blast radius menor.
		  - system-global: scope reservado para emergências cross-agent (e.g.,
		    governance global compromise); não usado em envelope per-agent.

		═══ PLANNED CALIBRATION PATH (non-binding) ═══

		Curva indicativa de caps por lifecycle stage (planning, não promotion
		automática): onboarding (1/30) → validation (2/50) → operational
		(3/70) → mature (5/100 teto). Promotion exige critérios satisfeitos
		(promotionCriteria) + founder/governance approval — não há promoção
		por feeling ou volume isolado. Curva documentada para tornar
		calibration auditável.

		Lenses: aag (primária — autonomia, escalation, blast radius, lifecycle,
		calibração, drift), sti (primária — caps mínimos absolutos, defense
		in depth, anti-drift estrutural), rc (secundária — governance-version
		rastreável, audit trail regulatory-grade via spec).
		"""
}
