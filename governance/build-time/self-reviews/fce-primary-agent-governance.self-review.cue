package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fcePrimaryAgentGovernance: build_time.#SelfReviewReport & {
	reportId: "srr-fce-primary-agent-governance"

	artifactPath:       "contexts/fce/agents/fce-primary-agent.governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-governance.cue"
	artifactType:       "agent-governance"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-19"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Envelope #AgentGovernanceEnvelope do agt-fce-primary (FCE — gate que MOVE DINHEIRO, P11 nível-1) em lifecycleStage onboarding, par do agent-spec fce-primary-agent.cue per ADR-037 e ratificação adr-155. Revisão isolada cold-read contra tq-gv-06..15 (schema) + tq-gvg-01..11 (production-guide agent-governance.cue) + 5 ataques adversariais. ZERO fail, ZERO warn.

			ATAQUE A (DENTE 2 — exclusão do override do promotionCriteria): DEFENDIDO por DECLARAÇÃO, não por ausência. O override act-resolve-guard-escalation é excluído explicitamente em 5 lugares: (1) comentário do bloco calibration ('A exclusão é declarada, não mera ausência: um leitor futuro NÃO deve adicionar o override ao promotionCriteria'); (2) promotionCriteria[0].description ('O override act-resolve-guard-escalation NÃO é elegível (teto permanente)'); (3) promotionCriteria[0].metric ('act-resolve-guard-escalation permanece propose-and-wait independentemente desta métrica'); (4) promotionCriteria[1].description+metric ('continua excluído (teto permanente)'); (5) calibration.rationale + rationale top-level ('PERMANENTEMENTE EXCLUÍDO... nenhum volume, janela ou métrica o promove; um leitor futuro NÃO deve adicioná-lo aqui'). Construção de caminho de promoção: a única máquina que eleva autonomia é promotionCriteria, cujos dois critérios escopam exaustivamente 'APENAS as 3 mutations autônomas promovíveis' (act-execute-prepayment-guard, act-dispatch-payment-instruction, act-settle-payment) e nomeiam o override como inelegível. O campo autonomyOverrides está AUSENTE (verificado por grep — só aparece em rationale como 'SEM autonomyOverrides'), portanto tq-gv-14 é satisfeito vacuamente e não há backdoor de execute-and-log. Nenhum caminho da calibration alcança execute-and-log para o override; alinhado com cst-override-never-autonomous + cst-override-requires-human-attribution do spec.

			ATAQUE B (freeze-routing do breach): DEFENDIDO pelos 3 elementos exigidos. (i) O breach p11-invariant-breach-detected é carregado pela category unclassifiable-anomaly → routeia para channel CONTENEDOR alert-and-block ('Freeze IMEDIATO do pipeline de dispatch autônomo; containment precede diagnosis, ADR-079'). (ii) Drift metric dm-p11-breach-rate com baseline '0 breaches' e threshold '≥ 1 breach em qualquer janela — zero-tolerance, não há banda de drift tolerada' — zero-tolerance genuíno. (iii) Regression trigger 'Breach de P11 detectado' com metric dm-p11-breach-rate ≥ 1, threshold '1 ocorrência', immediateAction suspend-and-escalate — gatilho suspensivo com binding 1:1. Piso fechado em 3 camadas: garantido-no-domínio (handler exige as 3 condições, cst-breach-bypasses-escalation) + roteado-no-envelope (alert-and-block) + monitorado-aqui (breach-rate=0 zero-tolerance) + suspende-aqui (suspend-and-escalate). É a (ii) do rtd-018, com o freeze de domain-state (PaymentSlice) reconhecido como T2 separada no mesh-runtime.

			ATAQUE C (caps + failureHandling para gate de dinheiro): COERENTE. blastRadiusCaps 1/30 — maxConcurrentMutations=1 SERIALIZA o caminho de movimento de valor (postura maximamente conservadora), maxDailyActions=30; ambos ≤ teto global (5/100, verificado em architecture/agent-governance.cue blastRadiusPolicy → tq-gv-09 PASS); 1/30 dentro da faixa onboarding canônica 1-2/20-50 no lower-end (tq-gvg-07 PASS); daily(30) ≥ concurrent(1) sanity. Mais conservador que BDG (2/50, verificado) e IDC (2/40, verificado) — apropriado ao único gate que efetivamente move dinheiro. failureHandling fail-safe nos 3 eventos: onAgentError → suspend-and-escalate; onTimeout → suspend-and-escalate com retryPolicy aplicável SOMENTE a queries de input/projeção (REW/INV/prj-payment-status) e SEM retry para o gate determinístico ou EvidencePort ('fail-safe é parar de mover dinheiro, não degradar a verificação, dp-04'); onRepeatedFailure → suspend-and-escalate (3/24h). Nenhum modo de falha mantém movimento de dinheiro sob erro/timeout (per #FailureHandling, adr-058; tq-gvg-08 PASS).

			ATAQUE D (pareamento bidirecional + control-plane): DEFENDIDO. tq-gv-06: envelope.agentRef 'agt-fce-primary' == spec.code 'agt-fce-primary'; spec.governanceRef 'fce-primary-agent' == base name do arquivo (fce-primary-agent.governance.cue) — ambos verificados lendo os dois arquivos. tq-ag-09: o governanceRef do spec resolve para este envelope, que existe. tq-gv-15: scan de contexts/fce/agents/ confirma exatamente 1 .governance.cue (uniqueness intacta). tq-gvg-09 control-plane: o envelope contém APENAS escalationRouting + blastRadiusCaps + driftDetection + calibration + lifecycleStage + failureHandling; nenhuma business logic vazada — PrePaymentGuard, as 7 invariantes, atribuição de override e detecção de breach vivem em agent-spec.constraints + domain-model. As drift metrics MEDEM outcomes de domínio agregados (dm-p11-breach-rate, dm-double-pay-rate, dm-guard-consistency) sem DECIDIR domínio individual — exatamente o que tq-gvg-09 permite.

			ATAQUE E (higiene de process-allusion): LIMPO. Scan por fatia/slice/seção/section/checkpoint/WIP/red-team/round/disp-NN/B2/estágio 2/oq-fce/claim parcial/WI-04/frente seguinte retornou ZERO leaks no artefato. 'Promoção em 2 estágios' (linhas 160/218) refere-se à estrutura do ladder de calibration (onboarding→validation→operational), conceito de domínio do envelope, NÃO ao workflow de autoria.

			Demais critérios: tq-gv-07/tq-gvg-02 (as 6 categories de agent-spec.escalationConditions — conflicting-signals/insufficient-context/ambiguous-case/out-of-scope/suspicious-input/unclassifiable-anomaly — têm escalationRouting correspondente); tq-gv-08 (lifecycleStage 'onboarding' na taxonomia #LifecycleStage); tq-gv-10/tq-gvg-03 (promotionCriteria mensuráveis e time-bounded: ≥25 Payments/60d, ≥80 Payments/90d; regressionTriggers com immediateAction enum + tolerance-zero nos 4 controls); tq-gv-11/tq-gv-13 (autonomyOverrides ausentes — vacuamente satisfeitos); tq-gv-12 (governanceGlobalVersion '0.1' == version '0.1' do global materializado — PASS, não mais warn); tq-gvg-05 (routing precedence declarada: blocking > non-blocking; mutation-related > informational; explicit > fallback); tq-gvg-06 (bindings drift→action: 3 controls → suspend-and-escalate; override/escalada sustentados e cap > 90% → reduce-autonomy); tq-gvg-10 (FAIL no PG — block scope explícito: as 3 rotas alert-and-block declaram escopo: insufficient-context 'dispatch autônomo bloqueado', suspicious-input 'tupla afetada pausada', unclassifiable-anomaly 'freeze do pipeline de dispatch autônomo' agent-wide justificado por severity tier nível-1). cue vet recursivo deixado para validação autoritativa do dispatcher (baseline pré-existente de colisão de schema #Policy não-relacionado).
			"""
	}]

	findings: {}

	summary: "Envelope de governança do agt-fce-primary (FCE — gate que move dinheiro, P11 nível-1) em onboarding, par do agent-spec via ADR-037/adr-155. Revisão isolada cold-read: ZERO fail / ZERO warn / ZERO info contra tq-gv-06..15 + tq-gvg-01..11 + 5 ataques. DENTE 2 (exclusão do override act-resolve-guard-escalation do promotionCriteria) é DECLARADO em 5 lugares + autonomyOverrides ausente — nenhum caminho de calibration o promove a execute-and-log (tq-gv-14). Freeze-routing do breach fechada: unclassifiable-anomaly → alert-and-block + dm-p11-breach-rate zero-tolerance + regression trigger suspend-and-escalate (rtd-018 ii). Caps 1/30 conservadores ≤ teto global 5/100; failureHandling fail-safe nos 3 eventos. Bidirectional ref e control-plane separation OK."

	singleRoundRationale: "Round único suficiente: revisão isolada adversarial não encontrou nenhum fail nem warn. Os 5 ataques (DENTE 2, freeze-routing do breach, caps/failureHandling do gate de dinheiro, pareamento bidirecional, process-allusion) resolveram todos a favor do artefato com âncoras concretas verificadas (exclusão do override declarada em 5 lugares + autonomyOverrides ausente; dm-p11-breach-rate zero-tolerance + suspend-and-escalate; caps 1/30 ≤ global 5/100; agentRef/governanceRef recíprocos). Claims factuais cross-file verificados por Read direto (global agent-governance.cue version 0.1 e blastRadiusPolicy 5/100; BDG 2/50; IDC 2/40; uniqueness do diretório). Sem findings a corrigir, não há segundo round a executar — estabilização imediata, não bypass."
}
