package npm

// npm-primary-agent.governance.cue — Governance Envelope: NPM Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do NPM.
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, e calibração de autonomia.
//
// Fronteira com agent-spec (npm-primary-agent.cue):
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
// - lens-regulatory-compliance-as-architecture (terciária):
//   governanceGlobalVersion rastreável, calibração vinculada a compliance
//
// Limitações conhecidas:
// - governanceGlobalVersion "0.1" é forward reference para
//   architecture/agent-governance.cue que ainda não existe.
//   Estruturalmente permitido: campo é string com regex no type system;
//   match com versão do global é validação de runner (tq-gv-12, warn).
//   Será satisfeito quando global for criado com version "0.1".
// - Categoria ambiguous-case unifica duas condições semanticamente distintas
//   (mass-suspension-trigger e contested-termination) por limitação da
//   taxonomia atual de categories no envelope. SLA de 4h pode ser
//   insuficiente para contested-termination se envolver análise jurídica —
//   tensão aceita em onboarding, revisável com dados reais.
// - Founder como único recipient de todas as rotas. Limitação estrutural
//   pré-PMF: sem equipe para routing diferenciado. Revisável quando
//   houver papéis operacionais distintos.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

npmPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-npm-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING
	// =============================================

	escalationRouting: [{
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "Resposta dentro de 24 horas. Participante retido em pending até decisão."
		recipient:      "founder"
		rationale:      "Cobre duas condições distintas que compartilham o mesmo routing por limitação da taxonomia atual de categories no envelope: (1) tipo de organização não previsto nos templates de qualificação — falta de referência KYC/AML; (2) mudança regulatória que afeta requisitos de qualificação. Ambas exigem decisão humana porque o agente não possui contexto regulatório para avaliar novos requisitos. Canal async-queue porque nenhuma das duas bloqueia operações de participantes já qualificados — apenas o participante específico ou processo regulatório fica retido. (aag-escalation-protocol: contexto mínimo inclui tipo de organização ou mudança regulatória, gap versus templates existentes, e participantes potencialmente afetados.)"
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Participante ou processo bloqueado até resolução."
		recipient:      "founder"
		rationale:      "Cobre duas condições semanticamente distintas: (1) mass-suspension-trigger — expiração simultânea afeta múltiplos participantes, blast radius proporcional ao número; (2) contested-termination — participante contesta decisão com implicação jurídica (dp-10). Canal sync-human-review porque ambas propagam incerteza para BCs downstream: participante em estado ambíguo bloqueia operações em CTR, SSC e demais consumidores de status. SLA de 4h pode ser insuficiente para contested-termination se envolver análise jurídica — tensão aceita em onboarding, revisável com dados reais. (aag-escalation-protocol: contexto mínimo inclui participantes afetados, cenário concreto, e BCs downstream impactados.)"
	}, {
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até resolução."
		recipient:      "founder"
		rationale:      "Sinais contraditórios sobre participante — e.g., IDC reporta identidade verificada via evento mas query retorna pendente, ou monitoramento detecta irregularidade durante reativação em curso. Canal sync e SLA curto porque participante retido em pending não opera em nenhum BC downstream — CTR não pode emitir contratos, SSC não pode incluir em sourcing — e conflito não resolvido pode criar precedente inconsistente no audit trail. (aag-escalation-protocol: contexto mínimo inclui sinais em conflito, source de cada sinal, e impacto em cada BC consumidor de status NPM.)"
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até contexto fornecido."
		recipient:      "founder"
		rationale:      "Ações que dependem de informação não disponível no contexto local do agente — e.g., QueryIdentityVerificationStatus indisponível, documentação com campos ambíguos, dados cadastrais com inconsistências não resolvíveis. alert-and-block porque prosseguir sem contexto em qualificação viola integridade da decisão e pode habilitar participante não verificado na rede. (aag-escalation-protocol: contexto mínimo inclui qual informação falta, onde deveria estar, e impacto de operar sem ela.)"
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 3
		maxDailyActions:        50
		rationale: "NPM possui 12 ações declaradas (6 execute-and-log mutations/validations + 2 execute-and-log queries + 4 propose-and-wait). maxConcurrentMutations: 3 — mais conservador que CMT (5/10) porque cada mutação NPM afeta status de participante consumido por múltiplos BCs downstream. 3 concurrent mutations permitem processamento paralelo de até 3 participantes em etapas distintas do lifecycle sem saturar contexto do agente. maxDailyActions: 50 reflete volume esperado em onboarding — rede com poucos participantes iniciais, maioria das ações são queries e validações. Recomendação de implementação: queries (act-query-*) são leitura sem efeito colateral e não deveriam consumir orçamento de mutation — decisão final depende do runner. (aag-blast-radius-containment: capability nova inicia com blast radius conservador e expande com track record.)"
	}

	// =============================================
	// DRIFT DETECTION
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-qualification-completion-rate"
			name:        "Taxa de Conclusão de Qualificação"
			description: "Percentual de participantes que completam transição pending→qualified sem abandono, timeout ou cancelamento prematuro."
			baseline:    "> 70% dos participantes completam qualificação"
			threshold:   "< 50% de conclusão"
			rationale:   "Taxa abaixo de 50% sugere que o processo de qualificação tem fricção excessiva — requisitos de KYC/AML possivelmente desproporcionais, ou IDC com latência alta no retorno de verificação de identidade. Em onboarding, threshold conservador — será calibrado com dados reais. (aag-drift-detection: métrica de saúde do domínio, não apenas do agente.)"
		}, {
			code:        "dm-escalation-response-latency"
			name:        "Latência de Resposta a Escalações"
			description: "p95 do tempo entre escalação e resposta do founder."
			baseline:    "< 12h para async-queue, < 4h para sync-human-review e alert-and-block"
			threshold:   "> 24h para qualquer canal"
			rationale:   "Se escalações consistentemente atingem o limite de SLA, o founder pode estar sobrecarregado ou o canal subdimensionado. No NPM especificamente, escalação não resolvida retém participante em estado não-terminal — participante em pending não opera em nenhum BC downstream, e participante em qualified com escalação pendente pode ter operações em curso afetadas. Drift aqui indica que o agente opera em incerteza prolongada com impacto cross-context. (aag-drift-detection: baseline + threshold por canal.)"
		}, {
			code:        "dm-blast-radius-utilization"
			name:        "Utilização de Capacidade de Blast Radius"
			description: "Percentual médio de utilização do maxDailyActions."
			baseline:    "< 60% de utilização média"
			threshold:   "> 90% de utilização média em janela de avaliação"
			rationale:   "Utilização consistente acima de 90% indica que o cap está subdimensionado para a demanda real, forçando o agente a priorizar ou adiar ações — participantes podem ficar retidos em filas. Pode justificar promoção de caps ou revisão de lifecycle stage. (aag-drift-detection: cap como indicador de dimensionamento, não apenas contenção.)"
		}]
		rationale: "Três métricas cobrem saúde do domínio (conclusão de qualificação), latência de supervisão (resposta a escalações) e dimensionamento operacional (utilização de caps). Cadência semanal adequada para onboarding — volume baixo, cada semana acumula amostra suficiente. (aag-drift-detection: drift é silencioso — detecção ativa é o mecanismo.)"
	}

	// =============================================
	// CALIBRATION
	// =============================================

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation"
			metric:                   "≥ 10 qualificações concluídas com zero violação de invariante e taxa de aprovação de recomendações ≥ 95% (supervisor aprova o que agente propôs em ações propose-and-wait)"
			minimumObservationPeriod: "30 days"
			rationale:                "10 qualificações é volume mínimo para padrão significativo em rede nascente — cada qualificação exercita ciclo completo pending→qualified. 30 dias garante exposição a variação temporal. Taxa de 95% mede alinhamento entre julgamento do agente e do supervisor. (aag-agent-capability-lifecycle: onboarding → validation com critérios ex ante.)"
		}, {
			description:              "Promoção de validation para operational"
			metric:                   "≥ 40 qualificações concluídas, zero violação de invariante, taxa de aprovação ≥ 98%, zero drift detectado acima de threshold por 4 semanas consecutivas, audit trail verificável com reconstrução completa de decisão em amostra de 5 operações — inputs, decisão, rationale e outcome recuperáveis sem informação externa ao trail"
			minimumObservationPeriod: "60 days"
			rationale:                "NPM é gateway da rede — participante não qualificado não opera em nenhum BC. Promoção prematura amplifica risco para toda a malha downstream. Critérios mais exigentes que onboarding→validation: volume maior, aprovação mais alta, drift estável, audit trail testado com reconstrução explícita. (aag-hitl-calibration: supervisão proporcional à maturidade e consequência.)"
		}]
		regressionTriggers: [{
			description:     "Violação de autonomy boundary"
			metric:          "Qualquer ação executada fora do autonomyLevel declarado no agent-spec ou override no envelope"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de boundary é evento de severidade máxima — indica falha no modelo de contenção, não apenas no comportamento pontual. suspend-and-escalate porque o agente não pode operar enquanto a causa raiz não for identificada. (aag-autonomy-boundary: violação é falha estrutural.)"
		}, {
			description:     "Drift sustentado em qualquer métrica"
			metric:          "Qualquer métrica de driftDetection acima do threshold"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Drift sustentado indica desalinhamento estrutural entre o envelope e a operação real — promoção nesse estado amplificaria o problema. Redução de autonomia força revisão mais intensiva enquanto causa é investigada. (aag-drift-detection: detecção precoce + ação proporcional.)"
		}, {
			description:     "Breach de blast radius"
			metric:          "maxConcurrentMutations ou maxDailyActions excedido"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach de blast radius é contenção prioritária. Redução de autonomia cria margem de segurança enquanto a causa raiz é investigada. (aag-blast-radius-containment: breach indica subdimensionamento ou comportamento anômalo.)"
		}]
		rationale: "Promoção em dois estágios com critérios proporcionais ao papel de gateway do NPM na rede. Regressão com tolerância zero para violação de autonomy boundary (suspend-and-escalate), detecção precoce para drift sustentado (2 semanas, reduce-autonomy), e contenção imediata para breach de blast radius. Calibração conservadora para BC core em fase pré-PMF."
	}

	rationale: "NPM é gateway da rede Mesh — nenhum participante opera sem qualificação NPM. Decisões do agente (qualificar, suspender, terminar) propagam para todos os BCs downstream que consomem status de participante (CTR, SSC, e indiretamente BDG, TCM, DRC via contratos). Envelope calibrado para onboarding: blast radius conservador (3 concurrent, 50 daily), escalation routing completo para as 4 categorias do agent-spec (async-queue para out-of-scope, sync-human-review para ambiguous-case e conflicting-signals, alert-and-block para insufficient-context), drift detection semanal com 3 métricas cobrindo saúde de qualificação, latência de supervisão e utilização de capacidade. Calibração: promoção com critérios mensuráveis (10 qualificações/30d para validation, 40 qualificações/60d para operational), regressão com tolerância zero para violação de boundary. Lenses: aag (primária: autonomia, escalation, blast radius, lifecycle, calibração, drift), sti (secundária: caps conservadores), rc (terciária: compliance rastreável)."
}
