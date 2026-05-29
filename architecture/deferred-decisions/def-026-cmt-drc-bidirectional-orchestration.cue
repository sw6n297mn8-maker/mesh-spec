package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def026: artifact_schemas.#DeferredDecision & {
	id:     "def-026"
	title:  "Resolver ciclo CMT↔DRC (sc-cm-07 W1 + cascata W3) — bidirectional-orchestration como feedbackLoop.kind"
	date:   "2026-05-29"
	status: "open"

	description: """
		sc-cm-07 (directed-acyclicity, adr-117) detectou 4 ciclos de dependência
		no context-map. Este deferimento cobre W1 (drc → cmt → drc, 2-BC) e
		W3 (fce → drc → cmt → rew → fce, 4-BC, cascata via a mesma aresta
		cmt-to-drc).

		Decisão conceitual registrada: o par CMT↔DRC é orquestração sequencial
		bidirecional, NÃO parceria DDD genuína. O context-map já declara
		feedbackLoop:{exists:true, loopSemantics:"...loop bidirecional disputa↔
		compromisso"} em ambas as arestas (cmt-to-drc, drc-to-cmt). Evidência
		dos canvases (CMT.communication) + subdomain DRC reforça: DRC é
		supporting-subdomain de "Orquestração do lifecycle de exceções" cujo
		negativeBoundary declara que "DRC trata exceções que afetam compromissos;
		CMT governa o fluxo normal". Assimetria de tipos (DRC=supporting,
		CMT=core) refuta partnership genuína (que exigiria shared kernel ou
		SoT compartilhado). O loop é semantic: CMT publica lifecycle proativo;
		DRC reage com decisões pós-hoc que alteram estado CMT.

		Família A da taxonomia de exclusão do grafo do sc-cm-07: o schema do
		context-map ganha vocabulário novo (kind semântico) que nomeia uma
		natureza qualitativa de relação. Família A vs Família B (filtro sobre
		dado existente, ver def-028): família A muda contrato; família B só
		muda check.

		Decisão a materializar: estender #FeedbackLoopKind enum com
		"bidirectional-orchestration" + estender edgeFilters do sc-cm-07 para
		excluir arestas em pares onde ambas declaram feedbackLoop.exists=true
		E feedbackLoop.kind="bidirectional-orchestration". Cascata: ciclo W3
		fica resolvido como side-effect porque o caminho "fce → drc → cmt → rew
		→ fce" perde a aresta drc → cmt (excluída via filter).

		Opções consideradas (preferred destacado):

		(a) Promover par a direction:"mutual-dependency" (#InternalPartnership
		Relationship). REJEITADA: força sinalizar simetria que os subdomains
		categoricamente refutam. DRC não é parceiro estrutural de CMT — é
		supporting subdomain que reage a eventos de CMT (core). Mutual-
		dependency em DDD orthodoxy implica shared kernel ou SoT compartilhado;
		nada disso existe entre CMT e DRC. Adicionalmente: distorce loopSemantics
		que já declara "orquestração", não "parceria".

		(b) Remover uma das arestas (assumindo a outra cobre semanticamente).
		REJEITADA: ambas as arestas carregam eventos distintos com semânticas
		distintas (cmt-to-drc: contexto via CommitmentAccepted/StateChanged;
		drc-to-cmt: decisões via DisputeResolved/CommitmentSuspensionOrdered).
		Remover qualquer das duas perderia integration contract real.

		(c) [PREFERRED] Estender #FeedbackLoopKind enum com "bidirectional-
		orchestration" e excluir do grafo do sc-cm-07 via edgeFilter. Família A
		da taxonomia. Preserva direcionalidade declarada (não force partnership
		falsa) + reconhece loop semântico (não esconde a verdade declarada em
		loopSemantics) + remove o par do grafo de dependência arquitetural
		(reflete que orquestração NÃO é dependência estrutural no sentido
		topológico). Vocabulário novo nomeia uma classe DDD legítima:
		downstream-and-upstream-eventos-bidirecionais-em-orquestração-sequencial,
		distinto de partnership (shared kernel) e de open-host-service (one-way
		data flow). Cobre W1 diretamente + W3 por cascata (compartilha aresta
		cmt-to-drc).

		(d) Documentar via tension-entry (limitação de schema) e aceitar warn
		permanente do sc-cm-07. REJEITADA: warn permanente em catraca adr-097
		é exatamente o que a catraca pretende evitar — checks born-warn devem
		ter path para reject articulado, não vitalícios. Tension-entry não
		resolve, só descreve.

		ADR de resolução planejado: adr-118-add-bidirectional-orchestration-to-
		feedback-loop-kind (a ser criado em PR-1 do plano em
		triggerCalibrationRationale).
		"""

	deferralRationale: """
		MOTIVO: a resolução exige (1) decisão DDD sobre o vocabulário a adicionar
		ao schema (#FeedbackLoopKind enum), (2) ADR de schema-extension do
		context-map (adr-118 planejado), (3) ADR adjacente para edgeFilter do
		sc-cm-07, (4) materialização em PR separado quando ambas as estensões
		estiverem validadas. Sequenciamento exige founder decision + revisita
		cross-BC (CMT canvas, eventual DRC canvas quando scaffolded). Resolver
		hoje seria atropelar o sequenciamento próprio dos 3 PRs planejados.

		RISCO de resolver agora sem deferred-decision: decisão DDD apressada
		(promover a mutual-dependency seria mecanicamente fácil mas
		categoricamente errado per evidência dos subdomains); ou pior, esconder
		o ciclo via deleção de aresta perdendo integration contract real.
		Custo de deferir: 1 ciclo continua marcado WARN no sc-cm-07 + cascata
		W3 idem; reversível mecanicamente assim que adr-118 + ADR-ZZZ sequence
		materializar (PR-1 + PR-3 do plano).

		Plano de PRs registrado em triggerCalibrationRationale para audit.
		"""

	triggerCalibrationRationale: """
		Trigger primário manual-review porque a decisão é interpretativa em 3
		dimensões: (a) nome do kind ("bidirectional-orchestration" é proposta;
		founder pode preferir naming mais curto/longo); (b) lugar exato no
		schema (#FeedbackLoopKind como enum top-level vs aninhado em
		#FeedbackLoop); (c) escopo do edgeFilter (excluir aresta isoladamente
		vs ambas se ambas declararem o kind). Nenhuma das 3 é machine-evaluable.

		Trigger secundário adjacent-need file-contains em strategic/context-map.
		cue detectando o pattern `kind: "bidirectional-orchestration"` (com
		dois-pontos + espaço + aspas como regex literal). Pattern restrito a
		ATRIBUIÇÃO CUE em instância — evita falso-positivo em ADR-118 (PR-1)
		que apenas declara o enum ou cita o nome em prose. Fires quando founder
		editar manualmente para aplicar a decisão materializada (PR-3 do plano),
		momento em que founder também marca status open → resolved com resolvedBy
		apontando para o adr-118-...cue.

		Plano de PRs (registrado para audit; sequenciamento que o trigger
		secundário acompanha):
		- PR-1: adr-118 + adr-119 (def-026 + def-027 família A — schema
		  extensions)
		- PR-2: adr-120 (def-028 família B — só check filter)
		- PR-3: aplicação nas arestas concretas do context-map + promoção
		  sc-cm-07 warn → reject

		Trigger não é temporal (não há justificativa para deadline arbitrária);
		não é volume-threshold (single decisão).
		"""

	originatingArtifacts: [
		"strategic/context-map.cue",
		"architecture/structural-checks/context-map.cue",
		"architecture/adrs/adr-117-add-directed-acyclicity-kind-to-structural-check.cue",
		"contexts/cmt/canvas.cue",
		"strategic/subdomains/drc.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			2 ciclos (W1 + W3 via cascata) ficam visíveis como WARN do sc-cm-07
			até resolução; não bloqueiam build (born-warn). Severity medium
			porque há cascata real (W3 não tem decisão DDD própria — é
			side-effect de W1; resolver W1 fecha W3 automaticamente) mas é
			contido a 3 BCs (CMT/DRC/FCE/REW; FCE/REW só aparecem por trânsito
			em W3). blastRadius cross-artifact porque resolução toca schema do
			context-map (architecture/artifact-schemas/context-map.cue) +
			sc-cm-07 (architecture/structural-checks/context-map.cue) +
			eventual instância de uso na strategic/context-map.cue.
			Não é local (3 arquivos afetados); não é cross-cutting (não toca
			outros BCs além dos do ciclo).
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Decisão DDD interpretativa: nome do kind, lugar exato no schema
			(#FeedbackLoopKind top-level vs aninhado), escopo do edgeFilter.
			Founder revisita quando preparar PR-1 (ADR de schema extension).
			Não machine-evaluable porque vocabulário DDD novo exige julgamento
			sobre fit com convenções existentes (partnership, OHS, ACL).
			"""
	}, {
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "strategic/context-map.cue"
			pattern: "kind: \"bidirectional-orchestration\""
		}
	}]
}
