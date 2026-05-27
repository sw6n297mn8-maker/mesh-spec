package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// tension-entry.cue — Structural checks determinísticos para
// tension log entries (architecture/tension-log/).
//
// Per adr-040: gate determinístico complementar ao design review
// advisory feito por vp-tension-entry. Per adr-063: filesystem-path-
// exists kind cobre verificação de manifestsIn (sc-te-01). Per adr-102
// (resolve def-002): cross-file-id-exists kind passa a permitir
// sc-te-02 (relatedADR aponta para ADR existente). Check ainda
// pretendido: sc-te-tensionTarget path-or-axiom — known gap em
// adr-063 (path-or-axiom semantics), fora deste pass.

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

structuralChecks: "sc-te-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-te-02"
	title:        "tension-entry.relatedADR referencia ADR existente"
	artifactType: "tension-entry"
	description:  "Todo tension-entry.relatedADR existe como id de ADR em architecture/adrs/*.cue. Trava regressão de tensão apontando para ADR inexistente (id fictício que o regex de formato adr-NNN aceita mas que não existe semanticamente)."
	kind:         "cross-file-id-exists"
	rule: {
		referencePath: "relatedADR"
		targetGlob:    "architecture/adrs/*.cue"
		targetIdPath:  "id"
	}
	errorMessage: "tension entry contém relatedADR apontando para id de ADR que não existe em architecture/adrs/. Corrija o id ou crie o ADR referenciado."
	rationale:    "def-002 (adr-102): primeiro check do kind cross-file-id-exists — caso born-green nomeado no def-002. cue vet valida o formato (adr-NNN), não a existência semântica cross-file; este check fecha esse gap para relatedADR."
	enforcement: "reject"
}
