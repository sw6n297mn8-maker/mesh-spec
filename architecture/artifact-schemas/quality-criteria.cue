package artifact_schemas

// quality-criteria.cue — Tipos reutilizáveis para critérios de qualidade.
//
// Vivem em artifact_schemas porque são consumidos por:
// (a) cada artifact schema via _qualityCriteria
// (b) quality-gate.cue via import de artifact_schemas
//
// Direção de dependência: governance/build-time → artifact_schemas.
// Nunca o contrário.

#Severity: "fail" | "warn" | "info"

#QualityCriterion: {
	id:          string & !=""
	description: string & !=""
	test:        string & !=""
	severity:    #Severity
	rationale:   string & !=""
}

// #QualityCriteria é o bloco que cada artifact schema usa em _qualityCriteria.
// Formato padronizado: lista de critérios + rationale do conjunto.
#QualityCriteria: {
	criteria:  [#QualityCriterion, ...#QualityCriterion]
	rationale: string & !=""
}
