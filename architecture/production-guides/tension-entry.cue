package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// tension-entry.cue — Production guide para Tension Log Entries.
//
// Schema alvo: #TensionEntry (architecture/artifact-schemas/tension-entry.cue).
// Cardinality collection — múltiplas entries em architecture/tension-log/.
// Phase 2 da regra universal de adr-053 (universal coverage); cascade-ordering
// precondition (adr-054 dec 13) — PG existe ANTES de qualquer nova instância
// ten-XXX. Dívida acumulada: ten-001..ten-011 autorados sem PG dedicado;
// reconciliação via change-on-touch.
//
// Tension entry registra TENSÃO documentada — trade-off concreto entre uma
// decisão e um axioma/princípio operacional, OU limitação de schema, OU
// fricção cross-artifact — com target identificável, manifestação rastreável,
// resolution articulada e (quando resolved) evidência rastreável. Tensão NÃO
// é bug travestido (vai para WI), NÃO é deferimento consciente (vai para
// def-XXX per adr-062), NÃO é opinião não-ancorada — é registro estrutural
// para que agentes stateless cross-context recuperem trade-offs aceitos em
// sessões anteriores (lens-knowledge-management).

tensionEntryGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/tension-entry\\.cue$"
			fileNameRegex:      "^tension-entry\\.cue$"
			description:        "Production guide para autoria de tension log entries em mesh-spec."
			rationale:          "Schema #TensionEntry é instanciável (cardinality collection); tq-as-05 + sc-pg-01 (production-guide-coverage per adr-056) exigem PG. Cascade ordering precondition (adr-054 dec 13): PG existe ANTES de novas instâncias ten-XXX; cobre também dívida acumulada de ten-001..ten-011 autorados pre-cascade rule."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-teg-01"
			description: "Guide produz instância com target identificável (tq-te-01) E manifestação rastreável (tq-te-03) — hardening conjunto dos 2 critérios schema-level"
			test:        "Process inclui passo explícito de coletar tensionTarget (axioma ax-XX, princípio dp-XX/PX, ou path de schema existente) E manifestsIn (path de artefato existente) com founder; gapPolicy proíbe targets/paths fictícios; finalValidation step verifica AMBOS tq-te-01 (target) E tq-te-03 (manifestação). tq-teg-01 é hardening conjunto: cobre os dois schema-level fails que juntos definem ancoragem material da tensão."
			severity:    "fail"
			rationale:   "tq-te-01 e tq-te-03 do schema já são fail; guide reitera porque agentes/founder tendem a 'preencher' tensionTarget e manifestsIn com referências aproximadas (ID de axioma plausível mas não verificado; path de artefato não existente) para fechar registro. Tensão sem target identificável e manifestação rastreável vira opinião sem reavaliação possível."
		}, {
			id:          "tq-teg-02"
			description: "Guide força resolution com trade-off concreto (anti-genericidade)"
			test:        "Process da section description-and-resolution exige resolution articulando (a) alternativa escolhida, (b) alternativa rejeitada, (c) o que foi ganho e o que foi perdido. gapPolicy proíbe resolution genérico ('aceito como trade-off', 'convivemos com isso'); finalValidation step verifica tq-te-02. Reforço de guide-level sobre tq-te-02 do schema (já fail)."
			severity:    "fail"
			rationale:   "tq-te-02 do schema já é fail; guide reitera porque resolution genérica é vetor primário de degradação observado — perde informação para reavaliação futura quando contexto mudar. Reavaliabilidade é o propósito do registro."
		}, {
			id:          "tq-teg-03"
			description: "Guide força evidência rastreável quando status é 'resolved'"
			test:        "Process da section status-and-resolution-path exige que status='resolved' implique pelo menos um de structuralResolutionPath (path do mecanismo que resolveu) OU relatedADR (adr-XXX que formalizou a resolução) preenchido. gapPolicy proíbe declaração unilateral de resolved sem evidência; finalValidation step verifica tq-te-04. Reforço de guide-level sobre tq-te-04 do schema (já fail)."
			severity:    "fail"
			rationale:   "tq-te-04 do schema já é fail; guide reitera porque resolved sem evidência é declaração unilateral — não verificável, não revertível. Pattern observado em ten-006 (resolved by adr-040) é o caminho canônico: tensão precede ADR como input rastreável; resolution status só muda quando ADR formaliza."
		}, {
			id:          "tq-teg-04"
			description: "Guide proíbe colapso de tension-entry com bug, deferimento ou opinião"
			test:        "gapPolicy declara explicitamente que tension-entry NÃO é bug travestido (vai para WI), NÃO é deferimento consciente (vai para def-XXX per adr-062), NÃO é opinião sem target estruturalmente identificável. Heuristics da section context-and-classification reforça com critérios diferenciadores. Verificado por inspeção do guide."
			severity:    "warn"
			rationale:   "Tension log atrai uso como catch-all para qualquer 'coisa não resolvida'. Sem critério diferenciador articulado, vira dumping ground — perde valor como mecanismo de externalização de trade-offs estruturais. Anti-catch-all discipline alinha-se com pattern de adr-062 (deferred-decision) onde mesmo problema de naming foi resolvido via critério de pertinência."
		}]
		rationale: "4 critérios cobrem disciplinas centrais para autoria de tension entry: ancoragem material em target+manifestação (tq-teg-01 hardening de tq-te-01/03), resolution articulado como trade-off concreto (tq-teg-02 hardening de tq-te-02), evidência rastreável de resolution (tq-teg-03 hardening de tq-te-04), e anti-catch-all distinguindo tension de bug/deferimento/opinião (tq-teg-04 warn). tq-te-01..04 do schema cobrem o lado de instância autorada; tq-teg-XX cobrem o lado de PROCESSO de autoria — separação consistente com pattern PG-ADR (tq-adrg) e PG-Glossary (tq-gg). Hardening em 01/02/03 (todos fail no schema, todos fail no guide) reitera disciplina porque vetores de degradação observados (referências aproximadas, resolution genérico, resolved sem evidência) são frequentes em authoring por agente; tq-teg-04 warn protege fronteira semântica do tipo."
	}

	prerequisites: {
		description: "Antes de autorar tension entry, agente lê schema #TensionEntry + ten-XXX recentes do mesmo kind como referência estrutural + domain/domain-definition.cue (foundingPrinciples.axioms para ax-XX) + architecture/design-principles.cue (P-XX, dp-XX) quando target é axioma/princípio. Tension entry documenta TENSÃO ESTRUTURAL observada — trade-off com target identificável, manifestação rastreável e (quando resolved) evidência. NÃO é bug travestido nem deferimento consciente."
		collectFromFounder: [
			"Articulação da tensão em uma frase: 'decisão X precisava de Y, mas target Z não suporta diretamente' OU 'axioma A é tensionado pela decisão B em artefato C' — se a tensão não pode ser articulada nesta forma, postergar autoria (talvez seja bug, deferimento ou opinião)",
			"tensionTarget: id de axioma (ax-XX), princípio (dp-XX, PX) ou path de schema cuja limitação gerou a tensão — agente NÃO inventa IDs nem aproxima paths; verifica existência em domain/domain-definition.cue / architecture/design-principles.cue / architecture/artifact-schemas/ ANTES de incluir",
			"manifestsIn: path de artefato existente onde a tensão é observável (regex schema: '^.+/.+\\.(cue|md)$') — agente verifica existência por filesystem; especulativo falha tq-te-03",
			"kind: classificação entre 'axiom-tension' (decisão concreta diverge de axioma/princípio), 'schema-limitation' (schema não suporta o que modelagem precisa expressar), 'cross-artifact-friction' (dois artefatos corretos individualmente entram em atrito) — NÃO usar cross-artifact-friction como catch-all per comment do schema; preferir axiom-tension ou schema-limitation quando target tem id específico",
			"Resolution articulada: alternativa escolhida + alternativa rejeitada + o que foi ganho + o que foi perdido — agente NÃO produz resolution genérico ('aceito como trade-off') que falha tq-te-02",
			"Status: 'open' (identificada, não decidida), 'accepted' (trade-off aceito explicitamente — convive-se), 'resolved' (eliminada por evolução de schema, refatoração ou nova decisão) — se 'resolved', founder fornece structuralResolutionPath OU relatedADR (adr-XXX) como evidência (tq-te-04 fail)",
			"structuralResolutionPath (opcional): mecanismo que resolveria a tensão definitivamente quando known (ex.: 'evolução de #DomainField para suportar optionalidade condicional'); omitir se não há resolução estrutural conhecida — NÃO inventar caminhos especulativos por completude formal",
			"relatedADR (opcional): adr-XXX que formalmente cria ou resolve a tensão — agente verifica existência da ADR ANTES de incluir",
		]
		gapPolicy: "Se a tensão não pode ser articulada como trade-off com target identificável + manifestação concreta, NÃO autore a entry — talvez seja bug travestido (que vai para WI em task-approved), deferimento consciente (que vai para def-XXX per adr-062), ou opinião sem ancoragem estrutural. NÃO invente IDs de axiomas/princípios — verifique existência em domain/domain-definition.cue (axioms) e architecture/design-principles.cue (P-XX, dp-XX) ANTES de incluir em tensionTarget. NÃO inclua paths em tensionTarget ou manifestsIn que não existam no filesystem — paths fictícios falham tq-te-01 e tq-te-03 (ambos fail no schema). NÃO produza resolution genérico ('aceito como trade-off', 'convivemos com isso', 'reavaliar quando necessário') — resolution especifica alternativa escolhida E alternativa rejeitada COM ganho/perda concretos; genérico falha tq-te-02. NÃO declare status 'resolved' sem preencher structuralResolutionPath OU relatedADR — resolução sem evidência rastreável falha tq-te-04. NÃO use kind 'cross-artifact-friction' como catch-all (comment do schema explicita) — preferir axiom-tension ou schema-limitation quando target tem id específico (axioma, princípio, schema). NÃO copie estrutura textual de outra ten-XXX sem verificar que a tensão é genuinamente análoga — cada tensão é específica ao contexto. Se founder confunde tension com bug/deferimento/opinião, redirecionar (bug → WI; deferimento → def-XXX; opinião sem target estrutural → discussão informal sem registro canônico). Quando dúvida persistir, pergunta direta ao founder; nunca preencher por inferência heurística."
		validatorNote: "Em Phase 0, validação é (a) cue vet para shape — incluindo regex de id, date, tensionTarget, manifestsIn, relatedADR enforced no schema, (b) founder review semântico — substantividade do resolution (tq-te-02), genuinidade da tensão vs bug/deferimento (tq-teg-04), e existência das refs cross-file (tq-te-01 axioma/princípio, tq-te-03 manifestsIn) exigem judgment humano não totalmente automatizável em Phase 0. Quando structural-checks de tension-entry existirem (post-WI futuro), tq-te-04 (status='resolved' implica structuralResolutionPath OU relatedADR preenchido) automatiza-se intra-artifact. Existência cross-file de IDs ax-XX/dp-XX/PX e paths em manifestsIn depende de runner futuro."
		outputNote:    "Output é arquivo único architecture/tension-log/ten-NNN-{slug}.cue conformante a #TensionEntry. NNN é zero-padded sequencial sobre o último ten-XXX existente; slug é descritivo em kebab-case (≤6 palavras tipicamente). Regex completo do filename per schema: '^ten-[0-9]{3}-[a-z0-9-]+\\.cue$'. Tamanho típico: 40-120 linhas dependendo da complexidade da tensão (ten-001 = 42 linhas; ten-006 com resolution rica e rationale extenso = 112 linhas). cardinality 'collection' no schema (múltiplas entries no diretório architecture/tension-log/)."
	}

	workOrder: [
		"context-and-classification",
		"description-and-resolution",
		"status-and-resolution-path",
	]

	sections: {
		"context-and-classification": {
			target:    "#TensionEntry"
			objective: "Compor identity (id, date, title), classification (kind), e refs estruturais (tensionTarget, manifestsIn) com base nos inputs do founder. Esta section produz o envelope estrutural antes da redação substantiva da tensão."
			process: [{
				action: "Identificar próximo NNN sequencial"
				detail: "Listar architecture/tension-log/ ordenado; próximo id é último_NNN + 1, zero-padded para 3 dígitos. Verificar inexistência de ten-NNN para evitar colisão. NNN é monotônico, não reusa números (entries withdrawn/rejected mantêm número)."
			}, {
				action: "Compor slug kebab-case e title descritivo"
				detail: "slug deriva da tensão (≤6 palavras tipicamente; a-z, 0-9, hífen). title descreve a tensão de forma curta (não pergunta, não declarativa pura). Exemplos canônicos: 'Validação semântica baseada em LLM apresenta variância entre execuções' (ten-006), '#DomainField não suporta optionalidade intra-value-object' (ten-001)."
			}, {
				action: "Declarar date no formato ISO YYYY-MM-DD"
				detail: "date é a data de registro da tensão (sessão de autoria), não da tensão emergente original se diferente. Regex schema: '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'."
			}, {
				action: "Classificar kind contra os 3 enum values"
				detail: "3 enum values: 'axiom-tension' (decisão concreta diverge de axioma ou princípio operacional — target é ax-XX, dp-XX ou PX); 'schema-limitation' (schema não suporta o que modelagem precisa expressar — target é path de schema); 'cross-artifact-friction' (dois artefatos corretos individualmente entram em atrito entre si — não usar como catch-all per comment do schema; preferir os dois primeiros quando target tem id específico)."
			}, {
				action: "Verificar existência de tensionTarget"
				detail: "Se kind='axiom-tension': tensionTarget ∈ {ax-XX | dp-XX | PX}, verificar id em domain/domain-definition.cue (foundingPrinciples.axioms) ou architecture/design-principles.cue. Se kind='schema-limitation': tensionTarget é path de schema, verificar via filesystem ls. Se kind='cross-artifact-friction': tensionTarget pode ser path de qualquer artefato afetado. ID/path inexistente falha tq-te-01 (fail)."
			}, {
				action: "Verificar existência de manifestsIn"
				detail: "manifestsIn é path de artefato (regex schema: '^.+/.+\\.(cue|md)$') onde tensão é observável. Verificar via filesystem ls. Path especulativo falha tq-te-03 (fail). Limitação conhecida: tensionTarget é singular per comment do schema; tensão que afeta múltiplos targets exige uma entry por target ou target composto descrito textualmente."
			}]
			sources: [
				"architecture/artifact-schemas/tension-entry.cue (#TensionEntry, #TensionKind, #TensionStatus + comments com critérios diferenciadores)",
				"domain/domain-definition.cue (axioms ax-XX para axiom-tension targets)",
				"architecture/design-principles.cue (P-XX, dp-XX para axiom-tension targets)",
				"architecture/tension-log/ (entries existentes ten-001..ten-011 — observar último NNN para sequência)",
				"architecture/tension-log/ten-001-domain-field-optionality.cue (exemplo schema-limitation, 42 linhas)",
				"architecture/tension-log/ten-006-validation-non-determinism.cue (exemplo cross-artifact-friction com resolved-by-ADR, 112 linhas)",
			]
			heuristics: [
				"title descritivo da tensão; pergunta ('como tratar X') ou declaração genérica ('X é problema') é code smell.",
				"kind escolhido por target dominante: axiom-tension se target é id de axioma/princípio; schema-limitation se target é capacidade expressiva de schema; cross-artifact-friction APENAS quando dois artefatos corretos individualmente entram em atrito sem target single-id (anti-catch-all per comment do schema).",
				"tensionTarget verificado contra source canônico ANTES de inclusão — agente NÃO infere existência por similaridade com IDs de outros axiomas/princípios.",
				"manifestsIn aponta para artefato concreto onde tensão é observável; sem manifestação verificável, registro é especulativo.",
				"Tension entry NÃO é bug (vai para WI), NÃO é deferimento consciente (vai para def-XXX per adr-062), NÃO é opinião sem target estrutural — critério diferenciador: existe target identificável + manifestação rastreável + trade-off articulável? se NÃO em qualquer dos três, não é tension entry.",
				"Singularidade do tensionTarget é limitação conhecida do schema — tensão multi-target exige entry por target, ou target composto descrito textualmente em description.",
			]
			doneCriteria: "id sequencial determinado e não-conflitante; title descritivo; date ISO; kind ∈ #TensionKind enum coerente com target; tensionTarget verificado existente em source canônico (axioma/princípio/schema/path); manifestsIn verificado existente no filesystem; tq-te-01 e tq-te-03 satisfeitos."
			ifGap:        "Se tensão não tem target identificável (founder não consegue apontar axioma, princípio ou schema específico), NÃO autore — provavelmente é opinião ou bug. Se kind='cross-artifact-friction' está sendo usado porque axiom-tension/schema-limitation 'não cabem', reconsiderar — comment do schema proíbe catch-all. Se NNN sequencial colide com ten-XXX existente, escolher próximo livre."
		}

		"description-and-resolution": {
			target:    "#TensionEntry"
			objective: "Compor o núcleo substantivo da entry — description (o que a decisão concreta precisava e por que target não suporta) e resolution (trade-off articulado com alternativa escolhida, alternativa rejeitada, ganho e perda)."
			process: [{
				action: "Compor description endereçando necessidade vs limitação do target"
				detail: "description responde duas perguntas: (a) o que a decisão concreta precisava expressar/decidir? (b) por que o target (axioma/princípio/schema) não suporta diretamente? Tamanho típico: 1-3 parágrafos. Ten-001 ilustra padrão schema-limitation (necessidade: optionalidade condicional intra-VO; limitação: #DomainField não suporta). Ten-006 ilustra padrão cross-artifact-friction com observação de propriedades concretas em rodadas de validação."
			}, {
				action: "Compor resolution como trade-off articulado"
				detail: "resolution articula 4 elementos: (1) alternativa ESCOLHIDA — qual caminho foi adotado; (2) alternativa REJEITADA — quais caminhos foram considerados e descartados; (3) GANHO — o que a alternativa escolhida preserva ou habilita; (4) PERDA — o que a alternativa escolhida sacrifica ou limita. Ten-001 padrão minimalista: 'manter os dois campos com discriminador' vs 'dois VOs distintos'; ganho 'linearidade conceitual'; perda 'optionalidade semântica não-estrutural'. Ten-006 padrão extensivo: 'LLM removido categoricamente do papel de gate' como conclusão irrevogável com justificativa completa."
			}, {
				action: "Verificar tq-te-02 sobre substantividade do resolution"
				detail: "resolution especifica alternativa escolhida E rejeitada COM ganho/perda concretos? Genérico ('aceito como trade-off', 'convivemos com isso', 'reavaliar quando necessário') falha tq-te-02 (fail). Teste: alguém lendo a entry em 6 meses consegue reconstruir o espaço de decisão e reavaliar se o trade-off ainda é válido? Se NÃO, resolution é insuficiente."
			}, {
				action: "Verificar não-conflação tension vs bug/deferimento (tq-teg-04 warn)"
				detail: "Critério diferenciador: tensão tem target estrutural identificável + trade-off articulável (ESTE é tension); coisa pendente sem trade-off articulado é bug ou trabalho rotineiro (vai para WI); decisão de NÃO resolver agora com trade-off articulado e condição de revisita codificada é deferimento consciente (vai para def-XXX per adr-062). Se entry está virando catch-all, reconsiderar se tipo é apropriado."
			}]
			sources: [
				"architecture/artifact-schemas/tension-entry.cue _qualityCriteria (tq-te-02 trade-off concreto; tq-te-04 evidência de resolved)",
				"architecture/tension-log/ten-001-domain-field-optionality.cue (resolution minimalista substantivo, padrão schema-limitation)",
				"architecture/tension-log/ten-006-validation-non-determinism.cue (resolution extensivo com conclusão irrevogável, padrão cross-artifact-friction resolved-by-ADR)",
				"architecture/artifact-schemas/deferred-decision.cue (referência diferenciadora — quando tensão vira deferimento)",
			]
			heuristics: [
				"description fala da NECESSIDADE concreta vs LIMITAÇÃO do target — não history geral do tópico nem discussão filosófica.",
				"resolution articula 4 elementos: alternativa escolhida, alternativa rejeitada, ganho, perda — sem os 4, falha tq-te-02.",
				"resolution genérico ('aceito como trade-off', 'convivemos com isso') é vetor #1 de degradação observado — fail por construção.",
				"Substituibilidade test: trocar 'esta tensão' por 'qualquer tensão' no resolution. Se texto continua válido, está genérico; reescrever com referências concretas ao target/manifestação.",
				"tension vs bug: bug TEM solução conhecida e pendente de execução (vai para WI); tension TEM trade-off aceito sem solução estrutural disponível (fica registrada).",
				"tension vs deferimento (per adr-062): deferimento é decisão de NÃO resolver agora COM condição codificada de revisita; tension é trade-off aceito SEM revisita programada por construção (revisita acontece quando contexto muda, não por trigger automático).",
				"Volume típico de description: 1-3 parágrafos para tensões simples (ten-001); pode escalar para 10+ parágrafos quando observação tem múltiplas propriedades documentadas (ten-006).",
				"Volume típico de resolution: 1 parágrafo para trade-off direto (ten-001); pode escalar para 3-5 parágrafos quando resolução tem conclusão irrevogável que precisa ser articulada (ten-006).",
			]
			doneCriteria: "description ≥1 parágrafo cobrindo necessidade + limitação do target; resolution articula alternativa escolhida + alternativa rejeitada + ganho + perda concretos; tq-te-02 satisfeito (trade-off concreto, não genérico); tq-teg-04 verificado (entry é genuinamente tension, não bug/deferimento/opinião)."
			ifGap:        "Se resolution fica genérico após reescritas, reconsiderar se trade-off real existe — sem trade-off articulável, talvez seja bug pendente (vai para WI) ou deferimento (vai para def-XXX). Se description não consegue articular limitação concreta do target, reconsiderar se target está correto — talvez kind precise mudar (ex.: schema-limitation vira axiom-tension se limitação real é divergência principial)."
		}

		"status-and-resolution-path": {
			target:    "#TensionEntry"
			objective: "Declarar status (open/accepted/resolved), structuralResolutionPath e relatedADR conforme aplicável, com evidência rastreável quando status='resolved' (tq-te-04). Compor rationale do registro."
			process: [{
				action: "Declarar status"
				detail: "3 enum values: 'open' (tensão identificada, ainda não decidida — typical em registro inicial quando founder ainda avalia caminhos); 'accepted' (trade-off aceito explicitamente — convive-se com a tensão; mais comum para schema-limitation onde resolução estrutural é futura); 'resolved' (tensão eliminada por evolução de schema, refatoração ou nova decisão — exige evidência via structuralResolutionPath OU relatedADR per tq-te-04 fail)."
			}, {
				action: "Declarar structuralResolutionPath se aplicável"
				detail: "Campo opcional. Quando há mecanismo conhecido que resolveria a tensão definitivamente (não necessariamente implementado), declarar como descrição substantiva (ex.: 'Evolução de #DomainField para suportar optionalidade condicional' em ten-001). Se não há resolução estrutural conhecida, OMITIR — NÃO inventar caminho especulativo por completude formal."
			}, {
				action: "Declarar relatedADR se aplicável"
				detail: "Campo opcional. Regex schema: '^adr-[0-9]{3}$'. Quando ADR formaliza decisão que cria ou resolve a tensão, incluir id. Verificar EXISTÊNCIA da ADR em architecture/adrs/ ANTES de incluir — id inventado quebra rastreabilidade. Pattern canônico observado em ten-006: tensão precede ADR como input rastreável; relatedADR preenchido após ADR aprovada; status pode mudar para 'resolved' nesse momento."
			}, {
				action: "Verificar tq-te-04: resolved exige evidência"
				detail: "Se status='resolved': pelo menos UM entre structuralResolutionPath e relatedADR DEVE estar preenchido. Resolution sem evidência rastreável é declaração unilateral — não verificável, não revertível. Verificação determinística (poderá ser automatizada via structural-check futuro). Falha → reconsiderar status (talvez 'accepted' é mais correto se evidência ainda não existe)."
			}, {
				action: "Compor rationale do registro"
				detail: "rationale explica POR QUE esta tensão merece registro canônico — específico ao contexto Mesh. Útil para articular: relação com ADRs (input rastreável vs resolução), valor do registro para agentes stateless cross-context (lens-knowledge-management), pertinência conforme critérios diferenciadores (não é bug nem deferimento). NÃO confundir com description (que é o WHAT da tensão) — rationale é o WHY de existir como tension entry."
			}]
			sources: [
				"architecture/artifact-schemas/tension-entry.cue _qualityCriteria (tq-te-04 resolved exige evidência)",
				"architecture/adrs/ (ADRs existentes para verificar relatedADR id antes de incluir)",
				"architecture/tension-log/ten-001-domain-field-optionality.cue (status='accepted' com structuralResolutionPath substantivo, sem relatedADR)",
				"architecture/tension-log/ten-006-validation-non-determinism.cue (status='resolved' com relatedADR='adr-040' como evidência canônica)",
			]
			heuristics: [
				"status default em registro inicial: 'accepted' quando trade-off já decidido na sessão de autoria; 'open' quando registro precede decisão; 'resolved' APENAS se structuralResolutionPath OU relatedADR está preenchido com evidência verificada.",
				"structuralResolutionPath descreve mecanismo conceitual de resolução — não é WI agendado nem promessa de execução; é hipótese de qual caminho estrutural eliminaria a tensão.",
				"relatedADR é preenchido APÓS ADR aprovada — referenciar id de ADR em draft viola rastreabilidade.",
				"Pattern canônico (ten-006): tensão registrada PRIMEIRO como input rastreável; ADR autorada subsequente referencia tensão; quando ADR aprovada, relatedADR é preenchido na entry e status pode mudar para 'resolved'. Não inverter ordem (ADR-first sem tension entry perde rastreabilidade da observação que motivou a decisão).",
				"rationale do registro NÃO duplica description — articula POR QUE este registro existe (valor para reavaliação futura, input para ADR, externalização de trade-off para agentes stateless cross-context).",
				"Se status='resolved' mas evidência ausente, recuar para 'accepted' — declaração unilateral de resolved é pior que registro accurate de accepted com resolução pendente.",
			]
			doneCriteria: "status declarado coerente com evidência disponível; structuralResolutionPath e relatedADR preenchidos quando aplicáveis (e omitidos quando não — não inventados); tq-te-04 satisfeito (status='resolved' implica ≥1 evidência preenchida); rationale articula valor do registro sem duplicar description."
			ifGap:        "Se status='resolved' sem evidência disponível, recuar para 'accepted' — não declarar resolved sem rastreabilidade. Se relatedADR de ADR ainda não aprovada está sendo considerado, OMITIR até ADR ser commitada e aprovada (referência a ADR em draft viola rastreabilidade). Se rationale fica redundante com description, reescrever focando no WHY do registro (valor de externalização) vs WHAT da tensão."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #TensionEntry (todos os campos obrigatórios presentes; tipos corretos; regex de id, date, tensionTarget, manifestsIn, relatedADR satisfeitos).",
			"Verificar tq-pg-01 / tq-mg-01: workOrder é permutação exata das chaves de sections (3 sections; sem redundância, omissão ou duplicata).",
			"Verificar tq-pg-02: cada section.target referencia tipo existente em schema adotado (#TensionEntry para todas 3 sections deste guide).",
			"Verificar tq-pg-04 / tq-mg-04: prerequisites.gapPolicy ≥50 runes E declara explicitamente comportamento anti-invenção (cláusulas 'NÃO autore se tensão não articulável', 'NÃO invente IDs de axiomas/princípios', 'NÃO inclua paths que não existam', 'NÃO produza resolution genérico', 'NÃO declare status resolved sem evidência', 'NÃO use cross-artifact-friction como catch-all', 'NÃO copie estrutura de outra ten-XXX sem verificar análoga').",
			"Verificar tq-pg-05 / tq-mg-03: finalValidation.steps[-1] menciona submissão/revisão/aprovação do founder.",
			"Verificar tq-pg-06 / tq-mg-02: cada section.process[].action começa com verbo imperativo concreto da lista canônica (Identificar, Compor, Declarar, Verificar, ...).",
			"Verificar tq-te-01 / tq-teg-01 (hardened fail): tensionTarget existe — id de axioma/princípio verificado em domain/domain-definition.cue ou architecture/design-principles.cue, OU path de schema verificado por filesystem ls. ID inventado ou aproximado falha.",
			"Verificar tq-te-02 / tq-teg-02 (hardened fail): resolution articula alternativa escolhida + alternativa rejeitada + ganho + perda concretos. Genérico ('aceito como trade-off', 'convivemos com isso') = fail.",
			"Verificar tq-te-03 / tq-teg-01 (hardened fail): manifestsIn aponta para artefato existente verificado por filesystem ls. Path especulativo = fail.",
			"Verificar tq-te-04 / tq-teg-03 (hardened fail): se status='resolved', pelo menos UM entre structuralResolutionPath e relatedADR está preenchido com evidência verificada (ADR id existe em architecture/adrs/). Resolved sem evidência = fail; recuar para 'accepted'.",
			"Verificar anti-catch-all (tq-teg-04 warn): entry é genuinamente tension (target estrutural identificável + manifestação rastreável + trade-off articulável), NÃO bug travestido (que vai para WI em task-approved), NÃO deferimento consciente (que vai para def-XXX per adr-062), NÃO opinião sem ancoragem estrutural. Se kind='cross-artifact-friction' está sendo usado, verificar que axiom-tension/schema-limitation realmente não cabem (anti-catch-all per comment do schema).",
			"Verificar canonical removal test (tq-mg-10 warn): se esta tension entry for removida, o trade-off documentado perde seu registro canônico — agentes stateless cross-context perdem acesso à decisão; entry existe para externalizar conhecimento organizacional (lens-knowledge-management), não para enforcement. Resposta esperada: SIM (tension entries são OBSERVADORES/REGISTROS, não enforcers — ADRs e schemas é que enforçam).",
			"Submeter ao founder para aprovação explícita antes de commit — step próprio bloqueante per adr-057 founderConfirmation (NÃO absorvido na inspeção de critérios precedentes; gate humano distinto da inspeção de conformity).",
		]
	}
}
