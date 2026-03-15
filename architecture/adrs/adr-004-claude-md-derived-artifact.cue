package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr004: artifact_schemas.#ADR & {
	id:    "adr-004"
	title: "CLAUDE.md como artefato derivado com sync enforcement"
	date:  "2026-03-15"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		CLAUDE.md já era gerado a partir de governance/claude/config.cue via
		template CUE, mas nada declarava formalmente essa relação. config.cue
		foi editado sem regenerar CLAUDE.md (ou vice-versa), causando drift
		silencioso entre source e artefato gerado. O CI não detectava a
		divergência porque CLAUDE.md estava apenas em scope.excluded sem
		nenhuma validação adicional.
		"""

	decision: """
		Declarar CLAUDE.md como artefato derivado em repo-structure.cue:
		(a) novo schema #DerivedArtifact com path, source, generator e rationale;
		(b) instância registrando CLAUDE.md com source governance/claude/config.cue
		    e generator "cue export ./governance/claude -e output --out text";
		(c) nova CI phase derived-artifact-sync que executa cada generator e
		    compara output com o arquivo commitado;
		(d) CLAUDE.md permanece em scope.excluded (não é CUE, não se classifica
		    contra artifact schemas) — sync é validação ortogonal.
		"""

	consequences: """
		Positivas: drift entre config.cue e CLAUDE.md é detectado automaticamente
		pelo CI; modelo extensível para futuros artefatos derivados (e.g. README
		gerado); generator explícito documenta como regenerar.
		Negativas: CI ganha mais uma phase (custo marginal baixo dado que
		derived-artifact-sync é script trivial de diff).
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"governance/repo-structure.cue",
	]

	derivedArtifacts: [
		"CLAUDE.md",
	]

	principlesApplied: [
		"P0",
		"P1",
	]

	rationale: "Incidente de drift entre config.cue e CLAUDE.md demonstrou que relação source→derivado sem enforcement é frágil. Declarar formalmente e validar no CI fecha o loop."
}
