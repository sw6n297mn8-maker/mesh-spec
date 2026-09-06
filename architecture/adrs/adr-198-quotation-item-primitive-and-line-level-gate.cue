package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr198: artifact_schemas.#ADR & {
	id:    "adr-198"
	title: "Item de cotação como primitiva do sourcing (matriz item × fornecedor) + elo requisição↔cotação no nível do item + reexpressão por linha do 2º braço do portão"
	date:  "2026-09-06"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		A frente §0 + L1 mediu o furo e o founder deu o veredito: MODELO
		INCOMPLETO, a tela está certa (def-087). vo-rfq-scope é escopo único
		(description + estimatedVolume singulares) e a proposta carrega
		unitPrice no nível da cotação inteira — a comparação item a item que
		a prática usa (mapa de cotação como matriz item × fornecedor;
		economia medida por item e por compra; consolidação de frete) não
		existe no modelo. A prática foi observada no protótipo da Mesa de
		Adjudicação (evidência de prática, não norma): 14 linhas, vencedor
		derivado POR linha, proposta parcial (fornecedor sem oferta em
		linhas), adjudicação parcial (linhas decididas 12 de 14; linha com
		pool < 2 supervisionada; linha sem fornecedor avaliável não
		decidível), total como soma das linhas.

		A FALSIFICAÇÃO (a) DO adr-177 DISPAROU — a primeira do repo a
		disparar de fato. Sua condição ('o gate não resolve vencedor único
		e escala SEMPRE, virando teatro de gate') materializou-se por uma
		direção não antecipada: não pelo domínio de preferred/strategic,
		mas porque no fluxo dominante (one-shot) a adjudicação real é POR
		LINHA, com vencedores distintos por item — sob a forma aritmética
		vigente (igualdade sobre preço único + quantity singular), toda
		compra multi-item com split escalaria. O disparo atinge APENAS o
		segundo braço (procedência de preço); o braço de cobertura
		orçamentária (bdg) não é tocado por item.

		A deliberação do def-079/adr-177 considerou dois níveis para o elo
		— a RFQ e a requisição — e rejeitou (i-b) (requisitionRef em
		cmd-open-rfq) por contradição de modelo: o ssc é
		categoria-escopado; ref obrigatório força 1:1 num modelo N:1
		(def-088). Existe um terceiro nível que aquela deliberação não
		considerou: o do ITEM — o único que não contradiz o ssc, porque o
		item da RFQ pertence à RFQ (categoria), não a requisição alguma, e
		o vínculo pode nascer inteiro do lado p2p.

		Alternativas consideradas e rejeitadas:

		(alt-1) Estender só o ESCOPO (vo-rfq-scope itemizado, cotação e
		decisão intocadas): não bastava — a matriz item × fornecedor
		continuaria inexistente (preço seguiria único por proposta) e o
		modelo ficaria internamente incoerente: escopo plural, preço
		singular — pior que o estado atual. REJEITADA.

		(alt-2) Item como ENTITY própria com lifecycle: o item do escopo
		não muta durante a janela — quem muta é a cotação (revisões), quem
		carimba é a decisão; entity sem mutação é cerimônia, e item fora do
		agregado quebraria a consistency boundary declarada (RFQ + cotações
		+ decisão atômicas). REJEITADA — VO com identidade local (itemId
		string local à RFQ; endereçamento cross-BC pelo par rfqId+itemId;
		sem VO de id standalone porque o item não tem vida fora da RFQ).

		(alt-3) Elo por item carregado pelo SSC (requisitionItemRef na
		RFQ/cotação): reabriria (i-b) um nível abaixo — mesma contradição
		categoria-escopada (a RFQ serve N requisições; seu item não
		pertence a nenhuma). REJEITADA; o p2p carrega, na linha de
		aprovação — direção (ii) do adr-177 preservada no nível do item.

		(alt-4) Abandonar a verificação aritmética (procedência vira só
		'decisão referenciada existe'): a pergunta do gate — o preço
		aprovado tem procedência na proposta vencedora — continua
		necessária e continua verificável linha a linha; abandonar porque a
		conta mudou de forma seria reabrir o furo de auditoria que o
		adr-177 fechou. REJEITADA.

		(alt-5) Tolerância na soma (banda percentual): mesma rejeição da
		alternativa (C) do adr-177 — calibração arbitrária sem evidência;
		começar exato e abrir banda por evidência é reversível, o inverso
		não. REJEITADA.
		"""

	decision: """
		(1) ITEM COMO PRIMITIVA — ssc: vo-rfq-item novo {itemId local,
		description, quantity, unit declarado, neededBy?}; vo-rfq-scope
		reexpresso (categoryRef/deadline/location no escopo; items:
		[vo-rfq-item, ...] no lugar de description/estimatedVolume
		singulares) — flui para agg-sourcing-process, evt-rfq-opened e
		vo-fitness-signals.rfqContext. p2p: vo-purchase-item novo (mesma
		forma) e vo-purchase-scope itemizado do mesmo jeito — requisição e
		pedido ganham linhas pela mesma VO (alinhamento nominal cross-BC
		que o rationale da VO já declara). unit entra como string
		DECLARADA, não taxonomia — canonização deferida em def-093.

		(2) PROPOSTA POR ITEM + PARCIAL LEGÍTIMA — vo-quotation-line novo
		{itemId, unitPrice, declaredCapacity?, deliveryDate?};
		ent-quotation reexpressa: unitPrice/declaredCapacity singulares
		migram para lines; currency permanece da cotação (uma por cotação;
		invariante de imutabilidade do WI-161 preservado), assim como
		supplierRef/paymentTerms/deliverySchedule/termsNotes/
		revisionNumber. A cobertura da cotação É a lista de linhas —
		ausência de linha = item não cotado; NENHUM invariante força
		cobertura total. cmd-submit-quotation, cmd-revise-quotation e os
		espelhos evt-quotation-submitted/evt-quotation-revised carregam
		lines. Negociação por linha: vo-counter-terms ganha itemId?
		opcional (alvo da rodada quando de linha; ausente = eixos da
		cotação inteira); cmd-propose-counter-terms/
		evt-counter-terms-proposed espelham via a VO.

		(3) DECISÃO POR ITEM + LINHA VAZIA COM NOME — vo-item-award novo
		{itemId, outcome: awarded | no-quotation | withheld,
		awardedSupplierRef?, awardedQuotationRef?, narrative?} (nomes
		indicativos; glossário do ssc decide na fatia). awarded referencia
		a cotação vencedora (P0 — não copia unitPrice); no-quotation
		registra item sem proposta válida (linha não adjudicável, nunca
		silenciosa); withheld registra a linha que a compradora deixa sem
		destino deliberadamente, com narrative obrigatória. A CONCLUSÃO NÃO
		EXIGE ADJUDICAÇÃO TOTAL: cmd-make-one-shot-sourcing-decision
		conclui com itemAwards cobrindo TODOS os itens do escopo, cada um
		com outcome — a soma por linha sabe o que fazer com a linha vazia
		porque ela existe e tem outcome. evt-sourcing-decision-made carrega
		itemAwards; selectedSuppliers vira derivado (união dos awarded);
		allocationPolicy fica, com single/split derivado dos itemAwards. O
		destino posterior de item não adjudicado (nova janela) é jornada
		nova — fora. Invariantes reexpressos: pool competitivo POR LINHA
		(linha com <2 cotantes válidos exige a exceção supervisionada na
		linha); vo-evaluated-supplier ganha itemId (score por linha).
		ESCOPO: one-shot. preferred-designation/strategic-award concedem
		autoridade, não linhas — intocados, com a escalada ambiguous-case
		do adr-177 mantida para eles.

		(4) O ELO NO NÍVEL DO ITEM, CARREGADO PELO P2P — vo-approval-line
		novo {requisitionItemId, sourcingItemId (língua ssc: itemId dentro
		da decisão referenciada), quantity firme, lineAmount}.
		cmd-approve-purchase ganha lines; amount permanece o TOTAL
		declarado pelo gestor (ato de autoridade humana — intocado); o
		quantity singular do adr-177 migra para as linhas.
		evt-purchase-approved e agg-purchase-requisition espelham (lines
		quando approved; preservadas em converted). A linha de aprovação É
		o elo requisição-item ↔ item-da-decisão ↔ linha-da-cotação — nasce
		no p2p, no ato da aprovação, como o sourcingDecisionRef já nasce
		hoje; NADA entra em cmd-open-rfq nem no agg-sourcing-process.
		Item awarded ausente das lines é legítimo (compra-se o
		subconjunto). AGREGAÇÃO (def-089): permitida por construção (itens
		de N requisições podem apontar, em N aprovações, para o mesmo item
		de uma decisão), NÃO modelada aqui.

		(5) REEXPRESSÃO DO 2º BRAÇO — inv-approval-amount-matches-
		winning-quotation muda de forma, não de pergunta: (a) decisão
		existente e concluída [intocado]; (b) POR LINHA: sourcingItemId
		resolve item-award com outcome=awarded e linha vencedora
		resolvível — linha de aprovação contra item no-quotation/withheld
		NÃO efetiva e escala (não se aprova dinheiro contra linha sem
		proposta vencedora); o ambíguo multi-supplier do one-shot dissolve
		(award por item é único por construção; ambiguous-case fica para
		preferred/strategic); (c) currency match POR LINHA; (d) POR LINHA:
		unitPrice(linha vencedora) × quantity(linha) == lineAmount,
		igualdade exata; (e) Σ lineAmount == amount — o total como soma.
		Divergência em qualquer verificação: mesma mecânica — não
		transiciona, permanece triaged, escalada supervisionada. O braço 1
		(cobertura bdg) NÃO é tocado: segue reservando o amount total.
		Resolução via QueryQuotationMap no ato — query-only sync intocada
		(adr-120; zero aresta; sc-cm-07 verde por construção).

		(6) COEVOLUÇÃO NO MESMO COMMIT (catraca adr-176): agent-specs de
		p2p (act-process-purchase-approval) e ssc (acts de avaliação e
		conclusão) + canvases (superfície QueryQuotationMap do ssc;
		query-dependency do p2p) + prj-quotation-map/qry-quotation-map
		reexpressos como matriz por item. A story não é tocada (referencia
		por código; nenhum código muda).

		(7) def-087 e def-088: open → resolved, resolvedBy este ADR
		(padrão def-079/adr-177). def-093 nasce desta decisão (defersTo)
		com a fronteira da canonização de unit.
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) a RFQ dominante tiver ~1 item na prática — a estrutura por linha vira overhead cerimonial sem matriz; OU (b) a aprovação por linhas escalar rotineiramente por divergência de soma (gestores incapazes de compor Σ lineAmount == amount — a forma nova reprovando o fluxo dominante que a forma antiga aprovava); OU (c) a proposta parcial dominante degradar o pool por linha a <2 rotineiramente — toda linha exigindo exceção supervisionada, o gate por linha virando teatro."
		observableSignal: "Distribuição de itens por RFQ (mediana ~1 = sinal (a)); taxa de escalada por divergência de soma sobre aprovações vs. taxa dos demais braços (sinal (b)); fração de linhas com pool <2 sobre linhas adjudicadas (sinal (c)). Observáveis em event log quando houver runtime."
	}

	consequences: """
		Positivas — P1: a matriz item × fornecedor que a prática usa passa
		a existir no modelo: comparação, decisão, rationale e procedência
		POR LINHA, com o total como soma. P2: a proposta parcial e a linha
		vazia deixam de ser irrepresentáveis — têm outcome nomeado, nunca
		silêncio. P3: o elo requisição↔cotação fecha no único nível que não
		contradiz o ssc categoria-escopado, sem reabrir (i-b). P4: a
		agregação (def-089) fica PERMITIDA por construção sem ser modelada.
		P5: o gate de procedência sobrevive à sua primeira falsificação
		disparada reexpressando-se — a pergunta permanece, a aritmética
		acompanha o domínio.

		Negativas/fronteiras declaradas — N1: shapes de commands/events
		nascidos no WI-151/adr-177 mudam (quantity singular migra;
		unitPrice migra para linha) — pré-runtime, sem dado persistido, sem
		grandfathering. N2: unit entra como string declarada; a canonização
		de unidade é deferida em def-093 (defersTo) — e a urgência é maior
		que 'conceito emergiu': unidades divergentes quebram a comparação
		por linha EM SILÊNCIO (um fornecedor cota o rolo, outro o metro, e
		a matriz compara números incomparáveis sem erro visível — o
		protótipo pratica fator de normalização; o modelo ainda não tem
		onde declará-lo). N3: frete e alocação por entrega NÃO são
		consequência desta fatia — a equalização (frete rateado, ICMS,
		prazo) vive em FitnessRuleContent (config, oq-ssc-8), não no
		schema; alocação por entrega é território do recebimento (def-091).
		N4: o desenho do item CONDICIONA a forma do saldo do def-091 — o
		saldo por item herdará itemId + quantity + unit da linha do PEDIDO
		(vo-purchase-item via vo-purchase-scope) — registrado aqui,
		modelado lá. N5: re-sourcing de item não adjudicado (nova janela a
		partir de no-quotation/withheld) é jornada nova — fora. N6:
		preferred/strategic seguem sem linhas (autoridade, não
		adjudicação) — a falsificação (a) original do adr-177 permanece
		vigiando esse domínio.

		Relação com adr-177: REEXPRESSÃO, não substituição — as decisões
		(1) direção (ii), (2) quantidade firme (agora por linha), (4)
		query-only sync, (5) context-map e (6) coevolução permanecem
		vigentes; muda a forma aritmética da decisão (3). supersedes NÃO
		cabe (a união discriminada do schema exigiria adr-177 inteiro
		status=superseded — falso: o ADR segue majoritariamente vigente);
		defersTo aponta def-093 (o único def que ESTA decisão cria); a
		relação com o adr-177 vive nesta prosa e em principlesApplied —
		com o disparo da falsificação (a) registrado no context como o
		gatilho.
		"""

	affectedArtifacts: [
		"contexts/ssc/domain-model.cue",
		"contexts/p2p/domain-model.cue",
		"contexts/ssc/schemas/events.cue",
		"contexts/p2p/schemas/events.cue",
		"contexts/ssc/api.yaml",
		"contexts/p2p/api.yaml",
		"contexts/ssc/agents/ssc-primary-agent.cue",
		"contexts/p2p/agents/p2p-primary-agent.cue",
		"contexts/ssc/canvas.cue",
		"contexts/p2p/canvas.cue",
		"architecture/deferred-decisions/def-087-quotation-item-as-model-primitive.cue",
		"architecture/deferred-decisions/def-088-requisition-quotation-link-at-item-level.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-093-unit-of-measure-canonization.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	defersTo: ["def-093"]

	principlesApplied: [
		"P0 — o preço por linha tem UMA casa canônica (vo-quotation-line na ent-quotation); o item-award e a linha de aprovação referenciam por itemId/quotationRef, nunca copiam o unitPrice.",
		"P10 — o gate reexpresso permanece determinístico linha a linha (existência + outcome + currency + fórmula exata + soma); a decisão do gestor permanece humana (amount e lines são entrada verificada, não derivação).",
		"adr-177 — reexpressão do 2º braço sob a falsificação (a) disparada: direção (ii) preservada no nível do item; (i-b) segue rejeitada; a mecânica falha-não-transiciona-e-escala é a mesma.",
		"adr-174 — a ordem canônica do portão (alçada, saldo E procedência como pré-condição da emissão) não muda; o braço de cobertura não é tocado.",
		"adr-120 — a resolução por linha continua query call-site via QueryQuotationMap; zero aresta nova; sc-cm-07 verde por construção.",
		"adr-176 — coevolução de agent-specs e canvases no mesmo commit; sc-ag-01/02 permanecem verdes.",
		"def-032 — falsificação própria declarada; o disparo da falsificação (a) do adr-177 é o primeiro caso real do mecanismo funcionando.",
	]

	supersedes: []

	rationale: """
		Princípios: P0 (linha canônica na cotação), P10 (gate determinístico
		por linha), adr-174/177 (portão preservado, braço reexpresso),
		adr-120 (query-only), adr-176 (coevolução).

		Failure mode evitado: o do caso do caminhão rio acima — granularidade
		grossa exatamente onde a decisão acontece. Sem item, a comparação
		real (por linha) vive fora do modelo e a procedência prova uma
		agregação que ninguém decidiu.

		Relação def-087/def-088: resolução substantiva de ambos (forma do
		item + elo no nível do item); resolvedBy aponta aqui (padrão
		def-079/adr-177). def-089 (agregação) NÃO é tocado — o desenho a
		permite sem modelá-la, e a tensão com o Fracionamento continua
		registrada lá. def-091 recebe a condição de forma do saldo (N4).
		def-093 nasce aqui (a fronteira do unit ganha morada no mesmo
		commit — a lição do passe de morada aplicada no ato).

		Tensão com axiomas: nenhuma — mech-evidence reforçado: a cadeia de
		evidência deixa de mudar de granularidade no elo da decisão.

		Lenses: nenhuma com match — princípios + precedentes internos
		(adr-174/177/120/176), mesmo regime do adr-177.
		"""
}
