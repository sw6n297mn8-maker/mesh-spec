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
		}, {
			id:          "tq-scg-04"
			description: "Guide enforça layer applicability declaration per domain-invariant rule (Domain-Invariant Structural Check Authoring Protocol per adr-086)"
			test:        "Process da section rule-composition (sub-block kind=domain-invariant) exige: para cada rule com kind=domain-invariant, declarar applicable layers do progressive ladder de 7 layers (L1 PRESENCE / L2 CROSS-FIELD / L2.5 ADOPTION PROOF / L3 RESOLVABLE CONTRACT / L4 VERSIONED / L5 FRESHNESS / L6 DECISION-INTERPRETATION COHERENCE / L7 DECISION CONTEXT). RE-VALIDATION REQUIREMENT (RE-VAL) é flag SEPARADA dos 7 layers, declarada adicionalmente quando invariant tem evolução temporal/contextual. Para cada layer non-applicable, rationale explícito requerido. Silent omission proibida. Cobre adr-086 D2 progressive applicability ladder per-rule obligation."
			severity:    "fail"
			rationale:   "Layer declaration é base do Domain-Invariant Structural Check Authoring Protocol. Sem declaration + non-applicability rationale, rule volta a ser prose plausível — fail per adr-086 D2 base discipline."
		}, {
			id:          "tq-scg-05"
			description: "Guide enforça coverage flags declaration per domain-invariant rule"
			test:        "Process da section rule-composition exige: cada rule com kind=domain-invariant declara coverage struct {buildTime, validationTime, runtimeRequired} per schema #DomainInvariantRule.coverage (per adr-080). At least one flag MUST be true. Cobre adr-086 D3 coverage flags discipline."
			severity:    "fail"
			rationale:   "Coverage flags declaram explicit o que rule cobre por dimensão (build-time / validation-time / runtime). Sem flags ou todos false, rule fica sem dimensão de enforcement declarada — gap silencioso fail per adr-086 D3."
		}, {
			id:          "tq-scg-06"
			description: "Guide enforça runtimeGap mandatory quando coverage.runtimeRequired=true"
			test:        "Process da section rule-composition exige: quando coverage.runtimeRequired=true, runtimeGap struct MANDATORY com description (o que não é build-time-enforceable) + enforcedBy (onde runtime enforcement vive — aggregate lifecycle / runtime governance layer / external system). Cobre adr-086 D4 runtimeGap declaration protocol."
			severity:    "fail"
			rationale:   "runtimeGap separa coverage flag (o que rule cobre) de honesty declaration (o que rule admite não cobrir build-time). Sem runtimeGap, runtimeRequired=true vira reconhecimento abstrato sem articulação — fail per adr-086 D4 + paralelo cst-system-boundary-acknowledged pattern."
		}, {
			id:          "tq-scg-07"
			description: "Guide enforça war-game derivation evidence per domain-invariant rule"
			test:        "Process da section rule-composition exige: rationale de cada rule kind=domain-invariant referencia (a) concrete production-break case observado, OR (b) credible pre-production failure mode com cenário articulado explícito. REGRA FINAL V2 ('esse erro continuaria válido ao longo do tempo?') + TESTE EPISTEMOLÓGICO V2 ('novo BC consegue interpretar + provar uso correto + detectar drift sem contexto adicional?') considerados (TESTE verifica WHETHER L3, L2.5, L5 apply; non-applicable com rationale OK per progressive ladder). Cobre adr-086 D5 founder dialectic war-game pattern."
			severity:    "warn"
			rationale:   "War-game derivation é discipline anti-template-copy per adr-086 D5. warn porque rationale pode ser forte mas formatado imperfeitamente; endurecer post-empirical observation (n=3+ BCs aplicando o protocolo)."
		}, {
			id:          "tq-scg-08"
			description: "Guide enforça behavioral non-applicability declaration"
			test:        "Process da section rule-composition exige: invariants behavioral puras (architectural review; anti-corruption discipline) que NÃO são structurally enforceable declaradas explicit como non-applicable estruturalmente em domain-invariant rule comment OR rationale. Cobre adr-086 D6 behavioral non-applicability declaration."
			severity:    "warn"
			rationale:   "Behavioral non-applicability discipline previne aspirational rules per adr-086 D6. warn porque classification exige maturidade pós INV/REW retro-audit; endurecer quando n=3+ BCs aplicaram o protocolo."
		}]
		rationale: "8 critérios cobrem disciplinas para autoria de structural-check: (1) 3 critérios base aplicáveis a TODOS kinds — derivação 1:1 rule↔caso concreto (tq-scg-01), acionabilidade de errorMessage como vetor primário do gate (tq-scg-02 hardening), preservação da disciplina de extension-via-ADR vs contorção de kind (tq-scg-03). (2) 5 critérios específicos para kind=domain-invariant (adr-080 + Domain-Invariant Structural Check Authoring Protocol per adr-086): layer applicability declaration (tq-scg-04 fail), coverage flags declaration (tq-scg-05 fail), runtimeGap mandatory quando runtimeRequired (tq-scg-06 fail), war-game derivation evidence (tq-scg-07 warn), behavioral non-applicability declaration (tq-scg-08 warn). tq-sc-01/02/03 do schema cobrem lado de INSTÂNCIA; estes critérios cobrem lado de PROCESSO de autoria. Severidades fail para tq-scg-04..06 refletem base discipline do protocolo per adr-086; warn para tq-scg-07/08 reflete maturidade incremental (war-game evidence pode ter formatting variation; behavioral classification exige n=3+ BCs aplicando para hardening)."
	}

	prerequisites: {
		description: "Antes de autorar structural-check para um artifactType, agente lê o schema do artifactType alvo + schema #StructuralCheck + instâncias existentes em architecture/structural-checks/ (se houver), identifica casos concretos de inconsistência observados em reviews prévias, e confirma escopo com founder. Cada rule deriva de um caso concreto — não de simetria entre artifactTypes."
		collectFromFounder: [
			"Confirmação do artifactType alvo das rules (ex.: 'canvas', 'glossary', 'production-guide') e que o schema correspondente está adotado em architecture/artifact-schemas/",
			"Casos concretos de inconsistência observados durante review de instâncias do tipo — cada caso é candidato a rule. Sem casos concretos: criar no máximo o PG, mas não autorar instâncias/rules especulativas",
			"Para cada caso: artefato envolvido, qual gap de validação CUE-level a rule fecha (CUE valida shape isolado; structural-check valida coerência cross-block ou cross-file que CUE não alcança)",
			"Naming abbreviation canônica do artifactType (ex.: 'cv' para canvas, 'gl' para glossary) usada em sc-{abbrev}-NN — id regex do schema é '^sc-[a-z0-9-]+-[0-9]{2}$' mas convenção interna favorece abreviação curta",
		]
		gapPolicy: "Se schema do artifactType alvo não existir em architecture/artifact-schemas/, postergue autoria do guide até schema existir. Se schema existe mas nenhum caso concreto de inconsistência foi observado em instâncias, NÃO crie structural-check instance/rule especulativa — PG pode existir como casca documentada; rules surgem quando casos surgem. NÃO infira rules por simetria com structural-checks de outros artifactTypes — cada rule fecha um gap específico do tipo alvo. Se um caso concreto não cabe nos 5 kinds operacionais (4 originais — required-block, reference-exists, same-artifact-consistency, conditional-file-presence; + domain-invariant per adr-080 + Domain-Invariant Structural Check Authoring Protocol per adr-086), NÃO contorça rule shape para forçar fit — propor extensão do schema #StructuralCheck via ADR (precedente: adr-049 adicionou conditional-file-presence; adr-080 adicionou domain-invariant) ANTES de instanciar a rule. Para kind=domain-invariant: rules DEVEM emergir de concrete production-break case OR credible pre-production failure mode com cenário articulado (war-game derivation per adr-086 D5); template-copy de INV/REW structural-checks é anti-pattern explícito proibido. Se errorMessage ficar genérico ('regra falhou', 'check falhou'), reescrever ou OMITIR — tq-sc-01 fail. Se founder não souber articular caso concreto com artefato + gap específico, OMITIR rule — rule sem caso é ruído sobre o gate determinístico. Quando dúvida persistir, pergunta direta ao founder; nunca preencher por inferência heurística."
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
				"Os 5 kinds operacionais (4 originais — required-block, reference-exists, same-artifact-consistency, conditional-file-presence; + domain-invariant per adr-080 + Domain-Invariant Structural Check Authoring Protocol per adr-086) cobrem patterns atuais; novo pattern → propor extension via ADR (precedente adr-049/adr-080), NÃO contorcer kind existente.",
				"Casos para validation-prompt advisory (interpretativos, não-determinísticos) NÃO entram aqui — adr-040 separação é categórica.",
				"Para kind=domain-invariant authoring (per Domain-Invariant Structural Check Authoring Protocol, adr-086): ler domain-model do BC alvo + identificar invariants candidate para structural enforcement. NÃO bulk-copy de INV/REW; cada invariant deriva via war-game derivation (D5).",
				"War-game admissibility per adr-086 D5: cada candidate rule deve emergir de (a) concrete production-break case observado, OR (b) credible pre-production failure mode com cenário articulado explícito (NÃO especulação genérica). Apply REGRA FINAL V2 + TESTE EPISTEMOLÓGICO V2 como check questions.",
				"Anti-pattern explícito proibido para kind=domain-invariant: template-copy de structural-checks de outros BCs. Cada BC tem invariants distintas; layer applicability + coverage flags são per-invariant per-BC.",
				"Behavioral non-applicability identification: durante context-and-rule-identification, identificar invariants do domain-model que são behavioral puras (architectural review; anti-corruption discipline) — essas DEVEM ser declared non-applicable estruturalmente per adr-086 D6 (não força rule estrutural sobre invariant behavioral).",
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
				action: "Para kind=domain-invariant: aplicar Domain-Invariant Structural Check Authoring Protocol (adr-086)"
				detail: """
					Per ADR-086 Domain-Invariant Structural Check Authoring Protocol — 5 disciplinas obrigatórias além de 8 campos base:

					(1) Progressive applicability ladder (D2): declarar applicable layers do 7-LAYERS ladder (L1 PRESENCE / L2 CROSS-FIELD / L2.5 ADOPTION PROOF / L3 RESOLVABLE CONTRACT / L4 VERSIONED / L5 FRESHNESS / L6 DECISION-INTERPRETATION COHERENCE / L7 DECISION CONTEXT). RE-VALIDATION REQUIREMENT (RE-VAL) é flag SEPARADA dos 7 layers, declarada adicionalmente quando invariant tem evolução temporal/contextual. Layers são INDEPENDENTLY APPLICABLE — invariants invocam subset conforme natureza. NÃO obrigação rígida que toda rule invoque todos 7. OBRIGAÇÃO per-rule: declarar applicable layers explicit; para cada non-applicable layer, rationale explícito (NÃO silent omission).

					(2) Coverage flags discipline (D3): declarar coverage struct {buildTime, validationTime, runtimeRequired} per schema #DomainInvariantRule.coverage. buildTime=true (enforceable em commit por build-time validation tooling); validationTime=true (enforceable em instance validation step advisory); runtimeRequired=true (requer runtime context). At least one flag MUST be true.

					(3) runtimeGap declaration (D4): quando coverage.runtimeRequired=true, runtimeGap MANDATORY com description (o que NÃO é build-time-enforceable) + enforcedBy (onde runtime enforcement vive — aggregate lifecycle / runtime governance layer / external system).

					(4) War-game derivation (D5): rationale referencia (a) concrete production-break case observado, OR (b) credible pre-production failure mode com cenário articulado (NÃO especulação). REGRA FINAL V2 + TESTE EPISTEMOLÓGICO V2 considerados (TESTE verifica WHETHER L3, L2.5, L5 apply — non-applicable com rationale OK per progressive ladder).

					(5) Behavioral non-applicability declaration (D6): invariants behavioral puras (architectural review; anti-corruption discipline) declaradas explicit como non-applicable estruturalmente — NÃO force structural rule sobre behavioral invariant.

					Empirical references canônicas:
					- architecture/structural-checks/inv-domain-model.cue (primeira instância domain-invariant; pre-DISCAP; referência histórica, não exemplar completo — pode ter gaps de declaration por authoring pre-meta-template)
					- architecture/structural-checks/rew-domain-model.cue (Phase 3.5a; genesis do Domain-Invariant Structural Check Authoring Protocol via meta-template level-2 founder dialectic; referência canônica forte; matriz de layers per sc-rule — sc-rew-08 full ladder com RE-VAL; sc-rew-15 L2+L5 com RE-VAL apenas)
					"""
			}, {
				action: "Verificar coerência semântica rule↔gap"
				detail: "Releitura: a rule, executada por build-time validation tooling, captura o gap declarado em Section 1? rule mais ampla = falsos positivos esperados; rule mais estreita = gap não fecha. Ajustar até 1:1."
			}]
			sources: [
				"architecture/artifact-schemas/structural-check.cue (5 rule sub-types: #RequiredBlockRule, #ReferenceExistsRule, #SameArtifactConsistencyRule, #ConditionalFilePresenceRule, #DomainInvariantRule per adr-080)",
				"architecture/structural-checks/canvas.cue (3 exemplos: sc-cv-01 referente, sc-cv-02/03 condicional bicondicional)",
				"architecture/structural-checks/inv-domain-model.cue (primeira instância domain-invariant; pre-DISCAP; referência histórica, não exemplar completo)",
				"architecture/structural-checks/rew-domain-model.cue (Phase 3.5a; genesis do Domain-Invariant Structural Check Authoring Protocol; referência canônica forte; sc-rew-08 full ladder; sc-rew-15 L2+L5+RE-VAL apenas)",
				"architecture/artifact-schemas/structural-check.cue _qualityCriteria (tq-sc-01 acionabilidade, tq-sc-02 união discriminada, tq-sc-03 rastreabilidade)",
				"architecture/adrs/adr-080-extend-structural-check-domain-invariants.cue (kind domain-invariant extension)",
				"architecture/adrs/adr-086-domain-invariant-authoring-protocol.cue (Domain-Invariant Structural Check Authoring Protocol)",
			]
			heuristics: [
				"id usa abreviação consistente do artifactType (cv=canvas, gl=glossary); NN começa em 01.",
				"title é substantivo do bloco/relação validado, não verbo de ação ('Stakeholders em X devem aparecer em Y' — não 'Verificar que stakeholders aparecem em Y').",
				"description começa com regra positiva afirmando o invariante; falha e correção vão em errorMessage.",
				"rule shape conforma estritamente ao sub-schema do kind — campos estrangeiros falham união discriminada (enforced por CUE).",
				"errorMessage tem 3 partes (o que / por quê / como corrigir); falta de qualquer parte degrada acionabilidade.",
				"rationale referencia caso observado OU princípio do schema; tautologia ('verifica X porque X é obrigatório') é tq-sc-03 warn — reescrever.",
				"Se candidate rule não cabe nos 5 kinds operacionais (4 originais + domain-invariant per adr-080), parar e propor extension via ADR (precedente adr-049/adr-080); contorcer sub-schema é tq-sc-02 fail.",
				"kind=domain-invariant: Progressive applicability ladder per adr-086 D2 — 7 layers L1..L7 applicable SELECTIVELY; RE-VAL flag declarada separately quando applicable. Obrigação per-rule é declaração + non-applicability rationale, NÃO invocação rígida.",
				"kind=domain-invariant: Coverage flags per adr-086 D3 — {buildTime, validationTime, runtimeRequired} com at least one true. Sem flags ou todos false = fail (tq-scg-05).",
				"kind=domain-invariant: runtimeGap MANDATORY quando runtimeRequired=true per adr-086 D4 — description + enforcedBy preenchidos (aggregate lifecycle / runtime governance layer / external system). Sem isso = fail (tq-scg-06).",
				"kind=domain-invariant: War-game derivation per adr-086 D5 — rationale referencia production-break OR credible pre-production failure mode com cenário; template-copy é anti-pattern proibido.",
				"kind=domain-invariant: Behavioral non-applicability per adr-086 D6 — invariants behavioral declaradas explicit non-applicable estruturalmente (NÃO força rule sobre behavioral).",
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
			"Verificar tq-scg-04 (layer-applicability-declared, fail): para kind=domain-invariant rules, applicable layers do progressive ladder (L1..L7) declarados explicit + para cada non-applicable layer, rationale explícito; RE-VAL flag declarada separately quando applicable. Silent omission é fail per adr-086 D2.",
			"Verificar tq-scg-05 (coverage-flags-declared, fail): para kind=domain-invariant rules, coverage struct {buildTime, validationTime, runtimeRequired} declarado com at least one flag true.",
			"Verificar tq-scg-06 (runtimegap-mandatory, fail): para kind=domain-invariant rules, quando coverage.runtimeRequired=true, runtimeGap struct com description + enforcedBy (aggregate lifecycle / runtime governance layer / external system) preenchido.",
			"Verificar tq-scg-07 (war-game-derivation-evidenced, warn): para kind=domain-invariant rules, rationale referencia concrete production-break case OR credible pre-production failure mode com cenário articulado explícito.",
			"Verificar tq-scg-08 (behavioral-non-applicability-explicit, warn): invariants behavioral puras do domain-model do BC alvo declaradas explicit como non-applicable estruturalmente em rule comment OR rationale; NÃO forçadas em structural rule (aspirational).",
			"Verificar enforcement owner (tq-mg-05 warn): rationale do conjunto OU rationale individual da rule reconhece build-time validation tooling (e runner futuro, quando ativado per WI-068) como único enforcer determinístico — instâncias permanecem latentes pré-tooling conforme validatorNote do guide.",
			"Verificar canonical removal (tq-mg-10 warn): se rules forem removidas, gaps cross-block/cross-file ficam sem enforcement determinístico; isso confirma que structural-check é o enforcer canônico desses gaps, não um artefato decorativo.",
			"Submeter ao founder para aprovação antes de commit.",
		]
	}
}
