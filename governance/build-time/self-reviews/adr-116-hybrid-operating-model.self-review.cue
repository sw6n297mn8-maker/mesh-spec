package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr116HybridOperatingModel: build_time.#SelfReviewReport & {
	reportId: "srr-adr-116-hybrid-operating-model"

	artifactPath:       "architecture/adrs/adr-116-hybrid-operating-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-27"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-116 (modelo de operação híbrido). Texto aprovado pelo founder
			no chat antes da escrita, com dois refinamentos incorporados (guard-rail de
			enforcement em CI; 'fix de cue vet' só mecânico sem mudança semântica).

			(a) Conformância #ADR (tq-adr-01..04): id ^adr-[0-9]{3}$; status "accepted";
			decisionClass "foundational" (altera protocolo de governança base do agente);
			reversibility "high" (revert é editar texto de volta) + blastRadius "repo-wide"
			(governa toda operação) — consistentes. tq-adr-01: três alternativas com motivo
			de rejeição (estrito / autonomia total / híbrido). tq-adr-03/04: affectedArtifacts
			(config.cue) é real; derivedArtifacts (CLAUDE.md) é o derivado regenerado.

			(b) Coerência: o ADR documenta a divergência prévia honestamente (o agente vinha
			violando o texto antigo) e a reconcilia, em vez de fingir conformidade retroativa.

			(c) Verificação: cue vet ./... EXIT 0; CLAUDE.md regenerado bate com o config.cue
			editado; structural-check-runner 0 bloqueantes.
			"""
	}]

	summary: "adr-116 conforma #ADR (tq-adr-01..04): 3 alternativas com motivo de rejeição, risco consistente (foundational, high, repo-wide), rastreabilidade real (config.cue + CLAUDE.md derivado). Documenta honestamente a divergência prévia e a reconcilia. Verificado: cue vet exit 0, CLAUDE.md regen em sync, runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round: o texto foi proposto e aprovado pelo founder no chat (com 2 refinamentos) ANTES da escrita; a conformância de schema é verificada por cue vet + runner sem findings."
}
