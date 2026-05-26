package governance

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// repo-structure.cue — Escopo e algoritmo de validação estrutural.
//
// Schema #RepoStructure e sub-tipos adotados verbatim de tekton-spec v0.3.0
// via governance/adopted-artifacts.cue (ADR-052). Schema local anterior
// removido — mesh-spec foi autor original (base de ADR-008 de tekton); com
// promoção concluída, fechamos o ciclo adotando o schema portfolio-wide.
//
// Este artefato NÃO declara a árvore do filesystem nem onde cada tipo de
// artefato vive. Essa responsabilidade é de cada artifact schema (campo
// _schema.location). Este artefato declara:
//   1. Quais diretórios CI deve validar (scope)
//   2. Quais paths CI deve ignorar (excluded)
//   3. Segmentos de path compartilhados (pathSegments) — single source para
//      fragments usados por múltiplos schemas
//   4. O algoritmo de classificação e validação (validation)
//   5. Limite explícito de responsabilidade (responsibilityBoundary)
//   6. Artefatos derivados com source e comando de geração (derivedArtifacts)
//
// Nota sobre #PathSegments: schema portfolio-wide é struct aberta
// ({[string]: string} + rationale) em vez de campos fixos. Mesh-spec preserva
// os mesmos nomes (bcRoot, bcCodePattern, etc.) como keys — equivalência
// semântica sem perda de documentação.

repoStructure: artifact_schemas.#RepoStructure & {
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
			"scripts/",
		]
		schemaExemptZones: [
			"governance/build-time/",
			"governance/claude/",
			"architecture/conventions/",
		]
		rationale: "Arquivos em excluded são exceções P2 (README.md, CLAUDE.md), impostos por plataforma (.github/, .gitignore, etc.), ou tooling operacional de CI (scripts/). scripts/ está fora da classificação por artifact schemas, mas continua sujeito às convenções gerais do repositório. CLAUDE.md é adicionalmente governado por derivedArtifacts — sync validado na phase derived-artifact-sync. schemaExemptZones (adr-098) são zonas engine/config governadas por cue vet + checks próprios, mas fora da classificação por artifact-schema-instance: governance/build-time/ (engine de work-governance + config de build-time, subsume task-specs/work-events/projections), governance/claude/ (subsistema de renderização do CLAUDE.md) e architecture/conventions/ (documentos de convenção, não tipos instanciáveis)."
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

	derivedArtifacts: {
		artifacts: [{
			path:      "CLAUDE.md"
			source:    "governance/claude/config.cue"
			generator: "cue export ./governance/claude -e output --out text"
			rationale: "CLAUDE.md é exceção P2 (markdown), mas conteúdo é gerado a partir de config.cue. Edição direta é drift por construção."
		}, {
			path:      "README.md"
			source:    "governance/readme/config.cue"
			generator: "cue export ./governance/readme -e output --out text"
			rationale: "README.md é exceção P2 (markdown) materializada como derivado integral. Source é config.cue (instância de #ReadmeConfig); template fixo em governance/readme/output.cue completa o pipeline. Sync validado por scripts/ci/check-readme-coevolution.sh per ADR-051."
		}, {
			path:      "governance/readme/structure-index.cue"
			source:    "_schema.location (architecture/artifact-schemas + governance/build-time) + scan do filesystem (repoStructure.scope)"
			generator: "python3 scripts/ci/generate-structure-index.py ."
			rationale: "Índice estrutural derivado (adr-090 componente 1): a estrutura schema-governada do repo é derivada de cada _schema.location + scan do filesystem, não autorada. Materializado e mantido em sync pelo workflow .github/workflows/materialize-structure-index.yml (auto-commit do github-actions[bot] quando difere). O gerador faz self-exclusão do próprio índice, evitando auto-referência. Consumo pelo config.cue e virada do sync em gate ficam para o passo (v) do cutover."
		}]
		rationale: "Registro explícito de artefatos derivados permite CI validar sync automaticamente. Per ADR-051, README.md migrou de derivação parcial por blockId para derivação full-file; campo blockId permanece no schema como extensão opcional para casos futuros, atualmente sem consumer."
	}

	responsibilityBoundary: {
		owns: [
			"Escopo de validação: quais raízes o CI valida",
			"Exclusões globais: quais paths o CI ignora",
			"Path segments compartilhados: vocabulário de raízes estruturais",
			"Fases de validação: ordem e contrato de cada fase",
			"Classificação de arquivos: algoritmo de match file→schema",
			"Política de classificação: mapeamento categoria→ação do CI",
			"Artefatos derivados: registro de sources, generators e paths para sync check",
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
			{
				id:        "derived-artifact-sync"
				rationale: "Garante que artefatos derivados estão em sync com seus sources. Cobre arquivos inteiros (CLAUDE.md, README.md). O campo blockId estende o mecanismo para derivação parcial em arquivos mistos, mas per ADR-051 nenhum derivedArtifact ativo o utiliza."
				includes: [
					"Para cada entrada em derivedArtifacts.artifacts:",
					"Se blockId ausente: executar generator e comparar output com conteúdo integral de path",
					"Se blockId presente: executar generator e comparar output com conteúdo entre marcadores <!-- BEGIN:{blockId} --> e <!-- END:{blockId} --> em path (sem consumer ativo per ADR-051)",
					"Se diff não for vazio, CI falha com mensagem indicando source, blockId (se aplicável) e comando de regeneração",
				]
				dependsOn: ["schema-conformance"]
			},
			{
				id:        "self-review-evidence"
				rationale: "Garante que artefatos governados alterados têm evidência estruturada de autovalidação. Enforcement determinístico complementa a disciplina comportamental instruída em config.cue."
				includes: [
					"Para cada artefato governado alterado (matched por artifact_type_for_path), verificar existência de self-review report em governance/build-time/self-reviews/",
					"Validar reports com cue vet contra #SelfReviewReport (inclui invariante stable↔fail via união discriminada)",
					"Verificar associação artifactPath↔artefato e artifactType↔tipo esperado",
					"Verificar consistência roundDetails vs roundsExecuted",
					"Consultar bootstrap exceptions em governance/build-time/self-review-bootstrap-policy.cue",
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
				"adr-consistency":        "script que parseia todos os ADRs em architecture/adrs/, monta grafo dirigido de supersession (supersedes/supersededBy) e valida existência, simetria e acyclicity"
				"derived-artifact-sync":  "script que itera derivedArtifacts; para entries sem blockId: executa generator e compara output com path via diff; entries com blockId atualmente não existem (per ADR-051); regeneração segue a convenção operacional 'generator > path'"
				"self-review-evidence": "scripts/ci/check-self-review.sh — cue vet estrutural + checks relacionais via bash/python; bootstrap exceptions consultadas antes de exigir report"
			}
		}
	}
}

// ── Contrato estável para tooling ──
//
// Entrypoint que desacopla scripts da forma interna do artefato.
// Tooling consome `tooling.excludedPaths` (não `repoStructure.scope.excluded`)
// para que renomeações da instância não quebrem consumidores. Per ADR-051,
// check-readme-coevolution.sh é o primeiro consumer formal. Schema #Tooling
// adotado de tekton-spec v0.3.0 junto com #RepoStructure (ADR-052).

tooling: artifact_schemas.#Tooling & {
	excludedPaths: repoStructure.scope.excluded
}
