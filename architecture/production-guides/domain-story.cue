package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-story.cue — Production guide para Domain Stories.
//
// Schema alvo: #DomainStory (architecture/artifact-schemas/domain-story.cue).
// Cardinality collection — instâncias vivem em strategic/domain-stories/.
// Zero instâncias no disco hoje: cascade ordering (adr-054 dec 13) + sc-pg-01
// exigem este PG ANTES da 1ª story, que nasce com as fontes do founder.
//
// Uma domain story narra um fluxo de negócio REAL como sequência ordenada
// ator → ação → work-item, atravessando os BCs que o implementam. Gramática
// Domain Storytelling (Hofer/Schwentner), não EventStorming Brandolini
// completo — divergência declarada em adr-170; elementos Brandolini são
// expressáveis via refs de building block do work-item.
//
// PRINCÍPIO (adr-170): a story REFERENCIA o que já existe no modelo, NUNCA
// inventa para preencher. Ref preenchida → morde (gates); ref vazia → LACUNA
// HONESTA registrada como achado sobre o modelo. A story é teste de cobertura
// do modelo em todas as dimensões (ator, BC, comando, política, evento,
// read-model, query) — inventar para completar inverte o instrumento.
//
// O schema NÃO declara tq-ds-XX intra-artifact: os elos são gateados por
// structural-checks sc-ds-01..08 (born-warn per adr-097; promoção a reject é
// decisão junto da 1ª story). sc-ds-04..08 são item-scoped (adr-169): a ref
// de building block resolve contra o domain-model DO BC DO PASSO
// (scopeField workItem.boundedContextRef) — refs LIMPAS, sem chave composta.
// termRefs é elo FROUXO per def-075 (sem gate até a decisão de resolução
// canônica cross-BC). Os tq-dsg-XX deste guide cobrem o lado de PROCESSO
// de autoria, consistente com o pattern tq-gg/tq-teg.

domainStoryGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/domain-story\\.cue$"
			fileNameRegex:      "^domain-story\\.cue$"
			description:        "Production guide para autoria de domain stories em mesh-spec."
			rationale:          "Schema #DomainStory é instanciável (cardinality collection, zero instâncias hoje); cascade ordering (adr-054 dec 13) + sc-pg-01 (production-guide-coverage per adr-056) exigem PG ANTES da 1ª instância — a 1ª story nasce com as fontes reais do founder e este guide já operante."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-dsg-01"
			description: "Guide produz story cujas refs preenchidas existem verificadas nas fontes canônicas"
			test:        "Process inclui verificação explícita de actorRef (domain/stakeholder-map.cue), boundedContextRef (contexts/*/canvas.cue), subdomainRef (strategic/subdomains/*.cue) e refs de building block (domain-model DO BC do passo) por leitura direta ANTES da proposta; gapPolicy proíbe refs inventadas ou aproximadas; finalValidation reproduz sc-ds-01..08 manualmente (gates born-warn per adr-097 não seguram o erro no CI). Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "Ref aproximada é o vetor #1 previsto para stories: agente tende a preencher com id plausível (sh-XX parecido, cmd-* análogo de outro BC) para fechar a narrativa. Com os gates em warn, só a disciplina de autoria segura — ref fantasma quebra o valor da story como teste de cobertura."
		}, {
			id:          "tq-dsg-02"
			description: "Guide força lacuna honesta como achado registrado — nunca invenção para preencher"
			test:        "Process da section de resolução declara a regra única de adr-170 (ref preenchida → morde; ref vazia → lacuna honesta); a section final exige relatório de lacunas como entregável acompanhando a proposta ao founder; gapPolicy proíbe criar elemento de modelo (stakeholder, BC, comando, evento, política, projeção, query) para completar a story na mesma autoria. Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "A story é teste de cobertura do modelo (adr-170); a ref vazia É o resultado do teste. Inventar para preencher inverte o instrumento — anula o achado e contamina o modelo com elementos nascidos de conveniência narrativa, não de decisão de design."
		}, {
			id:          "tq-dsg-03"
			description: "Guide exige narrativa de fonte REAL na ordem da dor (anti-retrofit)"
			test:        "prerequisites.collectFromFounder exige a narrativa com fonte declarada (piloto/entrevista/observação do founder); process da section narrative-and-scope proíbe sintetizar a story a partir do modelo; heuristics reforça ordem da dor (ordem em que o negócio vive o fluxo) vs ordem do modelo. Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "Story retrofit (modelo → narrativa) valida a si mesma: cobre 100% por construção e não descobre nada. O valor do tipo depende da direção narrativa → modelo — só a narrativa real, na ordem da dor, revela onde o modelo não cobre o negócio."
		}, {
			id:          "tq-dsg-04"
			description: "Guide disciplina o escopo por-item das refs de building block (adr-169)"
			test:        "Heuristics da section steps-and-model-resolution declara que refs de building block são LIMPAS (cmd-*/evt-*/pol-*/prj-*/qry-*, sem chave composta) e resolvem contra o domain-model do BC do scopeField do próprio passo; cópia consumida do elemento no modelo de OUTRO BC não conta como dono. Verificado por inspeção do guide."
			severity:    "warn"
			rationale:   "A união global de domain-models daria falso-verde via cópias consumidas (sourceContext) — cenário provado no self-test do runner (sc-ds-05, evt-invoice-issued em passo cmt). Autoria que ignora o escopo por-item produz refs que o gate certo rejeita depois."
		}]
		rationale: "4 critérios cobrem as disciplinas centrais de autoria de domain story: existência verificada das refs preenchidas (tq-dsg-01) e lacuna honesta como achado (tq-dsg-02) são as duas metades do princípio de adr-170 — referencia o que existe; o vazio é achado; tq-dsg-03 protege a direção do instrumento (narrativa real → modelo, nunca retrofit); tq-dsg-04 protege contra o falso-verde cross-BC que adr-169 mata. O schema não tem tq-ds-XX intra-artifact (os elos vivem nos gates sc-ds-01..08, born-warn); os tq-dsg cobrem o lado de PROCESSO de autoria enquanto o runner cobre o lado de instância commitada — separação consistente com o pattern tq-gg (glossary) e tq-teg (tension-entry)."
	}

	prerequisites: {
		description: "Antes de autorar domain story, agente lê o schema #DomainStory + structural-checks sc-ds-01..08 + domain/stakeholder-map.cue + strategic/subdomains/ + canvases e domain-models dos BCs candidatos, e coleta do founder a narrativa REAL fonte. A story referencia o que existe; lacuna é achado sobre o modelo, nunca licença de invenção."
		collectFromFounder: [
			"A narrativa REAL e sua fonte declarada (piloto, entrevista ou observação do founder): atores envolvidos, sequência de acontecimentos NA ORDEM DA DOR (a ordem em que o negócio vive o fluxo, incluindo espera, retrabalho e fricção) e o cenário concreto que a story ancora — sem fonte real, postergar autoria (story sintetizada do modelo é retrofit circular)",
			"Confirmação do subdomínio dono da jornada (code existente em strategic/subdomains/*.cue) — a story cruza BCs; o dono estratégico é o subdomínio (sc-ds-03)",
			"Decisão sobre atores da narrativa SEM stakeholder correspondente no stakeholder-map: registrar sh-* novo ANTES da story (fluxo próprio do stakeholder-map, decisão do founder) OU manter o ator fora da narrativa formal como achado — agente NÃO cria ref aproximada",
			"Alinhamento de expectativa sobre lacunas conhecidas de antemão (ex.: BC do passo ainda sem domain-model → refs de building block vazias em bloco): o relatório de lacunas é entregável esperado da autoria, não sinal de falha",
		]
		gapPolicy:     "A story REFERENCIA o que já existe no modelo — NÃO inventa para preencher (adr-170). Se um ator não existe em domain/stakeholder-map.cue, NÃO crie ref aproximada nem sh-* fictício — pare o passo e reporte como achado (registrar stakeholder é decisão do founder, fora deste guide). Se o BC implementador de um passo não tem canvas, NÃO invente boundedContextRef — escale: derivar o BC primeiro (fluxo próprio, PG de canvas + P13) OU redesenhar/postergar a story; o campo é obrigatório e não admite placeholder. Se o domain-model do BC do passo não tem o comando/evento/política/projeção/query narrado, deixe a ref VAZIA e registre a lacuna honesta como achado — NÃO crie o elemento no domain-model para completar a story na mesma autoria (mudança de domain-model é fluxo próprio, com PG e aprovação próprios). NÃO use cópia consumida de outro BC como dono (o gate resolve contra o modelo DO BC DO PASSO, adr-169). NÃO preencha termRefs por palpite — o elo frouxo per def-075 não é licença de chute; preencha só termos verificados no glossário do BC do passo, na dúvida OMITA. Se a narrativa fonte não existe, NÃO autore story especulativa — postergue até piloto/entrevista/observação existir. Quando dúvida persistir, pergunta direta ao founder; nunca preencher por inferência heurística."
		validatorNote: "Gates estruturais sc-ds-01..08 já existem e cobrem os elos (actorRef, boundedContextRef, subdomainRef, building-block refs item-scoped per adr-169), mas nascem born-warn per adr-097 — promoção a reject é decisão do founder junto da 1ª story real. Durante autoria, warn é tratado como fail: verificação manual das refs contra as fontes é obrigatória antes da proposta. termRefs fica sem gate de existência até def-075 resolver a resolução canônica cross-BC. Founder review é o gate semântico final: fidelidade da narrativa à fonte, ordem da dor e genuinidade das lacunas exigem julgamento humano que estrutura não alcança."
		outputNote:    "Output é arquivo único strategic/domain-stories/{slug}.cue conformante a #DomainStory (canonicalPathRegex '^strategic/domain-stories/[a-z][a-z0-9-]*\\.cue$'; cardinality collection). code com prefixo ds-, sem hífen final. Zero instâncias existem hoje — a 1ª story é também o gatilho da decisão de promoção warn→reject dos sc-ds-01..08. A proposta ao founder vai acompanhada do relatório de lacunas honestas (entregável de sessão no chat, não arquivo do repo)."
	}

	workOrder: [
		"narrative-and-scope",
		"steps-and-model-resolution",
		"gaps-validation-and-submission",
	]

	sections: {
		"narrative-and-scope": {
			target:    "#DomainStory"
			objective: "Capturar a narrativa REAL da fonte declarada pelo founder, extrair a sequência ator → ação → work-item na ordem da dor, e compor a identidade da story (code, name, purpose, subdomainRef) ANTES de resolver qualquer ref contra o modelo."
			process: [{
				action: "Coletar a narrativa real da fonte declarada pelo founder"
				detail: "Fonte é piloto, entrevista ou observação — nunca o próprio modelo. Pedir a sequência de acontecimentos NA ORDEM DA DOR: a ordem em que o negócio vive o fluxo (incluindo espera, retrabalho, fricção), não a ordem em que a arquitetura organizaria. Registrar a fonte no material da sessão para o founder review."
			}, {
				action: "Extrair a sequência ator → ação → work-item da narrativa"
				detail: "Gramática Domain Storytelling (Hofer/Schwentner): cada passo tem UM ator (quem age), UMA ação (verbo + complemento na linguagem do negócio) e UM work-item (o que o sistema faz e quem implementa). A ordem É a posição na lista steps — sem campo de ordem paralelo (uma única autoridade de sequência per schema)."
			}, {
				action: "Compor code, name e purpose da story"
				detail: "code satisfaz '^ds-[a-z][a-z0-9]*(-[a-z0-9]+)*$' (sem hífen final — aperta a wart conhecida do package); name descritivo da jornada; purpose declara o cenário CONCRETO de uso que a story ancora e por quê (quem, o quê, em que situação) — não missão genérica."
			}, {
				action: "Verificar subdomainRef contra strategic/subdomains/"
				detail: "A story cruza BCs; o dono estratégico da jornada é o subdomínio. Verificar que o code existe em strategic/subdomains/*.cue (sc-ds-03) por leitura direta ANTES de incluir. Subdomínio inexistente não é preenchível por aproximação — escalar ao founder."
			}]
			sources: [
				"architecture/artifact-schemas/domain-story.cue (schema #DomainStory + #StoryStep; comments carregam o princípio de adr-170)",
				"architecture/structural-checks/domain-story.cue (sc-ds-01..08 — o que morde em cada elo)",
				"domain/stakeholder-map.cue (universo canônico de atores sh-*)",
				"strategic/subdomains/ (universo canônico de donos estratégicos)",
			]
			heuristics: [
				"Fonte real primeiro: story nasce de narrativa observada (piloto/entrevista/observação), nunca do modelo — story que apenas percorre o modelo na ordem do modelo é retrofit circular e perde o valor de teste de cobertura (tq-dsg-03).",
				"Ordem da dor ≠ ordem limpa: se a narrativa real tem espera de 60 dias, retrabalho ou vai-e-volta, a sequência de passos preserva isso — a dor é informação de design, não ruído a editar.",
				"Um passo = um ator + uma ação + um work-item; passo com dois atores agindo é sinal de dois passos; ação sem ator identificável é sinal de que o passo é reação do sistema (a política, se existir no modelo, entra como policyRef do work-item, não como ator).",
				"purpose declara o cenário concreto ancorado; o rationale da story (composto na section final) registra por que ESTE registro merece ser canônico — não duplicar um no outro.",
			]
			doneCriteria: "Narrativa real coletada com fonte declarada; sequência de passos extraída na ordem da dor com ator/ação/work-item identificados por passo; code, name e purpose compostos conforme regex e propósito; subdomainRef verificado existente em strategic/subdomains/*.cue por leitura direta."
			ifGap:        "Se não há fonte real disponível (nenhum piloto, entrevista ou observação), NÃO autore — postergue até a fonte existir; story especulativa não testa cobertura de nada. Se o subdomínio dono não existe em strategic/subdomains/, escalar ao founder — declarar subdomínio é decisão estratégica prévia à story, não parte dela."
		}

		"steps-and-model-resolution": {
			target:    "#StoryStep"
			objective: "Para cada passo extraído da narrativa, resolver o ator a um sh-* existente, o work-item a um BC existente, e preencher as refs de building block SOMENTE com o que o domain-model do BC do passo já materializou — deixando vazio o que o modelo não tem."
			process: [{
				action: "Resolver actorRef contra domain/stakeholder-map.cue"
				detail: "Cada ator da narrativa mapeia para stakeholders[].code (regex '^sh-[0-9]{2}$'). Verificar existência por leitura direta ANTES de incluir (sc-ds-01). Ator sem stakeholder correspondente NÃO vira ref aproximada — é achado sobre o stakeholder-map: parar o passo e reportar (registrar sh-* novo é decisão do founder)."
			}, {
				action: "Compor action na linguagem do negócio"
				detail: "Verbo + complemento como o ator descreveria o que faz ('solicita antecipação do recebível'), não jargão do sistema ('dispara cmd-request-anticipation'). A tradução para o modelo vive nas refs do work-item, não na action."
			}, {
				action: "Declarar workItem.description e verificar boundedContextRef contra contexts/*/canvas.cue"
				detail: "description narra o que o sistema faz neste passo. boundedContextRef é o BC que IMPLEMENTA o passo — verificar canvas.code existente por leitura direta (sc-ds-02). É também o scopeField dos gates por-item (adr-169). BC sem canvas não é referenciável: escalar (derivar BC primeiro ou postergar a story) — o campo é obrigatório e não admite placeholder."
			}, {
				action: "Ler o domain-model do BC do passo e preencher refs de building block só com codes existentes"
				detail: "Abrir contexts/{bc}/domain-model.cue DO BC DESTE passo. Para cada dimensão narrada, procurar o code correspondente: comando disparado → commands[].code (cmd-*), evento resultante → events[].code (evt-*), política reagindo → policies[].code (pol-*), tela/projeção consultada → projections[].code (prj-*), consulta → projections[].queryCapabilities[].code (qry-*). Encontrou → preenche com o code EXATO lido do modelo (sc-ds-04..08 mordem). Não encontrou → campo fica vazio: lacuna honesta, registrada como achado. NUNCA inventar code nem usar cópia consumida de outro BC como dono."
			}, {
				action: "Avaliar termRefs sob o elo frouxo de def-075"
				detail: "Campo opcional, resolução POR CONVENÇÃO no glossário do BC do passo, sem gate de existência até def-075 resolver. Disciplina mesmo sem gate: preencher apenas termos verificados por leitura no glossário do BC do passo (contexts/{bc}/glossary.cue); na dúvida, OMITIR — typo passa silencioso até a decisão."
			}, {
				action: "Compor rationale do passo"
				detail: "Por que este passo existe na narrativa — o que ele ancora ou testa no modelo (ex.: 'passo onde a dor de visibilidade se manifesta; testa cobertura de leitura do BC X'). Não repetir a action nem a description."
			}]
			sources: [
				"architecture/artifact-schemas/domain-story.cue (#StoryStep — refs opcionais por prefixo e regra única de adr-170)",
				"architecture/structural-checks/domain-story.cue (sc-ds-01/02/04..08 — referencePath e targetIdPath exatos de cada elo)",
				"domain/stakeholder-map.cue (stakeholders[].code)",
				"contexts/*/canvas.cue (canvas.code dos BCs deriváveis como implementadores)",
				"contexts/*/domain-model.cue (commands/events/policies/projections/queryCapabilities dos BCs que já têm modelo)",
				"architecture/deferred-decisions/def-075-story-term-glossary-resolution.cue (por que termRefs é frouxo e o que fica deferido)",
			]
			heuristics: [
				"Regra única (adr-170): ref preenchida → morde; ref vazia → lacuna honesta. NUNCA inventar cmd-/evt-/pol-/prj-/qry- para completar o passo — o vazio é o achado (tq-dsg-02).",
				"Refs de building block são LIMPAS (cmd-x, sem chave composta): o escopo vem do boundedContextRef do próprio passo (adr-169) — o motor lê o BC do scopeField; não prefixar nem qualificar a ref.",
				"Cópia consumida não é dono: evento presente no modelo de outro BC via sourceContext não conta — sc-ds-05 resolve contra o modelo DO BC DO PASSO (o falso-verde que adr-169 mata; tq-dsg-04).",
				"commandRefs vs readModelRefs/queryRefs distinguem a mutação narrada da leitura narrada — quando o modelo tem ambos os lados do passo, declarar ambos torna a cobertura bidimensional (write + read).",
				"Enforcement dos elos vive no RUNNER via sc-ds-01..08 (born-warn per adr-097; promoção junto da 1ª story): o guide disciplina a autoria; o gate valida a instância commitada — dois enforcers, papéis distintos, sem substituição.",
				"Ator que não resolve a sh-* é ACHADO sobre o stakeholder-map, não licença para ref aproximada — sh-* plausível mas não verificado falha sc-ds-01 e contamina a rastreabilidade de incentivos/dores.",
				"BC sem domain-model → todas as refs de building block do passo ficam vazias: lacuna honesta em bloco, registrada uma vez no relatório (não por campo).",
			]
			doneCriteria: "Cada passo tem actorRef verificado em stakeholder-map, action na linguagem do negócio, workItem com description e boundedContextRef verificado em canvas existente; refs de building block preenchidas apenas com codes confirmados por leitura do domain-model do BC do passo; dimensões sem correspondência deixadas vazias e anotadas para o relatório; rationale por passo preenchido sem duplicar action/description."
			ifGap:        "Se o ator não existe no stakeholder-map, parar o passo e reportar como achado — não criar ref aproximada. Se o BC implementador não tem canvas, escalar: derivar o BC primeiro (P13 + PG de canvas) OU redesenhar/postergar a story. Se o domain-model do BC não existe ou não tem o elemento narrado, deixar refs vazias e registrar a lacuna — mudança de domain-model é fluxo próprio, nunca efeito colateral da story."
		}

		"gaps-validation-and-submission": {
			target:    "#DomainStory"
			objective: "Consolidar as lacunas honestas como relatório de achados sobre o modelo, verificar as refs preenchidas reproduzindo os gates manualmente, compor o rationale da story e submeter ao founder com o relatório anexo."
			process: [{
				action: "Listar lacunas honestas como achados sobre o modelo"
				detail: "Para cada ref vazia (ou bloco vazio por BC sem modelo): dimensão (ator/BC/comando/evento/política/read-model/query), passo afetado, o que a narrativa precisaria e status no modelo (ausente). O relatório acompanha a proposta — a story é teste de cobertura; o vazio é o RESULTADO do teste. Lacuna NÃO vira obrigação de criar elemento na mesma sessão: o destino (WI, derivação de BC, decisão, aceitar o vazio) é do founder."
			}, {
				action: "Verificar todas as refs preenchidas contra as fontes (pré-gate manual de sc-ds-01..08)"
				detail: "Reproduzir cada gate por leitura direta: actorRef ∈ stakeholders[].code; boundedContextRef ∈ canvas.code; subdomainRef ∈ subdomains code; cada cmd-/evt-/pol-/prj-/qry- ∈ coleção correspondente do domain-model DO BC do passo. Gates são born-warn (adr-097) — a autoria NÃO conta com reject para segurar erro; warn de sc-ds-0X é tratado como fail durante autoria."
			}, {
				action: "Executar cue vet sobre o arquivo da story e os schemas"
				detail: "Shape: regex de code (ds-*), actorRef (sh-NN), refs por prefixo, steps não-vazio, rationales presentes. CUE inválido nunca é proposto nem commitado."
			}, {
				action: "Verificar coerência narrativa e ordem da dor"
				detail: "Ler a story de ponta a ponta como narrativa de negócio: a ordem dos passos ainda é a ordem da narrativa fonte (sem reordenação para 'ficar limpo' pelo modelo)? Cada passo é legível como ator agindo? Se a resolução ao modelo distorceu a narrativa, corrigir a story — nunca a fonte."
			}, {
				action: "Compor rationale da story"
				detail: "Por que esta jornada merece registro canônico: representatividade da dor, prioridade do cenário na tese, valor do teste de cobertura que ela executa. Não duplica purpose (purpose é o cenário; rationale é o porquê do registro)."
			}, {
				action: "Submeter ao founder para aprovação explícita antes de commit"
				detail: "Proposta acompanhada do relatório de lacunas. Founder decide o destino das lacunas e aprova a story — step próprio bloqueante per adr-057 founderConfirmation. Na 1ª story real, sinalizar também a decisão pendente de promoção warn→reject dos sc-ds-01..08 (catraca adr-097)."
			}]
			sources: [
				"architecture/structural-checks/domain-story.cue (sc-ds-01..08 a reproduzir manualmente; enforcement born-warn)",
				"strategic/domain-stories/ (diretório canônico; zero instâncias hoje — a 1ª story dispara a decisão de promoção dos gates)",
			]
			heuristics: [
				"Relatório de lacunas é entregável de primeira classe da autoria — story com refs vazias e sem relatório está incompleta; story sem nenhuma lacuna merece desconfiança (cobertura 100% na 1ª passada é sintoma de retrofit, tq-dsg-03).",
				"Vazio ≠ erro: ref vazia registrada é sucesso do instrumento; ref inventada para 'passar limpo' é a falha (tq-dsg-01/02).",
				"Born-warn não é verde: durante autoria, warn de sc-ds-0X é tratado como fail — verificação manual obrigatória antes da proposta.",
				"Canonical removal test (tq-mg-10): remover o tipo domain-story do sistema NÃO desprotege invariantes — invariantes vivem no domain-model/lifecycle/gates; a story é OBSERVADOR/teste de cobertura, nunca enforcer. Se uma story estiver segurando regra de negócio que não existe em outro lugar, isso é bug arquitetural: a regra pertence ao modelo.",
			]
			doneCriteria: "Relatório de lacunas compilado (ou registro explícito de zero lacunas com justificativa anti-retrofit); todas as refs preenchidas verificadas por leitura direta contra as fontes; cue vet limpo; ordem narrativa preservada de ponta a ponta; rationale da story composto; proposta pronta com relatório anexo."
			ifGap:        "Se a verificação pré-gate encontra ref sem correspondência, NÃO ajustar por aproximação (id parecido): ou o elemento existe com outro code (corrigir para o code REAL lido do modelo) ou não existe (esvaziar a ref e registrar a lacuna). Se o founder pedir para 'completar o modelo' na mesma sessão, tratar como fluxo separado com PG e aprovação próprios — a story referencia o resultado depois."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #DomainStory (code ds-* sem hífen final; steps não-vazio; cada #StoryStep com actorRef sh-NN, action, workItem com description + boundedContextRef, rationale; refs opcionais satisfazendo regex por prefixo cmd-/evt-/pol-/prj-/qry-).",
			"Verificar tq-pg-01 / tq-mg-01: workOrder é permutação exata das chaves de sections (3 sections; sem redundância, omissão ou duplicata).",
			"Verificar tq-pg-02: cada section.target referencia tipo existente no schema alvo (#DomainStory, #StoryStep).",
			"Verificar tq-pg-04 / tq-mg-04: prerequisites.gapPolicy ≥50 runes E declara comportamento anti-invenção (cláusulas 'NÃO crie ref aproximada', 'NÃO invente boundedContextRef', 'NÃO crie o elemento no domain-model para completar a story', 'NÃO use cópia consumida', 'NÃO preencha termRefs por palpite', 'NÃO autore story especulativa').",
			"Verificar tq-pg-05 / tq-mg-03: finalValidation.steps[-1] é submissão ao founder como step próprio bloqueante distinto (não absorvido em validação de critérios precedentes).",
			"Verificar tq-pg-06 / tq-mg-02: cada section.process[].action começa com verbo imperativo concreto (Coletar, Extrair, Compor, Verificar, Resolver, Declarar, Ler, Avaliar, Listar, Executar, Submeter).",
			"Verificar tq-dsg-01 (fail): toda ref preenchida na story foi verificada por leitura direta contra a fonte canônica — actorRef em domain/stakeholder-map.cue, boundedContextRef em contexts/*/canvas.cue, subdomainRef em strategic/subdomains/*.cue, building-block refs no domain-model DO BC do passo — reproduzindo sc-ds-01..08 manualmente (born-warn não segura o erro).",
			"Verificar tq-dsg-02 (fail): nenhuma ref foi inventada para preencher; toda dimensão narrada sem correspondência no modelo está VAZIA na story e REGISTRADA no relatório de lacunas que acompanha a proposta.",
			"Verificar tq-dsg-03 (fail): a narrativa tem fonte real declarada (piloto/entrevista/observação) e a ordem dos passos é a ordem da dor da fonte — story que apenas percorre o modelo na ordem do modelo é retrofit e volta para narrative-and-scope.",
			"Verificar tq-dsg-04 (warn): refs de building block estão LIMPAS (sem chave composta) e cada uma resolve no modelo do BC do PRÓPRIO passo — nenhuma sustentada por cópia consumida de outro BC.",
			"Verificar canonical removal test (tq-mg-10 warn): se o tipo domain-story for removido, invariants críticos permanecem protegidos (domain-model, lifecycle, gates determinísticos) — a story é OBSERVADOR/teste de cobertura, não enforcer. Resposta esperada: SIM; regra de negócio que só existe na story é bug arquitetural.",
			"Submeter ao founder para aprovação explícita antes de commit, com o relatório de lacunas honestas anexo — step próprio bloqueante per adr-057 founderConfirmation (NÃO absorvido na inspeção de critérios precedentes; gate humano distinto da inspeção de conformity). Na 1ª story real, incluir na submissão a decisão pendente de promoção warn→reject dos sc-ds-01..08 per adr-097.",
		]
	}
}
