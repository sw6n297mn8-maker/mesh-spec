package artifact_schemas

// structural-check.cue — Schema para regras de verificação estrutural.
//
// Per adr-040: structural verification é o lado determinístico da
// validação, separado do design review interpretativo. Per adr-041
// (v1), adr-049, adr-056, adr-063 e adr-064 (extensões incrementais):
// este schema é deliberadamente mínimo — 8 campos, 7 kinds atualmente,
// rule estritamente como dado estruturado. Cross-artifact reference
// checking de IDs (cross-file-id-exists) e regex pattern matching
// permanecem fora do schema; registrados como deferimentos
// conscientes em def-002 e def-003 (per adr-062 + adr-063).
// Kinds adicionados após v1 original:
//   - conditional-file-presence (adr-049) — motivado por api-spec
//     convention (adr-048).
//   - production-guide-coverage (adr-056) — motivado por cascade-
//     ordering enforcement (adr-053 + adr-054 dec 13).
//   - filesystem-path-exists (adr-063) — motivado por verificação
//     determinística de path validity em campos como artifactPath
//     (self-review-report) e manifestsIn (tension-entry).
//   - directory-pair-coverage (adr-064) — motivado por bug WI-033
//     (work-event sem task-spec); kind reusável para outros pairs
//     de diretórios futuros.
//
// Discriminação por kind segue o padrão de #ADR (união discriminada
// status↔supersededBy): cada kind exige um shape específico de rule.
//
// Convenção de _schema.location: descreve onde vivem as INSTÂNCIAS
// conformantes a este tipo (architecture/structural-checks/), não
// onde vive a definição do tipo (architecture/artifact-schemas/).
// Mesmo padrão dos demais artifact schemas no repositório.

#StructuralCheck: _#StructuralCheckBase & ({
	kind: "required-block"
	rule: #RequiredBlockRule
} | {
	kind: "reference-exists"
	rule: #ReferenceExistsRule
} | {
	kind: "same-artifact-consistency"
	rule: #SameArtifactConsistencyRule
} | {
	kind: "conditional-file-presence"
	rule: #ConditionalFilePresenceRule
} | {
	kind: "production-guide-coverage"
	rule: #ProductionGuideCoverageRule
} | {
	kind: "filesystem-path-exists"
	rule: #FilesystemPathExistsRule
} | {
	kind: "directory-pair-coverage"
	rule: #DirectoryPairCoverageRule
})

_#StructuralCheckBase: {
	// Identificador único da regra. Padrão recomendado:
	// sc-<artifact-abbrev>-NN (e.g., sc-cv-01 para a primeira
	// regra de canvas). O segmento do meio aceita qualquer
	// identificador alfanumérico-com-hífen para não acoplar
	// o schema à hipótese de abreviações curtas para sempre.
	id: string & =~"^sc-[a-z0-9-]+-[0-9]{2}$"

	// Título curto humano.
	title: string & !=""

	// Tipo de artefato que esta regra valida.
	artifactType: #ArtifactType

	// Descrição da regra em prosa.
	description: string & !=""

	// Discriminador que determina o shape de rule.
	// Constraint de presença/shape é imposto pela união em #StructuralCheck.
	kind: #StructuralCheckKind

	// Dado estruturado cujo shape depende de kind.
	rule: #StructuralCheckRule

	// Mensagem específica emitida quando a regra falha.
	// Deve conter informação suficiente para o autor entender
	// o que precisa corrigir.
	errorMessage: string & !=""

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/structural-checks/[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.cue$"
			description:        "Structural check rules: regras determinísticas de verificação estrutural por tipo de artefato."
			rationale:          "Regras estruturais vivem em diretório próprio porque são consumidas por mecanismo de gate (não por humanos editando o tipo) e podem evoluir independente do schema-base do tipo que validam."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-sc-01"
			description: "errorMessage é específica ao caso da regra"
			test:        "errorMessage descreve concretamente o que está faltando ou inconsistente. Não é genérica ('regra falhou', 'check falhou'). Inclui referência ao elemento específico (blockName, sourcePath, refNamespace) que a regra verifica."
			severity:    "fail"
			rationale:   "Mensagem genérica derrota o propósito do gate determinístico — autor recebe sinal sem informação acionável para corrigir."
		}, {
			id:          "tq-sc-02"
			description: "rule conforma com kind via união discriminada"
			test:        "rule usa exclusivamente o shape permitido para o kind declarado, sem campos incompatíveis com a rule correspondente. Enforcement primário é a união discriminada em #StructuralCheck — este critério é a versão de protocolo para casos em que o autor pode tentar contornar a discriminação."
			severity:    "fail"
			rationale:   "Sem discriminação consistente, runner não consegue despachar por kind."
		}, {
			id:          "tq-sc-03"
			description: "rationale conecta regra a caso concreto ou princípio"
			test:        "rationale referencia um caso observado (e.g., 'cobre vc-cv-03 sobre presença de communication') ou um princípio do schema do artifactType validado. Não é tautológico ('verifica X porque X é obrigatório')."
			severity:    "warn"
			rationale:   "Sem rationale rastreável, regras estruturais acumulam sem critério — futuro autor não sabe se uma regra ainda é necessária ou pode ser removida."
		}]
		rationale: "Critérios cobrem três aspectos do contrato structural-check v1: acionabilidade do erro (tq-sc-01), conformidade da união discriminada por kind (tq-sc-02) e justificabilidade da regra (tq-sc-03). Os três aspectos refletem o que adr-041 estabelece como inegociável: gate determinístico exige output informativo, despacho confiável por kind, e rastreabilidade para evolução."
	}
}

