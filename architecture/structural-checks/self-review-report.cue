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

structuralChecks: "sc-srr-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-srr-01"
	title:        "self-review-report.artifactPath deve apontar para arquivo existente"
	artifactType: "self-review-report"
	description:  "O campo artifactPath de cada self-review report deve corresponder a path real no filesystem. Per adr-040 split: existência é dimensão determinística (verificável por inspeção do filesystem), não interpretativa. Self-review report cuja artifactPath não existe é review órfão — review de algo que não existe ou foi removido sem atualizar o report."
	kind:         "filesystem-path-exists"
	rule: {
		sourcePath: "artifactPath"
		isList:     false
	}
	errorMessage: "self-review report contém artifactPath apontando para arquivo que não existe no repositório. Self-review é evidência de revisão de um artefato concreto — sem o artefato, o report é especulativo. Verifique se o artifactPath está digitado corretamente, se o arquivo foi movido (atualizar artifactPath), ou se o arquivo foi removido (mover este report para arquivo deletado ou retirá-lo)."
	rationale:    "Cobre o gap entre self-review report e artefato avaliado. tq-srr-XX do schema captura aspectos do conteúdo (rounds, findings); este check captura existência da referência cruzada. derivedFromInvariant: pattern observado de reports órfãos quando arquivos são renomeados; structural-check força sync."
}
