package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr133: artifact_schemas.#ADR & {
	id:    "adr-133"
	title: "Adicionar kind flow-event-closure (oráculo de closure de cross-context-flow)"

	date: "2026-05-31"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		PR-#2 da sequência de feedback-cycles (Ciclo 3). A auditoria de ciclos
		identificou que a especificação de um BC é incompleta se não consegue
		expressar o fluxo de domínio ponta-a-ponta sem furo — o
		event-storming-reverso — e isso não tinha gate determinístico. def-031
		registrou o gap.

		Estado atual (verificado): a regra de closure JÁ existe como tq-xf-02
		no schema #CrossContextFlow, mas apenas como _quality criterion_
		(design-review advisory, interpretativo) — NÃO como structural-check
		determinístico. Os dados da cadeia (phases[].completionSignal,
		integrationEvents, consumedBy[].consumes) já vivem no schema. Nenhum dos
		19 #StructuralCheckKind existentes expressa closure de grafo. E o único
		flow declarado (commitment-lifecycle) NÃO fecha hoje: 2 eventos
		produzidos sem consumidor declarado — BudgetCommitted (phase Budget
		Approval) e CommitmentClosed (phase terminal Financial Settlement) —
		exatamente as emissões roadmap que def-021 já sinalizou como
		não-materializadas.

		Alternativas avaliadas:

		(a) Schema B — estender #CrossContextFlow com um campo explícito de
		    cadeia de eventos. REJEITADA: os dados de closure já são
		    expressáveis pelos campos existentes; um campo de cadeia seria
		    duplicação (drift por construção, contra P0) e YAGNI até a distinção
		    órfão-bug vs órfão-roadmap exigir reject.

		(b) born-reject — o check bloqueia o build ao primeiro órfão. REJEITADA:
		    o flow atual tem 2 órfãos roadmap; gatear reject = born-red, que
		    afoga o sinal real — o anti-pattern que def-019/def-021 evitaram e
		    que o arco cycle-resolution ensinou (sc-cm-07 nasceu warn com ciclos
		    presentes).

		(c) Reusar directed-acyclicity ou cross-file-id-exists. REJEITADA:
		    closure produção↔consumo é propriedade topológica distinta de
		    aciclicidade e de existência cross-file de id; nenhum kind existente
		    a expressa.
		"""

	decision: """
		(1) ADICIONAR o kind flow-event-closure ao enum #StructuralCheckKind +
		    #FlowEventClosureRule (config de paths com defaults) + a entrada na
		    união discriminada de #StructuralCheck.

		(2) IMPLEMENTAR o handler ev_flow_event_closure no runner
		    (scripts/ci/structural-check-runner.py), registrado em EVAL — o
		    evaluator-coverage (adr-099) exige evaluator para todo kind do enum;
		    enum + handler entram no MESMO commit.

		(3) CRIAR sc-ccf-03 (artifactType cross-context-flow),
		    enforcement "warn" (born-warn, catraca adr-097).

		(4) REGRA de closure: todo evento produzido por uma phase
		    (completionSignal + integrationEvents) tem >=1 consumidor em
		    consumedBy[].consumes (consumidor pode ser phase OU contexto externo
		    ao conjunto de phases), EXCETO o completionSignal da phase terminal;
		    todo consumedBy[].consumes referencia um evento produzido pela
		    própria phase; consumedBy[].phase, quando presente, existe em
		    phases[].name.

		(5) Schema A — NÃO estender #CrossContextFlow: os dados de closure já
		    vivem no schema; nenhum campo de cadeia é adicionado.

		(6) Os 2 órfãos atuais (BudgetCommitted, CommitmentClosed) são emissões
		    roadmap (consumidores não-materializados) → ficam como warn; o flow
		    commitment-lifecycle NÃO é tocado neste PR.

		(7) NÃO resolver def-031 com este ADR. A letra do texto de def-031
		    amarra a resolução a schema-extension + structural-check que FALHA
		    (reject); este PR entrega check-em-warn + ADR sob Schema A. Logo
		    def-031 permanece "open" (promove a reject quando o flow fechar) e
		    nenhum DD novo é criado — def-031 é o lar do residual. Complementa
		    def-021 (dimensão events↔domain-model), não duplica.
		"""

	consequences: """
		Positivas:
		(P1) O event-storming-reverso vira gate determinístico: um flow cuja
		     cadeia não fecha é flagado pelo check (warn agora), pegando o erro
		     de modelagem mais caro — o que só se revela meses depois, quando o
		     agente constrói em cima.
		(P2) tq-xf-02 (advisory, interpretativo) ganha enforcement determinístico
		     (P10/adr-040) — deixa de depender de design-review por agente.
		(P3) Kind reusável: qualquer flow futuro (o 2º declaredFlow dispara o
		     adjacent-need de def-031) é coberto automaticamente, sem novo kind.
		(P4) PR de classe única (kind + check born-warn), sem tocar o flow
		     canônico nem o schema #CrossContextFlow.

		Negativas:
		(N1) Born-warn pode virar zombie (warn permanente que ninguém promove a
		     reject). Mitigação: def-031 + dd-status rastreiam; a
		     falsificationCondition deste ADR observa o estado.
		(N2) Sem Schema B, a distinção órfão-bug vs órfão-roadmap fica no
		     julgamento do revisor (não estrutural) — aceitável até reject exigir
		     a distinção formal.
		(N3) Kind novo amplia o motor de checks (enum + runner) — blastRadius
		     repo-wide; mitigado pelo precedente (adr-102/105/107, 1 kind/PR) e
		     pela verificação determinística (sc-ccf-03 produz exatamente 2 warns
		     no flow atual).
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			Esta decisão (gate de closure born-warn, Schema A) estará errada SE o
			check gerar falsos-órfãos sistemáticos — emissões roadmap legítimas
			tratadas como erro, afogando o sinal real — OU se o warn nunca for
			promovido a reject (zombie: ninguém fecha os flows nem promove o
			gate), tornando o oráculo decorativo.
			"""
		observableSignal: """
			Razão, nos warns de sc-ccf-03, entre órfãos que são bug de modelagem
			real vs emissões roadmap conhecidas; e o estado de def-031 (promovido
			a reject = o ciclo fechou; eternamente open com warns acumulando =
			zombie).
			"""
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/cross-context-flow.cue",
	]

	principlesApplied: ["P10", "P12"]

	supersedes: []

	rationale: """
		P10 (gates determinísticos validam; agentes estocásticos recomendam): o
		cerne do PR é mover a closure de tq-xf-02 (advisory, interpretativo) para
		um gate determinístico — exatamente a fronteira P10/adr-040. O check
		computa a closure do grafo declarado (produção vs consumo), sem
		interpretação estocástica.

		P12 (governança é código): a regra de closure vira fitness function
		versionada no CI, não convenção lembrada por humanos.

		Por que Schema A (não B): os dados de closure já vivem no
		#CrossContextFlow (completionSignal/integrationEvents/consumedBy.
		consumes); estender o schema com um campo de cadeia seria duplicação
		(contra P0) e YAGNI até a distinção órfão-bug/órfão-roadmap exigir reject.

		Por que born-warn (não reject): o flow commitment-lifecycle tem 2 órfãos
		roadmap hoje; reject agora = born-red, que afoga sinal — o anti-pattern
		que def-019/def-021 evitaram e que o arco cycle-resolution cristalizou
		(sc-cm-07 nasceu warn com ciclos presentes). Catraca adr-097: promove a
		reject quando o flow fechar.

		Por que kind novo (não reuso): closure produção↔consumo é propriedade
		topológica distinta de aciclicidade (directed-acyclicity) e de existência
		cross-file de id (cross-file-id-exists). O kind é inevitável aqui — é o
		ponto do def-031 — diferente do PR-#1 (adr-132), onde o kind novo era
		evitável e foi deliberadamente deferido.

		def-031: a letra (schema-extension + check-que-FALHA) não é integralmente
		entregue por Schema-A + born-warn → def-031 fica open; sem DD novo
		(def-031 é o lar do residual, mesma forma do def-032 no PR-#1).

		Tensão com axiomas: nenhuma.
		"""
}
