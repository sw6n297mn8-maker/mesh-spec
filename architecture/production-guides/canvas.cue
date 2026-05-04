package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// canvas.cue — Production guide para Bounded Context Canvas.
//
// Schema alvo: #Canvas (architecture/artifact-schemas/canvas.cue).
// Escopo: cada canvas governa um único bounded context.
// Materializado por cascade-ordering requirement de adr-053/adr-054
// (instância de #Canvas em contexts/<bc>/canvas.cue exige PG canvas
// pré-existente). Authoring manual após dispatch subagent timeout
// (per adr-074 fallbackPolicy).

canvasGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/canvas\\.cue$"
			fileNameRegex:      "^canvas\\.cue$"
			description:        "Production guide para autoria de Bounded Context Canvas em mesh-spec."
			rationale:          "Canvas é o documento raiz de identidade de cada BC; guide explicita process, gapPolicy e heuristics que o schema #Canvas sozinho não documenta. Materializado por cascade-ordering requirement de adr-053/adr-054."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-cv-01"
			description: "Guide produz instância cuja classification é coerente com strategic/subdomains/<code>.cue type"
			test:        "Process da section strategic-classification declara cross-file check: subdomainType em canvas.classification deve coincidir com type em subdomain registry. Heuristics reforça check antes de submission."
			severity:    "fail"
			rationale:   "Drift entre canvas e subdomain registry quebra invariante de SoT singular para classificação subdominal — fontes concorrentes com divergências silenciosas."
		}, {
			id:          "tq-cv-02"
			description: "Guide exige integration contracts cross-checked com strategic/context-map.cue"
			test:        "Process da section communication declara cross-check de cada inbound event consumer + outbound event publisher contra context-map. Heuristics declara que relations não-formalizadas ficam em openQuestions, não em communication."
			severity:    "fail"
			rationale:   "Canvas com relations não-formalizadas no context-map cria drift estrutural. Pattern observado em failed dispatch: subagent declarou bdg→cmt sem CMT canvas listar bdg como consumer."
		}, {
			id:          "tq-cv-03"
			description: "Guide produz instância com ≥3 stakeholders concretos e ≥1 incentiveAnalysis adversarial vector"
			test:        "Process da section stakeholders-incentives-and-costs exige ≥3 stakeholders (impactDescription concreto), ≥1 incentive vector com manipulationVector + manipulationCost + designResponse. Heuristics rejeita stakeholders genéricos."
			severity:    "fail"
			rationale:   "Canvas sem stakeholders concretos é abstração; sem incentive vectors é design ingênuo. Mesh é AI-operated — incentive analysis explícita é defesa cross-BC."
		}, {
			id:          "tq-cv-04"
			description: "Guide eleva businessDecisions a ≥2 invariants core declarados"
			test:        "Process da section business-decisions exige ≥2 invariants (decision + rationale + consequences). Heuristics rejeita decisões instrumentais."
			severity:    "fail"
			rationale:   "businessDecisions codifica invariants. < 2 sugere BC sem identidade ou design por imitation. Golden examples têm 4+ businessDecisions."
		}]
		rationale: "4 critérios cobrem disciplinas centrais: alignment com subdomain registry (tq-cv-01), no fabricated integration relations (tq-cv-02), grounded design via stakeholders + incentives (tq-cv-03), invariants substantivos (tq-cv-04). Hardens warn→fail onde fabricação por agente é risco crítico — pattern observado em failed canvas dispatch."
	}

	prerequisites: {
		description: "Antes de criar canvas para um BC, agente lê schema + 3 golden examples (cmt + idc + npm) + subdomain alvo em strategic/subdomains/ + slice relevante de strategic/context-map.cue + capabilities/costs em domain/domain-definition.cue. Confirma com founder os 7 itens substantivos antes de iniciar authoring."
		collectFromFounder: [
			"BC alvo: code (regex ^[a-z][a-z0-9-]*$), name completo, path do subdomain alvo em strategic/subdomains/<code>.cue (deve existir e estar completo)",
			"Classification: subdomainType (core/supporting/generic) coerente com type em strategic/subdomains/<code>.cue + businessRole + wardleyEvolution",
			"VerticalApplicability: mode (vertical-agnostic/vertical-adaptable/vertical-specific) + rationale",
			"DomainRoles: primary archetype + secondary archetypes",
			"Integration shape: inbound commands + outbound events + query surfaces, com refs verificados em strategic/context-map.cue (relations não-formalizadas viram openQuestions)",
			"BusinessDecisions iniciais: ≥2 invariants core (não decisões instrumentais)",
			"CostsEliminated refs do domain-definition (para core/supporting BCs; generic pode omitir per schema)",
		]
		gapPolicy:     "Se subdomain alvo (strategic/subdomains/<code>.cue) não existe ou está incompleto, NÃO crie o canvas — postergue até subdomain estar completo. Se context-map não declara integration relation que canvas pretende usar, NÃO invente — registre em openQuestions com flag 'pendente formalização no context-map'. NÃO copie classification de outro BC sem verificar coerência com subdomain alvo. NÃO atribua costsEliminated refs sem leitura do domain-definition. NÃO declare stakeholders sem impactDescription concreto. NÃO invente businessDecisions por imitation — invariants emergem do purpose declarado, não de catálogo cross-BC. Quando founder não souber definir purpose com precisão suficiente para guiar restante, OMITA authoring até purpose estar claro — canvas vago é pior que ausência."
		validatorNote: "Em Phase 0/1, founder review section-by-section per manualAuthoringProtocol (adr-057) é obrigatório. Section gates impedem authoring batch sem confirmação. Quando file-pair-coverage estiver operacional (adr-053 dec 7) e structural-checks de canvas existirem, tq-cv-XX automatizam-se."
		outputNote:    "Output é arquivo único contexts/<code>/canvas.cue conformante a #Canvas. Tamanho típico: 250-450 linhas para core/supporting BCs (denso por construção — schema tem ~25 top-level fields). Generic BCs podem ser menores (200-300 linhas) com costsEliminated omitido."
	}

	workOrder: [
		"identity-and-purpose",
		"strategic-classification",
		"domain-roles-and-capabilities",
		"communication",
		"business-decisions",
		"stakeholders-incentives-and-costs",
		"ownership-and-governance",
		"epistemic-and-validation",
	]

	sections: {
		"identity-and-purpose": {
			target:    "#Canvas"
			objective: "Estabelecer identidade canônica do BC: code (alinhado ao diretório), name, purpose (justificativa do contorno), ubiquitousLanguageRef (ponteiro para glossary)."
			process: [{
				action: "Verificar code alinhamento com diretório"
				detail: "code ∈ contexts/<code>/. Schema regex '^[a-z][a-z0-9-]*$'. Checar que diretório existe ou será criado no mesmo commit."
			}, {
				action: "Compor purpose como justificativa de contorno"
				detail: "Purpose responde 'POR QUE este contexto existe como unidade SEPARADA' — não 'o que ele faz'. Articular qual responsabilidade é EXCLUSIVAMENTE deste BC e o que aconteceria se BC não existisse. Pattern: golden examples têm purpose 200-400 runes, citam BC adjacents para mostrar contorno."
			}, {
				action: "Declarar ubiquitousLanguageRef"
				detail: "Path canônico contexts/<code>/glossary.cue. Forward reference aceitável: glossary pode não existir ainda no primeiro authoring (será autorado em fase 2 do WI bootstrap)."
			}]
			heuristics: [
				"Purpose deve citar BC adjacents pelo nome (3-letter code) para mostrar contorno; canvas isolado é abstração.",
				"Code é case-sensitive lowercase; respeite convenção de 3 letras (cmt, idc, npm).",
				"ubiquitousLanguageRef é forward reference no primeiro authoring; structural-check valida existência quando glossary for autorado.",
			]
			doneCriteria: "code conforma ao regex e coincide com diretório. name completo. purpose tem ≥150 runes E justifica contorno (não apenas descreve atividade). ubiquitousLanguageRef declarado no path canônico."
			ifGap:        "Se purpose vago (não justifica contorno), pergunte 'qual responsabilidade é exclusivamente deste BC?' antes de prosseguir. Se founder não tem resposta precisa, postergue."
		}

		"strategic-classification": {
			target:    "#Canvas"
			objective: "Posicionar BC no landscape estratégico: classification (subdomainType + businessRole + wardleyEvolution + rationale) + verticalApplicability."
			process: [{
				action: "Cross-check subdomainType com strategic/subdomains/<code>.cue"
				detail: "subdomainType em canvas (core/supporting/generic) deve coincidir EXATAMENTE com 'type' em strategic/subdomains/<code>.cue. Drift indica classification flutuante — corrigir um dos dois antes de prosseguir."
			}, {
				action: "Compor businessRole + wardleyEvolution"
				detail: "businessRole captura papel funcional (compliance-enforcer, gateway-onboarding, ledger-of-record, advisor, etc.). wardleyEvolution: genesis/custom/product/commodity — reflete maturidade do problema."
			}, {
				action: "Declarar verticalApplicability"
				detail: "Mode + rationale. Vertical-agnostic: padrões universais. Vertical-adaptable: primitivas universais com vocabulary adaptável. Vertical-specific: anchored em construção civil ou outra vertical."
			}]
			heuristics: [
				"subdomainType + type em subdomain registry compartilham SoT — drift é design churn não-resolvido.",
				"wardleyEvolution captura percepção do estágio atual; revisitável.",
				"verticalApplicability é dimensão ortogonal a subdomainType; supporting pode ser vertical-agnostic (BDG) ou vertical-adaptable.",
			]
			doneCriteria: "classification.subdomainType coincide com type em strategic/subdomains/<code>.cue (verificado). businessRole + wardleyEvolution declarados com rationale (≥80 runes). verticalApplicability mode + rationale presentes."
			ifGap:        "Se subdomain registry e canvas divergem em subdomainType, PARE — corrija uma das fontes (subdomain registry geralmente prevalece). Se businessRole vago, pergunte ao founder."
		}

		"domain-roles-and-capabilities": {
			target:    "#Canvas"
			objective: "Articular o que o BC FAZ: domainRoles (primary + secondary archetypes) + capabilities (operational list + sync/async surface flags)."
			process: [{
				action: "Compor domainRoles primary + secondary"
				detail: "Primary é papel CENTRAL; secondary captura capabilities ortogonais. Catalog: gateway, orchestrator, ledger, advisor, execution, etc. BCs que GATEKEEPING flow têm primary=gateway."
			}, {
				action: "Declarar capabilities operational com refs ao domain-definition"
				detail: "Cada capability declara capabilityRef (cc-XX no catalog) OU description-only (capability local). Heurística: se capability local recorrer cross-BC, propor adição ao catalog em ADR separado."
			}, {
				action: "Setar capability surface flags"
				detail: "hasSyncSurface (true se BC expõe query síncrono ou command sync) + hasAsyncSurface (true se publica/consome events). Schema enforça completude condicional baseada em flags."
			}]
			heuristics: [
				"Primary archetype reflete papel CENTRAL — BC com 2 archetypes equally weighted é scope mal delimitado (provavelmente 2 BCs sincretizados).",
				"capabilityRef aponta para cc-XX no domain-definition; capability local sem ref é OK mas se recorrer 2+ vezes cross-BC, deveria virar cc-XX (proposta em ADR).",
				"surface flags são source of truth para structural-check — flag falsa bloqueia validation correta.",
				"Per tq-mg-07 impact classification (META-PG): capabilities/commands podem declarar impact ortogonal a category (read-only/state-change/cross-bc/external-side-effect) — registrar em rationale quando relevante.",
			]
			doneCriteria: "domainRoles.primary + ≥1 secondary. capabilities operational ≥3 entries. hasSyncSurface + hasAsyncSurface declarados (não default)."
			ifGap:        "Se BC tem capabilities cross-cutting com vários BCs, valide se BC não absorve responsibilities de outros (drift para BC Deus). Se primary archetype não está claro, pergunte."
		}

		"communication": {
			target:    "#Canvas"
			objective: "Articular integration shape: inbound (commands + event consumers + query surfaces) + outbound (event publishers + query dependencies). TODA relation cross-checked com strategic/context-map.cue."
			process: [{
				action: "Cross-check cada inbound consumer + outbound publisher com strategic/context-map.cue"
				detail: "Para CADA event consumer/publisher proposto, verificar relation existe em context-map. Relations não-formalizadas viram openQuestions com flag 'pendente formalização' — NÃO declaradas como factual."
			}, {
				action: "Declarar inbound commands"
				detail: "Cada command tem type, interactionMode (sync/async), trigger, command name, resultingEvents (lista plural)."
			}, {
				action: "Declarar inbound event consumers"
				detail: "Cada event-consumer tem sourceContext (BC code), event name, reaction, description."
			}, {
				action: "Declarar query surfaces inbound"
				detail: "Cada query-surface tem query name, returnType, description. Habilita upstream consumers a consultar SoT do BC."
			}, {
				action: "Declarar outbound event publishers"
				detail: "Cada event-publisher tem trigger, event name, consumers (lista de BCs), description. Consumers list cross-checked com context-map."
			}]
			heuristics: [
				"Pattern observado: inbound 4-8 entries, outbound 2-5 entries. Outbound > 5 sugere drift para hub não-intencional.",
				"Events que GATEKEEPING flow downstream usam interactionMode sync no consumer side OR são modelados como hard-dependency em context-map.",
				"Query surface NÃO substitui event-consumer — query é pull, event é push; design choice por tipo de relação (lookup vs reaction).",
				"Per tq-mg-09 decide-vs-execute separation: commands com decisão + execução irreversível devem split em decide-X / execute-X com human gate entre.",
			]
			doneCriteria: "inbound.commands ≥1 OR rationale explícita de event/query-only interface. inbound.event-consumers respeitando sources declarados em canvases adjacentes. outbound.event-publishers ≥1. TODAS relations cross-checked. Relations não-formalizadas estão em openQuestions, NÃO em communication."
			ifGap:        "Se context-map não declara relation que canvas precisa, registre openQuestion com 'oq-<code>-N' format E flag de relation pendente. NÃO declare como factual. Se BC propõe consumer cross-BC que outro BC não lista como source: drift cross-context — escalar."
		}

		"business-decisions": {
			target:    "#Canvas"
			objective: "Codificar invariants core como businessDecisions: cada decision tem id (verb-noun), decision (statement), rationale, consequences."
			process: [{
				action: "Identificar ≥2 invariants core a partir do purpose"
				detail: "Invariants emergem da purpose statement — perguntar 'que regra DEVE ser sempre verdade neste BC?'. BCs core têm 4-6 invariants; supporting têm 2-4."
			}, {
				action: "Compor cada decision como statement + rationale + consequences"
				detail: "Decision é declaração afirmativa (não 'avaliar X'; 'X é Y'). Rationale articula POR QUE invariant existe. Consequences articula o que MUDA no design por respeitar invariant."
			}]
			heuristics: [
				"ID pattern: verb-noun em kebab-case (bd-coverage-as-invariant, bd-allocation-not-treasury). Verbs canônicos: as, not, requires, separates, reserves.",
				"Decisão sem 'consequences' é contemplação abstrata. Force consequences ANTES de aceitar.",
				"Invariant que apenas restate purpose é redundante — businessDecision adiciona SUBSTÂNCIA (constraint, separation, ordering).",
				"Per tq-mg-06 derived→source ref: businessDecisions que derivam de domain principles devem ref-explicitar a origem (e.g., derivedFromAxiom: 'ax-XYZ').",
			]
			doneCriteria: "≥2 businessDecisions. Cada com id (regex bd-*), decision (≥80 runes assertivo), rationale (≥80 runes), consequences (≥60 runes operacional)."
			ifGap:        "Se < 2 invariants emergem, BC não tem identity própria — pergunte ao founder qual diferencia este BC. Sem invariants substantivos, postergue."
		}

		"stakeholders-incentives-and-costs": {
			target:    "#Canvas"
			objective: "Aterrar BC em atores concretos: stakeholders (≥3 com impactDescription concreto) + incentiveAnalysis (≥1 adversarial vector) + costsEliminated (refs ao domain-definition para core/supporting)."
			process: [{
				action: "Declarar ≥3 stakeholders com impactDescription concreto"
				detail: "Cada stakeholder tem stakeholderRef (sh-XX), roleInContext (papel SPECÍFICO), impactDescription (impacto CONCRETO — não 'beneficia genericamente'), rationale."
			}, {
				action: "Compor incentiveAnalysis com ≥1 adversarial vector"
				detail: "Cada participant tem stakeholderRef + participantType + desiredBehavior + correctOperationIncentive + manipulationVector + manipulationCost + vsBenefit + designResponse + rationale. Pelo menos 1 adversarial vector."
			}, {
				action: "Declarar costsEliminated com refs ao domain-definition"
				detail: "Para core/supporting BCs, declare ≥1 ce-XX ref + contribution. Generic BCs podem omitir per schema."
			}]
			heuristics: [
				"Stakeholders sem impactDescription concreto são DECORATIVE — schema-validação passa, design fica vazio. Force exemplos específicos.",
				"incentiveAnalysis sem adversarial vectors é design ingênuo. Mesh é AI-operated — misalignment by agent é vector default.",
				"Detectar coalizões cross-stakeholder (proponente-aprovador, etc.) requer monitoring + gates determinísticos. Patterns sub-threshold compartilhados cross-BC ficam em openQuestions com cross-ref.",
			]
			doneCriteria: "≥3 stakeholders com sh-XX refs + impactDescription concreto. incentiveAnalysis com ≥1 participant adversarial vector cobrindo manipulationVector + manipulationCost + designResponse. costsEliminated ≥1 ref para core/supporting (omitido para generic com flag)."
			ifGap:        "Se stakeholders são 'todos' (genérico), pergunte 'quem PERDE se BC opera mal?'. Se incentive vectors ausentes, force authoring de pelo menos 1 vector explícito."
		}

		"ownership-and-governance": {
			target:    "#Canvas"
			objective: "Configurar agente operador + boundaries de autonomia: ownership.domainAgentSpec (path canônico) + governanceScope (autonomousDecisions + supervisedDecisions + escalationCriteria)."
			process: [{
				action: "Declarar ownership.domainAgentSpec por path canônico"
				detail: "Path: contexts/<code>/agents/<code>-primary-agent.cue. Forward reference aceitável (agent-spec ainda não autorado na primeira fase do BC bootstrap)."
			}, {
				action: "Compor governanceScope.autonomousDecisions"
				detail: "Decisões que agente toma SEM founder confirmation. Cada decision tem id (verb-noun), description, rationale. Heurística: autonomous = puramente determinística."
			}, {
				action: "Compor governanceScope.supervisedDecisions"
				detail: "Decisões que EXIGEM founder/supervisor confirmation. Heurística: supervised = qualquer decisão com julgamento (override, ambiguidade, ajuste de policy)."
			}, {
				action: "Compor governanceScope.escalationCriteria"
				detail: "Condições que disparam escalação automática. Cada criterion tem id, condition (machine-evaluable), action, rationale."
			}]
			heuristics: [
				"Decisão autonomous deve ser TRULY determinística — se requer julgamento, é supervisedDecision.",
				"Override de policy NUNCA é autonomous — sempre supervised, nominalmente atribuído ao supervisor.",
				"escalationCriteria condition deve ser machine-evaluable; descritivo vago não é critério.",
				"Per tq-mg-08 default+override granularity: governanceScope tem default autonomous; override (supervised) é exceção, não regra. Articular QUANDO override aplica.",
				"Calibragem por complexidade: BCs simples podem ter ≥1 autonomous + ≥1 supervised genuinamente substantivos; forçar números maiores fabrica decisões fracas.",
			]
			doneCriteria: "ownership.domainAgentSpec path canônico declarado. ≥1 autonomousDecision, ≥1 supervisedDecision, ≥3 escalationCriteria. Cada com id (verb-noun) + description + rationale (todos ≥40 runes)."
			ifGap:        "Se autonomous ou supervised vazios, BC tem governance scope incompleto — pergunte ao founder. Se < 3 escalation criteria, escalation é implícito — codifique 3 conditions concretas."
		}

		"epistemic-and-validation": {
			target:    "#Canvas"
			objective: "Capturar estado epistêmico (assumptions + openQuestions + verificationMetrics) + compor rationale root-level + executar validation final."
			process: [{
				action: "Declarar assumptions com invalidationSignal"
				detail: "Cada assumption tem id (as-<code>-N), assumption, invalidationSignal (machine-evaluable ou observable), rationale. Heurística: assumption sem invalidationSignal é fé não-falsificável."
			}, {
				action: "Declarar openQuestions com deadlines"
				detail: "Cada question tem id (oq-<code>-N), question, impact, deadline (data ISO), rationale. Cross-references entre BCs (oq compartilhada) são bem-vindas."
			}, {
				action: "Declarar verificationMetrics com targets"
				detail: "Cada metric tem id, metric (descrição), target (threshold concreto quantificado), rationale."
			}, {
				action: "Compor rationale root-level como SÍNTESE"
				detail: "Rationale recapitula identity + classification + key invariants + governance scope. Não é repetição — é síntese que permite leitura standalone do canvas."
			}, {
				action: "Validation final: cue vet + verificar cross-file invariants + canonical removal test"
				detail: "Rodar cue vet local. Verificar tq-cv-XX critérios. Verificar tq-mg-10 canonical removal: 'se removermos este BC, invariants críticos permanecem protegidos por outros enforcers?' — resposta NÃO é esperada (BC é dono canônico). Submeter ao founder para approval explícito."
			}]
			heuristics: [
				"Assumption sem invalidationSignal é fé — force articulação do sinal mensurável.",
				"openQuestion deadline é compromisso público — escolha datas concretas (ano-mês-dia), não 'eventually'.",
				"verificationMetric target é threshold concreto — quantificado ou observable; 'qualidade boa' não é métrica.",
				"rationale root-level é último step — preencher SOMENTE depois de outras sections completas; sintetizar, não inventar.",
				"Per tq-mg-10 canonical removal test: se remover BC, invariants críticos permanecem protegidos por outros enforcers? Resposta esperada NÃO — BC é dono canônico de seus invariants.",
			]
			doneCriteria: "≥3 assumptions com invalidationSignals. ≥3 openQuestions com deadlines ISO. ≥3 verificationMetrics com targets quantificados. rationale root-level ≥500 runes sintetizando identity + invariants + governance. cue vet passa. founder approval explícito antes de commit."
			ifGap:        "Se assumptions são poucas, BC pode estar over-confident — force ≥3. Se openQuestions são vazias, BC pretende certeza que não tem — invente honestamente as áreas de incerteza."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância válida contra #Canvas (todos campos obrigatórios + capability flag-driven completude condicional).",
			"Verificar tq-cv-01: classification.subdomainType coincide com type em strategic/subdomains/<code>.cue (cross-file consistency).",
			"Verificar tq-cv-02: TODA inbound event-consumer + outbound event-publisher tem relation correspondente em strategic/context-map.cue, OU está em openQuestions com flag 'pendente formalização'.",
			"Verificar tq-cv-03: ≥3 stakeholders com sh-XX refs E ≥1 incentiveAnalysis vector com manipulationCost + designResponse.",
			"Verificar tq-cv-04: ≥2 businessDecisions com id (verb-noun) + decision + rationale + consequences.",
			"Verificar coerência semântica: businessDecisions emergem do purpose; capabilities respeitam contorno (não invadem adjacents); governanceScope.supervisedDecisions cobrem decisões com julgamento.",
			"Verificar canonical removal test (tq-mg-10): se removermos o BC, invariants críticos permanecem protegidos por outros enforcers? Resposta esperada NÃO — BC é dono canônico.",
			"Verificar cross-context drift: BC propõe consumer cross-BC que outro BC não lista como source? Drift bloqueia commit até resolução.",
			"Submeter ao founder para aprovação explícita antes de commit — step próprio bloqueante per adr-057 founderConfirmation (NÃO absorvido na inspeção de critérios precedentes).",
		]
	}
}
