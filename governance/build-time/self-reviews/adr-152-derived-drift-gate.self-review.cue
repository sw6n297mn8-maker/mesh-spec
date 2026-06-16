package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr152: build_time.#SelfReviewReport & {
	reportId: "srr-adr-152-derived-drift-gate"

	artifactPath:       "architecture/adrs/adr-152-derived-drift-gate.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-16"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 1
		summary: """
			Round 1 -- review por SUB-AGENTE ISOLADO (rollout adr -> isolated-subagent), sem
			o historico da sessao de autoria, sobre adr-152 completo. Sete pontos de ataque,
			verificacao contra o disco. 7 PASS: (1) AMEND genuino -- decisoes-nucleo de adr-090
			(derivar do filesystem, adr-090:30-32) e adr-115 (meta.cue->tree->README,
			adr-115:44-48) de pe; adr-152 so troca o mecanismo de sync, nao supersede. (2)
			distincao real gate-aspiracional (adr-090:23-27, config aspiracional, falso-positivo
			by design) vs gate-deterministico (adr-152, derivado reflete o que existe) -- nao
			sofistica. (3) as 3 citacoes verbatim batem com o disco (090 c2 :84-85, 090-rejeicao
			:23-25, 115 c3 :92-93). (4) P0/P10/P12 aplicados com mecanismo concreto, sem
			name-drop; P1 corretamente OMITIDO -- o ADR-irmao adr-090 (mesmo artefato) cita
			["P0","P10","P12"] sem P1 (adr-090:115). (5) rastreabilidade fecha: 6
			affectedArtifacts existem e mudam, regenerate-derived.sh e novo, sc-adr-01
			at-least-one satisfeita. (6) falsificationCondition falsificavel, sinal checavel (PR
			nao-toca-fontes + step de drift vermelho). (7) coerencia com WI-141
			(wave-plan.cue:531-559): concordam no diagnostico GH013/branch-protection e no
			conserto gate audivel. 0 FAIL. 1 WARN + 1 INFO, ambos comment-level e corrigidos
			mecanicamente: WARN -- ref de linha num comentario de affectedArtifacts
			(rebuild-projections.sh "l.35-36" -> "l.36-37"; l.35 e o fim do item
			claim-expiration, o --check esta em 36-37); INFO -- grafia "deterministico" numa
			gloss de citacao em principlesApplied alinhada ao verbatim de adr-115
			("deterministic"). cue vet EXIT=0 apos as correcoes.
			"""
	}]

	findings: {}

	summary: """
		adr-152 (proposed) substitui o auto-commit pos-merge dos 3 derivados (structure-index,
		tree-generated, README) por um gate de drift no PR (validate.yml, [push,pull_request],
		deterministico) via regenerate-derived.sh --check (P0, wiring b); descomissiona os 2
		workflows materialize-* (incompativeis com main-exige-PR). AMEND de adr-090 (o detector
		que c2 descreveu) e adr-115 (o gate que c3 prometeu) -- decisoes-nucleo intactas,
		supersedes vazio. Materializacao dos artefatos mecanicos (gate, script, remocoes,
		ponteiros) = PR seguinte (plannedOutputs). Self-review por SUB-AGENTE ISOLADO em 1 round
		(rollout adr -> isolated-subagent): 7 pontos de ataque contra o disco, 7 PASS / 0 FAIL;
		2 achados comment-level (warn: ref de linha; info: grafia de gloss) corrigidos
		mecanicamente. cue vet EXIT=0. Zero fail residual; estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: o review isolado achou 0 fail nos 7 pontos de ataque (amend-vs-supersede,
		distincao gate-aspiracional vs deterministico, citacoes verbatim, principlesApplied,
		rastreabilidade, falsificationCondition, coerencia WI-141), todos PASS contra o disco.
		Os 2 itens (warn: ref de linha num comentario; info: grafia numa gloss de citacao) sao
		comment-level/mecanicos -- corrigidos sem exigir re-review semantico, com cue vet
		permanecendo EXIT=0. Round unico porque nenhum achado tocou a semantica do ADR.
		"""
}
