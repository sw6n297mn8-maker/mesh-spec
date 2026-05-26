package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr099: artifact_schemas.#ADR & {
	id:    "adr-099"
	title: "Camada de meta-cobertura: evaluator-coverage (M1) + structural-check-coverage (M2)"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		A descoberta original do audit: o repositório é rígido na ESCRITA (cue vet
		recusa CUE torto) mas frouxo na FISCALIZAÇÃO — dezenas de regras existem como
		"cartaz na parede" sem funcionário que as execute; a conferência dependia de
		um agente lembrar de olhar à mão (foi assim que 14 work-events sem task-spec
		passaram ~5 semanas). adr-096/097 deram um runner real que roda no CI e
		bloqueia em reject; adr-090/098 fizeram a estrutura se auto-mapear e travaram
		órfão/phantom. Falta responder a pergunta de fecho: como GARANTIR que toda
		regra tem robô, que os robôs cobrem tudo, e que o que ainda vai existir já
		nasce coberto?

		Medição do estado real: dos 10 kinds de check, todos os usados têm evaluator
		(M1 nasce verde). Mas só 8 de ~38 tipos governados têm structural-check
		comportamental — ~30 dependem só de cue vet (forma) + gate de órfão
		(existência). Não há meta-gate que torne essa lacuna visível nem que impeça
		um tipo novo de nascer descoberto.

		Distinção central (e limite honesto): COBERTURA (existe um robô para X?) é
		decidível e mecanizável; ADEQUAÇÃO (o robô fiscaliza a coisa certa? a regra
		é suficiente?) NÃO é mecanizável — é P10/ten-006 (gate determinístico não
		julga semântica). Adequação fica com a camada advisory (validation-prompts)
		+ review do founder + SRR + red-team. Esta decisão ataca só COBERTURA.

		Alternativa REJEITADA: autorar a lista de tipos cobertos (como o
		coveredSchemas do sc-pg-01). Reprovada — a própria lista envelhece e mente
		(é nova superfície de drift, o oposto do adr-090). M2 DERIVA o conjunto de
		tipos dos _schema.location. Segunda alternativa REJEITADA: hardcode da
		introspecção no runner sem check declarativo — recriaria o débito que o
		adr-098 removeu (GOVERNED_ELSEWHERE).
		"""

	decision: """
		Camada de meta-cobertura (fiscais que fiscalizam a folha dos fiscais), via 2
		structural-checks declarativos novos, born-warn (catraca adr-097):

		(1) Schema (#StructuralCheck): 2 kinds novos —
		    - evaluator-coverage + #EvaluatorCoverageRule {checkSchemaPath}
		    - structural-check-coverage + #StructuralCheckCoverageRule {exemptTypes:[{type,rationale}]}

		(2) Runner: 2 evaluators registrados em EVAL —
		    - ev_evaluator_coverage (M1): todo kind declarado no enum
		      #StructuralCheckKind (lido de checkSchemaPath) + todo kind usado por
		      algum check tem evaluator em EVAL. Cartaz sem fiscal = finding. Sem
		      isenção (declarar regra sem robô é sempre erro).
		    - ev_sc_coverage (M2): tipos governados DERIVADOS dos _schema.location
		      (basenames dos schemas que governam instâncias); coberto = existe
		      check com artifactType correspondente; exemptTypes (com rationale)
		      removem os adequadamente cobertos só por cue vet + gate de órfão.

		(3) Instâncias (architecture/structural-checks/meta-coverage.cue): sc-meta-01
		    (evaluator-coverage) e sc-meta-02 (structural-check-coverage), ambos
		    enforcement "warn". sc-meta-02.exemptTypes nasce VAZIO de propósito: o
		    inventário em warn (~30 tipos) é o backlog explícito para triagem.

		(4) Fixpoint (termina a recursão "quem fiscaliza os fiscais"): M1/M2 são
		    checks rodados pelo mesmo runner, usando o mesmo conjunto pequeno de
		    evaluators que verificam — M1 cobre os kinds que M1/M2 usam; M2 cobre o
		    tipo structural-check (que já tem check). Núcleo pequeno, auditado uma
		    vez, auto-mantido (análogo ao mapa auto-desenhado do adr-090).

		FORA DE ESCOPO (follow-on): promover sc-meta-01/02 a reject (só após triar
		os ~30 → check-ou-isenção, garantindo zero); M3 (asserção de que o runner
		está de fato invocado no validate.yml — liveness do workflow); e a
		pré-condição de cascata "tipo novo só passa com seu check/isenção"
		(extensão da regra PG-antes-de-instância) que torna o FUTURO coberto por
		construção. Esta decisão entrega só a VISIBILIDADE (warn).
		"""

	consequences: """
		Positivas: (1) a lacuna de cobertura comportamental (~30 tipos) vira
		inventário explícito em vez de ponto cego; (2) declarar um kind sem evaluator
		passa a ser finding (M1 fecha rule→robô); (3) ausência de check por tipo vira
		decisão registrada (exemptTypes com rationale), nunca acidente; (4) a regra
		vive em check declarativo (P0), não em hardcode no runner; (5) o conjunto de
		tipos é derivado (M2 não herda o drift da whitelist autorada do sc-pg-01).

		Negativas: (1) born-warn não impede NADA ainda — só dá visibilidade (mitigado:
		é deliberado; promoção a reject vem após triagem, dp-07 sem big-bang); (2) o
		mapeamento tipo↔check é por convenção basename↔artifactType — um schema cujo
		basename divirja do artifactType usado apareceria como falso descoberto
		(triável via exemptTypes); (3) M1/M2 cobrem COBERTURA, não ADEQUAÇÃO — não
		provam que as regras são suficientes (isso é da camada advisory; declarado
		explicitamente para não criar falsa confiança).
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/meta-coverage.cue",
	]

	principlesApplied: [
		"P10 — gates validam, agentes/humanos recomendam: M1/M2 mecanizam COBERTURA (decidível); ADEQUAÇÃO fica explicitamente na camada advisory (ten-006)",
		"P0 — localização canônica única: meta-cobertura vive em checks declarativos + conjunto de tipos DERIVADO, não autorado nem hardcoded",
		"adr-097 — born-warn + catraca: M1/M2 nascem não-bloqueantes, promoção por evidência",
		"adr-090 — derivar em vez de autorar: o conjunto de tipos vem dos _schema.location, não de whitelist",
		"dp-07 — evolução sem big-bang: visibilidade primeiro (warn), promoção após triagem",
	]

	defersTo: []

	rationale: """
		decisionClass structural: adiciona 2 kinds + 2 rule shapes ao #StructuralCheck,
		2 evaluators ao runner e 2 instâncias — aplica P0/P10/adr-090/adr-097 sem
		redefinir princípios. reversibility medium (aditivo + born-warn, mas desfazer
		envolve schema + runner + instâncias); blastRadius repo-wide (meta-gate sobre
		toda a camada de fiscalização).

		Verificado antes da proposta: cue vet ./... EXIT 0; runner --self-test PASS;
		runner default → sc-meta-01 verde (0 kinds sem evaluator), sc-meta-02 lista
		~30 tipos sem check comportamental, ambos enforcement warn => 0 bloqueantes,
		exit 0 (não quebra o CI). A entrega é a visibilidade da lacuna de cobertura,
		não o seu fechamento — esse é o follow-on (triar → check-ou-isenção → promover).
		"""
}
