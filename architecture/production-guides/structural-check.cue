package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// structural-check.cue — Production guide para regras determinísticas
// de verificação estrutural por tipo de artefato.
//
// Schema alvo: #StructuralCheck (architecture/artifact-schemas/structural-check.cue).
// Per adr-040 (separação determinístico vs advisory) e adr-041
// (v1 minimal). adr-049 estabeleceu precedente de extensão de schema
// (kind conditional-file-presence) — guide formaliza o pattern.
//
// Phase pulled forward por cascade-ordering precondition: PG é gate
// per adr-054 dec 13 antes de autoria de qualquer instância de
// #StructuralCheck. Discovery 2026-05-01 (idc-primary-agent.cue
// commit b248178) motivou autoria de Layer 1 (cascade-ordering
// structural-check) — esta autoria de PG-StructuralCheck precede.
//
// Materializado em commit único section-by-section sob gates voluntários
// (manualAuthoringProtocol em adr-056 ainda não codificado; disciplina
// antecipada por convenção).

structuralCheckGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/structural-check\\.cue$"
			fileNameRegex:      "^structural-check\\.cue$"
			description:        "Production guide para autoria de regras determinísticas de verificação estrutural por tipo de artefato em mesh-spec."
			rationale:          "Schema #StructuralCheck é instanciável (cardinality collection); tq-as-05 exige guide. Phase pulled forward por cascade-ordering precondition (adr-054 dec 13) — autoria precede Layer 1 cascade-ordering check."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-scg-01"
			description: "Guide produz instância com 1:1 rule↔caso concreto (anti-fabricação)"
			test:        "Process inclui passo explícito de identificar caso concreto ANTES de compor rule (context-and-rule-identification) E passo de verificação 1:1 em finalValidation. gapPolicy proíbe rules especulativas. Cobre tq-sc-03 do schema (rationale rastreável) hardened para fail. Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "Rule sem caso concreto é ruído sobre o gate determinístico. Discovery 2026-05-01 (idc-primary-agent.cue commit b248178) motivou esta sequência; rule especulativa contradiz a justificativa estrutural de existir — agente fabricaria gate sobre gap fictício."
		}, {
			id:          "tq-scg-02"
			description: "Guide produz errorMessage com 3 partes acionáveis"
			test:        "Process da section rule-composition exige composição de errorMessage em 3 partes (o que / por quê / como corrigir). Heuristics reforça. finalValidation step verifica explicitamente. Hardening de tq-sc-01 do schema (já fail) — guide reitera disciplina porque errorMessage é o output do gate ao autor da instância validada."
			severity:    "fail"
			rationale:   "tq-sc-01 do schema já é fail; guide reitera porque errorMessage é o canal único do gate determinístico para o autor — sem acionabilidade, gate detecta mas não orienta correção, degradando para warn-equivalente. adr-041 estabelece acionabilidade como inegociável."
		}, {
			id:          "tq-scg-03"
			description: "Guide bloqueia kind aproximado quando gap não cabe nos 4 existentes"
			test:        "gapPolicy declara explicitamente que kind aproximado NÃO é instanciado — extension via ADR (precedente adr-049) é o caminho. Heuristics da rule-composition repete a regra. ifGap da rule-composition redireciona para extension. Verificado por inspeção do guide."
			severity:    "warn"
			rationale:   "Schema #StructuralCheck é v1 minimal (adr-041) com extensão deliberada quando caso concreto justifica (adr-049 estabeleceu o pattern). Contorcer kind existente para forçar fit é tq-sc-02 fail no schema; guide reforça via warn (caminho de extension é parte da discipline, não bloqueio absoluto — autor pode legitimamente postergar caso até ADR ser autorada)."
		}]
		rationale: "3 critérios cobrem disciplinas centrais para autoria de structural-check: derivação 1:1 rule↔caso concreto (tq-scg-01), acionabilidade de errorMessage como vetor primário do gate (tq-scg-02 hardening), preservação da disciplina de extension-via-ADR vs contorção de kind (tq-scg-03). tq-sc-01/02/03 do schema cobrem o lado de instância autorada; estes critérios cobrem o lado de PROCESSO de autoria — separação consistente com meta-guide (tq-mg-XX) vs schema (#ProductionGuide tq-pg-XX). Hardening tq-sc-01 → tq-scg-02 (ambos fail) reitera disciplina sem elevar severity (é reforço de guide-level)."
	}

	prerequisites: {
		description: "Antes de autorar structural-check para um artifactType, agente lê o schema do artifactType alvo + schema #StructuralCheck + instâncias existentes em architecture/structural-checks/ (se houver), identifica casos concretos de inconsistência observados em reviews prévias, e confirma escopo com founder. Cada rule deriva de um caso concreto — não de simetria entre artifactTypes."
		collectFromFounder: [
			"Confirmação do artifactType alvo das rules (ex.: 'canvas', 'glossary', 'production-guide') e que o schema correspondente está adotado em architecture/artifact-schemas/",
			"Casos concretos de inconsistência observados durante review de instâncias do tipo — cada caso é candidato a rule. Sem casos concretos: criar no máximo o PG, mas não autorar instâncias/rules especulativas",
			"Para cada caso: artefato envolvido, qual gap de validação CUE-level a rule fecha (CUE valida shape isolado; structural-check valida coerência cross-block ou cross-file que CUE não alcança)",
			"Naming abbreviation canônica do artifactType (ex.: 'cv' para canvas, 'gl' para glossary) usada em sc-{abbrev}-NN — id regex do schema é '^sc-[a-z0-9-]+-[0-9]{2}$' mas convenção interna favorece abreviação curta",
		]
		gapPolicy: "Se schema do artifactType alvo não existir em architecture/artifact-schemas/, postergue autoria do guide até schema existir. Se schema existe mas nenhum caso concreto de inconsistência foi observado em instâncias, NÃO crie structural-check instance/rule especulativa — PG pode existir como casca documentada; rules surgem quando casos surgem. NÃO infira rules por simetria com structural-checks de outros artifactTypes — cada rule fecha um gap específico do tipo alvo. Se um caso concreto não cabe nos 4 kinds existentes (required-block, reference-exists, same-artifact-consistency, conditional-file-presence), NÃO contorça rule shape para forçar fit — propor extensão do schema #StructuralCheck via ADR (precedente: adr-049 adicionou conditional-file-presence) ANTES de instanciar a rule. Se errorMessage ficar genérico ('regra falhou', 'check falhou'), reescrever ou OMITIR — tq-sc-01 fail. Se founder não souber articular caso concreto com artefato + gap específico, OMITIR rule — rule sem caso é ruído sobre o gate determinístico. Quando dúvida persistir, pergunta direta ao founder; nunca preencher por inferência heurística."
		validatorNote: "Em Phase 0, validação é (a) cue vet do arquivo de structural-check para shape e união discriminada, (b) founder review semântico do casamento rule↔caso (rule realmente fecha o gap declarado?). Execução real das rules como gate depende de runner (mecanismo de build-time que carrega structural-checks e executa contra artefatos). Runner é work-item separado — schema + instances podem existir antes do runner; rules ficam latentes até runner ativá-las. Per CLAUDE.md L83-89 e adr-040, structural-check é o ÚNICO mecanismo pós-commit que pode bloquear; existência das rules (mesmo latentes) é parte da governança declarativa que o runner futuro consumirá."
		outputNote: "Output é arquivo único architecture/structural-checks/<artifactType>.cue agregando todas rules para o tipo (cardinality 'collection' no schema). Tamanho típico: 30-100 linhas para 1-5 rules. Padrão dos arquivos existentes (architecture/structural-checks/canvas.cue): package structural_checks, import de artifact_schemas, declaração 'structuralChecks: \"<id>\": artifact_schemas.#StructuralCheck & {...}', uma entrada por rule. Múltiplos artifactTypes geram múltiplos arquivos (canvas.cue, glossary.cue, production-guide.cue, etc.); convenção operacional: não misturar artifactTypes no mesmo arquivo (basename ≈ artifactType ou abreviação derivada por convenção)."
	}

	workOrder: [
		"context-and-rule-identification",
		"rule-composition",
		"validation-and-meta",
	]

	sections: {
		"context-and-rule-identification": {
			target:    "#StructuralCheck"
			objective: "Estabelecer artifactType alvo, ler seu schema + schema #StructuralCheck + instâncias existentes (se houver), e identificar casos concretos de inconsistência observados em reviews que motivam cada rule. Cada candidate rule deriva de UM gap concreto."
			process: [{
				action: "Localizar architecture/artifact-schemas/{artifactType}.cue e ler schema completo, comments, _qualityCriteria"
				detail: "Schema target define o que CUE valida (shape, regex, enum, cardinality). Comments revelam intent. _qualityCriteria expõe o que self-review cobre. Tudo isso é o que structural-check NÃO precisa cobrir — gap fica no que sobra."
			}, {
				action: "Ler architecture/structural-checks/{artifactType}.cue se já existir + canvas.cue como referência estrutural"
				detail: "Rules prévias estabelecem padrão de naming, estilo de errorMessage e cobertura corrente. canvas.cue (sc-cv-01/02/03) é exemplar com 2 dos 4 kinds (same-artifact-consistency, conditional-file-presence)."
			}, {
				action: "Coletar com founder casos concretos de inconsistência observados em reviews"
				detail: "Cada caso = artefato real que passou cue vet mas violou coerência semântica em review (ex.: sc-cv-01 emerge do gap entre incentiveAnalysis.participants e stakeholders[]). Sem casos: NÃO autorar rules; PG fica documentado, instâncias surgem quando casos surgem."
			}, {
				action: "Identificar gap específico de cada caso"
				detail: "Para cada caso: (a) qual bloco/campo do artefato envolve, (b) por que CUE shape validation não cobre (intra-block ok, cross-block ou cross-file inconsistente), (c) qual seria a correção do autor. Casos sem gap claro = candidatos para validation-prompt advisory, não structural-check."
			}, {
				action: "Confirmar com founder abreviação canônica do artifactType"
				detail: "id regex schema é '^sc-[a-z0-9-]+-[0-9]{2}$' — segmento aceita qualquer alfanumérico-com-hífen. Convenção interna favorece abreviação curta (cv=canvas, gl=glossary) consistente com BC abbrev quando aplicável."
			}]
			sources: [
				"architecture/artifact-schemas/structural-check.cue (schema #StructuralCheck + 4 rule sub-types)",
				"architecture/structural-checks/canvas.cue (instâncias existentes: sc-cv-01 same-artifact-consistency, sc-cv-02/03 conditional-file-presence)",
				"architecture/adrs/adr-040-validation-split-structural-vs-design-review.cue (separação categórica determinístico vs advisory)",
				"architecture/adrs/adr-041-structural-check-v1-schema-shape.cue (v1 minimal — 4 kinds)",
				"architecture/adrs/adr-049-extend-structural-check-conditional-file-presence.cue (precedente de extensão de kind)",
			]
			heuristics: [
				"Caso concreto = artefato real que passou cue vet mas viola coerência semântica observada em review; rule sem caso é ruído sobre o gate determinístico.",
				"CUE shape validation cobre tipos, regex, enums, cardinality, presence requerida — structural-check NÃO duplica essas verificações.",
				"structural-check cobre coerência cross-block intra-artefato (kinds required-block, reference-exists, same-artifact-consistency) ou cross-file (kind conditional-file-presence).",
				"Cada rule fecha UM gap; rule que fecha múltiplos gaps sugere split em 2 rules.",
				"Os 4 kinds atuais cobrem o pattern v1; novo pattern → propor extension via ADR (precedente adr-049), NÃO contorcer kind existente.",
				"Casos para validation-prompt advisory (interpretativos, não-determinísticos) NÃO entram aqui — adr-040 separação é categórica.",
			]
			doneCriteria: "artifactType alvo confirmado; schema target lido; instâncias existentes (se houver) lidas; abreviação canônica determinada; SE houver autoria de rules nesta sessão: casos concretos confirmados com founder (cada um com artefato + gap específico declarados). Sem casos: autoria de rules é diferida; PG pode existir sem instâncias especulativas (per gapPolicy)."
			ifGap:        "Se artifactType alvo sem instâncias autoradas, postergar autoria das rules — sem instâncias não há observação de inconsistência. Se nenhum caso concreto emergiu, postergar autoria das rules — convenção operacional desta autoria: PG existe; rules surgem quando casos surgem."
		}

		"rule-composition": {
			target:    "#StructuralCheck"
			objective: "Para cada caso identificado em context-and-rule-identification, compor instância de #StructuralCheck — 8 campos obrigatórios + rule shape conforme kind — verificando que kind escolhido casa semanticamente com o gap concreto."
			process: [{
				action: "Identificar kind apropriado per gap"
				detail: "required-block: bloco nomeado deve existir top-level. reference-exists: refs em sourcePath devem aparecer em refNamespace do MESMO artefato. same-artifact-consistency: relação explícita entre dois blocos do MESMO artefato (v1: every-reference-must-exist-as-entry). conditional-file-presence: arquivo-alvo presente/ausente condicionado a campo booleano em arquivo-fonte. Se gap não cabe nos 4: NÃO instanciar; propor extension via ADR."
			}, {
				action: "Compor id, title, artifactType, description"
				detail: "id = sc-{abbrev}-NN (NN sequencial; regex '^sc-[a-z0-9-]+-[0-9]{2}$'). title ≤80 runes, substantivo do bloco/relação validado. artifactType = enum match. description = regra positiva ('Toda X tem Y') explicando invariante; explicação da falha vai em errorMessage."
			}, {
				action: "Compor rule shape conforme sub-schema do kind"
				detail: "Discriminated union em #StructuralCheck enforça shape — campos estrangeiros falham validação CUE. required-block: blockName. reference-exists: sourcePath, refNamespace. same-artifact-consistency: referencingBlock, definingBlock, relation. conditional-file-presence: sourcePattern, conditionField, targetPattern, biconditional."
			}, {
				action: "Compor errorMessage com 3 partes acionáveis"
				detail: "(1) O que está inconsistente em termos concretos do artefato (incluindo nome do bloco/path/refId). (2) Por que importa (referência ao gap fechado). (3) Ação concreta de correção (e.g., 'Adicione X em Y ou remova Z'). errorMessage genérica ('check falhou') = tq-sc-01 fail."
			}, {
				action: "Compor rationale referenciando caso ou princípio"
				detail: "rationale referencia (a) caso observado (e.g., 'cobre vc-cv-03 sobre presença de communication') OU (b) princípio específico do schema do artifactType validado. Tautologia ('verifica X porque X é obrigatório') = tq-sc-03 warn — reescrever."
			}, {
				action: "Verificar coerência semântica rule↔gap"
				detail: "Releitura: a rule, executada por runner, captura o gap declarado em Section 1? rule mais ampla = falsos positivos esperados; rule mais estreita = gap não fecha. Ajustar até 1:1."
			}]
			sources: [
				"architecture/artifact-schemas/structural-check.cue (4 rule sub-types: #RequiredBlockRule, #ReferenceExistsRule, #SameArtifactConsistencyRule, #ConditionalFilePresenceRule)",
				"architecture/structural-checks/canvas.cue (3 exemplos: sc-cv-01 referente, sc-cv-02/03 condicional bicondicional)",
				"architecture/artifact-schemas/structural-check.cue _qualityCriteria (tq-sc-01 acionabilidade, tq-sc-02 união discriminada, tq-sc-03 rastreabilidade)",
			]
			heuristics: [
				"id usa abreviação consistente do artifactType (cv=canvas, gl=glossary); NN começa em 01.",
				"title é substantivo do bloco/relação validado, não verbo de ação ('Stakeholders em X devem aparecer em Y' — não 'Verificar que stakeholders aparecem em Y').",
				"description começa com regra positiva afirmando o invariante; falha e correção vão em errorMessage.",
				"rule shape conforma estritamente ao sub-schema do kind — campos estrangeiros falham união discriminada (enforced por CUE).",
				"errorMessage tem 3 partes (o que / por quê / como corrigir); falta de qualquer parte degrada acionabilidade.",
				"rationale referencia caso observado OU princípio do schema; tautologia ('verifica X porque X é obrigatório') é tq-sc-03 warn — reescrever.",
				"Se candidate rule não cabe nos 4 kinds, parar e propor extension via ADR (precedente adr-049); contorcer sub-schema é tq-sc-02 fail.",
			]
			doneCriteria: "Cada rule tem 8 campos obrigatórios preenchidos (id, title, artifactType, description, kind, rule, errorMessage, rationale); rule shape conforma ao sub-schema do kind sem campos estrangeiros; errorMessage tem 3 partes acionáveis; rationale referencia caso concreto ou princípio (não-tautológico); coerência rule↔gap verificada por releitura."
			ifGap:        "Se kind atual não cobre o gap concreto, NÃO instanciar com kind aproximado — propor extension de schema #StructuralCheck via ADR (precedente adr-049) ANTES de continuar. Se errorMessage continua genérico após reescritas, reconsiderar se rule está realmente fechando gap concreto OU se é validation-prompt advisory disfarçada de structural-check."
		}

		"validation-and-meta": {
			target:    "#ProductionGuide"
			objective: "Compor finalValidation (com submissão ao founder como ÚLTIMO step), _schema.location do guide próprio + _qualityCriteria com critérios cobrindo as falhas mais críticas de autoria de structural-check."
			process: [{
				action: "Compor finalValidation.steps com submissão ao founder no último step"
				detail: "Steps cobrem: cue vet do arquivo de checks, verificação de tq-sc-01 (errorMessage acionável), tq-sc-02 (rule shape conforma kind), tq-sc-03 (rationale rastreável), 1:1 rule↔caso. ÚLTIMO step = submeter ao founder. tq-pg-05 / tq-mg-03 fail se ausente."
			}, {
				action: "Compor _schema.location do guide"
				detail: "canonicalPathRegex regex para o GUIDE ('^architecture/production-guides/structural-check\\.cue$'); fileNameRegex ('^structural-check\\.cue$'); description curta; rationale; cardinality 'singleton'; allowNested false. NÃO confundir com canonicalPathRegex das INSTÂNCIAS de #StructuralCheck (que vivem em architecture/structural-checks/)."
			}, {
				action: "Compor _qualityCriteria com critérios tq-scgXX"
				detail: "Critérios sobre o GUIDE produzir instâncias que: (a) deriven de caso concreto (anti-fabricação), (b) escolham kind correto, (c) tenham errorMessage acionável (hardening de tq-sc-01 fail). Rationale do conjunto explica cobertura agregada — não repete rationales individuais."
			}, {
				action: "Verificar disciplinas tq-mg-05..10 do meta-PG aplicáveis"
				detail: "tq-mg-05 (enforcement owner): structural-check carrega rules — runner é único enforcer; declarar em rationale. tq-mg-06 (derived→source): rule pode derivar de quality-criteria do schema target; explicitar quando aplica. tq-mg-07 (impact): structural-check tem impact uniforme (gating block-emit). tq-mg-09 (decide-vs-execute): N/A (gate, não decide). tq-mg-10 (canonical removal): structural-check É o único enforcer dos gaps cross-block/cross-file por design — adr-040 separation."
			}, {
				action: "Verificar cross-field do guide composto"
				detail: "Confira: target em todas sections válido? workOrder permutação exata de keys(sections)? doneCriteria avaliáveis? gapPolicy ≥50 runes com cláusula anti-invenção? Último step de finalValidation menciona founder?"
			}]
			heuristics: [
				"finalValidation.steps[-1] sempre menciona submissão/revisão/aprovação do founder — sem isso, ciclo propor→aprovar→escrever está quebrado (tq-pg-05).",
				"_schema.cardinality 'singleton' (1 guide por schema alvo).",
				"_qualityCriteria mínimo 1 critério fail; hardening de severities (warn→fail) quando risco de fabricação por agente é crítico — para structural-check, errorMessage genérica é o vetor primário de degradação.",
				"Rationale do conjunto explica COBERTURA agregada, não repete rationales individuais.",
			]
			doneCriteria: "finalValidation.steps tem ≥1 entrada com último step mencionando founder; _schema.location preenchido com 5 campos não-vazios; _qualityCriteria.criteria não-vazia com cada critério id/description/test/severity/rationale; rationale do conjunto presente e substantivo."
			ifGap:        "Se _qualityCriteria parece trivial, force ao menos 1 critério fail sobre acionabilidade de errorMessage (hardening de tq-sc-01) — vetor de degradação primário identificado em adr-041."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #ProductionGuide (todos os campos obrigatórios presentes; tipos corretos).",
			"Verificar tq-pg-01 / tq-mg-01: workOrder é permutação exata das chaves de sections (sem redundância, sem omissão, sem duplicatas).",
			"Verificar tq-pg-02: cada section.target referencia tipo existente em schema adotado (#StructuralCheck ou #ProductionGuide).",
			"Verificar tq-pg-04 / tq-mg-04: prerequisites.gapPolicy ≥50 runes E declara explicitamente comportamento anti-invenção (cláusula 'NÃO crie structural-check instance/rule especulativa', 'NÃO infira por simetria', 'NÃO contorça rule shape').",
			"Verificar tq-pg-05 / tq-mg-03: finalValidation.steps[-1] menciona submissão/revisão/aprovação do founder.",
			"Verificar tq-pg-06 / tq-mg-02: cada section.process[].action começa com verbo imperativo concreto da lista canônica.",
			"Verificar tq-sc-01 / tq-scg-02 (hardened fail): para cada rule autorada via este guide, errorMessage tem 3 partes acionáveis (o que está inconsistente em termos do artefato / por que importa / ação concreta de correção). Genérica ('check falhou') é fail.",
			"Verificar tq-sc-02: para cada rule, rule shape conforma sub-schema do kind escolhido (required-block: blockName; reference-exists: sourcePath+refNamespace; same-artifact-consistency: referencingBlock+definingBlock+relation; conditional-file-presence: sourcePattern+conditionField+targetPattern+biconditional). Campos estrangeiros falham união discriminada (CUE catch).",
			"Verificar tq-sc-03 / tq-scg-01: para cada rule, rationale referencia caso concreto observado OU princípio específico do schema do artifactType validado. Tautologia ('verifica X porque X é obrigatório') rejeita.",
			"Verificar 1:1 rule↔caso (tq-scg-01 hardened fail): cada rule autorada via este guide corresponde a UM caso concreto declarado em context-and-rule-identification. Rule sem caso = ruído.",
			"Verificar enforcement owner (tq-mg-05 warn): rationale do conjunto OU rationale individual da rule reconhece runner como único enforcer determinístico — instâncias permanecem latentes pré-runner conforme validatorNote do guide.",
			"Verificar canonical removal (tq-mg-10 warn): se rules forem removidas, gaps cross-block/cross-file ficam sem enforcement determinístico; isso confirma que structural-check é o enforcer canônico desses gaps, não um artefato decorativo.",
			"Submeter ao founder para aprovação antes de commit.",
		]
	}
}
