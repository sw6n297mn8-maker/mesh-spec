package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr137: artifact_schemas.#ADR & {
	id:    "adr-137"
	title: "Disbursement do advance: canal de execução estável (FCE) + fonte de capital variável — resolve pf-scf-1"

	date: "2026-06-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		pf-scf-1 (probe-record do Ciclo 4, records/scf.cue) achou uma contradição
		interna no canvas SCF: bd-structures-not-executes afirma que "o SCF especifica o
		que o FCE executará downstream" e que a liquidação "é do FCE", mas o evento de
		originação ReceivableAdvanceOriginated lista consumers ["ato"] — sem aresta
		scf→fce no context-map. O disbursement do advance ao fornecedor não tinha canal
		topológico. Os dois canvases asseveram a relação em prosa (SCF "FCE executará";
		FCE ce-06 l.654 "antecipação originada por SCF... execução do FCE"), mas nenhum
		a modelava.

		Decisão de domínio do founder: o Mesh suporta DOIS modos de funding do advance —
		capital próprio (quando houver receita + autorização BC) e capital de parceiro
		(para diluir risco). O que varia entre os modos é a FONTE do capital, não o
		CAMINHO de execução: o canal é SEMPRE o FCE.

		A aresta scf→fce nova + a fce→scf existente (PaymentSettled fecha a antecipação)
		formam um ciclo bilateral genuíno (originar→desembolsar / liquidar→fechar). Por
		P13 (ônus invertido), ciclo cross-BC é defeito-por-default: sua legitimidade
		exige kind nomeado + ADR.

		Alternativas:
		(A-evento + ciclo tipado) modelar scf→fce como evento (ReceivableAdvanceOriginated
		    consumido pelo FCE) e TIPAR o ciclo scf↔fce. ESCOLHIDA.
		(A-sync sem events) modelar scf→fce como command/query-surface sem events (excluído
		    do grafo de acyclicity pelo events-filter, adr-120 — precedente tcm→fce).
		    REJEITADA: exigiria um command-surface novo no FCE (que hoje é event-driven) e
		    introduziria acoplamento sync no caminho de disbursement.
		(B reframe-only) reescrever bd-structures-not-executes para negar o canal scf→fce.
		    REJEITADA: negaria uma relação que AMBOS os canvases afirmam (o FCE é o
		    executor do disbursement); seria varrer a relação real para baixo do tapete.
		"""

	decision: """
		(1) Modelar a aresta scf→fce no context-map: SCF open-host-service, FCE
		    anti-corruption-layer (espelha as demais arestas para o FCE), events
		    [ReceivableAdvanceOriginated].

		(2) Tipar o ciclo scf↔fce como bidirectional-orchestration (reusa #FeedbackLoopKind
		    existente — zero schema novo). feedbackLoop declarado em AMBAS as arestas
		    (scf-to-fce ↔ fce-to-scf, reverseRelationshipId mútuo), padrão idêntico a
		    cmt↔drc (adr-118/122). sc-cm-07 exclui o ciclo tipado via edgeFilter
		    notEquals → 0 ciclos não-tipados preservado.

		(3) Canal de execução ESTÁVEL: o disbursement passa SEMPRE pelo FCE. O SCF nunca
		    move dinheiro nem toca rails — emite ReceivableAdvanceOriginated; o FCE executa.

		(4) Fonte de capital VARIÁVEL: próprio (sob receita + autorização BC) ou parceiro
		    (diluir risco) = dois modos de funding. A fonte é dimensão do produto, não do
		    caminho.

		(5) Escopo AMPLO deferido a def-036: a escolha da fonte, o regime de risco por
		    modo, e o impacto no PrePaymentGuard do FCE. Este ADR abre o canal (escopo
		    mínimo); o regime de fonte fica para quando as condições existirem.
		"""

	consequences: """
		Positivas:
		(P1) Resolve pf-scf-1: a cláusula "o que o FCE executará downstream" passa a ter
		     canal topológico (aresta scf→fce); a contradição entre businessDecision e
		     topologia desaparece.
		(P2) Ciclo scf↔fce legítimo e gate-enforçado: tipado bidirectional-orchestration,
		     reconhecido pelo sc-cm-07 (P12) — não é acoplamento circular oculto.
		(P3) Dois modos de funding capturados sem comprometer a fronteira executar-vs-fundar
		     (P0: um executor canônico = FCE; o SCF não ganha aggregate de pagamento).

		Negativas / limitações:
		(N1) O FCE ganha um 2º gatilho de execução (além de InvoiceIssued). A semântica do
		     PrePaymentGuard por fonte de capital (próprio/parceiro) NÃO é modelada aqui —
		     fica deferida a def-036. Abrir o canal sem o regime de fonte é deliberado
		     (escopo mínimo); o risco de "inventar o regime" é evitado pelo deferimento.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Esta decisão (canal de execução estável no FCE + fonte de capital variável)
			estará errada SE o disbursement do advance não passar pelo FCE em nenhum modo
			— então a aresta scf→fce seria espúria e o canal estaria mal-modelado — OU se
			a fonte de funding nunca se tornar variável (sempre próprio OU sempre parceiro)
			— então não havia dois modos, e a dimensão fonte seria over-modeling.
			"""
		observableSignal: """
			(1) O FCE consome ReceivableAdvanceOriginated e executa o disbursement (aresta
			scf→fce viva, bidirectional-validada nos dois canvases). (2) def-036 evolui
			(triggered/resolved) quando o funding amadurece — surgindo de fato um 2º modo
			(primeiro parceiro real OU autorização BC para capital próprio). Ausência
			persistente de qualquer um dos dois sinais falsifica.
			"""
	}

	affectedArtifacts: [
		"strategic/context-map.cue",
		"contexts/scf/canvas.cue",
		"contexts/fce/canvas.cue",
		"architecture/deferred-decisions/def-036-funding-source-regime.cue",
	]

	defersTo: ["def-036"]

	principlesApplied: ["P0", "P13", "P12"]

	supersedes: []

	rationale: """
		P13 (decomposição auditável; ônus invertido sobre ciclos): o ciclo scf↔fce é
		genuíno (originar→desembolsar / liquidar→fechar é bilateral), e P13 manda que
		ciclo cross-BC seja defeito-por-default cuja legitimidade exige kind nomeado + ADR.
		Reusa-se bidirectional-orchestration (publish-react bilateral do lifecycle do
		advance, shape de cmt↔drc) em vez de criar kind novo — minimalismo de taxonomia
		(adr-049/056/063); o acoplamento não aponta estrutura genuinamente nova que um
		kind existente mis-classificaria.

		P0 (uma localização canônica): o movimento de dinheiro tem UM executor canônico —
		o FCE. Modelar a fonte de capital como variável NÃO duplica o caminho de execução;
		o SCF continua sem aggregate de pagamento. Canal único, fonte como dimensão do
		produto — sem segunda via de disbursement.

		P12 (governança como código): a legitimidade do ciclo não é convenção — é
		gate-enforçada. sc-cm-07 (directed-acyclicity, reject) exclui o ciclo SÓ porque
		ele está tipado com feedbackLoop.kind reconhecido; se a tipagem sumir, o ciclo
		volta a falhar o build. A fitness function valida a decisão.

		Por que deferir o escopo amplo (def-036): a escolha da fonte, o risco por modo e o
		impacto no PrePaymentGuard dependem de condições que ainda não existem (receita do
		Mesh, autorização BC para capital próprio, parceiros de funding concretos).
		Modelar agora especularia sobre regime regulatório não-controlado. Abrir o canal
		(escopo mínimo) resolve a contradição sem inventar o regime.

		Tensão com axiomas: nenhuma.
		"""
}
