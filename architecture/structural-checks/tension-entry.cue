package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// tension-entry.cue — Structural checks determinísticos para
// tension log entries (architecture/tension-log/).
//
// Per adr-040: gate determinístico complementar ao design review
// advisory feito por vp-tension-entry. Per adr-063: filesystem-path-
// exists kind cobre verificação de manifestsIn. Outros checks
// pretendidos (sc-te-relatedADR aponta para ADR existente,
// sc-te-tensionTarget path-or-axiom) dependem de cross-file-id-
// exists kind ou refinement de filesystem-path-exists com skip-if-
// pattern — registrados em def-002 (cross-file-id-exists) e como
// known gap em adr-063 (path-or-axiom semantics).

structuralChecks: "sc-te-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-te-01"
	title:        "tension-entry.manifestsIn deve apontar para arquivo existente"
	artifactType: "tension-entry"
	description:  "O campo manifestsIn de cada tension entry deve corresponder a path real no filesystem. Per adr-040 split: existência é dimensão determinística (verificável por inspeção). Tension entry cuja manifestsIn não existe declara manifestação especulativa — sem artefato concreto, a tensão não é observável nem resolvível. tq-te-03 captura aspecto interpretativo (manifestation visibility); este check captura a precondição estrutural (file existence)."
	kind:         "filesystem-path-exists"
	rule: {
		sourcePath: "manifestsIn"
		isList:     false
	}
	errorMessage: "tension entry contém manifestsIn apontando para arquivo que não existe no repositório. Tensão sem manifestação concreta é especulativa — não há onde verificar nem onde resolver. Verifique se o path está digitado corretamente, se o arquivo foi movido (atualizar manifestsIn) ou removido (atualizar manifestsIn para artifact remanescente onde a tensão é observável, ou marcar status='resolved' se a tensão deixou de existir)."
	rationale:    "Cobre o gap entre tension entry e artifact onde tensão se manifesta. tq-te-03 é fail mas verifica apenas substantividade da rastreabilidade interpretativamente; structural-check captura precondição mecânica (path real vs typo/stale). Pattern paralelo a sc-srr-01."
}