#StructuralCheckKind: "required-block" | "reference-exists" | "same-artifact-consistency" | "conditional-file-presence" | "production-guide-coverage" | "filesystem-path-exists" | "directory-pair-coverage"

#StructuralCheckRule: #RequiredBlockRule | #ReferenceExistsRule | #SameArtifactConsistencyRule | #ConditionalFilePresenceRule | #ProductionGuideCoverageRule | #FilesystemPathExistsRule | #DirectoryPairCoverageRule

// Rule shape para kind=required-block.
// Verifica que o artefato sob validação contém um bloco nomeado.
#RequiredBlockRule: {
	// Nome do bloco que deve existir como campo top-level
	// (ou caminho dot-separated) no artefato.
	blockName: string & !=""
}

// Rule shape para kind=reference-exists.
// Verifica que toda referência em sourcePath aponta para um id
// que existe em refNamespace, AMBOS no mesmo artefato. Cross-artifact
// reference checking está explicitamente fora da v1 (per adr-041).
#ReferenceExistsRule: {
	// Caminho dot-separated do campo no artefato sob validação
	// que contém referências (uma string ou lista de strings).
	sourcePath: string & !=""
	// Caminho dot-separated do bloco do MESMO artefato onde
	// os ids válidos vivem como entries.
	refNamespace: string & !=""
}

// Rule shape para kind=same-artifact-consistency.
// Verifica relação explícita entre dois blocos do mesmo artefato.
// v1 suporta apenas a relação 'every-reference-must-exist-as-entry'.
#SameArtifactConsistencyRule: {
	// Bloco onde ids são referenciados.
	referencingBlock: string & !=""
	// Bloco onde ids devem existir como entries.
	definingBlock: string & !=""
	// Natureza da relação a verificar.
	relation: #SameArtifactRelation
}

#SameArtifactRelation: "every-reference-must-exist-as-entry"

// Rule shape para kind=conditional-file-presence.
// Verifica presença ou ausência de um arquivo-alvo por path,
// condicionada a um campo booleano em um artefato-fonte no
// mesmo scope de diretório. Per adr-049: kind deliberadamente
// sobre arquivo por path, não sobre "artefato" abstrato —
// evita escorregar para meta-kind cross-artifact genérico.
// Cross-artifact reference checking genérico permanece fora
// do schema (per adr-041); este kind cobre exclusivamente
// presença condicional de arquivo.
#ConditionalFilePresenceRule: {
	// Glob pattern para o artefato-fonte contendo a condição.
	// Wildcard * delimita o scope compartilhado com targetPattern.
	sourcePattern: string & !=""
	// Caminho dot-separated ao campo booleano no artefato-fonte.
	conditionField: string & !=""
	// Path pattern para o arquivo-alvo. Mesmo * scope do sourcePattern.
	targetPattern: string & !=""
	// true: field=true exige target, field=false proíbe target.
	// false: apenas field=true exige target.
	biconditional: bool
}

