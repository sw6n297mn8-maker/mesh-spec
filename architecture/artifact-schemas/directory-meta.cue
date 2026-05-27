package artifact_schemas

import (
	"strings"
)

// directory-meta.cue — Schema para metadata de diretório governado.
//
// Cada diretório governado em mesh-spec carrega um arquivo _meta.cue. Schema
// declarado por adr-115 (adota o pattern de auster-spec adr-028, adaptado).
//
// Adaptações à stack da mesh (ver adr-115): (a) nome _meta.cue (prefixo _)
// para não casar os canonicalPathRegex dos schemas de instância do diretório,
// que exigem filename iniciando em [a-z0-9]; (b) o _meta.cue declara `meta`
// como mapa keyed pelo path, em forma plana SEM importar este schema — evita
// ciclo de import (artifact_schemas importa shared_types) e colisão de campo
// quando subdir compartilha o package do pai. A conformância a #DirectoryMeta
// é validada pelo gerador (P10), não por unificação CUE.
//
// Filesystem é source of truth da estrutura. canonicalPath é self-declared e
// validado pelo gerador (scripts/ci/generate-repo-tree.py) contra o path real
// onde o _meta.cue reside — divergência indica copy-paste ou rename sem update.
//
// purpose é a descrição em uma frase do diretório, renderizada no README e
// em governance/readme/tree-generated.cue (derivado). Faixa 20-200 runes
// força substância sem virar dissertação.
//
// rationale é opcional. Quando presente, registra por que o diretório existe
// (complementar ao purpose, que descreve o que ele é).

#DirectoryMeta: {
	canonicalPath: string & !=""
	purpose:       string & strings.MinRunes(20) & strings.MaxRunes(200)
	rationale?:    string & strings.MinRunes(20)

	// conventions: regras/observações específicas do diretório, renderizadas
	// na tabela do README (#DirectoryNote.conventions). Lista possivelmente
	// vazia. Migradas do config.cue para co-localização (adr-115).
	conventions?: [...string & !=""]

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-dm-01"
			description: "canonicalPath corresponde ao path real do diretório no filesystem"
			test:        "canonicalPath, concatenado com '/meta.cue', é igual ao path do arquivo onde a instância reside. Validado por scripts/ci/generate-repo-tree.py durante a regeneração; divergência bloqueia o sync do README derivado."
			severity:    "fail"
			rationale:   "Path declarado divergente do path real indica copy-paste error ou diretório renomeado sem update do meta.cue. O gerador bloqueia a regen do artefato derivado até reconciliar."
		}, {
			id:          "tq-dm-02"
			description: "purpose tem substância controlada"
			test:        "purpose entre 20 e 200 runes. Enforçado por shape (strings.MinRunes(20) & strings.MaxRunes(200))."
			severity:    "fail"
			rationale:   "Abaixo de 20 runes não orienta o leitor sobre o propósito do diretório; acima de 200 vira dissertação que pertence a documentação dedicada, não ao README."
		}, {
			id:          "tq-dm-03"
			description: "rationale, quando presente, tem substância"
			test:        "Se rationale está presente, tem ao menos 20 runes. Enforçado por shape (strings.MinRunes(20))."
			severity:    "fail"
			rationale:   "Rationale curto demais é filler que reduz auditabilidade da decisão de criar o diretório."
		}, {
			id:          "tq-dm-04"
			description: "purpose descreve o diretório como agregado, não enumera arquivos individuais"
			test:        "purpose não contém referência a nome de arquivo .cue específico do diretório (substring matching '.cue'). Verificado pelo gerador."
			severity:    "warn"
			rationale:   "Enumeração de arquivos individuais em purpose duplica conteúdo que vive em outros artefatos e violaria Zero Duplicação (P0). purpose deve descrever o tipo agregado do conteúdo do diretório."
		}]
		rationale: "Critérios cobrem três dimensões do meta.cue: (a) consistência com filesystem (tq-dm-01) — sem isso o regen é não-confiável; (b) substância controlada de purpose e rationale (tq-dm-02, tq-dm-03) — sem isso o README perde valor de auto-documentação; (c) granularidade adequada (tq-dm-04) — sem isso purpose vira reconciliação pseudo-canônica de conteúdo de outros artefatos."
	}

	_schema: {
		location: {
			canonicalPathRegex: "^([a-z0-9][a-z0-9-]*/)*_meta\\.cue$"
			fileNameRegex:      "^_meta\\.cue$"
			description:        "Metadata de diretório governado: descrição canônica (purpose) do diretório, source da árvore derivada do README."
			rationale:          "Nome _meta.cue (prefixo _) para não casar os canonicalPathRegex dos schemas de instância do diretório (agent-spec, lens, subdomain, etc.), que exigem filename iniciando em [a-z0-9]. Vive em cada diretório governado (não em lista central) — localização canônica única (P0); consumido pelo gerador determinístico."
			cardinality:        "collection"
			allowNested:        true
		}
	}
}
