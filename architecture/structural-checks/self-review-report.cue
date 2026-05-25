package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// self-review-report.cue — Structural checks determinísticos para
// self-review reports (governance/build-time/self-reviews/).
//
// Per adr-040: gate determinístico complementar ao design review
// advisory feito por vp-self-review-report. Per adr-063: filesystem-
// path-exists kind cobre verificação de artifactPath. Outros checks
// pretendidos (sc-srr-02 artifactSchemaPath match canonicalPathRegex)
// dependem de regex-pattern-match kind — registrado em def-003.
//
// recordType (adr-090 follow-on): sc-srr-01 só exige existência para
// reviews (recordType=artifact-review); sc-srr-03 exige ausência para
// registros de deleção (recordType=artifact-deletion). Filtro +
// polaridade via #FilesystemPathExistsRule (filterField/mustExist).

structuralChecks: "sc-srr-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-srr-01"
	title:        "self-review-report.artifactPath deve apontar para arquivo existente"
	artifactType: "self-review-report"
	description:  "O campo artifactPath de cada self-review report de REVIEW (recordType=artifact-review) deve corresponder a path real no filesystem. Per adr-040 split: existência é dimensão determinística (verificável por inspeção do filesystem), não interpretativa. Self-review report de review cuja artifactPath não existe é review órfão — review de algo que não existe. Registros de deleção (recordType=artifact-deletion) são cobertos por sc-srr-03, não por este check."
	kind:         "filesystem-path-exists"
	rule: {
		sourcePath:  "artifactPath"
		isList:      false
		filterField: "recordType"
		filterValue: "artifact-review"
	}
	errorMessage: "self-review report de review contém artifactPath apontando para arquivo que não existe no repositório. Self-review é evidência de revisão de um artefato concreto — sem o artefato, o report é especulativo. Verifique se o artifactPath está digitado corretamente, se o arquivo foi movido (atualizar artifactPath), ou se o arquivo foi removido (use recordType=artifact-deletion com deletionContext)."
	rationale:    "Cobre o gap entre self-review report e artefato avaliado. tq-srr-XX do schema captura aspectos do conteúdo (rounds, findings); este check captura existência da referência cruzada para reviews. derivedFromInvariant: pattern observado de reports órfãos quando arquivos são renomeados; structural-check força sync."
}

structuralChecks: "sc-srr-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-srr-03"
	title:        "SRRs de deleção apontam para artefatos ausentes"
	artifactType: "self-review-report"
	description:  "O campo artifactPath de cada self-review report de DELEÇÃO (recordType=artifact-deletion) deve apontar para path que NÃO existe no filesystem. Registro de deleção referencia, por construção, um artefato removido intencionalmente; se o path ainda existe, o registro está mal classificado (deveria ser artifact-review) ou a deleção não ocorreu. Complementa sc-srr-01 (que cobre reviews) preservando a classe semântica de deleção como audit trail legítimo."
	kind:         "filesystem-path-exists"
	rule: {
		sourcePath:  "artifactPath"
		isList:      false
		filterField: "recordType"
		filterValue: "artifact-deletion"
		mustExist:   false
	}
	errorMessage: "SRR de deleção '{file}' aponta para artifactPath existente; use artifact-review ou remova recordType=artifact-deletion."
	rationale:    "Per adr-090 follow-on: deleção é classe semântica distinta de review. sc-srr-01 exige existência (review); sc-srr-03 exige ausência (deleção). Sem este check, marcar um SRR como deleção desativaria silenciosamente a verificação de path sem garantir que o artefato de fato foi removido."
}
