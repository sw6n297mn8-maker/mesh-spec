package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr103FilesystemDeclaredCoverageKind: build_time.#SelfReviewReport & {
	reportId: "srr-adr-103-filesystem-declared-coverage-kind"

	artifactPath:       "architecture/adrs/adr-103-filesystem-declared-coverage-kind.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-103 (kind filesystem-declared-coverage + sc-cm-05 +
			def-019). Escopo e nome do kind aprovados pelo founder antes da escrita.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility/blastRadius coerentes; defersTo ["def-019"].
			tq-adr-01: alternativa rejeitada com motivo (gatear context-map→disco com
			allowance plannedIn = ruído, os 14 sem dir são roadmap). affectedArtifacts
			= 4 paths reais.

			(b) Reenquadramento honesto registrado: context↔disco não é drift (mapa
			à frente do disco por design); events↔BC prematuro (não materializado).
			Só disco→map é drift real e born-green. Não há falsa alegação de
			cobertura cross-file total.

			(c) Verificacao empirica: investigação sobre dados reais (0 dir
			não-declarado; 14 contexts planejados; 44 events forward-declared sem
			fonte canônica); cue vet ./... EXIT 0; runner --self-test PASS; runner
			default → sc-cm-05 verde, 0 bloqueantes, exit 0.

			(d) Gap governado: events↔BC vira def-019 (adr-062) com trade-off e
			trigger manual-review articulado — não gap esquecido.
			"""
	}]

	findings: {}

	summary: """
		adr-103 adiciona o kind filesystem-declared-coverage (enumera filesystem,
		exige declaração no artefato — inverso do cross-file-id-exists), autora
		sc-cm-05 (disco→context-map, born-green) e defere events↔BC em def-019.
		Fecha o 'mapas discordam com o disco' do audit na direção real e segura.
		Sem findings fail/warn.
		"""

	singleRoundRationale: """
		Uma rodada basta: escopo e nome aprovados pelo founder antes da escrita;
		premissa reenquadrada por investigação empírica; viabilidade verificada por
		cue vet + self-test + execucao (sc-cm-05 born-green). Sem espaco de decisao
		aberto a red-team adicional.
		"""
}
