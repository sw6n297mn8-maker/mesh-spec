package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// canvas.cue — Structural checks determinísticos para Bounded Context Canvas.
//
// Per adr-040: estes checks são gating determinístico, complementares
// (não substitutos) ao design review advisory feito por vp-canvas.
// Per adr-041: v1 é minimal — sem cross-artifact reference checking.
// Refs cross-artifact (stakeholderRef→stakeholder-map, costRef→
// domain-definition, communication refs→context-map) ficam fora do v1
// e serão adicionadas quando v2 admitir o kind correspondente.

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
