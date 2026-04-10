package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// canvas.cue — Structural checks determinísticos para Bounded Context Canvas.
//
// Per adr-040: estes checks são gating determinístico, complementares
// (não substitutos) ao design review advisory feito por vp-canvas.
// Per adr-041: v1 é minimal — sem cross-artifact reference checking
// genérico. Refs cross-artifact (stakeholderRef→stakeholder-map,
// costRef→domain-definition, communication refs→context-map) ficam
// fora até kind correspondente existir.
//
// Per adr-049: kind conditional-file-presence adicionado para
// enforcement da convenção api-spec (adr-048). sc-cv-02 e sc-cv-03
// usam este kind para verificar presença bicondicional de api.yaml
// e async-api.yaml por canvas capability flags.

structuralChecks: "sc-cv-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-cv-01"
	title:        "Stakeholders em incentiveAnalysis devem aparecer em stakeholders"
	artifactType: "canvas"
	description:  "Toda entrada em incentiveAnalysis.participants referencia um stakeholder via stakeholderRef. O mesmo stakeholderRef deve aparecer em pelo menos uma entrada do bloco stakeholders[] do mesmo canvas. Análise de incentivos sobre participante que o canvas não declara como impactado é incoerência interna."
	kind:         "same-artifact-consistency"
	rule: {
		referencingBlock: "incentiveAnalysis.participants"
		definingBlock:    "stakeholders"
		relation:         "every-reference-must-exist-as-entry"
	}
	errorMessage: "incentiveAnalysis.participants[].stakeholderRef contém valor que não corresponde a nenhum stakeholders[].stakeholderRef no mesmo canvas. Analisar incentivos de stakeholder que o BC não declara como afetado indica análise órfã ou stakeholder esquecido na lista canônica do contexto. Adicione o stakeholder em stakeholders[] ou remova a entrada de incentiveAnalysis.participants[]."
	rationale:    "Cobre o gap entre incentive analysis (dp-08) e stakeholder mapping no escopo do próprio canvas. Sem este check, um canvas pode declarar incentivos sobre participantes que ele mesmo não reconhece — quebra de coerência interna que o schema CUE não detecta porque ambos os blocos validam isoladamente."
}

structuralChecks: "sc-cv-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-cv-02"
	title:        "hasSyncSurface exige presença bicondicional de api.yaml"
	artifactType: "canvas"
	description:  "Quando canvas declara capabilities.hasSyncSurface como true, o arquivo contexts/{bc}/api.yaml deve existir no mesmo bounded context. Quando hasSyncSurface é false, api.yaml não deve existir — spec órfão sem cobertura de canvas é drift. Per api-spec-convention: bicondicionalidade mantém consistência nos dois sentidos."
	kind:         "conditional-file-presence"
	rule: {
		sourcePattern:  "contexts/*/canvas.cue"
		conditionField: "capabilities.hasSyncSurface"
		targetPattern:  "contexts/*/api.yaml"
		biconditional:  true
	}
	errorMessage: "Inconsistência entre canvas.capabilities.hasSyncSurface e presença de api.yaml no bounded context. Se hasSyncSurface é true, api.yaml deve existir (superfície declarada mas não materializada). Se hasSyncSurface é false, api.yaml não deve existir (spec órfão sem cobertura de canvas). Ajuste o flag no canvas ou crie/remova api.yaml conforme a intenção de superfície síncrona do BC."
	rationale:    "Materializa enforcement estrutural da condição de presença bicondicional definida em architecture/conventions/api-spec-convention.cue (per adr-048). Flag true sem spec é promessa vazia; flag false com spec é drift silencioso. Check determinístico por inspeção de filesystem — cabe no domínio de structural-check per adr-040."
}

structuralChecks: "sc-cv-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-cv-03"
	title:        "hasAsyncSurface exige presença bicondicional de async-api.yaml"
	artifactType: "canvas"
	description:  "Quando canvas declara capabilities.hasAsyncSurface como true, o arquivo contexts/{bc}/async-api.yaml deve existir no mesmo bounded context. Quando hasAsyncSurface é false, async-api.yaml não deve existir. Mesma lógica bicondicional de sc-cv-02, aplicada à superfície assíncrona."
	kind:         "conditional-file-presence"
	rule: {
		sourcePattern:  "contexts/*/canvas.cue"
		conditionField: "capabilities.hasAsyncSurface"
		targetPattern:  "contexts/*/async-api.yaml"
		biconditional:  true
	}
	errorMessage: "Inconsistência entre canvas.capabilities.hasAsyncSurface e presença de async-api.yaml no bounded context. Se hasAsyncSurface é true, async-api.yaml deve existir. Se hasAsyncSurface é false, async-api.yaml não deve existir. Ajuste o flag no canvas ou crie/remova async-api.yaml conforme a intenção de superfície assíncrona do BC."
	rationale:    "Mesma lógica bicondicional de sc-cv-02 aplicada à superfície assíncrona. Materializa enforcement da segunda condição de presença em api-spec-convention.cue. Check determinístico por inspeção de filesystem."
}
