package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// first-class-traceability.cue — Gate de rastreabilidade semântica first-class
// (adr-153, materializa adr-151 D1 + passo v do D2). UM kind/evaluator
// (ev_first_class_traceability) constrói o índice conceito↔termo 1× (P0) e emite os
// 9 findings: G1–G5 (Forma A owned) + B1–B4 (Forma B shared). Determinístico:
// norm() exato + pertinência de conjunto, zero heurística/LLM (P10).
//
// Born-warn (catraca adr-097): a Forma A não foi backfillada (48 conceitos
// cross-contract, 0 firstClass), todos reconhecidos na worklist; promove a reject
// (passo vi do adr-151) quando a worklist fechar.

structuralChecks: {
	"sc-fct-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-fct-01"
		title:        "Rastreabilidade semântica first-class: G1–G5 (owned) + B1–B4 (shared)"
		artifactType: "domain-model"
		description:  "Para cada conceito do domain-model que CRUZA CONTRATO (V1: membership em aggregate-manifest — commandsAccepted/eventsEmitted/aggregateRef; port-manifest e assertion deferidos em def-063/def-049; invariants excluídos = alvos), exige firstClass+firstClassReason declarado OU entrada na worklist (G2). Verifica cobertura dedicada owned (G1: termo termEn==coreNoun que referencia o conceito), integridade dos elos termo↔conceito (G3 ref-existe + correspondência; G4 nenhum termo aponta firstClass:false), e o link de primitivo compartilhado (B1–B4 Forma B: termo canônico no kernel, canonicalTermRef declarado/resolvível, coreNoun correspondente quando declarado). G5 (razão-tipada) é coberto por cue vet via enum #FirstClassReason (adr-151 3a), não re-checado aqui."
		kind:         "first-class-traceability"
		rule: {}
		errorMessage: "first-class-traceability: conceito que cruza contrato sem firstClass declarado (nem na worklist), OU termo dedicado ausente/incorreto (coreNoun↔termEn), OU ref de glossário quebrado, OU link Forma B inválido (canonicalTermRef sem âncora no kernel). Declare firstClass+firstClassReason+coreNoun + termo dedicado no glossário, OU registre a pendência em governance/build-time/first-class-backfill-worklist.cue."
		rationale:    "adr-153: a obrigação de rastreabilidade first-class (adr-151) vira gate determinístico no CI (P12), não boa intenção. O conceito-central-sem-termo (gatilho do adr-151: Payment no FCE) não reaparece em silêncio. Born-warn enquanto a campanha de backfill Forma A drena a worklist; promove a reject (passo vi do adr-151) quando todo cross-contract estiver declarado-ou-na-worklist."
		enforcement:  "warn"
	}
}
