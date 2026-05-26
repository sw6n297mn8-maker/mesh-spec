package artifact_schemas

// repo-structure.cue — Schema portfolio-wide para governance/repo-structure.cue.
//
// Governa escopo de validação, artefatos derivados, fases de CI,
// classificação de arquivos e fronteira de responsabilidade de cada
// repo do portfólio.
//
// Origem: promovido de mesh-spec local (ADR-008 de tekton-spec).
// Generalização: #PathSegments é struct aberta (cada repo define
// seus segmentos); demais 11 sub-tipos promovidos sem alteração.
//
// Convenção: instância é singleton em governance/repo-structure.cue.
// #Tooling é tipo auxiliar recomendado para desacoplar scripts do
// nome da instância — não obrigatório pelo schema, documentado no
// production guide.

// ── Raiz ──

#RepoStructure: {
	rationale:              string & !=""
	scope:                  #Scope
	pathSegments:           #PathSegments
	responsibilityBoundary: #ResponsibilityBoundary
	derivedArtifacts:       #DerivedArtifacts
	validation:             #Validation

	_schema: {
		location: {
			canonicalPathRegex: "^governance/repo-structure\\.cue$"
			fileNameRegex:      "^repo-structure\\.cue$"
			description:        "Escopo de validação, artefatos derivados, fases de CI e fronteira de responsabilidade do repo."
			rationale:          "Singleton em governance/ de cada repo. Consumido por CI (classificação, phases, derived-sync) e por tooling (excludedPaths). Sem este artefato, escopo de validação é implícito."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-rs-01"
			description: "Scope declara pelo menos um diretório validado"
			test:        "scope.validated tem ao menos 1 item. Enforçado por shape (list MinItems implícito via uso — repos sem diretórios validados não precisam do artefato)."
			severity:    "warn"
			rationale:   "Scope vazio torna o artefato inoperante — existe mas não governa nada."
		}, {
			id:          "tq-rs-02"
			description: "DerivedArtifacts tem ao menos um artefato"
			test:        "derivedArtifacts.artifacts satisfaz [#DerivedArtifact, ...#DerivedArtifact] (pelo menos 1). Enforçado por shape."
			severity:    "fail"
			rationale:   "Todo repo do portfólio tem ao menos README.md ou CLAUDE.md como derivado — ausência indica artefato incompleto."
		}, {
			id:          "tq-rs-03"
			description: "Generator é comando stdout-only"
			test:        "Cada derivedArtifacts.artifacts[].generator não contém redirecionamento (> ou >>). Convenção: generator escreve em stdout; regeneração segue padrão 'generator > path'. Advisory — não enforçável por regex simples em todos os casos."
			severity:    "warn"
			rationale:   "Generator stdout-only permite que derived-artifact-sync compare output com arquivo existente sem efeito colateral. Generator que escreve diretamente impede comparação."
		}, {
			id:          "tq-rs-04"
			description: "ResponsibilityBoundary declara owns e doesNotOwn"
			test:        "responsibilityBoundary.owns e doesNotOwn têm ao menos 1 item cada. Enforçado por shape."
			severity:    "fail"
			rationale:   "Fronteira sem 'não governa' é fronteira sem limite — smell de god artifact."
		}]
		rationale: "Critérios garantem que repo-structure é operacional (scope não-vazio, derivados declarados, generator stdout-only) e tem fronteira explícita (owns + doesNotOwn). 2 fail shape-enforced + 2 warn advisory."
	}
}

// ── Scope ──

#Scope: {
	validated: [...string & !=""]
	excluded:  [...string & !=""]

	// Zonas engine/config (adr-098): prefixos DENTRO de validated (cue vet
	// aplica) mas FORA do regime de classificação por artifact-schema-instance —
	// maquinaria de governança/build-time, não tipos de artefato instanciáveis.
	// Opcional (default ausente = []); aditivo a repos sem o conceito.
	schemaExemptZones?: [...string & !=""]

	rationale: string & !=""
}

// ── Path segments ──
//
// Struct aberta: cada repo define seus segmentos conforme sua estrutura.
// Generalização de mesh-spec (que tinha campos fixos bcRoot, domainRoot, etc.).

#PathSegments: {
	{[string]: string}
	rationale: string & !=""
}

// ── Responsibility boundary ──

#ResponsibilityBoundary: {
	owns:       [string & !="", ...string & !=""]
	doesNotOwn: [string & !="", ...string & !=""]
	rationale:  string & !=""
}

// ── Derived artifacts ──

#DerivedArtifact: {
	path:      string & !=""
	source:    string & !=""
	generator: string & !=""
	blockId?:  string & !=""
	rationale: string & !=""
}

#DerivedArtifacts: {
	artifacts: [#DerivedArtifact, ...#DerivedArtifact]
	rationale: string & !=""
}

// ── File classification ──

#FileClassificationCategory: {
	description: string & !=""
}

#FileClassificationPolicy: {
	mapping:   {[string]: "reject" | "warn" | "info" | "ignore" | "validate-conformance"}
	actions:   {[string]: string}
	rationale: string & !=""
}

#FileClassification: {
	strategy:   string & !=""
	rationale:  string & !=""
	steps:      [string & !="", ...string & !=""]
	categories: {[string]: #FileClassificationCategory}
	policy:     #FileClassificationPolicy
}

// ── Validation ──

#ValidationPhase: {
	id:        string & !=""
	rationale: string & !=""
	includes:  [string & !="", ...string & !=""]
	dependsOn: [...string & !=""]
}

#ImplementationGuidance: {
	rationale:   string & !=""
	incremental: {[string]: string}
}

#Validation: {
	rationale:              string & !=""
	fileClassification:     #FileClassification
	phases:                 [#ValidationPhase, ...#ValidationPhase]
	implementationGuidance: #ImplementationGuidance
}

// ── Tooling entrypoint ──
//
// Tipo auxiliar recomendado (não obrigatório no #RepoStructure).
// Desacopla scripts do nome da instância de #RepoStructure.
// Repos que usam definem top-level:
//   tooling: #Tooling & { excludedPaths: repoStructure.scope.excluded }

#Tooling: {
	excludedPaths: [...string & !=""]
}
