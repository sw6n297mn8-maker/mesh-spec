package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do adr-162 (vigilância de deferred-decisions: gate de carência instalado-
// mas-desligado + briefing de abertura; filho de adr-062). Self-review em
// subagente ISOLADO (quality-gate rollout adr→isolated-subagent; sem o histórico
// da conversa). 1 round, stable. 1 warn (structure-index stale) CORRIGIDO antes
// da proposta (regen).

adr162Vigilance: build_time.#SelfReviewReport & {
	reportId: "srr-adr-162-deferred-decision-vigilance-grace-gate"

	artifactPath:       "architecture/adrs/adr-162-deferred-decision-vigilance-grace-gate.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-28"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do adr-162 + def-070 + a emenda do script/config, em SUBAGENTE
			ISOLADO (sem histórico da conversa) contra #ADR + PG-ADR + #DeferredDecision +
			universalCriteria, com verificação factual via Read/filesystem. cue vet ./... EXIT=0.

			[#ADR conformance / tq-adr-01..04]: PASS. enums válidos (structural/founder/proposed →
			supersededBy omitido; medium/cross-cutting; date ISO; id adr-162 próximo livre). 3
			alternativas substantivas no context (keep-advisory rejeitada pela experiência dos 8
			defs apodrecidos; gate-imediato rejeitado por tirania; grace-gate escolhida). risk
			metadata coerente e justificada no rationale. paths reais.

			[parentesco adr-062]: PASS. adr-062 segue accepted (não tocado); adr-162.supersedes
			ausente (NÃO lista adr-062); framing evolução-pela-experiência coerente ("NÃO é 'o
			adr-062 estava errado'"); invariante de não-mutação preservada (relógio git-derivado,
			sem firedAt no schema).

			[coerência interna gate instalado-mas-OFF]: PASS. bate com o script: GRACE_DAYS=7,
			fireDate git-derivado (git log file-exists; def.date+maxAgeDays temporal), exit 1 só com
			DD_GATE_ENABLED + além-da-carência, default exit 0 advisory. Workflow é comment-only (a
			linha run: inalterada). config.cue Camada-3 regenerada no CLAUDE.md.

			[uq-01/02/03/07]: PASS. rationale=por quê; especificidade-Mesh (adr-062/runner, os defs
			concretos, P10/P12); P12/P10/P0 verificados reais em design-principles.cue; sem
			placeholder (matches "TODO" eram substring de "TODOS", falso-positivo).

			[WARN encontrado e CORRIGIDO]: tq-adr-03/uq-03 — adr-162 declara
			governance/readme/structure-index.cue em derivedArtifacts, mas o índice (scan de
			filesystem, adr-090) ainda não fora regenerado (não listava adr-162 nem def-070).
			CORREÇÃO aplicada ANTES da proposta: rodado scripts/ci/generate-structure-index.py; o
			índice agora inclui ambos (diff mecânico de +2 entradas). Warn resolvido; sem warn
			pendente.
			"""
	}]

	findings: {}

	summary: """
		SRR do adr-162 — ADR estrutural filho de adr-062 que estende a postura advisory do runner
		de deferred-decisions para advisory-com-carência-que-bloqueia (gate de carência), instalado-
		mas-DESLIGADO neste arco (nascimento limpo: o workflow não seta DD_GATE_ENABLED), mais a
		Camada 3 (briefing de abertura em governance/claude/config.cue → CLAUDE.md) e o def-070
		(Camada 2 deferida). Self-review em subagente ISOLADO (sem histórico da conversa) per
		quality-gate rollout adr→isolated-subagent.

		VEREDITO: 0 fail / 0 warn pendente / 0 info, stable em 1 round (1 warn surgido e CORRIGIDO).
		#ADR conformance PASS; tq-adr-01..04 PASS; parentesco adr-062 íntegro (accepted, não-
		superseded, não-listado em supersedes; evolução-pela-experiência); coerência gate-instalado-
		mas-OFF bate com script/workflow/config; uq-01/02/03/07 PASS. O único achado — warn de
		structure-index stale (não listava adr-162/def-070) — foi corrigido regenerando o índice
		antes da proposta. cue vet ./... EXIT=0; dry-run de 2 faces prova o gate (exit 1 com flag,
		exit 0 advisory).
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque (a) o desenho das 3 camadas + a decisão de nascimento-
		desligado foram aprovados pelo founder antes da escrita, e (b) a revisão foi feita por
		subagente ISOLADO (viés de auto-ratificação reduzido) que deu PASS em todas as dimensões de
		fail. O ataque central — reverter a postura advisory do adr-062 sem violar sua invariante de
		não-mutação e sem a peça nascer sendo violada — foi verificado coerente: relógio git-derivado
		(sem firedAt), gate instalado-mas-OFF (workflow comment-only), prova por dry-run de 2 faces.
		O único finding foi um warn não-fail (structure-index derivado ainda não regenerado),
		mecânico e corrigido ANTES da proposta (regen do índice incluindo adr-162 + def-070), sem
		delta semântico a re-verificar num 2º round. cue vet ./... EXIT=0; nenhum finding fail.
		"""
}
