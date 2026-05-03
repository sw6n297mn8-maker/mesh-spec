package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// deferred-decision.cue — Structural checks determinísticos para
// deferimentos conscientes governados (per adr-062).
//
// V1 minimal: kinds atuais (per adr-049 + adr-056) suportam apenas
// checks within-artifact e file-presence-conditional. Cross-file
// reference checking, regex pattern conformance, e cross-package
// type resolution permanecem fora do framework structural-check
// (per adr-041). Expansão futura via ADR análogo a adr-049 quando
// caso concreto justificar.
//
// Per adr-062 known gaps declarados: structural-checks de def-XXX
// são minimais inicialmente. Schema enforcement via cue vet
// (discriminated union sobre status; #Trigger union; OriginRef
// union) já cobre boa parte do shape. Validation-prompt vp-deferred-
// decision (advisory) cobre dimensões interpretativas.

// Sem checks structurais ativos no V1 — gaps deliberados:
//
// - sc-def-01 (originatingArtifacts paths existem no FS): exige kind
//   filesystem-path-exists não disponível.
// - sc-def-02 (resolvedBy path existe quando status=resolved): mesmo
//   gap.
// - sc-def-03 (adjacent-need.path existe ao escrever def-XXX): mesmo
//   gap. Note: NÃO é o mesmo que avaliar trigger fired — é validar
//   que o path declarado é referência real (não typo).
//
// Quando filesystem-path-exists kind for adicionado (caso concreto
// agregado de def-XXX + outros tipos justificar), criar sc-def-01..03
// neste arquivo.
//
// File deliberately empty of structural-check instances — placeholder
// para coverage future. cue vet passes (file is valid CUE com package
// declaration + import).

_unused: artifact_schemas.#StructuralCheck // suppress unused import warning
