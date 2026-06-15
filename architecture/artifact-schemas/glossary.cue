package artifact_schemas

// glossary.cue — Schema para Ubiquitous Language Glossary.
//
// O glossary é o artefato canônico da Ubiquitous Language de cada BC.
// Define termos do domínio com precisão suficiente para agentes
// gerarem código, validarem contratos e disambiguarem conceitos.
//
// Estratégia desta versão:
// - termos têm categoria, definição, rationale obrigatório, anti-termos e exemplos
// - bilingual mapping (pt-BR / en) para cada termo, habilitando code generation
// - cross-layer mapping opcional e lightweight (code, API, UI) para consistency
// - rejected alternatives documentam seleção deliberada de termos
// - refs ao domain model usam todos os prefixos canônicos do domain-model.cue
// - relatedTerms formam grafo navegável; self-reference detectada por criterion
// - termos sem ancoragem semântica detectados por criterion
// - glossário é por BC; termos transversais vivem no context map
// - quality criteria cobrem integridade referencial, qualidade semântica e cross-artifact
//
// Ancoragem nos princípios Mesh:
// - glossário como SoT da UL (P1): cada termo definido em exatamente um lugar
// - bilingual mapping: pt-BR para negócio e contratos, en para código e API
// - cross-layer mapping: garante 1 termo per conceito per layer
// - rejected alternatives: decisões terminológicas são decisões de design (P0)
//
// Lens aplicada: lens-domain-language-and-terminology-design
// - bilingual mapping (dl-bilingual-terminology)
// - rejected alternatives (dl-term-selection-criteria)
// - cross-layer mapping (dl-cross-layer-consistency)
//
// O que NÃO vive aqui:
// - termos transversais entre BCs → context-map
// - definições técnicas de arquitetura → ADRs, design-principles.cue
// - mapping de audiência (expert/professional/accessible) → evolução futura
// - classificação de risco jurídico de termos → evolução futura
// - convenções de naming de código (camelCase, snake_case) → CLAUDE.md
// - nomes de eventos de domínio → domain-model.cue (building blocks canônicos)
//
// Limitações conhecidas:
// - Cross-glossary validation (termos homônimos com significados diferentes
//   entre BCs) depende de tooling futuro. Schema valida apenas intra-BC.
// - Audience variants (expert/professional/accessible per audience) não
//   modelados nesta versão. Adicionar quando instâncias revelarem necessidade.
// - Juridical risk classification per termo não modelado. Lens
//   domain-language recomenda; avaliar após primeiras instâncias.
// - layerMapping é lightweight e opcional — APIs e UIs ainda não estão
//   estabilizadas na maioria dos BCs. Não elevar importância conceitual
//   prematuramente.
// - Trailing hyphens em #BoundedContextRef e #DomainModelRef ainda são
//   aceitos por consistência com demais schemas do package. term codes
//   usam regex mais estrita que impede trailing hyphens.
// - Normalização de synonyms (duplicatas, case, espaços extras) é
//   responsabilidade do runner. Schema não enforça.
// - #ArtifactType em quality-criteria.cue não inclui "glossary" até commit
//   deste schema. Companion change necessária para entrar no regime de
//   self-review.

