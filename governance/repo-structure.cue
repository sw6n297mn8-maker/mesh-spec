package governance

// repo-structure.cue — Escopo e algoritmo de validação estrutural.
//
// Este artefato NÃO declara a árvore do filesystem nem onde cada tipo
// de artefato vive. Essa responsabilidade é de cada artifact schema
// (campo _schema.location). Este artefato declara:
//   1. Quais diretórios CI deve validar (scope)
//   2. Quais paths CI deve ignorar (excluded)
//   3. Segmentos de path compartilhados (pathSegments) — single source
//      para fragments usados por múltiplos schemas
//   4. O algoritmo de classificação e validação (validation)

repoStructure: #RepoStructure

#RepoStructure: {
	rationale: string & !=""
	scope:     #Scope
	pathSegments:  #PathSegments
	validation:    #Validation
}

#Scope: {
	validated: [...string & !=""]
	excluded:  [...string & !=""]
	rationale: string & !=""
}

#PathSegments: {
	bcRoot:         string & !=""
	bcCodePattern:  string & !=""
	domainRoot:     string & !=""
	strategicRoot:  string & !=""
	archRoot:       string & !=""
	governanceRoot: string & !=""
	aiRoot:         string & !=""
	rationale:      string & !=""
}

#FileClassification: {
	strategy:  string & !=""
	rationale: string & !=""
	steps: [string & !="", ...string & !=""]
}

#UnmatchedFilePolicy: {
	rule:      string & !=""
	rationale: string & !=""
	behavior:  string & !=""
}

#ValidationPhase: {
	id:        string & !=""
	rationale: string & !=""
	includes: [string & !="", ...string & !=""]
	dependsOn: [...string & !=""]
}

#ImplementationGuidance: {
	rationale:   string & !=""
	incremental: {[string]: string}
}

#Validation: {
	rationale:              string & !=""
	fileClassification:     #FileClassification
	unmatchedFilePolicy:    #UnmatchedFilePolicy
	phases: [#ValidationPhase, ...#ValidationPhase]
	implementationGuidance: #ImplementationGuidance
}

// ── Instância ──

repoStructure: {
	rationale: "Separar escopo de validação (aqui) de regras por tipo (nos schemas) evita arquivo central monolítico e elimina single point of failure."

	scope: {
		validated: [
			"domain/",
			"strategic/",
			"contexts/",
			"architecture/",
			"governance/",
			"ai-orchestration/",
		]
		excluded: [
			"cue.mod/",
			".git/",
			".github/",
			".gitignore",
			"LICENSE",
			"CODEOWNERS",
			"Taskfile.yml",
			"README.md",
			"CLAUDE.md",
		]
		rationale: "Arquivos em excluded são exceções P2 (README.md, CLAUDE.md) ou impostos por plataforma (.github/, .gitignore, etc). CI não os classifica contra schemas."
	}

	pathSegments: {
		bcRoot:         "contexts"
		bcCodePattern:  "[a-z][a-z0-9-]*"
		domainRoot:     "domain"
		strategicRoot:  "strategic"
		archRoot:       "architecture"
		governanceRoot: "governance"
		aiRoot:         "ai-orchestration"
		rationale:      "Renomear um diretório raiz exige 1 edição aqui. Schemas referenciam estes segmentos em vez de hardcodar paths."
	}

	validation: {
		rationale: "Declara o algoritmo que CI implementa. Mudança aqui = mudança no CI pipeline."

		fileClassification: {
			strategy:  "exclusive-schema-match"
			rationale: "Cada arquivo faz match em exatamente 1 schema pelo path. Ambiguidade é bug nos schemas, não no arquivo."
			steps: [
				"Filtrar arquivos por scope.validated, excluir scope.excluded",
				"Para cada arquivo .cue, testar canonicalPathPattern de todos os schemas que declaram _schema.location",
				"Exatamente 1 match → validar conteúdo contra aquele schema",
				"Zero matches → aplicar unmatchedFilePolicy",
				"2+ matches → erro nos schemas (patterns sobrepostos — corrigir schemas)",
			]
		}

		unmatchedFilePolicy: {
			rule:      "conditional-on-schema-existence"
			rationale: "Governança cresce com o repo. Cada schema criado é enforcement imediato para seu tipo. Sem transição manual de fase."
			behavior: """
				Para cada arquivo sem match em nenhum schema:
				- Se nenhum schema no repo declara location para aquele
				  segmento de path → warn (tipo ainda não governado)
				- Se existe schema para o segmento mas o arquivo não
				  conforma com fileNamePattern → reject
				Quando o último tipo ganha schema com location,
				todos os arquivos passam a ter match potencial.
				A transição bootstrap→produção é emergente.
				"""
		}

		phases: [
			{
				id:        "schema-conformance"
				rationale: "Valida estrutura individual antes de avaliar relações entre artefatos."
				includes: ["cue vet contra artifact schemas com _schema.location"]
				dependsOn: []
			},
			{
				id:        "completeness"
				rationale: "Só executa após schema-conformance garantir que canvas é válido e campos condition são resolvíveis."
				includes: ["bounded-context-completeness"]
				dependsOn: ["schema-conformance"]
			},
		]

		implementationGuidance: {
			rationale: "CI não precisa existir completo no dia 1. Cada phase é independentemente implementável."
			incremental: {
				"schema-conformance":  "cue vet nativo — funciona hoje sem tooling custom"
				"file-classification": "script que extrai canonicalPathPattern dos schemas e testa contra arquivos em scope"
				completeness:          "script que resolve conditions do completeness contra canvas de cada BC"
			}
		}
	}
}
