package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr079: artifact_schemas.#ADR & {
	id:    "adr-079"
	title: "Refine PG canvas metric classification — direct-action vs escalation-driven control execution paths (empirical validation via DLV test)"
	date:  "2026-05-06"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		ADR-078 (commit 46586fb) operacionalizou metric classification
		via 2 categorias formais (control / observability-only) com
		algoritmo 5-step. Validation experiment retroativo em DLV
		(zero-write analysis) revelou 1 caso real não coberto:
		Metric 8 'verified-without-evidence-or-override-attempts'
		(invariant tripwire BD7 anti-default) tem scope_enforcement=
		freeze INLINE — control metric com action executada
		diretamente, sem escalation routing.

		Diagnóstico inicial agente foi 'criar 3ª categoria control-
		with-inline-action' — REJEITADO pelo founder como erro
		estrutural: distinção real não é tipo de metric, é tipo de
		EXECUTION PATH. Reframe correto: control metrics MAY execute
		via dois paths (direct-action ou escalation-driven); ambos
		legitimamente control; metric classification permanece 2
		categorias formais.

		Validation revelou padrão BC archetype emergent: DLV
		(enforcement BC) = 7 escalation + 1 direct-action + 0
		observability; INV (governance-driven BC) = 3 escalation +
		0 direct-action + 3 observability. Distribuição metric/action
		reflete natureza estrutural do BC — distinção fundamental
		entre containment (direct-action invariant enforcement) e
		coordination (escalation-driven governance).
		"""

	decision: """
		ADOPT 3 mudanças coordenadas em PG canvas Section 8 refinando
		ADR-078 SEM substituir nem alterar categorização base:

		(D1) Add process Step (1.5) ANTES do Step 2 — verificação de
		     execution path da ação corretiva: (a) executável
		     diretamente (tripwire, invariant breach com resposta
		     imediata via scope_enforcement INLINE) OU (b) requer
		     routing/escalation (coordenação, decisão externa,
		     diagnóstico).

		(D2) Add heuristic 'direct-action vs escalation' com 3
		     guardrails CRITICOS:

		     (D2.1) Direct-action APENAS quando ação é monotônica e
		            segura (fail-safe: block/freeze/reject), NÃO cria
		            novo estado de negócio (não emite, não altera,
		            não coordena), NÃO depende de interpretação
		            contextual. Direct-action = fail-safe invariant
		            enforcement, NÃO ação qualquer.

		     (D2.2) Tripwire (direct-action) NÃO é fallback para
		            ausência de escalation. Se ação não é claramente
		            fail-safe e determinística, modelar como
		            escalation — NÃO forçar direct-action.

		     (D2.3) Quando metric poderia acionar tanto direct-action
		            quanto escalation: executar direct-action primeiro
		            (fail-safe containment); escalation pode ocorrer
		            em paralelo ou após contenção.

		(D3) Update doneCriteria: control metric deve declarar
		     EITHER onBreach.escalationRef (escalation-driven path)
		     OR ação direta explícita no rationale (direct-action
		     path / tripwire pattern). Observability-only inalterado.

		Categorias formais permanecem 2 (control + observability-only)
		— mudança é sub-classification de execution path dentro de
		control, não taxonomia top-level. Schema #VerificationMetric
		inalterado (onBreach permanece optional; tripwire pattern
		usa rationale explícito).
		"""

	consequences: """
		(a) DLV Metric 8 (tripwire) é classificação válida sob PG
		    refinado: control com direct-action; rationale documenta
		    scope_enforcement=freeze inline; NÃO requer escalation
		    sintética para satisfazer algorithm.

		(b) Pattern BC archetype emergent registrado: distribuição
		    metric/action reflete natureza BC (enforcement vs
		    governance-driven vs mixed). DLV = containment-heavy;
		    INV = coordination-heavy; sistema Mesh precisa de ambos.
		    Distinção fundamental containment vs coordination é base
		    arquitetural para governance envelope + runtime
		    orchestration + agent autonomy levels.

		(c) Guardrails direct-action (D2.1-D2.3) bloqueiam 3 vetores
		    de drift:
		    (c1) lógica arbitrária travestida de 'ação direta'
		         (D2.1: monotônica + fail-safe + sem novo estado)
		    (c2) bypass de governance via 'é determinístico, executo
		         direto' (D2.1: NÃO interpretação contextual)
		    (c3) tripwire como fallback de design preguiçoso
		         (D2.2: NÃO fallback para ausência de escalation)
		    (c4) race conditions containment vs diagnosis
		         (D2.3: precedence clara — containment first)

		(d) ADR-078 PRESERVADO temporalmente — refinement empírico
		    via ADR-079 documenta evolução guiada por validation,
		    NÃO supersession. Pattern 'ADR-077 schema → ADR-078
		    authoring rule → ADR-079 empirical refinement' demonstra
		    governance evolution sob disciplina de scope.

		(e) Refinement não exige write em DLV canvas — Metric 8
		    permanece válido com structure atual; PG refinado
		    formaliza o pattern empírico que DLV já implementa
		    inline. Backfill 8 canvases existentes (WI separado)
		    aplica algorithm refinado consistentemente.

		(f) P2P validation deferred — DLV revelou direct-action
		    path; P2P teste many-to-one principle independent.
		    WI-053 INV bootstrap segue para Phase 2 glossary
		    (continuar Wave 0 progress) sem bloqueio adicional.
		"""

	reversibility: "high"
	blastRadius:   "local"

	affectedArtifacts: [
		"architecture/production-guides/canvas.cue",
	]

	plannedOutputs: []

	derivedArtifacts: []

	principlesApplied: [
		"P10-deterministic-gates-vs-stochastic-recommendations",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-077-canvas-metric-onbreach-field",
		"adr-078-pg-canvas-metric-classification-hardening",
	]

	rationale: """
		Reversibility high: PG refinement, não schema constraint;
		canvases existentes inalterados. BlastRadius local: PG canvas
		único guide. Refinement empírico validado via DLV test
		(zero-write analysis) — pattern emerge de uso real, não
		especulação. Pushback founder em 'criar 3ª categoria'
		preservou modelo ADR-078 íntegro; reframe 'execution path
		dentro de control' captura distinção real (containment vs
		coordination) sem fragmentar taxonomia. 3 guardrails
		direct-action (monotônico+fail-safe; não-fallback;
		precedence containment-first) fecham vetores de drift
		específicos a invariant-self-execution. Demonstra metodologia
		'evolução governada via validation empírica' — preferível a
		expansão especulativa por completude teórica.
		"""
}
