package build_time

// completion-gates.cue — Gates obrigatórios por template para task completion.
//
// Define o catálogo de gates e mapeamento template → gates requeridos,
// com override por task individual quando a obrigação depende do output
// scope (e.g. adr-coevolution para paths em architecture/ ou governance/).
//
// Extensão do pipeline ev-NN: adiciona ev-11 (completion gate enforcement).
// Composição: mesmo padrão de claim-expiration-validation.cue.
//
// Ref: P10 (design-principles.cue) — agentes recomendam, gates validam.
// Ref: task-governance.cue — templates e criticality.
// Ref: work-governance.cue — #CompletionValidation.gatesPassed.

// ── Tipo de gate ────────────────────────────────────────────────

#CompletionGate: {
	id:          string & =~"^[a-z][a-z0-9-]*$"
	description: string & !=""
	// "deterministic": verificável por tooling sem julgamento humano.
	// "evidence": requer evidência produzida por processo estruturado
	// (e.g. self-review report). CI verifica presença da evidência,
	// não julga conteúdo.
	kind:      "deterministic" | "evidence"
	rationale: string & !=""
}

// ── Catálogo de gates conhecidos ────────────────────────────────
//
// Cada gate tem semântica precisa. IDs alinham com valores já usados
// em gatesPassed de work-events existentes (e.g. "cue-vet").

completionGates: [ID=string]: #CompletionGate & {id: ID}

completionGates: {
	"cue-vet": {
		id:          "cue-vet"
		description: "Artefato CUE passa cue vet sem erros — baseline sintático da spec Mesh."
		kind:        "deterministic"
		rationale:   "CUE é o formato canônico da Mesh (P2). Artefato sintaticamente inválido nunca é commitado (CLAUDE.md seção Validação). Gate determinístico verificável por tooling sem julgamento."
	}
	"self-review": {
		id:          "self-review"
		description: "Self-review executado conforme quality-gate.cue com condição de saída satisfeita — evidência estruturada de autovalidação pré-proposta."
		kind:        "evidence"
		rationale:   "P10: agentes estocásticos recomendam, gates determinísticos validam. Self-review produz report auditável (self-review-report.cue) que comprova revisão antes da proposta ao founder. Evidência: report com status stable ou max-rounds-reached com disclaimer."
	}
	"structural-check": {
		id:          "structural-check"
		description: "Structural checks aplicáveis ao artefato, executados como gate determinístico pós-commit per adr-040."
		kind:        "deterministic"
		rationale:   "Per adr-040, structural-checks (architecture/structural-checks/) são o único mecanismo de validação pós-commit que pode bloquear. Regras declarativas por kind (required-block, reference-exists, same-artifact-consistency), reproduzíveis e auditáveis. Falha estrutural exige correção da instância ou alteração explícita da regra via decisão arquitetural. P10: agentes estocásticos recomendam, gates determinísticos validam."
	}
	"validation-prompt": {
		id:          "validation-prompt"
		description: "Validation prompt correspondente executado em sessão isolada como design review advisory per adr-040. Findings são recomendações para decisão do founder, nunca bloqueio."
		kind:        "evidence"
		rationale:   "Per adr-040, validation prompts são exclusivamente advisory — produzem revisão de design interpretativa por agente em sessão separada. Detectam viés e blind spots que self-review do mesmo agente não captura, mas não participam de gating determinístico (esse papel pertence a structural-check). Separação de contexto é o mecanismo diferenciador. Kind 'evidence' é aproximativo aqui por restrição do enum atual (deterministic|evidence) — 'advisory' ou 'review' seria mais preciso semanticamente; manter como evidence até que o enum seja estendido. ten-006 documenta por que a categoria não pode ser colapsada com structural-check."
	}
	"adr-coevolution": {
		id:          "adr-coevolution"
		description: "ADR criado ou atualizado no mesmo commit para mudanças semânticas em architecture/ ou governance/ — rastreabilidade de decisões."
		kind:        "deterministic"
		rationale:   "CLAUDE.md exige ADR para mudanças semânticas. Gate determinístico: CI verifica presença de ADR no mesmo commit quando paths afetados estão em architecture/ ou governance/."
	}
}

// ── Mapping: template → gates requeridos ────────────────────────
//
// Struct indexado por templateRef para lookup direto por CI
// (mesmo padrão de eventCommandMappings em event-validation.cue
// e taskGovernance em task-governance.cue).
//
// Nota: validation-prompt não é gate requerido em nenhum template
// nesta fase. CLAUDE.md seção Validação: "Se não existir validation
// prompt correspondente, prosseguir sem bloquear." Quando cobertura
// de validation prompts for universal, templates podem adicioná-lo.

#TemplateGateRequirement: {
	templateRef:   string & !=""
	requiredGates: [string & !="", ...string & !=""]
	rationale:     string & !=""
}

templateGateRequirements: [ID=string]: #TemplateGateRequirement & {templateRef: ID}

