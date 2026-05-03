package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adrSchemaPlannedoutputs: build_time.#SelfReviewReport & {
	reportId: "srr-adr-schema-plannedoutputs"

	artifactPath:       "architecture/artifact-schemas/adr.cue"
	artifactSchemaPath: "architecture/artifact-schemas/quality-criteria.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-01"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Schema #ADR estendido per adr-059: (1) novo field plannedOutputs?: [...string & !=\"\"] adicionado entre affectedArtifacts (required) e derivedArtifacts (optional) — agrupamento semântico por traceability dimension. Field OPTIONAL per founder direction (grandfather strategy); ADRs pré-adr-059 continuam válidas sem migration. (2) Comments atualizados: affectedArtifacts comment ajustado de 'criados ou alterados' para 'existentes alterados' + nota de grandfather; plannedOutputs comment novo articulando 'novos criados pela decisão como output direto' + optional/grandfather; derivedArtifacts comment preservado. Reusa pattern tipo string & !=\"\" do affectedArtifacts. Extension puramente aditiva — disjuncts/sub-types/enum entries existentes não alterados; 58 instâncias existentes (adr-001..adr-058) permanecem válidas — verificado via cue vet ./... EXIT=0. tq-as-XX critérios do schema artifact-schema satisfeitos por inspeção: field comment substantivo, tipo coerente com fields adjacentes, optional preservando backward compat."
	}]

	findings: {}

	summary: """
		architecture/artifact-schemas/adr.cue estendido per adr-059
		(commit subsequente nesta sessão) com novo field plannedOutputs
		OPTIONAL em #ADRBase. Promove disciplina 3-way conceitual
		(PG-ADR narrative) para schema first-class. Grandfather strategy
		(field optional) preserva 58 ADRs existentes sem migration.
		Single round porque mudança é estrutural-aditiva coesa autorada
		como parte do commit unificado de adr-059 — review distribuído
		ocorreu via approval do próprio adr-059 que especifica items 1-2
		dessa extension.
		"""

	singleRoundRationale: """
		Esta extension é parte estrutural inseparável da decisão registrada
		em adr-059 (Part 1 do C3 plan). Review do schema delta ocorreu
		via review do próprio adr-059 — founder aprovou decision items
		1-2 (field optional + comments updated) + risk metadata (high/
		cross-artifact). Round 1 do self-review verifica: (a) cue vet
		./... passa EXIT=0 com 58 ADRs existentes inalteradas + adr-059
		usando o novo field (auto-referencial), (b) field optional preserva
		backward compat completo (zero ADRs antigas afetadas), (c) tipo
		[...string & !=\"\"] consistente com pattern dos outros fields
		traceability (affectedArtifacts/derivedArtifacts), (d) comments
		articulam grandfather strategy explicitamente. Multiple rounds
		retroativos seriam fabricação — única round real é verificação
		post-write da decisão já aprovada.
		"""
}
