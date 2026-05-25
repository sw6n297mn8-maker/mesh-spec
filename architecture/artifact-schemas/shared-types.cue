package artifact_schemas

// shared-types.cue — Location/convention schema para a biblioteca de tipos
// CUE em architecture/shared-types/.
//
// ATENÇÃO (per adr-094): este é um LOCATION/CONVENTION schema, NÃO um
// instance-shape schema. Os arquivos em architecture/shared-types/ são
// BIBLIOTECAS DE DEFINIÇÕES CUE (package shared_types: #VerticalClass,
// #VerticalApplicability, #SubdomainClassification, …) consumidas por outros
// schemas — não são instâncias de dados. Portanto este schema declara apenas
// localização + convenções advisory; deliberadamente NÃO finge validar shape
// de instância (struct aberta). Existe para tirar a biblioteca da zona órfã
// (unmatched) mantendo a sequência adr-090/def-018, sem redesenhar shared-types.

#SharedTypes: {
	// Struct aberta: não impõe shape de dados — os arquivos são defs, não dados.
	...

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/shared-types/[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.cue$"
			description:        "Biblioteca de definições de tipo CUE compartilhadas (package shared_types), consumidas por outros schemas."
			rationale:          "Location/convention schema (NÃO instance-shape) per adr-094: os arquivos são definições reutilizáveis, não instâncias de dados. Declara localização para tirar a biblioteca da zona órfã sem forçar shape."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-st-01"
			description: "Arquivo é biblioteca de tipos no package shared_types"
			test:        "Cada arquivo em architecture/shared-types/ declara package shared_types e contém ao menos uma definição (#Tipo) reutilizável. Advisory: verificação de convenção de biblioteca, não de shape de instância (não há instância a validar)."
			severity:    "warn"
			rationale:   "Mantém a pasta coesa como biblioteca de tipos; um arquivo sem definição ou em outro package não pertence aqui."
		}, {
			id:          "tq-st-02"
			description: "Vocabulário canônico fechado expande via ADR"
			test:        "Enums/uniões canônicas fechadas (e.g., #VerticalClass, #SubdomainClassification) expandem por ADR, nunca por PR direto. Advisory: disciplina de vocabulário, não enforceável por shape."
			severity:    "warn"
			rationale:   "A disciplina do vocabulário é o que torna esses tipos úteis para governança e consulta mecânica (ref adr-043)."
		}]
		rationale: "Critérios são ADVISORY (warn) por construção: um location/convention schema não tem instância cujo shape validar. Garantem coesão da biblioteca e disciplina de vocabulário, não conformância de dados."
	}
}
