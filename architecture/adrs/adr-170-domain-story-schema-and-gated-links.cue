package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr170: artifact_schemas.#ADR & {
	id:    "adr-170"
	title: "Schema #DomainStory com elos gateados: a story referencia o que existe no modelo — nunca inventa; refs vazias são lacunas honestas (teste de cobertura do modelo)"
	date:  "2026-07-05"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		strategic/domain-stories/ existia como cômodo reservado sem forma:
		_meta.cue com intenção declarada ('sequências ator → ação → work item;
		cada story referencia BCs e eventos por ID'), zero schema, zero PG,
		zero instância — o WI-113 (W002) planejou schema Brandolini + 1ª
		instância CMT e nunca executou. A investigação da teia de coerência
		(2026-07-05) mostrou: a sub-teia stakeholder↔canvas↔glossário↔
		domain-model está formalizada e gateada; os elos que passariam PELA
		story (ator←stakeholder, work-item→BC, termo←glossário) nunca foram
		sequer especificados. O review isolado do draft (executionPolicy:
		artifact-schema → isolated-subagent) retornou 3 BLOCKERs (gates
		fictícios sem o pacote completo; def fantasma no elo do termo;
		divergência com _meta/README/WI-113 sobre eventos) e 7 WARNs, todos
		endereçados nesta materialização. O Tempo 1 do stakeholder-map
		concluiu que a migração da instância NÃO é mecânica (def-076) — a
		ponte verificada: sc-ds-01 lê stakeholders[].code, presente nas duas
		shapes.
		"""

	decision: """
		(1) Schema #DomainStory (architecture/artifact-schemas/domain-story.cue):
		narrativa como sequência ordenada de passos ator→ação→work-item
		(gramática do Domain Storytelling, Hofer/Schwentner — o rótulo
		'Brandolini' do WI-113 estava incorreto para esta forma; divergência
		de escopo declarada no item 5). A ordem É a posição na lista — sem
		campo de ordem paralelo (uma única autoridade de sequência).

		(2) PRINCÍPIO NORMATIVO: a story REFERENCIA o que já existe no modelo;
		NÃO redescreve nem inventa elementos para preencher. Refs de building
		block são OPCIONAIS; preenchida → o gate confere a existência; vazia →
		LACUNA HONESTA registrada (achado sobre o modelo). A story é o teste
		de cobertura do modelo em todas as dimensões: ator, BC, comando,
		política, evento, read-model, query.

		(3) ELOS GATEADOS (todos born-warn per adr-097; promoção junto da 1ª
		story real): actorRef→stakeholder-map (sc-ds-01); workItem.
		boundedContextRef→canvases (sc-ds-02); subdomainRef→subdomains
		(sc-ds-03); commandRefs/eventRefs/policyRefs/readModelRefs/queryRefs→
		domain-model DO BC DO PASSO via kind item-scoped-cross-file-id-exists
		(sc-ds-04..08, adr-169) — refs LIMPAS, sem chave composta; o motor lê
		o BC do scopeField do próprio passo. readModelRefs mapeia para
		projections[].code e queryRefs para projections[].queryCapabilities[].
		code — os nomes do disco.

		(4) ELO FROUXO REGISTRADO: termRefs (opcionais, #GlossaryTermRef)
		resolvem POR CONVENÇÃO no glossário do BC do work-item, SEM gate de
		existência — glossários são por-BC e refs cross-glossário não são
		suportadas (tq-gl-02); a resolução canônica cross-BC é deferida em
		def-075.

		(5) EXECUÇÃO PARCIAL do WI-113, declarada: schema + PG + gates entram;
		a 1ª instância (cmt-commitment-formation) fica para fatia própria com
		as fontes do founder. FORA do schema (divergência consciente vs
		Brandolini completo do WI-113): policies/read-models como elementos
		narrativos próprios, hotspots/pivotal events, ramificação de sequência,
		atores não-stakeholder — expressáveis via refs ou adiados até a 1ª
		story pedir.

		(6) Integração de governança no mesmo commit: 'domain-story' no enum
		#ArtifactType; sc-pg-01 coveredSchemas += domain-story (cascade
		ordering: PG antes de instância); PG autorado via authoring-subagent
		(rollout: production-guide = subagent-drafted; dispatch registrado no
		subagent-execution-log); def-076 registra o crack do stakeholder-map
		(D1 ponte — re-autoria é decisão de conteúdo do founder).
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) a 1ª story real não conseguir se expressar na forma mínima (ator→ação→work-item + refs) sem os elementos Brandolini excluídos — sinal de que a divergência do WI-113 cortou demais; OU (b) as refs opcionais forem sistematicamente deixadas vazias mesmo onde o modelo TEM o elemento — o princípio 'vazio = lacuna honesta' virando licença para não referenciar; OU (c) os gates warn acusarem falso-positivo em story legítima (ref correta rejeitada)."
		observableSignal: "(a) é observável na autoria da 1ª story (fatia própria com o founder): elemento narrativo sem lar na forma = reporte imediato. (b) é observável comparando refs vazias vs building blocks existentes no domain-model do BC do passo — divergência sistemática aparece na review da story. (c) é observável no runner: violação sc-ds-* sobre ref que existe no domain-model do BC é falso-positivo, reportar como bug do gate."
	}

	consequences: """
		Positivas: o cômodo reservado ganha forma com os elos que a teia não
		tinha (ator←stakeholder, work-item→BC, refs→modelo-do-BC); a story
		nasce como instrumento de cobertura do modelo, não como prosa solta;
		o falso-verde cross-BC morre para as refs (adr-169); a 1ª instância
		nascerá com PG existente (cascade ordering respeitado) e gates prontos
		em warn.

		Negativas/custos: 8 checks novos em warn ampliam a superfície de
		vigilância antes de existir instância (vácuo-verde até a 1ª story);
		o elo do termo fica declaradamente sem gate até def-075; a divergência
		vs WI-113 significa que a forma Brandolini completa, se a 1ª story
		pedir, exigirá extensão de schema (falsificationCondition (a) vigia).
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/structural-checks/production-guide.cue",
		"governance/build-time/subagent-execution-log.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/domain-story.cue",
		"architecture/structural-checks/domain-story.cue",
		"architecture/production-guides/domain-story.cue",
		"architecture/deferred-decisions/def-075-story-term-glossary-resolution.cue",
		"architecture/deferred-decisions/def-076-stakeholder-map-schema-drift.cue",
	]

	defersTo: ["def-075", "def-076"]

	principlesApplied: [
		"P0 — a story referencia por id, nunca copia: todos os elos são ponteiros gateados; reuso de #StakeholderRef/#BoundedContextRef/#SubdomainRef/#GlossaryTermRef em vez de regexes duplicadas (findings 4/5 do review isolado).",
		"P10 — gates determinísticos validam os elos; a narrativa (estocástica, humana) recomenda; nenhum gate julga a QUALIDADE da story, só a existência do que ela referencia.",
		"adr-097 — os 8 checks nascem warn (catraca); promoção a reject é decisão junto da 1ª story real.",
		"adr-062 — os dois deferimentos conscientes (termo cross-BC; re-autoria do stakeholder-map) são defs com trigger, não prosa.",
		"adr-054 — PG via authoring-subagent per rollout; draft é proposta, founder é gate final.",
	]

	supersedes: []

	rationale: """
		A forma mínima com refs tipadas foi escolhida contra o Brandolini
		completo do WI-113 porque o valor imediato da story é ANCORAR a teia
		(ator↔BC↔modelo) e testar cobertura — não reproduzir EventStorming em
		CUE; os elementos excluídos permanecem expressáveis via refs e a
		falsificationCondition vigia se o corte foi excessivo. O par com o
		adr-169 mantém as refs limpas (P0) com mordida por-BC-do-passo. A
		ordem-pela-posição (sem campo order) elimina a ambiguidade de dupla
		autoridade apontada no review. WI-113 executa parcial e declarado —
		errar para o lado de registrar (CLAUDE.md), não de fingir completude.
		"""
}
