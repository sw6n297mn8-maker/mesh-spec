package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr077: artifact_schemas.#ADR & {
	id:    "adr-077"
	title: "Add #VerificationMetric.onBreach field linking metric → escalation in canvas governanceScope (Phase 1 advisory rollout)"
	date:  "2026-05-06"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Sessão de schema hardening review (2026-05-06) sobre #Canvas
		identificou 4 ajustes potenciais elevando schema de 'estrutura
		descritiva' para 'parte do sistema de controle': (1) haltConditions
		explícitas, (2) assumption.type taxonomy, (3) metric.onBreach link
		para escalation, (4) openQuestion.impactLevel.

		Founder priorizou execução parcial (Opção C parcial): schema mod
		focada SOMENTE em metric.onBreach (ajuste #3) por ser único onde
		'machine-readable matters Phase 0' — loop metric → action sem
		link explícito é prose-coupled e interpretado inconsistentemente
		por agentes diferentes. Os outros 3 ajustes são deferidos para WI
		canvas-schema-hardening separado (junto com 10 melhorias prévias
		do mesmo schema review) e encoded via prose workaround micro-
		estruturada nos canvases Phase 0.

		WI-053 INV bootstrap Phase 1.8 (em andamento) materializa 6
		verificationMetrics e 7 escalationCriteria. Sem field link
		explícito metric → escalation, relação vm-inv-4 (taxa
		esc-projection-stale) ↔ esc-projection-stale fica implícita por
		nome — drift em outros canvases vai produzir variantes
		incompatíveis. Outros 8 canvases existentes (CMT, BDG, DLV, IDC,
		NPM, P2P, SSC, CTR) também serão beneficiados via backfill
		progressivo (WI separado).
		"""

	decision: """
		ADOPT 3 mudanças coordenadas no #Canvas schema (architecture/
		artifact-schemas/canvas.cue):

		(D1) Add optional field #VerificationMetric.onBreach com tipo
		     #MetricBreachAction. Field opcional para retrocompat com
		     8 canvases existentes (todos sem onBreach Phase 0). Ausência
		     explícita NÃO é oversight — significa observability-only
		     metric (signal sem escalation direta; exige avaliação
		     contextual human-in-the-loop). Decisão de não-ligar é
		     tratada como design choice legítima, NÃO incompletude.

		(D2) Add sub-schema #MetricBreachAction com:
		     - escalationRef: regex bd-style id, REFERENCIA
		       #EscalationCriterion.id no MESMO canvas (intra-canvas
		       link, não cross-BC)
		     - rationale: justifica por que ESTA métrica é signal
		       apropriado de breach desta escalation (distinto do
		       rationale do escalationCriterion)

		     Link é UNIDIRECIONAL por design: metric → escalation. Uma
		     escalation pode ser acionada por múltiplas métricas; não há
		     reverse link enforced no schema (modelar bidirecionalidade
		     seria complexity desnecessária Phase 0).

		(D3) Add tq-cv-14 quality criterion (severity warn — Phase 1
		     advisory) validando: para cada metric.onBreach.escalationRef
		     declarado, o id correspondente DEVE existir em
		     ownership.governanceScope.escalationCriteria[].id.
		     Validação por runner/unificação. Phase 2 ADR posterior
		     promove tq-cv-14 a fail após backfill completo + validação
		     de drift cross-canvas.

		     Compatibilidade SEMÂNTICA entre metric e escalation
		     referenciada (e.g., metric de cancellation rate apontando
		     para escalation de atomic emit failure seria sintaticamente
		     válido mas semanticamente errado) é responsabilidade do
		     design — validação manual Phase 1; potencial automação
		     Phase 2 via validation-prompt advisory que checa coerência
		     metric ↔ action (semantic gate per adr-040, não structural
		     gate).
		"""

	consequences: """
		(a) Canvas Phase 1.8 INV declara onBreach explicitamente em
		    metrics que têm escalation correspondente (vm-inv-2 →
		    esc-atomic-emit-primitive-failure; vm-inv-4 →
		    esc-projection-stale; vm-inv-6 →
		    esc-duplicate-issuance-attempt-detected). Métricas
		    observability-only (vm-inv-1 latency, vm-inv-3 cancel
		    ratio, vm-inv-5 cancel-pre-settle ratio) declaram
		    explicitamente em rationale como observability signal sem
		    escalation direta.

		(b) 8 canvases existentes permanecem válidos (campo opcional);
		    backfill é WI separado (escopo: ~6-10 metrics por canvas
		    × 8 = ~50 onBreach declarations potenciais; nem todas
		    serão preenchidas — observability-only metrics são
		    legítimas). Backfill triggera re-evaluation de cobertura
		    escalationCriteria por canvas.

		(c) Loop metric → action → governance fecha
		    deterministicamente para canvases com onBreach declarado;
		    canvases com onBreach ausente operam em modo observability-
		    only (decisão design legítima). Loop completo emerge da
		    composição: metric (dashboard signal) + onBreach.escalationRef
		    (intra-canvas link) + escalationCriterion.action (operational
		    response) + envelope.escalationRouting (runtime routing —
		    Phase 5 envelope, fora deste ADR).

		(d) Structural-check para tq-cv-14 implementação separada
		    (deferida para Phase 1+ runner work; estrutura segue
		    padrão de tq-cv-12 cross-reference validation).

		(e) Outros 3 ajustes do schema review prévio (haltConditions,
		    assumption.type, openQuestion.impactLevel) ficam como
		    dívida explícita em WI canvas-schema-hardening — encoded
		    via prose workaround micro-estruturada em INV Phase 1.8
		    ([HALT-CONDITION], [ASSUMPTION-TYPE: X], [IMPACT-LEVEL: X]).
		    Padrão micro-estrutura é parsing-friendly para futura
		    promoção a schema fields.

		(f) Padrão metric → escalation pode ser generalizado em lente
		    reutilizável (lens-governance-loop) Phase 1+ — descrevendo
		    o pattern arquitetural de loops governáveis (signal →
		    decisão → ação → correção) aplicável além de canvas
		    (e.g., agent-spec, envelope, structural-check).
		"""

	reversibility: "medium"
	blastRadius:   "local"

	affectedArtifacts: [
		"architecture/artifact-schemas/canvas.cue",
	]

	plannedOutputs: [
		"#VerificationMetric.onBreach optional field (architecture/artifact-schemas/canvas.cue)",
		"#MetricBreachAction sub-schema (architecture/artifact-schemas/canvas.cue)",
		"tq-cv-14 quality criterion (architecture/artifact-schemas/canvas.cue)",
	]

	derivedArtifacts: [
		"contexts/inv/canvas.cue (Phase 1.8 INV — primeira instância usando onBreach)",
	]

	principlesApplied: [
		"P1-canonical-cue-source",
		"P10-deterministic-gates-vs-stochastic-recommendations",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-043-phase-1-advisory-rollout-pattern",
	]

	rationale: """
		Reversibilidade medium: schema addition é optional/non-breaking,
		mas remoção pós-adoção exigiria backward-incompat ADR. Blast
		radius narrow: campo intra-canvas; não afeta outros artifact
		types nem cross-BC integration. Schema mod focada (1 field +
		1 sub-schema + 1 critério warn) fecha loop crítico
		metric → escalation Phase 0 sem breaking nos canvases
		existentes. Outros 3 ajustes do schema review deferidos
		preservam decisão founder de não fazer big-bang schema rework
		— evolução guiada por loops críticos, não por completude
		teórica. Phase 1 advisory pattern (paralelo adr-043) permite
		backfill progressivo sob signal warn vs fail. Padrão
		micro-estrutura prose ([HALT-CONDITION] etc.) usada em INV
		Phase 1.8 prepara terreno para futura promoção a schema fields
		sem fabricação de fake compliance.
		"""
}
