package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// agent-spec.cue — Production guide para Agent Spec (operational
// definition de agente DDD-aware em mesh-spec).
//
// Schema alvo: #AgentSpec (architecture/artifact-schemas/agent-spec.cue,
// 465 linhas, 13+ tq-ag-XX). Phase 3 da regra universal de adr-053
// (autorado fora de phasing estrito por necessidade de cascade
// ordering — IDC primary agent é a primeira instância pós-cascade
// per adr-054 decision 13). Authoring manual Phase 0 de adr-054
// (pre-WI-069). Materializado em 3 commits sequenciais (scaffold
// → sections → finalValidation).
//
// Convenção: tq-agg-NN para critérios deste guide. Abreviação "agg"
// declarada na legenda canônica de architecture/artifact-schemas/
// quality-criteria.cue.
//
// Iteração pós-founder review (sessão 2026-05-01): 6 disciplinas
// adicionadas a partir de gaps identificados em revisão estrutural —
// enforcementLevel per constraint (agent/runner/domain/external),
// derivedFromInvariant explicit ref (1:1 default), action impact
// classification (read-only/state-change/cross-bc/external-side-effect),
// per-action escalation override quando criticality diverge do global,
// decision-vs-execution separation (action não mistura decidir +
// executar irreversível), canonical test "se remover o agente, sistema
// ainda protege os invariants?". 6 critérios tq-agg adicionados
// (tq-agg-05..10 todos warn — heuristic-level, não enforced por schema).
//
// Diagnóstico capturado: spec assumia implicitamente agente como
// centro do sistema; Mesh modela DOMÍNIO como centro, AGENTE como
// operador. Endurecer essa hierarquia é o ponto de inflexão para
// sair de "spec bem definido" rumo a "sistema que prova que o spec
// é obedecido". Tq-agg-10 (canonical test) é o gate dessa inversão:
// se remover o agente quebra invariants, agente está segurando regra
// de domínio (bug arquitetural).

agentSpecGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/agent-spec\\.cue$"
			fileNameRegex:      "^agent-spec\\.cue$"
			description:        "Production guide para autoria de Agent Spec (operational definition de agente per BC) em mesh-spec."
			rationale:          "Agent Spec formaliza role + operationalScope + actions + constraints + escalation + observability de agente DDD-aware (#AgentSpec, 13+ tq-ag-XX). Guide explicita process, gapPolicy e heuristics que o schema sozinho não documenta. Phase 3 de adr-053; autorado antecipadamente por exigência de cascade ordering."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-agg-01"
			description: "Guide produz instância com integridade referencial actions↔domain-model"
			test:        "Process da section scope-and-action-catalog declara passo explícito de validar que cada actions[].domainModelRefs.{aggregates,commands,events,invariants,projections} resolve a code existente no domain-model do BC. Cobre tq-ag-01/02/03/04 (todos fail) do schema."
			severity:    "fail"
			rationale:   "Action referenciando aggregate/command/event/invariant/projection inexistente é operação fantasma — agente declara que opera sobre construto que o domain-model não modela."
		}, {
			id:          "tq-agg-02"
			description: "Guide enforça invariant→constraint coverage com exceção declarada"
			test:        "Process da section constraints-and-escalation exige: para cada invariant do domain-model do BC, agent-spec declara constraint correspondente OU rationale explícito de exceção (e.g., enforced via lifecycle do aggregate, fora do escopo do agente). Empirical: cmt 8/8, npm 6/6, ctr 5/7 com gap explicado. Cobre tq-ag-08/09 (fail) do schema."
			severity:    "fail"
			rationale:   "Invariant sem constraint é regra de domínio sem enforcement por agente — gap silencioso entre o que o domínio promete e o que o agente protege."
		}, {
			id:          "tq-agg-03"
			description: "Guide enforça escalation coherence per category"
			test:        "Heuristics da section constraints-and-escalation exige: actions com category='mutation' declaram que escalationConditions inclui as categories 'conflicting-signals' E 'insufficient-context'; queries não exigem (read-only). Cobre tq-ag-10 (fail) do schema."
			severity:    "fail"
			rationale:   "Mutation sem escalation routing para conflicting-signals/insufficient-context é mutação cega — agente executa apesar de incerteza estrutural; viola P10 (gates determinísticos para decisões irreversíveis)."
		}, {
			id:          "tq-agg-04"
			description: "Guide enforça observability completude"
			test:        "Process da section context-observability-validation exige: signals[] cobre ≥1 signal por category declarada nos actions; auditTrail.fields contém ≥7 minimum (per #AuditTrail._minimumAuditFields) + ≥3 domain-specific. Empirical: cmt 10, ctr 11, npm 11. Cobre tq-ag-05/06/07 do schema."
			severity:    "warn"
			rationale:   "Sem signals proporcionais aos actions, audit trail é incompleto — reconstituição regulatória impossível downstream. Domain-specific fields evitam que audit vire genérico (perde valor de domínio)."
		}, {
			id:          "tq-agg-05"
			description: "Guide enforça enforcementLevel declarado per constraint"
			test:        "Heuristics da section constraints-and-escalation exige: cada constraint declara onde é enforced — enforcementLevel ∈ {agent, runner, domain, external}. agent = constraint validada in-line pelo agente antes de submit; runner = validada por runner pós-submission (deterministic gate); domain = enforced via aggregate/lifecycle no domain-model (constraint é eco/observação, não execução); external = enforced por sistema externo (gateway, API, regulator). Verificado por inspeção do rationale ou campo dedicado (heuristic-level até schema absorver)."
			severity:    "warn"
			rationale:   "Sem enforcementLevel declarado, constraint vira ambígua — não se sabe se agente, runner, domain, ou external executa. Ambiguidade gera duplicação (agente + runner valida mesma coisa), gap (ninguém valida), ou drift (validação muda sem ninguém notar). Heuristic-level: schema não modela hoje; PG documenta convenção e protocolo de declaração."
		}, {
			id:          "tq-agg-06"
			description: "Guide enforça derivedFromInvariant explicit ref per constraint"
			test:        "Heuristics da section constraints-and-escalation exige: cada constraint declara derivedFromInvariant: 'inv-XYZ' (ref ao invariant do domain-model que origina a constraint). Default 1:1 — uma constraint deriva de exatamente uma invariant. Constraint sem invariant origem é guideline ou enforcement técnico (ambos suspeitos); constraint derivada de múltiplas invariants é candidate a split. Verificado por inspeção do rationale ou campo dedicado."
			severity:    "warn"
			rationale:   "Coverage invariant→constraint hoje vive em prosa de rationale, não em ref estruturada — runner futuro não consegue validar coverage automaticamente nem detectar drift quando invariant é renomeada/removida. Heuristic-level: schema não modela hoje; PG documenta convenção. Aligns com adr-055 pattern (cross-aggregate-state-dependency como first-class)."
		}, {
			id:          "tq-agg-07"
			description: "Guide enforça action impact classification"
			test:        "Heuristics da section scope-and-action-catalog exige: cada action declara impact ∈ {read-only, state-change, cross-bc, external-side-effect}. read-only = query sem efeito colateral; state-change = mutation no aggregate; cross-bc = afeta state de outro BC (via published event ou sync command); external-side-effect = dispara efeito em sistema externo (notification, ledger entry, regulatory submission). Verificado por inspeção do rationale ou campo dedicado."
			severity:    "warn"
			rationale:   "Sem impact classification, governance (caps, escalation, audit cadence) é dimensionada por action.category sozinho — perde-se sinalização de blast radius real. action category=mutation com impact=external-side-effect exige caps mais conservadores que category=mutation com impact=state-change interno. Heuristic-level: schema não modela hoje; PG documenta convenção."
		}, {
			id:          "tq-agg-08"
			description: "Guide enforça per-action escalation override quando criticality diverge"
			test:        "Heuristics da section constraints-and-escalation declara: escalationConditions[] no spec é default global; actions cuja criticality diverge significativamente (e.g., regulatory mutation vs internal validation) podem declarar escalationConditionsOverride com categories adicionais ou substitutas. Granularidade per-action é EXCEÇÃO, não regra — over-declaração polui spec. Verificado por inspeção quando spec tem ≥1 action com criticality marcadamente diferente das demais."
			severity:    "warn"
			rationale:   "Escalation global cobre o piso comum, mas actions de risco diferenciado (e.g., emit-published-event regulatory vs query-internal) podem precisar de categories distintas (e.g., suspicious-input para um, conflicting-signals para outro). Hoje spec só permite escalation global — gap de granularidade. Heuristic-level: schema não modela override hoje; PG documenta padrão de declaração no rationale da action."
		}, {
			id:          "tq-agg-09"
			description: "Guide enforça decision-vs-execution separation em actions"
			test:        "Heuristics da section scope-and-action-catalog declara: action NÃO deve misturar decisão (julgar/avaliar/recomendar) com execução irreversível (mutate/publish/emit) em mesmo step. Actions monolíticas que decidem + executam violam P10 — agente deveria propor decisão, gate humano/determinístico aprova, executor (potencialmente outro componente) materializa. Padrão recomendado: actions tipo decide-X (autonomyLevel propose-and-wait, output: recommendation) + tipo execute-X (autonomyLevel restricted, input: approved recommendation). Verificado por inspeção das actions com category=mutation."
			severity:    "warn"
			rationale:   "Action monolítica decide+executa é P10 violation por design — sem separação, autonomyLevel=propose-and-wait não tem onde inserir o human gate (decisão e execução acontecem atomicamente). Heuristic-level: schema não distingue tipos de action hoje; PG documenta padrão de split em casos de execução irreversível."
		}, {
			id:          "tq-agg-10"
			description: "Guide enforça canonical test: domínio é o centro, agente é operador"
			test:        "finalValidation declara teste canônico: 'se remover o agente do BC, o sistema ainda protege os invariants do domain-model?'. Resposta esperada: SIM (invariants vivem em aggregates/lifecycle/runner/external; agente OBSERVA e PROPÕE, não SEGURA regra de domínio). Resposta NÃO indica bug arquitetural — agente está segurando lógica de domínio que deveria estar em aggregate.invariants[] enforced via lifecycle/command-handler. Verificado por inspeção: para cada invariant do domain-model, identificar o enforcer real (lifecycle? command handler? runner? agente?); agente como ÚNICO enforcer de invariant é red flag."
			severity:    "warn"
			rationale:   "Mesh modela domínio como centro, agente como operador. Spec que assume agente como centro vira frágil: trocar agente quebra invariants; degradar agente compromete domínio. Inversão correta: agente segura recomendação e observação; aggregates/lifecycle/runner seguram invariants. Heuristic-level: teste mental durante autoria; canonical para evitar drift estrutural ao longo de fases."
		}]
		rationale: "10 critérios cobrem disciplinas core para autoria de agent-spec: integridade referencial actions↔domain-model (tq-agg-01), invariant→constraint coverage (tq-agg-02), escalation coherence (tq-agg-03), observability completude (tq-agg-04), enforcementLevel per constraint (tq-agg-05), derivedFromInvariant explicit ref (tq-agg-06), action impact classification (tq-agg-07), per-action escalation override (tq-agg-08), decision-vs-execution separation (tq-agg-09), canonical test domínio-é-centro (tq-agg-10). Critérios 01-04 derivam dos tq-ag-XX do schema; 05-10 derivam de revisão estrutural pós-PG-A (sessão 2026-05-01) — todos warn por enquanto, heuristic-level até schema absorver. Cobertura completa dos 13+ tq-ag-XX do schema vive em finalValidation.steps."
	}

	prerequisites: {
		description: "Antes de criar agent-spec para um BC, agente lê canvas (estável) + glossary (recomendado) + domain-model (obrigatório, aprovado) + 3 BCs exemplares (cmt/ctr/npm primary agents) antes de autorar. Confirmar onboarding lifecycle stage e caps proporcionais com founder."
		collectFromFounder: [
			"BC alvo (code de 3 letras), confirmação de que canvas + domain-model existem e estão aprovados (estáveis, não em flux)",
			"Role inicial do agente — 'primary' é default; outros roles (specialist, validator) em fases futuras",
			"Onboarding lifecycle stage — default 'supervised-onboarding' (100% mutations propose-and-wait); demais stages pós-promotion via governance",
			"Caps proporcionais (mutations/period) — heurística baseada em criticidade do BC: cmt 5/80, ctr 3/50, npm 3/50; founder ajusta",
			"Estimated budget per action — heurística: heavy se >5 artifacts + cross-BC reads; moderate se 4-5 artifacts; light se ≤3 artifacts",
		]
		gapPolicy:     "Se domain-model do BC não estável ou não aprovado, NÃO crie agent-spec — postergue até domain-model convergir (cascade ordering: agent-spec depende de actions[].domainModelRefs resolvíveis). Se canvas em flux, postergar. Se governance ainda não autorada para o BC, forward-ref permitido (governanceRef como string vazia tolerada por schema?; verificar — alternativa: declarar com placeholder e atualizar no commit que cria governance.cue). NÃO inventar actions sem origem em domain-model commands/queries; NÃO inventar invariants para constraints — constraint deriva de invariant existente. Cascade ordering (per CLAUDE.md): agent-spec PG é pré-condição para instâncias de #AgentSpec; agente verifica este PG existe antes de instanciar."
		validatorNote: "Em Phase 0, founder review é obrigatório. Em Phase 1+ (após WI-069), authoring pode usar dispatch declarativo per authoring-policy.cue rollout. Quando structural-checks de agent-spec existirem (post-WI-068), tq-ag-01..04, tq-ag-08..10, tq-ag-13 automatizam-se intra-BC; tq-ag-11/12 dependem de runner cross-file (canvas alignment)."
		outputNote:    "Output é arquivo único contexts/{bc}/agents/{bc}-primary-agent.cue conformante a #AgentSpec. Tamanho típico: 340-380 linhas (per cmt 370, ctr 340, npm 381). Agent-spec inicial pode focar em primary role; specialist/validator roles em fases posteriores."
	}

	workOrder: [
		"scope-and-action-catalog",
		"constraints-and-escalation",
		"context-observability-validation",
	]

	sections: {
		"scope-and-action-catalog": {
			target:    "#AgentSpec"
			objective: "Estabelecer BC alvo, ler canvas + glossary + domain-model + 3 BCs exemplares; popular role + operationalScope (refs a domain-model) + actions[] (catalog top-level com category × autonomyLevel × inputTrustLevel matrix)."
			process: [{
				action: "Localizar canvas + glossary + domain-model + governance.cue (se já existir) + 3 BCs exemplares"
				detail: "Verificar contexts/{bc}/canvas.cue, glossary.cue e domain-model.cue existem e estão estáveis. Verificar se contexts/{bc}/agents/{bc}-primary-agent.governance.cue já existe (forward-ref permitido se ausente). Ler contexts/{cmt,ctr,npm}/agents/{bc}-primary-agent.cue como exemplares estruturais."
			}, {
				action: "Determinar role + alinhar com canvas.ownership.domainAgentSpec (tq-ag-03)"
				detail: "Role default 'domain-agent' para primary agent; outros roles (integration-agent, validation-agent, observation-agent) em fases futuras. agentSpec.code DEVE corresponder a canvas.ownership.domainAgentSpec — runner valida por tq-ag-03 (fail). Divergência aciona reconciliação canvas ou correção de code."
			}, {
				action: "Popular operationalScope com refs ao domain-model"
				detail: "operationalScope.aggregates obrigatório (≥1 ref a aggregates[].code do domain-model do BC). commands/events/invariants/projections opcionais conforme escopo do agente. Refs validadas por tq-ag-01 (fail) — building block inexistente é responsabilidade fantasma."
			}, {
				action: "Catalog actions[] com matrix category × autonomyLevel × inputTrustLevel"
				detail: "Cada action declara: code (act- prefix); category (query/mutation/validation/generation/escalation); autonomyLevel (default 'propose-and-wait' para mutations em onboarding — Phase 0 100% supervisão); inputTrustLevel (obrigatório se action processa input externo per tq-ag-11 warn — trusted-internal/external-structured/external-untrusted-freeform); domainModelRefs ⊆ operationalScope (tq-ag-02 fail); preconditions/postconditions opcionais. Action count proporcional à complexidade do BC."
			}, {
				action: "Confirmar catalog inicial com founder antes de section 2"
				detail: "Apresentar role + operationalScope + actions[] catalog (codes + categories + autonomyLevels + inputTrustLevels). Founder filtra: actions genuínas vs inventadas; autonomyLevel apropriado para Phase 0; inputTrustLevel correto para input externo. Compor catalog confirmado antes de proceder a constraints/escalation."
			}]
			sources: [
				"architecture/artifact-schemas/agent-spec.cue (#AgentSpec + 13+ tq-ag-XX)",
				"architecture/adrs/adr-037-* (governance two-level: global + envelope)",
				"contexts/cmt/agents/cmt-primary-agent.cue (exemplar 370 linhas, 10 actions)",
				"contexts/ctr/agents/ctr-primary-agent.cue (exemplar 340 linhas, 8 actions)",
				"contexts/npm/agents/npm-primary-agent.cue (exemplar 381 linhas, 12 actions)",
				"architecture/lenses/lens-ai-agent-governance.cue (lens primária — autonomy/escalation/observability)",
			]
			heuristics: [
				"Default Phase 0: 100% mutations declaradas como autonomyLevel 'propose-and-wait' — agressive supervision é o piso de onboarding; promotion a 'execute-and-log' vive em governance envelope, não em spec.",
				"inputTrustLevel obrigatório em mutations e validations que processam input externo; queries puramente internas omitem (default implícito trusted-internal). Per tq-ag-11 warn.",
				"Action count proporcional à complexidade do BC (cmt 10, ctr 8, npm 12). 1 action isolada é candidata a merge; >15 actions sugere split em múltiplos agentes (specialist roles em fases futuras).",
				"estimatedBudget heurística (informacional, não enforced por schema): heavy se action requer >5 artifacts + cross-BC reads; moderate se 4-5 artifacts; light se ≤3.",
				"6 standard signal codes recorrentes (canonicalizar): sig-mutation-executed, sig-validation-result, sig-escalation-triggered, sig-query-served, sig-supervision-requested, sig-constraint-violation. Domain-specific signals adicionais permitidos.",
				"domainModelRefs em actions[] DEVEM ser subset de operationalScope (least privilege per tq-ag-02 fail). Action operando fora do escopo é responsabilidade não-declarada.",
				"Forward-ref de governance: governanceRef declarado como string mesmo antes de governance.cue existir; resolução cross-file por runner via tq-ag-09 (fail post-creation). Em Phase 0, ambos os arquivos são autorados em sequência (spec → governance) ou par único.",
				"Aggregate vs feature: action é unidade comportamental, não pasta funcional. 'act-validate-X' que apenas envelopa command 'X' é misclassified — spec deve modelar decisão do agente, não pipe-through.",
				"Glossary alignment: action names usam linguagem da Ubiquitous Language do BC; divergência terminológica registrada como tension entry.",
				"Action impact classification (tq-agg-07): cada action declara impact ∈ {read-only (query sem efeito colateral), state-change (mutation no aggregate), cross-bc (afeta state de outro BC via published event ou sync command), external-side-effect (dispara efeito em sistema externo — notification, ledger, regulatory submission)}. impact é dimensão ortogonal a category — duas actions com category=mutation podem ter impact distintos (state-change interno vs external-side-effect regulatory) e exigem caps/escalation diferentes. Declarar no rationale da action; schema não modela como first-class hoje (heuristic-level).",
				"Decision vs execution separation (tq-agg-09): action NÃO deve misturar decidir (julgar/avaliar/recomendar) com executar irreversível (mutate/publish/emit) em mesmo step. Pattern recomendado para execuções irreversíveis: split em par decide-X (output: recommendation) + execute-X (input: approved recommendation). Actions monolíticas decide+execute violam P10 por design — não há onde inserir human gate em propose-and-wait. Para queries/observations a separação é menos crítica (read-only).",
			]
			doneCriteria: "Role identificado e alinhado com canvas.ownership.domainAgentSpec; operationalScope populado com refs válidas ao domain-model; actions[] catalog com category × autonomyLevel × inputTrustLevel × impact × domainModelRefs declarado para cada action; decision-vs-execution split aplicado em mutations irreversíveis (tq-agg-09); founder aprovou catalog antes de proceder à section 2."
			ifGap:        "Se canvas.ownership.domainAgentSpec não declarado ou não match com agent code proposto, postergar até canvas reconciliar (tq-ag-03 fail). Se domain-model em flux ou não aprovado, postergar — cascade ordering: actions[].domainModelRefs dependem de refs estáveis. Se action não tem domainModelRefs claro no operationalScope, é misclassified — pode ser action de outro role/agente OU pipe-through que deve ser removida. Se autonomyLevel proposto não é 'propose-and-wait' em mutations Phase 0, escalar — promotion vive em governance, não em spec."
		}

		"constraints-and-escalation": {
			target:    "#AgentSpec"
			objective: "Para cada invariant do domain-model, declarar constraint correspondente em constraints[] OR justificar exceção. Definir escalation conditions per role/category cobrindo conflicting-signals + insufficient-context para mutations."
			process: [{
				action: "Mapear invariants do domain-model para constraints"
				detail: "Para cada invariant em domain-model.invariants[], declarar constraint correspondente em constraints[] OR rationale explícito de exceção (enforced via lifecycle do aggregate / fora do escopo do agente / validado por command-handler antes do agente). Empirical: cmt 8/8, npm 6/6, ctr 5/7 com 2 gaps explicados. Cobre tq-ag-08 (codes únicos) e baseline para tq-agg-02."
			}, {
				action: "Para cada constraint, declarar verification + onViolation + appliesToActions"
				detail: "verification descreve teste mecânico (não-aspiracional per tq-ag-04 warn) — 'runner valida X via Y', não 'agente deve respeitar X'. onViolation: block (hard halt antes da action), escalate (envia ao supervisor), log-only (warn em audit), halt-and-revert (rollback após detect). appliesToActions lista action codes onde a constraint dispara."
			}, {
				action: "Definir escalationConditions[] cobrindo categories per role"
				detail: "Mínimo: 1 condition. Per tq-ag-10 warn: integration-agent/validation-agent que processam input externo incluem ≥1 entre suspicious-input/ambiguous-case; agentes com mutations incluem ≥1 entre conflicting-signals/insufficient-context. Mutations sem essas categories operam com autonomia implícita ilimitada — viola P10."
			}, {
				action: "Verificar coherence autonomyLevel × constraints (tq-ag-12 warn)"
				detail: "Combinações incoerentes: (a) action com autonomyLevel='execute-and-log' onde TODAS constraints aplicáveis têm onViolation='log-only' — agente sem freio real; (b) action com autonomyLevel='no-autonomous-action' com constraints onViolation='log-only' — constraint que nunca dispara porque humano já controla. Reportar como warn; founder decide ajuste."
			}, {
				action: "Confirmar constraint × escalation × action matrix com founder"
				detail: "Apresentar tabela: invariant → constraint (com verification + onViolation) → applies to actions [act-X, act-Y]. Apresentar escalationConditions[] por category com rationale. Founder filtra: constraints aspiracionais (reescrever ou descartar); onViolation strategy desproporcional; gaps de cobertura invariant→constraint."
			}]
			sources: [
				"architecture/artifact-schemas/agent-spec.cue (#AgentConstraint, #EscalationCondition, #EscalationCategory)",
				"contexts/{bc}/domain-model.cue (invariants[] do BC alvo — fonte de truth para constraint coverage)",
				"contexts/cmt/agents/cmt-primary-agent.cue (8 constraints, 8 invariants — coverage 1:1)",
				"contexts/npm/agents/npm-primary-agent.cue (6 constraints, 6 invariants — coverage 1:1)",
				"contexts/ctr/agents/ctr-primary-agent.cue (5 constraints, 7 invariants — 2 gaps explicados via lifecycle)",
				"architecture/design-principles.cue (P10 — agentes recomendam, gates determinísticos validam)",
			]
			heuristics: [
				"Coverage 1:1 invariant→constraint é norma; exceções declaradas explicitamente no rationale do constraint OR na rationale outer do agent-spec quando enforcement é via lifecycle do aggregate.",
				"onViolation='block' ou 'escalate' é default para constraints regulatory (Bacen, SCD, LGPD, KYC/AML) ou irreversíveis — log-only insuficiente para audit posterior.",
				"onViolation='log-only' apenas para soft constraints onde audit posterior + correção em batch é suficiente (ex.: padrões estilísticos, métricas de qualidade não-bloqueantes).",
				"Mutations sem escalation routing para conflicting-signals + insufficient-context são mutações cegas — agente executa apesar de incerteza estrutural; viola P10 (gates determinísticos para decisões irreversíveis).",
				"Constraints técnicas (formato, schema, presença de campo) → onViolation=block; constraints semânticas (regulatory, business invariant) → onViolation=escalate.",
				"verification mecânica: 'runner verifica X consultando Y' é concreto; 'agente respeita X' é guideline (tq-ag-04 warn). Reescrever guidelines como verifications testáveis.",
				"Channel selection (governance concern, mas spec antecipa): sync se a condition bloqueia o pipeline inteiro; async se retém apenas o item específico. Documentar no rationale do escalation condition.",
				"Recipient pre-PMF: 'founder' only — documentar como constraint da fase, não inventar abstração de routing inexistente. Per ADR-037 governance two-level.",
				"enforcementLevel per constraint (tq-agg-05): cada constraint declara onde é enforced em rationale ou campo dedicado — agent (validada in-line pelo agente antes de submit), runner (validada por runner pós-submission, deterministic gate), domain (enforced via aggregate/lifecycle no domain-model — constraint é eco/observação, não execução), external (enforced por sistema externo — gateway/API/regulator). Sem essa declaração, ambiguidade entre quem realmente valida produz duplicação ou gap.",
				"derivedFromInvariant explicit ref (tq-agg-06): cada constraint declara derivedFromInvariant: 'inv-XYZ' (ref ao invariant do domain-model que origina a constraint). Default 1:1 — uma constraint deriva de exatamente uma invariant. Constraint sem invariant origem é guideline ou enforcement técnico não-de-domínio (suspeito, escalar). Constraint derivando de múltiplas invariants é candidate a split. Permite validação automática de coverage e detecção de drift quando invariant é renomeada/removida.",
				"Per-action escalation override (tq-agg-08): escalationConditions[] no spec é default global aplicável a todas actions. Actions cuja criticality diverge significativamente do global (e.g., regulatory mutation com input externo vs query interna) podem declarar escalationConditionsOverride no rationale ou campo dedicado, listando categories adicionais ou substitutas. Granularidade per-action é EXCEÇÃO — over-declaração polui spec. Default: 1 escalationConditions global; override só quando criticality realmente diverge.",
			]
			doneCriteria: "Cada invariant do domain-model tem constraint correspondente OR exceção declarada com rationale (tq-agg-02); cada constraint declara enforcementLevel (tq-agg-05) E derivedFromInvariant ref (tq-agg-06); escalationConditions cobrem categories per role + mutations declaram conflicting-signals + insufficient-context (tq-ag-10); per-action override declarado quando criticality diverge (tq-agg-08); coherence autonomyLevel × constraints verificada (tq-ag-12); founder aprovou matrix antes de proceder à section 3."
			ifGap:        "Se invariant não tem constraint correspondente nem rationale de exceção, gap é silencioso — declarar exceção explícita com referência ao mecanismo alternativo de enforcement OR adicionar constraint. Se mutation não tem escalation conditions cobrindo conflicting-signals/insufficient-context, agente opera com autonomia implícita ilimitada — adicionar conditions ou reduzir autonomyLevel. Se constraint sem verification mecânica, é guideline não constraint (tq-ag-04 warn) — reescrever como verifiable ou descartar. Se onViolation='log-only' para constraint regulatory, escalar ao founder — risco de violação silenciosa de obrigação legal."
		}

		"context-observability-validation": {
			target:    "#AgentSpec"
			objective: "Definir contextRequirements (artifacts lidos pelo agente), observabilityContract (signals ≥1 por category + auditTrail ≥7 minimum + domain-specific fields). Executar tq-ag checks intra-BC + cross-canvas alignment + cue vet."
			process: [{
				action: "Declarar contextRequirements coerente com operationalScope (tq-ag-06 warn)"
				detail: "contextRequirements.artifacts lista canvas + glossary + domain-model do BC + lenses aplicáveis + ADRs relevantes. Cada artifact deve ser necessário para operar sobre ≥1 building block do operationalScope — artifact carregado sem uso é desperdício de context window. estimatedBudget per #BudgetEstimate (heavy/moderate/light)."
			}, {
				action: "Declarar observability.signals — ≥1 signal por category presente em actions[] (tq-ag-05 warn)"
				detail: "Para cada category presente em actions[] (query/mutation/validation/generation/escalation), declarar ≥1 signal com sig- prefix em observability.signals. 6 codes canônicos recorrentes: sig-mutation-executed, sig-validation-result, sig-escalation-triggered, sig-query-served, sig-supervision-requested, sig-constraint-violation. Domain-specific signals adicionais permitidos."
			}, {
				action: "Declarar observability.auditTrail.requiredFields ≥7 minimum + domain-specific (tq-ag-13 fail)"
				detail: "Mínimo 7 fields per #AuditTrail._minimumAuditFields: timestamp, agent-id, action-code, input-summary, output-summary, decision-rationale, governance-version. Adicionar 3-4 domain-specific (cmt 10, ctr 11, npm 11): refs a BC entities, IDs de transações, hashes de payload, metadata regulatory. Audit trail 'reconstrutível' é o teste canônico — dado o registro, é possível reconstruir inputs + decisão + rationale + outcome?"
			}, {
				action: "Verificar unicidade de codes em actions[] e constraints[] (tq-ag-07/08 fail)"
				detail: "Nenhum code duplicado em actions[] (act- prefix) nem em constraints[] (cst- prefix) nem em observability.signals[] (sig- prefix). Code duplicado quebra rastreabilidade de auditoria/governança. Conferência manual antes de cue vet."
			}, {
				action: "Executar cue vet ./contexts/{bc}/agents/ ./architecture/artifact-schemas/"
				detail: "Validação de shape final. Falha aqui bloqueia avanço — corrigir sintaxe e re-executar antes de submeter ao founder."
			}, {
				action: "Submeter ao founder para aprovação antes de commit"
				detail: "Apresentar agent-spec completo com sumário: BC, role, número de actions/constraints/escalation conditions/signals, autonomyLevel distribution, audit trail field count. Founder aprova antes de write."
			}]
			sources: [
				"architecture/artifact-schemas/agent-spec.cue (#ContextRequirements, #ObservabilityContract, #AuditTrail, _minimumAuditFields)",
				"contexts/cmt/agents/cmt-primary-agent.cue (10 audit fields, 6 signals)",
				"contexts/ctr/agents/ctr-primary-agent.cue (11 audit fields, 6 signals)",
				"contexts/npm/agents/npm-primary-agent.cue (11 audit fields, 6 signals)",
			]
			heuristics: [
				"contextRequirements coerente com operationalScope: artifact carregado sem uso no escopo é desperdício (tq-ag-06 warn). Lista enxuta — adicionar conforme necessidade emerge, não preventivamente.",
				"7 minimum fields são o floor regulatory-grade per ADR/lens-regulatory-compliance-as-architecture; 3-4 domain-specific cobrem reconstituição de contexto BC-específico (entity IDs, transaction refs, regulatory metadata).",
				"Audit trail 'reconstrutível' é o teste canônico: dado o registro persistido, é possível reconstituir todos os inputs + decisão tomada + rationale + outcome? Se NÃO, fields insuficientes.",
				"estimatedBudget proporcional a artifacts + tipo de read: heavy se cross-BC + >5 artifacts; moderate se 4-5 + same-BC; light se ≤3 + same-BC. Informacional (não enforced por schema).",
				"Forward-ref governanceRef até governance.cue existir; PG-B finaliza o pair (instance authoring de governance). tq-ag-09 (fail) só dispara após criação do envelope — Phase 0 pre-pair tolera ausência.",
				"Signal codes domain-specific opcionais quando 6 canônicos cobrem semântica completa do BC; preferir reuse a proliferation.",
				"cue vet recursive antes de submeter ao founder — sintaxe inválida nunca chega à revisão.",
			]
			doneCriteria: "contextRequirements coerente com operationalScope; signals[] cobre ≥1 por category presente em actions[] (tq-ag-05); auditTrail.requiredFields contém ≥7 mínimo + 3-4 domain-specific (tq-ag-13); codes únicos em actions[]/constraints[]/signals[] (tq-ag-07/08); cue vet limpo; founder aprovou."
			ifGap:        "Se signal categories não cobrem actions[] categories, observability incompleta — adicionar signals (tq-ag-05 warn). Se auditTrail.requiredFields < 7 minimum, audit trail não-regulatory-grade (tq-ag-13 fail) — adicionar fields obrigatórios. Se cue vet falha, corrigir sintaxe. Se contextRequirements lista artifacts não usados pelo operationalScope, podar (tq-ag-06 warn). Se action code, constraint code ou signal code duplicado, renomear (tq-ag-07/08 fail)."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #AgentSpec (boundedContextRef, role, governanceRef, operationalScope, actions/constraints/escalationConditions não-vazios, contextRequirements, observability, rationale).",
			"Verificar integridade referencial actions↔domain-model (tq-ag-01/02 + tq-agg-01): cada ref em operationalScope existe em domain-model do BC; cada actions[].domainModelRefs ⊆ operationalScope (least privilege).",
			"Verificar canvas alignment (tq-ag-03 fail): agent code corresponde a canvas.ownership.domainAgentSpec do BC. Validação por inspeção em Phase 0; runner futuro automatiza.",
			"Verificar invariant→constraint coverage (tq-agg-02 fail): cada invariant do domain-model do BC tem constraint correspondente em constraints[] OR rationale explícito de exceção (enforced via lifecycle / fora do escopo do agente). Coverage ratio reportado (cmt 8/8, ctr 5/7, npm 6/6 como referência).",
			"Verificar constraints verificáveis (tq-ag-04 warn): cada constraints[].verification descreve teste mecânico — não-aspiracional. 'Runner valida X via Y' aceito; 'agente respeita X' reescrito como verifiable ou descartado.",
			"Verificar codes únicos (tq-ag-07/08 fail): nenhum code duplicado em actions[] (act-), constraints[] (cst-), nem signals[] (sig-).",
			"Verificar governanceRef (tq-ag-09 fail): contexts/{boundedContextRef}/agents/{governanceRef}.governance.cue existe. Em Phase 0 pre-pair, forward-ref tolerado com nota explícita; pós-creation do governance envelope, criterion vira hard fail.",
			"Verificar escalation coherence (tq-ag-10 + tq-agg-03 fail): escalationConditions[] não-vazio; integration/validation agents com input externo incluem ≥1 entre suspicious-input/ambiguous-case; mutations declaram ≥1 entre conflicting-signals/insufficient-context. Sem isso, autonomia implícita ilimitada.",
			"Verificar inputTrustLevel em ações com input externo (tq-ag-11 warn): mutations e validations que processam input não-interno declaram inputTrustLevel (trusted-internal / external-structured / external-untrusted-freeform).",
			"Verificar coherence autonomyLevel × constraints (tq-ag-12 warn): flagear combinações incoerentes — execute-and-log com TODAS constraints aplicáveis log-only (agente sem freio); no-autonomous-action com constraints log-only (constraint que nunca dispara).",
			"Verificar audit trail mínimo (tq-ag-13 fail + tq-agg-04): auditTrail.requiredFields contém ≥7 minimum (timestamp, agent-id, action-code, input-summary, output-summary, decision-rationale, governance-version) + 3-4 domain-specific (refs a entities BC, IDs de transações, hashes de payload, regulatory metadata).",
			"Verificar observability completude (tq-ag-05 warn + tq-agg-04): signals[] cobre ≥1 por category presente em actions[] (query/mutation/validation/generation/escalation). 6 codes canônicos como base; domain-specific adicionais permitidos.",
			"Verificar context coerência (tq-ag-06 warn): cada artifact em contextRequirements.artifacts é necessário para operar sobre ≥1 building block do operationalScope. Artifact carregado sem uso é desperdício de context window.",
			"Verificar enforcementLevel declarado per constraint (tq-agg-05 warn): cada constraints[] declara enforcementLevel ∈ {agent, runner, domain, external} no rationale ou campo dedicado. Sem isso, ambíguo quem executa a validação (agente, runner, domain, ou sistema externo).",
			"Verificar derivedFromInvariant explicit ref per constraint (tq-agg-06 warn): cada constraints[] declara derivedFromInvariant: 'inv-XYZ' apontando para invariant existente no domain-model do BC. Default 1:1 (uma constraint deriva de uma invariant); múltiplas refs sugere split; ausência de ref sugere constraint não-de-domínio (escalar).",
			"Verificar action impact classification (tq-agg-07 warn): cada actions[] declara impact ∈ {read-only, state-change, cross-bc, external-side-effect} no rationale ou campo dedicado. impact é ortogonal a category — duas mutations com impact distintos (state-change interno vs external-side-effect regulatory) exigem caps/escalation diferentes.",
			"Verificar per-action escalation override (tq-agg-08 warn): se ≥1 action tem criticality marcadamente divergente do global (e.g., regulatory mutation vs internal query), envelope spec declara escalationConditionsOverride para essa action. Granularidade é exceção, não regra; over-declaração polui spec.",
			"Verificar decision-vs-execution separation (tq-agg-09 warn): para cada action com category=mutation e impact=external-side-effect ou cross-bc, verificar split em par decide-X (output: recommendation) + execute-X (input: approved recommendation). Actions monolíticas decide+execute em mutações irreversíveis violam P10 por design — não há onde inserir human gate em propose-and-wait.",
			"Verificar canonical test domínio-é-centro (tq-agg-10 warn): para cada invariant do domain-model do BC, identificar o enforcer real (lifecycle do aggregate? command handler? runner? agente?). Resposta esperada: invariants são enforced por aggregates/lifecycle/runner, NÃO pelo agente sozinho. Se agente é o ÚNICO enforcer de algum invariant, é red flag arquitetural — invariant deveria estar em domain-model, não em agent-spec. Teste mental: 'se remover o agente, sistema ainda protege esse invariant?'.",
			"Executar cue vet ./contexts/{bc}/agents/ ./architecture/artifact-schemas/ — falha bloqueia avanço; corrigir sintaxe e re-executar antes de submeter ao founder.",
			"Submeter ao founder para aprovação antes de commit.",
		]
	}
}
