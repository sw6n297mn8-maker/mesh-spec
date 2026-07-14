package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr177: artifact_schemas.#ADR & {
	id:    "adr-177"
	title: "Elo formal requisição↔cotação carregado pelo p2p (sourcingDecisionRef) + 2º braço do portão de aprovação: gate determinístico de procedência de preço contra a cotação vencedora do ssc"
	date:  "2026-07-13"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		O def-079 (aberto no WI-151, quando o amount entrou no
		cmd-approve-purchase como campo de entrada solto) deferiu duas
		metades de um mesmo furo: (a) COMO formalizar o elo
		requisição↔cotação — shape do ref, quem o carrega, em que momento
		nasce; (b) como reconciliar o amount aprovado contra o valor da
		cotação vencedora do ssc — gate determinístico? tolerância?
		divergência escala? O exit codificado ("idealmente após WI-152
		materializar a superfície de leitura que o elo referenciaria")
		foi satisfeito: o WI-152 entregou prj-quotation-map +
		qry-quotation-map — cotações lado a lado com vencedor destacado
		pós-decisão, e o próprio rationale da query nomeava o def-079
		como consumidor futuro.

		FATO DE MODELO DECISIVO (Tempo 1 read-only, 2026-07-13): o ssc é
		CATEGORIA-ESCOPADO, não requisição-escopado. agg-sourcing-process
		nasce de cmd-open-rfq com categoryRef + vo-rfq-scope; as
		autoridades preferred-designation e strategic-award são DURADOURAS
		(validityPeriod, expectedContractScope) e servem N compras futuras
		— uma RFQ NÃO é 1:1 com uma requisição por construção. Esse fato
		força a direção do elo.

		Estado pré-decisão do terreno: o preço vive na ent-quotation do
		ssc (unitPrice decimal + currency, por fornecedor);
		evt-sourcing-decision-made NÃO carrega valor; o p2p já referencia
		decisão ssc rio abaixo (claimedAuthorityRef = sourcingDecisionId na
		emissão, padrão primitive ref cross-BC de costCenterRef); o
		agg-purchase-requisition não tinha NENHUM campo ligando à cotação;
		nenhuma quantidade FIRME existia no modelo (só scope.estimatedVolume
		— estimativa da submissão); ssc-to-p2p existia como aresta async
		(3 events) no grafo do sc-cm-07 (reject); NÃO existia relação
		p2p-to-ssc; QuerySourcingDecision era consumida pelo p2p
		(act-validate-authority) SEM declaração no context-map (drift).

		Alternativas consideradas e rejeitadas:

		(i-a) SSC carrega o elo POR EVENTO (ssc consome
		PurchaseRequisitionTriaged): exigiria tornar público um evento hoje
		internal E criar relação p2p-to-ssc com events → aresta ssc→p2p no
		grafo; com a aresta p2p→ssc existente (ssc-to-p2p async) forma
		ciclo de 2 — o sc-cm-07 em REJECT bloqueia por construção.
		REJEITADA (veto estrutural).

		(i-b) SSC carrega o elo POR CAMPO (requisitionRef em cmd-open-rfq /
		agg-sourcing-process): sem aresta nova, mas contradiz o modelo
		categoria-escopado — requisitionRef obrigatório quebra
		preferred/strategic (N requisições por autoridade); opcional vira
		campo semi-morto que só o fluxo one-shot preenche. REJEITADA
		(contradição de modelo).

		(iii) Enriquecer os events de decisão do ssc (requisitionRef +
		valor vencedor no payload): pressupõe (i-b) — a RFQ teria que
		conhecer a requisição para ecoá-la; expõe preço vencedor em evento
		PUBLISHED, tensionando o veto de confidencialidade competitiva do
		WI-152 (o veto é contra evento público de cotação); e para
		preferred/strategic o "valor total" nem existe. REJEITADA.

		(A) DERIVAÇÃO do amount (deixa de ser entrada; p2p deriva da
		cotação no ato): reconciliação por construção, mas muda o contrato
		do command e esvazia o ato de autoridade humana — o gestor
		aprovaria um valor que não declara. REJEITADA (decisão do founder:
		o amount SEGUE campo de entrada; o gate verifica, não substitui).

		(C) TOLERÂNCIA (banda percentual no comparador): calibração
		arbitrária sem evidência Phase 0; começar exato e abrir banda por
		evidência é reversível — o inverso não. REJEITADA.

		(fórmula com estimatedVolume): validar amount contra unitPrice ×
		scope.estimatedVolume seria tratar estimativa da submissão como
		quantidade firme — teatro de auditoria (o gate passaria a provar
		uma multiplicação sobre um chute). REJEITADA; a quantidade firme
		entra como campo novo declarado pelo gestor.
		"""

	decision: """
		(1) DIREÇÃO (ii): o p2p carrega o elo. sourcingDecisionRef —
		primitive ref cross-BC, língua ssc (sourcingDecisionId; identidade
		canônica vive no ssc vo-sourcing-decision-id), mesmo padrão de
		costCenterRef (língua bdg) e claimedAuthorityRef (emissão). NASCE
		no cmd-approve-purchase (declarado pelo gestor com a decisão),
		PERSISTE no agg-purchase-requisition (presente quando
		status=approved; preservado em converted para auditoria) e VIAJA
		no evt-purchase-approved (procedência auditável a partir do
		próprio fato).

		(2) QUANTIDADE FIRME: cmd-approve-purchase ganha campo quantity
		(decimal) — a quantidade firme sendo comprada, declarada pelo
		gestor no ato da aprovação; persiste no aggregate e viaja no
		evento. scope.estimatedVolume NUNCA é base de reconciliação.

		(3) RECONCILIAÇÃO POR INVARIANTE-GATE (2º braço do portão):
		inv-approval-amount-matches-winning-quotation entra como guard da
		transição triaged→approved AO LADO de
		inv-approval-requires-coverage-reservation — o portão do adr-174
		vira DUPLO: braço 1 prova COBERTURA (bdg: saldo + alçada); braço 2
		prova PROCEDÊNCIA (ssc: o valor aprovado é o da cotação certa).
		O gate verifica: (a) sourcingDecisionRef aponta decisão existente
		e concluída; (b) cotação VENCEDORA resolvível; (c) currency match;
		(d) unitPrice × quantity == amount (igualdade exata). Divergência
		NÃO transiciona — requisição permanece triaged + escalada
		supervisionada (mesma mecânica do braço bdg). Multi-supplier
		(preferred/strategic, vencedor ambíguo) → escalada ambiguous-case,
		espelho do padrão multi-supplier da emissão. Cross-BC dependency
		declarada per adr-055: dependsOnAggregateState → ssc
		agg-sourcing-process via canvas query-surface QueryQuotationMap.

		(4) RESOLUÇÃO DA COTAÇÃO É QUERY-ONLY SYNC: QueryQuotationMap no
		momento da aprovação — call-site operacional FORA do grafo de
		dependência per adr-120. ZERO aresta nova; sc-cm-07 verde por
		construção.

		(5) CONTEXT-MAP: ssc-to-p2p evolui communication async → HYBRID
		(espelho de npm-to-ssc) com queries: [QueryQuotationMap,
		QuerySourcingDecision]. Os events permanecem — a aresta p2p→ssc do
		grafo NÃO muda. A 2ª query quita o drift existente
		(QuerySourcingDecision consumida sem declaração no mapa).

		(6) COEVOLUÇÃO NO MESMO COMMIT (1ª fatia de domínio sob a catraca
		adr-176): o agent-spec do p2p incorpora a invariante nova em
		operationalScope.invariants +
		act-process-purchase-approval.domainModelRefs; a prosa que
		declarava "dívida do elo formal em def-079" é reescrita para a
		verdade atual (classe-2); o braço ssc entra nas
		pre/postconditions. sc-ag-01/sc-ag-02 (ambos reject) permanecem
		verdes. Os CANVASES coevoluem na mesma fatia (emenda do founder
		sobre o W1 do reviewer): canvas p2p ganha a query-dependency
		QueryQuotationMap → ssc (4ª entry, shape do braço bdg); a surface
		QueryQuotationMap do canvas ssc nomeia P2P como consumidor do
		gate — as três faces do acoplamento (domain-model, context-map,
		canvas) fecham juntas, sem janela.

		(7) def-079: status open → resolved, resolvedBy apontando este
		ADR (padrão def-028/adr-123). SEM WI e sem work-event (padrão
		adr-176 — a materialização ocorre integralmente nesta fatia; nada
		fica pendente).

		Toque editorial no ssc (sem building block novo): rationale do
		qry-quotation-map atualizado ("referenciará" → REFERENCIA; o exit
		do def-079 consumado). O bdg NÃO é tocado.
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) o fluxo dominante de aprovação referenciar decisões preferred/strategic multi-supplier — onde o gate não resolve vencedor único e escala SEMPRE, virando teatro de gate com humano no loop rotineiro em vez de exceção; OU (b) a quantity 'firme' se provar fictícia na prática (gestores copiando estimatedVolume para passar no gate) — a fórmula estaria provando uma cópia, não uma realidade; OU (c) a dupla interação sync na aprovação (bdg + ssc) criar indisponibilidade operacional que force bypass supervisionado rotineiro."
		observableSignal: "Taxa de escalada ambiguous-case sobre aprovações (dominância de vencedor-ambíguo = sinal (a)); correlação sistemática quantity == scope.estimatedVolume nos fatos aprovados (sinal (b)); frequência de escalada por indisponibilidade do braço ssc vs braço bdg (sinal (c)). Todos observáveis em event log / audit trail quando houver runtime."
	}

	consequences: """
		Positivas:
		(P1) O furo de auditoria da SCD fecha: "confio que o valor é o da
		cotação certa" vira "o disco prova a procedência do valor
		aprovado". Todo evt-purchase-approved carrega sourcingDecisionRef +
		quantity — auditoria reconstrói a verificação (cotação vencedora,
		unitPrice, currency, fórmula) a partir do fato + ent-quotation, sem
		confiança em prosa.

		(P2) Portão DUPLO simétrico: os dois braços têm a MESMA mecânica
		determinística (falha não transiciona + escalada supervisionada;
		P10) — o operador aprende um padrão, não dois. A decisão do gestor
		permanece humana nos dois braços (amount é entrada verificada,
		não derivação).

		(P3) Zero custo de grafo: a resolução da cotação é query call-site
		(adr-120); a evolução async→hybrid do ssc-to-p2p mantém a aresta
		idêntica. sc-cm-07 (reject) verde por construção — verificado no
		runner na própria fatia.

		(P4) Drift do mapa quitado: QuerySourcingDecision (consumida desde
		o bootstrap do p2p) agora declarada em ssc-to-p2p.queries.

		(P5) 1ª fatia de domínio sob a catraca adr-176 prova o custo da
		coevolução: agent-spec do p2p atualizado no mesmo commit, sc-ag-02
		em reject permanece 0 — a lei funciona sem fricção quando a
		coevolução é feita.

		Negativas:
		(N1) A aprovação agora depende de disponibilidade sync do ssc além
		do bdg (duas interações na mesma action). Mitigação: mesma janela
		operacional do braço bdg; indisponibilidade escala honestamente
		(insufficient-context), nunca aprova às cegas.

		(N2) Aprovações sob autoridade preferred/strategic multi-supplier
		NÃO passam pelo gate sem humano (ambiguous-case). Deliberado
		Phase 0 — escalada explícita, não furo; a falsificação (a) vigia o
		caso de isso virar o fluxo dominante.

		(N3) quantity nasce na aprovação sem verificação contra entrega —
		a reconciliação quantidade-aprovada vs quantidade-entregue é
		terreno dlv/downstream, fora deste ADR (fronteira declarada, não
		lacuna esquecida).

		(P6) Coevolução COMPLETA das três faces do acoplamento no mesmo
		commit (decisão do founder na emenda do W1 do reviewer, SEM janela
		declarada): domain-model (accessVia da invariante), context-map
		(ssc-to-p2p hybrid + queries) e canvas — query-dependency
		QueryQuotationMap no canvas do p2p (shape do braço bdg) + surface
		do ssc nomeando P2P como consumidor do gate (forma do precedente
		QuerySourcingDecision; alinhamento cross-canvas adr-055 itens
		5/8). Diferente da janela legítima do governanceScope (WI-153,
		que dependia do def-076 pendente), o conteúdo aqui estava
		disponível no ato — declarar janela seria evadir trabalho pequeno
		e criar exatamente o drift que o arco de coevolução (adr-175/176
		+ elo duplo nos PGs) existe para eliminar.

		Fronteira regulatória: fecha furo de trilha de auditoria (procedência
		de valor aprovado — sustenta cc-04, auditoria contínua, cuja
		amarração à Lei 12.846 vive na capability do canvas p2p, e a tese
		SCD de valor lastreado em evidência). Nenhuma obrigação nova criada.
		"""

	affectedArtifacts: [
		"contexts/p2p/domain-model.cue",
		"contexts/p2p/agents/p2p-primary-agent.cue",
		"contexts/p2p/canvas.cue",
		"strategic/context-map.cue",
		"contexts/ssc/domain-model.cue",
		"contexts/ssc/canvas.cue",
		"architecture/deferred-decisions/def-079-requisition-quote-link-and-amount-reconciliation.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: [
		"P10 — o gate de procedência é determinístico (existência + vencedor + currency + fórmula exata); nenhuma camada estocástica decide valor; a decisão do gestor permanece humana e o gate verifica, não substitui.",
		"P0 — o preço unitário tem UMA localização canônica (ent-quotation no ssc); o p2p referencia por sourcingDecisionRef e verifica no ato via query, nunca copia o unitPrice para dentro do próprio modelo.",
		"adr-055 — dependsOnAggregateState cross-BC via canvas query-surface é o shape declarado do acoplamento (mesmo padrão do braço bdg e do RECTOR de authority).",
		"adr-120 — query síncrona é call-site operacional, fora do grafo de dependência arquitetural; o elo não cria aresta e o sc-cm-07 permanece verde por construção.",
		"adr-174 — este ADR estende o portão (1 braço → 2 braços) sem alterar sua ordem canônica: alçada, saldo E procedência são pré-condição da emissão, nunca reação.",
		"adr-175/adr-176 — a coevolução do agent-spec no mesmo commit é exigência da catraca em reject; esta fatia é a primeira instância do regime em fatia de domínio.",
	]

	supersedes: []

	rationale: """
		Princípios aplicados: P10 (gate determinístico verifica procedência;
		humano decide), P0 (preço unitário canônico no ssc; elo por
		referência), adr-055/adr-120 (shape e custo-zero-de-grafo do
		acoplamento), adr-174 (extensão do portão).

		Failure mode evitado: valor aprovado sem procedência verificável —
		exatamente o furo que o def-079 registrou quando o amount entrou
		como campo de entrada solto no WI-151. Sem o elo, a frase 'o valor
		é o da cotação vencedora' era prosa confiada; com o elo + gate, é
		propriedade verificada na transição.

		Relacionamento com def-079: este ADR é a resolução substantiva das
		duas metades (elo + reconciliação); resolvedBy aponta aqui (padrão
		def-028/adr-123). O exit dependia do WI-152 (superfície de leitura)
		— entregue; esta fatia consome a superfície como o rationale do
		qry-quotation-map antecipava.

		Relacionamento com adr-174: o portão ganhou o 2º braço SEM mudança
		de ordem nem de mecânica — a simetria (falha não transiciona +
		escalada) é deliberada para que o padrão aprendido no braço bdg
		valha no braço ssc.

		Relacionamento com o fato categoria-escopado: a direção (ii) não é
		preferência — é a única que não quebra nada: (i-a) fecha ciclo de 2
		vetado pelo sc-cm-07; (i-b) força 1:1 num modelo N:1; (iii) herda
		(i-b) e tensiona a confidencialidade do WI-152. O p2p já era o lado
		que referencia decisões ssc (claimedAuthorityRef); o elo rio acima
		segue o mesmo padrão.

		Tensão com axiomas: nenhuma. A tese fundacional é REFORÇADA
		(foundingPrinciples, mech-evidence — 'dinheiro só se move quando a
		operação comprova'; mesmo apontamento do adr-174): o valor que o
		Gate de Cobertura reserva passa a ter procedência provada contra a
		cotação que o originou.

		Lenses consultadas: nenhuma com match direto — decisão resolvida
		por princípios (P0/P10) + precedentes internos (adr-055, adr-120,
		adr-174), mesmo regime do adr-174.
		"""
}
