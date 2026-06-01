package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr136: build_time.#SelfReviewReport & {
	reportId: "srr-adr-136-modeling-health-dashboard"

	artifactPath:       "architecture/adrs/adr-136-modeling-health-dashboard.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-01"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-136 (painel de saúde de modelagem materializado como
			tooling resolve def-034, status-A). NOTA: rollout prescreve
			isolated-subagent para adr; aqui self-reported (manual takeover).
			Avaliado contra 8 universalCriteria + tq-adr + uq-09.

			uq-01 (WHY): rationale explica por que P0/P8/P12 aplicam e por que
			resolver AGORA (a razão operante do deferimento — fontes inexistentes —
			caiu: campo falsificationCondition via adr-132 + check sc-ccf-03 via
			adr-133 existem). Não descreve o que o painel faz. Pass.
			uq-02 (Mesh): o painel mede artefatos específicos da Mesh — canvases de
			BC, ADRs com falsificationCondition, cross-context-flows (closure),
			cobertura de agent-probe. Trocar 'Mesh' por 'qualquer fintech' falha:
			são os artefatos de governança desta spec. Pass.
			uq-03 (refs): adr-132, adr-133, def-031/032/034, sc-ccf-03, sc-apr-02
			existem; modeling-health.sh criado no mesmo commit; def-034 existe.
			NÃO afirma que def-031/032 estão 'resolved' (verificado: ambos open) —
			afirma só que as FONTES (campo + check) existem. Pass.
			uq-04 (princípios): P0 (painel parseia o runner, não reimplementa a
			regra — sem 2ª fonte), P8 (projeção reconstruível, nunca SoT), P12
			(observabilidade como código). Sem contradição com design-principles. Pass.
			uq-05 (limitações): N1 (métrica 2 = presença, não acionada), N2
			(volatility é proxy grosso), N3 (parse depende do formato do runner) —
			todas declaradas. Pass.
			uq-06 (ubiquitous language): termos estáveis (painel, fronteira-volatility,
			flows verdes, cobertura probe, falsificação declarada). Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #ADR): decisionClass/decider/status/reversibility/
			blastRadius/falsificationCondition{condition,observableSignal}/
			affectedArtifacts(2)/principlesApplied(P0,P8,P12)/supersedes presentes;
			cue vet EXIT=0. Pass.
			uq-09 (section gates): N/A — adr está em rollout mode isolated-subagent,
			não manual; manualAuthoringProtocol não aplica. Não-finding.
			tq-adr-01 (alternativas): context avalia (a) manter def-034 aberto até
			detecção de falsificação acionada [rejeitada — ata o instrumento inteiro
			a uma sub-métrica] vs (b) materializar como tooling [escolhida]. Pass.
			tq-adr-02 (metadata de risco): reversibility high (tooling deletável + DD
			reabrível); blastRadius cross-cutting (o painel observa sinais de TODOS
			os contexts/ADRs/flows — escopo cross-cutting, coerente com a própria
			costOfDeferral.blastRadius de def-034). Não-genérico. Pass.
			tq-adr-03 (paths reais): scripts/ci/modeling-health.sh criado no mesmo
			commit; def-034 path existe. Pass.
			tq-adr-04 (rastreabilidade ≥1): affectedArtifacts non-empty (2 entries). Pass.
			"""
	}]

	findings: {}

	summary: """
		adr-136 fecha def-034 (Camada 3 de feedback) materializando o painel de
		saúde de modelagem como tooling (scripts/ci/modeling-health.sh, reporter
		read-only fora de workflow, exit 0). Resolve por status-A: a razão operante
		do deferimento (fontes de dados inexistentes) caiu — o campo
		falsificationCondition (adr-132) e o check sc-ccf-03 (adr-133) existem agora,
		e a fronteira-volatility sempre teve fonte (git). O painel é observabilidade
		(P8: projeção reconstruível, nunca SoT) que DERIVA do structural-check-runner
		(P0: parseia sc-ccf-03/sc-apr-02, não reimplementa a regra). Residual
		declarado: métrica 2 mede presença, não falsificação acionada (N1). Estável
		em 1 round.
		"""

	singleRoundRationale: """
		Decisão derivada de pré-flight verificado nesta sessão (7 ADRs com
		falsificationCondition; sc-ccf-03 e sc-apr-02 produzindo violações
		parseáveis no runner; 11 DDs resolved → 12). O ADR registra um fato
		estrutural verificável por inspeção direta (as fontes existem) + uma escolha
		de fechamento (status-A) com alternativa explícita avaliada. Sem ambiguidade
		pendente: as 4 métricas têm fonte verificada e o residual (N1) está
		registrado, não escondido.
		"""
}
