package artifact_schemas

// domain-story.cue — Schema para domain stories (adr-170; núcleo do WI-113,
// execução parcial: schema + PG + gates; primeira instância vem depois, com
// as fontes do founder).
//
// Uma domain story narra um fluxo de negócio REAL como sequência ordenada
// ator → ação → work-item, atravessando os bounded contexts que o implementam.
// A gramática é a do Domain Storytelling (Hofer/Schwentner) — ator/ação/work
// item —, não a do EventStorming de Brandolini; o WI-113 pedia a forma
// Brandolini completa (commands/events/policies/read-models como elementos
// narrativos próprios) e esta materialização diverge CONSCIENTEMENTE para a
// forma mínima com refs tipadas (divergência declarada em adr-170; elementos
// Brandolini ficam expressáveis via as refs de building block do work-item).
//
// PRINCÍPIO (adr-170): a story REFERENCIA o que já existe no modelo; ela NÃO
// redescreve nem inventa elementos para preencher. Onde o modelo tem o
// elemento → referencia (o gate confere). Onde o modelo NÃO tem → o campo
// fica vazio e o vazio é LACUNA HONESTA registrada — achado sobre o modelo,
// nunca obrigação de inventar. Assim a story funciona como teste de cobertura
// do modelo em todas as dimensões (ator, BC, comando, política, evento,
// read-model, query).
//
// ELOS E GATES (todos born-warn per adr-097; promoção junto da 1ª story):
// - actorRef → domain/stakeholder-map.cue (sc-ds-01, cross-file-id-exists)
// - workItem.boundedContextRef → contexts/*/canvas.cue (sc-ds-02)
// - subdomainRef → strategic/subdomains/*.cue (sc-ds-03)
// - refs de building block → domain-model DO BC DO PASSO (sc-ds-04..08,
//   kind item-scoped-cross-file-id-exists, adr-169): as refs ficam LIMPAS
//   (cmd-*/evt-*/...) — o motor lê o BC do scopeField do próprio passo;
//   sem chave composta.
// - termRefs → elo FROUXO por decisão registrada em def-075: glossários são
//   por-BC e refs cross-glossário não são suportadas; a resolução canônica
//   (glossário-de-story vs glossário-do-BC-do-work-item) fica deferida.

#DomainStory: {
	// Identidade da story. Sem hífen final (aperta a wart conhecida do package).
	code: string & =~"^ds-[a-z][a-z0-9]*(-[a-z0-9]+)*$"
	name: #NonEmptyString

	// Escopo estratégico da jornada: a story cruza BCs; o dono é o subdomínio.
	// Existência gateada por sc-ds-03.
	subdomainRef: #SubdomainRef

	// O que esta story ancora e por quê (o cenário concreto de uso).
	purpose: #NonEmptyString

	// A narrativa: sequência ordenada de passos ator → ação → work-item.
	// A ordem É a posição na lista (sem campo de ordem paralelo — uma única
	// autoridade de sequência).
	steps: [#StoryStep, ...#StoryStep]

	rationale: #NonEmptyString

	_schema: {
		location: {
			canonicalPathRegex: "^strategic/domain-stories/[a-z][a-z0-9-]*\\.cue$"
			fileNameRegex:      "^[a-z][a-z0-9-]*\\.cue$"
			description:        "Domain stories: fluxos de negócio narrados como sequências ator→ação→work-item, com refs gateadas ao modelo."
			rationale:          "Vivem em strategic/ na dobra tese→BC (Layer 1); ancoram design em cenários concretos de uso (WI-113 via adr-170)."
			cardinality:        "collection"
			allowNested:        false
		}
	}
}

#StoryStep: {
	// ELO 1: todo ator da narrativa rastreia a um stakeholder canônico.
	// Formato gateado por CUE; existência por sc-ds-01.
	actorRef: #StakeholderRef

	// A ação narrada, na linguagem do negócio (verbo + complemento).
	action: #NonEmptyString

	// O work-item: o que o sistema faz neste passo e QUEM implementa.
	workItem: {
		description: #NonEmptyString

		// ELO 2: o BC que implementa o passo. Formato por CUE; existência
		// por sc-ds-02. É também o scopeField dos gates por-item (adr-169).
		boundedContextRef: #BoundedContextRef

		// Refs OPCIONAIS aos building blocks que o BC deste passo JÁ
		// materializou no domain-model. Regra única (adr-170): preenchida →
		// morde (sc-ds-04..08 contra o modelo DESTE BC); vazia → lacuna
		// honesta. Regexes por-prefixo (não existe tipo standalone por
		// prefixo no package; o #DomainModelRef é a união dos 11 e não
		// separaria cmd de evt no campo errado).
		commandRefs?:   [...string & =~"^cmd-[a-z][a-z0-9]*(-[a-z0-9]+)*$"]
		eventRefs?:     [...string & =~"^evt-[a-z][a-z0-9]*(-[a-z0-9]+)*$"]
		policyRefs?:    [...string & =~"^pol-[a-z][a-z0-9]*(-[a-z0-9]+)*$"]
		readModelRefs?: [...string & =~"^prj-[a-z][a-z0-9]*(-[a-z0-9]+)*$"]
		queryRefs?:     [...string & =~"^qry-[a-z][a-z0-9]*(-[a-z0-9]+)*$"]

		// ELO 3 (frouxo por decisão registrada em def-075): termos canônicos
		// do passo, resolvidos por convenção no glossário do BC deste
		// work-item; sem gate de existência até def-075 resolver.
		termRefs?: [...#GlossaryTermRef]
	}

	rationale: #NonEmptyString
}
