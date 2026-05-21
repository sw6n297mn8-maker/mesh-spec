package artifact_schemas

// Strategic Alignment Guardrail
// Per ADR-091.
//
// Categoria de governance paralela a structural-check, quality-gate
// e policy. Valida coerência evolutiva entre strategic intent (declarado
// em BC Identity Capsule) e materialização nos artifacts do BC.
//
// Escopo Phase 1 (canonical): apenas deterministic constraints.
// Heuristic constraints (semantic-drift, ontology-sprawl, rationale-
// depth) deferidos para ADRs subsequentes (ADR-094+) por instabilidade
// de métricas.
//
// Distinção canonical vs adjacentes:
// - structural-check: valida shape sintática de artifacts
// - quality-gate: valida qualidade interna de autoria
// - policy: valida workflow de governance
// - strategic-alignment-guardrail: valida coerência evolutiva entre
//   strategic intent e materialização (ESTE)
//
// Enforcement timing per ADR-090 D6 (constraints no caminho operacional):
// - hard-fail: pre-materialization OU pre-merge (bloqueia ANTES da
//   operação completar)
// - soft-warn: post-analysis advisory
//
// Cascade ordering com BC Identity Capsule (ADR-092):
// - Phase 1 (ADR-091 only): missing Capsule produz non-blocking warning
// - Phase 2 (ADR-092 materialized): missing Capsule para BC alvo de
//   bootstrap se torna hard-fail

#StrategicAlignmentGuardrail: {
	// Identificador canonical. Prefixo "sag-" canonical (paralelo a
	// "sc-" para structural-check, "qg-" para quality-gate).
	// Formato: sag-{bc}-{kind} ou sag-{kind}-{scope} para guardrails
	// cross-BC.
	id: string & =~"^sag-[a-z][a-z0-9-]*$"

	// Nome humanamente legível.
	name: string & !=""

	// Descrição operacional do que o guardrail valida.
	description: string & !=""

	// BC alvo do guardrail. Quando guardrail é cross-BC (rares casos),
	// usar "all" ou enumerar via guardrail composto em ADR futuro.
	appliesToBoundedContextRef: string & =~"^[a-z][a-z0-9-]*$"

	// Classe de constraint. Permite diferenciar enforcement model +
	// observability + false positive profile por classe.
	// Phase 1: 3 classes canonical (identity/capability/abstraction).
	// Phase 2+ (ADR-094+): "semantic", "complexity".
	constraintClass: "identity" | "capability" | "abstraction"

	// Kind específico dentro da classe. Phase 1 canonical kinds:
	// - identity-mismatch: role/semanticCenter divergente do Capsule
	// - unauthorized-capability-expansion: capability em canvas/domain-
	//   model não autorizada pelo Capsule
	// - forbidden-abstraction-tier-breach: tier semântico além do
	//   permitido pelo Capsule (e.g., "operational" BC virando
	//   "meta-constitutional")
	constraintKind: string & =~"^[a-z][a-z0-9-]*$"

	// Nível de enforcement determinístico vs advisory.
	enforcementLevel: "hard-fail" | "soft-warn"

	// Estabilidade canonical. "canonical" = constraint bem entendido com
	// métricas robustas. "experimental" = constraint em validação,
	// pode mudar entre ADRs.
	// Phase 1: todos canonical. Heuristic kinds futuros começam
	// experimental.
	stability: "canonical" | "experimental"

	// Referência à BC Identity Capsule consumida como input para
	// validação. Path canonical: strategic/identity-capsules/{bc}.cue
	// (lifecycle separado de strategic/subdomains/).
	// Schema do Capsule materializado em ADR-092.
	// Phase 1 ADR-091 only: Capsule ainda não materializado; missing
	// Capsule produz non-blocking warning per ADR-091 D5.
	identityCapsuleRef: string & =~"^strategic/identity-capsules/[a-z][a-z0-9-]*\\.cue$"

	// Especificação declarativa do check. Não imperativo (per P10:
	// gates determinísticos, não LLM-judged). Formato exato evolui
	// conforme constraint kinds materializam — Phase 1 aceita prose
	// declarativa que descreve o invariant verificável.
	checkSpec: string & !=""

	// Comportamento em violação. 4 opções canonical:
	// - block-pre-materialization: bloqueia durante autoria (proposta
	//   no chat ou pre-commit hook)
	// - block-pre-merge: bloqueia em CI antes de merge
	// - emit-warning: post-analysis advisory non-blocking
	// - escalate-to-founder: bypass requer aprovação explícita
	onViolation: "block-pre-materialization" | "block-pre-merge" | "emit-warning" | "escalate-to-founder"

	// Por que este guardrail existe. Rationale obrigatório per
	// princípio canonical CLAUDE.md.
	rationale: string & !=""
}
