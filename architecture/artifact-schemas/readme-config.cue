package artifact_schemas

// readme-config.cue — Schema portfolio-wide para source CUE do README.md.
//
// Instância vive em governance/readme/config.cue de cada repo que adota.
// Gerador (governance/readme/output.cue) consome essa instância via
// text/template e produz README.md derivado.
//
// Origem: ADR-005 (promoção de tekton-spec local para portfolio-wide,
// extensão com tree obrigatória para governance estrutural).
//
// Abreviação de quality criterion ID: rc.

import (
	"list"
	"strings"
)

// ── Tipos de tree ──
//
// #RepositoryTree e #DirectoryNote são sub-tipos específicos de #ReadmeConfig
// (sem _schema.location próprio, utilitários por ADR-004).

#DirectoryNote: {
	path:        string & !=""
	purpose:     string & strings.MinRunes(20)
	conventions: [...string & !=""]
	rationale:   string & !=""
}

#RepositoryTree: {
	rootPath:  string & !=""
	entries:   [...#DirectoryNote] & list.MinItems(1)
	rationale: string & !=""
}

// ── Seções narrativas ──

#ReadmeSection: {
	title:     string & !=""
	content:   string & !=""
	rationale: string & !=""
}

// ── Raiz ──

#ReadmeConfig: {
	repo:        string & !=""
	heading:     string & !=""
	description: string & strings.MinRunes(50)
	tree:        #RepositoryTree
	sections:    [#ReadmeSection, ...#ReadmeSection]

	_schema: {
		location: {
			canonicalPathRegex: "^governance/readme/config\\.cue$"
			fileNameRegex:      "^config\\.cue$"
			description:        "Configuração do gerador de README.md de cada repo."
			rationale:          "Singleton em governance/readme/ de cada repo. Consumido por governance/readme/output.cue via template para derivar README.md."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-rc-01"
			description: "Description tem ao menos 50 runes"
			test:        "description satisfaz strings.MinRunes(50). Enforçado por shape."
			severity:    "fail"
			rationale:   "Description curta não contextualiza o repo para novos leitores."
		}, {
			id:          "tq-rc-02"
			description: "Tree tem ao menos uma entry"
			test:        "tree.entries satisfaz list.MinItems(1). Enforçado por shape."
			severity:    "fail"
			rationale:   "README sem tree é README sem auditoria estrutural — viola ADR-005."
		}, {
			id:          "tq-rc-03"
			description: "Tree entries cobrem filesystem real"
			test:        "Cada tree.entries[].path corresponde a diretório existente no repo; cada diretório governado do repo aparece em tree.entries. Advisory: CI-enforced (script futuro), CUE não varre filesystem."
			severity:    "warn"
			rationale:   "Drift entre tree declarada e filesystem invalida o propósito de ter tree auditável."
		}, {
			id:          "tq-rc-04"
			description: "DirectoryNote tem purpose substantivo"
			test:        "Cada tree.entries[].purpose satisfaz strings.MinRunes(20). Enforçado por shape."
			severity:    "fail"
			rationale:   "Purpose vago não comunica o papel do diretório."
		}, {
			id:          "tq-rc-05"
			description: "Sections têm ao menos uma entry"
			test:        "sections satisfaz [#ReadmeSection, ...#ReadmeSection] (pelo menos 1). Enforçado por shape."
			severity:    "fail"
			rationale:   "README sem seções narrativas é só tree — perde contexto conceitual do repo."
		}]
		rationale: "Critérios garantem que README é índice estrutural auditável (tree obrigatória, purposes substantivos), tem narrativa conceitual (sections), e reflete filesystem real (advisory, CI-enforced). 4 fail shape-enforced + 1 warn CI-enforced."
	}
}
