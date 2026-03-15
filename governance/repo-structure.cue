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
//   5. Limite explícito de responsabilidade (responsibilityBoundary)

repoStructure: #RepoStructure

#RepoStructure: {
	rationale: string & !=""
	scope:     #Scope
	pathSegments:           #PathSegments
	responsibilityBoundary: #ResponsibilityBoundary
	validation:             #Validation
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

#ResponsibilityBoundary: {
	owns:       [string & !="", ...string & !=""]
	doesNotOwn: [string & !="", ...string & !=""]
	rationale:  string & !=""
}

#FileClassificationCategory: {
	description: string & !=""
}

#FileClassificationPolicy: {
	mapping: {[string]: "reject" | "warn" | "info" | "ignore" | "validate-conformance"}
	actions: {[string]: string}
	rationale: string & !=""
}

#FileClassification: {
	strategy:   string & !=""
	rationale:  string & !=""
	steps:      [string & !="", ...string & !=""]
	categories: {[string]: #FileClassificationCategory}
	policy:     #FileClassificationPolicy
}

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
			"SESSION-CONTEXT.md",
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

	responsibilityBoundary: {
		owns: [
			"Escopo de validação: quais raízes o CI valida",
			"Exclusões globais: quais paths o CI ignora",
			"Path segments compartilhados: vocabulário de raízes estruturais",
			"Fases de validação: ordem e contrato de cada fase",
			"Classificação de arquivos: algoritmo de match file→schema",
			"Política de classificação: mapeamento categoria→ação do CI",
		]
		doesNotOwn: [
			"Quais artifact types existem — responsabilidade dos schemas em architecture/artifact-schemas/",
			"Onde cada tipo vive — responsabilidade do campo _schema.location de cada schema",
			"O que é obrigatório por BC — responsabilidade de governance/bounded-context-completeness.cue",
			"Convenções de naming por tipo — responsabilidade do schema do tipo",
			"Semântica de campos de domínio — responsabilidade dos schemas de domínio",
		]
		rationale: "Limite explícito previne absorção gradual de responsabilidades que pertencem a outros artefatos. Sem fronteira declarada, repo-structure.cue tende a virar single point of failure — exatamente o que a abordagem type-centric visa evitar."
	}

	validation: {
		rationale: "Declara o algoritmo que CI implementa. Mudança aqui = mudança no CI pipeline."

		fileClassification: {
			strategy:  "exclusive-schema-match"
			rationale: "Cada arquivo faz match em exatamente 1 schema pelo path. Ambiguidade é bug nos schemas, não no arquivo."
			steps: [
				"Filtrar arquivos por scope.validated, excluir scope.excluded",
				"Para cada arquivo .cue, testar canonicalPathRegex de todos os schemas que declaram _schema.location",
				"Classificar cada arquivo em exatamente 1 categoria de fileClassification.categories",
				"Aplicar fileClassification.policy.mapping para determinar ação do CI",
			]

			// Eixo A: categorias de classificação.
			// Observações do mundo — não carregam ação.
			categories: {
				"outside-scope": {
					description: "Arquivo fora de scope.validated ou em scope.excluded."
				}
				matched: {
					description: "Path do arquivo faz match com exatamente 1 schema."
				}
				ambiguous: {
					description: "Path do arquivo faz match com 2+ schemas. Indica sobreposição nos patterns dos schemas."
				}
				"unmatched-governed-with-schemas": {
					description: "Arquivo em zona governada (dentro de scope.validated) onde existem schemas para aquela raiz, mas nenhum cobre este arquivo."
				}
				"unmatched-governed-without-schemas": {
					description: "Arquivo em zona governada onde nenhum schema governa aquela raiz ainda."
				}
			}

			// Eixo B: política de resposta por categoria.
			// Mutável independentemente das categorias.
			policy: {
				mapping: {
					"outside-scope":                     "ignore"
					matched:                             "validate-conformance"
					ambiguous:                           "reject"
					"unmatched-governed-with-schemas":    "warn"
					"unmatched-governed-without-schemas": "info"
				}
				actions: {
					reject:                 "CI falha. Arquivo não pode ser mergeado."
					warn:                   "CI reporta warning. Merge não bloqueado, mas visível em review."
					info:                   "CI registra para visibilidade. Sem impacto no merge."
					ignore:                 "CI não processa o arquivo."
					"validate-conformance": "CI valida o arquivo contra o schema matched."
				}
				rationale: "Separar classificação de política permite evoluir severidade por zona sem alterar o modelo de categorias. Exemplo: quando uma zona amadurece, basta mudar a ação de 'warn' para 'reject' sem redesenhar a taxonomia."
			}
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
			{
				id:        "adr-coverage"
				rationale: "Garante que toda mudança semântica em zonas governadas tem decisão rastreável. Sem enforcement determinístico, governança de ADR depende de disciplina de agente — insuficiente para o modelo de robustez da Mesh."
				includes: [
					"Se diff contém arquivos alterados em architecture/ ou governance/ (exceto architecture/adrs/)",
					"Então o mesmo commit/PR deve conter pelo menos 1 ADR novo ou alterado em architecture/adrs/",
					"E pelo menos 1 dos ADRs deve referenciar ao menos 1 path do diff em affectedArtifacts",
				]
				dependsOn: ["schema-conformance"]
			},
			{
				id:        "adr-consistency"
				rationale: "Valida invariants relacionais entre ADRs que o schema de arquivo isolado não consegue expressar: existência de referências, simetria de cadeia e ausência de ciclos."
				includes: [
					"Se ADR.status == superseded, o ADR referenciado em supersededBy deve existir",
					"Se ADR-B.supersedes contém ADR-A, então ADR-A deve ter status == superseded e supersededBy == ADR-B",
					"Nenhum ADR pode referenciar a si mesmo em supersedes ou supersededBy",
					"O grafo de supersession deve ser acíclico (DAG)",
				]
				dependsOn: ["schema-conformance"]
			},
		]

		implementationGuidance: {
			rationale: "CI não precisa existir completo no dia 1. Cada phase é independentemente implementável."
			incremental: {
				"schema-conformance":  "cue vet nativo — funciona hoje sem tooling custom"
				"file-classification": "script que extrai canonicalPathRegex dos schemas e testa contra arquivos em scope"
				completeness:          "script que resolve conditions do completeness contra canvas de cada BC"
				"adr-coverage":        "script que compara diff de architecture/ e governance/ contra ADRs no mesmo PR; parseia affectedArtifacts dos .cue em architecture/adrs/"
				"adr-consistency":     "script que parseia todos os ADRs em architecture/adrs/, monta grafo dirigido de supersession (supersedes/supersededBy) e valida existência, simetria e acyclicity"
			}
		}
	}
}
