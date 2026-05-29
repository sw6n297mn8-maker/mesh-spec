package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr121: artifact_schemas.#ADR & {
	id:    "adr-121"
	title: "Adicionar operator notEquals ao edgeFilters do #DirectedAcyclicityRule (PR-3 cycle-resolution, capability)"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		PR-3 do plano de cycle-resolution (registrado em
		def-026/027/028.triggerCalibrationRationale) precisa aplicar
		Família A nos kinds materializados no PR #84 (adr-118
		bidirectional-orchestration + adr-119 policy-reaction). A
		aplicação concreta no sc-cm-07 exige EXCLUIR do grafo de
		dependência arestas onde o kind está declarado — por design
		"aresta categorizada como bidirectional-orchestration ou
		policy-reaction não é dependência arquitetural cross-BC, é
		acoplamento bidirecional/notification" (def-026 + def-027).

		Schema atual do #DirectedAcyclicityRule.edgeFilters (adr-117
		+ adr-120) suporta {path, equals} e {path, exists}. Composição
		AND entre filters. Não há operator de exclusão por valor — só
		por presença (exists:false) ou inclusão por valor (equals).

		Para excluir kind=policy-reaction (ou
		feedbackLoop.kind=bidirectional-orchestration), o framework
		atual ofereceria:
		- equals: excluiria TUDO exceto o valor — direção invertida.
		- exists:false: excluiria QUALQUER kind declarado — falso-
		  positivo se kinds futuros não-relacionados a cycle forem
		  adicionados.
		- Não há combinação de equals+exists que expresse "exclui se
		  valor == X" preservando "mantém se valor ≠ X ou ausente".

		Família B+ (capability extension paralela a adr-120): adicionar
		operator notEquals como 3ª variante de união discriminada do
		edgeFilters. Custo idêntico ao PR-2 (1 union variant + ~10
		linhas no runner + 4 casos de self-test).

		Tabela de verdade proposta (consistente com Python None != X →
		True):
		- equals: X    — field presente casa: passa | diverge: exclui | ausente: exclui
		- notEquals: X — field presente casa: exclui | diverge: passa | ausente: passa
		- exists: true — presente: passa | ausente: exclui
		- exists: false — presente: exclui | ausente: passa

		Semântica de ausente para notEquals (passa) é dualidade
		correta de equals (exclui), não inconsistência. Ambos operam
		sobre predicado de igualdade; ausência é tratada por design
		como "predicate not satisfied for equals; vacuously true for
		notEquals". Composição AND com exists:true permite expressar
		"exclui kind=X E exige kind presente" sem operator adicional.

		Este ADR é apenas capability (infraestrutura). NÃO aplica em
		nenhuma instância concreta — aplicação é adr-122 (Família A
		instances + edgeFilters novos no sc-cm-07).

		Alternativas consideradas e rejeitadas:

		(a) Inverter sc-cm-07 inteiro: substituir edgeFilters por
		includeKinds/excludeKinds allow/deny-lists. REJEITADA: refactor
		invasivo do framework; perde uniformidade equals/exists/
		notEquals; cria dois sistemas paralelos de filter (per-path vs
		per-kind global).

		(b) Adicionar field excludeFromAcyclicityGraph: bool em
		relationships. REJEITADA: tag boolean esconde semântica per-
		kind atrás de flag opaco; viola P0 (vocabulário canônico:
		kind expressa NATUREZA da aresta; flag esconderia per-aresta
		por que foi excluída); cria precedente de tags ad-hoc.

		(c) Critério rigoroso via combinação equals composta com
		valor sentinel (e.g., equals: "<not-policy-reaction>" em
		múltiplos filters). REJEITADA: mesma gambiarra rejeitada em
		adr-120 alternativa (d) — mistura semântica de presença com
		semântica de igualdade; depende de convenção lexical.

		(d) Operators present + absent separados em vez de exists:
		bool binary (capability redesign retrospectivo). REJEITADA:
		mesma análise de adr-120 alternativa (b) — minimalismo
		preferido; exists: bool já cobre presence/absence; notEquals
		é dimensão ortogonal (igualdade, não presença).
		"""

	decision: """
		Estender architecture/artifact-schemas/structural-check.cue +
		scripts/ci/structural-check-runner.py com 2 mudanças atômicas:

		(1) [capability-extension] Estender #DirectedAcyclicityRule.
		edgeFilters de união discriminada 2-way para 3-way:
		  edgeFilters: [...({
		      path:   string & !=""
		      equals: string & !=""
		  } | {
		      path:   string & !=""
		      exists: bool
		  } | {
		      path:      string & !=""
		      notEquals: string & !=""
		  })]

		Filter atomicamente é OU {path, equals} OU {path, exists} OU
		{path, notEquals}. Não permite combinação dentro da mesma
		entry (discriminação por presença do campo: equals vs exists
		vs notEquals). Filters compostos continuam AND-compostos via
		lista.

		(2) [runner-implementation] Estender ev_directed_acyclicity
		em scripts/ci/structural-check-runner.py para 3-way
		discrimination:
		  - "equals" in fl: dotget != equals → exclui
		  - "exists" in fl: missing per exists:true → exclui; present
		    per exists:false → exclui
		  - "notEquals" in fl: dotget == notEquals → exclui (ausente
		    passa vacuously)

		Adicionar 4 casos no --self-test:
		  - sc-g-05: notEquals presente diferente → mantém aresta;
		    ciclo detectado preserved (regression-positive)
		  - sc-g-06: notEquals presente igual → exclui aresta; ciclo
		    quebrado (capability-positive)
		  - sc-g-07: notEquals ausente → mantém aresta (semântica
		    vacuously-true; explicit test ratifica decisão)
		  - sc-g-08: AND-composto equals + exists + notEquals
		    (3-operator combinatorial regression)

		Regression dos operators pré-existentes (equals, exists:true,
		exists:false, equals+exists AND-composto) coberta por sc-g-
		01..04 do PR-2.

		Este ADR é apenas capability (infraestrutura). NÃO toca:
		- architecture/structural-checks/context-map.cue (instance —
		  fica para adr-122)
		- strategic/context-map.cue (arestas — fica para adr-122)
		- def-XXX status (resolução fica para adr-122 + adr-123)
		- enforcement do sc-cm-07 (warn→reject fica para adr-123)
		"""

	consequences: """
		Positivas:
		(P1) Capability genérica reusável: operator notEquals completa
		o álgebra básico de igualdade no framework de edgeFilters (par
		dual com equals). Pattern paralelo a adr-120 (exists: bool).
		Qualquer futuro consumidor de directed-acyclicity (work-graph,
		cross-context-workflows, ADR supersedes graph) herda capability.

		(P2) Ortogonalidade com operators existentes: equals (inclusão
		por valor), exists (predicado de presença), notEquals (exclusão
		por valor). Cobertura completa do espaço básico de filters
		predicate-based sobre string field. Composição AND permite
		expressar conjunções; nenhuma necessidade de operator OR
		atualmente (cycle-resolution não precisa).

		(P3) Resolve necessidade arquitetural concreta no PR-3
		(aplicação Família A) sem refactor do framework. Custo
		marginal: 1 union variant + ~10 linhas no runner + 4 casos
		self-test.

		(P4) Preserva minimalismo per adr-041: notEquals é primitiva
		mínima necessária para excluir kinds typed. Operators mais
		complexos (notIn, matches, gt/lt) ficam para ADRs follow-on
		quando caso concreto emergir (pattern adr-049/056/063).

		Negativas:
		(N1) Schema do #DirectedAcyclicityRule cresce: edgeFilters
		passa de união 2-way para 3-way. Custo marginal em cue vet.
		Pattern de extensão orgânica estabelecido (adr-117 + adr-120 +
		este).

		(N2) Asimetria explícita entre equals e notEquals quanto a
		field ausente:
		  - equals: X — ausente exclui (predicate "= X" não satisfeito)
		  - notEquals: X — ausente passa (predicate "≠ X" vacuously
		    satisfeito)
		Dualidade matemática correta. Documentada na tabela de verdade
		inline no comentário do schema; composição com exists:true
		permite strictness se necessária no futuro.

		(N3) Risco hipotético de drift entre operator semantics e
		expectativa intuitiva: futuro autor de check pode esperar
		notEquals strict (ausente exclui per SQL convention).
		Mitigação: tabela de verdade explícita no comentário do
		schema; self-test sc-g-07 ratifica a semântica
		comportamentalmente.

		Known gaps declarados:
		- notIn (notEquals para conjunto de valores), matches (regex),
		  ordering operators (gt/lt) NÃO introduzidos. Pattern adr-041:
		  primitiva mínima; emergem em ADRs follow-on conforme caso
		  concreto.
		- OR-composition entre filters NÃO introduzida (atualmente
		  AND-only via lista). Lista de filters é AND; OR ficaria para
		  futuro ADR se padrão emergir.

		Fronteira regulatória: nenhuma. Decisão meta-estrutural sobre
		framework interno. Sem efeito em Bacen/SCD/LGPD/KYC/AML.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
	]

	principlesApplied: ["P0", "P1", "P12"]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0 (uma localização canônica): operator notEquals vive no schema
		structural-check.cue como SoT única; runner consume shape sem
		duplicar semântica; sc-cm-07 (adr-122) referencia o schema.

		P1 (CUE como SoT de contratos): operator declarativo no schema;
		runner consume estritamente o que está declarado. Tabela de
		verdade documentada inline no comentário do schema (consumível
		por humano + qualquer agent vendo o schema).

		P12 (governança como código): exclusão por valor expressa via
		operator declarativo, não via convenção lexical (e.g., valor
		sentinel) nem via flag boolean (excludeFromGraph).

		Failure mode evitado: usar exists:false como proxy de exclusão
		por kind (overly broad — excluiria QUALQUER kind futuro) ou
		introduzir flag boolean por relationship (esconde semantic-per-
		kind atrás de flag opaco).

		Tensão com axiomas: nenhuma tensão substantiva. ax-03 (pagar
		custo de complexidade cedo) confirmado: capability genérica
		notEquals adiciona ortogonalidade ao framework vs operator
		narrow específico-de-uso.

		Lenses consultadas:
		- lens-graph-theory-fundamentals: filter operators sobre
		  predicate de igualdade são primitivas-padrão em graph query
		  languages (Cypher, GQL); cobertura equals + notEquals + exists
		  alinha com convenção estabelecida.

		Relacionamento com def-026/027 (criados em PR #83, mantidos
		em status open): este ADR é precondição infraestrutural para
		adr-122 (aplicação). def-026/027 são resolvidos por adr-122,
		NÃO por este ADR — semântica estrita defersTo (pattern adr-118/
		119/120). defersTo NÃO usado (def-026/027 criados em PR
		anterior).

		Relacionamento com adr-122 (mesmo PR): adr-121 é precondição
		infraestrutural; adr-122 é primeiro consumidor + resolve
		def-026/027 substantivamente. Documentado em prose; sem field
		schema novo necessário.
		"""
}
