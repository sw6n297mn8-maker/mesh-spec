package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// lens.cue — Production guide para lentes analíticas (#AnalyticalLens).
//
// Schema alvo: #AnalyticalLens (architecture/artifact-schemas/lens.cue).
// Escopo: cada lens vive em arquivo individual em architecture/lenses/.
// Materializado por cascade-ordering requirement de adr-053/adr-054
// (instância de #AnalyticalLens exige PG lens pré-existente). PG lens
// criado em sessão WI-060 SSC bootstrap por necessidade de bootstrap
// de lens-incentive-alignment para Q10 do canvas SSC.
//
// Convenção: tq-lng-XX para critérios deste guide (abreviação 'lng'
// = "lens guide", distinto de 'ln' do schema).
//
// Disciplinas tq-mg-XX aplicadas:
// - tq-mg-02 (verbos imperativos concretos): todas process actions
//   iniciam com Identificar/Compor/Declarar/Listar/Verificar/Executar
// - tq-mg-04 (gapPolicy anti-invenção HARD): anti-fabulação acadêmica
//   como invariant central — concept SEM mesh-manifestation real é
//   fabulação por importação nominal
// - tq-mg-08 (default+override): status (draft default, active/deprecated
//   via promotion explícita) + verticalApplicability (default Fase 1
//   advisory)
// - tq-mg-10 (canonical removal test UNIVERSAL): "se remover esta lens,
//   alguma invariant Mesh deixa de existir?" — resposta esperada NÃO
//   (lens é descritiva, não enforcer)
//
// Não aplicáveis:
// - tq-mg-05 (enforcement owner): lens não tem rule/constraint/check
// - tq-mg-07 (impact classification): lens não tem elementos operacionais
// - tq-mg-09 (decide-vs-execute split): lens não tem units of work
//
// 6 critérios tq-lng-XX: 5 derivados de tq-ln-XX do schema (hardening
// de severity onde fabricação por agente é risco crítico) + tq-lng-06
// (founder addition) protegendo contra policy creep — lens como
// governance escondida é vetor recorrente em sistemas com lenses ricos.

lensGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/lens\\.cue$"
			fileNameRegex:      "^lens\\.cue$"
			description:        "Production guide para autoria de lentes analíticas (#AnalyticalLens) em mesh-spec."
			rationale:          "Lens é artefato de raciocínio aplicado por agentes para examinar problemas Mesh sob ângulo específico. Schema #AnalyticalLens tem 10 critérios mínimos estruturais; guide explicita process, gapPolicy anti-fabulação acadêmica e disciplinas que o schema sozinho não documenta. Materializado por cascade-ordering requirement de adr-053/adr-054 — primeira instância (lens-incentive-alignment) bootstrapped por Q10 do canvas SSC."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-lng-01"
			description: "Guide produz lens com trigger conditions deterministicamente avaliáveis"
			test:        "Process da section identity-and-trigger declara passo explícito proibindo quantificadores vagos ('às vezes', 'frequentemente', 'depende de contexto'); ifGap cobre cenário de condition probabilística. Hardens tq-ln-01 do schema (warn→fail)."
			severity:    "fail"
			rationale:   "Lens com ativação probabilística vira advisory que ativa em todo problema — gera overhead de context window sem valor analítico. Determinismo é pré-requisito de aplicabilidade."
		}, {
			id:          "tq-lng-02"
			description: "Guide produz lens cujos concepts agregam capacidade analítica própria (não duplicam principles ou outras lenses)"
			test:        "Heuristics da section concepts-reasoning-examples declara que reasoningProtocol que apenas repete 'aplique P10' é peso morto; ifGap rejeita concepts que duplicam dp-XX/P-XX/ax-XX sem agregar análise distintiva. Hardens tq-ln-02."
			severity:    "fail"
			rationale:   "Lens que duplica princípios é peso morto no context window. Quanto mais lenses sem capacidade própria, maior o overhead sem ganho cognitivo — degradação proporcional a tamanho do catálogo."
		}, {
			id:          "tq-lng-03"
			description: "Guide produz lens com mesh examples concretos (cenário reconhecível + análise específica + recomendação acionável)"
			test:        "Process da section concepts-reasoning-examples exige meshExample com scenario Mesh reconhecível, analysis aplicando a lens, recommendation concreta. Heuristics rejeita examples narrativos sem recomendação acionável. Hardens tq-ln-03."
			severity:    "fail"
			rationale:   "Lens só é útil se mostra como muda decisões reais Mesh — exemplo abstrato é narrativa decorativa, não anchored aplicação."
		}, {
			id:          "tq-lng-04"
			description: "Guide produz lens com limitations explícitas + alternativa concreta"
			test:        "Process exige cada limitation declarar alternative (lens/abordagem substituta) + rationale. Heuristic reforça que limitation sem alternative é dead text. Mantém severity warn (per schema tq-ln-04)."
			severity:    "warn"
			rationale:   "Lens sem fronteira explícita tende a ser aplicada fora de contexto. Alternative força fronteira navegável: agente sabe para onde ir quando lens não cobre."
		}, {
			id:          "tq-lng-05"
			description: "Guide produz lens cujo relatedLenses usa tipo de relação semanticamente correto"
			test:        "Process exige escolha entre {complementsWith, tensionWith, feedsInto, dependsOn, extends, supersededBy, alternativeTo} com context articulando POR QUE essa relação. Heuristic mapeia semantics de cada tipo. tensionWith em particular sinaliza arbitragem por agente."
			severity:    "warn"
			rationale:   "Tipo de relação determina como agente combina lenses. complementsWith errado para tensionWith faz agente somar lenses contraditórias; o inverso faz agente arbitrar lenses que apenas se somam. Errado é drift de raciocínio cognitivo silencioso."
		}, {
			id:          "tq-lng-06"
			description: "Guide produz lens descritiva — NÃO contém decisão normativa, policy, regra de enforcement ou workflow operacional"
			test:        "Heuristics em concepts-reasoning-examples declara que concept/reasoning step operando como policy disfarçada (declara workflow operacional, regra de enforcement, OR decisão obrigatória sobre estado do sistema) é falha; orientação analítica é o escopo válido. Imperativos textuais ('DEVE'/'NUNCA'/'OBRIGATÓRIO') são RED FLAG para inspeção mas NÃO falha textual literal — 'lens não deve ser usada quando X' é boundary descritivo válido. Falha real: se remover concept/step, alguma regra que ninguém mais enforça desaparece (policy creep). finalValidation aplica canonical removal test (tq-mg-10): se remover lens, invariant deixa de existir? NÃO esperado — lens é descritiva, não enforcer."
			severity:    "fail"
			rationale:   "Lens que enforça regra é policy disfarçada — viola separação categórica adr-040 (lens orienta análise; policy/structural-check enforça). Founder addition crítica: protege contra governance escondida em artefato descritivo. Vetor recorrente em sistemas com lenses ricos onde catálogo cresce sem disciplina de fronteira."
		}]
		rationale: "6 critérios cobrem disciplinas core para autoria de lens: trigger determinístico (tq-lng-01), capacidade analítica própria (tq-lng-02), examples concretos (tq-lng-03), limitations com alternative (tq-lng-04), relatedLenses semantic correctness (tq-lng-05), separação descritivo↔normativo (tq-lng-06 founder addition). Critérios 01-04 derivam direto de tq-ln-XX do schema (hardening warn→fail em 01-03 onde fabricação por agente é risco crítico); 05 generaliza pattern de relatedLenses observado em lenses paradigmáticas; 06 é proteção founder-driven contra policy creep — lens como governance escondida. tq-mg-04 (anti-invenção) reforçado em gapPolicy outer + heuristics de cada section."
	}

	prerequisites: {
		description: "Antes de criar lens, agente lê schema #AnalyticalLens completo, consulta 2-3 lenses paradigmáticas existentes em architecture/lenses/, verifica não-colisão de id, identifica catálogos de principleIds (axiomas, design principles, P-XX) e confirma com founder o escopo + ângulo distintivo da lens (vs catálogo existente)."
		collectFromFounder: [
			"Id da lens (lens-XYZ) + name auto-explicativo + purpose ≤200 runes (o que cobre + por que existe)",
			"Trigger criteria iniciais — em quais cenários esta lens deve ativar; em quais NÃO ativar (excludeWhen); vocabulário Mesh real (keywords)",
			"Concepts core esperados — 5+ ferramentas analíticas com manifestação Mesh real (não conceitos acadêmicos por associação nominal)",
			"Mesh examples âncora — 2+ cenários Mesh reconhecíveis onde a lens muda decisão concreta",
			"Relations com lenses adjacentes — complementa, tensiona, depende? Articulação de boundary com catálogo existente",
			"Limitations honestas — onde lens NÃO se aplica + qual lens/abordagem alternativa cobre o gap",
		]
		gapPolicy:     "Anti-fabulação acadêmica como regra central: NÃO importar teoria acadêmica por associação nominal. Só incluir conceitos que tenham manifestação concreta em Mesh, uso decisório claro e boundary explícita com outras lenses. Concept SEM meshManifestation real é fabulação por importação nominal — REJEITAR, não inventar manifestação. NÃO copiar concepts de outra lens sem verificar relevância para escopo desta. NÃO inventar trigger conditions/keywords por extensão semântica do nome da lens — usar VOCABULÁRIO Mesh real. NÃO declarar relatedLenses por afinidade temática sem articular tipo de relação concreta (complementsWith / tensionWith / etc.). NÃO inventar limitations por completude — limitação ≥2 deve ser real, com alternative concreta. Quando founder não souber articular escopo distintivo da lens, OMITAR criação até clareza emergir — lens vaga é pior que ausência. Anti-policy creep: concept ou reasoning step que opera como policy disfarçada (declara workflow operacional, regra de enforcement, decisão obrigatória sobre estado) viola escopo descritivo da lens — refatorar para qualificação observacional ou mover normativo para policy/governance/structural-check apropriado."
		validatorNote: "Em Fase 0/1, founder review section-by-section per manualAuthoringProtocol (adr-057) é obrigatório. Section gates impedem authoring batch sem confirmação. Lens não está em sc-pg-01 coveredSchemas (cascade ordering structural-check não bloqueia) — protection vive no manualAuthoringProtocol."
		outputNote:    "Output é arquivo único architecture/lenses/<id>.cue conformante a #AnalyticalLens. Tamanho típico: 150-220 linhas para lenses iniciais; lenses paradigmáticas (lens-organizational-resource-allocation, lens-game-theory-applied) chegam a 400-470 linhas com 8-10 concepts + reasoning protocols extensos."
	}

	workOrder: [
		"identity-and-trigger",
		"concepts-reasoning-examples",
		"relations-limitations-validation",
	]

	sections: {
		"identity-and-trigger": {
			target:    "#AnalyticalLens"
			objective: "Estabelecer identidade da lens (id, name, purpose, status, verticalApplicability) e definir trigger (conditions ≥3 + keywords ≥5 + excludeWhen + rationale) que torna ativação determinística."
			process: [{
				action: "Identificar id da lens"
				detail: "id segue regex ^lens-[a-z][a-z0-9-]*$. Nome auto-explicativo curto (ex.: lens-game-theory-applied, lens-organizational-resource-allocation). NÃO copiar de outra lens; verificar não-colisão em architecture/lenses/."
			}, {
				action: "Compor purpose como síntese de 1-2 frases"
				detail: "Resposta a 'o que esta lens cobre e por que existe', em ≤200 runes. Permite ao agente decidir se carrega a lens antes de ler 75k+ chars. Sem purpose claro, lens é dead weight no context window."
			}, {
				action: "Declarar status inicial"
				detail: "Default 'draft' para lenses recém-criadas. Promotion para 'active' apenas após uso real em ≥1 decisão Mesh comprovada. 'deprecated' apenas via supersession explícita por outra lens com supersededBy populado."
			}, {
				action: "Declarar verticalApplicability (Fase 1 advisory per adr-043)"
				detail: "Mode (vertical-agnostic / vertical-adaptable / vertical-specific) + rationale. Lens nascida agnostic deveria ser explícita; lens vertical-adaptable enumera pontos de variação por vertical no rationale. Ausência aciona tq-ln-05 warn — Fase 1 advisory."
			}, {
				action: "Compor trigger.conditions (≥3) deterministicamente avaliáveis"
				detail: "Cada condition é frase descrevendo cenário concreto onde lens deve ativar. Avaliação determinística: dado tipo de decisão concreto, é possível determinar SIM/NÃO se condition matcha. NÃO usar quantificadores vagos ('às vezes', 'frequentemente', 'depende de contexto')."
			}, {
				action: "Listar trigger.keywords (≥5) identificáveis em prompt/contexto/artefato"
				detail: "Keywords que aparecem no prompt do founder OU em artefato sob análise OU em decisão proposta — sinalizam relevância da lens. Específicas ao escopo (ex.: 'auction', 'RFQ', 'allocation'); genéricas demais (ex.: 'system', 'process') geram falsa ativação."
			}, {
				action: "Declarar trigger.excludeWhen (opcional mas recomendado)"
				detail: "Cenários onde lens NÃO deve ativar mesmo se conditions/keywords matcham — defesa contra falsa ativação. Ex.: lens-game-theory-applied excludeWhen 'agente único sem interação estratégica entre múltiplos atores'. Lens sem excludeWhen é mais propensa a over-application."
			}, {
				action: "Compor trigger.rationale articulando boundary"
				detail: "Por que trigger criteria foram escolhidos. Articulação de fronteira com outras lenses: 'esta lens ativa quando X mas NÃO quando Y por motivo Z'. Sem rationale, boundary com lens-adjacent fica implícita."
			}]
			sources: [
				"architecture/artifact-schemas/lens.cue (#AnalyticalLens, #LensRef, trigger constraints)",
				"architecture/lenses/lens-organizational-resource-allocation.cue (lens primária ~413 linhas; pattern de declaração de identidade)",
				"architecture/lenses/lens-game-theory-applied.cue (lens com adversarial focus ~408 linhas; pattern de trigger conditions específicas)",
				"architecture/lenses/lens-mechanism-design.cue (lens com tensão complementar a game-theory ~469 linhas; pattern de excludeWhen)",
			]
			heuristics: [
				"purpose ≤200 runes: agente decide carregar ou omitir lens em < 5s. Purpose verboso quebra context budget e mata a função sintética do campo.",
				"trigger.conditions e trigger.keywords são complementares: conditions descrevem CENÁRIO de aplicação; keywords identificam VOCABULÁRIO presente. Ambos são necessários para ativação determinística — só um vira ativação enviesada.",
				"verticalApplicability declaração explícita (default Fase 1 advisory): mesmo lens vertical-agnostic deveria declarar — ausência cria ambiguidade silenciosa.",
				"Status 'draft' → 'active' exige USO REAL comprovado (≥1 decisão Mesh aplicou esta lens conscientemente). Promotion sem uso é wishful thinking — cobertura aparente sem operação.",
				"excludeWhen é defesa primária contra ativação falsa: se lens cobre tema amplo (ex.: 'system thinking', 'governance'), excludeWhen é o que IMPEDE ativação em qualquer problema — sem ele, lens é sempre advisory genérica.",
				"Anti-fabulação acadêmica (gapPolicy core): keywords e conditions devem refletir VOCABULÁRIO Mesh real, não terminologia acadêmica importada por associação nominal.",
			]
			doneCriteria: "id válido (regex ^lens-[a-z][a-z0-9-]*$), name não-vazio auto-explicativo, purpose ≤200 runes articulando 'o que cobre + por que existe', status declarado (default 'draft'), verticalApplicability presente com mode + rationale (warn se ausente per tq-ln-05), trigger.conditions ≥3 deterministicamente avaliáveis (sem quantificadores vagos), trigger.keywords ≥5 específicas ao escopo (não genéricas), trigger.excludeWhen presente quando lens cobre tema amplo, trigger.rationale articulando boundary com lenses adjacentes."
			ifGap:        "Se purpose não cabe em 200 runes, escopo da lens é difuso — refinar antes de prosseguir. Se trigger.conditions usam quantificadores vagos, ativação vira probabilística — reescrever cada condition como SIM/NÃO testável. Se < 3 conditions emergem genuinamente, lens é provavelmente sub-categoria de outra lens — verificar antes de criar. Se < 5 keywords específicas emergem, vocabulário da lens é genérico demais — fronteira com lenses adjacentes fica difusa, ativação enviesada inevitável. Se id colide com lens existente, NÃO renomear forçando — investigar se proposed lens é genuinamente nova ou sub-aspecto da existente."
		}

		"concepts-reasoning-examples": {
			target:    "#AnalyticalLens"
			objective: "Compor o conteúdo substantivo da lens: concepts (≥5 com nature/role/dependsOn) que materializam ferramentas analíticas, reasoningProtocol (≥4 steps) que orienta sequência de aplicação, meshExamples (≥2) que demonstram aplicação concreta a cenário Mesh."
			process: [{
				action: "Identificar concepts core (≥5) com manifestação Mesh real"
				detail: "Cada concept declara: id (regex ^[a-z][a-z0-9]+-[a-z][a-z0-9-]*$), name, nature (theoretical/operational), role (framework/method/property/heuristic), definition (≥1 frase teórica), meshManifestation (como aparece em Mesh concretamente), meshImplication (decisão/design que muda por causa do concept), rationale (por que concept está nesta lens). Concept SEM meshManifestation real é fabulação acadêmica — REJEITAR."
			}, {
				action: "Declarar concepts.dependsOn quando aplicável"
				detail: "dependsOn lista concepts da MESMA lens que são pré-requisitos cognitivos para entender o concept atual. CI valida que ids referenciados existem. Use crossDependsOn (lensId + conceptId + context) para refs cross-lens. Default sem dependsOn — concept independente."
			}, {
				action: "Compor reasoningProtocol como ≥4 steps sequenciais"
				detail: "Cada step declara: question (pergunta concreta que agente faz), reveals (o que análise da pergunta revela), rationale, appliesWhen opcional (condição de aplicação do step). Steps formam sequência de raciocínio que vai além de aplicação direta de princípios — sem isso, lens é peso morto (tq-ln-02 fail)."
			}, {
				action: "Compor meshExamples (≥2) com cenário concreto + análise + recomendação"
				detail: "Cada example declara: id (regex ^ex-[a-z][a-z0-9-]*$), scenario (descrição de situação Mesh reconhecível), analysis (como a lens lê o cenário), recommendation (decisão/ação concreta que emerge), principlesApplied (refs a ax/dp/P aplicados), assumptions (premissas operacionais), rationale (por que este example ilustra a lens)."
			}, {
				action: "Verificar tq-mg-10 canonical removal test (UNIVERSAL)"
				detail: "Pergunta: 'se removermos esta lens, alguma invariant Mesh deixa de existir / alguma policy deixa de ser enforced / algum workflow operacional para?'. Resposta esperada: NÃO — lens é descritiva (orienta análise), não normativa. Resposta SIM indica lens virou policy disfarçada — refatorar conteúdo para mover normativo para policy/governance/structural-check apropriado."
			}]
			sources: [
				"architecture/artifact-schemas/lens.cue (#LensConcept, #ReasoningStep, #LensExample)",
				"architecture/lenses/lens-organizational-resource-allocation.cue (concepts paradigmáticos com mesh-manifestation rica)",
				"architecture/lenses/lens-information-economics.cue (reasoningProtocol como sequência de perguntas adversariais)",
			]
			heuristics: [
				"Anti-fabulação acadêmica: concept SEM meshManifestation real é fabulação por importação nominal. Conceito acadêmico sem aplicação Mesh comprovada é OMITIR, não inventar manifestação.",
				"Concept.role (framework/method/property/heuristic): framework é estrutura analítica abstrata; method é procedimento aplicável; property é característica observável; heuristic é regra prática. Categorização errada degrada usabilidade da lens.",
				"Concept.nature (theoretical/operational): theoretical descreve o que é; operational descreve o que fazer. Operational concepts podem ter reviewCadence — degradam com tempo (revisar quarterly/annual).",
				"reasoningProtocol agrega capacidade analítica PRÓPRIA — perguntas que LEVAM a análise diferente da aplicação direta de princípios gerais. Steps que apenas repetem 'aplique P10' são peso morto.",
				"meshExamples são âncoras de uso — cenário Mesh reconhecível (ex.: 'BC SSC decide sourcing entre 3 fornecedores qualificados sob assimetria de informação'), análise que aplica a lens, recomendação concreta que emerge. Example sem recomendação acionável é dead documentation.",
				"Anti-policy creep (tq-lng-06): concepts e reasoningProtocol orientam ANÁLISE; NÃO declaram regra de enforcement, workflow operacional ou decisão obrigatória sobre estado do sistema. Imperativos textuais ('DEVE'/'NUNCA') são RED FLAG para inspeção — não falha textual literal ('lens não deve ser usada quando X' é boundary descritivo válido). Falha real: concept/step que opera como policy disfarçada — se remover, sistema perde regra que ninguém mais enforça.",
			]
			doneCriteria: "concepts ≥5 com id único + name + nature + role + definition + meshManifestation concreto + meshImplication + rationale; dependsOn referencia concepts existentes na lens (CI valida); reasoningProtocol ≥4 steps com question + reveals + rationale; meshExamples ≥2 com id (ex-XX) + scenario + analysis + recommendation + principlesApplied + assumptions + rationale; canonical removal test (tq-mg-10) respondido NÃO em rationale do guide outer; nenhum concept ou reasoning step opera como policy disfarçada (tq-lng-06)."
			ifGap:        "Se concept não tem meshManifestation real, OMITIR — não inventar por extensão acadêmica. Se < 5 concepts emergem genuinamente, lens é provavelmente sub-aspecto de outra existente — verificar antes de continuar. Se reasoningProtocol parece duplicar princípios (P10, dp-XX) sem agregar capacidade própria, lens não justifica existência (tq-ln-02 fail). Se meshExample não tem recomendação acionável, é narrativa não-operacional — reescrever ou substituir. Se concept ou reasoning step opera como policy (declara workflow operacional, regra de enforcement, decisão obrigatória sobre estado) em vez de orientar análise, lens vira governance escondida (tq-lng-06 fail) — refatorar para qualificação observacional ou mover normativo para policy/governance/structural-check apropriado."
		}

		"relations-limitations-validation": {
			target:    "#AnalyticalLens"
			objective: "Declarar contexto da lens (principleIds + relatedLenses) + limitations explícitas + rationale outer sintético + finalValidation que termina com submissão ao founder."
			process: [{
				action: "Declarar principleIds com refs a ax/dp/P"
				detail: "Lista de principles (regex ^(ax-[0-9]{2}|dp-[0-9]{2}|P[0-9]{1,2})$) que a lens torna operacional. Refs validam contra catálogo (axiomas em domain-definition, dp-XX em design-principles, P-XX em README). Lens sem principleIds é descontextualizada — tipicamente 2-4 refs."
			}, {
				action: "Declarar relatedLenses (≥1) com tipo de relação"
				detail: "Cada entry tem lensId + relation (complementsWith / tensionWith / feedsInto / dependsOn / extends / supersededBy / alternativeTo) + context. Em catálogo já populado (50+ lenses), relatedLenses vazio é quase sempre suspeita — provável duplicação, sub-aspecto OU drift de fronteira. complementsWith é mais comum (capacidades somam); tensionWith sinaliza ações opostas (agente arbitra). Tipo de relação semanticamente correto (tq-lng-05 warn)."
			}, {
				action: "Compor limitations (≥2) com alternativa concreta"
				detail: "Cada limitation declara: description (onde lens falha), alternative (lens/abordagem substituta), rationale. Limitation 'lens não cobre X' SEM alternative é incompleta — alternative força fronteira navegável."
			}, {
				action: "Compor rationale outer como síntese"
				detail: "Sintetiza identity + concepts core + relations + limitations em 1-3 parágrafos. Permite leitura standalone da lens sem ler conteúdo inteiro. NÃO repetir purpose nem rationale de campos individuais — sintetizar coverage."
			}, {
				action: "Verificar tq-lng-XX (programmatic)"
				detail: "Suite mínima: tq-lng-01 (trigger conditions deterministicamente avaliáveis), tq-lng-02 (concepts agregam capacidade — não duplicam principles), tq-lng-03 (examples concretos), tq-lng-04 (limitations com alternative — warn), tq-lng-05 (relatedLenses semantic correctness — warn), tq-lng-06 (lens não opera como policy disfarçada)."
			}, {
				action: "Executar cue vet ./architecture/lenses/ ./architecture/artifact-schemas/"
				detail: "Validação shape final do pacote inteiro (não apenas arquivo isolado — evita problema de sibling refs). Falha aqui bloqueia avanço — corrigir sintaxe e re-executar antes de submeter."
			}, {
				action: "Submeter ao founder para aprovação explícita antes de commit"
				detail: "Step próprio bloqueante per adr-057 founderConfirmation. NÃO absorvido em validação de critérios precedentes. Apresentar lens completa com sumário de identity + concepts count + reasoning steps count + examples + relations. Founder aprova explicitamente antes de write."
			}]
			sources: [
				"architecture/artifact-schemas/lens.cue (#LensRelation, #LensLimitation, #PrincipleRef, _qualityCriteria)",
				"domain/domain-definition.cue (catálogo de axiomas ax-XX para principleIds refs)",
				"architecture/design-principles.cue (catálogo de dp-XX e P-XX para principleIds refs)",
				"architecture/lenses/ (lenses existentes para verificar lensId em relatedLenses)",
			]
			heuristics: [
				"principleIds: 2-4 refs típicos. Mais que 6 sugere lens cobrindo demais — possível sinal de lens difusa.",
				"relatedLenses.relation semantic: complementsWith (capacidades somam, bidirecional), tensionWith (recomendações podem opor — agente arbitra), feedsInto (output desta é input de outra, direcional), dependsOn (esta requer outra como pré-req), extends (esta aprofunda aspecto da outra), alternativeTo (cobrem mesmo problema com abordagens distintas).",
				"limitations com alternative: cada limitation 'lens X não cobre Y' deve responder 'qual lens/abordagem cobre Y?'. Sem alternative, limitation é dead text — não orienta decisão.",
				"rationale outer ≥500 runes sintetizando coverage; preencher SOMENTE depois de outras sections completas — sintetizar, não inventar.",
				"Submissão ao founder é gate humano explícito (adr-057 manualAuthoringProtocol Camada 2): NÃO absorver em 'verificar critérios + cue vet'. Step bloqueante separado.",
			]
			doneCriteria: "principleIds ≥1 ref válido contra catálogos; relatedLenses ≥1 com lensId existente em architecture/lenses/ E relation type semanticamente apropriado; limitations ≥2 cada com description + alternative + rationale; rationale outer ≥500 runes sintetizando coverage; cue vet PASSED no pacote ./architecture/lenses/ ./architecture/artifact-schemas/; founder approval explícito antes de commit."
			ifGap:        "Se principleIds vazio, lens não conecta a princípios Mesh — verificar se lens é genuína ou aplicação local de princípio existente. Se relatedLenses vazio em catálogo já populado (50+ lenses), lens é quase sempre suspeita — provável duplicação/sub-aspecto de lens existente OU drift de fronteira. Force articulação de ≥1 relation antes de prosseguir. Se limitations < 2, lens pretende universalidade que não tem — force articulação honesta de fronteiras. Se cue vet falha, corrigir sintaxe e re-executar (não é trivial correction se mudança estrutural per CLAUDE.md). Se founder identifica gap em review, voltar para section correspondente — NÃO commitar com gap registrado em rationale."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #AnalyticalLens (todos campos obrigatórios + constraints _allConceptIDs unique + _depsCheck cross-references resolvem).",
			"Verificar tq-lng-01: trigger.conditions são deterministicamente avaliáveis (sem quantificadores vagos como 'às vezes', 'frequentemente', 'depende de contexto').",
			"Verificar tq-lng-02: concepts agregam capacidade analítica própria — reasoningProtocol não duplica aplicação direta de princípios (dp-XX/P-XX/ax-XX).",
			"Verificar tq-lng-03: meshExamples ≥2 com scenario Mesh reconhecível + analysis específica + recommendation acionável.",
			"Verificar tq-lng-04 (warn): cada limitation declara alternative concreta + rationale.",
			"Verificar tq-lng-05 (warn): relatedLenses ≥1 (per doneCriteria de relations-limitations-validation) usa relation type semanticamente apropriado (complementsWith / tensionWith / feedsInto / dependsOn / extends / supersededBy / alternativeTo).",
			"Verificar tq-lng-06 (CRÍTICO): nenhum concept ou reasoning step opera como policy disfarçada (declara workflow operacional, regra de enforcement, OR decisão obrigatória sobre estado do sistema). Imperativos textuais são red flag para inspeção, não falha automática — falha real é enforcement normativo escondido em artefato descritivo.",
			"Verificar canonical removal test (tq-mg-10 UNIVERSAL): se remover esta lens do sistema, alguma invariant Mesh deixa de existir? Resposta esperada NÃO — lens é OPERADORA de raciocínio, não SEGURADORA de invariant. Resposta SIM indica policy creep — refatorar.",
			"Verificar coerência semântica: trigger conditions/keywords refletem vocabulário Mesh real (não terminologia acadêmica por associação nominal); concepts têm meshManifestation concreto (não fabulação); examples são âncoras de uso real.",
			"Executar cue vet ./architecture/lenses/ ./architecture/artifact-schemas/ — validação do pacote inteiro (não apenas arquivo isolado, evita problema de sibling refs). Falha bloqueia avanço; corrigir sintaxe e re-executar antes de submeter ao founder.",
			"Submeter ao founder para aprovação explícita antes de commit — step próprio bloqueante per adr-057 founderConfirmation (NÃO absorvido na inspeção de critérios precedentes; gate humano distinto da inspeção de conformity).",
		]
	}
}
