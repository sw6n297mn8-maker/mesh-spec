package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr122: artifact_schemas.#ADR & {
	id:    "adr-122"
	title: "Aplicar Família A (bidirectional-orchestration + policy-reaction + policy-execution-feedback) em 6 arestas + 3 edgeFilters notEquals no sc-cm-07 (PR-3 cycle-resolution, aplicação)"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		PR-3 (terceiro PR do plano cycle-resolution registrado em
		def-026/027/028.triggerCalibrationRationale). Após adr-118 +
		adr-119 (PR #84 — schema extensions Família A) + adr-120
		(PR #85 — capability exists + filter events-required Família B)
		+ adr-121 (mesmo PR-3 — capability notEquals), o framework está
		pronto para aplicar os kinds typed nas arestas concretas do
		context-map E excluí-las do grafo de dependência via novos
		edgeFilters.

		Estado pré-aplicação (sc-cm-07 reporta 3 WARN após PR-2):
		- W1 (drc↔cmt, 2-BC): ambas arestas têm feedbackLoop declarado
		  mas sem kind typed.
		- W2 (cmt→rew→dlv→bdg→cmt, 4-BC): aresta anômala rew-to-cmt
		  sem kind; outras 3 são spine linear de commitment-lifecycle.
		- W3 (fce→drc→cmt→rew→fce, 4-BC): cascata via cmt-to-drc (W1)
		  + rew-to-cmt (W2); W3 quebra automaticamente quando W1 + W2
		  quebram.

		Aplicação Família A — escopo inicial planejado (4 arestas):

		(1) cmt-to-drc + (2) drc-to-cmt — feedbackLoop.kind:
		"bidirectional-orchestration". Justificativa per-aresta:
		ambas declaram feedbackLoop com loopSemantics "Compromisso
		contextualiza disputa; resolução de disputa altera estado do
		compromisso — loop bidirecional disputa↔compromisso". Canvas
		CMT + subdomain DRC confirmam orquestração bilateral (publish-
		react em ambos lados). Kind formaliza machine-evaluable o que
		loopSemantics expressa em prose. Resolve W1 + cascata W3.

		(3) rew-to-cmt — top-level kind: "policy-reaction". Aresta
		publica RiskAlertRaised/RiskAlertResolved (notification de
		signal). Canvas REW: "REW publica decisões mas NUNCA enforça
		diretamente. Execução de gates é responsabilidade de consumers
		(CMT, SCF, FCE)". Canvas CMT: reaction de RiskAlertRaised é
		"Sinaliza compromissos ativos com contraparte sob risco
		elevado. Pode suspender formalização em andamento" — pode
		(agency) explícito; CMT escolhe ação per policy local. Per
		def-027: signature canônica de policy-reaction. Resolve W2.

		(4) rew-to-ins — top-level kind: "policy-reaction". Aresta
		publica CounterpartyRiskScoreUpdated. Description: "INS usa
		como input para solicitar cotação à seguradora externa. INS
		intermedia." INS tem agência decisória clara — escolhe se/
		quando solicitar cotação à seguradora externa. NÃO está em
		nenhum ciclo atual (folha do grafo; INS sem outbound back to
		REW). Aplicação é ontológica, não cycle-breaking. Mitigação
		do hidden coupling risk previsto em def-027.deferralRationale.

		Descoberta empírica via Ajuste 1 da Fase 3 (validação
		intermediária warn-first ANTES da promoção warn→reject):

		Após aplicação das 4 arestas + 2 edgeFilters notEquals (kind
		+ feedbackLoop.kind bidirectional-orchestration), sc-cm-07
		reportou 1 ciclo remanescente NÃO PREVISTO:
		fce → rew → fce (rew-to-fce + fce-to-rew, ambas com
		feedbackLoop declarado). Causa: sub-ciclo de 2 arestas
		agregado dentro do SCC grande de W3; emergiu como detectado
		independentemente após W3 quebrar.

		Análise semântica de fce↔rew (registrada em adr-124):
		- rew-to-fce: REW publica decisões/policy (CreditEligibility
		  Decided); FCE executa per invariante.
		- fce-to-rew: FCE publica state events de execução
		  (PaymentSettled, PaymentObligationDefaulted); REW consome
		  para recalibrar modelo de risco.
		Não é bidirectional-orchestration (não é orquestração
		sequencial; cadência assimétrica). Não é policy-reaction
		(FCE sem agência via invariante; PaymentSettled é state
		event). Exige nomeação própria.

		Decisão: adr-124 (mesmo PR-3) adiciona "policy-execution-
		feedback" ao #FeedbackLoopKind enum. Este ADR (adr-122) é
		ESTENDIDO para incluir aplicação dessa categoria nas 2
		arestas + 7ª edgeFilter.

		Aplicação Família A — escopo expandido (6 arestas, 3
		edgeFilters notEquals):

		(5) rew-to-fce + (6) fce-to-rew — feedbackLoop.kind:
		"policy-execution-feedback". Justificativa: per categoria
		introduzida em adr-124; ambas arestas declaram feedbackLoop
		com loopSemantics "loop de aprendizado contínuo"; estrutura
		canônica policy-side ↔ execution-side com feedback contínuo.
		Resolve sub-ciclo emergente capturado pelo Ajuste 1.

		Scan complementar policy-reaction concluído (Tarefa 5 do
		plano original):
		- rew-to-cmt ✓ canônico
		- rew-to-ins ✓ borderline genuíno → aplicar
		- rew-to-scf — published-language formal ontology; SCF executa
		  fluxo de antecipação condicionado, não "ignora conforme
		  policy". NÃO marcar policy-reaction. NOTA: rew-to-scf E
		  rew-to-fce poderiam emergir como policy-execution-feedback
		  futuros se canvas SCF/REW declarar bidirecionalidade — fora
		  do escopo atual; aplicação ontológica futura.
		- rew-to-fce — NÃO policy-reaction (enforcement via invariante);
		  É policy-execution-feedback (via adr-124, descoberta Ajuste 1).
		- drc-to-fce — FinancialCompensationOrdered é command; FCE
		  executa ordem sem agência. NÃO marcar (command propagation,
		  não policy-reaction).

		Confirmação scan das 3 query-surfaces não-W4 (do filter
		events-required do PR-2):
		- idc-to-log: "IDC fornece primitivas de verificação de
		  integridade; LOG conforma com o protocolo" — query-surface
		  genuína (IDC SoT de primitivas crypto).
		- idc-to-dlv: "DLV depende de IDC para integridade
		  criptográfica sem tradução" — query-surface genuína.
		- npm-to-ctr: "CTR consulta NPM sincronamente como
		  precondição de registro" — query-surface genuína (NPM SoT
		  de qualification status).
		Nenhuma esconde coupling arquitetural disfarçado. P3 do
		adr-120 (generalização proativa) confirmado.

		3 edgeFilters novos no sc-cm-07 (escopo expandido):
		- {path: "kind", notEquals: "policy-reaction"} — exclui
		  rew-to-cmt + rew-to-ins do grafo.
		- {path: "feedbackLoop.kind", notEquals:
		  "bidirectional-orchestration"} — exclui cmt-to-drc +
		  drc-to-cmt do grafo.
		- {path: "feedbackLoop.kind", notEquals:
		  "policy-execution-feedback"} — exclui rew-to-fce +
		  fce-to-rew do grafo. Entrada SEPARADA (não OR-composto
		  com a anterior) per pattern AND-only do framework.

		Resultado factual (validado pre-merge, enforcement ainda
		warn):
		- W1 (drc↔cmt) — ambas arestas excluídas → ciclo quebra.
		- W2 (cmt→rew→dlv→bdg→cmt) — rew-to-cmt excluída → ciclo
		  quebra.
		- W3 (fce→drc→cmt→rew→fce) — múltiplas arestas excluídas
		  (cmt-to-drc + rew-to-cmt) → ciclo quebra (over-determined).
		- Sub-ciclo fce↔rew — ambas arestas excluídas via policy-
		  execution-feedback → ciclo quebra.
		- Total: sc-cm-07 reporta 0 WARN.

		Pré-condições satisfeitas:
		- adr-118 (FeedbackLoopKind enum + #ActiveFeedbackLoop.kind?)
		  — PR #84 ✓
		- adr-119 (RelationshipKind enum + kind? em
		  #BaseRelationshipWith/WithoutCommunication) — PR #84 ✓
		- adr-121 (operator notEquals) — mesmo PR-3 ✓
		- adr-124 (policy-execution-feedback enum value) — mesmo
		  PR-3, precondição para aplicação em rew-to-fce/fce-to-rew

		Este ADR resolve def-026 e def-027 substantivamente
		(aplicação dos kinds + exclusão do grafo). def-028 é resolvido
		por adr-123 (promoção warn→reject que completa o arco de
		cycle-resolution iniciado em adr-120). defersTo NÃO usado
		(def-026/027 criados em PR #83 anterior).

		Alternativas consideradas e rejeitadas:

		(a) Aplicar apenas as 4 arestas originais sem incluir
		fce↔rew (entregar PR-3 parcial e abrir PR-4 para fce↔rew).
		REJEITADA: arco cycle-resolution fica meio-aberto; promoção
		warn→reject (adr-123) bloqueia em CI; pattern atômico do PR
		é preferível per founder direction "arco cycle-resolution
		fecha honestamente".

		(b) Aplicar apenas rew-to-cmt sem rew-to-ins. REJEITADA:
		def-027.deferralRationale explicitamente avisa hidden coupling
		risk; scan complementar confirmou rew-to-ins como caso
		borderline genuíno (INS com agência decisória).

		(c) Aplicar policy-reaction também a rew-to-scf, rew-to-fce,
		drc-to-fce (extensão maximalista). REJEITADA: scan rigoroso
		dos canvases mostra: rew-to-scf é published-language formal;
		rew-to-fce é policy-execution-feedback (adr-124); drc-to-fce
		é command propagation. Aplicar policy-reaction seria semantic
		drift.

		(d) Promover sc-cm-07 a reject neste ADR. REJEITADA: 1 ADR =
		1 decisão (per founder direction Q3=c). Promoção é decisão
		de gate distinta da decisão de aplicação Família A;
		separação em adr-123 preserva audit clarity.
		"""

	decision: """
		3 mudanças atômicas (escopo expandido após descoberta Ajuste 1):

		(1) [aplicação Família A] Adicionar field kind nas 6 arestas
		em strategic/context-map.cue:
		  - cmt-to-drc: feedbackLoop.kind: "bidirectional-orchestration"
		  - drc-to-cmt: feedbackLoop.kind: "bidirectional-orchestration"
		  - rew-to-cmt: kind: "policy-reaction" (top-level)
		  - rew-to-ins: kind: "policy-reaction" (top-level)
		  - rew-to-fce: feedbackLoop.kind: "policy-execution-feedback"
		  - fce-to-rew: feedbackLoop.kind: "policy-execution-feedback"

		(2) [edgeFilters novos] Adicionar 5ª, 6ª e 7ª entradas em
		sc-cm-07.rule.edgeFilters:
		  edgeFilters: [
		      {path: "direction", equals: "upstream-downstream"},
		      {path: "source.kind", equals: "bounded-context"},
		      {path: "target.kind", equals: "bounded-context"},
		      {path: "events", exists: true},
		      {path: "kind", notEquals: "policy-reaction"},
		      {path: "feedbackLoop.kind", notEquals: "bidirectional-orchestration"},
		      {path: "feedbackLoop.kind", notEquals: "policy-execution-feedback"},
		  ]

		(3) [errorMessage + rationale do sc-cm-07] Atualizar
		description e rationale mencionando os 3 kinds typed
		excluídos + aplicação completa do plano cycle-resolution +
		descoberta empírica via Ajuste 1.

		Marcação de def-026/027 como resolved (no mesmo commit do
		PR-3 governado por este ADR):
		  def-026.status: "resolved"
		  def-026.resolvedBy: "architecture/adrs/adr-122-apply-cycle-resolution-kinds.cue"
		  def-027.status: "resolved"
		  def-027.resolvedBy: "architecture/adrs/adr-122-apply-cycle-resolution-kinds.cue"

		Este ADR NÃO toca:
		- enforcement: "warn" do sc-cm-07 (promoção é decisão de
		  adr-123)
		- def-028 (resolvido por adr-123)
		- #FeedbackLoopKind enum (capability extension é adr-124)
		"""

	consequences: """
		Positivas:
		(P1) Resolve 4 ciclos (W1/W2/W3 + sub-ciclo fce↔rew) via
		vocabulário typed declarativo, sem editar topologia das
		relationships (arestas mantêm-se no context-map, ganham só
		categorização). Preserva rastreabilidade dos events
		cross-BC.

		(P2) Ontologia DDD enriquecida: cmt-to-drc + drc-to-cmt agora
		são reconhecidamente bidirectional-orchestration (loop
		bilateral entre BCs distintos); rew-to-cmt + rew-to-ins são
		reconhecidamente policy-reaction (notification + downstream
		agency); rew-to-fce + fce-to-rew são reconhecidamente
		policy-execution-feedback (estrutura policy ↔ execution com
		feedback contínuo). Linguagem comum entre BCs.

		(P3) Resolve hidden coupling risk de def-027 via rew-to-ins
		(scan complementar materializado). Mitigação aplicada por
		generalização proativa.

		(P4) Confirma scan das 3 query-surfaces não-W4 (P3 do
		adr-120) — nenhuma esconde coupling disfarçado.

		(P5) Validação empírica do Ajuste 1 (ordem de materialização
		warn-first → validate → promote): capturou ciclo emergente
		ANTES da promoção. Pattern repetível.

		(P6) Precondição para adr-123 (promoção warn→reject): sem
		aplicação Família A completa, sc-cm-07 ainda reportaria 1
		ciclo (fce↔rew); promoção causaria 1 FAIL — bloquearia CI.

		Negativas:
		(N1) strategic/context-map.cue cresce 6 linhas (kind per
		aresta). Custo marginal; ganho ontológico.

		(N2) sc-cm-07.edgeFilters cresce de 4 para 7 entradas. Custo
		marginal em performance (filter loop O(n_arestas × n_filters)
		= O(47 × 7) = 329 ops por execução; negligenciável).

		(N3) Risco categórico hipotético: futura aresta adicionada
		com kind=policy-reaction ou feedbackLoop.kind={bidirectional-
		orchestration | policy-execution-feedback} será
		automaticamente excluída do grafo sem auditoria manual.
		Mitigação: adr-119 + adr-118 + adr-124 estabelecem que
		adição de novo kind exige ADR (enum literal control no
		schema); ADR seria o ponto de auditoria. Promoção warn→reject
		(adr-123) cria também safety net retroativo: se aplicação
		futura introduzir ciclo via kind não-coberto, gate falha.

		Known gaps declarados:
		- rew-to-scf permanece sem kind declarado (decisão deliberada
		  per scan; published-language semantic). Se um dia padrão
		  emergir distinto, ADR follow-on registra.
		- INS subdomain canvas ainda não tem materialização completa;
		  reflexão complementar sobre policy-reaction em rew-to-ins
		  pode emergir quando canvas INS materializar.
		- Outros loops policy↔execution potenciais (e.g., rew↔scf)
		  não aplicados — não estão em ciclo atual; aplicação
		  ontológica futura.

		Fronteira regulatória: nenhuma. Mudanças semantic-only no
		context-map. Sem efeito em Bacen/SCD/LGPD/KYC/AML.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"strategic/context-map.cue",
		"architecture/structural-checks/context-map.cue",
		"architecture/deferred-decisions/def-026-cmt-drc-bidirectional-orchestration.cue",
		"architecture/deferred-decisions/def-027-rew-cmt-policy-reaction.cue",
	]

	plannedOutputs: [
		"strategic/context-map.cue",
		"architecture/structural-checks/context-map.cue",
		"architecture/deferred-decisions/def-026-cmt-drc-bidirectional-orchestration.cue",
		"architecture/deferred-decisions/def-027-rew-cmt-policy-reaction.cue",
	]

	principlesApplied: ["P0", "P1", "P12"]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0: kind types são vocabulário canônico do context-map; única
		localização semântica per natureza de aresta.

		P1: aplicação declarativa via field tipado no schema; runner
		consome via filter declarativo; nenhuma duplicação.

		P12: cycle resolution expressa via filter typed
		(notEquals + kind declarado), não via convenção lexical nem
		flag boolean. Future BC additions herdam framework. Ajuste 1
		validou empiricamente que warn-first → validate → promote
		captura regressões antes da promoção (governance-as-code
		operacional).

		Failure mode evitado: deixar 4 ciclos como WARN crônicos
		(catraca adr-097 nunca cumprida); aplicar policy-reaction só
		em rew-to-cmt criando hidden coupling para rew-to-ins (falha
		do scan complementar); promover sem detectar sub-ciclo fce↔rew
		(falha do Ajuste 1).

		Tensão com axiomas: nenhuma. ax-03 confirmado: aplicar a
		rew-to-ins agora + nomear policy-execution-feedback agora é
		mais barato que descobrir later.

		Lenses consultadas:
		- lens-event-driven-architecture-patterns: distinção entre
		  notification (policy-reaction), command (fce execution),
		  orchestration (bidirectional-orchestration), e policy↔
		  execution feedback (policy-execution-feedback) é canônica
		  em EDA.
		- lens-distributed-systems-design: feedback loops bilaterais
		  entre serviços em duas categorias estruturais distintas
		  (orchestration vs policy-execution-feedback) preserva
		  granularidade DDD.

		Relacionamento com adr-121 (mesmo PR): este ADR é primeiro
		consumidor da capability notEquals; sem adr-121, edgeFilters
		novos não compilam.

		Relacionamento com adr-124 (mesmo PR): este ADR é primeiro
		consumidor do enum value policy-execution-feedback
		introduzido em adr-124. Descoberta empírica via Ajuste 1
		motivou adr-124; adr-124 introduz vocabulário; este ADR
		aplica.

		Relacionamento com adr-118/119 (PR #84): este ADR aplica os
		kinds que adr-118/119 introduziram.

		Relacionamento com def-026/027 (PR #83 anterior): este ADR
		resolve ambos substantivamente. status: "resolved" +
		resolvedBy: "architecture/adrs/adr-122-...cue" marcados no
		mesmo commit. defersTo NÃO usado.

		Pattern paralelo a adr-049/056/063/076/080 (instanciação de
		schema extensions).
		"""
}
