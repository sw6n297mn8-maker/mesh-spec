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
		}]
		rationale: "4 critérios cobrem disciplinas core para autoria de envelope: bidirectional ref (tq-gvg-01) como fundação ADR-037, escalation routing coverage (tq-gvg-02), calibration measurable (tq-gvg-03), P10 enforcement em overrides (tq-gvg-04). Scope é disciplinas que protocol enforce via process; cobertura completa dos 10 tq-gv-XX para envelope (tq-gv-06..15) vive em finalValidation.steps."
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
				action: "Placeholder — populado em commit 2/3 (sections)"
				detail: "Conteúdo desta section é materializado no próximo commit. Scaffold mantém shape mínimo válido per schema #SectionSpec."
			}]
			doneCriteria: "Placeholder — finalizado no commit 2/3."
		}

		"drift-and-calibration": {
			target:    "#AgentGovernanceEnvelope"
			objective: "Declarar driftDetection (cadence + métricas baseline/threshold) e calibration (promotionCriteria + regressionTriggers + immediateAction enum) com métricas mensuráveis e períodos declarados."
			process: [{
				action: "Placeholder — populado em commit 2/3 (sections)"
				detail: "Conteúdo desta section é materializado no próximo commit."
			}]
			doneCriteria: "Placeholder — finalizado no commit 2/3."
		}

		"bidirectional-validation": {
			target:    "#AgentGovernanceEnvelope"
			objective: "Validar bidirectional ref agent-spec↔envelope (tq-gv-06); validar autonomyOverrides[] não violam P10 em mutations (tq-gv-14); validar lifecycleStage na taxonomia global (tq-gv-08); cue vet final."
			process: [{
				action: "Placeholder — populado em commit 2/3 (sections)"
				detail: "Conteúdo desta section é materializado no próximo commit."
			}]
			doneCriteria: "Placeholder — finalizado no commit 2/3."
		}
	}

	finalValidation: {
		steps: [
			"Placeholder — finalValidation steps populadas no commit 3/3.",
		]
	}
}
