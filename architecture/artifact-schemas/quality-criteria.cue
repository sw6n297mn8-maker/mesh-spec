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

// Convenção de IDs:
//   uq-NN     — critério universal (quality-gate.cue)
//   tq-XXX-NN — critério type-specific (XXX = abreviação do tipo)
// Abreviações canônicas: adr, cv (canvas), dd (domain-definition),
// ln (lens), as (artifact-schema), sm (stakeholder-map),
// tt (task-template), wp (wave-plan).
#QualityCriterion: {
	id:          string & =~"^(uq|tq-[a-z]{2,3})-[0-9]{2}$"
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