// Rule shape para kind=production-guide-coverage.
// Verifica que para cada nome em coveredSchemas, existe arquivo
// architecture/production-guides/<nome>.cue. Per adr-056: kind narrow
// para cobertura universal de PGs (materializa adr-053 cobertura
// universal + adr-054 dec 13 cascade ordering como gating
// determinístico). Whitelist explícita evita CI surpresa por auto-
// discovery; cobertura cresce por change-on-touch quando novo PG é
// committed (schema name adicionado a coveredSchemas no MESMO commit).
// Cross-artifact reference checking genérico permanece fora do schema
// (per adr-041); este kind cobre exclusivamente coverage de PGs.
#ProductionGuideCoverageRule: {
	// Lista explícita de nomes de schemas que exigem PG correspondente.
	// Cada nome resolve para architecture/production-guides/<nome>.cue.
	// Whitelist (não auto-discovery) — expansão deliberada por commit.
	coveredSchemas: [string & !="", ...string & !=""]
}

// Rule shape para kind=filesystem-path-exists.
// Verifica que o valor (string ou lista de strings) no campo apontado
// por sourcePath dentro do artefato sob validação corresponde a path
// existente no filesystem. Per adr-063: kind narrow para verificação
// determinística de path validity em campos que devem apontar para
// artefatos reais (e.g., self-review-report.artifactPath, tension-
// entry.manifestsIn).
// V1 minimal: sourcePath aceita dot-path simples (e.g., 'artifactPath',
// 'manifestsIn'); nested iteration sobre lists of structs (e.g.,
// adopted-artifacts.artifacts[*].artifact) NÃO suportada — aguarda
// kind ainda mais nuanced ou refinement deste kind.
// Cross-file reference checking de id (vs path), regex pattern
// matching de campo, e iteration nested permanecem fora — registrados
// como def-002 e def-003 respectivamente.
#FilesystemPathExistsRule: {
	// Dot-path do campo no artefato sob validação contendo o path
	// (ou lista de paths) a verificar. Apenas single-level lists ou
	// strings — não suporta nested iteration em V1.
	sourcePath: string & !=""
	// true: sourcePath aponta para list of strings (runner itera);
	// false (default): sourcePath aponta para single string.
	isList: bool | *false
}

// Rule shape para kind=directory-pair-coverage.
// Verifica pareamento de arquivos entre dois diretórios via globs com
// wildcards compartilhados. Per adr-064: kind narrow para integridade
// referencial cross-directory (e.g., toda wi-XXX em work-events/ exige
// wi-XXX em task-specs/). Source set é DINÂMICO (cada arquivo matching
// sourceGlob), não whitelist curada (vs production-guide-coverage que
// usa whitelist).
//
// Wildcard '*' em sourceGlob captura identidade compartilhada com
// targetGlob na mesma posição. Runner: para cada arquivo matching
// sourceGlob, deriva target via mesma captura, verifica existência.
//
// Motivado por bug WI-033 (work-event criado sem task-spec
// correspondente, inconsistência referencial silenciosa por ~5 semanas).
// Reusável para outros pairs futuros (e.g., self-reviews/ ↔ governed
// artifacts/) sem novo kind.
#DirectoryPairCoverageRule: {
	// Glob pattern para arquivos no source dir. Wildcard '*' captura
	// identidade compartilhada com targetGlob.
	sourceGlob: string & !=""
	// Glob pattern para target dir. Wildcards '*' nas mesmas posições
	// que sourceGlob — runner verifica que cada source file tem target
	// file com mesmo wildcard capture.
	targetGlob: string & !=""
	// true: ambas direções enforced (every source ↔ every target);
	// false (default): source-to-target only — target sem source é
	// estado válido (e.g., task-spec sem work-event = admission=defined
	// per work-governance state machine).
	bidirectional: bool | *false
}
