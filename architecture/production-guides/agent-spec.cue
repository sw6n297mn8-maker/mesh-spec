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
		}]
		rationale: "4 critérios cobrem disciplinas core para autoria de agent-spec: integridade referencial actions↔domain-model (tq-agg-01), invariant→constraint coverage (tq-agg-02), escalation coherence (tq-agg-03), observability completude (tq-agg-04). Scope é disciplinas que protocol enforce via process; cobertura completa dos 13+ tq-ag-XX do schema vive em finalValidation.steps."
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
				action: "Placeholder — populado em commit 2/3 (sections)"
				detail: "Conteúdo desta section é materializado no próximo commit. Scaffold mantém shape mínimo válido per schema #SectionSpec (process com ≥1 step + doneCriteria ≥20 chars)."
			}]
			doneCriteria: "Placeholder — finalizado no commit 2/3."
		}

		"constraints-and-escalation": {
			target:    "#AgentSpec"
			objective: "Para cada invariant do domain-model, declarar constraint correspondente em constraints[] OR justificar exceção. Definir escalation conditions per role/category cobrindo conflicting-signals + insufficient-context para mutations."
			process: [{
				action: "Placeholder — populado em commit 2/3 (sections)"
				detail: "Conteúdo desta section é materializado no próximo commit."
			}]
			doneCriteria: "Placeholder — finalizado no commit 2/3."
		}

		"context-observability-validation": {
			target:    "#AgentSpec"
			objective: "Definir contextRequirements (artifacts lidos pelo agente), observabilityContract (signals ≥1 por category + auditTrail ≥7 minimum + domain-specific fields). Executar tq-ag checks intra-BC + cross-canvas alignment + cue vet."
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
