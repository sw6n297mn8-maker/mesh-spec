package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def027: artifact_schemas.#DeferredDecision & {
	id:     "def-027"
	title:  "Resolver ciclo cmt→rew→dlv→bdg→cmt (sc-cm-07 W2) — policy-reaction como relationship.kind"
	date:   "2026-05-29"
	status: "resolved"

	resolvedBy: "architecture/adrs/adr-122-apply-cycle-resolution-kinds.cue"

	description: """
		sc-cm-07 (directed-acyclicity, adr-117) detectou 4 ciclos. Este
		deferimento cobre W2 (cmt → rew → dlv → bdg → cmt, 4-BC). A aresta
		anômala é rew-to-cmt; as outras 3 (cmt-to-bdg, bdg-to-dlv, dlv-to-rew)
		são spine linear do cross-context-workflow commitment-lifecycle.cue,
		que declara explicitamente em outOfScope: "Precificação de risco —
		transversal ao flow, não fase sequencial".

		Decisão conceitual registrada: aresta rew-to-cmt é policy reaction
		(notification de signal), NÃO dependência estrutural de dados. Evidência
		categórica do canvas REW: "REW publica decisões (score, eligibility,
		alerts) mas NUNCA enforça diretamente. Execução de gates é
		responsabilidade de consumers (CMT, SCF, FCE). Não enviado a FCE — FCE
		consome decisões (eligibility), não sinais (alerts); separação preserva
		decisão ≠ execução." Canvas CMT confirma: a reaction de RiskAlertRaised
		é "Sinaliza compromissos ativos com contraparte sob risco elevado.
		Pode suspender formalização em andamento" — é policy decision
		(CMT escolhe ação), não data sync.

		Família A da taxonomia de exclusão do grafo do sc-cm-07: o schema do
		context-map ganha vocabulário novo (relationship.kind semântico) que
		nomeia notification-driven publish-subscribe como classe distinta de
		dependência arquitetural. Família A vs Família B (filtro sobre dado
		existente, ver def-028): família A muda contrato; família B só muda
		check.

		Decisão a materializar: estender #RelationshipKind (novo discriminator)
		do context-map com "policy-reaction" + estender edgeFilters do sc-cm-07
		para excluir arestas com este kind. Aresta rew-to-cmt vira typed
		policy-reaction; sai do grafo de dependência arquitetural; ciclo W2
		quebra.

		Hipótese estrutural com risco de escopo elevado: "policy-reaction"
		como categoria pode aplicar-se a outras arestas do repo no momento
		da decisão (e.g., FCE publica sinais que outros BCs reagem por policy
		interna). PR-1 que materializar adr-119 deve fazer scan complementar
		para identificar candidatos cross-BC além de rew-to-cmt — risco de
		hidden coupling se aplicarmos apenas a 1 aresta sem revisar outras.

		Opções consideradas (preferred destacado):

		(a) Promover par REW↔CMT a direction:"mutual-dependency". REJEITADA:
		mesma razão de def-026 com agravamento — REW não tem nenhuma
		dependência estrutural de CMT (REW não consome eventos de CMT no
		canvas), logo "mutual" é categoricamente falso (mutualidade requer
		bidirecionalidade real). Forçaria modelagem que distorce a tese
		"decisão ≠ execução" articulada no canvas REW.

		(b) Remover aresta rew-to-cmt do context-map e modelar como policy
		interna do CMT subscrevendo ao event log de REW (sem cruzar fronteira
		BC explícita). REJEITADA: cross-BC events EXISTEM (RiskAlertRaised,
		RiskAlertResolved publicados por REW e consumidos por CMT — registrados
		em ambos canvases); remover do context-map perderia rastreabilidade do
		integration contract (def-019 + adr-104 estabelecem que events cross-BC
		são linguagem ubíqua que merece estar no context-map). Esconder a
		aresta é dishonest modeling.

		(c) [PREFERRED] Estender #RelationshipKind do context-map com
		"policy-reaction" e excluir do grafo do sc-cm-07 via edgeFilter.
		Família A da taxonomia. Reconhece notification publish-subscribe como
		cidadão de primeira classe do vocabulário cross-BC; preserva
		rastreabilidade dos events no context-map; remove o trânsito do grafo
		topológico (refletindo que notification NÃO é dependência arquitetural).
		Generaliza para outros publishers→consumers de signals no repo (REW
		é primeiro consumidor; FCE pode ser segundo quando WI-043 scaffolda
		FCE canvas). Cobre W2 diretamente; W3 já coberto por def-026 cascade
		(arestas cmt-to-drc/drc-to-cmt) — W3 fica duplamente protegido,
		def-027 contribui defensiva.

		(d) Estender com edgeFilters complexos por pattern de event name
		(e.g., "exclui arestas onde events[] contém *.Raised|.Resolved|.Cleared").
		REJEITADA: filtro por nome de evento é heurístico (futuro pattern
		policy-reaction pode usar naming distinto); semântica não deve depender
		de convenção lexical de eventos. Opção (c) é declarativa-canônica.

		ADR de resolução planejado: adr-119-add-policy-reaction-to-
		relationship-kind (a ser criado em PR-1 do plano em
		triggerCalibrationRationale).
		"""

	deferralRationale: """
		MOTIVO: a resolução exige (1) decisão DDD sobre vocabulário (kind name
		+ semântica), (2) ADR de schema-extension do context-map (adr-119
		planejado), (3) ADR adjacente do edgeFilter no sc-cm-07, (4) scan
		complementar para outras arestas candidatas (risco de hidden coupling
		se aplicar só a rew-to-cmt sem revisar outras "REW publica sinal"
		candidatas), (5) materialização em PR separado. Sequenciamento exige
		founder decision + revisita cross-BC.

		RISCO de resolver agora sem deferred-decision: aplicar policy-reaction
		só a rew-to-cmt deixando outras arestas com mesma natureza não-tipadas
		(hidden coupling). Severity high porque 4 BCs envolvidos no ciclo +
		hipótese estrutural ("policy-reaction" como categoria DDD) tem
		blast-radius além de 1 aresta.

		Plano de PRs em triggerCalibrationRationale.
		"""

	triggerCalibrationRationale: """
		Trigger primário manual-review porque a decisão tem 3 dimensões
		interpretativas: (a) nome do kind ("policy-reaction" é proposta;
		alternativas: "notification", "signal-driven", "reactive-event");
		(b) lugar no schema (#RelationshipKind novo discriminator vs estender
		#UpstreamPattern/#DownstreamPattern); (c) escopo de aplicação (só
		rew-to-cmt agora vs scan completo para detectar outras arestas
		candidatas no commit que materializar a decisão).

		Trigger secundário adjacent-need file-contains em strategic/context-map.
		cue detectando o pattern `kind: "policy-reaction"` (com dois-pontos +
		espaço + aspas como regex literal). Pattern restrito a ATRIBUIÇÃO CUE
		em instância — evita falso-positivo em adr-119 (PR-1) que apenas declara
		o enum ou cita o nome em prose. Fires quando PR-3 do plano editar
		manualmente o context-map.

		Plano de PRs (sequenciamento para audit):
		- PR-1: adr-118 + adr-119 (def-026 + def-027 família A — schema
		  extensions)
		- PR-2: adr-120 (def-028 família B — só check filter)
		- PR-3: aplicação nas arestas concretas do context-map + scan
		  complementar de candidatos policy-reaction + promoção sc-cm-07
		  warn → reject
		"""

	originatingArtifacts: [
		"strategic/context-map.cue",
		"architecture/structural-checks/context-map.cue",
		"architecture/adrs/adr-117-add-directed-acyclicity-kind-to-structural-check.cue",
		"contexts/cmt/canvas.cue",
		"contexts/rew/canvas.cue",
		"architecture/cross-context-workflows/commitment-lifecycle.cue",
	]

	costOfDeferral: {
		severity:    "high"
		blastRadius: "cross-artifact"
		description: """
			1 ciclo (W2) marcado como WARN até resolução; mas severity high
			porque (a) 4 BCs envolvidos (CMT/REW/DLV/BDG) — escopo maior que
			def-026; (b) hipótese estrutural ("policy-reaction" como categoria
			DDD) tem aplicação além de 1 aresta — risco de hidden coupling se
			outras arestas candidatas (e.g., FCE publica sinais) não forem
			detectadas no scan complementar; (c) commitment-lifecycle.cue
			declara explicitamente "risco transversal ao flow", e o ciclo
			contradiz essa declaração — sinal de modeling inconsistency.
			blastRadius cross-artifact: schema do context-map + sc-cm-07 +
			strategic/context-map.cue + potencialmente outros canvases (REW
			canvas para validar policy-reaction como classe; FCE canvas
			quando WI-043 scaffolda).
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Decisão DDD interpretativa em 3 dimensões: nome do kind, lugar no
			schema (#RelationshipKind novo vs estender patterns existentes),
			escopo de aplicação (1 aresta vs scan completo para policy-reaction
			candidates). Founder revisita preparando PR-1. Não machine-evaluable
			porque exige julgamento sobre fit com vocabulário DDD existente +
			scan cross-canvas para hidden coupling.
			"""
	}, {
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "strategic/context-map.cue"
			pattern: "kind: \"policy-reaction\""
		}
	}]
}
