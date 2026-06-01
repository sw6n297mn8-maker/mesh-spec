package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def034: artifact_schemas.#DeferredDecision & {
	id:     "def-034"
	title:  "Painel de saúde de modelagem — 3 métricas North-Star de build-time (Camada 3 de feedback, cadência semanal)"
	date:   "2026-05-30"
	status: "resolved"

	// Resolvido por adr-136 (status-A): a razão OPERANTE do deferimento — as fontes
	// de dados não existiam — caiu. O campo falsificationCondition (adr-132) e o
	// check sc-ccf-03 (adr-133) existem agora; fronteira-volatility sempre teve
	// fonte (git). O painel foi materializado como tooling (scripts/ci/modeling-
	// health.sh, reporter read-only fora de workflow) reportando 4 métricas —
	// falsificação medida como PRESENÇA, não acionada (residual em adr-136 N1).
	// def-031/def-032 seguem OPEN (trabalho de GATE); o painel consome o que eles
	// já materializaram, não os fecha.
	resolvedBy: "architecture/adrs/adr-136-modeling-health-dashboard.cue"

	description: """
		Estender dd-status.sh (ou script irmão) para reportar as 3 métricas de
		saúde de modelagem de build-time, para revisão founder de cadência
		semanal: (1) fronteira-volatility — quantos BCs mudaram de fronteira na
		semana (alta volatilidade indica domínio ainda não compreendido, via git
		log sobre contexts/*/canvas.cue + context-map); (2) ADRs com
		falsificationCondition acionada (depende de def-032 — o campo precisa
		existir); (3) fluxos de evento ponta-a-ponta verdes (depende de def-031 —
		o check de closure precisa existir). A métrica (3) é a North-Star de
		build-time: o equivalente-spec do volume financeiro sob governança. O
		painel substitui vigilância contínua por um instrumento de revisão
		periódica — desenho certo para o perfil do founder (gatilho externo, não
		atenção sustentada).
		"""

	deferralRationale: """
		HORIZONTE DE RESOLUÇÃO: diferido — depende DIRETAMENTE de def-031 (flow
		oracle) E def-032 (falsificationCondition) estarem resolvidos. Não é
		adiamento por prioridade, é dependência dura: 2 das 3 métricas não têm o
		que medir até os campos/checks subjacentes existirem (métrica 2 precisa
		do campo falsificationCondition de def-032; métrica 3 precisa do check
		de closure de def-031). Materializar antes produziria um painel com 1
		métrica real (fronteira-volatility, via git) e 2 colunas vazias.

		MOTIVO de deferir: dependência técnica explícita, não procrastinação. A
		métrica 1 (volatility) poderia ser feita já, mas um painel parcial
		fragmenta o instrumento de revisão semanal — melhor entregar as 3 juntas
		quando 031+032 fecharem. Custo evitado: painel zumbi com colunas vazias
		que treina o founder a ignorá-lo. Custo de continuar: sem o painel, a
		cadência semanal de saúde de modelagem não tem instrumento — mas as
		camadas 1 (CI gate) e 2 (ADR/DD) cobrem o curto e médio prazo
		enquanto isso, então o custo é contido.
		"""

	triggerCalibrationRationale: """
		Trigger primário adjacent-need file-exists sobre o script de saúde
		(scripts/ci/modeling-health.sh) é circular — em vez disso, uso
		file-contains sobre o schema #ADR procurando o campo falsificationCondition
		(materializado por def-032): quando o campo existir, a métrica 2 fica
		viável e o painel passa a ter base. É o proxy machine-evaluable de
		'def-032 resolvido'. Dependência de def-031 (métrica 3) é registrada em
		prose aqui e no grafo de dependência — o runner dispara no sinal de
		def-032 (o mais fácil de detectar via file-contains), e o founder
		verifica def-031 na revisita. Backstop manual-review para o founder
		reavaliar se o painel ainda é o instrumento certo quando os dois
		precedentes fecharem.
		"""

	originatingArtifacts: [
		"session:feedback-cycles-audit",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			Sem o painel, não há instrumento para a cadência semanal de revisão
			de saúde de modelagem (volatility de fronteira, falsificações
			acionadas, flows verdes). medium porque as camadas 1 (CI) e 2
			(ADR/DD) cobrem curto e médio prazo enquanto o painel não existe, e o
			painel depende de 031+032; cross-cutting porque agrega sinais de todo
			o repositório de modelagem.
			"""
	}

	triggers: [{
		kind:      "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "architecture/artifact-schemas/adr.cue"
			pattern: "falsificationCondition"
		}
	}, {
		kind:   "manual-review"
		reason: """
			Painel depende de def-031 (flow oracle) E def-032 (falsification)
			resolvidos; o founder reavalia na revisita se o painel ainda é o
			instrumento certo e se as 3 métricas têm base de dados. Dependência
			dura entre DDs não é totalmente machine-evaluable num único trigger.
			"""
	}]
}
