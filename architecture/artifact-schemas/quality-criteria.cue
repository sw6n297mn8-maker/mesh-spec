package artifact_schemas

// quality-criteria.cue — Tipos reutilizáveis para critérios de qualidade
// e classificação de artefatos.
//
// Vivem em artifact_schemas porque são consumidos por:
// (a) cada artifact schema via _qualityCriteria
// (b) quality-gate.cue via import de artifact_schemas
// (c) self-review-report.cue via import de artifact_schemas
//
// Direção de dependência: governance/build-time → artifact_schemas.
// Nunca o contrário.

#Severity: "fail" | "warn" | "info"

// #ArtifactType é deliberadamente restrito aos artefatos com critérios
// de qualidade específicos validados na prática. Expandir quando novos
// tipos entrarem no regime de self-review. A enum é fechada por fase
// operacional, não ontologicamente completa.
#ArtifactType:
	"adr" |
	"canvas" |
	"domain-definition" |
	"lens" |
	"artifact-schema" |
	"stakeholder-map" |
	"task-template" |
	"wave-plan"

// Convenção de IDs:
//   uq-NN     — critério universal (quality-gate.cue)
//   tq-XXX-NN — critério type-specific (XXX = abreviação do tipo)
// Abreviações canônicas: adr, cv (canvas), dd (domain-definition),
// ln (lens), as (artifact-schema), sm (stakeholder-map),
// tt (task-template), wp (wave-plan), srr (self-review-report).
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

// #QualityCriterionFinding é o resultado de avaliação de um critério
// durante self-review. severity deve ser igual ao severity do critério
// referenciado por criterionId — o agente não reclassifica severity.
// rationale é contexto adicional do finding, não justificativa de override.
#QualityCriterionFinding: {
	criterionId: string & =~"^(uq|tq-[a-z]{2,3})-[0-9]{2}$"
	severity:    #Severity
	message:     string & !=""
	rationale?:  string & !=""
}
