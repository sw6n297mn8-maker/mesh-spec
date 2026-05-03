package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// production-guide.cue — Structural check determinístico para cobertura
// universal de production-guides.
//
// Per adr-056: kind production-guide-coverage materializa enforcement
// de adr-053 (cobertura universal de PGs para schemas instanciáveis)
// + adr-054 dec 13 (cascade ordering — PG existe ANTES de autoria de
// instância). Antes regras prose-only em CLAUDE.md / ADRs; agora
// gating determinístico (per adr-040 separation determinístico vs
// advisory).
//
// Rule nasce verde com 7 PGs já existentes em architecture/production-
// guides/ no momento desta autoria; cresce por change-on-touch quando
// novo PG é committed (schema name adicionado a coveredSchemas no
// MESMO commit). Runner futuro consome coveredSchemas para verificar
// existência architecture/production-guides/{nome}.cue; rule fica
// latente até runner ativar — alinhado com validatorNote do
// PG-StructuralCheck.

structuralChecks: "sc-pg-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-pg-01"
	title:        "Schemas em coveredSchemas exigem production-guide existente"
	artifactType: "production-guide"
	description:  "Para cada nome em rule.coveredSchemas, verificar que architecture/production-guides/{nome}.cue existe e conforma com #ProductionGuide. Whitelist explícita evita CI surpresa por auto-discovery; expansão deliberada por change-on-touch quando novo PG é committed."
	kind:         "production-guide-coverage"
	rule: {
		coveredSchemas: [
			"agent-spec",
			"agent-governance",
			"glossary",
			"domain-model",
			"production-guide",
			"structural-check",
			"adr",
		]
	}
	errorMessage: "Schema '{nome}' está declarado em coveredSchemas mas o arquivo architecture/production-guides/{nome}.cue não existe. Cascade ordering (adr-054 dec 13) exige PG ANTES de autoria de qualquer instância do schema. Crie o PG via meta-PG (architecture/production-guides/production-guide.cue) ou remova o nome de coveredSchemas se cobertura para este schema foi descontinuada."
	rationale:    "Cobre o gap entre cobertura universal de PGs (adr-053) declarada e cascade ordering (adr-054 dec 13) declarado: ambos eram regras prose-only, agora são gating determinístico per adr-040 separation. derivedFromInvariant: discovery 2026-05-01 (idc-primary-agent.cue commit b248178 — authoring de instância sem founder review section-by-section apesar de PG-A existir). enforcementLevel: runner (gate determinístico pós-commit, latente até runner ativar). Whitelist com 7 schemas — 5 já existentes antes desta sequência (agent-spec, agent-governance, glossary, domain-model, production-guide meta) + structural-check + adr criados nesta sequência (commits 64a44e0 e 3d6b7e3). Rule nasce verde — primeiro uso é proteção contra remoção acidental, não débito retroativo."
}