#Glossary: {
	code: string & =~"^[a-z][a-z0-9-]*$"
	name: #NonEmptyString

	// Referência ao BC que este glossário governa.
	// Runner valida que corresponde ao canvas.code do BC.
	boundedContextRef: #BoundedContextRef

	// Termos da Ubiquitous Language deste BC.
	// Ao menos um termo é obrigatório — glossário vazio é inválido.
	terms: [#GlossaryTerm, ...#GlossaryTerm]

	rationale: #NonEmptyString

	_schema: {
		location: {
			// adr-151 (item 4): lar canônico estendido para admitir o glossário-kernel
			// compartilhado em architecture/shared-schemas/, além de contexts/<bc>/.
			canonicalPathRegex: "^(contexts/[a-z][a-z0-9-]*|architecture/shared-schemas)/glossary\\.cue$"
			fileNameRegex:      "^glossary\\.cue$"
			description:        "Glossary: Ubiquitous Language canônica do bounded context."
			rationale:          "Glossary vive na raiz do BC junto ao canvas e domain model. Agentes consultam o glossário para validar terminologia."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-gl-01"
			description: "Todo termo tem code único"
			test:        "Nenhum code duplicado em terms[]."
			severity:    "fail"
			rationale:   "Code é o identificador que agentes e tooling consomem para referenciar termos programaticamente; duplicidade torna a referência ambígua."
		}, {
			id:          "tq-gl-02"
			description: "relatedTerms referenciam termos válidos dentro deste glossário"
			test:        "Cada ref em terms[].relatedTerms[] existe em terms[].code. Refs cross-glossário não são suportadas nesta versão."
			severity:    "fail"
			rationale:   "Referência a termo inexistente é navegação quebrada."
		}, {
			id:          "tq-gl-03"
			description: "domainModelRefs usam prefixos válidos e existem no domain model"
			test:        "Prefixo validado estruturalmente pela regex de #DomainModelRef (CUE). Existência do building block referenciado no domain-model.cue validada por runner."
			severity:    "fail"
			rationale:   "Prefixo inválido é erro estrutural (CUE catch). Ref a building block inexistente é ligação fantasma (runner catch)."
		}, {
			id:          "tq-gl-04"
			description: "Termos cobrem os aggregates do domain model"
			test:        "Quando domain model do mesmo BC existir: para cada aggregates[].code, existe ao menos um termo com domainModelRef apontando para ele. Skipped quando domain model ainda não existe. Validação por runner."
			severity:    "warn"
			rationale:   "Aggregate sem termo no glossário indica conceito central não documentado na UL. warn para permitir preenchimento incremental."
		}, {
			id:          "tq-gl-05"
			description: "Definição e sinônimos não são redundantes com campos de identidade"
			test:        "Checks concretos: (a) definition não é igual a name. (b) definition não é igual a nenhum synonym. (c) nenhum synonym é igual a name ou termEn. Check semântico (runner): definition descreve identidade do termo com precisão suficiente para distinção operacional entre conceitos do BC."
			severity:    "warn"
			rationale:   "Definição vaga ou redundante anula o propósito do glossário para agentes. Synonym que repete name ou termEn é ruído."
		}, {
			id:          "tq-gl-06"
			description: "Anti-termos não repetem termos do próprio glossário"
			test:        "Nenhum antiTerms[].term coincide (case-insensitive) com terms[].name ou terms[].synonyms[] neste glossário."
			severity:    "warn"
			rationale:   "Anti-termo que é um termo válido ou sinônimo no mesmo BC cria contradição."
		}, {
			id:          "tq-gl-07"
			description: "boundedContextRef alinha com canvas"
			test:        "boundedContextRef corresponde ao canvas.code do BC onde este glossário vive. Validação por runner."
			severity:    "fail"
			rationale:   "Glossário desalinhado do canvas é artefato órfão."
		}, {
			id:          "tq-gl-08"
			description: "Termo não referencia a si mesmo em relatedTerms"
			test:        "Nenhum terms[].relatedTerms[] contém o próprio terms[].code."
			severity:    "warn"
			rationale:   "Self-reference raramente agrega navegação semântica e normalmente indica preenchimento descuidado."
		}, {
			id:          "tq-gl-09"
			description: "Termo tem ao menos um mecanismo de ancoragem semântica"
			test:        "Cada termo declara ao menos um entre: examples, antiTerms, relatedTerms ou domainModelRefs."
			severity:    "warn"
			rationale:   "Termo sem ancoragem tende a virar definição abstrata demais para uso confiável por agentes."
		}, {
			id:          "tq-gl-10"
			description: "layerMapping, quando presente, tem ao menos uma layer preenchida"
			test:        "Se terms[].layerMapping está presente, ao menos um campo (codeTerm, apiTerm, uiLabel) é não-vazio. layerMapping vazio é structurally válido em CUE — este critério é enforcement por runner."
			severity:    "warn"
			rationale:   "layerMapping vazio é declaração sem conteúdo — melhor omitir."
		}, {
			id:          "tq-gl-11"
			description: "termEn é semanticamente adequado"
			test:        "termEn não é idêntico a name, exceto para loanwords genuinamente iguais em ambos os idiomas (e.g., Score, Compliance, Spread). termEn não repete nenhum synonym. termEn representa o mesmo conceito que name — não é tradução frouxa ou genérica. Validação semântica pode exigir runner."
			severity:    "warn"
			rationale:   "termEn é o campo que agentes mais consomem para code generation. Tradução frouxa propaga naming incorreto para código e API."
		}, {
			id:          "tq-gl-12"
			description: "Todo termo tem termEn único"
			test:        "Nenhum termEn duplicado em terms[]. Dois termos com mesmo termEn geram colisão de naming em código gerado."
			severity:    "fail"
			rationale:   "Agentes usam termEn para nomear classes e endpoints. Duplicidade causa naming collision."
		}, {
			id:          "tq-gl-13"
			description: "Todo termo tem name único"
			test:        "Nenhum name duplicado em terms[]."
			severity:    "fail"
			rationale:   "Dois termos com mesmo nome canônico violam unicidade da Ubiquitous Language."
		}]
		rationale: "Critérios cobrem integridade referencial interna (tq-gl-01, tq-gl-02, tq-gl-08), unicidade de identidade e naming (tq-gl-12, tq-gl-13), rastreabilidade ao domain model (tq-gl-03, tq-gl-04), qualidade semântica (tq-gl-05, tq-gl-06, tq-gl-09), qualidade bilíngue (tq-gl-11), alinhamento cross-artifact (tq-gl-07) e consistência cross-layer (tq-gl-10)."
	}
}

