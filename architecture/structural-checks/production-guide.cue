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
			"deferred-decision",
			"tension-entry",
			"port-manifest",
			"aggregate-manifest",
			"golden-example",
		]
	}
	errorMessage: "Schema '{nome}' está declarado em coveredSchemas mas o arquivo architecture/production-guides/{nome}.cue não existe. Cascade ordering (adr-054 dec 13) exige PG ANTES de autoria de qualquer instância do schema. Crie o PG via meta-PG (architecture/production-guides/production-guide.cue) ou remova o nome de coveredSchemas se cobertura para este schema foi descontinuada."
	rationale:    "Cobre o gap entre cobertura universal de PGs (adr-053) declarada e cascade ordering (adr-054 dec 13) declarado: ambos eram regras prose-only, agora são gating determinístico per adr-040 separation. derivedFromInvariant: discovery 2026-05-01 (idc-primary-agent.cue commit b248178 — authoring de instância sem founder review section-by-section apesar de PG-A existir). enforcementLevel: runner (gate determinístico pós-commit, latente até runner ativar). Whitelist com 7 schemas — 5 já existentes antes desta sequência (agent-spec, agent-governance, glossary, domain-model, production-guide meta) + structural-check + adr criados nesta sequência (commits 64a44e0 e 3d6b7e3). Rule nasce verde — primeiro uso é proteção contra remoção acidental, não débito retroativo."
}

// sc-pg-02 + sc-pg-03 (per adr-063): bidirectional workOrder ↔ sections
// consistency. Materializa tq-pg-01 do schema (workOrder == keys(sections))
// como gating determinístico via 2 checks unidirecionais (relation
// 'every-reference-must-exist-as-entry' do same-artifact-consistency
// kind é one-way).

structuralChecks: "sc-pg-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-pg-02"
	title:        "workOrder elements devem existir como sections keys"
	artifactType: "production-guide"
	description:  "Cada elemento em production-guide.workOrder deve aparecer como key em sections. workOrder é a sequência ordenada que o agente segue durante autoria; element em workOrder sem section correspondente quebra o protocolo (agente seria instruído a executar section que não existe). Direção 1 de 2 da bidirecional workOrder ↔ sections — sc-pg-03 cobre direção reversa."
	kind:         "same-artifact-consistency"
	rule: {
		referencingBlock: "workOrder"
		definingBlock:    "sections"
		relation:         "every-reference-must-exist-as-entry"
	}
	errorMessage: "production-guide.workOrder contém elemento que não existe como section key. Agente seguindo workOrder seria instruído a executar section ausente. Adicione a section ausente OU remova o elemento de workOrder. Ambos os blocks devem manter consistência bidirecional (sc-pg-03 cobre direção reversa)."
	rationale:    "Materializa tq-pg-01 do schema (workOrder == keys(sections)) como gating determinístico per adr-040 split. Schema enforce shape (cada item ∈ string); este check enforce coherence relacional. derivedFromInvariant: 'workOrder deve ser permutação das chaves de sections' declarado em comment do #ProductionGuide schema desde adr-053."
}

structuralChecks: "sc-pg-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-pg-03"
	title:        "sections keys devem aparecer em workOrder"
	artifactType: "production-guide"
	description:  "Cada key de production-guide.sections deve aparecer como elemento em workOrder. Section sem reference em workOrder é trabalho declarado mas nunca executado pelo agente — section órfão. Direção 2 de 2 da bidirecional workOrder ↔ sections — sc-pg-02 cobre direção reversa."
	kind:         "same-artifact-consistency"
	rule: {
		referencingBlock: "sections"
		definingBlock:    "workOrder"
		relation:         "every-reference-must-exist-as-entry"
	}
	errorMessage: "production-guide.sections contém key que não aparece em workOrder. Section órfão é trabalho declarado mas nunca executado. Adicione a key em workOrder na posição apropriada OU remova a section. Ambos os blocks devem manter consistência bidirecional (sc-pg-02 cobre direção reversa)."
	rationale:    "Direção complementar de sc-pg-02. Conjuntamente, sc-pg-02 + sc-pg-03 enforce permutação completa workOrder ↔ keys(sections) que tq-pg-01 declarava como tech debt structural ('Enforçado por structural check ou CI'). Bidirecional via 2 checks porque relation do same-artifact-consistency kind é one-way."
}
