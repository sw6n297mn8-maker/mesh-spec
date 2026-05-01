package production_guides

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
)

// production-guide.cue — Meta-guide para autoria de production guides.
//
// Schema alvo: #ProductionGuide em architecture/artifact-schemas/production-guide.cue
// (adotado verbatim de tekton-spec/portfolio/artifact-schemas/production-guide.cue).
//
// Auto-referencial: este guide é ele próprio uma instância de #ProductionGuide
// e satisfaz os critérios tq-pg-XX e tq-mg-XX que ensina. Quem ler este guide
// pode usá-lo como template para escrever production guides para outros schemas.
//
// Resolve auto-violação de tq-as-05 latente em tekton e mesh (schema
// #ProductionGuide instanciável sem guide próprio). Tekton continua sem
// guide upstream — dívida pode ser fechada por promoção FP-02 ou equivalente.
//
// Adaptado mecanicamente do meta-guide auster-spec (origin/main commit 2dc4a1e,
// sessão 2026-04-26, produzido via 3 ciclos de red team) em 2026-04-27.
// Adaptações: import path mesh-spec; sources cross-repo apontando para
// tekton-spec/portfolio/production-guides/ (evita coupling com auster);
// package, variable name, canonicalPathRegex e quality criteria preservados.
// Materializado em 3 commits sequenciais (scaffold → sections → finalValidation).
//
// Iteração pós-PG-A/PG-B founder reviews (sessão 2026-05-01): 6 disciplinas
// generalizadas adicionadas a partir de gaps identificados em revisão de
// PG-A (tq-agg-05..10) — enforcement owner declarado, derived→source ref
// explícita, impact classification ortogonal a category, default+override
// granularity articulada, decide-vs-execute separation em units of work
// irreversíveis, canonical removal test universal. 6 critérios tq-mg
// adicionados (tq-mg-05..10 todos warn) representando as disciplinas no
// nível meta — futuros PGs (lens, adr-pg, structural-check-pg, ~18+
// pendentes) já saem com essas distinções por construção, sem depender de
// founder review post-hoc para descobri-las.
//
// Diagnóstico capturado: PGs existentes (domain-model, glossary, agent-
// spec, agent-governance) acumularam disciplinas via review iterativa.
// Lifting disciplinas ao meta-PG é o ponto de inflexão que muda autoria
// de "descoberta post-hoc" para "default-by-construction". PGs já
// autorados ficam intocados — reconciliação via change-on-touch quando
// receberem amendments futuros, não como refactor proativo.

productionGuideGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/production-guide\\.cue$"
			fileNameRegex:      "^production-guide\\.cue$"
			description:        "Meta-guide para autoria de production guides em mesh-spec."
			rationale:          "Schema #ProductionGuide é instanciável; tq-as-05 exige guide. Este artefato fecha a meta-recursão localmente em mesh, com candidato a promoção upstream a tekton (FP-02 ou equivalente)."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-mg-01"
			description: "Guide produz instância que satisfaz tq-pg-01 (workOrder == keys(sections))"
			test:        "Process inclui passo explícito de verificar workOrder como permutação exata das chaves de sections (mesmos elementos, sem duplicatas, sem omissões) ANTES de finalização. Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "Inconsistência workOrder ↔ sections é a falha #1 prevista para production guides; este meta-guide deve preveni-la por construção."
		}, {
			id:          "tq-mg-02"
			description: "Guide produz process steps com verbos imperativos concretos"
			test:        "Para cada section.process[].action: começa com verbo imperativo concreto da lista (Identificar, Declarar, Coletar, Compor, Verificar, Documentar, Pesquisar, Avaliar, Ler, Listar) ou sinônimo equivalente. Heuristics da section repete a regra. Inspeção determinística por análise da primeira palavra de cada action."
			severity:    "warn"
			rationale:   "tq-pg-06 (advisory) do schema requer ações acionáveis; este meta-guide é onde a disciplina é instilada antes da escrita."
		}, {
			id:          "tq-mg-03"
			description: "Guide produz finalValidation que termina com submissão ao founder"
			test:        "finalValidation.steps[-1] menciona explicitamente submissão, revisão ou aprovação do founder. Process do guide inclui passo declarando esta exigência. Verificado por inspeção."
			severity:    "fail"
			rationale:   "tq-pg-05 (warn no schema, fail aqui no meta-guide) garante o ciclo propor→aprovar→escrever. Quebra elimina o gate humano."
		}, {
			id:          "tq-mg-04"
			description: "Guide produz gapPolicy que declara comportamento anti-invenção"
			test:        "gapPolicy declara explicitamente comportamento anti-invenção (contém substring 'NÃO invent' ou 'NÃO infer' ou equivalente direto). E heuristics em pelo menos 1 section reforça o princípio. Inspeção determinística por presença de cláusula proibitiva."
			severity:    "fail"
			rationale:   "tq-pg-04 advisory requer gapPolicy substantiva; meta-guide eleva a fail para forçar disciplina anti-fabulação. Sem cláusula proibitiva explícita, agente preenche por analogia ou inferência heurística — fonte primária de drift."
		}, {
			id:          "tq-mg-05"
			description: "Guide força enforcement owner declarado quando instância carrega rule/constraint/check"
			test:        "Quando schema alvo do guide define elementos do tipo rule/constraint/check (ex.: agent-spec.constraints[], structural-check rules, validation-prompt assertions), guide produz heuristics OR critério dedicado exigindo que cada rule declare WHERE é enforced — agent (in-line), runner (deterministic gate pós-submission), domain (via aggregate/lifecycle), external (sistema externo). Heuristic-level até schema absorver como first-class. Verificado por inspeção quando schema alvo qualifica."
			severity:    "warn"
			rationale:   "Sem enforcement owner declarado, rule vira ambígua — duplicação (vários enforcers da mesma regra), gap (ninguém valida), drift (validação muda silenciosamente) tornam-se inevitáveis. Generalização de tq-agg-05 (enforcementLevel per constraint) descoberta via PG-A founder review; pattern aplica a todo schema com elementos rule-bearing."
		}, {
			id:          "tq-mg-06"
			description: "Guide força ref explícita de derived→source quando instância carrega elementos derivados"
			test:        "Quando schema alvo declara elementos que derivam de outro artefato (ex.: agent-spec.constraints derivam de domain-model.invariants; structural-checks derivam de ADRs; validation-prompts derivam de quality-criteria), guide produz heuristics OR critério dedicado exigindo ref explícita do elemento derivado a sua origem (e.g., derivedFromInvariant: 'inv-XYZ'). Default 1:1 — múltiplas refs sugere split. Verificado por inspeção quando schema alvo qualifica."
			severity:    "warn"
			rationale:   "Sem ref estruturada, coverage derived↔source vive em prosa — runner futuro não consegue validar coverage automaticamente nem detectar drift quando source é renomeado/removido. Generalização de tq-agg-06 (derivedFromInvariant). Aligns com adr-055 pattern (cross-aggregate-state-dependency como first-class)."
		}, {
			id:          "tq-mg-07"
			description: "Guide força impact classification ortogonal a category quando instância carrega elementos operacionais"
			test:        "Quando schema alvo declara elementos operacionais (ex.: agent-spec.actions, domain-model.commands/events, services), guide produz heuristics OR critério dedicado exigindo declaração de impact dimension ortogonal a category — read-only / state-change / cross-bc / external-side-effect (taxonomia adaptável ao tipo). impact informa governance (caps, escalation, audit cadence). Verificado por inspeção quando schema alvo qualifica."
			severity:    "warn"
			rationale:   "Category sozinho perde sinalização de blast radius real — duas mutations com impact distintos (state-change interno vs external-side-effect regulatory) exigem governance diferente. Generalização de tq-agg-07 (action impact classification)."
		}, {
			id:          "tq-mg-08"
			description: "Guide força articulação de default+override granularity quando padrão aparece"
			test:        "Quando schema alvo carrega configuração que admite default global + override per-element (ex.: escalation conditions global + per-action; SLA global + per-route; autonomyLevel default + override), guide produz heuristics OR critério dedicado exigindo articulação de QUANDO override aplica (exceção vs regra). Default 'override é exceção' — over-declaração polui artefato. Verificado por inspeção quando schema alvo qualifica."
			severity:    "warn"
			rationale:   "Default+override pattern sem articulação explícita gera over-declaração (overrides sempre presentes mascaram default) ou under-declaração (override genuíno necessário fica implícito). Generalização de tq-agg-08 (per-action escalation override) — pattern aparece em vários schemas."
		}, {
			id:          "tq-mg-09"
			description: "Guide força decide-vs-execute separation em units of work irreversíveis"
			test:        "Quando schema alvo carrega units of work que podem combinar decisão (julgar/avaliar/recomendar) com execução irreversível (mutate/publish/emit), guide produz heuristics OR critério dedicado proibindo unidades monolíticas decide+execute em irreversíveis. Pattern recomendado: split em par decide-X (output: recommendation) + execute-X (input: approved recommendation), permitindo human gate entre os dois steps. Verificado por inspeção quando schema alvo qualifica."
			severity:    "warn"
			rationale:   "Unidade monolítica decide+executa em irreversíveis viola P10 por design — não há onde inserir human gate em propose-and-wait, decisão e execução acontecem atomicamente. Generalização de tq-agg-09 (action decision-execution split). Pattern aplica a actions, commands, workflows, sagas."
		}, {
			id:          "tq-mg-10"
			description: "Guide força canonical removal test (universal)"
			test:        "Guide produz finalValidation step OR heuristic dedicada com teste canônico: 'se remover este artifact type do sistema, invariants críticos do BC/sistema permanecem protegidos por outros enforcers (lifecycle, command handler, runner, gate determinístico, sistema externo)?'. Resposta esperada: SIM — artefato é OPERADOR/OBSERVADOR, não único enforcer. Resposta NÃO indica bug arquitetural — artefato está segurando lógica que deveria estar em outra camada. UNIVERSAL: aplica a TODO schema, não apenas agent-spec."
			severity:    "warn"
			rationale:   "Canonical test enforça a inversão domínio-é-centro: cada artifact type é OPERADOR sobre invariants do domínio, não SEGURADOR. Sem este teste durante autoria, agentes/projections/services/etc. acumulam silenciosamente lógica que pertence ao domínio — frágil em escala. Generalização de tq-agg-10. Universal porque a pergunta 'quem é o real enforcer?' é independente do tipo do artefato."
		}]
		rationale: "10 critérios cobrem disciplinas core para autoria de production guides: 4 originais (inconsistência workOrder↔sections, process vago, finalValidation sem founder gate, gapPolicy permissiva) + 6 derivados de PG-A founder review (sessão 2026-05-01) generalizando patterns que apareceram em agent-spec PG: enforcement owner (tq-mg-05), derived→source ref (tq-mg-06), impact classification (tq-mg-07), default+override granularity (tq-mg-08), decide-vs-execute separation (tq-mg-09), canonical removal test (tq-mg-10). Schema #ProductionGuide tem tq-pg-XX cobrindo subconjunto; meta-guide hardens severities (warn→fail em 01, 03, 04) onde fabricação por agente é risco crítico, e adiciona disciplinas meta (05-10 warn) que propagam para futuros PGs. Lifting de disciplinas descobertas em PGs concretos para o meta-PG é o pattern canônico de evolução do sistema (PG-A descoberta → meta-PG código → futuros PGs default)."
	}

	prerequisites: {
		description: "Antes de criar production guide para um schema alvo, agente lê o schema, consulta instâncias existentes (se houver) e guides existentes para outros schemas, confirma com founder o escopo do guide e coleta intent semântico."
		collectFromFounder: [
			"Confirmação do schema alvo (path completo + nome do tipo, ex.: 'architecture/artifact-schemas/foo.cue / #Foo')",
			"Confirmação de que schema é instanciável e merece guide (default é guide obrigatório por tq-as-05; exceção rara para schemas meta-utility deve ser explicitada)",
			"Quaisquer constraints de fase ou contexto (ex.: 'em Fase 0 este schema só é usado por agente, não autor humano' — afeta validatorNote e outputNote)",
			"Heurísticas tácitas que o founder usa ao avaliar instâncias do schema mas que não estão em quality criteria — candidatos a heuristics no guide",
		]
		gapPolicy:     "Se schema alvo não existe ou ainda não foi adotado, NÃO crie o guide especulativamente — postergue até schema existir. Se schema existe mas não tem instâncias autoradas, USE o schema como única fonte (comments + quality criteria) — NÃO invente process steps por analogia com guides de outros schemas. Se founder não souber articular heurísticas tácitas, OMITA o campo heuristics na seção em vez de inventar regras. NÃO copie process steps de outro guide existente sem verificar aderência ao schema alvo — cada schema tem semântica própria. Quando dúvida persistir, pergunta direta ao founder; nunca preencha por inferência heurística."
		validatorNote: "Em Fase 0, validação é review com founder na sessão. Quando structural-check de production-guide-coverage existir (post-motor de build-time), validação automatiza-se via tq-pg-01..06 do schema."
		outputNote:    "Output é arquivo único <schema-basename>.cue em architecture/production-guides/, instanciando #ProductionGuide. Tamanho típico: 30-150 linhas dependendo da complexidade do schema alvo. Para schemas triviais (3-5 campos), guide minimalista de 30-50 linhas é aceitável e esperado."
	}

	workOrder: [
		"target-and-prerequisites",
		"sections-and-workorder",
		"validation-and-meta",
	]

	sections: {
		"target-and-prerequisites": {
			target:    "#ProductionGuide"
			objective: "Estabelecer schema alvo do guide (target type ref) e definir prerequisites — collectFromFounder, gapPolicy, validatorNote, outputNote — antes de qualquer trabalho de seção substantiva."
			process: [{
				action: "Identificar schema alvo"
				detail: "Localizar arquivo do schema em architecture/artifact-schemas/ (ou portfolio/ em tekton). Verificar nome do tipo (ex.: '#BusinessCase' em business-case.base.cue). target deve seguir regex ^#[A-Z][A-Za-z]+$ — nome de tipo CUE válido."
			}, {
				action: "Ler schema completo + comments + quality criteria + 1-3 instâncias existentes (se houver)"
				detail: "Schema é fonte primária para process steps. Comments de campos revelam intent. Quality criteria do schema (tq-XX) revelam o que validar. Instâncias revelam variance prática. Sem schema lido, guide é fabricação."
			}, {
				action: "Coletar collectFromFounder"
				detail: "Liste itens substantivos que o founder fornece antes de instanciar o schema alvo. Específico ao schema (ex.: para #BusinessCase, 'thesis hypothesis em uma frase + métrica âncora preferida + ask em moeda+valor'). Evite genérico tipo 'intent do projeto'."
			}, {
				action: "Compor gapPolicy com cláusula anti-invenção explícita"
				detail: "Regra explícita anti-invenção: declarar o que agente NÃO faz quando dado falta (NÃO inventa, NÃO infere, NÃO copia de outro guide). Mínimo 50 runes (schema constraint). Inclua opções concretas: pergunta direta, postergação, omissão de seção opcional. NUNCA: 'usar melhor julgamento'."
			}, {
				action: "Avaliar validatorNote e outputNote (opcionais mas recomendados)"
				detail: "validatorNote indica quem valida na fase atual (founder em Fase 0, structural-check em fase posterior). outputNote indica formato esperado e tamanho típico do arquivo. Omita se trivialmente óbvio do schema."
			}]
			sources: [
				"architecture/artifact-schemas/production-guide.cue (schema #ProductionGuide, adotado verbatim)",
				"tekton-spec/portfolio/production-guides/business-case.base.cue (guide complexo, 14+ sections com targets sub-tipados)",
				"tekton-spec/portfolio/production-guides/repo-bootstrap-plan.cue (guide rico em heurísticas, 9 sections)",
				"tekton-spec/portfolio/production-guides/claude-config.cue (guide minimalista, 2 sections)",
			]
			heuristics: [
				"target deve ser TypeRef de tipo CONCRETO instanciável, não definição abstrata. Ex.: '#BusinessCase' (concreto) é válido; '#Schema' (abstrato/meta) não é alvo direto.",
				"collectFromFounder mínimo: 1 item substantivo. Schema trivial (3 campos) pode ter 1-2 itens; schema complexo (#BusinessCase) tem 4-6.",
				"gapPolicy declara explicitamente que agente NÃO inventa quando dado faltar; deve perguntar ao founder ou postergar; nunca preencher por analogia ou inferência heurística.",
			]
			doneCriteria: "target apontando para tipo válido do schema alvo, prerequisites com description (≥20 runes), collectFromFounder (≥1 item substantivo) e gapPolicy (≥50 runes anti-invenção) preenchidos. validatorNote e outputNote presentes se agregam clareza sobre fase ou formato; omitidos se não."
			ifGap:        "Se target não existe ou não é tipo válido, schema alvo não está adotado — postergue criação do guide. Se collectFromFounder for < 1 item, founder não tem clareza do que coletar — pergunte explicitamente antes de prosseguir."
		}

		"sections-and-workorder": {
			target:    "#ProductionGuide"
			objective: "Definir sections (chave + #SectionSpec) e workOrder consistente. Sections cobrem o conteúdo substantivo do guide; workOrder é a sequência de produção."
			process: [{
				action: "Identificar partição natural do schema alvo em sections, por atividade autoral lógica"
				detail: "Particionamento por atividade lógica do autor, NÃO estritamente por campo top-level do schema. Schema com 1-3 campos: 1 section única (ex.: #DirectoryMeta → 1 section 'meta'). Schema com 4-15 campos: agrupar campos relacionados em 2-5 sections (ex.: #ProductionGuide tem 7 campos top-level mas 3 sections agrupam por atividade). Schema com 14+ campos (#BusinessCase): granularidade fina, ~14 sections."
			}, {
				action: "Para cada section: definir target, objective, process, heuristics, doneCriteria, ifGap"
				detail: "target da section pode ser igual ao target do guide (instância completa) OU sub-tipo (ex.: guide para #BusinessCase tem section com target #StructuralOpportunity). objective ≥20 runes. process ≥1 step com action+detail concretos. doneCriteria ≥20 runes avaliável. ifGap opcional mas recomendado para schemas com risco de gap em produção."
			}, {
				action: "Compor workOrder como permutação exata de keys(sections)"
				detail: "Lista ordenada dos nomes de section. Ordem reflete dependência causal: section A vem antes de B se conteúdo de A é insumo de B. Ex.: structuralOpportunity antes de market porque mercado deriva da oportunidade."
			}, {
				action: "Verificar tq-pg-01: workOrder é permutação exata das chaves de sections"
				detail: "Mesmos elementos (set equality), sem duplicatas em workOrder, sem omissões em qualquer direção. Conferência manual antes de submeter. Inconsistência aciona tq-pg-01 fail."
			}]
			sources: [
				"architecture/artifact-schemas/production-guide.cue (#SectionSpec, #ProcessStep)",
				"tekton-spec/portfolio/production-guides/business-case.base.cue (granularidade fina, 14+ sections com targets sub-tipados)",
				"tekton-spec/portfolio/production-guides/claude-config.cue (granularidade trivial, 2 sections)",
				"tekton-spec/portfolio/production-guides/repo-bootstrap-plan.cue (granularidade média, 9 sections)",
			]
			heuristics: [
				"process[].action começa com verbo imperativo concreto (Identificar, Declarar, Coletar, Compor, Verificar, Documentar, Pesquisar, Avaliar, Ler, Listar) — não com instrução vaga (Considerar, Pensar sobre, Explorar, Refletir).",
				"Para schemas autorais com múltiplas instâncias previstas, sources (referências externas que o agente consulta) é útil; para schemas locais raros, omita sources.",
				"heuristics na section são juízos de qualidade que não cabem em shape do schema; tipicamente regras de 'não X; X' ou 'preferir A a B' ou 'evite Y'.",
				"doneCriteria deve ser AVALIÁVEL — descreve condição verificável por humano ou agente. 'É bom' não é avaliável; 'Tem ≥3 evidências com source datado' é.",
				"Particionamento ideal: cada section corresponde a UMA atividade cognitiva coesa; transições entre sections devem coincidir com mudanças de modo cognitivo (research → modelagem → validação).",
			]
			doneCriteria: "sections é mapa não-vazio com cada entrada satisfazendo #SectionSpec; workOrder é lista de strings cujos valores correspondem 1:1 às chaves de sections (sem duplicatas, sem omissões); cada section tem target válido, objective ≥20 runes, process com ≥1 step acionável, doneCriteria ≥20 runes avaliável."
			ifGap:        "Se schema alvo é tão simples que 1 section parece artificial mas 0 sections é inválido, use 1 section nomeada apropriadamente (ex.: 'meta' para #DirectoryMeta). Se workOrder e sections desincronizam, reconsidere partição — costuma ser sinal de section duplicada ou ausente."
		}

		"validation-and-meta": {
			target:    "#ProductionGuide"
			objective: "Definir finalValidation (com founder approval explícito como ÚLTIMO step) e os campos meta (_schema.location + _qualityCriteria) que o guide próprio satisfaz."
			process: [{
				action: "Compor finalValidation.steps com último step obrigatório de submissão ao founder"
				detail: "Lista de steps verificáveis por humano ou agente. Inclua passos de shape validation (cue vet quando disponível), critérios advisory específicos (tq-XX do schema alvo). REGRA INVARIÁVEL: ÚLTIMO step de finalValidation.steps DEVE mencionar submissão, revisão ou aprovação do founder. Sem este step, ciclo propor→aprovar→escrever quebra (tq-pg-05 fail)."
			}, {
				action: "Avaliar inclusão de finalValidation.reconciliation (opcional)"
				detail: "Se schema alvo tem invariantes cross-field (ex.: BC ask amount alinha com investmentPlan rounds[0]), declare reconciliation com pairs de itens a verificar. Sem invariantes cross-field, omita."
			}, {
				action: "Compor _schema.location"
				detail: "canonicalPathRegex e fileNameRegex regex para o GUIDE em si (ex.: '^architecture/production-guides/foo\\\\.cue$'). description curta. rationale explicando localização. cardinality 'singleton' (1 guide por schema)."
			}, {
				action: "Compor _qualityCriteria com critérios e rationale do conjunto"
				detail: "Critérios tq-pg<XX>-Y onde <XX> é abreviação do schema alvo. Tipicamente 1-4 critérios cobrindo as falhas previstas mais críticas para o guide alvo. Rationale do conjunto explica que aspecto da autoria é coberto coletivamente — não é repetição dos rationales individuais."
			}, {
				action: "Verificação final cross-field do guide composto"
				detail: "Confira: target em todas as sections é válido? workOrder é permutação exata de keys(sections)? doneCriteria avaliável? gapPolicy ≥50 runes com cláusula anti-invenção? Último step de finalValidation menciona founder? Se algum NÃO, voltar para section correspondente."
			}]
			heuristics: [
				"finalValidation.steps[-1] sempre menciona submissão/revisão/aprovação do founder — sem isso, ciclo propor→aprovar→escrever está quebrado (tq-pg-05).",
				"_schema.cardinality é 'singleton' para production guide (sempre 1 guide por schema alvo, não múltiplos).",
				"_qualityCriteria mínimo: 1 critério com severity 'fail'. Schema trivial com guide minimalista pode ter só 1-2 critérios; schema complexo merece 3-5.",
				"Rationale do conjunto não é repetição dos rationales individuais — explica a COBERTURA agregada (que aspectos do guide os critérios protegem).",
				"Considere hardening de severities: critérios advisory (warn) do schema alvo podem virar fail no guide quando risco de fabricação por agente for crítico.",
				"Enforcement owner discipline (tq-mg-05): se o schema alvo declara elementos rule/constraint/check (ex.: agent-spec.constraints, structural-check rules, validation-prompt assertions), perguntar durante autoria: 'cada rule declara WHERE é enforced (agent / runner / domain / external)?'. Se não, adicionar heuristic OR critério dedicado que force a declaração. Sem enforcement owner declarado, rule vira ambígua — múltiplos enforcers ou nenhum, drift garantido em escala.",
				"Derived→source ref discipline (tq-mg-06): se o schema alvo carrega elementos derivados de outro artefato (ex.: agent-spec.constraints derivam de domain-model.invariants; structural-checks derivam de ADRs), perguntar: 'cada elemento derivado tem ref explícita à origem?'. Se não, adicionar heuristic OR critério forçando ref (e.g., derivedFromInvariant: 'inv-XYZ'). Default 1:1 origem→derivado. Sem ref, coverage e drift detection automatizáveis ficam impossíveis.",
				"Impact classification discipline (tq-mg-07): se o schema alvo declara elementos operacionais (actions, commands, events, services), perguntar: 'cada elemento operacional declara impact ortogonal a category (read-only / state-change / cross-bc / external-side-effect)?'. Taxonomia adapta ao tipo. Se não, governance (caps, escalation) opera sobre dimensão única (category) — perde sinalização de blast radius real.",
				"Default+override granularity discipline (tq-mg-08): se o schema alvo carrega config que admite default global + override per-element (escalation, SLA, autonomy, etc.), perguntar: 'guide articula QUANDO override aplica (exceção vs regra)?'. Default canônico: 'override é exceção' — over-declaração polui artefato. Sem articulação, override implícito (sempre presente) ou ausente (genuíno necessário não declarado) tornam-se silenciosos.",
				"Decide-vs-execute separation discipline (tq-mg-09): se o schema alvo declara units of work que podem combinar decisão + execução irreversível (actions, commands, workflows, sagas), perguntar: 'guide proíbe unidades monolíticas decide+execute em irreversíveis?'. Pattern recomendado: split em par decide-X (output: recommendation) + execute-X (input: approved). Sem split, propose-and-wait não tem onde inserir human gate — viola P10 por design.",
				"Canonical removal test (tq-mg-10) — UNIVERSAL: para CADA schema alvo, durante autoria do guide, perguntar: 'se removermos este artifact type do sistema, invariants críticos permanecem protegidos por outros enforcers (lifecycle, command handler, runner, gate determinístico, sistema externo)?'. Resposta esperada: SIM. Resposta NÃO indica bug arquitetural — artefato está segurando lógica que pertence a outra camada. Aplica a TODO schema (não só agent-spec). Adicionar como finalValidation step do guide alvo.",
			]
			doneCriteria: "finalValidation.steps tem ≥1 entrada com último step mencionando founder. _schema.location preenchido com 5 campos não-vazios. _qualityCriteria.criteria não-vazia, cada critério com id/description/test/severity/rationale, e rationale do conjunto presente e substantivo (não-redundante com rationales individuais)."
			ifGap:        "Se _qualityCriteria parece vazio porque schema é trivial, force ao menos 1 critério obrigatório: 'guide produz instância que satisfaz shape do schema alvo' (severity fail). Sempre há algo a validar."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #ProductionGuide (todos os campos obrigatórios presentes; tipos corretos).",
			"Verificar tq-pg-01 / tq-mg-01: workOrder é permutação exata das chaves de sections (sem redundância, sem omissão, sem duplicatas).",
			"Verificar tq-pg-02: cada section.target é referência a tipo existente em schema adotado (não inventado).",
			"Verificar tq-pg-04 / tq-mg-04: prerequisites.gapPolicy ≥50 runes E declara explicitamente comportamento anti-invenção (cláusula com 'NÃO invent' ou 'NÃO infer' ou equivalente).",
			"Verificar tq-pg-05 / tq-mg-03: finalValidation.steps[-1] menciona submissão/revisão/aprovação do founder.",
			"Verificar tq-pg-06 / tq-mg-02: cada section.process[].action começa com verbo imperativo concreto (lista canônica em heuristics da section sections-and-workorder deste guide).",
			"Verificar coerência semântica: process steps de cada section orientam autoria do tipo declarado em target — não duplicam guidance de outras sections nem omitem etapas necessárias.",
			"Verificar enforcement owner discipline (tq-mg-05 warn): se schema alvo declara elementos rule/constraint/check, guide produz heuristic OR critério dedicado exigindo declaração de WHERE rule é enforced (agent / runner / domain / external). Sem isso, ambiguidade entre múltiplos enforcers ou nenhum.",
			"Verificar derived→source ref discipline (tq-mg-06 warn): se schema alvo carrega elementos derivados de outro artefato, guide produz heuristic OR critério exigindo ref explícita do derivado a sua origem (e.g., derivedFromInvariant: 'inv-XYZ'). Default 1:1.",
			"Verificar impact classification discipline (tq-mg-07 warn): se schema alvo declara elementos operacionais (actions/commands/events/services), guide produz heuristic OR critério exigindo impact dimension ortogonal a category (read-only / state-change / cross-bc / external-side-effect; taxonomia adaptável).",
			"Verificar default+override granularity discipline (tq-mg-08 warn): se schema alvo carrega default global + override per-element (escalation, SLA, autonomy), guide produz heuristic OR critério articulando QUANDO override aplica (exceção vs regra; default 'override é exceção').",
			"Verificar decide-vs-execute separation discipline (tq-mg-09 warn): se schema alvo declara units of work com potencial decide+execute irreversível, guide produz heuristic OR critério proibindo unidades monolíticas; pattern recomendado split decide-X / execute-X com human gate entre.",
			"Verificar canonical removal test (tq-mg-10 warn) — UNIVERSAL: guide produz finalValidation step OR heuristic dedicada com pergunta 'se remover este artifact type, invariants críticos permanecem protegidos por outros enforcers?'. Resposta esperada SIM (artefato é operador, não único enforcer); resposta NÃO indica bug arquitetural.",
			"Submeter ao founder para aprovação antes de commit.",
		]
	}
}
