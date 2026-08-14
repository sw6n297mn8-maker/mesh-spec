package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// design-system-constitution.cue — Structural checks determinísticos para
// a Constituição do Design System (adr-194).
//
// A instância é UMA Constituição lógica COMPOSTA por 3 arquivos do
// package design_system (merge de structs CUE): constitution.cue +
// canonical-cases.cue + token-contract.cue. Essa forma multi-arquivo
// delimita o que o runner V1 alcança: os evaluators baseados em
// instância (required-block, same-artifact-consistency, local-field-
// reference-integrity) carregam artefatos POR ARQUIVO (`cue export
// <file>`) — cada arquivo é parcial e não exporta sozinho, então um
// check desses seria VACUAMENTE verde (skip silencioso), cartaz sem
// fiscal de outra espécie. Honestidade sobre o alcance:
//
// - Integridade de derivesFrom (todo token aponta camada/seção
//   existente) é enforçada por CUE VET via enum fechado
//   #DerivationSource no schema (P14: invariante expressável em tipo é
//   forçado em compile-time) — camada MAIS forte que um check
//   pós-commit; não duplicada aqui.
// - A garantia determinística que RESTA a este runner e é real (não
//   vácua): a CO-PRESENÇA dos arquivos que compõem o singleton lógico.
//   Deleção parcial (ex.: token-contract.cue removido, constitution.cue
//   fica) quebraria a instância silenciosamente — o gêmeo do risco que
//   sc-sg-01 trava para singletons de path literal, que não alcança
//   este tipo (canonicalPathRegex de diretório, não-literal, fora do
//   V1 do singleton-coverage).
//
// Born-warn per adr-097 (catraca): promoção a reject é decisão
// por-check posterior.

structuralChecks: "sc-dsc-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-dsc-01"
	title:        "Constituição composta: canonical-cases exige constitution (e vice-versa)"
	artifactType: "design-system-constitution"
	description:  "architecture/design-system/canonical-cases.cue e architecture/design-system/constitution.cue existem JUNTOS ou nenhum existe. A jurisprudência (VIII) é campo da mesma instância que a lei (I-VII, IX) — arquivo órfão é instância quebrada por deleção parcial."
	kind:         "directory-pair-coverage"
	rule: {
		sourceGlob:    "architecture/design-system/canonical-cases.cue"
		targetGlob:    "architecture/design-system/constitution.cue"
		bidirectional: true
	}
	errorMessage: "Par da Constituição quebrado: canonical-cases.cue e constitution.cue devem coexistir em architecture/design-system/ (instância única composta por merge de structs — adr-194). Restaure o arquivo ausente ou remova o par completo com emenda via ADR (cláusula IX)."
	rationale:    "A instância multi-arquivo fica fora do alcance do singleton-coverage V1 (regex não-literal) e dos evaluators por-arquivo (arquivo parcial não exporta — check de conteúdo seria vacuamente verde). Co-presença é a garantia determinística real disponível: trava de deleção parcial, gêmea do sc-sg-01. derivedFromInvariant: unicidade lógica declarada em _schema.location do schema (adr-194)."
}

structuralChecks: "sc-dsc-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-dsc-02"
	title:        "Constituição composta: token-contract exige constitution (e vice-versa)"
	artifactType: "design-system-constitution"
	description:  "architecture/design-system/token-contract.cue e architecture/design-system/constitution.cue existem JUNTOS ou nenhum existe. O contrato de tokens (B/VII) é campo da mesma instância que as camadas que os autorizam — token sem camada é valor sem decisão (viola 'nenhum valor entra sem referência à decisão que o autoriza', VII)."
	kind:         "directory-pair-coverage"
	rule: {
		sourceGlob:    "architecture/design-system/token-contract.cue"
		targetGlob:    "architecture/design-system/constitution.cue"
		bidirectional: true
	}
	errorMessage: "Par da Constituição quebrado: token-contract.cue e constitution.cue devem coexistir em architecture/design-system/ (instância única composta por merge de structs — adr-194). Restaure o arquivo ausente ou remova o par completo com emenda via ADR (cláusula IX)."
	rationale:    "Direção complementar de sc-dsc-01 para o segundo arquivo componente. Juntos, os dois checks garantem que os 3 arquivos da instância só existem como conjunto completo — deleção parcial vira finding determinístico, não silêncio. A integridade interna (derivesFrom → camada) já é compile-time via enum fechado no schema (P14)."
}
