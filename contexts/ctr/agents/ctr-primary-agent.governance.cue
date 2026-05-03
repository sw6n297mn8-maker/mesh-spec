package ctr

// ctr-primary-agent.governance.cue — Governance Envelope: CTR Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do CTR.
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, e calibração de autonomia.
//
// Fronteira com agent-spec (ctr-primary-agent.cue):
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → este envelope pode override
// - agent-spec declara observability signals → este envelope define drift thresholds
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária):
//   aag-autonomy-boundary, aag-escalation-protocol, aag-blast-radius-containment,
//   aag-agent-capability-lifecycle, aag-hitl-calibration, aag-drift-detection
// - lens-security-trust-infrastructure (secundária):
//   blast radius caps, defense in depth via limites conservadores
// - lens-contractual-and-legal-architecture (secundária):
//   impacto jurídico de ativação/cancelamento informa canal de escalação
// - lens-regulatory-compliance-as-architecture (terciária):
//   governanceGlobalVersion rastreável, calibração vinculada a compliance
//
// Limitações conhecidas:
// - governanceGlobalVersion "0.1" é forward reference para
//   architecture/agent-governance.cue que ainda não existe.
//   Estruturalmente permitido: campo é string com regex no type system;
//   match com versão do global é validação de runner (tq-gv-12, warn).
//   Será satisfeito quando global for criado com version "0.1".
// - Threshold de valor contratual para escalação aguarda definição
//   (canvas oq-ctr-1, deadline 2026-06-01). Em onboarding, 100% das
//   ativações são supervisionadas — threshold não é operacionalmente relevante.
// - Categoria ambiguous-case unifica dois riscos semanticamente distintos
//   (econômico e regulatório) por limitação de sub-routing no runner.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ctrPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-ctr-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING
	// =============================================

	escalationRouting: [{
		category:       "out-of-scope"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Tipo de contrato novo bloqueia registro até definição de template."
		recipient:      "founder"
		rationale:      "Tipo contratual não previsto exige definição de template e validação jurídica antes de registro. Canal sync porque decisão bloqueia pipeline de registro — atraso propaga para formalização de compromissos em CMT. (aag-escalation-protocol: contexto mínimo inclui tipo de contrato, cláusulas identificadas, e gap versus templates existentes.)"
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 2 horas úteis. Operação bloqueada até resolução."
		recipient:      "founder"
		rationale:      "Cobre duas condições do agent-spec com semânticas distintas: (1) valor do contrato acima de threshold — risco econômico e blast radius financeiro; (2) zona cinza regulatória — risco de conformidade e legalidade. Unificadas na mesma rota por limitação do runner: #EscalationRoute mapeia 1:1 com #EscalationCategory, sem sub-routing por condição. Semânticas serão separadas quando runner suportar sub-routing ou quando categorias forem desdobradas no schema. Em lifecycle onboarding, 100% das ativações já são propose-and-wait — threshold de valor (canvas oq-ctr-1) é operacionalmente deferido para quando calibração permitir override de autonomia. Canal sync e SLA curto porque ambiguidade regulatória em intermediário financeiro é constraint inviolável (nível 1). (cl-liability-allocation: ambiguidade não resolvida expõe Mesh a liability por default.)"
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Registro bloqueado até resolução."
		recipient:      "founder"
		rationale:      "Input suspeito pode indicar termos enviesados ou fraudulentos (canvas incentive analysis sh-01). alert-and-block porque registrar termos potencialmente fraudulentos criaria fato de domínio em draft que, mesmo não ativado, polui o registry e pode ser explorado em disputas. Tentativas bloqueadas são registradas no audit trail operacional do agente (sig-escalation-triggered + campos de audit trail) — evidência operacional preservada sem criar artefato de domínio. Separação deliberada: event log de domínio registra fatos de negócio; audit trail do agente registra tentativas e decisões operacionais."
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 1 hora útil. Operação bloqueada até NPM disponível ou decisão manual de abortar e reencaminhar por procedimento excepcional fora do fluxo padrão."
		recipient:      "founder"
		rationale:      "NPM indisponível impede validação de qualificação de partes — registrar sem validação viola inv-valid-participant-qualification, que é invariante do domínio e não admite bypass mesmo por decisão humana dentro do fluxo. SLA curto (1h) porque indisponibilidade de NPM pode afetar múltiplos registros simultâneos, e resolução rápida (retry, abortar ou reencaminhar) desbloqueia pipeline. (canvas as-ctr-2: NPM disponível com latência aceitável é assumption — indisponibilidade é cenário de degradação, não operação normal.)"
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 3
		maxDailyActions:        50
		rationale: "Caps conservadores para lifecycle onboarding. maxConcurrentMutations=3 permite throughput mínimo operacional sem perder contenção e auditabilidade manual — agente processa registros concorrentes mas volume é limitado o suficiente para revisão individual. 50 ações diárias cobrem operação pré-PMF (registros + queries + validações + publicações) com margem para picos. Calibração prevista na revisão mensal do primeiro mês de operação com dados reais de volume. (aag-blast-radius-containment: capability nova inicia com blast radius mínimo e expande com track record.)"
	}

	// =============================================
	// DRIFT DETECTION
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-escalation-rate"
			name:        "Taxa de Escalação por Condição"
			description: "Percentual de operações onde o agente dispara uma escalation condition (out-of-scope, ambiguous-case, suspicious-input, insufficient-context) versus processamento normal. Distinto de supervisão by design — ativação e cancelamento são propose-and-wait por spec, não contam como escalação."
			baseline:    "< 15% das operações disparam escalation conditions"
			threshold:   "< 2% (sub-escalação: agente ignorando anomalias) ou > 30% (super-escalação: agente paralisado por falsos positivos)"
			rationale:   "Sub-escalação indica agente processando situações que deveria escalar — risco de registrar termos com anomalias não detectadas. Super-escalação indica agente conservador demais — consome constraint do founder sem valor. Ambos são drift operacional. (aag-drift-detection: baseline + threshold bilateral para cada capability.)"
		}, {
			code:        "dm-validation-rejection-rate"
			name:        "Taxa de Rejeição de Qualificação de Partes"
			description: "Percentual de registros (iniciais e revisões) rejeitados por falha de qualificação de partes em NPM."
			baseline:    "< 5% dos registros rejeitados por qualificação"
			threshold:   "> 15% dos registros rejeitados"
			rationale:   "Taxa alta de rejeição pode indicar: (1) mudança no perfil de quem submete termos, (2) degradação da qualidade de dados no NPM, ou (3) partes operando sem qualificação adequada. Cada cenário exige investigação diferente — métrica é sinal, não diagnóstico."
		}, {
			code:        "dm-lifecycle-completion-rate"
			name:        "Taxa de Conclusão Normal de Lifecycle"
			description: "Percentual de termos que completam lifecycle normalmente (draft→active→superseded ou draft→active→expired) versus terminações anômalas (cancelled de qualquer estado, draft que nunca ativa)."
			baseline:    "> 80% dos termos completam lifecycle normal"
			threshold:   "< 60% de conclusão normal"
			rationale:   "Taxa alta de cancelamento ou drafts abandonados pode indicar: registros precipitados, termos mal formados, ou uso de cancelamento como workaround para edição (violaria imutabilidade conceitual). Threshold de 60% é conservador — primeiros meses podem ter taxa menor por learning curve dos participantes."
		}]
		rationale: "Três métricas cobrem comportamento do agente (escalação), qualidade de input (rejeição), e saúde do lifecycle (conclusão). Cadência semanal adequada para onboarding — volume baixo, cada semana acumula amostra suficiente. Métricas são sinais para investigação, não gatilhos automáticos de ação. (aag-drift-detection: drift é silencioso — detecção ativa é o mecanismo.)"
	}

	// =============================================
	// CALIBRATION
	// =============================================

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation"
			metric:                   "≥ 30 registros processados com zero violação de invariante e taxa de aprovação de recomendações ≥ 95% (supervisor aprova o que agente propôs em ações propose-and-wait)"
			minimumObservationPeriod: "30 days"
			rationale:                "30 registros é volume mínimo para padrão significativo em operação inicial. 30 dias garante exposição a variação temporal. Taxa de aprovação de 95% mede alinhamento entre julgamento do agente e do supervisor — rejeição > 5% indica necessidade de recalibração antes de reduzir supervisão. (aag-agent-capability-lifecycle: onboarding → validation com critérios ex ante.)"
		}, {
			description:              "Promoção de validation para operational"
			metric:                   "≥ 100 registros processados, zero violação de invariante, taxa de aprovação ≥ 98%, zero drift detectado acima de threshold por 4 semanas consecutivas, audit trail verificável com reconstrução bem-sucedida em amostra de 10 operações"
			minimumObservationPeriod: "60 days"
			rationale:                "Critérios mais exigentes: volume maior, aprovação mais alta, drift monitorado e estável, audit trail testado. 60 dias garante exposição a ciclos de revisão contratual e expiração. Audit trail testável é pré-requisito regulatório — promoção sem verificação transfere risco para fase com menos supervisão. (aag-hitl-calibration: supervisão proporcional à maturidade e consequência.)"
		}]
		regressionTriggers: [{
			description:     "Violação de invariante"
			metric:          "Qualquer violação de inv-single-active-version, inv-post-activation-immutability, inv-lineage-integrity ou inv-valid-participant-qualification"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de invariante em registry de termos contratuais é falha de integridade jurídica. Uma única violação pode ter blast radius irreversível — compromissos downstream referenciando termos inconsistentes. Tolerância zero justificada pelo domínio regulado. (aag-blast-radius-containment: suspend é contenção máxima para falha de integridade.)"
		}, {
			description:     "Drift de escalação sustentado"
			metric:          "dm-escalation-rate fora do intervalo baseline por período prolongado"
			threshold:       "2 avaliações consecutivas (2 semanas) fora do baseline"
			immediateAction: "reduce-autonomy"
			rationale:       "Drift sustentado indica mudança comportamental não transitória. Redução de autonomia força revisão mais intensiva enquanto causa é investigada. Duas semanas consecutivas filtra flutuações pontuais. (aag-drift-detection: detecção precoce + ação proporcional.)"
		}, {
			description:     "Rejeição frequente de recomendações"
			metric:          "Taxa de rejeição de recomendações do agente em ações propose-and-wait (ativação e cancelamento)"
			threshold:       "> 20% de rejeição em janela de 7 dias, com mínimo de 3 rejeições"
			immediateAction: "reduce-autonomy"
			rationale:       "Rejeições frequentes indicam desalinhamento entre critérios do agente e julgamento do supervisor. Threshold relativo (20%) com piso absoluto (3) evita falso positivo em volumes baixos. Redução de autonomia aumenta supervisão enquanto critérios são recalibrados. (aag-hitl-calibration: rejeição é sinal de desalinhamento, não punição.)"
		}]
		rationale: "Promoção em dois estágios: onboarding→validation (30 registros, 30 dias) e validation→operational (100 registros, 60 dias). Regressão com tolerância zero para violação de invariante (integridade jurídica), detecção precoce para drift de escalação (2 semanas), e threshold relativo para rejeição de recomendações (20%+3). Calibração conservadora para fase pré-PMF em domínio regulado — CTR como base jurídica exige priorizar safety sobre speed."
	}

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Erro interno do agente (exception, comportamento não-determinístico): halt operations, escalate to founder for root cause analysis antes de retomar."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "Max 1 retry com exponential backoff (initial 2s)"
			description: "Timeout em operação: retry once; falha persiste = suspend e escalate via insufficient-context routing."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: "3 falhas em 24h sugerem issue sistêmico: suspend agent operations + immediate founder notification."
		}
		rationale: "Per adr-058 promotion de tech debt narrative para field first-class. Defaults conservadores Phase 0: suspend-and-escalate em todos 3 eventos; retry once em onTimeout; threshold 3/24h para repeated failure. Calibração BC-specific futura via amendment se padrões operacionais justificarem."
	}

	rationale: "Envelope de governança do agt-ctr-primary em lifecycle onboarding. Quatro rotas de escalação: sync-human-review para out-of-scope e ambiguous-case (decisões bloqueantes com impacto jurídico, SLA 2-4h), alert-and-block para suspicious-input e insufficient-context (bloquear antes de registrar é contenção upstream). Blast radius caps conservadores (3 concurrent, 50 daily) para fase pré-PMF com throughput mínimo operacional. Drift detection semanal com 3 métricas cobrindo comportamento do agente, qualidade de input e saúde do lifecycle. Calibração: promoção com critérios mensuráveis (volume, aprovação, drift, audit trail), regressão com tolerância zero para violação de invariante. Threshold de valor contratual (canvas oq-ctr-1) operacionalmente deferido — em onboarding, 100% das ativações são supervisionadas por spec. Lenses: aag (primária: autonomia, escalation, blast radius, lifecycle, calibração, drift), sti (secundária: caps conservadores), cl (secundária: impacto jurídico informa routing), rc (terciária: compliance rastreável)."
}
