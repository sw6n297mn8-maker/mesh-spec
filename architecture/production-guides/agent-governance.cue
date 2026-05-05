package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// agent-governance.cue — Production guide para Agent Governance
// Envelope (per-agent supervisory layer).
//
// Schema alvo: #AgentGovernanceEnvelope (459 linhas no schema
// agent-governance.cue, com 10 tq-gv-XX para envelope: tq-gv-06..15).
// Phase 1 da regra universal de adr-053 (autorado fora de phasing
// estrito por necessidade de cascade ordering — IDC primary agent
// governance é a primeira instância pós-cascade per adr-054 dec 13).
//
// Scope deste PG: envelope per-agent. Global #AgentGovernanceGlobal
// (singleton em architecture/agent-governance.cue) é concern separado;
// PG distinto quando global for materializado. Em Phase 0,
// governanceGlobalVersion "0.1" é forward-ref canônico (per CMT
// envelope header documentando a convenção).
//
// Authoring manual Phase 0 de adr-054. Materializado em 3 commits
// sequenciais (scaffold → sections → finalValidation).
//
// Convenção: tq-gvg-NN para critérios deste guide. Abreviação "gvg"
// declarada na legenda canônica em architecture/artifact-schemas/
// quality-criteria.cue (commit 8ba35b6).
//
// Iteração pós-founder review (sessão 2026-05-01): 5 disciplinas
// adicionadas a partir de gaps identificados em revisão estrutural —
// routing precedence (concorrência entre categories), automatic
// enforcement (drift→ação direta, sem passar por calibration),
// lifecycleStage→caps monotonicidade, failure handling de erros do
// próprio agente, envelope-is-control-plane anti-pattern guard.
// 5 critérios tq-gvg adicionados (tq-gvg-05/06/07/08/09 todos warn).
// tq-gvg-08 (failure handling) originalmente warn heuristic-level com
// tech debt narrative; promovido a schema first-class enforced via
// adr-058 (commit subsequente nesta sessão) — PG-B atualizado para
// referenciar campo declarativo.
//
// Iteração pós-SSC envelope (sessão 2026-05-05, post-commit SSC envelope
// 588c1df + SRR dc5c83c): 3 hardenings adicionados a partir de erros
// revelados no founder review do envelope SSC — block scope explícito
// para rotas bloqueantes (alert-and-block sem scope vira global agent
// halt por default), autonomy path matrix para mutations com autonomia
// condicional (normalPath × exceptionPath × escalationOverride evita
// inconsistência spec↔envelope), diferenciação drift determinístico vs
// estatístico (anomaly detection sem confidence threshold + janela
// gera bloqueio amplo prematuro). 2 critérios tq-gvg adicionados
// (tq-gvg-10 fail + tq-gvg-11 warn) + 3 heuristics + 3 finalValidation
// steps + 1 clarification em tq-gvg-09 (drift metrics podem MEDIR
// domain, NÃO decidir domain individual).

agentGovernanceGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/agent-governance\\.cue$"
			fileNameRegex:      "^agent-governance\\.cue$"
			description:        "Production guide para autoria de Agent Governance Envelope (per-agent supervisory layer) em mesh-spec."
			rationale:          "Envelope formaliza routing + caps + calibration + drift + lifecycle stage de governança per-agent (#AgentGovernanceEnvelope, 10 tq-gv-XX). Guide explicita process, gapPolicy e heuristics que o schema sozinho não documenta. Phase 1 de adr-053; autorado antecipadamente por exigência de cascade ordering. Scope é envelope per-agent; global singleton tem PG separado quando materializado."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-gvg-01"
			description: "Guide enforça bidirectional ref coherence agent-spec↔envelope"
			test:        "Process da section bidirectional-validation declara passo explícito de validar: envelope.agentRef == agent-spec.code AND agent-spec.governanceRef == base name do arquivo envelope (sem .governance.cue). Cobre tq-gv-06 (fail) do schema."
			severity:    "fail"
			rationale:   "Link bidirecional spec↔envelope é fundação da hierarquia de governança per ADR-037. Sem isso, envelope órfão ou spec apontando para envelope errado produzem governança sem alvo."
		}, {
			id:          "tq-gvg-02"
			description: "Guide enforça escalation routing coverage de spec categories"
			test:        "Process da section routing-and-blast-radius exige: para cada category em agent-spec.escalationConditions[], envelope declara escalationRouting com mesma category OU rationale explícito de fallback via global categoryDefaults/fallbackChannel. Cada route tem channel + slaDescription + recipient. Cobre tq-gv-07 (warn) do schema com elevação a fail no protocolo."
			severity:    "fail"
			rationale:   "Routing incompleto deixa spec categories sem destino concreto — agente escala e ninguém sabe. Schema severity é warn (tolera global fallback); PG eleva a fail porque autoria deve ser explícita sobre coverage."
		}, {
			id:          "tq-gvg-03"
			description: "Guide enforça calibration measurable + time-bounded"
			test:        "Heuristics da section drift-and-calibration exige: cada calibration.promotionCriteria[] e calibration.regressionTriggers[] tem métrica mensurável (volume, period, approval-rate, boundary-violation-count) E período declarado. Critérios qualitativos como 'quando o agente estiver pronto' falham. Cobre tq-gv-10 (warn) do schema."
			severity:    "warn"
			rationale:   "Calibração sem métrica é promoção por feeling — inconsistente com governança. Empirical: cmt 20/80, ctr 30/100, npm 10/40 (volume thresholds proporcionais ao throughput esperado)."
		}, {
			id:          "tq-gvg-04"
			description: "Guide enforça P10 em autonomy overrides para mutations"
			test:        "Process da section bidirectional-validation declara passo de cruzar autonomyOverrides[].overrideLevel × agent-spec actions[].category. Nenhum override concede execute-and-log a action cuja category é 'mutation'. Cobre tq-gv-14 (fail) do schema."
			severity:    "fail"
			rationale:   "P10: agentes recomendam, gates determinísticos validam. Mutation com execute-and-log via override viola P10 mesmo que spec declare propose-and-wait — override seria backdoor para autonomia ilimitada em decisões irreversíveis."
		}, {
			id:          "tq-gvg-05"
			description: "Guide enforça routing precedence quando categories concorrem"
			test:        "Heuristics da section routing-and-blast-radius declara precedência canônica entre categories quando múltiplas categories podem disparar simultaneamente (e.g., conflicting-signals + suspicious-input em mesma action). Precedência: blocking > non-blocking; mutation-related > informational; explicit route > fallback. Verificado por inspeção do envelope quando spec tem ≥2 categories que podem coexistir."
			severity:    "warn"
			rationale:   "Sem precedência declarada, múltiplas categories simultâneas geram routing ambíguo — qual rota dispara primeiro fica implícito ao runner, criando comportamento não-determinístico. Heuristic-level: schema não enforça hoje; PG documenta precedência canônica."
		}, {
			id:          "tq-gvg-06"
			description: "Guide enforça automatic enforcement (drift → ação direta sem calibration)"
			test:        "Heuristics da section drift-and-calibration distingue 3 camadas: detecção (driftDetection.metrics), adaptação (calibration), contenção automática (immediate system action ligada a thresholds críticos sem passar por calibration humana — e.g., escalation rate > X → throttle automático; audit completeness < Y → block). Envelope declara ≥1 binding direto drift→action quando aplicável."
			severity:    "warn"
			rationale:   "Drift detection sem ação automática direta é detecção sem contenção — métricas degradam até calibration humana intervir, criando janela de risco. Separação detecção/adaptação/contenção transforma governance em sistema dinâmico, não apenas estático. Heuristic-level: schema não modela como first-class hoje."
		}, {
			id:          "tq-gvg-07"
			description: "Guide enforça caps proporcionais ao lifecycleStage (monotonicidade)"
			test:        "Heuristics da section routing-and-blast-radius declara: blastRadiusCaps DEVEM ser função monotônica (não-decrescente) do lifecycleStage. Faixas canônicas: onboarding 1-2 concurrent / 20-50 daily; validation 2-3 / 30-70; operational 3-5 / 50-100; mature 4-8 / 80-150. Envelope com lifecycleStage='onboarding' e caps de 'mature' é incoerente (warn)."
			severity:    "warn"
			rationale:   "lifecycleStage e caps são acoplados na prática mas declarados em campos separados — sem heuristic explícita, autor pode declarar onboarding com caps de production, contradizendo a semântica de progressão. Heuristic-level: schema não cruza os campos hoje."
		}, {
			id:          "tq-gvg-08"
			description: "Guide enforça preenchimento do field failureHandling para erros do próprio agente"
			test:        "Process da section drift-and-calibration declara passo de preencher envelope.failureHandling field (per adr-058 schema first-class) cobrindo onAgentError + onTimeout + onRepeatedFailure com action de #RegressionAction, descriptions substantivas, retryPolicy/threshold/timeWindow quando aplicáveis. Verificado por inspeção do shape no envelope (schema enforce presence; PG enforce semantic completude)."
			severity:    "warn"
			rationale:   "Drift cobre desvio comportamental; escalation cobre incerteza; overrides cobrem calibração — mas falha do próprio agente (timeout, erro sistemático, comportamento não-determinístico) não tem cobertura explícita. Sistema robusto contra erro da própria IA exige failure handling declarado. Per adr-058, failureHandling é field schema first-class enforced (não mais tech debt narrative); PG verifica completude semântica acima do shape mínimo do schema."
		}, {
			id:          "tq-gvg-09"
			description: "Guide enforça envelope is control plane, not business logic (anti-pattern guard)"
			test:        "Heuristics da section bidirectional-validation declara: envelope contém APENAS routing + caps + calibration + drift + lifecycle (control plane); NÃO contém regras de domínio (business logic). Distinção operacional: drift metrics PODEM medir domain (rfq-cancellation-rate, supervisor-override-rate, budget-rejection-rate medem outcomes agregados de domínio para detectar drift estrutural) mas NÃO podem decidir domain individual (uma RFQ não vira inválida porque cancellation-rate global está alta — RFQ-individual validity vive no aggregate/spec; envelope reage com reduce-autonomy global, não com rejeição da RFQ específica). Sintomas de violação: route com condition que avalia conteúdo de payload do action; calibration metric específica de outcome de domínio individual (vs agregada); cap diferente por tipo de aggregate. Verificado por inspeção do rationale e structure."
			severity:    "warn"
			rationale:   "Envelope absorvendo business logic distorce ADR-037 (separation of concerns spec/envelope) — domain rules viram governança paralela à do agent-spec, criando dois pontos de verdade para a mesma decisão. Sintomas começam silenciosamente; documentar como anti-pattern guard previne drift."
		}, {
			id:          "tq-gvg-10"
			description: "Guide exige escopo explícito para rotas bloqueantes"
			test:        "Heuristics da section routing-and-blast-radius exige: toda escalationRouting com channel='alert-and-block' declara no rationale OU slaDescription o menor escopo bloqueado (rfq-specific, supplier-affected, proponent-affected, category-affected, agent-wide, system-global). Bloqueio amplo (agent-wide ou system-global) exige justificativa explícita de severity tier ou coordenação adversarial. Verificado por inspeção do envelope quando ≥1 route usa alert-and-block."
			severity:    "fail"
			rationale:   "alert-and-block sem scope explícito é interpretado como global agent halt por default — bloquear o agente inteiro por uma RFQ ambígua é desproporcional e amplifica blast radius via cap consumption + reputation cost de operações concorrentes. SSC envelope authoring revelou: alert-and-block para insufficient-context inicialmente lido como global halt; founder review pediu scope item-specific explícito. Princípio de menor blast radius: RFQ-specific < ator-afetado < category-affected < agent-wide < system-global; declarar o menor que satisfaz a condição."
		}, {
			id:          "tq-gvg-11"
			description: "Guide diferencia sinais determinísticos de sinais estatísticos"
			test:        "Heuristics da section drift-and-calibration exige: rotas ou regressionTriggers baseados em anomaly detection / statistical pattern (low-balling via histogram comparison, fragmentation pattern, drift sustentado em métrica) declaram confidence threshold (ex.: z-score, IQR, mediana ± kσ, ou regra estatística declarada), janela mínima de observação (≥30 dias para padrões mensais; ≥7 dias para semanais) e escopo de contenção (ator-afetado por default; bloqueio amplo apenas com threshold sustentado em ≥2 evaluations consecutivas + rationale). Verificado por inspeção quando spec tem actions de escalation category com input estatístico."
			severity:    "warn"
			rationale:   "Signals estatísticos têm false positive rate inerente — bloqueio amplo sob signal único é overreach. Diferentemente de drift determinístico (cap breach, autonomy boundary violation — tolerance 1 ocorrência), drift estatístico exige threshold sustentado + janela mínima antes de contenção ampla. SSC envelope authoring revelou: act-detect-fragmentation/suspicious-quotation são mecanismos secundários per spec mas regression trigger inicial proposto era global suspend-and-escalate em 1 evaluation; founder review pediu scope ator-afetado + tolerance maior."
		}]
		rationale: "11 critérios cobrem disciplinas core para autoria de envelope: bidirectional ref (tq-gvg-01) como fundação ADR-037, escalation routing coverage (tq-gvg-02), calibration measurable (tq-gvg-03), P10 enforcement em overrides (tq-gvg-04), routing precedence (tq-gvg-05), automatic enforcement drift→action (tq-gvg-06), lifecycleStage×caps monotonicidade (tq-gvg-07), failure handling do próprio agente (tq-gvg-08), envelope-is-control-plane anti-pattern guard (tq-gvg-09), block scope explícito para rotas bloqueantes (tq-gvg-10), diferenciação drift determinístico vs estatístico (tq-gvg-11). Critérios 01-04 derivam de tq-gv-XX do schema; 05-09 derivam de revisão estrutural pós-PG-B (sessão 2026-05-01); 10-11 derivam de SSC envelope authoring (commit 588c1df). tq-gvg-08 originalmente warn heuristic-level com tech debt narrative; promovido a schema first-class enforced via adr-058 — PG verifica completude semântica acima do shape do schema. tq-gvg-10 fail / tq-gvg-11 warn refletem severity proporcional: scope ambíguo de bloqueio é estrutural (gera global halt indevido); diferenciação estatística é judgment-driven (false positive rate inerente). Demais 05/06/07/09/11 permanecem warn heuristic-level. Cobertura completa dos 10 tq-gv-XX para envelope (tq-gv-06..15) vive em finalValidation.steps."
	}

	prerequisites: {
		description: "Antes de criar agent-governance envelope para um BC, agente lê schema #AgentGovernanceEnvelope + agent-spec do mesmo BC (já criado e aprovado, par sequencial) + 3 BCs exemplares (cmt/ctr/npm governance.cue) + ADR-037 (governance two-level). Cascade ordering: envelope vem APÓS agent-spec no pair."
		collectFromFounder: [
			"BC alvo (3 letras) + confirmação de que agent-spec foi aprovado e committed (cascade: bidirectional ref tq-gv-06 falha sem spec)",
			"lifecycleStage inicial — default 'onboarding' (Phase 0 conservador; outros stages via promoção via calibration)",
			"blastRadiusCaps proporcionais — heurística baseada em criticidade BC: cmt 5/80, ctr 3/50, npm 3/50; founder ajusta",
			"Escalation channel preferences per category: sync-human-review se condition bloqueia pipeline; async-queue se retém apenas item específico; alert-and-block para boundary violations; alert-and-continue para anomalias informativas",
			"Calibration thresholds: promotionCriteria (volume + period + approval-rate; ex.: cmt 20 actions in 80 days >95% approval); regressionTriggers (boundary violation count → tolerance-zero default; drift detection → reduce-autonomy)",
			"Recipient pre-PMF: 'founder' only — documentar; routing abstraction futura é fora do escopo da fase",
		]
		gapPolicy:     "Se agent-spec não aprovado/committed, NÃO crie governance — bidirectional ref tq-gv-06 falha. Se global #AgentGovernanceGlobal não materializado em architecture/agent-governance.cue, usar forward-ref governanceGlobalVersion '0.1' (canônico Phase 0 per CMT/CTR/NPM); tq-gv-12 warn ativa quando global for criado e versão divergir. NÃO inventar lifecycleStages fora da taxonomia hardcoded (onboarding/validation/operational/mature). NÃO declarar caps que excedam o que será o teto global (tq-gv-09 fail post-global). NÃO criar autonomyOverrides retroativamente expirados (validUntil >= data atual; tq-gv-13 warn). NÃO conceder execute-and-log via override a action cuja category é mutation (tq-gv-14 fail; viola P10). Cascade ordering: agent-governance PG é pré-condição para instâncias de #AgentGovernanceEnvelope."
		validatorNote: "Em Phase 0, founder review é obrigatório. Em Phase 1+ (após WI-069), authoring pode usar dispatch declarativo per authoring-policy.cue rollout. Quando structural-checks de envelope existirem (post-WI-068), tq-gv-06/08/09/11/14/15 automatizam-se intra-BC; tq-gv-07/12 dependem de runner cross-file (spec + global). tq-gv-10/13 são warn semântico — inspeção visual permanece relevante."
		outputNote:    "Output é arquivo único contexts/{bc}/agents/{bc}-primary-agent.governance.cue conformante a #AgentGovernanceEnvelope. Tamanho típico: 150-180 linhas (per cmt 153). Envelope inicial foca em onboarding stage; promoção a validation/operational/mature ocorre via calibration declarada, não via autoria de novos arquivos."
	}

	workOrder: [
		"routing-and-blast-radius",
		"drift-and-calibration",
		"bidirectional-validation",
	]

	sections: {
		"routing-and-blast-radius": {
			target:    "#AgentGovernanceEnvelope"
			objective: "Estabelecer agentRef + governanceGlobalVersion + lifecycleStage; declarar escalationRouting cobrindo categories do agent-spec; declarar blastRadiusCaps proporcionais ao risco da fase."
			process: [{
				action: "Localizar agent-spec aprovado + 3 BCs exemplares + schema"
				detail: "Verificar contexts/{bc}/agents/{bc}-primary-agent.cue existe e foi aprovado pelo founder (cascade ordering: bidirectional ref tq-gv-06 falha sem spec). Ler contexts/{cmt,ctr,npm}/agents/*.governance.cue como exemplares estruturais. Ler schema #AgentGovernanceEnvelope para enums e constraints."
			}, {
				action: "Declarar agentRef + governanceGlobalVersion + lifecycleStage"
				detail: "agentRef = agent-spec.code (regex agt- prefix; tq-gv-06). governanceGlobalVersion = '0.1' como forward-ref Phase 0 canônico (per CMT envelope header documenta convenção); upgrade quando global #AgentGovernanceGlobal for materializado. lifecycleStage = 'onboarding' default em Phase 0; promoção a validation/operational/mature ocorre via calibration declarada, não autoria de novo arquivo."
			}, {
				action: "Declarar escalationRouting cobrindo categories do agent-spec"
				detail: "Para cada category em agent-spec.escalationConditions[], declarar escalationRouting com mesma category + channel + slaDescription + recipient + rationale. Categories sem route declarado documentam fallback a global categoryDefaults com referência explícita. Cobre tq-gvg-02 (fail; elevado de tq-gv-07 warn). Channel selection per heuristic abaixo."
			}, {
				action: "Declarar blastRadiusCaps proporcionais à criticidade do BC"
				detail: "maxConcurrentMutations + maxDailyActions proporcionais ao throughput esperado e criticidade. Empirical: cmt 5/80 (high), ctr 3/50 (medium), npm 3/50 (medium). Sanity check: maxDailyActions ≥ maxConcurrentMutations. Cobre tq-gv-09 (fail post-global) — runner verifica caps ≤ teto global quando este existir; em Phase 0 inspeção visual."
			}, {
				action: "Confirmar routing matrix + caps com founder"
				detail: "Apresentar tabela: category → (channel, sla, recipient) com rationale. Apresentar caps proporcionais com justificativa de criticidade. Founder filtra: channel desproporcional (alert-and-block para anomalia informativa); SLA vago ('ASAP'); caps que excedem o que será o teto global."
			}]
			sources: [
				"architecture/artifact-schemas/agent-governance.cue (#AgentGovernanceEnvelope, #EscalationRoute, #EscalationChannel, #BlastRadiusCaps, #LifecycleStage)",
				"architecture/adrs/adr-037-* (governance two-level: global + envelope)",
				"contexts/cmt/agents/cmt-primary-agent.governance.cue (exemplar 153 linhas, lifecycle onboarding)",
				"contexts/ctr/agents/ctr-primary-agent.governance.cue (exemplar)",
				"contexts/npm/agents/npm-primary-agent.governance.cue (exemplar)",
				"contexts/{bc}/agents/{bc}-primary-agent.cue (agent-spec do BC alvo — fonte de truth para escalationConditions categories)",
			]
			heuristics: [
				"Channel selection: sync-human-review se condition bloqueia pipeline (e.g., conflicting-signals em mutation regulatory); async-queue se retém apenas item específico (e.g., out-of-scope individual); alert-and-block para boundary violations (compliance-critical); alert-and-continue para anomalias informativas (não bloqueantes).",
				"SLA descriptions concretas: '30 min em horário comercial', 'next business day', 'immediate'. Abstrações vagas como 'ASAP' falham audit posterior — runner não consegue verificar compliance.",
				"Recipient pre-PMF: 'founder' only — abstração de routing futura é tech debt explícita, documentada como Phase constraint no rationale do envelope, não inventada via campos artificiais.",
				"Caps proporcionais ao throughput esperado do BC: high (cmt 5/80), medium (ctr/npm 3/50). IDC heurística: 3/50 baseline (similar criticality a ctr/npm); ajustar conforme crítica regulatory adicional.",
				"maxDailyActions ≥ maxConcurrentMutations sanity check; caps inversos quebram lógica (não pode ter mais concurrent que daily total).",
				"Categories canônicas a cobrir (per agent-spec patterns): conflicting-signals, insufficient-context, out-of-scope, ambiguous-case, suspicious-input, unclassifiable-anomaly. Routing exhaustivo é norma; gaps documentam fallback global.",
				"Forward-ref governanceGlobalVersion '0.1' é canônico Phase 0 (CMT header documenta); upgrade a '1.0' quando architecture/agent-governance.cue for materializado e versão estiver alinhada.",
				"lifecycleStage Phase 0 sempre 'onboarding' — promoção a validation/operational/mature via calibration declarada (section 2), não autoria de novo arquivo.",
				"Routing precedence (tq-gvg-05): quando múltiplas categories podem disparar simultaneamente em uma mesma action, declarar precedência canônica no rationale do envelope. Hierarquia: (1) blocking > non-blocking (alert-and-block precede alert-and-continue); (2) mutation-related > informational (categories ligadas a mutation precedem categories ligadas a query/observation); (3) explicit route > fallback (route declarada precede global categoryDefaults). Sem precedência, runner escolha é não-determinística.",
				"lifecycleStage × caps monotonicidade (tq-gvg-07): blastRadiusCaps DEVEM ser função monotônica (não-decrescente) do lifecycleStage. Faixas canônicas: onboarding 1-2 concurrent / 20-50 daily; validation 2-3 / 30-70; operational 3-5 / 50-100; mature 4-8 / 80-150. Envelope onboarding com caps de mature é incoerente — promotion vive em calibration, não em autoria inicial inflada.",
				"Envelope is control plane, not business logic (tq-gvg-09): envelope contém APENAS routing + caps + calibration + drift + lifecycle. Sintomas de violação: route com condition avaliando payload do action (pertence ao spec); cap diferente por tipo de aggregate (business rule vazada); SLA específico por outcome de domínio. Domain rules vivem em agent-spec.constraints[] / domain-model.invariants[]; envelope governa, não decide negócio.",
				"Block scope discipline (tq-gvg-10): alert-and-block NÃO significa bloquear o agente inteiro por default. Aplicar menor blast radius possível: RFQ-specific (rfqId único bloqueado) < supplier/proponent-affected (ator específico em janela de detecção) < category-affected (categoria de compra inteira) < agent-wide (todo agente halt) < system-global (todos agentes). Declarar scope explícito no rationale OU slaDescription da route — sem isso, runner trata como global halt. Justificativa para escopo amplo (agent-wide ou system-global): severity tier alto (zona cinza regulatória + ausência de defesa estrutural primária) OU vetor adversarial coordenado sustentado.",
			]
			doneCriteria: "agentRef + governanceGlobalVersion + lifecycleStage declarados; cada category em agent-spec.escalationConditions[] tem escalationRouting correspondente OR rationale explícito de fallback global; routes alert-and-block declaram block scope explícito per tq-gvg-10; blastRadiusCaps proporcionais à criticidade BC + sanity check daily ≥ concurrent + monotonicidade vs lifecycleStage (tq-gvg-07); precedência declarada quando categories podem coexistir (tq-gvg-05); envelope contém apenas control plane (tq-gvg-09); founder aprovou routing matrix antes de proceder à section 2."
			ifGap:        "Se agent-spec não aprovado/committed, postergar (cascade ordering: tq-gv-06 fail). Se categoria do spec não tem route declarado nem fallback explícito documentado, gap é silencioso — adicionar route ou referência a global categoryDefaults. Se caps excedem teto global (post-creation), ajustar (tq-gv-09 fail). Se lifecycleStage diferente de 'onboarding' em Phase 0, escalar ao founder — promotion vive em calibration, não em autoria inicial. Se SLA description vaga, reescrever como concreta."
		}

		"drift-and-calibration": {
			target:    "#AgentGovernanceEnvelope"
			objective: "Declarar driftDetection (cadence + métricas baseline/threshold) e calibration (promotionCriteria + regressionTriggers + immediateAction enum) com métricas mensuráveis e períodos declarados."
			process: [{
				action: "Declarar driftDetection.cadence + métricas baseline/threshold"
				detail: "cadence em formato descritivo legível ('weekly', 'monthly', '30 days'). metrics[] declara cada métrica com baseline numérico e threshold numérico/comparável. Métricas qualitativas falham (tq-gv-10 warn → tq-gvg-03 warn). Cobertura típica: action volume, escalation rate, approval rate, mean time to escalation, audit completeness rate."
			}, {
				action: "Declarar calibration.promotionCriteria[] mensuráveis e time-bounded"
				detail: "Cada promotionCriteria com volume + period + approval-rate + immediate action enum. Exemplo: '20 actions in 80 days >95% approval → promote to validation'. Critérios qualitativos ('quando o agente estiver pronto') falham — reescrever como quantitativos ou descartar."
			}, {
				action: "Declarar calibration.regressionTriggers[] com tolerance-zero para boundary violations"
				detail: "Standard triggers (canonical): boundary violation tolerance-zero → suspend-and-escalate; drift detected (qualquer métrica > threshold) → reduce-autonomy 1 level por 2 weeks; cap breach (concurrent ou daily) → reduce-autonomy. immediateAction enum per #ImmediateAction obrigatório (suspend-and-escalate / reduce-autonomy / pause-and-review)."
			}, {
				action: "Verificar calibration reconstrutível"
				detail: "Teste canônico: dado o registro de actions + outcomes (action volume, escalation rate, boundary violations) ao longo de minimumObservationPeriod, é possível derivar promotion/regression decision sem inspect manual? Se NÃO, métricas insuficientes ou critérios mal-definidos."
			}, {
				action: "Confirmar calibration thresholds + drift metrics com founder"
				detail: "Apresentar tabela: drift metric → (baseline, threshold, cadence); promotionCriteria → (volume, period, approval-rate); regressionTriggers → (condition, immediateAction). Founder filtra: thresholds desproporcionais (95% para mature é baixo); períodos curtos (validation→operational <30 days); regressionTriggers sem immediateAction."
			}]
			sources: [
				"architecture/artifact-schemas/agent-governance.cue (#DriftDetectionConfig, #CalibrationRules, #PromotionCriterion, #RegressionTrigger, #ImmediateAction, #LifecycleStage)",
				"contexts/cmt/agents/cmt-primary-agent.governance.cue (calibration: 20 actions in 80 days >95% approval)",
				"contexts/ctr/agents/ctr-primary-agent.governance.cue (calibration: 30/100 thresholds)",
				"contexts/npm/agents/npm-primary-agent.governance.cue (calibration: 10/40 thresholds)",
			]
			heuristics: [
				"Standard regression triggers (canonicalize): boundary violation tolerance-zero → suspend-and-escalate; drift detected (any metric > threshold) → reduce-autonomy 1 level por 2 weeks; cap breach → reduce-autonomy.",
				"Promotion volumes proporcionais ao throughput esperado: cmt 20/80 (high throughput), ctr 30/100, npm 10/40. IDC heurística: 15/60 (proporcional a throughput esperado de identity verifications).",
				"Approval-rate thresholds em escalada: 95% para validation→operational; 98% para operational→mature; 99.5% como teto. Patamares baixos comprometem qualidade do track record.",
				"Period thresholds (minimumObservationPeriod): 30 days mínimo para validation→operational; 90 days mínimo para operational→mature. Períodos curtos não acumulam track record significativo.",
				"Métricas mensuráveis requeridas: action volume, escalation rate, approval rate, mean time to escalation, audit completeness rate — todas numéricas com baseline + threshold (tq-gv-10 warn → tq-gvg-03 warn).",
				"immediateAction enum em regressionTriggers (#ImmediateAction): suspend-and-escalate (boundary violation; tolerance-zero); reduce-autonomy (drift; gradual); pause-and-review (anomaly; investigatório).",
				"Calibration reconstrutível como teste canônico: dado o registro de actions + outcomes, runner deriva promotion/regression sem inspect manual; se requer judgment humano, métricas insuficientes.",
				"Métricas qualitativas ('quando estiver pronto', 'quando confiável') falham tq-gv-10 — reescrever como quantitativas ou descartar do envelope.",
				"Automatic enforcement (tq-gvg-06): governance opera em 3 camadas distintas — detecção (driftDetection.metrics observa), adaptação (calibration ajusta autonomyLevel via promotion/regression), contenção automática (immediate system action ligada a thresholds críticos sem passar por humano). Bindings canônicos drift→action: escalation rate > threshold → throttle automático; audit completeness < threshold → block; cap breach → reduce-autonomy imediato. Declarar ≥1 binding direto quando spec tem actions com input externo ou mutations regulatory; sem isso, drift detectado degrada até calibration humana intervir (janela de risco aberta).",
				"Failure handling (tq-gvg-08): drift cobre desvio comportamental; escalation cobre incerteza; overrides cobrem calibração — mas falha do próprio agente exige cobertura explícita. Per adr-058, envelope.failureHandling é field schema first-class (sub-tipo #FailureHandling) cobrindo onAgentError + onTimeout + onRepeatedFailure com action de #RegressionAction + descriptions substantivas + retryPolicy/threshold/timeWindow quando aplicáveis. Defaults conservadores Phase 0: action='suspend-and-escalate' nos 3 events; retryPolicy 'max 1 retry exponential backoff' em onTimeout (semantics retry-then-escalate via combinação action+retryPolicy); threshold '3 failures' / timeWindow '24h' em onRepeatedFailure. Sistema robusto contra erro da própria IA é precondição de operação Mesh — agente não-determinístico sem failure handling é risco sistêmico.",
				"Statistical signal discipline (tq-gvg-11): diferenciação entre drift determinístico vs estatístico. Drift determinístico (cap breach, autonomy boundary violation, lifecycle invariant violation): tolerance 1 ocorrência; immediateAction suspend-and-escalate ou reduce-autonomy direta. Drift estatístico (anomaly detection, pattern recognition, threshold sobre histogramas): exige confidence threshold (ex.: z-score, IQR, mediana ± kσ, ou regra estatística declarada), janela mínima de observação (≥30 dias para padrões mensais; ≥7 dias para semanais), escopo de contenção (ator-afetado por default; categoria-wide apenas com threshold sustentado em ≥2 evaluations consecutivas; agent-wide apenas com coordenação adversarial sem defesa estrutural primária declarada). False positive rate inerente torna bloqueio amplo prematuro — supressão progressiva (collect-and-report → ator-block → categoria-block → agent-suspend) é norma, não exceção.",
			]
			doneCriteria: "driftDetection.cadence + métricas mensuráveis (baseline + threshold) declaradas; calibration.promotionCriteria com volume + period + approval-rate; regressionTriggers com immediateAction enum + tolerance-zero para boundary violations; calibration reconstrutível verificada; ≥1 automatic enforcement binding drift→action declarado quando aplicável (tq-gvg-06); failureHandling field preenchido per #FailureHandling shape cobrindo onAgentError/onTimeout/onRepeatedFailure (tq-gvg-08, schema first-class per adr-058); founder aprovou thresholds antes de section 3."
			ifGap:        "Se métrica qualitativa, reescrever como quantitativa ou descartar (tq-gv-10 / tq-gvg-03 warn). Se promotionCriteria sem período declarado, agente promove sem track record adequado — adicionar minimumObservationPeriod. Se regressionTriggers sem immediateAction, governance não tem ação automática — adicionar enum. Se boundary violation com tolerance > 0, escalar ao founder (P10 violation: gates determinísticos exigem tolerance-zero). Se métricas não permitem reconstituição programática, expandir cobertura ou repensar promoção."
		}

		"bidirectional-validation": {
			target:    "#AgentGovernanceEnvelope"
			objective: "Validar bidirectional ref agent-spec↔envelope (tq-gv-06); validar autonomyOverrides[] não violam P10 em mutations (tq-gv-14); validar lifecycleStage na taxonomia (tq-gv-08); cue vet final + submissão founder."
			process: [{
				action: "Validar bidirectional ref agent-spec↔envelope (tq-gv-06 fail)"
				detail: "envelope.agentRef == agent-spec.code (regex agt- prefix). agent-spec.governanceRef == base name do envelope file (sem .governance.cue). Empirical: spec 'agt-cmt-primary' + envelope file 'cmt-primary-agent.governance.cue' + spec.governanceRef 'cmt-primary-agent'. Inconsistência aciona hard fail."
			}, {
				action: "Validar lifecycleStage pertence à taxonomia hardcoded (tq-gv-08 fail)"
				detail: "lifecycleStage ∈ {onboarding, validation, operational, mature} per #LifecycleStage enum. Stage fora da enum é vocabulário desalinhado. Em Phase 0 sempre 'onboarding'."
			}, {
				action: "Validar escalation routing coverage (tq-gvg-02 fail)"
				detail: "Para cada category em agent-spec.escalationConditions[], envelope tem escalationRouting com mesma category OU rationale explícito de fallback global. Cobertura silenciosa via global default sem documentação no envelope é gap — autoria deve ser explícita."
			}, {
				action: "Validar autonomyOverrides[] (tq-gv-11 + tq-gv-13 + tq-gv-14)"
				detail: "Para cada override em autonomyOverrides[]: (a) actionRef existe em agent-spec.actions[].code (tq-gv-11 fail; sem isso é configuração fantasma); (b) validUntil >= data atual quando presente (tq-gv-13 warn; expirados pollutam o envelope); (c) overrideLevel != 'execute-and-log' quando agent-spec.actions[actionRef].category == 'mutation' (tq-gv-14 fail; viola P10 — backdoor para autonomia ilimitada em decisões irreversíveis)."
			}, {
				action: "Validar envelope unicity per agentRef no diretório (tq-gv-15 fail)"
				detail: "Scan de contexts/{bc}/agents/ por arquivos .governance.cue com agentRef == X; máximo 1 por X. Múltiplos envelopes para o mesmo agente criam ambiguidade indeterminada de governança."
			}, {
				action: "Executar cue vet + submeter ao founder"
				detail: "cue vet ./contexts/{bc}/agents/ ./architecture/artifact-schemas/ recursive. Falha bloqueia avanço. Submeter ao founder: BC, agentRef, lifecycleStage, número de routes/overrides/promotionCriteria/regressionTriggers, caps, drift cadence. Founder aprova antes de write."
			}]
			sources: [
				"architecture/artifact-schemas/agent-governance.cue (#AgentGovernanceEnvelope, #AutonomyOverride, #LifecycleStage)",
				"architecture/artifact-schemas/agent-spec.cue (cross-validation: actions[], escalationConditions[], code, governanceRef)",
				"contexts/{bc}/agents/{bc}-primary-agent.cue (agent-spec do BC alvo — fonte de truth para cross-validation)",
				"architecture/design-principles.cue (P10 — agentes recomendam, gates validam)",
			]
			heuristics: [
				"Bidirectional ref é fundação ADR-037 — tq-gv-06 é hard fail; sem isso, governance é órfã ou aponta para spec errado.",
				"P10 enforcement em overrides (tq-gv-14): execute-and-log para mutation via override seria backdoor para autonomia ilimitada em decisões irreversíveis; unconditional fail. Mutation category não distingue financeira de não-financeira — regra default conservador para intermediário regulado.",
				"autonomyOverrides são ferramenta de calibração temporária, não substituto de autoria — validUntil obrigatório quando override é experimental; sem prazo, override vira estado permanente paralelo ao spec.",
				"Envelope unicity per agentRef (tq-gv-15): 1 envelope por agentRef por diretório agents/. Múltiplos é ambiguidade indeterminada — qual prevalece é decisão silenciosa do runner.",
				"cue vet recursive antes de submissão founder; sintaxe inválida nunca chega à revisão.",
				"Forward-ref governanceGlobalVersion '0.1' produz tq-gv-12 warn quando global existir e versão divergir — em Phase 0 versão é canônica e tq-gv-12 não dispara.",
				"Autonomy path matrix discipline: para cada mutation declarada no spec, envelope confirma 3 elementos em rationale (do envelope OU dos componentes relevantes — route, regression trigger): (a) normalPath autonomy — autonomyLevel quando preconditions normais satisfeitas; (b) exceptionPath autonomy — comportamento quando preconditions violadas (escalation routing? autonomy reduzida? mantém autonomyLevel mas escala via different category?); (c) escalationOverride condition — gatilho explícito da transição normal→exception (e.g., act-revalidate-rfq-pool: normalPath execute-and-log quando pool ≥2; exceptionPath escalate via out-of-scope async-queue quando pool <2; transition condition: pool size pós-revalidation). Sem essa matriz, autonomyLevel conditional do spec vira ambíguo no envelope — runner pode interpretar como override silencioso (viola tq-gv-14) ou como gate humano onde autonomia spec-declarada deveria operar.",
			]
			doneCriteria: "Bidirectional ref validado (tq-gv-06); lifecycleStage na taxonomia (tq-gv-08); routing coverage validado (tq-gvg-02); autonomyOverrides[] sem violação P10 (tq-gv-14) e sem expiração retroativa (tq-gv-13); envelope unicity confirmado (tq-gv-15); cue vet limpo; founder aprovou."
			ifGap:        "Se bidirectional ref não resolve (tq-gv-06 fail), corrigir spec.governanceRef OR envelope filename. Se override concede execute-and-log a mutation, remover override (tq-gv-14 fail) — não há override válido para essa combinação. Se overrides expirados presentes, podar (tq-gv-13 warn) — override morto polui envelope. Se múltiplos envelopes para mesmo agentRef, consolidar em arquivo único (tq-gv-15 fail). Se cue vet falha, corrigir sintaxe."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #AgentGovernanceEnvelope (agentRef, governanceGlobalVersion, lifecycleStage, escalationRouting/blastRadiusCaps/driftDetection/calibration não-vazios, rationale).",
			"Verificar bidirectional ref agent-spec↔envelope (tq-gv-06 + tq-gvg-01 fail): envelope.agentRef == agent-spec.code; agent-spec.governanceRef == base name do envelope file (sem .governance.cue). Inconsistência aciona hard fail.",
			"Verificar lifecycleStage na taxonomia hardcoded (tq-gv-08 fail): lifecycleStage ∈ #LifecycleStage enum (onboarding, validation, operational, mature). Em Phase 0 sempre 'onboarding'.",
			"Verificar escalation routing coverage (tq-gv-07 + tq-gvg-02 fail): cada category em agent-spec.escalationConditions[] tem escalationRouting com mesma category OR rationale explícito de fallback global; cada route tem channel + slaDescription + recipient + rationale.",
			"Verificar blastRadiusCaps (tq-gv-09 fail post-global): caps ≤ blastRadiusPolicy global maxConcurrentMutations e maxDailyActions; sanity check daily ≥ concurrent. Em Phase 0 sem global materializado, validação por inspeção visual.",
			"Verificar calibration measurable + time-bounded (tq-gv-10 + tq-gvg-03 warn): cada promotionCriteria[] / regressionTriggers[] tem métrica numérica (volume, period, approval-rate) + período declarado; critérios qualitativos ('quando estiver pronto') flagged.",
			"Verificar autonomyOverrides ref validity (tq-gv-11 fail): cada override.actionRef existe em agent-spec.actions[].code. Override de action inexistente é configuração fantasma.",
			"Verificar autonomyOverrides expiração (tq-gv-13 warn): cada override.validUntil >= data atual quando presente. Overrides expirados pollutam envelope e obscurecem state real de autonomia.",
			"Verificar P10 em autonomyOverrides (tq-gv-14 + tq-gvg-04 fail): nenhum override concede overrideLevel='execute-and-log' a action cuja agent-spec.actions[].category é 'mutation'. Backdoor para autonomia ilimitada em decisões irreversíveis viola P10 unconditional.",
			"Verificar governanceGlobalVersion match (tq-gv-12 warn): governanceGlobalVersion == architecture/agent-governance.cue version. Em Phase 0 sem global materializado, '0.1' forward-ref tolerado; warn ativa post-global quando versão divergir.",
			"Verificar envelope unicity per agentRef (tq-gv-15 fail): scan contexts/{bc}/agents/ por arquivos .governance.cue; máximo 1 envelope com mesmo agentRef. Múltiplos envelopes criam ambiguidade indeterminada de governança.",
			"Verificar routing precedence quando categories concorrem (tq-gvg-05 warn): se spec tem ≥2 categories que podem disparar simultaneamente em mesma action, envelope declara precedência canônica no rationale (blocking > non-blocking; mutation-related > informational; explicit route > fallback). Sem isso, runner choice é não-determinística.",
			"Verificar automatic enforcement bindings drift→action (tq-gvg-06 warn): envelope declara ≥1 binding drift→immediate-action (e.g., escalation rate > threshold → throttle; audit completeness < threshold → block) quando spec tem actions com input externo ou mutations regulatory. Sem isso, drift detected degrada até calibration humana intervir.",
			"Verificar caps × lifecycleStage monotonicidade (tq-gvg-07 warn): blastRadiusCaps dentro das faixas canônicas para o lifecycleStage declarado (onboarding 1-2/20-50; validation 2-3/30-70; operational 3-5/50-100; mature 4-8/80-150). Envelope incoerente (e.g., onboarding com caps de mature) escalado.",
			"Verificar failureHandling field (tq-gvg-08 warn): envelope.failureHandling preenchido per #FailureHandling shape (schema first-class per adr-058) cobrindo onAgentError + onTimeout + onRepeatedFailure com action + descriptions substantivas + retryPolicy/threshold/timeWindow quando aplicáveis. Sem isso, sistema vulnerável a erro da própria IA.",
			"Verificar envelope-is-control-plane anti-pattern guard (tq-gvg-09 warn): envelope contém apenas routing + caps + calibration + drift + lifecycle (control plane). Sintomas de violação flagged: route com condition avaliando payload (business logic vazada); cap diferente por tipo de aggregate; SLA específico por outcome de domínio. Domain rules pertencem a spec/domain-model, não envelope.",
			"Verificar block scope explícito em rotas bloqueantes (tq-gvg-10 fail): toda escalationRouting com channel='alert-and-block' declara no rationale OU slaDescription o menor escopo bloqueado (rfq-specific, supplier-affected, proponent-affected, category-affected, agent-wide, system-global). Bloqueio amplo (agent-wide ou system-global) exige justificativa explícita de severity tier ou coordenação adversarial. Sem scope, runner trata como global halt — overreach.",
			"Verificar statistical signal discipline (tq-gvg-11 warn): rotas/regressionTriggers baseados em anomaly detection ou statistical pattern declaram confidence threshold (ex.: z-score, IQR, mediana ± kσ, ou regra estatística declarada), janela mínima de observação (≥30 dias mensais; ≥7 dias semanais) e escopo de contenção (default ator-afetado; escopo amplo apenas com threshold sustentado em ≥2 evaluations + rationale). Sem isso, false positive rate inerente gera bloqueio amplo prematuro.",
			"Verificar autonomy path matrix para mutations conditional: para cada mutation no spec cujo comportamento muda conforme condição operacional, escalationOverride, ou route específica, envelope declara em rationale: (a) normalPath autonomy; (b) exceptionPath autonomy; (c) condition de transição normal→exception. Sem matriz explícita, autonomyLevel conditional vira ambíguo entre spec e envelope — heuristic-level até schema absorver pattern como first-class.",
			"Executar cue vet ./contexts/{bc}/agents/ ./architecture/artifact-schemas/ recursive — falha bloqueia avanço; corrigir sintaxe e re-executar antes de submeter ao founder.",
			"Submeter ao founder para aprovação antes de commit.",
		]
	}
}
