package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr175AgentModelCoverageGate: build_time.#SelfReviewReport & {
	reportId: "srr-adr-175-agent-model-coverage-gate"

	artifactPath:       "architecture/adrs/adr-175-agent-model-coverage-gate.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-13"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 4
		infoCount: 5
		summary: """
			Round 1 — review por SUB-AGENTE ISOLADO (rollout adr →
			isolated-subagent), sem o histórico da sessão de autoria, sobre o
			adr-175 completo + o bundle materializado (schema/runner/check/PG),
			com verificação contra o disco. Núcleo factual PASS em grau raro —
			TODAS as alegações mecânicas bateram exatamente: kind nos 3 pontos
			do schema (enum/união discriminada/union de rules), evaluator +
			entry EVAL, fixture com os 5 casos e self-test PASS, 6ª família +
			scopeExclusions com as duas formas no #AgentSpec, sc-ag-02 warn
			(não reject) com as 6 famílias, sc-ag-01 com domainServices, elo
			duplo no PG (critério E passo), baseline 61 com decomposição por
			BC idêntica ao runner real (bdg 3, cmt 2, p2p 16, rew 35, ssc 5),
			0 bloqueantes novos confirmado por diff contra HEAD, e até os
			números incidentais ('113 vo-', '7 dos 12 BCs') exatos. Metadata
			de risco espelha o precedente adr-113; alternativas genuínas
			(tq-adr-01); principlesApplied load-bearing.

			4 FINDINGS WARN, concentrados num padrão — a fatia não aplicou a
			si mesma toda a disciplina de coevolução que institui: F1
			comentário do #AgentAction.domainModelRefs no agent-spec.cue ainda
			listava svc- entre os prefixos 'não representados em
			operationalScope' — contradição same-artifact introduzida pela
			própria fatia; F2 o PG agent-spec (architecture/production-guides/
			agent-spec.cue) ensina a doutrina antiga (5 famílias, svc- por
			'scope próprio') e não menciona scopeExclusions — não coevoluído e
			ausente da rastreabilidade do ADR; F3 o deferimento da
			estruturação de campos de ator/enforcement está em prosa, sem
			def-XXX/defersTo (adr-062 SHOULD para ADRs pós-adr-062); F4
			exclusões dangling não são validadas por gate nenhum (sc-ag-01
			não inclui os paths de scopeExclusions; o evaluator de cobertura
			só une exclusões ao conjunto coberto) — typo ou exclusão órfã
			sobrevive silenciosamente, limitação não declarada. 5 INFO:
			F5 backfill wi-151 identificado sem artefato de registro; F6
			tq-ag-01 test lista só 4 famílias (staleness pré-existente,
			agravada); F7 branch escopo-fantasma do evaluator novo sem caso
			na fixture; F8 bootstrap-policy (quitação transient do PG) fora
			da rastreabilidade do ADR (precedente adr-173 tratou como chore);
			F9 uq-09 não avaliável em isolamento (evidência de section gates
			pertence à sessão de autoria).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 3
		infoCount: 5
		summary: """
			Round 2 — tratamento proporcional ao regime gated: F1 CORRIGIDO
			(comentário do #AgentAction atualizado — svc- movido para os
			prefixos de operationalScope, nota 'ganhou família própria per
			adr-175'; correção editorial de consistência da mudança já
			aprovada, mostrada no checkpoint). F2, F3 e F4 NÃO são corrigíveis
			pelo agente sem decisão do founder — F2 estende a fatia a arquivo
			fora do escopo aprovado (PG agent-spec; opções: coevoluir nesta
			fatia / empurrar para a higiene A com menção no WI-154 / justificar
			não-edição no ADR), F3 cria artefato de governança novo (def-XXX
			com G2 assert; opções: def agora / prosa mantida com justificativa),
			F4 é decisão de desenho nomeada pelo próprio reviewer como do
			founder (adicionar os paths de scopeExclusions ao sc-ag-01
			resolveria mecanicamente; alternativa: declarar a limitação no
			ADR). Os 3 permanecem DECLARADOS em findings.warn per
			severityPolicy.warn (residual visível, nunca silenciado) e
			apresentados como decisões no checkpoint da proposta. F5-F9 info
			registrados no round 1; F6/F7 são candidatos naturais às fatias de
			higiene se o founder confirmar.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 3 — o founder decidiu os 3 residuais (F2/F3/F4 → todos
			recomendação (a)) e a rodada os aplicou: F2 RESOLVIDO — PG
			agent-spec coevoluído pelo padrão do elo duplo (tq-agg-11 +
			passo de cobertura-vs-exclusão no process + heuristics com a
			doutrina 6-famílias/scopeExclusions + finalValidation com o
			passo do sc-ag-02; SRR próprio srr-agent-spec-pg-adr-175-
			coevolution); F3 RESOLVIDO — def-080 criado (G2 re-derivado:
			def-080 próximo-livre; enums conferidos contra o schema:
			medium/cross-artifact; trigger manual-review com tq-def-03
			declarado; SRR próprio) e o adr-175 ganhou defersTo:["def-080"]
			+ def-080 em plannedOutputs + prosa da decisão 3/consequences
			apontando o def em vez de deferir só em prosa; F4 RESOLVIDO —
			sc-ag-01 estendido com scopeExclusions[].ref e
			scopeExclusions[].refs[] em referencePaths (dangling é violação;
			runner inalterado 92/0 — zero falso-positivo). findings.warn
			esvaziado: nenhum residual permanece. F5-F9 (info) seguem
			registrados no round 1 como candidatos de higiene.
			"""
	}]

	findings: {}

	summary: """
		adr-175 (accepted, BUNDLE kind-ADR per precedente adr-153) institui o
		gate de cobertura agente↔modelo: kind instance-scoped-cross-file-
		coverage (direção inversa do adr-113), 6 famílias (+svc-),
		scopeExclusions por id e por classe com critério de legitimidade,
		sc-ag-02 born-warn anunciando baseline 61, elo duplo no PG
		domain-model, higienes WI-154/155, defersTo def-080. Review isolado:
		0 fail; núcleo factual integralmente confirmado contra o disco. 4
		warns num único padrão (a fatia não aplicou a si mesma toda a
		coevolução que institui): F1 corrigido no round 2; F2/F3/F4
		apresentados como decisões ao founder no checkpoint e RESOLVIDOS no
		round 3 após decisão (a)/(a)/(a) — PG agent-spec coevoluído (elo
		duplo + tq-agg-11), def-080 criado com defersTo no ADR, sc-ag-01
		validando exclusões dangling. VEREDITO: stable, 0 fail, zero warn
		residual.
		"""
}
