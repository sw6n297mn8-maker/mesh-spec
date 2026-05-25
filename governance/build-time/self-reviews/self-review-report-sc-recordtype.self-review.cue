package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

selfReviewReportScRecordtype: build_time.#SelfReviewReport & {
	reportId: "srr-self-review-report-sc-recordtype"

	artifactPath:       "architecture/structural-checks/self-review-report.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Ajuste do sc-srr-01 + criacao do sc-srr-03 para tornar a verificacao
			de artifactPath ciente do recordType (adr-090 follow-on):
			- sc-srr-01: rule ganha filterField=recordType, filterValue=
			  artifact-review (mustExist default true). Passa a exigir existencia
			  do artifactPath APENAS para reviews. Os ~280 SRRs existentes
			  defaultam recordType=artifact-review, entao continuam cobertos.
			- sc-srr-03 (novo): filterValue=artifact-deletion, mustExist=false.
			  Exige que o artifactPath de registros de delecao NAO exista, com o
			  title e errorMessage aprovados pelo founder.

			Motivo: os 10 SRRs de delecao (fce/nim/ntf) apontam para artefatos
			removidos no reset (PR #43) e eram falsamente sinalizados pelo
			sc-srr-01. Em vez de apagar audit trail append-only, distingue-se a
			classe semantica (review vs deletion). Ambos os checks conformam a
			#StructuralCheck (kind filesystem-path-exists) com o shape estendido
			(filterField/filterValue/mustExist). cue vet confirma a uniao
			discriminada.
			"""
	}]

	findings: {}

	summary: """
		sc-srr-01 passa a filtrar recordType=artifact-review (exige path
		existente); sc-srr-03 novo cobre recordType=artifact-deletion (exige path
		ausente). Resolve o falso-positivo dos 10 SRRs de delecao sem apagar o
		audit trail, distinguindo review de delecao como classes semanticas.
		"""

	singleRoundRationale: "Ajuste deterministico de 2 checks consumindo o shape estendido de #FilesystemPathExistsRule (mesmo commit). Title/errorMessage do sc-srr-03 aprovados pelo founder. Efeito verificavel: sc-srr-01 deixa de cobrir os 10 de delecao; sc-srr-03 os cobre exigindo ausencia. cue vet passa; rounds adicionais nao detectariam new findings."
}
