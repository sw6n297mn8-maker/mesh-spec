package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr118: artifact_schemas.#ADR & {
	id:    "adr-118"
	title: "Adicionar bidirectional-orchestration ao #FeedbackLoopKind (schema extension do context-map, PR-1 de plano cycle-resolution)"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		def-026 (registrado em PR #83 mergeado em 2026-05-29) articulou a
		decisão DDD para resolver W1 (drc → cmt → drc, 2-BC) + cascata W3
		(fce → drc → cmt → rew → fce, via aresta cmt-to-drc compartilhada)
		do sc-cm-07 (directed-acyclicity, adr-117): o par CMT↔DRC é
		orquestração sequencial bidirecional, NÃO parceria DDD genuína.
		Evidência: ambas arestas declaram feedbackLoop:{exists:true,
		loopSemantics:"...loop bidirecional disputa↔compromisso"}; subdomain
		DRC = supporting (orquestração de exceções); subdomain CMT = core
		(lifecycle de compromisso); canvases revelam orquestração
		sequencial (CMT publica lifecycle proativo; DRC reage com decisões
		pós-hoc que alteram estado CMT).

		Schema atual do context-map carrega #ActiveFeedbackLoop com 3 fields
		(exists, reverseRelationshipId, loopSemantics). loopSemantics é prose
		livre — descreve o loop em linguagem natural mas NÃO permite
		categorização machine-evaluable. Para que o sc-cm-07 possa filtrar
		arestas em loops orquestrados (excluindo-as do grafo de dependência
		direcionada), precisa de uma dimensão categorical typed que
		complemente loopSemantics.

		Este ADR é o passo 1 do plano de PRs registrado em
		def-026.triggerCalibrationRationale:
		- PR-1 (este ADR + adr-119): schema extensions (enums novos +
		  fields opcionais)
		- PR-2 (adr-120): filter no sc-cm-07 para def-028 família B
		- PR-3: aplicação dos kinds nas arestas concretas do context-map +
		  scan complementar + promoção sc-cm-07 warn → reject. PR-3
		  resolverá def-026/def-027 ao marcá-los status open → resolved.

		Este ADR NÃO resolve def-026 — só prepara vocabulário. Resolução
		ocorre em PR-3 quando arestas drc↔cmt forem editadas para incluir
		kind: "bidirectional-orchestration" E o sc-cm-07 ganhar edgeFilter
		que exclui o par. defersTo schema field NÃO usado porque def-026
		não foi CRIADO por este ADR (precondition do field per schema
		#ADR.defersTo description: "Deferimentos conscientes governados
		criados por esta decisão").

		Alternativas consideradas e rejeitadas:

		(a) Adicionar field típico-prose adicional (e.g., loopCategory:
		string) sem enum. REJEITADA: strings livres não são machine-
		evaluable; sc-cm-07 não consegue filtrar por substring confiável.
		Pattern adr-049/056/063 estabelece enums typed para discriminação.

		(b) Adicionar valores especulativos no enum agora (e.g.,
		"shared-state-loop", "event-sourcing-loop"). REJEITADA: minimalismo
		per adr-041 — kinds devem ser narrow e específicos. Expansão
		on-demand quando padrão concreto emergir. Enum com 1 valor é
		válido em CUE e estabelece o pattern.

		(c) Adicionar kind obrigatório (sem ?). REJEITADA: forçaria cascade
		update em todas as instances existentes de #ActiveFeedbackLoop —
		3 arestas no context-map declaram feedbackLoop (cmt-to-drc,
		drc-to-cmt, fce-to-rew). Optional permite migração progressiva;
		PR-3 aplica nas arestas que precisarem.

		(d) Modificar loopSemantics shape de string para struct com kind
		embedded (e.g., {kind, description}). REJEITADA: muda contrato
		existente (loopSemantics atual é string) — break change não-trivial
		em instances. Adicionar kind separado preserva loopSemantics
		existente.
		"""

	decision: """
		Estender architecture/artifact-schemas/context-map.cue com 2
		mudanças paralelas (mesma forma de adr-049, adr-056, adr-063,
		adr-076, adr-080):

		(1) [enum-creation] Criar #FeedbackLoopKind enum no fim do
		arquivo (seção KINDS junto com #RelationshipKind do adr-119
		paralelo) com 1 valor inicial:
		  #FeedbackLoopKind: "bidirectional-orchestration"

		(2) [struct-extension] Adicionar field opcional kind ao
		#ActiveFeedbackLoop:
		  #ActiveFeedbackLoop: {
		      exists:                true
		      reverseRelationshipId: string & =~"^[a-z][a-z0-9-]*$"
		      loopSemantics:         string & !=""
		      kind?:                 #FeedbackLoopKind   // ← novo
		  }

		Valor inicial documentado em comentário do enum: categoria
		bidirectional-orchestration = par BC↔BC onde cada lado publica
		eventos para o outro consumir (orquestração sequencial), distinto
		de partnership (shared kernel) e de OHS (one-way data flow).
		Primeiro consumidor planejado: drc↔cmt (sc-cm-07 W1, em PR-3).

		Este ADR é apenas schema extension. NÃO toca:
		- architecture/structural-checks/context-map.cue (sc-cm-07
		  edgeFilters vêm em PR-3)
		- strategic/context-map.cue (arestas concretas; aplicação em PR-3)
		- def-026 instance (resolução em PR-3 via resolvedBy →
		  adr-resolver-em-pr-3)

		Field opcional (kind?) preserva validade de todas instances
		existentes de #ActiveFeedbackLoop sem cascade update — alinha
		com pattern de minimalismo + migração progressiva.
		"""

	consequences: """
		Positivas:
		(P1) Machine-evaluable categorization de loops complementa
		loopSemantics (prose) com dimensão typed. Habilita sc-cm-07
		(PR-3) a filtrar arestas em loops orquestrados via edgeFilter
		declarativo sem heurística sobre loopSemantics text.

		(P2) Extensibilidade preservada via discriminated enum: futuros
		ADRs follow-on adicionam valores (e.g., "shared-state-loop",
		"event-sourcing-loop") quando padrão concreto emergir. Pattern
		paralelo às extensions de structural-check (adr-049/056/063/076/
		080/117).

		(P3) Vocabulário DDD novo nomeado: "bidirectional-orchestration"
		formaliza classe distinta de partnership (shared kernel) e
		OHS (one-way data flow). Reduz ambiguidade futura quando outros
		pares bilaterais sequenciais surgirem.

		(P4) Field opcional permite migração progressiva — instances
		existentes (cmt-to-drc, drc-to-cmt, fce-to-rew com
		feedbackLoop declarado) continuam válidas; aplicação progressiva
		em PR-3 e além.

		Negativas:
		(N1) Schema #ActiveFeedbackLoop cresce 3 → 4 fields. Custo
		marginal em cue vet; alinha com pattern de extensão orgânica
		estabelecido.

		(N2) v1 do enum tem só 1 valor. Pode parecer subdimensionado —
		mas é deliberado (minimalismo per adr-041); ADRs follow-on
		adicionam valores quando emergir caso concreto.

		Known gaps declarados:
		- sc-cm-07 edgeFilter para excluir arestas com
		  feedbackLoop.kind=="bidirectional-orchestration" NÃO está
		  aqui. Vem em PR-3 (junto com aplicação nas instances). Razão:
		  o filter sem aplicação seria órfão (não muda comportamento do
		  runner); aplicação sem filter seria muda (não muda topology
		  do grafo). Ambos vivem juntos em PR-3.
		- Edição de instances (drc↔cmt em strategic/context-map.cue)
		  NÃO é parte deste PR. Vem em PR-3 quando founder estiver
		  pronto para fechar o ciclo.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural sobre
		framework de modelagem de relationships internas. Sem efeito em
		Bacen/SCD/LGPD/KYC/AML.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/context-map.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/context-map.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0 (uma localização canônica + zero duplicação): #FeedbackLoopKind
		vive em architecture/artifact-schemas/context-map.cue como SoT
		única do vocabulário; instances importam via reference (não
		duplicação).

		P1 (CUE como SoT de contratos): enum + field opcional declarativos
		em CUE; cue vet enforce shape; runner do sc-cm-07 (PR-3) consume
		shape via edgeFilter.

		P12 (governança como código): categorização machine-evaluable
		substitui prose livre como mecanismo de discriminação. sc-cm-07
		passa a poder filtrar arestas em loops orquestrados via filter
		declarativo, não heurístico.

		Failure mode evitado: gap entre intent ('loop é orquestração
		bidirecional, não dependência') e enforcement (nenhum mecanismo
		além de prose em loopSemantics). Sem este enum, sc-cm-07 não
		consegue distinguir orquestração de acoplamento real — falso
		positivo de ciclo em pares onde feedback é declarado por design.

		Tensão com axiomas: nenhuma tensão substantiva. ax-03 (pagar
		custo de complexidade cedo) é confirmado: enum genérico ganha
		extensibilidade futura vs custo de criar agora.

		Lenses consultadas:

		lens-distributed-systems-design: orquestração sequencial
		bidirecional é pattern bem documentado distinto de partnership
		(shared kernel) e OHS (one-way data flow); confirma legitimidade
		de nomear a classe.

		Relacionamento com def-026 (registrado em PR #83, status open):
		def-026 articulou a decisão DDD; este ADR materializa o passo 1
		do plano de PRs (schema extension). PR-3 aplicará nas instances
		concretas e marcará def-026 resolved via resolvedBy apontando
		para o ADR de PR-3. defersTo NÃO usado aqui porque def-026 não
		foi CRIADO por este ADR (semântica estrita do field per schema).
		"""
}