templateGateRequirements: {
	"tmpl-validate-artifact@v1": {
		templateRef:   "tmpl-validate-artifact@v1"
		requiredGates: ["cue-vet"]
		rationale:     "Validações não produzem artefatos novos — baseline sintático suficiente. Criticality low (task-governance.cue)."
	}
	"tmpl-create-schema@v1": {
		templateRef:   "tmpl-create-schema@v1"
		requiredGates: ["cue-vet", "self-review", "adr-coevolution"]
		rationale:     "Schemas restringem todas as instâncias futuras via cue vet e governam geração de código (P1). Criticality high — exigem self-review e ADR. Schemas vivem em architecture/ por definição."
	}
	"tmpl-create-instance@v1": {
		templateRef:   "tmpl-create-instance@v1"
		requiredGates: ["cue-vet", "self-review"]
		rationale:     "Instâncias são constrained por schema + quality-gate. Self-review garante conformidade semântica. adr-coevolution não está aqui porque obrigação de ADR depende do output path, não do template — tasks com outputs em architecture/ ou governance/ devem usar taskGateOverrides."
	}
}

// ── Override por task ───────────────────────────────────────────
//
// Quando a obrigação de gates depende de propriedades da task
// individual (e.g. output path) e não do template, override por
// taskId tem precedência sobre templateGateRequirements.
//
// Caso concreto: tmpl-create-instance@v1 usado tanto para artefatos
// de domínio (sem ADR obrigatório) quanto para artefatos de
// governance (ADR obrigatório por CLAUDE.md). O template não
// distingue — o override resolve.
//
// Escopo: task-governance.cue já prevê overrides por task (scope:
// "task") para criticality. Aqui, o mesmo princípio para gates.

#TaskGateOverride: {
	taskId:        string & =~"^WI-[0-9]{3}$"
	requiredGates: [string & !="", ...string & !=""]
	rationale:     string & !=""
}

taskGateOverrides: [ID=string]: #TaskGateOverride & {taskId: ID}

taskGateOverrides: {
	"WI-018": {
		taskId:        "WI-018"
		requiredGates: ["cue-vet", "self-review", "adr-coevolution"]
		rationale:     "Output em governance/build-time/ — mudança semântica em governance exige ADR (CLAUDE.md). Template tmpl-create-instance@v1 não inclui adr-coevolution por default porque nem toda instância vive em governance/."
	}
	"WI-019": {
		taskId:        "WI-019"
		requiredGates: ["cue-vet", "self-review", "adr-coevolution"]
		rationale:     "Output em governance/build-time/ — mesma lógica de WI-018."
	}
}

// ── Backfill ────────────────────────────────────────────────────
//
// Tasks completadas antes da ativação (WI-001..WI-017) registram
// apenas ["cue-vet"]. CI aceita gatesPassed mínimo quando
// task-completed.timestamp < activationTimestamp.
// Mesma lógica de backfill retroativo de ADR-024.

backfillPolicy: {
	activationTimestamp: "2026-03-22T13:00:00Z"
	rationale:          "Tasks anteriores operavam sob regime mínimo (apenas cue-vet verificável retroativamente). Exigir gates que não existiam formalmente é inconsistência sem valor — evidência não pode ser fabricada retroativamente."
}

// ── Extensão do pipeline ev-NN ──────────────────────────────────
//
// Segue o padrão de claim-expiration-validation.cue: checks próprios
// no mesmo namespace ev-NN, compostos na união pelo CI.

completionGateValidation: {
	rationale: "Fecha o loop entre gates requeridos (este arquivo) e gatesPassed declarado nos work-events. Sem este check, completionValidation é declarativo sem enforcement — violação de P10."

	checks: [...#EventValidationCheck] & [{
		id:          "ev-11"
		description: "gatesPassed em task-completed contém todos os gates requeridos pelo template (ou override)"
		severity:    "fail"
		enforcement: "procedural"
		source:      "completion-gates.cue (taskGateOverrides, templateGateRequirements, completionGates) + task-specs (templateRef)"
		algorithm: """
			Para cada task-completed na stream:
			1. Lookup taskId em taskGateOverrides.
			   Se encontrado: requiredGates = taskGateOverrides[taskId].requiredGates.
			   Se não: lookup taskId em task-specs → templateRef →
			   templateGateRequirements[templateRef].requiredGates.
			2. Se templateRef não encontrado em templateGateRequirements
			   (e sem override): emitir warn — template sem gate
			   requirements definidos é gap de especificação,
			   não erro do evento. Prosseguir sem bloquear.
			3. Validar que cada gate em requiredGates existe como
			   chave em completionGates. Erro se gate desconhecido
			   (typo ou gate removido sem atualizar requirements).
			4. Verificar que cada gate em requiredGates está presente
			   em completionValidation.gatesPassed.
			5. Backfill: se task-completed.timestamp <
			   backfillPolicy.activationTimestamp, exigir apenas
			   ["cue-vet"].
			Erro se gate requerido ausente em gatesPassed (exceto
			backfill).
			"""
		rationale: "Sem enforcement CI, gatesPassed aceita qualquer lista — definição formal de gates seria decorativa. P10: gate determinístico substitui declaração por verificação."
	}]
}
