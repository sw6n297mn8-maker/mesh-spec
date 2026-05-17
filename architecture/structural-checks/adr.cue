package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr.cue — Structural checks determinísticos para Architecture Decision Records.
//
// Per adr-040: estes checks são gating determinístico, complementares
// (não substitutos) ao design review advisory feito por
// validate-adr.cue. Per princípio canônico (founder Phase 5):
// "Quando CUE não consegue expressar a regra, o enforcement deve
// subir para CI structural-check — não virar convenção."
//
// sc-adr-01 materializa enforcement determinístico de tq-adr-04
// (severity fail no schema #ADR) usando kind at-least-one-block-present
// — kind introduzido por decisão de schema evolution para suportar
// constraints "at-least-one-of-N" que CUE schema não consegue expressar
// declarativamente sobre fields opcionais (ver ADR correspondente).
//
// Layered enforcement (schema valida conteúdo → check valida existência):
// - Schema #ADRBase: cada path em affectedArtifacts/plannedOutputs/
//   derivedArtifacts é string non-empty (`string & !=""`) — VALIDA
//   CONTEÚDO de elementos quando a lista existe.
// - sc-adr-01: ao menos um dos 3 blocos é presente como lista non-empty
//   (≥1 elemento) — VALIDA EXISTÊNCIA de impacto declarado.
// - Combinação: ADR sem impacto = bloqueado por sc-adr-01; ADR com
//   impacto declarado mas elementos vazios = bloqueado por schema.

structuralChecks: "sc-adr-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-adr-01"
	title:        "ADR tem impacto rastreável (≥1 de affectedArtifacts/plannedOutputs/derivedArtifacts populado)"
	artifactType: "adr"
	description:  "Para cada ADR em architecture/adrs/adr-XXX-*.cue, ao menos um dos 3 blocos de rastreabilidade deve estar presente E non-empty (lista com ≥1 elemento válido): affectedArtifacts (paths existentes alterados), plannedOutputs (paths novos criados pela decisão como output direto, per adr-059), OR derivedArtifacts (paths regenerados como consequência indireta). ADR sem ao menos um destes é decoração — derrota propósito de governança proporcional. Constraint at-least-one não enforce-ável em CUE schema (closed-struct semantics + limites de disjunção sobre optional fields, vide comentário em #ADRBase line ~71-74); enforcement determinístico via este structural-check usando kind at-least-one-block-present. Layered separation: schema valida CONTEÚDO de elementos (cada path é string non-empty); sc-adr-01 valida EXISTÊNCIA de impacto declarado (lista non-empty)."
	kind:         "at-least-one-block-present"
	rule: {
		blockNames: [
			"affectedArtifacts",
			"plannedOutputs",
			"derivedArtifacts",
		]
	}
	errorMessage: "ADR sem ao menos um dos blocos affectedArtifacts/plannedOutputs/derivedArtifacts populado (listas vazias [] também são inválidas — exigem ≥1 elemento) é decoração sem impacto rastreável. Adicione paths em affectedArtifacts (existentes alterados), OR plannedOutputs (paths novos criados como output direto, per adr-059), OR derivedArtifacts (paths regenerados como consequência indireta) — discipline 3-way. Pelo menos um bloco deve ser non-empty (≥1 elemento) para passar gate determinístico."
	rationale:    "Materializa enforcement determinístico de tq-adr-04 (severity fail no schema #ADR). Per adr-040 layered separation: CUE schema enforça shape (cada elemento é string non-empty); structural-check enforça constraints relacionais que CUE schema não expressa (lista non-empty); CI runner executa structural-checks como gate bloqueante. Combinação cobre ambas dimensões: (1) ADR sem impacto declarado falha sc-adr-01; (2) ADR com lista contendo elementos vazios falha schema. Caso degenerate (single blockName) explicitamente rejeitado pelo schema #AtLeastOneBlockPresentRule (min 2 blockNames) — degenerate case = required-block kind existente."
}
