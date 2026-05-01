package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-model.cue — Production guide para Domain Model (DDD tactical design).
//
// PARTIAL — commit 1 da sequência (scaffold).
// _schema, _qualityCriteria e prerequisites substantivos.
// workOrder, sections e finalValidation com placeholders TBD a serem
// substituídos em commits 2 e 3.
//
// Schema alvo: #DomainModel (architecture/artifact-schemas/domain-model.cue).
// Escopo: cada domain model formaliza building blocks DDD de um BC.
// Phase 2 da regra universal de adr-053. Cascade ordering: este PG é
// pré-condição para criar instâncias de #DomainModel (per adr-054
// decision item 13).

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

	workOrder: ["tbd"]

	sections: {
		"tbd": {
			target:    "#DomainModel"
			objective: "TBD — section substantiva em commit 2 da sequência."
			process: [{
				action: "TBD substituído em commit 2 da sequência"
				detail: "Placeholder mínimo satisfazendo schema MinRunes(10)."
			}]
			doneCriteria: "TBD — substituído em commit 2 da sequência."
		}
	}

	finalValidation: {
		steps: [
			"TBD — finalValidation substantiva em commit 3 da sequência.",
		]
	}
}
