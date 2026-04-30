package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue — Production guide para Ubiquitous Language Glossary.
//
// PARTIAL — commit 1 da sequência (scaffold).
// _schema, _qualityCriteria e prerequisites substantivos.
// workOrder, sections e finalValidation com placeholders TBD a serem
// substituídos em commits 2 e 3.
//
// Schema alvo: #Glossary (architecture/artifact-schemas/glossary.cue).
// Escopo: cada glossário governa um único bounded context.
// Phase 2 da regra universal de adr-053. Lens aplicada:
// lens-domain-language-and-terminology-design.

glossaryGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/glossary\\.cue$"
			fileNameRegex:      "^glossary\\.cue$"
			description:        "Production guide para autoria de Ubiquitous Language Glossary por bounded context em mesh-spec."
			rationale:          "Glossary é o SoT da UL de cada BC; guide explicita process, gapPolicy e heuristics que o schema #Glossary sozinho não documenta. Phase 2 da regra universal de adr-053."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-gg-01"
			description: "Guide produz instância com unicidade de code, name, termEn"
			test:        "Process inclui passo explícito de verificar unicidade dos 3 campos (code, name, termEn) antes de finalização. Cobre tq-gl-01/12/13 do schema (todos fail). Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "Unicidade de identidade é a falha #1 em glossários multi-term — duplicate code quebra refs, duplicate termEn causa naming collision em código gerado, duplicate name viola UL."
		}, {
			id:          "tq-gg-02"
			description: "Guide exige instância com ≥1 anchor semântico por term"
			test:        "Process da section term-content-and-anchoring exige declarar ≥1 entre examples, antiTerms, relatedTerms ou domainModelRefs por termo (synonyms e rejectedAlternatives NÃO contam como ancoragem per tq-gl-09 do schema). Heuristics da section repete a regra. Verificado por inspeção."
			severity:    "fail"
			rationale:   "tq-gl-09 do schema é warn; guide eleva para fail porque termo sem ancoragem vira definição abstrata e perde valor para code generation por agentes."
		}, {
			id:          "tq-gg-03"
			description: "Guide produz definitions não-redundantes"
			test:        "Process declara: definition ≠ name; definition ≠ qualquer synonym; sinônimos ≠ name/termEn. Heuristics reforça com exemplo do que NÃO fazer. Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "tq-gl-05 do schema é warn; guide eleva para fail porque definição redundante anula propósito do glossário."
		}, {
			id:          "tq-gg-04"
			description: "Guide promove rejectedAlternatives substantivos"
			test:        "Heuristics da section term-content-and-anchoring explicita que rejectedAlternatives deve registrar (a) alternativas consideradas, (b) razão de rejeição, (c) motivo da escolha canônica, quando a seleção terminológica foi não-trivial. Verificado por inspeção."
			severity:    "warn"
			rationale:   "rejectedAlternatives é campo opcional rico mas frequentemente omitido; lens domain-language demanda explicitação quando seleção foi não-trivial."
		}]
		rationale: "4 critérios cobrem disciplinas centrais para autoria de glossário multi-term: unicidade de identidade (tq-gg-01), ancoragem semântica (tq-gg-02), não-redundância de definição (tq-gg-03), explicitação de seleção terminológica (tq-gg-04). Scope é severidades hardened (warn→fail em 02 e 03 do schema); cobertura completa dos 13 tq-gl-XX vive em finalValidation.steps."
	}

	prerequisites: {
		description: "Antes de criar glossário para um BC, agente lê canvas + domain-model (se existir) + lens-domain-language, identifica candidate terms a partir do vocabulário emergente, e confirma escopo com founder."
		collectFromFounder: [
			"Confirmação do BC alvo (code de 3 letras, ex.: 'idc') e que canvas existe em contexts/{bc}/canvas.cue",
			"Confirmação de que glossary é apropriado agora (canvas estável; domain-model criado ou em criação)",
			"Heurísticas tácitas que founder usa para distinguir termo canônico do BC vs termo trivial/universal — candidatos a heuristics no guide",
		]
		gapPolicy:     "Se canvas do BC alvo não existir, NÃO crie o glossary — postergue até canvas existir (glossary depende de UL emergente em canvas). Se domain-model não existir mas canvas sim, prosseguir usando canvas + businessDecisions como fonte primária; domainModelRefs serão preenchidos incrementalmente quando domain-model surgir. NÃO invente termos que canvas não usa — UL emerge do vocabulário operacional, não de catálogo abstrato. NÃO copie termos de outro glossary sem verificar que conceito é genuinamente o mesmo no BC alvo (homônimos com significado diferente entre BCs são esperados — cada BC tem o seu glossary independente). Quando founder não souber definir termo com precisão suficiente para code generation, OMITA do glossary inicial e adicione em sessão futura — definição vaga é pior que ausência. Se a autoria do glossary revelar inconsistência terminológica no canvas (canvas usa termo divergente do que emerge da análise estruturada), NÃO corrija silenciosamente no glossary — registre tension entry ou proponha alteração explícita no canvas antes de canonizar o termo no glossary; correção silenciosa diverge dois SoTs."
		validatorNote: "Em Phase 0, founder review é obrigatório como gate semântico final. Em Phases futuras, founder review pode ser substituído por aprovação humana delegada ou policy gate formal — não cristalizar founder como gargalo eterno. Validação por inspeção em Phase 0 é sujeita a inconsistência entre sessões — estruturar critérios observáveis sempre que possível para reduzir variância e habilitar futura automação. Quando structural-checks de glossary existirem (post-WI-068), tq-gl-01/02/05/06/07/08/12/13 automatizam-se intra-glossary; tq-gl-03/04 (cross-file domain-model) e tq-gl-11 (semântica termEn) dependem de runner futuro per limitação declarada no schema."
		outputNote:    "Output é arquivo único contexts/{bc}/glossary.cue conformante a #Glossary. Tamanho típico: 250-310 linhas para glossário completo (per cmt 267, npm 284, ctr 306). Glossário inicial pode começar com 5-15 termos centrais e crescer incrementalmente conforme novos artefatos do BC surgem."
	}

	workOrder: ["tbd"]

	sections: {
		"tbd": {
			target:    "#Glossary"
			objective: "TBD — section substantiva em commit 2 da sequência."
			process: [{
				action: "TBD substituído em commit 2 da sequência"
				detail: "Placeholder mínimo satisfazendo schema MinRunes(10)."
			}]
			doneCriteria: "TBD — substituído em commit 2 da sequência."
		}
	}

	finalValidation: {
		steps: [
			"TBD — finalValidation substantiva em commit 3 da sequência.",
		]
	}
}