// ==============================
// GLOSSARY TERMS
// ==============================

#GlossaryTerm: {
	code: string & =~"^term-[a-z][a-z0-9]*(-[a-z0-9]+)*$"

	// Nome canônico do termo na Ubiquitous Language (pt-BR).
	name: #NonEmptyString

	// Canonical English term para code generation e API naming.
	// Agentes usam este campo para nomear classes, variáveis e endpoints.
	// Permite letras, dígitos e espaços (multi-word: "Anticipation Operation").
	// Hyphens intencionalmente excluídos — termos compostos usam espaço.
	// Para loanwords iguais em pt-BR e en (Score, Compliance): repetir é válido.
	termEn: string & =~"^[A-Za-z][A-Za-z0-9]*( [A-Za-z][A-Za-z0-9]*)*$"

	// Definição precisa. Deve ser suficiente para um agente
	// decidir nomes de classes, campos e métodos sem ambiguidade.
	definition: #NonEmptyString

	// Categoria do termo no domínio.
	category: #TermCategory

	// Por que este conceito merece existir como termo canônico separado.
	// Especialmente importante quando há termos próximos entre BCs diferentes.
	rationale: #NonEmptyString

	// Sinônimos informais que podem aparecer em conversas
	// com domain experts. Não são nomes canônicos.
	synonyms?: [...#NonEmptyString]

	// O que este termo NÃO é. Previne erros de interpretação comuns.
	// Especialmente útil quando o termo existe em outros BCs
	// com significado diferente, ou quando há confusão frequente.
	antiTerms?: [...#AntiTerm]

	// Alternativas de nome consideradas e rejeitadas com justificativa.
	// Documenta seleção deliberada per lens domain-language.
	// antiTerms = "o que o conceito NÃO é" (disambiguation).
	// rejectedAlternatives = "quais nomes foram considerados e por quê não" (seleção).
	rejectedAlternatives?: [...#RejectedAlternative]

	// Exemplos concretos para disambiguação.
	examples?: [...#TermExample]

	// Termos relacionados dentro deste glossário.
	// Forma grafo navegável intra-glossário.
	// tq-gl-08 detecta self-references.
	relatedTerms?: [...#GlossaryTermRef]

	// Referências a building blocks no domain model que
	// materializam este conceito. Usa prefixos canônicos.
	// Runner valida existência no domain-model.cue.
	domainModelRefs?: [...#DomainModelRef]

	// Mapping cross-layer: como este termo aparece em cada camada.
	// Opcional e lightweight — APIs e UIs podem não estar estabilizadas.
	// Evento de domínio não entra aqui; vive no domain-model.cue.
	layerMapping?: #LayerMapping
}

// ==============================
// TERM CATEGORIES
// ==============================

// Categorias que orientam agentes sobre a natureza do conceito.
#TermCategory:
	"entity" |           // Conceito com identidade e ciclo de vida (maps to aggregate/entity)
	"value" |            // Conceito sem identidade, definido por atributos (maps to value object)
	"process" |          // Sequência de atividades ou workflow do domínio
	"role" |             // Papel que um participante assume no domínio
	"rule" |             // Regra de negócio ou restrição (maps to invariant)
	"event" |            // Fato que aconteceu no domínio (maps to domain event)
	"command" |          // Intenção de ação no domínio (maps to command)
	"metric" |           // Medida ou indicador de desempenho do domínio
	"document" |         // Artefato documental do domínio (NF-e, contrato, certificado)
	"classification"     // Taxonomia ou categorização usada no domínio

// ==============================
// ANTI-TERMS
// ==============================

// O que o conceito NÃO é.
#AntiTerm: {
	// O termo que gera confusão.
	term: #NonEmptyString

	// Por que esse termo não se aplica a este conceito.
	clarification: #NonEmptyString
}

// ==============================
// REJECTED ALTERNATIVES
// ==============================

// Alternativa de nome considerada e rejeitada durante seleção do termo.
#RejectedAlternative: {
	// O termo alternativo que foi considerado.
	term: #NonEmptyString

	// Por que foi rejeitado (precisão jurídica, domínio,
	// familiaridade, diferenciação, i18n, consistency, brevidade).
	reason: #NonEmptyString
}

// ==============================
// LAYER MAPPING
// ==============================

// Como o termo aparece em cada camada do sistema.
// Lightweight e opcional — não elevar importância conceitual prematuramente.
// Evento de domínio NÃO entra aqui; é building block do domain-model.cue.
// Campos são convenções de naming, não constraints enforçados por CUE.
// tq-gl-10 valida que ao menos uma layer está preenchida.
#LayerMapping: {
	// Nome em código (English). Convenção: PascalCase para classes,
	// camelCase para fields — mas não enforçado por regex.
	codeTerm?: #NonEmptyString

	// Path ou field name em API (English). Convenção: kebab-case
	// ou snake_case — mas não enforçado por regex.
	apiTerm?: #NonEmptyString

	// Label na UI (pt-BR).
	uiLabel?: #NonEmptyString
}

// ==============================
// EXAMPLES
// ==============================

// Exemplo concreto de uso do termo para disambiguação.
#TermExample: {
	// Contexto situacional do exemplo.
	context: #NonEmptyString

	// Instância concreta do conceito neste contexto.
	instance: #NonEmptyString

	// Por que este exemplo é representativo do conceito.
	rationale?: #NonEmptyString
}

// ==============================
// REFS
// ==============================

// Ref interna ao glossário.
#GlossaryTermRef: string & =~"^term-[a-z][a-z0-9]*(-[a-z0-9]+)*$"

// Ref ao domain model usando todos os prefixos canônicos do domain-model.cue.
// Se domain-model.cue adicionar novo prefixo, esta regex precisa ser atualizada manualmente.
// Nota: qry- (QueryCapability) é nested em projections[].queryCapabilities[],
// não top-level. Runner deve traversar projections[] para validar existência.
#DomainModelRef: string & =~"^(evt|cmd|inv|vo|agg|ent|mod|svc|pol|prj|qry)-[a-z][a-z0-9-]*$"

#BoundedContextRef: string & =~"^[a-z][a-z0-9-]*$"

#NonEmptyString: string & !=""
