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

	workOrder: [
		"context-and-term-identification",
		"term-content-and-anchoring",
		"validation-and-meta",
	]

	sections: {
		"context-and-term-identification": {
			target:    "#Glossary"
			objective: "Estabelecer BC alvo, ler artefatos source (canvas, domain-model se existir, lens-domain-language) e identificar candidate terms a partir do vocabulário emergente."
			process: [{
				action: "Localizar canvas.cue do BC alvo e extrair canvas.code"
				detail: "Verificar contexts/{bc}/canvas.cue existe. canvas.code (3 letras) determina boundedContextRef e glossary.code do output (alinhamento por construção, validado por tq-gl-07)."
			}, {
				action: "Ler canvas + domain-model (se existir) + lens-domain-language"
				detail: "Canvas é fonte primária do vocabulário do BC (purpose, capabilities, businessDecisions, communication, stakeholders). Domain-model fornece aggregate/entity/value-object names para domainModelRefs. Lens fornece dimensões dl-bilingual-terminology, dl-term-selection-criteria, dl-cross-layer-consistency."
			}, {
				action: "Coletar candidate terms a partir do vocabulário do canvas"
				detail: "Termos emergem de: nomes de conceitos centrais em canvas.purpose/capabilities/businessDecisions; aggregates do domain-model (se existir); commands/events em canvas.communication. Liste 5-15 candidates iniciais — glossário cresce incremental."
			}, {
				action: "Confirmar lista de candidates com founder"
				detail: "Apresentar lista com nome canônico + 1-line definition. Founder filtra: quais merecem entrada canônica, quais são triviais/universais (skip), quais são transversais (vivem em context-map). NÃO inventar terms ausentes do vocabulário operacional."
			}, {
				action: "Compor metadata do glossary"
				detail: "code = canvas.code (lowercase, 3 letras). name = canvas.name (Title Case). boundedContextRef = canvas.code. rationale do glossary explica escopo conceitual da UL no BC."
			}]
			sources: [
				"architecture/artifact-schemas/glossary.cue (schema #Glossary + #GlossaryTerm)",
				"architecture/lenses/lens-domain-language-and-terminology-design.cue (3 dimensões aplicadas)",
				"architecture/design-principles.cue (P1 — UL como SoT)",
				"contexts/cmt/glossary.cue (exemplo completo, 267 linhas)",
				"contexts/ctr/glossary.cue (exemplo, 306 linhas)",
			]
			heuristics: [
				"Candidate term emerge do vocabulário do canvas; não inventar termos ausentes do canvas.",
				"Aggregate/entity names do domain-model são candidatos prioritários para term entries.",
				"Termos transversais entre BCs vivem em strategic/context-map.cue, NÃO no glossary do BC.",
				"Termos universais (hash, file, request, server) NÃO entram — glossary captura específico do domínio.",
				"Homônimos entre BCs com significado diferente são esperados — cada BC tem seu glossary independente.",
				"Glossary cresce incrementalmente: começar com termos centrais; adicionar conforme domain-model e workflows materializam novos conceitos.",
				"Evitar fragmentação excessiva: variações de estado ou atributos de um conceito NÃO geram novos terms a menos que alterem identidade semântica do conceito no BC (ex.: 'Recebível' é um term; 'Recebível Confirmado' é estado, não term separado; 'Recebível Elegível' é critério, não term).",
				"Exemplos em sources (contexts/cmt/glossary.cue, contexts/ctr/glossary.cue) são não-normativos: em conflito entre exemplo e schema/guide, schema + guide prevalecem.",
			]
			doneCriteria: "BC identificado com canvas existente; canvas + domain-model (se houver) + lens-domain-language lidos; lista substantiva de candidate terms confirmada com founder; metadata (code, name, boundedContextRef) derivada do canvas."
			ifGap:        "Se canvas do BC não existe, postergar criação (glossary depende de canvas). Se domain-model não existe, prosseguir com canvas + businessDecisions como fonte primária — domainModelRefs ficam vazios e são preenchidos quando domain-model surgir."
		}

		"term-content-and-anchoring": {
			target:    "#GlossaryTerm"
			objective: "Para cada candidate term, preencher os 6 campos obrigatórios (code, name, termEn, definition, category, rationale) e adicionar ancoragem semântica."
			process: [{
				action: "Derivar code e definir nomes (name pt-BR, termEn English)"
				detail: "code = 'term-' + slug do nome (regex: ^term-[a-z][a-z0-9]*(-[a-z0-9]+)*$). name é o termo em pt-BR como aparece em conversação de domínio. termEn é o nome para code generation (regex permite multi-word: '^[A-Za-z][A-Za-z0-9]*( [A-Za-z][A-Za-z0-9]*)*$'). Para loanwords (Score, Compliance), name == termEn é válido."
			}, {
				action: "Escrever definition substantiva e operacional"
				detail: "Definition é precisa o suficiente para agente decidir nomes de classes, campos e métodos sem ambiguidade. NÃO redundante com name (tq-gl-05 / tq-gg-03). Tamanho típico: 30-150 runes. Inclui o que define identidade do termo, não apenas exemplos."
			}, {
				action: "Classificar category"
				detail: "10 enum values: entity, value, process, role, rule, event, command, metric, document, classification. Mapping ao domain-model: entity↔aggregate/entity, value↔value-object, rule↔invariant, event↔domain-event, command↔command. Casos ambíguos (process vs role vs metric): escolher por intent dominante do conceito no BC, não por overlap conceitual."
			}, {
				action: "Compor rationale: por que termo merece entrada canônica neste BC"
				detail: "Rationale é específico ao BC alvo. Útil quando há termos próximos em outros BCs com significado diferente, ou quando seleção terminológica foi não-trivial. NÃO confundir com definition — rationale é o WHY de existir como termo separado, não o WHAT."
			}, {
				action: "Adicionar ancoragem semântica (mínimo 1)"
				detail: "Pelo menos um entre: examples (concretos para disambiguação), antiTerms (o que NÃO é, com clarification), relatedTerms (refs a outros term-XX deste glossary), domainModelRefs (refs a building blocks com prefixo canônico agg-/ent-/vo-/ev-/cmd-/inv-/ws-/pol-). NOTA: synonyms e rejectedAlternatives são campos opcionais úteis mas NÃO contam como ancoragem per tq-gl-09 do schema."
			}, {
				action: "Avaliar campos opcionais (synonyms, rejectedAlternatives, layerMapping)"
				detail: "synonyms são INFORMAIS (aparecem em conversa com domain expert), não nomes canônicos. rejectedAlternatives documenta seleção deliberada per dl-term-selection-criteria — incluir quando escolha não foi óbvia (registrar alternativas consideradas, razão de rejeição, motivo da escolha canônica). layerMapping (codeTerm/apiTerm/uiLabel) opcional — omitir se layers não estabilizadas (preencher por completude formal viola tq-gl-10)."
			}]
			sources: [
				"architecture/artifact-schemas/glossary.cue (#GlossaryTerm + sub-types #AntiTerm, #RejectedAlternative, #TermExample, #LayerMapping)",
				"architecture/lenses/lens-domain-language-and-terminology-design.cue (dl-bilingual-terminology, dl-term-selection-criteria, dl-cross-layer-consistency)",
				"contexts/cmt/glossary.cue (exemplos de ancoragem variada)",
				"contexts/ctr/glossary.cue (exemplos com layerMapping populado)",
			]
			heuristics: [
				"Cada term representa um único conceito semântico; termos que agregam múltiplos conceitos (ex.: 'Pagamento e Liquidação', 'Verificação e Autorização') são inválidos e devem ser decompostos em terms separados.",
				"definition é precisa o suficiente para agente decidir nomes de classes sem ambiguidade — vaga é falha tq-gg-03.",
				"definition NÃO depende do próprio termo nem de sinônimos para se explicar — evitar circularidade semântica (ex.: 'Verificação de Identidade' definida como 'processo que verifica identidade' é circular e inválida).",
				"termEn não é tradução frouxa — é o nome que aparece em código e API; tradução errada propaga downstream.",
				"termEn preserva intenção operacional, mesmo quando tradução literal em inglês seria estranha — preferir nome idiomático de software/domain modeling em vez de tradução escolar (ex.: 'Recebível' → 'Receivable', não 'Receivable Document'; 'Antecipação' → 'Anticipation Operation', não literal 'Advance').",
				"category escolhida por intent dominante: process se sequência de atividades; role se papel assumido; metric se medida; classification se taxonomia.",
				"Ancoragem (tq-gg-02): preferir examples para conceito concreto operacional (NF-e, ICMS); antiTerms quando confusão com termo de outro BC é frequente; relatedTerms para conceitos do mesmo BC; domainModelRefs quando há agregado correspondente.",
				"synonyms e rejectedAlternatives NÃO contam como ancoragem — preencher esses sem ≥1 dos 4 anchors verdadeiros falha tq-gg-02.",
				"rejectedAlternatives substantivo per dl-term-selection-criteria: registrar (a) alternativas consideradas, (b) razão de rejeição de cada uma, (c) motivo da escolha canônica QUANDO escolha foi não-trivial — não preencher por completude formal.",
				"domainModelRefs usam prefixos canônicos do schema #DomainModel: agg- (aggregate), ent- (entity), vo- (value-object), ev- (event), cmd- (command), inv- (invariant), ws- (workflow-step), pol- (policy).",
			]
			doneCriteria: "Cada term tem 6 campos obrigatórios preenchidos (code, name, termEn, definition, category, rationale); definition ≥30 runes não-redundante com name nem synonyms; ≥1 anchor declarado entre examples/antiTerms/relatedTerms/domainModelRefs; termEn satisfaz regex; category é enum válido."
			ifGap:        "Se founder não definir termo com precisão suficiente para code generation, OMITA do glossary inicial — não invente. Se candidate term não tem ancoragem natural disponível (sem domain-model peer, sem examples concretos, sem relatedTerms aplicáveis), questionar se merece entrada canônica vs trivializar definition."
		}

		"validation-and-meta": {
			target:    "#Glossary"
			objective: "Executar 13 tq-gl-XX checks intra-glossário + cue vet + finalValidation com submissão ao founder."
			process: [{
				action: "Executar cue vet ./contexts/{bc}/ ./architecture/artifact-schemas/"
				detail: "Validação de shape: instância valida contra #Glossary; #GlossaryTerm shape OK; regex de code, termEn satisfeitos. Falha aqui bloqueia avanço."
			}, {
				action: "Verificar unicidade (tq-gl-01/12/13): code, termEn, name"
				detail: "Listar todos terms[].code, terms[].termEn, terms[].name. Detectar duplicatas em cada um. Fail bloqueia. Cobertura: tq-gg-01 do guide herda estes 3."
			}, {
				action: "Verificar integridade referencial intra-glossary (tq-gl-02, tq-gl-08)"
				detail: "tq-gl-02: cada terms[].relatedTerms[].ref existe em terms[].code do mesmo glossary (cross-glossary refs não suportadas). tq-gl-08: nenhum terms[] inclui o próprio code em relatedTerms[]."
			}, {
				action: "Verificar qualidade semântica intra-term (tq-gl-05/06/09)"
				detail: "tq-gl-05 (warn schema, fail tq-gg-03 guide): definition ≠ name; definition ≠ synonym; synonym ≠ name/termEn. tq-gl-06 (warn): antiTerms[].term ≠ terms[].name|synonyms (case-insensitive). tq-gl-09 (warn schema, fail tq-gg-02 guide): ≥1 entre examples/antiTerms/relatedTerms/domainModelRefs."
			}, {
				action: "Verificar alinhamento cross-artifact (tq-gl-07)"
				detail: "boundedContextRef === canvas.code do mesmo BC. Validação por inspeção em Phase 0; runner futuro automatiza."
			}, {
				action: "Verificar tq-gl-10/11 (warn) e tq-gl-03/04 (parcial)"
				detail: "tq-gl-10: layerMapping presente → ≥1 campo não-vazio. tq-gl-11: termEn não idêntico a name (exceto loanwords); termEn não duplica synonyms. tq-gl-03: domainModelRefs prefixos válidos (CUE catch via regex); existência cross-file depende de runner. tq-gl-04: cobertura de aggregates depende de runner. Em Phase 0 sem runner, founder review substitui via inspeção visual."
			}, {
				action: "Submeter ao founder para aprovação antes de commit"
				detail: "Apresentar glossary completo com sumário: BC, número de terms, distribuição por category, coverage de aggregates (se domain-model existir). Founder aprova antes de write."
			}]
			heuristics: [
				"Cue vet primeiro — sintaxe e shape antes de critérios semânticos.",
				"Cobertura de aggregates (tq-gl-04) é warn — pode ser preenchida incrementalmente em sessions futuras quando domain-model crescer.",
				"Cross-glossary validation (homônimos entre BCs) NÃO é coberta por este guide — depende de tooling futuro per limitação declarada no schema #Glossary.",
				"finalValidation.steps[-1] sempre menciona submissão ao founder — sem isso, ciclo propor→aprovar→escrever está quebrado.",
			]
			doneCriteria: "cue vet limpo recursive; tq-gl-01/02/05/06/07/08/09/12/13 verificados intra-glossário; tq-gl-03/04/10/11 reportados (warn ou advisory) com nota de cobertura parcial em Phase 0; founder aprovou."
			ifGap:        "Se cue vet falhar, corrigir sintaxe (não exige novo ciclo de proposta per CLAUDE.md). Se tq-gl-01/12/13 falhar com duplicatas, reconsiderar se conceitos realmente são distintos OU merge dos termos OU diferenciar com termEn distintos."
		}
	}

	finalValidation: {
		steps: [
			"TBD — finalValidation substantiva em commit 3 da sequência.",
		]
	}
}
