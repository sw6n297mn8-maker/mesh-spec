package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-model-event-convention.cue — Convenção de nome de event (adr-107,
// kind regex-pattern-match). Trava a regressão do vocabulário canonizado em
// adr-104: todo domain-model.events[].name é PascalCase sem espaços. Promovido
// a REJECT em adr-108 após a normalização dos 22 names (dlv/inv/rew) → zero
// violações; um name não-canônico novo agora falha o CI.

structuralChecks: "sc-ev-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-ev-01"
	title:        "Event name é PascalCase (sem espaços)"
	artifactType: "domain-model"
	description:  "Todo domain-model.events[].name casa ^[A-Z][A-Za-z0-9]*$ (PascalCase, sem espaços/parentéticos). Convenção canônica per adr-104 (name é a chave cross-artifact de event). cue vet valida que name é string non-empty, não a convenção de formato."
	kind:         "regex-pattern-match"
	rule: {
		valuePath: "events[].name"
		pattern:   "^[A-Z][A-Za-z0-9]*$"
	}
	errorMessage: "domain-model: event name '{valor}' não é PascalCase sem espaços (^[A-Z][A-Za-z0-9]*$). Normalize o name canônico (PascalCase) e mova detalhe descritivo (parentéticos) para o campo description."
	rationale:    "adr-107: name é a chave cross-artifact de event (adr-104); um vocabulário só é referenciável de forma confiável se a convenção de formato for consistente. Promovido a reject em adr-108 (22 names normalizados → zero violações)."
	enforcement: "reject"
}
