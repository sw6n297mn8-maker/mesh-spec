package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-model.cue — Production guide para Domain Model (DDD tactical design).
//
// Schema alvo: #DomainModel (architecture/artifact-schemas/domain-model.cue).
// Escopo: cada domain model formaliza building blocks DDD de um BC.
// Phase 2 da regra universal de adr-053. Cascade ordering: este PG é
// pré-condição para criar instâncias de #DomainModel (per adr-054
// decision item 13).
//
// Versão produzida via 3 ciclos red team em sessão 2026-05-01 +
// 5 correções founder (tq-dmg-04 substring→observável; cue vet
// ordering; commands não derivam causalmente de events; anti-events-
// técnicos heurística; aggregate não é módulo funcional). Authoring
// manual Phase 0 de adr-054 (pre-WI-069). Materializado em 3 commits
// sequenciais (scaffold → sections → finalValidation).

domainModelGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/domain-model\\.cue$"
			fileNameRegex:      "^domain-model\\.cue$"
			description:        "Production guide para autoria de Domain Model (DDD tactical) por bounded context em mesh-spec."
			rationale:          "Domain model formaliza building blocks DDD (events, commands, invariants, aggregates, value objects, policies, projections, services); guide explicita process, gapPolicy e heuristics que o schema #DomainModel sozinho não documenta. Phase 2 da regra universal de adr-053."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-dmg-01"
			description: "Guide produz instância com integridade referencial catalog↔aggregates"
			test:        "Process inclui passo explícito de verificar: cada commands[].code em exactly 1 aggregates[].handlesCommands[]; cada events[].code em ≥1 aggregates[].emitsEvents[]; cada invariants[].code em ≥1 aggregates[].protectsInvariants[]. Cobre tq-dm-01/02/03 (todos fail) do schema. Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "Integridade referencial entre catalog e aggregates é a falha #1 em domain-models — command órfão é fato sem causa, invariant não-protegida é regra sem enforcement."
		}, {
			id:          "tq-dmg-02"
			description: "Guide enforça behavior-first ordering"
			test:        "Process da section context-and-behavior-first-catalog declara explicitamente ordem events → commands → invariants → value-objects → aggregates como atividade autoral. Heuristics da section reforça que events emergem de canvas; commands derivam de events. Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "Behavior-first é princípio Mesh per schema header (Event Log é SoT, P3). Ordem inversa (aggregates first) tende a produzir aggregates artificiais sem origem em eventos do domínio."
		}, {
			id:          "tq-dmg-03"
			description: "Guide produz lifecycle válido com state references consistentes"
			test:        "Process da section aggregates-and-wiring declara: aggregate com lifecycle exige states[] explícitos; cada transition.from/to existe em states[]; initialState existe; cada transition.triggeredByCommand/emitsEvents/guards existem em catálogos. Cobre tq-dm-07/08 (fail) do schema."
			severity:    "fail"
			rationale:   "Lifecycle com state references quebradas é state machine inválida — agente que consome o domain-model produz código com transições impossíveis."
		}, {
			id:          "tq-dmg-04"
			description: "Guide promove glossary alignment"
			test:        "Heuristics da section context-and-behavior-first-catalog exige que event/command/aggregate names sejam reconciliados com terms canônicos do glossary do BC quando glossary existir; divergências devem ser registradas como tension entry ou propostas como upstream glossary/canvas update. Verificado por inspeção."
			severity:    "warn"
			rationale:   "Domain-model e glossary são 2 SoTs do BC — terminologia divergente cria drift entre UL (glossary) e código (derivado de domain-model)."
		}]
		rationale: "4 critérios cobrem disciplinas core para autoria de domain-model: integridade referencial catalog↔aggregates (tq-dmg-01), behavior-first ordering (tq-dmg-02), lifecycle válido (tq-dmg-03), glossary alignment (tq-dmg-04). Scope é disciplinas que protocol enforce via process; cobertura completa dos 13+ tq-dm-XX vive em finalValidation.steps."
	}

	prerequisites: {
		description: "Antes de criar domain-model para um BC, agente lê canvas (estável) + glossary (recomendado) + lens-domain-model-design (se existir), aplica behavior-first ordering, e confirma escopo com founder."
		collectFromFounder: [
			"Confirmação do BC alvo (code de 3 letras) e que canvas existe e está estável (não em flux ativo)",
			"Confirmação se glossary do BC existe (recomendado mas não obrigatório — domain-model pode preceder glossary em casos onde domain emerge primeiro)",
			"Quaisquer constraints de fase (ex.: 'em Phase 0 deste BC, modelar apenas aggregates principais; sagas/process managers em fase posterior')",
			"Heurísticas tácitas que founder usa para distinguir aggregate de entity, value-object de domain-type, etc.",
		]
		gapPolicy:     "Se canvas do BC não estável, NÃO crie domain-model — postergue até canvas convergir. Se glossary não existir, prosseguir mas com caveat: terminologia em events/commands/aggregates pode requerer reconciliação quando glossary for criado (tq-dmg-04 warn). NÃO invente events/commands sem origem em canvas (canvas businessDecisions, communication, capabilities). NÃO copie domain-model de outro BC sem verificar que building blocks são genuinamente os mesmos — homônimos com significado diferente são esperados. Cascade ordering (per CLAUDE.md): domain-model PG é pré-condição para instâncias de #DomainModel; agente verifica este PG existe antes de instanciar. Quando founder não souber distinguir aggregate de entity, ou quando lifecycle não estiver claro: OMITIR (não criar lifecycle) ao invés de inventar — domain-model com lifecycle especulativo é pior que sem lifecycle."
		validatorNote: "Em Phase 0, founder review é obrigatório. Em Phase 1+ (após WI-069), authoring pode usar dispatch declarativo per authoring-policy.cue rollout production-guide. Quando structural-checks de domain-model existirem (post-WI-068), tq-dm-01/02/03/05/06/07/08/09/10/13 automatizam-se intra-domain-model; tq-dm-04/11/12 dependem de runner cross-file."
		outputNote:    "Output é arquivo único contexts/{bc}/domain-model.cue conformante a #DomainModel. Tamanho típico: 440-650 linhas (per cmt 647, ctr 551, npm 443). Domain-model inicial pode focar em 2-4 aggregates centrais e crescer incrementalmente; sagas/process managers e projections são opcionais e podem entrar em sessões posteriores."
	}

	workOrder: [
		"context-and-behavior-first-catalog",
		"aggregates-and-wiring",
		"cross-aggregate-and-validation",
	]

	sections: {
		"context-and-behavior-first-catalog": {
			target:    "#DomainModel"
			objective: "Estabelecer BC alvo, ler canvas + glossary + lens (se existir), e popular catálogos top-level (events, commands, invariants, value-objects) em ordem behavior-first antes de modelar aggregates."
			process: [{
				action: "Localizar canvas + glossary do BC alvo"
				detail: "Verificar contexts/{bc}/canvas.cue existe e canvas.code está estável. Verificar contexts/{bc}/glossary.cue (recomendado). canvas.code determina boundedContextRef e domainModel.code (alinhamento por construção)."
			}, {
				action: "Identificar events emergentes do canvas"
				detail: "Events vêm de: (a) canvas.communication.outbound[] type='event-publisher' (events publicados externamente — visibility 'published'); (b) canvas.communication.inbound[] resultingEvents (events resultantes de commands handled); (c) canvas.businessDecisions que descrevem fatos. NÃO inventar events sem origem em canvas."
			}, {
				action: "Identificar commands derivados de intenções de mudança de estado"
				detail: "Commands são identificados por intenções de mudança de estado: (a) canvas.communication.inbound[] type='command-handler' command names; (b) commands internos que policies emitirão para reagir a events. Para cada event identificado, perguntar qual command/intenção normalmente o produz. Behavior-first ordering começa por events porque são fatos observáveis no canvas, não porque commands derivam de events causalmente — events são consequências, commands são causas."
			}, {
				action: "Identificar invariants protegidos"
				detail: "Invariants vêm de: (a) canvas.businessDecisions com 'NÃO' (proibições explícitas); (b) regras implícitas em canvas.purpose/capabilities (ex.: 'autorização exige identidade verificada' → invariant); (c) constraints regulatórios mencionados em canvas.stakeholders (regulator)."
			}, {
				action: "Catalog value-objects emergentes de event/command payloads"
				detail: "Value-objects são tipos imutáveis sem identidade que aparecem em event/command structures (ex.: Money, CNPJ, Score). Catalog top-level se reusados entre múltiplos aggregates; nested em aggregate se exclusivos. Per schema, value-objects são opcionais."
			}, {
				action: "Confirmar catalog inicial com founder"
				detail: "Apresentar catalog: lista de events/commands/invariants/value-objects nomeados + 1-line de cada. Founder filtra: quais são genuínos do domínio, quais são técnicos (não-domain), quais são duplicatas. Compor catalog confirmado antes de section 2."
			}]
			sources: [
				"architecture/artifact-schemas/domain-model.cue (schema #DomainModel + 13+ tq-dm-XX)",
				"architecture/production-guides/glossary.cue (production-guide irmão; glossary precede domain-model em phasing)",
				"contexts/cmt/domain-model.cue (exemplo completo, 647 linhas)",
				"contexts/ctr/domain-model.cue (exemplo, 551 linhas)",
				"architecture/design-principles.cue (P3 — Event Log SoT; behavior-first ordering)",
			]
			heuristics: [
				"Behavior-first: events → commands → invariants → value-objects → aggregates. Inverter ordem produz aggregates artificiais.",
				"Events emergem do canvas; não inventar events ausentes do canvas (mesma regra que glossary terms).",
				"Events representam fatos de domínio, não acontecimentos técnicos de infraestrutura — evitar RequestReceived, RecordSaved, ValidationExecuted salvo se forem conceitos de domínio auditáveis no BC.",
				"Glossary alignment: terminologia em event/command names alinha com terms canônicos do glossary do BC quando glossary existir.",
				"Visibility em events: 'published' = aparece em canvas outbound event-publishers (cross-BC contract); 'internal' = audit trail / domain-internal.",
				"sourceContext em events marca traduções ACL de sinais externos (referenciar BC origem).",
				"Catalog cresce incrementalmente: começar com 5-10 events centrais; adicionar conforme aggregates revelam novas interações.",
			]
			doneCriteria: "BC identificado com canvas estável; glossary do BC consultado se existir; events identificados de origem clara no canvas; commands derivados; invariants enumerados; value-objects catalog (opcional); founder confirmou catalog."
			ifGap:        "Se canvas em flux ativo, postergar (domain-model precede stability do canvas é receita para retrabalho). Se events não emergem do canvas (canvas é puramente abstrato), pedir founder esclarecimento — domain-model sem origem em canvas é fabricação."
		}

		"aggregates-and-wiring": {
			target:    "#Aggregate"
			objective: "Definir aggregates como consistency boundaries que conectam catalog (events, commands, invariants, value-objects). Aggregate é a wiring layer: declara o que handla, emite, protege, usa."
			process: [{
				action: "Agrupar commands por consistency boundary"
				detail: "Cada command é handled por exactly UM aggregate (tq-dm-01 fail). Pergunta-chave: 'quais commands compartilham state que muda atomicamente?' → mesmo aggregate. Tipicamente 3-7 commands por aggregate. Aggregate com 1 command isolado é candidato a merge; aggregate com 15+ commands é candidato a split."
			}, {
				action: "Para cada aggregate definir handlesCommands, emitsEvents, protectsInvariants, usesValueObjects"
				detail: "handlesCommands: refs (cmd-XX) handled exclusivamente. emitsEvents: refs (evt-XX) (≥1 aggregate emit cada event per tq-dm-02). protectsInvariants: refs (inv-XX) (≥1 aggregate protect cada per tq-dm-03). usesValueObjects: refs (vo-XX) reusados."
			}, {
				action: "Nest entities dentro de aggregates"
				detail: "Entities são owned por exactly um aggregate (ownership) — nested em aggregate.entities[]. Cada entity tem prefix ent-. Distinção entity vs value-object: entity tem identity e lifecycle; value-object é imutável sem identity."
			}, {
				action: "Definir lifecycle quando aggregate tem state machine clara"
				detail: "Lifecycle é state machine com states[] + transitions[]. Cada transition declara: from, to, triggeredByCommand, emitsEvents, guards (todos refs em catálogos existentes). initialState existe em states[]. Cobre tq-dm-07/08 fail. Lifecycle é OPCIONAL — omit se aggregate não tem state machine clara."
			}, {
				action: "Verificar integridade referencial intra-domain-model"
				detail: "tq-dmg-01 / tq-dm-01/02/03: cada commands[] em exactly 1 aggregate; cada events[] em ≥1 aggregate; cada invariants[] em ≥1 aggregate. Conferência manual antes de avançar. Inconsistência aciona fail."
			}]
			sources: [
				"architecture/artifact-schemas/domain-model.cue (#Aggregate, #Entity, #Lifecycle, #Transition sub-types)",
				"contexts/cmt/domain-model.cue (exemplo de aggregates com lifecycle complexo)",
				"contexts/npm/domain-model.cue (exemplo de aggregates simples sem lifecycle)",
			]
			heuristics: [
				"Aggregate é consistency boundary: state que muda atomicamente fica junto.",
				"Aggregate não é pasta funcional nem feature group; é boundary de consistência transacional.",
				"Tipicamente 3-7 commands por aggregate; >15 sugere split; 1 isolado sugere merge ou re-modelar.",
				"Aggregate root é único ponto de entrada de mutation; entities nested são owned exclusivamente.",
				"Entity vs Value-object: entity tem identity (id distinto que persiste com mudança de atributos); value-object é imutável e identidade vem de atributos.",
				"Lifecycle é OPCIONAL — usar apenas quando state machine é clara e estável; lifecycle especulativo é pior que sem lifecycle.",
				"Cada lifecycle.transition referencia cmd/evt/inv existentes — validar refs antes de finalizar (tq-dm-07).",
				"Aggregate names em PascalCase; codes com prefix agg- (ex.: agg-commitment).",
				"Glossary alignment: aggregate name corresponde a term canônico do glossary quando aplicável.",
			]
			doneCriteria: "Cada aggregate tem handlesCommands/emitsEvents/protectsInvariants populados com refs válidas; cada command em exactly 1 aggregate; cada event em ≥1; cada invariant em ≥1; entities nested onde aplicável; lifecycle definido apenas onde state machine é clara."
			ifGap:        "Se 2+ aggregates parecem competir pelo mesmo command, reconsiderar consistency boundary. Se nenhum aggregate naturally handla um command, pode ser misclassified como command vs event/query. Se lifecycle states não emergem claramente, omitir lifecycle."
		}

		"cross-aggregate-and-validation": {
			target:    "#DomainModel"
			objective: "Definir cross-aggregate concerns (domain services, policies, projections, modules) e executar 13+ tq-dm-XX checks intra-domain-model + cross-canvas + cue vet + finalValidation com submissão ao founder."
			process: [{
				action: "Identificar cross-aggregate concerns"
				detail: "Domain services: lógica que coordena 2+ aggregates. Policies: automação event → command com guards. Projections: read models derivados de events. Modules: agrupamento organizacional de aggregates (futura extração para microservices)."
			}, {
				action: "Validar policies/projections refs (tq-dm-05/06)"
				detail: "policies[].triggeredByEvent existe em events[]. policies[].issuesCommand existe em commands[]. policies[].guards existem em invariants[]. projections[].consumesEvents existem em events[]. Quebra aciona fail."
			}, {
				action: "Validar domain services e modules (tq-dm-09/10)"
				detail: "domainServices[].orchestrates existem em aggregates[]. modules[].aggregateRefs existem em aggregates[] e nenhum aggregate em 2+ modules."
			}, {
				action: "Validar cross-canvas alignment (tq-dm-11/12)"
				detail: "events[] visibility='published' têm correspondência em canvas.communication.outbound[] event-publisher (tq-dm-11 fail). commands handled têm correspondência em canvas.communication.inbound[] command-handler quando exposto externamente (tq-dm-12 warn). Em Phase 0, validação por inspeção; runner futuro automatiza."
			}, {
				action: "Validar prefixos e unicidade (tq-dm-13)"
				detail: "Cada code segue prefixo do catálogo (evt-, cmd-, inv-, vo-, agg-, mod-, svc-, pol-, prj-). Entities ent-. Query capabilities qry-. Nenhum code duplicado em qualquer catalog."
			}, {
				action: "Executar cue vet ./contexts/{bc}/ ./architecture/artifact-schemas/"
				detail: "Validação de shape final. Falha aqui bloqueia avanço."
			}, {
				action: "Submeter ao founder para aprovação antes de commit"
				detail: "Apresentar domain-model completo com sumário: BC, número de events/commands/invariants/value-objects/aggregates, lifecycle present/absent, services/policies/projections/modules. Founder aprova antes de write."
			}]
			heuristics: [
				"Domain services para coordenação cross-aggregate; policies para automação event → command simples; ambos opcionais.",
				"Projections são read-only views — nunca emitem events ou alteram state.",
				"Modules são organizacional, não technical: aggregate em modulo X não impede emit events para modulo Y.",
				"tq-dm-04 (vo orphan) é warn — value-object catalog item sem uso é ok durante evolução.",
				"Cross-canvas alignment (tq-dm-11/12) é runner-dependent; em Phase 0 valida por inspeção visual.",
				"cue vet deve ocorrer antes do fechamento final; quando possível, rodar antes e depois dos checks semânticos para detectar shape issues cedo e confirmar correções.",
				"finalValidation.steps[-1] sempre menciona submissão ao founder — sem isso, ciclo propor→aprovar→escrever está quebrado.",
			]
			doneCriteria: "cue vet recursive limpo; tq-dm-01/02/03/05/06/07/08/09/10/13 verificados intra-domain-model; tq-dm-04/11/12 reportados (warn ou cross-file advisory) com nota de cobertura parcial em Phase 0; founder aprovou."
			ifGap:        "Se cue vet falhar, corrigir sintaxe. Se tq-dm-01 falhar (command em 2 aggregates), reconsiderar consistency boundary. Se tq-dm-11 falhar (event published sem canvas counterpart), reconciliar canvas (pode ser canvas obsoleto) ou domain-model (event não deveria ser published)."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #DomainModel (boundedContextRef, events/commands/invariants/aggregates não-vazios, rationale).",
			"Verificar integridade referencial catalog↔aggregates (tq-dm-01/02/03 + tq-dmg-01): cada command em exactly 1 aggregate; cada event em ≥1; cada invariant em ≥1.",
			"Verificar refs de policies/projections/services/modules (tq-dm-05/06/09/10): triggeredByEvent, issuesCommand, guards, consumesEvents, orchestrates, aggregateRefs todos resolvendo; aggregates não em múltiplos modules.",
			"Verificar lifecycle (tq-dm-07/08 + tq-dmg-03): para cada aggregate com lifecycle, transitions referenciam cmd/evt/inv existentes; from/to/initialState existem em states[].",
			"Verificar atomicidade e behavior-first ordering (tq-dmg-02): catalog populado em ordem events→commands→invariants→value-objects antes de aggregates; aggregates wiring derivado, não inventado.",
			"Verificar cross-canvas alignment (tq-dm-11/12): events 'published' têm correspondência em canvas outbound; commands handled têm correspondência em canvas inbound (warn).",
			"Verificar prefixos e unicidade (tq-dm-13): cada code segue prefix do catálogo; nenhum code duplicado.",
			"Verificar value-object usage (tq-dm-04 warn): se valueObjects[] presente, cada vo usado em ≥1 aggregate ou entity.",
			"Verificar glossary alignment (tq-dmg-04 warn): terminologia em event/command/aggregate names alinha com glossary do BC quando glossary existir; divergências registradas como tension ou propostas como upstream update.",
			"Submeter ao founder para aprovação antes de commit.",
		]
	}
}
