package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr174: artifact_schemas.#ADR & {
	id:    "adr-174"
	title: "Aprovação de compra é PORTÃO pré-pedido: Gate de Cobertura (saldo+alçada) invocado antes da emissão, com reserva efetivada no commitment (Reservation/Confirmation)"
	date:  "2026-07-12"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		A 1ª domain story (ds-buyer-procurement-journey) mediu a maior
		divergência de ordem entre a jornada vivida e o modelo: o setor de
		compras real NUNCA emite pedido sem o de-acordo do gestor por alçada
		(aprovação-como-GATE), enquanto o modelo disparava o controle
		orçamentário DEPOIS do commitment aceito (aprovação-como-CONSEQUÊNCIA,
		bdg pol-commitment-accepted-triggers-approval). A decisão de qual ordem
		o modelo adota foi registrada como def-078 (open, manual-review) e
		amarrada como pré-requisito do passo de triagem do WI-151.

		O read-only que abriu a fatia reenquadrou a pergunta: o MECANISMO de
		portão já existe no bdg — o Gate de Cobertura (cmd-approve-budget:
		'Saldo Disponível suficiente + Alçada satisfeita', determinístico, com
		escalada supervisionada) e a semântica de reserva
		(cmd-release-budget-commitment 'devolve o valor reservado'). A pergunta
		nunca foi 'construir aprovação?' — era ONDE no tempo o portão fica.

		O founder decidiu: PORTÃO (opção A). O modelo segue o real — a lição
		que a story instituiu.
		"""

	decision: """
		(1) ORDEM CANÔNICA do ciclo demanda-a-pedido: requisição → triagem →
		(cotação/decisão de sourcing no ssc) → APROVAÇÃO com Gate de Cobertura
		(saldo + alçada, pré-pedido) → emissão do pedido → commitment. Alçada e
		saldo são PRÉ-CONDIÇÃO da emissão, nunca reação ao pedido emitido.

		(2) TWO-PHASE Reservation/Confirmation (o padrão multi-aggregate
		canônico do corpus, ADR-C4-2.0 §2.0.8): a aprovação da compra RESERVA
		cobertura no Centro de Custo (bdg); o commitment aceito EFETIVA a
		reserva; o cancelamento a LIBERA (release já existente). O mecanismo do
		bdg é integralmente preservado — o pol-commitment-accepted-triggers-
		approval muda de papel: de gate-tardio para EFETIVAÇÃO da reserva feita
		na aprovação. Nada é construído em paralelo; muda o tempo da invocação.

		(3) ACOPLAMENTO p2p→bdg pelo padrão adr-055 (cross-aggregate state
		dependency, o mesmo shape do npm↔idc): a aprovação em p2p
		(cmd-approve-purchase) tem PRÉ-CONDIÇÃO de reserva confirmada do Gate
		de Cobertura via interação sync — o cmd-approve-budget do bdg JÁ é sync
		por desenho ('downstream precisa de decisão determinística'). Muda o
		invocador e o momento, não o mecanismo.

		(4) MATERIALIZAÇÃO: o lado p2p (aggregate de requisição, triagem
		formal, aprovação com pré-condição de reserva, segundo braço do gate de
		emissão — inv-emission-requires-approved-requisition ao lado do RECTOR)
		entra NESTA fatia (WI-151). O re-papel bdg-side (policy→efetivação +
		evento de reserva) é DECLARADO aqui e registrado como fatia irmã
		WI-153 — não executado junto, uma fatia por vez.

		(5) AMARRAÇÃO À TESE: 'dinheiro só se move quando a operação comprova'
		— a aprovação orçamentária pré-pedido é a instância procurement dessa
		lei: nenhum compromisso nasce sem cobertura e alçada provadas ANTES. O
		portão não burocratiza; ele torna o de-acordo que o setor já vive um
		fato verificável do sistema.

		(6) Esta decisão RESOLVE o def-078 (status resolved, resolvedBy este
		ADR, no mesmo commit que materializa o portão — a resolução viaja com a
		prova no disco, não antes dela).
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) a operação real (piloto) mostrar compras legítimas que EXIGEM emissão antes do de-acordo (urgência de canteiro genuína) em volume que não caiba como exceção supervisionada — sinal de que o portão rígido não é a ordem vivida em emergência; OU (b) a reserva pré-pedido criar represamento operacional de saldo (reservas aprovadas que não viram pedido prendendo Centro de Custo) sem que o release cubra o ciclo real."
		observableSignal: "(a) observável no piloto: taxa de compras emergenciais que contornam a requisição (maverick) — se subir após o portão, a exceção supervisionada precisa de desenho próprio (não reverter a ordem silenciosamente). (b) observável na projeção de disponibilidade do bdg: reservas em aberto envelhecendo sem conversão — threshold de revisita na 1ª leitura operacional do piloto."
	}

	consequences: """
		Positivas: o modelo passa a viver a ordem que o comprador vive — a
		divergência nº 1 do relatório da story morre; o Gate de Cobertura é
		reusado no tempo certo (zero mecanismo paralelo); o padrão
		Reservation/Confirmation entra no domínio de compras pela porta
		canônica; o passo de triagem/alçada do WI-151 destrava.

		Negativas/custos: o bdg entra no caminho síncrono da aprovação
		(acoplamento pré-emissão, mitigado pelo padrão adr-055 já provado em
		npm↔idc); o two-phase é mais rico que o fluxo de um estágio — reserva
		órfã vira preocupação operacional (vigiada pela falsificação (b)); o
		re-papel bdg-side fica pendente até o WI-153 executar (janela declarada
		em que a policy antiga ainda descreve o papel velho).
		"""

	affectedArtifacts: [
		"architecture/deferred-decisions/def-078-approval-order-gate-vs-consequence.cue",
		"contexts/p2p/domain-model.cue",
		"contexts/p2p/canvas.cue",
		"contexts/p2p/glossary.cue",
		"strategic/domain-stories/buyer-procurement-journey.cue",
	]

	plannedOutputs: [
		"governance/build-time/task-specs/wi-153.cue",
	]

	principlesApplied: [
		"P10 — o portão é gate determinístico (saldo + alçada verificáveis) invocado pré-emissão; nenhuma camada estocástica decide cobertura orçamentária.",
		"adr-055 — a pré-condição cross-aggregate (aprovação requer reserva confirmada no bdg) segue o padrão canônico de state dependency via interação sync, o mesmo shape provado em npm↔idc.",
		"ADR-C4-2.0 §2.0.8 (corpus fundacional) — Reservation/Confirmation é O padrão multi-aggregate da casa; a decisão o aplica em vez de inventar atomicidade cross-BC.",
		"foundingPrinciples (tese) — evidência antes de dinheiro: cobertura e alçada provadas ANTES do compromisso nascer, nunca conferidas depois.",
	]

	supersedes: []

	rationale: """
		Portão venceu consequência porque o modelo segue o real (a lição
		instituída pela story): a jornada vivida trata o de-acordo como
		pré-condição, e mantê-lo como reação produziria pedidos desfeitos que
		nenhum comprador vive. O desenho de menor custo venceu o de maior:
		mover a invocação do Gate de Cobertura existente (e re-papelizar a
		policy do bdg como efetivação) preserva todo o mecanismo e aplica o
		padrão canônico da casa, contra a alternativa de construir gate novo em
		p2p duplicando saldo/alçada (drift por construção, rejeitada). A
		alternativa de manter consequência com 'aprovação quase-síncrona' foi
		rejeitada porque o ponto da jornada é o de-acordo humano por alçada
		como pré-condição, não latência.
		"""
}
