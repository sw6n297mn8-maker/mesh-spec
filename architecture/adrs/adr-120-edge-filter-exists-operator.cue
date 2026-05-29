package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr120: artifact_schemas.#ADR & {
	id:    "adr-120"
	title: "Adicionar operator exists ao edgeFilters do #DirectedAcyclicityRule + filter events-required no sc-cm-07 (PR-2 cycle-resolution)"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		def-028 (registrado em PR #83 mergeado em 2026-05-29) articulou
		a decisão DDD para resolver W4 (fce → tcm → fce, 2-BC) do
		sc-cm-07 (directed-acyclicity, adr-117) como Família B da
		taxonomia: filter sobre dado existente no context-map (não
		extensão de vocabulário do schema). Evidência: subdomain TCM
		"TCM projeta e planeja; FCE executa. Projeção é prospectiva;
		pagamento é efetivo. Fusão misturaria planejamento com execução
		— cadências e responsabilidades distintas"; subdomain FCE "FCE
		utiliza informações de disponibilidade fornecidas por TCM para
		otimizar execução, sem assumir gestão de posição de caixa". A
		aresta tcm-to-fce é call-site operacional (sync query), não
		dependência arquitetural.

		Schema atual do #DirectedAcyclicityRule.edgeFilters (adr-117)
		suporta APENAS {path, equals: string} — igualdade simples. Não
		expressa presence/absence de field. Para excluir query-surface
		(critério canônico: aresta sem events publicados) precisa de
		operator novo. Investigação prévia do context-map (47 arestas)
		identificou exatamente 4 arestas sem events: tcm-to-fce (W4) +
		3 outras query-surfaces benignas (idc-to-log, idc-to-dlv,
		npm-to-ctr).

		Tese canônica subjacente (alinhada com canvas REW "decisão ≠
		execução" + def-028 + DDD orthodoxy event-driven): no
		event published = no architectural dependency edge cross-BC.
		Query-surface é call-site sync que retorna info via query
		(operacional), não dependência estrutural que liga lifecycle
		de BCs. Filter genérico "events exists" expressa esta tese
		de forma declarativa.

		Generalização proativa (NÃO side-effect): o filter aplicará
		uniformemente nas 4 arestas sem events, não só em tcm-to-fce.
		Isto INTERNALIZA o scan complementar previsto em
		def-028.triggerCalibrationRationale, reduzindo o escopo do
		PR-3 (que originalmente carregaria responsabilidade de
		identificar e validar outras query-surfaces). PR-3 agora só
		precisa CONFIRMAR que nenhuma das 3 não-W4 esconde coupling
		arquitetural — confirmação simples per inspeção de subdomain
		owner intent.

		Este ADR é o passo 2 (PR-2) do plano de PRs registrado em
		def-028.triggerCalibrationRationale, paralelo a:
		- PR-1: adr-118 + adr-119 (mergeados em #84) — schema
		  extensions Família A (vocabulário novo)
		- PR-2 (este ADR): capability extension + filter Família B
		- PR-3: aplicação Família A nas arestas concretas + scan
		  confirmação das 3 query-surfaces + promoção sc-cm-07
		  warn → reject. PR-3 resolverá def-026/027/028.

		Este ADR NÃO resolve def-028 — só materializa o filter
		(infraestrutura). Resolução ocorre em PR-3 quando founder
		marcar def-028.status = resolved com resolvedBy apontando
		para o ADR de PR-3. defersTo schema field NÃO usado (mesma
		análise de adr-118/119 em PR #84): def-028 foi criado em PR
		#83 anterior, não por este ADR (semântica estrita per schema
		#ADR.defersTo description "Deferimentos conscientes governados
		CRIADOS por esta decisão").

		Alternativas consideradas e rejeitadas:

		(a) Critério rigoroso de 3 condições compostas (sync AND
		queries declarado AND events not-exists) fielmente ao texto
		de def-028. REJEITADA: requer 2 conceitos novos no schema
		— operator exists + campo edgeExcludeFilters (lógica "exclude
		if all match"). Cobertura idêntica a Opção β nas 47 arestas
		atuais (mesmas 4 são excluídas). Custo arquitetural maior
		sem ganho prático. Generalização "events exists" é mais
		canônica DDD que a conjunção sintática 3-condições.

		(b) Operators present + absent separados (em vez de binary
		exists). REJEITADA: dobra a superfície de capability (2
		novos conceitos vs 1). Binary exists: bool é primitiva
		mínima — true expressa presença, false expressa ausência.
		Alinha com pattern adr-041 minimalismo.

		(c) Filter ad-hoc por path específico (e.g., {excludeEdgePath:
		"tcm-to-fce"} hard-coded). REJEITADA: anti-DRY; não generaliza;
		viola P0 (vocabulário canônico); requer ADR per query-surface
		futura.

		(d) Estender semântica de "equals" para aceitar valores
		especiais (e.g., equals: "<absent>"). REJEITADA: gambiarra;
		mistura semântica de presença com semântica de igualdade;
		incompatível com tipo string puro do schema atual.
		"""

	decision: """
		Estender architecture/artifact-schemas/structural-check.cue +
		scripts/ci/structural-check-runner.py + architecture/
		structural-checks/context-map.cue com 3 mudanças atômicas:

		(1) [capability-extension] Estender #DirectedAcyclicityRule.
		edgeFilters de struct fechado para união discriminada:
		  edgeFilters: [...({
		      path:   string & !=""
		      equals: string & !=""
		  } | {
		      path:   string & !=""
		      exists: bool
		  })]

		Filter atomicamente é OU {path, equals} OU {path, exists}.
		Não permite combinação (forma é union discriminada por
		presença do campo equals vs exists). Filters compostos
		continuam AND-compostos via lista.

		(2) [runner-implementation] Estender ev_directed_acyclicity
		em scripts/ci/structural-check-runner.py para discriminar:
		  - Se filter tem chave "equals": dotget(item, path) !=
		    equals → exclui (comportamento existente)
		  - Se filter tem chave "exists":
		    - exists: true: dotget retorna None → exclui
		    - exists: false: dotget retorna não-None → exclui

		Adicionar 3 casos no --self-test cobrindo: exists:true presente
		passa + ciclo detectado (sc-g-02 sobre exist-pres.cue);
		exists:true ausente exclui aresta cíclica (sc-g-02 sobre
		exist-abs.cue); AND-composto equals+exists em filters
		separados (sc-g-03); exists:false inverso (sc-g-04 sobre
		exist-inv.cue). Regression do equals puro coberta pelo
		sc-g-01 pré-existente.

		(3) [first-consumer] Adicionar 4ª entrada nos edgeFilters do
		sc-cm-07 (architecture/structural-checks/context-map.cue):
		  edgeFilters: [
		      {path: "direction",   equals: "upstream-downstream"},
		      {path: "source.kind", equals: "bounded-context"},
		      {path: "target.kind", equals: "bounded-context"},
		      {path: "events",      exists: true},   // ← novo
		  ]

		Resultado factual no grafo atual (validado em Fase 1 sobre
		as 47 arestas):
		  - tcm-to-fce: sem events → EXCLUÍDA → resolve W4
		  - idc-to-log, idc-to-dlv, npm-to-ctr: também sem events
		    (query-surfaces benignas) → EXCLUÍDAS → generalização
		    proativa do critério, não side-effect
		  - 43 arestas restantes (todas com events) → mantidas
		  - Ciclos remanescentes esperados: W1 (drc↔cmt), W2
		    (cmt→rew→dlv→bdg→cmt), W3 (fce→drc→cmt→rew→fce)
		  - sc-cm-07 reporta 3 WARN (vs 4 anteriores) após PR-2

		Também atualizar errorMessage e rationale do sc-cm-07
		mencionando exclusão de query-surfaces, e atualizar
		comentário do edgeFilters em #DirectedAcyclicityRule
		mencionando o novo operator.

		Este ADR é apenas capability + filter (infraestrutura). NÃO
		toca:
		- strategic/context-map.cue (arestas concretas; nada para
		  editar aqui, filter age sobre dado existente)
		- def-028 instance (resolução em PR-3 via resolvedBy →
		  adr-resolver-em-pr-3)
		- promoção sc-cm-07 warn → reject (vem em PR-3 após Família A
		  ser aplicada)
		"""

	consequences: """
		Positivas:
		(P1) Capability genérica reusável: operator exists adiciona
		dimensão "presence/absence" ao framework de edgeFilters. Não é
		específico a context-map — qualquer futuro consumidor de
		directed-acyclicity (work-graph, cross-context-workflows,
		ADR supersedes) herda capability. Pattern paralelo a
		adr-049/056/063/076/080/117/118/119 (extensão orgânica de
		framework de check).

		(P2) Generalização DDD canônica: "no event published = no
		architectural dependency edge cross-BC" é tese sólida em
		event-driven design. Filter declarativo expressa intent sem
		hard-coding por path. Alinha com canvas REW ("decisão ≠
		execução"), subdomain TCM ("projeta não executa"), e DDD
		orthodoxy (event publishing é o contract; query-surface é
		operacional).

		(P3) Redução proativa do escopo do PR-3: as 4 query-surfaces
		(tcm-to-fce + 3 outras) são excluídas uniformemente. PR-3
		originalmente carregaria responsabilidade de scan complementar
		(per def-028.triggerCalibrationRationale: "identify outras
		query-surfaces candidates"); essa identificação é agora
		automatic via filter. PR-3 só precisa CONFIRMAR que nenhuma
		das 3 não-W4 esconde coupling — confirmação simples
		(inspeção de subdomain owner intent).

		(P4) Resolve W4 (fce↔tcm) limpamente: o único ciclo do
		Família B é fechado por filter declarativo, sem editar
		strategic/context-map.cue nem schema do context-map. Custo
		zero em propagação.

		(P5) Binary operator (exists: bool) preserva minimalismo per
		adr-041 — single concept expressa both presence e absence.
		Schema cresce 1 union variant; runner cresce ~10 linhas. Custo
		marginal.

		Negativas:
		(N1) Schema do #DirectedAcyclicityRule cresce: edgeFilters
		passa de struct fechado para união discriminada (1 nova
		variante {path, exists}). Custo marginal em cue vet sobre
		architecture/structural-checks/. Pattern de extensão
		orgânica estabelecido.

		(N2) 3 arestas não-W4 ganham exclusão do grafo (idc-to-log,
		idc-to-dlv, npm-to-ctr). NÃO é side-effect a documentar
		como gap — é aplicação consistente do princípio (P3).
		Mitigação: nenhuma dessas 3 participa de qualquer ciclo
		atual do sc-cm-07 (verificado em Fase 1); generalização
		é zero-risco no estado vigente do context-map.

		(N3) Risco residual hipotético: se uma das 3 query-surfaces
		(idc-to-log, idc-to-dlv, npm-to-ctr) se revelar coupling
		arquitetural disfarçado (publisher deveria publicar event
		mas usa query síncrona), filter esconderia o coupling do
		sc-cm-07. PR-3 mitiga via confirmação manual. Mitigação
		permanente: estes pares devem ser revisitados se o canvas
		do BC produtor materializar e declarar event flow distinto.

		Known gaps declarados:
		- Confirmação manual das 3 query-surfaces não-W4 (não são
		  coupling disfarçado) vem em PR-3. Single-line scan: ler
		  subdomain do source de cada e confirmar "produz dados via
		  query, não publica events para downstream consumir como
		  contract público". Documentado em adr-120 SRR roundDetails.
		- Operator exists v1 é binary. Futuros operators (notEquals,
		  matches, in) ficam para ADRs follow-on quando caso concreto
		  emergir. Pattern adr-041 minimalismo.
		- edgeExcludeFilters (lógica "exclude if all match") NÃO
		  introduzido — Opção α rejeitada porque custo (2 conceitos)
		  vs ganho (zero no caso atual). Pode emergir em futuro ADR
		  se padrão "exclude-by-conjunction" recorrer.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre framework de validação interno. Sem efeito em Bacen/
		SCD/LGPD/KYC/AML.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/context-map.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/context-map.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0 (uma localização canônica + zero duplicação): operator
		exists vive em architecture/artifact-schemas/structural-check.
		cue como SoT única; filter no sc-cm-07 referencia o schema;
		runner consume shape sem duplicar semântica.

		P1 (CUE como SoT de contratos): operator + filter declarativos
		em CUE; cue vet enforce shape; runner consume estritamente o
		que está declarado. Generalização "no event = no dependency"
		expressa via filter, não via convenção lexical.

		P12 (governança como código): tese DDD ("no event published =
		no architectural dependency cross-BC") substitui heurística
		humana. sc-cm-07 passa a refletir essa tese via filter
		declarativo. Future query-surfaces capturadas automaticamente
		sem ADR per-caso.

		Failure mode evitado: gap entre intent (def-028: "query-
		surface é call-site, não dependência arquitetural") e
		enforcement (filter atual não distingue events de queries).
		Sem este ADR, query-surfaces continuariam contribuindo para
		cycles do sc-cm-07 — falsos positivos arquiteturais.

		Tensão com axiomas: nenhuma tensão substantiva. ax-03 (pagar
		custo de complexidade cedo) confirmado: capability genérica
		exists ganha extensibilidade futura vs operator narrow
		específico-de-uso.

		Lenses consultadas:

		lens-event-driven-architecture-patterns: distinção entre
		event flow (architectural dependency) e query-surface
		(operational call-site) é canônica em EDA; filter declarativo
		formaliza a distinção.

		lens-distributed-systems-design: minimização de coupling
		arquitetural via separation of concerns (events para
		notification de fato; queries para operational lookup)
		alinha com decisão.

		Relacionamento com def-028 (PR #83, status open): def-028
		articulou decisão DDD; este ADR materializa o passo 2 do plano
		de PRs (PR-2 — capability + filter, Família B). PR-3 aplicará
		Família A nas instances + confirmará as 3 query-surfaces não-W4
		+ marcará def-028 resolved via resolvedBy → ADR de PR-3.
		defersTo NÃO usado (mesma análise adr-118/119 em PR #84):
		def-028 não foi CRIADO por este ADR.

		Decisão de framing das 3 query-surfaces não-W4 (per direção
		founder na Fase 2): aplicação proativa do princípio, NÃO
		side-effect. Documentado em P3 como benefício (redução de
		escopo PR-3), não em known gaps. Risco residual hipotético
		coberto em N3 + mitigação em PR-3.
		"""
}
