package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr117: artifact_schemas.#ADR & {
	id:    "adr-117"
	title: "Adicionar kind directed-acyclicity ao framework structural-check"
	date:  "2026-05-28"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Diagnóstico de arquitetura (sessão 2026-05-28) revelou que o aparato
		de structural-checks do context-map cobre integridade referencial
		intra-arquivo (sc-cm-01..04: local-field-reference-integrity),
		descoberta filesystem→map (sc-cm-05: filesystem-declared-coverage) e
		coerência cross-file de events (sc-cm-06: scoped-cross-file-id-exists),
		mas nenhum check executa análise topológica sobre o grafo dirigido
		que as 47 relationships do context-map formam. Em particular, ciclo
		de dependência entre bounded contexts — propriedade emergente do
		fechamento transitivo das arestas — é invisível ao cue vet e aos
		18 kinds de #StructuralCheck existentes.

		dp-03 (blast radius) declara: "Isolamento entre tenants, entre
		bounded contexts e entre operações é invariante estrutural, não
		otimização." Dependência circular cross-BC viola esse invariante:
		dois ou mais BCs ficam ligados num laço em que mudança em um
		propaga para o(s) outro(s) sem ordem topológica de deploy
		(sintoma direto do acoplamento). Princípio existe, instrumento
		automático de verificação não.

		Diagnóstico empírico do grafo atual (47 relationships, filtrado
		para direction='upstream-downstream' entre dois bounded-contexts:
		45 arestas, 21 nós): 4 ciclos detectados, dois deles de 2-BC
		(drc↔cmt, fce↔tcm) e dois de 4-BC (cmt→rew→dlv→bdg→cmt;
		fce→drc→cmt→rew→fce). Esses ciclos podem refletir realidade do
		domínio econômico em loop (típico de sistemas financeiros) que
		exige redesenho de fronteira (e.g., promover aresta a
		direction='mutual-dependency', ou modelar policy reaction em vez
		de dependência direta), mas a decisão é design DDD profunda e
		separada deste ADR. O ADR não resolve os ciclos — instala o
		instrumento que os torna visíveis.

		Alternativas consideradas e rejeitadas:

		(a) Kind dedicado context-map-acyclicity hard-coded para o
		artefato context-map. Embutiria a lista de patterns simétricos
		({partnership, shared-kernel}) no código Python. Rejeitada:
		nenhum kind atual é específico de um único schema (exceto
		domain-invariant que itera contexts/*/domain-model.cue por
		design); todos os 17 outros generalizam por path/glob declarativo.
		Rompe o padrão. Também acopla o evaluator ao vocabulário
		específico de patterns DDD; se o schema do context-map evoluir
		(novo pattern simétrico), o evaluator precisa ser tocado.

		(b) Kind genérico directed-acyclicity com filtros declarativos.
		Aresta entra no grafo se TODOS os edgeFilters {path, equals}
		casarem. Aderente ao pattern dos 18 kinds existentes
		(local-field-reference-integrity, cross-file-id-exists, etc.).
		ESCOLHIDA — instanciada primeiro pro context-map (sc-cm-07).
		Reuso futuro provável em outros grafos do repo (work-graph
		dependências entre WIs, cross-context-workflows dependências
		entre flows, ADRs supersedes formando DAG).

		(c) Aceitar gap, manter cycle detection como advisory
		(validation-prompt). Rejeitada: per adr-040 split,
		propriedade topológica é determinística por construção (depende
		apenas do estado declarado do artefato). Pertence ao gate
		structural, não advisory. Validation-prompts cobrem dimensões
		interpretativas.

		(d) Adicionar OR-composto em edgeFilters (allOf/anyOf). Rejeitada
		(para v1): AND-composto cobre 100% do caso atual (context-map
		precisa de 3 filtros AND). YAGNI per adr-041 (minimalismo
		deliberado de kinds e shapes). Se o segundo consumidor real
		precisar de OR, expansão futura.

		Descoberta importante durante o desenho (sessão 2026-05-28):
		o schema #BaseRelationship carrega um discriminador explícito
		'direction' (= "upstream-downstream" | "mutual-dependency"),
		fixado por união discriminada nas variantes
		#InternalBaseRelationship vs #InternalSymmetricRelationship.
		Logo, filtrar arestas por direction é mais robusto que
		enumerar patterns simétricos {partnership, shared-kernel}: se
		um terceiro pattern simétrico surgir, ele ganhará automaticamente
		direction='mutual-dependency' e o check continua correto sem
		edição.
		"""

	decision: """
		Estender #StructuralCheck adicionando 1 novo kind 'directed-acyclicity':

		(1) [kind-extension] Adicionar 'directed-acyclicity' ao
		#StructuralCheckKind, à união discriminada de #StructuralCheck,
		e ao #StructuralCheckRule. Pattern paralelo a adr-049, adr-056,
		adr-063, adr-076, adr-080.

		(2) [rule-shape] Definir #DirectedAcyclicityRule com 5 campos:
		  - nodesPath: path multi-valor enumerando ids dos nós
		    (suporta travessia "[]"; e.g., "contexts[].context").
		  - edgesPath: path multi-valor enumerando arestas (itens-
		    struct; e.g., "relationships[]").
		  - edgeSource: path dot-separated DENTRO de cada item de
		    edgesPath para o id do nó-origem da aresta direcionada
		    (semântica de dependência: origem = quem depende).
		  - edgeTarget: path dot-separated DENTRO de cada item para
		    o id do nó-destino (= quem é dependido).
		  - edgeFilters: lista de {path, equals} AND-compostos.
		    Aresta entra no grafo apenas se TODOS casarem. Lista
		    vazia = nenhum filtro.

		(3) [runner-implementation] ev_directed_acyclicity em
		scripts/ci/structural-check-runner.py + helper _find_cycles
		(DFS clássico com cores, back-edge detecta ciclo, caminho
		extraído da pilha). Determinístico: nós e arestas processados
		em ordem alfabética. Cada ciclo reportado como linha legível
		(caminho dos nós + codes das arestas se disponíveis).

		(4) [self-test-extension] Quatro casos sintéticos cobrindo:
		grafo acíclico (pass), ciclo 2-nós (detect), ciclo 4-nós
		(detect), aresta filtrada que criaria ciclo (pass).

		(5) [first-instance] sc-cm-07 em
		architecture/structural-checks/context-map.cue. artifactType
		context-map. Filtros declarados: direction=upstream-downstream,
		source.kind=bounded-context, target.kind=bounded-context.
		Direção da aresta: edgeSource=target.context,
		edgeTarget=source.context (downstream → upstream, semântica
		DDD de dependência).

		(6) [born-warn explícito] enforcement=warn. Há 4 ciclos pré-
		existentes no grafo atual (drc↔cmt, fce↔tcm, cmt→rew→dlv→bdg→
		cmt, fce→drc→cmt→rew→fce); promoção para reject ocorrerá
		em ADR follow-on dedicado após cada ciclo ser resolvido em
		PR de modelagem separado (decisão de design DDD que cabe
		ao founder, fora do escopo deste ADR). Catraca adr-097
		aplicada: nasce não-bloqueante, promove quando comprovadamente
		verde.

		OR-composto em edgeFilters NÃO coberto em v1. Caso futuro
		exigir, expansão tratada como segundo consumidor real
		(princípio adr-062: consolidar no segundo consumidor
		concreto). Não registrado como deferred-decision agora
		porque não há trigger empírico de revisita.
		"""

	consequences: """
		Positivas:
		(P1) Lacuna estrutural identificada (diagnóstico 2026-05-28)
		fechada: ciclos de dependência cross-BC tornam-se visíveis ao
		gate determinístico. dp-03 (blast radius) ganha instrumento de
		verificação automático.

		(P2) Kind genérico vs dedicado escolhido (Opção C): primeiro
		consumidor é context-map (sc-cm-07), mas o shape declarativo
		(nodesPath/edgesPath/edgeFilters) generaliza para outros
		grafos do repo. Reuso futuro provável em: work-graph
		(dependências entre WIs via #ExecutionDependency.dependsOn),
		cross-context-workflows (dependências entre flows), ADRs
		(supersedes formando DAG cuja inversão é forbidden).

		(P3) Filtro por direction (não por enumeração de patterns
		simétricos) é robusto a evolução do schema do context-map: se
		um terceiro pattern simétrico surgir, ganha automaticamente
		direction='mutual-dependency' por união discriminada e o
		check continua correto sem edição do rule.

		(P4) Maintain framework minimalism per adr-041: kind narrow
		específico (propriedade topológica), não generic catch-all.

		(P5) Pattern de auditoria preservado: runner reporta o caminho
		concreto do ciclo + codes das arestas, permitindo ao autor
		localizar exatamente quais relationships participam.

		Negativas:
		(N1) Schema #StructuralCheck cresce 18 → 19 kinds. Pattern
		estabelecido em adr-049, adr-056, adr-063, adr-076, adr-080
		prevê expansão orgânica; custo é proporcional ao caso concreto.

		(N2) v1 do kind não suporta OR-composto em edgeFilters. Caso
		futuro que exigir (improvável dado o uso atual) requer
		expansão do schema. Aceito como YAGNI consciente.

		(N3) v1 do kind não reporta SCCs (componentes fortemente
		conexos) — reporta cada ciclo individual encontrado pelo DFS.
		Para grafos com múltiplos ciclos sobrepostos, alguns ciclos
		podem ser rotações redundantes do mesmo SCC. Aceitável para
		v1 (output ainda é acionável); refinamento futuro via Tarjan
		se diagnóstico real demandar.

		(N4) Output do runner inclui codes das arestas quando os
		itens-fonte têm campo "code" (heurística). Para edgesPath
		cujos itens não têm "code", apenas o caminho dos nós é
		reportado. Heurística aceitável para v1; campo declarativo
		(edgeIdField?) pode ser adicionado quando segundo consumidor
		real precisar.

		Known gaps declarados:
		- Resolução dos 4 ciclos pré-existentes no grafo atual:
		  drc↔cmt, fce↔tcm, cmt→rew→dlv→bdg→cmt, fce→drc→cmt→rew→fce.
		  Cada ciclo exige decisão de design DDD separada (promover a
		  mutual-dependency, redesenhar aresta como policy reaction,
		  ou aceitar redesenho de fronteira). NÃO registrado como
		  def-XXX porque o trigger codificado seria "ciclo resolvido",
		  o que não é machine-evaluable de forma simples (depende de
		  edição manual do context-map por humano com critério DDD).
		  Promoção sc-cm-07 warn→reject ocorrerá em ADR follow-on
		  quando todos os ciclos forem resolvidos.

		- Reporte mais sofisticado (SCC via Tarjan, edge label
		  configurável). NÃO registrado como def-XXX porque não há
		  caso concreto que justifique agora.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre framework de validação interno.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/context-map.cue",
	]

	plannedOutputs: [
		"architecture/structural-checks/context-map.cue",
	]

	defersTo: []

	principlesApplied: [
		"P0",
		"P1",
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P10 (gates determinísticos validam, agentes recomendam) é o
		driver primário: aciclicidade de grafo dirigido é propriedade
		decidível em tempo polinomial sobre estado declarado do
		artefato. Pertence ao gate structural per adr-040 split, não
		advisory. Tratar como advisory seria categórico erro do split.

		P12 (governança como código): kind directed-acyclicity
		formaliza disciplina que antes era prose ('grafo de dependência
		cross-BC deveria ser acíclico'). Schema enforce shape; runner
		enforce semantics; output legível enforce diagnóstico
		acionável.

		P0 (uma localização canônica): directed-acyclicity é a
		localização canônica para checks topológicos de aciclicidade.
		Não dispersa semantics em múltiplos kinds (e.g., um por tipo
		de grafo).

		P1 (CUE como SoT): kind + rule shape declarativos em CUE
		schema; runner consome shape via path multi-valor + filtros
		declarativos. Pattern paralelo aos kinds local-field-reference-
		integrity (adr-100), cross-file-id-exists (adr-102),
		scoped-cross-file-id-exists (adr-105).

		Failure mode evitado: gap entre intent ('grafo de dependência
		entre BCs é acíclico, per dp-03 blast radius') e enforcement
		(nenhum mecanismo). Sem este check, ciclos crescem por
		acréscimo silencioso de relationships — cue vet e os
		structural-checks existentes passam, o invariante DDD é violado
		em runtime quando o deploy não topologicamente-ordenável é
		descoberto empiricamente.

		Tensão com axiomas: nenhuma tensão substantiva. ax-03 (pagar
		custo de complexidade cedo) é confirmado: kind genérico é
		marginalmente mais caro que dedicado agora, paga depois quando
		work-graph/cross-context-workflows precisarem.

		Lenses consultadas:

		lens-real-options: ESCOLHIDA opção genérica (C) sobre dedicada
		(A) porque preserva opcionalidade — futuro consumidor reaproveita
		sem refactor de schema. Custo marginal pequeno (~50 linhas no
		evaluator); opção real preservada não-trivial.

		lens-distributed-systems-design: dependência circular cross-BC
		é anti-pattern bem documentado (lente cita ordering de deploy,
		isolamento de falha, recovery independente). Confirma que o
		invariante a verificar é genuíno.
		"""
}
