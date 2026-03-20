package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr018: artifact_schemas.#ADR & {
	id:    "adr-018"
	title: "Self-review hardening: severity invariant, meta-schema, and maxRounds"
	date:  "2026-03-20"

	decisionClass: "structural"
	decider:       "founder"

	context: """
		O self-review report (#SelfReviewReport) permite que findings
		declarem severity independente do critério que os originou.
		Isto cria um vetor de autoengano: o agente pode reportar um
		critério com severity 'fail' como finding com severity 'warn',
		produzindo um report 'stable' que mascara falhas reais.
		Simultaneamente, artifact schemas não tinham critérios type-specific
		próprios (tq-as-*), ficando fora do regime de quality gate para
		meta-validação. Adicionalmente, observação empírica mostrou que
		artefatos de governança e meta-schemas precisam consistentemente
		de 4 rounds para estabilizar, mas maxRounds canônico era 3.
		Alternativas consideradas para severity enforcement:
		(a) constraint CUE com lookup por criterionId — rejeitada: CUE
		não suporta cross-reference dinâmica entre instâncias;
		(b) apenas tq-srr-04 sem política canônica no tipo — rejeitada:
		critério procedural sem fonte de verdade estrutural é frágil;
		(c) política canônica + critério procedural + CI futuro — aceita:
		três camadas complementares com enforcement progressivo.
		"""

	decision: """
		Três mudanças coordenadas: (1) adicionar _severityInvariant como
		campo hidden em #QualityCriterionFinding declarando a política
		canônica de que finding.severity == criterion.severity, com
		enforcement por protocolo e CI futuro — não por CUE type system;
		(2) criar tq-srr-04 em self-review-report.cue como critério
		procedural que o agente verifica em cada round; (3) criar
		artifact-schema.cue como meta-schema com tq-as-01 a tq-as-03
		para que artifact schemas participem do regime de self-review.
		Adicionalmente: maxRounds canônico em quality-gate.cue de 3 para
		4, alinhando o protocolo com a observação empírica de que
		artefatos de governança precisam de 4 rounds.
		"""

	consequences: """
		Positivas: severity downgrade torna-se detectável em três
		camadas (política no tipo, critério no protocolo, CI futuro);
		artifact schemas com schema existente ganham meta-critérios de
		qualidade; maxRounds reflete observação empírica, eliminando
		desalinhamento entre protocolo e prática. Negativas: _severityInvariant
		é enforcement declarativo, não compilatório — depende do agente
		e do CI respeitarem; artifact schemas sem _qualityCriteria
		(canvas, stakeholder-map, task-template, wave-plan) continuam
		fora do regime type-specific; maxRounds 4 pode ser excessivo
		para artefatos simples (mitigado: estabilização precoce é
		permitida).
		"""

	status: "accepted"

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"governance/build-time/self-review-report.cue",
		"architecture/artifact-schemas/artifact-schema.cue",
		"governance/build-time/quality-gate.cue",
	]

	principlesApplied: [
		"P0",
		"P12",
	]

	rationale: """
		P0 (single source of truth) exige que a invariante de severity
		tenha exatamente uma localização canônica — _severityInvariant
		no tipo, não espalhada em documentação. P12 (governança como
		código) exige que enforcement seja progressivamente automatizado:
		política → protocolo → CI. O meta-schema fecha o loop de que
		schemas são artefatos de primeira classe no regime de qualidade.
		maxRounds 4 alinha o protocolo canônico com a observação empírica,
		eliminando desalinhamento semântico entre o que o protocolo diz
		e o que os reports evidenciam.
		"""
}
