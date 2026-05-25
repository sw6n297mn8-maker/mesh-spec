package architecture

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// agent-governance.cue — Instância singleton da governança GLOBAL de agentes.
//
// Per adr-037 (dois níveis) + adr-090 (este global era o singleton ausente que
// 11 envelopes já referenciavam por governanceGlobalVersion). Conforma a
// artifact_schemas.#AgentGovernanceGlobal.
//
// Campos AMARRADOS pelos 11 envelopes existentes (reconciliação, não escolha):
//   - version "0.1": todos os 11 envelopes declaram governanceGlobalVersion "0.1".
//   - blastRadiusPolicy >= teto observado: maxConcurrentMutations 5 (cmt) e
//     maxDailyActions 100 (dlv) — nenhum cap de envelope pode exceder o global.
//   - lifecycleStages cobre os 4 stages do enum (só "onboarding" em uso hoje).
//
// Campos de POLÍTICA NOVA (decisão do founder, postura conservadora P10):
//   defaultAutonomyLevel, definições de cada stage, escalationDefaults,
//   driftDetectionPolicy, auditPolicy.

agentGovernance: artifact_schemas.#AgentGovernanceGlobal & {
	version: "0.1"

	// Default conservador (P10: agente recomenda, humano aprova). Ações sem
	// override no envelope herdam este nível.
	defaultAutonomyLevel: "propose-and-wait"

	lifecycleStages: [
		{
			stage:           "onboarding"
			description:     "Agente novo, sob observação intensiva. Autonomia mínima até acumular track record."
			entryConditions: "Agente recém-criado ou após regressão. Envelope ativo e agent-spec válido."
			allowedAutonomyLevels: ["no-autonomous-action", "collect-and-report"]
			rationale: "Início conservador: o agente coleta e reporta; humano decide. Sem propor nem executar até validação."
		},
		{
			stage:           "validation"
			description:     "Agente em validação com dados reais; pode propor, humano aprova."
			entryConditions: "Período mínimo de observação em onboarding cumprido com métricas de drift dentro do baseline."
			allowedAutonomyLevels: ["no-autonomous-action", "collect-and-report", "propose-and-wait"]
			rationale: "Habilita propose-and-wait: o agente passa a recomendar, mas execução continua gated por humano."
		},
		{
			stage:           "operational"
			description:     "Agente operando com autonomia calibrada; propose-and-wait como teto padrão."
			entryConditions: "Track record consistente em validation; reversões humanas abaixo do threshold."
			allowedAutonomyLevels: ["no-autonomous-action", "collect-and-report", "propose-and-wait"]
			rationale: "Mantém propose-and-wait como teto: execute-and-log fica reservado a mature, e nunca a mutations (tq-gv-14)."
		},
		{
			stage:           "mature"
			description:     "Agente com track record comprovado; autonomia máxima permitida (execute-and-log para ações não-mutation)."
			entryConditions: "Período prolongado em operational sem regressão; auditoria comprova confiabilidade."
			allowedAutonomyLevels: ["no-autonomous-action", "collect-and-report", "propose-and-wait", "execute-and-log"]
			rationale: "execute-and-log admitido APENAS como teto global neste stage; P10 mantido: mutations críticas permanecem gated pelo envelope local + constraints, e tq-gv-14 proíbe execute-and-log em mutations independentemente do stage. O teto não concede autonomia — apenas a permite quando envelope local e constraints autorizarem."
		},
	]

	escalationDefaults: {
		fallbackChannel:        "alert-and-block"
		fallbackSlaDescription: "Resposta humana em até 1 dia útil; operação bloqueada até resolução."
		fallbackRecipient:      "Owner do BC (CODEOWNERS); founder como fallback final."
		rationale:              "Fallback conservador pré-PMF: qualquer escalation sem routing específico no envelope bloqueia e alerta, garantindo que nenhuma escalation fica sem destino (tq-gv-02)."
	}

	driftDetectionPolicy: {
		evaluationCadence: "weekly"
		defaultMetrics: [
			{
				code:        "dm-escalation-rate"
				name:        "Taxa de escalation"
				description: "Proporção de ações do agente que terminam em escalation, sobre janela móvel."
				baseline:    "<= 20% das ações em 7 dias"
				threshold:   "> 40% das ações em 7 dias"
				rationale:   "Escalation rate crescente indica que o agente está fora de calibração para o escopo atual."
			},
			{
				code:        "dm-human-reversal-rate"
				name:        "Taxa de reversão humana"
				description: "Proporção de recomendações do agente revertidas/rejeitadas por humano no gate."
				baseline:    "<= 5% das recomendações em 7 dias"
				threshold:   "> 15% das recomendações em 7 dias"
				rationale:   "Reversão humana alta indica drift entre o que o agente propõe e o que o gate aceita — sinal de regressão."
			},
		]
		rationale: "Duas métricas mensuráveis (baseline + threshold comparáveis) cobrindo calibração (escalation) e qualidade de recomendação (reversão); avaliação semanal pré-PMF. Estes valores são GLOBAL DEFAULTS (baseline inicial), NÃO verdade operacional por BC: cada envelope refina baselines/thresholds via seu driftDetection local conforme o perfil de risco do agente."
	}

	blastRadiusPolicy: {
		maxConcurrentMutations: 5
		maxDailyActions:        100
		rationale:              "Teto do sistema = maior cap declarado entre os 11 envelopes (cmt: 5 concurrent; dlv: 100 daily), para que nenhum envelope viole tq-gv-09. daily >= concurrent (tq-gv-04). Limites conservadores pré-PMF; revisáveis por ADR quando o volume crescer."
	}

	auditPolicy: {
		retentionPeriod:     "10 years"
		externalAuditAccess: true
		rationale:           "Intermediário financeiro regulado: retenção longa + acesso a auditores externos para reconstituição completa de decisões de agente (complementa auditTrail do agent-spec)."
	}

	rationale: """
		Governança global de agentes (adr-037), materializada como o singleton que
		11 envelopes já referenciavam. Campos amarrados pela reconciliação dos
		envelopes (version 0.1; blastRadiusPolicy >= 5/100; taxonomia dos 4 stages);
		demais campos são política conservadora P10 (default propose-and-wait;
		execute-and-log só em mature e nunca em mutations; fallback alert-and-block;
		drift semanal; retenção 10 anos). Postura pré-PMF, revisável por ADR.

		Semântica do ladder: cada stage define o TETO global de autonomia; o
		envelope local pode ser MAIS restritivo, nunca mais permissivo. Os global
		defaults (drift, blast radius, escalation) são piso/teto de sistema, não
		verdade operacional por BC — cada envelope refina dentro desses limites.
		"""
}
